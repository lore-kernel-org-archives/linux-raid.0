From: =?UTF-8?Q?Lucian_=C8=98andor?= <lucisandor@gmail.com>
Subject: RAID5 reshape past 100%
Date: Sun, 23 Aug 2009 08:02:22 -0400
Message-ID: <c775b4470908230502o6fa41danf4281ed58f0e82a9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

I am growing a RAID5 to the sixth disk which used to be spare. When I
woke up this morning, I found reshape went over 100%.

Here are some details:

The newest drive is sde8. Prior to starting the grow operation, I
removed the internal bitmap (otherwise grow fails). After starting the
reshape I increased speed_limit_min to 500000 and speed_limit_max to
5000000.

battlecruiser:~ # cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4] [raid0] [raid1]
md2 : active raid5 sde8[6] sdc8[0] sdb8[5] sdf8[4] sda8[3] sdd8[1]
      3818585088 blocks super 1.0 level 5, 128k chunk, algorithm 0
[6/6] [UUUUUU]
      [=====================>]  reshape =106.5% (508767236/477323136)
finish=39803743.6min speed=7148K/sec
..... other RAIDs.....
unused devices: <none>


battlecruiser:~ # mdadm --detail /dev/md2
/dev/md2:
        Version : 1.00
  Creation Time : Tue Jul  7 23:37:30 2009
     Raid Level : raid5
     Array Size : 3818585088 (3641.69 GiB 3910.23 GB)
  Used Dev Size : 1909292544 (1820.84 GiB 1955.12 GB)
   Raid Devices : 6
  Total Devices : 6
    Persistence : Superblock is persistent
    Update Time : Sun Aug 23 07:49:05 2009
          State : clean
 Active Devices : 6
Working Devices : 6
 Failed Devices : 0
  Spare Devices : 0
         Layout : left-asymmetric
     Chunk Size : 128K
  Delta Devices : 1, (5->6)
           Name : linux:2
           UUID : ed7d15cd:1cad6a1c:3b3f4b49:ea68d0c6
         Events : 1574658
    Number   Major   Minor   RaidDevice State
       0       8       40        0      active sync   /dev/sdc8
       1       8       56        1      active sync   /dev/sdd8
       3       8        8        2      active sync   /dev/sda8
       4       8       88        3      active sync   /dev/sdf8
       5       8       24        4      active sync   /dev/sdb8
       6       8       72        5      active sync   /dev/sde8


battlecruiser:~ # mdadm --examine /dev/sda8
/dev/sda8:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x4
     Array UUID : ed7d15cd:1cad6a1c:3b3f4b49:ea68d0c6
           Name : linux:2
  Creation Time : Tue Jul  7 23:37:30 2009
     Raid Level : raid5
   Raid Devices : 6
 Avail Dev Size : 1909292784 (910.42 GiB 977.56 GB)
     Array Size : 9546462720 (4552.11 GiB 4887.79 GB)
  Used Dev Size : 1909292544 (910.42 GiB 977.56 GB)
   Super Offset : 1909293040 sectors
          State : clean
    Device UUID : b53ba38b:2c061f4a:3c3c7a8f:480eec39
  Reshape pos'n : 2557671680 (2439.19 GiB 2619.06 GB)
  Delta Devices : 1 (5->6)
    Update Time : Sun Aug 23 07:54:32 2009
       Checksum : d2e31480 - correct
         Events : 1576210
         Layout : left-asymmetric
     Chunk Size : 128K
    Array Slot : 3 (0, 1, failed, 2, 3, 4, 5)
   Array State : uuUuuu 1 failed

battlecruiser:~ # mdadm --examine /dev/sde8
/dev/sde8:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x4
     Array UUID : ed7d15cd:1cad6a1c:3b3f4b49:ea68d0c6
           Name : linux:2
  Creation Time : Tue Jul  7 23:37:30 2009
     Raid Level : raid5
   Raid Devices : 6
 Avail Dev Size : 1909292784 (910.42 GiB 977.56 GB)
     Array Size : 9546462720 (4552.11 GiB 4887.79 GB)
  Used Dev Size : 1909292544 (910.42 GiB 977.56 GB)
   Super Offset : 1909293040 sectors
          State : clean
    Device UUID : 0829adf4:f920807f:b99e30b9:43010401
  Reshape pos'n : 2559514880 (2440.94 GiB 2620.94 GB)
  Delta Devices : 1 (5->6)
    Update Time : Sun Aug 23 07:55:13 2009
       Checksum : 6254b335 - correct
         Events : 1576450
         Layout : left-asymmetric
     Chunk Size : 128K
    Array Slot : 6 (0, 1, failed, 2, 3, 4, 5)
   Array State : uuuuuU 1 failed

I am a bit confused, since according to examine commands, the grow
operation is ongoing. Also, some of these commands show the raid as
failed, some as clean.

What should I do next? I am tempted to restart reshaping, but then
maybe examine output is correct.

Thanks in advance,
Lucian
