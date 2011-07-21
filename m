From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 23/34] md: introduce link/unlink_rdev() helpers
Date: Thu, 21 Jul 2011 12:32:27 +1000
Message-ID: <20110721023227.6728.86081.stgit@notabene.brown>
References: <20110721022537.6728.90204.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110721022537.6728.90204.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Namhyung Kim <namhyung@gmail.com>
List-Id: linux-raid.ids

From: Namhyung Kim <namhyung@gmail.com>

There are places where sysfs links to rdev are handled
in a same way. Add the helper functions to consolidate
them.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/md.c    |   47 ++++++++++++++---------------------------------
 drivers/md/md.h    |   14 ++++++++++++++
 drivers/md/raid1.c |   15 +++++----------
 drivers/md/raid5.c |   10 +++-------
 4 files changed, 36 insertions(+), 50 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 91e31e2..0398dc4 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2459,7 +2459,6 @@ slot_store(mdk_rdev_t *rdev, const char *buf, size_t len)
 {
 	char *e;
 	int err;
-	char nm[20];
 	int slot = simple_strtoul(buf, &e, 10);
 	if (strncmp(buf, "none", 4)==0)
 		slot = -1;
@@ -2482,8 +2481,7 @@ slot_store(mdk_rdev_t *rdev, const char *buf, size_t len)
 			hot_remove_disk(rdev->mddev, rdev->raid_disk);
 		if (err)
 			return err;
-		sprintf(nm, "rd%d", rdev->raid_disk);
-		sysfs_remove_link(&rdev->mddev->kobj, nm);
+		sysfs_unlink_rdev(rdev->mddev, rdev);
 		rdev->raid_disk = -1;
 		set_bit(MD_RECOVERY_NEEDED, &rdev->mddev->recovery);
 		md_wakeup_thread(rdev->mddev->thread);
@@ -2522,8 +2520,7 @@ slot_store(mdk_rdev_t *rdev, const char *buf, size_t len)
 			return err;
 		} else
 			sysfs_notify_dirent_safe(rdev->sysfs_state);
-		sprintf(nm, "rd%d", rdev->raid_disk);
-		if (sysfs_create_link(&rdev->mddev->kobj, &rdev->kobj, nm))
+		if (sysfs_link_rdev(rdev->mddev, rdev))
 			/* failure here is OK */;
 		/* don't wakeup anyone, leave that to userspace. */
 	} else {
@@ -3149,15 +3146,13 @@ level_store(mddev_t *mddev, const char *buf, size_t len)
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
+		sysfs_unlink_rdev(mddev, rdev);
 	}
 	list_for_each_entry(rdev, &mddev->disks, same_set) {
 		if (rdev->raid_disk < 0)
@@ -3168,11 +3163,10 @@ level_store(mddev_t *mddev, const char *buf, size_t len)
 		if (rdev->raid_disk < 0)
 			clear_bit(In_sync, &rdev->flags);
 		else {
-			char nm[20];
-			sprintf(nm, "rd%d", rdev->raid_disk);
-			if(sysfs_create_link(&mddev->kobj, &rdev->kobj, nm))
-				printk("md: cannot register %s for %s after level change\n",
-				       nm, mdname(mddev));
+			if (sysfs_link_rdev(mddev, rdev))
+				printk(KERN_WARNING "md: cannot register rd%d"
+				       " for %s after level change\n",
+				       rdev->raid_disk, mdname(mddev));
 		}
 	}
 
@@ -4621,12 +4615,9 @@ int md_run(mddev_t *mddev)
 	smp_wmb();
 	mddev->ready = 1;
 	list_for_each_entry(rdev, &mddev->disks, same_set)
-		if (rdev->raid_disk >= 0) {
-			char nm[20];
-			sprintf(nm, "rd%d", rdev->raid_disk);
-			if (sysfs_create_link(&mddev->kobj, &rdev->kobj, nm))
+		if (rdev->raid_disk >= 0)
+			if (sysfs_link_rdev(mddev, rdev))
 				/* failure here is OK */;
-		}
 	
 	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 	
@@ -4854,11 +4845,8 @@ static int do_md_stop(mddev_t * mddev, int mode, int is_open)
 		sysfs_notify_dirent_safe(mddev->sysfs_state);
 
 		list_for_each_entry(rdev, &mddev->disks, same_set)
-			if (rdev->raid_disk >= 0) {
-				char nm[20];
-				sprintf(nm, "rd%d", rdev->raid_disk);
-				sysfs_remove_link(&mddev->kobj, nm);
-			}
+			if (rdev->raid_disk >= 0)
+				sysfs_unlink_rdev(mddev, rdev);
 
 		set_capacity(disk, 0);
 		mutex_unlock(&mddev->open_mutex);
@@ -7077,9 +7065,7 @@ static int remove_and_add_spares(mddev_t *mddev)
 		    atomic_read(&rdev->nr_pending)==0) {
 			if (mddev->pers->hot_remove_disk(
 				    mddev, rdev->raid_disk)==0) {
-				char nm[20];
-				sprintf(nm,"rd%d", rdev->raid_disk);
-				sysfs_remove_link(&mddev->kobj, nm);
+				sysfs_unlink_rdev(mddev, rdev);
 				rdev->raid_disk = -1;
 			}
 		}
@@ -7096,10 +7082,7 @@ static int remove_and_add_spares(mddev_t *mddev)
 				rdev->recovery_offset = 0;
 				if (mddev->pers->
 				    hot_add_disk(mddev, rdev) == 0) {
-					char nm[20];
-					sprintf(nm, "rd%d", rdev->raid_disk);
-					if (sysfs_create_link(&mddev->kobj,
-							      &rdev->kobj, nm))
+					if (sysfs_link_rdev(mddev, rdev))
 						/* failure here is OK */;
 					spares++;
 					md_new_event(mddev);
@@ -7219,9 +7202,7 @@ void md_check_recovery(mddev_t *mddev)
 				    atomic_read(&rdev->nr_pending)==0) {
 					if (mddev->pers->hot_remove_disk(
 						    mddev, rdev->raid_disk)==0) {
-						char nm[20];
-						sprintf(nm,"rd%d", rdev->raid_disk);
-						sysfs_remove_link(&mddev->kobj, nm);
+						sysfs_unlink_rdev(mddev, rdev);
 						rdev->raid_disk = -1;
 					}
 				}
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 1c26c7a..6863f72 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -413,6 +413,20 @@ static inline char * mdname (mddev_t * mddev)
 	return mddev->gendisk ? mddev->gendisk->disk_name : "mdX";
 }
 
+static inline int sysfs_link_rdev(mddev_t *mddev, mdk_rdev_t *rdev)
+{
+	char nm[20];
+	sprintf(nm, "rd%d", rdev->raid_disk);
+	return sysfs_create_link(&mddev->kobj, &rdev->kobj, nm);
+}
+
+static inline void sysfs_unlink_rdev(mddev_t *mddev, mdk_rdev_t *rdev)
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
index d3a8f4b..1d79a04 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2159,18 +2159,13 @@ static int raid1_reshape(mddev_t *mddev)
 	for (d = d2 = 0; d < conf->raid_disks; d++) {
 		mdk_rdev_t *rdev = conf->mirrors[d].rdev;
 		if (rdev && rdev->raid_disk != d2) {
-			char nm[20];
-			sprintf(nm, "rd%d", rdev->raid_disk);
-			sysfs_remove_link(&mddev->kobj, nm);
+			sysfs_unlink_rdev(mddev, rdev);
 			rdev->raid_disk = d2;
-			sprintf(nm, "rd%d", rdev->raid_disk);
-			sysfs_remove_link(&mddev->kobj, nm);
-			if (sysfs_create_link(&mddev->kobj,
-					      &rdev->kobj, nm))
+			sysfs_unlink_rdev(mddev, rdev);
+			if (sysfs_link_rdev(mddev, rdev))
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
index b14183e..3c67942 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5152,16 +5152,14 @@ static int raid5_start_reshape(mddev_t *mddev)
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
+					if (sysfs_link_rdev(mddev, rdev))
 						/* Failure here is OK */;
 				}
 			} else if (rdev->raid_disk >= conf->previous_raid_disks
@@ -5257,9 +5255,7 @@ static void raid5_finish_reshape(mddev_t *mddev)
 			     d++) {
 				mdk_rdev_t *rdev = conf->disks[d].rdev;
 				if (rdev && raid5_remove_disk(mddev, d) == 0) {
-					char nm[20];
-					sprintf(nm, "rd%d", rdev->raid_disk);
-					sysfs_remove_link(&mddev->kobj, nm);
+					sysfs_unlink_rdev(mddev, rdev);
 					rdev->raid_disk = -1;
 				}
 			}


