From: Michael McLagan <mmclagan@invlogic.com>
Subject: Size limitation?
Date: Fri, 1 Jan 2010 14:57:24 -0500
Message-ID: <201001011457.24334.mmclagan@invlogic.com>
Reply-To: mmclagan+reply@invlogic.com
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

   I'm trying to set up a large array but isn't working.  I tried 
Googling size limits, etc and came up empty.

The problem is that with 10 drives (300GB SCSI), the array is coming up 
with 500GB of space?!?  I did an experiment and when the array size 
exceeds 2TB, it fails/wraps?

Is there a solution (simple or otherwise) for this?  The machine runs 
2.6.29.5 (anything later causes the machine to lock up :( ).  I'm not 
sure if mdadm or the kernel is the problem either.

Any suggestions appreciated (please CC me on replies).

   Michael

-----

Here's the details:

]# mdadm --stop /dev/md1;mdadm --zero-superblock /dev/sd[a-j]1;mdadm --
create --level=5 --raid-devices=6 --assume-clean --auto=yes --force 
/dev/md1 /dev/sd[a-f]1;mdadm --detail /dev/md1
/dev/md1:
        Version : 0.90
  Creation Time : Fri Jan  1 14:15:42 2010
     Raid Level : raid5
     Array Size : 1464841600 (1396.98 GiB 1500.00 GB)
  Used Dev Size : 292968320 (279.40 GiB 300.00 GB)
   Raid Devices : 6
  Total Devices : 6
Preferred Minor : 1
    Persistence : Superblock is persistent

    Update Time : Fri Jan  1 14:15:42 2010
          State : clean
 Active Devices : 6
Working Devices : 6
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

           UUID : f6351ed0:cc1a90d1:0436ea62:f9d2db27
         Events : 0.1

    Number   Major   Minor   RaidDevice State
       0       8        1        0      active sync   /dev/sda1
       1       8       17        1      active sync   /dev/sdb1
       2       8       33        2      active sync   /dev/sdc1
       3       8       49        3      active sync   /dev/sdd1
       4       8       65        4      active sync   /dev/sde1
       5       8       81        5      active sync   /dev/sdf1

]# mdadm --stop /dev/md1;mdadm --zero-superblock /dev/sd[a-j]1;mdadm --
create --level=5 --raid-devices=7 --assume-clean --auto=yes --force 
/dev/md1 /dev/sd[a-g]1;mdadm --detail /dev/md1
/dev/md1:
        Version : 0.90
  Creation Time : Fri Jan  1 14:16:00 2010
     Raid Level : raid5
     Array Size : 1757809920 (1676.38 GiB 1800.00 GB)
  Used Dev Size : 292968320 (279.40 GiB 300.00 GB)
   Raid Devices : 7
  Total Devices : 7
Preferred Minor : 1
    Persistence : Superblock is persistent

    Update Time : Fri Jan  1 14:16:00 2010
          State : clean
 Active Devices : 7
Working Devices : 7
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

           UUID : 4116e7ac:522157c5:0436ea62:f9d2db27
         Events : 0.1

    Number   Major   Minor   RaidDevice State
       0       8        1        0      active sync   /dev/sda1
       1       8       17        1      active sync   /dev/sdb1
       2       8       33        2      active sync   /dev/sdc1
       3       8       49        3      active sync   /dev/sdd1
       4       8       65        4      active sync   /dev/sde1
       5       8       81        5      active sync   /dev/sdf1
       6       8       97        6      active sync   /dev/sdg1

]# mdadm --stop /dev/md1;mdadm --zero-superblock /dev/sd[a-j]1;mdadm --
create --level=5 --raid-devices=8 --assume-clean --auto=yes --force 
/dev/md1 /dev/sd[a-h]1;mdadm --detail /dev/md1
/dev/md1:
        Version : 0.90
  Creation Time : Fri Jan  1 14:16:16 2010
     Raid Level : raid5
     Array Size : 2050778240 (1955.77 GiB 2100.00 GB)
  Used Dev Size : 292968320 (279.40 GiB 300.00 GB)
   Raid Devices : 8
  Total Devices : 8
Preferred Minor : 1
    Persistence : Superblock is persistent

    Update Time : Fri Jan  1 14:16:16 2010
          State : clean
 Active Devices : 8
Working Devices : 8
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

           UUID : 9d271092:1a5fda10:0436ea62:f9d2db27
         Events : 0.1

    Number   Major   Minor   RaidDevice State
       0       8        1        0      active sync   /dev/sda1
       1       8       17        1      active sync   /dev/sdb1
       2       8       33        2      active sync   /dev/sdc1
       3       8       49        3      active sync   /dev/sdd1
       4       8       65        4      active sync   /dev/sde1
       5       8       81        5      active sync   /dev/sdf1
       6       8       97        6      active sync   /dev/sdg1
       7       8      113        7      active sync   /dev/sdh1

]# mdadm --stop /dev/md1;mdadm --zero-superblock /dev/sd[a-j]1;mdadm --
create --level=5 --raid-devices=9 --assume-clean --auto=yes --force 
/dev/md1 /dev/sd[a-i]1;mdadm --detail /dev/md1
/dev/md1:
        Version : 0.90
  Creation Time : Fri Jan  1 14:16:31 2010
     Raid Level : raid5
     Array Size : 196262912 (187.17 GiB 200.97 GB)
  Used Dev Size : 292968320 (279.40 GiB 300.00 GB)
   Raid Devices : 9
  Total Devices : 9
Preferred Minor : 1
    Persistence : Superblock is persistent

    Update Time : Fri Jan  1 14:16:31 2010
          State : clean
 Active Devices : 9
Working Devices : 9
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

           UUID : 720627fd:b0e722a1:0436ea62:f9d2db27
         Events : 0.1

    Number   Major   Minor   RaidDevice State
       0       8        1        0      active sync   /dev/sda1
       1       8       17        1      active sync   /dev/sdb1
       2       8       33        2      active sync   /dev/sdc1
       3       8       49        3      active sync   /dev/sdd1
       4       8       65        4      active sync   /dev/sde1
       5       8       81        5      active sync   /dev/sdf1
       6       8       97        6      active sync   /dev/sdg1
       7       8      113        7      active sync   /dev/sdh1
       8       8      129        8      active sync   /dev/sdi1

]# mdadm --stop /dev/md1;mdadm --zero-superblock /dev/sd[a-j]1;mdadm --
create --level=5 --raid-devices=10 --assume-clean --auto=yes --force 
/dev/md1 /dev/sd[a-j]1;mdadm --detail /dev/md1
/dev/md1:
        Version : 0.90
  Creation Time : Fri Jan  1 14:49:33 2010
     Raid Level : raid5
     Array Size : 489231232 (466.57 GiB 500.97 GB)
  Used Dev Size : 292968320 (279.40 GiB 300.00 GB)
   Raid Devices : 10
  Total Devices : 10
Preferred Minor : 1
    Persistence : Superblock is persistent

    Update Time : Fri Jan  1 14:49:33 2010
          State : clean
 Active Devices : 10
Working Devices : 10
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

           UUID : db75bd2c:d566c205:0436ea62:f9d2db27x
         Events : 0.1

    Number   Major   Minor   RaidDevice State
       0       8        1        0      active sync   /dev/sda1
       1       8       17        1      active sync   /dev/sdb1
       2       8       33        2      active sync   /dev/sdc1
       3       8       49        3      active sync   /dev/sdd1
       4       8       65        4      active sync   /dev/sde1
       5       8       81        5      active sync   /dev/sdf1
       6       8       97        6      active sync   /dev/sdg1
       7       8      113        7      active sync   /dev/sdh1
       8       8      129        8      active sync   /dev/sdi1
       9       8      145        9      active sync   /dev/sdj1
