From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 14/16] md/raid1: avoid writing to known-bad blocks on
	known-bad drives.
Date: Mon, 07 Jun 2010 10:07:56 +1000
Message-ID: <20100607000756.13302.74584.stgit@notabene.brown>
References: <20100606235833.13302.60932.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100606235833.13302.60932.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

If we have seen any write error on a drive, then don't write to
any known-bad blocks on that drive.
If necessary, we divide the write request up into pieces just
like we do for reads, so each piece is either all written or
all not written to any given drive.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/raid1.c |  147 ++++++++++++++++++++++++++++++++++++++++------------
 1 files changed, 112 insertions(+), 35 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index bb81681..d240d58 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -838,11 +838,14 @@ static int make_request(mddev_t *mddev, struct bio * bio)
 	struct bitmap *bitmap;
 	unsigned long flags;
 	struct bio_list bl;
-	struct page **behind_pages = NULL;
+	struct page **behind_pages;
 	const int rw = bio_data_dir(bio);
 	const bool do_sync = bio_rw_flagged(bio, BIO_RW_SYNCIO);
 	bool do_barriers;
 	mdk_rdev_t *blocked_rdev;
+	int first_clone;
+	int sectors_handled;
+	int max_sectors;
 
 	/*
 	 * Register the new request and wait if the reconstruction
@@ -914,7 +917,6 @@ static int make_request(mddev_t *mddev, struct bio * bio)
 		/*
 		 * read balancing logic:
 		 */
-		int max_sectors;
 		int rdisk;
 
 	read_again:
@@ -954,7 +956,6 @@ static int make_request(mddev_t *mddev, struct bio * bio)
 			/* could not read all from this device, so we will
 			 * need another r1_bio.
 			 */
-			int sectors_handled;
 
 			sectors_handled = (r1_bio->sector + max_sectors
 					   - bio->bi_sector);
@@ -983,9 +984,15 @@ static int make_request(mddev_t *mddev, struct bio * bio)
 	/*
 	 * WRITE:
 	 */
-	/* first select target devices under spinlock and
+	/* first select target devices under rcu_lock and
 	 * inc refcount on their rdev.  Record them by setting
 	 * bios[x] to bio
+	 * If there are known/acknowledged bad blocks on any device on
+	 * which we have seen a write error, we want to avoid writing those
+	 * blocks.
+	 * This potentially requires several writes to write around
+	 * the bad blocks.  We do those serially using the same
+	 * bio which we repeatedly trim to size.
 	 */
 	disks = conf->raid_disks;
 #if 0
@@ -998,6 +1005,7 @@ static int make_request(mddev_t *mddev, struct bio * bio)
  retry_write:
 	blocked_rdev = NULL;
 	rcu_read_lock();
+	max_sectors = r1_bio->sectors;
 	for (i = 0;  i < disks; i++) {
 		mdk_rdev_t *rdev = rcu_dereference(conf->mirrors[i].rdev);
 		if (rdev && unlikely(test_bit(Blocked, &rdev->flags))) {
@@ -1005,17 +1013,55 @@ static int make_request(mddev_t *mddev, struct bio * bio)
 			blocked_rdev = rdev;
 			break;
 		}
-		if (rdev && !test_bit(Faulty, &rdev->flags)) {
-			atomic_inc(&rdev->nr_pending);
-			if (test_bit(Faulty, &rdev->flags)) {
+		r1_bio->bios[i] = NULL;
+		if (!rdev || test_bit(Faulty, &rdev->flags)) {
+			set_bit(R1BIO_Degraded, &r1_bio->state);
+			continue;
+		}
+
+		atomic_inc(&rdev->nr_pending);
+		if (test_bit(Faulty, &rdev->flags)) {
+			rdev_dec_pending(rdev, mddev);
+			set_bit(R1BIO_Degraded, &r1_bio->state);
+			continue;
+		}
+		if (test_bit(WriteErrorSeen, &rdev->flags)) {
+			sector_t first_bad;
+			int bad_sectors, good_sectors;
+
+			if (is_badblock(rdev, r1_bio->sector,
+					max_sectors,
+					&first_bad, &bad_sectors) < 0) {
+
+				/* mustn't write here until the bad block is
+				 * acknowledged*/
+				blocked_rdev = rdev;
+				break;
+			}
+			if (first_bad <= r1_bio->sector) {
+				/* Cannot write here at all */
+				bad_sectors -= (r1_bio->sector - first_bad);
+				if (bad_sectors < max_sectors)
+					/* mustn't write more than bad_sectors
+					 * to other devices yet
+					 */
+					max_sectors = bad_sectors;
 				rdev_dec_pending(rdev, mddev);
-				r1_bio->bios[i] = NULL;
-			} else {
-				r1_bio->bios[i] = bio;
-				targets++;
+				/* We don't set R1BIO_Degraded as that only applies
+				 * if the disk is missing, so it might be re-added,
+				 * and we want to know to recovery this chunk.
+				 * In this case the device is here, and the fact that
+				 * this chunk is no in-sync is recorded in the
+				 * bad block log
+				 */
+				continue;
 			}
-		} else
-			r1_bio->bios[i] = NULL;
+			good_sectors = first_bad - r1_bio->sector;
+			if (good_sectors < max_sectors)
+				max_sectors = good_sectors;
+		}
+		r1_bio->bios[i] = bio;
+		targets++;
 	}
 	rcu_read_unlock();
 
@@ -1035,22 +1081,26 @@ static int make_request(mddev_t *mddev, struct bio * bio)
 
 	BUG_ON(targets == 0); /* we never fail the last device */
 
+	if (max_sectors < r1_bio->sectors) {
+		/* We are splitting this write into multiple parts, so
+		 * we need to prepare for allocating another r1_bio.
+		 */
+		r1_bio->sectors = max_sectors;
+		spin_lock_irq(&conf->device_lock);
+		if (bio->bi_phys_segments == 0)
+			bio->bi_phys_segments = 2;
+		else
+			bio->bi_phys_segments++;
+		spin_unlock_irq(&conf->device_lock);
+	}
+	sectors_handled = r1_bio->sector + max_sectors - bio->bi_sector;
+
 	if (targets < conf->raid_disks) {
 		/* array is degraded, we will not clear the bitmap
 		 * on I/O completion (see raid1_end_write_request) */
 		set_bit(R1BIO_Degraded, &r1_bio->state);
 	}
 
-	/* do behind I/O ?
-	 * Not if there are too many, or cannot allocate memory,
-	 * or a reader on WriteMostly is waiting for behind writes 
-	 * to flush */
-	if (bitmap &&
-	    (atomic_read(&bitmap->behind_writes)
-	     < mddev->bitmap_info.max_write_behind) &&
-	    !waitqueue_active(&bitmap->behind_wait) &&
-	    (behind_pages = alloc_behind_pages(bio)) != NULL)
-		set_bit(R1BIO_BehindIO, &r1_bio->state);
 
 	atomic_set(&r1_bio->remaining, 0);
 	atomic_set(&r1_bio->behind_remaining, 0);
@@ -1060,21 +1110,28 @@ static int make_request(mddev_t *mddev, struct bio * bio)
 		set_bit(R1BIO_Barrier, &r1_bio->state);
 
 	bio_list_init(&bl);
+	first_clone = 1;
+	behind_pages = NULL;
 	for (i = 0; i < disks; i++) {
 		struct bio *mbio;
 		if (!r1_bio->bios[i])
 			continue;
 
 		mbio = bio_clone(bio, GFP_NOIO);
-		r1_bio->bios[i] = mbio;
-
-		mbio->bi_sector	= r1_bio->sector + conf->mirrors[i].rdev->data_offset;
-		mbio->bi_bdev = conf->mirrors[i].rdev->bdev;
-		mbio->bi_end_io	= raid1_end_write_request;
-		mbio->bi_rw = WRITE | (do_barriers << BIO_RW_BARRIER) |
-			(do_sync << BIO_RW_SYNCIO);
-		mbio->bi_private = r1_bio;
 
+		if (first_clone) {
+			/* do behind I/O ?
+			 * Not if there are too many, or cannot
+			 * allocate memory, or a reader on WriteMostly
+			 * is waiting for behind writes to flush */
+			if (bitmap &&
+			    (atomic_read(&bitmap->behind_writes)
+			     < mddev->bitmap_info.max_write_behind) &&
+			    !waitqueue_active(&bitmap->behind_wait) &&
+			    (behind_pages = alloc_behind_pages(mbio)) != NULL)
+				set_bit(R1BIO_BehindIO, &r1_bio->state);
+			first_clone = 0;
+		}
 		if (behind_pages) {
 			struct bio_vec *bvec;
 			int j;
@@ -1092,6 +1149,17 @@ static int make_request(mddev_t *mddev, struct bio * bio)
 				atomic_inc(&r1_bio->behind_remaining);
 		}
 
+		trim_bio(mbio, r1_bio->sector - bio->bi_sector, max_sectors);
+		r1_bio->bios[i] = mbio;
+
+		mbio->bi_sector	= (r1_bio->sector +
+				   conf->mirrors[i].rdev->data_offset);
+		mbio->bi_bdev = conf->mirrors[i].rdev->bdev;
+		mbio->bi_end_io	= raid1_end_write_request;
+		mbio->bi_rw = WRITE | (do_barriers << BIO_RW_BARRIER) |
+			(do_sync << BIO_RW_SYNCIO);
+		mbio->bi_private = r1_bio;
+
 		atomic_inc(&r1_bio->remaining);
 
 		bio_list_add(&bl, mbio);
@@ -1110,12 +1178,21 @@ static int make_request(mddev_t *mddev, struct bio * bio)
 	/* In case raid1d snuck into freeze_array */
 	wake_up(&conf->wait_barrier);
 
+	if (sectors_handled < (bio->bi_size >> 9)) {
+		/* We need another r1_bio.  It has already been counted
+		 * in bio->bi_phys_segments
+		 */
+		r1_bio = mempool_alloc(conf->r1bio_pool, GFP_NOIO);
+		r1_bio->master_bio = bio;
+		r1_bio->sectors = (bio->bi_size >> 9) - sectors_handled;
+		r1_bio->state = 0;
+		r1_bio->mddev = mddev;
+		r1_bio->sector = bio->bi_sector + sectors_handled;
+		goto retry_write;
+	}
+
 	if (do_sync)
 		md_wakeup_thread(mddev->thread);
-#if 0
-	while ((bio = bio_list_pop(&bl)) != NULL)
-		generic_make_request(bio);
-#endif
 
 	return 0;
 }


