From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 7 of 13 - Make spare handling simple ... personalities know less
Date: Thu, 22 Aug 2002 10:34:10 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E17hfvO-00050K-00@notabene.cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


### Comments for ChangeSet

1/ Personalities only know about raid_disks devices.
   Some might be not in_sync and so cannot be read from,
   but must be written to.
	- change MD_SB_DISKS to ->raid_disks
	- add tests for .write_only

2/ rdev->raid_disk is now -1 for spares.  desc_nr is maintained 
   by analyse_sbs and sync_sbs.

3/ spare_inactive method is subsumed into hot_remove_disk
   spare_writable is subsumed into hot_add_disk.
   hot_add_disk decides which slot a new device will hold.

4/ spare_active now finds all non-in_sync devices and marks them
   in_sync.

5/ faulty devices are removed by the md recovery thread as soon
   as they are idle.  Any spares that are available are then added.



 ----------- Diffstat output ------------
 ./drivers/md/md.c            |  160 +++++++++++--------------
 ./drivers/md/multipath.c     |   68 ++++------
 ./drivers/md/raid1.c         |  253 +++++++++-------------------------------
 ./drivers/md/raid5.c         |  271 ++++++++-----------------------------------
 ./include/linux/raid/md_k.h  |    7 -
 ./include/linux/raid/raid1.h |    2 
 ./include/linux/raid/raid5.h |    1 
 7 files changed, 210 insertions(+), 552 deletions(-)

--- ./include/linux/raid/raid1.h	2002/08/21 23:10:56	1.4
+++ ./include/linux/raid/raid1.h	2002/08/21 23:11:27	1.5
@@ -14,7 +14,6 @@ struct mirror_info {
 	 */
 	int		operational;
 	int		write_only;
-	int		spare;
 };
 
 typedef struct r1bio_s r1bio_t;
@@ -27,7 +26,6 @@ struct r1_private_data_s {
 	int			last_used;
 	sector_t		next_seq_sect;
 	mdk_thread_t		*thread;
-	mirror_info_t		*spare;
 	spinlock_t		device_lock;
 
 	/* for use when syncing mirrors: */
--- ./include/linux/raid/raid5.h	2002/08/21 23:10:56	1.3
+++ ./include/linux/raid/raid5.h	2002/08/21 23:11:27	1.4
@@ -195,7 +195,6 @@ struct disk_info {
 	mdk_rdev_t	*rdev;
 	int		operational;
 	int		write_only;
-	int		spare;
 };
 
 struct raid5_private_data {
--- ./include/linux/raid/md_k.h	2002/08/21 23:10:24	1.3
+++ ./include/linux/raid/md_k.h	2002/08/21 23:11:27	1.4
@@ -207,7 +207,7 @@ struct mddev_s
 	int				in_sync;	/* know to not need resync */
 	struct semaphore		reconfig_sem;
 	atomic_t			active;
-	mdk_rdev_t			*spare;
+	int				spares;
 
 	int				degraded;	/* whether md should consider
 							 * adding a spare
@@ -231,8 +231,6 @@ struct mdk_personality_s
 	int (*error_handler)(mddev_t *mddev, mdk_rdev_t *rdev);
 	int (*hot_add_disk) (mddev_t *mddev, mdk_rdev_t *rdev);
 	int (*hot_remove_disk) (mddev_t *mddev, int number);
-	int (*spare_write) (mddev_t *mddev);
-	int (*spare_inactive) (mddev_t *mddev);
 	int (*spare_active) (mddev_t *mddev);
 	int (*sync_request)(mddev_t *mddev, sector_t sector_nr, int go_faster);
 };
@@ -277,9 +275,6 @@ extern mdk_rdev_t * find_rdev_nr(mddev_t
 #define ITERATE_RDEV_PENDING(rdev,tmp)					\
 	ITERATE_RDEV_GENERIC(pending_raid_disks,rdev,tmp)
 
-#define xchg_values(x,y) do { __typeof__(x) __tmp = x; \
-				x = y; y = __tmp; } while (0)
-
 typedef struct mdk_thread_s {
 	void			(*run) (void *data);
 	void			*data;
--- ./drivers/md/md.c	2002/08/21 23:10:24	1.7
+++ ./drivers/md/md.c	2002/08/21 23:11:27	1.8
@@ -233,7 +233,7 @@ mdk_rdev_t * find_rdev_nr(mddev_t *mddev
 	struct list_head *tmp;
 
 	ITERATE_RDEV(mddev,rdev,tmp) {
-		if (rdev->raid_disk == nr)
+		if (rdev->desc_nr == nr)
 			return rdev;
 	}
 	return NULL;
@@ -804,6 +804,7 @@ static void sync_sbs(mddev_t * mddev)
 	mdk_rdev_t *rdev;
 	mdp_super_t *sb;
 	struct list_head *tmp;
+	int next_spare = mddev->raid_disks;
 
 	/* make all rdev->sb match mddev data..
 	 * we setup the data in the first rdev and copy it
@@ -856,12 +857,20 @@ static void sync_sbs(mddev_t * mddev)
 
 	sb->disks[0].state = (1<<MD_DISK_REMOVED);
 	ITERATE_RDEV(mddev,rdev,tmp) {
-		mdp_disk_t *d = &sb->disks[rdev->desc_nr];
+		mdp_disk_t *d;
+		if (rdev->raid_disk >= 0)
+			rdev->desc_nr = rdev->raid_disk;
+		else
+			rdev->desc_nr = next_spare++;
+		d = &sb->disks[rdev->desc_nr];
 		nr_disks++;
 		d->number = rdev->desc_nr;
 		d->major = MAJOR(rdev->bdev->bd_dev);
 		d->minor = MINOR(rdev->bdev->bd_dev);
-		d->raid_disk = rdev->raid_disk;
+		if (rdev->raid_disk >= 0)
+			d->raid_disk = rdev->raid_disk;
+		else
+			d->raid_disk = rdev->desc_nr; /* compatability */
 		if (rdev->faulty) {
 			d->state = (1<<MD_DISK_FAULTY);
 			failed++;
@@ -1195,15 +1204,17 @@ static int analyze_sbs(mddev_t * mddev)
 			mdp_disk_t *desc;
 			rdev->desc_nr = rdev->sb->this_disk.number;
 			desc = sb->disks + rdev->desc_nr;
-			rdev->raid_disk = desc->raid_disk;
+			rdev->raid_disk = -1;
 			rdev->in_sync = rdev->faulty = 0;
 
 			if (desc->state & (1<<MD_DISK_FAULTY)) {
 				rdev->faulty = 1;
 				kick_rdev_from_array(rdev);
 			} else if (desc->state & (1<<MD_DISK_SYNC) &&
-				 rdev->raid_disk < mddev->raid_disks)
+				   desc->raid_disk < mddev->raid_disks) {
 				rdev->in_sync = 1;
+				rdev->raid_disk = desc->raid_disk;
+			}
 		}
 	}
 
@@ -1551,10 +1562,6 @@ static int do_md_stop(mddev_t * mddev, i
 				mddev->recovery_running = -EINTR;
 			md_unregister_thread(mddev->sync_thread);
 			mddev->sync_thread = NULL;
-			if (mddev->spare) {
-				mddev->pers->spare_inactive(mddev);
-				mddev->spare = NULL;
-			}
 		}
 
 		invalidate_device(dev, 1);
@@ -1925,7 +1932,7 @@ static int get_disk_info(mddev_t * mddev
 		}
 	} else {
 		info.major = info.minor = 0;
-		info.raid_disk = 0;
+		info.raid_disk = -1;
 		info.state = (1<<MD_DISK_REMOVED);
 	}
 
@@ -1975,7 +1982,11 @@ static int add_new_disk(mddev_t * mddev,
 			return PTR_ERR(rdev);
 		}
 		rdev->desc_nr = info->number;
-		rdev->raid_disk = info->raid_disk;
+		if (info->raid_disk < mddev->raid_disks)
+			rdev->raid_disk = info->raid_disk;
+		else
+			rdev->raid_disk = -1;
+
 		rdev->faulty = 0;
 		if (rdev->raid_disk < mddev->raid_disks)
 			rdev->in_sync = (info->state & (1<<MD_DISK_SYNC));
@@ -2034,7 +2045,6 @@ static int hot_generate_error(mddev_t * 
 
 static int hot_remove_disk(mddev_t * mddev, dev_t dev)
 {
-	int err;
 	mdk_rdev_t *rdev;
 
 	if (!mddev->pers)
@@ -2043,28 +2053,12 @@ static int hot_remove_disk(mddev_t * mdd
 	printk(KERN_INFO "md: trying to remove %s from md%d ... \n",
 		partition_name(to_kdev_t(dev)), mdidx(mddev));
 
-	if (!mddev->pers->hot_remove_disk) {
-		printk(KERN_WARNING "md%d: personality does not support diskops!\n",
-		       mdidx(mddev));
-		return -EINVAL;
-	}
-
 	rdev = find_rdev(mddev, dev);
 	if (!rdev)
 		return -ENXIO;
 
-	if (rdev->in_sync && ! rdev->faulty)
-		goto busy;
-
-	err = mddev->pers->hot_remove_disk(mddev, rdev->raid_disk);
-	if (err == -EBUSY) {
-		MD_BUG();
+	if (rdev->raid_disk >= 0)
 		goto busy;
-	}
-	if (err) {
-		MD_BUG();
-		return -EINVAL;
-	}
 
 	kick_rdev_from_array(rdev);
 	md_update_sb(mddev);
@@ -2137,13 +2131,7 @@ static int hot_add_disk(mddev_t * mddev,
 	}
 
 	rdev->desc_nr = i;
-	rdev->raid_disk = i;
-
-	if (mddev->pers->hot_add_disk(mddev, rdev)) {
-		MD_BUG();
-		err = -EINVAL;
-		goto abort_unbind_export;
-	}
+	rdev->raid_disk = -1;
 
 	md_update_sb(mddev);
 
@@ -2697,7 +2685,7 @@ static int status_resync(char * page, md
 		sz += sprintf(page + sz, "] ");
 	}
 	sz += sprintf(page + sz, " %s =%3lu.%lu%% (%lu/%lu)",
-		      (mddev->spare ? "recovery" : "resync"),
+		      (mddev->spares ? "recovery" : "resync"),
 		      res/10, res % 10, resync, max_blocks);
 
 	/*
@@ -2815,22 +2803,6 @@ int unregister_md_personality(int pnum)
 	return 0;
 }
 
-static mdk_rdev_t *get_spare(mddev_t *mddev)
-{
-	mdk_rdev_t *rdev;
-	struct list_head *tmp;
-
-	ITERATE_RDEV(mddev,rdev,tmp) {
-		if (rdev->faulty)
-			continue;
-		if (rdev->in_sync)
-			continue;
-
-		return rdev;
-	}
-	return NULL;
-}
-
 static unsigned int sync_io[DK_MAX_MAJOR][DK_MAX_DISK];
 void md_sync_acct(mdk_rdev_t *rdev, unsigned long nr_sectors)
 {
@@ -3048,19 +3020,30 @@ static void md_do_sync(void *data)
 
 
 /*
- * This is the kernel thread that watches all md arrays for re-sync action
- * that might be needed.
+ * This is the kernel thread that watches all md arrays for re-sync and other
+ * action that might be needed.
  * It does not do any resync itself, but rather "forks" off other threads
  * to do that as needed.
  * When it is determined that resync is needed, we set "->recovery_running" and
  * create a thread at ->sync_thread.
- * When the thread finishes is clears recovery_running (or set and error)
+ * When the thread finishes it clears recovery_running (or sets an error)
  * and wakeup up this thread which will reap the thread and finish up.
+ * This thread also removes any faulty devices (with nr_pending == 0).
+ *
+ * The overall approach is:
+ *  1/ if the superblock needs updating, update it.
+ *  2/ If a recovery thread is running, don't do anything else.
+ *  3/ If recovery has finished, clean up, possibly marking spares active.
+ *  4/ If there are any faulty devices, remove them.
+ *  5/ If array is degraded, try to add spares devices
+ *  6/ If array has spares or is not in-sync, start a resync thread.
  */
 void md_do_recovery(void *data)
 {
 	mddev_t *mddev;
-	struct list_head *tmp;
+	mdk_rdev_t *rdev;
+	struct list_head *tmp, *rtmp;
+
 
 	dprintk(KERN_INFO "md: recovery thread got woken up ...\n");
 
@@ -3076,26 +3059,11 @@ void md_do_recovery(void *data)
 			/* resync has finished, collect result */
 			md_unregister_thread(mddev->sync_thread);
 			mddev->sync_thread = NULL;
-			if (mddev->recovery_running < 0) {
-				/* some sort of failure.
-				 * If we were doing a reconstruction,
-				 * we need to retrieve the spare
-				 */
-				if (!mddev->pers->spare_inactive)
-					goto unlock;
-				if (mddev->spare) {
-					mddev->pers->spare_inactive(mddev);
-					mddev->spare = NULL;
-				}
-			} else {
-				if (!mddev->pers->spare_active)
-					goto unlock;
+			if (mddev->recovery_running == 0) {
 				/* success...*/
-				if (mddev->spare) {
-					mddev->pers->spare_active(mddev);
-					mddev->spare->in_sync = 1;
-					mddev->spare = NULL;
-				}
+				/* activate any spares */
+				mddev->pers->spare_active(mddev);
+				mddev->spares = 0;
 			}
 			md_update_sb(mddev);
 			mddev->recovery_running = 0;
@@ -3108,16 +3076,33 @@ void md_do_recovery(void *data)
 			wake_up(&resync_wait);
 		}
 
+		/* no recovery is running.
+		 * remove any failed drives, then
+		 * add spares if possible
+		 */
+		mddev->spares = 0;
+		ITERATE_RDEV(mddev,rdev,rtmp) {
+			if (rdev->raid_disk >= 0 &&
+			    rdev->faulty &&
+			    atomic_read(&rdev->nr_pending)==0) {
+				mddev->pers->hot_remove_disk(mddev, rdev->raid_disk);
+				rdev->raid_disk = -1;
+			}
+			if (!rdev->faulty && rdev->raid_disk >= 0 && !rdev->in_sync)
+				mddev->spares++;
+		}
 		if (mddev->degraded) {
-			mddev->spare = get_spare(mddev);
-			if (!mddev->spare)
-				printk(KERN_ERR "md%d: no spare disk to reconstruct array! "
-				       "-- continuing in degraded mode\n", mdidx(mddev));
-			else
-				printk(KERN_INFO "md%d: resyncing spare disk %s to replace failed disk\n",
-				       mdidx(mddev), bdev_partition_name(mddev->spare->bdev));
+			ITERATE_RDEV(mddev,rdev,rtmp)
+				if (rdev->raid_disk < 0
+				    && !rdev->faulty) {
+					if (mddev->pers->hot_add_disk(mddev,rdev))
+						mddev->spares++;
+					else
+						break;
+				}
 		}
-		if (!mddev->spare && mddev->in_sync) {
+
+		if (!mddev->spares && mddev->in_sync) {
 			/* nothing we can do ... */
 			goto unlock;
 		}
@@ -3127,13 +3112,9 @@ void md_do_recovery(void *data)
 								"md_resync");
 			if (!mddev->sync_thread) {
 				printk(KERN_ERR "md%d: could not start resync thread...\n", mdidx(mddev));
-				if (mddev->spare)
-					mddev->pers->spare_inactive(mddev);
-				mddev->spare = NULL;
+				/* leave the spares where they are, it shouldn't hurt */
 				mddev->recovery_running = 0;
 			} else {
-				if (mddev->spare)
-					mddev->pers->spare_write(mddev);
 				mddev->recovery_running = 1;
 				md_wakeup_thread(mddev->sync_thread);
 			}
@@ -3595,6 +3576,5 @@ EXPORT_SYMBOL(md_register_thread);
 EXPORT_SYMBOL(md_unregister_thread);
 EXPORT_SYMBOL(md_wakeup_thread);
 EXPORT_SYMBOL(md_print_devices);
-EXPORT_SYMBOL(find_rdev_nr);
 EXPORT_SYMBOL(md_interrupt_thread);
 MODULE_LICENSE("GPL");
--- ./drivers/md/raid5.c	2002/08/21 23:10:56	1.6
+++ ./drivers/md/raid5.c	2002/08/21 23:11:27	1.7
@@ -454,9 +454,11 @@ static int error(mddev_t *mddev, mdk_rde
 		if (disk->operational) {
 			disk->operational = 0;
 			mddev->sb_dirty = 1;
-			mddev->degraded++;
 			conf->working_disks--;
-			conf->failed_disks++;
+			if (!disk->write_only) {
+				mddev->degraded++;
+				conf->failed_disks++;
+			}
 			printk (KERN_ALERT
 				"raid5: Disk failure on %s, disabling device."
 				" Operation continuing on %d devices\n",
@@ -464,29 +466,6 @@ static int error(mddev_t *mddev, mdk_rde
 		}
 		return 0;
 	}
-	/*
-	 * handle errors in spares (during reconstruction)
-	 */
-	if (conf->spare) {
-		disk = conf->spare;
-		if (disk->rdev == rdev) {
-			printk (KERN_ALERT
-				"raid5: Disk failure on spare %s\n",
-				bdev_partition_name (rdev->bdev));
-			if (!conf->spare->operational) {
-				/* probably a SET_DISK_FAULTY ioctl */
-				return -EIO;
-			}
-			disk->operational = 0;
-			disk->write_only = 0;
-			conf->spare = NULL;
-
-			mddev->sb_dirty = 1;
-
-			return 0;
-		}
-	}
-	MD_BUG();
 	return -EIO;
 }	
 
@@ -891,7 +870,7 @@ static void handle_stripe(struct stripe_
 		if (dev->toread) to_read++;
 		if (dev->towrite) to_write++;
 		if (dev->written) written++;
-		if (!conf->disks[i].operational) {
+		if (!conf->disks[i].operational || conf->disks[i].write_only) {
 			failed++;
 			failed_num = i;
 		}
@@ -919,7 +898,7 @@ static void handle_stripe(struct stripe_
 				bi = nextbi;
 			}
 			/* fail any reads if this device is non-operational */
-			if (!conf->disks[i].operational) {
+			if (!conf->disks[i].operational || conf->disks[i].write_only) {
 				bi = sh->dev[i].toread;
 				sh->dev[i].toread = NULL;
 				if (bi) to_read--;
@@ -947,7 +926,7 @@ static void handle_stripe(struct stripe_
 	 */
 	dev = &sh->dev[sh->pd_idx];
 	if ( written &&
-	     ( (conf->disks[sh->pd_idx].operational && !test_bit(R5_LOCKED, &dev->flags) &&
+	     ( (conf->disks[sh->pd_idx].operational && !conf->disks[sh->pd_idx].write_only && !test_bit(R5_LOCKED, &dev->flags) &&
 		test_bit(R5_UPTODATE, &dev->flags))
 	       || (failed == 1 && failed_num == sh->pd_idx))
 	    ) {
@@ -955,7 +934,7 @@ static void handle_stripe(struct stripe_
 	    for (i=disks; i--; )
 		if (sh->dev[i].written) {
 		    dev = &sh->dev[i];
-		    if (!conf->disks[sh->pd_idx].operational ||
+		    if (!conf->disks[sh->pd_idx].operational || conf->disks[sh->pd_idx].write_only ||
 			(!test_bit(R5_LOCKED, &dev->flags) && test_bit(R5_UPTODATE, &dev->flags)) ) {
 			/* maybe we can return some write requests */
 			    struct bio *wbi, *wbi2;
@@ -989,7 +968,7 @@ static void handle_stripe(struct stripe_
 					PRINTK("Computing block %d\n", i);
 					compute_block(sh, i);
 					uptodate++;
-				} else if (conf->disks[i].operational) {
+				} else if (conf->disks[i].operational && !conf->disks[i].write_only) {
 					set_bit(R5_LOCKED, &dev->flags);
 					action[i] = READ+1;
 #if 0
@@ -1024,7 +1003,7 @@ static void handle_stripe(struct stripe_
 #endif
 				    ) &&
 			    !test_bit(R5_UPTODATE, &dev->flags)) {
-				if (conf->disks[i].operational 
+				if (conf->disks[i].operational  && !conf->disks[i].write_only
 /*				    && !(!mddev->insync && i == sh->pd_idx) */
 					)
 					rmw++;
@@ -1038,7 +1017,7 @@ static void handle_stripe(struct stripe_
 #endif
 				    ) &&
 			    !test_bit(R5_UPTODATE, &dev->flags)) {
-				if (conf->disks[i].operational) rcw++;
+				if (conf->disks[i].operational && !conf->disks[i].write_only) rcw++;
 				else rcw += 2*disks;
 			}
 		}
@@ -1050,7 +1029,7 @@ static void handle_stripe(struct stripe_
 				dev = &sh->dev[i];
 				if ((dev->towrite || i == sh->pd_idx) &&
 				    !test_bit(R5_LOCKED, &dev->flags) && !test_bit(R5_UPTODATE, &dev->flags) &&
-				    conf->disks[i].operational) {
+				    conf->disks[i].operational && !conf->disks[i].write_only) {
 					if (test_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
 					{
 						PRINTK("Read_old block %d for r-m-w\n", i);
@@ -1069,7 +1048,7 @@ static void handle_stripe(struct stripe_
 				dev = &sh->dev[i];
 				if (!test_bit(R5_OVERWRITE, &dev->flags) && i != sh->pd_idx &&
 				    !test_bit(R5_LOCKED, &dev->flags) && !test_bit(R5_UPTODATE, &dev->flags) &&
-				    conf->disks[i].operational) {
+				    conf->disks[i].operational && !conf->disks[i].write_only) {
 					if (test_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
 					{
 						PRINTK("Read_old block %d for Reconstruct\n", i);
@@ -1092,7 +1071,7 @@ static void handle_stripe(struct stripe_
 					PRINTK("Writing block %d\n", i);
 					locked++;
 					action[i] = WRITE+1;
-					if (!conf->disks[i].operational
+					if (!conf->disks[i].operational || conf->disks[i].write_only
 					    || (i==sh->pd_idx && failed == 0))
 						set_bit(STRIPE_INSYNC, &sh->state);
 				}
@@ -1125,7 +1104,6 @@ static void handle_stripe(struct stripe_
 			}
 		}
 		if (!test_bit(STRIPE_INSYNC, &sh->state)) {
-			struct disk_info *spare;
 			if (failed==0)
 				failed_num = sh->pd_idx;
 			/* should be able to compute the missing block and write it to spare */
@@ -1144,9 +1122,6 @@ static void handle_stripe(struct stripe_
 			set_bit(STRIPE_INSYNC, &sh->state);
 			if (conf->disks[failed_num].operational)
 				md_sync_acct(conf->disks[failed_num].rdev, STRIPE_SECTORS);
-			else if ((spare=conf->spare))
-				md_sync_acct(spare->rdev, STRIPE_SECTORS);
-
 		}
 	}
 	if (syncing && locked == 0 && test_bit(STRIPE_INSYNC, &sh->state)) {
@@ -1174,8 +1149,6 @@ static void handle_stripe(struct stripe_
 			spin_lock_irq(&conf->device_lock);
 			if (conf->disks[i].operational)
 				rdev = conf->disks[i].rdev;
-			else if (conf->spare && action[i] == WRITE+1)
-				rdev = conf->spare->rdev;
 			else skip=1;
 			if (rdev)
 				atomic_inc(&rdev->nr_pending);
@@ -1372,7 +1345,7 @@ static void raid5d (void *data)
 static int run (mddev_t *mddev)
 {
 	raid5_conf_t *conf;
-	int i, raid_disk, memory;
+	int raid_disk, memory;
 	mdk_rdev_t *rdev;
 	struct disk_info *disk;
 	struct list_head *tmp;
@@ -1408,54 +1381,25 @@ static int run (mddev_t *mddev)
 	PRINTK("raid5: run(md%d) called.\n", mdidx(mddev));
 
 	ITERATE_RDEV(mddev,rdev,tmp) {
-		/*
-		 * This is important -- we are using the descriptor on
-		 * the disk only to get a pointer to the descriptor on
-		 * the main superblock, which might be more recent.
-		 */
 		raid_disk = rdev->raid_disk;
+		if (raid_disk > mddev->raid_disks
+		    || raid_disk < 0)
+			continue;
 		disk = conf->disks + raid_disk;
 
-		if (rdev->faulty) {
-			printk(KERN_ERR "raid5: disabled device %s (errors detected)\n", bdev_partition_name(rdev->bdev));
-			disk->rdev = rdev;
+		disk->rdev = rdev;
 
+		if (rdev->faulty)
 			disk->operational = 0;
-			disk->write_only = 0;
-			disk->spare = 0;
-			continue;
-		}
-		if (rdev->in_sync) {
-			if (disk->operational) {
-				printk(KERN_ERR "raid5: disabled device %s (device %d already operational)\n", bdev_partition_name(rdev->bdev), raid_disk);
-				continue;
-			}
+		else if (rdev->in_sync) {
 			printk(KERN_INFO "raid5: device %s operational as raid disk %d\n", bdev_partition_name(rdev->bdev), raid_disk);
 	
-			disk->rdev = rdev;
 			disk->operational = 1;
-
+			disk->write_only = 0;
 			conf->working_disks++;
 		} else {
-			/*
-			 * Must be a spare disk ..
-			 */
-			printk(KERN_INFO "raid5: spare disk %s\n", bdev_partition_name(rdev->bdev));
-			disk->rdev = rdev;
-
-			disk->operational = 0;
-			disk->write_only = 0;
-			disk->spare = 1;
-		}
-	}
-
-	for (i = 0; i < conf->raid_disks; i++) {
-		disk = conf->disks + i;
-
-		if (!disk->rdev) {
-			disk->operational = 0;
-			disk->write_only = 0;
-			disk->spare = 0;
+			disk->operational = 1;
+			disk->write_only = 1;
 		}
 	}
 
@@ -1614,146 +1558,37 @@ static void print_raid5_conf (raid5_conf
 	printk(" --- rd:%d wd:%d fd:%d\n", conf->raid_disks,
 		 conf->working_disks, conf->failed_disks);
 
-#if RAID5_DEBUG
-	for (i = 0; i < MD_SB_DISKS; i++) {
-#else
-	for (i = 0; i < conf->working_disks+conf->failed_disks; i++) {
-#endif
+	for (i = 0; i < conf->raid_disks; i++) {
 		tmp = conf->disks + i;
 		if (tmp->rdev)
-		printk(" disk %d, s:%d, o:%d, dev:%s\n",
-			i, tmp->spare,tmp->operational,
+		printk(" disk %d, o:%d, dev:%s\n",
+			i, tmp->operational,
 			bdev_partition_name(tmp->rdev->bdev));
 	}
 }
 
 static int raid5_spare_active(mddev_t *mddev)
 {
-	int err = 0;
-	int i, failed_disk=-1, spare_disk=-1;
+	int i;
 	raid5_conf_t *conf = mddev->private;
-	struct disk_info *tmp, *sdisk, *fdisk;
-	mdk_rdev_t *spare_rdev, *failed_rdev;
+	struct disk_info *tmp;
 
-	print_raid5_conf(conf);
 	spin_lock_irq(&conf->device_lock);
 	for (i = 0; i < conf->raid_disks; i++) {
 		tmp = conf->disks + i;
-		if ((!tmp->operational && !tmp->spare) ||
-				!tmp->rdev) {
-			failed_disk = i;
-			break;
+		if (tmp->operational && tmp->rdev
+		    && !tmp->rdev->faulty
+		    && tmp->write_only) {
+			tmp->write_only = 0;
+			mddev->degraded--;
+			conf->failed_disks--;
+			conf->working_disks++;
+			tmp->rdev->in_sync = 1;
 		}
 	}
-	if (failed_disk == -1) {
-		MD_BUG();
-		err = 1;
-		goto abort;
-	}
-	/*
-	 * Find the spare disk ... (can only be in the 'high'
-	 * area of the array)
-	 */
-	spare_disk = mddev->spare->raid_disk;
-
-	if (!conf->spare) {
-		MD_BUG();
-		err = 1;
-		goto abort;
-	}
-	sdisk = conf->disks + spare_disk;
-	fdisk = conf->disks + failed_disk;
-
-	/*
-	 * do the switch finally
-	 */
-	spare_rdev = find_rdev_nr(mddev, spare_disk);
-	failed_rdev = find_rdev_nr(mddev, failed_disk);
-
-	/* There must be a spare_rdev, but there may not be a
-	 * failed_rdev.  That slot might be empty...
-	 */
-	spare_rdev->desc_nr = failed_disk;
-	spare_rdev->raid_disk = failed_disk;
-	if (failed_rdev) {
-		failed_rdev->desc_nr = spare_disk;
-		failed_rdev->raid_disk = spare_disk;
-	}
-	
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
-	/*
-	 * this really activates the spare.
-	 */
-	fdisk->spare = 0;
-	fdisk->write_only = 0;
-
-	/*
-	 * if we activate a spare, we definitely replace a
-	 * non-operational disk slot in the 'low' area of
-	 * the disk array.
-	 */
-	mddev->degraded--;
-	conf->failed_disks--;
-	conf->working_disks++;
-	conf->spare = NULL;
-abort:
-	spin_unlock_irq(&conf->device_lock);
-	print_raid5_conf(conf);
-	return err;
-}
-
-static int raid5_spare_inactive(mddev_t *mddev)
-{
-	raid5_conf_t *conf = mddev->private;
-	struct disk_info *p;
-	int err = 0;
-
-	print_raid5_conf(conf);
-	spin_lock_irq(&conf->device_lock);
-	p = conf->disks + mddev->spare->raid_disk;
-	if (p) {
-		p->operational = 0;
-		p->write_only = 0;
-		if (conf->spare == p)
-			conf->spare = NULL;
-	} else {
-		MD_BUG();
-		err = 1;
-	}
 	spin_unlock_irq(&conf->device_lock);
 	print_raid5_conf(conf);
-	return err;
-}
-
-static int raid5_spare_write(mddev_t *mddev)
-{
-	raid5_conf_t *conf = mddev->private;
-	struct disk_info *p;
-	int err = 0;
-
-	print_raid5_conf(conf);
-	spin_lock_irq(&conf->device_lock);
-	p = conf->disks + mddev->spare->raid_disk;
-	if (p && !conf->spare) {
-		p->operational = 1;
-		p->write_only = 1;
-		conf->spare = p;
-	} else {
-		MD_BUG();
-		err = 1;
-	}
-	spin_unlock_irq(&conf->device_lock);
-	print_raid5_conf(conf);
-	return err;
+	return 0;
 }
 
 static int raid5_remove_disk(mddev_t *mddev, int number)
@@ -1785,28 +1620,26 @@ abort:
 static int raid5_add_disk(mddev_t *mddev, mdk_rdev_t *rdev)
 {
 	raid5_conf_t *conf = mddev->private;
-	int err = 1;
-	struct disk_info *p = conf->disks + rdev->raid_disk;
+	int found = 0;
+	int disk;
+	struct disk_info *p;
 
-	print_raid5_conf(conf);
 	spin_lock_irq(&conf->device_lock);
 	/*
 	 * find the disk ...
 	 */
-
-	if (!p->rdev) {
-		/* it will be held open by rdev */
-		p->rdev = rdev;
-		p->operational = 0;
-		p->write_only = 0;
-		p->spare = 1;
-		err = 0;
-	}
-	if (err)
-		MD_BUG();
+	for (disk=0; disk < mddev->raid_disks; disk++)
+		if ((p=conf->disks + disk)->rdev == NULL) {
+			p->rdev = rdev;
+			p->operational = 1;
+			p->write_only = 1;
+			rdev->raid_disk = disk;
+			found = 1;
+			break;
+		}
 	spin_unlock_irq(&conf->device_lock);
 	print_raid5_conf(conf);
-	return err;
+	return found;
 }
 
 static mdk_personality_t raid5_personality=
@@ -1819,8 +1652,6 @@ static mdk_personality_t raid5_personali
 	.error_handler	= error,
 	.hot_add_disk	= raid5_add_disk,
 	.hot_remove_disk= raid5_remove_disk,
-	.spare_write	= raid5_spare_write,
-	.spare_inactive	= raid5_spare_inactive,
 	.spare_active	= raid5_spare_active,
 	.sync_request	= sync_request,
 };
--- ./drivers/md/raid1.c	2002/08/21 23:10:56	1.5
+++ ./drivers/md/raid1.c	2002/08/21 23:11:27	1.6
@@ -135,7 +135,7 @@ static void put_all_bios(conf_t *conf, r
 		bio_put(r1_bio->read_bio);
 		r1_bio->read_bio = NULL;
 	}
-	for (i = 0; i < MD_SB_DISKS; i++) {
+	for (i = 0; i < conf->raid_disks; i++) {
 		struct bio **bio = r1_bio->write_bios + i;
 		if (*bio) {
 			if (atomic_read(&(*bio)->bi_cnt) != 1)
@@ -191,7 +191,7 @@ static inline void put_buf(r1bio_t *r1_b
 static int map(mddev_t *mddev, mdk_rdev_t **rdev)
 {
 	conf_t *conf = mddev_to_conf(mddev);
-	int i, disks = MD_SB_DISKS;
+	int i, disks = conf->raid_disks;
 
 	/*
 	 * Later we do read balancing on the read side
@@ -200,8 +200,9 @@ static int map(mddev_t *mddev, mdk_rdev_
 
 	spin_lock_irq(&conf->device_lock);
 	for (i = 0; i < disks; i++) {
-		if (conf->mirrors[i].operational &&
-			conf->mirrors[i].rdev) {
+		if (conf->mirrors[i].operational
+		    && !conf->mirrors[i].write_only
+		    && conf->mirrors[i].rdev) {
 			*rdev = conf->mirrors[i].rdev;
 			atomic_inc(&(*rdev)->nr_pending);
 			spin_unlock_irq(&conf->device_lock);
@@ -261,7 +262,7 @@ static void end_request(struct bio *bio)
 	if (r1_bio->cmd == READ || r1_bio->cmd == READA)
 		mirror = r1_bio->read_disk;
 	else {
-		for (mirror = 0; mirror < MD_SB_DISKS; mirror++)
+		for (mirror = 0; mirror < conf->raid_disks; mirror++)
 			if (r1_bio->write_bios[mirror] == bio)
 				break;
 	}
@@ -357,7 +358,7 @@ static int read_balance(conf_t *conf, st
 
 
 	/* make sure the disk is operational */
-	while (!conf->mirrors[new_disk].operational) {
+	while (!conf->mirrors[new_disk].operational || conf->mirrors[new_disk].write_only) {
 		if (new_disk <= 0)
 			new_disk = conf->raid_disks;
 		new_disk--;
@@ -386,8 +387,8 @@ static int read_balance(conf_t *conf, st
 			disk = conf->raid_disks;
 		disk--;
 
-		if ((conf->mirrors[disk].write_only) ||
-				(!conf->mirrors[disk].operational))
+		if (conf->mirrors[disk].write_only ||
+		    !conf->mirrors[disk].operational)
 			continue;
 
 		if (!atomic_read(&conf->mirrors[disk].rdev->nr_pending)) {
@@ -453,7 +454,7 @@ static int make_request(request_queue_t 
 	mirror_info_t *mirror;
 	r1bio_t *r1_bio;
 	struct bio *read_bio;
-	int i, sum_bios = 0, disks = MD_SB_DISKS;
+	int i, sum_bios = 0, disks = conf->raid_disks;
 
 	/*
 	 * Register the new request and wait if the reconstruction
@@ -552,7 +553,7 @@ static int make_request(request_queue_t 
 	 * do end_request by hand if all requests finish until we had a
 	 * chance to set up the semaphore correctly ... lots of races).
 	 */
-	for (i = 0; i < disks; i++) {
+	for (i=disks; i--; ) {
 		struct bio *mbio;
 		mbio = r1_bio->write_bios[i];
 		if (!mbio)
@@ -611,7 +612,7 @@ static int error(mddev_t *mddev, mdk_rde
 {
 	conf_t *conf = mddev_to_conf(mddev);
 	mirror_info_t * mirrors = conf->mirrors;
-	int disks = MD_SB_DISKS;
+	int disks = conf->raid_disks;
 	int i;
 
 	/*
@@ -627,7 +628,8 @@ static int error(mddev_t *mddev, mdk_rde
 	if (i == disks)
 		return 0;
 
-	if (i < conf->raid_disks && conf->working_disks == 1)
+	if (mirrors[i].operational && !mirrors[i].write_only
+	    && conf->working_disks == 1)
 		/*
 		 * Don't fail the drive, act as though we were just a
 		 * normal single drive
@@ -650,11 +652,11 @@ static void print_conf(conf_t *conf)
 	printk(" --- wd:%d rd:%d\n", conf->working_disks,
 			conf->raid_disks);
 
-	for (i = 0; i < MD_SB_DISKS; i++) {
+	for (i = 0; i < conf->raid_disks; i++) {
 		tmp = conf->mirrors + i;
 		if (tmp->rdev)
-			printk(" disk %d, s:%d, o:%d, dev:%s\n",
-			       i, tmp->spare, tmp->operational,
+			printk(" disk %d, wo:%d, o:%d, dev:%s\n",
+			       i, tmp->write_only, tmp->operational,
 			       bdev_partition_name(tmp->rdev->bdev));
 	}
 }
@@ -675,156 +677,55 @@ static void close_sync(conf_t *conf)
 
 static int raid1_spare_active(mddev_t *mddev)
 {
-	int err = 0;
-	int i, failed_disk = -1, spare_disk = -1;
+	int i;
 	conf_t *conf = mddev->private;
-	mirror_info_t *tmp, *sdisk, *fdisk;
-	mdk_rdev_t *spare_rdev, *failed_rdev;
+	mirror_info_t *tmp;
 
-	print_conf(conf);
 	spin_lock_irq(&conf->device_lock);
 	/*
-	 * Find the failed disk within the RAID1 configuration ...
-	 * (this can only be in the first conf->working_disks part)
+	 * Find all failed disks within the RAID1 configuration 
+	 * and mark them readable
 	 */
 	for (i = 0; i < conf->raid_disks; i++) {
 		tmp = conf->mirrors + i;
-		if ((!tmp->operational && !tmp->spare) ||
-				!tmp->rdev) {
-			failed_disk = i;
-			break;
+		if (tmp->operational && tmp->rdev 
+		    && !tmp->rdev->faulty
+		    && tmp->write_only) {
+			conf->working_disks++;
+			mddev->degraded--;
+			tmp->write_only = 0;
+			tmp->rdev->in_sync = 1;
 		}
 	}
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
-	spare_disk = mddev->spare->raid_disk;
-
-	sdisk = conf->mirrors + spare_disk;
-	fdisk = conf->mirrors + failed_disk;
-
-	/*
-	 * do the switch finally
-	 */
-	spare_rdev = find_rdev_nr(mddev, spare_disk);
-	failed_rdev = find_rdev_nr(mddev, failed_disk);
-
-	/*
-	 * There must be a spare_rdev, but there may not be a
-	 * failed_rdev. That slot might be empty...
-	 */
-	spare_rdev->desc_nr = failed_disk;
-	spare_rdev->raid_disk = failed_disk;
-	if (failed_rdev) {
-		failed_rdev->desc_nr = spare_disk;
-		failed_rdev->raid_disk = spare_disk;
-	}
-
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
-	/*
-	 * this really activates the spare.
-	 */
-	fdisk->spare = 0;
-	fdisk->write_only = 0;
-
-	/*
-	 * if we activate a spare, we definitely replace a
-	 * non-operational disk slot in the 'low' area of
-	 * the disk array.
-	 */
-
-	conf->working_disks++;
-	mddev->degraded--;
-abort:
 	spin_unlock_irq(&conf->device_lock);
 
 	print_conf(conf);
-	return err;
-}
-
-static int raid1_spare_inactive(mddev_t *mddev)
-{
-	conf_t *conf = mddev->private;
-	mirror_info_t *p;
-	int err = 0;
-
-	print_conf(conf);
-	spin_lock_irq(&conf->device_lock);
-	p = conf->mirrors + mddev->spare->raid_disk;
-	if (p) {
-		p->operational = 0;
-		p->write_only = 0;
-	} else {
-		MD_BUG();
-		err = 1;
-	}
-	spin_unlock_irq(&conf->device_lock);
-	print_conf(conf);
-	return err;
+	return 0;
 }
 
-static int raid1_spare_write(mddev_t *mddev)
-{
-	conf_t *conf = mddev->private;
-	mirror_info_t *p;
-	int err = 0;
-
-	print_conf(conf);
-	spin_lock_irq(&conf->device_lock);
-	p = conf->mirrors + mddev->spare->raid_disk;
-	if (p) {
-		p->operational = 1;
-		p->write_only = 1;
-	} else {
-		MD_BUG();
-		err = 1;
-	}
-	spin_unlock_irq(&conf->device_lock);
-	print_conf(conf);
-	return err;
-}
 
 static int raid1_add_disk(mddev_t *mddev, mdk_rdev_t *rdev)
 {
 	conf_t *conf = mddev->private;
-	int err = 1;
-	mirror_info_t *p = conf->mirrors + rdev->raid_disk;
+	int found = 0;
+	int mirror;
+	mirror_info_t *p;
 
-	print_conf(conf);
 	spin_lock_irq(&conf->device_lock);
-	if (!p->rdev) {
-		p->rdev = rdev;
-		p->operational = 0;
-		p->write_only = 0;
-		p->spare = 1;
-		p->head_position = 0;
-		err = 0;
-	}
-	if (err)
-		MD_BUG();
+	for (mirror=0; mirror < mddev->raid_disks; mirror++)
+		if ( !(p=conf->mirrors+mirror)->rdev) {
+			p->rdev = rdev;
+			p->write_only = 1;
+			p->operational = 1;
+			p->head_position = 0;
+			rdev->raid_disk = mirror;
+			found = 1;
+			break;
+		}
 	spin_unlock_irq(&conf->device_lock);
 
 	print_conf(conf);
-	return err;
+	return found;
 }
 
 static int raid1_remove_disk(mddev_t *mddev, int number)
@@ -891,7 +792,7 @@ static void end_sync_write(struct bio *b
 	int i;
 	int mirror=0;
 
-	for (i = 0; i < MD_SB_DISKS; i++)
+	for (i = 0; i < conf->raid_disks; i++)
 		if (r1_bio->write_bios[i] == bio) {
 			mirror = i;
 			break;
@@ -912,7 +813,7 @@ static void sync_request_write(mddev_t *
 {
 	conf_t *conf = mddev_to_conf(mddev);
 	int i, sum_bios = 0;
-	int disks = MD_SB_DISKS;
+	int disks = conf->raid_disks;
 	struct bio *bio, *mbio;
 
 	bio = r1_bio->master_bio;
@@ -943,7 +844,7 @@ static void sync_request_write(mddev_t *
 			 * we read from here, no need to write
 			 */
 			continue;
-		if (i < conf->raid_disks && mddev->in_sync)
+		if (!conf->mirrors[i].write_only && mddev->in_sync)
 			/*
 			 * don't need to write this we are just rebuilding
 			 */
@@ -1109,6 +1010,7 @@ static int sync_request(mddev_t *mddev, 
 	/* make sure disk is operational */
 	spin_lock_irq(&conf->device_lock);
 	while (!conf->mirrors[disk].operational ||
+	       conf->mirrors[disk].write_only ||
 		!conf->mirrors[disk].rdev) {
 		if (disk <= 0)
 			disk = conf->raid_disks;
@@ -1238,58 +1140,20 @@ static int run(mddev_t *mddev)
 		goto out;
 	}
 
-//	for (tmp = (mddev)->disks.next; rdev = ((mdk_rdev_t *)((char *)(tmp)-(unsigned long)(&((mdk_rdev_t *)0)->same_set))), tmp = tmp->next, tmp->prev != &(mddev)->disks ; ) {
 
 	ITERATE_RDEV(mddev, rdev, tmp) {
-		if (rdev->faulty) {
-			printk(ERRORS, bdev_partition_name(rdev->bdev));
-		} else {
-			if (!rdev->sb) {
-				MD_BUG();
-				continue;
-			}
-		}
-		if (rdev->desc_nr == -1) {
-			MD_BUG();
-			continue;
-		}
 		disk_idx = rdev->raid_disk;
+		if (disk_idx >= mddev->raid_disks
+		    || disk_idx < 0)
+			continue;
 		disk = conf->mirrors + disk_idx;
 
-		if (rdev->faulty) {
-			disk->rdev = rdev;
-			disk->operational = 0;
-			disk->write_only = 0;
-			disk->spare = 0;
-			disk->head_position = 0;
-			continue;
-		}
-		if (rdev->in_sync) {
-			if (disk->operational) {
-				printk(ALREADY_RUNNING,
-					bdev_partition_name(rdev->bdev),
-					disk_idx);
-				continue;
-			}
-			printk(OPERATIONAL, bdev_partition_name(rdev->bdev),
-					disk_idx);
-			disk->rdev = rdev;
-			disk->operational = 1;
-			disk->write_only = 0;
-			disk->spare = 0;
-			disk->head_position = 0;
+		disk->rdev = rdev;
+		disk->operational = ! rdev->faulty;
+		disk->write_only = ! rdev->in_sync;
+		disk->head_position = 0;
+		if (!rdev->faulty && rdev->in_sync)
 			conf->working_disks++;
-		} else {
-		/*
-		 * Must be a spare disk ..
-		 */
-			printk(SPARE, bdev_partition_name(rdev->bdev));
-			disk->rdev = rdev;
-			disk->operational = 0;
-			disk->write_only = 0;
-			disk->spare = 1;
-			disk->head_position = 0;
-		}
 	}
 	conf->raid_disks = mddev->raid_disks;
 	conf->mddev = mddev;
@@ -1312,7 +1176,6 @@ static int run(mddev_t *mddev)
 		if (!disk->rdev) {
 			disk->operational = 0;
 			disk->write_only = 0;
-			disk->spare = 0;
 			disk->head_position = 0;
 			mddev->degraded++;
 		}
@@ -1322,7 +1185,9 @@ static int run(mddev_t *mddev)
 	 * find the first working one and use it as a starting point
 	 * to read balancing.
 	 */
-	for (j = 0; !conf->mirrors[j].operational && j < MD_SB_DISKS; j++)
+	for (j = 0; j < conf->raid_disks &&
+		     (!conf->mirrors[j].operational ||
+		      conf->mirrors[j].write_only) ; j++)
 		/* nothing */;
 	conf->last_used = j;
 
@@ -1377,8 +1242,6 @@ static mdk_personality_t raid1_personali
 	.error_handler	= error,
 	.hot_add_disk	= raid1_add_disk,
 	.hot_remove_disk= raid1_remove_disk,
-	.spare_write	= raid1_spare_write,
-	.spare_inactive	= raid1_spare_inactive,
 	.spare_active	= raid1_spare_active,
 	.sync_request	= sync_request,
 };
--- ./drivers/md/multipath.c	2002/08/21 23:10:56	1.5
+++ ./drivers/md/multipath.c	2002/08/21 23:11:27	1.6
@@ -299,23 +299,24 @@ static void print_multipath_conf (multip
 static int multipath_add_disk(mddev_t *mddev, mdk_rdev_t *rdev)
 {
 	multipath_conf_t *conf = mddev->private;
-	int err = 1;
-	struct multipath_info *p = conf->multipaths + rdev->raid_disk;
+	int found = 0;
+	int path;
+	struct multipath_info *p;
 
 	print_multipath_conf(conf);
 	spin_lock_irq(&conf->device_lock);
-	if (!p->rdev) {
-		p->rdev = rdev;
-		p->operational = 1;
-		conf->working_disks++;
-		err = 0;
-	}
-	if (err)
-		MD_BUG();
+	for (path=0; path<mddev->raid_disks; path++) 
+		if ((p=conf->multipaths+path)->rdev == NULL) {
+			p->rdev = rdev;
+			p->operational = 1;
+			conf->working_disks++;
+			rdev->raid_disk = path;
+			found = 1;
+		}
 	spin_unlock_irq(&conf->device_lock);
 
 	print_multipath_conf(conf);
-	return err;
+	return found;
 }
 
 static int multipath_remove_disk(mddev_t *mddev, int number)
@@ -443,7 +444,6 @@ static int multipath_run (mddev_t *mddev
 	struct multipath_info *disk;
 	mdk_rdev_t *rdev;
 	struct list_head *tmp;
-	int num_rdevs = 0;
 
 	MOD_INC_USE_COUNT;
 
@@ -465,39 +465,30 @@ static int multipath_run (mddev_t *mddev
 	}
 	memset(conf, 0, sizeof(*conf));
 
+	conf->working_disks = 0;
 	ITERATE_RDEV(mddev,rdev,tmp) {
-		if (rdev->faulty) {
-			/* this is a "should never happen" case and if it */
-			/* ever does happen, a continue; won't help */
-			printk(ERRORS, bdev_partition_name(rdev->bdev));
-			continue;
-		} else {
-			/* this is a "should never happen" case and if it */
-			/* ever does happen, a continue; won't help */
-			if (!rdev->sb) {
-				MD_BUG();
-				continue;
-			}
-		}
-		if (rdev->desc_nr == -1) {
-			MD_BUG();
+		disk_idx = rdev->raid_disk;
+		if (disk_idx < 0 ||
+		    disk_idx >= mddev->raid_disks)
 			continue;
-		}
 
-		disk_idx = rdev->raid_disk;
 		disk = conf->multipaths + disk_idx;
-
-		/*
-		 * Mark all disks as active to start with, there are no
-		 * spares.  multipath_read_balance deals with choose
-		 * the "best" operational device.
-		 */
 		disk->rdev = rdev;
-		disk->operational = 1;
-		num_rdevs++;
+		if (rdev->faulty) 
+			disk->operational = 0;
+		else {
+
+			/*
+			 * Mark all disks as active to start with, there are no
+			 * spares.  multipath_read_balance deals with choose
+			 * the "best" operational device.
+			 */
+			disk->operational = 1;
+			conf->working_disks++;
+		}
 	}
 
-	conf->raid_disks = mddev->raid_disks = num_rdevs;
+	conf->raid_disks = mddev->raid_disks;
 	mddev->sb_dirty = 1;
 	conf->mddev = mddev;
 	conf->device_lock = SPIN_LOCK_UNLOCKED;
@@ -506,6 +497,7 @@ static int multipath_run (mddev_t *mddev
 		printk(NONE_OPERATIONAL, mdidx(mddev));
 		goto out_free_conf;
 	}
+	mddev->degraded = conf->raid_disks = conf->working_disks;
 
 	conf->pool = mempool_create(NR_RESERVED_BUFS,
 				    mp_pool_alloc, mp_pool_free,
