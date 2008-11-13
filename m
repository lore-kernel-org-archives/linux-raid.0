From: Jan Wagner <jwagner@kurp.hut.fi>
Subject: partitionable md partition size caps at 0.4TB
Date: Thu, 13 Nov 2008 14:00:18 +0200 (EET)
Message-ID: <alpine.DEB.2.00.0811131350410.20263@kurp.hut.fi>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

is it possible to create md partitions larger than 0.4TB?

We have >=9TB RAID-0 systems, and I tried to create a partitionable 
two-partition md with mdadm --auto=mdp2 and partition it into for example 
16MB and ~9TB. For partitioning /dev/md_d0 I have tried sfdisk, fdisk, 
cfdisk, parted, ... Regardless of the partitioning tool, the ~9TB 
partition always ends up as 455780.07MB i.e. 0.4TB.

There is no problem to create a large 9TB single partition on a 
non-partitionable /dev/md0. Is the 445097720 blocks (0.4TB) "cropping" a 
bug or a real limitation with mdp partitionable raid?

Further infos below.

root@abidal:~# uname -a
Linux abidal 2.6.27-7-generic #1 SMP Tue Nov 4 19:33:06 UTC 2008 x86_64 GNU/Linux

root@abidal:~# cat /etc/lsb-release
DISTRIB_ID=Ubuntu
DISTRIB_RELEASE=8.10
DISTRIB_CODENAME=intrepid
DISTRIB_DESCRIPTION="Ubuntu 8.10"

root@abidal:~# cat /proc/partitions|grep md
  254     0 9035047936 md_d0
  254     1      15622 md_d0p1
  254     2  445097720 md_d0p2

root@abidal:~# sfdisk /dev/md_d0
Checking that no-one is using this disk right now ...
OK

Disk /dev/md_d0: 2258761984 cylinders, 2 heads, 4 sectors/track
Old situation:
Units = cylinders of 4096 bytes, blocks of 1024 bytes, counting from 0

    Device Boot Start     End   #cyls    #blocks   Id  System
/dev/md_d0p1          0+   3905    3906-     15622   83  Linux
/dev/md_d0p2       3906  111278335  111274430  445097720   83  Linux
/dev/md_d0p3          0       -       0          0    0  Empty
/dev/md_d0p4          0       -       0          0    0  Empty

root@abidal:~# mdadm -D /dev/md0
mdadm: md device /dev/md0 does not appear to be active.
root@abidal:~# mdadm -D /dev/md_d0
/dev/md_d0:
         Version : 00.90
   Creation Time : Thu Nov 13 11:58:59 2008
      Raid Level : raid0
      Array Size : 9035047936 (8616.49 GiB 9251.89 GB)
    Raid Devices : 12
   Total Devices : 12
Preferred Minor : 0
     Persistence : Superblock is persistent

     Update Time : Thu Nov 13 11:58:59 2008
           State : clean
  Active Devices : 12
Working Devices : 12
  Failed Devices : 0
   Spare Devices : 0

      Chunk Size : 1024K

            UUID : f1945a73:83d2bea9:b96e9208:11a3b9ec (local to host 
abidal)
          Events : 0.1

     Number   Major   Minor   RaidDevice State
        0       8       17        0      active sync   /dev/sdb1
        1       8       33        1      active sync   /dev/sdc1
        2       8       49        2      active sync   /dev/sdd1
        3       8       65        3      active sync   /dev/sde1
        4       8       81        4      active sync   /dev/sdf1
        5       8       97        5      active sync   /dev/sdg1
        6       8      113        6      active sync   /dev/sdh1
        7       8      129        7      active sync   /dev/sdi1
        8       8      145        8      active sync   /dev/sdj1
        9       8      161        9      active sync   /dev/sdk1
       10       8      177       10      active sync   /dev/sdl1
       11       8      193       11      active sync   /dev/sdm1

thanks,
  - Jan
