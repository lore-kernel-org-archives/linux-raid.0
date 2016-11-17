From: Song Liu <songliubraving@fb.com>
Subject: [PATCH v7 05/10] md/r5cache: write-out phase and reclaim support
Date: Thu, 17 Nov 2016 15:24:40 -0800
Message-ID: <20161117232445.1798305-6-songliubraving@fb.com>
References: <20161117232445.1798305-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161117232445.1798305-1-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.com, shli@fb.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, liuzhengyuang521@gmail.com, liuzhengyuan@kylinos.cn, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

There are two limited resources, stripe cache and journal disk space.
For better performance, we priotize reclaim of full stripe writes.
To free up more journal space, we free earliest data on the journal.

In current implementation, reclaim happens when:
1. Periodically (every R5C_RECLAIM_WAKEUP_INTERVAL, 30 seconds) reclaim
   if there is no reclaim in the past 5 seconds.
2. when there are R5C_FULL_STRIPE_FLUSH_BATCH (256) cached full stripes,
   or cached stripes is enough for a full stripe (chunk size / 4k)
   (r5c_check_cached_full_stripe)
3. when there is pressure on stripe cache (r5c_check_stripe_cache_usage)
4. when there is pressure on journal space (r5l_write_stripe, r5c_cache_data)

r5c_do_reclaim() contains new logic of reclaim.

For stripe cache:

When stripe cache pressure is high (more than 3/4 stripes are cached,
or there is empty inactive lists), flush all full stripe. If fewer
than R5C_RECLAIM_STRIPE_GROUP (NR_STRIPE_HASH_LOCKS * 2) full stripes
are flushed, flush some paritial stripes. When stripe cache pressure
is moderate (1/2 to 3/4 of stripes are cached), flush all full stripes.

For log space:

To avoid deadlock due to log space, we need to reserve enough space
to flush cached data. The size of required log space depends on total
number of cached stripes (stripe_in_journal_count). In current
implementation, the writing-out phase automatically include pending
data writes with parity writes (similar to write through case).
Therefore, we need up to (conf->raid_disks + 1) pages for each cached
stripe (1 page for meta data, raid_disks pages for all data and
parity). r5c_log_required_to_flush_cache() calculates log space
required to flush cache. In the following, we refer to the space
calculated by r5c_log_required_to_flush_cache() as
reclaim_required_space.

Two flags are added to r5conf->cache_state: R5C_LOG_TIGHT and
R5C_LOG_CRITICAL. R5C_LOG_TIGHT is set when free space on the log
device is less than 3x of reclaim_required_space. R5C_LOG_CRITICAL
is set when free space on the log device is less than 2x of
reclaim_required_space.

r5c_cache keeps all data in cache (not fully committed to RAID) in
a list (stripe_in_journal_list). These stripes are in the order of their
first appearance on the journal. So the log tail (last_checkpoint)
should point to the journal_start of the first item in the list.

When R5C_LOG_TIGHT is set, r5l_reclaim_thread starts flushing out
stripes at the head of stripe_in_journal. When R5C_LOG_CRITICAL is
set, the state machine only writes data that are already in the
log device (in stripe_in_journal_list).

This patch includes a fix to improve performance by
Shaohua Li <shli@fb.com>.

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 drivers/md/raid5-cache.c | 411 +++++++++++++++++++++++++++++++++++++++++++----
 drivers/md/raid5.c       |  21 +++
 drivers/md/raid5.h       |  39 +++--
 3 files changed, 430 insertions(+), 41 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 19c5af9..7dec2a0 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -29,12 +29,21 @@
 #define BLOCK_SECTORS (8)
 
 /*
- * reclaim runs every 1/4 disk size or 10G reclaimable space. This can prevent
- * recovery scans a very long log
+ * log->max_free_space is min(1/4 disk size, 10G reclaimable space).
+ *
+ * In write through mode, the reclaim runs every log->max_free_space.
+ * This can prevent the recovery scans for too long
  */
 #define RECLAIM_MAX_FREE_SPACE (10 * 1024 * 1024 * 2) /* sector */
 #define RECLAIM_MAX_FREE_SPACE_SHIFT (2)
 
+/* wake up reclaim thread periodically */
+#define R5C_RECLAIM_WAKEUP_INTERVAL (30 * HZ)
+/* start flush with these full stripes */
+#define R5C_FULL_STRIPE_FLUSH_BATCH 256
+/* reclaim stripes in groups */
+#define R5C_RECLAIM_STRIPE_GROUP (NR_STRIPE_HASH_LOCKS * 2)
+
 /*
  * We only need 2 bios per I/O unit to make progress, but ensure we
  * have a few more available to not get too tight.
@@ -141,6 +150,12 @@ struct r5l_log {
 
 	/* for r5c_cache */
 	enum r5c_journal_mode r5c_journal_mode;
+
+	/* all stripes in r5cache, in the order of seq at sh->log_start */
+	struct list_head stripe_in_journal_list;
+
+	spinlock_t stripe_in_journal_lock;
+	atomic_t stripe_in_journal_count;
 };
 
 /*
@@ -256,11 +271,109 @@ void r5c_handle_cached_data_endio(struct r5conf *conf,
 	}
 }
 
+/* Check whether we should flush some stripes to free up stripe cache */
+void r5c_check_stripe_cache_usage(struct r5conf *conf)
+{
+	int total_cached;
+
+	if (!r5c_is_writeback(conf->log))
+		return;
+
+	total_cached = atomic_read(&conf->r5c_cached_partial_stripes) +
+		atomic_read(&conf->r5c_cached_full_stripes);
+
+	/*
+	 * The following condition is true for either of the following:
+	 *   - stripe cache pressure high:
+	 *          total_cached > 3/4 min_nr_stripes ||
+	 *          empty_inactive_list_nr > 0
+	 *   - stripe cache pressure moderate:
+	 *          total_cached > 1/2 min_nr_stripes
+	 */
+	if (total_cached > conf->min_nr_stripes * 1 / 2 ||
+	    atomic_read(&conf->empty_inactive_list_nr) > 0)
+		r5l_wake_reclaim(conf->log, 0);
+}
+
+/*
+ * flush cache when there are R5C_FULL_STRIPE_FLUSH_BATCH or more full
+ * stripes in the cache
+ */
+void r5c_check_cached_full_stripe(struct r5conf *conf)
+{
+	if (!r5c_is_writeback(conf->log))
+		return;
+
+	/*
+	 * wake up reclaim for R5C_FULL_STRIPE_FLUSH_BATCH cached stripes
+	 * or a full stripe (chunk size / 4k stripes).
+	 */
+	if (atomic_read(&conf->r5c_cached_full_stripes) >=
+	    min(R5C_FULL_STRIPE_FLUSH_BATCH,
+		conf->chunk_sectors >> STRIPE_SHIFT))
+		r5l_wake_reclaim(conf->log, 0);
+}
+
+/*
+ * Total log space (in sectors) needed to flush all data in cache
+ *
+ * Currently, writing-out phase automatically includes all pending writes
+ * to the same sector. So the reclaim of each stripe takes up to
+ * (conf->raid_disks + 1) pages of log space.
+ *
+ * To totally avoid deadlock due to log space, the code reserves
+ * (conf->raid_disks + 1) pages for each stripe in cache, which is not
+ * necessary in most cases.
+ *
+ * To improve this, we will need writing-out phase to be able to NOT include
+ * pending writes, which will reduce the requirement to
+ * (conf->max_degraded + 1) pages per stripe in cache.
+ */
+static sector_t r5c_log_required_to_flush_cache(struct r5conf *conf)
+{
+	struct r5l_log *log = conf->log;
+
+	if (!r5c_is_writeback(log))
+		return 0;
+
+	return BLOCK_SECTORS * (conf->raid_disks + 1) *
+		atomic_read(&log->stripe_in_journal_count);
+}
+
+/*
+ * evaluate log space usage and update R5C_LOG_TIGHT and R5C_LOG_CRITICAL
+ *
+ * R5C_LOG_TIGHT is set when free space on the log device is less than 3x of
+ * reclaim_required_space. R5C_LOG_CRITICAL is set when free space on the log
+ * device is less than 2x of reclaim_required_space.
+ */
+static inline void r5c_update_log_state(struct r5l_log *log)
+{
+	struct r5conf *conf = log->rdev->mddev->private;
+	sector_t free_space;
+	sector_t reclaim_space;
+
+	if (!r5c_is_writeback(log))
+		return;
+
+	free_space = r5l_ring_distance(log, log->log_start,
+				       log->last_checkpoint);
+	reclaim_space = r5c_log_required_to_flush_cache(conf);
+	if (free_space < 2 * reclaim_space)
+		set_bit(R5C_LOG_CRITICAL, &conf->cache_state);
+	else
+		clear_bit(R5C_LOG_CRITICAL, &conf->cache_state);
+	if (free_space < 3 * reclaim_space)
+		set_bit(R5C_LOG_TIGHT, &conf->cache_state);
+	else
+		clear_bit(R5C_LOG_TIGHT, &conf->cache_state);
+}
+
 /*
  * Put the stripe into writing-out phase by clearing STRIPE_R5C_CACHING.
  * This function should only be called in write-back mode.
  */
-static void r5c_make_stripe_write_out(struct stripe_head *sh)
+void r5c_make_stripe_write_out(struct stripe_head *sh)
 {
 	struct r5conf *conf = sh->raid_conf;
 	struct r5l_log *log = conf->log;
@@ -440,6 +553,7 @@ static void r5_reserve_log_entry(struct r5l_log *log, struct r5l_io_unit *io)
 {
 	log->log_start = r5l_ring_add(log, log->log_start, BLOCK_SECTORS);
 
+	r5c_update_log_state(log);
 	/*
 	 * If we filled up the log device start from the beginning again,
 	 * which will require a new bio.
@@ -600,21 +714,43 @@ static int r5l_log_stripe(struct r5l_log *log, struct stripe_head *sh,
 	atomic_inc(&io->pending_stripe);
 	sh->log_io = io;
 
+	if (log->r5c_journal_mode == R5C_JOURNAL_MODE_WRITE_THROUGH)
+		return 0;
+
+	if (sh->log_start == MaxSector) {
+		BUG_ON(!list_empty(&sh->r5c));
+		sh->log_start = io->log_start;
+		spin_lock_irq(&log->stripe_in_journal_lock);
+		list_add_tail(&sh->r5c,
+			      &log->stripe_in_journal_list);
+		spin_unlock_irq(&log->stripe_in_journal_lock);
+		atomic_inc(&log->stripe_in_journal_count);
+	}
 	return 0;
 }
 
-static void r5l_wake_reclaim(struct r5l_log *log, sector_t space);
+/* add stripe to no_space_stripes, and then wake up reclaim */
+static inline void r5l_add_no_space_stripe(struct r5l_log *log,
+					   struct stripe_head *sh)
+{
+	spin_lock(&log->no_space_stripes_lock);
+	list_add_tail(&sh->log_list, &log->no_space_stripes);
+	spin_unlock(&log->no_space_stripes_lock);
+}
+
 /*
  * running in raid5d, where reclaim could wait for raid5d too (when it flushes
  * data from log to raid disks), so we shouldn't wait for reclaim here
  */
 int r5l_write_stripe(struct r5l_log *log, struct stripe_head *sh)
 {
+	struct r5conf *conf = sh->raid_conf;
 	int write_disks = 0;
 	int data_pages, parity_pages;
 	int reserve;
 	int i;
 	int ret = 0;
+	bool wake_reclaim = false;
 
 	if (!log)
 		return -EAGAIN;
@@ -658,22 +794,49 @@ int r5l_write_stripe(struct r5l_log *log, struct stripe_head *sh)
 	mutex_lock(&log->io_mutex);
 	/* meta + data */
 	reserve = (1 + write_disks) << (PAGE_SHIFT - 9);
-	if (!r5l_has_free_space(log, reserve)) {
-		spin_lock(&log->no_space_stripes_lock);
-		list_add_tail(&sh->log_list, &log->no_space_stripes);
-		spin_unlock(&log->no_space_stripes_lock);
 
-		r5l_wake_reclaim(log, reserve);
-	} else {
-		ret = r5l_log_stripe(log, sh, data_pages, parity_pages);
-		if (ret) {
-			spin_lock_irq(&log->io_list_lock);
-			list_add_tail(&sh->log_list, &log->no_mem_stripes);
-			spin_unlock_irq(&log->io_list_lock);
+	if (log->r5c_journal_mode == R5C_JOURNAL_MODE_WRITE_THROUGH) {
+		if (!r5l_has_free_space(log, reserve)) {
+			r5l_add_no_space_stripe(log, sh);
+			wake_reclaim = true;
+		} else {
+			ret = r5l_log_stripe(log, sh, data_pages, parity_pages);
+			if (ret) {
+				spin_lock_irq(&log->io_list_lock);
+				list_add_tail(&sh->log_list,
+					      &log->no_mem_stripes);
+				spin_unlock_irq(&log->io_list_lock);
+			}
+		}
+	} else {  /* R5C_JOURNAL_MODE_WRITE_BACK */
+		/*
+		 * log space critical, do not process stripes that are
+		 * not in cache yet (sh->log_start == MaxSector).
+		 */
+		if (test_bit(R5C_LOG_CRITICAL, &conf->cache_state) &&
+		    sh->log_start == MaxSector) {
+			r5l_add_no_space_stripe(log, sh);
+			wake_reclaim = true;
+			reserve = 0;
+		} else if (!r5l_has_free_space(log, reserve)) {
+			if (sh->log_start == log->last_checkpoint)
+				BUG();
+			else
+				r5l_add_no_space_stripe(log, sh);
+		} else {
+			ret = r5l_log_stripe(log, sh, data_pages, parity_pages);
+			if (ret) {
+				spin_lock_irq(&log->io_list_lock);
+				list_add_tail(&sh->log_list,
+					      &log->no_mem_stripes);
+				spin_unlock_irq(&log->io_list_lock);
+			}
 		}
 	}
 
 	mutex_unlock(&log->io_mutex);
+	if (wake_reclaim)
+		r5l_wake_reclaim(log, reserve);
 	return 0;
 }
 
@@ -720,10 +883,40 @@ static void r5l_run_no_space_stripes(struct r5l_log *log)
 	spin_unlock(&log->no_space_stripes_lock);
 }
 
+/*
+ * calculate new last_checkpoint
+ * for write through mode, returns log->next_checkpoint
+ * for write back, returns log_start of first sh in stripe_in_journal_list
+ */
+static sector_t r5c_calculate_new_cp(struct r5conf *conf)
+{
+	struct stripe_head *sh;
+	struct r5l_log *log = conf->log;
+	sector_t new_cp;
+	unsigned long flags;
+
+	if (log->r5c_journal_mode == R5C_JOURNAL_MODE_WRITE_THROUGH)
+		return log->next_checkpoint;
+
+	spin_lock_irqsave(&log->stripe_in_journal_lock, flags);
+	if (list_empty(&conf->log->stripe_in_journal_list)) {
+		/* all stripes flushed */
+		spin_unlock(&log->stripe_in_journal_lock);
+		return log->next_checkpoint;
+	}
+	sh = list_first_entry(&conf->log->stripe_in_journal_list,
+			      struct stripe_head, r5c);
+	new_cp = sh->log_start;
+	spin_unlock_irqrestore(&log->stripe_in_journal_lock, flags);
+	return new_cp;
+}
+
 static sector_t r5l_reclaimable_space(struct r5l_log *log)
 {
+	struct r5conf *conf = log->rdev->mddev->private;
+
 	return r5l_ring_distance(log, log->last_checkpoint,
-				 log->next_checkpoint);
+				 r5c_calculate_new_cp(conf));
 }
 
 static void r5l_run_no_mem_stripe(struct r5l_log *log)
@@ -769,6 +962,7 @@ static bool r5l_complete_finished_ios(struct r5l_log *log)
 static void __r5l_stripe_write_finished(struct r5l_io_unit *io)
 {
 	struct r5l_log *log = io->log;
+	struct r5conf *conf = log->rdev->mddev->private;
 	unsigned long flags;
 
 	spin_lock_irqsave(&log->io_list_lock, flags);
@@ -779,7 +973,8 @@ static void __r5l_stripe_write_finished(struct r5l_io_unit *io)
 		return;
 	}
 
-	if (r5l_reclaimable_space(log) > log->max_free_space)
+	if (r5l_reclaimable_space(log) > log->max_free_space ||
+	    test_bit(R5C_LOG_TIGHT, &conf->cache_state))
 		r5l_wake_reclaim(log, 0);
 
 	spin_unlock_irqrestore(&log->io_list_lock, flags);
@@ -900,14 +1095,146 @@ static void r5l_write_super_and_discard_space(struct r5l_log *log,
 	}
 }
 
+/*
+ * r5c_flush_stripe moves stripe from cached list to handle_list. When called,
+ * the stripe must be on r5c_cached_full_stripes or r5c_cached_partial_stripes.
+ *
+ * must hold conf->device_lock
+ */
+static void r5c_flush_stripe(struct r5conf *conf, struct stripe_head *sh)
+{
+	BUG_ON(list_empty(&sh->lru));
+	BUG_ON(!test_bit(STRIPE_R5C_CACHING, &sh->state));
+	BUG_ON(test_bit(STRIPE_HANDLE, &sh->state));
+
+	/*
+	 * The stripe is not ON_RELEASE_LIST, so it is safe to call
+	 * raid5_release_stripe() while holding conf->device_lock
+	 */
+	BUG_ON(test_bit(STRIPE_ON_RELEASE_LIST, &sh->state));
+	assert_spin_locked(&conf->device_lock);
+
+	list_del_init(&sh->lru);
+	atomic_inc(&sh->count);
+
+	set_bit(STRIPE_HANDLE, &sh->state);
+	atomic_inc(&conf->active_stripes);
+	r5c_make_stripe_write_out(sh);
+
+	if (!test_and_set_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
+		atomic_inc(&conf->preread_active_stripes);
+	raid5_release_stripe(sh);
+}
+
+/*
+ * if num == 0, flush all full stripes
+ * if num > 0, flush all full stripes. If less than num full stripes are
+ *             flushed, flush some partial stripes until totally num stripes are
+ *             flushed or there is no more cached stripes.
+ */
+void r5c_flush_cache(struct r5conf *conf, int num)
+{
+	int count;
+	struct stripe_head *sh, *next;
+
+	assert_spin_locked(&conf->device_lock);
+	if (!conf->log)
+		return;
+
+	count = 0;
+	list_for_each_entry_safe(sh, next, &conf->r5c_full_stripe_list, lru) {
+		r5c_flush_stripe(conf, sh);
+		count++;
+	}
+
+	if (count >= num)
+		return;
+	list_for_each_entry_safe(sh, next,
+				 &conf->r5c_partial_stripe_list, lru) {
+		r5c_flush_stripe(conf, sh);
+		if (++count >= num)
+			break;
+	}
+}
+
+static void r5c_do_reclaim(struct r5conf *conf)
+{
+	struct r5l_log *log = conf->log;
+	struct stripe_head *sh;
+	int count = 0;
+	unsigned long flags;
+	int total_cached;
+	int stripes_to_flush;
+
+	if (!r5c_is_writeback(log))
+		return;
+
+	total_cached = atomic_read(&conf->r5c_cached_partial_stripes) +
+		atomic_read(&conf->r5c_cached_full_stripes);
+
+	if (total_cached > conf->min_nr_stripes * 3 / 4 ||
+	    atomic_read(&conf->empty_inactive_list_nr) > 0)
+		/*
+		 * if stripe cache pressure high, flush all full stripes and
+		 * some partial stripes
+		 */
+		stripes_to_flush = R5C_RECLAIM_STRIPE_GROUP;
+	else if (total_cached > conf->min_nr_stripes * 1 / 2 ||
+		 atomic_read(&conf->r5c_cached_full_stripes) >
+		 R5C_FULL_STRIPE_FLUSH_BATCH)
+		/*
+		 * if stripe cache pressure moderate, or if there is many full
+		 * stripes,flush all full stripes
+		 */
+		stripes_to_flush = 0;
+	else
+		/* no need to flush */
+		stripes_to_flush = -1;
+
+	if (stripes_to_flush >= 0) {
+		spin_lock_irqsave(&conf->device_lock, flags);
+		r5c_flush_cache(conf, stripes_to_flush);
+		spin_unlock_irqrestore(&conf->device_lock, flags);
+	}
+
+	/* if log space is tight, flush stripes on stripe_in_journal_list */
+	if (test_bit(R5C_LOG_TIGHT, &conf->cache_state)) {
+		spin_lock_irqsave(&log->stripe_in_journal_lock, flags);
+		spin_lock(&conf->device_lock);
+		list_for_each_entry(sh, &log->stripe_in_journal_list, r5c) {
+			/*
+			 * stripes on stripe_in_journal_list could be in any
+			 * state of the stripe_cache state machine. In this
+			 * case, we only want to flush stripe on
+			 * r5c_cached_full/partial_stripes. The following
+			 * condition makes sure the stripe is on one of the
+			 * two lists.
+			 */
+			if (!list_empty(&sh->lru) &&
+			    !test_bit(STRIPE_HANDLE, &sh->state) &&
+			    atomic_read(&sh->count) == 0) {
+				r5c_flush_stripe(conf, sh);
+			}
+			if (count++ >= R5C_RECLAIM_STRIPE_GROUP)
+				break;
+		}
+		spin_unlock(&conf->device_lock);
+		spin_unlock_irqrestore(&log->stripe_in_journal_lock, flags);
+	}
+	md_wakeup_thread(conf->mddev->thread);
+}
+
 static void r5l_do_reclaim(struct r5l_log *log)
 {
+	struct r5conf *conf = log->rdev->mddev->private;
 	sector_t reclaim_target = xchg(&log->reclaim_target, 0);
 	sector_t reclaimable;
 	sector_t next_checkpoint;
-	u64 next_cp_seq;
+	bool write_super;
 
 	spin_lock_irq(&log->io_list_lock);
+	write_super = r5l_reclaimable_space(log) > log->max_free_space ||
+		reclaim_target != 0 || !list_empty(&log->no_space_stripes);
 	/*
 	 * move proper io_unit to reclaim list. We should not change the order.
 	 * reclaimable/unreclaimable io_unit can be mixed in the list, we
@@ -928,12 +1255,12 @@ static void r5l_do_reclaim(struct r5l_log *log)
 				    log->io_list_lock);
 	}
 
-	next_checkpoint = log->next_checkpoint;
-	next_cp_seq = log->next_cp_seq;
+	next_checkpoint = r5c_calculate_new_cp(conf);
 	spin_unlock_irq(&log->io_list_lock);
 
 	BUG_ON(reclaimable < 0);
-	if (reclaimable == 0)
+
+	if (reclaimable == 0 || !write_super)
 		return;
 
 	/*
@@ -945,7 +1272,7 @@ static void r5l_do_reclaim(struct r5l_log *log)
 
 	mutex_lock(&log->io_mutex);
 	log->last_checkpoint = next_checkpoint;
-	log->last_cp_seq = next_cp_seq;
+	r5c_update_log_state(log);
 	mutex_unlock(&log->io_mutex);
 
 	r5l_run_no_space_stripes(log);
@@ -959,14 +1286,17 @@ static void r5l_reclaim_thread(struct md_thread *thread)
 
 	if (!log)
 		return;
+	r5c_do_reclaim(conf);
 	r5l_do_reclaim(log);
 }
 
-static void r5l_wake_reclaim(struct r5l_log *log, sector_t space)
+void r5l_wake_reclaim(struct r5l_log *log, sector_t space)
 {
 	unsigned long target;
 	unsigned long new = (unsigned long)space; /* overflow in theory */
 
+	if (!log)
+		return;
 	do {
 		target = log->reclaim_target;
 		if (new < target)
@@ -990,11 +1320,12 @@ void r5l_quiesce(struct r5l_log *log, int state)
 			return;
 		log->reclaim_thread = md_register_thread(r5l_reclaim_thread,
 					log->rdev->mddev, "reclaim");
+		log->reclaim_thread->timeout = R5C_RECLAIM_WAKEUP_INTERVAL;
 	} else if (state == 1) {
 		/* make sure r5l_write_super_and_discard_space exits */
 		mddev = log->rdev->mddev;
 		wake_up(&mddev->sb_wait);
-		r5l_wake_reclaim(log, -1L);
+		r5l_wake_reclaim(log, MaxSector);
 		md_unregister_thread(&log->reclaim_thread);
 		r5l_do_reclaim(log);
 	}
@@ -1415,12 +1746,22 @@ void r5c_finish_stripe_write_out(struct r5conf *conf,
 
 	if (do_wakeup)
 		wake_up(&conf->wait_for_overlap);
+
+	if (conf->log->r5c_journal_mode == R5C_JOURNAL_MODE_WRITE_THROUGH)
+		return;
+
+	spin_lock_irq(&conf->log->stripe_in_journal_lock);
+	list_del_init(&sh->r5c);
+	spin_unlock_irq(&conf->log->stripe_in_journal_lock);
+	sh->log_start = MaxSector;
+	atomic_dec(&conf->log->stripe_in_journal_count);
 }
 
 int
 r5c_cache_data(struct r5l_log *log, struct stripe_head *sh,
 	       struct stripe_head_state *s)
 {
+	struct r5conf *conf = sh->raid_conf;
 	int pages = 0;
 	int reserve;
 	int i;
@@ -1451,12 +1792,15 @@ r5c_cache_data(struct r5l_log *log, struct stripe_head *sh,
 	mutex_lock(&log->io_mutex);
 	/* meta + data */
 	reserve = (1 + pages) << (PAGE_SHIFT - 9);
-	if (!r5l_has_free_space(log, reserve)) {
-		spin_lock(&log->no_space_stripes_lock);
-		list_add_tail(&sh->log_list, &log->no_space_stripes);
-		spin_unlock(&log->no_space_stripes_lock);
 
-		r5l_wake_reclaim(log, reserve);
+	if (test_bit(R5C_LOG_CRITICAL, &conf->cache_state) &&
+	    sh->log_start == MaxSector)
+		r5l_add_no_space_stripe(log, sh);
+	else if (!r5l_has_free_space(log, reserve)) {
+		if (sh->log_start == log->last_checkpoint)
+			BUG();
+		else
+			r5l_add_no_space_stripe(log, sh);
 	} else {
 		ret = r5l_log_stripe(log, sh, pages, 0);
 		if (ret) {
@@ -1470,7 +1814,6 @@ r5c_cache_data(struct r5l_log *log, struct stripe_head *sh,
 	return 0;
 }
 
-
 static int r5l_load_log(struct r5l_log *log)
 {
 	struct md_rdev *rdev = log->rdev;
@@ -1530,6 +1873,9 @@ static int r5l_load_log(struct r5l_log *log)
 		log->max_free_space = RECLAIM_MAX_FREE_SPACE;
 	log->last_checkpoint = cp;
 	log->next_checkpoint = cp;
+	mutex_lock(&log->io_mutex);
+	r5c_update_log_state(log);
+	mutex_unlock(&log->io_mutex);
 
 	__free_page(page);
 
@@ -1601,6 +1947,8 @@ int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
 						 log->rdev->mddev, "reclaim");
 	if (!log->reclaim_thread)
 		goto reclaim_thread;
+	log->reclaim_thread->timeout = R5C_RECLAIM_WAKEUP_INTERVAL;
+
 	init_waitqueue_head(&log->iounit_wait);
 
 	INIT_LIST_HEAD(&log->no_mem_stripes);
@@ -1609,6 +1957,9 @@ int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
 	spin_lock_init(&log->no_space_stripes_lock);
 
 	log->r5c_journal_mode = R5C_JOURNAL_MODE_WRITE_THROUGH;
+	INIT_LIST_HEAD(&log->stripe_in_journal_list);
+	spin_lock_init(&log->stripe_in_journal_lock);
+	atomic_set(&log->stripe_in_journal_count, 0);
 
 	if (r5l_load_log(log))
 		goto error;
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index f535ce2..90638ba 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -228,6 +228,16 @@ static void do_release_stripe(struct r5conf *conf, struct stripe_head *sh,
 		for (i = sh->disks; i--; )
 			if (test_bit(R5_InJournal, &sh->dev[i].flags))
 				injournal++;
+	/*
+	 * When quiesce in r5c write back, set STRIPE_HANDLE for stripes with
+	 * data in journal, so they are not released to cached lists
+	 */
+	if (conf->quiesce && r5c_is_writeback(conf->log) &&
+	    !test_bit(STRIPE_HANDLE, &sh->state) && injournal != 0) {
+		if (test_bit(STRIPE_R5C_CACHING, &sh->state))
+			r5c_make_stripe_write_out(sh);
+		set_bit(STRIPE_HANDLE, &sh->state);
+	}
 
 	if (test_bit(STRIPE_HANDLE, &sh->state)) {
 		if (test_bit(STRIPE_DELAYED, &sh->state) &&
@@ -268,6 +278,7 @@ static void do_release_stripe(struct r5conf *conf, struct stripe_head *sh,
 					if (test_and_clear_bit(STRIPE_R5C_PARTIAL_STRIPE, &sh->state))
 						atomic_dec(&conf->r5c_cached_partial_stripes);
 					list_add_tail(&sh->lru, &conf->r5c_full_stripe_list);
+					r5c_check_cached_full_stripe(conf);
 				} else {
 					/* partial stripe */
 					if (!test_and_set_bit(STRIPE_R5C_PARTIAL_STRIPE,
@@ -639,9 +650,12 @@ raid5_get_active_stripe(struct r5conf *conf, sector_t sector,
 			}
 			if (noblock && sh == NULL)
 				break;
+
+			r5c_check_stripe_cache_usage(conf);
 			if (!sh) {
 				set_bit(R5_INACTIVE_BLOCKED,
 					&conf->cache_state);
+				r5l_wake_reclaim(conf->log, 0);
 				wait_event_lock_irq(
 					conf->wait_for_stripe,
 					!list_empty(conf->inactive_list + hash) &&
@@ -1992,7 +2006,9 @@ static struct stripe_head *alloc_stripe(struct kmem_cache *sc, gfp_t gfp,
 		spin_lock_init(&sh->batch_lock);
 		INIT_LIST_HEAD(&sh->batch_list);
 		INIT_LIST_HEAD(&sh->lru);
+		INIT_LIST_HEAD(&sh->r5c);
 		atomic_set(&sh->count, 1);
+		sh->log_start = MaxSector;
 		for (i = 0; i < disks; i++) {
 			struct r5dev *dev = &sh->dev[i];
 
@@ -4759,6 +4775,10 @@ static int raid5_congested(struct mddev *mddev, int bits)
 
 	if (test_bit(R5_INACTIVE_BLOCKED, &conf->cache_state))
 		return 1;
+
+	/* Also checks whether there is pressure on r5cache log space */
+	if (test_bit(R5C_LOG_TIGHT, &conf->cache_state))
+		return 1;
 	if (conf->quiesce)
 		return 1;
 	if (atomic_read(&conf->empty_inactive_list_nr))
@@ -7661,6 +7681,7 @@ static void raid5_quiesce(struct mddev *mddev, int state)
 		/* '2' tells resync/reshape to pause so that all
 		 * active stripes can drain
 		 */
+		r5c_flush_cache(conf, INT_MAX);
 		conf->quiesce = 2;
 		wait_event_cmd(conf->wait_for_quiescent,
 				    atomic_read(&conf->active_stripes) == 0 &&
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 73c1833..35b4c0f 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -226,6 +226,8 @@ struct stripe_head {
 
 	struct r5l_io_unit	*log_io;
 	struct list_head	log_list;
+	sector_t		log_start; /* first meta block on the journal */
+	struct list_head	r5c; /* for r5c_cache->stripe_in_journal */
 	/**
 	 * struct stripe_operations
 	 * @target - STRIPE_OP_COMPUTE_BLK target
@@ -537,6 +539,27 @@ struct r5worker_group {
 	int stripes_cnt;
 };
 
+enum r5_cache_state {
+	R5_INACTIVE_BLOCKED,	/* release of inactive stripes blocked,
+				 * waiting for 25% to be free
+				 */
+	R5_ALLOC_MORE,		/* It might help to allocate another
+				 * stripe.
+				 */
+	R5_DID_ALLOC,		/* A stripe was allocated, don't allocate
+				 * more until at least one has been
+				 * released.  This avoids flooding
+				 * the cache.
+				 */
+	R5C_LOG_TIGHT,		/* log device space tight, need to
+				 * prioritize stripes at last_checkpoint
+				 */
+	R5C_LOG_CRITICAL,	/* log device is running out of space,
+				 * only process stripes that are already
+				 * occupying the log
+				 */
+};
+
 struct r5conf {
 	struct hlist_head	*stripe_hashtbl;
 	/* only protect corresponding hash list and inactive_list */
@@ -636,17 +659,6 @@ struct r5conf {
 	wait_queue_head_t	wait_for_stripe;
 	wait_queue_head_t	wait_for_overlap;
 	unsigned long		cache_state;
-#define R5_INACTIVE_BLOCKED	1	/* release of inactive stripes blocked,
-					 * waiting for 25% to be free
-					 */
-#define R5_ALLOC_MORE		2	/* It might help to allocate another
-					 * stripe.
-					 */
-#define R5_DID_ALLOC		4	/* A stripe was allocated, don't allocate
-					 * more until at least one has been
-					 * released.  This avoids flooding
-					 * the cache.
-					 */
 	struct shrinker		shrinker;
 	int			pool_size; /* number of disks in stripeheads in pool */
 	spinlock_t		device_lock;
@@ -752,8 +764,13 @@ extern void
 r5c_finish_stripe_write_out(struct r5conf *conf, struct stripe_head *sh,
 			    struct stripe_head_state *s);
 extern void r5c_release_extra_page(struct stripe_head *sh);
+extern void r5l_wake_reclaim(struct r5l_log *log, sector_t space);
 extern void r5c_handle_cached_data_endio(struct r5conf *conf,
 	struct stripe_head *sh, int disks, struct bio_list *return_bi);
 extern int r5c_cache_data(struct r5l_log *log, struct stripe_head *sh,
 			  struct stripe_head_state *s);
+extern void r5c_make_stripe_write_out(struct stripe_head *sh);
+extern void r5c_flush_cache(struct r5conf *conf, int num);
+extern void r5c_check_stripe_cache_usage(struct r5conf *conf);
+extern void r5c_check_cached_full_stripe(struct r5conf *conf);
 #endif
-- 
2.9.3

