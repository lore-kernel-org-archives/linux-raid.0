From: Shaohua Li <shli@fb.com>
Subject: [PATCH 2/9] raid5-cache: add trim support for log
Date: Thu, 8 Oct 2015 21:54:06 -0700
Message-ID: <effe8247d5013e4951fd7efa06cc45efe66a94c4.1444360850.git.shli@fb.com>
References: <cover.1444360850.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cover.1444360850.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com, neilb@suse.de
List-Id: linux-raid.ids

Since superblock is updated infrequently, we do a simple trim of log
disk (a synchronous trim)

Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/raid5-cache.c | 63 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 62 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index caeec10..5dbe084 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -85,6 +85,7 @@ struct r5l_log {
 	spinlock_t no_space_stripes_lock;
 
 	bool need_cache_flush;
+	bool in_teardown;
 };
 
 /*
@@ -644,6 +645,60 @@ void r5l_flush_stripe_to_raid(struct r5l_log *log)
 }
 
 static void r5l_write_super(struct r5l_log *log, sector_t cp);
+static void r5l_write_super_and_discard_space(struct r5l_log *log,
+	sector_t end)
+{
+	struct block_device *bdev = log->rdev->bdev;
+	struct mddev *mddev;
+
+	r5l_write_super(log, end);
+
+	if (!blk_queue_discard(bdev_get_queue(bdev)))
+		return;
+
+	mddev = log->rdev->mddev;
+	/*
+	 * This is to avoid a deadlock. r5l_quiesce holds reconfig_mutex and
+	 * wait for this thread to finish. This thread waits for
+	 * MD_CHANGE_PENDING clear, which is supposed to be done in
+	 * md_check_recovery(). md_check_recovery() tries to get
+	 * reconfig_mutex. Since r5l_quiesce already holds the mutex,
+	 * md_check_recovery() fails, so the PENDING never get cleared. The
+	 * in_teardown check workaround this issue.
+	 * */
+	if (!log->in_teardown) {
+		set_bit(MD_CHANGE_DEVS, &mddev->flags);
+		set_bit(MD_CHANGE_PENDING, &mddev->flags);
+		md_wakeup_thread(mddev->thread);
+		wait_event(mddev->sb_wait,
+			!test_bit(MD_CHANGE_PENDING, &mddev->flags) ||
+			log->in_teardown);
+		/*
+		 * r5l_quiesce could run after in_teardown check and hold
+		 * mutex first. Superblock might get updated twice.
+		 * */
+		if (log->in_teardown)
+			md_update_sb(mddev, 1);
+	} else {
+		BUG_ON(!mddev_is_locked(mddev));
+		md_update_sb(mddev, 1);
+	}
+
+	if (log->last_checkpoint < end) {
+		blkdev_issue_discard(bdev,
+				log->last_checkpoint + log->rdev->data_offset,
+				end - log->last_checkpoint, GFP_NOIO, 0);
+	} else {
+		blkdev_issue_discard(bdev,
+				log->last_checkpoint + log->rdev->data_offset,
+				log->device_size - log->last_checkpoint,
+				GFP_NOIO, 0);
+		blkdev_issue_discard(bdev, log->rdev->data_offset, end,
+				GFP_NOIO, 0);
+	}
+}
+
+
 static void r5l_do_reclaim(struct r5l_log *log)
 {
 	sector_t reclaim_target = xchg(&log->reclaim_target, 0);
@@ -685,7 +740,7 @@ static void r5l_do_reclaim(struct r5l_log *log)
 	 * here, because the log area might be reused soon and we don't want to
 	 * confuse recovery
 	 */
-	r5l_write_super(log, next_checkpoint);
+	r5l_write_super_and_discard_space(log, next_checkpoint);
 
 	mutex_lock(&log->io_mutex);
 	log->last_checkpoint = next_checkpoint;
@@ -721,9 +776,11 @@ static void r5l_wake_reclaim(struct r5l_log *log, sector_t space)
 
 void r5l_quiesce(struct r5l_log *log, int state)
 {
+	struct mddev *mddev;
 	if (!log || state == 2)
 		return;
 	if (state == 0) {
+		log->in_teardown = 0;
 		log->reclaim_thread = md_register_thread(r5l_reclaim_thread,
 					log->rdev->mddev, "reclaim");
 	} else if (state == 1) {
@@ -731,6 +788,10 @@ void r5l_quiesce(struct r5l_log *log, int state)
 		 * at this point all stripes are finished, so io_unit is at
 		 * least in STRIPE_END state
 		 */
+		log->in_teardown = 1;
+		/* make sure r5l_write_super_and_discard_space exits */
+		mddev = log->rdev->mddev;
+		wake_up(&mddev->sb_wait);
 		r5l_wake_reclaim(log, -1L);
 		md_unregister_thread(&log->reclaim_thread);
 		r5l_do_reclaim(log);
-- 
2.4.6

