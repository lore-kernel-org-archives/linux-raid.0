From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] imsm: platform capabilities are not validated during
 level migration
Date: Thu, 17 Nov 2011 12:02:58 +1100
Message-ID: <20111117120258.0bb75d47@notabene.brown>
References: <F9123E44003394499FDD2B17C60621D405E476@IRSMSX101.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/anhWDWZgbV0b8cQNWLgk2/I"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <F9123E44003394499FDD2B17C60621D405E476@IRSMSX101.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Labun, Marcin" <Marcin.Labun@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/anhWDWZgbV0b8cQNWLgk2/I
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 15 Nov 2011 13:49:36 +0000 "Labun, Marcin" <Marcin.Labun@intel.com>
wrote:

> Subject: [PATCH] imsm: platform capabilities are not validated during lev=
el migration
>=20
> Migration from RAID0 to RAID5 should be blocked on the system without
> support for RAID5. No platform validation was performed in RAID
> level migrations: verification for all level migrations added.
>=20
> Signed-off-by: Marcin Labun <marcin.labun@intel.com>

Applied, thanks.

NeilBrown


> ---
>  super-intel.c |   35 +++++++++++++++++++----------------
>  1 files changed, 19 insertions(+), 16 deletions(-)
>=20
> diff --git a/super-intel.c b/super-intel.c
> index f776be9..b64aa7a 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -5385,7 +5385,11 @@ static int validate_geometry_imsm(struct supertype=
 *st, int level, int layout,
>  	}
>  =09
>  	if (!dev) {
> -		if (st->sb && freesize) {
> +		if (st->sb) {
> +			if (!validate_geometry_imsm_orom(st->sb, level, layout,
> +							 raiddisks, chunk,
> +							 verbose))
> +				return 0;
>  			/* we are being asked to automatically layout a
>  			 * new volume based on the current contents of
>  			 * the container.  If the the parameters can be
> @@ -5394,12 +5398,9 @@ static int validate_geometry_imsm(struct supertype=
 *st, int level, int layout,
>  			 * created.  add_to_super and getinfo_super
>  			 * detect when autolayout is in progress.
>  			 */
> -			if (!validate_geometry_imsm_orom(st->sb, level, layout,
> -							 raiddisks, chunk,
> -							 verbose))
> -				return 0;
> -			return reserve_space(st, raiddisks, size,
> -					     chunk?*chunk:0, freesize);
> +			if (freesize)
> +				return reserve_space(st, raiddisks, size,
> +						     chunk?*chunk:0, freesize);
>  		}
>  		return 1;
>  	}
> @@ -8664,6 +8665,8 @@ enum imsm_reshape_type imsm_analyze_change(struct s=
upertype *st,
>  	int change =3D -1;
>  	int check_devs =3D 0;
>  	int chunk;
> +	int devNumChange=3D0;
> +	int layout =3D -1;
> =20
>  	getinfo_super_imsm_volume(st, &info, NULL);
>  	if ((geo->level !=3D info.array.level) &&
> @@ -8681,23 +8684,23 @@ enum imsm_reshape_type imsm_analyze_change(struct=
 supertype *st,
>  					change =3D -1;
>  					goto analyse_change_exit;
>  				}
> +				layout =3D  geo->layout;
>  				check_devs =3D 1;
> -			}
> -			if (geo->level =3D=3D 10) {
> +				devNumChange =3D 1; /* parity disk added */
> +			} else if (geo->level =3D=3D 10) {
>  				change =3D CH_TAKEOVER;
>  				check_devs =3D 1;
> +				devNumChange =3D 2; /* two mirrors added */
> +				layout =3D 0x102; /* imsm supported layout */
>  			}
>  			break;
>  		case 1:
> -			if (geo->level =3D=3D 0) {
> -				change =3D CH_TAKEOVER;
> -				check_devs =3D 1;
> -			}
> -			break;
>  		case 10:
>  			if (geo->level =3D=3D 0) {
>  				change =3D CH_TAKEOVER;
>  				check_devs =3D 1;
> +				devNumChange =3D -(geo->raid_disks/2);
> +				layout =3D 0; /* imsm raid0 layout */=20
>  			}
>  			break;
>  		}
> @@ -8744,8 +8747,8 @@ enum imsm_reshape_type imsm_analyze_change(struct s=
upertype *st,
>  	chunk =3D geo->chunksize / 1024;
>  	if (!validate_geometry_imsm(st,
>  				    geo->level,
> -				    geo->layout,
> -				    geo->raid_disks,
> +				    layout,
> +				    geo->raid_disks + devNumChange,
>  				    &chunk,
>  				    geo->size,
>  				    0, 0, 1))


--Sig_/anhWDWZgbV0b8cQNWLgk2/I
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTsRdQjnsnt1WYoG5AQIDbA//YS5XdyO30HkZmBicSR6LQkUiFLkL/rDW
whUF4VA6kQ6E3ljmfuNgQQOWL1e5k11KfHz3thCbWlwDgdV7HBo6Ximm6E5vScPm
jPXIagwa5u2nEseyHtjEctha2jb4Rqf/gFcfV6iCDBPa1yfctEUsqJ4xv8QBbOtx
H+CKXVAQ0FTt517oZPRt/r19mK9IQztcrTZVJ7HhEvPAi0bGpwYJwNMqZbEJVFzL
Ruytv4McqW1kWRyAhiscxnZTme4plRUgbcuLD70XFt7VYb64fWCOTAdL8bXwkJ0p
4ds3z54ihg7U3QVPKJ5zWOytJHKVrt0SkWlI+lTVDI5G/UWv8g3poEks4ZpgDkZD
yFH0RGAKqS+9Q5nCZVuNQbhaKwggfSr/Jhpsk+CfcXTgYO8UMziPo2RDmzsJlRae
eOzor+skwGD7zbEkzSYPZCfhKslJ9wFtW7G8F1rXpQkFgQFDiC84cTFvyUmj2Uw4
91xbrRZliam6QU5y7UdrWhM5Vp9T++o8hYjsUZLDENAR5IaCZVBQDE6r+TlS0WUK
kLXtTZ/IFnqp8QqyDy5sH0jn4YjW8vW2sod0RWxYboxdjk5CB0NOAED8a+zNSQII
tFF9ioBSJIzNvz2LClroQnrJRnLvpzxQRItvYtOBuZmhAYFiM4Q5rmz1XIL6v5BN
I4XyLIGItck=
=3900
-----END PGP SIGNATURE-----

--Sig_/anhWDWZgbV0b8cQNWLgk2/I--
