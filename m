From: Hein Roehrig <hpr@eml.cc>
Subject: 2.2.17 -> 2.4.19-rc3: bub in file md.c, line 1311
Date: 23 Jul 2002 17:09:02 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <87r8huqy5t.fsf@qaip3.ins.cwi.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I am trying to (remotely) upgrade a kernel 2.2.17 with raid-2.2.17-A0
patch to 2.4.19-rc3 with the little attached patch to get autodetect
to work (sparc64 architecture.) Here is a partial manual transcript
from what appears on the console; the system still boots 2.2.17
without problem. I would be grateful for any advice on getting things
right...

Thanks,
Hein


md: linear personality registered as nr 1
md: raid 0 personality registered as nr 2
md: raid 1 personality registered as nr 3
md: raid 5 personality registered as nr 4
raid5: measuring checksumming speed
   VIS   : 113.600 MB/sec
raid5: using function: VIS (113.600 MB/sec)
md: md driver 0.90.0 MAX_MD_DEVS=3D256, MD_SB_DISKS=3D27
md: Autodetecting RAID arrays.
md:      [events:00000000]
md:      [events:00000000]
md:      [events:00000000]
md:      [events:00000000]=20
md:      [events:00000000]  =20
md:      [events:00000000]
md:      [events:00000000]=20
md:      [events:00000000]  =20
md:      [events:00000000]
md:      [events:00000000]
md:      [events:00000000]
md:      [events:00000000]
md: autorun
md: considering
md: adding sdf4
md: adding sde4
md: adding sdd4
md: adding sdc4
md: adding sda4
md: created md2
md: bind <sda4,1>
md: bind <sdc4,2>
md: bind <sdd4,3>
md: bind <sde4,4>
md: bind <sdf4,5>
md: running: <sdf4><sde4><sdd4><sdc4><sda4>
md: sdf4=B4s event counter: 00000000
md: device name has changed from [dev =3D3:08] to sdf4 since last impot=
!
md: bub in file md.c, line 1311

md:  **********************************
md:  * <COMPLETE RAID STATE PRINTOUT> *
md:  **********************************

md: <sdf4><sde4><sdd4><sdc4><sda4> array superblock
md:   SB: (V:0.90.0) ID: <2b62b4de.b2ac2edc.51dd7a78.2e9b708f> CT:38fa2=
9a2

diff -ur clean/linux-2.4.19-rc3/fs/partitions/sun.c linux-2.4.19-rc3/fs=
/partitions/sun.c
--- clean/linux-2.4.19-rc3/fs/partitions/sun.c	Tue Oct  2 05:03:26 2001
+++ linux-2.4.19-rc3/fs/partitions/sun.c	Tue Jul 23 13:54:31 2002
@@ -19,6 +19,10 @@
 #include "check.h"
 #include "sun.h"
=20
+#if CONFIG_BLK_DEV_MD
+extern void md_autodetect_dev(kdev_t dev);
+#endif
+
 int sun_partition(struct gendisk *hd, struct block_device *bdev, unsig=
ned long first_sector, int first_part_minor)
 {
 	int i, csum;
@@ -27,7 +31,14 @@
 	kdev_t dev =3D to_kdev_t(bdev->bd_dev);
 	struct sun_disklabel {
 		unsigned char info[128];   /* Informative text string */
-		unsigned char spare[292];  /* Boot information etc. */
+		unsigned char spare0[14];
+		struct sun_disklabelinfo {
+			unsigned char spare1;
+			unsigned char id;
+			unsigned char spare2;
+			unsigned char flags;
+		} infos[8];
+		unsigned char spare1[246];  /* Boot information etc. */
 		unsigned short rspeed;     /* Disk rotational speed */
 		unsigned short pcylcount;  /* Physical cylinder count */
 		unsigned short sparecyl;   /* extra sects per cylinder */
@@ -77,8 +88,14 @@
=20
 		st_sector =3D first_sector + be32_to_cpu(p->start_cylinder) * spc; 	=
	num_sectors =3D be32_to_cpu(p->num_sectors);
-		if (num_sectors)
+		if (num_sectors) {
 			add_gd_partition(hd, first_part_minor, st_sector, num_sectors);
+#if CONFIG_BLK_DEV_MD
+			if (label->infos[i].id =3D=3D LINUX_RAID_PARTITION) {
+			    md_autodetect_dev(MKDEV(hd->major, first_part_minor));
+			}
+#endif
+                }
 		first_part_minor++;
 	}
 	printk("\n");


-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
