From: seth vidal <skvidal@phy.duke.edu>
Subject: Re: a couple of mdadm questions
Date: 08 Sep 2003 09:53:25 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1063029205.22120.4.camel@opus>
References: <1062879895.8172.20.camel@opus>
	 <16220.10893.339884.282892@gargle.gargle.HOWL>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16220.10893.339884.282892@gargle.gargle.HOWL>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> You could get mdadm 1.3.0, add some patches from
>     http://cgi.cse.unsw.edu.au/~neilb/source/mdadm/patch/applied/
> and try
>    --assemble --update=summaries
> 
> it should fix these counts for you.
hmmm

good call.
Thanks



> Probably.  What is the actual message?

All of the output attached below:

raid5: using function: p5_mmx (2653.200 MB/sec)
md: raid5 personality registered as nr 4
Journalled Block Device driver loaded
md: Autodetecting RAID arrays.
 [events: 00000053]
 [events: 00000053]
 [events: 00000053]
md: autorun ...
md: considering sdf1 ...
md:  adding sdf1 ...
md:  adding sde1 ...
md:  adding sdc1 ...
md: created md1
md: bind<sdc1,1>
md: bind<sde1,2>
md: bind<sdf1,3>
md: running: <sdf1><sde1><sdc1>
md: sdf1's event counter: 00000053
md: sde1's event counter: 00000053
md: sdc1's event counter: 00000053
md1: former device sdb1 is unavailable, removing from array!
md1: former device sdd1 is unavailable, removing from array!
md1: former device sdg1 is unavailable, removing from array!
md1: former device sdh1 is unavailable, removing from array!
md1: max total readahead window set to 1536k
md1: 6 data-disks, max readahead per data-disk: 256k
raid5: device sdf1 operational as raid disk 4
raid5: device sde1 operational as raid disk 3
raid5: device sdc1 operational as raid disk 1
raid5: not enough operational devices for md1 (4/7 failed)
RAID5 conf printout:
 --- rd:7 wd:3 fd:4
 disk 0, s:0, o:0, n:0 rd:0 us:1 dev:[dev 00:00]
 disk 1, s:0, o:1, n:1 rd:1 us:1 dev:sdc1
 disk 2, s:0, o:0, n:2 rd:2 us:1 dev:[dev 00:00]
 disk 3, s:0, o:1, n:3 rd:3 us:1 dev:sde1
 disk 4, s:0, o:1, n:4 rd:4 us:1 dev:sdf1
 disk 5, s:0, o:0, n:5 rd:5 us:1 dev:[dev 00:00]
 disk 6, s:0, o:0, n:6 rd:6 us:1 dev:[dev 00:00]
raid5: failed to run raid set md1
md: pers->run() failed ...
md :do_md_run() returned -22
md: md1 stopped.
md: unbind<sdf1,2>
md: export_rdev(sdf1)
md: unbind<sde1,1>
md: export_rdev(sde1)
md: unbind<sdc1,0>
md: export_rdev(sdc1)
md: ... autorun DONE.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
Freeing unused kernel memory: 116k freed
Adding Swap: 2096472k swap-space (priority -1)
EXT3 FS 2.4-0.9.19, 19 August 2002 on sd(8,1), internal journal
 [events: 00000053]
 [events: 00000053]
 [events: 00000053]
 [events: 00000053]
 [events: 00000053]
 [events: 00000053]
 [events: 00000053]
md: autorun ...
md: considering sdh1 ...
md:  adding sdh1 ...
md:  adding sdg1 ...
md:  adding sdf1 ...
md:  adding sde1 ...
md:  adding sdd1 ...
md:  adding sdb1 ...
md:  adding sdc1 ...
md: created md1
md: bind<sdc1,1>
md: bind<sdb1,2>
md: bind<sdd1,3>
md: bind<sde1,4>
md: bind<sdf1,5>
md: bind<sdg1,6>
md: bind<sdh1,7>
md: running: <sdh1><sdg1><sdf1><sde1><sdd1><sdb1><sdc1>
md: sdh1's event counter: 00000053
md: sdg1's event counter: 00000053
md: sdf1's event counter: 00000053
md: sde1's event counter: 00000053
md: sdd1's event counter: 00000053
md: sdb1's event counter: 00000053
md: sdc1's event counter: 00000053
md1: max total readahead window set to 1536k
md1: 6 data-disks, max readahead per data-disk: 256k
raid5: device sdh1 operational as raid disk 6
raid5: device sdg1 operational as raid disk 5
raid5: device sdf1 operational as raid disk 4
raid5: device sde1 operational as raid disk 3
raid5: device sdd1 operational as raid disk 2
raid5: device sdb1 operational as raid disk 0
raid5: device sdc1 operational as raid disk 1
raid5: allocated 7475kB for md1
raid5: raid level 5 set md1 active with 7 out of 7 devices, algorithm 0
RAID5 conf printout:
 --- rd:7 wd:7 fd:0
 disk 0, s:0, o:1, n:0 rd:0 us:1 dev:sdb1
 disk 1, s:0, o:1, n:1 rd:1 us:1 dev:sdc1
 disk 2, s:0, o:1, n:2 rd:2 us:1 dev:sdd1
 disk 3, s:0, o:1, n:3 rd:3 us:1 dev:sde1
 disk 4, s:0, o:1, n:4 rd:4 us:1 dev:sdf1
 disk 5, s:0, o:1, n:5 rd:5 us:1 dev:sdg1
 disk 6, s:0, o:1, n:6 rd:6 us:1 dev:sdh1
RAID5 conf printout:
 --- rd:7 wd:7 fd:0
 disk 0, s:0, o:1, n:0 rd:0 us:1 dev:sdb1
 disk 1, s:0, o:1, n:1 rd:1 us:1 dev:sdc1
 disk 2, s:0, o:1, n:2 rd:2 us:1 dev:sdd1
 disk 3, s:0, o:1, n:3 rd:3 us:1 dev:sde1
 disk 4, s:0, o:1, n:4 rd:4 us:1 dev:sdf1
 disk 5, s:0, o:1, n:5 rd:5 us:1 dev:sdg1
 disk 6, s:0, o:1, n:6 rd:6 us:1 dev:sdh1
md: updating md1 RAID superblock on device
md: sdh1 [events: 00000054]<6>(write) sdh1's sb offset: 71681920
md: sdg1 [events: 00000054]<6>(write) sdg1's sb offset: 71681920
md: sdf1 [events: 00000054]<6>(write) sdf1's sb offset: 71681920
md: sde1 [events: 00000054]<6>(write) sde1's sb offset: 71681920
md: sdd1 [events: 00000054]<6>(write) sdd1's sb offset: 71681920
md: sdb1 [events: 00000054]<6>(write) sdb1's sb offset: 71681920
md: sdc1 [events: 00000054]<6>(write) sdc1's sb offset: 71681920
md: ... autorun DONE.
raid5: switching cache buffer size, 4096 --> 1024
raid5: switching cache buffer size, 1024 --> 4096


Thanks
-sv


