From: Andy Smith <andy@lug.org.uk>
Subject: swap on RAID (was Re: swp - Re: ext3 journal on software raid)
Date: Thu, 6 Jan 2005 09:38:11 +0000
Message-ID: <20050106093811.GB99565@caffreys.strugglers.net>
References: <41DC9420.5030701@h3c.com> <Pine.LNX.3.96.1050105210224.11158B-100000@Maggie.Linux-Consulting.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tubstlZAyh7waw5D"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.3.96.1050105210224.11158B-100000@Maggie.Linux-Consulting.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--tubstlZAyh7waw5D
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 05, 2005 at 09:04:00PM -0800, Alvin Oga wrote:
> On Wed, 5 Jan 2005, Mike Hardy wrote:
>=20
> > There are those that think if they size the machine correctly, they=20
> > shouldn't need swap, and they're right.
>=20
> bingo

Yet in an earlier reply you state that your machines have swap
configured.

There is a difference between these two statements:

        a) I need some amount of swap configured but don't expect a
        significant swap usage under normal load.

        b) I expect my server to always be using a significant
        amount of swap.

I interpret your views as (a) but I interpret Mike's as "there are
people who are saying that a correctly sized machine can have zero
swap configured."

Having no swap configured and merely using no swap in normal
circumstances are very very different situations.

--tubstlZAyh7waw5D
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (FreeBSD)

iD8DBQFB3QcDIJm2TL8VSQsRApd8AKDO7cUdZaJTb0/41y8m3ZgX5NfgsgCfYITR
3lKCaOJopBHyUhYk/mlzCo0=
=2GVG
-----END PGP SIGNATURE-----

--tubstlZAyh7waw5D--
