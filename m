From: Song Liu <songliubraving@fb.com>
Subject: [PATCH v3 5/8] md/r5cache: reclaim support
Date: Thu, 6 Oct 2016 00:14:13 -0700
Message-ID: <20161006071416.3295093-6-songliubraving@fb.com>
References: <20161006071416.3295093-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161006071416.3295093-1-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.com, shli@fb.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, liuzhengyuang521@gmail.com, liuzhengyuan@kylinos.cn, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

There are two limited resources, stripe cache and journal disk space.
For better performance, we priotize reclaim of full stripe writes.
To free up more journal space, we free earliest data on the journal.

In current implementation, reclaim happens when:
1. every R5C_RECLAIM_WAKEUP_INTERVAL (5 seconds)
2. when there are R5C_FULL_STRIPE_FLUSH_BATCH (8) cached full stripes
   (r5c_check_cached_full_stripe)
3. when raid5_get_active_stripe sees pressure in stripe cache space
   (r5c_check_stripe_cache_usage)
4. when there is pressure in journal space.

1-3 above are straightforward. The following explains details of 4.

To avoid deadlock due to log space, we need to reserve enough space
to flush cached data. The size of required log space depends on total
number of cached stripes (stripe_in_cache_count). In current
implementation, the reclaim path automatically include pending
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
a list (stripe_in_cache_list). These stripes are in the order of their
first appearance on the journal. So the log tail (last_checkpoint)
should point to the journal_start of the first item in the list.

When R5C_LOG_TIGHT is set, r5l_reclaim_thread starts flushing out
stripes at the head of stripe_in_cache. When R5C_LOG_CRITICAL is
set, the state machine only writes data that are already in the
log device (in stripe_in_cache_list).

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 drivers/md/raid5-cache.c | 362 +++++++++++++++++++++++++++++++++++++++++++----
 drivers/md/raid5.c       |  21 ++-
 drivers/md/raid5.h       |  39 +++--
 3 files changed, 384 insertions(+), 38 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 92d3d7b..688dae1 100644
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
+#define R5C_RECLAIM_WAKEUP_INTERVAL (5 * HZ)
+/* start flush with these full stripes */
+#define R5C_FULL_STRIPE_FLUSH_BATCH 8
+/* reclaim stripes in groups */
+#define R5C_RECLAIM_STRIPE_GROUP (NR_STRIPE_HASH_LOCKS * 2)
+
 /*
  * We only need 2 bios per I/O unit to make progress, but ensure we
  * have a few more available to not get too tight.
@@ -141,6 +150,11 @@ struct r5l_log {
 
 	/* for r5c_cache */
 	enum r5c_state r5c_state;
+	struct list_head stripe_in_cache_list;	/* all stripes in r5cache, with
+						 * sh->log_start in order
+						 */
+	spinlock_t stripe_in_cache_lock;
+	atomic_t stripe_in_cache_count;
 };
 
 /*
@@ -256,6 +270,91 @@ void r5c_handle_cached_data_endio(struct r5conf *conf,
 	}
 }
 
+static inline int r5c_total_cached_stripes(struct r5conf *conf)
+{
+	return atomic_read(&conf->r5c_cached_partial_stripes) +
+		atomic_read(&conf->r5c_cached_full_stripes);
+}
+
+/*
+ * check whether we should flush some stripes to free up stripe cache
+ */
+void r5c_check_stripe_cache_usage(struct r5conf *conf)
+{
+	if (!r5c_is_writeback(conf->log))
+		return;
+	spin_lock(&conf->device_lock);
+	if ((r5c_total_cached_stripes(conf) >
+	     conf->min_nr_stripes * 3 / 4) ||
+	    atomic_read(&conf->empty_inactive_list_nr) > 0)
+		r5c_flush_cache(conf, R5C_RECLAIM_STRIPE_GROUP);
+	spin_unlock(&conf->device_lock);
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
+	if (atomic_read(&conf->r5c_cached_full_stripes) >=
+	    R5C_FULL_STRIPE_FLUSH_BATCH)
+		r5l_wake_reclaim(conf->log, 0);
+}
+
+/*
+ * Total log space (in sectors) needed to flush all data in cache
+ *
+ * Currently, reclaim path automatically includes all pending writes
+ * to the same sector. So the reclaim of each stripe takes up to
+ * (conf->raid_disks + 1) pages of log space.
+ *
+ * To totally avoid deadlock due to log space, the code reserves
+ * (conf->raid_disks + 1) pages for each stripe in cache, which is not
+ * necessary in most cases.
+ *
+ * To improve this, we will need reclaim path to be able to NOT include
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
+		atomic_read(&log->stripe_in_cache_count);
+}
+
+/* evaluate log space usage and update R5C_LOG_TIGHT and R5C_LOG_CRITICAL */
+static inline void r5c_update_log_state(struct r5l_log *log)
+{
+	struct r5conf *conf = log->rdev->mddev->private;
+	sector_t free_space = r5l_ring_distance(log, log->log_start,
+						log->last_checkpoint);
+	sector_t reclaim_space = r5c_log_required_to_flush_cache(conf);
+
+	if (!r5c_is_writeback(log))
+		return;
+	if (free_space < reclaim_space)
+		BUG();
+	else if (free_space < 2 * reclaim_space) {
+		set_bit(R5C_LOG_CRITICAL, &conf->cache_state);
+		set_bit(R5C_LOG_TIGHT, &conf->cache_state);
+	} else if (free_space < 3 * reclaim_space) {
+		clear_bit(R5C_LOG_CRITICAL, &conf->cache_state);
+		set_bit(R5C_LOG_TIGHT, &conf->cache_state);
+	} else if (free_space > 4 * reclaim_space) {
+		clear_bit(R5C_LOG_TIGHT, &conf->cache_state);
+		clear_bit(R5C_LOG_CRITICAL, &conf->cache_state);
+	} else
+		clear_bit(R5C_LOG_CRITICAL, &conf->cache_state);
+}
+
 /*
  * Freeze the stripe, thus send the stripe into reclaim path.
  *
@@ -290,6 +389,19 @@ void r5c_freeze_stripe_for_reclaim(struct stripe_head *sh)
 	}
 }
 
+/*
+ * do not release a stripe to cached lists in quiesce
+ */
+void r5c_prepare_stripe_for_release_in_quiesce(struct stripe_head *sh)
+{
+	if (!test_bit(STRIPE_HANDLE, &sh->state) &&
+	    atomic_read(&sh->dev_in_cache) != 0) {
+		if (!test_bit(STRIPE_R5C_FROZEN, &sh->state))
+			r5c_freeze_stripe_for_reclaim(sh);
+		set_bit(STRIPE_HANDLE, &sh->state);
+	}
+}
+
 static void r5c_handle_data_cached(struct stripe_head *sh)
 {
 	int i;
@@ -435,6 +547,7 @@ static void r5_reserve_log_entry(struct r5l_log *log, struct r5l_io_unit *io)
 {
 	log->log_start = r5l_ring_add(log, log->log_start, BLOCK_SECTORS);
 
+	r5c_update_log_state(log);
 	/*
 	 * If we filled up the log device start from the beginning again,
 	 * which will require a new bio.
@@ -552,6 +665,7 @@ static int r5l_log_stripe(struct r5l_log *log, struct stripe_head *sh,
 	int meta_size;
 	int ret;
 	struct r5l_io_unit *io;
+	unsigned long flags;
 
 	meta_size =
 		((sizeof(struct r5l_payload_data_parity) + sizeof(__le32))
@@ -595,6 +709,18 @@ static int r5l_log_stripe(struct r5l_log *log, struct stripe_head *sh,
 	atomic_inc(&io->pending_stripe);
 	sh->log_io = io;
 
+	if (log->r5c_state == R5C_STATE_WRITE_THROUGH)
+		return 0;
+
+	if (sh->log_start == MaxSector) {
+		BUG_ON(!list_empty(&sh->r5c));
+		sh->log_start = io->log_start;
+		spin_lock_irqsave(&log->stripe_in_cache_lock, flags);
+		list_add_tail(&sh->r5c,
+			      &log->stripe_in_cache_list);
+		spin_unlock_irqrestore(&log->stripe_in_cache_lock, flags);
+		atomic_inc(&log->stripe_in_cache_count);
+	}
 	return 0;
 }
 
@@ -604,6 +730,7 @@ static int r5l_log_stripe(struct r5l_log *log, struct stripe_head *sh,
  */
 int r5l_write_stripe(struct r5l_log *log, struct stripe_head *sh)
 {
+	struct r5conf *conf = sh->raid_conf;
 	int write_disks = 0;
 	int data_pages, parity_pages;
 	int reserve;
@@ -654,13 +781,36 @@ int r5l_write_stripe(struct r5l_log *log, struct stripe_head *sh)
 	mutex_lock(&log->io_mutex);
 	/* meta + data */
 	reserve = (1 + write_disks) << (PAGE_SHIFT - 9);
-	if (!r5l_has_free_space(log, reserve)) {
-		spin_lock(&log->no_space_stripes_lock);
-		list_add_tail(&sh->log_list, &log->no_space_stripes);
-		spin_unlock(&log->no_space_stripes_lock);
 
-		r5l_wake_reclaim(log, reserve);
-	} else {
+	if (log->r5c_state == R5C_STATE_WRITE_THROUGH) {
+		if (!r5l_has_free_space(log, reserve)) {
+			spin_lock(&log->no_space_stripes_lock);
+			list_add_tail(&sh->log_list, &log->no_space_stripes);
+			spin_unlock(&log->no_space_stripes_lock);
+			r5l_wake_reclaim(log, reserve);
+		} else {
+			ret = r5l_log_stripe(log, sh, data_pages, parity_pages);
+			if (ret) {
+				spin_lock_irq(&log->io_list_lock);
+				list_add_tail(&sh->log_list,
+					      &log->no_mem_stripes);
+				spin_unlock_irq(&log->io_list_lock);
+			}
+		}
+	} else {  /* R5C_STATE_WRITE_BACK */
+		if (test_bit(R5C_LOG_CRITICAL, &conf->cache_state)) {
+			/* log space critical, only process stripes in cache */
+			if (list_empty(&sh->r5c)) {
+				spin_lock(&log->no_space_stripes_lock);
+				list_add_tail(&sh->log_list,
+					      &log->no_space_stripes);
+				spin_unlock(&log->no_space_stripes_lock);
+				mutex_unlock(&log->io_mutex);
+				r5l_wake_reclaim(log, reserve);
+				return -ENOSPC;
+			}
+		}
+		BUG_ON(!r5l_has_free_space(log, reserve));
 		ret = r5l_log_stripe(log, sh, data_pages, parity_pages);
 		if (ret) {
 			spin_lock_irq(&log->io_list_lock);
@@ -716,10 +866,40 @@ static void r5l_run_no_space_stripes(struct r5l_log *log)
 	spin_unlock(&log->no_space_stripes_lock);
 }
 
+/*
+ * calculate new last_checkpoint
+ * for write through mode, returns log->next_checkpoint
+ * for write back, returns log_start of first sh in stripe_in_cache_list
+ */
+static sector_t r5c_calculate_new_cp(struct r5conf *conf)
+{
+	struct stripe_head *sh;
+	struct r5l_log *log = conf->log;
+	sector_t end = MaxSector;
+	unsigned long flags;
+
+	if (log->r5c_state == R5C_STATE_WRITE_THROUGH)
+		return log->next_checkpoint;
+
+	spin_lock_irqsave(&log->stripe_in_cache_lock, flags);
+	if (list_empty(&conf->log->stripe_in_cache_list)) {
+		/* all stripes flushed */
+		spin_unlock_irqrestore(&log->stripe_in_cache_lock, flags);
+		return log->next_checkpoint;
+	}
+	sh = list_first_entry(&conf->log->stripe_in_cache_list,
+			      struct stripe_head, r5c);
+	end = sh->log_start;
+	spin_unlock_irqrestore(&log->stripe_in_cache_lock, flags);
+	return end;
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
@@ -765,6 +945,7 @@ static bool r5l_complete_finished_ios(struct r5l_log *log)
 static void __r5l_stripe_write_finished(struct r5l_io_unit *io)
 {
 	struct r5l_log *log = io->log;
+	struct r5conf *conf = log->rdev->mddev->private;
 	unsigned long flags;
 
 	spin_lock_irqsave(&log->io_list_lock, flags);
@@ -775,7 +956,8 @@ static void __r5l_stripe_write_finished(struct r5l_io_unit *io)
 		return;
 	}
 
-	if (r5l_reclaimable_space(log) > log->max_free_space)
+	if (r5l_reclaimable_space(log) > log->max_free_space ||
+	    test_bit(R5C_LOG_TIGHT, &conf->cache_state))
 		r5l_wake_reclaim(log, 0);
 
 	spin_unlock_irqrestore(&log->io_list_lock, flags);
@@ -898,10 +1080,10 @@ static void r5l_write_super_and_discard_space(struct r5l_log *log,
 
 static void r5l_do_reclaim(struct r5l_log *log)
 {
+	struct r5conf *conf = log->rdev->mddev->private;
 	sector_t reclaim_target = xchg(&log->reclaim_target, 0);
 	sector_t reclaimable;
 	sector_t next_checkpoint;
-	u64 next_cp_seq;
 
 	spin_lock_irq(&log->io_list_lock);
 	/*
@@ -924,8 +1106,7 @@ static void r5l_do_reclaim(struct r5l_log *log)
 				    log->io_list_lock);
 	}
 
-	next_checkpoint = log->next_checkpoint;
-	next_cp_seq = log->next_cp_seq;
+	next_checkpoint = r5c_calculate_new_cp(conf);
 	spin_unlock_irq(&log->io_list_lock);
 
 	BUG_ON(reclaimable < 0);
@@ -941,7 +1122,7 @@ static void r5l_do_reclaim(struct r5l_log *log)
 
 	mutex_lock(&log->io_mutex);
 	log->last_checkpoint = next_checkpoint;
-	log->last_cp_seq = next_cp_seq;
+	r5c_update_log_state(log);
 	mutex_unlock(&log->io_mutex);
 
 	r5l_run_no_space_stripes(log);
@@ -955,6 +1136,7 @@ static void r5l_reclaim_thread(struct md_thread *thread)
 
 	if (!log)
 		return;
+	r5c_do_reclaim(conf);
 	r5l_do_reclaim(log);
 }
 
@@ -963,6 +1145,8 @@ void r5l_wake_reclaim(struct r5l_log *log, sector_t space)
 	unsigned long target;
 	unsigned long new = (unsigned long)space; /* overflow in theory */
 
+	if (!log)
+		return;
 	do {
 		target = log->reclaim_target;
 		if (new < target)
@@ -990,7 +1174,7 @@ void r5l_quiesce(struct r5l_log *log, int state)
 		/* make sure r5l_write_super_and_discard_space exits */
 		mddev = log->rdev->mddev;
 		wake_up(&mddev->sb_wait);
-		r5l_wake_reclaim(log, -1L);
+		r5l_wake_reclaim(log, MaxSector);
 		md_unregister_thread(&log->reclaim_thread);
 		r5l_do_reclaim(log);
 	}
@@ -1271,6 +1455,67 @@ static void r5l_write_super(struct r5l_log *log, sector_t cp)
 	set_bit(MD_CHANGE_DEVS, &mddev->flags);
 }
 
+/*
+ * r5c_flush_stripe will move stripe from cached list to handle_list
+ *
+ * must hold conf->device_lock
+ */
+static void r5c_flush_stripe(struct r5conf *conf, struct stripe_head *sh)
+{
+	BUG_ON(list_empty(&sh->lru));
+
+	if (!test_bit(STRIPE_R5C_FROZEN, &sh->state))
+		r5c_freeze_stripe_for_reclaim(sh);
+	if (!test_and_set_bit(STRIPE_HANDLE, &sh->state))
+		atomic_inc(&conf->active_stripes);
+	clear_bit(STRIPE_DELAYED, &sh->state);
+	clear_bit(STRIPE_BIT_DELAY, &sh->state);
+
+	list_del_init(&sh->lru);
+	atomic_inc(&sh->count);
+	raid5_release_stripe(sh);
+}
+
+/*
+ * if num <= 0, flush all stripes
+ * if num > 0, flush at most num stripes
+ */
+int r5c_flush_cache(struct r5conf *conf, int num)
+{
+	int count = 0;
+	struct stripe_head *sh, *next;
+
+	assert_spin_locked(&conf->device_lock);
+	if (!conf->log)
+		return 0;
+
+	list_for_each_entry_safe(sh, next, &conf->r5c_full_stripe_list, lru) {
+		r5c_flush_stripe(conf, sh);
+		count++;
+		if (num > 0 && count >= num && count >=
+		    R5C_FULL_STRIPE_FLUSH_BATCH)
+			return count;
+	}
+
+	list_for_each_entry_safe(sh, next,
+				 &conf->r5c_partial_stripe_list, lru) {
+		r5c_flush_stripe(conf, sh);
+		count++;
+		if (num > 0 && count == num)
+			return count;
+	}
+
+	if (num <= 0) {
+		list_for_each_entry_safe(sh, next, &conf->delayed_list, lru) {
+			if (test_bit(STRIPE_R5C_PARTIAL_STRIPE, &sh->state) ||
+			    test_bit(STRIPE_R5C_FULL_STRIPE, &sh->state))
+				r5c_flush_stripe(conf, sh);
+		}
+		r5l_run_no_space_stripes(conf->log);
+	}
+	return count;
+}
+
 int r5c_handle_stripe_dirtying(struct r5conf *conf,
 			       struct stripe_head *sh,
 			       struct stripe_head_state *s,
@@ -1327,6 +1572,7 @@ void r5c_handle_stripe_written(struct r5conf *conf,
 {
 	int i;
 	int do_wakeup = 0;
+	unsigned long flags;
 
 	if (!test_and_clear_bit(STRIPE_R5C_WRITTEN, &sh->state))
 		return;
@@ -1349,12 +1595,22 @@ void r5c_handle_stripe_written(struct r5conf *conf,
 
 	if (do_wakeup)
 		wake_up(&conf->wait_for_overlap);
+
+	if (conf->log->r5c_state == R5C_STATE_WRITE_THROUGH)
+		return;
+
+	spin_lock_irqsave(&conf->log->stripe_in_cache_lock, flags);
+	list_del_init(&sh->r5c);
+	spin_unlock_irqrestore(&conf->log->stripe_in_cache_lock, flags);
+	sh->log_start = MaxSector;
+	atomic_dec(&conf->log->stripe_in_cache_count);
 }
 
 int
 r5c_cache_data(struct r5l_log *log, struct stripe_head *sh,
 	       struct stripe_head_state *s)
 {
+	struct r5conf *conf = sh->raid_conf;
 	int pages;
 	int reserve;
 	int i;
@@ -1387,25 +1643,71 @@ r5c_cache_data(struct r5l_log *log, struct stripe_head *sh,
 	mutex_lock(&log->io_mutex);
 	/* meta + data */
 	reserve = (1 + pages) << (PAGE_SHIFT - 9);
-	if (!r5l_has_free_space(log, reserve)) {
-		spin_lock(&log->no_space_stripes_lock);
-		list_add_tail(&sh->log_list, &log->no_space_stripes);
-		spin_unlock(&log->no_space_stripes_lock);
 
-		r5l_wake_reclaim(log, reserve);
-	} else {
-		ret = r5l_log_stripe(log, sh, pages, 0);
-		if (ret) {
-			spin_lock_irq(&log->io_list_lock);
-			list_add_tail(&sh->log_list, &log->no_mem_stripes);
-			spin_unlock_irq(&log->io_list_lock);
+	if (test_bit(R5C_LOG_CRITICAL, &conf->cache_state)) {
+		/* if log space critical, only process data already cached */
+		if (list_empty(&sh->r5c)) {
+			spin_lock(&log->no_space_stripes_lock);
+			list_add_tail(&sh->log_list, &log->no_space_stripes);
+			spin_unlock(&log->no_space_stripes_lock);
+			mutex_unlock(&log->io_mutex);
+			return -ENOSPC;
 		}
 	}
+	/*
+	 * r5cache reserves enough log space for reclaim. If there is not
+	 * enough space to process, there must be a bug in reclaim
+	 */
+	if (!r5l_has_free_space(log, reserve))
+		BUG();
+	ret = r5l_log_stripe(log, sh, pages, 0);
+	if (ret) {
+		spin_lock_irq(&log->io_list_lock);
+		list_add_tail(&sh->log_list, &log->no_mem_stripes);
+		spin_unlock_irq(&log->io_list_lock);
+	}
 
 	mutex_unlock(&log->io_mutex);
 	return 0;
 }
 
+void r5c_do_reclaim(struct r5conf *conf)
+{
+	struct r5l_log *log = conf->log;
+	struct stripe_head *sh, *next;
+	int count = 0;
+	unsigned long flags;
+	sector_t last_checkpoint;
+
+	if (!r5c_is_writeback(log))
+		return;
+
+	/* flush all full stripes */
+	spin_lock_irqsave(&conf->device_lock, flags);
+	list_for_each_entry_safe(sh, next, &conf->r5c_full_stripe_list, lru)
+		r5c_flush_stripe(conf, sh);
+	spin_unlock_irqrestore(&conf->device_lock, flags);
+
+	/* if log space is tight, start flushing data near last_checkpoint */
+	if (test_bit(R5C_LOG_TIGHT, &conf->cache_state)) {
+		spin_lock_irqsave(&log->stripe_in_cache_lock, flags);
+		spin_lock(&conf->device_lock);
+		last_checkpoint = (list_first_entry(&log->stripe_in_cache_list,
+						    struct stripe_head, r5c))->log_start;
+		list_for_each_entry(sh, &log->stripe_in_cache_list, r5c) {
+			if (!list_empty(&sh->lru)) {
+				r5c_flush_stripe(conf, sh);
+				count++;
+			}
+			if (count >= R5C_RECLAIM_STRIPE_GROUP)
+				break;
+		}
+		spin_unlock(&conf->device_lock);
+		spin_unlock_irqrestore(&log->stripe_in_cache_lock, flags);
+	}
+	md_wakeup_thread(conf->mddev->thread);
+}
+
 static int r5l_load_log(struct r5l_log *log)
 {
 	struct md_rdev *rdev = log->rdev;
@@ -1463,6 +1765,9 @@ create:
 	if (log->max_free_space > RECLAIM_MAX_FREE_SPACE)
 		log->max_free_space = RECLAIM_MAX_FREE_SPACE;
 	log->last_checkpoint = cp;
+	mutex_lock(&log->io_mutex);
+	r5c_update_log_state(log);
+	mutex_unlock(&log->io_mutex);
 
 	__free_page(page);
 
@@ -1534,6 +1839,8 @@ int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
 						 log->rdev->mddev, "reclaim");
 	if (!log->reclaim_thread)
 		goto reclaim_thread;
+	log->reclaim_thread->timeout = R5C_RECLAIM_WAKEUP_INTERVAL;
+
 	init_waitqueue_head(&log->iounit_wait);
 
 	INIT_LIST_HEAD(&log->no_mem_stripes);
@@ -1542,6 +1849,9 @@ int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
 	spin_lock_init(&log->no_space_stripes_lock);
 
 	log->r5c_state = R5C_STATE_WRITE_THROUGH;
+	INIT_LIST_HEAD(&log->stripe_in_cache_list);
+	spin_lock_init(&log->stripe_in_cache_lock);
+	atomic_set(&log->stripe_in_cache_count, 0);
 
 	if (r5l_load_log(log))
 		goto error;
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 27fd183..5977d44 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -220,6 +220,11 @@ static void do_release_stripe(struct r5conf *conf, struct stripe_head *sh,
 {
 	BUG_ON(!list_empty(&sh->lru));
 	BUG_ON(atomic_read(&conf->active_stripes)==0);
+
+	/* When quiesce in r5c write back, make sure the stripe is handled*/
+	if (conf->quiesce && r5c_is_writeback(conf->log))
+		r5c_prepare_stripe_for_release_in_quiesce(sh);
+
 	if (test_bit(STRIPE_HANDLE, &sh->state)) {
 		if (test_bit(STRIPE_DELAYED, &sh->state) &&
 		    !test_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
@@ -256,6 +261,7 @@ static void do_release_stripe(struct r5conf *conf, struct stripe_head *sh,
 				if (test_and_clear_bit(STRIPE_R5C_PARTIAL_STRIPE, &sh->state))
 					atomic_dec(&conf->r5c_cached_partial_stripes);
 				list_add_tail(&sh->lru, &conf->r5c_full_stripe_list);
+				r5c_check_cached_full_stripe(conf);
 			} else {
 				/* partial stripe */
 				if (!test_and_set_bit(STRIPE_R5C_PARTIAL_STRIPE,
@@ -626,9 +632,12 @@ raid5_get_active_stripe(struct r5conf *conf, sector_t sector,
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
@@ -844,6 +853,7 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 	struct r5conf *conf = sh->raid_conf;
 	int i, disks = sh->disks;
 	struct stripe_head *head_sh = sh;
+	int ret;
 
 	might_sleep();
 
@@ -852,8 +862,10 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 		return;
 	}
 
-	if (r5l_write_stripe(conf->log, sh) == 0)
+	ret = r5l_write_stripe(conf->log, sh);
+	if (ret == 0 || ret == -ENOSPC)
 		return;
+
 	for (i = disks; i--; ) {
 		int op, op_flags = 0;
 		int replace_only = 0;
@@ -1983,8 +1995,10 @@ static struct stripe_head *alloc_stripe(struct kmem_cache *sc, gfp_t gfp,
 		spin_lock_init(&sh->batch_lock);
 		INIT_LIST_HEAD(&sh->batch_list);
 		INIT_LIST_HEAD(&sh->lru);
+		INIT_LIST_HEAD(&sh->r5c);
 		atomic_set(&sh->count, 1);
 		atomic_set(&sh->dev_in_cache, 0);
+		sh->log_start = MaxSector;
 		for (i = 0; i < disks; i++) {
 			struct r5dev *dev = &sh->dev[i];
 
@@ -4739,6 +4753,10 @@ static int raid5_congested(struct mddev *mddev, int bits)
 
 	if (test_bit(R5_INACTIVE_BLOCKED, &conf->cache_state))
 		return 1;
+
+	/* Also checks whether there is pressure on r5cache log space */
+	if (test_bit(R5C_LOG_CRITICAL, &conf->cache_state))
+		return 1;
 	if (conf->quiesce)
 		return 1;
 	if (atomic_read(&conf->empty_inactive_list_nr))
@@ -7704,6 +7722,7 @@ static void raid5_quiesce(struct mddev *mddev, int state)
 		/* '2' tells resync/reshape to pause so that all
 		 * active stripes can drain
 		 */
+		r5c_flush_cache(conf, 0);
 		conf->quiesce = 2;
 		wait_event_cmd(conf->wait_for_quiescent,
 				    atomic_read(&conf->active_stripes) == 0 &&
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index ac6d7c7..d17eed4 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -227,6 +227,8 @@ struct stripe_head {
 	struct r5l_io_unit	*log_io;
 	struct list_head	log_list;
 	atomic_t		dev_in_cache;
+	sector_t		log_start; /* first meta block on the journal */
+	struct list_head	r5c; /* for r5c_cache->stripe_in_cache */
 	/**
 	 * struct stripe_operations
 	 * @target - STRIPE_OP_COMPUTE_BLK target
@@ -521,6 +523,26 @@ struct r5worker_group {
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
+	R5C_LOG_TIGHT,		/* journal device space tight, need to
+				 * prioritize stripes at last_checkpoint
+				 */
+	R5C_LOG_CRITICAL,	/* journal device is running out of space,
+				 * only process stripes at last_checkpoint
+				 */
+};
+
 struct r5conf {
 	struct hlist_head	*stripe_hashtbl;
 	/* only protect corresponding hash list and inactive_list */
@@ -622,17 +644,6 @@ struct r5conf {
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
@@ -742,4 +753,10 @@ extern void r5c_handle_cached_data_endio(struct r5conf *conf,
 extern int r5c_cache_data(struct r5l_log *log, struct stripe_head *sh,
 			  struct stripe_head_state *s);
 extern void r5c_freeze_stripe_for_reclaim(struct stripe_head *sh);
+extern void r5c_prepare_stripe_for_release_in_quiesce(struct stripe_head *sh);
+extern void r5c_do_reclaim(struct r5conf *conf);
+extern int r5c_flush_cache(struct r5conf *conf, int num);
+extern void r5c_check_stripe_cache_usage(struct r5conf *conf);
+extern void r5c_check_cached_full_stripe(struct r5conf *conf);
+
 #endif
-- 
2.9.3

