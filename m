From: Kari Kallioinen <karbas-raid@frontier.tky.hut.fi>
Subject: Problems with autodetecting arrays
Date: Thu, 3 Jul 2003 18:23:37 +0300
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030703152337.GA702@frontier.tky.hut.fi>
Reply-To: karbas-raid@frontier.tky.hut.fi
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I have 5 hard drives. 1x60GB,1x80Gb,3x120. I have set up one 120GB raid0-array
from 60&80 GB hard drives(md0). Then I have made raid4-array from those three
120GB + md0.

But now I have problem. When system boot's up, it detects first this md0(raid0)
array and then this raid5. Unfortunately this raid5 doesn't find this md0 even
kernel have already set it up.

So my question is that is this a bug or have I done something wrong?

Here is part of the kern.log:

Jul  3 17:55:38 frontier kernel: md: linear personality registered as nr 1
Jul  3 17:55:38 frontier kernel: md: raid0 personality registered as nr 2
Jul  3 17:55:38 frontier kernel: md: raid1 personality registered as nr 3
Jul  3 17:55:38 frontier kernel: md: raid5 personality registered as nr 4
Jul  3 17:55:38 frontier kernel: raid5: measuring checksumming speed
Jul  3 17:55:38 frontier kernel:    8regs     :  1296.800 MB/sec
Jul  3 17:55:38 frontier kernel:    32regs    :   919.600 MB/sec
Jul  3 17:55:38 frontier kernel:    pII_mmx   :  1989.200 MB/sec
Jul  3 17:55:38 frontier kernel:    p5_mmx    :  2551.600 MB/sec
Jul  3 17:55:38 frontier kernel: raid5: using function: p5_mmx (2551.600 MB/sec)
Jul  3 17:55:38 frontier kernel: md: multipath personality registered as nr 7
Jul  3 17:55:38 frontier kernel: md: md driver 0.90.0 MAX_MD_DEVS=256, MD_SB_DISKS=27
Jul  3 17:55:38 frontier kernel: md: Autodetecting RAID arrays.
Jul  3 17:55:38 frontier kernel:  [events: 00000045]
Jul  3 17:55:38 frontier last message repeated 2 times
Jul  3 17:55:38 frontier kernel:  [events: 00000009]
Jul  3 17:55:38 frontier kernel:  [events: 00000009]
Jul  3 17:55:38 frontier kernel: md: autorun ...
Jul  3 17:55:38 frontier kernel: md: considering ide/host2/bus1/target1/lun0/part1 ...
Jul  3 17:55:38 frontier kernel: md:  adding ide/host2/bus1/target1/lun0/part1 ...
Jul  3 17:55:38 frontier kernel: md:  adding ide/host2/bus1/target0/lun0/part1 ...
Jul  3 17:55:38 frontier kernel: md: created md0
Jul  3 17:55:38 frontier kernel: md: bind<ide/host2/bus1/target0/lun0/part1,1>
Jul  3 17:55:38 frontier kernel: md: bind<ide/host2/bus1/target1/lun0/part1,2>
Jul  3 17:55:38 frontier kernel: md: running: <ide/host2/bus1/target1/lun0/part1><ide/host2/bus1/target0/lun0/part1>
Jul  3 17:55:38 frontier kernel: md: ide/host2/bus1/target1/lun0/part1's event counter: 00000009
Jul  3 17:55:38 frontier kernel: md: ide/host2/bus1/target0/lun0/part1's event counter: 00000009
Jul  3 17:55:38 frontier kernel: md0: max total readahead window set to 124k
Jul  3 17:55:38 frontier kernel: md0: 1 data-disks, max readahead per data-disk: 124k
Jul  3 17:55:38 frontier kernel: md: updating md0 RAID superblock on device
Jul  3 17:55:38 frontier kernel: md: ide/host2/bus1/target1/lun0/part1 [events: 0000000a]<6>(write) ide/host2/bus1/target1/lun0/part1's sb offset: 58623168
Jul  3 17:55:38 frontier kernel: md: ide/host2/bus1/target0/lun0/part1 [events: 0000000a]<6>(write) ide/host2/bus1/target0/lun0/part1's sb offset: 58623168
Jul  3 17:55:38 frontier kernel: md: considering ide/host0/bus1/target1/lun0/part1 ...
Jul  3 17:55:38 frontier kernel: md:  adding ide/host0/bus1/target1/lun0/part1 ...
Jul  3 17:55:38 frontier kernel: md:  adding ide/host0/bus1/target0/lun0/part1 ...
Jul  3 17:55:38 frontier kernel: md:  adding ide/host0/bus0/target0/lun0/part1 ...
Jul  3 17:55:38 frontier kernel: md: created md1
Jul  3 17:55:38 frontier kernel: md: bind<ide/host0/bus0/target0/lun0/part1,1>
Jul  3 17:55:38 frontier kernel: md: bind<ide/host0/bus1/target0/lun0/part1,2>
Jul  3 17:55:38 frontier kernel: md: bind<ide/host0/bus1/target1/lun0/part1,3>
Jul  3 17:55:38 frontier kernel: md: running: <ide/host0/bus1/target1/lun0/part1><ide/host0/bus1/target0/lun0/part1><ide/host0/bus0/target0/lun0/part1>
Jul  3 17:55:38 frontier kernel: md: ide/host0/bus1/target1/lun0/part1's event counter: 00000045
Jul  3 17:55:38 frontier kernel: md: ide/host0/bus1/target0/lun0/part1's event counter: 00000045
Jul  3 17:55:38 frontier kernel: md: ide/host0/bus0/target0/lun0/part1's event counter: 00000045
Jul  3 17:55:38 frontier kernel: md: device name has changed from [dev 21:01] to ide/host0/bus1/target1/lun0/part1 since last import!
Jul  3 17:55:38 frontier kernel: md1: former device md/0 is unavailable, removing from array!
Jul  3 17:55:38 frontier kernel: md: md1: raid array is not clean -- starting background reconstruction
Jul  3 17:55:38 frontier kernel: md1: max total readahead window set to 744k
Jul  3 17:55:38 frontier kernel: md1: 3 data-disks, max readahead per data-disk: 248k
Jul  3 17:55:38 frontier kernel: raid5: device ide/host0/bus1/target1/lun0/part1 operational as raid disk 0
Jul  3 17:55:38 frontier kernel: raid5: device ide/host0/bus1/target0/lun0/part1 operational as raid disk 1
Jul  3 17:55:38 frontier kernel: raid5: device ide/host0/bus0/target0/lun0/part1 operational as raid disk 2
Jul  3 17:55:38 frontier kernel: raid5: md1, not all disks are operational -- trying to recover array
Jul  3 17:55:38 frontier kernel: raid5: allocated 4330kB for md1
Jul  3 17:55:38 frontier kernel: raid5: raid level 4 set md1 active with 3 out of 4 devices, algorithm 0
Jul  3 17:55:38 frontier kernel: RAID5 conf printout:
Jul  3 17:55:38 frontier kernel:  --- rd:4 wd:3 fd:1
Jul  3 17:55:38 frontier kernel:  disk 0, s:0, o:1, n:0 rd:0 us:1 dev:ide/host0/bus1/target1/lun0/part1
Jul  3 17:55:38 frontier kernel:  disk 1, s:0, o:1, n:1 rd:1 us:1 dev:ide/host0/bus1/target0/lun0/part1
Jul  3 17:55:38 frontier kernel:  disk 2, s:0, o:1, n:2 rd:2 us:1 dev:ide/host0/bus0/target0/lun0/part1
Jul  3 17:55:38 frontier kernel:  disk 3, s:0, o:0, n:3 rd:3 us:1 dev:[dev 00:00]
Jul  3 17:55:38 frontier kernel: RAID5 conf printout:
Jul  3 17:55:38 frontier kernel:  --- rd:4 wd:3 fd:1
Jul  3 17:55:38 frontier kernel:  disk 0, s:0, o:1, n:0 rd:0 us:1 dev:ide/host0/bus1/target1/lun0/part1
Jul  3 17:55:38 frontier kernel:  disk 1, s:0, o:1, n:1 rd:1 us:1 dev:ide/host0/bus1/target0/lun0/part1
Jul  3 17:55:38 frontier kernel:  disk 2, s:0, o:1, n:2 rd:2 us:1 dev:ide/host0/bus0/target0/lun0/part1
Jul  3 17:55:38 frontier kernel:  disk 3, s:0, o:0, n:3 rd:3 us:1 dev:[dev 00:00]
Jul  3 17:55:38 frontier kernel: md: updating md1 RAID superblock on device
Jul  3 17:55:38 frontier kernel: md: ide/host0/bus1/target1/lun0/part1 [events: 00000046]<6>(write) ide/host0/bus1/target1/lun0/part1's sb offset: 117242240
Jul  3 17:55:38 frontier kernel: md: recovery thread got woken up ...
Jul  3 17:55:38 frontier kernel: md1: no spare disk to reconstruct array! -- continuing in degraded mode
Jul  3 17:55:38 frontier kernel: md: recovery thread finished ...
Jul  3 17:55:38 frontier kernel: md: ide/host0/bus1/target0/lun0/part1 [events: 00000046]<6>(write) ide/host0/bus1/target0/lun0/part1's sb offset: 117246400
Jul  3 17:55:38 frontier kernel: md: ide/host0/bus0/target0/lun0/part1 [events: 00000046]<6>(write) ide/host0/bus0/target0/lun0/part1's sb offset: 117246400
Jul  3 17:55:38 frontier kernel: md: ... autorun DONE.

Output of the uname -a:
Linux frontier 2.4.21 #2 Sat Jun 28 23:26:58 EEST 2003 i686 GNU/Linux

After adding manually this md0 to md1, /proc/mdstat looks like this:
Personalities : [linear] [raid0] [raid1] [raid5] [multipath] 
read_ahead 1024 sectors
md1 : active raid5 md/0[4] ide/host0/bus1/target1/lun0/part1[0] ide/host0/bus1/target0/lun0/part1[1] ide/host0/bus0/target0/lun0/part1[2]
      351726720 blocks level 4, 32k chunk, algorithm 0 [4/3] [UUU_]
      [>....................]  recovery =  1.8% (2205712/117242240) finish=10613.4min speed=180K/sec
md0 : active linear ide/host2/bus1/target1/lun0/part1[1] ide/host2/bus1/target0/lun0/part1[0]
      117246336 blocks 16k rounding
      
unused devices: <none>

-- 
Kari Kallioinen 
