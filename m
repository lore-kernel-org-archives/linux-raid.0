From: Miquel van Smoorenburg <miquels@cistron.nl>
Subject: [PATCH] md=d0,/dev/hda,/dev/hdb fails if hda is missing
Date: Mon, 22 Mar 2004 14:34:45 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040322133444.GA15384@cistron.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

If you assemble disks with md=d0,/dev/hda,/dev/hdb it fails
if /dev/hda is missing (for example because it's dead).

This patch fixes it:

--- linux-2.6.5-rc1/init/do_mounts_md.c.ORIG	2004-03-16 15:14:48.000000000 +0100
+++ linux-2.6.5-rc1/init/do_mounts_md.c	2004-03-20 14:30:33.000000000 +0100
@@ -142,7 +142,7 @@
 		else
 			dev = MKDEV(MD_MAJOR, minor);
 		create_dev(name, dev, devfs_name);
-		for (i = 0; i < MD_SB_DISKS && devname != 0; i++) {
+		for (i = 0; i < MD_SB_DISKS && devname != 0;) {
 			char *p;
 			char comp_name[64];
 			u32 rdev;
@@ -158,12 +158,11 @@
 			rdev = bstat(comp_name);
 			if (rdev)
 				dev = new_decode_dev(rdev);
-			if (!dev) {
-				printk(KERN_WARNING "md: Unknown device name: %s\n", devname);
-				break;
-			}
-
-			devices[i] = dev;
+			if (dev)
+				devices[i++] = dev;
+			else
+				printk(KERN_WARNING "md: Unknown device name: "
+						    "%s\n", devname);
 
 			devname = p;
 		}


Mike.
-- 
Netu, v qba'g yvxr gur cynvagrkg :)
