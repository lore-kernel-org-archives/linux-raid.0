From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 5 of 7 - Avoid unnecessary bio allocation during raid1 resync
Date: Fri, 06 Feb 2004 16:35:53 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E1Aoyef-00083n-00@notabene>
References: <20040206162532.30220.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


For each resync request, we allocate a "r1_bio" which has a
bio "master_bio" attached that goes largely unused. We also
allocate a read_bio which is used.
This patch removes the read_bio and just uses the master_bio instead.

This fixes a bug wherein bi_bdev of the master_bio wasn't being set,
but was being used.

We also introduce a new "sectors" field into the r1_bio as we can
no-longer rely in master_bio->bi_sectors.

 ----------- Diffstat output ------------
 ./drivers/md/raid1.c         |   37 ++++++++++++++++++-------------------
 ./include/linux/raid/raid1.h |    1 +
 2 files changed, 19 insertions(+), 19 deletions(-)

diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
--- ./drivers/md/raid1.c~current~	2004-02-06 16:19:15.000000000 +1100
+++ ./drivers/md/raid1.c	2004-02-06 16:19:44.000000000 +1100
@@ -77,6 +77,9 @@ static void * r1buf_pool_alloc(int gfp_f
 	if (!bio)
 		goto out_free_r1_bio;
 
+	/*
+	 * Allocate RESYNC_PAGES data pages for this iovec.
+	 */
 	for (i = 0; i < RESYNC_PAGES; i++) {
 		page = alloc_page(gfp_flags);
 		if (unlikely(!page))
@@ -87,9 +90,6 @@ static void * r1buf_pool_alloc(int gfp_f
 		bio->bi_io_vec[i].bv_offset = 0;
 	}
 
-	/*
-	 * Allocate a single data page for this iovec.
-	 */
 	bio->bi_vcnt = RESYNC_PAGES;
 	bio->bi_idx = 0;
 	bio->bi_size = RESYNC_BLOCK_SIZE;
@@ -122,8 +122,6 @@ static void r1buf_pool_free(void *__r1_b
 		__free_page(bio->bi_io_vec[i].bv_page);
 		bio->bi_io_vec[i].bv_page = NULL;
 	}
-	if (atomic_read(&bio->bi_cnt) != 1)
-		BUG();
 	bio_put(bio);
 	r1bio_pool_free(r1bio, conf->mddev);
 }
@@ -249,7 +247,7 @@ static inline void update_head_pos(int d
 	conf_t *conf = mddev_to_conf(r1_bio->mddev);
 
 	conf->mirrors[disk].head_position =
-		r1_bio->sector + (r1_bio->master_bio->bi_size >> 9);
+		r1_bio->sector + (r1_bio->sectors);
 }
 
 static int raid1_end_read_request(struct bio *bio, unsigned int bytes_done, int error)
@@ -507,6 +505,7 @@ static int make_request(request_queue_t 
 	r1_bio = mempool_alloc(conf->r1bio_pool, GFP_NOIO);
 
 	r1_bio->master_bio = bio;
+	r1_bio->sectors = bio->bi_size >> 9;
 
 	r1_bio->mddev = mddev;
 	r1_bio->sector = bio->bi_sector;
@@ -799,7 +798,7 @@ static int end_sync_write(struct bio *bi
 	update_head_pos(mirror, r1_bio);
 
 	if (atomic_dec_and_test(&r1_bio->remaining)) {
-		md_done_sync(mddev, r1_bio->master_bio->bi_size >> 9, uptodate);
+		md_done_sync(mddev, r1_bio->sectors, uptodate);
 		put_buf(r1_bio);
 	}
 	atomic_dec(&conf->mirrors[mirror].rdev->nr_pending);
@@ -829,7 +828,7 @@ static void sync_request_write(mddev_t *
 			" for block %llu\n",
 			bdevname(bio->bi_bdev,b), 
 			(unsigned long long)r1_bio->sector);
-		md_done_sync(mddev, r1_bio->master_bio->bi_size >> 9, 0);
+		md_done_sync(mddev, r1_bio->sectors, 0);
 		put_buf(r1_bio);
 		return;
 	}
@@ -874,7 +873,7 @@ static void sync_request_write(mddev_t *
 	}
 
 	if (atomic_dec_and_test(&r1_bio->remaining)) {
-		md_done_sync(mddev, r1_bio->master_bio->bi_size >> 9, 1);
+		md_done_sync(mddev, r1_bio->sectors, 1);
 		put_buf(r1_bio);
 	}
 }
@@ -966,7 +965,7 @@ static int sync_request(mddev_t *mddev, 
 	conf_t *conf = mddev_to_conf(mddev);
 	mirror_info_t *mirror;
 	r1bio_t *r1_bio;
-	struct bio *read_bio, *bio;
+	struct bio *bio;
 	sector_t max_sector, nr_sectors;
 	int disk, partial;
 
@@ -1035,18 +1034,18 @@ static int sync_request(mddev_t *mddev, 
 		bio->bi_io_vec[bio->bi_vcnt-1].bv_len = partial;
 
 
-	read_bio = bio_clone(r1_bio->master_bio, GFP_NOIO);
-
-	read_bio->bi_sector = sector_nr + mirror->rdev->data_offset;
-	read_bio->bi_bdev = mirror->rdev->bdev;
-	read_bio->bi_end_io = end_sync_read;
-	read_bio->bi_rw = READ;
-	read_bio->bi_private = r1_bio;
-	r1_bio->bios[r1_bio->read_disk] = read_bio;
+	bio->bi_sector = sector_nr + mirror->rdev->data_offset;
+	bio->bi_bdev = mirror->rdev->bdev;
+	bio->bi_end_io = end_sync_read;
+	bio->bi_rw = READ;
+	bio->bi_private = r1_bio;
+	bio_get(bio);
+	r1_bio->bios[r1_bio->read_disk] = bio;
+	r1_bio->sectors = nr_sectors;
 
 	md_sync_acct(mirror->rdev, nr_sectors);
 
-	generic_make_request(read_bio);
+	generic_make_request(bio);
 
 	return nr_sectors;
 }

diff ./include/linux/raid/raid1.h~current~ ./include/linux/raid/raid1.h
--- ./include/linux/raid/raid1.h~current~	2004-02-06 16:19:15.000000000 +1100
+++ ./include/linux/raid/raid1.h	2004-02-06 16:19:44.000000000 +1100
@@ -55,6 +55,7 @@ struct r1bio_s {
 					    * used from IRQ handlers
 					    */
 	sector_t		sector;
+	int			sectors;
 	unsigned long		state;
 	mddev_t			*mddev;
 	/*
