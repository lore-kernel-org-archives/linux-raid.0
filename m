From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: [PATCH v2 02/12] raid5-cache: add policy logic
Date: Mon,  5 Dec 2016 16:31:03 +0100
Message-ID: <20161205153113.7268-3-artur.paszkiewicz@intel.com>
References: <20161205153113.7268-1-artur.paszkiewicz@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161205153113.7268-1-artur.paszkiewicz@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: shli@kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Add a struct r5l_policy and wrapper functions for non-static functions
from raid5-cache. This allows adding different policies for raid5
logging without changing the mechanism - calls from the raid5
personality stay the same.

Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
---
 drivers/md/raid5-cache.c | 112 +++++++++++++++++++++++++++++++++++------------
 drivers/md/raid5-cache.h |  13 ++++++
 2 files changed, 98 insertions(+), 27 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 6a3f8e7..74a0eda 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -727,7 +727,7 @@ static inline void r5l_add_no_space_stripe(struct r5l_log *log,
  * running in raid5d, where reclaim could wait for raid5d too (when it flushes
  * data from log to raid disks), so we shouldn't wait for reclaim here
  */
-int r5l_write_stripe(struct r5l_log *log, struct stripe_head *sh)
+static int __r5l_write_stripe(struct r5l_log *log, struct stripe_head *sh)
 {
 	struct r5conf *conf = sh->raid_conf;
 	int write_disks = 0;
@@ -737,8 +737,6 @@ int r5l_write_stripe(struct r5l_log *log, struct stripe_head *sh)
 	int ret = 0;
 	bool wake_reclaim = false;
 
-	if (!log)
-		return -EAGAIN;
 	/* Don't support stripe batch */
 	if (sh->log_io || !test_bit(R5_Wantwrite, &sh->dev[sh->pd_idx].flags) ||
 	    test_bit(STRIPE_SYNCING, &sh->state)) {
@@ -825,19 +823,28 @@ int r5l_write_stripe(struct r5l_log *log, struct stripe_head *sh)
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
@@ -869,6 +876,13 @@ int r5l_handle_flush_request(struct r5l_log *log, struct bio *bio)
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
@@ -989,8 +1003,9 @@ void r5l_stripe_write_finished(struct stripe_head *sh)
 	io = sh->log_io;
 	sh->log_io = NULL;
 
-	if (io && atomic_dec_and_test(&io->pending_stripe))
-		__r5l_stripe_write_finished(io);
+	if (io && atomic_dec_and_test(&io->pending_stripe) &&
+			io->log->policy->stripe_write_finished)
+		io->log->policy->stripe_write_finished(io);
 }
 
 static void r5l_log_flush_endio(struct bio *bio)
@@ -1024,11 +1039,11 @@ static void r5l_log_flush_endio(struct bio *bio)
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
@@ -1050,6 +1065,12 @@ void r5l_flush_stripe_to_raid(struct r5l_log *log)
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
@@ -1304,10 +1325,10 @@ void r5l_wake_reclaim(struct r5l_log *log, sector_t space)
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
@@ -1321,6 +1342,12 @@ void r5l_quiesce(struct r5l_log *log, int state)
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
@@ -2406,11 +2433,9 @@ static int r5l_load_log(struct r5l_log *log)
 	return ret;
 }
 
-int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
+static int __r5l_init_log(struct r5l_log *log, struct r5conf *conf)
 {
-	struct request_queue *q = bdev_get_queue(rdev->bdev);
-	struct r5l_log *log;
-
+	struct request_queue *q = bdev_get_queue(log->rdev->bdev);
 	if (PAGE_SIZE != 4096)
 		return -EINVAL;
 
@@ -2429,15 +2454,11 @@ int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
 		return -EINVAL;
 	}
 
-	log = kzalloc(sizeof(*log), GFP_KERNEL);
-	if (!log)
-		return -ENOMEM;
-	log->rdev = rdev;
 
 	log->need_cache_flush = test_bit(QUEUE_FLAG_WC, &q->queue_flags) != 0;
 
-	log->uuid_checksum = crc32c_le(~0, rdev->mddev->uuid,
-				       sizeof(rdev->mddev->uuid));
+	log->uuid_checksum = crc32c_le(~0, log->rdev->mddev->uuid,
+				       sizeof(log->rdev->mddev->uuid));
 
 	mutex_init(&log->io_mutex);
 
@@ -2502,16 +2523,53 @@ int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
 io_pool:
 	kmem_cache_destroy(log->io_kc);
 io_kc:
-	kfree(log);
 	return -EINVAL;
 }
 
-void r5l_exit_log(struct r5l_log *log)
+static void __r5l_exit_log(struct r5l_log *log)
 {
 	md_unregister_thread(&log->reclaim_thread);
 	mempool_destroy(log->meta_pool);
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
+	struct r5l_log *log = kzalloc(sizeof(*log), GFP_KERNEL);
+	if (!log)
+		return -ENOMEM;
+
+	log->rdev = rdev;
+	log->policy = &r5l_journal;
+
+	ret = log->policy->init_log(log, conf);
+	if (ret)
+		kfree(log);
+
+	return ret;
+}
diff --git a/drivers/md/raid5-cache.h b/drivers/md/raid5-cache.h
index 1908d45..52cfef4 100644
--- a/drivers/md/raid5-cache.h
+++ b/drivers/md/raid5-cache.h
@@ -78,6 +78,8 @@ struct r5l_log {
 
 	/* to submit async io_units, to fulfill ordering of flush */
 	struct work_struct deferred_io_work;
+
+	struct r5l_policy *policy;
 };
 
 /*
@@ -127,6 +129,17 @@ enum r5l_io_unit_state {
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
2.10.1

