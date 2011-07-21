From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 23/36] md/raid10: Split handle_read_error out from raid10d.
Date: Thu, 21 Jul 2011 12:58:49 +1000
Message-ID: <20110721025849.8422.62271.stgit@notabene.brown>
References: <20110721024556.8422.99443.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110721024556.8422.99443.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

raid10d() is too big and is about to get bigger, so split
handle_read_error() out as a separate function.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid10.c |  123 +++++++++++++++++++++++++++------------------------
 1 files changed, 66 insertions(+), 57 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index c489b5c..f1b749c 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1618,21 +1618,81 @@ static void fix_read_error(conf_t *conf, mddev_t *mddev, r10bio_t *r10_bio)
 	}
 }
 
+static void handle_read_error(mddev_t *mddev, r10bio_t *r10_bio)
+{
+	int slot = r10_bio->read_slot;
+	int mirror = r10_bio->devs[slot].devnum;
+	struct bio *bio;
+	conf_t *conf = mddev->private;
+	mdk_rdev_t *rdev;
+	char b[BDEVNAME_SIZE];
+	unsigned long do_sync;
+
+	/* we got a read error. Maybe the drive is bad.  Maybe just
+	 * the block and we can fix it.
+	 * We freeze all other IO, and try reading the block from
+	 * other devices.  When we find one, we re-write
+	 * and check it that fixes the read error.
+	 * This is all done synchronously while the array is
+	 * frozen.
+	 */
+	if (mddev->ro == 0) {
+		freeze_array(conf);
+		fix_read_error(conf, mddev, r10_bio);
+		unfreeze_array(conf);
+	}
+	rdev_dec_pending(conf->mirrors[mirror].rdev, mddev);
+
+	bio = r10_bio->devs[slot].bio;
+	r10_bio->devs[slot].bio =
+		mddev->ro ? IO_BLOCKED : NULL;
+	mirror = read_balance(conf, r10_bio);
+	if (mirror == -1) {
+		printk(KERN_ALERT "md/raid10:%s: %s: unrecoverable I/O"
+		       " read error for block %llu\n",
+		       mdname(mddev),
+		       bdevname(bio->bi_bdev, b),
+		       (unsigned long long)r10_bio->sector);
+		raid_end_bio_io(r10_bio);
+		bio_put(bio);
+		return;
+	}
+
+	do_sync = (r10_bio->master_bio->bi_rw & REQ_SYNC);
+	bio_put(bio);
+	slot = r10_bio->read_slot;
+	rdev = conf->mirrors[mirror].rdev;
+	printk_ratelimited(
+		KERN_ERR
+		"md/raid10:%s: %s: redirecting"
+		"sector %llu to another mirror\n",
+		mdname(mddev),
+		bdevname(rdev->bdev, b),
+		(unsigned long long)r10_bio->sector);
+	bio = bio_clone_mddev(r10_bio->master_bio,
+			      GFP_NOIO, mddev);
+	r10_bio->devs[slot].bio = bio;
+	bio->bi_sector = r10_bio->devs[slot].addr
+		+ rdev->data_offset;
+	bio->bi_bdev = rdev->bdev;
+	bio->bi_rw = READ | do_sync;
+	bio->bi_private = r10_bio;
+	bio->bi_end_io = raid10_end_read_request;
+	generic_make_request(bio);
+}
+
 static void raid10d(mddev_t *mddev)
 {
 	r10bio_t *r10_bio;
-	struct bio *bio;
 	unsigned long flags;
 	conf_t *conf = mddev->private;
 	struct list_head *head = &conf->retry_list;
-	mdk_rdev_t *rdev;
 	struct blk_plug plug;
 
 	md_check_recovery(mddev);
 
 	blk_start_plug(&plug);
 	for (;;) {
-		char b[BDEVNAME_SIZE];
 
 		flush_pending_writes(conf);
 
@@ -1652,60 +1712,9 @@ static void raid10d(mddev_t *mddev)
 			sync_request_write(mddev, r10_bio);
 		else if (test_bit(R10BIO_IsRecover, &r10_bio->state))
 			recovery_request_write(mddev, r10_bio);
-		else {
-			int slot = r10_bio->read_slot;
-			int mirror = r10_bio->devs[slot].devnum;
-			/* we got a read error. Maybe the drive is bad.  Maybe just
-			 * the block and we can fix it.
-			 * We freeze all other IO, and try reading the block from
-			 * other devices.  When we find one, we re-write
-			 * and check it that fixes the read error.
-			 * This is all done synchronously while the array is
-			 * frozen.
-			 */
-			if (mddev->ro == 0) {
-				freeze_array(conf);
-				fix_read_error(conf, mddev, r10_bio);
-				unfreeze_array(conf);
-			}
-			rdev_dec_pending(conf->mirrors[mirror].rdev, mddev);
-
-			bio = r10_bio->devs[slot].bio;
-			r10_bio->devs[slot].bio =
-				mddev->ro ? IO_BLOCKED : NULL;
-			mirror = read_balance(conf, r10_bio);
-			if (mirror == -1) {
-				printk(KERN_ALERT "md/raid10:%s: %s: unrecoverable I/O"
-				       " read error for block %llu\n",
-				       mdname(mddev),
-				       bdevname(bio->bi_bdev,b),
-				       (unsigned long long)r10_bio->sector);
-				raid_end_bio_io(r10_bio);
-				bio_put(bio);
-			} else {
-				const unsigned long do_sync = (r10_bio->master_bio->bi_rw & REQ_SYNC);
-				bio_put(bio);
-				slot = r10_bio->read_slot;
-				rdev = conf->mirrors[mirror].rdev;
-				printk_ratelimited(
-					KERN_ERR
-					"md/raid10:%s: %s: redirecting"
-					"sector %llu to another mirror\n",
-					mdname(mddev),
-					bdevname(rdev->bdev, b),
-					(unsigned long long)r10_bio->sector);
-				bio = bio_clone_mddev(r10_bio->master_bio,
-						      GFP_NOIO, mddev);
-				r10_bio->devs[slot].bio = bio;
-				bio->bi_sector = r10_bio->devs[slot].addr
-					+ rdev->data_offset;
-				bio->bi_bdev = rdev->bdev;
-				bio->bi_rw = READ | do_sync;
-				bio->bi_private = r10_bio;
-				bio->bi_end_io = raid10_end_read_request;
-				generic_make_request(bio);
-			}
-		}
+		else
+			handle_read_error(mddev, r10_bio);
+
 		cond_resched();
 		if (mddev->flags & ~(1<<MD_CHANGE_PENDING))
 			md_check_recovery(mddev);


