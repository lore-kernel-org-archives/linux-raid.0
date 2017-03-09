From: Tim Small <tim@buttersideup.com>
Subject: mdadm add spare fails with "add new device failed ... Invalid
 argument" for RAID5
Date: Thu, 9 Mar 2017 20:17:30 +0000
Message-ID: <52bd5f76-a343-ddc7-1c72-0350796cbe07@buttersideup.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello,

I attempted to add in a new partition as a spare to a RAID5 array.  This
had previously worked for a different md (a smaller one, using another
set of partitions on the same set of drives, but otherwise created at
the same time and very similar), but it fails on the larger md array as
below:

# ~tim/compile/mdadm/mdadm --manage /dev/md2 --add /dev/sdf2
mdadm: add new device failed for /dev/sdf2 as 4: Invalid argument

The kernel says:

md: sdf2 does not have a valid v1.2 superblock, not importing!

I've tried with various mdadm versions (v3.1.4 to current git), and also
with Ubuntu  4.4.x and 4.8.x kernels.

I've attached mdadm --examine -v output:

Existing member examined with mdadm from git@github.com:neilbrown/mdadm.git

/dev/sdd2:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x9
     Array UUID : ad7ef7fa:e78344ea:a8778f06:abf07bf5
           Name : magic:2  (local to host magic)
  Creation Time : Wed Jul 15 13:43:06 2015
     Raid Level : raid5
   Raid Devices : 3

 Avail Dev Size : 3885793456 (1852.89 GiB 1989.53 GB)
     Array Size : 3885793280 (3705.78 GiB 3979.05 GB)
  Used Dev Size : 3885793280 (1852.89 GiB 1989.53 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=176 sectors
          State : clean
    Device UUID : 55004cc7:b2e691de:c612612a:675ea2f3

Internal Bitmap : 8 sectors from superblock
    Update Time : Thu Mar  9 15:14:29 2017
  Bad Block Log : 512 entries available at offset 72 sectors - bad
blocks present.
       Checksum : 35698943 - correct
         Events : 568847

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 1
   Array State : AAA ('A' == active, '.' == missing, 'R' == replacing)



 diff vs. failed-to-add member:


--- /tmp/existing-member-examined-with-git-mdadm-d2	2017-03-09
15:18:32.993620717 +0000
+++ /tmp/mdadm-3-1-4-examined-with-git-mdadm-f2	2017-03-09
15:18:37.905679120 +0000
@@ -1,4 +1,4 @@
-/dev/sdd2:
+/dev/sdf2:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x9
@@ -8,23 +8,23 @@
      Raid Level : raid5
    Raid Devices : 3

- Avail Dev Size : 3885793456 (1852.89 GiB 1989.53 GB)
+ Avail Dev Size : 3886053552 (1853.01 GiB 1989.66 GB)
      Array Size : 3885793280 (3705.78 GiB 3979.05 GB)
   Used Dev Size : 3885793280 (1852.89 GiB 1989.53 GB)
-    Data Offset : 262144 sectors
+    Data Offset : 2048 sectors
    Super Offset : 8 sectors
-   Unused Space : before=262056 sectors, after=176 sectors
+   Unused Space : before=1960 sectors, after=260272 sectors
           State : active
-    Device UUID : 55004cc7:b2e691de:c612612a:675ea2f3
+    Device UUID : 876152cb:5f1646b5:39c32e17:9b55d3dd

 Internal Bitmap : 8 sectors from superblock
-    Update Time : Thu Mar  9 15:18:32 2017
+    Update Time : Thu Mar  9 15:15:02 2017
   Bad Block Log : 512 entries available at offset 72 sectors - bad
blocks present.
-       Checksum : 35698a37 - correct
-         Events : 568848
+       Checksum : e719c0b6 - correct
+         Events : 0

          Layout : left-symmetric
      Chunk Size : 512K

-   Device Role : Active device 1
+   Device Role : spare
    Array State : AAA ('A' == active, '.' == missing, 'R' == replacing)


and vs. same newly created spare, but when the add was attempted with
the a current git mdadm:


--- /tmp/existing-member-examined-with-git-mdadm-d2	2017-03-09
15:18:32.993620717 +0000
+++ /tmp/git-f2	2017-03-09 15:14:22.226655671 +0000
@@ -1,4 +1,4 @@
-/dev/sdd2:
+/dev/sdf2:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x9
@@ -13,18 +13,18 @@
   Used Dev Size : 3885793280 (1852.89 GiB 1989.53 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
-   Unused Space : before=262056 sectors, after=176 sectors
-          State : active
-    Device UUID : 55004cc7:b2e691de:c612612a:675ea2f3
+   Unused Space : before=262064 sectors, after=176 sectors
+          State : clean
+    Device UUID : 3b1be0c7:82e8b8df:2d84b34b:9212fa71

 Internal Bitmap : 8 sectors from superblock
-    Update Time : Thu Mar  9 15:18:32 2017
-  Bad Block Log : 512 entries available at offset 72 sectors - bad
blocks present.
-       Checksum : 35698a37 - correct
-         Events : 568848
+    Update Time : Thu Mar  9 15:13:58 2017
+  Bad Block Log : 512 entries available at offset 16 sectors - bad
blocks present.
+       Checksum : d6c5ca00 - correct
+         Events : 0

          Layout : left-symmetric
      Chunk Size : 512K

-   Device Role : Active device 1
+   Device Role : spare
    Array State : AAA ('A' == active, '.' == missing, 'R' == replacing)


Any hints or tips welcome...

Tim.
