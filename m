From: Redeeman <redeeman@metanurb.dk>
Subject: internal write-intent bitmap, chunksize, superblock
Date: Sat, 23 May 2009 16:34:27 +0200
Message-ID: <1243089267.5740.39.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello.

I have just created a raid6 array with 8 1tb drives, and it uses the
default metadata 0.9.

I have been reading up on write intent bitmaps, and i wish to create an
internal one. I read about different chunk sizes yielding different
performance costs, but one thing i wonder is, how much space is reserved
in the superblock for the bitmap? and what happens if i try to create a
bitmap which would take more than the reserved space?


this is the --detail of the array:
/dev/md0:
        Version : 00.90
  Creation Time : Fri May 22 23:38:18 2009
     Raid Level : raid6
     Array Size : 5860559616 (5589.07 GiB 6001.21 GB)
  Used Dev Size : 976759936 (931.51 GiB 1000.20 GB)
   Raid Devices : 8
  Total Devices : 8
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Sat May 23 16:33:50 2009
          State : active
 Active Devices : 8
Working Devices : 8
 Failed Devices : 0
  Spare Devices : 0

     Chunk Size : 64K

           UUID : 8a52684a:161d95d0:2cd51773:dd992753 (local to host
ida)
         Events : 0.7

    Number   Major   Minor   RaidDevice State
       0       8        1        0      active sync   /dev/sda1
       1       8       17        1      active sync   /dev/sdb1
       2       8       33        2      active sync   /dev/sdc1
       3       8       49        3      active sync   /dev/sdd1
       4       8       65        4      active sync   /dev/sde1
       5       8       81        5      active sync   /dev/sdf1
       6       8       97        6      active sync   /dev/sdg1
       7       8      113        7      active sync   /dev/sdh1


mvh.
Kasper Sandberg

