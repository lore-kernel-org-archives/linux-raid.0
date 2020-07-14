From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 08/23] md: simplify md_setup_drive
Date: Tue, 14 Jul 2020 21:04:12 +0200
Message-ID: <20200714190427.4332-9-hch@lst.de>
References: <20200714190427.4332-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200714190427.4332-1-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Song Liu <song@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-raid.ids

Move the loop over the possible arrays into the caller to remove a level
of indentation for the whole function.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Song Liu <song@kernel.org>
---
 drivers/md/md-autodetect.c | 203 ++++++++++++++++++-------------------
 1 file changed, 101 insertions(+), 102 deletions(-)

diff --git a/drivers/md/md-autodetect.c b/drivers/md/md-autodetect.c
index 6bc9b734eee6ff..a43a8f1580584c 100644
--- a/drivers/md/md-autodetect.c
+++ b/drivers/md/md-autodetect.c
@@ -27,7 +27,7 @@ static int __initdata raid_noautodetect=1;
 #endif
 static int __initdata raid_autopart;
 
-static struct {
+static struct md_setup_args {
 	int minor;
 	int partitioned;
 	int level;
@@ -126,122 +126,117 @@ static inline int create_dev(char *name, dev_t dev)
 	return ksys_mknod(name, S_IFBLK|0600, new_encode_dev(dev));
 }
 
-static void __init md_setup_drive(void)
+static void __init md_setup_drive(struct md_setup_args *args)
 {
-	int minor, i, ent, partitioned;
+	int minor, i, partitioned;
 	dev_t dev;
 	dev_t devices[MD_SB_DISKS+1];
+	int fd;
+	int err = 0;
+	char *devname;
+	mdu_disk_info_t dinfo;
+	char name[16];
 
-	for (ent = 0; ent < md_setup_ents ; ent++) {
-		int fd;
-		int err = 0;
-		char *devname;
-		mdu_disk_info_t dinfo;
-		char name[16];
+	minor = args->minor;
+	partitioned = args->partitioned;
+	devname = args->device_names;
 
-		minor = md_setup_args[ent].minor;
-		partitioned = md_setup_args[ent].partitioned;
-		devname = md_setup_args[ent].device_names;
+	sprintf(name, "/dev/md%s%d", partitioned?"_d":"", minor);
+	if (partitioned)
+		dev = MKDEV(mdp_major, minor << MdpMinorShift);
+	else
+		dev = MKDEV(MD_MAJOR, minor);
+	create_dev(name, dev);
+	for (i = 0; i < MD_SB_DISKS && devname != NULL; i++) {
+		struct kstat stat;
+		char *p;
+		char comp_name[64];
 
-		sprintf(name, "/dev/md%s%d", partitioned?"_d":"", minor);
-		if (partitioned)
-			dev = MKDEV(mdp_major, minor << MdpMinorShift);
-		else
-			dev = MKDEV(MD_MAJOR, minor);
-		create_dev(name, dev);
-		for (i = 0; i < MD_SB_DISKS && devname != NULL; i++) {
-			struct kstat stat;
-			char *p;
-			char comp_name[64];
+		p = strchr(devname, ',');
+		if (p)
+			*p++ = 0;
 
-			p = strchr(devname, ',');
-			if (p)
-				*p++ = 0;
+		dev = name_to_dev_t(devname);
+		if (strncmp(devname, "/dev/", 5) == 0)
+			devname += 5;
+		snprintf(comp_name, 63, "/dev/%s", devname);
+		if (vfs_stat(comp_name, &stat) == 0 && S_ISBLK(stat.mode))
+			dev = new_decode_dev(stat.rdev);
+		if (!dev) {
+			printk(KERN_WARNING "md: Unknown device name: %s\n", devname);
+			break;
+		}
 
-			dev = name_to_dev_t(devname);
-			if (strncmp(devname, "/dev/", 5) == 0)
-				devname += 5;
-			snprintf(comp_name, 63, "/dev/%s", devname);
-			if (vfs_stat(comp_name, &stat) == 0 &&
-			    S_ISBLK(stat.mode))
-				dev = new_decode_dev(stat.rdev);
-			if (!dev) {
-				printk(KERN_WARNING "md: Unknown device name: %s\n", devname);
-				break;
-			}
+		devices[i] = dev;
+		devname = p;
+	}
+	devices[i] = 0;
 
-			devices[i] = dev;
+	if (!i)
+		return;
 
-			devname = p;
-		}
-		devices[i] = 0;
+	printk(KERN_INFO "md: Loading md%s%d: %s\n",
+		partitioned ? "_d" : "", minor,
+		args->device_names);
 
-		if (!i)
-			continue;
+	fd = ksys_open(name, 0, 0);
+	if (fd < 0) {
+		printk(KERN_ERR "md: open failed - cannot start "
+				"array %s\n", name);
+		return;
+	}
+	if (ksys_ioctl(fd, SET_ARRAY_INFO, 0) == -EBUSY) {
+		printk(KERN_WARNING
+		       "md: Ignoring md=%d, already autodetected. (Use raid=noautodetect)\n",
+		       minor);
+		ksys_close(fd);
+		return;
+	}
 
-		printk(KERN_INFO "md: Loading md%s%d: %s\n",
-			partitioned ? "_d" : "", minor,
-			md_setup_args[ent].device_names);
+	if (args->level != LEVEL_NONE) {
+		/* non-persistent */
+		mdu_array_info_t ainfo;
+		ainfo.level = args->level;
+		ainfo.size = 0;
+		ainfo.nr_disks =0;
+		ainfo.raid_disks =0;
+		while (devices[ainfo.raid_disks])
+			ainfo.raid_disks++;
+		ainfo.md_minor =minor;
+		ainfo.not_persistent = 1;
 
-		fd = ksys_open(name, 0, 0);
-		if (fd < 0) {
-			printk(KERN_ERR "md: open failed - cannot start "
-					"array %s\n", name);
-			continue;
-		}
-		if (ksys_ioctl(fd, SET_ARRAY_INFO, 0) == -EBUSY) {
-			printk(KERN_WARNING
-			       "md: Ignoring md=%d, already autodetected. (Use raid=noautodetect)\n",
-			       minor);
-			ksys_close(fd);
-			continue;
+		ainfo.state = (1 << MD_SB_CLEAN);
+		ainfo.layout = 0;
+		ainfo.chunk_size = args->chunk;
+		err = ksys_ioctl(fd, SET_ARRAY_INFO, (long)&ainfo);
+		for (i = 0; !err && i <= MD_SB_DISKS; i++) {
+			dev = devices[i];
+			if (!dev)
+				break;
+			dinfo.number = i;
+			dinfo.raid_disk = i;
+			dinfo.state = (1<<MD_DISK_ACTIVE)|(1<<MD_DISK_SYNC);
+			dinfo.major = MAJOR(dev);
+			dinfo.minor = MINOR(dev);
+			err = ksys_ioctl(fd, ADD_NEW_DISK,
+					 (long)&dinfo);
 		}
-
-		if (md_setup_args[ent].level != LEVEL_NONE) {
-			/* non-persistent */
-			mdu_array_info_t ainfo;
-			ainfo.level = md_setup_args[ent].level;
-			ainfo.size = 0;
-			ainfo.nr_disks =0;
-			ainfo.raid_disks =0;
-			while (devices[ainfo.raid_disks])
-				ainfo.raid_disks++;
-			ainfo.md_minor =minor;
-			ainfo.not_persistent = 1;
-
-			ainfo.state = (1 << MD_SB_CLEAN);
-			ainfo.layout = 0;
-			ainfo.chunk_size = md_setup_args[ent].chunk;
-			err = ksys_ioctl(fd, SET_ARRAY_INFO, (long)&ainfo);
-			for (i = 0; !err && i <= MD_SB_DISKS; i++) {
-				dev = devices[i];
-				if (!dev)
-					break;
-				dinfo.number = i;
-				dinfo.raid_disk = i;
-				dinfo.state = (1<<MD_DISK_ACTIVE)|(1<<MD_DISK_SYNC);
-				dinfo.major = MAJOR(dev);
-				dinfo.minor = MINOR(dev);
-				err = ksys_ioctl(fd, ADD_NEW_DISK,
-						 (long)&dinfo);
-			}
-		} else {
-			/* persistent */
-			for (i = 0; i <= MD_SB_DISKS; i++) {
-				dev = devices[i];
-				if (!dev)
-					break;
-				dinfo.major = MAJOR(dev);
-				dinfo.minor = MINOR(dev);
-				ksys_ioctl(fd, ADD_NEW_DISK, (long)&dinfo);
-			}
+	} else {
+		/* persistent */
+		for (i = 0; i <= MD_SB_DISKS; i++) {
+			dev = devices[i];
+			if (!dev)
+				break;
+			dinfo.major = MAJOR(dev);
+			dinfo.minor = MINOR(dev);
+			ksys_ioctl(fd, ADD_NEW_DISK, (long)&dinfo);
 		}
-		if (!err)
-			err = ksys_ioctl(fd, RUN_ARRAY, 0);
-		if (err)
-			printk(KERN_WARNING "md: starting md%d failed\n", minor);
-		ksys_close(fd);
 	}
+	if (!err)
+		err = ksys_ioctl(fd, RUN_ARRAY, 0);
+	if (err)
+		printk(KERN_WARNING "md: starting md%d failed\n", minor);
+	ksys_close(fd);
 }
 
 static int __init raid_setup(char *str)
@@ -289,11 +284,15 @@ static void __init autodetect_raid(void)
 
 void __init md_run_setup(void)
 {
+	int ent;
+
 	create_dev("/dev/md0", MKDEV(MD_MAJOR, 0));
 
 	if (raid_noautodetect)
 		printk(KERN_INFO "md: Skipping autodetection of RAID arrays. (raid=autodetect will force)\n");
 	else
 		autodetect_raid();
-	md_setup_drive();
+
+	for (ent = 0; ent < md_setup_ents; ent++)
+		md_setup_drive(&md_setup_args[ent]);
 }
-- 
2.27.0
