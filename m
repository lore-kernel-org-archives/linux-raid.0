From: Andre Noll <maan@systemlinux.org>
Subject: Re: MD: Feature Request: Estimate of blocks necessary to complete sync
Date: Tue, 16 Dec 2008 11:58:17 +0100
Message-ID: <20081216105817.GC17966@skl-net.de>
References: <cccedfc60812110727p18abcf49v909cb0860c2d4c02@mail.gmail.com> <18759.7048.623851.9550@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="v4PrGfol6wGsg/Ra"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <18759.7048.623851.9550@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Jon Nelson <jnelson-linux-raid@jamponi.net>, LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--v4PrGfol6wGsg/Ra
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 14:07, Neil Brown wrote:
> > What would be nice is the addition of something like this:
> > Dec 11 08:59:40 turnip kernel: md: bitmap shows 27 128K blocks requirin=
g sync
> > or
> > Dec 11 08:59:40 turnip kernel: md: bitmap shows 3456K blocks requiring =
sync
> > or some other analogue.
> >=20
> > Seem reasonable?
>=20
> Probably.  I wouldn't be too hard to could the number of bits that are
> set.  I guess it could be useful.
>=20
> I'll put it on my list :-)

We already have

	printk(KERN_INFO "%s: bitmap initialized from disk: "
		"read %lu/%lu pages, set %lu bits\n",
		bmname(bitmap), bitmap->file_pages, num_pages, bit_cnt);

in bitmap.c. Shouldn't that do the trick?

Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--v4PrGfol6wGsg/Ra
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFJR4nJWto1QDEAkw8RAoAMAJ0fJxWsGaea+P3s7Z9Zaektm+OeeACfXzbv
oLO7nXcFIPgDzTK4H8jCgBU=
=Prp9
-----END PGP SIGNATURE-----

--v4PrGfol6wGsg/Ra--
