From: andras@tantosonline.com
Subject: How to recover after md crash during =?UTF-8?Q?reshape=3F?=
Date: Mon, 19 Oct 2015 21:35:05 -0500
Message-ID: <04cdcd6bd69b3aa1f8f24465f8485c90@tantosonline.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear all,

I have a serious (to me) problem, and I'm seeking some pro advice in 
recovering a RAID6 volume after a crash at the beginning of a reshape. 
Thank you all in advance for any help!

The details:

I'm running Debian.
     uname -r says:
         kernel 3.2.0-4-amd64
     dmsg says:
         Linux version 3.2.0-4-amd64 (debian-kernel@lists.debian.org) 
(gcc version 4.6.3 (Debian 4.6.3-14) ) #1 SMP Debian 3.2.68-1+deb7u3
     mdadm -v says:
         mdadm - v3.2.5 - 18th May 2012

I used to have a RAID6 volume with 7 disks on it. I've recently bought 
another 3 new HDD-s and was trying to add them to the array.
I've put them in the machine (hot-plug), partitioned them then did:

     mdadm --add /dev/md1 /dev/sdh1 /dev/sdi1 /dev/sdj1

This worked fine, /proc/mdstat showed them as three spares. Then I did:

     mdadm --grow --raid-devices=10 /dev/md1

Yes, I was dumb enough to start the process without a backup option - 
(copy-paste error from https://raid.wiki.kernel.org/index.php/Growing).

This immediately (well, after 2 seconds) crashed the MD driver:

     Oct 17 17:30:27 bazsalikom kernel: [7869821.514718] sd 0:0:0:0: 
[sdj] Attached SCSI disk
     Oct 17 18:39:21 bazsalikom kernel: [7873955.418679]  sdh: sdh1
     Oct 17 18:39:37 bazsalikom kernel: [7873972.155084]  sdi: sdi1
     Oct 17 18:39:49 bazsalikom kernel: [7873983.916038]  sdj: sdj1
     Oct 17 18:40:33 bazsalikom kernel: [7874027.963430] md: bind<sdh1>
     Oct 17 18:40:34 bazsalikom kernel: [7874028.263656] md: bind<sdi1>
     Oct 17 18:40:34 bazsalikom kernel: [7874028.361112] md: bind<sdj1>
     Oct 17 18:59:48 bazsalikom kernel: [7875182.667815] md: reshape of 
RAID array md1
     Oct 17 18:59:48 bazsalikom kernel: [7875182.667818] md: minimum 
_guaranteed_  speed: 1000 KB/sec/disk.
     Oct 17 18:59:48 bazsalikom kernel: [7875182.667821] md: using 
maximum available idle IO bandwidth (but not more than 200000 KB/sec) 
for reshape.
     Oct 17 18:59:48 bazsalikom kernel: [7875182.667831] md: using 128k 
window, over a total of 1465135936k.
--> Oct 17 18:59:50 bazsalikom kernel: [7875184.326245] md: md_do_sync() 
got signal ... exiting
     Oct 17 19:02:46 bazsalikom kernel: [7875360.928059] md1_raid6       
D ffff88021fc12780     0   282      2 0x00000000
     Oct 17 19:02:46 bazsalikom kernel: [7875360.928066]  
ffff880213fd9140 0000000000000046 ffff8800aa80c140 ffff880201fe08c0
     Oct 17 19:02:46 bazsalikom kernel: [7875360.928073]  
0000000000012780 ffff880211845fd8 ffff880211845fd8 ffff880213fd9140
     Oct 17 19:02:46 bazsalikom kernel: [7875360.928079]  
ffff8800a77d8a40 ffffffff81071331 0000000000000046 ffff8802135a0c00
     Oct 17 19:02:46 bazsalikom kernel: [7875360.928085] Call Trace:
     Oct 17 19:02:46 bazsalikom kernel: [7875360.928095]  
[<ffffffff81071331>] ? arch_local_irq_save+0x11/0x17
     Oct 17 19:02:46 bazsalikom kernel: [7875360.928111]  
[<ffffffffa0124c6c>] ? check_reshape+0x27b/0x51a [raid456]
     Oct 17 19:02:46 bazsalikom kernel: [7875360.928128]  
[<ffffffffa013ade4>] ? scsi_request_fn+0x443/0x51e [scsi_mod]
     Oct 17 19:02:46 bazsalikom kernel: [7875360.928134]  
[<ffffffff8103f6e2>] ? try_to_wake_up+0x197/0x197
     Oct 17 19:02:46 bazsalikom kernel: [7875360.928144]  
[<ffffffffa00ef3b8>] ? md_check_recovery+0x2a5/0x514 [md_mod]
     Oct 17 19:02:46 bazsalikom kernel: [7875360.928151]  
[<ffffffffa01286c7>] ? raid5d+0x1c/0x483 [raid456]
     Oct 17 19:02:46 bazsalikom kernel: [7875360.928156]  
[<ffffffff81071331>] ? arch_local_irq_save+0x11/0x17
     Oct 17 19:02:46 bazsalikom kernel: [7875360.928160]  
[<ffffffff81071331>] ? arch_local_irq_save+0x11/0x17
     Oct 17 19:02:46 bazsalikom kernel: [7875360.928169]  
[<ffffffffa00e9256>] ? md_thread+0x114/0x132 [md_mod]
     Oct 17 19:02:46 bazsalikom kernel: [7875360.928174]  
[<ffffffff8105fdf3>] ? add_wait_queue+0x3c/0x3c
     Oct 17 19:02:46 bazsalikom kernel: [7875360.928183]  
[<ffffffffa00e9142>] ? md_rdev_init+0xea/0xea [md_mod]
     Oct 17 19:02:46 bazsalikom kernel: [7875360.928188]  
[<ffffffff8105f7a1>] ? kthread+0x76/0x7e
     Oct 17 19:02:46 bazsalikom kernel: [7875360.928194]  
[<ffffffff81357ff4>] ? kernel_thread_helper+0x4/0x10
     Oct 17 19:02:46 bazsalikom kernel: [7875360.928199]  
[<ffffffff8105f72b>] ? kthread_worker_fn+0x139/0x139
     Oct 17 19:02:46 bazsalikom kernel: [7875360.928204]  
[<ffffffff81357ff0>] ? gs_change+0x13/0x13
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928055] md1_raid6       
D ffff88021fc12780     0   282      2 0x00000000
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928062]  
ffff880213fd9140 0000000000000046 ffff8800aa80c140 ffff880201fe08c0
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928069]  
0000000000012780 ffff880211845fd8 ffff880211845fd8 ffff880213fd9140
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928075]  
ffff8800a77d8a40 ffffffff81071331 0000000000000046 ffff8802135a0c00
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928082] Call Trace:
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928091]  
[<ffffffff81071331>] ? arch_local_irq_save+0x11/0x17
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928108]  
[<ffffffffa0124c6c>] ? check_reshape+0x27b/0x51a [raid456]
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928124]  
[<ffffffffa013ade4>] ? scsi_request_fn+0x443/0x51e [scsi_mod]
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928130]  
[<ffffffff8103f6e2>] ? try_to_wake_up+0x197/0x197
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928141]  
[<ffffffffa00ef3b8>] ? md_check_recovery+0x2a5/0x514 [md_mod]
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928148]  
[<ffffffffa01286c7>] ? raid5d+0x1c/0x483 [raid456]
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928153]  
[<ffffffff81071331>] ? arch_local_irq_save+0x11/0x17
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928157]  
[<ffffffff81071331>] ? arch_local_irq_save+0x11/0x17
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928166]  
[<ffffffffa00e9256>] ? md_thread+0x114/0x132 [md_mod]
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928171]  
[<ffffffff8105fdf3>] ? add_wait_queue+0x3c/0x3c
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928180]  
[<ffffffffa00e9142>] ? md_rdev_init+0xea/0xea [md_mod]
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928185]  
[<ffffffff8105f7a1>] ? kthread+0x76/0x7e
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928191]  
[<ffffffff81357ff4>] ? kernel_thread_helper+0x4/0x10
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928196]  
[<ffffffff8105f72b>] ? kthread_worker_fn+0x139/0x139
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928200]  
[<ffffffff81357ff0>] ? gs_change+0x13/0x13
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928212] jbd2/md1-8      
D ffff88021fc92780     0  1731      2 0x00000000
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928218]  
ffff880213693180 0000000000000046 ffff880200000000 ffff880216d04180
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928224]  
0000000000012780 ffff880213df3fd8 ffff880213df3fd8 ffff880213693180
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928230]  
0000000000000000 00000001135a0d70 ffff8802135a0d60 ffff8802135a0d70
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928236] Call Trace:
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928243]  
[<ffffffffa0123804>] ? get_active_stripe+0x24c/0x505 [raid456]
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928248]  
[<ffffffff8103f6e2>] ? try_to_wake_up+0x197/0x197
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928255]  
[<ffffffffa01258c8>] ? make_request+0x1b4/0x37a [raid456]
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928260]  
[<ffffffff8105fdf3>] ? add_wait_queue+0x3c/0x3c
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928278]  
[<ffffffffa00e8d47>] ? md_make_request+0xee/0x1db [md_mod]
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928283]  
[<ffffffff8119a3ec>] ? generic_make_request+0x90/0xcf
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928287]  
[<ffffffff8119a4fe>] ? submit_bio+0xd3/0xf1
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928293]  
[<ffffffff81121b78>] ? bio_alloc_bioset+0x43/0xb6
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928297]  
[<ffffffff8111da68>] ? submit_bh+0xe2/0xff
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928304]  
[<ffffffffa0167674>] ? jbd2_journal_commit_transaction+0x803/0x10bf 
[jbd2]
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928309]  
[<ffffffff8100d02f>] ? load_TLS+0x7/0xa
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928313]  
[<ffffffff8100d69e>] ? __switch_to+0x133/0x258
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928318]  
[<ffffffff81350dd1>] ? _raw_spin_lock_irqsave+0x9/0x25
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928323]  
[<ffffffff8105267a>] ? lock_timer_base.isra.29+0x23/0x47
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928330]  
[<ffffffffa016b166>] ? kjournald2+0xc0/0x20a [jbd2]
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928334]  
[<ffffffff8105fdf3>] ? add_wait_queue+0x3c/0x3c
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928341]  
[<ffffffffa016b0a6>] ? commit_timeout+0x5/0x5 [jbd2]
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928345]  
[<ffffffff8105f7a1>] ? kthread+0x76/0x7e
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928349]  
[<ffffffff81357ff4>] ? kernel_thread_helper+0x4/0x10
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928354]  
[<ffffffff8105f72b>] ? kthread_worker_fn+0x139/0x139
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928358]  
[<ffffffff81357ff0>] ? gs_change+0x13/0x13
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928408] smbd            
D ffff88021fc12780     0  3063  25481 0x00000000
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928413]  
ffff880213e07780 0000000000000082 0000000000000000 ffffffff8160d020
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928418]  
0000000000012780 ffff880003cabfd8 ffff880003cabfd8 ffff880213e07780
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928424]  
0000000000000000 00000001135a0d70 ffff8802135a0d60 ffff8802135a0d70
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928429] Call Trace:
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928435]  
[<ffffffffa0123804>] ? get_active_stripe+0x24c/0x505 [raid456]
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928439]  
[<ffffffff8103f6e2>] ? try_to_wake_up+0x197/0x197
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928445]  
[<ffffffffa01258c8>] ? make_request+0x1b4/0x37a [raid456]
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928450]  
[<ffffffff8105fdf3>] ? add_wait_queue+0x3c/0x3c
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928457]  
[<ffffffffa00e8d47>] ? md_make_request+0xee/0x1db [md_mod]
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928468]  
[<ffffffffa017d19a>] ? noalloc_get_block_write+0x17/0x17 [ext4]
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928473]  
[<ffffffff8119a3ec>] ? generic_make_request+0x90/0xcf
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928477]  
[<ffffffff8119a4fe>] ? submit_bio+0xd3/0xf1
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928482]  
[<ffffffff810bedab>] ? __lru_cache_add+0x2b/0x51
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928486]  
[<ffffffff811259dd>] ? mpage_readpages+0x113/0x134
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928496]  
[<ffffffffa017d19a>] ? noalloc_get_block_write+0x17/0x17 [ext4]
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928500]  
[<ffffffff81109033>] ? poll_freewait+0x97/0x97
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928505]  
[<ffffffff81036628>] ? should_resched+0x5/0x23
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928508]  
[<ffffffff8134fa44>] ? _cond_resched+0x7/0x1c
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928513]  
[<ffffffff810bdd31>] ? __do_page_cache_readahead+0x11e/0x1c3
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928517]  
[<ffffffff810be02e>] ? ra_submit+0x19/0x1d
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928522]  
[<ffffffff810b689b>] ? generic_file_aio_read+0x282/0x5cf
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928528]  
[<ffffffff810fadc4>] ? do_sync_read+0xb4/0xec
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928532]  
[<ffffffff810fb4af>] ? vfs_read+0x9f/0xe6
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928536]  
[<ffffffff810fb61f>] ? sys_pread64+0x53/0x6e
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928540]  
[<ffffffff81355e92>] ? system_call_fastpath+0x16/0x1b
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928549] imap            
D ffff88021fc12780     0  3121   4613 0x00000000
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928554]  
ffff880216db1100 0000000000000082 ffffea0000000000 ffffffff8160d020
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928559]  
0000000000012780 ffff8800cf5b1fd8 ffff8800cf5b1fd8 ffff880216db1100
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928564]  
0000000000000000 00000001135a0d70 ffff8802135a0d60 ffff8802135a0d70
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928569] Call Trace:
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928576]  
[<ffffffffa0123804>] ? get_active_stripe+0x24c/0x505 [raid456]
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928580]  
[<ffffffff8103f6e2>] ? try_to_wake_up+0x197/0x197
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928585]  
[<ffffffffa01258c8>] ? make_request+0x1b4/0x37a [raid456]
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928590]  
[<ffffffff8105fdf3>] ? add_wait_queue+0x3c/0x3c
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928597]  
[<ffffffffa00e8d47>] ? md_make_request+0xee/0x1db [md_mod]
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928607]  
[<ffffffffa017d19a>] ? noalloc_get_block_write+0x17/0x17 [ext4]
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928611]  
[<ffffffff8119a3ec>] ? generic_make_request+0x90/0xcf
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928615]  
[<ffffffff8119a4fe>] ? submit_bio+0xd3/0xf1
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928619]  
[<ffffffff810bedab>] ? __lru_cache_add+0x2b/0x51
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928623]  
[<ffffffff811259dd>] ? mpage_readpages+0x113/0x134
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928633]  
[<ffffffffa017d19a>] ? noalloc_get_block_write+0x17/0x17 [ext4]
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928637]  
[<ffffffff8110b27f>] ? dput+0x27/0xee
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928641]  
[<ffffffff811110df>] ? mntput_no_expire+0x1e/0xc9
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928646]  
[<ffffffff810bdd31>] ? __do_page_cache_readahead+0x11e/0x1c3
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928650]  
[<ffffffff810bdff1>] ? force_page_cache_readahead+0x5f/0x83
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928654]  
[<ffffffff810b85e5>] ? sys_fadvise64_64+0x141/0x1e2
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928658]  
[<ffffffff81355e92>] ? system_call_fastpath+0x16/0x1b
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928667] smbd            
D ffff88021fc12780     0  3155  25481 0x00000000
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928672]  
ffff8802135d8780 0000000000000086 0000000000000000 ffffffff8160d020
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928677]  
0000000000012780 ffff880005267fd8 ffff880005267fd8 ffff8802135d8780
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928683]  
0000000000000000 00000001135a0d70 ffff8802135a0d60 ffff8802135a0d70
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928688] Call Trace:
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928694]  
[<ffffffffa0123804>] ? get_active_stripe+0x24c/0x505 [raid456]
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928698]  
[<ffffffff8103f6e2>] ? try_to_wake_up+0x197/0x197
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928704]  
[<ffffffffa01258c8>] ? make_request+0x1b4/0x37a [raid456]
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928708]  
[<ffffffff8105fdf3>] ? add_wait_queue+0x3c/0x3c
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928715]  
[<ffffffffa00e8d47>] ? md_make_request+0xee/0x1db [md_mod]
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928725]  
[<ffffffffa017d19a>] ? noalloc_get_block_write+0x17/0x17 [ext4]
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928729]  
[<ffffffff8119a3ec>] ? generic_make_request+0x90/0xcf
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928733]  
[<ffffffff8119a4fe>] ? submit_bio+0xd3/0xf1
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928737]  
[<ffffffff810bedab>] ? __lru_cache_add+0x2b/0x51
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928741]  
[<ffffffff811259dd>] ? mpage_readpages+0x113/0x134
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928751]  
[<ffffffffa017d19a>] ? noalloc_get_block_write+0x17/0x17 [ext4]
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928755]  
[<ffffffff81109033>] ? poll_freewait+0x97/0x97
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928759]  
[<ffffffff81036628>] ? should_resched+0x5/0x23
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928762]  
[<ffffffff8134fa44>] ? _cond_resched+0x7/0x1c
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928767]  
[<ffffffff810bdd31>] ? __do_page_cache_readahead+0x11e/0x1c3
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928771]  
[<ffffffff810be02e>] ? ra_submit+0x19/0x1d
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928775]  
[<ffffffff810b689b>] ? generic_file_aio_read+0x282/0x5cf
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928780]  
[<ffffffff810fadc4>] ? do_sync_read+0xb4/0xec
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928784]  
[<ffffffff810fb4af>] ? vfs_read+0x9f/0xe6
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928788]  
[<ffffffff810fb61f>] ? sys_pread64+0x53/0x6e
     Oct 17 19:04:46 bazsalikom kernel: [7875480.928792]  
[<ffffffff81355e92>] ? system_call_fastpath+0x16/0x1b

 From here on, things went downhill pretty damn fast. I was not able to 
unmount the file-system, stop or re-start the array (/proc/mdstat went 
away), any process trying to touch /dev/md1 hung, so eventually, I run 
out of options and hit the reset button on the machine.

Upon reboot, the array wouldn't assemble, it was complaining that SDA 
and SDA1 had the same superblock info on it.

mdadm: WARNING /dev/sda and /dev/sda1 appear to have very similar 
superblocks.
       If they are really different, please --zero the superblock on one
       If they are the same or overlap, please remove one from the
       DEVICE list in mdadm.conf.

At this point, I looked at the drives and it appeared that the drive 
letters got re-arranged by the kernel. My three new HDD-s (which used to 
be SDH, SDI, SDJ) now appear as SDA, SDB and SDD.

I've read up on this a little and everyone seemed to suggest that you 
repair this super-block corruption by zeroing out the suport-block, so I 
did:

     mdadm --zero-superblock /dev/sda1

At this point mdadm started complaining about the super-block on SDB 
(and later SDD) so I ended up zeroing out the superblock on all three of 
the new hard-drives:

     mdadm --zero-superblock /dev/sdb1
     mdadm --zero-superblock /dev/sdd1

After this, the array would assemble, but wouldn't start, stating that 
it doesn't have enough disks in it - which is correct for the new array: 
I just removed 3 drives from a RAID6.

Right now, /proc/mdstat says:

     Personalities : [raid1] [raid6] [raid5] [raid4]
     md1 : inactive sdh2[0](S) sdc2[6](S) sdj1[5](S) sde1[4](S) 
sdg1[3](S) sdi1[2](S) sdf2[1](S)
           10744335040 blocks super 0.91

mdadm -E /dev/sdc2 says:
     /dev/sdc2:
               Magic : a92b4efc
             Version : 0.91.00
                UUID : 5e57a17d:43eb0786:42ea8b6c:723593c7
       Creation Time : Sat Oct  2 07:21:53 2010
          Raid Level : raid6
       Used Dev Size : 1465135936 (1397.26 GiB 1500.30 GB)
          Array Size : 11721087488 (11178.10 GiB 12002.39 GB)
        Raid Devices : 10
       Total Devices : 10
     Preferred Minor : 1


       Reshape pos'n : 4096
       Delta Devices : 3 (7->10)


         Update Time : Sat Oct 17 18:59:50 2015
               State : active
      Active Devices : 10
     Working Devices : 10
      Failed Devices : 0
       Spare Devices : 0
            Checksum : fad60788 - correct
              Events : 2579239


              Layout : left-symmetric
          Chunk Size : 64K


           Number   Major   Minor   RaidDevice State
     this     6       8       98        6      active sync


        0     0       8       50        0      active sync
        1     1       8       18        1      active sync
        2     2       8       65        2      active sync   /dev/sde1
        3     3       8       33        3      active sync   /dev/sdc1
        4     4       8        1        4      active sync   /dev/sda1
        5     5       8       81        5      active sync   /dev/sdf1
        6     6       8       98        6      active sync
        7     7       8      145        7      active sync   /dev/sdj1
        8     8       8      129        8      active sync   /dev/sdi1
        9     9       8      113        9      active sync   /dev/sdh1

So, if I read this right, the superblock here states that the array is 
in the middle of a reshape from 7 to 10 devices, but it just started 
(4096 is the position).
What's interesting is the device names listed here don't match the ones 
reported by /proc/mdstat, and are actually incorrect. The right 
partition numbers are in /proc/mdstat.

The superblocks on the 6 other original disks match, except for of 
course which one they mark as 'this' and the checksum.

I've read in here (http://ubuntuforums.org/showthread.php?t=2133576) 
among many other places that it might be possible to recover the data on 
the array by trying to re-create it to the state before the re-shape.

I've also read that if I want to re-create an array in read-only mode, I 
should re-create it degraded.

So, what I thought I would do is this:

     mdadm --create /dev/md1 --level=6 --raid-devices=7 /dev/sdh2 
/dev/sdf2 /dev/sdi1 /dev/sdg1 /dev/sde1 missing missing

Obviously, at this point, I'm trying to be as cautious as possible in 
not causing any further damage, if that's at all possible.

It seems that this issue has some similarities to this bug: 
https://bugs.launchpad.net/ubuntu/+source/mdadm/+bug/1001019

So, please all mdadm gurus, help me out! How can I recover as much of 
the data on this volume as possible?

Thanks again,
Andras Tantos

