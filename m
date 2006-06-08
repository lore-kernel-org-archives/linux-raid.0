From: Bryce <bryce@zeniv.linux.org.uk>
Subject: And then there was Bryce...
Date: Thu, 08 Jun 2006 01:41:38 +0100
Message-ID: <44877242.2060803@zeniv.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Gosh, where to start,..

Ok general setup

I'm using  kernel version 2.6.17-rc5 and  Raid 5 over 5 500Gb SATA disks

(boring dump)
-----------------------------------------------------------------------
[root@emerald ~]# mdadm -D /dev/md0
/dev/md0:
        Version : 00.90.03
  Creation Time : Sat May 27 20:49:13 2006
     Raid Level : raid5
     Array Size : 1953533952 (1863.04 GiB 2000.42 GB)
    Device Size : 488383488 (465.76 GiB 500.10 GB)
   Raid Devices : 5
  Total Devices : 5
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Thu Jun  8 01:05:24 2006
          State : clean
 Active Devices : 5
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 1024K

           UUID : d8d7cacb:24db29e6:46ace8ec:49547cc4
         Events : 0.143369

    Number   Major   Minor   RaidDevice State
       0       8       17        0      active sync   /dev/sdb1
       1       8       33        1      active sync   /dev/sdc1
       2       8       49        2      active sync   /dev/sdd1
       3       8       65        3      active sync   /dev/sde1
       4       8       81        4      active sync   /dev/sdf1
-----------------------------------------------------------------------

Anyway, I happen to have a 512MB USB pen drive that I was playing with 
earlier that I left attached over a reboot

What follows is horrifying.

 From the syslog...

Jun  7 18:47:10 Emerald syslogd 1.4.1: restart.
Jun  7 18:47:10 Emerald kernel: klogd 1.4.1, log source = /proc/kmsg 
started.
Jun  7 18:47:10 Emerald kernel: Linux version 2.6.17-rc5 (root@emerald) 
(gcc version 4.1.0 20060304 (Red Hat 4.1.0-3)) #2 SMP Sun May 28 
15:29:46 BST 2006
...
everything going ok,.. normal boot
and then it all goes horribly wrong,...


Jun  7 18:52:30 Emerald kernel: raid5: Disk failure on sde1, disabling 
device. Operation continuing on 3 devices
Jun  7 18:52:30 Emerald kernel: RAID5 conf printout:
Jun  7 18:52:30 Emerald kernel:  --- rd:5 wd:3 fd:2
Jun  7 18:52:30 Emerald kernel:  disk 0, o:1, dev:sdb1
Jun  7 18:52:30 Emerald kernel:  disk 1, o:1, dev:sdd1
Jun  7 18:52:30 Emerald kernel:  disk 2, o:0, dev:sde1
Jun  7 18:52:30 Emerald kernel:  disk 4, o:1, dev:sdg1
Jun  7 18:52:30 Emerald kernel: RAID5 conf printout:
Jun  7 18:52:30 Emerald kernel:  --- rd:5 wd:3 fd:2
Jun  7 18:52:30 Emerald kernel:  disk 0, o:1, dev:sdb1
Jun  7 18:52:30 Emerald kernel:  disk 1, o:1, dev:sdd1
Jun  7 18:52:30 Emerald kernel:  disk 4, o:1, dev:sdg1
Jun  7 18:54:37 Emerald kernel: Buffer I/O error on device dm-2, logical 
block 0
Jun  7 18:54:37 Emerald kernel: lost page write due to I/O error on dm-2
Jun  7 18:57:11 Emerald kernel: Buffer I/O error on device md0, logical 
block 488383472
Jun  7 18:57:11 Emerald kernel: Buffer I/O error on device md0, logical 
block 488383472
Jun  7 18:57:11 Emerald kernel: Buffer I/O error on device md0, logical 
block 488383486
Jun  7 18:57:11 Emerald kernel: Buffer I/O error on device md0, logical 
block 488383486
Jun  7 19:05:10 Emerald kernel: md: unbind<sde1>
Jun  7 19:05:10 Emerald kernel: md: export_rdev(sde1)
Jun  7 19:05:15 Emerald kernel: md: bind<sde1>

but wait a sec,.. WTF is this sdg1 in the raid printout?....
reading back in the syslog, I see

Jun  7 18:47:26 Emerald kernel: SCSI device sdg: 976773168 512-byte hdwr 
sectors (500108 MB)
Jun  7 18:47:26 Emerald kernel: sdg: Write Protect is off
Jun  7 18:47:26 Emerald kernel: SCSI device sdg: drive cache: write back
Jun  7 18:47:26 Emerald kernel: SCSI device sdg: 976773168 512-byte hdwr 
sectors (500108 MB)
Jun  7 18:47:26 Emerald kernel: sdg: Write Protect is off
Jun  7 18:47:26 Emerald kernel: SCSI device sdg: drive cache: write back
Jun  7 18:47:26 Emerald kernel:  sdg: sdg1
Jun  7 18:47:26 Emerald kernel: sd 6:0:0:0: Attached scsi disk sdg

well thats nice, thats my pendrive! so what happened when it setup the 
array?

Jun  7 18:47:30 Emerald kernel: md: Autodetecting RAID arrays.
Jun  7 18:47:30 Emerald kernel: md: autorun ...
Jun  7 18:47:30 Emerald kernel: md: considering sdg1 ...
Jun  7 18:47:30 Emerald kernel: md:  adding sdg1 ...
Jun  7 18:47:30 Emerald kernel: md:  adding sdf1 ...
Jun  7 18:47:30 Emerald kernel: md:  adding sde1 ...
Jun  7 18:47:30 Emerald kernel: md:  adding sdd1 ...
Jun  7 18:47:30 Emerald kernel: md:  adding sdb1 ...
Jun  7 18:47:30 Emerald kernel: md: created md0
Jun  7 18:47:30 Emerald kernel: md: bind<sdb1>
Jun  7 18:47:31 Emerald kernel: md: bind<sdd1>
Jun  7 18:47:31 Emerald kernel: md: bind<sde1>
Jun  7 18:47:31 Emerald kernel: md: bind<sdf1>
Jun  7 18:47:31 Emerald kernel: md: bind<sdg1>
Jun  7 18:47:31 Emerald kernel: md: running: <sdg1><sdf1><sde1><sdd1><sdb1>
Jun  7 18:47:31 Emerald kernel: md: kicking non-fresh sdf1 from array!
Jun  7 18:47:31 Emerald kernel: md: unbind<sdf1>
Jun  7 18:47:31 Emerald kernel: md: export_rdev(sdf1)
Jun  7 18:47:31 Emerald kernel: raid5: automatically using best 
checksumming function: pIII_sse
Jun  7 18:47:31 Emerald kernel:    pIII_sse  :  4203.000 MB/sec
Jun  7 18:47:31 Emerald kernel: raid5: using function: pIII_sse 
(4203.000 MB/sec)
Jun  7 18:47:31 Emerald kernel: md: raid5 personality registered for level 5
Jun  7 18:47:31 Emerald kernel: md: raid4 personality registered for level 4
Jun  7 18:47:31 Emerald kernel: raid5: device sdg1 operational as raid 
disk 4
Jun  7 18:47:31 Emerald kernel: raid5: device sde1 operational as raid 
disk 2
Jun  7 18:47:31 Emerald kernel: raid5: device sdd1 operational as raid 
disk 1
Jun  7 18:47:31 Emerald kernel: raid5: device sdb1 operational as raid 
disk 0
Jun  7 18:47:31 Emerald kernel: raid5: allocated 5248kB for md0
Jun  7 18:47:31 Emerald kernel: raid5: raid level 5 set md0 active with 
4 out of 5 devices, algorithm 2
Jun  7 18:47:31 Emerald kernel: RAID5 conf printout:
Jun  7 18:47:31 Emerald kernel:  --- rd:5 wd:4 fd:1
Jun  7 18:47:31 Emerald kernel:  disk 0, o:1, dev:sdb1
Jun  7 18:47:31 Emerald kernel:  disk 1, o:1, dev:sdd1
Jun  7 18:47:31 Emerald kernel:  disk 2, o:1, dev:sde1
Jun  7 18:47:31 Emerald kernel:  disk 4, o:1, dev:sdg1
Jun  7 18:47:31 Emerald kernel: md: ... autorun DONE.

WHAT THE HELL?!??
*considering sdg1* ?!?! then deciding it was fair game to use?!??
it's a FAT16 FS pendrive with NO UUID stuff on it...
suddenly the RAID5 gets very unhappy and becomes a RID5 and I spend the 
next few hours rebuilding it (fortunately all data was preserved but it 
wasn't a pleasant evening I can tell you)

Hum ho,.. I survived the horror but umm, well, I'll leave the above as a 
story to frighten young sysadmins with.

Phil
=--=


