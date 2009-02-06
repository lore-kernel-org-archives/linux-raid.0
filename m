From: "Thomas J. Baker" <tjb@unh.edu>
Subject: Re: Any hope for a 27 disk RAID6+1HS array with four disks
 reporting "No md superblock detected"?
Date: Fri, 06 Feb 2009 16:47:18 -0500
Message-ID: <1233956838.9786.37.camel@localhost.localdomain>
References: <1233775657.10151.5.camel@localhost.localdomain>
	 <18827.51024.270348.20624@notabene.brown>
	 <1233952325.9786.20.camel@localhost.localdomain>
	 <5b35884ec706518d378265e6b95ace53.squirrel@neil.brown.name>
Reply-To: tjb@unh.edu
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5b35884ec706518d378265e6b95ace53.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 2009-02-07 at 08:01 +1100, NeilBrown wrote:
> On Sat, February 7, 2009 7:32 am, Thomas J. Baker wrote:
> 
> > Thanks for the info. I think I follow everything. One last question
> > before really trying it - is this what is expected when I actually run
> > the command - the warnings about previous array, etc?
> 
> Yes, you would expect exactly those messages.
> 
> NeilBrown
> 

OK, first I put the drives back to their original configuration (I had
swapped two banks to make them appear physically as the kernel sees them
logically to make it easier to track down the possibly faulty disks.)
For clarity, I put them back to the original configuration before trying
anything.

Next I ran 

mdadm --create /dev/md0 --verbose --level=6 --raid-devices=26  \
/dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1 /dev/sdg1 missing \
/dev/sdi1 missing /dev/sdk1 /dev/sdl1 /dev/sdm1 /dev/sdn1 /dev/sdo1 \
/dev/sdp1 /dev/sdq1 /dev/sdr1 /dev/sdt1 /dev/sdu1 /dev/sdv1 \
/dev/sdw1 /dev/sdx1 /dev/sdy1 /dev/sdz1 /dev/sdaa1 /dev/sdab1

which completed but when I fsck'd the disk, it wasn't happy, complaining
about a missing superblock on /dev/md0. I then stopped the array. I'm
not sure what to do next. It seems like the examine information of all
the disks has been updated by the last create. I guess I should only go
by the previous examine? As for the missing statement, should that only
relate to drives with no md superblock?

Thanks for the help and sorry for the continued questions.

Here is how it currently sits:

[root@node002 ~]# ./examineRAIDDisks 
mdadm
-E /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1 /dev/sdg1 /dev/sdh1 /dev/sdi1 /dev/sdj1 /dev/sdk1 /dev/sdl1 /dev/sdm1 /dev/sdn1 /dev/sdo1 /dev/sdp1 /dev/sdq1 /dev/sdr1 /dev/sds1 /dev/sdt1 /dev/sdu1 /dev/sdv1 /dev/sdw1 /dev/sdx1 /dev/sdy1 /dev/sdz1 /dev/sdaa1 /dev/sdab1 /dev/sdac1
/dev/sdb1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : ccf28b9d:ea58ca5b:6ec35d57:27415988
  Creation Time : Fri Feb  6 16:26:44 2009
     Raid Level : raid6
  Used Dev Size : 292961216 (279.39 GiB 299.99 GB)
     Array Size : 7031069184 (6705.35 GiB 7199.81 GB)
   Raid Devices : 26
  Total Devices : 24
Preferred Minor : 0

    Update Time : Fri Feb  6 16:27:11 2009
          State : clean
 Active Devices : 24
Working Devices : 24
 Failed Devices : 2
  Spare Devices : 0
       Checksum : 9b0bffbe - correct
         Events : 0.4

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     0       8       17        0      active sync   /dev/sdb1

   0     0       8       17        0      active sync   /dev/sdb1
   1     1       8       33        1      active sync   /dev/sdc1
   2     2       8       49        2      active sync   /dev/sdd1
   3     3       8       65        3      active sync   /dev/sde1
   4     4       8       81        4      active sync   /dev/sdf1
   5     5       8       97        5      active sync   /dev/sdg1
   6     6       0        0        6      faulty removed
   7     7       8      129        7      active sync   /dev/sdi1
   8     8       0        0        8      faulty removed
   9     9       8      161        9      active sync   /dev/sdk1
  10    10       8      177       10      active sync   /dev/sdl1
  11    11       8      193       11      active sync   /dev/sdm1
  12    12       8      209       12      active sync   /dev/sdn1
  13    13       8      225       13      active sync   /dev/sdo1
  14    14       8      241       14      active sync   /dev/sdp1
  15    15      65        1       15      active sync   /dev/sdq1
  16    16      65       17       16      active sync   /dev/sdr1
  17    17      65       49       17      active sync   /dev/sdt1
  18    18      65       65       18      active sync   /dev/sdu1
  19    19      65       81       19      active sync   /dev/sdv1
  20    20      65       97       20      active sync   /dev/sdw1
  21    21      65      113       21      active sync   /dev/sdx1
  22    22      65      129       22      active sync   /dev/sdy1
  23    23      65      145       23      active sync   /dev/sdz1
  24    24      65      161       24      active sync   /dev/sdaa1
  25    25      65      177       25      active sync   /dev/sdab1
/dev/sdc1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : ccf28b9d:ea58ca5b:6ec35d57:27415988
  Creation Time : Fri Feb  6 16:26:44 2009
     Raid Level : raid6
  Used Dev Size : 292961216 (279.39 GiB 299.99 GB)
     Array Size : 7031069184 (6705.35 GiB 7199.81 GB)
   Raid Devices : 26
  Total Devices : 24
Preferred Minor : 0

    Update Time : Fri Feb  6 16:27:11 2009
          State : clean
 Active Devices : 24
Working Devices : 24
 Failed Devices : 2
  Spare Devices : 0
       Checksum : 9b0bffd0 - correct
         Events : 0.4

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     1       8       33        1      active sync   /dev/sdc1

   0     0       8       17        0      active sync   /dev/sdb1
   1     1       8       33        1      active sync   /dev/sdc1
   2     2       8       49        2      active sync   /dev/sdd1
   3     3       8       65        3      active sync   /dev/sde1
   4     4       8       81        4      active sync   /dev/sdf1
   5     5       8       97        5      active sync   /dev/sdg1
   6     6       0        0        6      faulty removed
   7     7       8      129        7      active sync   /dev/sdi1
   8     8       0        0        8      faulty removed
   9     9       8      161        9      active sync   /dev/sdk1
  10    10       8      177       10      active sync   /dev/sdl1
  11    11       8      193       11      active sync   /dev/sdm1
  12    12       8      209       12      active sync   /dev/sdn1
  13    13       8      225       13      active sync   /dev/sdo1
  14    14       8      241       14      active sync   /dev/sdp1
  15    15      65        1       15      active sync   /dev/sdq1
  16    16      65       17       16      active sync   /dev/sdr1
  17    17      65       49       17      active sync   /dev/sdt1
  18    18      65       65       18      active sync   /dev/sdu1
  19    19      65       81       19      active sync   /dev/sdv1
  20    20      65       97       20      active sync   /dev/sdw1
  21    21      65      113       21      active sync   /dev/sdx1
  22    22      65      129       22      active sync   /dev/sdy1
  23    23      65      145       23      active sync   /dev/sdz1
  24    24      65      161       24      active sync   /dev/sdaa1
  25    25      65      177       25      active sync   /dev/sdab1
/dev/sdd1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : ccf28b9d:ea58ca5b:6ec35d57:27415988
  Creation Time : Fri Feb  6 16:26:44 2009
     Raid Level : raid6
  Used Dev Size : 292961216 (279.39 GiB 299.99 GB)
     Array Size : 7031069184 (6705.35 GiB 7199.81 GB)
   Raid Devices : 26
  Total Devices : 24
Preferred Minor : 0

    Update Time : Fri Feb  6 16:27:11 2009
          State : clean
 Active Devices : 24
Working Devices : 24
 Failed Devices : 2
  Spare Devices : 0
       Checksum : 9b0bffe2 - correct
         Events : 0.4

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     2       8       49        2      active sync   /dev/sdd1

   0     0       8       17        0      active sync   /dev/sdb1
   1     1       8       33        1      active sync   /dev/sdc1
   2     2       8       49        2      active sync   /dev/sdd1
   3     3       8       65        3      active sync   /dev/sde1
   4     4       8       81        4      active sync   /dev/sdf1
   5     5       8       97        5      active sync   /dev/sdg1
   6     6       0        0        6      faulty removed
   7     7       8      129        7      active sync   /dev/sdi1
   8     8       0        0        8      faulty removed
   9     9       8      161        9      active sync   /dev/sdk1
  10    10       8      177       10      active sync   /dev/sdl1
  11    11       8      193       11      active sync   /dev/sdm1
  12    12       8      209       12      active sync   /dev/sdn1
  13    13       8      225       13      active sync   /dev/sdo1
  14    14       8      241       14      active sync   /dev/sdp1
  15    15      65        1       15      active sync   /dev/sdq1
  16    16      65       17       16      active sync   /dev/sdr1
  17    17      65       49       17      active sync   /dev/sdt1
  18    18      65       65       18      active sync   /dev/sdu1
  19    19      65       81       19      active sync   /dev/sdv1
  20    20      65       97       20      active sync   /dev/sdw1
  21    21      65      113       21      active sync   /dev/sdx1
  22    22      65      129       22      active sync   /dev/sdy1
  23    23      65      145       23      active sync   /dev/sdz1
  24    24      65      161       24      active sync   /dev/sdaa1
  25    25      65      177       25      active sync   /dev/sdab1
/dev/sde1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : ccf28b9d:ea58ca5b:6ec35d57:27415988
  Creation Time : Fri Feb  6 16:26:44 2009
     Raid Level : raid6
  Used Dev Size : 292961216 (279.39 GiB 299.99 GB)
     Array Size : 7031069184 (6705.35 GiB 7199.81 GB)
   Raid Devices : 26
  Total Devices : 24
Preferred Minor : 0

    Update Time : Fri Feb  6 16:27:11 2009
          State : clean
 Active Devices : 24
Working Devices : 24
 Failed Devices : 2
  Spare Devices : 0
       Checksum : 9b0bfff4 - correct
         Events : 0.4

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     3       8       65        3      active sync   /dev/sde1

   0     0       8       17        0      active sync   /dev/sdb1
   1     1       8       33        1      active sync   /dev/sdc1
   2     2       8       49        2      active sync   /dev/sdd1
   3     3       8       65        3      active sync   /dev/sde1
   4     4       8       81        4      active sync   /dev/sdf1
   5     5       8       97        5      active sync   /dev/sdg1
   6     6       0        0        6      faulty removed
   7     7       8      129        7      active sync   /dev/sdi1
   8     8       0        0        8      faulty removed
   9     9       8      161        9      active sync   /dev/sdk1
  10    10       8      177       10      active sync   /dev/sdl1
  11    11       8      193       11      active sync   /dev/sdm1
  12    12       8      209       12      active sync   /dev/sdn1
  13    13       8      225       13      active sync   /dev/sdo1
  14    14       8      241       14      active sync   /dev/sdp1
  15    15      65        1       15      active sync   /dev/sdq1
  16    16      65       17       16      active sync   /dev/sdr1
  17    17      65       49       17      active sync   /dev/sdt1
  18    18      65       65       18      active sync   /dev/sdu1
  19    19      65       81       19      active sync   /dev/sdv1
  20    20      65       97       20      active sync   /dev/sdw1
  21    21      65      113       21      active sync   /dev/sdx1
  22    22      65      129       22      active sync   /dev/sdy1
  23    23      65      145       23      active sync   /dev/sdz1
  24    24      65      161       24      active sync   /dev/sdaa1
  25    25      65      177       25      active sync   /dev/sdab1
/dev/sdf1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : ccf28b9d:ea58ca5b:6ec35d57:27415988
  Creation Time : Fri Feb  6 16:26:44 2009
     Raid Level : raid6
  Used Dev Size : 292961216 (279.39 GiB 299.99 GB)
     Array Size : 7031069184 (6705.35 GiB 7199.81 GB)
   Raid Devices : 26
  Total Devices : 24
Preferred Minor : 0

    Update Time : Fri Feb  6 16:27:11 2009
          State : clean
 Active Devices : 24
Working Devices : 24
 Failed Devices : 2
  Spare Devices : 0
       Checksum : 9b0c0006 - correct
         Events : 0.4

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     4       8       81        4      active sync   /dev/sdf1

   0     0       8       17        0      active sync   /dev/sdb1
   1     1       8       33        1      active sync   /dev/sdc1
   2     2       8       49        2      active sync   /dev/sdd1
   3     3       8       65        3      active sync   /dev/sde1
   4     4       8       81        4      active sync   /dev/sdf1
   5     5       8       97        5      active sync   /dev/sdg1
   6     6       0        0        6      faulty removed
   7     7       8      129        7      active sync   /dev/sdi1
   8     8       0        0        8      faulty removed
   9     9       8      161        9      active sync   /dev/sdk1
  10    10       8      177       10      active sync   /dev/sdl1
  11    11       8      193       11      active sync   /dev/sdm1
  12    12       8      209       12      active sync   /dev/sdn1
  13    13       8      225       13      active sync   /dev/sdo1
  14    14       8      241       14      active sync   /dev/sdp1
  15    15      65        1       15      active sync   /dev/sdq1
  16    16      65       17       16      active sync   /dev/sdr1
  17    17      65       49       17      active sync   /dev/sdt1
  18    18      65       65       18      active sync   /dev/sdu1
  19    19      65       81       19      active sync   /dev/sdv1
  20    20      65       97       20      active sync   /dev/sdw1
  21    21      65      113       21      active sync   /dev/sdx1
  22    22      65      129       22      active sync   /dev/sdy1
  23    23      65      145       23      active sync   /dev/sdz1
  24    24      65      161       24      active sync   /dev/sdaa1
  25    25      65      177       25      active sync   /dev/sdab1
/dev/sdg1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : ccf28b9d:ea58ca5b:6ec35d57:27415988
  Creation Time : Fri Feb  6 16:26:44 2009
     Raid Level : raid6
  Used Dev Size : 292961216 (279.39 GiB 299.99 GB)
     Array Size : 7031069184 (6705.35 GiB 7199.81 GB)
   Raid Devices : 26
  Total Devices : 24
Preferred Minor : 0

    Update Time : Fri Feb  6 16:27:11 2009
          State : clean
 Active Devices : 24
Working Devices : 24
 Failed Devices : 2
  Spare Devices : 0
       Checksum : 9b0c0018 - correct
         Events : 0.4

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     5       8       97        5      active sync   /dev/sdg1

   0     0       8       17        0      active sync   /dev/sdb1
   1     1       8       33        1      active sync   /dev/sdc1
   2     2       8       49        2      active sync   /dev/sdd1
   3     3       8       65        3      active sync   /dev/sde1
   4     4       8       81        4      active sync   /dev/sdf1
   5     5       8       97        5      active sync   /dev/sdg1
   6     6       0        0        6      faulty removed
   7     7       8      129        7      active sync   /dev/sdi1
   8     8       0        0        8      faulty removed
   9     9       8      161        9      active sync   /dev/sdk1
  10    10       8      177       10      active sync   /dev/sdl1
  11    11       8      193       11      active sync   /dev/sdm1
  12    12       8      209       12      active sync   /dev/sdn1
  13    13       8      225       13      active sync   /dev/sdo1
  14    14       8      241       14      active sync   /dev/sdp1
  15    15      65        1       15      active sync   /dev/sdq1
  16    16      65       17       16      active sync   /dev/sdr1
  17    17      65       49       17      active sync   /dev/sdt1
  18    18      65       65       18      active sync   /dev/sdu1
  19    19      65       81       19      active sync   /dev/sdv1
  20    20      65       97       20      active sync   /dev/sdw1
  21    21      65      113       21      active sync   /dev/sdx1
  22    22      65      129       22      active sync   /dev/sdy1
  23    23      65      145       23      active sync   /dev/sdz1
  24    24      65      161       24      active sync   /dev/sdaa1
  25    25      65      177       25      active sync   /dev/sdab1
mdadm: No md superblock detected on /dev/sdh1.
/dev/sdi1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : ccf28b9d:ea58ca5b:6ec35d57:27415988
  Creation Time : Fri Feb  6 16:26:44 2009
     Raid Level : raid6
  Used Dev Size : 292961216 (279.39 GiB 299.99 GB)
     Array Size : 7031069184 (6705.35 GiB 7199.81 GB)
   Raid Devices : 26
  Total Devices : 24
Preferred Minor : 0

    Update Time : Fri Feb  6 16:27:11 2009
          State : clean
 Active Devices : 24
Working Devices : 24
 Failed Devices : 2
  Spare Devices : 0
       Checksum : 9b0c003c - correct
         Events : 0.4

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     7       8      129        7      active sync   /dev/sdi1

   0     0       8       17        0      active sync   /dev/sdb1
   1     1       8       33        1      active sync   /dev/sdc1
   2     2       8       49        2      active sync   /dev/sdd1
   3     3       8       65        3      active sync   /dev/sde1
   4     4       8       81        4      active sync   /dev/sdf1
   5     5       8       97        5      active sync   /dev/sdg1
   6     6       0        0        6      faulty removed
   7     7       8      129        7      active sync   /dev/sdi1
   8     8       0        0        8      faulty removed
   9     9       8      161        9      active sync   /dev/sdk1
  10    10       8      177       10      active sync   /dev/sdl1
  11    11       8      193       11      active sync   /dev/sdm1
  12    12       8      209       12      active sync   /dev/sdn1
  13    13       8      225       13      active sync   /dev/sdo1
  14    14       8      241       14      active sync   /dev/sdp1
  15    15      65        1       15      active sync   /dev/sdq1
  16    16      65       17       16      active sync   /dev/sdr1
  17    17      65       49       17      active sync   /dev/sdt1
  18    18      65       65       18      active sync   /dev/sdu1
  19    19      65       81       19      active sync   /dev/sdv1
  20    20      65       97       20      active sync   /dev/sdw1
  21    21      65      113       21      active sync   /dev/sdx1
  22    22      65      129       22      active sync   /dev/sdy1
  23    23      65      145       23      active sync   /dev/sdz1
  24    24      65      161       24      active sync   /dev/sdaa1
  25    25      65      177       25      active sync   /dev/sdab1
mdadm: No md superblock detected on /dev/sdj1.
/dev/sdk1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : ccf28b9d:ea58ca5b:6ec35d57:27415988
  Creation Time : Fri Feb  6 16:26:44 2009
     Raid Level : raid6
  Used Dev Size : 292961216 (279.39 GiB 299.99 GB)
     Array Size : 7031069184 (6705.35 GiB 7199.81 GB)
   Raid Devices : 26
  Total Devices : 24
Preferred Minor : 0

    Update Time : Fri Feb  6 16:27:11 2009
          State : clean
 Active Devices : 24
Working Devices : 24
 Failed Devices : 2
  Spare Devices : 0
       Checksum : 9b0c0060 - correct
         Events : 0.4

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     9       8      161        9      active sync   /dev/sdk1

   0     0       8       17        0      active sync   /dev/sdb1
   1     1       8       33        1      active sync   /dev/sdc1
   2     2       8       49        2      active sync   /dev/sdd1
   3     3       8       65        3      active sync   /dev/sde1
   4     4       8       81        4      active sync   /dev/sdf1
   5     5       8       97        5      active sync   /dev/sdg1
   6     6       0        0        6      faulty removed
   7     7       8      129        7      active sync   /dev/sdi1
   8     8       0        0        8      faulty removed
   9     9       8      161        9      active sync   /dev/sdk1
  10    10       8      177       10      active sync   /dev/sdl1
  11    11       8      193       11      active sync   /dev/sdm1
  12    12       8      209       12      active sync   /dev/sdn1
  13    13       8      225       13      active sync   /dev/sdo1
  14    14       8      241       14      active sync   /dev/sdp1
  15    15      65        1       15      active sync   /dev/sdq1
  16    16      65       17       16      active sync   /dev/sdr1
  17    17      65       49       17      active sync   /dev/sdt1
  18    18      65       65       18      active sync   /dev/sdu1
  19    19      65       81       19      active sync   /dev/sdv1
  20    20      65       97       20      active sync   /dev/sdw1
  21    21      65      113       21      active sync   /dev/sdx1
  22    22      65      129       22      active sync   /dev/sdy1
  23    23      65      145       23      active sync   /dev/sdz1
  24    24      65      161       24      active sync   /dev/sdaa1
  25    25      65      177       25      active sync   /dev/sdab1
/dev/sdl1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : ccf28b9d:ea58ca5b:6ec35d57:27415988
  Creation Time : Fri Feb  6 16:26:44 2009
     Raid Level : raid6
  Used Dev Size : 292961216 (279.39 GiB 299.99 GB)
     Array Size : 7031069184 (6705.35 GiB 7199.81 GB)
   Raid Devices : 26
  Total Devices : 24
Preferred Minor : 0

    Update Time : Fri Feb  6 16:27:11 2009
          State : clean
 Active Devices : 24
Working Devices : 24
 Failed Devices : 2
  Spare Devices : 0
       Checksum : 9b0c0072 - correct
         Events : 0.4

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this    10       8      177       10      active sync   /dev/sdl1

   0     0       8       17        0      active sync   /dev/sdb1
   1     1       8       33        1      active sync   /dev/sdc1
   2     2       8       49        2      active sync   /dev/sdd1
   3     3       8       65        3      active sync   /dev/sde1
   4     4       8       81        4      active sync   /dev/sdf1
   5     5       8       97        5      active sync   /dev/sdg1
   6     6       0        0        6      faulty removed
   7     7       8      129        7      active sync   /dev/sdi1
   8     8       0        0        8      faulty removed
   9     9       8      161        9      active sync   /dev/sdk1
  10    10       8      177       10      active sync   /dev/sdl1
  11    11       8      193       11      active sync   /dev/sdm1
  12    12       8      209       12      active sync   /dev/sdn1
  13    13       8      225       13      active sync   /dev/sdo1
  14    14       8      241       14      active sync   /dev/sdp1
  15    15      65        1       15      active sync   /dev/sdq1
  16    16      65       17       16      active sync   /dev/sdr1
  17    17      65       49       17      active sync   /dev/sdt1
  18    18      65       65       18      active sync   /dev/sdu1
  19    19      65       81       19      active sync   /dev/sdv1
  20    20      65       97       20      active sync   /dev/sdw1
  21    21      65      113       21      active sync   /dev/sdx1
  22    22      65      129       22      active sync   /dev/sdy1
  23    23      65      145       23      active sync   /dev/sdz1
  24    24      65      161       24      active sync   /dev/sdaa1
  25    25      65      177       25      active sync   /dev/sdab1
/dev/sdm1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : ccf28b9d:ea58ca5b:6ec35d57:27415988
  Creation Time : Fri Feb  6 16:26:44 2009
     Raid Level : raid6
  Used Dev Size : 292961216 (279.39 GiB 299.99 GB)
     Array Size : 7031069184 (6705.35 GiB 7199.81 GB)
   Raid Devices : 26
  Total Devices : 24
Preferred Minor : 0

    Update Time : Fri Feb  6 16:27:11 2009
          State : clean
 Active Devices : 24
Working Devices : 24
 Failed Devices : 2
  Spare Devices : 0
       Checksum : 9b0c0084 - correct
         Events : 0.4

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this    11       8      193       11      active sync   /dev/sdm1

   0     0       8       17        0      active sync   /dev/sdb1
   1     1       8       33        1      active sync   /dev/sdc1
   2     2       8       49        2      active sync   /dev/sdd1
   3     3       8       65        3      active sync   /dev/sde1
   4     4       8       81        4      active sync   /dev/sdf1
   5     5       8       97        5      active sync   /dev/sdg1
   6     6       0        0        6      faulty removed
   7     7       8      129        7      active sync   /dev/sdi1
   8     8       0        0        8      faulty removed
   9     9       8      161        9      active sync   /dev/sdk1
  10    10       8      177       10      active sync   /dev/sdl1
  11    11       8      193       11      active sync   /dev/sdm1
  12    12       8      209       12      active sync   /dev/sdn1
  13    13       8      225       13      active sync   /dev/sdo1
  14    14       8      241       14      active sync   /dev/sdp1
  15    15      65        1       15      active sync   /dev/sdq1
  16    16      65       17       16      active sync   /dev/sdr1
  17    17      65       49       17      active sync   /dev/sdt1
  18    18      65       65       18      active sync   /dev/sdu1
  19    19      65       81       19      active sync   /dev/sdv1
  20    20      65       97       20      active sync   /dev/sdw1
  21    21      65      113       21      active sync   /dev/sdx1
  22    22      65      129       22      active sync   /dev/sdy1
  23    23      65      145       23      active sync   /dev/sdz1
  24    24      65      161       24      active sync   /dev/sdaa1
  25    25      65      177       25      active sync   /dev/sdab1
/dev/sdn1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : ccf28b9d:ea58ca5b:6ec35d57:27415988
  Creation Time : Fri Feb  6 16:26:44 2009
     Raid Level : raid6
  Used Dev Size : 292961216 (279.39 GiB 299.99 GB)
     Array Size : 7031069184 (6705.35 GiB 7199.81 GB)
   Raid Devices : 26
  Total Devices : 24
Preferred Minor : 0

    Update Time : Fri Feb  6 16:27:11 2009
          State : clean
 Active Devices : 24
Working Devices : 24
 Failed Devices : 2
  Spare Devices : 0
       Checksum : 9b0c0096 - correct
         Events : 0.4

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this    12       8      209       12      active sync   /dev/sdn1

   0     0       8       17        0      active sync   /dev/sdb1
   1     1       8       33        1      active sync   /dev/sdc1
   2     2       8       49        2      active sync   /dev/sdd1
   3     3       8       65        3      active sync   /dev/sde1
   4     4       8       81        4      active sync   /dev/sdf1
   5     5       8       97        5      active sync   /dev/sdg1
   6     6       0        0        6      faulty removed
   7     7       8      129        7      active sync   /dev/sdi1
   8     8       0        0        8      faulty removed
   9     9       8      161        9      active sync   /dev/sdk1
  10    10       8      177       10      active sync   /dev/sdl1
  11    11       8      193       11      active sync   /dev/sdm1
  12    12       8      209       12      active sync   /dev/sdn1
  13    13       8      225       13      active sync   /dev/sdo1
  14    14       8      241       14      active sync   /dev/sdp1
  15    15      65        1       15      active sync   /dev/sdq1
  16    16      65       17       16      active sync   /dev/sdr1
  17    17      65       49       17      active sync   /dev/sdt1
  18    18      65       65       18      active sync   /dev/sdu1
  19    19      65       81       19      active sync   /dev/sdv1
  20    20      65       97       20      active sync   /dev/sdw1
  21    21      65      113       21      active sync   /dev/sdx1
  22    22      65      129       22      active sync   /dev/sdy1
  23    23      65      145       23      active sync   /dev/sdz1
  24    24      65      161       24      active sync   /dev/sdaa1
  25    25      65      177       25      active sync   /dev/sdab1
/dev/sdo1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : ccf28b9d:ea58ca5b:6ec35d57:27415988
  Creation Time : Fri Feb  6 16:26:44 2009
     Raid Level : raid6
  Used Dev Size : 292961216 (279.39 GiB 299.99 GB)
     Array Size : 7031069184 (6705.35 GiB 7199.81 GB)
   Raid Devices : 26
  Total Devices : 24
Preferred Minor : 0

    Update Time : Fri Feb  6 16:27:11 2009
          State : clean
 Active Devices : 24
Working Devices : 24
 Failed Devices : 2
  Spare Devices : 0
       Checksum : 9b0c00a8 - correct
         Events : 0.4

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this    13       8      225       13      active sync   /dev/sdo1

   0     0       8       17        0      active sync   /dev/sdb1
   1     1       8       33        1      active sync   /dev/sdc1
   2     2       8       49        2      active sync   /dev/sdd1
   3     3       8       65        3      active sync   /dev/sde1
   4     4       8       81        4      active sync   /dev/sdf1
   5     5       8       97        5      active sync   /dev/sdg1
   6     6       0        0        6      faulty removed
   7     7       8      129        7      active sync   /dev/sdi1
   8     8       0        0        8      faulty removed
   9     9       8      161        9      active sync   /dev/sdk1
  10    10       8      177       10      active sync   /dev/sdl1
  11    11       8      193       11      active sync   /dev/sdm1
  12    12       8      209       12      active sync   /dev/sdn1
  13    13       8      225       13      active sync   /dev/sdo1
  14    14       8      241       14      active sync   /dev/sdp1
  15    15      65        1       15      active sync   /dev/sdq1
  16    16      65       17       16      active sync   /dev/sdr1
  17    17      65       49       17      active sync   /dev/sdt1
  18    18      65       65       18      active sync   /dev/sdu1
  19    19      65       81       19      active sync   /dev/sdv1
  20    20      65       97       20      active sync   /dev/sdw1
  21    21      65      113       21      active sync   /dev/sdx1
  22    22      65      129       22      active sync   /dev/sdy1
  23    23      65      145       23      active sync   /dev/sdz1
  24    24      65      161       24      active sync   /dev/sdaa1
  25    25      65      177       25      active sync   /dev/sdab1
/dev/sdp1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : ccf28b9d:ea58ca5b:6ec35d57:27415988
  Creation Time : Fri Feb  6 16:26:44 2009
     Raid Level : raid6
  Used Dev Size : 292961216 (279.39 GiB 299.99 GB)
     Array Size : 7031069184 (6705.35 GiB 7199.81 GB)
   Raid Devices : 26
  Total Devices : 24
Preferred Minor : 0

    Update Time : Fri Feb  6 16:27:11 2009
          State : clean
 Active Devices : 24
Working Devices : 24
 Failed Devices : 2
  Spare Devices : 0
       Checksum : 9b0c00ba - correct
         Events : 0.4

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this    14       8      241       14      active sync   /dev/sdp1

   0     0       8       17        0      active sync   /dev/sdb1
   1     1       8       33        1      active sync   /dev/sdc1
   2     2       8       49        2      active sync   /dev/sdd1
   3     3       8       65        3      active sync   /dev/sde1
   4     4       8       81        4      active sync   /dev/sdf1
   5     5       8       97        5      active sync   /dev/sdg1
   6     6       0        0        6      faulty removed
   7     7       8      129        7      active sync   /dev/sdi1
   8     8       0        0        8      faulty removed
   9     9       8      161        9      active sync   /dev/sdk1
  10    10       8      177       10      active sync   /dev/sdl1
  11    11       8      193       11      active sync   /dev/sdm1
  12    12       8      209       12      active sync   /dev/sdn1
  13    13       8      225       13      active sync   /dev/sdo1
  14    14       8      241       14      active sync   /dev/sdp1
  15    15      65        1       15      active sync   /dev/sdq1
  16    16      65       17       16      active sync   /dev/sdr1
  17    17      65       49       17      active sync   /dev/sdt1
  18    18      65       65       18      active sync   /dev/sdu1
  19    19      65       81       19      active sync   /dev/sdv1
  20    20      65       97       20      active sync   /dev/sdw1
  21    21      65      113       21      active sync   /dev/sdx1
  22    22      65      129       22      active sync   /dev/sdy1
  23    23      65      145       23      active sync   /dev/sdz1
  24    24      65      161       24      active sync   /dev/sdaa1
  25    25      65      177       25      active sync   /dev/sdab1
/dev/sdq1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : ccf28b9d:ea58ca5b:6ec35d57:27415988
  Creation Time : Fri Feb  6 16:26:44 2009
     Raid Level : raid6
  Used Dev Size : 292961216 (279.39 GiB 299.99 GB)
     Array Size : 7031069184 (6705.35 GiB 7199.81 GB)
   Raid Devices : 26
  Total Devices : 24
Preferred Minor : 0

    Update Time : Fri Feb  6 16:27:11 2009
          State : clean
 Active Devices : 24
Working Devices : 24
 Failed Devices : 2
  Spare Devices : 0
       Checksum : 9b0c0005 - correct
         Events : 0.4

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this    15      65        1       15      active sync   /dev/sdq1

   0     0       8       17        0      active sync   /dev/sdb1
   1     1       8       33        1      active sync   /dev/sdc1
   2     2       8       49        2      active sync   /dev/sdd1
   3     3       8       65        3      active sync   /dev/sde1
   4     4       8       81        4      active sync   /dev/sdf1
   5     5       8       97        5      active sync   /dev/sdg1
   6     6       0        0        6      faulty removed
   7     7       8      129        7      active sync   /dev/sdi1
   8     8       0        0        8      faulty removed
   9     9       8      161        9      active sync   /dev/sdk1
  10    10       8      177       10      active sync   /dev/sdl1
  11    11       8      193       11      active sync   /dev/sdm1
  12    12       8      209       12      active sync   /dev/sdn1
  13    13       8      225       13      active sync   /dev/sdo1
  14    14       8      241       14      active sync   /dev/sdp1
  15    15      65        1       15      active sync   /dev/sdq1
  16    16      65       17       16      active sync   /dev/sdr1
  17    17      65       49       17      active sync   /dev/sdt1
  18    18      65       65       18      active sync   /dev/sdu1
  19    19      65       81       19      active sync   /dev/sdv1
  20    20      65       97       20      active sync   /dev/sdw1
  21    21      65      113       21      active sync   /dev/sdx1
  22    22      65      129       22      active sync   /dev/sdy1
  23    23      65      145       23      active sync   /dev/sdz1
  24    24      65      161       24      active sync   /dev/sdaa1
  25    25      65      177       25      active sync   /dev/sdab1
/dev/sdr1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : ccf28b9d:ea58ca5b:6ec35d57:27415988
  Creation Time : Fri Feb  6 16:26:44 2009
     Raid Level : raid6
  Used Dev Size : 292961216 (279.39 GiB 299.99 GB)
     Array Size : 7031069184 (6705.35 GiB 7199.81 GB)
   Raid Devices : 26
  Total Devices : 24
Preferred Minor : 0

    Update Time : Fri Feb  6 16:27:11 2009
          State : clean
 Active Devices : 24
Working Devices : 24
 Failed Devices : 2
  Spare Devices : 0
       Checksum : 9b0c0017 - correct
         Events : 0.4

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this    16      65       17       16      active sync   /dev/sdr1

   0     0       8       17        0      active sync   /dev/sdb1
   1     1       8       33        1      active sync   /dev/sdc1
   2     2       8       49        2      active sync   /dev/sdd1
   3     3       8       65        3      active sync   /dev/sde1
   4     4       8       81        4      active sync   /dev/sdf1
   5     5       8       97        5      active sync   /dev/sdg1
   6     6       0        0        6      faulty removed
   7     7       8      129        7      active sync   /dev/sdi1
   8     8       0        0        8      faulty removed
   9     9       8      161        9      active sync   /dev/sdk1
  10    10       8      177       10      active sync   /dev/sdl1
  11    11       8      193       11      active sync   /dev/sdm1
  12    12       8      209       12      active sync   /dev/sdn1
  13    13       8      225       13      active sync   /dev/sdo1
  14    14       8      241       14      active sync   /dev/sdp1
  15    15      65        1       15      active sync   /dev/sdq1
  16    16      65       17       16      active sync   /dev/sdr1
  17    17      65       49       17      active sync   /dev/sdt1
  18    18      65       65       18      active sync   /dev/sdu1
  19    19      65       81       19      active sync   /dev/sdv1
  20    20      65       97       20      active sync   /dev/sdw1
  21    21      65      113       21      active sync   /dev/sdx1
  22    22      65      129       22      active sync   /dev/sdy1
  23    23      65      145       23      active sync   /dev/sdz1
  24    24      65      161       24      active sync   /dev/sdaa1
  25    25      65      177       25      active sync   /dev/sdab1
/dev/sds1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 216d848a:ec7c507e:d27b1c78:ee592a9e
  Creation Time : Fri Feb  6 16:06:02 2009
     Raid Level : raid6
  Used Dev Size : 292961216 (279.39 GiB 299.99 GB)
     Array Size : 7324030400 (6984.74 GiB 7499.81 GB)
   Raid Devices : 27
  Total Devices : 27
Preferred Minor : 0

    Update Time : Fri Feb  6 16:06:02 2009
          State : active
 Active Devices : 24
Working Devices : 24
 Failed Devices : 3
  Spare Devices : 0
       Checksum : 1c7a06a4 - correct
         Events : 0.1

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this    17      65      145       17      active sync   /dev/sdz1

   0     0       8       17        0      active sync   /dev/sdb1
   1     1       8       33        1      active sync   /dev/sdc1
   2     2       8       49        2      active sync   /dev/sdd1
   3     3       8       65        3      active sync   /dev/sde1
   4     4       8       81        4      active sync   /dev/sdf1
   5     5       8       97        5      active sync   /dev/sdg1
   6     6       0        0        6      faulty
   7     7       8      129        7      active sync   /dev/sdi1
   8     8       0        0        8      faulty
   9     9       8      161        9      active sync   /dev/sdk1
  10    10       8      177       10      active sync   /dev/sdl1
  11    11       8      193       11      active sync   /dev/sdm1
  12    12       8      209       12      active sync   /dev/sdn1
  13    13       8      225       13      active sync   /dev/sdo1
  14    14      65       97       14      active sync   /dev/sdw1
  15    15      65      113       15      active sync   /dev/sdx1
  16    16      65      129       16      active sync   /dev/sdy1
  17    17      65      145       17      active sync   /dev/sdz1
  18    18      65      161       18      active sync   /dev/sdaa1
  19    19      65      177       19      active sync   /dev/sdab1
  20    20      65      193       20      active sync   /dev/sdac1
  21    21       8      241       21      active sync   /dev/sdp1
  22    22      65        1       22      active sync   /dev/sdq1
  23    23      65       17       23      active sync   /dev/sdr1
  24    24       0        0       24      faulty
  25    25      65       49       25      active sync   /dev/sdt1
  26    26      65       65       26      active sync   /dev/sdu1
/dev/sdt1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : ccf28b9d:ea58ca5b:6ec35d57:27415988
  Creation Time : Fri Feb  6 16:26:44 2009
     Raid Level : raid6
  Used Dev Size : 292961216 (279.39 GiB 299.99 GB)
     Array Size : 7031069184 (6705.35 GiB 7199.81 GB)
   Raid Devices : 26
  Total Devices : 24
Preferred Minor : 0

    Update Time : Fri Feb  6 16:27:11 2009
          State : clean
 Active Devices : 24
Working Devices : 24
 Failed Devices : 2
  Spare Devices : 0
       Checksum : 9b0c0039 - correct
         Events : 0.4

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this    17      65       49       17      active sync   /dev/sdt1

   0     0       8       17        0      active sync   /dev/sdb1
   1     1       8       33        1      active sync   /dev/sdc1
   2     2       8       49        2      active sync   /dev/sdd1
   3     3       8       65        3      active sync   /dev/sde1
   4     4       8       81        4      active sync   /dev/sdf1
   5     5       8       97        5      active sync   /dev/sdg1
   6     6       0        0        6      faulty removed
   7     7       8      129        7      active sync   /dev/sdi1
   8     8       0        0        8      faulty removed
   9     9       8      161        9      active sync   /dev/sdk1
  10    10       8      177       10      active sync   /dev/sdl1
  11    11       8      193       11      active sync   /dev/sdm1
  12    12       8      209       12      active sync   /dev/sdn1
  13    13       8      225       13      active sync   /dev/sdo1
  14    14       8      241       14      active sync   /dev/sdp1
  15    15      65        1       15      active sync   /dev/sdq1
  16    16      65       17       16      active sync   /dev/sdr1
  17    17      65       49       17      active sync   /dev/sdt1
  18    18      65       65       18      active sync   /dev/sdu1
  19    19      65       81       19      active sync   /dev/sdv1
  20    20      65       97       20      active sync   /dev/sdw1
  21    21      65      113       21      active sync   /dev/sdx1
  22    22      65      129       22      active sync   /dev/sdy1
  23    23      65      145       23      active sync   /dev/sdz1
  24    24      65      161       24      active sync   /dev/sdaa1
  25    25      65      177       25      active sync   /dev/sdab1
/dev/sdu1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : ccf28b9d:ea58ca5b:6ec35d57:27415988
  Creation Time : Fri Feb  6 16:26:44 2009
     Raid Level : raid6
  Used Dev Size : 292961216 (279.39 GiB 299.99 GB)
     Array Size : 7031069184 (6705.35 GiB 7199.81 GB)
   Raid Devices : 26
  Total Devices : 24
Preferred Minor : 0

    Update Time : Fri Feb  6 16:27:11 2009
          State : clean
 Active Devices : 24
Working Devices : 24
 Failed Devices : 2
  Spare Devices : 0
       Checksum : 9b0c004b - correct
         Events : 0.4

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this    18      65       65       18      active sync   /dev/sdu1

   0     0       8       17        0      active sync   /dev/sdb1
   1     1       8       33        1      active sync   /dev/sdc1
   2     2       8       49        2      active sync   /dev/sdd1
   3     3       8       65        3      active sync   /dev/sde1
   4     4       8       81        4      active sync   /dev/sdf1
   5     5       8       97        5      active sync   /dev/sdg1
   6     6       0        0        6      faulty removed
   7     7       8      129        7      active sync   /dev/sdi1
   8     8       0        0        8      faulty removed
   9     9       8      161        9      active sync   /dev/sdk1
  10    10       8      177       10      active sync   /dev/sdl1
  11    11       8      193       11      active sync   /dev/sdm1
  12    12       8      209       12      active sync   /dev/sdn1
  13    13       8      225       13      active sync   /dev/sdo1
  14    14       8      241       14      active sync   /dev/sdp1
  15    15      65        1       15      active sync   /dev/sdq1
  16    16      65       17       16      active sync   /dev/sdr1
  17    17      65       49       17      active sync   /dev/sdt1
  18    18      65       65       18      active sync   /dev/sdu1
  19    19      65       81       19      active sync   /dev/sdv1
  20    20      65       97       20      active sync   /dev/sdw1
  21    21      65      113       21      active sync   /dev/sdx1
  22    22      65      129       22      active sync   /dev/sdy1
  23    23      65      145       23      active sync   /dev/sdz1
  24    24      65      161       24      active sync   /dev/sdaa1
  25    25      65      177       25      active sync   /dev/sdab1
/dev/sdv1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : ccf28b9d:ea58ca5b:6ec35d57:27415988
  Creation Time : Fri Feb  6 16:26:44 2009
     Raid Level : raid6
  Used Dev Size : 292961216 (279.39 GiB 299.99 GB)
     Array Size : 7031069184 (6705.35 GiB 7199.81 GB)
   Raid Devices : 26
  Total Devices : 24
Preferred Minor : 0

    Update Time : Fri Feb  6 16:27:11 2009
          State : clean
 Active Devices : 24
Working Devices : 24
 Failed Devices : 2
  Spare Devices : 0
       Checksum : 9b0c005d - correct
         Events : 0.4

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this    19      65       81       19      active sync   /dev/sdv1

   0     0       8       17        0      active sync   /dev/sdb1
   1     1       8       33        1      active sync   /dev/sdc1
   2     2       8       49        2      active sync   /dev/sdd1
   3     3       8       65        3      active sync   /dev/sde1
   4     4       8       81        4      active sync   /dev/sdf1
   5     5       8       97        5      active sync   /dev/sdg1
   6     6       0        0        6      faulty removed
   7     7       8      129        7      active sync   /dev/sdi1
   8     8       0        0        8      faulty removed
   9     9       8      161        9      active sync   /dev/sdk1
  10    10       8      177       10      active sync   /dev/sdl1
  11    11       8      193       11      active sync   /dev/sdm1
  12    12       8      209       12      active sync   /dev/sdn1
  13    13       8      225       13      active sync   /dev/sdo1
  14    14       8      241       14      active sync   /dev/sdp1
  15    15      65        1       15      active sync   /dev/sdq1
  16    16      65       17       16      active sync   /dev/sdr1
  17    17      65       49       17      active sync   /dev/sdt1
  18    18      65       65       18      active sync   /dev/sdu1
  19    19      65       81       19      active sync   /dev/sdv1
  20    20      65       97       20      active sync   /dev/sdw1
  21    21      65      113       21      active sync   /dev/sdx1
  22    22      65      129       22      active sync   /dev/sdy1
  23    23      65      145       23      active sync   /dev/sdz1
  24    24      65      161       24      active sync   /dev/sdaa1
  25    25      65      177       25      active sync   /dev/sdab1
/dev/sdw1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : ccf28b9d:ea58ca5b:6ec35d57:27415988
  Creation Time : Fri Feb  6 16:26:44 2009
     Raid Level : raid6
  Used Dev Size : 292961216 (279.39 GiB 299.99 GB)
     Array Size : 7031069184 (6705.35 GiB 7199.81 GB)
   Raid Devices : 26
  Total Devices : 24
Preferred Minor : 0

    Update Time : Fri Feb  6 16:27:11 2009
          State : clean
 Active Devices : 24
Working Devices : 24
 Failed Devices : 2
  Spare Devices : 0
       Checksum : 9b0c006f - correct
         Events : 0.4

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this    20      65       97       20      active sync   /dev/sdw1

   0     0       8       17        0      active sync   /dev/sdb1
   1     1       8       33        1      active sync   /dev/sdc1
   2     2       8       49        2      active sync   /dev/sdd1
   3     3       8       65        3      active sync   /dev/sde1
   4     4       8       81        4      active sync   /dev/sdf1
   5     5       8       97        5      active sync   /dev/sdg1
   6     6       0        0        6      faulty removed
   7     7       8      129        7      active sync   /dev/sdi1
   8     8       0        0        8      faulty removed
   9     9       8      161        9      active sync   /dev/sdk1
  10    10       8      177       10      active sync   /dev/sdl1
  11    11       8      193       11      active sync   /dev/sdm1
  12    12       8      209       12      active sync   /dev/sdn1
  13    13       8      225       13      active sync   /dev/sdo1
  14    14       8      241       14      active sync   /dev/sdp1
  15    15      65        1       15      active sync   /dev/sdq1
  16    16      65       17       16      active sync   /dev/sdr1
  17    17      65       49       17      active sync   /dev/sdt1
  18    18      65       65       18      active sync   /dev/sdu1
  19    19      65       81       19      active sync   /dev/sdv1
  20    20      65       97       20      active sync   /dev/sdw1
  21    21      65      113       21      active sync   /dev/sdx1
  22    22      65      129       22      active sync   /dev/sdy1
  23    23      65      145       23      active sync   /dev/sdz1
  24    24      65      161       24      active sync   /dev/sdaa1
  25    25      65      177       25      active sync   /dev/sdab1
/dev/sdx1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : ccf28b9d:ea58ca5b:6ec35d57:27415988
  Creation Time : Fri Feb  6 16:26:44 2009
     Raid Level : raid6
  Used Dev Size : 292961216 (279.39 GiB 299.99 GB)
     Array Size : 7031069184 (6705.35 GiB 7199.81 GB)
   Raid Devices : 26
  Total Devices : 24
Preferred Minor : 0

    Update Time : Fri Feb  6 16:27:11 2009
          State : clean
 Active Devices : 24
Working Devices : 24
 Failed Devices : 2
  Spare Devices : 0
       Checksum : 9b0c0081 - correct
         Events : 0.4

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this    21      65      113       21      active sync   /dev/sdx1

   0     0       8       17        0      active sync   /dev/sdb1
   1     1       8       33        1      active sync   /dev/sdc1
   2     2       8       49        2      active sync   /dev/sdd1
   3     3       8       65        3      active sync   /dev/sde1
   4     4       8       81        4      active sync   /dev/sdf1
   5     5       8       97        5      active sync   /dev/sdg1
   6     6       0        0        6      faulty removed
   7     7       8      129        7      active sync   /dev/sdi1
   8     8       0        0        8      faulty removed
   9     9       8      161        9      active sync   /dev/sdk1
  10    10       8      177       10      active sync   /dev/sdl1
  11    11       8      193       11      active sync   /dev/sdm1
  12    12       8      209       12      active sync   /dev/sdn1
  13    13       8      225       13      active sync   /dev/sdo1
  14    14       8      241       14      active sync   /dev/sdp1
  15    15      65        1       15      active sync   /dev/sdq1
  16    16      65       17       16      active sync   /dev/sdr1
  17    17      65       49       17      active sync   /dev/sdt1
  18    18      65       65       18      active sync   /dev/sdu1
  19    19      65       81       19      active sync   /dev/sdv1
  20    20      65       97       20      active sync   /dev/sdw1
  21    21      65      113       21      active sync   /dev/sdx1
  22    22      65      129       22      active sync   /dev/sdy1
  23    23      65      145       23      active sync   /dev/sdz1
  24    24      65      161       24      active sync   /dev/sdaa1
  25    25      65      177       25      active sync   /dev/sdab1
/dev/sdy1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : ccf28b9d:ea58ca5b:6ec35d57:27415988
  Creation Time : Fri Feb  6 16:26:44 2009
     Raid Level : raid6
  Used Dev Size : 292961216 (279.39 GiB 299.99 GB)
     Array Size : 7031069184 (6705.35 GiB 7199.81 GB)
   Raid Devices : 26
  Total Devices : 24
Preferred Minor : 0

    Update Time : Fri Feb  6 16:27:11 2009
          State : clean
 Active Devices : 24
Working Devices : 24
 Failed Devices : 2
  Spare Devices : 0
       Checksum : 9b0c0093 - correct
         Events : 0.4

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this    22      65      129       22      active sync   /dev/sdy1

   0     0       8       17        0      active sync   /dev/sdb1
   1     1       8       33        1      active sync   /dev/sdc1
   2     2       8       49        2      active sync   /dev/sdd1
   3     3       8       65        3      active sync   /dev/sde1
   4     4       8       81        4      active sync   /dev/sdf1
   5     5       8       97        5      active sync   /dev/sdg1
   6     6       0        0        6      faulty removed
   7     7       8      129        7      active sync   /dev/sdi1
   8     8       0        0        8      faulty removed
   9     9       8      161        9      active sync   /dev/sdk1
  10    10       8      177       10      active sync   /dev/sdl1
  11    11       8      193       11      active sync   /dev/sdm1
  12    12       8      209       12      active sync   /dev/sdn1
  13    13       8      225       13      active sync   /dev/sdo1
  14    14       8      241       14      active sync   /dev/sdp1
  15    15      65        1       15      active sync   /dev/sdq1
  16    16      65       17       16      active sync   /dev/sdr1
  17    17      65       49       17      active sync   /dev/sdt1
  18    18      65       65       18      active sync   /dev/sdu1
  19    19      65       81       19      active sync   /dev/sdv1
  20    20      65       97       20      active sync   /dev/sdw1
  21    21      65      113       21      active sync   /dev/sdx1
  22    22      65      129       22      active sync   /dev/sdy1
  23    23      65      145       23      active sync   /dev/sdz1
  24    24      65      161       24      active sync   /dev/sdaa1
  25    25      65      177       25      active sync   /dev/sdab1
/dev/sdz1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : ccf28b9d:ea58ca5b:6ec35d57:27415988
  Creation Time : Fri Feb  6 16:26:44 2009
     Raid Level : raid6
  Used Dev Size : 292961216 (279.39 GiB 299.99 GB)
     Array Size : 7031069184 (6705.35 GiB 7199.81 GB)
   Raid Devices : 26
  Total Devices : 24
Preferred Minor : 0

    Update Time : Fri Feb  6 16:27:11 2009
          State : clean
 Active Devices : 24
Working Devices : 24
 Failed Devices : 2
  Spare Devices : 0
       Checksum : 9b0c00a5 - correct
         Events : 0.4

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this    23      65      145       23      active sync   /dev/sdz1

   0     0       8       17        0      active sync   /dev/sdb1
   1     1       8       33        1      active sync   /dev/sdc1
   2     2       8       49        2      active sync   /dev/sdd1
   3     3       8       65        3      active sync   /dev/sde1
   4     4       8       81        4      active sync   /dev/sdf1
   5     5       8       97        5      active sync   /dev/sdg1
   6     6       0        0        6      faulty removed
   7     7       8      129        7      active sync   /dev/sdi1
   8     8       0        0        8      faulty removed
   9     9       8      161        9      active sync   /dev/sdk1
  10    10       8      177       10      active sync   /dev/sdl1
  11    11       8      193       11      active sync   /dev/sdm1
  12    12       8      209       12      active sync   /dev/sdn1
  13    13       8      225       13      active sync   /dev/sdo1
  14    14       8      241       14      active sync   /dev/sdp1
  15    15      65        1       15      active sync   /dev/sdq1
  16    16      65       17       16      active sync   /dev/sdr1
  17    17      65       49       17      active sync   /dev/sdt1
  18    18      65       65       18      active sync   /dev/sdu1
  19    19      65       81       19      active sync   /dev/sdv1
  20    20      65       97       20      active sync   /dev/sdw1
  21    21      65      113       21      active sync   /dev/sdx1
  22    22      65      129       22      active sync   /dev/sdy1
  23    23      65      145       23      active sync   /dev/sdz1
  24    24      65      161       24      active sync   /dev/sdaa1
  25    25      65      177       25      active sync   /dev/sdab1
/dev/sdaa1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : ccf28b9d:ea58ca5b:6ec35d57:27415988
  Creation Time : Fri Feb  6 16:26:44 2009
     Raid Level : raid6
  Used Dev Size : 292961216 (279.39 GiB 299.99 GB)
     Array Size : 7031069184 (6705.35 GiB 7199.81 GB)
   Raid Devices : 26
  Total Devices : 24
Preferred Minor : 0

    Update Time : Fri Feb  6 16:27:11 2009
          State : clean
 Active Devices : 24
Working Devices : 24
 Failed Devices : 2
  Spare Devices : 0
       Checksum : 9b0c00b7 - correct
         Events : 0.4

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this    24      65      161       24      active sync   /dev/sdaa1

   0     0       8       17        0      active sync   /dev/sdb1
   1     1       8       33        1      active sync   /dev/sdc1
   2     2       8       49        2      active sync   /dev/sdd1
   3     3       8       65        3      active sync   /dev/sde1
   4     4       8       81        4      active sync   /dev/sdf1
   5     5       8       97        5      active sync   /dev/sdg1
   6     6       0        0        6      faulty removed
   7     7       8      129        7      active sync   /dev/sdi1
   8     8       0        0        8      faulty removed
   9     9       8      161        9      active sync   /dev/sdk1
  10    10       8      177       10      active sync   /dev/sdl1
  11    11       8      193       11      active sync   /dev/sdm1
  12    12       8      209       12      active sync   /dev/sdn1
  13    13       8      225       13      active sync   /dev/sdo1
  14    14       8      241       14      active sync   /dev/sdp1
  15    15      65        1       15      active sync   /dev/sdq1
  16    16      65       17       16      active sync   /dev/sdr1
  17    17      65       49       17      active sync   /dev/sdt1
  18    18      65       65       18      active sync   /dev/sdu1
  19    19      65       81       19      active sync   /dev/sdv1
  20    20      65       97       20      active sync   /dev/sdw1
  21    21      65      113       21      active sync   /dev/sdx1
  22    22      65      129       22      active sync   /dev/sdy1
  23    23      65      145       23      active sync   /dev/sdz1
  24    24      65      161       24      active sync   /dev/sdaa1
  25    25      65      177       25      active sync   /dev/sdab1
/dev/sdab1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : ccf28b9d:ea58ca5b:6ec35d57:27415988
  Creation Time : Fri Feb  6 16:26:44 2009
     Raid Level : raid6
  Used Dev Size : 292961216 (279.39 GiB 299.99 GB)
     Array Size : 7031069184 (6705.35 GiB 7199.81 GB)
   Raid Devices : 26
  Total Devices : 24
Preferred Minor : 0

    Update Time : Fri Feb  6 16:27:11 2009
          State : clean
 Active Devices : 24
Working Devices : 24
 Failed Devices : 2
  Spare Devices : 0
       Checksum : 9b0c00c9 - correct
         Events : 0.4

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this    25      65      177       25      active sync   /dev/sdab1

   0     0       8       17        0      active sync   /dev/sdb1
   1     1       8       33        1      active sync   /dev/sdc1
   2     2       8       49        2      active sync   /dev/sdd1
   3     3       8       65        3      active sync   /dev/sde1
   4     4       8       81        4      active sync   /dev/sdf1
   5     5       8       97        5      active sync   /dev/sdg1
   6     6       0        0        6      faulty removed
   7     7       8      129        7      active sync   /dev/sdi1
   8     8       0        0        8      faulty removed
   9     9       8      161        9      active sync   /dev/sdk1
  10    10       8      177       10      active sync   /dev/sdl1
  11    11       8      193       11      active sync   /dev/sdm1
  12    12       8      209       12      active sync   /dev/sdn1
  13    13       8      225       13      active sync   /dev/sdo1
  14    14       8      241       14      active sync   /dev/sdp1
  15    15      65        1       15      active sync   /dev/sdq1
  16    16      65       17       16      active sync   /dev/sdr1
  17    17      65       49       17      active sync   /dev/sdt1
  18    18      65       65       18      active sync   /dev/sdu1
  19    19      65       81       19      active sync   /dev/sdv1
  20    20      65       97       20      active sync   /dev/sdw1
  21    21      65      113       21      active sync   /dev/sdx1
  22    22      65      129       22      active sync   /dev/sdy1
  23    23      65      145       23      active sync   /dev/sdz1
  24    24      65      161       24      active sync   /dev/sdaa1
  25    25      65      177       25      active sync   /dev/sdab1
mdadm: No md superblock detected on /dev/sdac1.
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

