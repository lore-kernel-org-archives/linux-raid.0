From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] md: remove redudent code
Date: Tue, 15 May 2012 18:03:49 +1000
Message-ID: <20120515180349.0f0d275e@notabene.brown>
References: <1337068825-11995-1-git-send-email-yuanhan.liu@linux.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/VqFEOse+MAiSHk0f6D8+1c4"; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1337068825-11995-1-git-send-email-yuanhan.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/VqFEOse+MAiSHk0f6D8+1c4
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 15 May 2012 16:00:25 +0800 Yuanhan Liu <yuanhan.liu@linux.intel.com>
wrote:

> The code does nothing but repating assigning sb->sb_csum with original
> value.

This code sets the sb_csum to 0 while the csum is calculated.

Without this, calculating the csum, setting it, then calculating again would
produce a different result.

So the code is correct as is.

Thanks,
NeilBrown


>=20
> Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
> ---
>  drivers/md/md.c |    4 ----
>  1 files changed, 0 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 0bd44e3..f2d799a 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -1439,15 +1439,12 @@ super_90_rdev_size_change(struct md_rdev *rdev, s=
ector_t num_sectors)
> =20
>  static __le32 calc_sb_1_csum(struct mdp_superblock_1 * sb)
>  {
> -	__le32 disk_csum;
>  	u32 csum;
>  	unsigned long long newcsum;
>  	int size =3D 256 + le32_to_cpu(sb->max_dev)*2;
>  	__le32 *isuper =3D (__le32*)sb;
>  	int i;
> =20
> -	disk_csum =3D sb->sb_csum;
> -	sb->sb_csum =3D 0;
>  	newcsum =3D 0;
>  	for (i=3D0; size>=3D4; size -=3D 4 )
>  		newcsum +=3D le32_to_cpu(*isuper++);
> @@ -1456,7 +1453,6 @@ static __le32 calc_sb_1_csum(struct mdp_superblock_=
1 * sb)
>  		newcsum +=3D le16_to_cpu(*(__le16*) isuper);
> =20
>  	csum =3D (newcsum & 0xffffffff) + (newcsum >> 32);
> -	sb->sb_csum =3D disk_csum;
>  	return cpu_to_le32(csum);
>  }
> =20


--Sig_/VqFEOse+MAiSHk0f6D8+1c4
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT7IN5Tnsnt1WYoG5AQKRPQ//YQsOhXUHzslLwVvne50qinZ/cOlvnf3U
4M8KK76JCF09dgKOSxPKZQuCMJsFETThy2l6vGcv+gEqHjoGMtqqZoFJCmKxpZuq
wJDVjez9mLGlQMPkymkzkrZrJ9lFKFFdqlGyR4osaURBMquDeE1OWbfkN8oZOOWS
GURGKY8IEQ9nTYHZ1GA8i5Ub6J7vs66HpireKmgL/T7ONHSbtG9MsinPUvXxEzEc
SXEczi8NHHTi4FfreuoQsm7fA8YB54E8dwFlAGLGWoNEzXbqd1KEVgaQqdbf4KcM
U8d5gP3qcBKFBee+UGgwHORJtwBWxCsbLafdWtmSqvkfZ/u0H5m9KlEyzF8M5MQL
UGruardVlC38Ap8tWks9Wi0umDkFTv+qgUaZZyeCzylwIIQ7ffurA5Om1v1PT7z5
Rmj6hScVGvhQnkYuaLRnbLtc9v/Uxd4KRjq2SaPEtr8g2+h+haRIb/yqzIg8YaUR
ubjiVeu08k/xffMq9FVfkbmKEh1Tm7EasHXXn5kXTntnvLrUXiinth2HVRZU4tch
RTczV9dlc6Su7S3W+gkcSZpQ82dB+6YKJ0emig8ww31dG0YCDQrONy9+k0hgzI8Q
4tberdSaWNEi5VxwiHBGwq83ogL6XNyQjLR1nVsYMaFC+gQ4eFtsxpC3dJAFotdd
N2xUpmSPqqs=
=0R+N
-----END PGP SIGNATURE-----

--Sig_/VqFEOse+MAiSHk0f6D8+1c4--
