From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] MD - 19 of 27 - Don't maintain disc status in superblock.
Date: Thu, 18 Jul 2002 23:33:59 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1020718133359.4972@cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


### Comments for ChangeSet
Don't maintain disc status in superblock.

The state is now in rdev so we don't maintain it
in superblock any more.
We also nolonger test content of superblock for
disk status
mddev->spare is now an rdev and not a superblock fragment.




 ----------- Diffstat output ------------
 ./drivers/md/md.c           |  387 ++++++--------------------------------------
 ./drivers/md/multipath.c    |   69 +------
 ./drivers/md/raid1.c        |  128 +++-----------
 ./drivers/md/raid5.c        |  124 +++-----------
 ./include/linux/raid/md_k.h |    6 
 5 files changed, 137 insertions(+), 577 deletions(-)

--- ./drivers/md/md.c	2002/07/18 12:06:12	1.12
+++ ./drivers/md/md.c	2002/07/18 12:06:48	1.13
@@ -342,23 +342,6 @@ static unsigned int zoned_raid_size(mdde
 	return 0;
 }
 
-static void remove_descriptor(mdp_disk_t *disk, mdp_super_t *sb)
-{
-	if (disk_active(disk)) {
-		sb->working_disks--;
-	} else {
-		if (disk_spare(disk)) {
-			sb->spare_disks--;
-			sb->working_disks--;
-		} else	{
-			sb->failed_disks--;
-		}
-	}
-	sb->nr_disks--;
-	disk->major = 0;
-	disk->minor = 0;
-	mark_disk_removed(disk);
-}
 
 #define BAD_MAGIC KERN_ERR \
 "md: invalid raid superblock magic on %s\n"
@@ -1091,8 +1074,8 @@ abort_free:
 static int analyze_sbs(mddev_t * mddev)
 {
 	int out_of_date = 0, i;
-	struct list_head *tmp, *tmp2;
-	mdk_rdev_t *rdev, *rdev2, *freshest;
+	struct list_head *tmp;
+	mdk_rdev_t *rdev, *freshest;
 	mdp_super_t *sb;
 
 	/*
@@ -1216,203 +1199,15 @@ static int analyze_sbs(mddev_t * mddev)
 			rdev->raid_disk = desc->raid_disk;
 			rdev->in_sync = rdev->faulty = 0;
 
-			if (desc->state & (1<<MD_DISK_FAULTY))
+			if (desc->state & (1<<MD_DISK_FAULTY)) {
 				rdev->faulty = 1;
-			else if (desc->state & (1<<MD_DISK_SYNC) &&
-				 rdev->raid_disk < mddev->sb-raid_disks)
-				rdev->in_sync = 1;
-		}
-	}
-	/*
-	 * Fix up changed device names ... but only if this disk has a
-	 * recent update time. Use faulty checksum ones too.
-	 */
-	if (mddev->sb->level != LEVEL_MULTIPATH)
-	ITERATE_RDEV(mddev,rdev,tmp) {
-		__u64 ev1, ev2, ev3;
-		if (rdev->faulty || rdev->alias_device) {
-			MD_BUG();
-			goto abort;
-		}
-		ev1 = md_event(rdev->sb);
-		ev2 = md_event(sb);
-		ev3 = ev2;
-		--ev3;
-		if (!kdev_same(rdev->dev, rdev->old_dev) &&
-			((ev1 == ev2) || (ev1 == ev3))) {
-			mdp_disk_t *desc;
-
-			printk(KERN_WARNING "md: device name has changed from %s to %s since last import!\n",
-			       partition_name(rdev->old_dev), partition_name(rdev->dev));
-			if (rdev->desc_nr == -1) {
-				MD_BUG();
-				goto abort;
-			}
-			desc = &sb->disks[rdev->desc_nr];
-			if (!kdev_same( rdev->old_dev, mk_kdev(desc->major, desc->minor))) {
-				MD_BUG();
-				goto abort;
-			}
-			desc->major = major(rdev->dev);
-			desc->minor = minor(rdev->dev);
-			desc = &rdev->sb->this_disk;
-			desc->major = major(rdev->dev);
-			desc->minor = minor(rdev->dev);
-		}
-	}
-
-	/*
-	 * Remove unavailable and faulty devices ...
-	 *
-	 * note that if an array becomes completely unrunnable due to
-	 * missing devices, we do not write the superblock back, so the
-	 * administrator has a chance to fix things up. The removal thus
-	 * only happens if it's nonfatal to the contents of the array.
-	 */
-	for (i = 0; i < MD_SB_DISKS; i++) {
-		int found;
-		mdp_disk_t *desc;
-		kdev_t dev;
-
-		desc = sb->disks + i;
-		dev = mk_kdev(desc->major, desc->minor);
-
-		/*
-		 * We kick faulty devices/descriptors immediately.
-		 *
-		 * Note: multipath devices are a special case.  Since we
-		 * were able to read the superblock on the path, we don't
-		 * care if it was previously marked as faulty, it's up now
-		 * so enable it.
-		 */
-		if (disk_faulty(desc) && mddev->sb->level != LEVEL_MULTIPATH) {
-			found = 0;
-			ITERATE_RDEV(mddev,rdev,tmp) {
-				if (rdev->desc_nr != desc->number)
-					continue;
-				printk(KERN_WARNING "md%d: kicking faulty %s!\n",
-					mdidx(mddev),partition_name(rdev->dev));
 				kick_rdev_from_array(rdev);
-				found = 1;
-				break;
-			}
-			if (!found) {
-				if (kdev_none(dev))
-					continue;
-				printk(KERN_WARNING "md%d: removing former faulty %s!\n",
-					mdidx(mddev), partition_name(dev));
-			}
-			remove_descriptor(desc, sb);
-			continue;
-		} else if (disk_faulty(desc)) {
-			/*
-			 * multipath entry marked as faulty, unfaulty it
-			 */
-			rdev = find_rdev(mddev, dev);
-			if(rdev)
-				mark_disk_spare(desc);
-			else
-				remove_descriptor(desc, sb);
-		}
-
-		if (kdev_none(dev))
-			continue;
-		/*
-		 * Is this device present in the rdev ring?
-		 */
-		found = 0;
-		ITERATE_RDEV(mddev,rdev,tmp) {
-			/*
-			 * Multi-path IO special-case: since we have no
-			 * this_disk descriptor at auto-detect time,
-			 * we cannot check rdev->number.
-			 * We can check the device though.
-			 */
-			if ((sb->level == LEVEL_MULTIPATH) &&
-			    kdev_same(rdev->dev,
-				      mk_kdev(desc->major,desc->minor))) {
-				found = 1;
-				break;
-			}
-			if (rdev->desc_nr == desc->number) {
-				found = 1;
-				break;
-			}
+			} else if (desc->state & (1<<MD_DISK_SYNC) &&
+				 rdev->raid_disk < mddev->sb->raid_disks)
+				rdev->in_sync = 1;
 		}
-		if (found)
-			continue;
-
-		printk(KERN_WARNING "md%d: former device %s is unavailable, removing from array!\n",
-		       mdidx(mddev), partition_name(dev));
-		remove_descriptor(desc, sb);
 	}
 
-	/*
-	 * Double check wether all devices mentioned in the
-	 * superblock are in the rdev ring.
-	 */
-	for (i = 0; i < MD_SB_DISKS; i++) {
-		mdp_disk_t *desc;
-		kdev_t dev;
-
-		desc = sb->disks + i;
-		dev = mk_kdev(desc->major, desc->minor);
-
-		if (kdev_none(dev))
-			continue;
-
-		if (disk_faulty(desc)) {
-			MD_BUG();
-			goto abort;
-		}
-
-		rdev = find_rdev(mddev, dev);
-		if (!rdev) {
-			MD_BUG();
-			goto abort;
-		}
-	}
-
-	/*
-	 * Kick all rdevs that are not in the
-	 * descriptor array:
-	 */
-	ITERATE_RDEV(mddev,rdev,tmp) {
-		if (rdev->desc_nr == -1)
-			kick_rdev_from_array(rdev);
-	}
-
-	/*
-	 * Do a final reality check.
-	 */
-	if (mddev->sb->level != LEVEL_MULTIPATH) {
-		ITERATE_RDEV(mddev,rdev,tmp) {
-			if (rdev->desc_nr == -1) {
-				MD_BUG();
-				goto abort;
-			}
-			/*
-			 * is the desc_nr unique?
-			 */
-			ITERATE_RDEV(mddev,rdev2,tmp2) {
-				if ((rdev2 != rdev) &&
-						(rdev2->desc_nr == rdev->desc_nr)) {
-					MD_BUG();
-					goto abort;
-				}
-			}
-			/*
-			 * is the device unique?
-			 */
-			ITERATE_RDEV(mddev,rdev2,tmp2) {
-				if (rdev2 != rdev &&
-				    kdev_same(rdev2->dev, rdev->dev)) {
-					MD_BUG();
-					goto abort;
-				}
-			}
-		}
-	}
 
 	/*
 	 * Check if we can support this RAID array
@@ -2029,11 +1824,27 @@ static int get_version(void * arg)
 static int get_array_info(mddev_t * mddev, void * arg)
 {
 	mdu_array_info_t info;
+	int nr,working,active,failed,spare;
+	mdk_rdev_t *rdev;
+	struct list_head *tmp;
 
 	if (!mddev->sb) {
 		MD_BUG();
 		return -EINVAL;
 	}
+	nr=working=active=failed=spare=0;
+	ITERATE_RDEV(mddev,rdev,tmp) {
+		nr++;
+		if (rdev->faulty)
+			failed++;
+		else {
+			working++;
+			if (rdev->in_sync)
+				active++;	
+			else
+				spare++;
+		}
+	}
 
 	SET_FROM_SB(major_version);
 	SET_FROM_SB(minor_version);
@@ -2048,10 +1859,10 @@ static int get_array_info(mddev_t * mdde
 
 	SET_FROM_SB(utime);
 	SET_FROM_SB(state);
-	SET_FROM_SB(active_disks);
-	SET_FROM_SB(working_disks);
-	SET_FROM_SB(failed_disks);
-	SET_FROM_SB(spare_disks);
+	info.active_disks  = active;
+	info.working_disks = working;
+	info.failed_disks  = failed;
+	info.spare_disks   = spare;
 
 	SET_FROM_SB(layout);
 	SET_FROM_SB(chunk_size);
@@ -2063,11 +1874,12 @@ static int get_array_info(mddev_t * mdde
 }
 #undef SET_FROM_SB
 
-#define SET_FROM_SB(x) info.x = mddev->sb->disks[nr].x
+
 static int get_disk_info(mddev_t * mddev, void * arg)
 {
 	mdu_disk_info_t info;
 	unsigned int nr;
+	mdk_rdev_t *rdev;
 
 	if (!mddev->sb)
 		return -EINVAL;
@@ -2079,25 +1891,34 @@ static int get_disk_info(mddev_t * mddev
 	if (nr >= MD_SB_DISKS)
 		return -EINVAL;
 
-	SET_FROM_SB(major);
-	SET_FROM_SB(minor);
-	SET_FROM_SB(raid_disk);
-	SET_FROM_SB(state);
+	rdev = find_rdev_nr(mddev, nr);
+	if (rdev) {
+		info.major = major(rdev->dev);
+		info.minor = minor(rdev->dev);
+		info.raid_disk = rdev->raid_disk;
+		info.state = 0;
+		if (rdev->faulty)
+			info.state |= (1<<MD_DISK_FAULTY);
+		else if (rdev->in_sync) {
+			info.state |= (1<<MD_DISK_ACTIVE);
+			info.state |= (1<<MD_DISK_SYNC);
+		}
+	} else {
+		info.major = info.minor = 0;
+		info.raid_disk = 0;
+		info.state = (1<<MD_DISK_REMOVED);
+	}
 
 	if (copy_to_user(arg, &info, sizeof(info)))
 		return -EFAULT;
 
 	return 0;
 }
-#undef SET_FROM_SB
-
-#define SET_SB(x) mddev->sb->disks[nr].x = info->x
 
 static int add_new_disk(mddev_t * mddev, mdu_disk_info_t *info)
 {
 	int size, persistent;
 	mdk_rdev_t *rdev;
-	unsigned int nr;
 	kdev_t dev;
 	dev = mk_kdev(info->major,info->minor);
 	if (!mddev->sb) {
@@ -2127,19 +1948,6 @@ static int add_new_disk(mddev_t * mddev,
 		return 0;
 	}
 
-	nr = info->number;
-	if (nr >= mddev->sb->nr_disks) {
-		MD_BUG();
-		return -EINVAL;
-	}
-
-
-	SET_SB(number);
-	SET_SB(major);
-	SET_SB(minor);
-	SET_SB(raid_disk);
-	SET_SB(state);
-
 	if (!(info->state & (1<<MD_DISK_FAULTY))) {
 		rdev = md_import_device (dev, 0);
 		if (IS_ERR(rdev)) {
@@ -2168,20 +1976,13 @@ static int add_new_disk(mddev_t * mddev,
 			mddev->sb->size = size;
 	}
 
-	/*
-	 * sync all other superblocks with the main superblock
-	 */
-	sync_sbs(mddev);
-
 	return 0;
 }
-#undef SET_SB
 
 static int hot_generate_error(mddev_t * mddev, kdev_t dev)
 {
 	struct request_queue *q;
 	mdk_rdev_t *rdev;
-	mdp_disk_t *disk;
 
 	if (!mddev->pers)
 		return -ENODEV;
@@ -2199,8 +2000,7 @@ static int hot_generate_error(mddev_t * 
 		MD_BUG();
 		return -EINVAL;
 	}
-	disk = &mddev->sb->disks[rdev->desc_nr];
-	if (!disk_active(disk))
+	if (!rdev->in_sync)
 		return -ENODEV;
 
 	q = bdev_get_queue(rdev->bdev);
@@ -2218,7 +2018,6 @@ static int hot_remove_disk(mddev_t * mdd
 {
 	int err;
 	mdk_rdev_t *rdev;
-	mdp_disk_t *disk;
 
 	if (!mddev->pers)
 		return -ENODEV;
@@ -2236,21 +2035,10 @@ static int hot_remove_disk(mddev_t * mdd
 	if (!rdev)
 		return -ENXIO;
 
-	if (rdev->desc_nr == -1) {
-		MD_BUG();
-		return -EINVAL;
-	}
-	disk = &mddev->sb->disks[rdev->desc_nr];
-	if (disk_active(disk)) {
-		MD_BUG();
+	if (rdev->in_sync && ! rdev->faulty)
 		goto busy;
-	}
-	if (disk_removed(disk)) {
-		MD_BUG();
-		return -EINVAL;
-	}
 
-	err = mddev->pers->hot_remove_disk(mddev, disk->raid_disk);
+	err = mddev->pers->hot_remove_disk(mddev, rdev->raid_disk);
 	if (err == -EBUSY) {
 		MD_BUG();
 		goto busy;
@@ -2260,7 +2048,6 @@ static int hot_remove_disk(mddev_t * mdd
 		return -EINVAL;
 	}
 
-	remove_descriptor(disk, mddev->sb);
 	kick_rdev_from_array(rdev);
 	md_update_sb(mddev);
 
@@ -2276,7 +2063,6 @@ static int hot_add_disk(mddev_t * mddev,
 	int i, err, persistent;
 	unsigned int size;
 	mdk_rdev_t *rdev;
-	mdp_disk_t *disk;
 
 	if (!mddev->pers)
 		return -ENODEV;
@@ -2290,10 +2076,6 @@ static int hot_add_disk(mddev_t * mddev,
 		return -EINVAL;
 	}
 
-	rdev = find_rdev(mddev, dev);
-	if (rdev)
-		return -EBUSY;
-
 	rdev = md_import_device (dev, 0);
 	if (IS_ERR(rdev)) {
 		printk(KERN_WARNING "md: error, md_import_device() returned %ld\n", PTR_ERR(rdev));
@@ -2326,15 +2108,10 @@ static int hot_add_disk(mddev_t * mddev,
 	rdev->size = size;
 	rdev->sb_offset = calc_dev_sboffset(rdev, mddev, persistent);
 
-	disk = mddev->sb->disks + mddev->sb->raid_disks;
-	for (i = mddev->sb->raid_disks; i < MD_SB_DISKS; i++) {
-		disk = mddev->sb->disks + i;
-
-		if (!disk->major && !disk->minor)
+	for (i = mddev->sb->raid_disks; i < MD_SB_DISKS; i++)
+		if (find_rdev_nr(mddev,i)==NULL)
 			break;
-		if (disk_removed(disk))
-			break;
-	}
+
 	if (i == MD_SB_DISKS) {
 		printk(KERN_WARNING "md%d: can not hot-add to full array!\n",
 		       mdidx(mddev));
@@ -2342,34 +2119,15 @@ static int hot_add_disk(mddev_t * mddev,
 		goto abort_unbind_export;
 	}
 
-	if (disk_removed(disk)) {
-		/*
-		 * reuse slot
-		 */
-		if (disk->number != i) {
-			MD_BUG();
-			err = -EINVAL;
-			goto abort_unbind_export;
-		}
-	} else {
-		disk->number = i;
-	}
-
-	disk->raid_disk = disk->number;
-	disk->major = major(dev);
-	disk->minor = minor(dev);
+	rdev->desc_nr = i;
+	rdev->raid_disk = i;
 
-	if (mddev->pers->hot_add_disk(mddev, disk, rdev)) {
+	if (mddev->pers->hot_add_disk(mddev, rdev)) {
 		MD_BUG();
 		err = -EINVAL;
 		goto abort_unbind_export;
 	}
 
-	mark_disk_spare(disk);
-	mddev->sb->nr_disks++;
-	mddev->sb->spare_disks++;
-	mddev->sb->working_disks++;
-
 	md_update_sb(mddev);
 
 	/*
@@ -2408,10 +2166,6 @@ static int set_array_info(mddev_t * mdde
 	SET_SB(not_persistent);
 
 	SET_SB(state);
-	SET_SB(active_disks);
-	SET_SB(working_disks);
-	SET_SB(failed_disks);
-	SET_SB(spare_disks);
 
 	SET_SB(layout);
 	SET_SB(chunk_size);
@@ -3076,28 +2830,18 @@ int unregister_md_personality(int pnum)
 	return 0;
 }
 
-mdp_disk_t *get_spare(mddev_t *mddev)
+static mdk_rdev_t *get_spare(mddev_t *mddev)
 {
-	mdp_super_t *sb = mddev->sb;
-	mdp_disk_t *disk;
 	mdk_rdev_t *rdev;
 	struct list_head *tmp;
 
 	ITERATE_RDEV(mddev,rdev,tmp) {
 		if (rdev->faulty)
 			continue;
-		if (!rdev->sb) {
-			MD_BUG();
-			continue;
-		}
-		disk = &sb->disks[rdev->desc_nr];
-		if (disk_faulty(disk)) {
-			MD_BUG();
+		if (rdev->in_sync)
 			continue;
-		}
-		if (disk_active(disk))
-			continue;
-		return disk;
+
+		return rdev;
 	}
 	return NULL;
 }
@@ -3365,10 +3109,7 @@ void md_do_recovery(void *data)
 				/* success...*/
 				if (mddev->spare) {
 					mddev->pers->spare_active(mddev);
-					mark_disk_sync(mddev->spare);
-					mark_disk_active(mddev->spare);
-					sb->active_disks++;
-					sb->spare_disks--;
+					mddev->spare->in_sync = 1;
 					mddev->spare = NULL;
 				}
 			}
@@ -3390,7 +3131,7 @@ void md_do_recovery(void *data)
 				       "-- continuing in degraded mode\n", mdidx(mddev));
 			else
 				printk(KERN_INFO "md%d: resyncing spare disk %s to replace failed disk\n",
-				       mdidx(mddev), partition_name(mk_kdev(mddev->spare->major,mddev->spare->minor)));
+				       mdidx(mddev), partition_name(mddev->spare->dev));
 		}
 		if (!mddev->spare && mddev->in_sync) {
 			/* nothing we can do ... */
@@ -3749,10 +3490,6 @@ void __init md_setup_drive(void)
 			ainfo.not_persistent = 1;
 
 			ainfo.state = (1 << MD_SB_CLEAN);
-			ainfo.active_disks = 0;
-			ainfo.working_disks = 0;
-			ainfo.failed_disks = 0;
-			ainfo.spare_disks = 0;
 			ainfo.layout = 0;
 			ainfo.chunk_size = md_setup_args.chunk[minor];
 			err = set_array_info(mddev, &ainfo);
@@ -3765,10 +3502,7 @@ void __init md_setup_drive(void)
 				dinfo.state = (1<<MD_DISK_ACTIVE)|(1<<MD_DISK_SYNC);
 				dinfo.major = major(dev);
 				dinfo.minor = minor(dev);
-				mddev->sb->nr_disks++;
 				mddev->sb->raid_disks++;
-				mddev->sb->active_disks++;
-				mddev->sb->working_disks++;
 				err = add_new_disk (mddev, &dinfo);
 			}
 		} else {
@@ -3883,5 +3617,4 @@ EXPORT_SYMBOL(md_wakeup_thread);
 EXPORT_SYMBOL(md_print_devices);
 EXPORT_SYMBOL(find_rdev_nr);
 EXPORT_SYMBOL(md_interrupt_thread);
-EXPORT_SYMBOL(get_spare);
 MODULE_LICENSE("GPL");
--- ./drivers/md/multipath.c	2002/07/18 12:03:01	1.11
+++ ./drivers/md/multipath.c	2002/07/18 12:06:48	1.12
@@ -214,15 +214,8 @@ static void mark_disk_bad (mddev_t *mdde
 {
 	multipath_conf_t *conf = mddev_to_conf(mddev);
 	struct multipath_info *multipath = conf->multipaths+failed;
-	mdp_super_t *sb = mddev->sb;
 
 	multipath->operational = 0;
-	mark_disk_faulty(sb->disks+multipath->number);
-	mark_disk_nonsync(sb->disks+multipath->number);
-	mark_disk_inactive(sb->disks+multipath->number);
-	sb->active_disks--;
-	sb->working_disks--;
-	sb->failed_disks++;
 	mddev->sb_dirty = 1;
 	conf->working_disks--;
 	printk (DISK_FAILED, bdev_partition_name (multipath->bdev),
@@ -296,30 +289,23 @@ static void print_multipath_conf (multip
 }
 
 
-static int multipath_add_disk(mddev_t *mddev, mdp_disk_t *added_desc,
-	mdk_rdev_t *rdev)
+static int multipath_add_disk(mddev_t *mddev, mdk_rdev_t *rdev)
 {
 	multipath_conf_t *conf = mddev->private;
 	int err = 1;
-	int i;
+	struct multipath_info *p = conf->multipaths + rdev->raid_disk;
 
 	print_multipath_conf(conf);
 	spin_lock_irq(&conf->device_lock);
-	for (i = 0; i < MD_SB_DISKS; i++) {
-		struct multipath_info *p = conf->multipaths + i;
-		if (!p->used_slot) {
-			if (added_desc->number != i)
-				break;
-			p->number = added_desc->number;
-			p->raid_disk = added_desc->raid_disk;
-			p->bdev = rdev->bdev;
-			p->operational = 1;
-			p->used_slot = 1;
-			conf->nr_disks++;
-			conf->working_disks++;
-			err = 0;
-			break;
-		}
+	if (!p->used_slot) {
+		p->number = rdev->desc_nr;
+		p->raid_disk = rdev->raid_disk;
+		p->bdev = rdev->bdev;
+		p->operational = 1;
+		p->used_slot = 1;
+		conf->nr_disks++;
+		conf->working_disks++;
+		err = 0;
 	}
 	if (err)
 		MD_BUG();
@@ -451,10 +437,9 @@ static void multipathd (void *data)
 static int multipath_run (mddev_t *mddev)
 {
 	multipath_conf_t *conf;
-	int i, j, disk_idx;
+	int disk_idx;
 	struct multipath_info *disk;
 	mdp_super_t *sb = mddev->sb;
-	mdp_disk_t *desc;
 	mdk_rdev_t *rdev;
 	struct list_head *tmp;
 	int num_rdevs = 0;
@@ -498,32 +483,24 @@ static int multipath_run (mddev_t *mddev
 			continue;
 		}
 
-		desc = &sb->disks[rdev->desc_nr];
-		disk_idx = desc->raid_disk;
+		disk_idx = rdev->raid_disk;
 		disk = conf->multipaths + disk_idx;
 
-		if (!disk_sync(desc))
-			printk(NOT_IN_SYNC, bdev_partition_name(rdev->bdev));
-
 		/*
 		 * Mark all disks as active to start with, there are no
 		 * spares.  multipath_read_balance deals with choose
 		 * the "best" operational device.
 		 */
-		disk->number = desc->number;
-		disk->raid_disk = desc->raid_disk;
+		disk->number = rdev->desc_nr;
+		disk->raid_disk = disk_idx;
 		disk->bdev = rdev->bdev;
 		disk->operational = 1;
 		disk->used_slot = 1;
-		mark_disk_sync(desc);
-		mark_disk_active(desc);
 		num_rdevs++;
 	}
 
-	conf->raid_disks = sb->raid_disks = sb->active_disks = num_rdevs;
-	conf->nr_disks = sb->nr_disks = sb->working_disks = num_rdevs;
-	sb->failed_disks = 0;
-	sb->spare_disks = 0;
+	conf->raid_disks = sb->raid_disks = num_rdevs;
+	conf->nr_disks = num_rdevs;
 	mddev->sb_dirty = 1;
 	conf->mddev = mddev;
 	conf->device_lock = SPIN_LOCK_UNLOCKED;
@@ -548,18 +525,6 @@ static int multipath_run (mddev_t *mddev
 		if (!conf->thread) {
 			printk(THREAD_ERROR, mdidx(mddev));
 			goto out_free_conf;
-		}
-	}
-
-	/*
-	 * Regenerate the "device is in sync with the raid set" bit for
-	 * each device.
-	 */
-	for (i = 0; i < MD_SB_DISKS; i++) {
-		mark_disk_nonsync(sb->disks+i);
-		for (j = 0; j < sb->raid_disks; j++) {
-			if (sb->disks[i].number == conf->multipaths[j].number)
-				mark_disk_sync(sb->disks+i);
 		}
 	}
 
--- ./drivers/md/raid1.c	2002/07/18 12:06:02	1.8
+++ ./drivers/md/raid1.c	2002/07/18 12:06:48	1.9
@@ -575,21 +575,13 @@ static void mark_disk_bad(mddev_t *mddev
 {
 	conf_t *conf = mddev_to_conf(mddev);
 	mirror_info_t *mirror = conf->mirrors+failed;
-	mdp_super_t *sb = mddev->sb;
 
 	mirror->operational = 0;
-	mark_disk_faulty(sb->disks+mirror->number);
-	mark_disk_nonsync(sb->disks+mirror->number);
-	mark_disk_inactive(sb->disks+mirror->number);
 	if (!mirror->write_only) {
-		sb->active_disks--;
 		mddev->degraded++;
+		conf->working_disks--;
 	}
-	sb->working_disks--;
-	sb->failed_disks++;
 	mddev->sb_dirty = 1;
-	if (!mirror->write_only)
-		conf->working_disks--;
 	printk(DISK_FAILED, bdev_partition_name(mirror->bdev), conf->working_disks);
 }
 
@@ -665,8 +657,6 @@ static int raid1_spare_active(mddev_t *m
 	int i, failed_disk = -1, spare_disk = -1;
 	conf_t *conf = mddev->private;
 	mirror_info_t *tmp, *sdisk, *fdisk;
-	mdp_super_t *sb = mddev->sb;
-	mdp_disk_t *failed_desc, *spare_desc;
 	mdk_rdev_t *spare_rdev, *failed_rdev;
 
 	print_conf(conf);
@@ -701,17 +691,6 @@ static int raid1_spare_active(mddev_t *m
 	sdisk = conf->mirrors + spare_disk;
 	fdisk = conf->mirrors + failed_disk;
 
-	spare_desc = &sb->disks[sdisk->number];
-	failed_desc = &sb->disks[fdisk->number];
-
-	if (spare_desc->raid_disk != sdisk->raid_disk ||
-	    sdisk->raid_disk != spare_disk || fdisk->raid_disk != failed_disk ||
-	    failed_desc->raid_disk != fdisk->raid_disk) {
-		MD_BUG();
-		err = 1;
-		goto abort;
-	}
-
 	/*
 	 * do the switch finally
 	 */
@@ -722,15 +701,13 @@ static int raid1_spare_active(mddev_t *m
 	 * There must be a spare_rdev, but there may not be a
 	 * failed_rdev. That slot might be empty...
 	 */
-	spare_rdev->desc_nr = failed_desc->number;
+	spare_rdev->desc_nr = failed_disk;
 	spare_rdev->raid_disk = failed_disk;
 	if (failed_rdev) {
-		failed_rdev->desc_nr = spare_desc->number;
+		failed_rdev->desc_nr = spare_disk;
 		failed_rdev->raid_disk = spare_disk;
 	}
-	spare_rdev->in_sync = 1;
 
-	xchg_values(*spare_desc, *failed_desc);
 	xchg_values(*fdisk, *sdisk);
 
 	/*
@@ -740,9 +717,7 @@ static int raid1_spare_active(mddev_t *m
 	 * give the proper raid_disk number to the now activated
 	 * disk. (this means we switch back these values)
 	 */
-	xchg_values(spare_desc->raid_disk, failed_desc->raid_disk);
 	xchg_values(sdisk->raid_disk, fdisk->raid_disk);
-	xchg_values(spare_desc->number, failed_desc->number);
 	xchg_values(sdisk->number, fdisk->number);
 
 	if (!sdisk->bdev)
@@ -810,36 +785,26 @@ static int raid1_spare_write(mddev_t *md
 	return err;
 }
 
-static int raid1_add_disk(mddev_t *mddev, mdp_disk_t *added_desc,
-	mdk_rdev_t *rdev)
+static int raid1_add_disk(mddev_t *mddev, mdk_rdev_t *rdev)
 {
 	conf_t *conf = mddev->private;
 	int err = 1;
-	int i;
+	mirror_info_t *p = conf->mirrors + rdev->raid_disk;
 
 	print_conf(conf);
 	spin_lock_irq(&conf->device_lock);
-	/*
-	 * find the disk ...
-	 */
-	for (i = conf->raid_disks; i < MD_SB_DISKS; i++) {
-		mirror_info_t *p = conf->mirrors + i;
-		if (!p->used_slot) {
-			if (added_desc->number != i)
-				break;
-			p->number = added_desc->number;
-			p->raid_disk = added_desc->raid_disk;
-			/* it will be held open by rdev */
-			p->bdev = rdev->bdev;
-			p->operational = 0;
-			p->write_only = 0;
-			p->spare = 1;
-			p->used_slot = 1;
-			p->head_position = 0;
-			conf->nr_disks++;
-			err = 0;
-			break;
-		}
+	if (!p->used_slot) {
+		p->number = rdev->desc_nr;
+		p->raid_disk = rdev->raid_disk;
+		/* it will be held open by rdev */
+		p->bdev = rdev->bdev;
+		p->operational = 0;
+		p->write_only = 0;
+		p->spare = 1;
+		p->used_slot = 1;
+		p->head_position = 0;
+		conf->nr_disks++;
+		err = 0;
 	}
 	if (err)
 		MD_BUG();
@@ -1222,7 +1187,6 @@ static int run(mddev_t *mddev)
 	int i, j, disk_idx;
 	mirror_info_t *disk;
 	mdp_super_t *sb = mddev->sb;
-	mdp_disk_t *descriptor;
 	mdk_rdev_t *rdev;
 	struct list_head *tmp;
 
@@ -1267,12 +1231,11 @@ static int run(mddev_t *mddev)
 			MD_BUG();
 			continue;
 		}
-		descriptor = &sb->disks[rdev->desc_nr];
-		disk_idx = descriptor->raid_disk;
+		disk_idx = rdev->raid_disk;
 		disk = conf->mirrors + disk_idx;
 
-		if (disk_faulty(descriptor)) {
-			disk->number = descriptor->number;
+		if (rdev->faulty) {
+			disk->number = rdev->desc_nr;
 			disk->raid_disk = disk_idx;
 			disk->bdev = rdev->bdev;
 			disk->operational = 0;
@@ -1282,19 +1245,7 @@ static int run(mddev_t *mddev)
 			disk->head_position = 0;
 			continue;
 		}
-		if (disk_active(descriptor)) {
-			if (!disk_sync(descriptor)) {
-				printk(NOT_IN_SYNC,
-					bdev_partition_name(rdev->bdev));
-				continue;
-			}
-			if ((descriptor->number > MD_SB_DISKS) ||
-					(disk_idx > sb->raid_disks)) {
-
-				printk(INCONSISTENT,
-					bdev_partition_name(rdev->bdev));
-				continue;
-			}
+		if (rdev->in_sync) {
 			if (disk->operational) {
 				printk(ALREADY_RUNNING,
 					bdev_partition_name(rdev->bdev),
@@ -1303,7 +1254,7 @@ static int run(mddev_t *mddev)
 			}
 			printk(OPERATIONAL, bdev_partition_name(rdev->bdev),
 					disk_idx);
-			disk->number = descriptor->number;
+			disk->number = rdev->desc_nr;
 			disk->raid_disk = disk_idx;
 			disk->bdev = rdev->bdev;
 			disk->operational = 1;
@@ -1317,7 +1268,7 @@ static int run(mddev_t *mddev)
 		 * Must be a spare disk ..
 		 */
 			printk(SPARE, bdev_partition_name(rdev->bdev));
-			disk->number = descriptor->number;
+			disk->number = rdev->desc_nr;
 			disk->raid_disk = disk_idx;
 			disk->bdev = rdev->bdev;
 			disk->operational = 0;
@@ -1342,16 +1293,13 @@ static int run(mddev_t *mddev)
 	}
 
 	mddev->degraded = 0;
-	for (i = 0; i < MD_SB_DISKS; i++) {
+	for (i = 0; i < conf->raid_disks; i++) {
 
-		descriptor = sb->disks+i;
-		disk_idx = descriptor->raid_disk;
-		disk = conf->mirrors + disk_idx;
+		disk = conf->mirrors + i;
 
-		if (disk_faulty(descriptor) && (disk_idx < conf->raid_disks) &&
-				!disk->used_slot) {
-			disk->number = descriptor->number;
-			disk->raid_disk = disk_idx;
+		if (!disk->used_slot) {
+			disk->number = i;
+			disk->raid_disk = i;
 			disk->bdev = NULL;
 			disk->operational = 0;
 			disk->write_only = 0;
@@ -1359,7 +1307,7 @@ static int run(mddev_t *mddev)
 			disk->used_slot = 1;
 			disk->head_position = 0;
 		}
-		if (!disk->used_slot && disk_idk < conf->raid_disks)
+		if (!disk->used_slot)
 			mddev->degraded++;
 	}
 
@@ -1383,23 +1331,7 @@ static int run(mddev_t *mddev)
 		}
 	}
 
-
-	/*
-	 * Regenerate the "device is in sync with the raid set" bit for
-	 * each device.
-	 */
-	for (i = 0; i < MD_SB_DISKS; i++) {
-		mark_disk_nonsync(sb->disks+i);
-		for (j = 0; j < sb->raid_disks; j++) {
-			if (!conf->mirrors[j].operational)
-				continue;
-			if (sb->disks[i].number == conf->mirrors[j].number)
-				mark_disk_sync(sb->disks+i);
-		}
-	}
-	sb->active_disks = conf->working_disks;
-
-	printk(ARRAY_IS_ACTIVE, mdidx(mddev), sb->active_disks, sb->raid_disks);
+	printk(ARRAY_IS_ACTIVE, mdidx(mddev), sb->raid_disks - mddev->degraded, sb->raid_disks);
 	/*
 	 * Ok, everything is just fine now
 	 */
--- ./drivers/md/raid5.c	2002/07/18 12:06:02	1.7
+++ ./drivers/md/raid5.c	2002/07/18 12:06:48	1.8
@@ -442,7 +442,6 @@ static void raid5_build_block (struct st
 static int error(mddev_t *mddev, struct block_device *bdev)
 {
 	raid5_conf_t *conf = (raid5_conf_t *) mddev->private;
-	mdp_super_t *sb = mddev->sb;
 	struct disk_info *disk;
 	int i;
 
@@ -453,12 +452,6 @@ static int error(mddev_t *mddev, struct 
 			continue;
 		if (disk->operational) {
 			disk->operational = 0;
-			mark_disk_faulty(sb->disks+disk->number);
-			mark_disk_nonsync(sb->disks+disk->number);
-			mark_disk_inactive(sb->disks+disk->number);
-			sb->active_disks--;
-			sb->working_disks--;
-			sb->failed_disks++;
 			mddev->sb_dirty = 1;
 			mddev->degraded++;
 			conf->working_disks--;
@@ -486,12 +479,6 @@ static int error(mddev_t *mddev, struct 
 			disk->operational = 0;
 			disk->write_only = 0;
 			conf->spare = NULL;
-			mark_disk_faulty(sb->disks+disk->number);
-			mark_disk_nonsync(sb->disks+disk->number);
-			mark_disk_inactive(sb->disks+disk->number);
-			sb->spare_disks--;
-			sb->working_disks--;
-			sb->failed_disks++;
 
 			mddev->sb_dirty = 1;
 
@@ -1376,9 +1363,8 @@ static void raid5d (void *data)
 static int run (mddev_t *mddev)
 {
 	raid5_conf_t *conf;
-	int i, j, raid_disk, memory;
+	int i, raid_disk, memory;
 	mdp_super_t *sb = mddev->sb;
-	mdp_disk_t *desc;
 	mdk_rdev_t *rdev;
 	struct disk_info *disk;
 	struct list_head *tmp;
@@ -1419,17 +1405,12 @@ static int run (mddev_t *mddev)
 		 * the disk only to get a pointer to the descriptor on
 		 * the main superblock, which might be more recent.
 		 */
-		desc = sb->disks + rdev->desc_nr;
-		raid_disk = desc->raid_disk;
+		raid_disk = rdev->raid_disk;
 		disk = conf->disks + raid_disk;
 
-		if (disk_faulty(desc)) {
+		if (rdev->faulty) {
 			printk(KERN_ERR "raid5: disabled device %s (errors detected)\n", bdev_partition_name(rdev->bdev));
-			if (!rdev->faulty) {
-				MD_BUG();
-				goto abort;
-			}
-			disk->number = desc->number;
+			disk->number = rdev->desc_nr;
 			disk->raid_disk = raid_disk;
 			disk->bdev = rdev->bdev;
 
@@ -1439,23 +1420,14 @@ static int run (mddev_t *mddev)
 			disk->used_slot = 1;
 			continue;
 		}
-		if (disk_active(desc)) {
-			if (!disk_sync(desc)) {
-				printk(KERN_ERR "raid5: disabled device %s (not in sync)\n", bdev_partition_name(rdev->bdev));
-				MD_BUG();
-				goto abort;
-			}
-			if (raid_disk > sb->raid_disks) {
-				printk(KERN_ERR "raid5: disabled device %s (inconsistent descriptor)\n", bdev_partition_name(rdev->bdev));
-				continue;
-			}
+		if (rdev->in_sync) {
 			if (disk->operational) {
 				printk(KERN_ERR "raid5: disabled device %s (device %d already operational)\n", bdev_partition_name(rdev->bdev), raid_disk);
 				continue;
 			}
 			printk(KERN_INFO "raid5: device %s operational as raid disk %d\n", bdev_partition_name(rdev->bdev), raid_disk);
 	
-			disk->number = desc->number;
+			disk->number = rdev->desc_nr;
 			disk->raid_disk = raid_disk;
 			disk->bdev = rdev->bdev;
 			disk->operational = 1;
@@ -1467,7 +1439,7 @@ static int run (mddev_t *mddev)
 			 * Must be a spare disk ..
 			 */
 			printk(KERN_INFO "raid5: spare disk %s\n", bdev_partition_name(rdev->bdev));
-			disk->number = desc->number;
+			disk->number = rdev->desc_nr;
 			disk->raid_disk = raid_disk;
 			disk->bdev = rdev->bdev;
 
@@ -1478,16 +1450,13 @@ static int run (mddev_t *mddev)
 		}
 	}
 
-	for (i = 0; i < MD_SB_DISKS; i++) {
-		desc = sb->disks + i;
-		raid_disk = desc->raid_disk;
-		disk = conf->disks + raid_disk;
+	for (i = 0; i < sb->raid_disks; i++) {
+		disk = conf->disks + i;
 
-		if (disk_faulty(desc) && (raid_disk < sb->raid_disks) &&
-			!conf->disks[raid_disk].used_slot) {
+		if (!disk->used_slot) {
 
-			disk->number = desc->number;
-			disk->raid_disk = raid_disk;
+			disk->number = i;
+			disk->raid_disk = i;
 			disk->bdev = NULL;
 
 			disk->operational = 0;
@@ -1555,22 +1524,7 @@ static int run (mddev_t *mddev)
 	} else
 		printk(KERN_INFO "raid5: allocated %dkB for md%d\n", memory, mdidx(mddev));
 
-	/*
-	 * Regenerate the "device is in sync with the raid set" bit for
-	 * each device.
-	 */
-	for (i = 0; i < MD_SB_DISKS ; i++) {
-		mark_disk_nonsync(sb->disks + i);
-		for (j = 0; j < sb->raid_disks; j++) {
-			if (!conf->disks[j].operational)
-				continue;
-			if (sb->disks[i].number == conf->disks[j].number)
-				mark_disk_sync(sb->disks + i);
-		}
-	}
-	sb->active_disks = conf->working_disks;
-
-	if (sb->active_disks == sb->raid_disks)
+	if (conf->working_disks == conf->raid_disks)
 		printk("raid5: raid level %d set md%d active with %d out of %d devices, algorithm %d\n", conf->level, mdidx(mddev), sb->active_disks, sb->raid_disks, conf->algorithm);
 	else
 		printk(KERN_ALERT "raid5: raid level %d set md%d active with %d out of %d devices, algorithm %d\n", conf->level, mdidx(mddev), sb->active_disks, sb->raid_disks, conf->algorithm);
@@ -1693,8 +1647,6 @@ static int raid5_spare_active(mddev_t *m
 	int i, failed_disk=-1, spare_disk=-1;
 	raid5_conf_t *conf = mddev->private;
 	struct disk_info *tmp, *sdisk, *fdisk;
-	mdp_super_t *sb = mddev->sb;
-	mdp_disk_t *failed_desc, *spare_desc;
 	mdk_rdev_t *spare_rdev, *failed_rdev;
 
 	print_raid5_conf(conf);
@@ -1726,17 +1678,6 @@ static int raid5_spare_active(mddev_t *m
 	sdisk = conf->disks + spare_disk;
 	fdisk = conf->disks + failed_disk;
 
-	spare_desc = &sb->disks[sdisk->number];
-	failed_desc = &sb->disks[fdisk->number];
-
-	if ( spare_desc->raid_disk != sdisk->raid_disk ||
-	    sdisk->raid_disk != spare_disk || fdisk->raid_disk != failed_disk ||
-	    failed_desc->raid_disk != fdisk->raid_disk) {
-		MD_BUG();
-		err = 1;
-		goto abort;
-	}
-
 	/*
 	 * do the switch finally
 	 */
@@ -1746,15 +1687,13 @@ static int raid5_spare_active(mddev_t *m
 	/* There must be a spare_rdev, but there may not be a
 	 * failed_rdev.  That slot might be empty...
 	 */
-	spare_rdev->desc_nr = failed_desc->number;
+	spare_rdev->desc_nr = failed_disk;
 	spare_rdev->raid_disk = failed_disk;
 	if (failed_rdev) {
-		failed_rdev->desc_nr = spare_desc->number;
+		failed_rdev->desc_nr = spare_disk;
 		failed_rdev->raid_disk = spare_disk;
 	}
-	spare_rdev->in_sync = 1;
 	
-	xchg_values(*spare_desc, *failed_desc);
 	xchg_values(*fdisk, *sdisk);
 
 	/*
@@ -1765,9 +1704,7 @@ static int raid5_spare_active(mddev_t *m
 	 * disk. (this means we switch back these values)
 	 */
 
-	xchg_values(spare_desc->raid_disk, failed_desc->raid_disk);
 	xchg_values(sdisk->raid_disk, fdisk->raid_disk);
-	xchg_values(spare_desc->number, failed_desc->number);
 	xchg_values(sdisk->number, fdisk->number);
 
 	if (!sdisk->bdev)
@@ -1865,12 +1802,11 @@ abort:
 	return err;
 }
 
-static int raid5_add_disk(mddev_t *mddev, mdp_disk_t *added_desc,
-	mdk_rdev_t *rdev)
+static int raid5_add_disk(mddev_t *mddev, mdk_rdev_t *rdev)
 {
 	raid5_conf_t *conf = mddev->private;
 	int err = 1;
-	int i;
+	struct disk_info *p = conf->disks + rdev->raid_disk;
 
 	print_raid5_conf(conf);
 	spin_lock_irq(&conf->device_lock);
@@ -1878,22 +1814,16 @@ static int raid5_add_disk(mddev_t *mddev
 	 * find the disk ...
 	 */
 
-	for (i = conf->raid_disks; i < MD_SB_DISKS; i++) {
-		struct disk_info *p = conf->disks + i;
-		if (!p->used_slot) {
-			if (added_desc->number != i)
-				break;
-			p->number = added_desc->number;
-			p->raid_disk = added_desc->raid_disk;
-			/* it will be held open by rdev */
-			p->bdev = rdev->bdev;
-			p->operational = 0;
-			p->write_only = 0;
-			p->spare = 1;
-			p->used_slot = 1;
-			err = 0;
-			break;
-		}
+	if (!p->used_slot) {
+		p->number = rdev->desc_nr;
+		p->raid_disk = rdev->raid_disk;
+		/* it will be held open by rdev */
+		p->bdev = rdev->bdev;
+		p->operational = 0;
+		p->write_only = 0;
+		p->spare = 1;
+		p->used_slot = 1;
+		err = 0;
 	}
 	if (err)
 		MD_BUG();
--- ./include/linux/raid/md_k.h	2002/07/18 12:06:02	1.7
+++ ./include/linux/raid/md_k.h	2002/07/18 12:06:48	1.8
@@ -190,7 +190,7 @@ struct mddev_s
 	int				in_sync;	/* know to not need resync */
 	struct semaphore		reconfig_sem;
 	atomic_t			active;
-	mdp_disk_t			*spare;
+	mdk_rdev_t			*spare;
 
 	int				degraded;	/* whether md should consider
 							 * adding a spare
@@ -212,7 +212,7 @@ struct mdk_personality_s
 	int (*stop)(mddev_t *mddev);
 	int (*status)(char *page, mddev_t *mddev);
 	int (*error_handler)(mddev_t *mddev, struct block_device *bdev);
-	int (*hot_add_disk) (mddev_t *mddev, mdp_disk_t *descriptor, mdk_rdev_t *rdev);
+	int (*hot_add_disk) (mddev_t *mddev, mdk_rdev_t *rdev);
 	int (*hot_remove_disk) (mddev_t *mddev, int number);
 	int (*spare_write) (mddev_t *mddev);
 	int (*spare_inactive) (mddev_t *mddev);
@@ -238,7 +238,7 @@ static inline kdev_t mddev_to_kdev(mddev
 
 extern mdk_rdev_t * find_rdev(mddev_t * mddev, kdev_t dev);
 extern mdk_rdev_t * find_rdev_nr(mddev_t *mddev, int nr);
-extern mdp_disk_t *get_spare(mddev_t *mddev);
+extern mdk_rdev_t *get_spare(mddev_t *mddev);
 
 /*
  * iterates through some rdev ringlist. It's safe to remove the
