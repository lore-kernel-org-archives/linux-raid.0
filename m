From: Daniel Reurich <daniel@centurion.net.nz>
Subject: When does the raid bitmap actually work.
Date: Sat, 30 Oct 2010 10:50:39 +1300
Message-ID: <1288389039.5147.35.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

I'm wondering why if I fail and remove a drive from an array and then
re-add it a couple of minutes later that this forces a full resync even
though there is a bitmap setup.  I was lead to believe that when using a
bitmap that it would only resync the areas of the array that have been
written too in the meantime.  Am I mistaken in how the bitmap works?  Or
is simply that I'm running either a too old kernel or version of mdadm?

The particular scenario I'm dealing with is having to drop members out
of the array to alter the partition table of each host disk one at a
time, and when I re-add the disks I'm having to wait for a full re-sync
taking 3 - 4 hours before doing the next members disk.  As a result of
the partitioning changes, the device name changes from /dev/sd(X)2
to /dev/sd(X)3 but the partition itself remains untouched and in the
same location on disk.

Details: Debian Lenny Server
Mdadm version: 2.6.7.2
Kernel version: 2.6.29-2-amd64

:~# cat /proc/mdstat
Personalities : [raid1] [raid6] [raid5] [raid4] 
md0 : active raid1 sdc2[4](S) sdg2[3] sdf2[2] sda1[0] sdb1[1]
      308200 blocks [4/4] [UUUU]
      
md1 : active raid5 sdc3[4] sdg3[2] sda2[0] sdb2[1]
      1463633664 blocks level 5, 256k chunk, algorithm 2 [4/3] [UUU_]
      [============>........]  recovery = 63.4% (309610996/487877888)
finish=154.6min speed=19215K/sec
      bitmap: 1/2 pages [4KB], 131072KB chunk
:~# mdadm -D /dev/md1
/dev/md1:
        Version : 00.90
  Creation Time : Tue May  5 19:23:30 2009
     Raid Level : raid5
     Array Size : 1463633664 (1395.83 GiB 1498.76 GB)
  Used Dev Size : 487877888 (465.28 GiB 499.59 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 1
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Sat Oct 30 10:40:32 2010
          State : active, degraded, recovering
 Active Devices : 3
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 1

         Layout : left-symmetric
     Chunk Size : 256K

 Rebuild Status : 65% complete

           UUID : 5e64e0da:a5a68f88:03de972c:1e3eb3c3
         Events : 0.24500

    Number   Major   Minor   RaidDevice State
       0       8        2        0      active sync   /dev/sda2
       1       8       18        1      active sync   /dev/sdb2
       2       8       99        2      active sync   /dev/sdg3
       4       8       35        3      spare rebuilding   /dev/sdc3

The Removed and re-added partition:

:~# mdadm -E /dev/sdc3
/dev/sdc3:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 5e64e0da:a5a68f88:03de972c:1e3eb3c3
  Creation Time : Tue May  5 19:23:30 2009
     Raid Level : raid5
  Used Dev Size : 487877888 (465.28 GiB 499.59 GB)
     Array Size : 1463633664 (1395.83 GiB 1498.76 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 1

    Update Time : Sat Oct 30 10:47:08 2010
          State : clean
Internal Bitmap : present
 Active Devices : 3
Working Devices : 4
 Failed Devices : 1
  Spare Devices : 1
       Checksum : 8338653d - correct
         Events : 24712

         Layout : left-symmetric
     Chunk Size : 256K

      Number   Major   Minor   RaidDevice State
this     4       8       35        4      spare   /dev/sdc3

   0     0       8        2        0      active sync   /dev/sda2
   1     1       8       18        1      active sync   /dev/sdb2
   2     2       8       99        2      active sync   /dev/sdg3
   3     3       0        0        3      faulty removed
   4     4       8       35        4      spare   /dev/sdc3




One of the remaining member partitions:

:~# mdadm -E /dev/sda2
/dev/sda2:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 5e64e0da:a5a68f88:03de972c:1e3eb3c3
  Creation Time : Tue May  5 19:23:30 2009
     Raid Level : raid5
  Used Dev Size : 487877888 (465.28 GiB 499.59 GB)
     Array Size : 1463633664 (1395.83 GiB 1498.76 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 1

    Update Time : Sat Oct 30 10:44:23 2010
          State : active
Internal Bitmap : present
 Active Devices : 3
Working Devices : 4
 Failed Devices : 1
  Spare Devices : 1
       Checksum : 83380399 - correct
         Events : 24629

         Layout : left-symmetric
     Chunk Size : 256K

      Number   Major   Minor   RaidDevice State
this     0       8        2        0      active sync   /dev/sda2

   0     0       8        2        0      active sync   /dev/sda2
   1     1       8       18        1      active sync   /dev/sdb2
   2     2       8       99        2      active sync   /dev/sdg3
   3     3       0        0        3      faulty removed
   4     4       8       35        4      spare   /dev/sdc3






