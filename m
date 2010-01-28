From: Andre Noll <maan@systemlinux.org>
Subject: Re: [mdadm PATCH] Kill: fix when zeroing busy devices.
Date: Thu, 28 Jan 2010 17:31:57 +0100
Message-ID: <20100128163157.GT7517@skl-net.de>
References: <20100128154844.31790.44309.stgit@awojcik-linux>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PVZB3C997XEKXh6G"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100128154844.31790.44309.stgit@awojcik-linux>
Sender: linux-raid-owner@vger.kernel.org
To: Artur Wojcik <artur.wojcik@intel.com>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids


--PVZB3C997XEKXh6G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 16:48, Artur Wojcik wrote:
> mdadm should not wait indefinitely when it trys to reset
> superblock on device which is busy (cannot be opened).
>=20
> Signed-off-by: Artur Wojcik <artur.wojcik@intel.com>
> ---
>  Kill.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/Kill.c b/Kill.c
> index 63442a6..a65b865 100644
> --- a/Kill.c
> +++ b/Kill.c
> @@ -46,7 +46,7 @@ int Kill(char *dev, struct supertype *st, int force, in=
t quiet, int noexcl)
>  			fprintf(stderr, Name ": Couldn't open %s for write - not zeroing\n",
>  				dev);
>  		close(fd);
> -		return 1;
> +		return 2;
>  	}
>  	if (st =3D=3D NULL)
>  		st =3D guess_super(fd);

Jup.

	Acked-by: Andre Noll <maan@systemlinux.org>

BTW: Mind to kill the close(fd) as well (as fd is negative) while
we're at it? A comment that explains the meaning of the return value
would also be nice.

Thanks
Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--PVZB3C997XEKXh6G
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFLYbv9Wto1QDEAkw8RAnppAJ9+YdcZYHBPBn2GhT6L+qb7hoPqJACcCjDA
2AlarZ5ZLxW4TkFSpp8d8Rc=
=6y4c
-----END PGP SIGNATURE-----

--PVZB3C997XEKXh6G--
