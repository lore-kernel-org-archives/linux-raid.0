From: "Cress, Andrew R" <andrew.r.cress@intel.com>
Subject: RE: no resync after hotadd
Date: Wed, 24 Sep 2003 14:56:37 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E5DA6395B8F9614EB7A784D628184B200D9AB7@hdsmsx402.hd.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
content-class: urn:content-classes:message
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


In looking at the code, hot_add_disk does:
   mddev->sb>nr_disks++;
   mddev->sb>spare_disks++;
   mddev->sb>working_disks++;
then do_recovery checks
   if (sb->active_disks == sb->raid_disks) 
       continue;
which seems ok to me, but I'd guess that the problem is in the counters
somewhere.
Perhaps it is looking at the new sdb sb instead of the one from sda?

Andy


-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Cress, Andrew R
Sent: Tuesday, September 23, 2003 10:44 AM
To: linux-raid@vger.kernel.org
Subject: no resync after hotadd


Neil,

I've seen this before, but it is very reproducable on the SuSE/UL system
I am testing on now.
When I hotadd a new/replacement disk (sdb) into the raid device, the
resync doesn't start.
From the superblocks, apparently the active disk still has total disks=1
so only 1 active, but the new disk superblock was written with total
disks=2 and both active.  

The configuration is raid1 with sda and sdb, and sdb was hot-removed and
hot-added (each partition with mdadm -a).
I've included the resulting superblocks, and the syslog for the add
sequence is attached.

Is this a problem with the md driver?  

Andy

# uname -a
Linux telcoraid 2.4.21-55-smp #1 SMP Wed Aug 27 19:53:48 UTC 2003 i686
unknown
# cat /proc/mdstat
Personalities : [raid1] 
read_ahead 1024 sectors
md2 : active raid1 sdb2[2] sda2[1]
      136448 blocks [2/1] [_U]
      
md1 : active raid1 sdb1[2] sda1[1]
      80256 blocks [2/1] [_U]
      
md0 : active raid1 sdb3[2] sda3[1]
      17518784 blocks [2/1] [_U]
      
unused devices: <none>

#
# mdadm -E /dev/sda1
/dev/sda1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 15e24cfe:af2ecf43:9c74fae1:7aabf6f0
  Creation Time : Thu Sep 18 13:12:09 2003
     Raid Level : raid1
    Device Size : 80256 (78.38 MiB 82.18 MB)
   Raid Devices : 2
  Total Devices : 1
Preferred Minor : 1

    Update Time : Mon Sep 22 12:58:41 2003
          State : dirty, no-errors
 Active Devices : 1
Working Devices : 1
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 43828e3 - correct
         Events : 0.28


      Number   Major   Minor   RaidDevice State
this     1       8        1        1      active sync   /dev/sda1
   0     0       0        0        0      faulty removed
   1     1       8        1        1      active sync   /dev/sda1

/dev/sdb1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 15e24cfe:af2ecf43:9c74fae1:7aabf6f0
  Creation Time : Thu Sep 18 13:12:09 2003
     Raid Level : raid1
    Device Size : 80256 (78.38 MiB 82.18 MB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 1

    Update Time : Mon Sep 22 09:37:09 2003
          State : dirty, no-errors
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 437fa2f - correct
         Events : 0.25


      Number   Major   Minor   RaidDevice State
this     0       8       17        0      active sync   /dev/sdb1
   0     0       8       17        0      active sync   /dev/sdb1
   1     1       8        1        1      active sync   /dev/sda1

/dev/sda2:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 16df7960:13fe43ac:ac0cc4ba:42690535
  Creation Time : Thu Sep 18 13:12:56 2003
     Raid Level : raid1
    Device Size : 136448 (133.25 MiB 139.72 MB)
   Raid Devices : 2
  Total Devices : 1
Preferred Minor : 2

    Update Time : Mon Sep 22 12:58:41 2003
          State : dirty, no-errors
 Active Devices : 1
Working Devices : 1
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 415a7d7f - correct
         Events : 0.30


      Number   Major   Minor   RaidDevice State
this     1       8        2        1      active sync   /dev/sda2
   0     0       0        0        0      faulty removed
   1     1       8        2        1      active sync   /dev/sda2

/dev/sdb2:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 16df7960:13fe43ac:ac0cc4ba:42690535
  Creation Time : Thu Sep 18 13:12:56 2003
     Raid Level : raid1
    Device Size : 136448 (133.25 MiB 139.72 MB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 2

    Update Time : Mon Sep 22 09:37:09 2003
          State : dirty, no-errors
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 415a4ecc - correct
         Events : 0.27


      Number   Major   Minor   RaidDevice State
this     0       8       18        0      active sync   /dev/sdb2
   0     0       8       18        0      active sync   /dev/sdb2
   1     1       8        2        1      active sync   /dev/sda2

/dev/sda3:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 31b4390a:af5afa82:44c73f24:a2a36931
  Creation Time : Thu Sep 18 13:13:12 2003
     Raid Level : raid1
    Device Size : 17518784 (16.71 GiB 17.94 GB)
   Raid Devices : 2
  Total Devices : 1
Preferred Minor : 0

    Update Time : Mon Sep 22 12:58:40 2003
          State : dirty, no-errors
 Active Devices : 1
Working Devices : 1
 Failed Devices : 0
  Spare Devices : 0
       Checksum : f18a0e32 - correct
         Events : 0.28


      Number   Major   Minor   RaidDevice State
this     1       8        3        1      active sync   /dev/sda3
   0     0       0        0        0      faulty removed
   1     1       8        3        1      active sync   /dev/sda3

/dev/sdb3:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 31b4390a:af5afa82:44c73f24:a2a36931
  Creation Time : Thu Sep 18 13:13:12 2003
     Raid Level : raid1
    Device Size : 17518784 (16.71 GiB 17.94 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 0

    Update Time : Mon Sep 22 09:37:08 2003
          State : dirty, no-errors
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0
       Checksum : f189df80 - correct
         Events : 0.25


      Number   Major   Minor   RaidDevice State
this     0       8       19        0      active sync   /dev/sdb3
   0     0       8       19        0      active sync   /dev/sdb3
   1     1       8        3        1      active sync   /dev/sda3
