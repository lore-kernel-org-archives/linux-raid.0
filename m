From: NeilBrown <neilb@suse.de>
Subject: Re: Bugreport: mdmon will not start with latest git version when
 using ddf container
Date: Thu, 1 Aug 2013 15:28:18 +1000
Message-ID: <20130801152818.27cf61a5@notabene.brown>
References: <51F953FA.5000400@gmail.com>
	<20130801104433.1e7b41a5@notabene.brown>
	<CAGkViCGM5-ztFSh3d-yh=P0HNfvcPYr6p7g3rDfkmx2+8YaqEw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/rkB/wdygBeJ+oqepgWxHa9y"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGkViCGM5-ztFSh3d-yh=P0HNfvcPYr6p7g3rDfkmx2+8YaqEw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Albert Pauw <albert.pauw@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/rkB/wdygBeJ+oqepgWxHa9y
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 1 Aug 2013 07:18:53 +0200 Albert Pauw <albert.pauw@gmail.com> wrote:

> Hi Neil,
>=20
> both mdadm and mdmon come from the same location, /sbin, and are the newly
> created one.
>=20
> I've attached the strace file. Hopefully you can find any clues in there.
>=20

Yes I can.

mdmon needs to create /run/mdadm but you don't have '/run'.
try:
 make clean
 make MAP_DIR=3D/var/run/mdadm
or maybe
 make MAP_DIR=3D/dev/.mdadm

NeilBrown

--Sig_/rkB/wdygBeJ+oqepgWxHa9y
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUfnx8jnsnt1WYoG5AQLxiQ//VGrBE+t3fsRVeSV5cyN5OrZamxEyRF6+
u5+Cx8iTx8ixZitBuaNL1Rd0IgPbCbtbxMV+y34dC23bjSUEt13LaUFqEhfxdCBA
Cf8nbxeIE372Zh40PzDCYhnvB0hTSpH12mFbMs3Ioq27o0dG1lo9jJvf4zacHPAy
lzvnkJst0VkTg2qrjKpg705k30ehIdUx1Q9+DcG/hraNGatxdz2wyGuqNiUoLp7/
HkqWPnIGXcbOuSyNzPtHN3iU0fuylnWib8O0YTDCME/50BH1PRuEQzdft/BGMRjY
fXzK4nQg3JfBvpL+J/ognJOCho2yim6KtYCerCA7jlwkEl4p7KXHbwNrrwlPaARC
6RvKOTZY2Dge2EUS+ZwAPsfLmO3ytF6WMYHSo4F7JbQ0lTlUiB/C9JA9oyJ+wmG6
6xNCHsXSP+8kpBUH1SDGMVqLhutQ7grw3IQJB1HCGODK1obD4UrRXLTcl8jhMIV9
ckRdrjb5n6TiKiIXBJNhqT5StIlBQoerUsHzq2yypiB9MTHwjkSRQtkIO12Mt6Vh
9i8ccGKghaGSjDJDdA5V9ltwjBBETiWZC8pN5Yctj68CEchzoK/8sOPQjb1WtwF/
UK3ohZ8rGEXyj3kpDJ1Y4JBKTkownM9cJ6TgfZvs7fNCL+Yyi1vD+3D2Guqpm/c1
pC78Lv8Cs70=
=+N9K
-----END PGP SIGNATURE-----

--Sig_/rkB/wdygBeJ+oqepgWxHa9y--
