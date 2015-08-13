From: Shaohua Li <shli@fb.com>
Subject: [patch v2 08/11] raid5: log recovery
Date: Thu, 13 Aug 2015 14:32:01 -0700
Message-ID: <5092b2496e6bff21c3bbf02d20d3ad4ca3274c98.1439500639.git.shli@fb.com>
References: <cover.1439500639.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cover.1439500639.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com, neilb@suse.de
List-Id: linux-raid.ids

This is the log recovery support. The process is quite straightforward.
We scan the log and read all valid meta/data/parity into memory. If a
stripe's data/parity checksum is correct, the stripe will be recoveried.
Otherwise, it's discarded and we don't scan the log further. The reclaim
process guarantees stripe which starts to be flushed raid disks has
completed data/parity and has correct checksum. To recovery a stripe, we
just copy its data/parity to corresponding raid disks.

The trick thing is superblock update after recovery. we can't let
superblock point to last valid meta block. The log might look like:
| meta 1| meta 2| meta 3|
meta 1 is valid, meta 2 is invalid. meta 3 could be valid. If superblock
points to meta 1, we write a new valid meta 2n.  If crash happens again,
new recovery will start from meta 1. Since meta 2n is valid, recovery
will think meta 3 is valid, which is wrong.  The solution is we create a
new meta in meta2 with its seq == meta 1's seq + 10 and let superblock
points to meta2.  recovery will not think meta 3 is a valid meta,
because its seq is wrong

Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/raid5-cache.c | 241 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 238 insertions(+), 3 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index d02a402..52feb90 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -711,11 +711,246 @@ static void r5l_wake_reclaim(struct r5l_log *log, sector_t space)
 	md_wakeup_thread(log->reclaim_thread);
 }
 
+struct r5l_recovery_ctx {
+	struct page *meta_page; /* current meta */
+	sector_t meta_total_blocks; /* total size of current meta and data */
+	sector_t pos; /* recovery position */
+	u64 seq; /* recovery position seq */
+};
+
+static int r5l_read_meta_block(struct r5l_log *log,
+	struct r5l_recovery_ctx *ctx)
+{
+	struct page *page = ctx->meta_page;
+	struct r5l_meta_block *mb;
+	u32 crc, stored_crc;
+
+	if (!sync_page_io(log->rdev, ctx->pos, PAGE_SIZE, page, READ, false))
+		return -EIO;
+
+	mb = page_address(page);
+	stored_crc = le32_to_cpu(mb->checksum);
+	mb->checksum = 0;
+
+	if (le32_to_cpu(mb->magic) != R5LOG_MAGIC ||
+	    le64_to_cpu(mb->seq) != ctx->seq ||
+	    mb->version != R5LOG_VERSION ||
+	    le64_to_cpu(mb->position) != ctx->pos)
+		return -EINVAL;
+
+	crc = crc32_le(log->uuid_checksum, (void *)mb, PAGE_SIZE);
+	if (stored_crc != crc)
+		return -EINVAL;
+
+	if (le32_to_cpu(mb->meta_size) > PAGE_SIZE)
+		return -EINVAL;
+
+	ctx->meta_total_blocks = BLOCK_SECTORS;
+
+	return 0;
+}
+
+static int r5l_recovery_flush_one_stripe(struct r5l_log *log,
+	struct r5l_recovery_ctx *ctx, sector_t stripe_sect,
+	int *offset, sector_t *log_offset)
+{
+	struct r5conf *conf = log->rdev->mddev->private;
+	struct stripe_head *sh;
+	struct r5l_payload_data_parity *payload;
+	int disk_index;
+
+	sh = raid5_get_active_stripe(conf, stripe_sect, 0, 0, 0);
+	while (1) {
+		payload = page_address(ctx->meta_page) + *offset;
+
+		if (le16_to_cpu(payload->header.type) == R5LOG_PAYLOAD_DATA) {
+			raid5_compute_sector(conf,
+				le64_to_cpu(payload->location), 0,
+				&disk_index, sh);
+
+			sync_page_io(log->rdev, *log_offset, PAGE_SIZE,
+				sh->dev[disk_index].page, READ, false);
+			sh->dev[disk_index].log_checksum =
+				le32_to_cpu(payload->checksum[0]);
+			set_bit(R5_Wantwrite, &sh->dev[disk_index].flags);
+			ctx->meta_total_blocks += BLOCK_SECTORS;
+		} else {
+			disk_index = sh->pd_idx;
+			sync_page_io(log->rdev, *log_offset, PAGE_SIZE,
+				sh->dev[disk_index].page, READ, false);
+			sh->dev[disk_index].log_checksum =
+				le32_to_cpu(payload->checksum[0]);
+			set_bit(R5_Wantwrite, &sh->dev[disk_index].flags);
+
+			if (sh->qd_idx >= 0) {
+				disk_index = sh->qd_idx;
+				sync_page_io(log->rdev,
+					r5l_ring_add(log, *log_offset, BLOCK_SECTORS),
+					PAGE_SIZE, sh->dev[disk_index].page,
+					READ, false);
+				sh->dev[disk_index].log_checksum =
+					le32_to_cpu(payload->checksum[1]);
+				set_bit(R5_Wantwrite,
+					&sh->dev[disk_index].flags);
+			}
+			ctx->meta_total_blocks += BLOCK_SECTORS * conf->max_degraded;
+		}
+
+		*log_offset = r5l_ring_add(log, *log_offset,
+			le32_to_cpu(payload->size));
+		*offset += sizeof(struct r5l_payload_data_parity) +
+			sizeof(__le32) *
+			(le32_to_cpu(payload->size) >> (PAGE_SHIFT - 9));
+		if (le16_to_cpu(payload->header.type) == R5LOG_PAYLOAD_PARITY)
+			break;
+	}
+
+	for (disk_index = 0; disk_index < sh->disks; disk_index++) {
+		void *addr;
+		u32 checksum;
+
+		if (!test_bit(R5_Wantwrite, &sh->dev[disk_index].flags))
+			continue;
+		addr = kmap_atomic(sh->dev[disk_index].page);
+		checksum = crc32_le(log->uuid_checksum, addr, PAGE_SIZE);
+		kunmap_atomic(addr);
+		if (checksum != sh->dev[disk_index].log_checksum)
+			goto error;
+	}
+
+	for (disk_index = 0; disk_index < sh->disks; disk_index++) {
+		struct md_rdev *rdev, *rrdev;
+		if (!test_and_clear_bit(R5_Wantwrite,
+				&sh->dev[disk_index].flags))
+			continue;
+
+		/* in case device is broken */
+		rdev = rcu_dereference(conf->disks[disk_index].rdev);
+		if (rdev)
+			sync_page_io(rdev, stripe_sect, PAGE_SIZE,
+				sh->dev[disk_index].page, WRITE, false);
+		rrdev = rcu_dereference(conf->disks[disk_index].replacement);
+		if (rrdev)
+			sync_page_io(rrdev, stripe_sect, PAGE_SIZE,
+				sh->dev[disk_index].page, WRITE, false);
+	}
+	raid5_release_stripe(sh);
+	return 0;
+
+error:
+	for (disk_index = 0; disk_index < sh->disks; disk_index++)
+		sh->dev[disk_index].flags = 0;
+	raid5_release_stripe(sh);
+	return -EINVAL;
+}
+
+static int r5l_recovery_flush_one_meta(struct r5l_log *log,
+	struct r5l_recovery_ctx *ctx)
+{
+	struct r5conf *conf = log->rdev->mddev->private;
+	struct r5l_payload_data_parity *payload;
+	struct r5l_meta_block *mb;
+	int offset;
+	sector_t log_offset;
+	sector_t stripe_sector;
+
+	mb = page_address(ctx->meta_page);
+	offset = sizeof(struct r5l_meta_block);
+	log_offset = r5l_ring_add(log, ctx->pos, BLOCK_SECTORS);
+
+	while (offset < le32_to_cpu(mb->meta_size)) {
+		int dd;
+
+		payload = (void *)mb + offset;
+		stripe_sector = raid5_compute_sector(conf,
+			le64_to_cpu(payload->location), 0, &dd, NULL);
+		if (r5l_recovery_flush_one_stripe(log, ctx, stripe_sector,
+		    &offset, &log_offset))
+			return -EINVAL;
+	}
+	return 0;
+}
+
+/* copy data/parity from log to raid disks */
+static void r5l_recovery_flush_log(struct r5l_log *log,
+	struct r5l_recovery_ctx *ctx)
+{
+	while (1) {
+		if (r5l_read_meta_block(log, ctx))
+			return;
+		if (r5l_recovery_flush_one_meta(log, ctx))
+			return;
+		ctx->seq++;
+		ctx->pos = r5l_ring_add(log, ctx->pos, ctx->meta_total_blocks);
+	}
+}
+
+static int r5l_log_write_empty_meta_block(struct r5l_log *log, sector_t pos,
+	u64 seq)
+{
+	struct page *page;
+	struct r5l_meta_block *mb;
+	u32 crc;
+
+	page = alloc_page(GFP_KERNEL | __GFP_ZERO);
+	if (!page)
+		return -ENOMEM;
+	mb = page_address(page);
+	mb->magic = cpu_to_le32(R5LOG_MAGIC);
+	mb->version = R5LOG_VERSION;
+	mb->meta_size = cpu_to_le32(sizeof(struct r5l_meta_block));
+	mb->seq = cpu_to_le64(seq);
+	mb->position = cpu_to_le64(pos);
+	crc = crc32_le(log->uuid_checksum, (void *)mb, PAGE_SIZE);
+	mb->checksum = cpu_to_le32(crc);
+
+	if (!sync_page_io(log->rdev, pos, PAGE_SIZE, page, WRITE_FUA, false)) {
+		__free_page(page);
+		return -EIO;
+	}
+	__free_page(page);
+	return 0;
+}
+
 static int r5l_recovery_log(struct r5l_log *log)
 {
-	/* fake recovery */
-	log->seq = log->last_cp_seq + 1;
-	log->log_start = r5l_ring_add(log, log->last_checkpoint, BLOCK_SECTORS);
+	struct r5l_recovery_ctx ctx;
+
+	ctx.pos = log->last_checkpoint;
+	ctx.seq = log->last_cp_seq;
+	ctx.meta_page = alloc_page(GFP_KERNEL);
+	if (!ctx.meta_page)
+		return -ENOMEM;
+
+	r5l_recovery_flush_log(log, &ctx);
+	__free_page(ctx.meta_page);
+
+	/*
+	 * we did a recovery. Now ctx.pos points to an invalid meta block. New
+	 * log will start here. but we can't let superblock point to last valid
+	 * meta block. The log might looks like:
+	 * | meta 1| meta 2| meta 3|
+	 * meta 1 is valid, meta 2 is invalid. meta 3 could be valid. If
+	 * superblock points to meta 1, we write a new valid meta 2n.  if crash
+	 * happens again, new recovery will start from meta 1. Since meta 2n is
+	 * valid now, recovery will think meta 3 is valid, which is wrong.
+	 * The solution is we create a new meta in meta2 with its seq == meta
+	 * 1's seq + 10 and let superblock points to meta2. The same recovery will
+	 * not think meta 3 is a valid meta, because its seq doesn't match
+	 */
+	if (ctx.seq > log->last_cp_seq + 1) {
+		int ret;
+
+		ret = r5l_log_write_empty_meta_block(log, ctx.pos, ctx.seq + 10);
+		if (ret)
+			return ret;
+		log->seq = ctx.seq + 11;
+		log->log_start = r5l_ring_add(log, ctx.pos, BLOCK_SECTORS);
+		r5l_write_super(log, ctx.pos);
+	} else {
+		log->log_start = ctx.pos;
+		log->seq = ctx.seq;
+	}
 	return 0;
 }
 
-- 
1.8.1

