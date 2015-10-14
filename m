From: Phil Reynolds <phil@tinsleyviaduct.com>
Subject: Debian jessie - RAID 6 reshape - making no progress after >48 hours
Date: Wed, 14 Oct 2015 18:10:19 +0100
Message-ID: <20151014181019.6f7f9d0a@topdeck.tinsleyviaduct.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have recently tried to add 4 additional devices to a RAID 6 array,
with this command:

mdadm -G /dev/md1 -n 8 -a /dev/sdb2 /dev/sdf2 /dev/sdg2 /dev/sdh2

Output from the command, I do not have, but it is what I would take as
normal - it confirmed what I had asked with no error.

dmesg | grep -w md shows this:

[    2.339195] md: bind<sde2>
[    2.339957] md: bind<sdc1>
[    2.341128] md: bind<sdd2>
[    2.342079] md: bind<sdc3>
[    2.342735] md: bind<sdd3>
[    2.343667] md: bind<sdc2>
[    2.344923] md: bind<sdd1>
[    2.345939] md: bind<sde1>
[    2.347212] md: bind<sde3>
[    3.413622] md: bind<sda2>
[    3.660395] md: raid6 personality registered for level 6
[    3.660396] md: raid5 personality registered for level 5
[    3.660397] md: raid4 personality registered for level 4
[    3.660548] md/raid:md1: device sda2 operational as raid disk 0
[    3.660550] md/raid:md1: device sdc2 operational as raid disk 1
[    3.660551] md/raid:md1: device sdd2 operational as raid disk 2
[    3.660552] md/raid:md1: device sde2 operational as raid disk 3
[    3.660844] md/raid:md1: allocated 0kB
[    3.660862] md/raid:md1: raid level 6 active with 4 out of 4
devices, algorithm 2 [    3.731726] md: bind<sda3>
[    3.733039] md: raid0 personality registered for level 0
[    3.733168] md/raid0:md2: md_size is 234129408 sectors.
[    3.733170] md: RAID0 configuration for md2 - 1 zone
[    3.733171] md: zone0=[sda3/sdd3/sde3]
[    3.739588] md: bind<sda1>
[    3.759253] md: raid1 personality registered for level 1
[    3.759429] md/raid1:md0: active with 4 out of 4 mirrors
[    3.918565] md: array md3 already has disks!
[    3.918697] md: bind<md2>
[    3.919332] md: linear personality registered for level -1
[ 2733.499792] md: bind<sdb1>
[ 2735.135587] md: bind<sdf1>
[ 2735.256588] md: bind<sdg1>
[ 2735.402403] md: could not open unknown-block(8,81).
[ 2735.402412] md: md_import_device returned -16
[ 2735.402428] md: could not open unknown-block(8,81).
[ 2735.402432] md: md_import_device returned -16
[ 2735.447468] md: bind<sdh1>
[ 2735.741173] md: recovery of RAID array md0
[ 2735.741174] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[ 2735.741175] md: using maximum available idle IO bandwidth (but not
more than 200000 KB/sec) for recovery.
[ 2735.741183] md: using 128k
window, over a total of 96256k.
[ 2745.098791] md: md0: recovery done.
[ 2779.774452] md: bind<sdb2>
[ 2779.887067] md: bind<sdf2>
[ 2780.051949] md: bind<sdg2>
[ 2780.162323] md: bind<sdh2>
[ 2780.559396] md: reshape of RAID array md1
[ 2780.559399] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[ 2780.559400] md: using maximum available idle IO bandwidth (but not
more than 200000 KB/sec) for reshape.
[ 2780.559408] md: using 128k window, over a total of 205077632k.

(note: I have already tried adjusting the minimum speed)

/proc/mdstat is looking like this:

Personalities : [raid6] [raid5] [raid4] [raid0] [raid1] [linear]
md2 : active raid0 sda3[0] sde3[2] sdd3[1]
      117064704 blocks super 1.2 512k chunks

md3 : active linear md2[0] sdc3[1]
      400277156 blocks super 1.2 0k rounding

md0 : active raid1 sdh1[4] sdg1[5] sdf1[6] sdb1[7] sda1[0] sde1[3]
sdd1[1] sdc1[ 2]
      96256 blocks [8/8] [UUUUUUUU]
      bitmap: 0/12 pages [0KB], 4KB chunk

md1 : active raid6 sdh2[4] sdg2[5] sdf2[6] sdb2[7] sda2[0] sdc2[1]
sdd2[2] sde2[ 3]
      410155264 blocks super 0.91 level 6, 64k chunk, algorithm 2 [8/8]
[UUUUUUU U]
      [>....................]  reshape =  0.0% (0/205077632)
finish=39282834032. 1min speed=0K/sec
      bitmap: 10/196 pages [40KB], 512KB chunk

unused devices: <none>

mdadm --detail /dev/md1 gives:

/dev/md1:
        Version : 0.91
  Creation Time : Sat Oct  4 15:01:57 2008
     Raid Level : raid6
     Array Size : 410155264 (391.15 GiB 420.00 GB)
  Used Dev Size : 205077632 (195.58 GiB 210.00 GB)
   Raid Devices : 8
  Total Devices : 8
Preferred Minor : 1
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Wed Oct 14 18:09:32 2015
          State : clean, reshaping 
 Active Devices : 8
Working Devices : 8
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

 Reshape Status : 0% complete
  Delta Devices : 4, (4->8)

           UUID : 7b4ddd0f:d04e8dbf:93c13954:ca72c56a
         Events : 0.5558446

    Number   Major   Minor   RaidDevice State
       0       8        2        0      active sync   /dev/sda2
       1       8       34        1      active sync   /dev/sdc2
       2       8       50        2      active sync   /dev/sdd2
       3       8       66        3      active sync   /dev/sde2
       4       8      114        4      active sync   /dev/sdh2
       5       8       98        5      active sync   /dev/sdg2
       6       8       82        6      active sync   /dev/sdf2
       7       8       18        7      active sync   /dev/sdb2

What can I safely do to move this along?

-- 
Phil Reynolds
mail: phil@tinsleyviaduct.com
Web: http://phil.tinsleyviaduct.com/

