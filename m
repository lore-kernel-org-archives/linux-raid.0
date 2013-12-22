From: Hans Kraus <hans@hanswkraus.com>
Subject: More 'D' state processes [was: Re: Weird problem: mdadm blocks]
Date: Sun, 22 Dec 2013 17:43:43 +0100
Message-ID: <52B716BF.70000@hanswkraus.com>
References: <52B6AA66.5050502@hanswkraus.com> <20131222221914.78630829@notabene.brown> <52B70F38.5040807@hanswkraus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52B70F38.5040807@hanswkraus.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

sorry for my last mail, I didn't get all 'D' state processes:
1     0    18     2  20   0      0     0 -      D    ?          2:17 
[kswapd0]
1     0   291     2   0 -20      0     0 -      D<   ?          0:00 [md]
1     0   760     2  20   0      0     0 -      D    ?          1:15 
[flush-9:4]
0     0  4560  4559  20   0  67196  6440 -      D    ?          0:52 
/usr/bin/perl -w /usr/bin/apt-show-versions -i
0     0  5028  5005  20   0  49816  2472 -      D    ?          0:22 
apt-get check -f -qq
0     0  5345 20853  20   0  26756  1224 -      D+   pts/3      0:00 ls 
-al /stor1
1     0  6068  5354  20   0  20680  1952 -      D+   pts/5      0:00 -bash
0   114  7910 28104  30  10  64724 14364 -      DN   ?          7:26 
/usr/bin/perl /usr/share/backuppc/bin/BackupPC_link robbe
0   114  8843 28104  20   0 133108 72076 -      D    ?          8:58 
/usr/bin/perl /usr/share/backuppc/bin/BackupPC_dump biber
0   114  8844 28104  20   0 135096 74240 -      D    ?          5:27 
/usr/bin/perl /usr/share/backuppc/bin/BackupPC_dump eisbaer
0   114  8846 28104  20   0 110440 48456 -      D    ?         12:07 
/usr/bin/perl /usr/share/backuppc/bin/BackupPC_dump robbe_foto
1   114  8901  8845  20   0  84460 22880 -      D    ?         84:14 
/usr/bin/perl /usr/share/backuppc/bin/BackupPC_dump robbe_audio
1   114  8965  8846  20   0 104272 42280 -      D    ?         81:54 
/usr/bin/perl /usr/share/backuppc/bin/BackupPC_dump robbe_foto
1   114  9793  8844  20   0 159476 94444 -      D    ?         60:59 
/usr/bin/perl /usr/share/backuppc/bin/BackupPC_dump eisbaer
1   114 10077  8843  20   0 157724 94420 -      D    ?         45:37 
/usr/bin/perl /usr/share/backuppc/bin/BackupPC_dump biber
1     0 12935     2  20   0      0     0 -      D    ?          3:05 
[kworker/0:0]
1     0 18837     2  20   0      0     0 -      D    ?         66:09 
[md127_raid5]
1     0 18866     2  20   0      0     0 -      D    ?        117:04 
[md127_resync]
1     0 19557     2  20   0      0     0 -      D    ?          0:16 
[kworker/0:2]
1     0 20797     2  20   0      0     0 -      D    ?          0:27 
[xfsbufd/dm-0]
1     0 20798     2  20   0      0     0 -      D    ?          2:01 
[xfsaild/dm-0]
1     0 20958     2  20   0      0     0 -      D    ?          3:26 
[flush-253:0]
0   114 26646 28104  30  10  46540  7892 -      DN   ?          0:26 
/usr/bin/perl /usr/share/backuppc/bin/BackupPC_trashClean
0   114 26647 28104  30  10  59952 11004 -      DN   ?          0:11 
/usr/bin/perl /usr/share/backuppc/bin/BackupPC_nightly -m 0 127
0   114 26648 28104  30  10  59952 10992 -      DN   ?          0:11 
/usr/bin/perl /usr/share/backuppc/bin/BackupPC_nightly 128 255
1   114 28104     1  20   0  65416 13056 -      D    ?          0:02 
/usr/bin/perl /usr/share/backuppc/bin/BackupPC -d

The stack trace of [md127_raid5] is:
root@elefant:/home/kraush/work# cat /proc/18837/stack
[<ffffffffa01756f0>] md_super_wait+0x6a/0x80 [md_mod]
[<ffffffff8105fc83>] autoremove_wake_function+0x0/0x2a
[<ffffffffa0175a88>] md_update_sb+0x382/0x474 [md_mod]
[<ffffffff8100d02f>] load_TLS+0x7/0xa
[<ffffffff8100d69f>] __switch_to+0x133/0x258
[<ffffffffa01762f4>] md_check_recovery+0x218/0x514 [md_mod]
[<ffffffffa0f146fe>] raid5d+0x1c/0x483 [raid456]
[<ffffffff81070fc1>] arch_local_irq_save+0x11/0x17
[<ffffffff81070fc1>] arch_local_irq_save+0x11/0x17
[<ffffffffa0170256>] md_thread+0x114/0x132 [md_mod]
[<ffffffff8105fc83>] autoremove_wake_function+0x0/0x2a
[<ffffffffa0170142>] md_thread+0x0/0x132 [md_mod]
[<ffffffff8105f631>] kthread+0x76/0x7e
[<ffffffff81356374>] kernel_thread_helper+0x4/0x10
[<ffffffff8105f5bb>] kthread+0x0/0x7e
[<ffffffff81356370>] kernel_thread_helper+0x0/0x10
[<ffffffffffffffff>] 0xffffffffffffffff

The stack trace of [md127_resync] is:
root@elefant:/home/kraush/work# cat /proc/18866/stack
[<ffffffff81070fc1>] arch_local_irq_save+0x11/0x17
[<ffffffffa0f0f903>] get_active_stripe+0x24c/0x505 [raid456]
[<ffffffff8103f6c4>] default_wake_function+0x0/0x9
[<ffffffffa0f14dcf>] sync_request+0x26a/0x2de [raid456]
[<ffffffffa0173581>] md_do_sync+0x76b/0xb6f [md_mod]
[<ffffffff8105fc83>] autoremove_wake_function+0x0/0x2a
[<ffffffffa0170256>] md_thread+0x114/0x132 [md_mod]
[<ffffffffa0170142>] md_thread+0x0/0x132 [md_mod]
[<ffffffff8105f631>] kthread+0x76/0x7e
[<ffffffff81356374>] kernel_thread_helper+0x4/0x10
[<ffffffff8105f5bb>] kthread+0x0/0x7e
[<ffffffff81356370>] kernel_thread_helper+0x0/0x10
[<ffffffffffffffff>] 0xffffffffffffffff

Regards, Hans

Am 22.12.2013 17:11, schrieb Hans Kraus:
> Hi Neil,
>
> thanks for your answer. The only process in 'D' state is the
> "ls -al /stor1" I wrote about.
>
> Dmesg has the following complaints:
> [40800.776543] INFO: task md127_raid5:18837 blocked for more than 120
> seconds.
> [40800.776546] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [40800.776549] md127_raid5     D ffff880077c13780     0 18837      2
> 0x00000000
> [40800.776554]  ffff880054d1f1a0 0000000000000046 ffff88003efa3488
> ffff88006b6717d0
> [40800.776559]  0000000000013780 ffff880043f47fd8 ffff880043f47fd8
> ffff880054d1f1a0
> [40800.776564]  0000000000000246 ffffffff8134f209 ffff88003734a680
> ffff88003734a400
> [40800.776569] Call Trace:
> [40800.776574]  [<ffffffff8134f209>] ? _raw_spin_lock_irqsave+0x9/0x25
> [40800.776585]  [<ffffffffa01756f0>] ? md_super_wait+0x6a/0x80 [md_mod]
> [40800.776590]  [<ffffffff8105fc83>] ? add_wait_queue+0x3c/0x3c
> [40800.776600]  [<ffffffffa0175a88>] ? md_update_sb+0x382/0x474 [md_mod]
> [40800.776606]  [<ffffffff8100d02f>] ? load_TLS+0x7/0xa
> [40800.776611]  [<ffffffff8100d69f>] ? __switch_to+0x133/0x258
> [40800.776621]  [<ffffffffa01762f4>] ? md_check_recovery+0x218/0x514
> [md_mod]
> [40800.776629]  [<ffffffffa0f146fe>] ? raid5d+0x1c/0x483 [raid456]
> [40800.776634]  [<ffffffff8134e35b>] ? schedule_timeout+0x2c/0xdb
> [40800.776638]  [<ffffffff81070fc1>] ? arch_local_irq_save+0x11/0x17
> [40800.776642]  [<ffffffff81070fc1>] ? arch_local_irq_save+0x11/0x17
> [40800.776652]  [<ffffffffa0170256>] ? md_thread+0x114/0x132 [md_mod]
> [40800.776657]  [<ffffffff8105fc83>] ? add_wait_queue+0x3c/0x3c
> [40800.776666]  [<ffffffffa0170142>] ? md_rdev_init+0xea/0xea [md_mod]
> [40800.776671]  [<ffffffff8105f631>] ? kthread+0x76/0x7e
> [40800.776676]  [<ffffffff81356374>] ? kernel_thread_helper+0x4/0x10
> [40800.776681]  [<ffffffff8105f5bb>] ? kthread_worker_fn+0x139/0x139
> [40800.776686]  [<ffffffff81356370>] ? gs_change+0x13/0x13
> [40800.776689] INFO: task md127_resync:18866 blocked for more than 120
> seconds.
> [40800.776692] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [40800.776695] md127_resync    D ffff8800727441c0     0 18866      2
> 0x00000000
> [40800.776701]  ffff8800727441c0 0000000000000046 0000000000000000
> ffff88001b3848b0
> [40800.776705]  0000000000013780 ffff8800716d5fd8 ffff8800716d5fd8
> ffff8800727441c0
> [40800.776710]  0000000000000000 ffffffff81070fc1 0000000000000046
> ffff880054ed9570
> [40800.776715] Call Trace:
> [40800.776719]  [<ffffffff81070fc1>] ? arch_local_irq_save+0x11/0x17
> [40800.776726]  [<ffffffffa0f0f903>] ? get_active_stripe+0x24c/0x505
> [raid456]
> [40800.776730]  [<ffffffff8103f6c4>] ? try_to_wake_up+0x197/0x197
> [40800.776737]  [<ffffffffa0f14dcf>] ? sync_request+0x26a/0x2de [raid456]
> [40800.776748]  [<ffffffffa0173581>] ? md_do_sync+0x76b/0xb6f [md_mod]
> [40800.776754]  [<ffffffff8105fc83>] ? add_wait_queue+0x3c/0x3c
> [40800.776763]  [<ffffffffa0170256>] ? md_thread+0x114/0x132 [md_mod]
> [40800.776773]  [<ffffffffa0170142>] ? md_rdev_init+0xea/0xea [md_mod]
> [40800.776778]  [<ffffffff8105f631>] ? kthread+0x76/0x7e
> [40800.776782]  [<ffffffff81356374>] ? kernel_thread_helper+0x4/0x10
> [40800.776788]  [<ffffffff8105f5bb>] ? kthread_worker_fn+0x139/0x139
> [40800.776792]  [<ffffffff81356370>] ? gs_change+0x13/0x13
> [40800.776797] INFO: task xfsbufd/dm-0:20797 blocked for more than 120
> seconds.
> [40800.776801] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [40800.776804] xfsbufd/dm-0    D ffff880077c13780     0 20797      2
> 0x00000000
> [40800.776809]  ffff8800757b3550 0000000000000046 ffff880071fedd40
> ffff88006b6717d0
> [40800.776814]  0000000000013780 ffff88001b12ffd8 ffff88001b12ffd8
> ffff8800757b3550
> [40800.776819]  0000000000000246 ffffffff8134f209 ffff88003734a680
> ffff88003734a400
> [40800.776824] Call Trace:
> [40800.776828]  [<ffffffff8134f209>] ? _raw_spin_lock_irqsave+0x9/0x25
> [40800.776838]  [<ffffffffa0174122>] ? md_write_start+0x133/0x149 [md_mod]
> [40800.776844]  [<ffffffff8105fc83>] ? add_wait_queue+0x3c/0x3c
> [40800.776850]  [<ffffffffa0f11722>] ? make_request+0x36/0x37a [raid456]
> [40800.776860]  [<ffffffffa0185873>] ?
> __split_and_process_bio+0x4f4/0x506 [dm_mod]
> [40800.776866]  [<ffffffff8105fc83>] ? add_wait_queue+0x3c/0x3c
> [40800.776875]  [<ffffffffa016fd47>] ? md_make_request+0xee/0x1db [md_mod]
> [40800.776881]  [<ffffffff8119908a>] ? generic_make_request+0x90/0xcf
> [40800.776885]  [<ffffffff8119919c>] ? submit_bio+0xd3/0xf1
> [40800.776890]  [<ffffffff81120e40>] ? bio_alloc_bioset+0x43/0xb6
> [40800.776910]  [<ffffffffa0f2be8a>] ? _xfs_buf_ioapply+0x17a/0x1bb [xfs]
> [40800.776915]  [<ffffffff8103f6c4>] ? try_to_wake_up+0x197/0x197
> [40800.776932]  [<ffffffffa0f2c73d>] ? xfs_bdstrat_cb+0x4d/0x51 [xfs]
> [40800.776950]  [<ffffffffa0f2bf98>] ? xfs_buf_iorequest+0x62/0x7b [xfs]
> [40800.776967]  [<ffffffffa0f2c73d>] ? xfs_bdstrat_cb+0x4d/0x51 [xfs]
> [40800.776985]  [<ffffffffa0f2c823>] ? xfsbufd+0xe2/0x114 [xfs]
> [40800.776989]  [<ffffffff8134de91>] ? __schedule+0x5f9/0x610
> [40800.777007]  [<ffffffffa0f2c741>] ? xfs_bdstrat_cb+0x51/0x51 [xfs]
> [40800.777012]  [<ffffffff8105f631>] ? kthread+0x76/0x7e
> [40800.777017]  [<ffffffff81356374>] ? kernel_thread_helper+0x4/0x10
> [40800.777023]  [<ffffffff8105f5bb>] ? kthread_worker_fn+0x139/0x139
> [40800.777027]  [<ffffffff81356370>] ? gs_change+0x13/0x13
> [40800.777030] INFO: task xfsaild/dm-0:20798 blocked for more than 120
> seconds.
> [40800.777034] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [40800.777037] xfsaild/dm-0    D ffff88003754c300     0 20798      2
> 0x00000000
> [40800.777042]  ffff88003754c300 0000000000000046 0000000000000000
> ffff88005d7c51a0
> [40800.777047]  0000000000013780 ffff88001b01ffd8 ffff88001b01ffd8
> ffff88003754c300
> [40800.777052]  ffff880071fede00 ffffffff81070fc1 0000000000000046
> ffff88003734a400
> [40800.777057] Call Trace:
> [40800.777061]  [<ffffffff81070fc1>] ? arch_local_irq_save+0x11/0x17
> [40800.777071]  [<ffffffffa0170466>] ? md_flush_request+0x96/0x111 [md_mod]
> [40800.777076]  [<ffffffff8103f6c4>] ? try_to_wake_up+0x197/0x197
> [40800.777082]  [<ffffffffa0f11711>] ? make_request+0x25/0x37a [raid456]
> [40800.777091]  [<ffffffffa0185873>] ?
> __split_and_process_bio+0x4f4/0x506 [dm_mod]
> [40800.777096]  [<ffffffff8103720c>] ? test_tsk_need_resched+0xa/0x13
> [40800.777101]  [<ffffffff8103afb6>] ? check_preempt_curr+0x52/0x5f
> [40800.777106]  [<ffffffff8103b013>] ? ttwu_do_wakeup+0x50/0xc4
> [40800.777116]  [<ffffffffa016fd47>] ? md_make_request+0xee/0x1db [md_mod]
> [40800.777121]  [<ffffffff8119908a>] ? generic_make_request+0x90/0xcf
> [40800.777126]  [<ffffffff8119919c>] ? submit_bio+0xd3/0xf1
> [40800.777131]  [<ffffffff81120e66>] ? bio_alloc_bioset+0x69/0xb6
> [40800.777149]  [<ffffffffa0f2be8a>] ? _xfs_buf_ioapply+0x17a/0x1bb [xfs]
> [40800.777154]  [<ffffffff8103f6c4>] ? try_to_wake_up+0x197/0x197
> [40800.777179]  [<ffffffffa0f6ba3a>] ? xlog_bdstrat+0x34/0x38 [xfs]
> [40800.777196]  [<ffffffffa0f2bf98>] ? xfs_buf_iorequest+0x62/0x7b [xfs]
> [40800.777221]  [<ffffffffa0f6ba3a>] ? xlog_bdstrat+0x34/0x38 [xfs]
> [40800.777245]  [<ffffffffa0f6c7cc>] ? xlog_sync+0x1dd/0x2d4 [xfs]
> [40800.777269]  [<ffffffffa0f70cd0>] ? xfs_ail_min_lsn+0xd/0x2b [xfs]
> [40800.777294]  [<ffffffffa0f6db4b>] ? xlog_write+0x348/0x545 [xfs]
> [40800.777316]  [<ffffffffa0f3cd86>] ? kmem_zone_zalloc+0x1b/0x2d [xfs]
> [40800.777341]  [<ffffffffa0f6ed2b>] ? xlog_cil_push+0x1e5/0x2fb [xfs]
> [40800.777366]  [<ffffffffa0f6f351>] ? xlog_cil_force_lsn+0x1d/0x86 [xfs]
> [40800.777391]  [<ffffffffa0f6ded3>] ? _xfs_log_force+0x4e/0x1ae [xfs]
> [40800.777416]  [<ffffffffa0f6e03e>] ? xfs_log_force+0xb/0x2c [xfs]
> [40800.777440]  [<ffffffffa0f70eae>] ? xfsaild+0xf4/0x46b [xfs]
> [40800.777465]  [<ffffffffa0f70dba>] ?
> xfs_trans_ail_cursor_first+0x79/0x79 [xfs]
> [40800.777470]  [<ffffffff8105f631>] ? kthread+0x76/0x7e
> [40800.777475]  [<ffffffff81356374>] ? kernel_thread_helper+0x4/0x10
> [40800.777481]  [<ffffffff8105f5bb>] ? kthread_worker_fn+0x139/0x139
> [40800.777485]  [<ffffffff81356370>] ? gs_change+0x13/0x13
> [40800.777489] INFO: task flush-253:0:20958 blocked for more than 120
> seconds.
> [40800.777492] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [40800.777495] flush-253:0     D ffff880077c13780     0 20958      2
> 0x00000000
> [40800.777500]  ffff88001b7ecf20 0000000000000046 0000000000011200
> ffff8800727441c0
> [40800.777505]  0000000000013780 ffff88001b0b3fd8 ffff88001b0b3fd8
> ffff88001b7ecf20
> [40800.777510]  0000000000000246 ffffffff8134f209 ffff88003734a680
> ffff88003734a400
> [40800.777515] Call Trace:
> [40800.777519]  [<ffffffff8134f209>] ? _raw_spin_lock_irqsave+0x9/0x25
> [40800.777531]  [<ffffffffa0174122>] ? md_write_start+0x133/0x149 [md_mod]
> [40800.777536]  [<ffffffff8105fc83>] ? add_wait_queue+0x3c/0x3c
> [40800.777542]  [<ffffffffa0f11722>] ? make_request+0x36/0x37a [raid456]
> [40800.777552]  [<ffffffffa0185873>] ?
> __split_and_process_bio+0x4f4/0x506 [dm_mod]
> [40800.777562]  [<ffffffffa016fd47>] ? md_make_request+0xee/0x1db [md_mod]
> [40800.777567]  [<ffffffff8119908a>] ? generic_make_request+0x90/0xcf
> [40800.777572]  [<ffffffff8119919c>] ? submit_bio+0xd3/0xf1
> [40800.777577]  [<ffffffff811171c5>] ? __mark_inode_dirty+0x58/0x17a
> [40800.777595]  [<ffffffffa0f2a4aa>] ? xfs_submit_ioend+0x99/0xd9 [xfs]
> [40800.777612]  [<ffffffffa0f2a852>] ? xfs_vm_writepage+0x368/0x3e1 [xfs]
> [40800.777618]  [<ffffffff810bc31a>] ? __writepage+0xa/0x21
> [40800.777622]  [<ffffffff810bc1a2>] ? write_cache_pages+0x1f8/0x2e9
> [40800.777628]  [<ffffffff810bc310>] ? set_page_dirty_lock+0x2b/0x2b
> [40800.777633]  [<ffffffff810bc2cd>] ? generic_writepages+0x3a/0x52
> [40800.777639]  [<ffffffff811183f3>] ? writeback_single_inode+0x11d/0x2cc
> [40800.777644]  [<ffffffff81118873>] ? writeback_sb_inodes+0x16b/0x204
> [40800.777650]  [<ffffffff81118979>] ? __writeback_inodes_wb+0x6d/0xab
> [40800.777655]  [<ffffffff81118adf>] ? wb_writeback+0x128/0x21f
> [40800.777660]  [<ffffffff810bc628>] ? determine_dirtyable_memory+0x10/0x17
> [40800.777665]  [<ffffffff81118fd9>] ? wb_do_writeback+0x189/0x1a8
> [40800.777671]  [<ffffffff8111907d>] ? bdi_writeback_thread+0x85/0x1e6
> [40800.777676]  [<ffffffff81118ff8>] ? wb_do_writeback+0x1a8/0x1a8
> [40800.777681]  [<ffffffff8105f631>] ? kthread+0x76/0x7e
> [40800.777686]  [<ffffffff81356374>] ? kernel_thread_helper+0x4/0x10
> [40800.777691]  [<ffffffff8105f5bb>] ? kthread_worker_fn+0x139/0x139
> [40800.777695]  [<ffffffff81356370>] ? gs_change+0x13/0x13
> [40800.777703] INFO: task BackupPC_dump:8965 blocked for more than 120
> seconds.
> [40800.777706] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [40800.777710] BackupPC_dump   D ffff88005d7c51a0     0  8965   8846
> 0x00000000
> [40800.777715]  ffff88005d7c51a0 0000000000000086 ffff88005e635b40
> ffff88006b2a82c0
> [40800.777720]  0000000000013780 ffff8800596c9fd8 ffff8800596c9fd8
> ffff88005d7c51a0
> [40800.777725]  0000000000000000 0000000000000000 ffff880050f9bd40
> 7fffffffffffffff
> [40800.777730] Call Trace:
> [40800.777734]  [<ffffffff8134e35b>] ? schedule_timeout+0x2c/0xdb
> [40800.777739]  [<ffffffff811aa999>] ? _atomic_dec_and_lock+0x1/0x48
> [40800.777744]  [<ffffffff8134dfa1>] ? wait_for_common+0xa0/0x119
> [40800.777748]  [<ffffffff8103f6c4>] ? try_to_wake_up+0x197/0x197
> [40800.777766]  [<ffffffffa0f2c0fb>] ? xfs_buf_read+0x88/0xbe [xfs]
> [40800.777791]  [<ffffffffa0f71a39>] ? xfs_trans_read_buf+0x4a/0x310 [xfs]
> [40800.777808]  [<ffffffffa0f2bff5>] ? xfs_buf_iowait+0x44/0x81 [xfs]
> [40800.777826]  [<ffffffffa0f2c0fb>] ? xfs_buf_read+0x88/0xbe [xfs]
> [40800.777850]  [<ffffffffa0f71a39>] ? xfs_trans_read_buf+0x4a/0x310 [xfs]
> [40800.777875]  [<ffffffffa0f5fb1c>] ? xfs_imap_to_bp+0x40/0x100 [xfs]
> [40800.777899]  [<ffffffffa0f632cd>] ? xfs_iread+0x54/0x177 [xfs]
> [40800.777917]  [<ffffffffa0f30743>] ? xfs_inode_alloc+0x73/0xe9 [xfs]
> [40800.777936]  [<ffffffffa0f30ec2>] ? xfs_iget+0x37c/0x56c [xfs]
> [40800.777958]  [<ffffffffa0f3b3b4>] ? xfs_lookup+0xa4/0xd3 [xfs]
> [40800.777977]  [<ffffffffa0f33e5a>] ? xfs_vn_lookup+0x3f/0x7e [xfs]
> [40800.777983]  [<ffffffff81102709>] ? d_alloc_and_lookup+0x3a/0x60
> [40800.777988]  [<ffffffff811031ad>] ? walk_component+0x219/0x406
> [40800.777993]  [<ffffffff811039e1>] ? link_path_walk+0x174/0x421
> [40800.777998]  [<ffffffff81104018>] ? path_lookupat+0x53/0x2bd
> [40800.778002]  [<ffffffff81036628>] ? should_resched+0x5/0x23
> [40800.778006]  [<ffffffff81036628>] ? should_resched+0x5/0x23
> [40800.778010]  [<ffffffff8134deec>] ? _cond_resched+0x7/0x1c
> [40800.778014]  [<ffffffff8110429e>] ? do_path_lookup+0x1c/0x87
> [40800.778019]  [<ffffffff81105d27>] ? user_path_at_empty+0x47/0x7b
> [40800.778024]  [<ffffffff811b0604>] ? timerqueue_add+0x80/0xa0
> [40800.778029]  [<ffffffff810380d3>] ? set_next_entity+0x32/0x55
> [40800.778034]  [<ffffffff8100d751>] ? __switch_to+0x1e5/0x258
> [40800.778039]  [<ffffffff810fdd7a>] ? vfs_fstatat+0x32/0x60
> [40800.778043]  [<ffffffff810fdeb0>] ? sys_newstat+0x12/0x2b
> [40800.778048]  [<ffffffff81354212>] ? system_call_fastpath+0x16/0x1b
> [40800.778053] INFO: task kworker/0:0:12935 blocked for more than 120
> seconds.
> [40800.778056] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [40800.778059] kworker/0:0     D ffff880077c13780     0 12935      2
> 0x00000000
> [40800.778064]  ffff88001b0c4f60 0000000000000046 ffffffff81788740
> ffff88006b7e6340
> [40800.778069]  0000000000013780 ffff880000cabfd8 ffff880000cabfd8
> ffff88001b0c4f60
> [40800.778074]  0000000000000246 ffffffff8134f209 ffff88003734a680
> ffff88003734a400
> [40800.778079] Call Trace:
> [40800.778083]  [<ffffffff8134f209>] ? _raw_spin_lock_irqsave+0x9/0x25
> [40800.778095]  [<ffffffffa0174122>] ? md_write_start+0x133/0x149 [md_mod]
> [40800.778100]  [<ffffffff8105fc83>] ? add_wait_queue+0x3c/0x3c
> [40800.778106]  [<ffffffffa0f11722>] ? make_request+0x36/0x37a [raid456]
> [40800.778111]  [<ffffffff810ece31>] ? kmem_cache_alloc+0x86/0xea
> [40800.778121]  [<ffffffffa016fd47>] ? md_make_request+0xee/0x1db [md_mod]
> [40800.778126]  [<ffffffff8119908a>] ? generic_make_request+0x90/0xcf
> [40800.778135]  [<ffffffffa01855e4>] ?
> __split_and_process_bio+0x265/0x506 [dm_mod]
> [40800.778140]  [<ffffffff8134f247>] ? _raw_spin_unlock_irqrestore+0xe/0xf
> [40800.778144]  [<ffffffff8103f6b4>] ? try_to_wake_up+0x187/0x197
> [40800.778154]  [<ffffffffa0185a6e>] ? dm_wq_work+0x8c/0xab [dm_mod]
> [40800.778158]  [<ffffffff8105b529>] ? process_one_work+0x161/0x269
> [40800.778163]  [<ffffffff8105c4f2>] ? worker_thread+0xc2/0x145
> [40800.778167]  [<ffffffff8105c430>] ? manage_workers.isra.25+0x15b/0x15b
> [40800.778172]  [<ffffffff8105f631>] ? kthread+0x76/0x7e
> [40800.778177]  [<ffffffff81356374>] ? kernel_thread_helper+0x4/0x10
> [40800.778182]  [<ffffffff8105f5bb>] ? kthread_worker_fn+0x139/0x139
> [40800.778186]  [<ffffffff81356370>] ? gs_change+0x13/0x13
> [40800.778190] INFO: task kworker/0:2:19557 blocked for more than 120
> seconds.
> [40800.778193] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [40800.778196] kworker/0:2     D ffff880077c13780     0 19557      2
> 0x00000000
> [40800.778202]  ffff88006b7e6340 0000000000000046 0000000000000000
> ffff880054d1f1a0
> [40800.778206]  0000000000013780 ffff88000005ffd8 ffff88000005ffd8
> ffff88006b7e6340
> [40800.778211]  ffff880071fede00 ffffffff81070fc1 0000000000000046
> ffff88003734a400
> [40800.778216] Call Trace:
> [40800.778221]  [<ffffffff81070fc1>] ? arch_local_irq_save+0x11/0x17
> [40800.778230]  [<ffffffffa0170466>] ? md_flush_request+0x96/0x111 [md_mod]
> [40800.778235]  [<ffffffff8103f6c4>] ? try_to_wake_up+0x197/0x197
> [40800.778241]  [<ffffffffa0f11711>] ? make_request+0x25/0x37a [raid456]
> [40800.778250]  [<ffffffffa0185873>] ?
> __split_and_process_bio+0x4f4/0x506 [dm_mod]
> [40800.778255]  [<ffffffff8103720c>] ? test_tsk_need_resched+0xa/0x13
> [40800.778260]  [<ffffffff8103afb6>] ? check_preempt_curr+0x52/0x5f
> [40800.778264]  [<ffffffff8103b013>] ? ttwu_do_wakeup+0x50/0xc4
> [40800.778274]  [<ffffffffa016fd47>] ? md_make_request+0xee/0x1db [md_mod]
> [40800.778279]  [<ffffffff8119908a>] ? generic_make_request+0x90/0xcf
> [40800.778284]  [<ffffffff8119919c>] ? submit_bio+0xd3/0xf1
> [40800.778289]  [<ffffffff81120e66>] ? bio_alloc_bioset+0x69/0xb6
> [40800.778308]  [<ffffffffa0f2be8a>] ? _xfs_buf_ioapply+0x17a/0x1bb [xfs]
> [40800.778312]  [<ffffffff8103f6c4>] ? try_to_wake_up+0x197/0x197
> [40800.778337]  [<ffffffffa0f6ba3a>] ? xlog_bdstrat+0x34/0x38 [xfs]
> [40800.778354]  [<ffffffffa0f2bf98>] ? xfs_buf_iorequest+0x62/0x7b [xfs]
> [40800.778379]  [<ffffffffa0f6ba3a>] ? xlog_bdstrat+0x34/0x38 [xfs]
> [40800.778403]  [<ffffffffa0f6c7cc>] ? xlog_sync+0x1dd/0x2d4 [xfs]
> [40800.778428]  [<ffffffffa0f70cd0>] ? xfs_ail_min_lsn+0xd/0x2b [xfs]
> [40800.778452]  [<ffffffffa0f6db4b>] ? xlog_write+0x348/0x545 [xfs]
> [40800.778477]  [<ffffffffa0f6ed2b>] ? xlog_cil_push+0x1e5/0x2fb [xfs]
> [40800.778482]  [<ffffffff81070fc1>] ? arch_local_irq_save+0x11/0x17
> [40800.778507]  [<ffffffffa0f6f351>] ? xlog_cil_force_lsn+0x1d/0x86 [xfs]
> [40800.778531]  [<ffffffffa0f6e0c2>] ? _xfs_log_force_lsn+0x63/0x205 [xfs]
> [40800.778556]  [<ffffffffa0f6b502>] ? xfs_trans_commit+0x10a/0x205 [xfs]
> [40800.778577]  [<ffffffffa0f387d4>] ? xfs_sync_worker+0x3a/0x6a [xfs]
> [40800.778581]  [<ffffffff8105b529>] ? process_one_work+0x161/0x269
> [40800.778586]  [<ffffffff8105c4f2>] ? worker_thread+0xc2/0x145
> [40800.778590]  [<ffffffff8105c430>] ? manage_workers.isra.25+0x15b/0x15b
> [40800.778595]  [<ffffffff8105f631>] ? kthread+0x76/0x7e
> [40800.778600]  [<ffffffff81356374>] ? kernel_thread_helper+0x4/0x10
> [40800.778605]  [<ffffffff8105f5bb>] ? kthread_worker_fn+0x139/0x139
> [40800.778609]  [<ffffffff81356370>] ? gs_change+0x13/0x13
>
> Regards, Hans
>
> Am 22.12.2013 12:19, schrieb NeilBrown:
>> On Sun, 22 Dec 2013 10:01:26 +0100 Hans Kraus <hans@hanswkraus.com>
>> wrote:
>>
>>> Hi,
>>>
>>> my backup system (running backuppc) has developed a weird problem:
>>> calls from command line "mdadm --detail /dev/mdX" block, for every
>>> existing raid on the system, and can be only terminated with ^C. This
>>> is true even for the newest mdadm built from git.
>>>
>>> "cat /proc/mdstat" blocks too. All mounted raids are working (at least
>>> ls <mountpoint> is), exept for one, md127 (the storage of backuppc).
>>> There ls is blocking and is not terminable by ^C.
>>>
>>> The raid structure is the following:
>>> md2, md3, m4    raid1 for swap, /boot, /
>>> md30        raid0 for short term storage
>>> md10, md11, md12, md13    raid0, built from 2x 2TB or 1TB + 3TB drives
>>> md127        raid5 built from md10, md11, md12, md13
>>>
>>> I recently (some 12 hours ago) added md13 again and the system was
>>> rebuilding from a degraded state. The file system on md127 is xfs. All
>>> the physical rives are OK, at least according to smartmontools.
>>> Webmin 1.660 reports:
>>> CPU load averages     16.96 (1 min) 15.04 (5 mins) 12.67 (15 mins)
>>> CPU usage         0% user, 1% kernel, 99% IO, 0% idle
>>>
>>> Is there any way to diagnose the problem further? I'm reluctant to
>>> do a reboot.
>>
>> Either some process has crashed leaving an 'oops' or 'bug' message in the
>> kernel logs, or some process is stuck in 'D' state in 'ps'.
>>
>> So:
>>   1/ look through kernel logs since boot (e.g. output of 'dmesg',
>> though that
>>     might not be complete) for anything  unusual - there should be a
>> stack
>>     trace.
>>   2/ if there is a process in 'D' state, find how which and get a
>> stack trace
>>      of it.  Possibly by
>>       echo w > /proc/sysrq-trigger
>>     or
>>       cat /proc/$PID/stack
>>     or event
>>       echo t > /proc/sysrq-trigger
>>     (though that might create lots of output that might be hard to
>> capture).
>>
>> NeilBrown
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

