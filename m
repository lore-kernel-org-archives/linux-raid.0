From: Andy Smith <andy@lug.org.uk>
Subject: Re: PROBLEM: Kernel 2.6.10 crashing repeatedly and hard
Date: Fri, 7 Jan 2005 09:39:36 +0000
Message-ID: <20050107093936.GM99565@caffreys.strugglers.net>
References: <m3is6k4oeu.fsf@reason.gnu-hamburg> <m38y7fn4ay.fsf@reason.gnu-hamburg> <v3rda2-hjn.ln1@news.it.uc3m.es> <41DE2A54.1010902@tequila.co.jp>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="w/v2c/tRBe2qsJs0"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <41DE2A54.1010902@tequila.co.jp>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--w/v2c/tRBe2qsJs0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 07, 2005 at 03:21:08PM +0900, Clemens Schwaighofer wrote:
> On 12/31/2004 02:39 AM, Peter T. Breuer wrote:
> > Yes, well, don't put the journal on the raid partition. Put it
> > elsewhere (anyway, journalling and raid do not mix, as write ordering
> > is not - deliberately - preserved in raid, as far as I can tell).
>=20
> Thats a very new claim. I never ever heard of that.

Yes, and neither have most people I talked to about this, which is
why I think this deserves to be explored more and any gotchas
documented somewhere.

--w/v2c/tRBe2qsJs0
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (FreeBSD)

iD8DBQFB3ljYIJm2TL8VSQsRAlZ2AJ0VNwelWxN8eIwunE6RUTRcACxKxgCfVUKA
xlIBgCi1kkAJwA7VhT6PT9g=
=hPIX
-----END PGP SIGNATURE-----

--w/v2c/tRBe2qsJs0--
