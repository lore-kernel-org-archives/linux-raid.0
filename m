From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 22/28] md: split md_set_readonly out of do_md_stop
Date: Thu, 15 Apr 2010 16:21:08 +1000
Message-ID: <20100415062108.5126.21822.stgit@notabene.brown>
References: <20100415061516.5126.53068.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100415061516.5126.53068.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Using do_md_stop to set an array to read-only is a little confusing.
Now most of the common code has been factored out, split
md_set_readonly off in to a separate function.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/md.c |   90 +++++++++++++++++++++++++++++++------------------------
 1 files changed, 51 insertions(+), 39 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 15f533d..51a109e 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3308,6 +3308,7 @@ array_state_show(mddev_t *mddev, char *page)
 }
 
 static int do_md_stop(mddev_t * mddev, int ro, int is_open);
+static int md_set_readonly(mddev_t * mddev, int is_open);
 static int do_md_run(mddev_t * mddev);
 static int restart_array(mddev_t *mddev);
 
@@ -3338,7 +3339,7 @@ array_state_store(mddev_t *mddev, const char *buf, size_t len)
 		break; /* not supported yet */
 	case readonly:
 		if (mddev->pers)
-			err = do_md_stop(mddev, 1, 0);
+			err = md_set_readonly(mddev, 0);
 		else {
 			mddev->ro = 1;
 			set_disk_ro(mddev->gendisk, 1);
@@ -3348,7 +3349,7 @@ array_state_store(mddev_t *mddev, const char *buf, size_t len)
 	case read_auto:
 		if (mddev->pers) {
 			if (mddev->ro == 0)
-				err = do_md_stop(mddev, 1, 0);
+				err = md_set_readonly(mddev, 0);
 			else if (mddev->ro == 1)
 				err = restart_array(mddev);
 			if (err == 0) {
@@ -4640,9 +4641,34 @@ static void md_stop(mddev_t *mddev)
 
 }
 
+static int md_set_readonly(mddev_t *mddev, int is_open)
+{
+	int err = 0;
+	mutex_lock(&mddev->open_mutex);
+	if (atomic_read(&mddev->openers) > is_open) {
+		printk("md: %s still in use.\n",mdname(mddev));
+		err = -EBUSY;
+		goto out;
+	}
+	if (mddev->pers) {
+		md_stop_writes(mddev);
+
+		err  = -ENXIO;
+		if (mddev->ro==1)
+			goto out;
+		mddev->ro = 1;
+		set_disk_ro(mddev->gendisk, 1);
+		clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
+		sysfs_notify_dirent(mddev->sysfs_state);
+		err = 0;	
+	}
+out:
+	mutex_unlock(&mddev->open_mutex);
+	return err;
+}
+
 /* mode:
  *   0 - completely stop and dis-assemble array
- *   1 - switch to readonly
  *   2 - stop but do not disassemble array
  */
 static int do_md_stop(mddev_t * mddev, int mode, int is_open)
@@ -4659,45 +4685,33 @@ static int do_md_stop(mddev_t * mddev, int mode, int is_open)
 
 		md_stop_writes(mddev);
 
-		switch(mode) {
-		case 1: /* readonly */
-			err  = -ENXIO;
-			if (mddev->ro==1)
-				goto out;
-			mddev->ro = 1;
-			break;
-		case 0: /* disassemble */
-		case 2: /* stop */
-			if (mddev->ro)
-				set_disk_ro(disk, 0);
+		if (mddev->ro)
+			set_disk_ro(disk, 0);
 
-			md_stop(mddev);
-			mddev->queue->merge_bvec_fn = NULL;
-			mddev->queue->unplug_fn = NULL;
-			mddev->queue->backing_dev_info.congested_fn = NULL;
+		md_stop(mddev);
+		mddev->queue->merge_bvec_fn = NULL;
+		mddev->queue->unplug_fn = NULL;
+		mddev->queue->backing_dev_info.congested_fn = NULL;
 
-			/* tell userspace to handle 'inactive' */
-			sysfs_notify_dirent(mddev->sysfs_state);
+		/* tell userspace to handle 'inactive' */
+		sysfs_notify_dirent(mddev->sysfs_state);
 
-			list_for_each_entry(rdev, &mddev->disks, same_set)
-				if (rdev->raid_disk >= 0) {
-					char nm[20];
-					sprintf(nm, "rd%d", rdev->raid_disk);
-					sysfs_remove_link(&mddev->kobj, nm);
-				}
+		list_for_each_entry(rdev, &mddev->disks, same_set)
+			if (rdev->raid_disk >= 0) {
+				char nm[20];
+				sprintf(nm, "rd%d", rdev->raid_disk);
+				sysfs_remove_link(&mddev->kobj, nm);
+			}
 
-			set_capacity(disk, 0);
-			revalidate_disk(disk);
+		set_capacity(disk, 0);
+		revalidate_disk(disk);
 
-			if (mddev->ro)
-				mddev->ro = 0;
-		}
-		if (mode == 1)
-			set_disk_ro(disk, 1);
+		if (mddev->ro)
+			mddev->ro = 0;
+		
 		clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
 		err = 0;
 	}
-out:
 	mutex_unlock(&mddev->open_mutex);
 	if (err)
 		return err;
@@ -4723,9 +4737,7 @@ out:
 		if (mddev->hold_active == UNTIL_STOP)
 			mddev->hold_active = 0;
 
-	} else if (mddev->pers)
-		printk(KERN_INFO "md: %s switched to read-only mode.\n",
-			mdname(mddev));
+	}
 	err = 0;
 	blk_integrity_unregister(disk);
 	md_new_event(mddev);
@@ -5722,7 +5734,7 @@ static int md_ioctl(struct block_device *bdev, fmode_t mode,
 			goto done_unlock;
 
 		case STOP_ARRAY_RO:
-			err = do_md_stop(mddev, 1, 1);
+			err = md_set_readonly(mddev, 1);
 			goto done_unlock;
 
 	}
@@ -7110,7 +7122,7 @@ static int md_notify_reboot(struct notifier_block *this,
 				 * appears to still be in use.  Hence
 				 * the '100'.
 				 */
-				do_md_stop(mddev, 1, 100);
+				md_set_readonly(mddev, 100);
 				mddev_unlock(mddev);
 			}
 		/*


