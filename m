From: David Flynn <davidf@rd.bbc.co.uk>
Subject: Re: md raid5 blocked in get_active_stripe after disk failure
Date: Sat, 12 Feb 2011 00:41:17 +0000
Message-ID: <20110212004117.GA7946@rd.bbc.co.uk>
References: <20110112130420.GA6275@rd.bbc.co.uk> <20110112140632.GB6275@rd.bbc.co.uk> <20110113073331.687bc941@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110113073331.687bc941@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Jan 13, 2011 at 07:33:31AM +1100, NeilBrown wrote:
> If this is easily reproducible (which I think you suggested it is), I would
> put a printk in raid5_end_read_request where it sets "retry = 1" to report
> "trying to fix a failed read".
> 
> If you then get a hang but don't get that message, it is a device driver
> problem.  If you do get that message it is probably an md/raid6 problem.

I was able to reproduce again (without specific interaction from me), and
with the following patch applied:

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 96c6902..eff0a0a 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1618,8 +1618,12 @@ static void raid5_end_read_request(struct bio * bi, int error)
 			printk(KERN_WARNING
 			       "md/raid:%s: Too many read errors, failing device %s.\n",
 			       mdname(conf->mddev), bdn);
-		else
+		else {
+			printk(KERN_WARNING
+			       "md/raid:%s: trying to fix a failed read (%s)\n",
+			       mdname(conf->mddev), bdn);
 			retry = 1;
+		}
 		if (retry)
 			set_bit(R5_ReadError, &sh->dev[i].flags);
 		else {

the added printk wasn't hit (see below).  access to the underlying
block device [sdj] was possible, although anything that touches the
xfs filesystem on md0 blocks.  i didn't try poking md0 directly this
time.  subsequent dd'ing from the faulty sector on sdj eventually
caused the disk to succeed in reading, although this didn't help
anything else.

this was repeated twice:
 - the first time didn't have the prink mod.  pulling the disk
   physically, ata spots it, but md doesn't.  re-inserting
   doesn't help.
 - the second did have the printk mod (and also started on resync)
   the failure is logged below:

kind regards,

..david

[23184.612855] end_request: I/O error, dev sdj, sector 1463405046
[23184.652751] ata2: EH complete
[23404.788116] INFO: task md1_raid5:2312 blocked for more than 120 seconds.
[23404.833357] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[23404.885415] md1_raid5     D 0000000100574c4b     0  2312      2 0x00000000
[23404.901082]  ffff880426600da0 0000000000000046 0000000000000007 ffffffff00000000
[23404.901085]  ffff88042e0ddf60 00000000000154c0 00000000000154c0 00000000000154c0
[23404.901087]  ffff880426651fd8 00000000000154c0 ffff880426600da0 ffff880426651fd8
[23404.901089] Call Trace:
[23404.901099]  [<ffffffffa01de156>] ? get_active_stripe+0xfe/0x55b [raid456]
[23404.901105]  [<ffffffff8103f760>] ? default_wake_function+0x0/0xf
[23404.901108]  [<ffffffffa01dffb5>] ? raid5d+0x149/0x3f2 [raid456]
[23404.901118]  [<ffffffffa0278010>] ? md_thread+0xf2/0x110 [md_mod]
[23404.901122]  [<ffffffff8105b995>] ? autoremove_wake_function+0x0/0x2a
[23404.901126]  [<ffffffffa0277f1e>] ? md_thread+0x0/0x110 [md_mod]
[23404.901129]  [<ffffffff8105b541>] ? kthread+0x75/0x7d
[23404.901133]  [<ffffffff810097e4>] ? kernel_thread_helper+0x4/0x10
[23404.901135]  [<ffffffff8105b4cc>] ? kthread+0x0/0x7d
[23404.901137]  [<ffffffff810097e0>] ? kernel_thread_helper+0x0/0x10
[23404.901140] INFO: task md1_resync:2313 blocked for more than 120 seconds.
[23404.901141] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[23404.901142] md1_resync    D 0000000100573f32     0  2313      2 0x00000000
[23404.901145]  ffff88042783a210 0000000000000046 0000000000000286 ffff880400000000
[23404.901147]  ffff88042e0ddf60 00000000000154c0 00000000000154c0 00000000000154c0
[23404.901149]  ffff880426653fd8 00000000000154c0 ffff88042783a210 ffff880426653fd8
[23404.901151] Call Trace:
[23404.901154]  [<ffffffffa01e103f>] ? sync_request+0x16a/0x2d1 [raid456]
[23404.901157]  [<ffffffff8105b995>] ? autoremove_wake_function+0x0/0x2a
[23404.901162]  [<ffffffffa02778f0>] ? md_do_sync+0x712/0xb0d [md_mod]
[23404.901167]  [<ffffffffa0278010>] ? md_thread+0xf2/0x110 [md_mod]
[23404.901171]  [<ffffffffa0277f1e>] ? md_thread+0x0/0x110 [md_mod]
[23404.901174]  [<ffffffff8105b541>] ? kthread+0x75/0x7d
[23404.901176]  [<ffffffff810097e4>] ? kernel_thread_helper+0x4/0x10
[23404.901178]  [<ffffffff8105b4cc>] ? kthread+0x0/0x7d
[23404.901181]  [<ffffffff810097e0>] ? kernel_thread_helper+0x0/0x10
[23404.901183] INFO: task flush-9:1:2341 blocked for more than 120 seconds.
[23404.901184] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[23404.901185] flush-9:1     D 0000000100573f32     0  2341      2 0x00000000
[23404.901188]  ffff880427839470 0000000000000046 ffff8804252c5998 ffff880400000000
[23404.901190]  ffff88042e0da8e0 00000000000154c0 00000000000154c0 00000000000154c0
[23404.901192]  ffff8804252c5fd8 00000000000154c0 ffff880427839470 ffff8804252c5fd8
[23404.901194] Call Trace:
[23404.901199]  [<ffffffff81305d07>] ? schedule_timeout+0x2d/0xd7
[23404.901202]  [<ffffffff81306645>] ? __down_common+0x92/0xe3
[23404.901233]  [<ffffffffa057a3bd>] ? xfs_getsb+0x25/0x32 [xfs]
[23404.901236]  [<ffffffff8105f54c>] ? down+0x27/0x37
[23404.901255]  [<ffffffffa05877ab>] ? xfs_buf_lock+0x73/0xaa [xfs]
[23404.901272]  [<ffffffffa057a3bd>] ? xfs_getsb+0x25/0x32 [xfs]
[23404.901291]  [<ffffffffa057feda>] ? xfs_trans_getsb+0x63/0xb2 [xfs]
[23404.901309]  [<ffffffffa057dfcd>] ? xfs_trans_apply_sb_deltas+0x12/0x1da [xfs]
[23404.901328]  [<ffffffffa057e9a8>] ? _xfs_trans_commit+0x50/0x221 [xfs]
[23404.901345]  [<ffffffffa0570794>] ? xfs_iomap_write_allocate+0x270/0x36c [xfs]
[23404.901362]  [<ffffffffa056a4f0>] ? xfs_iunlock+0x7b/0xb7 [xfs]
[23404.901380]  [<ffffffffa0585356>] ? xfs_map_blocks+0x37/0x3e [xfs]
[23404.901398]  [<ffffffffa05863d5>] ? xfs_page_state_convert+0x268/0x50e [xfs]
[23404.901417]  [<ffffffffa0586843>] ? xfs_vm_writepage+0xef/0x12c [xfs]
[23404.901420]  [<ffffffff810b548a>] ? __writepage+0xa/0x21
[23404.901422]  [<ffffffff810b6504>] ? write_cache_pages+0x1d8/0x2ec
[23404.901425]  [<ffffffff810b5480>] ? __writepage+0x0/0x21
[23404.901429]  [<ffffffff81102cd4>] ? writeback_single_inode+0xd1/0x2e5
[23404.901432]  [<ffffffff8110323e>] ? writeback_sb_inodes+0x136/0x204
[23404.901434]  [<ffffffff811038e3>] ? writeback_inodes_wb+0x127/0x139
[23404.901437]  [<ffffffff81103a83>] ? wb_writeback+0x18e/0x208
[23404.901439]  [<ffffffff81103c30>] ? wb_do_writeback+0x133/0x149
[23404.901442]  [<ffffffff81103c80>] ? bdi_writeback_task+0x3a/0x112
[23404.901444]  [<ffffffff8105b8bb>] ? bit_waitqueue+0x14/0xa1
[23404.901447]  [<ffffffff810c1f4f>] ? bdi_start_fn+0x0/0xc3
[23404.901449]  [<ffffffff810c1fb2>] ? bdi_start_fn+0x63/0xc3
[23404.901451]  [<ffffffff810c1f4f>] ? bdi_start_fn+0x0/0xc3
[23404.901453]  [<ffffffff8105b541>] ? kthread+0x75/0x7d
[23404.901456]  [<ffffffff810097e4>] ? kernel_thread_helper+0x4/0x10
[23404.901458]  [<ffffffff8105b4cc>] ? kthread+0x0/0x7d
[23404.901460]  [<ffffffff810097e0>] ? kernel_thread_helper+0x0/0x10
[23404.901468] INFO: task xfssyncd/md1:2676 blocked for more than 120 seconds.
[23404.901469] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[23404.901470] xfssyncd/md1  D 0000000100573f32     0  2676      2 0x00000000
[23404.901473]  ffff88042a71afb0 0000000000000046 0000000000000086 ffffffff00000000
[23404.901475]  ffff88042e06ed00 00000000000154c0 00000000000154c0 00000000000154c0
[23404.901477]  ffff88042b57ffd8 00000000000154c0 ffff88042a71afb0 ffff88042b57ffd8
[23404.901479] Call Trace:
[23404.901482]  [<ffffffffa01dc520>] ? raid5_quiesce+0xe3/0x19b [raid456]
[23404.901485]  [<ffffffff8100e7d9>] ? sched_clock+0x5/0x8
[23404.901487]  [<ffffffff8103f760>] ? default_wake_function+0x0/0xf
[23404.901491]  [<ffffffffa01e1971>] ? make_request+0x31/0x403 [raid456]
[23404.901508]  [<ffffffffa0573f35>] ? xlog_write+0x430/0x46e [xfs]
[23404.901513]  [<ffffffffa02767ca>] ? md_make_request+0xd0/0x1d4 [md_mod]
[23404.901530]  [<ffffffffa057542f>] ? xlog_commit_record+0x92/0xc2 [xfs]
[23404.901548]  [<ffffffffa0580333>] ? xfs_trans_unlock_chunk+0x7d/0xc1 [xfs]
[23404.901552]  [<ffffffff8117583c>] ? generic_make_request+0x27a/0x2f0
[23404.901556]  [<ffffffff810b09dd>] ? mempool_alloc+0x53/0x106
[23404.901558]  [<ffffffff81175983>] ? submit_bio+0xd1/0xed
[23404.901576]  [<ffffffffa05874d2>] ? _xfs_buf_ioapply+0x212/0x24f [xfs]
[23404.901593]  [<ffffffffa0572ace>] ? xlog_bdstrat+0x3a/0x3e [xfs]
[23404.901611]  [<ffffffffa0588430>] ? xfs_buf_iorequest+0x75/0x8e [xfs]
[23404.901628]  [<ffffffffa0572ace>] ? xlog_bdstrat+0x3a/0x3e [xfs]
[23404.901645]  [<ffffffffa0572ce1>] ? xlog_sync+0x20f/0x326 [xfs]
[23404.901663]  [<ffffffffa05736d4>] ? _xfs_log_force+0xd9/0x196 [xfs]
[23404.901680]  [<ffffffffa0573915>] ? xfs_log_force+0xb/0x2a [xfs]
[23404.901698]  [<ffffffffa058fd5d>] ? xfs_commit_dummy_trans+0xb3/0xc2 [xfs]
[23404.901717]  [<ffffffffa05903ac>] ? xfs_sync_worker+0x41/0x60 [xfs]
[23404.901735]  [<ffffffffa058fc2e>] ? xfssyncd+0x155/0x1d1 [xfs]
[23404.901753]  [<ffffffffa058fad9>] ? xfssyncd+0x0/0x1d1 [xfs]
[23404.901755]  [<ffffffff8105b541>] ? kthread+0x75/0x7d
[23404.901757]  [<ffffffff810097e4>] ? kernel_thread_helper+0x4/0x10
[23404.901760]  [<ffffffff8105b4cc>] ? kthread+0x0/0x7d
[23404.901762]  [<ffffffff810097e0>] ? kernel_thread_helper+0x0/0x10
[23404.901767] INFO: task nfsd:3388 blocked for more than 120 seconds.
[23404.901768] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[23404.901770] nfsd          D 00000001005740cc     0  3388      2 0x00000000
[23404.901772]  ffff88042a71a210 0000000000000046 ffff880100001000 0000000000000000
[23404.901775]  ffff88042e0da8e0 00000000000154c0 00000000000154c0 00000000000154c0
[23404.901777]  ffff88042128dfd8 00000000000154c0 ffff88042a71a210 ffff88042128dfd8
[23404.901779] Call Trace:
[23404.901781]  [<ffffffff8100e806>] ? read_tsc+0x5/0x16
[23404.901784]  [<ffffffff810aefe5>] ? sync_page+0x0/0x45
[23404.901786]  [<ffffffff813059f0>] ? io_schedule+0x6b/0xaa
[23404.901788]  [<ffffffff810af026>] ? sync_page+0x41/0x45
[23404.901791]  [<ffffffff81305e3b>] ? __wait_on_bit_lock+0x3c/0x85
[23404.901793]  [<ffffffff810aefd2>] ? __lock_page+0x5d/0x63
[23404.901795]  [<ffffffff8105b9bf>] ? wake_bit_function+0x0/0x2e
[23404.901798]  [<ffffffff811067e1>] ? __generic_file_splice_read+0x26c/0x420
[23404.901802]  [<ffffffff81255ec9>] ? dev_queue_xmit+0x42d/0x45b
[23404.901805]  [<ffffffff8127e914>] ? ip_queue_xmit+0x2dc/0x33c
[23404.901807]  [<ffffffff81306561>] ? down_read+0x9/0x19
[23404.901824]  [<ffffffffa056a66a>] ? xfs_ilock+0x5c/0x97 [xfs]
[23404.901840]  [<ffffffffa056af1c>] ? xfs_iget+0x51f/0x58b [xfs]
[23404.901843]  [<ffffffff812491ca>] ? release_sock+0x19/0xf3
[23404.901846]  [<ffffffff810b2dfc>] ? free_pcppages_bulk+0x13d/0x150
[23404.901849]  [<ffffffff81104eca>] ? spd_release_page+0x0/0x14
[23404.901851]  [<ffffffff811069d0>] ? generic_file_splice_read+0x3b/0x63
[23404.901869]  [<ffffffffa05894cd>] ? xfs_file_splice_read+0xe4/0x12e [xfs]
[23404.901872]  [<ffffffff81105019>] ? splice_direct_to_actor+0xba/0x17b
[23404.901881]  [<ffffffffa05d4851>] ? nfsd_direct_splice_actor+0x0/0x13 [nfsd]
[23404.901887]  [<ffffffffa05d4748>] ? nfsd_vfs_read+0x242/0x34b [nfsd]
[23404.901894]  [<ffffffffa05d4e4d>] ? nfsd_read+0xa5/0xc4 [nfsd]
[23404.901901]  [<ffffffffa05db583>] ? nfsd3_proc_read+0xd6/0x114 [nfsd]
[23404.901907]  [<ffffffffa05d0334>] ? nfsd_dispatch+0xdf/0x1b5 [nfsd]
[23404.901929]  [<ffffffffa02e0596>] ? svc_process+0x40d/0x60b [sunrpc]
[23404.901934]  [<ffffffffa05d0851>] ? nfsd+0xe8/0x131 [nfsd]
[23404.901939]  [<ffffffffa05d0769>] ? nfsd+0x0/0x131 [nfsd]
[23404.901941]  [<ffffffff8105b541>] ? kthread+0x75/0x7d
[23404.901943]  [<ffffffff810097e4>] ? kernel_thread_helper+0x4/0x10
[23404.901946]  [<ffffffff8105b4cc>] ? kthread+0x0/0x7d
[23404.901948]  [<ffffffff810097e0>] ? kernel_thread_helper+0x0/0x10
[23404.901950] INFO: task nfsd:3389 blocked for more than 120 seconds.
[23404.901951] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[23404.901953] nfsd          D 0000000100573eb1     0  3389      2 0x00000000
[23404.901955]  ffff88042a71e630 0000000000000046 0000000100000000 ffff880400000000
[23404.901958]  ffff88042e06b680 00000000000154c0 00000000000154c0 00000000000154c0
[23404.901960]  ffff880421387fd8 00000000000154c0 ffff88042a71e630 ffff880421387fd8
[23404.901962] Call Trace:
[23404.901964]  [<ffffffff8100e806>] ? read_tsc+0x5/0x16
[23404.901966]  [<ffffffff810aefe5>] ? sync_page+0x0/0x45
[23404.901969]  [<ffffffff813059f0>] ? io_schedule+0x6b/0xaa
[23404.901971]  [<ffffffff810af026>] ? sync_page+0x41/0x45
[23404.901973]  [<ffffffff81305f39>] ? __wait_on_bit+0x3e/0x6f
[23404.901975]  [<ffffffff810af161>] ? wait_on_page_bit+0x6a/0x70
[23404.901978]  [<ffffffff8105b9bf>] ? wake_bit_function+0x0/0x2e
[23404.901980]  [<ffffffff810b6de4>] ? pagevec_lookup_tag+0x18/0x1f
[23404.901982]  [<ffffffff810af3b5>] ? filemap_fdatawait_range+0x96/0x14a
[23404.901985]  [<ffffffff810af4d2>] ? __filemap_fdatawrite_range+0x48/0x4d
[23404.901988]  [<ffffffff810af514>] ? filemap_write_and_wait_range+0x3d/0x50
[23404.902006]  [<ffffffffa058a5d1>] ? xfs_file_aio_write+0x6ab/0x762 [xfs]
[23404.902023]  [<ffffffffa056af1c>] ? xfs_iget+0x51f/0x58b [xfs]
[23404.902026]  [<ffffffff810e0afe>] ? __slab_free+0x1c/0x250
[23404.902044]  [<ffffffffa0589f26>] ? xfs_file_aio_write+0x0/0x762 [xfs]
[23404.902047]  [<ffffffff810e9324>] ? do_sync_readv_writev+0x9a/0xd5
[23404.902063]  [<ffffffffa056a4f0>] ? xfs_iunlock+0x7b/0xb7 [xfs]
[23404.902066]  [<ffffffff810e0f8b>] ? __slab_alloc+0xf9/0x3eb
[23404.902068]  [<ffffffff810e90d5>] ? copy_from_user+0x18/0x30
[23404.902071]  [<ffffffff810e9e43>] ? rw_copy_check_uvector+0x6a/0xe1
[23404.902073]  [<ffffffff810e9f5e>] ? do_readv_writev+0xa4/0x118
[23404.902080]  [<ffffffffa05d8ae5>] ? nfsd_setuser+0x1a2/0x1e5 [nfsd]
[23404.902085]  [<ffffffffa05d2ff4>] ? nfsd_setuser_and_check_port+0x76/0x92 [nfsd]
[23404.902091]  [<ffffffffa05d4300>] ? nfsd_vfs_write+0x11b/0x321 [nfsd]
[23404.902093]  [<ffffffff810e81f8>] ? __dentry_open+0x184/0x28f
[23404.902099]  [<ffffffffa05d4d87>] ? nfsd_write+0xbb/0xdc [nfsd]
[23404.902106]  [<ffffffffa05d8e8a>] ? nfsd_cache_lookup+0x26e/0x37d [nfsd]
[23404.902113]  [<ffffffffa05db492>] ? nfsd3_proc_write+0xcf/0xea [nfsd]
[23404.902118]  [<ffffffffa05d0334>] ? nfsd_dispatch+0xdf/0x1b5 [nfsd]
[23404.902128]  [<ffffffffa02e0596>] ? svc_process+0x40d/0x60b [sunrpc]
[23404.902133]  [<ffffffffa05d0851>] ? nfsd+0xe8/0x131 [nfsd]
[23404.902138]  [<ffffffffa05d0769>] ? nfsd+0x0/0x131 [nfsd]
[23404.902140]  [<ffffffff8105b541>] ? kthread+0x75/0x7d
[23404.902143]  [<ffffffff810097e4>] ? kernel_thread_helper+0x4/0x10
[23404.902145]  [<ffffffff8105b4cc>] ? kthread+0x0/0x7d
[23404.902147]  [<ffffffff810097e0>] ? kernel_thread_helper+0x0/0x10


[25525.716038] SysRq : Show Blocked State
[25525.719829]   task                        PC stack   pid father
[25525.719829] md1_raid5     D 0000000100574c4b     0  2312      2 0x00000000
[25525.719829]  ffff880426600da0 0000000000000046 0000000000000007 ffffffff00000000
[25525.719829]  ffff88042e0ddf60 00000000000154c0 00000000000154c0 00000000000154c0
[25525.916295]  ffff880426651fd8 00000000000154c0 ffff880426600da0 ffff880426651fd8
[25525.916295] Call Trace:
[25525.916295]  [<ffffffffa01de156>] ? get_active_stripe+0xfe/0x55b [raid456]
[25525.916295]  [<ffffffff8103f760>] ? default_wake_function+0x0/0xf
[25525.916295]  [<ffffffffa01dffb5>] ? raid5d+0x149/0x3f2 [raid456]
[25525.916295]  [<ffffffffa0278010>] ? md_thread+0xf2/0x110 [md_mod]
[25525.916295]  [<ffffffff8105b995>] ? autoremove_wake_function+0x0/0x2a
[25525.916295]  [<ffffffffa0277f1e>] ? md_thread+0x0/0x110 [md_mod]
[25525.916295]  [<ffffffff8105b541>] ? kthread+0x75/0x7d
[25525.916295]  [<ffffffff810097e4>] ? kernel_thread_helper+0x4/0x10
[25525.916295]  [<ffffffff8105b4cc>] ? kthread+0x0/0x7d
[25525.916295]  [<ffffffff810097e0>] ? kernel_thread_helper+0x0/0x10
[25525.916295] md1_resync    D 0000000100573f32     0  2313      2 0x00000000
[25525.916295]  ffff88042783a210 0000000000000046 0000000000000286 ffff880400000000
[25525.916295]  ffff88042e0ddf60 00000000000154c0 00000000000154c0 00000000000154c0
[25525.916295]  ffff880426653fd8 00000000000154c0 ffff88042783a210 ffff880426653fd8
[25525.916295] Call Trace:
[25525.916295]  [<ffffffffa01e103f>] ? sync_request+0x16a/0x2d1 [raid456]
[25525.916295]  [<ffffffff8105b995>] ? autoremove_wake_function+0x0/0x2a
[25525.916295]  [<ffffffffa02778f0>] ? md_do_sync+0x712/0xb0d [md_mod]
[25525.916295]  [<ffffffffa0278010>] ? md_thread+0xf2/0x110 [md_mod]
[25525.916295]  [<ffffffffa0277f1e>] ? md_thread+0x0/0x110 [md_mod]
[25525.916295]  [<ffffffff8105b541>] ? kthread+0x75/0x7d
[25525.916295]  [<ffffffff810097e4>] ? kernel_thread_helper+0x4/0x10
[25525.916295]  [<ffffffff8105b4cc>] ? kthread+0x0/0x7d
[25525.916295]  [<ffffffff810097e0>] ? kernel_thread_helper+0x0/0x10
[25525.916295] flush-9:1     D 0000000100573f32     0  2341      2 0x00000000
[25525.916295]  ffff880427839470 0000000000000046 ffff8804252c5998 ffff880400000000
[25525.916295]  ffff88042e0da8e0 00000000000154c0 00000000000154c0 00000000000154c0
[25525.916295]  ffff8804252c5fd8 00000000000154c0 ffff880427839470 ffff8804252c5fd8
[25525.916295] Call Trace:
[25525.916295]  [<ffffffff81305d07>] ? schedule_timeout+0x2d/0xd7
[25525.916295]  [<ffffffff81306645>] ? __down_common+0x92/0xe3
[25525.916295]  [<ffffffffa057a3bd>] ? xfs_getsb+0x25/0x32 [xfs]
[25525.916295]  [<ffffffff8105f54c>] ? down+0x27/0x37
[25525.916295]  [<ffffffffa05877ab>] ? xfs_buf_lock+0x73/0xaa [xfs]
[25525.916295]  [<ffffffffa057a3bd>] ? xfs_getsb+0x25/0x32 [xfs]
[25525.916295]  [<ffffffffa057feda>] ? xfs_trans_getsb+0x63/0xb2 [xfs]
[25525.916295]  [<ffffffffa057dfcd>] ? xfs_trans_apply_sb_deltas+0x12/0x1da [xfs]
[25525.916295]  [<ffffffffa057e9a8>] ? _xfs_trans_commit+0x50/0x221 [xfs]
[25525.916295]  [<ffffffffa0570794>] ? xfs_iomap_write_allocate+0x270/0x36c [xfs]
[25525.916295]  [<ffffffffa056a4f0>] ? xfs_iunlock+0x7b/0xb7 [xfs]
[25525.916295]  [<ffffffffa0585356>] ? xfs_map_blocks+0x37/0x3e [xfs]
[25525.916295]  [<ffffffffa05863d5>] ? xfs_page_state_convert+0x268/0x50e [xfs]
[25525.916295]  [<ffffffffa0586843>] ? xfs_vm_writepage+0xef/0x12c [xfs]
[25525.916295]  [<ffffffff810b548a>] ? __writepage+0xa/0x21
[25525.916295]  [<ffffffff810b6504>] ? write_cache_pages+0x1d8/0x2ec
[25525.916295]  [<ffffffff810b5480>] ? __writepage+0x0/0x21
[25525.916295]  [<ffffffff81102cd4>] ? writeback_single_inode+0xd1/0x2e5
[25525.916295]  [<ffffffff8110323e>] ? writeback_sb_inodes+0x136/0x204
[25525.916295]  [<ffffffff811038e3>] ? writeback_inodes_wb+0x127/0x139
[25525.916295]  [<ffffffff81103a83>] ? wb_writeback+0x18e/0x208
[25525.916295]  [<ffffffff81103c30>] ? wb_do_writeback+0x133/0x149
[25525.916295]  [<ffffffff81103c80>] ? bdi_writeback_task+0x3a/0x112
[25525.916295]  [<ffffffff8105b8bb>] ? bit_waitqueue+0x14/0xa1
[25525.916295]  [<ffffffff810c1f4f>] ? bdi_start_fn+0x0/0xc3
[25525.916295]  [<ffffffff810c1fb2>] ? bdi_start_fn+0x63/0xc3
[25525.916295]  [<ffffffff810c1f4f>] ? bdi_start_fn+0x0/0xc3
[25525.916295]  [<ffffffff8105b541>] ? kthread+0x75/0x7d
[25525.916295]  [<ffffffff810097e4>] ? kernel_thread_helper+0x4/0x10
[25525.916295]  [<ffffffff8105b4cc>] ? kthread+0x0/0x7d
[25525.916295]  [<ffffffff810097e0>] ? kernel_thread_helper+0x0/0x10
[25525.916295] xfssyncd/md1  D 0000000100573f32     0  2676      2 0x00000000
[25525.916295]  ffff88042a71afb0 0000000000000046 0000000000000086 ffffffff00000000
[25525.916295]  ffff88042e06ed00 00000000000154c0 00000000000154c0 00000000000154c0
[25525.916295]  ffff88042b57ffd8 00000000000154c0 ffff88042a71afb0 ffff88042b57ffd8
[25525.916295] Call Trace:
[25525.916295]  [<ffffffffa01dc520>] ? raid5_quiesce+0xe3/0x19b [raid456]
[25525.916295]  [<ffffffff8100e7d9>] ? sched_clock+0x5/0x8
[25525.916295]  [<ffffffff8103f760>] ? default_wake_function+0x0/0xf
[25525.916295]  [<ffffffffa01e1971>] ? make_request+0x31/0x403 [raid456]
[25525.916295]  [<ffffffffa0573f35>] ? xlog_write+0x430/0x46e [xfs]
[25525.916295]  [<ffffffffa02767ca>] ? md_make_request+0xd0/0x1d4 [md_mod]
[25525.916295]  [<ffffffffa057542f>] ? xlog_commit_record+0x92/0xc2 [xfs]
[25525.916295]  [<ffffffffa0580333>] ? xfs_trans_unlock_chunk+0x7d/0xc1 [xfs]
[25525.916295]  [<ffffffff8117583c>] ? generic_make_request+0x27a/0x2f0
[25525.916295]  [<ffffffff810b09dd>] ? mempool_alloc+0x53/0x106
[25525.916295]  [<ffffffff81175983>] ? submit_bio+0xd1/0xed
[25525.916295]  [<ffffffffa05874d2>] ? _xfs_buf_ioapply+0x212/0x24f [xfs]
[25525.916295]  [<ffffffffa0572ace>] ? xlog_bdstrat+0x3a/0x3e [xfs]
[25525.916295]  [<ffffffffa0588430>] ? xfs_buf_iorequest+0x75/0x8e [xfs]
[25525.916295]  [<ffffffffa0572ace>] ? xlog_bdstrat+0x3a/0x3e [xfs]
[25525.916295]  [<ffffffffa0572ce1>] ? xlog_sync+0x20f/0x326 [xfs]
[25525.916295]  [<ffffffffa05736d4>] ? _xfs_log_force+0xd9/0x196 [xfs]
[25525.916295]  [<ffffffffa0573915>] ? xfs_log_force+0xb/0x2a [xfs]
[25525.916295]  [<ffffffffa058fd5d>] ? xfs_commit_dummy_trans+0xb3/0xc2 [xfs]
[25525.916295]  [<ffffffffa05903ac>] ? xfs_sync_worker+0x41/0x60 [xfs]
[25525.916295]  [<ffffffffa058fc2e>] ? xfssyncd+0x155/0x1d1 [xfs]
[25525.916295]  [<ffffffffa058fad9>] ? xfssyncd+0x0/0x1d1 [xfs]
[25525.916295]  [<ffffffff8105b541>] ? kthread+0x75/0x7d
[25525.916295]  [<ffffffff810097e4>] ? kernel_thread_helper+0x4/0x10
[25525.916295]  [<ffffffff8105b4cc>] ? kthread+0x0/0x7d
[25525.916295]  [<ffffffff810097e0>] ? kernel_thread_helper+0x0/0x10
[25525.916295] nfsd          D 00000001005740cc     0  3388      2 0x00000000
[25525.916295]  ffff88042a71a210 0000000000000046 ffff880100001000 0000000000000000
[25525.916295]  ffff88042e0da8e0 00000000000154c0 00000000000154c0 00000000000154c0
[25525.916295]  ffff88042128dfd8 00000000000154c0 ffff88042a71a210 ffff88042128dfd8
[25525.916295] Call Trace:
[25525.916295]  [<ffffffff8100e806>] ? read_tsc+0x5/0x16
[25525.916295]  [<ffffffff810aefe5>] ? sync_page+0x0/0x45
[25525.916295]  [<ffffffff813059f0>] ? io_schedule+0x6b/0xaa
[25525.916295]  [<ffffffff810af026>] ? sync_page+0x41/0x45
[25525.916295]  [<ffffffff81305e3b>] ? __wait_on_bit_lock+0x3c/0x85
[25525.916295]  [<ffffffff810aefd2>] ? __lock_page+0x5d/0x63
[25525.916295]  [<ffffffff8105b9bf>] ? wake_bit_function+0x0/0x2e
[25525.916295]  [<ffffffff811067e1>] ? __generic_file_splice_read+0x26c/0x420
[25525.916295]  [<ffffffff81255ec9>] ? dev_queue_xmit+0x42d/0x45b
[25525.916295]  [<ffffffff8127e914>] ? ip_queue_xmit+0x2dc/0x33c
[25525.916295]  [<ffffffff81306561>] ? down_read+0x9/0x19
[25525.916295]  [<ffffffffa056a66a>] ? xfs_ilock+0x5c/0x97 [xfs]
[25525.916295]  [<ffffffffa056af1c>] ? xfs_iget+0x51f/0x58b [xfs]
[25525.916295]  [<ffffffff812491ca>] ? release_sock+0x19/0xf3
[25525.916295]  [<ffffffff810b2dfc>] ? free_pcppages_bulk+0x13d/0x150
[25525.916295]  [<ffffffff81104eca>] ? spd_release_page+0x0/0x14
[25525.916295]  [<ffffffff811069d0>] ? generic_file_splice_read+0x3b/0x63
[25525.916295]  [<ffffffffa05894cd>] ? xfs_file_splice_read+0xe4/0x12e [xfs]
[25525.916295]  [<ffffffff81105019>] ? splice_direct_to_actor+0xba/0x17b
[25525.916295]  [<ffffffffa05d4851>] ? nfsd_direct_splice_actor+0x0/0x13 [nfsd]
[25525.916295]  [<ffffffffa05d4748>] ? nfsd_vfs_read+0x242/0x34b [nfsd]
[25525.916295]  [<ffffffffa05d4e4d>] ? nfsd_read+0xa5/0xc4 [nfsd]
[25525.916295]  [<ffffffffa05db583>] ? nfsd3_proc_read+0xd6/0x114 [nfsd]
[25525.916295]  [<ffffffffa05d0334>] ? nfsd_dispatch+0xdf/0x1b5 [nfsd]
[25525.916295]  [<ffffffffa02e0596>] ? svc_process+0x40d/0x60b [sunrpc]
[25525.916295]  [<ffffffffa05d0851>] ? nfsd+0xe8/0x131 [nfsd]
[25525.916295]  [<ffffffffa05d0769>] ? nfsd+0x0/0x131 [nfsd]
[25525.916295]  [<ffffffff8105b541>] ? kthread+0x75/0x7d
[25525.916295]  [<ffffffff810097e4>] ? kernel_thread_helper+0x4/0x10
[25525.916295]  [<ffffffff8105b4cc>] ? kthread+0x0/0x7d
[25525.916295]  [<ffffffff810097e0>] ? kernel_thread_helper+0x0/0x10
[25525.916295] nfsd          D 0000000100573eb1     0  3389      2 0x00000000
[25525.916295]  ffff88042a71e630 0000000000000046 0000000100000000 ffff880400000000
[25525.916295]  ffff88042e06b680 00000000000154c0 00000000000154c0 00000000000154c0
[25525.916295]  ffff880421387fd8 00000000000154c0 ffff88042a71e630 ffff880421387fd8
[25525.916295] Call Trace:
[25525.916295]  [<ffffffff8100e806>] ? read_tsc+0x5/0x16
[25525.916295]  [<ffffffff810aefe5>] ? sync_page+0x0/0x45
[25525.916295]  [<ffffffff813059f0>] ? io_schedule+0x6b/0xaa
[25525.916295]  [<ffffffff810af026>] ? sync_page+0x41/0x45
[25525.916295]  [<ffffffff81305f39>] ? __wait_on_bit+0x3e/0x6f
[25525.916295]  [<ffffffff810af161>] ? wait_on_page_bit+0x6a/0x70
[25525.916295]  [<ffffffff8105b9bf>] ? wake_bit_function+0x0/0x2e
[25525.916295]  [<ffffffff810b6de4>] ? pagevec_lookup_tag+0x18/0x1f
[25525.916295]  [<ffffffff810af3b5>] ? filemap_fdatawait_range+0x96/0x14a
[25525.916295]  [<ffffffff810af4d2>] ? __filemap_fdatawrite_range+0x48/0x4d
[25525.916295]  [<ffffffff810af514>] ? filemap_write_and_wait_range+0x3d/0x50
[25525.916295]  [<ffffffffa058a5d1>] ? xfs_file_aio_write+0x6ab/0x762 [xfs]
[25525.916295]  [<ffffffffa056af1c>] ? xfs_iget+0x51f/0x58b [xfs]
[25525.916295]  [<ffffffff810e0afe>] ? __slab_free+0x1c/0x250
[25525.916295]  [<ffffffffa0589f26>] ? xfs_file_aio_write+0x0/0x762 [xfs]
[25525.916295]  [<ffffffff810e9324>] ? do_sync_readv_writev+0x9a/0xd5
[25525.916295]  [<ffffffffa056a4f0>] ? xfs_iunlock+0x7b/0xb7 [xfs]
[25525.916295]  [<ffffffff810e0f8b>] ? __slab_alloc+0xf9/0x3eb
[25525.916295]  [<ffffffff810e90d5>] ? copy_from_user+0x18/0x30
[25525.916295]  [<ffffffff810e9e43>] ? rw_copy_check_uvector+0x6a/0xe1
[25525.916295]  [<ffffffff810e9f5e>] ? do_readv_writev+0xa4/0x118
[25525.916295]  [<ffffffffa05d8ae5>] ? nfsd_setuser+0x1a2/0x1e5 [nfsd]
[25525.916295]  [<ffffffffa05d2ff4>] ? nfsd_setuser_and_check_port+0x76/0x92 [nfsd]
[25525.916295]  [<ffffffffa05d4300>] ? nfsd_vfs_write+0x11b/0x321 [nfsd]
[25525.916295]  [<ffffffff810e81f8>] ? __dentry_open+0x184/0x28f
[25525.916295]  [<ffffffffa05d4d87>] ? nfsd_write+0xbb/0xdc [nfsd]
[25525.916295]  [<ffffffffa05d8e8a>] ? nfsd_cache_lookup+0x26e/0x37d [nfsd]
[25525.916295]  [<ffffffffa05db492>] ? nfsd3_proc_write+0xcf/0xea [nfsd]
[25525.916295]  [<ffffffffa05d0334>] ? nfsd_dispatch+0xdf/0x1b5 [nfsd]
[25525.916295]  [<ffffffffa02e0596>] ? svc_process+0x40d/0x60b [sunrpc]
[25525.916295]  [<ffffffffa05d0851>] ? nfsd+0xe8/0x131 [nfsd]
[25525.916295]  [<ffffffffa05d0769>] ? nfsd+0x0/0x131 [nfsd]
[25525.916295]  [<ffffffff8105b541>] ? kthread+0x75/0x7d
[25525.916295]  [<ffffffff810097e4>] ? kernel_thread_helper+0x4/0x10
[25525.916295]  [<ffffffff8105b4cc>] ? kthread+0x0/0x7d
[25525.916295]  [<ffffffff810097e0>] ? kernel_thread_helper+0x0/0x10
[25525.916295] nfsd          D 0000000100574314     0  3390      2 0x00000000
[25525.916295]  ffff88042a71f3d0 0000000000000046 00000000000002c9 ffff880400000000
[25525.916295]  ffffffff81632020 00000000000154c0 00000000000154c0 00000000000154c0
[25525.916295]  ffff880420c81fd8 00000000000154c0 ffff88042a71f3d0 ffff880420c81fd8
[25525.916295] Call Trace:
[25525.916295]  [<ffffffff81306bdd>] ? rwsem_down_failed_common+0x97/0xcb
[25525.916295]  [<ffffffff81306c58>] ? rwsem_down_read_failed+0x22/0x2b
[25525.916295]  [<ffffffff8118f714>] ? call_rwsem_down_read_failed+0x14/0x30
[25525.916295]  [<ffffffff8130656f>] ? down_read+0x17/0x19
[25525.916295]  [<ffffffffa056a66a>] ? xfs_ilock+0x5c/0x97 [xfs]
[25525.916295]  [<ffffffffa056acd9>] ? xfs_iget+0x2dc/0x58b [xfs]
[25525.916295]  [<ffffffff810e0afe>] ? __slab_free+0x1c/0x250
[25525.916295]  [<ffffffff812491ca>] ? release_sock+0x19/0xf3
[25525.916295]  [<ffffffffa05d2eb4>] ? nfsd_acceptable+0x0/0xca [nfsd]
[25525.916295]  [<ffffffffa05890d0>] ? xfs_nfs_get_inode+0x34/0x83 [xfs]
[25525.916295]  [<ffffffffa02e858b>] ? cache_check+0x3f/0x29c [sunrpc]
[25525.916295]  [<ffffffffa05891b9>] ? xfs_fs_fh_to_dentry+0x67/0x71 [xfs]
[25525.916295]  [<ffffffffa01a2589>] ? exportfs_decode_fh+0x46/0x215 [exportfs]
[25525.916295]  [<ffffffffa02e858b>] ? cache_check+0x3f/0x29c [sunrpc]
[25525.916295]  [<ffffffffa05d7687>] ? exp_find_key+0x6a/0x7d [nfsd]
[25525.916295]  [<ffffffff812457b6>] ? sock_recvmsg+0x86/0x9e
[25525.916295]  [<ffffffffa05d32b1>] ? fh_verify+0x2a1/0x4ec [nfsd]
[25525.916295]  [<ffffffffa05d495e>] ? nfsd_open+0x1a/0x13b [nfsd]
[25525.916295]  [<ffffffffa05d4d5a>] ? nfsd_write+0x8e/0xdc [nfsd]
[25525.916295]  [<ffffffff810e0afe>] ? __slab_free+0x1c/0x250
[25525.916295]  [<ffffffffa05d8e8a>] ? nfsd_cache_lookup+0x26e/0x37d [nfsd]
[25525.916295]  [<ffffffffa05db492>] ? nfsd3_proc_write+0xcf/0xea [nfsd]
[25525.916295]  [<ffffffffa05d0334>] ? nfsd_dispatch+0xdf/0x1b5 [nfsd]
[25525.916295]  [<ffffffffa02e0596>] ? svc_process+0x40d/0x60b [sunrpc]
[25525.916295]  [<ffffffffa05d0851>] ? nfsd+0xe8/0x131 [nfsd]
[25525.916295]  [<ffffffffa05d0769>] ? nfsd+0x0/0x131 [nfsd]
[25525.916295]  [<ffffffff8105b541>] ? kthread+0x75/0x7d
[25525.916295]  [<ffffffff810097e4>] ? kernel_thread_helper+0x4/0x10
[25525.916295]  [<ffffffff8105b4cc>] ? kthread+0x0/0x7d
[25525.916295]  [<ffffffff810097e0>] ? kernel_thread_helper+0x0/0x10
[25525.916295] nfsd          D 0000000100573eb1     0  3391      2 0x00000000
[25525.916295]  ffff88042a71caf0 0000000000000046 ffff88042a443000 ffffffff00000000
[25525.916295]  ffff88042e0d8da0 00000000000154c0 00000000000154c0 00000000000154c0
[25525.916295]  ffff880420d99fd8 00000000000154c0 ffff88042a71caf0 ffff880420d99fd8
[25525.916295] Call Trace:
[25525.916295]  [<ffffffff8100e806>] ? read_tsc+0x5/0x16
[25525.916295]  [<ffffffff810aefe5>] ? sync_page+0x0/0x45
[25525.916295]  [<ffffffff813059f0>] ? io_schedule+0x6b/0xaa
[25525.916295]  [<ffffffff810af026>] ? sync_page+0x41/0x45
[25525.916295]  [<ffffffff81305f39>] ? __wait_on_bit+0x3e/0x6f
[25525.916295]  [<ffffffff810af161>] ? wait_on_page_bit+0x6a/0x70
[25525.916295]  [<ffffffff8105b9bf>] ? wake_bit_function+0x0/0x2e
[25525.916295]  [<ffffffff810b6de4>] ? pagevec_lookup_tag+0x18/0x1f
[25525.916295]  [<ffffffff810af3b5>] ? filemap_fdatawait_range+0x96/0x14a
[25525.916295]  [<ffffffff810af4d2>] ? __filemap_fdatawrite_range+0x48/0x4d
[25525.916295]  [<ffffffff810af514>] ? filemap_write_and_wait_range+0x3d/0x50
[25525.916295]  [<ffffffffa058a5d1>] ? xfs_file_aio_write+0x6ab/0x762 [xfs]
[25525.916295]  [<ffffffffa056af1c>] ? xfs_iget+0x51f/0x58b [xfs]
[25525.916295]  [<ffffffff810e0afe>] ? __slab_free+0x1c/0x250
[25525.916295]  [<ffffffffa0589f26>] ? xfs_file_aio_write+0x0/0x762 [xfs]
[25525.916295]  [<ffffffff810e9324>] ? do_sync_readv_writev+0x9a/0xd5
[25525.916295]  [<ffffffffa056a4f0>] ? xfs_iunlock+0x7b/0xb7 [xfs]
[25525.916295]  [<ffffffffa01a2602>] ? exportfs_decode_fh+0xbf/0x215 [exportfs]
[25525.916295]  [<ffffffff810e90d5>] ? copy_from_user+0x18/0x30
[25525.916295]  [<ffffffff810e9e43>] ? rw_copy_check_uvector+0x6a/0xe1
[25525.916295]  [<ffffffff810e9f5e>] ? do_readv_writev+0xa4/0x118
[25525.916295]  [<ffffffffa05d8ae5>] ? nfsd_setuser+0x1a2/0x1e5 [nfsd]
[25525.916295]  [<ffffffffa05d2ff4>] ? nfsd_setuser_and_check_port+0x76/0x92 [nfsd]
[25525.916295]  [<ffffffffa05d4300>] ? nfsd_vfs_write+0x11b/0x321 [nfsd]
[25525.916295]  [<ffffffff810e81f8>] ? __dentry_open+0x184/0x28f
[25525.916295]  [<ffffffffa05d4d87>] ? nfsd_write+0xbb/0xdc [nfsd]
[25525.916295]  [<ffffffffa05d8e8a>] ? nfsd_cache_lookup+0x26e/0x37d [nfsd]
[25525.916295]  [<ffffffffa05db492>] ? nfsd3_proc_write+0xcf/0xea [nfsd]
[25525.916295]  [<ffffffffa05d0334>] ? nfsd_dispatch+0xdf/0x1b5 [nfsd]
[25525.916295]  [<ffffffffa02e0596>] ? svc_process+0x40d/0x60b [sunrpc]
[25525.916295]  [<ffffffffa05d0851>] ? nfsd+0xe8/0x131 [nfsd]
[25525.916295]  [<ffffffffa05d0769>] ? nfsd+0x0/0x131 [nfsd]
[25525.916295]  [<ffffffff8105b541>] ? kthread+0x75/0x7d
[25525.916295]  [<ffffffff810097e4>] ? kernel_thread_helper+0x4/0x10
[25525.916295]  [<ffffffff8105b4cc>] ? kthread+0x0/0x7d
[25525.916295]  [<ffffffff810097e0>] ? kernel_thread_helper+0x0/0x10
[25525.916295] nfsd          D 00000001005740cf     0  3392      2 0x00000000
[25525.916295]  ffff88042a71d890 0000000000000046 ffff880420e93678 ffff880420bdb930
[25525.916295]  ffffffff81632020 00000000000154c0 00000000000154c0 00000000000154c0
[25525.916295]  ffff880420e93fd8 00000000000154c0 ffff88042a71d890 ffff880420e93fd8
[25525.916295] Call Trace:
[25525.916295]  [<ffffffff810dfe2f>] ? virt_to_head_page+0x9/0x2a
[25525.916295]  [<ffffffff81305d07>] ? schedule_timeout+0x2d/0xd7
[25525.916295]  [<ffffffff81306645>] ? __down_common+0x92/0xe3
[25525.916295]  [<ffffffffa057a3bd>] ? xfs_getsb+0x25/0x32 [xfs]
[25525.916295]  [<ffffffff8105f54c>] ? down+0x27/0x37
[25525.916295]  [<ffffffffa05877ab>] ? xfs_buf_lock+0x73/0xaa [xfs]
[25525.916295]  [<ffffffffa057a3bd>] ? xfs_getsb+0x25/0x32 [xfs]
[25525.916295]  [<ffffffffa057feda>] ? xfs_trans_getsb+0x63/0xb2 [xfs]
[25525.916295]  [<ffffffffa057dfcd>] ? xfs_trans_apply_sb_deltas+0x12/0x1da [xfs]
[25525.916295]  [<ffffffffa057e9a8>] ? _xfs_trans_commit+0x50/0x221 [xfs]
[25525.916295]  [<ffffffffa056b179>] ? xfs_iext_get_ext+0x40/0x66 [xfs]
[25525.916295]  [<ffffffffa0570794>] ? xfs_iomap_write_allocate+0x270/0x36c [xfs]
[25525.916295]  [<ffffffffa056a4f0>] ? xfs_iunlock+0x7b/0xb7 [xfs]
[25525.916295]  [<ffffffffa0585356>] ? xfs_map_blocks+0x37/0x3e [xfs]
[25525.916295]  [<ffffffffa05863d5>] ? xfs_page_state_convert+0x268/0x50e [xfs]
[25525.916295]  [<ffffffffa0586843>] ? xfs_vm_writepage+0xef/0x12c [xfs]
[25525.916295]  [<ffffffff810b548a>] ? __writepage+0xa/0x21
[25525.916295]  [<ffffffff810b6504>] ? write_cache_pages+0x1d8/0x2ec
[25525.916295]  [<ffffffff810b5480>] ? __writepage+0x0/0x21
[25525.916295]  [<ffffffff81108dc5>] ? block_write_end+0x4e/0x57
[25525.916295]  [<ffffffff81108e1a>] ? generic_write_end+0x4c/0x6d
[25525.916295]  [<ffffffff810af4d2>] ? __filemap_fdatawrite_range+0x48/0x4d
[25525.916295]  [<ffffffff810af4fe>] ? filemap_write_and_wait_range+0x27/0x50
[25525.916295]  [<ffffffffa058a5d1>] ? xfs_file_aio_write+0x6ab/0x762 [xfs]
[25525.916295]  [<ffffffffa056af1c>] ? xfs_iget+0x51f/0x58b [xfs]
[25525.916295]  [<ffffffff810e0b47>] ? __slab_free+0x65/0x250
[25525.916295]  [<ffffffffa0589f26>] ? xfs_file_aio_write+0x0/0x762 [xfs]
[25525.916295]  [<ffffffff810e9324>] ? do_sync_readv_writev+0x9a/0xd5
[25525.916295]  [<ffffffffa056a4f0>] ? xfs_iunlock+0x7b/0xb7 [xfs]
[25525.916295]  [<ffffffff810615c7>] ? groups_alloc+0x35/0xb4
[25525.916295]  [<ffffffff810e90d5>] ? copy_from_user+0x18/0x30
[25525.916295]  [<ffffffff810e9e43>] ? rw_copy_check_uvector+0x6a/0xe1
[25525.916295]  [<ffffffff810e9f5e>] ? do_readv_writev+0xa4/0x118
[25525.916295]  [<ffffffffa05d8ae5>] ? nfsd_setuser+0x1a2/0x1e5 [nfsd]
[25525.916295]  [<ffffffff810e09d3>] ? get_partial_node+0x15/0x82
[25525.916295]  [<ffffffff810e0f8b>] ? __slab_alloc+0xf9/0x3eb
[25525.916295]  [<ffffffff810ea823>] ? get_empty_filp+0x70/0x12f
[25525.916295]  [<ffffffffa05d4300>] ? nfsd_vfs_write+0x11b/0x321 [nfsd]
[25525.916295]  [<ffffffff810e81f8>] ? __dentry_open+0x184/0x28f
[25525.916295]  [<ffffffffa05d4d87>] ? nfsd_write+0xbb/0xdc [nfsd]
[25525.916295]  [<ffffffffa05d8e8a>] ? nfsd_cache_lookup+0x26e/0x37d [nfsd]
[25525.916295]  [<ffffffffa05db492>] ? nfsd3_proc_write+0xcf/0xea [nfsd]
[25525.916295]  [<ffffffffa05d0334>] ? nfsd_dispatch+0xdf/0x1b5 [nfsd]
[25525.916295]  [<ffffffffa02e0596>] ? svc_process+0x40d/0x60b [sunrpc]
[25525.916295]  [<ffffffffa05d0851>] ? nfsd+0xe8/0x131 [nfsd]
[25525.916295]  [<ffffffffa05d0769>] ? nfsd+0x0/0x131 [nfsd]
[25525.916295]  [<ffffffff8105b541>] ? kthread+0x75/0x7d
[25525.916295]  [<ffffffff810097e4>] ? kernel_thread_helper+0x4/0x10
[25525.916295]  [<ffffffff8105b4cc>] ? kthread+0x0/0x7d
[25525.916295]  [<ffffffff810097e0>] ? kernel_thread_helper+0x0/0x10
[25525.916295] nfsd          D 0000000100573eb1     0  3393      2 0x00000000
[25525.916295]  ffff88042a71df60 0000000000000046 ffff88042a442000 ffffffff00000000
[25525.916295]  ffffffff81632020 00000000000154c0 00000000000154c0 00000000000154c0
[25525.916295]  ffff880420f8dfd8 00000000000154c0 ffff88042a71df60 ffff880420f8dfd8
[25525.916295] Call Trace:
[25525.916295]  [<ffffffff8100e806>] ? read_tsc+0x5/0x16
[25525.916295]  [<ffffffff810aefe5>] ? sync_page+0x0/0x45
[25525.916295]  [<ffffffff813059f0>] ? io_schedule+0x6b/0xaa
[25525.916295]  [<ffffffff810af026>] ? sync_page+0x41/0x45
[25525.916295]  [<ffffffff81305f39>] ? __wait_on_bit+0x3e/0x6f
[25525.916295]  [<ffffffff810af161>] ? wait_on_page_bit+0x6a/0x70
[25525.916295]  [<ffffffff8105b9bf>] ? wake_bit_function+0x0/0x2e
[25525.916295]  [<ffffffff810b6de4>] ? pagevec_lookup_tag+0x18/0x1f
[25525.916295]  [<ffffffff810af3b5>] ? filemap_fdatawait_range+0x96/0x14a
[25525.916295]  [<ffffffff810af4d2>] ? __filemap_fdatawrite_range+0x48/0x4d
[25525.916295]  [<ffffffff810af514>] ? filemap_write_and_wait_range+0x3d/0x50
[25525.916295]  [<ffffffffa058a5d1>] ? xfs_file_aio_write+0x6ab/0x762 [xfs]
[25525.916295]  [<ffffffffa056af1c>] ? xfs_iget+0x51f/0x58b [xfs]
[25525.916295]  [<ffffffff810e0afe>] ? __slab_free+0x1c/0x250
[25525.916295]  [<ffffffffa0589f26>] ? xfs_file_aio_write+0x0/0x762 [xfs]
[25525.916295]  [<ffffffff810e9324>] ? do_sync_readv_writev+0x9a/0xd5
[25525.916295]  [<ffffffffa056a4f0>] ? xfs_iunlock+0x7b/0xb7 [xfs]
[25525.916295]  [<ffffffffa01a2602>] ? exportfs_decode_fh+0xbf/0x215 [exportfs]
[25525.916295]  [<ffffffff810e90d5>] ? copy_from_user+0x18/0x30
[25525.916295]  [<ffffffff810e9e43>] ? rw_copy_check_uvector+0x6a/0xe1
[25525.916295]  [<ffffffff810e9f5e>] ? do_readv_writev+0xa4/0x118
[25525.916295]  [<ffffffffa05d8ae5>] ? nfsd_setuser+0x1a2/0x1e5 [nfsd]
[25525.916295]  [<ffffffffa05d2ff4>] ? nfsd_setuser_and_check_port+0x76/0x92 [nfsd]
[25525.916295]  [<ffffffffa05d4300>] ? nfsd_vfs_write+0x11b/0x321 [nfsd]
[25525.916295]  [<ffffffff810e81f8>] ? __dentry_open+0x184/0x28f
[25525.916295]  [<ffffffffa05d4d87>] ? nfsd_write+0xbb/0xdc [nfsd]
[25525.916295]  [<ffffffffa05d8e8a>] ? nfsd_cache_lookup+0x26e/0x37d [nfsd]
[25525.916295]  [<ffffffffa05db492>] ? nfsd3_proc_write+0xcf/0xea [nfsd]
[25525.916295]  [<ffffffffa05d0334>] ? nfsd_dispatch+0xdf/0x1b5 [nfsd]
[25525.916295]  [<ffffffffa02e0596>] ? svc_process+0x40d/0x60b [sunrpc]
[25525.916295]  [<ffffffffa05d0851>] ? nfsd+0xe8/0x131 [nfsd]
[25525.916295]  [<ffffffffa05d0769>] ? nfsd+0x0/0x131 [nfsd]
[25525.916295]  [<ffffffff8105b541>] ? kthread+0x75/0x7d
[25525.916295]  [<ffffffff810097e4>] ? kernel_thread_helper+0x4/0x10
[25525.916295]  [<ffffffff8105b4cc>] ? kthread+0x0/0x7d
[25525.916295]  [<ffffffff810097e0>] ? kernel_thread_helper+0x0/0x10
[25525.916295] nfsd          D 0000000100573eb1     0  3394      2 0x00000000
[25525.916295]  ffff88042a719b40 0000000000000046 ffff88042a443800 ffffffff00000000
[25525.916295]  ffff88042e06ed00 00000000000154c0 00000000000154c0 00000000000154c0
[25525.916295]  ffff8804208affd8 00000000000154c0 ffff88042a719b40 ffff8804208affd8
[25525.916295] Call Trace:
[25525.916295]  [<ffffffff8100e806>] ? read_tsc+0x5/0x16
[25525.916295]  [<ffffffff810aefe5>] ? sync_page+0x0/0x45
[25525.916295]  [<ffffffff813059f0>] ? io_schedule+0x6b/0xaa
[25525.916295]  [<ffffffff810af026>] ? sync_page+0x41/0x45
[25525.916295]  [<ffffffff81305f39>] ? __wait_on_bit+0x3e/0x6f
[25525.916295]  [<ffffffff810af161>] ? wait_on_page_bit+0x6a/0x70
[25525.916295]  [<ffffffff8105b9bf>] ? wake_bit_function+0x0/0x2e
[25525.916295]  [<ffffffff810b6de4>] ? pagevec_lookup_tag+0x18/0x1f
[25525.916295]  [<ffffffff810af3b5>] ? filemap_fdatawait_range+0x96/0x14a
[25525.916295]  [<ffffffff810af4d2>] ? __filemap_fdatawrite_range+0x48/0x4d
[25525.916295]  [<ffffffff810af514>] ? filemap_write_and_wait_range+0x3d/0x50
[25525.916295]  [<ffffffffa058a5d1>] ? xfs_file_aio_write+0x6ab/0x762 [xfs]
[25525.916295]  [<ffffffff8118bd35>] ? rwsem_wake+0x38/0x3f
[25525.916295]  [<ffffffff8118f767>] ? call_rwsem_wake+0x17/0x30
[25525.916295]  [<ffffffffa0589f26>] ? xfs_file_aio_write+0x0/0x762 [xfs]
[25525.916295]  [<ffffffff810e9324>] ? do_sync_readv_writev+0x9a/0xd5
[25525.916295]  [<ffffffffa056a4f0>] ? xfs_iunlock+0x7b/0xb7 [xfs]
[25525.916295]  [<ffffffff810615c7>] ? groups_alloc+0x35/0xb4
[25525.916295]  [<ffffffff810e90d5>] ? copy_from_user+0x18/0x30
[25525.916295]  [<ffffffff810e9e43>] ? rw_copy_check_uvector+0x6a/0xe1
[25525.916295]  [<ffffffff810e9f5e>] ? do_readv_writev+0xa4/0x118
[25525.916295]  [<ffffffffa05d8ae5>] ? nfsd_setuser+0x1a2/0x1e5 [nfsd]
[25525.916295]  [<ffffffffa05d2ff4>] ? nfsd_setuser_and_check_port+0x76/0x92 [nfsd]
[25525.916295]  [<ffffffffa05d4300>] ? nfsd_vfs_write+0x11b/0x321 [nfsd]
[25525.916295]  [<ffffffff810e81f8>] ? __dentry_open+0x184/0x28f
[25525.916295]  [<ffffffffa05d4d87>] ? nfsd_write+0xbb/0xdc [nfsd]
[25525.916295]  [<ffffffffa05d8e8a>] ? nfsd_cache_lookup+0x26e/0x37d [nfsd]
[25525.916295]  [<ffffffffa05db492>] ? nfsd3_proc_write+0xcf/0xea [nfsd]
[25525.916295]  [<ffffffffa05d0334>] ? nfsd_dispatch+0xdf/0x1b5 [nfsd]
[25525.916295]  [<ffffffffa02e0596>] ? svc_process+0x40d/0x60b [sunrpc]
[25525.916295]  [<ffffffffa05d0851>] ? nfsd+0xe8/0x131 [nfsd]
[25525.916295]  [<ffffffffa05d0769>] ? nfsd+0x0/0x131 [nfsd]
[25525.916295]  [<ffffffff8105b541>] ? kthread+0x75/0x7d
[25525.916295]  [<ffffffff810097e4>] ? kernel_thread_helper+0x4/0x10
[25525.916295]  [<ffffffff8105b4cc>] ? kthread+0x0/0x7d
[25525.916295]  [<ffffffff810097e0>] ? kernel_thread_helper+0x0/0x10
[25525.916295] nfsd          D 0000000100573ec5     0  3395      2 0x00000000
[25525.916295]  ffff88042a718da0 0000000000000046 0000000000000000 0000020c00000000
[25525.916295]  ffff88042e06ed00 00000000000154c0 00000000000154c0 00000000000154c0
[25525.916295]  ffff8804209a9fd8 00000000000154c0 ffff88042a718da0 ffff8804209a9fd8
[25525.916295] Call Trace:
[25525.916295]  [<ffffffffa01dc520>] ? raid5_quiesce+0xe3/0x19b [raid456]
[25525.916295]  [<ffffffff8103f760>] ? default_wake_function+0x0/0xf
[25525.916295]  [<ffffffffa01e1971>] ? make_request+0x31/0x403 [raid456]
[25525.916295]  [<ffffffffa057fae4>] ? _xfs_trans_bjoin+0x3b/0x47 [xfs]
[25525.916295]  [<ffffffffa057f961>] ? xfs_trans_log_buf+0x8f/0xb5 [xfs]
[25525.916295]  [<ffffffffa05570b9>] ? xfs_btree_log_block+0x51/0x7b [xfs]
[25525.916295]  [<ffffffffa02767ca>] ? md_make_request+0xd0/0x1d4 [md_mod]
[25525.916295]  [<ffffffff8117583c>] ? generic_make_request+0x27a/0x2f0
[25525.916295]  [<ffffffff810b09dd>] ? mempool_alloc+0x53/0x106
[25525.916295]  [<ffffffff81175983>] ? submit_bio+0xd1/0xed
[25525.916295]  [<ffffffffa05874d2>] ? _xfs_buf_ioapply+0x212/0x24f [xfs]
[25525.916295]  [<ffffffffa0572ace>] ? xlog_bdstrat+0x3a/0x3e [xfs]
[25525.916295]  [<ffffffffa0588430>] ? xfs_buf_iorequest+0x75/0x8e [xfs]
[25525.916295]  [<ffffffffa0572ace>] ? xlog_bdstrat+0x3a/0x3e [xfs]
[25525.916295]  [<ffffffffa0572ce1>] ? xlog_sync+0x20f/0x326 [xfs]
[25525.916295]  [<ffffffffa0573e1a>] ? xlog_write+0x315/0x46e [xfs]
[25525.916295]  [<ffffffffa0573fc2>] ? xfs_log_write+0x4f/0x7a [xfs]
[25525.916295]  [<ffffffffa057e814>] ? xfs_trans_commit_iclog+0x146/0x28a [xfs]
[25525.916295]  [<ffffffff8105f533>] ? down+0xe/0x37
[25525.916295]  [<ffffffffa057fae4>] ? _xfs_trans_bjoin+0x3b/0x47 [xfs]
[25525.916295]  [<ffffffffa057f961>] ? xfs_trans_log_buf+0x8f/0xb5 [xfs]
[25525.916295]  [<ffffffffa057ea32>] ? _xfs_trans_commit+0xda/0x221 [xfs]
[25525.916295]  [<ffffffffa0570794>] ? xfs_iomap_write_allocate+0x270/0x36c [xfs]
[25525.916295]  [<ffffffffa056a4f0>] ? xfs_iunlock+0x7b/0xb7 [xfs]
[25525.916295]  [<ffffffffa0585356>] ? xfs_map_blocks+0x37/0x3e [xfs]
[25525.916295]  [<ffffffffa05863d5>] ? xfs_page_state_convert+0x268/0x50e [xfs]
[25525.916295]  [<ffffffffa0586843>] ? xfs_vm_writepage+0xef/0x12c [xfs]
[25525.916295]  [<ffffffff810b548a>] ? __writepage+0xa/0x21
[25525.916295]  [<ffffffff810b6504>] ? write_cache_pages+0x1d8/0x2ec
[25525.916295]  [<ffffffff810b5480>] ? __writepage+0x0/0x21
[25525.916295]  [<ffffffff810af4d2>] ? __filemap_fdatawrite_range+0x48/0x4d
[25525.916295]  [<ffffffff810af4fe>] ? filemap_write_and_wait_range+0x27/0x50
[25525.916295]  [<ffffffff81106b66>] ? vfs_fsync_rang
