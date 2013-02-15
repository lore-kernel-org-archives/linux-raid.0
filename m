From: "Dragon" <Sunghost@gmx.de>
Subject: Possible to rescue SW Raid5 with 2 missing Disks
Date: Fri, 15 Feb 2013 16:41:20 +0100
Message-ID: <20130215154120.95960@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,
ok your absolutely right. i searched to logfiles in var/log but found nothing about superblock. but as i wrote i worked with phil at this problem and in my outputbox i found an email with information before this:

Here the output oft Option "-D"
--------------------------------------------------------------
mdadm -D /dev/md2
/dev/md2:
        Version : 1.2
  Creation Time : Tue Jul 24 18:18:21 2012
     Raid Level : raid5
  Used Dev Size : -1
   Raid Devices : 6
  Total Devices : 4
    Persistence : Superblock is persistent

    Update Time : Mon Dec 17 00:13:56 2012
          State : active, FAILED, Not Started
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 512K

           Name : mfsnode1:2  (local to host mfsnode1)
           UUID : 92a99ca0:8e22bc66:f8050881:78c344d9
         Events : 211768

    Number   Major   Minor   RaidDevice State
       0       8        4        0      active sync   /dev/sda4
       1       8       20        1      active sync   /dev/sdb4
       2       8       36        2      active sync   /dev/sdc4
       3       0        0        3      removed
       4       8       68        4      active sync   /dev/sde4
       5       0        0        5      removed
--------------------------------------------------------------
mdadm -E /dev/sda4
/dev/sda4:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 92a99ca0:8e22bc66:f8050881:78c344d9
           Name : mfsnode1:2  (local to host mfsnode1)
  Creation Time : Tue Jul 24 18:18:21 2012
     Raid Level : raid5
   Raid Devices : 6

 Avail Dev Size : 5842757597 (2786.04 GiB 2991.49 GB)
     Array Size : 29213783040 (13930.22 GiB 14957.46 GB)
  Used Dev Size : 5842756608 (2786.04 GiB 2991.49 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 6a679a1d:f42d6b9f:a13cd977:0fdbea86

    Update Time : Mon Dec 17 00:13:56 2012
       Checksum : 8c50873e - correct
         Events : 211768

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : AAA.A. ('A' == active, '.' == missing)
--------------------------------------------------------------
mdadm -E /dev/sdb4
/dev/sdb4:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 92a99ca0:8e22bc66:f8050881:78c344d9
           Name : mfsnode1:2  (local to host mfsnode1)
  Creation Time : Tue Jul 24 18:18:21 2012
     Raid Level : raid5
   Raid Devices : 6

 Avail Dev Size : 5842757597 (2786.04 GiB 2991.49 GB)
     Array Size : 29213783040 (13930.22 GiB 14957.46 GB)
  Used Dev Size : 5842756608 (2786.04 GiB 2991.49 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 099f7aa0:9f7a0802:2a874b3a:259431c6

    Update Time : Mon Dec 17 00:13:56 2012
       Checksum : 73870f28 - correct
         Events : 211768

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 1
   Array State : AAA.A. ('A' == active, '.' == missing)
--------------------------------------------------------------
mdadm -E /dev/sdc4
/dev/sdc4:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 92a99ca0:8e22bc66:f8050881:78c344d9
           Name : mfsnode1:2  (local to host mfsnode1)
  Creation Time : Tue Jul 24 18:18:21 2012
     Raid Level : raid5
   Raid Devices : 6

 Avail Dev Size : 5842757597 (2786.04 GiB 2991.49 GB)
     Array Size : 29213783040 (13930.22 GiB 14957.46 GB)
  Used Dev Size : 5842756608 (2786.04 GiB 2991.49 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 41f58710:f1658674:4980a5ae:a9c674b3

    Update Time : Mon Dec 17 00:13:56 2012
       Checksum : b7af7c56 - correct
         Events : 211768

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 2
   Array State : AAA.A. ('A' == active, '.' == missing)
--------------------------------------------------------------
mdadm -E /dev/sdd4
/dev/sdd4:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 92a99ca0:8e22bc66:f8050881:78c344d9
           Name : mfsnode1:2  (local to host mfsnode1)
  Creation Time : Tue Jul 24 18:18:21 2012
     Raid Level : raid5
   Raid Devices : 6

 Avail Dev Size : 5842757597 (2786.04 GiB 2991.49 GB)
     Array Size : 29213783040 (13930.22 GiB 14957.46 GB)
  Used Dev Size : 5842756608 (2786.04 GiB 2991.49 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 53e3bb36:58d746d3:52012491:f518b985

    Update Time : Mon Dec 17 00:13:56 2012
       Checksum : f16373f1 - correct
         Events : 0

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : spare
   Array State : AAA.A. ('A' == active, '.' == missing)
--------------------------------------------------------------
mdadm -E /dev/sde4
/dev/sde4:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 92a99ca0:8e22bc66:f8050881:78c344d9
           Name : mfsnode1:2  (local to host mfsnode1)
  Creation Time : Tue Jul 24 18:18:21 2012
     Raid Level : raid5
   Raid Devices : 6

 Avail Dev Size : 5842756608 (2786.04 GiB 2991.49 GB)
     Array Size : 29213783040 (13930.22 GiB 14957.46 GB)
    Data Offset : 1024 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 570b6ed0:9be27d23:6db489de:9c5ddf30

    Update Time : Mon Dec 17 00:13:56 2012
       Checksum : d3dbd252 - correct
         Events : 211768

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 4
   Array State : AAA.A. ('A' == active, '.' == missing)
--------------------------------------------------------------
mdadm -E /dev/sdf4
/dev/sdf4:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 92a99ca0:8e22bc66:f8050881:78c344d9
           Name : mfsnode1:2  (local to host mfsnode1)
  Creation Time : Tue Jul 24 18:18:21 2012
     Raid Level : raid5
   Raid Devices : 6

 Avail Dev Size : 5842756608 (2786.04 GiB 2991.49 GB)
     Array Size : 29213783040 (13930.22 GiB 14957.46 GB)
    Data Offset : 1024 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 3718659d:78d3c607:69c0d241:009a0ef6

    Update Time : Mon Dec 17 00:13:56 2012
       Checksum : ad90dd3a - correct
         Events : 0

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : spare
   Array State : AAA.A. ('A' == active, '.' == missing)
--------------------------------------------------------------
cat /proc/mdstat
Personalities : [raid1] [raid6] [raid5] [raid4]
md2 : inactive sda4[0] sde4[4] sdc4[2] sdb4[1]
      11685514699 blocks super 1.2

md1 : active (auto-read-only) raid5 sda3[0] sdf3[5] sde3[4] sdd3[3]
sdc3[2] sdb3[1]
      4881920 blocks super 1.2 level 5, 512k chunk, algorithm 2 [6/6]
[UUUUUU]

md0 : active raid1 sda2[0] sdf2[5] sde2[4] sdd2[3] sdc2[2] sdb2[1]
      7811464 blocks super 1.2 [6/6] [UUUUUU]

unused devices: <none>
--------------------------------------------------------------
dmesg |grep md2
[    2.497112] md: md2 stopped.
[    2.522264] raid5: allocated 6386kB for md2
[    2.522456] raid5: not enough operational devices for md2 (2/6 failed)
[    2.522780] raid5: failed to run raid set md2
--------------------------------------------------------------
dmesg |grep sd[a,b,c,d,e,f]4
[    1.183060]  sdf: sdd1 sdd2 sdd3 sdd4
[    1.211480]  sdc1 sdc2 sdc3 sdc4
[    1.212753]  sda1 sda2 sda3 sda4
[    1.214156]  sdb1 sdb2 sdb3 sdb4
[    1.221997]  sdf1 sdf2 sdf3 sdf4
[    1.249067]  sde1 sde2 sde3 sde4
[    2.502642] md: bind<sdb4>
[    2.505288] md: bind<sdc4>
[    2.505426] md: bind<sde4>
[    2.505521] md: bind<sdf4>
[    2.505613] md: export_rdev(sdd4)
[    2.505823] md: bind<sda4>
[    2.505884] md: kicking non-fresh sdf4 from array!
[    2.505898] md: unbind<sdf4>
[    2.520389] md: export_rdev(sdf4)
[    2.521897] raid5: device sda4 operational as raid disk 0
[    2.521900] raid5: device sde4 operational as raid disk 4
[    2.521902] raid5: device sdc4 operational as raid disk 2
[    2.521904] raid5: device sdb4 operational as raid disk 1
[    2.522510]  disk 0, o:1, dev:sda4
[    2.522512]  disk 1, o:1, dev:sdb4
[    2.522513]  disk 2, o:1, dev:sdc4
[    2.522515]  disk 4, o:1, dev:sde4
------------------------------------------------

behaps this could bring light in the dark
