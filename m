From: Redeeman <redeeman@metanurb.dk>
Subject: problem in grow of raid5 3 -> 4 disks
Date: Tue, 17 Feb 2009 21:48:11 +0100
Message-ID: <1234903691.18827.21.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello.

A friend of mines array just stalled in the reshape process, while
growing from 3 to 4 disks, on raid5.

kernel is 2.6.27,

dmesg spews insane amounts of:
compute_blocknr: map not correct
compute_blocknr: map not correct
compute_blocknr: map not correct
compute_blocknr: map not correct

/proc/mdstat:
md0 : active raid5 sdd1[3] sdc1[2] sdb1[1] sda1[0]
      1953519872 blocks super 0.91 level 5, 64k chunk, algorithm 2 [4/4]
[UUUU]
      [==============>......]  reshape = 73.2% (715827840/976759936)
finish=15504.9min speed=280K/sec

# mdadm --detail:
/dev/md0:
        Version : 0.91
  Creation Time : Sun Feb  1 03:30:50 2009
     Raid Level : raid5
     Array Size : 1953519872 (1863.02 GiB 2000.40 GB)
  Used Dev Size : 976759936 (931.51 GiB 1000.20 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0
    Persistence : Superblock is persistent
 
    Update Time : Tue Feb 17 23:26:37 2009
          State : clean, recovering
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0
 
         Layout : left-symmetric
     Chunk Size : 64K
 
 Reshape Status : 73% complete
  Delta Devices : 1, (3->4)
 
           UUID : e55b3e10:456492af:b4421a5d:cd497c91
         Events : 0.476018
 
    Number   Major   Minor   RaidDevice State
       0       8        1        0      active sync   /dev/sda1
       1       8       17        1      active sync   /dev/sdb1
       2       8       33        2      active sync   /dev/sdc1
       3       8       49        3      active sync   /dev/sdd1


What should we do about this? Anyone experienced something similar?
SMART reports no errors on any of the disks.

---
Thanks.
Kasper Sandberg

