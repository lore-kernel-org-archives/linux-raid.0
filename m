From: Brassow Jonathan <jbrassow@redhat.com>
Subject: Re: [PATCH 0/5] Fixes for RAID1 resync
Date: Thu, 11 Sep 2014 12:12:01 -0500
Message-ID: <8697EC47-F648-4E66-B37C-4A2DC3030696@redhat.com>
References: <20140910062039.26400.36745.stgit@notabene.brown> <D96E0116-919C-4F4B-B4B6-2564B99449FB@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <D96E0116-919C-4F4B-B4B6-2564B99449FB@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brassow Jonathan <jbrassow@redhat.com>
Cc: NeilBrown <neilb@suse.de>, Eivind Sarto <eivindsarto@gmail.com>, linux-raid@vger.kernel.org, majianpeng <majianpeng@gmail.com>
List-Id: linux-raid.ids


On Sep 10, 2014, at 10:45 PM, Brassow Jonathan wrote:

> 
> On Sep 10, 2014, at 1:20 AM, NeilBrown wrote:
> 
>> 
>> Jon: could you test with these patches on top of what you
>> have just in case something happens to fix the problem without
>> me realising it?
> 
> I'm on it.  The test is running.  I'll know later tomorrow.
> 
> brassow

The test is still failing from here.  I grabbed 3.17.0-rc4, added the 5 patches, and got the attached backtraces when testing.  As I said, the hangs are not exactly the same.  This set shows the mdX_raid1 thread in the middle of handling a read failure.

 brassow

Sep 11 07:48:02 bp-01 kernel: INFO: task dmeventd:27071 blocked for more than 12
0 seconds.
Sep 11 07:48:02 bp-01 kernel:      Tainted: G            E  3.17.0-rc4 #1
Sep 11 07:48:02 bp-01 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
 disables this message.
Sep 11 07:48:02 bp-01 kernel: dmeventd        D 0000000000000003     0 27071      1 0x00000080
Sep 11 07:48:02 bp-01 kernel: ffff8804038efae8 0000000000000082 ffff8800dbccf460 ffff88021721c0d0
Sep 11 07:48:02 bp-01 kernel: ffff8804038ec010 0000000000012bc0 0000000000012bc0 ffff88041432b180
Sep 11 07:48:02 bp-01 kernel: ffff8804038efb28 ffff88021fa72bc0 ffff88041432b180 ffff88041432b180
Sep 11 07:48:02 bp-01 kernel: Call Trace:
Sep 11 07:48:02 bp-01 kernel: [<ffffffff81580999>] schedule+0x29/0x70
Sep 11 07:48:02 bp-01 kernel: [<ffffffff81580a6c>] io_schedule+0x8c/0xd0
Sep 11 07:48:02 bp-01 kernel: [<ffffffff811d0044>] dio_await_completion+0x54/0xd0
Sep 11 07:48:02 bp-01 kernel: [<ffffffff811d264a>] do_blockdev_direct_IO+0x7fa/0xbd0
Sep 11 07:48:02 bp-01 kernel: [<ffffffff81143655>] ? pagevec_lookup_tag+0x25/0x40
Sep 11 07:48:02 bp-01 kernel: [<ffffffff81141327>] ? write_cache_pages+0x147/0x510
Sep 11 07:48:02 bp-01 kernel: [<ffffffff811cd850>] ? I_BDEV+0x10/0x10
Sep 11 07:48:02 bp-01 kernel: [<ffffffff811d2a6c>] __blockdev_direct_IO+0x4c/0x50
Sep 11 07:48:02 bp-01 kernel: [<ffffffff811cd850>] ? I_BDEV+0x10/0x10
Sep 11 07:48:02 bp-01 kernel: [<ffffffff811ce7ee>] blkdev_direct_IO+0x4e/0x50
Sep 11 07:48:02 bp-01 kernel: [<ffffffff811cd850>] ? I_BDEV+0x10/0x10
Sep 11 07:48:02 bp-01 kernel: [<ffffffff811376e3>] generic_file_read_iter+0x143/0x150
Sep 11 07:48:02 bp-01 kernel: [<ffffffff811cdab7>] blkdev_read_iter+0x37/0x40
Sep 11 07:48:02 bp-01 kernel: [<ffffffff811977af>] new_sync_read+0x8f/0xc0
Sep 11 07:48:02 bp-01 kernel: [<ffffffff81197cb3>] vfs_read+0xa3/0x110
Sep 11 07:48:02 bp-01 kernel: [<ffffffff811b47a3>] ? __fdget+0x13/0x20
Sep 11 07:48:02 bp-01 kernel: [<ffffffff81198266>] SyS_read+0x56/0xd0
Sep 11 07:48:02 bp-01 kernel: [<ffffffff810ec4e6>] ? __audit_syscall_exit+0x216/0x2c0
Sep 11 07:48:02 bp-01 kernel: [<ffffffff81584612>] system_call_fastpath+0x16/0x1b
Sep 11 07:48:02 bp-01 kernel: INFO: task kworker/u129:4:24399 blocked for more than 120 seconds.
Sep 11 07:48:02 bp-01 kernel:      Tainted: G            E  3.17.0-rc4 #1
Sep 11 07:48:02 bp-01 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Sep 11 07:48:02 bp-01 kernel: kworker/u129:4  D 0000000000000000     0 24399      2 0x00000080
Sep 11 07:48:02 bp-01 kernel: Workqueue: writeback bdi_writeback_workfn (flush-253:16)
Sep 11 07:48:02 bp-01 kernel: ffff8801fc8bb468 0000000000000046 0000000100000000 ffffffff81a19480
Sep 11 07:48:02 bp-01 kernel: ffff8801fc8b8010 0000000000012bc0 0000000000012bc0 ffff88021721ce40
Sep 11 07:48:02 bp-01 kernel: ffff8801fc8bb558 ffff880414f9e940 ffff880414f9e9b8 ffff8801fc8bb498
Sep 11 07:48:02 bp-01 kernel: Call Trace:
Sep 11 07:48:02 bp-01 kernel: [<ffffffff81580999>] schedule+0x29/0x70
Sep 11 07:48:02 bp-01 kernel: [<ffffffffa0408e9d>] wait_barrier+0xbd/0x230 [raid1]
Sep 11 07:48:02 bp-01 kernel: [<ffffffff8108eb00>] ? bit_waitqueue+0xe0/0xe0
Sep 11 07:48:02 bp-01 kernel: [<ffffffffa040baaa>] make_request+0x9a/0xc00 [raid1]
Sep 11 07:48:02 bp-01 kernel: [<ffffffff81137ff0>] ? mempool_alloc+0x60/0x170
Sep 11 07:48:02 bp-01 kernel: [<ffffffff81137e95>] ? mempool_alloc_slab+0x15/0x20
Sep 11 07:48:02 bp-01 kernel: [<ffffffff81137ff0>] ? mempool_alloc+0x60/0x170
Sep 11 07:48:02 bp-01 kernel: [<ffffffffa0423018>] raid_map+0x18/0x20 [dm_raid]
Sep 11 07:48:02 bp-01 kernel: [<ffffffffa000336a>] __map_bio+0x4a/0x120 [dm_mod]
Sep 11 07:48:02 bp-01 kernel: [<ffffffffa0003723>] __clone_and_map_data_bio+0x113/0x130 [dm_mod]
Sep 11 07:48:02 bp-01 kernel: [<ffffffffa00037ac>] __split_and_process_non_flush+0x6c/0xb0 [dm_mod]
Sep 11 07:48:02 bp-01 kernel: [<ffffffffa0003991>] __split_and_process_bio+0x1a1/0x200 [dm_mod]
Sep 11 07:48:02 bp-01 kernel: [<ffffffffa0003b12>] _dm_request+0x122/0x190 [dm_mod]
Sep 11 07:48:02 bp-01 kernel: [<ffffffffa0003ba8>] dm_request+0x28/0x40 [dm_mod]
Sep 11 07:48:02 bp-01 kernel: [<ffffffff81269620>] generic_make_request+0xc0/0x100
Sep 11 07:48:02 bp-01 kernel: [<ffffffff812696d1>] submit_bio+0x71/0x140
Sep 11 07:48:02 bp-01 kernel: [<ffffffff811c9686>] _submit_bh+0x146/0x220
Sep 11 07:48:02 bp-01 kernel: [<ffffffff811c9770>] submit_bh+0x10/0x20
Sep 11 07:48:02 bp-01 kernel: [<ffffffff811ccf93>] __block_write_full_page.clone.0+0x1a3/0x340
Sep 11 07:48:02 bp-01 kernel: [<ffffffff811cd850>] ? I_BDEV+0x10/0x10
Sep 11 07:48:02 bp-01 kernel: [<ffffffff811cd850>] ? I_BDEV+0x10/0x10
Sep 11 07:48:02 bp-01 kernel: [<ffffffff811cd306>] block_write_full_page+0xc6/0x100
Sep 11 07:48:02 bp-01 kernel: [<ffffffff811ce8f8>] blkdev_writepage+0x18/0x20
Sep 11 07:48:02 bp-01 kernel: [<ffffffff81140067>] __writepage+0x17/0x50
Sep 11 07:48:02 bp-01 kernel: [<ffffffff81141424>] write_cache_pages+0x244/0x510
Sep 11 07:48:02 bp-01 kernel: [<ffffffff81140050>] ? set_page_dirty+0x60/0x60
Sep 11 07:48:02 bp-01 kernel: [<ffffffff81141741>] generic_writepages+0x51/0x80
Sep 11 07:48:02 bp-01 kernel: [<ffffffff81141790>] do_writepages+0x20/0x40
Sep 11 07:48:02 bp-01 kernel: [<ffffffff811bfee9>] __writeback_single_inode+0x49/0x230
Sep 11 07:48:02 bp-01 kernel: [<ffffffff811c3329>] writeback_sb_inodes+0x249/0x360
Sep 11 07:48:02 bp-01 kernel: [<ffffffff811c34de>] __writeback_inodes_wb+0x9e/0xd0
Sep 11 07:48:02 bp-01 kernel: [<ffffffff811c370b>] wb_writeback+0x1fb/0x2c0
Sep 11 07:48:02 bp-01 kernel: [<ffffffff811c3976>] wb_do_writeback+0x1a6/0x1f0
Sep 11 07:48:02 bp-01 kernel: [<ffffffff811c3a30>] bdi_writeback_workfn+0x70/0x210
Sep 11 07:48:02 bp-01 kernel: [<ffffffff8106b762>] process_one_work+0x182/0x450
Sep 11 07:48:02 bp-01 kernel: [<ffffffff8106bb4f>] worker_thread+0x11f/0x3c0
Sep 11 07:48:02 bp-01 kernel: [<ffffffff8106ba30>] ? process_one_work+0x450/0x450
Sep 11 07:48:02 bp-01 kernel: [<ffffffff8107083e>] kthread+0xce/0xf0
Sep 11 07:48:02 bp-01 kernel: [<ffffffff81070770>] ? kthread_freezable_should_stop+0x70/0x70
Sep 11 07:48:02 bp-01 kernel: [<ffffffff8158456c>] ret_from_fork+0x7c/0xb0
Sep 11 07:48:02 bp-01 kernel: [<ffffffff81070770>] ? kthread_freezable_should_stop+0x70/0x70
Sep 11 07:48:02 bp-01 kernel: INFO: task mdX_raid1:27151 blocked for more than 120 seconds.
Sep 11 07:48:02 bp-01 kernel:      Tainted: G            E  3.17.0-rc4 #1
Sep 11 07:48:02 bp-01 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Sep 11 07:48:02 bp-01 kernel: mdX_raid1       D 0000000000000002     0 27151      2 0x00000080
Sep 11 07:48:02 bp-01 kernel: ffff880415bebc88 0000000000000046 0000000000000296 ffff880217260f00
Sep 11 07:48:02 bp-01 kernel: ffff880415be8010 0000000000012bc0 0000000000012bc0 ffff8803fc6982d0
Sep 11 07:48:02 bp-01 kernel: ffff8800de22bd20 ffff880414f9e940 ffff880414f9e9b8 ffff880415bebca8
Sep 11 07:48:02 bp-01 kernel: Call Trace:
Sep 11 07:48:02 bp-01 kernel: [<ffffffff81580999>] schedule+0x29/0x70
Sep 11 07:48:02 bp-01 kernel: [<ffffffffa0408d34>] freeze_array+0x74/0xc0 [raid1]
Sep 11 07:48:02 bp-01 kernel: [<ffffffff8108eb00>] ? bit_waitqueue+0xe0/0xe0
Sep 11 07:48:02 bp-01 kernel: [<ffffffff8126a7a3>] ? blk_queue_bio+0x143/0x320
Sep 11 07:48:02 bp-01 kernel: [<ffffffffa040a14d>] handle_read_error+0x3d/0x300 [raid1]
Sep 11 07:48:02 bp-01 kernel: [<ffffffff81269620>] ? generic_make_request+0xc0/0x100
Sep 11 07:48:02 bp-01 kernel: [<ffffffffa040841b>] ? sync_request_write+0xab/0x1a0 [raid1]
Sep 11 07:48:02 bp-01 kernel: [<ffffffffa040a515>] raid1d+0x105/0x170 [raid1]
Sep 11 07:48:02 bp-01 kernel: [<ffffffff81460e76>] md_thread+0x116/0x150
Sep 11 07:48:02 bp-01 kernel: [<ffffffff8108eb00>] ? bit_waitqueue+0xe0/0xe0
Sep 11 07:48:02 bp-01 kernel: [<ffffffff81460d60>] ? md_rdev_init+0x110/0x110
Sep 11 07:48:02 bp-01 kernel: [<ffffffff8107083e>] kthread+0xce/0xf0
Sep 11 07:48:02 bp-01 kernel: [<ffffffff81070770>] ? kthread_freezable_should_stop+0x70/0x70
Sep 11 07:48:02 bp-01 kernel: [<ffffffff8158456c>] ret_from_fork+0x7c/0xb0
Sep 11 07:48:02 bp-01 kernel: [<ffffffff81070770>] ? kthread_freezable_should_stop+0x70/0x70
Sep 11 07:48:03 bp-01 kernel: INFO: task mdX_resync:27154 blocked for more than 120 seconds.
Sep 11 07:48:03 bp-01 kernel:      Tainted: G            E  3.17.0-rc4 #1
Sep 11 07:48:03 bp-01 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Sep 11 07:48:03 bp-01 kernel: mdX_resync      D 0000000000000004     0 27154      2 0x00000080
Sep 11 07:48:03 bp-01 kernel: ffff880405777c58 0000000000000046 ffff880405777bf8 ffff88021726cf40
Sep 11 07:48:03 bp-01 kernel: ffff880405774010 0000000000012bc0 0000000000012bc0 ffff88040284f180
Sep 11 07:48:03 bp-01 kernel: ffff88041400323c ffff880405777db8 ffff88041400323c ffff880414003010
Sep 11 07:48:03 bp-01 kernel: Call Trace:
Sep 11 07:48:03 bp-01 kernel: [<ffffffff81580999>] schedule+0x29/0x70
Sep 11 07:48:03 bp-01 kernel: [<ffffffff814608e7>] md_do_sync+0xac7/0xd40
Sep 11 07:48:03 bp-01 kernel: [<ffffffff8108eb00>] ? bit_waitqueue+0xe0/0xe0
Sep 11 07:48:03 bp-01 kernel: [<ffffffff81460e76>] md_thread+0x116/0x150
Sep 11 07:48:03 bp-01 kernel: [<ffffffff815804be>] ? __schedule+0x34e/0x6e0
Sep 11 07:48:03 bp-01 kernel: [<ffffffff81460d60>] ? md_rdev_init+0x110/0x110
Sep 11 07:48:03 bp-01 kernel: [<ffffffff8107083e>] kthread+0xce/0xf0
Sep 11 07:48:03 bp-01 kernel: [<ffffffff81580999>] ? schedule+0x29/0x70
Sep 11 07:48:03 bp-01 kernel: [<ffffffff81070770>] ? kthread_freezable_should_stop+0x70/0x70
Sep 11 07:48:03 bp-01 kernel: [<ffffffff8158456c>] ret_from_fork+0x7c/0xb0
Sep 11 07:48:03 bp-01 kernel: [<ffffffff81070770>] ? kthread_freezable_should_stop+0x70/0x70
Sep 11 07:48:03 bp-01 kernel: INFO: task kjournald:27205 blocked for more than 120 seconds.
Sep 11 07:48:03 bp-01 kernel:      Tainted: G            E  3.17.0-rc4 #1
Sep 11 07:48:03 bp-01 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Sep 11 07:48:03 bp-01 kernel: kjournald       D 0000000000000000     0 27205      2 0x00000080
Sep 11 07:48:03 bp-01 kernel: ffff8803f5c07868 0000000000000046 ffff8803f5c07988 ffffffff81a19480
Sep 11 07:48:03 bp-01 kernel: ffff8803f5c04010 0000000000012bc0 0000000000012bc0 ffff8803f5774ec0
Sep 11 07:48:03 bp-01 kernel: ffff880216e06000 ffff880414f9e940 ffff880414f9e9b8 ffff8803f5c07898
Sep 11 07:48:03 bp-01 kernel: Call Trace:
Sep 11 07:48:03 bp-01 kernel: [<ffffffff81580999>] schedule+0x29/0x70
Sep 11 07:48:03 bp-01 kernel: [<ffffffffa0408e9d>] wait_barrier+0xbd/0x230 [raid1]
Sep 11 07:48:03 bp-01 kernel: [<ffffffff8108eb00>] ? bit_waitqueue+0xe0/0xe0
Sep 11 07:48:03 bp-01 kernel: [<ffffffffa040baaa>] make_request+0x9a/0xc00 [raid1]
Sep 11 07:48:03 bp-01 kernel: [<ffffffff81137ff0>] ? mempool_alloc+0x60/0x170
Sep 11 07:48:03 bp-01 kernel: [<ffffffffa0423018>] raid_map+0x18/0x20 [dm_raid]
Sep 11 07:48:03 bp-01 kernel: [<ffffffffa000336a>] __map_bio+0x4a/0x120 [dm_mod]
Sep 11 07:48:03 bp-01 kernel: [<ffffffffa0003723>] __clone_and_map_data_bio+0x113/0x130 [dm_mod]
Sep 11 07:48:03 bp-01 kernel: [<ffffffffa00037ac>] __split_and_process_non_flush+0x6c/0xb0 [dm_mod]
Sep 11 07:48:03 bp-01 kernel: [<ffffffffa0003991>] __split_and_process_bio+0x1a1/0x200 [dm_mod]
Sep 11 07:48:03 bp-01 kernel: [<ffffffffa0003b12>] _dm_request+0x122/0x190 [dm_mod]
Sep 11 07:48:03 bp-01 kernel: [<ffffffffa0003ba8>] dm_request+0x28/0x40 [dm_mod]
Sep 11 07:48:03 bp-01 kernel: [<ffffffff81269620>] generic_make_request+0xc0/0x100
Sep 11 07:48:03 bp-01 kernel: [<ffffffff812696d1>] submit_bio+0x71/0x140
Sep 11 07:48:03 bp-01 kernel: [<ffffffff811c9686>] _submit_bh+0x146/0x220
Sep 11 07:48:03 bp-01 kernel: [<ffffffffa042e553>] journal_do_submit_data+0x43/0x60 [jbd]
Sep 11 07:48:03 bp-01 kernel: [<ffffffffa042ea12>] journal_submit_data_buffers+0x202/0x2f0 [jbd]
Sep 11 07:48:03 bp-01 kernel: [<ffffffffa042eda6>] journal_commit_transaction+0x2a6/0xf80 [jbd]
Sep 11 07:48:03 bp-01 kernel: [<ffffffff8108847f>] ? put_prev_entity+0x2f/0x400
Sep 11 07:48:03 bp-01 kernel: [<ffffffff810b21bb>] ? try_to_del_timer_sync+0x5b/0x70
Sep 11 07:48:03 bp-01 kernel: [<ffffffffa0432ae1>] kjournald+0xf1/0x270 [jbd]
Sep 11 07:48:03 bp-01 kernel: [<ffffffff8108eb00>] ? bit_waitqueue+0xe0/0xe0
Sep 11 07:48:03 bp-01 kernel: [<ffffffffa04329f0>] ? commit_timeout+0x10/0x10 [jbd]
Sep 11 07:48:03 bp-01 kernel: [<ffffffff8107083e>] kthread+0xce/0xf0
Sep 11 07:48:03 bp-01 kernel: [<ffffffff81070770>] ? kthread_freezable_should_stop+0x70/0x70
Sep 11 07:48:03 bp-01 kernel: [<ffffffff8158456c>] ret_from_fork+0x7c/0xb0
Sep 11 07:48:03 bp-01 kernel: [<ffffffff81070770>] ? kthread_freezable_should_stop+0x70/0x70
Sep 11 08:40:01 bp-01 auditd[1981]: Audit daemon rotating log files