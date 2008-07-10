From: Andre Noll <maan@systemlinux.org>
Subject: Re: resync'ing - what is going on
Date: Thu, 10 Jul 2008 20:03:05 +0200
Message-ID: <20080710180305.GA4247@skl-net.de>
References: <20080710165459.GA17542@rap.rap.dk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3V7upXqbjpZ4EhLz"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080710165459.GA17542@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--3V7upXqbjpZ4EhLz
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 18:54, Keld J=F8rn Simonsen wrote:
> And what happens if a discrepancy is found? Which of the 2 copies are the
> good one?

Nobody can tell. IIRC, the md code picks the one with the smallest drive
id.

> For raid5 and raid6 I could imagine that the parity blocks were cheked.

For raid5 you still can't tell which of the copies (if any) is
good. For raid6 you can tell under the assumption that exactly one
drive has bad data.  However, the raid6 code currently does not try
to fix up errors.

Have a look at the archives for more..
Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--3V7upXqbjpZ4EhLz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFIdk7ZWto1QDEAkw8RAjGEAJ97vyf0hRJBaInv5n4MPbfB4TTmhQCdFI6F
WyrOmzK+XX2XnongsTzPCSQ=
=61qp
-----END PGP SIGNATURE-----

--3V7upXqbjpZ4EhLz--
