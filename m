From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 2 of 3 - Cleanups for md to move device size calculations into personalities
Date: Fri, 04 Apr 2003 11:25:24 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E191FxM-0001zG-00@notabene.cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


### Comments for ChangeSet

 ----------- Diffstat output ------------
 ./drivers/md/linear.c       |    5 +
 ./drivers/md/md.c           |  151 ++++++--------------------------------------
 ./drivers/md/multipath.c    |    1 
 ./drivers/md/raid0.c        |   11 ++-
 ./drivers/md/raid1.c        |    2 
 ./drivers/md/raid5.c        |    3 
 ./include/linux/raid/md.h   |    2 
 ./include/linux/raid/md_k.h |    1 
 8 files changed, 40 insertions(+), 136 deletions(-)

diff ./drivers/md/linear.c~current~ ./drivers/md/linear.c
--- ./drivers/md/linear.c~current~	2003-04-04 11:21:32.000000000 +1000
+++ ./drivers/md/linear.c	2003-04-04 11:21:33.000000000 +1000
@@ -91,6 +91,8 @@ static int linear_run (mddev_t *mddev)
 
 	conf->smallest = NULL;
 	cnt = 0;
+	mddev->array_size = 0;
+
 	ITERATE_RDEV(mddev,rdev,tmp) {
 		int j = rdev->raid_disk;
 		dev_info_t *disk = conf->disks + j;
@@ -102,6 +104,7 @@ static int linear_run (mddev_t *mddev)
 
 		disk->rdev = rdev;
 		disk->size = rdev->size;
+		mddev->array_size += rdev->size;
 
 		if (!conf->smallest || (disk->size < conf->smallest->size))
 			conf->smallest = disk;
@@ -121,7 +124,7 @@ static int linear_run (mddev_t *mddev)
 		unsigned round;
 		unsigned long base;
 
-		sz = md_size[mdidx(mddev)];
+		sz = mddev->array_size;
 		base = conf->smallest->size;
 		round = sector_div(sz, base);
 		nb_zone = conf->nr_zones = sz + (round ? 1 : 0);

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2003-04-04 11:21:20.000000000 +1000
+++ ./drivers/md/md.c	2003-04-04 11:21:33.000000000 +1000
@@ -125,8 +125,6 @@ static ctl_table raid_root_table[] = {
 	{ .ctl_name = 0 }
 };
 
-sector_t md_size[MAX_MD_DEVS];
-
 static struct block_device_operations md_fops;
 
 static struct gendisk *disks[MAX_MD_DEVS];
@@ -288,21 +286,6 @@ static sector_t calc_dev_size(mdk_rdev_t
 	return size;
 }
 
-static sector_t zoned_raid_size(mddev_t *mddev)
-{
-	mdk_rdev_t * rdev;
-	struct list_head *tmp;
-
-	/*
-	 * do size and offset calculations.
-	 */
-
-	ITERATE_RDEV(mddev,rdev,tmp)
-		md_size[mdidx(mddev)] += rdev->size;
-
-	return 0;
-}
-
 static int alloc_disk_sb(mdk_rdev_t * rdev)
 {
 	if (rdev->sb_page)
@@ -1453,87 +1436,6 @@ abort:
 	return 1;
 }
 
-static int device_size_calculation(mddev_t * mddev)
-{
-	int data_disks = 0;
-	unsigned int readahead;
-	struct list_head *tmp;
-	mdk_rdev_t *rdev;
-
-	/*
-	 * Do device size calculation. Bail out if too small.
-	 * (we have to do this after having validated chunk_size,
-	 * because device size has to be modulo chunk_size)
-	 */
-
-	ITERATE_RDEV(mddev,rdev,tmp) {
-		if (rdev->faulty)
-			continue;
-		if (rdev->size < mddev->chunk_size / 1024) {
-			printk(KERN_WARNING
-				"md: Dev %s smaller than chunk_size:"
-				" %lluk < %dk\n",
-				bdev_partition_name(rdev->bdev),
-				(unsigned long long)rdev->size,
-				mddev->chunk_size / 1024);
-			return -EINVAL;
-		}
-	}
-
-	switch (mddev->level) {
-		case LEVEL_MULTIPATH:
-			data_disks = 1;
-			break;
-		case -3:
-			data_disks = 1;
-			break;
-		case -2:
-			data_disks = 1;
-			break;
-		case LEVEL_LINEAR:
-			zoned_raid_size(mddev);
-			data_disks = 1;
-			break;
-		case 0:
-			zoned_raid_size(mddev);
-			data_disks = mddev->raid_disks;
-			break;
-		case 1:
-			data_disks = 1;
-			break;
-		case 4:
-		case 5:
-			data_disks = mddev->raid_disks-1;
-			break;
-		default:
-			printk(KERN_ERR "md: md%d: unsupported raid level %d\n",
-				mdidx(mddev), mddev->level);
-			goto abort;
-	}
-	if (!md_size[mdidx(mddev)])
-		md_size[mdidx(mddev)] = mddev->size * data_disks;
-
-	readahead = (VM_MAX_READAHEAD * 1024) / PAGE_SIZE;
-	if (!mddev->level || (mddev->level == 4) || (mddev->level == 5)) {
-		readahead = (mddev->chunk_size>>PAGE_SHIFT) * 4 * data_disks;
-		if (readahead < data_disks * (MAX_SECTORS>>(PAGE_SHIFT-9))*2)
-			readahead = data_disks * (MAX_SECTORS>>(PAGE_SHIFT-9))*2;
-	} else {
-		// (no multipath branch - it uses the default setting)
-		if (mddev->level == -3)
-			readahead = 0;
-	}
-
-	printk(KERN_INFO "md%d: max total readahead window set to %ldk\n",
-		mdidx(mddev), readahead*(PAGE_SIZE/1024));
-
-	printk(KERN_INFO
-		"md%d: %d data-disks, max readahead per data-disk: %ldk\n",
-		mdidx(mddev), data_disks, readahead/data_disks*(PAGE_SIZE/1024));
-	return 0;
-abort:
-	return 1;
-}
 
 static struct gendisk *md_probe(dev_t dev, int *part, void *data)
 {
@@ -1597,12 +1499,6 @@ static int do_md_run(mddev_t * mddev)
 		return -EBUSY;
 
 	/*
-	 * Resize disks to align partitions size on a given
-	 * chunk size.
-	 */
-	md_size[mdidx(mddev)] = 0;
-
-	/*
 	 * Analyze all RAID superblock(s)
 	 */
 	if (!mddev->raid_disks && analyze_sbs(mddev)) {
@@ -1642,6 +1538,21 @@ static int do_md_run(mddev_t * mddev)
 				chunk_size, PAGE_SIZE);
 			return -EINVAL;
 		}
+
+		/* devices must have minimum size of one chunk */
+		ITERATE_RDEV(mddev,rdev,tmp) {
+			if (rdev->faulty)
+				continue;
+			if (rdev->size < chunk_size / 1024) {
+				printk(KERN_WARNING
+					"md: Dev %s smaller than chunk_size:"
+					" %lluk < %dk\n",
+					bdev_partition_name(rdev->bdev),
+					(unsigned long long)rdev->size,
+					chunk_size / 1024);
+				return -EINVAL;
+			}
+		}
 	}
 
 	if (pnum >= MAX_PERSONALITY) {
@@ -1658,9 +1569,6 @@ static int do_md_run(mddev_t * mddev)
 	}
 #endif
 
-	if (device_size_calculation(mddev))
-		return -EINVAL;
-
 	/*
 	 * Drop all container device buffers, from now on
 	 * the only valid external interface is through the md
@@ -1672,18 +1580,6 @@ static int do_md_run(mddev_t * mddev)
 			continue;
 		sync_blockdev(rdev->bdev);
 		invalidate_bdev(rdev->bdev, 0);
-#if 0
-	/*
-	 * Aside of obvious breakage (code below results in block size set
-	 * according to the sector size of last component instead of the
-	 * maximal sector size), we have more interesting problem here.
-	 * Namely, we actually ought to set _sector_ size for the array
-	 * and that requires per-array request queues.  Disabled for now.
-	 */
-		md_blocksizes[mdidx(mddev)] = 1024;
-		if (bdev_hardsect_size(rdev->bdev) > md_blocksizes[mdidx(mddev)])
-			md_blocksizes[mdidx(mddev)] = bdev_hardsect_size(rdev->bdev);
-#endif
 	}
 
 	md_probe(mdidx(mddev), NULL, NULL);
@@ -1727,8 +1623,8 @@ static int do_md_run(mddev_t * mddev)
 	
 	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 	md_wakeup_thread(mddev->thread);
-	set_capacity(disk, md_size[mdidx(mddev)]<<1);
-	return (0);
+	set_capacity(disk, mddev->array_size<<1);
+	return 0;
 }
 
 static int restart_array(mddev_t *mddev)
@@ -1828,7 +1724,7 @@ static int do_md_stop(mddev_t * mddev, i
 
 		export_array(mddev);
 
-		md_size[mdidx(mddev)] = 0;
+		mddev->array_size = 0;
 		disk = disks[mdidx(mddev)];
 		if (disk)
 			set_capacity(disk, 0);
@@ -3052,9 +2948,10 @@ static int md_seq_show(struct seq_file *
 		if (!list_empty(&mddev->disks)) {
 			if (mddev->pers)
 				seq_printf(seq, "\n      %llu blocks",
-						 (unsigned long long)md_size[mdidx(mddev)]);
+					(unsigned long long)mddev->array_size);
 			else
-				seq_printf(seq, "\n      %llu blocks", (unsigned long long)size);
+				seq_printf(seq, "\n      %llu blocks",
+					(unsigned long long)size);
 		}
 
 		if (mddev->pers) {
@@ -3563,11 +3460,6 @@ struct notifier_block md_notifier = {
 static void md_geninit(void)
 {
 	struct proc_dir_entry *p;
-	int i;
-
-	for(i = 0; i < MAX_MD_DEVS; i++) {
-		md_size[i] = 0;
-	}
 
 	dprintk("md: sizeof(mdp_super_t) = %d\n", (int)sizeof(mdp_super_t));
 
@@ -3682,7 +3574,6 @@ static __exit void md_exit(void)
 module_init(md_init)
 module_exit(md_exit)
 
-EXPORT_SYMBOL(md_size);
 EXPORT_SYMBOL(register_md_personality);
 EXPORT_SYMBOL(unregister_md_personality);
 EXPORT_SYMBOL(md_error);

diff ./drivers/md/multipath.c~current~ ./drivers/md/multipath.c
--- ./drivers/md/multipath.c~current~	2003-04-04 11:21:32.000000000 +1000
+++ ./drivers/md/multipath.c	2003-04-04 11:21:33.000000000 +1000
@@ -438,6 +438,7 @@ static int multipath_run (mddev_t *mddev
 	/*
 	 * Ok, everything is just fine now
 	 */
+	mddev->array_size = mddev->size;
 	return 0;
 
 out_free_conf:

diff ./drivers/md/raid0.c~current~ ./drivers/md/raid0.c
--- ./drivers/md/raid0.c~current~	2003-04-04 11:21:32.000000000 +1000
+++ ./drivers/md/raid0.c	2003-04-04 11:21:33.000000000 +1000
@@ -196,6 +196,8 @@ static int raid0_run (mddev_t *mddev)
 	sector_t zone0_size;
 	s64 size;
 	raid0_conf_t *conf;
+	mdk_rdev_t *rdev;
+	struct list_head *tmp;
 
 	conf = vmalloc(sizeof (raid0_conf_t));
 	if (!conf)
@@ -205,15 +207,20 @@ static int raid0_run (mddev_t *mddev)
 	if (create_strip_zones (mddev)) 
 		goto out_free_conf;
 
+	/* calculate array device size */
+	mddev->array_size = 0;
+	ITERATE_RDEV(mddev,rdev,tmp)
+		mddev->array_size += rdev->size;
+
 	printk("raid0 : md_size is %llu blocks.\n", 
-		(unsigned long long)md_size[mdidx(mddev)]);
+		(unsigned long long)mddev->array_size);
 	printk("raid0 : conf->smallest->size is %llu blocks.\n",
 		(unsigned long long)conf->smallest->size);
 	{
 #if __GNUC__ < 3
 		volatile
 #endif
-		sector_t s = md_size[mdidx(mddev)];
+		sector_t s = mddev->array_size;
 		int round = sector_div(s, (unsigned long)conf->smallest->size) ? 1 : 0;
 		nb_zone = s + round;
 	}

diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
--- ./drivers/md/raid1.c~current~	2003-04-04 11:21:32.000000000 +1000
+++ ./drivers/md/raid1.c	2003-04-04 11:21:33.000000000 +1000
@@ -1156,6 +1156,8 @@ static int run(mddev_t *mddev)
 	/*
 	 * Ok, everything is just fine now
 	 */
+	mddev->array_size = mddev->size;
+
 	return 0;
 
 out_free_conf:

diff ./drivers/md/raid5.c~current~ ./drivers/md/raid5.c
--- ./drivers/md/raid5.c~current~	2003-04-04 11:21:32.000000000 +1000
+++ ./drivers/md/raid5.c	2003-04-04 11:21:33.000000000 +1000
@@ -1550,7 +1550,8 @@ memory = conf->max_nr_stripes * (sizeof(
 	print_raid5_conf(conf);
 
 	/* Ok, everything is just fine now */
-	return (0);
+	mddev->array_size =  mddev->size * (mddev->raid_disks - 1);
+	return 0;
 abort:
 	if (conf) {
 		print_raid5_conf(conf);

diff ./include/linux/raid/md.h~current~ ./include/linux/raid/md.h
--- ./include/linux/raid/md.h~current~	2003-04-04 11:21:33.000000000 +1000
+++ ./include/linux/raid/md.h	2003-04-04 11:21:33.000000000 +1000
@@ -61,8 +61,6 @@
 #define MD_MINOR_VERSION                90
 #define MD_PATCHLEVEL_VERSION           0
 
-extern sector_t md_size[MAX_MD_DEVS];
-
 extern inline char * bdev_partition_name (struct block_device *bdev)
 {
 	return partition_name(bdev ? bdev->bd_dev : 0);

diff ./include/linux/raid/md_k.h~current~ ./include/linux/raid/md_k.h
--- ./include/linux/raid/md_k.h~current~	2003-04-04 11:21:33.000000000 +1000
+++ ./include/linux/raid/md_k.h	2003-04-04 11:21:33.000000000 +1000
@@ -203,6 +203,7 @@ struct mddev_s
 	int				raid_disks;
 	int				max_disks;
 	sector_t			size; /* used size of component devices */
+	sector_t			array_size; /* exported array size */
 	__u64				events;
 
 	char				uuid[16];
