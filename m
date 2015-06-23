From: Shaohua Li <shli@fb.com>
Subject: [PATCH V4 06/13] raid5: cache IO error handling
Date: Tue, 23 Jun 2015 14:37:56 -0700
Message-ID: <d034054ad3676a5ca6293631cb24a8fc79b1fa6a.1435094582.git.shli@fb.com>
References: <cover.1435094582.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cover.1435094582.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com, neilb@suse.de
List-Id: linux-raid.ids

Cache disk might have IO error, which makes it a single failure point.
To solve this issue. we allow the raid array enters bypass mode in IO
error. In this mode, raid array will dispatch IO to raid disks directly,
so the array can still run. Existing data in log disk isn't lost.  Since
all data which isn't flushed to raid disks is in memory, we don't read
log disk to read back the data. The IO error handling will just flush
the data to raid disks. In this way there is no risk we lose data, and
raid array is still available.

Of course if raid array enters bypass mode, we don't have protection of
write hole and lose cache speed up. System admin can always choose to
shutdown the array for safety.

IO error likely isn't permanent. So after some time, we will retry
caching. But if there are too many IO errors, we don't do retry any
more.

Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/raid5-cache.c | 114 +++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 111 insertions(+), 3 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 84fcb4d..c5de6dd 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -34,6 +34,10 @@
 #define RECLAIM_BATCH 16
 #define CHECKPOINT_TIMEOUT (5 * HZ)
 
+#define MAX_RETRY 10
+#define IOERR_RETRY_TIME (5 * 60 * HZ)
+#define MEMERR_RETRY_TIME (60 * HZ)
+
 typedef u64 r5blk_t; /* log blocks, could be 512B - 4k */
 
 /*
@@ -353,6 +357,13 @@ enum {
 	RECLAIM_FLUSH_ALL = 16, /* flush all data to raid */
 };
 
+/* cache error state */
+enum {
+	ERROR_NOERROR = 0,
+	ERROR_PREPARE = 1, /* Had an error, flushing cache to raid */
+	ERROR_FINISH = 2, /* Had an error, cache has no data */
+};
+
 #define PAGE_SECTOR_SHIFT (PAGE_SHIFT - 9)
 
 static inline struct r5c_cache *r5l_cache(struct r5l_log *log)
@@ -1546,6 +1557,37 @@ static bool r5c_freeze_stripe(struct r5c_cache *cache,
 	return true;
 }
 
+/*
+ * If IO error happens in log, we flush all data to raid disks. This is safe
+ * since all data which isn't flushed to raid disk is in memory pool. If we are
+ * in the process to flush data to raid disks, we stall incoming IO, as we
+ * can't dispatch it to raid disks right now (to avoid data corruption, for
+ * example, new IO write to stripe which is reclaiming). New IO will be
+ * dispatched to raid disks after all data is flushed to raid disks
+ * */
+static bool r5c_check_wait_error_mode(struct r5c_cache *cache)
+{
+	if (cache->error_state)
+		wait_event(cache->error_wait,
+			cache->error_state == ERROR_FINISH);
+	if (cache->next_retry_time &&
+	    time_before(cache->next_retry_time, jiffies))
+		md_wakeup_thread(cache->reclaim_thread);
+	return !!cache->error_state;
+}
+
+static void r5c_enter_error_mode(struct r5c_cache *cache, int error)
+{
+	if (cmpxchg(&cache->error_state, ERROR_NOERROR,
+	    ERROR_PREPARE) == ERROR_NOERROR) {
+		printk(KERN_ERR"md: %s caching has %s, enter bypass mode\n",
+			mdname(cache->mddev),
+			error == -ENOMEM ? "no memory" : "IO error");
+		cache->error_type = error;
+		r5c_wake_reclaimer(cache, RECLAIM_FLUSH_ALL);
+	}
+}
+
 static void r5c_bio_task_end(struct r5l_task *task, int error)
 {
 	struct r5c_io_range *range = task->private;
@@ -1596,7 +1638,10 @@ static void r5c_bio_task_end(struct r5l_task *task, int error)
 				RECLAIM_MEM_FULL);
 	}
 	r5c_unlock_stripe(cache, stripe, &flags2);
-
+	if (error) {
+		bio_list_add(&cache->retry_bio_list, orig_bio);
+		r5c_enter_error_mode(cache, -EIO);
+	}
 	spin_unlock_irqrestore(&cache->tree_lock, flags);
 
 	if (!error) {
@@ -1663,7 +1708,12 @@ static void r5c_bio_flush_task_end(struct r5l_task *task, int error)
 
 	kfree(task);
 
-	if (!error) {
+	if (error) {
+		spin_lock_irqsave(&cache->tree_lock, flags);
+		bio_list_add(&cache->retry_bio_list, orig_bio);
+		r5c_enter_error_mode(cache, -EIO);
+		spin_unlock_irqrestore(&cache->tree_lock, flags);
+	} else {
 		bio_endio(orig_bio, 0);
 		md_write_end(cache->mddev);
 	}
@@ -1687,6 +1737,9 @@ static void r5c_write_bio(struct r5c_cache *cache, struct bio *bio)
 		return;
 	}
 
+	if (r5c_check_wait_error_mode(cache))
+		goto error_mode;
+
 	if (bio->bi_iter.bi_size == 0) {
 		BUG_ON(!(bio->bi_rw & REQ_FLUSH));
 		if (r5l_queue_empty_flush_bio(&cache->log, bio,
@@ -1740,6 +1793,9 @@ static void r5c_write_bio(struct r5c_cache *cache, struct bio *bio)
 	r5c_put_stripe(stripe);
 enter_error:
 	r5l_put_reserve(&cache->log, reserved_blocks);
+	r5c_enter_error_mode(cache, -ENOMEM);
+	r5c_check_wait_error_mode(cache);
+error_mode:
 	raid5_make_request(cache->mddev, bio);
 }
 
@@ -2221,6 +2277,53 @@ static void r5c_reclaim_thread(struct md_thread *thread)
 
 		wake_up(&cache->reclaim_wait);
 	}
+
+	if (cache->error_state == ERROR_PREPARE) {
+		struct bio *bio;
+		spin_lock_irq(&cache->tree_lock);
+		if (!list_empty(&cache->log_list))
+			retry = true;
+		spin_unlock_irq(&cache->tree_lock);
+		if (retry) {
+			clear_bit(RECLAIM_FLUSH_ALL, &cache->reclaim_reason);
+			goto do_retry;
+		}
+
+		cache->error_state = ERROR_FINISH;
+		wake_up(&cache->error_wait);
+
+		/*
+		 * after all data is flushed to raid disks from cache, we will
+		 * retry error IO and dispatch it to raid disks directly
+		 **/
+		while ((bio = bio_list_pop(&cache->retry_bio_list)) != NULL)
+			raid5_make_request(cache->mddev, bio);
+
+		if (++cache->retry_cnt < MAX_RETRY) {
+			cache->next_retry_time = jiffies +
+				(cache->error_type != -ENOMEM ?
+				IOERR_RETRY_TIME : MEMERR_RETRY_TIME);
+		}
+	}
+
+	/*
+	 * IO error to log might not be permanent, let's try log again if there
+	 * aren't too many IO errors
+	 * */
+	if (cache->next_retry_time &&
+		time_before(cache->next_retry_time, jiffies)) {
+
+		/*
+		 * must guarantee there are no pending IO running in raid
+		 * before we allow retry, since r5c_write_parity might get
+		 * confused for running stripes
+		 * */
+		mddev_suspend(cache->mddev);
+		cache->next_retry_time = 0;
+		cache->error_type = 0;
+		cache->error_state = 0;
+		mddev_resume(cache->mddev);
+	}
 }
 
 static void r5c_wake_reclaimer(struct r5c_cache *cache, int reason)
@@ -2263,6 +2366,11 @@ static void r5c_write_one_stripe_parity(struct r5c_cache *cache,
 	stripe_offset = sector_div(stripe_index, cache->chunk_size);
 	stripe_offset >>= PAGE_SECTOR_SHIFT;
 
+	if (cache->error_state) {
+		r5c_put_stripe_dirty(cache, stripe);
+		return;
+	}
+
 	r5l_queue_parity(&cache->log, sh->sector,
 		sh->dev[sh->pd_idx].page,
 		sh->qd_idx >= 0 ? sh->dev[sh->qd_idx].page : NULL,
@@ -2278,7 +2386,7 @@ int r5c_write_parity(struct r5c_cache *cache, struct stripe_head *head_sh)
 	unsigned long flags;
 
 	/* parity is already written */
-	if (head_sh->stripe) {
+	if (head_sh->stripe || cache->error_state == ERROR_FINISH) {
 		head_sh->stripe = NULL;
 		return -EAGAIN;
 	}
-- 
1.8.1

