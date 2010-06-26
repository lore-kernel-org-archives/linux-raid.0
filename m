From: Markus Hennig <mhennig@gmail.com>
Subject: RAID5 crashed for unknown reason on old 2.6.16 kernel
Date: Sat, 26 Jun 2010 23:22:41 +0200
Message-ID: <AANLkTimTAvYM7p4sk8S5He4WOWT3FW6IRPQ0AfpFnIVR@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

my RAID5 with 4 disks crashed on a Buffalo "NAS" box (big-endian!) -
no logs of course...
I made immediately images of all disks and try to now gather my very
valuable content on a Linux box running GRML 4/10 (little-endian!)
with 2.6.33 and mdadm - v3.1.1.
Some blocks were not readable from HDD2, maybe that's the reason why
the Buffalo box shut down.


What I know already:

- the RAID5 was created with a very old set of software:
linux-2.6.16-tshtgl.tgz   mdadm-2.5.2.tgz   xfsprogs-2.5.6_arm.tgz
- the Buffalo box blinked red on HDD2
- the box run a rebuild on HDD4, I don't know if that was already finished
- all disks are identically, 250GB

- Partitioning:
Disk /dev/sdb: 251.0 GB, 251000193024 bytes
255 heads, 63 sectors/track, 30515 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Disk identifier: 0x35353535

   Device Boot      Start         End      Blocks   Id  System
/dev/sdb1               1          48      385528+  fd  Linux raid autodetect
/dev/sdb2              49          65      136552+  82  Linux swap / Solaris
/dev/sdb3              66       30378   243481141   fd  Linux raid autodetect
/dev/sdb4           30378       30515     1108484   fd  Linux raid autodetect

- Partition 3 is the data partition:

HDD1: (mdadm   --examine --metadata=0.swap /dev/mapper/loop1p3 )
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 9eb0d5a8:1ce1a3c7:e82c8901:cfa389c2
  Creation Time : Sun Nov 21 19:31:12 2004
     Raid Level : raid5
  Used Dev Size : 243481024 (232.20 GiB 249.32 GB)
     Array Size : 730443072 (696.60 GiB 747.97 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 1

    Update Time : Tue Jun 22 01:58:56 2010
          State : clean
 Active Devices : 2
Working Devices : 3
 Failed Devices : 1
  Spare Devices : 1
       Checksum : b8d2f28c - correct

         Events : 131
         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     0       3        3        0      active sync

   0     0       3        3        0      active sync
   1     1      22        3        1      faulty
   2     2      33        3        2      active sync
   3     3       0        0        3      faulty removed
   4     4      34        3        4      spare


HDD2:
          Magic : a92b4efc
        Version : 0.91.00
           UUID : ffffffff:ffffffff:ffffffff:ffffffff
  Creation Time : Sun Nov 21 19:31:12 2004
     Raid Level : raid5
  Used Dev Size : 243481024 (232.20 GiB 249.32 GB)
     Array Size : 730443072 (696.60 GiB 747.97 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 1

  Reshape pos'n : 0
      New Level : raid0
     New Layout : left-asymmetric
  New Chunksize : 0

    Update Time : Mon Jun 21 22:41:19 2010
          State : active
 Active Devices : 3
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 1
       Checksum : b8d2c453 - expected 45703820
         Events : 129

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     1      22        3        1      active sync

   0     0       3        3        0      active sync
   1     1      22        3        1      active sync
   2     2      33        3        2      active sync
   3     3       0        0        3      faulty removed
   4     4      34        3        4      spare


HDD3:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 9eb0d5a8:1ce1a3c7:e82c8901:cfa389c2
  Creation Time : Sun Nov 21 19:31:12 2004
     Raid Level : raid5
  Used Dev Size : 243481024 (232.20 GiB 249.32 GB)
     Array Size : 730443072 (696.60 GiB 747.97 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 1

    Update Time : Tue Jun 22 01:58:56 2010
          State : clean
 Active Devices : 2
Working Devices : 3
 Failed Devices : 1
  Spare Devices : 1
       Checksum : b8d2f2ae - correct
         Events : 131

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     2      33        3        2      active sync

   0     0       3        3        0      active sync
   1     1      22        3        1      faulty
   2     2      33        3        2      active sync
   3     3       0        0        3      faulty removed
   4     4      34        3        4      spare

HDD4:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 9eb0d5a8:1ce1a3c7:e82c8901:cfa389c2
  Creation Time : Sun Nov 21 19:31:12 2004
     Raid Level : raid5
  Used Dev Size : 243481024 (232.20 GiB 249.32 GB)
     Array Size : 730443072 (696.60 GiB 747.97 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 1

    Update Time : Tue Jun 22 01:58:56 2010
          State : clean
 Active Devices : 2
Working Devices : 3
 Failed Devices : 1
  Spare Devices : 1
       Checksum : b8d2f2ad - correct
         Events : 131

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     4      34        3        4      spare

   0     0       3        3        0      active sync
   1     1      22        3        1      faulty
   2     2      33        3        2      active sync
   3     3       0        0        3      faulty removed
   4     4      34        3        4      spare


My various experiments with "--assemble" and/or "--create" are not
successful so far.
What I learned already, I have to use "--update=byteorder"  and
"--metadata=0"  ;-)



Open questions for which I wasn't able to find a answer myself :

What triggers the event count? And why is the event counter on HDD2
just 129, on all other 131?
Can that cause problems while rescue my data and how can I work around it?


What is that "UUID : ffffffff:ffffffff:ffffffff:ffffffff" on HDD2?
What does it mean?

Its really in the superblock on the hard disk:
 hexdump -s 488006273b -C hdd2_ddrescue
 3a2cc50200  a9 2b 4e fc 00 00 00 00  00 00 00 5b 00 00 00 00
|.+N........[....|
 3a2cc50210  00 00 00 00 ff ff ff ff  41 a0 de f0 00 00 00 05
|........A.......|
 3a2cc50220  0e 83 39 c0 00 00 00 04  00 00 00 04 00 00 00 01
|..9.............|
 3a2cc50230  00 00 00 00 ff ff ff ff  ff ff ff ff ff ff ff ff
|................|
 3a2cc50240  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
|................|
Would it help to rewrite the UUID via hexedit to the correct one?


Can somebody explain the meaning of:
  Reshape pos'n : 0
      New Level : raid0
     New Layout : left-asymmetric
  New Chunksize : 0
on HDD2 ?


What parameters are included in the checksum?
And how critical in on HHD2 that "Checksum : b8d2c453 - expected 45703820"?


I have no explanation why "Version :" is on HDD2 on 0.91.00"...
I see 0x5B in the partition 3 superblock on HDD2 (and on all other
0x5A), so its really on the disk...  Weird...
Somebody any idea on that?



Any(!) help is very appreciated, incl. hints at resources (papers,
docu, code) or questions for additional information.

Thx in advance,
Markus
