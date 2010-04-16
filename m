From: Brett King <king.br@gmail.com>
Subject: compute_blocknr: map not correct error during RAID6 reshape 6 -> 7
	disks, mdadm 3.1.2 / kernel 2.6.34-rc3
Date: Fri, 16 Apr 2010 11:56:57 +1000
Message-ID: <u2j8cf253381004151856l76b4e227mc6327534e0e304ad@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi All,
I'm currently encountering an error when growing a 6-disk RAID6 array
to 7 disks (2TB disks used). The reshape stalls with many
"compute_blocknr: map not correct" errors in the system log.

array:~ # mdadm -V
mdadm - v3.1.2 - 10th March 2010
array:~ # uname -a
Linux array 2.6.34-rc3-11-default #1 SMP 2010-04-09 18:24:53 +0200
x86_64 x86_64 x86_64 GNU/Linux
array:~ # cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md2000 : active raid6 sdl[0] sda[6] sdq[5] sdp[4] sdo[3] sdn[2] sdm[1]
      7814057808 blocks super 1.1 level 6, 4k chunk, algorithm 18
[7/7] [UUUUUUU]
      [=================>...]  reshape = 87.9% (1717986916/1953514452)
finish=15863.5min speed=247K/sec

unused devices: <none>
array:~ #

COMMAND:

array:~ # mdadm -A /dev/md2000 /dev/sda /dev/sd[l-q]
mdadm: /dev/md2000 has been started with 7 drives.
array:~ # cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md2000 : active raid6 sdl[0] sda[6] sdq[5] sdp[4] sdo[3] sdn[2] sdm[1]
      7814057808 blocks super 1.1 level 6, 4k chunk, algorithm 18
[7/7] [UUUUUUU]
      [=================>...]  reshape = 87.9% (1717808872/1953514452)
finish=151.3min speed=25946K/sec

unused devices: <none>
array:~ # cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md2000 : active raid6 sdl[0] sda[6] sdq[5] sdp[4] sdo[3] sdn[2] sdm[1]
      7814057808 blocks super 1.1 level 6, 4k chunk, algorithm 18
[7/7] [UUUUUUU]
      [=================>...]  reshape = 87.9% (1717986916/1953514452)
finish=111.4min speed=35228K/sec

unused devices: <none>
array:~ #

As you can see the reshape jumps back a few blocks then gets stuck,
throwing many compute_blocknr: map not correct errors in syslog.

SYSLOG:

Apr 15 23:10:11 array kernel: [  765.216458] md: md2000 stopped.
Apr 15 23:10:11 array kernel: [  765.261491] md: bind<sdm>
Apr 15 23:10:11 array kernel: [  765.261679] md: bind<sdn>
Apr 15 23:10:11 array kernel: [  765.261864] md: bind<sdo>
Apr 15 23:10:11 array kernel: [  765.262002] md: bind<sdp>
Apr 15 23:10:11 array kernel: [  765.262136] md: bind<sdq>
Apr 15 23:10:11 array kernel: [  765.273414] md: bind<sdl>
Apr 15 23:10:11 array kernel: [  765.280031] async_tx: api initialized
(async)
Apr 15 23:10:11 array kernel: [  765.283014] xor: automatically using
best checksumming function: generic_sse
Apr 15 23:10:11 array kernel: [  765.300671]    generic_sse:  6006.000
MB/sec
Apr 15 23:10:11 array kernel: [  765.300676] xor: using function:
generic_sse (6006.000 MB/sec)
Apr 15 23:10:11 array kernel: [  765.376648] raid6: int64x1   1466
MB/s
Apr 15 23:10:11 array kernel: [  765.444542] raid6: int64x2   1815
MB/s
Apr 15 23:10:11 array kernel: [  765.512417] raid6: int64x4   1262
MB/s
Apr 15 23:10:12 array kernel: [  765.580300] raid6: int64x8   1393
MB/s
Apr 15 23:10:12 array kernel: [  765.648185] raid6: sse2x1    3960
MB/s
Apr 15 23:10:12 array kernel: [  765.716074] raid6: sse2x2    4649
MB/s
Apr 15 23:10:12 array kernel: [  765.783954] raid6: sse2x4    5007
MB/s
Apr 15 23:10:12 array kernel: [  765.783959] raid6: using algorithm
sse2x4 (5007 MB/s)
Apr 15 23:10:12 array kernel: [  765.800602] md: raid6 personality
registered for level 6
Apr 15 23:10:12 array kernel: [  765.800611] md: raid5 personality
registered for level 5
Apr 15 23:10:12 array kernel: [  765.800617] md: raid4 personality
registered for level 4
Apr 15 23:10:12 array kernel: [  765.805135] raid5: reshape will
continue
Apr 15 23:10:12 array kernel: [  765.805153] raid5: device sdl
operational as raid disk 0
Apr 15 23:10:12 array kernel: [  765.805158] raid5: device sdq
operational as raid disk 5
Apr 15 23:10:12 array kernel: [  765.805161] raid5: device sdp
operational as raid disk 4
Apr 15 23:10:12 array kernel: [  765.805165] raid5: device sdo
operational as raid disk 3
Apr 15 23:10:12 array kernel: [  765.805169] raid5: device sdn
operational as raid disk 2
Apr 15 23:10:12 array kernel: [  765.805172] raid5: device sdm
operational as raid disk 1
Apr 15 23:10:12 array kernel: [  765.806332] raid5: allocated 7438kB
for md2000
Apr 15 23:10:12 array kernel: [  765.806457] 0: w=1 pa=18 pr=6 m=2
a=18 r=7 op1=0 op2=0
Apr 15 23:10:12 array kernel: [  765.806463] 5: w=2 pa=18 pr=6 m=2
a=18 r=7 op1=1 op2=0
Apr 15 23:10:12 array kernel: [  765.806468] 4: w=3 pa=18 pr=6 m=2
a=18 r=7 op1=0 op2=0
Apr 15 23:10:12 array kernel: [  765.806472] 3: w=4 pa=18 pr=6 m=2
a=18 r=7 op1=0 op2=0
Apr 15 23:10:12 array kernel: [  765.806477] 2: w=5 pa=18 pr=6 m=2
a=18 r=7 op1=0 op2=0
Apr 15 23:10:12 array kernel: [  765.806481] 1: w=6 pa=18 pr=6 m=2
a=18 r=7 op1=0 op2=0
Apr 15 23:10:12 array kernel: [  765.806485] raid5: raid level 6 set
md2000 active with 6 out of 7 devices, algorithm 18
Apr 15 23:10:12 array kernel: [  765.806490] RAID5 conf printout:
Apr 15 23:10:12 array kernel: [  765.806493]  --- rd:7 wd:6
Apr 15 23:10:12 array kernel: [  765.806496]  disk 0, o:1, dev:sdl
Apr 15 23:10:12 array kernel: [  765.806499]  disk 1, o:1, dev:sdm
Apr 15 23:10:12 array kernel: [  765.806502]  disk 2, o:1, dev:sdn
Apr 15 23:10:12 array kernel: [  765.806505]  disk 3, o:1, dev:sdo
Apr 15 23:10:12 array kernel: [  765.806508]  disk 4, o:1, dev:sdp
Apr 15 23:10:12 array kernel: [  765.806511]  disk 5, o:1, dev:sdq
Apr 15 23:10:12 array kernel: [  765.806513] ...ok start reshape
thread
Apr 15 23:10:12 array kernel: [  765.806595] md2000: detected capacity
change from 0 to 8001595195392
Apr 15 23:10:12 array kernel: [  765.806603] md: reshape of RAID array
md2000
Apr 15 23:10:12 array kernel: [  765.806610] md: minimum _guaranteed_
speed: 1000 KB/sec/disk.
Apr 15 23:10:12 array kernel: [  765.806615] md: using maximum
available idle IO bandwidth (but not more than 200000 KB/sec) for
reshape.
Apr 15 23:10:12 array kernel: [  765.806632] md: using 128k window,
over a total of 1953514452 blocks.
Apr 15 23:10:13 array kernel: [  766.600756]  md2000: unknown
partition table
Apr 15 23:10:20 array kernel: [  774.298298] compute_blocknr: map not
correct
Apr 15 23:10:20 array kernel: [  774.298306] compute_blocknr: map not
correct
Apr 15 23:10:20 array kernel: [  774.298311] compute_blocknr: map not
correct
Apr 15 23:10:20 array kernel: [  774.298315] compute_blocknr: map not
correct
Apr 15 23:10:20 array kernel: [  774.298322] compute_blocknr: map not
correct
Apr 15 23:10:20 array kernel: [  774.298326] compute_blocknr: map not
correct
Apr 15 23:10:20 array kernel: [  774.298329] compute_blocknr: map not
correct
Apr 15 23:10:20 array kernel: [  774.298332] compute_blocknr: map not
correct
Apr 15 23:10:20 array kernel: [  774.298336] compute_blocknr: map not
correct

Any commands relating to the array hang after this, and the system
needs a hard reset to recover.

I found some people's previous encounters with this error message,
back around 2004 with the kernel at that stage requiring LBD (large
block device) support to be explicitly enabled. This is now the
default in x86_64 systems for a long time so I'm thinking this reshape
is hitting another limit above the 2^30 mark. The strange thing is
I've grown larger RAID6 arrays (e.g. 13TB) made of smaller 1TB disks
before without an issue, on earlier kernels (e.g. 2.6.27) and mdadm
versions (e.g. 3.0.2). The root cause now seems to be related to the
larger 2TB disks being used; growing from 4 disks to 5 and then 5
disks to 6 plus adding a Q disk in there was fine.

Also I've tried adjusting the value of stripe_cache_size as mentioned
in another person's similar issue on this list however the reshape
doesn't budge. Am I correct in expecting the reshape to automatically
continue as soon as this value is modified ?

I'm open to try any commands, patches, debugs etc that may get the
reshape moving again. This is one of several arrays in a ~20TB LVM
volume group; all the data is inaccessible until I can get this
resolved !

Thanks in advance everyone.
