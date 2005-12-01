From: NeilBrown <neilb@suse.de>
Subject: [PATCH md 002 of 14] Allow raid1 to check consistency
Date: Thu, 1 Dec 2005 14:22:56 +1100
Message-ID: <1051201032256.29567@suse.de>
References: <20051201141508.29384.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Where performing a user-requested 'check' or 'repair',
we read all readable devices, and compare the contents.
We only write to blocks which had read errors, or
blocks with content that differs from the first good device
found.



Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid1.c |  158 +++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 129 insertions(+), 29 deletions(-)

diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
--- ./drivers/md/raid1.c~current~	2005-11-28 15:08:48.000000000 +1100
+++ ./drivers/md/raid1.c	2005-11-28 17:20:37.000000000 +1100
@@ -106,15 +106,30 @@ static void * r1buf_pool_alloc(gfp_t gfp
 	}
 	/*
 	 * Allocate RESYNC_PAGES data pages and attach them to
-	 * the first bio;
-	 */
-	bio = r1_bio->bios[0];
-	for (i = 0; i < RESYNC_PAGES; i++) {
-		page = alloc_page(gfp_flags);
-		if (unlikely(!page))
-			goto out_free_pages;
-
-		bio->bi_io_vec[i].bv_page = page;
+	 * the first bio.
+	 * If this is a user-requested check/repair, allocate
+	 * RESYNC_PAGES for each bio.
+	 */
+	if (test_bit(MD_RECOVERY_REQUESTED, &pi->mddev->recovery))
+		j = pi->raid_disks;
+	else
+		j = 1;
+	while(j--) {
+		bio = r1_bio->bios[j];
+		for (i = 0; i < RESYNC_PAGES; i++) {
+			page = alloc_page(gfp_flags);
+			if (unlikely(!page))
+				goto out_free_pages;
+
+			bio->bi_io_vec[i].bv_page = page;
+		}
+	}
+	/* If not user-requests, copy the page pointers to all bios */
+	if (!test_bit(MD_RECOVERY_REQUESTED, &pi->mddev->recovery)) {
+		for (i=0; i<RESYNC_PAGES ; i++)
+			for (j=1; j<pi->raid_disks; j++)
+				r1_bio->bios[j]->bi_io_vec[i].bv_page =
+					r1_bio->bios[0]->bi_io_vec[i].bv_page;
 	}
 
 	r1_bio->master_bio = NULL;
@@ -122,8 +137,10 @@ static void * r1buf_pool_alloc(gfp_t gfp
 	return r1_bio;
 
 out_free_pages:
-	for ( ; i > 0 ; i--)
-		__free_page(bio->bi_io_vec[i-1].bv_page);
+	for (i=0; i < RESYNC_PAGES ; i++)
+		for (j=0 ; j < pi->raid_disks; j++)
+			__free_page(r1_bio->bios[j]->bi_io_vec[i].bv_page);
+	j = -1;
 out_free_bio:
 	while ( ++j < pi->raid_disks )
 		bio_put(r1_bio->bios[j]);
@@ -134,14 +151,16 @@ out_free_bio:
 static void r1buf_pool_free(void *__r1_bio, void *data)
 {
 	struct pool_info *pi = data;
-	int i;
+	int i,j;
 	r1bio_t *r1bio = __r1_bio;
-	struct bio *bio = r1bio->bios[0];
 
-	for (i = 0; i < RESYNC_PAGES; i++) {
-		__free_page(bio->bi_io_vec[i].bv_page);
-		bio->bi_io_vec[i].bv_page = NULL;
-	}
+	for (i = 0; i < RESYNC_PAGES; i++)
+		for (j = pi->raid_disks; j-- ;) {
+			if (j == 0 ||
+			    r1bio->bios[j]->bi_io_vec[i].bv_page !=
+			    r1bio->bios[0]->bi_io_vec[i].bv_page)
+				__free_page(r1bio->bios[j]->bi_io_vec[i].bv_page);
+		}
 	for (i=0 ; i < pi->raid_disks; i++)
 		bio_put(r1bio->bios[i]);
 
@@ -1076,13 +1095,16 @@ abort:
 static int end_sync_read(struct bio *bio, unsigned int bytes_done, int error)
 {
 	r1bio_t * r1_bio = (r1bio_t *)(bio->bi_private);
+	int i;
 
 	if (bio->bi_size)
 		return 1;
 
-	if (r1_bio->bios[r1_bio->read_disk] != bio)
-		BUG();
-	update_head_pos(r1_bio->read_disk, r1_bio);
+	for (i=r1_bio->mddev->raid_disks; i--; )
+		if (r1_bio->bios[i] == bio)
+			break;
+	BUG_ON(i < 0);
+	update_head_pos(i, r1_bio);
 	/*
 	 * we have read a block, now it needs to be re-written,
 	 * or re-read if the read failed.
@@ -1090,7 +1112,9 @@ static int end_sync_read(struct bio *bio
 	 */
 	if (test_bit(BIO_UPTODATE, &bio->bi_flags))
 		set_bit(R1BIO_Uptodate, &r1_bio->state);
-	reschedule_retry(r1_bio);
+
+	if (atomic_dec_and_test(&r1_bio->remaining))
+		reschedule_retry(r1_bio);
 	return 0;
 }
 
@@ -1133,9 +1157,65 @@ static void sync_request_write(mddev_t *
 	bio = r1_bio->bios[r1_bio->read_disk];
 
 
-	/*
-	 * schedule writes
-	 */
+	if (test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery)) {
+		/* We have read all readable devices.  If we haven't
+		 * got the block, then there is no hope left.
+		 * If we have, then we want to do a comparison
+		 * and skip the write if everything is the same.
+		 * If any blocks failed to read, then we need to
+		 * attempt an over-write
+		 */
+		int primary;
+		if (!test_bit(R1BIO_Uptodate, &r1_bio->state)) {
+			for (i=0; i<mddev->raid_disks; i++)
+				if (r1_bio->bios[i]->bi_end_io == end_sync_read)
+					md_error(mddev, conf->mirrors[i].rdev);
+
+			md_done_sync(mddev, r1_bio->sectors, 1);
+			put_buf(r1_bio);
+			return;
+		}
+		for (primary=0; primary<mddev->raid_disks; primary++)
+			if (r1_bio->bios[primary]->bi_end_io == end_sync_read &&
+			    test_bit(BIO_UPTODATE, &r1_bio->bios[primary]->bi_flags)) {
+				r1_bio->bios[primary]->bi_end_io = NULL;
+				break;
+			}
+		r1_bio->read_disk = primary;
+		for (i=0; i<mddev->raid_disks; i++)
+			if (r1_bio->bios[i]->bi_end_io == end_sync_read &&
+			    test_bit(BIO_UPTODATE, &r1_bio->bios[i]->bi_flags)) {
+				int j;
+				int vcnt = r1_bio->sectors >> (PAGE_SHIFT- 9);
+				struct bio *pbio = r1_bio->bios[primary];
+				struct bio *sbio = r1_bio->bios[i];
+				for (j = vcnt; j-- ; )
+					if (memcmp(page_address(pbio->bi_io_vec[j].bv_page),
+						   page_address(sbio->bi_io_vec[j].bv_page),
+						   PAGE_SIZE))
+						break;
+				if (j >= 0)
+					mddev->resync_mismatches += r1_bio->sectors;
+				if (j < 0 || test_bit(MD_RECOVERY_CHECK, &mddev->recovery))
+					sbio->bi_end_io = NULL;
+				else {
+					/* fixup the bio for reuse */
+					sbio->bi_vcnt = vcnt;
+					sbio->bi_size = r1_bio->sectors << 9;
+					sbio->bi_idx = 0;
+					sbio->bi_phys_segments = 0;
+					sbio->bi_hw_segments = 0;
+					sbio->bi_hw_front_size = 0;
+					sbio->bi_hw_back_size = 0;
+					sbio->bi_flags &= ~(BIO_POOL_MASK - 1);
+					sbio->bi_flags |= 1 << BIO_UPTODATE;
+					sbio->bi_next = NULL;
+					sbio->bi_sector = r1_bio->sector +
+						conf->mirrors[i].rdev->data_offset;
+					sbio->bi_bdev = conf->mirrors[i].rdev->bdev;
+				}
+			}
+	}
 	if (!test_bit(R1BIO_Uptodate, &r1_bio->state)) {
 		/* ouch - failed to read all of that.
 		 * Try some synchronous reads of other devices to get
@@ -1215,6 +1295,10 @@ static void sync_request_write(mddev_t *
 			idx ++;
 		}
 	}
+
+	/*
+	 * schedule writes
+	 */
 	atomic_set(&r1_bio->remaining, 1);
 	for (i = 0; i < disks ; i++) {
 		wbio = r1_bio->bios[i];
@@ -1617,10 +1701,10 @@ static sector_t sync_request(mddev_t *md
 		for (i=0 ; i < conf->raid_disks; i++) {
 			bio = r1_bio->bios[i];
 			if (bio->bi_end_io) {
-				page = r1_bio->bios[0]->bi_io_vec[bio->bi_vcnt].bv_page;
+				page = bio->bi_io_vec[bio->bi_vcnt].bv_page;
 				if (bio_add_page(bio, page, len, 0) == 0) {
 					/* stop here */
-					r1_bio->bios[0]->bi_io_vec[bio->bi_vcnt].bv_page = page;
+					bio->bi_io_vec[bio->bi_vcnt].bv_page = page;
 					while (i > 0) {
 						i--;
 						bio = r1_bio->bios[i];
@@ -1640,12 +1724,28 @@ static sector_t sync_request(mddev_t *md
 		sync_blocks -= (len>>9);
 	} while (r1_bio->bios[disk]->bi_vcnt < RESYNC_PAGES);
  bio_full:
-	bio = r1_bio->bios[r1_bio->read_disk];
 	r1_bio->sectors = nr_sectors;
 
-	md_sync_acct(conf->mirrors[r1_bio->read_disk].rdev->bdev, nr_sectors);
+	/* For a user-requested sync, we read all readable devices and do a
+	 * compare
+	 */
+	if (test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery)) {
+		atomic_set(&r1_bio->remaining, read_targets);
+		for (i=0; i<conf->raid_disks; i++) {
+			bio = r1_bio->bios[i];
+			if (bio->bi_end_io == end_sync_read) {
+				md_sync_acct(conf->mirrors[i].rdev->bdev, nr_sectors);
+				generic_make_request(bio);
+			}
+		}
+	} else {
+		atomic_set(&r1_bio->remaining, 1);
+		bio = r1_bio->bios[r1_bio->read_disk];
+		md_sync_acct(conf->mirrors[r1_bio->read_disk].rdev->bdev,
+			     nr_sectors);
+		generic_make_request(bio);
 
-	generic_make_request(bio);
+	}
 
 	return nr_sectors;
 }
