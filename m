From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Performance question, RAID5
Date: Sat, 29 Jan 2011 22:48:06 +0000
Message-ID: <AANLkTimXp-vGP8fb2Y-2EiaGxj+H6UJ9DfjtYMVDhDri@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

I'm wondering if the performance I'm getting is OK or if there's
something I can do about it. Also, where the potential bottlenecks
are.

Setup: 6x2TB HDDs, their performance:

/dev/sdb:
 Timing cached reads:   1322 MB in  2.00 seconds = 661.51 MB/sec
 Timing buffered disk reads: 362 MB in  3.02 seconds = 120.06 MB/sec

/dev/sdc:
 Timing cached reads:   1282 MB in  2.00 seconds = 641.20 MB/sec
 Timing buffered disk reads: 342 MB in  3.01 seconds = 113.53 MB/sec

/dev/sdd:
 Timing cached reads:   1282 MB in  2.00 seconds = 640.55 MB/sec
 Timing buffered disk reads: 344 MB in  3.00 seconds = 114.58 MB/sec

/dev/sde:
 Timing cached reads:   1328 MB in  2.00 seconds = 664.46 MB/sec
 Timing buffered disk reads: 350 MB in  3.01 seconds = 116.37 MB/sec

/dev/sdf:
 Timing cached reads:   1304 MB in  2.00 seconds = 651.55 MB/sec
 Timing buffered disk reads: 378 MB in  3.01 seconds = 125.62 MB/sec

/dev/sdg:
 Timing cached reads:   1324 MB in  2.00 seconds = 661.91 MB/sec
 Timing buffered disk reads: 400 MB in  3.00 seconds = 133.15 MB/sec

These are used in a RAID5 setup:

Personalities : [raid6] [raid5] [raid4]
md0 : active raid5 sdf1[0] sdg1[6] sde1[5] sdc1[3] sdd1[4] sdb1[1]
      9751756800 blocks super 1.2 level 5, 64k chunk, algorithm 2 [6/6] [UUUUUU]

unused devices: <none>

/dev/md0:
        Version : 1.2
  Creation Time : Tue Oct 19 08:58:41 2010
     Raid Level : raid5
     Array Size : 9751756800 (9300.00 GiB 9985.80 GB)
  Used Dev Size : 1950351360 (1860.00 GiB 1997.16 GB)
   Raid Devices : 6
  Total Devices : 6
    Persistence : Superblock is persistent

    Update Time : Fri Jan 28 14:55:48 2011
          State : clean
 Active Devices : 6
Working Devices : 6
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

           Name : ion:0  (local to host ion)
           UUID : e6595c64:b3ae90b3:f01133ac:3f402d20
         Events : 3035769

    Number   Major   Minor   RaidDevice State
       0       8       81        0      active sync   /dev/sdf1
       1       8       17        1      active sync   /dev/sdb1
       4       8       49        2      active sync   /dev/sdd1
       3       8       33        3      active sync   /dev/sdc1
       5       8       65        4      active sync   /dev/sde1
       6       8       97        5      active sync   /dev/sdg1

As you can see they are partitioned. They are all identical like this:

Disk /dev/sdb: 2000.4 GB, 2000398934016 bytes
81 heads, 63 sectors/track, 765633 cylinders, total 3907029168 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x0e5b3a7a

   Device Boot      Start         End      Blocks   Id  System
/dev/sdb1            2048  3907029167  1953513560   fd  Linux raid autodetect

On this I run LVM:

  --- Physical volume ---
  PV Name               /dev/md0
  VG Name               lvstorage
  PV Size               9.08 TiB / not usable 1.00 MiB
  Allocatable           yes (but full)
  PE Size               1.00 MiB
  Total PE              9523199
  Free PE               0
  Allocated PE          9523199
  PV UUID               YLEUKB-klxF-X3gF-6dG3-DL4R-xebv-6gKQc2

On top of the LVM I have:

  --- Volume group ---
  VG Name               lvstorage
  System ID
  Format                lvm2
  Metadata Areas        1
  Metadata Sequence No  6
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                1
  Open LV               1
  Max PV                0
  Cur PV                1
  Act PV                1
  VG Size               9.08 TiB
  PE Size               1.00 MiB
  Total PE              9523199
  Alloc PE / Size       9523199 / 9.08 TiB
  Free  PE / Size       0 / 0
  VG UUID               Xd0HTM-azdN-v9kJ-C7vD-COcU-Cnn8-6AJ6hI

And in turn:

  --- Logical volume ---
  LV Name                /dev/lvstorage/storage
  VG Name                lvstorage
  LV UUID                9wsJ0u-0QMs-lL5h-E2UA-7QJa-l46j-oWkSr3
  LV Write Access        read/write
  LV Status              available
  # open                 1
  LV Size                9.08 TiB
  Current LE             9523199
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     1280
  Block device           254:1

And on that (sorry) there's the ext4 partition:

/dev/mapper/lvstorage-storage on /raid5volume type ext4
(rw,noatime,barrier=1,nouser_xattr)

Here are the numbers:

/raid5volume $ time dd if=/dev/zero of=./bigfile.tmp bs=1M count=8192
8192+0 records in
8192+0 records out
8589934592 bytes (8.6 GB) copied, 94.0967 s, 91.3 MB/s

real	1m34.102s
user	0m0.107s
sys	0m54.693s

/raid5volume $ time dd if=./bigfile.tmp of=/dev/null bs=1M
8192+0 records in
8192+0 records out
8589934592 bytes (8.6 GB) copied, 37.8557 s, 227 MB/s

real	0m37.861s
user	0m0.053s
sys	0m23.608s

I saw that the process md0_raid5 spike sometimes on CPU usage. This is
an Atom @ 1.6GHz, is that what is limiting the results? Here's
bonnie++:

/raid5volume/temp $ time bonnie++ -d ./ -m ion
Writing with putc()...done
Writing intelligently...done
Rewriting...done
Reading with getc()...done
Reading intelligently...done
start 'em...done...done...done...
Create files in sequential order...done.
Stat files in sequential order...done.
Delete files in sequential order...done.
Create files in random order...done.
Stat files in random order...done.
Delete files in random order...done.
Version 1.03e       ------Sequential Output------ --Sequential Input- --Random-
                    -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
ion              7G 13726  98 148051  87 68020  41 14547  99 286647
61 404.1   2
                    ------Sequential Create------ --------Random Create--------
                    -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
              files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
                 16 20707  99 +++++ +++ 25870  99 21242  98 +++++ +++ 25630 100
ion,7G,13726,98,148051,87,68020,41,14547,99,286647,61,404.1,2,16,20707,99,+++++,+++,25870,99,21242,98,+++++,+++,25630,100

real	20m54.320s
user	16m10.447s
sys	2m45.543s


Thanks in advance,
// Mathias
