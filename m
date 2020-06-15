From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 07/16] md: rewrite md_setup_drive to avoid ioctls
Date: Mon, 15 Jun 2020 14:53:14 +0200
Message-ID: <20200615125323.930983-8-hch@lst.de>
References: <20200615125323.930983-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200615125323.930983-1-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Song Liu <song@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-raid.ids

md_setup_drive knows it works with md devices, so it is rather pointless
to open a file descriptor and issue ioctls.  Just call directly into the
relevant low-level md routines after getting a handle to the device using
blkdev_get_by_dev instead.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/md-autodetect.c | 127 ++++++++++++++++---------------------
 drivers/md/md.c            |  20 +++---
 drivers/md/md.h            |   6 ++
 3 files changed, 71 insertions(+), 82 deletions(-)

diff --git a/drivers/md/md-autodetect.c b/drivers/md/md-autodetect.c
index a43a8f1580584c..5b24b5616d3acc 100644
--- a/drivers/md/md-autodetect.c
+++ b/drivers/md/md-autodetect.c
@@ -2,7 +2,6 @@
 #include <linux/kernel.h>
 #include <linux/blkdev.h>
 #include <linux/init.h>
-#include <linux/syscalls.h>
 #include <linux/mount.h>
 #include <linux/major.h>
 #include <linux/delay.h>
@@ -120,37 +119,29 @@ static int __init md_setup(char *str)
 	return 1;
 }
 
-static inline int create_dev(char *name, dev_t dev)
-{
-	ksys_unlink(name);
-	return ksys_mknod(name, S_IFBLK|0600, new_encode_dev(dev));
-}
-
 static void __init md_setup_drive(struct md_setup_args *args)
 {
-	int minor, i, partitioned;
-	dev_t dev;
-	dev_t devices[MD_SB_DISKS+1];
-	int fd;
-	int err = 0;
-	char *devname;
-	mdu_disk_info_t dinfo;
+	char *devname = args->device_names;
+	dev_t devices[MD_SB_DISKS + 1], mdev;
+	struct mdu_array_info_s ainfo = { };
+	struct block_device *bdev;
+	struct mddev *mddev;
+	int err = 0, i;
 	char name[16];
 
-	minor = args->minor;
-	partitioned = args->partitioned;
-	devname = args->device_names;
+	if (args->partitioned) {
+		mdev = MKDEV(mdp_major, args->minor << MdpMinorShift);
+		sprintf(name, "md_d%d", args->minor);
+	} else {
+		mdev = MKDEV(MD_MAJOR, args->minor);
+		sprintf(name, "md%d", args->minor);
+	}
 
-	sprintf(name, "/dev/md%s%d", partitioned?"_d":"", minor);
-	if (partitioned)
-		dev = MKDEV(mdp_major, minor << MdpMinorShift);
-	else
-		dev = MKDEV(MD_MAJOR, minor);
-	create_dev(name, dev);
 	for (i = 0; i < MD_SB_DISKS && devname != NULL; i++) {
 		struct kstat stat;
 		char *p;
 		char comp_name[64];
+		dev_t dev;
 
 		p = strchr(devname, ',');
 		if (p)
@@ -163,7 +154,7 @@ static void __init md_setup_drive(struct md_setup_args *args)
 		if (vfs_stat(comp_name, &stat) == 0 && S_ISBLK(stat.mode))
 			dev = new_decode_dev(stat.rdev);
 		if (!dev) {
-			printk(KERN_WARNING "md: Unknown device name: %s\n", devname);
+			pr_warn("md: Unknown device name: %s\n", devname);
 			break;
 		}
 
@@ -175,68 +166,64 @@ static void __init md_setup_drive(struct md_setup_args *args)
 	if (!i)
 		return;
 
-	printk(KERN_INFO "md: Loading md%s%d: %s\n",
-		partitioned ? "_d" : "", minor,
-		args->device_names);
+	pr_info("md: Loading %s: %s\n", name, args->device_names);
 
-	fd = ksys_open(name, 0, 0);
-	if (fd < 0) {
-		printk(KERN_ERR "md: open failed - cannot start "
-				"array %s\n", name);
+	bdev = blkdev_get_by_dev(mdev, FMODE_READ, NULL);
+	if (IS_ERR(bdev)) {
+		pr_err("md: open failed - cannot start array %s\n", name);
 		return;
 	}
-	if (ksys_ioctl(fd, SET_ARRAY_INFO, 0) == -EBUSY) {
-		printk(KERN_WARNING
-		       "md: Ignoring md=%d, already autodetected. (Use raid=noautodetect)\n",
-		       minor);
-		ksys_close(fd);
-		return;
+	mddev = bdev->bd_disk->private_data;
+
+	err = mddev_lock(mddev);
+	if (err) {
+		pr_err("md: failed to lock array %s\n", name);
+		goto out_blkdev_put;
+	}
+
+	if (!list_empty(&mddev->disks) || mddev->raid_disks) {
+		pr_warn("md: Ignoring %s, already autodetected. (Use raid=noautodetect)\n",
+		       name);
+		goto out_unlock;
 	}
 
 	if (args->level != LEVEL_NONE) {
 		/* non-persistent */
-		mdu_array_info_t ainfo;
 		ainfo.level = args->level;
-		ainfo.size = 0;
-		ainfo.nr_disks =0;
-		ainfo.raid_disks =0;
-		while (devices[ainfo.raid_disks])
-			ainfo.raid_disks++;
-		ainfo.md_minor =minor;
+		ainfo.md_minor = args->minor;
 		ainfo.not_persistent = 1;
-
 		ainfo.state = (1 << MD_SB_CLEAN);
-		ainfo.layout = 0;
 		ainfo.chunk_size = args->chunk;
-		err = ksys_ioctl(fd, SET_ARRAY_INFO, (long)&ainfo);
-		for (i = 0; !err && i <= MD_SB_DISKS; i++) {
-			dev = devices[i];
-			if (!dev)
-				break;
+		while (devices[ainfo.raid_disks])
+			ainfo.raid_disks++;
+	}
+
+	err = md_set_array_info(mddev, &ainfo);
+
+	for (i = 0; i <= MD_SB_DISKS && devices[i]; i++) {
+		struct mdu_disk_info_s dinfo = {
+			.major	= MAJOR(devices[i]),
+			.minor	= MINOR(devices[i]),
+		};
+
+		if (args->level != LEVEL_NONE) {
 			dinfo.number = i;
 			dinfo.raid_disk = i;
-			dinfo.state = (1<<MD_DISK_ACTIVE)|(1<<MD_DISK_SYNC);
-			dinfo.major = MAJOR(dev);
-			dinfo.minor = MINOR(dev);
-			err = ksys_ioctl(fd, ADD_NEW_DISK,
-					 (long)&dinfo);
-		}
-	} else {
-		/* persistent */
-		for (i = 0; i <= MD_SB_DISKS; i++) {
-			dev = devices[i];
-			if (!dev)
-				break;
-			dinfo.major = MAJOR(dev);
-			dinfo.minor = MINOR(dev);
-			ksys_ioctl(fd, ADD_NEW_DISK, (long)&dinfo);
+			dinfo.state =
+				(1 << MD_DISK_ACTIVE) | (1 << MD_DISK_SYNC);
 		}
+
+		md_add_new_disk(mddev, &dinfo);
 	}
+
 	if (!err)
-		err = ksys_ioctl(fd, RUN_ARRAY, 0);
+		err = do_md_run(mddev);
 	if (err)
-		printk(KERN_WARNING "md: starting md%d failed\n", minor);
-	ksys_close(fd);
+		pr_warn("md: starting %s failed\n", name);
+out_unlock:
+	mddev_unlock(mddev);
+out_blkdev_put:
+	blkdev_put(bdev, FMODE_READ);
 }
 
 static int __init raid_setup(char *str)
@@ -286,8 +273,6 @@ void __init md_run_setup(void)
 {
 	int ent;
 
-	create_dev("/dev/md0", MKDEV(MD_MAJOR, 0));
-
 	if (raid_noautodetect)
 		printk(KERN_INFO "md: Skipping autodetection of RAID arrays. (raid=autodetect will force)\n");
 	else
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 6e9a48da474848..9960cfeb59a50c 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4368,7 +4368,6 @@ array_state_show(struct mddev *mddev, char *page)
 
 static int do_md_stop(struct mddev *mddev, int ro, struct block_device *bdev);
 static int md_set_readonly(struct mddev *mddev, struct block_device *bdev);
-static int do_md_run(struct mddev *mddev);
 static int restart_array(struct mddev *mddev);
 
 static ssize_t
@@ -6015,7 +6014,7 @@ int md_run(struct mddev *mddev)
 }
 EXPORT_SYMBOL_GPL(md_run);
 
-static int do_md_run(struct mddev *mddev)
+int do_md_run(struct mddev *mddev)
 {
 	int err;
 
@@ -6651,7 +6650,7 @@ static int get_disk_info(struct mddev *mddev, void __user * arg)
 	return 0;
 }
 
-static int add_new_disk(struct mddev *mddev, mdu_disk_info_t *info)
+int md_add_new_disk(struct mddev *mddev, struct mdu_disk_info_s *info)
 {
 	char b[BDEVNAME_SIZE], b2[BDEVNAME_SIZE];
 	struct md_rdev *rdev;
@@ -6697,7 +6696,7 @@ static int add_new_disk(struct mddev *mddev, mdu_disk_info_t *info)
 	}
 
 	/*
-	 * add_new_disk can be used once the array is assembled
+	 * md_add_new_disk can be used once the array is assembled
 	 * to add "hot spares".  They must already have a superblock
 	 * written
 	 */
@@ -6810,7 +6809,7 @@ static int add_new_disk(struct mddev *mddev, mdu_disk_info_t *info)
 		return err;
 	}
 
-	/* otherwise, add_new_disk is only allowed
+	/* otherwise, md_add_new_disk is only allowed
 	 * for major_version==0 superblocks
 	 */
 	if (mddev->major_version != 0) {
@@ -7055,7 +7054,7 @@ static int set_bitmap_file(struct mddev *mddev, int fd)
 }
 
 /*
- * set_array_info is used two different ways
+ * md_set_array_info is used two different ways
  * The original usage is when creating a new array.
  * In this usage, raid_disks is > 0 and it together with
  *  level, size, not_persistent,layout,chunksize determine the
@@ -7067,9 +7066,8 @@ static int set_bitmap_file(struct mddev *mddev, int fd)
  *  The minor and patch _version numbers are also kept incase the
  *  super_block handler wishes to interpret them.
  */
-static int set_array_info(struct mddev *mddev, mdu_array_info_t *info)
+int md_set_array_info(struct mddev *mddev, struct mdu_array_info_s *info)
 {
-
 	if (info->raid_disks == 0) {
 		/* just setting version number for superblock loading */
 		if (info->major_version < 0 ||
@@ -7560,7 +7558,7 @@ static int md_ioctl(struct block_device *bdev, fmode_t mode,
 			err = -EBUSY;
 			goto unlock;
 		}
-		err = set_array_info(mddev, &info);
+		err = md_set_array_info(mddev, &info);
 		if (err) {
 			pr_warn("md: couldn't set array info. %d\n", err);
 			goto unlock;
@@ -7614,7 +7612,7 @@ static int md_ioctl(struct block_device *bdev, fmode_t mode,
 				/* Need to clear read-only for this */
 				break;
 			else
-				err = add_new_disk(mddev, &info);
+				err = md_add_new_disk(mddev, &info);
 			goto unlock;
 		}
 		break;
@@ -7682,7 +7680,7 @@ static int md_ioctl(struct block_device *bdev, fmode_t mode,
 		if (copy_from_user(&info, argp, sizeof(info)))
 			err = -EFAULT;
 		else
-			err = add_new_disk(mddev, &info);
+			err = md_add_new_disk(mddev, &info);
 		goto unlock;
 	}
 
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 6f8fff77ce10a5..7ee81aa2eac862 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -801,7 +801,13 @@ static inline void mddev_check_write_zeroes(struct mddev *mddev, struct bio *bio
 		mddev->queue->limits.max_write_zeroes_sectors = 0;
 }
 
+struct mdu_array_info_s;
+struct mdu_disk_info_s;
+
 extern int mdp_major;
 void md_autostart_arrays(int part);
+int md_set_array_info(struct mddev *mddev, struct mdu_array_info_s *info);
+int md_add_new_disk(struct mddev *mddev, struct mdu_disk_info_s *info);
+int do_md_run(struct mddev *mddev);
 
 #endif /* _MD_MD_H */
-- 
2.26.2
