From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 6 of 7 - Dynamically limit size of bio requests used for raid1 resync
Date: Fri, 06 Feb 2004 16:35:54 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E1Aoyeg-00083w-00@notabene>
References: <20040206162532.30220.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Currently raid1 uses PAGE_SIZE read/write requests for resync, as it 
doesn't know how to honour per-device restrictions.
This patch uses to bio_add_page to honour those restrictions and ups the limit
on request size to 64K.
This has a measurable impact on rebuild speed (25M/s -> 60M/s)


 ----------- Diffstat output ------------
 ./drivers/md/raid1.c |  183 ++++++++++++++++++++++++++-------------------------
 1 files changed, 96 insertions(+), 87 deletions(-)

diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
--- ./drivers/md/raid1.c~current~	2004-02-06 16:19:44.000000000 +1100
+++ ./drivers/md/raid1.c	2004-02-06 16:20:51.000000000 +1100
@@ -56,8 +56,8 @@ static void r1bio_pool_free(void *r1_bio
 	kfree(r1_bio);
 }
 
-//#define RESYNC_BLOCK_SIZE (64*1024)
-#define RESYNC_BLOCK_SIZE PAGE_SIZE
+#define RESYNC_BLOCK_SIZE (64*1024)
+//#define RESYNC_BLOCK_SIZE PAGE_SIZE
 #define RESYNC_SECTORS (RESYNC_BLOCK_SIZE >> 9)
 #define RESYNC_PAGES ((RESYNC_BLOCK_SIZE + PAGE_SIZE-1) / PAGE_SIZE)
 #define RESYNC_WINDOW (2048*1024)
@@ -73,38 +73,39 @@ static void * r1buf_pool_alloc(int gfp_f
 	r1_bio = r1bio_pool_alloc(gfp_flags, conf->mddev);
 	if (!r1_bio)
 		return NULL;
-	bio = bio_alloc(gfp_flags, RESYNC_PAGES);
-	if (!bio)
-		goto out_free_r1_bio;
 
 	/*
-	 * Allocate RESYNC_PAGES data pages for this iovec.
+	 * Allocate bios : 1 for reading, n-1 for writing
 	 */
+	for (j = conf->raid_disks ; j-- ; ) {
+		bio = bio_alloc(gfp_flags, RESYNC_PAGES);
+		if (!bio)
+			goto out_free_bio;
+		r1_bio->bios[j] = bio;
+	}
+	/*
+	 * Allocate RESYNC_PAGES data pages and attach them to
+	 * the first bio;
+	 */
+	bio = r1_bio->bios[0];
 	for (i = 0; i < RESYNC_PAGES; i++) {
 		page = alloc_page(gfp_flags);
 		if (unlikely(!page))
 			goto out_free_pages;
 
 		bio->bi_io_vec[i].bv_page = page;
-		bio->bi_io_vec[i].bv_len = PAGE_SIZE;
-		bio->bi_io_vec[i].bv_offset = 0;
 	}
 
-	bio->bi_vcnt = RESYNC_PAGES;
-	bio->bi_idx = 0;
-	bio->bi_size = RESYNC_BLOCK_SIZE;
-	bio->bi_end_io = NULL;
-	atomic_set(&bio->bi_cnt, 1);
-
 	r1_bio->master_bio = bio;
 
 	return r1_bio;
 
 out_free_pages:
-	for (j = 0; j < i; j++)
-		__free_page(bio->bi_io_vec[j].bv_page);
-	bio_put(bio);
-out_free_r1_bio:
+	for ( ; i > 0 ; i--)
+		__free_page(bio->bi_io_vec[i-1].bv_page);
+out_free_bio:
+	while ( j < conf->raid_disks )
+		bio_put(r1_bio->bios[++j]);
 	r1bio_pool_free(r1_bio, conf->mddev);
 	return NULL;
 }
@@ -114,15 +115,15 @@ static void r1buf_pool_free(void *__r1_b
 	int i;
 	conf_t *conf = data;
 	r1bio_t *r1bio = __r1_bio;
-	struct bio *bio = r1bio->master_bio;
+	struct bio *bio = r1bio->bios[0];
 
-	if (atomic_read(&bio->bi_cnt) != 1)
-		BUG();
 	for (i = 0; i < RESYNC_PAGES; i++) {
 		__free_page(bio->bi_io_vec[i].bv_page);
 		bio->bi_io_vec[i].bv_page = NULL;
 	}
-	bio_put(bio);
+	for (i=0 ; i < conf->raid_disks; i++)
+		bio_put(r1bio->bios[i]);
+
 	r1bio_pool_free(r1bio, conf->mddev);
 }
 
@@ -162,15 +163,8 @@ static inline void free_r1bio(r1bio_t *r
 static inline void put_buf(r1bio_t *r1_bio)
 {
 	conf_t *conf = mddev_to_conf(r1_bio->mddev);
-	struct bio *bio = r1_bio->master_bio;
 	unsigned long flags;
 
-	/*
-	 * undo any possible partial request fixup magic:
-	 */
-	if (bio->bi_size != RESYNC_BLOCK_SIZE)
-		bio->bi_io_vec[bio->bi_vcnt-1].bv_len = PAGE_SIZE;
-	put_all_bios(conf, r1_bio);
 	mempool_free(r1_bio, conf->r1buf_pool);
 
 	spin_lock_irqsave(&conf->resync_lock, flags);
@@ -810,12 +804,11 @@ static void sync_request_write(mddev_t *
 	conf_t *conf = mddev_to_conf(mddev);
 	int i;
 	int disks = conf->raid_disks;
-	struct bio *bio, *mbio;
+	struct bio *bio, *wbio;
 
-	bio = r1_bio->master_bio;
+	bio = r1_bio->bios[r1_bio->read_disk];
 
 	/*
-	 * have to allocate lots of bio structures and
 	 * schedule writes
 	 */
 	if (!test_bit(R1BIO_Uptodate, &r1_bio->state)) {
@@ -833,43 +826,16 @@ static void sync_request_write(mddev_t *
 		return;
 	}
 
-	spin_lock_irq(&conf->device_lock);
-	for (i = 0; i < disks ; i++) {
-		r1_bio->bios[i] = NULL;
-		if (!conf->mirrors[i].rdev || 
-		    conf->mirrors[i].rdev->faulty)
-			continue;
-		if (i == r1_bio->read_disk)
-			/*
-			 * we read from here, no need to write
-			 */
-			continue;
-		if (conf->mirrors[i].rdev->in_sync && 
-			r1_bio->sector + (bio->bi_size>>9) <= mddev->recovery_cp)
-			/*
-			 * don't need to write this we are just rebuilding
-			 */
-			continue;
-		atomic_inc(&conf->mirrors[i].rdev->nr_pending);
-		r1_bio->bios[i] = bio;
-	}
-	spin_unlock_irq(&conf->device_lock);
-
 	atomic_set(&r1_bio->remaining, 1);
-	for (i = disks; i-- ; ) {
-		if (!r1_bio->bios[i])
+	for (i = 0; i < disks ; i++) {
+		wbio = r1_bio->bios[i];
+		if (wbio->bi_end_io != end_sync_write)
 			continue;
-		mbio = bio_clone(bio, GFP_NOIO);
-		r1_bio->bios[i] = mbio;
-		mbio->bi_bdev = conf->mirrors[i].rdev->bdev;
-		mbio->bi_sector = r1_bio->sector + conf->mirrors[i].rdev->data_offset;
-		mbio->bi_end_io	= end_sync_write;
-		mbio->bi_rw = WRITE;
-		mbio->bi_private = r1_bio;
 
+		atomic_inc(&conf->mirrors[i].rdev->nr_pending);
 		atomic_inc(&r1_bio->remaining);
-		md_sync_acct(conf->mirrors[i].rdev, mbio->bi_size >> 9);
-		generic_make_request(mbio);
+		md_sync_acct(conf->mirrors[i].rdev, wbio->bi_size >> 9);
+		generic_make_request(wbio);
 	}
 
 	if (atomic_dec_and_test(&r1_bio->remaining)) {
@@ -967,7 +933,8 @@ static int sync_request(mddev_t *mddev, 
 	r1bio_t *r1_bio;
 	struct bio *bio;
 	sector_t max_sector, nr_sectors;
-	int disk, partial;
+	int disk;
+	int i;
 
 	if (!conf->r1buf_pool)
 		if (init_resync(conf))
@@ -1020,27 +987,69 @@ static int sync_request(mddev_t *mddev, 
 	set_bit(R1BIO_IsSync, &r1_bio->state);
 	r1_bio->read_disk = disk;
 
-	bio = r1_bio->master_bio;
-	nr_sectors = RESYNC_BLOCK_SIZE >> 9;
-	if (max_sector - sector_nr < nr_sectors)
-		nr_sectors = max_sector - sector_nr;
-	bio->bi_size = nr_sectors << 9;
-	bio->bi_vcnt = (bio->bi_size + PAGE_SIZE-1) / PAGE_SIZE;
-	/*
-	 * Is there a partial page at the end of the request?
-	 */
-	partial = bio->bi_size % PAGE_SIZE;
-	if (partial)
-		bio->bi_io_vec[bio->bi_vcnt-1].bv_len = partial;
-
-
-	bio->bi_sector = sector_nr + mirror->rdev->data_offset;
-	bio->bi_bdev = mirror->rdev->bdev;
-	bio->bi_end_io = end_sync_read;
-	bio->bi_rw = READ;
-	bio->bi_private = r1_bio;
-	bio_get(bio);
-	r1_bio->bios[r1_bio->read_disk] = bio;
+	for (i=0; i < conf->raid_disks; i++) {
+		bio = r1_bio->bios[i];
+
+		/* take from bio_init */
+		bio->bi_next = NULL;
+		bio->bi_flags |= 1 << BIO_UPTODATE;
+		bio->bi_rw = 0;
+		bio->bi_vcnt = 0;
+		bio->bi_idx = 0;
+		bio->bi_phys_segments = 0;
+		bio->bi_hw_segments = 0;
+		bio->bi_size = 0;
+		bio->bi_end_io = NULL;
+		bio->bi_private = NULL;
+
+		if (i == disk) {
+			bio->bi_rw = READ;
+			bio->bi_end_io = end_sync_read;
+		} else if (conf->mirrors[i].rdev &&
+			   !conf->mirrors[i].rdev->faulty &&
+			   (!conf->mirrors[i].rdev->in_sync ||
+			    sector_nr + RESYNC_SECTORS > mddev->recovery_cp)) {
+			bio->bi_rw = WRITE;
+			bio->bi_end_io = end_sync_write;
+		} else
+			continue;
+		bio->bi_sector = sector_nr + conf->mirrors[i].rdev->data_offset;
+		bio->bi_bdev = conf->mirrors[i].rdev->bdev;
+		bio->bi_private = r1_bio;
+	}
+	nr_sectors = 0;
+	do {
+		struct page *page;
+		int len = PAGE_SIZE;
+		if (sector_nr + (len>>9) > max_sector)
+			len = (max_sector - sector_nr) << 9;
+		if (len == 0)	
+			break;
+		for (i=0 ; i < conf->raid_disks; i++) {
+			bio = r1_bio->bios[i];
+			if (bio->bi_end_io) {
+				page = r1_bio->bios[0]->bi_io_vec[bio->bi_vcnt].bv_page;
+				if (bio_add_page(bio, page, len, 0) == 0) {
+					/* stop here */
+					r1_bio->bios[0]->bi_io_vec[bio->bi_vcnt].bv_page = page;
+					while (i > 0) {
+						i--;
+						bio = r1_bio->bios[i];
+						if (bio->bi_end_io==NULL) continue;
+						/* remove last page from this bio */
+						bio->bi_vcnt--;
+						bio->bi_size -= len;
+						bio->bi_flags &= ~(1<< BIO_SEG_VALID);
+					}
+					goto bio_full;
+				}
+			}
+		}
+		nr_sectors += len>>9;
+		sector_nr += len>>9;
+	} while (r1_bio->bios[disk]->bi_vcnt < RESYNC_PAGES);
+ bio_full:
+	bio = r1_bio->bios[disk];
 	r1_bio->sectors = nr_sectors;
 
 	md_sync_acct(mirror->rdev, nr_sectors);
