From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] MD - 16 of 27 - Add in_sync flag to each rdev
Date: Thu, 18 Jul 2002 23:33:41 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1020718133341.4932@cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


### Comments for ChangeSet
Add in_sync flag to each rdev

This currently mirrors the MD_DISK_SYNC superblock flag,
but soon it will be authoritative and the superblock will
only be consulted at start time.




 ----------- Diffstat output ------------
 ./drivers/md/md.c           |   19 ++++++++++++++++++-
 ./drivers/md/raid1.c        |    1 +
 ./drivers/md/raid5.c        |    1 +
 ./include/linux/raid/md_k.h |    2 ++
 4 files changed, 22 insertions(+), 1 deletion(-)

--- ./drivers/md/md.c	2002/07/18 12:05:11	1.9
+++ ./drivers/md/md.c	2002/07/18 12:05:40	1.10
@@ -1179,9 +1179,19 @@ static int analyze_sbs(mddev_t * mddev)
 			rdev->alias_device = !!i;
 			rdev->desc_nr = i++;
 			rdev->raid_disk = rdev->desc_nr;
+			rdev->in_sync = 1;
 		} else {
+			mdp_disk_t *desc;
 			rdev->desc_nr = rdev->sb->this_disk.number;
-			rdev->raid_disk = sb->disks[rdev->desc_nr].raid_disk;
+			desc = sb->disks + rdev->desc_nr;
+			rdev->raid_disk = desc->raid_disk;
+			rdev->in_sync = rdev->faulty = 0;
+
+			if (desc->state & (1<<MD_DISK_FAULTY))
+				rdev->faulty = 1;
+			else if (desc->state & (1<<MD_DISK_SYNC) &&
+				 rdev->raid_disk < mddev->sb-raid_disks)
+				rdev->in_sync = 1;
 		}
 	}
 	/*
@@ -2110,6 +2120,11 @@ static int add_new_disk(mddev_t * mddev,
 		rdev->old_dev = dev;
 		rdev->desc_nr = info->number;
 		rdev->raid_disk = info->raid_disk;
+		rdev->faulty = 0;
+		if (rdev->raid_disk < mddev->sb->raid_disks)
+			rdev->in_sync = (info->state & (1<<MD_DISK_SYNC));
+		else
+			rdev->in_sync = 0;
 
 		bind_rdev_to_array(rdev, mddev);
 
@@ -2271,6 +2286,7 @@ static int hot_add_disk(mddev_t * mddev,
 		err = -EINVAL;
 		goto abort_export;
 	}
+	rdev->in_sync = 0;
 	bind_rdev_to_array(rdev, mddev);
 
 	/*
@@ -2852,6 +2868,7 @@ int md_error(mddev_t *mddev, struct bloc
 	if (!mddev->pers->error_handler
 			|| mddev->pers->error_handler(mddev,bdev) <= 0) {
 		rrdev->faulty = 1;
+		rrdev->in_sync = 0;
 	} else
 		return 1;
 	/*
--- ./drivers/md/raid1.c	2002/07/18 12:05:11	1.6
+++ ./drivers/md/raid1.c	2002/07/18 12:05:40	1.7
@@ -726,6 +726,7 @@ static int raid1_spare_active(mddev_t *m
 		failed_rdev->desc_nr = spare_desc->number;
 		failed_rdev->raid_disk = spare_disk;
 	}
+	spare_rdev->in_sync = 1;
 
 	xchg_values(*spare_desc, *failed_desc);
 	xchg_values(*fdisk, *sdisk);
--- ./drivers/md/raid5.c	2002/07/18 12:05:11	1.5
+++ ./drivers/md/raid5.c	2002/07/18 12:05:40	1.6
@@ -1751,6 +1751,7 @@ static int raid5_spare_active(mddev_t *m
 		failed_rdev->desc_nr = spare_desc->number;
 		failed_rdev->raid_disk = spare_disk;
 	}
+	spare_rdev->in_sync = 1;
 	
 	xchg_values(*spare_desc, *failed_desc);
 	xchg_values(*fdisk, *sdisk);
--- ./include/linux/raid/md_k.h	2002/07/18 12:05:12	1.5
+++ ./include/linux/raid/md_k.h	2002/07/18 12:05:40	1.6
@@ -158,6 +158,8 @@ struct mdk_rdev_s
 
 	int alias_device;		/* device alias to the same disk */
 	int faulty;			/* if faulty do not issue IO requests */
+	int in_sync;			/* device is a full member of the array */
+
 	int desc_nr;			/* descriptor index in the superblock */
 	int raid_disk;			/* role of device in array */
 };
