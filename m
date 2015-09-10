From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH] Remove unused argument in md_new_event()
Date: Thu, 10 Sep 2015 07:41:59 -0500
Message-ID: <20150910124159.GA14214@shrek.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Code cleanup:

  - Removed md_new_event_inintr() because md_new_event() and
    md_new_event_inintr() are the same.

  - Removed mddev argument passed to md_new_event() because it is
    not used.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 drivers/md/md.c     | 37 ++++++++++++++-----------------------
 drivers/md/md.h     |  2 +-
 drivers/md/raid10.c |  2 +-
 drivers/md/raid5.c  |  2 +-
 4 files changed, 17 insertions(+), 26 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 4f5ecbe..c4b2c1e 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -198,22 +198,13 @@ EXPORT_SYMBOL_GPL(bio_clone_mddev);
  */
 static DECLARE_WAIT_QUEUE_HEAD(md_event_waiters);
 static atomic_t md_event_count;
-void md_new_event(struct mddev *mddev)
+void md_new_event()
 {
 	atomic_inc(&md_event_count);
 	wake_up(&md_event_waiters);
 }
 EXPORT_SYMBOL_GPL(md_new_event);
 
-/* Alternate version that can be called from interrupts
- * when calling sysfs_notify isn't needed.
- */
-static void md_new_event_inintr(struct mddev *mddev)
-{
-	atomic_inc(&md_event_count);
-	wake_up(&md_event_waiters);
-}
-
 /*
  * Enables to iterate over all existing md arrays
  * all_mddevs_lock protects this list.
@@ -2384,7 +2375,7 @@ static int add_bound_rdev(struct md_rdev *rdev)
 	if (mddev->degraded)
 		set_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
 	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
-	md_new_event(mddev);
+	md_new_event();
 	md_wakeup_thread(mddev->thread);
 	return 0;
 }
@@ -2497,7 +2488,7 @@ state_store(struct md_rdev *rdev, const char *buf, size_t len)
 				md_cluster_ops->metadata_update_start(mddev);
 			if (mddev->pers)
 				md_update_sb(mddev, 1);
-			md_new_event(mddev);
+			md_new_event();
 			if (mddev_is_clustered(mddev))
 				md_cluster_ops->metadata_update_finish(mddev);
 			err = 0;
@@ -3502,7 +3493,7 @@ level_store(struct mddev *mddev, const char *buf, size_t len)
 	if (!mddev->thread)
 		md_update_sb(mddev, 1);
 	sysfs_notify(&mddev->kobj, NULL, "level");
-	md_new_event(mddev);
+	md_new_event();
 	rv = len;
 out_unlock:
 	mddev_unlock(mddev);
@@ -5205,7 +5196,7 @@ int md_run(struct mddev *mddev)
 	if (mddev->flags & MD_UPDATE_SB_FLAGS)
 		md_update_sb(mddev, 0);
 
-	md_new_event(mddev);
+	md_new_event();
 	sysfs_notify_dirent_safe(mddev->sysfs_state);
 	sysfs_notify_dirent_safe(mddev->sysfs_action);
 	sysfs_notify(&mddev->kobj, NULL, "degraded");
@@ -5539,7 +5530,7 @@ static int do_md_stop(struct mddev *mddev, int mode,
 			mddev->hold_active = 0;
 	}
 	blk_integrity_unregister(disk);
-	md_new_event(mddev);
+	md_new_event();
 	sysfs_notify_dirent_safe(mddev->sysfs_state);
 	return 0;
 }
@@ -6008,7 +5999,7 @@ static int hot_remove_disk(struct mddev *mddev, dev_t dev)
 
 	md_kick_rdev_from_array(rdev);
 	md_update_sb(mddev, 1);
-	md_new_event(mddev);
+	md_new_event();
 
 	if (mddev_is_clustered(mddev))
 		md_cluster_ops->metadata_update_finish(mddev);
@@ -6093,7 +6084,7 @@ static int hot_add_disk(struct mddev *mddev, dev_t dev)
 	 */
 	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 	md_wakeup_thread(mddev->thread);
-	md_new_event(mddev);
+	md_new_event();
 	return 0;
 
 abort_clustered:
@@ -7050,7 +7041,7 @@ void md_error(struct mddev *mddev, struct md_rdev *rdev)
 	md_wakeup_thread(mddev->thread);
 	if (mddev->event_work.func)
 		queue_work(md_misc_wq, &mddev->event_work);
-	md_new_event_inintr(mddev);
+	md_new_event();
 }
 EXPORT_SYMBOL(md_error);
 
@@ -7795,7 +7786,7 @@ void md_do_sync(struct md_thread *thread)
 		mddev->curr_resync = 3; /* no longer delayed */
 	mddev->curr_resync_completed = j;
 	sysfs_notify(&mddev->kobj, NULL, "sync_completed");
-	md_new_event(mddev);
+	md_new_event();
 	update_time = jiffies;
 
 	if (mddev_is_clustered(mddev))
@@ -7871,7 +7862,7 @@ void md_do_sync(struct md_thread *thread)
 			/* this is the earliest that rebuild will be
 			 * visible in /proc/mdstat
 			 */
-			md_new_event(mddev);
+			md_new_event();
 
 		if (last_check + window > io_sectors || j == max_sectors)
 			continue;
@@ -8043,7 +8034,7 @@ static int remove_and_add_spares(struct mddev *mddev,
 			if (sysfs_link_rdev(mddev, rdev))
 				/* failure here is OK */;
 			spares++;
-			md_new_event(mddev);
+			md_new_event();
 			set_bit(MD_CHANGE_DEVS, &mddev->flags);
 		}
 	}
@@ -8078,7 +8069,7 @@ static void md_start_sync(struct work_struct *ws)
 	} else
 		md_wakeup_thread(mddev->sync_thread);
 	sysfs_notify_dirent_safe(mddev->sysfs_action);
-	md_new_event(mddev);
+	md_new_event();
 }
 
 /*
@@ -8311,7 +8302,7 @@ void md_reap_sync_thread(struct mddev *mddev)
 	/* flag recovery needed just to double check */
 	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 	sysfs_notify_dirent_safe(mddev->sysfs_action);
-	md_new_event(mddev);
+	md_new_event();
 	if (mddev->event_work.func)
 		queue_work(md_misc_wq, &mddev->event_work);
 }
diff --git a/drivers/md/md.h b/drivers/md/md.h
index ab33957..c8f2519c 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -634,7 +634,7 @@ extern void md_super_wait(struct mddev *mddev);
 extern int sync_page_io(struct md_rdev *rdev, sector_t sector, int size,
 			struct page *page, int rw, bool metadata_op);
 extern void md_do_sync(struct md_thread *thread);
-extern void md_new_event(struct mddev *mddev);
+extern void md_new_event(void);
 extern int md_allow_write(struct mddev *mddev);
 extern void md_wait_for_blocked_rdev(struct md_rdev *rdev, struct mddev *mddev);
 extern void md_set_array_sectors(struct mddev *mddev, sector_t array_sectors);
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 0fc33eb..c24fc98 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -4068,7 +4068,7 @@ static int raid10_start_reshape(struct mddev *mddev)
 	}
 	conf->reshape_checkpoint = jiffies;
 	md_wakeup_thread(mddev->sync_thread);
-	md_new_event(mddev);
+	md_new_event();
 	return 0;
 
 abort:
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 15ef2c6..ea4052a 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7420,7 +7420,7 @@ static int raid5_start_reshape(struct mddev *mddev)
 	}
 	conf->reshape_checkpoint = jiffies;
 	md_wakeup_thread(mddev->sync_thread);
-	md_new_event(mddev);
+	md_new_event();
 	return 0;
 }
 
-- 
2.1.4

