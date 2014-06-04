From: RedShift <redshift@telenet.be>
Subject: Recovering data from a shrunk RAID 10 array
Date: Wed, 4 Jun 2014 15:01:30 +0200 (CEST)
Message-ID: <1488530542.30565929.1401886890602.JavaMail.root@telenet.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello all


I'm trying to save data from a QNAP device which utilizes linux software RAID.
The RAID format used is RAID 10. The disks were handed to me after it was
decided a professional data recovery would cost too much for the data involved.
From what I can tell the following happened (I'm not sure as I wasn't there):

* The original RAID 10 array had 4 disks
* Array was expanded to 6 disks
* Filesystem has been resized
* Array was shrunk or rebuilt with 4 disks (remaining in RAID 10)
* The filesystem became unmountable.

The system has been booted with system rescue cd, which automatically starts
RAID arrays. This is the output from /proc/mdstat at this point:

---- cat /proc/mdstat

Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10] 
md127 : inactive sdd3[5](S) sda3[4](S)
      3903891200 blocks
       
md13 : active raid1 sdf4[0] sdd4[5] sda4[4] sdb4[3] sde4[2] sdc4[1]
      458880 blocks [8/6] [UUUUUU__]
      bitmap: 48/57 pages [192KB], 4KB chunk

md8 : active raid1 sdf2[0] sdd2[5](S) sda2[4](S) sde2[3](S) sdb2[2](S) sdc2[1]
      530048 blocks [2/2] [UU]
      
md9 : active raid1 sdf1[0] sdd1[5] sda1[4] sde1[3] sdb1[2] sdc1[1]
      530048 blocks [8/6] [UUUUUU__]
      bitmap: 65/65 pages [260KB], 4KB chunk

md0 : active raid10 sdf3[0] sde3[3] sdb3[2] sdc3[1]
      3903891200 blocks 64K chunks 2 near-copies [4/4] [UUUU]
      
unused devices: <none>



When I try to mount /dev/md0, it fails with this kernel message:

[  505.657356] EXT4-fs (md0): bad geometry: block count 1463959104 exceeds size of device (975972800 blocks)

If I skim /dev/md0 with "more", I do see random text data (the array was mainly
used for logging, so I see a lot of plaintext), so I suspect there is intact
data present.

What would be the best course of action here? Recreate the RAID array with
--assume-clean? I don't have room to create a backup of all the component
devices, risks known.


I recorded mdadm -E for every component:


---- mdadm -E /dev/sda3
/dev/sda3:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : ee50da6d:d084f704:2f17ef00:379899ff
  Creation Time : Fri May  2 07:16:58 2014
     Raid Level : raid10
  Used Dev Size : 1951945472 (1861.52 GiB 1998.79 GB)
     Array Size : 5855836416 (5584.56 GiB 5996.38 GB)
   Raid Devices : 6
  Total Devices : 4
Preferred Minor : 0

    Update Time : Sun May  4 10:22:16 2014
          State : active
 Active Devices : 4
Working Devices : 4
 Failed Devices : 2
  Spare Devices : 0
       Checksum : 411699c7 - correct
         Events : 15

         Layout : near=2
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     4       8       67        4      active sync   /dev/sde3

   0     0       8        3        0      active sync   /dev/sda3
   1     1       0        0        1      faulty removed
   2     2       8       35        2      active sync   /dev/sdc3
   3     3       0        0        3      faulty removed
   4     4       8       67        4      active sync   /dev/sde3
   5     5       8       83        5      active sync   /dev/sdf3


---- mdadm -E /dev/sdb3
/dev/sdb3:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 05b41ebc:0bd1a5ce:4778a22f:da014845
  Creation Time : Sun May  4 11:04:37 2014
     Raid Level : raid10
  Used Dev Size : 1951945600 (1861.52 GiB 1998.79 GB)
     Array Size : 3903891200 (3723.04 GiB 3997.58 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0

    Update Time : Mon May  5 14:30:00 2014
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0
       Checksum : f75212f1 - correct
         Events : 6

         Layout : near=2
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     2       8        3        2      active sync   /dev/sda3

   0     0       8       19        0      active sync   /dev/sdb3
   1     1       8       51        1      active sync   /dev/sdd3
   2     2       8        3        2      active sync   /dev/sda3
   3     3       8       35        3      active sync   /dev/sdc3


---- mdadm -E /dev/sdc3
/dev/sdc3:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 05b41ebc:0bd1a5ce:4778a22f:da014845
  Creation Time : Sun May  4 11:04:37 2014
     Raid Level : raid10
  Used Dev Size : 1951945600 (1861.52 GiB 1998.79 GB)
     Array Size : 3903891200 (3723.04 GiB 3997.58 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0

    Update Time : Mon May  5 14:30:00 2014
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0
       Checksum : f752131f - correct
         Events : 6

         Layout : near=2
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     1       8       51        1      active sync   /dev/sdd3

   0     0       8       19        0      active sync   /dev/sdb3
   1     1       8       51        1      active sync   /dev/sdd3
   2     2       8        3        2      active sync   /dev/sda3
   3     3       8       35        3      active sync   /dev/sdc3


---- mdadm -E /dev/sdd3
/dev/sdd3:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : ee50da6d:d084f704:2f17ef00:379899ff
  Creation Time : Fri May  2 07:16:58 2014
     Raid Level : raid10
  Used Dev Size : 1951945472 (1861.52 GiB 1998.79 GB)
     Array Size : 5855836416 (5584.56 GiB 5996.38 GB)
   Raid Devices : 6
  Total Devices : 4
Preferred Minor : 0

    Update Time : Sun May  4 10:22:16 2014
          State : active
 Active Devices : 4
Working Devices : 4
 Failed Devices : 2
  Spare Devices : 0
       Checksum : 411699d9 - correct
         Events : 15

         Layout : near=2
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     5       8       83        5      active sync   /dev/sdf3

   0     0       8        3        0      active sync   /dev/sda3
   1     1       0        0        1      faulty removed
   2     2       8       35        2      active sync   /dev/sdc3
   3     3       0        0        3      faulty removed
   4     4       8       67        4      active sync   /dev/sde3
   5     5       8       83        5      active sync   /dev/sdf3


---- mdadm -E /dev/sde3
/dev/sde3:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 05b41ebc:0bd1a5ce:4778a22f:da014845
  Creation Time : Sun May  4 11:04:37 2014
     Raid Level : raid10
  Used Dev Size : 1951945600 (1861.52 GiB 1998.79 GB)
     Array Size : 3903891200 (3723.04 GiB 3997.58 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0

    Update Time : Mon May  5 14:30:00 2014
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0
       Checksum : f7521313 - correct
         Events : 6

         Layout : near=2
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     3       8       35        3      active sync   /dev/sdc3

   0     0       8       19        0      active sync   /dev/sdb3
   1     1       8       51        1      active sync   /dev/sdd3
   2     2       8        3        2      active sync   /dev/sda3
   3     3       8       35        3      active sync   /dev/sdc3

   
---- mdadm -E /dev/sdf3
/dev/sdf3:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 05b41ebc:0bd1a5ce:4778a22f:da014845
  Creation Time : Sun May  4 11:04:37 2014
     Raid Level : raid10
  Used Dev Size : 1951945600 (1861.52 GiB 1998.79 GB)
     Array Size : 3903891200 (3723.04 GiB 3997.58 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0

    Update Time : Mon May  5 14:30:00 2014
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0
       Checksum : f75212fd - correct
         Events : 6

         Layout : near=2
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     0       8       19        0      active sync   /dev/sdb3

   0     0       8       19        0      active sync   /dev/sdb3
   1     1       8       51        1      active sync   /dev/sdd3
   2     2       8        3        2      active sync   /dev/sda3
   3     3       8       35        3      active sync   /dev/sdc3

   
Thanks,

Best regards,
