From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] MD - 15 of 27 - Add raid_disk field to rdev
Date: Thu, 18 Jul 2002 23:33:35 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1020718133335.4926@cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


### Comments for ChangeSet
Add raid_disk field to rdev

Also change find_rdev_nr to find based on position
in array (raid_disk) not position in superblock (number).




 ----------- Diffstat output ------------
 ./drivers/md/linear.c       |    2 +-
 ./drivers/md/md.c           |    8 ++++++--
 ./drivers/md/raid1.c        |    9 ++++++---
 ./drivers/md/raid5.c        |    9 ++++++---
 ./include/linux/raid/md_k.h |    1 +
 5 files changed, 20 insertions(+), 9 deletions(-)

--- ./drivers/md/linear.c	2002/07/18 11:57:48	1.2
+++ ./drivers/md/linear.c	2002/07/18 12:05:11	1.3
@@ -52,7 +52,7 @@ static int linear_run (mddev_t *mddev)
 	conf->smallest = NULL;
 	cnt = 0;
 	ITERATE_RDEV(mddev,rdev,tmp) {
-		int j = rdev->sb->this_disk.raid_disk;
+		int j = rdev->raid_disk;
 		dev_info_t *disk = conf->disks + j;
 
 		if (j < 0 || j > mddev->sb->raid_disks || disk->bdev) {
--- ./drivers/md/md.c	2002/07/18 12:03:00	1.8
+++ ./drivers/md/md.c	2002/07/18 12:05:11	1.9
@@ -242,7 +242,7 @@ mdk_rdev_t * find_rdev_nr(mddev_t *mddev
 	struct list_head *tmp;
 
 	ITERATE_RDEV(mddev,rdev,tmp) {
-		if (rdev->desc_nr == nr)
+		if (rdev->raid_disk == nr)
 			return rdev;
 	}
 	return NULL;
@@ -1178,8 +1178,11 @@ static int analyze_sbs(mddev_t * mddev)
 		if (sb->level == LEVEL_MULTIPATH) {
 			rdev->alias_device = !!i;
 			rdev->desc_nr = i++;
-		} else
+			rdev->raid_disk = rdev->desc_nr;
+		} else {
 			rdev->desc_nr = rdev->sb->this_disk.number;
+			rdev->raid_disk = sb->disks[rdev->desc_nr].raid_disk;
+		}
 	}
 	/*
 	 * Fix up changed device names ... but only if this disk has a
@@ -2106,6 +2109,7 @@ static int add_new_disk(mddev_t * mddev,
 		}
 		rdev->old_dev = dev;
 		rdev->desc_nr = info->number;
+		rdev->raid_disk = info->raid_disk;
 
 		bind_rdev_to_array(rdev, mddev);
 
--- ./drivers/md/raid1.c	2002/07/18 12:03:01	1.5
+++ ./drivers/md/raid1.c	2002/07/18 12:05:11	1.6
@@ -713,16 +713,19 @@ static int raid1_spare_active(mddev_t *m
 	/*
 	 * do the switch finally
 	 */
-	spare_rdev = find_rdev_nr(mddev, spare_desc->number);
-	failed_rdev = find_rdev_nr(mddev, failed_desc->number);
+	spare_rdev = find_rdev_nr(mddev, spare_disk);
+	failed_rdev = find_rdev_nr(mddev, failed_disk);
 
 	/*
 	 * There must be a spare_rdev, but there may not be a
 	 * failed_rdev. That slot might be empty...
 	 */
 	spare_rdev->desc_nr = failed_desc->number;
-	if (failed_rdev)
+	spare_rdev->raid_disk = failed_disk;
+	if (failed_rdev) {
 		failed_rdev->desc_nr = spare_desc->number;
+		failed_rdev->raid_disk = spare_disk;
+	}
 
 	xchg_values(*spare_desc, *failed_desc);
 	xchg_values(*fdisk, *sdisk);
--- ./drivers/md/raid5.c	2002/07/18 12:03:01	1.4
+++ ./drivers/md/raid5.c	2002/07/18 12:05:11	1.5
@@ -1739,15 +1739,18 @@ static int raid5_spare_active(mddev_t *m
 	/*
 	 * do the switch finally
 	 */
-	spare_rdev = find_rdev_nr(mddev, spare_desc->number);
-	failed_rdev = find_rdev_nr(mddev, failed_desc->number);
+	spare_rdev = find_rdev_nr(mddev, spare_disk);
+	failed_rdev = find_rdev_nr(mddev, failed_disk);
 
 	/* There must be a spare_rdev, but there may not be a
 	 * failed_rdev.  That slot might be empty...
 	 */
 	spare_rdev->desc_nr = failed_desc->number;
-	if (failed_rdev)
+	spare_rdev->raid_disk = failed_disk;
+	if (failed_rdev) {
 		failed_rdev->desc_nr = spare_desc->number;
+		failed_rdev->raid_disk = spare_disk;
+	}
 	
 	xchg_values(*spare_desc, *failed_desc);
 	xchg_values(*fdisk, *sdisk);
--- ./include/linux/raid/md_k.h	2002/07/18 12:03:01	1.4
+++ ./include/linux/raid/md_k.h	2002/07/18 12:05:12	1.5
@@ -159,6 +159,7 @@ struct mdk_rdev_s
 	int alias_device;		/* device alias to the same disk */
 	int faulty;			/* if faulty do not issue IO requests */
 	int desc_nr;			/* descriptor index in the superblock */
+	int raid_disk;			/* role of device in array */
 };
 
 typedef struct mdk_personality_s mdk_personality_t;
