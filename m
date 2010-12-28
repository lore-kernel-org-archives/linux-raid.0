From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: md-raid and block sizes
Date: Tue, 28 Dec 2010 16:45:15 +0500
Message-ID: <20101228164515.06ffa62f@natsu>
References: <1293451228.3266.9.camel@Waves.darkmere>
	<AANLkTikWxCxVUO+O8MXRXRR7Y8R5xGC1Catv-EiNGcDj@mail.gmail.com>
	<1293525980.23780.2.camel@Waves.darkmere>
	<AANLkTin=-0CN-teD5p4H_nFbuZ944DVuDMku3FaD7uv7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/7A9uet6CmpIHrOpAQBnKyQk"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTin=-0CN-teD5p4H_nFbuZ944DVuDMku3FaD7uv7@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: hansbkk@gmail.com
Cc: "D.S. Ljungmark" <spider@skuggor.se>, doug@easyco.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/7A9uet6CmpIHrOpAQBnKyQk
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 28 Dec 2010 18:29:26 +0700
hansbkk@gmail.com wrote:

> This doesn't actually relate to the blocksize issue, but a caveat -
> I've heard that these "green" drives are not suitable for use in a
> RAID.
>=20
> The specific issue is apparently that these drives spin down very
> frequently, but most RAID implementations keep spinning them back up
> again just as frequently (perhaps unnecessarily?), thus causing undue
> wear and tear on the drives' mechanics and ultimately premature
> failure.
>=20
> Of course this could be spin from the vendors to get people to spend
> more money on the "enterprise" level drives - I personally am a firm
> believer in saving money by buying consumer-level hardware and using
> the savings to buy extra redundancy.
>=20
> It just so happens that I've bought a batch of Samsung 2TB drives for
> a RAID6 I'm building, and it turns out they are quite similar to the
> WDEARS, both in their use of "new format" 4K blocks and some of the
> green features. I haven't yet detected any undue drive
> stopping/starting, but then again they are so quite I'm not sure how
> to check. . .
>=20
> Confirmation or refutation of these thoughts would be most welcome.

This all is just FUD and you shouldn't repeat and spread it further, helping
the vendor's marketing department get people spend money on an "Enterprise"
sticker.

WD*EARS/EADS, or at least most older models in that line-up, do indeed unlo=
ad
their heads after a short period of time, however that in no way inhibits t=
heir
usage in RAID (with this issue there's no difference at all, RAID or no RAI=
D),
and is user-adjustable using the WDIDLE3 utility:
https://encrypted.google.com/search?q=3DWDIDLE3

Samsung drives do not have any spindown/load/unload problems, but be aware =
of
this: http://sourceforge.net/apps/trac/smartmontools/wiki/SamsungF4EGBadBlo=
cks

--=20
With respect,
Roman

--Sig_/7A9uet6CmpIHrOpAQBnKyQk
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk0ZzcsACgkQTLKSvz+PZwhObwCcDr/JNUbD7SJ2xuvPE/QCNfD/
MTsAnj8us5uXa5AGsU8XrKA6oUmjinOP
=czwn
-----END PGP SIGNATURE-----

--Sig_/7A9uet6CmpIHrOpAQBnKyQk--
