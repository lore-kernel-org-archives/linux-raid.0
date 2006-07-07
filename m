From: "Christian Pernegger" <pernegger@gmail.com>
Subject: Re: Can't get md array to shut down cleanly
Date: Fri, 7 Jul 2006 22:06:34 +0200
Message-ID: <bb145bd20607071306t23ad638cu42b90b94e37ff98e@mail.gmail.com>
References: <bb145bd20607060648p3776d335g55e4bdee4ecaf3c4@mail.gmail.com>
	 <17581.35566.273512.814844@cse.unsw.edu.au>
	 <bb145bd20607061807m7d3a2395hd75b5b338b86e259@mail.gmail.com>
	 <17582.4876.14646.245791@cse.unsw.edu.au>
	 <bb145bd20607070225q7d6f943cx134815d004ad0d78@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <bb145bd20607070225q7d6f943cx134815d004ad0d78@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

It seems like it really isn't an md issue -- when I remove everything
to do with evms (userspace tools + initrd hooks) everything works
fine.

I took your patch back out and put a few printks in there ...
Without evms the "active" counter is 1 in an "idle" state, i. e. after the box
has finished booting.
With evms the counter is 2 in an "idle" state, and always one higher.

Directly before any attempt to shut down the array the counter is 3
with evms (thus the error) but only 2 without it.

I don't know if evms is buggy and fails to put back a reference or if
the +1 increase in the active counter is legit, and md.c needs a
better check then just "active needs to be below 3".

Longish dmesg excerpt follows, maybe someone can pinpoint the cause
and decide what
needs to be done.

md: md driver 0.90.3 MAX_MD_DEVS=256, MD_SB_DISKS=27
md: bitmap version 4.39
md: linear personality registered for level -1
md: raid0 personality registered for level 0
md: raid1 personality registered for level 1
md: raid10 personality registered for level 10
raid5: automatically using best checksumming function: generic_sse
  generic_sse:  4566.000 MB/sec
raid5: using function: generic_sse (4566.000 MB/sec)
md: raid5 personality registered for level 5
md: raid4 personality registered for level 4
raid6: int64x1   1331 MB/s
raid6: int64x2   1650 MB/s
raid6: int64x4   2018 MB/s
raid6: int64x8   1671 MB/s
raid6: sse2x1    2208 MB/s
raid6: sse2x2    3104 MB/s
raid6: sse2x4    2806 MB/s
raid6: using algorithm sse2x2 (3104 MB/s)
md: raid6 personality registered for level 6
md: REF UP: 2
md: REF DOWN: 1
md: REF UP: 2
md: REF DOWN: 1
md: REF UP: 2
md: REF DOWN: 1
md: REF UP: 2
md: REF DOWN: 1
md: REF UP: 2
md: REF DOWN: 1
md: REF UP: 2
md: bind<sdb>
md: REF DOWN: 1
md: REF UP: 2
md: bind<sdc>
md: REF DOWN: 1
md: REF UP: 2
md: bind<sdd>
md: REF DOWN: 1
md: REF UP: 2
md: bind<sde>
md: REF DOWN: 1
md: REF UP: 2
md: REF UP: 3
md: REF DOWN: 2
raid5: device sdd operational as raid disk 2
raid5: device sdc operational as raid disk 1
raid5: device sdb operational as raid disk 0
raid5: allocated 4262kB for md0
raid5: raid level 5 set md0 active with 3 out of 4 devices, algorithm 2
RAID5 conf printout:
 --- rd:4 wd:3 fd:1
 disk 0, o:1, dev:sdb
 disk 1, o:1, dev:sdc
 disk 2, o:1, dev:sdd
md0: bitmap initialized from disk: read 15/15 pages, set 0 bits, status: 0
created bitmap (233 pages) for device md0
RAID5 conf printout:
md: REF DOWN: 1
 --- rd:4 wd:3 fd:1
 disk 0, o:1, dev:sdb
 disk 1, o:1, dev:sdc
 disk 2, o:1, dev:sdd
 disk 3, o:1, dev:sde
md: REF UP: 2
md: REF UP: 3
md: REF DOWN: 2
md: REF DOWN: 1
md: syncing RAID array md0
md: minimum _guaranteed_ reconstruction speed: 1000 KB/sec/disc.
md: using maximum available idle IO bandwidth (but not more than
200000 KB/sec) for reconstruction.
md: using 128k window, over a total of 488386432 blocks.
md: REF UP: 2
md: REF DOWN: 1

*** [up to here everything is fine, but the counter never again drops
to 1 afterwards] ***

md: REF UP: 2
Attempting manual resume
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
md: REF UP: 3
hw_random: RNG not detected
md: REF DOWN: 2
Adding 4000176k swap on /dev/evms/sda2.  Priority:-1 extents:1 across:4000176k
EXT3 FS on dm-0, internal journal
md: REF UP: 3
md: REF DOWN: 2
*** [last two lines repeated fairly often, but more like excessive
polling than an infinite error loop] ***

Regards,

C.
