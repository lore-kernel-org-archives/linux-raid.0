From: Bryan Caron <caron@phys.ualberta.ca>
Subject: trouble recovering 8-disk RAID5 into degraded mode with mdadm
Date: Thu, 11 Dec 2003 16:49:27 -0700 (MST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0312111624200.23692-100000@megingjord.phys.ualberta.ca>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Greetings,

I have an 8 x 75 GB IDE array in RAID5 mode that I'm trying to get back 
into a workable state (ie. degraded mode) so I can remove the contents.  
The problem developed during an fsck after a clean reboot and appeared to 
be one failed drive.  

The reconstruction happily began when assembling the array with:

mdadm -Av --force /dev/md0 /dev/sda1 /dev/sdb1 /dev/sdc1 /dev/sde1 \
/dev/sdf1 /dev/sdg1 /dev/sdh1

However, drive sdd1 resulted in some errors after mounting the array and 
accessing files.

Dec 10 10:52:18 thuner-raid3c kernel: 3w-xxxx: scsi0: Command failed: 
status = 0xc7, flags = 0x51, unit #3.

But now one of the remaining 7 drives (sdg1) is now being marked as spare.  
I've tried unsuccessfully re-adding it to the array but won't proceed 
since the raid array won't be assembled.  The 7 working drives are all 
part of the original 8 drive array (sda1 to sdh1) so I was hoping to at 
least get the array into degraded-mode.

---
[root@thuner-raid3 root]# mdadm -Av --force /dev/md0 /dev/sda1 /dev/sdb1 \
/dev/sdc1 /dev/sde1 /dev/sdf1 /dev/sdg1 /dev/sdh1
mdadm: looking for devices for /dev/md0
mdadm: /dev/sda1 is identified as a member of /dev/md0, slot 0.
mdadm: /dev/sdb1 is identified as a member of /dev/md0, slot 1.
mdadm: /dev/sdc1 is identified as a member of /dev/md0, slot 2.
mdadm: /dev/sde1 is identified as a member of /dev/md0, slot 4.
mdadm: /dev/sdf1 is identified as a member of /dev/md0, slot 5.
mdadm: /dev/sdg1 is identified as a member of /dev/md0, slot 8.
mdadm: /dev/sdh1 is identified as a member of /dev/md0, slot 7.
mdadm: added /dev/sdb1 to /dev/md0 as 1
mdadm: added /dev/sdc1 to /dev/md0 as 2
mdadm: no uptodate device for slot 3 of /dev/md0
mdadm: added /dev/sde1 to /dev/md0 as 4
mdadm: added /dev/sdf1 to /dev/md0 as 5
mdadm: no uptodate device for slot 6 of /dev/md0
mdadm: added /dev/sdh1 to /dev/md0 as 7
mdadm: added /dev/sdg1 to /dev/md0 as 8
mdadm: added /dev/sda1 to /dev/md0 as 0
mdadm: /dev/md0 assembled from 6 drives and 1 spare - not enough to start 
the array.
---

Basically I would like to move sdg1 to slot 6 from slot 8.

Any advice or suggestions on how to re-add the spare drive would be 
appreciated.

Below are the details of the setup.

Many thanks in advance.

Best regards,

Bryan.

 -----------------------------------------------------------
 Bryan L. Caron               
 EMAIL: caron@phys.ualberta.ca
 ------------------------------------------------------------


RedHat Linux 7.3
Kernel 2.4.20-24.7
mdadm-1.4.0-1 (raid5 originally created with mkraid)
3ware 6800 controller

/dev/sda1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 765a4a48:bb833995:cae6f280:3cca6ac9
  Creation Time : Wed Dec 11 22:40:16 2002
     Raid Level : raid5
    Device Size : 75063616 (71.59 GiB 76.87 GB)
   Raid Devices : 8
  Total Devices : 7
Preferred Minor : 0

    Update Time : Wed Dec 10 19:08:29 2003
          State : clean, no-errors
 Active Devices : 6
Working Devices : 7
 Failed Devices : 0
  Spare Devices : 1
       Checksum : 65048751 - correct
         Events : 0.27

         Layout : left-asymmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     0       8        1        0      active sync   /dev/sda1
   0     0       8        1        0      active sync   /dev/sda1
   1     1       8       17        1      active sync   /dev/sdb1
   2     2       8       33        2      active sync   /dev/sdc1
   3     3       0        0        3      faulty removed
   4     4       8       65        4      active sync   /dev/sde1
   5     5       8       81        5      active sync   /dev/sdf1
   6     6       0        0        6      faulty removed
   7     7       8      113        7      active sync   /dev/sdh1
   8     8       8       97        8      spare   /dev/sdg1

/dev/sdb1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 765a4a48:bb833995:cae6f280:3cca6ac9
  Creation Time : Wed Dec 11 22:40:16 2002
     Raid Level : raid5
    Device Size : 75063616 (71.59 GiB 76.87 GB)
   Raid Devices : 8
  Total Devices : 7
Preferred Minor : 0

    Update Time : Wed Dec 10 19:08:29 2003
          State : clean, no-errors
 Active Devices : 6
Working Devices : 7
 Failed Devices : 0
  Spare Devices : 1
       Checksum : 65048763 - correct
         Events : 0.27

         Layout : left-asymmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     1       8       17        1      active sync   /dev/sdb1
   0     0       8        1        0      active sync   /dev/sda1
   1     1       8       17        1      active sync   /dev/sdb1
   2     2       8       33        2      active sync   /dev/sdc1
   3     3       0        0        3      faulty removed
   4     4       8       65        4      active sync   /dev/sde1
   5     5       8       81        5      active sync   /dev/sdf1
   6     6       0        0        6      faulty removed
   7     7       8      113        7      active sync   /dev/sdh1
   8     8       8       97        8      spare   /dev/sdg1


/dev/sdc1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 765a4a48:bb833995:cae6f280:3cca6ac9
  Creation Time : Wed Dec 11 22:40:16 2002
     Raid Level : raid5
    Device Size : 75063616 (71.59 GiB 76.87 GB)
   Raid Devices : 8
  Total Devices : 7
Preferred Minor : 0

    Update Time : Wed Dec 10 19:08:29 2003
          State : clean, no-errors
 Active Devices : 6
Working Devices : 7
 Failed Devices : 0
  Spare Devices : 1
       Checksum : 65048775 - correct
         Events : 0.27

         Layout : left-asymmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     2       8       33        2      active sync   /dev/sdc1
   0     0       8        1        0      active sync   /dev/sda1
   1     1       8       17        1      active sync   /dev/sdb1
   2     2       8       33        2      active sync   /dev/sdc1
   3     3       0        0        3      faulty removed
   4     4       8       65        4      active sync   /dev/sde1
   5     5       8       81        5      active sync   /dev/sdf1
   6     6       0        0        6      faulty removed
   7     7       8      113        7      active sync   /dev/sdh1
   8     8       8       97        8      spare   /dev/sdg1

/dev/sdd1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 765a4a48:bb833995:cae6f280:3cca6ac9
  Creation Time : Wed Dec 11 22:40:16 2002
     Raid Level : raid5
    Device Size : 75063616 (71.59 GiB 76.87 GB)
   Raid Devices : 8
  Total Devices : 7
Preferred Minor : 0

    Update Time : Wed Dec 10 19:02:43 2003
          State : dirty, no-errors
 Active Devices : 6
Working Devices : 5
 Failed Devices : 2
  Spare Devices : 1
       Checksum : 65048641 - correct
         Events : 0.22

         Layout : left-asymmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     9       8       49        9      spare   /dev/sdd1
   0     0       8        1        0      active sync   /dev/sda1
   1     1       8       17        1      active sync   /dev/sdb1
   2     2       8       33        2      active sync   /dev/sdc1
   3     3       0        0        3      faulty removed
   4     4       8       65        4      active sync   /dev/sde1
   5     5       8       81        5      active sync   /dev/sdf1
   6     6       0        0        6      faulty removed
   7     7       8      113        7      active sync   /dev/sdh1
   8     8       0        0        8      faulty removed

/dev/sde1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 765a4a48:bb833995:cae6f280:3cca6ac9
  Creation Time : Wed Dec 11 22:40:16 2002
     Raid Level : raid5
    Device Size : 75063616 (71.59 GiB 76.87 GB)
   Raid Devices : 8
  Total Devices : 7
Preferred Minor : 0

    Update Time : Wed Dec 10 19:08:29 2003
          State : clean, no-errors
 Active Devices : 6
Working Devices : 7
 Failed Devices : 0
  Spare Devices : 1
       Checksum : 65048799 - correct
         Events : 0.27

         Layout : left-asymmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     4       8       65        4      active sync   /dev/sde1
   0     0       8        1        0      active sync   /dev/sda1
   1     1       8       17        1      active sync   /dev/sdb1
   2     2       8       33        2      active sync   /dev/sdc1
   3     3       0        0        3      faulty removed
   4     4       8       65        4      active sync   /dev/sde1
   5     5       8       81        5      active sync   /dev/sdf1
   6     6       0        0        6      faulty removed
   7     7       8      113        7      active sync   /dev/sdh1
   8     8       8       97        8      spare   /dev/sdg1

/dev/sdf1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 765a4a48:bb833995:cae6f280:3cca6ac9
  Creation Time : Wed Dec 11 22:40:16 2002
     Raid Level : raid5
    Device Size : 75063616 (71.59 GiB 76.87 GB)
   Raid Devices : 8
  Total Devices : 7
Preferred Minor : 0

    Update Time : Wed Dec 10 19:08:29 2003
          State : clean, no-errors
 Active Devices : 6
Working Devices : 7
 Failed Devices : 0
  Spare Devices : 1
       Checksum : 650487ab - correct
         Events : 0.27

         Layout : left-asymmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     5       8       81        5      active sync   /dev/sdf1
   0     0       8        1        0      active sync   /dev/sda1
   1     1       8       17        1      active sync   /dev/sdb1
   2     2       8       33        2      active sync   /dev/sdc1
   3     3       0        0        3      faulty removed
   4     4       8       65        4      active sync   /dev/sde1
   5     5       8       81        5      active sync   /dev/sdf1
   6     6       0        0        6      faulty removed
   7     7       8      113        7      active sync   /dev/sdh1
   8     8       8       97        8      spare   /dev/sdg1

/dev/sdg1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 765a4a48:bb833995:cae6f280:3cca6ac9
  Creation Time : Wed Dec 11 22:40:16 2002
     Raid Level : raid5
    Device Size : 75063616 (71.59 GiB 76.87 GB)
   Raid Devices : 8
  Total Devices : 7
Preferred Minor : 0

    Update Time : Wed Dec 10 19:08:29 2003
          State : clean, no-errors
 Active Devices : 6
Working Devices : 7
 Failed Devices : 0
  Spare Devices : 1
       Checksum : 650487bb - correct
         Events : 0.27

         Layout : left-asymmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     8       8       97        8      spare   /dev/sdg1
   0     0       8        1        0      active sync   /dev/sda1
   1     1       8       17        1      active sync   /dev/sdb1
   2     2       8       33        2      active sync   /dev/sdc1
   3     3       0        0        3      faulty removed
   4     4       8       65        4      active sync   /dev/sde1
   5     5       8       81        5      active sync   /dev/sdf1
   6     6       0        0        6      faulty removed
   7     7       8      113        7      active sync   /dev/sdh1
   8     8       8       97        8      spare   /dev/sdg1

/dev/sdh1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 765a4a48:bb833995:cae6f280:3cca6ac9
  Creation Time : Wed Dec 11 22:40:16 2002
     Raid Level : raid5
    Device Size : 75063616 (71.59 GiB 76.87 GB)
   Raid Devices : 8
  Total Devices : 7
Preferred Minor : 0

    Update Time : Wed Dec 10 19:08:29 2003
          State : clean, no-errors
 Active Devices : 6
Working Devices : 7
 Failed Devices : 0
  Spare Devices : 1
       Checksum : 650487cf - correct
         Events : 0.27

         Layout : left-asymmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     7       8      113        7      active sync   /dev/sdh1
   0     0       8        1        0      active sync   /dev/sda1
   1     1       8       17        1      active sync   /dev/sdb1
   2     2       8       33        2      active sync   /dev/sdc1
   3     3       0        0        3      faulty removed
   4     4       8       65        4      active sync   /dev/sde1
   5     5       8       81        5      active sync   /dev/sdf1
   6     6       0        0        6      faulty removed
   7     7       8      113        7      active sync   /dev/sdh1
   8     8       8       97        8      spare   /dev/sdg1


# END



