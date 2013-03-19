From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 1 of 2 - v2] MD: Export 'md_reap_sync_thread' function
Date: Tue, 19 Mar 2013 12:18:46 -0500
Message-ID: <1363713526.11184.18.camel@f16>
References: <1363713352.11184.15.camel@f16>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1363713352.11184.15.camel@f16>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, agk@redhat.com, jbrassow@redhat.com
List-Id: linux-raid.ids

MD: Export 'md_reap_sync_thread' function

Make 'md_reap_sync_thread' available to other files, specifically dm-raid.c.
- rename reap_sync_thread to md_reap_sync_thread
- move the fn after md_check_recovery to match md.h declaration placement
- export md_reap_sync_thread

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-upstream/drivers/md/md.c
===================================================================
--- linux-upstream.orig/drivers/md/md.c
+++ linux-upstream/drivers/md/md.c
@@ -4225,8 +4225,6 @@ action_show(struct mddev *mddev, char *p
 	return sprintf(page, "%s\n", type);
 }
 
-static void reap_sync_thread(struct mddev *mddev);
-
 static ssize_t
 action_store(struct mddev *mddev, const char *page, size_t len)
 {
@@ -4241,7 +4239,7 @@ action_store(struct mddev *mddev, const
 	if (cmd_match(page, "idle") || cmd_match(page, "frozen")) {
 		if (mddev->sync_thread) {
 			set_bit(MD_RECOVERY_INTR, &mddev->recovery);
-			reap_sync_thread(mddev);
+			md_reap_sync_thread(mddev);
 		}
 	} else if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) ||
 		   test_bit(MD_RECOVERY_NEEDED, &mddev->recovery))
@@ -5279,7 +5277,7 @@ static void __md_stop_writes(struct mdde
 	if (mddev->sync_thread) {
 		set_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
 		set_bit(MD_RECOVERY_INTR, &mddev->recovery);
-		reap_sync_thread(mddev);
+		md_reap_sync_thread(mddev);
 	}
 
 	del_timer_sync(&mddev->safemode_timer);
@@ -7689,51 +7687,6 @@ static int remove_and_add_spares(struct
 	return spares;
 }
 
-static void reap_sync_thread(struct mddev *mddev)
-{
-	struct md_rdev *rdev;
-
-	/* resync has finished, collect result */
-	md_unregister_thread(&mddev->sync_thread);
-	if (!test_bit(MD_RECOVERY_INTR, &mddev->recovery) &&
-	    !test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery)) {
-		/* success...*/
-		/* activate any spares */
-		if (mddev->pers->spare_active(mddev)) {
-			sysfs_notify(&mddev->kobj, NULL,
-				     "degraded");
-			set_bit(MD_CHANGE_DEVS, &mddev->flags);
-		}
-	}
-	if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
-	    mddev->pers->finish_reshape)
-		mddev->pers->finish_reshape(mddev);
-
-	/* If array is no-longer degraded, then any saved_raid_disk
-	 * information must be scrapped.  Also if any device is now
-	 * In_sync we must scrape the saved_raid_disk for that device
-	 * do the superblock for an incrementally recovered device
-	 * written out.
-	 */
-	rdev_for_each(rdev, mddev)
-		if (!mddev->degraded ||
-		    test_bit(In_sync, &rdev->flags))
-			rdev->saved_raid_disk = -1;
-
-	md_update_sb(mddev, 1);
-	clear_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
-	clear_bit(MD_RECOVERY_SYNC, &mddev->recovery);
-	clear_bit(MD_RECOVERY_RESHAPE, &mddev->recovery);
-	clear_bit(MD_RECOVERY_REQUESTED, &mddev->recovery);
-	clear_bit(MD_RECOVERY_CHECK, &mddev->recovery);
-	/* flag recovery needed just to double check */
-	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
-	sysfs_notify_dirent_safe(mddev->sysfs_action);
-	md_new_event(mddev);
-	if (mddev->event_work.func)
-		queue_work(md_misc_wq, &mddev->event_work);
-}
-
 /*
  * This routine is regularly called by all per-raid-array threads to
  * deal with generic issues like resync and super-block update.
@@ -7836,7 +7789,7 @@ void md_check_recovery(struct mddev *mdd
 			goto unlock;
 		}
 		if (mddev->sync_thread) {
-			reap_sync_thread(mddev);
+			md_reap_sync_thread(mddev);
 			goto unlock;
 		}
 		/* Set RUNNING before clearing NEEDED to avoid
@@ -7917,6 +7870,51 @@ void md_check_recovery(struct mddev *mdd
 	}
 }
 
+void md_reap_sync_thread(struct mddev *mddev)
+{
+	struct md_rdev *rdev;
+
+	/* resync has finished, collect result */
+	md_unregister_thread(&mddev->sync_thread);
+	if (!test_bit(MD_RECOVERY_INTR, &mddev->recovery) &&
+	    !test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery)) {
+		/* success...*/
+		/* activate any spares */
+		if (mddev->pers->spare_active(mddev)) {
+			sysfs_notify(&mddev->kobj, NULL,
+				     "degraded");
+			set_bit(MD_CHANGE_DEVS, &mddev->flags);
+		}
+	}
+	if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
+	    mddev->pers->finish_reshape)
+		mddev->pers->finish_reshape(mddev);
+
+	/* If array is no-longer degraded, then any saved_raid_disk
+	 * information must be scrapped.  Also if any device is now
+	 * In_sync we must scrape the saved_raid_disk for that device
+	 * do the superblock for an incrementally recovered device
+	 * written out.
+	 */
+	rdev_for_each(rdev, mddev)
+		if (!mddev->degraded ||
+		    test_bit(In_sync, &rdev->flags))
+			rdev->saved_raid_disk = -1;
+
+	md_update_sb(mddev, 1);
+	clear_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
+	clear_bit(MD_RECOVERY_SYNC, &mddev->recovery);
+	clear_bit(MD_RECOVERY_RESHAPE, &mddev->recovery);
+	clear_bit(MD_RECOVERY_REQUESTED, &mddev->recovery);
+	clear_bit(MD_RECOVERY_CHECK, &mddev->recovery);
+	/* flag recovery needed just to double check */
+	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
+	sysfs_notify_dirent_safe(mddev->sysfs_action);
+	md_new_event(mddev);
+	if (mddev->event_work.func)
+		queue_work(md_misc_wq, &mddev->event_work);
+}
+
 void md_wait_for_blocked_rdev(struct md_rdev *rdev, struct mddev *mddev)
 {
 	sysfs_notify_dirent_safe(rdev->sysfs_state);
@@ -8642,6 +8640,7 @@ EXPORT_SYMBOL(md_register_thread);
 EXPORT_SYMBOL(md_unregister_thread);
 EXPORT_SYMBOL(md_wakeup_thread);
 EXPORT_SYMBOL(md_check_recovery);
+EXPORT_SYMBOL(md_reap_sync_thread);
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("MD RAID framework");
 MODULE_ALIAS("md");
Index: linux-upstream/drivers/md/md.h
===================================================================
--- linux-upstream.orig/drivers/md/md.h
+++ linux-upstream/drivers/md/md.h
@@ -567,6 +567,7 @@ extern struct md_thread *md_register_thr
 extern void md_unregister_thread(struct md_thread **threadp);
 extern void md_wakeup_thread(struct md_thread *thread);
 extern void md_check_recovery(struct mddev *mddev);
+extern void md_reap_sync_thread(struct mddev *mddev);
 extern void md_write_start(struct mddev *mddev, struct bio *bi);
 extern void md_write_end(struct mddev *mddev);
 extern void md_done_sync(struct mddev *mddev, int blocks, int ok);


