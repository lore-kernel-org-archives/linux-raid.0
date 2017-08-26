From: Oleksandr Natalenko <oleksandr@natalenko.name>
Subject: Re: I/O hangs after resuming from suspend-to-ram
Date: Sat, 26 Aug 2017 12:48:01 +0200
Message-ID: <1579257.t1hTzJa9iD@natalenko.name>
References: <3926917.BCSovyVWdL@natalenko.name> <2602983.s9jWEo5DpR@natalenko.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <2602983.s9jWEo5DpR@natalenko.name>
Sender: linux-block-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Shaohua Li <shli@kernel.org>
List-Id: linux-raid.ids

Quick update: reproduced on both v4.12.7 and v4.13.0-rc6.

On sobota 26. srpna 2017 12:37:29 CEST Oleksandr Natalenko wrote:
> Hi.
>=20
> I've re-checked this issue with 4.12.9, and it is still there.
>=20
> Also, I've managed to reproduce it in a VM with non-virtio disks (just
> -hda/- hdb pair in QEMU).
>=20
> I'm not able to reproduce it with blk_mq disabled. Also, if blk_mq is
> enabled, scheduler does not make any difference, even setting "none"
> triggers hang on resume.
>=20
> Next, will check for possible change between v4.12.7 and v4.12.8 (I don't
> remember this issue to be triggered on v4.12.7, or maybe I just haven't
> noticed it), and also will recompile kernel with debug info to capture
> proper vmcore.
>=20
> On =FAter=FD 22. srpna 2017 13:45:43 CEST Oleksandr Natalenko wrote:
> > Hi.
> >=20
> > v4.12.8 kernel hangs in I/O path after resuming from suspend-to-ram. I
> > have
> > blk-mq enabled, tried both BFQ and mq-deadline schedulers with the same
> > result. Soft lockup happens showing stacktraces I'm pasting below.
> >=20
> > Stacktrace shows that I/O hangs in md_super_wait(), and it means it wai=
ts
> > for "all superblock writes that were scheduled to complete". Since there
> > is
> > "scheduled" word, should I also try "none" scheduler with blk-mq enable=
d?
> >=20
> > While I'm trying to reproduce it on a VM without much luck (it happens =
on
> > my laptop rarely, like 1 out of 10 suspend-resume cycles), and also
> > re-checking it with blk-mq disabled, by any chance is this something
> > already known?
> >=20
> > Ideally, I'd like to reprduce it in a VM and capture vmcore.
> >=20
> > Any suggestions are welcome. Thanks.
> >=20
> > =3D=3D=3D
> > [ 9460.165958] INFO: task md0_raid10:225 blocked for more than 120
> > seconds.
> > [ 9460.165983]       Not tainted 4.12.0-pf7 #1
> > [ 9460.165989] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disab=
les
> > this message.
> > [ 9460.165996] md0_raid10      D    0   225      2 0x00000000
> > [ 9460.166005] Call Trace:
> > [ 9460.166027]  __schedule+0x6e7/0xcd0
> > [ 9460.166043]  schedule+0x3d/0xd0
> > [ 9460.166067]  md_super_wait+0x6e/0xa0 [md_mod]
> > [ 9460.166130]  ? wake_bit_function+0x60/0x60
> > [ 9460.166143]  write_page+0x185/0x310 [md_mod]
> > [ 9460.166156]  bitmap_update_sb+0x12f/0x140 [md_mod]
> > [ 9460.166167]  md_update_sb.part.60+0x354/0x840 [md_mod]
> > [ 9460.166179]  ? percpu_ref_switch_to_percpu+0x36/0x40
> > [ 9460.166190]  md_check_recovery+0x214/0x4b0 [md_mod]
> > [ 9460.166201]  raid10d+0x62/0x13c0 [raid10]
> > [ 9460.166213]  ? lock_timer_base+0x81/0xa0
> > [ 9460.166222]  ? try_to_del_timer_sync+0x53/0x80
> > [ 9460.166232]  ? del_timer_sync+0x39/0x40
> > [ 9460.166246]  ? schedule_timeout+0x19b/0x330
> > [ 9460.166261]  ? call_timer_fn+0x160/0x160
> > [ 9460.166279]  md_thread+0x120/0x160 [md_mod]
> > [ 9460.166290]  ? md_thread+0x120/0x160 [md_mod]
> > [ 9460.166298]  ? wake_bit_function+0x60/0x60
> > [ 9460.166309]  kthread+0x124/0x140
> > [ 9460.166319]  ? find_pers+0x70/0x70 [md_mod]
> > [ 9460.166353]  ? kthread_create_on_node+0x70/0x70
> > [ 9460.166360]  ret_from_fork+0x25/0x30
> > [ 9460.166371] INFO: task dmcrypt_write:254 blocked for more than 120
> > seconds. [ 9460.166376]       Not tainted 4.12.0-pf7 #1
> > [ 9460.166381] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disab=
les
> > this message.
> > [ 9460.166386] dmcrypt_write   D    0   254      2 0x00000000
> > [ 9460.166492] Call Trace:
> > [ 9460.166501]  __schedule+0x6e7/0xcd0
> > [ 9460.166511]  schedule+0x3d/0xd0
> > [ 9460.166522]  md_write_start+0xe3/0x270 [md_mod]
> > [ 9460.166529]  ? wake_bit_function+0x60/0x60
> > [ 9460.166538]  raid10_make_request+0x3f/0x140 [raid10]
> > [ 9460.166549]  md_make_request+0xa9/0x2a0 [md_mod]
> > [ 9460.166557]  ? __schedule+0x6ef/0xcd0
> > [ 9460.166567]  generic_make_request+0x11e/0x2f0
> > [ 9460.166578]  dmcrypt_write+0x22d/0x250 [dm_crypt]
> > [ 9460.166586]  ? dmcrypt_write+0x22d/0x250 [dm_crypt]
> > [ 9460.166596]  ? wake_up_q+0x80/0x80
> > [ 9460.166605]  kthread+0x124/0x140
> > [ 9460.166613]  ? kthread+0x124/0x140
> > [ 9460.166621]  ? crypt_iv_essiv_dtr+0x70/0x70 [dm_crypt]
> > [ 9460.166628]  ? kthread_create_on_node+0x70/0x70
> > [ 9460.166635]  ret_from_fork+0x25/0x30
> > [ 9460.166677] INFO: task konversation:7110 blocked for more than 120
> > seconds. [ 9460.166683]       Not tainted 4.12.0-pf7 #1
> > [ 9460.166687] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disab=
les
> > this message.
> > [ 9460.166693] konversation    D    0  7110   6972 0x00000000
> > [ 9460.166700] Call Trace:
> > [ 9460.166709]  __schedule+0x6e7/0xcd0
> > [ 9460.166719]  schedule+0x3d/0xd0
> > [ 9460.166824]  io_schedule+0x16/0x40
> > [ 9460.166833]  wait_on_page_bit+0xeb/0x130
> > [ 9460.166841]  ? page_cache_tree_insert+0xc0/0xc0
> > [ 9460.166882]  prepare_pages+0x1b5/0x1d0 [btrfs]
> > [ 9460.166915]  __btrfs_buffered_write+0x267/0x6d0 [btrfs]
> > [ 9460.166948]  btrfs_file_write_iter+0x1c1/0x500 [btrfs]
> > [ 9460.166956]  ? cp_new_stat+0x152/0x180
> > [ 9460.166966]  __vfs_write+0xe4/0x140
> > [ 9460.166975]  vfs_write+0xb1/0x1a0
> > [ 9460.166984]  SyS_write+0x55/0xc0
> > [ 9460.166994]  entry_SYSCALL_64_fastpath+0x1a/0xa5
> > [ 9460.167001] RIP: 0033:0x7fd020f09c0d
> > [ 9460.167006] RSP: 002b:00007ffe27e70360 EFLAGS: 00000293 ORIG_RAX:
> > 0000000000000001
> > [ 9460.167013] RAX: ffffffffffffffda RBX: 0000000003178840 RCX:
> > 00007fd020f09c0d
> > [ 9460.167019] RDX: 000000000000007d RSI: 0000000003241598 RDI:
> > 000000000000002b
> > [ 9460.167024] RBP: 00007fd0211c72a0 R08: 00007fd021a55010 R09:
> > 0000000000000030
> > [ 9460.167029] R10: 00007fd0211caad8 R11: 0000000000000293 R12:
> > 0000000000000000
> > [ 9460.167034] R13: 00000000013b4cef R14: 0000000000000400 R15:
> > 0000000000000001
> > [ 9460.167075] INFO: task akonadi_imap_re:7363 blocked for more than 120
> > seconds.
> > [ 9460.167080]       Not tainted 4.12.0-pf7 #1
> > [ 9460.167084] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disab=
les
> > this message.
> > [ 9460.167089] akonadi_imap_re D    0  7363   7107 0x00000000
> > [ 9460.167096] Call Trace:
> > [ 9460.167105]  __schedule+0x6e7/0xcd0
> > [ 9460.167114]  schedule+0x3d/0xd0
> > [ 9460.167149]  wait_for_writer+0xb1/0xe0 [btrfs]
> > [ 9460.167157]  ? wake_bit_function+0x60/0x60
> > [ 9460.167190]  btrfs_sync_log+0xe2/0xad0 [btrfs]
> > [ 9460.167201]  ? dput.part.24+0x51/0x1d0
> > [ 9460.167210]  ? dput+0x13/0x20
> > [ 9460.167242]  ? btrfs_log_dentry_safe+0x6a/0x80 [btrfs]
> > [ 9460.167275]  btrfs_sync_file+0x2f4/0x3f0 [btrfs]
> > [ 9460.167302]  ? btrfs_sync_file+0x2f4/0x3f0 [btrfs]
> > [ 9460.167313]  vfs_fsync_range+0x4b/0xb0
> > [ 9460.167320]  do_fsync+0x3d/0x70
> > [ 9460.167327]  SyS_fdatasync+0x13/0x20
> > [ 9460.167336]  entry_SYSCALL_64_fastpath+0x1a/0xa5
> > [ 9460.167342] RIP: 0033:0x7fcdf0d7522d
> > [ 9460.167348] RSP: 002b:00007ffdcb64e9a0 EFLAGS: 00000293 ORIG_RAX:
> > 000000000000004b
> > [ 9460.167355] RAX: ffffffffffffffda RBX: 0000007b8c7c9f80 RCX:
> > 00007fcdf0d7522d
> > [ 9460.167361] RDX: 0000000000000023 RSI: 0000007b8c7ca228 RDI:
> > 0000000000000010
> > [ 9460.167366] RBP: 0000000000000001 R08: 0000007b8c7c9270 R09:
> > 000000000000002f
> > [ 9460.167371] R10: 0000007b8c7c9830 R11: 0000000000000293 R12:
> > 0000007b8c7b88f0
> > [ 9460.167376] R13: 0000000000000000 R14: 0000000000000010 R15:
> > 0000007b8c7b66b0
> > [ 9460.167387] INFO: task akonadi_maildis:7366 blocked for more than 120
> > seconds.
> > [ 9460.167492]       Not tainted 4.12.0-pf7 #1
> > [ 9460.167496] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disab=
les
> > this message.
> > [ 9460.167501] akonadi_maildis D    0  7366   7107 0x00000000
> > [ 9460.167507] Call Trace:
> > [ 9460.167516]  __schedule+0x6e7/0xcd0
> > [ 9460.167525]  schedule+0x3d/0xd0
> > [ 9460.167557]  wait_log_commit+0xd6/0x100 [btrfs]
> > [ 9460.167564]  ? wake_bit_function+0x60/0x60
> > [ 9460.167593]  btrfs_sync_log+0x13e/0xad0 [btrfs]
> > [ 9460.167603]  ? dput.part.24+0x51/0x1d0
> > [ 9460.167611]  ? dput+0x13/0x20
> > [ 9460.167640]  ? btrfs_log_dentry_safe+0x6a/0x80 [btrfs]
> > [ 9460.167670]  btrfs_sync_file+0x2f4/0x3f0 [btrfs]
> > [ 9460.167696]  ? btrfs_sync_file+0x2f4/0x3f0 [btrfs]
> > [ 9460.167705]  vfs_fsync_range+0x4b/0xb0
> > [ 9460.167712]  do_fsync+0x3d/0x70
> > [ 9460.167718]  SyS_fdatasync+0x13/0x20
> > [ 9460.167727]  entry_SYSCALL_64_fastpath+0x1a/0xa5
> > [ 9460.167733] RIP: 0033:0x7ff91da0822d
> > [ 9460.167737] RSP: 002b:00007ffdbded6fb0 EFLAGS: 00000293 ORIG_RAX:
> > 000000000000004b
> > [ 9460.167744] RAX: ffffffffffffffda RBX: 000000841e8cc480 RCX:
> > 00007ff91da0822d
> > [ 9460.167749] RDX: 0000000000000028 RSI: 000000841e902608 RDI:
> > 000000000000000f
> > [ 9460.167754] RBP: 0000000000000001 R08: 000000841e8aff00 R09:
> > 000000000000002f
> > [ 9460.167760] R10: 000000841e91a1d0 R11: 0000000000000293 R12:
> > 000000841e910cc0
> > [ 9460.167764] R13: 0000000000000000 R14: 000000000000000f R15:
> > 000000841e9165c0
> > [ 9460.167786] INFO: task chromium:7600 blocked for more than 120 secon=
ds.
> > [ 9460.167791]       Not tainted 4.12.0-pf7 #1
> > [ 9460.167796] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disab=
les
> > this message.
> > [ 9460.167800] chromium        D    0  7600   7020 0x00000000
> > [ 9460.167807] Call Trace:
> > [ 9460.167815]  __schedule+0x6e7/0xcd0
> > [ 9460.167824]  schedule+0x3d/0xd0
> > [ 9460.167831]  io_schedule+0x16/0x40
> > [ 9460.167838]  wait_on_page_bit+0xeb/0x130
> > [ 9460.167847]  ? page_cache_tree_insert+0xc0/0xc0
> > [ 9460.167879]  btrfs_page_mkwrite+0x1bf/0x400 [btrfs]
> > [ 9460.167889]  do_page_mkwrite+0x31/0x90
> > [ 9460.167896]  ? current_time+0x38/0x70
> > [ 9460.167905]  do_wp_page+0x200/0x4b0
> > [ 9460.167911]  ? file_update_time+0x60/0x110
> > [ 9460.167920]  __handle_mm_fault+0x832/0xd50
> > [ 9460.167930]  handle_mm_fault+0xde/0x220
> > [ 9460.167938]  __do_page_fault+0x24d/0x510
> > [ 9460.167946]  do_page_fault+0x22/0x30
> > [ 9460.167954]  page_fault+0x28/0x30
> > [ 9460.167959] RIP: 0033:0x64de23cd9c
> > [ 9460.167964] RSP: 002b:00007ffdfd4ad4c0 EFLAGS: 00010202
> > [ 9460.167970] RAX: 00007f80a51b9d58 RBX: 0000398cef048700 RCX:
> > 0000398ce8da6510
> > [ 9460.167982] RDX: 0000000000000006 RSI: 0000000000000000 RDI:
> > 0000398cef048700
> > [ 9460.167988] RBP: 0000000000000005 R08: 0000000000000000 R09:
> > 0000000000000000
> > [ 9460.167993] R10: 00007ffdfd4acdc0 R11: 0000000000000000 R12:
> > 0000000000000001
> > [ 9460.168000] R13: 0000000000000005 R14: 00007ffdfd4ad908 R15:
> > 0000000000000000
> > [ 9460.168014] INFO: task BrowserBlocking:7639 blocked for more than 120
> > seconds.
> > [ 9460.168019]       Not tainted 4.12.0-pf7 #1
> > [ 9460.168024] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disab=
les
> > this message.
> > [ 9460.168028] BrowserBlocking D    0  7639   7020 0x00000000
> > [ 9460.168035] Call Trace:
> > [ 9460.168044]  __schedule+0x6e7/0xcd0
> > [ 9460.168054]  schedule+0x3d/0xd0
> > [ 9460.168061]  io_schedule+0x16/0x40
> > [ 9460.168068]  wait_on_page_bit_common+0xe3/0x180
> > [ 9460.168076]  ? page_cache_tree_insert+0xc0/0xc0
> > [ 9460.168083]  __filemap_fdatawait_range+0x12a/0x1a0
> > [ 9460.168093]  filemap_fdatawait_range+0x14/0x30
> > [ 9460.168128]  btrfs_wait_ordered_range+0x6b/0x110 [btrfs]
> > [ 9460.168157]  ? btrfs_fdatawrite_range+0x20/0x50 [btrfs]
> > [ 9460.168186]  btrfs_sync_file+0x17c/0x3f0 [btrfs]
> > [ 9460.168195]  vfs_fsync_range+0x4b/0xb0
> > [ 9460.168202]  do_fsync+0x3d/0x70
> > [ 9460.168209]  SyS_fdatasync+0x13/0x20
> > [ 9460.168218]  entry_SYSCALL_64_fastpath+0x1a/0xa5
> > [ 9460.168223] RIP: 0033:0x7f80b8fcd22d
> > [ 9460.168228] RSP: 002b:00007f808c8b7680 EFLAGS: 00000293 ORIG_RAX:
> > 000000000000004b
> > [ 9460.168235] RAX: ffffffffffffffda RBX: 00007f808c8b7670 RCX:
> > 00007f80b8fcd22d
> > [ 9460.168240] RDX: 00000000000019bc RSI: 0000398cef877800 RDI:
> > 0000000000000119
> > [ 9460.168246] RBP: 0000000000000119 R08: 0000000000000037 R09:
> > 0000398ce88693c0
> > [ 9460.168251] R10: 0000000000000000 R11: 0000000000000293 R12:
> > 00007f808c8b77d8
> > [ 9460.168257] R13: 0000398ceb6cf820 R14: 00000000000019bc R15:
> > 0000398cef877800
> > [ 9460.168267] INFO: task Chrome_SyncThre:7867 blocked for more than 120
> > seconds.
> > [ 9460.168272]       Not tainted 4.12.0-pf7 #1
> > [ 9460.168277] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disab=
les
> > this message.
> > [ 9460.168282] Chrome_SyncThre D    0  7867   7020 0x00000000
> > [ 9460.168289] Call Trace:
> > [ 9460.168297]  __schedule+0x6e7/0xcd0
> > [ 9460.168306]  schedule+0x3d/0xd0
> > [ 9460.168338]  wait_ordered_extents.isra.22.constprop.26+0x354/0x3d0
> > [btrfs] [ 9460.168348]  ? wake_bit_function+0x60/0x60
> > [ 9460.168377]  btrfs_log_changed_extents+0x28a/0x620 [btrfs]
> > [ 9460.168412]  ? release_extent_buffer+0x98/0xb0 [btrfs]
> > [ 9460.168444]  btrfs_log_inode+0x97e/0x1140 [btrfs]
> > [ 9460.168668]  btrfs_log_inode_parent+0x277/0xa30 [btrfs]
> > [ 9460.168676]  ? touch_atime+0xc1/0xd0
> > [ 9460.168686]  ? refcount_inc+0x9/0x30
> > [ 9460.168719]  ? join_transaction+0x122/0x450 [btrfs]
> > [ 9460.168750]  btrfs_log_dentry_safe+0x60/0x80 [btrfs]
> > [ 9460.168779]  btrfs_sync_file+0x2b3/0x3f0 [btrfs]
> > [ 9460.168787]  vfs_fsync_range+0x4b/0xb0
> > [ 9460.168794]  do_fsync+0x3d/0x70
> > [ 9460.168801]  SyS_fdatasync+0x13/0x20
> > [ 9460.168810]  entry_SYSCALL_64_fastpath+0x1a/0xa5
> > [ 9460.168815] RIP: 0033:0x7f80b8fcd22d
> > [ 9460.168819] RSP: 002b:00007f80804e1720 EFLAGS: 00000293 ORIG_RAX:
> > 000000000000004b
> > [ 9460.168826] RAX: ffffffffffffffda RBX: 0000000000008000 RCX:
> > 00007f80b8fcd22d
> > [ 9460.168830] RDX: 0000000000000001 RSI: 0000000000000002 RDI:
> > 00000000000000fb
> > [ 9460.168835] RBP: 0000398ce9e33000 R08: 0000398ced562800 R09:
> > 0000000000000001
> > [ 9460.168840] R10: 0000000000018400 R11: 0000000000000293 R12:
> > 00000000004b0000
> > [ 9460.168845] R13: 0000398ceac2ac78 R14: 0000398ce9e3b038 R15:
> > 0000398ceb9a1048
> > [ 9460.168854] INFO: task BrowserBlocking:8011 blocked for more than 120
> > seconds.
> > [ 9460.168858]       Not tainted 4.12.0-pf7 #1
> > [ 9460.168863] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disab=
les
> > this message.
> > [ 9460.168867] BrowserBlocking D    0  8011   7020 0x00000000
> > [ 9460.168873] Call Trace:
> > [ 9460.168882]  __schedule+0x6e7/0xcd0
> > [ 9460.168892]  schedule+0x3d/0xd0
> > [ 9460.168898]  io_schedule+0x16/0x40
> > [ 9460.168905]  wait_on_page_bit_common+0xe3/0x180
> > [ 9460.168912]  ? page_cache_tree_insert+0xc0/0xc0
> > [ 9460.168919]  __filemap_fdatawait_range+0x12a/0x1a0
> > [ 9460.168929]  filemap_fdatawait_range+0x14/0x30
> > [ 9460.168961]  btrfs_wait_ordered_range+0x6b/0x110 [btrfs]
> > [ 9460.168989]  ? btrfs_fdatawrite_range+0x20/0x50 [btrfs]
> > [ 9460.169015]  btrfs_sync_file+0x17c/0x3f0 [btrfs]
> > [ 9460.169025]  vfs_fsync_range+0x4b/0xb0
> > [ 9460.169033]  do_fsync+0x3d/0x70
> > [ 9460.169040]  SyS_fdatasync+0x13/0x20
> > [ 9460.169050]  entry_SYSCALL_64_fastpath+0x1a/0xa5
> > [ 9460.169055] RIP: 0033:0x7f80b8fcd22d
> > [ 9460.169060] RSP: 002b:00007f807d5f1680 EFLAGS: 00000293 ORIG_RAX:
> > 000000000000004b
> > [ 9460.169066] RAX: ffffffffffffffda RBX: 00007f807d5f1670 RCX:
> > 00007f80b8fcd22d
> > [ 9460.169073] RDX: 000000000001f95c RSI: 0000398cece75000 RDI:
> > 000000000000011d
> > [ 9460.169078] RBP: 000000000000011d R08: 000000000000003f R09:
> > 0000398ce8870200
> > [ 9460.169083] R10: 0000000000000000 R11: 0000000000000293 R12:
> > 00007f807d5f17d8
> > [ 9460.169088] R13: 0000398ceafb9160 R14: 000000000001f95c R15:
> > 0000398cece75000
> > [ 9460.169098] INFO: task TaskSchedulerBa:9603 blocked for more than 120
> > seconds.
> > [ 9460.169103]       Not tainted 4.12.0-pf7 #1
> > [ 9460.169108] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disab=
les
> > this message.
> > [ 9460.169113] TaskSchedulerBa D    0  9603   7020 0x00000000
> > [ 9460.169120] Call Trace:
> > [ 9460.169128]  __schedule+0x6e7/0xcd0
> > [ 9460.169138]  schedule+0x3d/0xd0
> > [ 9460.169166]  wait_ordered_extents.isra.22.constprop.26+0x354/0x3d0
> > [btrfs] [ 9460.169175]  ? wake_bit_function+0x60/0x60
> > [ 9460.169204]  btrfs_log_changed_extents+0x28a/0x620 [btrfs]
> > [ 9460.169237]  ? release_extent_buffer+0x98/0xb0 [btrfs]
> > [ 9460.169265]  btrfs_log_inode+0x97e/0x1140 [btrfs]
> > [ 9460.169278]  ? __set_page_dirty_nobuffers+0x117/0x150
> > [ 9460.169310]  ? btree_set_page_dirty+0xe/0x10 [btrfs]
> > [ 9460.169346]  ? set_extent_buffer_dirty+0x7b/0xb0 [btrfs]
> > [ 9460.169378]  btrfs_log_inode_parent+0x277/0xa30 [btrfs]
> > [ 9460.169386]  ? touch_atime+0xc1/0xd0
> > [ 9460.169395]  ? refcount_inc+0x9/0x30
> > [ 9460.169427]  ? join_transaction+0x122/0x450 [btrfs]
> > [ 9460.169457]  btrfs_log_dentry_safe+0x60/0x80 [btrfs]
> > [ 9460.169490]  btrfs_sync_file+0x2b3/0x3f0 [btrfs]
> > [ 9460.169498]  vfs_fsync_range+0x4b/0xb0
> > [ 9460.169505]  do_fsync+0x3d/0x70
> > [ 9460.169512]  SyS_fdatasync+0x13/0x20
> > [ 9460.169522]  entry_SYSCALL_64_fastpath+0x1a/0xa5
> > [ 9460.169527] RIP: 0033:0x7f80b8fcd22d
> > [ 9460.169532] RSP: 002b:00007f80777ea2c0 EFLAGS: 00000293 ORIG_RAX:
> > 000000000000004b
> > [ 9460.169541] RAX: ffffffffffffffda RBX: 0000398ce9546d90 RCX:
> > 00007f80b8fcd22d
> > [ 9460.169546] RDX: 0000000000000001 RSI: 0000000000000002 RDI:
> > 0000000000000117
> > [ 9460.169552] RBP: 0000000000000200 R08: 0000398ced6459c0 R09:
> > 0000000000000001
> > [ 9460.169557] R10: 000000000000e400 R11: 0000000000000293 R12:
> > 0000000000000001
> > [ 9460.169562] R13: 0000000000000015 R14: 0000000000000200 R15:
> > 0000398ce9b50d80
> > =3D=3D=3D
