From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] MD - 14 of 27 - Improve handling of spares in md
Date: Thu, 18 Jul 2002 23:33:31 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1020718133331.4919@cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


### Comments for ChangeSet
Improve handling of spares in md

- hot_remove_disk is given the raid_disk rather than descriptor number
  so that it can find the device in internal array directly, no search.
- spare_inactive now uses mddev->spare->raid_disk instead of 
  mddev->spare->number so it can find the device directly without searching
- spare_write does not need number.  It can use mddev->spare->raid_disk as above.
- spare_active does not need &mddev->spare.  It finds the descriptor directly
  and fixes it without this pointer




 ----------- Diffstat output ------------
 ./drivers/md/md.c           |    8 ++---
 ./drivers/md/multipath.c    |   24 +++++++----------
 ./drivers/md/raid1.c        |   61 ++++++++++----------------------------------
 ./drivers/md/raid5.c        |   59 ++++++++++--------------------------------
 ./include/linux/raid/md_k.h |    4 +-
 5 files changed, 44 insertions(+), 112 deletions(-)

--- ./drivers/md/md.c	2002/07/18 12:02:10	1.7
+++ ./drivers/md/md.c	2002/07/18 12:03:00	1.8
@@ -2202,7 +2202,7 @@ static int hot_remove_disk(mddev_t * mdd
 		return -EINVAL;
 	}
 
-	err = mddev->pers->hot_remove_disk(mddev, disk->number);
+	err = mddev->pers->hot_remove_disk(mddev, disk->raid_disk);
 	if (err == -EBUSY) {
 		MD_BUG();
 		goto busy;
@@ -3314,8 +3314,7 @@ void md_do_recovery(void *data)
 					goto unlock;
 				/* success...*/
 				if (mddev->spare) {
-					mddev->pers->spare_active(mddev,
-								&mddev->spare);
+					mddev->pers->spare_active(mddev);
 					mark_disk_sync(mddev->spare);
 					mark_disk_active(mddev->spare);
 					sb->active_disks++;
@@ -3359,8 +3358,7 @@ void md_do_recovery(void *data)
 				mddev->recovery_running = 0;
 			} else {
 				if (mddev->spare)
-					mddev->pers->spare_write(mddev,
-						mddev->spare->number);
+					mddev->pers->spare_write(mddev);
 				mddev->recovery_running = 1;
 				md_wakeup_thread(mddev->sync_thread);
 			}
--- ./drivers/md/multipath.c	2002/07/18 12:02:21	1.10
+++ ./drivers/md/multipath.c	2002/07/18 12:03:01	1.11
@@ -333,25 +333,21 @@ static int multipath_remove_disk(mddev_t
 {
 	multipath_conf_t *conf = mddev->private;
 	int err = 1;
-	int i;
+	struct multipath_info *p = conf->multipaths + number;
 
 	print_multipath_conf(conf);
 	spin_lock_irq(&conf->device_lock);
 
-	for (i = 0; i < MD_SB_DISKS; i++) {
-		struct multipath_info *p = conf->multipaths + i;
-		if (p->used_slot && (p->number == number)) {
-			if (p->operational) {
-				printk(KERN_ERR "hot-remove-disk, slot %d is identified to be the requested disk (number %d), but is still operational!\n", i, number);
-				err = -EBUSY;
-				goto abort;
-			}
-			p->bdev = NULL;
-			p->used_slot = 0;
-			conf->nr_disks--;
-			err = 0;
-			break;
+	if (p->used_slot) {
+		if (p->operational) {
+			printk(KERN_ERR "hot-remove-disk, slot %d is identified but is still operational!\n", number);
+			err = -EBUSY;
+			goto abort;
 		}
+		p->bdev = NULL;
+		p->used_slot = 0;
+		conf->nr_disks--;
+		err = 0;
 	}
 	if (err)
 		MD_BUG();
--- ./drivers/md/raid1.c	2002/07/18 12:02:01	1.4
+++ ./drivers/md/raid1.c	2002/07/18 12:03:01	1.5
@@ -657,19 +657,7 @@ static void close_sync(conf_t *conf)
 	conf->r1buf_pool = NULL;
 }
 
-static mirror_info_t *find_spare(mddev_t *mddev, int number)
-{
-	conf_t *conf = mddev->private;
-	int i;
-	for (i = conf->raid_disks; i < MD_SB_DISKS; i++) {
-		mirror_info_t *p = conf->mirrors + i;
-		if (p->spare && p->number == number)
-			return p;
-	}
-	return NULL;
-}
-
-static int raid1_spare_active(mddev_t *mddev, mdp_disk_t **d)
+static int raid1_spare_active(mddev_t *mddev)
 {
 	int err = 0;
 	int i, failed_disk = -1, spare_disk = -1;
@@ -706,18 +694,7 @@ static int raid1_spare_active(mddev_t *m
 	 * Find the spare disk ... (can only be in the 'high'
 	 * area of the array)
 	 */
-	for (i = conf->raid_disks; i < MD_SB_DISKS; i++) {
-		tmp = conf->mirrors + i;
-		if (tmp->spare && tmp->number == (*d)->number) {
-			spare_disk = i;
-			break;
-		}
-	}
-	if (spare_disk == -1) {
-		MD_BUG();
-		err = 1;
-		goto abort;
-	}
+	spare_disk = mddev->spare->raid_disk;
 
 	sdisk = conf->mirrors + spare_disk;
 	fdisk = conf->mirrors + failed_disk;
@@ -725,7 +702,7 @@ static int raid1_spare_active(mddev_t *m
 	spare_desc = &sb->disks[sdisk->number];
 	failed_desc = &sb->disks[fdisk->number];
 
-	if (spare_desc != *d || spare_desc->raid_disk != sdisk->raid_disk ||
+	if (spare_desc->raid_disk != sdisk->raid_disk ||
 	    sdisk->raid_disk != spare_disk || fdisk->raid_disk != failed_disk ||
 	    failed_desc->raid_disk != fdisk->raid_disk) {
 		MD_BUG();
@@ -762,8 +739,6 @@ static int raid1_spare_active(mddev_t *m
 	xchg_values(spare_desc->number, failed_desc->number);
 	xchg_values(sdisk->number, fdisk->number);
 
-	*d = failed_desc;
-
 	if (!sdisk->bdev)
 		sdisk->used_slot = 0;
 	/*
@@ -794,7 +769,7 @@ static int raid1_spare_inactive(mddev_t 
 
 	print_conf(conf);
 	spin_lock_irq(&conf->device_lock);
-	p = find_spare(mddev, mddev->spare->number);
+	p = conf->mirrors + mddev->spare->raid_disk;
 	if (p) {
 		p->operational = 0;
 		p->write_only = 0;
@@ -807,7 +782,7 @@ static int raid1_spare_inactive(mddev_t 
 	return err;
 }
 
-static int raid1_spare_write(mddev_t *mddev, int number)
+static int raid1_spare_write(mddev_t *mddev)
 {
 	conf_t *conf = mddev->private;
 	mirror_info_t *p;
@@ -815,7 +790,7 @@ static int raid1_spare_write(mddev_t *md
 
 	print_conf(conf);
 	spin_lock_irq(&conf->device_lock);
-	p = find_spare(mddev, number);
+	p = conf->mirrors + mddev->spare->raid_disk;
 	if (p) {
 		p->operational = 1;
 		p->write_only = 1;
@@ -871,25 +846,19 @@ static int raid1_remove_disk(mddev_t *md
 {
 	conf_t *conf = mddev->private;
 	int err = 1;
-	int i;
+	mirror_info_t *p = conf->mirrors+ number;
 
 	print_conf(conf);
 	spin_lock_irq(&conf->device_lock);
-	for (i = 0; i < MD_SB_DISKS; i++) {
-		mirror_info_t *p = conf->mirrors + i;
-		if (p->used_slot && (p->number == number)) {
-			if (p->operational) {
-				err = -EBUSY;
-				goto abort;
-			}
-			if (p->spare && (i < conf->raid_disks))
-				break;
-			p->bdev = NULL;
-			p->used_slot = 0;
-			conf->nr_disks--;
-			err = 0;
-			break;
+	if (p->used_slot) {
+		if (p->operational) {
+			err = -EBUSY;
+			goto abort;
 		}
+		p->bdev = NULL;
+		p->used_slot = 0;
+		conf->nr_disks--;
+		err = 0;
 	}
 	if (err)
 		MD_BUG();
--- ./drivers/md/raid5.c	2002/07/18 12:02:01	1.3
+++ ./drivers/md/raid5.c	2002/07/18 12:03:01	1.4
@@ -1686,19 +1686,7 @@ static void print_raid5_conf (raid5_conf
 	}
 }
 
-static struct disk_info *find_spare(mddev_t *mddev, int number)
-{
-	raid5_conf_t *conf = mddev->private;
-	int i;
-	for (i = conf->raid_disks; i < MD_SB_DISKS; i++) {
-		struct disk_info *p = conf->disks + i;
-		if (p->spare && p->number == number)
-			return p;
-	}
-	return NULL;
-}
-
-static int raid5_spare_active(mddev_t *mddev, mdp_disk_t **d)
+static int raid5_spare_active(mddev_t *mddev)
 {
 	int err = 0;
 	int i, failed_disk=-1, spare_disk=-1;
@@ -1727,18 +1715,7 @@ static int raid5_spare_active(mddev_t *m
 	 * Find the spare disk ... (can only be in the 'high'
 	 * area of the array)
 	 */
-	for (i = conf->raid_disks; i < MD_SB_DISKS; i++) {
-		tmp = conf->disks + i;
-		if (tmp->spare && tmp->number == (*d)->number) {
-			spare_disk = i;
-			break;
-		}
-	}
-	if (spare_disk == -1) {
-		MD_BUG();
-		err = 1;
-		goto abort;
-	}
+	spare_disk = mddev->spare->raid_disk;
 
 	if (!conf->spare) {
 		MD_BUG();
@@ -1751,7 +1728,7 @@ static int raid5_spare_active(mddev_t *m
 	spare_desc = &sb->disks[sdisk->number];
 	failed_desc = &sb->disks[fdisk->number];
 
-	if (spare_desc != *d || spare_desc->raid_disk != sdisk->raid_disk ||
+	if ( spare_desc->raid_disk != sdisk->raid_disk ||
 	    sdisk->raid_disk != spare_disk || fdisk->raid_disk != failed_disk ||
 	    failed_desc->raid_disk != fdisk->raid_disk) {
 		MD_BUG();
@@ -1788,8 +1765,6 @@ static int raid5_spare_active(mddev_t *m
 	xchg_values(spare_desc->number, failed_desc->number);
 	xchg_values(sdisk->number, fdisk->number);
 
-	*d = failed_desc;
-
 	if (!sdisk->bdev)
 		sdisk->used_slot = 0;
 
@@ -1821,7 +1796,7 @@ static int raid5_spare_inactive(mddev_t 
 
 	print_raid5_conf(conf);
 	spin_lock_irq(&conf->device_lock);
-	p = find_spare(mddev, mddev->spare->number);
+	p = conf->disks + mddev->spare->raid_disk;
 	if (p) {
 		p->operational = 0;
 		p->write_only = 0;
@@ -1836,7 +1811,7 @@ static int raid5_spare_inactive(mddev_t 
 	return err;
 }
 
-static int raid5_spare_write(mddev_t *mddev, int number)
+static int raid5_spare_write(mddev_t *mddev)
 {
 	raid5_conf_t *conf = mddev->private;
 	struct disk_info *p;
@@ -1844,7 +1819,7 @@ static int raid5_spare_write(mddev_t *md
 
 	print_raid5_conf(conf);
 	spin_lock_irq(&conf->device_lock);
-	p = find_spare(mddev, number);
+	p = conf->disks + mddev->spare->raid_disk;
 	if (p && !conf->spare) {
 		p->operational = 1;
 		p->write_only = 1;
@@ -1862,25 +1837,19 @@ static int raid5_remove_disk(mddev_t *md
 {
 	raid5_conf_t *conf = mddev->private;
 	int err = 1;
-	int i;
+	struct disk_info *p = conf->disks + number;
 
 	print_raid5_conf(conf);
 	spin_lock_irq(&conf->device_lock);
 
-	for (i = 0; i < MD_SB_DISKS; i++) {
-		struct disk_info *p = conf->disks + i;
-		if (p->used_slot && p->number == number) {
-			if (p->operational) {
-				err = -EBUSY;
-				goto abort;
-			}
-			if (p->spare && i < conf->raid_disks)
-				break;
-			p->bdev = NULL;
-			p->used_slot = 0;
-			err = 0;
-			break;
+	if (p->used_slot) {
+		if (p->operational) {
+			err = -EBUSY;
+			goto abort;
 		}
+		p->bdev = NULL;
+		p->used_slot = 0;
+		err = 0;
 	}
 	if (err)
 		MD_BUG();
--- ./include/linux/raid/md_k.h	2002/07/18 12:00:52	1.3
+++ ./include/linux/raid/md_k.h	2002/07/18 12:03:01	1.4
@@ -207,9 +207,9 @@ struct mdk_personality_s
 	int (*error_handler)(mddev_t *mddev, struct block_device *bdev);
 	int (*hot_add_disk) (mddev_t *mddev, mdp_disk_t *descriptor, mdk_rdev_t *rdev);
 	int (*hot_remove_disk) (mddev_t *mddev, int number);
-	int (*spare_write) (mddev_t *mddev, int number);
+	int (*spare_write) (mddev_t *mddev);
 	int (*spare_inactive) (mddev_t *mddev);
-	int (*spare_active) (mddev_t *mddev, mdp_disk_t **descriptor);
+	int (*spare_active) (mddev_t *mddev);
 	int (*sync_request)(mddev_t *mddev, sector_t sector_nr, int go_faster);
 };
 
