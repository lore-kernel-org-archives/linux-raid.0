From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] imsm: always use set_migr_type to set type of migration
Date: Thu, 6 Oct 2011 14:54:27 +1100
Message-ID: <20111006145427.19017f19@notabene.brown>
References: <20111005095949.28631.81041.stgit@gklab-128-081.igk.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/owp8VS7XTRRMeOrddi.Bty4"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111005095949.28631.81041.stgit@gklab-128-081.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, marcin.labun@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

--Sig_/owp8VS7XTRRMeOrddi.Bty4
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 05 Oct 2011 11:59:50 +0200 Przemyslaw Czarnowski
<przemyslaw.hawrylewicz.czarnowski@intel.com> wrote:

> For 'resync' besides the update of migration type (imsm_vol.migr_type
> structure) additionally status (imsm_dev.status) flag is set to
> DEV_VERIFY_AND_FIX. In order to clean up after migration, status flag
> must be cleared. For this reason, migration type shouldn't be set
> directly but via set_migr_type(). Otherwise status does not reflect
> the state of array.
>=20
> Signed-off-by: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@i=
ntel.com>
> ---
>  super-intel.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
>=20
> diff --git a/super-intel.c b/super-intel.c
> index 3185e91..216ec21 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -3112,7 +3112,7 @@ static void end_migration(struct imsm_dev *dev, __u=
8 map_state)
>  			}
> =20
>  	dev->vol.migr_state =3D 0;
> -	dev->vol.migr_type =3D 0;
> +	set_migr_type(dev, 0);
>  	dev->vol.curr_migr_unit =3D 0;
>  	map->map_state =3D map_state;
>  }
> @@ -6124,7 +6124,7 @@ static void imsm_progress_container_reshape(struct =
intel_super *super)
>  		map->num_members =3D prev_disks;
>  		dev->vol.migr_state =3D 1;
>  		dev->vol.curr_migr_unit =3D 0;
> -		dev->vol.migr_type =3D MIGR_GEN_MIGR;
> +		set_migr_type(dev, MIGR_GEN_MIGR);
>  		for (i =3D prev_num_members;
>  		     i < map->num_members; i++)
>  			set_imsm_ord_tbl_ent(map, i, i);
> @@ -6174,7 +6174,7 @@ static int imsm_set_array_state(struct active_array=
 *a, int consistent)
>  				if (0) {
>  				struct imsm_map *map2 =3D get_imsm_map(dev, 1);
>  				dev->vol.migr_state =3D 0;
> -				dev->vol.migr_type =3D 0;
> +				set_migr_type(dev, 0);
>  				dev->vol.curr_migr_unit =3D 0;
>  				memcpy(map, map2, sizeof_imsm_map(map2));
>  				super->updates_pending++;
> @@ -7053,7 +7053,7 @@ static int apply_reshape_container_disks_update(str=
uct imsm_update_reshape *u,
>  			devices_to_reshape--;
>  			newdev->vol.migr_state =3D 1;
>  			newdev->vol.curr_migr_unit =3D 0;
> -			newdev->vol.migr_type =3D MIGR_GEN_MIGR;
> +			set_migr_type(newdev, MIGR_GEN_MIGR);
>  			newmap->num_members =3D u->new_raid_disks;
>  			for (i =3D 0; i < delta_disks; i++) {
>  				set_imsm_ord_tbl_ent(newmap,
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Applied, thanks.

NeilBrown


--Sig_/owp8VS7XTRRMeOrddi.Bty4
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTo0mcznsnt1WYoG5AQIAGQ//Qhl3eeHTQAfDaUySKu8VdD1H9Mcix0yI
AR5SH+rppCOeSA4vA9fsdPWkLQak7+DRpT3Cl0AirTkEKfkOByjYpzWMU376/b1J
1vyFBlVRhN51MgbypCi9CLCN3CIfumH8EKlycEv1G27u3OYskPSbL4tSjVxRh7Ry
mI35Nn0BbYAzAOPP+wGvW2D12b1aGfpNGMF1Dy3nyh8V6O4n0TvoGtTTLZRZmvqF
dwhyOq3HuReNreKvfjo2hdR1xrhw3SYJEs43PvsSQwQrwruoPReQJ4N4I6OH7QrB
8et+d+ARzLRAM53nEOGQJm5hCWIb0bFr0Xm8pdgfyttBVld5oPlxoRipTD9F9jy8
tcAgZSSIaGj7HQrg/llAZThO/qNM3YSuN30eBSRHFK4O29sSmKRLL4tDeQQWPFnx
vtV/jrCs8Un9FfcBD0oY8w946JRUooV9yFuY5IYvA0J60btTWTrgL6M/CE7wiTQA
tE7CIQr8A3B+oTFNXCYECH5SO6CXmEhog4VXMtAWAja24ZSbE+ehY0ID8c+fMOoH
oDlbtm3AGF5BHJBMwJelK+InHmxW0/iLvhDzDej0arSZ4UrdfmuOkDx0CG0/hb6F
51HRsfwMCnkyqfJlpDP9JylAudZbn+mr+suZDG9RMqFIkdL4a8a84Yh5u08h0ZSZ
zWBt8GwQT/g=
=08SY
-----END PGP SIGNATURE-----

--Sig_/owp8VS7XTRRMeOrddi.Bty4--
