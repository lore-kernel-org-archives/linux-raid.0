From: Arthur Britto <ahbritto@iat.com>
Subject: Unable to add write-intent bitmap
Date: Sat, 22 Apr 2006 15:09:48 -0700
Message-ID: <1145743788.10042.33.camel@profit>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I am unable to add a write-intent bitmap to an existing array.  The man
page indicates:

>When using an internal bitmap, the chunksize is automatically
>determined to make best use of available space.

Yet, it appears that bitmap being created is too large and goes past the
end of the partitions provided to the array.

How can I add a write-intent bitmap to this array or will I need to
re-create this array?

-Arthur

mdadm version: 2.4.1
kernel version: linux-2.6.16-gentoo-r2

The command:

# mdadm -Gb internal /dev/md0
mdadm: failed to set internal bitmap.

The kernel log:
Apr 22 14:57:59 loss kernel: md0: bitmap file is out of date (0 <
1920472) -- forcing full recovery
Apr 22 14:57:59 loss kernel: md0: bitmap file is out of date, doing full
recovery
Apr 22 14:57:59 loss kernel: attempt to access beyond end of device
Apr 22 14:57:59 loss kernel: sdh2: rw=16, want=781289152,
limit=781289145
Apr 22 14:57:59 loss kernel: attempt to access beyond end of device
Apr 22 14:57:59 loss kernel: sdg2: rw=16, want=781289152,
limit=781289145
Apr 22 14:57:59 loss kernel: attempt to access beyond end of device
Apr 22 14:57:59 loss kernel: sdf2: rw=16, want=781289152,
limit=781289145
Apr 22 14:57:59 loss kernel: attempt to access beyond end of device
Apr 22 14:57:59 loss kernel: sde2: rw=16, want=781289152,
limit=781289145
Apr 22 14:57:59 loss kernel: attempt to access beyond end of device
Apr 22 14:57:59 loss kernel: sdd2: rw=16, want=781289152,
limit=781289145
Apr 22 14:57:59 loss kernel: attempt to access beyond end of device
Apr 22 14:57:59 loss kernel: sdc2: rw=16, want=781289152,
limit=781289145
Apr 22 14:57:59 loss kernel: md0: bitmap initialized from disk: read
22/24 pages, set 718848 bits, status: -5
Apr 22 14:57:59 loss kernel: md: couldn't update array info. -5

The RAID-5 array:

# mdadm -D /dev/md0
/dev/md0:
        Version : 00.90.03
  Creation Time : Wed Feb 15 02:18:54 2006
     Raid Level : raid5
     Array Size : 1953222400 (1862.74 GiB 2000.10 GB)
    Device Size : 390644480 (372.55 GiB 400.02 GB)
   Raid Devices : 6
  Total Devices : 6
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Sat Apr 22 14:46:36 2006
          State : clean
 Active Devices : 6
Working Devices : 6
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

           UUID : e49080f3:c60755cc:bef07a34:d5ceac64
         Events : 0.1920471

    Number   Major   Minor   RaidDevice State
       0       8       34        0      active sync   /dev/sdc2
       1       8       98        1      active sync   /dev/sdg2
       2       8       82        2      active sync   /dev/sdf2
       3       8       66        3      active sync   /dev/sde2
       4       8      114        4      active sync   /dev/sdh2
       5       8       50        5      active sync   /dev/sdd2

A component of the array:

# mdadm -E /dev/sdc2
/dev/sdc2:
          Magic : a92b4efc
        Version : 00.90.03
           UUID : e49080f3:c60755cc:bef07a34:d5ceac64
  Creation Time : Wed Feb 15 02:18:54 2006
     Raid Level : raid5
    Device Size : 390644480 (372.55 GiB 400.02 GB)
     Array Size : 1953222400 (1862.74 GiB 2000.10 GB)
   Raid Devices : 6
  Total Devices : 6
Preferred Minor : 0

    Update Time : Sat Apr 22 14:57:59 2006
          State : clean
 Active Devices : 6
Working Devices : 6
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 884454d9 - correct
         Events : 0.1920473

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     0       8       34        0      active sync   /dev/sdc2

   0     0       8       34        0      active sync   /dev/sdc2
   1     1       8       98        1      active sync   /dev/sdg2
   2     2       8       82        2      active sync   /dev/sdf2
   3     3       8       66        3      active sync   /dev/sde2
   4     4       8      114        4      active sync   /dev/sdh2
   5     5       8       50        5      active sync   /dev/sdd2

The 6 disks are partitioned as follows:

Disk /dev/sdc: 400.0 GB, 400088457216 bytes
255 heads, 63 sectors/track, 48641 cylinders, total 781422768 sectors
Units = sectors of 1 * 512 = 512 bytes

   Device Boot      Start         End      Blocks   Id  System
/dev/sdc1              63      128519       64228+  83  Linux
/dev/sdc2          128520   781417664   390644572+  fd  Linux raid
autodetect

The total number of blocks in a component partition is:
781417664-128520+1=781289145

The attempted access is to:
781289152

Which is 7 blocks past the end of the partition:
781289152-781289145=7



