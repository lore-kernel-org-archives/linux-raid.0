From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm segfault at assemble
Date: Thu, 16 Feb 2012 14:12:25 +1100
Message-ID: <20120216141225.2fb47604@notabene.brown>
References: <201202150854.32303.arekm@maven.pl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/iHKDWuzJni92nGx3Msthzow"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201202150854.32303.arekm@maven.pl>
Sender: linux-raid-owner@vger.kernel.org
To: Arkadiusz =?UTF-8?B?TWnFm2tpZXdpY3o=?= <arekm@maven.pl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/iHKDWuzJni92nGx3Msthzow
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 15 Feb 2012 08:54:32 +0100 Arkadiusz Mi=C5=9Bkiewicz <arekm@maven.p=
l>
wrote:

>=20
> Hi,
>=20
> mapfile.c:434=20
>=20
> struct mddev_ident *match =3D conf_match(st, info, NULL, 0, NULL);
>=20
> so devname is NULL and that's passed down to fnmatch in match_oneof causi=
ng=20
> segfault.
>=20
> Looked at git and it seems to be the same as in mine 3.2.3 version.
>=20
> Starting program: /sbin/mdadm --assemble --scan --auto=3Dyes
>=20
> Program received signal SIGSEGV, Segmentation fault.
> 0xb7ef9f15 in fnmatch () from /lib/libc.so.6
> (gdb) bt
> #0  0xb7ef9f15 in fnmatch () from /lib/libc.so.6
> #1  0x08051caf in match_oneof (devices=3D0x80dea79 ",/dev/sdb3", devname=
=3D0x0) at=20
> config.c:958
> #2  0x08052051 in conf_match (st=3D0x80def50, info=3D0x80e11b8, devname=
=3D0x0,=20
> verbose=3D0, rvp=3D0x0) at config.c:1049
> #3  0x080a8e0c in RebuildMap () at mapfile.c:434
> #4  0x080a865b in map_read (melp=3D0xbffff8a4) at mapfile.c:201
> #5  0x080a8526 in map_lock (melp=3D0xbffff8a4) at mapfile.c:145
> #6  0x0804e0f6 in main (argc=3D4, argv=3D0xbffffc54) at mdadm.c:1320
>=20

Thanks for the report.

This should fix it.

NeilBrown


commit 9f1b0f0f1ed0dd4752be65348a24971335cd50e8
Author: NeilBrown <neilb@suse.de>
Date:   Thu Feb 16 14:11:57 2012 +1100

    config: conf_match should ignore devname when not set.
   =20
    mapfile:RebuildMap calls conf_match with no devname, so we must be
    careful not to use it.
   =20
    Reported-by: Arkadiusz Mi=C5=9Bkiewicz <arekm@maven.pl>
    Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/config.c b/config.c
index 6027b2f..d8f48e1 100644
--- a/config.c
+++ b/config.c
@@ -1045,7 +1045,7 @@ struct mddev_ident *conf_match(struct supertype *st,
 					array_list->devname);
 			continue;
 		}
-		if (array_list->devices &&
+		if (array_list->devices && devname &&
 		    !match_oneof(array_list->devices, devname)) {
 			if (verbose >=3D 2 && array_list->devname)
 				fprintf(stderr, Name

--Sig_/iHKDWuzJni92nGx3Msthzow
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTzx0GTnsnt1WYoG5AQKcdBAAoGcoYtLQUWYydZlw63exXyBSVo8SPiH+
fFonmCc7veO1TCiie8kVeo2qwguZxcG5QQpkYDs65YMobIGFPuZL6BcAih1mSygz
B2+bxArOeJVx6s81EV6pl6zj1KoCmLBkQAh6A0S26HolJW7pHToWG7xImOZ/17tD
vcgrQDnoAK/8i2Qj0RvkTNK2B3OqFdf64Wit9vhwMWTcp4K3OqJ/UuScpLDvnwsv
TEUmaSF196VjUvloYgaQyUe74Kj222Xa17an0uep+RSGDiA8BN7gWl51wJ6D6d8m
Xxd0S2vGV9svJyF22pxJxVXqW/e65C/syEToFXiaUWVreXcSzRF2fjJGhpqREfxZ
rS7cl9sqkGlA5Fh+aMU6C/q+M0xNg/6rg/eySleen1A2FsQBYhEVOMQe2GURgrp7
ou+vCh9Oc9NCccEoIK3qVayPjUJvccNQX95PRwV4vGbLw367P+SfVDZjtvwkM1Fv
uKZLpxNyG86FMH8RnFYYP/z5Fe4WU3Ya+xWSF9wD9ixK2Yo+FDP5pwt5u4zjJsNN
fTlyedCqh+1e+habrfGXrTYZu0pn9+g3Lo+uMFnR1iu3+C9TgqHC6B9+Cu3KoGms
HPG8GIhrieP+p5Q6/JgM3oovrxVf/hfizfkWgtS2iuKzjYQRi9oBsieLNdmoce0B
41GjIU6JTEU=
=+Kad
-----END PGP SIGNATURE-----

--Sig_/iHKDWuzJni92nGx3Msthzow--
