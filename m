From: BillStuff <billstuff2001@sbcglobal.net>
Subject: Re: Raid5 hang in 3.14.19
Date: Tue, 30 Sep 2014 16:21:32 -0500
Message-ID: <542B1EDC.7060803@sbcglobal.net>
References: <5425E9D6.1050102@sbcglobal.net>	<20140929122533.3b91a543@notabene.brown>	<5428D863.7090409@sbcglobal.net>	<20140929140818.1086972e@notabene.brown>	<5428DFE1.9080600@sbcglobal.net> <20140930075950.1d1e3865@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140930075950.1d1e3865@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 09/29/2014 04:59 PM, NeilBrown wrote:
> On Sun, 28 Sep 2014 23:28:17 -0500 BillStuff <billstuff2001@sbcglobal.net>
> wrote:
>
>> On 09/28/2014 11:08 PM, NeilBrown wrote:
>>> On Sun, 28 Sep 2014 22:56:19 -0500 BillStuff <billstuff2001@sbcglobal.net>
>>> wrote:
>>>
>>>> On 09/28/2014 09:25 PM, NeilBrown wrote:
>>>>> On Fri, 26 Sep 2014 17:33:58 -0500 BillStuff <billstuff2001@sbcglobal.net>
>>>>> wrote:
>>>>>
>>>>>> Hi Neil,
>>>>>>
>>>>>> I found something that looks similar to the problem described in
>>>>>> "Re: seems like a deadlock in workqueue when md do a flush" from Sept 14th.
>>>>>>
>>>>>> It's on 3.14.19 with 7 recent patches for fixing raid1 recovery hangs.
>>>>>>
>>>>>> on this array:
>>>>>> md3 : active raid5 sdf1[5] sde1[4] sdd1[3] sdc1[2] sdb1[1] sda1[0]
>>>>>>           104171200 blocks level 5, 64k chunk, algorithm 2 [6/6] [UUUUUU]
>>>>>>           bitmap: 1/5 pages [4KB], 2048KB chunk
>>>>>>
>>>>>> I was running a test doing parallel kernel builds, read/write loops, and
>>>>>> disk add / remove / check loops,
>>>>>> on both this array and a raid1 array.
>>>>>>
>>>>>> I was trying to stress test your recent raid1 fixes, which went well,
>>>>>> but then after 5 days,
>>>>>> the raid5 array hung up with this in dmesg:
>>>>> I think this is different to the workqueue problem you mentioned, though as I
>>>>> don't know exactly what caused either I cannot be certain.
>>>>>
>>>>>     From the data you provided it looks like everything is waiting on
>>>>> get_active_stripe(), or on a process that is waiting on that.
>>>>> That seems pretty common whenever anything goes wrong in raid5 :-(
>>>>>
>>>>> The md3_raid5 task is listed as blocked, but not stack trace is given.
>>>>> If the machine is still in the state, then
>>>>>
>>>>>     cat /proc/1698/stack
>>>>>
>>>>> might be useful.
>>>>> (echo t > /proc/sysrq-trigger is always a good idea)
>>>> Might this help? I believe the array was doing a "check" when things
>>>> hung up.
>>> It looks like it was trying to start doing a 'check'.
>>> The 'resync' thread hadn't been started yet.
>>> What is 'kthreadd' doing?
>>> My guess is that it is in try_to_free_pages() waiting for writeout
>>> for some xfs file page onto the md array ... which won't progress until
>>> the thread gets started.
>>>
>>> That would suggest that we need an async way to start threads...
>>>
>>> Thanks,
>>> NeilBrown
>>>
>> I suspect your guess is correct:
> Thanks for the confirmation.
>
> I'm thinking of something like that.  Very basic suggestion suggests it
> instantly crash.
>
> If you were to apply this patch and run your test for a week or two,  that
> would increase my confidence (though of course testing doesn't prove the
> absence of bugs....)
>
> Thanks,
> NeilBrown
>

Neil,

It locked up already, but in a different way.
In this case it was triggered by a re-add in a fail / remove / add loop.

It kinda seems like md3_raid5 tried to "collect" (reap) md3_resync 
before it got fully started.


INFO: task md3_raid5:1698 blocked for more than 120 seconds.
       Tainted: P           O 3.14.19fe-dirty #3
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
  e8371dc4 00000046 c106d92d ea483770 d18a9994 ffd2177f ffffffff e8371dac
  c17d6700 c17d6700 e9d3bcc0 c231bcc0 00000420 e8371d98 00007400 00000088
  00000000 00000000 c33ead90 000003be 00000000 00000005 00000000 0000528b
Call Trace:
  [<c106d92d>] ? __enqueue_entity+0x6d/0x80
  [<c1072683>] ? enqueue_task_fair+0x2d3/0x660
  [<c153e893>] schedule+0x23/0x60
  [<c153dc25>] schedule_timeout+0x145/0x1c0
  [<c1069cb0>] ? default_wake_function+0x10/0x20
  [<c1065698>] ? update_rq_clock.part.92+0x18/0x50
  [<c1067a65>] ? check_preempt_curr+0x65/0x90
  [<c1067aa8>] ? ttwu_do_wakeup+0x18/0x120
  [<c153effb>] wait_for_common+0x9b/0x110
  [<c1069ca0>] ? wake_up_process+0x40/0x40
  [<c153f087>] wait_for_completion+0x17/0x20
  [<c105b241>] kthread_stop+0x41/0xb0
  [<c14540e1>] md_unregister_thread+0x31/0x40
  [<c145a799>] md_reap_sync_thread+0x19/0x140
  [<c145aba8>] md_check_recovery+0xe8/0x480
  [<f3dc3a10>] raid5d+0x20/0x4c0 [raid456]
  [<c104a022>] ? try_to_del_timer_sync+0x42/0x60
  [<c104a081>] ? del_timer_sync+0x41/0x50
  [<c153dbdd>] ? schedule_timeout+0xfd/0x1c0
  [<c10497c0>] ? detach_if_pending+0xa0/0xa0
  [<c10797b4>] ? finish_wait+0x44/0x60
  [<c1454098>] md_thread+0xe8/0x100
  [<c1079990>] ? __wake_up_sync+0x20/0x20
  [<c1453fb0>] ? md_start_sync+0xb0/0xb0
  [<c105ae21>] kthread+0xa1/0xc0
  [<c15418b7>] ret_from_kernel_thread+0x1b/0x28
  [<c105ad80>] ? kthread_create_on_node+0x110/0x110
INFO: task kworker/0:0:12491 blocked for more than 120 seconds.
       Tainted: P           O 3.14.19fe-dirty #3
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
  e6f2ba58 00000046 00000086 00000086 e6f2ba08 c10795ff f395c035 000030ea
  c17d6700 c17d6700 d18a9440 e8973cc0 e6f2ba14 c144fa3d 00000000 e6f2ba2c
  c2054600 f3dbc81b ea5f4c80 c9f64060 c2054600 00000001 c9f64060 e6f2ba5c
Call Trace:
  [<c10795ff>] ? __wake_up+0x3f/0x50
  [<c144fa3d>] ? md_wakeup_thread+0x2d/0x30
  [<f3dbc81b>] ? raid5_unplug+0xbb/0x120 [raid456]
  [<f3dbc81b>] ? raid5_unplug+0xbb/0x120 [raid456]
  [<c153e893>] schedule+0x23/0x60
  [<c153dc25>] schedule_timeout+0x145/0x1c0
  [<c12b1192>] ? blk_finish_plug+0x12/0x40
  [<f3c919f7>] ? _xfs_buf_ioapply+0x287/0x300 [xfs]
  [<c153effb>] wait_for_common+0x9b/0x110
  [<c1069ca0>] ? wake_up_process+0x40/0x40
  [<c153f087>] wait_for_completion+0x17/0x20
  [<f3c91e80>] xfs_buf_iowait+0x50/0xb0 [xfs]
  [<f3c91f17>] ? _xfs_buf_read+0x37/0x40 [xfs]
  [<f3c91f17>] _xfs_buf_read+0x37/0x40 [xfs]
  [<f3c91fa5>] xfs_buf_read_map+0x85/0xe0 [xfs]
  [<f3cefa99>] xfs_trans_read_buf_map+0x1e9/0x3e0 [xfs]
  [<f3caa977>] xfs_alloc_read_agfl+0x97/0xc0 [xfs]
  [<f3cad8a3>] xfs_alloc_fix_freelist+0x193/0x430 [xfs]
  [<f3ce83fe>] ? xlog_grant_sub_space.isra.4+0x1e/0x70 [xfs]
  [<f3cae17e>] xfs_free_extent+0x8e/0x100 [xfs]
  [<c111be1e>] ? kmem_cache_alloc+0xae/0xf0
  [<f3c8e12c>] xfs_bmap_finish+0x13c/0x190 [xfs]
  [<f3cda6f2>] xfs_itruncate_extents+0x1b2/0x2b0 [xfs]
  [<f3c8f0c3>] xfs_free_eofblocks+0x243/0x2e0 [xfs]
  [<f3c9abc6>] xfs_inode_free_eofblocks+0x96/0x140 [xfs]
  [<f3c9ab30>] ? xfs_inode_clear_eofblocks_tag+0x160/0x160 [xfs]
  [<f3c9956d>] xfs_inode_ag_walk.isra.7+0x1cd/0x2f0 [xfs]
  [<f3c9ab30>] ? xfs_inode_clear_eofblocks_tag+0x160/0x160 [xfs]
  [<c12d1631>] ? radix_tree_gang_lookup_tag+0x71/0xb0
  [<f3ce55fb>] ? xfs_perag_get_tag+0x2b/0xb0 [xfs]
  [<f3c9a56d>] ? xfs_inode_ag_iterator_tag+0x3d/0xa0 [xfs]
  [<f3c9a59a>] xfs_inode_ag_iterator_tag+0x6a/0xa0 [xfs]
  [<f3c9ab30>] ? xfs_inode_clear_eofblocks_tag+0x160/0x160 [xfs]
  [<f3c9a82e>] xfs_icache_free_eofblocks+0x2e/0x40 [xfs]
  [<f3c9a858>] xfs_eofblocks_worker+0x18/0x30 [xfs]
  [<c105521c>] process_one_work+0x10c/0x340
  [<c1055d31>] worker_thread+0x101/0x330
  [<c1055c30>] ? manage_workers.isra.27+0x250/0x250
  [<c105ae21>] kthread+0xa1/0xc0
  [<c15418b7>] ret_from_kernel_thread+0x1b/0x28
  [<c105ad80>] ? kthread_create_on_node+0x110/0x110
INFO: task xfs_fsr:24262 blocked for more than 120 seconds.
       Tainted: P           O 3.14.19fe-dirty #3
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
  e4d17aec 00000082 00000096 00000096 e4d17a9c c10795ff 00000000 00000000
  c17d6700 c17d6700 e9d3b7b0 c70a8000 e4d17aa8 c144fa3d 00000000 e4d17ac0
  c2054600 f3dbc81b ea7ace80 d7b74cc0 c2054600 00000002 d7b74cc0 e4d17af0
Call Trace:
  [<c10795ff>] ? __wake_up+0x3f/0x50
  [<c144fa3d>] ? md_wakeup_thread+0x2d/0x30
  [<f3dbc81b>] ? raid5_unplug+0xbb/0x120 [raid456]
  [<f3dbc81b>] ? raid5_unplug+0xbb/0x120 [raid456]
  [<c153e893>] schedule+0x23/0x60
  [<c153dc25>] schedule_timeout+0x145/0x1c0
  [<c12b1192>] ? blk_finish_plug+0x12/0x40
  [<f3c919f7>] ? _xfs_buf_ioapply+0x287/0x300 [xfs]
  [<c153effb>] wait_for_common+0x9b/0x110
  [<c1069ca0>] ? wake_up_process+0x40/0x40
  [<c153f087>] wait_for_completion+0x17/0x20
  [<f3c91e80>] xfs_buf_iowait+0x50/0xb0 [xfs]
  [<f3c91f17>] ? _xfs_buf_read+0x37/0x40 [xfs]
  [<f3c91f17>] _xfs_buf_read+0x37/0x40 [xfs]
  [<f3c91fa5>] xfs_buf_read_map+0x85/0xe0 [xfs]
  [<f3cefa29>] xfs_trans_read_buf_map+0x179/0x3e0 [xfs]
  [<f3cde727>] xfs_imap_to_bp+0x67/0xe0 [xfs]
  [<f3cdec7d>] xfs_iread+0x7d/0x3e0 [xfs]
  [<f3c996e8>] ? xfs_inode_alloc+0x58/0x1b0 [xfs]
  [<f3c9a092>] xfs_iget+0x192/0x580 [xfs]
  [<f3caa219>] ? kmem_free+0x19/0x50 [xfs]
  [<f3ca0ce6>] xfs_bulkstat_one_int+0x86/0x2c0 [xfs]
  [<f3ca0f54>] xfs_bulkstat_one+0x34/0x40 [xfs]
  [<f3ca0c10>] ? xfs_internal_inum+0xa0/0xa0 [xfs]
  [<f3ca1360>] xfs_bulkstat+0x400/0x870 [xfs]
  [<f3c9ae86>] xfs_ioc_bulkstat+0xb6/0x160 [xfs]
  [<f3ca0f20>] ? xfs_bulkstat_one_int+0x2c0/0x2c0 [xfs]
  [<f3c9ccb0>] ? xfs_ioc_swapext+0x160/0x160 [xfs]
  [<f3c9d433>] xfs_file_ioctl+0x783/0xa60 [xfs]
  [<c106bf9b>] ? __update_cpu_load+0xab/0xd0
  [<c105dc58>] ? hrtimer_forward+0xa8/0x1b0
  [<c12d4050>] ? timerqueue_add+0x50/0xb0
  [<c108d143>] ? ktime_get+0x53/0xe0
  [<c1094035>] ? clockevents_program_event+0x95/0x130
  [<f3c9ccb0>] ? xfs_ioc_swapext+0x160/0x160 [xfs]
  [<c11349b2>] do_vfs_ioctl+0x2e2/0x4c0
  [<c1095699>] ? tick_program_event+0x29/0x30
  [<c105e42c>] ? hrtimer_interrupt+0x13c/0x2a0
  [<c12d8dfb>] ? lockref_put_or_lock+0xb/0x30
  [<c1134c08>] SyS_ioctl+0x78/0x80
  [<c1540fa8>] syscall_call+0x7/0x7
INFO: task md3_resync:24817 blocked for more than 120 seconds.
       Tainted: P           O 3.14.19fe-dirty #3
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
  c2d95e08 00000046 00000092 00000000 00000020 00000092 1befb1af 000030e0
  c17d6700 c17d6700 e9d3c6e0 d18a9950 c2d95ddc c12adbc5 00000000 00000001
  00000000 00000001 c2d95dec e95f0000 00000001 c2d95e08 00000292 00000292
Call Trace:
  [<c12adbc5>] ? queue_unplugged+0x45/0x90
  [<c10798bb>] ? prepare_to_wait_event+0x6b/0xd0
  [<c153e893>] schedule+0x23/0x60
  [<c145782d>] md_do_sync+0x8dd/0x1010
  [<c1079990>] ? __wake_up_sync+0x20/0x20
  [<c1453fb0>] ? md_start_sync+0xb0/0xb0
  [<c1454098>] md_thread+0xe8/0x100
  [<c107945f>] ? __wake_up_locked+0x1f/0x30
  [<c1453fb0>] ? md_start_sync+0xb0/0xb0
  [<c105ae21>] kthread+0xa1/0xc0
  [<c15418b7>] ret_from_kernel_thread+0x1b/0x28
  [<c105ad80>] ? kthread_create_on_node+0x110/0x110

Again, the blocked task info is edited for space; hopefully these are 
the important ones,
but I've got more if it helps.

Thanks,
Bill
