From: Tyler <pml@dtbb.net>
Subject: Re: [PATCH] proactive raid5 disk replacement for 2.6.11, updated
Date: Wed, 17 Aug 2005 18:55:53 -0700
Message-ID: <4303EAA9.3080201@dtbb.net>
References: <1124322731.3810.77.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1124322731.3810.77.camel@localhost.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Pallai Roland <dap@mail.index.hu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I think some of these features are great :)  When you get into 15+ 
device raids, this becomes a very active issue.

Tyler.

Pallai Roland wrote:

> per-device bad block cache has been implemented to speed up arrays with
>partially failed drives (replies are often slow from those). also
>helps to determine badly damaged drives based on number of bad blocks,
>and can take an action if steps over an user defined threshold
>(see /proc/sys/dev/raid/badblock_tolerance).
>rewrite of a bad stripe will delete the entry from the cache, so it
>honors the auto sector reallocation feature of ATA drives
>
> performance is affected just a little bit if there's no or some
>registered bad blocks, but over a million that could be a problem
>currently, I'll examine it later..
>
> if we've a spare and a drive had kicked, that spare becomes to 'active
>spare', sync begins, but the original (failed) drive won't be kicked
>until the sync will not have finished. if the original drive still drops
>errors after had been synced, the in_sync spare replaces that online
>otherwise you can do it manually (mdadm -f)
>
> you can check the list of registered bad sectors in /proc/mdstat (in
>debug mode), and the size of the cache with: grep _bbc /proc/slabinfo
>
>
> please let me know if you're interested in, otherwise I'll not flood
>the list with this topic..
>
>
>my /proc/mdstat now:
>
>md0 : active raid5 ram4[2] md2[1] md1[0]
>      8064 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]
>      known bad sectors on active devices:
>      ram4
>      md2
>      md1 56 136 232 472 600 872 1176 1248 1336 1568 1688 1952 2104
>
>md2 : active faulty ram1[0]
>      4096 blocks nfaults=0
>      
>md1 : active faulty ram0[0]
>      4096 blocks ReadPersistent=92(100) nfaults=13
>
>
>--
> dap
>
>
>  
>
>------------------------------------------------------------------------
>
>
> this is a feature patch that implements 'proactive raid5 disk
>replacement' (http://www.arctic.org/~dean/raid-wishlist.html),
>that could help a lot on large raid5 arrays built from cheap sata
>drivers when the IO traffic such large that daily media scan on the
>disks isn't possible.
> linux software raid is very fragile by default, the typical (nervous)
>breakdown situation: I noticed a bad block on a drive, replace it,
>and the resync fails cause another 2-3 disks has hidden badblocks too.
>I've to save the disks and rebuild bad blocks with a userspace tool (by
>hand..), meanwhile the site is down for hours. bad; especially when a
>pair of simple steps enough to avoid from this atypical problem:
> 1. dont kick a drive on read error cause it is possible that 99.99% is
>useable and will help (to serve and to save data) if another drive show
>bad sectors in same array
> 2. let to mirror a partially failed drive to a spare _online_ and replace
>the source of the mirror with the spare when it's done. bad blocks isn't
>a problem unless same sector damaged on two disks what's a rare case. in
>this way is possible to fix an array with partially failed drives
>without data loss and without downtime
>
> I'm not a programmer just a sysadm who admins a large software sata
>array, but my angry got bigger than my laziness, so I made this patch on
>this weekend.. I don't understand every piece of the md code (eg. the
>if-forest of the handle_stripe :) yet, so this patch may be a bug-colony
>and wrong by design, but I've tested it under heavy stress with both of
>'faulty' module and real disks, and it works fine!
>
> ideas, piece of advice, bugfix/enchancement is welcomed!
>
>
> (I know, raid6 could be another solution for this problem, but that's a
>large overhead.)
>
>
>use:
>
>1. patch the kernel, this one is against 2.6.11
>2. type:
>
># make drives
>mdadm -B -n1 -l faulty /dev/md/1 /dev/rd/0
>mdadm -B -n1 -l faulty /dev/md/2 /dev/rd/1
>mdadm -B -n1 -l faulty /dev/md/3 /dev/rd/2
>
># make the array
>mdadm -C -n3 -l5 /dev/md/0 /dev/md/1 /dev/md/2 /dev/md/3
>
># .. wait for sync ..
>
># grow bad blocks as ma*tor does
>mdadm --grow -l faulty -p rp454 /dev/md/1
>mdadm --grow -l faulty -p rp738 /dev/md/2
>
># add a spare
>mdadm -a /dev/md/0 /dev/rd/4
>
># -> fail a drive, sync begins <-
>#  the md/1 will not marked as failed, this is the point, but if you want to,
>#  you can issue this command again!
>mdadm -f /dev/md/0 /dev/md/1
>
># kernel:
>#  resync from md1 to spare ram4
>#  added spare for active resync
>
># .. wonder the read errors from md[12] and the sync goes on!
># feel free to stress the md at this time, mkfs, dd, badblocks, etc
>
># kernel:
>#  raid5_spare_active: 3 in_sync 3->0
># /proc/mdstat:
>#  md0 : active raid5 ram4[0] md3[2] md2[1] md1[0]
># -> ram4 and md1 has same id, this means the spare is a complete mirror,
>#       if you stop the array you can assembly it with ram4 instead of md1,
>#       the superblock same both of them
>
># check the mirror (stop write stress if any)
>mdadm --grow -l faulty -p none /dev/md/1
>cmp /dev/md/1 /dev/rd/4
>
># hot-replace the mirrored -partially failed- device with the active spare
>#  (yes, mark it as failed again, but if there's a syncing- or synced 'active spare'
>#       the -f really fails the device or replace it with the synced spare)
>mdadm -f /dev/md/0 /dev/md/1
>
># kernel:
>#  replace md1 with in_sync active spare ram4
>
># and voila!
># /proc/mdstat:
>#  md0 : active raid5 ram4[0] md3[2] md2[1]
>
>
>update:
>
> per-device bad block cache has been implemented to speed up arrays with
>partially failed drives (replies are often slow from those). also
>helps to determine badly damaged drives based on number of bad blocks,
>and can take an action if steps over an user defined threshold
>(see /proc/sys/dev/raid/badblock_tolerance).
>rewrite of a bad stripe will delete the entry from the cache, so it honors
>the auto sector reallocation feature of ATA drives
>
> performance is affected just a little bit if there's no or some registered
>bad blocks, but over a million that could be a problem currently, I'll examine
>it later..
>
> if we've a spare and a drive had kicked, that spare becomes to
>'active spare', sync begins, but the original (failed) drive won't be
>kicked until the sync will not have finished. if the original drive still
>drops errors after had been synced, the in_sync spare replaces that online
>
> you can check the list of registered bad sectors in /proc/mdstat (in debug mode),
>and the size of the cache with: grep _bbc /proc/slabinfo
>
>
>my /proc/mdstat:
>
>md0 : active raid5 ram4[2] md2[1] md1[0]
>      8064 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]
>      known bad sectors on active devices:
>      ram4
>      md2
>      md1 56 136 232 472 600 872 1176 1248 1336 1568 1688 1952 2104
>
>md2 : active faulty ram1[0]
>      4096 blocks nfaults=0
>      
>md1 : active faulty ram0[0]
>      4096 blocks ReadPersistent=92(100) nfaults=13
>      
>
>
>--- linux/include/linux/raid/raid5.h.orig	2005-03-03 23:51:29.000000000 +0100
>+++ linux/include/linux/raid/raid5.h	2005-08-14 03:02:11.000000000 +0200
>@@ -147,6 +147,7 @@
> #define	R5_UPTODATE	0	/* page contains current data */
> #define	R5_LOCKED	1	/* IO has been submitted on "req" */
> #define	R5_OVERWRITE	2	/* towrite covers whole page */
>+#define	R5_FAILED	8	/* failed to read this stripe */
> /* and some that are internal to handle_stripe */
> #define	R5_Insync	3	/* rdev && rdev->in_sync at start */
> #define	R5_Wantread	4	/* want to schedule a read */
>@@ -196,8 +197,16 @@
>  */
>  
> 
>+struct badblock {
>+	struct badblock		*hash_next, **hash_pprev; /* hash pointers */
>+	sector_t		sector; /* stripe # */
>+};
>+
> struct disk_info {
> 	mdk_rdev_t	*rdev;
>+	struct badblock **badblock_hashtbl; /* list of known badblocks */
>+	char		cache_name[20];
>+	kmem_cache_t	*slab_cache; /* badblock db */
> };
> 
> struct raid5_private_data {
>@@ -224,6 +233,8 @@
> 	int			inactive_blocked;	/* release of inactive stripes blocked,
> 							 * waiting for 25% to be free
> 							 */        
>+	int			mirrorit; /* source for active spare resync */
>+
> 	spinlock_t		device_lock;
> 	struct disk_info	disks[0];
> };
>--- linux/include/linux/sysctl.h.orig	2005-07-06 20:19:10.000000000 +0200
>+++ linux/include/linux/sysctl.h	2005-08-17 22:01:28.000000000 +0200
>@@ -778,7 +778,8 @@
> /* /proc/sys/dev/raid */
> enum {
> 	DEV_RAID_SPEED_LIMIT_MIN=1,
>-	DEV_RAID_SPEED_LIMIT_MAX=2
>+	DEV_RAID_SPEED_LIMIT_MAX=2,
>+	DEV_RAID_BADBLOCK_TOLERANCE=3
> };
> 
> /* /proc/sys/dev/parport/default */
>--- linux/drivers/md/md.c.orig	2005-08-14 21:22:08.000000000 +0200
>+++ linux/drivers/md/md.c	2005-08-14 17:20:15.000000000 +0200
>@@ -78,6 +78,10 @@
> static int sysctl_speed_limit_min = 1000;
> static int sysctl_speed_limit_max = 200000;
> 
>+/* over this limit the drive'll be marked as failed. measure is block. */
>+int sysctl_badblock_tolerance = 10000;
>+
>+
> static struct ctl_table_header *raid_table_header;
> 
> static ctl_table raid_table[] = {
>@@ -97,6 +101,14 @@
> 		.mode		= 0644,
> 		.proc_handler	= &proc_dointvec,
> 	},
>+	{
>+		.ctl_name	= DEV_RAID_BADBLOCK_TOLERANCE,
>+		.procname	= "badblock_tolerance",
>+		.data		= &sysctl_badblock_tolerance,
>+		.maxlen		= sizeof(int),
>+		.mode		= 0644,
>+		.proc_handler	= &proc_dointvec,
>+	},
> 	{ .ctl_name = 0 }
> };
> 
>@@ -3525,10 +3537,12 @@
> 		}
> 		if (mddev->sync_thread) {
> 			/* resync has finished, collect result */
>+printk("md_check_recovery: resync has finished\n");
> 			md_unregister_thread(mddev->sync_thread);
> 			mddev->sync_thread = NULL;
> 			if (!test_bit(MD_RECOVERY_ERR, &mddev->recovery) &&
> 			    !test_bit(MD_RECOVERY_INTR, &mddev->recovery)) {
>+printk("md_check_recovery: activate any spares\n");
> 				/* success...*/
> 				/* activate any spares */
> 				mddev->pers->spare_active(mddev);
>@@ -3545,18 +3559,19 @@
> 
> 		/* no recovery is running.
> 		 * remove any failed drives, then
>-		 * add spares if possible
>+		 * add spares if possible.
>+		 * Spare are also removed and re-added, to allow
>+		 * the personality to fail the re-add.
> 		 */
>-		ITERATE_RDEV(mddev,rdev,rtmp) {
>+		ITERATE_RDEV(mddev,rdev,rtmp)
> 			if (rdev->raid_disk >= 0 &&
>-			    rdev->faulty &&
>+			    (rdev->faulty || ! rdev->in_sync) &&
> 			    atomic_read(&rdev->nr_pending)==0) {
>+printk("md_check_recovery: hot_remove_disk\n");
> 				if (mddev->pers->hot_remove_disk(mddev, rdev->raid_disk)==0)
> 					rdev->raid_disk = -1;
> 			}
>-			if (!rdev->faulty && rdev->raid_disk >= 0 && !rdev->in_sync)
>-				spares++;
>-		}
>+
> 		if (mddev->degraded) {
> 			ITERATE_RDEV(mddev,rdev,rtmp)
> 				if (rdev->raid_disk < 0
>@@ -3764,4 +3783,6 @@
> EXPORT_SYMBOL(md_wakeup_thread);
> EXPORT_SYMBOL(md_print_devices);
> EXPORT_SYMBOL(md_check_recovery);
>+EXPORT_SYMBOL(kick_rdev_from_array);	// fixme
>+EXPORT_SYMBOL(sysctl_badblock_tolerance);
> MODULE_LICENSE("GPL");
>--- linux/drivers/md/raid5.c.orig	2005-08-14 21:22:08.000000000 +0200
>+++ linux/drivers/md/raid5.c	2005-08-14 20:49:49.000000000 +0200
>@@ -40,6 +40,18 @@
> 
> #define stripe_hash(conf, sect)	((conf)->stripe_hashtbl[((sect) >> STRIPE_SHIFT) & HASH_MASK])
> 
>+ /*
>+ * per-device badblock cache
>+ */
>+
>+#define	BB_SHIFT		(PAGE_SHIFT/*12*/ - 9)
>+#define	BB_HASH_PAGES		1
>+#define	BB_NR_HASH		(HASH_PAGES * PAGE_SIZE / sizeof(struct badblock *))
>+#define	BB_HASH_MASK		(BB_NR_HASH - 1)
>+
>+#define	bb_hash(disk, sect)	((disk)->badblock_hashtbl[((sect) >> BB_SHIFT) & BB_HASH_MASK])
>+#define	bb_hashnr(sect)		(((sect) >> BB_SHIFT) & BB_HASH_MASK)
>+
> /* bio's attached to a stripe+device for I/O are linked together in bi_sector
>  * order without overlap.  There may be several bio's per stripe+device, and
>  * a bio could span several devices.
>@@ -53,7 +65,7 @@
> /*
>  * The following can be used to debug the driver
>  */
>-#define RAID5_DEBUG	0
>+#define RAID5_DEBUG	1
> #define RAID5_PARANOIA	1
> #if RAID5_PARANOIA && defined(CONFIG_SMP)
> # define CHECK_DEVLOCK() assert_spin_locked(&conf->device_lock)
>@@ -61,13 +73,159 @@
> # define CHECK_DEVLOCK()
> #endif
> 
>-#define PRINTK(x...) ((void)(RAID5_DEBUG && printk(x)))
>+#define PRINTK(x...) ((void)(RAID5_DEBUG && printk(KERN_DEBUG x)))
> #if RAID5_DEBUG
> #define inline
> #define __inline__
> #endif
> 
> static void print_raid5_conf (raid5_conf_t *conf);
>+extern int sysctl_badblock_tolerance;
>+
>+
>+static void bb_insert_hash(struct disk_info *disk, struct badblock *bb)
>+{
>+	struct badblock **bbp = &bb_hash(disk, bb->sector);
>+
>+	/*printk("bb_insert_hash(), sector %llu hashnr %lu\n", (unsigned long long)bb->sector,
>+		bb_hashnr(bb->sector));*/
>+
>+	if ((bb->hash_next = *bbp) != NULL)
>+		(*bbp)->hash_pprev = &bb->hash_next;
>+	*bbp = bb;	
>+	bb->hash_pprev = bbp;
>+}
>+
>+static void bb_remove_hash(struct badblock *bb)
>+{
>+	/*printk("remove_hash(), sector %llu hashnr %lu\n", (unsigned long long)bb->sector,
>+		bb_hashnr(bb->sector));*/
>+
>+	if (bb->hash_pprev) {
>+		if (bb->hash_next)
>+			bb->hash_next->hash_pprev = bb->hash_pprev;
>+		*bb->hash_pprev = bb->hash_next;
>+		bb->hash_pprev = NULL;
>+	}
>+}
>+
>+static struct badblock *__find_badblock(struct disk_info *disk, sector_t sector)
>+{
>+	struct badblock *bb;
>+
>+	for (bb = bb_hash(disk, sector); bb; bb = bb->hash_next)
>+		if (bb->sector == sector)
>+			return bb;
>+	return NULL;
>+}
>+
>+static struct badblock *find_badblock(struct disk_info *disk, sector_t sector)
>+{
>+	raid5_conf_t *conf = (raid5_conf_t *) disk->rdev->mddev->private;
>+	struct badblock *bb;
>+
>+	spin_lock_irq(&conf->device_lock);
>+	bb = __find_badblock(disk, sector);
>+	spin_unlock_irq(&conf->device_lock);
>+	return bb;
>+}
>+
>+static unsigned long count_badblocks (struct disk_info *disk)
>+{
>+	raid5_conf_t *conf = (raid5_conf_t *) disk->rdev->mddev->private;
>+	struct badblock *bb;
>+	int j;
>+	int n = 0;
>+
>+	spin_lock_irq(&conf->device_lock);
>+	for (j = 0; j < BB_NR_HASH; j++) {
>+		bb = disk->badblock_hashtbl[j];
>+		for (; bb; bb = bb->hash_next)
>+			n++;
>+	}
>+	spin_unlock_irq(&conf->device_lock);
>+
>+	return n;
>+}
>+
>+static int grow_badblocks(struct disk_info *disk)
>+{
>+	char b[BDEVNAME_SIZE];
>+	kmem_cache_t *sc;
>+
>+	/* hash table */
>+	if ((disk->badblock_hashtbl = (struct badblock **) __get_free_pages(GFP_ATOMIC, HASH_PAGES_ORDER)) == NULL) {
>+	    printk("grow_badblocks: __get_free_pages failed\n");
>+	    return 0;
>+	}
>+	memset(disk->badblock_hashtbl, 0, BB_HASH_PAGES * PAGE_SIZE);
>+
>+	/* badblocks db */
>+	sprintf(disk->cache_name, "raid5/%s_%s_bbc", mdname(disk->rdev->mddev),
>+			bdevname(disk->rdev->bdev, b));
>+	sc = kmem_cache_create(disk->cache_name,
>+			       sizeof(struct badblock),
>+			       0, 0, NULL, NULL);
>+	if (!sc) {
>+		printk("grow_badblocks: kmem_cache_create failed\n");
>+		return 1;
>+	}
>+	disk->slab_cache = sc;
>+
>+	return 0;
>+}
>+
>+static void shrink_badblocks(struct disk_info *disk)
>+{
>+	struct badblock *bb;
>+	int j;
>+
>+	/* badblocks db */
>+	for (j = 0; j < BB_NR_HASH; j++) {
>+		bb = disk->badblock_hashtbl[j];
>+		for (; bb; bb = bb->hash_next)
>+		        kmem_cache_free(disk->slab_cache, bb);
>+	}
>+	kmem_cache_destroy(disk->slab_cache);
>+	disk->slab_cache = NULL;
>+
>+	/* hash table */
>+	free_pages((unsigned long) disk->badblock_hashtbl, HASH_PAGES_ORDER);
>+}
>+
>+static void store_badblock(struct disk_info *disk, sector_t sector)
>+{
>+	struct badblock *bb;
>+	raid5_conf_t *conf = (raid5_conf_t *) disk->rdev->mddev->private;
>+
>+	bb = kmem_cache_alloc(disk->slab_cache, GFP_KERNEL);
>+	if (!bb) {
>+		printk("store_badblock: kmem_cache_alloc failed\n");
>+		return;
>+	}
>+	memset(bb, 0, sizeof(*bb));
>+	bb->sector = sector;
>+
>+	spin_lock_irq(&conf->device_lock);
>+	bb_insert_hash(disk, bb);
>+	spin_unlock_irq(&conf->device_lock);
>+}
>+
>+static void delete_badblock(struct disk_info *disk, sector_t sector)
>+{
>+	struct badblock *bb;
>+	raid5_conf_t *conf = (raid5_conf_t *) disk->rdev->mddev->private;
>+
>+	bb = find_badblock(disk, sector);
>+	if (!bb)
>+		/* reset on write'll call us like an idiot :} */
>+		return;
>+	spin_lock_irq(&conf->device_lock);
>+	bb_remove_hash(bb);
>+	kmem_cache_free(disk->slab_cache, bb);
>+	spin_unlock_irq(&conf->device_lock);
>+}
>+
> 
> static inline void __release_stripe(raid5_conf_t *conf, struct stripe_head *sh)
> {
>@@ -201,7 +359,7 @@
> 	sh->pd_idx = pd_idx;
> 	sh->state = 0;
> 
>-	for (i=disks; i--; ) {
>+	for (i=disks+1; i--; ) {
> 		struct r5dev *dev = &sh->dev[i];
> 
> 		if (dev->toread || dev->towrite || dev->written ||
>@@ -291,8 +449,10 @@
> 
> 	sprintf(conf->cache_name, "raid5/%s", mdname(conf->mddev));
> 
>+	/* +1: we need extra space in the *sh->devs for the 'active spare' to keep
>+	    handle_stripe() simple */
> 	sc = kmem_cache_create(conf->cache_name, 
>-			       sizeof(struct stripe_head)+(devs-1)*sizeof(struct r5dev),
>+			       sizeof(struct stripe_head)+(devs-1+1)*sizeof(struct r5dev),
> 			       0, 0, NULL, NULL);
> 	if (!sc)
> 		return 1;
>@@ -301,12 +461,12 @@
> 		sh = kmem_cache_alloc(sc, GFP_KERNEL);
> 		if (!sh)
> 			return 1;
>-		memset(sh, 0, sizeof(*sh) + (devs-1)*sizeof(struct r5dev));
>+		memset(sh, 0, sizeof(*sh) + (devs-1+1)*sizeof(struct r5dev));
> 		sh->raid_conf = conf;
> 		spin_lock_init(&sh->lock);
> 
>-		if (grow_buffers(sh, conf->raid_disks)) {
>-			shrink_buffers(sh, conf->raid_disks);
>+		if (grow_buffers(sh, conf->raid_disks+1)) {
>+			shrink_buffers(sh, conf->raid_disks+1);
> 			kmem_cache_free(sc, sh);
> 			return 1;
> 		}
>@@ -391,10 +551,39 @@
> 		}
> #else
> 		set_bit(R5_UPTODATE, &sh->dev[i].flags);
>+		clear_bit(R5_FAILED, &sh->dev[i].flags);
> #endif		
> 	} else {
>+	    char b[BDEVNAME_SIZE];
>+
>+	    /*
>+		rule 1.,: try to keep all disk in_sync even if we've got read errors,
>+		cause the 'active spare' may can rebuild a complete column from
>+		partially failed drives
>+	    */
>+	    if (conf->disks[i].rdev->in_sync && conf->working_disks < conf->raid_disks) {
>+		/* bad news, but keep it, cause md_error() would do a complete
>+		    array shutdown, even if 99.99% is useable */
>+		printk(KERN_ALERT
>+			"raid5_end_read_request: Read failure %s on sector %llu (%d) in degraded mode\n"
>+			,bdevname(conf->disks[i].rdev->bdev, b),
>+			(unsigned long long)sh->sector, atomic_read(&sh->count));
>+		if (conf->mddev->curr_resync)
>+		    /* raid5_add_disk() will no accept the spare again,
>+			and will not loop forever */
>+		    conf->mddev->degraded = 2;
>+	    } else if (conf->disks[i].rdev->in_sync && conf->working_disks >= conf->raid_disks) {
>+		/* will be computed */
>+		printk(KERN_ALERT
>+			"raid5_end_read_request: Read failure %s on sector %llu (%d) in optimal mode\n"
>+			,bdevname(conf->disks[i].rdev->bdev, b),
>+			(unsigned long long)sh->sector, atomic_read(&sh->count));
>+		/* conf->disks[i].rerr++ */
>+	    } else
>+		/* practically it never happens */
> 		md_error(conf->mddev, conf->disks[i].rdev);
>-		clear_bit(R5_UPTODATE, &sh->dev[i].flags);
>+	    clear_bit(R5_UPTODATE, &sh->dev[i].flags);
>+	    set_bit(R5_FAILED, &sh->dev[i].flags);
> 	}
> 	rdev_dec_pending(conf->disks[i].rdev, conf->mddev);
> #if 0
>@@ -430,10 +619,11 @@
> 	PRINTK("end_write_request %llu/%d, count %d, uptodate: %d.\n", 
> 		(unsigned long long)sh->sector, i, atomic_read(&sh->count),
> 		uptodate);
>+	/* sorry
> 	if (i == disks) {
> 		BUG();
> 		return 0;
>-	}
>+	}*/
> 
> 	spin_lock_irqsave(&conf->device_lock, flags);
> 	if (!uptodate)
>@@ -467,33 +657,144 @@
> 	dev->req.bi_private = sh;
> 
> 	dev->flags = 0;
>-	if (i != sh->pd_idx)
>+	if (i != sh->pd_idx && i < sh->raid_conf->raid_disks)	/* active spare? */
> 		dev->sector = compute_blocknr(sh, i);
> }
> 
>+static int raid5_remove_disk(mddev_t *mddev, int number);
>+static int raid5_add_disk(mddev_t *mddev, mdk_rdev_t *rdev);
>+/*static*/ void kick_rdev_from_array(mdk_rdev_t * rdev);
>+//static void md_update_sb(mddev_t * mddev);
> static void error(mddev_t *mddev, mdk_rdev_t *rdev)
> {
> 	char b[BDEVNAME_SIZE];
>+	char b2[BDEVNAME_SIZE];
> 	raid5_conf_t *conf = (raid5_conf_t *) mddev->private;
> 	PRINTK("raid5: error called\n");
> 
> 	if (!rdev->faulty) {
>-		mddev->sb_dirty = 1;
>-		if (rdev->in_sync) {
>-			conf->working_disks--;
>-			mddev->degraded++;
>-			conf->failed_disks++;
>-			rdev->in_sync = 0;
>-			/*
>-			 * if recovery was running, make sure it aborts.
>-			 */
>-			set_bit(MD_RECOVERY_ERR, &mddev->recovery);
>-		}
>-		rdev->faulty = 1;
>-		printk (KERN_ALERT
>-			"raid5: Disk failure on %s, disabling device."
>-			" Operation continuing on %d devices\n",
>-			bdevname(rdev->bdev,b), conf->working_disks);
>+		int mddisks = 0;
>+		mdk_rdev_t *rd;
>+		mdk_rdev_t *rdevs = NULL;
>+		struct list_head *rtmp;
>+		int i;
>+
>+		ITERATE_RDEV(mddev,rd,rtmp)
>+		    {
>+			printk(KERN_INFO "mddev%d: %s\n", mddisks, bdevname(rd->bdev,b));
>+			mddisks++;
>+		    }
>+		for (i = 0; (rd = conf->disks[i].rdev); i++) {
>+			printk(KERN_INFO "r5dev%d: %s\n", i, bdevname(rd->bdev,b));
>+		}
>+		ITERATE_RDEV(mddev,rd,rtmp)
>+		    {
>+			rdevs = rd;
>+			break;
>+		    }
>+printk("%d %d > %d %d ins:%d %p\n",
>+	mddev->raid_disks, mddisks, conf->raid_disks, mddev->degraded, rdev->in_sync, rdevs);
>+		if (conf->disks[conf->raid_disks].rdev == rdev && rdev->in_sync) {
>+		    /* in_sync, but must be handled specially, don't let 'degraded++' */
>+		    printk ("active spare failed %s (in_sync)\n",
>+				bdevname(rdev->bdev,b));
>+		    mddev->sb_dirty = 1;
>+		    rdev->in_sync = 0;
>+		    rdev->faulty = 1;
>+		    rdev->raid_disk = conf->raid_disks;		/* me as myself, again ;) */
>+		    conf->mirrorit = -1;
>+		} else if (mddisks > conf->raid_disks && !mddev->degraded && rdev->in_sync) {
>+		    /* have active spare, array is optimal, removed disk member
>+			    of it (but not the active spare) */
>+		    if (rdev->raid_disk == conf->mirrorit && conf->disks[conf->raid_disks].rdev) {
>+			if (!conf->disks[conf->raid_disks].rdev->in_sync) {
>+			    printk(KERN_ALERT "disk %s failed and active spare isn't in_sync yet, readd as normal spare\n",
>+					bdevname(rdev->bdev,b));
>+			    /* maybe shouldn't stop here, but we can't call this disk as
>+				'active spare' anymore, cause it's a simple rebuild from
>+				a degraded array, fear of bad blocks! */
>+			    conf->mirrorit = -1;
>+			    goto letitgo;
>+			} else {
>+			    int ret;
>+
>+			    /* hot replace the mirrored drive with the 'active spare'
>+				this is really "hot", I can't see clearly the things
>+				what I have to do here. :}
>+				pray. */
>+
>+			    printk(KERN_ALERT "replace %s with in_sync active spare %s\n",
>+				    bdevname(rdev->bdev,b),
>+				    bdevname(rdevs->bdev,b2));
>+			    rdev->in_sync = 0;
>+			    rdev->faulty = 1;
>+
>+			    conf->mirrorit = -1;
>+
>+			    /* my God, am I sane? */
>+			    while ((i = atomic_read(&rdev->nr_pending))) {
>+				printk("waiting for disk %d .. %d\n",
>+					rdev->raid_disk, i);
>+			    }
>+			    ret = raid5_remove_disk(mddev, rdev->raid_disk);
>+			    if (ret) {
>+				printk(KERN_WARNING "raid5_remove_disk1: busy?!\n");
>+				return;	// should nothing to do
>+			    }
>+
>+			    rd = conf->disks[conf->raid_disks].rdev;
>+			    while ((i = atomic_read(&rd->nr_pending))) {
>+				printk("waiting for disk %d .. %d\n",
>+					conf->raid_disks, i);
>+			    }
>+			    rd->in_sync = 0;
>+			    ret = raid5_remove_disk(mddev, conf->raid_disks);
>+			    if (ret) {
>+				printk(KERN_WARNING "raid5_remove_disk2: busy?!\n");
>+				return;	// ..
>+			    }
>+
>+			    ret = raid5_add_disk(mddev, rd);
>+			    if (!ret) {
>+				printk(KERN_WARNING "raid5_add_disk: no free slot?!\n");
>+				return;	// ..
>+			    }
>+			    rd->in_sync = 1;
>+
>+			    /* borrowed from hot_remove_disk() */
>+			    kick_rdev_from_array(rdev);
>+			    //md_update_sb(mddev);
>+			}
>+		    } else {
>+			/* in_sync disk failed (!degraded), trying to make a copy
>+			    to a spare {and we can call it 'active spare' from now:} */
>+			printk(KERN_ALERT "resync from %s to spare %s (%d)\n",
>+				bdevname(rdev->bdev,b),
>+			        bdevname(rdevs->bdev,b2),
>+				conf->raid_disks);
>+			conf->mirrorit = rdev->raid_disk;
>+
>+			mddev->degraded++;	/* for call raid5_hot_add_disk(), reset there */
>+		    }
>+		} else {
>+letitgo:
>+		    mddev->sb_dirty = 1;
>+		    if (rdev->in_sync) {
>+			    conf->working_disks--;
>+			    mddev->degraded++;
>+			    conf->failed_disks++;
>+			    rdev->in_sync = 0;
>+			    /*
>+			     * if recovery was running, make sure it aborts.
>+			     */
>+			    set_bit(MD_RECOVERY_ERR, &mddev->recovery);
>+		    }
>+		    rdev->faulty = 1;
>+		    printk (KERN_ALERT
>+			    "raid5: Disk failure on %s, disabling device."
>+			    " Operation continuing on %d devices\n",
>+			    bdevname(rdev->bdev,b), conf->working_disks);
>+		}
> 	}
> }	
> 
>@@ -888,6 +1189,8 @@
> 	int locked=0, uptodate=0, to_read=0, to_write=0, failed=0, written=0;
> 	int non_overwrite = 0;
> 	int failed_num=0;
>+	int aspare=0, asparenum=-1;
>+	struct disk_info *asparedev;
> 	struct r5dev *dev;
> 
> 	PRINTK("handling stripe %llu, cnt=%d, pd_idx=%d\n",
>@@ -899,10 +1202,18 @@
> 	clear_bit(STRIPE_DELAYED, &sh->state);
> 
> 	syncing = test_bit(STRIPE_SYNCING, &sh->state);
>+	asparedev = &conf->disks[conf->raid_disks];
>+	if (!conf->mddev->degraded && asparedev->rdev && !asparedev->rdev->faulty &&
>+		conf->mirrorit != -1) {
>+	    aspare++;
>+	    asparenum = sh->raid_conf->mirrorit;
>+	    PRINTK("has aspare (%d)\n", asparenum);
>+	}
> 	/* Now to look around and see what can be done */
> 
>-	for (i=disks; i--; ) {
>+	for (i=disks+aspare; i--; ) {
> 		mdk_rdev_t *rdev;
>+		struct badblock *bb = NULL;
> 		dev = &sh->dev[i];
> 		clear_bit(R5_Insync, &dev->flags);
> 		clear_bit(R5_Syncio, &dev->flags);
>@@ -945,12 +1256,43 @@
> 		}
> 		if (dev->written) written++;
> 		rdev = conf->disks[i].rdev; /* FIXME, should I be looking rdev */
>-		if (!rdev || !rdev->in_sync) {
>+		if (rdev && rdev->in_sync &&
>+		    !test_bit(R5_UPTODATE, &dev->flags) &&
>+		    !test_bit(R5_LOCKED, &dev->flags)) {
>+			/* ..potentially deserved to read, we must check it
>+			    checkme, it could be a big performance penalty if called
>+				without a good reason! it's seems ok for now
>+			*/
>+			PRINTK("find_badblock %d: %llu\n", i, sh->sector);
>+			bb = find_badblock(&conf->disks[i], sh->sector);
>+		}
>+		if (!rdev || !rdev->in_sync
>+		    || (test_bit(R5_FAILED, &dev->flags) && !test_bit(R5_UPTODATE, &dev->flags))
>+		    || bb) {
>+			if (rdev && rdev->in_sync && test_bit(R5_FAILED, &dev->flags) && !bb) {
>+				if (/*(!aspare || (aspare && asparedev->rdev->in_sync)) &&
>+				    it would be clear, but too early, the thread hasn't woken, yet */
>+				    conf->mirrorit == -1 &&
>+				    count_badblocks(&conf->disks[i]) >= sysctl_badblock_tolerance) {
>+					char b[BDEVNAME_SIZE];
>+
>+					printk(KERN_ALERT "too many badblocks (%lu) on device %s, marking as failed\n",
>+						    count_badblocks(&conf->disks[i]) + 1, bdevname(conf->disks[i].rdev->bdev, b));
>+					md_error(conf->mddev, conf->disks[i].rdev);
>+				}
>+				PRINTK("store_badblock %d: %llu\n", i, sh->sector);
>+				store_badblock(&conf->disks[i], sh->sector);
>+			}
> 			failed++;
> 			failed_num = i;
>-		} else
>+			PRINTK("device %d failed for this stripe r%p w%p\n", i, dev->toread, dev->towrite);
>+		} else {
> 			set_bit(R5_Insync, &dev->flags);
>+		}
> 	}
>+	if (aspare && failed > 1)
>+	    failed--;	/* failed = 1 means "all ok" if we've aspare, this is simplest
>+			    method to do our work */
> 	PRINTK("locked=%d uptodate=%d to_read=%d"
> 		" to_write=%d failed=%d failed_num=%d\n",
> 		locked, uptodate, to_read, to_write, failed, failed_num);
>@@ -1013,6 +1355,7 @@
> 		spin_unlock_irq(&conf->device_lock);
> 	}
> 	if (failed > 1 && syncing) {
>+		printk(KERN_ALERT "sync stopped by IO error\n");
> 		md_done_sync(conf->mddev, STRIPE_SECTORS,0);
> 		clear_bit(STRIPE_SYNCING, &sh->state);
> 		syncing = 0;
>@@ -1184,6 +1527,26 @@
> 					PRINTK("Writing block %d\n", i);
> 					locked++;
> 					set_bit(R5_Wantwrite, &sh->dev[i].flags);
>+					if (aspare && i == asparenum) {
>+					    char *ps, *pd;
>+
>+					    /* mirroring this new block */
>+					    PRINTK("Writing to aspare too %d->%d\n",
>+							i, conf->raid_disks);
>+					    /*if (test_bit(R5_LOCKED, &sh->dev[conf->raid_disks].flags)) {
>+						printk("bazmeg, ez lokkolt1!!!\n");
>+					    }*/
>+					    ps = page_address(sh->dev[i].page);
>+					    pd = page_address(sh->dev[conf->raid_disks].page);
>+					    /* better idea? */
>+					    memcpy(pd, ps, STRIPE_SIZE);
>+					    set_bit(R5_LOCKED, &sh->dev[conf->raid_disks].flags);
>+					    set_bit(R5_Wantwrite, &sh->dev[conf->raid_disks].flags);
>+					}
>+					if (conf->disks[i].rdev && conf->disks[i].rdev->in_sync) {
>+					    PRINTK("reset badblock on %d: %llu\n", i, sh->sector);
>+					    delete_badblock(&conf->disks[i], sh->sector);
>+					}
> 					if (!test_bit(R5_Insync, &sh->dev[i].flags)
> 					    || (i==sh->pd_idx && failed == 0))
> 						set_bit(STRIPE_INSYNC, &sh->state);
>@@ -1220,20 +1583,39 @@
> 			if (failed==0)
> 				failed_num = sh->pd_idx;
> 			/* should be able to compute the missing block and write it to spare */
>+			if (aspare)
>+			    failed_num = asparenum;
> 			if (!test_bit(R5_UPTODATE, &sh->dev[failed_num].flags)) {
> 				if (uptodate+1 != disks)
> 					BUG();
> 				compute_block(sh, failed_num);
> 				uptodate++;
> 			}
>+			if (aspare) {
>+			    char *ps, *pd;
>+
>+			    ps = page_address(sh->dev[failed_num].page);
>+			    pd = page_address(sh->dev[conf->raid_disks].page);
>+			    memcpy(pd, ps, STRIPE_SIZE);
>+			    PRINTK("R5_Wantwrite to aspare, uptodate: %d %p->%p\n",
>+					uptodate, ps, pd);
>+			    /*if (test_bit(R5_LOCKED, &sh->dev[conf->raid_disks].flags)) {
>+				printk("bazmeg, ez lokkolt2!!!\n");
>+			    }*/
>+			}
> 			if (uptodate != disks)
> 				BUG();
>+			if (aspare)
>+			    failed_num = conf->raid_disks;
> 			dev = &sh->dev[failed_num];
> 			set_bit(R5_LOCKED, &dev->flags);
> 			set_bit(R5_Wantwrite, &dev->flags);
> 			locked++;
> 			set_bit(STRIPE_INSYNC, &sh->state);
> 			set_bit(R5_Syncio, &dev->flags);
>+			/* !in_sync..
>+			printk("reset badblock on %d: %llu\n", failed_num, sh->sector);
>+			delete_badblock(&conf->disks[failed_num], sh->sector);*/
> 		}
> 	}
> 	if (syncing && locked == 0 && test_bit(STRIPE_INSYNC, &sh->state)) {
>@@ -1251,7 +1633,7 @@
> 		bi->bi_size = 0;
> 		bi->bi_end_io(bi, bytes, 0);
> 	}
>-	for (i=disks; i-- ;) {
>+	for (i=disks+aspare; i-- ;) {
> 		int rw;
> 		struct bio *bi;
> 		mdk_rdev_t *rdev;
>@@ -1493,6 +1875,15 @@
> 		unplug_slaves(mddev);
> 		return 0;
> 	}
>+	/* if there is 1 or more failed drives and we are trying
>+	 * to resync, then assert that we are finished, because there is
>+	 * nothing we can do.
>+	 */
>+	if (mddev->degraded >= 1 && test_bit(MD_RECOVERY_SYNC, &mddev->recovery)) {
>+		int rv = (mddev->size << 1) - sector_nr;
>+		md_done_sync(mddev, rv, 1);
>+		return rv;
>+	}
> 
> 	x = sector_nr;
> 	chunk_offset = sector_div(x, sectors_per_chunk);
>@@ -1591,11 +1982,11 @@
> 	}
> 
> 	mddev->private = kmalloc (sizeof (raid5_conf_t)
>-				  + mddev->raid_disks * sizeof(struct disk_info),
>+				  + (mddev->raid_disks + 1) * sizeof(struct disk_info),
> 				  GFP_KERNEL);
> 	if ((conf = mddev->private) == NULL)
> 		goto abort;
>-	memset (conf, 0, sizeof (*conf) + mddev->raid_disks * sizeof(struct disk_info) );
>+	memset (conf, 0, sizeof (*conf) + (mddev->raid_disks + 1) * sizeof(struct disk_info) );
> 	conf->mddev = mddev;
> 
> 	if ((conf->stripe_hashtbl = (struct stripe_head **) __get_free_pages(GFP_ATOMIC, HASH_PAGES_ORDER)) == NULL)
>@@ -1625,6 +2016,8 @@
> 
> 		disk->rdev = rdev;
> 
>+		grow_badblocks(disk);
>+
> 		if (rdev->in_sync) {
> 			char b[BDEVNAME_SIZE];
> 			printk(KERN_INFO "raid5: device %s operational as raid"
>@@ -1635,6 +2028,7 @@
> 	}
> 
> 	conf->raid_disks = mddev->raid_disks;
>+	conf->mirrorit = -1;
> 	/*
> 	 * 0 for a fully functional array, 1 for a degraded array.
> 	 */
>@@ -1684,7 +2078,7 @@
> 		}
> 	}
> memory = conf->max_nr_stripes * (sizeof(struct stripe_head) +
>-		 conf->raid_disks * ((sizeof(struct bio) + PAGE_SIZE))) / 1024;
>+		 (conf->raid_disks+1) * ((sizeof(struct bio) + PAGE_SIZE))) / 1024;
> 	if (grow_stripes(conf, conf->max_nr_stripes)) {
> 		printk(KERN_ERR 
> 			"raid5: couldn't allocate %dkB for buffers\n", memory);
>@@ -1739,10 +2133,14 @@
> static int stop (mddev_t *mddev)
> {
> 	raid5_conf_t *conf = (raid5_conf_t *) mddev->private;
>+	int i;
> 
> 	md_unregister_thread(mddev->thread);
> 	mddev->thread = NULL;
> 	shrink_stripes(conf);
>+	for (i = conf->raid_disks; i--; )
>+		if (conf->disks[i].rdev && conf->disks[i].rdev->in_sync)
>+			shrink_badblocks(&conf->disks[i]);
> 	free_pages((unsigned long) conf->stripe_hashtbl, HASH_PAGES_ORDER);
> 	blk_sync_queue(mddev->queue); /* the unplug fn references 'conf'*/
> 	kfree(conf);
>@@ -1788,7 +2186,9 @@
> static void status (struct seq_file *seq, mddev_t *mddev)
> {
> 	raid5_conf_t *conf = (raid5_conf_t *) mddev->private;
>-	int i;
>+	int i, j;
>+	char b[BDEVNAME_SIZE];
>+	struct badblock *bb;
> 
> 	seq_printf (seq, " level %d, %dk chunk, algorithm %d", mddev->level, mddev->chunk_size >> 10, mddev->layout);
> 	seq_printf (seq, " [%d/%d] [", conf->raid_disks, conf->working_disks);
>@@ -1801,6 +2201,20 @@
> #define D(x) \
> 	seq_printf (seq, "<"#x":%d>", atomic_read(&conf->x))
> 	printall(conf);
>+
>+	spin_lock_irq(&conf->device_lock);	/* it's ok now for debug */
>+	seq_printf (seq, "\n      known bad sectors on active devices:");
>+	for (i = conf->raid_disks; i--; ) {
>+	    if (conf->disks[i].rdev) {
>+		seq_printf (seq, "\n      %s", bdevname(conf->disks[i].rdev->bdev, b));
>+		for (j = 0; j < BB_NR_HASH; j++) {
>+		    bb = conf->disks[i].badblock_hashtbl[j];
>+		    for (; bb; bb = bb->hash_next)
>+			seq_printf (seq, " %llu-%llu", bb->sector, bb->sector + (unsigned long long)(STRIPE_SIZE / 512) - 1);
>+		}
>+	    }
>+	}
>+	spin_unlock_irq(&conf->device_lock);
> #endif
> }
> 
>@@ -1844,6 +2258,17 @@
> 			tmp->rdev->in_sync = 1;
> 		}
> 	}
>+	tmp = conf->disks + i;
>+	if (tmp->rdev && !tmp->rdev->faulty && !tmp->rdev->in_sync) {
>+	    /* sync done to the 'active spare' */
>+	    tmp->rdev->in_sync = 1;
>+
>+	    printk(KERN_NOTICE "raid5_spare_active: %d in_sync %d->%d\n",
>+			i, tmp->rdev->raid_disk, conf->mirrorit);
>+
>+	    /* scary..? :} */
>+	    tmp->rdev->raid_disk = conf->mirrorit;
>+	}
> 	print_raid5_conf(conf);
> 	return 0;
> }
>@@ -1857,6 +2282,7 @@
> 
> 	print_raid5_conf(conf);
> 	rdev = p->rdev;
>+printk("raid5_remove_disk %d\n", number);
> 	if (rdev) {
> 		if (rdev->in_sync ||
> 		    atomic_read(&rdev->nr_pending)) {
>@@ -1870,6 +2296,8 @@
> 			err = -EBUSY;
> 			p->rdev = rdev;
> 		}
>+		if (!err)
>+			shrink_badblocks(p);
> 	}
> abort:
> 
>@@ -1884,6 +2312,10 @@
> 	int disk;
> 	struct disk_info *p;
> 
>+	if (mddev->degraded > 1)
>+		/* no point adding a device */
>+		return 0;
>+
> 	/*
> 	 * find the disk ...
> 	 */
>@@ -1895,6 +2327,22 @@
> 			p->rdev = rdev;
> 			break;
> 		}
>+
>+	if (!found) {
>+	    /* array optimal, this should be the 'active spare' */
>+	    conf->disks[disk].rdev = rdev;
>+	    rdev->in_sync = 0;
>+	    rdev->raid_disk = conf->raid_disks;
>+
>+	    mddev->degraded--;
>+	    found++;	/* call resync */
>+
>+	    printk(KERN_INFO "added spare for active resync\n");
>+	}
>+	if (found)
>+		grow_badblocks(&conf->disks[disk]);
>+	printk(KERN_INFO "raid5_add_disk: %d (%d)\n", disk, found);
>+
> 	print_raid5_conf(conf);
> 	return found;
> }
>  
>
>------------------------------------------------------------------------
>
>No virus found in this incoming message.
>Checked by AVG Anti-Virus.
>Version: 7.0.338 / Virus Database: 267.10.12/75 - Release Date: 8/17/2005
>  
>


-- 
No virus found in this outgoing message.
Checked by AVG Anti-Virus.
Version: 7.0.338 / Virus Database: 267.10.12/75 - Release Date: 8/17/2005

