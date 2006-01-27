From: Stephan van Hienen <raid@a2000.nu>
Subject: mdadm 2.2 segmentation fault
Date: Fri, 27 Jan 2006 14:12:16 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0601271406410.30850@adsl.a2000.nu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

when i try to start my raid with mdadm 2.2 it gives a segfault :

]# mdadm  -A /dev/md0
Segmentation fault

and dmesg shows :
md: md0 stopped.

mdadm 1.12 shows :

]# mdadm  -A /dev/md0
mdadm: /dev/md0 has been started with 15 drives.

after i start the md0 with mdadm 1.12, it looks like 2.2 is working ok :

]# mdadm  -D /dev/md0
/dev/md0:
         Version : 00.90.03
   Creation Time : Wed Dec  1 16:38:32 2004
      Raid Level : raid5
      Array Size : 2461523456 (2347.49 GiB 2520.60 GB)
     Device Size : 175823104 (167.68 GiB 180.04 GB)
    Raid Devices : 15
   Total Devices : 15
Preferred Minor : 0
     Persistence : Superblock is persistent

     Update Time : Fri Jan 27 14:06:15 2006
           State : clean
  Active Devices : 15
Working Devices : 15
  Failed Devices : 0
   Spare Devices : 0

          Layout : left-symmetric
      Chunk Size : 256K

            UUID : 784fce06:6999eec1:ad90674e:e415169f
          Events : 0.3082763

     Number   Major   Minor   RaidDevice State
        0       8       49        0      active sync   /dev/sdd1
        1       8       33        1      active sync   /dev/sdc1
        2       8       17        2      active sync   /dev/sdb1
        3       8       65        3      active sync   /dev/sde1
        4       8       81        4      active sync   /dev/sdf1
        5       8       97        5      active sync   /dev/sdg1
        6       8      113        6      active sync   /dev/sdh1
        7       8      129        7      active sync   /dev/sdi1
        8       8      145        8      active sync   /dev/sdj1
        9       8      161        9      active sync   /dev/sdk1
       10       8      177       10      active sync   /dev/sdl1
       11       8      193       11      active sync   /dev/sdm1
       12       8      209       12      active sync   /dev/sdn1
       13       8      225       13      active sync   /dev/sdo1
       14       8      241       14      active sync   /dev/sdp1


is there anything i can test/debug ?
