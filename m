From: "fibreraid@gmail.com" <fibreraid@gmail.com>
Subject: Single Drive Pegged during RAID 5 synchronization
Date: Wed, 29 Jun 2011 06:23:34 -0700
Message-ID: <BANLkTikXNnVyRYjWDCYPq1n8dgGA2zaGog@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: fibre raid <fibreraid@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi All,

I am seeing an intermittent issue where a single HDD is pegged higher
than the rest during md RAID 5 synchronization. I have swapped the
drive, and even swapped server hardware (tested on two different
servers), and seen the same issue, so I am doubtful the issue is
hardware.

Linux 2.6.38 kernel
md 3.2.1
24 x 15K HDD's
LSI SAS HBA for connectivity
Dual socket 6-cores per socket Westmere CPU's
48GB RAM


For the md0, stripe_cache_size is set to 32768.


Here is /proc/diskstats. Note that /dev/sdn (and /dev/sdn1, since I
use partitions in my md arrays) has a Busy state pegged much higher
than every other drive. Basically, this holds back the performance of
the syncing substantially. Presently, I see this issue 60% of the time
when I create this same 24 drive md RAID 5, but not always, even on
the same hardware and different hardware. It's the luck of the draw,
it seems, as I am using the same exact md parameters everytime (its a
script I've written). Any insight would be helpful! I'm happy to share
any details you need.

   8      16 sdb 211255 6666671 54996777 6443720 377 1517 15182 420 37
174260 6445100
   8      17 sdb1 211222 6666672 54996513 6443700 375 1517 15182 330
37 174150 6444990
   8      32 sdc 211765 6666192 54999961 6421520 377 1558 15510 380 34
174330 6422710
   8      33 sdc1 211732 6666192 54999697 6421470 375 1558 15510 300
34 174200 6422580
   8      48 sdd 212307 6665648 54999297 6461190 397 1642 16286 380 34
174220 6462560
   8      49 sdd1 212274 6665648 54999033 6461170 395 1642 16286 300
34 174120 6462460
   8      64 sde 211710 6666237 54998601 6476740 383 1576 15630 380 34
174260 6477820
   8      65 sde1 211677 6666237 54998337 6476700 381 1576 15630 300
34 174140 6477700
   8      80 sdf 136 602 1073 70 3 1 4 10 0 80 80
   8      81 sdf1 103 602 809 40 2 1 4 0 0 40 40
   8      96 sdg 212614 6665307 54996689 6454800 400 1510 15254 390 38
174260 6456330
   8      97 sdg1 212581 6665307 54996425 6454770 398 1510 15254 300
38 174140 6456210
   8     112 sdh 213941 6663994 54995737 6459190 476 1466 15518 190 39
174120 6460710
   8     113 sdh1 213908 6663994 54995473 6459160 474 1466 15518 190
39 174090 6460680
   8     128 sdi 214546 6663411 54999522 6452290 429 1478 15254 150 34
174130 6453420
   8     129 sdi1 214513 6663412 54999258 6452250 427 1478 15254 140
34 174080 6453370
   8     144 sdj 209035 6668893 54999097 6443480 346 1519 14894 380 34
174260 6444690
   8     145 sdj1 209002 6668893 54998833 6443380 344 1519 14894 300
34 174080 6444510
   8     160 sdk 209119 6668782 54998865 6420410 378 1483 14870 370 35
174280 6421940
   8     161 sdk1 209086 6668782 54998601 6420320 376 1483 14870 290
35 174110 6421770
   8     176 sdl 209757 6668165 54997097 6442070 358 1516 14982 340 36
174270 6443350
   8     177 sdl1 209724 6668165 54996833 6441980 356 1516 14982 260
36 174100 6443180
   8     192 sdm 210138 6667816 54996905 6472880 354 1525 15022 330 36
174220 6474120
   8     193 sdm1 210105 6667816 54996641 6472780 352 1525 15022 250
36 174040 6473940
   8     208 sdn 112322 6765562 54967569 10757840 354 1506 14894 520
50 198980 10761710
   8     209 sdn1 112289 6765562 54967305 10757730 352 1506 14894 440
50 198790 10761520
   8     224 sdo 210541 6667355 54998705 6468100 390 1468 14854 340 34
174290 6469340
   8     225 sdo1 210508 6667355 54998441 6468000 388 1468 14854 260
34 174110 6469160
   8     240 sdp 210883 6667016 54995489 6459260 356 1499 14838 360 38
174240 6460950
   8     241 sdp1 210850 6667016 54995225 6459140 354 1499 14838 280
38 174040 6460750
  65       0 sdq 211738 6666198 54996641 6425340 339 1514 14838 410 38
174300 6426920
  65       1 sdq1 211705 6666198 54996377 6425250 337 1514 14838 330
38 174130 6426750
  65      16 sdr 208645 6669245 54998905 6448670 373 1491 14902 350 34
174190 6449680
  65      17 sdr1 208612 6669246 54998641 6448590 371 1491 14902 270
34 174030 6449520
  65      32 sds 208589 6669311 54998505 6407470 356 1497 14846 360 36
174220 6408640
  65      33 sds1 208556 6669311 54998241 6407390 354 1497 14846 280
36 174060 6408480
  65      48 sdt 208607 6669288 54995817 6427660 342 1514 14838 360 38
174290 6429310
  65      49 sdt1 208574 6669288 54995553 6427550 340 1514 14838 280
38 174100 6429120
  65      64 sdu 208873 6669043 54996313 6401250 384 1482 14910 390 37
174270 6402750
  65      65 sdu1 208840 6669043 54996049 6401160 382 1482 14910 310
37 174100 6402580
  65      80 sdv 207564 6670749 54997755 6417840 388 1521 15270 370 38
174280 6419210
  65      81 sdv1 207531 6670749 54997491 6417740 386 1521 15270 290
38 174100 6419030
  65      96 sdw 206935 6670977 54998065 6422840 342 1522 14958 350 35
174260 6424060
  65      97 sdw1 206902 6670977 54997801 6422720 340 1522 14958 270
35 174060 6423860
  65     112 sdx 208733 6669162 54996609 6394610 360 1517 14998 10 38
173920 6395820
  65     113 sdx1 208700 6669162 54996345 6394520 358 1517 14998 10 38
173830 6395730
  65     128 sdy 207494 6670422 54996545 6429010 332 1542 14966 340 36
174200 6430330
  65     129 sdy1 207461 6670422 54996281 6428910 330 1542 14966 260
36 174020 6430150


/dev/md0:
        Version : 1.2
  Creation Time : Wed Jun 29 06:12:22 2011
     Raid Level : raid5
     Array Size : 8595566848 (8197.37 GiB 8801.86 GB)
  Used Dev Size : 390707584 (372.61 GiB 400.08 GB)
   Raid Devices : 23
  Total Devices : 24
    Persistence : Superblock is persistent

    Update Time : Wed Jun 29 06:18:53 2011
          State : active, resyncing
 Active Devices : 23
Working Devices : 24
 Failed Devices : 0
  Spare Devices : 1

         Layout : left-symmetric
     Chunk Size : 64K

 Rebuild Status : 16% complete

           Name : 00259009BA16:md0  (local to host 00259009BA16)
           UUID : c44e5382:8f2c2979:2206f737:ee6f22c1
         Events : 3

    Number   Major   Minor   RaidDevice State
       0      65       81        0      active sync   /dev/sdv1
       1      65       97        1      active sync   /dev/sdw1
       2      65      113        2      active sync   /dev/sdx1
       3      65      129        3      active sync   /dev/sdy1
       4      65       17        4      active sync   /dev/sdr1
       5      65       33        5      active sync   /dev/sds1
       6      65       49        6      active sync   /dev/sdt1
       7      65       65        7      active sync   /dev/sdu1
       8       8      145        8      active sync   /dev/sdj1
       9       8      161        9      active sync   /dev/sdk1
      10       8      177       10      active sync   /dev/sdl1
      11       8      193       11      active sync   /dev/sdm1
      12       8      225       12      active sync   /dev/sdo1
      13       8      241       13      active sync   /dev/sdp1
      14      65        1       14      active sync   /dev/sdq1
      15       8      209       15      active sync   /dev/sdn1
      16       8       17       16      active sync   /dev/sdb1
      17       8       33       17      active sync   /dev/sdc1
      18       8       49       18      active sync   /dev/sdd1
      19       8       65       19      active sync   /dev/sde1
      20       8       97       20      active sync   /dev/sdg1
      21       8      113       21      active sync   /dev/sdh1
      22       8      129       22      active sync   /dev/sdi1

      23       8       81        -      spare   /dev/sdf1


Thanks,
TG
