From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: [PATCH v5 2/7] raid5: separate header for log functions
Date: Thu,  9 Mar 2017 09:59:58 +0100
Message-ID: <20170309090003.13298-3-artur.paszkiewicz@intel.com>
References: <20170309090003.13298-1-artur.paszkiewicz@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170309090003.13298-1-artur.paszkiewicz@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: shli@fb.com
Cc: linux-raid@vger.kernel.org, Artur Paszkiewicz <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

Move raid5-cache declarations from raid5.h to raid5-log.h, add inline
wrappers for functions which will be shared with ppl and use them in
raid5 core instead of direct calls to raid5-cache.

Remove unused parameter from r5c_cache_data(), move two duplicated
pr_debug() calls to r5l_init_log().

Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
---
 drivers/md/raid5-cache.c | 22 ++++++++++---
 drivers/md/raid5-log.h   | 81 ++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/md/raid5.c       | 48 ++++++++--------------------
 drivers/md/raid5.h       | 30 ------------------
 4 files changed, 112 insertions(+), 69 deletions(-)
 create mode 100644 drivers/md/raid5-log.h

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 3f307be01b10..ac4e74ef1f7f 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -343,6 +343,8 @@ void r5c_handle_cached_data_endio(struct r5conf *conf,
 	}
 }
 
+void r5l_wake_reclaim(struct r5l_log *log, sector_t space);
+
 /* Check whether we should flush some stripes to free up stripe cache */
 void r5c_check_stripe_cache_usage(struct r5conf *conf)
 {
@@ -2620,9 +2622,7 @@ void r5c_finish_stripe_write_out(struct r5conf *conf,
 	}
 }
 
-int
-r5c_cache_data(struct r5l_log *log, struct stripe_head *sh,
-	       struct stripe_head_state *s)
+int r5c_cache_data(struct r5l_log *log, struct stripe_head *sh)
 {
 	struct r5conf *conf = sh->raid_conf;
 	int pages = 0;
@@ -2785,6 +2785,10 @@ int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
 {
 	struct request_queue *q = bdev_get_queue(rdev->bdev);
 	struct r5l_log *log;
+	char b[BDEVNAME_SIZE];
+
+	pr_debug("md/raid:%s: using device %s as journal\n",
+		 mdname(conf->mddev), bdevname(rdev->bdev, b));
 
 	if (PAGE_SIZE != 4096)
 		return -EINVAL;
@@ -2887,7 +2891,7 @@ int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
 	return -EINVAL;
 }
 
-void r5l_exit_log(struct r5l_log *log)
+static void __r5l_exit_log(struct r5l_log *log)
 {
 	flush_work(&log->disable_writeback_work);
 	md_unregister_thread(&log->reclaim_thread);
@@ -2897,3 +2901,13 @@ void r5l_exit_log(struct r5l_log *log)
 	kmem_cache_destroy(log->io_kc);
 	kfree(log);
 }
+
+void r5l_exit_log(struct r5conf *conf)
+{
+	struct r5l_log *log = conf->log;
+
+	conf->log = NULL;
+	synchronize_rcu();
+
+	__r5l_exit_log(log);
+}
diff --git a/drivers/md/raid5-log.h b/drivers/md/raid5-log.h
new file mode 100644
index 000000000000..2da4bd3bbd79
--- /dev/null
+++ b/drivers/md/raid5-log.h
@@ -0,0 +1,81 @@
+#ifndef _RAID5_LOG_H
+#define _RAID5_LOG_H
+
+extern int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev);
+extern void r5l_exit_log(struct r5conf *conf);
+extern int r5l_write_stripe(struct r5l_log *log, struct stripe_head *head_sh);
+extern void r5l_write_stripe_run(struct r5l_log *log);
+extern void r5l_flush_stripe_to_raid(struct r5l_log *log);
+extern void r5l_stripe_write_finished(struct stripe_head *sh);
+extern int r5l_handle_flush_request(struct r5l_log *log, struct bio *bio);
+extern void r5l_quiesce(struct r5l_log *log, int state);
+extern bool r5l_log_disk_error(struct r5conf *conf);
+extern bool r5c_is_writeback(struct r5l_log *log);
+extern int
+r5c_try_caching_write(struct r5conf *conf, struct stripe_head *sh,
+		      struct stripe_head_state *s, int disks);
+extern void
+r5c_finish_stripe_write_out(struct r5conf *conf, struct stripe_head *sh,
+			    struct stripe_head_state *s);
+extern void r5c_release_extra_page(struct stripe_head *sh);
+extern void r5c_use_extra_page(struct stripe_head *sh);
+extern void r5l_wake_reclaim(struct r5l_log *log, sector_t space);
+extern void r5c_handle_cached_data_endio(struct r5conf *conf,
+	struct stripe_head *sh, int disks, struct bio_list *return_bi);
+extern int r5c_cache_data(struct r5l_log *log, struct stripe_head *sh);
+extern void r5c_make_stripe_write_out(struct stripe_head *sh);
+extern void r5c_flush_cache(struct r5conf *conf, int num);
+extern void r5c_check_stripe_cache_usage(struct r5conf *conf);
+extern void r5c_check_cached_full_stripe(struct r5conf *conf);
+extern struct md_sysfs_entry r5c_journal_mode;
+extern void r5c_update_on_rdev_error(struct mddev *mddev);
+extern bool r5c_big_stripe_cached(struct r5conf *conf, sector_t sect);
+
+static inline int log_stripe(struct stripe_head *sh, struct stripe_head_state *s)
+{
+	struct r5conf *conf = sh->raid_conf;
+
+	if (conf->log) {
+		if (!test_bit(STRIPE_R5C_CACHING, &sh->state)) {
+			/* writing out phase */
+			if (s->waiting_extra_page)
+				return 0;
+			return r5l_write_stripe(conf->log, sh);
+		} else if (test_bit(STRIPE_LOG_TRAPPED, &sh->state)) {
+			/* caching phase */
+			return r5c_cache_data(conf->log, sh);
+		}
+	}
+
+	return -EAGAIN;
+}
+
+static inline void log_stripe_write_finished(struct stripe_head *sh)
+{
+	struct r5conf *conf = sh->raid_conf;
+
+	if (conf->log)
+		r5l_stripe_write_finished(sh);
+}
+
+static inline void log_write_stripe_run(struct r5conf *conf)
+{
+	if (conf->log)
+		r5l_write_stripe_run(conf->log);
+}
+
+static inline void log_exit(struct r5conf *conf)
+{
+	if (conf->log)
+		r5l_exit_log(conf);
+}
+
+static inline int log_init(struct r5conf *conf, struct md_rdev *journal_dev)
+{
+	if (journal_dev)
+		return r5l_init_log(conf, journal_dev);
+
+	return 0;
+}
+
+#endif
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 5d9148125ec5..043a509560c2 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -61,6 +61,7 @@
 #include "raid5.h"
 #include "raid0.h"
 #include "bitmap.h"
+#include "raid5-log.h"
 
 #define UNSUPPORTED_MDDEV_FLAGS	(1L << MD_FAILFAST_SUPPORTED)
 
@@ -911,18 +912,8 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 
 	might_sleep();
 
-	if (!test_bit(STRIPE_R5C_CACHING, &sh->state)) {
-		/* writing out phase */
-		if (s->waiting_extra_page)
-			return;
-		if (r5l_write_stripe(conf->log, sh) == 0)
-			return;
-	} else {  /* caching phase */
-		if (test_bit(STRIPE_LOG_TRAPPED, &sh->state)) {
-			r5c_cache_data(conf->log, sh, s);
-			return;
-		}
-	}
+	if (log_stripe(sh, s) == 0)
+		return;
 
 	for (i = disks; i--; ) {
 		int op, op_flags = 0;
@@ -3247,7 +3238,7 @@ handle_failed_stripe(struct r5conf *conf, struct stripe_head *sh,
 		if (bi)
 			bitmap_end = 1;
 
-		r5l_stripe_write_finished(sh);
+		log_stripe_write_finished(sh);
 
 		if (test_and_clear_bit(R5_Overlap, &sh->dev[i].flags))
 			wake_up(&conf->wait_for_overlap);
@@ -3666,7 +3657,7 @@ static void handle_stripe_clean_event(struct r5conf *conf,
 				discard_pending = 1;
 		}
 
-	r5l_stripe_write_finished(sh);
+	log_stripe_write_finished(sh);
 
 	if (!discard_pending &&
 	    test_bit(R5_Discard, &sh->dev[sh->pd_idx].flags)) {
@@ -4656,7 +4647,7 @@ static void handle_stripe(struct stripe_head *sh)
 
 	if (s.just_cached)
 		r5c_handle_cached_data_endio(conf, sh, disks, &s.return_bi);
-	r5l_stripe_write_finished(sh);
+	log_stripe_write_finished(sh);
 
 	/* Now we might consider reading some blocks, either to check/generate
 	 * parity, or to satisfy requests
@@ -6057,7 +6048,7 @@ static int handle_active_stripes(struct r5conf *conf, int group,
 
 	for (i = 0; i < batch_size; i++)
 		handle_stripe(batch[i]);
-	r5l_write_stripe_run(conf->log);
+	log_write_stripe_run(conf);
 
 	cond_resched();
 
@@ -6633,8 +6624,8 @@ static void free_conf(struct r5conf *conf)
 {
 	int i;
 
-	if (conf->log)
-		r5l_exit_log(conf->log);
+	log_exit(conf);
+
 	if (conf->shrinker.nr_deferred)
 		unregister_shrinker(&conf->shrinker);
 
@@ -7315,14 +7306,8 @@ static int raid5_run(struct mddev *mddev)
 		blk_queue_max_hw_sectors(mddev->queue, UINT_MAX);
 	}
 
-	if (journal_dev) {
-		char b[BDEVNAME_SIZE];
-
-		pr_debug("md/raid:%s: using device %s as journal\n",
-			 mdname(mddev), bdevname(journal_dev->bdev, b));
-		if (r5l_init_log(conf, journal_dev))
-			goto abort;
-	}
+	if (log_init(conf, journal_dev))
+		goto abort;
 
 	return 0;
 abort:
@@ -7436,17 +7421,13 @@ static int raid5_remove_disk(struct mddev *mddev, struct md_rdev *rdev)
 
 	print_raid5_conf(conf);
 	if (test_bit(Journal, &rdev->flags) && conf->log) {
-		struct r5l_log *log;
 		/*
 		 * we can't wait pending write here, as this is called in
 		 * raid5d, wait will deadlock.
 		 */
 		if (atomic_read(&mddev->writes_pending))
 			return -EBUSY;
-		log = conf->log;
-		conf->log = NULL;
-		synchronize_rcu();
-		r5l_exit_log(log);
+		log_exit(conf);
 		return 0;
 	}
 	if (rdev == p->rdev)
@@ -7515,7 +7496,6 @@ static int raid5_add_disk(struct mddev *mddev, struct md_rdev *rdev)
 	int last = conf->raid_disks - 1;
 
 	if (test_bit(Journal, &rdev->flags)) {
-		char b[BDEVNAME_SIZE];
 		if (conf->log)
 			return -EBUSY;
 
@@ -7524,9 +7504,7 @@ static int raid5_add_disk(struct mddev *mddev, struct md_rdev *rdev)
 		 * The array is in readonly mode if journal is missing, so no
 		 * write requests running. We should be safe
 		 */
-		r5l_init_log(conf, rdev);
-		pr_debug("md/raid:%s: using device %s as journal\n",
-			 mdname(mddev), bdevname(rdev->bdev, b));
+		log_init(conf, rdev);
 		return 0;
 	}
 	if (mddev->recovery_disabled == conf->recovery_disabled)
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 4bb27b97bf6b..749c6c496e7d 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -765,34 +765,4 @@ extern struct stripe_head *
 raid5_get_active_stripe(struct r5conf *conf, sector_t sector,
 			int previous, int noblock, int noquiesce);
 extern int raid5_calc_degraded(struct r5conf *conf);
-extern int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev);
-extern void r5l_exit_log(struct r5l_log *log);
-extern int r5l_write_stripe(struct r5l_log *log, struct stripe_head *head_sh);
-extern void r5l_write_stripe_run(struct r5l_log *log);
-extern void r5l_flush_stripe_to_raid(struct r5l_log *log);
-extern void r5l_stripe_write_finished(struct stripe_head *sh);
-extern int r5l_handle_flush_request(struct r5l_log *log, struct bio *bio);
-extern void r5l_quiesce(struct r5l_log *log, int state);
-extern bool r5l_log_disk_error(struct r5conf *conf);
-extern bool r5c_is_writeback(struct r5l_log *log);
-extern int
-r5c_try_caching_write(struct r5conf *conf, struct stripe_head *sh,
-		      struct stripe_head_state *s, int disks);
-extern void
-r5c_finish_stripe_write_out(struct r5conf *conf, struct stripe_head *sh,
-			    struct stripe_head_state *s);
-extern void r5c_release_extra_page(struct stripe_head *sh);
-extern void r5c_use_extra_page(struct stripe_head *sh);
-extern void r5l_wake_reclaim(struct r5l_log *log, sector_t space);
-extern void r5c_handle_cached_data_endio(struct r5conf *conf,
-	struct stripe_head *sh, int disks, struct bio_list *return_bi);
-extern int r5c_cache_data(struct r5l_log *log, struct stripe_head *sh,
-			  struct stripe_head_state *s);
-extern void r5c_make_stripe_write_out(struct stripe_head *sh);
-extern void r5c_flush_cache(struct r5conf *conf, int num);
-extern void r5c_check_stripe_cache_usage(struct r5conf *conf);
-extern void r5c_check_cached_full_stripe(struct r5conf *conf);
-extern struct md_sysfs_entry r5c_journal_mode;
-extern void r5c_update_on_rdev_error(struct mddev *mddev);
-extern bool r5c_big_stripe_cached(struct r5conf *conf, sector_t sect);
 #endif
-- 
2.11.0

