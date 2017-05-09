From: Song Liu <songliubraving@fb.com>
Subject: [PATCH v4 2/2] md/r5cache: gracefully handle journal device errors for writeback mode
Date: Mon, 8 May 2017 17:39:25 -0700
Message-ID: <20170509003925.3480693-2-songliubraving@fb.com>
References: <20170509003925.3480693-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170509003925.3480693-1-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@fb.com, neilb@suse.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, jes.sorensen@gmail.com, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

For the raid456 with writeback cache, when journal device failed during
normal operation, it is still possible to persist all data, as all
pending data is still in stripe cache. However, it is necessary to handle
journal failure gracefully.

During journal failures, this patch makes the follow changes to land data
in cache to raid disks gracefully:

1. In handle_stripe(), allow stripes with data in journal (s.injournal > 0)
   to make progress;
2. In delay_towrite(), only process data in the cache (skip dev->towrite);
3. In __get_priority_stripe(), set try_loprio to true, so no stripe stuck
   in loprio_list

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 drivers/md/raid5-cache.c | 13 ++++++++++---
 drivers/md/raid5-log.h   |  3 ++-
 drivers/md/raid5.c       | 29 +++++++++++++++++++++++------
 3 files changed, 35 insertions(+), 10 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index dc1dba6..e6032f6 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -24,6 +24,7 @@
 #include "md.h"
 #include "raid5.h"
 #include "bitmap.h"
+#include "raid5-log.h"
 
 /*
  * metadata/data stored in disk with 4k size unit (a block) regardless
@@ -679,6 +680,7 @@ static void r5c_disable_writeback_async(struct work_struct *work)
 		return;
 	pr_info("md/raid:%s: Disabling writeback cache for degraded array.\n",
 		mdname(mddev));
+	md_update_sb(mddev, 1);
 	mddev_suspend(mddev);
 	log->r5c_journal_mode = R5C_JOURNAL_MODE_WRITE_THROUGH;
 	mddev_resume(mddev);
@@ -1557,6 +1559,8 @@ void r5l_wake_reclaim(struct r5l_log *log, sector_t space)
 void r5l_quiesce(struct r5l_log *log, int state)
 {
 	struct mddev *mddev;
+	struct r5conf *conf;
+
 	if (!log || state == 2)
 		return;
 	if (state == 0)
@@ -1564,10 +1568,12 @@ void r5l_quiesce(struct r5l_log *log, int state)
 	else if (state == 1) {
 		/* make sure r5l_write_super_and_discard_space exits */
 		mddev = log->rdev->mddev;
+		conf = mddev->private;
 		wake_up(&mddev->sb_wait);
 		kthread_park(log->reclaim_thread->tsk);
 		r5l_wake_reclaim(log, MaxSector);
-		r5l_do_reclaim(log);
+		if (!r5l_log_disk_error(conf))
+			r5l_do_reclaim(log);
 	}
 }
 
@@ -2982,7 +2988,7 @@ static int r5l_load_log(struct r5l_log *log)
 	return ret;
 }
 
-void r5c_update_on_rdev_error(struct mddev *mddev)
+void r5c_update_on_rdev_error(struct mddev *mddev, struct md_rdev *rdev)
 {
 	struct r5conf *conf = mddev->private;
 	struct r5l_log *log = conf->log;
@@ -2990,7 +2996,8 @@ void r5c_update_on_rdev_error(struct mddev *mddev)
 	if (!log)
 		return;
 
-	if (raid5_calc_degraded(conf) > 0 &&
+	if ((raid5_calc_degraded(conf) > 0 ||
+	     test_bit(Journal, &rdev->flags)) &&
 	    conf->log->r5c_journal_mode == R5C_JOURNAL_MODE_WRITE_BACK)
 		schedule_work(&log->disable_writeback_work);
 }
diff --git a/drivers/md/raid5-log.h b/drivers/md/raid5-log.h
index 2709710..328d67a 100644
--- a/drivers/md/raid5-log.h
+++ b/drivers/md/raid5-log.h
@@ -28,7 +28,8 @@ extern void r5c_flush_cache(struct r5conf *conf, int num);
 extern void r5c_check_stripe_cache_usage(struct r5conf *conf);
 extern void r5c_check_cached_full_stripe(struct r5conf *conf);
 extern struct md_sysfs_entry r5c_journal_mode;
-extern void r5c_update_on_rdev_error(struct mddev *mddev);
+extern void r5c_update_on_rdev_error(struct mddev *mddev,
+				     struct md_rdev *rdev);
 extern bool r5c_big_stripe_cached(struct r5conf *conf, sector_t sect);
 
 extern struct dma_async_tx_descriptor *
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index f8055a7..0ac57a9 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2689,7 +2689,7 @@ static void raid5_error(struct mddev *mddev, struct md_rdev *rdev)
 		bdevname(rdev->bdev, b),
 		mdname(mddev),
 		conf->raid_disks - mddev->degraded);
-	r5c_update_on_rdev_error(mddev);
+	r5c_update_on_rdev_error(mddev, rdev);
 }
 
 /*
@@ -3050,6 +3050,11 @@ sector_t raid5_compute_blocknr(struct stripe_head *sh, int i, int previous)
  *      When LOG_CRITICAL, stripes with injournal == 0 will be sent to
  *      no_space_stripes list.
  *
+ *   3. during journal failure
+ *      In journal failure, we try to flush all cached data to raid disks
+ *      based on data in stripe cache. The array is read-only to upper
+ *      layers, so we would skip all pending writes.
+ *
  */
 static inline bool delay_towrite(struct r5conf *conf,
 				 struct r5dev *dev,
@@ -3063,6 +3068,9 @@ static inline bool delay_towrite(struct r5conf *conf,
 	if (test_bit(R5C_LOG_CRITICAL, &conf->cache_state) &&
 	    s->injournal > 0)
 		return true;
+	/* case 3 above */
+	if (s->log_failed && s->injournal)
+		return true;
 	return false;
 }
 
@@ -4696,10 +4704,15 @@ static void handle_stripe(struct stripe_head *sh)
 	       " to_write=%d failed=%d failed_num=%d,%d\n",
 	       s.locked, s.uptodate, s.to_read, s.to_write, s.failed,
 	       s.failed_num[0], s.failed_num[1]);
-	/* check if the array has lost more than max_degraded devices and,
+	/*
+	 * check if the array has lost more than max_degraded devices and,
 	 * if so, some requests might need to be failed.
+	 *
+	 * When journal device failed (log_failed), we will only process
+	 * the stripe if there is data need write to raid disks
 	 */
-	if (s.failed > conf->max_degraded || s.log_failed) {
+	if (s.failed > conf->max_degraded ||
+	    (s.log_failed && s.injournal == 0)) {
 		sh->check_state = 0;
 		sh->reconstruct_state = 0;
 		break_stripe_batch_list(sh, 0);
@@ -5272,8 +5285,10 @@ static struct stripe_head *__get_priority_stripe(struct r5conf *conf, int group)
 	struct stripe_head *sh, *tmp;
 	struct list_head *handle_list = NULL;
 	struct r5worker_group *wg;
-	bool second_try = !r5c_is_writeback(conf->log);
-	bool try_loprio = test_bit(R5C_LOG_TIGHT, &conf->cache_state);
+	bool second_try = !r5c_is_writeback(conf->log) &&
+		!r5l_log_disk_error(conf);
+	bool try_loprio = test_bit(R5C_LOG_TIGHT, &conf->cache_state) ||
+		r5l_log_disk_error(conf);
 
 again:
 	wg = NULL;
@@ -7521,7 +7536,9 @@ static int raid5_remove_disk(struct mddev *mddev, struct md_rdev *rdev)
 		 * neilb: there is no locking about new writes here,
 		 * so this cannot be safe.
 		 */
-		if (atomic_read(&conf->active_stripes)) {
+		if (atomic_read(&conf->active_stripes) ||
+		    atomic_read(&conf->r5c_cached_full_stripes) ||
+		    atomic_read(&conf->r5c_cached_partial_stripes)) {
 			return -EBUSY;
 		}
 		log_exit(conf);
-- 
2.9.3

