From: Ben Martin <monkeyiq@users.sourceforge.net>
Subject: Re: Benchmarks: Linux Kernel RAID vs a Hardware RAID setup
Date: Wed, 16 Jul 2008 13:25:31 +1000
Message-ID: <1216178731.5633.337.camel@sam.localdomain>
References: <1216130769.5633.318.camel@sam.localdomain>
	 <20080715194143.GA25566@rap.rap.dk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-wkrh81B3DGL3rvELSaug"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080715194143.GA25566@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: Keld =?ISO-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Cc: linux-raid@vger.kernel.org, Ben Martin <monkeyiq@users.sourceforge.net>
List-Id: linux-raid.ids


--=-wkrh81B3DGL3rvELSaug
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-07-15 at 21:41 +0200, Keld J=C3=B8rn Simonsen wrote:
> On Wed, Jul 16, 2008 at 12:06:09AM +1000, Ben Martin wrote:
> > Hi,
> >   Apologies if posting this here is inappropriate but a recent article
> > of mine compares the Linux Kernel RAID code to an $800 hardware RAID
> > card and might be of interest to list members:
> >=20
> > http://www.linux.com/feature/140734
>=20
> Thanks for this! I have written about it on the wiki.

Excellent :)

>=20
> I see that the Adaptec has a mode 1E which looks a lot like Linux
> raid10,o2.  It could be fun to compare these, and also raid10,f2.

I'd also like to compare the 5EE type modes as RAID-6 does bring a fair
degradation of performance for its two failure protection.

>=20
> Also, if you wish, it would be nice to see what can actually be achieved
> without the expensive Adaptec card, that is what can be done with the
> controller on the mobo, with arrays with 4 disks.

I was actually a bit worried that the card was geared toward middle tear
as there are more performance oriented cards around (including the
commensurate price).

>=20
> And also if the mobo controller has raid types, what could be achieved
> with this....=20

This would be very interesting. Taking a common middle level P45 board
and benchmarking the mobo RAID vs the kernel RAID.

>=20
> best regards
> keld

--=-wkrh81B3DGL3rvELSaug
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkh9aisACgkQsIKOrI+5WvOfdQCeKHs0XMMKLGQYNgzTkvb/npe2
y4IAn3C6XsV0eWmply5e13iuEmODIwMh
=B1b9
-----END PGP SIGNATURE-----

--=-wkrh81B3DGL3rvELSaug--

