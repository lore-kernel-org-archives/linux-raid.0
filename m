From: =?UTF-8?Q?Micha=C5=82?= Sawicz <michal@sawicz.net>
Subject: Possible availability improvement
Date: Tue, 22 Feb 2011 15:45:35 +0100
Message-ID: <1298385935.2740.5.camel@michal-laptop.sawicz.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-wQzQ1F0IQl76SbwYPogk"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-wQzQ1F0IQl76SbwYPogk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi all,

On the wave of Neil's recent roadmap proposal I wanted to forward an
idea to bring it upon discussion.

When things in md-world break, there's usually some big and long strain
on the array members. My colleague's idea is to virtually split the
members into smaller chunks and keep some metadata (events, checksum?)
for each of them to reduce the extent of recovery needed when faced
with, say, a power failure.

Does that make sense?

Kind regards
--=20
Micha=C5=82 Sawicz <michal@sawicz.net>

--=-wQzQ1F0IQl76SbwYPogk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEABECAAYFAk1jzA8ACgkQzQlUjpZYlbeTzgCdFJrMiXa3ucffvD4uc1kiKyJf
qNoAniytaibA0QCArnfhgNhGOShqIJ8T
=8OTG
-----END PGP SIGNATURE-----

--=-wQzQ1F0IQl76SbwYPogk--

