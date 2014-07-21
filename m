From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] IMSM: move "validate_container_imsm" to be included in
 mdassemble
Date: Mon, 21 Jul 2014 16:57:43 +1000
Message-ID: <20140721165743.4be73256@notabene.brown>
References: <20140718150127.10665.91982.stgit@gklab-154-222.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/cO6=3rSSCEp1Yd.6h=70mTE"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140718150127.10665.91982.stgit@gklab-154-222.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Pawel Baldysiak <pawel.baldysiak@intel.com>, ssuominen@gentoo.org
Cc: linux-raid@vger.kernel.org, artur.paszkiewicz@intel.com
List-Id: linux-raid.ids

--Sig_/cO6=3rSSCEp1Yd.6h=70mTE
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 18 Jul 2014 17:01:27 +0200 Pawel Baldysiak
<pawel.baldysiak@intel.com> wrote:

> Commit 0c21b485e4beb7bcfe631412a231f7c1ea1067bc added new
> function in imsm superswitch. This function should be
> included in mdassemble.
>=20
> Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
> ---
>  super-intel.c |   82 +++++++++++++++++++++++++++++----------------------=
------
>  1 file changed, 41 insertions(+), 41 deletions(-)
>=20
> diff --git a/super-intel.c b/super-intel.c
> index b4efa72..e28ac7d 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -9048,6 +9048,47 @@ int open_backup_targets(struct mdinfo *info, int r=
aid_disks, int *raid_fds,
>  	return 0;
>  }
> =20
> +/***********************************************************************=
********
> + * Function:	validate_container_imsm
> + * Description: This routine validates container after assemble,
> + *		eg. if devices in container are under the same controller.
> + *
> + * Parameters:
> + *	info	: linked list with info about devices used in array
> + * Returns:
> + *	1 : HBA mismatch
> + *	0 : Success
> + ***********************************************************************=
*******/
> +int validate_container_imsm(struct mdinfo *info)
> +{
> +	if (!check_env("IMSM_NO_PLATFORM")) {
> +		struct sys_dev *idev;
> +		struct mdinfo *dev;
> +		char *hba_path =3D NULL;
> +		char *dev_path =3D devt_to_devpath(makedev(info->disk.major,
> +										info->disk.minor));
> +
> +		for (idev =3D find_intel_devices(); idev; idev =3D idev->next) {
> +			if (strstr(dev_path, idev->path)) {
> +				hba_path =3D idev->path;
> +				break;
> +			}
> +		}
> +		free(dev_path);
> +
> +		if (hba_path) {
> +			for (dev =3D info->next; dev; dev =3D dev->next) {
> +				if (!devt_attached_to_hba(makedev(dev->disk.major,
> +						dev->disk.minor), hba_path)) {
> +					pr_err("WARNING - IMSM container assembled with disks under differe=
nt HBAs!\n"
> +						"       This operation is not supported and can lead to data loss.=
\n");
> +					return 1;
> +				}
> +			}
> +		}
> +	}
> +	return 0;
> +}
>  #ifndef MDASSEMBLE
>  /***********************************************************************=
********
>   * Function:	init_migr_record_imsm
> @@ -10524,47 +10565,6 @@ abort:
>  	return ret_val;
>  }
> =20
> -/***********************************************************************=
********
> - * Function:	validate_container_imsm
> - * Description: This routine validates container after assemble,
> - *		eg. if devices in container are under the same controller.
> - *
> - * Parameters:
> - *	info	: linked list with info about devices used in array
> - * Returns:
> - *	1 : HBA mismatch
> - *	0 : Success
> - ***********************************************************************=
*******/
> -int validate_container_imsm(struct mdinfo *info)
> -{
> -	if (!check_env("IMSM_NO_PLATFORM")) {
> -		struct sys_dev *idev;
> -		struct mdinfo *dev;
> -		char *hba_path =3D NULL;
> -		char *dev_path =3D devt_to_devpath(makedev(info->disk.major,
> -										info->disk.minor));
> -
> -		for (idev =3D find_intel_devices(); idev; idev =3D idev->next) {
> -			if (strstr(dev_path, idev->path)) {
> -				hba_path =3D idev->path;
> -				break;
> -			}
> -		}
> -		free(dev_path);
> -
> -		if (hba_path) {
> -			for (dev =3D info->next; dev; dev =3D dev->next) {
> -				if (!devt_attached_to_hba(makedev(dev->disk.major,
> -						dev->disk.minor), hba_path)) {
> -					pr_err("WARNING - IMSM container assembled with disks under differe=
nt HBAs!\n"
> -						"       This operation is not supported and can lead to data loss.=
\n");
> -					return 1;
> -				}
> -			}
> -		}
> -	}
> -	return 0;
> -}
>  #endif /* MDASSEMBLE */
> =20
>  struct superswitch super_imsm =3D {


Applied, thanks.

Though I do wonder if we really need mdassemble.  Is there a convincing
use-case?

NeilBrown


--Sig_/cO6=3rSSCEp1Yd.6h=70mTE
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU8y55znsnt1WYoG5AQKaiA/9EybUS+DHiaZD6Rt4O/BAT41HFGezvryK
f0rm1AzvW49w6lySkaitS/Iz4nodpaEeY4CWDrL3cT73r7WabcGhobyYFGnmhsPe
MzrPm9JWaqnBe3vjJn0CSCk4oCmN0d0RdF5Vj7kA1WlmKH543M6Xq8BUw/tBn+lU
mhIycy7V3BrPqY9rosfketgFJ2BHpyGHcQbxlkbBh3/LUiJEyJ/JEgZf5lnXkUpc
6lYJGmOZlL29286V6VhZbRcbKtIErwM1CQ9B4+pioX36ClmUnbRqLQiFbk958XU+
IMaasoFq/re/jAild3JkPZs/cip7AeHWsmXUZMj0AvKONgZ7VYNIaadSBXUuR+AI
kX+StrgkA0+tcyWA5xVO2zdVwDg/gSH3hChLYorxWoE33hkBzM7CtfU/jPeN966y
cukdusFjLwdmCmhyfhTB0NyMukZekzstXVpQVIYBIaATS81tdUwtFgSq36IjdLJG
tjyYkZ9ar6CRlD+ubwQm3WDxC/LI83Rf8jcimN8rciT3S1UOBjS1lz0873RiXxr2
hCafr0YGkeDqRJupyoLvHuUGlfrT76UOEYMVv6Pw/Z+NuREnbQ/76iu7/hH1P6lB
uB45SrmlOg9H71K1/mzUfiRGfXKhNkMn6ydlkTuzYLXc8MUGKjHz26drek7hdrca
ESCnZ08npAs=
=cMA9
-----END PGP SIGNATURE-----

--Sig_/cO6=3rSSCEp1Yd.6h=70mTE--
