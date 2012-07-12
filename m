From: NeilBrown <neilb@suse.de>
Subject: Re: commit backport request
Date: Thu, 12 Jul 2012 14:14:22 +1000
Message-ID: <20120712141422.05809022@notabene.brown>
References: <20120709140230.3cf926ec@notabene.brown>
	<20120711220740.GE10930@kroah.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/p+6j=egtp4ruZ18P_uftlH8"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120711220740.GE10930@kroah.com>
Sender: linux-raid-owner@vger.kernel.org
To: Greg KH <gregkh@linuxfoundation.org>
Cc: stable <stable@vger.kernel.org>, Jose Manuel dos Santos Calhariz <jose.calhariz@netvisao.pt>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/p+6j=egtp4ruZ18P_uftlH8
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 11 Jul 2012 15:07:40 -0700 Greg KH <gregkh@linuxfoundation.org> wro=
te:

> On Mon, Jul 09, 2012 at 02:02:30PM +1000, NeilBrown wrote:
> >=20
> > Hi Mr Stable,
> >=20
> >  please apply patch
> >=20
> > commit fab363b5ff502d1b39ddcfec04271f5858d9f26e
> > Author: Shaohua Li <shli@kernel.org>
> > Date:   Tue Jul 3 15:57:19 2012 +1000
> >=20
> >     raid5: delayed stripe fix
> >=20
> >=20
> > to 3.4.y and 3.2.y.
> >=20
> > It fixes a deadlock in RAID5 which can cause all IO to hang.
> > It has been demonstrated to fix a real-life problem (the race is not
> > theoretical).
>=20
> Is it also needed for 3.0.x?  It seems to apply there just fine.

Yes it is.  Don't know why I missed that.
I see you've already included it - thanks.

NeilBrown

--Sig_/p+6j=egtp4ruZ18P_uftlH8
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT/5PHjnsnt1WYoG5AQJkvQ//chOix69TnlVcpjh2q0VOqth+RXn29MN9
TGrbmeaPiUzPbt0Q2wbHCo52YAemIT9ZzAYNCsfklBj+IAyA7uLnJq4Rozz/PT1U
hX77unvBdq7b4skmHgFGHnMC2iokyZwah8mCUrSZwBcAbrV/bekIFnmJM66Lb2Lk
BmeRB1c43Zx7FbWoVl3m1fnFFGYlmqkpyeCg8uRjQbQ9mFxmdG0j2yFrLr0VE1xX
qlIstFQF1jWxiT1Skuw5j2/nhi2hwzFbRJg11L2nDUiwP0jKStvHLT2J02fhSTbT
yVoZgF8otW5opfYZ4ZUBd6aNOyd8Xg0cECw4R4Ld2sWYBRq7E+9L+S3Cc3VXfdv+
Foiz9D2mpfpSHaG/BwZ2g7orTXbuOjSzX1SVzp+ibg/39u1lCl5dqZwnvlC2zgCW
pFHKqMmWMD2OMKoueou7MH1LD5Eyu4J6V4hbI6tkXkb68u9f1gdESUo4EIFu87f9
soTbdDGgUJXp5aK+bNqwYxopluquIsUhUMUjYHV97A4nqlR7Q3uT60cQvTsBdhae
KckdW2COI6Ioii1mN+q6aRIfFgUU3HrEhQ5BLpqM1/TCKuHxpsUpntXBLTGHn6iG
9CEVdIS3vuuiMij5Xw8HUaapdDNlzn0PgXMh0BYw0dIOEecUnb7nCDncy9BuycXD
ZBeOaH/kZJc=
=KXVF
-----END PGP SIGNATURE-----

--Sig_/p+6j=egtp4ruZ18P_uftlH8--
