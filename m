From: Konstantinos Skarlatos <k.skarlatos@gmail.com>
Subject: Re: Hang in Raid-5 code (Old bug back?)
Date: Thu, 16 Feb 2012 15:43:26 +0200
Message-ID: <4F3D07FE.6010601@gmail.com>
References: <1363014.L0fQ1kFyFY@eseries> <8881584.REWxvMC81A@eseries>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8881584.REWxvMC81A@eseries>
Sender: linux-raid-owner@vger.kernel.org
To: Dag Nygren <dag@newtech.fi>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On =CE=A0=CE=AD=CE=BC=CF=80=CF=84=CE=B7, 9 =CE=A6=CE=B5=CE=B2=CF=81=CE=BF=
=CF=85=CE=AC=CF=81=CE=B9=CE=BF=CF=82 2012 4:55:11 =CF=80=CE=BC, Dag Nyg=
ren wrote:
> s=C3=B6ndag 05 februari 2012 18:55:58 skrev  Dag Nygren:
>> Hi!
>>
>> Using lessfs on top of an XFS on top on a software RAID-5 and see th=
is
>> freeze happening about once a week. Usually during heavy load.
>
> No comments on the stuff below? Nobody else?

I also have frequent freezes on two raid5 arrays on different systems.=20
kernels tested are 3.1 and 3.2.
system1: raid5-xfs-btrfs loop
system2: raid5-btrfs

when the freezes happen, iostat -xk 1 gives 100% usage on one random=20
disk.
Here are some kernel messages from the raid5-xfs-loop btrfs system.

[Mon Jan 30 20:07:10 2012] INFO: task rsync:18646 blocked for more than=
=20
120 seconds.
[Mon Jan 30 20:07:10 2012] "echo 0 >=20
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
[Mon Jan 30 20:07:10 2012] rsync           D 0000000105d6f258     0=20
18646  18645 0x00000000
[Mon Jan 30 20:07:10 2012]  ffff88013bb39a78 0000000000000086=20
ffff880100000000 ffffffffa05086ba
[Mon Jan 30 20:07:10 2012]  ffff880200e94020 ffff88013bb39fd8=20
ffff88013bb39fd8 ffff88013bb39fd8
[Mon Jan 30 20:07:10 2012]  ffff880202d21c80 ffff880200e94020=20
ffff8800b14b2900 ffff88013bb39a18
[Mon Jan 30 20:07:10 2012] Call Trace:
[Mon Jan 30 20:07:10 2012]  [<ffffffffa05086ba>] ?=20
btrfs_queue_worker+0x1ea/0x300 [btrfs]
[Mon Jan 30 20:07:10 2012]  [<ffffffffa04e70c5>] ?=20
run_delalloc_range+0x185/0x360 [btrfs]
[Mon Jan 30 20:07:10 2012]  [<ffffffff8101d639>] ? read_tsc+0x9/0x20
[Mon Jan 30 20:07:10 2012]  [<ffffffff8109271d>] ?=20
ktime_get_ts+0xad/0xe0
[Mon Jan 30 20:07:10 2012]  [<ffffffff8101d639>] ? read_tsc+0x9/0x20
[Mon Jan 30 20:07:10 2012]  [<ffffffff811055d0>] ? __lock_page+0x70/0x7=
0
[Mon Jan 30 20:07:10 2012]  [<ffffffff814258bf>] schedule+0x3f/0x60
[Mon Jan 30 20:07:10 2012]  [<ffffffff8142596f>] io_schedule+0x8f/0xd0
[Mon Jan 30 20:07:10 2012]  [<ffffffff811055de>] sleep_on_page+0xe/0x20
[Mon Jan 30 20:07:10 2012]  [<ffffffff8142611f>] __wait_on_bit+0x5f/0x9=
0
[Mon Jan 30 20:07:10 2012]  [<ffffffff811057c8>]=20
wait_on_page_bit+0x78/0x80
[Mon Jan 30 20:07:10 2012]  [<ffffffff81088cf0>] ?=20
autoremove_wake_function+0x40/0x40
[Mon Jan 30 20:07:10 2012]  [<ffffffffa04fe5e5>]=20
extent_write_cache_pages.isra.22.constprop.30+0x295/0x3f0 [btrfs]
[Mon Jan 30 20:07:10 2012]  [<ffffffff81150d3b>] ?=20
kmem_cache_free+0x13b/0x150
[Mon Jan 30 20:07:10 2012]  [<ffffffffa04fa6e7>] ?=20
free_extent_state+0x37/0x60 [btrfs]
[Mon Jan 30 20:07:10 2012]  [<ffffffffa04fe985>]=20
extent_writepages+0x45/0x60 [btrfs]
[Mon Jan 30 20:07:10 2012]  [<ffffffffa04e3790>] ?=20
uncompress_inline.isra.47+0x1d0/0x1d0 [btrfs]
[Mon Jan 30 20:07:10 2012]  [<ffffffffa04e2a78>]=20
btrfs_writepages+0x28/0x30 [btrfs]
[Mon Jan 30 20:07:10 2012]  [<ffffffff81110ff4>] do_writepages+0x24/0x4=
0
[Mon Jan 30 20:07:10 2012]  [<ffffffff8110686b>]=20
__filemap_fdatawrite_range+0x5b/0x60
[Mon Jan 30 20:07:10 2012]  [<ffffffff811077e3>]=20
filemap_fdatawrite_range+0x13/0x20
[Mon Jan 30 20:07:10 2012]  [<ffffffffa04f92e6>]=20
btrfs_wait_ordered_range+0x66/0x150 [btrfs]
[Mon Jan 30 20:07:10 2012]  [<ffffffffa04e8c28>]=20
btrfs_truncate+0xc8/0x670 [btrfs]
[Mon Jan 30 20:07:10 2012]  [<ffffffffa04eaad1>]=20
btrfs_setattr+0xc1/0x1b0 [btrfs]
[Mon Jan 30 20:07:10 2012]  [<ffffffff811827a2>]=20
notify_change+0x1a2/0x340
[Mon Jan 30 20:07:10 2012]  [<ffffffff811656be>] do_truncate+0x5e/0xa0
[Mon Jan 30 20:07:10 2012]  [<ffffffff81165985>]=20
sys_ftruncate+0xd5/0x120
[Mon Jan 30 20:07:10 2012]  [<ffffffff814290c2>]=20
system_call_fastpath+0x16/0x1b
[Mon Jan 30 22:37:10 2012] INFO: task btrfs-delayed-m:24548 blocked for=
=20
more than 120 seconds.
[Mon Jan 30 22:37:10 2012] "echo 0 >=20
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
[Mon Jan 30 22:37:10 2012] btrfs-delayed-m D 0000000106001847     0=20
24548      2 0x00000000
[Mon Jan 30 22:37:10 2012]  ffff8800014f3510 0000000000000046=20
0000000000000000 0000000000000286
[Mon Jan 30 22:37:10 2012]  ffff880201804e60 ffff8800014f3fd8=20
ffff8800014f3fd8 ffff8800014f3fd8
[Mon Jan 30 22:37:10 2012]  ffffffff8180d020 ffff880201804e60=20
ffffffff811239c9 ffff880201804e60
[Mon Jan 30 22:37:10 2012] Call Trace:
[Mon Jan 30 22:37:10 2012]  [<ffffffff811239c9>] ?=20
zone_statistics+0x99/0xc0
[Mon Jan 30 22:37:10 2012]  [<ffffffff81108065>] ?=20
mempool_alloc_slab+0x15/0x20
[Mon Jan 30 22:37:10 2012]  [<ffffffff8104f4b5>] ?=20
cpuacct_charge+0x65/0x70
[Mon Jan 30 22:37:10 2012]  [<ffffffff814258bf>] schedule+0x3f/0x60
[Mon Jan 30 22:37:10 2012]  [<ffffffff81427e75>]=20
rwsem_down_failed_common+0xc5/0x160
[Mon Jan 30 22:37:10 2012]  [<ffffffff81427f23>]=20
rwsem_down_write_failed+0x13/0x20
[Mon Jan 30 22:37:10 2012]  [<ffffffff81241fa3>]=20
call_rwsem_down_write_failed+0x13/0x20
[Mon Jan 30 22:37:10 2012]  [<ffffffff81427545>] ? down_write+0x25/0x27
[Mon Jan 30 22:37:10 2012]  [<ffffffffa04c74e9>]=20
cache_block_group+0x229/0x3d0 [btrfs]
[Mon Jan 30 22:37:10 2012]  [<ffffffff81088cb0>] ?=20
abort_exclusive_wait+0xb0/0xb0
[Mon Jan 30 22:37:10 2012]  [<ffffffffa04cc2a8>]=20
find_free_extent.constprop.67+0xab8/0xb20 [btrfs]
[Mon Jan 30 22:37:10 2012]  [<ffffffff8109271d>] ?=20
ktime_get_ts+0xad/0xe0
[Mon Jan 30 22:37:10 2012]  [<ffffffffa04cf7b8>]=20
btrfs_reserve_extent+0xe8/0x220 [btrfs]
[Mon Jan 30 22:37:10 2012]  [<ffffffffa04cfe08>]=20
btrfs_alloc_free_block+0x178/0x350 [btrfs]
[Mon Jan 30 22:37:10 2012]  [<ffffffffa04bee62>]=20
__btrfs_cow_block+0x122/0x430 [btrfs]
[Mon Jan 30 22:37:10 2012]  [<ffffffffa04bf266>]=20
btrfs_cow_block+0xf6/0x250 [btrfs]
[Mon Jan 30 22:37:10 2012]  [<ffffffffa050e2e0>] ?=20
btrfs_set_lock_blocking_rw+0x50/0xb0 [btrfs]
[Mon Jan 30 22:37:10 2012]  [<ffffffffa04c2dde>]=20
btrfs_search_slot+0x18e/0x8a0 [btrfs]
[Mon Jan 30 22:37:10 2012]  [<ffffffffa04c81bb>]=20
lookup_inline_extent_backref+0x9b/0x460 [btrfs]
[Mon Jan 30 22:37:10 2012]  [<ffffffffa04c9073>]=20
insert_inline_extent_backref+0x63/0xe0 [btrfs]
[Mon Jan 30 22:37:10 2012]  [<ffffffffa04c918e>]=20
__btrfs_inc_extent_ref.isra.57+0x9e/0x1d0 [btrfs]
[Mon Jan 30 22:37:10 2012]  [<ffffffffa04ce1c6>]=20
run_clustered_refs+0x496/0x810 [btrfs]
[Mon Jan 30 22:37:10 2012]  [<ffffffffa051b100>] ?=20
btrfs_find_ref_cluster+0xe0/0x190 [btrfs]
[Mon Jan 30 22:37:10 2012]  [<ffffffffa04ce608>]=20
btrfs_run_delayed_refs+0xc8/0x220 [btrfs]
[Mon Jan 30 22:37:10 2012]  [<ffffffffa04df96e>]=20
__btrfs_end_transaction+0xbe/0x310 [btrfs]
[Mon Jan 30 22:37:10 2012]  [<ffffffffa04dfbd8>]=20
btrfs_end_transaction_dmeta+0x18/0x20 [btrfs]
[Mon Jan 30 22:37:10 2012]  [<ffffffffa0524b48>]=20
btrfs_async_run_delayed_node_done+0xd8/0x1a0 [btrfs]
[Mon Jan 30 22:37:10 2012]  [<ffffffffa0508920>]=20
worker_loop+0x150/0x520 [btrfs]
[Mon Jan 30 22:37:10 2012]  [<ffffffffa05087d0>] ?=20
btrfs_queue_worker+0x300/0x300 [btrfs]
[Mon Jan 30 22:37:10 2012]  [<ffffffff8108836c>] kthread+0x8c/0xa0
[Mon Jan 30 22:37:10 2012]  [<ffffffff8142b234>]=20
kernel_thread_helper+0x4/0x10
[Mon Jan 30 22:37:10 2012]  [<ffffffff810882e0>] ?=20
kthread_worker_fn+0x190/0x190
[Mon Jan 30 22:37:10 2012]  [<ffffffff8142b230>] ? gs_change+0x13/0x13
[Mon Jan 30 22:37:10 2012] INFO: task btrfs-delayed-m:24550 blocked for=
=20
more than 120 seconds.
[Mon Jan 30 22:37:10 2012] "echo 0 >=20
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
[Mon Jan 30 22:37:10 2012] btrfs-delayed-m D 000000010600185f     0=20
24550      2 0x00000000
[Mon Jan 30 22:37:10 2012]  ffff88001b521630 0000000000000046=20
ffff88001b521570 ffffffff8105c001
[Mon Jan 30 22:37:10 2012]  ffff8801ce0d23a0 ffff88001b521fd8=20
ffff88001b521fd8 ffff88001b521fd8
[Mon Jan 30 22:37:10 2012]  ffff880202d21c80 ffff8801ce0d23a0=20
ffff8801ce0d23e8 0000000000000001
[Mon Jan 30 22:37:10 2012] Call Trace:
[Mon Jan 30 22:37:10 2012]  [<ffffffff8105c001>] ?=20
update_curr+0x121/0x1f0
[Mon Jan 30 22:37:10 2012]  [<ffffffff81151f13>] ?=20
kmem_cache_alloc+0x133/0x160
[Mon Jan 30 22:37:10 2012]  [<ffffffff81150c2f>] ?=20
kmem_cache_free+0x2f/0x150
[Mon Jan 30 22:37:10 2012]  [<ffffffff81181948>] ? iput+0x48/0x210
[Mon Jan 30 22:37:10 2012]  [<ffffffffa051405d>] ?=20
tree_search_offset.isra.24+0x1ed/0x230 [btrfs]
[Mon Jan 30 22:37:10 2012]  [<ffffffff81151d03>] ?=20
kmem_cache_alloc_trace+0x133/0x160
[Mon Jan 30 22:37:10 2012]  [<ffffffff814258bf>] schedule+0x3f/0x60
[Mon Jan 30 22:37:10 2012]  [<ffffffffa04c7192>]=20
wait_block_group_cache_progress+0xe2/0x110 [btrfs]
[Mon Jan 30 22:37:10 2012]  [<ffffffff81088cb0>] ?=20
abort_exclusive_wait+0xb0/0xb0
[Mon Jan 30 22:37:10 2012]  [<ffffffff81088cb0>] ?=20
abort_exclusive_wait+0xb0/0xb0
[Mon Jan 30 22:37:10 2012]  [<ffffffffa04cbbbd>]=20
find_free_extent.constprop.67+0x3cd/0xb20 [btrfs]
[Mon Jan 30 22:37:10 2012]  [<ffffffff8109271d>] ?=20
ktime_get_ts+0xad/0xe0
[Mon Jan 30 22:37:10 2012]  [<ffffffffa04cf7b8>]=20
btrfs_reserve_extent+0xe8/0x220 [btrfs]
[Mon Jan 30 22:37:10 2012]  [<ffffffffa04cfe08>]=20
btrfs_alloc_free_block+0x178/0x350 [btrfs]
[Mon Jan 30 22:37:10 2012]  [<ffffffffa04bee62>]=20
__btrfs_cow_block+0x122/0x430 [btrfs]
[Mon Jan 30 22:37:10 2012]  [<ffffffffa04bf266>]=20
btrfs_cow_block+0xf6/0x250 [btrfs]
[Mon Jan 30 22:37:10 2012]  [<ffffffffa050e2e0>] ?=20
btrfs_set_lock_blocking_rw+0x50/0xb0 [btrfs]
[Mon Jan 30 22:37:10 2012]  [<ffffffffa04c2dde>]=20
btrfs_search_slot+0x18e/0x8a0 [btrfs]
[Mon Jan 30 22:37:10 2012]  [<ffffffffa04c602d>] ?=20
find_next_key+0xdd/0xf0 [btrfs]
[Mon Jan 30 22:37:10 2012]  [<ffffffffa04c45ac>]=20
btrfs_insert_empty_items+0x7c/0xe0 [btrfs]
[Mon Jan 30 22:37:10 2012]  [<ffffffffa04c8845>]=20
insert_extent_data_ref+0x65/0x2a0 [btrfs]
[Mon Jan 30 22:37:10 2012]  [<ffffffffa04c92ad>]=20
__btrfs_inc_extent_ref.isra.57+0x1bd/0x1d0 [btrfs]
[Mon Jan 30 22:37:10 2012]  [<ffffffffa04cdfd2>]=20
run_clustered_refs+0x2a2/0x810 [btrfs]
[Mon Jan 30 22:37:10 2012]  [<ffffffffa051b100>] ?=20
btrfs_find_ref_cluster+0xe0/0x190 [btrfs]
[Mon Jan 30 22:37:10 2012]  [<ffffffffa04ce608>]=20
btrfs_run_delayed_refs+0xc8/0x220 [btrfs]
[Mon Jan 30 22:37:10 2012]  [<ffffffffa04df96e>]=20
__btrfs_end_transaction+0xbe/0x310 [btrfs]
[Mon Jan 30 22:37:10 2012]  [<ffffffffa04dfbd8>]=20
btrfs_end_transaction_dmeta+0x18/0x20 [btrfs]
[Mon Jan 30 22:37:10 2012]  [<ffffffffa0524b48>]=20
btrfs_async_run_delayed_node_done+0xd8/0x1a0 [btrfs]
[Mon Jan 30 22:37:10 2012]  [<ffffffffa0508920>]=20
worker_loop+0x150/0x520 [btrfs]
[Mon Jan 30 22:37:10 2012]  [<ffffffffa05087d0>] ?=20
btrfs_queue_worker+0x300/0x300 [btrfs]
[Mon Jan 30 22:37:10 2012]  [<ffffffff8108836c>] kthread+0x8c/0xa0
[Mon Jan 30 22:37:10 2012]  [<ffffffff8142b234>]=20
kernel_thread_helper+0x4/0x10
[Mon Jan 30 22:37:10 2012]  [<ffffffff810882e0>] ?=20
kthread_worker_fn+0x190/0x190
[Mon Jan 30 22:37:10 2012]  [<ffffffff8142b230>] ? gs_change+0x13/0x13
[Tue Jan 31 12:55:10 2012] INFO: task btrfs-transacti:21407 blocked for=
=20
more than 120 seconds.
[Tue Jan 31 12:55:10 2012] "echo 0 >=20
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
[Tue Jan 31 12:55:10 2012] btrfs-transacti D 0000000106ebce55     0=20
21407      2 0x00000000
[Tue Jan 31 12:55:10 2012]  ffff8801d9573bc0 0000000000000046=20
ffffffff8142514e ffff880201a88000
[Tue Jan 31 12:55:10 2012]  ffff880201f9c740 ffff8801d9573fd8=20
ffff8801d9573fd8 ffff8801d9573fd8
[Tue Jan 31 12:55:10 2012]  ffff880202cb4e60 ffff880201f9c740=20
ffffffffa04fa601 ffff880071022e70
[Tue Jan 31 12:55:10 2012] Call Trace:
[Tue Jan 31 12:55:10 2012]  [<ffffffff8142514e>] ?=20
__schedule+0x33e/0x980
[Tue Jan 31 12:55:10 2012]  [<ffffffffa04fa601>] ?=20
extent_io_exit+0xd1/0x130 [btrfs]
[Tue Jan 31 12:55:10 2012]  [<ffffffff8101d639>] ? read_tsc+0x9/0x20
[Tue Jan 31 12:55:10 2012]  [<ffffffff8109271d>] ?=20
ktime_get_ts+0xad/0xe0
[Tue Jan 31 12:55:10 2012]  [<ffffffff8122d436>] ?=20
throtl_find_tg+0x46/0x60
[Tue Jan 31 12:55:10 2012]  [<ffffffff8122dd1a>] ?=20
blk_throtl_bio+0x1fa/0x5f0
[Tue Jan 31 12:55:10 2012]  [<ffffffff811055d0>] ? __lock_page+0x70/0x7=
0
[Tue Jan 31 12:55:10 2012]  [<ffffffff810d4934>] ?=20
__delayacct_blkio_end+0x34/0x60
[Tue Jan 31 12:55:10 2012]  [<ffffffff814258bf>] schedule+0x3f/0x60
[Tue Jan 31 12:55:10 2012]  [<ffffffff81425fd5>]=20
schedule_timeout+0x305/0x390
[Tue Jan 31 12:55:10 2012]  [<ffffffff8104f373>] ? __wake_up+0x53/0x70
[Tue Jan 31 12:55:10 2012]  [<ffffffff81424b48>]=20
wait_for_common+0xc8/0x160
[Tue Jan 31 12:55:10 2012]  [<ffffffff8105f060>] ?=20
try_to_wake_up+0x290/0x290
[Tue Jan 31 12:55:10 2012]  [<ffffffff81424bfd>]=20
wait_for_completion+0x1d/0x20
[Tue Jan 31 12:55:10 2012]  [<ffffffffa04d81db>]=20
write_dev_flush+0x4b/0x140 [btrfs]
[Tue Jan 31 12:55:10 2012]  [<ffffffffa04da1b6>]=20
write_all_supers+0x6f6/0x800 [btrfs]
[Tue Jan 31 12:55:10 2012]  [<ffffffffa04da2d3>]=20
write_ctree_super+0x13/0x20 [btrfs]
[Tue Jan 31 12:55:10 2012]  [<ffffffffa04df63d>]=20
btrfs_commit_transaction+0x63d/0x880 [btrfs]
[Tue Jan 31 12:55:10 2012]  [<ffffffff81088cb0>] ?=20
abort_exclusive_wait+0xb0/0xb0
[Tue Jan 31 12:55:10 2012]  [<ffffffffa04dfcd4>] ?=20
start_transaction+0x94/0x2b0 [btrfs]
[Tue Jan 31 12:55:10 2012]  [<ffffffffa04d7e6d>]=20
transaction_kthread+0x26d/0x290 [btrfs]
[Tue Jan 31 12:55:10 2012]  [<ffffffffa04d7c00>] ?=20
btrfs_congested_fn+0xd0/0xd0 [btrfs]
[Tue Jan 31 12:55:10 2012]  [<ffffffff8108836c>] kthread+0x8c/0xa0
[Tue Jan 31 12:55:10 2012]  [<ffffffff8142b234>]=20
kernel_thread_helper+0x4/0x10
[Tue Jan 31 12:55:10 2012]  [<ffffffff810882e0>] ?=20
kthread_worker_fn+0x190/0x190
[Tue Jan 31 12:55:10 2012]  [<ffffffff8142b230>] ? gs_change+0x13/0x13
[Tue Jan 31 12:55:10 2012] INFO: task rsync:13574 blocked for more than=
=20
120 seconds.
[Tue Jan 31 12:55:10 2012] "echo 0 >=20
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
[Tue Jan 31 12:55:10 2012] rsync           D 0000000106ebce49     0=20
13574  12299 0x00000000
[Tue Jan 31 12:55:10 2012]  ffff880012c29758 0000000000000082=20
ffff880000000000 ffffffff8104f373
[Tue Jan 31 12:55:10 2012]  ffff880202355ca0 ffff880012c29fd8=20
ffff880012c29fd8 ffff880012c29fd8
[Tue Jan 31 12:55:10 2012]  ffff880202cb7200 ffff880202355ca0=20
ffff880012c296a8 ffffffffa01a31be
[Tue Jan 31 12:55:10 2012] Call Trace:
[Tue Jan 31 12:55:10 2012]  [<ffffffff8104f373>] ? __wake_up+0x53/0x70
[Tue Jan 31 12:55:10 2012]  [<ffffffffa01a31be>] ?=20
loop_make_request+0xde/0x110 [loop]
[Tue Jan 31 12:55:10 2012]  [<ffffffff8121d877>] ?=20
generic_make_request+0xc7/0x100
[Tue Jan 31 12:55:10 2012]  [<ffffffff8121d937>] ? submit_bio+0x87/0x11=
0
[Tue Jan 31 12:55:10 2012]  [<ffffffff8101d639>] ? read_tsc+0x9/0x20
[Tue Jan 31 12:55:10 2012]  [<ffffffff811055d0>] ? __lock_page+0x70/0x7=
0
[Tue Jan 31 12:55:10 2012]  [<ffffffff814258bf>] schedule+0x3f/0x60
[Tue Jan 31 12:55:10 2012]  [<ffffffff8142596f>] io_schedule+0x8f/0xd0
[Tue Jan 31 12:55:10 2012]  [<ffffffff811055de>] sleep_on_page+0xe/0x20
[Tue Jan 31 12:55:10 2012]  [<ffffffff8142611f>] __wait_on_bit+0x5f/0x9=
0
[Tue Jan 31 12:55:10 2012]  [<ffffffff811057c8>]=20
wait_on_page_bit+0x78/0x80
[Tue Jan 31 12:55:10 2012]  [<ffffffff81088cf0>] ?=20
autoremove_wake_function+0x40/0x40
[Tue Jan 31 12:55:10 2012]  [<ffffffffa04ffe66>]=20
read_extent_buffer_pages+0x476/0x510 [btrfs]
[Tue Jan 31 12:55:10 2012]  [<ffffffffa04d6f90>] ?=20
verify_parent_transid+0x160/0x160 [btrfs]
[Tue Jan 31 12:55:10 2012]  [<ffffffffa04d815a>]=20
btree_read_extent_buffer_pages.isra.100+0x8a/0xc0 [btrfs]
[Tue Jan 31 12:55:10 2012]  [<ffffffffa04d98f1>]=20
read_tree_block+0x41/0x60 [btrfs]
[Tue Jan 31 12:55:10 2012]  [<ffffffffa04c0ca3>]=20
read_block_for_search.isra.33+0xf3/0x3d0 [btrfs]
[Tue Jan 31 12:55:10 2012]  [<ffffffffa04c0577>] ?=20
generic_bin_search.constprop.35+0xe7/0x160 [btrfs]
[Tue Jan 31 12:55:10 2012]  [<ffffffffa04c2fe0>]=20
btrfs_search_slot+0x390/0x8a0 [btrfs]
[Tue Jan 31 12:55:10 2012]  [<ffffffffa04d5eef>]=20
btrfs_lookup_inode+0x2f/0xa0 [btrfs]
[Tue Jan 31 12:55:10 2012]  [<ffffffffa04e9b31>] btrfs_iget+0x101/0x490=
=20
[btrfs]
[Tue Jan 31 12:55:10 2012]  [<ffffffff8117a210>] ? __pollwait+0xf0/0xf0
[Tue Jan 31 12:55:10 2012]  [<ffffffff8117d000>] ? d_validate+0x10/0xb0
[Tue Jan 31 12:55:10 2012]  [<ffffffffa04ea793>]=20
btrfs_lookup_dentry+0x453/0x4e0 [btrfs]
[Tue Jan 31 12:55:10 2012]  [<ffffffff8117f3e5>] ? __d_lookup+0xb5/0x17=
0
[Tue Jan 31 12:55:10 2012]  [<ffffffffa04ea83d>] btrfs_lookup+0x1d/0x60=
=20
[btrfs]
[Tue Jan 31 12:55:10 2012]  [<ffffffff81172e9d>]=20
d_inode_lookup.isra.12+0x1d/0x50
[Tue Jan 31 12:55:10 2012]  [<ffffffff81173292>] do_lookup+0x382/0x3d0
[Tue Jan 31 12:55:10 2012]  [<ffffffff81174d0c>]=20
path_lookupat+0x11c/0x760
[Tue Jan 31 12:55:10 2012]  [<ffffffff81175381>]=20
do_path_lookup+0x31/0xc0
[Tue Jan 31 12:55:10 2012]  [<ffffffff811771d9>]=20
user_path_at_empty+0x59/0xa0
[Tue Jan 31 12:55:10 2012]  [<ffffffffa04bac3d>] ?=20
btrfs_fs_dirty_inode+0x1d/0x80 [btrfs]
[Tue Jan 31 12:55:10 2012]  [<ffffffff8118f1ef>] ?=20
__mark_inode_dirty+0x19f/0x230
[Tue Jan 31 12:55:10 2012]  [<ffffffff81177231>] user_path_at+0x11/0x20
[Tue Jan 31 12:55:10 2012]  [<ffffffff8116bf4a>] vfs_fstatat+0x3a/0x70
[Tue Jan 31 12:55:10 2012]  [<ffffffff811798c0>] ? sys_ioctl+0xa0/0xa0
[Tue Jan 31 12:55:10 2012]  [<ffffffff8116bf9e>] vfs_lstat+0x1e/0x20
[Tue Jan 31 12:55:10 2012]  [<ffffffff8116c13a>] sys_newlstat+0x1a/0x40
[Tue Jan 31 12:55:10 2012]  [<ffffffff81179d1c>] ?=20
sys_getdents+0xbc/0xf0
[Tue Jan 31 12:55:10 2012]  [<ffffffff814290c2>]=20
system_call_fastpath+0x16/0x1b
[Tue Jan 31 12:55:10 2012] INFO: task rsync:19379 blocked for more than=
=20
120 seconds.
[Tue Jan 31 12:55:10 2012] "echo 0 >=20
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
[Tue Jan 31 12:55:10 2012] rsync           D 0000000106ebce5c     0=20
19379  18859 0x00000000
[Tue Jan 31 12:55:10 2012]  ffff88017e46b758 0000000000000086=20
ffff880100000000 ffffffff8104f373
[Tue Jan 31 12:55:10 2012]  ffff88002d35c740 ffff88017e46bfd8=20
ffff88017e46bfd8 ffff88017e46bfd8
[Tue Jan 31 12:55:10 2012]  ffff880202cb4e60 ffff88002d35c740=20
ffff88017e46b6a8 ffffffffa01a31be
[Tue Jan 31 12:55:10 2012] Call Trace:
[Tue Jan 31 12:55:10 2012]  [<ffffffff8104f373>] ? __wake_up+0x53/0x70
[Tue Jan 31 12:55:10 2012]  [<ffffffffa01a31be>] ?=20
loop_make_request+0xde/0x110 [loop]
[Tue Jan 31 12:55:10 2012]  [<ffffffff8121d877>] ?=20
generic_make_request+0xc7/0x100
[Tue Jan 31 12:55:10 2012]  [<ffffffff8121d937>] ? submit_bio+0x87/0x11=
0
[Tue Jan 31 12:55:10 2012]  [<ffffffff8101d639>] ? read_tsc+0x9/0x20
[Tue Jan 31 12:55:10 2012]  [<ffffffff811055d0>] ? __lock_page+0x70/0x7=
0
[Tue Jan 31 12:55:10 2012]  [<ffffffff814258bf>] schedule+0x3f/0x60
[Tue Jan 31 12:55:10 2012]  [<ffffffff8142596f>] io_schedule+0x8f/0xd0
[Tue Jan 31 12:55:10 2012]  [<ffffffff811055de>] sleep_on_page+0xe/0x20
[Tue Jan 31 12:55:10 2012]  [<ffffffff8142611f>] __wait_on_bit+0x5f/0x9=
0
[Tue Jan 31 12:55:10 2012]  [<ffffffff811057c8>]=20
wait_on_page_bit+0x78/0x80
[Tue Jan 31 12:55:10 2012]  [<ffffffff81088cf0>] ?=20
autoremove_wake_function+0x40/0x40
[Tue Jan 31 12:55:10 2012]  [<ffffffffa04ffe66>]=20
read_extent_buffer_pages+0x476/0x510 [btrfs]
[Tue Jan 31 12:55:10 2012]  [<ffffffffa04d6f90>] ?=20
verify_parent_transid+0x160/0x160 [btrfs]
[Tue Jan 31 12:55:10 2012]  [<ffffffffa04d815a>]=20
btree_read_extent_buffer_pages.isra.100+0x8a/0xc0 [btrfs]
[Tue Jan 31 12:55:10 2012]  [<ffffffffa04d98f1>]=20
read_tree_block+0x41/0x60 [btrfs]
[Tue Jan 31 12:55:10 2012]  [<ffffffffa04c0ca3>]=20
read_block_for_search.isra.33+0xf3/0x3d0 [btrfs]
[Tue Jan 31 12:55:10 2012]  [<ffffffffa04c0577>] ?=20
generic_bin_search.constprop.35+0xe7/0x160 [btrfs]
[Tue Jan 31 12:55:10 2012]  [<ffffffffa04c2fe0>]=20
btrfs_search_slot+0x390/0x8a0 [btrfs]
[Tue Jan 31 12:55:10 2012]  [<ffffffffa04d5eef>]=20
btrfs_lookup_inode+0x2f/0xa0 [btrfs]
[Tue Jan 31 12:55:10 2012]  [<ffffffffa04e9b31>] btrfs_iget+0x101/0x490=
=20
[btrfs]
[Tue Jan 31 12:55:10 2012]  [<ffffffffa04ea7e5>] ?=20
btrfs_lookup_dentry+0x4a5/0x4e0 [btrfs]
[Tue Jan 31 12:55:10 2012]  [<ffffffff8117d000>] ? d_validate+0x10/0xb0
[Tue Jan 31 12:55:10 2012]  [<ffffffffa04ea793>]=20
btrfs_lookup_dentry+0x453/0x4e0 [btrfs]
[Tue Jan 31 12:55:10 2012]  [<ffffffff8117f3e5>] ? __d_lookup+0xb5/0x17=
0
[Tue Jan 31 12:55:10 2012]  [<ffffffffa04ea83d>] btrfs_lookup+0x1d/0x60=
=20
[btrfs]
[Tue Jan 31 12:55:10 2012]  [<ffffffff81172e9d>]=20
d_inode_lookup.isra.12+0x1d/0x50
[Tue Jan 31 12:55:10 2012]  [<ffffffff81173292>] do_lookup+0x382/0x3d0
[Tue Jan 31 12:55:10 2012]  [<ffffffff81172abb>] ?=20
getname_flags+0x3b/0x260
[Tue Jan 31 12:55:10 2012]  [<ffffffff81174d0c>]=20
path_lookupat+0x11c/0x760
[Tue Jan 31 12:55:10 2012]  [<ffffffff81175381>]=20
do_path_lookup+0x31/0xc0
[Tue Jan 31 12:55:10 2012]  [<ffffffff811771d9>]=20
user_path_at_empty+0x59/0xa0
[Tue Jan 31 12:55:10 2012]  [<ffffffff811798c0>] ? sys_ioctl+0xa0/0xa0
[Tue Jan 31 12:55:10 2012]  [<ffffffff8116bb94>] ?=20
inode_get_bytes+0x44/0x60
[Tue Jan 31 12:55:10 2012]  [<ffffffffa04e0df6>] ?=20
btrfs_getattr+0x56/0x90 [btrfs]
[Tue Jan 31 12:55:10 2012]  [<ffffffff8116bd34>] ? cp_new_stat+0xe4/0xf=
0
[Tue Jan 31 12:55:10 2012]  [<ffffffff81177231>] user_path_at+0x11/0x20
[Tue Jan 31 12:55:10 2012]  [<ffffffff8116bf4a>] vfs_fstatat+0x3a/0x70
[Tue Jan 31 12:55:10 2012]  [<ffffffff8116bf9e>] vfs_lstat+0x1e/0x20
[Tue Jan 31 12:55:10 2012]  [<ffffffff8116c13a>] sys_newlstat+0x1a/0x40
[Tue Jan 31 12:55:10 2012]  [<ffffffff814290c2>]=20
system_call_fastpath+0x16/0x1b
[Tue Jan 31 12:55:10 2012] INFO: task rsync:16598 blocked for more than=
=20
120 seconds.
[Tue Jan 31 12:55:10 2012] "echo 0 >=20
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
[Tue Jan 31 12:55:10 2012] rsync           D 0000000106ebce55     0=20
16598  16597 0x00000000
[Tue Jan 31 12:55:10 2012]  ffff88000236f758 0000000000000086=20
ffff88000236f678 ffffffff8104f373
[Tue Jan 31 12:55:10 2012]  ffff880025859560 ffff88000236ffd8=20
ffff88000236ffd8 ffff88000236ffd8
[Tue Jan 31 12:55:10 2012]  ffff880202d21c80 ffff880025859560=20
ffff88000236f6a8 ffffffffa01a31be
[Tue Jan 31 12:55:10 2012] Call Trace:
[Tue Jan 31 12:55:10 2012]  [<ffffffff8104f373>] ? __wake_up+0x53/0x70
[Tue Jan 31 12:55:10 2012]  [<ffffffffa01a31be>] ?=20
loop_make_request+0xde/0x110 [loop]
[Tue Jan 31 12:55:10 2012]  [<ffffffff8121d877>] ?=20
generic_make_request+0xc7/0x100
[Tue Jan 31 12:55:10 2012]  [<ffffffff8121d937>] ? submit_bio+0x87/0x11=
0
[Tue Jan 31 12:55:10 2012]  [<ffffffff8101d639>] ? read_tsc+0x9/0x20
[Tue Jan 31 12:55:10 2012]  [<ffffffff8109271d>] ?=20
ktime_get_ts+0xad/0xe0
[Tue Jan 31 12:55:10 2012]  [<ffffffff811055d0>] ? __lock_page+0x70/0x7=
0
[Tue Jan 31 12:55:10 2012]  [<ffffffff814258bf>] schedule+0x3f/0x60
[Tue Jan 31 12:55:10 2012]  [<ffffffff8142596f>] io_schedule+0x8f/0xd0
[Tue Jan 31 12:55:10 2012]  [<ffffffff811055de>] sleep_on_page+0xe/0x20
[Tue Jan 31 12:55:10 2012]  [<ffffffff8142611f>] __wait_on_bit+0x5f/0x9=
0
[Tue Jan 31 12:55:10 2012]  [<ffffffff811057c8>]=20
wait_on_page_bit+0x78/0x80
[Tue Jan 31 12:55:10 2012]  [<ffffffff81088cf0>] ?=20
autoremove_wake_function+0x40/0x40
[Tue Jan 31 12:55:10 2012]  [<ffffffffa04ffe66>]=20
read_extent_buffer_pages+0x476/0x510 [btrfs]
[Tue Jan 31 12:55:10 2012]  [<ffffffffa04d6f90>] ?=20
verify_parent_transid+0x160/0x160 [btrfs]
[Tue Jan 31 12:55:10 2012]  [<ffffffffa04d815a>]=20
btree_read_extent_buffer_pages.isra.100+0x8a/0xc0 [btrfs]
[Tue Jan 31 12:55:10 2012]  [<ffffffffa04d98f1>]=20
read_tree_block+0x41/0x60 [btrfs]
[Tue Jan 31 12:55:10 2012]  [<ffffffffa04c0ca3>]=20
read_block_for_search.isra.33+0xf3/0x3d0 [btrfs]
[Tue Jan 31 12:55:10 2012]  [<ffffffffa04c0577>] ?=20
generic_bin_search.constprop.35+0xe7/0x160 [btrfs]
[Tue Jan 31 12:55:10 2012]  [<ffffffffa04c2fe0>]=20
btrfs_search_slot+0x390/0x8a0 [btrfs]
[Tue Jan 31 12:55:10 2012]  [<ffffffffa04d5eef>]=20
btrfs_lookup_inode+0x2f/0xa0 [btrfs]
[Tue Jan 31 12:55:10 2012]  [<ffffffffa04e9b31>] btrfs_iget+0x101/0x490=
=20
[btrfs]
[Tue Jan 31 12:55:10 2012]  [<ffffffffa04ea7e5>] ?=20
btrfs_lookup_dentry+0x4a5/0x4e0 [btrfs]
[Tue Jan 31 12:55:10 2012]  [<ffffffff8117d000>] ? d_validate+0x10/0xb0
[Tue Jan 31 12:55:10 2012]  [<ffffffffa04ea793>]=20
btrfs_lookup_dentry+0x453/0x4e0 [btrfs]
[Tue Jan 31 12:55:10 2012]  [<ffffffff8107150a>] ? ns_capable+0x2a/0x60
[Tue Jan 31 12:55:10 2012]  [<ffffffff811735e9>] ?=20
generic_permission+0x149/0x280
[Tue Jan 31 12:55:10 2012]  [<ffffffff8117f3e5>] ? __d_lookup+0xb5/0x17=
0
[Tue Jan 31 12:55:10 2012]  [<ffffffffa04ea83d>] btrfs_lookup+0x1d/0x60=
=20
[btrfs]
[Tue Jan 31 12:55:10 2012]  [<ffffffff81172e9d>]=20
d_inode_lookup.isra.12+0x1d/0x50
[Tue Jan 31 12:55:10 2012]  [<ffffffff81173292>] do_lookup+0x382/0x3d0
[Tue Jan 31 12:55:10 2012]  [<ffffffff81172abb>] ?=20
getname_flags+0x3b/0x260
[Tue Jan 31 12:55:10 2012]  [<ffffffff81174d0c>]=20
path_lookupat+0x11c/0x760
[Tue Jan 31 12:55:10 2012]  [<ffffffff81175381>]=20
do_path_lookup+0x31/0xc0
[Tue Jan 31 12:55:10 2012]  [<ffffffff811771d9>]=20
user_path_at_empty+0x59/0xa0
[Tue Jan 31 12:55:10 2012]  [<ffffffff8116bb94>] ?=20
inode_get_bytes+0x44/0x60
[Tue Jan 31 12:55:10 2012]  [<ffffffffa04e0df6>] ?=20
btrfs_getattr+0x56/0x90 [btrfs]
[Tue Jan 31 12:55:10 2012]  [<ffffffff8116bd34>] ? cp_new_stat+0xe4/0xf=
0
[Tue Jan 31 12:55:10 2012]  [<ffffffff81177231>] user_path_at+0x11/0x20
[Tue Jan 31 12:55:10 2012]  [<ffffffff8116bf4a>] vfs_fstatat+0x3a/0x70
[Tue Jan 31 12:55:10 2012]  [<ffffffff8116bf9e>] vfs_lstat+0x1e/0x20
[Tue Jan 31 12:55:10 2012]  [<ffffffff8116c13a>] sys_newlstat+0x1a/0x40
[Tue Jan 31 12:55:10 2012]  [<ffffffff814290c2>]=20
system_call_fastpath+0x16/0x1b
[Tue Jan 31 13:02:52 2012] device-mapper: uevent: version 1.0.3
[Tue Jan 31 13:02:52 2012] device-mapper: ioctl: 4.22.0-ioctl=20
(2011-10-19) initialised: dm-devel@redhat.com
[Tue Jan 31 13:23:10 2012] INFO: task rsync:13574 blocked for more than=
=20
120 seconds.
[Tue Jan 31 13:23:10 2012] "echo 0 >=20
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
[Tue Jan 31 13:23:10 2012] rsync           D 0000000106f37614     0=20
13574  12299 0x00000000
[Tue Jan 31 13:23:10 2012]  ffff880012c29a88 0000000000000082=20
ffff880012c299a8 ffffffff8104f373
[Tue Jan 31 13:23:10 2012]  ffff880202355ca0 ffff880012c29fd8=20
ffff880012c29fd8 ffff880012c29fd8
[Tue Jan 31 13:23:10 2012]  ffff880202d21c80 ffff880202355ca0=20
ffff880012c299d8 ffffffffa01a31be
[Tue Jan 31 13:23:10 2012] Call Trace:
[Tue Jan 31 13:23:10 2012]  [<ffffffff8104f373>] ? __wake_up+0x53/0x70
[Tue Jan 31 13:23:10 2012]  [<ffffffffa01a31be>] ?=20
loop_make_request+0xde/0x110 [loop]
[Tue Jan 31 13:23:10 2012]  [<ffffffff8121d877>] ?=20
generic_make_request+0xc7/0x100
[Tue Jan 31 13:23:10 2012]  [<ffffffff8121d937>] ? submit_bio+0x87/0x11=
0
[Tue Jan 31 13:23:10 2012]  [<ffffffff8101d639>] ? read_tsc+0x9/0x20
[Tue Jan 31 13:23:10 2012]  [<ffffffff8109271d>] ?=20
ktime_get_ts+0xad/0xe0
[Tue Jan 31 13:23:10 2012]  [<ffffffff811055d0>] ? __lock_page+0x70/0x7=
0
[Tue Jan 31 13:23:10 2012]  [<ffffffff814258bf>] schedule+0x3f/0x60
[Tue Jan 31 13:23:10 2012]  [<ffffffff8142596f>] io_schedule+0x8f/0xd0
[Tue Jan 31 13:23:10 2012]  [<ffffffff811055de>] sleep_on_page+0xe/0x20
[Tue Jan 31 13:23:10 2012]  [<ffffffff8142611f>] __wait_on_bit+0x5f/0x9=
0
[Tue Jan 31 13:23:10 2012]  [<ffffffff811057c8>]=20
wait_on_page_bit+0x78/0x80
[Tue Jan 31 13:23:10 2012]  [<ffffffff81088cf0>] ?=20
autoremove_wake_function+0x40/0x40
[Tue Jan 31 13:23:10 2012]  [<ffffffffa04ffe66>]=20
read_extent_buffer_pages+0x476/0x510 [btrfs]
[Tue Jan 31 13:23:10 2012]  [<ffffffffa04d6f90>] ?=20
verify_parent_transid+0x160/0x160 [btrfs]
[Tue Jan 31 13:23:10 2012]  [<ffffffffa04d815a>]=20
btree_read_extent_buffer_pages.isra.100+0x8a/0xc0 [btrfs]
[Tue Jan 31 13:23:10 2012]  [<ffffffffa04d98f1>]=20
read_tree_block+0x41/0x60 [btrfs]
[Tue Jan 31 13:23:10 2012]  [<ffffffffa04c0ca3>]=20
read_block_for_search.isra.33+0xf3/0x3d0 [btrfs]
[Tue Jan 31 13:23:10 2012]  [<ffffffffa04c2fe0>]=20
btrfs_search_slot+0x390/0x8a0 [btrfs]
[Tue Jan 31 13:23:10 2012]  [<ffffffff8123a8bb>] ?=20
radix_tree_lookup+0xb/0x10
[Tue Jan 31 13:23:10 2012]  [<ffffffffa04e0837>]=20
btrfs_real_readdir+0x1b7/0x720 [btrfs]
[Tue Jan 31 13:23:10 2012]  [<ffffffff811798c0>] ? sys_ioctl+0xa0/0xa0
[Tue Jan 31 13:23:10 2012]  [<ffffffff81426703>] ?=20
__mutex_lock_killable_slowpath+0x273/0x400
[Tue Jan 31 13:23:10 2012]  [<ffffffff811798c0>] ? sys_ioctl+0xa0/0xa0
[Tue Jan 31 13:23:10 2012]  [<ffffffff81179bc0>] vfs_readdir+0xb0/0xe0
[Tue Jan 31 13:23:10 2012]  [<ffffffff81179ce9>] sys_getdents+0x89/0xf0
[Tue Jan 31 13:23:10 2012]  [<ffffffff814290c2>]=20
system_call_fastpath+0x16/0x1b
[Tue Jan 31 13:23:10 2012] INFO: task rsync:19880 blocked for more than=
=20
120 seconds.
[Tue Jan 31 13:23:10 2012] "echo 0 >=20
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
[Tue Jan 31 13:23:10 2012] rsync           D 0000000106f37616     0=20
19880  19818 0x00000000
[Tue Jan 31 13:23:10 2012]  ffff88019f8a3758 0000000000000086=20
ffff880100000000 ffffffff8104f373
[Tue Jan 31 13:23:10 2012]  ffff8801e3e0b900 ffff88019f8a3fd8=20
ffff88019f8a3fd8 ffff88019f8a3fd8
[Tue Jan 31 13:23:10 2012]  ffff880202cb4e60 ffff8801e3e0b900=20
ffff88019f8a36a8 ffffffffa01a31be
[Tue Jan 31 13:23:10 2012] Call Trace:
[Tue Jan 31 13:23:10 2012]  [<ffffffff8104f373>] ? __wake_up+0x53/0x70
[Tue Jan 31 13:23:10 2012]  [<ffffffffa01a31be>] ?=20
loop_make_request+0xde/0x110 [loop]
[Tue Jan 31 13:23:10 2012]  [<ffffffff8121d877>] ?=20
generic_make_request+0xc7/0x100
[Tue Jan 31 13:23:10 2012]  [<ffffffff8121d937>] ? submit_bio+0x87/0x11=
0
[Tue Jan 31 13:23:10 2012]  [<ffffffff8101d639>] ? read_tsc+0x9/0x20
[Tue Jan 31 13:23:10 2012]  [<ffffffff811055d0>] ? __lock_page+0x70/0x7=
0
[Tue Jan 31 13:23:10 2012]  [<ffffffff814258bf>] schedule+0x3f/0x60
[Tue Jan 31 13:23:10 2012]  [<ffffffff8142596f>] io_schedule+0x8f/0xd0
[Tue Jan 31 13:23:10 2012]  [<ffffffff811055de>] sleep_on_page+0xe/0x20
[Tue Jan 31 13:23:10 2012]  [<ffffffff8142611f>] __wait_on_bit+0x5f/0x9=
0
[Tue Jan 31 13:23:10 2012]  [<ffffffff811057c8>]=20
wait_on_page_bit+0x78/0x80
[Tue Jan 31 13:23:10 2012]  [<ffffffff81088cf0>] ?=20
autoremove_wake_function+0x40/0x40
[Tue Jan 31 13:23:10 2012]  [<ffffffffa04ffe66>]=20
read_extent_buffer_pages+0x476/0x510 [btrfs]
[Tue Jan 31 13:23:10 2012]  [<ffffffffa04d6f90>] ?=20
verify_parent_transid+0x160/0x160 [btrfs]
[Tue Jan 31 13:23:10 2012]  [<ffffffffa04d815a>]=20
btree_read_extent_buffer_pages.isra.100+0x8a/0xc0 [btrfs]
[Tue Jan 31 13:23:10 2012]  [<ffffffffa04d98f1>]=20
read_tree_block+0x41/0x60 [btrfs]
[Tue Jan 31 13:23:10 2012]  [<ffffffffa04c0ca3>]=20
read_block_for_search.isra.33+0xf3/0x3d0 [btrfs]
[Tue Jan 31 13:23:10 2012]  [<ffffffffa04c0577>] ?=20
generic_bin_search.constprop.35+0xe7/0x160 [btrfs]
[Tue Jan 31 13:23:10 2012]  [<ffffffffa04c2fe0>]=20
btrfs_search_slot+0x390/0x8a0 [btrfs]
[Tue Jan 31 13:23:10 2012]  [<ffffffffa04d5eef>]=20
btrfs_lookup_inode+0x2f/0xa0 [btrfs]
[Tue Jan 31 13:23:10 2012]  [<ffffffffa04e9b31>] btrfs_iget+0x101/0x490=
=20
[btrfs]
[Tue Jan 31 13:23:10 2012]  [<ffffffffa04ea7e5>] ?=20
btrfs_lookup_dentry+0x4a5/0x4e0 [btrfs]
[Tue Jan 31 13:23:10 2012]  [<ffffffff8117d000>] ? d_validate+0x10/0xb0
[Tue Jan 31 13:23:10 2012]  [<ffffffffa04ea793>]=20
btrfs_lookup_dentry+0x453/0x4e0 [btrfs]
[Tue Jan 31 13:23:10 2012]  [<ffffffff8117f3e5>] ? __d_lookup+0xb5/0x17=
0
[Tue Jan 31 13:23:10 2012]  [<ffffffffa04ea83d>] btrfs_lookup+0x1d/0x60=
=20
[btrfs]
[Tue Jan 31 13:23:10 2012]  [<ffffffff81172e9d>]=20
d_inode_lookup.isra.12+0x1d/0x50
[Tue Jan 31 13:23:10 2012]  [<ffffffff81173292>] do_lookup+0x382/0x3d0
[Tue Jan 31 13:23:10 2012]  [<ffffffff81174d0c>]=20
path_lookupat+0x11c/0x760
[Tue Jan 31 13:23:10 2012]  [<ffffffff81175381>]=20
do_path_lookup+0x31/0xc0
[Tue Jan 31 13:23:10 2012]  [<ffffffff811771d9>]=20
user_path_at_empty+0x59/0xa0
[Tue Jan 31 13:23:10 2012]  [<ffffffff811798c0>] ? sys_ioctl+0xa0/0xa0
[Tue Jan 31 13:23:10 2012]  [<ffffffff8116bb94>] ?=20
inode_get_bytes+0x44/0x60
[Tue Jan 31 13:23:10 2012]  [<ffffffffa04e0df6>] ?=20
btrfs_getattr+0x56/0x90 [btrfs]
[Tue Jan 31 13:23:10 2012]  [<ffffffff8116bd34>] ? cp_new_stat+0xe4/0xf=
0
[Tue Jan 31 13:23:10 2012]  [<ffffffff81177231>] user_path_at+0x11/0x20
[Tue Jan 31 13:23:10 2012]  [<ffffffff8116bf4a>] vfs_fstatat+0x3a/0x70
[Tue Jan 31 13:23:10 2012]  [<ffffffff8116bf9e>] vfs_lstat+0x1e/0x20
[Tue Jan 31 13:23:10 2012]  [<ffffffff8116c13a>] sys_newlstat+0x1a/0x40
[Tue Jan 31 13:23:10 2012]  [<ffffffff814290c2>]=20
system_call_fastpath+0x16/0x1b
[Tue Jan 31 13:23:10 2012] INFO: task rsync:20089 blocked for more than=
=20
120 seconds.
[Tue Jan 31 13:23:10 2012] "echo 0 >=20
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
[Tue Jan 31 13:23:10 2012] rsync           D 0000000106f37615     0=20
20089  20088 0x00000000
[Tue Jan 31 13:23:10 2012]  ffff880046403758 0000000000000086=20
ffff880000000000 ffffffff8104f373
[Tue Jan 31 13:23:10 2012]  ffff8801e3e0c020 ffff880046403fd8=20
ffff880046403fd8 ffff880046403fd8
[Tue Jan 31 13:23:10 2012]  ffff880202cb4e60 ffff8801e3e0c020=20
ffff8800464036a8 ffffffffa01a31be
[Tue Jan 31 13:23:10 2012] Call Trace:
[Tue Jan 31 13:23:10 2012]  [<ffffffff8104f373>] ? __wake_up+0x53/0x70
[Tue Jan 31 13:23:10 2012]  [<ffffffffa01a31be>] ?=20
loop_make_request+0xde/0x110 [loop]
[Tue Jan 31 13:23:10 2012]  [<ffffffff8121d877>] ?=20
generic_make_request+0xc7/0x100
[Tue Jan 31 13:23:10 2012]  [<ffffffff8121d937>] ? submit_bio+0x87/0x11=
0
[Tue Jan 31 13:23:10 2012]  [<ffffffff8101d639>] ? read_tsc+0x9/0x20
[Tue Jan 31 13:23:10 2012]  [<ffffffff811055d0>] ? __lock_page+0x70/0x7=
0
[Tue Jan 31 13:23:10 2012]  [<ffffffff814258bf>] schedule+0x3f/0x60
[Tue Jan 31 13:23:10 2012]  [<ffffffff8142596f>] io_schedule+0x8f/0xd0
[Tue Jan 31 13:23:10 2012]  [<ffffffff811055de>] sleep_on_page+0xe/0x20
[Tue Jan 31 13:23:10 2012]  [<ffffffff8142611f>] __wait_on_bit+0x5f/0x9=
0
[Tue Jan 31 13:23:10 2012]  [<ffffffff811057c8>]=20
wait_on_page_bit+0x78/0x80
[Tue Jan 31 13:23:10 2012]  [<ffffffff81088cf0>] ?=20
autoremove_wake_function+0x40/0x40
[Tue Jan 31 13:23:10 2012]  [<ffffffffa04ffe66>]=20
read_extent_buffer_pages+0x476/0x510 [btrfs]
[Tue Jan 31 13:23:10 2012]  [<ffffffffa04d6f90>] ?=20
verify_parent_transid+0x160/0x160 [btrfs]
[Tue Jan 31 13:23:10 2012]  [<ffffffffa04d815a>]=20
btree_read_extent_buffer_pages.isra.100+0x8a/0xc0 [btrfs]
[Tue Jan 31 13:23:10 2012]  [<ffffffffa04d98f1>]=20
read_tree_block+0x41/0x60 [btrfs]
[Tue Jan 31 13:23:10 2012]  [<ffffffffa04c0ca3>]=20
read_block_for_search.isra.33+0xf3/0x3d0 [btrfs]
[Tue Jan 31 13:23:10 2012]  [<ffffffffa04c0577>] ?=20
generic_bin_search.constprop.35+0xe7/0x160 [btrfs]
[Tue Jan 31 13:23:10 2012]  [<ffffffffa04c2fe0>]=20
btrfs_search_slot+0x390/0x8a0 [btrfs]
[Tue Jan 31 13:23:10 2012]  [<ffffffffa04d5eef>]=20
btrfs_lookup_inode+0x2f/0xa0 [btrfs]
[Tue Jan 31 13:23:10 2012]  [<ffffffffa04e9b31>] btrfs_iget+0x101/0x490=
=20
[btrfs]
[Tue Jan 31 13:23:10 2012]  [<ffffffffa04ea7e5>] ?=20
btrfs_lookup_dentry+0x4a5/0x4e0 [btrfs]
[Tue Jan 31 13:23:10 2012]  [<ffffffff8117d000>] ? d_validate+0x10/0xb0
[Tue Jan 31 13:23:10 2012]  [<ffffffff81354f9b>] ?=20
__alloc_skb+0x4b/0x240
[Tue Jan 31 13:23:10 2012]  [<ffffffffa04ea793>]=20
btrfs_lookup_dentry+0x453/0x4e0 [btrfs]
[Tue Jan 31 13:23:10 2012]  [<ffffffff81090bc4>] ? in_group_p+0x34/0x40
[Tue Jan 31 13:23:10 2012]  [<ffffffff81173622>] ?=20
generic_permission+0x182/0x280
[Tue Jan 31 13:23:10 2012]  [<ffffffff8117f3e5>] ? __d_lookup+0xb5/0x17=
0
[Tue Jan 31 13:23:10 2012]  [<ffffffffa04ea83d>] btrfs_lookup+0x1d/0x60=
=20
[btrfs]
[Tue Jan 31 13:23:10 2012]  [<ffffffff81172e9d>]=20
d_inode_lookup.isra.12+0x1d/0x50
[Tue Jan 31 13:23:10 2012]  [<ffffffff81173292>] do_lookup+0x382/0x3d0
[Tue Jan 31 13:23:10 2012]  [<ffffffff81174d0c>]=20
path_lookupat+0x11c/0x760
[Tue Jan 31 13:23:10 2012]  [<ffffffff81175381>]=20
do_path_lookup+0x31/0xc0
[Tue Jan 31 13:23:10 2012]  [<ffffffff811771d9>]=20
user_path_at_empty+0x59/0xa0
[Tue Jan 31 13:23:10 2012]  [<ffffffff8116bb94>] ?=20
inode_get_bytes+0x44/0x60
[Tue Jan 31 13:23:10 2012]  [<ffffffffa04e0df6>] ?=20
btrfs_getattr+0x56/0x90 [btrfs]
[Tue Jan 31 13:23:10 2012]  [<ffffffff8116bd34>] ? cp_new_stat+0xe4/0xf=
0
[Tue Jan 31 13:23:10 2012]  [<ffffffff81177231>] user_path_at+0x11/0x20
[Tue Jan 31 13:23:10 2012]  [<ffffffff8116bf4a>] vfs_fstatat+0x3a/0x70
[Tue Jan 31 13:23:10 2012]  [<ffffffff8116bf9e>] vfs_lstat+0x1e/0x20
[Tue Jan 31 13:23:10 2012]  [<ffffffff8116c13a>] sys_newlstat+0x1a/0x40
[Tue Jan 31 13:23:10 2012]  [<ffffffff814290c2>]=20
system_call_fastpath+0x16/0x1b

> Increased the stripe_cache_size to 4096 according to the workaround f=
or ths
> old similiar bug. Is the bug back in the recent kernels?
>
> Has not seen any freezes since that workaround but oth they weren't t=
hat
> frequent earlier either.
>
>
>> Feb 5 02:51:04 mythserv kernel: INFO: task lessfs:2687 blocked for m=
ore than
>> 120 seconds.
>> Feb 5 02:51:04 mythserv kernel: =E2=80=9Cecho 0>
>> /proc/sys/kernel/hung_task_timeout_secs=E2=80=9D disables this messa=
ge.
>> Feb 5 02:51:04 mythserv kernel: lessfs D ffff88006faf1998 0 2687 1
>> 0=C3=9700000000 Feb 5 02:51:04 mythserv kernel: ffff880066579828
>> 0000000000000086 ffff8800665797b8 ffffffff00000000
>> Feb 5 02:51:04 mythserv kernel: ffff88006faf1620 0000000000013300
>> ffff880066579fd8 ffff880066578010
>> Feb 5 02:51:04 mythserv kernel: ffff880066579fd8 0000000000013300
>> ffffffff81655020 ffff88006faf1620
>> Feb 5 02:51:04 mythserv kernel: Call Trace:
>> Feb 5 02:51:04 mythserv kernel: [] schedule+0x3f/0=C3=9760
>> Feb 5 02:51:04 mythserv kernel: [] get_active_stripe+0x2ea/0=C3=9779=
0 [raid456]
>> Feb 5 02:51:04 mythserv kernel: [] ? try_to_wake_up+0x2b0/0x2b0
>> Feb 5 02:51:04 mythserv kernel: [] make_request+0x1ae/0=C3=97460 [ra=
id456]
>> Feb 5 02:51:04 mythserv kernel: [] ? wake_up_bit+0=C3=9740/0=C3=9740
>> Feb 5 02:51:04 mythserv kernel: [] md_make_request+0xd5/0=C3=97200
>> Feb 5 02:51:04 mythserv kernel: [] generic_make_request+0xbf/0xf0
>> Feb 5 02:51:04 mythserv kernel: [] submit_bio+0=C3=9785/0=C3=97110
>> Feb 5 02:51:04 mythserv kernel: [] ? __bio_add_page+0=C3=97110/0=C3=97=
250
>> Feb 5 02:51:04 mythserv kernel: [] xfs_submit_ioend_bio+0=C3=9757/0=C3=
=9780 [xfs]
>> Feb 5 02:51:04 mythserv kernel: [] xfs_submit_ioend+0xf6/0=C3=97110 =
[xfs]
>> Feb 5 02:51:04 mythserv kernel: [] xfs_vm_writepage+0=C3=97230/0=C3=97=
500 [xfs]
>> Feb 5 02:51:04 mythserv kernel: [] __writepage+0=C3=9717/0=C3=9740
>> Feb 5 02:51:04 mythserv kernel: [] write_cache_pages+0=C3=97221/0x4a=
0
>> Feb 5 02:51:04 mythserv kernel: [] ? tomoyo_init_request_info+0x3f/0=
=C3=9770
>> Feb 5 02:51:04 mythserv kernel: [] ? set_page_dirty+0=C3=9770/0=C3=97=
70
>> Feb 5 02:51:04 mythserv kernel: [] generic_writepages+0=C3=9751/0=C3=
=9780
>> Feb 5 02:51:04 mythserv kernel: [] xfs_vm_writepages+0=C3=9753/0=C3=97=
70 [xfs]
>> Feb 5 02:51:04 mythserv kernel: [] do_writepages+0=C3=9721/0=C3=9740
>> Feb 5 02:51:04 mythserv kernel: [] __filemap_fdatawrite_range+0x5b/0=
=C3=9760
>> Feb 5 02:51:04 mythserv kernel: [] filemap_write_and_wait_range+0x5a=
/0=C3=9780
>> Feb 5 02:51:04 mythserv kernel: [] xfs_file_fsync+0=C3=9768/0x2d0 [x=
fs]
>> Feb 5 02:51:04 mythserv kernel: [] vfs_fsync_range+0x2b/0=C3=9740
>> Feb 5 02:51:04 mythserv kernel: [] vfs_fsync+0x1c/0=C3=9720
>> Feb 5 02:51:04 mythserv kernel: [] do_fsync+0x3a/0=C3=9760
>> Feb 5 02:51:04 mythserv kernel: [] sys_fsync+0=C3=9710/0=C3=9720
>> Feb 5 02:51:04 mythserv kernel: [] system_call_fastpath+0=C3=9716/0x=
1b
>>
>> Any hints? Or any debugging I can do to help? I did find a similar c=
as from
>> 2008, but that is supposed to be fixed now.
>> This also started after updating the kernel to the 3.x series. At th=
e moment
>> using 3.2.2 and still seeing it.


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
