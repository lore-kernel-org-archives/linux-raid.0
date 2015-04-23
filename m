From: NeilBrown <neilb@suse.de>
Subject: Bisected, with rfc/patch - was Re: BUG: unable to handle kernel
 NULL pointer dereference at sysfs_do_create_link_sd (after mdadm)
Date: Thu, 23 Apr 2015 16:05:51 +1000
Message-ID: <20150423160551.45345f96@notabene.brown>
References: <20150414171537.GH25394@azat>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/cvMwMeTpcQUpTPqGviejswq"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150414171537.GH25394@azat>
Sender: linux-raid-owner@vger.kernel.org
To: Azat Khuzhin <a3at.mail@gmail.com>, Christoph Hellwig <hch@lst.de>
Cc: "Kernel.org-Linux-RAID" <linux-raid@vger.kernel.org>, Guoqing Jiang <GQJiang@suse.com>, Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.cz>, Jens Axboe <axboe@fb.com>
List-Id: linux-raid.ids

--Sig_/cvMwMeTpcQUpTPqGviejswq
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


Hi Christoph et-al,

As Azat reports (see mail below with stack traces etc), it is now fairly ea=
sy
to trigger a WARNING followed by a BUG when you stop an 'md' array.

Bisection shows that this was introduced by:

commit c4db59d31e39ea067c32163ac961e9c80198fd37
Author: Christoph Hellwig <hch@lst.de>
    fs: don't reassign dirty inodes to default_backing_dev_info

When an md array is stopped, a udev event causes udev to run blkid which
opens the md device.  Due to the "interesting" semantics of md devices, this
creates a new device, at least temporarily.  So we have device removal
immediately followed by creation of the same device.
And particularly: bdi removal immediately before bdi creation with same nam=
e.

Prior to the above commit, the bdi entry would be removed from sysfs when
bdi_unregister is called by del_gendisk() (bdi_unregister called
device_unregister(bdi->dev)).
Importantly del_gendisk() calls this *before* calling blk_unregister_region=
().
As soon as the latter is called, a new md device can be created simply by
opening the device node.

After the identified commit, the device_unregister call is delayed until
bdi_destroy().  I'm not sure how long this delay is, but it happens *after*
the blk_unregister_region() call.

This means there is a window during which the block device has been
unregistered, but the bdi still appears in sysfs.
If the md device is opened during this window (by blkid from udev), the
WARNING shown below results and the new bdi does not get registered properl=
y.

The following RFC patch moves the device_unregister() call (and related
bdi_debug_unregister()) back into bdi_unregister().

This by itself is not sufficient as bdi_writeback_workfn() uses bdi->dev, a=
nd
that can run later (which was half the point of the patch I believe).
bdi_writeback_workfn() *only* uses bdi->dev to get a name for the worker
process, so I changed that to only use the bdi->dev name if bdi->dev was not
NULL.

Finally, to ensure no races, I flush the dwork if it is pending between
clearing bdi->dev and unregistering it.  This ensure bdi_writeback_workfn()
doesn't try to find the name of a device which is just being freed.

I left the unregister code in bdi_destroy() as I'm not certain that
bdi_unregister() is always called (though I suspect it is) and the code can=
not
hurt as it only runs if bdi->dev is not NULL.  I'll remove that if that
would be more correct.

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 32a8bbd7a9ad..93f872ec434b 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -1093,9 +1093,13 @@ void bdi_writeback_workfn(struct work_struct *work)
 	struct bdi_writeback *wb =3D container_of(to_delayed_work(work),
 						struct bdi_writeback, dwork);
 	struct backing_dev_info *bdi =3D wb->bdi;
+	struct device *dev =3D bdi->dev;
 	long pages_written;
=20
-	set_worker_desc("flush-%s", dev_name(bdi->dev));
+	if (dev)
+		set_worker_desc("flush-%s", dev_name(dev));
+	else
+		set_worker_desc("flush-final");
 	current->flags |=3D PF_SWAPWRITE;
=20
 	if (likely(!current_is_workqueue_rescuer() ||
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 6dc4580df2af..110af4534905 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -369,9 +369,17 @@ static void bdi_wb_shutdown(struct backing_dev_info *b=
di)
  */
 void bdi_unregister(struct backing_dev_info *bdi)
 {
-	if (WARN_ON_ONCE(!bdi->dev))
+	struct device *dev =3D bdi->dev;
+	if (WARN_ON_ONCE(!dev))
 		return;
=20
+	bdi->dev =3D NULL;
+	if (delayed_work_pending(&bdi->wb.dwork))
+		/* The worker can access bdi->dev */
+		flush_work(&bdi->wb.dwork.work);
+	bdi_debug_unregister(bdi);
+	device_unregister(dev);
+
 	bdi_set_min_ratio(bdi, 0);
 }
 EXPORT_SYMBOL(bdi_unregister);


As mentioned the WARNING is followed shortly by a BUG.
This is because add_disk() doesn't check if bdi_register_dev() failed, and
proceeds to use bdi->dev.  This is probably best fixed by the following pat=
ch:

diff --git a/block/genhd.c b/block/genhd.c
index 0a536dc05f3b..e351fc521053 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -612,6 +612,10 @@ void add_disk(struct gendisk *disk)
 	/* Register BDI before referencing it from bdev */
 	bdi =3D &disk->queue->backing_dev_info;
 	bdi_register_dev(bdi, disk_devt(disk));
+	if (!bdi->dev) {
+		WARN_ON(1);
+		return;
+	}
=20
 	blk_register_region(disk_devt(disk), disk->minors, NULL,
 			    exact_match, exact_lock, disk);


which Jens or Tejun might like to comment on.

If I can get an 'ack' or a proposal for a different approach I will happy
create a properly formatted patch for submission to -stable and to Linus.

And Azat:  thanks for reporting!! sorry it took over a week to get to this.

NeilBrown


On Tue, 14 Apr 2015 20:15:37 +0300 Azat Khuzhin <a3at.mail@gmail.com> wrote:

> $ git describe
> v4.0-2620-gb79013b
>=20
> During setting up partitions with mdadm, mdadm hung, after attaching to m=
dadm with strace I got next:
>=20
> # pgrep mdadm | xargs strace -fp
> Process 27389 attached - interrupt to quit
> unlink("/dev/.tmp.md.27389:9:127")      =3D 0
> mknod("/tmp/.tmp.md.27389:9:127", S_IFBLK|0600, makedev(9, 127)) =3D 0
> open("/tmp/.tmp.md.27389:9:127", O_RDWR|O_EXCL|O_DIRECT) <-- *hung*
>=20
> After, I looked into dmesg, and found this:
> [ 9627.630018] ------------[ cut here ]------------
> [ 9627.630029] WARNING: CPU: 18 PID: 3330 at fs/sysfs/dir.c:31 sysfs_warn=
_dup+0x5a/0x70()
> [ 9627.630032] sysfs: cannot create duplicate filename '/devices/virtual/=
bdi/9:127'
> [ 9627.630033] Modules linked in: xt_tcpudp iptable_filter ip_tables x_ta=
bles nfsd nfs lockd grace sunrpc ipmi_devintf netconsole configfs loop hid_=
generic usbhid hid x86_pkg_temp_thermal coretemp ghash_clmulni_intel aesni_=
intel ioatdma ehci_pci aes_x86_64 iTCO_wdt iTCO_ve
> [ 9627.630074] CPU: 18 PID: 3330 Comm: mdadm Not tainted 4.0.0bl-azat-v6+=
 #1
> [ 9627.630076] Hardware name: Supermicro X9DRD-7LN4F(-JBOD)/X9DRD-EF/X9DR=
D-7LN4F, BIOS 3.0a 12/05/2013
> [ 9627.630077]  0000000000000000 ffffffff814e3fcc ffffffff813e590f ffff88=
5f9bcd3808
> [ 9627.630079]  ffffffff8104575c ffff885f96acb000 ffff885fa4b3e3c0 ffff88=
5fa2fec780
> [ 9627.630081]  ffff885fa4bc4000 0000000000000000 ffffffff810457d5 ffffff=
ff814e5d78
> [ 9627.630083] Call Trace:
> [ 9627.630091]  [<ffffffff813e590f>] ? dump_stack+0x40/0x50
> [ 9627.630096]  [<ffffffff8104575c>] ? warn_slowpath_common+0x7c/0xb0
> [ 9627.630098]  [<ffffffff810457d5>] ? warn_slowpath_fmt+0x45/0x50
> [ 9627.630100]  [<ffffffff81185092>] ? kernfs_path+0x42/0x50
> [ 9627.630102]  [<ffffffff811883da>] ? sysfs_warn_dup+0x5a/0x70
> [ 9627.630104]  [<ffffffff8118846e>] ? sysfs_create_dir_ns+0x7e/0x90
> [ 9627.630108]  [<ffffffff811d94ab>] ? kobject_add_internal+0x9b/0x2f0
> [ 9627.630109]  [<ffffffff811d9af6>] ? kobject_add+0x66/0xb0
> [ 9627.630114]  [<ffffffff812bb2e3>] ? device_add+0x263/0x620
> [ 9627.630116]  [<ffffffff812bb8a8>] ? device_create_groups_vargs+0xe8/0x=
100
> [ 9627.630118]  [<ffffffff812bb8d3>] ? device_create_vargs+0x13/0x20
> [ 9627.630124]  [<ffffffff810ed128>] ? bdi_register+0x68/0x150
> [ 9627.630129]  [<ffffffff811c535d>] ? add_disk+0x14d/0x4a0
> [ 9627.630132]  [<ffffffff811c585f>] ? alloc_disk_node+0xaf/0x100
> [ 9627.630137]  [<ffffffffa0252269>] ? md_alloc+0x1e9/0x350 [md_mod]
> [ 9627.630141]  [<ffffffffa02523db>] ? md_probe+0xb/0x20 [md_mod]
> [ 9627.630143]  [<ffffffff812c0654>] ? kobj_lookup+0x104/0x170
> [ 9627.630147]  [<ffffffffa02523d0>] ? md_alloc+0x350/0x350 [md_mod]
> [ 9627.630149]  [<ffffffff811c4da8>] ? get_gendisk+0x28/0xf0
> [ 9627.630153]  [<ffffffff8115fb74>] ? __blkdev_get+0x114/0x3c0
> [ 9627.630156]  [<ffffffff8115e590>] ? bdev_direct_access+0xa0/0xa0
> [ 9627.630158]  [<ffffffff8115e5a0>] ? bdev_test+0x10/0x10
> [ 9627.630160]  [<ffffffff8115fe58>] ? blkdev_get+0x38/0x310
> [ 9627.630162]  [<ffffffff81160170>] ? blkdev_get_by_dev+0x40/0x40
> [ 9627.630167]  [<ffffffff8112b3d3>] ? do_dentry_open.isra.16+0x153/0x320
> [ 9627.630170]  [<ffffffff811380f3>] ? do_last.isra.51+0x323/0xd50
> [ 9627.630172]  [<ffffffff8111f5b3>] ? kmem_cache_alloc+0x123/0x130
> [ 9627.630174]  [<ffffffff8113a97f>] ? path_openat+0x7f/0x610
> [ 9627.630177]  [<ffffffff810f7480>] ? tlb_flush_mmu_free+0x30/0x50
> [ 9627.630180]  [<ffffffff810fe800>] ? unmap_region+0xb0/0xf0
> [ 9627.630182]  [<ffffffff8113bb3b>] ? do_filp_open+0x2b/0x90
> [ 9627.630187]  [<ffffffff811472ec>] ? __alloc_fd+0x7c/0x120
> [ 9627.630189]  [<ffffffff8112c531>] ? do_sys_open+0x121/0x210
> [ 9627.630193]  [<ffffffff813ea097>] ? system_call_fastpath+0x12/0x6a
> [ 9627.630195] ---[ end trace b7a3e9c6f05c2666 ]---
> [ 9627.630196] ------------[ cut here ]------------
> [ 9627.630198] WARNING: CPU: 18 PID: 3330 at lib/kobject.c:240 kobject_ad=
d_internal+0x274/0x2f0()
> [ 9627.630200] kobject_add_internal failed for 9:127 with -EEXIST, don't =
try to register things with the same name in the same directory.
> [ 9627.630201] Modules linked in: xt_tcpudp iptable_filter ip_tables x_ta=
bles nfsd nfs lockd grace sunrpc ipmi_devintf netconsole configfs loop hid_=
generic usbhid hid x86_pkg_temp_thermal coretemp ghash_clmulni_intel aesni_=
intel ioatdma ehci_pci aes_x86_64 iTCO_wdt iTCO_ve
> [ 9627.630223] CPU: 18 PID: 3330 Comm: mdadm Tainted: G        W       4.=
0.0bl-azat-v6+ #1
> [ 9627.630224] Hardware name: Supermicro X9DRD-7LN4F(-JBOD)/X9DRD-EF/X9DR=
D-7LN4F, BIOS 3.0a 12/05/2013
> [ 9627.630225]  0000000000000000 ffffffff814f2c88 ffffffff813e590f ffff88=
5f9bcd3858
> [ 9627.630227]  ffffffff8104575c ffff885fa4bc4010 00000000ffffffef ffff88=
5fa473f420
> [ 9627.630229]  ffff885fa4bc4000 0000000000000000 ffffffff810457d5 ffffff=
ff814f2e48
> [ 9627.630230] Call Trace:
> [ 9627.630233]  [<ffffffff813e590f>] ? dump_stack+0x40/0x50
> [ 9627.630235]  [<ffffffff8104575c>] ? warn_slowpath_common+0x7c/0xb0
> [ 9627.630236]  [<ffffffff810457d5>] ? warn_slowpath_fmt+0x45/0x50
> [ 9627.630238]  [<ffffffff8118846e>] ? sysfs_create_dir_ns+0x7e/0x90
> [ 9627.630240]  [<ffffffff811d9684>] ? kobject_add_internal+0x274/0x2f0
> [ 9627.630242]  [<ffffffff811d9af6>] ? kobject_add+0x66/0xb0
> [ 9627.630244]  [<ffffffff812bb2e3>] ? device_add+0x263/0x620
> [ 9627.630245]  [<ffffffff812bb8a8>] ? device_create_groups_vargs+0xe8/0x=
100
> [ 9627.630247]  [<ffffffff812bb8d3>] ? device_create_vargs+0x13/0x20
> [ 9627.630250]  [<ffffffff810ed128>] ? bdi_register+0x68/0x150
> [ 9627.630252]  [<ffffffff811c535d>] ? add_disk+0x14d/0x4a0
> [ 9627.630255]  [<ffffffff811c585f>] ? alloc_disk_node+0xaf/0x100
> [ 9627.630258]  [<ffffffffa0252269>] ? md_alloc+0x1e9/0x350 [md_mod]
> [ 9627.630261]  [<ffffffffa02523db>] ? md_probe+0xb/0x20 [md_mod]
> [ 9627.630262]  [<ffffffff812c0654>] ? kobj_lookup+0x104/0x170
> [ 9627.630266]  [<ffffffffa02523d0>] ? md_alloc+0x350/0x350 [md_mod]
> [ 9627.630268]  [<ffffffff811c4da8>] ? get_gendisk+0x28/0xf0
> [ 9627.630270]  [<ffffffff8115fb74>] ? __blkdev_get+0x114/0x3c0
> [ 9627.630272]  [<ffffffff8115e590>] ? bdev_direct_access+0xa0/0xa0
> [ 9627.630274]  [<ffffffff8115e5a0>] ? bdev_test+0x10/0x10
> [ 9627.630276]  [<ffffffff8115fe58>] ? blkdev_get+0x38/0x310
> [ 9627.630278]  [<ffffffff81160170>] ? blkdev_get_by_dev+0x40/0x40
> [ 9627.630280]  [<ffffffff8112b3d3>] ? do_dentry_open.isra.16+0x153/0x320
> [ 9627.630282]  [<ffffffff811380f3>] ? do_last.isra.51+0x323/0xd50
> [ 9627.630283]  [<ffffffff8111f5b3>] ? kmem_cache_alloc+0x123/0x130
> [ 9627.630285]  [<ffffffff8113a97f>] ? path_openat+0x7f/0x610
> [ 9627.630287]  [<ffffffff810f7480>] ? tlb_flush_mmu_free+0x30/0x50
> [ 9627.630289]  [<ffffffff810fe800>] ? unmap_region+0xb0/0xf0
> [ 9627.630291]  [<ffffffff8113bb3b>] ? do_filp_open+0x2b/0x90
> [ 9627.630293]  [<ffffffff811472ec>] ? __alloc_fd+0x7c/0x120
> [ 9627.630295]  [<ffffffff8112c531>] ? do_sys_open+0x121/0x210
> [ 9627.630297]  [<ffffffff813ea097>] ? system_call_fastpath+0x12/0x6a
> [ 9627.630298] ---[ end trace b7a3e9c6f05c2667 ]---
> [ 9627.630395] BUG: unable to handle kernel NULL pointer dereference at 0=
000000000000040
> [ 9627.630430] IP: [<ffffffff8118869a>] sysfs_do_create_link_sd.isra.2+0x=
2a/0xb0
> [ 9627.630524] PGD 5fa2d03067 PUD 5f9d679067 PMD 0=20
> [ 9627.630550] Oops: 0000 [#1] SMP=20
> [ 9627.630624] Modules linked in: xt_tcpudp iptable_filter ip_tables x_ta=
bles nfsd nfs lockd grace sunrpc ipmi_devintf netconsole configfs loop hid_=
generic usbhid hid x86_pkg_temp_thermal coretemp ghash_clmulni_intel aesni_=
intel ioatdma ehci_pci aes_x86_64 iTCO_wdt iTCO_ve
> [ 9627.631073] CPU: 18 PID: 3330 Comm: mdadm Tainted: G        W       4.=
0.0bl-azat-v6+ #1
> [ 9627.631090] Hardware name: Supermicro X9DRD-7LN4F(-JBOD)/X9DRD-EF/X9DR=
D-7LN4F, BIOS 3.0a 12/05/2013
> [ 9627.631109] task: ffff885fa4659f00 ti: ffff885f9bcd0000 task.ti: ffff8=
85f9bcd0000
> [ 9627.631124] RIP: 0010:[<ffffffff8118869a>]  [<ffffffff8118869a>] sysfs=
_do_create_link_sd.isra.2+0x2a/0xb0
> [ 9627.631162] RSP: 0018:ffff885f9bcd3a78  EFLAGS: 00010246
> [ 9627.631189] RAX: 000000000000e6e6 RBX: 0000000000000040 RCX: 000000000=
00000e6
> [ 9627.631219] RDX: ffffffff814e19d0 RSI: 0000000000000040 RDI: ffffffff8=
1740d88
> [ 9627.631249] RBP: ffffffff814e19d0 R08: 0000000000017d60 R09: ffff88607=
fcd7d60
> [ 9627.631278] R10: ffff882fbf802400 R11: ffffea017e830e00 R12: 000000000=
0000001
> [ 9627.631308] R13: ffff885fa5a61ca8 R14: ffff885fa4bc3c70 R15: ffff885fa=
4bc3c00
> [ 9627.631338] FS:  00007f439e991700(0000) GS:ffff88607fcc0000(0000) knlG=
S:0000000000000000
> [ 9627.631383] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 9627.631411] CR2: 0000000000000040 CR3: 0000005f9fe22000 CR4: 000000000=
01407e0
> [ 9627.631440] Stack:
> [ 9627.631460]  ffff885fa4bc3c00 ffff885f9bf41428 ffff885fa4bc3c0c ffff88=
5fa4bc3c80
> [ 9627.631515]  ffff885fa4bc3c70 ffffffff811c53f3 ffff885fa4bc3c00 ffffff=
ff00000018
> [ 9627.631569]  0090007f9bcd3b08 ffff885fa4bc3c00 0000000000000000 000000=
0000000001
> [ 9627.631680] Call Trace:
> [ 9627.631703]  [<ffffffff811c53f3>] ? add_disk+0x1e3/0x4a0
> [ 9627.631733]  [<ffffffffa0252269>] ? md_alloc+0x1e9/0x350 [md_mod]
> [ 9627.631763]  [<ffffffffa02523db>] ? md_probe+0xb/0x20 [md_mod]
> [ 9627.631791]  [<ffffffff812c0654>] ? kobj_lookup+0x104/0x170
> [ 9627.631820]  [<ffffffffa02523d0>] ? md_alloc+0x350/0x350 [md_mod]
> [ 9627.631849]  [<ffffffff811c4da8>] ? get_gendisk+0x28/0xf0
> [ 9627.631877]  [<ffffffff8115fb74>] ? __blkdev_get+0x114/0x3c0
> [ 9627.631905]  [<ffffffff8115e590>] ? bdev_direct_access+0xa0/0xa0
> [ 9627.631933]  [<ffffffff8115e5a0>] ? bdev_test+0x10/0x10
> [ 9627.631961]  [<ffffffff8115fe58>] ? blkdev_get+0x38/0x310
> [ 9627.631988]  [<ffffffff81160170>] ? blkdev_get_by_dev+0x40/0x40
> [ 9627.632017]  [<ffffffff8112b3d3>] ? do_dentry_open.isra.16+0x153/0x320
> [ 9627.632046]  [<ffffffff811380f3>] ? do_last.isra.51+0x323/0xd50
> [ 9627.632075]  [<ffffffff8111f5b3>] ? kmem_cache_alloc+0x123/0x130
> [ 9627.632103]  [<ffffffff8113a97f>] ? path_openat+0x7f/0x610
> [ 9627.632131]  [<ffffffff810f7480>] ? tlb_flush_mmu_free+0x30/0x50
> [ 9627.632159]  [<ffffffff810fe800>] ? unmap_region+0xb0/0xf0
> [ 9627.632186]  [<ffffffff8113bb3b>] ? do_filp_open+0x2b/0x90
> [ 9627.632215]  [<ffffffff811472ec>] ? __alloc_fd+0x7c/0x120
> [ 9627.632242]  [<ffffffff8112c531>] ? do_sys_open+0x121/0x210
> [ 9627.632270]  [<ffffffff813ea097>] ? system_call_fastpath+0x12/0x6a
> [ 9627.632298] Code: 00 48 85 d2 74 73 48 85 ff 74 6e 41 56 41 55 49 89 f=
d 41 54 55 48 c7 c7 88 0d 74 81 53 48 89 f3 41 89 cc 48 89 d5 e8 76 15 26 0=
0 <48> 8b 1b 48 85 db 74 08 48 89 df e8 f6 c9 ff ff 80 05 d7 86 5b=20
> [ 9627.632557] RIP  [<ffffffff8118869a>] sysfs_do_create_link_sd.isra.2+0=
x2a/0xb0
> [ 9627.632604]  RSP <ffff885f9bcd3a78>
> [ 9627.632627] CR2: 0000000000000040
> [ 9627.633014] ---[ end trace b7a3e9c6f05c2668 ]---
>=20
> Any assumptions?


--Sig_/cvMwMeTpcQUpTPqGviejswq
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVTiLvznsnt1WYoG5AQJ0GhAAqtsqAdfY3eJUrxiTLJYFrVgsrj7w3Z9t
o3+yLzz+8ZrElZPyoywCzLnAPUqGn8FvkX0i+nIug/DXzC+MKEo9f/ZnTy2ka4F4
yj7mKOwLCNsdYpL8OlvAspqQNRYmyPglkFTPWvIg4CKfa2JkbvtUfVjjxi9/Og4R
2YVVyYuCYZJiUUTzcrT1LDPwBr36LJzlMJKm7NDlyCpY4BX7R4lhx4J+eGPz8QMq
NvRFDjqTwIlC/UQxiMvGhb864x8Ys5SbXR11lq8TezIR2R4QBc0OK4IyMO0WhpxR
4RhLpH+lQYhufGHQwjJiPv7x+WneQUrZQAm8eNjO+Oig2K3F9G/hgYc9M4a2RdhK
DJI9jNNtvmSnmiHT3r63Tx13WIdxo7Z/dskOHbXGWQcH/HTaA1pEYcCIzPqi+ax6
7cPqv300ikj5upelsEIp6oxenOxXfnrNT3YlIMNbuFVmZRVWTog/s5WsqUG5BTMn
Kaup3EUVRchd8DKZGhxTHEGm4GQVh/TO6wRqJHRBqAKbsptKGpGS2FkZcizUxmwk
U9Y6kHvirww8R3G60cm7buiwSrQhQApYk13NNgksGXQj+5Vj4rmM7MPamcue6DkA
+cnv8l9ijOCI8+UijEaX30vBtjIWvs8Jgpc4mETQZLuGihm5FB66bVlfL4KjTRT3
41We6GVp2rg=
=1WlA
-----END PGP SIGNATURE-----

--Sig_/cvMwMeTpcQUpTPqGviejswq--
