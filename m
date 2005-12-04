From: Alfons Andorfer <a_a@gmx.de>
Subject: RAID5 problem
Date: Sun, 04 Dec 2005 15:21:48 +0100
Message-ID: <4392FB7C.6080600@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@cse.unsw.edu.au
List-Id: linux-raid.ids

Hi,

I have a RAID5 array consisting of 4 disks:

/dev/hda3
/dev/hdc3
/dev/hde3
/dev/hdg3

and the Linux machine that this system was running on crashed yesterday 
due to a faulty Kernel driver (i.e. the machine just halted).
So I resetted it, but it didn't come up again.
I started the machine with a Knoppix CD and found out that the array had 
been running in degraded mode for about two months (/dev/hda3 went off 
then).

When I do a

mdadm --assemble /dev/md0 --force /dev/hd[ceg]3

I get

mdadm: forcing event count in /dev/hdc3(1) from 515 upto 516
mdadm: /dev/md0 has been started with 3 drives (out of 4).

I can mount the array with

mount /dev/md0 /mount/

and the data seems to be OK.
But after a

umount /dev/md0

and a

fsck -n /dev/md0

it stops with an error

"pass 1: checking Inodes, Blocks, and sizes
read error - Block 131460 (Attempt to read block from filesystem 
resulted in short read) during Inode-Scan  Ignore error?"

and if I do the fsck with

e2fsck  -y /dev/md0

I get tons of read errors of the type "(Attempt to read block from 
filesystem resulted in short read)" and the event counter of the 
/dev/hdc3 is then just one _behind_ of the event counters of /dev/hde3 
and /dev/hdg3 which is really strange to me!?!


Then I tried

mdadm -S /dev/md0
mdadm --create /dev/md0 -c32 -l5 -n4 missing /dev/hdc3 /dev/hde3 /dev/hdg3

which resultet in

mdadm: /dev/hdc3 appears to be part of a raid array:
     level=5 devices=4 ctime=Fri May 30 14:25:47 2003
mdadm: /dev/hde3 appears to be part of a raid array:
     level=5 devices=4 ctime=Fri May 30 14:25:47 2003
mdadm: /dev/hdg3 appears to contain an ext2fs file system
     size=493736704K  mtime=Tue Jan  3 04:48:21 2006
mdadm: /dev/hdg3 appears to be part of a raid array:
     level=5 devices=4 ctime=Fri May 30 14:25:47 2003
Continue creating array? no
mdadm: create aborted.

I aborted the above because it look strange to me that /dev/hdg3 appears 
two times and /dev/hda3 doesn't at all!?!

So this is where I got stuck, any help appreciated!





Here are the outputs of

cat /mount/etc/raidtab

and

mdadm --examine /dev/hd[aceg]3

----------------------------------------------------------------------
cat /mount/etc/raidtab:
-----------------------

raiddev /dev/md0
         raid-level      5
         nr-raid-disks   4
         nr-spare-disks  0
         persistent-superblock 1
         parity-algorithm        left-symmetric
         chunk-size      32
         device          /dev/hda3
         raid-disk       0
         device          /dev/hdc3
         raid-disk       1
         device          /dev/hde3
         raid-disk       2
         device          /dev/hdg3
         raid-disk       3


----------------------------------------------------------------------
mdadm --examine /dev/hd[aceg]3:
-------------------------------
/dev/hda3:
           Magic : a92b4efc
         Version : 00.90.00
            UUID : 02d9c6f2:53c8584d:8815ae94:e4af8e1c
   Creation Time : Fri May 30 14:25:47 2003
      Raid Level : raid5
    Raid Devices : 4
   Total Devices : 3
Preferred Minor : 0

     Update Time : Sat Dec  3 18:56:59 2005
           State : clean
  Active Devices : 3
Working Devices : 3
  Failed Devices : 1
   Spare Devices : 0
        Checksum : f620ca21 - correct
          Events : 0.390

          Layout : left-symmetric
      Chunk Size : 32K

       Number   Major   Minor   RaidDevice State
this     0       3        3        0      active sync

    0     0       3        3        0      active sync
    1     1       0        0        1      faulty removed
    2     2      33        3        2      active sync
    3     3      34        3        3      active sync
/dev/hdc3:
           Magic : a92b4efc
         Version : 00.90.00
            UUID : 02d9c6f2:53c8584d:8815ae94:e4af8e1c
   Creation Time : Fri May 30 14:25:47 2003
      Raid Level : raid5
    Raid Devices : 4
   Total Devices : 3
Preferred Minor : 0

     Update Time : Sun Dec  4 15:03:42 2005
           State : clean
  Active Devices : 3
Working Devices : 3
  Failed Devices : 0
   Spare Devices : 0
        Checksum : f621e626 - correct
          Events : 0.524

          Layout : left-symmetric
      Chunk Size : 32K

       Number   Major   Minor   RaidDevice State
this     1      22        3        1      active sync

    0     0       0        0        0      removed
    1     1      22        3        1      active sync
    2     2      33        3        2      active sync
    3     3      34        3        3      active sync
/dev/hde3:
           Magic : a92b4efc
         Version : 00.90.00
            UUID : 02d9c6f2:53c8584d:8815ae94:e4af8e1c
   Creation Time : Fri May 30 14:25:47 2003
      Raid Level : raid5
    Raid Devices : 4
   Total Devices : 3
Preferred Minor : 0

     Update Time : Sun Dec  4 15:03:42 2005
           State : clean
  Active Devices : 3
Working Devices : 3
  Failed Devices : 0
   Spare Devices : 0
        Checksum : f621e633 - correct
          Events : 0.524

          Layout : left-symmetric
      Chunk Size : 32K

       Number   Major   Minor   RaidDevice State
this     2      33        3        2      active sync

    0     0       0        0        0      removed
    1     1      22        3        1      active sync
    2     2      33        3        2      active sync
    3     3      34        3        3      active sync
/dev/hdg3:
           Magic : a92b4efc
         Version : 00.90.00
            UUID : 02d9c6f2:53c8584d:8815ae94:e4af8e1c
   Creation Time : Fri May 30 14:25:47 2003
      Raid Level : raid5
    Raid Devices : 4
   Total Devices : 3
Preferred Minor : 0

     Update Time : Sun Dec  4 15:03:42 2005
           State : clean
  Active Devices : 3
Working Devices : 3
  Failed Devices : 0
   Spare Devices : 0
        Checksum : f621e636 - correct
          Events : 0.524

          Layout : left-symmetric
      Chunk Size : 32K

       Number   Major   Minor   RaidDevice State
this     3      34        3        3      active sync

    0     0       0        0        0      removed
    1     1      22        3        1      active sync
    2     2      33        3        2      active sync
    3     3      34        3        3      active sync





