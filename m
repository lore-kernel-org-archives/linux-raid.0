From: NeilBrown <neilb@suse.com>
Subject: Re: [Patch v5] super1: fix sb->max_dev when adding a new disk in linear array
Date: Fri, 26 May 2017 07:51:54 +1000
Message-ID: <87vaoohaf9.fsf@notabene.neil.brown.name>
References: <20170525092811.3868-1-lzhong@suse.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170525092811.3868-1-lzhong@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Lidong Zhong <lzhong@suse.com>, linux-raid@vger.kernel.org
Cc: colyli@suse.com, Jes.Sorensen@gmail.com
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, May 25 2017, Lidong Zhong wrote:

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

Reviewed-by: NeilBrown <neilb@suse.com>

Thanks,
NeilBrown

> ---
>  super1.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/super1.c b/super1.c
> index 2fcb814..86ec850 100644
> --- a/super1.c
> +++ b/super1.c
> @@ -1267,8 +1267,9 @@ static int update_super1(struct supertype *st, stru=
ct mdinfo *info,
>  				break;
>  		sb->dev_number =3D __cpu_to_le32(i);
>  		info->disk.number =3D i;
> -		if (max >=3D __le32_to_cpu(sb->max_dev))
> +		if (i >=3D max) {
>  			sb->max_dev =3D __cpu_to_le32(max+1);
> +		}
>=20=20
>  		random_uuid(sb->device_uuid);
>=20=20
> @@ -1293,7 +1294,11 @@ static int update_super1(struct supertype *st, str=
uct mdinfo *info,
>  			}
>  		}
>  	} else if (strcmp(update, "linear-grow-update") =3D=3D 0) {
> +		int max =3D __le32_to_cpu(sb->max_dev);
>  		sb->raid_disks =3D __cpu_to_le32(info->array.raid_disks);
> +		if (info->array.raid_disks > max) {
> +			sb->max_dev =3D __cpu_to_le32(max+1);
> +		}
>  		sb->dev_roles[info->disk.number] =3D
>  			__cpu_to_le16(info->disk.raid_disk);
>  	} else if (strcmp(update, "resync") =3D=3D 0) {
> --=20
> 2.12.0

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlknUfwACgkQOeye3VZi
gbkxpQ//fOsCbx18a9niZi5vs83MnmV2S1frDWjdQxlIoe5RL8sYYRz7HxxKxT2C
hVe6JhcLbucUCseiqEjwxKyTHjv/YaomLqMHn7PYyfw7dsbesWgchhE1Bo1uvJZK
KTWtwmCnAQB0U/vOf5FOnsDnOnJxNUoGQrYkotbGvRNoILvDEzpTaRbqk9l5oUZ3
ViHvF5woUMSzFIxASPejSwn791E6vUY7Sgn+RL2me7YfFUsQCrdLLKRGYYojK0pQ
/MOJR/W7O6YxwWcJUaLK9v4k4kEMnY8a/re2yPX6nfoeU3UyDFUTfL1J3Ln1zlfM
RkvPzWVRj1OfmQu3RuqaKVm4tGhX4kIO+hD2S3FUmiC+Bk7OZZh0iEF5W1pQT/eA
sZK1+m/dTCfY8rUaOklGjcq7b4wVxoEvzP9g3kRt5a6ItBRyOq7Hl+i3dpRFD/h9
QTcKTUIXzYnfoSQU2wHemsSs9Bn8SbL6Kq1tTvFsjzya0nnqa6hA/2ai972eJDrB
NQi1AaXZaSdgqmSkE0PLB87yl5wcnDAdGArKadS6UjVLbjQfpUwLiopob4kWakEE
Tp2aHrOZb8fIDQ5yIlO7GCl6QBm0gyA8u8jnv4dwdF/CiaNP3X6+nHHpScTOaPwi
Ydp8peno482qSJI9rTdp6toS6yDzdy5BTNDwtmQhPWvV6EfAARg=
=uANV
-----END PGP SIGNATURE-----
--=-=-=--
