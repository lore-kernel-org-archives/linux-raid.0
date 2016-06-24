From: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Subject: [PATCH] raid10: improve random reads performance
Date: Fri, 24 Jun 2016 14:20:16 +0200
Message-ID: <1466770816-5227-1-git-send-email-tomasz.majchrzak@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

RAID10 random read performance is lower than expected due to excessive spinlock
utilisation which is required mostly for rebuild/resync. Simplify allow_barrier
as it's in IO path and encounters a lot of unnecessary congestion.

As lower_barrier just takes a lock in order to decrement a counter, convert
counter (nr_pending) into atomic variable and remove the spin lock. There is
also a congestion for wake_up (it uses lock internally) so call it only when
it's really needed. As wake_up is not called constantly anymore, ensure process
waiting to raise a barrier is notified when there are no more waiting IOs.

Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
---
 drivers/md/raid10.c | 21 ++++++++++++---------
 drivers/md/raid10.h |  3 ++-
 2 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index e3fd725..cdbe504 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -913,7 +913,7 @@ static void raise_barrier(struct r10conf *conf, int force)
 
 	/* Now wait for all pending IO to complete */
 	wait_event_lock_irq(conf->wait_barrier,
-			    !conf->nr_pending && conf->barrier < RESYNC_DEPTH,
+			    !atomic_read(&conf->nr_pending) && conf->barrier < RESYNC_DEPTH,
 			    conf->resync_lock);
 
 	spin_unlock_irq(&conf->resync_lock);
@@ -944,23 +944,23 @@ static void wait_barrier(struct r10conf *conf)
 		 */
 		wait_event_lock_irq(conf->wait_barrier,
 				    !conf->barrier ||
-				    (conf->nr_pending &&
+				    (atomic_read(&conf->nr_pending) &&
 				     current->bio_list &&
 				     !bio_list_empty(current->bio_list)),
 				    conf->resync_lock);
 		conf->nr_waiting--;
+		if (!conf->nr_waiting)
+			wake_up(&conf->wait_barrier);
 	}
-	conf->nr_pending++;
+	atomic_inc(&conf->nr_pending);
 	spin_unlock_irq(&conf->resync_lock);
 }
 
 static void allow_barrier(struct r10conf *conf)
 {
-	unsigned long flags;
-	spin_lock_irqsave(&conf->resync_lock, flags);
-	conf->nr_pending--;
-	spin_unlock_irqrestore(&conf->resync_lock, flags);
-	wake_up(&conf->wait_barrier);
+	if ((atomic_dec_and_test(&conf->nr_pending)) ||
+			(conf->array_freeze_pending))
+		wake_up(&conf->wait_barrier);
 }
 
 static void freeze_array(struct r10conf *conf, int extra)
@@ -978,13 +978,15 @@ static void freeze_array(struct r10conf *conf, int extra)
 	 * we continue.
 	 */
 	spin_lock_irq(&conf->resync_lock);
+	conf->array_freeze_pending++;
 	conf->barrier++;
 	conf->nr_waiting++;
 	wait_event_lock_irq_cmd(conf->wait_barrier,
-				conf->nr_pending == conf->nr_queued+extra,
+				atomic_read(&conf->nr_pending) == conf->nr_queued+extra,
 				conf->resync_lock,
 				flush_pending_writes(conf));
 
+	conf->array_freeze_pending--;
 	spin_unlock_irq(&conf->resync_lock);
 }
 
@@ -3505,6 +3507,7 @@ static struct r10conf *setup_conf(struct mddev *mddev)
 
 	spin_lock_init(&conf->resync_lock);
 	init_waitqueue_head(&conf->wait_barrier);
+	atomic_set(&conf->nr_pending, 0);
 
 	conf->thread = md_register_thread(raid10d, mddev, "raid10");
 	if (!conf->thread)
diff --git a/drivers/md/raid10.h b/drivers/md/raid10.h
index 6fc2c75..18ec1f7 100644
--- a/drivers/md/raid10.h
+++ b/drivers/md/raid10.h
@@ -64,10 +64,11 @@ struct r10conf {
 	int			pending_count;
 
 	spinlock_t		resync_lock;
-	int			nr_pending;
+	atomic_t		nr_pending;
 	int			nr_waiting;
 	int			nr_queued;
 	int			barrier;
+	int			array_freeze_pending;
 	sector_t		next_resync;
 	int			fullsync;  /* set to 1 if a full sync is needed,
 					    * (fresh device added).
-- 
1.8.3.1

