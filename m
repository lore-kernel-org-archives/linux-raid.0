From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 2/3] md: don't export log device
Date: Thu, 01 Oct 2015 14:45:32 +1000
Message-ID: <87mvw3jixf.fsf@notabene.neil.brown.name>
References: <cover.1443653794.git.shli@fb.com> <78d0cd55e9c1476869933454e06b3f74ad88ce9c.1443653794.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <78d0cd55e9c1476869933454e06b3f74ad88ce9c.1443653794.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>, linux-raid@vger.kernel.org
Cc: Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Shaohua Li <shli@fb.com> writes:

> If there is IO error in log device, don't export it like other raid
> disks. Otherwise we get kernel crash in different places since
> rdev->bdev, rdev->mddev becomes NULL
>
> Signed-off-by: Shaohua Li <shli@fb.com>
> ---
>  drivers/md/md.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index f1cbb08..0b1d7ef 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -2519,7 +2519,7 @@ state_store(struct md_rdev *rdev, const char *buf, =
size_t len)
>  		else
>  			err =3D -EBUSY;
>  	} else if (cmd_match(buf, "remove")) {
> -		if (rdev->raid_disk >=3D 0)
> +		if (rdev->raid_disk >=3D 0 || test_bit(Journal, &rdev->flags))
>  			err =3D -EBUSY;
>  		else {
>  			struct mddev *mddev =3D rdev->mddev;
> @@ -6040,7 +6040,7 @@ static int hot_remove_disk(struct mddev *mddev, dev=
_t dev)
>  	clear_bit(Blocked, &rdev->flags);
>  	remove_and_add_spares(mddev, rdev);
>=20=20
> -	if (rdev->raid_disk >=3D 0)
> +	if (rdev->raid_disk >=3D 0 || test_bit(Journal, &rdev->flags))
>  		goto busy;
>=20=20
>  	if (mddev_is_clustered(mddev))
> --=20
> 2.4.6

I'd rather keep these details local to the RAID5 code...

Can we just have raid5_remove_disk return -EBUSY when an attempt is made
to remove the Journal device?

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWDLpsAAoJEDnsnt1WYoG5zYYP/1Kgr4jCyeOSBjaGA5CpxECD
n7NN2zt9xc7oqs6NAFZrScGEUUgCdv5XVoY/66bYsyXt8Pmob+ZK6bFBz50EDO5Z
TbCxKLvGQCdkkARefliSz3AShgY3tXye8mfHJ/OkHE35D7ikAIldnscVEm8+igNe
d905wcvxJIBKu2D7DCDI1GN4DHV/zjv15qpqZphm2EhQWL2lNQCTx6IhlYd75hEN
YLxhOTb10ey9m3ZOjTymnEHUe1y4oeJPjg9qe8qLp5h8kphsWQvaeBV9gyzGC2Mk
3OtZRWyFi2EoQuH1BhrXRJjNSfZ5GJaz66hMFNdXZ0nEnC57WGancZ8ulEluTEW7
Dy/9T0LaZZp6e5Xzejfq2DoINFTNwGv/es7cpJ9tTQVfTCxfsBWlDjNMIwlLHC6X
LsFY16L6pCsf1MonrC6tTMl4V3I15Q9cpNEsTTcxRCVhGRKpTzNVR2/sqdzy1EMT
U1vHhujDq+9I2MZsN3+c66Q3F6ylVDsT1V/HFwyFKjU/C5oArqS/bmiO8xYDv+VI
oPiV3DLk1gK9p7OnHNRkONraiY4r7Ebj4VX9JctrY8gj3ooIXeM+estYTryYrT4z
keoh/gHtiBInnk13H321/Ar5MPYCKFptfGwIX0iBC0EFir8FCZXjPtRnBuazqrx4
NP6/wob6BCLuTaPeWYK/
=qCO4
-----END PGP SIGNATURE-----
--=-=-=--
