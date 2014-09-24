From: Pavel Hofman <pavel.hofman@ivitera.com>
Subject: Re: More 'D' state processes
Date: Wed, 24 Sep 2014 13:14:27 +0200
Message-ID: <5422A793.7090502@ivitera.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> On Mon, 06 Jan 2014 17:00:35 +0100 hans@xxxxxxxxxxxxxx wrote:
>>  
>> 
>> Hi Neil, 
>> 
>> the output of 'uname -r' is: 3.2.0-4-amd64. A standard Debian Wheezy.
>> 
>> I rebooted the system in the meantime. The re-sync started anew but
>> finished otherwise without flaws. 
> 
> I guess there must be some other bug then. I still expect that it is related
> to md_flush_request().  Probably related to the fact that you have an md
> device on top of other md devices....
> 
> I had a quick look and cannot find the cause of the problem.  Maybe it will
> have to wait until someone else hit it :-(
> 
> Thanks for the report,
> NeilBrown

Hi Neil,

IMO I have been hitting the same bug.

I have a layered setup with several MDs on top of each other (backup
server with offline copies).

Sometimes, when mdadm is checking/resyncing, my XFS filesystem gets
stuck. Recovery of a small partition (raid1, md1, ext3) finishes, while
recovery of large (raid1, md6) gets stuck. XFS is on md7 composed of
raid1 - md5 + md6.

Kernel 3.2 was OK, kernels 3.14, 3.16 produce the lockup.


Please let me know what other diagnostics I have to run.

Thanks a lot for your kind help.

Pavel.


dmesg
----------
[1295936.011721] md: recovery of RAID array md6
[1295936.011730] md: minimum _guaranteed_  speed: 100000 KB/sec/disk.
[1295936.011733] md: using maximum available idle IO bandwidth (but not
more than 200000 KB/sec) for recovery.
[1295936.011738] md: using 128k window, over a total of 4356343672k.
[1295936.033832] md: export_rdev(sde2)
[1295936.114241] md: bind<sde2>
[1295936.188266] md1: Warning: Device sde2 is misaligned
[1295936.188273] RAID1 conf printout:
[1295936.188275]  --- wd:4 rd:6
[1295936.188278]  disk 0, wo:0, o:1, dev:sdc1
[1295936.188280]  disk 1, wo:0, o:1, dev:sdd1
[1295936.188283]  disk 2, wo:0, o:1, dev:sdb2
[1295936.188285]  disk 3, wo:0, o:1, dev:sda2
[1295936.188287]  disk 4, wo:1, o:1, dev:sde2
[1296065.585142] md: recovery of RAID array md1
[1296065.585145] md: minimum _guaranteed_  speed: 100000 KB/sec/disk.
[1296065.585147] md: using maximum available idle IO bandwidth (but not
more than 200000 KB/sec) for recovery.
[1296065.585152] md: using 128k window, over a total of 10739328k.
[1296196.841709] md: md1: recovery done.
[1296197.003548] RAID1 conf printout:
[1296197.003558]  --- wd:6 rd:6
[1296197.003565]  disk 0, wo:0, o:1, dev:sdc1
[1296197.003570]  disk 1, wo:0, o:1, dev:sdd1
[1296197.003574]  disk 2, wo:0, o:1, dev:sdb2
[1296197.003578]  disk 3, wo:0, o:1, dev:sda2
[1296197.003582]  disk 4, wo:0, o:1, dev:sde2
[1296197.003586]  disk 5, wo:0, o:1, dev:sdf1
[1296360.756072] INFO: task BackupPC_tarExt:17592 blocked for more than
120 seconds.
[1296360.756146]       Tainted: G          I   3.16.0-tecmintkernel #2
[1296360.756197] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[1296360.756261] BackupPC_tarExt D 0000000000000000     0 17592  17581
0x00000000
[1296360.756270]  ffff8800b9680b00 0000000000000082 0000000000014640
ffff88006cb77fd8
[1296360.756277]  0000000000014640 ffff8800b9680b00 ffff880039476cf0
ffff88006cb77940
[1296360.756284]  7fffffffffffffff ffff8800b9680b00 0000000000000000
ffff8800ba0ec4c0
[1296360.756290] Call Trace:
[1296360.756307]  [<ffffffff814de639>] ? schedule_timeout+0x1f9/0x270
[1296360.756316]  [<ffffffff814e153b>] ? __down+0x6b/0xa0
[1296360.756362]  [<ffffffffa0420b25>] ? _xfs_buf_find+0x135/0x280 [xfs]
[1296360.756371]  [<ffffffff810a767c>] ? down+0x3c/0x50
[1296360.756391]  [<ffffffffa042095a>] ? xfs_buf_lock+0x2a/0xc0 [xfs]
[1296360.756411]  [<ffffffffa0420b25>] ? _xfs_buf_find+0x135/0x280 [xfs]
[1296360.756430]  [<ffffffffa0420c8e>] ? xfs_buf_get_map+0x1e/0x1a0 [xfs]
[1296360.756451]  [<ffffffffa042168f>] ? xfs_buf_read_map+0x1f/0x130 [xfs]
[1296360.756484]  [<ffffffffa047f03b>] ?
xfs_trans_read_buf_map+0x20b/0x480 [xfs]
[1296360.756510]  [<ffffffffa046ddb9>] ? xfs_imap_to_bp+0x59/0xe0 [xfs]
[1296360.756537]  [<ffffffffa046e27b>] ? xfs_iread+0x6b/0x390 [xfs]
[1296360.756558]  [<ffffffffa042907b>] ? xfs_iget+0x24b/0x6b0 [xfs]
[1296360.756586]  [<ffffffffa046849e>] ? xfs_lookup+0xce/0xf0 [xfs]
[1296360.756607]  [<ffffffffa042e0de>] ? xfs_vn_lookup+0x4e/0xa0 [xfs]
[1296360.756616]  [<ffffffff8119f10b>] ? lookup_dcache+0x7b/0xb0
[1296360.756622]  [<ffffffff8119e7e4>] ? lookup_real+0x14/0x60
[1296360.756628]  [<ffffffff8119f16a>] ? __lookup_hash+0x2a/0x40
[1296360.756635]  [<ffffffff811a0b3b>] ? link_path_walk+0x46b/0xeb0
[1296360.756643]  [<ffffffff811a15d2>] ? path_lookupat+0x52/0xd60
[1296360.756667]  [<ffffffffa0443779>] ?
xfs_bmap_search_extents+0x59/0xe0 [xfs]
[1296360.756675]  [<ffffffff811a2300>] ? filename_lookup+0x20/0xc0
[1296360.756682]  [<ffffffff811a65af>] ? user_path_at_empty+0x4f/0xa0
[1296360.756688]  [<ffffffff8119a168>] ? vfs_fstatat+0x48/0xa0
[1296360.756695]  [<ffffffff8119a60a>] ? SYSC_newstat+0x1a/0x40
[1296360.756703]  [<ffffffff81195a9c>] ? vfs_read+0x11c/0x170
[1296360.756709]  [<ffffffff8119660d>] ? SyS_read+0x3d/0xa0
[1296360.756715]  [<ffffffff814e2f29>] ? system_call_fastpath+0x16/0x1b
[1296360.756724] INFO: task BackupPC_link:22685 blocked for more than
120 seconds.
[1296360.756784]       Tainted: G          I   3.16.0-tecmintkernel #2
[1296360.756834] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[1296360.756896] BackupPC_link   D 0000000000000000     0 22685   1718
0x00000000
[1296360.756902]  ffff8800b87792f0 0000000000000082 0000000000014640
ffff88000041bfd8
[1296360.756909]  0000000000014640 ffff8800b87792f0 ffff880016d569f0
ffff88000041b9f0
[1296360.756914]  7fffffffffffffff ffff8800b87792f0 0000000000000000
ffff8800bafdd880
[1296360.756921] Call Trace:
[1296360.756929]  [<ffffffff814de639>] ? schedule_timeout+0x1f9/0x270
[1296360.756952]  [<ffffffffa0089adb>] ? nv_swncq_qc_issue+0x5b/0x90
[sata_nv]
[1296360.756960]  [<ffffffff8101b695>] ? sched_clock+0x5/0x10
[1296360.756967]  [<ffffffff814e153b>] ? __down+0x6b/0xa0
[1296360.756974]  [<ffffffff81094e00>] ?
__clear_sched_clock_stable+0x20/0x20
[1296360.756996]  [<ffffffffa0420b25>] ? _xfs_buf_find+0x135/0x280 [xfs]
[1296360.757003]  [<ffffffff810a767c>] ? down+0x3c/0x50
[1296360.757021]  [<ffffffffa042095a>] ? xfs_buf_lock+0x2a/0xc0 [xfs]
[1296360.757040]  [<ffffffffa0420b25>] ? _xfs_buf_find+0x135/0x280 [xfs]
[1296360.757060]  [<ffffffffa0420c8e>] ? xfs_buf_get_map+0x1e/0x1a0 [xfs]
[1296360.757079]  [<ffffffffa042168f>] ? xfs_buf_read_map+0x1f/0x130 [xfs]
[1296360.757105]  [<ffffffffa047f03b>] ?
xfs_trans_read_buf_map+0x20b/0x480 [xfs]
[1296360.757131]  [<ffffffffa046ddb9>] ? xfs_imap_to_bp+0x59/0xe0 [xfs]
[1296360.757156]  [<ffffffffa046e27b>] ? xfs_iread+0x6b/0x390 [xfs]
[1296360.757177]  [<ffffffffa042907b>] ? xfs_iget+0x24b/0x6b0 [xfs]
[1296360.757204]  [<ffffffffa046849e>] ? xfs_lookup+0xce/0xf0 [xfs]
[1296360.757225]  [<ffffffffa042e0de>] ? xfs_vn_lookup+0x4e/0xa0 [xfs]
[1296360.757232]  [<ffffffff8119f10b>] ? lookup_dcache+0x7b/0xb0
[1296360.757239]  [<ffffffff8119e7e4>] ? lookup_real+0x14/0x60
[1296360.757245]  [<ffffffff8119f16a>] ? __lookup_hash+0x2a/0x40
[1296360.757251]  [<ffffffff811a1e83>] ? path_lookupat+0x903/0xd60
[1296360.757276]  [<ffffffffa0437598>] ? xfs_trans_free_items+0x78/0xa0
[xfs]
[1296360.757283]  [<ffffffff811a2300>] ? filename_lookup+0x20/0xc0



Processes in D state:
----------------------

   29 ?        D     72:29 [kswapd0]
 1815 ?        D     36:22 [xfsaild/md7]
17592 ?        D     33:37 /usr/bin/perl
/usr/share/backuppc/bin/BackupPC_tarExtract orion-1000 / 3
21086 ?        D      3:58 /usr/bin/rsync --server --sender
--numeric-ids --perms --owner --group -D --links --hard-links --times
--block-size=2048 --recursive -D --one-file-system .
/mnt/raid/local-copies/nemeton/
22341 ?        D      0:00 [md6_resync]
22685 ?        D      0:00 /usr/bin/perl
/usr/share/backuppc/bin/BackupPC_link hestia



orfeus:~# cat /proc/mdstat
---------------------------
Personalities : [raid1] [raid0]
md9 : active raid0 sde4[0] sdf3[1]
      4356343808 blocks super 1.0 512k chunks

md7 : active raid1 md5[2] md6[1]
      4356343536 blocks super 1.0 [2/2] [UU]

md6 : active raid1 md9[2] md4[0]
      4356343672 blocks super 1.0 [2/1] [U_]
      [>....................]  recovery =  0.0% (6208/4356343672)
finish=200447042.5min speed=0K/sec
      bitmap: 9/9 pages [36KB], 262144KB chunk

md5 : active raid1 md3[0]
      4356343616 blocks super 1.0 [2/1] [U_]
      bitmap: 33/33 pages [132KB], 65536KB chunk

md4 : active raid0 sdb4[0] sdd3[1]
      4356343808 blocks super 1.0 512k chunks

md3 : active raid0 sda4[0] sdc3[1]
      4356343808 blocks super 1.0 512k chunks

md2 : active raid1 sdc2[0] sda3[3] sdb3[2] sdd2[1]
      8787456 blocks [4/4] [UUUU]

md1 : active raid1 sdf1[5] sde2[4] sdc1[0] sda2[3] sdb2[2] sdd1[1]
      10739328 blocks [6/6] [UUUUUU]








> 
> 
>> 
>> Regards, Hans 
>> 
>> Am 05.01.2014 23:00, schrieb NeilBrown: 
>> 
>> > On Sun, 22 Dec 2013 17:43:43 +0100 Hans Kraus <hans@xxxxxxxxxxxxxx> wrote:
>> > 
>> >> Hi Neil,
>> > 
>> > Hi Hans,
>> > sorry for the delay - Christmas/New Year vacation...
>> > [40800.777037] xfsaild/dm-0 D ffff88003754c300 0 20798 2 0x00000000 [40800.777042] ffff88003754c300 0000000000000046 0000000000000000 ffff88005d7c51a0 [40800.777047] 0000000000013780 ffff88001b01ffd8 ffff88001b01ffd8 ffff88003754c300 [40800.777052] ffff880071fede00 ffffffff81070fc1 0000000000000046 ffff88003734a400 [40800.777057] Call Trace: [40800.777061] [<ffffffff81070fc1>] ? arch_local_irq_save+0x11/0x17 [40800.777071] [<ffffffffa0170466>] ? md_flush_request+0x96/0x111 [md_mod] [40800.777076] [<ffffffff8103f6c4>] ? try_to_wake_up+0x197/0x197 [40800.777082] [<ffffffffa0f11711>] ? make_request+0x25/0x37a [raid456] [40800.777091] [<ffffffffa0185873>] ?
>> 
>> This looks like the most likely root of the problem - something wrong in
>> md_flush_request.
>> 
>> There was a bug here fixed in 2.6.37
>> 
>> commit a035fc3e2531703b539f23bec4ca7943cfc69349
>> Author: NeilBrown <neilb@xxxxxxx>
>> Date: Thu Dec 9 16:17:51 2010 +1100
>> 
>>  md: fix possible deadlock in handling flush requests.
>> 
>> You didn't say which kernel you were running. Could it be earlier than
>> 2.6.37???
>> 
>> NeilBrown
>> 
>>  

