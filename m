From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 7 of 7 - Allow partitioning of MD devices.
Date: Fri, 06 Feb 2004 16:35:55 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E1Aoyeh-000847-00@notabene>
References: <20040206162532.30220.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Al Viro <viro@parcelfarce.linux.theplanet.co.uk>
List-Id: linux-raid.ids


With this patch, md used two major numbers for arrays.

One Major is number 9 with name 'md'  have unpartitioned md arrays,
one per minor number.

The other Major is allocated dynamically with name 'mdp' and had 
on array for every 64 minors, allowing for upto 63 partitions.

The arrays under one major are completely separate from the arrays
under the other.

The preferred name for devices with the new major are of the form:

  /dev/md/d1p3  # partion 3 of device 1 - minor 67

When a paritioned md device is assembled, the partitions are not recognised
until after the whole-array device is opened again.  A future version of
mdadm will perform this open so that the need will be transparent.

 ----------- Diffstat output ------------
 ./drivers/md/md.c           |  105 +++++++++++++++++++++++++++++++-------------
 ./drivers/md/raid5.c        |    2 
 ./drivers/md/raid6main.c    |    2 
 ./include/linux/raid/md_k.h |   13 +----
 4 files changed, 80 insertions(+), 42 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2004-02-06 16:17:55.000000000 +1100
+++ ./drivers/md/md.c	2004-02-06 16:22:56.000000000 +1100
@@ -52,6 +52,9 @@
 #define MAJOR_NR MD_MAJOR
 #define MD_DRIVER
 
+/* 63 partitions with the alternate major number (mdp) */
+#define MdpMinorShift 6
+
 #define DEBUG 0
 #define dprintk(x...) ((void)(DEBUG && printk(x)))
 
@@ -178,14 +181,14 @@ static void mddev_put(mddev_t *mddev)
 	spin_unlock(&all_mddevs_lock);
 }
 
-static mddev_t * mddev_find(int unit)
+static mddev_t * mddev_find(dev_t unit)
 {
 	mddev_t *mddev, *new = NULL;
 
  retry:
 	spin_lock(&all_mddevs_lock);
 	list_for_each_entry(mddev, &all_mddevs, all_mddevs)
-		if (mdidx(mddev) == unit) {
+		if (mddev->unit == unit) {
 			mddev_get(mddev);
 			spin_unlock(&all_mddevs_lock);
 			if (new)
@@ -206,7 +209,12 @@ static mddev_t * mddev_find(int unit)
 
 	memset(new, 0, sizeof(*new));
 
-	new->__minor = unit;
+	new->unit = unit;
+	if (MAJOR(unit) == MD_MAJOR)
+		new->md_minor = MINOR(unit);
+	else
+		new->md_minor = MINOR(unit) >> MdpMinorShift;
+
 	init_MUTEX(&new->reconfig_sem);
 	INIT_LIST_HEAD(&new->disks);
 	INIT_LIST_HEAD(&new->all_mddevs);
@@ -660,7 +668,7 @@ static void super_90_sync(mddev_t *mddev
 	sb->level = mddev->level;
 	sb->size  = mddev->size;
 	sb->raid_disks = mddev->raid_disks;
-	sb->md_minor = mddev->__minor;
+	sb->md_minor = mddev->md_minor;
 	sb->not_persistent = !mddev->persistent;
 	sb->utime = mddev->utime;
 	sb->state = 0;
@@ -1442,13 +1450,16 @@ abort:
 	return 1;
 }
 
+static int mdp_major = 0;
 
 static struct kobject *md_probe(dev_t dev, int *part, void *data)
 {
 	static DECLARE_MUTEX(disks_sem);
-	int unit = *part;
-	mddev_t *mddev = mddev_find(unit);
+	mddev_t *mddev = mddev_find(dev);
 	struct gendisk *disk;
+	int partitioned = (MAJOR(dev) != MD_MAJOR);
+	int shift = partitioned ? MdpMinorShift : 0;
+	int unit = MINOR(dev) >> shift;
 
 	if (!mddev)
 		return NULL;
@@ -1459,15 +1470,18 @@ static struct kobject *md_probe(dev_t de
 		mddev_put(mddev);
 		return NULL;
 	}
-	disk = alloc_disk(1);
+	disk = alloc_disk(1 << shift);
 	if (!disk) {
 		up(&disks_sem);
 		mddev_put(mddev);
 		return NULL;
 	}
-	disk->major = MD_MAJOR;
-	disk->first_minor = mdidx(mddev);
-	sprintf(disk->disk_name, "md%d", mdidx(mddev));
+	disk->major = MAJOR(dev);
+	disk->first_minor = unit << shift;
+	if (partitioned)
+		sprintf(disk->disk_name, "md_d%d", unit);
+	else
+		sprintf(disk->disk_name, "md%d", unit);
 	disk->fops = &md_fops;
 	disk->private_data = mddev;
 	disk->queue = mddev->queue;
@@ -1496,7 +1510,6 @@ static int do_md_run(mddev_t * mddev)
 	mdk_rdev_t *rdev;
 	struct gendisk *disk;
 	char b[BDEVNAME_SIZE];
-	int unit;
 
 	if (list_empty(&mddev->disks)) {
 		MD_BUG();
@@ -1588,8 +1601,7 @@ static int do_md_run(mddev_t * mddev)
 		invalidate_bdev(rdev->bdev, 0);
 	}
 
-	unit = mdidx(mddev);
-	md_probe(0, &unit, NULL);
+	md_probe(mddev->unit, NULL, NULL);
 	disk = mddev->gendisk;
 	if (!disk)
 		return -ENOMEM;
@@ -1636,6 +1648,7 @@ static int do_md_run(mddev_t * mddev)
 	mddev->queue->queuedata = mddev;
 	mddev->queue->make_request_fn = mddev->pers->make_request;
 
+	mddev->changed = 1;
 	return 0;
 }
 
@@ -1735,6 +1748,7 @@ static int do_md_stop(mddev_t * mddev, i
 		disk = mddev->gendisk;
 		if (disk)
 			set_capacity(disk, 0);
+		mddev->changed = 1;
 	} else
 		printk(KERN_INFO "md: %s switched to read-only mode.\n",
 			mdname(mddev));
@@ -1791,6 +1805,7 @@ static void autorun_devices(void)
 
 	printk(KERN_INFO "md: autorun ...\n");
 	while (!list_empty(&pending_raid_disks)) {
+		dev_t dev;
 		rdev0 = list_entry(pending_raid_disks.next,
 					 mdk_rdev_t, same_set);
 
@@ -1808,8 +1823,14 @@ static void autorun_devices(void)
 		 * mostly sane superblocks. It's time to allocate the
 		 * mddev.
 		 */
-
-		mddev = mddev_find(rdev0->preferred_minor);
+		if (rdev0->preferred_minor < 0 || rdev0->preferred_minor >= MAX_MD_DEVS) {
+			printk(KERN_INFO "md: unit number in %s is bad: %d\n", 
+			       bdevname(rdev0->bdev, b), rdev0->preferred_minor);
+			break;
+		}
+		dev = MKDEV(MD_MAJOR, rdev0->preferred_minor);
+		md_probe(dev, NULL, NULL);
+		mddev = mddev_find(dev);
 		if (!mddev) {
 			printk(KERN_ERR 
 				"md: cannot allocate memory for md drive.\n");
@@ -1824,7 +1845,7 @@ static void autorun_devices(void)
 				"md: %s already running, cannot run %s\n",
 				mdname(mddev), bdevname(rdev0->bdev,b));
 			mddev_unlock(mddev);
-		} else if (rdev0->preferred_minor >= 0 && rdev0->preferred_minor < MAX_MD_DEVS) {
+		} else {
 			printk(KERN_INFO "md: created %s\n", mdname(mddev));
 			ITERATE_RDEV_GENERIC(candidates,rdev,tmp) {
 				list_del_init(&rdev->same_set);
@@ -1833,9 +1854,7 @@ static void autorun_devices(void)
 			}
 			autorun_array(mddev);
 			mddev_unlock(mddev);
-		} else
-			printk(KERN_WARNING "md: %s had invalid preferred minor %d\n",
-			       bdevname(rdev->bdev, b), rdev0->preferred_minor);
+		}
 		/* on success, candidates will be empty, on error
 		 * it won't...
 		 */
@@ -1955,7 +1974,7 @@ static int get_array_info(mddev_t * mdde
 	info.size          = mddev->size;
 	info.nr_disks      = nr;
 	info.raid_disks    = mddev->raid_disks;
-	info.md_minor      = mddev->__minor;
+	info.md_minor      = mddev->md_minor;
 	info.not_persistent= !mddev->persistent;
 
 	info.utime         = mddev->utime;
@@ -2326,7 +2345,7 @@ static int set_array_info(mddev_t * mdde
 	mddev->level         = info->level;
 	mddev->size          = info->size;
 	mddev->raid_disks    = info->raid_disks;
-	/* don't set __minor, it is determined by which /dev/md* was
+	/* don't set md_minor, it is determined by which /dev/md* was
 	 * openned
 	 */
 	if (info->state & (1<<MD_SB_CLEAN))
@@ -2366,7 +2385,6 @@ static int md_ioctl(struct inode *inode,
 			unsigned int cmd, unsigned long arg)
 {
 	char b[BDEVNAME_SIZE];
-	unsigned int minor = iminor(inode);
 	int err = 0;
 	struct hd_geometry *loc = (struct hd_geometry *) arg;
 	mddev_t *mddev = NULL;
@@ -2374,11 +2392,6 @@ static int md_ioctl(struct inode *inode,
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
 
-	if (minor >= MAX_MD_DEVS) {
-		MD_BUG();
-		return -EINVAL;
-	}
-
 	/*
 	 * Commands dealing with the RAID driver but not any
 	 * particular array:
@@ -2620,6 +2633,7 @@ static int md_open(struct inode *inode, 
 	mddev_get(mddev);
 	mddev_unlock(mddev);
 
+	check_disk_change(inode->i_bdev);
  out:
 	return err;
 }
@@ -2635,12 +2649,28 @@ static int md_release(struct inode *inod
 	return 0;
 }
 
+static int md_media_changed(struct gendisk *disk)
+{
+	mddev_t *mddev = disk->private_data;
+
+	return mddev->changed;
+}
+
+static int md_revalidate(struct gendisk *disk)
+{
+	mddev_t *mddev = disk->private_data;
+
+	mddev->changed = 0;
+	return 0;
+}
 static struct block_device_operations md_fops =
 {
 	.owner		= THIS_MODULE,
 	.open		= md_open,
 	.release	= md_release,
 	.ioctl		= md_ioctl,
+	.media_changed	= md_media_changed,
+	.revalidate_disk= md_revalidate,
 };
 
 int md_thread(void * arg)
@@ -3505,16 +3535,26 @@ int __init md_init(void)
 
 	if (register_blkdev(MAJOR_NR, "md"))
 		return -1;
-
+	if ((mdp_major=register_blkdev(0, "mdp"))<=0) {
+		unregister_blkdev(MAJOR_NR, "md");
+		return -1;
+	}
 	devfs_mk_dir("md");
 	blk_register_region(MKDEV(MAJOR_NR, 0), MAX_MD_DEVS, THIS_MODULE,
 				md_probe, NULL, NULL);
+	blk_register_region(MKDEV(mdp_major, 0), MAX_MD_DEVS<<MdpMinorShift, THIS_MODULE,
+			    md_probe, NULL, NULL);
 
-	for (minor=0; minor < MAX_MD_DEVS; ++minor) {
+	for (minor=0; minor < MAX_MD_DEVS; ++minor)
 		devfs_mk_bdev(MKDEV(MAJOR_NR, minor),
 				S_IFBLK|S_IRUSR|S_IWUSR,
 				"md/%d", minor);
-	}
+
+	for (minor=0; minor < MAX_MD_DEVS; ++minor)
+		devfs_mk_bdev(MKDEV(mdp_major, minor<<MdpMinorShift),
+			      S_IFBLK|S_IRUSR|S_IWUSR,
+			      "md/d%d", minor);
+	
 
 	register_reboot_notifier(&md_notifier);
 	raid_table_header = register_sysctl_table(raid_root_table, 1);
@@ -3576,11 +3616,16 @@ static __exit void md_exit(void)
 	struct list_head *tmp;
 	int i;
 	blk_unregister_region(MKDEV(MAJOR_NR,0), MAX_MD_DEVS);
+	blk_unregister_region(MKDEV(mdp_major,0), MAX_MD_DEVS << MdpMinorShift);
 	for (i=0; i < MAX_MD_DEVS; i++)
 		devfs_remove("md/%d", i);
+	for (i=0; i < MAX_MD_DEVS; i++)
+		devfs_remove("md/d%d", i);
+
 	devfs_remove("md");
 
 	unregister_blkdev(MAJOR_NR,"md");
+	unregister_blkdev(mdp_major, "mdp");
 	unregister_reboot_notifier(&md_notifier);
 	unregister_sysctl_table(raid_table_header);
 	remove_proc_entry("mdstat", NULL);

diff ./drivers/md/raid5.c~current~ ./drivers/md/raid5.c
--- ./drivers/md/raid5.c~current~	2004-02-06 16:22:55.000000000 +1100
+++ ./drivers/md/raid5.c	2004-02-06 16:22:56.000000000 +1100
@@ -284,7 +284,7 @@ static int grow_stripes(raid5_conf_t *co
 	kmem_cache_t *sc;
 	int devs = conf->raid_disks;
 
-	sprintf(conf->cache_name, "md/raid5-%d", conf->mddev->__minor);
+	sprintf(conf->cache_name, "raid5/%s", mdname(conf->mddev));
 
 	sc = kmem_cache_create(conf->cache_name, 
 			       sizeof(struct stripe_head)+(devs-1)*sizeof(struct r5dev),

diff ./drivers/md/raid6main.c~current~ ./drivers/md/raid6main.c
--- ./drivers/md/raid6main.c~current~	2004-02-06 16:22:55.000000000 +1100
+++ ./drivers/md/raid6main.c	2004-02-06 16:22:56.000000000 +1100
@@ -303,7 +303,7 @@ static int grow_stripes(raid6_conf_t *co
 	kmem_cache_t *sc;
 	int devs = conf->raid_disks;
 
-	sprintf(conf->cache_name, "md/raid6-%d", conf->mddev->__minor);
+	sprintf(conf->cache_name, "raid6/%s", mdname(conf->mddev));
 
 	sc = kmem_cache_create(conf->cache_name,
 			       sizeof(struct stripe_head)+(devs-1)*sizeof(struct r5dev),

diff ./include/linux/raid/md_k.h~current~ ./include/linux/raid/md_k.h
--- ./include/linux/raid/md_k.h~current~	2004-02-06 16:22:55.000000000 +1100
+++ ./include/linux/raid/md_k.h	2004-02-06 16:22:56.000000000 +1100
@@ -186,7 +186,8 @@ struct mddev_s
 {
 	void				*private;
 	mdk_personality_t		*pers;
-	int				__minor;
+	dev_t				unit;
+	int				md_minor;
 	struct list_head 		disks;
 	int				sb_dirty;
 	int				ro;
@@ -235,6 +236,7 @@ struct mddev_s
 	struct semaphore		reconfig_sem;
 	atomic_t			active;
 
+	int				changed;	/* true if we might need to reread partition info */
 	int				degraded;	/* whether md should consider
 							 * adding a spare
 							 */
@@ -272,15 +274,6 @@ struct mdk_personality_s
 };
 
 
-/*
- * Currently we index md_array directly, based on the minor
- * number. This will have to change to dynamic allocation
- * once we start supporting partitioning of md devices.
- */
-static inline int mdidx (mddev_t * mddev)
-{
-	return mddev->__minor;
-}
 static inline char * mdname (mddev_t * mddev)
 {
 	return mddev->gendisk ? mddev->gendisk->disk_name : "mdX";
