From: Shaohua Li <shli@fb.com>
Subject: [PATCH V4 05/13] raid5: cache reclaim support
Date: Tue, 23 Jun 2015 14:37:55 -0700
Message-ID: <9669ba11505e8fb11e17c07f73cc5b9392e20fce.1435094582.git.shli@fb.com>
References: <cover.1435094582.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cover.1435094582.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com, neilb@suse.de
List-Id: linux-raid.ids

We have two limited resources, memory pool and cache disk space. If
resource is tight, we will do reclaim. In either case, we will flush
some data from cache disk to raid disks. However, we implement different
strategies. For memory reclaim, we prefer reclaiming full stripe. For
cache disk space reclaim, we prefer reclaiming io_range entry at the
head of the global io_range list. We always do reclaim in stripe unit.
Since data which isn't flushed to raid disks is in memory, we don't need
read stripe's data back from cache disk.

Reclaim process will be like:
1. select stripe to reclaim
2. start sending stripe IO to raid disks. raid5 will fetch required data
and calculate parity, and ops_run_io will try to write data/parity.
3. cache hijack ops_run_io, write parity data to cache log. ops_run_io
doesn't write data/parity to raid disks at this time
4. flush cache disk and write flush_start block
5. ops_run_io continues. data/parity will be written to raid disks
6. flush all raid disks cache
7. write flush_end block
8. delete in-memory index of the stripe, and advance superblock log checkpoint

In the process, parity is always appended to log after its corresponding
data. After parity is in cache disk, a flush_start block is appended to
log, which indicates stripe is flushing to raid disks. Data writing to
raid disks only happens after all data and parity are already in cache
disk. This will fix the write whole issue. After a stripe is flushed to
raid disks, a flush_end block is appended to log, which indicates a
stripe is settled down in raid disks.

flush_start isn't strictly required in above process. We calcualte
checksum for both data/parity. The checksum will guarantee data/parity
isn't corrupted, and if all parity of a stripe is in cache disk,
recovery can think the stripe is already running step 5, even it
doesn't. But this doesn't matter, it's not an error recovery writes the
data/parity to raid disks. So the flush_start (step 4) can be replaced
with a 'flush cache disk'. But the flush shouldn't be a simple flush
cache disk, we must maintain log IO ordering like other flush request,
see the patch of 'log part' for the ordering requirement. The
flush_start, however, makes recovery easily determines which stripe
starts step 5. I'm open to remove the flush_start block if necessary.

Reclaim could create holes in the log, eg, some io_range in the middle
is reclaimed, but io_range at the head remains. But this doesn't matter,
the first io_range is always the log tail. Superblock has a field
pointing to the position of log tail. The hole can waste a lot of disk
space though. In the future, we can implement a garbage collection to
mitigate the issue, eg, copy data from the index tail to head.

The performance of the raid will largely be determined by reclaim speed
at run time. Several stages of the reclaim process involves IO wait or
disk cache flush, which significantly impact the raid disk utilization
and performance. The flush_start and flush_end block make running
multiple reclaim possible. Each reclaim only records stripes in the
flush start/end block which it is reclaiming. Recovery can use the
information to correctly determine stripe's flush stage. An example of 2
reclaimer:

xxx1 belongs to stripe1 and the same for stripe2

reclaim 1:  |data1|...|parity1|...|flush_start1|...|flush_end1|
reclaim 2:      |data2|..|parity2|...............|flush_start2|...|flush_end2|

the reclaims only record its own stripes in flush block. If, for
exmaple, recovery finds flush_start1, it knows stripe1 is flushing to
raid disk. Recovery will ignore stripe2, since stripe2 isn't in
flush_start1.

Multiple reclaim will efficiently solve the performance issue, since
pipeline of different reclaim can fill the gap caused by wait. Note,
this doesn't need to be multiple reclaim. The same mechanism should work
for a single thread with multiple reclaim stream (here reclaim1 and
reclaim 2 can thought as a stream), which for example could use a state
machine.

Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/raid5-cache.c | 486 +++++++++++++++++++++++++++++++++++++++++++++++
 drivers/md/raid5.c       |  25 ++-
 drivers/md/raid5.h       |   7 +
 3 files changed, 510 insertions(+), 8 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index d0950ae..84fcb4d 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -1526,6 +1526,26 @@ static void r5c_put_stripe(struct r5c_stripe *stripe)
 	kmem_cache_free(cache->stripe_kc, stripe);
 }
 
+/* must hold cache->tree_lock. Freeze a stripe so it can be reclaimed */
+static bool r5c_freeze_stripe(struct r5c_cache *cache,
+	struct r5c_stripe *stripe, bool blocking)
+{
+	if (atomic_read(&stripe->ref) == 1) {
+		stripe->state = STRIPE_FROZEN;
+		return true;
+	}
+	if (!blocking)
+		return false;
+	/* Make sure no IO running in stripe */
+	wait_event_lock_irq(*r5c_stripe_waitq(cache, stripe),
+			atomic_read(&stripe->ref) == 1 ||
+			stripe->state >= STRIPE_FROZEN, cache->tree_lock);
+	if (stripe->state >= STRIPE_FROZEN)
+		return false;
+	stripe->state = STRIPE_FROZEN;
+	return true;
+}
+
 static void r5c_bio_task_end(struct r5l_task *task, int error)
 {
 	struct r5c_io_range *range = task->private;
@@ -1781,6 +1801,17 @@ static void r5c_read_bio(struct r5c_cache *cache, struct bio *bio)
 	r5c_put_stripe(stripe);
 }
 
+/*
+ * we write parity to log in a batch way, so each r5l_meta_block can track more
+ * parity
+ * */
+void r5c_flush_pending_parity(struct r5c_cache *cache)
+{
+	if (!cache)
+		return;
+	r5l_run_tasks(&cache->log, true);
+}
+
 static void r5c_flush_pending_io(struct r5c_cache *cache)
 {
 	r5l_run_tasks(&cache->log, false);
@@ -1824,12 +1855,460 @@ void r5c_handle_bio(struct r5c_cache *cache, struct bio *bio)
 		r5c_flush_pending_io(cache);
 }
 
+void r5c_write_start(struct mddev *mddev, struct bio *bi)
+{
+	struct r5conf *conf = mddev->private;
+	if (!conf->cache)
+		md_write_start(mddev, bi);
+
+	/*
+	 * With cache, r5c_handle_bio already does md_write_start. This is
+	 * called in reclaim, since quiesce will stop reclaim, we do nothing
+	 * here
+	 * */
+}
+
+void r5c_write_end(struct mddev *mddev, struct bio *bi)
+{
+	struct r5conf *conf = mddev->private;
+	if (!conf->cache) {
+		md_write_end(mddev);
+		return;
+	}
+
+	/*
+	 * r5c_flush_one doesn't set bi_bdev for bio, which doesn't require
+	 * md_write_end. While bio from retry_bio_list (for io error handling)
+	 * has bi_bdev, which require md_write_end
+	 **/
+	if (bi->bi_bdev)
+		md_write_end(mddev);
+
+	/*
+	 * For normal bio, r5c_bio_task_end already does md_write_end. This
+	 * routine is called in reclaim, which doesn't need md_write_end
+	 **/
+}
+
+static void r5c_flush_endio(struct bio *bio, int err)
+{
+	struct r5c_stripe *stripe = bio->bi_private;
+	struct r5c_cache *cache = stripe->cache;
+
+	if (atomic_dec_and_test(&stripe->pending_bios)) {
+		stripe->state = STRIPE_INRAID;
+		wake_up(r5c_stripe_waitq(cache, stripe));
+	}
+
+	bio_put(bio);
+}
+
+static void r5c_flush_one(struct r5c_cache *cache, struct r5c_stripe *stripe,
+	int start, int pages)
+{
+	sector_t base;
+	struct bio *bio;
+	int max_vecs;
+	int i, j;
+
+	i = 0;
+	base = r5c_stripe_raid_sector(cache, stripe) +
+					(start << PAGE_SECTOR_SHIFT);
+	while (i < pages) {
+		/* Below is ugly, but We don't have a block_device */
+		max_vecs = min_t(int, pages - i, BIO_MAX_PAGES);
+		bio = bio_alloc_bioset(GFP_NOIO, max_vecs, cache->bio_set);
+		bio->bi_iter.bi_sector = base + (i << PAGE_SECTOR_SHIFT);
+		bio->bi_bdev = NULL;
+		bio->bi_private = stripe;
+		for (j = 0; j < max_vecs; j++) {
+			struct bio_vec *bvec;
+			bvec = &bio->bi_io_vec[bio->bi_vcnt];
+			bvec->bv_page = stripe->data_pages[i + start];
+			bvec->bv_len = PAGE_SIZE;
+			bvec->bv_offset = 0;
+			bio->bi_vcnt++;
+			bio->bi_phys_segments++;
+			bio->bi_iter.bi_size += PAGE_SIZE;
+			i++;
+		}
+		bio->bi_end_io = r5c_flush_endio;
+		bio->bi_rw = WRITE;
+		atomic_inc(&stripe->pending_bios);
+		raid5_make_request(cache->mddev, bio);
+	}
+}
+
+static void r5c_put_stripe_dirty(struct r5c_cache *cache,
+					struct r5c_stripe *stripe)
+{
+	if (!atomic_dec_return(&stripe->dirty_stripes)) {
+		stripe->state = STRIPE_PARITY_DONE;
+		wake_up(r5c_stripe_waitq(cache, stripe));
+	}
+}
+
+static void r5c_flush_stripe(struct r5c_cache *cache, struct r5c_stripe *stripe)
+{
+	unsigned long *stripe_bits;
+	int chunk_stripes;
+	int start;
+	int end = 0;
+	int i;
+
+	chunk_stripes = cache->chunk_size >> PAGE_SECTOR_SHIFT;
+	stripe_bits = kzalloc(BITS_TO_LONGS(chunk_stripes) * sizeof(long),
+		GFP_NOIO);
+	for (i = 0; i < cache->stripe_data_pages; i++) {
+		if (stripe->data_pages[i])
+			__set_bit(i % chunk_stripes, stripe_bits);
+	}
+	atomic_set(&stripe->dirty_stripes, bitmap_weight(stripe_bits,
+				chunk_stripes) + 1);
+	kfree(stripe_bits);
+
+	while (end < cache->stripe_data_pages) {
+		while (end < cache->stripe_data_pages &&
+		       !stripe->data_pages[end])
+			end++;
+		if (end >= cache->stripe_data_pages)
+			break;
+		start = end;
+		while (end < cache->stripe_data_pages &&
+		       stripe->data_pages[end])
+			end++;
+		r5c_flush_one(cache, stripe, start, end - start);
+	}
+	r5c_put_stripe_dirty(cache, stripe);
+}
+
+/* Since r5c_freeze_stripe can sleep, this isn't multithread safe yet */
+static int r5c_select_front_stripes(struct r5c_cache *cache,
+	struct list_head *list, unsigned int count, bool blocking)
+{
+	struct r5c_stripe *stripe;
+	struct r5c_io_range *range;
+	int stripes = 0;
+
+	list_for_each_entry(range, &cache->log_list, log_sibling) {
+		stripe = range->stripe;
+		if (stripe->state >= STRIPE_FROZEN)
+			continue;
+
+		if (!r5c_freeze_stripe(cache, stripe, blocking))
+			continue;
+
+		list_move_tail(&stripe->lru, list);
+		stripes++;
+		if (stripes >= count)
+			break;
+	}
+	return stripes;
+}
+
+static int r5c_select_full_stripes(struct r5c_cache *cache,
+	struct list_head *list, unsigned int count, bool blocking)
+{
+	struct r5c_stripe *stripe, *tmp;
+	int stripes = 0;
+
+	list_for_each_entry_safe(stripe, tmp, &cache->full_stripes, lru) {
+		if (stripe->state >= STRIPE_FROZEN)
+			continue;
+		if (!r5c_freeze_stripe(cache, stripe, blocking))
+			continue;
+
+		list_move_tail(&stripe->lru, list);
+		stripes++;
+		cache->full_stripe_cnt--;
+		if (stripes >= count)
+			break;
+	}
+	if (list_empty(&cache->full_stripes))
+		clear_bit(RECLAIM_MEM_FULL, &cache->reclaim_reason);
+
+	return stripes;
+}
+
+static void r5c_select_stripes(struct r5c_cache *cache, struct list_head *list)
+{
+	int stripes;
+	bool blocking;
+
+	/*
+	 * generally select full stripe, if no disk space, select first stripe
+	 */
+	spin_lock_irq(&cache->tree_lock);
+	/* Don't need stripe lock, as nobody is operating on the stripe */
+	if (test_bit(RECLAIM_FLUSH_ALL, &cache->reclaim_reason)) {
+		r5c_select_front_stripes(cache, list, cache->reclaim_batch,
+				true);
+	} else if (test_bit(RECLAIM_DISK, &cache->reclaim_reason) ||
+	    test_bit(RECLAIM_DISK_BACKGROUND, &cache->reclaim_reason)) {
+		blocking = test_bit(RECLAIM_DISK, &cache->reclaim_reason);
+		r5c_select_front_stripes(cache, list, cache->reclaim_batch,
+				blocking);
+	} else if (test_bit(RECLAIM_MEM, &cache->reclaim_reason) ||
+	           test_bit(RECLAIM_MEM_BACKGROUND, &cache->reclaim_reason)) {
+		stripes = r5c_select_full_stripes(cache, list,
+				cache->reclaim_batch, false);
+		if (stripes < cache->reclaim_batch)
+			stripes += r5c_select_front_stripes(cache, list,
+				cache->reclaim_batch - stripes, false);
+		if (stripes < cache->reclaim_batch)
+			stripes += r5c_select_full_stripes(cache, list,
+				cache->reclaim_batch - stripes, true);
+		if (stripes < cache->reclaim_batch)
+			stripes += r5c_select_front_stripes(cache, list,
+				cache->reclaim_batch - stripes, true);
+	} else if (test_bit(RECLAIM_MEM_FULL, &cache->reclaim_reason)) {
+		r5c_select_full_stripes(cache, list, cache->reclaim_batch,
+				false);
+	}
+
+	spin_unlock_irq(&cache->tree_lock);
+}
+
+static void r5c_disks_flush_end(struct bio *bio, int err)
+{
+	struct completion *io_complete = bio->bi_private;
+
+	complete(io_complete);
+	bio_put(bio);
+}
+
+static void r5c_flush_all_disks(struct r5c_cache *cache)
+{
+	struct mddev *mddev = cache->mddev;
+	struct bio *bi;
+	DECLARE_COMPLETION_ONSTACK(io_complete);
+
+	bi = bio_alloc_mddev(GFP_NOIO, 0, mddev);
+	bi->bi_end_io = r5c_disks_flush_end;
+	bi->bi_private = &io_complete;
+
+	/* If bio hasn't payload, this function will just flush all disks */
+	md_flush_request(mddev, bi);
+
+	wait_for_completion_io(&io_complete);
+}
+
+static int r5c_stripe_list_cmp(void *priv, struct list_head *a,
+	struct list_head *b)
+{
+	struct r5c_stripe *stripe_a = container_of(a, struct r5c_stripe,
+		lru);
+	struct r5c_stripe *stripe_b = container_of(b, struct r5c_stripe,
+		lru);
+
+	return !(stripe_a->raid_index < stripe_b->raid_index);
+}
+
+static void r5c_reclaim_stripe_list(struct r5c_cache *cache,
+	struct list_head *stripe_list)
+{
+	struct r5c_stripe *stripe;
+	struct r5c_io_range *range;
+	u64 seq;
+	sector_t meta;
+	struct blk_plug plug;
+	size_t size = 0;
+
+	if (list_empty(stripe_list))
+		return;
+	list_sort(NULL, stripe_list, r5c_stripe_list_cmp);
+	list_for_each_entry(stripe, stripe_list, lru) {
+		cache->stripe_flush_data[size] =
+				cpu_to_le64(stripe->raid_index);
+		size++;
+	}
+	size *= sizeof(__le64);
+
+	blk_start_plug(&plug);
+	/* step 1: start write to raid */
+	list_for_each_entry(stripe, stripe_list, lru)
+		r5c_flush_stripe(cache, stripe);
+	blk_finish_plug(&plug);
+
+	/* step 2: wait parity write to cache */
+	list_for_each_entry_reverse(stripe, stripe_list, lru)
+		r5c_stripe_wait_state(cache, stripe, STRIPE_PARITY_DONE);
+
+	/* step 3: make sure data and parity settle down */
+	r5l_flush_block(&cache->log, R5LOG_TYPE_FLUSH_START,
+		cache->stripe_flush_data, size, &seq, &meta);
+
+	/* step 4: continue write to raid */
+	list_for_each_entry(stripe, stripe_list, lru) {
+		while (!list_empty(&stripe->stripes)) {
+			struct stripe_head *sh;
+
+			sh = list_first_entry(&stripe->stripes,
+				struct stripe_head, stripe_list);
+			list_del(&sh->stripe_list);
+			set_bit(STRIPE_HANDLE, &sh->state);
+			release_stripe(sh);
+		}
+	}
+
+	/* step 5: wait to make sure stripe data is in raid */
+	list_for_each_entry_reverse(stripe, stripe_list, lru)
+		r5c_stripe_wait_state(cache, stripe, STRIPE_INRAID);
+
+	/* step 6: flush raid disks */
+	r5c_flush_all_disks(cache);
+
+	/* step 7: mark data is flushed to raid */
+	r5l_flush_block(&cache->log, R5LOG_TYPE_FLUSH_END,
+		cache->stripe_flush_data, size, &seq, &meta);
+
+	/* step 8: mark stripe as dead */
+	while (!list_empty(stripe_list)) {
+		stripe = list_first_entry(stripe_list, struct r5c_stripe,
+			lru);
+		list_del_init(&stripe->lru);
+
+		stripe->state = STRIPE_DEAD;
+		wake_up(r5c_stripe_waitq(cache, stripe));
+
+		r5c_put_stripe(stripe);
+	}
+
+	/* step 9: advance superblock checkpoint */
+	spin_lock_irq(&cache->tree_lock);
+	/* if no data, superblock records the next position of checkpoint */
+	if (!list_empty(&cache->log_list)) {
+		range = list_first_entry(&cache->log_list,
+			struct r5c_io_range, log_sibling);
+		/* can't cross checkpoint */
+		if (range->seq < seq) {
+			seq = range->seq;
+			meta = range->meta_start;
+		}
+	}
+	spin_unlock_irq(&cache->tree_lock);
+
+	r5l_write_super(&cache->log, seq, meta);
+}
+
+static void r5c_reclaim_thread(struct md_thread *thread)
+{
+	struct mddev *mddev = thread->mddev;
+	struct r5conf *conf = mddev->private;
+	struct r5c_cache *cache = conf->cache;
+	LIST_HEAD(stripe_list);
+	bool retry;
+
+do_retry:
+	retry = false;
+
+	while (cache->reclaim_reason != 0) {
+		/*
+		 * select stripe will freeze stripe, which will guarantee no
+		 * new task pending in error mode
+		 * */
+		r5c_select_stripes(cache, &stripe_list);
+
+		if (list_empty(&stripe_list)) {
+			clear_bit(RECLAIM_MEM_FULL, &cache->reclaim_reason);
+			clear_bit(RECLAIM_MEM_BACKGROUND,
+					&cache->reclaim_reason);
+			clear_bit(RECLAIM_DISK_BACKGROUND,
+					&cache->reclaim_reason);
+			clear_bit(RECLAIM_FLUSH_ALL, &cache->reclaim_reason);
+		} else
+			r5c_reclaim_stripe_list(cache, &stripe_list);
+
+		wake_up(&cache->reclaim_wait);
+	}
+}
+
 static void r5c_wake_reclaimer(struct r5c_cache *cache, int reason)
 {
+	set_bit(reason, &cache->reclaim_reason);
+	md_wakeup_thread(cache->reclaim_thread);
 }
 
 static void r5c_wake_wait_reclaimer(struct r5c_cache *cache, int reason)
 {
+	r5c_wake_reclaimer(cache, reason);
+	wait_event(cache->reclaim_wait, !test_bit(reason,
+		&cache->reclaim_reason));
+}
+
+static void r5c_parity_task_end(struct r5l_task *task, int error)
+{
+	struct stripe_head *head_sh = task->private;
+	struct r5conf *conf = head_sh->raid_conf;
+	struct r5c_cache *cache = conf->cache;
+	struct r5c_stripe *stripe = head_sh->stripe;
+
+	/* parity IO error doesn't matter */
+	r5c_put_stripe_dirty(cache, stripe);
+	kfree(task);
+}
+
+/*
+ * we don't record parity range in cache->log_list, because after a success
+ * reclaim, parity always is discarded
+ */
+static void r5c_write_one_stripe_parity(struct r5c_cache *cache,
+	struct r5c_stripe *stripe, struct stripe_head *head_sh,
+	struct stripe_head *sh)
+{
+	u64 stripe_index;
+	int stripe_offset;
+
+	stripe_index = sh->sector;
+	stripe_offset = sector_div(stripe_index, cache->chunk_size);
+	stripe_offset >>= PAGE_SECTOR_SHIFT;
+
+	r5l_queue_parity(&cache->log, sh->sector,
+		sh->dev[sh->pd_idx].page,
+		sh->qd_idx >= 0 ? sh->dev[sh->qd_idx].page : NULL,
+		r5c_parity_task_end, head_sh);
+}
+
+int r5c_write_parity(struct r5c_cache *cache, struct stripe_head *head_sh)
+{
+	struct r5c_stripe *stripe;
+	struct stripe_head *sh;
+	u64 stripe_index;
+	int parity_cnt;
+	unsigned long flags;
+
+	/* parity is already written */
+	if (head_sh->stripe) {
+		head_sh->stripe = NULL;
+		return -EAGAIN;
+	}
+	if (!test_bit(R5_Wantwrite, &head_sh->dev[head_sh->pd_idx].flags) ||
+	     test_bit(STRIPE_SYNCING, &head_sh->state))
+		return -EAGAIN;
+
+	stripe_index = head_sh->sector;
+	sector_div(stripe_index, cache->chunk_size);
+
+	stripe = r5c_search_stripe(cache, stripe_index);
+	r5c_lock_stripe(cache, stripe, &flags);
+	list_add_tail(&head_sh->stripe_list, &stripe->stripes);
+	r5c_unlock_stripe(cache, stripe, &flags);
+	head_sh->stripe = stripe;
+
+	atomic_inc(&head_sh->count);
+
+	parity_cnt = !!(head_sh->pd_idx >= 0) + !!(head_sh->qd_idx >= 0);
+	BUG_ON(parity_cnt != cache->parity_disks);
+
+	sh = head_sh;
+	do {
+		r5c_write_one_stripe_parity(cache, stripe, head_sh, sh);
+		if (!head_sh->batch_head)
+			return 0;
+		sh = list_first_entry(&sh->batch_list, struct stripe_head,
+				      batch_list);
+	} while (sh != head_sh);
+	return 0;
 }
 
 static int r5l_load_log(struct r5l_log *log)
@@ -2153,6 +2632,12 @@ struct r5c_cache *r5c_init_cache(struct r5conf *conf, struct md_rdev *rdev)
 
 	r5c_calculate_watermark(cache);
 
+	cache->reclaim_thread = md_register_thread(r5c_reclaim_thread,
+		mddev, "reclaim");
+	if (!cache->reclaim_thread)
+		goto err_page;
+	cache->reclaim_thread->timeout = CHECKPOINT_TIMEOUT;
+
 	r5c_shrink_cache_memory(cache, cache->max_pages);
 
 	return cache;
@@ -2174,6 +2659,7 @@ struct r5c_cache *r5c_init_cache(struct r5conf *conf, struct md_rdev *rdev)
 
 void r5c_exit_cache(struct r5c_cache *cache)
 {
+	md_unregister_thread(&cache->reclaim_thread);
 	r5l_exit_log(&cache->log);
 
 	r5c_free_cache_data(cache);
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index ca164ad..a9e10ff 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -409,7 +409,7 @@ static int release_stripe_list(struct r5conf *conf,
 	return count;
 }
 
-static void release_stripe(struct stripe_head *sh)
+void release_stripe(struct stripe_head *sh)
 {
 	struct r5conf *conf = sh->raid_conf;
 	unsigned long flags;
@@ -887,6 +887,11 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 
 	might_sleep();
 
+	if (conf->cache) {
+		if (!r5c_write_parity(conf->cache, sh))
+			return;
+	}
+
 	for (i = disks; i--; ) {
 		int rw;
 		int replace_only = 0;
@@ -3097,7 +3102,7 @@ handle_failed_stripe(struct r5conf *conf, struct stripe_head *sh,
 			struct bio *nextbi = r5_next_bio(bi, sh->dev[i].sector);
 			clear_bit(BIO_UPTODATE, &bi->bi_flags);
 			if (!raid5_dec_bi_active_stripes(bi)) {
-				md_write_end(conf->mddev);
+				r5c_write_end(conf->mddev, bi);
 				bi->bi_next = *return_bi;
 				*return_bi = bi;
 			}
@@ -3121,7 +3126,7 @@ handle_failed_stripe(struct r5conf *conf, struct stripe_head *sh,
 			struct bio *bi2 = r5_next_bio(bi, sh->dev[i].sector);
 			clear_bit(BIO_UPTODATE, &bi->bi_flags);
 			if (!raid5_dec_bi_active_stripes(bi)) {
-				md_write_end(conf->mddev);
+				r5c_write_end(conf->mddev, bi);
 				bi->bi_next = *return_bi;
 				*return_bi = bi;
 			}
@@ -3460,7 +3465,7 @@ static void handle_stripe_clean_event(struct r5conf *conf,
 					dev->sector + STRIPE_SECTORS) {
 					wbi2 = r5_next_bio(wbi, dev->sector);
 					if (!raid5_dec_bi_active_stripes(wbi)) {
-						md_write_end(conf->mddev);
+						r5c_write_end(conf->mddev, wbi);
 						wbi->bi_next = *return_bi;
 						*return_bi = wbi;
 					}
@@ -5127,7 +5132,7 @@ static void make_discard_request(struct mddev *mddev, struct bio *bi)
 
 	remaining = raid5_dec_bi_active_stripes(bi);
 	if (remaining == 0) {
-		md_write_end(mddev);
+		r5c_write_end(mddev, bi);
 		bio_endio(bi, 0);
 	}
 }
@@ -5149,7 +5154,7 @@ void raid5_make_request(struct mddev *mddev, struct bio * bi)
 		return;
 	}
 
-	md_write_start(mddev, bi);
+	r5c_write_start(mddev, bi);
 
 	/*
 	 * If array is degraded, better not do chunk aligned read because
@@ -5285,8 +5290,9 @@ void raid5_make_request(struct mddev *mddev, struct bio * bi)
 			}
 			set_bit(STRIPE_HANDLE, &sh->state);
 			clear_bit(STRIPE_DELAYED, &sh->state);
+			/* there's no point to delay stripe with cache */
 			if ((!sh->batch_head || sh == sh->batch_head) &&
-			    (bi->bi_rw & REQ_SYNC) &&
+			    ((bi->bi_rw & REQ_SYNC) || conf->cache) &&
 			    !test_and_set_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
 				atomic_inc(&conf->preread_active_stripes);
 			release_stripe_plug(mddev, sh);
@@ -5302,7 +5308,7 @@ void raid5_make_request(struct mddev *mddev, struct bio * bi)
 	if (remaining == 0) {
 
 		if ( rw == WRITE )
-			md_write_end(mddev);
+			r5c_write_end(mddev, bi);
 
 		trace_block_bio_complete(mddev->queue, bi, 0);
 		bio_endio(bi, 0);
@@ -5703,6 +5709,7 @@ static int  retry_aligned_read(struct r5conf *conf, struct bio *raid_bio)
 		}
 
 		set_bit(R5_ReadNoMerge, &sh->dev[dd_idx].flags);
+		/* IO read should not trigger r5c IO */
 		handle_stripe(sh);
 		release_stripe(sh);
 		handled++;
@@ -5751,6 +5758,8 @@ static int handle_active_stripes(struct r5conf *conf, int group,
 	for (i = 0; i < batch_size; i++)
 		handle_stripe(batch[i]);
 
+	r5c_flush_pending_parity(conf->cache);
+
 	cond_resched();
 
 	spin_lock_irq(&conf->device_lock);
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 14761c9..16bd54f 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -223,6 +223,8 @@ struct stripe_head {
 	struct stripe_head	*batch_head; /* protected by stripe lock */
 	spinlock_t		batch_lock; /* only header's lock is useful */
 	struct list_head	batch_list; /* protected by head's batch lock*/
+	struct r5c_stripe	*stripe;
+	struct list_head	stripe_list;
 	/**
 	 * struct stripe_operations
 	 * @target - STRIPE_OP_COMPUTE_BLK target
@@ -606,8 +608,13 @@ static inline int algorithm_is_DDF(int layout)
 extern void md_raid5_kick_device(struct r5conf *conf);
 extern int raid5_set_cache_size(struct mddev *mddev, int size);
 
+void release_stripe(struct stripe_head *sh);
+int r5c_write_parity(struct r5c_cache *cache, struct stripe_head *sh);
+void r5c_flush_pending_parity(struct r5c_cache *cache);
 void raid5_make_request(struct mddev *mddev, struct bio *bi);
 void r5c_handle_bio(struct r5c_cache *cache, struct bio *bi);
 struct r5c_cache *r5c_init_cache(struct r5conf *conf, struct md_rdev *rdev);
 void r5c_exit_cache(struct r5c_cache *cache);
+void r5c_write_start(struct mddev *mddev, struct bio *bi);
+void r5c_write_end(struct mddev *mddev, struct bio *bi);
 #endif
-- 
1.8.1

