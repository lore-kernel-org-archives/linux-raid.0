From: Dennis Yang <shinrairis@gmail.com>
Subject: Soft/Hard lockup detected in raid5_unplug() when doing heavy I/O on RAID6
Date: Wed, 23 Aug 2017 19:34:08 +0800
Message-ID: <CAKTMprNV5bnCRTdQ7=-OUdTMHHQn54_65ehS8y7VL+GMWF22eg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

I have an issue about I/O freeze and system reboot when doing heavy
I/O (4 fio processes and each with 16 threads and I/O depth=16) on a
RAID6 composed by 8 SSD on linux-4.2.8. The I/O keeps freezing and
system would automatically be rebooted after couple of hours. After
turning on the kernel lockup detection, the following trace shows up
which indicates that raid5_unplug is holding the conf->device_lock for
a very long time.

[ 4481.493998] BUG: spinlock lockup suspected on CPU#10, md1_raid6/5497
[ 4481.501109]  lock: 0xffff88102b242888, .magic: dead4ead, .owner:
kworker/u24:2/22322, .owner_cpu: 0
[ 4481.511231] CPU: 10 PID: 5497 Comm: md1_raid6 Tainted: P        W
O    4.2.8 #7
[ 4481.519504] Hardware name: Default string Default string/Default
string, BIOS QY38AR06 01/24/2017
[ 4481.529429]  ffff88102b242888 ffff881014967c78 ffffffff81c933b6
0000000000000007
[ 4481.537739]  ffff8805c9720a00 ffff881014967c98 ffffffff810d2c20
ffff88102b242888
[ 4481.546048]  0000000082d0f7c8 ffff881014967cc8 ffffffff810d2d9b
ffff88102b242888
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
[ 4481.648540] sending NMI to all CPUs:
[ 4481.654638] NMI backtrace for cpu 0
[ 4481.658536] CPU: 0 PID: 22322 Comm: kworker/u24:2 Tainted: P
W  O    4.2.8 #7
[ 4481.667198] Hardware name: Default string Default string/Default
string, BIOS QY38AR06 01/24/2017
[ 4481.677124] Workqueue: writeback wb_workfn (flush-252:15)
[ 4481.683160] task: ffff8805c9720a00 ti: ffff8805c84f8000 task.ti:
ffff8805c84f8000
[ 4481.691531] RIP: 0010:[<ffffffff816cd9f1>]  [<ffffffff816cd9f1>]
raid5_unplug+0x71/0x270
[ 4481.700582] RSP: 0018:ffff8805c84fb938  EFLAGS: 00000046
[ 4481.706521] RAX: ffff8805cd2ce258 RBX: ffff881038557280 RCX: ffff8805cd2ce258
[ 4481.714502] RDX: ffff8805cd2ce258 RSI: ffff8805cd2ce248 RDI: ffff88102b242000
[ 4481.722483] RBP: ffff8805c84fb978 R08: ffffffff81e0a1c0 R09: 0000000000000000
[ 4481.730464] R10: 0000000000000000 R11: 00000000071775d0 R12: 00000000b921e53c
[ 4481.738445] R13: ffff88102b242000 R14: ffff8810385572a0 R15: ffff88102feec000
[ 4481.746427] FS:  0000000000000000(0000) GS:ffff88107fc00000(0000)
knlGS:0000000000000000
[ 4481.755477] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 4481.761904] CR2: 00007fb7bf2d2000 CR3: 0000000fff8df000 CR4: 00000000003406f0
[ 4481.769886] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 4481.777868] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[ 4481.785848] Stack:
[ 4481.788094]  00000000f835a020 ffff88102b242888 ffff8805c84fbb48
ffff8805c84fb9a8
[ 4481.796366]  0000000000000000 ffff8805c84fba28 ffff8805c84fba48
ffff8805c84fb998
[ 4481.804640]  ffff8805c84fb9e8 ffffffff81463c8b ffff8805c84fb9d8
ffffffff81461bb2
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
[ 4481.886421]  [<ffffffff8121607b>] wb_workfn+0x3bb/0x8c0
[ 4481.892263]  [<ffffffff810988a3>] process_one_work+0x1e3/0x790
[ 4481.898787]  [<ffffffff8109880f>] ? process_one_work+0x14f/0x790
[ 4481.905505]  [<ffffffff81098eb4>] worker_thread+0x64/0x470
[ 4481.911639]  [<ffffffff81098e50>] ? process_one_work+0x790/0x790
[ 4481.918356]  [<ffffffff8109eed5>] kthread+0x105/0x120
[ 4481.924003]  [<ffffffff8109edd0>] ? kthread_create_on_node+0x220/0x220
[ 4481.931303]  [<ffffffff81ca218f>] ret_from_fork+0x3f/0x70
[ 4481.937340]  [<ffffffff8109edd0>] ? kthread_create_on_node+0x220/0x220
[ 4481.944641] Code: c6 3a 5d 00 48 8b 43 20 49 39 c6 74 43 48 8b 08
48 8b 50 08 48 8d 70 f0 48 89 51 08 48 89 0a 48 89 00 48 89 40 08 f0
80 60 3a fb <48> 0f bf 50 36 4c 89 ef 41 83 c4 01 48 83 c2 03 48 c1 e2
04 48
[ 4482.914006] NMI backtrace for cpu 5
[ 4482.917906] CPU: 5 PID: 26333 Comm: kworker/u24:5 Tainted: P
W  O    4.2.8 #7
[ 4482.926567] Hardware name: Default string Default string/Default
string, BIOS QY38AR06 01/24/2017
[ 4482.936492] Workqueue: writeback wb_workfn (flush-252:14)
[ 4482.942529] task: ffff8805c7a74340 ti: ffff8805c6228000 task.ti:
ffff8805c6228000
[ 4482.950898] RIP: 0010:[<ffffffff8149cfd7>]  [<ffffffff8149cfd7>]
delay_tsc+0x17/0x70
[ 4482.959558] RSP: 0018:ffff8805c622b368  EFLAGS: 00000082
[ 4482.965498] RAX: 00000000dc0ef28f RBX: ffff88102b242888 RCX: 00000000dc0ef259
[ 4482.973479] RDX: 0000000000003c68 RSI: 0000000000000005 RDI: 0000000000000001
[ 4482.981460] RBP: ffff8805c622b368 R08: 0000000000000001 R09: 0000000000000001
[ 4482.989441] R10: 0000000000000000 R11: 0000000000000007 R12: 00000000763815f7
[ 4482.997422] R13: 0000000000000001 R14: 0000000082d0f7c8 R15: ffff88102feec000
[ 4483.005403] FS:  0000000000000000(0000) GS:ffff88107fca0000(0000)
knlGS:0000000000000000
[ 4483.014459] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 4483.020876] CR2: 00007f54d805a030 CR3: 0000001006c20000 CR4: 00000000003406e0
[ 4483.028858] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 4483.036840] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[ 4483.044822] Stack:
[ 4483.047069]  ffff8805c622b378 ffffffff8149cf2a ffff8805c622b3a8
ffffffff810d2d87
[ 4483.055341]  ffff88102b242888 0000000000000000 ffff88102b242000
ffff881007d702a0
[ 4483.063613]  ffff8805c622b3d8 ffffffff81ca14d1 ffffffff816cd9ca
0000000000000000
[ 4483.071885] Call Trace:
[ 4483.074617]  [<ffffffff8149cf2a>] __delay+0xa/0x10
[ 4483.079973]  [<ffffffff810d2d87>] do_raw_spin_lock+0x87/0x120
[ 4483.086399]  [<ffffffff81ca14d1>] _raw_spin_lock_irq+0x41/0x50
[ 4483.092920]  [<ffffffff816cd9ca>] ? raid5_unplug+0x4a/0x270
[ 4483.099151]  [<ffffffff816cd9ca>] raid5_unplug+0x4a/0x270
[ 4483.105188]  [<ffffffff81463c8b>] blk_flush_plug_list+0x9b/0x230
[ 4483.111907]  [<ffffffff81c9bf9d>] schedule+0x6d/0x90
[ 4483.117459]  [<ffffffff816c9910>]
__get_active_stripe.constprop.61+0x750/0x970
[ 4483.125539]  [<ffffffff810c37e0>] ? wait_woken+0xb0/0xb0
[ 4483.131480]  [<ffffffff816c9d2a>] make_request+0x1fa/0xe30
[ 4483.137616]  [<ffffffff816ddc8e>] ? md_make_request+0x1fe/0x4b0
[ 4483.144238]  [<ffffffff810c37e0>] ? wait_woken+0xb0/0xb0
[ 4483.150179]  [<ffffffff816ddc52>] ? md_make_request+0x1c2/0x4b0
[ 4483.156800]  [<ffffffff816ddc8e>] md_make_request+0x1fe/0x4b0
[ 4483.163227]  [<ffffffff816ddade>] ? md_make_request+0x4e/0x4b0
[ 4483.169750]  [<ffffffff816edd43>] ? dm_make_request+0x73/0x110
[ 4483.176273]  [<ffffffff81461b0e>] generic_make_request+0xce/0x110
[ 4483.183089]  [<ffffffff81461bb2>] submit_bio+0x62/0x150
[ 4483.188932]  [<ffffffff81229776>] __mpage_writepage+0x446/0x700
[ 4483.195554]  [<ffffffff81184b8a>] ? clear_page_dirty_for_io+0x9a/0x290
[ 4483.202856]  [<ffffffff811d129d>] ? mem_cgroup_end_page_stat+0x2d/0xb0
[ 4483.210157]  [<ffffffff811d12bc>] ? mem_cgroup_end_page_stat+0x4c/0xb0
[ 4483.217458]  [<ffffffff81184c45>] ? clear_page_dirty_for_io+0x155/0x290
[ 4483.224856]  [<ffffffff81184b8a>] ? clear_page_dirty_for_io+0x9a/0x290
[ 4483.232157]  [<ffffffff8118585b>] write_cache_pages+0x26b/0x690
[ 4484.338648] NMI backtrace for cpu 10
[ 4484.342645] CPU: 10 PID: 5497 Comm: md1_raid6 Tainted: P        W
O    4.2.8 #7
[ 4484.350919] Hardware name: Default string Default string/Default
string, BIOS QY38AR06 01/24/2017
[ 4484.360845] task: ffff8810374fa0c0 ti: ffff881014964000 task.ti:
ffff881014964000
[ 4484.369217] RIP: 0010:[<ffffffff8149cff8>]  [<ffffffff8149cff8>]
delay_tsc+0x38/0x70
[ 4484.377878] RSP: 0018:ffff881014967bb8  EFLAGS: 00000083
[ 4484.383819] RAX: 00000000dc1fb693 RBX: 0000000000001000 RCX: 00000000dc1fb67b
[ 4484.391801] RDX: 0000000000000018 RSI: 000000000000000a RDI: 0000000000035953
[ 4484.399784] RBP: ffff881014967bb8 R08: fffffffffffff800 R09: 0000000000000000
[ 4484.407766] R10: 0000000000000001 R11: 000000000000097a R12: 00000000000003e9
[ 4484.415748] R13: 0000000000000400 R14: 0000000000000002 R15: 000000000000000b
[ 4484.423730] FS:  0000000000000000(0000) GS:ffff88107fd40000(0000)
knlGS:0000000000000000
[ 4484.432783] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 4484.439211] CR2: 00007fb839d47e26 CR3: 000000000240b000 CR4: 00000000003406e0
[ 4484.447192] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 4484.455175] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[ 4484.463157] Stack:
[ 4484.465404]  ffff881014967bc8 ffffffff8149cf57 ffff881014967be8
ffffffff8103c4e0
[ 4484.473677]  000000000000a13e ffffffff82577c08 ffff881014967c38
ffffffff8103e4f4
[ 4484.481952]  0000000b821dcb8f 0000000000000092 ffff881014967c58
000000000000c500
[ 4484.490226] Call Trace:
[ 4484.492958]  [<ffffffff8149cf57>] __const_udelay+0x27/0x30
[ 4484.499093]  [<ffffffff8103c4e0>] native_safe_apic_wait_icr_idle+0x20/0x50
[ 4484.506784]  [<ffffffff8103e4f4>]
default_send_IPI_mask_sequence_phys+0xb4/0x100
[ 4484.515057]  [<ffffffff810430d9>] physflat_send_IPI_mask+0x9/0x10
[ 4484.521874]  [<ffffffff8103f5bf>] arch_trigger_all_cpu_backtrace+0x23f/0x250
[ 4484.529758]  [<ffffffff81c933b6>] ? dump_stack+0x4c/0x65
[ 4484.535697]  [<ffffffff810d2da5>] do_raw_spin_lock+0xa5/0x120
[ 4484.542124]  [<ffffffff81ca14d1>] _raw_spin_lock_irq+0x41/0x50
[ 4484.548648]  [<ffffffff816d2204>] ? raid5d+0x64/0x790
[ 4484.554297]  [<ffffffff816d2204>] raid5d+0x64/0x790
[ 4484.559751]  [<ffffffff810c35c6>] ? finish_wait+0x46/0x80
[ 4484.565789]  [<ffffffff810c35e8>] ? finish_wait+0x68/0x80
[ 4484.571825]  [<ffffffff816d8d2e>] md_thread+0x13e/0x150
[ 4484.577667]  [<ffffffff810c37e0>] ? wait_woken+0xb0/0xb0
[ 4484.583606]  [<ffffffff816d8bf0>] ? find_pers+0x80/0x80
[ 4484.589450]  [<ffffffff8109eed5>] kthread+0x105/0x120
[ 4484.595097]  [<ffffffff8109edd0>] ? kthread_create_on_node+0x220/0x220
[ 4484.602399]  [<ffffffff81ca218f>] ret_from_fork+0x3f/0x70
[ 4484.608436]  [<ffffffff8109edd0>] ? kthread_create_on_node+0x220/0x220
[ 4484.615739] Code: 35 66 d1 b6 7e 0f ae e8 0f 31 89 c1 0f ae e8 0f
31 48 c1 e2 20 89 c0 48 09 c2 89 d0 29 ca 39 fa 73 2f 65 ff 0d e2 da
b6 7e f3 90 <65> ff 05 d9 da b6 7e 65 8b 15 32 d1 b6 7e 39 d6 74 cf 29
c1 01

Since raid5_unplug() basically just grab the conf->device_lock and
release any stripe_head with ref equals 1 in the callback stripe_head
list in a while loop, I think the lockup could only happens if the
callback stripe_head list is corrupted. After digging to the source
code and put some debug trace, it seems that sometimes the
release_stripe_plug() would be called with the input stripe_head
having a non-empty sh->lru list, and this causes the problem after
release_stripe_plug() adds it to the callback stripe_head list. Since
a stripe_head would only be linked to another stripe_head list when
its reference count (sh->count) reaches 0 in release_stripe(), I am
not sure if it is okay to add a stripe_head to the callback
stripe_head list without making sure if somebody is still processing
this stripe_head.

Any help would be appreciated.
Thanks!

Dennis
