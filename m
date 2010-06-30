From: Roman Mamedov <roman@rm.pp.ru>
Subject: Re: Write-intent bitmap decreases or increase performance of RAID5?
Date: Wed, 30 Jun 2010 11:59:27 +0600
Message-ID: <20100630115927.090751dd@natsu>
References: <20100629201153.GA13018@localhost>
	<20100630111854.006ec4d0@natsu>
	<alpine.DEB.1.10.1006300729150.8623@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/7KVGVfJ0awicodSe0PthVAm"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.1006300729150.8623@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: Shaochun Wang <scwang@ios.ac.cn>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/7KVGVfJ0awicodSe0PthVAm
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 30 Jun 2010 07:54:55 +0200 (CEST)
Mikael Abrahamsson <swmike@swm.pp.se> wrote:

> On Wed, 30 Jun 2010, Roman Mamedov wrote:
>=20
> >  dd if=3D/dev/zero of=3Dzerofile bs=3D1M count=3D2048 conv=3Dfdatasync,=
notrunc
>=20
> To be a bit more sure about accurate measurement, make sure the amount of=
=20
> data you're transferring is twice the amount of RAM in the machine, the=20
> above is only 2 gigs of data.

This is not necessary. See the dd man page about the conv=3Dfdatasync switc=
h.
You can even test with just 256 MB this way, and still get an extremely
accurate result.

Three consecutive runs with "count=3D256" on a machine with 4GB of RAM:
268435456 bytes (268 MB) copied, 4.76846 s, 56.3 MB/s
268435456 bytes (268 MB) copied, 4.79682 s, 56.0 MB/s
268435456 bytes (268 MB) copied, 4.79307 s, 56.0 MB/s

--=20
With respect,
Roman

--Sig_/7KVGVfJ0awicodSe0PthVAm
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkwq3T8ACgkQTLKSvz+PZwhteACdHvzbI4q+LDTqlb1cbGX6Oyll
WD8AoIVqMhY8fp/A0g+RA9fR/d0UO4xj
=XYyn
-----END PGP SIGNATURE-----

--Sig_/7KVGVfJ0awicodSe0PthVAm--
