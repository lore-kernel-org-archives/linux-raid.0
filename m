From: Song Liu <songliubraving@fb.com>
Subject: [PATCH v5] md/r5cache: gracefully handle journal device errors for writeback mode
Date: Thu, 11 May 2017 15:28:28 -0700
Message-ID: <20170511222828.2142993-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@fb.com, neilb@suse.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, jes.sorensen@gmail.com, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

For the raid456 with writeback cache, when journal device failed during
normal operation, it is still possible to persist all data, as all
pending data is still in stripe cache. However, it is necessary to handle
journal failure gracefully.

During journal failures, the following logic handles the graceful shutdown
of journal:
1. raid5_error() marks the device as Faulty and schedules async work
   log->disable_writeback_work;
2. In disable_writeback_work (r5c_disable_writeback_async), the mddev is
   suspended, set to write through, and then resumed. mddev_suspend()
   flushes all cached stripes;
3. All cached stripes need to be flushed carefully to the RAID array.

This patch fixes issues within the process above:
1. In r5c_update_on_rdev_error() schedule disable_writeback_work for
   journal failures;
2. In r5c_disable_writeback_async(), wait for MD_SB_CHANGE_PENDING,
   since raid5_error() updates superblock.
3. In handle_stripe(), allow stripes with data in journal (s.injournal > 0)
   to make progress during log_failed;
4. In delay_towrite(), if log failed only process data in the cache (skip
   new writes in dev->towrite);
5. In __get_priority_stripe(), process loprio_list during journal device
   failures.
6. In raid5_remove_disk(), wait for all cached stripes are flushed before
   calling log_exit().

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 drivers/md/raid5-cache.c | 11 +++++++++--
 drivers/md/raid5-log.h   |  3 ++-
 drivers/md/raid5.c       | 29 +++++++++++++++++++++++------
 3 files changed, 34 insertions(+), 9 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index a6a62e2..cc3f844 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -24,6 +24,7 @@
 #include "md.h"
 #include "raid5.h"
 #include "bitmap.h"
+#include "raid5-log.h"
 
 /*
  * metadata/data stored in disk with 4k size unit (a block) regardless
@@ -680,6 +681,11 @@ static void r5c_disable_writeback_async(struct work_struct *work)
 		return;
 	pr_info("md/raid:%s: Disabling writeback cache for degraded array.\n",
 		mdname(mddev));
+
+	/* wait superblock change before suspend */
+	wait_event(mddev->sb_wait,
+		   !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags));
+
 	mddev_suspend(mddev);
 	log->r5c_journal_mode = R5C_JOURNAL_MODE_WRITE_THROUGH;
 	mddev_resume(mddev);
@@ -2983,7 +2989,7 @@ static int r5l_load_log(struct r5l_log *log)
 	return ret;
 }
 
-void r5c_update_on_rdev_error(struct mddev *mddev)
+void r5c_update_on_rdev_error(struct mddev *mddev, struct md_rdev *rdev)
 {
 	struct r5conf *conf = mddev->private;
 	struct r5l_log *log = conf->log;
@@ -2991,7 +2997,8 @@ void r5c_update_on_rdev_error(struct mddev *mddev)
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

