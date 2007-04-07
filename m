From: Andy Smith <andy@lug.org.uk>
Subject: Re: raid10_make_request bug: can't convert block across chunks or bigger [...]
Date: Sat, 7 Apr 2007 04:28:53 +0000
Message-ID: <20070407042853.GV2737@bitfolk.com>
References: <20070407031027.GT2737@bitfolk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FC+OF+RkWR/mYmkL"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070407031027.GT2737@bitfolk.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--FC+OF+RkWR/mYmkL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Sorry for the reply to self, but the last thing I tried has provided
some more info:

On Sat, Apr 07, 2007 at 03:10:27AM +0000, Andy Smith wrote:
> I'm now seeing the exact same problem as Ask did in:
>=20
> http://www.mail-archive.com/linux-raid@vger.kernel.org/msg06762.html
>=20
> again using md raid10 under LVM, trying to export an LV to a xen
> domain.

This LV was initially created as 512M in size.  I extended it to 1G
and experienced the same thing.  I then created a new LV of size 2G,
copied the contents of the first LV to the second, and used that as
the domain's root filesystem.  I no longer get this problem.

I then deleted the original LV and renamed the new LV to the name of
the original and things still work.  I am able to do:

dd if=3D/dev/sda1 of=3D/dev/null

in the Xen domain and not receive any errors so I have to conclude
that all blocks of this second LV are readable.  So is this an issue
of the layout of the LVM extents on disk?  Will I get this problem
again?  Should I be pursuing this on the LVM list, here, or maybe
even with the Xen folks?

Cheers,
Andy

--FC+OF+RkWR/mYmkL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFGFx4FIJm2TL8VSQsRAsK0AJ4golsa3/qswt5RI+KCsG3xvLz2tgCeNCAz
C7Zhpv4bVWoO6/QNog8PNuQ=
=Gi87
-----END PGP SIGNATURE-----

--FC+OF+RkWR/mYmkL--
