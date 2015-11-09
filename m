From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH 5/6] md-cluster: Fix the remove sequence with the new MD reload code
Date: Tue, 10 Nov 2015 10:49:37 +1100
Message-ID: <87bnb2spgu.fsf@notabene.neil.brown.name>
References: <1446781819-25571-1-git-send-email-rgoldwyn@suse.de> <1446781819-25571-5-git-send-email-rgoldwyn@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1446781819-25571-5-git-send-email-rgoldwyn@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: rgoldwyn@suse.de, linux-raid@vger.kernel.org
Cc: Goldwyn Rodrigues <rgoldwyn@suse.com>, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 06 2015, rgoldwyn@suse.de wrote:

> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
>
> The remove disk message does not need metadata_update_start(), but
> can be an independent message.

This looks good.
Applied - thanks.

NeilBrown


>
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
> ---
>  drivers/md/md-cluster.c | 2 +-
>  drivers/md/md.c         | 9 +--------
>  2 files changed, 2 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
> index 9a36ad6..33f5d7a 100644
> --- a/drivers/md/md-cluster.c
> +++ b/drivers/md/md-cluster.c
> @@ -1018,7 +1018,7 @@ static int remove_disk(struct mddev *mddev, struct =
md_rdev *rdev)
>  	struct md_cluster_info *cinfo =3D mddev->cluster_info;
>  	cmsg.type =3D cpu_to_le32(REMOVE);
>  	cmsg.raid_slot =3D cpu_to_le32(rdev->desc_nr);
> -	return __sendmsg(cinfo, &cmsg);
> +	return sendmsg(cinfo, &cmsg);
>  }
>=20=20
>  static int gather_bitmaps(struct md_rdev *rdev)
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 65b6326..4222285 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -6045,15 +6045,11 @@ static int hot_remove_disk(struct mddev *mddev, d=
ev_t dev)
>  {
>  	char b[BDEVNAME_SIZE];
>  	struct md_rdev *rdev;
> -	int ret =3D -1;
>=20=20
>  	rdev =3D find_rdev(mddev, dev);
>  	if (!rdev)
>  		return -ENXIO;
>=20=20
> -	if (mddev_is_clustered(mddev))
> -		ret =3D md_cluster_ops->metadata_update_start(mddev);
> -
>  	if (rdev->raid_disk < 0)
>  		goto kick_rdev;
>=20=20
> @@ -6064,7 +6060,7 @@ static int hot_remove_disk(struct mddev *mddev, dev=
_t dev)
>  		goto busy;
>=20=20
>  kick_rdev:
> -	if (mddev_is_clustered(mddev) && ret =3D=3D 0)
> +	if (mddev_is_clustered(mddev))
>  		md_cluster_ops->remove_disk(mddev, rdev);
>=20=20
>  	md_kick_rdev_from_array(rdev);
> @@ -6073,9 +6069,6 @@ kick_rdev:
>=20=20
>  	return 0;
>  busy:
> -	if (mddev_is_clustered(mddev) && ret =3D=3D 0)
> -		md_cluster_ops->metadata_update_cancel(mddev);
> -
>  	printk(KERN_WARNING "md: cannot remove active disk %s from %s ...\n",
>  		bdevname(rdev->bdev,b), mdname(mddev));
>  	return -EBUSY;
> --=20
> 1.8.5.6

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWQTERAAoJEDnsnt1WYoG5abAQAMPMBaFzg7ocHmZpjkKWNVr5
COhfzUbkevI/61hZSiaP+DsLzQB9aQ+V/7CCHlzDHrSflLLIwiCDWu7txhMWBGwk
oumO1hbEooR2HRsP8+UqUYgvr/JBxmWGFF98DHvgfeCFFod+4xVoThM4HmW9QDfP
Xh+gvboKNy2YhOthxwfmHm+iMicNfRWXX2jvxk2nVrySBpVL9qQ83W9wM3fWVfIt
zrD6AahyiqOqtqvFA+Fh1hNGlzU/fKmYD9+lNjcw4zs/mmLLEyAm4VMz91gVHl93
QiwnGY55dD489SI+g6OisclzuERArLXgd7Oh/m4a8QLbaCH+i8YAfuVOxPq12rkK
xD/P/IkDxM2gYpDw5+5ZtvANtLcC2a9elo7PySG2/J3cc1NMphY9CM/ik5BAL2+B
zy4Ds1IHbq8Kz6SOsfb+nKkSDFMjGRagtVGHyS3AdEcKAmFnku+KZs6QBeCu3AaH
nX765fcAdQY3qEVm1m/WaIeJse4jy1/ouIdpsInyHFyrgXa5KnDGnGgU7HNrEdKi
hLAt2QMXymfakuv0k1IcNjSo4wVrrUy6wGFB3GHcsiawb9PsvtAn9gOykALSi+Ay
UtHKXLjpycTo9fdDDSSyUbIHf+HzeF/BNk0NWUjPR6XUrn1hiWvd/3UVvYMx+w4Y
1pK/yt8bIAWf9p+wPJmK
=wrXf
-----END PGP SIGNATURE-----
--=-=-=--
