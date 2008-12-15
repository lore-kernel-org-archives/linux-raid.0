From: Kevin Shanahan <kmshanah@disenchant.net>
Subject: Help recovering RAID6 failure
Date: Tue, 16 Dec 2008 08:33:08 +1030
Message-ID: <20081215220307.GE1749@cubit>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

My server seems to have had a bad night, and so I'm not having the
best morning. Overnight three drives failed in my RAID6 array. Worse,
that's on top of one failure I already knew about, so 4 drives in
total.

I put this down to problems with the controller - I had been using
3ware 9650 controllers (in JBOD mode). This morning I've loaded the
drives into another server connected to the on board Intel AHCI SATA
ports and an extra Sil3132 controller.

My first naive attempt was to try re-assembling the array from the
eight most up-to-date member devices:

hermes:~# mdadm -A /dev/md5 /dev/sd[cefghijk]1
mdadm: failed to RUN_ARRAY /dev/md5: Input/output error

I assume that's not an I/O error with the underlying device? I can't
see anything indicating that dmesg/syslog.

Output from "mdadm -E /dev/sd[cdefghijkl]1" included below.

Any advice would be much appreciated.

(and now, back to scouring the mail archives for clues).

Cheers,
Kevin.
--

/dev/sdc1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 77fa8675:444efef0:12f8dff0:9f609eb4
  Creation Time : Sun Jul 27 15:03:44 2008
     Raid Level : raid6
  Used Dev Size : 976759936 (931.51 GiB 1000.20 GB)
     Array Size : 7814079488 (7452.09 GiB 8001.62 GB)
   Raid Devices : 10
  Total Devices : 10
Preferred Minor : 5

    Update Time : Tue Dec 16 05:35:46 2008
          State : clean
Internal Bitmap : present
 Active Devices : 6
Working Devices : 6
 Failed Devices : 3
  Spare Devices : 0
       Checksum : e3df9eea - correct
         Events : 176870

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     8       8      129        8      active sync   /dev/sdi1

   0     0       0        0        0      removed
   1     1       0        0        1      faulty removed
   2     2       8       33        2      active sync   /dev/sdc1
   3     3       8       49        3      active sync   /dev/sdd1
   4     4       8       65        4      active sync   /dev/sde1
   5     5       8       81        5      active sync   /dev/sdf1
   6     6       8       97        6      active sync   /dev/sdg1
   7     7       0        0        7      faulty removed
   8     8       8      129        8      active sync   /dev/sdi1
   9     9       0        0        9      faulty removed
/dev/sdd1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 77fa8675:444efef0:12f8dff0:9f609eb4
  Creation Time : Sun Jul 27 15:03:44 2008
     Raid Level : raid6
  Used Dev Size : 976759936 (931.51 GiB 1000.20 GB)
     Array Size : 7814079488 (7452.09 GiB 8001.62 GB)
   Raid Devices : 10
  Total Devices : 10
Preferred Minor : 5

    Update Time : Thu Nov 27 09:20:39 2008
          State : clean
Internal Bitmap : present
 Active Devices : 10
Working Devices : 10
 Failed Devices : 0
  Spare Devices : 0
       Checksum : e3c42f8b - correct
         Events : 91974

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     9       8      145        9      active sync   /dev/sdj1

   0     0       8        1        0      active sync   /dev/sda1
   1     1       8       17        1      active sync   /dev/sdb1
   2     2       8       33        2      active sync   /dev/sdc1
   3     3       8       49        3      active sync   /dev/sdd1
   4     4       8       65        4      active sync   /dev/sde1
   5     5       8       81        5      active sync   /dev/sdf1
   6     6       8       97        6      active sync   /dev/sdg1
   7     7       8      113        7      active sync   /dev/sdh1
   8     8       8      129        8      active sync   /dev/sdi1
   9     9       8      145        9      active sync   /dev/sdj1
/dev/sde1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 77fa8675:444efef0:12f8dff0:9f609eb4
  Creation Time : Sun Jul 27 15:03:44 2008
     Raid Level : raid6
  Used Dev Size : 976759936 (931.51 GiB 1000.20 GB)
     Array Size : 7814079488 (7452.09 GiB 8001.62 GB)
   Raid Devices : 10
  Total Devices : 10
Preferred Minor : 5

    Update Time : Tue Dec 16 00:28:14 2008
          State : active
Internal Bitmap : present
 Active Devices : 8
Working Devices : 8
 Failed Devices : 2
  Spare Devices : 0
       Checksum : e3dca329 - correct
         Events : 176870

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     0       8        1        0      active sync   /dev/sda1

   0     0       8        1        0      active sync   /dev/sda1
   1     1       8       17        1      active sync   /dev/sdb1
   2     2       8       33        2      active sync   /dev/sdc1
   3     3       8       49        3      active sync   /dev/sdd1
   4     4       8       65        4      active sync   /dev/sde1
   5     5       8       81        5      active sync   /dev/sdf1
   6     6       8       97        6      active sync   /dev/sdg1
   7     7       0        0        7      faulty removed
   8     8       8      129        8      active sync   /dev/sdi1
   9     9       0        0        9      faulty removed
/dev/sdf1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 77fa8675:444efef0:12f8dff0:9f609eb4
  Creation Time : Sun Jul 27 15:03:44 2008
     Raid Level : raid6
  Used Dev Size : 976759936 (931.51 GiB 1000.20 GB)
     Array Size : 7814079488 (7452.09 GiB 8001.62 GB)
   Raid Devices : 10
  Total Devices : 10
Preferred Minor : 5

    Update Time : Tue Dec 16 00:29:00 2008
          State : active
Internal Bitmap : present
 Active Devices : 7
Working Devices : 7
 Failed Devices : 2
  Spare Devices : 0
       Checksum : e3dca382 - correct
         Events : 176870

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     1       8       17        1      active sync   /dev/sdb1

   0     0       0        0        0      removed
   1     1       8       17        1      active sync   /dev/sdb1
   2     2       8       33        2      active sync   /dev/sdc1
   3     3       8       49        3      active sync   /dev/sdd1
   4     4       8       65        4      active sync   /dev/sde1
   5     5       8       81        5      active sync   /dev/sdf1
   6     6       8       97        6      active sync   /dev/sdg1
   7     7       0        0        7      faulty removed
   8     8       8      129        8      active sync   /dev/sdi1
   9     9       0        0        9      faulty removed
/dev/sdg1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 77fa8675:444efef0:12f8dff0:9f609eb4
  Creation Time : Sun Jul 27 15:03:44 2008
     Raid Level : raid6
  Used Dev Size : 976759936 (931.51 GiB 1000.20 GB)
     Array Size : 7814079488 (7452.09 GiB 8001.62 GB)
   Raid Devices : 10
  Total Devices : 10
Preferred Minor : 5

    Update Time : Tue Dec 16 05:35:46 2008
          State : clean
Internal Bitmap : present
 Active Devices : 6
Working Devices : 6
 Failed Devices : 3
  Spare Devices : 0
       Checksum : e3df9e7e - correct
         Events : 176870

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     2       8       33        2      active sync   /dev/sdc1

   0     0       0        0        0      removed
   1     1       0        0        1      faulty removed
   2     2       8       33        2      active sync   /dev/sdc1
   3     3       8       49        3      active sync   /dev/sdd1
   4     4       8       65        4      active sync   /dev/sde1
   5     5       8       81        5      active sync   /dev/sdf1
   6     6       8       97        6      active sync   /dev/sdg1
   7     7       0        0        7      faulty removed
   8     8       8      129        8      active sync   /dev/sdi1
   9     9       0        0        9      faulty removed
/dev/sdh1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 77fa8675:444efef0:12f8dff0:9f609eb4
  Creation Time : Sun Jul 27 15:03:44 2008
     Raid Level : raid6
  Used Dev Size : 976759936 (931.51 GiB 1000.20 GB)
     Array Size : 7814079488 (7452.09 GiB 8001.62 GB)
   Raid Devices : 10
  Total Devices : 10
Preferred Minor : 5

    Update Time : Tue Dec 16 05:35:46 2008
          State : clean
Internal Bitmap : present
 Active Devices : 6
Working Devices : 6
 Failed Devices : 3
  Spare Devices : 0
       Checksum : e3df9ec6 - correct
         Events : 176870

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     6       8       97        6      active sync   /dev/sdg1

   0     0       0        0        0      removed
   1     1       0        0        1      faulty removed
   2     2       8       33        2      active sync   /dev/sdc1
   3     3       8       49        3      active sync   /dev/sdd1
   4     4       8       65        4      active sync   /dev/sde1
   5     5       8       81        5      active sync   /dev/sdf1
   6     6       8       97        6      active sync   /dev/sdg1
   7     7       0        0        7      faulty removed
   8     8       8      129        8      active sync   /dev/sdi1
   9     9       0        0        9      faulty removed
/dev/sdi1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 77fa8675:444efef0:12f8dff0:9f609eb4
  Creation Time : Sun Jul 27 15:03:44 2008
     Raid Level : raid6
  Used Dev Size : 976759936 (931.51 GiB 1000.20 GB)
     Array Size : 7814079488 (7452.09 GiB 8001.62 GB)
   Raid Devices : 10
  Total Devices : 10
Preferred Minor : 5

    Update Time : Tue Dec 16 05:35:46 2008
          State : clean
Internal Bitmap : present
 Active Devices : 6
Working Devices : 6
 Failed Devices : 3
  Spare Devices : 0
       Checksum : e3df9eb4 - correct
         Events : 176870

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     5       8       81        5      active sync   /dev/sdf1

   0     0       0        0        0      removed
   1     1       0        0        1      faulty removed
   2     2       8       33        2      active sync   /dev/sdc1
   3     3       8       49        3      active sync   /dev/sdd1
   4     4       8       65        4      active sync   /dev/sde1
   5     5       8       81        5      active sync   /dev/sdf1
   6     6       8       97        6      active sync   /dev/sdg1
   7     7       0        0        7      faulty removed
   8     8       8      129        8      active sync   /dev/sdi1
   9     9       0        0        9      faulty removed
/dev/sdj1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 77fa8675:444efef0:12f8dff0:9f609eb4
  Creation Time : Sun Jul 27 15:03:44 2008
     Raid Level : raid6
  Used Dev Size : 976759936 (931.51 GiB 1000.20 GB)
     Array Size : 7814079488 (7452.09 GiB 8001.62 GB)
   Raid Devices : 10
  Total Devices : 10
Preferred Minor : 5

    Update Time : Tue Dec 16 05:35:46 2008
          State : clean
Internal Bitmap : present
 Active Devices : 6
Working Devices : 6
 Failed Devices : 3
  Spare Devices : 0
       Checksum : e3df9ea2 - correct
         Events : 176870

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     4       8       65        4      active sync   /dev/sde1

   0     0       0        0        0      removed
   1     1       0        0        1      faulty removed
   2     2       8       33        2      active sync   /dev/sdc1
   3     3       8       49        3      active sync   /dev/sdd1
   4     4       8       65        4      active sync   /dev/sde1
   5     5       8       81        5      active sync   /dev/sdf1
   6     6       8       97        6      active sync   /dev/sdg1
   7     7       0        0        7      faulty removed
   8     8       8      129        8      active sync   /dev/sdi1
   9     9       0        0        9      faulty removed
/dev/sdk1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 77fa8675:444efef0:12f8dff0:9f609eb4
  Creation Time : Sun Jul 27 15:03:44 2008
     Raid Level : raid6
  Used Dev Size : 976759936 (931.51 GiB 1000.20 GB)
     Array Size : 7814079488 (7452.09 GiB 8001.62 GB)
   Raid Devices : 10
  Total Devices : 10
Preferred Minor : 5

    Update Time : Tue Dec 16 05:35:46 2008
          State : clean
Internal Bitmap : present
 Active Devices : 6
Working Devices : 6
 Failed Devices : 3
  Spare Devices : 0
       Checksum : e3df9e90 - correct
         Events : 176870

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     3       8       49        3      active sync   /dev/sdd1

   0     0       0        0        0      removed
   1     1       0        0        1      faulty removed
   2     2       8       33        2      active sync   /dev/sdc1
   3     3       8       49        3      active sync   /dev/sdd1
   4     4       8       65        4      active sync   /dev/sde1
   5     5       8       81        5      active sync   /dev/sdf1
   6     6       8       97        6      active sync   /dev/sdg1
   7     7       0        0        7      faulty removed
   8     8       8      129        8      active sync   /dev/sdi1
   9     9       0        0        9      faulty removed
/dev/sdl1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 77fa8675:444efef0:12f8dff0:9f609eb4
  Creation Time : Sun Jul 27 15:03:44 2008
     Raid Level : raid6
  Used Dev Size : 976759936 (931.51 GiB 1000.20 GB)
     Array Size : 7814079488 (7452.09 GiB 8001.62 GB)
   Raid Devices : 10
  Total Devices : 10
Preferred Minor : 5

    Update Time : Mon Dec 15 22:36:32 2008
          State : active
Internal Bitmap : present
 Active Devices : 9
Working Devices : 9
 Failed Devices : 1
  Spare Devices : 0
       Checksum : e3dc8525 - correct
         Events : 175787

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     7       8      113        7      active sync   /dev/sdh1

   0     0       8        1        0      active sync   /dev/sda1
   1     1       8       17        1      active sync   /dev/sdb1
   2     2       8       33        2      active sync   /dev/sdc1
   3     3       8       49        3      active sync   /dev/sdd1
   4     4       8       65        4      active sync   /dev/sde1
   5     5       8       81        5      active sync   /dev/sdf1
   6     6       8       97        6      active sync   /dev/sdg1
   7     7       8      113        7      active sync   /dev/sdh1
   8     8       8      129        8      active sync   /dev/sdi1
   9     9       0        0        9      faulty removed
