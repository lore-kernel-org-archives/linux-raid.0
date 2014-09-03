From: Brassow Jonathan <jbrassow@redhat.com>
Subject: Re: raid1 data corruption during resync
Date: Wed, 3 Sep 2014 16:39:52 -0500
Message-ID: <4A5FFCF0-B3D2-464D-AE72-9CFCD2F23139@redhat.com>
References: <20A5228D-DD63-4A6C-B2C6-B0C38996E636@gmail.com> <EAC50175-42D9-43BA-ADE2-1A50BD0581CB@redhat.com> <18B7DF88-26D1-44B8-8F72-2159A2DF868D@gmail.com> <20140903095507.032e8c6d@notabene.brown> <F9B1D613-79EF-488E-8D41-4C1BDBC6D4BE@redhat.com> <20140903113151.4099292b@notabene.brown> <7703179B-1291-4471-B84F-FEE1E28F31A0@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7703179B-1291-4471-B84F-FEE1E28F31A0@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Eivind Sarto <eivindsarto@gmail.com>, "linux-raid@vger.kernel.org Raid" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Sep 2, 2014, at 8:45 PM, Brassow Jonathan wrote:

> 
> On Sep 2, 2014, at 8:31 PM, NeilBrown wrote:
> 
>> Thanks for the details Jon.  I don't suppose you have a stack trace from an
>> upstream kernel?  Not that I doubt you have one, and I suspect it is very
>> similar.  But I've learnt not to trust "suspect" and "presume" and "no doubt".
>> 
>> I'll have a look anyway.
> 
> Indeed - me too.  I'll get started on recreating it on the latest upstream kernel now.  It does take several hours to reproduce on average, so I likely won't send the update until tomorrow.
> 
> brassow

The test being run does the following:
1) Writes I/O to an FS which is sitting on a RAID dev (created via LVM, but using MD personalities)
2) The RAID dev is undergoing its initial resync
3) The device in slot 0 suffers a failure.  (I can't be sure at the moment if I've seen this trigger from a device failure from a different slot.)
Sorry the test is so involved.  I haven't been able to create a simple reproducer and the tests I have take quite a while (i.e. a number of iterations) to hit the problem.  These backtraces came after 45min, which is actually really quick compared to what I've seen.

The kernel I used was 3.17.0-rc3.  It is unmodified - I have not applied the patch for reads to potentially resync'ing areas.

 brassow

Sep  3 09:18:36 bp-01 kernel: INFO: task kworker/u130:1:6600 blocked for more than 120 seconds.
Sep  3 09:18:36 bp-01 kernel:      Tainted: G            E  3.17.0-rc3 #1
Sep  3 09:18:36 bp-01 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Sep  3 09:18:36 bp-01 kernel: kworker/u130:1  D 0000000000000008     0  6600      2 0x00000080
Sep  3 09:18:36 bp-01 kernel: Workqueue: writeback bdi_writeback_workfn (flush-253:11)
Sep  3 09:18:36 bp-01 kernel: ffff880415b3b868 0000000000000046 ffff880415b3b858 ffff88021727efc0
Sep  3 09:18:36 bp-01 kernel: ffff880415b38010 0000000000012bc0 0000000000012bc0 ffff8804024e4150
Sep  3 09:18:36 bp-01 kernel: ffff880415b3b838 ffff88041ea52bc0 ffff8804024e4150 ffff880415b3b920
Sep  3 09:18:36 bp-01 kernel: Call Trace:
Sep  3 09:18:36 bp-01 kernel: [<ffffffff81580830>] ? yield_to+0x180/0x180
Sep  3 09:18:36 bp-01 kernel: [<ffffffff81580549>] schedule+0x29/0x70
Sep  3 09:18:36 bp-01 kernel: [<ffffffff8158061c>] io_schedule+0x8c/0xd0
Sep  3 09:18:36 bp-01 kernel: [<ffffffff8158085c>] bit_wait_io+0x2c/0x50
Sep  3 09:18:36 bp-01 kernel: [<ffffffff81580946>] __wait_on_bit_lock+0x76/0xb0
Sep  3 09:18:36 bp-01 kernel: [<ffffffff81135057>] __lock_page+0x67/0x70
Sep  3 09:18:36 bp-01 kernel: [<ffffffff8108eb90>] ? wake_atomic_t_function+0x40/0x40
Sep  3 09:18:36 bp-01 kernel: [<ffffffff81141468>] write_cache_pages+0x318/0x510
Sep  3 09:18:36 bp-01 kernel: [<ffffffffa01d8b5a>] ? ext4_writepages+0x5a/0x6a0 [ext4]
Sep  3 09:18:36 bp-01 kernel: [<ffffffff8113ffc0>] ? set_page_dirty+0x60/0x60
Sep  3 09:18:36 bp-01 kernel: [<ffffffff811416b1>] generic_writepages+0x51/0x80
Sep  3 09:18:36 bp-01 kernel: [<ffffffff81141715>] do_writepages+0x35/0x40
Sep  3 09:18:36 bp-01 kernel: [<ffffffff811bfcf9>] __writeback_single_inode+0x49/0x230
Sep  3 09:18:36 bp-01 kernel: [<ffffffff8108eeef>] ? wake_up_bit+0x2f/0x40
Sep  3 09:18:36 bp-01 kernel: [<ffffffff811c3139>] writeback_sb_inodes+0x249/0x360
Sep  3 09:18:36 bp-01 kernel: [<ffffffff8119a415>] ? put_super+0x25/0x40
Sep  3 09:18:36 bp-01 kernel: [<ffffffff811c32ee>] __writeback_inodes_wb+0x9e/0xd0
Sep  3 09:18:36 bp-01 kernel: [<ffffffff811c351b>] wb_writeback+0x1fb/0x2c0
Sep  3 09:18:36 bp-01 kernel: [<ffffffff811c3662>] wb_do_writeback+0x82/0x1f0
Sep  3 09:18:36 bp-01 kernel: [<ffffffff81078fda>] ? ttwu_do_activate.clone.0+0x4a/0x60
Sep  3 09:18:36 bp-01 kernel: [<ffffffff811c3840>] bdi_writeback_workfn+0x70/0x210
Sep  3 09:18:36 bp-01 kernel: [<ffffffff8106b762>] process_one_work+0x182/0x450
Sep  3 09:18:36 bp-01 kernel: [<ffffffff8106bb4f>] worker_thread+0x11f/0x3c0
Sep  3 09:18:36 bp-01 kernel: [<ffffffff8106ba30>] ? process_one_work+0x450/0x450
Sep  3 09:18:36 bp-01 kernel: [<ffffffff8107083e>] kthread+0xce/0xf0
Sep  3 09:18:36 bp-01 kernel: [<ffffffff81070770>] ? kthread_freezable_should_stop+0x70/0x70
Sep  3 09:18:36 bp-01 kernel: [<ffffffff8158412c>] ret_from_fork+0x7c/0xb0
Sep  3 09:18:36 bp-01 kernel: [<ffffffff81070770>] ? kthread_freezable_should_stop+0x70/0x70
Sep  3 09:18:36 bp-01 kernel: INFO: task kworker/0:4:8765 blocked for more than 120 seconds.
Sep  3 09:18:36 bp-01 kernel:      Tainted: G            E  3.17.0-rc3 #1
Sep  3 09:18:36 bp-01 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Sep  3 09:18:36 bp-01 kernel: kworker/0:4     D 0000000000000000     0  8765      2 0x00000080
Sep  3 09:18:36 bp-01 kernel: Workqueue: kcopyd do_work [dm_mod]
Sep  3 09:18:36 bp-01 kernel: ffff8802102ab898 0000000000000046 0000000000000000 ffffffff81a19480
Sep  3 09:18:36 bp-01 kernel: ffff8802102a8010 0000000000012bc0 0000000000012bc0 ffff880215950010
Sep  3 09:18:36 bp-01 kernel: ffff8802102ab898 ffff88040171e100 ffff88040171e178 ffff8802102ab8c8
Sep  3 09:18:36 bp-01 kernel: Call Trace:
Sep  3 09:18:36 bp-01 kernel: [<ffffffff81580549>] schedule+0x29/0x70
Sep  3 09:18:36 bp-01 kernel: [<ffffffffa0389e99>] wait_barrier+0xb9/0x260 [raid1]
Sep  3 09:18:36 bp-01 kernel: [<ffffffff8108eb00>] ? bit_waitqueue+0xe0/0xe0
Sep  3 09:18:36 bp-01 kernel: [<ffffffff8108ee13>] ? __wake_up+0x53/0x70
Sep  3 09:18:36 bp-01 kernel: [<ffffffffa038caaa>] make_request+0x9a/0xc00 [raid1]
Sep  3 09:18:37 bp-01 lvm[2109]: device-mapper: waitevent ioctl on (LVM-PSbaO1Zwzw2wYurZrkrTkI5grmcS3IQ3ot9VJPwplnllFf45AU5vBkbtjfLU0adG) failed: Interrupted system call
Sep  3 09:18:37 bp-01 kernel: [<ffffffff81137f60>] ? mempool_alloc+0x60/0x170
Sep  3 09:18:37 bp-01 kernel: [<ffffffff81186ea8>] ? cache_alloc_refill+0x98/0x2c0
Sep  3 09:18:37 bp-01 kernel: [<ffffffffa03a4018>] raid_map+0x18/0x20 [dm_raid]
Sep  3 09:18:37 bp-01 kernel: [<ffffffffa000336a>] __map_bio+0x4a/0x120 [dm_mod]
Sep  3 09:18:37 bp-01 kernel: [<ffffffffa0003723>] __clone_and_map_data_bio+0x113/0x130 [dm_mod]
Sep  3 09:18:37 bp-01 kernel: [<ffffffffa00037ac>] __split_and_process_non_flush+0x6c/0xb0 [dm_mod]
Sep  3 09:18:37 bp-01 kernel: [<ffffffffa0003991>] __split_and_process_bio+0x1a1/0x200 [dm_mod]
Sep  3 09:18:37 bp-01 kernel: [<ffffffffa0003b12>] _dm_request+0x122/0x190 [dm_mod]
Sep  3 09:18:37 bp-01 kernel: [<ffffffffa0003ba8>] dm_request+0x28/0x40 [dm_mod]
Sep  3 09:18:37 bp-01 kernel: [<ffffffff812693b0>] generic_make_request+0xc0/0x100
Sep  3 09:18:37 bp-01 kernel: [<ffffffffa03ba00c>] pending_complete+0x13c/0x2a0 [dm_snapshot]
Sep  3 09:18:37 bp-01 kernel: [<ffffffffa03ba29e>] commit_callback+0xe/0x10 [dm_snapshot]
Sep  3 09:18:37 bp-01 kernel: [<ffffffffa03bcea8>] persistent_commit_exception+0xb8/0x160 [dm_snapshot]
Sep  3 09:18:37 bp-01 kernel: [<ffffffffa03ba1a3>] complete_exception+0x33/0x50 [dm_snapshot]
Sep  3 09:18:37 bp-01 kernel: [<ffffffffa03ba26a>] copy_callback+0xaa/0xd0 [dm_snapshot]
Sep  3 09:18:37 bp-01 kernel: [<ffffffffa03ba1c0>] ? complete_exception+0x50/0x50 [dm_snapshot]
Sep  3 09:18:37 bp-01 kernel: [<ffffffffa000b788>] run_complete_job+0x98/0xe0 [dm_mod]
Sep  3 09:18:37 bp-01 kernel: [<ffffffffa000b21b>] process_jobs+0x5b/0x100 [dm_mod]
Sep  3 09:18:37 bp-01 kernel: [<ffffffffa000b6f0>] ? dispatch_job+0x80/0x80 [dm_mod]
Sep  3 09:18:37 bp-01 kernel: [<ffffffffa000b2ff>] do_work+0x3f/0x80 [dm_mod]
Sep  3 09:18:37 bp-01 kernel: [<ffffffff8106b762>] process_one_work+0x182/0x450
Sep  3 09:18:37 bp-01 kernel: [<ffffffff8106bb4f>] worker_thread+0x11f/0x3c0
Sep  3 09:18:37 bp-01 kernel: [<ffffffff8106ba30>] ? process_one_work+0x450/0x450
Sep  3 09:18:37 bp-01 kernel: [<ffffffff8107083e>] kthread+0xce/0xf0
Sep  3 09:18:37 bp-01 kernel: [<ffffffff81070770>] ? kthread_freezable_should_stop+0x70/0x70
Sep  3 09:18:37 bp-01 kernel: [<ffffffff8158412c>] ret_from_fork+0x7c/0xb0
Sep  3 09:18:37 bp-01 kernel: [<ffffffff81070770>] ? kthread_freezable_should_stop+0x70/0x70
Sep  3 09:18:37 bp-01 kernel: INFO: task kjournald:12268 blocked for more than 120 seconds.
Sep  3 09:18:37 bp-01 kernel:      Tainted: G            E  3.17.0-rc3 #1
Sep  3 09:18:37 bp-01 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Sep  3 09:18:37 bp-01 kernel: kjournald       D 0000000000000000     0 12268      2 0x00000080
Sep  3 09:18:37 bp-01 kernel: ffff88040d373c08 0000000000000046 ffff88040d373bd8 ffffffff81a19480
Sep  3 09:18:37 bp-01 kernel: ffff88040d370010 0000000000012bc0 0000000000012bc0 ffff8804153a0e80
Sep  3 09:18:37 bp-01 kernel: ffff88040d373c08 ffff88021fa12bc0 ffff8804153a0e80 ffffffff81580830
Sep  3 09:18:37 bp-01 kernel: Call Trace:
Sep  3 09:18:37 bp-01 kernel: [<ffffffff81580830>] ? yield_to+0x180/0x180
Sep  3 09:18:37 bp-01 kernel: [<ffffffff81580549>] schedule+0x29/0x70
Sep  3 09:18:37 bp-01 kernel: [<ffffffff8158061c>] io_schedule+0x8c/0xd0
Sep  3 09:18:37 bp-01 kernel: [<ffffffff8158085c>] bit_wait_io+0x2c/0x50
Sep  3 09:18:37 bp-01 kernel: [<ffffffff81580b45>] __wait_on_bit+0x65/0x90
Sep  3 09:18:37 bp-01 kernel: [<ffffffff81580830>] ? yield_to+0x180/0x180
Sep  3 09:18:37 bp-01 kernel: [<ffffffff81580be8>] out_of_line_wait_on_bit+0x78/0x90
Sep  3 09:18:37 bp-01 kernel: [<ffffffff8108eb90>] ? wake_atomic_t_function+0x40/0x40
Sep  3 09:18:37 bp-01 kernel: [<ffffffff811ca14e>] __wait_on_buffer+0x2e/0x30
Sep  3 09:18:37 bp-01 kernel: [<ffffffffa0448372>] journal_commit_transaction+0x872/0xf80 [jbd]
Sep  3 09:18:37 bp-01 kernel: [<ffffffff8108847f>] ? put_prev_entity+0x2f/0x400
Sep  3 09:18:37 bp-01 kernel: [<ffffffff810b21bb>] ? try_to_del_timer_sync+0x5b/0x70
Sep  3 09:18:37 bp-01 kernel: [<ffffffffa044bae1>] kjournald+0xf1/0x270 [jbd]
Sep  3 09:18:37 bp-01 kernel: [<ffffffff8108eb00>] ? bit_waitqueue+0xe0/0xe0
Sep  3 09:18:37 bp-01 kernel: [<ffffffffa044b9f0>] ? commit_timeout+0x10/0x10 [jbd]
Sep  3 09:18:37 bp-01 kernel: [<ffffffff8107083e>] kthread+0xce/0xf0
Sep  3 09:18:37 bp-01 kernel: [<ffffffff81070770>] ? kthread_freezable_should_stop+0x70/0x70
Sep  3 09:18:37 bp-01 kernel: [<ffffffff8158412c>] ret_from_fork+0x7c/0xb0
Sep  3 09:18:37 bp-01 kernel: [<ffffffff81070770>] ? kthread_freezable_should_stop+0x70/0x70
Sep  3 09:18:37 bp-01 kernel: INFO: task xdoio:12364 blocked for more than 120 seconds.
Sep  3 09:18:37 bp-01 kernel:      Tainted: G            E  3.17.0-rc3 #1
Sep  3 09:18:37 bp-01 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Sep  3 09:18:37 bp-01 kernel: xdoio           D 0000000000000005     0 12364  12363 0x00000080
Sep  3 09:18:37 bp-01 kernel: ffff8804037af978 0000000000000082 ffff8804037af948 ffff88021726c1d0
Sep  3 09:18:37 bp-01 kernel: ffff8804037ac010 0000000000012bc0 0000000000012bc0 ffff8804063a0050
Sep  3 09:18:37 bp-01 kernel: ffff8804037af978 ffff88021fab2bc0 ffff8804063a0050 ffff8804037afa30
Sep  3 09:18:37 bp-01 kernel: Call Trace:
Sep  3 09:18:37 bp-01 kernel: [<ffffffff81580830>] ? yield_to+0x180/0x180
Sep  3 09:18:37 bp-01 kernel: [<ffffffff81580549>] schedule+0x29/0x70
Sep  3 09:18:37 bp-01 kernel: [<ffffffff8158061c>] io_schedule+0x8c/0xd0
Sep  3 09:18:37 bp-01 kernel: [<ffffffff8158085c>] bit_wait_io+0x2c/0x50
Sep  3 09:18:37 bp-01 kernel: [<ffffffff81580946>] __wait_on_bit_lock+0x76/0xb0
Sep  3 09:18:37 bp-01 kernel: [<ffffffff81580830>] ? yield_to+0x180/0x180
Sep  3 09:18:37 bp-01 kernel: [<ffffffff815809f8>] out_of_line_wait_on_bit_lock+0x78/0x90
Sep  3 09:18:37 bp-01 kernel: [<ffffffff8108eb90>] ? wake_atomic_t_function+0x40/0x40
Sep  3 09:18:37 bp-01 kernel: [<ffffffff811ca36e>] __lock_buffer+0x2e/0x30
Sep  3 09:18:37 bp-01 kernel: [<ffffffff811cb520>] __sync_dirty_buffer+0xa0/0xd0
Sep  3 09:18:37 bp-01 kernel: [<ffffffff811cb563>] sync_dirty_buffer+0x13/0x20
Sep  3 09:18:37 bp-01 kernel: [<ffffffffa0446e12>] journal_dirty_data+0x1f2/0x260 [jbd]
Sep  3 09:18:37 bp-01 kernel: [<ffffffffa0464200>] ext3_journal_dirty_data+0x20/0x50 [ext3]
Sep  3 09:18:37 bp-01 kernel: [<ffffffffa0464255>] journal_dirty_data_fn+0x25/0x30 [ext3]
Sep  3 09:18:37 bp-01 kernel: [<ffffffffa04638d4>] walk_page_buffers+0x84/0xc0 [ext3]
Sep  3 09:18:37 bp-01 kernel: [<ffffffffa0464230>] ? ext3_journal_dirty_data+0x50/0x50 [ext3]
Sep  3 09:18:37 bp-01 kernel: [<ffffffffa046797f>] ext3_ordered_write_end+0xaf/0x1e0 [ext3]
Sep  3 09:18:37 bp-01 kernel: [<ffffffff81134b42>] generic_perform_write+0x112/0x1c0
Sep  3 09:18:37 bp-01 kernel: [<ffffffff81137aaf>] __generic_file_write_iter+0x18f/0x390
Sep  3 09:18:37 bp-01 kernel: [<ffffffff81137cfe>] generic_file_write_iter+0x4e/0xd0
Sep  3 09:18:37 bp-01 kernel: [<ffffffff81197347>] do_iter_readv_writev+0x77/0xb0
Sep  3 09:18:37 bp-01 kernel: [<ffffffff8122e483>] ? security_file_permission+0x23/0x90
Sep  3 09:18:37 bp-01 kernel: [<ffffffff81137cb0>] ? __generic_file_write_iter+0x390/0x390
Sep  3 09:18:37 bp-01 kernel: [<ffffffff81137cb0>] ? __generic_file_write_iter+0x390/0x390
Sep  3 09:18:37 bp-01 kernel: [<ffffffff81198a60>] do_readv_writev+0xd0/0x320
Sep  3 09:18:37 bp-01 kernel: [<ffffffff81137cb0>] ? __generic_file_write_iter+0x390/0x390
Sep  3 09:18:37 bp-01 kernel: [<ffffffff81197400>] ? do_sync_readv_writev+0x80/0x80
Sep  3 09:18:37 bp-01 kernel: [<ffffffff810c724f>] ? do_futex+0xaf/0x1b0
Sep  3 09:18:37 bp-01 kernel: [<ffffffff81198cf1>] vfs_writev+0x41/0x50
Sep  3 09:18:37 bp-01 kernel: [<ffffffff81198e26>] SyS_writev+0x56/0xf0
Sep  3 09:18:37 bp-01 kernel: [<ffffffff810ec456>] ? __audit_syscall_exit+0x216/0x2c0
Sep  3 09:18:37 bp-01 kernel: [<ffffffff815841d2>] system_call_fastpath+0x16/0x1b

