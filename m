From: Sebastian Herbszt <herbszt@gmx.de>
Subject: How to identify a failed md array
Date: Mon, 26 May 2014 20:07:11 +0200
Message-ID: <20140526200711.000030e2@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Sebastian Herbszt <herbszt@gmx.de>
List-Id: linux-raid.ids

Hello,

I am wondering how to identify a failed md array.
Lets assume the following array

/dev/md0:
        Version : 1.2
  Creation Time : Mon May 26 19:10:59 2014
     Raid Level : raid1
     Array Size : 10176 (9.94 MiB 10.42 MB)
  Used Dev Size : 10176 (9.94 MiB 10.42 MB)
   Raid Devices : 2
  Total Devices : 2
    Persistence : Superblock is persistent

    Update Time : Mon May 26 19:10:59 2014
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

           Name : test:0  (local to host test)
           UUID : cac8fd48:44219a96:5de7e757:4e21a3e2
         Events : 17

    Number   Major   Minor   RaidDevice State
       0     254        0        0      active sync   /dev/dm-0
       1     254        1        1      active sync   /dev/dm-1

with

/sys/block/md0/md/array_state:clean
/sys/block/md0/md/dev-dm-0/state:in_sync
/sys/block/md0/md/dev-dm-1/state:in_sync

and

disk0: 0 20480 linear 7:0 0
disk1: 0 20480 linear 7:1 0

If dm-0 gets changed to "disk0: 0 20480 error" and we read from the
array (dd if=/dev/md0 count=1 iflag=direct of=/dev/null) the broken
disk gets detected by md:

[84688.483607] md/raid1:md0: dm-0: rescheduling sector 0
[84688.483654] md/raid1:md0: redirecting sector 0 to other mirror: dm-1
[84688.483670] md: super_written gets error=-5, uptodate=0
[84688.483672] md/raid1:md0: Disk failure on dm-0, disabling device.
md/raid1:md0: Operation continuing on 1 devices.
[84688.483676] md: super_written gets error=-5, uptodate=0
[84688.494174] RAID1 conf printout:
[84688.494178]  --- wd:1 rd:2
[84688.494181]  disk 0, wo:1, o:0, dev:dm-0
[84688.494182]  disk 1, wo:0, o:1, dev:dm-1
[84688.494183] RAID1 conf printout:
[84688.494184]  --- wd:1 rd:2
[84688.494184]  disk 1, wo:0, o:1, dev:dm-1

/dev/md0:
        Version : 1.2
  Creation Time : Mon May 26 19:10:59 2014
     Raid Level : raid1
     Array Size : 10176 (9.94 MiB 10.42 MB)
  Used Dev Size : 10176 (9.94 MiB 10.42 MB)
   Raid Devices : 2
  Total Devices : 2
    Persistence : Superblock is persistent

    Update Time : Mon May 26 19:27:41 2014
          State : clean, degraded
 Active Devices : 1
Working Devices : 1
 Failed Devices : 1
  Spare Devices : 0

           Name : test:0  (local to host test)
           UUID : cac8fd48:44219a96:5de7e757:4e21a3e2
         Events : 20

    Number   Major   Minor   RaidDevice State
       0       0        0        0      removed
       1     254        1        1      active sync   /dev/dm-1

       0     254        0        -      faulty   /dev/dm-0

md0 : active raid1 dm-1[1] dm-0[0](F)
      10176 blocks super 1.2 [2/1] [_U]

/sys/block/md0/md/array_state:clean
/sys/block/md0/md/dev-dm-0/state:faulty,write_error
/sys/block/md0/md/dev-dm-1/state:in_sync
/sys/block/md0/md/degraded:1

However if I also change dm-1 to "disk1: 0 20480 error" and read
again there is no visible state change:

/dev/md0:
        Version : 1.2
  Creation Time : Mon May 26 19:10:59 2014
     Raid Level : raid1
     Array Size : 10176 (9.94 MiB 10.42 MB)
  Used Dev Size : 10176 (9.94 MiB 10.42 MB)
   Raid Devices : 2
  Total Devices : 2
    Persistence : Superblock is persistent

    Update Time : Mon May 26 19:27:41 2014
          State : clean, degraded
 Active Devices : 1
Working Devices : 1
 Failed Devices : 1
  Spare Devices : 0

    Number   Major   Minor   RaidDevice State
       0       0        0        0      removed
       1     254        1        1      active sync   /dev/dm-1

       0     254        0        -      faulty   /dev/dm-0

md0 : active raid1 dm-1[1] dm-0[0](F)
      10176 blocks super 1.2 [2/1] [_U]

/sys/block/md0/md/array_state:clean
/sys/block/md0/md/dev-dm-0/state:faulty,write_error
/sys/block/md0/md/dev-dm-1/state:in_sync
/sys/block/md0/md/degraded:1

On write to the array we get

[85498.660247] md: super_written gets error=-5, uptodate=0
[85498.666464] quiet_error: 268 callbacks suppressed
[85498.666470] Buffer I/O error on device md0, logical block 2528
[85498.666476] Buffer I/O error on device md0, logical block 2528
[85498.666486] Buffer I/O error on device md0, logical block 2542
[85498.666490] Buffer I/O error on device md0, logical block 2542
[85498.666496] Buffer I/O error on device md0, logical block 0
[85498.666499] Buffer I/O error on device md0, logical block 0
[85498.666508] Buffer I/O error on device md0, logical block 1
[85498.666512] Buffer I/O error on device md0, logical block 1
[85498.666518] Buffer I/O error on device md0, logical block 2543
[85498.666524] Buffer I/O error on device md0, logical block 2543
[85498.866388] md: super_written gets error=-5, uptodate=0

and the only change is

/sys/block/md0/md/dev-dm-1/state:in_sync,write_error,want_replacement

How can I identify a failed array?
array_state reports "clean", the last raid member stays "in_sync" and
the value in degraded doesn't equal raid_disks.

Sebastian
