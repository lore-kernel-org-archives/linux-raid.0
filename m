From: NeilBrown <neilb@suse.de>
Subject: Re: "bitmap file is out of date, doing full recovery"
Date: Mon, 13 Oct 2014 09:24:26 +1100
Message-ID: <20141013092426.5ea1288d@notabene.brown>
References: <CAGRgLy5zhV49xF=ZwULaF46Xx=8rnWcypTWxxgf0HmEPpCP+yQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/aHyUDW=.sGprbK1YjfYQ/1h"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy5zhV49xF=ZwULaF46Xx=8rnWcypTWxxgf0HmEPpCP+yQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/aHyUDW=.sGprbK1YjfYQ/1h
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 12 Oct 2014 21:03:57 +0300 Alexander Lyakas <alex.bolshoy@gmail.com>
wrote:

> Hi Neil,
> after a 2-drive raid1 unclean shutdown (crash actually), after reboot, we=
 had:
>=20
> md/raid1:md24: not clean -- starting background reconstruction
> md/raid1:md24: active with 2 out of 2 mirrors
> md24: bitmap file is out of date (41 < 42) -- forcing full recovery
> created bitmap (22 pages) for device md24
> md24: bitmap file is out of date, doing full recovery
> md24: bitmap initialized from disk: read 2 pages, set 44667 of 44667 bits
>=20
> The superblock of both drives had event count =3D 42:
> (this is a custom mdadm with some added prints):
> mdadm: looking for devices for /dev/md24
> mdadm: [/dev/md24] /dev/dm-205: slot=3D0, events=3D42,
> recovery_offset=3DN/A, resync_offset=3D0, comp_size=3D5854539776
> mdadm: [/dev/md24] /dev/dm-206: slot=3D1, events=3D42,
> recovery_offset=3DN/A, resync_offset=3D0, comp_size=3D5854539776
>=20
> But the bitmap superblock had lower event count, which resulted in a
> full resync. Is this an expected scenario in case of a crash?

No.

>=20
> For example in md_update_sb, first we call
> bitmap_update_sb(mddev->bitmap), which synchronously updates the
> bitmap, and only afterwards we go ahead and update our superblocks. So
> in this case, the bitmap should not have a lower event count. Is there
> some other valid scenario, in which the bitmap can remain with a lower
> event count?

Not that I can think of.


NeilBrown

>=20
> Thanks,
> Alex.


--Sig_/aHyUDW=.sGprbK1YjfYQ/1h
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVDr/mjnsnt1WYoG5AQKD/RAAmTTJAeHn30mZmQwWiYXXxjKLsAr1cZN0
kPFqTxFLcrybXWpsyQWD92WgaHkQXJv1d2qppinncZ6sQhdqR21cc871wQitLIWk
fR6X5fOgJbRtjZXohAj4eub5W9Pm+EhwWf5dOssxrW/zdWMg5fvEwFqJh6RHvEPS
CKHzyw4a38QvRi3D6Gd/ML3MPzY2t3UD7dnjyhbdmZ1jQkXL8UxjazmCfc8lJis8
NCfF9ENJ1ej6xCh5M9yeLLLviVVJNPrQjLWPiLHC+olk6yYeZceAOk0J803zzU7c
P9ALMySdFJ8pJML6MRG4HjOz70NcIKSp6WNTXsaHwi6H8cSNECY+FSG0yERGhkJl
485/G7T7j1UEc5eHixuTqrOtcRjLlQ/6+mEFUKIhGP1qJNoF9fHoVNhM23MJhy9h
339W6HnQVUrXHkpluHE+TSneUWLpLTgGw3TM9r7tzBsuLeldx5ljs1kFk8FE54iX
p589UqDJxq4xj5sw0CRZy4jygz1WZNZfdqi/9DmlT/r1JeUM6NwDCOHCGmRfNfcH
ezCd3fOXFH1ksA2by/mJM5GI4yPAYJszyW+hL2jofciFBKTq/gi77oNPN5vAh1Pc
ybOwp/bQpX7rHxcRlRq3rbTsXijp30jnpk0BJgS/RSXFEcO/40SqM69inlsKBQeE
ceUNtTDwEDU=
=era6
-----END PGP SIGNATURE-----

--Sig_/aHyUDW=.sGprbK1YjfYQ/1h--
