From: Turbo Fredriksson <turbo@bayour.com>
Subject: Which (physical) disk is broken?
Date: Tue, 21 Dec 2004 12:08:55 +0100
Message-ID: <87ekhj6h88.fsf@pumba.bayour.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I've forgot, and I can't seem to find out which physical disk
is broken/removed from an array...

----- s n i p -----
aurora:~# mdadm -D /dev/md/1
/dev/md/1:
        Version : 00.90.01
  Creation Time : Wed Oct 27 08:12:44 2004
     Raid Level : raid5
     Array Size : 141483520 (134.93 GiB 144.88 GB)
    Device Size : 17685440 (16.87 GiB 18.11 GB)
   Raid Devices : 9
  Total Devices : 8
Preferred Minor : 1
    Persistence : Superblock is persistent

    Update Time : Tue Dec 21 12:04:43 2004
          State : dirty, degraded
 Active Devices : 8
Working Devices : 8
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 32K

    Number   Major   Minor   RaidDevice State
       0       8       49        0      active sync   /dev/scsi/host3/bus0/target4/lun0/part1
       1       8       81        1      active sync   /dev/scsi/host3/bus0/target8/lun0/part1
       2       8       97        2      active sync   /dev/scsi/host3/bus0/target9/lun0/part1
       3       8      241        3      active sync   /dev/scsi/host4/bus0/target4/lun0/part1
       4      65        1        4      active sync   /dev/scsi/host4/bus0/target5/lun0/part1
       5      65       17        5      active sync   /dev/scsi/host4/bus0/target8/lun0/part1
       6      65       33        6      active sync   /dev/scsi/host4/bus0/target9/lun0/part1
       7      65      113        7      active sync   /dev/scsi/host4/bus0/target14/lun0/part1
       8       0        0       -1      removed
           UUID : d0b4e775:290f5785:2e6ad7d1:5a66178b
         Events : 0.974012
----- s n i p -----

I _THINK_ (!!) it's '/dev/scsi/host4/bus0/target15/lun0/part', but
I'm not sure.... Don't want to yank a perfectly working disk :)

----- s n i p -----
aurora:~# mdadm -E /dev/scsi/host4/bus0/target15/lun0/part1
mdadm: No super block found on /dev/scsi/host4/bus0/target15/lun0/part1 (Expected magic a92b4efc, got 00000000)
----- s n i p -----

Is there any way I can find out exactly which disk 'number 8' is?

----- s n i p -----
aurora:~# mdadm --version
mdadm - v1.6.0 - 4 June 2004
aurora:~# uname -a
Linux aurora 2.6.8.1 #1 SMP Sun Dec 12 21:04:58 CET 2004 sparc64 unknown
----- s n i p -----
-- 
Ortega assassination explosion FBI president PLO Iran domestic
disruption genetic Ft. Bragg Rule Psix $400 million in gold bullion
Clinton Cocaine Treasury
[See http://www.aclu.org/echelonwatch/index.html for more about this]
