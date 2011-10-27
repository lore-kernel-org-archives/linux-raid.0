From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] FIX: Close unused handle in child process during
 reshape restart
Date: Thu, 27 Oct 2011 15:50:48 +1100
Message-ID: <20111027155048.719e8daf@notabene.brown>
References: <20111026161654.13887.42747.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/iGySwj08CEsY2.gNSn_Y6Ri"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111026161654.13887.42747.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

--Sig_/iGySwj08CEsY2.gNSn_Y6Ri
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 26 Oct 2011 18:16:55 +0200 Adam Kwolek <adam.kwolek@intel.com> wrot=
e:

> When array reshape (e.g. raid0->raid5 migration) is restarted during
> array assembly, file system placed on this array cannot be mounted until
> reshape is finished due to "busy" error.
>=20
> This is caused when reshape is executed on array for external metadata
> and array handle is cloned /forked/ to child process environment but not
> closed.
>=20
> Handle can't be closed before executing Grow_continue() because it is
> used later in code.
>=20
> Close unused handle in child process /reshape_container()/.
> It is similar to close fd handle in reshape_array() before calling
> manage_reshape()/child_monitor() in Grow.c:2290.
>=20
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> ---
>=20
>  Grow.c |   13 +++++++++++--
>  1 files changed, 11 insertions(+), 2 deletions(-)
>=20
> diff --git a/Grow.c b/Grow.c
> index 0e4dd10..93a69fd 100644
> --- a/Grow.c
> +++ b/Grow.c
> @@ -1350,6 +1350,7 @@ static int reshape_array(char *container, int fd, c=
har *devname,
>  			 char *backup_file, int quiet, int forked,
>  			 int restart, int freeze_reshape);
>  static int reshape_container(char *container, char *devname,
> +			     int mdfd,
>  			     struct supertype *st,=20
>  			     struct mdinfo *info,
>  			     int force,
> @@ -1768,7 +1769,7 @@ int Grow_reshape(char *devname, int fd, int quiet, =
char *backup_file,
>  		 * number of devices (On-Line Capacity Expansion) must be
>  		 * performed at the level of the container
>  		 */
> -		rv =3D reshape_container(container, devname, st, &info,
> +		rv =3D reshape_container(container, devname, -1, st, &info,
>  				       force, backup_file, quiet, 0, 0);
>  		frozen =3D 0;
>  	} else {
> @@ -2403,7 +2404,10 @@ release:
>  	return 1;
>  }
> =20
> +/* mdfd handle is passed to be closed in child process (after fork).
> + */
>  int reshape_container(char *container, char *devname,
> +		      int mdfd,
>  		      struct supertype *st,=20
>  		      struct mdinfo *info,
>  		      int force,
> @@ -2446,6 +2450,11 @@ int reshape_container(char *container, char *devna=
me,
>  		break;
>  	}
> =20
> +	/* close unused handle in child process
> +	 */
> +	if (mdfd > -1)
> +		close(mdfd);
> +
>  	while(1) {
>  		/* For each member array with reshape_active,
>  		 * we need to perform the reshape.
> @@ -3821,7 +3830,7 @@ int Grow_continue(int mdfd, struct supertype *st, s=
truct mdinfo *info,
>  		fmt_devname(container, st->container_dev);
>  		st->ss->load_container(st, cfd, container);
>  		close(cfd);
> -		ret_val =3D reshape_container(container, NULL,
> +		ret_val =3D reshape_container(container, NULL, mdfd,
>  					    st, info, 0, backup_file,
>  					    0, 1, freeze_reshape);
>  	} else
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



Applied, thanks.

NeilBrown

--Sig_/iGySwj08CEsY2.gNSn_Y6Ri
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTqjjKDnsnt1WYoG5AQJh7hAAtd0vL8HfcuvlSLFSTz5XPZZpOhgi49II
EQiU0shNI/Ro2OA8SqwBr2XWCnN4+jGYVDjrf4SYCtwJ/4GoyPqTgk97pSUaLgND
fgstPQTFJD8hDTbjuwp9RVA5ayt2m4TiGqbXZ5Jo0P8+fQ7xQiKO62Oj4RS8uTWW
rFoSA0ZMebgGvsLk6W62oqhTNw6wbTh2czi1AslMlbl8J1ZIQyyvpoEfrXQSMNYC
ALzcO0Ja2mdeBncEhZ4+vfxHLYvruz/yxv+9DrN11H92ISL/9FzhurmB0TrTAI5B
TTM1lfYHP0PRkg8Wz5Rlxq0Ps/SzE0eeNwBeawjsr5PKVF9av1BAbj8jW6Wj5Vgn
eNr69MSWmGK0rtNqeUX9Z7pjQxI0ZPxUZWoUsC542naSBuE3yDiKtR60/kqZ1Ajl
8Kh4yzp0MDU+nxsF8U7JWDrWKUU+QAdDqGx1q1UoO8AgmlA166yOzOMSu69TCFJu
8p9v7xrOd3okzkefcNrzS0Y5lwZw9O2YTY+p+y1OLHgQHAIpovE8U+8A4UODYZPW
4gO45JbfEP74YzO/rsOaXqUI9IFEELvIpltzf2n6tg73N1UhWYWTYNsquCFacY41
rcys2WEma1sVoNzHaqzyjOthYXhg56NCaxJqkGhpESYIJJr6iUqITWY60TLVnUHd
mZx6sGNLR5A=
=Q9N6
-----END PGP SIGNATURE-----

--Sig_/iGySwj08CEsY2.gNSn_Y6Ri--
