From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH v3] super1: fix sb->max_dev when adding a new disk in linear array
Date: Mon, 22 May 2017 09:31:40 +1000
Message-ID: <87lgppkcrn.fsf@notabene.neil.brown.name>
References: <20170519060638.4470-1-lzhong@suse.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170519060638.4470-1-lzhong@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Lidong Zhong <lzhong@suse.com>, linux-raid@vger.kernel.org
Cc: colyli@suse.com, Jes.Sorensen@gmail.com
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, May 19 2017, Lidong Zhong wrote:

> The value of sb->max_dev will always be increased by 1 when adding
> a new disk in linear array. It causes an inconsistence between each
> disk in the array and the "Array State" value of "mdadm --examine DISK"
> is wrong. For example, when adding the first new disk into linear array
> it will be:
>
> Array State : RAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
> ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D replacing)
>
> Adding the second disk into linear array it will be
>
> Array State : .AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
> ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D replacing)
>
> Signed-off-by: Lidong Zhong <lzhong@suse.com>
> ---
>  super1.c | 13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
>
> diff --git a/super1.c b/super1.c
> index 2fcb814..811923f 100644
> --- a/super1.c
> +++ b/super1.c
> @@ -1267,8 +1267,13 @@ static int update_super1(struct supertype *st, str=
uct mdinfo *info,
>  				break;
>  		sb->dev_number =3D __cpu_to_le32(i);
>  		info->disk.number =3D i;
> -		if (max >=3D __le32_to_cpu(sb->max_dev))
> -			sb->max_dev =3D __cpu_to_le32(max+1);
> +		if (i >=3D max) {
> +			while (max <=3D i) {
> +				sb->dev_roles[max] =3D __cpu_to_le16(MD_DISK_ROLE_SPARE);
> +				max +=3D 1;
> +			}
> +			sb->max_dev =3D __cpu_to_le32(max);
> +		}

This part of the patch is OK....

>=20=20
>  		random_uuid(sb->device_uuid);
>=20=20
> @@ -1296,6 +1301,10 @@ static int update_super1(struct supertype *st, str=
uct mdinfo *info,
>  		sb->raid_disks =3D __cpu_to_le32(info->array.raid_disks);
>  		sb->dev_roles[info->disk.number] =3D
>  			__cpu_to_le16(info->disk.raid_disk);
> +		if (sb->raid_disks+1 >=3D __le32_to_cpu(sb->max_dev)) {

sb->raid_disks is an le32 number, not a cpu number.  So adding 1 to
it is clearly wrong.

Why do you think you need a change here at all?

NeilBrown


> +			sb->dev_roles[sb->raid_disks] =3D __cpu_to_le16(MD_DISK_ROLE_SPARE);
> +			sb->max_dev =3D __cpu_to_le32(sb->raid_disks+1);
> +		}
>  	} else if (strcmp(update, "resync") =3D=3D 0) {
>  		/* make sure resync happens */
>  		sb->resync_offset =3D 0ULL;
> --=20
> 2.12.0

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIyBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlkiI1wACgkQOeye3VZi
gbncew/4ilzc0cTz00YTkkdd64rCyasu4DCwUcw//7UHJn7ND1qxlUXzW1egaWSU
UaExyLG1D+JwguH49rVWnpEqzma1DGN/vBOYcN1xM6LGjZtRFLsQI/adkE6Pzuhr
SkNeR72GU8EtgZv+zvg70KbI5C5jHD0oLWJ0tcVH7RJwjqbuir8NgLoW9vmNVUIi
/PA1rClM/f/rbij/Mx3nDa/bMTGCwg7faiY3Kr1Ss0HSshJ639S//RPYHEiZGLqR
OGJoncrHeAR8NvfbtJNul4zz8eKay6n3L/A60g8vsTbHC0/Gn9NGTecoS0vQiKi0
p49ptQjXgJw1+MNeOaWwrGSxdO08ek5at7zRf4p6HDTFxOzPmOrtONYF3UOHryf9
JozXCUOxY0xxGWcZ1EHiQo7ZkmPNJarVby+k4rpwh7EsMVjasj3LdjVxPlpZcGzw
4GwSjPTgPOredVVB4gTw3FIfGd+Rf0U7dShFRvzas79vLp9sJVH1ycDqMZCftw5G
k/o4++x4b87hx9apcKWB/mK6fhja61bvD6YKOCxqijTy/hhahTvYjVb2ofmtAdrP
sdtqPsVZto/1JDtj2v5WHtstxa8xTQWk6Gd6wze/X8ZstcvuKNJarLo40qPuNUoa
zJ+MikS9EY7ouPDEeGcumICHLuL3qXkAQv/bjQ/HNUu2K1amvQ==
=xrbi
-----END PGP SIGNATURE-----
--=-=-=--
