From: Maarten <maarten@ultratux.net>
Subject: Raid6 array crashed-- 4-disk failure...(?)
Date: Mon, 15 Sep 2008 11:04:12 +0200
Message-ID: <48CE250C.8000603@ultratux.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


This weekend I promoted my new 6-disk raid6 array to production use and 
was busy copying data to it overnight. The next morning the machine had 
crashed, and the array is down with an (apparent?) 4-disk failure, as 
witnessed by this info:

md5 : inactive sdj1[2](S) sdb1[5](S) sda1[4](S) sdf1[3](S) sdc1[1](S) 
sdk1[0](S)
       2925435648 blocks

apoc ~ # mdadm --assemble /dev/md5 /dev/sd[abcfjk]1
mdadm: /dev/md5 assembled from 2 drives - not enough to start the array.

apoc log # fdisk -l|grep 4875727
/dev/sda1        1       60700   487572718+  fd  Linux raid autodetect
/dev/sdb1        1       60700   487572718+  fd  Linux raid autodetect
/dev/sdc1        1       60700   487572718+  fd  Linux raid autodetect
/dev/sdf1        1       60700   487572718+  fd  Linux raid autodetect
/dev/sdj1        1       60700   487572718+  fd  Linux raid autodetect
/dev/sdk1        1       60700   487572718+  fd  Linux raid autodetect

apoc log # mdadm --examine /dev/sd[abcfjk]1|grep Events
          Events : 0.1057345
          Events : 0.1057343
          Events : 0.1057343
          Events : 0.1057343
          Events : 0.1057345
          Events : 0.1057343

Note: the array was built half-degraded, ie. it misses one disk. This is 
how it was displayed when it was still OK yesterday:

md5 : active raid6 sdk1[0] sdj1[2] sdf1[3] sdc1[1] sdb1[5] sda1[4]
       2437863040 blocks level 6, 64k chunk, algorithm 2 [7/6] [UUUUUU_]


By these event counters, one would maybe assume that 4 disks failed 
simultaneously, however weird this may be. But when looking at the other 
info of the examine command, this seems unlikely: all drives report (I 
think) that they were online until the end, except for two drives. The 
first drive of those two is the one that reports it has failed. The 
second is the one that 'sees' that that first drive did fail. All the 
others seem oblivious to that...  I included that data below at the end.

My questions...

1) Is my analysis correct so far ?
2) Can/should I try to assemble --force, or it that very bad in these 
circumstances?
3) Should I say farewell to my ~2400 GB of data ? :-(
4) If it was only a one-drive failure, why did it kill the array ?
5) Any insight as to how this happened / can be prevented in future ?

Thanks in advance !
Maarten



apoc log # mdadm --examine /dev/sd[abcfjk]1
/dev/sda1:
           Magic : a92b4efc
         Version : 00.90.00
            UUID : 999c61f3:c632ab84:b78500dd:1e5b1429
   Creation Time : Sun Jan 13 18:10:14 2008
      Raid Level : raid6
   Used Dev Size : 487572608 (464.99 GiB 499.27 GB)
      Array Size : 2437863040 (2324.93 GiB 2496.37 GB)
    Raid Devices : 7
   Total Devices : 6
Preferred Minor : 5

     Update Time : Mon Sep 15 05:17:07 2008
           State : active
  Active Devices : 5
Working Devices : 5
  Failed Devices : 1
   Spare Devices : 0
        Checksum : 8c5374ca - correct
          Events : 0.1057345

      Chunk Size : 64K

       Number   Major   Minor   RaidDevice State
this     4       8        1        4      active sync   /dev/sda1

    0     0       0        0        0      removed
    1     1       8       33        1      active sync   /dev/sdc1
    2     2       8      145        2      active sync   /dev/sdj1
    3     3       8       81        3      active sync   /dev/sdf1
    4     4       8        1        4      active sync   /dev/sda1
    5     5       8       17        5      active sync   /dev/sdb1
    6     6       0        0        6      faulty removed
/dev/sdb1:
           Magic : a92b4efc
         Version : 00.90.00
            UUID : 999c61f3:c632ab84:b78500dd:1e5b1429
   Creation Time : Sun Jan 13 18:10:14 2008
      Raid Level : raid6
   Used Dev Size : 487572608 (464.99 GiB 499.27 GB)
      Array Size : 2437863040 (2324.93 GiB 2496.37 GB)
    Raid Devices : 7
   Total Devices : 6
Preferred Minor : 5

     Update Time : Mon Sep 15 05:16:06 2008
           State : active
  Active Devices : 6
Working Devices : 6
  Failed Devices : 1
   Spare Devices : 0
        Checksum : 8c53748e - correct
          Events : 0.1057343

      Chunk Size : 64K

       Number   Major   Minor   RaidDevice State
this     5       8       17        5      active sync   /dev/sdb1

    0     0       8      161        0      active sync   /dev/sdk1
    1     1       8       33        1      active sync   /dev/sdc1
    2     2       8      145        2      active sync   /dev/sdj1
    3     3       8       81        3      active sync   /dev/sdf1
    4     4       8        1        4      active sync   /dev/sda1
    5     5       8       17        5      active sync   /dev/sdb1
    6     6       0        0        6      faulty removed
/dev/sdc1:
           Magic : a92b4efc
         Version : 00.90.00
            UUID : 999c61f3:c632ab84:b78500dd:1e5b1429
   Creation Time : Sun Jan 13 18:10:14 2008
      Raid Level : raid6
   Used Dev Size : 487572608 (464.99 GiB 499.27 GB)
      Array Size : 2437863040 (2324.93 GiB 2496.37 GB)
    Raid Devices : 7
   Total Devices : 6
Preferred Minor : 5

     Update Time : Mon Sep 15 05:16:06 2008
           State : active
  Active Devices : 6
Working Devices : 6
  Failed Devices : 1
   Spare Devices : 0
        Checksum : 8c537496 - correct
          Events : 0.1057343

      Chunk Size : 64K

       Number   Major   Minor   RaidDevice State
this     1       8       33        1      active sync   /dev/sdc1

    0     0       8      161        0      active sync   /dev/sdk1
    1     1       8       33        1      active sync   /dev/sdc1
    2     2       8      145        2      active sync   /dev/sdj1
    3     3       8       81        3      active sync   /dev/sdf1
    4     4       8        1        4      active sync   /dev/sda1
    5     5       8       17        5      active sync   /dev/sdb1
    6     6       0        0        6      faulty removed
/dev/sdf1:
           Magic : a92b4efc
         Version : 00.90.00
            UUID : 999c61f3:c632ab84:b78500dd:1e5b1429
   Creation Time : Sun Jan 13 18:10:14 2008
      Raid Level : raid6
   Used Dev Size : 487572608 (464.99 GiB 499.27 GB)
      Array Size : 2437863040 (2324.93 GiB 2496.37 GB)
    Raid Devices : 7
   Total Devices : 6
Preferred Minor : 5

     Update Time : Mon Sep 15 05:16:06 2008
           State : active
  Active Devices : 6
Working Devices : 6
  Failed Devices : 1
   Spare Devices : 0
        Checksum : 8c5374ca - correct
          Events : 0.1057343

      Chunk Size : 64K

       Number   Major   Minor   RaidDevice State
this     3       8       81        3      active sync   /dev/sdf1

    0     0       8      161        0      active sync   /dev/sdk1
    1     1       8       33        1      active sync   /dev/sdc1
    2     2       8      145        2      active sync   /dev/sdj1
    3     3       8       81        3      active sync   /dev/sdf1
    4     4       8        1        4      active sync   /dev/sda1
    5     5       8       17        5      active sync   /dev/sdb1
    6     6       0        0        6      faulty removed
/dev/sdj1:
           Magic : a92b4efc
         Version : 00.90.00
            UUID : 999c61f3:c632ab84:b78500dd:1e5b1429
   Creation Time : Sun Jan 13 18:10:14 2008
      Raid Level : raid6
   Used Dev Size : 487572608 (464.99 GiB 499.27 GB)
      Array Size : 2437863040 (2324.93 GiB 2496.37 GB)
    Raid Devices : 7
   Total Devices : 6
Preferred Minor : 5

     Update Time : Mon Sep 15 05:17:07 2008
           State : active
  Active Devices : 5
Working Devices : 5
  Failed Devices : 1
   Spare Devices : 0
        Checksum : 8c537556 - correct
          Events : 0.1057345

      Chunk Size : 64K

       Number   Major   Minor   RaidDevice State
this     2       8      145        2      active sync   /dev/sdj1

    0     0       0        0        0      removed
    1     1       8       33        1      active sync   /dev/sdc1
    2     2       8      145        2      active sync   /dev/sdj1
    3     3       8       81        3      active sync   /dev/sdf1
    4     4       8        1        4      active sync   /dev/sda1
    5     5       8       17        5      active sync   /dev/sdb1
    6     6       0        0        6      faulty removed
/dev/sdk1:
           Magic : a92b4efc
         Version : 00.90.00
            UUID : 999c61f3:c632ab84:b78500dd:1e5b1429
   Creation Time : Sun Jan 13 18:10:14 2008
      Raid Level : raid6
   Used Dev Size : 487572608 (464.99 GiB 499.27 GB)
      Array Size : 2437863040 (2324.93 GiB 2496.37 GB)
    Raid Devices : 7
   Total Devices : 6
Preferred Minor : 5

     Update Time : Mon Sep 15 05:16:06 2008
           State : active
  Active Devices : 6
Working Devices : 6
  Failed Devices : 1
   Spare Devices : 0
        Checksum : 8c537514 - correct
          Events : 0.1057343

      Chunk Size : 64K

       Number   Major   Minor   RaidDevice State
this     0       8      161        0      active sync   /dev/sdk1

    0     0       8      161        0      active sync   /dev/sdk1
    1     1       8       33        1      active sync   /dev/sdc1
    2     2       8      145        2      active sync   /dev/sdj1
    3     3       8       81        3      active sync   /dev/sdf1
    4     4       8        1        4      active sync   /dev/sda1
    5     5       8       17        5      active sync   /dev/sdb1
    6     6       0        0        6      faulty removed


