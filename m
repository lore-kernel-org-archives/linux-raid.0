From: raid@ddx.a2000.nu
Subject: mdadm -D shows incorrect working devices ?
Date: Tue, 17 Dec 2002 22:22:11 +0100 (CET)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.50.0212172214130.25725-100000@ddx.a2000.nu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

after a failure i recovered using mdadm -A :

mdadm -A /dev/md0  --force /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1
/dev/sdf1 /dev/sdg1 /dev/sdh1

i still miss one device in my raid5 (will be there tomorrow)

/proc/mdstat show me :

md0 : active raid5 sdh1[6] sdg1[5] sdf1[4] sde1[3] sdd1[2] sdc1[1] sdb1[0]
      820527232 blocks level 5, 64k chunk, algorithm 0 [8/7] [UUUUUUU_]

but mdadm -D /dev/md0 show me incorrect info
look at the ammount of working devices/failed devices

/dev/md0:
        Version : 00.90.00
  Creation Time : Fri Oct 18 23:11:09 2002
     Raid Level : raid5
     Array Size : 820527232 (782.51 GiB 840.21 GB)
    Device Size : 117218176 (111.78 GiB 120.03 GB)
   Raid Devices : 8
  Total Devices : 8
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Tue Dec 17 22:12:24 2002
          State : dirty, no-errors
 Active Devices : 7
Working Devices : 6
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
       5       8       97        5      active sync   /dev/sdg1
       6       8      113        6      active sync   /dev/sdh1
       7       0        0        7      faulty
           UUID : 316793d2:5e51db22:3607b944:6aeb5e01

7 devices active/6 working/2 failed ??
but only 1 is failed ?

i restarted about 5 times after recoveringing using mdadm -A
(reboot, so this info should be updated already...)

kernel 2.4.20
mdadm v1.0.1
