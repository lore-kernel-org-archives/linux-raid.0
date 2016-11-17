From: Song Liu <songliubraving@fb.com>
Subject: [PATCH v7 08/10] md/r5cache: r5cache recovery: part 1
Date: Thu, 17 Nov 2016 15:24:43 -0800
Message-ID: <20161117232445.1798305-9-songliubraving@fb.com>
References: <20161117232445.1798305-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161117232445.1798305-1-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.com, shli@fb.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, liuzhengyuang521@gmail.com, liuzhengyuan@kylinos.cn, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

Recovery of write-back cache has different logic to write-through only
cache. Specifically, for write-back cache, the recovery need to scan
through all active journal entries before flushing data out. Therefore,
large portion of the recovery logic is rewritten here.

To make the diffs cleaner, we split the rewrite as follows:

1. In this patch, we:
      - add new data to r5l_recovery_ctx
      - add new functions to recovery write-back cache
   The new functions are not used in this patch, so this patch does not
   change the behavior of recovery.

2. In next patch, we:
      - modify main recovery procedure r5l_recovery_log() to call new
        functions
      - remove old functions

With cache feature, there are 2 different scenarios of recovery:
1. Data-Parity stripe: a stripe with complete parity in journal.
2. Data-Only stripe: a stripe with only data in journal (or partial
   parity).

The code differentiate Data-Parity stripe from Data-Only stripe with
flag STRIPE_R5C_CACHING.

For Data-Parity stripes, we use the same procedure as raid5 journal,
where all the data and parity are replayed to the RAID devices.

For Data-Only strips, we need to finish complete calculate parity and
finish the full reconstruct write or RMW write. For simplicity, in
the recovery, we load the stripe to stripe cache. Once the array is
started, the stripe cache state machine will handle these stripes
through normal write path.

r5c_recovery_flush_log contains the main procedure of recovery. The
recovery code first scans through the journal and loads data to
stripe cache. The code keeps tracks of all these stripes in a list
(use sh->lru and ctx->cached_list), stripes in the list are
organized in the order of its first appearance on the journal.
During the scan, the recovery code assesses each stripe as
Data-Parity or Data-Only.

During scan, the array may run out of stripe cache. In these cases,
the recovery code will also call raid5_set_cache_size to increase
stripe cache size. If the array still runs out of stripe cache
because there isn't enough memory, the array will not assemble.

At the end of scan, the recovery code replays all Data-Parity
stripes, and sets proper states for Data-Only stripes. The recovery
code also increases seq number by 10 and rewrites all Data-Only
stripes to journal. This is to avoid confusion after repeated
crashes. More details is explained in raid5-cache.c before
r5c_recovery_rewrite_data_only_stripes().

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 drivers/md/raid5-cache.c | 602 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 602 insertions(+)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 390be84..3aa7ecc 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -1,5 +1,6 @@
 /*
  * Copyright (C) 2015 Shaohua Li <shli@fb.com>
+ * Copyright (C) 2016 Song Liu <songliubraving@fb.com>
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms and conditions of the GNU General Public License,
@@ -1354,6 +1355,9 @@ struct r5l_recovery_ctx {
 	sector_t meta_total_blocks;	/* total size of current meta and data */
 	sector_t pos;			/* recovery position */
 	u64 seq;			/* recovery position seq */
+	int data_parity_stripes;	/* number of data_parity stripes */
+	int data_only_stripes;		/* number of data_only stripes */
+	struct list_head cached_list;
 };
 
 static int r5l_recovery_read_meta_block(struct r5l_log *log,
@@ -1576,6 +1580,590 @@ static int r5l_log_write_empty_meta_block(struct r5l_log *log, sector_t pos,
 	return 0;
 }
 
+/*
+ * r5l_recovery_load_data and r5l_recovery_load_parity uses flag R5_Wantwrite
+ * to mark valid (potentially not flushed) data in the journal.
+ *
+ * We already verified checksum in r5l_recovery_verify_data_checksum_for_mb,
+ * so there should not be any mismatch here.
+ */
+static void r5l_recovery_load_data(struct r5l_log *log,
+				   struct stripe_head *sh,
+				   struct r5l_recovery_ctx *ctx,
+				   struct r5l_payload_data_parity *payload,
+				   sector_t log_offset)
+{
+	struct mddev *mddev = log->rdev->mddev;
+	struct r5conf *conf = mddev->private;
+	int dd_idx;
+
+	raid5_compute_sector(conf,
+			     le64_to_cpu(payload->location), 0,
+			     &dd_idx, sh);
+	sync_page_io(log->rdev, log_offset, PAGE_SIZE,
+		     sh->dev[dd_idx].page, REQ_OP_READ, 0, false);
+	sh->dev[dd_idx].log_checksum =
+		le32_to_cpu(payload->checksum[0]);
+	ctx->meta_total_blocks += BLOCK_SECTORS;
+
+	set_bit(R5_Wantwrite, &sh->dev[dd_idx].flags);
+	set_bit(STRIPE_R5C_CACHING, &sh->state);
+}
+
+static void r5l_recovery_load_parity(struct r5l_log *log,
+				     struct stripe_head *sh,
+				     struct r5l_recovery_ctx *ctx,
+				     struct r5l_payload_data_parity *payload,
+				     sector_t log_offset)
+{
+	struct mddev *mddev = log->rdev->mddev;
+	struct r5conf *conf = mddev->private;
+
+	ctx->meta_total_blocks += BLOCK_SECTORS * conf->max_degraded;
+	sync_page_io(log->rdev, log_offset, PAGE_SIZE,
+		     sh->dev[sh->pd_idx].page, REQ_OP_READ, 0, false);
+	sh->dev[sh->pd_idx].log_checksum =
+		le32_to_cpu(payload->checksum[0]);
+	set_bit(R5_Wantwrite, &sh->dev[sh->pd_idx].flags);
+
+	if (sh->qd_idx >= 0) {
+		sync_page_io(log->rdev,
+			     r5l_ring_add(log, log_offset, BLOCK_SECTORS),
+			     PAGE_SIZE, sh->dev[sh->qd_idx].page,
+			     REQ_OP_READ, 0, false);
+		sh->dev[sh->qd_idx].log_checksum =
+			le32_to_cpu(payload->checksum[1]);
+		set_bit(R5_Wantwrite, &sh->dev[sh->qd_idx].flags);
+	}
+	clear_bit(STRIPE_R5C_CACHING, &sh->state);
+}
+
+static void r5l_recovery_reset_stripe(struct stripe_head *sh)
+{
+	int i;
+
+	sh->state = 0;
+	sh->log_start = MaxSector;
+	for (i = sh->disks; i--; )
+		sh->dev[i].flags = 0;
+}
+
+static void
+r5l_recovery_replay_one_stripe(struct r5conf *conf,
+			       struct stripe_head *sh,
+			       struct r5l_recovery_ctx *ctx)
+{
+	struct md_rdev *rdev, *rrdev;
+	int disk_index;
+	int data_count = 0;
+
+	for (disk_index = 0; disk_index < sh->disks; disk_index++) {
+		if (!test_bit(R5_Wantwrite, &sh->dev[disk_index].flags))
+			continue;
+		if (disk_index == sh->qd_idx || disk_index == sh->pd_idx)
+			continue;
+		data_count++;
+	}
+
+	/*
+	 * stripes that only have parity must have been flushed
+	 * before the crash that we are now recovering from, so
+	 * there is nothing more to recovery.
+	 */
+	if (data_count == 0)
+		goto out;
+
+	for (disk_index = 0; disk_index < sh->disks; disk_index++) {
+		if (!test_bit(R5_Wantwrite, &sh->dev[disk_index].flags))
+			continue;
+
+		/* in case device is broken */
+		rcu_read_lock();
+		rdev = rcu_dereference(conf->disks[disk_index].rdev);
+		if (rdev) {
+			atomic_inc(&rdev->nr_pending);
+			rcu_read_unlock();
+			sync_page_io(rdev, sh->sector, PAGE_SIZE,
+				     sh->dev[disk_index].page, REQ_OP_WRITE, 0,
+				     false);
+			rdev_dec_pending(rdev, rdev->mddev);
+			rcu_read_lock();
+		}
+		rrdev = rcu_dereference(conf->disks[disk_index].replacement);
+		if (rrdev) {
+			atomic_inc(&rrdev->nr_pending);
+			rcu_read_unlock();
+			sync_page_io(rrdev, sh->sector, PAGE_SIZE,
+				     sh->dev[disk_index].page, REQ_OP_WRITE, 0,
+				     false);
+			rdev_dec_pending(rrdev, rrdev->mddev);
+			rcu_read_lock();
+		}
+		rcu_read_unlock();
+	}
+	ctx->data_parity_stripes++;
+out:
+	r5l_recovery_reset_stripe(sh);
+}
+
+static struct stripe_head *
+r5c_recovery_alloc_stripe(struct r5conf *conf,
+			  struct list_head *recovery_list,
+			  sector_t stripe_sect,
+			  sector_t log_start)
+{
+	struct stripe_head *sh;
+
+	sh = raid5_get_active_stripe(conf, stripe_sect, 0, 1, 0);
+	if (!sh)
+		return NULL;  /* no more stripe available */
+
+	r5l_recovery_reset_stripe(sh);
+	sh->log_start = log_start;
+
+	return sh;
+}
+
+static struct stripe_head *
+r5c_recovery_lookup_stripe(struct list_head *list, sector_t sect)
+{
+	struct stripe_head *sh;
+
+	list_for_each_entry(sh, list, lru)
+		if (sh->sector == sect)
+			return sh;
+	return NULL;
+}
+
+static void
+r5c_recovery_drop_stripes(struct list_head *cached_stripe_list,
+			  struct r5l_recovery_ctx *ctx)
+{
+	struct stripe_head *sh, *next;
+
+	list_for_each_entry_safe(sh, next, cached_stripe_list, lru) {
+		r5l_recovery_reset_stripe(sh);
+		list_del_init(&sh->lru);
+		raid5_release_stripe(sh);
+	}
+}
+
+static void
+r5c_recovery_replay_stripes(struct list_head *cached_stripe_list,
+			    struct r5l_recovery_ctx *ctx)
+{
+	struct stripe_head *sh, *next;
+
+	list_for_each_entry_safe(sh, next, cached_stripe_list, lru)
+		if (!test_bit(STRIPE_R5C_CACHING, &sh->state)) {
+			r5l_recovery_replay_one_stripe(sh->raid_conf, sh, ctx);
+			list_del_init(&sh->lru);
+			raid5_release_stripe(sh);
+		}
+}
+
+/* if matches return 0; otherwise return -EINVAL */
+static int
+r5l_recovery_verify_data_checksum(struct r5l_log *log, struct page *page,
+				  sector_t log_offset, __le32 log_checksum)
+{
+	void *addr;
+	u32 checksum;
+
+	sync_page_io(log->rdev, log_offset, PAGE_SIZE,
+		     page, REQ_OP_READ, 0, false);
+	addr = kmap_atomic(page);
+	checksum = crc32c_le(log->uuid_checksum, addr, PAGE_SIZE);
+	kunmap_atomic(addr);
+	return (le32_to_cpu(log_checksum) == checksum) ? 0 : -EINVAL;
+}
+
+/*
+ * before loading data to stripe cache, we need verify checksum for all data,
+ * if there is mismatch for any data page, we drop all data in the mata block
+ */
+static int
+r5l_recovery_verify_data_checksum_for_mb(struct r5l_log *log,
+					 struct r5l_recovery_ctx *ctx)
+{
+	struct mddev *mddev = log->rdev->mddev;
+	struct r5conf *conf = mddev->private;
+	struct r5l_meta_block *mb = page_address(ctx->meta_page);
+	sector_t mb_offset = sizeof(struct r5l_meta_block);
+	sector_t log_offset = r5l_ring_add(log, ctx->pos, BLOCK_SECTORS);
+	struct page *page;
+	struct r5l_payload_data_parity *payload;
+
+	page = alloc_page(GFP_KERNEL);
+	if (!page)
+		return -ENOMEM;
+
+	while (mb_offset < le32_to_cpu(mb->meta_size)) {
+		payload = (void *)mb + mb_offset;
+
+		if (payload->header.type == R5LOG_PAYLOAD_DATA) {
+			if (r5l_recovery_verify_data_checksum(
+				    log, page, log_offset,
+				    payload->checksum[0]) < 0)
+				goto mismatch;
+		} else if (payload->header.type == R5LOG_PAYLOAD_PARITY) {
+			if (r5l_recovery_verify_data_checksum(
+				    log, page, log_offset,
+				    payload->checksum[0]) < 0)
+				goto mismatch;
+			if (conf->max_degraded == 2 && /* q for RAID 6 */
+			    r5l_recovery_verify_data_checksum(
+				    log, page,
+				    r5l_ring_add(log, log_offset,
+						 BLOCK_SECTORS),
+				    payload->checksum[1]) < 0)
+				goto mismatch;
+		} else /* not R5LOG_PAYLOAD_DATA or R5LOG_PAYLOAD_PARITY */
+			goto mismatch;
+
+		log_offset = r5l_ring_add(log, log_offset,
+					  le32_to_cpu(payload->size));
+
+		mb_offset += sizeof(struct r5l_payload_data_parity) +
+			sizeof(__le32) *
+			(le32_to_cpu(payload->size) >> (PAGE_SHIFT - 9));
+	}
+
+	put_page(page);
+	return 0;
+
+mismatch:
+	put_page(page);
+	return -EINVAL;
+}
+
+/*
+ * Analyze all data/parity pages in one meta block
+ * Returns:
+ * 0 for success
+ * -EINVAL for unknown playload type
+ * -EAGAIN for checksum mismatch of data page
+ * -ENOMEM for run out of memory (alloc_page failed or run out of stripes)
+ */
+static int
+r5c_recovery_analyze_meta_block(struct r5l_log *log,
+				struct r5l_recovery_ctx *ctx,
+				struct list_head *cached_stripe_list)
+{
+	struct mddev *mddev = log->rdev->mddev;
+	struct r5conf *conf = mddev->private;
+	struct r5l_meta_block *mb;
+	struct r5l_payload_data_parity *payload;
+	int mb_offset;
+	sector_t log_offset;
+	sector_t stripe_sect;
+	struct stripe_head *sh;
+	int ret;
+
+	/*
+	 * for mismatch in data blocks, we will drop all data in this mb, but
+	 * we will still read next mb for other data with FLUSH flag, as
+	 * io_unit could finish out of order.
+	 */
+	ret = r5l_recovery_verify_data_checksum_for_mb(log, ctx);
+	if (ret == -EINVAL)
+		return -EAGAIN;
+	else if (ret)
+		return ret;   /* -ENOMEM duo to alloc_page() failed */
+
+	mb = page_address(ctx->meta_page);
+	mb_offset = sizeof(struct r5l_meta_block);
+	log_offset = r5l_ring_add(log, ctx->pos, BLOCK_SECTORS);
+
+	while (mb_offset < le32_to_cpu(mb->meta_size)) {
+		int dd;
+
+		payload = (void *)mb + mb_offset;
+		stripe_sect = (payload->header.type == R5LOG_PAYLOAD_DATA) ?
+			raid5_compute_sector(
+				conf, le64_to_cpu(payload->location), 0, &dd,
+				NULL)
+			: le64_to_cpu(payload->location);
+
+		sh = r5c_recovery_lookup_stripe(cached_stripe_list,
+						stripe_sect);
+
+		if (!sh) {
+			sh = r5c_recovery_alloc_stripe(conf, cached_stripe_list,
+						       stripe_sect, ctx->pos);
+			/*
+			 * cannot get stripe from raid5_get_active_stripe
+			 * try replay some stripes
+			 */
+			if (!sh) {
+				r5c_recovery_replay_stripes(
+					cached_stripe_list, ctx);
+				sh = r5c_recovery_alloc_stripe(
+					conf, cached_stripe_list,
+					stripe_sect, ctx->pos);
+			}
+			if (!sh) {
+				pr_debug("md/raid:%s: Increasing stripe cache size to %d to recovery data on journal.\n",
+					mdname(mddev),
+					conf->min_nr_stripes * 2);
+				raid5_set_cache_size(mddev,
+						     conf->min_nr_stripes * 2);
+				sh = r5c_recovery_alloc_stripe(
+					conf, cached_stripe_list, stripe_sect,
+					ctx->pos);
+			}
+			if (!sh) {
+				pr_err("md/raid:%s: Cannot get enough stripes due to memory pressure. Recovery failed.\n",
+				       mdname(mddev));
+				return -ENOMEM;
+			}
+			list_add_tail(&sh->lru, cached_stripe_list);
+		}
+
+		if (payload->header.type == R5LOG_PAYLOAD_DATA) {
+			if (!test_bit(STRIPE_R5C_CACHING, &sh->state)) {
+				r5l_recovery_replay_one_stripe(conf, sh, ctx);
+				r5l_recovery_reset_stripe(sh);
+				sh->log_start = ctx->pos;
+				list_move_tail(&sh->lru, cached_stripe_list);
+			}
+			r5l_recovery_load_data(log, sh, ctx, payload,
+					       log_offset);
+		} else if (payload->header.type == R5LOG_PAYLOAD_PARITY)
+			r5l_recovery_load_parity(log, sh, ctx, payload,
+						 log_offset);
+		else
+			return -EINVAL;
+
+		log_offset = r5l_ring_add(log, log_offset,
+					  le32_to_cpu(payload->size));
+
+		mb_offset += sizeof(struct r5l_payload_data_parity) +
+			sizeof(__le32) *
+			(le32_to_cpu(payload->size) >> (PAGE_SHIFT - 9));
+	}
+
+	return 0;
+}
+
+/*
+ * Load the stripe into cache. The stripe will be written out later by
+ * the stripe cache state machine.
+ */
+static void r5c_recovery_load_one_stripe(struct r5l_log *log,
+					 struct stripe_head *sh)
+{
+	struct r5conf *conf = sh->raid_conf;
+	struct r5dev *dev;
+	int i;
+
+	for (i = sh->disks; i--; ) {
+		dev = sh->dev + i;
+		if (test_and_clear_bit(R5_Wantwrite, &dev->flags)) {
+			set_bit(R5_InJournal, &dev->flags);
+			set_bit(R5_UPTODATE, &dev->flags);
+		}
+	}
+	set_bit(STRIPE_R5C_PARTIAL_STRIPE, &sh->state);
+	atomic_inc(&conf->r5c_cached_partial_stripes);
+	list_add_tail(&sh->r5c, &log->stripe_in_journal_list);
+}
+
+/*
+ * Scan through the log for all to-be-flushed data
+ *
+ * For stripes with data and parity, namely Data-Parity stripe
+ * (STRIPE_R5C_CACHING == 0), we simply replay all the writes.
+ *
+ * For stripes with only data, namely Data-Only stripe
+ * (STRIPE_R5C_CACHING == 1), we load them to stripe cache state machine.
+ *
+ * For a stripe, if we see data after parity, we should discard all previous
+ * data and parity for this stripe, as these data are already flushed to
+ * the array.
+ *
+ * At the end of the scan, we return the new journal_tail, which points to
+ * first data-only stripe on the journal device, or next invalid meta block.
+ */
+static int r5c_recovery_flush_log(struct r5l_log *log,
+				  struct r5l_recovery_ctx *ctx)
+{
+	struct stripe_head *sh, *next;
+	int ret = 0;
+
+	/* scan through the log */
+	while (1) {
+		if (r5l_recovery_read_meta_block(log, ctx))
+			break;
+
+		ret = r5c_recovery_analyze_meta_block(log, ctx,
+						      &ctx->cached_list);
+		/*
+		 * -EAGAIN means mismatch in data block, in this case, we still
+		 * try scan the next metablock
+		 */
+		if (ret && ret != -EAGAIN)
+			break;   /* ret == -EINVAL or -ENOMEM */
+		ctx->seq++;
+		ctx->pos = r5l_ring_add(log, ctx->pos, ctx->meta_total_blocks);
+	}
+
+	if (ret == -ENOMEM) {
+		r5c_recovery_drop_stripes(&ctx->cached_list, ctx);
+		return ret;
+	}
+
+	/* replay data-parity stripes */
+	r5c_recovery_replay_stripes(&ctx->cached_list, ctx);
+
+	/* load data-only stripes to stripe cache */
+	list_for_each_entry_safe(sh, next, &ctx->cached_list, lru) {
+		WARN_ON(!test_bit(STRIPE_R5C_CACHING, &sh->state));
+		r5c_recovery_load_one_stripe(log, sh);
+		list_del_init(&sh->lru);
+		raid5_release_stripe(sh);
+		ctx->data_only_stripes++;
+	}
+
+	return 0;
+}
+
+/*
+ * we did a recovery. Now ctx.pos points to an invalid meta block. New
+ * log will start here. but we can't let superblock point to last valid
+ * meta block. The log might looks like:
+ * | meta 1| meta 2| meta 3|
+ * meta 1 is valid, meta 2 is invalid. meta 3 could be valid. If
+ * superblock points to meta 1, we write a new valid meta 2n.  if crash
+ * happens again, new recovery will start from meta 1. Since meta 2n is
+ * valid now, recovery will think meta 3 is valid, which is wrong.
+ * The solution is we create a new meta in meta2 with its seq == meta
+ * 1's seq + 10 and let superblock points to meta2. The same recovery will
+ * not think meta 3 is a valid meta, because its seq doesn't match
+ */
+
+/*
+ * Before recovery, the log looks like the following
+ *
+ *   ---------------------------------------------
+ *   |           valid log        | invalid log  |
+ *   ---------------------------------------------
+ *   ^
+ *   |- log->last_checkpoint
+ *   |- log->last_cp_seq
+ *
+ * Now we scan through the log until we see invalid entry
+ *
+ *   ---------------------------------------------
+ *   |           valid log        | invalid log  |
+ *   ---------------------------------------------
+ *   ^                            ^
+ *   |- log->last_checkpoint      |- ctx->pos
+ *   |- log->last_cp_seq          |- ctx->seq
+ *
+ * From this point, we need to increase seq number by 10 to avoid
+ * confusing next recovery.
+ *
+ *   ---------------------------------------------
+ *   |           valid log        | invalid log  |
+ *   ---------------------------------------------
+ *   ^                              ^
+ *   |- log->last_checkpoint        |- ctx->pos+1
+ *   |- log->last_cp_seq            |- ctx->seq+11
+ *
+ * However, it is not safe to start the state machine yet, because data only
+ * parities are not yet secured in RAID. To save these data only parities, we
+ * rewrite them from seq+11.
+ *
+ *   -----------------------------------------------------------------
+ *   |           valid log        | data only stripes | invalid log  |
+ *   -----------------------------------------------------------------
+ *   ^                                                ^
+ *   |- log->last_checkpoint                          |- ctx->pos+n
+ *   |- log->last_cp_seq                              |- ctx->seq+10+n
+ *
+ * If failure happens again during this process, the recovery can safe start
+ * again from log->last_checkpoint.
+ *
+ * Once data only stripes are rewritten to journal, we move log_tail
+ *
+ *   -----------------------------------------------------------------
+ *   |     old log        |    data only stripes    | invalid log  |
+ *   -----------------------------------------------------------------
+ *                        ^                         ^
+ *                        |- log->last_checkpoint   |- ctx->pos+n
+ *                        |- log->last_cp_seq       |- ctx->seq+10+n
+ *
+ * Then we can safely start the state machine. If failure happens from this
+ * point on, the recovery will start from new log->last_checkpoint.
+ */
+static int
+r5c_recovery_rewrite_data_only_stripes(struct r5l_log *log,
+				       struct r5l_recovery_ctx *ctx)
+{
+	struct stripe_head *sh;
+	struct mddev *mddev = log->rdev->mddev;
+	struct page *page;
+
+	page = alloc_page(GFP_KERNEL);
+	if (!page) {
+		pr_err("md/raid:%s: cannot allocate memory to rewrite data only stripes\n",
+		       mdname(mddev));
+		return -ENOMEM;
+	}
+
+	ctx->seq += 10;
+	list_for_each_entry(sh, &ctx->cached_list, lru) {
+		struct r5l_meta_block *mb;
+		int i;
+		int offset;
+		sector_t write_pos;
+
+		WARN_ON(!test_bit(STRIPE_R5C_CACHING, &sh->state));
+		r5l_recovery_create_empty_meta_block(log, page,
+						     ctx->pos, ctx->seq);
+		mb = page_address(page);
+		offset = le32_to_cpu(mb->meta_size);
+		write_pos = ctx->pos + BLOCK_SECTORS;
+
+		for (i = sh->disks; i--; ) {
+			struct r5dev *dev = &sh->dev[i];
+			struct r5l_payload_data_parity *payload;
+			void *addr;
+
+			if (test_bit(R5_InJournal, &dev->flags)) {
+				payload = (void *)mb + offset;
+				payload->header.type = cpu_to_le16(
+					R5LOG_PAYLOAD_DATA);
+				payload->size = BLOCK_SECTORS;
+				payload->location = cpu_to_le64(
+					raid5_compute_blocknr(sh, i, 0));
+				addr = kmap_atomic(dev->page);
+				payload->checksum[0] = cpu_to_le32(
+					crc32c_le(log->uuid_checksum, addr,
+						  PAGE_SIZE));
+				kunmap_atomic(addr);
+				sync_page_io(log->rdev, write_pos, PAGE_SIZE,
+					     dev->page, REQ_OP_WRITE, 0, false);
+				write_pos = r5l_ring_add(log, write_pos,
+							 BLOCK_SECTORS);
+				offset += sizeof(__le32) +
+					sizeof(struct r5l_payload_data_parity);
+
+			}
+		}
+		mb->meta_size = cpu_to_le32(offset);
+		mb->checksum = crc32c_le(log->uuid_checksum, mb, PAGE_SIZE);
+		sync_page_io(log->rdev, ctx->pos, PAGE_SIZE, page,
+			     REQ_OP_WRITE, WRITE_FUA, false);
+		sh->log_start = ctx->pos;
+		ctx->pos = write_pos;
+		ctx->seq += 1;
+	}
+	__free_page(page);
+	return 0;
+}
+
 static int r5l_recovery_log(struct r5l_log *log)
 {
 	struct r5l_recovery_ctx ctx;
@@ -1583,6 +2171,10 @@ static int r5l_recovery_log(struct r5l_log *log)
 	ctx.pos = log->last_checkpoint;
 	ctx.seq = log->last_cp_seq;
 	ctx.meta_page = alloc_page(GFP_KERNEL);
+	ctx.data_only_stripes = 0;
+	ctx.data_parity_stripes = 0;
+	INIT_LIST_HEAD(&ctx.cached_list);
+
 	if (!ctx.meta_page)
 		return -ENOMEM;
 
@@ -1617,6 +2209,16 @@ static int r5l_recovery_log(struct r5l_log *log)
 		log->log_start = ctx.pos;
 		log->seq = ctx.seq;
 	}
+
+	/*
+	 * This is to suppress "function defined but not used" warning.
+	 * It will be removed when the two functions are used (next patch).
+	 */
+	if (!log) {
+		r5c_recovery_flush_log(log, &ctx);
+		r5c_recovery_rewrite_data_only_stripes(log, &ctx);
+	}
+
 	return 0;
 }
 
-- 
2.9.3

