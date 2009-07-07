From: Mark F <gnomeza@gmail.com>
Subject: Manually specifying data_offset in component device superblock?
Date: Tue, 7 Jul 2009 11:54:13 +0100
Message-ID: <6ad05c580907070354o485818d7w255d75de9101fb39@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi

__The Problem__

I'm attempting to recover a RAID5 (6 disks) with zeroed superblocks.

mdadm -C --assume-clean -f -e 1.2 -l 5 -p ls -c 128 -n6

But I'm unable to get the data offsets of some of the disks in the
array to match what I had before:
Diff of mdadm --examine /dev/sdb3 (which became /dev/sde3 after reboot)

--- md3.sdb3.orig       2009-07-07 10:14:25.000000000 +0100
+++ md3.sde3.new        2009-07-07 10:14:27.000000000 +0100
@@ -2,26 +2,26 @@
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
-     Array UUID : 2b7ca9c9:c9fa9a28:086e0f83:90cbef62
+     Array UUID : 679bc68c:aeb0464c:8f11e607:c8e58161
            Name : hastur:3  (local to host hastur)
-  Creation Time : Thu Oct 18 14:46:47 2007
+  Creation Time : Sun Jul  5 03:32:38 2009
      Raid Level : raid5
    Raid Devices : 6

- Avail Dev Size : 870353369 (415.02 GiB 445.62 GB)
+ Avail Dev Size : 870353233 (415.02 GiB 445.62 GB)
      Array Size : 4351765760 (2075.08 GiB 2228.10 GB)
   Used Dev Size : 870353152 (415.02 GiB 445.62 GB)
-    Data Offset : 136 sectors
+    Data Offset : 272 sectors
    Super Offset : 8 sectors
           State : clean
-    Device UUID : c4983266:9ee820fd:106bbf9d:20a69333
+    Device UUID : 1b87acce:883de3fc:881f279e:e2b84a9b

-    Update Time : Mon Jun 29 21:05:55 2009
-       Checksum : 5a501eb5 - correct
-         Events : 320840
+    Update Time : Sun Jul  5 03:32:38 2009
+       Checksum : 94ba3ae4 - correct
+         Events : 0

          Layout : left-symmetric
      Chunk Size : 128K

-    Array Slot : 0 (failed, 1, 2, failed, failed, 4, 5)
-   Array State : _uu_uu 3 failed
+    Array Slot : 0 (0, 1, 2, 3, 4, 5)
+   Array State : Uuuuuu

Data offset for this disk was originally 136, but on recreation, mdadm
chooses 272...

The array started off as RAID5 (5 disks plus a hot spare).
One disk (array slot 4) failed about a year ago and was replaced.
The array was grown to RAID5 (6 disks) shortly after.

__The Question__

So, is there a way to force a particular data offset? (short of
recompiling mdadm?)

__Some things I've tried__

It seems to be feasible to *manually* tweak data_offset with a hexeditor.
To test things I've created some sparse loopback devices of the
correct size (dd seek) with just the first 1MB or so of data in each
device.
After updating data_offset and the checksum of the first disk I
assembled the array and cryptsetup found its header. (Yay!)

But does anyone know if other parts of the superblock are dependent on
the data_offset value?
Am I going to bork things horribly by fiddling with the data_offset?

What data is present between the end of the superblock and the
beginning of data?

Thanks
  Mark
