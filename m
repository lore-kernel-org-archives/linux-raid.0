From: Mikko Saukkoriipi <Mikko.Saukkoriipi@mbnet.fi>
Subject: Problems with raidreconf and RAID-5
Date: Thu, 22 Aug 2002 14:18:21 +0300
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3D64C87D.5809A077@mbnet.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

  I have been testing raidreconf and I've been able to add a new disk to
a RAID-0 array, but trying to convert RAID-0 to RAID-5 or add a new disk
to RAID-5 have failed.
  Just before the conversion has finished or some times even at
beginning I get and error "raid5_map_global_to_local: disk 0 block out
of range: 488098 (487840) gblock = 1464296" or similar and raidreconf
aborts.
  I'll add below script of the program running as well the used raidtabs
and listings of partitiontables. The example is from adding a new disk
to a 3 drive RAID-5 array. raidreconf version is "raidreconf 0.1.1 for
mkraid version 0.90.0".

Also, what file is gmon.out? It appears after running raidreconf, but
the documentation didn't mention anything about it.

Thank you.
Mikko Saukkoriipi


Script started on Wed Aug 21 11:19:42 2002
battousai:~/temp/raid5-add-sda1_v3# raidstop /dev/md0
battousai:~/temp/raid5-add-sda1_v3# raidreconf -o raidtab.old -n
raidtab.new -m /dev/md0
Working with device /dev/md0
Parsing raidtab.old
Parsing raidtab.new
Size of old array: 11714787 blocks,  Size of new array: 15622339 blocks
Old raid-disk 0 has 487840 chunks, 1951360 blocks
Old raid-disk 1 has 488224 chunks, 1952896 blocks
Old raid-disk 2 has 488224 chunks, 1952896 blocks
New raid-disk 0 has 487840 chunks, 1951360 blocks
New raid-disk 1 has 488224 chunks, 1952896 blocks
New raid-disk 2 has 488224 chunks, 1952896 blocks
New raid-disk 3 has 488416 chunks, 1953664 blocks
Using 4 Kbyte blocks to move from 4 Kbyte chunks to 4 Kbyte chunks.
Detected 254836 KB of physical memory in system
A maximum of 2123 outstanding requests is allowed
---------------------------------------------------
I will grow your old device /dev/md0 of 976448 blocks
to a new device /dev/md0 of 1464864 blocks
using a block-size of 4 KB
Is this what you want? (yes/no): yes
Converting 976448 block device to 1464864 block device
Allocated free block map for 3 disks
4 unique disks detected.
Working (-) [00000000/00976448]
[                                            ]
...
Working (-) [00974103/00976448]
[########################################### ]
raid5_map_global_to_local: disk 0 block out of range: 487840 (487840)
gblock = 975681
Aborted
battousai:~/temp/raid5-add-sda1_v3# exit

Script done on Wed Aug 21 13:01:09 2002


Original raidtab:

raiddev /dev/md0
        raid-level      5
        nr-raid-disks   3
        nr-spare-disks  0
        persistent-superblock   1
        parity-algorithm        left-symmetric
        chunk-size      4
        device          /dev/hdb1
        raid-disk       0
        device          /dev/hdc1
        raid-disk       1
        device          /dev/hdd1
        raid-disk       2

New raidtab:

raiddev /dev/md0
        raid-level      5
        nr-raid-disks   4
        nr-spare-disks  0
        persistent-superblock   1
        parity-algorithm        left-symmetric
        chunk-size      4
        device          /dev/hdb1
        raid-disk       0
        device          /dev/hdc1
        raid-disk       1
        device          /dev/hdd1
        raid-disk       2
        device          /dev/sda1
        raid-disk       3

Listing of partitions from fdisk -l:

Partitiontable for /dev/hda

Disk /dev/hda: 255 heads, 63 sectors, 523 cylinders
Units = cylinders of 16065 * 512 bytes

   Device Boot    Start       End    Blocks   Id  System
/dev/hda1   *         1         4     32098+  83  Linux
/dev/hda2             5       523   4168867+   5  Extended
/dev/hda5             5        35    248976   82  Linux swap
/dev/hda6            36       523   3919828+  83  Linux
---

Partitiontable for /dev/hdb

Disk /dev/hdb: 128 heads, 63 sectors, 621 cylinders
Units = cylinders of 8064 * 512 bytes

   Device Boot    Start       End    Blocks   Id  System
/dev/hdb1             1       484   1951456+  fd  Linux raid autodetect
---

Partitiontable for /dev/hdc

Disk /dev/hdc: 16 heads, 63 sectors, 4200 cylinders
Units = cylinders of 1008 * 512 bytes

   Device Boot    Start       End    Blocks   Id  System
/dev/hdc1             1      3875   1952968+  fd  Linux raid autodetect
---

Partitiontable for /dev/hdd

Disk /dev/hdd: 16 heads, 63 sectors, 4200 cylinders
Units = cylinders of 1008 * 512 bytes

   Device Boot    Start       End    Blocks   Id  System
/dev/hdd1             1      3875   1952968+  fd  Linux raid autodetect
---
Partitiontable for /dev/sda

Disk /dev/sda: 64 heads, 32 sectors, 2006 cylinders
Units = cylinders of 2048 * 512 bytes

   Device Boot    Start       End    Blocks   Id  System
/dev/sda1             1      1908   1953776   fd  Linux raid autodetect
---

Partitiontable for /dev/sdb

Disk /dev/sdb: 64 heads, 32 sectors, 2006 cylinders
Units = cylinders of 2048 * 512 bytes

   Device Boot    Start       End    Blocks   Id  System
/dev/sdb1             1      2006   2054128   83  Linux
---
