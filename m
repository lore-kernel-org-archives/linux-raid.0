From: NeilBrown <neilb@suse.de>
Subject: Re: raid5: R5_WriteError is not cleared after rdev is marked as
 Faulty
Date: Mon, 6 Jan 2014 13:15:05 +1100
Message-ID: <20140106131505.0ee4c490@notabene.brown>
References: <CAGRgLy6w=_nspVHu9YF9JHz3ADc5CkGL5N0bv6TGgopUpeaxGw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/VVs7AO2L4UWRuHLYze+Pgsr"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy6w=_nspVHu9YF9JHz3ADc5CkGL5N0bv6TGgopUpeaxGw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/VVs7AO2L4UWRuHLYze+Pgsr
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 2 Jan 2014 17:58:33 +0200 Alexander Lyakas <alex.bolshoy@gmail.com>
wrote:

> Hi Neil,
> I see the following issue: if more than one stripe-head experiences an
> error in raid5_end_write_request, then when first stripe-head is
> handled, it eventually fails the disk, but when the second stripe-head
> is handled, disk is already marked as Faulty, so R5_WriteError is not
> cleared from this second stripe-head, but it still remains in the
> stripe cache.
>=20
> Below are more details on the flow. I added some prints to display the
> flags values etc.
>=20
> # raid6 is rebuilding a disk
>=20
> # disk fails, as a result, raid5_end_write_request is called on two
> stripe-heads:
> [23369]md48066*[raid5_end_write_request:2002] sh[4560].flags=3D0x101A
> dev[0].flags=3D0x20003 rdev[dm-6].flags=3D0x40
> bio=3Dffff880028744fd8[4592(4560):8] WRITE ERROR
> [13527.467363] [3842]md48066*[raid5_end_write_request:2002]
> sh[4568].flags=3D0x101B dev[0].flags=3D0x20003 rdev[dm-6].flags=3D0x240
> bio=3Dffff880028742bc0[4600(4568):8] WRITE ERROR
>=20
> As a result, appropriate r5dev's are marked with R5_WriteError on
> these two stripe-heads.
>=20
> # raid5 calls analyse_stripe on behalf of stripe-head 4560 ((through
> handle_active_stripes->handle_stripe->analyse_stripe)
>=20
> # analyse_stripe performs this code:
>         if (rdev && test_bit(R5_WriteError, &dev->flags)) {
>             /* This flag does not apply to '.replacement'
>              * only to .rdev, so make sure to check that*/
>             struct md_rdev *rdev2 =3D rcu_dereference(
>                 conf->disks[i].rdev);
>             if (rdev2 =3D=3D rdev)
>                 clear_bit(R5_Insync, &dev->flags);
>             if (rdev2 && !test_bit(Faulty, &rdev2->flags)) {
>                 s->handle_bad_blocks =3D 1;
> it clears the R5_WriteError and sets handle_bad_blocks on the stripe-head
>=20
> # handle_stripe performs:
>     if (s.handle_bad_blocks)
>         for (i =3D disks; i--; ) {
>             struct md_rdev *rdev;
>             struct r5dev *dev =3D &sh->dev[i];
>             if (test_and_clear_bit(R5_WriteError, &dev->flags)) {
>                 /* We own a safe reference to the rdev */
>                 rdev =3D conf->disks[i].rdev;
>                 if (!rdev_set_badblocks(rdev, sh->sector,
>                             STRIPE_SECTORS, 0))
>                     md_error(conf->mddev, rdev);
> this marks the rdev as Faulty and fails it (bad blocks are disabled)
>=20
> # raid5d calls analyse_stripe on stripe-head 4568. However, rdev is
> already marked as Faulty, so it does:
>         if (rdev && test_bit(Faulty, &rdev->flags))
>             rdev =3D NULL;
> and later this condition does not hold:
> if (rdev && test_bit(R5_WriteError, &dev->flags)) {
> so R5_WriteError is not cleared, but this stripe-head is still valid
> in the stripe cache.
>=20
> Dumping the state of this stripe-head in the stripe-cache (through
> custom sysfs entry):
> sh[4568].state=3D0x1010 disks=3D5 pdidx=3D2 qdidx=3D3
>   dev[0].flags=3D0x20001 rdev[???].flags=3D0x0 (sector=3D13688)
>   dev[1].flags=3D0x11 rdev[dm-7].flags=3D0x2 (sector=3D13720)
>   dev[2].flags=3D0x11 rdev[dm-8].flags=3D0x2 (sector=3D0) *P*
>   dev[3].flags=3D0x11 rdev[dm-9].flags=3D0x2 (sector=3D0) *Q*
>   dev[4].flags=3D0x11 rdev[dm-10].flags=3D0x2 (sector=3D13656)
>=20
> # Now user recovers the disk and re-adds the disk back into the array.
> Rebuild starts, and eventually md_do_sync calls sync_request on this
> stripe-head, which calls handle_stripe->analyse_stripe. Now
> analyse_stripe sees the stale R5_WriteError flag and fails the disk,
> which aborts the rebuild. Here is the stack trace, which detects the
> stale R5_WriteError and fails the disk:
> [<ffffffffa02d4543>] error+0x153/0x1d0 [raid456]
> [<ffffffffa0445449>] md_error.part.39+0x19/0xa0 [md_mod]
> [<ffffffffa0445503>] md_error+0x33/0x60 [md_mod]
> [<ffffffffa02da07c>] handle_stripe+0x57c/0x2250 [raid456]
> [<ffffffffa02dcacb>] sync_request+0x18b/0x390 [raid456]
> [<ffffffffa044320c>] md_do_sync+0x76c/0xda0 [md_mod]
> [<ffffffffa044084d>] md_thread+0x10d/0x140 [md_mod]
>=20
> Does this analysis make sense? I don't know how to fix issue though. I
> am looking at kernel (3.8.13 - as usual), but looking at your
> for-linus branch, it seems like the same would happen.
>=20

Looks like:

commit 5d8c71f9e5fbdd95650be00294d238e27a363b5c
Author: Adam Kwolek <adam.kwolek@intel.com>
Date:   Fri Dec 9 14:26:11 2011 +1100

    md: raid5 crash during degradation


introduced this problem (in linux 3.3) with an over-simple fix for a proble=
m.

I think that we can not just reverted that patch as

commit 14a75d3e07c784c004b4b44b34af996b8e4ac453
Author: NeilBrown <neilb@suse.de>
Date:   Fri Dec 23 10:17:52 2011 +1100

    md/raid5: preferentially read from replacement device if possible.


has effected a better fix.
So the patch below should work.  Does that make sense to you?

Thanks,
NeilBrown

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index cc055da02e2a..9168173deaf3 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3608,7 +3608,7 @@ static void analyse_stripe(struct stripe_head *sh, st=
ruct stripe_head_state *s)
 			 */
 			set_bit(R5_Insync, &dev->flags);
=20
-		if (rdev && test_bit(R5_WriteError, &dev->flags)) {
+		if (test_bit(R5_WriteError, &dev->flags)) {
 			/* This flag does not apply to '.replacement'
 			 * only to .rdev, so make sure to check that*/
 			struct md_rdev *rdev2 =3D rcu_dereference(
@@ -3621,7 +3621,7 @@ static void analyse_stripe(struct stripe_head *sh, st=
ruct stripe_head_state *s)
 			} else
 				clear_bit(R5_WriteError, &dev->flags);
 		}
-		if (rdev && test_bit(R5_MadeGood, &dev->flags)) {
+		if (test_bit(R5_MadeGood, &dev->flags)) {
 			/* This flag does not apply to '.replacement'
 			 * only to .rdev, so make sure to check that*/
 			struct md_rdev *rdev2 =3D rcu_dereference(

--Sig_/VVs7AO2L4UWRuHLYze+Pgsr
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUsoRqTnsnt1WYoG5AQID1g/+OIXEmhyENDRI37vwcu3hVMSD6HAMGoXw
gcp/H7uEThKeoq3PX5K2VRAyzxS5c2wIIeOm2f0kOqjlmelVUZVlZ4PL7hacJ4IZ
gdl5bW193uuprlrCh532xuZxuh3KZ4MVtg4TUh9kXbCjxGp8Yz3hhBRc3mFx9L/4
BHRlZOz3M8Rjwnv3bryMmQnsKQMJiWoLumFG2WvUOR9YPRkfPoDNRsinC+N3xThn
EnDcCmg3tFRZ5WbCsPiE3Na2+V/0X7wIUzsAVg1P37TvPW3oF5qD6Xx9JI7Rxsir
lnkX5wwjS919DQo0e+62bSx6cIBK/0Sj12w74uzPx7qk9772X8RxX2wpS9rVuWVK
sCqPiFMZsh+w0C62Vo38oiM6JtNm3H5ZF46/2VfNfZmni2SuFbY+OWX2TSJ70Lbv
Utj4EKpmK8FRgJhaeIFfI6hWGcqjYV/mxwNPfSs7uODcPNdJ5cPhWg7i9BTc8xWM
c0EcTPPa4GV1egzANOKjg92ZmXUltavhkm5WSLzn9P3dykSz1Il3a1vdtVg4Hncb
O42Dk0515cj0Im7sIK3EhwMSIhEBxHWImznpyTFoDe/3WmUwz5mWzZ/xlVTsv86d
rtaXTpJT+B3Vn8+bDmfWgU8dDl6i77Qxf7nykROM+6S12ZUvYJTNpnCszYDMutjY
pIC9C45d8bc=
=iZjb
-----END PGP SIGNATURE-----

--Sig_/VVs7AO2L4UWRuHLYze+Pgsr--
