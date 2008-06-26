From: "Jon Nelson" <jnelson-linux-raid@jamponi.net>
Subject: Slowww raid check (raid10, f2)
Date: Thu, 26 Jun 2008 08:21:49 -0500
Message-ID: <cccedfc60806260621ud3af517j959f5ce3c2e521ef@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Linux-Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

A few months back, I converted my raid setup from raid5 to raid10,f2,
using the same disks and setup as before.
The setup is an AMD x86-64, 3600+ dual, making use of three 300 GB SATA disks:

The current raid looks like this:

md0 : active raid10 sdb4[0] sdc4[2] sdd4[1]
      460057152 blocks 64K chunks 2 far-copies [3/3] [UUU]
      bitmap: 1/439 pages [4KB], 512KB chunk, file: /md0.bitmap

/dev/md0:
        Version : 00.90.03
  Creation Time : Fri May 23 23:24:20 2008
     Raid Level : raid10
     Array Size : 460057152 (438.74 GiB 471.10 GB)
  Used Dev Size : 306704768 (292.50 GiB 314.07 GB)
   Raid Devices : 3
  Total Devices : 3
Preferred Minor : 0
    Persistence : Superblock is persistent

  Intent Bitmap : /md0.bitmap

    Update Time : Thu Jun 26 08:16:52 2008
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0

         Layout : near=1, far=2
     Chunk Size : 64K

           UUID : ff4e969d:2f07be4e:8c61e068:8406cdc0
         Events : 0.1670

    Number   Major   Minor   RaidDevice State
       0       8       20        0      active sync   /dev/sdb4
       1       8       52        1      active sync   /dev/sdd4
       2       8       36        2      active sync   /dev/sdc4

As you can see, it's comprised of 3x 292 MiB partitions (the other
partitions are unused or used for /boot, so no run-time I/O).

Individually, the disks are capable of some 70 MB/s (give or take).
The raid5 would take 2.5 hours to run a "check".
The raid10,f2 takes substantially longer:

Jun 23 02:30:01 turnip kernel: md: data-check of RAID array md0
Jun 23 07:17:46 turnip kernel: md: md0: data-check done.

Whaaa? 4.75 hours? That's 28MB/s end-to-end. That's about 40% of
actual disk speed. I expected it to be slower but not /that/ much
slower. What might be going on here?

-- 
Jon
