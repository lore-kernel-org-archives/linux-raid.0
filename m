From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] MD - 27 of 27 - Get rid of dev in rdev and use bdev exclusively.
Date: Thu, 18 Jul 2002 23:34:44 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1020718133444.5063@cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


### Comments for ChangeSet
Get rid of dev in rdev and use bdev exclusively.

There is an awkwardness here in that userspace sometimes
passed down a dev_t (e.g. hot_add_disk) and sometime
a major and a minor (e.g. add_new_disk).  Should we convert
both to kdev_t as the uniform standard....
That is what was being done but it seemed very clumsy and
things were gets converted back and forth a lot.

As bdget used a dev_t, I felt safe in staying with dev_t once I 
had one rather than converting to kdev_t and back.


 ----------- Diffstat output ------------
 ./drivers/md/md.c           |  106 ++++++++++++++++++++++++--------------------
 ./include/linux/raid/md_k.h |    2 
 2 files changed, 59 insertions(+), 49 deletions(-)

--- ./drivers/md/md.c	2002/07/18 12:08:41	1.18
+++ ./drivers/md/md.c	2002/07/18 12:08:58	1.19
@@ -36,6 +36,7 @@
 #include <linux/bio.h>
 #include <linux/raid/xor.h>
 #include <linux/devfs_fs_kernel.h>
+#include <linux/buffer_head.h> /* for invalidate_bdev */
 
 #include <linux/init.h>
 
@@ -248,13 +249,25 @@ mdk_rdev_t * find_rdev_nr(mddev_t *mddev
 	return NULL;
 }
 
-mdk_rdev_t * find_rdev(mddev_t * mddev, kdev_t dev)
+static mdk_rdev_t * find_rdev(mddev_t * mddev, dev_t dev)
 {
 	struct list_head *tmp;
 	mdk_rdev_t *rdev;
 
 	ITERATE_RDEV(mddev,rdev,tmp) {
-		if (kdev_same(rdev->dev, dev))
+		if (rdev->bdev->bd_dev == dev)
+			return rdev;
+	}
+	return NULL;
+}
+
+static mdk_rdev_t * find_rdev_bdev(mddev_t * mddev, struct block_device *bdev)
+{
+	struct list_head *tmp;
+	mdk_rdev_t *rdev;
+
+	ITERATE_RDEV(mddev,rdev,tmp) {
+		if (rdev->bdev == bdev)
 			return rdev;
 	}
 	return NULL;
@@ -552,12 +565,12 @@ static void unbind_rdev_from_array(mdk_r
  * inode is not enough, the SCSI module usage code needs
  * an explicit open() on the device]
  */
-static int lock_rdev(mdk_rdev_t *rdev)
+static int lock_rdev(mdk_rdev_t *rdev, dev_t dev)
 {
 	int err = 0;
 	struct block_device *bdev;
 
-	bdev = bdget(kdev_t_to_nr(rdev->dev));
+	bdev = bdget(dev);
 	if (!bdev)
 		return -ENOMEM;
 	err = blkdev_get(bdev, FMODE_READ|FMODE_WRITE, 0, BDEV_RAW);
@@ -582,7 +595,7 @@ static void unlock_rdev(mdk_rdev_t *rdev
 	blkdev_put(bdev, BDEV_RAW);
 }
 
-void md_autodetect_dev(kdev_t dev);
+void md_autodetect_dev(dev_t dev);
 
 static void export_rdev(mdk_rdev_t * rdev)
 {
@@ -593,9 +606,8 @@ static void export_rdev(mdk_rdev_t * rde
 	list_del_init(&rdev->same_set);
 	unlock_rdev(rdev);
 #ifndef MODULE
-	md_autodetect_dev(rdev->dev);
+	md_autodetect_dev(rdev->bdev->bd_dev);
 #endif
-	rdev->dev = NODEV;
 	rdev->faulty = 0;
 	kfree(rdev);
 }
@@ -869,8 +881,8 @@ static void sync_sbs(mddev_t * mddev)
 		mdp_disk_t *d = &sb->disks[rdev->desc_nr];
 		nr_disks++;
 		d->number = rdev->desc_nr;
-		d->major = major(rdev->dev);
-		d->minor = minor(rdev->dev);
+		d->major = MAJOR(rdev->bdev->bd_dev);
+		d->minor = MINOR(rdev->bdev->bd_dev);
 		d->raid_disk = rdev->raid_disk;
 		if (rdev->faulty) {
 			d->state = (1<<MD_DISK_FAULTY);
@@ -984,7 +996,7 @@ repeat:
  *
  * a faulty rdev _never_ has rdev->sb set.
  */
-static mdk_rdev_t *md_import_device(kdev_t newdev, int on_disk)
+static mdk_rdev_t *md_import_device(dev_t newdev, int on_disk)
 {
 	int err;
 	mdk_rdev_t *rdev;
@@ -992,7 +1004,7 @@ static mdk_rdev_t *md_import_device(kdev
 
 	rdev = (mdk_rdev_t *) kmalloc(sizeof(*rdev), GFP_KERNEL);
 	if (!rdev) {
-		printk(KERN_ERR "md: could not alloc mem for %s!\n", partition_name(newdev));
+		printk(KERN_ERR "md: could not alloc mem for %s!\n", partition_name(to_kdev_t(newdev)));
 		return ERR_PTR(-ENOMEM);
 	}
 	memset(rdev, 0, sizeof(*rdev));
@@ -1000,11 +1012,10 @@ static mdk_rdev_t *md_import_device(kdev
 	if ((err = alloc_disk_sb(rdev)))
 		goto abort_free;
 
-	rdev->dev = newdev;
-	err = lock_rdev(rdev);
+	err = lock_rdev(rdev, newdev);
 	if (err) {
 		printk(KERN_ERR "md: could not lock %s.\n",
-			partition_name(newdev));
+			partition_name(to_kdev_t(newdev)));
 		goto abort_free;
 	}
 	rdev->desc_nr = -1;
@@ -1435,7 +1446,8 @@ static int do_md_run(mddev_t * mddev)
 	ITERATE_RDEV(mddev,rdev,tmp) {
 		if (rdev->faulty)
 			continue;
-		invalidate_device(rdev->dev, 1);
+		sync_blockdev(rdev->bdev);
+		invalidate_bdev(rdev->bdev, 0);
 #if 0
 	/*
 	 * Aside of obvious breakage (code below results in block size set
@@ -1745,7 +1757,7 @@ static void autorun_devices(void)
 #define AUTORUNNING KERN_INFO \
 "md: auto-running md%d.\n"
 
-static int autostart_array(kdev_t startdev)
+static int autostart_array(dev_t startdev)
 {
 	int err = -EINVAL, i;
 	mdp_super_t *sb = NULL;
@@ -1753,7 +1765,7 @@ static int autostart_array(kdev_t startd
 
 	start_rdev = md_import_device(startdev, 1);
 	if (IS_ERR(start_rdev)) {
-		printk(KERN_WARNING "md: could not import %s!\n", partition_name(startdev));
+		printk(KERN_WARNING "md: could not import %s!\n", partition_name(to_kdev_t(startdev)));
 		goto abort;
 	}
 
@@ -1776,19 +1788,19 @@ static int autostart_array(kdev_t startd
 
 	for (i = 0; i < MD_SB_DISKS; i++) {
 		mdp_disk_t *desc;
-		kdev_t dev;
+		dev_t dev;
 
 		desc = sb->disks + i;
-		dev = mk_kdev(desc->major, desc->minor);
+		dev = MKDEV(desc->major, desc->minor);
 
-		if (kdev_none(dev))
+		if (!dev)
 			continue;
-		if (kdev_same(dev, startdev))
+		if (dev == startdev)
 			continue;
 		rdev = md_import_device(dev, 1);
 		if (IS_ERR(rdev)) {
 			printk(KERN_WARNING "md: could not import %s, trying to run array nevertheless.\n",
-			       partition_name(dev));
+			       partition_name(to_kdev_t(dev)));
 			continue;
 		}
 		list_add(&rdev->same_set, &pending_raid_disks);
@@ -1896,8 +1908,8 @@ static int get_disk_info(mddev_t * mddev
 
 	rdev = find_rdev_nr(mddev, nr);
 	if (rdev) {
-		info.major = major(rdev->dev);
-		info.minor = minor(rdev->dev);
+		info.major = MAJOR(rdev->bdev->bd_dev);
+		info.minor = MINOR(rdev->bdev->bd_dev);
 		info.raid_disk = rdev->raid_disk;
 		info.state = 0;
 		if (rdev->faulty)
@@ -1922,8 +1934,8 @@ static int add_new_disk(mddev_t * mddev,
 {
 	int size;
 	mdk_rdev_t *rdev;
-	kdev_t dev;
-	dev = mk_kdev(info->major,info->minor);
+	dev_t dev;
+	dev = MKDEV(info->major,info->minor);
 	if (!mddev->raid_disks) {
 		/* expecting a device which has a superblock */
 		rdev = md_import_device(dev, 1);
@@ -1980,7 +1992,7 @@ static int add_new_disk(mddev_t * mddev,
 	return 0;
 }
 
-static int hot_generate_error(mddev_t * mddev, kdev_t dev)
+static int hot_generate_error(mddev_t * mddev, dev_t dev)
 {
 	struct request_queue *q;
 	mdk_rdev_t *rdev;
@@ -1989,7 +2001,7 @@ static int hot_generate_error(mddev_t * 
 		return -ENODEV;
 
 	printk(KERN_INFO "md: trying to generate %s error in md%d ... \n",
-		partition_name(dev), mdidx(mddev));
+		partition_name(to_kdev_t(dev)), mdidx(mddev));
 
 	rdev = find_rdev(mddev, dev);
 	if (!rdev) {
@@ -2015,7 +2027,7 @@ static int hot_generate_error(mddev_t * 
 	return 0;
 }
 
-static int hot_remove_disk(mddev_t * mddev, kdev_t dev)
+static int hot_remove_disk(mddev_t * mddev, dev_t dev)
 {
 	int err;
 	mdk_rdev_t *rdev;
@@ -2024,7 +2036,7 @@ static int hot_remove_disk(mddev_t * mdd
 		return -ENODEV;
 
 	printk(KERN_INFO "md: trying to remove %s from md%d ... \n",
-		partition_name(dev), mdidx(mddev));
+		partition_name(to_kdev_t(dev)), mdidx(mddev));
 
 	if (!mddev->pers->hot_remove_disk) {
 		printk(KERN_WARNING "md%d: personality does not support diskops!\n",
@@ -2059,7 +2071,7 @@ busy:
 	return -EBUSY;
 }
 
-static int hot_add_disk(mddev_t * mddev, kdev_t dev)
+static int hot_add_disk(mddev_t * mddev, dev_t dev)
 {
 	int i, err;
 	unsigned int size;
@@ -2069,7 +2081,7 @@ static int hot_add_disk(mddev_t * mddev,
 		return -ENODEV;
 
 	printk(KERN_INFO "md: trying to hot-add %s to md%d ... \n",
-		partition_name(dev), mdidx(mddev));
+		partition_name(to_kdev_t(dev)), mdidx(mddev));
 
 	if (!mddev->pers->hot_add_disk) {
 		printk(KERN_WARNING "md%d: personality does not support diskops!\n",
@@ -2176,7 +2188,7 @@ static int set_array_info(mddev_t * mdde
 	return 0;
 }
 
-static int set_disk_faulty(mddev_t *mddev, kdev_t dev)
+static int set_disk_faulty(mddev_t *mddev, dev_t dev)
 {
 	mdk_rdev_t *rdev;
 	int ret;
@@ -2270,7 +2282,7 @@ static int md_ioctl(struct inode *inode,
 		/* START_ARRAY doesn't need to lock the array as autostart_array
 		 * does the locking, and it could even be a different array
 		 */
-		err = autostart_array(val_to_kdev(arg));
+		err = autostart_array(arg);
 		if (err) {
 			printk(KERN_WARNING "md: autostart %s failed!\n",
 			       partition_name(val_to_kdev(arg)));
@@ -2401,18 +2413,18 @@ static int md_ioctl(struct inode *inode,
 			goto done_unlock;
 		}
 		case HOT_GENERATE_ERROR:
-			err = hot_generate_error(mddev, val_to_kdev(arg));
+			err = hot_generate_error(mddev, arg);
 			goto done_unlock;
 		case HOT_REMOVE_DISK:
-			err = hot_remove_disk(mddev, val_to_kdev(arg));
+			err = hot_remove_disk(mddev, arg);
 			goto done_unlock;
 
 		case HOT_ADD_DISK:
-			err = hot_add_disk(mddev, val_to_kdev(arg));
+			err = hot_add_disk(mddev, arg);
 			goto done_unlock;
 
 		case SET_DISK_FAULTY:
-			err = set_disk_faulty(mddev, val_to_kdev(arg));
+			err = set_disk_faulty(mddev, arg);
 			goto done_unlock;
 
 		case RUN_ARRAY:
@@ -2626,10 +2638,9 @@ static void md_recover_arrays(void)
 int md_error(mddev_t *mddev, struct block_device *bdev)
 {
 	mdk_rdev_t * rrdev;
-	kdev_t rdev = to_kdev_t(bdev->bd_dev);
 
 	dprintk("md_error dev:(%d:%d), rdev:(%d:%d), (caller: %p,%p,%p,%p).\n",
-		MD_MAJOR,mdidx(mddev),major(rdev),minor(rdev),
+		MD_MAJOR,mdidx(mddev),MAJOR(bdev->bd_dev),MINOR(bdev->bd_dev),
 		__builtin_return_address(0),__builtin_return_address(1),
 		__builtin_return_address(2),__builtin_return_address(3));
 
@@ -2637,7 +2648,7 @@ int md_error(mddev_t *mddev, struct bloc
 		MD_BUG();
 		return 0;
 	}
-	rrdev = find_rdev(mddev, rdev);
+	rrdev = find_rdev_bdev(mddev, bdev);
 	if (!rrdev || rrdev->faulty)
 		return 0;
 	if (!mddev->pers->error_handler
@@ -2861,8 +2872,9 @@ static int is_mddev_idle(mddev_t *mddev)
 
 	idle = 1;
 	ITERATE_RDEV(mddev,rdev,tmp) {
-		int major = major(rdev->dev);
-		int idx = disk_index(rdev->dev);
+		kdev_t dev = to_kdev_t(rdev->bdev->bd_dev);
+		int major = major(dev);
+		int idx = disk_index(dev);
 
 		if ((idx >= DK_MAX_DISK) || (major >= DK_MAX_MAJOR))
 			continue;
@@ -3273,10 +3285,10 @@ struct {
  * Searches all registered partitions for autorun RAID arrays
  * at boot time.
  */
-static kdev_t detected_devices[128];
+static dev_t detected_devices[128];
 static int dev_cnt;
 
-void md_autodetect_dev(kdev_t dev)
+void md_autodetect_dev(dev_t dev)
 {
 	if (dev_cnt >= 0 && dev_cnt < 127)
 		detected_devices[dev_cnt++] = dev;
@@ -3291,12 +3303,12 @@ static void autostart_arrays(void)
 	printk(KERN_INFO "md: Autodetecting RAID arrays.\n");
 
 	for (i = 0; i < dev_cnt; i++) {
-		kdev_t dev = detected_devices[i];
+		dev_t dev = detected_devices[i];
 
 		rdev = md_import_device(dev,1);
 		if (IS_ERR(rdev)) {
 			printk(KERN_ALERT "md: could not import %s!\n",
-				partition_name(dev));
+				partition_name(to_kdev_t(dev)));
 			continue;
 		}
 		if (rdev->faulty) {
--- ./include/linux/raid/md_k.h	2002/07/18 12:08:25	1.12
+++ ./include/linux/raid/md_k.h	2002/07/18 12:08:58	1.13
@@ -144,7 +144,6 @@ struct mdk_rdev_s
 {
 	struct list_head same_set;	/* RAID devices within the same set */
 
-	kdev_t dev;			/* Device number */
 	unsigned long size;		/* Device size (in blocks) */
 	mddev_t *mddev;			/* RAID array if running */
 	unsigned long last_events;	/* IO event timestamp */
@@ -249,7 +248,6 @@ static inline kdev_t mddev_to_kdev(mddev
 	return mk_kdev(MD_MAJOR, mdidx(mddev));
 }
 
-extern mdk_rdev_t * find_rdev(mddev_t * mddev, kdev_t dev);
 extern mdk_rdev_t * find_rdev_nr(mddev_t *mddev, int nr);
 extern mdk_rdev_t *get_spare(mddev_t *mddev);
 
