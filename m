From: Shaohua Li <shli@fb.com>
Subject: [PATCH V4 08/13] raid5: cache recovery support
Date: Tue, 23 Jun 2015 14:37:58 -0700
Message-ID: <54ce59e8ea5f1b0bd6e5a38b9b5c5d43eb47cbcb.1435094582.git.shli@fb.com>
References: <cover.1435094582.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cover.1435094582.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com, neilb@suse.de
List-Id: linux-raid.ids

After a unclean shutdown, cache must be recovered. According to reclaim
process, we take different actions for stripes in different states.
-stripe without parity: read data to memory
-stripe with parity but not listed in flush_start block: read data to
memory and discard parity
-stripe with parity and listed in flush_start but not in flush_end
block: read data/parity to memory, recovery (flush them to raid disks)
-stripe listed in flush_end block: discard all its data and parity

The recovery process is quite straightforward. We just read all
data/parity into memory, do sanity check and flush stripes which reclaim
was flushint them to raid disks at crash.

There is one thing we must be careful about that recovery should use
parity stored in log instead of that calculated by raid5 stripe state
machine, since after crash, the raid array isn't in consistent state,
calculated parity could be wrong.

Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/raid5-cache.c | 640 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 639 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 35657cd..143f333 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -288,6 +288,13 @@ enum {
 	STRIPE_DEAD = 4, /* stripe can be reused */
 };
 
+/* stripe recovery state */
+enum {
+	RECOVERY_NO_FLUSH = 0,
+	RECOVERY_FLUSH_START = 1, /* stripe in a start flush block */
+	RECOVERY_FLUSH_END = 2,
+};
+
 #define STRIPE_LOCK_BITS 8
 struct r5c_cache {
 	struct mddev *mddev;
@@ -1535,7 +1542,12 @@ static void r5c_put_stripe(struct r5c_stripe *stripe)
 		kmem_cache_free(cache->io_range_kc, range);
 	}
 	r5c_put_pages(cache, stripe->data_pages, cache->stripe_data_pages);
-	BUG_ON(stripe->parity_pages);
+	if (stripe->parity_pages) {
+		r5c_put_pages(cache, stripe->parity_pages,
+			cache->stripe_parity_pages);
+		kfree(stripe->parity_pages);
+		stripe->parity_pages = NULL;
+	}
 
 	r5c_unlock_stripe(cache, stripe, &flags2);
 
@@ -2401,6 +2413,26 @@ static void r5c_write_one_stripe_parity(struct r5c_cache *cache,
 	stripe_offset = sector_div(stripe_index, cache->chunk_size);
 	stripe_offset >>= PAGE_SECTOR_SHIFT;
 
+	/*
+	 * in recovery, raid array isn't in consistent state, we shouldn't use
+	 * calculated parity but those stored in log
+	 * */
+	if (cache->in_recovery) {
+		stripe_offset *= cache->parity_disks;
+
+		copy_highpage(sh->dev[sh->pd_idx].page,
+			stripe->parity_pages[stripe_offset]);
+		if (sh->qd_idx >= 0)
+			copy_highpage(sh->dev[sh->qd_idx].page,
+				stripe->parity_pages[stripe_offset + 1]);
+
+		if (!atomic_dec_return(&stripe->dirty_stripes)) {
+			stripe->state = STRIPE_PARITY_DONE;
+			wake_up(r5c_stripe_waitq(cache, stripe));
+		}
+		return;
+	}
+
 	if (cache->error_state) {
 		r5c_put_stripe_dirty(cache, stripe);
 		return;
@@ -2454,8 +2486,614 @@ int r5c_write_parity(struct r5c_cache *cache, struct stripe_head *head_sh)
 	return 0;
 }
 
+struct r5c_load_ctx {
+	struct r5c_cache *cache;
+	struct list_head io_ranges;
+	struct list_head stripes_with_parity;
+	struct list_head stripes_without_parity;
+	atomic_t io_cnt;
+	wait_queue_head_t io_wq;
+};
+
+/*
+ * If a stripe has parity in the log and is listed in a flush start block, the
+ * stripe is being flushed to raid. If the stripe is listed in flush end block,
+ * the striep is fully flushed to raid, all its data/parity can be discarded.
+ * Otherwise, the stripe must be recovered. If a stripe has parity data and is
+ * not listed in flush start block, it's not flushed to raid, its parity can be
+ * discarded.
+ *
+ * Note super block might point to anywhere. d(data), p(parity), f(flush start),
+ *  F(flush end), ^(superblock pointed log tail). assume 4d 2p:
+ *
+ *   d  d  d  d  p  p  f  F
+ * ^, normal case
+ *     ^ stripe must be in F, ignore data, parity
+ *                 ^ stripe must be in F, ignore parity
+ *                    ^ stripe in f/F can be ingored
+ *   d  d  d  d  p
+ * ^, f/F should not exsist if p isn't enough
+ *   d  d  d  d  p p
+ *        ^, invalid case, superblock is updated after F
+ *
+ * Each reclaim thread records its own flushed stripes and multiple reclaim
+ * threads can't handle one stripe in the meaning time. Multiple reclaim threads
+ * don't change the behavior.
+ * */
+static int r5c_add_flush_start(struct r5c_load_ctx *ctx,
+	struct r5l_flush_block *fb, u64 seq)
+{
+	struct r5c_stripe *stripe;
+	int size;
+	int i;
+	u64 stripe_index;
+
+	size = le32_to_cpu(fb->header.meta_size) -
+		sizeof(struct r5l_flush_block);
+	size /= sizeof(__le64);
+
+	for (i = 0; i < size; i++) {
+		stripe_index = le64_to_cpu(fb->flush_stripes[i]);
+		/* superblock skips the stripe */
+		stripe = r5c_search_stripe(ctx->cache, stripe_index);
+		if (!stripe)
+			continue;
+		stripe->recovery_state = RECOVERY_FLUSH_START;
+	}
+	return 0;
+}
+
+static int r5c_add_flush_end(struct r5c_load_ctx *ctx,
+	struct r5l_flush_block *fb, u64 seq)
+{
+	struct r5c_cache *cache = ctx->cache;
+	struct r5c_stripe *stripe;
+	struct r5c_io_range *range;
+	int size;
+	int i;
+	u64 stripe_index;
+
+	size = le32_to_cpu(fb->header.meta_size) -
+		sizeof(struct r5l_flush_block);
+	size /= sizeof(__le64);
+
+	for (i = 0; i < size; i++) {
+		stripe_index = le64_to_cpu(fb->flush_stripes[i]);
+		stripe = r5c_search_stripe(ctx->cache, stripe_index);
+		/* superblock skips the stripe */
+		if (!stripe)
+			continue;
+		if (stripe->recovery_state != RECOVERY_FLUSH_START)
+			return -EINVAL;
+
+		list_del(&stripe->lru);
+		/* essentially r5c_put_stripe */
+		radix_tree_delete(&cache->stripe_tree, stripe->raid_index);
+
+		while (!list_empty(&stripe->io_ranges)) {
+			range = list_first_entry(&stripe->io_ranges,
+				struct r5c_io_range, stripe_sibling);
+			list_del(&range->stripe_sibling);
+
+			list_del(&range->log_sibling);
+
+			kfree(range->checksum);
+			kmem_cache_free(cache->io_range_kc, range);
+		}
+		while (!list_empty(&stripe->parity_list)) {
+			range = list_first_entry(&stripe->parity_list,
+				struct r5c_io_range, stripe_sibling);
+			list_del(&range->stripe_sibling);
+
+			kfree(range->checksum);
+			kmem_cache_free(cache->io_range_kc, range);
+		}
+
+		kmem_cache_free(cache->stripe_kc, stripe);
+	}
+	return 0;
+}
+
+static int r5c_add_data(struct r5c_load_ctx *ctx, u64 seq,
+	sector_t meta_start, sector_t data_start, sector_t raid_start,
+	ssize_t sectors, u32 *checksum)
+{
+	struct r5c_stripe *stripe;
+	struct r5c_io_range *range;
+	u64 index;
+	int offset;
+
+	r5c_sector_stripe_index_offset(ctx->cache, raid_start, &index,
+		&offset);
+
+	stripe = r5c_create_get_stripe(ctx->cache, index);
+	if (stripe->recovery_state != RECOVERY_NO_FLUSH)
+		return -EINVAL;
+
+	range = kmem_cache_alloc(ctx->cache->io_range_kc, GFP_NOIO);
+	if (!range)
+		return -ENOMEM;
+
+	range->seq = seq;
+	range->meta_start = meta_start;
+	range->data_start = data_start;
+	range->raid_start = raid_start;
+	range->data_sectors = sectors;
+	range->stripe = stripe;
+	range->checksum = checksum;
+
+	list_add_tail(&range->stripe_sibling, &stripe->io_ranges);
+	list_add_tail(&range->log_sibling, &ctx->io_ranges);
+
+	if (list_empty(&stripe->lru))
+		list_add_tail(&stripe->lru, &ctx->stripes_without_parity);
+
+	r5c_put_stripe(stripe);
+	return 0;
+}
+
+static int r5c_add_parity(struct r5c_load_ctx *ctx, u64 seq,
+	sector_t meta_start, sector_t data_start, sector_t stripe_sect,
+	ssize_t sectors, u32 *checksum)
+{
+	struct r5c_stripe *stripe;
+	struct r5c_io_range *range;
+	sector_t index = stripe_sect;
+
+	sector_div(index, ctx->cache->log.chunk_size);
+	/* superblock skips this stripe */
+	stripe = r5c_search_stripe(ctx->cache, index);
+	if (!stripe)
+		return 0;
+	if (stripe->recovery_state != RECOVERY_NO_FLUSH)
+		return -EINVAL;
+
+	range = kmem_cache_alloc(ctx->cache->io_range_kc, GFP_NOIO);
+	if (!range)
+		return -ENOMEM;
+
+	range->seq = seq;
+	range->meta_start = meta_start;
+	range->data_start = data_start;
+	range->raid_start = stripe_sect;
+	range->data_sectors = sectors;
+	range->stripe = stripe;
+	range->checksum = checksum;
+
+	if (list_empty(&stripe->parity_list))
+		list_move_tail(&stripe->lru, &ctx->stripes_with_parity);
+	list_add_tail(&range->stripe_sibling, &stripe->parity_list);
+
+	return 0;
+}
+
+static void r5c_free_parity_ranges(struct r5c_stripe *stripe, bool skip_parity)
+{
+	struct r5c_cache *cache = stripe->cache;
+	struct r5c_io_range *range;
+
+	while (!list_empty(&stripe->parity_list)) {
+		range = list_first_entry(&stripe->parity_list,
+			struct r5c_io_range, stripe_sibling);
+		list_del(&range->stripe_sibling);
+
+		kfree(range->checksum);
+		kmem_cache_free(cache->io_range_kc, range);
+	}
+	if (skip_parity)
+		return;
+	if (stripe->parity_pages) {
+		r5c_put_pages(cache, stripe->parity_pages,
+			cache->stripe_parity_pages);
+		kfree(stripe->parity_pages);
+		stripe->parity_pages = NULL;
+	}
+}
+
+/*
+ * parities of some stripes aren't fully in log disk, such stripes havedn't
+ * started to be flushed to log yet, ignore parities of such stripes.
+ **/
+static void r5c_analyse_log(struct r5c_load_ctx *ctx)
+{
+	struct r5c_stripe *stripe, *tmp;
+	int recovery_state;
+	LIST_HEAD(list);
+
+	list_for_each_entry_safe(stripe, tmp, &ctx->stripes_with_parity, lru) {
+		recovery_state = stripe->recovery_state;
+		stripe->recovery_state = RECOVERY_NO_FLUSH;
+
+		if (recovery_state == RECOVERY_NO_FLUSH)
+			list_move_tail(&stripe->lru, &list);
+	}
+	if (list_empty(&list))
+		return;
+	list_for_each_entry(stripe, &list, lru)
+		r5c_free_parity_ranges(stripe, false);
+	list_splice_tail(&list, &ctx->stripes_without_parity);
+	printk(KERN_ERR
+		"md: %s, parities of some stripes aren't fully in cache, "
+		"discard them\n",
+		mdname(ctx->cache->mddev));
+}
+
+static void r5l_fetch_endio(struct bio *bio, int err)
+{
+	struct r5c_load_ctx *ctx = bio->bi_private;
+
+	bio_put(bio);
+	if (atomic_dec_and_test(&ctx->io_cnt))
+		wake_up(&ctx->io_wq);
+}
+
+static int r5l_fetch_one_range(struct r5c_load_ctx *ctx,
+	struct r5c_stripe *stripe, struct page **pages,
+	ssize_t page_cnt, sector_t sec, bool data)
+{
+	struct r5l_log *log = &ctx->cache->log;
+	struct bio *bio;
+	int page_index = 0;
+	int nvec;
+	int i;
+
+again:
+	nvec = min_t(int, page_cnt - page_index,
+		bio_get_nr_vecs(r5l_bdev(log)));
+	bio = bio_kmalloc(GFP_NOIO, nvec);
+	bio->bi_iter.bi_sector = sec;
+	bio->bi_end_io = r5l_fetch_endio;
+	bio->bi_private = ctx;
+	bio->bi_bdev = r5l_bdev(log);
+	atomic_inc(&ctx->io_cnt);
+
+	/* FIXME: we might use too many memory */
+	for (i = 0; i < nvec; i++) {
+		pages[page_index] = alloc_page(GFP_NOIO | __GFP_HIGHMEM);
+		if (!bio_add_page(bio, pages[page_index], PAGE_SIZE, 0)) {
+			__free_page(pages[page_index]);
+			pages[page_index] = NULL;
+			break;
+		}
+		page_index++;
+		if (data)
+			stripe->existing_pages++;
+		ctx->cache->total_pages++;
+	}
+
+	sec = r5l_block_to_sector(log, r5l_ring_add(log,
+		r5l_sector_to_block(log, sec), r5l_page_blocks(log, i)));
+	r5l_submit_bio(log, READ, bio);
+
+	if (page_index < page_cnt)
+		goto again;
+	return 0;
+}
+
+static int r5l_fetch_one_stripe(struct r5c_load_ctx *ctx,
+	struct r5c_stripe *stripe)
+{
+	struct r5c_cache *cache = stripe->cache;
+	struct r5c_io_range *range;
+	u64 index;
+	int offset, max, start, range_start;
+
+	/* new data is at the tail */
+	list_for_each_entry_reverse(range, &stripe->io_ranges, stripe_sibling) {
+		r5c_sector_stripe_index_offset(cache, range->raid_start,
+			&index, &offset);
+		offset >>= PAGE_SECTOR_SHIFT;
+		range_start = offset;
+		max = (range->data_sectors >> PAGE_SECTOR_SHIFT) + offset;
+again:
+		while (offset < max && stripe->data_pages[offset])
+			offset++;
+		start = offset;
+		while (offset < max && !stripe->data_pages[offset])
+			offset++;
+		if (start >= max)
+			continue;
+		r5l_fetch_one_range(ctx, stripe, &stripe->data_pages[start],
+			offset - start,
+			range->data_start + ((start - range_start) <<
+			PAGE_SECTOR_SHIFT), true);
+		if (offset < max)
+			goto again;
+	}
+
+	if (list_empty(&stripe->parity_list))
+		return 0;
+
+	stripe->parity_pages = kmalloc(cache->stripe_parity_pages *
+		sizeof(struct page *), GFP_NOIO | __GFP_ZERO);
+
+	list_for_each_entry(range, &stripe->parity_list, stripe_sibling) {
+		index = range->raid_start;
+		offset = sector_div(index, cache->chunk_size);
+		offset >>= PAGE_SECTOR_SHIFT;
+		offset *= cache->parity_disks;
+
+		r5l_fetch_one_range(ctx, stripe, &stripe->parity_pages[offset],
+			cache->parity_disks, range->data_start, false);
+	}
+	return 0;
+}
+
+static int r5l_fetch_stripes(struct r5c_load_ctx *ctx)
+{
+	struct r5c_stripe *stripe;
+	struct blk_plug plug;
+
+	blk_start_plug(&plug);
+	list_for_each_entry(stripe, &ctx->stripes_without_parity, lru) {
+		r5l_fetch_one_stripe(ctx, stripe);
+	}
+	list_for_each_entry(stripe, &ctx->stripes_with_parity, lru) {
+		r5l_fetch_one_stripe(ctx, stripe);
+	}
+	blk_finish_plug(&plug);
+
+	atomic_dec(&ctx->io_cnt);
+	wait_event(ctx->io_wq, atomic_read(&ctx->io_cnt) == 0);
+
+	return 0;
+}
+
+static u32 r5l_calculate_page_checksum(struct r5l_log *log, struct page *page)
+{
+	u32 csum;
+	void *addr = kmap_atomic(page);
+	csum = r5l_calculate_checksum(log, log->uuid_checksum_data,
+		addr, PAGE_SIZE, true);
+	kunmap_atomic(addr);
+	return csum;
+}
+
+static int r5l_check_one_stripe_checksum(struct r5c_stripe *stripe)
+{
+	struct r5c_cache *cache = stripe->cache;
+	struct r5l_log *log = &cache->log;
+	struct r5c_io_range *range;
+	struct page *page;
+	u64 index;
+	int offset;
+	int ret = 0;
+
+	/* FIXME: we currently ignore all data parity check */
+	list_for_each_entry(range, &stripe->io_ranges, stripe_sibling) {
+		kfree(range->checksum);
+		range->checksum = NULL;
+	}
+
+	if (list_empty(&stripe->parity_list)) {
+		r5c_free_parity_ranges(stripe, false);
+		return 0;
+	}
+
+	list_for_each_entry(range, &stripe->parity_list, stripe_sibling) {
+		index = range->raid_start;
+		offset = sector_div(index, cache->chunk_size);
+		offset >>= PAGE_SECTOR_SHIFT;
+		offset *= cache->parity_disks;
+
+		page = stripe->parity_pages[offset];
+
+		if (le32_to_cpu(range->checksum[0]) !=
+		    r5l_calculate_page_checksum(log, page)) {
+			ret = -EINVAL;
+			break;
+		}
+		if (cache->parity_disks > 1) {
+			page = stripe->parity_pages[offset + 1];
+			if (le32_to_cpu(range->checksum[1]) !=
+			    r5l_calculate_page_checksum(log, page)) {
+				ret = -EINVAL;
+				break;
+			}
+		}
+	}
+	/* If parity checksum is wrong, we don't recovery the stripe */
+	r5c_free_parity_ranges(stripe, !ret ? true : false);
+	return ret;
+}
+
+static int r5l_check_stripes_checksum(struct r5c_load_ctx *ctx)
+{
+	struct r5c_stripe *stripe, *tmp;
+
+	while (!list_empty(&ctx->stripes_without_parity)) {
+		stripe = list_first_entry(&ctx->stripes_without_parity,
+			struct r5c_stripe, lru);
+		list_del_init(&stripe->lru);
+
+		r5l_check_one_stripe_checksum(stripe);
+	}
+
+	list_for_each_entry_safe(stripe, tmp, &ctx->stripes_with_parity, lru) {
+		/* checksum error, don't recover the stripe */
+		if (r5l_check_one_stripe_checksum(stripe)) {
+			list_del_init(&stripe->lru);
+		}
+	}
+
+	return 0;
+}
+
+static int r5c_recover_stripes(struct r5c_load_ctx *ctx)
+{
+	struct r5c_cache *cache = ctx->cache;
+	LIST_HEAD(list);
+	int i;
+
+	r5l_check_stripes_checksum(ctx);
+
+	list_splice_tail(&ctx->io_ranges, &ctx->cache->log_list);
+
+	if (list_empty(&ctx->stripes_with_parity))
+		return 0;
+
+	/*
+	 * we already read all data/metadata in memory, just flush them to raid
+	 * disks.
+	 *
+	 * But note for parity, we should use that stored in cache disk instead
+	 * of that we calculated in recovery, since raid array isn't in
+	 * consistent state. The in_recovery is for this purpose.
+	 * */
+	cache->in_recovery = 1;
+
+	while (!list_empty(&ctx->stripes_with_parity)) {
+		i = 0;
+		/*
+		 * Can't handle large stripe list because of the size
+		 * limitation of flush_end block. We don't really need
+		 * flush_end though, but adding it makes we can share the
+		 * reclaim code
+		 * */
+		while (i < RECLAIM_BATCH &&
+		       !list_empty(&ctx->stripes_with_parity)) {
+			list_move_tail(ctx->stripes_with_parity.next,
+				&list);
+			i++;
+		}
+		r5c_reclaim_stripe_list(cache, &list);
+		BUG_ON(!list_empty(&list));
+	}
+
+	cache->in_recovery = 0;
+	return 0;
+}
+
+static void *r5l_read_meta_block(struct r5l_log *log, r5blk_t block,
+	u64 expected_seq, struct page **retpage)
+{
+	struct page *page = alloc_page(GFP_KERNEL|__GFP_ZERO);
+	struct r5l_meta_header *header;
+	u32 crc, stored_crc;
+
+	if (!sync_page_io(log->rdev, r5l_block_to_sector(log, block),
+	    log->block_size, page, READ, false))
+		return NULL;
+
+	header = page_address(page);
+	stored_crc = le32_to_cpu(header->checksum);
+	header->checksum = 0;
+
+	if (le32_to_cpu(header->magic) != R5LOG_MAGIC ||
+	    le64_to_cpu(header->seq) != expected_seq ||
+	    le64_to_cpu(header->position) != block)
+		goto error;
+	if (le32_to_cpu(header->type) != R5LOG_TYPE_META &&
+	    le32_to_cpu(header->type) != R5LOG_TYPE_FLUSH_START &&
+	    le32_to_cpu(header->type) != R5LOG_TYPE_FLUSH_END)
+		goto error;
+
+	crc = r5l_calculate_checksum(log, log->uuid_checksum_meta,
+			header, log->block_size, false);
+	if (stored_crc != crc)
+		goto error;
+
+	if (le32_to_cpu(header->meta_size) > log->block_size)
+		goto error;
+	*retpage = page;
+	return header;
+error:
+	__free_page(page);
+	return NULL;
+}
+
 static int r5l_load_log(struct r5l_log *log)
 {
+	r5blk_t last_cp = log->last_checkpoint;
+	u64 last_seq = log->last_cp_seq;
+	r5blk_t payload_block;
+	struct page *page = NULL;
+	struct r5l_meta_header *header;
+	void *meta;
+	struct r5l_meta_payload *payload;
+	struct r5c_load_ctx ctx;
+	int offset;
+
+	ctx.cache = r5l_cache(log);
+	INIT_LIST_HEAD(&ctx.io_ranges);
+	INIT_LIST_HEAD(&ctx.stripes_with_parity);
+	INIT_LIST_HEAD(&ctx.stripes_without_parity);
+	atomic_set(&ctx.io_cnt, 1);
+	init_waitqueue_head(&ctx.io_wq);
+
+again:
+	if (page) {
+		__free_page(page);
+		page = NULL;
+	}
+	header = r5l_read_meta_block(log, last_cp, last_seq, &page);
+	if (!header)
+		goto finish;
+	offset = sizeof(struct r5l_meta_header);
+
+	if (le32_to_cpu(header->type) == R5LOG_TYPE_FLUSH_START) {
+		r5c_add_flush_start(&ctx, (struct r5l_flush_block *)header,
+					last_seq);
+		last_cp = r5l_ring_add(log, last_cp, 1);
+		last_seq++;
+		goto again;
+	}
+
+	if (le32_to_cpu(header->type) == R5LOG_TYPE_FLUSH_END) {
+		r5c_add_flush_end(&ctx, (struct r5l_flush_block *)header,
+				last_seq);
+		last_cp = r5l_ring_add(log, last_cp, 1);
+		last_seq++;
+		goto again;
+	}
+
+	meta = header;
+	payload = meta + offset;
+	payload_block = r5l_ring_add(log, last_cp, 1);
+
+	while (offset < cpu_to_le32(header->meta_size)) {
+		u16 type = le16_to_cpu(payload->payload_type);
+		u16 entries = le32_to_cpu(payload->blocks) >>
+				log->page_block_shift;
+		u32 *checksum;
+
+		checksum = kmalloc(sizeof(u32) * entries, GFP_KERNEL);
+		memcpy(checksum, payload->data_checksum, sizeof(u32) * entries);
+		if (type == R5LOG_PAYLOAD_DATA) {
+			r5c_add_data(&ctx, last_seq,
+			  r5l_block_to_sector(log, last_cp),
+			  r5l_block_to_sector(log, payload_block),
+			  le64_to_cpu(payload->location),
+			  entries << PAGE_SECTOR_SHIFT, checksum);
+		} else {
+			r5c_add_parity(&ctx, last_seq,
+			  r5l_block_to_sector(log, last_cp),
+			  r5l_block_to_sector(log, payload_block),
+			  le64_to_cpu(payload->location),
+			  entries << PAGE_SECTOR_SHIFT, checksum);
+		}
+		payload_block = r5l_ring_add(log, payload_block,
+			r5l_page_blocks(log, entries));
+		offset += sizeof(struct r5l_meta_payload) +
+			entries * sizeof(u32);
+		payload = meta + offset;
+	}
+
+	last_seq++;
+	last_cp = payload_block;
+	goto again;
+finish:
+	if (page)
+		__free_page(page);
+
+	r5c_analyse_log(&ctx);
+
+	r5l_fetch_stripes(&ctx);
+
+	log->seq = last_seq;
+	log->log_start = last_cp;
+	r5c_recover_stripes(&ctx);
+
 	return 0;
 }
 
-- 
1.8.1

