From: Song Liu <songliubraving@fb.com>
Subject: [PATCH v3] md/r5cache: disable write back for degraded array
Date: Tue, 24 Jan 2017 10:45:30 -0800
Message-ID: <20170124184530.1097979-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.com, shli@fb.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, liuzhengyuan@kylinos.cn, liuyun01@kylinos.cn, Song Liu <songliubraving@fb.com>, jsorensen@fb.com
List-Id: linux-raid.ids

write-back cache in degraded mode introduces corner cases to the array.
Although we try to cover all these corner cases, it is safer to just
disable write-back cache when the array is in degraded mode.

In this patch, we disable writeback cache for degraded mode:
1. On device failure, if the array enters degraded mode, raid5_error()
   will submit async job r5c_disable_writeback_async to disable
   writeback;
2. In r5c_journal_mode_store(), it is invalid to enable writeback in
   degraded mode;
3. In r5c_try_caching_write(), stripes with s->failed>0 will be handled
   in write-through mode.

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 drivers/md/raid5-cache.c | 46 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/md/raid5.c       | 15 ++++++++-------
 drivers/md/raid5.h       |  2 ++
 3 files changed, 56 insertions(+), 7 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 00d2838..8ab6e1a 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -164,6 +164,9 @@ struct r5l_log {
 	/* to submit async io_units, to fulfill ordering of flush */
 	struct work_struct deferred_io_work;
 
+	/* to disable write back during in degraded mode */
+	struct work_struct disable_writeback_work;
+
 	/* to for chunk_aligned_read in writeback mode, details below */
 	spinlock_t tree_lock;
 	struct radix_tree_root big_stripe_tree;
@@ -653,6 +656,20 @@ static void r5l_submit_io_async(struct work_struct *work)
 		r5l_do_submit_io(log, io);
 }
 
+static void r5c_disable_writeback_async(struct work_struct *work)
+{
+	struct r5l_log *log = container_of(work, struct r5l_log,
+					   disable_writeback_work);
+	struct mddev *mddev = log->rdev->mddev;
+	struct r5conf *conf = mddev->private;
+
+	pr_info("md/raid:%s: Disabling writeback cache for degraded array.\n",
+		mdname(mddev));
+	mddev_suspend(mddev);
+	conf->log->r5c_journal_mode = R5C_JOURNAL_MODE_WRITE_THROUGH;
+	mddev_resume(mddev);
+}
+
 static void r5l_submit_current_io(struct r5l_log *log)
 {
 	struct r5l_io_unit *io = log->current_io;
@@ -2311,6 +2328,10 @@ static ssize_t r5c_journal_mode_store(struct mddev *mddev,
 	    val > R5C_JOURNAL_MODE_WRITE_BACK)
 		return -EINVAL;
 
+	if (raid5_calc_degraded(conf) > 0 &&
+	    val == R5C_JOURNAL_MODE_WRITE_BACK)
+		return -EINVAL;
+
 	mddev_suspend(mddev);
 	conf->log->r5c_journal_mode = val;
 	mddev_resume(mddev);
@@ -2369,6 +2390,16 @@ int r5c_try_caching_write(struct r5conf *conf,
 		set_bit(STRIPE_R5C_CACHING, &sh->state);
 	}
 
+	/*
+	 * When run in degraded mode, array is set to write-through mode.
+	 * This check helps drain pending write safely in the transition to
+	 * write-through mode.
+	 */
+	if (s->failed) {
+		r5c_make_stripe_write_out(sh);
+		return -EAGAIN;
+	}
+
 	for (i = disks; i--; ) {
 		dev = &sh->dev[i];
 		/* if non-overwrite, use writing-out phase */
@@ -2713,6 +2744,19 @@ static int r5l_load_log(struct r5l_log *log)
 	return ret;
 }
 
+void r5c_update_on_rdev_error(struct mddev *mddev)
+{
+	struct r5conf *conf = mddev->private;
+	struct r5l_log *log = conf->log;
+
+	if (!log)
+		return;
+
+	if (raid5_calc_degraded(conf) > 0 &&
+	    conf->log->r5c_journal_mode == R5C_JOURNAL_MODE_WRITE_BACK)
+		schedule_work(&log->disable_writeback_work);
+}
+
 int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
 {
 	struct request_queue *q = bdev_get_queue(rdev->bdev);
@@ -2788,6 +2832,7 @@ int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
 	spin_lock_init(&log->no_space_stripes_lock);
 
 	INIT_WORK(&log->deferred_io_work, r5l_submit_io_async);
+	INIT_WORK(&log->disable_writeback_work, r5c_disable_writeback_async);
 
 	log->r5c_journal_mode = R5C_JOURNAL_MODE_WRITE_THROUGH;
 	INIT_LIST_HEAD(&log->stripe_in_journal_list);
@@ -2820,6 +2865,7 @@ int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
 
 void r5l_exit_log(struct r5l_log *log)
 {
+	flush_scheduled_work();
 	md_unregister_thread(&log->reclaim_thread);
 	mempool_destroy(log->meta_pool);
 	bioset_free(log->bs);
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index ad8f24c..9c93ca1 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -556,7 +556,7 @@ static struct stripe_head *__find_stripe(struct r5conf *conf, sector_t sector,
  * of the two sections, and some non-in_sync devices may
  * be insync in the section most affected by failed devices.
  */
-static int calc_degraded(struct r5conf *conf)
+int raid5_calc_degraded(struct r5conf *conf)
 {
 	int degraded, degraded2;
 	int i;
@@ -619,7 +619,7 @@ static int has_failed(struct r5conf *conf)
 	if (conf->mddev->reshape_position == MaxSector)
 		return conf->mddev->degraded > conf->max_degraded;
 
-	degraded = calc_degraded(conf);
+	degraded = raid5_calc_degraded(conf);
 	if (degraded > conf->max_degraded)
 		return 1;
 	return 0;
@@ -2592,7 +2592,7 @@ static void raid5_error(struct mddev *mddev, struct md_rdev *rdev)
 
 	spin_lock_irqsave(&conf->device_lock, flags);
 	clear_bit(In_sync, &rdev->flags);
-	mddev->degraded = calc_degraded(conf);
+	mddev->degraded = raid5_calc_degraded(conf);
 	spin_unlock_irqrestore(&conf->device_lock, flags);
 	set_bit(MD_RECOVERY_INTR, &mddev->recovery);
 
@@ -2606,6 +2606,7 @@ static void raid5_error(struct mddev *mddev, struct md_rdev *rdev)
 		bdevname(rdev->bdev, b),
 		mdname(mddev),
 		conf->raid_disks - mddev->degraded);
+	r5c_update_on_rdev_error(mddev);
 }
 
 /*
@@ -7147,7 +7148,7 @@ static int raid5_run(struct mddev *mddev)
 	/*
 	 * 0 for a fully functional array, 1 or 2 for a degraded array.
 	 */
-	mddev->degraded = calc_degraded(conf);
+	mddev->degraded = raid5_calc_degraded(conf);
 
 	if (has_failed(conf)) {
 		pr_crit("md/raid:%s: not enough operational devices (%d/%d failed)\n",
@@ -7394,7 +7395,7 @@ static int raid5_spare_active(struct mddev *mddev)
 		}
 	}
 	spin_lock_irqsave(&conf->device_lock, flags);
-	mddev->degraded = calc_degraded(conf);
+	mddev->degraded = raid5_calc_degraded(conf);
 	spin_unlock_irqrestore(&conf->device_lock, flags);
 	print_raid5_conf(conf);
 	return count;
@@ -7754,7 +7755,7 @@ static int raid5_start_reshape(struct mddev *mddev)
 		 * pre and post number of devices.
 		 */
 		spin_lock_irqsave(&conf->device_lock, flags);
-		mddev->degraded = calc_degraded(conf);
+		mddev->degraded = raid5_calc_degraded(conf);
 		spin_unlock_irqrestore(&conf->device_lock, flags);
 	}
 	mddev->raid_disks = conf->raid_disks;
@@ -7842,7 +7843,7 @@ static void raid5_finish_reshape(struct mddev *mddev)
 		} else {
 			int d;
 			spin_lock_irq(&conf->device_lock);
-			mddev->degraded = calc_degraded(conf);
+			mddev->degraded = raid5_calc_degraded(conf);
 			spin_unlock_irq(&conf->device_lock);
 			for (d = conf->raid_disks ;
 			     d < conf->raid_disks - mddev->delta_disks;
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 8ae498c..bbdc5a4 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -762,6 +762,7 @@ extern sector_t raid5_compute_sector(struct r5conf *conf, sector_t r_sector,
 extern struct stripe_head *
 raid5_get_active_stripe(struct r5conf *conf, sector_t sector,
 			int previous, int noblock, int noquiesce);
+extern int raid5_calc_degraded(struct r5conf *conf);
 extern int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev);
 extern void r5l_exit_log(struct r5l_log *log);
 extern int r5l_write_stripe(struct r5l_log *log, struct stripe_head *head_sh);
@@ -791,4 +792,5 @@ extern void r5c_check_stripe_cache_usage(struct r5conf *conf);
 extern void r5c_check_cached_full_stripe(struct r5conf *conf);
 extern struct md_sysfs_entry r5c_journal_mode;
 extern bool r5c_big_stripe_cached(struct r5conf *conf, sector_t sect);
+extern void r5c_update_on_rdev_error(struct mddev *mddev);
 #endif
-- 
2.9.3

