From: raid@ddx.a2000.nu
Subject: Re: mdadm -D shows incorrect working devices ?
Date: Wed, 18 Dec 2002 21:57:02 +0100 (CET)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.50.0212182153120.4838-100000@ddx.a2000.nu>
References: <Pine.LNX.4.50.0212172214130.25725-100000@ddx.a2000.nu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.50.0212172214130.25725-100000@ddx.a2000.nu>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Today rebuiled raid5 (8/8 disks)
mdadm -D is still showing incorrect info
(9 devices total/8 active/7 working/2 failed)
can someone explain this ?

]# cat /proc/mdstat
Personalities : [raid0] [raid5]
read_ahead 1024 sectors
md0 : active raid5 sdg1[7] sdb1[0] sdi1[6] sdh1[5] sdf1[4] sde1[3] sdd1[2]
sdc1[1]
      820527232 blocks level 5, 64k chunk, algorithm 0 [8/8] [UUUUUUUU]

unused devices: <none>

]# mdadm -D /dev/md0
/dev/md0:
        Version : 00.90.00
  Creation Time : Fri Oct 18 23:11:09 2002
     Raid Level : raid5
     Array Size : 820527232 (782.51 GiB 840.21 GB)
    Device Size : 117218176 (111.78 GiB 120.03 GB)
   Raid Devices : 8
  Total Devices : 9
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Wed Dec 18 21:50:43 2002
          State : dirty, no-errors
 Active Devices : 8
Working Devices : 7
 Failed Devices : 2
  Spare Devices : 0

         Layout : left-asymmetric
     Chunk Size : 64K

    Number   Major   Minor   RaidDevice State
       0       8       17        0      active sync   /dev/sdb1
       1       8       33        1      active sync   /dev/sdc1
       2       8       49        2      active sync   /dev/sdd1
       3       8       65        3      active sync   /dev/sde1
       4       8       81        4      active sync   /dev/sdf1
       5       8      113        5      active sync   /dev/sdh1
       6       8      129        6      active sync   /dev/sdi1
       7       8       97        7      active sync   /dev/sdg1
           UUID : 316793d2:5e51db22:3607b944:6aeb5e01

