From: Ross Boylan <ross@biostat.ucsf.edu>
Subject: How do I tell which disk failed?
Date: Mon, 07 Jan 2013 18:05:01 -0800
Message-ID: <1357610701.16366.13.camel@corn.betterworld.us>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: ross@biostat.ucsf.edu
List-Id: linux-raid.ids

I see my array is reconstructing, but I can't tell which disk failed.
Is there a way to?  I tried mdadm --detail on the array, mdadm --examine
on the components, and looking at /proc/mdstat, but none of them give
much of a clue.

Disks have 0.90 metadata; mdadm - v2.6.7.2 - 14th November 2008, 2.6.32
kernel.

The machine (real, not virtual) hung, leaving few clues in the logs.

# cat /proc/mdstat
Personalities : [raid1]
md0 : active raid1 sda1[0] sdc2[2] sdb2[1]
      96256 blocks [3/3] [UUU]

md1 : active raid1 sda3[0] sdc4[2] sdb4[1]
      730523648 blocks [3/3] [UUU]
      [>....................]  resync =  0.4% (3382400/730523648) finish=14164.9min speed=855K/sec

unused devices: <none>

# mdadm --detail /dev/md1
/dev/md1:
        Version : 00.90
  Creation Time : Mon Dec 15 06:50:18 2008
     Raid Level : raid1
     Array Size : 730523648 (696.68 GiB 748.06 GB)
  Used Dev Size : 730523648 (696.68 GiB 748.06 GB)
   Raid Devices : 3
  Total Devices : 3
Preferred Minor : 1
    Persistence : Superblock is persistent

    Update Time : Mon Jan  7 17:17:41 2013
          State : active, resyncing
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0

 Rebuild Status : 0% complete

           UUID : b77027df:d6aa474a:c4290e12:319afc54
         Events : 0.5078497

    Number   Major   Minor   RaidDevice State
       0       8        3        0      active sync   /dev/sda3
       1       8       20        1      active sync   /dev/sdb4
       2       8       36        2      active sync   /dev/sdc4

The system is currently sluggish and the load is 13; I suspect whatever went wrong is happening again.

Thanks.
Ross


