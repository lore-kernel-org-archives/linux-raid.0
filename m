From: Shaohua Li <shli@fb.com>
Subject: [PATCH 4/8] raid5-cache: fix a user-after-free bug
Date: Wed, 2 Sep 2015 13:49:47 -0700
Message-ID: <dba05fc30825847c478ca88b767099f23138c37e.1441221530.git.shli@fb.com>
References: <cover.1441221530.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cover.1441221530.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com, neilb@suse.de
List-Id: linux-raid.ids

r5l_compress_stripe_end_list() can free an io_unit. This breaks the
assumption only reclaimer can free io_unit. We can add a reference count
based io_unit free, but since only reclaim can wait io_unit becoming to
STRIPE_END state, we use a simple global wait queue here.

Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/raid5-cache.c | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 86b836c..2f5e2b8 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -78,6 +78,7 @@ struct r5l_log {
 				  * which are in IO_UNIT_STRIPE_END state (eg,
 				  * reclaim dones't wait for specific io_unit
 				  * switching to IO_UNIT_STRIPE_END state) */
+	wait_queue_head_t iounit_wait;
 
 	struct list_head no_space_stripes; /* pending stripes, log has no space */
 	spinlock_t no_space_stripes_lock;
@@ -108,7 +109,6 @@ struct r5l_io_unit {
 	struct list_head stripe_list; /* stripes added to the io_unit */
 
 	int state;
-	wait_queue_head_t wait_state;
 };
 
 /* r5l_io_unit state */
@@ -161,7 +161,6 @@ static struct r5l_io_unit *r5l_alloc_io_unit(struct r5l_log *log)
 	INIT_LIST_HEAD(&io->log_sibling);
 	INIT_LIST_HEAD(&io->stripe_list);
 	io->state = IO_UNIT_RUNNING;
-	init_waitqueue_head(&io->wait_state);
 	return io;
 }
 
@@ -242,8 +241,8 @@ static void __r5l_set_io_unit_state(struct r5l_io_unit *io,
 			r5l_wake_reclaim(log, 0);
 
 		r5l_compress_stripe_end_list(log);
+		wake_up(&log->iounit_wait);
 	}
-	wake_up(&io->wait_state);
 }
 
 static void r5l_set_io_unit_state(struct r5l_io_unit *io,
@@ -617,10 +616,11 @@ void r5l_flush_stripe_to_raid(struct r5l_log *log)
 	submit_bio(WRITE_FLUSH, &log->flush_bio);
 }
 
-static void r5l_kick_io_unit(struct r5l_log *log, struct r5l_io_unit *io)
+static void r5l_kick_io_unit(struct r5l_log *log)
 {
 	md_wakeup_thread(log->rdev->mddev->thread);
-	wait_event(io->wait_state, io->state >= IO_UNIT_STRIPE_END);
+	wait_event_lock_irq(log->iounit_wait, !list_empty(&log->stripe_end_ios),
+		log->io_list_lock);
 }
 
 static void r5l_write_super(struct r5l_log *log, sector_t cp);
@@ -665,12 +665,7 @@ static void r5l_do_reclaim(struct r5l_log *log)
 		else if (!list_empty(&log->running_ios))
 			target_list = &log->running_ios;
 
-		io = list_first_entry(target_list,
-			struct r5l_io_unit, log_sibling);
-		spin_unlock_irq(&log->io_list_lock);
-		/* nobody else can delete the io, we are safe */
-		r5l_kick_io_unit(log, io);
-		spin_lock_irq(&log->io_list_lock);
+		r5l_kick_io_unit(log);
 	}
 	spin_unlock_irq(&log->io_list_lock);
 
@@ -1071,6 +1066,7 @@ int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
 		log->rdev->mddev, "reclaim");
 	if (!log->reclaim_thread)
 		goto reclaim_thread;
+	init_waitqueue_head(&log->iounit_wait);
 
 	INIT_LIST_HEAD(&log->no_space_stripes);
 	spin_lock_init(&log->no_space_stripes_lock);
-- 
1.8.1

