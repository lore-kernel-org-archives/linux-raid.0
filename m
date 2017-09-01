From: Dennis Yang <dennisyang@qnap.com>
Subject: Re: [PATCH] md/raid5: preserve STRIPE_ON_UNPLUG_LIST in break_stripe_batch_list
Date: Fri,  1 Sep 2017 17:26:48 +0800
Message-ID: <1504258008-24637-1-git-send-email-dennisyang@qnap.com>
References: <20170901053857.a5qaqhzdevucby6p@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170901053857.a5qaqhzdevucby6p@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: shli@kernel.org
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Dennis Yang <dennisyang@qnap.com>
List-Id: linux-raid.ids

>On Mon, Aug 28, 2017 at 08:01:59PM +0800, Dennis Yang wrote:
>> break_stripe_batch_list() did not preserve STRIPE_ON_UNPLUG_LIST which is
>> set when a stripe_head gets queued to the stripe_head list maintained by
>> raid5_plug_cb and waiting for releasing after blk_unplug().
>> 
>> In release_stripe_plug(), if a stripe_head has its STRIPE_ON_UNPLUG_LIST
>> set, it indicates that this stripe_head is already in the raid5_plug_cb
>> list and release_stripe() would be called instead to drop a reference
>> count. Otherwise, the STRIPE_ON_UNPLUG_LIST bit would be set for this
>> stripe_head and it will get queued into the raid5_plug_cb list.
>> 
>> Without preserving STRIPE_ON_UNPLUG_LIST in break_stripe_batch_list(),
>> a stripe_head could be re-added to the raid5_plug_cb list while it is
>> currently on that list and waiting to be released. This would mess up
>> the raid5_plug_cb and leads to soft/hard lockup in raid5_unplug() or
>> kernel crash.
>
>Did you observe this? From my understanding, this is impossible. If a stripe is
>in batch list (that's why we have break_stripe_batch_list), add_stripe_bio will
>bail out (because sh->batch_head != NULL), so the stripe is never added into
>plug list, hence has the STRIPE_ON_UNPLUG_LIST bit set. Am I missing anything?
>
>Thanks,
>Shaohua

It is hard to reproduce. Our storage exports 4 iscsi LUNs which are built on 
top of a dm-thin pool with 8 x SSD RAID6. Each two of these iscsi LUNs are 
connected to a windows server which runs 4 fio jobs with 16 threads and 
iodepth = 16. In this setup, we can get the following call trace after couples 
of hours. The stack dump basically shows that the raid5_unplug is holding the 
conf->device_lock for a very long time. After adding some debug traces, we can 
confirm that the raid5_plug_cb->list is corrupted which sometimes leads to 
infinite loop in raid5_unplug. 

I didn't notice that add_stripe_bio will bail out if the stripe_head is in 
someone's batch list, but I am wondering if the following scenario will still 
happen. If a stripe_head A is added to another stripe_head B's batch list, in 
this case A will have its batch_head != NULL and be added into the plug list. 
After that, stripe_head B gets handled and called break_stripe_batch_list() to 
reset all the batched stripe_head(including A which is still on the plug list)'s 
state and reset their batch_head to NULL. Before the plug list gets processed, 
if there is another write request comes in and get stripe_head A, A will have 
its batch_head == NULL (cleared by calling break_stripe_batch_list() on B) and 
be added to plug list once again. 

Since we have the environment which can reproduce this issue in 6 hours, if 
there is anything we can do to help resolve this issue, we are more than 
willing to help. 

Thanks,
Dennis

[ 4481.493998] BUG: spinlock lockup suspected on CPU#10, md1_raid6/5497
[ 4481.501109]  lock: 0xffff88102b242888, .magic: dead4ead, .owner: kworker/u24:2/22322, .owner_cpu: 0
[ 4481.511231] CPU: 10 PID: 5497 Comm: md1_raid6 Tainted: P        W  O    4.2.8 #7
[ 4481.519504] Hardware name: Default string Default string/Default string, BIOS QY38AR06 01/24/2017
[ 4481.529429]  ffff88102b242888 ffff881014967c78 ffffffff81c933b6 0000000000000007
[ 4481.537739]  ffff8805c9720a00 ffff881014967c98 ffffffff810d2c20 ffff88102b242888
[ 4481.546048]  0000000082d0f7c8 ffff881014967cc8 ffffffff810d2d9b ffff88102b242888
[ 4481.554357] Call Trace:
[ 4481.557093]  [<ffffffff81c933b6>] dump_stack+0x4c/0x65
[ 4481.562840]  [<ffffffff810d2c20>] spin_dump+0x80/0xd0
[ 4481.568489]  [<ffffffff810d2d9b>] do_raw_spin_lock+0x9b/0x120
[ 4481.574916]  [<ffffffff81ca14d1>] _raw_spin_lock_irq+0x41/0x50
[ 4481.581443]  [<ffffffff816d2204>] ? raid5d+0x64/0x790
[ 4481.587091]  [<ffffffff816d2204>] raid5d+0x64/0x790
[ 4481.592546]  [<ffffffff810c35c6>] ? finish_wait+0x46/0x80
[ 4481.598583]  [<ffffffff810c35e8>] ? finish_wait+0x68/0x80
[ 4481.604621]  [<ffffffff816d8d2e>] md_thread+0x13e/0x150
[ 4481.610464]  [<ffffffff810c37e0>] ? wait_woken+0xb0/0xb0
[ 4481.616405]  [<ffffffff816d8bf0>] ? find_pers+0x80/0x80
[ 4481.622249]  [<ffffffff8109eed5>] kthread+0x105/0x120
[ 4481.627899]  [<ffffffff8109edd0>] ? kthread_create_on_node+0x220/0x220
[ 4481.635201]  [<ffffffff81ca218f>] ret_from_fork+0x3f/0x70
[ 4481.641239]  [<ffffffff8109edd0>] ? kthread_create_on_node+0x220/0x220
[ 4481.654638] NMI backtrace for cpu 0
[ 4481.658536] CPU: 0 PID: 22322 Comm: kworker/u24:2 Tainted: P        W  O    4.2.8 #7
[ 4481.667198] Hardware name: Default string Default string/Default string, BIOS QY38AR06 01/24/2017
[ 4481.677124] Workqueue: writeback wb_workfn (flush-252:15)
[ 4481.683160] task: ffff8805c9720a00 ti: ffff8805c84f8000 task.ti: ffff8805c84f8000
[ 4481.691531] RIP: 0010:[<ffffffff816cd9f1>]  [<ffffffff816cd9f1>] raid5_unplug+0x71/0x270
[ 4481.700582] RSP: 0018:ffff8805c84fb938  EFLAGS: 00000046
[ 4481.706521] RAX: ffff8805cd2ce258 RBX: ffff881038557280 RCX: ffff8805cd2ce258
[ 4481.714502] RDX: ffff8805cd2ce258 RSI: ffff8805cd2ce248 RDI: ffff88102b242000
[ 4481.722483] RBP: ffff8805c84fb978 R08: ffffffff81e0a1c0 R09: 0000000000000000
[ 4481.730464] R10: 0000000000000000 R11: 00000000071775d0 R12: 00000000b921e53c
[ 4481.738445] R13: ffff88102b242000 R14: ffff8810385572a0 R15: ffff88102feec000
[ 4481.746427] FS:  0000000000000000(0000) GS:ffff88107fc00000(0000) knlGS:0000000000000000
[ 4481.755477] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 4481.761904] CR2: 00007fb7bf2d2000 CR3: 0000000fff8df000 CR4: 00000000003406f0
[ 4481.769886] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 4481.777868] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[ 4481.785848] Stack:
[ 4481.788094]  00000000f835a020 ffff88102b242888 ffff8805c84fbb48 ffff8805c84fb9a8
[ 4481.796366]  0000000000000000 ffff8805c84fba28 ffff8805c84fba48 ffff8805c84fb998
[ 4481.804640]  ffff8805c84fb9e8 ffffffff81463c8b ffff8805c84fb9d8 ffffffff81461bb2
[ 4481.812912] Call Trace:
[ 4481.815644]  [<ffffffff81463c8b>] blk_flush_plug_list+0x9b/0x230
[ 4481.822361]  [<ffffffff81461bb2>] ? submit_bio+0x62/0x150
[ 4481.828398]  [<ffffffff81464364>] blk_finish_plug+0x24/0x40
[ 4481.834628]  [<ffffffff812292c3>] mpage_writepages+0x73/0x90
[ 4481.840956]  [<ffffffff81222f90>] ? I_BDEV+0x10/0x10
[ 4481.846506]  [<ffffffff81225380>] qnap_blkdev_writepages+0x10/0x20
[ 4481.853418]  [<ffffffff81188af9>] do_writepages+0x59/0x70
[ 4481.859455]  [<ffffffff81213874>] __writeback_single_inode+0x74/0xa50
[ 4481.866658]  [<ffffffff81214a41>] writeback_sb_inodes+0x2f1/0x680
[ 4481.873472]  [<ffffffff81214e54>] __writeback_inodes_wb+0x84/0xb0
[ 4481.880287]  [<ffffffff812151a9>] wb_writeback+0x329/0x6e0
[ 4482.914006] NMI backtrace for cpu 5
[ 4482.917906] CPU: 5 PID: 26333 Comm: kworker/u24:5 Tainted: P        W  O    4.2.8 #7
[ 4482.926567] Hardware name: Default string Default string/Default string, BIOS QY38AR06 01/24/2017
[ 4482.936492] Workqueue: writeback wb_workfn (flush-252:14)
[ 4482.942529] task: ffff8805c7a74340 ti: ffff8805c6228000 task.ti: ffff8805c6228000
[ 4482.950898] RIP: 0010:[<ffffffff8149cfd7>]  [<ffffffff8149cfd7>] delay_tsc+0x17/0x70
[ 4482.959558] RSP: 0018:ffff8805c622b368  EFLAGS: 00000082
[ 4482.965498] RAX: 00000000dc0ef28f RBX: ffff88102b242888 RCX: 00000000dc0ef259
[ 4482.973479] RDX: 0000000000003c68 RSI: 0000000000000005 RDI: 0000000000000001
[ 4482.981460] RBP: ffff8805c622b368 R08: 0000000000000001 R09: 0000000000000001
[ 4482.989441] R10: 0000000000000000 R11: 0000000000000007 R12: 00000000763815f7
[ 4482.997422] R13: 0000000000000001 R14: 0000000082d0f7c8 R15: ffff88102feec000
[ 4483.005403] FS:  0000000000000000(0000) GS:ffff88107fca0000(0000) knlGS:0000000000000000
[ 4483.014459] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 4483.020876] CR2: 00007f54d805a030 CR3: 0000001006c20000 CR4: 00000000003406e0
[ 4483.028858] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 4483.036840] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[ 4483.044822] Stack:
[ 4483.047069]  ffff8805c622b378 ffffffff8149cf2a ffff8805c622b3a8 ffffffff810d2d87
[ 4483.055341]  ffff88102b242888 0000000000000000 ffff88102b242000 ffff881007d702a0
[ 4483.063613]  ffff8805c622b3d8 ffffffff81ca14d1 ffffffff816cd9ca 0000000000000000
[ 4483.071885] Call Trace:
[ 4483.074617]  [<ffffffff8149cf2a>] __delay+0xa/0x10
[ 4483.079973]  [<ffffffff810d2d87>] do_raw_spin_lock+0x87/0x120
[ 4483.086399]  [<ffffffff81ca14d1>] _raw_spin_lock_irq+0x41/0x50
[ 4483.092920]  [<ffffffff816cd9ca>] ? raid5_unplug+0x4a/0x270
[ 4483.099151]  [<ffffffff816cd9ca>] raid5_unplug+0x4a/0x270
[ 4483.105188]  [<ffffffff81463c8b>] blk_flush_plug_list+0x9b/0x230
[ 4483.111907]  [<ffffffff81c9bf9d>] schedule+0x6d/0x90
[ 4483.117459]  [<ffffffff816c9910>] __get_active_stripe.constprop.61+0x750/0x970
[ 4483.125539]  [<ffffffff810c37e0>] ? wait_woken+0xb0/0xb0
[ 4483.131480]  [<ffffffff816c9d2a>] make_request+0x1fa/0xe30
[ 4483.137616]  [<ffffffff816ddc8e>] ? md_make_request+0x1fe/0x4b0
[ 4483.144238]  [<ffffffff810c37e0>] ? wait_woken+0xb0/0xb0
[ 4483.150179]  [<ffffffff816ddc52>] ? md_make_request+0x1c2/0x4b0
[ 4483.156800]  [<ffffffff816ddc8e>] md_make_request+0x1fe/0x4b0
[ 4483.163227]  [<ffffffff816ddade>] ? md_make_request+0x4e/0x4b0
[ 4483.169750]  [<ffffffff816edd43>] ? dm_make_request+0x73/0x110
[ 4483.176273]  [<ffffffff81461b0e>] generic_make_request+0xce/0x110
