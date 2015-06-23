From: Shaohua Li <shli@fb.com>
Subject: [PATCH V4 07/13] raid5: cache device quiesce support
Date: Tue, 23 Jun 2015 14:37:57 -0700
Message-ID: <d01f908ea919217daca81b8672a41094281d24d9.1435094582.git.shli@fb.com>
References: <cover.1435094582.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cover.1435094582.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com, neilb@suse.de
List-Id: linux-raid.ids

In raid array quiesce, we should stop all IO. Existing mechanism stops
IO from upper layer but not IO from cache reclaim. This makes sure
reclaim thread will stop.

Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/raid5-cache.c | 35 +++++++++++++++++++++++++++++++++++
 drivers/md/raid5.c       |  2 ++
 drivers/md/raid5.h       |  1 +
 3 files changed, 38 insertions(+)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index c5de6dd..35657cd 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -364,6 +364,13 @@ enum {
 	ERROR_FINISH = 2, /* Had an error, cache has no data */
 };
 
+/* device quiescent support */
+enum {
+	QUIESCE_NONE = 0,
+	QUIESCE_START = 1,
+	QUIESCE_END = 2,
+};
+
 #define PAGE_SECTOR_SHIFT (PAGE_SHIFT - 9)
 
 static inline struct r5c_cache *r5l_cache(struct r5l_log *log)
@@ -2324,6 +2331,15 @@ static void r5c_reclaim_thread(struct md_thread *thread)
 		cache->error_state = 0;
 		mddev_resume(cache->mddev);
 	}
+
+	if (cache->quiesce_state == QUIESCE_START) {
+		/* user IO already finished, we just stop reclaim */
+		cache->reclaim_reason = 0;
+		cache->quiesce_state = QUIESCE_END;
+		wake_up(&cache->reclaim_wait);
+		wait_event(cache->reclaim_wait, cache->quiesce_state ==
+			QUIESCE_NONE);
+	}
 }
 
 static void r5c_wake_reclaimer(struct r5c_cache *cache, int reason)
@@ -2339,6 +2355,25 @@ static void r5c_wake_wait_reclaimer(struct r5c_cache *cache, int reason)
 		&cache->reclaim_reason));
 }
 
+void r5c_quiesce(struct r5conf *conf, int state)
+{
+	struct r5c_cache *cache = conf->cache;
+
+	if (!cache || cache->error_state)
+		return;
+	if (state == 1) {
+		/* we choose to flush all data to raid disks, this is a policy */
+		r5c_wake_wait_reclaimer(cache, RECLAIM_FLUSH_ALL);
+		cache->quiesce_state = QUIESCE_START;
+		md_wakeup_thread(cache->reclaim_thread);
+		wait_event(cache->reclaim_wait, cache->quiesce_state ==
+			QUIESCE_END);
+	} else if (state == 0) {
+		cache->quiesce_state = QUIESCE_NONE;
+		wake_up(&cache->reclaim_wait);
+	}
+}
+
 static void r5c_parity_task_end(struct r5l_task *task, int error)
 {
 	struct stripe_head *head_sh = task->private;
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index a9e10ff..bcd6c1f 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7485,6 +7485,7 @@ static void raid5_quiesce(struct mddev *mddev, int state)
 		break;
 
 	case 1: /* stop all writes */
+		r5c_quiesce(conf, state);
 		lock_all_device_hash_locks_irq(conf);
 		/* '2' tells resync/reshape to pause so that all
 		 * active stripes can drain
@@ -7507,6 +7508,7 @@ static void raid5_quiesce(struct mddev *mddev, int state)
 		wake_up(&conf->wait_for_stripe);
 		wake_up(&conf->wait_for_overlap);
 		unlock_all_device_hash_locks_irq(conf);
+		r5c_quiesce(conf, state);
 		break;
 	}
 }
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 16bd54f..534e5be 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -617,4 +617,5 @@ struct r5c_cache *r5c_init_cache(struct r5conf *conf, struct md_rdev *rdev);
 void r5c_exit_cache(struct r5c_cache *cache);
 void r5c_write_start(struct mddev *mddev, struct bio *bi);
 void r5c_write_end(struct mddev *mddev, struct bio *bi);
+void r5c_quiesce(struct r5conf *conf, int state);
 #endif
-- 
1.8.1

