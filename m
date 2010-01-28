From: =?UTF-8?Q?Micha=C5=82?= Sawicz <michal@sawicz.net>
Subject: Re: How To Grow Using 'mdadm' Utility
Date: Thu, 28 Jan 2010 16:59:23 +0100
Message-ID: <1264694363.1928.30.camel@test.apertos.eu>
References: <d80f793f1001271056i1127fbcege5b4dd4a3927576@mail.gmail.com>
	 <1264634977.1928.13.camel@test.apertos.eu>
	 <d80f793f1001280658k487be15emc0a6d23c9d013957@mail.gmail.com>
	 <1264691314.1928.27.camel@test.apertos.eu>
	 <d80f793f1001280713j5b0ee689m1c4c455403c64928@mail.gmail.com>
	 <1264692194.1928.29.camel@test.apertos.eu>
	 <d80f793f1001280750n68257e18n3e79ec0d68b5ac18@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-+naCnAmEGrr5yLlYfop3"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <d80f793f1001280750n68257e18n3e79ec0d68b5ac18@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Carlos Williams <carloswill@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-+naCnAmEGrr5yLlYfop3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dnia 2010-01-28, czw o godzinie 10:50 -0500, Carlos Williams pisze:
> I can do "shutdown -r -F now" from my regular system. During this
> reboot a fsck will be forced. Will that be enough?=20

You would still need resize2fs to run on a running, mounted FS - it's
slow and smells of trouble.

--=20
Pozdrawiam
Micha=C5=82 (Saviq) Sawicz

--=-+naCnAmEGrr5yLlYfop3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: To jest =?UTF-8?Q?cz=C4=99=C5=9B=C4=87?=
 =?UTF-8?Q?_wiadomo=C5=9Bci?= podpisana cyfrowo

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkthtFsACgkQzQlUjpZYlbeLIwCfThvvbzVJLOUeLl02YUefEIbG
dUMAmwQBmF/7T0Kf74U9YrjB/FCPLjMv
=Y96+
-----END PGP SIGNATURE-----

--=-+naCnAmEGrr5yLlYfop3--

