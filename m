From: Dominik Sennfelder <buliwyf@gmx.de>
Subject: F***** Raid Perfomance with Raid5
Date: Thu, 4 Mar 2004 21:33:52 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1697082605.20040304213352@gmx.de>
Reply-To: Dominik Sennfelder <buliwyf@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello

Im running a Raid 5 with 4 160 GB Discs.
Every Disc is running on 1 port of a promise controller.
That means that i have got 2 Promise Rais controllers in the box.
The discs in single mode are fast, but the raid is slow.
Here you have got some hdparm output.
Does anyone have an idea how the problem can be solved?
Thx for your help

buliwyf


utgard:~# hdparm -tT /dev/hde1 ;hdparm -tT /dev/hdg1 ;hdparm -tT /dev/hdi1 ;hdparm -Tt /dev/hdk1 ;hdparm -tT  /dev/md0

/dev/hde1:
 Timing buffer-cache reads:   128 MB in  0.44 seconds =288.98 MB/sec
 Timing buffered disk reads:  64 MB in  1.31 seconds = 48.86 MB/sec

/dev/hdg1:
 Timing buffer-cache reads:   128 MB in  0.44 seconds =293.62 MB/sec
 Timing buffered disk reads:  64 MB in  1.27 seconds = 50.56 MB/sec

/dev/hdi1:
 Timing buffer-cache reads:   128 MB in  0.43 seconds =298.41 MB/sec
 Timing buffered disk reads:  64 MB in  3.50 seconds = 18.30 MB/sec

/dev/hdk1:
 Timing buffer-cache reads:   128 MB in  0.42 seconds =301.22 MB/sec
 Timing buffered disk reads:  64 MB in  1.29 seconds = 49.58 MB/sec

/dev/md0:
 Timing buffer-cache reads:   128 MB in  0.43 seconds =294.30 MB/sec
 Timing buffered disk reads:  64 MB in  1.96 seconds = 32.62 MB/sec

utgard:~# cat /etc/raidtab
raiddev /dev/md0
        raid-level      5
        nr-raid-disks   4
        nr-spare-disks  0
        persistent-superblock 1
        parity-algorithm        left-symmetric
        chunk-size      32
        device          /dev/hde1
        raid-disk       0
        device          /dev/hdg1
        raid-disk       1
        device          /dev/hdi1
        raid-disk       2
        device          /dev/hdk1
        raid-disk       3
utgard:~# hdparm /dev/hde

/dev/hde:
 multcount    = 16 (on)
 I/O support  =  3 (32-bit w/sync)
 unmaskirq    =  1 (on)
 using_dma    =  1 (on)
 keepsettings =  0 (off)
 nowerr       =  0 (off)
 readonly     =  0 (off)
 readahead    = 256 (on)
 geometry     = 19457/255/63, sectors = 312581808, start = 0
 busstate     =  1 (on)
utgard:~# hdparm /dev/hdg

/dev/hdg:
 multcount    = 16 (on)
 I/O support  =  3 (32-bit w/sync)
 unmaskirq    =  1 (on)
 using_dma    =  1 (on)
 keepsettings =  0 (off)
 nowerr       =  0 (off)
 readonly     =  0 (off)
 readahead    = 256 (on)
 geometry     = 19457/255/63, sectors = 312581808, start = 0
 busstate     =  1 (on)
utgard:~# hdparm /dev/hdi

/dev/hdi:
 multcount    = 16 (on)
 I/O support  =  3 (32-bit w/sync)
 unmaskirq    =  1 (on)
 using_dma    =  1 (on)
 keepsettings =  0 (off)
 nowerr       =  0 (off)
 readonly     =  0 (off)
 readahead    = 256 (on)
 geometry     = 19457/255/63, sectors = 312581808, start = 0
 busstate     =  1 (on)
utgard:~# hdparm /dev/hdk

/dev/hdk:
 multcount    = 16 (on)
 I/O support  =  3 (32-bit w/sync)
 unmaskirq    =  1 (on)
 using_dma    =  1 (on)
 keepsettings =  0 (off)
 nowerr       =  0 (off)
 readonly     =  0 (off)
 readahead    = 256 (on)
 geometry     = 19457/255/63, sectors = 312581808, start = 0
 busstate     =  1 (on)
utgard:~# hdparm /dev/md0

/dev/md0:
 readonly     =  0 (off)
 geometry     = 37824/2/4, sectors = 937729536, start = 0
utgard:~#





