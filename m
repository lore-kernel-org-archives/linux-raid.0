From: Andy Smith <andy@strugglers.net>
Subject: Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10 crashing repeatedly and hard)
Date: Tue, 4 Jan 2005 02:41:08 +0000
Message-ID: <20050104024108.GK99565@caffreys.strugglers.net>
References: <l1nna2-e9i.ln1@news.it.uc3m.es> <200501031846.42950.maarten@ultratux.net> <200501032052.21459.maarten@ultratux.net> <a9noa2-o12.ln1@news.it.uc3m.es> <fh0pa2-kvp.ln1@news.it.uc3m.es> <16857.55609.534526.297577@cse.unsw.edu.au> <jh4pa2-pi.ln1@news.it.uc3m.es> <16857.64086.362458.177296@cse.unsw.edu.au> <6d5bedd80501031816eb8f296@mail.gmail.com> <16857.65024.745883.752981@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="u+fRANu8FDjhiqn/"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <16857.65024.745883.752981@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--u+fRANu8FDjhiqn/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 04, 2005 at 01:22:56PM +1100, Neil Brown wrote:
> On Monday January 3, ewan.grantham@gmail.com wrote:
> > I've setup a RAID-5 array using two internal 250 Gig HDs and two
> > external 250 Gig HDs through a USB-2 interface. Each of the externals
> > is on it's own card, and the internals are on seperate IDE channels.
> >=20
> > I "thought" I was doing a good thing by doing all of this and then
> > setting them up using an ext3 filesystem.
>=20
> Sounds like a perfectly fine setup (providing always that external
> cables are safe from stray feet etc).
>=20
> No need to change anything.

Except that Peter says that the ext3 journals should be on separate
non-mirrored devices and the reason this is not mentioned in any
documentation (md / ext3) is that everyone sees it as obvious.
Whether it is true or not it's clear to me that it's not obvious to
everyone.

--u+fRANu8FDjhiqn/
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.6 (FreeBSD)

iD8DBQFB2gJEIJm2TL8VSQsRAtJbAJoDxT5OmfwhR8pJ2lVSwT/iV+NGXwCgt1ap
utEna2fyRIfEI/Mi17haF4w=
=jhL4
-----END PGP SIGNATURE-----

--u+fRANu8FDjhiqn/--
