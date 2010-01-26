From: =?UTF-8?Q?Micha=C5=82?= Sawicz <michal@sawicz.net>
Subject: Re: Several steps to death
Date: Tue, 26 Jan 2010 15:56:03 +0100
Message-ID: <1264517763.30742.88.camel@test.apertos.eu>
References: <55f050077e86adeb1f4acca87cace12b.squirrel@www.dcsnow.com>
	 <4B5EB5BD.7070406@shiftmail.org>
	 <5931ac0a02f59a2a2e1db82c630ff474.squirrel@www.dcsnow.com>
	 <4B5EEFD7.2080407@shiftmail.org>
	 <37bfaf9c6cbe90557cdef839be3ff20f.squirrel@www.dcsnow.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-nh78u+QDKxR+gMgdi2cw"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <37bfaf9c6cbe90557cdef839be3ff20f.squirrel@www.dcsnow.com>
Sender: linux-raid-owner@vger.kernel.org
To: aragonx@dcsnow.com
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--=-nh78u+QDKxR+gMgdi2cw
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dnia 2010-01-26, wto o godzinie 09:36 -0500, aragonx@dcsnow.com pisze:
> Poor wording on my part.  Yes I tried to assemble the array several
> times
> under Fedora 12 and Knoppix 6.2.  It would not start so then I tried
> the
> create.  Either way the data is gone and that answers my question.=20

You should have also used '--assume-clean' so that no data would be
written onto the array while the array was assembled. Saved my ass
earlier.

--=20
Cheers
Micha=C5=82 (Saviq) Sawicz

--=-nh78u+QDKxR+gMgdi2cw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: To jest =?UTF-8?Q?cz=C4=99=C5=9B=C4=87?=
 =?UTF-8?Q?_wiadomo=C5=9Bci?= podpisana cyfrowo

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAktfAoMACgkQzQlUjpZYlbcyfQCfcxJp9HHKdQuQLUpG6+psvLjV
cfoAoLi2js6jPXPStJelFDqEQPtLznUD
=Wuti
-----END PGP SIGNATURE-----

--=-nh78u+QDKxR+gMgdi2cw--

