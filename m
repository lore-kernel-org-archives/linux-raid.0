From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 4 of 13 - MD error handers and md_sync_acct now get rdev instead of bdev
Date: Thu, 22 Aug 2002 10:34:02 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E17hfvG-000505-00@notabene.cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


### Comments for ChangeSet

This simplifies the error handlers slighty, but allows for even more
simplification later.


 ----------- Diffstat output ------------
 ./drivers/md/md.c           |   31 +++++++++----------------------
 ./drivers/md/multipath.c    |   14 +++++++-------
 ./drivers/md/raid1.c        |   14 +++++++-------
 ./drivers/md/raid5.c        |   20 ++++++++++----------
 ./include/linux/raid/md.h   |    4 ++--
 ./include/linux/raid/md_k.h |    2 +-
 6 files changed, 36 insertions(+), 49 deletions(-)

--- ./include/linux/raid/md.h	2002/08/21 23:08:50	1.1
+++ ./include/linux/raid/md.h	2002/08/21 23:08:55	1.2
@@ -76,8 +76,8 @@ extern void md_unregister_thread (mdk_th
 extern void md_wakeup_thread(mdk_thread_t *thread);
 extern void md_interrupt_thread (mdk_thread_t *thread);
 extern void md_done_sync(mddev_t *mddev, int blocks, int ok);
-extern void md_sync_acct(struct block_device *bdev, unsigned long nr_sectors);
-extern int md_error (mddev_t *mddev, struct block_device *bdev);
+extern void md_sync_acct(mdk_rdev_t *rdev, unsigned long nr_sectors);
+extern int md_error (mddev_t *mddev, mdk_rdev_t *rdev);
 extern int md_run_setup(void);
 
 extern void md_print_devices (void);
--- ./include/linux/raid/md_k.h	2002/08/21 23:08:50	1.1
+++ ./include/linux/raid/md_k.h	2002/08/21 23:08:55	1.2
@@ -223,7 +223,7 @@ struct mdk_personality_s
 	int (*run)(mddev_t *mddev);
 	int (*stop)(mddev_t *mddev);
 	int (*status)(char *page, mddev_t *mddev);
-	int (*error_handler)(mddev_t *mddev, struct block_device *bdev);
+	int (*error_handler)(mddev_t *mddev, mdk_rdev_t *rdev);
 	int (*hot_add_disk) (mddev_t *mddev, mdk_rdev_t *rdev);
 	int (*hot_remove_disk) (mddev_t *mddev, int number);
 	int (*spare_write) (mddev_t *mddev);
--- ./drivers/md/md.c	2002/08/21 23:00:33	1.5
+++ ./drivers/md/md.c	2002/08/21 23:08:55	1.6
@@ -251,18 +251,6 @@ static mdk_rdev_t * find_rdev(mddev_t * 
 	return NULL;
 }
 
-static mdk_rdev_t * find_rdev_bdev(mddev_t * mddev, struct block_device *bdev)
-{
-	struct list_head *tmp;
-	mdk_rdev_t *rdev;
-
-	ITERATE_RDEV(mddev,rdev,tmp) {
-		if (rdev->bdev == bdev)
-			return rdev;
-	}
-	return NULL;
-}
-
 static LIST_HEAD(device_names);
 
 char * partition_name(kdev_t dev)
@@ -2213,7 +2201,7 @@ static int set_disk_faulty(mddev_t *mdde
 	if (!rdev)
 		return 0;
 
-	ret = md_error(mddev, rdev->bdev);
+	ret = md_error(mddev, rdev);
 	return ret;
 }
 
@@ -2629,9 +2617,8 @@ static void md_recover_arrays(void)
 }
 
 
-int md_error(mddev_t *mddev, struct block_device *bdev)
+int md_error(mddev_t *mddev, mdk_rdev_t *rdev)
 {
-	mdk_rdev_t * rrdev;
 
 	dprintk("md_error dev:(%d:%d), rdev:(%d:%d), (caller: %p,%p,%p,%p).\n",
 		MD_MAJOR,mdidx(mddev),MAJOR(bdev->bd_dev),MINOR(bdev->bd_dev),
@@ -2642,13 +2629,13 @@ int md_error(mddev_t *mddev, struct bloc
 		MD_BUG();
 		return 0;
 	}
-	rrdev = find_rdev_bdev(mddev, bdev);
-	if (!rrdev || rrdev->faulty)
+
+	if (!rdev || rdev->faulty)
 		return 0;
 	if (!mddev->pers->error_handler
-			|| mddev->pers->error_handler(mddev,bdev) <= 0) {
-		rrdev->faulty = 1;
-		rrdev->in_sync = 0;
+			|| mddev->pers->error_handler(mddev,rdev) <= 0) {
+		rdev->faulty = 1;
+		rdev->in_sync = 0;
 	} else
 		return 1;
 	/*
@@ -2844,9 +2831,9 @@ static mdk_rdev_t *get_spare(mddev_t *md
 }
 
 static unsigned int sync_io[DK_MAX_MAJOR][DK_MAX_DISK];
-void md_sync_acct(struct block_device *bdev, unsigned long nr_sectors)
+void md_sync_acct(mdk_rdev_t *rdev, unsigned long nr_sectors)
 {
-	kdev_t dev = to_kdev_t(bdev->bd_dev);
+	kdev_t dev = to_kdev_t(rdev->bdev->bd_dev);
 	unsigned int major = major(dev);
 	unsigned int index;
 
--- ./drivers/md/raid5.c	2002/08/21 23:07:28	1.3
+++ ./drivers/md/raid5.c	2002/08/21 23:08:55	1.4
@@ -371,7 +371,7 @@ static void raid5_end_read_request (stru
 		set_bit(R5_UPTODATE, &sh->dev[i].flags);
 #endif		
 	} else {
-		md_error(conf->mddev, conf->disks[i].rdev->bdev);
+		md_error(conf->mddev, conf->disks[i].rdev);
 		clear_bit(R5_UPTODATE, &sh->dev[i].flags);
 	}
 #if 0
@@ -407,7 +407,7 @@ static void raid5_end_write_request (str
 
 	spin_lock_irqsave(&conf->device_lock, flags);
 	if (!uptodate)
-		md_error(conf->mddev, conf->disks[i].rdev->bdev);
+		md_error(conf->mddev, conf->disks[i].rdev);
 	
 	clear_bit(R5_LOCKED, &sh->dev[i].flags);
 	set_bit(STRIPE_HANDLE, &sh->state);
@@ -437,7 +437,7 @@ static void raid5_build_block (struct st
 		dev->sector = compute_blocknr(sh, i);
 }
 
-static int error(mddev_t *mddev, struct block_device *bdev)
+static int error(mddev_t *mddev, mdk_rdev_t *rdev)
 {
 	raid5_conf_t *conf = (raid5_conf_t *) mddev->private;
 	struct disk_info *disk;
@@ -446,7 +446,7 @@ static int error(mddev_t *mddev, struct 
 	PRINTK("raid5: error called\n");
 
 	for (i = 0, disk = conf->disks; i < conf->raid_disks; i++, disk++) {
-		if (disk->rdev->bdev != bdev)
+		if (disk->rdev != rdev)
 			continue;
 		if (disk->operational) {
 			disk->operational = 0;
@@ -457,7 +457,7 @@ static int error(mddev_t *mddev, struct 
 			printk (KERN_ALERT
 				"raid5: Disk failure on %s, disabling device."
 				" Operation continuing on %d devices\n",
-				bdev_partition_name(bdev), conf->working_disks);
+				bdev_partition_name(rdev->bdev), conf->working_disks);
 		}
 		return 0;
 	}
@@ -466,10 +466,10 @@ static int error(mddev_t *mddev, struct 
 	 */
 	if (conf->spare) {
 		disk = conf->spare;
-		if (disk->rdev->bdev == bdev) {
+		if (disk->rdev == rdev) {
 			printk (KERN_ALERT
 				"raid5: Disk failure on spare %s\n",
-				bdev_partition_name (bdev));
+				bdev_partition_name (rdev->bdev));
 			if (!conf->spare->operational) {
 				/* probably a SET_DISK_FAULTY ioctl */
 				return -EIO;
@@ -1001,7 +1001,7 @@ static void handle_stripe(struct stripe_
 					locked++;
 					PRINTK("Reading block %d (sync=%d)\n", i, syncing);
 					if (syncing)
-						md_sync_acct(conf->disks[i].rdev->bdev, STRIPE_SECTORS);
+						md_sync_acct(conf->disks[i].rdev, STRIPE_SECTORS);
 				}
 			}
 		}
@@ -1140,9 +1140,9 @@ static void handle_stripe(struct stripe_
 			locked++;
 			set_bit(STRIPE_INSYNC, &sh->state);
 			if (conf->disks[failed_num].operational)
-				md_sync_acct(conf->disks[failed_num].rdev->bdev, STRIPE_SECTORS);
+				md_sync_acct(conf->disks[failed_num].rdev, STRIPE_SECTORS);
 			else if ((spare=conf->spare))
-				md_sync_acct(spare->rdev->bdev, STRIPE_SECTORS);
+				md_sync_acct(spare->rdev, STRIPE_SECTORS);
 
 		}
 	}
--- ./drivers/md/raid1.c	2002/08/21 23:07:28	1.2
+++ ./drivers/md/raid1.c	2002/08/21 23:08:55	1.3
@@ -265,7 +265,7 @@ static void end_request(struct bio *bio)
 	 * this branch is our 'one mirror IO has finished' event handler:
 	 */
 	if (!uptodate)
-		md_error(r1_bio->mddev, conf->mirrors[mirror].rdev->bdev);
+		md_error(r1_bio->mddev, conf->mirrors[mirror].rdev);
 	else
 		/*
 		 * Set R1BIO_Uptodate in our master bio, so that
@@ -585,7 +585,7 @@ static void mark_disk_bad(mddev_t *mddev
 	printk(DISK_FAILED, bdev_partition_name(mirror->rdev->bdev), conf->working_disks);
 }
 
-static int error(mddev_t *mddev, struct block_device *bdev)
+static int error(mddev_t *mddev, mdk_rdev_t *rdev)
 {
 	conf_t *conf = mddev_to_conf(mddev);
 	mirror_info_t * mirrors = conf->mirrors;
@@ -600,7 +600,7 @@ static int error(mddev_t *mddev, struct 
 	 * else mark the drive as failed
 	 */
 	for (i = 0; i < disks; i++)
-		if (mirrors[i].operational && mirrors[i].rdev->bdev == bdev)
+		if (mirrors[i].operational && mirrors[i].rdev == rdev)
 			break;
 	if (i == disks)
 		return 0;
@@ -856,7 +856,7 @@ static void end_sync_read(struct bio *bi
 	 */
 	if (!uptodate)
 		md_error(r1_bio->mddev,
-			 conf->mirrors[r1_bio->read_disk].rdev->bdev);
+			 conf->mirrors[r1_bio->read_disk].rdev);
 	else
 		set_bit(R1BIO_Uptodate, &r1_bio->state);
 	reschedule_retry(r1_bio);
@@ -877,7 +877,7 @@ static void end_sync_write(struct bio *b
 			break;
 		}
 	if (!uptodate)
-		md_error(mddev, conf->mirrors[mirror].rdev->bdev);
+		md_error(mddev, conf->mirrors[mirror].rdev);
 	update_head_pos(mirror, r1_bio);
 
 	if (atomic_dec_and_test(&r1_bio->remaining)) {
@@ -959,7 +959,7 @@ static void sync_request_write(mddev_t *
 		if (!mbio)
 			continue;
 
-		md_sync_acct(mbio->bi_bdev, mbio->bi_size >> 9);
+		md_sync_acct(conf->mirrors[i].rdev, mbio->bi_size >> 9);
 		generic_make_request(mbio);
 		atomic_inc(&conf->mirrors[i].nr_pending);
 	}
@@ -1127,7 +1127,7 @@ static int sync_request(mddev_t *mddev, 
 		BUG();
 	r1_bio->read_bio = read_bio;
 
-	md_sync_acct(read_bio->bi_bdev, nr_sectors);
+	md_sync_acct(mirror->rdev, nr_sectors);
 
 	generic_make_request(read_bio);
 	atomic_inc(&conf->mirrors[conf->last_used].nr_pending);
--- ./drivers/md/multipath.c	2002/08/21 23:07:28	1.2
+++ ./drivers/md/multipath.c	2002/08/21 23:08:55	1.3
@@ -127,7 +127,7 @@ void multipath_end_request(struct bio *b
 	int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
 	struct multipath_bh * mp_bh = (struct multipath_bh *)(bio->bi_private);
 	multipath_conf_t *conf;
-	struct block_device *bdev;
+	mdk_rdev_t *rdev;
 	if (uptodate) {
 		multipath_end_bh_io(mp_bh, uptodate);
 		return;
@@ -136,10 +136,10 @@ void multipath_end_request(struct bio *b
 	 * oops, IO error:
 	 */
 	conf = mddev_to_conf(mp_bh->mddev);
-	bdev = conf->multipaths[mp_bh->path].rdev->bdev;
-	md_error (mp_bh->mddev, bdev);
+	rdev = conf->multipaths[mp_bh->path].rdev;
+	md_error (mp_bh->mddev, rdev);
 	printk(KERN_ERR "multipath: %s: rescheduling sector %lu\n", 
-		 bdev_partition_name(bdev), bio->bi_sector);
+		 bdev_partition_name(rdev->bdev), bio->bi_sector);
 	multipath_reschedule_retry(mp_bh);
 	return;
 }
@@ -225,7 +225,7 @@ static void mark_disk_bad (mddev_t *mdde
 /*
  * Careful, this can execute in IRQ contexts as well!
  */
-static int multipath_error (mddev_t *mddev, struct block_device *bdev)
+static int multipath_error (mddev_t *mddev, mdk_rdev_t *rdev)
 {
 	multipath_conf_t *conf = mddev_to_conf(mddev);
 	struct multipath_info * multipaths = conf->multipaths;
@@ -240,7 +240,7 @@ static int multipath_error (mddev_t *mdd
 		 * which has just failed.
 		 */
 		for (i = 0; i < disks; i++) {
-			if (multipaths[i].rdev->bdev == bdev && !multipaths[i].operational)
+			if (multipaths[i].rdev == rdev && !multipaths[i].operational)
 				return 0;
 		}
 		printk (LAST_DISK);
@@ -250,7 +250,7 @@ static int multipath_error (mddev_t *mdd
 		 * Mark disk as unusable
 		 */
 		for (i = 0; i < disks; i++) {
-			if (multipaths[i].rdev->bdev == bdev && multipaths[i].operational) {
+			if (multipaths[i].rdev == rdev && multipaths[i].operational) {
 				mark_disk_bad(mddev, i);
 				break;
 			}
