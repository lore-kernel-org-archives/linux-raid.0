From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] skip match_mddev_units check for special roles
Date: Wed, 30 Sep 2015 18:06:34 +1000
Message-ID: <874micl4ad.fsf@notabene.neil.brown.name>
References: <1441346435-4009054-1-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1441346435-4009054-1-git-send-email-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@fb.com, hch@infradead.org, dan.j.williams@intel.com, hch@lst.de, Kernel-team@fb.com, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Song Liu <songliubraving@fb.com> writes:

> match_mddev_units is used to check whether 2 RAID arrays share
> same disk(s). Arrays that share disk(s) will not do resync at the
> same time for better performance (fewer HDD seek). However, this
> check should not apply to Spare, Faulty, and Journal disks, as
> they do not paticipate in resync.
>
> In this patch, match_mddev_units skips check for disks with flag
> "Faulty" or "Journal" or raid_disk < 0.
>
> Signed-off-by: Song Liu <songliubraving@fb.com>
> Signed-off-by: Shaohua Li <shli@fb.com>
> ---
>  drivers/md/md.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 95824fb..b96d135 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -1957,13 +1957,23 @@ static int match_mddev_units(struct mddev *mddev1=
, struct mddev *mddev2)
>  	struct md_rdev *rdev, *rdev2;
>=20=20
>  	rcu_read_lock();
> -	rdev_for_each_rcu(rdev, mddev1)
> -		rdev_for_each_rcu(rdev2, mddev2)
> +	rdev_for_each_rcu(rdev, mddev1) {
> +		if (test_bit(Faulty, &rdev->flags) ||
> +		    test_bit(Journal, &rdev->flags) ||
> +		    rdev->raid_disk =3D=3D -1)
> +			continue;
> +		rdev_for_each_rcu(rdev2, mddev2) {
> +			if (test_bit(Faulty, &rdev2->flags) ||
> +			    test_bit(Journal, &rdev2->flags) ||
> +			    rdev2->raid_disk =3D=3D -1)
> +				continue;
>  			if (rdev->bdev->bd_contains =3D=3D
>  			    rdev2->bdev->bd_contains) {
>  				rcu_read_unlock();
>  				return 1;
>  			}
> +		}
> +	}
>  	rcu_read_unlock();
>  	return 0;
>  }
> --=20
> 1.8.1

That makes sense.  Applied, thanks.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWC5gKAAoJEDnsnt1WYoG5MvoP/iJNvM4czBMEM8z8dPD3Bfbj
6xxlxgS1AmYVboE0Ai6gFeY9BdLgLR2X0bJ7ZuQYxt78oJLktPWpFfuKN1qGwmjI
e8CkWwOmtZNdbxsKgkltJQ1juKY4IqAPWlbawB6gGYR28ow9AmctvZWnnBvtcVJp
qQJ8s4XK6JKVlDsJWPBU/PDk2N0NS3/0Rq0/Ppv3w9OW1FZliXBJ8Aoa5qjbSluB
C+rVSsC/lA4PFym78dfhU4472+RAodGyiMgfK1rjlkJW+NWe6qn5FfgauIbSml0Z
8q2I6cNh5Y3pYV0XGnzN/sVhuRXx9XLnRUMjK6U6oh4zl6280sKn4GTwAhPTCkLg
t8DxKYHU++Zqgpg1hYA3U1P9+7En9dZHpJ+m+qUGfaBTZBVPNG3U0AEJs9nK1WNv
1mV4lZ6FamHprZgv73iwC89yzK3TR7MnQeNMmkfJp1a90a/ISVckuNdptKU0zhyh
GOmnp1GWKkYEn7n1OAImjrONoKS74A8PkDWZmaJ6aF3yzE6MXCHDKhHpmfUb34V0
dTZzQ2M+1lCcxUt4WTyahdHTY13b8zkU9ZDI/cOhI47qS0W288LiAqCdGBhYpuaR
rvevRVaSrosNDUVeemQeWVh/SnthGhT//aT9VX0jmGj2LQlMCOs2XO0hsjxsKFqp
mxmYXbw3Top/qsIgHs8e
=FvQF
-----END PGP SIGNATURE-----
--=-=-=--
