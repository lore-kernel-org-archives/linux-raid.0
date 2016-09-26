From: Song Liu <songliubraving@fb.com>
Subject: [PATCH v2 3/6] r5cache: reclaim support
Date: Mon, 26 Sep 2016 16:30:47 -0700
Message-ID: <20160926233050.3351081-4-songliubraving@fb.com>
References: <20160926233050.3351081-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160926233050.3351081-1-songliubraving@fb.com>
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

1-3 above are straightforward.

For 4, we added 2 flags to r5conf->cache_state: R5C_LOG_TIGHT and
R5C_LOG_CRITICAL. R5C_LOG_TIGHT is set when 2x max_free_space of
journal space is in-use; while R5C_LOG_CRITICAL is set when 3x
max_free_space of journal space is in-use. Where max_free_space
= min(1/4 journal space, 10GB).

r5c_cache keeps all data in cache (not fully committed to RAID) in
a list (stripe_in_cache). These stripes are in the order of their
first appearance on the journal. So the log tail (last_checkpoint)
should point to the journal_start of the first item in the list.

When R5C_LOG_TIGHT is set, r5l_reclaim_thread starts freezing
stripes at the head of stripe_in_cache. When R5C_LOG_CRITICAL is
set, the state machine only processes stripes at the head of
stripe_in_cache (other stripes are added to no_space_stripes in
r5c_cache_data and r5l_write_stripe).

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 drivers/md/raid5-cache.c | 313 +++++++++++++++++++++++++++++++++++++++--------
 drivers/md/raid5.c       |  31 +++--
 drivers/md/raid5.h       |  37 ++++--
 3 files changed, 313 insertions(+), 68 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 0a0b16a..75b70d8 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -28,8 +28,7 @@
 #define BLOCK_SECTORS (8)
 
 /*
- * reclaim runs every 1/4 disk size or 10G reclaimable space. This can prevent
- * recovery scans a very long log
+ * log->max_free_space is min(1/4 disk size, 10G reclaimable space)
  */
 #define RECLAIM_MAX_FREE_SPACE (10 * 1024 * 1024 * 2) /* sector */
 #define RECLAIM_MAX_FREE_SPACE_SHIFT (2)
@@ -116,6 +115,9 @@ struct r5l_log {
 
 	/* for r5c_cache */
 	enum r5c_state r5c_state;
+	struct list_head stripe_in_cache; /* all stripes in the cache, with
+					   * sh->log_start in order */
+	spinlock_t stripe_in_cache_lock;  /* lock for stripe_in_cache */
 };
 
 /*
@@ -180,6 +182,16 @@ static bool r5l_has_free_space(struct r5l_log *log, sector_t size)
 	return log->device_size > used_size + size;
 }
 
+static sector_t r5l_used_space(struct r5l_log *log)
+{
+	sector_t ret;
+
+	WARN_ON(!mutex_is_locked(&log->io_mutex));
+	ret = r5l_ring_distance(log, log->last_checkpoint,
+				log->log_start);
+	return ret;
+}
+
 static void __r5l_set_io_unit_state(struct r5l_io_unit *io,
 				    enum r5l_io_unit_state state)
 {
@@ -188,6 +200,56 @@ static void __r5l_set_io_unit_state(struct r5l_io_unit *io,
 	io->state = state;
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
+	if (!conf->log)
+		return;
+	spin_lock(&conf->device_lock);
+	if (r5c_total_cached_stripes(conf) > conf->max_nr_stripes * 3 / 4 ||
+	    atomic_read(&conf->empty_inactive_list_nr) > 0)
+		r5c_flush_cache(conf, R5C_RECLAIM_STRIPE_GROUP);
+	else if (r5c_total_cached_stripes(conf) >
+		 conf->max_nr_stripes * 1 / 2)
+		r5c_flush_cache(conf, 1);
+	spin_unlock(&conf->device_lock);
+}
+
+void r5c_check_cached_full_stripe(struct r5conf *conf)
+{
+	if (!conf->log)
+		return;
+	if (atomic_read(&conf->r5c_cached_full_stripes) >=
+	    R5C_FULL_STRIPE_FLUSH_BATCH)
+		r5l_wake_reclaim(conf->log, 0);
+}
+
+static void r5c_update_log_state(struct r5l_log *log)
+{
+	struct r5conf *conf = log->rdev->mddev->private;
+	sector_t used_space = r5l_used_space(log);
+
+	if (used_space > 3 * log->max_free_space) {
+		set_bit(R5C_LOG_CRITICAL, &conf->cache_state);
+		set_bit(R5C_LOG_TIGHT, &conf->cache_state);
+	} else if (used_space > 2 * log->max_free_space) {
+		clear_bit(R5C_LOG_CRITICAL, &conf->cache_state);
+		set_bit(R5C_LOG_TIGHT, &conf->cache_state);
+	} else if (used_space < log->max_free_space) {
+		clear_bit(R5C_LOG_TIGHT, &conf->cache_state);
+		clear_bit(R5C_LOG_CRITICAL, &conf->cache_state);
+	} else  /* max_free_space < used_space < 2 * max_free_space */
+		clear_bit(R5C_LOG_CRITICAL, &conf->cache_state);
+}
+
 /*
  * Freeze the stripe, thus send the stripe into reclaim path.
  *
@@ -198,10 +260,9 @@ void r5c_freeze_stripe_for_reclaim(struct stripe_head *sh)
 {
 	struct r5conf *conf = sh->raid_conf;
 
-	if (!conf->log)
+	if (!conf->log || test_bit(STRIPE_R5C_FROZEN, &sh->state))
 		return;
 
-	WARN_ON(test_bit(STRIPE_R5C_FROZEN, &sh->state));
 	set_bit(STRIPE_R5C_FROZEN, &sh->state);
 
 	if (!test_and_set_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
@@ -356,8 +417,11 @@ static struct bio *r5l_bio_alloc(struct r5l_log *log)
 
 static void r5_reserve_log_entry(struct r5l_log *log, struct r5l_io_unit *io)
 {
+	WARN_ON(!mutex_is_locked(&log->io_mutex));
+	WARN_ON(!r5l_has_free_space(log, BLOCK_SECTORS));
 	log->log_start = r5l_ring_add(log, log->log_start, BLOCK_SECTORS);
 
+	r5c_update_log_state(log);
 	/*
 	 * If we filled up the log device start from the beginning again,
 	 * which will require a new bio.
@@ -475,6 +539,7 @@ static int r5l_log_stripe(struct r5l_log *log, struct stripe_head *sh,
 	int meta_size;
 	int ret;
 	struct r5l_io_unit *io;
+	unsigned long flags;
 
 	meta_size =
 		((sizeof(struct r5l_payload_data_parity) + sizeof(__le32))
@@ -518,6 +583,14 @@ static int r5l_log_stripe(struct r5l_log *log, struct stripe_head *sh,
 	atomic_inc(&io->pending_stripe);
 	sh->log_io = io;
 
+	if (sh->log_start == MaxSector) {
+		BUG_ON(!list_empty(&sh->r5c));
+		sh->log_start = io->log_start;
+		spin_lock_irqsave(&log->stripe_in_cache_lock, flags);
+		list_add_tail(&sh->r5c,
+			      &log->stripe_in_cache);
+		spin_unlock_irqrestore(&log->stripe_in_cache_lock, flags);
+	}
 	return 0;
 }
 
@@ -527,6 +600,7 @@ static int r5l_log_stripe(struct r5l_log *log, struct stripe_head *sh,
  */
 int r5l_write_stripe(struct r5l_log *log, struct stripe_head *sh)
 {
+	struct r5conf *conf = sh->raid_conf;
 	int write_disks = 0;
 	int data_pages, parity_pages;
 	int meta_size;
@@ -590,19 +664,31 @@ int r5l_write_stripe(struct r5l_log *log, struct stripe_head *sh)
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
+	if (test_bit(R5C_LOG_CRITICAL, &conf->cache_state)) {
+		sector_t last_checkpoint;
+
+		spin_lock(&log->stripe_in_cache_lock);
+		last_checkpoint = (list_first_entry(&log->stripe_in_cache,
+						    struct stripe_head, r5c))->log_start;
+		spin_unlock(&log->stripe_in_cache_lock);
+		if (sh->log_start != last_checkpoint) {
+			spin_lock(&log->no_space_stripes_lock);
+			list_add_tail(&sh->log_list, &log->no_space_stripes);
+			spin_unlock(&log->no_space_stripes_lock);
+			mutex_unlock(&log->io_mutex);
+			return -ENOSPC;
+		} else 	if (!r5l_has_free_space(log, reserve)) {
+			WARN(1, "%s: run out of journal space\n", __func__);
+			BUG();
 		}
+		pr_debug("%s: write sh %lu to free log space\n", __func__, sh->sector);
+	}
+	ret = r5l_log_stripe(log, sh, data_pages, parity_pages);
+	if (ret) {
+		spin_lock_irq(&log->io_list_lock);
+		list_add_tail(&sh->log_list, &log->no_mem_stripes);
+		spin_unlock_irq(&log->io_list_lock);
 	}
 
 	mutex_unlock(&log->io_mutex);
@@ -639,12 +725,17 @@ int r5l_handle_flush_request(struct r5l_log *log, struct bio *bio)
 /* This will run after log space is reclaimed */
 static void r5l_run_no_space_stripes(struct r5l_log *log)
 {
-	struct stripe_head *sh;
+	struct r5conf *conf = log->rdev->mddev->private;
+	struct stripe_head *sh, *next;
+	sector_t last_checkpoint;
 
 	spin_lock(&log->no_space_stripes_lock);
-	while (!list_empty(&log->no_space_stripes)) {
-		sh = list_first_entry(&log->no_space_stripes,
-				      struct stripe_head, log_list);
+	last_checkpoint = (list_first_entry(&log->stripe_in_cache,
+					    struct stripe_head, r5c))->log_start;
+	list_for_each_entry_safe(sh, next, &log->no_space_stripes, log_list) {
+		if (test_bit(R5C_LOG_CRITICAL, &conf->cache_state) &&
+		    sh->log_start != last_checkpoint)
+			continue;
 		list_del_init(&sh->log_list);
 		set_bit(STRIPE_HANDLE, &sh->state);
 		raid5_release_stripe(sh);
@@ -652,10 +743,32 @@ static void r5l_run_no_space_stripes(struct r5l_log *log)
 	spin_unlock(&log->no_space_stripes_lock);
 }
 
+static sector_t r5c_calculate_last_cp(struct r5conf *conf)
+{
+	struct stripe_head *sh;
+	struct r5l_log *log = conf->log;
+	sector_t end = MaxSector;
+	unsigned long flags;
+
+	spin_lock_irqsave(&log->stripe_in_cache_lock, flags);
+	if (list_empty(&conf->log->stripe_in_cache)) {
+		/* all stripes flushed */
+		spin_unlock_irqrestore(&log->stripe_in_cache_lock, flags);
+		return log->next_checkpoint;
+	}
+	sh = list_first_entry(&conf->log->stripe_in_cache,
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
+				 r5c_calculate_last_cp(conf));
 }
 
 static void r5l_run_no_mem_stripe(struct r5l_log *log)
@@ -830,14 +943,21 @@ static void r5l_write_super_and_discard_space(struct r5l_log *log,
 		blkdev_issue_discard(bdev, log->rdev->data_offset, end,
 				GFP_NOIO, 0);
 	}
+	mutex_lock(&log->io_mutex);
+	log->last_checkpoint = end;
+	r5c_update_log_state(log);
+	pr_debug("%s: set last_checkpoint = %lu\n", __func__, end);
+
+	log->last_cp_seq = log->next_cp_seq;
+	mutex_unlock(&log->io_mutex);
 }
 
 static void r5l_do_reclaim(struct r5l_log *log)
 {
+	struct r5conf *conf = log->rdev->mddev->private;
 	sector_t reclaim_target = xchg(&log->reclaim_target, 0);
 	sector_t reclaimable;
 	sector_t next_checkpoint;
-	u64 next_cp_seq;
 
 	spin_lock_irq(&log->io_list_lock);
 	/*
@@ -860,14 +980,12 @@ static void r5l_do_reclaim(struct r5l_log *log)
 				    log->io_list_lock);
 	}
 
-	next_checkpoint = log->next_checkpoint;
-	next_cp_seq = log->next_cp_seq;
+	next_checkpoint = r5c_calculate_last_cp(conf);
 	spin_unlock_irq(&log->io_list_lock);
 
 	BUG_ON(reclaimable < 0);
 	if (reclaimable == 0)
 		return;
-
 	/*
 	 * write_super will flush cache of each raid disk. We must write super
 	 * here, because the log area might be reused soon and we don't want to
@@ -877,10 +995,7 @@ static void r5l_do_reclaim(struct r5l_log *log)
 
 	mutex_lock(&log->io_mutex);
 	log->last_checkpoint = next_checkpoint;
-	log->last_cp_seq = next_cp_seq;
 	mutex_unlock(&log->io_mutex);
-
-	r5l_run_no_space_stripes(log);
 }
 
 static void r5l_reclaim_thread(struct md_thread *thread)
@@ -891,7 +1006,9 @@ static void r5l_reclaim_thread(struct md_thread *thread)
 
 	if (!log)
 		return;
+	r5c_do_reclaim(conf);
 	r5l_do_reclaim(log);
+	md_wakeup_thread(mddev->thread);
 }
 
 void r5l_wake_reclaim(struct r5l_log *log, sector_t space)
@@ -899,6 +1016,8 @@ void r5l_wake_reclaim(struct r5l_log *log, sector_t space)
 	unsigned long target;
 	unsigned long new = (unsigned long)space; /* overflow in theory */
 
+	if (!log)
+		return;
 	do {
 		target = log->reclaim_target;
 		if (new < target)
@@ -926,7 +1045,7 @@ void r5l_quiesce(struct r5l_log *log, int state)
 		/* make sure r5l_write_super_and_discard_space exits */
 		mddev = log->rdev->mddev;
 		wake_up(&mddev->sb_wait);
-		r5l_wake_reclaim(log, -1L);
+		r5l_wake_reclaim(log, MaxSector);
 		md_unregister_thread(&log->reclaim_thread);
 		r5l_do_reclaim(log);
 	}
@@ -1207,14 +1326,39 @@ static void r5l_write_super(struct r5l_log *log, sector_t cp)
 	set_bit(MD_CHANGE_DEVS, &mddev->flags);
 }
 
-static void r5c_flush_stripe(struct r5conf *conf, struct stripe_head *sh)
+/*
+ * r5c_flush_cache will move stripe from cached list to handle_list or
+ * r5c_priority_list
+ *
+ * return 1 if the stripe is moved, and 0 if the stripe is not moved
+ * must hold conf->device_lock
+ */
+static int r5c_flush_stripe(struct r5conf *conf, struct stripe_head *sh,
+			    bool priority)
 {
-	list_del_init(&sh->lru);
+	BUG_ON(list_empty(&sh->lru));
+
+	BUG_ON(test_bit(STRIPE_R5C_PRIORITY, &sh->state) &&
+	       !test_bit(STRIPE_HANDLE, &sh->state));
+
+	if (test_bit(STRIPE_R5C_PRIORITY, &sh->state))
+		return 0;
+	if (test_bit(STRIPE_HANDLE, &sh->state) && !priority)
+		return 0;
+
 	r5c_freeze_stripe_for_reclaim(sh);
-	atomic_inc(&conf->active_stripes);
+	if (!test_and_set_bit(STRIPE_HANDLE, &sh->state)) {
+		atomic_inc(&conf->active_stripes);
+	}
+	clear_bit(STRIPE_DELAYED, &sh->state);
+	clear_bit(STRIPE_BIT_DELAY, &sh->state);
+	if (priority)
+		set_bit(STRIPE_R5C_PRIORITY, &sh->state);
+
+	list_del_init(&sh->lru);
 	atomic_inc(&sh->count);
-	set_bit(STRIPE_HANDLE, &sh->state);
 	raid5_release_stripe(sh);
+	return 1;
 }
 
 /* if num <= 0, flush all stripes
@@ -1228,20 +1372,28 @@ int r5c_flush_cache(struct r5conf *conf, int num)
 	assert_spin_locked(&conf->device_lock);
 	if (!conf->log)
 		return 0;
+
 	list_for_each_entry_safe(sh, next, &conf->r5c_full_stripe_list, lru) {
-		r5c_flush_stripe(conf, sh);
-		count++;
+		count += r5c_flush_stripe(conf, sh, false);
 		if (num > 0 && count >= num && count >=
 		    R5C_FULL_STRIPE_FLUSH_BATCH)
 			return count;
 	}
 
 	list_for_each_entry_safe(sh, next, &conf->r5c_partial_stripe_list, lru) {
-		r5c_flush_stripe(conf, sh);
-		count++;
+		count += r5c_flush_stripe(conf, sh, false);
 		if (num > 0 && count == num)
 			return count;
 	}
+
+	if (num <= 0) {
+		list_for_each_entry_safe(sh, next, &conf->delayed_list, lru) {
+			if (test_bit(STRIPE_R5C_PARTIAL_STRIPE, &sh->state) ||
+			    test_bit(STRIPE_R5C_FULL_STRIPE, &sh->state))
+				r5c_flush_stripe(conf, sh, false);
+		}
+		r5l_run_no_space_stripes(conf->log);
+	}
 	return count;
 }
 
@@ -1349,6 +1501,7 @@ void r5c_handle_stripe_written(struct r5conf *conf,
 			       struct stripe_head *sh) {
 	int i;
 	int do_wakeup = 0;
+	unsigned long flags;
 
 	if (test_and_clear_bit(STRIPE_R5C_WRITTEN, &sh->state)) {
 		WARN_ON(!test_bit(STRIPE_R5C_FROZEN, &sh->state));
@@ -1361,6 +1514,11 @@ void r5c_handle_stripe_written(struct r5conf *conf,
 			if (test_and_clear_bit(R5_Overlap, &sh->dev[i].flags))
 				do_wakeup = 1;
 		}
+		spin_lock_irqsave(&conf->log->stripe_in_cache_lock, flags);
+		list_del_init(&sh->r5c);
+		spin_unlock_irqrestore(&conf->log->stripe_in_cache_lock, flags);
+		sh->log_start = MaxSector;
+		clear_bit(STRIPE_R5C_PRIORITY, &sh->state);
 	}
 
 	if (do_wakeup)
@@ -1371,6 +1529,7 @@ int
 r5c_cache_data(struct r5l_log *log, struct stripe_head *sh,
 	       struct stripe_head_state *s)
 {
+	struct r5conf *conf = sh->raid_conf;
 	int pages;
 	int meta_size;
 	int reserve;
@@ -1413,19 +1572,33 @@ r5c_cache_data(struct r5l_log *log, struct stripe_head *sh,
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
+		sector_t last_checkpoint;
+
+		spin_lock(&log->stripe_in_cache_lock);
+		last_checkpoint = (list_first_entry(&log->stripe_in_cache,
+						    struct stripe_head, r5c))->log_start;
+		spin_unlock(&log->stripe_in_cache_lock);
+		if (sh->log_start != last_checkpoint) {
+			spin_lock(&log->no_space_stripes_lock);
+			list_add_tail(&sh->log_list, &log->no_space_stripes);
+			spin_unlock(&log->no_space_stripes_lock);
+
+			mutex_unlock(&log->io_mutex);
+			return -ENOSPC;
 		}
+		pr_debug("%s: write sh %lu to free log space\n", __func__, sh->sector);
+	}
+	if (!r5l_has_free_space(log, reserve)) {
+		pr_err("%s: cannot reserve space %d\n", __func__, reserve);
+		BUG();
+	}
+	ret = r5l_log_stripe(log, sh, pages, 0);
+	if (ret) {
+		spin_lock_irq(&log->io_list_lock);
+		list_add_tail(&sh->log_list, &log->no_mem_stripes);
+		spin_unlock_irq(&log->io_list_lock);
 	}
 
 	mutex_unlock(&log->io_mutex);
@@ -1435,12 +1608,45 @@ r5c_cache_data(struct r5l_log *log, struct stripe_head *sh,
 void r5c_do_reclaim(struct r5conf *conf)
 {
 	struct r5l_log *log = conf->log;
-
-	assert_spin_locked(&conf->device_lock);
+	struct stripe_head *sh, *next;
+	int count = 0;
+	unsigned long flags;
+	sector_t last_checkpoint;
 
 	if (!log)
 		return;
-	r5c_flush_cache(conf, 0);
+
+	if (!test_bit(R5C_LOG_CRITICAL, &conf->cache_state)) {
+		/* flush all full stripes */
+		spin_lock_irqsave(&conf->device_lock, flags);
+		list_for_each_entry_safe(sh, next, &conf->r5c_full_stripe_list, lru)
+			r5c_flush_stripe(conf, sh, false);
+		spin_unlock_irqrestore(&conf->device_lock, flags);
+	}
+
+	if (test_bit(R5C_LOG_TIGHT, &conf->cache_state)) {
+		spin_lock_irqsave(&log->stripe_in_cache_lock, flags);
+		spin_lock(&conf->device_lock);
+		last_checkpoint = (list_first_entry(&log->stripe_in_cache,
+						    struct stripe_head, r5c))->log_start;
+		list_for_each_entry(sh, &log->stripe_in_cache, r5c) {
+			if (sh->log_start == last_checkpoint) {
+				if (!list_empty(&sh->lru))
+					r5c_flush_stripe(conf, sh, true);
+			} else
+				break;
+		}
+		spin_unlock(&conf->device_lock);
+		spin_unlock_irqrestore(&log->stripe_in_cache_lock, flags);
+		pr_debug("%s: flushed %d stripes for log space\n", __func__, count);
+	} else if (test_bit(R5_INACTIVE_BLOCKED, &conf->cache_state)) {
+		spin_lock_irqsave(&conf->device_lock, flags);
+		r5c_flush_cache(conf, R5C_RECLAIM_STRIPE_GROUP);
+		spin_unlock_irqrestore(&conf->device_lock, flags);
+	}
+	wake_up(&conf->wait_for_stripe);
+	md_wakeup_thread(conf->mddev->thread);
+	r5l_run_no_space_stripes(log);
 }
 
 static int r5l_load_log(struct r5l_log *log)
@@ -1500,6 +1706,9 @@ create:
 	if (log->max_free_space > RECLAIM_MAX_FREE_SPACE)
 		log->max_free_space = RECLAIM_MAX_FREE_SPACE;
 	log->last_checkpoint = cp;
+	mutex_lock(&log->io_mutex);
+	r5c_update_log_state(log);
+	mutex_unlock(&log->io_mutex);
 
 	__free_page(page);
 
@@ -1555,6 +1764,8 @@ int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
 						 log->rdev->mddev, "reclaim");
 	if (!log->reclaim_thread)
 		goto reclaim_thread;
+	log->reclaim_thread->timeout = R5C_RECLAIM_WAKEUP_INTERVAL;
+
 	init_waitqueue_head(&log->iounit_wait);
 
 	INIT_LIST_HEAD(&log->no_mem_stripes);
@@ -1564,6 +1775,8 @@ int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
 
 	/* flush full stripe */
 	log->r5c_state = R5C_STATE_WRITE_BACK;
+	INIT_LIST_HEAD(&log->stripe_in_cache);
+	spin_lock_init(&log->stripe_in_cache_lock);
 
 	if (r5l_load_log(log))
 		goto error;
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index cc4ac1d..a3d26ec 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -301,7 +301,9 @@ static void do_release_stripe(struct r5conf *conf, struct stripe_head *sh,
 		else {
 			clear_bit(STRIPE_DELAYED, &sh->state);
 			clear_bit(STRIPE_BIT_DELAY, &sh->state);
-			if (conf->worker_cnt_per_group == 0) {
+			if (test_bit(STRIPE_R5C_PRIORITY, &sh->state))
+				list_add_tail(&sh->lru, &conf->r5c_priority_list);
+			else if (conf->worker_cnt_per_group == 0) {
 				list_add_tail(&sh->lru, &conf->handle_list);
 			} else {
 				raid5_wakeup_stripe_thread(sh);
@@ -327,6 +329,7 @@ static void do_release_stripe(struct r5conf *conf, struct stripe_head *sh,
 				if (test_and_clear_bit(STRIPE_R5C_PARTIAL_STRIPE, &sh->state))
 					atomic_dec(&conf->r5c_cached_partial_stripes);
 				list_add_tail(&sh->lru, &conf->r5c_full_stripe_list);
+				r5c_check_cached_full_stripe(conf);
 			} else {
 				/* not full stripe */
 				if (!test_and_set_bit(STRIPE_R5C_PARTIAL_STRIPE,
@@ -697,9 +700,14 @@ raid5_get_active_stripe(struct r5conf *conf, sector_t sector,
 			}
 			if (noblock && sh == NULL)
 				break;
+
+			r5c_check_stripe_cache_usage(conf);
 			if (!sh) {
+				unsigned long before_jiffies;
 				set_bit(R5_INACTIVE_BLOCKED,
 					&conf->cache_state);
+				r5l_wake_reclaim(conf->log, 0);
+				before_jiffies = jiffies;
 				wait_event_lock_irq(
 					conf->wait_for_stripe,
 					!list_empty(conf->inactive_list + hash) &&
@@ -708,6 +716,9 @@ raid5_get_active_stripe(struct r5conf *conf, sector_t sector,
 					 || !test_bit(R5_INACTIVE_BLOCKED,
 						      &conf->cache_state)),
 					*(conf->hash_locks + hash));
+				before_jiffies = jiffies - before_jiffies;
+				if (before_jiffies > 20)
+					pr_debug("%s: wait for sh takes %lu jiffies\n", __func__, before_jiffies);
 				clear_bit(R5_INACTIVE_BLOCKED,
 					  &conf->cache_state);
 			} else {
@@ -915,18 +926,20 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 	struct r5conf *conf = sh->raid_conf;
 	int i, disks = sh->disks;
 	struct stripe_head *head_sh = sh;
+	int ret;
 
 	might_sleep();
 
 	if (s->to_cache) {
-		if (r5c_cache_data(conf->log, sh, s) == 0)
+		ret = r5c_cache_data(conf->log, sh, s);
+		if (ret == 0 || ret == -ENOSPC)
 			return;
-		/* array is too big that meta data size > PAGE_SIZE  */
-		r5c_freeze_stripe_for_reclaim(sh);
 	}
 
-	if (r5l_write_stripe(conf->log, sh) == 0)
+	ret = r5l_write_stripe(conf->log, sh);
+	if (ret == 0 || ret == -ENOSPC)
 		return;
+
 	for (i = disks; i--; ) {
 		int op, op_flags = 0;
 		int replace_only = 0;
@@ -2045,8 +2058,10 @@ static struct stripe_head *alloc_stripe(struct kmem_cache *sc, gfp_t gfp,
 		spin_lock_init(&sh->batch_lock);
 		INIT_LIST_HEAD(&sh->batch_list);
 		INIT_LIST_HEAD(&sh->lru);
+		INIT_LIST_HEAD(&sh->r5c);
 		atomic_set(&sh->count, 1);
 		atomic_set(&sh->dev_in_cache, 0);
+		sh->log_start = MaxSector;
 		for (i = 0; i < disks; i++) {
 			struct r5dev *dev = &sh->dev[i];
 
@@ -5057,7 +5072,9 @@ static struct stripe_head *__get_priority_stripe(struct r5conf *conf, int group)
 	struct list_head *handle_list = NULL;
 	struct r5worker_group *wg = NULL;
 
-	if (conf->worker_cnt_per_group == 0) {
+	if (!list_empty(&conf->r5c_priority_list))
+		handle_list = &conf->r5c_priority_list;
+	else if (conf->worker_cnt_per_group == 0) {
 		handle_list = &conf->handle_list;
 	} else if (group != ANY_GROUP) {
 		handle_list = &conf->worker_groups[group].handle_list;
@@ -6049,7 +6066,6 @@ static void raid5d(struct md_thread *thread)
 			md_check_recovery(mddev);
 			spin_lock_irq(&conf->device_lock);
 		}
-		r5c_do_reclaim(conf);
 	}
 	pr_debug("%d stripes handled\n", handled);
 
@@ -6675,6 +6691,7 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 	init_waitqueue_head(&conf->wait_for_overlap);
 	INIT_LIST_HEAD(&conf->handle_list);
 	INIT_LIST_HEAD(&conf->hold_list);
+	INIT_LIST_HEAD(&conf->r5c_priority_list);
 	INIT_LIST_HEAD(&conf->delayed_list);
 	INIT_LIST_HEAD(&conf->bitmap_list);
 	bio_list_init(&conf->return_bi);
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 2ae027c..2d8222c 100644
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
@@ -356,6 +358,7 @@ enum {
 				 * in conf->r5c_full_stripe_list) */
 	STRIPE_R5C_FROZEN,	/* r5c_cache frozen and being written out */
 	STRIPE_R5C_WRITTEN,	/* ready for r5c_handle_stripe_written() */
+	STRIPE_R5C_PRIORITY,	/* high priority stripe for log reclaim */
 };
 
 #define STRIPE_EXPAND_SYNC_FLAGS \
@@ -442,6 +445,26 @@ struct r5worker_group {
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
@@ -480,6 +503,7 @@ struct r5conf {
 
 	struct list_head	handle_list; /* stripes needing handling */
 	struct list_head	hold_list; /* preread ready stripes */
+	struct list_head	r5c_priority_list; /* high priority stripes for reclaim */
 	struct list_head	delayed_list; /* stripes that have plugged requests */
 	struct list_head	bitmap_list; /* stripes delaying awaiting bitmap update */
 	struct bio		*retry_read_aligned; /* currently retrying aligned bios   */
@@ -543,17 +567,6 @@ struct r5conf {
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
@@ -665,5 +678,7 @@ extern void r5c_freeze_stripe_for_reclaim(struct stripe_head *sh);
 extern void r5c_do_reclaim(struct r5conf *conf);
 extern int r5c_flush_cache(struct r5conf *conf, int num);
 extern struct md_sysfs_entry r5c_state;
+extern void r5c_check_stripe_cache_usage(struct r5conf *conf);
+extern void r5c_check_cached_full_stripe(struct r5conf *conf);
 
 #endif
-- 
2.9.3

