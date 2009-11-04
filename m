From: Adam Huffman <bloch@verdurin.com>
Subject: RAID1 array losing one member
Date: Wed, 4 Nov 2009 16:18:01 +0000
Message-ID: <20091104161801.GC20938@shuttle.verdurin.salon>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


I have an annoying problem with a RAID1 array.

One of the members keeps dropping out of the array:

/dev/md0:
        Version : 0.90
  Creation Time : Sun Jun 28 13:24:02 2009
     Raid Level : raid1
     Array Size : 732571904 (698.64 GiB 750.15 GB)
  Used Dev Size : 732571904 (698.64 GiB 750.15 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Wed Nov  4 16:12:36 2009
          State : clean, degraded
 Active Devices : 1
Working Devices : 1
 Failed Devices : 1
  Spare Devices : 0

           UUID : 281b623a:4f01e4e1:36bee1ae:cd0903da
         Events : 0.4682740

    Number   Major   Minor   RaidDevice State
       0       8        1        0      active sync   /dev/sda1
       1       0        0        1      removed

       2       8       17        -      faulty spare   /dev/sdb1

I've run extended SMART self-tests and the manufacturer's diagnostic
test on the drive - in neither case is any error found.

When I try to re-add the disk, reconstruction of the array begins.
However, it always fails, at different points.

Is there another test I can run to see what might be wrong with the
drive?  Could this be a different MD problem?

The machine is running Fedora 10, 
kernel 2.6.27.37-170.2.104.fc10.x86_64.

This is the device that keeps failing:

/dev/sdb1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 281b623a:4f01e4e1:36bee1ae:cd0903da
  Creation Time : Sun Jun 28 13:24:02 2009
     Raid Level : raid1
  Used Dev Size : 732571904 (698.64 GiB 750.15 GB)
     Array Size : 732571904 (698.64 GiB 750.15 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 0

    Update Time : Tue Nov  3 17:20:42 2009
          State : active
 Active Devices : 1
Working Devices : 2
 Failed Devices : 1
  Spare Devices : 1
       Checksum : e5396754 - correct
         Events : 4651695


      Number   Major   Minor   RaidDevice State
this     2       8       17        2      spare   /dev/sdb1

   0     0       8        1        0      active sync   /dev/sda1
   1     1       0        0        1      faulty removed
   2     2       8       17        2      spare   /dev/sdb1



Adam
