From: P Agenbag <internet@mweb.co.za>
Subject: RAID5+spare volume gone - mdadm sees RAID1 only?
Date: Sun, 22 Sep 2013 20:02:35 +0200
Message-ID: <CAFjqtwhDa03Yi2kaWAVCVpYPxPmF3omwAw2KW4cmKfQerXFwug@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi List

I have a D-Link DNS345 NAS which I configured as RAID5 + spare with 4x
500GB Seagate SATA drives.

I suspect a power surge caused the NAS to suddenly lose the volume.

All 4 drives checked out OK when doing a SMART test on the NAS itself.
I proceeded to build all 4 drives into a CentOS server, but was unable
to mount the RAID5 - error is always "not enough drives".

I followed some advise in archives, and did some mdadm -- examines,
and echo them below - what I don't understand is why the --examine
picks them up as RAID1.

Is there anything I can do to re-build this array?

Appreciate any help/advise.

Regards


/dev/sda1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 17888794:50a497c7:f853c57d:313558dc
  Creation Time : Sat Sep 21 11:19:13 2013
     Raid Level : raid1
  Used Dev Size : 524224 (512.02 MiB 536.81 MB)
     Array Size : 524224 (512.02 MiB 536.81 MB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 1

    Update Time : Sun Sep 22 12:20:23 2013
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0
       Checksum : df65b6a0 - correct
         Events : 6


      Number   Major   Minor   RaidDevice State
this     3       8        1        3      active sync   /dev/sda1

   0     0       8       17        0      active sync   /dev/sdb1
   1     1       8       49        1      active sync   /dev/sdd1
   2     2       8       33        2      active sync   /dev/sdc1
   3     3       8        1        3      active sync   /dev/sda1
/dev/sdb1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 17888794:50a497c7:f853c57d:313558dc
  Creation Time : Sat Sep 21 11:19:13 2013
     Raid Level : raid1
  Used Dev Size : 524224 (512.02 MiB 536.81 MB)
     Array Size : 524224 (512.02 MiB 536.81 MB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 1

    Update Time : Sun Sep 22 12:20:23 2013
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0
       Checksum : df65b6aa - correct
         Events : 6


      Number   Major   Minor   RaidDevice State
this     0       8       17        0      active sync   /dev/sdb1

   0     0       8       17        0      active sync   /dev/sdb1
   1     1       8       49        1      active sync   /dev/sdd1
   2     2       8       33        2      active sync   /dev/sdc1
   3     3       8        1        3      active sync   /dev/sda1
/dev/sdc1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 17888794:50a497c7:f853c57d:313558dc
  Creation Time : Sat Sep 21 11:19:13 2013
     Raid Level : raid1
  Used Dev Size : 524224 (512.02 MiB 536.81 MB)
     Array Size : 524224 (512.02 MiB 536.81 MB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 1

    Update Time : Sun Sep 22 12:20:23 2013
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0
       Checksum : df65b6be - correct
         Events : 6


      Number   Major   Minor   RaidDevice State
this     2       8       33        2      active sync   /dev/sdc1

   0     0       8       17        0      active sync   /dev/sdb1
   1     1       8       49        1      active sync   /dev/sdd1
   2     2       8       33        2      active sync   /dev/sdc1
   3     3       8        1        3      active sync   /dev/sda1
/dev/sdd1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 17888794:50a497c7:f853c57d:313558dc
  Creation Time : Sat Sep 21 11:19:13 2013
     Raid Level : raid1
  Used Dev Size : 524224 (512.02 MiB 536.81 MB)
     Array Size : 524224 (512.02 MiB 536.81 MB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 1

    Update Time : Sun Sep 22 12:20:23 2013
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0
       Checksum : df65b6cc - correct
         Events : 6


      Number   Major   Minor   RaidDevice State
this     1       8       49        1      active sync   /dev/sdd1

   0     0       8       17        0      active sync   /dev/sdb1
   1     1       8       49        1      active sync   /dev/sdd1
   2     2       8       33        2      active sync   /dev/sdc1
   3     3       8        1        3      active sync   /dev/sda1
