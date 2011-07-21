From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 29/36] md/raid10: avoid writing to known bad blocks on
 known bad drives.
Date: Thu, 21 Jul 2011 12:58:50 +1000
Message-ID: <20110721025850.8422.33853.stgit@notabene.brown>
References: <20110721024556.8422.99443.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110721024556.8422.99443.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Writing to known bad blocks on drives that have seen a write error
is asking for trouble.  So try to avoid these blocks.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid10.c |  105 +++++++++++++++++++++++++++++++++++++++++++++------
 1 files changed, 93 insertions(+), 12 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 7f11924..7dcd318 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -807,6 +807,8 @@ static int make_request(mddev_t *mddev, struct bio * bio)
 	unsigned long flags;
 	mdk_rdev_t *blocked_rdev;
 	int plugged;
+	int sectors_handled;
+	int max_sectors;
 
 	if (unlikely(bio->bi_rw & REQ_FLUSH)) {
 		md_flush_request(mddev, bio);
@@ -895,7 +897,6 @@ static int make_request(mddev_t *mddev, struct bio * bio)
 		/*
 		 * read balancing logic:
 		 */
-		int max_sectors;
 		int disk;
 		int slot;
 
@@ -925,8 +926,6 @@ read_again:
 			/* Could not read all from this device, so we will
 			 * need another r10_bio.
 			 */
-			int sectors_handled;
-
 			sectors_handled = (r10_bio->sectors + max_sectors
 					   - bio->bi_sector);
 			r10_bio->sectors = max_sectors;
@@ -963,13 +962,22 @@ read_again:
 	/* first select target devices under rcu_lock and
 	 * inc refcount on their rdev.  Record them by setting
 	 * bios[x] to bio
+	 * If there are known/acknowledged bad blocks on any device
+	 * on which we have seen a write error, we want to avoid
+	 * writing to those blocks.  This potentially requires several
+	 * writes to write around the bad blocks.  Each set of writes
+	 * gets its own r10_bio with a set of bios attached.  The number
+	 * of r10_bios is recored in bio->bi_phys_segments just as with
+	 * the read case.
 	 */
 	plugged = mddev_check_plugged(mddev);
 
 	raid10_find_phys(conf, r10_bio);
- retry_write:
+retry_write:
 	blocked_rdev = NULL;
 	rcu_read_lock();
+	max_sectors = r10_bio->sectors;
+
 	for (i = 0;  i < conf->copies; i++) {
 		int d = r10_bio->devs[i].devnum;
 		mdk_rdev_t *rdev = rcu_dereference(conf->mirrors[d].rdev);
@@ -978,13 +986,55 @@ read_again:
 			blocked_rdev = rdev;
 			break;
 		}
-		if (rdev && !test_bit(Faulty, &rdev->flags)) {
-			atomic_inc(&rdev->nr_pending);
-			r10_bio->devs[i].bio = bio;
-		} else {
-			r10_bio->devs[i].bio = NULL;
+		r10_bio->devs[i].bio = NULL;
+		if (!rdev || test_bit(Faulty, &rdev->flags)) {
 			set_bit(R10BIO_Degraded, &r10_bio->state);
+			continue;
+		}
+		if (test_bit(WriteErrorSeen, &rdev->flags)) {
+			sector_t first_bad;
+			sector_t dev_sector = r10_bio->devs[i].addr;
+			int bad_sectors;
+			int is_bad;
+
+			is_bad = is_badblock(rdev, dev_sector,
+					     max_sectors,
+					     &first_bad, &bad_sectors);
+			if (is_bad < 0) {
+				/* Mustn't write here until the bad block
+				 * is acknowledged
+				 */
+				atomic_inc(&rdev->nr_pending);
+				set_bit(BlockedBadBlocks, &rdev->flags);
+				blocked_rdev = rdev;
+				break;
+			}
+			if (is_bad && first_bad <= dev_sector) {
+				/* Cannot write here at all */
+				bad_sectors -= (dev_sector - first_bad);
+				if (bad_sectors < max_sectors)
+					/* Mustn't write more than bad_sectors
+					 * to other devices yet
+					 */
+					max_sectors = bad_sectors;
+				/* We don't set R10BIO_Degraded as that
+				 * only applies if the disk is missing,
+				 * so it might be re-added, and we want to
+				 * know to recover this chunk.
+				 * In this case the device is here, and the
+				 * fact that this chunk is not in-sync is
+				 * recorded in the bad block log.
+				 */
+				continue;
+			}
+			if (is_bad) {
+				int good_sectors = first_bad - dev_sector;
+				if (good_sectors < max_sectors)
+					max_sectors = good_sectors;
+			}
 		}
+		r10_bio->devs[i].bio = bio;
+		atomic_inc(&rdev->nr_pending);
 	}
 	rcu_read_unlock();
 
@@ -1004,8 +1054,22 @@ read_again:
 		goto retry_write;
 	}
 
+	if (max_sectors < r10_bio->sectors) {
+		/* We are splitting this into multiple parts, so
+		 * we need to prepare for allocating another r10_bio.
+		 */
+		r10_bio->sectors = max_sectors;
+		spin_lock_irq(&conf->device_lock);
+		if (bio->bi_phys_segments == 0)
+			bio->bi_phys_segments = 2;
+		else
+			bio->bi_phys_segments++;
+		spin_unlock_irq(&conf->device_lock);
+	}
+	sectors_handled = r10_bio->sector + max_sectors - bio->bi_sector;
+
 	atomic_set(&r10_bio->remaining, 1);
-	bitmap_startwrite(mddev->bitmap, bio->bi_sector, r10_bio->sectors, 0);
+	bitmap_startwrite(mddev->bitmap, r10_bio->sector, r10_bio->sectors, 0);
 
 	for (i = 0; i < conf->copies; i++) {
 		struct bio *mbio;
@@ -1014,10 +1078,12 @@ read_again:
 			continue;
 
 		mbio = bio_clone_mddev(bio, GFP_NOIO, mddev);
+		md_trim_bio(mbio, r10_bio->sector - bio->bi_sector,
+			    max_sectors);
 		r10_bio->devs[i].bio = mbio;
 
-		mbio->bi_sector	= r10_bio->devs[i].addr+
-			conf->mirrors[d].rdev->data_offset;
+		mbio->bi_sector	= (r10_bio->devs[i].addr+
+				   conf->mirrors[d].rdev->data_offset);
 		mbio->bi_bdev = conf->mirrors[d].rdev->bdev;
 		mbio->bi_end_io	= raid10_end_write_request;
 		mbio->bi_rw = WRITE | do_sync | do_fua;
@@ -1042,6 +1108,21 @@ read_again:
 	/* In case raid10d snuck in to freeze_array */
 	wake_up(&conf->wait_barrier);
 
+	if (sectors_handled < (bio->bi_size >> 9)) {
+		/* We need another r1_bio.  It has already been counted
+		 * in bio->bi_phys_segments.
+		 */
+		r10_bio = mempool_alloc(conf->r10bio_pool, GFP_NOIO);
+
+		r10_bio->master_bio = bio;
+		r10_bio->sectors = (bio->bi_size >> 9) - sectors_handled;
+
+		r10_bio->mddev = mddev;
+		r10_bio->sector = bio->bi_sector + sectors_handled;
+		r10_bio->state = 0;
+		goto retry_write;
+	}
+
 	if (do_sync || !mddev->bitmap || !plugged)
 		md_wakeup_thread(mddev->thread);
 	return 0;


