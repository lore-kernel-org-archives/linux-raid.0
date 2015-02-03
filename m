From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 06/26] md: rename mddev->write_lock to mddev->lock
Date: Wed, 04 Feb 2015 08:42:28 +1100
Message-ID: <20150203214228.3448.16273.stgit@notabene.brown>
References: <20150203213948.3448.80258.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150203213948.3448.80258.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This lock is used for (slightly) more than helping with writing
superblocks, and it will soon be extended further.  So the
name is inappropriate.

Also, the _irq variant hasn't been needed since 2.6.37 as it is
never taking from interrupt or bh context.

So:
  -rename write_lock to lock
  -document what it protects
  -remove _irq ... except in md_flush_request() as there
     is no wait_event_lock() (with no _irq).  This can be
     cleaned up after appropriate changes to wait.h.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/md.c |   36 ++++++++++++++++++------------------
 drivers/md/md.h |    8 +++++++-
 2 files changed, 25 insertions(+), 19 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 709755fb6d7b..17e7fd776034 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -397,12 +397,12 @@ static void md_submit_flush_data(struct work_struct *ws)
 
 void md_flush_request(struct mddev *mddev, struct bio *bio)
 {
-	spin_lock_irq(&mddev->write_lock);
+	spin_lock_irq(&mddev->lock);
 	wait_event_lock_irq(mddev->sb_wait,
 			    !mddev->flush_bio,
-			    mddev->write_lock);
+			    mddev->lock);
 	mddev->flush_bio = bio;
-	spin_unlock_irq(&mddev->write_lock);
+	spin_unlock_irq(&mddev->lock);
 
 	INIT_WORK(&mddev->flush_work, submit_flushes);
 	queue_work(md_wq, &mddev->flush_work);
@@ -465,7 +465,7 @@ void mddev_init(struct mddev *mddev)
 	atomic_set(&mddev->active, 1);
 	atomic_set(&mddev->openers, 0);
 	atomic_set(&mddev->active_io, 0);
-	spin_lock_init(&mddev->write_lock);
+	spin_lock_init(&mddev->lock);
 	atomic_set(&mddev->flush_pending, 0);
 	init_waitqueue_head(&mddev->sb_wait);
 	init_waitqueue_head(&mddev->recovery_wait);
@@ -2230,7 +2230,7 @@ repeat:
 		return;
 	}
 
-	spin_lock_irq(&mddev->write_lock);
+	spin_lock(&mddev->lock);
 
 	mddev->utime = get_seconds();
 
@@ -2287,7 +2287,7 @@ repeat:
 	}
 
 	sync_sbs(mddev, nospares);
-	spin_unlock_irq(&mddev->write_lock);
+	spin_unlock(&mddev->lock);
 
 	pr_debug("md: updating %s RAID superblock on device (in sync %d)\n",
 		 mdname(mddev), mddev->in_sync);
@@ -2326,15 +2326,15 @@ repeat:
 	md_super_wait(mddev);
 	/* if there was a failure, MD_CHANGE_DEVS was set, and we re-write super */
 
-	spin_lock_irq(&mddev->write_lock);
+	spin_lock(&mddev->lock);
 	if (mddev->in_sync != sync_req ||
 	    test_bit(MD_CHANGE_DEVS, &mddev->flags)) {
 		/* have to write it out again */
-		spin_unlock_irq(&mddev->write_lock);
+		spin_unlock(&mddev->lock);
 		goto repeat;
 	}
 	clear_bit(MD_CHANGE_PENDING, &mddev->flags);
-	spin_unlock_irq(&mddev->write_lock);
+	spin_unlock(&mddev->lock);
 	wake_up(&mddev->sb_wait);
 	if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
 		sysfs_notify(&mddev->kobj, NULL, "sync_completed");
@@ -3722,7 +3722,7 @@ array_state_store(struct mddev *mddev, const char *buf, size_t len)
 	case clean:
 		if (mddev->pers) {
 			restart_array(mddev);
-			spin_lock_irq(&mddev->write_lock);
+			spin_lock(&mddev->lock);
 			if (atomic_read(&mddev->writes_pending) == 0) {
 				if (mddev->in_sync == 0) {
 					mddev->in_sync = 1;
@@ -3733,7 +3733,7 @@ array_state_store(struct mddev *mddev, const char *buf, size_t len)
 				err = 0;
 			} else
 				err = -EBUSY;
-			spin_unlock_irq(&mddev->write_lock);
+			spin_unlock(&mddev->lock);
 		} else
 			err = -EINVAL;
 		break;
@@ -7102,7 +7102,7 @@ void md_write_start(struct mddev *mddev, struct bio *bi)
 	if (mddev->safemode == 1)
 		mddev->safemode = 0;
 	if (mddev->in_sync) {
-		spin_lock_irq(&mddev->write_lock);
+		spin_lock(&mddev->lock);
 		if (mddev->in_sync) {
 			mddev->in_sync = 0;
 			set_bit(MD_CHANGE_CLEAN, &mddev->flags);
@@ -7110,7 +7110,7 @@ void md_write_start(struct mddev *mddev, struct bio *bi)
 			md_wakeup_thread(mddev->thread);
 			did_change = 1;
 		}
-		spin_unlock_irq(&mddev->write_lock);
+		spin_unlock(&mddev->lock);
 	}
 	if (did_change)
 		sysfs_notify_dirent_safe(mddev->sysfs_state);
@@ -7148,7 +7148,7 @@ int md_allow_write(struct mddev *mddev)
 	if (!mddev->pers->sync_request)
 		return 0;
 
-	spin_lock_irq(&mddev->write_lock);
+	spin_lock(&mddev->lock);
 	if (mddev->in_sync) {
 		mddev->in_sync = 0;
 		set_bit(MD_CHANGE_CLEAN, &mddev->flags);
@@ -7156,11 +7156,11 @@ int md_allow_write(struct mddev *mddev)
 		if (mddev->safemode_delay &&
 		    mddev->safemode == 0)
 			mddev->safemode = 1;
-		spin_unlock_irq(&mddev->write_lock);
+		spin_unlock(&mddev->lock);
 		md_update_sb(mddev, 0);
 		sysfs_notify_dirent_safe(mddev->sysfs_state);
 	} else
-		spin_unlock_irq(&mddev->write_lock);
+		spin_unlock(&mddev->lock);
 
 	if (test_bit(MD_CHANGE_PENDING, &mddev->flags))
 		return -EAGAIN;
@@ -7688,7 +7688,7 @@ void md_check_recovery(struct mddev *mddev)
 
 		if (!mddev->external) {
 			int did_change = 0;
-			spin_lock_irq(&mddev->write_lock);
+			spin_lock(&mddev->lock);
 			if (mddev->safemode &&
 			    !atomic_read(&mddev->writes_pending) &&
 			    !mddev->in_sync &&
@@ -7699,7 +7699,7 @@ void md_check_recovery(struct mddev *mddev)
 			}
 			if (mddev->safemode == 1)
 				mddev->safemode = 0;
-			spin_unlock_irq(&mddev->write_lock);
+			spin_unlock(&mddev->lock);
 			if (did_change)
 				sysfs_notify_dirent_safe(mddev->sysfs_state);
 		}
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 03cec5bdcaae..f0d15bdd96d4 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -386,7 +386,13 @@ struct mddev {
 
 	struct work_struct del_work;	/* used for delayed sysfs removal */
 
-	spinlock_t			write_lock;
+	/* "lock" protects:
+	 *   flush_bio transition from NULL to !NULL
+	 *   rdev superblocks, events
+	 *   clearing MD_CHANGE_*
+	 *   in_sync - and related safemode and MD_CHANGE changes
+	 */
+	spinlock_t			lock;
 	wait_queue_head_t		sb_wait;	/* for waiting on superblock updates */
 	atomic_t			pending_writes;	/* number of active superblock writes */
 


