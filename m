From: Dan Christensen <jdc@uwo.ca>
Subject: RAID-5 streaming read performance
Date: Mon, 11 Jul 2005 11:11:28 -0400
Message-ID: <874qb14btr.fsf@uwo.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I was wondering what I should expect in terms of streaming read
performance when using (software) RAID-5 with four SATA drives.  I
thought I would get a noticeable improvement compared to reads from a
single device, but that's not the case.  I tested this by using dd to
read 300MB directly from disk partitions /dev/sda7, etc, and also using
dd to read 300MB directly from the raid device (/dev/md2 in this case).
I get around 57MB/s from each of the disk partitions that make up the
raid device, and about 58MB/s from the raid device.  On the other
hand, if I run parallel reads from the component partitions, I get
25 to 30MB/s each, so the bus can clearly achieve more than 100MB/s.

Before each read, I try to clear the kernel's cache by reading
900MB from an unrelated partition on the disk.  (Is this guaranteed
to work?  Is there a better and/or faster way to clear cache?)

I have AAM quiet mode/low performance enabled on the drives, but (a)
this shouldn't matter too much for streaming reads, and (b) it's the
relative performance of the reads from the partitions and the RAID
device that I'm curious about.

I also get poor write performance, but that's harder to isolate
because I have to go through the lvm and filesystem layers too.

I also get poor performance from my RAID-1 array and my other
RAID-5 arrays.

Details of my tests and set-up below.

Thanks for any suggestions,

Dan


System:
- Athlon 2500+
- kernel 2.6.12.2 (also tried 2.6.11.11)
- four SATA drives (3 160G, 1 200G); Samsung Spinpoint
- SiI3114 controller (latency_timer=32 by default; tried 128 too)
- 1G ram
- blockdev --getra /dev/sda  -->  256   (didn't play with these)
- blockdev --getra /dev/md2  -->  768   (didn't play with this)
- tried anticipatory, deadline and cfq schedules, with no significant
  difference.
- machine essentially idle during tests

Here is part of /proc/mdstat (the full output is below):

md2 : active raid5 sdd5[3] sdc5[2] sdb5[1] sda7[0]
      218612160 blocks level 5, 64k chunk, algorithm 2 [4/4] [UUUU]
      
Here's the test script and output:

# Clear cache:
dd if=/dev/sda8 of=/dev/null bs=1M count=900 > /dev/null 2>&1
for f in sda7 sdb5 sdc5 sdd5 ; do 
  echo $f
  dd if=/dev/$f of=/dev/null bs=1M count=300 2>&1 | grep bytes/sec
  echo
done

# Clear cache:
dd if=/dev/sda8 of=/dev/null bs=1M count=900 > /dev/null 2>&1
for f in md2 ; do 
  echo $f
  dd if=/dev/$f of=/dev/null bs=1M count=300 2>&1 | grep bytes/sec
  echo
done

Output:

sda7
314572800 bytes transferred in 5.401071 seconds (58242671 bytes/sec)

sdb5
314572800 bytes transferred in 5.621170 seconds (55962158 bytes/sec)

sdc5
314572800 bytes transferred in 5.635491 seconds (55819947 bytes/sec)

sdd5
314572800 bytes transferred in 5.333374 seconds (58981951 bytes/sec)

md2
314572800 bytes transferred in 5.386627 seconds (58398846 bytes/sec)

# cat /proc/mdstat
md1 : active raid5 sdd1[2] sdc1[1] sda2[0]
      578048 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]
      
md4 : active raid5 sdd2[3] sdc2[2] sdb2[1] sda6[0]
      30748032 blocks level 5, 64k chunk, algorithm 2 [4/4] [UUUU]
      
md2 : active raid5 sdd5[3] sdc5[2] sdb5[1] sda7[0]
      218612160 blocks level 5, 64k chunk, algorithm 2 [4/4] [UUUU]
      
md3 : active raid5 sdd6[3] sdc6[2] sdb6[1] sda8[0]
      218636160 blocks level 5, 64k chunk, algorithm 2 [4/4] [UUUU]
      
md0 : active raid1 sdb1[0] sda5[1]
      289024 blocks [2/2] [UU]

# mdadm --detail /dev/md2
/dev/md2:
        Version : 00.90.01
  Creation Time : Mon Jul  4 23:54:34 2005
     Raid Level : raid5
     Array Size : 218612160 (208.48 GiB 223.86 GB)
    Device Size : 72870720 (69.49 GiB 74.62 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 2
    Persistence : Superblock is persistent

    Update Time : Thu Jul  7 21:52:50 2005
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

           UUID : c4056d19:7b4bb550:44925b88:91d5bc8a
         Events : 0.10873823

    Number   Major   Minor   RaidDevice State
       0       8        7        0      active sync   /dev/sda7
       1       8       21        1      active sync   /dev/sdb5
       2       8       37        2      active sync   /dev/sdc5
       3       8       53        3      active sync   /dev/sdd5

