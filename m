From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] imsm: fix, check all volumes state in Grow_continue
 function
Date: Thu, 24 Nov 2011 16:27:29 +1100
Message-ID: <20111124162729.1f575164@notabene.brown>
References: <F9123E44003394499FDD2B17C60621D40604F1@IRSMSX101.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/exhV10HQd5KTEOOUx93oJ2e"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <F9123E44003394499FDD2B17C60621D40604F1@IRSMSX101.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Labun, Marcin" <Marcin.Labun@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/exhV10HQd5KTEOOUx93oJ2e
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 23 Nov 2011 15:26:01 +0000 "Labun, Marcin" <Marcin.Labun@intel.com>
wrote:

> The Grow_continue grows all volumes in the container that are in container
> reshape state, therefore we  need to check blocking bits
> of all volumes in container, not just the one that is pointed by the comm=
and
> line argument.
>=20
> Signed-off-by: Marcin Labun <marcin.labun@intel.com>
> ---
>  Grow.c |   13 +++++++------
>  1 files changed, 7 insertions(+), 6 deletions(-)
>=20
> diff --git a/Grow.c b/Grow.c
> index e7fd7c4..65aa851 100644
> --- a/Grow.c
> +++ b/Grow.c
> @@ -3769,18 +3769,19 @@ int Grow_continue_command(char *devname, int fd,
>  			goto Grow_continue_command_exit;
>  		}
> =20
> -		cc =3D st->ss->container_content(st, subarray);
> +		cc =3D st->ss->container_content(st, NULL);
>  		for (content =3D cc; content ; content =3D content->next) {
>  			char *array;
>  			int allow_reshape =3D 1;
> =20
>  			if (content->reshape_active =3D=3D 0)
>  				continue;
> -			/* The decision about array or container wide
> -			 * reshape is taken in Grow_continue based
> -			 * content->reshape_active state, therefore we
> -			 * need to check_reshape based on
> -			 * reshape_active and subarray name
> +			/* The Grow_continue grows all volumes
> +			 * in the container that are in container
> +			 * reshape state,=20
> +			 * therefore we  need to check blocking bits
> +			 * of all volumes in container, not just the=20
> +			 * one that is pointed by command line argument.
>  			 */
>  			if (content->array.state & (1<<MD_SB_BLOCK_VOLUME))
>  				allow_reshape =3D 0;


I don't think this is right.

There are two sorts of reshapes - those that affect the whole container and
those that affect a single array.

If I run
  mdadm --grow --continue /dev/md/CONTAINER

then it should examine every array and restart any reshape that is pending,
whichever type it is.  You patch doesn't affect this case and I assume it
works.

If I run
  mdadm --grow --contine /dev/md/MEMBER_ARRAY

then it should refuse to restart a container-wide reshape, whether it is
blocked for some reason or not.  This usage should only be allowed to start=
 a
just-this-array reshape and should succeed or fail without any reference to
any other arrays in the container.

Does that make sense?  Can you make that happen?

Thanks,
NeilBrown


--Sig_/exhV10HQd5KTEOOUx93oJ2e
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTs3VwTnsnt1WYoG5AQLSsA//XM1NZdHHd2vhryx6zlKwWyzAA6+7RWJd
H8atQIJLPionlvVFqLusH3JbqFdPkso1WQe65Oyi8kNyfkB9Ml1T2AWhDaXtKTEZ
8uzoF++LW4JSbNcMw3N2WwXfcfgErK4bYGiXdT4wb79DlgnG+5A5yp9muBnV9JG2
SNumYb60eIaxfo/n25A0gMbzPfGLfiPItfM+KMkMxsJgjWc7PZfK5IPRhlS+6HXH
MxYhjahiUWNicvv/BN8AO1g+HOc/2QdrRB9a7X9733nDMuBmYdFv7q6K4Bh4H2sr
qT0tNGikL4wCsN5tn4wB4U1vis+FR98SJb+f501mNeto9WKFM5TrRdDbBiuKzBG6
8YddHldLL3j2ySLVlVXfVUGQI1blN+aTvlNn9FZYEwD1Yunmh2CW7GypXFP9UUsB
iXtYvIuNdehCDfgsLxoPKN83irJLll6Onoe8nsm063MNym/IE2ww78ds+Li/txGK
k/kGTYsD04fciduwqahDs9l3jlWmgHCZQ06yyNr53Ea7+Oa8zncZKVJfzb4OxtLK
i1c+YpflT8a9Bd4N24gvlgV0VeezHAPtFaKjWKWFTEiqiyeEZ3n2wS9NsO7ehDKY
DlP+bRQ/+mGXuCew8M9AkL3P7MT5QEEd/cCWy7cGVGGUxWJSIEnJwNnMwdPXkAAl
J+CJ+CFrkuY=
=UOBl
-----END PGP SIGNATURE-----

--Sig_/exhV10HQd5KTEOOUx93oJ2e--
