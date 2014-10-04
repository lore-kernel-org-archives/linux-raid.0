From: Dennis Grant <reccedg@gmail.com>
Subject: Extremely High mismatch_cnt on RAID1 system
Date: Sat, 4 Oct 2014 10:46:00 -0300
Message-ID: <CAOWcSW5+8ZkWAyXL7VTk9JO+yrozFJS8RwroKqtudkiKD-fvXA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello all.

I recently updated an Ubuntu 12.04 LTS system to a 14.04 LTS system.
This upgrade did not go particularly smoothly, and I've been dealing
with various types of weirdness ever since.

This system has 4 hard drives in it, comprising 3 RAID 1 arrays. One
pair of drives contains two arrays - one for / (md0), and one for
/home (md2). The other array is a pair of older drives (the original
array from when the machine was first built) which I have mounted as
/home/backups (md3)

Some investigation has me thinking that perhaps the arrays had gotten
out of sync, or perhaps there was even a failing drive. So I've been
checking and repairing arrays to see what happens.

All drives passed their long SMART tests with no issues.

Even after multiple checks, repairs, and rebuilds, the arrays on the
bigger drives (/ and /home) are showing insanely high mismatch_cnt
values. This has me concerned.

Here are the details:

$cat /proc/mdstat
Personalities : [raid1] [linear] [multipath] [raid0] [raid6] [raid5]
[raid4] [raid10]
md3 : active raid1 sdb4[3] sda4[2]
      660213568 blocks super 1.2 [2/2] [UU]

md0 : active raid1 sda2[2] sdb2[3]
      307068736 blocks super 1.2 [2/2] [UU]

md2 : active raid1 sdc1[0] sdd1[1]
      2930133824 blocks super 1.2 [2/2] [UU]

unused devices: <none>

$ sudo mdadm -D /dev/md0
/dev/md0:
        Version : 1.2
  Creation Time : Sun Jun  9 19:19:32 2013
     Raid Level : raid1
     Array Size : 307068736 (292.84 GiB 314.44 GB)
  Used Dev Size : 307068736 (292.84 GiB 314.44 GB)
   Raid Devices : 2
  Total Devices : 2
    Persistence : Superblock is persistent

    Update Time : Sat Oct  4 10:18:58 2014
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

           Name : karzai:0  (local to host karzai)
           UUID : ff878502:6d567c41:4dbd32f7:7a1122be
         Events : 256772

$ sudo mdadm -D /dev/md2
/dev/md2:
        Version : 1.2
  Creation Time : Sat Jun  8 04:09:23 2013
     Raid Level : raid1
     Array Size : 2930133824 (2794.39 GiB 3000.46 GB)
  Used Dev Size : 2930133824 (2794.39 GiB 3000.46 GB)
   Raid Devices : 2
  Total Devices : 2
    Persistence : Superblock is persistent

    Update Time : Sat Oct  4 10:19:33 2014
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

           Name : karzai:2  (local to host karzai)
           UUID : dd5af8bf:02a9500e:0b73f986:72a2ba43
         Events : 459

    Number   Major   Minor   RaidDevice State
       0       8       33        0      active sync   /dev/sdc1
       1       8       49        1      active sync   /dev/sdd1


    Number   Major   Minor   RaidDevice State
       3       8       18        0      active sync   /dev/sdb2
       2       8        2        1      active sync   /dev/sda2

$ sudo mdadm -D /dev/md3
/dev/md3:
        Version : 1.2
  Creation Time : Sun Jun  9 20:05:28 2013
     Raid Level : raid1
     Array Size : 660213568 (629.63 GiB 676.06 GB)
  Used Dev Size : 660213568 (629.63 GiB 676.06 GB)
   Raid Devices : 2
  Total Devices : 2
    Persistence : Superblock is persistent

    Update Time : Sat Oct  4 09:52:47 2014
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

           Name : karzai:3  (local to host karzai)
           UUID : e60332c8:e5568487:df2f3b61:94fd2b2c
         Events : 14971

    Number   Major   Minor   RaidDevice State
       3       8       20        0      active sync   /dev/sdb4
       2       8        4        1      active sync   /dev/sda4

$ grep . /sys/block/md?/md/mismatch_cnt
/sys/block/md0/md/mismatch_cnt:3148032
/sys/block/md2/md/mismatch_cnt:20217856
/sys/block/md3/md/mismatch_cnt:0

fsck of md2 and md3 were clean

Should I be concerned? The fact that the high counts on on arrays that
share the same physical drives has me very nervous, notwithstanding
the passed SMART tests.

Thank you.
