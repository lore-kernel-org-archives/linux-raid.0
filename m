From: "Dragon" <Sunghost@gmx.de>
Subject: Possible to rescue SW Raid5 with 2 missing Disks
Date: Fri, 15 Feb 2013 10:46:49 +0100
Message-ID: <20130215094649.220270@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Dave,

many thx for your help and your explainations. The first step seems to work. Am i right? Therefore the next step is to readd the missing sdd4 (mdadm --add /dev/md2 /dev/sdd4)

mdadm -A /dev/md2 -R /dev/sda4 /dev/sdb4 /dev/sdc4 /dev/sdf4 /dev/sde4
mdadm: /dev/md2 has been started with 5 drives (out of 6).
-------------
output of dmesg
mdadm: sending ioctl 1261 to a partition!
[ 9884.422907] mdadm: sending ioctl 1261 to a partition!
[ 9884.422916] mdadm: sending ioctl 1261 to a partition!
[ 9884.540433] mdadm: sending ioctl 1261 to a partition!
[ 9884.540443] mdadm: sending ioctl 1261 to a partition!
[ 9884.561874] mdadm: sending ioctl 1261 to a partition!
[ 9884.561884] mdadm: sending ioctl 1261 to a partition!
[ 9884.562283] mdadm: sending ioctl 1261 to a partition!
[ 9884.562292] mdadm: sending ioctl 1261 to a partition!
[ 9885.381902] md: md2 stopped.
[ 9885.431051] md: bind<sdb4>
[ 9885.431185] md: bind<sdc4>
[ 9885.436744] md: bind<sdf4>
[ 9885.437110] md: bind<sde4>
[ 9885.437415] md: bind<sda4>
[ 9885.518260] raid5: device sda4 operational as raid disk 0
[ 9885.518264] raid5: device sde4 operational as raid disk 4
[ 9885.518266] raid5: device sdf4 operational as raid disk 3
[ 9885.518267] raid5: device sdc4 operational as raid disk 2
[ 9885.518269] raid5: device sdb4 operational as raid disk 1
[ 9885.518644] raid5: allocated 6386kB for md2
[ 9885.518843] 0: w=1 pa=0 pr=6 m=1 a=2 r=6 op1=0 op2=0
[ 9885.518847] 4: w=2 pa=0 pr=6 m=1 a=2 r=6 op1=0 op2=0
[ 9885.518849] 3: w=3 pa=0 pr=6 m=1 a=2 r=6 op1=0 op2=0
[ 9885.518851] 2: w=4 pa=0 pr=6 m=1 a=2 r=6 op1=0 op2=0
[ 9885.518853] 1: w=5 pa=0 pr=6 m=1 a=2 r=6 op1=0 op2=0
[ 9885.518855] raid5: raid level 5 set md2 active with 5 out of 6 devices, algorithm 2
[ 9885.518871] RAID5 conf printout:
[ 9885.518872]  --- rd:6 wd:5
[ 9885.518874]  disk 0, o:1, dev:sda4
[ 9885.518876]  disk 1, o:1, dev:sdb4
[ 9885.518877]  disk 2, o:1, dev:sdc4
[ 9885.518879]  disk 3, o:1, dev:sdf4
[ 9885.518880]  disk 4, o:1, dev:sde4
[ 9885.518894] md2: Warning: Device sde4 is misaligned
[ 9885.518896] md2: Warning: Device sdf4 is misaligned
[ 9885.518920] md2: detected capacity change from 0 to 14957451673600
[ 9885.520484]  md2: unknown partition table
---
mdadm -D /dev/md2 
/dev/md2:
        Version : 1.2
  Creation Time : Tue Feb  5 17:44:45 2013
     Raid Level : raid5
     Array Size : 14606886400 (13930.21 GiB 14957.45 GB)
  Used Dev Size : 2921377280 (2786.04 GiB 2991.49 GB)
   Raid Devices : 6
  Total Devices : 5
    Persistence : Superblock is persistent

    Update Time : Tue Feb  5 17:44:45 2013
          State : clean, degraded
 Active Devices : 5
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 512K

           Name : mfsnode1:2  (local to host mfsnode1)
           UUID : e84f0346:3f5ff3f1:507b6f9c:0fa02c63
         Events : 0

    Number   Major   Minor   RaidDevice State
       0       8        4        0      active sync   /dev/sda4
       1       8       20        1      active sync   /dev/sdb4
       2       8       36        2      active sync   /dev/sdc4
       3       8       84        3      active sync   /dev/sdf4
       4       8       68        4      active sync   /dev/sde4
       5       0        0        5      removed
-----
