From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 6 of 13 - Remove used_slot field from per-personality info
Date: Thu, 22 Aug 2002 10:34:09 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E17hfvN-00050F-00@notabene.cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


### Comments for ChangeSet

This is equivalent to ->rdev != NULL, so it isn't needed.


 ----------- Diffstat output ------------
 ./drivers/md/multipath.c         |   14 +++++---------
 ./drivers/md/raid1.c             |   28 +++++++++-------------------
 ./drivers/md/raid5.c             |   31 ++++++-------------------------
 ./include/linux/raid/multipath.h |    2 --
 ./include/linux/raid/raid1.h     |    2 --
 ./include/linux/raid/raid5.h     |    1 -
 6 files changed, 20 insertions(+), 58 deletions(-)

--- ./include/linux/raid/raid1.h	2002/08/21 23:10:24	1.3
+++ ./include/linux/raid/raid1.h	2002/08/21 23:10:56	1.4
@@ -15,8 +15,6 @@ struct mirror_info {
 	int		operational;
 	int		write_only;
 	int		spare;
-
-	int		used_slot;
 };
 
 typedef struct r1bio_s r1bio_t;
--- ./include/linux/raid/raid5.h	2002/08/21 23:07:28	1.2
+++ ./include/linux/raid/raid5.h	2002/08/21 23:10:56	1.3
@@ -196,7 +196,6 @@ struct disk_info {
 	int		operational;
 	int		write_only;
 	int		spare;
-	int		used_slot;
 };
 
 struct raid5_private_data {
--- ./include/linux/raid/multipath.h	2002/08/21 23:07:28	1.2
+++ ./include/linux/raid/multipath.h	2002/08/21 23:10:56	1.3
@@ -11,8 +11,6 @@ struct multipath_info {
 	 * State bits:
 	 */
 	int		operational;
-
-	int		used_slot;
 };
 
 struct multipath_private_data {
--- ./drivers/md/raid5.c	2002/08/21 23:10:25	1.5
+++ ./drivers/md/raid5.c	2002/08/21 23:10:56	1.6
@@ -1423,7 +1423,6 @@ static int run (mddev_t *mddev)
 			disk->operational = 0;
 			disk->write_only = 0;
 			disk->spare = 0;
-			disk->used_slot = 1;
 			continue;
 		}
 		if (rdev->in_sync) {
@@ -1435,7 +1434,6 @@ static int run (mddev_t *mddev)
 	
 			disk->rdev = rdev;
 			disk->operational = 1;
-			disk->used_slot = 1;
 
 			conf->working_disks++;
 		} else {
@@ -1448,20 +1446,16 @@ static int run (mddev_t *mddev)
 			disk->operational = 0;
 			disk->write_only = 0;
 			disk->spare = 1;
-			disk->used_slot = 1;
 		}
 	}
 
 	for (i = 0; i < conf->raid_disks; i++) {
 		disk = conf->disks + i;
 
-		if (!disk->used_slot) {
-			disk->rdev = NULL;
-
+		if (!disk->rdev) {
 			disk->operational = 0;
 			disk->write_only = 0;
 			disk->spare = 0;
-			disk->used_slot = 1;
 		}
 	}
 
@@ -1476,14 +1470,6 @@ static int run (mddev_t *mddev)
 	conf->algorithm = mddev->layout;
 	conf->max_nr_stripes = NR_STRIPES;
 
-#if 0
-	for (i = 0; i < conf->raid_disks; i++) {
-		if (!conf->disks[i].used_slot) {
-			MD_BUG();
-			goto abort;
-		}
-	}
-#endif
 	if (!conf->chunk_size || conf->chunk_size % 4) {
 		printk(KERN_ERR "raid5: invalid chunk size %d for md%d\n", conf->chunk_size, mdidx(mddev));
 		goto abort;
@@ -1634,9 +1620,9 @@ static void print_raid5_conf (raid5_conf
 	for (i = 0; i < conf->working_disks+conf->failed_disks; i++) {
 #endif
 		tmp = conf->disks + i;
-		printk(" disk %d, s:%d, o:%d, us:%d dev:%s\n",
+		if (tmp->rdev)
+		printk(" disk %d, s:%d, o:%d, dev:%s\n",
 			i, tmp->spare,tmp->operational,
-			tmp->used_slot,
 			bdev_partition_name(tmp->rdev->bdev));
 	}
 }
@@ -1654,7 +1640,7 @@ static int raid5_spare_active(mddev_t *m
 	for (i = 0; i < conf->raid_disks; i++) {
 		tmp = conf->disks + i;
 		if ((!tmp->operational && !tmp->spare) ||
-				!tmp->used_slot) {
+				!tmp->rdev) {
 			failed_disk = i;
 			break;
 		}
@@ -1704,9 +1690,6 @@ static int raid5_spare_active(mddev_t *m
 	 * disk. (this means we switch back these values)
 	 */
 
-	if (!sdisk->rdev)
-		sdisk->used_slot = 0;
-
 	/*
 	 * this really activates the spare.
 	 */
@@ -1782,14 +1765,13 @@ static int raid5_remove_disk(mddev_t *md
 	print_raid5_conf(conf);
 	spin_lock_irq(&conf->device_lock);
 
-	if (p->used_slot) {
+	if (p->rdev) {
 		if (p->operational || 
 		    atomic_read(&p->rdev->nr_pending)) {
 			err = -EBUSY;
 			goto abort;
 		}
 		p->rdev = NULL;
-		p->used_slot = 0;
 		err = 0;
 	}
 	if (err)
@@ -1812,13 +1794,12 @@ static int raid5_add_disk(mddev_t *mddev
 	 * find the disk ...
 	 */
 
-	if (!p->used_slot) {
+	if (!p->rdev) {
 		/* it will be held open by rdev */
 		p->rdev = rdev;
 		p->operational = 0;
 		p->write_only = 0;
 		p->spare = 1;
-		p->used_slot = 1;
 		err = 0;
 	}
 	if (err)
--- ./drivers/md/raid1.c	2002/08/21 23:10:25	1.4
+++ ./drivers/md/raid1.c	2002/08/21 23:10:56	1.5
@@ -652,10 +652,10 @@ static void print_conf(conf_t *conf)
 
 	for (i = 0; i < MD_SB_DISKS; i++) {
 		tmp = conf->mirrors + i;
-		printk(" disk %d, s:%d, o:%d, us:%d dev:%s\n",
-			i, tmp->spare, tmp->operational,
-			tmp->used_slot,
-			bdev_partition_name(tmp->rdev->bdev));
+		if (tmp->rdev)
+			printk(" disk %d, s:%d, o:%d, dev:%s\n",
+			       i, tmp->spare, tmp->operational,
+			       bdev_partition_name(tmp->rdev->bdev));
 	}
 }
 
@@ -690,7 +690,7 @@ static int raid1_spare_active(mddev_t *m
 	for (i = 0; i < conf->raid_disks; i++) {
 		tmp = conf->mirrors + i;
 		if ((!tmp->operational && !tmp->spare) ||
-				!tmp->used_slot) {
+				!tmp->rdev) {
 			failed_disk = i;
 			break;
 		}
@@ -740,8 +740,6 @@ static int raid1_spare_active(mddev_t *m
 	 * disk. (this means we switch back these values)
 	 */
 
-	if (!sdisk->rdev)
-		sdisk->used_slot = 0;
 	/*
 	 * this really activates the spare.
 	 */
@@ -813,12 +811,11 @@ static int raid1_add_disk(mddev_t *mddev
 
 	print_conf(conf);
 	spin_lock_irq(&conf->device_lock);
-	if (!p->used_slot) {
+	if (!p->rdev) {
 		p->rdev = rdev;
 		p->operational = 0;
 		p->write_only = 0;
 		p->spare = 1;
-		p->used_slot = 1;
 		p->head_position = 0;
 		err = 0;
 	}
@@ -838,14 +835,13 @@ static int raid1_remove_disk(mddev_t *md
 
 	print_conf(conf);
 	spin_lock_irq(&conf->device_lock);
-	if (p->used_slot) {
+	if (p->rdev) {
 		if (p->operational ||
 			(p->rdev && atomic_read(&p->rdev->nr_pending))) {
 			err = -EBUSY;
 			goto abort;
 		}
 		p->rdev = NULL;
-		p->used_slot = 0;
 		err = 0;
 	}
 	if (err)
@@ -1265,7 +1261,6 @@ static int run(mddev_t *mddev)
 			disk->operational = 0;
 			disk->write_only = 0;
 			disk->spare = 0;
-			disk->used_slot = 1;
 			disk->head_position = 0;
 			continue;
 		}
@@ -1282,7 +1277,6 @@ static int run(mddev_t *mddev)
 			disk->operational = 1;
 			disk->write_only = 0;
 			disk->spare = 0;
-			disk->used_slot = 1;
 			disk->head_position = 0;
 			conf->working_disks++;
 		} else {
@@ -1294,7 +1288,6 @@ static int run(mddev_t *mddev)
 			disk->operational = 0;
 			disk->write_only = 0;
 			disk->spare = 1;
-			disk->used_slot = 1;
 			disk->head_position = 0;
 		}
 	}
@@ -1316,16 +1309,13 @@ static int run(mddev_t *mddev)
 
 		disk = conf->mirrors + i;
 
-		if (!disk->used_slot) {
-			disk->rdev = NULL;
+		if (!disk->rdev) {
 			disk->operational = 0;
 			disk->write_only = 0;
 			disk->spare = 0;
-			disk->used_slot = 1;
 			disk->head_position = 0;
-		}
-		if (!disk->used_slot)
 			mddev->degraded++;
+		}
 	}
 
 	/*
--- ./drivers/md/multipath.c	2002/08/21 23:10:25	1.4
+++ ./drivers/md/multipath.c	2002/08/21 23:10:56	1.5
@@ -288,11 +288,10 @@ static void print_multipath_conf (multip
 
 	for (i = 0; i < MD_SB_DISKS; i++) {
 		tmp = conf->multipaths + i;
-		if (tmp->operational || tmp->used_slot)
-			printk(" disk%d, o:%d, us:%d dev:%s\n",
+		if (tmp->rdev)
+			printk(" disk%d, o:%d, dev:%s\n",
 				i,tmp->operational,
-				tmp->used_slot,
-				bdev_partition_name(tmp->rdev->bdev));
+			       bdev_partition_name(tmp->rdev->bdev));
 	}
 }
 
@@ -305,10 +304,9 @@ static int multipath_add_disk(mddev_t *m
 
 	print_multipath_conf(conf);
 	spin_lock_irq(&conf->device_lock);
-	if (!p->used_slot) {
+	if (!p->rdev) {
 		p->rdev = rdev;
 		p->operational = 1;
-		p->used_slot = 1;
 		conf->working_disks++;
 		err = 0;
 	}
@@ -329,7 +327,7 @@ static int multipath_remove_disk(mddev_t
 	print_multipath_conf(conf);
 	spin_lock_irq(&conf->device_lock);
 
-	if (p->used_slot) {
+	if (p->rdev) {
 		if (p->operational ||
 		    (p->rdev && atomic_read(&p->rdev->nr_pending))) {
 			printk(KERN_ERR "hot-remove-disk, slot %d is identified but is still operational!\n", number);
@@ -337,7 +335,6 @@ static int multipath_remove_disk(mddev_t
 			goto abort;
 		}
 		p->rdev = NULL;
-		p->used_slot = 0;
 		err = 0;
 	}
 	if (err)
@@ -497,7 +494,6 @@ static int multipath_run (mddev_t *mddev
 		 */
 		disk->rdev = rdev;
 		disk->operational = 1;
-		disk->used_slot = 1;
 		num_rdevs++;
 	}
 
