From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 5 of 7 - Change the way the name of an md device is printed in error messages.
Date: Fri, 23 Jan 2004 11:14:24 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E1Ajoxs-0000jt-00@notabene>
References: <20040123105615.2237.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Instead of using ("md%d", mdidx(mddev)), we now use
 ("%s", mdname(mddev)) where mdname is the disk_name field in the associated
gendisk structure.  This allows future flexability in naming.

 ----------- Diffstat output ------------
 ./drivers/md/md.c           |  132 ++++++++++++++++++++++----------------------
 ./drivers/md/multipath.c    |   30 ++++------
 ./drivers/md/raid0.c        |    4 -
 ./drivers/md/raid1.c        |   30 +++++-----
 ./drivers/md/raid5.c        |   40 ++++++-------
 ./drivers/md/raid6main.c    |   42 +++++++-------
 ./include/linux/raid/md_k.h |    4 +
 7 files changed, 142 insertions(+), 140 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2004-01-23 10:34:49.000000000 +1100
+++ ./drivers/md/md.c	2004-01-23 10:37:12.000000000 +1100
@@ -994,10 +994,10 @@ static int bind_rdev_to_array(mdk_rdev_t
 	same_pdev = match_dev_unit(mddev, rdev);
 	if (same_pdev)
 		printk(KERN_WARNING
-			"md%d: WARNING: %s appears to be on the same physical"
+			"%s: WARNING: %s appears to be on the same physical"
 	 		" disk as %s. True\n     protection against single-disk"
 			" failure might be compromised.\n",
-			mdidx(mddev), bdevname(rdev->bdev,b),
+			mdname(mddev), bdevname(rdev->bdev,b),
 			bdevname(same_pdev->bdev,b2));
 
 	/* Verify rdev->desc_nr is unique.
@@ -1177,7 +1177,7 @@ void md_print_devices(void)
 	printk("md:	* <COMPLETE RAID STATE PRINTOUT> *\n");
 	printk("md:	**********************************\n");
 	ITERATE_MDDEV(mddev,tmp) {
-		printk("md%d: ", mdidx(mddev));
+		printk("%s: ", mdname(mddev));
 
 		ITERATE_RDEV(mddev,rdev,tmp2)
 			printk("<%s>", bdevname(rdev->bdev,b));
@@ -1257,8 +1257,8 @@ repeat:
 		return;
 
 	dprintk(KERN_INFO 
-		"md: updating md%d RAID superblock on device (in sync %d)\n",
-		mdidx(mddev),mddev->in_sync);
+		"md: updating %s RAID superblock on device (in sync %d)\n",
+		mdname(mddev),mddev->in_sync);
 
 	err = 0;
 	ITERATE_RDEV(mddev,rdev,tmp) {
@@ -1424,8 +1424,8 @@ static int analyze_sbs(mddev_t * mddev)
 	if (mddev->major_version != MD_MAJOR_VERSION ||
 			mddev->minor_version > MD_MINOR_VERSION) {
 		printk(KERN_ALERT 
-			"md: md%d: unsupported raid array version %d.%d.%d\n",
-			mdidx(mddev), mddev->major_version,
+			"md: %s: unsupported raid array version %d.%d.%d\n",
+			mdname(mddev), mddev->major_version,
 			mddev->minor_version, mddev->patch_version);
 		goto abort;
 	}
@@ -1433,9 +1433,9 @@ static int analyze_sbs(mddev_t * mddev)
 	if ((mddev->recovery_cp != MaxSector) &&
 	    ((mddev->level == 1) ||
 	     ((mddev->level >= 4) && (mddev->level <= 6))))
-		printk(KERN_ERR "md: md%d: raid array is not clean"
+		printk(KERN_ERR "md: %s: raid array is not clean"
 		       " -- starting background reconstruction\n",
-		       mdidx(mddev));
+		       mdname(mddev));
 
 	return 0;
 abort:
@@ -1660,8 +1660,8 @@ static int restart_array(mddev_t *mddev)
 		mddev->ro = 0;
 		set_disk_ro(disk, 0);
 
-		printk(KERN_INFO "md: md%d switched to read-write mode.\n",
-			mdidx(mddev));
+		printk(KERN_INFO "md: %s switched to read-write mode.\n",
+			mdname(mddev));
 		/*
 		 * Kick recovery or resync if necessary
 		 */
@@ -1669,8 +1669,8 @@ static int restart_array(mddev_t *mddev)
 		md_wakeup_thread(mddev->thread);
 		err = 0;
 	} else {
-		printk(KERN_ERR "md: md%d has no personality assigned.\n",
-			mdidx(mddev));
+		printk(KERN_ERR "md: %s has no personality assigned.\n",
+			mdname(mddev));
 		err = -EINVAL;
 	}
 
@@ -1685,7 +1685,7 @@ static int do_md_stop(mddev_t * mddev, i
 
 	if (mddev->pers) {
 		if (atomic_read(&mddev->active)>2) {
-			printk("md: md%d still in use.\n",mdidx(mddev));
+			printk("md: %s still in use.\n",mdname(mddev));
 			return -EBUSY;
 		}
 
@@ -1727,7 +1727,7 @@ static int do_md_stop(mddev_t * mddev, i
 	 */
 	if (!ro) {
 		struct gendisk *disk;
-		printk(KERN_INFO "md: md%d stopped.\n", mdidx(mddev));
+		printk(KERN_INFO "md: %s stopped.\n", mdname(mddev));
 
 		export_array(mddev);
 
@@ -1736,8 +1736,8 @@ static int do_md_stop(mddev_t * mddev, i
 		if (disk)
 			set_capacity(disk, 0);
 	} else
-		printk(KERN_INFO "md: md%d switched to read-only mode.\n",
-			mdidx(mddev));
+		printk(KERN_INFO "md: %s switched to read-only mode.\n",
+			mdname(mddev));
 	err = 0;
 out:
 	return err;
@@ -1816,16 +1816,16 @@ static void autorun_devices(void)
 			break;
 		}
 		if (mddev_lock(mddev)) 
-			printk(KERN_WARNING "md: md%d locked, cannot run\n",
-			       mdidx(mddev));
+			printk(KERN_WARNING "md: %s locked, cannot run\n",
+			       mdname(mddev));
 		else if (mddev->raid_disks || mddev->major_version
 			 || !list_empty(&mddev->disks)) {
 			printk(KERN_WARNING 
-				"md: md%d already running, cannot run %s\n",
-				mdidx(mddev), bdevname(rdev0->bdev,b));
+				"md: %s already running, cannot run %s\n",
+				mdname(mddev), bdevname(rdev0->bdev,b));
 			mddev_unlock(mddev);
 		} else if (rdev0->preferred_minor >= 0 && rdev0->preferred_minor < MAX_MD_DEVS) {
-			printk(KERN_INFO "md: created md%d\n", mdidx(mddev));
+			printk(KERN_INFO "md: created %s\n", mdname(mddev));
 			ITERATE_RDEV_GENERIC(candidates,rdev,tmp) {
 				list_del_init(&rdev->same_set);
 				if (bind_rdev_to_array(rdev, mddev))
@@ -2059,8 +2059,8 @@ static int add_new_disk(mddev_t * mddev,
 		int err;
 		if (!mddev->pers->hot_add_disk) {
 			printk(KERN_WARNING 
-				"md%d: personality does not support diskops!\n",
-			       mdidx(mddev));
+				"%s: personality does not support diskops!\n",
+			       mdname(mddev));
 			return -EINVAL;
 		}
 		rdev = md_import_device(dev, mddev->major_version,
@@ -2085,8 +2085,8 @@ static int add_new_disk(mddev_t * mddev,
 	 * for major_version==0 superblocks
 	 */
 	if (mddev->major_version != 0) {
-		printk(KERN_WARNING "md%d: ADD_NEW_DISK not supported\n",
-		       mdidx(mddev));
+		printk(KERN_WARNING "%s: ADD_NEW_DISK not supported\n",
+		       mdname(mddev));
 		return -EINVAL;
 	}
 
@@ -2140,8 +2140,8 @@ static int hot_generate_error(mddev_t * 
 	if (!mddev->pers)
 		return -ENODEV;
 
-	printk(KERN_INFO "md: trying to generate %s error in md%d ... \n",
-		__bdevname(dev, b), mdidx(mddev));
+	printk(KERN_INFO "md: trying to generate %s error in %s ... \n",
+		__bdevname(dev, b), mdname(mddev));
 
 	rdev = find_rdev(mddev, dev);
 	if (!rdev) {
@@ -2175,8 +2175,8 @@ static int hot_remove_disk(mddev_t * mdd
 	if (!mddev->pers)
 		return -ENODEV;
 
-	printk(KERN_INFO "md: trying to remove %s from md%d ... \n",
-		__bdevname(dev, b), mdidx(mddev));
+	printk(KERN_INFO "md: trying to remove %s from %s ... \n",
+		__bdevname(dev, b), mdname(mddev));
 
 	rdev = find_rdev(mddev, dev);
 	if (!rdev)
@@ -2190,8 +2190,8 @@ static int hot_remove_disk(mddev_t * mdd
 
 	return 0;
 busy:
-	printk(KERN_WARNING "md: cannot remove active disk %s from md%d ... \n",
-		bdevname(rdev->bdev,b), mdidx(mddev));
+	printk(KERN_WARNING "md: cannot remove active disk %s from %s ... \n",
+		bdevname(rdev->bdev,b), mdname(mddev));
 	return -EBUSY;
 }
 
@@ -2205,19 +2205,19 @@ static int hot_add_disk(mddev_t * mddev,
 	if (!mddev->pers)
 		return -ENODEV;
 
-	printk(KERN_INFO "md: trying to hot-add %s to md%d ... \n",
-		__bdevname(dev, b), mdidx(mddev));
+	printk(KERN_INFO "md: trying to hot-add %s to %s ... \n",
+		__bdevname(dev, b), mdname(mddev));
 
 	if (mddev->major_version != 0) {
-		printk(KERN_WARNING "md%d: HOT_ADD may only be used with"
+		printk(KERN_WARNING "%s: HOT_ADD may only be used with"
 			" version-0 superblocks.\n",
-			mdidx(mddev));
+			mdname(mddev));
 		return -EINVAL;
 	}
 	if (!mddev->pers->hot_add_disk) {
 		printk(KERN_WARNING 
-			"md%d: personality does not support diskops!\n",
-			mdidx(mddev));
+			"%s: personality does not support diskops!\n",
+			mdname(mddev));
 		return -EINVAL;
 	}
 
@@ -2235,8 +2235,8 @@ static int hot_add_disk(mddev_t * mddev,
 
 	if (size < mddev->size) {
 		printk(KERN_WARNING 
-			"md%d: disk size %llu blocks < array size %llu\n",
-			mdidx(mddev), (unsigned long long)size,
+			"%s: disk size %llu blocks < array size %llu\n",
+			mdname(mddev), (unsigned long long)size,
 			(unsigned long long)mddev->size);
 		err = -ENOSPC;
 		goto abort_export;
@@ -2244,8 +2244,8 @@ static int hot_add_disk(mddev_t * mddev,
 
 	if (rdev->faulty) {
 		printk(KERN_WARNING 
-			"md: can not hot-add faulty %s disk to md%d!\n",
-			bdevname(rdev->bdev,b), mdidx(mddev));
+			"md: can not hot-add faulty %s disk to %s!\n",
+			bdevname(rdev->bdev,b), mdname(mddev));
 		err = -EINVAL;
 		goto abort_export;
 	}
@@ -2259,8 +2259,8 @@ static int hot_add_disk(mddev_t * mddev,
 	 */
 
 	if (rdev->desc_nr == mddev->max_disks) {
-		printk(KERN_WARNING "md%d: can not hot-add to full array!\n",
-			mdidx(mddev));
+		printk(KERN_WARNING "%s: can not hot-add to full array!\n",
+			mdname(mddev));
 		err = -EBUSY;
 		goto abort_unbind_export;
 	}
@@ -2442,15 +2442,15 @@ static int md_ioctl(struct inode *inode,
 
 			if (!list_empty(&mddev->disks)) {
 				printk(KERN_WARNING 
-					"md: array md%d already has disks!\n",
-					mdidx(mddev));
+					"md: array %s already has disks!\n",
+					mdname(mddev));
 				err = -EBUSY;
 				goto abort_unlock;
 			}
 			if (mddev->raid_disks) {
 				printk(KERN_WARNING 
-					"md: array md%d already initialised!\n",
-					mdidx(mddev));
+					"md: array %s already initialised!\n",
+					mdname(mddev));
 				err = -EBUSY;
 				goto abort_unlock;
 			}
@@ -2645,7 +2645,7 @@ int md_thread(void * arg)
 	 * Detach thread
 	 */
 
-	daemonize(thread->name, mdidx(thread->mddev));
+	daemonize(thread->name, mdname(thread->mddev));
 
 	current->exit_signal = SIGCHLD;
 	allow_signal(SIGKILL);
@@ -2759,8 +2759,8 @@ void md_error(mddev_t *mddev, mdk_rdev_t
 	if (!rdev || rdev->faulty)
 		return;
 
-	dprintk("md_error dev:(%d:%d), rdev:(%d:%d), (caller: %p,%p,%p,%p).\n",
-		MD_MAJOR,mdidx(mddev),
+	dprintk("md_error dev:%s, rdev:(%d:%d), (caller: %p,%p,%p,%p).\n",
+		mdname(mddev),
 		MAJOR(rdev->bdev->bd_dev), MINOR(rdev->bdev->bd_dev),
 		__builtin_return_address(0),__builtin_return_address(1),
 		__builtin_return_address(2),__builtin_return_address(3));
@@ -2933,7 +2933,7 @@ static int md_seq_show(struct seq_file *
 	if (mddev_lock(mddev)!=0) 
 		return -EINTR;
 	if (mddev->pers || mddev->raid_disks || !list_empty(&mddev->disks)) {
-		seq_printf(seq, "md%d : %sactive", mdidx(mddev),
+		seq_printf(seq, "%s : %sactive", mdname(mddev),
 						mddev->pers ? "" : "in");
 		if (mddev->pers) {
 			if (mddev->ro)
@@ -3122,8 +3122,8 @@ static inline void md_enter_safemode(mdd
 void md_handle_safemode(mddev_t *mddev)
 {
 	if (signal_pending(current)) {
-		printk(KERN_INFO "md: md%d in immediate safe mode\n",
-			mdidx(mddev));
+		printk(KERN_INFO "md: %s in immediate safe mode\n",
+			mdname(mddev));
 		mddev->safemode = 2;
 		flush_signals(current);
 	}
@@ -3165,10 +3165,10 @@ static void md_do_sync(mddev_t *mddev)
 				continue;
 			if (mddev2->curr_resync && 
 			    match_mddev_units(mddev,mddev2)) {
-				printk(KERN_INFO "md: delaying resync of md%d"
-					" until md%d has finished resync (they"
+				printk(KERN_INFO "md: delaying resync of %s"
+					" until %s has finished resync (they"
 				       	" share one or more physical units)\n",
-				       mdidx(mddev), mdidx(mddev2));
+				       mdname(mddev), mdname(mddev2));
 				if (mddev < mddev2) {/* arbitrarily yield */
 					mddev->curr_resync = 1;
 					wake_up(&resync_wait);
@@ -3189,7 +3189,7 @@ static void md_do_sync(mddev_t *mddev)
 
 	max_sectors = mddev->size << 1;
 
-	printk(KERN_INFO "md: syncing RAID array md%d\n", mdidx(mddev));
+	printk(KERN_INFO "md: syncing RAID array %s\n", mdname(mddev));
 	printk(KERN_INFO "md: minimum _guaranteed_ reconstruction speed:"
 		" %d KB/sec/disc.\n", sysctl_speed_limit_min);
 	printk(KERN_INFO "md: using maximum available idle IO bandwith "
@@ -3222,8 +3222,8 @@ static void md_do_sync(mddev_t *mddev)
 
 	if (j)
 		printk(KERN_INFO 
-			"md: resuming recovery of md%d from checkpoint.\n",
-			mdidx(mddev));
+			"md: resuming recovery of %s from checkpoint.\n",
+			mdname(mddev));
 
 	while (j < max_sectors) {
 		int sectors;
@@ -3293,7 +3293,7 @@ static void md_do_sync(mddev_t *mddev)
 			}
 		}
 	}
-	printk(KERN_INFO "md: md%d: sync done.\n",mdidx(mddev));
+	printk(KERN_INFO "md: %s: sync done.\n",mdname(mddev));
 	/*
 	 * this also signals 'finished resyncing' to md_stop
 	 */
@@ -3308,8 +3308,8 @@ static void md_do_sync(mddev_t *mddev)
 	    mddev->curr_resync > mddev->recovery_cp) {
 		if (test_bit(MD_RECOVERY_INTR, &mddev->recovery)) {
 			printk(KERN_INFO 
-				"md: checkpointing recovery of md%d.\n",
-				mdidx(mddev));
+				"md: checkpointing recovery of %s.\n",
+				mdname(mddev));
 			mddev->recovery_cp = mddev->curr_resync;
 		} else
 			mddev->recovery_cp = MaxSector;
@@ -3429,11 +3429,11 @@ void md_check_recovery(mddev_t *mddev)
 				set_bit(MD_RECOVERY_SYNC, &mddev->recovery);
 			mddev->sync_thread = md_register_thread(md_do_sync,
 								mddev,
-								"md%d_resync");
+								"%s_resync");
 			if (!mddev->sync_thread) {
-				printk(KERN_ERR "md%d: could not start resync"
+				printk(KERN_ERR "%s: could not start resync"
 					" thread...\n", 
-					mdidx(mddev));
+					mdname(mddev));
 				/* leave the spares where they are, it shouldn't hurt */
 				mddev->recovery = 0;
 			} else {

diff ./drivers/md/multipath.c~current~ ./drivers/md/multipath.c
--- ./drivers/md/multipath.c~current~	2004-01-23 10:36:51.000000000 +1100
+++ ./drivers/md/multipath.c	2004-01-23 10:37:11.000000000 +1100
@@ -389,8 +389,8 @@ static int multipath_run (mddev_t *mddev
 	struct list_head *tmp;
 
 	if (mddev->level != LEVEL_MULTIPATH) {
-		printk("multipath: md%d: raid level not set to multipath IO (%d)\n",
-		       mdidx(mddev), mddev->level);
+		printk("multipath: %s: raid level not set to multipath IO (%d)\n",
+		       mdname(mddev), mddev->level);
 		goto out;
 	}
 	/*
@@ -403,8 +403,8 @@ static int multipath_run (mddev_t *mddev
 	mddev->private = conf;
 	if (!conf) {
 		printk(KERN_ERR 
-			"multipath: couldn't allocate memory for md%d\n",
-			mdidx(mddev));
+			"multipath: couldn't allocate memory for %s\n",
+			mdname(mddev));
 		goto out;
 	}
 	memset(conf, 0, sizeof(*conf));
@@ -413,8 +413,8 @@ static int multipath_run (mddev_t *mddev
 				   GFP_KERNEL);
 	if (!conf->multipaths) {
 		printk(KERN_ERR 
-			"multipath: couldn't allocate memory for md%d\n",
-			mdidx(mddev));
+			"multipath: couldn't allocate memory for %s\n",
+			mdname(mddev));
 		goto out_free_conf;
 	}
 	memset(conf->multipaths, 0, sizeof(struct multipath_info)*mddev->raid_disks);
@@ -448,8 +448,8 @@ static int multipath_run (mddev_t *mddev
 	conf->device_lock = SPIN_LOCK_UNLOCKED;
 
 	if (!conf->working_disks) {
-		printk(KERN_ERR "multipath: no operational IO paths for md%d\n",
-			mdidx(mddev));
+		printk(KERN_ERR "multipath: no operational IO paths for %s\n",
+			mdname(mddev));
 		goto out_free_conf;
 	}
 	mddev->degraded = conf->raid_disks = conf->working_disks;
@@ -459,25 +459,23 @@ static int multipath_run (mddev_t *mddev
 				    NULL);
 	if (conf->pool == NULL) {
 		printk(KERN_ERR 
-			"multipath: couldn't allocate memory for md%d\n",
-			mdidx(mddev));
+			"multipath: couldn't allocate memory for %s\n",
+			mdname(mddev));
 		goto out_free_conf;
 	}
 
 	{
-		const char * name = "md%d_multipath";
-
-		mddev->thread = md_register_thread(multipathd, mddev, name);
+		mddev->thread = md_register_thread(multipathd, mddev, "%s_multipath");
 		if (!mddev->thread) {
 			printk(KERN_ERR "multipath: couldn't allocate thread"
-				" for md%d\n", mdidx(mddev));
+				" for %s\n", mdname(mddev));
 			goto out_free_conf;
 		}
 	}
 
 	printk(KERN_INFO 
-		"multipath: array md%d active with %d out of %d IO paths\n",
-		mdidx(mddev), conf->working_disks, mddev->raid_disks);
+		"multipath: array %s active with %d out of %d IO paths\n",
+		mdname(mddev), conf->working_disks, mddev->raid_disks);
 	/*
 	 * Ok, everything is just fine now
 	 */

diff ./drivers/md/raid0.c~current~ ./drivers/md/raid0.c
--- ./drivers/md/raid0.c~current~	2004-01-23 10:36:51.000000000 +1100
+++ ./drivers/md/raid0.c	2004-01-23 10:37:11.000000000 +1100
@@ -240,8 +240,8 @@ static int raid0_run (mddev_t *mddev)
 	mdk_rdev_t *rdev;
 	struct list_head *tmp;
 
-	printk("md%d: setting max_sectors to %d, segment boundary to %d\n",
-	       mdidx(mddev),
+	printk("%s: setting max_sectors to %d, segment boundary to %d\n",
+	       mdname(mddev),
 	       mddev->chunk_size >> 9,
 	       (mddev->chunk_size>>1)-1);
 	blk_queue_max_sectors(mddev->queue, mddev->chunk_size >> 9);

diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
--- ./drivers/md/raid1.c~current~	2004-01-23 10:36:51.000000000 +1100
+++ ./drivers/md/raid1.c	2004-01-23 10:37:11.000000000 +1100
@@ -1052,8 +1052,8 @@ static int run(mddev_t *mddev)
 	struct list_head *tmp;
 
 	if (mddev->level != 1) {
-		printk("raid1: md%d: raid level not set to mirroring (%d)\n",
-		       mdidx(mddev), mddev->level);
+		printk("raid1: %s: raid level not set to mirroring (%d)\n",
+		       mdname(mddev), mddev->level);
 		goto out;
 	}
 	/*
@@ -1064,16 +1064,16 @@ static int run(mddev_t *mddev)
 	conf = kmalloc(sizeof(conf_t), GFP_KERNEL);
 	mddev->private = conf;
 	if (!conf) {
-		printk(KERN_ERR "raid1: couldn't allocate memory for md%d\n",
-			mdidx(mddev));
+		printk(KERN_ERR "raid1: couldn't allocate memory for %s\n",
+			mdname(mddev));
 		goto out;
 	}
 	memset(conf, 0, sizeof(*conf));
 	conf->mirrors = kmalloc(sizeof(struct mirror_info)*mddev->raid_disks, 
 				 GFP_KERNEL);
 	if (!conf->mirrors) {
-		printk(KERN_ERR "raid1: couldn't allocate memory for md%d\n",
-		       mdidx(mddev));
+		printk(KERN_ERR "raid1: couldn't allocate memory for %s\n",
+		       mdname(mddev));
 		goto out_free_conf;
 	}
 	memset(conf->mirrors, 0, sizeof(struct mirror_info)*mddev->raid_disks);
@@ -1081,8 +1081,8 @@ static int run(mddev_t *mddev)
 	conf->r1bio_pool = mempool_create(NR_RAID1_BIOS, r1bio_pool_alloc,
 						r1bio_pool_free, mddev);
 	if (!conf->r1bio_pool) {
-		printk(KERN_ERR "raid1: couldn't allocate memory for md%d\n", 
-			mdidx(mddev));
+		printk(KERN_ERR "raid1: couldn't allocate memory for %s\n", 
+			mdname(mddev));
 		goto out_free_conf;
 	}
 
@@ -1121,8 +1121,8 @@ static int run(mddev_t *mddev)
 	init_waitqueue_head(&conf->wait_resume);
 
 	if (!conf->working_disks) {
-		printk(KERN_ERR "raid1: no operational mirrors for md%d\n",
-			mdidx(mddev));
+		printk(KERN_ERR "raid1: no operational mirrors for %s\n",
+			mdname(mddev));
 		goto out_free_conf;
 	}
 
@@ -1150,17 +1150,17 @@ static int run(mddev_t *mddev)
 
 
 	{
-		mddev->thread = md_register_thread(raid1d, mddev, "md%d_raid1");
+		mddev->thread = md_register_thread(raid1d, mddev, "%s_raid1");
 		if (!mddev->thread) {
 			printk(KERN_ERR 
-				"raid1: couldn't allocate thread for md%d\n", 
-				mdidx(mddev));
+				"raid1: couldn't allocate thread for %s\n", 
+				mdname(mddev));
 			goto out_free_conf;
 		}
 	}
 	printk(KERN_INFO 
-		"raid1: raid set md%d active with %d out of %d mirrors\n",
-		mdidx(mddev), mddev->raid_disks - mddev->degraded, 
+		"raid1: raid set %s active with %d out of %d mirrors\n",
+		mdname(mddev), mddev->raid_disks - mddev->degraded, 
 		mddev->raid_disks);
 	/*
 	 * Ok, everything is just fine now

diff ./drivers/md/raid5.c~current~ ./drivers/md/raid5.c
--- ./drivers/md/raid5.c~current~	2004-01-23 10:36:51.000000000 +1100
+++ ./drivers/md/raid5.c	2004-01-23 10:37:11.000000000 +1100
@@ -1485,7 +1485,7 @@ static int run (mddev_t *mddev)
 	struct list_head *tmp;
 
 	if (mddev->level != 5 && mddev->level != 4) {
-		printk("raid5: md%d: raid level not set to 4/5 (%d)\n", mdidx(mddev), mddev->level);
+		printk("raid5: %s: raid level not set to 4/5 (%d)\n", mdname(mddev), mddev->level);
 		return -EIO;
 	}
 
@@ -1511,7 +1511,7 @@ static int run (mddev_t *mddev)
 
 	mddev->queue->unplug_fn = raid5_unplug_device;
 
-	PRINTK("raid5: run(md%d) called.\n", mdidx(mddev));
+	PRINTK("raid5: run(%s) called.\n", mdname(mddev));
 
 	ITERATE_RDEV(mddev,rdev,tmp) {
 		raid_disk = rdev->raid_disk;
@@ -1543,37 +1543,37 @@ static int run (mddev_t *mddev)
 	conf->max_nr_stripes = NR_STRIPES;
 
 	if (!conf->chunk_size || conf->chunk_size % 4) {
-		printk(KERN_ERR "raid5: invalid chunk size %d for md%d\n",
-			conf->chunk_size, mdidx(mddev));
+		printk(KERN_ERR "raid5: invalid chunk size %d for %s\n",
+			conf->chunk_size, mdname(mddev));
 		goto abort;
 	}
 	if (conf->algorithm > ALGORITHM_RIGHT_SYMMETRIC) {
 		printk(KERN_ERR 
-			"raid5: unsupported parity algorithm %d for md%d\n",
-			conf->algorithm, mdidx(mddev));
+			"raid5: unsupported parity algorithm %d for %s\n",
+			conf->algorithm, mdname(mddev));
 		goto abort;
 	}
 	if (mddev->degraded > 1) {
-		printk(KERN_ERR "raid5: not enough operational devices for md%d"
+		printk(KERN_ERR "raid5: not enough operational devices for %s"
 			" (%d/%d failed)\n",
-			mdidx(mddev), conf->failed_disks, conf->raid_disks);
+			mdname(mddev), conf->failed_disks, conf->raid_disks);
 		goto abort;
 	}
 
 	if (mddev->degraded == 1 &&
 	    mddev->recovery_cp != MaxSector) {
 		printk(KERN_ERR 
-			"raid5: cannot start dirty degraded array for md%d\n",
-			mdidx(mddev));
+			"raid5: cannot start dirty degraded array for %s\n",
+			mdname(mddev));
 		goto abort;
 	}
 
 	{
-		mddev->thread = md_register_thread(raid5d, mddev, "md%d_raid5");
+		mddev->thread = md_register_thread(raid5d, mddev, "%s_raid5");
 		if (!mddev->thread) {
 			printk(KERN_ERR 
-				"raid5: couldn't allocate thread for md%d\n",
-				mdidx(mddev));
+				"raid5: couldn't allocate thread for %s\n",
+				mdname(mddev));
 			goto abort;
 		}
 	}
@@ -1586,18 +1586,18 @@ memory = conf->max_nr_stripes * (sizeof(
 		md_unregister_thread(mddev->thread);
 		goto abort;
 	} else
-		printk(KERN_INFO "raid5: allocated %dkB for md%d\n",
-			memory, mdidx(mddev));
+		printk(KERN_INFO "raid5: allocated %dkB for %s\n",
+			memory, mdname(mddev));
 
 	if (mddev->degraded == 0)
-		printk("raid5: raid level %d set md%d active with %d out of %d"
-			" devices, algorithm %d\n", conf->level, mdidx(mddev), 
+		printk("raid5: raid level %d set %s active with %d out of %d"
+			" devices, algorithm %d\n", conf->level, mdname(mddev), 
 			mddev->raid_disks-mddev->degraded, mddev->raid_disks,
 			conf->algorithm);
 	else
-		printk(KERN_ALERT "raid5: raid level %d set md%d active with %d"
+		printk(KERN_ALERT "raid5: raid level %d set %s active with %d"
 			" out of %d devices, algorithm %d\n", conf->level,
-			mdidx(mddev), mddev->raid_disks - mddev->degraded,
+			mdname(mddev), mddev->raid_disks - mddev->degraded,
 			mddev->raid_disks, conf->algorithm);
 
 	print_raid5_conf(conf);
@@ -1624,7 +1624,7 @@ abort:
 		kfree(conf);
 	}
 	mddev->private = NULL;
-	printk(KERN_ALERT "raid5: failed to run raid set md%d\n", mdidx(mddev));
+	printk(KERN_ALERT "raid5: failed to run raid set %s\n", mdname(mddev));
 	return -EIO;
 }
 

diff ./drivers/md/raid6main.c~current~ ./drivers/md/raid6main.c
--- ./drivers/md/raid6main.c~current~	2004-01-23 10:36:51.000000000 +1100
+++ ./drivers/md/raid6main.c	2004-01-23 10:37:11.000000000 +1100
@@ -1647,7 +1647,7 @@ static int run (mddev_t *mddev)
 	struct list_head *tmp;
 
 	if (mddev->level != 6) {
-		PRINTK("raid6: md%d: raid level not set to 6 (%d)\n", mdidx(mddev), mddev->level);
+		PRINTK("raid6: %s: raid level not set to 6 (%d)\n", mdname(mddev), mddev->level);
 		return -EIO;
 	}
 
@@ -1673,7 +1673,7 @@ static int run (mddev_t *mddev)
 
 	mddev->queue->unplug_fn = raid6_unplug_device;
 
-	PRINTK("raid6: run(md%d) called.\n", mdidx(mddev));
+	PRINTK("raid6: run(%s) called.\n", mdname(mddev));
 
 	ITERATE_RDEV(mddev,rdev,tmp) {
 		raid_disk = rdev->raid_disk;
@@ -1706,42 +1706,42 @@ static int run (mddev_t *mddev)
 	conf->max_nr_stripes = NR_STRIPES;
 
 	if (conf->raid_disks < 4) {
-		printk(KERN_ERR "raid6: not enough configured devices for md%d (%d, minimum 4)\n",
-		       mdidx(mddev), conf->raid_disks);
+		printk(KERN_ERR "raid6: not enough configured devices for %s (%d, minimum 4)\n",
+		       mdname(mddev), conf->raid_disks);
 		goto abort;
 	}
 	if (!conf->chunk_size || conf->chunk_size % 4) {
-		printk(KERN_ERR "raid6: invalid chunk size %d for md%d\n",
-		       conf->chunk_size, mdidx(mddev));
+		printk(KERN_ERR "raid6: invalid chunk size %d for %s\n",
+		       conf->chunk_size, mdname(mddev));
 		goto abort;
 	}
 	if (conf->algorithm > ALGORITHM_RIGHT_SYMMETRIC) {
 		printk(KERN_ERR
-		       "raid6: unsupported parity algorithm %d for md%d\n",
-		       conf->algorithm, mdidx(mddev));
+		       "raid6: unsupported parity algorithm %d for %s\n",
+		       conf->algorithm, mdname(mddev));
 		goto abort;
 	}
 	if (mddev->degraded > 2) {
-		printk(KERN_ERR "raid6: not enough operational devices for md%d"
+		printk(KERN_ERR "raid6: not enough operational devices for %s"
 		       " (%d/%d failed)\n",
-		       mdidx(mddev), conf->failed_disks, conf->raid_disks);
+		       mdname(mddev), conf->failed_disks, conf->raid_disks);
 		goto abort;
 	}
 
 #if 0				/* FIX: For now */
 	if (mddev->degraded > 0 &&
 	    mddev->recovery_cp != MaxSector) {
-		printk(KERN_ERR "raid6: cannot start dirty degraded array for md%d\n", mdidx(mddev));
+		printk(KERN_ERR "raid6: cannot start dirty degraded array for %s\n", mdname(mddev));
 		goto abort;
 	}
 #endif
 
 	{
-		mddev->thread = md_register_thread(raid6d, mddev, "md%d_raid6");
+		mddev->thread = md_register_thread(raid6d, mddev, "%s_raid6");
 		if (!mddev->thread) {
 			printk(KERN_ERR
-			       "raid6: couldn't allocate thread for md%d\n",
-			       mdidx(mddev));
+			       "raid6: couldn't allocate thread for %s\n",
+			       mdname(mddev));
 			goto abort;
 		}
 	}
@@ -1755,18 +1755,18 @@ static int run (mddev_t *mddev)
 		md_unregister_thread(mddev->thread);
 		goto abort;
 	} else
-		printk(KERN_INFO "raid6: allocated %dkB for md%d\n",
-		       memory, mdidx(mddev));
+		printk(KERN_INFO "raid6: allocated %dkB for %s\n",
+		       memory, mdname(mddev));
 
 	if (mddev->degraded == 0)
-		printk(KERN_INFO "raid6: raid level %d set md%d active with %d out of %d"
-		       " devices, algorithm %d\n", conf->level, mdidx(mddev),
+		printk(KERN_INFO "raid6: raid level %d set %s active with %d out of %d"
+		       " devices, algorithm %d\n", conf->level, mdname(mddev),
 		       mddev->raid_disks-mddev->degraded, mddev->raid_disks,
 		       conf->algorithm);
 	else
-		printk(KERN_ALERT "raid6: raid level %d set md%d active with %d"
+		printk(KERN_ALERT "raid6: raid level %d set %s active with %d"
 		       " out of %d devices, algorithm %d\n", conf->level,
-		       mdidx(mddev), mddev->raid_disks - mddev->degraded,
+		       mdname(mddev), mddev->raid_disks - mddev->degraded,
 		       mddev->raid_disks, conf->algorithm);
 
 	print_raid6_conf(conf);
@@ -1793,7 +1793,7 @@ abort:
 		kfree(conf);
 	}
 	mddev->private = NULL;
-	printk(KERN_ALERT "raid6: failed to run raid set md%d\n", mdidx(mddev));
+	printk(KERN_ALERT "raid6: failed to run raid set %s\n", mdname(mddev));
 	return -EIO;
 }
 

diff ./include/linux/raid/md_k.h~current~ ./include/linux/raid/md_k.h
--- ./include/linux/raid/md_k.h~current~	2004-01-23 10:30:08.000000000 +1100
+++ ./include/linux/raid/md_k.h	2004-01-23 10:37:11.000000000 +1100
@@ -281,6 +281,10 @@ static inline int mdidx (mddev_t * mddev
 {
 	return mddev->__minor;
 }
+static inline char * mdname (mddev_t * mddev)
+{
+	return mddev->gendisk ? mddev->gendisk->disk_name : "mdX";
+}
 
 extern mdk_rdev_t * find_rdev_nr(mddev_t *mddev, int nr);
 
