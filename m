From: Stephan van Hienen <raid@a2000.nu>
Subject: tuning disk on 3ware /performance problem
Date: Sun, 6 Apr 2003 16:20:33 +0200 (CEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.53.0304061251190.8636@ddx.a2000.nu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: bernard@biesterbos.nl
List-Id: linux-raid.ids

same disk (WD1800BB) on different controllers

----------
on intel u100/promise U100 :

/dev/hde:
 Timing buffer-cache reads:   128 MB in  0.28 seconds =457.14 MB/sec
 Timing buffered disk reads:  64 MB in  1.37 seconds = 46.72 MB/sec

Version 1.02c       ------Sequential Output------ --Sequential Input-
--Random-
                    -Per Chr- --Block-- -Rewrite- -Per Chr- --Block--
--Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP
/sec %CP
storage.a2000.nu 1G 22364  96 42206  13 15897   6 22634  91 44019  10
252.1   0
                    ------Sequential Create------ --------Random
Create--------
                    -Create-- --Read--- -Delete-- -Create-- --Read---
-Delete--
              files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
/sec %CP
                 16  3658  99 +++++ +++ +++++ +++  3757  99 +++++ +++
9681 100
storage.a2000.nu,1G,22364,96,42206,13,15897,6,22634,91,44019,10,252.1,0,16,3658,99,+++++,+++,+++++,+++,3757,99,+++++,+++,9681,100
----------
# hdparm -v /dev/hde

/dev/hde:
 multcount    = 16 (on)
 IO_support   =  3 (32-bit w/sync)
 unmaskirq    =  0 (off)
 using_dma    =  1 (on)
 keepsettings =  0 (off)
 readonly     =  0 (off)
 readahead    =  8 (on)
 geometry     = 21889/255/63, sectors = 351651888, start = 0


----------
on 3ware (7850) :

/dev/sdb:
 Timing buffer-cache reads:   128 MB in  0.28 seconds =457.14 MB/sec
 Timing buffered disk reads:  64 MB in  1.70 seconds = 37.65 MB/sec


Version 1.02c       ------Sequential Output------ --Sequential Input-
--Random-
                    -Per Chr- --Block-- -Rewrite- -Per Chr- --Block--
--Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP
/sec %CP
storage.a2000.nu 1G 22151  94 67312  18 20152   8 22315  90 38488   9
260.4   0
                    ------Sequential Create------ --------Random
Create--------
                    -Create-- --Read--- -Delete-- -Create-- --Read---
-Delete--
              files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
/sec %CP
                 16  3706  99 +++++ +++ +++++ +++  3895  99 +++++ +++
9686  99
storage.a2000.nu,1G,22151,94,67312,18,20152,8,22315,90,38488,9,260.4,0,16,3706,99,+++++,+++,+++++,+++,3895,99,+++++,+++,9686,99
----------
]# hdparm -v /dev/sdb

/dev/sdb:
 readonly     =  0 (off)
 geometry     = 21889/255/63, sectors = 351651888, start = 0


Is there anything i can do to tune the drives connected to he 3ware
controller ? (37MB/sec vs 43MB/sec)
(and why is the seq. output block 65MB/sec on the 3ware vs 41MB/sec on
'ide controllers')

