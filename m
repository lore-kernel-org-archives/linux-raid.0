From: Song Liu <songliubraving@fb.com>
Subject: [RFC 5/5] r5cache: naive reclaim approach
Date: Thu, 26 May 2016 22:29:43 -0700
Message-ID: <1464326983-3798454-6-git-send-email-songliubraving@fb.com>
References: <1464326983-3798454-1-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1464326983-3798454-1-git-send-email-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@fb.com, nfbrown@novell.com, dan.j.williams@intel.com, hch@infradead.org, kernel-team@fb.com, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

This patch adds a naive reclaim for r5c cache.

There are two limited resources, stripe cache and journal disk space.
For better performance, we priotize reclaim of stripes with more data
in cache. To free up more journal space, we free earliest data on
the journal.

The reclaim thread (r5l_reclaim_thread) wakes up every 5 seconds. In
this thread, r5c_do_reclaim reclaims stripe cache space, while
r5l_do_reclaim reclaims journal space.

r5c_cache keeps all data in cache (not fully committed to RAID) in
a list (stripe_in_cache). These stripes are in the order of their
first appearence on the journal. So the log tail (last_checkpoint)
should point to the journal_start of the first item in the list.

Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/raid5-cache.c | 96 ++++++++++++++++++++++++++++++++++++++----------
 drivers/md/raid5.c       | 14 ++++++-
 drivers/md/raid5.h       |  2 +
 3 files changed, 91 insertions(+), 21 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 66a3cd5..272c109 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -34,6 +34,9 @@
 #define RECLAIM_MAX_FREE_SPACE (10 * 1024 * 1024 * 2) /* sector */
 #define RECLAIM_MAX_FREE_SPACE_SHIFT (2)
 
+/* wake up reclaim thread periodically */
+#define RECLAIM_WAKEUP_INTERVAL (5 * HZ)
+
 /*
  * We only need 2 bios per I/O unit to make progress, but ensure we
  * have a few more available to not get too tight.
@@ -52,6 +55,11 @@ struct r5c_cache {
 	int flush_threshold;		/* flush the stripe when flush_threshold buffers are dirty  */
 	int mode;			/* enum r5c_cache_mode */
 
+	struct list_head stripe_in_cache; /* all stripes in the cache, with sh->journal_start in order */
+	spinlock_t stripe_in_cache_lock;  /* lock for stripe_in_cache */
+
+	sector_t first_sector;		/* first useful data on journal */
+
 	/* read stats */
 	atomic64_t read_full_hits;	/* the whole chunk in cache */
 	atomic64_t read_partial_hits;	/* some pages of the chunk in cache */
@@ -165,6 +173,8 @@ static void init_r5c_cache(struct r5conf *conf, struct r5c_cache *cache)
 {
 	cache->flush_threshold = conf->raid_disks - conf->max_degraded;  /* full stripe */
 	cache->mode = R5C_MODE_WRITE_BACK;
+	INIT_LIST_HEAD(&cache->stripe_in_cache);
+	spin_lock_init(&cache->stripe_in_cache_lock);
 
 	atomic64_set(&cache->read_full_hits, 0);
 	atomic64_set(&cache->read_partial_hits, 0);
@@ -497,6 +507,7 @@ static int r5l_log_stripe(struct r5l_log *log, struct stripe_head *sh,
 	int meta_size;
 	int ret;
 	struct r5l_io_unit *io;
+	unsigned long flags;
 
 	meta_size =
 		((sizeof(struct r5l_payload_data_parity) + sizeof(__le32))
@@ -542,6 +553,16 @@ static int r5l_log_stripe(struct r5l_log *log, struct stripe_head *sh,
 	atomic_inc(&io->pending_stripe);
 	sh->log_io = io;
 
+	spin_lock_irqsave(&log->cache.stripe_in_cache_lock, flags);
+	spin_lock(&sh->stripe_lock);
+	if (sh->journal_start == -1L) {
+		BUG_ON(!list_empty(&sh->r5c));
+		sh->journal_start = log->next_checkpoint;
+		list_add_tail(&sh->r5c,
+			      &log->cache.stripe_in_cache);
+	}
+	spin_unlock(&sh->stripe_lock);
+	spin_unlock_irqrestore(&log->cache.stripe_in_cache_lock, flags);
 	return 0;
 }
 
@@ -863,6 +884,10 @@ static void r5l_write_super_and_discard_space(struct r5l_log *log,
 		blkdev_issue_discard(bdev, log->rdev->data_offset, end,
 				GFP_NOIO, 0);
 	}
+	mutex_lock(&log->io_mutex);
+	log->last_checkpoint = end;
+	log->last_cp_seq = log->next_cp_seq;
+	mutex_unlock(&log->io_mutex);
 }
 
 static void r5l_do_reclaim(struct r5l_log *log)
@@ -901,19 +926,32 @@ static void r5l_do_reclaim(struct r5l_log *log)
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
+	struct list_head *l;
+	struct stripe_head *sh;
+	struct r5l_log *log = conf->log;
+	sector_t end = -1L;
+	unsigned long flags;
 
-	r5l_run_no_space_stripes(log);
+	if (list_empty(&conf->log->cache.stripe_in_cache)) {
+		/* all stripes flushed */
+		r5l_write_super_and_discard_space(log, log->next_checkpoint);
+		return;
+	}
+	spin_lock_irqsave(&log->cache.stripe_in_cache_lock, flags);
+	l = conf->log->cache.stripe_in_cache.next;
+	sh = list_entry(l, struct stripe_head, r5c);
+	spin_lock(&sh->stripe_lock);
+	end = sh->journal_start;
+	spin_unlock(&sh->stripe_lock);
+	spin_unlock_irqrestore(&log->cache.stripe_in_cache_lock, flags);
+
+	if (end != log->last_checkpoint && end != -1L)
+		r5l_write_super_and_discard_space(log, sh->journal_start);
 }
 
 static void r5l_reclaim_thread(struct md_thread *thread)
@@ -924,12 +962,11 @@ static void r5l_reclaim_thread(struct md_thread *thread)
 
 	if (!log)
 		return;
-/*
-	spin_lock_irq(&conf->device_lock);
+
 	r5c_do_reclaim(conf);
-	spin_unlock_irq(&conf->device_lock);
-*/
 	r5l_do_reclaim(log);
+	r5c_update_super(conf);
+	md_wakeup_thread(mddev->thread);
 }
 
 void r5l_wake_reclaim(struct r5l_log *log, sector_t space)
@@ -973,6 +1010,7 @@ void r5l_quiesce(struct r5l_log *log, int state)
 		r5l_wake_reclaim(log, -1L);
 		md_unregister_thread(&log->reclaim_thread);
 		r5l_do_reclaim(log);
+		r5c_update_super(log->rdev->mddev->private);
 	}
 }
 
@@ -1627,6 +1665,7 @@ void r5c_handle_stripe_flush(struct r5conf *conf,
 			     int disks) {
 	int i;
 	int do_wakeup = 0;
+	unsigned long flags;
 
 	if (sh->r5c_state == R5C_STATE_PARITY_DONE) {
 		r5c_set_state(sh, R5C_STATE_INRAID);
@@ -1636,6 +1675,12 @@ void r5c_handle_stripe_flush(struct r5conf *conf,
 			if (test_and_clear_bit(R5_Overlap, &sh->dev[i].flags))
 				do_wakeup = 1;
 		}
+		spin_lock_irqsave(&conf->log->cache.stripe_in_cache_lock, flags);
+		list_del_init(&sh->r5c);
+		spin_unlock_irqrestore(&conf->log->cache.stripe_in_cache_lock, flags);
+		spin_lock_irqsave(&sh->stripe_lock, flags);
+		sh->journal_start = -1L;
+		spin_unlock_irqrestore(&sh->stripe_lock, flags);
 	}
 	if (do_wakeup)
 		wake_up(&conf->wait_for_overlap);
@@ -1717,6 +1762,9 @@ static void r5c_adjust_flush_threshold(struct r5conf *conf)
 	else if (atomic_read(&conf->r5c_cached_stripes) * 8 > conf->max_nr_stripes)
 		new_thres -= 1;
 
+	if (test_bit(R5_INACTIVE_BLOCKED, &conf->cache_state))
+		new_thres = 1;
+
 	if (new_thres >= 1)
 		log->cache.flush_threshold = new_thres;
 }
@@ -1725,16 +1773,23 @@ void r5c_do_reclaim(struct r5conf *conf)
 {
 	struct stripe_head *sh, *next;
 	struct r5l_log *log = conf->log;
-
-	assert_spin_locked(&conf->device_lock);
+	int count = 0;
+	unsigned long flags;
 
 	if (!log)
 		return;
 
+	spin_lock_irqsave(&conf->device_lock, flags);
 	r5c_adjust_flush_threshold(conf);
-	list_for_each_entry_safe(sh, next, &conf->r5c_cached_list, lru)
-		if (atomic_read(&sh->dev_in_cache) >= log->cache.flush_threshold)
+	list_for_each_entry_safe(sh, next, &conf->r5c_cached_list, lru) {
+		if (atomic_read(&sh->dev_in_cache) >= log->cache.flush_threshold) {
+			count ++;
 			r5c_flush_stripe(conf, sh);
+		}
+	}
+	spin_unlock_irqrestore(&conf->device_lock, flags);
+	if (test_bit(R5_INACTIVE_BLOCKED, &conf->cache_state))
+		wake_up(&conf->wait_for_overlap);
 }
 
 static int r5l_load_log(struct r5l_log *log)
@@ -1849,6 +1904,8 @@ int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
 						 log->rdev->mddev, "reclaim");
 	if (!log->reclaim_thread)
 		goto reclaim_thread;
+	log->reclaim_thread->timeout = RECLAIM_WAKEUP_INTERVAL;
+
 	init_waitqueue_head(&log->iounit_wait);
 
 	INIT_LIST_HEAD(&log->no_mem_stripes);
@@ -1857,7 +1914,6 @@ int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
 	spin_lock_init(&log->no_space_stripes_lock);
 
 	init_r5c_cache(conf, &log->cache);
-
 	if (r5l_load_log(log))
 		goto error;
 
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 127c5c2..3e2bdc5 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -636,6 +636,8 @@ raid5_get_active_stripe(struct r5conf *conf, sector_t sector,
 			if (!sh) {
 				set_bit(R5_INACTIVE_BLOCKED,
 					&conf->cache_state);
+				if (conf->log)
+					r5l_wake_reclaim(conf->log, 0);
 				wait_event_lock_irq(
 					conf->wait_for_stripe,
 					!list_empty(conf->inactive_list + hash) &&
@@ -670,6 +672,15 @@ raid5_get_active_stripe(struct r5conf *conf, sector_t sector,
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
 
@@ -1965,8 +1976,10 @@ static struct stripe_head *alloc_stripe(struct kmem_cache *sc, gfp_t gfp)
 		spin_lock_init(&sh->batch_lock);
 		INIT_LIST_HEAD(&sh->batch_list);
 		INIT_LIST_HEAD(&sh->lru);
+		INIT_LIST_HEAD(&sh->r5c);
 		atomic_set(&sh->count, 1);
 		atomic_set(&sh->dev_in_cache, 0);
+		sh->journal_start = -1L;
 	}
 	return sh;
 }
@@ -5965,7 +5978,6 @@ static void raid5d(struct md_thread *thread)
 			md_check_recovery(mddev);
 			spin_lock_irq(&conf->device_lock);
 		}
-		r5c_do_reclaim(conf);
 	}
 	pr_debug("%d stripes handled\n", handled);
 
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 78fcc6d..4fe06cc 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -237,6 +237,8 @@ struct stripe_head {
 	struct r5l_io_unit	*log_io;
 	struct list_head	log_list;
 	atomic_t		dev_in_cache;
+	sector_t		journal_start; /* first meta block on the journal */
+	struct list_head	r5c; /* for r5c_cache->stripe_in_cache */
 	/**
 	 * struct stripe_operations
 	 * @target - STRIPE_OP_COMPUTE_BLK target
-- 
2.8.0.rc2

