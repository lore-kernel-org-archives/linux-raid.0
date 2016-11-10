From: Song Liu <songliubraving@fb.com>
Subject: [PATCH v6 09/11] md/r5cache: r5cache recovery: part 2
Date: Thu, 10 Nov 2016 12:46:21 -0800
Message-ID: <20161110204623.3484694-10-songliubraving@fb.com>
References: <20161110204623.3484694-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161110204623.3484694-1-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.com, shli@fb.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, liuzhengyuang521@gmail.com, liuzhengyuan@kylinos.cn, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

1. In previous patch, we:
      - add new data to r5l_recovery_ctx
      - add new functions to recovery write-back cache
   The new functions are not used in this patch, so this patch does not
   change the behavior of recovery.

2. In this patchpatch, we:
      - modify main recovery procedure r5l_recovery_log() to call new
        functions
      - remove old functions

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 drivers/md/raid5-cache.c | 198 ++++++-----------------------------------------
 drivers/md/raid5.c       |   3 +-
 2 files changed, 26 insertions(+), 175 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 44af32d..c6b6840 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -1390,144 +1390,6 @@ static int r5l_recovery_read_meta_block(struct r5l_log *log,
 	return 0;
 }
 
-static int r5l_recovery_flush_one_stripe(struct r5l_log *log,
-					 struct r5l_recovery_ctx *ctx,
-					 sector_t stripe_sect,
-					 int *offset)
-{
-	struct r5conf *conf = log->rdev->mddev->private;
-	struct stripe_head *sh;
-	struct r5l_payload_data_parity *payload;
-	int disk_index;
-
-	sh = raid5_get_active_stripe(conf, stripe_sect, 0, 0, 0);
-	while (1) {
-		sector_t log_offset = r5l_ring_add(log, ctx->pos,
-				ctx->meta_total_blocks);
-		payload = page_address(ctx->meta_page) + *offset;
-
-		if (le16_to_cpu(payload->header.type) == R5LOG_PAYLOAD_DATA) {
-			raid5_compute_sector(conf,
-					     le64_to_cpu(payload->location), 0,
-					     &disk_index, sh);
-
-			sync_page_io(log->rdev, log_offset, PAGE_SIZE,
-				     sh->dev[disk_index].page, REQ_OP_READ, 0,
-				     false);
-			sh->dev[disk_index].log_checksum =
-				le32_to_cpu(payload->checksum[0]);
-			set_bit(R5_Wantwrite, &sh->dev[disk_index].flags);
-		} else {
-			disk_index = sh->pd_idx;
-			sync_page_io(log->rdev, log_offset, PAGE_SIZE,
-				     sh->dev[disk_index].page, REQ_OP_READ, 0,
-				     false);
-			sh->dev[disk_index].log_checksum =
-				le32_to_cpu(payload->checksum[0]);
-			set_bit(R5_Wantwrite, &sh->dev[disk_index].flags);
-
-			if (sh->qd_idx >= 0) {
-				disk_index = sh->qd_idx;
-				sync_page_io(log->rdev,
-					     r5l_ring_add(log, log_offset, BLOCK_SECTORS),
-					     PAGE_SIZE, sh->dev[disk_index].page,
-					     REQ_OP_READ, 0, false);
-				sh->dev[disk_index].log_checksum =
-					le32_to_cpu(payload->checksum[1]);
-				set_bit(R5_Wantwrite,
-					&sh->dev[disk_index].flags);
-			}
-		}
-
-		ctx->meta_total_blocks += le32_to_cpu(payload->size);
-		*offset += sizeof(struct r5l_payload_data_parity) +
-			sizeof(__le32) *
-			(le32_to_cpu(payload->size) >> (PAGE_SHIFT - 9));
-		if (le16_to_cpu(payload->header.type) == R5LOG_PAYLOAD_PARITY)
-			break;
-	}
-
-	for (disk_index = 0; disk_index < sh->disks; disk_index++) {
-		void *addr;
-		u32 checksum;
-
-		if (!test_bit(R5_Wantwrite, &sh->dev[disk_index].flags))
-			continue;
-		addr = kmap_atomic(sh->dev[disk_index].page);
-		checksum = crc32c_le(log->uuid_checksum, addr, PAGE_SIZE);
-		kunmap_atomic(addr);
-		if (checksum != sh->dev[disk_index].log_checksum)
-			goto error;
-	}
-
-	for (disk_index = 0; disk_index < sh->disks; disk_index++) {
-		struct md_rdev *rdev, *rrdev;
-
-		if (!test_and_clear_bit(R5_Wantwrite,
-					&sh->dev[disk_index].flags))
-			continue;
-
-		/* in case device is broken */
-		rdev = rcu_dereference(conf->disks[disk_index].rdev);
-		if (rdev)
-			sync_page_io(rdev, stripe_sect, PAGE_SIZE,
-				     sh->dev[disk_index].page, REQ_OP_WRITE, 0,
-				     false);
-		rrdev = rcu_dereference(conf->disks[disk_index].replacement);
-		if (rrdev)
-			sync_page_io(rrdev, stripe_sect, PAGE_SIZE,
-				     sh->dev[disk_index].page, REQ_OP_WRITE, 0,
-				     false);
-	}
-	raid5_release_stripe(sh);
-	return 0;
-
-error:
-	for (disk_index = 0; disk_index < sh->disks; disk_index++)
-		sh->dev[disk_index].flags = 0;
-	raid5_release_stripe(sh);
-	return -EINVAL;
-}
-
-static int r5l_recovery_flush_one_meta(struct r5l_log *log,
-				       struct r5l_recovery_ctx *ctx)
-{
-	struct r5conf *conf = log->rdev->mddev->private;
-	struct r5l_payload_data_parity *payload;
-	struct r5l_meta_block *mb;
-	int offset;
-	sector_t stripe_sector;
-
-	mb = page_address(ctx->meta_page);
-	offset = sizeof(struct r5l_meta_block);
-
-	while (offset < le32_to_cpu(mb->meta_size)) {
-		int dd;
-
-		payload = (void *)mb + offset;
-		stripe_sector = raid5_compute_sector(conf,
-						     le64_to_cpu(payload->location), 0, &dd, NULL);
-		if (r5l_recovery_flush_one_stripe(log, ctx, stripe_sector,
-						  &offset))
-			return -EINVAL;
-	}
-	return 0;
-}
-
-/* copy data/parity from log to raid disks */
-static void r5l_recovery_flush_log(struct r5l_log *log,
-				   struct r5l_recovery_ctx *ctx)
-{
-	while (1) {
-		if (r5l_recovery_read_meta_block(log, ctx))
-			return;
-		if (r5l_recovery_flush_one_meta(log, ctx))
-			return;
-		ctx->seq++;
-		ctx->pos = r5l_ring_add(log, ctx->pos, ctx->meta_total_blocks);
-	}
-}
-
 static void
 r5l_recovery_create_empty_meta_block(struct r5l_log *log,
 				     struct page *page,
@@ -2139,7 +2001,9 @@ r5c_recovery_rewrite_data_only_stripes(struct r5l_log *log,
 
 static int r5l_recovery_log(struct r5l_log *log)
 {
+	struct mddev *mddev = log->rdev->mddev;
 	struct r5l_recovery_ctx ctx;
+	int ret;
 
 	ctx.pos = log->last_checkpoint;
 	ctx.seq = log->last_cp_seq;
@@ -2151,47 +2015,33 @@ static int r5l_recovery_log(struct r5l_log *log)
 	if (!ctx.meta_page)
 		return -ENOMEM;
 
-	r5l_recovery_flush_log(log, &ctx);
+	ret = r5c_recovery_flush_log(log, &ctx);
 	__free_page(ctx.meta_page);
 
-	/*
-	 * we did a recovery. Now ctx.pos points to an invalid meta block. New
-	 * log will start here. but we can't let superblock point to last valid
-	 * meta block. The log might looks like:
-	 * | meta 1| meta 2| meta 3|
-	 * meta 1 is valid, meta 2 is invalid. meta 3 could be valid. If
-	 * superblock points to meta 1, we write a new valid meta 2n.  if crash
-	 * happens again, new recovery will start from meta 1. Since meta 2n is
-	 * valid now, recovery will think meta 3 is valid, which is wrong.
-	 * The solution is we create a new meta in meta2 with its seq == meta
-	 * 1's seq + 10 and let superblock points to meta2. The same recovery will
-	 * not think meta 3 is a valid meta, because its seq doesn't match
-	 */
-	if (ctx.seq > log->last_cp_seq) {
-		int ret;
-
-		ret = r5l_log_write_empty_meta_block(log, ctx.pos, ctx.seq + 10);
-		if (ret)
-			return ret;
-		log->seq = ctx.seq + 11;
-		log->log_start = r5l_ring_add(log, ctx.pos, BLOCK_SECTORS);
-		r5l_write_super(log, ctx.pos);
-		log->last_checkpoint = ctx.pos;
-		log->next_checkpoint = ctx.pos;
-	} else {
-		log->log_start = ctx.pos;
-		log->seq = ctx.seq;
-	}
+	if (ret)
+		return ret;
 
-	/*
-	 * This is to suppress "function defined but not used" warning.
-	 * It will be removed when the two functions are used (next patch).
-	 */
-	if (!log) {
-		r5c_recovery_flush_log(log, &ctx);
-		r5c_recovery_rewrite_data_only_stripes(log, &ctx);
+	if ((ctx.data_only_stripes == 0) && (ctx.data_parity_stripes == 0))
+		pr_debug("md/raid:%s: starting from clean shutdown\n",
+			 mdname(mddev));
+	else {
+		pr_debug("md/raid:%s: recoverying %d data-only stripes and %d data-parity stripes\n",
+			 mdname(mddev), ctx.data_only_stripes,
+			 ctx.data_parity_stripes);
+
+		if (ctx.data_only_stripes > 0)
+			if (r5c_recovery_rewrite_data_only_stripes(log, &ctx)) {
+				pr_err("md/raid:%s: failed to rewrite stripes to journal\n",
+				       mdname(mddev));
+				return -EIO;
+			}
 	}
 
+	log->log_start = ctx.pos;
+	log->next_checkpoint = ctx.pos;
+	log->seq = ctx.seq;
+	r5l_log_write_empty_meta_block(log, ctx.pos, ctx.seq);
+	r5l_write_super(log, ctx.pos);
 	return 0;
 }
 
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index e8dace5..3ac3172 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7087,7 +7087,8 @@ static int raid5_run(struct mddev *mddev)
 
 		pr_debug("md/raid:%s: using device %s as journal\n",
 			 mdname(mddev), bdevname(journal_dev->bdev, b));
-		r5l_init_log(conf, journal_dev);
+		if (r5l_init_log(conf, journal_dev))
+			goto abort;
 	}
 
 	return 0;
-- 
2.9.3

