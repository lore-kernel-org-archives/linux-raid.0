From: nterry <nigel@nigelterry.net>
Subject: Raid 5 Problem
Date: Sun, 14 Dec 2008 08:41:24 -0500
Message-ID: <49450D04.8060703@nigelterry.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi.  I hope someone can tell me what I have done wrong.  I have a 4 disk 
Raid 5 array running on Fedora9.  I've run this array for 2.5 years with 
no issues.  I recently rebooted after upgrading to Kernel 2.6.27.7.  
When I did this I found that only 3 of my disks were in the array.  When 
I examine the three active elements of the array (/dev/sdd1, /dev/sde1, 
/dev/sdc1) they all show that the array has 3 drives and one missing.  
When I examine the missing drive it shows that all members of the array 
are present, which I don't understand! When I try to add the missing 
drive back is says the device is busy.  Please see below and let me know 
what I need to do to get this working again.  Thanks Nigel:

==================================================================
[root@homepc ~]# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : active raid5 sdd1[0] sdc1[3] sde1[1]
      735334656 blocks level 5, 128k chunk, algorithm 2 [4/3] [UU_U]
     
md_d0 : inactive sdb[2](S)
      245117312 blocks
      
unused devices: <none>
[root@homepc ~]#
==================================================================
[root@homepc ~]# cat /etc/mdadm.conf

# mdadm.conf written out by anaconda
# DEVICE partitions
MAILADDR nigel@nigelterry.net
ARRAY /dev/md0 level=raid5 num-devices=4 
devices=/dev/sdb1,/dev/sdc1,/dev/sdd1,/dev/sde1

[root@homepc ~]#

==================================================================
[root@homepc ~]# mdadm --detail /dev/md0
/dev/md0:
        Version : 0.90
  Creation Time : Tue Apr 18 17:44:34 2006
     Raid Level : raid5
     Array Size : 735334656 (701.27 GiB 752.98 GB)
  Used Dev Size : 245111552 (233.76 GiB 250.99 GB)
   Raid Devices : 4
  Total Devices : 3
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Fri Dec 12 17:48:12 2008
          State : clean, degraded
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 128K

           UUID : 50e3173e:b5d2bdb6:7db3576b:644409bb
         Events : 0.6485812

    Number   Major   Minor   RaidDevice State
       0       8       49        0      active sync   /dev/sdd1
       1       8       65        1      active sync   /dev/sde1
       2       0        0        2      removed
       3       8       33        3      active sync   /dev/sdc1
[root@homepc ~]# mdadm --examine  /dev/sdd1
/dev/sdd1:
          Magic : a92b4efc
        Version : 0.90.03
           UUID : 50e3173e:b5d2bdb6:7db3576b:644409bb
  Creation Time : Tue Apr 18 17:44:34 2006
     Raid Level : raid5
  Used Dev Size : 245111552 (233.76 GiB 250.99 GB)
     Array Size : 735334656 (701.27 GiB 752.98 GB)
   Raid Devices : 4
  Total Devices : 3
Preferred Minor : 0

    Update Time : Fri Dec 12 17:48:22 2008
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 1
  Spare Devices : 0
       Checksum : 2ec4d801 - correct
         Events : 6485814

         Layout : left-symmetric
     Chunk Size : 128K

      Number   Major   Minor   RaidDevice State
this     0       8       49        0      active sync   /dev/sdd1

   0     0       8       49        0      active sync   /dev/sdd1
   1     1       8       65        1      active sync   /dev/sde1
   2     2       0        0        2      faulty removed
   3     3       8       33        3      active sync   /dev/sdc1
[root@homepc ~]# mdadm --examine  /dev/sde1
/dev/sde1:
          Magic : a92b4efc
        Version : 0.90.03
           UUID : 50e3173e:b5d2bdb6:7db3576b:644409bb
  Creation Time : Tue Apr 18 17:44:34 2006
     Raid Level : raid5
  Used Dev Size : 245111552 (233.76 GiB 250.99 GB)
     Array Size : 735334656 (701.27 GiB 752.98 GB)
   Raid Devices : 4
  Total Devices : 3
Preferred Minor : 0

    Update Time : Fri Dec 12 17:48:22 2008
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 1
  Spare Devices : 0
       Checksum : 2ec4d813 - correct
         Events : 6485814

         Layout : left-symmetric
     Chunk Size : 128K

      Number   Major   Minor   RaidDevice State
this     1       8       65        1      active sync   /dev/sde1

   0     0       8       49        0      active sync   /dev/sdd1
   1     1       8       65        1      active sync   /dev/sde1
   2     2       0        0        2      faulty removed
   3     3       8       33        3      active sync   /dev/sdc1
[root@homepc ~]# mdadm --examine  /dev/sdc1
/dev/sdc1:
          Magic : a92b4efc
        Version : 0.90.03
           UUID : 50e3173e:b5d2bdb6:7db3576b:644409bb
  Creation Time : Tue Apr 18 17:44:34 2006
     Raid Level : raid5
  Used Dev Size : 245111552 (233.76 GiB 250.99 GB)
     Array Size : 735334656 (701.27 GiB 752.98 GB)
   Raid Devices : 4
  Total Devices : 3
Preferred Minor : 0

    Update Time : Fri Dec 12 17:48:22 2008
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 1
  Spare Devices : 0
       Checksum : 2ec4d7f7 - correct
         Events : 6485814

         Layout : left-symmetric
     Chunk Size : 128K

      Number   Major   Minor   RaidDevice State
this     3       8       33        3      active sync   /dev/sdc1

   0     0       8       49        0      active sync   /dev/sdd1
   1     1       8       65        1      active sync   /dev/sde1
   2     2       0        0        2      faulty removed
   3     3       8       33        3      active sync   /dev/sdc1
[root@homepc ~]# mdadm --examine  /dev/sdb1
/dev/sdb1:
          Magic : a92b4efc
        Version : 0.90.03
           UUID : 50e3173e:b5d2bdb6:7db3576b:644409bb
  Creation Time : Tue Apr 18 17:44:34 2006
     Raid Level : raid5
  Used Dev Size : 245111552 (233.76 GiB 250.99 GB)
     Array Size : 735334656 (701.27 GiB 752.98 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0

    Update Time : Fri Dec 12 17:29:15 2008
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 2ec4d1d6 - correct
         Events : 6485600

         Layout : left-symmetric
     Chunk Size : 128K

      Number   Major   Minor   RaidDevice State
this     2       8       17        2      active sync   /dev/sdb1

   0     0       8       49        0      active sync   /dev/sdd1
   1     1       8       65        1      active sync   /dev/sde1
   2     2       8       17        2      active sync   /dev/sdb1
   3     3       8       33        3      active sync   /dev/sdc1
[root@homepc ~]# mdadm /dev/md0 --add /dev/sdb1
mdadm: Cannot open /dev/sdb1: Device or resource busy
[root@homepc ~]#

