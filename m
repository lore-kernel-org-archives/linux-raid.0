From: NeilBrown <neilb@suse.de>
Subject: Re: Wrong array size detected after reboot
Date: Thu, 20 Sep 2012 21:39:48 +1000
Message-ID: <20120920213948.7dfc5f78@notabene.brown>
References: <CAFEwywaeGevnDMu7Do_wK+_Jgtyd0vman0804C2LyqbyzcJ9Sw@mail.gmail.com>
	<504C0462.2000609@turmel.org>
	<20120910091352.38dfdc20@notabene.brown>
	<CAFEwywaGN3cvXVAJxsWuc1-j0mfeLtKs_iqNznFQN8QA7JO8qQ@mail.gmail.com>
	<20120919114202.0ad6355b@notabene.brown>
	<CAFEwywbuH1689UStqoGOsvAh_X9afCpojKouY=Po5sXFGDFutw@mail.gmail.com>
	<20120920091109.5d950820@notabene.brown>
	<CAFEwywZ58nJMxd9ae66fEsWcUo94Djvhj44fg3MxFcQp_7_vpw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/8Gb93ka1Qb6r9yzTeK7ERtz"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAFEwywZ58nJMxd9ae66fEsWcUo94Djvhj44fg3MxFcQp_7_vpw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Markus Irle <tha.bear@gmail.com>
Cc: Phil Turmel <philip@turmel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/8Gb93ka1Qb6r9yzTeK7ERtz
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 20 Sep 2012 11:53:04 +0200 Markus Irle <tha.bear@gmail.com> wrote:

> Hi Neil,
>=20
> On Thu, Sep 20, 2012 at 1:11 AM, NeilBrown <neilb@suse.de> wrote:
> >
> > Yes, the metadata has lots the most-significant-bit of the 'size'.
> >
> > So it should be sufficient to:
> >   mdadm -G /dev/md2 --size 2930266432
> >
> > where the size is calculated as the current "used device size" plus 2^3=
1.
> > You could probably just do "--size max"
> >
> > This will cause a resync of the 2G of data which is probably unnecessar=
y, but
> > is awkward to avoid.
>=20
> Thanks, will try.
>=20
> Resyncing won't overwrite the existing data, will it?

No, it won't.  It'll just check all the parity blocks are correct.

> Sorry for being overly cautious...

Not something to apologise for ....

NeilBrown

>=20
> Cheers,
> Markus


--Sig_/8Gb93ka1Qb6r9yzTeK7ERtz
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUFsAhDnsnt1WYoG5AQIcHQ/8D8rorySPIP2Gmc2pC/SX0xAE7lGxBADX
qJMBETB9PQULd8YPL/KxOFHHNhGM2dPGDIG1TGDO6aVOOKqucILIJQdkQPiPOv3L
kZO3pNqtXZfOustldaqIb0IsHOeqpil6XnwZBhveMkyfYnT9bgXaqgFaUJs+oKHR
A/1Jtg1ribRjShITENfqXRSYEAQyS7IL/cenSMGBAdjQv/l8zvswXHhm0p3QnQiy
c5Og4dhyK1upjwDR1ygah8/MKx/CiS0tRJzfFSGI4nddVXhBRU48PZ9ANLZ4xCJU
TXLTLcCb+oJxF2t5eNmmo1RSwLwDYNIahVjKEslRMzyfpzfZF7kFibiUMBYnaYco
BDF6mBcGk4oueUA7sLQm1fgCn2eECwnVzM9N6Dz3cgOWMhFSnqYEItws13PcCosf
DJP4CefrSPVgj/Ef7prj7pMhDTWZdahAzycjOpftdG25sr0zrgED9ZcGQSZjwogP
eLM8jFdO1n0crHRlwDPVbZlsoPJT1iYr1V4ZruB1OI+92hhCl9nxKr+EbwJMzN/b
HD8NOsaPiiEUB7FSR8OdesuLOB6LPsB2UiStzBZPG4pFgWmzYXFZvii8VugR/9VO
RtcdOFnkO1cMTwRXZaPB+fFGvLYuisy6odU29SPViAED4iZo9lh5Vfiw+X8QAiz0
0Gu6CvC/j6M=
=MmSE
-----END PGP SIGNATURE-----

--Sig_/8Gb93ka1Qb6r9yzTeK7ERtz--
