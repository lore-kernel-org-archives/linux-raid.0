From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 05/17] md/raid10: writes should get directed to replacement
 as well as original.
Date: Wed, 02 Nov 2011 16:25:44 +1100
Message-ID: <20111102052543.17566.6386.stgit@notabene.brown>
References: <20111102051851.17566.52748.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111102051851.17566.52748.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

When writing, we need to submit two writes, one to the original,
and one to the replacements - if there is a replacement.

If the write to the replacement results in a write error we just
fail the device.  We only try to record write errors to the
original.

This only handles writing new data.  Writing for resync/recovery
will come later.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid10.c |   83 +++++++++++++++++++++++++++++++++++++++++++++------
 1 files changed, 74 insertions(+), 9 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 698696b..0db0402 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -395,17 +395,29 @@ static void raid10_end_write_request(struct bio *bio, int error)
 	int dev;
 	int dec_rdev = 1;
 	struct r10conf *conf = r10_bio->mddev->private;
-	int slot;
+	int slot, repl;
+	struct md_rdev *rdev;
 
-	dev = find_bio_disk(conf, r10_bio, bio, &slot, NULL);
+	dev = find_bio_disk(conf, r10_bio, bio, &slot, &repl);
 
+	if (repl)
+		rdev = conf->mirrors[dev].replacement;
+	else
+		rdev = conf->mirrors[dev].rdev;
 	/*
 	 * this branch is our 'one mirror IO has finished' event handler:
 	 */
 	if (!uptodate) {
-		set_bit(WriteErrorSeen,	&conf->mirrors[dev].rdev->flags);
-		set_bit(R10BIO_WriteError, &r10_bio->state);
-		dec_rdev = 0;
+		if (repl)
+			/* Never record new bad blocks to replacement,
+			 * just fail it.
+			 */
+			md_error(rdev->mddev, rdev);
+		else {
+			set_bit(WriteErrorSeen,	&rdev->flags);
+			set_bit(R10BIO_WriteError, &r10_bio->state);
+			dec_rdev = 0;
+		}
 	} else {
 		/*
 		 * Set R10BIO_Uptodate in our master bio, so that
@@ -422,12 +434,15 @@ static void raid10_end_write_request(struct bio *bio, int error)
 		set_bit(R10BIO_Uptodate, &r10_bio->state);
 
 		/* Maybe we can clear some bad blocks. */
-		if (is_badblock(conf->mirrors[dev].rdev,
+		if (is_badblock(rdev,
 				r10_bio->devs[slot].addr,
 				r10_bio->sectors,
 				&first_bad, &bad_sectors)) {
 			bio_put(bio);
-			r10_bio->devs[slot].bio = IO_MADE_GOOD;
+			if (repl)
+				r10_bio->devs[slot].repl_bio = IO_MADE_GOOD;
+			else
+				r10_bio->devs[slot].bio = IO_MADE_GOOD;
 			dec_rdev = 0;
 			set_bit(R10BIO_MadeGood, &r10_bio->state);
 		}
@@ -443,7 +458,6 @@ static void raid10_end_write_request(struct bio *bio, int error)
 		rdev_dec_pending(conf->mirrors[dev].rdev, conf->mddev);
 }
 
-
 /*
  * RAID10 layout manager
  * As well as the chunksize and raid_disks count, there are two
@@ -1074,12 +1088,23 @@ retry_write:
 	for (i = 0;  i < conf->copies; i++) {
 		int d = r10_bio->devs[i].devnum;
 		struct md_rdev *rdev = rcu_dereference(conf->mirrors[d].rdev);
+		struct md_rdev *rrdev = rcu_dereference(
+			conf->mirrors[d].replacement);
 		if (rdev && unlikely(test_bit(Blocked, &rdev->flags))) {
 			atomic_inc(&rdev->nr_pending);
 			blocked_rdev = rdev;
 			break;
 		}
+		if (rrdev && unlikely(test_bit(Blocked, &rrdev->flags))) {
+			atomic_inc(&rrdev->nr_pending);
+			blocked_rdev = rrdev;
+			break;
+		}
+		if (rrdev && test_bit(Faulty, &rrdev->flags))
+			rrdev = NULL;
+
 		r10_bio->devs[i].bio = NULL;
+		r10_bio->devs[i].repl_bio = NULL;
 		if (!rdev || test_bit(Faulty, &rdev->flags)) {
 			set_bit(R10BIO_Degraded, &r10_bio->state);
 			continue;
@@ -1128,6 +1153,10 @@ retry_write:
 		}
 		r10_bio->devs[i].bio = bio;
 		atomic_inc(&rdev->nr_pending);
+		if (rrdev) {
+			r10_bio->devs[i].repl_bio = bio;
+			atomic_inc(&rrdev->nr_pending);
+		}
 	}
 	rcu_read_unlock();
 
@@ -1136,11 +1165,17 @@ retry_write:
 		int j;
 		int d;
 
-		for (j = 0; j < i; j++)
+		for (j = 0; j < i; j++) {
 			if (r10_bio->devs[j].bio) {
 				d = r10_bio->devs[j].devnum;
 				rdev_dec_pending(conf->mirrors[d].rdev, mddev);
 			}
+			if (r10_bio->devs[j].repl_bio) {
+				d = r10_bio->devs[j].devnum;
+				rdev_dec_pending(
+					conf->mirrors[d].replacement, mddev);
+			}
+		}
 		allow_barrier(conf);
 		md_wait_for_blocked_rdev(blocked_rdev, mddev);
 		wait_barrier(conf);
@@ -1187,6 +1222,27 @@ retry_write:
 		bio_list_add(&conf->pending_bio_list, mbio);
 		conf->pending_count++;
 		spin_unlock_irqrestore(&conf->device_lock, flags);
+
+		if (!r10_bio->devs[i].repl_bio)
+			continue;
+
+		mbio = bio_clone_mddev(bio, GFP_NOIO, mddev);
+		md_trim_bio(mbio, r10_bio->sector - bio->bi_sector,
+			    max_sectors);
+		r10_bio->devs[i].repl_bio = mbio;
+
+		mbio->bi_sector	= (r10_bio->devs[i].addr+
+				   conf->mirrors[d].replacement->data_offset);
+		mbio->bi_bdev = conf->mirrors[d].replacement->bdev;
+		mbio->bi_end_io	= raid10_end_write_request;
+		mbio->bi_rw = WRITE | do_sync | do_fua;
+		mbio->bi_private = r10_bio;
+
+		atomic_inc(&r10_bio->remaining);
+		spin_lock_irqsave(&conf->device_lock, flags);
+		bio_list_add(&conf->pending_bio_list, mbio);
+		conf->pending_count++;
+		spin_unlock_irqrestore(&conf->device_lock, flags);
 	}
 
 	/* Don't remove the bias on 'remaining' (one_write_done) until
@@ -2255,6 +2311,15 @@ static void handle_write_completed(struct r10conf *conf, struct r10bio *r10_bio)
 				}
 				rdev_dec_pending(rdev, conf->mddev);
 			}
+			bio = r10_bio->devs[m].repl_bio;
+			rdev = conf->mirrors[dev].replacement;
+			if (bio == IO_MADE_GOOD) {
+				rdev_clear_badblocks(
+					rdev,
+					r10_bio->devs[m].addr,
+					r10_bio->sectors);
+				rdev_dec_pending(rdev, conf->mddev);
+			}
 		}
 		if (test_bit(R10BIO_WriteError,
 			     &r10_bio->state))


