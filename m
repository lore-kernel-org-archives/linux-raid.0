From: =?UTF-8?Q?Micha=C5=82?= Sawicz <michal@sawicz.net>
Subject: Re: How To Grow Using 'mdadm' Utility
Date: Thu, 28 Jan 2010 16:23:14 +0100
Message-ID: <1264692194.1928.29.camel@test.apertos.eu>
References: <d80f793f1001271056i1127fbcege5b4dd4a3927576@mail.gmail.com>
	 <1264634977.1928.13.camel@test.apertos.eu>
	 <d80f793f1001280658k487be15emc0a6d23c9d013957@mail.gmail.com>
	 <1264691314.1928.27.camel@test.apertos.eu>
	 <d80f793f1001280713j5b0ee689m1c4c455403c64928@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-ogrnGewg8oculTNdxqil"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <d80f793f1001280713j5b0ee689m1c4c455403c64928@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Carlos Williams <carloswill@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-ogrnGewg8oculTNdxqil
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dnia 2010-01-28, czw o godzinie 10:13 -0500, Carlos Williams pisze:
> Should I ignore the warning and proceed?

If you do - remount the filesystem read-only (mount -o remount,ro). But
it would be best to use some LiveCD system, otherwise you will need to
resize on a live filesystem, it will take much more time and is more
dangerous than resizing offline.

If you can't take the fs offline - you can force resizing without fsck
first, but again - it would be best to fsck it and resize offline.

--=20
Cheers
Micha=C5=82 (Saviq) Sawicz

--=-ogrnGewg8oculTNdxqil
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: To jest =?UTF-8?Q?cz=C4=99=C5=9B=C4=87?=
 =?UTF-8?Q?_wiadomo=C5=9Bci?= podpisana cyfrowo

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkthq+IACgkQzQlUjpZYlbcvhgCgoZ6fyzp+zQ9XMIBEGAlYHGEu
JR4AniLOvhj2+Gt64ElfrPqgobn41EQv
=qI9R
-----END PGP SIGNATURE-----

--=-ogrnGewg8oculTNdxqil--

