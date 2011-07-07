From: Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH] md: introduce link/unlink_rdev() helpers
Date: Thu,  7 Jul 2011 11:57:09 +0900
Message-ID: <1310007429-8822-1-git-send-email-namhyung@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

There are places where sysfs links to rdev are handled
in a same way. Add the helper functions to consolidate
them.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 drivers/md/md.c |   64 ++++++++++++++++++++++++++----------------------------
 1 files changed, 31 insertions(+), 33 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index a4022e679b63..af3a9453a62d 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2314,6 +2314,20 @@ repeat:
 
 }
 
+static inline int link_rdev(mddev_t *mddev, mdk_rdev_t *rdev)
+{
+	char nm[20];
+	sprintf(nm, "rd%d", rdev->raid_disk);
+	return sysfs_create_link(&mddev->kobj, &rdev->kobj, nm);
+}
+
+static inline void unlink_rdev(mddev_t *mddev, mdk_rdev_t *rdev)
+{
+	char nm[20];
+	sprintf(nm, "rd%d", rdev->raid_disk);
+	sysfs_remove_link(&mddev->kobj, nm);
+}
+
 /* words written to sysfs files may, or may not, be \n terminated.
  * We want to accept with case. For this we use cmd_match.
  */
@@ -2458,7 +2472,6 @@ slot_store(mdk_rdev_t *rdev, const char *buf, size_t len)
 {
 	char *e;
 	int err;
-	char nm[20];
 	int slot = simple_strtoul(buf, &e, 10);
 	if (strncmp(buf, "none", 4)==0)
 		slot = -1;
@@ -2481,8 +2494,8 @@ slot_store(mdk_rdev_t *rdev, const char *buf, size_t len)
 			hot_remove_disk(rdev->mddev, rdev->raid_disk);
 		if (err)
 			return err;
-		sprintf(nm, "rd%d", rdev->raid_disk);
-		sysfs_remove_link(&rdev->mddev->kobj, nm);
+
+		unlink_rdev(rdev->mddev, rdev);
 		rdev->raid_disk = -1;
 		set_bit(MD_RECOVERY_NEEDED, &rdev->mddev->recovery);
 		md_wakeup_thread(rdev->mddev->thread);
@@ -2521,8 +2534,8 @@ slot_store(mdk_rdev_t *rdev, const char *buf, size_t len)
 			return err;
 		} else
 			sysfs_notify_dirent_safe(rdev->sysfs_state);
-		sprintf(nm, "rd%d", rdev->raid_disk);
-		if (sysfs_create_link(&rdev->mddev->kobj, &rdev->kobj, nm))
+
+		if (link_rdev(rdev->mddev, rdev))
 			/* failure here is OK */;
 		/* don't wakeup anyone, leave that to userspace. */
 	} else {
@@ -3148,15 +3161,14 @@ level_store(mddev_t *mddev, const char *buf, size_t len)
 	}
 
 	list_for_each_entry(rdev, &mddev->disks, same_set) {
-		char nm[20];
 		if (rdev->raid_disk < 0)
 			continue;
 		if (rdev->new_raid_disk >= mddev->raid_disks)
 			rdev->new_raid_disk = -1;
 		if (rdev->new_raid_disk == rdev->raid_disk)
 			continue;
-		sprintf(nm, "rd%d", rdev->raid_disk);
-		sysfs_remove_link(&mddev->kobj, nm);
+
+		unlink_rdev(mddev, rdev);
 	}
 	list_for_each_entry(rdev, &mddev->disks, same_set) {
 		if (rdev->raid_disk < 0)
@@ -3167,11 +3179,10 @@ level_store(mddev_t *mddev, const char *buf, size_t len)
 		if (rdev->raid_disk < 0)
 			clear_bit(In_sync, &rdev->flags);
 		else {
-			char nm[20];
-			sprintf(nm, "rd%d", rdev->raid_disk);
-			if(sysfs_create_link(&mddev->kobj, &rdev->kobj, nm))
-				printk("md: cannot register %s for %s after level change\n",
-				       nm, mdname(mddev));
+			if (link_rdev(mddev, rdev))
+				printk(KERN_WARNING "md: cannot register rd%d"
+				       " for %s after level change\n",
+				       rdev->raid_disk, mdname(mddev));
 		}
 	}
 
@@ -4620,12 +4631,9 @@ int md_run(mddev_t *mddev)
 	smp_wmb();
 	mddev->ready = 1;
 	list_for_each_entry(rdev, &mddev->disks, same_set)
-		if (rdev->raid_disk >= 0) {
-			char nm[20];
-			sprintf(nm, "rd%d", rdev->raid_disk);
-			if (sysfs_create_link(&mddev->kobj, &rdev->kobj, nm))
+		if (rdev->raid_disk >= 0)
+			if (link_rdev(mddev, rdev))
 				/* failure here is OK */;
-		}
 	
 	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 	
@@ -4853,11 +4861,8 @@ static int do_md_stop(mddev_t * mddev, int mode, int is_open)
 		sysfs_notify_dirent_safe(mddev->sysfs_state);
 
 		list_for_each_entry(rdev, &mddev->disks, same_set)
-			if (rdev->raid_disk >= 0) {
-				char nm[20];
-				sprintf(nm, "rd%d", rdev->raid_disk);
-				sysfs_remove_link(&mddev->kobj, nm);
-			}
+			if (rdev->raid_disk >= 0)
+				unlink_rdev(mddev, rdev);
 
 		set_capacity(disk, 0);
 		mutex_unlock(&mddev->open_mutex);
@@ -7076,9 +7081,7 @@ static int remove_and_add_spares(mddev_t *mddev)
 		    atomic_read(&rdev->nr_pending)==0) {
 			if (mddev->pers->hot_remove_disk(
 				    mddev, rdev->raid_disk)==0) {
-				char nm[20];
-				sprintf(nm,"rd%d", rdev->raid_disk);
-				sysfs_remove_link(&mddev->kobj, nm);
+				unlink_rdev(mddev, rdev);
 				rdev->raid_disk = -1;
 			}
 		}
@@ -7095,10 +7098,7 @@ static int remove_and_add_spares(mddev_t *mddev)
 				rdev->recovery_offset = 0;
 				if (mddev->pers->
 				    hot_add_disk(mddev, rdev) == 0) {
-					char nm[20];
-					sprintf(nm, "rd%d", rdev->raid_disk);
-					if (sysfs_create_link(&mddev->kobj,
-							      &rdev->kobj, nm))
+					if (link_rdev(mddev, rdev))
 						/* failure here is OK */;
 					spares++;
 					md_new_event(mddev);
@@ -7215,9 +7215,7 @@ void md_check_recovery(mddev_t *mddev)
 				    atomic_read(&rdev->nr_pending)==0) {
 					if (mddev->pers->hot_remove_disk(
 						    mddev, rdev->raid_disk)==0) {
-						char nm[20];
-						sprintf(nm,"rd%d", rdev->raid_disk);
-						sysfs_remove_link(&mddev->kobj, nm);
+						unlink_rdev(mddev, rdev);
 						rdev->raid_disk = -1;
 					}
 				}
-- 
1.7.6

