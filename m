From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: PATCH - md 21 of 22 - Improve handling of MD super blocks
Date: Wed, 19 Jun 2002 10:55:04 +1000 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15631.54888.507711.643358@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



1/ don't free the rdev->sb on an error -- it might be
   accessed again later.  Just wait for the device to be
   exported.
2/ Change md_update_sb to __md_update_sb and have it 
   clear the sb_dirty flag.
   New md_update_sb locks the device and calls __md_update_sb
   if sb_dirty.  This avoids any possbile races around 
   updating the superblock


 ----------- Diffstat output ------------
 ./drivers/md/md.c         |   31 ++++++++++++++++++-------------
 ./drivers/md/multipath.c  |    1 -
 ./drivers/md/raid1.c      |    1 -
 ./drivers/md/raid5.c      |    4 +---
 ./include/linux/raid/md.h |    2 +-
 5 files changed, 20 insertions(+), 19 deletions(-)

--- ./drivers/md/md.c	2002/06/18 06:05:22	1.20
+++ ./drivers/md/md.c	2002/06/18 06:08:03	1.21
@@ -921,12 +921,13 @@
 	return 0;
 }
 
-int md_update_sb(mddev_t * mddev)
+void __md_update_sb(mddev_t * mddev)
 {
 	int err, count = 100;
 	struct list_head *tmp;
 	mdk_rdev_t *rdev;
 
+	mddev->sb_dirty = 0;
 repeat:
 	mddev->sb->utime = CURRENT_TIME;
 	if (!(++mddev->sb->events_lo))
@@ -948,7 +949,7 @@
 	 * nonpersistent superblocks
 	 */
 	if (mddev->sb->not_persistent)
-		return 0;
+		return;
 
 	printk(KERN_INFO "md: updating md%d RAID superblock on device\n",
 					mdidx(mddev));
@@ -976,9 +977,18 @@
 		}
 		printk(KERN_ERR "md: excessive errors occurred during superblock update, exiting\n");
 	}
-	return 0;
 }
 
+void md_update_sb(mddev_t *mddev)
+{
+	if (mddev_lock(mddev))
+		return;
+	if (mddev->sb_dirty)
+		__md_update_sb(mddev);
+	mddev_unlock(mddev);
+}
+
+
 /*
  * Import a device. If 'on_disk', then sanity check the superblock
  *
@@ -1648,7 +1658,7 @@
 	}
 
 	mddev->sb->state &= ~(1 << MD_SB_CLEAN);
-	md_update_sb(mddev);
+	__md_update_sb(mddev);
 
 	/*
 	 * md_size has units of 1K blocks, which are
@@ -1770,7 +1780,7 @@
 				printk(KERN_INFO "md: marking sb clean...\n");
 				mddev->sb->state |= 1 << MD_SB_CLEAN;
 			}
-			md_update_sb(mddev);
+			__md_update_sb(mddev);
 		}
 		if (ro)
 			set_device_ro(dev, 1);
@@ -2281,8 +2291,7 @@
 
 	remove_descriptor(disk, mddev->sb);
 	kick_rdev_from_array(rdev);
-	mddev->sb_dirty = 1;
-	md_update_sb(mddev);
+	__md_update_sb(mddev);
 
 	return 0;
 busy:
@@ -2393,9 +2402,7 @@
 	mddev->sb->spare_disks++;
 	mddev->sb->working_disks++;
 
-	mddev->sb_dirty = 1;
-
-	md_update_sb(mddev);
+	__md_update_sb(mddev);
 
 	/*
 	 * Kick recovery, maybe this spare has to be added to the
@@ -2918,7 +2925,6 @@
 		return 0;
 	if (!mddev->pers->error_handler
 			|| mddev->pers->error_handler(mddev,rdev) <= 0) {
-		free_disk_sb(rrdev);
 		rrdev->faulty = 1;
 	} else
 		return 1;
@@ -3423,8 +3429,7 @@
 			sb->active_disks++;
 			sb->spare_disks--;
 		}
-		mddev->sb_dirty = 1;
-		md_update_sb(mddev);
+		__md_update_sb(mddev);
 		mddev->recovery_running = 0;
 	unlock:
 		mddev_unlock(mddev);
--- ./drivers/md/raid5.c	2002/06/18 05:29:05	1.7
+++ ./drivers/md/raid5.c	2002/06/18 06:08:03	1.8
@@ -1335,10 +1335,8 @@
 
 	handled = 0;
 
-	if (mddev->sb_dirty) {
-		mddev->sb_dirty = 0;
+	if (mddev->sb_dirty)
 		md_update_sb(mddev);
-	}
 	spin_lock_irq(&conf->device_lock);
 	while (1) {
 		struct list_head *first;
--- ./drivers/md/raid1.c	2002/06/18 05:29:05	1.3
+++ ./drivers/md/raid1.c	2002/06/18 06:08:03	1.4
@@ -1084,7 +1084,6 @@
 		conf = mddev_to_conf(mddev);
 		if (mddev->sb_dirty) {
 			printk(KERN_INFO "raid1: dirty sb detected, updating.\n");
-			mddev->sb_dirty = 0;
 			md_update_sb(mddev);
 		}
 		bio = r1_bio->master_bio;
--- ./drivers/md/multipath.c	2002/06/18 04:18:35	1.2
+++ ./drivers/md/multipath.c	2002/06/18 06:08:03	1.3
@@ -699,7 +699,6 @@
 		mddev = mp_bh->mddev;
 		if (mddev->sb_dirty) {
 			printk(KERN_INFO "dirty sb detected, updating.\n");
-			mddev->sb_dirty = 0;
 			md_update_sb(mddev);
 		}
 		bio = mp_bh->bio;
--- ./include/linux/raid/md.h	2002/06/18 04:37:53	1.3
+++ ./include/linux/raid/md.h	2002/06/18 06:08:03	1.4
@@ -75,7 +75,7 @@
 extern void md_unregister_thread (mdk_thread_t *thread);
 extern void md_wakeup_thread(mdk_thread_t *thread);
 extern void md_interrupt_thread (mdk_thread_t *thread);
-extern int md_update_sb (mddev_t *mddev);
+extern void md_update_sb (mddev_t *mddev);
 extern int md_do_sync(mddev_t *mddev, mdp_disk_t *spare);
 extern void md_done_sync(mddev_t *mddev, int blocks, int ok);
 extern void md_sync_acct(kdev_t dev, unsigned long nr_sectors);
