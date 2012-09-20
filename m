From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH - v2] DM RAID: Fix for ineffective "sync" directive
Date: Thu, 20 Sep 2012 12:35:25 +1000
Message-ID: <20120920123525.282c04da@notabene.brown>
References: <1345735914.25206.8.camel@f16>
	<1347648483.27926.8.camel@f16>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Wxy2j6=qJ5rlSU77.X64WUu"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1347648483.27926.8.camel@f16>
Sender: linux-raid-owner@vger.kernel.org
To: Jonathan Brassow <jbrassow@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/Wxy2j6=qJ5rlSU77.X64WUu
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 14 Sep 2012 13:48:03 -0500 Jonathan Brassow <jbrassow@redhat.com>
wrote:

> Neil,
>=20
> I've taken your suggestion to not muck around with the BITMAP_STALE, and
> instead simply clear the superblocks as a whole when the "sync"
> directive is given.
>=20
>  brassow
>=20
> DM RAID: Fix for "sync" directive ineffectiveness
>=20
> There are two table arguments that can be given to a DM RAID target that
> control whether the array is forced to (re)synchronize or skip initializa=
tion:
> "sync" and "nosync".  When "sync" is given, we set mddev->recovery_cp to 0
> in order to cause the device to resynchronize.  This is insufficient if t=
here
> is a bitmap in use, because the array will simply look at the bitmap and =
see
> that there is no recovery necessary.
>=20
> The fix is to skip over the loading of the superblocks when "sync" is giv=
en,
> causing new superblocks to be written that will force the array to go thr=
ough
> initialization (i.e. synchronization).
>=20
> Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
>=20
> Index: linux-upstream/drivers/md/dm-raid.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-upstream.orig/drivers/md/dm-raid.c
> +++ linux-upstream/drivers/md/dm-raid.c
> @@ -960,6 +960,19 @@ static int analyse_superblocks(struct dm
> =20
>  	freshest =3D NULL;
>  	rdev_for_each_safe(rdev, tmp, mddev) {
> +		/*
> +		 * Skipping super_load due to DMPF_SYNC will cause
> +		 * the array to undergo initialization again as
> +		 * though it were new.  This is the intended effect
> +		 * of the "sync" directive.
> +		 *
> +		 * When reshaping capability is added, we must ensure
> +		 * that the "sync" directive is disallowed during the
> +		 * reshape.
> +		 */
> +		if (rs->print_flags & DMPF_SYNC)
> +			continue;
> +
>  		if (!rdev->meta_bdev)
>  			continue;
> =20
>=20

OK, applied.

Thanks.
NeilBrown

--Sig_/Wxy2j6=qJ5rlSU77.X64WUu
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUFqA7Tnsnt1WYoG5AQIDlhAAuyixuoMKFL61OmkzOWhb4R7SryqXkXEN
O76Aqw+m1WJ9pZ+xqutPcSxXbuuBHwTrVUsRR5pbmxGSuqrKtQd1ofkufP+Q99FP
PLZUny2Tqbt1jrXbXBimEIPbZCuMgCF/jCRa24b/ggHUfixMGRDpUym/UOBPlb/3
3AG6PQXS4OTdD5RdcQ2Aa3Kp/UiCBof/GJGs0CRIWS2ZzV3t3rjhdGLPZFbWZiBX
AStmX5ouBDob4io9qXhsupvT0WOBHw06W0xy/X0avM/TrY4x5iWzxIut1SKT2lUq
QpSsjPCNo8j4gvj4HJEg7kDktCvQI0nxtYQzK5BBbBQlW1IcKs4bUc3KQA5uBjhW
/P2mAk0mP+c3VnHdkqMlioRNnBAZzTVopGdZBJh+Ha7n7SYo9v+2sAzzsYrLl5Nx
rtr0Z+Q/LBNGZoD/0ggtBLoDBmY1wdlxAPJzbKPV1ux5CdMQXE2FD/wSvFWlfEqq
dGO7fl0xyH3eKrmJjeKdxD2qaKjNduvh81Kk3+UeV1vo4HBSt8i5cEgdCE/nNteQ
vtVJ/nQ0wtXdO1jMC0rZiyTU2k3A0Gi1ByP/ZSVmKgMuttYgQYozJjGcUbSt524Q
BJWQGfwVJJIhlliMdlwJRfIfeZcAE63DExN3WcGMyXpTRcuop7oMowXW4Sbzjc7w
eBV3H9XCSyo=
=iwYM
-----END PGP SIGNATURE-----

--Sig_/Wxy2j6=qJ5rlSU77.X64WUu--
