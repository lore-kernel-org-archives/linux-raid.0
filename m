From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 2 of 2 - Allow assembling of partitioned arrays at boot time.
Date: Fri, 05 Mar 2004 16:45:37 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E1Az89R-0001t3-00@notabene>
References: <20040305164342.7205.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


kernel parameters:
   raid=partitionable
     will make all auto-detected md arrays partitionable
   md=d....
     will assemble an array as a partitionable array.

 ----------- Diffstat output ------------
 ./drivers/md/md.c     |   19 ++++++---
 ./init/do_mounts_md.c |   99 +++++++++++++++++++++++++++++---------------------
 2 files changed, 70 insertions(+), 48 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2004-03-05 16:43:23.000000000 +1100
+++ ./drivers/md/md.c	2004-03-05 16:43:24.000000000 +1100
@@ -57,7 +57,7 @@
 
 
 #ifndef MODULE
-static void autostart_arrays (void);
+static void autostart_arrays (int part);
 #endif
 
 static mdk_personality_t *pers[MAX_PERSONALITY];
@@ -1792,7 +1792,7 @@ static void autorun_array(mddev_t *mddev
  *
  * If "unit" is allocated, then bump its reference count
  */
-static void autorun_devices(void)
+static void autorun_devices(int part)
 {
 	struct list_head candidates;
 	struct list_head *tmp;
@@ -1825,7 +1825,12 @@ static void autorun_devices(void)
 			       bdevname(rdev0->bdev, b), rdev0->preferred_minor);
 			break;
 		}
-		dev = MKDEV(MD_MAJOR, rdev0->preferred_minor);
+		if (part)
+			dev = MKDEV(mdp_major,
+				    rdev0->preferred_minor << MdpMinorShift);
+		else
+			dev = MKDEV(MD_MAJOR, rdev0->preferred_minor);
+
 		md_probe(dev, NULL, NULL);
 		mddev = mddev_find(dev);
 		if (!mddev) {
@@ -1922,7 +1927,7 @@ static int autostart_array(dev_t startde
 	/*
 	 * possibly return codes
 	 */
-	autorun_devices();
+	autorun_devices(0);
 	return 0;
 
 }
@@ -2407,7 +2412,7 @@ static int md_ioctl(struct inode *inode,
 #ifndef MODULE
 		case RAID_AUTORUN:
 			err = 0;
-			autostart_arrays();
+			autostart_arrays(arg);
 			goto done;
 #endif
 		default:;
@@ -3577,7 +3582,7 @@ void md_autodetect_dev(dev_t dev)
 }
 
 
-static void autostart_arrays(void)
+static void autostart_arrays(int part)
 {
 	char b[BDEVNAME_SIZE];
 	mdk_rdev_t *rdev;
@@ -3602,7 +3607,7 @@ static void autostart_arrays(void)
 	}
 	dev_cnt = 0;
 
-	autorun_devices();
+	autorun_devices(part);
 }
 
 #endif

diff ./init/do_mounts_md.c~current~ ./init/do_mounts_md.c
--- ./init/do_mounts_md.c~current~	2004-03-05 16:43:23.000000000 +1100
+++ ./init/do_mounts_md.c	2004-03-05 16:43:24.000000000 +1100
@@ -12,14 +12,17 @@
  * The code for that is here.
  */
 
-static int __initdata raid_noautodetect;
+static int __initdata raid_noautodetect, raid_autopart;
 
 static struct {
-	char device_set [MAX_MD_DEVS];
-	int pers[MAX_MD_DEVS];
-	int chunk[MAX_MD_DEVS];
-	char *device_names[MAX_MD_DEVS];
-} md_setup_args __initdata;
+	int minor;
+	int partitioned;
+	int pers;
+	int chunk;
+	char *device_names;
+} md_setup_args[MAX_MD_DEVS] __initdata;
+
+static int md_setup_ents __initdata;
 
 /*
  * Parse the command-line parameters given our kernel, but do not
@@ -43,21 +46,37 @@ static struct {
  */
 static int __init md_setup(char *str)
 {
-	int minor, level, factor, fault, pers;
+	int minor, level, factor, fault, pers, partitioned = 0;
 	char *pername = "";
-	char *str1 = str;
+	char *str1;
+	int ent;
 
+	if (*str == 'd') {
+		partitioned = 1;
+		str++;
+	}
 	if (get_option(&str, &minor) != 2) {	/* MD Number */
 		printk(KERN_WARNING "md: Too few arguments supplied to md=.\n");
 		return 0;
 	}
+	str1 = str;
 	if (minor >= MAX_MD_DEVS) {
 		printk(KERN_WARNING "md: md=%d, Minor device number too high.\n", minor);
 		return 0;
-	} else if (md_setup_args.device_names[minor]) {
-		printk(KERN_WARNING "md: md=%d, Specified more than once. "
-		       "Replacing previous definition.\n", minor);
 	}
+	for (ent=0 ; ent< md_setup_ents ; ent++) 
+		if (md_setup_args[ent].minor == minor &&
+		    md_setup_args[ent].partitioned == partitioned) {
+			printk(KERN_WARNING "md: md=%s%d, Specified more than once. "
+			       "Replacing previous definition.\n", partitioned?"d":"", minor);
+			break;
+		}
+	if (ent >= MAX_MD_DEVS) {
+		printk(KERN_WARNING "md: md=%s%d - too many md initialisations\n", partitioned?"d":"", minor);
+		return 0;
+	}
+	if (ent >= md_setup_ents)
+		md_setup_ents++;
 	switch (get_option(&str, &level)) {	/* RAID Personality */
 	case 2: /* could be 0 or -1.. */
 		if (level == 0 || level == LEVEL_LINEAR) {
@@ -66,24 +85,16 @@ static int __init md_setup(char *str)
 				printk(KERN_WARNING "md: Too few arguments supplied to md=.\n");
 				return 0;
 			}
-			md_setup_args.pers[minor] = level;
-			md_setup_args.chunk[minor] = 1 << (factor+12);
-			switch(level) {
-			case LEVEL_LINEAR:
+			md_setup_args[ent].pers = level;
+			md_setup_args[ent].chunk = 1 << (factor+12);
+			if (level ==  LEVEL_LINEAR) {
 				pers = LINEAR;
 				pername = "linear";
-				break;
-			case 0:
+			} else {
 				pers = RAID0;
 				pername = "raid0";
-				break;
-			default:
-				printk(KERN_WARNING
-				       "md: The kernel has not been configured for raid%d support!\n",
-				       level);
-				return 0;
 			}
-			md_setup_args.pers[minor] = pers;
+			md_setup_args[ent].pers = pers;
 			break;
 		}
 		/* FALL THROUGH */
@@ -91,35 +102,38 @@ static int __init md_setup(char *str)
 		str = str1;
 		/* FALL THROUGH */
 	case 0:
-		md_setup_args.pers[minor] = 0;
+		md_setup_args[ent].pers = 0;
 		pername="super-block";
 	}
 
 	printk(KERN_INFO "md: Will configure md%d (%s) from %s, below.\n",
 		minor, pername, str);
-	md_setup_args.device_names[minor] = str;
+	md_setup_args[ent].device_names = str;
+	md_setup_args[ent].partitioned = partitioned;
+	md_setup_args[ent].minor = minor;
 
 	return 1;
 }
 
 static void __init md_setup_drive(void)
 {
-	int minor, i;
+	int minor, i, ent, partitioned;
 	dev_t dev;
 	dev_t devices[MD_SB_DISKS+1];
 
-	for (minor = 0; minor < MAX_MD_DEVS; minor++) {
+	for (ent = 0; ent < md_setup_ents ; ent++) {
 		int fd;
 		int err = 0;
 		char *devname;
 		mdu_disk_info_t dinfo;
 		char name[16], devfs_name[16];
 
-		if (!(devname = md_setup_args.device_names[minor]))
-			continue;
-		
-		sprintf(name, "/dev/md%d", minor);
-		sprintf(devfs_name, "/dev/md/%d", minor);
+		minor = md_setup_args[ent].minor;
+		partitioned = md_setup_args[ent].partitioned;
+		devname = md_setup_args[ent].device_names;
+
+		sprintf(name, "/dev/md%s%d", partitioned?"_d":"", minor);
+		sprintf(devfs_name, "/dev/md/%s%d", partitioned?"d":"", minor);
 		create_dev(name, MKDEV(MD_MAJOR, minor), devfs_name);
 		for (i = 0; i < MD_SB_DISKS && devname != 0; i++) {
 			char *p;
@@ -143,20 +157,19 @@ static void __init md_setup_drive(void)
 			}
 
 			devices[i] = dev;
-			md_setup_args.device_set[minor] = 1;
 
 			devname = p;
 		}
 		devices[i] = 0;
 
-		if (!md_setup_args.device_set[minor])
+		if (!i)
 			continue;
 
-		printk(KERN_INFO "md: Loading md%d: %s\n", minor, md_setup_args.device_names[minor]);
+		printk(KERN_INFO "md: Loading md%s%d: %s\n", partitioned?"_d":"", minor, md_setup_args[ent].device_names);
 
 		fd = open(name, 0, 0);
 		if (fd < 0) {
-			printk(KERN_ERR "md: open failed - cannot start array %d\n", minor);
+			printk(KERN_ERR "md: open failed - cannot start array %s\n", name);
 			continue;
 		}
 		if (sys_ioctl(fd, SET_ARRAY_INFO, 0) == -EBUSY) {
@@ -167,10 +180,10 @@ static void __init md_setup_drive(void)
 			continue;
 		}
 
-		if (md_setup_args.pers[minor]) {
+		if (md_setup_args[ent].pers) {
 			/* non-persistent */
 			mdu_array_info_t ainfo;
-			ainfo.level = pers_to_level(md_setup_args.pers[minor]);
+			ainfo.level = pers_to_level(md_setup_args[ent].pers);
 			ainfo.size = 0;
 			ainfo.nr_disks =0;
 			ainfo.raid_disks =0;
@@ -181,7 +194,7 @@ static void __init md_setup_drive(void)
 
 			ainfo.state = (1 << MD_SB_CLEAN);
 			ainfo.layout = 0;
-			ainfo.chunk_size = md_setup_args.chunk[minor];
+			ainfo.chunk_size = md_setup_args[ent].chunk;
 			err = sys_ioctl(fd, SET_ARRAY_INFO, (long)&ainfo);
 			for (i = 0; !err && i <= MD_SB_DISKS; i++) {
 				dev = devices[i];
@@ -229,6 +242,10 @@ static int __init raid_setup(char *str)
 
 		if (!strncmp(str, "noautodetect", wlen))
 			raid_noautodetect = 1;
+		if (strncmp(str, "partitionable", wlen)==0)
+			raid_autopart = 1;
+		if (strncmp(str, "part", wlen)==0)
+			raid_autopart = 1;
 		pos += wlen+1;
 	}
 	return 1;
@@ -245,7 +262,7 @@ void __init md_run_setup(void)
 	else {
 		int fd = open("/dev/md0", 0, 0);
 		if (fd >= 0) {
-			sys_ioctl(fd, RAID_AUTORUN, 0);
+			sys_ioctl(fd, RAID_AUTORUN, raid_autopart);
 			close(fd);
 		}
 	}
