From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 4/6] md: don't export log device
Date: Thu, 08 Oct 2015 12:57:29 +1100
Message-ID: <87pp0q6s1i.fsf@notabene.neil.brown.name>
References: <cover.1443973492.git.shli@fb.com> <7aecea0895b46e28c2b8a876a83da10d7f30d7f1.1443973492.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7aecea0895b46e28c2b8a876a83da10d7f30d7f1.1443973492.git.shli@fb.com>
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
>  drivers/md/md.c    | 4 ++--
>  drivers/md/raid5.c | 2 ++
>  2 files changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index c643c9a..ec6574d 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -2523,7 +2523,7 @@ state_store(struct md_rdev *rdev, const char *buf, =
size_t len)
>  		else
>  			err =3D -EBUSY;
>  	} else if (cmd_match(buf, "remove")) {
> -		if (rdev->raid_disk >=3D 0)
> +		if (rdev->raid_disk >=3D 0 || test_bit(Journal, &rdev->flags))
>  			err =3D -EBUSY;
>  		else {
>  			struct mddev *mddev =3D rdev->mddev;
> @@ -6044,7 +6044,7 @@ static int hot_remove_disk(struct mddev *mddev, dev=
_t dev)
>  	clear_bit(Blocked, &rdev->flags);
>  	remove_and_add_spares(mddev, rdev);
>=20=20
> -	if (rdev->raid_disk >=3D 0)
> +	if (rdev->raid_disk >=3D 0 || test_bit(Journal, &rdev->flags))
>  		goto busy;
>=20=20
>  	if (mddev_is_clustered(mddev))

Neither of these chunks should be needed.
=2D>raid_disk of an active devices is only set to -1 if ->hot_remove_disk
succeeds.
You have make ->hot_remove_disk fail for Journal devices, so ->raid_disk
will be >=3D 0.

NeilBrown

> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 216fa3c..c164501 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -7128,6 +7128,8 @@ static int raid5_remove_disk(struct mddev *mddev, s=
truct md_rdev *rdev)
>  	struct disk_info *p =3D conf->disks + number;
>=20=20
>  	print_raid5_conf(conf);
> +	if (test_bit(Journal, &rdev->flags))
> +		return -EBUSY;
>  	if (rdev =3D=3D p->rdev)
>  		rdevp =3D &p->rdev;
>  	else if (rdev =3D=3D p->replacement)
> --=20
> 2.4.6

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWFc2JAAoJEDnsnt1WYoG5EkwP/0wEdfW6cYglZ5+mEvgHEhBr
/WzR0RCIkcaaaVi+djqaum7O0BIlaTnGQO7cKfmDS+oqsxi/FeSf5pKt1F7Tqkrn
ek4pdjtVfCLdevS+Mg6bAc1UgEfal2I7qfhY1MYYlqFFASf1eTOUGvXFLCs5a1gl
Wl3s3p24oOTiKxbS8DcrYe2auDmht9IRoq5hSo2yTCw5umAvqMo1DPF88z3wA4Yk
BMtwmXoy7GEch5jXhKCb2npa4GiAf0VPny1PK8DTjKxkGD/f1keKwaiSqQK11+ea
UpSwJ2BcCwAzPKBmudMjIYmQ01mzHrvgQjBBrDQkKHwclvgsaQZQ8rVXBHrmdKlS
iHhdhbB8re0Qb9ZqvzpYULv4CxjI7JQkbqkzBDLk6imRgbBmV7+dr/US6lXfK3H5
OtrkPZP9XbTLmoun+UTS5PV6q5rPN6V1tsXcuVw+C1sEw7MSDyPG9gQfUme1L3OA
QJOAzbmYGx4I4I4oNYqMcRasZwFc5VXswMy8pfEMVhybv6eIf/JWGzL4PwEuDc2I
Pn/fQzDsxvAbf0dqh2qvFrmcyGguvgBhQ+MoyaN370Cz+BWLkMaMFqJRADBzBNo/
2xQkI+KV3jhWBVLUI8pYdApHBq9oKO4v8YZF5K3UGH3EIRFdiu9j8SXNC2/nB0Ie
BLsWExKYaCG5fVaVbpeJ
=I4a5
-----END PGP SIGNATURE-----
--=-=-=--
