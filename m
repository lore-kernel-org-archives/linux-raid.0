From: Guillaume Paumier <guillaume.paumier@gmail.com>
Subject: Guidance on reshape stuck at 0% after --grow
Date: Mon, 21 Sep 2015 19:15:11 -0700
Message-ID: <CAKWBTuFk4Tz20B4aZHgPF3FoEYXDqwQeKeAwN3Nt-cSAopUQ0Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

First of all, my apologies if this is explained somewhere; I haven't
been able to find existing documentation about this exact situation.

Yesterday, I added a new (identical) disk to an existing, clean,
8-disk RAID6 array (with XFS), and attempted to grow the array:

# mdadm --add /dev/md0 /dev/sdb1
# mdadm --grow --raid-devices=9 /dev/md0

Over 24 hours later, the reshape is still in the same state as when it
started, i.e. at 0%. Looking at cat /proc/mdstat , no data seems to
have been moved, and the speed is shown as 0K/sec. The "finish"
estimate just keeps increasing. I don't see any process related to
mdadm in top. Unfortunately, I omitted the backup file in the --grow
command.

I'm looking for guidance regarding what to do next. I'm not sure
whether I should wait longer (how long?), or try to re-assemble the
seemingly-intact original array (how do I stop/restart the reshape
cleanly?), or something else. Any advice would be greatly appreciated.

Here's some additional information about the array after the --grow command:

______________________________________________
# mdadm -D /dev/md0
______________________________________________

/dev/md0:
        Version : 1.0
  Creation Time : Thu Aug  1 12:23:07 2013
     Raid Level : raid6
     Array Size : 23442098688 (22356.13 GiB 24004.71 GB)
  Used Dev Size : 3907016448 (3726.02 GiB 4000.78 GB)
   Raid Devices : 9
  Total Devices : 9
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Sun Sep 20 16:48:15 2015
          State : clean, reshaping
 Active Devices : 9
Working Devices : 9
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 128K

 Reshape Status : 0% complete
  Delta Devices : 1, (8->9)

           Name : (redacted):0
           UUID : eea59047:120a0365:353da182:6787e030
         Events : 35499

    Number   Major   Minor   RaidDevice State
       0       8       33        0      active sync   /dev/sdc1
       1       8       49        1      active sync   /dev/sdd1
       2       8       97        2      active sync   /dev/sdg1
       3       8      113        3      active sync   /dev/sdh1
       4       8      129        4      active sync   /dev/sdi1
       5       8      145        5      active sync   /dev/sdj1
       7       8       81        6      active sync   /dev/sdf1
       6       8       65        7      active sync   /dev/sde1
       8       8       17        8      active sync   /dev/sdb1




______________________________________________
cat /proc/mdstat
______________________________________________

Personalities : [raid6] [raid5] [raid4]
md0 : active raid6 sdb1[8] sdg1[2] sdj1[5] sdc1[0] sdf1[7] sde1[6]
sdh1[3] sdi1[4] sdd1[1]
      23442098688 blocks super 1.0 level 6, 128k chunk, algorithm 2
[9/9] [UUUUUUUUU]
      [>....................]  reshape =  0.0% (0/3907016448)
finish=377198019201.6min speed=0K/sec
      bitmap: 0/30 pages [0KB], 65536KB chunk

unused devices: <none>



______________________________________________

# dmesg | grep md
______________________________________________

<pre>
[    4.468239] md: bind<sdd1>
[    4.477539] md: bind<sdi1>
[    4.489898] md: bind<sdh1>
[    4.499959] md: bind<sde1>
[    4.507908] md: bind<sdf1>
[    4.534961] md: bind<sdc1>
[    4.544582] md: bind<sdj1>
[    4.550060] md: bind<sdg1>
[    4.642375] md: raid6 personality registered for level 6
[    4.642378] md: raid5 personality registered for level 5
[    4.642407] md: raid4 personality registered for level 4
[    4.644839] md/raid:md0: device sdg1 operational as raid disk 2
[    4.644843] md/raid:md0: device sdj1 operational as raid disk 5
[    4.644844] md/raid:md0: device sdc1 operational as raid disk 0
[    4.644845] md/raid:md0: device sdf1 operational as raid disk 6
[    4.644846] md/raid:md0: device sde1 operational as raid disk 7
[    4.644847] md/raid:md0: device sdh1 operational as raid disk 3
[    4.644848] md/raid:md0: device sdi1 operational as raid disk 4
[    4.644850] md/raid:md0: device sdd1 operational as raid disk 1
[    4.645566] md/raid:md0: allocated 0kB
[    4.646409] md/raid:md0: raid level 6 active with 8 out of 8
devices, algorithm 2
[    4.646575] created bitmap (30 pages) for device md0
[    4.647292] md0: bitmap initialized from disk: read 2 pages, set 0
of 59617 bits
[    4.699645] md0: detected capacity change from 0 to 24004709056512
[    4.700805]  md0: unknown partition table
[    4.909274] XFS (md0): Mounting V4 Filesystem
[    5.335425] XFS (md0): Ending clean mount
[ 1642.872936]  md0: unknown partition table
[ 1665.183589] md: bind<sdb1>
[ 1665.217944]  md0: unknown partition table
[ 1868.222033] md: reshape of RAID array md0
[ 1868.222037] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[ 1868.222038] md: using maximum available idle IO bandwidth (but not
more than 200000 KB/sec) for reshape.
[ 1868.222047] md: using 128k window, over a total of 3907016448k.
[ 1868.276409]  md0: unknown partition table
[ 2001.573583]  md0: unknown partition table



______________________________________________
# mdadm --version
______________________________________________
mdadm - v3.3.1 - 5th June 2014




-- 
Guillaume Paumier
