From: "James H. Edwards" <jedwards@nmcourts.com>
Subject: Help with dirty RAID array
Date: Thu, 15 Jun 2006 11:06:17 -0600
Message-ID: <1150391177.16155.164.camel@homer.nmcourts.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a RAID 1 and RAID 5 array on a mail server. It panic rebooted and
now the arrays will not start cleaning. I have run xfs_repair on both
arrays Each array flip flops from indicating it is dirty and then clean.
I do not see the resync process running, which I am used to seeing when
a a box is not shutdown correctly. Here is the output of  mdadm -QD for
both arrays showing clean and dirty state, what do I need to do the
clean these arrays ? 

MD0 Array:


[root@jidmail bin]# mdadm -QD /dev/md0
/dev/md0:
        Version : 00.90.01
  Creation Time : Mon Nov 22 06:11:32 2004
     Raid Level : raid1
     Array Size : 71681920 (68.36 GiB 73.40 GB)
    Device Size : 71681920 (68.36 GiB 73.40 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Thu Jun 15 11:00:28 2006
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0


    Number   Major   Minor   RaidDevice State
       0       8      241        0      active sync   /dev/sdp1
       1      65        1        1      active sync   /dev/sdq1
           UUID : 2f4cbf03:cd1ddc43:ef9965aa:3d51f6f2
         Events : 0.47732796


[root@jidmail bin]# mdadm -QD /dev/md0
/dev/md0:
        Version : 00.90.01
  Creation Time : Mon Nov 22 06:11:32 2004
     Raid Level : raid1
     Array Size : 71681920 (68.36 GiB 73.40 GB)
    Device Size : 71681920 (68.36 GiB 73.40 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Thu Jun 15 11:00:29 2006
          State : dirty
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0


    Number   Major   Minor   RaidDevice State
       0       8      241        0      active sync   /dev/sdp1
       1      65        1        1      active sync   /dev/sdq1
           UUID : 2f4cbf03:cd1ddc43:ef9965aa:3d51f6f2
         Events : 0.47732797
[root@jidmail bin]#



MD1 Array:

[root@jidmail bin]# mdadm -QD /dev/md1
/dev/md1:
        Version : 00.90.01
  Creation Time : Mon Nov 22 06:11:19 2004
     Raid Level : raid5
     Array Size : 1577091648 (1504.03 GiB 1614.94 GB)
    Device Size : 143371968 (136.73 GiB 146.81 GB)
   Raid Devices : 12
  Total Devices : 14
Preferred Minor : 1
    Persistence : Superblock is persistent

    Update Time : Thu Jun 15 11:04:29 2006
          State : dirty
 Active Devices : 12
Working Devices : 14
 Failed Devices : 0
  Spare Devices : 2

         Layout : left-asymmetric
     Chunk Size : 64K

    Number   Major   Minor   RaidDevice State
       0       8       33        0      active sync   /dev/sdc1
       1       8       49        1      active sync   /dev/sdd1
       2       8       65        2      active sync   /dev/sde1
       3       8       81        3      active sync   /dev/sdf1
       4       8       97        4      active sync   /dev/sdg1
       5       8      113        5      active sync   /dev/sdh1
       6       8      129        6      active sync   /dev/sdi1
       7       8      145        7      active sync   /dev/sdj1
       8       8      161        8      active sync   /dev/sdk1
       9       8      177        9      active sync   /dev/sdl1
      10       8      193       10      active sync   /dev/sdm1
      11       8      209       11      active sync   /dev/sdn1
      12      65       17       -1      spare   /dev/sdr1
      13       8      225       -1      spare   /dev/sdo1
           UUID : 478195d2:df1da7b0:fbaa9190:6c2a0348
         Events : 0.47810358
[root@jidmail bin]# mdadm -QD /dev/md1
/dev/md1:
        Version : 00.90.01
  Creation Time : Mon Nov 22 06:11:19 2004
     Raid Level : raid5
     Array Size : 1577091648 (1504.03 GiB 1614.94 GB)
    Device Size : 143371968 (136.73 GiB 146.81 GB)
   Raid Devices : 12
  Total Devices : 14
Preferred Minor : 1
    Persistence : Superblock is persistent

    Update Time : Thu Jun 15 11:04:31 2006
          State : dirty
 Active Devices : 12
Working Devices : 14
 Failed Devices : 0
  Spare Devices : 2

         Layout : left-asymmetric
     Chunk Size : 64K

    Number   Major   Minor   RaidDevice State
       0       8       33        0      active sync   /dev/sdc1
       1       8       49        1      active sync   /dev/sdd1
       2       8       65        2      active sync   /dev/sde1
       3       8       81        3      active sync   /dev/sdf1
       4       8       97        4      active sync   /dev/sdg1
       5       8      113        5      active sync   /dev/sdh1
       6       8      129        6      active sync   /dev/sdi1
       7       8      145        7      active sync   /dev/sdj1
       8       8      161        8      active sync   /dev/sdk1
       9       8      177        9      active sync   /dev/sdl1
      10       8      193       10      active sync   /dev/sdm1
      11       8      209       11      active sync   /dev/sdn1
      12      65       17       -1      spare   /dev/sdr1
      13       8      225       -1      spare   /dev/sdo1
           UUID : 478195d2:df1da7b0:fbaa9190:6c2a0348
         Events : 0.47810372


[root@jidmail bin]# mdadm -QD /dev/md1
/dev/md1:
        Version : 00.90.01
  Creation Time : Mon Nov 22 06:11:19 2004
     Raid Level : raid5
     Array Size : 1577091648 (1504.03 GiB 1614.94 GB)
    Device Size : 143371968 (136.73 GiB 146.81 GB)
   Raid Devices : 12
  Total Devices : 14
Preferred Minor : 1
    Persistence : Superblock is persistent

    Update Time : Thu Jun 15 11:04:33 2006
          State : clean
 Active Devices : 12
Working Devices : 14
 Failed Devices : 0
  Spare Devices : 2

         Layout : left-asymmetric
     Chunk Size : 64K

    Number   Major   Minor   RaidDevice State
       0       8       33        0      active sync   /dev/sdc1
       1       8       49        1      active sync   /dev/sdd1
       2       8       65        2      active sync   /dev/sde1
       3       8       81        3      active sync   /dev/sdf1
       4       8       97        4      active sync   /dev/sdg1
       5       8      113        5      active sync   /dev/sdh1
       6       8      129        6      active sync   /dev/sdi1
       7       8      145        7      active sync   /dev/sdj1
       8       8      161        8      active sync   /dev/sdk1
       9       8      177        9      active sync   /dev/sdl1
      10       8      193       10      active sync   /dev/sdm1
      11       8      209       11      active sync   /dev/sdn1
      12      65       17       -1      spare   /dev/sdr1
      13       8      225       -1      spare   /dev/sdo1
           UUID : 478195d2:df1da7b0:fbaa9190:6c2a0348
         Events : 0.47810379
[root@jidmail bin]#





