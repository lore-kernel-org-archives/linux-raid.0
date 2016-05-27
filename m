From: Song Liu <songliubraving@fb.com>
Subject: [RFC 4/5] r5cache: write part of r5cache
Date: Thu, 26 May 2016 22:29:42 -0700
Message-ID: <1464326983-3798454-5-git-send-email-songliubraving@fb.com>
References: <1464326983-3798454-1-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1464326983-3798454-1-git-send-email-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@fb.com, nfbrown@novell.com, dan.j.williams@intel.com, hch@infradead.org, kernel-team@fb.com, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

This is the write part of r5cache. The cache is integrated with
stripe cache of raid456. It leverages code of r5l_log to write
data to journal device.

r5cache split current write path into 2 parts: the write path
and the reclaim path. The write path is as following:
1. write data to journal
2. call bio_endio

Then the reclaim path is as:
1. Freeze the stripe (no more writes coming in)
2. Calcualte parity (reconstruct or RMW)
3. Write parity to journal device (data is already written to it)
4. Write data and parity to RAID disks

With r5cache, write operation does not wait for parity calculation
and write out, so the write latency is lower (1 write to journal
device vs. read and then write to raid disks). Also, r5cache will
reduce RAID overhead (multipile IO due to read-modify-write of
parity) and provide more opportunities of full stripe writes.

r5cache adds a new state of each stripe: enum r5c_states. The write
path runs in state CLEAN and RUNNING (data in cache). Cache writes
start from r5c_handle_stripe_dirtying(), where bit R5_Wantcache is
set for devices with bio in towrite. Then, the data is written to
the journal through r5l_log implementation. Once the data is in the
journal, we set bit R5_InCache, and presue bio_endio for these
writes.

The reclaim path starts by freezing the stripe (no more writes).
This stripes back to raid5 state machine, where
handle_stripe_dirtying will evaluate the stripe for reconstruct
writes or RMW writes (read data and calculate parity).

For RMW, the code allocates extra page for prexor. Specifically,
a new page is allocated for r5dev->page to do prexor; while
r5dev->orig_page keeps the cached data. The extra page is freed
after prexor.

r5cache naturally excludes SkipCopy. With R5_Wantcache bit set,
async_copy_data will not skip copy.

Before writing data to RAID disks, the r5l_log logic stores
parity (and non-overwrite data) to the journal.

Instead of inactive_list, stripes with cached data are tracked in
r5conf->r5c_cached_list. r5conf->r5c_cached_stripes tracks how
many stripes has dirty data in the cache.

Two sysfs entries are provided for the write cache:
1. r5c_cached_stripes shows how many stripes have cached data.
   Writing anything to r5c_cached_stripes will flush all data
   to RAID disks.
2. r5c_cache_mode provides knob to switch the system between
   write-back or write-through (only write-log).

There are some known limitations of the cache implementation:

1. Write cache only covers full page writes (R5_OVERWRITE). Writes
   of smaller granularity are write through.
2. Only one log io (sh->log_io) for each stripe at anytime. Later
   writes for the same stripe have to wait. This can be improved by
   moving log_io to r5dev.

Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/raid5-cache.c | 399 +++++++++++++++++++++++++++++++++++++++++++++--
 drivers/md/raid5.c       | 172 +++++++++++++++++---
 drivers/md/raid5.h       |  38 ++++-
 3 files changed, 577 insertions(+), 32 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 5f0d96f..66a3cd5 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -40,7 +40,19 @@
  */
 #define R5L_POOL_SIZE	4
 
+enum r5c_cache_mode {
+	R5C_MODE_NO_CACHE = 0,
+	R5C_MODE_WRITE_THROUGH = 1,
+	R5C_MODE_WRITE_BACK = 2,
+};
+
+static char *r5c_cache_mode_str[] = {"no-cache", "write-through", "write-back"};
+
 struct r5c_cache {
+	int flush_threshold;		/* flush the stripe when flush_threshold buffers are dirty  */
+	int mode;			/* enum r5c_cache_mode */
+
+	/* read stats */
 	atomic64_t read_full_hits;	/* the whole chunk in cache */
 	atomic64_t read_partial_hits;	/* some pages of the chunk in cache */
 	atomic64_t read_misses;		/* the whold chunk is not in cache */
@@ -151,11 +163,23 @@ struct r5c_chunk_map {
 
 static void init_r5c_cache(struct r5conf *conf, struct r5c_cache *cache)
 {
+	cache->flush_threshold = conf->raid_disks - conf->max_degraded;  /* full stripe */
+	cache->mode = R5C_MODE_WRITE_BACK;
+
 	atomic64_set(&cache->read_full_hits, 0);
 	atomic64_set(&cache->read_partial_hits, 0);
 	atomic64_set(&cache->read_misses, 0);
 }
 
+void r5c_set_state(struct stripe_head *sh, enum r5c_states new_state)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&sh->stripe_lock, flags);
+	sh->r5c_state = new_state;
+	spin_unlock_irqrestore(&sh->stripe_lock, flags);
+}
+
 static sector_t r5l_ring_add(struct r5l_log *log, sector_t start, sector_t inc)
 {
 	start += inc;
@@ -191,12 +215,74 @@ static void __r5l_set_io_unit_state(struct r5l_io_unit *io,
 	io->state = state;
 }
 
+void r5c_freeze_stripe_for_reclaim(struct stripe_head *sh)
+{
+	struct r5conf *conf = sh->raid_conf;
+
+	if (!conf->log)
+		return;
+
+	WARN_ON(sh->r5c_state >= R5C_STATE_FROZEN);
+	r5c_set_state(sh, R5C_STATE_FROZEN);
+	if (!test_and_set_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
+		atomic_inc(&conf->preread_active_stripes);
+	if (test_and_clear_bit(STRIPE_IN_R5C_CACHE, &sh->state)) {
+		BUG_ON(atomic_read(&conf->r5c_cached_stripes) == 0);
+		atomic_dec(&conf->r5c_cached_stripes);
+	}
+}
+
+static void r5c_handle_data_cached(struct stripe_head *sh)
+{
+	int i;
+
+	for (i = sh->disks; i--; )
+		if (test_and_clear_bit(R5_Wantcache, &sh->dev[i].flags)) {
+			set_bit(R5_InCache, &sh->dev[i].flags);
+			clear_bit(R5_LOCKED, &sh->dev[i].flags);
+			atomic_inc(&sh->dev_in_cache);
+		}
+}
+
+/*
+ * this journal write must contain full parity,
+ * it may also contain data of none-overwrites
+ */
+static void r5c_handle_parity_cached(struct stripe_head *sh)
+{
+	int i;
+
+	for (i = sh->disks; i--; )
+		if (test_bit(R5_InCache, &sh->dev[i].flags))
+			set_bit(R5_Wantwrite, &sh->dev[i].flags);
+	r5c_set_state(sh, R5C_STATE_PARITY_DONE);
+}
+
+static void r5c_finish_cache_stripe(struct stripe_head *sh)
+{
+	switch (sh->r5c_state) {
+	case R5C_STATE_PARITY_RUN:
+		r5c_handle_parity_cached(sh);
+		break;
+	case R5C_STATE_CLEAN:
+		r5c_set_state(sh, R5C_STATE_RUNNING);
+	case R5C_STATE_RUNNING:
+		r5c_handle_data_cached(sh);
+		break;
+	default:
+		BUG();
+	}
+}
+
 static void r5l_io_run_stripes(struct r5l_io_unit *io)
 {
 	struct stripe_head *sh, *next;
 
 	list_for_each_entry_safe(sh, next, &io->stripe_list, log_list) {
 		list_del_init(&sh->log_list);
+
+		r5c_finish_cache_stripe(sh);
+
 		set_bit(STRIPE_HANDLE, &sh->state);
 		raid5_release_stripe(sh);
 	}
@@ -425,7 +511,10 @@ static int r5l_log_stripe(struct r5l_log *log, struct stripe_head *sh,
 	io = log->current_io;
 
 	for (i = 0; i < sh->disks; i++) {
-		if (!test_bit(R5_Wantwrite, &sh->dev[i].flags))
+		if (!test_bit(R5_Wantwrite, &sh->dev[i].flags) &&
+		    !test_bit(R5_Wantcache, &sh->dev[i].flags))
+			continue;
+		if (test_bit(R5_InCache, &sh->dev[i].flags))
 			continue;
 		if (i == sh->pd_idx || i == sh->qd_idx)
 			continue;
@@ -435,18 +524,19 @@ static int r5l_log_stripe(struct r5l_log *log, struct stripe_head *sh,
 		r5l_append_payload_page(log, sh->dev[i].page);
 	}
 
-	if (sh->qd_idx >= 0) {
+	if (parity_pages == 2) {
 		r5l_append_payload_meta(log, R5LOG_PAYLOAD_PARITY,
 					sh->sector, sh->dev[sh->pd_idx].log_checksum,
 					sh->dev[sh->qd_idx].log_checksum, true);
 		r5l_append_payload_page(log, sh->dev[sh->pd_idx].page);
 		r5l_append_payload_page(log, sh->dev[sh->qd_idx].page);
-	} else {
+	} else if (parity_pages == 1) {
 		r5l_append_payload_meta(log, R5LOG_PAYLOAD_PARITY,
 					sh->sector, sh->dev[sh->pd_idx].log_checksum,
 					0, false);
 		r5l_append_payload_page(log, sh->dev[sh->pd_idx].page);
-	}
+	} else
+		BUG_ON(parity_pages != 0);
 
 	list_add_tail(&sh->log_list, &io->stripe_list);
 	atomic_inc(&io->pending_stripe);
@@ -455,7 +545,6 @@ static int r5l_log_stripe(struct r5l_log *log, struct stripe_head *sh,
 	return 0;
 }
 
-static void r5l_wake_reclaim(struct r5l_log *log, sector_t space);
 /*
  * running in raid5d, where reclaim could wait for raid5d too (when it flushes
  * data from log to raid disks), so we shouldn't wait for reclaim here
@@ -471,6 +560,7 @@ int r5l_write_stripe(struct r5l_log *log, struct stripe_head *sh)
 
 	if (!log)
 		return -EAGAIN;
+
 	/* Don't support stripe batch */
 	if (sh->log_io || !test_bit(R5_Wantwrite, &sh->dev[sh->pd_idx].flags) ||
 	    test_bit(STRIPE_SYNCING, &sh->state)) {
@@ -479,11 +569,17 @@ int r5l_write_stripe(struct r5l_log *log, struct stripe_head *sh)
 		return -EAGAIN;
 	}
 
+	WARN_ON(sh->r5c_state < R5C_STATE_FROZEN);
+
 	for (i = 0; i < sh->disks; i++) {
 		void *addr;
 
 		if (!test_bit(R5_Wantwrite, &sh->dev[i].flags))
 			continue;
+
+		if (test_bit(R5_InCache, &sh->dev[i].flags))
+			continue;
+
 		write_disks++;
 		/* checksum is already calculated in last run */
 		if (test_bit(STRIPE_LOG_TRAPPED, &sh->state))
@@ -496,6 +592,9 @@ int r5l_write_stripe(struct r5l_log *log, struct stripe_head *sh)
 	parity_pages = 1 + !!(sh->qd_idx >= 0);
 	data_pages = write_disks - parity_pages;
 
+	pr_debug("%s: write %d data_pages and %d parity_pages\n",
+		 __func__, data_pages, parity_pages);
+
 	meta_size =
 		((sizeof(struct r5l_payload_data_parity) + sizeof(__le32))
 		 * data_pages) +
@@ -766,7 +865,6 @@ static void r5l_write_super_and_discard_space(struct r5l_log *log,
 	}
 }
 
-
 static void r5l_do_reclaim(struct r5l_log *log)
 {
 	sector_t reclaim_target = xchg(&log->reclaim_target, 0);
@@ -826,10 +924,15 @@ static void r5l_reclaim_thread(struct md_thread *thread)
 
 	if (!log)
 		return;
+/*
+	spin_lock_irq(&conf->device_lock);
+	r5c_do_reclaim(conf);
+	spin_unlock_irq(&conf->device_lock);
+*/
 	r5l_do_reclaim(log);
 }
 
-static void r5l_wake_reclaim(struct r5l_log *log, sector_t space)
+void r5l_wake_reclaim(struct r5l_log *log, sector_t space)
 {
 	unsigned long target;
 	unsigned long new = (unsigned long)space; /* overflow in theory */
@@ -1274,8 +1377,7 @@ struct bio *r5c_lookup_chunk(struct r5l_log *log, struct bio *raid_bio)
 		hash = stripe_hash_locks_hash(first_stripe + sh_idx * STRIPE_SECTORS);
 		spin_lock_irqsave(conf->hash_locks + hash, flags);
 		sh = __find_stripe(conf, first_stripe + sh_idx * STRIPE_SECTORS, conf->generation);
-		if (sh &&
-		    test_bit(R5_UPTODATE, &sh->dev[dd_idx].flags)) {
+		if (sh && test_bit(R5_UPTODATE, &sh->dev[dd_idx].flags)) {
 			if (!atomic_inc_not_zero(&sh->count)) {
 				spin_lock(&conf->device_lock);
 				if (!atomic_read(&sh->count)) {
@@ -1356,6 +1458,285 @@ r5c_stat_show(struct mddev *mddev, char* page)
 	return ret;
 }
 
+static void r5c_flush_stripe(struct r5conf *conf, struct stripe_head *sh)
+{
+	list_del_init(&sh->lru);
+	r5c_freeze_stripe_for_reclaim(sh);
+	atomic_inc(&conf->active_stripes);
+	atomic_inc(&sh->count);
+	set_bit(STRIPE_HANDLE, &sh->state);
+	raid5_release_stripe(sh);
+}
+
+int r5c_flush_cache(struct r5conf *conf)
+{
+	int count = 0;
+
+	if (!conf->log)
+		return 0;
+	while(!list_empty(&conf->r5c_cached_list)) {
+		struct list_head *l = conf->r5c_cached_list.next;
+		struct stripe_head *sh;
+		sh = list_entry(l, struct stripe_head, lru);
+		r5c_flush_stripe(conf, sh);
+		++count;
+	}
+	return count;
+}
+
+ssize_t
+r5c_cached_stripes_show(struct mddev *mddev, char* page)
+{
+	struct r5conf *conf = mddev->private;
+	int ret = 0;
+
+	if (!conf)
+		return 0;
+
+	ret += snprintf(page + ret, PAGE_SIZE - ret, "r5c_cached_stripes: %llu\n",
+			(unsigned long long) atomic_read(&conf->r5c_cached_stripes));
+	return ret;
+}
+
+ssize_t r5l_show_need_cache_flush(struct mddev *mddev, char *page)
+{
+	struct r5conf *conf = mddev->private;
+	struct r5l_log *log = conf->log;
+	int ret = 0;
+	int val;
+
+	if (!log)
+		val = 0;
+	else
+		val = log->need_cache_flush;
+
+	ret += snprintf(page + ret, PAGE_SIZE - ret, "%d\n", val);
+	return ret;
+}
+
+ssize_t r5l_store_need_cache_flush(struct mddev *mddev, const char *page, size_t len)
+{
+	struct r5conf *conf = mddev->private;
+	struct r5l_log *log = conf->log;
+	int val;
+
+	if (!log)
+		return -EINVAL;
+
+	if (kstrtoint(page, 10, &val))
+		return -EINVAL;
+
+	if (val > 1 || val < 0)
+		return -EINVAL;
+
+	log->need_cache_flush = val;
+	return len;
+}
+
+ssize_t
+r5c_cached_stripes_store(struct mddev *mddev, const char *page, size_t len)
+{
+	struct r5conf *conf = mddev->private;
+
+	spin_lock_irq(&conf->device_lock);
+	r5c_flush_cache(conf);  /* flush cache regardless of any input, TODO: change this*/
+	spin_unlock_irq(&conf->device_lock);
+
+	md_wakeup_thread(mddev->thread);
+	return len;
+}
+
+ssize_t r5c_show_cache_mode(struct mddev *mddev, char *page)
+{
+	struct r5conf *conf = mddev->private;
+	int val = 0;
+	int ret = 0;
+
+	if (conf->log)
+		val = conf->log->cache.mode;
+	ret += snprintf(page, PAGE_SIZE - ret, "%d: %s\n", val, r5c_cache_mode_str[val]);
+	return ret;
+}
+
+ssize_t r5c_store_cache_mode(struct mddev *mddev, const char *page, size_t len)
+{
+	struct r5conf *conf = mddev->private;
+	int val;
+
+	if (!conf->log)
+		return -EINVAL;
+	if (kstrtoint(page, 10, &val))
+		return -EINVAL;
+	if (val < R5C_MODE_WRITE_THROUGH || val > R5C_MODE_WRITE_BACK)
+		return -EINVAL;
+	spin_lock_irq(&conf->device_lock);
+	conf->log->cache.mode = val;
+	spin_unlock_irq(&conf->device_lock);
+	printk(KERN_INFO "%s: setting r5c cache mode to %d: %s\n", mdname(mddev), val, r5c_cache_mode_str[val]);
+	return len;
+}
+
+int r5c_handle_stripe_dirtying(struct r5conf *conf,
+			       struct stripe_head *sh,
+			       struct stripe_head_state *s,
+			       int disks) {
+	struct r5l_log *log = conf->log;
+	int i;
+	struct r5dev *dev;
+
+	if (!log || sh->r5c_state >= R5C_STATE_FROZEN)
+		return -EAGAIN;
+
+	if (conf->log->cache.mode == R5C_MODE_WRITE_THROUGH || conf->quiesce != 0 || conf->mddev->degraded != 0) {
+		/* write through mode */
+		r5c_freeze_stripe_for_reclaim(sh);
+		return -EAGAIN;
+	}
+
+	s->to_cache = 0;
+
+	for (i = disks; i--; ) {
+		dev = &sh->dev[i];
+		/* if none-overwrite, use the reclaim path (write through) */
+		if (dev->towrite && !test_bit(R5_OVERWRITE, &dev->flags) &&
+		    !test_bit(R5_InCache, &dev->flags)) {
+			r5c_freeze_stripe_for_reclaim(sh);
+			return -EAGAIN;
+		}
+	}
+
+	for (i = disks; i--; ) {
+		dev = &sh->dev[i];
+		if (dev->towrite) {
+			set_bit(R5_Wantcache, &dev->flags);
+			set_bit(R5_Wantdrain, &dev->flags);
+			set_bit(R5_LOCKED, &dev->flags);
+			s->to_cache++;
+		}
+	}
+
+	if (s->to_cache)
+		set_bit(STRIPE_OP_BIODRAIN, &s->ops_request);
+
+	return 0;
+}
+
+void r5c_handle_stripe_flush(struct r5conf *conf,
+			     struct stripe_head *sh,
+			     struct stripe_head_state *s,
+			     int disks) {
+	int i;
+	int do_wakeup = 0;
+
+	if (sh->r5c_state == R5C_STATE_PARITY_DONE) {
+		r5c_set_state(sh, R5C_STATE_INRAID);
+		for (i = disks; i--; ) {
+			clear_bit(R5_InCache, &sh->dev[i].flags);
+			clear_bit(R5_UPTODATE, &sh->dev[i].flags);
+			if (test_and_clear_bit(R5_Overlap, &sh->dev[i].flags))
+				do_wakeup = 1;
+		}
+	}
+	if (do_wakeup)
+		wake_up(&conf->wait_for_overlap);
+}
+
+int
+r5c_cache_data(struct r5l_log *log, struct stripe_head *sh,
+	       struct stripe_head_state *s)
+{
+	int pages;
+	int meta_size;
+	int reserve;
+	int i;
+	int ret = 0;
+	int page_count = 0;
+
+	BUG_ON(!log);
+	BUG_ON(s->to_cache == 0);
+
+	for (i = 0; i < sh->disks; i++) {
+		void *addr;
+		if (!test_bit(R5_Wantcache, &sh->dev[i].flags))
+			continue;
+		addr = kmap_atomic(sh->dev[i].page);
+		sh->dev[i].log_checksum = crc32c_le(log->uuid_checksum,
+						    addr, PAGE_SIZE);
+		kunmap_atomic(addr);
+		page_count++;
+	}
+	WARN_ON(page_count != s->to_cache);
+
+	pages = s->to_cache;
+
+	meta_size =
+		((sizeof(struct r5l_payload_data_parity) + sizeof(__le32))
+		 * pages);
+	/* Doesn't work with very big raid array */
+	if (meta_size + sizeof(struct r5l_meta_block) > PAGE_SIZE)
+		return -EINVAL;
+
+	/*
+	 * The stripe must enter state machine again to call endio, so
+	 * don't delay.
+	 */
+	clear_bit(STRIPE_DELAYED, &sh->state);
+	atomic_inc(&sh->count);
+
+	mutex_lock(&log->io_mutex);
+	/* meta + data */
+	reserve = (1 + pages) << (PAGE_SHIFT - 9);
+	if (!r5l_has_free_space(log, reserve)) {
+		spin_lock(&log->no_space_stripes_lock);
+		list_add_tail(&sh->log_list, &log->no_space_stripes);
+		spin_unlock(&log->no_space_stripes_lock);
+
+		r5l_wake_reclaim(log, reserve);
+	} else {
+		ret = r5l_log_stripe(log, sh, pages, 0);
+		if (ret) {
+			spin_lock_irq(&log->io_list_lock);
+			list_add_tail(&sh->log_list, &log->no_mem_stripes);
+			spin_unlock_irq(&log->io_list_lock);
+		}
+	}
+
+	mutex_unlock(&log->io_mutex);
+	return 0;
+}
+
+static void r5c_adjust_flush_threshold(struct r5conf *conf)
+{
+	struct r5l_log *log = conf->log;
+	int new_thres = conf->raid_disks - conf->max_degraded;
+
+	if (atomic_read(&conf->r5c_cached_stripes) * 2 > conf->max_nr_stripes)
+		new_thres = 1;
+	else if (atomic_read(&conf->r5c_cached_stripes) * 4 > conf->max_nr_stripes)
+		new_thres /= 2;
+	else if (atomic_read(&conf->r5c_cached_stripes) * 8 > conf->max_nr_stripes)
+		new_thres -= 1;
+
+	if (new_thres >= 1)
+		log->cache.flush_threshold = new_thres;
+}
+
+void r5c_do_reclaim(struct r5conf *conf)
+{
+	struct stripe_head *sh, *next;
+	struct r5l_log *log = conf->log;
+
+	assert_spin_locked(&conf->device_lock);
+
+	if (!log)
+		return;
+
+	r5c_adjust_flush_threshold(conf);
+	list_for_each_entry_safe(sh, next, &conf->r5c_cached_list, lru)
+		if (atomic_read(&sh->dev_in_cache) >= log->cache.flush_threshold)
+			r5c_flush_stripe(conf, sh);
+}
+
 static int r5l_load_log(struct r5l_log *log)
 {
 	struct md_rdev *rdev = log->rdev;
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index cdd9c4b..127c5c2 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -261,8 +261,16 @@ static void do_release_stripe(struct r5conf *conf, struct stripe_head *sh,
 			    < IO_THRESHOLD)
 				md_wakeup_thread(conf->mddev->thread);
 		atomic_dec(&conf->active_stripes);
-		if (!test_bit(STRIPE_EXPANDING, &sh->state))
-			list_add_tail(&sh->lru, temp_inactive_list);
+		if (!test_bit(STRIPE_EXPANDING, &sh->state)) {
+			if (sh->r5c_state == R5C_STATE_CLEAN)
+				list_add_tail(&sh->lru, temp_inactive_list);
+			else {
+				if (!test_and_set_bit(STRIPE_IN_R5C_CACHE, &sh->state)) {
+					atomic_inc(&conf->r5c_cached_stripes);
+				}
+				list_add_tail(&sh->lru, &conf->r5c_cached_list);
+			}
+		}
 	}
 }
 
@@ -650,6 +658,7 @@ raid5_get_active_stripe(struct r5conf *conf, sector_t sector,
 				BUG_ON(list_empty(&sh->lru) &&
 				       !test_bit(STRIPE_EXPANDING, &sh->state));
 				list_del_init(&sh->lru);
+
 				if (sh->group) {
 					sh->group->stripes_cnt--;
 					sh->group = NULL;
@@ -834,6 +843,11 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 
 	might_sleep();
 
+	if (s->to_cache) {
+		r5c_cache_data(conf->log, sh, s);
+		return;
+	}
+
 	if (r5l_write_stripe(conf->log, sh) == 0)
 		return;
 	for (i = disks; i--; ) {
@@ -964,6 +978,7 @@ again:
 
 			if (test_bit(R5_SkipCopy, &sh->dev[i].flags))
 				WARN_ON(test_bit(R5_UPTODATE, &sh->dev[i].flags));
+
 			sh->dev[i].vec.bv_page = sh->dev[i].page;
 			bi->bi_vcnt = 1;
 			bi->bi_io_vec[0].bv_len = STRIPE_SIZE;
@@ -1051,7 +1066,7 @@ again:
 static struct dma_async_tx_descriptor *
 async_copy_data(int frombio, struct bio *bio, struct page **page,
 	sector_t sector, struct dma_async_tx_descriptor *tx,
-	struct stripe_head *sh)
+	struct stripe_head *sh, int no_skipcopy)
 {
 	struct bio_vec bvl;
 	struct bvec_iter iter;
@@ -1091,7 +1106,8 @@ async_copy_data(int frombio, struct bio *bio, struct page **page,
 			if (frombio) {
 				if (sh->raid_conf->skip_copy &&
 				    b_offset == 0 && page_offset == 0 &&
-				    clen == STRIPE_SIZE)
+				    clen == STRIPE_SIZE &&
+				    !no_skipcopy)
 					*page = bio_page;
 				else
 					tx = async_memcpy(*page, bio_page, page_offset,
@@ -1173,7 +1189,7 @@ static void ops_run_biofill(struct stripe_head *sh)
 			while (rbi && rbi->bi_iter.bi_sector <
 				dev->sector + STRIPE_SECTORS) {
 				tx = async_copy_data(0, rbi, &dev->page,
-					dev->sector, tx, sh);
+						     dev->sector, tx, sh, 0);
 				rbi = r5_next_bio(rbi, dev->sector);
 			}
 		}
@@ -1300,7 +1316,8 @@ static int set_syndrome_sources(struct page **srcs,
 		if (i == sh->qd_idx || i == sh->pd_idx ||
 		    (srctype == SYNDROME_SRC_ALL) ||
 		    (srctype == SYNDROME_SRC_WANT_DRAIN &&
-		     test_bit(R5_Wantdrain, &dev->flags)) ||
+		     (test_bit(R5_Wantdrain, &dev->flags) ||
+		      test_bit(R5_InCache, &dev->flags))) ||
 		    (srctype == SYNDROME_SRC_WRITTEN &&
 		     dev->written))
 			srcs[slot] = sh->dev[i].page;
@@ -1479,9 +1496,17 @@ ops_run_compute6_2(struct stripe_head *sh, struct raid5_percpu *percpu)
 static void ops_complete_prexor(void *stripe_head_ref)
 {
 	struct stripe_head *sh = stripe_head_ref;
+	int i;
 
 	pr_debug("%s: stripe %llu\n", __func__,
 		(unsigned long long)sh->sector);
+
+	for (i = sh->disks; i--; )
+		if (sh->dev[i].page != sh->dev[i].orig_page) {
+			struct page *p = sh->dev[i].page;
+			sh->dev[i].page = sh->dev[i].orig_page;
+			put_page(p);
+		}
 }
 
 static struct dma_async_tx_descriptor *
@@ -1503,7 +1528,7 @@ ops_run_prexor5(struct stripe_head *sh, struct raid5_percpu *percpu,
 	for (i = disks; i--; ) {
 		struct r5dev *dev = &sh->dev[i];
 		/* Only process blocks that are known to be uptodate */
-		if (test_bit(R5_Wantdrain, &dev->flags))
+		if (test_bit(R5_Wantdrain, &dev->flags) || test_bit(R5_InCache, &dev->flags))
 			xor_srcs[count++] = dev->page;
 	}
 
@@ -1554,6 +1579,10 @@ ops_run_biodrain(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
 
 again:
 			dev = &sh->dev[i];
+			if (test_and_clear_bit(R5_InCache, &dev->flags)) {
+				BUG_ON(atomic_read(&sh->dev_in_cache) == 0);
+				atomic_dec(&sh->dev_in_cache);
+			}
 			spin_lock_irq(&sh->stripe_lock);
 			chosen = dev->towrite;
 			dev->towrite = NULL;
@@ -1561,7 +1590,8 @@ again:
 			BUG_ON(dev->written);
 			wbi = dev->written = chosen;
 			spin_unlock_irq(&sh->stripe_lock);
-			WARN_ON(dev->page != dev->orig_page);
+			if (!test_bit(R5_Wantcache, &dev->flags))
+				WARN_ON(dev->page != dev->orig_page);
 
 			while (wbi && wbi->bi_iter.bi_sector <
 				dev->sector + STRIPE_SECTORS) {
@@ -1573,8 +1603,9 @@ again:
 					set_bit(R5_Discard, &dev->flags);
 				else {
 					tx = async_copy_data(1, wbi, &dev->page,
-						dev->sector, tx, sh);
-					if (dev->page != dev->orig_page) {
+							     dev->sector, tx, sh, test_bit(R5_Wantcache, &dev->flags));
+					if (dev->page != dev->orig_page &&
+					    !test_bit(R5_Wantcache, &dev->flags)) {
 						set_bit(R5_SkipCopy, &dev->flags);
 						clear_bit(R5_UPTODATE, &dev->flags);
 						clear_bit(R5_OVERWRITE, &dev->flags);
@@ -1682,7 +1713,7 @@ again:
 		xor_dest = xor_srcs[count++] = sh->dev[pd_idx].page;
 		for (i = disks; i--; ) {
 			struct r5dev *dev = &sh->dev[i];
-			if (head_sh->dev[i].written)
+			if (head_sh->dev[i].written || test_bit(R5_InCache, &head_sh->dev[i].flags))
 				xor_srcs[count++] = dev->page;
 		}
 	} else {
@@ -1935,6 +1966,7 @@ static struct stripe_head *alloc_stripe(struct kmem_cache *sc, gfp_t gfp)
 		INIT_LIST_HEAD(&sh->batch_list);
 		INIT_LIST_HEAD(&sh->lru);
 		atomic_set(&sh->count, 1);
+		atomic_set(&sh->dev_in_cache, 0);
 	}
 	return sh;
 }
@@ -2816,6 +2848,9 @@ schedule_reconstruction(struct stripe_head *sh, struct stripe_head_state *s,
 				if (!expand)
 					clear_bit(R5_UPTODATE, &dev->flags);
 				s->locked++;
+			} else if (test_bit(R5_InCache, &dev->flags)) {
+				set_bit(R5_LOCKED, &dev->flags);
+				s->locked++;
 			}
 		}
 		/* if we are not expanding this is a proper write request, and
@@ -2855,6 +2890,9 @@ schedule_reconstruction(struct stripe_head *sh, struct stripe_head_state *s,
 				set_bit(R5_LOCKED, &dev->flags);
 				clear_bit(R5_UPTODATE, &dev->flags);
 				s->locked++;
+			} else if (test_bit(R5_InCache, &dev->flags)) {
+				set_bit(R5_LOCKED, &dev->flags);
+				s->locked++;
 			}
 		}
 		if (!s->locked)
@@ -2913,6 +2951,8 @@ static int add_stripe_bio(struct stripe_head *sh, struct bio *bi, int dd_idx,
 	 */
 	spin_lock_irq(&sh->stripe_lock);
 	/* Don't allow new IO added to stripes in batch list */
+	if (sh->r5c_state >= R5C_STATE_FROZEN)
+		goto overlap;
 	if (sh->batch_head)
 		goto overlap;
 	if (forwrite) {
@@ -3502,6 +3542,9 @@ static void handle_stripe_dirtying(struct r5conf *conf,
 	int rmw = 0, rcw = 0, i;
 	sector_t recovery_cp = conf->mddev->recovery_cp;
 
+	if (r5c_handle_stripe_dirtying(conf, sh, s, disks) == 0)
+		return;
+
 	/* Check whether resync is now happening or should start.
 	 * If yes, then the array is dirty (after unclean shutdown or
 	 * initial creation), so parity in some stripes might be inconsistent.
@@ -3522,9 +3565,11 @@ static void handle_stripe_dirtying(struct r5conf *conf,
 	} else for (i = disks; i--; ) {
 		/* would I have to read this buffer for read_modify_write */
 		struct r5dev *dev = &sh->dev[i];
-		if ((dev->towrite || i == sh->pd_idx || i == sh->qd_idx) &&
+		if ((dev->towrite || i == sh->pd_idx || i == sh->qd_idx ||
+		     test_bit(R5_InCache, &dev->flags)) &&
 		    !test_bit(R5_LOCKED, &dev->flags) &&
-		    !(test_bit(R5_UPTODATE, &dev->flags) ||
+		    /* !(test_bit(R5_UPTODATE, &dev->flags) || */
+		    !((test_bit(R5_UPTODATE, &dev->flags) && (!test_bit(R5_InCache, &dev->flags) || (dev->page != dev->orig_page))) ||
 		      test_bit(R5_Wantcompute, &dev->flags))) {
 			if (test_bit(R5_Insync, &dev->flags))
 				rmw++;
@@ -3536,13 +3581,15 @@ static void handle_stripe_dirtying(struct r5conf *conf,
 		    i != sh->pd_idx && i != sh->qd_idx &&
 		    !test_bit(R5_LOCKED, &dev->flags) &&
 		    !(test_bit(R5_UPTODATE, &dev->flags) ||
-		    test_bit(R5_Wantcompute, &dev->flags))) {
+		      test_bit(R5_InCache, &dev->flags) ||
+		      test_bit(R5_Wantcompute, &dev->flags))) {
 			if (test_bit(R5_Insync, &dev->flags))
 				rcw++;
 			else
 				rcw += 2*disks;
 		}
 	}
+
 	pr_debug("for sector %llu, rmw=%d rcw=%d\n",
 		(unsigned long long)sh->sector, rmw, rcw);
 	set_bit(STRIPE_HANDLE, &sh->state);
@@ -3554,10 +3601,16 @@ static void handle_stripe_dirtying(struct r5conf *conf,
 					  (unsigned long long)sh->sector, rmw);
 		for (i = disks; i--; ) {
 			struct r5dev *dev = &sh->dev[i];
-			if ((dev->towrite || i == sh->pd_idx || i == sh->qd_idx) &&
+			if (test_bit(R5_InCache, &dev->flags) &&
+			    dev->page == dev->orig_page)
+				dev->page = alloc_page(GFP_NOIO);  /* allocate page for prexor */
+
+			if ((dev->towrite || i == sh->pd_idx || i == sh->qd_idx ||
+			     test_bit(R5_InCache, &dev->flags)) &&
 			    !test_bit(R5_LOCKED, &dev->flags) &&
-			    !(test_bit(R5_UPTODATE, &dev->flags) ||
-			    test_bit(R5_Wantcompute, &dev->flags)) &&
+			    /* !(test_bit(R5_UPTODATE, &dev->flags) || */
+			    !((test_bit(R5_UPTODATE, &dev->flags) && (!test_bit(R5_InCache, &dev->flags) || (dev->page != dev->orig_page))) ||
+			      test_bit(R5_Wantcompute, &dev->flags)) &&
 			    test_bit(R5_Insync, &dev->flags)) {
 				if (test_bit(STRIPE_PREREAD_ACTIVE,
 					     &sh->state)) {
@@ -3583,6 +3636,7 @@ static void handle_stripe_dirtying(struct r5conf *conf,
 			    i != sh->pd_idx && i != sh->qd_idx &&
 			    !test_bit(R5_LOCKED, &dev->flags) &&
 			    !(test_bit(R5_UPTODATE, &dev->flags) ||
+			      test_bit(R5_InCache, &dev->flags) ||
 			      test_bit(R5_Wantcompute, &dev->flags))) {
 				rcw++;
 				if (test_bit(R5_Insync, &dev->flags) &&
@@ -3610,6 +3664,10 @@ static void handle_stripe_dirtying(struct r5conf *conf,
 	    !test_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
 		set_bit(STRIPE_DELAYED, &sh->state);
 
+	if ((sh->r5c_state == R5C_STATE_FROZEN) && (rmw == 0 || rcw == 0)) {
+		r5c_set_state(sh, R5C_STATE_PARITY_RUN);
+	}
+
 	/* now if nothing is locked, and if we have enough data,
 	 * we can start a write request
 	 */
@@ -3622,7 +3680,7 @@ static void handle_stripe_dirtying(struct r5conf *conf,
 	 */
 	if ((s->req_compute || !test_bit(STRIPE_COMPUTE_RUN, &sh->state)) &&
 	    (s->locked == 0 && (rcw == 0 || rmw == 0) &&
-	    !test_bit(STRIPE_BIT_DELAY, &sh->state)))
+	     !test_bit(STRIPE_BIT_DELAY, &sh->state)))
 		schedule_reconstruction(sh, s, rcw == 0, 0);
 }
 
@@ -3935,6 +3993,38 @@ static void handle_stripe_expansion(struct r5conf *conf, struct stripe_head *sh)
 	async_tx_quiesce(&tx);
 }
 
+static void r5c_return_dev_pending_writes(struct r5conf *conf, struct r5dev *dev,
+					  struct bio_list *return_bi)
+{
+	struct bio *wbi, *wbi2;
+
+	wbi = dev->written;
+	dev->written = NULL;
+	while (wbi && wbi->bi_iter.bi_sector <
+	       dev->sector + STRIPE_SECTORS) {
+		wbi2 = r5_next_bio(wbi, dev->sector);
+		if (!raid5_dec_bi_active_stripes(wbi)) {
+			md_write_end(conf->mddev);
+			bio_list_add(return_bi, wbi);
+		}
+		wbi = wbi2;
+	}
+}
+
+static void r5c_handle_cached_data_endio(struct r5conf *conf,
+		  struct stripe_head *sh, int disks, struct bio_list *return_bi)
+{
+	int i;
+
+	for (i = sh->disks; i--; ) {
+		if (test_bit(R5_InCache, &sh->dev[i].flags) && sh->dev[i].written) {
+			set_bit(R5_UPTODATE, &sh->dev[i].flags);
+			r5c_return_dev_pending_writes(conf, &sh->dev[i], return_bi);
+		}
+	}
+	r5l_stripe_write_finished(sh);
+}
+
 /*
  * handle_stripe - do things to a stripe.
  *
@@ -4113,6 +4203,13 @@ static void analyse_stripe(struct stripe_head *sh, struct stripe_head_state *s)
 			if (rdev && !test_bit(Faulty, &rdev->flags))
 				do_recovery = 1;
 		}
+		if (test_bit(R5_InCache, &dev->flags)) {
+			s->in_cache++;
+			if (dev->written)
+				s->just_cached++;
+			if (i == sh->pd_idx || i == sh->qd_idx)
+				s->parity_cached++;
+		}
 	}
 	if (test_bit(STRIPE_SYNCING, &sh->state)) {
 		/* If there is a failed device being replaced,
@@ -4341,7 +4438,7 @@ static void handle_stripe(struct stripe_head *sh)
 			struct r5dev *dev = &sh->dev[i];
 			if (test_bit(R5_LOCKED, &dev->flags) &&
 				(i == sh->pd_idx || i == sh->qd_idx ||
-				 dev->written)) {
+				 dev->written || test_bit(R5_InCache, &dev->flags))) {
 				pr_debug("Writing block %d\n", i);
 				set_bit(R5_Wantwrite, &dev->flags);
 				if (prexor)
@@ -4381,6 +4478,17 @@ static void handle_stripe(struct stripe_head *sh)
 				 test_bit(R5_Discard, &qdev->flags))))))
 		handle_stripe_clean_event(conf, sh, disks, &s.return_bi);
 
+	if (s.just_cached)
+		r5c_handle_cached_data_endio(conf, sh, disks, &s.return_bi);
+
+	if (sh->r5c_state == R5C_STATE_PARITY_DONE)
+		r5l_stripe_write_finished(sh);
+
+	if (s.parity_cached == sh->raid_conf->max_degraded) {
+		r5c_set_state(sh, R5C_STATE_PARITY_DONE);
+		r5l_stripe_write_finished(sh);
+	}
+
 	/* Now we might consider reading some blocks, either to check/generate
 	 * parity, or to satisfy requests
 	 * or to load a block that is being partially written.
@@ -4392,13 +4500,17 @@ static void handle_stripe(struct stripe_head *sh)
 	    || s.expanding)
 		handle_stripe_fill(sh, &s, disks);
 
-	/* Now to consider new write requests and what else, if anything
-	 * should be read.  We do not handle new writes when:
+	r5c_handle_stripe_flush(conf, sh, &s, disks);
+
+	/* Now to consider new write requests, cache write back and what else,
+	 * if anything should be read.  We do not handle new writes when:
 	 * 1/ A 'write' operation (copy+xor) is already in flight.
 	 * 2/ A 'check' operation is in flight, as it may clobber the parity
 	 *    block.
+	 * 3/ A r5c cache log write is in flight.
 	 */
-	if (s.to_write && !sh->reconstruct_state && !sh->check_state)
+	if ((s.to_write || sh->r5c_state == R5C_STATE_FROZEN) &&
+	     !sh->reconstruct_state && !sh->check_state && !sh->log_io)
 		handle_stripe_dirtying(conf, sh, &s, disks);
 
 	/* maybe we need to check and possibly fix the parity for this stripe
@@ -5853,6 +5965,7 @@ static void raid5d(struct md_thread *thread)
 			md_check_recovery(mddev);
 			spin_lock_irq(&conf->device_lock);
 		}
+		r5c_do_reclaim(conf);
 	}
 	pr_debug("%d stripes handled\n", handled);
 
@@ -6175,6 +6288,14 @@ static struct md_sysfs_entry
 r5c_cache_stats = __ATTR(r5c_cache_stats, S_IRUGO,
 			 r5c_stat_show, NULL);
 
+static struct md_sysfs_entry
+r5c_cached_stripes = __ATTR(r5c_cached_stripes, S_IRUGO | S_IWUSR,
+			    r5c_cached_stripes_show, r5c_cached_stripes_store);
+
+static struct md_sysfs_entry
+r5c_cache_mode = __ATTR(r5c_cache_mode, S_IRUGO | S_IWUSR,
+			r5c_show_cache_mode, r5c_store_cache_mode);
+
 static struct attribute *raid5_attrs[] =  {
 	&raid5_stripecache_size.attr,
 	&raid5_stripecache_active.attr,
@@ -6183,6 +6304,8 @@ static struct attribute *raid5_attrs[] =  {
 	&raid5_skip_copy.attr,
 	&raid5_rmw_level.attr,
 	&r5c_cache_stats.attr,
+	&r5c_cached_stripes.attr,
+	&r5c_cache_mode.attr,
 	NULL,
 };
 static struct attribute_group raid5_attrs_group = {
@@ -6524,6 +6647,9 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 	for (i = 0; i < NR_STRIPE_HASH_LOCKS; i++)
 		INIT_LIST_HEAD(conf->temp_inactive_list + i);
 
+	atomic_set(&conf->r5c_cached_stripes, 0);
+	INIT_LIST_HEAD(&conf->r5c_cached_list);
+
 	conf->level = mddev->new_level;
 	conf->chunk_sectors = mddev->new_chunk_sectors;
 	if (raid5_alloc_percpu(conf) != 0)
@@ -7578,8 +7704,10 @@ static void raid5_quiesce(struct mddev *mddev, int state)
 		/* '2' tells resync/reshape to pause so that all
 		 * active stripes can drain
 		 */
+		r5c_flush_cache(conf);
 		conf->quiesce = 2;
 		wait_event_cmd(conf->wait_for_quiescent,
+				    atomic_read(&conf->r5c_cached_stripes) == 0 &&
 				    atomic_read(&conf->active_stripes) == 0 &&
 				    atomic_read(&conf->active_aligned_reads) == 0,
 				    unlock_all_device_hash_locks_irq(conf),
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index de11514..78fcc6d 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -194,6 +194,15 @@ enum reconstruct_states {
 	reconstruct_state_result,
 };
 
+enum r5c_states {
+	R5C_STATE_CLEAN = 0,		/* all data in RAID HDDs are up to date */
+	R5C_STATE_RUNNING = 1,		/* stripe can accept new writes */
+	R5C_STATE_FROZEN = 2,		/* Doesn't accept new data and is reclaiming */
+	R5C_STATE_PARITY_RUN = 3,	/* stripe parity is being written to cache disk */
+	R5C_STATE_PARITY_DONE = 4,	/* stripe parity is in cache disk */
+	R5C_STATE_INRAID = R5C_STATE_CLEAN,     /* stripe data/parity are in raid disks */
+};
+
 struct stripe_head {
 	struct hlist_node	hash;
 	struct list_head	lru;	      /* inactive_list or handle_list */
@@ -216,6 +225,7 @@ struct stripe_head {
 						  */
 	enum check_states	check_state;
 	enum reconstruct_states reconstruct_state;
+	enum r5c_states		r5c_state;
 	spinlock_t		stripe_lock;
 	int			cpu;
 	struct r5worker_group	*group;
@@ -226,6 +236,7 @@ struct stripe_head {
 
 	struct r5l_io_unit	*log_io;
 	struct list_head	log_list;
+	atomic_t		dev_in_cache;
 	/**
 	 * struct stripe_operations
 	 * @target - STRIPE_OP_COMPUTE_BLK target
@@ -263,6 +274,7 @@ struct stripe_head_state {
 	 */
 	int syncing, expanding, expanded, replacing;
 	int locked, uptodate, to_read, to_write, failed, written;
+	int to_cache, in_cache, just_cached, parity_cached;
 	int to_fill, compute, req_compute, non_overwrite;
 	int failed_num[2];
 	int p_failed, q_failed;
@@ -313,6 +325,8 @@ enum r5dev_flags {
 			 */
 	R5_Discard,	/* Discard the stripe */
 	R5_SkipCopy,	/* Don't copy data from bio to stripe cache */
+	R5_Wantcache,	/* Want write data to write cache */
+	R5_InCache,	/* Data in cache */
 };
 
 /*
@@ -345,7 +359,8 @@ enum {
 	STRIPE_BITMAP_PENDING,	/* Being added to bitmap, don't add
 				 * to batch yet.
 				 */
-	STRIPE_LOG_TRAPPED, /* trapped into log */
+	STRIPE_LOG_TRAPPED,	/* trapped into log */
+	STRIPE_IN_R5C_CACHE,	/* in r5c cache (to-be/being handled or in conf->r5c_cached_list) */
 };
 
 #define STRIPE_EXPAND_SYNC_FLAGS \
@@ -521,6 +536,8 @@ struct r5conf {
 	 */
 	atomic_t		active_stripes;
 	struct list_head	inactive_list[NR_STRIPE_HASH_LOCKS];
+	atomic_t		r5c_cached_stripes;
+	struct list_head	r5c_cached_list;
 	atomic_t		empty_inactive_list_nr;
 	struct llist_head	released_stripes;
 	wait_queue_head_t	wait_for_quiescent;
@@ -690,10 +707,29 @@ extern void r5l_stripe_write_finished(struct stripe_head *sh);
 extern int r5l_handle_flush_request(struct r5l_log *log, struct bio *bio);
 extern void r5l_quiesce(struct r5l_log *log, int state);
 extern bool r5l_log_disk_error(struct r5conf *conf);
+extern void r5l_wake_reclaim(struct r5l_log *log, sector_t space);
 
 extern struct bio *r5c_lookup_chunk(struct r5l_log *log, struct bio *raid_bio);
 extern struct stripe_head *__find_stripe(struct r5conf *conf, sector_t sector,
 					 short generation);
 
 extern ssize_t r5c_stat_show(struct mddev *mddev, char* page);
+
+extern int r5c_handle_stripe_dirtying(struct r5conf *conf, struct stripe_head *sh,
+				      struct stripe_head_state *s, int disks);
+extern int r5c_cache_data(struct r5l_log *log, struct stripe_head *sh,
+			  struct stripe_head_state *s);
+extern int r5c_cache_parity(struct r5l_log *log, struct stripe_head *sh,
+			    struct stripe_head_state *s);
+extern void r5c_handle_stripe_flush(struct r5conf *conf, struct stripe_head *sh,
+				    struct stripe_head_state *s, int disks);
+extern void r5c_freeze_stripe_for_reclaim(struct stripe_head *sh);
+extern void r5c_do_reclaim(struct r5conf *conf);
+
+extern ssize_t r5c_cached_stripes_show(struct mddev *mddev, char* page);
+extern ssize_t r5c_cached_stripes_store(struct mddev *mddev, const char *page, size_t len);
+extern int r5c_flush_cache(struct r5conf *conf);
+extern ssize_t r5c_show_cache_mode(struct mddev *mddev, char *page);
+extern ssize_t r5c_store_cache_mode(struct mddev *mddev, const char *page, size_t len);
+extern void r5c_set_state(struct stripe_head *sh, enum r5c_states new_state);
 #endif
-- 
2.8.0.rc2

