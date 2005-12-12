From: NeilBrown <neilb@suse.de>
Subject: [PATCH md 003 of 20] Define and use safe_put_page for md.
Date: Mon, 12 Dec 2005 14:10:18 +1100
Message-ID: <1051212031018.4891@suse.de>
References: <20051212135705.4561.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


md sometimes call put_page on NULL pointers (treating it like kfree).
This is not safe, so define and use a 'safe_put_page' which checks
for NULL.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/bitmap.c       |    3 +--
 ./drivers/md/raid1.c        |    8 ++++----
 ./drivers/md/raid10.c       |    8 ++++----
 ./drivers/md/raid6main.c    |    3 +--
 ./include/linux/raid/md_k.h |    5 +++++
 5 files changed, 15 insertions(+), 12 deletions(-)

diff ./drivers/md/bitmap.c~current~ ./drivers/md/bitmap.c
--- ./drivers/md/bitmap.c~current~	2005-12-12 10:45:16.000000000 +1100
+++ ./drivers/md/bitmap.c	2005-12-12 10:45:26.000000000 +1100
@@ -626,8 +626,7 @@ static void bitmap_file_unmap(struct bit
 	kfree(map);
 	kfree(attr);
 
-	if (sb_page)
-		put_page(sb_page);
+	safe_put_page(sb_page);
 }
 
 static void bitmap_stop_daemon(struct bitmap *bitmap);

diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
--- ./drivers/md/raid1.c~current~	2005-12-12 10:45:22.000000000 +1100
+++ ./drivers/md/raid1.c	2005-12-12 10:45:26.000000000 +1100
@@ -136,7 +136,7 @@ static void * r1buf_pool_alloc(gfp_t gfp
 out_free_pages:
 	for (i=0; i < RESYNC_PAGES ; i++)
 		for (j=0 ; j < pi->raid_disks; j++)
-			put_page(r1_bio->bios[j]->bi_io_vec[i].bv_page);
+			safe_put_page(r1_bio->bios[j]->bi_io_vec[i].bv_page);
 	j = -1;
 out_free_bio:
 	while ( ++j < pi->raid_disks )
@@ -156,7 +156,7 @@ static void r1buf_pool_free(void *__r1_b
 			if (j == 0 ||
 			    r1bio->bios[j]->bi_io_vec[i].bv_page !=
 			    r1bio->bios[0]->bi_io_vec[i].bv_page)
-				put_page(r1bio->bios[j]->bi_io_vec[i].bv_page);
+				safe_put_page(r1bio->bios[j]->bi_io_vec[i].bv_page);
 		}
 	for (i=0 ; i < pi->raid_disks; i++)
 		bio_put(r1bio->bios[i]);
@@ -381,7 +381,7 @@ static int raid1_end_write_request(struc
 			/* free extra copy of the data pages */
 			int i = bio->bi_vcnt;
 			while (i--)
-				put_page(bio->bi_io_vec[i].bv_page);
+				safe_put_page(bio->bi_io_vec[i].bv_page);
 		}
 		/* clear the bitmap if all writes complete successfully */
 		bitmap_endwrite(r1_bio->mddev->bitmap, r1_bio->sector,
@@ -1907,7 +1907,7 @@ out_free_conf:
 		if (conf->r1bio_pool)
 			mempool_destroy(conf->r1bio_pool);
 		kfree(conf->mirrors);
-		put_page(conf->tmppage);
+		safe_put_page(conf->tmppage);
 		kfree(conf->poolinfo);
 		kfree(conf);
 		mddev->private = NULL;

diff ./drivers/md/raid10.c~current~ ./drivers/md/raid10.c
--- ./drivers/md/raid10.c~current~	2005-12-12 10:45:16.000000000 +1100
+++ ./drivers/md/raid10.c	2005-12-12 10:45:26.000000000 +1100
@@ -132,10 +132,10 @@ static void * r10buf_pool_alloc(gfp_t gf
 
 out_free_pages:
 	for ( ; i > 0 ; i--)
-		put_page(bio->bi_io_vec[i-1].bv_page);
+		safe_put_page(bio->bi_io_vec[i-1].bv_page);
 	while (j--)
 		for (i = 0; i < RESYNC_PAGES ; i++)
-			put_page(r10_bio->devs[j].bio->bi_io_vec[i].bv_page);
+			safe_put_page(r10_bio->devs[j].bio->bi_io_vec[i].bv_page);
 	j = -1;
 out_free_bio:
 	while ( ++j < nalloc )
@@ -155,7 +155,7 @@ static void r10buf_pool_free(void *__r10
 		struct bio *bio = r10bio->devs[j].bio;
 		if (bio) {
 			for (i = 0; i < RESYNC_PAGES; i++) {
-				put_page(bio->bi_io_vec[i].bv_page);
+				safe_put_page(bio->bi_io_vec[i].bv_page);
 				bio->bi_io_vec[i].bv_page = NULL;
 			}
 			bio_put(bio);
@@ -2042,7 +2042,7 @@ static int run(mddev_t *mddev)
 out_free_conf:
 	if (conf->r10bio_pool)
 		mempool_destroy(conf->r10bio_pool);
-	put_page(conf->tmppage);
+	safe_put_page(conf->tmppage);
 	kfree(conf->mirrors);
 	kfree(conf);
 	mddev->private = NULL;

diff ./drivers/md/raid6main.c~current~ ./drivers/md/raid6main.c
--- ./drivers/md/raid6main.c~current~	2005-12-12 10:45:16.000000000 +1100
+++ ./drivers/md/raid6main.c	2005-12-12 10:45:26.000000000 +1100
@@ -2072,8 +2072,7 @@ static int run(mddev_t *mddev)
 abort:
 	if (conf) {
 		print_raid6_conf(conf);
-		if (conf->spare_page)
-			put_page(conf->spare_page);
+		safe_put_page(conf->spare_page);
 		kfree(conf->stripe_hashtbl);
 		kfree(conf);
 	}

diff ./include/linux/raid/md_k.h~current~ ./include/linux/raid/md_k.h
--- ./include/linux/raid/md_k.h~current~	2005-12-12 10:45:16.000000000 +1100
+++ ./include/linux/raid/md_k.h	2005-12-12 10:45:26.000000000 +1100
@@ -324,5 +324,10 @@ do {									\
 	__wait_event_lock_irq(wq, condition, lock, cmd);		\
 } while (0)
 
+static inline void safe_put_page(struct page *p)
+{
+	if (p) put_page(p);
+}
+
 #endif
 
