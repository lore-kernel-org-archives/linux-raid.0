From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: What the heck happened to my array? (No apparent data loss).
Date: Sun, 03 Apr 2011 21:32:20 +0800
Message-ID: <4D9876E4.6080501@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2.6.38.2
x86_64
10 x 1TB SATA drives in a single RAID-6

Here is the chain of events.

Saturday morning I started a reshape on a 10 element RAID-6. Simply 
changing the Chunk size from 512k to 64k. This was going to take about 
4.5 days according to the initial estimates.

I then went away for the weekend and came home to a wedged array.
Here is the chain of events that caused it.

This occurred about 1 minute after my scheduled morning SMART long (it 
is Sunday after all) began.

Apr  3 03:19:08 srv kernel: [288180.455339] sd 0:0:12:0: [sdd] Unhandled 
error code
Apr  3 03:19:08 srv kernel: [288180.455359] sd 0:0:12:0: [sdd]  Result: 
hostbyte=0x04 driverbyte=0x00
Apr  3 03:19:08 srv kernel: [288180.455377] sd 0:0:12:0: [sdd] CDB: 
cdb[0]=0x2a: 2a 00 00 00 00 08 00 00 02 00
Apr  3 03:19:08 srv kernel: [288180.455415] end_request: I/O error, dev 
sdd, sector 8
Apr  3 03:19:08 srv kernel: [288180.455449] end_request: I/O error, dev 
sdd, sector 8
Apr  3 03:19:08 srv kernel: [288180.455462] md: super_written gets 
error=-5, uptodate=0
Apr  3 03:19:08 srv kernel: [288180.455477] md/raid:md0: Disk failure on 
sdd, disabling device.
Apr  3 03:19:08 srv kernel: [288180.455480] md/raid:md0: Operation 
continuing on 9 devices.
Apr  3 03:19:08 srv kernel: [288180.472914] md: md0: reshape done.
Apr  3 03:19:08 srv kernel: [288180.472983] md: delaying data-check of 
md5 until md3 has finished (they share one or more physical units)
Apr  3 03:19:08 srv kernel: [288180.473002] md: delaying data-check of 
md4 until md6 has finished (they share one or more physical units)
Apr  3 03:19:08 srv kernel: [288180.473030] md: delaying data-check of 
md6 until md5 has finished (they share one or more physical units)
Apr  3 03:19:08 srv kernel: [288180.473047] md: delaying data-check of 
md3 until md1 has finished (they share one or more physical units)
Apr  3 03:19:08 srv kernel: [288180.551450] md: reshape of RAID array md0
Apr  3 03:19:08 srv kernel: [288180.551468] md: minimum _guaranteed_ 
speed: 200000 KB/sec/disk.
Apr  3 03:19:08 srv kernel: [288180.551483] md: using maximum available 
idle IO bandwidth (but not more than 200000 KB/sec) for reshape.
Apr  3 03:19:08 srv kernel: [288180.551514] md: using 128k window, over 
a total of 976759808 blocks.
Apr  3 03:19:08 srv kernel: [288180.620089] sd 0:0:12:0: [sdd] 
Synchronizing SCSI cache
Apr  3 03:19:08 srv mdadm[4803]: RebuildFinished event detected on md 
device /dev/md0
Apr  3 03:19:08 srv mdadm[4803]: Fail event detected on md device 
/dev/md0, component device /dev/sdd
Apr  3 03:19:08 srv mdadm[4803]: RebuildStarted event detected on md 
device /dev/md0
Apr  3 03:19:10 srv kernel: [288182.614918] scsi 0:0:12:0: Direct-Access 
     ATA      MAXTOR STM310003 MX1A PQ: 0 ANSI: 5
Apr  3 03:19:10 srv kernel: [288182.615312] sd 0:0:12:0: Attached scsi 
generic sg3 type 0
Apr  3 03:19:10 srv kernel: [288182.618262] sd 0:0:12:0: [sdq] 
1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
Apr  3 03:19:10 srv kernel: [288182.736998] sd 0:0:12:0: [sdq] Write 
Protect is off
Apr  3 03:19:10 srv kernel: [288182.737019] sd 0:0:12:0: [sdq] Mode 
Sense: 73 00 00 08
Apr  3 03:19:10 srv kernel: [288182.740521] sd 0:0:12:0: [sdq] Write 
cache: enabled, read cache: enabled, doesn't support DPO or FUA
Apr  3 03:19:10 srv kernel: [288182.848999]  sdq: unknown partition table
Apr  3 03:19:10 srv ata_id[28453]: HDIO_GET_IDENTITY failed for '/dev/sdq'
Apr  3 03:19:10 srv kernel: [288182.970091] sd 0:0:12:0: [sdq] Attached 
SCSI disk
Apr  3 03:20:01 srv /USR/SBIN/CRON[28624]: (brad) CMD ([ -z 
"`/usr/bin/pgrep -u brad collect`" ] && /usr/bin/screen -X -S brad-bot 
screen /home/brad/bin/collect-thermostat)
Apr  3 03:20:01 srv /USR/SBIN/CRON[28625]: (root) CMD ([ -z 
`/usr/bin/pgrep -u root keepalive` ] && /home/brad/bin/launch-keepalive)
Apr  3 03:20:01 srv /USR/SBIN/CRON[28626]: (brad) CMD ([ -z "`screen 
-list | grep brad-bot`" ] && /home/brad/bin/botstart)
Apr  3 03:20:01 srv /USR/SBIN/CRON[28628]: (root) CMD (if [ -x 
/usr/bin/mrtg ] && [ -r /etc/mrtg.cfg ]; then mkdir -p /var/log/mrtg ; 
env LANG=C /usr/bin/mrtg /etc/mrtg.cfg 2>&1 | tee -a 
/var/log/mrtg/mrtg.log ; fi)
Apr  3 03:20:01 srv /USR/SBIN/CRON[28627]: (brad) CMD 
(/home/brad/rrd/rrd-create-graphs)
Apr  3 03:20:01 srv /USR/SBIN/CRON[28590]: (CRON) error (grandchild 
#28625 failed with exit status 1)
Apr  3 03:20:01 srv /USR/SBIN/CRON[28589]: (CRON) error (grandchild 
#28626 failed with exit status 1)
Apr  3 03:20:01 srv /USR/SBIN/CRON[28587]: (CRON) error (grandchild 
#28624 failed with exit status 1)
Apr  3 03:22:10 srv kernel: [288363.070094] INFO: task jbd2/md0-8:2647 
blocked for more than 120 seconds.
Apr  3 03:22:10 srv kernel: [288363.070114] "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Apr  3 03:22:10 srv kernel: [288363.070132] jbd2/md0-8      D 
ffff88041aa52948     0  2647      2 0x00000000
Apr  3 03:22:10 srv kernel: [288363.070154]  ffff88041aa526f0 
0000000000000046 0000000000000000 ffff8804196769b0
Apr  3 03:22:10 srv kernel: [288363.070178]  0000000000011180 
ffff88041bdc5fd8 0000000000004000 0000000000011180
Apr  3 03:22:10 srv kernel: [288363.070201]  ffff88041bdc4010 
ffff88041aa52950 ffff88041bdc5fd8 ffff88041aa52948
Apr  3 03:22:10 srv kernel: [288363.070224] Call Trace:
Apr  3 03:22:10 srv kernel: [288363.070246]  [<ffffffff8104e4c6>] ? 
queue_work_on+0x16/0x20
Apr  3 03:22:10 srv kernel: [288363.070266]  [<ffffffff812e6bfd>] ? 
md_write_start+0xad/0x190
Apr  3 03:22:10 srv kernel: [288363.070283]  [<ffffffff81052b90>] ? 
autoremove_wake_function+0x0/0x30
Apr  3 03:22:10 srv kernel: [288363.070299]  [<ffffffff812e16f5>] ? 
make_request+0x35/0x600
Apr  3 03:22:10 srv kernel: [288363.070317]  [<ffffffff8108463b>] ? 
__alloc_pages_nodemask+0x10b/0x810
Apr  3 03:22:10 srv kernel: [288363.070335]  [<ffffffff81142042>] ? 
T.1015+0x32/0x90
Apr  3 03:22:10 srv kernel: [288363.070350]  [<ffffffff812e6a24>] ? 
md_make_request+0xd4/0x200
Apr  3 03:22:10 srv kernel: [288363.070366]  [<ffffffff81142218>] ? 
ext4_map_blocks+0x178/0x210
Apr  3 03:22:10 srv kernel: [288363.070382]  [<ffffffff811b6e84>] ? 
generic_make_request+0x144/0x2f0
Apr  3 03:22:10 srv kernel: [288363.070397]  [<ffffffff8116e89d>] ? 
jbd2_journal_file_buffer+0x3d/0x70
Apr  3 03:22:10 srv kernel: [288363.070413]  [<ffffffff811b708c>] ? 
submit_bio+0x5c/0xd0
Apr  3 03:22:10 srv kernel: [288363.070430]  [<ffffffff810e61d5>] ? 
submit_bh+0xe5/0x120
Apr  3 03:22:10 srv kernel: [288363.070445]  [<ffffffff811709b1>] ? 
jbd2_journal_commit_transaction+0x441/0x1180
Apr  3 03:22:10 srv kernel: [288363.070466]  [<ffffffff81044893>] ? 
lock_timer_base+0x33/0x70
Apr  3 03:22:10 srv kernel: [288363.070480]  [<ffffffff81052b90>] ? 
autoremove_wake_function+0x0/0x30
Apr  3 03:22:10 srv kernel: [288363.070498]  [<ffffffff81174871>] ? 
kjournald2+0xb1/0x1e0
Apr  3 03:22:10 srv kernel: [288363.070511]  [<ffffffff81052b90>] ? 
autoremove_wake_function+0x0/0x30
Apr  3 03:22:10 srv kernel: [288363.070527]  [<ffffffff811747c0>] ? 
kjournald2+0x0/0x1e0
Apr  3 03:22:10 srv kernel: [288363.070544]  [<ffffffff811747c0>] ? 
kjournald2+0x0/0x1e0
Apr  3 03:22:10 srv kernel: [288363.070557]  [<ffffffff81052716>] ? 
kthread+0x96/0xa0
Apr  3 03:22:10 srv kernel: [288363.070573]  [<ffffffff81003154>] ? 
kernel_thread_helper+0x4/0x10
Apr  3 03:22:10 srv kernel: [288363.070588]  [<ffffffff81052680>] ? 
kthread+0x0/0xa0
Apr  3 03:22:10 srv kernel: [288363.070602]  [<ffffffff81003150>] ? 
kernel_thread_helper+0x0/0x10

So apparently sdd suffered an unknown failure (it happens) and the array 
kicked it out (as it should). But 120 seconds later all tasks accessing 
that array trigger their 120 second hangcheck warning and are all suck 
in the D state.

At the time the array was 12.1% of the way through a reshape. I had to 
reboot the machine to get it back up and it's now continuing the reshape 
on 9 drives.

brad@srv:~$ cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
md0 : active raid6 sdc[0] sdh[9] sda[8] sde[7] sdg[5] sdb[4] sdf[3] 
sdm[2] sdl[1]
       7814078464 blocks super 1.2 level 6, 512k chunk, algorithm 2 
[10/9] [UUUUUU_UUU]
       [===>.................]  reshape = 16.5% (162091008/976759808) 
finish=5778.6min speed=2349K/sec



To make matters more confusing the other arrays on the machine were in 
the middle of their "Debians first Sunday of every month" "check" scrub.

I have the full syslog and can probably procure any other information 
that might be useful. I don't think I've lost any data, the machine 
continued reshaping and we're all moving along nicely. I just wanted to 
report it and offer assistance in diagnosing it should that be requested.

Regards,
Brad
