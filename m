From: "Andrew Herdman" <andrew@whine.com>
Subject: RAID1: Disks alternating on reads
Date: Sun, 21 Sep 2003 11:14:11 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <014b01c38053$0358ad90$0180a8c0@what>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Pardon me if my assumption was incorrect, but I was under the belief that
when using software RAID1, that when reads occurred on the RAID device that
it would read from both drives in a striped fashion similar to how RAID0
works to improve the speed of the md devices.   I am actually seeing this,
but it appears that the reads on each drive are continuing for 10 to 20
seconds before moving onto the next drive and then another 10-20 seconds and
back again.  This is not allowing for any performance increase, it just lets
the drives rest alternately.

This link http://www.whine.com/~andrew/alternating_disk.png is a gkrellm
snapshot of the activity, hda and hde are the two disks in the RAID array.
Each disk is the master on it's own channel.

I also included the mdadm --query --detail info below for each RAID
partition

how:~# mdadm --query --detail /dev/md/1
/dev/md/1:
        Version : 00.90.00
  Creation Time : Sat Jul 19 08:30:42 2003
     Raid Level : raid1
     Array Size : 62400 (60.94 MiB 63.90 MB)
    Device Size : 62400 (60.94 MiB 63.90 MB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 1
    Persistence : Superblock is persistent

    Update Time : Mon Sep 15 08:41:38 2003
          State : dirty, no-errors
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0


    Number   Major   Minor   RaidDevice State
       0       3        1        0      active sync
/dev/ide/host0/bus0/target0/lun0/part1
       1      33        1        1      active sync
/dev/ide/host2/bus0/target0/lun0/part1
           UUID : faa4b7b2:4832fae8:ac2fa294:2fce1d85
         Events : 0.38

how:~# mdadm --query --detail /dev/md/2
/dev/md/2:
        Version : 00.90.00
  Creation Time : Sat Jul 19 08:32:18 2003
     Raid Level : raid1
     Array Size : 119140544 (113.62 GiB 121.100 GB)
    Device Size : 119140544 (113.62 GiB 121.100 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 2
    Persistence : Superblock is persistent

    Update Time : Mon Sep 15 08:41:38 2003
          State : dirty, no-errors
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0


    Number   Major   Minor   RaidDevice State
       0       3        2        0      active sync
/dev/ide/host0/bus0/target0/lun0/part2
       1      33        2        1      active sync
/dev/ide/host2/bus0/target0/lun0/part2
           UUID : 0ad35f02:56a32094:c8301e3e:45895c16
         Events : 0.38

how:~# mdadm --query --detail /dev/md/3
/dev/md/3:
        Version : 00.90.00
  Creation Time : Sat Jul 19 08:31:37 2003
     Raid Level : raid1
     Array Size : 499904 (488.19 MiB 511.90 MB)
    Device Size : 499904 (488.19 MiB 511.90 MB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 3
    Persistence : Superblock is persistent

    Update Time : Mon Sep 15 08:41:38 2003
          State : dirty, no-errors
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0


    Number   Major   Minor   RaidDevice State
       0       3        3        0      active sync
/dev/ide/host0/bus0/target0/lun0/part3
       1      33        3        1      active sync
/dev/ide/host2/bus0/target0/lun0/part3
           UUID : f8b2d95b:93055c43:d78427ac:197a610f
         Events : 0.38

how:~# df -h
Filesystem            Size  Used Avail Use% Mounted on
/dev/md/2             112G   94G   16G  86% /
/dev/md/1              60M   16M   42M  28% /boot

Have I configured something incorrectly?  Or is this really the way RAID1
works?

Thanks
 Andrew
--
Andrew Herdman
andrew@whine.com - Primary E-Mail

