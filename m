From: Farkas Levente <lfarkas@bppiac.hu>
Subject: why the kernel and mdadm report differently
Date: Mon, 05 Sep 2005 11:01:28 +0200
Message-ID: <431C0968.10301@bppiac.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

hi,
one of our raid array is crash all the time (once a week), and one more 
stange thing that it's currently not working, kernel report inactive 
while mdadm said it's active, degraded. what's more we cant put this 
array into active state.
this is mdadm 1.12, just another site note there is no rpm for version 
2.0:-(
yours.
---------------------------------------------------
[root@kek:~] mdadm --detail /dev/md2
/dev/md2:
         Version : 00.90.01
   Creation Time : Tue Jun  1 09:37:17 2004
      Raid Level : raid5
     Device Size : 120053632 (114.49 GiB 122.93 GB)
    Raid Devices : 7
   Total Devices : 7
Preferred Minor : 2
     Persistence : Superblock is persistent

     Update Time : Sat Sep  3 16:10:39 2005
           State : active, degraded
  Active Devices : 6
Working Devices : 7
  Failed Devices : 0
   Spare Devices : 1

          Layout : left-symmetric
      Chunk Size : 128K

            UUID : 79b566fd:924d9c94:15304031:0c945006
          Events : 0.3130

     Number   Major   Minor   RaidDevice State
        0       8        1        0      active sync   /dev/sda1
        1       8       17        1      active sync   /dev/sdb1
        2       8       33        2      active sync   /dev/sdc1
        3       0        0        -      removed
        4       8       65        4      active sync   /dev/sde1
        5       8       81        5      active sync   /dev/sdf1
        6       8       97        6      active sync   /dev/sdg1

        7       8      113        -      spare   /dev/sdh1
[root@kek:~] cat /proc/mdstat
Personalities : [raid1] [raid5]
md1 : active raid1 hdc1[0] hda1[1]
       1048704 blocks [2/2] [UU]

md2 : inactive sda1[0] sdh1[7] sdg1[6] sdf1[5] sde1[4] sdc1[2] sdb1[1]
       840375424 blocks
md0 : active raid1 hdc2[0] hda2[1]
       39097664 blocks [2/2] [UU]

unused devices: <none>
---------------------------------------------------

-- 
   Levente                               "Si vis pacem para bellum!"

