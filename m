From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] MD - 20 of 27 - Remove old_dev field.
Date: Thu, 18 Jul 2002 23:34:05 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1020718133405.4977@cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


### Comments for ChangeSet
Remove old_dev field.

We used to monitor the pervious device number of a 
component device for superblock maintenance.  This is
not needed any more.



 ----------- Diffstat output ------------
 ./drivers/md/md.c           |   12 ++----------
 ./include/linux/raid/md_k.h |    1 -
 2 files changed, 2 insertions(+), 11 deletions(-)

--- ./drivers/md/md.c	2002/07/18 12:06:48	1.13
+++ ./drivers/md/md.c	2002/07/18 12:07:15	1.14
@@ -708,8 +708,8 @@ static void print_sb(mdp_super_t *sb)
 
 static void print_rdev(mdk_rdev_t *rdev)
 {
-	printk(KERN_INFO "md: rdev %s: O:%s, SZ:%08ld F:%d DN:%d ",
-		partition_name(rdev->dev), partition_name(rdev->old_dev),
+	printk(KERN_INFO "md: rdev %s, SZ:%08ld F:%d DN:%d ",
+		partition_name(rdev->dev),
 		rdev->size, rdev->faulty, rdev->desc_nr);
 	if (rdev->sb) {
 		printk(KERN_INFO "md: rdev superblock:\n");
@@ -1029,12 +1029,6 @@ static mdk_rdev_t *md_import_device(kdev
 			       partition_name(newdev));
 			goto abort_free;
 		}
-
-		if (rdev->sb->level != LEVEL_MULTIPATH)
-			rdev->old_dev = mk_kdev(rdev->sb->this_disk.major,
-						rdev->sb->this_disk.minor);
-		else
-			rdev->old_dev = NODEV;
 	}
 	INIT_LIST_HEAD(&rdev->same_set);
 
@@ -1954,7 +1948,6 @@ static int add_new_disk(mddev_t * mddev,
 			printk(KERN_WARNING "md: error, md_import_device() returned %ld\n", PTR_ERR(rdev));
 			return PTR_ERR(rdev);
 		}
-		rdev->old_dev = dev;
 		rdev->desc_nr = info->number;
 		rdev->raid_disk = info->raid_disk;
 		rdev->faulty = 0;
@@ -2104,7 +2097,6 @@ static int hot_add_disk(mddev_t * mddev,
 	 * The rest should better be atomic, we can have disk failures
 	 * noticed in interrupt contexts ...
 	 */
-	rdev->old_dev = dev;
 	rdev->size = size;
 	rdev->sb_offset = calc_dev_sboffset(rdev, mddev, persistent);
 
--- ./include/linux/raid/md_k.h	2002/07/18 12:06:48	1.8
+++ ./include/linux/raid/md_k.h	2002/07/18 12:07:15	1.9
@@ -145,7 +145,6 @@ struct mdk_rdev_s
 	struct list_head same_set;	/* RAID devices within the same set */
 
 	kdev_t dev;			/* Device number */
-	kdev_t old_dev;			/*  "" when it was last imported */
 	unsigned long size;		/* Device size (in blocks) */
 	mddev_t *mddev;			/* RAID array if running */
 	unsigned long last_events;	/* IO event timestamp */
