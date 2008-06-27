From: NeilBrown <neilb@suse.de>
Subject: [PATCH 015 of 29] md: Make sure all changes to md/sync_action are notified.
Date: Fri, 27 Jun 2008 16:50:57 +1000
Message-ID: <1080627065057.10543@suse.de>
References: <20080627164503.9671.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


When the 'resync' thread starts or stops, when we explicitly
set sync_action, or when we determine that there is definitely nothing
to do, we notify sync_action.

To stop "sync_action" from occasionally showing the wrong value,
we introduce a new flags - MD_RECOVERY_RECOVER - to say that a 
recovery is probably needed or happening, and we make sure
that we set MD_RECOVERY_RUNNING before clearing MD_RECOVERY_NEEDED.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./Documentation/md.txt      |    6 ++++++
 ./drivers/md/md.c           |   34 ++++++++++++++++++++++++++++------
 ./include/linux/raid/md_k.h |    2 ++
 3 files changed, 36 insertions(+), 6 deletions(-)

diff .prev/Documentation/md.txt ./Documentation/md.txt
--- .prev/Documentation/md.txt	2008-06-27 16:22:01.000000000 +1000
+++ ./Documentation/md.txt	2008-06-27 16:22:02.000000000 +1000
@@ -386,6 +386,12 @@ also have
 	'check' and 'repair' will start the appropriate process
            providing the current state is 'idle'.
 
+      This file responds to select/poll.  Any important change in the value
+      triggers a poll event.  Sometimes the value will briefly be
+      "recover" if a recovery seems to be needed, but cannot be
+      achieved. In that case, the transition to "recover" isn't
+      notified, but the transition away is.
+
    mismatch_count
       When performing 'check' and 'repair', and possibly when
       performing 'resync', md will count the number of errors that are

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2008-06-27 16:22:01.000000000 +1000
+++ ./drivers/md/md.c	2008-06-27 16:22:02.000000000 +1000
@@ -169,7 +169,6 @@ void md_new_event(mddev_t *mddev)
 {
 	atomic_inc(&md_event_count);
 	wake_up(&md_event_waiters);
-	sysfs_notify(&mddev->kobj, NULL, "sync_action");
 }
 EXPORT_SYMBOL_GPL(md_new_event);
 
@@ -2936,7 +2935,7 @@ action_show(mddev_t *mddev, char *page)
 				type = "check";
 			else
 				type = "repair";
-		} else
+		} else if (test_bit(MD_RECOVERY_RECOVER, &mddev->recovery))
 			type = "recover";
 	}
 	return sprintf(page, "%s\n", type);
@@ -2958,9 +2957,12 @@ action_store(mddev_t *mddev, const char 
 	} else if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) ||
 		   test_bit(MD_RECOVERY_NEEDED, &mddev->recovery))
 		return -EBUSY;
-	else if (cmd_match(page, "resync") || cmd_match(page, "recover"))
+	else if (cmd_match(page, "resync"))
+		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
+	else if (cmd_match(page, "recover")) {
+		set_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
 		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
-	else if (cmd_match(page, "reshape")) {
+	} else if (cmd_match(page, "reshape")) {
 		int err;
 		if (mddev->pers->start_reshape == NULL)
 			return -EINVAL;
@@ -2977,6 +2979,7 @@ action_store(mddev_t *mddev, const char 
 	}
 	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 	md_wakeup_thread(mddev->thread);
+	sysfs_notify(&mddev->kobj, NULL, "sync_action");
 	return len;
 }
 
@@ -3682,6 +3685,7 @@ static int do_md_run(mddev_t * mddev)
 	mddev->changed = 1;
 	md_new_event(mddev);
 	sysfs_notify(&mddev->kobj, NULL, "array_state");
+	sysfs_notify(&mddev->kobj, NULL, "sync_action");
 	kobject_uevent(&mddev->gendisk->dev.kobj, KOBJ_CHANGE);
 	return 0;
 }
@@ -4252,6 +4256,8 @@ static int add_new_disk(mddev_t * mddev,
 			export_rdev(rdev);
 
 		md_update_sb(mddev, 1);
+		if (mddev->degraded)
+			set_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
 		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 		md_wakeup_thread(mddev->thread);
 		return err;
@@ -5105,6 +5111,8 @@ void md_error(mddev_t *mddev, mdk_rdev_t
 	if (!mddev->pers->error_handler)
 		return;
 	mddev->pers->error_handler(mddev,rdev);
+	if (mddev->degraded)
+		set_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
 	set_bit(MD_RECOVERY_INTR, &mddev->recovery);
 	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 	md_wakeup_thread(mddev->thread);
@@ -6055,13 +6063,18 @@ void md_check_recovery(mddev_t *mddev)
 			mddev->recovery = 0;
 			/* flag recovery needed just to double check */
 			set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
+			sysfs_notify(&mddev->kobj, NULL, "sync_action");
 			md_new_event(mddev);
 			goto unlock;
 		}
+		/* Set RUNNING before clearing NEEDED to avoid
+		 * any transients in the value of "sync_action".
+		 */
+		set_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
+		clear_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 		/* Clear some bits that don't mean anything, but
 		 * might be left set
 		 */
-		clear_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 		clear_bit(MD_RECOVERY_INTR, &mddev->recovery);
 		clear_bit(MD_RECOVERY_DONE, &mddev->recovery);
 
@@ -6079,17 +6092,19 @@ void md_check_recovery(mddev_t *mddev)
 				/* Cannot proceed */
 				goto unlock;
 			set_bit(MD_RECOVERY_RESHAPE, &mddev->recovery);
+			clear_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
 		} else if ((spares = remove_and_add_spares(mddev))) {
 			clear_bit(MD_RECOVERY_SYNC, &mddev->recovery);
 			clear_bit(MD_RECOVERY_CHECK, &mddev->recovery);
+			set_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
 		} else if (mddev->recovery_cp < MaxSector) {
 			set_bit(MD_RECOVERY_SYNC, &mddev->recovery);
+			clear_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
 		} else if (!test_bit(MD_RECOVERY_SYNC, &mddev->recovery))
 			/* nothing to be done ... */
 			goto unlock;
 
 		if (mddev->pers->sync_request) {
-			set_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
 			if (spares && mddev->bitmap && ! mddev->bitmap->file) {
 				/* We are adding a device or devices to an array
 				 * which has the bitmap stored on all devices.
@@ -6108,9 +6123,16 @@ void md_check_recovery(mddev_t *mddev)
 				mddev->recovery = 0;
 			} else
 				md_wakeup_thread(mddev->sync_thread);
+			sysfs_notify(&mddev->kobj, NULL, "sync_action");
 			md_new_event(mddev);
 		}
 	unlock:
+		if (!mddev->sync_thread) {
+			clear_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
+			if (test_and_clear_bit(MD_RECOVERY_RECOVER,
+					       &mddev->recovery))
+				sysfs_notify(&mddev->kobj, NULL, "sync_action");
+		}
 		mddev_unlock(mddev);
 	}
 }

diff .prev/include/linux/raid/md_k.h ./include/linux/raid/md_k.h
--- .prev/include/linux/raid/md_k.h	2008-06-27 16:20:34.000000000 +1000
+++ ./include/linux/raid/md_k.h	2008-06-27 16:22:02.000000000 +1000
@@ -188,6 +188,7 @@ struct mddev_s
 	 * NEEDED:   we might need to start a resync/recover
 	 * RUNNING:  a thread is running, or about to be started
 	 * SYNC:     actually doing a resync, not a recovery
+	 * RECOVER:  doing recovery, or need to try it.
 	 * INTR:     resync needs to be aborted for some reason
 	 * DONE:     thread is done and is waiting to be reaped
 	 * REQUEST:  user-space has requested a sync (used with SYNC)
@@ -198,6 +199,7 @@ struct mddev_s
 	 */
 #define	MD_RECOVERY_RUNNING	0
 #define	MD_RECOVERY_SYNC	1
+#define	MD_RECOVERY_RECOVER	2
 #define	MD_RECOVERY_INTR	3
 #define	MD_RECOVERY_DONE	4
 #define	MD_RECOVERY_NEEDED	5
