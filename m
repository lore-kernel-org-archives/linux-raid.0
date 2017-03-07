From: Song Liu <songliubraving@fb.com>
Subject: [PATCH v2] md/r5cache: improve recovery with read ahead page pool
Date: Tue, 7 Mar 2017 13:47:01 -0800
Message-ID: <20170307214702.3527217-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@fb.com, neilb@suse.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

In r5cache recovery, the journal device is scanned page by page.
Currently, we use sync_page_io() to read journal device. This is
not efficient when we have to recovery many stripes from the journal.

To improve the speed of recovery, this patch introduces a read ahead
page pool (ra_pool) to recovery_ctx. With ra_pool, multiple consecutive
pages are read in one IO. Then the recovery code read the journal from
ra_pool.

With ra_pool, r5l_recovery_ctx has become much bigger. Therefore,
r5l_recovery_log() is refactored so r5l_recovery_ctx is not using
stack space.

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 drivers/md/raid5-cache.c | 225 +++++++++++++++++++++++++++++++++++++----------
 1 file changed, 178 insertions(+), 47 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 3f307be..73a24ab 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -30,6 +30,7 @@
  * underneath hardware sector size. only works with PAGE_SIZE == 4096
  */
 #define BLOCK_SECTORS (8)
+#define BLOCK_SECTOR_SHIFT (3)
 
 /*
  * log->max_free_space is min(1/4 disk size, 10G reclaimable space).
@@ -1552,6 +1553,8 @@ bool r5l_log_disk_error(struct r5conf *conf)
 	return ret;
 }
 
+#define R5L_RECOVERY_PAGE_POOL_SIZE 256
+
 struct r5l_recovery_ctx {
 	struct page *meta_page;		/* current meta */
 	sector_t meta_total_blocks;	/* total size of current meta and data */
@@ -1560,18 +1563,131 @@ struct r5l_recovery_ctx {
 	int data_parity_stripes;	/* number of data_parity stripes */
 	int data_only_stripes;		/* number of data_only stripes */
 	struct list_head cached_list;
+
+	/*
+	 * read ahead page pool (ra_pool)
+	 * in recovery, log is read sequentially. It is not efficient to
+	 * read every page with sync_page_io(). The read ahead page pool
+	 * reads multiple pages with one IO, so further log read can
+	 * just copy data from the pool.
+	 */
+	struct page *ra_pool[R5L_RECOVERY_PAGE_POOL_SIZE];
+	sector_t pool_offset;	/* offset of first page in the pool */
+	int total_pages;	/* total allocated pages */
+	int valid_pages;	/* pages with valid data */
+	struct bio *ra_bio;	/* bio to do the read ahead */
 };
 
+static int r5l_recovery_allocate_ra_pool(struct r5l_log *log,
+					    struct r5l_recovery_ctx *ctx)
+{
+	struct page *page;
+
+	ctx->ra_bio = bio_alloc_bioset(GFP_KERNEL, BIO_MAX_PAGES, log->bs);
+	if (!ctx->ra_bio)
+		return -ENOMEM;
+
+	ctx->valid_pages = 0;
+	ctx->total_pages = 0;
+	while (ctx->total_pages < R5L_RECOVERY_PAGE_POOL_SIZE) {
+		page = alloc_page(GFP_KERNEL);
+
+		if (!page)
+			break;
+		ctx->ra_pool[ctx->total_pages] = page;
+		ctx->total_pages += 1;
+	}
+
+	if (ctx->total_pages == 0) {
+		bio_put(ctx->ra_bio);
+		return -ENOMEM;
+	}
+
+	ctx->pool_offset = 0;
+	return 0;
+}
+
+static void r5l_recovery_free_ra_pool(struct r5l_log *log,
+					struct r5l_recovery_ctx *ctx)
+{
+	int i;
+
+	for (i = 0; i < ctx->total_pages; ++i)
+		put_page(ctx->ra_pool[i]);
+	bio_put(ctx->ra_bio);
+}
+
+/*
+ * fetch ctx->valid_pages pages from offset
+ * In normal cases, ctx->valid_pages == ctx->total_pages after the call.
+ * However, if the offset is close to the end of the journal device,
+ * ctx->valid_pages could be smaller than ctx->total_pages
+ */
+static int r5l_recovery_fetch_ra_pool(struct r5l_log *log,
+				      struct r5l_recovery_ctx *ctx,
+				      sector_t offset)
+{
+	bio_reset(ctx->ra_bio);
+	ctx->ra_bio->bi_bdev = log->rdev->bdev;
+	bio_set_op_attrs(ctx->ra_bio, REQ_OP_READ, 0);
+	ctx->ra_bio->bi_iter.bi_sector = log->rdev->data_offset + offset;
+
+	ctx->valid_pages = 0;
+	ctx->pool_offset = offset;
+
+	while (ctx->valid_pages < ctx->total_pages) {
+		bio_add_page(ctx->ra_bio,
+			     ctx->ra_pool[ctx->valid_pages], PAGE_SIZE, 0);
+		ctx->valid_pages += 1;
+
+		offset = r5l_ring_add(log, offset, BLOCK_SECTORS);
+
+		if (offset == 0)  /* reached end of the device */
+			break;
+	}
+
+	return submit_bio_wait(ctx->ra_bio);
+}
+
+/*
+ * try read a page from the read ahead page pool, if the page is not in the
+ * pool, call r5l_recovery_fetch_ra_pool
+ */
+static int r5l_recovery_read_page(struct r5l_log *log,
+				  struct r5l_recovery_ctx *ctx,
+				  struct page *page,
+				  sector_t offset)
+{
+	int ret;
+
+	if (offset < ctx->pool_offset ||
+	    offset >= ctx->pool_offset + ctx->valid_pages * BLOCK_SECTORS) {
+		ret = r5l_recovery_fetch_ra_pool(log, ctx, offset);
+		if (ret)
+			return ret;
+	}
+
+	BUG_ON(offset < ctx->pool_offset ||
+	       offset >= ctx->pool_offset + ctx->valid_pages * BLOCK_SECTORS);
+
+	memcpy(page_address(page),
+	       page_address(ctx->ra_pool[(offset - ctx->pool_offset) >>
+					 BLOCK_SECTOR_SHIFT]),
+	       PAGE_SIZE);
+	return 0;
+}
+
 static int r5l_recovery_read_meta_block(struct r5l_log *log,
 					struct r5l_recovery_ctx *ctx)
 {
 	struct page *page = ctx->meta_page;
 	struct r5l_meta_block *mb;
 	u32 crc, stored_crc;
+	int ret;
 
-	if (!sync_page_io(log->rdev, ctx->pos, PAGE_SIZE, page, REQ_OP_READ, 0,
-			  false))
-		return -EIO;
+	ret = r5l_recovery_read_page(log, ctx, page, ctx->pos);
+	if (ret != 0)
+		return ret;
 
 	mb = page_address(page);
 	stored_crc = le32_to_cpu(mb->checksum);
@@ -1653,8 +1769,7 @@ static void r5l_recovery_load_data(struct r5l_log *log,
 	raid5_compute_sector(conf,
 			     le64_to_cpu(payload->location), 0,
 			     &dd_idx, sh);
-	sync_page_io(log->rdev, log_offset, PAGE_SIZE,
-		     sh->dev[dd_idx].page, REQ_OP_READ, 0, false);
+	r5l_recovery_read_page(log, ctx, sh->dev[dd_idx].page, log_offset);
 	sh->dev[dd_idx].log_checksum =
 		le32_to_cpu(payload->checksum[0]);
 	ctx->meta_total_blocks += BLOCK_SECTORS;
@@ -1673,17 +1788,15 @@ static void r5l_recovery_load_parity(struct r5l_log *log,
 	struct r5conf *conf = mddev->private;
 
 	ctx->meta_total_blocks += BLOCK_SECTORS * conf->max_degraded;
-	sync_page_io(log->rdev, log_offset, PAGE_SIZE,
-		     sh->dev[sh->pd_idx].page, REQ_OP_READ, 0, false);
+	r5l_recovery_read_page(log, ctx, sh->dev[sh->pd_idx].page, log_offset);
 	sh->dev[sh->pd_idx].log_checksum =
 		le32_to_cpu(payload->checksum[0]);
 	set_bit(R5_Wantwrite, &sh->dev[sh->pd_idx].flags);
 
 	if (sh->qd_idx >= 0) {
-		sync_page_io(log->rdev,
-			     r5l_ring_add(log, log_offset, BLOCK_SECTORS),
-			     PAGE_SIZE, sh->dev[sh->qd_idx].page,
-			     REQ_OP_READ, 0, false);
+		r5l_recovery_read_page(
+			log, ctx, sh->dev[sh->qd_idx].page,
+			r5l_ring_add(log, log_offset, BLOCK_SECTORS));
 		sh->dev[sh->qd_idx].log_checksum =
 			le32_to_cpu(payload->checksum[1]);
 		set_bit(R5_Wantwrite, &sh->dev[sh->qd_idx].flags);
@@ -1814,14 +1927,15 @@ r5c_recovery_replay_stripes(struct list_head *cached_stripe_list,
 
 /* if matches return 0; otherwise return -EINVAL */
 static int
-r5l_recovery_verify_data_checksum(struct r5l_log *log, struct page *page,
+r5l_recovery_verify_data_checksum(struct r5l_log *log,
+				  struct r5l_recovery_ctx *ctx,
+				  struct page *page,
 				  sector_t log_offset, __le32 log_checksum)
 {
 	void *addr;
 	u32 checksum;
 
-	sync_page_io(log->rdev, log_offset, PAGE_SIZE,
-		     page, REQ_OP_READ, 0, false);
+	r5l_recovery_read_page(log, ctx, page, log_offset);
 	addr = kmap_atomic(page);
 	checksum = crc32c_le(log->uuid_checksum, addr, PAGE_SIZE);
 	kunmap_atomic(addr);
@@ -1853,17 +1967,17 @@ r5l_recovery_verify_data_checksum_for_mb(struct r5l_log *log,
 
 		if (payload->header.type == R5LOG_PAYLOAD_DATA) {
 			if (r5l_recovery_verify_data_checksum(
-				    log, page, log_offset,
+				    log, ctx, page, log_offset,
 				    payload->checksum[0]) < 0)
 				goto mismatch;
 		} else if (payload->header.type == R5LOG_PAYLOAD_PARITY) {
 			if (r5l_recovery_verify_data_checksum(
-				    log, page, log_offset,
+				    log, ctx, page, log_offset,
 				    payload->checksum[0]) < 0)
 				goto mismatch;
 			if (conf->max_degraded == 2 && /* q for RAID 6 */
 			    r5l_recovery_verify_data_checksum(
-				    log, page,
+				    log, ctx, page,
 				    r5l_ring_add(log, log_offset,
 						 BLOCK_SECTORS),
 				    payload->checksum[1]) < 0)
@@ -2241,55 +2355,72 @@ static void r5c_recovery_flush_data_only_stripes(struct r5l_log *log,
 static int r5l_recovery_log(struct r5l_log *log)
 {
 	struct mddev *mddev = log->rdev->mddev;
-	struct r5l_recovery_ctx ctx;
+	struct r5l_recovery_ctx *ctx;
 	int ret;
 	sector_t pos;
 
-	ctx.pos = log->last_checkpoint;
-	ctx.seq = log->last_cp_seq;
-	ctx.meta_page = alloc_page(GFP_KERNEL);
-	ctx.data_only_stripes = 0;
-	ctx.data_parity_stripes = 0;
-	INIT_LIST_HEAD(&ctx.cached_list);
-
-	if (!ctx.meta_page)
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
+	if (!ctx)
 		return -ENOMEM;
 
-	ret = r5c_recovery_flush_log(log, &ctx);
-	__free_page(ctx.meta_page);
+	ctx->pos = log->last_checkpoint;
+	ctx->seq = log->last_cp_seq;
+	ctx->data_only_stripes = 0;
+	ctx->data_parity_stripes = 0;
+	INIT_LIST_HEAD(&ctx->cached_list);
+	ctx->meta_page = alloc_page(GFP_KERNEL);
 
-	if (ret)
-		return ret;
+	if (!ctx->meta_page) {
+		ret =  -ENOMEM;
+		goto meta_page;
+	}
+
+	if (r5l_recovery_allocate_ra_pool(log, ctx) != 0) {
+		ret = -ENOMEM;
+		goto ra_pool;
+	}
 
-	pos = ctx.pos;
-	ctx.seq += 10000;
+	ret = r5c_recovery_flush_log(log, ctx);
 
+	if (ret)
+		goto error;
 
-	if ((ctx.data_only_stripes == 0) && (ctx.data_parity_stripes == 0))
+	pos = ctx->pos;
+	ctx->seq += 10000;
+
+	if ((ctx->data_only_stripes == 0) && (ctx->data_parity_stripes == 0))
 		pr_debug("md/raid:%s: starting from clean shutdown\n",
 			 mdname(mddev));
 	else
-		pr_debug("md/raid:%s: recovering %d data-only stripes and %d data-parity stripes\n",
-			 mdname(mddev), ctx.data_only_stripes,
-			 ctx.data_parity_stripes);
-
-	if (ctx.data_only_stripes == 0) {
-		log->next_checkpoint = ctx.pos;
-		r5l_log_write_empty_meta_block(log, ctx.pos, ctx.seq++);
-		ctx.pos = r5l_ring_add(log, ctx.pos, BLOCK_SECTORS);
-	} else if (r5c_recovery_rewrite_data_only_stripes(log, &ctx)) {
+		pr_info("md/raid:%s: recovering %d data-only stripes and %d data-parity stripes\n",
+			 mdname(mddev), ctx->data_only_stripes,
+			 ctx->data_parity_stripes);
+
+	if (ctx->data_only_stripes == 0) {
+		log->next_checkpoint = ctx->pos;
+		r5l_log_write_empty_meta_block(log, ctx->pos, ctx->seq++);
+		ctx->pos = r5l_ring_add(log, ctx->pos, BLOCK_SECTORS);
+	} else if (r5c_recovery_rewrite_data_only_stripes(log, ctx)) {
 		pr_err("md/raid:%s: failed to rewrite stripes to journal\n",
 		       mdname(mddev));
-		return -EIO;
+		ret =  -EIO;
+		goto error;
 	}
 
-	log->log_start = ctx.pos;
-	log->seq = ctx.seq;
+	log->log_start = ctx->pos;
+	log->seq = ctx->seq;
 	log->last_checkpoint = pos;
 	r5l_write_super(log, pos);
 
-	r5c_recovery_flush_data_only_stripes(log, &ctx);
-	return 0;
+	r5c_recovery_flush_data_only_stripes(log, ctx);
+	ret = 0;
+error:
+	r5l_recovery_free_ra_pool(log, ctx);
+ra_pool:
+	__free_page(ctx->meta_page);
+meta_page:
+	kfree(ctx);
+	return ret;
 }
 
 static void r5l_write_super(struct r5l_log *log, sector_t cp)
-- 
2.9.3

