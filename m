From: Shaohua Li <shli@fb.com>
Subject: [PATCH v3 8/8] raid5: multi-thread support for raid5 caching reclaim
Date: Wed, 3 Jun 2015 15:48:43 -0700
Message-ID: <12e529dbd3cc58bc37c8febda0a33dfe985c7dd3.1433356864.git.shli@fb.com>
References: <cover.1433356864.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cover.1433356864.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com, neilb@suse.de
List-Id: linux-raid.ids

There are several stalled stages in raid5 caching reclaim, which can
significantly harm reclaim performance. To mitigate the performance
issue, we introduce multi-thread support for reclaim. Since each thread
records reclaimed stripes in flush start/end block, it's safe for
multi-thread.

Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/raid5-cache.c | 343 +++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 288 insertions(+), 55 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 86e7b94..329aa38 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -224,6 +224,8 @@ enum {
 };
 
 #define STRIPE_LOCK_BITS 8
+
+#define MAX_RECLAIM_WORKERS 16
 struct r5c_cache {
 	struct mddev *mddev;
 	struct md_rdev *rdev;
@@ -258,9 +260,11 @@ struct r5c_cache {
 	unsigned long reclaim_reason;
 	wait_queue_head_t reclaim_wait;
 	struct md_thread *reclaim_thread;
-	__le64 *stripe_flush_data;
 	int quiesce_state;
 
+	struct md_thread *reclaim_workers[MAX_RECLAIM_WORKERS];
+	int reclaim_worker_cnt;
+
 	int in_recovery;
 
 	struct work_struct pending_io_work;
@@ -294,9 +298,8 @@ enum {
 	RECLAIM_DISK_BACKGROUND = 9, /* try to reclaim disk */
 	RECLAIM_FLUSH_ALL = 16, /* flush all data to raid */
 
-	QUIESCE_NONE = 0,
+	QUIESCE_END = 0,
 	QUIESCE_START = 1,
-	QUIESCE_END = 2,
 
 	ERROR_NOERROR = 0,
 	ERROR_PREPARE = 1, /* Had an error, flushing cache to raid */
@@ -1958,7 +1961,9 @@ static void r5c_select_stripes(struct r5c_cache *cache, struct list_head *list)
 {
 	int stripes;
 	bool blocking;
+	static DEFINE_MUTEX(lock);
 
+	mutex_lock(&lock);
 	/*
 	 * generally select full stripe, if no disk space, select first stripe
 	 */
@@ -1991,6 +1996,7 @@ static void r5c_select_stripes(struct r5c_cache *cache, struct list_head *list)
 	}
 
 	spin_unlock_irq(&cache->tree_lock);
+	mutex_unlock(&lock);
 }
 
 static void r5c_disks_flush_end(struct bio *bio, int err)
@@ -2028,11 +2034,44 @@ static int r5c_stripe_list_cmp(void *priv, struct list_head *a,
 	return !(stripe_a->raid_index < stripe_b->raid_index);
 }
 
-static void r5c_reclaim_stripe_list(struct r5c_cache *cache,
-	struct list_head *stripe_list)
+struct r5c_reclaim_context {
+	struct list_head stripe_list;
+	__le64 *stripe_flush_data;
+	u64 seq;
+	sector_t meta;
+	struct completion comp;
+};
+
+static struct r5c_reclaim_context *
+r5c_alloc_reclaim_context(struct r5c_cache *cache)
+{
+	struct r5c_reclaim_context *context;
+
+	context = kzalloc(sizeof(*context), GFP_KERNEL);
+	if (!context)
+		return NULL;
+	INIT_LIST_HEAD(&context->stripe_list);
+	context->stripe_flush_data = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	if (!context->stripe_flush_data) {
+		kfree(context);
+		return NULL;
+	}
+	init_completion(&context->comp);
+	return context;
+}
+
+static void r5c_free_reclaim_context(struct r5c_reclaim_context *context)
+{
+	kfree(context->stripe_flush_data);
+	kfree(context);
+}
+
+static void r5c_do_reclaim(struct r5c_cache *cache,
+	struct r5c_reclaim_context *context)
 {
+	struct list_head *stripe_list = &context->stripe_list;
+	__le64 *stripe_flush_data = context->stripe_flush_data;
 	struct r5c_stripe *stripe;
-	struct r5c_io_range *range;
 	u64 seq;
 	sector_t meta;
 	size_t size = 0;
@@ -2045,7 +2084,7 @@ static void r5c_reclaim_stripe_list(struct r5c_cache *cache,
 
 	list_sort(NULL, stripe_list, r5c_stripe_list_cmp);
 	list_for_each_entry(stripe, stripe_list, lru) {
-		cache->stripe_flush_data[size] =
+		stripe_flush_data[size] =
 				cpu_to_le64(stripe->raid_index);
 		size++;
 	}
@@ -2063,7 +2102,7 @@ static void r5c_reclaim_stripe_list(struct r5c_cache *cache,
 
 	/* step 3: make sure data and parity settle down */
 	r5l_flush_block(&cache->log, R5LOG_TYPE_FLUSH_START,
-		cache->stripe_flush_data, size, &seq, &meta);
+		stripe_flush_data, size, &seq, &meta);
 
 	/* step 4: continue write to raid */
 	list_for_each_entry(stripe, stripe_list, lru) {
@@ -2087,7 +2126,7 @@ static void r5c_reclaim_stripe_list(struct r5c_cache *cache,
 
 	/* step 7: mark data is flushed to raid */
 	r5l_flush_block(&cache->log, R5LOG_TYPE_FLUSH_END,
-		cache->stripe_flush_data, size, &seq, &meta);
+		stripe_flush_data, size, &seq, &meta);
 
 	/* step 8: mark stripe as dead */
 	while (!list_empty(stripe_list)) {
@@ -2100,6 +2139,23 @@ static void r5c_reclaim_stripe_list(struct r5c_cache *cache,
 
 		r5c_put_stripe(stripe);
 	}
+	context->seq = seq;
+	context->meta = meta;
+}
+
+static void r5c_do_reclaim_and_write_super(struct r5c_cache *cache,
+	struct r5c_reclaim_context *context)
+{
+	struct r5c_io_range *range;
+	u64 seq;
+	sector_t meta;
+
+	if (list_empty(&context->stripe_list))
+		return;
+
+	r5c_do_reclaim(cache, context);
+	seq = context->seq;
+	meta = context->meta;
 
 	/* step 9: advance superblock checkpoint */
 	spin_lock_irq(&cache->tree_lock);
@@ -2118,14 +2174,67 @@ static void r5c_reclaim_stripe_list(struct r5c_cache *cache,
 	r5l_write_super(&cache->log, seq, meta);
 }
 
+static void r5c_reclaim_work(struct r5c_cache *cache,
+	struct r5c_reclaim_context *context)
+{
+	/*
+	 * select stripe will freeze stripe, which will guarantee no
+	 * new task pending in error mode
+	 * */
+	r5c_select_stripes(cache, &context->stripe_list);
+
+	r5c_do_reclaim(cache, context);
+}
+
+static void r5c_reclaim_stripe_list(struct r5c_cache *cache,
+	struct list_head *stripe_list)
+{
+	int size;
+	struct r5c_reclaim_context *context;
+
+	context = r5c_alloc_reclaim_context(cache);
+
+	while (!list_empty(stripe_list)) {
+		size = 0;
+		while (!list_empty(stripe_list) && size < RECLAIM_BATCH) {
+			list_move_tail(stripe_list->next,
+				&context->stripe_list);
+			size++;
+		}
+		if (!list_empty(stripe_list))
+			r5c_do_reclaim(cache, context);
+		else
+			r5c_do_reclaim_and_write_super(cache, context);
+	}
+
+	r5c_free_reclaim_context(context);
+}
+
+static void r5c_reclaim_thread_check_quiesce(struct r5c_cache *cache,
+	struct r5c_reclaim_context *context)
+{
+	if (cache->quiesce_state == QUIESCE_START) {
+		complete(&context->comp);
+		wait_event(cache->reclaim_wait, cache->quiesce_state ==
+			QUIESCE_END);
+		reinit_completion(&context->comp);
+	}
+}
+
 static void r5c_reclaim_thread(struct md_thread *thread)
 {
 	struct mddev *mddev = thread->mddev;
 	struct r5conf *conf = mddev->private;
 	struct r5c_cache *cache = conf->cache;
-	LIST_HEAD(stripe_list);
+	struct r5c_reclaim_context *context = thread->private;
 	bool retry;
 
+	r5c_reclaim_thread_check_quiesce(cache, context);
+
+	if (thread != cache->reclaim_thread) {
+		r5c_reclaim_work(cache, context);
+		return;
+	}
 do_retry:
 	retry = false;
 
@@ -2134,9 +2243,9 @@ static void r5c_reclaim_thread(struct md_thread *thread)
 		 * select stripe will freeze stripe, which will guarantee no
 		 * new task pending in error mode
 		 * */
-		r5c_select_stripes(cache, &stripe_list);
+		r5c_select_stripes(cache, &context->stripe_list);
 
-		if (list_empty(&stripe_list)) {
+		if (list_empty(&context->stripe_list)) {
 			clear_bit(RECLAIM_MEM_FULL, &cache->reclaim_reason);
 			clear_bit(RECLAIM_MEM_BACKGROUND,
 					&cache->reclaim_reason);
@@ -2144,7 +2253,7 @@ static void r5c_reclaim_thread(struct md_thread *thread)
 					&cache->reclaim_reason);
 			clear_bit(RECLAIM_FLUSH_ALL, &cache->reclaim_reason);
 		} else
-			r5c_reclaim_stripe_list(cache, &stripe_list);
+			r5c_do_reclaim_and_write_super(cache, context);
 
 		wake_up(&cache->reclaim_wait);
 	}
@@ -2179,20 +2288,80 @@ static void r5c_reclaim_thread(struct md_thread *thread)
 		cache->error_state = 0;
 		mddev_resume(cache->mddev);
 	}
-	if (cache->quiesce_state == QUIESCE_START) {
-		/* user IO already finished, we just stop reclaim */
-		cache->reclaim_reason = 0;
-		cache->quiesce_state = QUIESCE_END;
-		wake_up(&cache->reclaim_wait);
-		wait_event(cache->reclaim_wait, cache->quiesce_state ==
-			QUIESCE_NONE);
+}
+
+static struct md_thread *r5c_init_reclaim_thread(struct r5c_cache *cache)
+{
+	struct r5c_reclaim_context *context;
+	struct md_thread *thread;
+
+	context = r5c_alloc_reclaim_context(cache);
+	if (!context)
+		return NULL;
+
+	thread = md_register_thread(r5c_reclaim_thread,
+			cache->mddev, "reclaim");
+	if (!thread) {
+		r5c_free_reclaim_context(context);
+		return NULL;
+	}
+	thread->private = context;
+
+	return thread;
+}
+
+static void r5c_exit_reclaim_thread(struct r5c_cache *cache,
+	struct md_thread **thread)
+{
+	struct r5c_reclaim_context *context;
+
+	context = (*thread)->private;
+	r5c_free_reclaim_context(context);
+
+	md_unregister_thread(thread);
+}
+
+static int r5c_init_reclaimers(struct r5c_cache *cache)
+{
+	struct md_thread *thread;
+
+	thread = r5c_init_reclaim_thread(cache);
+	if (!thread)
+		return -ENOMEM;
+	cache->reclaim_thread = thread;
+	cache->reclaim_thread->timeout = CHECKPOINT_TIMEOUT;
+	return 0;
+}
+
+static void r5c_exit_reclaimers(struct r5c_cache *cache)
+{
+	int i = cache->reclaim_worker_cnt;
+
+	while (i > 0) {
+		r5c_exit_reclaim_thread(cache, &cache->reclaim_workers[i - 1]);
+		i--;
 	}
+
+	r5c_exit_reclaim_thread(cache, &cache->reclaim_thread);
+}
+
+static void r5c_wakeup_reclaimer_threads(struct r5c_cache *cache)
+{
+	int i;
+
+	md_wakeup_thread(cache->reclaim_thread);
+
+	preempt_disable();
+	for (i = 0; i < cache->reclaim_worker_cnt; i++)
+		if (cache->reclaim_workers[i])
+			md_wakeup_thread(cache->reclaim_workers[i]);
+	preempt_enable();
 }
 
 static void r5c_wake_reclaimer(struct r5c_cache *cache, int reason)
 {
 	set_bit(reason, &cache->reclaim_reason);
-	md_wakeup_thread(cache->reclaim_thread);
+	r5c_wakeup_reclaimer_threads(cache);
 }
 
 static void r5c_wake_wait_reclaimer(struct r5c_cache *cache, int reason)
@@ -2205,17 +2374,25 @@ static void r5c_wake_wait_reclaimer(struct r5c_cache *cache, int reason)
 void r5c_quiesce(struct r5conf *conf, int state)
 {
 	struct r5c_cache *cache = conf->cache;
+	struct r5c_reclaim_context *context;
+	int i;
 
 	if (!cache || cache->error_state)
 		return;
 	if (state == 1) {
 		r5c_wake_wait_reclaimer(cache, RECLAIM_FLUSH_ALL);
+
 		cache->quiesce_state = QUIESCE_START;
-		md_wakeup_thread(cache->reclaim_thread);
-		wait_event(cache->reclaim_wait, cache->quiesce_state ==
-			QUIESCE_END);
+		r5c_wakeup_reclaimer_threads(cache);
+
+		for (i = 0; i < cache->reclaim_worker_cnt; i++) {
+			context = cache->reclaim_workers[i]->private;
+			wait_for_completion(&context->comp);
+		}
+		context = cache->reclaim_thread->private;
+		wait_for_completion(&context->comp);
 	} else if (state == 0) {
-		cache->quiesce_state = QUIESCE_NONE;
+		cache->quiesce_state = QUIESCE_END;
 		wake_up(&cache->reclaim_wait);
 	}
 }
@@ -2751,7 +2928,6 @@ static int r5c_recover_stripes(struct r5c_load_ctx *ctx)
 {
 	struct r5c_cache *cache = ctx->cache;
 	LIST_HEAD(list);
-	int i;
 
 	r5l_check_stripes_checksum(ctx);
 
@@ -2762,18 +2938,7 @@ static int r5c_recover_stripes(struct r5c_load_ctx *ctx)
 
 	cache->in_recovery = 1;
 
-	while (!list_empty(&ctx->stripes_with_parity)) {
-		i = 0;
-		/* Can't handle large stripe list */
-		while (i < RECLAIM_BATCH &&
-		       !list_empty(&ctx->stripes_with_parity)) {
-			list_move_tail(ctx->stripes_with_parity.next,
-				&list);
-			i++;
-		}
-		r5c_reclaim_stripe_list(cache, &list);
-		BUG_ON(!list_empty(&list));
-	}
+	r5c_reclaim_stripe_list(cache, &ctx->stripes_with_parity);
 
 	cache->in_recovery = 0;
 	return 0;
@@ -3181,16 +3346,20 @@ int r5c_min_stripe_cache_size(struct r5c_cache *cache)
 {
 	struct r5conf *conf = cache->mddev->private;
 	return (conf->chunk_sectors >> PAGE_SECTOR_SHIFT) *
-		cache->reclaim_batch;
+		cache->reclaim_batch * (1 + cache->reclaim_worker_cnt);
 }
 
-static void r5c_set_reclaim_batch(struct r5c_cache *cache, int batch)
+static void r5c_set_reclaim_batch(struct r5c_cache *cache, int batch,
+	int threads)
 {
 	struct mddev *mddev = cache->mddev;
 	struct r5conf *conf = mddev->private;
 	int size;
 
-	size = (cache->stripe_parity_pages << PAGE_SECTOR_SHIFT) * batch;
+	threads++;
+
+	size = (cache->stripe_parity_pages << PAGE_SECTOR_SHIFT) * batch *
+		threads;
 	if (size > cache->reserved_space) {
 		cache->reserved_space = size;
 		mutex_lock(&cache->log.io_mutex);
@@ -3207,7 +3376,7 @@ static void r5c_set_reclaim_batch(struct r5c_cache *cache, int batch)
 		cache->reserved_space = size;
 	}
 
-	size = (conf->chunk_sectors >> PAGE_SECTOR_SHIFT) * batch;
+	size = (conf->chunk_sectors >> PAGE_SECTOR_SHIFT) * batch * threads;
 
 	mddev_lock(mddev);
 	if (size > conf->max_nr_stripes)
@@ -3241,7 +3410,7 @@ static ssize_t r5c_store_cache_reclaim_batch(struct mddev *mddev,
 		new = r5l_max_flush_stripes(&cache->log);
 
 	if (new != cache->reclaim_batch)
-		r5c_set_reclaim_batch(cache, new);
+		r5c_set_reclaim_batch(cache, new, cache->reclaim_worker_cnt);
 	return len;
 }
 
@@ -3337,6 +3506,68 @@ static struct md_sysfs_entry r5c_cache_memory_watermark =
 	__ATTR(cache_memory_watermark, S_IRUGO | S_IWUSR,
 	r5c_show_cache_memory_watermark, r5c_store_cache_memory_watermark);
 
+static ssize_t r5c_show_reclaim_threads(struct mddev *mddev, char *page)
+{
+	struct r5conf *conf = mddev->private;
+	struct r5c_cache *cache = conf->cache;
+
+	return sprintf(page, "%d\n", cache->reclaim_worker_cnt);
+}
+
+static void r5c_set_reclaim_thread_count(struct r5c_cache *cache, int cnt)
+{
+	struct md_thread *thread;
+	int old_cnt;
+
+	if (cache->reclaim_worker_cnt == cnt)
+		return;
+	if (cnt > MAX_RECLAIM_WORKERS)
+		cnt = MAX_RECLAIM_WORKERS;
+
+	old_cnt = cache->reclaim_worker_cnt;
+	if (old_cnt > cnt) {
+		cache->reclaim_worker_cnt = cnt;
+		/* make sure r5c_wake_reclaimer() isn't using thread */
+		synchronize_sched();
+	}
+
+	while (old_cnt > cnt) {
+		r5c_exit_reclaim_thread(cache,
+			&cache->reclaim_workers[old_cnt - 1]);
+		old_cnt--;
+	}
+	while (old_cnt < cnt) {
+		thread = r5c_init_reclaim_thread(cache);
+		if (!thread)
+			break;
+		cache->reclaim_workers[old_cnt++] = thread;
+	}
+
+	r5c_set_reclaim_batch(cache, cache->reclaim_batch, old_cnt);
+
+	cache->reclaim_worker_cnt = old_cnt;
+}
+
+static ssize_t r5c_store_reclaim_threads(struct mddev *mddev,
+	const char *page, size_t len)
+{
+	struct r5conf *conf = mddev->private;
+	struct r5c_cache *cache = conf->cache;
+	unsigned int new;
+
+	if (len >= PAGE_SIZE)
+		return -EINVAL;
+	if (kstrtouint(page, 0, &new))
+		return -EINVAL;
+
+	r5c_set_reclaim_thread_count(cache, new);
+	return len;
+}
+
+static struct md_sysfs_entry r5c_cache_reclaim_threads =
+	__ATTR(cache_reclaim_threads, S_IRUGO | S_IWUSR,
+	r5c_show_reclaim_threads, r5c_store_reclaim_threads);
+
 static int r5c_init_sysfs(struct r5c_cache *cache)
 {
 	struct mddev *mddev = cache->mddev;
@@ -3363,7 +3594,16 @@ static int r5c_init_sysfs(struct r5c_cache *cache)
 				      &r5c_cache_memory_watermark.attr, NULL);
 	if (ret)
 		goto memory_watermark;
+
+	ret = sysfs_add_file_to_group(&mddev->kobj,
+				      &r5c_cache_reclaim_threads.attr, NULL);
+	if (ret)
+		goto reclaim_threads;
+
 	return 0;
+reclaim_threads:
+	sysfs_remove_file_from_group(&mddev->kobj,
+		&r5c_cache_memory_watermark.attr, NULL);
 memory_watermark:
 	sysfs_remove_file_from_group(&mddev->kobj,
 		&r5c_cache_stat.attr, NULL);
@@ -3392,6 +3632,8 @@ static void r5c_exit_sysfs(struct r5c_cache *cache)
 		&r5c_cache_stat.attr, NULL);
 	sysfs_remove_file_from_group(&mddev->kobj,
 		&r5c_cache_memory_watermark.attr, NULL);
+	sysfs_remove_file_from_group(&mddev->kobj,
+		&r5c_cache_reclaim_threads.attr, NULL);
 }
 
 static void r5c_free_cache_data(struct r5c_cache *cache)
@@ -3446,10 +3688,6 @@ struct r5c_cache *r5c_init_cache(struct r5conf *conf, struct md_rdev *rdev)
 	cache->stripe_parity_pages = (cache->stripe_size -
 		cache->stripe_data_size) >> PAGE_SECTOR_SHIFT;
 
-	cache->stripe_flush_data = kmalloc(PAGE_SIZE, GFP_KERNEL);
-	if (!cache->stripe_flush_data)
-		goto io_range_kc;
-
 	cache->io_range_kc = KMEM_CACHE(r5c_io_range, 0);
 	if (!cache->io_range_kc)
 		goto io_range_kc;
@@ -3497,18 +3735,15 @@ struct r5c_cache *r5c_init_cache(struct r5conf *conf, struct md_rdev *rdev)
 
 	r5c_calculate_watermark(cache);
 
-	cache->reclaim_thread = md_register_thread(r5c_reclaim_thread,
-		mddev, "reclaim");
-	if (!cache->reclaim_thread)
+	if (r5c_init_reclaimers(cache))
 		goto err_page;
-	cache->reclaim_thread->timeout = CHECKPOINT_TIMEOUT;
 
 	r5c_shrink_cache_memory(cache, cache->max_pages);
 	if (r5c_init_sysfs(cache))
 		goto err_sysfs;
 	return cache;
 err_sysfs:
-	md_unregister_thread(&cache->reclaim_thread);
+	r5c_exit_reclaimers(cache);
 err_page:
 	r5c_free_cache_data(cache);
 
@@ -3520,7 +3755,6 @@ struct r5c_cache *r5c_init_cache(struct r5conf *conf, struct md_rdev *rdev)
 stripe_kc:
 	kmem_cache_destroy(cache->io_range_kc);
 io_range_kc:
-	kfree(cache->stripe_flush_data);
 	kfree(cache);
 	return NULL;
 }
@@ -3528,7 +3762,7 @@ struct r5c_cache *r5c_init_cache(struct r5conf *conf, struct md_rdev *rdev)
 void r5c_exit_cache(struct r5c_cache *cache)
 {
 	r5c_exit_sysfs(cache);
-	md_unregister_thread(&cache->reclaim_thread);
+	r5c_exit_reclaimers(cache);
 	r5l_exit_log(&cache->log);
 
 	r5c_free_cache_data(cache);
@@ -3537,6 +3771,5 @@ void r5c_exit_cache(struct r5c_cache *cache)
 	kmem_cache_destroy(cache->stripe_kc);
 	kmem_cache_destroy(cache->io_range_kc);
 
-	kfree(cache->stripe_flush_data);
 	kfree(cache);
 }
-- 
1.8.1

