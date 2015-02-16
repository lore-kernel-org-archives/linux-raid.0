From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm failed to remove internal bitmap
Date: Mon, 16 Feb 2015 17:48:00 +1100
Message-ID: <20150216174800.124d2ce8@notabene.brown>
References: <54DDC806.5010803@gmail.com>
	<20150216143419.553cf93e@notabene.brown>
	<54E1914C.9030000@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/nT4yrvd/E72XUBx8yFlysFQ"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <54E1914C.9030000@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: gary <gary.mdjiang@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/nT4yrvd/E72XUBx8yFlysFQ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 16 Feb 2015 14:42:20 +0800 gary <gary.mdjiang@gmail.com> wrote:

> Hi Neil,
>=20
> Please check the followings.
> > What kernel are you running?
> linux48:~ # uname -r
> 3.12.32-33-default

Does this have any patches on top of 3.12.32 that touch md.c ?


>=20
> And 3.12.28-4-default kernel is ok.

There are no differences between 3.12.28 and 3.12.32 that could affect this.


> ioctl(3, RAID_VERSION, 0x7fff2e10c060)  =3D 0
> ioctl(3, GET_BITMAP_FILE, 0x7fff2e10c1f0) =3D 0
> ioctl(3, GET_ARRAY_INFO, 0x7fff2e10c1a0) =3D 0
> ioctl(3, SET_ARRAY_INFO, 0x7fff2e10c1a0) =3D -1 EINVAL (Invalid argument)
> write(2, "mdadm: failed to remove internal"..., 41mdadm: failed to=20
> remove internal bitmap.


EINVAL from SET_ARRAY_INFO almost certainly comes from update_array_info().
It can happen if:
 - more than 1 thing needs to be updated - seems unlikely
 - pers->quiesce is NULL - not possible for raid1.
 - mddev->bitmap->storage.file is not NULL.  Seems unlikely.

I suggest you look at the code you are actually running, and possible add
some printks to tell you where it is failing.

NeilBrown

--Sig_/nT4yrvd/E72XUBx8yFlysFQ
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVOGSoDnsnt1WYoG5AQIRwA//fRmGmfGk+GtyfBywFN/I0zII5wjyCbMX
Ao7SOseuxK3aE7pMStKBfYD+FXhJ5f4OI1hB3OMxKRUQ+Gop8z4IOG+CSJx37oy+
AYbp7LOshpmWnVYxPYfBXYqTflNVsU6qotnRgbyxxfVe0yCSNmHdQdwYbuHUvhrU
8RFJP3Rc9+Cz8KOLuJWumU5nW78Ah/e8exEaynQHiLbWFcV34hbN+Q5zjdnj0W8o
mn5y1WO5bAED+yg8wW+BTObkvHASS+Q5W3Wi+sT15dF6mBVrf6FouJ6MuL+OUeMm
O4FvGZRAMK0gGQFYukgj1N+aT8KMLMODyu76b5jN5fOMMTOjZYDu3UhMXk/9vUKq
wqoYFmWUiCrjPrUlMyoQsmx7Gz+JDjtzKMkZAVqjAGTM37+8ft2K+jqJ1AzXEIcL
A3f2YvB4UEd+g1U90ejFwlhY67516sPbOUqR3Q0vJKAcoBly/GJPkRZN886a8iE4
CEaB9Uqas84ZKeN/oXxkEdV8e+qoEOGL4uTrpDeItIMujSZ4OyDUCP4UAbnaN5W1
xCw4cvK7vc/SLn6iiOfRyGqIzZvm5loXH/FhTIAixszMXMjyKtnFfspXCpmdjjLi
xufR/AaULO0YA66ONfd1D5GddVeTR6qQBMWgW4XyDFc1up2sNAiErCN+O5z4U7pw
kFZZrxuJiWk=
=e5Xl
-----END PGP SIGNATURE-----

--Sig_/nT4yrvd/E72XUBx8yFlysFQ--
