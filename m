From: Andy Smith <andy@strugglers.net>
Subject: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10 crashing repeatedly and hard)
Date: Sun, 2 Jan 2005 19:42:40 +0000
Message-ID: <20050102194240.GE99565@caffreys.strugglers.net>
References: <m3is6k4oeu.fsf@reason.gnu-hamburg> <m38y7fn4ay.fsf@reason.gnu-hamburg> <v3rda2-hjn.ln1@news.it.uc3m.es> <41D45C1F.5030307@tls.msk.ru> <u59ea2-4qr.ln1@news.it.uc3m.es>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="p0aHTXLXY/BobAxh"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <u59ea2-4qr.ln1@news.it.uc3m.es>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--p0aHTXLXY/BobAxh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 30, 2004 at 10:39:42PM +0100, Peter T. Breuer wrote:
> In gmane.linux.raid Michael Tokarev <mjt@tls.msk.ru> wrote:
> > Peter T. Breuer wrote:
> > > In gmane.linux.raid Georg C. F. Greve <greve@fsfeurope.org> wrote:
> > >=20
> > > Yes, well, don't put the journal on the raid partition. Put it
> > > elsewhere (anyway, journalling and raid do not mix, as write ordering
> > > is not - deliberately - preserved in raid, as far as I can tell).
> >=20
> > This is a sort of a nonsense, really.  Both claims, it seems.
>=20
> It's perfectly correct, as far as I know!

Not really wishing to get into the middle of a flame war, but I
didn't really see how this could be true so I asked for more info on
ext3-users.

I got the following response:

https://listman.redhat.com/archives/ext3-users/2005-January/msg00003.html


--p0aHTXLXY/BobAxh
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.6 (FreeBSD)

iD8DBQFB2E6wIJm2TL8VSQsRAlxiAKCLo9EJYQIe1VVa35KbnmWzPvuTfwCfRKy5
yLI4cQc/9zKYSnn8rpT2i5o=
=qzkw
-----END PGP SIGNATURE-----

--p0aHTXLXY/BobAxh--
