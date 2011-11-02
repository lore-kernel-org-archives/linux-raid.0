From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 06/17] md/raid10: Handle replacement devices during resync.
Date: Wed, 02 Nov 2011 16:25:44 +1100
Message-ID: <20111102052544.17566.72926.stgit@notabene.brown>
References: <20111102051851.17566.52748.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111102051851.17566.52748.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

If we need to resync an array which has replacement devices,
we always write any block checked to every replacement.

If the resync was bitmap-based resync we will then complete the
replacement normally.
If it was a full resync, we mark the replacements as fully recovered
when the resync finishes so no further recovery is needed.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid10.c |  105 ++++++++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 98 insertions(+), 7 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 0db0402..a2341ca 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1596,19 +1596,29 @@ static void end_sync_write(struct bio *bio, int error)
 	sector_t first_bad;
 	int bad_sectors;
 	int slot;
+	int repl;
+	struct md_rdev *rdev;
 
-	d = find_bio_disk(conf, r10_bio, bio, &slot, NULL);
+	d = find_bio_disk(conf, r10_bio, bio, &slot, &repl);
+	if (repl)
+		rdev = conf->mirrors[d].replacement;
+	else
+		rdev = conf->mirrors[d].rdev;
 
 	if (!uptodate) {
-		set_bit(WriteErrorSeen, &conf->mirrors[d].rdev->flags);
-		set_bit(R10BIO_WriteError, &r10_bio->state);
-	} else if (is_badblock(conf->mirrors[d].rdev,
+		if (repl)
+			md_error(mddev, rdev);
+		else {
+			set_bit(WriteErrorSeen, &rdev->flags);
+			set_bit(R10BIO_WriteError, &r10_bio->state);
+		}
+	} else if (is_badblock(rdev,
 			     r10_bio->devs[slot].addr,
 			     r10_bio->sectors,
 			     &first_bad, &bad_sectors))
 		set_bit(R10BIO_MadeGood, &r10_bio->state);
 
-	rdev_dec_pending(conf->mirrors[d].rdev, mddev);
+	rdev_dec_pending(rdev, mddev);
 
 	end_sync_request(r10_bio);
 }
@@ -1712,6 +1722,29 @@ static void sync_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 		generic_make_request(tbio);
 	}
 
+	/* Now write out to any replacement devices
+	 * that are active
+	 */
+	for (i = 0; i < conf->copies; i++) {
+		int j, d;
+		int vcnt = r10_bio->sectors >> (PAGE_SHIFT-9);
+
+		tbio = r10_bio->devs[i].repl_bio;
+		if (!tbio || !tbio->bi_end_io)
+			continue;
+		if (r10_bio->devs[i].bio->bi_end_io != end_sync_write
+		    && r10_bio->devs[i].bio != fbio)
+			for (j = 0; j < vcnt; j++)
+				memcpy(page_address(tbio->bi_io_vec[j].bv_page),
+				       page_address(fbio->bi_io_vec[j].bv_page),
+				       PAGE_SIZE);
+		d = r10_bio->devs[i].devnum;
+		atomic_inc(&r10_bio->remaining);
+		md_sync_acct(conf->mirrors[d].replacement->bdev,
+			     tbio->bi_size >> 9);
+		generic_make_request(tbio);
+	}
+
 done:
 	if (atomic_dec_and_test(&r10_bio->remaining)) {
 		md_done_sync(mddev, r10_bio->sectors, 1);
@@ -2289,6 +2322,22 @@ static void handle_write_completed(struct r10conf *conf, struct r10bio *r10_bio)
 					    r10_bio->sectors, 0))
 					md_error(conf->mddev, rdev);
 			}
+			rdev = conf->mirrors[dev].replacement;
+			if (r10_bio->devs[m].repl_bio == NULL)
+				continue;
+			if (test_bit(BIO_UPTODATE,
+				     &r10_bio->devs[m].repl_bio->bi_flags)) {
+				rdev_clear_badblocks(
+					rdev,
+					r10_bio->devs[m].addr,
+					r10_bio->sectors);
+			} else {
+				if (!rdev_set_badblocks(
+					    rdev,
+					    r10_bio->devs[m].addr,
+					    r10_bio->sectors, 0))
+					md_error(conf->mddev, rdev);
+			}
 		}
 		put_buf(r10_bio);
 	} else {
@@ -2471,9 +2520,22 @@ static sector_t sync_request(struct mddev *mddev, sector_t sector_nr,
 				bitmap_end_sync(mddev->bitmap, sect,
 						&sync_blocks, 1);
 			}
-		} else /* completed sync */
+		} else {
+			/* completed sync */
+			if ((!mddev->bitmap || conf->fullsync)
+			    && conf->have_replacement
+			    && test_bit(MD_RECOVERY_SYNC, &mddev->recovery)) {
+				/* Completed a full sync so the replacements
+				 * are now fully recovered.
+				 */
+				for (i = 0; i < conf->raid_disks; i++)
+					if (conf->mirrors[i].replacement)
+						conf->mirrors[i].replacement
+							->recovery_offset
+							= MaxSector;
+			}
 			conf->fullsync = 0;
-
+		}
 		bitmap_close_sync(mddev->bitmap);
 		close_sync(conf);
 		*skipped = 1;
@@ -2721,6 +2783,9 @@ static sector_t sync_request(struct mddev *mddev, sector_t sector_nr,
 			sector_t first_bad, sector;
 			int bad_sectors;
 
+			if (r10_bio->devs[i].repl_bio)
+				r10_bio->devs[i].repl_bio->bi_end_io = NULL;
+
 			bio = r10_bio->devs[i].bio;
 			bio->bi_end_io = NULL;
 			clear_bit(BIO_UPTODATE, &bio->bi_flags);
@@ -2751,6 +2816,27 @@ static sector_t sync_request(struct mddev *mddev, sector_t sector_nr,
 				conf->mirrors[d].rdev->data_offset;
 			bio->bi_bdev = conf->mirrors[d].rdev->bdev;
 			count++;
+
+			if (conf->mirrors[d].replacement == NULL ||
+			    test_bit(Faulty,
+				     &conf->mirrors[d].replacement->flags))
+				continue;
+
+			/* Need to set up for writing to the replacement */
+			bio = r10_bio->devs[i].repl_bio;
+			clear_bit(BIO_UPTODATE, &bio->bi_flags);
+
+			sector = r10_bio->devs[i].addr;
+			atomic_inc(&conf->mirrors[d].rdev->nr_pending);
+			bio->bi_next = biolist;
+			biolist = bio;
+			bio->bi_private = r10_bio;
+			bio->bi_end_io = end_sync_write;
+			bio->bi_rw = WRITE;
+			bio->bi_sector = sector +
+				conf->mirrors[d].replacement->data_offset;
+			bio->bi_bdev = conf->mirrors[d].replacement->bdev;
+			count++;
 		}
 
 		if (count < 2) {
@@ -2759,6 +2845,11 @@ static sector_t sync_request(struct mddev *mddev, sector_t sector_nr,
 				if (r10_bio->devs[i].bio->bi_end_io)
 					rdev_dec_pending(conf->mirrors[d].rdev,
 							 mddev);
+				if (r10_bio->devs[i].repl_bio &&
+				    r10_bio->devs[i].repl_bio->bi_end_io)
+					rdev_dec_pending(
+						conf->mirrors[d].replacement,
+						mddev);
 			}
 			put_buf(r10_bio);
 			biolist = NULL;


