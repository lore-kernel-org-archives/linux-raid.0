From: Brian Murphy <murphy+raid@email.arizona.edu>
Subject: mdstat E status and RAID5 recovery with mdadm
Date: Wed, 25 Nov 2009 02:07:21 -0700
Message-ID: <7ee8e147683dcaca81a56f4340999ee9@coppershadow.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I've searched the RAID FAQ's, wiki and googled it multiple different ways
but I can't find the E flag in the RAID documentation.  I'm using a
synology cs407e appliance with a 2.6.24 kernel.  This is what /proc/mdstat
shows:

CubeStation> cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid6] [raid5] [raid4]
md2 : active raid5 sda3[0] sdb3[1] sdc3[2](E)
      2188293696 blocks level 5, 64k chunk, algorithm 2 [4/3] [UUE_]

md1 : active raid1 sda2[0] sdb2[1] sdc2[2]
      522048 blocks [4/3] [UUU_]

md0 : active raid1 sda1[0] sdb1[1] sdc1[2]
      2489920 blocks [4/3] [UUU_]

unused devices: <none>


The backstory is that sdd failed so I was backing up the ext3 filesystem
on md2 when sdc3 had a hiccup.  Since mdadm is showing 3 of 4 drives in the
RAID set as active I'm really hoping someone can help me get md2 fully
online so that I can get the data off of it.

The appliance uses mdadm to manipulate the RAID volumes and is short on
other tools.  I've tried stopping /dev/md2 and using mdadm -Af /dev/md2
with the UUID below to recover it without luck. (it activates with the E
flag again)  Here is more info that will hopefully help determine the next
steps.

CubeStation> mdadm --detail /dev/md2
/dev/md2:
        Version : 00.90
  Creation Time : Tue Apr 28 02:42:08 2009
     Raid Level : raid5
     Array Size : 2188293696 (2086.92 GiB 2240.81 GB)
  Used Dev Size : 729431232 (695.64 GiB 746.94 GB)
   Raid Devices : 4
  Total Devices : 3
Preferred Minor : 2
    Persistence : Superblock is persistent

    Update Time : Tue Nov 24 21:42:24 2009
          State : clean, degraded
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

           UUID : aa6e4f7b:b441bc58:32d7a109:4c5bf4e2
         Events : 0.28604

    Number   Major   Minor   RaidDevice State
       0       8        3        0      active sync   /dev/sda3
       1       8       19        1      active sync   /dev/hdb3
       2       8       35        2      active sync   /dev/hdc3
       3       0        0        3      removed


CubeStation> mdadm -E /dev/sda3
/dev/sda3:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : aa6e4f7b:b441bc58:32d7a109:4c5bf4e2
  Creation Time : Tue Apr 28 02:42:08 2009
     Raid Level : raid5
  Used Dev Size : 729431232 (695.64 GiB 746.94 GB)
     Array Size : 2188293696 (2086.92 GiB 2240.81 GB)
   Raid Devices : 4
  Total Devices : 3
Preferred Minor : 2

    Update Time : Tue Nov 24 21:42:24 2009
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 1
  Spare Devices : 0
       Checksum : 478e9350 - correct
         Events : 28604

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     0       8        3        0      active sync   /dev/sda3

   0     0       8        3        0      active sync   /dev/sda3
   1     1       8       19        1      active sync   /dev/hdb3
   2     2       8       35        2      active sync   /dev/hdc3
   3     3       0        0        3      faulty removed

CubeStation> mdadm -E /dev/sdb3
/dev/sdb3:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : aa6e4f7b:b441bc58:32d7a109:4c5bf4e2
  Creation Time : Tue Apr 28 02:42:08 2009
     Raid Level : raid5
  Used Dev Size : 729431232 (695.64 GiB 746.94 GB)
     Array Size : 2188293696 (2086.92 GiB 2240.81 GB)
   Raid Devices : 4
  Total Devices : 3
Preferred Minor : 2

    Update Time : Tue Nov 24 21:42:24 2009
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 1
  Spare Devices : 0
       Checksum : 478e9362 - correct
         Events : 28604

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     1       8       19        1      active sync   /dev/hdb3

   0     0       8        3        0      active sync   /dev/sda3
   1     1       8       19        1      active sync   /dev/hdb3
   2     2       8       35        2      active sync   /dev/hdc3
   3     3       0        0        3      faulty removed

CubeStation> mdadm -E /dev/sdc3
/dev/sdc3:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : aa6e4f7b:b441bc58:32d7a109:4c5bf4e2
  Creation Time : Tue Apr 28 02:42:08 2009
     Raid Level : raid5
  Used Dev Size : 729431232 (695.64 GiB 746.94 GB)
     Array Size : 2188293696 (2086.92 GiB 2240.81 GB)
   Raid Devices : 4
  Total Devices : 3
Preferred Minor : 2

    Update Time : Tue Nov 24 21:42:24 2009
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 1
  Spare Devices : 0
       Checksum : 478e93b4 - correct
         Events : 28604

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     2       8       35        2      active sync   /dev/hdc3

   0     0       8        3        0      active sync   /dev/sda3
   1     1       8       19        1      active sync   /dev/hdb3
   2     2       8       35        2      active sync   /dev/hdc3
   3     3       0        0        3      faulty removed


CubeStation> mount -t ext3 -o ro /dev/md2 /volume1
mount: Mounting /dev/md2 on /volume1 failed: Invalid argument

CubeStation> tail /var/log/messages
Nov 25 00:48:08 kernel: md: md2: set sda3 to auto_remap [0]
Nov 25 00:48:08 kernel: md: md2: set sdc3 to auto_remap [0]
Nov 25 00:48:08 kernel: md: md2: set sdb3 to auto_remap [0]
Nov 25 00:48:08 kernel: raid5: raid level 5 set md2 active with 3 out of 4
devices, algorithm 2
Nov 25 00:48:08 kernel: RAID5 conf printout:
Nov 25 00:48:08 kernel:  --- rd:4 wd:3
Nov 25 00:48:08 kernel:  disk 0, o:1, dev:sda3
Nov 25 00:48:08 kernel:  disk 1, o:1, dev:sdb3
Nov 25 00:48:08 kernel:  disk 2, o:1, dev:sdc3
Nov 25 00:49:07 kernel: EXT3-fs: can't read group descriptor 47

Thank you for helping!
Brian


