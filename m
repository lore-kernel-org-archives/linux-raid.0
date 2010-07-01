From: Roman Mamedov <roman@rm.pp.ru>
Subject: Re: Write-intent bitmap decreases or increase performance of RAID5?
Date: Fri, 2 Jul 2010 02:50:11 +0600
Message-ID: <20100702025011.1fdcddb6@natsu>
References: <20100629201153.GA13018@localhost>
	<20100630111854.006ec4d0@natsu>
	<alpine.DEB.1.10.1006300729150.8623@uplift.swm.pp.se>
	<20100701064044.GB6058@localhost>
	<AANLkTilnBWCGHUgQnmrzSzpo7TRYSedBVUZEOHKI4MmG@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/kb6CA5qsvd3O.qAQql1T0tY"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTilnBWCGHUgQnmrzSzpo7TRYSedBVUZEOHKI4MmG@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Majed B." <majedb@gmail.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/kb6CA5qsvd3O.qAQql1T0tY
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 1 Jul 2010 23:30:26 +0300
"Majed B." <majedb@gmail.com> wrote:

> How much RAM does your machine have?
>=20
> Write to the disk an amount that is larger than the amount of RAM and
> see if you get the same result.
>=20
> Also you can use hdparm to flush the caches before running dd the 2nd tim=
e.

Here we go again. Read up on what conv=3Dfdatasync means, and why cache is
irrelevant in this test.

--=20
With respect,
Roman

--Sig_/kb6CA5qsvd3O.qAQql1T0tY
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkws/4MACgkQTLKSvz+PZwhsaQCfSEKLf/IG/PvwIFJyYahFxpXg
M0gAni1zJKCv4rODbQH0XPK1CX9dovsV
=rHI2
-----END PGP SIGNATURE-----

--Sig_/kb6CA5qsvd3O.qAQql1T0tY--
