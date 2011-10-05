From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/3] Always run Grow_continue() for started array.
Date: Wed, 5 Oct 2011 13:59:09 +1100
Message-ID: <20111005135909.13fe29d9@notabene.brown>
References: <20111004155129.27434.81564.stgit@gklab-128-013.igk.intel.com>
	<20111004155349.27434.70639.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/uDieqdpU24w1Ga4dDqx72fA"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111004155349.27434.70639.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

--Sig_/uDieqdpU24w1Ga4dDqx72fA
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 04 Oct 2011 17:53:49 +0200 Adam Kwolek <adam.kwolek@intel.com> wrot=
e:

> So far there were 2 reshape continuation cases:
>  1. array is started /e.g. reshape was already invoked during initrd
>                       start-up stage using "--freeze-reshape" option/
>  2. array is not started yet /"normal" assembling array under reshape cas=
e/
>=20
> This patch narrows continuation cases in to single one. To do this
> array should be started /set readonly in to array_state/ before calling
> Grow_continue() function.
>=20
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>

I mostly like this patch.
However it seems to have lost something in Grow_continue.
The distinction between ->reshape_active=3D=3D1 and ->reshape_active=3D=3D2
is lost.

=3D=3D1 means just this array is in the middle of a reshape.
=3D=3D2 means that the whole container is being reshaped and after this arr=
ay
is done we need to move on to the next one.

Was there are reason you removed that?  If not, please put it back.

Thanks,
NeilBrown


> ---
>=20
>  Assemble.c |   17 +++++++++++++----
>  Grow.c     |   43 +++++++++++++++++++------------------------
>  2 files changed, 32 insertions(+), 28 deletions(-)
>=20
> diff --git a/Assemble.c b/Assemble.c
> index 4511f4d..0d3730b 100644
> --- a/Assemble.c
> +++ b/Assemble.c
> @@ -1343,10 +1343,14 @@ int Assemble(struct supertype *st, char *mddev,
>  			int rv;
>  #ifndef MDASSEMBLE
>  			if (content->reshape_active &&
> -			    content->delta_disks <=3D 0)
> -				rv =3D Grow_continue(mdfd, st, content,
> -						   backup_file, freeze_reshape);
> -			else
> +			    content->delta_disks <=3D 0) {
> +				rv =3D sysfs_set_str(content, NULL,
> +						   "array_state", "readonly");
> +				if (rv =3D=3D 0)
> +					rv =3D Grow_continue(mdfd, st, content,
> +							   backup_file,
> +							   freeze_reshape);
> +			} else
>  #endif
>  				rv =3D ioctl(mdfd, RUN_ARRAY, NULL);
>  			if (rv =3D=3D 0) {
> @@ -1561,6 +1565,11 @@ int assemble_container_content(struct supertype *s=
t, int mdfd,
>  					   spare, backup_file, verbose) =3D=3D 1)
>  				return 1;
> =20
> +			err =3D sysfs_set_str(content, NULL,
> +					    "array_state", "readonly");
> +			if (err)
> +				return 1;
> +
>  			err =3D Grow_continue(mdfd, st, content, backup_file,
>  					    freeze_reshape);
>  		} else switch(content->array.level) {
> diff --git a/Grow.c b/Grow.c
> index 0b58d5e..076375a 100644
> --- a/Grow.c
> +++ b/Grow.c
> @@ -3797,33 +3797,28 @@ Grow_continue_command_exit:
>  int Grow_continue(int mdfd, struct supertype *st, struct mdinfo *info,
>  		  char *backup_file, int freeze_reshape)
>  {
> -	char buf[40];
> -	char *container =3D NULL;
> -	int err;
> +	int ret_val =3D 2;
> +
> +	if (!info->reshape_active)
> +		return ret_val;
> =20
> -	err =3D sysfs_set_str(info, NULL, "array_state", "readonly");
> -	if (err)
> -		return err;
>  	if (st->ss->external) {
> -		fmt_devname(buf, st->container_dev);
> -		container =3D buf;
> +		char container[40];
> +		int cfd =3D open_dev(st->container_dev);
> =20
> -		if (!mdmon_running(st->container_dev))
> -			start_mdmon(st->container_dev);
> -		ping_monitor_by_id(st->container_dev);
> +		if (cfd < 0)
> +			return 1;
> =20
> +		fmt_devname(container, st->container_dev);
> +		st->ss->load_container(st, cfd, container);
> +		close(cfd);
> +		ret_val =3D reshape_container(container, NULL,
> +					    st, info, 0, backup_file,
> +					    0, 1, freeze_reshape);
> +	} else
> +		ret_val =3D reshape_array(NULL, mdfd, "array", st, info, 1,
> +					NULL, backup_file, 0, 0, 1,
> +					freeze_reshape);
> =20
> -		if (info->reshape_active =3D=3D 2) {
> -			int cfd =3D open_dev(st->container_dev);
> -			if (cfd < 0)
> -				return 1;
> -			st->ss->load_container(st, cfd, container);
> -			close(cfd);
> -			return reshape_container(container, NULL,
> -						 st, info, 0, backup_file,
> -						 0, 1, freeze_reshape);
> -		}
> -	}
> -	return reshape_array(container, mdfd, "array", st, info, 1,
> -			     NULL, backup_file, 0, 0, 1, freeze_reshape);
> +	return ret_val;
>  }
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/uDieqdpU24w1Ga4dDqx72fA
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iD8DBQFOi8f9G5fc6gV+Wb0RAovuAJ0UiZRtfoecfEaUy17BGbHS21npHwCgkbc3
D0OpHaeta7vcczkKjS3LMbs=
=/eAo
-----END PGP SIGNATURE-----

--Sig_/uDieqdpU24w1Ga4dDqx72fA--
