From: Andy Smith <andy@strugglers.net>
Subject: Swap should be mirrored or not? (was Re: ext3 journal on software raid)
Date: Wed, 5 Jan 2005 13:36:54 +0000
Message-ID: <20050105133654.GI99565@caffreys.strugglers.net>
References: <41DBD741.4070000@wasp.net.au> <Pine.LNX.3.96.1050105051955.9045B-100000@Maggie.Linux-Consulting.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aeKQ3o3ktSNpH7mO"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.3.96.1050105051955.9045B-100000@Maggie.Linux-Consulting.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--aeKQ3o3ktSNpH7mO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 05, 2005 at 05:23:19AM -0800, Alvin Oga wrote:
> On Wed, 5 Jan 2005, Brad Campbell wrote:
>=20
> > Picture lpd gets swapped out on a friday night. Over the weekend
> > it is not used and the drive develops a bad sector in the middle
> > of the file. Monday morning I want to print and the system tries
> > to page lpd back in again. *boom*.
>=20
> admin issue ... user related services like printers should NOT be on
> critical servers and take down what everybody will notice due to unrelated
> printer problems

The problem is not that an lpd process exists, the problem is that
an attempt was made to swap back in a swapped out process while the
swap device is screwed.  It could happen to any process.  Swap is
part of your virtual memory, either keep it working or don't use it
at all -- you cannot expect your server to keep on working when half
its virtual memory is on a device that just died.

--aeKQ3o3ktSNpH7mO
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (FreeBSD)

iD8DBQFB2+12IJm2TL8VSQsRAp+ZAKCrrEhY3uf/ZKc0/GfHb4pqLPCKjACgjbGi
H4fNPbSTEOOIfwU9GxS3wCA=
=jLxB
-----END PGP SIGNATURE-----

--aeKQ3o3ktSNpH7mO--
