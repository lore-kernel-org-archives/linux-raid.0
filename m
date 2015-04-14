From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH 5/6] md: re-add a failed disk
Date: Tue, 14 Apr 2015 10:45:22 -0500
Message-ID: <20150414154522.GA4105@shrek.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: GQJiang@suse.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This adds the capability of re-adding a failed disk by
writing "re-add" to /sys/block/mdXX/md/dev-YYY/state.

This facilitates adding disks which have encountered a temporary
error such as a network disconnection/hiccup in an iSCSI device,
or a SAN cable disconnection which has been restored. In such
a situation, you do not need to remove and re-add the device.
Writing re-add to the failed device's state would add it again
to the array and perform the recovery of only the blocks which
were written after the device failed.

This works for generic md, and is not related to clustering. However,
this patch is to ease re-add operations listed above in clustering
environments.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 drivers/md/md.c | 56 +++++++++++++++++++++++++++++++++++---------------------
 1 file changed, 35 insertions(+), 21 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 9127d11..ba01605 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2379,6 +2379,36 @@ repeat:
 }
 EXPORT_SYMBOL(md_update_sb);
 
+static int add_bound_rdev(struct md_rdev *rdev)
+{
+	struct mddev *mddev = rdev->mddev;
+	int err = 0;
+
+	if (!mddev->pers->hot_remove_disk) {
+		/* If there is hot_add_disk but no hot_remove_disk
+		 * then added disks for geometry changes,
+		 * and should be added immediately.
+		 */
+		super_types[mddev->major_version].
+			validate_super(mddev, rdev);
+		err = mddev->pers->hot_add_disk(mddev, rdev);
+		if (err) {
+			unbind_rdev_from_array(rdev);
+			export_rdev(rdev);
+			return err;
+		}
+	}
+	sysfs_notify_dirent_safe(rdev->sysfs_state);
+
+	set_bit(MD_CHANGE_DEVS, &mddev->flags);
+	if (mddev->degraded)
+		set_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
+	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
+	md_new_event(mddev);
+	md_wakeup_thread(mddev->thread);
+	return 0;
+}
+
 /* words written to sysfs files may, or may not, be \n terminated.
  * We want to accept with case. For this we use cmd_match.
  */
@@ -2568,7 +2598,10 @@ state_store(struct md_rdev *rdev, const char *buf, size_t len)
 			clear_bit(Replacement, &rdev->flags);
 			err = 0;
 		}
-	}
+	} else if (cmd_match(buf, "re-add") && (test_bit(Faulty, &rdev->flags) || (rdev->raid_disk == -1))) {
+			clear_bit(Faulty, &rdev->flags);
+			err = add_bound_rdev(rdev);
+		}
 	if (!err)
 		sysfs_notify_dirent_safe(rdev->sysfs_state);
 	return err ? err : len;
@@ -5882,29 +5915,10 @@ static int add_new_disk(struct mddev *mddev, mdu_disk_info_t *info)
 
 		rdev->raid_disk = -1;
 		err = bind_rdev_to_array(rdev, mddev);
-		if (!err && !mddev->pers->hot_remove_disk) {
-			/* If there is hot_add_disk but no hot_remove_disk
-			 * then added disks for geometry changes,
-			 * and should be added immediately.
-			 */
-			super_types[mddev->major_version].
-				validate_super(mddev, rdev);
-			err = mddev->pers->hot_add_disk(mddev, rdev);
-			if (err)
-				unbind_rdev_from_array(rdev);
-		}
 		if (err)
 			export_rdev(rdev);
 		else
-			sysfs_notify_dirent_safe(rdev->sysfs_state);
-
-		set_bit(MD_CHANGE_DEVS, &mddev->flags);
-		if (mddev->degraded)
-			set_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
-		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
-		if (!err)
-			md_new_event(mddev);
-		md_wakeup_thread(mddev->thread);
+			err = add_bound_rdev(rdev);
 		if (mddev_is_clustered(mddev) &&
 				(info->state & (1 << MD_DISK_CLUSTER_ADD)))
 			md_cluster_ops->add_new_disk_finish(mddev);
-- 
2.1.4

