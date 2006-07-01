From: Jason Lunz <lunz@falooley.org>
Subject: degraded raid5 refuses to start
Date: Sat, 1 Jul 2006 21:20:12 +0000 (UTC)
Message-ID: <e86oub$buu$1@sea.gmane.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a 4-disk raid5 (sda3, sdb3, hda1, hdc1). sda and sdb share a
silicon image sata card.  sdb died completely, then 20 minutes later,
the sata_sil driver became fatally confused and the machine locked up.
I shut down the machine and waited until I had a replacement for sdb.

I've got a replacement for sdb now, but I can't get the array to start
so that I can add it and resync. When I try to assemble the degraded
array, I get this:

root@orr:~# mdadm -Af /dev/md2 /dev/sda3 /dev/hda1 /dev/hdc1
mdadm: failed to RUN_ARRAY /dev/md2: Input/output error

root@orr:~# dmesg | tail -n 15
md: bind<hda1>
md: bind<hdc1>
md: bind<sda3>
md: md2: raid array is not clean -- starting background reconstruction
raid5: device sda3 operational as raid disk 0
raid5: device hdc1 operational as raid disk 3
raid5: device hda1 operational as raid disk 2
raid5: cannot start dirty degraded array for md2
RAID5 conf printout:
 --- rd:4 wd:3 fd:1
 disk 0, o:1, dev:sda3
 disk 2, o:1, dev:hda1
 disk 3, o:1, dev:hdc1
raid5: failed to run raid set md2
md: pers->run() failed ...

How do I convince the array to start? I can add the new disk to the
array, but it simply becomes a spare and the raid5 remains inactive.

The superblock on the 1 of the 3 drives is a little different than the
other two:

root@orr:~# mdadm -E /dev/hda1 > sb-hda1
root@orr:~# mdadm -E /dev/hdc1 > sb-hdc1
root@orr:~# mdadm -E /dev/sda3 > sb-sda3
root@orr:~# diff -u sb-hda1 sb-hdc1
--- sb-hda1     2006-07-01 17:17:36.000000000 -0400
+++ sb-hdc1     2006-07-01 17:17:41.000000000 -0400
@@ -1,4 +1,4 @@
-/dev/hda1:
+/dev/hdc1:
           Magic : a92b4efc
         Version : 00.90.00
            UUID : 6b8b4567:327b23c6:643c9869:66334873
@@ -16,14 +16,14 @@
 Working Devices : 3
  Failed Devices : 2
   Spare Devices : 0
-       Checksum : a2163da6 - correct
+       Checksum : a2163dbb - correct
          Events : 0.47575379

          Layout : left-symmetric
      Chunk Size : 64K

       Number   Major   Minor   RaidDevice State
-this     2       3        1        2      active sync   /dev/hda1
+this     3      22        1        3      active sync   /dev/hdc1

    0     0       8        3        0      active sync   /dev/sda3
    1     1       0        0        1      faulty removed
root@orr:~# diff -u sb-hda1 sb-sda3
--- sb-hda1     2006-07-01 17:17:36.000000000 -0400
+++ sb-sda3     2006-07-01 17:17:43.000000000 -0400
@@ -1,4 +1,4 @@
-/dev/hda1:
+/dev/sda3:
           Magic : a92b4efc
         Version : 00.90.00
            UUID : 6b8b4567:327b23c6:643c9869:66334873
@@ -10,22 +10,22 @@
   Total Devices : 4
 Preferred Minor : 2

-    Update Time : Mon Jun 26 22:51:12 2006
-          State : active
+    Update Time : Mon Jun 26 22:51:06 2006
+          State : clean
  Active Devices : 3
 Working Devices : 3
  Failed Devices : 2
   Spare Devices : 0
-       Checksum : a2163da6 - correct
-         Events : 0.47575379
+       Checksum : a4ec2eec - correct
+         Events : 0.47575378

          Layout : left-symmetric
      Chunk Size : 64K

       Number   Major   Minor   RaidDevice State
-this     2       3        1        2      active sync   /dev/hda1
+this     0       8        3        0      active sync   /dev/sda3

    0     0       8        3        0      active sync   /dev/sda3
-   1     1       0        0        1      faulty removed
+   1     1       0        0        1      spare
    2     2       3        1        2      active sync   /dev/hda1
    3     3      22        1        3      active sync   /dev/hdc1

How do I get this array going again?  Am I doing something wrong?
Reading the list archives indicates that there could be bugs in this
area, or that I may need to recreate the array with -C (though that
seems heavyhanded to me).

thanks,

Jason

