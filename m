From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: PATCH - md 10 of 22 - Remove nb_dev from mddev_s
Date: Wed, 19 Jun 2002 10:51:58 +1000 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15631.54702.143062.81950@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



The nb_dev field is not needed.
Most uses are the test if it is zero or not, and they can be replaced
by tests on the emptiness of the disks list.

Other uses are for iterating through devices in numerical order and
it makes the code clearer (IMO) to unroll the devices into an array first
(which has to be done at some stage anyway) and then walk that array.

This makes ITERATE_RDEV_ORDERED un-necessary.

Also remove the "name" field which is never used.


 ----------- Diffstat output ------------
 ./drivers/md/linear.c       |   35 +++++++++++--------
 ./drivers/md/md.c           |   81 +++-----------------------------------------
 ./drivers/md/raid0.c        |   74 +++++++++++++++++++++++++++++-----------
 ./include/linux/raid/md.h   |    1 
 ./include/linux/raid/md_k.h |    9 ----
 5 files changed, 84 insertions(+), 116 deletions(-)

--- ./drivers/md/md.c	2002/06/18 04:20:52	1.9
+++ ./drivers/md/md.c	2002/06/18 04:29:32	1.10
@@ -316,69 +316,6 @@
 	return 0;
 }
 
-/*
- * We check wether all devices are numbered from 0 to nb_dev-1. The
- * order is guaranteed even after device name changes.
- *
- * Some personalities (raid0, linear) use this. Personalities that
- * provide data have to be able to deal with loss of individual
- * disks, so they do their checking themselves.
- */
-int md_check_ordering(mddev_t *mddev)
-{
-	int i, c;
-	mdk_rdev_t *rdev;
-	struct list_head *tmp;
-
-	/*
-	 * First, all devices must be fully functional
-	 */
-	ITERATE_RDEV(mddev,rdev,tmp) {
-		if (rdev->faulty) {
-			printk(KERN_ERR "md: md%d's device %s faulty, aborting.\n",
-			       mdidx(mddev), partition_name(rdev->dev));
-			goto abort;
-		}
-	}
-
-	c = 0;
-	ITERATE_RDEV(mddev,rdev,tmp) {
-		c++;
-	}
-	if (c != mddev->nb_dev) {
-		MD_BUG();
-		goto abort;
-	}
-	if (mddev->nb_dev != mddev->sb->raid_disks) {
-		printk(KERN_ERR "md: md%d, array needs %d disks, has %d, aborting.\n",
-			mdidx(mddev), mddev->sb->raid_disks, mddev->nb_dev);
-		goto abort;
-	}
-	/*
-	 * Now the numbering check
-	 */
-	for (i = 0; i < mddev->nb_dev; i++) {
-		c = 0;
-		ITERATE_RDEV(mddev,rdev,tmp) {
-			if (rdev->desc_nr == i)
-				c++;
-		}
-		if (!c) {
-			printk(KERN_ERR "md: md%d, missing disk #%d, aborting.\n",
-			       mdidx(mddev), i);
-			goto abort;
-		}
-		if (c > 1) {
-			printk(KERN_ERR "md: md%d, too many disks #%d, aborting.\n",
-			       mdidx(mddev), i);
-			goto abort;
-		}
-	}
-	return 0;
-abort:
-	return 1;
-}
-
 static void remove_descriptor(mdp_disk_t *disk, mdp_super_t *sb)
 {
 	if (disk_active(disk)) {
@@ -608,8 +545,7 @@
 
 	list_add(&rdev->same_set, &mddev->disks);
 	rdev->mddev = mddev;
-	mddev->nb_dev++;
-	printk(KERN_INFO "md: bind<%s,%d>\n", partition_name(rdev->dev), mddev->nb_dev);
+	printk(KERN_INFO "md: bind<%s>\n", partition_name(rdev->dev));
 }
 
 static void unbind_rdev_from_array(mdk_rdev_t * rdev)
@@ -619,9 +555,7 @@
 		return;
 	}
 	list_del_init(&rdev->same_set);
-	rdev->mddev->nb_dev--;
-	printk(KERN_INFO "md: unbind<%s,%d>\n", partition_name(rdev->dev),
-						 rdev->mddev->nb_dev);
+	printk(KERN_INFO "md: unbind<%s>\n", partition_name(rdev->dev));
 	rdev->mddev = NULL;
 }
 
@@ -709,7 +643,7 @@
 		}
 		kick_rdev_from_array(rdev);
 	}
-	if (mddev->nb_dev)
+	if (!list_empty(&mddev->disks))
 		MD_BUG();
 }
 
@@ -1589,7 +1523,7 @@
 	mdk_rdev_t *rdev;
 
 
-	if (!mddev->nb_dev) {
+	if (list_empty(&mddev->disks)) {
 		MD_BUG();
 		return -EINVAL;
 	}
@@ -1729,7 +1663,7 @@
 	/*
 	 * Complain if it has no devices
 	 */
-	if (!mddev->nb_dev)
+	if (list_empty(&mddev->disks))
 		OUT(-ENXIO);
 
 	if (mddev->pers) {
@@ -2174,7 +2108,7 @@
 			MD_BUG();
 			return -EINVAL;
 		}
-		if (mddev->nb_dev) {
+		if (!list_empty(&mddev->disks)) {
 			mdk_rdev_t *rdev0 = list_entry(mddev->disks.next,
 							mdk_rdev_t, same_set);
 			if (!uuid_equal(rdev0, rdev)) {
@@ -3111,7 +3045,7 @@
 			size += rdev->size;
 		}
 
-		if (mddev->nb_dev) {
+		if (!list_empty(&mddev->disks)) {
 			if (mddev->pers)
 				sz += sprintf(page + sz, "\n      %d blocks",
 						 md_size[mdidx(mddev)]);
@@ -3947,6 +3881,5 @@
 EXPORT_SYMBOL(find_rdev_nr);
 EXPORT_SYMBOL(md_interrupt_thread);
 EXPORT_SYMBOL(mddev_map);
-EXPORT_SYMBOL(md_check_ordering);
 EXPORT_SYMBOL(get_spare);
 MODULE_LICENSE("GPL");
--- ./drivers/md/linear.c	2002/06/18 04:18:35	1.3
+++ ./drivers/md/linear.c	2002/06/18 04:29:32	1.4
@@ -33,39 +33,45 @@
 	linear_conf_t *conf;
 	struct linear_hash *table;
 	mdk_rdev_t *rdev;
-	int size, i, j, nb_zone;
+	int size, i, nb_zone, cnt;
 	unsigned int curr_offset;
+	struct list_head *tmp;
 
 	MOD_INC_USE_COUNT;
 
 	conf = kmalloc (sizeof (*conf), GFP_KERNEL);
 	if (!conf)
 		goto out;
+	memset(conf, 0, sizeof(*conf));
 	mddev->private = conf;
 
-	if (md_check_ordering(mddev)) {
-		printk("linear: disks are not ordered, aborting!\n");
-		goto out;
-	}
 	/*
 	 * Find the smallest device.
 	 */
 
 	conf->smallest = NULL;
-	curr_offset = 0;
-	ITERATE_RDEV_ORDERED(mddev,rdev,j) {
+	cnt = 0;
+	ITERATE_RDEV(mddev,rdev,tmp) {
+		int j = rdev->sb->this_disk.raid_disk;
 		dev_info_t *disk = conf->disks + j;
 
+		if (j < 0 || j > mddev->sb->raid_disks || disk->bdev) {
+			printk("linear: disk numbering problem. Aborting!\n");
+			goto out;
+		}
+
 		disk->dev = rdev->dev;
 		disk->bdev = rdev->bdev;
 		atomic_inc(&rdev->bdev->bd_count);
 		disk->size = rdev->size;
-		disk->offset = curr_offset;
-
-		curr_offset += disk->size;
 
 		if (!conf->smallest || (disk->size < conf->smallest->size))
 			conf->smallest = disk;
+		cnt++;
+	}
+	if (cnt != mddev->sb->raid_disks) {
+		printk("linear: not enough drives present. Aborting!\n");
+		goto out;
 	}
 
 	nb_zone = conf->nr_zones =
@@ -81,10 +87,13 @@
 	 * Here we generate the linear hash table
 	 */
 	table = conf->hash_table;
-	i = 0;
 	size = 0;
-	for (j = 0; j < mddev->nb_dev; j++) {
-		dev_info_t *disk = conf->disks + j;
+	curr_offset = 0;
+	for (i = 0; i < cnt; i++) {
+		dev_info_t *disk = conf->disks + i;
+
+		disk->offset = curr_offset;
+		curr_offset += disk->size;
 
 		if (size < 0) {
 			table[-1].dev1 = disk;
--- ./drivers/md/raid0.c	2002/06/18 04:18:35	1.3
+++ ./drivers/md/raid0.c	2002/06/18 04:29:32	1.4
@@ -28,21 +28,26 @@
 
 static int create_strip_zones (mddev_t *mddev)
 {
-	int i, c, j, j1, j2;
+	int i, c, j;
 	unsigned long current_offset, curr_zone_offset;
 	raid0_conf_t *conf = mddev_to_conf(mddev);
 	mdk_rdev_t *smallest, *rdev1, *rdev2, *rdev;
+	struct list_head *tmp1, *tmp2;
+	struct strip_zone *zone;
+	int cnt;
  
 	/*
 	 * The number of 'same size groups'
 	 */
 	conf->nr_strip_zones = 0;
  
-	ITERATE_RDEV_ORDERED(mddev,rdev1,j1) {
+	ITERATE_RDEV(mddev,rdev1,tmp1) {
 		printk("raid0: looking at %s\n", partition_name(rdev1->dev));
 		c = 0;
-		ITERATE_RDEV_ORDERED(mddev,rdev2,j2) {
-			printk("raid0:   comparing %s(%ld) with %s(%ld)\n", partition_name(rdev1->dev), rdev1->size, partition_name(rdev2->dev), rdev2->size);
+		ITERATE_RDEV(mddev,rdev2,tmp2) {
+			printk("raid0:   comparing %s(%ld) with %s(%ld)\n",
+			       partition_name(rdev1->dev), rdev1->size,
+			       partition_name(rdev2->dev), rdev2->size);
 			if (rdev2 == rdev1) {
 				printk("raid0:   END\n");
 				break;
@@ -50,7 +55,7 @@
 			if (rdev2->size == rdev1->size)
 			{
 				/*
-				 * Not unique, dont count it as a new
+				 * Not unique, don't count it as a new
 				 * group
 				 */
 				printk("raid0:   EQUAL\n");
@@ -65,29 +70,62 @@
 			printk("raid0: %d zones\n", conf->nr_strip_zones);
 		}
 	}
-		printk("raid0: FINAL %d zones\n", conf->nr_strip_zones);
+	printk("raid0: FINAL %d zones\n", conf->nr_strip_zones);
 
 	conf->strip_zone = vmalloc(sizeof(struct strip_zone)*
 				conf->nr_strip_zones);
 	if (!conf->strip_zone)
 		return 1;
 
+	memset(conf->strip_zone, 0,sizeof(struct strip_zone)*
+				   conf->nr_strip_zones);
+	/* The first zone must contain all devices, so here we check that
+	 * there is a properly alignment of slots to devices and find them all
+	 */
+	zone = &conf->strip_zone[0];
+	cnt = 0;
+	smallest = NULL;
+	ITERATE_RDEV(mddev, rdev1, tmp1) {
+		int j = rdev1->sb->this_disk.raid_disk;
+
+		if (j < 0 || j >= mddev->sb->raid_disks) {
+			printk("raid0: bad disk number %d - aborting!\n", j);
+			goto abort;
+		}
+		if (zone->dev[j]) {
+			printk("raid0: multiple devices for %d - aborting!\n", j);
+			goto abort;
+		}
+		zone->dev[j] = rdev1;
+		if (!smallest || (rdev1->size <smallest->size))
+			smallest = rdev1;
+		cnt++;
+	}
+	if (cnt != mddev->sb->raid_disks) {
+		printk("raid0: too few disks (%d of %d) - aborting!\n", cnt, 
+		       mddev->sb->raid_disks);
+		goto abort;
+	}
+	zone->nb_dev = cnt;
+	zone->size = smallest->size * cnt;
+	zone->zone_offset = 0;
+
+	conf->smallest = zone;
+	current_offset = smallest->size;
+	curr_zone_offset = zone->size;
 
-	conf->smallest = NULL;
-	current_offset = 0;
-	curr_zone_offset = 0;
-
-	for (i = 0; i < conf->nr_strip_zones; i++)
+	/* now do the other zones */
+	for (i = 1; i < conf->nr_strip_zones; i++)
 	{
-		struct strip_zone *zone = conf->strip_zone + i;
+		zone = conf->strip_zone + i;
 
 		printk("raid0: zone %d\n", i);
 		zone->dev_offset = current_offset;
 		smallest = NULL;
 		c = 0;
 
-		ITERATE_RDEV_ORDERED(mddev,rdev,j) {
-
+		for (j=0; j<cnt; j++) {
+			rdev = conf->strip_zone[0].dev[j];
 			printk("raid0: checking %s ...", partition_name(rdev->dev));
 			if (rdev->size > current_offset)
 			{
@@ -117,6 +155,9 @@
 	}
 	printk("raid0: done.\n");
 	return 0;
+ abort:
+	vfree(conf->strip_zone);
+	return 1;
 }
 
 static int raid0_run (mddev_t *mddev)
@@ -131,11 +172,6 @@
 		goto out;
 	mddev->private = (void *)conf;
  
-	if (md_check_ordering(mddev)) {
-		printk("raid0: disks are not ordered, aborting!\n");
-		goto out_free_conf;
-	}
-
 	if (create_strip_zones (mddev)) 
 		goto out_free_conf;
 
--- ./include/linux/raid/md_k.h	2002/06/18 04:18:35	1.4
+++ ./include/linux/raid/md_k.h	2002/06/18 04:29:32	1.5
@@ -196,14 +196,12 @@
 	mdk_personality_t		*pers;
 	int				__minor;
 	mdp_super_t			*sb;
-	int				nb_dev;
 	struct list_head 		disks;
 	int				sb_dirty;
 	int				ro;
 	unsigned long			curr_resync;	/* blocks scheduled */
 	unsigned long			resync_mark;	/* a recent timestamp */
 	unsigned long			resync_mark_cnt;/* blocks written at resync_mark */
-	char				*name;
 	int				recovery_running;
 	struct semaphore		reconfig_sem;
 	struct semaphore		recovery_sem;
@@ -279,13 +277,6 @@
  */
 #define ITERATE_RDEV(mddev,rdev,tmp)					\
 	ITERATE_RDEV_GENERIC((mddev)->disks,same_set,rdev,tmp)
-
-/*
- * Same as above, but assumes that the device has rdev->desc_nr numbered
- * from 0 to mddev->nb_dev, and iterates through rdevs in ascending order.
- */
-#define ITERATE_RDEV_ORDERED(mddev,rdev,i)				\
-	for (i = 0; rdev = find_rdev_nr(mddev, i), i < mddev->nb_dev; i++)
 
 
 /*
--- ./include/linux/raid/md.h	2002/06/18 04:27:49	1.1
+++ ./include/linux/raid/md.h	2002/06/18 04:29:32	1.2
@@ -82,7 +82,6 @@
 extern void md_done_sync(mddev_t *mddev, int blocks, int ok);
 extern void md_sync_acct(kdev_t dev, unsigned long nr_sectors);
 extern void md_recover_arrays (void);
-extern int md_check_ordering (mddev_t *mddev);
 extern int md_notify_reboot(struct notifier_block *this,
 					unsigned long code, void *x);
 extern int md_error (mddev_t *mddev, struct block_device *bdev);
