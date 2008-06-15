From: Karl Dubois <karl-2.dubois@polymtl.ca>
Subject: Weird corruptions read error.
Date: Sun, 15 Jun 2008 01:37:09 -0400
Message-ID: <1213508229.4854aa85e9f52@www.imp.polymtl.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hey everyone!

I'll make it quick. I've got two arrays, both composed of 4 disks. The first one
works fine and is composed of 4 disk (sda4, sdb1, sdd2, sdf2).

The second one is composed of four disk (sdc1, sdd1, sde1, sdf1) and gives some
weirds reading corruption.

portal ~ # uname -a
Linux portal 2.6.24 #1 SMP Sun Jun 15 10:15:40 EDT 2008 i686 Intel(R) Pentium(R)
Dual CPU E2140 @ 1.60GHz GenuineIntel GNU/Linux
portal ~ # mdadm -V
mdadm - v2.6.2 - 21st May 2007
portal ~ # cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md1 : active raid5 sdc1[3] sdf1[1] sde1[2] sdd1[0]
      937512768 blocks level 5, 64k chunk, algorithm 2 [4/4] [UUUU]

md0 : active raid5 sdf2[2] sdd2[1] sdb1[3] sda4[0]
      527638656 blocks level 5, 64k chunk, algorithm 2 [4/4] [UUUU]

unused devices: <none>
portal ~ #

/dev/md1:
        Version : 00.90.03
  Creation Time : Thu Jan  3 22:53:48 2008
     Raid Level : raid5
     Array Size : 937512768 (894.08 GiB 960.01 GB)
  Used Dev Size : 312504256 (298.03 GiB 320.00 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 1
    Persistence : Superblock is persistent

    Update Time : Sun Jun 15 21:19:53 2008
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

           UUID : 7747ce37:741a7fc6:7952671c:0738c2a8
         Events : 0.208954

    Number   Major   Minor   RaidDevice State
       0       8       49        0      active sync   /dev/sdd1
       1       8       81        1      active sync   /dev/sdf1
       2       8       65        2      active sync   /dev/sde1
       3       8       33        3      active sync   /dev/sdc1
portal ~ #

With the filesystem unmounted, if I read 3 time the same data with DD, I'll get
checksums:

portal / # dd if=/dev/md1 bs=1M count=100 | md5sum
100+0 records in
100+0 records out
104857600 bytes (105 MB) copied, 1.17863 s, 89.0 MB/s
7b4b257cf6909cc7ab93273fbd128cdd  -
portal / # echo 3 > /proc/sys/vm/drop_caches
portal / # dd if=/dev/md1 bs=1M count=100 | md5sum
100+0 records in
100+0 records out
06c1c32669d6651c78898a850a25b9ec  -
104857600 bytes (105 MB) copied, 1.21428 s, 86.4 MB/s
portal / # echo 3 > /proc/sys/vm/drop_caches
portal / # dd if=/dev/md1 bs=1M count=100 | md5sum
100+0 records in
100+0 records out
104857600 bytes (105 MB) copied, 1.18 s, 88.9 MB/s
992ca94d0950c9278b65c21d5de3fd07  -

If I check/compare the data read:
portal / # echo 3 > /proc/sys/vm/drop_caches
portal / # dd if=/dev/md1 bs=1M count=50 | hexdump -C >> /root/out1
...
...
portal / # echo 3 > /proc/sys/vm/drop_caches
portal / # dd if=/dev/md1 bs=1M count=50 | hexdump -C >> /root/out5
portal ~ # ls -al out*
-rw-r--r-- 1 root root 258290340 Jun 15 21:28 out1
-rw-r--r-- 1 root root 258290340 Jun 15 21:30 out2
-rw-r--r-- 1 root root 258290340 Jun 15 21:30 out3
-rw-r--r-- 1 root root 258290340 Jun 15 21:31 out4
-rw-r--r-- 1 root root 258290340 Jun 15 21:32 out5

portal ~ # diff out1 out2
259382c259382
< 0040fff0  60 31 c3 6c 0b 40 fa 29  75 7f 31 fd c2 de a8 fd  |`1.l.@.)u.1.....|
---
> 0040fff0  60 31 c3 6c 0b 40 fa 29  75 7f 31 fd 29 b1 04 79  |`1.l.@.)u.1.)..y|
1787125c1787125
< 01b5fff0  74 e3 ab 1d 61 df b7 6d  81 c0 f0 1b da bd 42 00  |t...a..m......B.|
---
> 01b5fff0  74 e3 ab 1d 61 df b7 6d  81 c0 f0 1b ae ff 9d 89  |t...a..m........|
2569450c2569450
< 0274fff0  d6 50 17 21 c2 f7 34 d5  ac a7 20 98 20 31 34 20  |.P.!..4... . 14 |
---
> 0274fff0  d6 50 17 21 c2 f7 34 d5  ac a7 20 98 3a c9 a8 28  |.P.!..4... .:..(|
2966739c2966739
< 02d5fff0  4b e9 f7 77 75 94 d0 c4  3e fd 47 58 20 54 2e 53  |K..wu...>.GX T.S|
---
> 02d5fff0  4b e9 f7 77 75 94 d0 c4  3e fd 47 58 11 aa 45 7a  |K..wu...>.GX..Ez|
portal ~ # diff out1 out3
259382c259382
< 0040fff0  60 31 c3 6c 0b 40 fa 29  75 7f 31 fd c2 de a8 fd  |`1.l.@.)u.1.....|
---
> 0040fff0  60 31 c3 6c 0b 40 fa 29  75 7f 31 fd 29 b1 04 79  |`1.l.@.)u.1.)..y|
1787125c1787125
< 01b5fff0  74 e3 ab 1d 61 df b7 6d  81 c0 f0 1b da bd 42 00  |t...a..m......B.|
---
> 01b5fff0  74 e3 ab 1d 61 df b7 6d  81 c0 f0 1b ae ff 9d 89  |t...a..m........|
1852660c1852660
< 01c5fff0  40 30 b0 b0 47 d9 a4 91  98 aa 08 38 44 02 0b 01  |@0..G......8D...|
---
> 01c5fff0  40 30 b0 b0 47 d9 a4 91  98 aa 08 38 38 03 04 a1  |@0..G......88...|
2569450c2569450
< 0274fff0  d6 50 17 21 c2 f7 34 d5  ac a7 20 98 20 31 34 20  |.P.!..4... . 14 |
---
> 0274fff0  d6 50 17 21 c2 f7 34 d5  ac a7 20 98 3a c9 a8 28  |.P.!..4... .:..(|
2966739c2966739
< 02d5fff0  4b e9 f7 77 75 94 d0 c4  3e fd 47 58 20 54 2e 53  |K..wu...>.GX T.S|
---
> 02d5fff0  4b e9 f7 77 75 94 d0 c4  3e fd 47 58 11 aa 45 7a  |K..wu...>.GX..Ez|
portal ~ # diff out1 out4
259382c259382
< 0040fff0  60 31 c3 6c 0b 40 fa 29  75 7f 31 fd c2 de a8 fd  |`1.l.@.)u.1.....|
---
> 0040fff0  60 31 c3 6c 0b 40 fa 29  75 7f 31 fd 29 b1 04 79  |`1.l.@.)u.1.)..y|
607541c607541
< 0095fff0  25 3f 14 eb f0 f1 9e de  d4 33 d0 44 fe 43 92 ab  |%?.......3.D.C..|
---
> 0095fff0  25 3f 14 eb f0 f1 9e de  d4 33 d0 44 d8 5c a2 d5  |%?.......3.D.\..|
1049909c1049909
< 0101fff0  66 61 d1 26 17 65 b6 bf  4d a7 89 2a bf fc ba f1  |fa.&.e..M..*....|
---
> 0101fff0  66 61 d1 26 17 65 b6 bf  4d a7 89 2a 38 09 83 b0  |fa.&.e..M..*8...|
1787125c1787125
< 01b5fff0  74 e3 ab 1d 61 df b7 6d  81 c0 f0 1b da bd 42 00  |t...a..m......B.|
---
> 01b5fff0  74 e3 ab 1d 61 df b7 6d  81 c0 f0 1b ae ff 9d 89  |t...a..m........|
2569450c2569450
< 0274fff0  d6 50 17 21 c2 f7 34 d5  ac a7 20 98 20 31 34 20  |.P.!..4... . 14 |
---
> 0274fff0  d6 50 17 21 c2 f7 34 d5  ac a7 20 98 3a c9 a8 28  |.P.!..4... .:..(|
2966739c2966739
< 02d5fff0  4b e9 f7 77 75 94 d0 c4  3e fd 47 58 20 54 2e 53  |K..wu...>.GX T.S|
---
> 02d5fff0  4b e9 f7 77 75 94 d0 c4  3e fd 47 58 11 aa 45 7a  |K..wu...>.GX..Ez|
3212495c3212495
< 0311fff0  52 d0 61 96 46 b0 5f f7  a9 d3 a5 08 53 8c 0a 6b  |R.a.F._.....S..k|
---
> 0311fff0  52 d0 61 96 46 b0 5f f7  a9 d3 a5 08 8f bd 3d 92  |R.a.F._.......=.|
portal ~ # diff out1 out5
259382c259382
< 0040fff0  60 31 c3 6c 0b 40 fa 29  75 7f 31 fd c2 de a8 fd  |`1.l.@.)u.1.....|
---
> 0040fff0  60 31 c3 6c 0b 40 fa 29  75 7f 31 fd 29 b1 04 79  |`1.l.@.)u.1.)..y|
1787125c1787125
< 01b5fff0  74 e3 ab 1d 61 df b7 6d  81 c0 f0 1b da bd 42 00  |t...a..m......B.|
---
> 01b5fff0  74 e3 ab 1d 61 df b7 6d  81 c0 f0 1b ae ff 9d 89  |t...a..m........|
2569450c2569450
< 0274fff0  d6 50 17 21 c2 f7 34 d5  ac a7 20 98 20 31 34 20  |.P.!..4... . 14 |
---
> 0274fff0  d6 50 17 21 c2 f7 34 d5  ac a7 20 98 3a c9 a8 28  |.P.!..4... .:..(|
2966739c2966739
< 02d5fff0  4b e9 f7 77 75 94 d0 c4  3e fd 47 58 20 54 2e 53  |K..wu...>.GX T.S|
---
> 02d5fff0  4b e9 f7 77 75 94 d0 c4  3e fd 47 58 11 aa 45 7a  |K..wu...>.GX..Ez|

I've also proceeded to do the same test on every hard drive of md1 
independently and they all reported sane results, no difference in 5
consecutive read of 50GB. If the data is read from memory (cache), there's no
problem occurring. The ram has been tested with memtest86. Each drive where
tested with smartctl and reported no errors. The array md0 work perfectly. If I
mount the array, the filesystem give the same behavior. Two checksum on the same
file will report two different thing.

Any of you have any ideas?

