From: Simon <simon.xhz@gmail.com>
Subject: The array is functioning normally (?)
Date: Wed, 04 Jul 2007 21:38:59 -0400
Message-ID: <468C4BB3.3020400@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I made the 3 devices faulty.  I wonder why it's still clean and --test says it's 
functionning normally?!

Thanks for any info!
Simon

===(`/sbin/mdadm -v -v --detail /dev/md1`)======================================
/dev/md1:
         Version : 00.90.03
   Creation Time : Tue Jul  3 16:29:38 2007
      Raid Level : raid5
      Array Size : 2011648 (1964.83 MiB 2059.93 MB)
   Used Dev Size : 1005824 (982.41 MiB 1029.96 MB)
    Raid Devices : 3
   Total Devices : 3
Preferred Minor : 1
     Persistence : Superblock is persistent

     Update Time : Wed Jul  4 19:43:37 2007
           State : clean, degraded
  Active Devices : 0
Working Devices : 0
  Failed Devices : 3
   Spare Devices : 0

          Layout : left-symmetric
      Chunk Size : 64K

     Number   Major   Minor   RaidDevice State
        0       0        0        0      removed
        1       0        0        1      removed
        2       0        0        2      removed

        3       8       50        -      faulty spare   /dev/sdd2
        4       8       18        -      faulty spare   /dev/sdb2
        5       8       34        -      faulty spare   /dev/sdc2
-------------------------  Return was: 0  ---[ 0 = running | 256 = inactive ]---
===(`/sbin/lsraid -a /dev/md1`)=================================================
[dev   9,   1] /dev/md1         00000000.00000000.00000000.00000000 online
[dev   ?,   ?] (unknown)        00000000.00000000.00000000.00000000 missing
[dev   ?,   ?] (unknown)        00000000.00000000.00000000.00000000 missing
[dev   ?,   ?] (unknown)        00000000.00000000.00000000.00000000 missing

------------------------------------------------------------  Return was: 0  ---
Return from `/sbin/mdadm /dev/md1 --detail --test` gave:
mdadm: The array is functioning normally.
================================================================================
