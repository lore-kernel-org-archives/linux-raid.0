From: Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH v2] md: introduce link/unlink_rdev() helpers
Date: Thu,  7 Jul 2011 12:45:40 +0900
Message-ID: <1310010340-12479-1-git-send-email-namhyung@gmail.com>
References: <1310007429-8822-1-git-send-email-namhyung@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1310007429-8822-1-git-send-email-namhyung@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

There are places where sysfs links to rdev are handled
in a same way. Add the helper functions to consolidate
them.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
Changes from v1:
 * move the helper functions to md.h
 * use them in raid1 and raid5 as well

 drivers/md/md.c    |   50 +++++++++++++++++---------------------------------
 drivers/md/md.h    |   14 ++++++++++++++
 drivers/md/raid1.c |   15 +++++----------
 drivers/md/raid5.c |   10 +++-------
 4 files changed, 39 insertions(+), 50 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index a4022e679b63..7843b3fed098 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2458,7 +2458,6 @@ slot_store(mdk_rdev_t *rdev, const char *buf, size_t len)
 {
 	char *e;
 	int err;
-	char nm[20];
 	int slot = simple_strtoul(buf, &e, 10);
 	if (strncmp(buf, "none", 4)==0)
 		slot = -1;
@@ -2481,8 +2480,8 @@ slot_store(mdk_rdev_t *rdev, const char *buf, size_t len)
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
@@ -2521,8 +2520,8 @@ slot_store(mdk_rdev_t *rdev, const char *buf, size_t len)
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
@@ -3148,15 +3147,14 @@ level_store(mddev_t *mddev, const char *buf, size_t len)
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
@@ -3167,11 +3165,10 @@ level_store(mddev_t *mddev, const char *buf, size_t len)
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
 
@@ -4620,12 +4617,9 @@ int md_run(mddev_t *mddev)
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
 	
@@ -4853,11 +4847,8 @@ static int do_md_stop(mddev_t * mddev, int mode, int is_open)
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
@@ -7076,9 +7067,7 @@ static int remove_and_add_spares(mddev_t *mddev)
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
@@ -7095,10 +7084,7 @@ static int remove_and_add_spares(mddev_t *mddev)
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
@@ -7215,9 +7201,7 @@ void md_check_recovery(mddev_t *mddev)
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
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 1c26c7a08ae6..87e84f253454 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -413,6 +413,20 @@ static inline char * mdname (mddev_t * mddev)
 	return mddev->gendisk ? mddev->gendisk->disk_name : "mdX";
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
 /*
  * iterates through some rdev ringlist. It's safe to remove the
  * current 'rdev'. Dont touch 'tmp' though.
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 4ed381488925..4c0d935b5acd 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2154,18 +2154,13 @@ static int raid1_reshape(mddev_t *mddev)
 	for (d = d2 = 0; d < conf->raid_disks; d++) {
 		mdk_rdev_t *rdev = conf->mirrors[d].rdev;
 		if (rdev && rdev->raid_disk != d2) {
-			char nm[20];
-			sprintf(nm, "rd%d", rdev->raid_disk);
-			sysfs_remove_link(&mddev->kobj, nm);
+			unlink_rdev(mddev, rdev);
 			rdev->raid_disk = d2;
-			sprintf(nm, "rd%d", rdev->raid_disk);
-			sysfs_remove_link(&mddev->kobj, nm);
-			if (sysfs_create_link(&mddev->kobj,
-					      &rdev->kobj, nm))
+			unlink_rdev(mddev, rdev);
+			if (link_rdev(mddev, rdev))
 				printk(KERN_WARNING
-				       "md/raid1:%s: cannot register "
-				       "%s\n",
-				       mdname(mddev), nm);
+				       "md/raid1:%s: cannot register rd%d\n",
+				       mdname(mddev), rdev->raid_disk);
 		}
 		if (rdev)
 			newmirrors[d2++].rdev = rdev;
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 59acc9b4deb3..a64458560d68 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5144,16 +5144,14 @@ static int raid5_start_reshape(mddev_t *mddev)
 			if (rdev->raid_disk < 0 &&
 			    !test_bit(Faulty, &rdev->flags)) {
 				if (raid5_add_disk(mddev, rdev) == 0) {
-					char nm[20];
 					if (rdev->raid_disk
 					    >= conf->previous_raid_disks) {
 						set_bit(In_sync, &rdev->flags);
 						added_devices++;
 					} else
 						rdev->recovery_offset = 0;
-					sprintf(nm, "rd%d", rdev->raid_disk);
-					if (sysfs_create_link(&mddev->kobj,
-							      &rdev->kobj, nm))
+
+					if (link_rdev(mddev, rdev))
 						/* Failure here is OK */;
 				}
 			} else if (rdev->raid_disk >= conf->previous_raid_disks
@@ -5249,9 +5247,7 @@ static void raid5_finish_reshape(mddev_t *mddev)
 			     d++) {
 				mdk_rdev_t *rdev = conf->disks[d].rdev;
 				if (rdev && raid5_remove_disk(mddev, d) == 0) {
-					char nm[20];
-					sprintf(nm, "rd%d", rdev->raid_disk);
-					sysfs_remove_link(&mddev->kobj, nm);
+					unlink_rdev(mddev, rdev);
 					rdev->raid_disk = -1;
 				}
 			}
-- 
1.7.6

