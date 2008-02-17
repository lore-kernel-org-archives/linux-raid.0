From: Sevrin Robstad <quackyo@start.no>
Subject: Create Raid6 with 1 missing member fails
Date: Sun, 17 Feb 2008 13:37:56 +0100
Message-ID: <47B82AA4.10402@start.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I tried to create a raid6 with one missing member, but it fails.
It works fine to create a raid6 with two missing members. Is it supposed 
to be like that ?

mdadm -C /dev/md0 -n5 -l6 -c256 /dev/sd[bcde]1 missing
raid5: failed to run raid set md0
mdadm: RUN_ARRAY failed: Input/output error
mdadm: stopped /dev/md0

mdadm --version
mdadm - v2.6.4 - 19th October 2007
uname -a
Linux compaq2.lan 2.6.23.15-137.fc8 #1 SMP Sun Feb 10 17:03:13 EST 2008 
x86_64 x86_64 x86_64 GNU/Linux

mdadm --examine /dev/sdb1
/dev/sdb1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : e4147673:e22e02ac:09e8c875:b3e364c1
  Creation Time : Sun Feb 17 14:31:55 2008
     Raid Level : raid6
  Used Dev Size : 488295424 (465.67 GiB 500.01 GB)
     Array Size : 1464886272 (1397.02 GiB 1500.04 GB)
   Raid Devices : 5
  Total Devices : 5
Preferred Minor : 0

    Update Time : Sun Feb 17 14:31:55 2008
          State : active
 Active Devices : 4
Working Devices : 4
 Failed Devices : 1
  Spare Devices : 0
       Checksum : d9c93170 - correct
         Events : 0.1

     Chunk Size : 256K

      Number   Major   Minor   RaidDevice State
this     0       8       17        0      active sync   /dev/sdb1

   0     0       8       17        0      active sync   /dev/sdb1
   1     1       8       33        1      active sync   /dev/sdc1
   2     2       8       49        2      active sync   /dev/sdd1
   3     3       8       65        3      active sync   /dev/sde1
   4     4       0        0        4      faulty

