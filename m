From: Chet McNeill <chet@somedec.com>
Subject: [patch] Boot recreation of md device with failed device
Date: Sun, 17 Jul 2005 16:07:56 -0600 (MDT)
Message-ID: <Pine.LNX.4.61.0507170825260.17864@somedec.sdecent.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This patch against 2.6.12.1 fixes a problem with the boot-time raid
md array reconstruction code.

The problem is that if an array is reconstructed at boot time with
md=X,/dev/hdx,/dev/hdy, and one of the devices dies, the array will not
start in degraded mode (and the machine will not boot). In the case of
a RAID-1 array, it should continue to boot in degraded mode.

This patch causes the kernel to /skip/ missing (i.e. dead) devices when
reconstructing an array rather than aborting on a missing device.

See http://somedec.com/downloads/howto-bootable-linux-raid1.html for a
HOWTO describing this situation in more detail.

This patch has not undergone thorough testing, but has worked well with
the software-only (LVM-based) and dual-drive RAID-1 array hardware
testing.


Thanks,

Chet McNeill
chet at somedec dot com


### Comments for Changeset

MD array reconstruction at boot time using a kernel boot parameter
should not fail on a missing (i.e. dead) device, but should construct
the array in degraded mode if possible.

This patch enables that behavior.

### Patch


--- linux-2.6.12.1.orig/init/do_mounts_md.c	2005-06-24 11:09:29.000000000 -0600
+++ linux-2.6.12.1/init/do_mounts_md.c	2005-06-24 13:34:35.000000000 -0600
@@ -126,6 +126,7 @@

  	for (ent = 0; ent < md_setup_ents ; ent++) {
  		int fd;
+		int disknum;
  		int err = 0;
  		char *devname;
  		mdu_disk_info_t dinfo;
@@ -142,6 +143,7 @@
  		else
  			dev = MKDEV(MD_MAJOR, minor);
  		create_dev(name, dev, devfs_name);
+		disknum = 0;
  		for (i = 0; i < MD_SB_DISKS && devname != 0; i++) {
  			char *p;
  			char comp_name[64];
@@ -149,7 +151,7 @@

  			p = strchr(devname, ',');
  			if (p)
-				*p++ = 0;
+				*p = 0;

  			dev = name_to_dev_t(devname);
  			if (strncmp(devname, "/dev/", 5) == 0)
@@ -159,17 +161,22 @@
  			if (rdev)
  				dev = new_decode_dev(rdev);
  			if (!dev) {
-				printk(KERN_WARNING "md: Unknown device name: %s\n", devname);
-				break;
+				printk(KERN_WARNING "md: Skipping unknown device name: %s\n", devname);
+				if (p)
+					*p++ = ',';
+				devname = p;
+				continue;
  			}

-			devices[i] = dev;
+			devices[disknum++] = dev;

+			if (p)
+				*p++ = ',';
  			devname = p;
  		}
-		devices[i] = 0;
+		devices[disknum] = 0;

-		if (!i)
+		if (!disknum)
  			continue;

  		printk(KERN_INFO "md: Loading md%s%d: %s\n",
