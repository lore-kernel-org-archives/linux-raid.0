From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 8 of 10 - Remove the 'disks' array from md which holds the gendisk structures.
Date: Fri, 16 Jan 2004 12:19:40 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E1AhIeC-0002Uu-00@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

### Comments for ChangeSet

Move the pointers into mddev.  The reduces dependance on MAX_MD_DEVS.

 ----------- Diffstat output ------------
 ./drivers/md/md.c           |   27 +++++++++++++--------------
 ./include/linux/raid/md_k.h |    2 ++
 2 files changed, 15 insertions(+), 14 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2004-01-16 12:06:43.000000000 +1100
+++ ./drivers/md/md.c	2004-01-16 12:07:31.000000000 +1100
@@ -123,8 +123,6 @@ static ctl_table raid_root_table[] = {
 
 static struct block_device_operations md_fops;
 
-static struct gendisk *disks[MAX_MD_DEVS];
-
 /*
  * Enables to iterate over all existing md arrays
  * all_mddevs_lock protects this list as well as mddev_map.
@@ -1461,7 +1459,7 @@ static struct kobject *md_probe(dev_t de
 		return NULL;
 
 	down(&disks_sem);
-	if (disks[unit]) {
+	if (mddev->gendisk) {
 		up(&disks_sem);
 		mddev_put(mddev);
 		return NULL;
@@ -1479,7 +1477,7 @@ static struct kobject *md_probe(dev_t de
 	disk->private_data = mddev;
 	disk->queue = mddev->queue;
 	add_disk(disk);
-	disks[mdidx(mddev)] = disk;
+	mddev->gendisk = disk;
 	up(&disks_sem);
 	return NULL;
 }
@@ -1597,7 +1595,7 @@ static int do_md_run(mddev_t * mddev)
 
 	unit = mdidx(mddev);
 	md_probe(0, &unit, NULL);
-	disk = disks[unit];
+	disk = mddev->gendisk;
 	if (!disk)
 		return -ENOMEM;
 
@@ -1648,7 +1646,7 @@ static int do_md_run(mddev_t * mddev)
 
 static int restart_array(mddev_t *mddev)
 {
-	struct gendisk *disk = disks[mdidx(mddev)];
+	struct gendisk *disk = mddev->gendisk;
 	int err;
 
 	/*
@@ -1688,7 +1686,7 @@ out:
 static int do_md_stop(mddev_t * mddev, int ro)
 {
 	int err = 0;
-	struct gendisk *disk = disks[mdidx(mddev)];
+	struct gendisk *disk = mddev->gendisk;
 
 	if (mddev->pers) {
 		if (atomic_read(&mddev->active)>2) {
@@ -1739,7 +1737,7 @@ static int do_md_stop(mddev_t * mddev, i
 		export_array(mddev);
 
 		mddev->array_size = 0;
-		disk = disks[mdidx(mddev)];
+		disk = mddev->gendisk;
 		if (disk)
 			set_capacity(disk, 0);
 	} else
@@ -2528,7 +2526,7 @@ static int md_ioctl(struct inode *inode,
 			err = put_user (4, (char *) &loc->sectors);
 			if (err)
 				goto abort_unlock;
-			err = put_user(get_capacity(disks[mdidx(mddev)])/8,
+			err = put_user(get_capacity(mddev->gendisk)/8,
 						(short *) &loc->cylinders);
 			if (err)
 				goto abort_unlock;
@@ -3568,6 +3566,8 @@ static void autostart_arrays(void)
 
 static __exit void md_exit(void)
 {
+	mddev_t *mddev;
+	struct list_head *tmp;
 	int i;
 	blk_unregister_region(MKDEV(MAJOR_NR,0), MAX_MD_DEVS);
 	for (i=0; i < MAX_MD_DEVS; i++)
@@ -3580,15 +3580,14 @@ static __exit void md_exit(void)
 #ifdef CONFIG_PROC_FS
 	remove_proc_entry("mdstat", NULL);
 #endif
-	for (i = 0; i < MAX_MD_DEVS; i++) {
-		struct gendisk *disk = disks[i];
-		mddev_t *mddev;
-		if (!disks[i])
+	ITERATE_MDDEV(mddev,tmp) {
+		struct gendisk *disk = mddev->gendisk;
+		if (!disk)
 			continue;
-		mddev = disk->private_data;
 		export_array(mddev);
 		del_gendisk(disk);
 		put_disk(disk);
+		mddev->gendisk = NULL;
 		mddev_put(mddev);
 	}
 }

diff ./include/linux/raid/md_k.h~current~ ./include/linux/raid/md_k.h
--- ./include/linux/raid/md_k.h~current~	2004-01-16 11:58:49.000000000 +1100
+++ ./include/linux/raid/md_k.h	2004-01-16 12:07:31.000000000 +1100
@@ -188,6 +188,8 @@ struct mddev_s
 	int				sb_dirty;
 	int				ro;
 
+	struct gendisk			*gendisk;
+
 	/* Superblock information */
 	int				major_version,
 					minor_version,
