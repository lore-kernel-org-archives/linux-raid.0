From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] MD - 22 of 27 - Remove number and raid_disk from personality arrays
Date: Thu, 18 Jul 2002 23:34:15 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1020718133415.5014@cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


### Comments for ChangeSet
Remove number and raid_disk from personality arrays

These are redundant.  number not needed any more
raid_disk never was as that is the index.





 ----------- Diffstat output ------------
 ./drivers/md/multipath.c         |   11 +++--------
 ./drivers/md/raid1.c             |   16 ++--------------
 ./drivers/md/raid5.c             |   18 ++----------------
 ./include/linux/raid/multipath.h |    2 --
 ./include/linux/raid/raid1.h     |    2 --
 ./include/linux/raid/raid5.h     |    2 --
 6 files changed, 7 insertions(+), 44 deletions(-)

--- ./drivers/md/multipath.c	2002/07/18 12:07:31	1.13
+++ ./drivers/md/multipath.c	2002/07/18 12:07:45	1.14
@@ -279,11 +279,10 @@ static void print_multipath_conf (multip
 
 	for (i = 0; i < MD_SB_DISKS; i++) {
 		tmp = conf->multipaths + i;
-		if (tmp->operational || tmp->number ||
-				tmp->raid_disk || tmp->used_slot)
-			printk(" disk%d, o:%d, n:%d rd:%d us:%d dev:%s\n",
+		if (tmp->operational || tmp->used_slot)
+			printk(" disk%d, o:%d, us:%d dev:%s\n",
 				i,tmp->operational,
-				tmp->number,tmp->raid_disk,tmp->used_slot,
+				tmp->used_slot,
 				bdev_partition_name(tmp->bdev));
 	}
 }
@@ -298,8 +297,6 @@ static int multipath_add_disk(mddev_t *m
 	print_multipath_conf(conf);
 	spin_lock_irq(&conf->device_lock);
 	if (!p->used_slot) {
-		p->number = rdev->desc_nr;
-		p->raid_disk = rdev->raid_disk;
 		p->bdev = rdev->bdev;
 		p->operational = 1;
 		p->used_slot = 1;
@@ -489,8 +486,6 @@ static int multipath_run (mddev_t *mddev
 		 * spares.  multipath_read_balance deals with choose
 		 * the "best" operational device.
 		 */
-		disk->number = rdev->desc_nr;
-		disk->raid_disk = disk_idx;
 		disk->bdev = rdev->bdev;
 		disk->operational = 1;
 		disk->used_slot = 1;
--- ./drivers/md/raid1.c	2002/07/18 12:07:31	1.10
+++ ./drivers/md/raid1.c	2002/07/18 12:07:45	1.11
@@ -630,9 +630,9 @@ static void print_conf(conf_t *conf)
 
 	for (i = 0; i < MD_SB_DISKS; i++) {
 		tmp = conf->mirrors + i;
-		printk(" disk %d, s:%d, o:%d, n:%d rd:%d us:%d dev:%s\n",
+		printk(" disk %d, s:%d, o:%d, us:%d dev:%s\n",
 			i, tmp->spare, tmp->operational,
-			tmp->number, tmp->raid_disk, tmp->used_slot,
+			tmp->used_slot,
 			bdev_partition_name(tmp->bdev));
 	}
 }
@@ -717,8 +717,6 @@ static int raid1_spare_active(mddev_t *m
 	 * give the proper raid_disk number to the now activated
 	 * disk. (this means we switch back these values)
 	 */
-	xchg_values(sdisk->raid_disk, fdisk->raid_disk);
-	xchg_values(sdisk->number, fdisk->number);
 
 	if (!sdisk->bdev)
 		sdisk->used_slot = 0;
@@ -794,8 +792,6 @@ static int raid1_add_disk(mddev_t *mddev
 	print_conf(conf);
 	spin_lock_irq(&conf->device_lock);
 	if (!p->used_slot) {
-		p->number = rdev->desc_nr;
-		p->raid_disk = rdev->raid_disk;
 		/* it will be held open by rdev */
 		p->bdev = rdev->bdev;
 		p->operational = 0;
@@ -1233,8 +1229,6 @@ static int run(mddev_t *mddev)
 		disk = conf->mirrors + disk_idx;
 
 		if (rdev->faulty) {
-			disk->number = rdev->desc_nr;
-			disk->raid_disk = disk_idx;
 			disk->bdev = rdev->bdev;
 			disk->operational = 0;
 			disk->write_only = 0;
@@ -1252,8 +1246,6 @@ static int run(mddev_t *mddev)
 			}
 			printk(OPERATIONAL, bdev_partition_name(rdev->bdev),
 					disk_idx);
-			disk->number = rdev->desc_nr;
-			disk->raid_disk = disk_idx;
 			disk->bdev = rdev->bdev;
 			disk->operational = 1;
 			disk->write_only = 0;
@@ -1266,8 +1258,6 @@ static int run(mddev_t *mddev)
 		 * Must be a spare disk ..
 		 */
 			printk(SPARE, bdev_partition_name(rdev->bdev));
-			disk->number = rdev->desc_nr;
-			disk->raid_disk = disk_idx;
 			disk->bdev = rdev->bdev;
 			disk->operational = 0;
 			disk->write_only = 0;
@@ -1295,8 +1285,6 @@ static int run(mddev_t *mddev)
 		disk = conf->mirrors + i;
 
 		if (!disk->used_slot) {
-			disk->number = i;
-			disk->raid_disk = i;
 			disk->bdev = NULL;
 			disk->operational = 0;
 			disk->write_only = 0;
--- ./drivers/md/raid5.c	2002/07/18 12:06:48	1.8
+++ ./drivers/md/raid5.c	2002/07/18 12:07:45	1.9
@@ -1410,8 +1410,6 @@ static int run (mddev_t *mddev)
 
 		if (rdev->faulty) {
 			printk(KERN_ERR "raid5: disabled device %s (errors detected)\n", bdev_partition_name(rdev->bdev));
-			disk->number = rdev->desc_nr;
-			disk->raid_disk = raid_disk;
 			disk->bdev = rdev->bdev;
 
 			disk->operational = 0;
@@ -1427,8 +1425,6 @@ static int run (mddev_t *mddev)
 			}
 			printk(KERN_INFO "raid5: device %s operational as raid disk %d\n", bdev_partition_name(rdev->bdev), raid_disk);
 	
-			disk->number = rdev->desc_nr;
-			disk->raid_disk = raid_disk;
 			disk->bdev = rdev->bdev;
 			disk->operational = 1;
 			disk->used_slot = 1;
@@ -1439,8 +1435,6 @@ static int run (mddev_t *mddev)
 			 * Must be a spare disk ..
 			 */
 			printk(KERN_INFO "raid5: spare disk %s\n", bdev_partition_name(rdev->bdev));
-			disk->number = rdev->desc_nr;
-			disk->raid_disk = raid_disk;
 			disk->bdev = rdev->bdev;
 
 			disk->operational = 0;
@@ -1454,9 +1448,6 @@ static int run (mddev_t *mddev)
 		disk = conf->disks + i;
 
 		if (!disk->used_slot) {
-
-			disk->number = i;
-			disk->raid_disk = i;
 			disk->bdev = NULL;
 
 			disk->operational = 0;
@@ -1634,9 +1625,9 @@ static void print_raid5_conf (raid5_conf
 	for (i = 0; i < conf->working_disks+conf->failed_disks; i++) {
 #endif
 		tmp = conf->disks + i;
-		printk(" disk %d, s:%d, o:%d, n:%d rd:%d us:%d dev:%s\n",
+		printk(" disk %d, s:%d, o:%d, us:%d dev:%s\n",
 			i, tmp->spare,tmp->operational,
-			tmp->number,tmp->raid_disk,tmp->used_slot,
+			tmp->used_slot,
 			bdev_partition_name(tmp->bdev));
 	}
 }
@@ -1704,9 +1695,6 @@ static int raid5_spare_active(mddev_t *m
 	 * disk. (this means we switch back these values)
 	 */
 
-	xchg_values(sdisk->raid_disk, fdisk->raid_disk);
-	xchg_values(sdisk->number, fdisk->number);
-
 	if (!sdisk->bdev)
 		sdisk->used_slot = 0;
 
@@ -1815,8 +1803,6 @@ static int raid5_add_disk(mddev_t *mddev
 	 */
 
 	if (!p->used_slot) {
-		p->number = rdev->desc_nr;
-		p->raid_disk = rdev->raid_disk;
 		/* it will be held open by rdev */
 		p->bdev = rdev->bdev;
 		p->operational = 0;
--- ./include/linux/raid/multipath.h	2002/07/18 12:07:32	1.7
+++ ./include/linux/raid/multipath.h	2002/07/18 12:07:45	1.8
@@ -5,8 +5,6 @@
 #include <linux/bio.h>
 
 struct multipath_info {
-	int		number;
-	int		raid_disk;
 	struct block_device *bdev;
 
 	/*
--- ./include/linux/raid/raid1.h	2002/07/18 12:07:32	1.2
+++ ./include/linux/raid/raid1.h	2002/07/18 12:07:45	1.3
@@ -6,8 +6,6 @@
 typedef struct mirror_info mirror_info_t;
 
 struct mirror_info {
-	int		number;
-	int		raid_disk;
 	struct block_device *bdev;
 	sector_t	head_position;
 	atomic_t	nr_pending;
--- ./include/linux/raid/raid5.h	2002/07/18 12:07:42	1.1
+++ ./include/linux/raid/raid5.h	2002/07/18 12:07:45	1.2
@@ -194,8 +194,6 @@ struct stripe_head {
 struct disk_info {
 	struct block_device *bdev;
 	int	operational;
-	int	number;
-	int	raid_disk;
 	int	write_only;
 	int	spare;
 	int	used_slot;
