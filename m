From: Shaohua Li <shli@fb.com>
Subject: [PATCH 1/4] raid5-cache: use rcu api to access r5conf->log
Date: Tue, 5 Jan 2016 13:26:01 -0800
Message-ID: <b2e460b69224288a2b7dfc66f86672551cdb9319.1452028077.git.shli@fb.com>
References: <cover.1452028077.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cover.1452028077.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Kernel-team@fb.com, songliubraving@fb.com, neilb@suse.de
List-Id: linux-raid.ids

If we add journal disk to an array which isn't created with journal, IO
might be running in the array. We must be careful about the log checks
to make sure log is fully initialized, which is the job of
rcu_dereference(). Don't need rcu read lock protection here, as
hotremove only happens when there is no write requests.

Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/raid5-cache.c | 19 +++++++++++++------
 drivers/md/raid5.c       | 20 ++++++++++----------
 drivers/md/raid5.h       | 10 +++++-----
 3 files changed, 28 insertions(+), 21 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index d242a36..31e0fad 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -438,7 +438,7 @@ static void r5l_wake_reclaim(struct r5l_log *log, sector_t space);
  * running in raid5d, where reclaim could wait for raid5d too (when it flushes
  * data from log to raid disks), so we shouldn't wait for reclaim here
  */
-int r5l_write_stripe(struct r5l_log *log, struct stripe_head *sh)
+int r5l_write_stripe(struct r5conf *conf, struct stripe_head *sh)
 {
 	int write_disks = 0;
 	int data_pages, parity_pages;
@@ -446,6 +446,7 @@ int r5l_write_stripe(struct r5l_log *log, struct stripe_head *sh)
 	int reserve;
 	int i;
 	int ret = 0;
+	struct r5l_log *log = rcu_dereference(conf->log);
 
 	if (!log)
 		return -EAGAIN;
@@ -513,8 +514,9 @@ int r5l_write_stripe(struct r5l_log *log, struct stripe_head *sh)
 	return 0;
 }
 
-void r5l_write_stripe_run(struct r5l_log *log)
+void r5l_write_stripe_run(struct r5conf *conf)
 {
+	struct r5l_log *log = rcu_dereference(conf->log);
 	if (!log)
 		return;
 	mutex_lock(&log->io_mutex);
@@ -522,8 +524,10 @@ void r5l_write_stripe_run(struct r5l_log *log)
 	mutex_unlock(&log->io_mutex);
 }
 
-int r5l_handle_flush_request(struct r5l_log *log, struct bio *bio)
+int r5l_handle_flush_request(struct r5conf *conf, struct bio *bio)
 {
+	struct r5l_log *log = ACCESS_ONCE(conf->log);
+
 	if (!log)
 		return -ENODEV;
 	/*
@@ -664,9 +668,10 @@ static void r5l_log_flush_endio(struct bio *bio)
  * only write stripes of an io_unit to raid disks till the io_unit is the first
  * one whose data/parity is in log.
  */
-void r5l_flush_stripe_to_raid(struct r5l_log *log)
+void r5l_flush_stripe_to_raid(struct r5conf *conf)
 {
 	bool do_flush;
+	struct r5l_log *log = rcu_dereference(conf->log);
 
 	if (!log || !log->need_cache_flush)
 		return;
@@ -800,7 +805,7 @@ static void r5l_reclaim_thread(struct md_thread *thread)
 {
 	struct mddev *mddev = thread->mddev;
 	struct r5conf *conf = mddev->private;
-	struct r5l_log *log = conf->log;
+	struct r5l_log *log = rcu_dereference(conf->log);
 
 	if (!log)
 		return;
@@ -820,9 +825,11 @@ static void r5l_wake_reclaim(struct r5l_log *log, sector_t space)
 	md_wakeup_thread(log->reclaim_thread);
 }
 
-void r5l_quiesce(struct r5l_log *log, int state)
+void r5l_quiesce(struct r5conf *conf, int state)
 {
 	struct mddev *mddev;
+	struct r5l_log *log = rcu_dereference(conf->log);
+
 	if (!log || state == 2)
 		return;
 	if (state == 0) {
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index a086014..e74ead1 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -757,7 +757,7 @@ static bool stripe_can_batch(struct stripe_head *sh)
 {
 	struct r5conf *conf = sh->raid_conf;
 
-	if (conf->log)
+	if (ACCESS_ONCE(conf->log))
 		return false;
 	return test_bit(STRIPE_BATCH_READY, &sh->state) &&
 		!test_bit(STRIPE_BITMAP_PENDING, &sh->state) &&
@@ -897,7 +897,7 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 
 	might_sleep();
 
-	if (r5l_write_stripe(conf->log, sh) == 0)
+	if (r5l_write_stripe(conf, sh) == 0)
 		return;
 	for (i = disks; i--; ) {
 		int rw;
@@ -5148,7 +5148,7 @@ static void make_request(struct mddev *mddev, struct bio * bi)
 	bool do_prepare;
 
 	if (unlikely(bi->bi_rw & REQ_FLUSH)) {
-		int ret = r5l_handle_flush_request(conf->log, bi);
+		int ret = r5l_handle_flush_request(conf, bi);
 
 		if (ret == 0)
 			return;
@@ -5751,7 +5751,7 @@ static int handle_active_stripes(struct r5conf *conf, int group,
 				break;
 		if (i == NR_STRIPE_HASH_LOCKS) {
 			spin_unlock_irq(&conf->device_lock);
-			r5l_flush_stripe_to_raid(conf->log);
+			r5l_flush_stripe_to_raid(conf);
 			spin_lock_irq(&conf->device_lock);
 			return batch_size;
 		}
@@ -5762,7 +5762,7 @@ static int handle_active_stripes(struct r5conf *conf, int group,
 	release_inactive_stripe_list(conf, temp_inactive_list,
 				     NR_STRIPE_HASH_LOCKS);
 
-	r5l_flush_stripe_to_raid(conf->log);
+	r5l_flush_stripe_to_raid(conf);
 	if (release_inactive) {
 		spin_lock_irq(&conf->device_lock);
 		return 0;
@@ -5770,7 +5770,7 @@ static int handle_active_stripes(struct r5conf *conf, int group,
 
 	for (i = 0; i < batch_size; i++)
 		handle_stripe(batch[i]);
-	r5l_write_stripe_run(conf->log);
+	r5l_write_stripe_run(conf);
 
 	cond_resched();
 
@@ -5904,7 +5904,7 @@ static void raid5d(struct md_thread *thread)
 		mutex_unlock(&conf->cache_size_mutex);
 	}
 
-	r5l_flush_stripe_to_raid(conf->log);
+	r5l_flush_stripe_to_raid(conf);
 
 	async_tx_issue_pending_all();
 	blk_finish_plug(&plug);
@@ -7291,7 +7291,7 @@ static int raid5_resize(struct mddev *mddev, sector_t sectors)
 	sector_t newsize;
 	struct r5conf *conf = mddev->private;
 
-	if (conf->log)
+	if (ACCESS_ONCE(conf->log))
 		return -EINVAL;
 	sectors &= ~((sector_t)conf->chunk_sectors - 1);
 	newsize = raid5_size(mddev, sectors, mddev->raid_disks);
@@ -7344,7 +7344,7 @@ static int check_reshape(struct mddev *mddev)
 {
 	struct r5conf *conf = mddev->private;
 
-	if (conf->log)
+	if (ACCESS_ONCE(conf->log))
 		return -EINVAL;
 	if (mddev->delta_disks == 0 &&
 	    mddev->new_layout == mddev->layout &&
@@ -7622,7 +7622,7 @@ static void raid5_quiesce(struct mddev *mddev, int state)
 		unlock_all_device_hash_locks_irq(conf);
 		break;
 	}
-	r5l_quiesce(conf->log, state);
+	r5l_quiesce(conf, state);
 }
 
 static void *raid45_takeover_raid0(struct mddev *mddev, int level)
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index a415e1c..96969fb 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -626,11 +626,11 @@ raid5_get_active_stripe(struct r5conf *conf, sector_t sector,
 			int previous, int noblock, int noquiesce);
 extern int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev);
 extern void r5l_exit_log(struct r5l_log *log);
-extern int r5l_write_stripe(struct r5l_log *log, struct stripe_head *head_sh);
-extern void r5l_write_stripe_run(struct r5l_log *log);
-extern void r5l_flush_stripe_to_raid(struct r5l_log *log);
+extern int r5l_write_stripe(struct r5conf *conf, struct stripe_head *head_sh);
+extern void r5l_write_stripe_run(struct r5conf *conf);
+extern void r5l_flush_stripe_to_raid(struct r5conf *conf);
 extern void r5l_stripe_write_finished(struct stripe_head *sh);
-extern int r5l_handle_flush_request(struct r5l_log *log, struct bio *bio);
-extern void r5l_quiesce(struct r5l_log *log, int state);
+extern int r5l_handle_flush_request(struct r5conf *conf, struct bio *bio);
+extern void r5l_quiesce(struct r5conf *conf, int state);
 extern bool r5l_log_disk_error(struct r5conf *conf);
 #endif
-- 
2.4.6

