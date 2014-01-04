From: Fabian Knorr <knorrfab@fim.uni-passau.de>
Subject: Recovering an Array with inconsistent Superblocks
Date: Sat, 04 Jan 2014 11:04:41 +0100
Message-ID: <1388829881.16265.20.camel@vessel>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-6aJt8eyJzRt4+KUAGHvl"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-6aJt8eyJzRt4+KUAGHvl
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Good morning folks,

I have a MD-RAID5 with 8 disks, 7 of them active, 1 spare. They are
connected to two SATA controllers, 4 disks each.

A few days ago, the disks connected to one of the controllers stopped
operating (some sort of controller hiccup, I guess). Now those disks are
marked as "possibly outdated" and the array refuses to assemble or
start, telling me there are only 4 out of 7 devices operational (See
attachment "assemble.status")

On boot, "/proc/mdstat" reports an inactive array with 7 spares, trying
to "mdadm --run" the array fails with the message mentioned above,
changing "/proc/mdstat" to now show an array of 4 disks. 

I tried "--add" with a missing device, getting the message "re-added
device /dev/sd...", but failing for subsequent devices with the message
"/dev/md0 failed to start, not adding device ..., You should stop and
re-assemble the array".
Then I tried "--assemble --scan --force", which yielded the same result
as above.

The next thing I would try is recreating the array with the layout
stored in the superblocks, but I was surprised to find it to be
inconsistent between the disks. I attached the output of "--examine
--verbose" as "raid.status". 

Could "--add"ing have changed one superblock, and can I safely try to
re-create the array with the layout given by /dev/sda and /dev/sdc?
Also, what parameters would I need to keep the layout (As mentioned in
the wiki at https://raid.wiki.kernel.org/index.php/RAID_Recovery)
consistent with the one I have now?


Thanks for your time!

Fabian



--=-6aJt8eyJzRt4+KUAGHvl
Content-Disposition: attachment; filename="assemble.status"
Content-Type: text/plain; name="assemble.status"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

mdadm: looking for devices for /dev/md0
mdadm: /dev/dm-0 is not one of /dev/sdi1,/dev/sdh1,/dev/sdg1,/dev/sdf1,/dev/sde1,/dev/sda1,/dev/sdb1,/dev/sdc1
mdadm: /dev/loop2 is not one of /dev/sdi1,/dev/sdh1,/dev/sdg1,/dev/sdf1,/dev/sde1,/dev/sda1,/dev/sdb1,/dev/sdc1
mdadm: /dev/loop1 is not one of /dev/sdi1,/dev/sdh1,/dev/sdg1,/dev/sdf1,/dev/sde1,/dev/sda1,/dev/sdb1,/dev/sdc1
mdadm: /dev/loop0 is not one of /dev/sdi1,/dev/sdh1,/dev/sdg1,/dev/sdf1,/dev/sde1,/dev/sda1,/dev/sdb1,/dev/sdc1
mdadm: /dev/sdj2 is not one of /dev/sdi1,/dev/sdh1,/dev/sdg1,/dev/sdf1,/dev/sde1,/dev/sda1,/dev/sdb1,/dev/sdc1
mdadm: /dev/sdj1 is not one of /dev/sdi1,/dev/sdh1,/dev/sdg1,/dev/sdf1,/dev/sde1,/dev/sda1,/dev/sdb1,/dev/sdc1
mdadm: /dev/sdj is not one of /dev/sdi1,/dev/sdh1,/dev/sdg1,/dev/sdf1,/dev/sde1,/dev/sda1,/dev/sdb1,/dev/sdc1
mdadm: /dev/sdi is not one of /dev/sdi1,/dev/sdh1,/dev/sdg1,/dev/sdf1,/dev/sde1,/dev/sda1,/dev/sdb1,/dev/sdc1
mdadm: /dev/sdh is not one of /dev/sdi1,/dev/sdh1,/dev/sdg1,/dev/sdf1,/dev/sde1,/dev/sda1,/dev/sdb1,/dev/sdc1
mdadm: /dev/sdg is not one of /dev/sdi1,/dev/sdh1,/dev/sdg1,/dev/sdf1,/dev/sde1,/dev/sda1,/dev/sdb1,/dev/sdc1
mdadm: /dev/sdf is not one of /dev/sdi1,/dev/sdh1,/dev/sdg1,/dev/sdf1,/dev/sde1,/dev/sda1,/dev/sdb1,/dev/sdc1
mdadm: /dev/sde is not one of /dev/sdi1,/dev/sdh1,/dev/sdg1,/dev/sdf1,/dev/sde1,/dev/sda1,/dev/sdb1,/dev/sdc1
mdadm: /dev/sdd1 is not one of /dev/sdi1,/dev/sdh1,/dev/sdg1,/dev/sdf1,/dev/sde1,/dev/sda1,/dev/sdb1,/dev/sdc1
mdadm: /dev/sdd is not one of /dev/sdi1,/dev/sdh1,/dev/sdg1,/dev/sdf1,/dev/sde1,/dev/sda1,/dev/sdb1,/dev/sdc1
mdadm: /dev/sda is not one of /dev/sdi1,/dev/sdh1,/dev/sdg1,/dev/sdf1,/dev/sde1,/dev/sda1,/dev/sdb1,/dev/sdc1
mdadm: /dev/sdb is not one of /dev/sdi1,/dev/sdh1,/dev/sdg1,/dev/sdf1,/dev/sde1,/dev/sda1,/dev/sdb1,/dev/sdc1
mdadm: /dev/sdc is not one of /dev/sdi1,/dev/sdh1,/dev/sdg1,/dev/sdf1,/dev/sde1,/dev/sda1,/dev/sdb1,/dev/sdc1
mdadm: /dev/sdi1 is identified as a member of /dev/md0, slot 3.
mdadm: /dev/sdh1 is identified as a member of /dev/md0, slot 2.
mdadm: /dev/sdg1 is identified as a member of /dev/md0, slot 1.
mdadm: /dev/sdf1 is identified as a member of /dev/md0, slot 0.
mdadm: /dev/sde1 is identified as a member of /dev/md0, slot 6.
mdadm: /dev/sda1 is identified as a member of /dev/md0, slot 4.
mdadm: /dev/sdb1 is identified as a member of /dev/md0, slot 4.
mdadm: /dev/sdc1 is identified as a member of /dev/md0, slot 5.
mdadm: added /dev/sdg1 to /dev/md0 as 1
mdadm: added /dev/sdh1 to /dev/md0 as 2
mdadm: added /dev/sdi1 to /dev/md0 as 3
mdadm: added /dev/sda1 to /dev/md0 as 4 (possibly out of date)
mdadm: added /dev/sdc1 to /dev/md0 as 5 (possibly out of date)
mdadm: added /dev/sde1 to /dev/md0 as 6 (possibly out of date)
mdadm: added /dev/sdf1 to /dev/md0 as 0
mdadm: /dev/md0 assembled from 4 drives - not enough to start the array.

--=-6aJt8eyJzRt4+KUAGHvl
Content-Disposition: attachment; filename="raid.status"
Content-Type: text/plain; name="raid.status"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

/dev/sda1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : cb5a6670:1b5d391f:edd8d016:611227ea
  Creation Time : Wed Jul 13 13:47:12 2011
     Raid Level : raid5
  Used Dev Size : 1953512448 (1863.01 GiB 2000.40 GB)
     Array Size : 11721074688 (11178.09 GiB 12002.38 GB)
   Raid Devices : 7
  Total Devices : 7
Preferred Minor : 0

    Update Time : Wed Jan  1 22:51:28 2014
          State : active
 Active Devices : 7
Working Devices : 7
 Failed Devices : 0
  Spare Devices : 0
       Checksum : f430c2a6 - correct
         Events : 24433

         Layout : left-symmetric
     Chunk Size : 1024K

      Number   Major   Minor   RaidDevice State
this     4       8        1        4      active sync   /dev/sda1

   0     0       8       65        0      active sync   /dev/sde1
   1     1       8       81        1      active sync   /dev/sdf1
   2     2       8       97        2      active sync   /dev/sdg1
   3     3       8      113        3      active sync   /dev/sdh1
   4     4       8        1        4      active sync   /dev/sda1
   5     5       8       33        5      active sync   /dev/sdc1
   6     6       8       49        6      active sync   /dev/sdd1
/dev/sdb1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : cb5a6670:1b5d391f:edd8d016:611227ea
  Creation Time : Wed Jul 13 13:47:12 2011
     Raid Level : raid5
  Used Dev Size : 1953512448 (1863.01 GiB 2000.40 GB)
     Array Size : 11721074688 (11178.09 GiB 12002.38 GB)
   Raid Devices : 7
  Total Devices : 8
Preferred Minor : 0

    Update Time : Sun Oct 27 15:00:43 2013
          State : active
 Active Devices : 7
Working Devices : 8
 Failed Devices : 0
  Spare Devices : 1
       Checksum : f3d95119 - correct
         Events : 24319

         Layout : left-symmetric
     Chunk Size : 1024K

      Number   Major   Minor   RaidDevice State
this     4       8       17        4      active sync   /dev/sdb1

   0     0       8       65        0      active sync   /dev/sde1
   1     1       8       81        1      active sync   /dev/sdf1
   2     2       8       97        2      active sync   /dev/sdg1
   3     3       8      113        3      active sync   /dev/sdh1
   4     4       8       17        4      active sync   /dev/sdb1
   5     5       8       33        5      active sync   /dev/sdc1
   6     6       8       49        6      active sync   /dev/sdd1
   7     7       8        1        7      spare   /dev/sda1
/dev/sdc1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : cb5a6670:1b5d391f:edd8d016:611227ea
  Creation Time : Wed Jul 13 13:47:12 2011
     Raid Level : raid5
  Used Dev Size : 1953512448 (1863.01 GiB 2000.40 GB)
     Array Size : 11721074688 (11178.09 GiB 12002.38 GB)
   Raid Devices : 7
  Total Devices : 7
Preferred Minor : 0

    Update Time : Wed Jan  1 22:51:28 2014
          State : active
 Active Devices : 7
Working Devices : 7
 Failed Devices : 0
  Spare Devices : 0
       Checksum : f430c2c8 - correct
         Events : 24433

         Layout : left-symmetric
     Chunk Size : 1024K

      Number   Major   Minor   RaidDevice State
this     5       8       33        5      active sync   /dev/sdc1

   0     0       8       65        0      active sync   /dev/sde1
   1     1       8       81        1      active sync   /dev/sdf1
   2     2       8       97        2      active sync   /dev/sdg1
   3     3       8      113        3      active sync   /dev/sdh1
   4     4       8        1        4      active sync   /dev/sda1
   5     5       8       33        5      active sync   /dev/sdc1
   6     6       8       49        6      active sync   /dev/sdd1
/dev/sde1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : cb5a6670:1b5d391f:edd8d016:611227ea
  Creation Time : Wed Jul 13 13:47:12 2011
     Raid Level : raid5
  Used Dev Size : 1953512448 (1863.01 GiB 2000.40 GB)
     Array Size : 11721074688 (11178.09 GiB 12002.38 GB)
   Raid Devices : 7
  Total Devices : 7
Preferred Minor : 0

    Update Time : Wed Jan  1 22:51:28 2014
          State : active
 Active Devices : 7
Working Devices : 7
 Failed Devices : 0
  Spare Devices : 0
       Checksum : f430c2da - correct
         Events : 24433

         Layout : left-symmetric
     Chunk Size : 1024K

      Number   Major   Minor   RaidDevice State
this     6       8       49        6      active sync   /dev/sdd1

   0     0       8       65        0      active sync   /dev/sde1
   1     1       8       81        1      active sync   /dev/sdf1
   2     2       8       97        2      active sync   /dev/sdg1
   3     3       8      113        3      active sync   /dev/sdh1
   4     4       8        1        4      active sync   /dev/sda1
   5     5       8       33        5      active sync   /dev/sdc1
   6     6       8       49        6      active sync   /dev/sdd1
/dev/sdf1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : cb5a6670:1b5d391f:edd8d016:611227ea
  Creation Time : Wed Jul 13 13:47:12 2011
     Raid Level : raid5
  Used Dev Size : 1953512448 (1863.01 GiB 2000.40 GB)
     Array Size : 11721074688 (11178.09 GiB 12002.38 GB)
   Raid Devices : 7
  Total Devices : 7
Preferred Minor : 0

    Update Time : Wed Jan  1 22:55:03 2014
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 3
  Spare Devices : 0
       Checksum : f43123f2 - correct
         Events : 24506

         Layout : left-symmetric
     Chunk Size : 1024K

      Number   Major   Minor   RaidDevice State
this     0       8       65        0      active sync   /dev/sde1

   0     0       8       65        0      active sync   /dev/sde1
   1     1       8       81        1      active sync   /dev/sdf1
   2     2       8       97        2      active sync   /dev/sdg1
   3     3       8      113        3      active sync   /dev/sdh1
   4     4       0        0        4      faulty removed
   5     5       0        0        5      faulty removed
   6     6       0        0        6      faulty removed
/dev/sdg1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : cb5a6670:1b5d391f:edd8d016:611227ea
  Creation Time : Wed Jul 13 13:47:12 2011
     Raid Level : raid5
  Used Dev Size : 1953512448 (1863.01 GiB 2000.40 GB)
     Array Size : 11721074688 (11178.09 GiB 12002.38 GB)
   Raid Devices : 7
  Total Devices : 7
Preferred Minor : 0

    Update Time : Wed Jan  1 22:55:03 2014
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 3
  Spare Devices : 0
       Checksum : f4312404 - correct
         Events : 24506

         Layout : left-symmetric
     Chunk Size : 1024K

      Number   Major   Minor   RaidDevice State
this     1       8       81        1      active sync   /dev/sdf1

   0     0       8       65        0      active sync   /dev/sde1
   1     1       8       81        1      active sync   /dev/sdf1
   2     2       8       97        2      active sync   /dev/sdg1
   3     3       8      113        3      active sync   /dev/sdh1
   4     4       0        0        4      faulty removed
   5     5       0        0        5      faulty removed
   6     6       0        0        6      faulty removed
/dev/sdh1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : cb5a6670:1b5d391f:edd8d016:611227ea
  Creation Time : Wed Jul 13 13:47:12 2011
     Raid Level : raid5
  Used Dev Size : 1953512448 (1863.01 GiB 2000.40 GB)
     Array Size : 11721074688 (11178.09 GiB 12002.38 GB)
   Raid Devices : 7
  Total Devices : 7
Preferred Minor : 0

    Update Time : Wed Jan  1 22:55:03 2014
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 3
  Spare Devices : 0
       Checksum : f4312416 - correct
         Events : 24506

         Layout : left-symmetric
     Chunk Size : 1024K

      Number   Major   Minor   RaidDevice State
this     2       8       97        2      active sync   /dev/sdg1

   0     0       8       65        0      active sync   /dev/sde1
   1     1       8       81        1      active sync   /dev/sdf1
   2     2       8       97        2      active sync   /dev/sdg1
   3     3       8      113        3      active sync   /dev/sdh1
   4     4       0        0        4      faulty removed
   5     5       0        0        5      faulty removed
   6     6       0        0        6      faulty removed
/dev/sdi1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : cb5a6670:1b5d391f:edd8d016:611227ea
  Creation Time : Wed Jul 13 13:47:12 2011
     Raid Level : raid5
  Used Dev Size : 1953512448 (1863.01 GiB 2000.40 GB)
     Array Size : 11721074688 (11178.09 GiB 12002.38 GB)
   Raid Devices : 7
  Total Devices : 7
Preferred Minor : 0

    Update Time : Wed Jan  1 22:55:03 2014
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 3
  Spare Devices : 0
       Checksum : f4312428 - correct
         Events : 24506

         Layout : left-symmetric
     Chunk Size : 1024K

      Number   Major   Minor   RaidDevice State
this     3       8      113        3      active sync   /dev/sdh1

   0     0       8       65        0      active sync   /dev/sde1
   1     1       8       81        1      active sync   /dev/sdf1
   2     2       8       97        2      active sync   /dev/sdg1
   3     3       8      113        3      active sync   /dev/sdh1
   4     4       0        0        4      faulty removed
   5     5       0        0        5      faulty removed
   6     6       0        0        6      faulty removed
/dev/sdj1:
   MBR Magic : aa55
Partition[0] :      1069056 sectors at            0 (type 00)
Partition[1] :        63488 sectors at        95576 (type ef)

--=-6aJt8eyJzRt4+KUAGHvl--

