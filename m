From: Ross Boylan <ross@biostat.ucsf.edu>
Subject: mdadm --fail doesn't mark device as failed?
Date: Wed, 21 Nov 2012 08:17:57 -0800
Message-ID: <1353514677.5795.14.camel@corn.betterworld.us>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: ross@biostat.ucsf.edu
List-Id: linux-raid.ids

After I failed and removed a partition, mdadm --examine seems to show
that partition is fine.

Perhaps related to this, I failed a partition and when I rebooted it
came up as the sole member of its RAID array.

Is this behavior expected?  Is there a way to make the failures more
convincing?

The drive sdb in the following excerpt does appear to be experiencing
hardware problems.  However, the failed partition that became the md on
reboot was on a drive without any reported problems.

<terminal>
markov:/# date; mdadm --examine -v /dev/sdb1
Wed Nov 21 07:56:32 PST 2012
/dev/sdb1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 313d5489:7869305b:c4290e12:319afc54
  Creation Time : Mon Dec 15 06:49:51 2008
     Raid Level : raid1
  Used Dev Size : 96256 (94.02 MiB 98.57 MB)
     Array Size : 96256 (94.02 MiB 98.57 MB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 0

    Update Time : Wed Nov 21 07:37:14 2012
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0
       Checksum : e28ac7f6 - correct
         Events : 1696


      Number   Major   Minor   RaidDevice State
this     1       8       17        1      active sync   /dev/sdb1

   0     0       8        1        0      active sync   /dev/sda1
   1     1       8       17        1      active sync   /dev/sdb1
markov:/# mdadm --fail /dev/md1 /dev/sdb3
mdadm: set /dev/sdb3 faulty in /dev/md1
markov:/# mdadm --fail /dev/md0 /dev/sdb1
mdadm: set /dev/sdb1 faulty in /dev/md0
markov:/# mdadm --remove /dev/md0 /dev/sdb1
mdadm: hot removed /dev/sdb1
markov:/# mdadm --remove /dev/md1 /dev/sdb3
mdadm: hot removed /dev/sdb3
markov:/# date; mdadm --examine -v /dev/sdb3
Wed Nov 21 07:57:54 PST 2012
/dev/sdb3:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : b77027df:d6aa474a:c4290e12:319afc54
  Creation Time : Mon Dec 15 06:50:18 2008
     Raid Level : raid1
 Used Dev Size : 730523648 (696.68 GiB 748.06 GB)
     Array Size : 730523648 (696.68 GiB 748.06 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 1

    Update Time : Wed Nov 21 07:56:44 2012
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0
       Checksum : f322bc10 - correct
         Events : 5067056


      Number   Major   Minor   RaidDevice State
this     1       8       19        1      active sync   /dev/sdb3

   0     0       8        3        0      active sync   /dev/sda3
   1     1       8       19        1      active sync   /dev/sdb3
markov:/# mdadm -Q /dev/md0
/dev/md0: 94.00MiB raid1 2 devices, 0 spares. Use mdadm --detail for more detail.
markov:/# date; mdadm --detail /dev/md0
Wed Nov 21 07:58:56 PST 2012
/dev/md0:
        Version : 00.90
  Creation Time : Mon Dec 15 06:49:51 2008
     Raid Level : raid1
     Array Size : 96256 (94.02 MiB 98.57 MB)
  Used Dev Size : 96256 (94.02 MiB 98.57 MB)
   Raid Devices : 2
  Total Devices : 1
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Wed Nov 21 07:57:35 2012
          State : clean, degraded
 Active Devices : 1
Working Devices : 1
 Failed Devices : 0
  Spare Devices : 0

           UUID : 313d5489:7869305b:c4290e12:319afc54
         Events : 0.1700

    Number   Major   Minor   RaidDevice State
       0       8        1        0      active sync   /dev/sda1
       1       0        0        1      removed
markov:/# mdadm --grow /dev/md0 -n 1 --force
</terminal>


