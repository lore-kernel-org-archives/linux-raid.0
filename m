From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] MD - 13 of 27 - Remove concept of 'spare' drive for multipath.
Date: Thu, 18 Jul 2002 23:33:24 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1020718133324.4893@cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


### Comments for ChangeSet
Remove concept of 'spare' drive for multipath.

Multipath now treats all working devices as
active and does io to to first working one.





 ----------- Diffstat output ------------
 ./drivers/md/multipath.c         |  287 ++-------------------------------------
 ./include/linux/raid/multipath.h |    1 
 2 files changed, 20 insertions(+), 268 deletions(-)

--- ./drivers/md/multipath.c	2002/07/18 12:02:01	1.9
+++ ./drivers/md/multipath.c	2002/07/18 12:02:21	1.10
@@ -55,8 +55,6 @@ static mdk_personality_t multipath_perso
 static spinlock_t retry_list_lock = SPIN_LOCK_UNLOCKED;
 struct multipath_bh *multipath_retry_list = NULL, **multipath_retry_tail;
 
-static int multipath_spare_write(mddev_t *, int);
-static int multipath_spare_active(mddev_t *mddev, mdp_disk_t **d);
 
 static void *mp_pool_alloc(int gfp_flags, void *data)
 {
@@ -155,7 +153,7 @@ static int multipath_read_balance (multi
 {
 	int disk;
 
-	for (disk = 0; disk < conf->raid_disks; disk++)	
+	for (disk = 0; disk < MD_SB_DISKS; disk++)	
 		if (conf->multipaths[disk].operational)
 			return disk;
 	BUG();
@@ -239,20 +237,10 @@ static int multipath_error (mddev_t *mdd
 	multipath_conf_t *conf = mddev_to_conf(mddev);
 	struct multipath_info * multipaths = conf->multipaths;
 	int disks = MD_SB_DISKS;
-	int other_paths = 1;
 	int i;
 
-	if (conf->working_disks == 1) {
-		other_paths = 0;
-		for (i = 0; i < disks; i++) {
-			if (multipaths[i].spare) {
-				other_paths = 1;
-				break;
-			}
-		}
-	}
 
-	if (!other_paths) {
+	if (conf->working_disks <= 1) {
 		/*
 		 * Uh oh, we can do nothing if this is our last path, but
 		 * first check if this is a queued request for a device
@@ -263,6 +251,7 @@ static int multipath_error (mddev_t *mdd
 				return 0;
 		}
 		printk (LAST_DISK);
+		return 1; /* leave it active... it's all we have */
 	} else {
 		/*
 		 * Mark disk as unusable
@@ -273,24 +262,6 @@ static int multipath_error (mddev_t *mdd
 				break;
 			}
 		}
-		if (!conf->working_disks) {
-			int err = 1;
-			mdp_disk_t *spare;
-			mdp_super_t *sb = mddev->sb;
-
-			spare = get_spare(mddev);
-			if (spare) {
-				err = multipath_spare_write(mddev, spare->number);
-				printk("got DISKOP_SPARE_WRITE err: %d. (spare_faulty(): %d)\n", err, disk_faulty(spare));
-			}
-			if (!err && !disk_faulty(spare)) {
-				multipath_spare_active(mddev, &spare);
-				mark_disk_sync(spare);
-				mark_disk_active(spare);
-				sb->active_disks++;
-				sb->spare_disks--;
-			}
-		}
 	}
 	return 0;
 }
@@ -315,183 +286,15 @@ static void print_multipath_conf (multip
 
 	for (i = 0; i < MD_SB_DISKS; i++) {
 		tmp = conf->multipaths + i;
-		if (tmp->spare || tmp->operational || tmp->number ||
+		if (tmp->operational || tmp->number ||
 				tmp->raid_disk || tmp->used_slot)
-			printk(" disk%d, s:%d, o:%d, n:%d rd:%d us:%d dev:%s\n",
-				i, tmp->spare,tmp->operational,
+			printk(" disk%d, o:%d, n:%d rd:%d us:%d dev:%s\n",
+				i,tmp->operational,
 				tmp->number,tmp->raid_disk,tmp->used_slot,
 				bdev_partition_name(tmp->bdev));
 	}
 }
 
-/*
- * Find the spare disk ... (can only be in the 'high' area of the array)
- */
-static struct multipath_info *find_spare(mddev_t *mddev, int number)
-{
-	multipath_conf_t *conf = mddev->private;
-	int i;
-	for (i = conf->raid_disks; i < MD_SB_DISKS; i++) {
-		struct multipath_info *p = conf->multipaths + i;
-		if (p->spare && p->number == number)
-			return p;
-	}
-	return NULL;
-}
-
-static int multipath_spare_inactive(mddev_t *mddev)
-{
-	multipath_conf_t *conf = mddev->private;
-	struct multipath_info *p;
-	int err = 0;
-
-	print_multipath_conf(conf);
-	spin_lock_irq(&conf->device_lock);
-	p = find_spare(mddev, mddev->spare->number);
-	if (p) {
-		p->operational = 0;
-	} else {
-		MD_BUG();
-		err = 1;
-	}
-	spin_unlock_irq(&conf->device_lock);
-
-	print_multipath_conf(conf);
-	return err;
-}
-
-static int multipath_spare_write(mddev_t *mddev, int number)
-{
-	multipath_conf_t *conf = mddev->private;
-	struct multipath_info *p;
-	int err = 0;
-
-	print_multipath_conf(conf);
-	spin_lock_irq(&conf->device_lock);
-	p = find_spare(mddev, number);
-	if (p) {
-		p->operational = 1;
-	} else {
-		MD_BUG();
-		err = 1;
-	}
-	spin_unlock_irq(&conf->device_lock);
-
-	print_multipath_conf(conf);
-	return err;
-}
-
-static int multipath_spare_active(mddev_t *mddev, mdp_disk_t **d)
-{
-	int err = 0;
-	int i, failed_disk=-1, spare_disk=-1;
-	multipath_conf_t *conf = mddev->private;
-	struct multipath_info *tmp, *sdisk, *fdisk;
-	mdp_super_t *sb = mddev->sb;
-	mdp_disk_t *failed_desc, *spare_desc;
-	mdk_rdev_t *spare_rdev, *failed_rdev;
-
-	print_multipath_conf(conf);
-	spin_lock_irq(&conf->device_lock);
-	/*
-	 * Find the failed disk within the MULTIPATH configuration ...
-	 * (this can only be in the first conf->working_disks part)
-	 */
-	for (i = 0; i < conf->raid_disks; i++) {
-		tmp = conf->multipaths + i;
-		if ((!tmp->operational && !tmp->spare) ||
-				!tmp->used_slot) {
-			failed_disk = i;
-			break;
-		}
-	}
-	/*
-	 * When we activate a spare disk we _must_ have a disk in
-	 * the lower (active) part of the array to replace. 
-	 */
-	if (failed_disk == -1) {
-		MD_BUG();
-		err = 1;
-		goto abort;
-	}
-	/*
-	 * Find the spare disk ... (can only be in the 'high'
-	 * area of the array)
-	 */
-	for (i = conf->raid_disks; i < MD_SB_DISKS; i++) {
-		tmp = conf->multipaths + i;
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
-
-	sdisk = conf->multipaths + spare_disk;
-	fdisk = conf->multipaths + failed_disk;
-
-	spare_desc = &sb->disks[sdisk->number];
-	failed_desc = &sb->disks[fdisk->number];
-
-	if (spare_desc != *d || spare_desc->raid_disk != sdisk->raid_disk ||
-	    sdisk->raid_disk != spare_disk || fdisk->raid_disk != failed_disk ||
-	    failed_desc->raid_disk != fdisk->raid_disk) {
-		MD_BUG();
-		err = 1;
-		goto abort;
-	}
-
-	/*
-	 * do the switch finally
-	 */
-	spare_rdev = find_rdev_nr(mddev, spare_desc->number);
-	failed_rdev = find_rdev_nr(mddev, failed_desc->number);
-	xchg_values(spare_rdev->desc_nr, failed_rdev->desc_nr);
-	spare_rdev->alias_device = 0;
-	failed_rdev->alias_device = 1;
-
-	xchg_values(*spare_desc, *failed_desc);
-	xchg_values(*fdisk, *sdisk);
-
-	/*
-	 * (careful, 'failed' and 'spare' are switched from now on)
-	 *
-	 * we want to preserve linear numbering and we want to
-	 * give the proper raid_disk number to the now activated
-	 * disk. (this means we switch back these values)
-	 */
-
-	xchg_values(spare_desc->raid_disk, failed_desc->raid_disk);
-	xchg_values(sdisk->raid_disk, fdisk->raid_disk);
-	xchg_values(spare_desc->number, failed_desc->number);
-	xchg_values(sdisk->number, fdisk->number);
-
-	*d = failed_desc;
-
-	if (!sdisk->bdev)
-		sdisk->used_slot = 0;
-	/*
-	 * this really activates the spare.
-	 */
-	fdisk->spare = 0;
-
-	/*
-	 * if we activate a spare, we definitely replace a
-	 * non-operational disk slot in the 'low' area of
-	 * the disk array.
-	 */
-
-	conf->working_disks++;
-abort:
-	spin_unlock_irq(&conf->device_lock);
-
-	print_multipath_conf(conf);
-	return err;
-}
 
 static int multipath_add_disk(mddev_t *mddev, mdp_disk_t *added_desc,
 	mdk_rdev_t *rdev)
@@ -502,7 +305,7 @@ static int multipath_add_disk(mddev_t *m
 
 	print_multipath_conf(conf);
 	spin_lock_irq(&conf->device_lock);
-	for (i = conf->raid_disks; i < MD_SB_DISKS; i++) {
+	for (i = 0; i < MD_SB_DISKS; i++) {
 		struct multipath_info *p = conf->multipaths + i;
 		if (!p->used_slot) {
 			if (added_desc->number != i)
@@ -510,10 +313,10 @@ static int multipath_add_disk(mddev_t *m
 			p->number = added_desc->number;
 			p->raid_disk = added_desc->raid_disk;
 			p->bdev = rdev->bdev;
-			p->operational = 0;
-			p->spare = 1;
+			p->operational = 1;
 			p->used_slot = 1;
 			conf->nr_disks++;
+			conf->working_disks++;
 			err = 0;
 			break;
 		}
@@ -543,8 +346,6 @@ static int multipath_remove_disk(mddev_t
 				err = -EBUSY;
 				goto abort;
 			}
-			if (p->spare && i < conf->raid_disks)
-				break;
 			p->bdev = NULL;
 			p->used_slot = 0;
 			conf->nr_disks--;
@@ -655,10 +456,10 @@ static int multipath_run (mddev_t *mddev
 {
 	multipath_conf_t *conf;
 	int i, j, disk_idx;
-	struct multipath_info *disk, *disk2;
+	struct multipath_info *disk;
 	mdp_super_t *sb = mddev->sb;
-	mdp_disk_t *desc, *desc2;
-	mdk_rdev_t *rdev, *def_rdev = NULL;
+	mdp_disk_t *desc;
+	mdk_rdev_t *rdev;
 	struct list_head *tmp;
 	int num_rdevs = 0;
 
@@ -709,69 +510,24 @@ static int multipath_run (mddev_t *mddev
 			printk(NOT_IN_SYNC, bdev_partition_name(rdev->bdev));
 
 		/*
-		 * Mark all disks as spare to start with, then pick our
-		 * active disk.  If we have a disk that is marked active
-		 * in the sb, then use it, else use the first rdev.
+		 * Mark all disks as active to start with, there are no
+		 * spares.  multipath_read_balance deals with choose
+		 * the "best" operational device.
 		 */
 		disk->number = desc->number;
 		disk->raid_disk = desc->raid_disk;
 		disk->bdev = rdev->bdev;
-		disk->operational = 0;
-		disk->spare = 1;
+		disk->operational = 1;
 		disk->used_slot = 1;
 		mark_disk_sync(desc);
-
-		if (disk_active(desc)) {
-			if(!conf->working_disks) {
-				printk(OPERATIONAL, bdev_partition_name(rdev->bdev),
- 					desc->raid_disk);
-				disk->operational = 1;
-				disk->spare = 0;
-				conf->working_disks++;
-				def_rdev = rdev;
-			} else {
-				mark_disk_spare(desc);
-			}
-		} else
-			mark_disk_spare(desc);
-
-		if(!num_rdevs++) def_rdev = rdev;
-	}
-	if(!conf->working_disks && num_rdevs) {
-		desc = &sb->disks[def_rdev->desc_nr];
-		disk = conf->multipaths + desc->raid_disk;
-		printk(OPERATIONAL, bdev_partition_name(def_rdev->bdev),
-			disk->raid_disk);
-		disk->operational = 1;
-		disk->spare = 0;
-		conf->working_disks++;
 		mark_disk_active(desc);
+		num_rdevs++;
 	}
-	/*
-	 * Make sure our active path is in desc spot 0
-	 */
-	if(def_rdev->desc_nr != 0) {
-		rdev = find_rdev_nr(mddev, 0);
-		desc = &sb->disks[def_rdev->desc_nr];
-		desc2 = sb->disks;
-		disk = conf->multipaths + desc->raid_disk;
-		disk2 = conf->multipaths + desc2->raid_disk;
-		xchg_values(*desc2,*desc);
-		xchg_values(*disk2,*disk);
-		xchg_values(desc2->number, desc->number);
-		xchg_values(disk2->number, disk->number);
-		xchg_values(desc2->raid_disk, desc->raid_disk);
-		xchg_values(disk2->raid_disk, disk->raid_disk);
-		if(rdev) {
-			xchg_values(def_rdev->desc_nr,rdev->desc_nr);
-		} else {
-			def_rdev->desc_nr = 0;
-		}
-	}
-	conf->raid_disks = sb->raid_disks = sb->active_disks = 1;
+
+	conf->raid_disks = sb->raid_disks = sb->active_disks = num_rdevs;
 	conf->nr_disks = sb->nr_disks = sb->working_disks = num_rdevs;
 	sb->failed_disks = 0;
-	sb->spare_disks = num_rdevs - 1;
+	sb->spare_disks = 0;
 	mddev->sb_dirty = 1;
 	conf->mddev = mddev;
 	conf->device_lock = SPIN_LOCK_UNLOCKED;
@@ -862,9 +618,6 @@ static mdk_personality_t multipath_perso
 	error_handler:	multipath_error,
 	hot_add_disk:	multipath_add_disk,
 	hot_remove_disk:multipath_remove_disk,
-	spare_inactive:	multipath_spare_inactive,
-	spare_active:	multipath_spare_active,
-	spare_write:	multipath_spare_write,
 };
 
 static int __init multipath_init (void)
--- ./include/linux/raid/multipath.h	2002/07/18 12:00:58	1.5
+++ ./include/linux/raid/multipath.h	2002/07/18 12:02:21	1.6
@@ -13,7 +13,6 @@ struct multipath_info {
 	 * State bits:
 	 */
 	int		operational;
-	int		spare;
 
 	int		used_slot;
 };
