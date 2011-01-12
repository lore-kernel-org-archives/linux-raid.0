From: David Flynn <davidf@rd.bbc.co.uk>
Subject: md raid5 blocked in get_active_stripe after disk failure
Date: Wed, 12 Jan 2011 13:04:20 +0000
Message-ID: <20110112130420.GA6275@rd.bbc.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a fileserver that mounts an md raid5 array with 20 active disks,
holding an xfs filesystem which is then exported via nfs. (system is
a twin-quadcore intel, 64bit)

I've witnessed a failure which resulted in a reproducible lockup of the
array after one of the array components suffered a read error.

The order of events was roughly:
 1) disk fails read:
   <snip mny errors>
   [103364.894588] sd 3:4:0:0: [sdt] Add. Sense: Unrecovered read error - auto reallocate failed
   [103364.949216] sd 3:4:0:0: [sdt] CDB: Read(10): 28 00 0b d3 95 3f 00 01 00 00
   [103364.969589] end_request: I/O error, dev sdt, sector 198415713
   [103364.969619] ata4: EH complete
 2) nfs clients report hung tasks
 3) file server reports hung tasks
     (re-reviewing this in the cold light of the morning, makes me wonder
      if the cause of the problem isn't in pid 2777, eitherway it is too early
      to thrink straight)
    [log is included at end of message]

 4) an hour passes, i'm alerted to the issue
 5) top reports 30-40% cpu utilization in iowait, the rest idle
 6) remembering an old strip_cache issue, i note that:
     /sys/class/block/md1/md/stripe_cache_active = 0
     /sys/class/block/md1/md/stripe_cache_size = 256
     doubling stripe_cache_size has no effect.
 7) mark sdt1 as faulty:
    [109593.732485] md/raid:md1: Disk failure on sdt1, disabling device.
    [109593.732487] <1>md/raid:md1: Operation continuing on 19 devices.
 8) try to remove sdt1:
    [110152.939464] md: cannot remove active disk sdt1 from md1 ...
 9) attempting to run perf top blocks.
10) use fdisk to partition another disk, (write out partition table is ok)
    but fdisk blocks while requesting a partition table scan. although
    using hdparm -z directly on the disk succeeds.
11) can't reboot, can't sync, can't unmount file systems, etc.,
    eventually powercycle the machine

When the machine reboots, restarts the array (was dirty, so rebuilds),
remounts the filesystems and nfs comes back up and the clients retry their
requests, the disk error occurred again and md locked up in the same way.

Any thoughts are greatly appreciated.

Kind regards,

..david


== kernel log from (3) above ==
   [103561.064060] INFO: task md1_raid5:2371 blocked for more than 120 seconds.
   [103561.109844] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
   [103561.162479] md1_raid5     D 0000000101892965     0  2371      2 0x00000000
   [103561.209434]  ffff880426984af0 0000000000000046 ffff88042ae12fb0 ffff880000000000
   [103561.259613]  ffffffff81632020 00000000000154c0 00000000000154c0 00000000000154c0
   [103561.309815]  ffff880425123fd8 00000000000154c0 ffff880426984af0 ffff880425123fd8
   [103561.359995] Call Trace:
   [103561.380375]  [<ffffffffa026b133>] ? get_active_stripe+0xfe/0x55b [raid456]
   [103561.427278]  [<ffffffff8103f760>] ? default_wake_function+0x0/0xf
   [103561.469536]  [<ffffffffa026cf92>] ? raid5d+0x149/0x3f2 [raid456]
   [103561.511297]  [<ffffffffa0228010>] ? md_thread+0xf2/0x110 [md_mod]
   [103561.553580]  [<ffffffff8105b995>] ? autoremove_wake_function+0x0/0x2a
   [103561.597882]  [<ffffffffa0227f1e>] ? md_thread+0x0/0x110 [md_mod]
   [103561.639553]  [<ffffffff8105b541>] ? kthread+0x75/0x7d
   [103561.675472]  [<ffffffff810097e4>] ? kernel_thread_helper+0x4/0x10
   [103561.717604]  [<ffffffff8105b4cc>] ? kthread+0x0/0x7d
   [103561.752937]  [<ffffffff810097e0>] ? kernel_thread_helper+0x0/0x10
   [103561.795009] INFO: task flush-9:1:2491 blocked for more than 120 seconds.
   [103561.840753] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
   [103561.893356] flush-9:1     D 0000000101892965     0  2491      2 0x00000000
   [103561.940355]  ffff880426b206d0 0000000000000046 ffff88042486d70c ffffffff00000000
   [103561.990544]  ffff88042e0da8e0 00000000000154c0 00000000000154c0 00000000000154c0
   [103562.040754]  ffff88042486dfd8 00000000000154c0 ffff880426b206d0 ffff88042486dfd8
   [103562.090973] Call Trace:
   [103562.111360]  [<ffffffffa026b133>] ? get_active_stripe+0xfe/0x55b [raid456]
   [103562.158352]  [<ffffffff8103f760>] ? default_wake_function+0x0/0xf
   [103562.200605]  [<ffffffffa026eafa>] ? make_request+0x1dd/0x403 [raid456]
   [103562.245486]  [<ffffffff8105b995>] ? autoremove_wake_function+0x0/0x2a
   [103562.289870]  [<ffffffffa02267ca>] ? md_make_request+0xd0/0x1d4 [md_mod]
   [103562.335319]  [<ffffffff8117583c>] ? generic_make_request+0x27a/0x2f0
   [103562.379181]  [<ffffffff810b09dd>] ? mempool_alloc+0x53/0x106
   [103562.418843]  [<ffffffff81175983>] ? submit_bio+0xd1/0xed
   [103562.456376]  [<ffffffff8118b006>] ? radix_tree_tag_set+0x64/0xc8
   [103562.498025]  [<ffffffff8110b97c>] ? __bio_add_page+0x156/0x1f1
   [103562.538646]  [<ffffffffa05aa640>] ? xfs_submit_ioend_bio+0x53/0x5f [xfs]
   [103562.584444]  [<ffffffffa05aa702>] ? xfs_submit_ioend+0xb6/0xd8 [xfs]
   [103562.628140]  [<ffffffffa05ab62a>] ? xfs_page_state_convert+0x4bd/0x50e [xfs]
   [103562.676040]  [<ffffffffa05ab843>] ? xfs_vm_writepage+0xef/0x12c [xfs]
   [103562.720299]  [<ffffffff810b548a>] ? __writepage+0xa/0x21
   [103562.757774]  [<ffffffff810b6504>] ? write_cache_pages+0x1d8/0x2ec
   [103562.799928]  [<ffffffff810b5480>] ? __writepage+0x0/0x21
   [103562.837380]  [<ffffffff81102cd4>] ? writeback_single_inode+0xd1/0x2e5
   [103562.881556]  [<ffffffff8110323e>] ? writeback_sb_inodes+0x136/0x204
   [103562.924674]  [<ffffffff811038e3>] ? writeback_inodes_wb+0x127/0x139
   [103562.967663]  [<ffffffff81103a83>] ? wb_writeback+0x18e/0x208
   [103563.006933]  [<ffffffff81103c30>] ? wb_do_writeback+0x133/0x149
   [103563.047721]  [<ffffffff81103c80>] ? bdi_writeback_task+0x3a/0x112
   [103563.089528]  [<ffffffff8105b8bb>] ? bit_waitqueue+0x14/0xa1
   [103563.128129]  [<ffffffff810c1f4f>] ? bdi_start_fn+0x0/0xc3
   [103563.165632]  [<ffffffff810c1fb2>] ? bdi_start_fn+0x63/0xc3
   [103563.165644]  [<ffffffff810c1f4f>] ? bdi_start_fn+0x0/0xc3
   [103563.165656]  [<ffffffff8105b541>] ? kthread+0x75/0x7d
   [103563.165667]  [<ffffffff810097e4>] ? kernel_thread_helper+0x4/0x10
   [103563.165679]  [<ffffffff8105b4cc>] ? kthread+0x0/0x7d
   [103563.165690]  [<ffffffff810097e0>] ? kernel_thread_helper+0x0/0x10
   [103563.165708] INFO: task xfssyncd/md1:2777 blocked for more than 120 seconds.
   [103563.165715] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
   [103563.165724] xfssyncd/md1  D ffff88042b1c3680     0  2777      2 0x00000000
   [103563.165735]  ffff88042b1c3680 0000000000000046 ffff88042a4ed000 ffffffffa002b0e0
   [103563.165747]  ffff88042e121b40 00000000000154c0 00000000000154c0 00000000000154c0
   [103563.165758]  ffff880424e61fd8 00000000000154c0 ffff88042b1c3680 ffff880424e61fd8
   [103563.165770] Call Trace:
   [103563.165797]  [<ffffffffa002b0e0>] ? scsi_setup_blk_pc_cmnd+0x39/0xff [scsi_mod]
   [103563.165823]  [<ffffffffa01a426c>] ? __ata_scsi_queuecmd+0x17f/0x1d6 [libata]
   [103563.165838]  [<ffffffff8100e7d9>] ? sched_clock+0x5/0x8
   [103563.165850]  [<ffffffffa0269520>] ? raid5_quiesce+0xe3/0x19b [raid456]
   [103563.165864]  [<ffffffff8103f760>] ? default_wake_function+0x0/0xf
   [103563.165877]  [<ffffffffa026e94e>] ? make_request+0x31/0x403 [raid456]
   [103563.165893]  [<ffffffffa02267ca>] ? md_make_request+0xd0/0x1d4 [md_mod]
   [103563.165906]  [<ffffffff8117583c>] ? generic_make_request+0x27a/0x2f0
   [103563.165919]  [<ffffffff810b09dd>] ? mempool_alloc+0x53/0x106
   [103563.165931]  [<ffffffff81175983>] ? submit_bio+0xd1/0xed
   [103563.165959]  [<ffffffffa05ac4d2>] ? _xfs_buf_ioapply+0x212/0x24f [xfs]
   [103563.165987]  [<ffffffffa0597ace>] ? xlog_bdstrat+0x3a/0x3e [xfs]
   [103563.166015]  [<ffffffffa05ad430>] ? xfs_buf_iorequest+0x75/0x8e [xfs]
   [103563.166043]  [<ffffffffa0597ace>] ? xlog_bdstrat+0x3a/0x3e [xfs]
   [103563.166070]  [<ffffffffa0597ce1>] ? xlog_sync+0x20f/0x326 [xfs]
   [103563.166098]  [<ffffffffa05986d4>] ? _xfs_log_force+0xd9/0x196 [xfs]
   [103563.166111]  [<ffffffff81050771>] ? process_timeout+0x0/0xa
   [103563.166138]  [<ffffffffa0598915>] ? xfs_log_force+0xb/0x2a [xfs]
   [103563.166167]  [<ffffffffa05b537f>] ? xfs_sync_worker+0x14/0x60 [xfs]
   [103563.166195]  [<ffffffffa05b4c2e>] ? xfssyncd+0x155/0x1d1 [xfs]
   [103563.166223]  [<ffffffffa05b4ad9>] ? xfssyncd+0x0/0x1d1 [xfs]
   [103563.166235]  [<ffffffff8105b541>] ? kthread+0x75/0x7d
   [103563.166246]  [<ffffffff810097e4>] ? kernel_thread_helper+0x4/0x10
   [103563.166258]  [<ffffffff8105b4cc>] ? kthread+0x0/0x7d
   [103563.166269]  [<ffffffff810097e0>] ? kernel_thread_helper+0x0/0x10
   [103563.166284] INFO: task nfsd:3494 blocked for more than 120 seconds.
   [103563.166292] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
   [103563.166302] nfsd          D 000000010189190f     0  3494      2 0x00000000
   [103563.166314]  ffff88042ae14420 0000000000000046 ffff880200001000 0000000000000000
   [103563.166325]  ffff88042e0d8da0 00000000000154c0 00000000000154c0 00000000000154c0
   [103563.166337]  ffff880420a03fd8 00000000000154c0 ffff88042ae14420 ffff880420a03fd8
   [103563.166348] Call Trace:
   [103563.166354]  [<ffffffff8100e806>] ? read_tsc+0x5/0x16
   [103563.166365]  [<ffffffff810aefe5>] ? sync_page+0x0/0x45
   [103563.166378]  [<ffffffff813059f0>] ? io_schedule+0x6b/0xaa
   [103563.166390]  [<ffffffff810af026>] ? sync_page+0x41/0x45
   [103563.166399]  [<ffffffff81305e3b>] ? __wait_on_bit_lock+0x3c/0x85
   [103563.166411]  [<ffffffff810aefd2>] ? __lock_page+0x5d/0x63
   [103563.166422]  [<ffffffff8105b9bf>] ? wake_bit_function+0x0/0x2e
   [103563.166435]  [<ffffffff811067e1>] ? __generic_file_splice_read+0x26c/0x420
   [103563.166450]  [<ffffffff8124f695>] ? memcpy_toiovec+0x38/0x67
   [103563.166463]  [<ffffffff81306561>] ? down_read+0x9/0x19
   [103563.166488]  [<ffffffffa058f66a>] ? xfs_ilock+0x5c/0x97 [xfs]
   [103563.166514]  [<ffffffffa058ff1c>] ? xfs_iget+0x51f/0x58b [xfs]
   [103563.166527]  [<ffffffff812491ca>] ? release_sock+0x19/0xf3
   [103563.166539]  [<ffffffff813070ce>] ? common_interrupt+0xe/0x13
   [103563.166552]  [<ffffffff81104eca>] ? spd_release_page+0x0/0x14
   [103563.166563]  [<ffffffff811069d0>] ? generic_file_splice_read+0x3b/0x63
   [103563.166592]  [<ffffffffa05ae4cd>] ? xfs_file_splice_read+0xe4/0x12e [xfs]
   [103563.166606]  [<ffffffff81105019>] ? splice_direct_to_actor+0xba/0x17b
   [103563.166626]  [<ffffffffa061d851>] ? nfsd_direct_splice_actor+0x0/0x13 [nfsd]
   [103563.166644]  [<ffffffffa061d748>] ? nfsd_vfs_read+0x242/0x34b [nfsd]
   [103563.166661]  [<ffffffffa061de4d>] ? nfsd_read+0xa5/0xc4 [nfsd]
   [103563.166679]  [<ffffffffa0624583>] ? nfsd3_proc_read+0xd6/0x114 [nfsd]
   [103563.166695]  [<ffffffffa0619334>] ? nfsd_dispatch+0xdf/0x1b5 [nfsd]
   [103563.166721]  [<ffffffffa02a7596>] ? svc_process+0x40d/0x60b [sunrpc]
   [103563.166737]  [<ffffffffa0619851>] ? nfsd+0xe8/0x131 [nfsd]
   [103563.166751]  [<ffffffffa0619769>] ? nfsd+0x0/0x131 [nfsd]
   [103563.166761]  [<ffffffff8105b541>] ? kthread+0x75/0x7d
   [103563.166772]  [<ffffffff810097e4>] ? kernel_thread_helper+0x4/0x10
   [103563.166784]  [<ffffffff8105b4cc>] ? kthread+0x0/0x7d
   [103563.166794]  [<ffffffff810097e0>] ? kernel_thread_helper+0x0/0x10
   [103563.166807] INFO: task nfsd:3495 blocked for more than 120 seconds.
   [103563.166815] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
   [103563.166824] nfsd          D 0000000101892965     0  3495      2 0x00000000
   [103563.166834]  ffff88042ae173d0 0000000000000046 ffff880420b0578c ffffffff00000000
   [103563.166846]  ffff88042e0d8da0 00000000000154c0 00000000000154c0 00000000000154c0
   [103563.166857]  ffff880420b05fd8 00000000000154c0 ffff88042ae173d0 ffff880420b05fd8
   [103563.166868] Call Trace:
   [103563.166875]  [<ffffffffa026b133>] ? get_active_stripe+0xfe/0x55b [raid456]
   [103563.166889]  [<ffffffff8103f760>] ? default_wake_function+0x0/0xf
   [103563.166902]  [<ffffffffa026eafa>] ? make_request+0x1dd/0x403 [raid456]
   [103563.166915]  [<ffffffff8105b995>] ? autoremove_wake_function+0x0/0x2a
   [103563.166931]  [<ffffffffa02267ca>] ? md_make_request+0xd0/0x1d4 [md_mod]
   [103563.166944]  [<ffffffff8117583c>] ? generic_make_request+0x27a/0x2f0
   [103563.166957]  [<ffffffff813070ce>] ? common_interrupt+0xe/0x13
   [103563.166969]  [<ffffffff81175983>] ? submit_bio+0xd1/0xed
   [103563.166979]  [<ffffffff8118b006>] ? radix_tree_tag_set+0x64/0xc8
   [103563.166991]  [<ffffffff8110b97c>] ? __bio_add_page+0x156/0x1f1
   [103563.167019]  [<ffffffffa05aa640>] ? xfs_submit_ioend_bio+0x53/0x5f [xfs]
   [103563.167048]  [<ffffffffa05aa702>] ? xfs_submit_ioend+0xb6/0xd8 [xfs]
   [103563.167077]  [<ffffffffa05ab62a>] ? xfs_page_state_convert+0x4bd/0x50e [xfs]
   [103563.167105]  [<ffffffffa058ff1c>] ? xfs_iget+0x51f/0x58b [xfs]
   [103563.167133]  [<ffffffffa05ab843>] ? xfs_vm_writepage+0xef/0x12c [xfs]
   [103563.167146]  [<ffffffff810b548a>] ? __writepage+0xa/0x21
   [103563.167157]  [<ffffffff810b6504>] ? write_cache_pages+0x1d8/0x2ec
   [103563.167167]  [<ffffffff810b5480>] ? __writepage+0x0/0x21
   [103563.167183]  [<ffffffffa0621ae5>] ? nfsd_setuser+0x1a2/0x1e5 [nfsd]
   [103563.167199]  [<ffffffffa061bff4>] ? nfsd_setuser_and_check_port+0x76/0x92 [nfsd]
   [103563.167214]  [<ffffffff810af4d2>] ? __filemap_fdatawrite_range+0x48/0x4d
   [103563.167227]  [<ffffffff810af4fe>] ? filemap_write_and_wait_range+0x27/0x50
   [103563.167240]  [<ffffffff81106b66>] ? vfs_fsync_range+0x2f/0x79
   [103563.167256]  [<ffffffffa061dc99>] ? nfsd_commit+0x67/0x9a [nfsd]
   [103563.167269]  [<ffffffff810dfe2f>] ? virt_to_head_page+0x9/0x2a
   [103563.167286]  [<ffffffffa0623871>] ? nfsd3_proc_commit+0x86/0x92 [nfsd]
   [103563.167302]  [<ffffffffa0619334>] ? nfsd_dispatch+0xdf/0x1b5 [nfsd]
   [103563.167322]  [<ffffffffa02a7596>] ? svc_process+0x40d/0x60b [sunrpc]
   [103563.167338]  [<ffffffffa0619851>] ? nfsd+0xe8/0x131 [nfsd]
   [103563.167352]  [<ffffffffa0619769>] ? nfsd+0x0/0x131 [nfsd]
   [103563.167364]  [<ffffffff8105b541>] ? kthread+0x75/0x7d
   [103563.167375]  [<ffffffff810097e4>] ? kernel_thread_helper+0x4/0x10
   [103563.167387]  [<ffffffff8105b4cc>] ? kthread+0x0/0x7d
   [103563.167398]  [<ffffffff810097e0>] ? kernel_thread_helper+0x0/0x10
   [103563.167409] INFO: task nfsd:3496 blocked for more than 120 seconds.
   [103563.167417] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
   [103563.167427] nfsd          D 0000000101892957     0  3496      2 0x00000000
   [103563.167437]  ffff88042ae12fb0 0000000000000046 ffff88042ae12fe8 0000000000000000
   [103563.167449]  ffff88042e06b680 00000000000154c0 00000000000154c0 00000000000154c0
   [103563.167460]  ffff88042041dfd8 00000000000154c0 ffff88042ae12fb0 ffff88042041dfd8
   [103563.167471] Call Trace:
   [103563.167477]  [<ffffffffa026b133>] ? get_active_stripe+0xfe/0x55b [raid456]
   [103563.167491]  [<ffffffff8103f760>] ? default_wake_function+0x0/0xf
   [103563.167505]  [<ffffffffa026eafa>] ? make_request+0x1dd/0x403 [raid456]
   [103563.167518]  [<ffffffff8105b995>] ? autoremove_wake_function+0x0/0x2a
   [103563.167533]  [<ffffffffa02267ca>] ? md_make_request+0xd0/0x1d4 [md_mod]
   [103563.167547]  [<ffffffff8117583c>] ? generic_make_request+0x27a/0x2f0
   [103563.167560]  [<ffffffff810b09dd>] ? mempool_alloc+0x53/0x106
   [103563.167572]  [<ffffffff81175983>] ? submit_bio+0xd1/0xed
   [103563.167582]  [<ffffffff8110b97c>] ? __bio_add_page+0x156/0x1f1
   [103563.167609]  [<ffffffffa05aa640>] ? xfs_submit_ioend_bio+0x53/0x5f [xfs]
   [103563.167638]  [<ffffffffa05aa702>] ? xfs_submit_ioend+0xb6/0xd8 [xfs]
   [103563.167667]  [<ffffffffa05ab62a>] ? xfs_page_state_convert+0x4bd/0x50e [xfs]
   [103563.167692]  [<ffffffffa058ff1c>] ? xfs_iget+0x51f/0x58b [xfs]
   [103563.167720]  [<ffffffffa05ab843>] ? xfs_vm_writepage+0xef/0x12c [xfs]
   [103563.167733]  [<ffffffff810b548a>] ? __writepage+0xa/0x21
   [103563.167744]  [<ffffffff810b6504>] ? write_cache_pages+0x1d8/0x2ec
   [103563.167756]  [<ffffffff810b5480>] ? __writepage+0x0/0x21
   [103563.167770]  [<ffffffffa0621ae5>] ? nfsd_setuser+0x1a2/0x1e5 [nfsd]
   [103563.167786]  [<ffffffffa061bff4>] ? nfsd_setuser_and_check_port+0x76/0x92 [nfsd]
   [103563.167801]  [<ffffffff810af4d2>] ? __filemap_fdatawrite_range+0x48/0x4d
   [103563.167814]  [<ffffffff810af4fe>] ? filemap_write_and_wait_range+0x27/0x50
   [103563.167828]  [<ffffffff81106b66>] ? vfs_fsync_range+0x2f/0x79
   [103563.167843]  [<ffffffffa061dc99>] ? nfsd_commit+0x67/0x9a [nfsd]
   [103563.167856]  [<ffffffff810dfe2f>] ? virt_to_head_page+0x9/0x2a
   [103563.167872]  [<ffffffffa0623871>] ? nfsd3_proc_commit+0x86/0x92 [nfsd]
   [103563.167888]  [<ffffffffa0619334>] ? nfsd_dispatch+0xdf/0x1b5 [nfsd]
   [103563.167914]  [<ffffffffa02a7596>] ? svc_process+0x40d/0x60b [sunrpc]
   [103563.167939]  [<ffffffffa0619851>] ? nfsd+0xe8/0x131 [nfsd]
   [103563.167953]  [<ffffffffa0619769>] ? nfsd+0x0/0x131 [nfsd]
   [103563.167964]  [<ffffffff8105b541>] ? kthread+0x75/0x7d
   [103563.167976]  [<ffffffff810097e4>] ? kernel_thread_helper+0x4/0x10
   [103563.167988]  [<ffffffff8105b4cc>] ? kthread+0x0/0x7d
   [103563.167999]  [<ffffffff810097e0>] ? kernel_thread_helper+0x0/0x10
   [103563.168011] INFO: task nfsd:3497 blocked for more than 120 seconds.
   [103563.168019] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
   [103563.168028] nfsd          D 0000000101891d57     0  3497      2 0x00000000
   [103563.168039]  ffff88042ae14af0 0000000000000046 ffff880177966600 0000000000000000
   [103563.168050]  ffff88042e0da8e0 00000000000154c0 00000000000154c0 00000000000154c0
   [103563.168062]  ffff880420517fd8 00000000000154c0 ffff88042ae14af0 ffff880420517fd8
   [103563.168073] Call Trace:
   [103563.168080]  [<ffffffffa026e8a9>] ? chunk_aligned_read+0x1be/0x232 [raid456]
   [103563.168094]  [<ffffffff8103f760>] ? default_wake_function+0x0/0xf
   [103563.168107]  [<ffffffffa022508c>] ? md_write_start+0x13f/0x144 [md_mod]
   [103563.168120]  [<ffffffffa026e995>] ? make_request+0x78/0x403 [raid456]
   [103563.168136]  [<ffffffffa02267ca>] ? md_make_request+0xd0/0x1d4 [md_mod]
   [103563.168149]  [<ffffffff8117583c>] ? generic_make_request+0x27a/0x2f0
   [103563.168162]  [<ffffffff8110bbca>] ? bvec_alloc_bs+0xa5/0xc0
   [103563.168174]  [<ffffffff81175983>] ? submit_bio+0xd1/0xed
   [103563.168185]  [<ffffffff8110bd13>] ? bio_alloc+0x10/0x1f
   [103563.168196]  [<ffffffff8110f562>] ? mpage_bio_submit+0x22/0x26
   [103563.168208]  [<ffffffff8110f9ff>] ? do_mpage_readpage+0x316/0x42f
   [103563.168236]  [<ffffffffa05aa4f7>] ? xfs_get_blocks+0x0/0x14 [xfs]
   [103563.168264]  [<ffffffffa05aa4f7>] ? xfs_get_blocks+0x0/0x14 [xfs]
   [103563.168277]  [<ffffffff810af286>] ? add_to_page_cache_locked+0x71/0xbb
   [103563.168306]  [<ffffffffa05aa4f7>] ? xfs_get_blocks+0x0/0x14 [xfs]
   [103563.168318]  [<ffffffff8110fc58>] ? mpage_readpages+0xce/0x112
   [103563.168346]  [<ffffffffa05aa4f7>] ? xfs_get_blocks+0x0/0x14 [xfs]
   [103563.168358]  [<ffffffff81305929>] ? schedule+0x4d4/0x530
   [103563.168370]  [<ffffffff810b6876>] ? __do_page_cache_readahead+0x117/0x1b3
   [103563.168382]  [<ffffffff810b692e>] ? ra_submit+0x1c/0x20
   [103563.168393]  [<ffffffff8110668b>] ? __generic_file_splice_read+0x116/0x420
   [103563.168407]  [<ffffffff81306561>] ? down_read+0x9/0x19
   [103563.168432]  [<ffffffffa058f66a>] ? xfs_ilock+0x5c/0x97 [xfs]
   [103563.168458]  [<ffffffffa058ff1c>] ? xfs_iget+0x51f/0x58b [xfs]
   [103563.168470]  [<ffffffff812491ca>] ? release_sock+0x19/0xf3
   [103563.168481]  [<ffffffff810b2dfc>] ? free_pcppages_bulk+0x13d/0x150
   [103563.168494]  [<ffffffff81104eca>] ? spd_release_page+0x0/0x14
   [103563.168506]  [<ffffffff811069d0>] ? generic_file_splice_read+0x3b/0x63
   [103563.168534]  [<ffffffffa05ae4cd>] ? xfs_file_splice_read+0xe4/0x12e [xfs]
   [103563.168549]  [<ffffffff81105019>] ? splice_direct_to_actor+0xba/0x17b
   [103563.168565]  [<ffffffffa061d851>] ? nfsd_direct_splice_actor+0x0/0x13 [nfsd]
   [103563.168582]  [<ffffffffa061d748>] ? nfsd_vfs_read+0x242/0x34b [nfsd]
   [103563.168599]  [<ffffffffa061de4d>] ? nfsd_read+0xa5/0xc4 [nfsd]
   [103563.168616]  [<ffffffffa0624583>] ? nfsd3_proc_read+0xd6/0x114 [nfsd]
   [103563.168631]  [<ffffffffa0619334>] ? nfsd_dispatch+0xdf/0x1b5 [nfsd]
   [103563.168651]  [<ffffffffa02a7596>] ? svc_process+0x40d/0x60b [sunrpc]
   [103563.168667]  [<ffffffffa0619851>] ? nfsd+0xe8/0x131 [nfsd]
   [103563.168681]  [<ffffffffa0619769>] ? nfsd+0x0/0x131 [nfsd]
   [103563.168692]  [<ffffffff8105b541>] ? kthread+0x75/0x7d
   [103563.168703]  [<ffffffff810097e4>] ? kernel_thread_helper+0x4/0x10
   [103563.168716]  [<ffffffff8105b4cc>] ? kthread+0x0/0x7d
   [103563.168726]  [<ffffffff810097e0>] ? kernel_thread_helper+0x0/0x10
   [103563.168738] INFO: task nfsd:3498 blocked for more than 120 seconds.
   [103563.168757] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
   [103563.168767] nfsd          D 0000000101891ce5     0  3498      2 0x00000000
   [103563.168778]  ffff88042ae15f60 0000000000000046 ffff88042023b780 0000000000000000
   [103563.168789]  ffff88042e0d8da0 00000000000154c0 00000000000154c0 00000000000154c0
   [103563.168801]  ffff880420611fd8 00000000000154c0 ffff88042ae15f60 ffff880420611fd8
   [103563.168812] Call Trace:
   [103563.168818]  [<ffffffffa026e8a9>] ? chunk_aligned_read+0x1be/0x232 [raid456]
   [103563.168832]  [<ffffffff8103f760>] ? default_wake_function+0x0/0xf
   [103563.168846]  [<ffffffffa026e995>] ? make_request+0x78/0x403 [raid456]
   [103563.168862]  [<ffffffffa02267ca>] ? md_make_request+0xd0/0x1d4 [md_mod]
   [103563.168875]  [<ffffffff8117583c>] ? generic_make_request+0x27a/0x2f0
   [103563.168888]  [<ffffffff8110bbca>] ? bvec_alloc_bs+0xa5/0xc0
   [103563.168899]  [<ffffffff81175983>] ? submit_bio+0xd1/0xed
   [103563.168909]  [<ffffffff8110bd13>] ? bio_alloc+0x10/0x1f
   [103563.168919]  [<ffffffff8110f562>] ? mpage_bio_submit+0x22/0x26
   [103563.168931]  [<ffffffff8110f9ff>] ? do_mpage_readpage+0x316/0x42f
   [103563.168959]  [<ffffffffa05aa4f7>] ? xfs_get_blocks+0x0/0x14 [xfs]
   [103563.168972]  [<ffffffff810b72dc>] ? ____pagevec_lru_add+0x12d/0x143
   [103563.169000]  [<ffffffffa05aa4f7>] ? xfs_get_blocks+0x0/0x14 [xfs]
   [103563.169028]  [<ffffffffa05aa4f7>] ? xfs_get_blocks+0x0/0x14 [xfs]
   [103563.169040]  [<ffffffff8110fc58>] ? mpage_readpages+0xce/0x112
   [103563.169068]  [<ffffffffa05aa4f7>] ? xfs_get_blocks+0x0/0x14 [xfs]
   [103563.169081]  [<ffffffff81305929>] ? schedule+0x4d4/0x530
   [103563.169092]  [<ffffffff810b6876>] ? __do_page_cache_readahead+0x117/0x1b3
   [103563.169105]  [<ffffffff810b692e>] ? ra_submit+0x1c/0x20
   [103563.169116]  [<ffffffff8110668b>] ? __generic_file_splice_read+0x116/0x420
   [103563.169141]  [<ffffffffa0572f5b>] ? xfs_bmap_search_multi_extents+0x85/0xdb [xfs]
   [103563.169156]  [<ffffffff8124f695>] ? memcpy_toiovec+0x38/0x67
   [103563.169169]  [<ffffffff81306561>] ? down_read+0x9/0x19
   [103563.169194]  [<ffffffffa058f66a>] ? xfs_ilock+0x5c/0x97 [xfs]
   [103563.169220]  [<ffffffffa058ff1c>] ? xfs_iget+0x51f/0x58b [xfs]
   [103563.169232]  [<ffffffff812491ca>] ? release_sock+0x19/0xf3
   [103563.169257]  [<ffffffffa058f4d0>] ? xfs_iunlock+0x5b/0xb7 [xfs]
   [103563.169270]  [<ffffffff81104eca>] ? spd_release_page+0x0/0x14
   [103563.169272]  [<ffffffff811069d0>] ? generic_file_splice_read+0x3b/0x63
   [103563.169298]  [<ffffffffa05ae4cd>] ? xfs_file_splice_read+0xe4/0x12e [xfs]
   [103563.169313]  [<ffffffff81105019>] ? splice_direct_to_actor+0xba/0x17b
   [103563.169329]  [<ffffffffa061d851>] ? nfsd_direct_splice_actor+0x0/0x13 [nfsd]
   [103563.169347]  [<ffffffffa061d748>] ? nfsd_vfs_read+0x242/0x34b [nfsd]
   [103563.169363]  [<ffffffffa061de4d>] ? nfsd_read+0xa5/0xc4 [nfsd]
   [103563.169378]  [<ffffffffa0624583>] ? nfsd3_proc_read+0xd6/0x114 [nfsd]
   [103563.169394]  [<ffffffffa0619334>] ? nfsd_dispatch+0xdf/0x1b5 [nfsd]
   [103563.169414]  [<ffffffffa02a7596>] ? svc_process+0x40d/0x60b [sunrpc]
   [103563.169430]  [<ffffffffa0619851>] ? nfsd+0xe8/0x131 [nfsd]
   [103563.169444]  [<ffffffffa0619769>] ? nfsd+0x0/0x131 [nfsd]
   [103563.169455]  [<ffffffff8105b541>] ? kthread+0x75/0x7d
   [103563.169466]  [<ffffffff810097e4>] ? kernel_thread_helper+0x4/0x10
   [103563.169479]  [<ffffffff8105b4cc>] ? kthread+0x0/0x7d
   [103563.169489]  [<ffffffff810097e0>] ? kernel_thread_helper+0x0/0x10
   [103563.169501] INFO: task nfsd:3499 blocked for more than 120 seconds.
   [103563.169510] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
   [103563.169519] nfsd          D 0000000101892025     0  3499      2 0x00000000
   [103563.169531]  ffff88042ae15890 0000000000000046 ffff8804258dad80 0000000000000000
   [103563.169544]  ffff88042e0dc420 00000000000154c0 00000000000154c0 00000000000154c0
   [103563.169555]  ffff880420713fd8 00000000000154c0 ffff88042ae15890 ffff880420713fd8
   [103563.169567] Call Trace:
   [103563.169574]  [<ffffffffa026e8a9>] ? chunk_aligned_read+0x1be/0x232 [raid456]
   [103563.169588]  [<ffffffff8103f760>] ? default_wake_function+0x0/0xf
   [103563.169602]  [<ffffffffa026e995>] ? make_request+0x78/0x403 [raid456]
   [103563.169615]  [<ffffffff8103a650>] ? find_busiest_group+0x296/0x848
   [103563.169630]  [<ffffffffa02267ca>] ? md_make_request+0xd0/0x1d4 [md_mod]
   [103563.169657]  [<ffffffffa058f4d0>] ? xfs_iunlock+0x5b/0xb7 [xfs]
   [103563.169669]  [<ffffffff8117583c>] ? generic_make_request+0x27a/0x2f0
   [103563.169680]  [<ffffffff81175983>] ? submit_bio+0xd1/0xed
   [103563.169691]  [<ffffffff8110f562>] ? mpage_bio_submit+0x22/0x26
   [103563.169703]  [<ffffffff8110f9ff>] ? do_mpage_readpage+0x316/0x42f
   [103563.169717]  [<ffffffff81036c0d>] ? update_curr+0xb1/0x159
   [103563.169744]  [<ffffffffa05aa4f7>] ? xfs_get_blocks+0x0/0x14 [xfs]
   [103563.169772]  [<ffffffffa05aa4f7>] ? xfs_get_blocks+0x0/0x14 [xfs]
   [103563.169784]  [<ffffffff810af286>] ? add_to_page_cache_locked+0x71/0xbb
   [103563.169813]  [<ffffffffa05aa4f7>] ? xfs_get_blocks+0x0/0x14 [xfs]
   [103563.169825]  [<ffffffff8110fc58>] ? mpage_readpages+0xce/0x112
   [103563.169853]  [<ffffffffa05aa4f7>] ? xfs_get_blocks+0x0/0x14 [xfs]
   [103563.169865]  [<ffffffff81305929>] ? schedule+0x4d4/0x530
   [103563.169877]  [<ffffffff810b6876>] ? __do_page_cache_readahead+0x117/0x1b3
   [103563.169891]  [<ffffffff810b692e>] ? ra_submit+0x1c/0x20
   [103563.169902]  [<ffffffff8110668b>] ? __generic_file_splice_read+0x116/0x420
   [103563.169917]  [<ffffffff81292523>] ? tcp_write_xmit+0x445/0x8fc
   [103563.169929]  [<ffffffff81306561>] ? down_read+0x9/0x19
   [103563.169954]  [<ffffffffa058f66a>] ? xfs_ilock+0x5c/0x97 [xfs]
   [103563.169980]  [<ffffffffa058ff1c>] ? xfs_iget+0x51f/0x58b [xfs]
   [103563.169990]  [<ffffffff812491ca>] ? release_sock+0x19/0xf3
   [103563.170002]  [<ffffffff810b2dfc>] ? free_pcppages_bulk+0x13d/0x150
   [103563.170015]  [<ffffffff81104eca>] ? spd_release_page+0x0/0x14
   [103563.170027]  [<ffffffff811069d0>] ? generic_file_splice_read+0x3b/0x63
   [103563.170056]  [<ffffffffa05ae4cd>] ? xfs_file_splice_read+0xe4/0x12e [xfs]
   [103563.170070]  [<ffffffff81105019>] ? splice_direct_to_actor+0xba/0x17b
   [103563.170086]  [<ffffffffa061d851>] ? nfsd_direct_splice_actor+0x0/0x13 [nfsd]
   [103563.170103]  [<ffffffffa061d748>] ? nfsd_vfs_read+0x242/0x34b [nfsd]
   [103563.170121]  [<ffffffffa061de4d>] ? nfsd_read+0xa5/0xc4 [nfsd]
   [103563.170137]  [<ffffffffa0624583>] ? nfsd3_proc_read+0xd6/0x114 [nfsd]
   [103563.170153]  [<ffffffffa0619334>] ? nfsd_dispatch+0xdf/0x1b5 [nfsd]
   [103563.170172]  [<ffffffffa02a7596>] ? svc_process+0x40d/0x60b [sunrpc]
   [103563.170188]  [<ffffffffa0619851>] ? nfsd+0xe8/0x131 [nfsd]
   [103563.170201]  [<ffffffffa0619769>] ? nfsd+0x0/0x131 [nfsd]
   [103563.170212]  [<ffffffff8105b541>] ? kthread+0x75/0x7d
   [103563.170224]  [<ffffffff810097e4>] ? kernel_thread_helper+0x4/0x10
   [103563.170236]  [<ffffffff8105b4cc>] ? kthread+0x0/0x7d
   [103563.170246]  [<ffffffff810097e0>] ? kernel_thread_helper+0x0/0x10
   [103563.170258] INFO: task nfsd:3500 blocked for more than 120 seconds.
   [103563.170267] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
   [103563.170277] nfsd          D 000000010189190d     0  3500      2 0x00000000
   [103563.170288]  ffff88042aa506d0 0000000000000046 ffff880426984af0 0000000000000000
   [103563.170300]  ffff88042e0da8e0 00000000000154c0 00000000000154c0 00000000000154c0
   [103563.170310]  ffff880420035fd8 00000000000154c0 ffff88042aa506d0 ffff880420035fd8
   [103563.170322] Call Trace:
   [103563.170327]  [<ffffffff8100e806>] ? read_tsc+0x5/0x16
   [103563.170338]  [<ffffffff810aefe5>] ? sync_page+0x0/0x45
   [103563.170349]  [<ffffffff813059f0>] ? io_schedule+0x6b/0xaa
   [103563.170361]  [<ffffffff810af026>] ? sync_page+0x41/0x45
   [103563.170371]  [<ffffffff81305e3b>] ? __wait_on_bit_lock+0x3c/0x85
   [103563.170384]  [<ffffffff810aefd2>] ? __lock_page+0x5d/0x63
   [103563.170395]  [<ffffffff8105b9bf>] ? wake_bit_function+0x0/0x2e
   [103563.170407]  [<ffffffff811067e1>] ? __generic_file_splice_read+0x26c/0x420
   [103563.170433]  [<ffffffffa0572f5b>] ? xfs_bmap_search_multi_extents+0x85/0xdb [xfs]
   [103563.170447]  [<ffffffff8124f695>] ? memcpy_toiovec+0x38/0x67
   [103563.170459]  [<ffffffff81306561>] ? down_read+0x9/0x19
   [103563.170484]  [<ffffffffa058f66a>] ? xfs_ilock+0x5c/0x97 [xfs]
   [103563.170510]  [<ffffffffa058ff1c>] ? xfs_iget+0x51f/0x58b [xfs]
   [103563.170522]  [<ffffffff812491ca>] ? release_sock+0x19/0xf3
   [103563.170548]  [<ffffffffa058f4d0>] ? xfs_iunlock+0x5b/0xb7 [xfs]
   [103563.170560]  [<ffffffff81104eca>] ? spd_release_page+0x0/0x14
   [103563.170572]  [<ffffffff811069d0>] ? generic_file_splice_read+0x3b/0x63
   [103563.170601]  [<ffffffffa05ae4cd>] ? xfs_file_splice_read+0xe4/0x12e [xfs]
   [103563.170615]  [<ffffffff81105019>] ? splice_direct_to_actor+0xba/0x17b
   [103563.170631]  [<ffffffffa061d851>] ? nfsd_direct_splice_actor+0x0/0x13 [nfsd]
   [103563.170649]  [<ffffffffa061d748>] ? nfsd_vfs_read+0x242/0x34b [nfsd]
   [103563.170665]  [<ffffffffa061de4d>] ? nfsd_read+0xa5/0xc4 [nfsd]
   [103563.170682]  [<ffffffffa0624583>] ? nfsd3_proc_read+0xd6/0x114 [nfsd]
   [103563.170698]  [<ffffffffa0619334>] ? nfsd_dispatch+0xdf/0x1b5 [nfsd]
   [103563.170719]  [<ffffffffa02a7596>] ? svc_process+0x40d/0x60b [sunrpc]
   [103563.170734]  [<ffffffffa0619851>] ? nfsd+0xe8/0x131 [nfsd]
   [103563.170748]  [<ffffffffa0619769>] ? nfsd+0x0/0x131 [nfsd]
   [103563.170759]  [<ffffffff8105b541>] ? kthread+0x75/0x7d
   [103563.170770]  [<ffffffff810097e4>] ? kernel_thread_helper+0x4/0x10
   [103563.170782]  [<ffffffff8105b4cc>] ? kthread+0x0/0x7d
   [103563.170793]  [<ffffffff810097e0>] ? kernel_thread_helper+0x0/0x10


== full error from (1) ==
   [103350.849291] ata4.04: exception Emask 0x0 SAct 0x92f SErr 0x0 action 0x6
   [103350.892975] ata4.04: irq_stat 0x00020002, device error via D2H FIS
   [103350.934022] ata4.04: failed command: READ FPDMA QUEUED
   [103350.968878] ata4.04: cmd 60/80:00:3f:97:d3/00:00:0b:00:00/40 tag 0 ncq 65536 in
   [103350.968879]          res 41/40:00:61:95:d3/00:01:0b:00:00/00 Emask 0x9 (media error)
   [103351.067418] ata4.04: status: { DRDY ERR }
   [103351.095674] ata4.04: error: { UNC }
   [103351.120802] ata4.04: failed command: READ FPDMA QUEUED
   [103351.155855] ata4.04: cmd 60/00:08:3f:95:d3/01:00:0b:00:00/40 tag 1 ncq 131072 in
   [103351.155857]          res 41/40:00:61:95:d3/00:01:0b:00:00/00 Emask 0x409 (media error) <F>
   [103351.258408] ata4.04: status: { DRDY ERR }
   [103351.286897] ata4.04: error: { UNC }
   [103351.312300] ata4.04: failed command: READ FPDMA QUEUED
   [103351.347597] ata4.04: cmd 60/80:10:3f:98:d3/00:00:0b:00:00/40 tag 2 ncq 65536 in
   [103351.347598]          res 60/80:10:3f:98:d3/00:00:0b:00:00/40 Emask 0x10 (ATA bus error)
   [103351.448427] ata4.04: status: { DRDY DF }
   [103351.476575] ata4.04: error: { ICRC }
   [103351.502633] ata4.04: failed command: READ FPDMA QUEUED
   [103351.538054] ata4.04: cmd 60/80:18:bf:97:d3/00:00:0b:00:00/40 tag 3 ncq 65536 in
   [103351.538055]          res 60/80:18:bf:97:d3/00:00:0b:00:00/40 Emask 0x10 (ATA bus error)
   [103351.639136] ata4.04: status: { DRDY DF }
   [103351.667451] ata4.04: error: { ICRC }
   [103351.693624] ata4.04: failed command: READ FPDMA QUEUED
   [103351.729201] ata4.04: cmd 60/00:28:3f:96:d3/01:00:0b:00:00/40 tag 5 ncq 131072 in
   [103351.729202]          res 5a/2a:04:04:00:00/00:00:00:50:5a/00 Emask 0x2 (HSM violation)
   [103351.830689] ata4.04: status: { DRDY DRQ }
   [103351.859707] ata4.04: failed command: READ FPDMA QUEUED
   [103351.895529] ata4.04: cmd 60/80:40:bf:98:d3/00:00:0b:00:00/40 tag 8 ncq 65536 in
   [103351.895530]          res 60/80:40:bf:98:d3/00:00:0b:00:00/40 Emask 0x10 (ATA bus error)
   [103351.997385] ata4.04: status: { DRDY DF }
   [103352.026059] ata4.04: error: { ICRC }
   [103352.052553] ata4.04: failed command: READ FPDMA QUEUED
   [103352.088421] ata4.04: cmd 60/00:58:3f:99:d3/01:00:0b:00:00/40 tag 11 ncq 131072 in
   [103352.088422]          res 60/00:58:3f:99:d3/00:00:0b:00:00/40 Emask 0x1 (device error)
   [103352.190450] ata4.04: status: { DRDY DF }
   [103352.219323] ata4.04: hard resetting link
   [103352.584379] ata4.04: SATA link up 3.0 Gbps (SStatus 123 SControl 320)
   [103352.631003] ata4.04: configured for UDMA/100
   [103352.661948] ata4: EH complete
   [103354.630686] ata4.04: exception Emask 0x0 SAct 0x620 SErr 0x0 action 0x6
   [103354.675663] ata4.04: irq_stat 0x00060002, device error via SDB FIS
   [103354.718067] ata4.04: failed command: READ FPDMA QUEUED
   [103354.754258] ata4.04: cmd 60/80:28:bf:98:d3/00:00:0b:00:00/40 tag 5 ncq 65536 in
   [103354.754259]          res 5a/2a:04:04:00:00/00:00:00:50:5a/00 Emask 0x2 (HSM violation)
   [103354.856506] ata4.04: status: { DRDY DRQ }
   [103354.886119] ata4.04: failed command: READ FPDMA QUEUED
   [103354.922522] ata4.04: cmd 60/00:48:3f:95:d3/01:00:0b:00:00/40 tag 9 ncq 131072 in
   [103354.922523]          res 41/40:00:61:95:d3/00:01:0b:00:00/00 Emask 0x409 (media error) <F>
   [103355.027674] ata4.04: status: { DRDY ERR }
   [103355.057331] ata4.04: error: { UNC }
   [103355.083824] ata4.04: failed command: READ FPDMA QUEUED
   [103355.083830] ata4.04: cmd 60/80:50:3f:97:d3/00:00:0b:00:00/40 tag 10 ncq 65536 in
   [103355.083833]          res 5a/2a:04:04:00:00/00:00:00:a0:5a/00 Emask 0x2 (HSM violation)
   [103355.083837] ata4.04: status: { DRDY DRQ }
   [103355.083907] ata4.04: hard resetting link
   [103355.432335] ata4.04: SATA link up 3.0 Gbps (SStatus 123 SControl 320)
   [103355.479370] ata4.04: configured for UDMA/100
   [103355.510657] ata4: EH complete
   [103357.495976] ata4.04: exception Emask 0x0 SAct 0x2 SErr 0x0 action 0x0
   [103357.540217] ata4.04: irq_stat 0x00060002, device error via SDB FIS
   [103357.582910] ata4.04: failed command: READ FPDMA QUEUED
   [103357.619344] ata4.04: cmd 60/00:08:3f:95:d3/01:00:0b:00:00/40 tag 1 ncq 131072 in
   [103357.619345]          res 41/40:00:61:95:d3/00:01:0b:00:00/00 Emask 0x409 (media error) <F>
   [103357.724580] ata4.04: status: { DRDY ERR }
   [103357.754332] ata4.04: error: { UNC }
   [103357.783799] ata4.04: configured for UDMA/100
   [103357.815172] ata4: EH complete
   [103359.786533] ata4.04: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x0
   [103359.830796] ata4.04: irq_stat 0x00060002, device error via SDB FIS
   [103359.873539] ata4.04: failed command: READ FPDMA QUEUED
   [103359.910035] ata4.04: cmd 60/00:00:3f:95:d3/01:00:0b:00:00/40 tag 0 ncq 131072 in
   [103359.910037]          res 41/40:00:61:95:d3/00:01:0b:00:00/00 Emask 0x409 (media error) <F>
   [103359.910040] ata4.04: status: { DRDY ERR }
   [103359.910041] ata4.04: error: { UNC }
   [103360.018086] ata4.04: configured for UDMA/100
   [103360.071645] ata4: EH complete
   [103362.052078] ata4.04: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x0
   [103362.096263] ata4.04: irq_stat 0x00060002, device error via SDB FIS
   [103362.138914] ata4.04: failed command: READ FPDMA QUEUED
   [103362.175334] ata4.04: cmd 60/00:00:3f:95:d3/01:00:0b:00:00/40 tag 0 ncq 131072 in
   [103362.175336]          res 41/40:00:61:95:d3/00:01:0b:00:00/00 Emask 0x409 (media error) <F>
   [103362.280506] ata4.04: status: { DRDY ERR }
   [103362.310179] ata4.04: error: { UNC }
   [103362.339586] ata4.04: configured for UDMA/100
   [103362.370840] ata4: EH complete
   [103364.334349] ata4.04: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x0
   [103364.378582] ata4.04: irq_stat 0x00060002, device error via SDB FIS
   [103364.421199] ata4.04: failed command: READ FPDMA QUEUED
   [103364.457555] ata4.04: cmd 60/00:00:3f:95:d3/01:00:0b:00:00/40 tag 0 ncq 131072 in
   [103364.457556]          res 41/40:00:61:95:d3/00:01:0b:00:00/00 Emask 0x409 (media error) <F>
   [103364.562587] ata4.04: status: { DRDY ERR }
   [103364.592185] ata4.04: error: { UNC }
   [103364.621387] ata4.04: configured for UDMA/100
   [103364.652557] sd 3:4:0:0: [sdt] Unhandled sense code
   [103364.686712] sd 3:4:0:0: [sdt] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
   [103364.734972] sd 3:4:0:0: [sdt] Sense Key : Medium Error [current] [descriptor]
   [103364.783292] Descriptor sense data with sense descriptors (in hex):
   [103364.825802]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00 
   [103364.869717]         0b d3 95 61 
   [103364.894588] sd 3:4:0:0: [sdt] Add. Sense: Unrecovered read error - auto reallocate failed
   [103364.949216] sd 3:4:0:0: [sdt] CDB: Read(10): 28 00 0b d3 95 3f 00 01 00 00
   [103364.969589] end_request: I/O error, dev sdt, sector 198415713
   [103364.969619] ata4: EH complete

