From: =?UTF-8?Q?Micha=C5=82?= Sawicz <michal@sawicz.net>
Subject: Swapping a disk without degrading an array
Date: Mon, 25 Jan 2010 13:11:15 +0100
Message-ID: <1264421475.30742.49.camel@test.apertos.eu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-O9ceYwEJfEWNxwos7seF"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--=-O9ceYwEJfEWNxwos7seF
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi list,

This is something I've discussed on IRC and we achieved a conclusion
that this might be useful, but somewhat limited use-case count might not
warrant the effort to be implemented.

What I have in mind is allowing a member of an array to be paired with a
spare while the array is on-line. The spare disk would then be filled
with exactly the same data and would, in the end, replace the active
member. The replaced disk could then be hot-removed without the array
ever going into degraded mode.

I wanted to start a discussion whether this at all makes sense, what can
be the use cases etc.

--=20
Cheers
Micha=C5=82 (Saviq) Sawicz

--=-O9ceYwEJfEWNxwos7seF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: To jest =?UTF-8?Q?cz=C4=99=C5=9B=C4=87?=
 =?UTF-8?Q?_wiadomo=C5=9Bci?= podpisana cyfrowo

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAktdimMACgkQzQlUjpZYlbekGgCeP4/0zaPyDcKMlcnXHhFIm99A
uiMAnjZ8pNNK2sis+bXiKHFHow0jx6Jf
=whQA
-----END PGP SIGNATURE-----

--=-O9ceYwEJfEWNxwos7seF--

