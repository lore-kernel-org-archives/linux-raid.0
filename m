From: Anssi Hannula <anssi.hannula@iki.fi>
Subject: raid6 rebuild not starting
Date: Sun, 11 Dec 2011 09:03:14 +0200
Message-ID: <4EE455B2.2040105@iki.fi>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080803080003060706080208"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------080803080003060706080208
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi!

After I rebooted during a raid6 rebuild, the rebuild didn't start again.
Instead, there is a flood of "RAID conf printout"s that seemingly happen
on array activity.

All the devices show up properly in --detail and two devices are marked
as "spare rebuilding", and I can access the contents of the array just
fine, but the rebuild doesn't actually start. Is this a bug or am I
missing something? :)

I was initially on 2.6.38.8, but also tried 3.1.4 which seems to have
the same issue. mdadm is 3.1.5.

I'm not using start_ro and writing to the array doesn't trigger a
rebuild either.

Attached are --examine outputs before assembly, kernel log output on
assembly, /proc/mdstat and --detail after assembly (on 3.1.4).

-- 
Anssi Hannula

--------------080803080003060706080208
Content-Type: text/plain;
 name="detail-md0.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="detail-md0.txt"

/dev/md0:
        Version : 1.2
  Creation Time : Fri Sep  3 21:45:45 2010
     Raid Level : raid6
     Array Size : 15628095488 (14904.11 GiB 16003.17 GB)
  Used Dev Size : 1953511936 (1863.01 GiB 2000.40 GB)
   Raid Devices : 10
  Total Devices : 13
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Sun Dec 11 08:12:18 2011
          State : active, degraded
 Active Devices : 8
Working Devices : 13
 Failed Devices : 0
  Spare Devices : 5

         Layout : left-symmetric
     Chunk Size : 512K

           Name : delta.onse.fi:delta  (local to host delta.onse.fi)
           UUID : 35794893:8cbfdd41:36a60e33:2a6169dd
         Events : 293646

    Number   Major   Minor   RaidDevice State
       5       8      225        0      active sync   /dev/sdo1
       2      65        1        1      active sync   /dev/sdq1
      11       8      161        2      active sync   /dev/sdk1
      17       8      113        3      spare rebuilding   /dev/sdh1
      10       8      145        4      active sync   /dev/sdj1
       9       8      177        5      active sync   /dev/sdl1
       8       8      241        6      active sync   /dev/sdp1
      18       8       81        7      spare rebuilding   /dev/sdf1
      12       8      193        8      active sync   /dev/sdm1
      13       8      209        9      active sync   /dev/sdn1

      14       8       97        -      spare   /dev/sdg1
      15       8       65        -      spare   /dev/sde1
      16       8      129        -      spare   /dev/sdi1

--------------080803080003060706080208
Content-Type: text/plain;
 name="dmesg-assembled.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg-assembled.txt"

[  763.062742] md: md0 stopped.
[  763.070923] md: bind<sdq1>
[  763.072029] md: bind<sdk1>
[  763.072567] md: bind<sdh1>
[  763.073404] md: bind<sdj1>
[  763.074199] md: bind<sdl1>
[  763.074752] md: bind<sdp1>
[  763.075234] md: bind<sdf1>
[  763.076543] md: bind<sdm1>
[  763.077348] md: bind<sdn1>
[  763.078020] md: bind<sdi1>
[  763.078356] md: bind<sdg1>
[  763.079611] md: bind<sde1>
[  763.080159] md: bind<sdo1>
[  763.082687] md/raid:md0: device sdo1 operational as raid disk 0
[  763.082765] md/raid:md0: device sdn1 operational as raid disk 9
[  763.082840] md/raid:md0: device sdm1 operational as raid disk 8
[  763.082914] md/raid:md0: device sdp1 operational as raid disk 6
[  763.082988] md/raid:md0: device sdl1 operational as raid disk 5
[  763.083063] md/raid:md0: device sdj1 operational as raid disk 4
[  763.083137] md/raid:md0: device sdk1 operational as raid disk 2
[  763.083211] md/raid:md0: device sdq1 operational as raid disk 1
[  763.084250] md/raid:md0: allocated 10592kB
[  763.084522] md/raid:md0: raid level 6 active with 8 out of 10 devices, algorithm 2
[  763.084617] RAID conf printout:
[  763.084685]  --- level:6 rd:10 wd:8
[  763.087189]  disk 0, o:1, dev:sdo1
[  763.087259]  disk 1, o:1, dev:sdq1
[  763.087328]  disk 2, o:1, dev:sdk1
[  763.087397]  disk 3, o:1, dev:sdh1
[  763.087465]  disk 4, o:1, dev:sdj1
[  763.087534]  disk 5, o:1, dev:sdl1
[  763.087603]  disk 6, o:1, dev:sdp1
[  763.087672]  disk 7, o:1, dev:sdf1
[  763.087741]  disk 8, o:1, dev:sdm1
[  763.087810]  disk 9, o:1, dev:sdn1
[  763.088062] created bitmap (15 pages) for device md0
[  763.508492] md0: bitmap initialized from disk: read 1/1 pages, set 254 of 29809 bits
[  763.953649] md0: detected capacity change from 0 to 16003169779712
[  763.953810] RAID conf printout:
[  763.953813]  --- level:6 rd:10 wd:8
[  763.953816]  disk 0, o:1, dev:sdo1
[  763.953818]  disk 1, o:1, dev:sdq1
[  763.953820]  disk 2, o:1, dev:sdk1
[  763.953822]  disk 3, o:1, dev:sdh1
[  763.953824]  disk 4, o:1, dev:sdj1
[  763.953826]  disk 5, o:1, dev:sdl1
[  763.953828]  disk 6, o:1, dev:sdp1
[  763.953830]  disk 7, o:1, dev:sdf1
[  763.953832]  disk 8, o:1, dev:sdm1
[  763.953834]  disk 9, o:1, dev:sdn1
[  763.953835] RAID conf printout:
[  763.953837]  --- level:6 rd:10 wd:8
[  763.953838]  disk 0, o:1, dev:sdo1
[  763.953840]  disk 1, o:1, dev:sdq1
[  763.953843]  disk 2, o:1, dev:sdk1
[  763.953844]  disk 3, o:1, dev:sdh1
[  763.953846]  disk 4, o:1, dev:sdj1
[  763.953848]  disk 5, o:1, dev:sdl1
[  763.953849]  disk 6, o:1, dev:sdp1
[  763.953851]  disk 7, o:1, dev:sdf1
[  763.953853]  disk 8, o:1, dev:sdm1
[  763.953854]  disk 9, o:1, dev:sdn1
[  763.953856] RAID conf printout:
[  763.953857]  --- level:6 rd:10 wd:8
[  763.953859]  disk 0, o:1, dev:sdo1
[  763.953861]  disk 1, o:1, dev:sdq1
[  763.953862]  disk 2, o:1, dev:sdk1
[  763.953864]  disk 3, o:1, dev:sdh1
[  763.953866]  disk 4, o:1, dev:sdj1
[  763.953867]  disk 5, o:1, dev:sdl1
[  763.953869]  disk 6, o:1, dev:sdp1
[  763.953871]  disk 7, o:1, dev:sdf1
[  763.953872]  disk 8, o:1, dev:sdm1
[  763.953874]  disk 9, o:1, dev:sdn1
[  763.953875] RAID conf printout:
[  763.953876]  --- level:6 rd:10 wd:8
[  763.953878]  disk 0, o:1, dev:sdo1
[  763.953880]  disk 1, o:1, dev:sdq1
[  763.953882]  disk 2, o:1, dev:sdk1
[  763.953883]  disk 3, o:1, dev:sdh1
[  763.953885]  disk 4, o:1, dev:sdj1
[  763.953887]  disk 5, o:1, dev:sdl1
[  763.953888]  disk 6, o:1, dev:sdp1
[  763.953890]  disk 7, o:1, dev:sdf1
[  763.953892]  disk 8, o:1, dev:sdm1
[  763.953893]  disk 9, o:1, dev:sdn1
[  763.953895] RAID conf printout:
[  763.953896]  --- level:6 rd:10 wd:8
[  763.953898]  disk 0, o:1, dev:sdo1
[  763.953900]  disk 1, o:1, dev:sdq1
[  763.953901]  disk 2, o:1, dev:sdk1
[  763.953903]  disk 3, o:1, dev:sdh1
[  763.953905]  disk 4, o:1, dev:sdj1
[  763.953906]  disk 5, o:1, dev:sdl1
[  763.953908]  disk 6, o:1, dev:sdp1
[  763.953910]  disk 7, o:1, dev:sdf1
[  763.953911]  disk 8, o:1, dev:sdm1
[  763.953913]  disk 9, o:1, dev:sdn1

--------------080803080003060706080208
Content-Type: text/plain;
 name="examine-sdf1.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="examine-sdf1.txt"

/dev/sdf1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x3
     Array UUID : 35794893:8cbfdd41:36a60e33:2a6169dd
           Name : delta.onse.fi:delta  (local to host delta.onse.fi)
  Creation Time : Fri Sep  3 21:45:45 2010
     Raid Level : raid6
   Raid Devices : 10

 Avail Dev Size : 3907025072 (1863.01 GiB 2000.40 GB)
     Array Size : 31256190976 (14904.11 GiB 16003.17 GB)
  Used Dev Size : 3907023872 (1863.01 GiB 2000.40 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
Recovery Offset : 289089800 sectors
          State : clean
    Device UUID : 775affd2:7cedaf16:d29518a2:9ebda6ab

Internal Bitmap : 2 sectors from superblock
    Update Time : Sun Dec 11 08:12:18 2011
       Checksum : 397ee09a - correct
         Events : 293646

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 7
   Array State : AAAAAAAAAA ('A' == active, '.' == missing)

--------------080803080003060706080208
Content-Type: text/plain;
 name="examine-sdh1.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="examine-sdh1.txt"

/dev/sdh1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x3
     Array UUID : 35794893:8cbfdd41:36a60e33:2a6169dd
           Name : delta.onse.fi:delta  (local to host delta.onse.fi)
  Creation Time : Fri Sep  3 21:45:45 2010
     Raid Level : raid6
   Raid Devices : 10

 Avail Dev Size : 3907025072 (1863.01 GiB 2000.40 GB)
     Array Size : 31256190976 (14904.11 GiB 16003.17 GB)
  Used Dev Size : 3907023872 (1863.01 GiB 2000.40 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
Recovery Offset : 289089800 sectors
          State : clean
    Device UUID : 01c10562:b17a29e4:f554a3bd:bf9ad501

Internal Bitmap : 2 sectors from superblock
    Update Time : Sun Dec 11 08:12:18 2011
       Checksum : 7b8709c - correct
         Events : 293646

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 3
   Array State : AAAAAAAAAA ('A' == active, '.' == missing)

--------------080803080003060706080208
Content-Type: text/plain;
 name="examine-sdj1.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="examine-sdj1.txt"

/dev/sdj1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 35794893:8cbfdd41:36a60e33:2a6169dd
           Name : delta.onse.fi:delta  (local to host delta.onse.fi)
  Creation Time : Fri Sep  3 21:45:45 2010
     Raid Level : raid6
   Raid Devices : 10

 Avail Dev Size : 3907025072 (1863.01 GiB 2000.40 GB)
     Array Size : 31256190976 (14904.11 GiB 16003.17 GB)
  Used Dev Size : 3907023872 (1863.01 GiB 2000.40 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 46cf1470:7fba6892:5646483b:687df054

Internal Bitmap : 2 sectors from superblock
    Update Time : Sun Dec 11 08:12:18 2011
       Checksum : 838b69a7 - correct
         Events : 293646

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 4
   Array State : AAAAAAAAAA ('A' == active, '.' == missing)

--------------080803080003060706080208
Content-Type: text/plain;
 name="examine-sdk1.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="examine-sdk1.txt"

/dev/sdk1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 35794893:8cbfdd41:36a60e33:2a6169dd
           Name : delta.onse.fi:delta  (local to host delta.onse.fi)
  Creation Time : Fri Sep  3 21:45:45 2010
     Raid Level : raid6
   Raid Devices : 10

 Avail Dev Size : 3907025072 (1863.01 GiB 2000.40 GB)
     Array Size : 31256190976 (14904.11 GiB 16003.17 GB)
  Used Dev Size : 3907023872 (1863.01 GiB 2000.40 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 8f58934b:e8c3b310:77280e93:c6dd7f1e

Internal Bitmap : 2 sectors from superblock
    Update Time : Sun Dec 11 08:12:18 2011
       Checksum : feaa3ed8 - correct
         Events : 293646

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 2
   Array State : AAAAAAAAAA ('A' == active, '.' == missing)

--------------080803080003060706080208
Content-Type: text/plain;
 name="examine-sdl1.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="examine-sdl1.txt"

/dev/sdl1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 35794893:8cbfdd41:36a60e33:2a6169dd
           Name : delta.onse.fi:delta  (local to host delta.onse.fi)
  Creation Time : Fri Sep  3 21:45:45 2010
     Raid Level : raid6
   Raid Devices : 10

 Avail Dev Size : 3907025072 (1863.01 GiB 2000.40 GB)
     Array Size : 31256190976 (14904.11 GiB 16003.17 GB)
  Used Dev Size : 3907023872 (1863.01 GiB 2000.40 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 7c742911:a4aa0b69:75767d03:d78f19aa

Internal Bitmap : 2 sectors from superblock
    Update Time : Sun Dec 11 08:12:18 2011
       Checksum : 18a1418f - correct
         Events : 293646

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 5
   Array State : AAAAAAAAAA ('A' == active, '.' == missing)

--------------080803080003060706080208
Content-Type: text/plain;
 name="examine-sdm1.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="examine-sdm1.txt"

/dev/sdm1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 35794893:8cbfdd41:36a60e33:2a6169dd
           Name : delta.onse.fi:delta  (local to host delta.onse.fi)
  Creation Time : Fri Sep  3 21:45:45 2010
     Raid Level : raid6
   Raid Devices : 10

 Avail Dev Size : 3907025072 (1863.01 GiB 2000.40 GB)
     Array Size : 31256190976 (14904.11 GiB 16003.17 GB)
  Used Dev Size : 3907023872 (1863.01 GiB 2000.40 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 5da5f2c1:27900682:eed98123:d1dd7683

Internal Bitmap : 2 sectors from superblock
    Update Time : Sun Dec 11 08:12:18 2011
       Checksum : dbc70969 - correct
         Events : 293646

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 8
   Array State : AAAAAAAAAA ('A' == active, '.' == missing)

--------------080803080003060706080208
Content-Type: text/plain;
 name="examine-sdn1.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="examine-sdn1.txt"

/dev/sdn1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 35794893:8cbfdd41:36a60e33:2a6169dd
           Name : delta.onse.fi:delta  (local to host delta.onse.fi)
  Creation Time : Fri Sep  3 21:45:45 2010
     Raid Level : raid6
   Raid Devices : 10

 Avail Dev Size : 3907025072 (1863.01 GiB 2000.40 GB)
     Array Size : 31256190976 (14904.11 GiB 16003.17 GB)
  Used Dev Size : 3907023872 (1863.01 GiB 2000.40 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : a3a9b4ad:cab2a5c4:fa4a83d2:6839a473

Internal Bitmap : 2 sectors from superblock
    Update Time : Sun Dec 11 08:12:18 2011
       Checksum : a956fd07 - correct
         Events : 293646

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 9
   Array State : AAAAAAAAAA ('A' == active, '.' == missing)

--------------080803080003060706080208
Content-Type: text/plain;
 name="examine-sdo1.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="examine-sdo1.txt"

/dev/sdo1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 35794893:8cbfdd41:36a60e33:2a6169dd
           Name : delta.onse.fi:delta  (local to host delta.onse.fi)
  Creation Time : Fri Sep  3 21:45:45 2010
     Raid Level : raid6
   Raid Devices : 10

 Avail Dev Size : 3907025072 (1863.01 GiB 2000.40 GB)
     Array Size : 31256190976 (14904.11 GiB 16003.17 GB)
  Used Dev Size : 3907023872 (1863.01 GiB 2000.40 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : f17591b8:8012317d:ded224ad:8054aee9

Internal Bitmap : 2 sectors from superblock
    Update Time : Sun Dec 11 08:12:18 2011
       Checksum : bd6acbef - correct
         Events : 293646

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : AAAAAAAAAA ('A' == active, '.' == missing)

--------------080803080003060706080208
Content-Type: text/plain;
 name="examine-sdp1.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="examine-sdp1.txt"

/dev/sdp1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 35794893:8cbfdd41:36a60e33:2a6169dd
           Name : delta.onse.fi:delta  (local to host delta.onse.fi)
  Creation Time : Fri Sep  3 21:45:45 2010
     Raid Level : raid6
   Raid Devices : 10

 Avail Dev Size : 3907025072 (1863.01 GiB 2000.40 GB)
     Array Size : 31256190976 (14904.11 GiB 16003.17 GB)
  Used Dev Size : 3907023872 (1863.01 GiB 2000.40 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : a0a2c206:5ce49b5c:f5a735f1:62352734

Internal Bitmap : 2 sectors from superblock
    Update Time : Sun Dec 11 08:12:18 2011
       Checksum : 79908075 - correct
         Events : 293646

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 6
   Array State : AAAAAAAAAA ('A' == active, '.' == missing)

--------------080803080003060706080208
Content-Type: text/plain;
 name="examine-sdq1.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="examine-sdq1.txt"

/dev/sdq1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 35794893:8cbfdd41:36a60e33:2a6169dd
           Name : delta.onse.fi:delta  (local to host delta.onse.fi)
  Creation Time : Fri Sep  3 21:45:45 2010
     Raid Level : raid6
   Raid Devices : 10

 Avail Dev Size : 3907025072 (1863.01 GiB 2000.40 GB)
     Array Size : 31256190976 (14904.11 GiB 16003.17 GB)
  Used Dev Size : 3907023872 (1863.01 GiB 2000.40 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 3cdd3e34:252a6077:8a1a5828:27528598

Internal Bitmap : 2 sectors from superblock
    Update Time : Sun Dec 11 08:12:18 2011
       Checksum : 5d51902e - correct
         Events : 293646

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 1
   Array State : AAAAAAAAAA ('A' == active, '.' == missing)

--------------080803080003060706080208
Content-Type: text/plain;
 name="proc_mdstat.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="proc_mdstat.txt"

Personalities : [raid1] [raid6] [raid5] [raid4] 
md0 : active raid6 sdo1[5] sde1[15](S) sdg1[14](S) sdi1[16](S) sdn1[13] sdm1[12] sdf1[18] sdp1[8] sdl1[9] sdj1[10] sdh1[17] sdk1[11] sdq1[2]
      15628095488 blocks super 1.2 level 6, 512k chunk, algorithm 2 [10/8] [UUU_UUU_UU]
      bitmap: 7/15 pages [28KB], 65536KB chunk

md1 : active raid1 sda2[0] sdb2[1]
      116170128 blocks super 1.2 [2/2] [UU]
      
unused devices: <none>

--------------080803080003060706080208--
