From: "Peter T. Breuer" <ptb@it.uc3m.es>
Subject: Fast RAID5
Date: Mon, 30 Aug 2004 17:25:37 +0200 (MET DST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200408301525.i7UFPbL22810@oboe.it.uc3m.es>
Reply-To: ptb@it.uc3m.es
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


I have a rudimentary patch for fast raid 5. It is currently available
at 

  ftp://oboe.it.uc3m.es/pub/Programs/fr5-1.0.tgz

I'll comment the patch when my head cold clears and I get over jetlag
in the next day or so (I am in the US).


md: syncing RAID array md0
md: minimum _guaranteed_ reconstruction speed: 100 KB/sec/disc.
md: using maximum available idle IO bandwith (but not more than 100000
KB/sec) for reconstruction.
md: using 124k window, over a total of 4032 blocks.
md0: retained bitmap a1c11e20
raid5: dirty stripe 4, sector 512, done 2, skipped clean sectors 0-511
                                           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
raid5: clean stripe 5, sector 640, done 2, synced maybe dirty sectors 512-639
raid5: clean stripe 62, sector 8062, done 2, skipped clean sectors 640-8063
                                           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
md: md0: sync done.
RAID5 conf printout:
 --- rd:3 wd:2 fd:1
 disk 0, s:0, o:1, n:0 rd:0 us:1 dev:[dev 07:00]
 disk 1, s:0, o:1, n:1 rd:1 us:1 dev:[dev 07:01]
 disk 2, s:0, o:0, n:2 rd:2 us:0 dev:[dev 00:00]
RAID5 conf printout:
 --- rd:3 wd:3 fd:0
 disk 0, s:0, o:1, n:0 rd:0 us:1 dev:[dev 07:00]
 disk 1, s:0, o:1, n:1 rd:1 us:1 dev:[dev 07:01]
 disk 2, s:0, o:1, n:2 rd:2 us:1 dev:[dev 07:02]
md: updating md0 RAID superblock on device
md: [dev 07:02] [events: 00000023]<6>(write) [dev 07:02]'s sb offset: 4032
md: [dev 07:00] [events: 00000023]<6>(write) [dev 07:00]'s sb offset: 4032
md: [dev 07:01] [events: 00000023]<6>(write) [dev 07:01]'s sb offset: 4032
md: recovery thread finished ...


At the moment the precision is only in terms of stripes (128 sectors),
but it could improve.

Peter


