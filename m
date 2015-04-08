From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH 3/4] re-add a failed disk
Date: Wed, 8 Apr 2015 14:23:37 -0500
Message-ID: <20150408192337.GA9686@shrek.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, GQJiang@suse.com
List-Id: linux-raid.ids

This adds the capability of re-adding a failed disk by
writing "re-add" to /sys/block/mdXX/md/dev-YYY/state.

This works for generic md, and is not (completely)
related to clustering.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 drivers/md/md.c | 56 ++++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 36 insertions(+), 20 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 0c65e51..83a8e91 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -79,6 +79,7 @@ static struct workqueue_struct *md_misc_wq;
 
 static int remove_and_add_spares(struct mddev *mddev,
 				 struct md_rdev *this);
+static int add_bound_rdev(struct md_rdev *);
 
 #define MD_BUG(x...) { printk("md: bug in file %s, line %d\n", __FILE__, __LINE__); md_print_devices(); }
 
@@ -2845,6 +2846,9 @@ state_store(struct md_rdev *rdev, const char *buf, size_t len)
 			clear_bit(Replacement, &rdev->flags);
 			err = 0;
 		}
+	} else if (cmd_match(buf, "re-add")) {
+		clear_bit(Faulty, &rdev->flags);
+		err = add_bound_rdev(rdev);
 	}
 	if (!err)
 		sysfs_notify_dirent_safe(rdev->sysfs_state);
@@ -5861,6 +5865,37 @@ static int get_disk_info(struct mddev * mddev, void __user * arg)
 	return 0;
 }
 
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
+		if (err)
+			unbind_rdev_from_array(rdev);
+	}
+	if (err)
+		export_rdev(rdev);
+	else
+		sysfs_notify_dirent_safe(rdev->sysfs_state);
+
+	set_bit(MD_CHANGE_DEVS, &mddev->flags);
+	if (mddev->degraded)
+		set_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
+	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
+	if (!err)
+		md_new_event(mddev);
+	md_wakeup_thread(mddev->thread);
+	return err;
+}
+
 static int add_new_disk(struct mddev * mddev, mdu_disk_info_t *info)
 {
 	char b[BDEVNAME_SIZE], b2[BDEVNAME_SIZE];
@@ -5989,29 +6024,10 @@ static int add_new_disk(struct mddev * mddev, mdu_disk_info_t *info)
 
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

