From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 6 of 7 - Allow partitioning of MD devices.
Date: Fri, 23 Jan 2004 11:14:25 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E1Ajoxt-0000k2-00@notabene>
References: <20040123105615.2237.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
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

 ----------- Diffstat output ------------
 ./drivers/md/md.c |   64 ++++++++++++++++++++++++++++++++++++++++++------------
 1 files changed, 50 insertions(+), 14 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2004-01-23 10:37:44.000000000 +1100
+++ ./drivers/md/md.c	2004-01-23 10:37:32.000000000 +1100
@@ -52,6 +52,9 @@
 #define MAJOR_NR MD_MAJOR
 #define MD_DRIVER
 
+/* 63 partitions with the alternate major number (mdp) */
+#define MdpMinorShift 6
+
 #define DEBUG 0
 #define dprintk(x...) ((void)(DEBUG && printk(x)))
 
@@ -1442,14 +1445,24 @@ abort:
 	return 1;
 }
 
+static int mdp_major = 0;
 
 static struct kobject *md_probe(dev_t dev, int *part, void *data)
 {
 	static DECLARE_MUTEX(disks_sem);
-	int unit = *part;
-	mddev_t *mddev = mddev_find(unit);
+	int unit;
+	int minor;
+	mddev_t *mddev;
 	struct gendisk *disk;
 
+	if (data) {
+		unit = *part >> MdpMinorShift;
+		minor = unit << MdpMinorShift;
+		unit = -1-unit;
+	} else
+		minor = unit = *part;
+
+	mddev = mddev_find(unit);
 	if (!mddev)
 		return NULL;
 
@@ -1459,15 +1472,18 @@ static struct kobject *md_probe(dev_t de
 		mddev_put(mddev);
 		return NULL;
 	}
-	disk = alloc_disk(1);
+	disk = alloc_disk(data ? (1<<MdpMinorShift) : 1);
 	if (!disk) {
 		up(&disks_sem);
 		mddev_put(mddev);
 		return NULL;
 	}
-	disk->major = MD_MAJOR;
-	disk->first_minor = mdidx(mddev);
-	sprintf(disk->disk_name, "md%d", mdidx(mddev));
+	disk->major = data ? mdp_major : MD_MAJOR;
+	disk->first_minor = minor;
+	if (data)
+		sprintf(disk->disk_name, "md_d%d", minor >> MdpMinorShift);
+	else
+		sprintf(disk->disk_name, "md%d", minor);
 	disk->fops = &md_fops;
 	disk->private_data = mddev;
 	disk->queue = mddev->queue;
@@ -1495,6 +1511,7 @@ static int do_md_run(mddev_t * mddev)
 	struct list_head *tmp;
 	mdk_rdev_t *rdev;
 	struct gendisk *disk;
+	struct block_device *bdev;
 	char b[BDEVNAME_SIZE];
 	int unit;
 
@@ -1636,6 +1653,19 @@ static int do_md_run(mddev_t * mddev)
 	mddev->queue->queuedata = mddev;
 	mddev->queue->make_request_fn = mddev->pers->make_request;
 
+	bdev = bdget_disk(disk, 0);
+	if (bdev) {
+		/* We need to reread the partition table, and that requires
+		 * setting the size of the blockdev inode suitably.
+		 * This code should really be export from block_dev.c,
+		 * but for now it is copied from dm.c:__set_size
+		 */
+		down(&bdev->bd_inode->i_sem);
+		i_size_write(bdev->bd_inode, (loff_t)mddev->array_size << 10);
+		up(&bdev->bd_inode->i_sem);
+		ioctl_by_bdev(bdev, BLKRRPART, 0);
+		bdput(bdev);
+	}
 	return 0;
 }
 
@@ -2366,7 +2396,6 @@ static int md_ioctl(struct inode *inode,
 			unsigned int cmd, unsigned long arg)
 {
 	char b[BDEVNAME_SIZE];
-	unsigned int minor = iminor(inode);
 	int err = 0;
 	struct hd_geometry *loc = (struct hd_geometry *) arg;
 	mddev_t *mddev = NULL;
@@ -2374,11 +2403,6 @@ static int md_ioctl(struct inode *inode,
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
@@ -3497,15 +3521,23 @@ int __init md_init(void)
 
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
+			    md_probe, NULL, (void*)1);
 
 	for (minor=0; minor < MAX_MD_DEVS; ++minor) {
 		devfs_mk_bdev(MKDEV(MAJOR_NR, minor),
 				S_IFBLK|S_IRUSR|S_IWUSR,
 				"md/%d", minor);
+		devfs_mk_bdev(MKDEV(mdp_major, minor<<MdpMinorShift),
+			      S_IFBLK|S_IRUSR|S_IWUSR,
+			      "md/d%d", minor);
 	}
 
 	register_reboot_notifier(&md_notifier);
@@ -3568,11 +3600,15 @@ static __exit void md_exit(void)
 	struct list_head *tmp;
 	int i;
 	blk_unregister_region(MKDEV(MAJOR_NR,0), MAX_MD_DEVS);
-	for (i=0; i < MAX_MD_DEVS; i++)
+	blk_unregister_region(MKDEV(mdp_major,0), MAX_MD_DEVS << MdpMinorShift);
+	for (i=0; i < MAX_MD_DEVS; i++) {
 		devfs_remove("md/%d", i);
+		devfs_remove("md/d%d", i);
+	}
 	devfs_remove("md");
 
 	unregister_blkdev(MAJOR_NR,"md");
+	unregister_blkdev(mdp_major, "mdp");
 	unregister_reboot_notifier(&md_notifier);
 	unregister_sysctl_table(raid_table_header);
 	remove_proc_entry("mdstat", NULL);
