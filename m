From: Laurent CARON <lcaron@unix-scripts.info>
Subject: Unable to grow RAID 6 array
Date: Wed, 18 May 2011 09:31:59 +0200
Message-ID: <20110518092327.airaicao@trusted.unix-scripts.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I'm basically trying to grow a RAID-6 array (5 disks).

I did change the disks one by one (change, rebuild, ...).

I finally did delete the last partition (the one I wanted to enlarge and
recreated it with the exactly same start but different end).

When I try to grow the array, I get: 

# mdadm --grow --size max /dev/md2
mdadm: component size of /dev/md2 has been set to 732458496K

# cat /proc/mdstat 
Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4] [multipath] [faulty] 
md2 : active raid6 sda3[0] sde3[4] sdd3[3] sdc3[2] sdb3[1]
      2197375488 blocks super 1.2 level 6, 512k chunk, algorithm 2 [5/5] [UUUUU]

# mdadm -E /dev/sda3
/dev/sda3:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 2687b3cf:4c884e3d:75aff183:342fe97d
           Name : gw:2  (local to host gw)
  Creation Time : Mon Apr 25 22:51:23 2011
     Raid Level : raid6
   Raid Devices : 5

 Avail Dev Size : 1464917107 (698.53 GiB 750.04 GB)
     Array Size : 4394750976 (2095.58 GiB 2250.11 GB)
  Used Dev Size : 1464916992 (698.53 GiB 750.04 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 98d5d478:4a58c880:a70646d8:d3b92777

    Update Time : Wed May 18 09:25:25 2011
       Checksum : 7cbdbbb9 - correct
         Events : 84

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : AAAAA ('A' == active, '.' == missing)

# mdadm -D /dev/md2
/dev/md2:
        Version : 1.2
  Creation Time : Mon Apr 25 22:51:23 2011
     Raid Level : raid6
     Array Size : 2197375488 (2095.58 GiB 2250.11 GB)
  Used Dev Size : 732458496 (698.53 GiB 750.04 GB)
   Raid Devices : 5
  Total Devices : 5
    Persistence : Superblock is persistent

    Update Time : Wed May 18 09:26:36 2011
          State : clean
 Active Devices : 5
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 512K

           Name : gw:2  (local to host gw)
           UUID : 2687b3cf:4c884e3d:75aff183:342fe97d
         Events : 84

    Number   Major   Minor   RaidDevice State
       0       8        3        0      active sync   /dev/sda3
       1       8       19        1      active sync   /dev/sdb3
       2       8       35        2      active sync   /dev/sdc3
       3       8       51        3      active sync   /dev/sdd3
       4       8       67        4      active sync   /dev/sde3

# fdisk -l /dev/sda
Disk /dev/sda: 2000.4 GB, 2000398934016 bytes
255 heads, 63 sectors/track, 243201 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x09cd117c

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1   *           1          19      152586   fd  Linux raid autodetect
/dev/sda2              20       30414   244147837+  fd  Linux raid autodetect
/dev/sda3           30415      243201  1709211577+  fd  Linux raid autodetect

The partitions I try to use are now 1.7TB so my raid array should be
able to grow without any trouble.

Needless to say I already rebooted for the kernel to re-read the
partition table.

If any of you can help me to sort this out It would be nice.

Thanks

