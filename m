From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 12 of 14 - Remove MD_SB_DISKS limits from raid1
Date: Tue, 27 May 2003 13:01:14 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E19KUiA-0003Ha-00@notabene.cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

### Comments for ChangeSet

raid1 uses MD_SB_DISKS to size two data structures,
but the new version-1 superblock allows for more than
this number of disks (and most actual arrays use many
fewer).
This patch sizes to two arrays dynamically.
One becomes a separate kmalloced array.
The other is moved to the end of the containing structure
and appropriate extra space is allocated.

Also, change r1buf_pool_alloc (which allocates buffers for 
a mempool for doing re-sync) to not get r1bio structures
from the r1bio pool (which could exhaust the pool) but instead
to allocate them separately.

 ----------- Diffstat output ------------
 ./drivers/md/raid1.c         |   29 ++++++++++++++++++++++-------
 ./include/linux/raid/raid1.h |   11 ++++++-----
 2 files changed, 28 insertions(+), 12 deletions(-)

diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
--- ./drivers/md/raid1.c~current~	2003-05-27 12:01:30.000000000 +1000
+++ ./drivers/md/raid1.c	2003-05-27 12:01:34.000000000 +1000
@@ -40,9 +40,12 @@ static LIST_HEAD(retry_list_head);
 
 static void * r1bio_pool_alloc(int gfp_flags, void *data)
 {
+	mddev_t *mddev = data;
 	r1bio_t *r1_bio;
 
-	r1_bio = kmalloc(sizeof(r1bio_t), gfp_flags);
+	/* allocate a r1bio with room for raid_disks entries in the write_bios array */
+	r1_bio = kmalloc(sizeof(r1bio_t) + sizeof(struct bio*)*mddev->raid_disks,
+			 gfp_flags);
 	if (r1_bio)
 		memset(r1_bio, 0, sizeof(*r1_bio));
 
@@ -67,8 +70,9 @@ static void * r1buf_pool_alloc(int gfp_f
 	struct bio *bio;
 	int i, j;
 
-	r1_bio = mempool_alloc(conf->r1bio_pool, gfp_flags);
-
+	r1_bio = r1bio_pool_alloc(gfp_flags, conf->mddev);
+	if (!r1_bio)
+		return NULL;
 	bio = bio_alloc(gfp_flags, RESYNC_PAGES);
 	if (!bio)
 		goto out_free_r1_bio;
@@ -101,7 +105,7 @@ out_free_pages:
 		__free_page(bio->bi_io_vec[j].bv_page);
 	bio_put(bio);
 out_free_r1_bio:
-	mempool_free(r1_bio, conf->r1bio_pool);
+	r1bio_pool_free(r1_bio, conf->mddev);
 	return NULL;
 }
 
@@ -121,7 +125,7 @@ static void r1buf_pool_free(void *__r1_b
 	if (atomic_read(&bio->bi_cnt) != 1)
 		BUG();
 	bio_put(bio);
-	mempool_free(r1bio, conf->r1bio_pool);
+	r1bio_pool_free(r1bio, conf->mddev);
 }
 
 static void put_all_bios(conf_t *conf, r1bio_t *r1_bio)
@@ -1085,13 +1089,20 @@ static int run(mddev_t *mddev)
 		goto out;
 	}
 	memset(conf, 0, sizeof(*conf));
+	conf->mirrors = kmalloc(sizeof(struct mirror_info)*mddev->raid_disks, 
+				 GFP_KERNEL);
+	if (!conf->mirrors) {
+		printk(KERN_ERR "raid1: couldn't allocate memory for md%d\n",
+		       mdidx(mddev));
+		goto out_free_conf;
+	}
 
 	conf->r1bio_pool = mempool_create(NR_RAID1_BIOS, r1bio_pool_alloc,
-						r1bio_pool_free, NULL);
+						r1bio_pool_free, mddev);
 	if (!conf->r1bio_pool) {
 		printk(KERN_ERR "raid1: couldn't allocate memory for md%d\n", 
 			mdidx(mddev));
-		goto out;
+		goto out_free_conf;
 	}
 
 
@@ -1169,6 +1180,8 @@ static int run(mddev_t *mddev)
 out_free_conf:
 	if (conf->r1bio_pool)
 		mempool_destroy(conf->r1bio_pool);
+	if (conf->mirrors)
+		kfree(conf->mirrors);
 	kfree(conf);
 	mddev->private = NULL;
 out:
@@ -1183,6 +1196,8 @@ static int stop(mddev_t *mddev)
 	mddev->thread = NULL;
 	if (conf->r1bio_pool)
 		mempool_destroy(conf->r1bio_pool);
+	if (conf->mirrors)
+		kfree(conf->mirrors);
 	kfree(conf);
 	mddev->private = NULL;
 	return 0;

diff ./include/linux/raid/raid1.h~current~ ./include/linux/raid/raid1.h
--- ./include/linux/raid/raid1.h~current~	2003-05-27 12:01:30.000000000 +1000
+++ ./include/linux/raid/raid1.h	2003-05-27 12:01:34.000000000 +1000
@@ -14,7 +14,7 @@ typedef struct r1bio_s r1bio_t;
 
 struct r1_private_data_s {
 	mddev_t			*mddev;
-	mirror_info_t		mirrors[MD_SB_DISKS];
+	mirror_info_t		*mirrors;
 	int			raid_disks;
 	int			working_disks;
 	int			last_used;
@@ -67,13 +67,14 @@ struct r1bio_s {
 	 */
 	struct bio		*read_bio;
 	int			read_disk;
-	/*
-	 * if the IO is in WRITE direction, then multiple bios are used:
-	 */
-	struct bio		*write_bios[MD_SB_DISKS];
 
 	r1bio_t			*next_r1; /* next for retry or in free list */
 	struct list_head	retry_list;
+	/*
+	 * if the IO is in WRITE direction, then multiple bios are used.
+	 * We choose the number when they are allocated.
+	 */
+	struct bio		*write_bios[0];
 };
 
 /* bits for r1bio.state */
