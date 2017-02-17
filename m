From: Les Stroud <les@lesstroud.com>
Subject: Process stuck in md_flush_request (state: D)
Date: Fri, 17 Feb 2017 14:05:49 -0500
Message-ID: <99A92F4D-338D-4486-BB1C-C114A8524403@lesstroud.com>
References: <36A8825E-F387-4ED8-8672-976094B3BEBB@lesstroud.com>
Mime-Version: 1.0 (Mac OS X Mail 10.2 \(3259\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


I have a problem with processes entering an uninterruptible sleep state =
in md_flush_request and never returning. I having trouble identifying =
the underlying issue. I=E2=80=99m hoping someone on here may be able to =
help.

The servers in question are running in aws (xen hvm) with kernel =
3.8.13-118.16.2.el6uek.x86_64.  The server has two mounts.  The first is =
vanilla ext4.  The second is a software RAID0 array, striped with 256k =
chunks, buiIt with md.  It=E2=80=99s file system is ext4.=20

The most immediately and obvious symptom of the issue are kernel errors =
=E2=80=9Ckernel: INFO task [some process]: blocked for more than 120 =
seconds.=E2=80=9D.  Shortly there after, other processes start entering =
the same uninterruptible wait state (D). This almost always impacts ssh =
logins.

The problem does not occur when the system is under load, or was =
recently under load.  It happens when the system is quiet (no cpu, very =
little io).

I=E2=80=99ve been able to gather a little information from the logs and =
process tree (when I could get in). It seems to start with an md process =
(jdb2/md-127-8). Most of the time it=E2=80=99s queuing up kworker =
processes behind it.  However, I=E2=80=99ve seen other processes stuck =
as well.  When I can find a way to execute commands on the box, some of =
them will work, some of them will hand immediately, and others will work =
a few times before hanging themselves. Every time I have been able to =
look, I=E2=80=99ve found these =E2=80=9Chung=E2=80=9D processes sitting =
in one of two methods md_flush_cache and md_flush_request. =20


I would appreciate any help you can provide to diagnose and resolve this =
issue, find an available patch, or report a bug (if necessary).



Here is a piece of one of the call traces:

	Feb  6 15:41:57 server1 kernel: INFO: task jbd2/md127-8:2511 =
blocked for more than 120 seconds.
	Feb  6 15:41:57 server1 kernel: "echo 0 > =
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
	Feb  6 15:41:57 server1 kernel: jbd2/md127-8    D =
ffffffff815c6d00     0  2511      2 0x00000000
	Feb  6 15:41:57 server1 kernel: ffff8803f8a659c8 =
0000000000000046 ffff8803f8a65fd8 0000000000013040
	Feb  6 15:41:57 server1 kernel: ffff8803f8a64010 =
0000000000013040 0000000000013040 0000000000013040
	Feb  6 15:41:57 server1 kernel: ffff8803f8a65fd8 =
0000000000013040 ffff8803f95b8300 ffff8803f5c3e340
	Feb  6 15:41:57 server1 kernel: Call Trace:
	Feb  6 15:41:57 server1 kernel: [<ffffffff815a0ea9>] =
schedule+0x29/0x70
	Feb  6 15:41:57 server1 kernel: [<ffffffff8146b886>] =
md_flush_request+0x86/0x120
	Feb  6 15:41:57 server1 kernel: [<ffffffff81086da0>] ? =
wake_up_bit+0x40/0x40
	Feb  6 15:41:57 server1 kernel: [<ffffffffa00ab6eb>] =
raid0_make_request+0x11b/0x200 [raid0]
	Feb  6 15:41:57 server1 kernel: [<ffffffff8126c83d>] ? =
generic_make_request_checks+0x1ad/0x400
	Feb  6 15:41:57 server1 kernel: [<ffffffff8146b60c>] =
md_make_request+0xdc/0x240
	Feb  6 15:41:57 server1 kernel: [<ffffffff81135365>] ? =
mempool_alloc_slab+0x15/0x20
	Feb  6 15:41:57 server1 kernel: [<ffffffff811354d0>] ? =
mempool_alloc+0x60/0x170
	Feb  6 15:41:57 server1 kernel: [<ffffffff8126cb5a>] =
generic_make_request+0xca/0x100
	Feb  6 15:41:57 server1 kernel: [<ffffffff8126cc09>] =
submit_bio+0x79/0x160
	Feb  6 15:41:57 server1 kernel: [<ffffffff811ce0e5>] ? =
bio_alloc_bioset+0x65/0x120
	Feb  6 15:41:57 server1 kernel: [<ffffffff811c8e50>] =
_submit_bh+0x130/0x200
	Feb  6 15:41:57 server1 kernel: [<ffffffff811c8f30>] =
submit_bh+0x10/0x20
	Feb  6 15:41:57 server1 kernel: [<ffffffffa0167fbd>] =
journal_submit_commit_record+0x14d/0x1d0 [jbd2]
	Feb  6 15:41:57 server1 kernel: [<ffffffffa016e380>] ? =
journal_free_journal_head+0x60/0x70 [jbd2]
	Feb  6 15:41:57 server1 kernel: [<ffffffffa0168eab>] =
jbd2_journal_commit_transaction+0xcfb/0x1950 [jbd2]
	Feb  6 15:41:57 server1 kernel: [<ffffffffa016f213>] =
kjournald2+0xf3/0x3e0 [jbd2]
	Feb  6 15:41:57 server1 kernel: [<ffffffff81086da0>] ? =
wake_up_bit+0x40/0x40
	Feb  6 15:41:57 server1 kernel: [<ffffffffa016f120>] ? =
commit_timeout+0x10/0x10 [jbd2]
	Feb  6 15:41:57 server1 kernel: [<ffffffff810864ee>] =
kthread+0xce/0xe0
	Feb  6 15:41:57 server1 kernel: [<ffffffff81086420>] ? =
kthread_freezable_should_stop+0x70/0x70
	Feb  6 15:41:57 server1 kernel: [<ffffffff815aa9c8>] =
ret_from_fork+0x58/0x90
	Feb  6 15:41:57 server1 kernel: [<ffffffff81086420>] ? =
kthread_freezable_should_stop+0x70/0x70
	Feb  6 15:41:57 server1 kernel: INFO: task ora_ckpt_rdbdev:1200 =
blocked for more than 120 seconds.
	Feb  6 15:41:57 server1 kernel: "echo 0 > =
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
	Feb  6 15:41:57 server1 kernel: ora_ckpt_rdbdev D =
ffffffff815c6d00     0  1200      1 0x00000080
	Feb  6 15:41:57 server1 kernel: ffff8803f5327898 =
0000000000000082 ffff8803f5327fd8 0000000000013040
	Feb  6 15:41:57 server1 kernel: ffff8803f5326010 =
0000000000013040 0000000000013040 0000000000013040
	Feb  6 15:41:57 server1 kernel: ffff8803f5327fd8 =
0000000000013040 ffffffff818c3420 ffff8803f7ad4140
	Feb  6 15:41:57 server1 kernel: Call Trace:
	Feb  6 15:41:57 server1 kernel: [<ffffffff815a0ea9>] =
schedule+0x29/0x70
	Feb  6 15:41:57 server1 kernel: [<ffffffff815a119e>] =
schedule_preempt_disabled+0xe/0x10
	Feb  6 15:41:57 server1 kernel: [<ffffffff8159f767>] =
__mutex_lock_slowpath+0x177/0x220
	Feb  6 15:41:57 server1 kernel: [<ffffffff81138e51>] ? =
prep_new_page+0x111/0x180
	Feb  6 15:41:57 server1 kernel: [<ffffffff8159f5cb>] =
mutex_lock+0x2b/0x50
	Feb  6 15:41:57 server1 kernel: [<ffffffff811d400e>] =
do_blockdev_direct_IO+0x7be/0x860
	Feb  6 15:41:57 server1 kernel: [<ffffffff811d40fc>] =
__blockdev_direct_IO+0x4c/0x50
	Feb  6 15:41:57 server1 kernel: [<ffffffffa0191ab0>] ? =
ext4_get_block_write+0x20/0x20 [ext4]
	Feb  6 15:41:57 server1 kernel: [<ffffffffa01d0c78>] =
ext4_ind_direct_IO+0xf8/0x480 [ext4]
	Feb  6 15:41:57 server1 kernel: [<ffffffffa0191ab0>] ? =
ext4_get_block_write+0x20/0x20 [ext4]
	Feb  6 15:41:57 server1 kernel: [<ffffffffa019331b>] =
ext4_ext_direct_IO+0x16b/0x240 [ext4]
	Feb  6 15:41:57 server1 kernel: [<ffffffffa01934c9>] =
ext4_direct_IO+0xd9/0x180 [ext4]
	Feb  6 15:41:57 server1 kernel: [<ffffffff811349e2>] =
generic_file_read_iter+0x122/0x130
	Feb  6 15:41:57 server1 kernel: [<ffffffff8119615c>] =
do_aio_read+0xbc/0xd0
	Feb  6 15:41:57 server1 kernel: [<ffffffff81196217>] =
do_sync_read+0xa7/0xe0
	Feb  6 15:41:57 server1 kernel: [<ffffffff81196521>] =
vfs_read+0xb1/0x130
	Feb  6 15:41:57 server1 kernel: [<ffffffff81196eaa>] =
sys_pread64+0x9a/0xb0
	Feb  6 15:41:57 server1 kernel: [<ffffffff815aaa79>] =
system_call_fastpath+0x16/0x1b
	Feb  6 15:41:57 server1 kernel: INFO: task kworker/0:5:30438 =
blocked for more than 120 seconds.
	Feb  6 15:41:57 server1 kernel: "echo 0 > =
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
	Feb  6 15:41:57 server1 kernel: kworker/0:5     D =
0000000000000000     0 30438      2 0x00000080
	Feb  6 15:41:57 server1 kernel: ffff8803f7df5ad8 =
0000000000000046 ffff8803f7df5fd8 0000000000013040
	Feb  6 15:41:57 server1 kernel: ffff8803f7df4010 =
0000000000013040 0000000000013040 0000000000013040
	Feb  6 15:41:57 server1 kernel: ffff8803f7df5fd8 =
0000000000013040 ffff8802958be500 ffff8802acd20200
	Feb  6 15:41:57 server1 kernel: Call Trace:
	Feb  6 15:41:57 server1 kernel: [<ffffffff815a0ea9>] =
schedule+0x29/0x70
	Feb  6 15:41:57 server1 kernel: [<ffffffff8146b886>] =
md_flush_request+0x86/0x120
	Feb  6 15:41:57 server1 kernel: [<ffffffff81086da0>] ? =
wake_up_bit+0x40/0x40
	Feb  6 15:41:57 server1 kernel: [<ffffffff8159eed5>] ? =
schedule_timeout+0x195/0x220
	Feb  6 15:41:57 server1 kernel: [<ffffffffa00ab6eb>] =
raid0_make_request+0x11b/0x200 [raid0]
	Feb  6 15:41:57 server1 kernel: [<ffffffff8126c83d>] ? =
generic_make_request_checks+0x1ad/0x400
	Feb  6 15:41:57 server1 kernel: [<ffffffff8146b60c>] =
md_make_request+0xdc/0x240
	Feb  6 15:41:57 server1 kernel: [<ffffffff81135365>] ? =
mempool_alloc_slab+0x15/0x20
	Feb  6 15:41:57 server1 kernel: [<ffffffff811354d0>] ? =
mempool_alloc+0x60/0x170
	Feb  6 15:41:57 server1 kernel: [<ffffffff8126cb5a>] =
generic_make_request+0xca/0x100
	Feb  6 15:41:57 server1 kernel: [<ffffffff8126cc09>] =
submit_bio+0x79/0x160
	Feb  6 15:41:57 server1 kernel: [<ffffffff811ce0e5>] ? =
bio_alloc_bioset+0x65/0x120
	Feb  6 15:41:57 server1 kernel: [<ffffffff8126fe68>] =
blkdev_issue_flush+0xb8/0xf0
	Feb  6 15:41:57 server1 kernel: [<ffffffffa018c807>] =
ext4_sync_file+0x167/0x300 [ext4]
	Feb  6 15:41:57 server1 kernel: [<ffffffff811c642e>] =
vfs_fsync_range+0x2e/0x30
	Feb  6 15:41:57 server1 kernel: [<ffffffff811c6491>] =
generic_write_sync+0x41/0x50
	Feb  6 15:41:57 server1 kernel: [<ffffffff811d1d8b>] =
dio_complete+0x11b/0x140
	Feb  6 15:41:57 server1 kernel: [<ffffffff8107ce0c>] ? =
need_to_create_worker+0x1c/0x40
	Feb  6 15:41:57 server1 kernel: [<ffffffff811d1f04>] =
dio_aio_complete_work+0x24/0x30
	Feb  6 15:41:57 server1 kernel: [<ffffffff8107ea50>] =
process_one_work+0x180/0x420
	Feb  6 15:41:57 server1 kernel: [<ffffffff8108119e>] =
worker_thread+0x12e/0x390
	Feb  6 15:41:57 server1 kernel: [<ffffffff81081070>] ? =
manage_workers+0x180/0x180
	Feb  6 15:41:57 server1 kernel: [<ffffffff810864ee>] =
kthread+0xce/0xe0
	Feb  6 15:41:57 server1 kernel: [<ffffffff81086420>] ? =
kthread_freezable_should_stop+0x70/0x70
	Feb  6 15:41:57 server1 kernel: [<ffffffff815aa9c8>] =
ret_from_fork+0x58/0x90
	Feb  6 15:41:57 server1 kernel: [<ffffffff81086420>] ? =
kthread_freezable_should_stop+0x70/0x70
	Feb  6 15:41:57 server1 kernel: INFO: task kworker/1:2:31430 =
blocked for more than 120 seconds.
	Feb  6 15:41:57 server1 kernel: "echo 0 > =
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
	Feb  6 15:41:57 server1 kernel: kworker/1:2     D =
0000000000000001     0 31430      2 0x00000080
	Feb  6 15:41:57 server1 kernel: ffff8802a7dcfb58 =
0000000000000046 ffff8802a7dcffd8 0000000000013040
	Feb  6 15:41:57 server1 kernel: ffff8802a7dce010 =
0000000000013040 0000000000013040 0000000000013040
	Feb  6 15:41:57 server1 kernel: ffff8802a7dcffd8 =
0000000000013040 ffff8803f6dca3c0 ffff8802a25bc580
	Feb  6 15:41:57 server1 kernel: Call Trace:
	Feb  6 15:41:57 server1 kernel: [<ffffffff815a0ea9>] =
schedule+0x29/0x70
	Feb  6 15:41:57 server1 kernel: [<ffffffff8159eed5>] =
schedule_timeout+0x195/0x220
	Feb  6 15:41:57 server1 kernel: [<ffffffff8126c83d>] ? =
generic_make_request_checks+0x1ad/0x400
	Feb  6 15:41:57 server1 kernel: [<ffffffff8146b60c>] ? =
md_make_request+0xdc/0x240
	Feb  6 15:41:57 server1 kernel: [<ffffffff81135365>] ? =
mempool_alloc_slab+0x15/0x20
	Feb  6 15:41:57 server1 kernel: [<ffffffff811354d0>] ? =
mempool_alloc+0x60/0x170
	Feb  6 15:41:57 server1 kernel: [<ffffffff815a0cda>] =
wait_for_common+0x11a/0x170
	Feb  6 15:41:57 server1 kernel: [<ffffffff8126cb5a>] ? =
generic_make_request+0xca/0x100
	Feb  6 15:41:57 server1 kernel: [<ffffffff8109a3d0>] ? =
try_to_wake_up+0x2e0/0x2e0
	Feb  6 15:41:57 server1 kernel: [<ffffffff815a0e0d>] =
wait_for_completion+0x1d/0x20
	Feb  6 15:41:57 server1 kernel: [<ffffffff8126fe70>] =
blkdev_issue_flush+0xc0/0xf0
	Feb  6 15:41:57 server1 kernel: [<ffffffffa018c8ef>] =
ext4_sync_file+0x24f/0x300 [ext4]
	Feb  6 15:41:57 server1 kernel: [<ffffffff811c642e>] =
vfs_fsync_range+0x2e/0x30
	Feb  6 15:41:57 server1 kernel: [<ffffffff811c6491>] =
generic_write_sync+0x41/0x50
	Feb  6 15:41:57 server1 kernel: [<ffffffff811d1d8b>] =
dio_complete+0x11b/0x140
	Feb  6 15:41:57 server1 kernel: [<ffffffff8107ce0c>] ? =
need_to_create_worker+0x1c/0x40
	Feb  6 15:41:57 server1 kernel: [<ffffffff811d1f04>] =
dio_aio_complete_work+0x24/0x30
	Feb  6 15:41:57 server1 kernel: [<ffffffff8107ea50>] =
process_one_work+0x180/0x420
	Feb  6 15:41:57 server1 kernel: [<ffffffff8108119e>] =
worker_thread+0x12e/0x390
	Feb  6 15:41:57 server1 kernel: [<ffffffff81081070>] ? =
manage_workers+0x180/0x180
	Feb  6 15:41:57 server1 kernel: [<ffffffff810864ee>] =
kthread+0xce/0xe0
	Feb  6 15:41:57 server1 kernel: [<ffffffff81086420>] ? =
kthread_freezable_should_stop+0x70/0x70
	Feb  6 15:41:57 server1 kernel: [<ffffffff815aa9c8>] =
ret_from_fork+0x58/0x90
	Feb  6 15:41:57 server1 kernel: [<ffffffff81086420>] ? =
kthread_freezable_should_stop+0x70/0x70
	Feb  6 15:41:57 server1 kernel: INFO: task kworker/3:0:32582 =
blocked for more than 120 seconds.
	Feb  6 15:41:57 server1 kernel: "echo 0 > =
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
	Feb  6 15:41:57 server1 kernel: kworker/3:0     D =
0000000000000003     0 32582      2 0x00000080
	Feb  6 15:41:57 server1 kernel: ffff8803f6e97ad8 =
0000000000000046 ffff8803f6e97fd8 0000000000013040
	Feb  6 15:41:57 server1 kernel: ffff8803f6e96010 =
0000000000013040 0000000000013040 0000000000013040
	Feb  6 15:41:57 server1 kernel: ffff8803f6e97fd8 =
0000000000013040 ffff8802b7806440 ffff8802a1f92540
	Feb  6 15:41:57 server1 kernel: Call Trace:
	Feb  6 15:41:57 server1 kernel: [<ffffffff815a0ea9>] =
schedule+0x29/0x70
	Feb  6 15:41:57 server1 kernel: [<ffffffff8146b886>] =
md_flush_request+0x86/0x120
	Feb  6 15:41:57 server1 kernel: [<ffffffff81086da0>] ? =
wake_up_bit+0x40/0x40
	Feb  6 15:41:57 server1 kernel: [<ffffffffa00ab6eb>] =
raid0_make_request+0x11b/0x200 [raid0]
	Feb  6 15:41:57 server1 kernel: [<ffffffff8126c83d>] ? =
generic_make_request_checks+0x1ad/0x400
	Feb  6 15:41:57 server1 kernel: [<ffffffff8146b60c>] =
md_make_request+0xdc/0x240
	Feb  6 15:41:57 server1 kernel: [<ffffffff81135365>] ? =
mempool_alloc_slab+0x15/0x20
	Feb  6 15:41:57 server1 kernel: [<ffffffff811354d0>] ? =
mempool_alloc+0x60/0x170
	Feb  6 15:41:57 server1 kernel: [<ffffffff8126cb5a>] =
generic_make_request+0xca/0x100
	Feb  6 15:41:57 server1 kernel: [<ffffffff8126cc09>] =
submit_bio+0x79/0x160
	Feb  6 15:41:57 server1 kernel: [<ffffffff811ce0e5>] ? =
bio_alloc_bioset+0x65/0x120
	Feb  6 15:41:57 server1 kernel: [<ffffffff8126fe68>] =
blkdev_issue_flush+0xb8/0xf0
	Feb  6 15:41:57 server1 kernel: [<ffffffffa018c807>] =
ext4_sync_file+0x167/0x300 [ext4]
	Feb  6 15:41:57 server1 kernel: [<ffffffff811c642e>] =
vfs_fsync_range+0x2e/0x30
	Feb  6 15:41:57 server1 kernel: [<ffffffff811c6491>] =
generic_write_sync+0x41/0x50
	Feb  6 15:41:57 server1 kernel: [<ffffffff811d1d8b>] =
dio_complete+0x11b/0x140
	Feb  6 15:41:57 server1 kernel: [<ffffffff811d1f04>] =
dio_aio_complete_work+0x24/0x30
	Feb  6 15:41:57 server1 kernel: [<ffffffff8107ea50>] =
process_one_work+0x180/0x420
	Feb  6 15:41:57 server1 kernel: [<ffffffff8108119e>] =
worker_thread+0x12e/0x390
	Feb  6 15:41:57 server1 kernel: [<ffffffff81081070>] ? =
manage_workers+0x180/0x180
	Feb  6 15:41:57 server1 kernel: [<ffffffff810864ee>] =
kthread+0xce/0xe0
	Feb  6 15:41:57 server1 kernel: [<ffffffff81086420>] ? =
kthread_freezable_should_stop+0x70/0x70
	Feb  6 15:41:57 server1 kernel: [<ffffffff815aa9c8>] =
ret_from_fork+0x58/0x90
	Feb  6 15:41:57 server1 kernel: [<ffffffff81086420>] ? =
kthread_freezable_should_stop+0x70/0x70
	Feb  6 15:41:57 server1 kernel: INFO: task kworker/1:1:416 =
blocked for more than 120 seconds.
	Feb  6 15:41:57 server1 kernel: "echo 0 > =
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
	Feb  6 15:41:57 server1 kernel: kworker/1:1     D =
ffffffff815c6d00     0   416      2 0x00000080
	Feb  6 15:41:57 server1 kernel: ffff88029ff75ad8 =
0000000000000046 ffff88029ff75fd8 0000000000013040
	Feb  6 15:41:57 server1 kernel: ffff88029ff74010 =
0000000000013040 0000000000013040 0000000000013040
	Feb  6 15:41:57 server1 kernel: ffff88029ff75fd8 =
0000000000013040 ffff8803f95b8300 ffff8802b1d983c0
	Feb  6 15:41:57 server1 kernel: Call Trace:
	Feb  6 15:41:57 server1 kernel: [<ffffffff815a0ea9>] =
schedule+0x29/0x70
	Feb  6 15:41:57 server1 kernel: [<ffffffff8146b886>] =
md_flush_request+0x86/0x120
	Feb  6 15:41:57 server1 kernel: [<ffffffff81086da0>] ? =
wake_up_bit+0x40/0x40
	Feb  6 15:41:57 server1 kernel: [<ffffffffa00ab6eb>] =
raid0_make_request+0x11b/0x200 [raid0]
	Feb  6 15:41:57 server1 kernel: [<ffffffff8126c83d>] ? =
generic_make_request_checks+0x1ad/0x400
	Feb  6 15:41:57 server1 kernel: [<ffffffff8146b60c>] =
md_make_request+0xdc/0x240
	Feb  6 15:41:57 server1 kernel: [<ffffffff81135365>] ? =
mempool_alloc_slab+0x15/0x20
	Feb  6 15:41:57 server1 kernel: [<ffffffff811354d0>] ? =
mempool_alloc+0x60/0x170
	Feb  6 15:41:57 server1 kernel: [<ffffffff8126cb5a>] =
generic_make_request+0xca/0x100
	Feb  6 15:41:57 server1 kernel: [<ffffffff8126cc09>] =
submit_bio+0x79/0x160
	Feb  6 15:41:57 server1 kernel: [<ffffffff811ce0e5>] ? =
bio_alloc_bioset+0x65/0x120
	Feb  6 15:41:57 server1 kernel: [<ffffffff8126fe68>] =
blkdev_issue_flush+0xb8/0xf0
	Feb  6 15:41:57 server1 kernel: [<ffffffffa018c807>] =
ext4_sync_file+0x167/0x300 [ext4]
	Feb  6 15:41:57 server1 kernel: [<ffffffff811c642e>] =
vfs_fsync_range+0x2e/0x30
	Feb  6 15:41:57 server1 kernel: [<ffffffff811c6491>] =
generic_write_sync+0x41/0x50
	Feb  6 15:41:57 server1 kernel: [<ffffffff811d1d8b>] =
dio_complete+0x11b/0x140
	Feb  6 15:41:57 server1 kernel: [<ffffffff811d1f04>] =
dio_aio_complete_work+0x24/0x30
	Feb  6 15:41:57 server1 kernel: [<ffffffff8107ea50>] =
process_one_work+0x180/0x420
	Feb  6 15:41:57 server1 kernel: [<ffffffff8108119e>] =
worker_thread+0x12e/0x390
	Feb  6 15:41:57 server1 kernel: [<ffffffff81081070>] ? =
manage_workers+0x180/0x180
	Feb  6 15:41:57 server1 kernel: [<ffffffff810864ee>] =
kthread+0xce/0xe0
	Feb  6 15:41:57 server1 kernel: [<ffffffff81086420>] ? =
kthread_freezable_should_stop+0x70/0x70
	Feb  6 15:41:57 server1 kernel: [<ffffffff815aa9c8>] =
ret_from_fork+0x58/0x90
	Feb  6 15:41:57 server1 kernel: [<ffffffff81086420>] ? =
kthread_freezable_should_stop+0x70/0x70



Thank you for the time,
LES




