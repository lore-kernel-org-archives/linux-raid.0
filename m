From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 10 of 13 - Remove per-personality 'operational' and 'write_only' flags
Date: Thu, 22 Aug 2002 10:34:20 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E17hfvY-00050Z-00@notabene.cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


### Comments for ChangeSet

raid1, raid5 and multipath maintain their own
'operational' flag.  This is equivalent to
   !rdev->faulty
and so isn't needed.
Similarly raid1 and raid1 maintain a "write_only" flag
that is equivalnt to
   !rdev->in_sync
so it isn't needed either.

As part of implementing this change, we introduce some extra
flag bit in raid5 that are meaningful only inside 'handle_stripe'.
Some of these replace the "action" array which recorded what
actions were required (and would be performed after the stripe
spinlock was released).  This has the advantage of reducing our
dependance on MD_SB_DISKS which personalities shouldn't need
to know about.




 ----------- Diffstat output ------------
 ./drivers/md/md.c                |   39 +++--------
 ./drivers/md/multipath.c         |   75 ++++++---------------
 ./drivers/md/raid1.c             |  106 ++++++++++++------------------
 ./drivers/md/raid5.c             |  134 ++++++++++++++++++---------------------
 ./include/linux/raid/md.h        |    3 
 ./include/linux/raid/md_k.h      |   15 ++++
 ./include/linux/raid/multipath.h |    5 -
 ./include/linux/raid/raid1.h     |    6 -
 ./include/linux/raid/raid5.h     |    7 +-
 9 files changed, 165 insertions(+), 225 deletions(-)

--- ./include/linux/raid/md.h	2002/08/21 23:08:55	1.2
+++ ./include/linux/raid/md.h	2002/08/21 23:14:39	1.3
@@ -77,8 +77,7 @@ extern void md_wakeup_thread(mdk_thread_
 extern void md_interrupt_thread (mdk_thread_t *thread);
 extern void md_done_sync(mddev_t *mddev, int blocks, int ok);
 extern void md_sync_acct(mdk_rdev_t *rdev, unsigned long nr_sectors);
-extern int md_error (mddev_t *mddev, mdk_rdev_t *rdev);
-extern int md_run_setup(void);
+extern void md_error (mddev_t *mddev, mdk_rdev_t *rdev);
 
 extern void md_print_devices (void);
 
--- ./include/linux/raid/raid1.h	2002/08/21 23:11:27	1.5
+++ ./include/linux/raid/raid1.h	2002/08/21 23:14:39	1.6
@@ -8,12 +8,6 @@ typedef struct mirror_info mirror_info_t
 struct mirror_info {
 	mdk_rdev_t	*rdev;
 	sector_t	head_position;
-
-	/*
-	 * State bits:
-	 */
-	int		operational;
-	int		write_only;
 };
 
 typedef struct r1bio_s r1bio_t;
--- ./include/linux/raid/raid5.h	2002/08/21 23:11:27	1.4
+++ ./include/linux/raid/raid5.h	2002/08/21 23:14:39	1.5
@@ -148,6 +148,11 @@ struct stripe_head {
 #define	R5_UPTODATE	0	/* page contains current data */
 #define	R5_LOCKED	1	/* IO has been submitted on "req" */
 #define	R5_OVERWRITE	2	/* towrite covers whole page */
+/* and some that are internal to handle_stripe */
+#define	R5_Insync	3	/* rdev && rdev->in_sync at start */
+#define	R5_Wantread	4	/* want to schedule a read */
+#define	R5_Wantwrite	5
+#define	R5_Syncio	6	/* this io need to be accounted as resync io */
 
 /*
  * Write method
@@ -193,8 +198,6 @@ struct stripe_head {
 
 struct disk_info {
 	mdk_rdev_t	*rdev;
-	int		operational;
-	int		write_only;
 };
 
 struct raid5_private_data {
--- ./include/linux/raid/md_k.h	2002/08/21 23:12:58	1.5
+++ ./include/linux/raid/md_k.h	2002/08/21 23:14:39	1.6
@@ -154,6 +154,16 @@ struct mdk_rdev_s
 	mdp_super_t	*sb;
 	unsigned long	sb_offset;
 
+	/* A device can be in one of three states based on two flags:
+	 * Not working:   faulty==1 in_sync==0
+	 * Fully working: faulty==0 in_sync==1
+	 * Working, but not
+	 * in sync with array
+	 *                faulty==0 in_sync==0
+	 *
+	 * It can never have faulty==1, in_sync==1
+	 * This reduces the burden of testing multiple flags in many cases
+	 */
 	int faulty;			/* if faulty do not issue IO requests */
 	int in_sync;			/* device is a full member of the array */
 
@@ -227,7 +237,10 @@ struct mdk_personality_s
 	int (*run)(mddev_t *mddev);
 	int (*stop)(mddev_t *mddev);
 	int (*status)(char *page, mddev_t *mddev);
-	int (*error_handler)(mddev_t *mddev, mdk_rdev_t *rdev);
+	/* error_handler must set ->faulty and clear ->in_sync
+	 * if appropriate, and should abort recovery if needed 
+	 */
+	void (*error_handler)(mddev_t *mddev, mdk_rdev_t *rdev);
 	int (*hot_add_disk) (mddev_t *mddev, mdk_rdev_t *rdev);
 	int (*hot_remove_disk) (mddev_t *mddev, int number);
 	int (*spare_active) (mddev_t *mddev);
--- ./include/linux/raid/multipath.h	2002/08/21 23:10:56	1.3
+++ ./include/linux/raid/multipath.h	2002/08/21 23:14:39	1.4
@@ -6,11 +6,6 @@
 
 struct multipath_info {
 	mdk_rdev_t	*rdev;
-
-	/*
-	 * State bits:
-	 */
-	int		operational;
 };
 
 struct multipath_private_data {
--- ./drivers/md/md.c	2002/08/21 23:12:58	1.9
+++ ./drivers/md/md.c	2002/08/21 23:14:39	1.10
@@ -365,9 +365,6 @@ static void free_disk_sb(mdk_rdev_t * rd
 		rdev->sb_page = NULL;
 		rdev->sb_offset = 0;
 		rdev->size = 0;
-	} else {
-		if (!rdev->faulty)
-			MD_BUG();
 	}
 }
 
@@ -586,7 +583,6 @@ static void export_rdev(mdk_rdev_t * rde
 	md_autodetect_dev(rdev->bdev->bd_dev);
 #endif
 	unlock_rdev(rdev);
-	rdev->faulty = 0;
 	kfree(rdev);
 }
 
@@ -671,9 +667,9 @@ static void print_sb(mdp_super_t *sb)
 
 static void print_rdev(mdk_rdev_t *rdev)
 {
-	printk(KERN_INFO "md: rdev %s, SZ:%08ld F:%d DN:%d ",
+	printk(KERN_INFO "md: rdev %s, SZ:%08ld F:%d S:%d DN:%d ",
 		bdev_partition_name(rdev->bdev),
-		rdev->size, rdev->faulty, rdev->desc_nr);
+		rdev->size, rdev->faulty, rdev->in_sync, rdev->desc_nr);
 	if (rdev->sb) {
 		printk(KERN_INFO "md: rdev superblock:\n");
 		print_sb(rdev->sb);
@@ -1006,6 +1002,7 @@ static mdk_rdev_t *md_import_device(dev_
 	}
 	rdev->desc_nr = -1;
 	rdev->faulty = 0;
+	rdev->in_sync = 0;
 	atomic_set(&rdev->nr_pending, 0);
 
 	size = rdev->bdev->bd_inode->i_size >> BLOCK_SIZE_BITS;
@@ -2182,14 +2179,13 @@ static int set_array_info(mddev_t * mdde
 static int set_disk_faulty(mddev_t *mddev, dev_t dev)
 {
 	mdk_rdev_t *rdev;
-	int ret;
 
 	rdev = find_rdev(mddev, dev);
 	if (!rdev)
 		return 0;
 
-	ret = md_error(mddev, rdev);
-	return ret;
+	md_error(mddev, rdev);
+	return 1;
 }
 
 static int md_ioctl(struct inode *inode, struct file *file,
@@ -2604,9 +2600,8 @@ static void md_recover_arrays(void)
 }
 
 
-int md_error(mddev_t *mddev, mdk_rdev_t *rdev)
+void md_error(mddev_t *mddev, mdk_rdev_t *rdev)
 {
-
 	dprintk("md_error dev:(%d:%d), rdev:(%d:%d), (caller: %p,%p,%p,%p).\n",
 		MD_MAJOR,mdidx(mddev),MAJOR(bdev->bd_dev),MINOR(bdev->bd_dev),
 		__builtin_return_address(0),__builtin_return_address(1),
@@ -2614,25 +2609,15 @@ int md_error(mddev_t *mddev, mdk_rdev_t 
 
 	if (!mddev) {
 		MD_BUG();
-		return 0;
+		return;
 	}
 
 	if (!rdev || rdev->faulty)
-		return 0;
-	if (!mddev->pers->error_handler
-			|| mddev->pers->error_handler(mddev,rdev) <= 0) {
-		rdev->faulty = 1;
-		rdev->in_sync = 0;
-	} else
-		return 1;
-	/*
-	 * if recovery was running, stop it now.
-	 */
-	if (mddev->recovery_running) 
-		mddev->recovery_running = -EIO;
+		return;
+	if (!mddev->pers->error_handler)
+		return;
+	mddev->pers->error_handler(mddev,rdev);
 	md_recover_arrays();
-
-	return 0;
 }
 
 static int status_unused(char * page)
@@ -3510,7 +3495,7 @@ static int __init raid_setup(char *str)
 	return 1;
 }
 
-int __init md_run_setup(void)
+static int __init md_run_setup(void)
 {
 	if (raid_setup_args.noautodetect)
 		printk(KERN_INFO "md: Skipping autodetection of RAID arrays. (raid=noautodetect)\n");
--- ./drivers/md/raid5.c	2002/08/21 23:12:26	1.8
+++ ./drivers/md/raid5.c	2002/08/21 23:14:39	1.9
@@ -440,33 +440,30 @@ static void raid5_build_block (struct st
 		dev->sector = compute_blocknr(sh, i);
 }
 
-static int error(mddev_t *mddev, mdk_rdev_t *rdev)
+static void error(mddev_t *mddev, mdk_rdev_t *rdev)
 {
 	raid5_conf_t *conf = (raid5_conf_t *) mddev->private;
-	struct disk_info *disk;
-	int i;
-
 	PRINTK("raid5: error called\n");
 
-	for (i = 0, disk = conf->disks; i < conf->raid_disks; i++, disk++) {
-		if (disk->rdev != rdev)
-			continue;
-		if (disk->operational) {
-			disk->operational = 0;
-			mddev->sb_dirty = 1;
-			conf->working_disks--;
-			if (!disk->write_only) {
-				mddev->degraded++;
-				conf->failed_disks++;
-			}
-			printk (KERN_ALERT
-				"raid5: Disk failure on %s, disabling device."
-				" Operation continuing on %d devices\n",
-				bdev_partition_name(rdev->bdev), conf->working_disks);
-		}
-		return 0;
+	if (!rdev->faulty) {
+		mddev->sb_dirty = 1;
+		conf->working_disks--;
+		if (rdev->in_sync) {
+			mddev->degraded++;
+			conf->failed_disks++;
+			rdev->in_sync = 0;
+			/*
+			 * if recovery was running, stop it now.
+			 */
+			if (mddev->recovery_running) 
+				mddev->recovery_running = -EIO;
+		}
+		rdev->faulty = 1;
+		printk (KERN_ALERT
+			"raid5: Disk failure on %s, disabling device."
+			" Operation continuing on %d devices\n",
+			bdev_partition_name(rdev->bdev), conf->working_disks);
 	}
-	return -EIO;
 }	
 
 /*
@@ -820,7 +817,6 @@ static void handle_stripe(struct stripe_
 	int disks = conf->raid_disks;
 	struct bio *return_bi= NULL;
 	struct bio *bi;
-	int action[MD_SB_DISKS];
 	int i;
 	int syncing;
 	int locked=0, uptodate=0, to_read=0, to_write=0, failed=0, written=0;
@@ -828,7 +824,6 @@ static void handle_stripe(struct stripe_
 	struct r5dev *dev;
 
 	PRINTK("handling stripe %ld, cnt=%d, pd_idx=%d\n", sh->sector, atomic_read(&sh->count), sh->pd_idx);
-	memset(action, 0, sizeof(action));
 
 	spin_lock(&sh->lock);
 	clear_bit(STRIPE_HANDLE, &sh->state);
@@ -838,7 +833,13 @@ static void handle_stripe(struct stripe_
 	/* Now to look around and see what can be done */
 
 	for (i=disks; i--; ) {
+		mdk_rdev_t *rdev;
 		dev = &sh->dev[i];
+		clear_bit(R5_Wantread, &dev->flags);
+		clear_bit(R5_Wantwrite, &dev->flags);
+		clear_bit(R5_Insync, &dev->flags);
+		clear_bit(R5_Syncio, &dev->flags);
+
 		PRINTK("check %d: state 0x%lx read %p write %p written %p\n", i, 
 		       dev->flags, dev->toread, dev->towrite, dev->written);
 		/* maybe we can reply to a read */
@@ -870,10 +871,12 @@ static void handle_stripe(struct stripe_
 		if (dev->toread) to_read++;
 		if (dev->towrite) to_write++;
 		if (dev->written) written++;
-		if (!conf->disks[i].operational || conf->disks[i].write_only) {
+		rdev = conf->disks[i].rdev; /* FIXME, should I be looking rdev */
+		if (!rdev || !rdev->in_sync) {
 			failed++;
 			failed_num = i;
-		}
+		} else
+			set_bit(R5_Insync, &dev->flags);
 	}
 	PRINTK("locked=%d uptodate=%d to_read=%d to_write=%d failed=%d failed_num=%d\n",
 	       locked, uptodate, to_read, to_write, failed, failed_num);
@@ -898,7 +901,7 @@ static void handle_stripe(struct stripe_
 				bi = nextbi;
 			}
 			/* fail any reads if this device is non-operational */
-			if (!conf->disks[i].operational || conf->disks[i].write_only) {
+			if (!test_bit(R5_Insync, &sh->dev[i].flags)) {
 				bi = sh->dev[i].toread;
 				sh->dev[i].toread = NULL;
 				if (bi) to_read--;
@@ -926,7 +929,7 @@ static void handle_stripe(struct stripe_
 	 */
 	dev = &sh->dev[sh->pd_idx];
 	if ( written &&
-	     ( (conf->disks[sh->pd_idx].operational && !conf->disks[sh->pd_idx].write_only && !test_bit(R5_LOCKED, &dev->flags) &&
+	     ( (test_bit(R5_Insync, &dev->flags) && !test_bit(R5_LOCKED, &dev->flags) &&
 		test_bit(R5_UPTODATE, &dev->flags))
 	       || (failed == 1 && failed_num == sh->pd_idx))
 	    ) {
@@ -934,7 +937,7 @@ static void handle_stripe(struct stripe_
 	    for (i=disks; i--; )
 		if (sh->dev[i].written) {
 		    dev = &sh->dev[i];
-		    if (!conf->disks[sh->pd_idx].operational || conf->disks[sh->pd_idx].write_only ||
+		    if (!test_bit(R5_Insync, &dev->flags) &&
 			(!test_bit(R5_LOCKED, &dev->flags) && test_bit(R5_UPTODATE, &dev->flags)) ) {
 			/* maybe we can return some write requests */
 			    struct bio *wbi, *wbi2;
@@ -968,9 +971,9 @@ static void handle_stripe(struct stripe_
 					PRINTK("Computing block %d\n", i);
 					compute_block(sh, i);
 					uptodate++;
-				} else if (conf->disks[i].operational && !conf->disks[i].write_only) {
+				} else if (test_bit(R5_Insync, &dev->flags)) {
 					set_bit(R5_LOCKED, &dev->flags);
-					action[i] = READ+1;
+					set_bit(R5_Wantread, &dev->flags);
 #if 0
 					/* if I am just reading this block and we don't have
 					   a failed drive, or any pending writes then sidestep the cache */
@@ -1003,7 +1006,7 @@ static void handle_stripe(struct stripe_
 #endif
 				    ) &&
 			    !test_bit(R5_UPTODATE, &dev->flags)) {
-				if (conf->disks[i].operational  && !conf->disks[i].write_only
+				if (test_bit(R5_Insync, &dev->flags)
 /*				    && !(!mddev->insync && i == sh->pd_idx) */
 					)
 					rmw++;
@@ -1017,7 +1020,7 @@ static void handle_stripe(struct stripe_
 #endif
 				    ) &&
 			    !test_bit(R5_UPTODATE, &dev->flags)) {
-				if (conf->disks[i].operational && !conf->disks[i].write_only) rcw++;
+				if (test_bit(R5_Insync, &dev->flags)) rcw++;
 				else rcw += 2*disks;
 			}
 		}
@@ -1029,12 +1032,12 @@ static void handle_stripe(struct stripe_
 				dev = &sh->dev[i];
 				if ((dev->towrite || i == sh->pd_idx) &&
 				    !test_bit(R5_LOCKED, &dev->flags) && !test_bit(R5_UPTODATE, &dev->flags) &&
-				    conf->disks[i].operational && !conf->disks[i].write_only) {
+				    test_bit(R5_Insync, &dev->flags)) {
 					if (test_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
 					{
 						PRINTK("Read_old block %d for r-m-w\n", i);
 						set_bit(R5_LOCKED, &dev->flags);
-						action[i] = READ+1;
+						set_bit(R5_Wantread, &dev->flags);
 						locked++;
 					} else {
 						set_bit(STRIPE_DELAYED, &sh->state);
@@ -1048,12 +1051,12 @@ static void handle_stripe(struct stripe_
 				dev = &sh->dev[i];
 				if (!test_bit(R5_OVERWRITE, &dev->flags) && i != sh->pd_idx &&
 				    !test_bit(R5_LOCKED, &dev->flags) && !test_bit(R5_UPTODATE, &dev->flags) &&
-				    conf->disks[i].operational && !conf->disks[i].write_only) {
+				    test_bit(R5_Insync, &dev->flags)) {
 					if (test_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
 					{
 						PRINTK("Read_old block %d for Reconstruct\n", i);
 						set_bit(R5_LOCKED, &dev->flags);
-						action[i] = READ+1;
+						set_bit(R5_Wantread, &dev->flags);
 						locked++;
 					} else {
 						set_bit(STRIPE_DELAYED, &sh->state);
@@ -1070,8 +1073,8 @@ static void handle_stripe(struct stripe_
 				if (test_bit(R5_LOCKED, &sh->dev[i].flags)) {
 					PRINTK("Writing block %d\n", i);
 					locked++;
-					action[i] = WRITE+1;
-					if (!conf->disks[i].operational || conf->disks[i].write_only
+					set_bit(R5_Wantwrite, &sh->dev[i].flags);
+					if (!test_bit(R5_Insync, &sh->dev[i].flags)
 					    || (i==sh->pd_idx && failed == 0))
 						set_bit(STRIPE_INSYNC, &sh->state);
 				}
@@ -1117,11 +1120,10 @@ static void handle_stripe(struct stripe_
 				BUG();
 			dev = &sh->dev[failed_num];
 			set_bit(R5_LOCKED, &dev->flags);
-			action[failed_num] = WRITE+1;
+			set_bit(R5_Wantwrite, &dev->flags);
 			locked++;
 			set_bit(STRIPE_INSYNC, &sh->state);
-			if (conf->disks[failed_num].operational)
-				md_sync_acct(conf->disks[failed_num].rdev, STRIPE_SECTORS);
+			set_bit(R5_Syncio, &dev->flags);
 		}
 	}
 	if (syncing && locked == 0 && test_bit(STRIPE_INSYNC, &sh->state)) {
@@ -1137,32 +1139,34 @@ static void handle_stripe(struct stripe_
 		bi->bi_end_io(bi);
 	}
 	for (i=disks; i-- ;) 
-		if (action[i]) {
+		if (sh->dev[i].flags & ((1<<R5_Wantwrite)|(1<<R5_Wantread))) {
 			struct bio *bi = &sh->dev[i].req;
 			mdk_rdev_t *rdev ;
 
-			if (action[i] == READ+1)
+			bi->bi_rw = 0;
+			if (test_bit(R5_Wantread, &sh->dev[i].flags))
 				bi->bi_end_io = raid5_end_read_request;
-			else
+			else {
 				bi->bi_end_io = raid5_end_write_request;
+				bi->bi_rw = 1;
+			}
 
 			spin_lock_irq(&conf->device_lock);
 			rdev = conf->disks[i].rdev;
-			if (!conf->disks[i].operational)
+			if (rdev && rdev->faulty)
 				rdev = NULL;
 			if (rdev)
 				atomic_inc(&rdev->nr_pending);
 			spin_unlock_irq(&conf->device_lock);
 
 			if (rdev) {
+				if (test_bit(R5_Syncio, &sh->dev[i].flags))
+					md_sync_acct(rdev, STRIPE_SECTORS);
+
 				bi->bi_bdev = rdev->bdev;
-				PRINTK("for %ld schedule op %d on disc %d\n", sh->sector, action[i]-1, i);
+				PRINTK("for %ld schedule op %d on disc %d\n", sh->sector, bi->bi_rw, i);
 				atomic_inc(&sh->count);
 				bi->bi_sector = sh->sector;
-				if (action[i] == READ+1) 
-					bi->bi_rw = 0;
-				else
-					bi->bi_rw = 1;
 				bi->bi_flags = 0;
 				bi->bi_vcnt = 1;	
 				bi->bi_idx = 0;
@@ -1171,7 +1175,7 @@ static void handle_stripe(struct stripe_
 				bi->bi_next = NULL;
 				generic_make_request(bi);
 			} else {
-				PRINTK("skip op %d on disc %d for sector %ld\n", action[i]-1, i, sh->sector);
+				PRINTK("skip op %d on disc %d for sector %ld\n", bi->bi_rw, i, sh->sector);
 				clear_bit(R5_LOCKED, &dev->flags);
 				set_bit(STRIPE_HANDLE, &sh->state);
 			}
@@ -1388,17 +1392,9 @@ static int run (mddev_t *mddev)
 
 		disk->rdev = rdev;
 
-		if (rdev->faulty)
-			disk->operational = 0;
-		else if (rdev->in_sync) {
+		if (rdev->in_sync) {
 			printk(KERN_INFO "raid5: device %s operational as raid disk %d\n", bdev_partition_name(rdev->bdev), raid_disk);
-	
-			disk->operational = 1;
-			disk->write_only = 0;
 			conf->working_disks++;
-		} else {
-			disk->operational = 1;
-			disk->write_only = 1;
 		}
 	}
 
@@ -1534,7 +1530,9 @@ static int status (char *page, mddev_t *
 	sz += sprintf (page+sz, " level %d, %dk chunk, algorithm %d", mddev->level, mddev->chunk_size >> 10, mddev->layout);
 	sz += sprintf (page+sz, " [%d/%d] [", conf->raid_disks, conf->working_disks);
 	for (i = 0; i < conf->raid_disks; i++)
-		sz += sprintf (page+sz, "%s", conf->disks[i].operational ? "U" : "_");
+		sz += sprintf (page+sz, "%s",
+			       conf->disks[i].rdev &&
+			       conf->disks[i].rdev->in_sync ? "U" : "_");
 	sz += sprintf (page+sz, "]");
 #if RAID5_DEBUG
 #define D(x) \
@@ -1561,7 +1559,7 @@ static void print_raid5_conf (raid5_conf
 		tmp = conf->disks + i;
 		if (tmp->rdev)
 		printk(" disk %d, o:%d, dev:%s\n",
-			i, tmp->operational,
+			i, !tmp->rdev->faulty,
 			bdev_partition_name(tmp->rdev->bdev));
 	}
 }
@@ -1575,10 +1573,9 @@ static int raid5_spare_active(mddev_t *m
 	spin_lock_irq(&conf->device_lock);
 	for (i = 0; i < conf->raid_disks; i++) {
 		tmp = conf->disks + i;
-		if (tmp->operational && tmp->rdev
+		if (tmp->rdev
 		    && !tmp->rdev->faulty
-		    && tmp->write_only) {
-			tmp->write_only = 0;
+		    && !tmp->rdev->in_sync) {
 			mddev->degraded--;
 			conf->failed_disks--;
 			conf->working_disks++;
@@ -1600,7 +1597,7 @@ static int raid5_remove_disk(mddev_t *md
 	spin_lock_irq(&conf->device_lock);
 
 	if (p->rdev) {
-		if (p->operational || 
+		if (p->rdev->in_sync || 
 		    atomic_read(&p->rdev->nr_pending)) {
 			err = -EBUSY;
 			goto abort;
@@ -1630,8 +1627,7 @@ static int raid5_add_disk(mddev_t *mddev
 	for (disk=0; disk < mddev->raid_disks; disk++)
 		if ((p=conf->disks + disk)->rdev == NULL) {
 			p->rdev = rdev;
-			p->operational = 1;
-			p->write_only = 1;
+			rdev->in_sync = 0;
 			rdev->raid_disk = disk;
 			found = 1;
 			break;
--- ./drivers/md/raid1.c	2002/08/21 23:11:27	1.6
+++ ./drivers/md/raid1.c	2002/08/21 23:14:39	1.7
@@ -188,7 +188,7 @@ static inline void put_buf(r1bio_t *r1_b
 	mempool_free(r1_bio, conf->r1buf_pool);
 }
 
-static int map(mddev_t *mddev, mdk_rdev_t **rdev)
+static int map(mddev_t *mddev, mdk_rdev_t **rdevp)
 {
 	conf_t *conf = mddev_to_conf(mddev);
 	int i, disks = conf->raid_disks;
@@ -200,11 +200,10 @@ static int map(mddev_t *mddev, mdk_rdev_
 
 	spin_lock_irq(&conf->device_lock);
 	for (i = 0; i < disks; i++) {
-		if (conf->mirrors[i].operational
-		    && !conf->mirrors[i].write_only
-		    && conf->mirrors[i].rdev) {
-			*rdev = conf->mirrors[i].rdev;
-			atomic_inc(&(*rdev)->nr_pending);
+		mdk_rdev_t *rdev = conf->mirrors[i].rdev;
+		if (rdev && rdev->in_sync) {
+			*rdevp = rdev;
+			atomic_inc(&rdev->nr_pending);
 			spin_unlock_irq(&conf->device_lock);
 			return 0;
 		}
@@ -346,7 +345,9 @@ static int read_balance(conf_t *conf, st
 	if (!conf->mddev->in_sync && (this_sector + sectors >= conf->next_resync)) {
 		/* make sure that disk is operational */
 		new_disk = 0;
-		while (!conf->mirrors[new_disk].operational || conf->mirrors[new_disk].write_only) {
+
+		while (!conf->mirrors[new_disk].rdev ||
+		       !conf->mirrors[new_disk].rdev->in_sync) {
 			new_disk++;
 			if (new_disk == conf->raid_disks) {
 				new_disk = 0;
@@ -358,7 +359,8 @@ static int read_balance(conf_t *conf, st
 
 
 	/* make sure the disk is operational */
-	while (!conf->mirrors[new_disk].operational || conf->mirrors[new_disk].write_only) {
+	while (!conf->mirrors[new_disk].rdev ||
+	       !conf->mirrors[new_disk].rdev->in_sync) {
 		if (new_disk <= 0)
 			new_disk = conf->raid_disks;
 		new_disk--;
@@ -387,8 +389,8 @@ static int read_balance(conf_t *conf, st
 			disk = conf->raid_disks;
 		disk--;
 
-		if (conf->mirrors[disk].write_only ||
-		    !conf->mirrors[disk].operational)
+		if (!conf->mirrors[disk].rdev ||
+		    !conf->mirrors[disk].rdev->in_sync)
 			continue;
 
 		if (!atomic_read(&conf->mirrors[disk].rdev->nr_pending)) {
@@ -509,8 +511,8 @@ static int make_request(request_queue_t 
 	 */
 	spin_lock_irq(&conf->device_lock);
 	for (i = 0;  i < disks; i++) {
-		if (conf->mirrors[i].operational &&
-		    conf->mirrors[i].rdev) {
+		if (conf->mirrors[i].rdev &&
+		    !conf->mirrors[i].rdev->faulty) {
 			atomic_inc(&conf->mirrors[i].rdev->nr_pending);
 			r1_bio->write_bios[i] = bio;
 		} else
@@ -573,7 +575,8 @@ static int status(char *page, mddev_t *m
 						conf->working_disks);
 	for (i = 0; i < conf->raid_disks; i++)
 		sz += sprintf(page+sz, "%s",
-			conf->mirrors[i].operational ? "U" : "_");
+			      conf->mirrors[i].rdev &&
+			      conf->mirrors[i].rdev->in_sync ? "U" : "_");
 	sz += sprintf (page+sz, "]");
 	return sz;
 }
@@ -594,49 +597,37 @@ static int status(char *page, mddev_t *m
 #define ALREADY_SYNCING KERN_INFO \
 "raid1: syncing already in progress.\n"
 
-static void mark_disk_bad(mddev_t *mddev, int failed)
-{
-	conf_t *conf = mddev_to_conf(mddev);
-	mirror_info_t *mirror = conf->mirrors+failed;
-
-	mirror->operational = 0;
-	if (!mirror->write_only) {
-		mddev->degraded++;
-		conf->working_disks--;
-	}
-	mddev->sb_dirty = 1;
-	printk(DISK_FAILED, bdev_partition_name(mirror->rdev->bdev), conf->working_disks);
-}
 
-static int error(mddev_t *mddev, mdk_rdev_t *rdev)
+static void error(mddev_t *mddev, mdk_rdev_t *rdev)
 {
 	conf_t *conf = mddev_to_conf(mddev);
-	mirror_info_t * mirrors = conf->mirrors;
-	int disks = conf->raid_disks;
-	int i;
 
 	/*
-	 * Find the drive.
 	 * If it is not operational, then we have already marked it as dead
 	 * else if it is the last working disks, ignore the error, let the
 	 * next level up know.
 	 * else mark the drive as failed
 	 */
-	for (i = 0; i < disks; i++)
-		if (mirrors[i].operational && mirrors[i].rdev == rdev)
-			break;
-	if (i == disks)
-		return 0;
-
-	if (mirrors[i].operational && !mirrors[i].write_only
+	if (rdev->in_sync
 	    && conf->working_disks == 1)
 		/*
 		 * Don't fail the drive, act as though we were just a
 		 * normal single drive
 		 */
-		return 1;
-	mark_disk_bad(mddev, i);
-	return 0;
+		return;
+	if (rdev->in_sync) {
+		mddev->degraded++;
+		conf->working_disks--;
+		/*
+		 * if recovery was running, stop it now.
+		 */
+		if (mddev->recovery_running) 
+			mddev->recovery_running = -EIO;
+	}
+	rdev->in_sync = 0;
+	rdev->faulty = 1;
+	mddev->sb_dirty = 1;
+	printk(DISK_FAILED, bdev_partition_name(rdev->bdev), conf->working_disks);
 }
 
 static void print_conf(conf_t *conf)
@@ -656,7 +647,7 @@ static void print_conf(conf_t *conf)
 		tmp = conf->mirrors + i;
 		if (tmp->rdev)
 			printk(" disk %d, wo:%d, o:%d, dev:%s\n",
-			       i, tmp->write_only, tmp->operational,
+			       i, !tmp->rdev->in_sync, !tmp->rdev->faulty,
 			       bdev_partition_name(tmp->rdev->bdev));
 	}
 }
@@ -688,12 +679,11 @@ static int raid1_spare_active(mddev_t *m
 	 */
 	for (i = 0; i < conf->raid_disks; i++) {
 		tmp = conf->mirrors + i;
-		if (tmp->operational && tmp->rdev 
+		if (tmp->rdev 
 		    && !tmp->rdev->faulty
-		    && tmp->write_only) {
+		    && !tmp->rdev->in_sync) {
 			conf->working_disks++;
 			mddev->degraded--;
-			tmp->write_only = 0;
 			tmp->rdev->in_sync = 1;
 		}
 	}
@@ -715,8 +705,6 @@ static int raid1_add_disk(mddev_t *mddev
 	for (mirror=0; mirror < mddev->raid_disks; mirror++)
 		if ( !(p=conf->mirrors+mirror)->rdev) {
 			p->rdev = rdev;
-			p->write_only = 1;
-			p->operational = 1;
 			p->head_position = 0;
 			rdev->raid_disk = mirror;
 			found = 1;
@@ -737,8 +725,8 @@ static int raid1_remove_disk(mddev_t *md
 	print_conf(conf);
 	spin_lock_irq(&conf->device_lock);
 	if (p->rdev) {
-		if (p->operational ||
-			(p->rdev && atomic_read(&p->rdev->nr_pending))) {
+		if (p->rdev->in_sync ||
+		    atomic_read(&p->rdev->nr_pending)) {
 			err = -EBUSY;
 			goto abort;
 		}
@@ -837,20 +825,19 @@ static void sync_request_write(mddev_t *
 	spin_lock_irq(&conf->device_lock);
 	for (i = 0; i < disks ; i++) {
 		r1_bio->write_bios[i] = NULL;
-		if (!conf->mirrors[i].operational)
+		if (!conf->mirrors[i].rdev || 
+		    conf->mirrors[i].rdev->faulty)
 			continue;
 		if (i == conf->last_used)
 			/*
 			 * we read from here, no need to write
 			 */
 			continue;
-		if (!conf->mirrors[i].write_only && mddev->in_sync)
+		if (conf->mirrors[i].rdev->in_sync && mddev->in_sync)
 			/*
 			 * don't need to write this we are just rebuilding
 			 */
 			continue;
-		if (!conf->mirrors[i].rdev)
-			continue;
 		atomic_inc(&conf->mirrors[i].rdev->nr_pending);
 		r1_bio->write_bios[i] = bio;
 	}
@@ -1009,9 +996,8 @@ static int sync_request(mddev_t *mddev, 
 	disk = conf->last_used;
 	/* make sure disk is operational */
 	spin_lock_irq(&conf->device_lock);
-	while (!conf->mirrors[disk].operational ||
-	       conf->mirrors[disk].write_only ||
-		!conf->mirrors[disk].rdev) {
+	while (conf->mirrors[disk].rdev == NULL ||
+	       !conf->mirrors[disk].rdev->in_sync) {
 		if (disk <= 0)
 			disk = conf->raid_disks;
 		disk--;
@@ -1149,8 +1135,6 @@ static int run(mddev_t *mddev)
 		disk = conf->mirrors + disk_idx;
 
 		disk->rdev = rdev;
-		disk->operational = ! rdev->faulty;
-		disk->write_only = ! rdev->in_sync;
 		disk->head_position = 0;
 		if (!rdev->faulty && rdev->in_sync)
 			conf->working_disks++;
@@ -1174,8 +1158,6 @@ static int run(mddev_t *mddev)
 		disk = conf->mirrors + i;
 
 		if (!disk->rdev) {
-			disk->operational = 0;
-			disk->write_only = 0;
 			disk->head_position = 0;
 			mddev->degraded++;
 		}
@@ -1186,8 +1168,8 @@ static int run(mddev_t *mddev)
 	 * to read balancing.
 	 */
 	for (j = 0; j < conf->raid_disks &&
-		     (!conf->mirrors[j].operational ||
-		      conf->mirrors[j].write_only) ; j++)
+		     (!conf->mirrors[j].rdev ||
+		      !conf->mirrors[j].rdev->in_sync) ; j++)
 		/* nothing */;
 	conf->last_used = j;
 
--- ./drivers/md/multipath.c	2002/08/21 23:11:27	1.6
+++ ./drivers/md/multipath.c	2002/08/21 23:14:40	1.7
@@ -70,7 +70,7 @@ static void mp_pool_free(void *mpb, void
 	kfree(mpb);
 }
 
-static int multipath_map (mddev_t *mddev, mdk_rdev_t **rdev)
+static int multipath_map (mddev_t *mddev, mdk_rdev_t **rdevp)
 {
 	multipath_conf_t *conf = mddev_to_conf(mddev);
 	int i, disks = MD_SB_DISKS;
@@ -82,10 +82,10 @@ static int multipath_map (mddev_t *mddev
 
 	spin_lock_irq(&conf->device_lock);
 	for (i = 0; i < disks; i++) {
-		if (conf->multipaths[i].operational &&
-			conf->multipaths[i].rdev) {
-			*rdev = conf->multipaths[i].rdev;
-			atomic_inc(&(*rdev)->nr_pending);
+		mdk_rdev_t *rdev = conf->multipaths[i].rdev;
+		if (rdev && rdev->in_sync) {
+			*rdevp = rdev;
+			atomic_inc(&rdev->nr_pending);
 			spin_unlock_irq(&conf->device_lock);
 			return 0;
 		}
@@ -158,10 +158,11 @@ static int multipath_read_balance (multi
 {
 	int disk;
 
-	for (disk = 0; disk < MD_SB_DISKS; disk++)	
-		if (conf->multipaths[disk].operational &&
-			conf->multipaths[disk].rdev)
+	for (disk = 0; disk < MD_SB_DISKS; disk++) {
+		mdk_rdev_t *rdev = conf->multipaths[disk].rdev;
+		if (rdev && rdev->in_sync)
 			return disk;
+	}
 	BUG();
 	return 0;
 }
@@ -204,7 +205,8 @@ static int multipath_status (char *page,
 						 conf->working_disks);
 	for (i = 0; i < conf->raid_disks; i++)
 		sz += sprintf (page+sz, "%s",
-			conf->multipaths[i].operational ? "U" : "_");
+			       conf->multipaths[i].rdev && 
+			       conf->multipaths[i].rdev->in_sync ? "U" : "_");
 	sz += sprintf (page+sz, "]");
 	return sz;
 }
@@ -219,28 +221,13 @@ static int multipath_status (char *page,
 "multipath: IO failure on %s, disabling IO path. \n" \
 "	Operation continuing on %d IO paths.\n"
 
-static void mark_disk_bad (mddev_t *mddev, int failed)
-{
-	multipath_conf_t *conf = mddev_to_conf(mddev);
-	struct multipath_info *multipath = conf->multipaths+failed;
-
-	multipath->operational = 0;
-	mddev->sb_dirty = 1;
-	conf->working_disks--;
-	printk (DISK_FAILED, bdev_partition_name (multipath->rdev->bdev),
-				 conf->working_disks);
-}
 
 /*
  * Careful, this can execute in IRQ contexts as well!
  */
-static int multipath_error (mddev_t *mddev, mdk_rdev_t *rdev)
+static void multipath_error (mddev_t *mddev, mdk_rdev_t *rdev)
 {
 	multipath_conf_t *conf = mddev_to_conf(mddev);
-	struct multipath_info * multipaths = conf->multipaths;
-	int disks = MD_SB_DISKS;
-	int i;
-
 
 	if (conf->working_disks <= 1) {
 		/*
@@ -248,24 +235,21 @@ static int multipath_error (mddev_t *mdd
 		 * first check if this is a queued request for a device
 		 * which has just failed.
 		 */
-		for (i = 0; i < disks; i++) {
-			if (multipaths[i].rdev == rdev && !multipaths[i].operational)
-				return 0;
-		}
 		printk (LAST_DISK);
-		return 1; /* leave it active... it's all we have */
+		/* leave it active... it's all we have */
 	} else {
 		/*
 		 * Mark disk as unusable
 		 */
-		for (i = 0; i < disks; i++) {
-			if (multipaths[i].rdev == rdev && multipaths[i].operational) {
-				mark_disk_bad(mddev, i);
-				break;
-			}
+		if (!rdev->faulty) {
+			rdev->in_sync = 0;
+			rdev->faulty = 1;
+			mddev->sb_dirty = 1;
+			conf->working_disks--;
+			printk (DISK_FAILED, bdev_partition_name (rdev->bdev),
+				conf->working_disks);
 		}
 	}
-	return 0;
 }
 
 #undef LAST_DISK
@@ -290,7 +274,7 @@ static void print_multipath_conf (multip
 		tmp = conf->multipaths + i;
 		if (tmp->rdev)
 			printk(" disk%d, o:%d, dev:%s\n",
-				i,tmp->operational,
+				i,!tmp->rdev->faulty,
 			       bdev_partition_name(tmp->rdev->bdev));
 	}
 }
@@ -308,7 +292,6 @@ static int multipath_add_disk(mddev_t *m
 	for (path=0; path<mddev->raid_disks; path++) 
 		if ((p=conf->multipaths+path)->rdev == NULL) {
 			p->rdev = rdev;
-			p->operational = 1;
 			conf->working_disks++;
 			rdev->raid_disk = path;
 			found = 1;
@@ -329,8 +312,8 @@ static int multipath_remove_disk(mddev_t
 	spin_lock_irq(&conf->device_lock);
 
 	if (p->rdev) {
-		if (p->operational ||
-		    (p->rdev && atomic_read(&p->rdev->nr_pending))) {
+		if (p->rdev->in_sync ||
+		    atomic_read(&p->rdev->nr_pending)) {
 			printk(KERN_ERR "hot-remove-disk, slot %d is identified but is still operational!\n", number);
 			err = -EBUSY;
 			goto abort;
@@ -474,18 +457,8 @@ static int multipath_run (mddev_t *mddev
 
 		disk = conf->multipaths + disk_idx;
 		disk->rdev = rdev;
-		if (rdev->faulty) 
-			disk->operational = 0;
-		else {
-
-			/*
-			 * Mark all disks as active to start with, there are no
-			 * spares.  multipath_read_balance deals with choose
-			 * the "best" operational device.
-			 */
-			disk->operational = 1;
+		if (!rdev->faulty) 
 			conf->working_disks++;
-		}
 	}
 
 	conf->raid_disks = mddev->raid_disks;
