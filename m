From: "Thomas J. Baker" <tjb@unh.edu>
Subject: Any hope for a 27 disk RAID6+1HS array with four disks reporting
 "No md superblock detected"?
Date: Wed, 04 Feb 2009 14:27:37 -0500
Message-ID: <1233775657.10151.5.camel@localhost.localdomain>
Reply-To: tjb@unh.edu
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Any help greately appreciated. Here are the details:

[root@node002 ~]# ./examineRAIDDisks 
mdadm -E /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1 /dev/sdg1 /dev/sdh1 /dev/sdi1 /dev/sdj1 /dev/sdk1 /dev/sdl1 /dev/sdm1 /dev/sdn1 /dev/sdo1 /dev/sdp1 /dev/sdq1 /dev/sdr1 /dev/sds1 /dev/sdt1 /dev/sdu1 /dev/sdv1 /dev/sdw1 /dev/sdx1 /dev/sdy1 /dev/sdz1 /dev/sdaa1 /dev/sdab1 /dev/sdac1
/dev/sdb1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : c00b698c:0b2bc972:2fe4a5a3:e488dcec
  Creation Time : Thu Jun 28 05:16:13 2007
     Raid Level : raid6
  Used Dev Size : 292961216 (279.39 GiB 299.99 GB)
     Array Size : 7324030400 (6984.74 GiB 7499.81 GB)
   Raid Devices : 27
  Total Devices : 28
Preferred Minor : 0

    Update Time : Tue Jan 27 23:12:33 2009
          State : clean
 Active Devices : 20
Working Devices : 21
 Failed Devices : 7
  Spare Devices : 1
       Checksum : 2a4aa806 - correct
         Events : 0.12

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     0       8       17        0      active sync   /dev/sdb1

   0     0       8       17        0      active sync   /dev/sdb1
   1     1       8       33        1      active sync   /dev/sdc1
   2     2       8       49        2      active sync   /dev/sdd1
   3     3       8       65        3      active sync   /dev/sde1
   4     4       8       81        4      active sync   /dev/sdf1
   5     5       8       97        5      active sync   /dev/sdg1
   6     6       8      113        6      active sync   /dev/sdh1
   7     7       8      129        7      active sync   /dev/sdi1
   8     8       8      145        8      active sync   /dev/sdj1
   9     9       8      161        9      active sync   /dev/sdk1
  10    10       8      177       10      active sync   /dev/sdl1
  11    11       8      193       11      active sync   /dev/sdm1
  12    12       8      209       12      active sync   /dev/sdn1
  13    13       8      225       13      active sync   /dev/sdo1
  14    14       0        0       14      active sync
  15    15       0        0       15      active sync
  16    16       0        0       16      active sync
  17    17       0        0       17      active sync
  18    18       0        0       18      active sync
  19    19       0        0       19      active sync
  20    20       0        0       20      active sync
  21    21      65       97       21      active sync   /dev/sdw1
  22    22      65      113       22      active sync   /dev/sdx1
  23    23      65      129       23      active sync   /dev/sdy1
  24    24      65      145       24      active sync   /dev/sdz1
  25    25      65      161       25      active sync   /dev/sdaa1
  26    26      65      177       26      active sync   /dev/sdab1
  27     0       8       17        0      active sync   /dev/sdb1
/dev/sdc1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : c00b698c:0b2bc972:2fe4a5a3:e488dcec
  Creation Time : Thu Jun 28 05:16:13 2007
     Raid Level : raid6
  Used Dev Size : 292961216 (279.39 GiB 299.99 GB)
     Array Size : 7324030400 (6984.74 GiB 7499.81 GB)
   Raid Devices : 27
  Total Devices : 28
Preferred Minor : 0

    Update Time : Tue Jan 27 23:12:33 2009
          State : clean
 Active Devices : 20
Working Devices : 21
 Failed Devices : 7
  Spare Devices : 1
       Checksum : 2a4aa82d - correct
         Events : 0.12

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     1       8       33        1      active sync   /dev/sdc1

   0     0       8       17        0      active sync   /dev/sdb1
   1     1       8       33        1      active sync   /dev/sdc1
   2     2       8       49        2      active sync   /dev/sdd1
   3     3       8       65        3      active sync   /dev/sde1
   4     4       8       81        4      active sync   /dev/sdf1
   5     5       8       97        5      active sync   /dev/sdg1
   6     6       8      113        6      active sync   /dev/sdh1
   7     7       8      129        7      active sync   /dev/sdi1
   8     8       8      145        8      active sync   /dev/sdj1
   9     9       8      161        9      active sync   /dev/sdk1
  10    10       8      177       10      active sync   /dev/sdl1
  11    11       8      193       11      active sync   /dev/sdm1
  12    12       8      209       12      active sync   /dev/sdn1
  13    13       8      225       13      active sync   /dev/sdo1
  14    14       0        0       14      faulty removed
  15    15       0        0       15      faulty removed
  16    16       0        0       16      faulty removed
  17    17       0        0       17      faulty removed
  18    18       0        0       18      faulty removed
  19    19       0        0       19      faulty removed
  20    20       0        0       20      faulty removed
  21    21      65       97       21      active sync   /dev/sdw1
  22    22      65      113       22      active sync   /dev/sdx1
  23    23      65      129       23      active sync   /dev/sdy1
  24    24      65      145       24      active sync   /dev/sdz1
  25    25      65      161       25      active sync   /dev/sdaa1
  26    26      65      177       26      active sync   /dev/sdab1
  27     1       8       33        1      active sync   /dev/sdc1
/dev/sdd1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : c00b698c:0b2bc972:2fe4a5a3:e488dcec
  Creation Time : Thu Jun 28 05:16:13 2007
     Raid Level : raid6
  Used Dev Size : 292961216 (279.39 GiB 299.99 GB)
     Array Size : 7324030400 (6984.74 GiB 7499.81 GB)
   Raid Devices : 27
  Total Devices : 28
Preferred Minor : 0

    Update Time : Tue Jan 27 23:12:33 2009
          State : clean
 Active Devices : 20
Working Devices : 21
 Failed Devices : 7
  Spare Devices : 1
       Checksum : 2a4aa83f - correct
         Events : 0.12

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     2       8       49        2      active sync   /dev/sdd1

   0     0       8       17        0      active sync   /dev/sdb1
   1     1       8       33        1      active sync   /dev/sdc1
   2     2       8       49        2      active sync   /dev/sdd1
   3     3       8       65        3      active sync   /dev/sde1
   4     4       8       81        4      active sync   /dev/sdf1
   5     5       8       97        5      active sync   /dev/sdg1
   6     6       8      113        6      active sync   /dev/sdh1
   7     7       8      129        7      active sync   /dev/sdi1
   8     8       8      145        8      active sync   /dev/sdj1
   9     9       8      161        9      active sync   /dev/sdk1
  10    10       8      177       10      active sync   /dev/sdl1
  11    11       8      193       11      active sync   /dev/sdm1
  12    12       8      209       12      active sync   /dev/sdn1
  13    13       8      225       13      active sync   /dev/sdo1
  14    14       0        0       14      faulty removed
  15    15       0        0       15      faulty removed
  16    16       0        0       16      faulty removed
  17    17       0        0       17      faulty removed
  18    18       0        0       18      faulty removed
  19    19       0        0       19      faulty removed
  20    20       0        0       20      faulty removed
  21    21      65       97       21      active sync   /dev/sdw1
  22    22      65      113       22      active sync   /dev/sdx1
  23    23      65      129       23      active sync   /dev/sdy1
  24    24      65      145       24      active sync   /dev/sdz1
  25    25      65      161       25      active sync   /dev/sdaa1
  26    26      65      177       26      active sync   /dev/sdab1
  27     2       8       49        2      active sync   /dev/sdd1
/dev/sde1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : c00b698c:0b2bc972:2fe4a5a3:e488dcec
  Creation Time : Thu Jun 28 05:16:13 2007
     Raid Level : raid6
  Used Dev Size : 292961216 (279.39 GiB 299.99 GB)
     Array Size : 7324030400 (6984.74 GiB 7499.81 GB)
   Raid Devices : 27
  Total Devices : 28
Preferred Minor : 0

    Update Time : Tue Jan 27 23:12:33 2009
          State : clean
 Active Devices : 20
Working Devices : 21
 Failed Devices : 7
  Spare Devices : 1
       Checksum : 2a4aa851 - correct
         Events : 0.12

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     3       8       65        3      active sync   /dev/sde1

   0     0       8       17        0      active sync   /dev/sdb1
   1     1       8       33        1      active sync   /dev/sdc1
   2     2       8       49        2      active sync   /dev/sdd1
   3     3       8       65        3      active sync   /dev/sde1
   4     4       8       81        4      active sync   /dev/sdf1
   5     5       8       97        5      active sync   /dev/sdg1
   6     6       8      113        6      active sync   /dev/sdh1
   7     7       8      129        7      active sync   /dev/sdi1
   8     8       8      145        8      active sync   /dev/sdj1
   9     9       8      161        9      active sync   /dev/sdk1
  10    10       8      177       10      active sync   /dev/sdl1
  11    11       8      193       11      active sync   /dev/sdm1
  12    12       8      209       12      active sync   /dev/sdn1
  13    13       8      225       13      active sync   /dev/sdo1
  14    14       0        0       14      faulty removed
  15    15       0        0       15      faulty removed
  16    16       0        0       16      faulty removed
  17    17       0        0       17      faulty removed
  18    18       0        0       18      faulty removed
  19    19       0        0       19      faulty removed
  20    20       0        0       20      faulty removed
  21    21      65       97       21      active sync   /dev/sdw1
  22    22      65      113       22      active sync   /dev/sdx1
  23    23      65      129       23      active sync   /dev/sdy1
  24    24      65      145       24      active sync   /dev/sdz1
  25    25      65      161       25      active sync   /dev/sdaa1
  26    26      65      177       26      active sync   /dev/sdab1
  27     3       8       65        3      active sync   /dev/sde1
/dev/sdf1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : c00b698c:0b2bc972:2fe4a5a3:e488dcec
  Creation Time : Thu Jun 28 05:16:13 2007
     Raid Level : raid6
  Used Dev Size : 292961216 (279.39 GiB 299.99 GB)
     Array Size : 7324030400 (6984.74 GiB 7499.81 GB)
   Raid Devices : 27
  Total Devices : 28
Preferred Minor : 0

    Update Time : Tue Jan 27 23:12:33 2009
          State : clean
 Active Devices : 20
Working Devices : 21
 Failed Devices : 7
  Spare Devices : 1
       Checksum : 2a4aa863 - correct
         Events : 0.12

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     4       8       81        4      active sync   /dev/sdf1

   0     0       8       17        0      active sync   /dev/sdb1
   1     1       8       33        1      active sync   /dev/sdc1
   2     2       8       49        2      active sync   /dev/sdd1
   3     3       8       65        3      active sync   /dev/sde1
   4     4       8       81        4      active sync   /dev/sdf1
   5     5       8       97        5      active sync   /dev/sdg1
   6     6       8      113        6      active sync   /dev/sdh1
   7     7       8      129        7      active sync   /dev/sdi1
   8     8       8      145        8      active sync   /dev/sdj1
   9     9       8      161        9      active sync   /dev/sdk1
  10    10       8      177       10      active sync   /dev/sdl1
  11    11       8      193       11      active sync   /dev/sdm1
  12    12       8      209       12      active sync   /dev/sdn1
  13    13       8      225       13      active sync   /dev/sdo1
  14    14       0        0       14      faulty removed
  15    15       0        0       15      faulty removed
  16    16       0        0       16      faulty removed
  17    17       0        0       17      faulty removed
  18    18       0        0       18      faulty removed
  19    19       0        0       19      faulty removed
  20    20       0        0       20      faulty removed
  21    21      65       97       21      active sync   /dev/sdw1
  22    22      65      113       22      active sync   /dev/sdx1
  23    23      65      129       23      active sync   /dev/sdy1
  24    24      65      145       24      active sync   /dev/sdz1
  25    25      65      161       25      active sync   /dev/sdaa1
  26    26      65      177       26      active sync   /dev/sdab1
  27     4       8       81        4      active sync   /dev/sdf1
/dev/sdg1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : c00b698c:0b2bc972:2fe4a5a3:e488dcec
  Creation Time : Thu Jun 28 05:16:13 2007
     Raid Level : raid6
  Used Dev Size : 292961216 (279.39 GiB 299.99 GB)
     Array Size : 7324030400 (6984.74 GiB 7499.81 GB)
   Raid Devices : 27
  Total Devices : 28
Preferred Minor : 0

    Update Time : Tue Jan 27 23:12:33 2009
          State : clean
 Active Devices : 20
Working Devices : 21
 Failed Devices : 7
  Spare Devices : 1
       Checksum : 2a4aa875 - correct
         Events : 0.12

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     5       8       97        5      active sync   /dev/sdg1

   0     0       8       17        0      active sync   /dev/sdb1
   1     1       8       33        1      active sync   /dev/sdc1
   2     2       8       49        2      active sync   /dev/sdd1
   3     3       8       65        3      active sync   /dev/sde1
   4     4       8       81        4      active sync   /dev/sdf1
   5     5       8       97        5      active sync   /dev/sdg1
   6     6       8      113        6      active sync   /dev/sdh1
   7     7       8      129        7      active sync   /dev/sdi1
   8     8       8      145        8      active sync   /dev/sdj1
   9     9       8      161        9      active sync   /dev/sdk1
  10    10       8      177       10      active sync   /dev/sdl1
  11    11       8      193       11      active sync   /dev/sdm1
  12    12       8      209       12      active sync   /dev/sdn1
  13    13       8      225       13      active sync   /dev/sdo1
  14    14       0        0       14      faulty removed
  15    15       0        0       15      faulty removed
  16    16       0        0       16      faulty removed
  17    17       0        0       17      faulty removed
  18    18       0        0       18      faulty removed
  19    19       0        0       19      faulty removed
  20    20       0        0       20      faulty removed
  21    21      65       97       21      active sync   /dev/sdw1
  22    22      65      113       22      active sync   /dev/sdx1
  23    23      65      129       23      active sync   /dev/sdy1
  24    24      65      145       24      active sync   /dev/sdz1
  25    25      65      161       25      active sync   /dev/sdaa1
  26    26      65      177       26      active sync   /dev/sdab1
  27     5       8       97        5      active sync   /dev/sdg1
mdadm: No md superblock detected on /dev/sdh1.
/dev/sdi1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : c00b698c:0b2bc972:2fe4a5a3:e488dcec
  Creation Time : Thu Jun 28 05:16:13 2007
     Raid Level : raid6
  Used Dev Size : 292961216 (279.39 GiB 299.99 GB)
     Array Size : 7324030400 (6984.74 GiB 7499.81 GB)
   Raid Devices : 27
  Total Devices : 28
Preferred Minor : 0

    Update Time : Tue Jan 27 23:12:33 2009
          State : clean
 Active Devices : 20
Working Devices : 21
 Failed Devices : 7
  Spare Devices : 1
       Checksum : 2a4aa899 - correct
         Events : 0.12

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     7       8      129        7      active sync   /dev/sdi1

   0     0       8       17        0      active sync   /dev/sdb1
   1     1       8       33        1      active sync   /dev/sdc1
   2     2       8       49        2      active sync   /dev/sdd1
   3     3       8       65        3      active sync   /dev/sde1
   4     4       8       81        4      active sync   /dev/sdf1
   5     5       8       97        5      active sync   /dev/sdg1
   6     6       8      113        6      active sync   /dev/sdh1
   7     7       8      129        7      active sync   /dev/sdi1
   8     8       8      145        8      active sync   /dev/sdj1
   9     9       8      161        9      active sync   /dev/sdk1
  10    10       8      177       10      active sync   /dev/sdl1
  11    11       8      193       11      active sync   /dev/sdm1
  12    12       8      209       12      active sync   /dev/sdn1
  13    13       8      225       13      active sync   /dev/sdo1
  14    14       0        0       14      faulty removed
  15    15       0        0       15      faulty removed
  16    16       0        0       16      faulty removed
  17    17       0        0       17      faulty removed
  18    18       0        0       18      faulty removed
  19    19       0        0       19      faulty removed
  20    20       0        0       20      faulty removed
  21    21      65       97       21      active sync   /dev/sdw1
  22    22      65      113       22      active sync   /dev/sdx1
  23    23      65      129       23      active sync   /dev/sdy1
  24    24      65      145       24      active sync   /dev/sdz1
  25    25      65      161       25      active sync   /dev/sdaa1
  26    26      65      177       26      active sync   /dev/sdab1
  27     7       8      129        7      active sync   /dev/sdi1
mdadm: No md superblock detected on /dev/sdj1.
/dev/sdk1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : c00b698c:0b2bc972:2fe4a5a3:e488dcec
  Creation Time : Thu Jun 28 05:16:13 2007
     Raid Level : raid6
  Used Dev Size : 292961216 (279.39 GiB 299.99 GB)
     Array Size : 7324030400 (6984.74 GiB 7499.81 GB)
   Raid Devices : 27
  Total Devices : 28
Preferred Minor : 0

    Update Time : Tue Jan 27 23:12:33 2009
          State : clean
 Active Devices : 20
Working Devices : 21
 Failed Devices : 7
  Spare Devices : 1
       Checksum : 2a4aa8bd - correct
         Events : 0.12

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     9       8      161        9      active sync   /dev/sdk1

   0     0       8       17        0      active sync   /dev/sdb1
   1     1       8       33        1      active sync   /dev/sdc1
   2     2       8       49        2      active sync   /dev/sdd1
   3     3       8       65        3      active sync   /dev/sde1
   4     4       8       81        4      active sync   /dev/sdf1
   5     5       8       97        5      active sync   /dev/sdg1
   6     6       8      113        6      active sync   /dev/sdh1
   7     7       8      129        7      active sync   /dev/sdi1
   8     8       8      145        8      active sync   /dev/sdj1
   9     9       8      161        9      active sync   /dev/sdk1
  10    10       8      177       10      active sync   /dev/sdl1
  11    11       8      193       11      active sync   /dev/sdm1
  12    12       8      209       12      active sync   /dev/sdn1
  13    13       8      225       13      active sync   /dev/sdo1
  14    14       0        0       14      faulty removed
  15    15       0        0       15      faulty removed
  16    16       0        0       16      faulty removed
  17    17       0        0       17      faulty removed
  18    18       0        0       18      faulty removed
  19    19       0        0       19      faulty removed
  20    20       0        0       20      faulty removed
  21    21      65       97       21      active sync   /dev/sdw1
  22    22      65      113       22      active sync   /dev/sdx1
  23    23      65      129       23      active sync   /dev/sdy1
  24    24      65      145       24      active sync   /dev/sdz1
  25    25      65      161       25      active sync   /dev/sdaa1
  26    26      65      177       26      active sync   /dev/sdab1
  27     9       8      161        9      active sync   /dev/sdk1
/dev/sdl1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : c00b698c:0b2bc972:2fe4a5a3:e488dcec
  Creation Time : Thu Jun 28 05:16:13 2007
     Raid Level : raid6
  Used Dev Size : 292961216 (279.39 GiB 299.99 GB)
     Array Size : 7324030400 (6984.74 GiB 7499.81 GB)
   Raid Devices : 27
  Total Devices : 28
Preferred Minor : 0

    Update Time : Tue Jan 27 23:12:33 2009
          State : clean
 Active Devices : 20
Working Devices : 21
 Failed Devices : 7
  Spare Devices : 1
       Checksum : 2a4aa8cf - correct
         Events : 0.12

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this    10       8      177       10      active sync   /dev/sdl1

   0     0       8       17        0      active sync   /dev/sdb1
   1     1       8       33        1      active sync   /dev/sdc1
   2     2       8       49        2      active sync   /dev/sdd1
   3     3       8       65        3      active sync   /dev/sde1
   4     4       8       81        4      active sync   /dev/sdf1
   5     5       8       97        5      active sync   /dev/sdg1
   6     6       8      113        6      active sync   /dev/sdh1
   7     7       8      129        7      active sync   /dev/sdi1
   8     8       8      145        8      active sync   /dev/sdj1
   9     9       8      161        9      active sync   /dev/sdk1
  10    10       8      177       10      active sync   /dev/sdl1
  11    11       8      193       11      active sync   /dev/sdm1
  12    12       8      209       12      active sync   /dev/sdn1
  13    13       8      225       13      active sync   /dev/sdo1
  14    14       0        0       14      faulty removed
  15    15       0        0       15      faulty removed
  16    16       0        0       16      faulty removed
  17    17       0        0       17      faulty removed
  18    18       0        0       18      faulty removed
  19    19       0        0       19      faulty removed
  20    20       0        0       20      faulty removed
  21    21      65       97       21      active sync   /dev/sdw1
  22    22      65      113       22      active sync   /dev/sdx1
  23    23      65      129       23      active sync   /dev/sdy1
  24    24      65      145       24      active sync   /dev/sdz1
  25    25      65      161       25      active sync   /dev/sdaa1
  26    26      65      177       26      active sync   /dev/sdab1
  27    10       8      177       10      active sync   /dev/sdl1
/dev/sdm1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : c00b698c:0b2bc972:2fe4a5a3:e488dcec
  Creation Time : Thu Jun 28 05:16:13 2007
     Raid Level : raid6
  Used Dev Size : 292961216 (279.39 GiB 299.99 GB)
     Array Size : 7324030400 (6984.74 GiB 7499.81 GB)
   Raid Devices : 27
  Total Devices : 28
Preferred Minor : 0

    Update Time : Tue Jan 27 23:12:33 2009
          State : clean
 Active Devices : 20
Working Devices : 21
 Failed Devices : 7
  Spare Devices : 1
       Checksum : 2a4aa8e1 - correct
         Events : 0.12

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this    11       8      193       11      active sync   /dev/sdm1

   0     0       8       17        0      active sync   /dev/sdb1
   1     1       8       33        1      active sync   /dev/sdc1
   2     2       8       49        2      active sync   /dev/sdd1
   3     3       8       65        3      active sync   /dev/sde1
   4     4       8       81        4      active sync   /dev/sdf1
   5     5       8       97        5      active sync   /dev/sdg1
   6     6       8      113        6      active sync   /dev/sdh1
   7     7       8      129        7      active sync   /dev/sdi1
   8     8       8      145        8      active sync   /dev/sdj1
   9     9       8      161        9      active sync   /dev/sdk1
  10    10       8      177       10      active sync   /dev/sdl1
  11    11       8      193       11      active sync   /dev/sdm1
  12    12       8      209       12      active sync   /dev/sdn1
  13    13       8      225       13      active sync   /dev/sdo1
  14    14       0        0       14      faulty removed
  15    15       0        0       15      faulty removed
  16    16       0        0       16      faulty removed
  17    17       0        0       17      faulty removed
  18    18       0        0       18      faulty removed
  19    19       0        0       19      faulty removed
  20    20       0        0       20      faulty removed
  21    21      65       97       21      active sync   /dev/sdw1
  22    22      65      113       22      active sync   /dev/sdx1
  23    23      65      129       23      active sync   /dev/sdy1
  24    24      65      145       24      active sync   /dev/sdz1
  25    25      65      161       25      active sync   /dev/sdaa1
  26    26      65      177       26      active sync   /dev/sdab1
  27    11       8      193       11      active sync   /dev/sdm1
/dev/sdn1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : c00b698c:0b2bc972:2fe4a5a3:e488dcec
  Creation Time : Thu Jun 28 05:16:13 2007
     Raid Level : raid6
  Used Dev Size : 292961216 (279.39 GiB 299.99 GB)
     Array Size : 7324030400 (6984.74 GiB 7499.81 GB)
   Raid Devices : 27
  Total Devices : 28
Preferred Minor : 0

    Update Time : Tue Jan 27 23:12:33 2009
          State : clean
 Active Devices : 20
Working Devices : 21
 Failed Devices : 7
  Spare Devices : 1
       Checksum : 2a4aa8f3 - correct
         Events : 0.12

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this    12       8      209       12      active sync   /dev/sdn1

   0     0       8       17        0      active sync   /dev/sdb1
   1     1       8       33        1      active sync   /dev/sdc1
   2     2       8       49        2      active sync   /dev/sdd1
   3     3       8       65        3      active sync   /dev/sde1
   4     4       8       81        4      active sync   /dev/sdf1
   5     5       8       97        5      active sync   /dev/sdg1
   6     6       8      113        6      active sync   /dev/sdh1
   7     7       8      129        7      active sync   /dev/sdi1
   8     8       8      145        8      active sync   /dev/sdj1
   9     9       8      161        9      active sync   /dev/sdk1
  10    10       8      177       10      active sync   /dev/sdl1
  11    11       8      193       11      active sync   /dev/sdm1
  12    12       8      209       12      active sync   /dev/sdn1
  13    13       8      225       13      active sync   /dev/sdo1
  14    14       0        0       14      faulty removed
  15    15       0        0       15      faulty removed
  16    16       0        0       16      faulty removed
  17    17       0        0       17      faulty removed
  18    18       0        0       18      faulty removed
  19    19       0        0       19      faulty removed
  20    20       0        0       20      faulty removed
  21    21      65       97       21      active sync   /dev/sdw1
  22    22      65      113       22      active sync   /dev/sdx1
  23    23      65      129       23      active sync   /dev/sdy1
  24    24      65      145       24      active sync   /dev/sdz1
  25    25      65      161       25      active sync   /dev/sdaa1
  26    26      65      177       26      active sync   /dev/sdab1
  27    12       8      209       12      active sync   /dev/sdn1
/dev/sdo1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : c00b698c:0b2bc972:2fe4a5a3:e488dcec
  Creation Time : Thu Jun 28 05:16:13 2007
     Raid Level : raid6
  Used Dev Size : 292961216 (279.39 GiB 299.99 GB)
     Array Size : 7324030400 (6984.74 GiB 7499.81 GB)
   Raid Devices : 27
  Total Devices : 28
Preferred Minor : 0

    Update Time : Tue Jan 27 23:12:33 2009
          State : clean
 Active Devices : 20
Working Devices : 21
 Failed Devices : 7
  Spare Devices : 1
       Checksum : 2a4aa905 - correct
         Events : 0.12

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this    13       8      225       13      active sync   /dev/sdo1

   0     0       8       17        0      active sync   /dev/sdb1
   1     1       8       33        1      active sync   /dev/sdc1
   2     2       8       49        2      active sync   /dev/sdd1
   3     3       8       65        3      active sync   /dev/sde1
   4     4       8       81        4      active sync   /dev/sdf1
   5     5       8       97        5      active sync   /dev/sdg1
   6     6       8      113        6      active sync   /dev/sdh1
   7     7       8      129        7      active sync   /dev/sdi1
   8     8       8      145        8      active sync   /dev/sdj1
   9     9       8      161        9      active sync   /dev/sdk1
  10    10       8      177       10      active sync   /dev/sdl1
  11    11       8      193       11      active sync   /dev/sdm1
  12    12       8      209       12      active sync   /dev/sdn1
  13    13       8      225       13      active sync   /dev/sdo1
  14    14       0        0       14      faulty removed
  15    15       0        0       15      faulty removed
  16    16       0        0       16      faulty removed
  17    17       0        0       17      faulty removed
  18    18       0        0       18      faulty removed
  19    19       0        0       19      faulty removed
  20    20       0        0       20      faulty removed
  21    21      65       97       21      active sync   /dev/sdw1
  22    22      65      113       22      active sync   /dev/sdx1
  23    23      65      129       23      active sync   /dev/sdy1
  24    24      65      145       24      active sync   /dev/sdz1
  25    25      65      161       25      active sync   /dev/sdaa1
  26    26      65      177       26      active sync   /dev/sdab1
  27    13       8      225       13      active sync   /dev/sdo1
/dev/sdp1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : c00b698c:0b2bc972:2fe4a5a3:e488dcec
  Creation Time : Thu Jun 28 05:16:13 2007
     Raid Level : raid6
  Used Dev Size : 292961216 (279.39 GiB 299.99 GB)
     Array Size : 7324030400 (6984.74 GiB 7499.81 GB)
   Raid Devices : 27
  Total Devices : 28
Preferred Minor : 0

    Update Time : Tue Jan 27 23:12:33 2009
          State : clean
 Active Devices : 20
Working Devices : 21
 Failed Devices : 7
  Spare Devices : 1
       Checksum : 2a4aa8ce - correct
         Events : 0.12

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this    21      65       97       21      active sync   /dev/sdw1

   0     0       8       17        0      active sync   /dev/sdb1
   1     1       8       33        1      active sync   /dev/sdc1
   2     2       8       49        2      active sync   /dev/sdd1
   3     3       8       65        3      active sync   /dev/sde1
   4     4       8       81        4      active sync   /dev/sdf1
   5     5       8       97        5      active sync   /dev/sdg1
   6     6       8      113        6      active sync   /dev/sdh1
   7     7       8      129        7      active sync   /dev/sdi1
   8     8       8      145        8      active sync   /dev/sdj1
   9     9       8      161        9      active sync   /dev/sdk1
  10    10       8      177       10      active sync   /dev/sdl1
  11    11       8      193       11      active sync   /dev/sdm1
  12    12       8      209       12      active sync   /dev/sdn1
  13    13       8      225       13      active sync   /dev/sdo1
  14    14       0        0       14      faulty removed
  15    15       0        0       15      faulty removed
  16    16       0        0       16      faulty removed
  17    17       0        0       17      faulty removed
  18    18       0        0       18      faulty removed
  19    19       0        0       19      faulty removed
  20    20       0        0       20      faulty removed
  21    21      65       97       21      active sync   /dev/sdw1
  22    22      65      113       22      active sync   /dev/sdx1
  23    23      65      129       23      active sync   /dev/sdy1
  24    24      65      145       24      active sync   /dev/sdz1
  25    25      65      161       25      active sync   /dev/sdaa1
  26    26      65      177       26      active sync   /dev/sdab1
  27    21      65       97       21      active sync   /dev/sdw1
/dev/sdq1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : c00b698c:0b2bc972:2fe4a5a3:e488dcec
  Creation Time : Thu Jun 28 05:16:13 2007
     Raid Level : raid6
  Used Dev Size : 292961216 (279.39 GiB 299.99 GB)
     Array Size : 7324030400 (6984.74 GiB 7499.81 GB)
   Raid Devices : 27
  Total Devices : 28
Preferred Minor : 0

    Update Time : Tue Jan 27 23:12:33 2009
          State : clean
 Active Devices : 20
Working Devices : 21
 Failed Devices : 7
  Spare Devices : 1
       Checksum : 2a4aa8e0 - correct
         Events : 0.12

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this    22      65      113       22      active sync   /dev/sdx1

   0     0       8       17        0      active sync   /dev/sdb1
   1     1       8       33        1      active sync   /dev/sdc1
   2     2       8       49        2      active sync   /dev/sdd1
   3     3       8       65        3      active sync   /dev/sde1
   4     4       8       81        4      active sync   /dev/sdf1
   5     5       8       97        5      active sync   /dev/sdg1
   6     6       8      113        6      active sync   /dev/sdh1
   7     7       8      129        7      active sync   /dev/sdi1
   8     8       8      145        8      active sync   /dev/sdj1
   9     9       8      161        9      active sync   /dev/sdk1
  10    10       8      177       10      active sync   /dev/sdl1
  11    11       8      193       11      active sync   /dev/sdm1
  12    12       8      209       12      active sync   /dev/sdn1
  13    13       8      225       13      active sync   /dev/sdo1
  14    14       0        0       14      faulty removed
  15    15       0        0       15      faulty removed
  16    16       0        0       16      faulty removed
  17    17       0        0       17      faulty removed
  18    18       0        0       18      faulty removed
  19    19       0        0       19      faulty removed
  20    20       0        0       20      faulty removed
  21    21      65       97       21      active sync   /dev/sdw1
  22    22      65      113       22      active sync   /dev/sdx1
  23    23      65      129       23      active sync   /dev/sdy1
  24    24      65      145       24      active sync   /dev/sdz1
  25    25      65      161       25      active sync   /dev/sdaa1
  26    26      65      177       26      active sync   /dev/sdab1
  27    22      65      113       22      active sync   /dev/sdx1
/dev/sdr1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : c00b698c:0b2bc972:2fe4a5a3:e488dcec
  Creation Time : Thu Jun 28 05:16:13 2007
     Raid Level : raid6
  Used Dev Size : 292961216 (279.39 GiB 299.99 GB)
     Array Size : 7324030400 (6984.74 GiB 7499.81 GB)
   Raid Devices : 27
  Total Devices : 28
Preferred Minor : 0

    Update Time : Tue Jan 27 23:12:33 2009
          State : clean
 Active Devices : 20
Working Devices : 21
 Failed Devices : 7
  Spare Devices : 1
       Checksum : 2a4aa8f2 - correct
         Events : 0.12

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this    23      65      129       23      active sync   /dev/sdy1

   0     0       8       17        0      active sync   /dev/sdb1
   1     1       8       33        1      active sync   /dev/sdc1
   2     2       8       49        2      active sync   /dev/sdd1
   3     3       8       65        3      active sync   /dev/sde1
   4     4       8       81        4      active sync   /dev/sdf1
   5     5       8       97        5      active sync   /dev/sdg1
   6     6       8      113        6      active sync   /dev/sdh1
   7     7       8      129        7      active sync   /dev/sdi1
   8     8       8      145        8      active sync   /dev/sdj1
   9     9       8      161        9      active sync   /dev/sdk1
  10    10       8      177       10      active sync   /dev/sdl1
  11    11       8      193       11      active sync   /dev/sdm1
  12    12       8      209       12      active sync   /dev/sdn1
  13    13       8      225       13      active sync   /dev/sdo1
  14    14       0        0       14      faulty removed
  15    15       0        0       15      faulty removed
  16    16       0        0       16      faulty removed
  17    17       0        0       17      faulty removed
  18    18       0        0       18      faulty removed
  19    19       0        0       19      faulty removed
  20    20       0        0       20      faulty removed
  21    21      65       97       21      active sync   /dev/sdw1
  22    22      65      113       22      active sync   /dev/sdx1
  23    23      65      129       23      active sync   /dev/sdy1
  24    24      65      145       24      active sync   /dev/sdz1
  25    25      65      161       25      active sync   /dev/sdaa1
  26    26      65      177       26      active sync   /dev/sdab1
  27    23      65      129       23      active sync   /dev/sdy1
mdadm: No md superblock detected on /dev/sds1.
/dev/sdt1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : c00b698c:0b2bc972:2fe4a5a3:e488dcec
  Creation Time : Thu Jun 28 05:16:13 2007
     Raid Level : raid6
  Used Dev Size : 292961216 (279.39 GiB 299.99 GB)
     Array Size : 7324030400 (6984.74 GiB 7499.81 GB)
   Raid Devices : 27
  Total Devices : 28
Preferred Minor : 0

    Update Time : Tue Jan 27 23:12:33 2009
          State : clean
 Active Devices : 20
Working Devices : 21
 Failed Devices : 7
  Spare Devices : 1
       Checksum : 2a4aa916 - correct
         Events : 0.12

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this    25      65      161       25      active sync   /dev/sdaa1

   0     0       8       17        0      active sync   /dev/sdb1
   1     1       8       33        1      active sync   /dev/sdc1
   2     2       8       49        2      active sync   /dev/sdd1
   3     3       8       65        3      active sync   /dev/sde1
   4     4       8       81        4      active sync   /dev/sdf1
   5     5       8       97        5      active sync   /dev/sdg1
   6     6       8      113        6      active sync   /dev/sdh1
   7     7       8      129        7      active sync   /dev/sdi1
   8     8       8      145        8      active sync   /dev/sdj1
   9     9       8      161        9      active sync   /dev/sdk1
  10    10       8      177       10      active sync   /dev/sdl1
  11    11       8      193       11      active sync   /dev/sdm1
  12    12       8      209       12      active sync   /dev/sdn1
  13    13       8      225       13      active sync   /dev/sdo1
  14    14       0        0       14      faulty removed
  15    15       0        0       15      faulty removed
  16    16       0        0       16      faulty removed
  17    17       0        0       17      faulty removed
  18    18       0        0       18      faulty removed
  19    19       0        0       19      faulty removed
  20    20       0        0       20      faulty removed
  21    21      65       97       21      active sync   /dev/sdw1
  22    22      65      113       22      active sync   /dev/sdx1
  23    23      65      129       23      active sync   /dev/sdy1
  24    24      65      145       24      active sync   /dev/sdz1
  25    25      65      161       25      active sync   /dev/sdaa1
  26    26      65      177       26      active sync   /dev/sdab1
  27    25      65      161       25      active sync   /dev/sdaa1
/dev/sdu1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : c00b698c:0b2bc972:2fe4a5a3:e488dcec
  Creation Time : Thu Jun 28 05:16:13 2007
     Raid Level : raid6
  Used Dev Size : 292961216 (279.39 GiB 299.99 GB)
     Array Size : 7324030400 (6984.74 GiB 7499.81 GB)
   Raid Devices : 27
  Total Devices : 28
Preferred Minor : 0

    Update Time : Tue Jan 27 23:12:33 2009
          State : clean
 Active Devices : 20
Working Devices : 21
 Failed Devices : 7
  Spare Devices : 1
       Checksum : 2a4aa928 - correct
         Events : 0.12

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this    26      65      177       26      active sync   /dev/sdab1

   0     0       8       17        0      active sync   /dev/sdb1
   1     1       8       33        1      active sync   /dev/sdc1
   2     2       8       49        2      active sync   /dev/sdd1
   3     3       8       65        3      active sync   /dev/sde1
   4     4       8       81        4      active sync   /dev/sdf1
   5     5       8       97        5      active sync   /dev/sdg1
   6     6       8      113        6      active sync   /dev/sdh1
   7     7       8      129        7      active sync   /dev/sdi1
   8     8       8      145        8      active sync   /dev/sdj1
   9     9       8      161        9      active sync   /dev/sdk1
  10    10       8      177       10      active sync   /dev/sdl1
  11    11       8      193       11      active sync   /dev/sdm1
  12    12       8      209       12      active sync   /dev/sdn1
  13    13       8      225       13      active sync   /dev/sdo1
  14    14       0        0       14      faulty removed
  15    15       0        0       15      faulty removed
  16    16       0        0       16      faulty removed
  17    17       0        0       17      faulty removed
  18    18       0        0       18      faulty removed
  19    19       0        0       19      faulty removed
  20    20       0        0       20      faulty removed
  21    21      65       97       21      active sync   /dev/sdw1
  22    22      65      113       22      active sync   /dev/sdx1
  23    23      65      129       23      active sync   /dev/sdy1
  24    24      65      145       24      active sync   /dev/sdz1
  25    25      65      161       25      active sync   /dev/sdaa1
  26    26      65      177       26      active sync   /dev/sdab1
  27    26      65      177       26      active sync   /dev/sdab1
mdadm: No md superblock detected on /dev/sdv1.
/dev/sdw1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : c00b698c:0b2bc972:2fe4a5a3:e488dcec
  Creation Time : Thu Jun 28 05:16:13 2007
     Raid Level : raid6
  Used Dev Size : 292961216 (279.39 GiB 299.99 GB)
     Array Size : 7324030400 (6984.74 GiB 7499.81 GB)
   Raid Devices : 27
  Total Devices : 28
Preferred Minor : 0

    Update Time : Mon Jan 26 14:03:23 2009
          State : clean
 Active Devices : 27
Working Devices : 28
 Failed Devices : 0
  Spare Devices : 1
       Checksum : 2a48da42 - correct
         Events : 0.12

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this    14       8      241       14      active sync   /dev/sdp1

   0     0       8       17        0      active sync   /dev/sdb1
   1     1       8       33        1      active sync   /dev/sdc1
   2     2       8       49        2      active sync   /dev/sdd1
   3     3       8       65        3      active sync   /dev/sde1
   4     4       8       81        4      active sync   /dev/sdf1
   5     5       8       97        5      active sync   /dev/sdg1
   6     6       8      113        6      active sync   /dev/sdh1
   7     7       8      129        7      active sync   /dev/sdi1
   8     8       8      145        8      active sync   /dev/sdj1
   9     9       8      161        9      active sync   /dev/sdk1
  10    10       8      177       10      active sync   /dev/sdl1
  11    11       8      193       11      active sync   /dev/sdm1
  12    12       8      209       12      active sync   /dev/sdn1
  13    13       8      225       13      active sync   /dev/sdo1
  14    14       8      241       14      active sync   /dev/sdp1
  15    15      65        1       15      active sync   /dev/sdq1
  16    16      65       17       16      active sync   /dev/sdr1
  17    17      65       33       17      active sync   /dev/sds1
  18    18      65       49       18      active sync   /dev/sdt1
  19    19      65       65       19      active sync   /dev/sdu1
  20    20      65       81       20      active sync   /dev/sdv1
  21    21      65       97       21      active sync   /dev/sdw1
  22    22      65      113       22      active sync   /dev/sdx1
  23    23      65      129       23      active sync   /dev/sdy1
  24    24      65      145       24      active sync   /dev/sdz1
  25    25      65      161       25      active sync   /dev/sdaa1
  26    26      65      177       26      active sync   /dev/sdab1
  27    14       8      241       14      active sync   /dev/sdp1
/dev/sdx1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : c00b698c:0b2bc972:2fe4a5a3:e488dcec
  Creation Time : Thu Jun 28 05:16:13 2007
     Raid Level : raid6
  Used Dev Size : 292961216 (279.39 GiB 299.99 GB)
     Array Size : 7324030400 (6984.74 GiB 7499.81 GB)
   Raid Devices : 27
  Total Devices : 28
Preferred Minor : 0

    Update Time : Mon Jan 26 14:03:23 2009
          State : clean
 Active Devices : 27
Working Devices : 28
 Failed Devices : 0
  Spare Devices : 1
       Checksum : 2a48d98d - correct
         Events : 0.12

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this    15      65        1       15      active sync   /dev/sdq1

   0     0       8       17        0      active sync   /dev/sdb1
   1     1       8       33        1      active sync   /dev/sdc1
   2     2       8       49        2      active sync   /dev/sdd1
   3     3       8       65        3      active sync   /dev/sde1
   4     4       8       81        4      active sync   /dev/sdf1
   5     5       8       97        5      active sync   /dev/sdg1
   6     6       8      113        6      active sync   /dev/sdh1
   7     7       8      129        7      active sync   /dev/sdi1
   8     8       8      145        8      active sync   /dev/sdj1
   9     9       8      161        9      active sync   /dev/sdk1
  10    10       8      177       10      active sync   /dev/sdl1
  11    11       8      193       11      active sync   /dev/sdm1
  12    12       8      209       12      active sync   /dev/sdn1
  13    13       8      225       13      active sync   /dev/sdo1
  14    14       8      241       14      active sync   /dev/sdp1
  15    15      65        1       15      active sync   /dev/sdq1
  16    16      65       17       16      active sync   /dev/sdr1
  17    17      65       33       17      active sync   /dev/sds1
  18    18      65       49       18      active sync   /dev/sdt1
  19    19      65       65       19      active sync   /dev/sdu1
  20    20      65       81       20      active sync   /dev/sdv1
  21    21      65       97       21      active sync   /dev/sdw1
  22    22      65      113       22      active sync   /dev/sdx1
  23    23      65      129       23      active sync   /dev/sdy1
  24    24      65      145       24      active sync   /dev/sdz1
  25    25      65      161       25      active sync   /dev/sdaa1
  26    26      65      177       26      active sync   /dev/sdab1
  27    15      65        1       15      active sync   /dev/sdq1
/dev/sdy1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : c00b698c:0b2bc972:2fe4a5a3:e488dcec
  Creation Time : Thu Jun 28 05:16:13 2007
     Raid Level : raid6
  Used Dev Size : 292961216 (279.39 GiB 299.99 GB)
     Array Size : 7324030400 (6984.74 GiB 7499.81 GB)
   Raid Devices : 27
  Total Devices : 28
Preferred Minor : 0

    Update Time : Mon Jan 26 14:03:23 2009
          State : clean
 Active Devices : 27
Working Devices : 28
 Failed Devices : 0
  Spare Devices : 1
       Checksum : 2a48d99f - correct
         Events : 0.12

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this    16      65       17       16      active sync   /dev/sdr1

   0     0       8       17        0      active sync   /dev/sdb1
   1     1       8       33        1      active sync   /dev/sdc1
   2     2       8       49        2      active sync   /dev/sdd1
   3     3       8       65        3      active sync   /dev/sde1
   4     4       8       81        4      active sync   /dev/sdf1
   5     5       8       97        5      active sync   /dev/sdg1
   6     6       8      113        6      active sync   /dev/sdh1
   7     7       8      129        7      active sync   /dev/sdi1
   8     8       8      145        8      active sync   /dev/sdj1
   9     9       8      161        9      active sync   /dev/sdk1
  10    10       8      177       10      active sync   /dev/sdl1
  11    11       8      193       11      active sync   /dev/sdm1
  12    12       8      209       12      active sync   /dev/sdn1
  13    13       8      225       13      active sync   /dev/sdo1
  14    14       8      241       14      active sync   /dev/sdp1
  15    15      65        1       15      active sync   /dev/sdq1
  16    16      65       17       16      active sync   /dev/sdr1
  17    17      65       33       17      active sync   /dev/sds1
  18    18      65       49       18      active sync   /dev/sdt1
  19    19      65       65       19      active sync   /dev/sdu1
  20    20      65       81       20      active sync   /dev/sdv1
  21    21      65       97       21      active sync   /dev/sdw1
  22    22      65      113       22      active sync   /dev/sdx1
  23    23      65      129       23      active sync   /dev/sdy1
  24    24      65      145       24      active sync   /dev/sdz1
  25    25      65      161       25      active sync   /dev/sdaa1
  26    26      65      177       26      active sync   /dev/sdab1
  27    16      65       17       16      active sync   /dev/sdr1
/dev/sdz1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : c00b698c:0b2bc972:2fe4a5a3:e488dcec
  Creation Time : Thu Jun 28 05:16:13 2007
     Raid Level : raid6
  Used Dev Size : 292961216 (279.39 GiB 299.99 GB)
     Array Size : 7324030400 (6984.74 GiB 7499.81 GB)
   Raid Devices : 27
  Total Devices : 28
Preferred Minor : 0

    Update Time : Mon Jan 26 14:03:23 2009
          State : clean
 Active Devices : 27
Working Devices : 28
 Failed Devices : 0
  Spare Devices : 1
       Checksum : 2a48d9b1 - correct
         Events : 0.12

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this    17      65       33       17      active sync   /dev/sds1

   0     0       8       17        0      active sync   /dev/sdb1
   1     1       8       33        1      active sync   /dev/sdc1
   2     2       8       49        2      active sync   /dev/sdd1
   3     3       8       65        3      active sync   /dev/sde1
   4     4       8       81        4      active sync   /dev/sdf1
   5     5       8       97        5      active sync   /dev/sdg1
   6     6       8      113        6      active sync   /dev/sdh1
   7     7       8      129        7      active sync   /dev/sdi1
   8     8       8      145        8      active sync   /dev/sdj1
   9     9       8      161        9      active sync   /dev/sdk1
  10    10       8      177       10      active sync   /dev/sdl1
  11    11       8      193       11      active sync   /dev/sdm1
  12    12       8      209       12      active sync   /dev/sdn1
  13    13       8      225       13      active sync   /dev/sdo1
  14    14       8      241       14      active sync   /dev/sdp1
  15    15      65        1       15      active sync   /dev/sdq1
  16    16      65       17       16      active sync   /dev/sdr1
  17    17      65       33       17      active sync   /dev/sds1
  18    18      65       49       18      active sync   /dev/sdt1
  19    19      65       65       19      active sync   /dev/sdu1
  20    20      65       81       20      active sync   /dev/sdv1
  21    21      65       97       21      active sync   /dev/sdw1
  22    22      65      113       22      active sync   /dev/sdx1
  23    23      65      129       23      active sync   /dev/sdy1
  24    24      65      145       24      active sync   /dev/sdz1
  25    25      65      161       25      active sync   /dev/sdaa1
  26    26      65      177       26      active sync   /dev/sdab1
  27    17      65       33       17      active sync   /dev/sds1
/dev/sdaa1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : c00b698c:0b2bc972:2fe4a5a3:e488dcec
  Creation Time : Thu Jun 28 05:16:13 2007
     Raid Level : raid6
  Used Dev Size : 292961216 (279.39 GiB 299.99 GB)
     Array Size : 7324030400 (6984.74 GiB 7499.81 GB)
   Raid Devices : 27
  Total Devices : 28
Preferred Minor : 0

    Update Time : Mon Jan 26 14:03:23 2009
          State : clean
 Active Devices : 27
Working Devices : 28
 Failed Devices : 0
  Spare Devices : 1
       Checksum : 2a48d9c3 - correct
         Events : 0.12

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this    18      65       49       18      active sync   /dev/sdt1

   0     0       8       17        0      active sync   /dev/sdb1
   1     1       8       33        1      active sync   /dev/sdc1
   2     2       8       49        2      active sync   /dev/sdd1
   3     3       8       65        3      active sync   /dev/sde1
   4     4       8       81        4      active sync   /dev/sdf1
   5     5       8       97        5      active sync   /dev/sdg1
   6     6       8      113        6      active sync   /dev/sdh1
   7     7       8      129        7      active sync   /dev/sdi1
   8     8       8      145        8      active sync   /dev/sdj1
   9     9       8      161        9      active sync   /dev/sdk1
  10    10       8      177       10      active sync   /dev/sdl1
  11    11       8      193       11      active sync   /dev/sdm1
  12    12       8      209       12      active sync   /dev/sdn1
  13    13       8      225       13      active sync   /dev/sdo1
  14    14       8      241       14      active sync   /dev/sdp1
  15    15      65        1       15      active sync   /dev/sdq1
  16    16      65       17       16      active sync   /dev/sdr1
  17    17      65       33       17      active sync   /dev/sds1
  18    18      65       49       18      active sync   /dev/sdt1
  19    19      65       65       19      active sync   /dev/sdu1
  20    20      65       81       20      active sync   /dev/sdv1
  21    21      65       97       21      active sync   /dev/sdw1
  22    22      65      113       22      active sync   /dev/sdx1
  23    23      65      129       23      active sync   /dev/sdy1
  24    24      65      145       24      active sync   /dev/sdz1
  25    25      65      161       25      active sync   /dev/sdaa1
  26    26      65      177       26      active sync   /dev/sdab1
  27    18      65       49       18      active sync   /dev/sdt1
/dev/sdab1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : c00b698c:0b2bc972:2fe4a5a3:e488dcec
  Creation Time : Thu Jun 28 05:16:13 2007
     Raid Level : raid6
  Used Dev Size : 292961216 (279.39 GiB 299.99 GB)
     Array Size : 7324030400 (6984.74 GiB 7499.81 GB)
   Raid Devices : 27
  Total Devices : 28
Preferred Minor : 0

    Update Time : Mon Jan 26 14:03:23 2009
          State : clean
 Active Devices : 27
Working Devices : 28
 Failed Devices : 0
  Spare Devices : 1
       Checksum : 2a48d9d5 - correct
         Events : 0.12

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this    19      65       65       19      active sync   /dev/sdu1

   0     0       8       17        0      active sync   /dev/sdb1
   1     1       8       33        1      active sync   /dev/sdc1
   2     2       8       49        2      active sync   /dev/sdd1
   3     3       8       65        3      active sync   /dev/sde1
   4     4       8       81        4      active sync   /dev/sdf1
   5     5       8       97        5      active sync   /dev/sdg1
   6     6       8      113        6      active sync   /dev/sdh1
   7     7       8      129        7      active sync   /dev/sdi1
   8     8       8      145        8      active sync   /dev/sdj1
   9     9       8      161        9      active sync   /dev/sdk1
  10    10       8      177       10      active sync   /dev/sdl1
  11    11       8      193       11      active sync   /dev/sdm1
  12    12       8      209       12      active sync   /dev/sdn1
  13    13       8      225       13      active sync   /dev/sdo1
  14    14       8      241       14      active sync   /dev/sdp1
  15    15      65        1       15      active sync   /dev/sdq1
  16    16      65       17       16      active sync   /dev/sdr1
  17    17      65       33       17      active sync   /dev/sds1
  18    18      65       49       18      active sync   /dev/sdt1
  19    19      65       65       19      active sync   /dev/sdu1
  20    20      65       81       20      active sync   /dev/sdv1
  21    21      65       97       21      active sync   /dev/sdw1
  22    22      65      113       22      active sync   /dev/sdx1
  23    23      65      129       23      active sync   /dev/sdy1
  24    24      65      145       24      active sync   /dev/sdz1
  25    25      65      161       25      active sync   /dev/sdaa1
  26    26      65      177       26      active sync   /dev/sdab1
  27    19      65       65       19      active sync   /dev/sdu1
/dev/sdac1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : c00b698c:0b2bc972:2fe4a5a3:e488dcec
  Creation Time : Thu Jun 28 05:16:13 2007
     Raid Level : raid6
  Used Dev Size : 292961216 (279.39 GiB 299.99 GB)
     Array Size : 7324030400 (6984.74 GiB 7499.81 GB)
   Raid Devices : 27
  Total Devices : 28
Preferred Minor : 0

    Update Time : Tue Jan 27 23:12:33 2009
          State : clean
 Active Devices : 26
Working Devices : 27
 Failed Devices : 1
  Spare Devices : 1
       Checksum : 2a4aabdf - correct
         Events : 0.12

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this    20      65       81       20      active sync   /dev/sdv1

   0     0       8       17        0      active sync   /dev/sdb1
   1     1       8       33        1      active sync   /dev/sdc1
   2     2       8       49        2      active sync   /dev/sdd1
   3     3       8       65        3      active sync   /dev/sde1
   4     4       8       81        4      active sync   /dev/sdf1
   5     5       8       97        5      active sync   /dev/sdg1
   6     6       8      113        6      active sync   /dev/sdh1
   7     7       8      129        7      active sync   /dev/sdi1
   8     8       8      145        8      active sync   /dev/sdj1
   9     9       8      161        9      active sync   /dev/sdk1
  10    10       8      177       10      active sync   /dev/sdl1
  11    11       8      193       11      active sync   /dev/sdm1
  12    12       8      209       12      active sync   /dev/sdn1
  13    13       8      225       13      active sync   /dev/sdo1
  14    14       8      241       14      active sync   /dev/sdp1
  15    15       0        0       15      faulty removed
  16    16      65       17       16      active sync   /dev/sdr1
  17    17      65       33       17      active sync   /dev/sds1
  18    18      65       49       18      active sync   /dev/sdt1
  19    19      65       65       19      active sync   /dev/sdu1
  20    20      65       81       20      active sync   /dev/sdv1
  21    21      65       97       21      active sync   /dev/sdw1
  22    22      65      113       22      active sync   /dev/sdx1
  23    23      65      129       23      active sync   /dev/sdy1
  24    24      65      145       24      active sync   /dev/sdz1
  25    25      65      161       25      active sync   /dev/sdaa1
  26    26      65      177       26      active sync   /dev/sdab1
  27    20      65       81       20      active sync   /dev/sdv1
[root@node002 ~]# 


Thanks,

tjb
-- 
=======================================================================
| Thomas Baker                                  email: tjb@unh.edu    |
| Systems Programmer                                                  |
| Research Computing Center                     voice: (603) 862-4490 |
| University of New Hampshire                     fax: (603) 862-1761 |
| 332 Morse Hall                                                      |
| Durham, NH 03824 USA              http://wintermute.sr.unh.edu/~tjb |
=======================================================================

