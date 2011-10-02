From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 2/2] imsm: Do not mark resync during reshape
Date: Mon, 3 Oct 2011 10:31:57 +1100
Message-ID: <20111003103157.76dc2714@notabene.brown>
References: <20110929154250.22094.48754.stgit@gklab-128-013.igk.intel.com>
	<20110929154545.22094.64680.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/e1TConmB+cTWKChoyhvbj0A"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110929154545.22094.64680.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

--Sig_/e1TConmB+cTWKChoyhvbj0A
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 29 Sep 2011 17:45:45 +0200 Adam Kwolek <adam.kwolek@intel.com> wrot=
e:

> During reshape, resync/rebuild in the same container is not possible
> due to fact that all arrays in container has to share the same disks set.
>=20
> Block new resync/rebuild process initialization and setting resync_start
> to 0 while any reshape in container is active. This avoids breaking
> container reshape and doesn't allow for starting multiple processes
> /resync/rebuild and reshape/ at the same time in md.
>=20
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> ---
>=20
>  super-intel.c |    8 +++++---
>  1 files changed, 5 insertions(+), 3 deletions(-)
>=20
> diff --git a/super-intel.c b/super-intel.c
> index 5504c17..4c546ac 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -2375,8 +2375,9 @@ static void getinfo_super_imsm_volume(struct supert=
ype *st, struct mdinfo *info,
> =20
>  	info->reshape_progress =3D 0;
>  	info->resync_start =3D MaxSector;
> -	if (map_to_analyse->map_state =3D=3D IMSM_T_STATE_UNINITIALIZED ||
> -	    dev->vol.dirty) {
> +	if ((map_to_analyse->map_state =3D=3D IMSM_T_STATE_UNINITIALIZED ||
> +	    dev->vol.dirty) &&
> +	    imsm_reshape_blocks_arrays_changes(super) =3D=3D 0) {
>  		info->resync_start =3D 0;
>  	}
>  	if (dev->vol.migr_state) {
> @@ -6232,7 +6233,8 @@ static int imsm_set_array_state(struct active_array=
 *a, int consistent)
>  			super->updates_pending++;
>  			a->last_checkpoint =3D 0;
>  		}
> -	} else if (!is_resyncing(dev) && !failed) {
> +	} else if ((!is_resyncing(dev) && !failed) &&
> +		   (imsm_reshape_blocks_arrays_changes(super) =3D=3D 0)) {
>  		/* mark the start of the init process if nothing is failed */
>  		dprintf("imsm: mark resync start\n");
>  		if (map->map_state =3D=3D IMSM_T_STATE_UNINITIALIZED)

Applied.  Thanks,

NeilBrown


--Sig_/e1TConmB+cTWKChoyhvbj0A
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iD8DBQFOiPRtG5fc6gV+Wb0RAtU8AKCCCh7iktyN7JI5oSGAir1iJ3ku8QCfdUAd
R7Xx7Q1KaYCHRGLDCPXktlA=
=FHph
-----END PGP SIGNATURE-----

--Sig_/e1TConmB+cTWKChoyhvbj0A--
