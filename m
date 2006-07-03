From: Frank Blendinger <fb@intoxicatedmind.net>
Subject: Re: [PATCH] enable auto=yes by default when using udev
Date: Mon, 3 Jul 2006 13:13:37 +0200
Message-ID: <20060703111337.GR24409@intoxicatedmind.net>
References: <20060702224549.GD12733@percy.comedia.it> <17576.21342.685662.432117@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eNjIDde0W37E3OQP"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <17576.21342.685662.432117@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--eNjIDde0W37E3OQP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 03, 2006 at 09:14:38AM +1000, Neil Brown wrote:
> I'm worried that this test is not very robust.
> On my Debian/unstable system running used, there is no
>  /dev/.udevdb
> though there is a
>  /dev/.udev/db
>=20
> I guess I could test for both, but then udev might change
> again.... I'd really like a more robust check.
>=20
> Maybe I could test if /dev was a mount point?
>=20
> Any other ideas?

Maybe checking for a running 'udevd' process?


Frank

--=20
Frank Blendinger | fb(at)intoxicatedmind.net | GPG: 0x0BF2FE7A
Fingerprint: BB64 F2B8 DFD8 BF90 0F2E 892B 72CF 7A41 0BF2 FE7A
   "Just because I don't care doesn't mean I don't undestand."
                                               (Homer Simpson)

--eNjIDde0W37E3OQP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFEqPvhcs96QQvy/noRAtCrAJ9uJM7g5xQpVaDf2xXfDjbWj6FUQACdHSLq
OBxdyK6CWDM4DR1udcGLQBk=
=qfa5
-----END PGP SIGNATURE-----

--eNjIDde0W37E3OQP--
