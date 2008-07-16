From: Ben Martin <monkeyiq@users.sourceforge.net>
Subject: Re: Benchmarks: Linux Kernel RAID vs a Hardware RAID setup
Date: Wed, 16 Jul 2008 13:44:46 +1000
Message-ID: <1216179886.5633.353.camel@sam.localdomain>
References: <1216130769.5633.318.camel@sam.localdomain>
	 <20080715163932.GA23164@rap.rap.dk>
	 <cccedfc60807151006mbcf58e2udd725f3b7bd38637@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-VB6aY2QEF1W7bGkxv8Zo"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cccedfc60807151006mbcf58e2udd725f3b7bd38637@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson-linux-raid@jamponi.net>
Cc: Keld =?ISO-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>, linux-raid@vger.kernel.org, Ben Martin <monkeyiq@users.sourceforge.net>
List-Id: linux-raid.ids


--=-VB6aY2QEF1W7bGkxv8Zo
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

This sounds perfect for an article that compares mobo fakeraid/bois-raid
for RAID-10 (if a board with it can be decided on) and kernel RAID-10. A
line graph of the bonnie xfer stats from say 16kb chunks through 1mb.

If/when I get this happening I'll post a link again to the list.

On Tue, 2008-07-15 at 12:06 -0500, Jon Nelson wrote:
> I would add to that request that you consider using a smaller chunk size.
> My own benchmarks showed that for some raid levels and layouts, a
> smaller chunk size gave the best overall performance.
>=20
>=20
> On Tue, Jul 15, 2008 at 11:39 AM, Keld J=C3=B8rn Simonsen <keld@dkuug.dk>=
 wrote:
> ...
> > It would be interesting if you could enhance your article with benchmar=
ks
> > on raid10, f2 and o2 layouts. I think they would outperform HW raid, at
> > least on input. And I would like to see how they perform on outout and
> > rewrite, with ext3 and xfs. We do have some tests, but many of them are
> > without a file system layer.
>=20
>=20
>=20

--=-VB6aY2QEF1W7bGkxv8Zo
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkh9bq4ACgkQsIKOrI+5WvPMGACeIXVXJ3sg0Basxq0B+MEwHOso
pdgAnj9eBMequykthzDs9adePSzunhB/
=SZcP
-----END PGP SIGNATURE-----

--=-VB6aY2QEF1W7bGkxv8Zo--

