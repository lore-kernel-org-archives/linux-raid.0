From: Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH v3 12/14] md: raid10: don't use bio's vec table to manage resync pages
Date: Fri, 17 Mar 2017 00:12:33 +0800
Message-ID: <20170316161235.27110-13-tom.leiming@gmail.com>
References: <20170316161235.27110-1-tom.leiming@gmail.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170316161235.27110-1-tom.leiming@gmail.com>
Sender: linux-block-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@fb.com>, linux-raid@vger.kernel.org, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Cc: Ming Lei <tom.leiming@gmail.com>
List-Id: linux-raid.ids

Now we allocate one page array for managing resync pages, instead
of using bio's vec table to do that, and the old way is very hacky
and won't work any more if multipage bvec is enabled.

The introduced cost is that we need to allocate (128 + 16) * copies
bytes per r10_bio, and it is fine because the inflight r10_bio for
resync shouldn't be much, as pointed by Shaohua.

Also bio_reset() in raid10_sync_request() and reshape_request()
are removed because all bios are freshly new now in these functions
and not necessary to reset any more.

This patch can be thought as cleanup too.

Suggested-by: Shaohua Li <shli@kernel.org>
Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 drivers/md/raid10.c | 134 ++++++++++++++++++++++++++++++++--------------------
 1 file changed, 82 insertions(+), 52 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 98e53f39b66e..d2cb68971486 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -110,6 +110,24 @@ static void end_reshape(struct r10conf *conf);
 #define raid10_log(md, fmt, args...)				\
 	do { if ((md)->queue) blk_add_trace_msg((md)->queue, "raid10 " fmt, ##args); } while (0)
 
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
+ * for resync bio, r10bio pointer can be retrieved from the per-bio
+ * 'struct resync_pages'.
+ */
+static inline struct r10bio *get_resync_r10bio(struct bio *bio)
+{
+	return get_resync_pages(bio)->raid_bio;
+}
+
 static void * r10bio_pool_alloc(gfp_t gfp_flags, void *data)
 {
 	struct r10conf *conf = data;
@@ -140,11 +158,11 @@ static void r10bio_pool_free(void *r10_bio, void *data)
 static void * r10buf_pool_alloc(gfp_t gfp_flags, void *data)
 {
 	struct r10conf *conf = data;
-	struct page *page;
 	struct r10bio *r10_bio;
 	struct bio *bio;
-	int i, j;
-	int nalloc;
+	int j;
+	int nalloc, nalloc_rp;
+	struct resync_pages *rps;
 
 	r10_bio = r10bio_pool_alloc(gfp_flags, conf);
 	if (!r10_bio)
@@ -156,6 +174,15 @@ static void * r10buf_pool_alloc(gfp_t gfp_flags, void *data)
 	else
 		nalloc = 2; /* recovery */
 
+	/* allocate once for all bios */
+	if (!conf->have_replacement)
+		nalloc_rp = nalloc;
+	else
+		nalloc_rp = nalloc * 2;
+	rps = kmalloc(sizeof(struct resync_pages) * nalloc_rp, gfp_flags);
+	if (!rps)
+		goto out_free_r10bio;
+
 	/*
 	 * Allocate bios.
 	 */
@@ -175,36 +202,40 @@ static void * r10buf_pool_alloc(gfp_t gfp_flags, void *data)
 	 * Allocate RESYNC_PAGES data pages and attach them
 	 * where needed.
 	 */
-	for (j = 0 ; j < nalloc; j++) {
+	for (j = 0; j < nalloc; j++) {
 		struct bio *rbio = r10_bio->devs[j].repl_bio;
+		struct resync_pages *rp, *rp_repl;
+
+		rp = &rps[j];
+		if (rbio)
+			rp_repl = &rps[nalloc + j];
+
 		bio = r10_bio->devs[j].bio;
-		for (i = 0; i < RESYNC_PAGES; i++) {
-			if (j > 0 && !test_bit(MD_RECOVERY_SYNC,
-					       &conf->mddev->recovery)) {
-				/* we can share bv_page's during recovery
-				 * and reshape */
-				struct bio *rbio = r10_bio->devs[0].bio;
-				page = rbio->bi_io_vec[i].bv_page;
-				get_page(page);
-			} else
-				page = alloc_page(gfp_flags);
-			if (unlikely(!page))
+
+		if (!j || test_bit(MD_RECOVERY_SYNC,
+				   &conf->mddev->recovery)) {
+			if (resync_alloc_pages(rp, gfp_flags))
 				goto out_free_pages;
+		} else {
+			memcpy(rp, &rps[0], sizeof(*rp));
+			resync_get_all_pages(rp);
+		}
 
-			bio->bi_io_vec[i].bv_page = page;
-			if (rbio)
-				rbio->bi_io_vec[i].bv_page = page;
+		rp->idx = 0;
+		rp->raid_bio = r10_bio;
+		bio->bi_private = rp;
+		if (rbio) {
+			memcpy(rp_repl, rp, sizeof(*rp));
+			rbio->bi_private = rp_repl;
 		}
 	}
 
 	return r10_bio;
 
 out_free_pages:
-	for ( ; i > 0 ; i--)
-		safe_put_page(bio->bi_io_vec[i-1].bv_page);
-	while (j--)
-		for (i = 0; i < RESYNC_PAGES ; i++)
-			safe_put_page(r10_bio->devs[j].bio->bi_io_vec[i].bv_page);
+	while (--j >= 0)
+		resync_free_pages(&rps[j * 2]);
+
 	j = 0;
 out_free_bio:
 	for ( ; j < nalloc; j++) {
@@ -213,30 +244,34 @@ static void * r10buf_pool_alloc(gfp_t gfp_flags, void *data)
 		if (r10_bio->devs[j].repl_bio)
 			bio_put(r10_bio->devs[j].repl_bio);
 	}
+	kfree(rps);
+out_free_r10bio:
 	r10bio_pool_free(r10_bio, conf);
 	return NULL;
 }
 
 static void r10buf_pool_free(void *__r10_bio, void *data)
 {
-	int i;
 	struct r10conf *conf = data;
 	struct r10bio *r10bio = __r10_bio;
 	int j;
+	struct resync_pages *rp = NULL;
 
-	for (j=0; j < conf->copies; j++) {
+	for (j = conf->copies; j--; ) {
 		struct bio *bio = r10bio->devs[j].bio;
-		if (bio) {
-			for (i = 0; i < RESYNC_PAGES; i++) {
-				safe_put_page(bio->bi_io_vec[i].bv_page);
-				bio->bi_io_vec[i].bv_page = NULL;
-			}
-			bio_put(bio);
-		}
+
+		rp = get_resync_pages(bio);
+		resync_free_pages(rp);
+		bio_put(bio);
+
 		bio = r10bio->devs[j].repl_bio;
 		if (bio)
 			bio_put(bio);
 	}
+
+	/* resync pages array stored in the 1st bio's .bi_private */
+	kfree(rp);
+
 	r10bio_pool_free(r10bio, conf);
 }
 
@@ -1937,7 +1972,7 @@ static void __end_sync_read(struct r10bio *r10_bio, struct bio *bio, int d)
 
 static void end_sync_read(struct bio *bio)
 {
-	struct r10bio *r10_bio = bio->bi_private;
+	struct r10bio *r10_bio = get_resync_r10bio(bio);
 	struct r10conf *conf = r10_bio->mddev->private;
 	int d = find_bio_disk(conf, r10_bio, bio, NULL, NULL);
 
@@ -1946,6 +1981,7 @@ static void end_sync_read(struct bio *bio)
 
 static void end_reshape_read(struct bio *bio)
 {
+	/* reshape read bio isn't allocated from r10buf_pool */
 	struct r10bio *r10_bio = bio->bi_private;
 
 	__end_sync_read(r10_bio, bio, r10_bio->read_slot);
@@ -1980,7 +2016,7 @@ static void end_sync_request(struct r10bio *r10_bio)
 
 static void end_sync_write(struct bio *bio)
 {
-	struct r10bio *r10_bio = bio->bi_private;
+	struct r10bio *r10_bio = get_resync_r10bio(bio);
 	struct mddev *mddev = r10_bio->mddev;
 	struct r10conf *conf = mddev->private;
 	int d;
@@ -2060,6 +2096,7 @@ static void sync_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 	for (i=0 ; i < conf->copies ; i++) {
 		int  j, d;
 		struct md_rdev *rdev;
+		struct resync_pages *rp;
 
 		tbio = r10_bio->devs[i].bio;
 
@@ -2101,11 +2138,13 @@ static void sync_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 		 * First we need to fixup bv_offset, bv_len and
 		 * bi_vecs, as the read request might have corrupted these
 		 */
+		rp = get_resync_pages(tbio);
 		bio_reset(tbio);
 
 		tbio->bi_vcnt = vcnt;
 		tbio->bi_iter.bi_size = fbio->bi_iter.bi_size;
-		tbio->bi_private = r10_bio;
+		rp->raid_bio = r10_bio;
+		tbio->bi_private = rp;
 		tbio->bi_iter.bi_sector = r10_bio->devs[i].addr;
 		tbio->bi_end_io = end_sync_write;
 		bio_set_op_attrs(tbio, REQ_OP_WRITE, 0);
@@ -3173,10 +3212,8 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 					}
 				}
 				bio = r10_bio->devs[0].bio;
-				bio_reset(bio);
 				bio->bi_next = biolist;
 				biolist = bio;
-				bio->bi_private = r10_bio;
 				bio->bi_end_io = end_sync_read;
 				bio_set_op_attrs(bio, REQ_OP_READ, 0);
 				if (test_bit(FailFast, &rdev->flags))
@@ -3200,10 +3237,8 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 
 				if (!test_bit(In_sync, &mrdev->flags)) {
 					bio = r10_bio->devs[1].bio;
-					bio_reset(bio);
 					bio->bi_next = biolist;
 					biolist = bio;
-					bio->bi_private = r10_bio;
 					bio->bi_end_io = end_sync_write;
 					bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
 					bio->bi_iter.bi_sector = to_addr
@@ -3228,10 +3263,8 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 				if (mreplace == NULL || bio == NULL ||
 				    test_bit(Faulty, &mreplace->flags))
 					break;
-				bio_reset(bio);
 				bio->bi_next = biolist;
 				biolist = bio;
-				bio->bi_private = r10_bio;
 				bio->bi_end_io = end_sync_write;
 				bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
 				bio->bi_iter.bi_sector = to_addr +
@@ -3353,7 +3386,6 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 				r10_bio->devs[i].repl_bio->bi_end_io = NULL;
 
 			bio = r10_bio->devs[i].bio;
-			bio_reset(bio);
 			bio->bi_error = -EIO;
 			rcu_read_lock();
 			rdev = rcu_dereference(conf->mirrors[d].rdev);
@@ -3378,7 +3410,6 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 			atomic_inc(&r10_bio->remaining);
 			bio->bi_next = biolist;
 			biolist = bio;
-			bio->bi_private = r10_bio;
 			bio->bi_end_io = end_sync_read;
 			bio_set_op_attrs(bio, REQ_OP_READ, 0);
 			if (test_bit(FailFast, &conf->mirrors[d].rdev->flags))
@@ -3397,13 +3428,11 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 
 			/* Need to set up for writing to the replacement */
 			bio = r10_bio->devs[i].repl_bio;
-			bio_reset(bio);
 			bio->bi_error = -EIO;
 
 			sector = r10_bio->devs[i].addr;
 			bio->bi_next = biolist;
 			biolist = bio;
-			bio->bi_private = r10_bio;
 			bio->bi_end_io = end_sync_write;
 			bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
 			if (test_bit(FailFast, &conf->mirrors[d].rdev->flags))
@@ -3442,7 +3471,8 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 		if (len == 0)
 			break;
 		for (bio= biolist ; bio ; bio=bio->bi_next) {
-			page = bio->bi_io_vec[bio->bi_vcnt].bv_page;
+			struct resync_pages *rp = get_resync_pages(bio);
+			page = resync_fetch_page(rp, rp->idx++);
 			/*
 			 * won't fail because the vec table is big enough
 			 * to hold all these pages
@@ -3451,7 +3481,7 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 		}
 		nr_sectors += len>>9;
 		sector_nr += len>>9;
-	} while (biolist->bi_vcnt < RESYNC_PAGES);
+	} while (get_resync_pages(biolist)->idx < RESYNC_PAGES);
 	r10_bio->sectors = nr_sectors;
 
 	while (biolist) {
@@ -3459,7 +3489,7 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 		biolist = biolist->bi_next;
 
 		bio->bi_next = NULL;
-		r10_bio = bio->bi_private;
+		r10_bio = get_resync_r10bio(bio);
 		r10_bio->sectors = nr_sectors;
 
 		if (bio->bi_end_io == end_sync_read) {
@@ -4354,6 +4384,7 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr,
 	struct bio *blist;
 	struct bio *bio, *read_bio;
 	int sectors_done = 0;
+	struct page **pages;
 
 	if (sector_nr == 0) {
 		/* If restarting in the middle, skip the initial sectors */
@@ -4504,11 +4535,9 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr,
 		if (!rdev2 || test_bit(Faulty, &rdev2->flags))
 			continue;
 
-		bio_reset(b);
 		b->bi_bdev = rdev2->bdev;
 		b->bi_iter.bi_sector = r10_bio->devs[s/2].addr +
 			rdev2->new_data_offset;
-		b->bi_private = r10_bio;
 		b->bi_end_io = end_reshape_write;
 		bio_set_op_attrs(b, REQ_OP_WRITE, 0);
 		b->bi_next = blist;
@@ -4518,8 +4547,9 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr,
 	/* Now add as many pages as possible to all of these bios. */
 
 	nr_sectors = 0;
+	pages = get_resync_pages(r10_bio->devs[0].bio)->pages;
 	for (s = 0 ; s < max_sectors; s += PAGE_SIZE >> 9) {
-		struct page *page = r10_bio->devs[0].bio->bi_io_vec[s/(PAGE_SIZE>>9)].bv_page;
+		struct page *page = pages[s / (PAGE_SIZE >> 9)];
 		int len = (max_sectors - s) << 9;
 		if (len > PAGE_SIZE)
 			len = PAGE_SIZE;
@@ -4703,7 +4733,7 @@ static int handle_reshape_read_error(struct mddev *mddev,
 
 static void end_reshape_write(struct bio *bio)
 {
-	struct r10bio *r10_bio = bio->bi_private;
+	struct r10bio *r10_bio = get_resync_r10bio(bio);
 	struct mddev *mddev = r10_bio->mddev;
 	struct r10conf *conf = mddev->private;
 	int d;
-- 
2.9.3
