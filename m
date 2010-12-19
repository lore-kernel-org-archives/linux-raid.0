From: =?ISO-8859-1?Q?Bj=F8rn_Eikeland?= <beikeland@gmail.com>
Subject: best way to try recovering inactive raid6
Date: Sun, 19 Dec 2010 14:21:01 +0100
Message-ID: <AANLkTin71JrpmKJC6df+ZX7jsm7P8RwCzUSfV8CMWk2v@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I've got myself into a pickle:

$ sudo mdadm -As
mdadm: /dev/md6 assembled from 2 drives and 2 spares - not enough to
start the array.

This was a 5 device raid6 array, made up of /dev/sd[abcdh]1. I'm
unsure what caused /dev/sdh to need resync, during this process
/dev/sdb decided it was a good time to get hardware problems, and this
slowed the resync down to <1000kB/s.

Then I got the incredible idea that I didn't need the drive that was
_actually_ failing, and failed/pulled the disk labeled with that
particular serial number, only to find out I had labeled it wrong,
which left me with:

$ cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md6 : inactive sdc1[0](S) sdd1[6](S) sdh1[5](S) sda1[3](S)
      3906236416 blocks

unused devices: <none>

As far as I've gone through google and this list, I should first try
mdadm --assemble --force and if that fails try to re-create the array.

Force assemble fails, so I guess re-create it is. I've looked at
Permute array.pl and just have the following questions

do I need to re-create it to the same /dev/mdN device?
with raid6 should I try permutations with two missing drives or go for
one missing and --assume-clean?
is there any point to ddrescue / clone /dev/sdb when it has a
different event count than the rest?
there is no --read-only involved in creating the array, only mounting?

Hope you guys can help me out with some input here!

regards,
Bjorn


/dev/sda1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 50ed6314:84f965cd:c5795ac2:70ba0679
  Creation Time : Thu May 29 20:51:39 2008
     Raid Level : raid6
  Used Dev Size : 976559104 (931.32 GiB 1000.00 GB)
     Array Size : 2929677312 (2793.96 GiB 2999.99 GB)
   Raid Devices : 5
  Total Devices : 5
Preferred Minor : 6

    Update Time : Sun Dec 19 12:12:34 2010
          State : clean
 Active Devices : 2
Working Devices : 4
 Failed Devices : 3
  Spare Devices : 2
       Checksum : 84f2dc10 - correct
         Events : 1290388

     Chunk Size : 256K

      Number   Major   Minor   RaidDevice State
this     3       8        1        3      active sync   /dev/sda1

   0     0       8       33        0      active sync   /dev/sdc1
   1     1       0        0        1      faulty removed
   2     2       0        0        2      faulty removed
   3     3       8        1        3      active sync   /dev/sda1
   4     4       0        0        4      faulty removed
   5     5       8      113        5      spare   /dev/sdh1
   6     6       8       49        6      spare   /dev/sdd1
-----------------------------------------------------------------
   /dev/sdb1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 50ed6314:84f965cd:c5795ac2:70ba0679
  Creation Time : Thu May 29 20:51:39 2008
     Raid Level : raid6
  Used Dev Size : 976559104 (931.32 GiB 1000.00 GB)
     Array Size : 2929677312 (2793.96 GiB 2999.99 GB)
   Raid Devices : 5
  Total Devices : 4
Preferred Minor : 6

    Update Time : Sun Dec 19 12:02:52 2010
          State : active
 Active Devices : 3
Working Devices : 4
 Failed Devices : 2
  Spare Devices : 1
       Checksum : 84df28e2 - correct
         Events : 1290382

     Chunk Size : 256K

      Number   Major   Minor   RaidDevice State
this     1       8       17        1      active sync   /dev/sdb1

   0     0       8       33        0      active sync   /dev/sdc1
   1     1       8       17        1      active sync   /dev/sdb1
   2     2       0        0        2      faulty removed
   3     3       8        1        3      active sync   /dev/sda1
   4     4       0        0        4      faulty removed
   5     5       8      113        5      spare   /dev/sdh1
-----------------------------------------------------------------
/dev/sdc1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 50ed6314:84f965cd:c5795ac2:70ba0679
  Creation Time : Thu May 29 20:51:39 2008
     Raid Level : raid6
  Used Dev Size : 976559104 (931.32 GiB 1000.00 GB)
     Array Size : 2929677312 (2793.96 GiB 2999.99 GB)
   Raid Devices : 5
  Total Devices : 5
Preferred Minor : 6

    Update Time : Sun Dec 19 12:12:34 2010
          State : clean
 Active Devices : 2
Working Devices : 4
 Failed Devices : 3
  Spare Devices : 2
       Checksum : 84f2dc2a - correct
         Events : 1290388

     Chunk Size : 256K

      Number   Major   Minor   RaidDevice State
this     0       8       33        0      active sync   /dev/sdc1

   0     0       8       33        0      active sync   /dev/sdc1
   1     1       0        0        1      faulty removed
   2     2       0        0        2      faulty removed
   3     3       8        1        3      active sync   /dev/sda1
   4     4       0        0        4      faulty removed
   5     5       8      113        5      spare   /dev/sdh1
   6     6       8       49        6      spare   /dev/sdd1
-----------------------------------------------------------------
/dev/sdd1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 50ed6314:84f965cd:c5795ac2:70ba0679
  Creation Time : Thu May 29 20:51:39 2008
     Raid Level : raid6
  Used Dev Size : 976559104 (931.32 GiB 1000.00 GB)
     Array Size : 2929677312 (2793.96 GiB 2999.99 GB)
   Raid Devices : 5
  Total Devices : 5
Preferred Minor : 6

    Update Time : Sun Dec 19 12:12:34 2010
          State : clean
 Active Devices : 2
Working Devices : 4
 Failed Devices : 3
  Spare Devices : 2
       Checksum : 84f2dc40 - correct
         Events : 1290388

     Chunk Size : 256K

      Number   Major   Minor   RaidDevice State
this     6       8       49        6      spare   /dev/sdd1

   0     0       8       33        0      active sync   /dev/sdc1
   1     1       0        0        1      faulty removed
   2     2       0        0        2      faulty removed
   3     3       8        1        3      active sync   /dev/sda1
   4     4       0        0        4      faulty removed
   5     5       8      113        5      spare   /dev/sdh1
   6     6       8       49        6      spare   /dev/sdd1
-----------------------------------------------------------------
/dev/sdh1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 50ed6314:84f965cd:c5795ac2:70ba0679
  Creation Time : Thu May 29 20:51:39 2008
     Raid Level : raid6
  Used Dev Size : 976559104 (931.32 GiB 1000.00 GB)
     Array Size : 2929677312 (2793.96 GiB 2999.99 GB)
   Raid Devices : 5
  Total Devices : 5
Preferred Minor : 6

    Update Time : Sun Dec 19 12:12:34 2010
          State : clean
 Active Devices : 2
Working Devices : 4
 Failed Devices : 3
  Spare Devices : 2
       Checksum : 84f2dc7e - correct
         Events : 1290388

     Chunk Size : 256K

      Number   Major   Minor   RaidDevice State
this     5       8      113        5      spare   /dev/sdh1

   0     0       8       33        0      active sync   /dev/sdc1
   1     1       0        0        1      faulty removed
   2     2       0        0        2      faulty removed
   3     3       8        1        3      active sync   /dev/sda1
   4     4       0        0        4      faulty removed
   5     5       8      113        5      spare   /dev/sdh1
   6     6       8       49        6      spare   /dev/sdd1
