From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 07/13] md: Be more careful about clearing flags bit in
	->recovery
Date: Wed, 12 Jan 2011 09:12:46 +1100
Message-ID: <20110111221246.12732.87440.stgit@notabene.brown>
References: <20110111221050.12732.31647.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110111221050.12732.31647.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Setting ->recovery to 0 is generally not a good idea as it could clear
bits that shouldn't be cleared.  In particular, MD_RECOVERY_FROZEN
should only be cleared on explicit request from user-space.

So when we need to clear things, just clear the bits that need
clearing.

As there are a few different places which reap a resync process - and
some do an incomplte job - factor out the code for doing the from
md_check_recovery and call that function instead of open coding part
of it.

Signed-off-by: NeilBrown <neilb@suse.de>
Reported-by: Jonathan Brassow <jbrassow@redhat.com>
---

 drivers/md/md.c |   86 +++++++++++++++++++++++++++++++------------------------
 1 files changed, 49 insertions(+), 37 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index f43ff29..a91dc59 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3746,6 +3746,8 @@ action_show(mddev_t *mddev, char *page)
 	return sprintf(page, "%s\n", type);
 }
 
+static void reap_sync_thread(mddev_t *mddev);
+
 static ssize_t
 action_store(mddev_t *mddev, const char *page, size_t len)
 {
@@ -3760,9 +3762,7 @@ action_store(mddev_t *mddev, const char *page, size_t len)
 	if (cmd_match(page, "idle") || cmd_match(page, "frozen")) {
 		if (mddev->sync_thread) {
 			set_bit(MD_RECOVERY_INTR, &mddev->recovery);
-			md_unregister_thread(mddev->sync_thread);
-			mddev->sync_thread = NULL;
-			mddev->recovery = 0;
+			reap_sync_thread(mddev);
 		}
 	} else if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) ||
 		   test_bit(MD_RECOVERY_NEEDED, &mddev->recovery))
@@ -4709,8 +4709,7 @@ static void __md_stop_writes(mddev_t *mddev)
 	if (mddev->sync_thread) {
 		set_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
 		set_bit(MD_RECOVERY_INTR, &mddev->recovery);
-		md_unregister_thread(mddev->sync_thread);
-		mddev->sync_thread = NULL;
+		reap_sync_thread(mddev);
 	}
 
 	del_timer_sync(&mddev->safemode_timer);
@@ -7044,6 +7043,45 @@ static int remove_and_add_spares(mddev_t *mddev)
 	}
 	return spares;
 }
+
+static void reap_sync_thread(mddev_t *mddev)
+{
+	mdk_rdev_t *rdev;
+
+	/* resync has finished, collect result */
+	md_unregister_thread(mddev->sync_thread);
+	mddev->sync_thread = NULL;
+	if (!test_bit(MD_RECOVERY_INTR, &mddev->recovery) &&
+	    !test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery)) {
+		/* success...*/
+		/* activate any spares */
+		if (mddev->pers->spare_active(mddev))
+			sysfs_notify(&mddev->kobj, NULL,
+				     "degraded");
+	}
+	if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
+	    mddev->pers->finish_reshape)
+		mddev->pers->finish_reshape(mddev);
+	md_update_sb(mddev, 1);
+
+	/* if array is no-longer degraded, then any saved_raid_disk
+	 * information must be scrapped
+	 */
+	if (!mddev->degraded)
+		list_for_each_entry(rdev, &mddev->disks, same_set)
+			rdev->saved_raid_disk = -1;
+
+	clear_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
+	clear_bit(MD_RECOVERY_SYNC, &mddev->recovery);
+	clear_bit(MD_RECOVERY_RESHAPE, &mddev->recovery);
+	clear_bit(MD_RECOVERY_REQUESTED, &mddev->recovery);
+	clear_bit(MD_RECOVERY_CHECK, &mddev->recovery);
+	/* flag recovery needed just to double check */
+	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
+	sysfs_notify_dirent_safe(mddev->sysfs_action);
+	md_new_event(mddev);
+}
+
 /*
  * This routine is regularly called by all per-raid-array threads to
  * deal with generic issues like resync and super-block update.
@@ -7068,9 +7106,6 @@ static int remove_and_add_spares(mddev_t *mddev)
  */
 void md_check_recovery(mddev_t *mddev)
 {
-	mdk_rdev_t *rdev;
-
-
 	if (mddev->bitmap)
 		bitmap_daemon_work(mddev);
 
@@ -7138,34 +7173,7 @@ void md_check_recovery(mddev_t *mddev)
 			goto unlock;
 		}
 		if (mddev->sync_thread) {
-			/* resync has finished, collect result */
-			md_unregister_thread(mddev->sync_thread);
-			mddev->sync_thread = NULL;
-			if (!test_bit(MD_RECOVERY_INTR, &mddev->recovery) &&
-			    !test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery)) {
-				/* success...*/
-				/* activate any spares */
-				if (mddev->pers->spare_active(mddev))
-					sysfs_notify(&mddev->kobj, NULL,
-						     "degraded");
-			}
-			if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
-			    mddev->pers->finish_reshape)
-				mddev->pers->finish_reshape(mddev);
-			md_update_sb(mddev, 1);
-
-			/* if array is no-longer degraded, then any saved_raid_disk
-			 * information must be scrapped
-			 */
-			if (!mddev->degraded)
-				list_for_each_entry(rdev, &mddev->disks, same_set)
-					rdev->saved_raid_disk = -1;
-
-			mddev->recovery = 0;
-			/* flag recovery needed just to double check */
-			set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
-			sysfs_notify_dirent_safe(mddev->sysfs_action);
-			md_new_event(mddev);
+			reap_sync_thread(mddev);
 			goto unlock;
 		}
 		/* Set RUNNING before clearing NEEDED to avoid
@@ -7223,7 +7231,11 @@ void md_check_recovery(mddev_t *mddev)
 					" thread...\n", 
 					mdname(mddev));
 				/* leave the spares where they are, it shouldn't hurt */
-				mddev->recovery = 0;
+				clear_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
+				clear_bit(MD_RECOVERY_SYNC, &mddev->recovery);
+				clear_bit(MD_RECOVERY_RESHAPE, &mddev->recovery);
+				clear_bit(MD_RECOVERY_REQUESTED, &mddev->recovery);
+				clear_bit(MD_RECOVERY_CHECK, &mddev->recovery);
 			} else
 				md_wakeup_thread(mddev->sync_thread);
 			sysfs_notify_dirent_safe(mddev->sysfs_action);


