From: Oleksandr Natalenko <oleksandr@natalenko.name>
Subject: Re: I/O hangs after resuming from suspend-to-ram
Date: Tue, 29 Aug 2017 17:52:42 +0200
Message-ID: <2329566.kid2YYBOAQ@natalenko.name>
References: <3926917.BCSovyVWdL@natalenko.name> <1615033.Xza1AIGLzP@natalenko.name> <20170829002425.GA28904@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170829002425.GA28904@ming.t460p>
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Shaohua Li <shli@kernel.org>
List-Id: linux-raid.ids

Hello.

Re-tested with v4.13-rc7 + proposed patch and got the same result.

Let me know if any additional testing is needed.

=3D=3D=3D
[   82.638148] INFO: task md0_raid10:193 blocked for more than 20 seconds.
[   82.642804]       Not tainted 4.13.0-pf1 #1
[   82.646998] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables=
=20
this message.
[   82.649007] md0_raid10      D    0   193      2 0x00000000
[   82.650799] Call Trace:
[   82.652118]  __schedule+0x239/0x890
[   82.653469]  schedule+0x3d/0x90
[   82.654649]  md_super_wait+0x6e/0xa0 [md_mod]
[   82.656186]  ? wait_woken+0x80/0x80
[   82.657333]  md_update_sb.part.59+0x3df/0x840 [md_mod]
[   82.659084]  ? percpu_ref_switch_to_percpu+0x36/0x40
[   82.660477]  md_check_recovery+0x453/0x520 [md_mod]
[   82.662125]  raid10d+0x62/0x1420 [raid10]
[   82.663457]  ? __schedule+0x241/0x890
[   82.664766]  ? schedule+0x3d/0x90
[   82.665816]  ? schedule_timeout+0x208/0x390
[   82.666785]  md_thread+0x120/0x160 [md_mod]
[   82.668117]  ? md_thread+0x120/0x160 [md_mod]
[   82.669487]  ? wait_woken+0x80/0x80
[   82.670531]  kthread+0x125/0x140
[   82.671602]  ? find_pers+0x70/0x70 [md_mod]
[   82.672452]  ? kthread_create_on_node+0x70/0x70
[   82.673844]  ret_from_fork+0x25/0x30
[   82.674991] INFO: task dmcrypt_write:226 blocked for more than 20 second=
s.
[   82.678246]       Not tainted 4.13.0-pf1 #1
[   82.679336] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables=
=20
this message.
[   82.681175] dmcrypt_write   D    0   226      2 0x00000000
[   82.682522] Call Trace:
[   82.683104]  __schedule+0x239/0x890
[   82.684099]  schedule+0x3d/0x90
[   82.684754]  md_write_start+0xe3/0x270 [md_mod]
[   82.685599]  ? wait_woken+0x80/0x80
[   82.686273]  raid10_make_request+0x3f/0x140 [raid10]
[   82.687258]  md_make_request+0xa2/0x290 [md_mod]
[   82.688132]  ? _raw_spin_unlock_irq+0x10/0x30
[   82.689660]  ? finish_task_switch+0x75/0x200
[   82.690624]  generic_make_request+0x125/0x320
[   82.691722]  dmcrypt_write+0x22d/0x250 [dm_crypt]
[   82.693120]  ? dmcrypt_write+0x22d/0x250 [dm_crypt]
[   82.694760]  ? wake_up_q+0x80/0x80
[   82.695752]  kthread+0x125/0x140
[   82.696831]  ? kthread+0x125/0x140
[   82.697964]  ? crypt_iv_essiv_dtr+0x70/0x70 [dm_crypt]
[   82.699340]  ? kthread_create_on_node+0x70/0x70
[   82.700728]  ret_from_fork+0x25/0x30
[   82.702378] INFO: task NetworkManager:432 blocked for more than 20 secon=
ds.
[   82.704022]       Not tainted 4.13.0-pf1 #1
[   82.705264] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables=
=20
this message.
[   82.709068] NetworkManager  D    0   432      1 0x00000000
[   82.710189] Call Trace:
[   82.711041]  __schedule+0x239/0x890
[   82.712162]  schedule+0x3d/0x90
[   82.713223]  io_schedule+0x16/0x40
[   82.714324]  wait_on_page_bit_common+0xe7/0x170
[   82.715644]  ? page_cache_tree_insert+0xc0/0xc0
[   82.717008]  __filemap_fdatawait_range+0x10d/0x170
[   82.718562]  ? __filemap_fdatawrite_range+0xc1/0x100
[   82.720103]  ? __filemap_fdatawrite_range+0xcd/0x100
[   82.721561]  file_write_and_wait_range+0x78/0xa0
[   82.722839]  xfs_file_fsync+0x5f/0x210 [xfs]
[   82.724085]  vfs_fsync_range+0x4b/0xb0
[   82.725152]  do_fsync+0x3d/0x70
[   82.726535]  SyS_fsync+0x10/0x20
[   82.727953]  entry_SYSCALL_64_fastpath+0x1a/0xa5
[   82.729196] RIP: 0033:0x7fcd816f6c8d
[   82.730336] RSP: 002b:00007ffd4650d4d0 EFLAGS: 00000293 ORIG_RAX:=20
000000000000004a
[   82.732192] RAX: ffffffffffffffda RBX: 0000000000000013 RCX:=20
00007fcd816f6c8d
[   82.733922] RDX: 00007ffd4650d4f0 RSI: 00007ffd4650d4f0 RDI:=20
0000000000000013
[   82.735313] RBP: 000056436710ff00 R08: 0000000000000000 R09:=20
00000000313d26e9
[   82.738973] R10: 000000000000003d R11: 0000000000000293 R12:=20
00007ffd4650d638
[   82.740531] R13: 0000000000000001 R14: 0000000000000002 R15:=20
00005643670eb1c0
[   82.741869] INFO: task sync:676 blocked for more than 20 seconds.
[   82.743116]       Not tainted 4.13.0-pf1 #1
[   82.744286] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables=
=20
this message.
[   82.745935] sync            D    0   676    542 0x00000000
[   82.747338] Call Trace:
[   82.748281]  __schedule+0x239/0x890
[   82.749421]  schedule+0x3d/0x90
[   82.750458]  io_schedule+0x16/0x40
[   82.751420]  wait_on_page_bit_common+0xe7/0x170
[   82.752668]  ? page_cache_tree_insert+0xc0/0xc0
[   82.753873]  __filemap_fdatawait_range+0x10d/0x170
[   82.755153]  ? finish_wait+0x56/0x70
[   82.756226]  filemap_fdatawait_keep_errors+0x27/0x50
[   82.757568]  sync_inodes_sb+0x204/0x2a0
[   82.758788]  ? SyS_tee+0x3d0/0x3d0
[   82.759926]  sync_inodes_one_sb+0x16/0x20
[   82.761152]  iterate_supers+0x94/0x100
[   82.762419]  sys_sync+0x44/0xb0
[   82.763499]  entry_SYSCALL_64_fastpath+0x1a/0xa5
[   82.764495] RIP: 0033:0x7fd85d7941d7
[   82.765736] RSP: 002b:00007ffe648d4f48 EFLAGS: 00000206 ORIG_RAX:=20
00000000000000a2
[   82.769068] RAX: ffffffffffffffda RBX: 0000000000000006 RCX:=20
00007fd85d7941d7
[   82.770663] RDX: 00007fd85da50e01 RSI: 0000000000000000 RDI:=20
00007fd85d8197d3
[   82.772211] RBP: 0000000000002710 R08: 0000000000000000 R09:=20
0000000000000000
[   82.774138] R10: 000000000000082c R11: 0000000000000206 R12:=20
00007fd85da4ead8
[   82.776430] R13: 0000000000000030 R14: 0000000000c6cfd0 R15:=20
00007fd85da4ea80
=3D=3D=3D

On =C3=BAter=C3=BD 29. srpna 2017 2:24:25 CEST Ming Lei wrote:
> On Mon, Aug 28, 2017 at 08:22:26PM +0200, Oleksandr Natalenko wrote:
> > Hi.
> >=20
> > On pond=C4=9Bl=C3=AD 28. srpna 2017 14:58:28 CEST Ming Lei wrote:
> > > Could you verify if the following patch fixes your issue?
> > > =E2=80=A6SNIP=E2=80=A6
> >=20
> > I've applied it to v4.12.9 and rechecked =E2=80=94 the issue is still t=
here,
> > unfortunately. Stacktrace is the same as before.
> >=20
> > Were you able to reproduce it in a VM?
>=20
> Yes, I can.
>=20
> > Should I re-check it with v4.13-rc7?
> >=20
> > Any other suggestions?
>=20
> Please test it with v4.13-rc7 first.
