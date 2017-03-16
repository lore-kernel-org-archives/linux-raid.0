From: Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH v3 05/14] md: raid1: don't use bio's vec table to manage resync pages
Date: Fri, 17 Mar 2017 00:12:26 +0800
Message-ID: <20170316161235.27110-6-tom.leiming@gmail.com>
References: <20170316161235.27110-1-tom.leiming@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170316161235.27110-1-tom.leiming@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@fb.com>, linux-raid@vger.kernel.org, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Cc: Ming Lei <tom.leiming@gmail.com>
List-Id: linux-raid.ids

Now we allocate one page array for managing resync pages, instead
of using bio's vec table to do that, and the old way is very hacky
and won't work any more if multipage bvec is enabled.

The introduced cost is that we need to allocate (128 + 16) * raid_disks
bytes per r1_bio, and it is fine because the inflight r1_bio for
resync shouldn't be much, as pointed by Shaohua.

Also the bio_reset() in raid1_sync_request() is removed because
all bios are freshly new now and not necessary to reset any more.

This patch can be thought as a cleanup too

Suggested-by: Shaohua Li <shli@kernel.org>
Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 drivers/md/raid1.c | 94 +++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 64 insertions(+), 30 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index e30d89690109..0e64beb60e4d 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -80,6 +80,24 @@ static void lower_barrier(struct r1conf *conf, sector_t sector_nr);
 #define raid1_log(md, fmt, args...)				\
 	do { if ((md)->queue) blk_add_trace_msg((md)->queue, "raid1 " fmt, ##args); } while (0)
 
+/*
+ * 'strct resync_pages' stores actual pages used for doing the resync
+ *  IO, and it is per-bio, so make .bi_private points to it.
+ */
+static inline struct resync_pages *get_resync_pages(struct bio *bio)
+{
+	return bio->bi_private;
+}
+
+/*
+ * for resync bio, r1bio pointer can be retrieved from the per-bio
+ * 'struct resync_pages'.
+ */
+static inline struct r1bio *get_resync_r1bio(struct bio *bio)
+{
+	return get_resync_pages(bio)->raid_bio;
+}
+
 static void * r1bio_pool_alloc(gfp_t gfp_flags, void *data)
 {
 	struct pool_info *pi = data;
@@ -107,12 +125,18 @@ static void * r1buf_pool_alloc(gfp_t gfp_flags, void *data)
 	struct r1bio *r1_bio;
 	struct bio *bio;
 	int need_pages;
-	int i, j;
+	int j;
+	struct resync_pages *rps;
 
 	r1_bio = r1bio_pool_alloc(gfp_flags, pi);
 	if (!r1_bio)
 		return NULL;
 
+	rps = kmalloc(sizeof(struct resync_pages) * pi->raid_disks,
+		      gfp_flags);
+	if (!rps)
+		goto out_free_r1bio;
+
 	/*
 	 * Allocate bios : 1 for reading, n-1 for writing
 	 */
@@ -132,22 +156,22 @@ static void * r1buf_pool_alloc(gfp_t gfp_flags, void *data)
 		need_pages = pi->raid_disks;
 	else
 		need_pages = 1;
-	for (j = 0; j < need_pages; j++) {
+	for (j = 0; j < pi->raid_disks; j++) {
+		struct resync_pages *rp = &rps[j];
+
 		bio = r1_bio->bios[j];
-		bio->bi_vcnt = RESYNC_PAGES;
-
-		if (bio_alloc_pages(bio, gfp_flags))
-			goto out_free_pages;
-	}
-	/* If not user-requests, copy the page pointers to all bios */
-	if (!test_bit(MD_RECOVERY_REQUESTED, &pi->mddev->recovery)) {
-		for (i=0; i<RESYNC_PAGES ; i++)
-			for (j=1; j<pi->raid_disks; j++) {
-				struct page *page =
-					r1_bio->bios[0]->bi_io_vec[i].bv_page;
-				get_page(page);
-				r1_bio->bios[j]->bi_io_vec[i].bv_page = page;
-			}
+
+		if (j < need_pages) {
+			if (resync_alloc_pages(rp, gfp_flags))
+				goto out_free_pages;
+		} else {
+			memcpy(rp, &rps[0], sizeof(*rp));
+			resync_get_all_pages(rp);
+		}
+
+		rp->idx = 0;
+		rp->raid_bio = r1_bio;
+		bio->bi_private = rp;
 	}
 
 	r1_bio->master_bio = NULL;
@@ -156,11 +180,14 @@ static void * r1buf_pool_alloc(gfp_t gfp_flags, void *data)
 
 out_free_pages:
 	while (--j >= 0)
-		bio_free_pages(r1_bio->bios[j]);
+		resync_free_pages(&rps[j]);
 
 out_free_bio:
 	while (++j < pi->raid_disks)
 		bio_put(r1_bio->bios[j]);
+	kfree(rps);
+
+out_free_r1bio:
 	r1bio_pool_free(r1_bio, data);
 	return NULL;
 }
@@ -168,14 +195,18 @@ static void * r1buf_pool_alloc(gfp_t gfp_flags, void *data)
 static void r1buf_pool_free(void *__r1_bio, void *data)
 {
 	struct pool_info *pi = data;
-	int i,j;
+	int i;
 	struct r1bio *r1bio = __r1_bio;
+	struct resync_pages *rp = NULL;
 
-	for (i = 0; i < RESYNC_PAGES; i++)
-		for (j = pi->raid_disks; j-- ;)
-			safe_put_page(r1bio->bios[j]->bi_io_vec[i].bv_page);
-	for (i=0 ; i < pi->raid_disks; i++)
+	for (i = pi->raid_disks; i--; ) {
+		rp = get_resync_pages(r1bio->bios[i]);
+		resync_free_pages(rp);
 		bio_put(r1bio->bios[i]);
+	}
+
+	/* resync pages array stored in the 1st bio's .bi_private */
+	kfree(rp);
 
 	r1bio_pool_free(r1bio, data);
 }
@@ -1863,7 +1894,7 @@ static int raid1_remove_disk(struct mddev *mddev, struct md_rdev *rdev)
 
 static void end_sync_read(struct bio *bio)
 {
-	struct r1bio *r1_bio = bio->bi_private;
+	struct r1bio *r1_bio = get_resync_r1bio(bio);
 
 	update_head_pos(r1_bio->read_disk, r1_bio);
 
@@ -1882,7 +1913,7 @@ static void end_sync_read(struct bio *bio)
 static void end_sync_write(struct bio *bio)
 {
 	int uptodate = !bio->bi_error;
-	struct r1bio *r1_bio = bio->bi_private;
+	struct r1bio *r1_bio = get_resync_r1bio(bio);
 	struct mddev *mddev = r1_bio->mddev;
 	struct r1conf *conf = mddev->private;
 	sector_t first_bad;
@@ -2099,6 +2130,7 @@ static void process_checks(struct r1bio *r1_bio)
 		int size;
 		int error;
 		struct bio *b = r1_bio->bios[i];
+		struct resync_pages *rp = get_resync_pages(b);
 		if (b->bi_end_io != end_sync_read)
 			continue;
 		/* fixup the bio for reuse, but preserve errno */
@@ -2111,7 +2143,8 @@ static void process_checks(struct r1bio *r1_bio)
 			conf->mirrors[i].rdev->data_offset;
 		b->bi_bdev = conf->mirrors[i].rdev->bdev;
 		b->bi_end_io = end_sync_read;
-		b->bi_private = r1_bio;
+		rp->raid_bio = r1_bio;
+		b->bi_private = rp;
 
 		size = b->bi_iter.bi_size;
 		for (j = 0; j < vcnt ; j++) {
@@ -2769,7 +2802,6 @@ static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
 	for (i = 0; i < conf->raid_disks * 2; i++) {
 		struct md_rdev *rdev;
 		bio = r1_bio->bios[i];
-		bio_reset(bio);
 
 		rdev = rcu_dereference(conf->mirrors[i].rdev);
 		if (rdev == NULL ||
@@ -2825,7 +2857,6 @@ static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
 			atomic_inc(&rdev->nr_pending);
 			bio->bi_iter.bi_sector = sector_nr + rdev->data_offset;
 			bio->bi_bdev = rdev->bdev;
-			bio->bi_private = r1_bio;
 			if (test_bit(FailFast, &rdev->flags))
 				bio->bi_opf |= MD_FAILFAST;
 		}
@@ -2911,9 +2942,12 @@ static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
 		}
 
 		for (i = 0 ; i < conf->raid_disks * 2; i++) {
+			struct resync_pages *rp;
+
 			bio = r1_bio->bios[i];
+			rp = get_resync_pages(bio);
 			if (bio->bi_end_io) {
-				page = bio->bi_io_vec[bio->bi_vcnt].bv_page;
+				page = resync_fetch_page(rp, rp->idx++);
 
 				/*
 				 * won't fail because the vec table is big
@@ -2925,8 +2959,8 @@ static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
 		nr_sectors += len>>9;
 		sector_nr += len>>9;
 		sync_blocks -= (len>>9);
-	} while (r1_bio->bios[disk]->bi_vcnt < RESYNC_PAGES);
- bio_full:
+	} while (get_resync_pages(r1_bio->bios[disk]->bi_private)->idx < RESYNC_PAGES);
+
 	r1_bio->sectors = nr_sectors;
 
 	if (mddev_is_clustered(mddev) &&
-- 
2.9.3

