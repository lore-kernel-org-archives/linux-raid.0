From: NeilBrown <neilb@suse.de>
Subject: Re: raid5 lockups post ca64cae96037de16e4af92678814f5d4bf0c1c65
Date: Wed, 6 Mar 2013 13:18:04 +1100
Message-ID: <20130306131804.0b39752a@notabene.brown>
References: <wrfj1ubvi88x.fsf@redhat.com>
	<20130305080010.6285b435@notabene.brown>
	<wrfjlia2fd6h.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/3KbmdIprr69NvcRB0c+MHSo"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <wrfjlia2fd6h.fsf@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-raid@vger.kernel.org, Shaohua Li <shli@kernel.org>
List-Id: linux-raid.ids

--Sig_/3KbmdIprr69NvcRB0c+MHSo
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 05 Mar 2013 09:44:54 +0100 Jes Sorensen <Jes.Sorensen@redhat.com>
wrote:

> NeilBrown <neilb@suse.de> writes:
> > On Mon, 04 Mar 2013 14:50:54 +0100 Jes Sorensen <Jes.Sorensen@redhat.co=
m>
> > wrote:
> >
> >> Hi,
> >>=20
> >> I have been hitting raid5 lockups with recent kernels. A bunch of
> >> bisecting narrowed it down to be caused by this commit:
> >>=20
> >> ca64cae96037de16e4af92678814f5d4bf0c1c65
> >>=20
> >> So far I can only reproduce the problem when running a test script
> >> creating raid5 arrays on top of loop devices and then running mkfs on
> >> those. I haven't managed to reproduce it on real disk devices yet, but=
 I
> >> suspect it is possible too.
> >>=20
> >> Basically it looks like a race condition where R5_LOCKED doesn't get
> >> cleared for the device, however it is unclear to me how we get to that
> >> point. Since I am not really deeply familiar with the discard related
> >> changes, I figured someone might have a better idea what could go wron=
g.
> >>=20
> >> Cheers,
> >> Jes
> >>=20
> >>=20
> >>=20
> >> [ 4799.312280] sector=3D97f8 i=3D1 (null) (null) (null) ffff88022f5963=
c0
> >> 0
> >> [ 4799.322174] ------------[ cut here ]------------
> >> [ 4799.327330] WARNING: at drivers/md/raid5.c:352
> >> init_stripe+0x2d2/0x360 [raid456]()
> >> [ 4799.335775] Hardware name: S1200BTL
> >> [ 4799.339668] Modules linked in: raid456 async_raid6_recov
> >> async_memcpy async_pq raid6_pq async_xor xor async_tx lockd sunrpc
> >> bnep bluetooth rfkill sg coretemp e1000e raid1 dm_mirror kvm_intel
> >> kvm crc32c_intel iTCO_wdt iTCO_vendor_support dm_region_hash
> >> ghash_clmulni_intel lpc_ich dm_log dm_mod mfd_core i2c_i801 video
> >> pcspkr microcode uinput xfs usb_storage mgag200 i2c_algo_bit
> >> drm_kms_helper ttm drm i2c_core mpt2sas raid_class
> >> scsi_transport_sas [last unloaded: raid456]
> >> [ 4799.386633] Pid: 8204, comm: mkfs.ext4 Not tainted 3.7.0-rc1+ #17
> >> [ 4799.393431] Call Trace:
> >> [ 4799.396163]  [<ffffffff810602ff>] warn_slowpath_common+0x7f/0xc0
> >> [ 4799.402868]  [<ffffffff8106035a>] warn_slowpath_null+0x1a/0x20
> >> [ 4799.409375]  [<ffffffffa0423b92>] init_stripe+0x2d2/0x360 [raid456]
> >> [ 4799.416368]  [<ffffffffa042400b>] get_active_stripe+0x3eb/0x480 [ra=
id456]
> >> [ 4799.423944]  [<ffffffffa0427beb>] make_request+0x3eb/0x6b0 [raid456]
> >> [ 4799.431037]  [<ffffffff81084210>] ? wake_up_bit+0x40/0x40
> >> [ 4799.437062]  [<ffffffff814a6633>] md_make_request+0xc3/0x200
> >> [ 4799.443379]  [<ffffffff81134655>] ? mempool_alloc_slab+0x15/0x20
> >> [ 4799.450082]  [<ffffffff812c70d2>] generic_make_request+0xc2/0x110
> >> [ 4799.456881]  [<ffffffff812c7199>] submit_bio+0x79/0x160
> >> [ 4799.462714]  [<ffffffff811ca625>] ? bio_alloc_bioset+0x65/0x120
> >> [ 4799.469321]  [<ffffffff812ce234>] blkdev_issue_discard+0x184/0x240
> >> [ 4799.476218]  [<ffffffff812cef76>] blkdev_ioctl+0x3b6/0x810
> >> [ 4799.482338]  [<ffffffff811cb971>] block_ioctl+0x41/0x50
> >> [ 4799.488170]  [<ffffffff811a6aa9>] do_vfs_ioctl+0x99/0x580
> >> [ 4799.494185] [<ffffffff8128a19a>] ?
> >> inode_has_perm.isra.30.constprop.60+0x2a/0x30
> >> [ 4799.502535]  [<ffffffff8128b6d7>] ? file_has_perm+0x97/0xb0
> >> [ 4799.508755]  [<ffffffff811a7021>] sys_ioctl+0x91/0xb0
> >> [ 4799.514384]  [<ffffffff810de9dc>] ? __audit_syscall_exit+0x3ec/0x450
> >> [ 4799.521475]  [<ffffffff8161e759>] system_call_fastpath+0x16/0x1b
> >> [ 4799.528177] ---[ end trace 583fffce97b9ddd9 ]---
> >> [ 4799.533327] sector=3D97f8 i=3D0 (null) (null) (null) ffff88022f5963=
c0
> >> 0
> >> [ 4799.543227] ------------[ cut here ]------------
> >
> > Does this fix it?
> >
> > NeilBrown
>=20
> Unfortunately no, I still see these crashes with this one applied :(
>=20

Thanks - the symptom looked  similar, but now that I look more closely I can
see it is quite different.

How about this then?  I can't really see what is happening, but based on the
patch that you identified it must be related to these flags.
It seems that handle_stripe_clean_event() is being called to early, and it
doesn't clear out the ->written bios because they are still locked or
something.  But it does clear R5_Discard on the parity block, so
handle_stripe_clean_event doesn't get called again.

This makes the handling of the various flags somewhat more uniform, which is
probably a good thing.

Thanks for testing,
NeilBrown




diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 277d9c2..a005dcc 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1246,8 +1246,7 @@ static void ops_complete_reconstruct(void *stripe_hea=
d_ref)
 		struct r5dev *dev =3D &sh->dev[i];
=20
 		if (dev->written || i =3D=3D pd_idx || i =3D=3D qd_idx) {
-			if (!discard)
-				set_bit(R5_UPTODATE, &dev->flags);
+			set_bit(R5_UPTODATE, &dev->flags);
 			if (fua)
 				set_bit(R5_WantFUA, &dev->flags);
 			if (sync)
@@ -2784,8 +2783,7 @@ static void handle_stripe_clean_event(struct r5conf *=
conf,
 		if (sh->dev[i].written) {
 			dev =3D &sh->dev[i];
 			if (!test_bit(R5_LOCKED, &dev->flags) &&
-			    (test_bit(R5_UPTODATE, &dev->flags) ||
-			     test_bit(R5_Discard, &dev->flags))) {
+			    test_bit(R5_UPTODATE, &dev->flags)) {
 				/* We can return any write requests */
 				struct bio *wbi, *wbi2;
 				pr_debug("Return write for disc %d\n", i);
@@ -2808,8 +2806,11 @@ static void handle_stripe_clean_event(struct r5conf =
*conf,
 					 !test_bit(STRIPE_DEGRADED, &sh->state),
 						0);
 			}
-		} else if (test_bit(R5_Discard, &sh->dev[i].flags))
-			clear_bit(R5_Discard, &sh->dev[i].flags);
+		} else if (!test_bit(R5_LOCKED, &sh->dev[i].flags) &&
+			   test_bit(R5_UPTODATE, &sh->dev[i].flags)) {
+			if (test_and_clear_bit(R5_Discard, &dev->flags))
+				clear_bit(R5_UPTODATE, &dev->flags);
+		}
=20
 	if (test_and_clear_bit(STRIPE_FULL_WRITE, &sh->state))
 		if (atomic_dec_and_test(&conf->pending_full_writes))

--Sig_/3KbmdIprr69NvcRB0c+MHSo
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUTanXDnsnt1WYoG5AQJUtg//amjNoPHBipfQx4xVMFk8sXUf1WQbiV8b
vTYRaD/xfAFcDJY+eio8WArSBekJMGIjbyFIleABdfFOPDPpeHvdozePo8ULJn1O
wocPtVa/IQg4I88cdWxfQqwxDwBXnHLx+wDUTLdvmSC7NEOfwNcQPa7p7Xy78a5l
B7gry+kHtIPZXk+BlSjsUsDZ1Agz9r0/bW94KUUNvcWlOQPgB/8wZUoQ6s7eka1X
zipB2BRsXoBcvSBs4HsF2x+tpIvNpuV2xJ3N4LBlcxABtZHO3dcTc+xky+AIeipq
cEF3BkpwVUrCbUa98PEpOh8NeoOThwawL7oDxexmTXamSHslm/YjXco+PLuGKX4S
F/3yRbeciZcUjyxoHjQtl+MBCbBvnYKzKHanO2C+M90X7cXv96ZPTIU9XCjbuRqN
CAw5qDiMjrWu2CzoLb+ZxI/STd6aVIU+kFIxwqM79i5Gw9aI4CHF/ReHfq1cCBPd
u3mYHjJejUROSdqYhNOK7LDOWo9cp4bZZFGzutC+PRxj5aqJz+48Yy4dgqslaOTi
O+k4pNZbL3fvuanQ4WyJCpNTSHb23978dXe6cWh4P/rE1PS2pw4i09ugRh/4dK1Y
SrkLr6BGoLqkVWNrZjkhm8oGuzzDJVhhhMFtoGrG6Um390PjhjF2luobuJWi7VcY
cmtAUyCtyOQ=
=M8pK
-----END PGP SIGNATURE-----

--Sig_/3KbmdIprr69NvcRB0c+MHSo--
