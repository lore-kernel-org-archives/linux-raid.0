From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] imsm: fix: correct checking newly missing disks
Date: Tue, 15 Nov 2011 15:43:50 +1100
Message-ID: <20111115154350.19ae1de2@notabene.brown>
References: <20111114145252.21148.62905.stgit@gklab-128-085.igk.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/B3qZHoSJKI3Tz.iOEA54dBm"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111114145252.21148.62905.stgit@gklab-128-085.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Lukasz Dorau <lukasz.dorau@intel.com>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, marcin.labun@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

--Sig_/B3qZHoSJKI3Tz.iOEA54dBm
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 14 Nov 2011 15:52:52 +0100 Lukasz Dorau <lukasz.dorau@intel.com>
wrote:

> The problem occurs when RAID10 array under rebuild
> (after one disk fails) is assembled incrementally.
> Mdadm tries to start array just after adding the third disk
> and the volume is assembled incorrectly (in degraded state).
>=20
> The cause is that container_enough depends on
> newly missing disks which are checked incorrectly now.
> They should be checked using always the first map.
>=20
> Signed-off-by: Lukasz Dorau <lukasz.dorau@intel.com>
> ---
>  super-intel.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/super-intel.c b/super-intel.c
> index 4ebee78..511a32a 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -2529,13 +2529,13 @@ static void getinfo_super_imsm(struct supertype *=
st, struct mdinfo *info, char *
> =20
>  		failed =3D imsm_count_failed(super, dev);
>  		state =3D imsm_check_degraded(super, dev, failed);
> -		map =3D get_imsm_map(dev, dev->vol.migr_state);
> +		map =3D get_imsm_map(dev, 0);
> =20
>  		/* any newly missing disks?
>  		 * (catches single-degraded vs double-degraded)
>  		 */
>  		for (j =3D 0; j < map->num_members; j++) {
> -			__u32 ord =3D get_imsm_ord_tbl_ent(dev, i, -1);
> +			__u32 ord =3D get_imsm_ord_tbl_ent(dev, i, 0);
>  			__u32 idx =3D ord_to_idx(ord);
> =20
>  			if (!(ord & IMSM_ORD_REBUILD) &&

Applied,
thanks,

NeilBrown


--Sig_/B3qZHoSJKI3Tz.iOEA54dBm
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTsHuETnsnt1WYoG5AQLAYQ/+K2B6OWxdAigouLaWkaKqciIHRNeCLnNw
wofETW92qlT04XXn7w7wY/A6SJEk0US5lQP6E1dsVnBRtulJ4Y9eh3vKzIXsTVSG
jS0J3fDAF01e+fN1S7bGCnPTbmYJpWMmfV7ytFd63iR81nwPwZZFNfamKpWIJIos
H0F7rKL75ExYHxB0Lo3Nn4UP+NM4M8VI/kodsK1fDmqFvZyrwNUp3u2kWmIXGaY/
zkKk22aHiTjWhCweZCFQ+y+uCRgjJV3DKZRfN5C0VceRuT6jvOqynffQZ2y7BhBu
HRvp6BC9RVC4RN17n8cJ8cqBxuP9xSLUu+JSGtINNoOmnoJksMbv7BzXOV9Rf90D
RUwcZc5+thdGPNUlA56ODXVjrGwsvMiFZ0j6pAnoxFjFfzMlUV/1I7ozblWfwn8F
ywGd04XMkXdKs3R1UOB/3pAL5uhmT8IvLhoQ5bANjsbHqd21cbC5M4NwPy7fTi5K
sFqKJsfWZiU41fK3rLOY13p3Hvr1H9wu4kwCVvieww5+9N1mpfuaWiqCNoDiac2j
i7UiZT4PopFqi4etBibZN/d7hag7PKiqSdvfdWGSWCWOnJRdp9g7vxiuiPlYKdiH
2ueYsX7N5SXS1R13+1p8J4p8fA9bWMN8SMq959U/LJTkNOV7/688XSBNIX6Al44J
2xbmcvKhm/M=
=2r2s
-----END PGP SIGNATURE-----

--Sig_/B3qZHoSJKI3Tz.iOEA54dBm--
