From: "Moshe Melnikov" <moshe@zadarastorage.com>
Subject: Kernel OOPs after RAID10 assemble
Date: Sun, 11 Sep 2011 16:07:55 +0300
Message-ID: <73BD7CAEBC35402D8AB28B442D788A0C@MoshePC>
References: <C8B40B93E2024230AB92E0B360028997@MoshePC>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1255;
	format=flowed	reply-type=original
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <C8B40B93E2024230AB92E0B360028997@MoshePC>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I created RAID10 from  4 disks
=93mdadm --create=20
/dev/md1 --raid-devices=3D4 --chunk=3D64 --level=3Draid10 --layout=3Dn2=
 --bitmap=3Dinternal=20
 --name=3D1 --run --auto=3Dmd --metadata=3D1.2 --homehost=3Dzadara_vc -=
-verbose=20
/dev/dm-0 /dev/dm-1 /dev/dm-2 /dev/dm-3=94.
Then I failed all 4 disks by injecting I/O errors. MD marked all except=
=20
/dev/dm-2 as =93faulty=94.
I removed 3 disks and re-added them.
=93mdadm /dev/md1 --remove /dev/dm-0 /dev/dm-1 /dev/dm-2=94
=93mdadm /dev/md1 =96re-add /dev/dm-0 /dev/dm-1 /dev/dm-2=94
The 3 disks are still marked as missing.
I Stopped raid =93mdadm =96-stop /dev/md1=94
Assembled it again. =93mdadm --assemble=20
/dev/md1 --name=3D1 --config=3Dnone --homehost=3Dzadara_vc --run --auto=
=3Dmd --verbose=20
/dev/dm-0 /dev/dm-1 /dev/dm-2 /dev/dm-3=94
After that I had kernel oops.Below is syslog

Sep 11 14:31:42 vc-0-0-6-01 kernel: [ 4024.417773] Buffer I/O error on=20
device md1, logical block 0
Sep 11 14:32:29 vc-0-0-6-01 mdadm[884]: DeviceDisappeared event detecte=
d on=20
md device /dev/md1
Sep 11 14:32:29 vc-0-0-6-01 kernel: [ 4071.613012] md1: detected capaci=
ty=20
change from 2147352576 to 0
Sep 11 14:32:29 vc-0-0-6-01 kernel: [ 4071.613019] md: md1 stopped.
Sep 11 14:32:29 vc-0-0-6-01 kernel: [ 4071.613027] md: unbind<dm-3>
Sep 11 14:32:29 vc-0-0-6-01 kernel: [ 4071.613032] md: export_rdev(dm-3=
)
Sep 11 14:32:29 vc-0-0-6-01 kernel: [ 4071.613038] md: unbind<dm-1>
Sep 11 14:32:29 vc-0-0-6-01 kernel: [ 4071.613041] md: export_rdev(dm-1=
)
Sep 11 14:32:29 vc-0-0-6-01 kernel: [ 4071.613046] md: unbind<dm-0>
Sep 11 14:32:29 vc-0-0-6-01 kernel: [ 4071.613049] md: export_rdev(dm-0=
)
Sep 11 14:32:29 vc-0-0-6-01 kernel: [ 4071.613053] md: unbind<dm-2>
Sep 11 14:32:29 vc-0-0-6-01 kernel: [ 4071.613056] md: export_rdev(dm-2=
)
Sep 11 14:33:07 vc-0-0-6-01 kernel: [ 4109.583968] md: md1 stopped.
Sep 11 14:33:07 vc-0-0-6-01 kernel: [ 4109.591469] md: bind<dm-0>
Sep 11 14:33:07 vc-0-0-6-01 kernel: [ 4109.591822] md: bind<dm-1>
Sep 11 14:33:07 vc-0-0-6-01 kernel: [ 4109.592109] md: bind<dm-3>
Sep 11 14:33:07 vc-0-0-6-01 kernel: [ 4109.592355] md: bind<dm-2>
Sep 11 14:33:07 vc-0-0-6-01 kernel: [ 4109.600692] md/raid10:md1: not e=
nough=20
operational mirrors.
Sep 11 14:33:07 vc-0-0-6-01 kernel: [ 4109.601459] md: pers->run() fail=
ed=20
=2E..
Sep 11 14:34:05 vc-0-0-6-01 kernel: [ 4167.452226] md: md1 stopped.
Sep 11 14:34:05 vc-0-0-6-01 kernel: [ 4167.452235] md: unbind<dm-2>
Sep 11 14:34:05 vc-0-0-6-01 kernel: [ 4167.452242] md: export_rdev(dm-2=
)
Sep 11 14:34:05 vc-0-0-6-01 kernel: [ 4167.452274] md: unbind<dm-3>
Sep 11 14:34:05 vc-0-0-6-01 kernel: [ 4167.452278] md: export_rdev(dm-3=
)
Sep 11 14:34:05 vc-0-0-6-01 kernel: [ 4167.452297] md: unbind<dm-1>
Sep 11 14:34:05 vc-0-0-6-01 kernel: [ 4167.452301] md: export_rdev(dm-1=
)
Sep 11 14:34:05 vc-0-0-6-01 kernel: [ 4167.452319] md: unbind<dm-0>
Sep 11 14:34:05 vc-0-0-6-01 kernel: [ 4167.452323] md: export_rdev(dm-0=
)
Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.073655] md: md1 stopped.
Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.081092] md: bind<dm-0>
Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.081412] md: bind<dm-1>
Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.081739] md: bind<dm-3>
Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.081991] md: bind<dm-2>
Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.090382] md/raid10:md1: not e=
nough=20
operational mirrors.
Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.091194] md: pers->run() fail=
ed=20
=2E..
Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.276215] BUG: unable to handl=
e=20
kernel NULL pointer dereference at           (null)
Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.276982] IP: [<          (nul=
l)>]=20
(null)
Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.277728] PGD b7433067 PUD b75=
e2067=20
PMD 0
Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.278464] Oops: 0010 [#1] SMP
Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.279202] last sysfs file:=20
/sys/module/raid10/initstate
Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.279966] CPU 0
Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.279987] Modules linked in:=20
dm_iostat iscsi_scst scst_vdisk libcrc32c scst ppdev ib_iser rdma_cm ib=
_cm=20
iw_cm ib_sa ib_mad ib_core ib_addr iscsi_tcp libiscsi_tcp libiscsi=20
scsi_transport_iscsi parport_pc nfsd psmouse exportfs nfs lockd fscache=
=20
nfs_acl serio_raw auth_rpcgss sunrpc i2c_piix4 lp parport floppy raid10=
=20
raid456 async_pq async_xor xor async_memcpy async_raid6_recov raid6_pq=20
async_tx raid1 raid0 multipath linear
Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.285078]
Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.285629] Pid: 4576, comm: md_=
stat=20
Not tainted 2.6.38-8-server #42-Ubuntu Bochs Bochs
Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.285629] RIP:=20
0010:[<0000000000000000>]  [<          (null)>]           (null)
Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.285629] RSP:=20
0018:ffff8800b630fd00  EFLAGS: 00010096
Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.285629] RAX: ffff880037383de=
8=20
RBX: ffff8800b8e1f8e8 RCX: 0000000000000000
Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.285629] RDX: 000000000000000=
0=20
RSI: 0000000000000003 RDI: ffff880037383de8
Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.285629] RBP: ffff8800b630fd4=
8=20
R08: 0000000000000000 R09: 0000000000000000
Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.285629] R10: 000000000000000=
4=20
R11: 0000000000000000 R12: 0000000000000000
Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.285629] R13: ffff8800b7b7b29=
8=20
R14: 0000000000000000 R15: 0000000000000000
Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.285629] FS:=20
00007f8af77ef720(0000) GS:ffff8800bfc00000(0000) knlGS:0000000000000000
Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.285629] CS:  0010 DS: 0000 E=
S:=20
0000 CR0: 0000000080050033
Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.285629] CR2: 000000000000000=
0=20
CR3: 00000000b75cc000 CR4: 00000000000006f0
Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.285629] DR0: 000000000000000=
0=20
DR1: 0000000000000000 DR2: 0000000000000000
Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.285629] DR3: 000000000000000=
0=20
DR6: 00000000ffff0ff0 DR7: 0000000000000400
Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.285629] Process md_stat (pid=
:=20
4576, threadinfo ffff8800b630e000, task ffff8800b55e44a0)
Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.285629] Stack:
Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.285629]  ffffffff8104bb39=20
ffffea000280ee88 0000000300000001 ffff8800b630fd28
Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.285629]  ffff8800b7b7b290=20
0000000000000282 0000000000000003 0000000000000001
Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.285629]  0000000000000000=20
ffff8800b630fd88 ffffffff8104e4b8 0000000200000001
Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.285629] Call Trace:
Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.285629]  [<ffffffff8104bb39>=
] ?=20
__wake_up_common+0x59/0x90
Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.285629]  [<ffffffff8104e4b8>=
]=20
__wake_up+0x48/0x70
Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.285629]  [<ffffffff81489478>=
]=20
md_wakeup_thread+0x28/0x30
Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.285629]  [<ffffffff8148a96f>=
]=20
mddev_unlock+0x7f/0xd0
Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.285629]  [<ffffffff81495068>=
]=20
md_ioctl+0x2b8/0x720
Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.285629]  [<ffffffff8113135d>=
] ?=20
handle_mm_fault+0x16d/0x250
Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.285629]  [<ffffffff812c8cb0>=
]=20
blkdev_ioctl+0x230/0x720
Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.285629]  [<ffffffff81198261>=
]=20
block_ioctl+0x41/0x50
Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.285629]  [<ffffffff8117680f>=
]=20
do_vfs_ioctl+0x8f/0x320
Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.285629]  [<ffffffff8116fd85>=
] ?=20
putname+0x35/0x50
Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.285629]  [<ffffffff81176b31>=
]=20
sys_ioctl+0x91/0xa0
Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.285629]  [<ffffffff8100bfc2>=
]=20
system_call_fastpath+0x16/0x1b
Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.285629] Code:  Bad RIP value=
=2E
Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.285629] RIP  [<          (nu=
ll)>]=20
(null)
Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.285629]  RSP <ffff8800b630fd=
00>
Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.285629] CR2: 000000000000000=
0
Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.285629] ---[ end trace=20
66d7ffb11044dd44 ]---

Thanks,
Moshe Melnikov=20

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
