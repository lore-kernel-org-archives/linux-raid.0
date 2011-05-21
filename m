From: Pol Hallen <raid1@fuckaround.org>
Subject: Performarce raid6 degraded
Date: Sat, 21 May 2011 13:16:18 +0200
Message-ID: <201105211316.18565.raid1@fuckaround.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi folks, after fail of a disk on my raid6 sw I check with dd the performance 
of raid:

dd if=/dev/zero of=degradedraid bs=1000024 count=100
100+0 records in
100+0 records out
100002400 bytes (100 MB) copied, 288.254 s, 347 kB/s

is it correct? only 347Kb/s on a raid6 degraded?

mdadm --detail /dev/md0
/dev/md0:
        Version : 0.90
  Creation Time : Mon Sep 27 14:19:15 2010
     Raid Level : raid6
     Array Size : 5860543744 (5589.05 GiB 6001.20 GB)
  Used Dev Size : 1465135936 (1397.26 GiB 1500.30 GB)
   Raid Devices : 6
  Total Devices : 7
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Sat May 21 13:14:43 2011
          State : active, degraded
 Active Devices : 5
Working Devices : 5
 Failed Devices : 2
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

           UUID : 9bd6372e:e2eab1d5:d2bdc3cb:ad12f41d
         Events : 0.385693

    Number   Major   Minor   RaidDevice State
       0       8        1        0      active sync   /dev/sda1
       1       8       17        1      active sync   /dev/sdb1
       2       0        0        2      removed
       3       8       81        3      active sync   /dev/sdf1
       4       8       65        4      active sync   /dev/sde1
       5       8       49        5      active sync   /dev/sdd1

       6       8      145        -      faulty spare
       7       8       33        -      faulty spare

thanks!
 
Pol
