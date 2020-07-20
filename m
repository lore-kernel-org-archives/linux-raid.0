From: NeilBrown <neil@brown.name>
Subject: Re: [PATCH v5 1/2] md-cluster: fix safemode_delay value when converting to clustered bitmap
Date: Tue, 21 Jul 2020 09:02:33 +1000
Message-ID: <87o8o9vlh2.fsf@notabene.neil.brown.name>
References: <1595268533-7040-1-git-send-email-heming.zhao@suse.com> <1595268533-7040-2-git-send-email-heming.zhao@suse.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1595268533-7040-2-git-send-email-heming.zhao@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Zhao Heming <heming.zhao@suse.com>, neilb@suse.com, song@kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 21 2020, Zhao Heming wrote:

> When array convert to clustered bitmap, the safe_mode_delay doesn't
> clean and vice versa. the /sys/block/mdX/md/safe_mode_delay keep original
> value after changing bitmap type. In safe_delay_store(), the code forbids
> setting mddev->safemode_delay when array is clustered. So in cluster-md
> env, the expected safemode_delay value should be 0.
>
> Reproducible steps:
> ```
> node1 # mdadm --zero-superblock /dev/sd{b,c,d}
> node1 # mdadm -C /dev/md0 -b internal -e 1.2 -n 2 -l mirror /dev/sdb /dev=
/sdc
> node1 # cat /sys/block/md0/md/safe_mode_delay
> 0.204
> node1 # mdadm -G /dev/md0 -b none
> node1 # mdadm --grow /dev/md0 --bitmap=3Dclustered
> node1 # cat /sys/block/md0/md/safe_mode_delay
> 0.204  <=3D=3D doesn't change, should ZERO for cluster-md
>
> node1 # mdadm --zero-superblock /dev/sd{b,c,d}
> node1 # mdadm -C /dev/md0 -b clustered -e 1.2 -n 2 -l mirror /dev/sdb /de=
v/sdc
> node1 # cat /sys/block/md0/md/safe_mode_delay
> 0.000
> node1 # mdadm -G /dev/md0 -b none
> node1 # cat /sys/block/md0/md/safe_mode_delay
> 0.000  <=3D=3D doesn't change, should default value
> ```
>
> Signed-off-by: Zhao Heming <heming.zhao@suse.com>

Reviewed-by: NeilBrown <neilb@suse.de>

Thanks,
NeilBrown


> ---
>  drivers/md/md.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index f567f536b529..1bde3df3fa18 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -101,6 +101,8 @@ static void mddev_detach(struct mddev *mddev);
>   * count by 2 for every hour elapsed between read errors.
>   */
>  #define MD_DEFAULT_MAX_CORRECTED_READ_ERRORS 20
> +/* Default safemode delay: 200 msec */
> +#define DEFAULT_SAFEMODE_DELAY ((200 * HZ)/1000 +1)
>  /*
>   * Current RAID-1,4,5 parallel reconstruction 'guaranteed speed limit'
>   * is 1000 KB/sec, so the extra system load does not show up that much.
> @@ -5982,7 +5984,7 @@ int md_run(struct mddev *mddev)
>  	if (mddev_is_clustered(mddev))
>  		mddev->safemode_delay =3D 0;
>  	else
> -		mddev->safemode_delay =3D (200 * HZ)/1000 +1; /* 200 msec delay */
> +		mddev->safemode_delay =3D DEFAULT_SAFEMODE_DELAY;
>  	mddev->in_sync =3D 1;
>  	smp_wmb();
>  	spin_lock(&mddev->lock);
> @@ -7361,6 +7363,7 @@ static int update_array_info(struct mddev *mddev, m=
du_array_info_t *info)
>=20=20
>  				mddev->bitmap_info.nodes =3D 0;
>  				md_cluster_ops->leave(mddev);
> +				mddev->safemode_delay =3D DEFAULT_SAFEMODE_DELAY;
>  			}
>  			mddev_suspend(mddev);
>  			md_bitmap_destroy(mddev);
> @@ -8355,6 +8358,7 @@ EXPORT_SYMBOL(unregister_md_cluster_operations);
>=20=20
>  int md_setup_cluster(struct mddev *mddev, int nodes)
>  {
> +	int ret;
>  	if (!md_cluster_ops)
>  		request_module("md-cluster");
>  	spin_lock(&pers_lock);
> @@ -8366,7 +8370,10 @@ int md_setup_cluster(struct mddev *mddev, int node=
s)
>  	}
>  	spin_unlock(&pers_lock);
>=20=20
> -	return md_cluster_ops->join(mddev, nodes);
> +	ret =3D md_cluster_ops->join(mddev, nodes);
> +	if (!ret)
> +		mddev->safemode_delay =3D 0;
> +	return ret;
>  }
>=20=20
>  void md_cluster_stop(struct mddev *mddev)
> --=20
> 2.25.0

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAl8WIokACgkQOeye3VZi
gbmyfA//WNy6qfh6u+uHwrKXCCFxj/yjX5tnEzbrAiYYWZPi3LeEjYxqwzo/lYuH
eQz/AlwzQN69+xsx1XYB1cwwgmEcTl1KduOpXCVjprudAehBurn/eiVkrKtYt8+M
CQaHQTfXblviWnZtcrmm7dTunPpKP0k49/L8O0xfNKUsQuHk+vjlsKoNTC9jGzOl
K1dlGCISYhwHtccC7Og5l4CD/3RDRGnixWavpFuoHRD0OCQq6zdcm7uF4w8NCDCK
ORADwJ8467ZW/ZyBn2Q9vMGD0/DSNKrVSQfKw8Jig/KDWeg8AP4Iotk6NBa4zl9z
zlT69LOyGenqZyX5w2GX1WD+/6bN1kLEQE3VHLbA1WHTB81BBBTduaZAR6D+GQ+I
usMRLEJyvYPDn08EYAZgQK++Y5C3gSEqFdUIX0vMzhSAqBz07U7YE2raWweMgfGe
P1gfmPlnxZVM7b9Y6Q6iqpy81hAVEdNyTu4TyHIdf6f4rQQApRxrLp4Nb2LimLkH
VwPjFpvK+FW4qssehL8ujg9rJCLzjbyiqXsOSQtYI/nZtCY6OYJxQVQaGIglJayo
B7Tr033Hy9QwVCHIGqtm9C3EJI0zRYozQYFXCYkad6TjSMYDRHWZPTTFciKTMNoP
fngTWQJYdLIkrOzc0plo1KWkCWcU/PmdxncGDaEFrMC0WgU0y8s=
=e6up
-----END PGP SIGNATURE-----
--=-=-=--
