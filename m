From: =?UTF-8?Q?Micha=C5=82?= Sawicz <michal@sawicz.net>
Subject: Re: Creating RAID5 w/ Hotspare?
Date: Thu, 11 Mar 2010 16:59:05 +0100
Message-ID: <1268323145.2481.17.camel@michal-laptop.sawicz.net>
References: <d80f793f1003110655m4b49f1c3x36c8aef817c62d72@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-W6vKg1Pkkvz5gfEmEYZC"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <d80f793f1003110655m4b49f1c3x36c8aef817c62d72@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Carlos Mennens <carloswill@gmail.com>
Cc: Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--=-W6vKg1Pkkvz5gfEmEYZC
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dnia 2010-03-11, czw o godzinie 09:55 -0500, Carlos Mennens pisze:
> Is that correct above or would I 1st have to partition the /dev/sdd
> drive?=20

To use it without partitioning, you would have to define a spare-group
and only add this disk to one of the arrays, it would then be moved
where needed.

But this way only one of the arrays would be able to use the disk as a
spare. If you partitioned it, all three could move to the spare disk and
you could replace a faulty one.

--=20
Pozdrawiam
Micha=C5=82 (Saviq) Sawicz

--=-W6vKg1Pkkvz5gfEmEYZC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: To jest =?UTF-8?Q?cz=C4=99=C5=9B=C4=87?=
 =?UTF-8?Q?_wiadomo=C5=9Bci?= podpisana cyfrowo

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkuZE0kACgkQzQlUjpZYlbditQCgxCQgZn1WSqnmY59KbV3T3eV/
cGEAnAnViXqIz0y4Ux3WnOakmSYtz+cX
=7pkY
-----END PGP SIGNATURE-----

--=-W6vKg1Pkkvz5gfEmEYZC--

