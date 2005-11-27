From: NeilBrown <neilb@suse.de>
Subject: [PATCH md 015 of 18] Tidyup some issues with raid1 resync and prepare for catching read errors.
Date: Mon, 28 Nov 2005 10:40:54 +1100
Message-ID: <1051127234054.14913@suse.de>
References: <20051128102824.14498.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


We are dereferencing ->rdev without an rcu lock!

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid1.c |  112 +++++++++++++++++++++++++--------------------------
 1 file changed, 57 insertions(+), 55 deletions(-)

diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
--- ./drivers/md/raid1.c~current~	2005-11-28 10:13:11.000000000 +1100
+++ ./drivers/md/raid1.c	2005-11-28 10:13:14.000000000 +1100
@@ -177,6 +177,13 @@ static inline void free_r1bio(r1bio_t *r
 static inline void put_buf(r1bio_t *r1_bio)
 {
 	conf_t *conf = mddev_to_conf(r1_bio->mddev);
+	int i;
+
+	for (i=0; i<conf->raid_disks; i++) {
+		struct bio *bio = r1_bio->bios[i];
+		if (bio->bi_end_io)
+			rdev_dec_pending(conf->mirrors[i].rdev, r1_bio->mddev);
+	}
 
 	mempool_free(r1_bio, conf->r1buf_pool);
 
@@ -1084,7 +1091,6 @@ static int end_sync_read(struct bio *bio
 			 conf->mirrors[r1_bio->read_disk].rdev);
 	} else
 		set_bit(R1BIO_Uptodate, &r1_bio->state);
-	rdev_dec_pending(conf->mirrors[r1_bio->read_disk].rdev, conf->mddev);
 	reschedule_retry(r1_bio);
 	return 0;
 }
@@ -1115,7 +1121,6 @@ static int end_sync_write(struct bio *bi
 		md_done_sync(mddev, r1_bio->sectors, uptodate);
 		put_buf(r1_bio);
 	}
-	rdev_dec_pending(conf->mirrors[mirror].rdev, mddev);
 	return 0;
 }
 
@@ -1152,10 +1157,14 @@ static void sync_request_write(mddev_t *
 	atomic_set(&r1_bio->remaining, 1);
 	for (i = 0; i < disks ; i++) {
 		wbio = r1_bio->bios[i];
-		if (wbio->bi_end_io != end_sync_write)
+		if (wbio->bi_end_io == NULL ||
+		    (wbio->bi_end_io == end_sync_read &&
+		     (i == r1_bio->read_disk ||
+		      !test_bit(MD_RECOVERY_SYNC, &mddev->recovery))))
 			continue;
 
-		atomic_inc(&conf->mirrors[i].rdev->nr_pending);
+		wbio->bi_rw = WRITE;
+		wbio->bi_end_io = end_sync_write;
 		atomic_inc(&r1_bio->remaining);
 		md_sync_acct(conf->mirrors[i].rdev->bdev, wbio->bi_size >> 9);
 
@@ -1387,14 +1396,13 @@ static int init_resync(conf_t *conf)
 static sector_t sync_request(mddev_t *mddev, sector_t sector_nr, int *skipped, int go_faster)
 {
 	conf_t *conf = mddev_to_conf(mddev);
-	mirror_info_t *mirror;
 	r1bio_t *r1_bio;
 	struct bio *bio;
 	sector_t max_sector, nr_sectors;
-	int disk;
+	int disk = -1;
 	int i;
-	int wonly;
-	int write_targets = 0;
+	int wonly = -1;
+	int write_targets = 0, read_targets = 0;
 	int sync_blocks;
 	int still_degraded = 0;
 
@@ -1446,44 +1454,24 @@ static sector_t sync_request(mddev_t *md
 
 	conf->next_resync = sector_nr;
 
-	/*
-	 * If reconstructing, and >1 working disc,
-	 * could dedicate one to rebuild and others to
-	 * service read requests ..
-	 */
-	disk = conf->last_used;
-	/* make sure disk is operational */
-	wonly = disk;
-	while (conf->mirrors[disk].rdev == NULL ||
-	       !test_bit(In_sync, &conf->mirrors[disk].rdev->flags) ||
-	       test_bit(WriteMostly, &conf->mirrors[disk].rdev->flags)
-		) {
-		if (conf->mirrors[disk].rdev  &&
-		    test_bit(In_sync, &conf->mirrors[disk].rdev->flags))
-			wonly = disk;
-		if (disk <= 0)
-			disk = conf->raid_disks;
-		disk--;
-		if (disk == conf->last_used) {
-			disk = wonly;
-			break;
-		}
-	}
-	conf->last_used = disk;
-	atomic_inc(&conf->mirrors[disk].rdev->nr_pending);
-
-
-	mirror = conf->mirrors + disk;
-
 	r1_bio = mempool_alloc(conf->r1buf_pool, GFP_NOIO);
+	rcu_read_lock();
+	/*
+	 * If we get a correctably read error during resync or recovery,
+	 * we might want to read from a different device.  So we
+	 * flag all drives that could conceivably be read from for READ,
+	 * and any others (which will be non-In_sync devices) for WRITE.
+	 * If a read fails, we try reading from something else for which READ
+	 * is OK.
+	 */
 
 	r1_bio->mddev = mddev;
 	r1_bio->sector = sector_nr;
 	r1_bio->state = 0;
 	set_bit(R1BIO_IsSync, &r1_bio->state);
-	r1_bio->read_disk = disk;
 
 	for (i=0; i < conf->raid_disks; i++) {
+		mdk_rdev_t *rdev;
 		bio = r1_bio->bios[i];
 
 		/* take from bio_init */
@@ -1498,35 +1486,49 @@ static sector_t sync_request(mddev_t *md
 		bio->bi_end_io = NULL;
 		bio->bi_private = NULL;
 
-		if (i == disk) {
-			bio->bi_rw = READ;
-			bio->bi_end_io = end_sync_read;
-		} else if (conf->mirrors[i].rdev == NULL ||
-			   test_bit(Faulty, &conf->mirrors[i].rdev->flags)) {
+		rdev = rcu_dereference(conf->mirrors[i].rdev);
+		if (rdev == NULL ||
+			   test_bit(Faulty, &rdev->flags)) {
 			still_degraded = 1;
 			continue;
-		} else if (!test_bit(In_sync, &conf->mirrors[i].rdev->flags) ||
-			   sector_nr + RESYNC_SECTORS > mddev->recovery_cp   ||
-			   test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery)) {
+		} else if (!test_bit(In_sync, &rdev->flags)) {
 			bio->bi_rw = WRITE;
 			bio->bi_end_io = end_sync_write;
 			write_targets ++;
-		} else
-			/* no need to read or write here */
-			continue;
-		bio->bi_sector = sector_nr + conf->mirrors[i].rdev->data_offset;
-		bio->bi_bdev = conf->mirrors[i].rdev->bdev;
+		} else {
+			/* may need to read from here */
+			bio->bi_rw = READ;
+			bio->bi_end_io = end_sync_read;
+			if (test_bit(WriteMostly, &rdev->flags)) {
+				if (wonly < 0)
+					wonly = i;
+			} else {
+				if (disk < 0)
+					disk = i;
+			}
+			read_targets++;
+		}
+		atomic_inc(&rdev->nr_pending);
+		bio->bi_sector = sector_nr + rdev->data_offset;
+		bio->bi_bdev = rdev->bdev;
 		bio->bi_private = r1_bio;
 	}
+	rcu_read_unlock();
+	if (disk < 0)
+		disk = wonly;
+	r1_bio->read_disk = disk;
 
-	if (write_targets == 0) {
+	if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery) && read_targets > 0)
+		/* extra read targets are also write targets */
+		write_targets += read_targets-1;
+
+	if (write_targets == 0 || read_targets == 0) {
 		/* There is nowhere to write, so all non-sync
 		 * drives must be failed - so we are finished
 		 */
 		sector_t rv = max_sector - sector_nr;
 		*skipped = 1;
 		put_buf(r1_bio);
-		rdev_dec_pending(conf->mirrors[disk].rdev, mddev);
 		return rv;
 	}
 
@@ -1577,10 +1579,10 @@ static sector_t sync_request(mddev_t *md
 		sync_blocks -= (len>>9);
 	} while (r1_bio->bios[disk]->bi_vcnt < RESYNC_PAGES);
  bio_full:
-	bio = r1_bio->bios[disk];
+	bio = r1_bio->bios[r1_bio->read_disk];
 	r1_bio->sectors = nr_sectors;
 
-	md_sync_acct(mirror->rdev->bdev, nr_sectors);
+	md_sync_acct(conf->mirrors[r1_bio->read_disk].rdev->bdev, nr_sectors);
 
 	generic_make_request(bio);
 
