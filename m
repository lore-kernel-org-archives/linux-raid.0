From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 16/36] md/raid1: factor several functions out or raid1d()
Date: Thu, 21 Jul 2011 12:58:49 +1000
Message-ID: <20110721025849.8422.88896.stgit@notabene.brown>
References: <20110721024556.8422.99443.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110721024556.8422.99443.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

raid1d is too big with several deep branches.
So separate them out into their own functions.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid1.c |  318 ++++++++++++++++++++++++++--------------------------
 1 files changed, 159 insertions(+), 159 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 08ff21a..d7518dc 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1862,21 +1862,168 @@ static int narrow_write_error(r1bio_t *r1_bio, int i)
 	return ok;
 }
 
+static void handle_sync_write_finished(conf_t *conf, r1bio_t *r1_bio)
+{
+	int m;
+	int s = r1_bio->sectors;
+	for (m = 0; m < conf->raid_disks ; m++) {
+		mdk_rdev_t *rdev = conf->mirrors[m].rdev;
+		struct bio *bio = r1_bio->bios[m];
+		if (bio->bi_end_io == NULL)
+			continue;
+		if (test_bit(BIO_UPTODATE, &bio->bi_flags) &&
+		    test_bit(R1BIO_MadeGood, &r1_bio->state)) {
+			rdev_clear_badblocks(rdev,
+					     r1_bio->sector,
+					     r1_bio->sectors);
+		}
+		if (!test_bit(BIO_UPTODATE, &bio->bi_flags) &&
+		    test_bit(R1BIO_WriteError, &r1_bio->state)) {
+			if (!rdev_set_badblocks(rdev,
+						r1_bio->sector,
+						r1_bio->sectors, 0))
+				md_error(conf->mddev, rdev);
+		}
+	}
+	put_buf(r1_bio);
+	md_done_sync(conf->mddev, s, 1);
+}
+
+static void handle_write_finished(conf_t *conf, r1bio_t *r1_bio)
+{
+	int m;
+	for (m = 0; m < conf->raid_disks ; m++)
+		if (r1_bio->bios[m] == IO_MADE_GOOD) {
+			mdk_rdev_t *rdev = conf->mirrors[m].rdev;
+			rdev_clear_badblocks(rdev,
+					     r1_bio->sector,
+					     r1_bio->sectors);
+			rdev_dec_pending(rdev, conf->mddev);
+		} else if (r1_bio->bios[m] != NULL) {
+			/* This drive got a write error.  We need to
+			 * narrow down and record precise write
+			 * errors.
+			 */
+			if (!narrow_write_error(r1_bio, m)) {
+				md_error(conf->mddev,
+					 conf->mirrors[m].rdev);
+				/* an I/O failed, we can't clear the bitmap */
+				set_bit(R1BIO_Degraded, &r1_bio->state);
+			}
+			rdev_dec_pending(conf->mirrors[m].rdev,
+					 conf->mddev);
+		}
+	if (test_bit(R1BIO_WriteError, &r1_bio->state))
+		close_write(r1_bio);
+	raid_end_bio_io(r1_bio);
+}
+
+static void handle_read_error(conf_t *conf, r1bio_t *r1_bio)
+{
+	int disk;
+	int max_sectors;
+	mddev_t *mddev = conf->mddev;
+	struct bio *bio;
+	char b[BDEVNAME_SIZE];
+	mdk_rdev_t *rdev;
+
+	clear_bit(R1BIO_ReadError, &r1_bio->state);
+	/* we got a read error. Maybe the drive is bad.  Maybe just
+	 * the block and we can fix it.
+	 * We freeze all other IO, and try reading the block from
+	 * other devices.  When we find one, we re-write
+	 * and check it that fixes the read error.
+	 * This is all done synchronously while the array is
+	 * frozen
+	 */
+	if (mddev->ro == 0) {
+		freeze_array(conf);
+		fix_read_error(conf, r1_bio->read_disk,
+			       r1_bio->sector,
+			       r1_bio->sectors);
+		unfreeze_array(conf);
+	} else
+		md_error(mddev,
+			 conf->mirrors[r1_bio->read_disk].rdev);
+
+	bio = r1_bio->bios[r1_bio->read_disk];
+	bdevname(bio->bi_bdev, b);
+read_more:
+	disk = read_balance(conf, r1_bio, &max_sectors);
+	if (disk == -1) {
+		printk(KERN_ALERT "md/raid1:%s: %s: unrecoverable I/O"
+		       " read error for block %llu\n",
+		       mdname(mddev), b,
+		       (unsigned long long)r1_bio->sector);
+		raid_end_bio_io(r1_bio);
+	} else {
+		const unsigned long do_sync
+			= r1_bio->master_bio->bi_rw & REQ_SYNC;
+		if (bio) {
+			r1_bio->bios[r1_bio->read_disk] =
+				mddev->ro ? IO_BLOCKED : NULL;
+			bio_put(bio);
+		}
+		r1_bio->read_disk = disk;
+		bio = bio_clone_mddev(r1_bio->master_bio, GFP_NOIO, mddev);
+		md_trim_bio(bio,
+			    r1_bio->sector - bio->bi_sector,
+			    max_sectors);
+		r1_bio->bios[r1_bio->read_disk] = bio;
+		rdev = conf->mirrors[disk].rdev;
+		printk_ratelimited(KERN_ERR
+				   "md/raid1:%s: redirecting sector %llu"
+				   " to other mirror: %s\n",
+				   mdname(mddev),
+				   (unsigned long long)r1_bio->sector,
+				   bdevname(rdev->bdev, b));
+		bio->bi_sector = r1_bio->sector + rdev->data_offset;
+		bio->bi_bdev = rdev->bdev;
+		bio->bi_end_io = raid1_end_read_request;
+		bio->bi_rw = READ | do_sync;
+		bio->bi_private = r1_bio;
+		if (max_sectors < r1_bio->sectors) {
+			/* Drat - have to split this up more */
+			struct bio *mbio = r1_bio->master_bio;
+			int sectors_handled = (r1_bio->sector + max_sectors
+					       - mbio->bi_sector);
+			r1_bio->sectors = max_sectors;
+			spin_lock_irq(&conf->device_lock);
+			if (mbio->bi_phys_segments == 0)
+				mbio->bi_phys_segments = 2;
+			else
+				mbio->bi_phys_segments++;
+			spin_unlock_irq(&conf->device_lock);
+			generic_make_request(bio);
+			bio = NULL;
+
+			r1_bio = mempool_alloc(conf->r1bio_pool, GFP_NOIO);
+
+			r1_bio->master_bio = mbio;
+			r1_bio->sectors = (mbio->bi_size >> 9) - sectors_handled;
+			r1_bio->state = 0;
+			set_bit(R1BIO_ReadError, &r1_bio->state);
+			r1_bio->mddev = mddev;
+			r1_bio->sector = mbio->bi_sector + sectors_handled;
+
+			goto read_more;
+		} else
+			generic_make_request(bio);
+	}
+}
+
 static void raid1d(mddev_t *mddev)
 {
 	r1bio_t *r1_bio;
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
 
 		if (atomic_read(&mddev->plug_cnt) == 0)
 			flush_pending_writes(conf);
@@ -1895,168 +2042,21 @@ static void raid1d(mddev_t *mddev)
 		conf = mddev->private;
 		if (test_bit(R1BIO_IsSync, &r1_bio->state)) {
 			if (test_bit(R1BIO_MadeGood, &r1_bio->state) ||
-			    test_bit(R1BIO_WriteError, &r1_bio->state)) {
-				int m;
-				int s = r1_bio->sectors;
-				for (m = 0; m < conf->raid_disks ; m++) {
-					mdk_rdev_t *rdev
-						= conf->mirrors[m].rdev;
-					struct bio *bio = r1_bio->bios[m];
-					if (bio->bi_end_io == NULL)
-						continue;
-					if (test_bit(BIO_UPTODATE,
-						     &bio->bi_flags) &&
-					    test_bit(R1BIO_MadeGood,
-						     &r1_bio->state)) {
-						rdev_clear_badblocks(
-							rdev,
-							r1_bio->sector,
-							r1_bio->sectors);
-					}
-					if (!test_bit(BIO_UPTODATE,
-						      &bio->bi_flags) &&
-					    test_bit(R1BIO_WriteError,
-						     &r1_bio->state)) {
-						if (!rdev_set_badblocks(
-							    rdev,
-							    r1_bio->sector,
-							    r1_bio->sectors, 0))
-							md_error(mddev, rdev);
-					}
-				}
-				put_buf(r1_bio);
-				md_done_sync(mddev, s, 1);
-			} else
+			    test_bit(R1BIO_WriteError, &r1_bio->state))
+				handle_sync_write_finished(conf, r1_bio);
+			else
 				sync_request_write(mddev, r1_bio);
 		} else if (test_bit(R1BIO_MadeGood, &r1_bio->state) ||
-			   test_bit(R1BIO_WriteError, &r1_bio->state)) {
-			int m;
-			for (m = 0; m < conf->raid_disks ; m++)
-				if (r1_bio->bios[m] == IO_MADE_GOOD) {
-					rdev = conf->mirrors[m].rdev;
-					rdev_clear_badblocks(
-						rdev,
-						r1_bio->sector,
-						r1_bio->sectors);
-					rdev_dec_pending(rdev, mddev);
-				} else if (r1_bio->bios[m] != NULL) {
-					/* This drive got a write error.  We
-					 * need to narrow down and record
-					 * precise write errors.
-					 */
-					if (!narrow_write_error(r1_bio, m)) {
-						md_error(mddev,
-							 conf->mirrors[m].rdev);
-						/* an I/O failed, we can't clear
-						 * the bitmap */
-						set_bit(R1BIO_Degraded,
-							&r1_bio->state);
-					}
-					rdev_dec_pending(conf->mirrors[m].rdev,
-							 mddev);
-				}
-			if (test_bit(R1BIO_WriteError, &r1_bio->state))
-				close_write(r1_bio);
-			raid_end_bio_io(r1_bio);
-		} else if (test_bit(R1BIO_ReadError, &r1_bio->state)) {
-			int disk;
-			int max_sectors;
-
-			clear_bit(R1BIO_ReadError, &r1_bio->state);
-			/* we got a read error. Maybe the drive is bad.  Maybe just
-			 * the block and we can fix it.
-			 * We freeze all other IO, and try reading the block from
-			 * other devices.  When we find one, we re-write
-			 * and check it that fixes the read error.
-			 * This is all done synchronously while the array is
-			 * frozen
-			 */
-			if (mddev->ro == 0) {
-				freeze_array(conf);
-				fix_read_error(conf, r1_bio->read_disk,
-					       r1_bio->sector,
-					       r1_bio->sectors);
-				unfreeze_array(conf);
-			} else
-				md_error(mddev,
-					 conf->mirrors[r1_bio->read_disk].rdev);
-
-			bio = r1_bio->bios[r1_bio->read_disk];
-			bdevname(bio->bi_bdev, b);
-read_more:
-			disk = read_balance(conf, r1_bio, &max_sectors);
-			if (disk == -1) {
-				printk(KERN_ALERT "md/raid1:%s: %s: unrecoverable I/O"
-				       " read error for block %llu\n",
-				       mdname(mddev), b,
-				       (unsigned long long)r1_bio->sector);
-				raid_end_bio_io(r1_bio);
-			} else {
-				const unsigned long do_sync = r1_bio->master_bio->bi_rw & REQ_SYNC;
-				if (bio) {
-					r1_bio->bios[r1_bio->read_disk] =
-						mddev->ro ? IO_BLOCKED : NULL;
-					bio_put(bio);
-				}
-				r1_bio->read_disk = disk;
-				bio = bio_clone_mddev(r1_bio->master_bio,
-						      GFP_NOIO, mddev);
-				md_trim_bio(bio,
-					    r1_bio->sector - bio->bi_sector,
-					    max_sectors);
-				r1_bio->bios[r1_bio->read_disk] = bio;
-				rdev = conf->mirrors[disk].rdev;
-				printk_ratelimited(
-					KERN_ERR
-					"md/raid1:%s: redirecting sector %llu"
-					" to other mirror: %s\n",
-					mdname(mddev),
-					(unsigned long long)r1_bio->sector,
-					bdevname(rdev->bdev, b));
-				bio->bi_sector = r1_bio->sector + rdev->data_offset;
-				bio->bi_bdev = rdev->bdev;
-				bio->bi_end_io = raid1_end_read_request;
-				bio->bi_rw = READ | do_sync;
-				bio->bi_private = r1_bio;
-				if (max_sectors < r1_bio->sectors) {
-					/* Drat - have to split this up more */
-					struct bio *mbio = r1_bio->master_bio;
-					int sectors_handled =
-						r1_bio->sector + max_sectors
-						- mbio->bi_sector;
-					r1_bio->sectors = max_sectors;
-					spin_lock_irq(&conf->device_lock);
-					if (mbio->bi_phys_segments == 0)
-						mbio->bi_phys_segments = 2;
-					else
-						mbio->bi_phys_segments++;
-					spin_unlock_irq(&conf->device_lock);
-					generic_make_request(bio);
-					bio = NULL;
-
-					r1_bio = mempool_alloc(conf->r1bio_pool,
-							       GFP_NOIO);
-
-					r1_bio->master_bio = mbio;
-					r1_bio->sectors = (mbio->bi_size >> 9)
-						- sectors_handled;
-					r1_bio->state = 0;
-					set_bit(R1BIO_ReadError,
-						&r1_bio->state);
-					r1_bio->mddev = mddev;
-					r1_bio->sector = mbio->bi_sector
-						+ sectors_handled;
-
-					goto read_more;
-				} else
-					generic_make_request(bio);
-			}
-		} else {
+			   test_bit(R1BIO_WriteError, &r1_bio->state))
+			handle_write_finished(conf, r1_bio);
+		else if (test_bit(R1BIO_ReadError, &r1_bio->state))
+			handle_read_error(conf, r1_bio);
+		else
 			/* just a partial read to be scheduled from separate
 			 * context
 			 */
 			generic_make_request(r1_bio->bios[r1_bio->read_disk]);
-		}
+
 		cond_resched();
 		if (mddev->flags & ~(1<<MD_CHANGE_PENDING))
 			md_check_recovery(mddev);


