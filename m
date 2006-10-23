From: eharney@CLEMSON.EDU
Subject: Need help recovering a raid5 array
Date: Mon, 23 Oct 2006 11:21:43 -0400 (EDT)
Message-ID: <44029.130.127.44.164.1161616903.squirrel@wm.clemson.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello all,

I had a disk fail in a raid 5 array (4 disk array, no spares), and am
having trouble recovering it.  I believe my data is still safe, but I
cannot tell what is going wrong here.

When I try to rebuild the array "mdadm --assemble /dev/md0 /dev/sda2
/dev/sdb2 /dev/sdc2 /dev/sdd2" I see "failed to RUN_ARRAY /dev/md0:
Input/output error".

dmesg shows the following:
md: bind<sdb2>
md: bind<sdc2>
md: bind<sdd2>
md: bind<sda2>
md: md0: raid array is not clean -- starting background reconstruction
raid5: device sda2 operational as raid disk 0
raid5: device sdc2 operational as raid disk 2
raid5: device sdb2 operational as raid disk 1
raid5: cannot start dirty degraded array for md0
RAID5 conf printout:
 --- rd:4 wd:3 fd:1
 disk 0, o:1, dev:sda2
 disk 1, o:1, dev:sdb2
 disk 2, o:1, dev:sdc2
raid5: failed to run raid set md0
md: pers->run() failed ...



/proc mdstat shows:
md0 : inactive sda2[0] sdd2[3](S) sdc2[2] sdb2[1]

This seems wrong, as sdd2 should not be a spare - I want it to be the
fourth disk.


The output of mdadm -E for each disk is as follows:
sda2:
/dev/sda2:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : c50a81fc:ef4323e6:438a7cb1:25ae35e5
  Creation Time : Thu Jun  1 21:13:58 2006
     Raid Level : raid5
    Device Size : 390555904 (372.46 GiB 399.93 GB)
     Array Size : 1171667712 (1117.39 GiB 1199.79 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0

    Update Time : Sun Oct 22 23:39:06 2006
          State : active
 Active Devices : 3
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 1
       Checksum : 683f2f5c - correct
         Events : 0.8831997

         Layout : left-symmetric
     Chunk Size : 256K

      Number   Major   Minor   RaidDevice State
this     0       8        2        0      active sync   /dev/sda2

   0     0       8        2        0      active sync   /dev/sda2
   1     1       8       18        1      active sync   /dev/sdb2
   2     2       8       34        2      active sync   /dev/sdc2
   3     3       0        0        3      faulty removed
   4     4       8       50        4      spare   /dev/sdd2


sdb2:
/dev/sdb2:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : c50a81fc:ef4323e6:438a7cb1:25ae35e5
  Creation Time : Thu Jun  1 21:13:58 2006
     Raid Level : raid5
    Device Size : 390555904 (372.46 GiB 399.93 GB)
     Array Size : 1171667712 (1117.39 GiB 1199.79 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0

    Update Time : Sun Oct 22 23:39:06 2006
          State : active
 Active Devices : 3
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 1
       Checksum : 683f2f6e - correct
         Events : 0.8831997

         Layout : left-symmetric
     Chunk Size : 256K

      Number   Major   Minor   RaidDevice State
this     1       8       18        1      active sync   /dev/sdb2

   0     0       8        2        0      active sync   /dev/sda2
   1     1       8       18        1      active sync   /dev/sdb2
   2     2       8       34        2      active sync   /dev/sdc2
   3     3       0        0        3      faulty removed
   4     4       8       50        4      spare   /dev/sdd2


sdc2:
/dev/sdc2:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : c50a81fc:ef4323e6:438a7cb1:25ae35e5
  Creation Time : Thu Jun  1 21:13:58 2006
     Raid Level : raid5
    Device Size : 390555904 (372.46 GiB 399.93 GB)
     Array Size : 1171667712 (1117.39 GiB 1199.79 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0

    Update Time : Sun Oct 22 23:39:06 2006
          State : active
 Active Devices : 3
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 1
       Checksum : 683f2f80 - correct
         Events : 0.8831997

         Layout : left-symmetric
     Chunk Size : 256K

      Number   Major   Minor   RaidDevice State
this     2       8       34        2      active sync   /dev/sdc2

   0     0       8        2        0      active sync   /dev/sda2
   1     1       8       18        1      active sync   /dev/sdb2
   2     2       8       34        2      active sync   /dev/sdc2
   3     3       0        0        3      faulty removed
   4     4       8       50        4      spare   /dev/sdd2


sdd2:
/dev/sdd2:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : c50a81fc:ef4323e6:438a7cb1:25ae35e5
  Creation Time : Thu Jun  1 21:13:58 2006
     Raid Level : raid5
    Device Size : 390555904 (372.46 GiB 399.93 GB)
     Array Size : 1171667712 (1117.39 GiB 1199.79 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0

    Update Time : Sun Oct 22 23:39:06 2006
          State : active
 Active Devices : 3
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 1
       Checksum : 683f2fbf - correct
         Events : 0.8831997

         Layout : left-symmetric
     Chunk Size : 256K

      Number   Major   Minor   RaidDevice State
this     3       8       50       -1      sync   /dev/sdd2

   0     0       8        2        0      active sync   /dev/sda2
   1     1       8       18        1      active sync   /dev/sdb2
   2     2       8       34        2      active sync   /dev/sdc2
   3     3       8       50       -1      sync   /dev/sdd2
   4     4       8       50        4      spare   /dev/sdd2



Does anyone have any idea how to get this array back into good shape?
I'm not sure why it thinks sdd2 should be a spare, or how to get it back
to being a regular disk.

I would appreciate any help you can offer.  (Also, am I right in thinking
my data is still good?  I should still have 3 of the 4 disks working fine,
at any rate.)

Thanks,
Eric
