From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] MD - 11 of 27 - Move md_update_sb calls
Date: Thu, 18 Jul 2002 23:33:14 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1020718133314.4869@cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


### Comments for ChangeSet
Move md_update_sb calls

When a change which requires a superblock update happens
at interrupt time, we currently set a flag (sb_dirty) and
wakeup to per-array thread (raid1/raid5d/multipathd) to
do the actual update.

This patch centralises this.  The sb_update is now done
by the mdrecoveryd thread.  As this is always woken up after 
the error handler is called, we don't need the call to wakeup
the local thread any more.

With this, we don't need "md_update_sb" to lock the array
any more and only use __md_update_sb which is local to md.c
So we rename __md_update_sb back to md_update_sb and stop
exporting it.





 ----------- Diffstat output ------------
 ./drivers/md/md.c         |   25 ++++++++-----------------
 ./drivers/md/multipath.c  |    5 -----
 ./drivers/md/raid1.c      |    5 -----
 ./drivers/md/raid5.c      |    5 -----
 ./include/linux/raid/md.h |    1 -
 5 files changed, 8 insertions(+), 33 deletions(-)

--- ./drivers/md/md.c	2002/07/18 12:00:52	1.5
+++ ./drivers/md/md.c	2002/07/18 12:02:00	1.6
@@ -904,7 +904,7 @@ static int sync_sbs(mddev_t * mddev)
 	return 0;
 }
 
-void __md_update_sb(mddev_t * mddev)
+static void md_update_sb(mddev_t * mddev)
 {
 	int err, count = 100;
 	struct list_head *tmp;
@@ -962,16 +962,6 @@ repeat:
 	}
 }
 
-void md_update_sb(mddev_t *mddev)
-{
-	if (mddev_lock(mddev))
-		return;
-	if (mddev->sb_dirty)
-		__md_update_sb(mddev);
-	mddev_unlock(mddev);
-}
-
-
 /*
  * Import a device. If 'on_disk', then sanity check the superblock
  *
@@ -1640,7 +1630,7 @@ static int do_md_run(mddev_t * mddev)
 	 */
 	if (mddev->pers->sync_request)
 		mddev->sb->state &= ~(1 << MD_SB_CLEAN);
-	__md_update_sb(mddev);
+	md_update_sb(mddev);
 
 	md_recover_arrays();
 	/*
@@ -1749,7 +1739,7 @@ static int do_md_stop(mddev_t * mddev, i
 				printk(KERN_INFO "md: marking sb clean...\n");
 				mddev->sb->state |= 1 << MD_SB_CLEAN;
 			}
-			__md_update_sb(mddev);
+			md_update_sb(mddev);
 		}
 		if (ro)
 			set_device_ro(dev, 1);
@@ -2234,7 +2224,7 @@ static int hot_remove_disk(mddev_t * mdd
 
 	remove_descriptor(disk, mddev->sb);
 	kick_rdev_from_array(rdev);
-	__md_update_sb(mddev);
+	md_update_sb(mddev);
 
 	return 0;
 busy:
@@ -2341,7 +2331,7 @@ static int hot_add_disk(mddev_t * mddev,
 	mddev->sb->spare_disks++;
 	mddev->sb->working_disks++;
 
-	__md_update_sb(mddev);
+	md_update_sb(mddev);
 
 	/*
 	 * Kick recovery, maybe this spare has to be added to the
@@ -3309,6 +3299,8 @@ void md_do_recovery(void *data)
 		sb = mddev->sb;
 		if (!sb || !mddev->pers || mddev->ro)
 			goto unlock;
+		if (mddev->sb_dirty)
+			md_update_sb(mddev);
 		if (mddev->recovery_running > 0)
 			/* resync/recovery still happening */
 			goto unlock;
@@ -3341,7 +3333,7 @@ void md_do_recovery(void *data)
 					mddev->spare = NULL;
 				}
 			}
-			__md_update_sb(mddev);
+			md_update_sb(mddev);
 			mddev->recovery_running = 0;
 			wake_up(&resync_wait);
 			goto unlock;
@@ -3849,7 +3841,6 @@ EXPORT_SYMBOL(md_sync_acct);
 EXPORT_SYMBOL(md_done_sync);
 EXPORT_SYMBOL(md_register_thread);
 EXPORT_SYMBOL(md_unregister_thread);
-EXPORT_SYMBOL(md_update_sb);
 EXPORT_SYMBOL(md_wakeup_thread);
 EXPORT_SYMBOL(md_print_devices);
 EXPORT_SYMBOL(find_rdev_nr);
--- ./drivers/md/multipath.c	2002/07/18 12:00:58	1.8
+++ ./drivers/md/multipath.c	2002/07/18 12:02:01	1.9
@@ -226,7 +226,6 @@ static void mark_disk_bad (mddev_t *mdde
 	sb->working_disks--;
 	sb->failed_disks++;
 	mddev->sb_dirty = 1;
-	md_wakeup_thread(conf->thread);
 	conf->working_disks--;
 	printk (DISK_FAILED, bdev_partition_name (multipath->bdev),
 				 conf->working_disks);
@@ -593,10 +592,6 @@ static void multipathd (void *data)
 		spin_unlock_irqrestore(&retry_list_lock, flags);
 
 		mddev = mp_bh->mddev;
-		if (mddev->sb_dirty) {
-			printk(KERN_INFO "dirty sb detected, updating.\n");
-			md_update_sb(mddev);
-		}
 		bio = &mp_bh->bio;
 		bio->bi_sector = mp_bh->master_bio->bi_sector;
 		bdev = bio->bi_bdev;
--- ./drivers/md/raid1.c	2002/07/18 12:00:58	1.3
+++ ./drivers/md/raid1.c	2002/07/18 12:02:01	1.4
@@ -586,7 +586,6 @@ static void mark_disk_bad(mddev_t *mddev
 	sb->working_disks--;
 	sb->failed_disks++;
 	mddev->sb_dirty = 1;
-	md_wakeup_thread(conf->thread);
 	if (!mirror->write_only)
 		conf->working_disks--;
 	printk(DISK_FAILED, bdev_partition_name(mirror->bdev), conf->working_disks);
@@ -1061,10 +1060,6 @@ static void raid1d(void *data)
 
 		mddev = r1_bio->mddev;
 		conf = mddev_to_conf(mddev);
-		if (mddev->sb_dirty) {
-			printk(KERN_INFO "raid1: dirty sb detected, updating.\n");
-			md_update_sb(mddev);
-		}
 		bio = r1_bio->master_bio;
 		switch(r1_bio->cmd) {
 		case SPECIAL:
--- ./drivers/md/raid5.c	2002/07/18 12:00:58	1.2
+++ ./drivers/md/raid5.c	2002/07/18 12:02:01	1.3
@@ -462,7 +462,6 @@ static int error(mddev_t *mddev, struct 
 			mddev->sb_dirty = 1;
 			conf->working_disks--;
 			conf->failed_disks++;
-			md_wakeup_thread(conf->thread);
 			printk (KERN_ALERT
 				"raid5: Disk failure on %s, disabling device."
 				" Operation continuing on %d devices\n",
@@ -494,7 +493,6 @@ static int error(mddev_t *mddev, struct 
 			sb->failed_disks++;
 
 			mddev->sb_dirty = 1;
-			md_wakeup_thread(conf->thread);
 
 			return 0;
 		}
@@ -1339,9 +1337,6 @@ static void raid5d (void *data)
 	PRINTK("+++ raid5d active\n");
 
 	handled = 0;
-
-	if (mddev->sb_dirty)
-		md_update_sb(mddev);
 	spin_lock_irq(&conf->device_lock);
 	while (1) {
 		struct list_head *first;
--- ./include/linux/raid/md.h	2002/07/18 12:01:42	1.1
+++ ./include/linux/raid/md.h	2002/07/18 12:02:01	1.2
@@ -75,7 +75,6 @@ extern mdk_thread_t * md_register_thread
 extern void md_unregister_thread (mdk_thread_t *thread);
 extern void md_wakeup_thread(mdk_thread_t *thread);
 extern void md_interrupt_thread (mdk_thread_t *thread);
-extern void md_update_sb (mddev_t *mddev);
 extern void md_done_sync(mddev_t *mddev, int blocks, int ok);
 extern void md_sync_acct(struct block_device *bdev, unsigned long nr_sectors);
 extern int md_error (mddev_t *mddev, struct block_device *bdev);
