From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 1 of 4 - Misc little raid fixes
Date: Thu, 07 Nov 2002 11:56:00 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E189axk-0008JD-00@notabene.cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Here begins 4 patch that fix an assortment of small and medium bugs in
md and get it mostly working again...

NeilBrown

### Comments for ChangeSet

Roughly in order of patch:

1/ xor.h is never needed in md.c
2/ set sb_loaded when we 'sync' mddev to rdev as well as when we load 
   sb into rdev from disk.
2/ due to lifetime changes, active count can be 2 when we stop array
3/ due to lifetime changes, we need to explicitly clear the ->pers when we
   stop an array
4/ autostart can only work for 0.90.0 superblocks.  
   None others would be silly enough to store device numbers for
   all devices in the superblock...
5/ we had lost the setting of 'sb' when auto-starting an array.
6/ Code currently calls export_rdev(start_rdev) when
   IS_ERR(start_rdev), which causes an oops.
7/ /proc/mdstat contents error: 
       code does not take into account that delayed 
       resyncs can wait with curr_resync = 1 or 2.
8/ There is a premature "return NOTIFY_DONE", that possibly was in 
   for debugging once...


 ----------- Diffstat output ------------
 ./drivers/md/md.c |   32 +++++++++++++++++++-------------
 1 files changed, 19 insertions(+), 13 deletions(-)

--- ./drivers/md/md.c	2002/11/06 22:51:20	1.1
+++ ./drivers/md/md.c	2002/11/06 22:58:15	1.2
@@ -34,7 +34,6 @@
 #include <linux/raid/md.h>
 #include <linux/sysctl.h>
 #include <linux/bio.h>
-#include <linux/raid/xor.h>
 #include <linux/devfs_fs_kernel.h>
 #include <linux/buffer_head.h> /* for invalidate_bdev */
 
@@ -995,8 +994,10 @@ static void sync_sbs(mddev_t * mddev)
 	mdk_rdev_t *rdev;
 	struct list_head *tmp;
 
-	ITERATE_RDEV(mddev,rdev,tmp)
+	ITERATE_RDEV(mddev,rdev,tmp) {
 		super_90_sync(mddev, rdev);
+		rdev->sb_loaded = 1;
+	}
 }
 
 static void md_update_sb(mddev_t * mddev)
@@ -1531,7 +1532,7 @@ static int do_md_stop(mddev_t * mddev, i
 	int err = 0;
 	struct gendisk *disk = disks[mdidx(mddev)];
 
-	if (atomic_read(&mddev->active)>1) {
+	if (atomic_read(&mddev->active)>2) {
 		printk(STILL_IN_USE, mdidx(mddev));
 		err = -EBUSY;
 		goto out;
@@ -1561,6 +1562,7 @@ static int do_md_stop(mddev_t * mddev, i
 					set_disk_ro(disk, 1);
 				goto out;
 			}
+			mddev->pers = NULL;
 			if (mddev->ro)
 				mddev->ro = 0;
 		}
@@ -1736,17 +1738,26 @@ static int autostart_array(dev_t startde
 	start_rdev = md_import_device(startdev, 1);
 	if (IS_ERR(start_rdev)) {
 		printk(KERN_WARNING "md: could not import %s!\n", partition_name(startdev));
-		goto abort;
+		return err;
+	}
+
+	/* NOTE: this can only work for 0.90.0 superblocks */
+	sb = (mdp_super_t*)page_address(start_rdev->sb_page);
+	if (sb->major_version != 0 ||
+	    sb->minor_version != 90 ) {
+		printk(KERN_WARNING "md: can only autostart 0.90.0 arrays\n");
+		export_rdev(start_rdev);
+		return err;
 	}
 
 	if (start_rdev->faulty) {
 		printk(KERN_WARNING "md: can not autostart based on faulty %s!\n",
 						bdev_partition_name(start_rdev->bdev));
-		goto abort;
+		export_rdev(start_rdev);
+		return err;
 	}
 	list_add(&start_rdev->same_set, &pending_raid_disks);
 
-
 	for (i = 0; i < MD_SB_DISKS; i++) {
 		mdp_disk_t *desc;
 		dev_t dev;
@@ -1773,10 +1784,6 @@ static int autostart_array(dev_t startde
 	autorun_devices();
 	return 0;
 
-abort:
-	if (start_rdev)
-		export_rdev(start_rdev);
-	return err;
 }
 
 #undef BAD_VERSION
@@ -2693,9 +2700,9 @@ static int md_status_read_proc(char *pag
 		sz += mddev->pers->status (page+sz, mddev);
 
 		sz += sprintf(page+sz, "\n      ");
-		if (mddev->curr_resync > 1)
+		if (mddev->curr_resync > 2)
 			sz += status_resync (page+sz, mddev);
-		else if (mddev->curr_resync == 1)
+		else if (mddev->curr_resync == 1 || mddev->curr_resync == 2)
 				sz += sprintf(page + sz, "	resync=DELAYED");
 
 		sz += sprintf(page + sz, "\n");
@@ -3050,7 +3057,6 @@ int md_notify_reboot(struct notifier_blo
 	if ((code == SYS_DOWN) || (code == SYS_HALT) || (code == SYS_POWER_OFF)) {
 
 		printk(KERN_INFO "md: stopping all md devices.\n");
-		return NOTIFY_DONE;
 
 		ITERATE_MDDEV(mddev,tmp)
 			if (mddev_trylock(mddev)==0)
