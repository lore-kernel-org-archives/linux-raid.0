From: Ben Martin <monkeyiq@users.sourceforge.net>
Subject: Re: Benchmarks: Linux Kernel RAID vs a Hardware RAID setup
Date: Wed, 16 Jul 2008 13:58:05 +1000
Message-ID: <1216180685.5633.364.camel@sam.localdomain>
References: <1216130769.5633.318.camel@sam.localdomain>
	 <20080715163932.GA23164@rap.rap.dk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-yOzdx7ch6AF3UpT7e4ju"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080715163932.GA23164@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: Keld =?ISO-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Cc: linux-raid@vger.kernel.org, Ben Martin <monkeyiq@users.sourceforge.net>
List-Id: linux-raid.ids


--=-yOzdx7ch6AF3UpT7e4ju
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-07-15 at 18:39 +0200, Keld J=C3=B8rn Simonsen wrote:
> On Wed, Jul 16, 2008 at 12:06:09AM +1000, Ben Martin wrote:
> > Hi,
> >   Apologies if posting this here is inappropriate but a recent article
> > of mine compares the Linux Kernel RAID code to an $800 hardware RAID
> > card and might be of interest to list members:
> >=20
> > http://www.linux.com/feature/140734
>=20
> It is (at least to me) very interesting to see comparisons on HW vs SW
> raid.
>=20
> I think tho, that you give it some bias not testing the best
> configurations for Linux SW raid. For example raid10, the f2 and o2
> layouts are faster than n2, and you don't know if Adaptec has some kind
> of improved layout.

This was one of those compromises in the article. If I was going to
fully treat RAID-10 then I'd have no time to do any sort of justice to
parity RAID configurations. I'll stay away from the parity vs r10 debate
that has arisen... I tried to make the article interesting to readers
wanting to use either configuration.

One interesting question about the r10 layouts, if f2/o2 perform better
than n2 why is the default for creation still n2? Just like mkfs.xfs
determining the raid chunk and stripe size for you (assuming you don't
use LVM to circumvent this, gah!), shouldn't mdadm select the "fastest"
--layout as the default for RAID-10?

>=20
> It would be interesting if you could enhance your article with benchmarks
> on raid10, f2 and o2 layouts. I think they would outperform HW raid, at
> least on input. And I would like to see how they perform on outout and
> rewrite, with ext3 and xfs. We do have some tests, but many of them are
> without a file system layer.

This will probably be the target of a new article at some point which
just focuses on R10.

>=20
> I would also welcome test with mobo HW RAID - Many mobo's today come
> with some HW raid functionality, and many people would be in the
> situation of whether to choose a HW or SW configuration.
>=20
> best regards
> keld

--=-yOzdx7ch6AF3UpT7e4ju
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkh9cc0ACgkQsIKOrI+5WvNXfQCeNfDaEoFohCZBaTMpK7pJ5jw5
9XIAn0JraL2rQdJUv0E/UM7DMzQdGmUG
=Zaeo
-----END PGP SIGNATURE-----

--=-yOzdx7ch6AF3UpT7e4ju--

