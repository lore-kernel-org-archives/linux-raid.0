From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/2] imsm: FIX: Do not allow for spare disk activation
 during reshape
Date: Mon, 3 Oct 2011 10:31:16 +1100
Message-ID: <20111003103116.47d4ccf5@notabene.brown>
References: <20110929154250.22094.48754.stgit@gklab-128-013.igk.intel.com>
	<20110929154536.22094.87434.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/K+X+3PlG4VYCrc6uBfFkbGX"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110929154536.22094.87434.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

--Sig_/K+X+3PlG4VYCrc6uBfFkbGX
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 29 Sep 2011 17:45:36 +0200 Adam Kwolek <adam.kwolek@intel.com> wrot=
e:

> Spare disk activation or starting repair for one array while on second
> reshape is in progress, will lead to IMSM incompatible situation when
> 2 arrays in container shares different disks sets.
> This can cause that 2 processes in container /reshape and rebuild/
> are in progress in parallel. This is IMSM incompatible situation also.
>=20
> Block spare disk activation and starting resync if any reshape in contain=
er
> is in progress.
>=20
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>

Thanks - applied.

(though I changed the while loop into a for loop... I couldn't help myself =
;-)

NeilBrown


> ---
>=20
>  super-intel.c |   33 +++++++++++++++++++++++++++++----
>  1 files changed, 29 insertions(+), 4 deletions(-)
>=20
> diff --git a/super-intel.c b/super-intel.c
> index 07d47b5..5504c17 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -2237,6 +2237,33 @@ static int write_imsm_migr_rec(struct supertype *s=
t)
>  }
>  #endif /* MDASSEMBLE */
> =20
> +/* spare/missing disks activations are not allowe when
> + * array/container performs reshape operation, because
> + * all arrays in container works on the same disks set
> + */
> +int imsm_reshape_blocks_arrays_changes(struct intel_super *super)
> +{
> +	int rv =3D 0;
> +	struct intel_dev *i_dev =3D super->devlist;
> +	struct imsm_dev *dev;
> +
> +	/* check whole container
> +	 */
> +	while (i_dev) {
> +		dev =3D i_dev->dev;
> +		if (dev->vol.migr_state &&
> +		    dev->vol.migr_type =3D=3D MIGR_GEN_MIGR) {
> +			/* No repair during any migration in container
> +			 */
> +			rv =3D 1;
> +			break;
> +		}
> +		i_dev =3D i_dev->next;
> +	}
> +
> +	return rv;
> +}
> +
>  static void getinfo_super_imsm_volume(struct supertype *st, struct mdinf=
o *info, char *dmap)
>  {
>  	struct intel_super *super =3D st->sb;
> @@ -6592,10 +6619,8 @@ static struct mdinfo *imsm_activate_spare(struct a=
ctive_array *a,
>  	dprintf("imsm: activate spare: inst=3D%d failed=3D%d (%d) level=3D%d\n",
>  		inst, failed, a->info.array.raid_disks, a->info.array.level);
> =20
> -	if (dev->vol.migr_state &&
> -	    dev->vol.migr_type =3D=3D MIGR_GEN_MIGR)
> -		/* No repair during migration */
> -		return NULL;
> +	if (imsm_reshape_blocks_arrays_changes(super))
> +			return NULL;
> =20
>  	if (a->info.array.level =3D=3D 4)
>  		/* No repair for takeovered array


--Sig_/K+X+3PlG4VYCrc6uBfFkbGX
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iD8DBQFOiPREG5fc6gV+Wb0RAoHeAKCpW9ikfMAwHAzx6d+z+gdpo4dPgwCgqvTB
RWkpHUyVJUq18pCcaXt+t+Y=
=ZonX
-----END PGP SIGNATURE-----

--Sig_/K+X+3PlG4VYCrc6uBfFkbGX--
