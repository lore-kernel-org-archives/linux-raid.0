From: Marc Smith <marc.smith@mcc.edu>
Subject: Re: MD Remnants After --stop
Date: Fri, 2 Dec 2016 15:22:20 -0500
Message-ID: <CAHkw+Lfncgkdb8HnbtfGaX0P_KmLmicj3E64JK7oY+1Pv6g_iw@mail.gmail.com>
References: <CAHkw+Lf1SErbGro4bq5MM5LyB-Zqyqi4E90R7c+uAZHv1WgSrA@mail.gmail.com>
 <87fun3ond9.fsf@notabene.neil.brown.name> <CAHkw+LcfszsWDGQJzDaQU0-PsL+8K7t5msW_bLbv+YyDEFmn8Q@mail.gmail.com>
 <87fumlebwo.fsf@notabene.neil.brown.name> <CAHkw+LfN9xaFmmvg653OKh1eH=_kLdhd3Y1QMg3955TePCCtkg@mail.gmail.com>
 <CAHkw+Ldbwkknz6ZqxVpFEE-3z1r7pz1AjamUbZaEPn_uyMn_-w@mail.gmail.com>
 <878tsbcbub.fsf@notabene.neil.brown.name> <CAHkw+Ldv+-uXGCQ+tKfkraZ3VF4V8sk203+Oopm7RvygGQQYGQ@mail.gmail.com>
 <87oa15938i.fsf@notabene.neil.brown.name> <CAHkw+LfJzZoWVnO8kDi+YVV09fas2DveQoChh10wEBZfYin6aQ@mail.gmail.com>
 <8760n8a7k5.fsf@notabene.neil.brown.name> <CAHkw+Lc9YEdbJcRu2bOLU-gex9UYSXB32iRKD8TPS7JpjSOdQA@mail.gmail.com>
 <87shq8743j.fsf@notabene.neil.brown.name> <CAHkw+LfmEyY8CSumeeftOrcYKzbkumHwtfeTuT0DhHZbaxdUSw@mail.gmail.com>
 <87k2bj6zwf.fsf@notabene.neil.brown.name> <CAHkw+LdhCOGn4ZXOrWMQHFK7RvJ9MA=0_uoN+69ZC3SUWsGaCg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAHkw+LdhCOGn4ZXOrWMQHFK7RvJ9MA=0_uoN+69ZC3SUWsGaCg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Finally, I got it! Why is it when I want it to break, it doesn't. =)

I will say, using the modified mdadm that prevents the synthesized
CHANGE event, it seems to not induce the problem as regularly.

Below are the kernel logs after stopping an array:

--snip--
[16438.999544] ------------[ cut here ]------------
[16438.999554] WARNING: CPU: 4 PID: 31175 at drivers/md/md.c:449
mddev_find+0x85/0x205
[16438.999567] Modules linked in: fcst(O) scst_changer(O) scst_tape(O)
scst_vdisk(O) scst_disk(O) ib_srpt(O) iscsi_scst(O) qla2x00tgt(O)
scst(O) qla2xxx bonding mlx5_core bna ib_umad rdma_ucm ib_uverbs
ib_srp iw_nes iw_cxgb4 cxgb4 iw_cxgb3 ib_qib rdmavt mlx4_ib ib_mthca
[16438.999592] CPU: 4 PID: 31175 Comm: mdadm Tainted: G        W  O
4.9.0-rc3-esos.prod #1
[16438.999593] Hardware name: Dell Inc. PowerEdge R710/00NH4P, BIOS
6.4.0 07/23/2013
[16438.999595]  0000000000000000 ffffffff81396464 0000000000000000
0000000000000000
[16438.999598]  ffffffff81065522 0000000000000000 000000000090007e
ffff8803182d4000
[16438.999601]  000000000000007e 0000000000000009 0000000000000001
ffffffff81875356
[16438.999604] Call Trace:
[16438.999612]  [<ffffffff81396464>] ? dump_stack+0x46/0x59
[16438.999618]  [<ffffffff81065522>] ? __warn+0xc8/0xe1
[16438.999620]  [<ffffffff81875356>] ? mddev_find+0x85/0x205
[16438.999623]  [<ffffffff8187978e>] ? md_open+0x10/0x9a
[16438.999628]  [<ffffffff811513c3>] ? __blkdev_get+0xc3/0x345
[16438.999634]  [<ffffffff81151935>] ? blkdev_get_by_dev+0x43/0x43
[16438.999641]  [<ffffffff811517f2>] ? blkdev_get+0x1ad/0x2ad
[16438.999647]  [<ffffffff81132a3f>] ? walk_component+0x36/0x20f
[16438.999653]  [<ffffffff81150501>] ? bdgrab+0xd/0x12
[16438.999659]  [<ffffffff81151935>] ? blkdev_get_by_dev+0x43/0x43
[16438.999666]  [<ffffffff8112664e>] ? do_dentry_open.isra.16+0x1b2/0x28a
[16438.999672]  [<ffffffff81134dd9>] ? path_openat+0xcc7/0xeb1
[16438.999677]  [<ffffffff8113500b>] ? do_filp_open+0x48/0x9e
[16438.999680]  [<ffffffff8113a058>] ? dput+0x21/0x1cb
[16438.999683]  [<ffffffff811274ab>] ? do_sys_open+0x135/0x1bc
[16438.999685]  [<ffffffff811274ab>] ? do_sys_open+0x135/0x1bc
[16438.999690]  [<ffffffff81a7da20>] ? entry_SYSCALL_64_fastpath+0x13/0x94
[16438.999692] ---[ end trace a0868b86aec8f14c ]---
[16438.999743] ------------[ cut here ]------------
[16438.999747] WARNING: CPU: 4 PID: 31175 at drivers/md/md.c:449
md_attr_show+0x61/0x8f
[16438.999748] Modules linked in: fcst(O) scst_changer(O) scst_tape(O)
scst_vdisk(O) scst_disk(O) ib_srpt(O) iscsi_scst(O) qla2x00tgt(O)
scst(O) qla2xxx bonding mlx5_core bna ib_umad rdma_ucm ib_uverbs
ib_srp iw_nes iw_cxgb4 cxgb4 iw_cxgb3 ib_qib rdmavt mlx4_ib ib_mthca
[16438.999763] CPU: 4 PID: 31175 Comm: mdadm Tainted: G        W  O
4.9.0-rc3-esos.prod #1
[16438.999764] Hardware name: Dell Inc. PowerEdge R710/00NH4P, BIOS
6.4.0 07/23/2013
[16438.999765]  0000000000000000 ffffffff81396464 0000000000000000
0000000000000000
[16438.999768]  ffffffff81065522 ffff8803182d4048 ffff8803182d4000
ffffffff8209fb80
[16438.999771]  ffff8803182fc000 ffffc9000ff17f30 ffff8805c7871998
ffffffff818792a0
[16438.999774] Call Trace:
[16438.999777]  [<ffffffff81396464>] ? dump_stack+0x46/0x59
[16438.999780]  [<ffffffff81065522>] ? __warn+0xc8/0xe1
[16438.999782]  [<ffffffff818792a0>] ? md_attr_show+0x61/0x8f
[16438.999787]  [<ffffffff811843ea>] ? sysfs_kf_read+0x61/0x97
[16438.999789]  [<ffffffff81183a52>] ? kernfs_fop_read+0xdc/0x13e
[16438.999792]  [<ffffffff811279a2>] ? __vfs_read+0x1c/0xe2
[16438.999795]  [<ffffffff811840ca>] ? kernfs_iop_get_link+0x14b/0x17b
[16438.999798]  [<ffffffff811283df>] ? vfs_read+0x98/0x11b
[16438.999800]  [<ffffffff811294d2>] ? SyS_read+0x48/0x81
[16438.999803]  [<ffffffff81a7da20>] ? entry_SYSCALL_64_fastpath+0x13/0x94
[16438.999804] ---[ end trace a0868b86aec8f14d ]---
[16438.999806] ------------[ cut here ]------------
[16438.999809] WARNING: CPU: 4 PID: 31175 at drivers/md/md.c:458
mddev_put+0x18/0x16b
[16438.999809] Modules linked in: fcst(O) scst_changer(O) scst_tape(O)
scst_vdisk(O) scst_disk(O) ib_srpt(O) iscsi_scst(O) qla2x00tgt(O)
scst(O) qla2xxx bonding mlx5_core bna ib_umad rdma_ucm ib_uverbs
ib_srp iw_nes iw_cxgb4 cxgb4 iw_cxgb3 ib_qib rdmavt mlx4_ib ib_mthca
[16438.999825] CPU: 4 PID: 31175 Comm: mdadm Tainted: G        W  O
4.9.0-rc3-esos.prod #1
[16438.999826] Hardware name: Dell Inc. PowerEdge R710/00NH4P, BIOS
6.4.0 07/23/2013
[16438.999827]  0000000000000000 ffffffff81396464 0000000000000000
0000000000000000
[16438.999830]  ffffffff81065522 ffff8803182d4000 ffff8803182d4000
ffffffff8209fb80
[16438.999833]  ffff8803182fc000 ffffc9000ff17f30 ffff8805c7871998
ffffffff818781b3
[16438.999836] Call Trace:
[16438.999838]  [<ffffffff81396464>] ? dump_stack+0x46/0x59
[16438.999840]  [<ffffffff81065522>] ? __warn+0xc8/0xe1
[16438.999843]  [<ffffffff818781b3>] ? mddev_put+0x18/0x16b
[16438.999845]  [<ffffffff818792c4>] ? md_attr_show+0x85/0x8f
[16438.999847]  [<ffffffff811843ea>] ? sysfs_kf_read+0x61/0x97
[16438.999850]  [<ffffffff81183a52>] ? kernfs_fop_read+0xdc/0x13e
[16438.999852]  [<ffffffff811279a2>] ? __vfs_read+0x1c/0xe2
[16438.999855]  [<ffffffff811840ca>] ? kernfs_iop_get_link+0x14b/0x17b
[16438.999857]  [<ffffffff811283df>] ? vfs_read+0x98/0x11b
[16438.999860]  [<ffffffff811294d2>] ? SyS_read+0x48/0x81
[16438.999862]  [<ffffffff81a7da20>] ? entry_SYSCALL_64_fastpath+0x13/0x94
[16438.999864] ---[ end trace a0868b86aec8f14e ]---
[16438.999864] mddev->active = 2
[16438.999884] ------------[ cut here ]------------
[16438.999887] WARNING: CPU: 4 PID: 31175 at drivers/md/md.c:449
md_attr_show+0x61/0x8f
[16438.999887] Modules linked in: fcst(O) scst_changer(O) scst_tape(O)
scst_vdisk(O) scst_disk(O) ib_srpt(O) iscsi_scst(O) qla2x00tgt(O)
scst(O) qla2xxx bonding mlx5_core bna ib_umad rdma_ucm ib_uverbs
ib_srp iw_nes iw_cxgb4 cxgb4 iw_cxgb3 ib_qib rdmavt mlx4_ib ib_mthca
[16438.999902] CPU: 4 PID: 31175 Comm: mdadm Tainted: G        W  O
4.9.0-rc3-esos.prod #1
[16438.999903] Hardware name: Dell Inc. PowerEdge R710/00NH4P, BIOS
6.4.0 07/23/2013
[16438.999904]  0000000000000000 ffffffff81396464 0000000000000000
0000000000000000
[16438.999907]  ffffffff81065522 ffff8803182d4048 ffff8803182d4000
ffffffff8209fd10
[16438.999910]  ffff8805c8def000 ffff8805c96b7e00 0000000000000001
ffffffff818792a0
[16438.999913] Call Trace:
[16438.999916]  [<ffffffff81396464>] ? dump_stack+0x46/0x59
[16438.999918]  [<ffffffff81065522>] ? __warn+0xc8/0xe1
[16438.999920]  [<ffffffff818792a0>] ? md_attr_show+0x61/0x8f
[16438.999923]  [<ffffffff811844cf>] ? sysfs_kf_seq_show+0x7a/0xc4
[16438.999927]  [<ffffffff81143d99>] ? seq_read+0x16c/0x323
[16438.999929]  [<ffffffff811279a2>] ? __vfs_read+0x1c/0xe2
[16438.999931]  [<ffffffff8113a067>] ? dput+0x30/0x1cb
[16438.999934]  [<ffffffff811283df>] ? vfs_read+0x98/0x11b
[16438.999936]  [<ffffffff811294d2>] ? SyS_read+0x48/0x81
[16438.999939]  [<ffffffff81a7da20>] ? entry_SYSCALL_64_fastpath+0x13/0x94
[16438.999941] ---[ end trace a0868b86aec8f14f ]---
[16438.999942] ------------[ cut here ]------------
[16438.999945] WARNING: CPU: 4 PID: 31175 at drivers/md/md.c:458
mddev_put+0x18/0x16b
[16438.999952] Modules linked in:
[16438.999958]  fcst(O) scst_changer(O) scst_tape(O) scst_vdisk(O)
scst_disk(O) ib_srpt(O) iscsi_scst(O) qla2x00tgt(O) scst(O) qla2xxx
bonding mlx5_core bna ib_umad rdma_ucm ib_uverbs ib_srp iw_nes
iw_cxgb4 cxgb4 iw_cxgb3 ib_qib rdmavt mlx4_ib ib_mthca
[16439.000060] CPU: 4 PID: 31175 Comm: mdadm Tainted: G        W  O
4.9.0-rc3-esos.prod #1
[16439.000061] Hardware name: Dell Inc. PowerEdge R710/00NH4P, BIOS
6.4.0 07/23/2013
[16439.000061]  0000000000000000 ffffffff81396464 0000000000000000
0000000000000000
[16439.000064]  ffffffff81065522 ffff8803182d4000 ffff8803182d4000
ffffffff8209fd10
[16439.000067]  ffff8805c8def000 ffff8805c96b7e00 0000000000000001
ffffffff818781b3
[16439.000070] Call Trace:
[16439.000073]  [<ffffffff81396464>] ? dump_stack+0x46/0x59
[16439.000075]  [<ffffffff81065522>] ? __warn+0xc8/0xe1
[16439.000077]  [<ffffffff818781b3>] ? mddev_put+0x18/0x16b
[16439.000080]  [<ffffffff818792c4>] ? md_attr_show+0x85/0x8f
[16439.000082]  [<ffffffff811844cf>] ? sysfs_kf_seq_show+0x7a/0xc4
[16439.000085]  [<ffffffff81143d99>] ? seq_read+0x16c/0x323
[16439.000087]  [<ffffffff811279a2>] ? __vfs_read+0x1c/0xe2
[16439.000089]  [<ffffffff8113a067>] ? dput+0x30/0x1cb
[16439.000092]  [<ffffffff811283df>] ? vfs_read+0x98/0x11b
[16439.000095]  [<ffffffff811294d2>] ? SyS_read+0x48/0x81
[16439.000097]  [<ffffffff81a7da20>] ? entry_SYSCALL_64_fastpath+0x13/0x94
[16439.000099] ---[ end trace a0868b86aec8f150 ]---
[16439.000099] mddev->active = 2
[16439.000111] ------------[ cut here ]------------
[16439.000114] WARNING: CPU: 4 PID: 31175 at drivers/md/md.c:449
md_attr_show+0x61/0x8f
[16439.000115] Modules linked in: fcst(O) scst_changer(O) scst_tape(O)
scst_vdisk(O) scst_disk(O) ib_srpt(O) iscsi_scst(O) qla2x00tgt(O)
scst(O) qla2xxx bonding mlx5_core bna ib_umad rdma_ucm ib_uverbs
ib_srp iw_nes iw_cxgb4 cxgb4 iw_cxgb3 ib_qib rdmavt mlx4_ib ib_mthca
[16439.000130] CPU: 4 PID: 31175 Comm: mdadm Tainted: G        W  O
4.9.0-rc3-esos.prod #1
[16439.000131] Hardware name: Dell Inc. PowerEdge R710/00NH4P, BIOS
6.4.0 07/23/2013
[16439.000132]  0000000000000000 ffffffff81396464 0000000000000000
0000000000000000
[16439.000135]  ffffffff81065522 ffff8803182d4048 ffff8803182d4000
ffffffff8209fba0
[16439.000138]  ffff8805c8def000 ffff8805c96b7100 0000000000000001
ffffffff818792a0
[16439.000141] Call Trace:
[16439.000144]  [<ffffffff81396464>] ? dump_stack+0x46/0x59
[16439.000146]  [<ffffffff81065522>] ? __warn+0xc8/0xe1
[16439.000148]  [<ffffffff818792a0>] ? md_attr_show+0x61/0x8f
[16439.000151]  [<ffffffff811844cf>] ? sysfs_kf_seq_show+0x7a/0xc4
[16439.000153]  [<ffffffff81143d99>] ? seq_read+0x16c/0x323
[16439.000156]  [<ffffffff811279a2>] ? __vfs_read+0x1c/0xe2
[16439.000158]  [<ffffffff8113a166>] ? dput+0x12f/0x1cb
[16439.000161]  [<ffffffff811283df>] ? vfs_read+0x98/0x11b
[16439.000163]  [<ffffffff811294d2>] ? SyS_read+0x48/0x81
[16439.000166]  [<ffffffff81a7da20>] ? entry_SYSCALL_64_fastpath+0x13/0x94
[16439.000167] ---[ end trace a0868b86aec8f151 ]---
[16439.000169] ------------[ cut here ]------------
[16439.000171] WARNING: CPU: 4 PID: 31175 at drivers/md/md.c:458
mddev_put+0x18/0x16b
[16439.000172] Modules linked in: fcst(O) scst_changer(O) scst_tape(O)
scst_vdisk(O) scst_disk(O) ib_srpt(O) iscsi_scst(O) qla2x00tgt(O)
scst(O) qla2xxx bonding mlx5_core bna ib_umad rdma_ucm ib_uverbs
ib_srp iw_nes iw_cxgb4 cxgb4 iw_cxgb3 ib_qib rdmavt mlx4_ib ib_mthca
[16439.000187] CPU: 4 PID: 31175 Comm: mdadm Tainted: G        W  O
4.9.0-rc3-esos.prod #1
[16439.000188] Hardware name: Dell Inc. PowerEdge R710/00NH4P, BIOS
6.4.0 07/23/2013
[16439.000189]  0000000000000000 ffffffff81396464 0000000000000000
0000000000000000
[16439.000192]  ffffffff81065522 ffff8803182d4000 ffff8803182d4000
ffffffff8209fba0
[16439.000195]  ffff8805c8def000 ffff8805c96b7100 0000000000000001
ffffffff818781b3
[16439.000198] Call Trace:
[16439.000201]  [<ffffffff81396464>] ? dump_stack+0x46/0x59
[16439.000203]  [<ffffffff81065522>] ? __warn+0xc8/0xe1
[16439.000205]  [<ffffffff818781b3>] ? mddev_put+0x18/0x16b
[16439.000207]  [<ffffffff818792c4>] ? md_attr_show+0x85/0x8f
[16439.000210]  [<ffffffff811844cf>] ? sysfs_kf_seq_show+0x7a/0xc4
[16439.000212]  [<ffffffff81143d99>] ? seq_read+0x16c/0x323
[16439.000215]  [<ffffffff811279a2>] ? __vfs_read+0x1c/0xe2
[16439.000217]  [<ffffffff8113a166>] ? dput+0x12f/0x1cb
[16439.000219]  [<ffffffff811283df>] ? vfs_read+0x98/0x11b
[16439.000222]  [<ffffffff811294d2>] ? SyS_read+0x48/0x81
[16439.000224]  [<ffffffff81a7da20>] ? entry_SYSCALL_64_fastpath+0x13/0x94
[16439.000226] ---[ end trace a0868b86aec8f152 ]---
[16439.000227] mddev->active = 2
[16439.000236] ------------[ cut here ]------------
[16439.000239] WARNING: CPU: 4 PID: 31175 at drivers/md/md.c:458
mddev_put+0x18/0x16b
[16439.000240] Modules linked in: fcst(O) scst_changer(O) scst_tape(O)
scst_vdisk(O) scst_disk(O) ib_srpt(O) iscsi_scst(O) qla2x00tgt(O)
scst(O) qla2xxx bonding mlx5_core bna ib_umad rdma_ucm ib_uverbs
ib_srp iw_nes iw_cxgb4 cxgb4 iw_cxgb3 ib_qib rdmavt mlx4_ib ib_mthca
[16439.000255] CPU: 4 PID: 31175 Comm: mdadm Tainted: G        W  O
4.9.0-rc3-esos.prod #1
[16439.000256] Hardware name: Dell Inc. PowerEdge R710/00NH4P, BIOS
6.4.0 07/23/2013
[16439.000257]  0000000000000000 ffffffff81396464 0000000000000000
0000000000000000
[16439.000260]  ffffffff81065522 ffff8803182d4000 ffff880622d20aa0
ffff8803182ae800
[16439.000263]  ffff880622d209d8 ffff880622d20b20 ffff88030f854ac8
ffffffff818781b3
[16439.000266] Call Trace:
[16439.000269]  [<ffffffff81396464>] ? dump_stack+0x46/0x59
[16439.000271]  [<ffffffff81065522>] ? __warn+0xc8/0xe1
[16439.000273]  [<ffffffff818781b3>] ? mddev_put+0x18/0x16b
[16439.000276]  [<ffffffff81151258>] ? __blkdev_put+0x11c/0x1c4
[16439.000278]  [<ffffffff81151aff>] ? blkdev_close+0x1c/0x1f
[16439.000280]  [<ffffffff81129c69>] ? __fput+0xd8/0x18a
[16439.000285]  [<ffffffff8107990c>] ? task_work_run+0x5d/0x73
[16439.000288]  [<ffffffff81001048>] ? exit_to_usermode_loop+0x48/0x5d
[16439.000290]  [<ffffffff8100135c>] ? syscall_return_slowpath+0x3a/0x4c
[16439.000292]  [<ffffffff81a7da9f>] ? entry_SYSCALL_64_fastpath+0x92/0x94
[16439.000294] ---[ end trace a0868b86aec8f153 ]---
[16439.000295] mddev->active = 1
[16439.000296] rd=2 empty=0 ctime=1480694644 hold=0
[16439.000302] ------------[ cut here ]------------
[16439.000305] WARNING: CPU: 4 PID: 31175 at drivers/md/md.c:449
mddev_find+0x85/0x205
[16439.000305] Modules linked in: fcst(O) scst_changer(O) scst_tape(O)
scst_vdisk(O) scst_disk(O) ib_srpt(O) iscsi_scst(O) qla2x00tgt(O)
scst(O) qla2xxx bonding mlx5_core bna ib_umad rdma_ucm ib_uverbs
ib_srp iw_nes iw_cxgb4 cxgb4 iw_cxgb3 ib_qib rdmavt mlx4_ib ib_mthca
[16439.000321] CPU: 4 PID: 31175 Comm: mdadm Tainted: G        W  O
4.9.0-rc3-esos.prod #1
[16439.000322] Hardware name: Dell Inc. PowerEdge R710/00NH4P, BIOS
6.4.0 07/23/2013
[16439.000323]  0000000000000000 ffffffff81396464 0000000000000000
0000000000000000
[16439.000326]  ffffffff81065522 0000000000000000 000000000090007e
ffff8803182d4000
[16439.000329]  000000000000007e 0000000000000009 0000000000000001
ffffffff81875356
[16439.000332] Call Trace:
[16439.000334]  [<ffffffff81396464>] ? dump_stack+0x46/0x59
[16439.000336]  [<ffffffff81065522>] ? __warn+0xc8/0xe1
[16439.000338]  [<ffffffff81875356>] ? mddev_find+0x85/0x205
[16439.000341]  [<ffffffff8187978e>] ? md_open+0x10/0x9a
[16439.000343]  [<ffffffff811513c3>] ? __blkdev_get+0xc3/0x345
[16439.000345]  [<ffffffff811517f2>] ? blkdev_get+0x1ad/0x2ad
[16439.000348]  [<ffffffff81150501>] ? bdgrab+0xd/0x12
[16439.000350]  [<ffffffff81151935>] ? blkdev_get_by_dev+0x43/0x43
[16439.000353]  [<ffffffff8112664e>] ? do_dentry_open.isra.16+0x1b2/0x28a
[16439.000355]  [<ffffffff81134dd9>] ? path_openat+0xcc7/0xeb1
[16439.000359]  [<ffffffff8109b30f>] ? console_unlock+0x254/0x46c
[16439.000362]  [<ffffffff8113500b>] ? do_filp_open+0x48/0x9e
[16439.000364]  [<ffffffff8113a058>] ? dput+0x21/0x1cb
[16439.000367]  [<ffffffff811274ab>] ? do_sys_open+0x135/0x1bc
[16439.000369]  [<ffffffff811274ab>] ? do_sys_open+0x135/0x1bc
[16439.000372]  [<ffffffff81a7da20>] ? entry_SYSCALL_64_fastpath+0x13/0x94
[16439.000374] ---[ end trace a0868b86aec8f154 ]---
[16439.000405] udevd[494]: inotify event: 8 for /dev/md126
[16439.000420] ------------[ cut here ]------------
[16439.000427] WARNING: CPU: 11 PID: 494 at drivers/md/md.c:449
mddev_find+0x85/0x205
[16439.000427] Modules linked in: fcst(O) scst_changer(O) scst_tape(O)
scst_vdisk(O) scst_disk(O) ib_srpt(O) iscsi_scst(O) qla2x00tgt(O)
scst(O) qla2xxx bonding mlx5_core bna ib_umad rdma_ucm ib_uverbs
ib_srp iw_nes iw_cxgb4 cxgb4 iw_cxgb3 ib_qib rdmavt mlx4_ib ib_mthca
[16439.000449] CPU: 11 PID: 494 Comm: udevd Tainted: G        W  O
4.9.0-rc3-esos.prod #1
[16439.000450] Hardware name: Dell Inc. PowerEdge R710/00NH4P, BIOS
6.4.0 07/23/2013
[16439.000452]  0000000000000000 ffffffff81396464 0000000000000000
0000000000000000
[16439.000455]  ffffffff81065522 0000000000000000 000000000090007e
ffff8803182d4000
[16439.000458]  000000000000007e 0000000000000009 0000000000000001
ffffffff81875356
[16439.000461] Call Trace:
[16439.000467]  [<ffffffff81396464>] ? dump_stack+0x46/0x59
[16439.000471]  [<ffffffff81065522>] ? __warn+0xc8/0xe1
[16439.000474]  [<ffffffff81875356>] ? mddev_find+0x85/0x205
[16439.000476]  [<ffffffff8187978e>] ? md_open+0x10/0x9a
[16439.000480]  [<ffffffff81151522>] ? __blkdev_get+0x222/0x345
[16439.000483]  [<ffffffff81151935>] ? blkdev_get_by_dev+0x43/0x43
[16439.000485]  [<ffffffff811517f2>] ? blkdev_get+0x1ad/0x2ad
[16439.000488]  [<ffffffff81132aab>] ? walk_component+0xa2/0x20f
[16439.000490]  [<ffffffff81150501>] ? bdgrab+0xd/0x12
[16439.000493]  [<ffffffff81151935>] ? blkdev_get_by_dev+0x43/0x43
[16439.000496]  [<ffffffff8112664e>] ? do_dentry_open.isra.16+0x1b2/0x28a
[16439.000498]  [<ffffffff81134dd9>] ? path_openat+0xcc7/0xeb1
[16439.000500]  [<ffffffff81132400>] ? lookup_fast+0x1c0/0x267
[16439.000503]  [<ffffffff8113a067>] ? dput+0x30/0x1cb
[16439.000505]  [<ffffffff8113316c>] ? path_lookupat+0xea/0xfe
[16439.000507]  [<ffffffff8113500b>] ? do_filp_open+0x48/0x9e
[16439.000510]  [<ffffffff8113cf32>] ? current_time+0x54/0x5d
[16439.000514]  [<ffffffff811840ca>] ? kernfs_iop_get_link+0x14b/0x17b
[16439.000516]  [<ffffffff811274ab>] ? do_sys_open+0x135/0x1bc
[16439.000518]  [<ffffffff811274ab>] ? do_sys_open+0x135/0x1bc
[16439.000523]  [<ffffffff81a7da20>] ? entry_SYSCALL_64_fastpath+0x13/0x94
[16439.000524] ---[ end trace a0868b86aec8f155 ]---
[16439.009255] md126: detected capacity change from 73340747776 to 0
[16439.009259] md: md126 stopped.
[16439.009419] dlm: d8c5a2a8-4fbe-7f67-ab89-d1834f978d2a: leaving the
lockspace group...
[16439.009424] udevd[494]: device /dev/md126 closed, synthesising 'change'
[16439.009512] udevd[494]: seq 3817 queued, 'offline' 'dlm'
[16439.009709] udevd[494]: seq 3817 forked new worker [31176]
[16439.009762] udevd[494]: seq 3818 queued, 'change' 'block'
[16439.009882] udevd[494]: seq 3818 forked new worker [31177]
[16439.009904] udevd[31176]: seq 3817 running
[16439.009955] udevd[31176]: no db file to read
/run/udev/data/+dlm:d8c5a2a8-4fbe-7f67-ab89-d1834f978d2a: No such file
or directory
[16439.010002] udevd[31176]: passed device to netlink monitor 0xdee2c0
[16439.010005] udevd[31176]: seq 3817 processed
[16439.010255] ------------[ cut here ]------------
[16439.010260] WARNING: CPU: 20 PID: 31177 at drivers/md/md.c:449
md_attr_show+0x61/0x8f
[16439.010261] Modules linked in: fcst(O) scst_changer(O) scst_tape(O)
scst_vdisk(O) scst_disk(O) ib_srpt(O) iscsi_scst(O) qla2x00tgt(O)
scst(O) qla2xxx bonding mlx5_core bna ib_umad rdma_ucm ib_uverbs
ib_srp iw_nes iw_cxgb4 cxgb4 iw_cxgb3 ib_qib rdmavt mlx4_ib ib_mthca
[16439.010280] CPU: 20 PID: 31177 Comm: udevd Tainted: G        W  O
 4.9.0-rc3-esos.prod #1
[16439.010281] Hardware name: Dell Inc. PowerEdge R710/00NH4P, BIOS
6.4.0 07/23/2013
[16439.010282]  0000000000000000 ffffffff81396464 0000000000000000
0000000000000000
[16439.010286]  ffffffff81065522 ffff8803182d4048 ffff8803182d4000
ffffffff8209fb80
[16439.010289]  ffff8806198f8000 ffffc9000f66ff30 ffff8805c95c7ed8
ffffffff818792a0
[16439.010292] Call Trace:
[16439.010296]  [<ffffffff81396464>] ? dump_stack+0x46/0x59
[16439.010299]  [<ffffffff81065522>] ? __warn+0xc8/0xe1
[16439.010301]  [<ffffffff818792a0>] ? md_attr_show+0x61/0x8f
[16439.010304]  [<ffffffff811843ea>] ? sysfs_kf_read+0x61/0x97
[16439.010306]  [<ffffffff81183a52>] ? kernfs_fop_read+0xdc/0x13e
[16439.010309]  [<ffffffff811279a2>] ? __vfs_read+0x1c/0xe2
[16439.010312]  [<ffffffff811283df>] ? vfs_read+0x98/0x11b
[16439.010315]  [<ffffffff811294d2>] ? SyS_read+0x48/0x81
[16439.010318]  [<ffffffff81a7da20>] ? entry_SYSCALL_64_fastpath+0x13/0x94
[16439.010319] ---[ end trace a0868b86aec8f156 ]---
[16439.010321] ------------[ cut here ]------------
[16439.010324] WARNING: CPU: 20 PID: 31177 at drivers/md/md.c:458
mddev_put+0x18/0x16b
[16439.010324] Modules linked in: fcst(O) scst_changer(O) scst_tape(O)
scst_vdisk(O) scst_disk(O) ib_srpt(O) iscsi_scst(O) qla2x00tgt(O)
scst(O) qla2xxx bonding mlx5_core bna ib_umad rdma_ucm ib_uverbs
ib_srp iw_nes iw_cxgb4 cxgb4 iw_cxgb3 ib_qib rdmavt mlx4_ib ib_mthca
[16439.010340] CPU: 20 PID: 31177 Comm: udevd Tainted: G        W  O
 4.9.0-rc3-esos.prod #1
[16439.010341] Hardware name: Dell Inc. PowerEdge R710/00NH4P, BIOS
6.4.0 07/23/2013
[16439.010342]  0000000000000000 ffffffff81396464 0000000000000000
0000000000000000
[16439.010345]  ffffffff81065522 ffff8803182d4000 ffff8803182d4000
ffffffff8209fb80
[16439.010348]  ffff8806198f8000 ffffc9000f66ff30 ffff8805c95c7ed8
ffffffff818781b3
[16439.010351] Call Trace:
[16439.010354]  [<ffffffff81396464>] ? dump_stack+0x46/0x59
[16439.010356]  [<ffffffff81065522>] ? __warn+0xc8/0xe1
[16439.010358]  [<ffffffff818781b3>] ? mddev_put+0x18/0x16b
[16439.010360]  [<ffffffff818792c4>] ? md_attr_show+0x85/0x8f
[16439.010363]  [<ffffffff811843ea>] ? sysfs_kf_read+0x61/0x97
[16439.010365]  [<ffffffff81183a52>] ? kernfs_fop_read+0xdc/0x13e
[16439.010368]  [<ffffffff811279a2>] ? __vfs_read+0x1c/0xe2
[16439.010370]  [<ffffffff811283df>] ? vfs_read+0x98/0x11b
[16439.010373]  [<ffffffff811294d2>] ? SyS_read+0x48/0x81
[16439.010375]  [<ffffffff81a7da20>] ? entry_SYSCALL_64_fastpath+0x13/0x94
[16439.010377] ---[ end trace a0868b86aec8f157 ]---
[16439.010377] mddev->active = 3
[16439.010385] dlm: d8c5a2a8-4fbe-7f67-ab89-d1834f978d2a: group event done 0 0
[16439.010399] ------------[ cut here ]------------
[16439.010402] WARNING: CPU: 20 PID: 31177 at drivers/md/md.c:449
md_attr_show+0x61/0x8f
[16439.010403] Modules linked in: fcst(O) scst_changer(O) scst_tape(O)
scst_vdisk(O) scst_disk(O) ib_srpt(O) iscsi_scst(O) qla2x00tgt(O)
scst(O) qla2xxx bonding mlx5_core bna ib_umad rdma_ucm ib_uverbs
ib_srp iw_nes iw_cxgb4 cxgb4 iw_cxgb3 ib_qib rdmavt mlx4_ib ib_mthca
[16439.010419] CPU: 20 PID: 31177 Comm: udevd Tainted: G        W  O
 4.9.0-rc3-esos.prod #1
[16439.010420] Hardware name: Dell Inc. PowerEdge R710/00NH4P, BIOS
6.4.0 07/23/2013
[16439.010421]  0000000000000000 ffffffff81396464 0000000000000000
0000000000000000
[16439.010424]  ffffffff81065522 ffff8803182d4048 ffff8803182d4000
ffffffff8209fc20
[16439.010426]  ffff8806198f8000 ffffc9000f66ff30 ffff8805c95c7ed8
ffffffff818792a0
[16439.010429] Call Trace:
[16439.010432]  [<ffffffff81396464>] ? dump_stack+0x46/0x59
[16439.010434]  [<ffffffff81065522>] ? __warn+0xc8/0xe1
[16439.010436]  [<ffffffff818792a0>] ? md_attr_show+0x61/0x8f
[16439.010439]  [<ffffffff811843ea>] ? sysfs_kf_read+0x61/0x97
[16439.010441]  [<ffffffff81183a52>] ? kernfs_fop_read+0xdc/0x13e
[16439.010444]  [<ffffffff811279a2>] ? __vfs_read+0x1c/0xe2
[16439.010447]  [<ffffffff811283df>] ? vfs_read+0x98/0x11b
[16439.010449]  [<ffffffff811294d2>] ? SyS_read+0x48/0x81
[16439.010452]  [<ffffffff81a7da20>] ? entry_SYSCALL_64_fastpath+0x13/0x94
[16439.010453] ---[ end trace a0868b86aec8f158 ]---
[16439.010455] ------------[ cut here ]------------
[16439.010457] WARNING: CPU: 20 PID: 31177 at drivers/md/md.c:458
mddev_put+0x18/0x16b
[16439.010458] Modules linked in: fcst(O) scst_changer(O) scst_tape(O)
scst_vdisk(O) scst_disk(O) ib_srpt(O) iscsi_scst(O) qla2x00tgt(O)
scst(O) qla2xxx bonding mlx5_core bna ib_umad rdma_ucm ib_uverbs
ib_srp iw_nes iw_cxgb4 cxgb4 iw_cxgb3 ib_qib rdmavt mlx4_ib ib_mthca
[16439.010473] CPU: 20 PID: 31177 Comm: udevd Tainted: G        W  O
 4.9.0-rc3-esos.prod #1
[16439.010474] Hardware name: Dell Inc. PowerEdge R710/00NH4P, BIOS
6.4.0 07/23/2013
[16439.010475]  0000000000000000 ffffffff81396464 0000000000000000
0000000000000000
[16439.010478]  ffffffff81065522 ffff8803182d4000 ffff8803182d4000
ffffffff8209fc20
[16439.010480]  ffff8806198f8000 ffffc9000f66ff30 ffff8805c95c7ed8
ffffffff818781b3
[16439.010483] Call Trace:
[16439.010486]  [<ffffffff81396464>] ? dump_stack+0x46/0x59
[16439.010488]  [<ffffffff81065522>] ? __warn+0xc8/0xe1
[16439.010491]  [<ffffffff818781b3>] ? mddev_put+0x18/0x16b
[16439.010493]  [<ffffffff818792c4>] ? md_attr_show+0x85/0x8f
[16439.010495]  [<ffffffff811843ea>] ? sysfs_kf_read+0x61/0x97
[16439.010498]  [<ffffffff81183a52>] ? kernfs_fop_read+0xdc/0x13e
[16439.010501]  [<ffffffff811279a2>] ? __vfs_read+0x1c/0xe2
[16439.010503]  [<ffffffff811283df>] ? vfs_read+0x98/0x11b
[16439.010506]  [<ffffffff811294d2>] ? SyS_read+0x48/0x81
[16439.010508]  [<ffffffff81a7da20>] ? entry_SYSCALL_64_fastpath+0x13/0x94
[16439.010510] ---[ end trace a0868b86aec8f159 ]---
[16439.010511] mddev->active = 3
[16439.010600] dlm: d8c5a2a8-4fbe-7f67-ab89-d1834f978d2a:
release_lockspace final free
[16439.010628] md: unbind<dm-2>
[16439.011727] ------------[ cut here ]------------
[16439.011732] WARNING: CPU: 12 PID: 31178 at drivers/md/md.c:449
mddev_find+0x85/0x205
[16439.011733] Modules linked in: fcst(O) scst_changer(O) scst_tape(O)
scst_vdisk(O) scst_disk(O) ib_srpt(O) iscsi_scst(O) qla2x00tgt(O)
scst(O) qla2xxx bonding mlx5_core bna ib_umad rdma_ucm ib_uverbs
ib_srp iw_nes iw_cxgb4 cxgb4 iw_cxgb3 ib_qib rdmavt mlx4_ib ib_mthca
[16439.011751] CPU: 12 PID: 31178 Comm: probe-bcache Tainted: G
W  O    4.9.0-rc3-esos.prod #1
[16439.011752] Hardware name: Dell Inc. PowerEdge R710/00NH4P, BIOS
6.4.0 07/23/2013
[16439.011753]  0000000000000000 ffffffff81396464 0000000000000000
0000000000000000
[16439.011757]  ffffffff81065522 0000000000000000 000000000090007e
ffff8803182d4000
[16439.011760]  000000000000007e 0000000000000009 0000000000000001
ffffffff81875356
[16439.011763] Call Trace:
[16439.011767]  [<ffffffff81396464>] ? dump_stack+0x46/0x59
[16439.011769]  [<ffffffff81065522>] ? __warn+0xc8/0xe1
[16439.011772]  [<ffffffff81875356>] ? mddev_find+0x85/0x205
[16439.011774]  [<ffffffff8187978e>] ? md_open+0x10/0x9a
[16439.011777]  [<ffffffff81151522>] ? __blkdev_get+0x222/0x345
[16439.011779]  [<ffffffff81151935>] ? blkdev_get_by_dev+0x43/0x43
[16439.011781]  [<ffffffff811517f2>] ? blkdev_get+0x1ad/0x2ad
[16439.011784]  [<ffffffff81132aab>] ? walk_component+0xa2/0x20f
[16439.011789]  [<ffffffff810ebf11>] ? get_page_from_freelist+0x58f/0x6dc
[16439.011791]  [<ffffffff81150501>] ? bdgrab+0xd/0x12
[16439.011794]  [<ffffffff81151935>] ? blkdev_get_by_dev+0x43/0x43
[16439.011796]  [<ffffffff8112664e>] ? do_dentry_open.isra.16+0x1b2/0x28a
[16439.011798]  [<ffffffff81134dd9>] ? path_openat+0xcc7/0xeb1
[16439.011801]  [<ffffffff8113500b>] ? do_filp_open+0x48/0x9e
[16439.011806]  [<ffffffff81105e6a>] ? handle_mm_fault+0x607/0xb0e
[16439.011809]  [<ffffffff811274ab>] ? do_sys_open+0x135/0x1bc
[16439.011811]  [<ffffffff811274ab>] ? do_sys_open+0x135/0x1bc
[16439.011814]  [<ffffffff81a7da20>] ? entry_SYSCALL_64_fastpath+0x13/0x94
[16439.011815] ---[ end trace a0868b86aec8f15a ]---
[16439.024630] md: export_rdev(dm-2)
[16439.024689] md: unbind<dm-3>
[16439.035626] md: export_rdev(dm-3)
[16439.035781] ------------[ cut here ]------------
[16439.035786] WARNING: CPU: 11 PID: 31175 at drivers/md/md.c:449
md_seq_next+0x5b/0x93
[16439.035787] Modules linked in: fcst(O) scst_changer(O) scst_tape(O)
scst_vdisk(O) scst_disk(O) ib_srpt(O) iscsi_scst(O) qla2x00tgt(O)
scst(O) qla2xxx bonding mlx5_core bna ib_umad rdma_ucm ib_uverbs
ib_srp iw_nes iw_cxgb4 cxgb4 iw_cxgb3 ib_qib rdmavt mlx4_ib ib_mthca
[16439.035805] CPU: 11 PID: 31175 Comm: mdadm Tainted: G        W  O
 4.9.0-rc3-esos.prod #1
[16439.035806] Hardware name: Dell Inc. PowerEdge R710/00NH4P, BIOS
6.4.0 07/23/2013
[16439.035808]  0000000000000000 ffffffff81396464 0000000000000000
0000000000000000
[16439.035811]  ffffffff81065522 0000000000000001 ffff88061a157000
ffff88061a1573b8
[16439.035814]  ffff8803133adb00 ffff880320a15000 000000000000004b
ffffffff81879329
[16439.035817] Call Trace:
[16439.035821]  [<ffffffff81396464>] ? dump_stack+0x46/0x59
[16439.035823]  [<ffffffff81065522>] ? __warn+0xc8/0xe1
[16439.035826]  [<ffffffff81879329>] ? md_seq_next+0x5b/0x93
[16439.035829]  [<ffffffff81143e60>] ? seq_read+0x233/0x323
[16439.035832]  [<ffffffff81175e07>] ? proc_reg_read+0x3f/0x5d
[16439.035834]  [<ffffffff81175dc8>] ? proc_reg_write+0x5d/0x5d
[16439.035837]  [<ffffffff811279a2>] ? __vfs_read+0x1c/0xe2
[16439.035840]  [<ffffffff8112c69b>] ? SyS_newfstat+0x1f/0x27
[16439.035842]  [<ffffffff811283df>] ? vfs_read+0x98/0x11b
[16439.035845]  [<ffffffff811294d2>] ? SyS_read+0x48/0x81
[16439.035848]  [<ffffffff81a7da20>] ? entry_SYSCALL_64_fastpath+0x13/0x94
[16439.035850] ---[ end trace a0868b86aec8f15b ]---
[16439.035858] ------------[ cut here ]------------
[16439.035861] WARNING: CPU: 11 PID: 31175 at drivers/md/md.c:449
md_seq_next+0x5b/0x93
[16439.035861] Modules linked in: fcst(O) scst_changer(O) scst_tape(O)
scst_vdisk(O) scst_disk(O) ib_srpt(O) iscsi_scst(O) qla2x00tgt(O)
scst(O) qla2xxx bonding mlx5_core bna ib_umad rdma_ucm ib_uverbs
ib_srp iw_nes iw_cxgb4 cxgb4 iw_cxgb3 ib_qib rdmavt mlx4_ib ib_mthca
[16439.035877] CPU: 11 PID: 31175 Comm: mdadm Tainted: G        W  O
 4.9.0-rc3-esos.prod #1
[16439.035878] Hardware name: Dell Inc. PowerEdge R710/00NH4P, BIOS
6.4.0 07/23/2013
[16439.035879]  0000000000000000 ffffffff81396464 0000000000000000
0000000000000000
[16439.035882]  ffffffff81065522 ffff88061a157000 ffff8803182d5000
ffff8803182d53b8
[16439.035885]  ffff8803133adb00 ffff880320a15000 00000000000000c9
ffffffff81879329
[16439.035888] Call Trace:
[16439.035891]  [<ffffffff81396464>] ? dump_stack+0x46/0x59
[16439.035893]  [<ffffffff81065522>] ? __warn+0xc8/0xe1
[16439.035895]  [<ffffffff81879329>] ? md_seq_next+0x5b/0x93
[16439.035897]  [<ffffffff81143e60>] ? seq_read+0x233/0x323
[16439.035900]  [<ffffffff81175e07>] ? proc_reg_read+0x3f/0x5d
[16439.035902]  [<ffffffff81175dc8>] ? proc_reg_write+0x5d/0x5d
[16439.035904]  [<ffffffff811279a2>] ? __vfs_read+0x1c/0xe2
[16439.035907]  [<ffffffff8112c69b>] ? SyS_newfstat+0x1f/0x27
[16439.035909]  [<ffffffff811283df>] ? vfs_read+0x98/0x11b
[16439.035911]  [<ffffffff811294d2>] ? SyS_read+0x48/0x81
[16439.035914]  [<ffffffff81a7da20>] ? entry_SYSCALL_64_fastpath+0x13/0x94
[16439.035915] ---[ end trace a0868b86aec8f15c ]---
[16439.035916] ------------[ cut here ]------------
[16439.035919] WARNING: CPU: 11 PID: 31175 at drivers/md/md.c:458
mddev_put+0x18/0x16b
[16439.035920] Modules linked in: fcst(O) scst_changer(O) scst_tape(O)
scst_vdisk(O) scst_disk(O) ib_srpt(O) iscsi_scst(O) qla2x00tgt(O)
scst(O) qla2xxx bonding mlx5_core bna ib_umad rdma_ucm ib_uverbs
ib_srp iw_nes iw_cxgb4 cxgb4 iw_cxgb3 ib_qib rdmavt mlx4_ib ib_mthca
[16439.035935] CPU: 11 PID: 31175 Comm: mdadm Tainted: G        W  O
 4.9.0-rc3-esos.prod #1
[16439.035936] Hardware name: Dell Inc. PowerEdge R710/00NH4P, BIOS
6.4.0 07/23/2013
[16439.035936]  0000000000000000 ffffffff81396464 0000000000000000
0000000000000000
[16439.035940]  ffffffff81065522 ffff88061a157000 ffff8803182d5000
ffff8803182d53b8
[16439.035942]  ffff8803133adb00 ffff880320a15000 00000000000000c9
ffffffff818781b3
[16439.035946] Call Trace:
[16439.035948]  [<ffffffff81396464>] ? dump_stack+0x46/0x59
[16439.035950]  [<ffffffff81065522>] ? __warn+0xc8/0xe1
[16439.035953]  [<ffffffff818781b3>] ? mddev_put+0x18/0x16b
[16439.035955]  [<ffffffff81879359>] ? md_seq_next+0x8b/0x93
[16439.035957]  [<ffffffff81143e60>] ? seq_read+0x233/0x323
[16439.035960]  [<ffffffff81175e07>] ? proc_reg_read+0x3f/0x5d
[16439.035961]  [<ffffffff81175dc8>] ? proc_reg_write+0x5d/0x5d
[16439.035964]  [<ffffffff811279a2>] ? __vfs_read+0x1c/0xe2
[16439.035966]  [<ffffffff8112c69b>] ? SyS_newfstat+0x1f/0x27
[16439.035969]  [<ffffffff811283df>] ? vfs_read+0x98/0x11b
[16439.035971]  [<ffffffff811294d2>] ? SyS_read+0x48/0x81
[16439.035974]  [<ffffffff81a7da20>] ? entry_SYSCALL_64_fastpath+0x13/0x94
[16439.035975] ---[ end trace a0868b86aec8f15d ]---
[16439.035976] mddev->active = 1
[16439.035978] rd=2 empty=0 ctime=1480694775 hold=0
[16439.035984] ------------[ cut here ]------------
[16439.035987] WARNING: CPU: 11 PID: 31175 at drivers/md/md.c:449
md_seq_next+0x5b/0x93
[16439.035988] Modules linked in: fcst(O) scst_changer(O) scst_tape(O)
scst_vdisk(O) scst_disk(O) ib_srpt(O) iscsi_scst(O) qla2x00tgt(O)
scst(O) qla2xxx bonding mlx5_core bna ib_umad rdma_ucm ib_uverbs
ib_srp iw_nes iw_cxgb4 cxgb4 iw_cxgb3 ib_qib rdmavt mlx4_ib ib_mthca
[16439.036003] CPU: 11 PID: 31175 Comm: mdadm Tainted: G        W  O
 4.9.0-rc3-esos.prod #1
[16439.036004] Hardware name: Dell Inc. PowerEdge R710/00NH4P, BIOS
6.4.0 07/23/2013
[16439.036005]  0000000000000000 ffffffff81396464 0000000000000000
0000000000000000
[16439.036008]  ffffffff81065522 ffff8803182d5000 ffff8803182d4000
ffff8803182d43b8
[16439.036011]  ffff8803133adb00 ffff880320a15000 0000000000000147
ffffffff81879329
[16439.036014] Call Trace:
[16439.036016]  [<ffffffff81396464>] ? dump_stack+0x46/0x59
[16439.036018]  [<ffffffff81065522>] ? __warn+0xc8/0xe1
[16439.036021]  [<ffffffff81879329>] ? md_seq_next+0x5b/0x93
[16439.036023]  [<ffffffff81143e60>] ? seq_read+0x233/0x323
[16439.036025]  [<ffffffff81175e07>] ? proc_reg_read+0x3f/0x5d
[16439.036027]  [<ffffffff81175dc8>] ? proc_reg_write+0x5d/0x5d
[16439.036030]  [<ffffffff811279a2>] ? __vfs_read+0x1c/0xe2
[16439.036032]  [<ffffffff8112c69b>] ? SyS_newfstat+0x1f/0x27
[16439.036034]  [<ffffffff811283df>] ? vfs_read+0x98/0x11b
[16439.036037]  [<ffffffff811294d2>] ? SyS_read+0x48/0x81
[16439.036039]  [<ffffffff81a7da20>] ? entry_SYSCALL_64_fastpath+0x13/0x94
[16439.036041] ---[ end trace a0868b86aec8f15e ]---
[16439.036042] ------------[ cut here ]------------
[16439.036044] WARNING: CPU: 11 PID: 31175 at drivers/md/md.c:458
mddev_put+0x18/0x16b
[16439.036045] Modules linked in: fcst(O) scst_changer(O) scst_tape(O)
scst_vdisk(O) scst_disk(O) ib_srpt(O) iscsi_scst(O) qla2x00tgt(O)
scst(O) qla2xxx bonding mlx5_core bna ib_umad rdma_ucm ib_uverbs
ib_srp iw_nes iw_cxgb4 cxgb4 iw_cxgb3 ib_qib rdmavt mlx4_ib ib_mthca
[16439.036060] CPU: 11 PID: 31175 Comm: mdadm Tainted: G        W  O
 4.9.0-rc3-esos.prod #1
[16439.036061] Hardware name: Dell Inc. PowerEdge R710/00NH4P, BIOS
6.4.0 07/23/2013
[16439.036062]  0000000000000000 ffffffff81396464 0000000000000000
0000000000000000
[16439.036065]  ffffffff81065522 ffff8803182d5000 ffff8803182d4000
ffff8803182d43b8
[16439.036067]  ffff8803133adb00 ffff880320a15000 0000000000000147
ffffffff818781b3
[16439.036070] Call Trace:
[16439.036073]  [<ffffffff81396464>] ? dump_stack+0x46/0x59
[16439.036075]  [<ffffffff81065522>] ? __warn+0xc8/0xe1
[16439.036077]  [<ffffffff818781b3>] ? mddev_put+0x18/0x16b
[16439.036079]  [<ffffffff81879359>] ? md_seq_next+0x8b/0x93
[16439.036082]  [<ffffffff81143e60>] ? seq_read+0x233/0x323
[16439.036084]  [<ffffffff81175e07>] ? proc_reg_read+0x3f/0x5d
[16439.036086]  [<ffffffff81175dc8>] ? proc_reg_write+0x5d/0x5d
[16439.036088]  [<ffffffff811279a2>] ? __vfs_read+0x1c/0xe2
[16439.036091]  [<ffffffff8112c69b>] ? SyS_newfstat+0x1f/0x27
[16439.036093]  [<ffffffff811283df>] ? vfs_read+0x98/0x11b
[16439.036096]  [<ffffffff811294d2>] ? SyS_read+0x48/0x81
[16439.036098]  [<ffffffff81a7da20>] ? entry_SYSCALL_64_fastpath+0x13/0x94
[16439.036100] ---[ end trace a0868b86aec8f15f ]---
[16439.036100] mddev->active = 1
[16439.036102] rd=2 empty=0 ctime=1480694673 hold=0
[16439.036103] ------------[ cut here ]------------
[16439.036105] WARNING: CPU: 11 PID: 31175 at drivers/md/md.c:458
mddev_put+0x18/0x16b
[16439.036106] Modules linked in: fcst(O) scst_changer(O) scst_tape(O)
scst_vdisk(O) scst_disk(O) ib_srpt(O) iscsi_scst(O) qla2x00tgt(O)
scst(O) qla2xxx bonding mlx5_core bna ib_umad rdma_ucm ib_uverbs
ib_srp iw_nes iw_cxgb4 cxgb4 iw_cxgb3 ib_qib rdmavt mlx4_ib ib_mthca
[16439.036121] CPU: 11 PID: 31175 Comm: mdadm Tainted: G        W  O
 4.9.0-rc3-esos.prod #1
[16439.036122] Hardware name: Dell Inc. PowerEdge R710/00NH4P, BIOS
6.4.0 07/23/2013
[16439.036122]  0000000000000000 ffffffff81396464 0000000000000000
0000000000000000
[16439.036125]  ffffffff81065522 ffff8803182d4000 0000000000000002
ffffffff8209ff30
[16439.036128]  ffff8803133adb00 ffff880320a15000 0000000000000147
ffffffff818781b3
[16439.036131] Call Trace:
[16439.036134]  [<ffffffff81396464>] ? dump_stack+0x46/0x59
[16439.036136]  [<ffffffff81065522>] ? __warn+0xc8/0xe1
[16439.036138]  [<ffffffff818781b3>] ? mddev_put+0x18/0x16b
[16439.036140]  [<ffffffff81879359>] ? md_seq_next+0x8b/0x93
[16439.036143]  [<ffffffff81143e60>] ? seq_read+0x233/0x323
[16439.036145]  [<ffffffff81175e07>] ? proc_reg_read+0x3f/0x5d
[16439.036147]  [<ffffffff81175dc8>] ? proc_reg_write+0x5d/0x5d
[16439.036150]  [<ffffffff811279a2>] ? __vfs_read+0x1c/0xe2
[16439.036152]  [<ffffffff8112c69b>] ? SyS_newfstat+0x1f/0x27
[16439.036154]  [<ffffffff811283df>] ? vfs_read+0x98/0x11b
[16439.036157]  [<ffffffff811294d2>] ? SyS_read+0x48/0x81
[16439.036160]  [<ffffffff81a7da20>] ? entry_SYSCALL_64_fastpath+0x13/0x94
[16439.036161] ---[ end trace a0868b86aec8f160 ]---
[16439.036162] mddev->active = 4
[16439.036298] ------------[ cut here ]------------
[16439.036302] WARNING: CPU: 11 PID: 31175 at drivers/md/md.c:458
mddev_put+0x18/0x16b
[16439.036303] Modules linked in: fcst(O) scst_changer(O) scst_tape(O)
scst_vdisk(O) scst_disk(O) ib_srpt(O) iscsi_scst(O) qla2x00tgt(O)
scst(O) qla2xxx bonding mlx5_core bna ib_umad rdma_ucm ib_uverbs
ib_srp iw_nes iw_cxgb4 cxgb4 iw_cxgb3 ib_qib rdmavt mlx4_ib ib_mthca
[16439.036319] CPU: 11 PID: 31175 Comm: mdadm Tainted: G        W  O
 4.9.0-rc3-esos.prod #1
[16439.036320] Hardware name: Dell Inc. PowerEdge R710/00NH4P, BIOS
6.4.0 07/23/2013
[16439.036321]  0000000000000000 ffffffff81396464 0000000000000000
0000000000000000
[16439.036324]  ffffffff81065522 ffff8803182d4000 ffff880622d20aa0
ffff8803182ae800
[16439.036327]  ffff880622d209d8 ffff880622d20b20 ffff88030f854ac8
ffffffff818781b3
[16439.036330] Call Trace:
[16439.036334]  [<ffffffff81396464>] ? dump_stack+0x46/0x59
[16439.036336]  [<ffffffff81065522>] ? __warn+0xc8/0xe1
[16439.036339]  [<ffffffff818781b3>] ? mddev_put+0x18/0x16b
[16439.036341]  [<ffffffff81151258>] ? __blkdev_put+0x11c/0x1c4
[16439.036344]  [<ffffffff81151aff>] ? blkdev_close+0x1c/0x1f
[16439.036346]  [<ffffffff81129c69>] ? __fput+0xd8/0x18a
[16439.036350]  [<ffffffff8107990c>] ? task_work_run+0x5d/0x73
[16439.036352]  [<ffffffff81001048>] ? exit_to_usermode_loop+0x48/0x5d
[16439.036354]  [<ffffffff8100135c>] ? syscall_return_slowpath+0x3a/0x4c
[16439.036357]  [<ffffffff81a7da9f>] ? entry_SYSCALL_64_fastpath+0x92/0x94
[16439.036359] ---[ end trace a0868b86aec8f161 ]---
[16439.036360] mddev->active = 3
--snip--


--Marc

On Fri, Dec 2, 2016 at 2:12 PM, Marc Smith <marc.smith@mcc.edu> wrote:
> On Thu, Dec 1, 2016 at 5:35 PM, NeilBrown <neilb@suse.com> wrote:
>> On Fri, Dec 02 2016, Marc Smith wrote:
>>
>>> On Wed, Nov 30, 2016 at 9:52 PM, NeilBrown <neilb@suse.com> wrote:
>>>> On Mon, Nov 28 2016, Marc Smith wrote:
>>>>
>>>>>
>>>>> # find /sys/block/md127/md
>>>>> /sys/block/md127/md
>>>>> /sys/block/md127/md/reshape_position
>>>>> /sys/block/md127/md/layout
>>>>> /sys/block/md127/md/raid_disks
>>>>> /sys/block/md127/md/bitmap
>>>>> /sys/block/md127/md/bitmap/chunksize
>>>>
>>>> This tells me that:
>>>>         sysfs_remove_group(&mddev->kobj, &md_bitmap_group);
>>>> hasn't been run, so mddev_delayed_delete() hasn't run.
>>>> That suggests the final mddev_put() hsn't run. i.e. mddev->active is > 0
>>>>
>>>> Everything else suggests that array has been stopped and cleaned and
>>>> should be gone...
>>>>
>>>> This seems to suggest that there is an unbalanced mddev_get() without a
>>>> matching mddev_put().  I cannot find it though.
>>>>
>>>> If I could reproduce it, I would try to see what is happening by:
>>>>
>>>> - putting
>>>>    printk("mddev->active = %d\n", atomic_read(&mddev->active));
>>>>  in the top of mddev_put().  That shouldn't be *too* noisy.
>>>>
>>>> - putting
>>>>    printk("rd=%d empty=%d ctime=%d hold=%d\n", mddev->raid_disks,
>>>>         list_empty(&mddev->disks), mddev->ctime, mddev->hold_active);
>>>>
>>>>   in mddev_put() just before those values are tested.
>>>>
>>>>  - putting
>>>>      printk("queue_work\n");
>>>>    just before the 'queue_work()' call in mddev_put.
>>>>
>>>>  - putting
>>>>      printk("mddev_delayed_delete\n");
>>>>    in mddev_delayed_delete()
>>>>
>>>> Then see what gets printed when you stop the array.
>>>
>>> I made those modifications to md.c and here is the kernel log when stopping:
>>>
>>> --snip--
>>> [ 3937.233487] mddev->active = 2
>>> [ 3937.233503] mddev->active = 2
>>> [ 3937.233509] mddev->active = 2
>>> [ 3937.233516] mddev->active = 1
>>> [ 3937.233516] rd=2 empty=0 ctime=1480617270 hold=0
>>
>> At this point, mdadm has opened the /dev/md127 device, accessed a few
>> attributes via sysfs just to check on the status, and then closed it
>> again.
>> The array is still active, but we know that no other process has it
>> open.
>>
>>
>>> [ 3937.233679] udevd[492]: inotify event: 8 for /dev/md127
>>> [ 3937.241489] md127: detected capacity change from 73340747776 to 0
>>> [ 3937.241493] md: md127 stopped.
>>
>> Now mdadm has opened the array again and issued the STOP_ARRAY ioctl.
>> Still nothing else has the array open.
>>
>>> [ 3937.241665] udevd[492]: device /dev/md127 closed, synthesising 'change'
>>> [ 3937.241726] udevd[492]: seq 3631 queued, 'change' 'block'
>>> [ 3937.241829] udevd[492]: seq 3631 forked new worker [4991]
>>> [ 3937.241989] udevd[4991]: seq 3631 running
>>> [ 3937.242002] dlm: dc18e34c-b136-1964-1c34-4509a7c60a19: leaving the
>>> lockspace group...
>>> [ 3937.242039] udevd[4991]: removing watch on '/dev/md127'
>>> [ 3937.242068] mddev->active = 3
>>
>> But somehow the ->active count got up to 3.
>> mdadm probably still has it open, but two other things do too.
>> If you have "mdadm --monitor" running in the background (which is good)
>> it will temporarily increase, then decrease the count.
>> udevd opens the device temporarily too.
>> So this isn't necessarily a problem.
>>
>>> [ 3937.242069] udevd[492]: seq 3632 queued, 'offline' 'dlm'
>>> [ 3937.242080] mddev->active = 3
>>> [ 3937.242104] udevd[4991]: IMPORT 'probe-bcache -o udev /dev/md127'
>>> /usr/lib/udev/rules.d/69-bcache.rules:16
>>> [ 3937.242161] udevd[492]: seq 3632 forked new worker [4992]
>>> [ 3937.242259] udevd[4993]: starting 'probe-bcache -o udev /dev/md127'
>>> [ 3937.242753] dlm: dc18e34c-b136-1964-1c34-4509a7c60a19: group event done 0 0
>>> [ 3937.242847] dlm: dc18e34c-b136-1964-1c34-4509a7c60a19:
>>> release_lockspace final free
>>> [ 3937.242861] md: unbind<dm-1>
>>> [ 3937.256606] md: export_rdev(dm-1)
>>> [ 3937.256612] md: unbind<dm-0>
>>> [ 3937.263601] md: export_rdev(dm-0)
>>> [ 3937.263688] mddev->active = 4
>>> [ 3937.263751] mddev->active = 3
>>
>> But here, the active count only drops down to 2. (it is decremented
>> after it is printed).  Assuming there really were no more messages like
>> this, there are two active references to the md device, and we don't
>> know what they are.
>>
>>>
>>> I didn't use my modified mdadm which stops the synthesized CHANGE from
>>> occurring, but if needed, I can re-run the test using that.
>>
>> It would be good to use the modified mdadm, if only to reduce the
>> noise.  It won't change the end result, but might make it easier to see
>> what is happening.
>> Also please add
>>    WARN_ON(1);
>>
>> in the start of mddev_get() and mddev_put().
>> That will provide a stack trace whenever either of these are called, so
>> we can see who takes a references, and who doesn't release it.
>
> Okay, I added that to both functions, and now I can't get stopping the
> array to misbehave (eg, not generate the REMOVE event). I've been
> trying all morning! I literally just added the WARN_ON(1) to those two
> functions, and that's all I changed. I compiled and reinstalled image,
> no other changes. I've tried quite a few times now to reproduce this,
> and I'm failing to do so -- every time the REMOVE event is generated
> and everything is removed correctly.
>
> I'm going to switch back to the previous image and confirm its
> reproducible with that.
>
> --Marc
>
>
>>
>> Thanks,
>> NeilBrown
>>
