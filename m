From: "Marcin M. Jessa" <lists@yazzy.org>
Subject: Recovery of failed RAID 6 and LVM
Date: Sun, 25 Sep 2011 09:55:04 +0200
Message-ID: <4E7EDE58.3000804@yazzy.org>
Reply-To: lists@yazzy.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi guys.


I have a RAID 6 setup with 5 2TB drives on Debian Wheezy [1] & [2].
Yesterday 3 of the drives failed working leaving the RAID setup broken.
Following [5] I managed to start the array and make it resync.
The problem I'm facing now is I cannot access any of the LVM partitions 
[3] I have on top of my md0. Fdisk says the disk doesn't contain a valid 
partition table [4].
I tried to run fsck on the lvm devices without luck.
Has any of you a suggestion, a method I could use to access my data please?



[1]:
# mdadm -QD /dev/md0
/dev/md0:
         Version : 1.2
   Creation Time : Sat Sep 24 23:59:02 2011
      Raid Level : raid6
      Array Size : 5860531200 (5589.04 GiB 6001.18 GB)
   Used Dev Size : 1953510400 (1863.01 GiB 2000.39 GB)
    Raid Devices : 5
   Total Devices : 5
     Persistence : Superblock is persistent

     Update Time : Sun Sep 25 09:40:20 2011
           State : clean, degraded, recovering
  Active Devices : 3
Working Devices : 5
  Failed Devices : 0
   Spare Devices : 2

          Layout : left-symmetric
      Chunk Size : 512K

  Rebuild Status : 63% complete

            Name : odin:0  (local to host odin)
            UUID : be51de24:ebcc6eef:8fc41158:fc728448
          Events : 10314

     Number   Major   Minor   RaidDevice State
        0       8       65        0      active sync   /dev/sde1
        1       8       81        1      active sync   /dev/sdf1
        2       8       97        2      active sync   /dev/sdg1
        5       8      129        3      spare rebuilding   /dev/sdi1
        4       0        0        4      removed

        6       8      113        -      spare   /dev/sdh1


[2]:
# cat /proc/mdstat

Personalities : [raid1] [raid6] [raid5] [raid4]
md0 : active raid6 sdh1[6](S) sdi1[5] sdg1[2] sdf1[1] sde1[0]
       5860531200 blocks super 1.2 level 6, 512k chunk, algorithm 2 
[5/3] [UUU__]
       [=======>.............]  recovery = 36.8% (720185308/1953510400) 
finish=441.4min speed=46564K/sec


[3]:
# lvdisplay
     Logging initialised at Sun Sep 25 09:49:11 2011
     Set umask from 0022 to 0077
     Finding all logical volumes
   --- Logical volume ---
   LV Name                /dev/fridge/storage
   VG Name                fridge
   LV UUID                kIhbSq-hePX-UIVv-uuiP-iK6w-djcz-iQ3cEI
   LV Write Access        read/write
   LV Status              available
   # open                 0
   LV Size                4.88 TiB
   Current LE             1280000
   Segments               1
   Allocation             inherit
   Read ahead sectors     auto
   - currently set to     6144
   Block device           253:0


[4]:

# fdisk  -l /dev/fridge/storage

Disk /dev/fridge/storage: 5368.7 GB, 5368709120000 bytes
255 heads, 63 sectors/track, 652708 cylinders, total 10485760000 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 524288 bytes / 1572864 bytes
Disk identifier: 0x00000000

Disk /dev/fridge/storage doesn't contain a valid partition table



[5]: 
http://en.wikipedia.org/wiki/Mdadm#Recovering_from_a_loss_of_raid_superblock



-- 

Marcin M. Jessa
