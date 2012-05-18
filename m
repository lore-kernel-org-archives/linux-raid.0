From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] imsm: fix: check if size of expansion is not larger
 than maximum
Date: Fri, 18 May 2012 13:42:39 +1000
Message-ID: <20120518134239.0a2c8799@notabene.brown>
References: <20120517141400.20390.87947.stgit@gklab-128-085.igk.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/BMT/wsePsCPvXkOQHEL6Ldc"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120517141400.20390.87947.stgit@gklab-128-085.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Lukasz Dorau <lukasz.dorau@intel.com>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

--Sig_/BMT/wsePsCPvXkOQHEL6Ldc
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 17 May 2012 16:14:00 +0200 Lukasz Dorau <lukasz.dorau@intel.com>
wrote:

> We do not check if requested size of expansion is larger than maximum
> available size now. If it is larger the output message is a bit misleadin=
g,
> for example:
>    mdadm: Cannot set size on array members.
>    mdadm: Cannot set device size for /dev/md/vol: Device or resource busy
> Now we check if requested size of expansion is larger than maximum
> available size and the appropriate output message was added.
>=20
> Signed-off-by: Lukasz Dorau <lukasz.dorau@intel.com>

Applied (the second, corrected one).

Thanks,
NeilBrown

> ---
>  super-intel.c |   47 ++++++++++++++++++++++++++++++++---------------
>  1 files changed, 32 insertions(+), 15 deletions(-)
>=20
> diff --git a/super-intel.c b/super-intel.c
> index 733bb38..6c87e20 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -9902,6 +9902,9 @@ enum imsm_reshape_type imsm_analyze_change(struct s=
upertype *st,
>  	struct imsm_dev *dev;
>  	struct intel_super *super;
>  	long long current_size;
> +	unsigned long long free_size;
> +	long long max_size;
> +	int rv;
> =20
>  	getinfo_super_imsm_volume(st, &info, NULL);
>  	if ((geo->level !=3D info.array.level) &&
> @@ -10015,28 +10018,33 @@ enum imsm_reshape_type imsm_analyze_change(stru=
ct supertype *st,
>  				super->current_vol, st->devnum);
>  			goto analyse_change_exit;
>  		}
> +		/* check the maximum available size
> +		 */
> +		rv =3D  imsm_get_free_size(st, dev->vol.map->num_members,
> +					 0, chunk, &free_size);
> +		if (rv =3D=3D 0)
> +			/* Cannot find maximum available space
> +			 */
> +			max_size =3D 0;
> +		else {
> +			max_size =3D free_size + current_size;
> +			/* align component size
> +			 */
> +			max_size =3D imsm_component_size_aligment_check(
> +					get_imsm_raid_level(dev->vol.map),
> +					chunk * 1024,
> +					max_size);
> +		}
>  		if (geo->size =3D=3D 0) {
>  			/* requested size change to the maximum available size
>  			 */
> -			unsigned long long freesize;
> -			int rv;
> -
> -			rv =3D  imsm_get_free_size(st, dev->vol.map->num_members,
> -						 0, chunk, &freesize);
> -			if (rv =3D=3D 0) {
> +			if (max_size =3D=3D 0) {
>  				fprintf(stderr, Name " Error. Cannot find "
>  					"maximum available space.\n");
>  				change =3D -1;
>  				goto analyse_change_exit;
> -			}
> -			geo->size =3D freesize + current_size;
> -
> -			/* align component size
> -			 */
> -			geo->size =3D imsm_component_size_aligment_check(
> -					      get_imsm_raid_level(dev->vol.map),
> -					      chunk * 1024,
> -					      geo->size);
> +			} else
> +				geo->size =3D max_size;
>  		}
> =20
>  		if ((direction =3D=3D ROLLBACK_METADATA_CHANGES)) {
> @@ -10057,6 +10065,15 @@ enum imsm_reshape_type imsm_analyze_change(struc=
t supertype *st,
>  					current_size, geo->size);
>  				goto analyse_change_exit;
>  			}
> +			if (max_size && geo->size > max_size) {
> +				fprintf(stderr,
> +					Name " Error. Requested size is larger "
> +					"than maximum available size (maximum "
> +					"available size is %llu, "
> +					"requested size /rounded/ is %llu).\n",
> +					max_size, geo->size);
> +				goto analyse_change_exit;
> +			}
>  		}
>  		geo->size *=3D data_disks;
>  		geo->raid_disks =3D dev->vol.map->num_members;


--Sig_/BMT/wsePsCPvXkOQHEL6Ldc
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT7XFLznsnt1WYoG5AQIeqQ//WsI7tfkO0CgkS5DJEXmu11ieImdVlVlf
Sy9u5fxY7Ps7W0YBPe8D6OJHK6m+lWJgN4rYmps12wQfuckfgqhKu6TYrwOjbs9Z
BRRTZxaz/CNdWlZhUwHG78nsi5ndXduecWIpZel25DzYsCg5CaO/D2k57rUe5hmE
lbdSnk9wrzqjjCXRFuUZv4L1pcLl2+nE4g+m369Bg2xwYyu/RivMJxipUDWIjNM+
iTfW06FksgidR3Pe0OlawNfRFltbAuhRElM5Er4jypEQCBAM7IpTXY0NctOqFe0N
uF5/25+y09H8NlajyQdBLV9EXMgzHl9U2QMfe0y4jJYwh3+lZRowgoCox8wgrh2T
9r5AVfn8tNr49bvYyaqX5Fht4LzXpRoYGN/NDzJ6HR6U5bf3kDLiOvXyCN/0UOnl
1etbMeb0IkTpxv2b0dZiGJkrjrpg3zUjfltZsc0NznBA0BSDYqVd+UpJVpCeTliA
/5f8930kkK/THciz6QsA7EiUNxlC0m2JWDMKMIqVQzl/zn4HZffWI2R39gJ7dLa/
fFfeP0S89YPyS7dqVnwLsLUkmkuO9G8IaSDrf+TRFRf+99nFhOZklD7zwGj5Sq0K
mmX4XPcwSBJNxJb4P3QJ5XC6ix0CsZVKMBcJPoBYBuygS42pcFIIavSUHMVJVJJn
eOoZscl7gkU=
=KspL
-----END PGP SIGNATURE-----

--Sig_/BMT/wsePsCPvXkOQHEL6Ldc--
