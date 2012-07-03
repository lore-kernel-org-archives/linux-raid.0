From: NeilBrown <neilb@suse.de>
Subject: Re: MD Raid10 recovery results in "attempt to access beyond end of
 device"
Date: Tue, 3 Jul 2012 11:46:38 +1000
Message-ID: <20120703114638.4d8d0af2@notabene.brown>
References: <20120622160632.7dfbbb9d@batzmaru.gol.ad.jp>
	<20120622180748.5f78339c@notabene.brown>
	<20120622174257.03a17e81@batzmaru.gol.ad.jp>
	<20120625140754.44536553@notabene.brown>
	<20120625150651.26a457bb@batzmaru.gol.ad.jp>
	<20120626234845.4d26bd8e@batzmaru.gol.ad.jp>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/szcqzQlYIjm+5EZ.6UYq1GU"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120626234845.4d26bd8e@batzmaru.gol.ad.jp>
Sender: linux-raid-owner@vger.kernel.org
To: Christian Balzer <chibi@gol.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/szcqzQlYIjm+5EZ.6UYq1GU
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 26 Jun 2012 23:48:45 +0900 Christian Balzer <chibi@gol.com> wrote:

>=20

> The patch worked fine:
> ---
> [  105.872117] md: recovery of RAID array md3
> [28981.157157] md: md3: recovery done.
> ---
>=20
> Thanks a bunch and I'd suggest to include this patch in any and all
> feasible backports and future kernels of course.
>=20
> Regards,
>=20
> Christian
>=20

Thanks for the confirmation.  I've added your "tested-by" and will forward =
to
Linus and -stable later today.

Thanks,
NeilBrown

--Sig_/szcqzQlYIjm+5EZ.6UYq1GU
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT/JO/jnsnt1WYoG5AQLARA//XP2OcdA5gEilqgqe8bnS24mACfL5wnIJ
VQqa3eB8SM9SXLj5rSxYlMYEQOIMuepnrM0KVczLUUYLELXOgX4mi43/PRIUn/be
U8hPJn1OH9Gm1PjwcYCnEdW4dQdI44MLFmne81G5KxkRSwZFfBWibs0Bwileg+Zm
IeMblwSP9p9WBKp4ipyTwkSAlDpHbL/Ekjj1K0x8Tv6Z14tZ+rS8UA/MvXGBN2E9
qEiVABdCwxeqNE9fhr+i6sSCKZdjN6E0421S1UVmuJZQW1wYUDy6CtK7Eg4BOmUP
XFR2mXrBF03bDNhSucgMwjdSAobupSwxlXHqDw4V7DIC+2ehSp3rSW+t+QwX7fn9
fNsBAKGPq1diVlPB5YPxViXIS6gmW8vceEwH+8st00HJQzFArEjNr/8q0aaKSZUi
egdl2LHs9NRhcCZwsN5EtuzDCTFg2wY7bbILodWlPjbww1b7g/piSXiimenAKGDJ
rirzR5Ki9LDNQ3CL4J2mZVWnCNsJq6JgTcS9YdSMtPb7neLjHnP+PE95BjtiTgOR
He1RTH1JSX09+z36Q/s9J2qeJijAtDlCrBkFC9db4oBOTEZiqj2wf8IfNEOXIwob
lPz8k/R6fIsQ3RRA+xAQxphOlcitw8fFW/crH96S+UC4j84WyzG6SdxG9L9uJ0/s
xMRms3GVA7c=
=14eJ
-----END PGP SIGNATURE-----

--Sig_/szcqzQlYIjm+5EZ.6UYq1GU--
