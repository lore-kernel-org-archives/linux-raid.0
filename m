From: BillStuff <billstuff2001@sbcglobal.net>
Subject: Raid5 hang in 3.14.19
Date: Fri, 26 Sep 2014 17:33:58 -0500
Message-ID: <5425E9D6.1050102@sbcglobal.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

Hi Neil,

I found something that looks similar to the problem described in
"Re: seems like a deadlock in workqueue when md do a flush" from Sept 14th.

It's on 3.14.19 with 7 recent patches for fixing raid1 recovery hangs.

on this array:
md3 : active raid5 sdf1[5] sde1[4] sdd1[3] sdc1[2] sdb1[1] sda1[0]
       104171200 blocks level 5, 64k chunk, algorithm 2 [6/6] [UUUUUU]
       bitmap: 1/5 pages [4KB], 2048KB chunk

I was running a test doing parallel kernel builds, read/write loops, and 
disk add / remove / check loops,
on both this array and a raid1 array.

I was trying to stress test your recent raid1 fixes, which went well, 
but then after 5 days,
the raid5 array hung up with this in dmesg:

INFO: task kworker/7:2:15726 blocked for more than 120 seconds.
       Tainted: P        W  O 3.14.19fe-dirty #2
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kworker/7:2     D 00000001     0 15726      2 0x00000000
Workqueue: xfs-log/md3 xfs_log_worker [xfs]
  d1809b1c 00000046 e95e0a80 00000001 c15b56a0 00000008 cf92b77a 0001721a
  c17d6700 c17d6700 d198bcc0 d3b6a880 c236dc00 c8290fb0 c2328468 00000352
  000000e2 c209c000 00000001 e9606000 c209c000 d1809b1c c14b05f4 c12d0c4a
Call Trace:
  [<c14b05f4>] ? sch_direct_xmit+0x54/0x180
  [<c12d0c4a>] ? radix_tree_lookup+0xa/0x10
  [<c10798bb>] ? prepare_to_wait_event+0x6b/0xd0
  [<c153e7f3>] schedule+0x23/0x60
  [<c144fdf1>] md_flush_request+0x51/0xd0
  [<c1079990>] ? __wake_up_sync+0x20/0x20
  [<f3dc0095>] make_request+0xb55/0xc30 [raid456]
  [<c14be153>] ? ip_finish_output+0x1e3/0x440
  [<c14bf5e7>] ? ip_output+0x77/0x80
  [<c14beeb0>] ? ip_local_out+0x20/0x30
  [<c12ae873>] ? generic_make_request_checks+0x343/0x400
  [<c1049903>] ? internal_add_timer+0x13/0x40
  [<c14501d1>] md_make_request+0xb1/0x1d0
  [<c10e6ee3>] ? mempool_alloc_slab+0x13/0x20
  [<c12af629>] generic_make_request+0x89/0xc0
  [<c12af6ba>] submit_bio+0x5a/0x120
  [<c1152cb8>] ? bio_add_page+0x38/0x40
  [<f3c919c0>] _xfs_buf_ioapply+0x250/0x300 [xfs]
  [<f3c91bb4>] xfs_buf_iorequest+0x44/0x80 [xfs]
  [<f3ce7dbe>] ? xlog_bdstrat+0x1e/0x50 [xfs]
  [<f3ce7dbe>] xlog_bdstrat+0x1e/0x50 [xfs]
  [<f3ce9900>] xlog_sync+0x2a0/0x460 [xfs]
  [<f3ce9b34>] xlog_state_release_iclog+0x74/0xa0 [xfs]
  [<f3cea3ef>] xlog_write+0x4af/0x630 [xfs]
  [<f3caa306>] ? kmem_zone_alloc+0x66/0xe0 [xfs]
  [<f3ceb897>] xlog_cil_push+0x1e7/0x3c0 [xfs]
  [<c1054c56>] ? flush_work+0x16/0x100
  [<f3cec059>] xlog_cil_force_lsn+0x79/0x1c0 [xfs]
  [<c106c864>] ? sched_clock_cpu+0x104/0x110
  [<c106d8bc>] ? __dequeue_entity+0x3c/0x40
  [<f3cea670>] _xfs_log_force+0x50/0x230 [xfs]
  [<c153e254>] ? __schedule+0x224/0x7a0
  [<f3cea876>] xfs_log_force+0x26/0x90 [xfs]
  [<f3cebb87>] ? xlog_cil_empty+0x17/0x30 [xfs]
  [<f3cea900>] xfs_log_worker+0x20/0x50 [xfs]
  [<c105521c>] process_one_work+0x10c/0x340
  [<c1055d31>] worker_thread+0x101/0x330
  [<c1055c30>] ? manage_workers.isra.27+0x250/0x250
  [<c105ae21>] kthread+0xa1/0xc0
  [<c1541837>] ret_from_kernel_thread+0x1b/0x28
  [<c105ad80>] ? kthread_create_on_node+0x110/0x110
INFO: task kworker/u16:2:24280 blocked for more than 120 seconds.
       Tainted: P        W  O 3.14.19fe-dirty #2
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kworker/u16:2   D d56879e0     0 24280      2 0x00000000
Workqueue: writeback bdi_writeback_workfn (flush-9:3)
  d5687a3c 00000046 00000000 d56879e0 f2fbd600 f3dbc81b 2e86d607 0001721c
  c17d6700 c17d6700 c49cbcc0 e601c6e0 f3dbc81b 00000002 00000001 e9e0fc00
  c2328468 0000003b d5687a28 d5687d74 00000001 d5687a3c c12b0db6 f3dba382
Call Trace:
  [<f3dbc81b>] ? raid5_unplug+0xbb/0x120 [raid456]
  [<f3dbc81b>] ? raid5_unplug+0xbb/0x120 [raid456]
  [<c12b0db6>] ? blk_flush_plug_list+0x86/0x1b0
  [<f3dba382>] ? stripe_set_idx+0xa2/0xc0 [raid456]
  [<c10798bb>] ? prepare_to_wait_event+0x6b/0xd0
  [<c153e7f3>] schedule+0x23/0x60
  [<f3dbe38b>] get_active_stripe+0x19b/0x5a0 [raid456]
  [<c145f80b>] ? bitmap_startwrite+0x5b/0x170
  [<c1079990>] ? __wake_up_sync+0x20/0x20
  [<f3dbf6b0>] make_request+0x170/0xc30 [raid456]
  [<c10b7193>] ? delayacct_end+0x93/0xa0
  [<c1079990>] ? __wake_up_sync+0x20/0x20
  [<c14501d1>] md_make_request+0xb1/0x1d0
  [<c10e6ee3>] ? mempool_alloc_slab+0x13/0x20
  [<c12af629>] generic_make_request+0x89/0xc0
  [<c12af6ba>] submit_bio+0x5a/0x120
  [<c1152b09>] ? __bio_add_page+0xd9/0x220
  [<c1153248>] ? bvec_alloc+0x78/0xe0
  [<f3c8b612>] xfs_submit_ioend_bio.isra.9+0x32/0x40 [xfs]
  [<f3c8b70c>] xfs_submit_ioend+0xec/0x120 [xfs]
  [<f3c8b981>] xfs_vm_writepage+0x241/0x580 [xfs]
  [<c10ec730>] __writepage+0x10/0x40
  [<c10ec720>] ? mapping_tagged+0x20/0x20
  [<c10ecc30>] write_cache_pages+0x170/0x3d0
  [<f3dbc81b>] ? raid5_unplug+0xbb/0x120 [raid456]
  [<c10ec720>] ? mapping_tagged+0x20/0x20
  [<c10ecec3>] generic_writepages+0x33/0x60
  [<f3c8aa43>] xfs_vm_writepages+0x33/0x40 [xfs]
  [<c10ee38a>] do_writepages+0x1a/0x40
  [<c11486b2>] __writeback_single_inode+0x42/0x1f0
  [<c107965c>] ? wake_up_bit+0x1c/0x20
  [<c1149423>] writeback_sb_inodes+0x193/0x2e0
  [<c11495ec>] __writeback_inodes_wb+0x7c/0xb0
  [<c11497f2>] wb_writeback+0x1d2/0x270
  [<c1149c11>] bdi_writeback_workfn+0x151/0x380
  [<c153e254>] ? __schedule+0x224/0x7a0
  [<c105521c>] process_one_work+0x10c/0x340
  [<c1069cb0>] ? default_wake_function+0x10/0x20
  [<c1055d31>] worker_thread+0x101/0x330
  [<c1055c30>] ? manage_workers.isra.27+0x250/0x250
  [<c105ae21>] kthread+0xa1/0xc0
  [<c1541837>] ret_from_kernel_thread+0x1b/0x28
  [<c105ad80>] ? kthread_create_on_node+0x110/0x110
INFO: task kworker/3:3:26958 blocked for more than 120 seconds.
       Tainted: P        W  O 3.14.19fe-dirty #2
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kworker/3:3     D 00000000     0 26958      2 0x00000000
Workqueue: md md_submit_flush_data
  c6d41dd8 00000046 d128391d 00000000 00000000 00000000 2d875421 0001721c
  c17d6700 c17d6700 e9d3bcc0 d4bf5610 00000000 00000000 00000000 ea469748
  df1132aa 0000c335 d4bf5654 d4bf5654 de5a17aa c6d41dec c106fe31 57d98c16
Call Trace:
  [<c106fe31>] ? update_curr+0xf1/0x1a0
  [<c10798bb>] ? prepare_to_wait_event+0x6b/0xd0
  [<c153e7f3>] schedule+0x23/0x60
  [<f3dbe38b>] get_active_stripe+0x19b/0x5a0 [raid456]
  [<c107030f>] ? dequeue_entity+0x11f/0x510
  [<c1079990>] ? __wake_up_sync+0x20/0x20
  [<f3dbf6b0>] make_request+0x170/0xc30 [raid456]
  [<c153e254>] ? __schedule+0x224/0x7a0
  [<c111bf45>] ? kmem_cache_free+0xe5/0x110
  [<c1079990>] ? __wake_up_sync+0x20/0x20
  [<c144fd60>] md_submit_flush_data+0x30/0x70
  [<c105521c>] process_one_work+0x10c/0x340
  [<c104a30f>] ? mod_timer+0xef/0x1d0
  [<c1055d31>] worker_thread+0x101/0x330
  [<c1055c30>] ? manage_workers.isra.27+0x250/0x250
  [<c105ae21>] kthread+0xa1/0xc0
  [<c1541837>] ret_from_kernel_thread+0x1b/0x28
  [<c105ad80>] ? kthread_create_on_node+0x110/0x110

There's more, mostly xfs threads complaining about being blocked and 
some user processes.
Thinking it was an xfs problem, I did "echo w > /proc/sysrq-trigger" and 
got this in syslog:

Sep 26 12:33:06 xplane kernel: SysRq : Show Blocked State
Sep 26 12:33:06 xplane kernel:   task                PC stack   pid father
Sep 26 12:33:06 xplane kernel: kthreadd        D c106ea4c     0 2      0 
0x00000000
Sep 26 12:33:06 xplane kernel: kswapd0         D 00017219     0 711      
2 0x00000000
Sep 26 12:33:06 xplane kernel: md3_raid5       D ea49d770     0 
1698      2 0x00000000
Sep 26 12:33:06 xplane kernel: xfsaild/md3     D e7d72700     0 
2234      2 0x00000000
Sep 26 12:33:06 xplane kernel: kworker/7:2     D 00000001     0 
15726      2 0x00000000
Sep 26 12:33:06 xplane kernel: Workqueue: xfs-log/md3 xfs_log_worker [xfs]
Sep 26 12:33:06 xplane kernel: kworker/u16:2   D d56879e0     0 
24280      2 0x00000000
Sep 26 12:33:06 xplane kernel: Workqueue: writeback bdi_writeback_workfn 
(flush-9:3)
Sep 26 12:33:06 xplane kernel: kworker/3:3     D 00000000     0 
26958      2 0x00000000
Sep 26 12:33:06 xplane kernel: Workqueue: md md_submit_flush_data
Sep 26 12:33:06 xplane kernel: cat             D 00000000     0 11412  
11410 0x00000000
Sep 26 12:33:06 xplane kernel: cc1             D d00c3bac     0 12102  
12101 0x00000000
Sep 26 12:33:06 xplane kernel: ld              D c16ef900     0 12132  
12130 0x00000000
Sep 26 12:33:06 xplane kernel: make            D 00000000     0 12147  
12047 0x00000000
Sep 26 12:33:06 xplane kernel: make            D d896ea80     0 12374  
11263 0x00000000
Sep 26 12:33:06 xplane kernel: cat             D f2e51d0c     0 23219  
23217 0x00000000
Sep 26 12:33:06 xplane kernel: gcc             D f2e51d0c     0 23564  
23563 0x00000000
Sep 26 12:33:06 xplane kernel: sh              D f2e51d0c     0 25753  
23615 0x00000000

which looks similar to the problem from the above mentioned list-post.

I did a few test writes to the filesystem, and it looked like xfs 
created the files, and could read them
and delete them, but there was never any disk activity and access to 
/sys/block/md3/md/{anything} was hung up

"top" showed consistent I/O wait time, first 25%, then 50%, with no disc 
activity

In the end I had to reboot, and I'm running the test again.

Any thoughts on what's happening here or ideas to help debug it?

Thanks,
Bill

