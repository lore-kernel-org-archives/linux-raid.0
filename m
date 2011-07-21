From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 10/36] md/raid1: avoid writing to known-bad blocks on
 known-bad drives.
Date: Thu, 21 Jul 2011 12:58:48 +1000
Message-ID: <20110721025848.8422.25836.stgit@notabene.brown>
References: <20110721024556.8422.99443.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110721024556.8422.99443.stgit@notabene.brown>
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

 drivers/md/raid1.c |  152 +++++++++++++++++++++++++++++++++++++++-------------
 1 files changed, 115 insertions(+), 37 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 4d40d9d..44277dc 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -772,6 +772,9 @@ static int make_request(mddev_t *mddev, struct bio * bio)
 	const unsigned long do_flush_fua = (bio->bi_rw & (REQ_FLUSH | REQ_FUA));
 	mdk_rdev_t *blocked_rdev;
 	int plugged;
+	int first_clone;
+	int sectors_handled;
+	int max_sectors;
 
 	/*
 	 * Register the new request and wait if the reconstruction
@@ -832,7 +835,6 @@ static int make_request(mddev_t *mddev, struct bio * bio)
 		/*
 		 * read balancing logic:
 		 */
-		int max_sectors;
 		int rdisk;
 
 read_again:
@@ -872,7 +874,6 @@ read_again:
 			/* could not read all from this device, so we will
 			 * need another r1_bio.
 			 */
-			int sectors_handled;
 
 			sectors_handled = (r1_bio->sector + max_sectors
 					   - bio->bi_sector);
@@ -906,9 +907,15 @@ read_again:
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
+	 * the bad blocks.  Each set of writes gets it's own r1bio
+	 * with a set of bios attached.
 	 */
 	plugged = mddev_check_plugged(mddev);
 
@@ -916,6 +923,7 @@ read_again:
  retry_write:
 	blocked_rdev = NULL;
 	rcu_read_lock();
+	max_sectors = r1_bio->sectors;
 	for (i = 0;  i < disks; i++) {
 		mdk_rdev_t *rdev = rcu_dereference(conf->mirrors[i].rdev);
 		if (rdev && unlikely(test_bit(Blocked, &rdev->flags))) {
@@ -923,17 +931,57 @@ read_again:
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
+		if (test_bit(WriteErrorSeen, &rdev->flags)) {
+			sector_t first_bad;
+			int bad_sectors;
+			int is_bad;
+
+			is_bad = is_badblock(rdev, r1_bio->sector,
+					     max_sectors,
+					     &first_bad, &bad_sectors);
+			if (is_bad < 0) {
+				/* mustn't write here until the bad block is
+				 * acknowledged*/
+				set_bit(BlockedBadBlocks, &rdev->flags);
+				blocked_rdev = rdev;
+				break;
+			}
+			if (is_bad && first_bad <= r1_bio->sector) {
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
+				/* We don't set R1BIO_Degraded as that
+				 * only applies if the disk is
+				 * missing, so it might be re-added,
+				 * and we want to know to recover this
+				 * chunk.
+				 * In this case the device is here,
+				 * and the fact that this chunk is not
+				 * in-sync is recorded in the bad
+				 * block log
+				 */
+				continue;
 			}
-		} else
-			r1_bio->bios[i] = NULL;
+			if (is_bad) {
+				int good_sectors = first_bad - r1_bio->sector;
+				if (good_sectors < max_sectors)
+					max_sectors = good_sectors;
+			}
+		}
+		r1_bio->bios[i] = bio;
+		targets++;
 	}
 	rcu_read_unlock();
 
@@ -944,48 +992,56 @@ read_again:
 		for (j = 0; j < i; j++)
 			if (r1_bio->bios[j])
 				rdev_dec_pending(conf->mirrors[j].rdev, mddev);
-
+		r1_bio->state = 0;
 		allow_barrier(conf);
 		md_wait_for_blocked_rdev(blocked_rdev, mddev);
 		wait_barrier(conf);
 		goto retry_write;
 	}
 
-	if (targets < conf->raid_disks) {
-		/* array is degraded, we will not clear the bitmap
-		 * on I/O completion (see raid1_end_write_request) */
-		set_bit(R1BIO_Degraded, &r1_bio->state);
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
 	}
-
-	/* do behind I/O ?
-	 * Not if there are too many, or cannot allocate memory,
-	 * or a reader on WriteMostly is waiting for behind writes 
-	 * to flush */
-	if (bitmap &&
-	    (atomic_read(&bitmap->behind_writes)
-	     < mddev->bitmap_info.max_write_behind) &&
-	    !waitqueue_active(&bitmap->behind_wait))
-		alloc_behind_pages(bio, r1_bio);
+	sectors_handled = r1_bio->sector + max_sectors - bio->bi_sector;
 
 	atomic_set(&r1_bio->remaining, 1);
 	atomic_set(&r1_bio->behind_remaining, 0);
 
-	bitmap_startwrite(bitmap, bio->bi_sector, r1_bio->sectors,
-				test_bit(R1BIO_BehindIO, &r1_bio->state));
+	first_clone = 1;
 	for (i = 0; i < disks; i++) {
 		struct bio *mbio;
 		if (!r1_bio->bios[i])
 			continue;
 
 		mbio = bio_clone_mddev(bio, GFP_NOIO, mddev);
-		r1_bio->bios[i] = mbio;
-
-		mbio->bi_sector	= r1_bio->sector + conf->mirrors[i].rdev->data_offset;
-		mbio->bi_bdev = conf->mirrors[i].rdev->bdev;
-		mbio->bi_end_io	= raid1_end_write_request;
-		mbio->bi_rw = WRITE | do_flush_fua | do_sync;
-		mbio->bi_private = r1_bio;
-
+		md_trim_bio(mbio, r1_bio->sector - bio->bi_sector, max_sectors);
+
+		if (first_clone) {
+			/* do behind I/O ?
+			 * Not if there are too many, or cannot
+			 * allocate memory, or a reader on WriteMostly
+			 * is waiting for behind writes to flush */
+			if (bitmap &&
+			    (atomic_read(&bitmap->behind_writes)
+			     < mddev->bitmap_info.max_write_behind) &&
+			    !waitqueue_active(&bitmap->behind_wait))
+				alloc_behind_pages(mbio, r1_bio);
+
+			bitmap_startwrite(bitmap, r1_bio->sector,
+					  r1_bio->sectors,
+					  test_bit(R1BIO_BehindIO,
+						   &r1_bio->state));
+			first_clone = 0;
+		}
 		if (r1_bio->behind_pages) {
 			struct bio_vec *bvec;
 			int j;
@@ -1003,6 +1059,15 @@ read_again:
 				atomic_inc(&r1_bio->behind_remaining);
 		}
 
+		r1_bio->bios[i] = mbio;
+
+		mbio->bi_sector	= (r1_bio->sector +
+				   conf->mirrors[i].rdev->data_offset);
+		mbio->bi_bdev = conf->mirrors[i].rdev->bdev;
+		mbio->bi_end_io	= raid1_end_write_request;
+		mbio->bi_rw = WRITE | do_flush_fua | do_sync;
+		mbio->bi_private = r1_bio;
+
 		atomic_inc(&r1_bio->remaining);
 		spin_lock_irqsave(&conf->device_lock, flags);
 		bio_list_add(&conf->pending_bio_list, mbio);
@@ -1013,6 +1078,19 @@ read_again:
 	/* In case raid1d snuck in to freeze_array */
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
 	if (do_sync || !bitmap || !plugged)
 		md_wakeup_thread(mddev->thread);
 


