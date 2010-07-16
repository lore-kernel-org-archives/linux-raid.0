From: Justin Bronder <jsbronder@gentoo.org>
Subject: Re: Raid10 device hangs during resync and heavy I/O.
Date: Fri, 16 Jul 2010 14:49:22 -0400
Message-ID: <20100716184922.GA25955@gmail.com>
References: <20100716184618.GA25890@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ibTvN161/egqYuK8"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100716184618.GA25890@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--ibTvN161/egqYuK8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 16/07/10 14:46 -0400, Justin Bronder wrote:
> I've been able to reproduce this across a number of machines with the same
> hardware configuration.  During a raid10 resync, it's possible to hang the
> device so that any further I/O operations will also block.  This can be
> fairly simply done using dd. =20
>=20
> Interestingly, this is not reproducible when using a non-partitioned devi=
ce.
> That is, creating the device with --auto=3Dyes and then directly using it
> functions as expected.  However, using --auto=3Dyes or --auto=3Dmdp and t=
hen
> creating a partition across the device will cause the hang.
>=20
> From all appearances, this is not just slow I/O, days later the same tasks
> are still blocked.  The rest of the system continues to function normally,
> including other raid devices.
>=20
> Below I'm going to include the script I'm using to reproduce, the relevant
> kernel tracebacks, and /proc/mdstat.  Thanks in advance for any help
> resolving this.

My apologies, I should have proof read this first.  I've reproduced using
2.6.28, 2.6.32 and 2.6.34.1.

--=20
Justin Bronder

--ibTvN161/egqYuK8
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iEYEARECAAYFAkxAqbIACgkQ4MrvBE1wQ8nrygCgre4994g+zYv4ZqMTWPPVN1q+
m6EAn12cHTIhmUbeh9wES8sNcb3MCRCr
=ZOX1
-----END PGP SIGNATURE-----

--ibTvN161/egqYuK8--
