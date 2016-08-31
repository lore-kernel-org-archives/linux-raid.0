From: Song Liu <songliubraving@fb.com>
Subject: [PATCH 3/5] r5cache: naive reclaim approach
Date: Wed, 31 Aug 2016 15:18:20 -0700
Message-ID: <1472681902-1172317-4-git-send-email-songliubraving@fb.com>
References: <1472681902-1172317-1-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1472681902-1172317-1-git-send-email-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.com, shli@fb.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

This patch adds a naive reclaim for r5c cache.

There are two limited resources, stripe cache and journal disk space.
For better performance, we priotize reclaim of stripes with more data
in cache. To free up more journal space, we free earliest data on
the journal.

In current implementation, reclaim decision is made in two places:
at the end of cached write, and from r5l_reclaim_thread.

At the end of every cached write, we check wthether we should reclaim
this stripe. Specifically, the stripe is reclaimed if:
 1. it is full stripe
 2. 50% of stripe cache space are in cached
 3. it is occupying large chunk of journal space

The reclaim thread (r5l_reclaim_thread) wakes up every 5 secounds. In
this thread, r5c_do_reclaim reclaims stripe cache space, while
r5l_do_reclaim reclaims journal space.

When resource is not limited, r5c_do_reclaim will do nothing.
Otherwise, r5c_do_reclaim walks through r5c_cached_list and freeze
up to R5C_RECLAIM_STRIPE_GROUP (set to 8) stripes.

r5c_cache keeps all data in cache (not fully committed to RAID) in
a list (stripe_in_cache). These stripes are in the order of their
first appearance on the journal. So the log tail (last_checkpoint)
should point to the journal_start of the first item in the list.

Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/raid5-cache.c | 167 ++++++++++++++++++++++++++++++++++++++++++-----
 drivers/md/raid5.c       |  14 +++-
 drivers/md/raid5.h       |   2 +
 3 files changed, 166 insertions(+), 17 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 78eeb6df..68f1470 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -34,6 +34,10 @@
 #define RECLAIM_MAX_FREE_SPACE (10 * 1024 * 1024 * 2) /* sector */
 #define RECLAIM_MAX_FREE_SPACE_SHIFT (2)
 
+/* wake up reclaim thread periodically */
+#define R5C_RECLAIM_WAKEUP_INTERVAL (5 * HZ)
+/* reclaim stripes in groups */
+#define R5C_RECLAIM_STRIPE_GROUP  8
 /*
  * We only need 2 bios per I/O unit to make progress, but ensure we
  * have a few more available to not get too tight.
@@ -109,6 +113,9 @@ struct r5l_log {
 
 	/* for r5c_cache */
 	enum r5c_state r5c_state;
+	struct list_head stripe_in_cache; /* all stripes in the cache, with
+					   * sh->log_start in order */
+	spinlock_t stripe_in_cache_lock;  /* lock for stripe_in_cache */
 };
 
 /*
@@ -462,6 +469,7 @@ static int r5l_log_stripe(struct r5l_log *log, struct stripe_head *sh,
 	int meta_size;
 	int ret;
 	struct r5l_io_unit *io;
+	unsigned long flags;
 
 	meta_size =
 		((sizeof(struct r5l_payload_data_parity) + sizeof(__le32))
@@ -505,6 +513,14 @@ static int r5l_log_stripe(struct r5l_log *log, struct stripe_head *sh,
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
 
@@ -705,15 +721,69 @@ static void __r5l_stripe_write_finished(struct r5l_io_unit *io)
 	wake_up(&log->iounit_wait);
 }
 
+/*
+ * Check whether we want to reclaim this stripe.
+ * Return true if the stripe should be freezed
+ *
+ * We would like to reclaim the stripe if
+ * 1. it is full stripe
+ * 2. 50% of stripe cache space are in cached
+ * 3. it is occupying large chunk of journal space
+ */
+static bool r5c_check_stripe_for_reclaim(struct stripe_head *sh,
+					 sector_t log_start)
+{
+	struct r5conf *conf = sh->raid_conf;
+	struct r5l_log *log = conf->log;
+	bool ret = false;
+
+	/* only check active stripe (STRIPE_ACTIVE) or
+	 * stripe in r5c_cached_list */
+	if (!test_bit(STRIPE_ACTIVE, &sh->state)) {
+		assert_spin_locked(&conf->device_lock);
+		WARN_ON(list_empty(&sh->r5c));
+	}
+
+	if (atomic_read(&sh->dev_in_cache) ==
+	    conf->raid_disks - conf->max_degraded) {
+		pr_debug("%s: freeze stripe for full stripe\n", __func__);
+		return true;
+	}
+
+	if (atomic_read(&conf->r5c_cached_stripes) * 2 >
+	    conf->min_nr_stripes) {
+		pr_debug("%s: freeze stripe for stripe cache\n", __func__);
+		return true;
+	}
+
+	/* TODO: do we need protection reading log->log_start? */
+	if (r5l_ring_distance(log, sh->log_start, log_start) >
+		   log->max_free_space) {
+		pr_debug("%s: freeze stripe for journal space\n", __func__);
+		ret = true;
+	}
+	return ret;
+}
+
 void r5l_stripe_write_finished(struct stripe_head *sh)
 {
+	struct r5conf *conf = sh->raid_conf;
+	struct r5l_log *log = conf->log;
 	struct r5l_io_unit *io;
+	sector_t log_start;
 
 	io = sh->log_io;
 	sh->log_io = NULL;
 
 	if (io && atomic_dec_and_test(&io->pending_stripe))
 		__r5l_stripe_write_finished(io);
+
+	mutex_lock(&log->io_mutex);
+	log_start = log->log_start;
+	mutex_unlock(&log->io_mutex);
+	if (!test_bit(STRIPE_R5C_FROZEN, &sh->state))
+		if (r5c_check_stripe_for_reclaim(sh, log_start))
+			r5c_freeze_stripe_for_reclaim(sh);
 }
 
 static void r5l_log_flush_endio(struct bio *bio)
@@ -817,6 +887,10 @@ static void r5l_write_super_and_discard_space(struct r5l_log *log,
 		blkdev_issue_discard(bdev, log->rdev->data_offset, end,
 				GFP_NOIO, 0);
 	}
+	mutex_lock(&log->io_mutex);
+	log->last_checkpoint = end;
+	log->last_cp_seq = log->next_cp_seq;
+	mutex_unlock(&log->io_mutex);
 }
 
 static void r5l_do_reclaim(struct r5l_log *log)
@@ -855,19 +929,30 @@ static void r5l_do_reclaim(struct r5l_log *log)
 	if (reclaimable == 0)
 		return;
 
-	/*
-	 * write_super will flush cache of each raid disk. We must write super
-	 * here, because the log area might be reused soon and we don't want to
-	 * confuse recovery
-	 */
-	r5l_write_super_and_discard_space(log, next_checkpoint);
+	r5l_run_no_space_stripes(log);
+}
 
-	mutex_lock(&log->io_mutex);
-	log->last_checkpoint = next_checkpoint;
-	log->last_cp_seq = next_cp_seq;
-	mutex_unlock(&log->io_mutex);
+static void r5c_update_super(struct r5conf *conf)
+{
+	struct stripe_head *sh;
+	struct r5l_log *log = conf->log;
+	sector_t end = MaxSector;
+	unsigned long flags;
 
-	r5l_run_no_space_stripes(log);
+	spin_lock_irqsave(&log->stripe_in_cache_lock, flags);
+	if (list_empty(&conf->log->stripe_in_cache)) {
+		/* all stripes flushed */
+		spin_unlock_irqrestore(&log->stripe_in_cache_lock, flags);
+		r5l_write_super_and_discard_space(log, log->next_checkpoint);
+		return;
+	}
+	sh = list_first_entry(&conf->log->stripe_in_cache,
+			      struct stripe_head, r5c);
+	end = sh->log_start;
+	spin_unlock_irqrestore(&log->stripe_in_cache_lock, flags);
+
+	if (end != log->last_checkpoint && end != MaxSector)
+		r5l_write_super_and_discard_space(log, end);
 }
 
 static void r5l_reclaim_thread(struct md_thread *thread)
@@ -878,7 +963,10 @@ static void r5l_reclaim_thread(struct md_thread *thread)
 
 	if (!log)
 		return;
+	r5c_do_reclaim(conf);
 	r5l_do_reclaim(log);
+	r5c_update_super(conf);
+	md_wakeup_thread(mddev->thread);
 }
 
 void r5l_wake_reclaim(struct r5l_log *log, sector_t space)
@@ -913,9 +1001,10 @@ void r5l_quiesce(struct r5l_log *log, int state)
 		/* make sure r5l_write_super_and_discard_space exits */
 		mddev = log->rdev->mddev;
 		wake_up(&mddev->sb_wait);
-		r5l_wake_reclaim(log, -1L);
+		r5l_wake_reclaim(log, MaxSector);
 		md_unregister_thread(&log->reclaim_thread);
 		r5l_do_reclaim(log);
+		r5c_update_super(log->rdev->mddev->private);
 	}
 }
 
@@ -1194,6 +1283,7 @@ static void r5l_write_super(struct r5l_log *log, sector_t cp)
 	set_bit(MD_CHANGE_DEVS, &mddev->flags);
 }
 
+
 static void r5c_flush_stripe(struct r5conf *conf, struct stripe_head *sh)
 {
 	list_del_init(&sh->lru);
@@ -1326,6 +1416,7 @@ void r5c_handle_stripe_written(struct r5conf *conf,
 			       struct stripe_head *sh) {
 	int i;
 	int do_wakeup = 0;
+	unsigned long flags;
 
 	if (test_and_clear_bit(STRIPE_R5C_WRITTEN, &sh->state)) {
 		WARN_ON(!test_bit(STRIPE_R5C_FROZEN, &sh->state));
@@ -1338,6 +1429,10 @@ void r5c_handle_stripe_written(struct r5conf *conf,
 			if (test_and_clear_bit(R5_Overlap, &sh->dev[i].flags))
 				do_wakeup = 1;
 		}
+		spin_lock_irqsave(&conf->log->stripe_in_cache_lock, flags);
+		list_del_init(&sh->r5c);
+		spin_unlock_irqrestore(&conf->log->stripe_in_cache_lock, flags);
+		sh->log_start = MaxSector;
 	}
 
 	if (do_wakeup)
@@ -1413,13 +1508,49 @@ void r5c_do_reclaim(struct r5conf *conf)
 {
 	struct stripe_head *sh, *next;
 	struct r5l_log *log = conf->log;
-
-	assert_spin_locked(&conf->device_lock);
+	int count = 0;
+	unsigned long flags;
+	bool skip_reclaim = true;
+	sector_t log_start;
 
 	if (!log)
 		return;
-	list_for_each_entry_safe(sh, next, &conf->r5c_cached_list, lru)
-		r5c_flush_stripe(conf, sh);
+	if (atomic_read(&conf->r5c_cached_stripes) +
+	    atomic_read(&conf->active_stripes) > conf->min_nr_stripes * 3 / 4)
+		skip_reclaim = false;
+	else {
+		struct list_head *l;
+
+		spin_lock_irqsave(&log->stripe_in_cache_lock, flags);
+		if (!list_empty(&log->stripe_in_cache)) {
+			l = log->stripe_in_cache.next;
+			sh = list_entry(l, struct stripe_head, r5c);
+			if (r5l_ring_distance(log, sh->log_start, log->log_start) >
+			    log->max_free_space)
+				skip_reclaim = false;
+		}
+		spin_unlock_irqrestore(&log->stripe_in_cache_lock, flags);
+	}
+	if (skip_reclaim)
+		return;
+
+	/* lock io_mutex and get log->log_start before holding device_lock*/
+	mutex_lock(&log->io_mutex);
+	log_start = log->log_start;
+	mutex_unlock(&log->io_mutex);
+
+	spin_lock_irqsave(&conf->device_lock, flags);
+	list_for_each_entry_safe(sh, next, &conf->r5c_cached_list, lru) {
+		if (r5c_check_stripe_for_reclaim(sh, log_start)) {
+			count++;
+			r5c_flush_stripe(conf, sh);
+		}
+		if (count >= R5C_RECLAIM_STRIPE_GROUP)
+			break;
+	}
+	spin_unlock_irqrestore(&conf->device_lock, flags);
+	if (test_bit(R5_INACTIVE_BLOCKED, &conf->cache_state))
+		wake_up(&conf->wait_for_stripe);
 }
 
 static int r5l_load_log(struct r5l_log *log)
@@ -1534,6 +1665,8 @@ int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
 						 log->rdev->mddev, "reclaim");
 	if (!log->reclaim_thread)
 		goto reclaim_thread;
+	log->reclaim_thread->timeout = R5C_RECLAIM_WAKEUP_INTERVAL;
+
 	init_waitqueue_head(&log->iounit_wait);
 
 	INIT_LIST_HEAD(&log->no_mem_stripes);
@@ -1543,6 +1676,8 @@ int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
 
 	/* flush full stripe */
 	log->r5c_state = R5C_STATE_WRITE_BACK;
+	INIT_LIST_HEAD(&log->stripe_in_cache);
+	spin_lock_init(&log->stripe_in_cache_lock);
 
 	if (r5l_load_log(log))
 		goto error;
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 7956d13..af6875b 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -691,6 +691,8 @@ raid5_get_active_stripe(struct r5conf *conf, sector_t sector,
 			if (!sh) {
 				set_bit(R5_INACTIVE_BLOCKED,
 					&conf->cache_state);
+				if (conf->log)
+					r5l_wake_reclaim(conf->log, 0);
 				wait_event_lock_irq(
 					conf->wait_for_stripe,
 					!list_empty(conf->inactive_list + hash) &&
@@ -729,6 +731,15 @@ raid5_get_active_stripe(struct r5conf *conf, sector_t sector,
 	} while (sh == NULL);
 
 	spin_unlock_irq(conf->hash_locks + hash);
+
+	if (conf->log &&
+	    (atomic_read(&conf->active_stripes) +
+	     atomic_read(&conf->r5c_cached_stripes) >
+	     conf->max_nr_stripes * 3 / 4)) {
+		set_bit(R5_INACTIVE_BLOCKED, &conf->cache_state);
+		r5l_wake_reclaim(conf->log, 0);
+	}
+
 	return sh;
 }
 
@@ -2036,8 +2047,10 @@ static struct stripe_head *alloc_stripe(struct kmem_cache *sc, gfp_t gfp,
 		spin_lock_init(&sh->batch_lock);
 		INIT_LIST_HEAD(&sh->batch_list);
 		INIT_LIST_HEAD(&sh->lru);
+		INIT_LIST_HEAD(&sh->r5c);
 		atomic_set(&sh->count, 1);
 		atomic_set(&sh->dev_in_cache, 0);
+		sh->log_start = MaxSector;
 		for (i = 0; i < disks; i++) {
 			struct r5dev *dev = &sh->dev[i];
 
@@ -6029,7 +6042,6 @@ static void raid5d(struct md_thread *thread)
 			md_check_recovery(mddev);
 			spin_lock_irq(&conf->device_lock);
 		}
-		r5c_do_reclaim(conf);
 	}
 	pr_debug("%d stripes handled\n", handled);
 
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index dbc128e..901fd41 100644
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
-- 
2.8.0.rc2

