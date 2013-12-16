From: Michael Samer <michael.samer@epos-cat.de>
Subject: mdadm error
Date: Mon, 16 Dec 2013 21:56:53 +0100
Message-ID: <52AF6915.7010806@epos-cat.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070201040302080409000204"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------070201040302080409000204
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit

Hello Mr Brown
you might remember helping me end of 2012 with an mdadm error 
(lost/inactive volume).
This year I've been proactive in advertising your name to our yearly 
donation list. My collegue Lisa Braunert should already have contacted 
you and booked 250EUR at your account. Hope this was/is an adequate 
donation for the two very helpful mails :-)

Currently I've the a mdadm system here again with unmountable volume due 
to disk (timeout and badblocks) failures. I transfered the disk already 
to new HDs.

Question: for this is a RAID5 the only redundant disk was lost to a 
timeout sometime in the past and the second (/dev/sdf) had tons of 
BadBlocks in the first and last 5MBs. I reconstructed the partition 
table (as all 8 disks are build the same way), but how could I glue the 
mdadm system together again. After that I'd start an integrity check of 
the mdadm volume and afterwards an fsck.

I attach the "mdadm --examine /dev/sd*" so you might consider looking 
upon my problem

In every way: best wishes for christmas
Michael Samer




--------------070201040302080409000204
Content-Type: text/plain; charset=windows-1252;
 name="md_examine_all.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="md_examine_all.txt"

/dev/sda:
   MBR Magic : aa55
Partition[0] :      1060250 sectors at           40 (type 83)
Partition[1] :      1060284 sectors at      1060296 (type 83)
Partition[2] :   3903891386 sectors at      2120584 (type 83)
Partition[3] :       996024 sectors at   3906011976 (type 83)
/dev/sda1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 05105cec:26fef0b4:bf3f9508:05f7c111
  Creation Time : Sun Jan 27 18:38:01 2013
     Raid Level : raid1
  Used Dev Size : 530048 (517.71 MiB 542.77 MB)
     Array Size : 530048 (517.71 MiB 542.77 MB)
   Raid Devices : 8
  Total Devices : 5
Preferred Minor : 9

    Update Time : Mon Dec 16 14:05:54 2013
          State : clean
Internal Bitmap : present
 Active Devices : 5
Working Devices : 5
 Failed Devices : 2
  Spare Devices : 0
       Checksum : 3e2e7326 - correct
         Events : 763


      Number   Major   Minor   RaidDevice State
this     2       8        1        2      active sync   /dev/sda1

   0     0       0        0        0      removed
   1     1       8       17        1      active sync   /dev/sdb1
   2     2       8        1        2      active sync   /dev/sda1
   3     3       8       65        3      active sync   /dev/sde1
   4     4       8       97        4      active sync   /dev/sdg1
   5     5       0        0        5      faulty removed
   6     6       8      113        6      active sync   /dev/sdh1
   7     7       0        0        7      faulty removed
/dev/sda2:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 39e8ca2f:3cfff703:4de89223:ac2a0c13
  Creation Time : Thu Mar  7 09:41:55 2013
     Raid Level : raid1
  Used Dev Size : 530048 (517.71 MiB 542.77 MB)
     Array Size : 530048 (517.71 MiB 542.77 MB)
   Raid Devices : 2
  Total Devices : 5
Preferred Minor : 126

    Update Time : Mon Dec 16 14:46:37 2013
          State : clean
 Active Devices : 2
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 3
       Checksum : be161f0b - correct
         Events : 59


      Number   Major   Minor   RaidDevice State
this     4       8        2        4      spare   /dev/sda2

   0     0       8       50        0      active sync   /dev/sdd2
   1     1       8      114        1      active sync   /dev/sdh2
   2     2       8       98        2      spare   /dev/sdg2
   3     3       8       82        3      spare   /dev/sdf2
   4     4       8        2        4      spare   /dev/sda2
/dev/sda3:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 52d7d080:5c40de46:bc741f30:65cb5a0d
  Creation Time : Sun Jan 27 23:10:25 2013
     Raid Level : raid5
  Used Dev Size : 1951945600 (1861.52 GiB 1998.79 GB)
     Array Size : 13663619200 (13030.64 GiB 13991.55 GB)
   Raid Devices : 8
  Total Devices : 7
Preferred Minor : 0

    Update Time : Sun Apr 21 14:14:49 2013
          State : active
 Active Devices : 7
Working Devices : 7
 Failed Devices : 1
  Spare Devices : 0
       Checksum : 91564c42 - correct
         Events : 136

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     3       8       51        3      active sync   /dev/sdd3

   0     0       8        3        0      active sync   /dev/sda3
   1     1       0        0        1      faulty removed
   2     2       8       35        2      active sync   /dev/sdc3
   3     3       8       51        3      active sync   /dev/sdd3
   4     4       8       67        4      active sync   /dev/sde3
   5     5       8       83        5      active sync   /dev/sdf3
   6     6       8       99        6      active sync   /dev/sdg3
   7     7       8      115        7      active sync   /dev/sdh3
/dev/sda4:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 4bfc2d50:283e9f67:803faac1:21814c31
  Creation Time : Sun Jan 27 18:38:10 2013
     Raid Level : raid1
  Used Dev Size : 458880 (448.20 MiB 469.89 MB)
     Array Size : 458880 (448.20 MiB 469.89 MB)
   Raid Devices : 8
  Total Devices : 7
Preferred Minor : 13

    Update Time : Mon Dec 16 14:05:54 2013
          State : clean
Internal Bitmap : present
 Active Devices : 7
Working Devices : 7
 Failed Devices : 1
  Spare Devices : 0
       Checksum : 62e299b3 - correct
         Events : 4355


      Number   Major   Minor   RaidDevice State
this     5       8        4        5      active sync   /dev/sda4

   0     0       8       36        0      active sync   /dev/sdc4
   1     1       8      116        1      active sync   /dev/sdh4
   2     2       8       52        2      active sync   /dev/sdd4
   3     3       8      100        3      active sync   /dev/sdg4
   4     4       8       68        4      active sync   /dev/sde4
   5     5       8        4        5      active sync   /dev/sda4
   6     6       8       20        6      active sync   /dev/sdb4
   7     7       0        0        7      faulty removed
/dev/sdb:
   MBR Magic : aa55
Partition[0] :      1060250 sectors at           40 (type 83)
Partition[1] :      1060284 sectors at      1060296 (type 83)
Partition[2] :   3903891386 sectors at      2120584 (type 83)
Partition[3] :       996024 sectors at   3906011976 (type 83)
/dev/sdb1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 05105cec:26fef0b4:bf3f9508:05f7c111
  Creation Time : Sun Jan 27 18:38:01 2013
     Raid Level : raid1
  Used Dev Size : 530048 (517.71 MiB 542.77 MB)
     Array Size : 530048 (517.71 MiB 542.77 MB)
   Raid Devices : 8
  Total Devices : 5
Preferred Minor : 9

    Update Time : Mon Dec 16 14:05:54 2013
          State : clean
Internal Bitmap : present
 Active Devices : 5
Working Devices : 5
 Failed Devices : 2
  Spare Devices : 0
       Checksum : 3e2e7334 - correct
         Events : 763


      Number   Major   Minor   RaidDevice State
this     1       8       17        1      active sync   /dev/sdb1

   0     0       0        0        0      removed
   1     1       8       17        1      active sync   /dev/sdb1
   2     2       8        1        2      active sync   /dev/sda1
   3     3       8       65        3      active sync   /dev/sde1
   4     4       8       97        4      active sync   /dev/sdg1
   5     5       0        0        5      faulty removed
   6     6       8      113        6      active sync   /dev/sdh1
   7     7       0        0        7      faulty removed
/dev/sdb4:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 4bfc2d50:283e9f67:803faac1:21814c31
  Creation Time : Sun Jan 27 18:38:10 2013
     Raid Level : raid1
  Used Dev Size : 458880 (448.20 MiB 469.89 MB)
     Array Size : 458880 (448.20 MiB 469.89 MB)
   Raid Devices : 8
  Total Devices : 7
Preferred Minor : 13

    Update Time : Mon Dec 16 14:05:54 2013
          State : clean
Internal Bitmap : present
 Active Devices : 7
Working Devices : 7
 Failed Devices : 1
  Spare Devices : 0
       Checksum : 62e299c5 - correct
         Events : 4355


      Number   Major   Minor   RaidDevice State
this     6       8       20        6      active sync   /dev/sdb4

   0     0       8       36        0      active sync   /dev/sdc4
   1     1       8      116        1      active sync   /dev/sdh4
   2     2       8       52        2      active sync   /dev/sdd4
   3     3       8      100        3      active sync   /dev/sdg4
   4     4       8       68        4      active sync   /dev/sde4
   5     5       8        4        5      active sync   /dev/sda4
   6     6       8       20        6      active sync   /dev/sdb4
   7     7       0        0        7      faulty removed
/dev/sdc:
   MBR Magic : aa55
Partition[0] :      1060250 sectors at           40 (type 83)
Partition[1] :      1060284 sectors at      1060296 (type 83)
Partition[2] :   3903891386 sectors at      2120584 (type 83)
Partition[3] :       996024 sectors at   3906011976 (type 83)
/dev/sdc1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 05105cec:26fef0b4:bf3f9508:05f7c111
  Creation Time : Sun Jan 27 18:38:01 2013
     Raid Level : raid1
  Used Dev Size : 530048 (517.71 MiB 542.77 MB)
     Array Size : 530048 (517.71 MiB 542.77 MB)
   Raid Devices : 8
  Total Devices : 8
Preferred Minor : 9

    Update Time : Sun Apr 21 14:00:12 2013
          State : clean
Internal Bitmap : present
 Active Devices : 8
Working Devices : 8
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 3cf34b80 - correct
         Events : 440


      Number   Major   Minor   RaidDevice State
this     0       8       17        0      active sync   /dev/sdb1

   0     0       8       17        0      active sync   /dev/sdb1
   1     1       8       49        1      active sync   /dev/sdd1
   2     2       8        1        2      active sync   /dev/sda1
   3     3       8       33        3      active sync   /dev/sdc1
   4     4       8       65        4      active sync   /dev/sde1
   5     5       8       81        5      active sync   /dev/sdf1
   6     6       8      113        6      active sync   /dev/sdh1
   7     7       8       97        7      active sync   /dev/sdg1
/dev/sdc2:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 39e8ca2f:3cfff703:4de89223:ac2a0c13
  Creation Time : Thu Mar  7 09:41:55 2013
     Raid Level : raid1
  Used Dev Size : 530048 (517.71 MiB 542.77 MB)
     Array Size : 530048 (517.71 MiB 542.77 MB)
   Raid Devices : 2
  Total Devices : 8
Preferred Minor : 8

    Update Time : Thu Mar  7 09:42:20 2013
          State : clean
 Active Devices : 2
Working Devices : 8
 Failed Devices : 0
  Spare Devices : 6
       Checksum : bc9f6dd7 - correct
         Events : 31


      Number   Major   Minor   RaidDevice State
this     1       8       18        1      active sync   /dev/sdb2

   0     0       8        2        0      active sync   /dev/sda2
   1     1       8       18        1      active sync   /dev/sdb2
   2     2       8      114        2      spare   /dev/sdh2
   3     3       8       98        3      spare   /dev/sdg2
   4     4       8       82        4      spare   /dev/sdf2
   5     5       8       66        5      spare   /dev/sde2
   6     6       8       50        6      spare   /dev/sdd2
   7     7       8       34        7      spare   /dev/sdc2
/dev/sdc3:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 52d7d080:5c40de46:bc741f30:65cb5a0d
  Creation Time : Sun Jan 27 23:10:25 2013
     Raid Level : raid5
  Used Dev Size : 1951945600 (1861.52 GiB 1998.79 GB)
     Array Size : 13663619200 (13030.64 GiB 13991.55 GB)
   Raid Devices : 8
  Total Devices : 8
Preferred Minor : 0

    Update Time : Sun Apr 21 14:06:49 2013
          State : active
 Active Devices : 8
Working Devices : 8
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 91564a57 - correct
         Events : 135

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     1       8       19        1      active sync   /dev/sdb3

   0     0       8        3        0      active sync   /dev/sda3
   1     1       8       19        1      active sync   /dev/sdb3
   2     2       8       35        2      active sync   /dev/sdc3
   3     3       8       51        3      active sync   /dev/sdd3
   4     4       8       67        4      active sync   /dev/sde3
   5     5       8       83        5      active sync   /dev/sdf3
   6     6       8       99        6      active sync   /dev/sdg3
   7     7       8      115        7      active sync   /dev/sdh3
/dev/sdc4:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 4bfc2d50:283e9f67:803faac1:21814c31
  Creation Time : Sun Jan 27 18:38:10 2013
     Raid Level : raid1
  Used Dev Size : 458880 (448.20 MiB 469.89 MB)
     Array Size : 458880 (448.20 MiB 469.89 MB)
   Raid Devices : 8
  Total Devices : 7
Preferred Minor : 13

    Update Time : Mon Dec 16 14:05:54 2013
          State : clean
Internal Bitmap : present
 Active Devices : 7
Working Devices : 7
 Failed Devices : 1
  Spare Devices : 0
       Checksum : 62e299c9 - correct
         Events : 4355


      Number   Major   Minor   RaidDevice State
this     0       8       36        0      active sync   /dev/sdc4

   0     0       8       36        0      active sync   /dev/sdc4
   1     1       8      116        1      active sync   /dev/sdh4
   2     2       8       52        2      active sync   /dev/sdd4
   3     3       8      100        3      active sync   /dev/sdg4
   4     4       8       68        4      active sync   /dev/sde4
   5     5       8        4        5      active sync   /dev/sda4
   6     6       8       20        6      active sync   /dev/sdb4
   7     7       0        0        7      faulty removed
/dev/sdd:
   MBR Magic : aa55
Partition[0] :      1060250 sectors at           40 (type 83)
Partition[1] :      1060284 sectors at      1060296 (type 83)
Partition[2] :   3903891386 sectors at      2120584 (type 83)
Partition[3] :       996024 sectors at   3906011976 (type 83)
/dev/sdd1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 05105cec:26fef0b4:bf3f9508:05f7c111
  Creation Time : Sun Jan 27 18:38:01 2013
     Raid Level : raid1
  Used Dev Size : 530048 (517.71 MiB 542.77 MB)
     Array Size : 530048 (517.71 MiB 542.77 MB)
   Raid Devices : 8
  Total Devices : 6
Preferred Minor : 9

    Update Time : Tue Sep 17 12:47:24 2013
          State : active
Internal Bitmap : present
 Active Devices : 6
Working Devices : 6
 Failed Devices : 2
  Spare Devices : 0
       Checksum : 3db7a8d2 - correct
         Events : 723


      Number   Major   Minor   RaidDevice State
this     0       8        1        0      active sync   /dev/sda1

   0     0       8        1        0      active sync   /dev/sda1
   1     1       8       33        1      active sync   /dev/sdc1
   2     2       8       49        2      active sync   /dev/sdd1
   3     3       8       65        3      active sync   /dev/sde1
   4     4       8       97        4      active sync   /dev/sdg1
   5     5       0        0        5      faulty removed
   6     6       8      113        6      active sync   /dev/sdh1
   7     7       0        0        7      faulty removed
/dev/sdd2:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 39e8ca2f:3cfff703:4de89223:ac2a0c13
  Creation Time : Thu Mar  7 09:41:55 2013
     Raid Level : raid1
  Used Dev Size : 530048 (517.71 MiB 542.77 MB)
     Array Size : 530048 (517.71 MiB 542.77 MB)
   Raid Devices : 2
  Total Devices : 5
Preferred Minor : 126

    Update Time : Mon Dec 16 14:05:54 2013
          State : clean
 Active Devices : 2
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 3
       Checksum : be1615ae - correct
         Events : 59


      Number   Major   Minor   RaidDevice State
this     0       8       50        0      active sync   /dev/sdd2

   0     0       8       50        0      active sync   /dev/sdd2
   1     1       8      114        1      active sync   /dev/sdh2
   2     2       8       98        2      spare   /dev/sdg2
   3     3       8       82        3      spare   /dev/sdf2
   4     4       8        2        4      spare   /dev/sda2
/dev/sdd4:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 4bfc2d50:283e9f67:803faac1:21814c31
  Creation Time : Sun Jan 27 18:38:10 2013
     Raid Level : raid1
  Used Dev Size : 458880 (448.20 MiB 469.89 MB)
     Array Size : 458880 (448.20 MiB 469.89 MB)
   Raid Devices : 8
  Total Devices : 7
Preferred Minor : 13

    Update Time : Mon Dec 16 14:05:54 2013
          State : clean
Internal Bitmap : present
 Active Devices : 7
Working Devices : 7
 Failed Devices : 1
  Spare Devices : 0
       Checksum : 62e299dd - correct
         Events : 4355


      Number   Major   Minor   RaidDevice State
this     2       8       52        2      active sync   /dev/sdd4

   0     0       8       36        0      active sync   /dev/sdc4
   1     1       8      116        1      active sync   /dev/sdh4
   2     2       8       52        2      active sync   /dev/sdd4
   3     3       8      100        3      active sync   /dev/sdg4
   4     4       8       68        4      active sync   /dev/sde4
   5     5       8        4        5      active sync   /dev/sda4
   6     6       8       20        6      active sync   /dev/sdb4
   7     7       0        0        7      faulty removed
/dev/sde:
   MBR Magic : aa55
Partition[0] :      1060250 sectors at           40 (type 83)
Partition[1] :      1060284 sectors at      1060296 (type 83)
Partition[2] :   3903891386 sectors at      2120584 (type 83)
Partition[3] :       996024 sectors at   3906011976 (type 83)
/dev/sde1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 05105cec:26fef0b4:bf3f9508:05f7c111
  Creation Time : Sun Jan 27 18:38:01 2013
     Raid Level : raid1
  Used Dev Size : 530048 (517.71 MiB 542.77 MB)
     Array Size : 530048 (517.71 MiB 542.77 MB)
   Raid Devices : 8
  Total Devices : 5
Preferred Minor : 9

    Update Time : Mon Dec 16 14:05:54 2013
          State : clean
Internal Bitmap : present
 Active Devices : 5
Working Devices : 5
 Failed Devices : 2
  Spare Devices : 0
       Checksum : 3e2e7368 - correct
         Events : 763


      Number   Major   Minor   RaidDevice State
this     3       8       65        3      active sync   /dev/sde1

   0     0       0        0        0      removed
   1     1       8       17        1      active sync   /dev/sdb1
   2     2       8        1        2      active sync   /dev/sda1
   3     3       8       65        3      active sync   /dev/sde1
   4     4       8       97        4      active sync   /dev/sdg1
   5     5       0        0        5      faulty removed
   6     6       8      113        6      active sync   /dev/sdh1
   7     7       0        0        7      faulty removed
/dev/sde2:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 39e8ca2f:3cfff703:4de89223:ac2a0c13
  Creation Time : Thu Mar  7 09:41:55 2013
     Raid Level : raid1
  Used Dev Size : 530048 (517.71 MiB 542.77 MB)
     Array Size : 530048 (517.71 MiB 542.77 MB)
   Raid Devices : 2
  Total Devices : 5
Preferred Minor : 8

    Update Time : Fri Dec 13 12:02:41 2013
          State : clean
 Active Devices : 2
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 3
       Checksum : be1203d3 - correct
         Events : 57


      Number   Major   Minor   RaidDevice State
this     3       8       66        3      spare   /dev/sde2

   0     0       8       50        0      active sync   /dev/sdd2
   1     1       8      114        1      active sync   /dev/sdh2
   2     2       8        2        2      spare   /dev/sda2
   3     3       8       66        3      spare   /dev/sde2
   4     4       8       98        4      spare   /dev/sdg2
/dev/sde3:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 52d7d080:5c40de46:bc741f30:65cb5a0d
  Creation Time : Sun Jan 27 23:10:25 2013
     Raid Level : raid5
  Used Dev Size : 1951945600 (1861.52 GiB 1998.79 GB)
     Array Size : 13663619200 (13030.64 GiB 13991.55 GB)
   Raid Devices : 8
  Total Devices : 7
Preferred Minor : 0

    Update Time : Sun Apr 21 14:14:49 2013
          State : active
 Active Devices : 7
Working Devices : 7
 Failed Devices : 1
  Spare Devices : 0
       Checksum : 91564c54 - correct
         Events : 136

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     4       8       67        4      active sync   /dev/sde3

   0     0       8        3        0      active sync   /dev/sda3
   1     1       0        0        1      faulty removed
   2     2       8       35        2      active sync   /dev/sdc3
   3     3       8       51        3      active sync   /dev/sdd3
   4     4       8       67        4      active sync   /dev/sde3
   5     5       8       83        5      active sync   /dev/sdf3
   6     6       8       99        6      active sync   /dev/sdg3
   7     7       8      115        7      active sync   /dev/sdh3
/dev/sde4:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 4bfc2d50:283e9f67:803faac1:21814c31
  Creation Time : Sun Jan 27 18:38:10 2013
     Raid Level : raid1
  Used Dev Size : 458880 (448.20 MiB 469.89 MB)
     Array Size : 458880 (448.20 MiB 469.89 MB)
   Raid Devices : 8
  Total Devices : 7
Preferred Minor : 13

    Update Time : Mon Dec 16 14:05:54 2013
          State : clean
Internal Bitmap : present
 Active Devices : 7
Working Devices : 7
 Failed Devices : 1
  Spare Devices : 0
       Checksum : 62e299f1 - correct
         Events : 4355


      Number   Major   Minor   RaidDevice State
this     4       8       68        4      active sync   /dev/sde4

   0     0       8       36        0      active sync   /dev/sdc4
   1     1       8      116        1      active sync   /dev/sdh4
   2     2       8       52        2      active sync   /dev/sdd4
   3     3       8      100        3      active sync   /dev/sdg4
   4     4       8       68        4      active sync   /dev/sde4
   5     5       8        4        5      active sync   /dev/sda4
   6     6       8       20        6      active sync   /dev/sdb4
   7     7       0        0        7      faulty removed
/dev/sdf:
   MBR Magic : aa55
Partition[0] :      1060250 sectors at           40 (type 83)
Partition[1] :      1060284 sectors at      1060296 (type 83)
Partition[2] :   3903891386 sectors at      2120584 (type 83)
Partition[3] :       996024 sectors at   3906011976 (type 83)
/dev/sdf1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 05105cec:26fef0b4:bf3f9508:05f7c111
  Creation Time : Sun Jan 27 18:38:01 2013
     Raid Level : raid1
  Used Dev Size : 530048 (517.71 MiB 542.77 MB)
     Array Size : 530048 (517.71 MiB 542.77 MB)
   Raid Devices : 8
  Total Devices : 7
Preferred Minor : 9

    Update Time : Sun Apr 21 14:50:18 2013
          State : active
Internal Bitmap : present
 Active Devices : 5
Working Devices : 5
 Failed Devices : 2
  Spare Devices : 0
       Checksum : 3cf355e6 - correct
         Events : 449


      Number   Major   Minor   RaidDevice State
this     5       8       81        5      active sync   /dev/sdf1

   0     0       0        0        0      removed
   1     1       0        0        1      faulty removed
   2     2       8        1        2      active sync   /dev/sda1
   3     3       8       33        3      active sync   /dev/sdc1
   4     4       0        0        4      faulty removed
   5     5       8       81        5      active sync   /dev/sdf1
   6     6       8      113        6      active sync   /dev/sdh1
   7     7       8       97        7      active sync   /dev/sdg1
/dev/sdf2:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 39e8ca2f:3cfff703:4de89223:ac2a0c13
  Creation Time : Thu Mar  7 09:41:55 2013
     Raid Level : raid1
  Used Dev Size : 530048 (517.71 MiB 542.77 MB)
     Array Size : 530048 (517.71 MiB 542.77 MB)
   Raid Devices : 2
  Total Devices : 5
Preferred Minor : 126

    Update Time : Mon Dec 16 14:46:37 2013
          State : clean
 Active Devices : 2
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 3
       Checksum : be161f59 - correct
         Events : 59


      Number   Major   Minor   RaidDevice State
this     3       8       82        3      spare   /dev/sdf2

   0     0       8       50        0      active sync   /dev/sdd2
   1     1       8      114        1      active sync   /dev/sdh2
   2     2       8       98        2      spare   /dev/sdg2
   3     3       8       82        3      spare   /dev/sdf2
   4     4       8        2        4      spare   /dev/sda2
/dev/sdf4:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 4bfc2d50:283e9f67:803faac1:21814c31
  Creation Time : Sun Jan 27 18:38:10 2013
     Raid Level : raid1
  Used Dev Size : 458880 (448.20 MiB 469.89 MB)
     Array Size : 458880 (448.20 MiB 469.89 MB)
   Raid Devices : 8
  Total Devices : 7
Preferred Minor : 13

    Update Time : Wed Apr 24 14:30:56 2013
          State : clean
Internal Bitmap : present
 Active Devices : 5
Working Devices : 5
 Failed Devices : 2
  Spare Devices : 0
       Checksum : 61ab5765 - correct
         Events : 1178


      Number   Major   Minor   RaidDevice State
this     5       8       84        5      active sync   /dev/sdf4

   0     0       0        0        0      removed
   1     1       0        0        1      faulty removed
   2     2       8        4        2      active sync   /dev/sda4
   3     3       8       36        3      active sync   /dev/sdc4
   4     4       0        0        4      faulty removed
   5     5       8       84        5      active sync   /dev/sdf4
   6     6       8      116        6      active sync   /dev/sdh4
   7     7       8      100        7      active sync   /dev/sdg4
/dev/sdg:
   MBR Magic : aa55
Partition[0] :      1060250 sectors at           40 (type 83)
Partition[1] :      1060284 sectors at      1060296 (type 83)
Partition[2] :   3903891386 sectors at      2120584 (type 83)
Partition[3] :       996024 sectors at   3906011976 (type 83)
/dev/sdg1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 05105cec:26fef0b4:bf3f9508:05f7c111
  Creation Time : Sun Jan 27 18:38:01 2013
     Raid Level : raid1
  Used Dev Size : 530048 (517.71 MiB 542.77 MB)
     Array Size : 530048 (517.71 MiB 542.77 MB)
   Raid Devices : 8
  Total Devices : 5
Preferred Minor : 9

    Update Time : Mon Dec 16 14:05:54 2013
          State : clean
Internal Bitmap : present
 Active Devices : 5
Working Devices : 5
 Failed Devices : 2
  Spare Devices : 0
       Checksum : 3e2e738a - correct
         Events : 763


      Number   Major   Minor   RaidDevice State
this     4       8       97        4      active sync   /dev/sdg1

   0     0       0        0        0      removed
   1     1       8       17        1      active sync   /dev/sdb1
   2     2       8        1        2      active sync   /dev/sda1
   3     3       8       65        3      active sync   /dev/sde1
   4     4       8       97        4      active sync   /dev/sdg1
   5     5       0        0        5      faulty removed
   6     6       8      113        6      active sync   /dev/sdh1
   7     7       0        0        7      faulty removed
/dev/sdg2:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 39e8ca2f:3cfff703:4de89223:ac2a0c13
  Creation Time : Thu Mar  7 09:41:55 2013
     Raid Level : raid1
  Used Dev Size : 530048 (517.71 MiB 542.77 MB)
     Array Size : 530048 (517.71 MiB 542.77 MB)
   Raid Devices : 2
  Total Devices : 5
Preferred Minor : 126

    Update Time : Mon Dec 16 14:46:37 2013
          State : clean
 Active Devices : 2
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 3
       Checksum : be161f67 - correct
         Events : 59


      Number   Major   Minor   RaidDevice State
this     2       8       98        2      spare   /dev/sdg2

   0     0       8       50        0      active sync   /dev/sdd2
   1     1       8      114        1      active sync   /dev/sdh2
   2     2       8       98        2      spare   /dev/sdg2
   3     3       8       82        3      spare   /dev/sdf2
   4     4       8        2        4      spare   /dev/sda2
/dev/sdg4:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 4bfc2d50:283e9f67:803faac1:21814c31
  Creation Time : Sun Jan 27 18:38:10 2013
     Raid Level : raid1
  Used Dev Size : 458880 (448.20 MiB 469.89 MB)
     Array Size : 458880 (448.20 MiB 469.89 MB)
   Raid Devices : 8
  Total Devices : 7
Preferred Minor : 13

    Update Time : Mon Dec 16 14:05:54 2013
          State : clean
Internal Bitmap : present
 Active Devices : 7
Working Devices : 7
 Failed Devices : 1
  Spare Devices : 0
       Checksum : 62e29a0f - correct
         Events : 4355


      Number   Major   Minor   RaidDevice State
this     3       8      100        3      active sync   /dev/sdg4

   0     0       8       36        0      active sync   /dev/sdc4
   1     1       8      116        1      active sync   /dev/sdh4
   2     2       8       52        2      active sync   /dev/sdd4
   3     3       8      100        3      active sync   /dev/sdg4
   4     4       8       68        4      active sync   /dev/sde4
   5     5       8        4        5      active sync   /dev/sda4
   6     6       8       20        6      active sync   /dev/sdb4
   7     7       0        0        7      faulty removed
/dev/sdh:
   MBR Magic : aa55
Partition[0] :      1060250 sectors at           40 (type 83)
Partition[1] :      1060284 sectors at      1060296 (type 83)
Partition[2] :   3903891386 sectors at      2120584 (type 83)
Partition[3] :       996024 sectors at   3906011976 (type 83)
/dev/sdh1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 05105cec:26fef0b4:bf3f9508:05f7c111
  Creation Time : Sun Jan 27 18:38:01 2013
     Raid Level : raid1
  Used Dev Size : 530048 (517.71 MiB 542.77 MB)
     Array Size : 530048 (517.71 MiB 542.77 MB)
   Raid Devices : 8
  Total Devices : 5
Preferred Minor : 9

    Update Time : Mon Dec 16 14:05:54 2013
          State : clean
Internal Bitmap : present
 Active Devices : 5
Working Devices : 5
 Failed Devices : 2
  Spare Devices : 0
       Checksum : 3e2e739e - correct
         Events : 763


      Number   Major   Minor   RaidDevice State
this     6       8      113        6      active sync   /dev/sdh1

   0     0       0        0        0      removed
   1     1       8       17        1      active sync   /dev/sdb1
   2     2       8        1        2      active sync   /dev/sda1
   3     3       8       65        3      active sync   /dev/sde1
   4     4       8       97        4      active sync   /dev/sdg1
   5     5       0        0        5      faulty removed
   6     6       8      113        6      active sync   /dev/sdh1
   7     7       0        0        7      faulty removed
/dev/sdh2:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 39e8ca2f:3cfff703:4de89223:ac2a0c13
  Creation Time : Thu Mar  7 09:41:55 2013
     Raid Level : raid1
  Used Dev Size : 530048 (517.71 MiB 542.77 MB)
     Array Size : 530048 (517.71 MiB 542.77 MB)
   Raid Devices : 2
  Total Devices : 5
Preferred Minor : 126

    Update Time : Mon Dec 16 14:05:54 2013
          State : clean
 Active Devices : 2
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 3
       Checksum : be1615f0 - correct
         Events : 59


      Number   Major   Minor   RaidDevice State
this     1       8      114        1      active sync   /dev/sdh2

   0     0       8       50        0      active sync   /dev/sdd2
   1     1       8      114        1      active sync   /dev/sdh2
   2     2       8       98        2      spare   /dev/sdg2
   3     3       8       82        3      spare   /dev/sdf2
   4     4       8        2        4      spare   /dev/sda2
/dev/sdh3:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 52d7d080:5c40de46:bc741f30:65cb5a0d
  Creation Time : Sun Jan 27 23:10:25 2013
     Raid Level : raid5
  Used Dev Size : 1951945600 (1861.52 GiB 1998.79 GB)
     Array Size : 13663619200 (13030.64 GiB 13991.55 GB)
   Raid Devices : 8
  Total Devices : 7
Preferred Minor : 0

    Update Time : Sun Apr 21 14:14:49 2013
          State : active
 Active Devices : 7
Working Devices : 7
 Failed Devices : 1
  Spare Devices : 0
       Checksum : 91564c8a - correct
         Events : 136

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     7       8      115        7      active sync   /dev/sdh3

   0     0       8        3        0      active sync   /dev/sda3
   1     1       0        0        1      faulty removed
   2     2       8       35        2      active sync   /dev/sdc3
   3     3       8       51        3      active sync   /dev/sdd3
   4     4       8       67        4      active sync   /dev/sde3
   5     5       8       83        5      active sync   /dev/sdf3
   6     6       8       99        6      active sync   /dev/sdg3
   7     7       8      115        7      active sync   /dev/sdh3
/dev/sdh4:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 4bfc2d50:283e9f67:803faac1:21814c31
  Creation Time : Sun Jan 27 18:38:10 2013
     Raid Level : raid1
  Used Dev Size : 458880 (448.20 MiB 469.89 MB)
     Array Size : 458880 (448.20 MiB 469.89 MB)
   Raid Devices : 8
  Total Devices : 7
Preferred Minor : 13

    Update Time : Mon Dec 16 14:05:54 2013
          State : clean
Internal Bitmap : present
 Active Devices : 7
Working Devices : 7
 Failed Devices : 1
  Spare Devices : 0
       Checksum : 62e29a1b - correct
         Events : 4355


      Number   Major   Minor   RaidDevice State
this     1       8      116        1      active sync   /dev/sdh4

   0     0       8       36        0      active sync   /dev/sdc4
   1     1       8      116        1      active sync   /dev/sdh4
   2     2       8       52        2      active sync   /dev/sdd4
   3     3       8      100        3      active sync   /dev/sdg4
   4     4       8       68        4      active sync   /dev/sde4
   5     5       8        4        5      active sync   /dev/sda4
   6     6       8       20        6      active sync   /dev/sdb4
   7     7       0        0        7      faulty removed
/dev/sdj:
   MBR Magic : aa55
Partition[0] :         4320 sectors at           32 (type 83)
Partition[1] :       484608 sectors at         4352 (type 83)
Partition[2] :       484608 sectors at       488960 (type 83)
Partition[3] :        34048 sectors at       973568 (type 05)
/dev/sdj4:
   MBR Magic : aa55
Partition[0] :        16608 sectors at           32 (type 83)
Partition[1] :        17408 sectors at        16640 (type 05)


--------------070201040302080409000204--
