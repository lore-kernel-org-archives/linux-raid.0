From: Kevin McAreavey <kevin.mcareavey@gmail.com>
Subject: Damage when growing RAID 5 array
Date: Mon, 25 Feb 2013 21:17:14 +0000
Message-ID: <C4E6825B-3AF2-40E7-BD1B-65F988171FF2@gmail.com>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi everyone,

I'm really hoping someone can help me and that the array can be saved.

I was trying to grow a RAID 5 array from 3 to 4 drives (I've already successfully grown it once from 2 to 3 drives).  However, after running the grow command it was stuck with 'resync=DELAYED'.  I eventually rebooted but the array was then inactive and with whatever I've done since the array has now disappeared.  Is it possible to salvage this before I make it any worse?

Thanks very much for any help!
Kevin

Some info:

----------

$ cat /proc/mdstat 
Personalities : [raid6] [raid5] [raid4] [linear] [multipath] [raid0] [raid1] [raid10] 
unused devices: <none>

----------

$ sudo mdadm --assemble /dev/md1
mdadm: Failed to restore critical section for reshape, sorry.
      Possibly you needed to specify the --backup-file

----------

$ sudo mdadm -Q /dev/sdc1
/dev/sdc1: is not an md array
/dev/sdc1: device 0 in 4 device undetected raid5 /dev/.tmp.md1.  Use mdadm --examine for more detail.

----------

$ sudo mdadm --examine /dev/sd[acde]1
/dev/sda1:
          Magic : a92b4efc
        Version : 0.91.00
           UUID : ec02c596:7c68f1da:7faca49f:4a711434 (local to host kevin-server)
  Creation Time : Tue Jan 11 20:05:16 2011
     Raid Level : raid5
  Used Dev Size : 1953508352 (1863.01 GiB 2000.39 GB)
     Array Size : 5860525056 (5589.03 GiB 6001.18 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 1

  Reshape pos'n : 0
  Delta Devices : 1 (3->4)

    Update Time : Mon Feb 25 18:19:50 2013
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0
       Checksum : ee7f7fa5 - correct
         Events : 6108

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     3       8        1        3      active sync   /dev/sda1

   0     0       8       33        0      active sync   /dev/sdc1
   1     1       8       65        1      active sync   /dev/sde1
   2     2       8       49        2      active sync   /dev/sdd1
   3     3       8        1        3      active sync   /dev/sda1
/dev/sdc1:
          Magic : a92b4efc
        Version : 0.91.00
           UUID : ec02c596:7c68f1da:7faca49f:4a711434 (local to host kevin-server)
  Creation Time : Tue Jan 11 20:05:16 2011
     Raid Level : raid5
  Used Dev Size : 1953508352 (1863.01 GiB 2000.39 GB)
     Array Size : 5860525056 (5589.03 GiB 6001.18 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 1

  Reshape pos'n : 0
  Delta Devices : 1 (3->4)

    Update Time : Mon Feb 25 18:19:50 2013
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0
       Checksum : ee7f7fbf - correct
         Events : 6108

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     0       8       33        0      active sync   /dev/sdc1

   0     0       8       33        0      active sync   /dev/sdc1
   1     1       8       65        1      active sync   /dev/sde1
   2     2       8       49        2      active sync   /dev/sdd1
   3     3       8        1        3      active sync   /dev/sda1
/dev/sdd1:
          Magic : a92b4efc
        Version : 0.91.00
           UUID : ec02c596:7c68f1da:7faca49f:4a711434 (local to host kevin-server)
  Creation Time : Tue Jan 11 20:05:16 2011
     Raid Level : raid5
  Used Dev Size : 1953508352 (1863.01 GiB 2000.39 GB)
     Array Size : 5860525056 (5589.03 GiB 6001.18 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 1

  Reshape pos'n : 0
  Delta Devices : 1 (3->4)

    Update Time : Mon Feb 25 18:19:50 2013
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0
       Checksum : ee7f7fd3 - correct
         Events : 6108

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     2       8       49        2      active sync   /dev/sdd1

   0     0       8       33        0      active sync   /dev/sdc1
   1     1       8       65        1      active sync   /dev/sde1
   2     2       8       49        2      active sync   /dev/sdd1
   3     3       8        1        3      active sync   /dev/sda1
/dev/sde1:
          Magic : a92b4efc
        Version : 0.91.00
           UUID : ec02c596:7c68f1da:7faca49f:4a711434 (local to host kevin-server)
  Creation Time : Tue Jan 11 20:05:16 2011
     Raid Level : raid5
  Used Dev Size : 1953508352 (1863.01 GiB 2000.39 GB)
     Array Size : 5860525056 (5589.03 GiB 6001.18 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 1

  Reshape pos'n : 0
  Delta Devices : 1 (3->4)

    Update Time : Mon Feb 25 18:19:50 2013
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0
       Checksum : ee7f7fe1 - correct
         Events : 6108

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     1       8       65        1      active sync   /dev/sde1

   0     0       8       33        0      active sync   /dev/sdc1
   1     1       8       65        1      active sync   /dev/sde1
   2     2       8       49        2      active sync   /dev/sdd1
   3     3       8        1        3      active sync   /dev/sda1

----------

I also noticed that /dev/sda seems to have been added:

$ sudo mdadm --examine /dev/sd[acde]
/dev/sda:
          Magic : a92b4efc
        Version : 0.91.00
           UUID : ec02c596:7c68f1da:7faca49f:4a711434 (local to host kevin-server)
  Creation Time : Tue Jan 11 20:05:16 2011
     Raid Level : raid5
  Used Dev Size : 1953508352 (1863.01 GiB 2000.39 GB)
     Array Size : 5860525056 (5589.03 GiB 6001.18 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 1

  Reshape pos'n : 0
  Delta Devices : 1 (3->4)

    Update Time : Mon Feb 25 18:19:50 2013
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0
       Checksum : ee7f7fa5 - correct
         Events : 6108

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     3       8        1        3      active sync   /dev/sda1

   0     0       8       33        0      active sync   /dev/sdc1
   1     1       8       65        1      active sync   /dev/sde1
   2     2       8       49        2      active sync   /dev/sdd1
   3     3       8        1        3      active sync   /dev/sda1
/dev/sdc:
   MBR Magic : aa55
Partition[0] :   3907016904 sectors at           56 (type 83)
/dev/sdd:
   MBR Magic : aa55
Partition[0] :   3907016904 sectors at           56 (type 83)
/dev/sde:
   MBR Magic : aa55
Partition[0] :   3907016904 sectors at           56 (type 83)