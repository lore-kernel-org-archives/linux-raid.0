From: Harland Christofferson <debian-user@zerocrossings.com>
Subject: mdadm raid1 howto
Date: Wed, 22 Dec 2004 16:38:19 -0500
Message-ID: <jUsT.aNoTheR.mEsSaGe.iD.11037516514657@24.45.154.254>
Reply-To: debian-user@zerocrossings.com
Mime-Version: 1.0
Content-Type: text/plain; charset=iso8859-1
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


i currently have a two systems running kernel v 2.4.18 and have raid 
support. i have found a howto on getting raid1 working on pre-existing 
system but when i tried it, i messed up my boot sector. i was able 
to recover but i do not wish to do this again. i am pretty confised 
as to how to straighten this out. any help is appreciated!!

right now, my configuration is as follows:

> mdadm -D /dev/md0
/dev/md0:
        Version : 00.90.00
  Creation Time : Tue Dec 14 18:14:03 2004
     Raid Level : raid1
     Array Size : 40021568 (38.16 GiB 40.98 GB)
    Device Size : 40021568 (38.16 GiB 40.98 GB)
     Raid Disks : 2
    Total Disks : 2
Preferred Minor : 0
    Persistance : Superblock is persistant

    Update Time : Thu Dec 16 06:40:04 2004
          State : dirty, no-errors
  Active Drives : 2
 Working Drives : 2
  Failed Drives : 0
   Spare Drives : 0


    Number   Major   Minor   RaidDisk   State
       0       3        0        0      active sync   /dev/hda
       1      22        0        1      active sync   /dev/hdc
           UUID : e5dd4d59:8c468e45:01ae5099:8a1ee740

> df -h
Filesystem            Size  Used Avail Use% Mounted on
/dev/hda7             9.2G  2.1G  6.7G  24% /
/dev/hda1              31M   12M   18M  41% /boot
/dev/hda6              19G  6.7G   11G  39% /home
/dev/hda8             9.6G  1.2G  8.0G  13% /var

> fdisk -l /dev/md0

Disk /dev/md0: 2 heads, 4 sectors, 10005392 cylinders
Units = cylinders of 8 * 512 bytes

    Device Boot    Start       End    Blocks   Id  System
/dev/md0p1   *         8      8033     32098+  83  Linux
Partition 1 does not end on cylinder boundary:
     phys=(3, 254, 63) should be (3, 1, 4)
/dev/md0p2          8033  10004479  39985785    5  Extended
Partition 2 does not end on cylinder boundary:
     phys=(1023, 254, 63) should be (1023, 1, 4)
/dev/md0p5          8041    132537    497983+  82  Linux swap
/dev/md0p6        132545   5016297  19535008+  83  Linux
/dev/md0p7       5016305   7458177   9767488+  83  Linux
/dev/md0p8       7458185  10004479  10185178+  83  Linux

> fdisk -l /dev/hda

Disk /dev/hda: 255 heads, 63 sectors, 4982 cylinders
Units = cylinders of 16065 * 512 bytes

   Device Boot    Start       End    Blocks   Id  System
/dev/hda1   *         1         4     32098+  83  Linux
/dev/hda2             5      4982  39985785    5  Extended
/dev/hda5             5        66    497983+  82  Linux swap
/dev/hda6            67      2498  19535008+  83  Linux
/dev/hda7          2499      3714   9767488+  83  Linux
/dev/hda8          3715      4982  10185178+  83  Linux

> fdisk -l /dev/hdc

Disk /dev/hdc: 255 heads, 63 sectors, 4998 cylinders
Units = cylinders of 16065 * 512 bytes

   Device Boot    Start       End    Blocks   Id  System
/dev/hdc1   *         1         4     32098+  83  Linux
/dev/hdc2             5      4982  39985785    5  Extended
/dev/hdc5             5        66    497983+  82  Linux swap
/dev/hdc6            67      2498  19535008+  83  Linux
/dev/hdc7          2499      3714   9767488+  83  Linux
/dev/hdc8          3715      4982  10185178+  83  Linux

----------------------------------------------------------------------
Zero Crossings, Inc. -- Embedded and Digital Signal Processing Systems

http://www.zerocrossings.com/










