From: Brett King <king.br@gmail.com>
Subject: RAID6 reshape stalled 6 -> 7 disks, mdadm 3.1.2 / kernel 2.6.31
Date: Wed, 14 Apr 2010 21:46:14 +1000
Message-ID: <y2x8cf253381004140446s2cb82a5ao98b5817cad00009b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,
I added another 2TB disk to grow a 6-disk RAID6 array as I have always
done but this time it has failed to complete the reshape .. it always
stalls at a particular block number and nothing I have tried can get
it moving again.

array:~ # mdadm -V
mdadm - v3.1.2 - 10th March 2010
array:~ # uname -a
Linux array 2.6.31.12-0.2-default #1 SMP 2010-03-16 21:25:39 +0100
x86_64 x86_64 x86_64 GNU/Linux
array:~ # cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md2000 : active raid6 sdl[0] sda[6] sdq[5] sdp[4] sdo[3] sdn[2] sdm[1]
      7814057808 blocks super 1.1 level 6, 4k chunk, algorithm 18
[7/7] [UUUUUUU]
      [=================>...]  reshape = 87.9% (1717986916/1953514452)
finish=224763.6min speed=17K/sec

unused devices: <none>
array:~ # cat /sys/block/md2000/md/sync_speed_max
200000 (system)
array:~ # cat /sys/block/md2000/md/sync_speed_min
1000 (system)
array:~ # cat /sys/block/md2000/md/stripe_cache_size
8192
array:~ #

I've tried several other values for stripe_cache_size: 1024, 16384 &
32768 without any effect.
The host needs a hard reset after assembling the array as any
subsequent 'mdadm -S' or 'reboot' commands hang.
This is one of several arrays in an LVM volume group.

Syslog messages:

Apr 14 17:47:51 array kernel: [  630.433884] md: md2000 stopped.
Apr 14 17:47:51 array kernel: [  630.435937] md: bind<sdm>
Apr 14 17:47:51 array kernel: [  630.436132] md: bind<sdn>
Apr 14 17:47:51 array kernel: [  630.436343] md: bind<sdo>
Apr 14 17:47:51 array kernel: [  630.436444] md: bind<sdp>
Apr 14 17:47:51 array kernel: [  630.436550] md: bind<sdq>
Apr 14 17:47:51 array kernel: [  630.436648] md: bind<sda>
Apr 14 17:47:51 array kernel: [  630.436802] md: bind<sdl>
Apr 14 17:47:51 array kernel: [  630.442766] xor: automatically using
best checksumming function: generic_sse
Apr 14 17:47:51 array kernel: [  630.462854]    generic_sse:  6780.000
MB/sec
Apr 14 17:47:51 array kernel: [  630.462859] xor: using function:
generic_sse (6780.000 MB/sec)
Apr 14 17:47:51 array kernel: [  630.465450] async_tx: api initialized
(async)
Apr 14 17:47:51 array kernel: [  630.542715] raid6: int64x1   1453
MB/s
Apr 14 17:47:51 array kernel: [  630.610590] raid6: int64x2   1897
MB/s
Apr 14 17:47:51 array kernel: [  630.678522] raid6: int64x4   1274
MB/s
Apr 14 17:47:51 array kernel: [  630.746337] raid6: int64x8   1335
MB/s
Apr 14 17:47:51 array kernel: [  630.814238] raid6: sse2x1    3963
MB/s
Apr 14 17:47:52 array kernel: [  630.882120] raid6: sse2x2    4655
MB/s
Apr 14 17:47:52 array kernel: [  630.949976] raid6: sse2x4    5259
MB/s
Apr 14 17:47:52 array kernel: [  630.949982] raid6: using algorithm
sse2x4 (5259 MB/s)
Apr 14 17:47:52 array kernel: [  630.962615] md: raid6 personality
registered for level 6
Apr 14 17:47:52 array kernel: [  630.962622] md: raid5 personality
registered for level 5
Apr 14 17:47:52 array kernel: [  630.962627] md: raid4 personality
registered for level 4
Apr 14 17:47:52 array kernel: [  630.968504] raid5: md2000 is not
clean -- starting background reconstruction
Apr 14 17:47:52 array kernel: [  630.968512] raid5: reshape will
continue
Apr 14 17:47:52 array kernel: [  630.968521] raid5: device sdl
operational as raid disk 0
Apr 14 17:47:52 array kernel: [  630.968526] raid5: device sda
operational as raid disk 6
Apr 14 17:47:52 array kernel: [  630.968530] raid5: device sdq
operational as raid disk 5
Apr 14 17:47:52 array kernel: [  630.968535] raid5: device sdp
operational as raid disk 4
Apr 14 17:47:52 array kernel: [  630.968540] raid5: device sdo
operational as raid disk 3
Apr 14 17:47:52 array kernel: [  630.968545] raid5: device sdn
operational as raid disk 2
Apr 14 17:47:52 array kernel: [  630.968549] raid5: device sdm
operational as raid disk 1
Apr 14 17:47:52 array kernel: [  630.970550] raid5: allocated 7436kB
for md2000
Apr 14 17:47:52 array kernel: [  630.970724] raid5: raid level 6 set
md2000 active with 7 out of 7 devices, algorithm 18
Apr 14 17:47:52 array kernel: [  630.970731] RAID5 conf printout:
Apr 14 17:47:52 array kernel: [  630.970734]  --- rd:7 wd:7
Apr 14 17:47:52 array kernel: [  630.970738]  disk 0, o:1, dev:sdl
Apr 14 17:47:52 array kernel: [  630.970742]  disk 1, o:1, dev:sdm
Apr 14 17:47:52 array kernel: [  630.970745]  disk 2, o:1, dev:sdn
Apr 14 17:47:52 array kernel: [  630.970749]  disk 3, o:1, dev:sdo
Apr 14 17:47:52 array kernel: [  630.970753]  disk 4, o:1, dev:sdp
Apr 14 17:47:52 array kernel: [  630.970757]  disk 5, o:1, dev:sdq
Apr 14 17:47:52 array kernel: [  630.970761]  disk 6, o:1, dev:sda
Apr 14 17:47:52 array kernel: [  630.970764] ...ok start reshape
thread
Apr 14 17:47:52 array kernel: [  630.970981] md2000: detected capacity
change from 0 to 8001595195392
Apr 14 17:47:52 array kernel: [  630.971035] md: reshape of RAID array
md2000
Apr 14 17:47:52 array kernel: [  630.971046] md: minimum _guaranteed_
speed: 1000 KB/sec/disk.
Apr 14 17:47:52 array kernel: [  630.971055] md: using maximum
available idle IO bandwidth (but not more than 200000 KB/sec) for
reshape.
Apr 14 17:47:52 array kernel: [  630.971093] md: using 128k window,
over a total of 1953514452 blocks.
Apr 14 17:47:52 array kernel: [  631.740804]  md2000: unknown
partition table
Apr 14 17:48:00 array kernel: [  639.084194] compute_blocknr: map not
correct
Apr 14 17:48:00 array kernel: [  639.084206] compute_blocknr: map not
correct

<output suppressed>

Apr 14 17:48:00 array kernel: [  639.095681] compute_blocknr: map not
correct
Apr 14 17:50:06 array kernel: [  765.171809] INFO: task
md2000_reshape:3216 blocked for more than 120 seconds.
Apr 14 17:50:06 array kernel: [  765.171817] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Apr 14 17:50:06 array kernel: [  765.171824] md2000_reshap D
0000000000000000     0  3216      2 0x00000000
Apr 14 17:50:06 array kernel: [  765.171832]  ffff88046c963ac0
0000000000000046 ffff88046c963a40 0000000000013a00
Apr 14 17:50:06 array kernel: [  765.171841]  ffff88046d5ac8a8
0000000000013a00 0000000000013a00 0000000000013a00
Apr 14 17:50:06 array kernel: [  765.171849]  0000000000013a00
ffff88046d5ac8a8 0000000000013a00 0000000000013a00
Apr 14 17:50:06 array kernel: [  765.171857] Call Trace:
Apr 14 17:50:06 array kernel: [  765.171874]  [<ffffffffa01490a0>]
get_active_stripe+0x2b0/0x3d0 [raid456]
Apr 14 17:50:06 array kernel: [  765.171894]  [<ffffffffa014b570>]
reshape_request+0x350/0xa10 [raid456]
Apr 14 17:50:06 array kernel: [  765.171910]  [<ffffffffa014bf82>]
sync_request+0x352/0x3d0 [raid456]
Apr 14 17:50:06 array kernel: [  765.171925]  [<ffffffff81416a68>]
md_do_sync+0x668/0xc10
Apr 14 17:50:06 array kernel: [  765.171934]  [<ffffffff81417894>]
md_thread+0x54/0x150
Apr 14 17:50:06 array kernel: [  765.171944]  [<ffffffff8108ea66>]
kthread+0xb6/0xc0
Apr 14 17:50:06 array kernel: [  765.171953]  [<ffffffff8100d70a>]
child_rip+0xa/0x20

<repeats every 120 seconds>

Any ideas ? I've also had the same problem on 2.6.34-rc3 :(

Thanks in advance.
Brett.
