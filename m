From: Chris Allen <chris@photobox.co.uk>
Subject: raid5 wont restart after disk failure, then corrupts
Date: Tue, 28 Feb 2006 22:08:11 +0000
Message-ID: <20060228220811.GA32469@cjx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


I have had two serious raid5 problems in the last couple of days.
Any advice would be much appreciated as they are problems that
I would very much like to avoid in the future. I'd also like to
know what was going on under the hood....

--------------------

I have an 8 disk array running raid5. Normal config looks something
like this:

        Version : 00.90.01
  Creation Time : Thu Oct  6 11:37:30 2005
     Raid Level : raid5
     Array Size : 2734961152 (2608.26 GiB 2800.60 GB)
    Device Size : 390708736 (372.61 GiB 400.09 GB)
   Raid Devices : 8
  Total Devices : 8
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Mon Feb 27 23:32:33 2006
          State : clean
 Active Devices : 8
Working Devices : 8
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

           UUID : 2d8e676b:b94f46a5:53b1ba2d:0a9edba1
         Events : 0.9523668

    Number   Major   Minor   RaidDevice State
       0       8        1        0      active sync   /dev/sda1
       1       8       17        1      active sync   /dev/sdb1
       2       8       33        2      active sync   /dev/sdc1
       3       8       49        3      active sync   /dev/sdd1
       4       8       65        4      active sync   /dev/sde1
       5       8       81        5      active sync   /dev/sdf1
       6       8       97        6      active sync   /dev/sdg1
       7       8      113        7      active sync   /dev/sdh1


================================================
PROBLEM 1 - UNABLE TO START ARRAY WITH NEW DRIVE
================================================

Yesterday morning we had an io error on /dev/sdd1:

Feb 27 10:08:57 snap25 kernel: SCSI error : <0 0 3 0> return code = 0x10000
Feb 27 10:08:57 snap25 kernel: end_request: I/O error, dev sdd, sector 50504271
Feb 27 10:08:57 snap25 kernel: raid5: Disk failure on sdd1, disabling device. Operation continuing on 7 devices

So, I shutdown the system and replaced drive sdd with a new one. 
When I powered up again, all was not well. The array wouldn't start:

---------------------

Feb 27 13:36:02 snap25 kernel: md: Autodetecting RAID arrays.
Feb 27 13:36:02 snap25 kernel: md: autorun ...
Feb 27 13:36:02 snap25 kernel: md: considering sdh1 ...
Feb 27 13:36:02 snap25 kernel: md:  adding sdh1 ...
Feb 27 13:36:02 snap25 kernel: md:  adding sdg1 ...
Feb 27 13:36:02 snap25 kernel: md:  adding sdf1 ...
Feb 27 13:36:02 snap25 kernel: md:  adding sde1 ...
Feb 27 13:36:02 snap25 kernel: md:  adding sdc1 ...
Feb 27 13:36:02 snap25 kernel: md:  adding sdb1 ...
Feb 27 13:36:02 snap25 kernel: md:  adding sda1 ...
Feb 27 13:36:02 snap25 kernel: md: created md0
Feb 27 13:36:02 snap25 kernel: md: bind<sda1>
Feb 27 13:36:02 snap25 kernel: md: bind<sdb1>
Feb 27 13:36:02 snap25 kernel: md: bind<sdc1>
Feb 27 13:36:02 snap25 kernel: md: bind<sde1>
Feb 27 13:36:02 snap25 kernel: md: bind<sdf1>
Feb 27 13:36:02 snap25 kernel: md: bind<sdg1>
Feb 27 13:36:02 snap25 kernel: md: bind<sdh1>
Feb 27 13:36:02 snap25 kernel: md: running: <sdh1><sdg1><sdf1><sde1><sdc1><sdb1><sda1>
Feb 27 13:36:02 snap25 kernel: md: md0: raid array is not clean -- starting background reconstruction
Feb 27 13:36:02 snap25 kernel: raid5: automatically using best checksumming function: pIII_sse
Feb 27 13:36:02 snap25 kernel:    pIII_sse  :  5160.000 MB/sec
Feb 27 13:36:02 snap25 kernel: raid5: using function: pIII_sse (5160.000 MB/sec)
Feb 27 13:36:02 snap25 kernel: md: raid5 personality registered as nr 4
Feb 27 13:36:02 snap25 kernel: raid5: device sdh1 operational as raid disk 7
Feb 27 13:36:02 snap25 kernel: raid5: device sdg1 operational as raid disk 6
Feb 27 13:36:02 snap25 kernel: raid5: device sdf1 operational as raid disk 5
Feb 27 13:36:02 snap25 kernel: raid5: device sde1 operational as raid disk 4
Feb 27 13:36:02 snap25 kernel: raid5: device sdc1 operational as raid disk 2
Feb 27 13:36:02 snap25 kernel: raid5: device sdb1 operational as raid disk 1
Feb 27 13:36:02 snap25 kernel: raid5: device sda1 operational as raid disk 0
Feb 27 13:36:02 snap25 kernel: raid5: cannot start dirty degraded array for md0
Feb 27 13:36:02 snap25 kernel: RAID5 conf printout:
Feb 27 13:36:02 snap25 kernel:  --- rd:8 wd:7 fd:1
Feb 27 13:36:02 snap25 kernel:  disk 0, o:1, dev:sda1
Feb 27 13:36:02 snap25 kernel:  disk 1, o:1, dev:sdb1
Feb 27 13:36:02 snap25 kernel:  disk 2, o:1, dev:sdc1
Feb 27 13:36:02 snap25 kernel:  disk 4, o:1, dev:sde1
Feb 27 13:36:02 snap25 kernel:  disk 5, o:1, dev:sdf1
Feb 27 13:36:02 snap25 kernel:  disk 6, o:1, dev:sdg1
Feb 27 13:36:02 snap25 kernel:  disk 7, o:1, dev:sdh1
Feb 27 13:36:02 snap25 kernel: raid5: failed to run raid set md0
Feb 27 13:36:02 snap25 kernel: md: pers->run() failed ...
Feb 27 13:36:02 snap25 kernel: md :do_md_run() returned -22
Feb 27 13:36:02 snap25 kernel: md: md0 stopped.

-----------------------

I tried assembling the array with --force, but this would produce exactly the
same results as above - the array would refuse to start.

QUESTION: What should I have done here? Each time I have tried this in the past, I
have had no problems restarting the array and adding the new disk. What had gone
wrong, and why wouldn't the array start?


Then things went from bad to worse.


===========================================
PROBLEM 2 - DATA CORRUPTION
===========================================

As I couldn't start the array, I tried putting the original drive sdd
back in again and rebooting. To my surprise, the array started without
error:

Feb 27 14:09:22 snap25 kernel: md: Autodetecting RAID arrays.
Feb 27 14:09:22 snap25 kernel: md: autorun ...
Feb 27 14:09:22 snap25 kernel: md: considering sdh1 ...
Feb 27 14:09:22 snap25 kernel: md:  adding sdh1 ...
Feb 27 14:09:22 snap25 kernel: md:  adding sdg1 ...
Feb 27 14:09:22 snap25 kernel: md:  adding sdf1 ...
Feb 27 14:09:22 snap25 kernel: md:  adding sde1 ...
Feb 27 14:09:22 snap25 kernel: md:  adding sdd1 ...
Feb 27 14:09:22 snap25 kernel: md:  adding sdc1 ...
Feb 27 14:09:22 snap25 kernel: md:  adding sdb1 ...
Feb 27 14:09:22 snap25 kernel: md:  adding sda1 ...
Feb 27 14:09:22 snap25 kernel: md: created md0
Feb 27 14:09:22 snap25 kernel: md: bind<sda1>
Feb 27 14:09:22 snap25 kernel: md: bind<sdb1>
Feb 27 14:09:22 snap25 kernel: md: bind<sdc1>
Feb 27 14:09:22 snap25 kernel: md: bind<sdd1>
Feb 27 14:09:22 snap25 kernel: md: bind<sde1>
Feb 27 14:09:22 snap25 kernel: md: bind<sdf1>
Feb 27 14:09:22 snap25 kernel: md: bind<sdg1>
Feb 27 14:09:22 snap25 kernel: md: bind<sdh1>
Feb 27 14:09:22 snap25 kernel: md: running: <sdh1><sdg1><sdf1><sde1><sdd1><sdc1><sdb1><sda1>
Feb 27 14:09:22 snap25 kernel: md: md0: raid array is not clean -- starting background reconstruction
Feb 27 14:09:22 snap25 kernel: raid5: automatically using best checksumming function: pIII_sse
Feb 27 14:09:22 snap25 kernel:    pIII_sse  :  5168.000 MB/sec
Feb 27 14:09:22 snap25 kernel: raid5: using function: pIII_sse (5168.000 MB/sec)
Feb 27 14:09:22 snap25 kernel: md: raid5 personality registered as nr 4
Feb 27 14:09:22 snap25 kernel: raid5: device sdh1 operational as raid disk 7
Feb 27 14:09:22 snap25 kernel: raid5: device sdg1 operational as raid disk 6
Feb 27 14:09:22 snap25 kernel: raid5: device sdf1 operational as raid disk 5
Feb 27 14:09:22 snap25 kernel: raid5: device sde1 operational as raid disk 4
Feb 27 14:09:22 snap25 kernel: raid5: device sdd1 operational as raid disk 3
Feb 27 14:09:22 snap25 kernel: raid5: device sdc1 operational as raid disk 2
Feb 27 14:09:22 snap25 kernel: raid5: device sdb1 operational as raid disk 1
Feb 27 14:09:22 snap25 kernel: raid5: device sda1 operational as raid disk 0
Feb 27 14:09:22 snap25 kernel: raid5: allocated 8367kB for md0
Feb 27 14:09:22 snap25 kernel: raid5: raid level 5 set md0 active with 8 out of 8 devices, algorithm 2
Feb 27 14:09:22 snap25 kernel: RAID5 conf printout:
Feb 27 14:09:22 snap25 kernel:  --- rd:8 wd:8 fd:0
Feb 27 14:09:22 snap25 kernel:  disk 0, o:1, dev:sda1
Feb 27 14:09:22 snap25 kernel:  disk 1, o:1, dev:sdb1
Feb 27 14:09:22 snap25 kernel:  disk 2, o:1, dev:sdc1
Feb 27 14:09:22 snap25 kernel:  disk 3, o:1, dev:sdd1
Feb 27 14:09:22 snap25 kernel:  disk 4, o:1, dev:sde1
Feb 27 14:09:22 snap25 kernel:  disk 5, o:1, dev:sdf1
Feb 27 14:09:22 snap25 kernel:  disk 6, o:1, dev:sdg1
Feb 27 14:09:22 snap25 kernel:  disk 7, o:1, dev:sdh1
Feb 27 14:09:22 snap25 kernel: md: ... autorun DONE.
Feb 27 14:09:22 snap25 kernel: md: syncing RAID array md0



I left the array syncing and went for a coffee. About an hour later it had
done 20%. It was at this stage that I noticed that there was a considerable 
corruption on the filesystem that was on the raid array. On close inspection,
the corruption was limited to files that had changed since the broken drive
was kicked from the array in the first place. Worried by this, I switched the array
to readonly and have been copying off all of our data onto another device.

QUESTIONS:

1. Any idea what had happened here? Why didn't it notice that sdd1 was stale? 

2. If I had let it complete its resync would it have sorted out the corruption? 
Or would it have made things worse?


Any advice much appreciated.


Regards,


Chris Allen.


