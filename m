From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH] md: avoid warning for 32-bit sector_t
Date: Wed, 16 Dec 2015 15:02:19 +1100
Message-ID: <87si339h2s.fsf@notabene.neil.brown.name>
References: <65226011.NWtA6TWNA3@wuerfel>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <65226011.NWtA6TWNA3@wuerfel>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 24 2015, Arnd Bergmann wrote:

> When CONFIG_LBDAF is not set, sector_t is only 32-bits wide, which
> means we cannot have devices with more than 2TB, and the code that
> is trying to handle compatibility support for large devices in
> md version 0.90 is meaningless but also causes a compile-time warning:
>
> drivers/md/md.c: In function 'super_90_load':
> drivers/md/md.c:1029:19: warning: large integer implicitly truncated to u=
nsigned type [-Woverflow]
> drivers/md/md.c: In function 'super_90_rdev_size_change':
> drivers/md/md.c:1323:17: warning: large integer implicitly truncated to u=
nsigned type [-Woverflow]
>
> This adds a check for CONFIG_LBDAF to avoid even getting into this
> code path, and also adds an explicit cast to let the compiler know
> it doesn't have to warn about the truncation.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> Noticed on ARM randconfig builds with recent gcc versions.
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 0b48c5d7c489..ee9a7ab44f32 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -1025,8 +1025,9 @@ static int super_90_load(struct md_rdev *rdev, stru=
ct md_rdev *refdev, int minor
>  	 * (not needed for Linear and RAID0 as metadata doesn't
>  	 * record this size)
>  	 */
> -	if (rdev->sectors >=3D (2ULL << 32) && sb->level >=3D 1)
> -		rdev->sectors =3D (2ULL << 32) - 2;
> +	if (IS_ENABLED(CONFIG_LBDAF) && (u64)rdev->sectors >=3D (2ULL << 32) &&
> +	    sb->level >=3D 1)
> +		rdev->sectors =3D (sector_t)(2ULL << 32) - 2;
>=20=20
>  	if (rdev->sectors < ((sector_t)sb->size) * 2 && sb->level >=3D 1)
>  		/* "this cannot possibly happen" ... */
> @@ -1319,8 +1320,9 @@ super_90_rdev_size_change(struct md_rdev *rdev, sec=
tor_t num_sectors)
>  	/* Limit to 4TB as metadata cannot record more than that.
>  	 * 4TB =3D=3D 2^32 KB, or 2*2^32 sectors.
>  	 */
> -	if (num_sectors >=3D (2ULL << 32) && rdev->mddev->level >=3D 1)
> -		num_sectors =3D (2ULL << 32) - 2;
> +	if (IS_ENABLED(CONFIG_LBDAF) && (u64)num_sectors >=3D (2ULL << 32) &&
> +	    rdev->mddev->level >=3D 1)
> +		num_sectors =3D (sector_t)(2ULL << 32) - 2;
>  	md_super_write(rdev->mddev, rdev, rdev->sb_start, rdev->sb_size,
>  		       rdev->sb_page);
>  	md_super_wait(rdev->mddev);

applied, thanks.
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWcOJLAAoJEDnsnt1WYoG5vDkP/3RdLR0rx9/R/nyrMlOhIQfS
Ilry8JcJ72hRLKcUCN5onBhLqXqrl9bDlkZEyVbZ0VfJEqwm0nY/E83pPlSk1PN3
cxokPCA5LuBjY5pTYn1BtdG2bQreLcCdJPCoSvvMxoPzuogNCAfG5LLmoLdYIXP/
j3pDu6h1XJGH9fUJl+X+er2txUk+dL+WfkwVC8H/x7ibV8uOUqlY5NkTPyCQwDsJ
uK1R8p79SL1RhlUJqRgozWE1K5EUbvEFyFKqJWtoGRgXALcwf8b3FeQPxhC1lBt8
tx+36HLqIX7Obfq4zS3OCHrr8+kfJuS48/daKVfgVPdLat8yPDepPVugEqnmJGR1
PDn49SDChZZatYKqQCBVgrTrnWSleQ8V775nA0zMikyrqWJ8PIyPhjJYNjv9/yHy
gOQZkXVsLRfQ10au2QdoZlUsFJ4rfF4XYO1NGYNgN+KQLgxMh9hdMyrS4vkmgqUh
8yvPZ8eqWpReuuy1YlLtNVF/zUIpFo5/2QuueaJ5M1Kf+LzIGC+TX5g9gxcR6li+
2GszE+9ak5Lk17/T2Ue2dqgVsyUYtE/2LJceQP6sOghx8xVR1XFPuEQANkOAUyhc
kXd//lIb2Y2uBYaeJs6oWEpuNHnZjdK0x1flf6TrugGHJX9bDy68kzRfIyZSFAny
kZyobpT2wcOD3CeiNk0m
=SNM4
-----END PGP SIGNATURE-----
--=-=-=--
