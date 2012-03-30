From: "majianpeng" <majianpeng@gmail.com>
Subject: When allocating resync pages,judge the queue limit of mddev.
Date: Fri, 30 Mar 2012 13:53:05 +0800
Message-ID: <201203301352578438837@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

From d5c0ad3ac03c805747f71338d30282f9f8d8d953 Mon Sep 17 00:00:00 2001
From: majianpeng <majianpeng@gmail.com>
Date: Fri, 30 Mar 2012 13:37:42 +0800
Subject: [PATCH] md/raid1:When allocating resync pages,judge the queue limit  of mddev.
 When max_sectors of mddev is smaller than
 RESYNC_PAGES(at present 64k),then: 1:alloc enough resync
 pags. 2:when do bio_add_page can goto bio_fill.


Signed-off-by: majianpeng <majianpeng@gmail.com>
---
 drivers/md/raid1.c |   18 +++++++++++-------
 1 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 4a40a20..cd100e6 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -82,16 +82,19 @@ static void * r1buf_pool_alloc(gfp_t gfp_flags, void *data)
 	struct r1bio *r1_bio;
 	struct bio *bio;
 	int i, j;
+	int sync_pages;
 
 	r1_bio = r1bio_pool_alloc(gfp_flags, pi);
 	if (!r1_bio)
 		return NULL;
 
+	sync_pages = queue_max_sectors(pi->mddev->gendisk->queue) << 9;
+	sync_pages = min(RESYNC_PAGES, (sync_pages + PAGE_SIZE - 1) / PAGE_SIZE);
 	/*
 	 * Allocate bios : 1 for reading, n-1 for writing
 	 */
 	for (j = pi->raid_disks ; j-- ; ) {
-		bio = bio_kmalloc(gfp_flags, RESYNC_PAGES);
+		bio = bio_kmalloc(gfp_flags, sync_pages);
 		if (!bio)
 			goto out_free_bio;
 		r1_bio->bios[j] = bio;
@@ -108,7 +111,7 @@ static void * r1buf_pool_alloc(gfp_t gfp_flags, void *data)
 		j = 1;
 	while(j--) {
 		bio = r1_bio->bios[j];
-		for (i = 0; i < RESYNC_PAGES; i++) {
+		for (i = 0; i < sync_pages; i++) {
 			page = alloc_page(gfp_flags);
 			if (unlikely(!page))
 				goto out_free_pages;
@@ -119,8 +122,8 @@ static void * r1buf_pool_alloc(gfp_t gfp_flags, void *data)
 	}
 	/* If not user-requests, copy the page pointers to all bios */
 	if (!test_bit(MD_RECOVERY_REQUESTED, &pi->mddev->recovery)) {
-		for (i=0; i<RESYNC_PAGES ; i++)
-			for (j=1; j<pi->raid_disks; j++)
+		for (i = 0; i < sync_pages ; i++)
+			for (j = 1; j < pi->raid_disks; j++)
 				r1_bio->bios[j]->bi_io_vec[i].bv_page =
 					r1_bio->bios[0]->bi_io_vec[i].bv_page;
 	}
@@ -147,7 +150,7 @@ static void r1buf_pool_free(void *__r1_bio, void *data)
 	int i,j;
 	struct r1bio *r1bio = __r1_bio;
 
-	for (i = 0; i < RESYNC_PAGES; i++)
+	for (i = 0; i < r1bio->bios[0]->bi_max_vecs; i++)
 		for (j = pi->raid_disks; j-- ;) {
 			if (j == 0 ||
 			    r1bio->bios[j]->bi_io_vec[i].bv_page !=
@@ -2243,7 +2246,7 @@ static sector_t sync_request(struct mddev *mddev, sector_t sector_nr, int *skipp
 	int write_targets = 0, read_targets = 0;
 	sector_t sync_blocks;
 	int still_degraded = 0;
-	int good_sectors = RESYNC_SECTORS;
+	int good_sectors;
 	int min_bad = 0; /* number of sectors that are bad in all devices */
 
 	if (!conf->r1buf_pool)
@@ -2296,6 +2299,7 @@ static sector_t sync_request(struct mddev *mddev, sector_t sector_nr, int *skipp
 	r1_bio = mempool_alloc(conf->r1buf_pool, GFP_NOIO);
 	raise_barrier(conf);
 
+	good_sectors = r1_bio->bios[0]->bi_max_vecs << 9;
 	conf->next_resync = sector_nr;
 
 	rcu_read_lock();
@@ -2477,7 +2481,7 @@ static sector_t sync_request(struct mddev *mddev, sector_t sector_nr, int *skipp
 		nr_sectors += len>>9;
 		sector_nr += len>>9;
 		sync_blocks -= (len>>9);
-	} while (r1_bio->bios[disk]->bi_vcnt < RESYNC_PAGES);
+	} while (r1_bio->bios[disk]->bi_vcnt < r1_bio->bios[0]->bi_max_vecs);
  bio_full:
 	r1_bio->sectors = nr_sectors;
 
-- 
1.7.5.4

 				
--------------
majianpeng
2012-03-30

