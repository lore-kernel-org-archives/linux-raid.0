From: Shaohua Li <shli@fb.com>
Subject: [PATCH V4 04/13] raid5: cache part of raid5 cache
Date: Tue, 23 Jun 2015 14:37:54 -0700
Message-ID: <1b6752eb31ee0ee86be798dcc34ba43566fe9cdb.1435094582.git.shli@fb.com>
References: <cover.1435094582.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cover.1435094582.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com, neilb@suse.de
List-Id: linux-raid.ids

This is the in-memory representation of cache. It includes a memory pool
to store data which isn't flushed to raid disks yet and index to track
data stored in cache disk.

When new request bio comes to the raid array with cache, we copy data of
the bio to a memory pool and write the bio to cache disk for write
request; copy data from memory pool to bio or directly dispatch the bio
to raid disks depending on if the bio has data in memory pool for read
request. stripe (see below) is the basic track unit, it's aligned to
stripe boundary and stripe size. we must make sure request has correct
alignment and size.

A stripe (r5c_stripe) tracks stripe data. Note, there is difference
between the stripe and existing raid5 stripe cache stripe. stripe here
tracks data of chunk size * raid disks, while stripe cache stripe tracks
data of a single 4k stripe accross all raid disks disks. There is a
radix-tree to map raid disk sector to a stripe. If we write a stripe, we
copy data to the stripe data_pages and write the data to log. To know
where we put the data to log, we have a r5c_io_range to track it. Each
stripe has a list of r5c_io_ranges. At some time, data of a stripe can
be written to raid disks (at reclaim time). After the data is in raid
disks, the stripe and its data pages will be freed.

Each io_range tracks a chunk of data stored in cache disk. io_range are
in two lists. One is in stripe list, the other a global log list. Both
are sorted in time order (or sequence order). The ordering in stripe
list lets us find latest data. The ordering in log list helps track log
tail, so we don't corrupt data which isn't written to raid disks.

We don't have a data structure to track parity of a stripe. We just
write parity to log in reclaim. After reclaim finishes, disk space of
the stripe (including data and parity) can be reused, so we don't need
to track parity in memory.

The cache part doesn't dispatch IO to cache disk. It's the
responsibility of log part. Cache part just sends task to log.

We don't use existing stripe cache mechanism to track stripe. Partly
because existing stripe cache state machine is complex enough we don't
want to make it worse. A new memory pool (and stripe raidx tree) is more
efficient for the cache layer. A separate memory pool is more flexible
too. A memory pool isn't a must-have, since all data is stored in cache
disk, we might remove the memory pool in the future (compared to cache
disk, memory pool is far smaller. The memory pool causes more reclaim
activity and can't absorb write latency). We can easily remove the
separate memory pool if necessary.

Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/Makefile      |   2 +-
 drivers/md/raid5-cache.c | 870 +++++++++++++++++++++++++++++++++++++++++++++++
 drivers/md/raid5.c       |  21 +-
 drivers/md/raid5.h       |   6 +
 4 files changed, 896 insertions(+), 3 deletions(-)

diff --git a/drivers/md/Makefile b/drivers/md/Makefile
index dba4db5..aeb4330 100644
--- a/drivers/md/Makefile
+++ b/drivers/md/Makefile
@@ -16,7 +16,7 @@ dm-cache-mq-y   += dm-cache-policy-mq.o
 dm-cache-cleaner-y += dm-cache-policy-cleaner.o
 dm-era-y	+= dm-era-target.o
 md-mod-y	+= md.o bitmap.o
-raid456-y	+= raid5.o
+raid456-y	+= raid5.o raid5-cache.o
 
 # Note: link order is important.  All raid personalities
 # and must come before md.o, as they each initialise 
diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index d6b7c64..d0950ae 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -30,6 +30,10 @@
 #define LOG_FLUSH_TIME HZ
 #define LOG_SUPER_WRITE_TIME (5 * HZ)
 
+#define MAX_MEM (256 * 1024 * 1024)
+#define RECLAIM_BATCH 16
+#define CHECKPOINT_TIMEOUT (5 * HZ)
+
 typedef u64 r5blk_t; /* log blocks, could be 512B - 4k */
 
 /*
@@ -191,6 +195,154 @@ struct r5l_io_unit {
 	int error;
 };
 
+/*
+ * a stripe can have data stored to several different chunks in log. each chunk
+ * is a bio (or r5l_task) dispatched to log. When r5l_task is finished,
+ * r5l_task will return position where the bio and corresponding metadata is
+ * stored in cache disk and a sequence number of its metadata. we use a data
+ * structure to index the chunk in memory, which is a r5c_io_range. 
+ *
+ * io_range will be in two lists. One is the stripe_sibling, which is linked to
+ * stripe list. The other is the log_sibling, which is linked to
+ * r5c_cache->log_list. Both lists are sorted, io_range is added to the lists
+ * in time order (or sequence order, since newer io_range has higher sequence
+ * order.
+ *
+ * In the stripe list, ordering can be used to destinguish if data is newer.
+ * newer data is at the tail of the list.
+ *
+ * In the log list, io_range is used to track cache disk usage. the first
+ * entry's meta_start is the log tail. Note, if a stripe is reclaimed, its
+ * io_ranges are deleted. Since each stripe can have its io_ranges stored
+ * sparsely in cache disk, the log list might have holes, but the first entry's
+ * meta_start is always the log tail. The ordering guarantees we can find log
+ * tail. We use meta_start for log tail tracking, because one r5l_meta_block
+ * records several chunks (or io_unit), the meta data can be freed only after
+ * all data pages it tracked are freed.
+ *
+ * When log dispatches IO to cache disk, several io_range (each is a bio) will
+ * be in one r5l_io_unit, so the io_ranges will have the same meta_start and
+ * sequence
+ * */
+struct r5c_io_range {
+	struct list_head log_sibling; /*link to cache->log_list */
+	struct list_head stripe_sibling; /* link to stripe->io_ranges */
+
+	u64 seq; /* sequence of its metadata */
+
+	/* cache disk position of corresponding r5l_meta_block */
+	sector_t meta_start;
+	sector_t data_start; /* cache disk position of data */
+	sector_t raid_start; /* raid position the data should be stored */
+	unsigned int data_sectors;
+
+	struct r5c_stripe *stripe;
+	union {
+		struct bio *bio;
+		u32 *checksum; /* only for recovery */
+	};
+};
+
+/*
+ * track a stripe (chunk_size * raid_disks), not a stripe_cache
+ *
+ * we must be careful about appending data to a stripe when the stripe is being
+ * reclaimed. If we append data to a stripe between stripe parity is in cache
+ * disk and stripe isn't fully reclaimed (reusable), the modified data doesn't
+ * match with parity, recovery will get confused. So if we are reclaiming a
+ * stripe, we freeze the stripe and don't allow new data added to it till the
+ * stripe is fully reclaimed
+ * */
+struct r5c_stripe {
+	u64 raid_index;
+	struct r5c_cache *cache;
+	atomic_t ref;
+	int state;
+	int recovery_state; /* just for recovery */
+
+	struct list_head io_ranges; /* ordered list of r5c_io_range */
+	union {
+		struct list_head stripes;
+		struct list_head parity_list; /* just for recovery */
+	};
+
+	struct list_head lru;
+
+	int existing_pages;
+	atomic_t dirty_stripes;
+	atomic_t pending_bios;
+	struct page **parity_pages; /* just for recovery */
+	struct page *data_pages[];
+};
+
+/* stripe state */
+enum {
+	STRIPE_RUNNING = 0, /* stripe can accept new data */
+	STRIPE_FROZEN = 1, /* Doesn't accept new data and is reclaiming */
+	STRIPE_PARITY_DONE = 2, /* stripe parity is cache disk */
+	STRIPE_INRAID = 3, /* stripe data/parity are in raid disks */
+	STRIPE_DEAD = 4, /* stripe can be reused */
+};
+
+#define STRIPE_LOCK_BITS 8
+struct r5c_cache {
+	struct mddev *mddev;
+	struct md_rdev *rdev;
+
+	struct r5l_log log;
+
+	spinlock_t tree_lock; /* protect stripe_tree, log_list, full_stripes */
+	struct radix_tree_root stripe_tree;
+	struct list_head log_list; /* sorted list of io_range */
+	struct list_head full_stripes; /* stripes have data full */
+	int full_stripe_cnt;
+
+	struct list_head page_pool;
+	spinlock_t pool_lock;
+	u64 free_pages;
+	u64 total_pages;
+	u64 max_pages;
+	/* background reclaim starts when free memory hits this watermark */
+	u64 low_watermark;
+	/* background reclaim stops when free memory hits this watermark */
+	u64 high_watermark;
+
+	unsigned int stripe_data_size; /* chunk_size * data_disks, sector */
+	unsigned int chunk_size; /* sector */
+	unsigned int stripe_size; /* chunk_size * all disks, sector */
+	unsigned int parity_disks; /* parity disks of a stripe */
+	unsigned int stripe_data_pages; /* total data pages of a stripe */
+	unsigned int stripe_parity_pages; /* total parity pages of a stripe */
+
+	unsigned int reclaim_batch;
+
+	unsigned int reserved_space; /* log reserved size, sector */
+
+	unsigned long reclaim_reason;
+	wait_queue_head_t reclaim_wait;
+	struct md_thread *reclaim_thread;
+	__le64 *stripe_flush_data;
+	int quiesce_state;
+
+	int in_recovery; /* in recovery mode */
+
+	struct work_struct pending_io_work;
+
+	spinlock_t stripe_locks[1 << STRIPE_LOCK_BITS];
+	wait_queue_head_t stripe_waitq[1 << STRIPE_LOCK_BITS];
+
+	int error_state;
+	int error_type;
+	int retry_cnt;
+	unsigned long next_retry_time;
+	struct bio_list retry_bio_list; /* bios should be retried after IO error */
+	wait_queue_head_t error_wait;
+
+	struct kmem_cache *io_range_kc;
+	struct kmem_cache *stripe_kc;
+	struct bio_set *bio_set;
+};
+
 /* reclaim reason */
 enum {
 	RECLAIM_MEM = 0, /* work hard to reclaim memory */
@@ -1139,6 +1291,539 @@ static int r5l_write_super(struct r5l_log *log, u64 seq, sector_t cp)
 	return 0;
 }
 
+static inline void r5c_sector_stripe_index_offset(struct r5c_cache *cache,
+	sector_t sect, u64 *index, unsigned int *offset)
+{
+	*offset = sector_div(sect, cache->stripe_data_size);
+	*index = sect;
+}
+
+static inline sector_t r5c_stripe_raid_sector(struct r5c_cache *cache,
+	struct r5c_stripe *stripe)
+{
+	return stripe->raid_index * cache->stripe_data_size;
+}
+
+static void r5c_lock_stripe(struct r5c_cache *cache, struct r5c_stripe *stripe,
+	unsigned long *flags)
+{
+	spinlock_t *lock;
+
+	lock = &cache->stripe_locks[hash_ptr(stripe, STRIPE_LOCK_BITS)];
+	spin_lock_irqsave(lock, *flags);
+}
+
+static void r5c_unlock_stripe(struct r5c_cache *cache,
+	struct r5c_stripe *stripe, unsigned long *flags)
+{
+	spinlock_t *lock;
+
+	lock = &cache->stripe_locks[hash_ptr(stripe, STRIPE_LOCK_BITS)];
+	spin_unlock_irqrestore(lock, *flags);
+}
+
+static wait_queue_head_t *r5c_stripe_waitq(struct r5c_cache *cache,
+	struct r5c_stripe *stripe)
+{
+	return &cache->stripe_waitq[hash_ptr(stripe, STRIPE_LOCK_BITS)];
+}
+
+static void r5c_stripe_wait_state(struct r5c_cache *cache,
+	struct r5c_stripe *stripe, int state)
+{
+	wait_event(*r5c_stripe_waitq(cache, stripe), stripe->state >= state);
+}
+
+static struct page *r5c_get_page(struct r5c_cache *cache)
+{
+	struct page *page;
+again:
+	spin_lock_irq(&cache->pool_lock);
+	if (!list_empty(&cache->page_pool)) {
+		page = list_first_entry(&cache->page_pool,
+			struct page, lru);
+		list_del_init(&page->lru);
+		cache->free_pages--;
+		if (cache->free_pages < cache->low_watermark)
+			r5c_wake_reclaimer(cache,
+				RECLAIM_MEM_BACKGROUND);
+	}
+	spin_unlock_irq(&cache->pool_lock);
+	if (page)
+		return page;
+	r5c_wake_wait_reclaimer(cache, RECLAIM_MEM);
+	goto again;
+}
+
+static void r5c_put_pages(struct r5c_cache *cache,
+	struct page *pages[], int size)
+{
+	unsigned long flags;
+	int free = 0;
+	int i;
+
+	spin_lock_irqsave(&cache->pool_lock, flags);
+	for (i = 0; i < size; i++) {
+		if (!pages[i])
+			continue;
+		if (cache->total_pages > cache->max_pages) {
+			__free_page(pages[i]);
+			cache->total_pages--;
+		} else {
+			list_add(&pages[i]->lru, &cache->page_pool);
+			free++;
+		}
+	}
+	cache->free_pages += free;
+	if (cache->free_pages >= cache->high_watermark)
+		clear_bit(RECLAIM_MEM_BACKGROUND, &cache->reclaim_reason);
+	clear_bit(RECLAIM_MEM, &cache->reclaim_reason);
+	spin_unlock_irqrestore(&cache->pool_lock, flags);
+
+	wake_up(&cache->reclaim_wait);
+}
+
+static struct r5c_stripe *
+r5c_search_stripe(struct r5c_cache *cache, u64 stripe_index)
+{
+	struct r5c_stripe *stripe;
+
+	spin_lock_irq(&cache->tree_lock);
+	stripe = radix_tree_lookup(&cache->stripe_tree, stripe_index);
+	spin_unlock_irq(&cache->tree_lock);
+	return stripe;
+}
+
+static void r5c_put_stripe(struct r5c_stripe *stripe);
+static struct r5c_stripe *
+r5c_get_stripe(struct r5c_cache *cache, u64 stripe_index)
+{
+	struct r5c_stripe *stripe;
+
+again:
+	spin_lock_irq(&cache->tree_lock);
+	stripe = radix_tree_lookup(&cache->stripe_tree, stripe_index);
+	if (stripe)
+		atomic_inc(&stripe->ref);
+	spin_unlock_irq(&cache->tree_lock);
+
+	if (!stripe)
+		return NULL;
+	BUG_ON(stripe->raid_index != stripe_index);
+
+	/*
+	 * The stripe is being reclaimed, wait reclaim finish, see the comment
+	 * in r5c_stripe
+	 * */
+	if (stripe->state >= STRIPE_FROZEN) {
+		r5c_stripe_wait_state(cache, stripe, STRIPE_DEAD);
+		r5c_put_stripe(stripe);
+		goto again;
+	}
+	return stripe;
+}
+
+static struct r5c_stripe *
+r5c_create_get_stripe(struct r5c_cache *cache, u64 stripe_index)
+{
+	struct r5c_stripe *stripe, *new;
+	int error;
+
+again:
+	spin_lock_irq(&cache->tree_lock);
+	stripe = radix_tree_lookup(&cache->stripe_tree, stripe_index);
+	if (stripe)
+		atomic_inc(&stripe->ref);
+	spin_unlock_irq(&cache->tree_lock);
+
+	if (stripe)
+		goto has_stripe;
+
+	new = kmem_cache_zalloc(cache->stripe_kc, GFP_NOIO);
+	if (!new)
+		return NULL;
+
+	new->raid_index = stripe_index;
+	atomic_set(&new->ref, 2);
+	new->state = STRIPE_RUNNING;
+	new->cache = cache;
+	INIT_LIST_HEAD(&new->io_ranges);
+	INIT_LIST_HEAD(&new->stripes);
+	INIT_LIST_HEAD(&new->lru);
+
+	error = radix_tree_preload(GFP_NOIO);
+	if (error) {
+		kmem_cache_free(cache->stripe_kc, new);
+		return NULL;
+	}
+
+	spin_lock_irq(&cache->tree_lock);
+	if (radix_tree_insert(&cache->stripe_tree, stripe_index, new)) {
+		stripe = radix_tree_lookup(&cache->stripe_tree, stripe_index);
+		atomic_inc(&stripe->ref);
+		kmem_cache_free(cache->stripe_kc, new);
+	} else
+		stripe = new;
+	spin_unlock_irq(&cache->tree_lock);
+
+	radix_tree_preload_end();
+
+	BUG_ON(stripe->raid_index != stripe_index);
+has_stripe:
+	/*
+	 * The stripe is being reclaimed, wait reclaim finish, see the comment
+	 * in r5c_stripe
+	 * */
+	if (stripe->state >= STRIPE_FROZEN) {
+		r5c_stripe_wait_state(cache, stripe, STRIPE_DEAD);
+		r5c_put_stripe(stripe);
+		goto again;
+	}
+
+	return stripe;
+}
+
+static void r5c_put_stripe(struct r5c_stripe *stripe)
+{
+	struct r5c_cache *cache = stripe->cache;
+	struct r5c_io_range *range;
+	unsigned long flags, flags2;
+
+	local_irq_save(flags);
+
+	/*
+	 * must take lock too, since we can't access stripe if its ref is
+	 * dropped to 0
+	 **/
+	if (!atomic_dec_and_lock(&stripe->ref, &cache->tree_lock)) {
+		local_irq_restore(flags);
+		/* the stripe is freezing, might wait for ref */
+		wake_up(r5c_stripe_waitq(cache, stripe));
+
+		return;
+	}
+
+	BUG_ON(radix_tree_delete(&cache->stripe_tree, stripe->raid_index)
+		!= stripe);
+
+	r5c_lock_stripe(cache, stripe, &flags2);
+	while (!list_empty(&stripe->io_ranges)) {
+		range = list_first_entry(&stripe->io_ranges,
+			struct r5c_io_range, stripe_sibling);
+		list_del(&range->stripe_sibling);
+
+		list_del(&range->log_sibling);
+
+		kmem_cache_free(cache->io_range_kc, range);
+	}
+	r5c_put_pages(cache, stripe->data_pages, cache->stripe_data_pages);
+	BUG_ON(stripe->parity_pages);
+
+	r5c_unlock_stripe(cache, stripe, &flags2);
+
+	spin_unlock_irqrestore(&cache->tree_lock, flags);
+
+	kmem_cache_free(cache->stripe_kc, stripe);
+}
+
+static void r5c_bio_task_end(struct r5l_task *task, int error)
+{
+	struct r5c_io_range *range = task->private;
+	struct r5c_stripe *stripe = range->stripe;
+	struct r5c_cache *cache = stripe->cache;
+	struct r5c_io_range *tmp;
+	unsigned long flags, flags2;
+	struct bio *orig_bio;
+
+	range->seq = task->seq;
+	range->meta_start = task->meta_start;
+	range->data_start = task->data_start;
+	orig_bio = task->orig_bio;
+	kfree(task);
+
+	spin_lock_irqsave(&cache->tree_lock, flags);
+
+	if (list_empty(&cache->log_list)) {
+		list_add_tail(&range->log_sibling, &cache->log_list);
+		goto out;
+	}
+
+	/*
+	 * generally tmp will be the last one. The order is important to track
+	 * log tail, see comments in r5c_io_range
+	 * */
+	list_for_each_entry_reverse(tmp, &cache->log_list, log_sibling) {
+		/*
+		 * later range has bigger seq and meta_start than previous
+		 * range
+		 **/
+		if (range->seq >= tmp->seq)
+			break;
+	}
+	list_add_tail(&range->log_sibling, &tmp->log_sibling);
+out:
+	r5c_lock_stripe(cache, stripe, &flags2);
+	/*
+	 * full stripes aren't reclaimed immediately till we have enough such
+	 * stripes, this is to improve performance
+	 * */
+	if (stripe->existing_pages == cache->stripe_data_pages &&
+	    list_empty(&stripe->lru)) {
+		list_add_tail(&stripe->lru, &cache->full_stripes);
+		cache->full_stripe_cnt++;
+		if (cache->full_stripe_cnt >= cache->reclaim_batch)
+			r5c_wake_reclaimer(cache,
+				RECLAIM_MEM_FULL);
+	}
+	r5c_unlock_stripe(cache, stripe, &flags2);
+
+	spin_unlock_irqrestore(&cache->tree_lock, flags);
+
+	if (!error) {
+		bio_endio(orig_bio, 0);
+		md_write_end(cache->mddev);
+	}
+
+	r5c_put_stripe(stripe);
+}
+
+static void r5c_copy_bio(struct bio *bio, struct page *pages[], bool tobio)
+{
+	struct bio *src = bio;
+	struct bvec_iter iter;
+	struct bio_vec bv;
+	void *src_p, *dst_p;
+	unsigned page_index = 0, page_offset = 0;
+	unsigned bytes;
+
+	iter = src->bi_iter;
+
+	while (1) {
+		if (!iter.bi_size) {
+			src = src->bi_next;
+			if (!src)
+				break;
+
+			iter = src->bi_iter;
+		}
+
+		if (page_offset == PAGE_SIZE) {
+			page_index++;
+			page_offset = 0;
+		}
+
+		bv = bio_iter_iovec(src, iter);
+
+		bytes = min_t(unsigned int, bv.bv_len, PAGE_SIZE - page_offset);
+
+		src_p = kmap_atomic(bv.bv_page);
+		dst_p = kmap_atomic(pages[page_index]);
+
+		if (tobio) {
+			memcpy(src_p + bv.bv_offset,
+			       dst_p + page_offset, bytes);
+		} else {
+			memcpy(dst_p + page_offset,
+			       src_p + bv.bv_offset, bytes);
+		}
+
+		kunmap_atomic(dst_p);
+		kunmap_atomic(src_p);
+
+		bio_advance_iter(src, &iter, bytes);
+		page_offset += bytes;
+	}
+}
+
+static void r5c_bio_flush_task_end(struct r5l_task *task, int error)
+{
+	struct r5c_cache *cache = task->private;
+	struct bio *orig_bio = task->orig_bio;
+	unsigned long flags;
+
+	kfree(task);
+
+	if (!error) {
+		bio_endio(orig_bio, 0);
+		md_write_end(cache->mddev);
+	}
+}
+
+static void r5c_write_bio(struct r5c_cache *cache, struct bio *bio)
+{
+	struct r5c_stripe *stripe;
+	struct r5c_io_range *io_range;
+	u64 index;
+	unsigned int offset;
+	int i, new_pages = 0;
+	unsigned long flags;
+	unsigned int reserved_blocks = 0;
+	unsigned int pages;
+
+	/* Doesn't support discard */
+	if (bio->bi_rw & REQ_DISCARD) {
+		bio_endio(bio, 0);
+		md_write_end(cache->mddev);
+		return;
+	}
+
+	if (bio->bi_iter.bi_size == 0) {
+		BUG_ON(!(bio->bi_rw & REQ_FLUSH));
+		if (r5l_queue_empty_flush_bio(&cache->log, bio,
+		    r5c_bio_flush_task_end, cache))
+			goto enter_error;
+		return;
+	}
+
+	pages = bio_sectors(bio) >> PAGE_SECTOR_SHIFT;
+	reserved_blocks = 1 + r5l_page_blocks(&cache->log, pages);
+	r5l_get_reserve(&cache->log, reserved_blocks);
+
+	r5c_sector_stripe_index_offset(cache, bio->bi_iter.bi_sector,
+		&index, &offset);
+
+	stripe = r5c_create_get_stripe(cache, index);
+	if (!stripe)
+		goto enter_error;
+
+	io_range = kmem_cache_alloc(cache->io_range_kc, GFP_NOIO);
+	if (!io_range)
+		goto put_error;
+
+	io_range->bio = bio;
+	io_range->raid_start = bio->bi_iter.bi_sector;
+	io_range->data_sectors = bio_sectors(bio);
+	io_range->stripe = stripe;
+
+	/* FIXME: if read comes in here, it might read random data */
+	offset >>= PAGE_SECTOR_SHIFT;
+	for (i = offset; i < offset + (bio_sectors(bio) >> PAGE_SECTOR_SHIFT);
+	     i++) {
+		if (stripe->data_pages[i])
+			continue;
+		stripe->data_pages[i] = r5c_get_page(cache);
+		new_pages++;
+	}
+
+	r5c_copy_bio(bio, &stripe->data_pages[offset], false);
+
+	r5c_lock_stripe(cache, stripe, &flags);
+	list_add_tail(&io_range->stripe_sibling, &stripe->io_ranges);
+	stripe->existing_pages += new_pages;
+	r5c_unlock_stripe(cache, stripe, &flags);
+
+	if (r5l_queue_bio(&cache->log, bio, r5c_bio_task_end, io_range,
+	    reserved_blocks))
+		goto put_error;
+	return;
+put_error:
+	r5c_put_stripe(stripe);
+enter_error:
+	r5l_put_reserve(&cache->log, reserved_blocks);
+	raid5_make_request(cache->mddev, bio);
+}
+
+static void r5c_read_bio(struct r5c_cache *cache, struct bio *bio)
+{
+	struct r5c_stripe *stripe;
+	u64 stripe_index;
+	int offset;
+	u64 start, end, tmp;
+	struct bio *split;
+
+	r5c_sector_stripe_index_offset(cache, bio->bi_iter.bi_sector,
+		&stripe_index, &offset);
+
+	stripe = r5c_get_stripe(cache, stripe_index);
+	if (!stripe) {
+		raid5_make_request(cache->mddev, bio);
+		return;
+	}
+
+	start = offset >> PAGE_SECTOR_SHIFT;
+	end = start + (bio_sectors(bio) >> PAGE_SECTOR_SHIFT);
+
+	while (start < end) {
+		if (stripe->data_pages[start]) {
+			tmp = start;
+			while (tmp < end && stripe->data_pages[tmp])
+				tmp++;
+			if (tmp < end) {
+				split = bio_split(bio,
+					(tmp - start) << PAGE_SECTOR_SHIFT,
+					GFP_NOIO, NULL);
+				bio_chain(split, bio);
+			} else /* all in cache */
+				split = bio;
+
+			r5c_copy_bio(split, &stripe->data_pages[start], true);
+
+			bio_endio(split, 0);
+
+			start = tmp;
+		} else {
+			tmp = start;
+			while (tmp < end && !stripe->data_pages[tmp])
+				tmp++;
+			if (tmp < end) {
+				split = bio_split(bio,
+					(tmp - start) << PAGE_SECTOR_SHIFT,
+					GFP_NOIO, NULL);
+				bio_chain(split, bio);
+			} else
+				split = bio;
+
+			raid5_make_request(cache->mddev, split);
+
+			start = tmp;
+		}
+	}
+	r5c_put_stripe(stripe);
+}
+
+static void r5c_flush_pending_io(struct r5c_cache *cache)
+{
+	r5l_run_tasks(&cache->log, false);
+}
+
+static void r5c_unplug_work(struct work_struct *work)
+{
+	struct r5c_cache *cache = container_of(work, struct r5c_cache,
+		pending_io_work);
+	r5c_flush_pending_io(cache);
+}
+
+static void r5c_unplug(struct blk_plug_cb *cb, bool from_schedule)
+{
+	struct r5c_cache *cache = cb->data;
+
+	kfree(cb);
+	if (from_schedule) {
+		schedule_work(&cache->pending_io_work);
+		return;
+	}
+	r5c_flush_pending_io(cache);
+}
+
+/* we aggregate bio to plug list, so each r5l_meta_block can track more data */
+void r5c_handle_bio(struct r5c_cache *cache, struct bio *bio)
+{
+	struct blk_plug_cb *cb;
+
+	if (bio_data_dir(bio) == READ) {
+		r5c_read_bio(cache, bio);
+		return;
+	}
+
+	md_write_start(cache->mddev, bio);
+
+	r5c_write_bio(cache, bio);
+
+	cb = blk_check_plugged(r5c_unplug, cache, sizeof(*cb));
+	if (!cb)
+		r5c_flush_pending_io(cache);
+}
+
 static void r5c_wake_reclaimer(struct r5c_cache *cache, int reason)
 {
 }
@@ -1315,3 +2000,188 @@ static void r5l_exit_log(struct r5l_log *log)
 	kmem_cache_destroy(log->io_kc);
 	__free_page(log->super_page);
 }
+
+static void r5c_calculate_watermark(struct r5c_cache *cache)
+{
+	u64 pages = cache->max_pages >> 3;
+
+	if (pages < 1024)
+		cache->low_watermark = 1024;
+	else
+		cache->low_watermark = pages;
+	cache->high_watermark = cache->low_watermark << 1;
+}
+
+static int r5c_shrink_cache_memory(struct r5c_cache *cache, unsigned long size)
+{
+	LIST_HEAD(page_list);
+	struct page *page, *tmp;
+
+	if (cache->total_pages <= size)
+		return 0;
+
+	spin_lock_irq(&cache->pool_lock);
+	cache->max_pages = size;
+	r5c_calculate_watermark(cache);
+	spin_unlock_irq(&cache->pool_lock);
+
+	while (cache->total_pages > size) {
+		spin_lock_irq(&cache->pool_lock);
+		if (cache->total_pages - cache->free_pages >= size) {
+			list_splice_init(&cache->page_pool, &page_list);
+			cache->total_pages -= cache->free_pages;
+			cache->free_pages = 0;
+		} else {
+			while (cache->total_pages > size) {
+				list_move(cache->page_pool.next, &page_list);
+				cache->total_pages--;
+				cache->free_pages--;
+			}
+		}
+		spin_unlock_irq(&cache->pool_lock);
+
+		list_for_each_entry_safe(page, tmp, &page_list, lru) {
+			list_del_init(&page->lru);
+			__free_page(page);
+		}
+
+		r5c_wake_wait_reclaimer(cache, RECLAIM_MEM_BACKGROUND);
+	}
+	return 0;
+}
+
+static void r5c_free_cache_data(struct r5c_cache *cache)
+{
+	struct r5c_stripe *stripe;
+	struct page *page, *tmp;
+	struct radix_tree_iter iter;
+	void **slot;
+
+	radix_tree_for_each_slot(slot, &cache->stripe_tree, &iter, 0) {
+		stripe = radix_tree_deref_slot(slot);
+		r5c_put_stripe(stripe);
+	}
+
+	BUG_ON(!list_empty(&cache->log_list));
+
+	list_for_each_entry_safe(page, tmp, &cache->page_pool, lru) {
+		list_del_init(&page->lru);
+		__free_page(page);
+	}
+}
+
+struct r5c_cache *r5c_init_cache(struct r5conf *conf, struct md_rdev *rdev)
+{
+	struct mddev *mddev = rdev->mddev;
+	struct r5c_cache *cache;
+	int i;
+
+	cache = kzalloc(sizeof(*cache), GFP_KERNEL);
+	if (!cache)
+		return NULL;
+	cache->mddev = mddev;
+	cache->rdev = rdev;
+
+	spin_lock_init(&cache->tree_lock);
+	INIT_RADIX_TREE(&cache->stripe_tree, GFP_ATOMIC);
+	INIT_LIST_HEAD(&cache->log_list);
+	INIT_LIST_HEAD(&cache->full_stripes);
+
+	INIT_LIST_HEAD(&cache->page_pool);
+	spin_lock_init(&cache->pool_lock);
+	INIT_WORK(&cache->pending_io_work, r5c_unplug_work);
+
+	cache->max_pages = MAX_MEM >> PAGE_SHIFT;
+
+	cache->stripe_data_size = conf->chunk_sectors * (conf->raid_disks -
+		conf->max_degraded);
+	cache->chunk_size = conf->chunk_sectors;
+	cache->stripe_size = conf->chunk_sectors * conf->raid_disks;
+	cache->parity_disks = conf->max_degraded;
+	cache->stripe_data_pages = cache->stripe_data_size >> PAGE_SECTOR_SHIFT;
+	cache->stripe_parity_pages = (cache->stripe_size -
+		cache->stripe_data_size) >> PAGE_SECTOR_SHIFT;
+
+	cache->stripe_flush_data = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	if (!cache->stripe_flush_data)
+		goto io_range_kc;
+
+	cache->io_range_kc = KMEM_CACHE(r5c_io_range, 0);
+	if (!cache->io_range_kc)
+		goto io_range_kc;
+	cache->stripe_kc = kmem_cache_create("r5c_stripe",
+		sizeof(struct r5c_stripe) + sizeof(struct page *) *
+		cache->stripe_data_pages, __alignof__(struct r5c_stripe),
+		0, NULL);
+	if (!cache->stripe_kc)
+		goto stripe_kc;
+
+	cache->bio_set = bioset_create(RECLAIM_BATCH, 0);
+	if (!cache->bio_set)
+		goto bio_set;
+
+	cache->reclaim_batch = RECLAIM_BATCH;
+	i = (conf->chunk_sectors >> PAGE_SECTOR_SHIFT) * cache->reclaim_batch;
+	if (i > conf->max_nr_stripes)
+		raid5_set_cache_size(mddev, i);
+
+	/* make sure we can add checkpoint */
+	cache->reserved_space = (cache->stripe_parity_pages <<
+		PAGE_SECTOR_SHIFT) * RECLAIM_BATCH;
+
+	init_waitqueue_head(&cache->reclaim_wait);
+	init_waitqueue_head(&cache->error_wait);
+	bio_list_init(&cache->retry_bio_list);
+
+	for (i = 0; i < (1 << STRIPE_LOCK_BITS); i++) {
+		spin_lock_init(&cache->stripe_locks[i]);
+		init_waitqueue_head(&cache->stripe_waitq[i]);
+	}
+
+	if (r5l_init_log(cache))
+		goto init_log;
+
+	while (cache->total_pages < cache->max_pages) {
+		struct page *page = alloc_page(GFP_KERNEL | __GFP_HIGHMEM);
+
+		if (!page)
+			goto err_page;
+		list_add(&page->lru, &cache->page_pool);
+		cache->free_pages++;
+		cache->total_pages++;
+	}
+
+	r5c_calculate_watermark(cache);
+
+	r5c_shrink_cache_memory(cache, cache->max_pages);
+
+	return cache;
+err_page:
+	r5c_free_cache_data(cache);
+
+	r5l_exit_log(&cache->log);
+init_log:
+	bioset_free(cache->bio_set);
+bio_set:
+	kmem_cache_destroy(cache->stripe_kc);
+stripe_kc:
+	kmem_cache_destroy(cache->io_range_kc);
+io_range_kc:
+	kfree(cache->stripe_flush_data);
+	kfree(cache);
+	return NULL;
+}
+
+void r5c_exit_cache(struct r5c_cache *cache)
+{
+	r5l_exit_log(&cache->log);
+
+	r5c_free_cache_data(cache);
+
+	bioset_free(cache->bio_set);
+	kmem_cache_destroy(cache->stripe_kc);
+	kmem_cache_destroy(cache->io_range_kc);
+
+	kfree(cache->stripe_flush_data);
+	kfree(cache);
+}
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 8160a63..ca164ad 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4661,17 +4661,24 @@ static int raid5_mergeable_bvec(struct mddev *mddev,
 	int max;
 	unsigned int chunk_sectors = mddev->chunk_sectors;
 	unsigned int bio_sectors = bvm->bi_size >> 9;
+	struct r5conf *conf = mddev->private;
 
 	/*
 	 * always allow writes to be mergeable, read as well if array
 	 * is degraded as we'll go through stripe cache anyway.
+	 * with cache, write must align within stripe
 	 */
-	if ((bvm->bi_rw & 1) == WRITE || mddev->degraded)
+	if (((bvm->bi_rw & 1) == WRITE && !conf->cache) || mddev->degraded)
 		return biovec->bv_len;
 
 	if (mddev->new_chunk_sectors < mddev->chunk_sectors)
 		chunk_sectors = mddev->new_chunk_sectors;
 	max =  (chunk_sectors - ((sector & (chunk_sectors - 1)) + bio_sectors)) << 9;
+	if (((bvm->bi_rw & 1) == WRITE) && conf->cache) {
+		chunk_sectors *= conf->raid_disks - conf->max_degraded;
+		max = (chunk_sectors - (sector_div(sector, chunk_sectors) +
+			bio_sectors)) << 9;
+	}
 	if (max < 0) max = 0;
 	if (max <= biovec->bv_len && bio_sectors == 0)
 		return biovec->bv_len;
@@ -5125,7 +5132,7 @@ static void make_discard_request(struct mddev *mddev, struct bio *bi)
 	}
 }
 
-static void make_request(struct mddev *mddev, struct bio * bi)
+void raid5_make_request(struct mddev *mddev, struct bio * bi)
 {
 	struct r5conf *conf = mddev->private;
 	int dd_idx;
@@ -5302,6 +5309,16 @@ static void make_request(struct mddev *mddev, struct bio * bi)
 	}
 }
 
+static void make_request(struct mddev *mddev, struct bio *bi)
+{
+	struct r5conf *conf = mddev->private;
+
+	if (conf->cache)
+		r5c_handle_bio(conf->cache, bi);
+	else
+		raid5_make_request(mddev, bi);
+}
+
 static sector_t raid5_size(struct mddev *mddev, sector_t sectors, int raid_disks);
 
 static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr, int *skipped)
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 896d603..14761c9 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -538,6 +538,7 @@ struct r5conf {
 	struct r5worker_group	*worker_groups;
 	int			group_cnt;
 	int			worker_cnt_per_group;
+	struct r5c_cache	*cache;
 };
 
 
@@ -604,4 +605,9 @@ static inline int algorithm_is_DDF(int layout)
 
 extern void md_raid5_kick_device(struct r5conf *conf);
 extern int raid5_set_cache_size(struct mddev *mddev, int size);
+
+void raid5_make_request(struct mddev *mddev, struct bio *bi);
+void r5c_handle_bio(struct r5c_cache *cache, struct bio *bi);
+struct r5c_cache *r5c_init_cache(struct r5conf *conf, struct md_rdev *rdev);
+void r5c_exit_cache(struct r5c_cache *cache);
 #endif
-- 
1.8.1

