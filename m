From: Ian Pilcher <arequipeno@gmail.com>
Subject: Array member "role numbers" in /proc/mdstat
Date: Mon, 23 Sep 2013 11:21:13 -0500
Message-ID: <52406A79.4030808@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

https://raid.wiki.kernel.org/index.php/Mdstat says that the number
shown in square brackets after each component device is the role number,
but this does not appear to be true (at least not always):

[root@c6 ~]# mdadm -C /dev/md0 -l 5 -n 3 -x 1 /dev/sd[bcde]
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md0 started.

[root@c6 ~]# cat /proc/mdstat
Personalities : [raid1] [raid6] [raid5] [raid4] [raid10]
md0 : active raid5 sdd[4] sde[3](S) sdc[1] sdb[0]
      4191232 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/3] [UUU]

[root@c6 ~]# mdadm --detail /dev/md0
/dev/md0:
        Version : 1.2
  Creation Time : Mon Sep 23 10:54:59 2013
     Raid Level : raid5
     Array Size : 4191232 (4.00 GiB 4.29 GB)
  Used Dev Size : 2095616 (2046.84 MiB 2145.91 MB)
   Raid Devices : 3
  Total Devices : 4
    Persistence : Superblock is persistent

    Update Time : Mon Sep 23 10:56:13 2013
          State : clean
 Active Devices : 3
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 1

         Layout : left-symmetric
     Chunk Size : 512K

           Name : c6.penurio.us:0  (local to host c6.penurio.us)
           UUID : 17b42cb3:691ea02a:1d9822a1:6be0b398
         Events : 18

    Number   Major   Minor   RaidDevice State
       0       8       16        0      active sync   /dev/sdb
       1       8       32        1      active sync   /dev/sdc
       4       8       48        2      active sync   /dev/sdd

       3       8       64        -      spare   /dev/sde

Doc bug?

-- 
========================================================================
Ian Pilcher                                         arequipeno@gmail.com
Sometimes there's nothing left to do but crash and burn...or die trying.
========================================================================
