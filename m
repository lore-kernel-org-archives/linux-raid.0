From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: [PATCH v3 2/9] raid5-cache: add policy logic
Date: Mon, 30 Jan 2017 19:59:46 +0100
Message-ID: <20170130185953.30428-3-artur.paszkiewicz@intel.com>
References: <20170130185953.30428-1-artur.paszkiewicz@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170130185953.30428-1-artur.paszkiewicz@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@fb.com, neilb@suse.com, jes.sorensen@gmail.com, Artur Paszkiewicz <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

Add wrappers for public log functions from raid5-cache and a struct
r5l_policy containing handlers for the log operations. This allows
adding different policies for raid5 logging without changing the
mechanism - calls from the raid5 personality stay the same.

Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
---
 drivers/md/raid5-cache.c | 116 +++++++++++++++++++++++++++++++++++++----------
 drivers/md/raid5-cache.h |  14 ++++++
 2 files changed, 106 insertions(+), 24 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 394d87b62efa..6fac581804a9 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -787,7 +787,7 @@ static inline void r5l_add_no_space_stripe(struct r5l_log *log,
  * running in raid5d, where reclaim could wait for raid5d too (when it flushes
  * data from log to raid disks), so we shouldn't wait for reclaim here
  */
-int r5l_write_stripe(struct r5l_log *log, struct stripe_head *sh)
+static int __r5l_write_stripe(struct r5l_log *log, struct stripe_head *sh)
 {
 	struct r5conf *conf = sh->raid_conf;
 	int write_disks = 0;
@@ -797,8 +797,6 @@ int r5l_write_stripe(struct r5l_log *log, struct stripe_head *sh)
 	int ret = 0;
 	bool wake_reclaim = false;
 
-	if (!log)
-		return -EAGAIN;
 	/* Don't support stripe batch */
 	if (sh->log_io || !test_bit(R5_Wantwrite, &sh->dev[sh->pd_idx].flags) ||
 	    test_bit(STRIPE_SYNCING, &sh->state)) {
@@ -885,19 +883,28 @@ int r5l_write_stripe(struct r5l_log *log, struct stripe_head *sh)
 	return 0;
 }
 
-void r5l_write_stripe_run(struct r5l_log *log)
+int r5l_write_stripe(struct r5l_log *log, struct stripe_head *sh)
+{
+	if (log && log->policy->write_stripe)
+		return log->policy->write_stripe(log, sh);
+	return -EAGAIN;
+}
+
+static void __r5l_write_stripe_run(struct r5l_log *log)
 {
-	if (!log)
-		return;
 	mutex_lock(&log->io_mutex);
 	r5l_submit_current_io(log);
 	mutex_unlock(&log->io_mutex);
 }
 
-int r5l_handle_flush_request(struct r5l_log *log, struct bio *bio)
+void r5l_write_stripe_run(struct r5l_log *log)
+{
+	if (log && log->policy->write_stripe_run)
+		log->policy->write_stripe_run(log);
+}
+
+static int __r5l_handle_flush_request(struct r5l_log *log, struct bio *bio)
 {
-	if (!log)
-		return -ENODEV;
 
 	if (log->r5c_journal_mode == R5C_JOURNAL_MODE_WRITE_THROUGH) {
 		/*
@@ -929,6 +936,13 @@ int r5l_handle_flush_request(struct r5l_log *log, struct bio *bio)
 	return -EAGAIN;
 }
 
+int r5l_handle_flush_request(struct r5l_log *log, struct bio *bio)
+{
+	if (log && log->policy->handle_flush_request)
+		return log->policy->handle_flush_request(log, bio);
+	return -ENODEV;
+}
+
 /* This will run after log space is reclaimed */
 static void r5l_run_no_space_stripes(struct r5l_log *log)
 {
@@ -1049,8 +1063,9 @@ void r5l_stripe_write_finished(struct stripe_head *sh)
 	io = sh->log_io;
 	sh->log_io = NULL;
 
-	if (io && atomic_dec_and_test(&io->pending_stripe))
-		__r5l_stripe_write_finished(io);
+	if (io && atomic_dec_and_test(&io->pending_stripe) &&
+	    io->log->policy->stripe_write_finished)
+		io->log->policy->stripe_write_finished(io);
 }
 
 static void r5l_log_flush_endio(struct bio *bio)
@@ -1084,11 +1099,11 @@ static void r5l_log_flush_endio(struct bio *bio)
  * only write stripes of an io_unit to raid disks till the io_unit is the first
  * one whose data/parity is in log.
  */
-void r5l_flush_stripe_to_raid(struct r5l_log *log)
+static void __r5l_flush_stripe_to_raid(struct r5l_log *log)
 {
 	bool do_flush;
 
-	if (!log || !log->need_cache_flush)
+	if (!log->need_cache_flush)
 		return;
 
 	spin_lock_irq(&log->io_list_lock);
@@ -1110,6 +1125,12 @@ void r5l_flush_stripe_to_raid(struct r5l_log *log)
 	submit_bio(&log->flush_bio);
 }
 
+void r5l_flush_stripe_to_raid(struct r5l_log *log)
+{
+	if (log && log->policy->flush_stripe_to_raid)
+		log->policy->flush_stripe_to_raid(log);
+}
+
 static void r5l_write_super(struct r5l_log *log, sector_t cp);
 static void r5l_write_super_and_discard_space(struct r5l_log *log,
 	sector_t end)
@@ -1366,10 +1387,10 @@ void r5l_wake_reclaim(struct r5l_log *log, sector_t space)
 	md_wakeup_thread(log->reclaim_thread);
 }
 
-void r5l_quiesce(struct r5l_log *log, int state)
+static void __r5l_quiesce(struct r5l_log *log, int state)
 {
 	struct mddev *mddev;
-	if (!log || state == 2)
+	if (state == 2)
 		return;
 	if (state == 0)
 		kthread_unpark(log->reclaim_thread->tsk);
@@ -1383,6 +1404,12 @@ void r5l_quiesce(struct r5l_log *log, int state)
 	}
 }
 
+void r5l_quiesce(struct r5l_log *log, int state)
+{
+	if (log && log->policy->quiesce)
+		log->policy->quiesce(log, state);
+}
+
 bool r5l_log_disk_error(struct r5conf *conf)
 {
 	struct r5l_log *log;
@@ -2626,11 +2653,10 @@ void r5c_update_on_rdev_error(struct mddev *mddev)
 		schedule_work(&log->disable_writeback_work);
 }
 
-int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
+static int __r5l_init_log(struct r5l_log *log, struct r5conf *conf)
 {
+	struct md_rdev *rdev = log->rdev;
 	struct request_queue *q = bdev_get_queue(rdev->bdev);
-	struct r5l_log *log;
-
 	if (PAGE_SIZE != 4096)
 		return -EINVAL;
 
@@ -2649,10 +2675,6 @@ int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
 		return -EINVAL;
 	}
 
-	log = kzalloc(sizeof(*log), GFP_KERNEL);
-	if (!log)
-		return -ENOMEM;
-	log->rdev = rdev;
 
 	log->need_cache_flush = test_bit(QUEUE_FLAG_WC, &q->queue_flags) != 0;
 
@@ -2728,11 +2750,10 @@ int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
 io_pool:
 	kmem_cache_destroy(log->io_kc);
 io_kc:
-	kfree(log);
 	return -EINVAL;
 }
 
-void r5l_exit_log(struct r5l_log *log)
+static void __r5l_exit_log(struct r5l_log *log)
 {
 	flush_work(&log->disable_writeback_work);
 	md_unregister_thread(&log->reclaim_thread);
@@ -2740,5 +2761,52 @@ void r5l_exit_log(struct r5l_log *log)
 	bioset_free(log->bs);
 	mempool_destroy(log->io_pool);
 	kmem_cache_destroy(log->io_kc);
+}
+
+void r5l_exit_log(struct r5l_log *log)
+{
+	if (!log)
+		return;
+
+	if (log->policy->exit_log)
+		log->policy->exit_log(log);
+
 	kfree(log);
 }
+
+struct r5l_policy r5l_journal = {
+	.init_log = __r5l_init_log,
+	.exit_log = __r5l_exit_log,
+	.write_stripe = __r5l_write_stripe,
+	.write_stripe_run = __r5l_write_stripe_run,
+	.flush_stripe_to_raid = __r5l_flush_stripe_to_raid,
+	.stripe_write_finished = __r5l_stripe_write_finished,
+	.handle_flush_request = __r5l_handle_flush_request,
+	.quiesce = __r5l_quiesce,
+};
+
+int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
+{
+	int ret;
+	struct r5l_log *log;
+	struct mddev *mddev = conf->mddev;
+
+	log = kzalloc(sizeof(*log), GFP_KERNEL);
+	if (!log)
+		return -ENOMEM;
+
+	if (test_bit(MD_HAS_JOURNAL, &mddev->flags)) {
+		log->policy = &r5l_journal;
+	} else {
+		kfree(log);
+		return -EINVAL;
+	}
+
+	log->rdev = rdev;
+
+	ret = log->policy->init_log(log, conf);
+	if (ret)
+		kfree(log);
+
+	return ret;
+}
diff --git a/drivers/md/raid5-cache.h b/drivers/md/raid5-cache.h
index 96dc95d4a36c..97803f3ae0fe 100644
--- a/drivers/md/raid5-cache.h
+++ b/drivers/md/raid5-cache.h
@@ -84,6 +84,9 @@ struct r5l_log {
 	/* to for chunk_aligned_read in writeback mode, details below */
 	spinlock_t tree_lock;
 	struct radix_tree_root big_stripe_tree;
+
+	/* handlers for log operations */
+	struct r5l_policy *policy;
 };
 
 /*
@@ -133,6 +136,17 @@ enum r5l_io_unit_state {
 	IO_UNIT_STRIPE_END = 3,	/* stripes data finished writing to raid */
 };
 
+struct r5l_policy {
+	int (*init_log)(struct r5l_log *log, struct r5conf *conf);
+	void (*exit_log)(struct r5l_log *log);
+	int (*write_stripe)(struct r5l_log *log, struct stripe_head *sh);
+	void (*write_stripe_run)(struct r5l_log *log);
+	void (*flush_stripe_to_raid)(struct r5l_log *log);
+	void (*stripe_write_finished)(struct r5l_io_unit *io);
+	int (*handle_flush_request)(struct r5l_log *log, struct bio *bio);
+	void (*quiesce)(struct r5l_log *log, int state);
+};
+
 extern int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev);
 extern void r5l_exit_log(struct r5l_log *log);
 extern int r5l_write_stripe(struct r5l_log *log, struct stripe_head *sh);
-- 
2.11.0

