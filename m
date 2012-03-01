From: Ray Morris <support@bettercgi.com>
Subject: debugging md2_resync hang at raise_barrier
Date: Wed, 29 Feb 2012 18:44:13 -0600
Message-ID: <20120229184413.13db7143@bettercgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I am attempting to debug a hang in raid1 and possibly one raid5.
I have experienced the same problem with many kernel versions
over a couple of years, and with disparate hardware.

My current plan, if noone more experienced suggests I do otherwise, is
to compile a kernel with some printk() in strategic locations and try to 
narrow down the problem. I know very little about kernel work, so I am 
seeking suggestions from those who know better than I.

In the case logged below, it appears to hang at raise_barrier in md2_resync
at raise_barrier, then further access to the device hangs. I'm just a Perl 
programmer who dabbles in C, but my intuition said I check that if perhaps 
lower_barrier had been called with conf->barrier already at zero, so that's
the one printk I've added so far. It may take a week or more before it 
crashes again, so is there any more debugging I should add before waiting 
for it to hang?

Also below is some older logging from similar symptoms with raid5, 
hanging at raid5_quiesce. I got rid of the raid5 in hopes of getting 
rid of the problem, but if anyone has suggestions on how to further 
debug that I maybe be able to add a raid5 array.

The load when I've noticed it is rsync to LVM volumes with snapshots.
After some discussion, lvm-devel suggested linux-raid would be the next 
logical step. Tested kernels include 2.6.32-220.4.1.el6.x86_64 
2.6.32.26-175.fc12.x86_64, vmlinuz-2.6.32.9-70.fc12.x86_64, and others.
Since I already have updated the kernel several times in the last couple 
of years, I figured I'd try some debugging with the current EL 6 kernel.

Anyway, any thoughts on how to debug, where to stick some printk, other 
debugging functions? 


Feb 28 23:16:52 clonebox3 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Feb 28 23:16:52 clonebox3 kernel: md2_resync    D 0000000000000002     0  9681      2 0x00000080
Feb 28 23:16:52 clonebox3 kernel: ffff88006b961bb0 0000000000000046 0000000000000000 0000000300000001
Feb 28 23:16:52 clonebox3 kernel: ffff88006b961b30 ffff88003c9ea7d0 0000000000000286 0000000000000003
Feb 28 23:16:52 clonebox3 kernel: ffff880037c8d038 ffff88006b961fd8 000000000000f4e8 ffff880037c8d038
Feb 28 23:16:52 clonebox3 kernel: Call Trace:
Feb 28 23:16:52 clonebox3 kernel: [<ffffffffa021ae0d>] raise_barrier+0x9d/0x1a0 [raid1]
Feb 28 23:16:52 clonebox3 kernel: [<ffffffff8105e7f0>] ? default_wake_function+0x0/0x20
Feb 28 23:16:52 clonebox3 kernel: [<ffffffffa021c319>] sync_request+0x129/0x6a0 [raid1]
Feb 28 23:16:52 clonebox3 kernel: [<ffffffffa021ad65>] ? md_raid1_unplug_device+0x25/0x30 [raid1]
Feb 28 23:16:52 clonebox3 kernel: [<ffffffff813eaa6d>] md_do_sync+0x6ad/0xbe0
Feb 28 23:16:52 clonebox3 kernel: [<ffffffff813eb236>] md_thread+0x116/0x150
Feb 28 23:16:52 clonebox3 kernel: [<ffffffff813eb120>] ? md_thread+0x0/0x150
Feb 28 23:16:52 clonebox3 kernel: [<ffffffff81090726>] kthread+0x96/0xa0
Feb 28 23:16:52 clonebox3 kernel: [<ffffffff8100c14a>] child_rip+0xa/0x20
Feb 28 23:16:52 clonebox3 kernel: [<ffffffff81090690>] ? kthread+0x0/0xa0
Feb 28 23:16:52 clonebox3 kernel: [<ffffffff8100c140>] ? child_rip+0x0/0x20


Feb 28 23:16:52 clonebox3 kernel: INFO: task kcopyd:10519 blocked for more than 120 seconds.
Feb 28 23:16:52 clonebox3 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Feb 28 23:16:52 clonebox3 kernel: kcopyd        D 0000000000000001     0 10519      2 0x00000080
Feb 28 23:16:52 clonebox3 kernel: ffff88004a76b920 0000000000000046 0000000000000000 0000000300000001
Feb 28 23:16:52 clonebox3 kernel: ffff880079eb0d80 ffff88003c9ea7d0 0000000000000286 0000000000000003
Feb 28 23:16:52 clonebox3 kernel: ffff880036a630b8 ffff88004a76bfd8 000000000000f4e8 ffff880036a630b8
Feb 28 23:16:52 clonebox3 kernel: Call Trace:
Feb 28 23:16:52 clonebox3 kernel: [<ffffffffa021b05d>] wait_barrier+0xed/0x130 [raid1]
Feb 28 23:16:52 clonebox3 kernel: [<ffffffff8105e7f0>] ? default_wake_function+0x0/0x20
Feb 28 23:16:52 clonebox3 kernel: [<ffffffffa021d096>] make_request+0x76/0x820 [raid1]
Feb 28 23:16:52 clonebox3 kernel: [<ffffffffa00016fd>] ? __map_bio+0xad/0x130 [dm_mod]
Feb 28 23:16:52 clonebox3 kernel: [<ffffffffa0002f07>] ? __split_and_process_bio+0x167/0x5d0 [dm_mod]
Feb 28 23:16:52 clonebox3 kernel: [<ffffffff8125e106>] ? throtl_find_tg+0x46/0x60
Feb 28 23:16:52 clonebox3 kernel: [<ffffffff813e9973>] md_make_request+0xd3/0x210
Feb 28 23:16:52 clonebox3 kernel: [<ffffffff8124fe32>] generic_make_request+0x2b2/0x5c0
Feb 28 23:16:52 clonebox3 kernel: [<ffffffffa0002d22>] ? dm_merge_bvec+0xc2/0x140 [dm_mod]
Feb 28 23:16:52 clonebox3 kernel: [<ffffffff812501cf>] submit_bio+0x8f/0x120
Feb 28 23:16:52 clonebox3 kernel: [<ffffffffa0009e2f>] dispatch_io+0x1ff/0x260 [dm_mod]
Feb 28 23:16:52 clonebox3 kernel: [<ffffffffa0009970>] ? list_get_page+0x0/0x30 [dm_mod]
Feb 28 23:16:52 clonebox3 kernel: [<ffffffffa00099a0>] ? list_next_page+0x0/0x20 [dm_mod]
Feb 28 23:16:52 clonebox3 kernel: [<ffffffffa000a960>] ? complete_io+0x0/0xa0 [dm_mod]
Feb 28 23:16:52 clonebox3 kernel: [<ffffffffa000a0d5>] dm_io+0xc5/0x1c0 [dm_mod]
Feb 28 23:16:52 clonebox3 kernel: [<ffffffffa0009970>] ? list_get_page+0x0/0x30 [dm_mod]
Feb 28 23:16:52 clonebox3 kernel: [<ffffffffa00099a0>] ? list_next_page+0x0/0x20 [dm_mod]
Feb 28 23:16:52 clonebox3 kernel: [<ffffffffa000a8f1>] run_io_job+0xa1/0x110 [dm_mod]
Feb 28 23:16:52 clonebox3 kernel: [<ffffffffa000a960>] ? complete_io+0x0/0xa0 [dm_mod]
Feb 28 23:16:52 clonebox3 kernel: [<ffffffffa000a70b>] process_jobs+0x5b/0x100 [dm_mod]
Feb 28 23:16:52 clonebox3 kernel: [<ffffffffa000a850>] ? run_io_job+0x0/0x110 [dm_mod]
Feb 28 23:16:52 clonebox3 kernel: [<ffffffffa000a7b0>] ? do_work+0x0/0xa0 [dm_mod]
Feb 28 23:16:52 clonebox3 kernel: [<ffffffffa000a7fc>] do_work+0x4c/0xa0 [dm_mod]
Feb 28 23:16:52 clonebox3 kernel: [<ffffffff8108b150>] worker_thread+0x170/0x2a0
Feb 28 23:16:52 clonebox3 kernel: [<ffffffff81090a90>] ? autoremove_wake_function+0x0/0x40
Feb 28 23:16:52 clonebox3 kernel: [<ffffffff8108afe0>] ? worker_thread+0x0/0x2a0
Feb 28 23:16:52 clonebox3 kernel: [<ffffffff81090726>] kthread+0x96/0xa0
Feb 28 23:16:52 clonebox3 kernel: [<ffffffff8100c14a>] child_rip+0xa/0x20
Feb 28 23:16:52 clonebox3 kernel: [<ffffffff81090690>] ? kthread+0x0/0xa0
Feb 28 23:16:52 clonebox3 kernel: [<ffffffff8100c140>] ? child_rip+0x0/0x20



Feb 28 23:16:52 clonebox3 kernel: INFO: task kjournald:10618 blocked for more than 120 seconds.
Feb 28 23:16:52 clonebox3 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Feb 28 23:16:52 clonebox3 kernel: kjournald     D 0000000000000002     0 10618      2 0x00000080
Feb 28 23:16:52 clonebox3 kernel: ffff88002557da20 0000000000000046 0000000000000000 0000000300000001
Feb 28 23:16:52 clonebox3 kernel: 0000000000011210 ffff88003c9ea7d0 0000000000000286 0000000000000003
Feb 28 23:16:52 clonebox3 kernel: ffff88006be8e5f8 ffff88002557dfd8 000000000000f4e8 ffff88006be8e5f8
Feb 28 23:16:52 clonebox3 kernel: Call Trace:
Feb 28 23:16:52 clonebox3 kernel: [<ffffffffa021b05d>] wait_barrier+0xed/0x130 [raid1]
Feb 28 23:16:52 clonebox3 kernel: [<ffffffff8105e7f0>] ? default_wake_function+0x0/0x20
Feb 28 23:16:52 clonebox3 kernel: [<ffffffffa021d096>] make_request+0x76/0x820 [raid1]
Feb 28 23:16:52 clonebox3 kernel: [<ffffffffa00016fd>] ? __map_bio+0xad/0x130 [dm_mod]
Feb 28 23:16:52 clonebox3 kernel: [<ffffffffa0002f07>] ? __split_and_process_bio+0x167/0x5d0 [dm_mod]
Feb 28 23:16:52 clonebox3 kernel: [<ffffffff8125e106>] ? throtl_find_tg+0x46/0x60
Feb 28 23:16:52 clonebox3 kernel: [<ffffffff813e9973>] md_make_request+0xd3/0x210
Feb 28 23:16:52 clonebox3 kernel: [<ffffffff8124fe32>] generic_make_request+0x2b2/0x5c0
Feb 28 23:16:52 clonebox3 kernel: [<ffffffff812501cf>] submit_bio+0x8f/0x120
Feb 28 23:16:52 clonebox3 kernel: [<ffffffff811a8046>] submit_bh+0xf6/0x150
Feb 28 23:16:52 clonebox3 kernel: [<ffffffffa01b5644>] journal_commit_transaction+0x1054/0x1310 [jbd]
Feb 28 23:16:52 clonebox3 kernel: [<ffffffff81090a90>] ? autoremove_wake_function+0x0/0x40
Feb 28 23:16:52 clonebox3 kernel: [<ffffffff8107ca1b>] ? try_to_del_timer_sync+0x7b/0xe0
Feb 28 23:16:52 clonebox3 kernel: [<ffffffffa01bab88>] kjournald+0xe8/0x250 [jbd]
Feb 28 23:16:52 clonebox3 kernel: [<ffffffff81090a90>] ? autoremove_wake_function+0x0/0x40
Feb 28 23:16:52 clonebox3 kernel: [<ffffffffa01baaa0>] ? kjournald+0x0/0x250 [jbd]
Feb 28 23:16:52 clonebox3 kernel: [<ffffffff81090726>] kthread+0x96/0xa0
Feb 28 23:16:52 clonebox3 kernel: [<ffffffff8100c14a>] child_rip+0xa/0x20
Feb 28 23:16:52 clonebox3 kernel: [<ffffffff81090690>] ? kthread+0x0/0xa0
Feb 28 23:16:52 clonebox3 kernel: [<ffffffff8100c140>] ? child_rip+0x0/0x20

Feb 28 23:16:52 clonebox3 kernel: INFO: task flush-253:27:10629 blocked for more than 120 seconds.
Feb 28 23:16:52 clonebox3 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Feb 28 23:16:52 clonebox3 kernel: flush-253:27  D 0000000000000000     0 10629      2 0x00000080
Feb 28 23:16:52 clonebox3 kernel: ffff88006c619640 0000000000000046 0000000000000000 0000000300000001
Feb 28 23:16:52 clonebox3 kernel: ffff88006c619660 ffff88003c9ea7d0 0000000000000282 0000000000000003
Feb 28 23:16:52 clonebox3 kernel: ffff8800744dbaf8 ffff88006c619fd8 000000000000f4e8 ffff8800744dbaf8
Feb 28 23:16:52 clonebox3 kernel: Call Trace:
Feb 28 23:16:52 clonebox3 kernel: [<ffffffffa021b05d>] wait_barrier+0xed/0x130 [raid1]
Feb 28 23:16:52 clonebox3 kernel: [<ffffffff8105e7f0>] ? default_wake_function+0x0/0x20
Feb 28 23:16:52 clonebox3 kernel: [<ffffffffa021d096>] make_request+0x76/0x820 [raid1]
Feb 28 23:16:52 clonebox3 kernel: [<ffffffffa00016fd>] ? __map_bio+0xad/0x130 [dm_mod]
Feb 28 23:16:52 clonebox3 kernel: [<ffffffffa0002f07>] ? __split_and_process_bio+0x167/0x5d0 [dm_mod]
Feb 28 23:16:52 clonebox3 kernel: [<ffffffff8125e106>] ?
throtl_find_tg+0x46/0x60
...





Dec 13 09:15:52 clonebox3 kernel: INFO: task kdmflush:31627 blocked for more than 120 seconds.
Dec 13 09:15:52 clonebox3 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Dec 13 09:15:52 clonebox3 kernel: kdmflush      D ffff88007b824300     0 31627      2 0x00000080
Dec 13 09:15:52 clonebox3 kernel: ffff8800372af9f0 0000000000000046 ffff8800372af9b8 ffff8800372af9b4
Dec 13 09:15:52 clonebox3 kernel: ffff8800372af9e0 ffff88007b824300 ffff880001e96980 00000001083f7318
Dec 13 09:15:52 clonebox3 kernel: ffff880076f27ad8 ffff8800372affd8 0000000000010518 ffff880076f27ad8
Dec 13 09:15:52 clonebox3 kernel: Call Trace:
Dec 13 09:15:52 clonebox3 kernel: [<ffffffffa01feca5>] raid5_quiesce+0x125/0x1a0 [raid456]
Dec 13 09:15:52 clonebox3 kernel: [<ffffffff8105c580>] ? default_wake_function+0x0/0x20
Dec 13 09:15:52 clonebox3 kernel: [<ffffffff810563f3>] ? __wake_up+0x53/0x70
Dec 13 09:15:52 clonebox3 kernel: [<ffffffffa02070c1>] make_request+0x501/0x520 [raid456]
Dec 13 09:15:52 clonebox3 kernel: [<ffffffff8102ea69>] ? native_smp_send_reschedule+0x49/0x60
Dec 13 09:15:52 clonebox3 kernel: [<ffffffff810508e8>] ? resched_task+0x68/0x80
Dec 13 09:15:52 clonebox3 kernel: [<ffffffff813d09fb>] md_make_request+0xcb/0x230
Dec 13 09:15:52 clonebox3 kernel: [<ffffffff8105c484>] ? try_to_wake_up+0x284/0x380
Dec 13 09:15:52 clonebox3 kernel: [<ffffffff81241982>] generic_make_request+0x1b2/0x4f0
Dec 13 09:15:52 clonebox3 kernel: [<ffffffff8110e925>] ? mempool_alloc_slab+0x15/0x20
Dec 13 09:15:52 clonebox3 kernel: [<ffffffff8110ea33>] ? mempool_alloc+0x63/0x140
Dec 13 09:15:52 clonebox3 kernel: [<ffffffffa00016bd>] __map_bio+0xad/0x130 [dm_mod]
Dec 13 09:15:52 clonebox3 kernel: [<ffffffffa00017ef>] __issue_target_requests+0xaf/0xd0 [dm_mod]
Dec 13 09:15:52 clonebox3 kernel: [<ffffffffa000351f>] __split_and_process_bio+0x59f/0x630 [dm_mod]
Dec 13 09:15:52 clonebox3 kernel: [<ffffffff8109225c>] ? remove_wait_queue+0x3c/0x50
Dec 13 09:15:52 clonebox3 kernel: [<ffffffffa00029c4>] ? dm_wait_for_completion+0xd4/0x100 [dm_mod]
Dec 13 09:15:52 clonebox3 kernel: [<ffffffffa0003836>] dm_flush+0x56/0x70 [dm_mod]
Dec 13 09:15:52 clonebox3 kernel: [<ffffffffa00038a4>] dm_wq_work+0x54/0x200 [dm_mod]
Dec 13 09:15:52 clonebox3 kernel: [<ffffffffa0003850>] ? dm_wq_work+0x0/0x200 [dm_mod]
Dec 13 09:15:52 clonebox3 kernel: [<ffffffff8108c7d0>] worker_thread+0x170/0x2a0
Dec 13 09:15:52 clonebox3 kernel: [<ffffffff81091ea0>] ? autoremove_wake_function+0x0/0x40
Dec 13 09:15:52 clonebox3 kernel: [<ffffffff8108c660>] ? worker_thread+0x0/0x2a0
Dec 13 09:15:52 clonebox3 kernel: [<ffffffff81091b36>] kthread+0x96/0xa0
Dec 13 09:15:52 clonebox3 kernel: [<ffffffff810141ca>] child_rip+0xa/0x20
Dec 13 09:15:52 clonebox3 kernel: [<ffffffff81091aa0>] ? kthread+0x0/0xa0
Dec 13 09:15:52 clonebox3 kernel: [<ffffffff810141c0>] ? child_rip+0x0/0x20
Dec 13 09:15:52 clonebox3 kernel: INFO: task kcopyd:31629 blocked for more than 120 seconds.
Dec 13 09:15:52 clonebox3 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Dec 13 09:15:52 clonebox3 kernel: kcopyd        D ffff88007b824700     0 31629      2 0x00000080
Dec 13 09:15:52 clonebox3 kernel: ffff880044aa7ac0 0000000000000046 ffff880044aa7a88 ffff880044aa7a84
Dec 13 09:15:52 clonebox3 kernel: ffff880044aa7ae0 ffff88007b824700 ffff880001e16980 00000001083f7280
-- 
Ray Morris
support@bettercgi.com

Strongbox - The next generation in site security:
http://www.bettercgi.com/strongbox/

Throttlebox - Intelligent Bandwidth Control
http://www.bettercgi.com/throttlebox/

Strongbox / Throttlebox affiliate program:
http://www.bettercgi.com/affiliates/user/register.php




