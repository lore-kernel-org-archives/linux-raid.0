From: Paul Clements <Paul.Clements@SteelEye.com>
Subject: Re: Raid1 and mdadm
Date: Wed, 02 Apr 2003 15:22:58 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3E8B46A2.2A82A4B7@SteelEye.com>
References: <A5974D8E5F98D511BB910002A50A66470580D71F@hdsmsx103.hd.intel.com>
			<3E89B947.C3838E0E@SteelEye.com> <16010.7165.412475.33750@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------637920260E0E04E5B6A9A84B"
Return-path: <linux-raid-owner@vger.kernel.org>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------637920260E0E04E5B6A9A84B
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Hi Neil,

> No.  I would not accept patches.
> Not because I fundamentally disagree with autostart, but because it
> wouldn't work.  I suggest you try it.

Maybe I didn't explain very clearly what my goal is...allow me to
clarify:

As it is now, if you compile md as a module and happen to have a
partition tagged as RAID, you'll panic the kernel. There's code in
fs/partitions (and in 2.5, in init/do_mounts.c) that is calling into
md....yechhh. What I'd like to do is make a clean separation between the
boot up and partitioning code and the md driver, so md can be compiled
as a module. (This would also allow other volume managers to use the
partition tagging to identify devices, if they wanted.) 


> > Or is there a better way to do this?
> 
> Yes.
> initrd/initfs is "the right way".
> As far as I know, it *does* work.(*)  You do not need md linked into the
> kernel.
> You have md.o and whatever personalities you want in the initrd image,
> then in the initrd script (linuxrc I think) you load the modules, and
> use mdadm to assemble the raid arrays.
> You then mount the real root and off you go.

Right, sorry, I wasn't clear. This is basically what I meant. All I want
to do is allow autostart_arrays() to be called when md is compiled as a
module. Then, let the initrd/linuxrc (later initramfs) call
autostart_arrays() (ioctl("/dev/md0", RAID_AUTORUN) is all, really).

I've hacked on 2.5.63. I'll attach the patch, it's fairly short...and
might give you a better idea what I'm proposing...

Any comments would be appreciated.

Thanks,
Paul
--------------637920260E0E04E5B6A9A84B
Content-Type: text/plain; charset=us-ascii;
 name="md_modular_patch.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="md_modular_patch.diff"

--- fs/partitions/Makefile.PRISTINE	2003-04-01 12:12:55.000000000 -0500
+++ fs/partitions/Makefile	2003-04-01 12:13:03.000000000 -0500
@@ -2,7 +2,7 @@
 # Makefile for the linux kernel.
 #
 
-obj-y := check.o
+obj-y := check.o raid.o
 
 obj-$(CONFIG_ACORN_PARTITION) += acorn.o
 obj-$(CONFIG_AMIGA_PARTITION) += amiga.o
--- fs/partitions/check.c.PRISTINE	2003-04-01 12:14:12.000000000 -0500
+++ fs/partitions/check.c	2003-04-01 12:15:36.000000000 -0500
@@ -21,6 +21,7 @@
 #include <linux/ctype.h>
 
 #include "check.h"
+#include "raid.h"
 
 #include "acorn.h"
 #include "amiga.h"
@@ -35,10 +36,6 @@
 #include "ultrix.h"
 #include "efi.h"
 
-#if CONFIG_BLK_DEV_MD
-extern void md_autodetect_dev(dev_t dev);
-#endif
-
 int warn_no_part = 1; /*This is ugly: should make genhd removable media aware*/
 
 static int (*check_part[])(struct parsed_partitions *, struct block_device *) = {
@@ -423,7 +420,7 @@ void register_disk(struct gendisk *disk)
 #if CONFIG_BLK_DEV_MD
 			if (!state->parts[j].flags)
 				continue;
-			md_autodetect_dev(bdev->bd_dev+j);
+			raid_autodetect_dev(bdev->bd_dev+j);
 #endif
 		}
 		kfree(state);
@@ -457,7 +454,7 @@ int rescan_partitions(struct gendisk *di
 		add_partition(disk, p, from, size);
 #if CONFIG_BLK_DEV_MD
 		if (state->parts[p].flags)
-			md_autodetect_dev(bdev->bd_dev+p);
+			raid_autodetect_dev(bdev->bd_dev+p);
 #endif
 	}
 	kfree(state);
--- fs/partitions/check.c.PRISTINE	2003-04-01 12:14:12.000000000 -0500
+++ fs/partitions/check.c	2003-04-01 12:15:36.000000000 -0500
@@ -21,6 +21,7 @@
 #include <linux/ctype.h>
 
 #include "check.h"
+#include "raid.h"
 
 #include "acorn.h"
 #include "amiga.h"
@@ -35,10 +36,6 @@
 #include "ultrix.h"
 #include "efi.h"
 
-#if CONFIG_BLK_DEV_MD
-extern void md_autodetect_dev(dev_t dev);
-#endif
-
 int warn_no_part = 1; /*This is ugly: should make genhd removable media aware*/
 
 static int (*check_part[])(struct parsed_partitions *, struct block_device *) = {
@@ -423,7 +420,7 @@ void register_disk(struct gendisk *disk)
 #if CONFIG_BLK_DEV_MD
 			if (!state->parts[j].flags)
 				continue;
-			md_autodetect_dev(bdev->bd_dev+j);
+			raid_autodetect_dev(bdev->bd_dev+j);
 #endif
 		}
 		kfree(state);
@@ -457,7 +454,7 @@ int rescan_partitions(struct gendisk *di
 		add_partition(disk, p, from, size);
 #if CONFIG_BLK_DEV_MD
 		if (state->parts[p].flags)
-			md_autodetect_dev(bdev->bd_dev+p);
+			raid_autodetect_dev(bdev->bd_dev+p);
 #endif
 	}
 	kfree(state);
--- /dev/null	2002-12-05 15:33:16.000000000 -0500
+++ fs/partitions/raid.c	2003-04-01 13:16:53.000000000 -0500
@@ -0,0 +1,28 @@
+/*
+ * Save registered partitions that are marked as autorun RAID arrays.
+ *
+ * check.c saves the partitions by calling raid_autodetect_dev at boot time
+ * md.c uses the partition list to do its autostart_arrays 
+ *
+ * code taken from md.c and new code added - 2003, Paul Clements
+ */
+static dev_t detected_devices[128];
+static int dev_cnt;
+
+void raid_autodetect_dev(dev_t dev)
+{
+        if (dev_cnt >= 0 && dev_cnt < 128)
+                detected_devices[dev_cnt++] = dev;
+}
+
+dev_t raid_get_detected_dev(int i)
+{
+	if (i >= 0 && i < dev_cnt)
+		return detected_devices[i];
+	return (dev_t) 0;
+}
+
+int raid_num_detected_devs(void)
+{
+	return dev_cnt;
+}
--- /dev/null	2002-12-05 15:33:16.000000000 -0500
+++ fs/partitions/raid.h	2003-04-01 12:17:30.000000000 -0500
@@ -0,0 +1,5 @@
+/*
+ *  fs/partitions/raid.h
+ */
+
+void raid_autodetect_dev(dev_t dev);
--- drivers/md/md.c.PRISTINE	2003-04-01 11:37:58.000000000 -0500
+++ drivers/md/md.c	2003-04-02 09:59:10.000000000 -0500
@@ -59,9 +59,7 @@
 #define dprintk(x...) ((void)(DEBUG && printk(x)))
 
 
-#ifndef MODULE
 static void autostart_arrays (void);
-#endif
 
 static mdk_personality_t *pers[MAX_PERSONALITY];
 
@@ -873,7 +871,9 @@ static void unlock_rdev(mdk_rdev_t *rdev
 	blkdev_put(bdev, BDEV_RAW);
 }
 
-void md_autodetect_dev(dev_t dev);
+extern void raid_autodetect_dev(dev_t);
+extern dev_t raid_get_detected_dev(int);
+extern int raid_num_detected_devs(void);
 
 static void export_rdev(mdk_rdev_t * rdev)
 {
@@ -882,9 +882,7 @@ static void export_rdev(mdk_rdev_t * rde
 		MD_BUG();
 	free_disk_sb(rdev);
 	list_del_init(&rdev->same_set);
-#ifndef MODULE
-	md_autodetect_dev(rdev->bdev->bd_dev);
-#endif
+	raid_autodetect_dev(rdev->bdev->bd_dev);
 	unlock_rdev(rdev);
 	kfree(rdev);
 }
@@ -2225,12 +2223,10 @@ static int md_ioctl(struct inode *inode,
 			md_print_devices();
 			goto done;
 
-#ifndef MODULE
 		case RAID_AUTORUN:
 			err = 0;
 			autostart_arrays();
 			goto done;
-#endif
 		default:;
 	}
 
@@ -3237,23 +3233,11 @@ int __init md_init(void)
 	raid_table_header = register_sysctl_table(raid_root_table, 1);
 
 	md_geninit();
-	return (0);
-}
-
 
-#ifndef MODULE
+	if (autostart) 
+		autostart_arrays();
 
-/*
- * Searches all registered partitions for autorun RAID arrays
- * at boot time.
- */
-static dev_t detected_devices[128];
-static int dev_cnt;
-
-void md_autodetect_dev(dev_t dev)
-{
-	if (dev_cnt >= 0 && dev_cnt < 127)
-		detected_devices[dev_cnt++] = dev;
+	return (0);
 }
 
 
@@ -3264,8 +3248,8 @@ static void autostart_arrays(void)
 
 	printk(KERN_INFO "md: Autodetecting RAID arrays.\n");
 
-	for (i = 0; i < dev_cnt; i++) {
-		dev_t dev = detected_devices[i];
+	for (i = 0; i < raid_num_detected_devs(); i++) {
+		dev_t dev = raid_get_detected_dev(i);
 
 		rdev = md_import_device(dev,1);
 		if (IS_ERR(rdev)) {
@@ -3284,8 +3268,6 @@ static void autostart_arrays(void)
 	autorun_devices();
 }
 
-#endif
-
 static __exit void md_exit(void)
 {
 	int i;

--------------637920260E0E04E5B6A9A84B--

