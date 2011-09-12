From: "Moshe Melnikov" <moshe@zadarastorage.com>
Subject: Re: Kernel OOPs after RAID10 assemble
Date: Mon, 12 Sep 2011 08:33:31 +0300
Message-ID: <6BFB6C30B63A4B5493F7E7F8651CE557@MoshePC>
References: <C8B40B93E2024230AB92E0B360028997@MoshePC><73BD7CAEBC35402D8AB28B442D788A0C@MoshePC> <20110912060528.5d8fba4d@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1255;
	format=flowed	reply-type=original
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110912060528.5d8fba4d@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I can reproduce it very easily.

I don't know how to apply this patch. I have very limited knowledge in =
Linux=20
kernel.

Thanks,
Moshe

-----Original Message-----=20
=46rom: NeilBrown
Sent: Monday, September 12, 2011 7:05 AM
To: Moshe Melnikov
Cc: linux-raid@vger.kernel.org
Subject: Re: Kernel OOPs after RAID10 assemble

On Sun, 11 Sep 2011 16:07:55 +0300 "Moshe Melnikov"=20
<moshe@zadarastorage.com>
wrote:

> Hi,
>
> I created RAID10 from  4 disks
> =93mdadm --create
> /dev/md1 --raid-devices=3D4 --chunk=3D64 --level=3Draid10 --layout=3D=
n2 --bitmap=3Dinternal
>  --name=3D1 --run --auto=3Dmd --metadata=3D1.2e --homehost=3Dzadara_v=
c --verbose
> /dev/dm-0 /dev/dm-1 /dev/dm-2 /dev/dm-3=94.
> Then I failed all 4 disks by injecting I/O errors. MD marked all exce=
pt
> /dev/dm-2 as =93faulty=94.
> I removed 3 disks and re-added them.
> =93mdadm /dev/md1 --remove /dev/dm-0 /dev/dm-1 /dev/dm-2=94
> =93mdadm /dev/md1 =96re-add /dev/dm-0 /dev/dm-1 /dev/dm-2=94
> The 3 disks are still marked as missing.
> I Stopped raid =93mdadm =96-stop /dev/md1=94
> Assembled it again. =93mdadm --assemble
> /dev/md1 --name=3D1 --config=3Dnone --homehost=3Dzadara_vc --run --au=
to=3Dmd --verbose
> /dev/dm-0 /dev/dm-1 /dev/dm-2 /dev/dm-3=94
> After that I had kernel oops.Below is syslog

Thanks for the report.

Pity your mailer wrapper all the long lines, but I'm getting used to th=
at=20
:-(

Is the reproducible?  Would you be able to test a patch?

I think it would be almost enough to do

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 747d061..ec35b64 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2413,12 +2413,13 @@ out:
static int stop(mddev_t *mddev)
{
  conf_t *conf =3D mddev->private;
+ mdk_thread_t *th =3D mddev->thread;

  raise_barrier(conf, 0);
  lower_barrier(conf);

- md_unregister_thread(mddev->thread);
  mddev->thread =3D NULL;
+ md_unregister_thread(th);
  blk_sync_queue(mddev->queue); /* the unplug fn references 'conf'*/
  if (conf->r10bio_pool)
  mempool_destroy(conf->r10bio_pool);

though it really needs some locking with calls the md_wakeup_thread too=
, but
there is currently no lock that would be easy to use, so I would have t=
o add
a lock and export it.  Particularly the call to md_wakeup_thread in
mddev_unlock is racing with this I think.

If it happens reliable with your current kernel, and you can test the a=
bove
patch and it happens significantly less, that would be useful to know.
However I'm fairly sure this is the problem so I create a proper fix fo=
r
mainline.

Thanks,
NeilBrown


>
> Sep 11 14:31:42 vc-0-0-6-01 kernel: [ 4024.417773] Buffer I/O error o=
n
> device md1, logical block 0
> Sep 11 14:32:29 vc-0-0-6-01 mdadm[884]: DeviceDisappeared event detec=
ted=20
> on
> md device /dev/md1
> Sep 11 14:32:29 vc-0-0-6-01 kernel: [ 4071.613012] md1: detected capa=
city
> change from 2147352576 to 0
> Sep 11 14:32:29 vc-0-0-6-01 kernel: [ 4071.613019] md: md1 stopped.
> Sep 11 14:32:29 vc-0-0-6-01 kernel: [ 4071.613027] md: unbind<dm-3>
> Sep 11 14:32:29 vc-0-0-6-01 kernel: [ 4071.613032] md: export_rdev(dm=
-3)
> Sep 11 14:32:29 vc-0-0-6-01 kernel: [ 4071.613038] md: unbind<dm-1>
> Sep 11 14:32:29 vc-0-0-6-01 kernel: [ 4071.613041] md: export_rdev(dm=
-1)
> Sep 11 14:32:29 vc-0-0-6-01 kernel: [ 4071.613046] md: unbind<dm-0>
> Sep 11 14:32:29 vc-0-0-6-01 kernel: [ 4071.613049] md: export_rdev(dm=
-0)
> Sep 11 14:32:29 vc-0-0-6-01 kernel: [ 4071.613053] md: unbind<dm-2>
> Sep 11 14:32:29 vc-0-0-6-01 kernel: [ 4071.613056] md: export_rdev(dm=
-2)
> Sep 11 14:33:07 vc-0-0-6-01 kernel: [ 4109.583968] md: md1 stopped.
> Sep 11 14:33:07 vc-0-0-6-01 kernel: [ 4109.591469] md: bind<dm-0>
> Sep 11 14:33:07 vc-0-0-6-01 kernel: [ 4109.591822] md: bind<dm-1>
> Sep 11 14:33:07 vc-0-0-6-01 kernel: [ 4109.592109] md: bind<dm-3>
> Sep 11 14:33:07 vc-0-0-6-01 kernel: [ 4109.592355] md: bind<dm-2>
> Sep 11 14:33:07 vc-0-0-6-01 kernel: [ 4109.600692] md/raid10:md1: not=
=20
> enough
> operational mirrors.
> Sep 11 14:33:07 vc-0-0-6-01 kernel: [ 4109.601459] md: pers->run() fa=
iled
> ...
> Sep 11 14:34:05 vc-0-0-6-01 kernel: [ 4167.452226] md: md1 stopped.
> Sep 11 14:34:05 vc-0-0-6-01 kernel: [ 4167.452235] md: unbind<dm-2>
> Sep 11 14:34:05 vc-0-0-6-01 kernel: [ 4167.452242] md: export_rdev(dm=
-2)
> Sep 11 14:34:05 vc-0-0-6-01 kernel: [ 4167.452274] md: unbind<dm-3>
> Sep 11 14:34:05 vc-0-0-6-01 kernel: [ 4167.452278] md: export_rdev(dm=
-3)
> Sep 11 14:34:05 vc-0-0-6-01 kernel: [ 4167.452297] md: unbind<dm-1>
> Sep 11 14:34:05 vc-0-0-6-01 kernel: [ 4167.452301] md: export_rdev(dm=
-1)
> Sep 11 14:34:05 vc-0-0-6-01 kernel: [ 4167.452319] md: unbind<dm-0>
> Sep 11 14:34:05 vc-0-0-6-01 kernel: [ 4167.452323] md: export_rdev(dm=
-0)
> Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.073655] md: md1 stopped.
> Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.081092] md: bind<dm-0>
> Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.081412] md: bind<dm-1>
> Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.081739] md: bind<dm-3>
> Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.081991] md: bind<dm-2>
> Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.090382] md/raid10:md1: not=
=20
> enough
> operational mirrors.
> Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.091194] md: pers->run() fa=
iled
> ...
> Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.276215] BUG: unable to han=
dle
> kernel NULL pointer dereference at           (null)
> Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.276982] IP: [<=20
> (null)>]
> (null)
> Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.277728] PGD b7433067 PUD=20
> b75e2067
> PMD 0
> Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.278464] Oops: 0010 [#1] SM=
P
> Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.279202] last sysfs file:
> /sys/module/raid10/initstate
> Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.279966] CPU 0
> Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.279987] Modules linked in:
> dm_iostat iscsi_scst scst_vdisk libcrc32c scst ppdev ib_iser rdma_cm =
ib_cm
> iw_cm ib_sa ib_mad ib_core ib_addr iscsi_tcp libiscsi_tcp libiscsi
> scsi_transport_iscsi parport_pc nfsd psmouse exportfs nfs lockd fscac=
he
> nfs_acl serio_raw auth_rpcgss sunrpc i2c_piix4 lp parport floppy raid=
10
> raid456 async_pq async_xor xor async_memcpy async_raid6_recov raid6_p=
q
> async_tx raid1 raid0 multipath linear
> Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.285078]
> Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.285629] Pid: 4576, comm:=20
> md_stat
> Not tainted 2.6.38-8-server #42-Ubuntu Bochs Bochs
> Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.285629] RIP:
> 0010:[<0000000000000000>]  [<          (null)>]           (null)
> Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.285629] RSP:
> 0018:ffff8800b630fd00  EFLAGS: 00010096
> Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.285629] RAX: ffff880037383=
de8
> RBX: ffff8800b8e1f8e8 RCX: 0000000000000000
> Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.285629] RDX: 0000000000000=
000
> RSI: 0000000000000003 RDI: ffff880037383de8
> Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.285629] RBP: ffff8800b630f=
d48
> R08: 0000000000000000 R09: 0000000000000000
> Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.285629] R10: 0000000000000=
004
> R11: 0000000000000000 R12: 0000000000000000
> Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.285629] R13: ffff8800b7b7b=
298
> R14: 0000000000000000 R15: 0000000000000000
> Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.285629] FS:
> 00007f8af77ef720(0000) GS:ffff8800bfc00000(0000) knlGS:00000000000000=
00
> Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.285629] CS:  0010 DS: 0000=
 ES:
> 0000 CR0: 0000000080050033
> Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.285629] CR2: 0000000000000=
000
> CR3: 00000000b75cc000 CR4: 00000000000006f0
> Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.285629] DR0: 0000000000000=
000
> DR1: 0000000000000000 DR2: 0000000000000000
> Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.285629] DR3: 0000000000000=
000
> DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.285629] Process md_stat (p=
id:
> 4576, threadinfo ffff8800b630e000, task ffff8800b55e44a0)
> Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.285629] Stack:
> Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.285629]  ffffffff8104bb39
> ffffea000280ee88 0000000300000001 ffff8800b630fd28
> Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.285629]  ffff8800b7b7b290
> 0000000000000282 0000000000000003 0000000000000001
> Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.285629]  0000000000000000
> ffff8800b630fd88 ffffffff8104e4b8 0000000200000001
> Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.285629] Call Trace:
> Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.285629]  [<ffffffff8104bb3=
9>] ?
> __wake_up_common+0x59/0x90
> Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.285629]  [<ffffffff8104e4b=
8>]
> __wake_up+0x48/0x70
> Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.285629]  [<ffffffff8148947=
8>]
> md_wakeup_thread+0x28/0x30
> Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.285629]  [<ffffffff8148a96=
f>]
> mddev_unlock+0x7f/0xd0
> Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.285629]  [<ffffffff8149506=
8>]
> md_ioctl+0x2b8/0x720
> Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.285629]  [<ffffffff8113135=
d>] ?
> handle_mm_fault+0x16d/0x250
> Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.285629]  [<ffffffff812c8cb=
0>]
> blkdev_ioctl+0x230/0x720
> Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.285629]  [<ffffffff8119826=
1>]
> block_ioctl+0x41/0x50
> Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.285629]  [<ffffffff8117680=
f>]
> do_vfs_ioctl+0x8f/0x320
> Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.285629]  [<ffffffff8116fd8=
5>] ?
> putname+0x35/0x50
> Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.285629]  [<ffffffff81176b3=
1>]
> sys_ioctl+0x91/0xa0
> Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.285629]  [<ffffffff8100bfc=
2>]
> system_call_fastpath+0x16/0x1b
> Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.285629] Code:  Bad RIP val=
ue.
> Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.285629] RIP  [<=20
> (null)>]
> (null)
> Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.285629]  RSP <ffff8800b630=
fd00>
> Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.285629] CR2: 0000000000000=
000
> Sep 11 14:34:14 vc-0-0-6-01 kernel: [ 4176.285629] ---[ end trace
> 66d7ffb11044dd44 ]---
>
> Thanks,
> Moshe Melnikov
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
