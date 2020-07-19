From: NeilBrown <neil@brown.name>
Subject: Re: [PATCH v4 1/2] md-cluster: fix safemode_delay value when converting to clustered bitmap
Date: Mon, 20 Jul 2020 09:24:09 +1000
Message-ID: <87k0yzw0km.fsf@notabene.neil.brown.name>
References: <1595156920-31427-1-git-send-email-heming.zhao@suse.com> <1595156920-31427-2-git-send-email-heming.zhao@suse.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1595156920-31427-2-git-send-email-heming.zhao@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Zhao Heming <heming.zhao@suse.com>, neilb@suse.com, jes@trained-monkey.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 19 2020, Zhao Heming wrote:

> When array convert to clustered bitmap, the safe_mode_delay doesn't clean=
 and vice versa.
> the /sys/block/mdX/md/safe_mode_delay keep original value after changing =
bitmap type.
> in safe_delay_store(), the code forbids setting mddev->safemode_delay whe=
n array is clustered.
> So in cluster-md env, the expected safemode_delay value should be 0.
>
> reproduction steps:
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
> md_setup_cluster() is a good place for setting, but md_cluster_stop is=20
> good for clean job when md_setup_cluster return err.
>
> see below flow:
> (user space)
> mdadm -C /dev/md0 -b clustered -e 1.2 -n 2 -l mirror /dev/sda /dev/sdb
> mdadm --grow /dev/md0 -b none
> (kernel space)
> SET_ARRAY_INFO
>  update_array_info
>   + mddev->bitmap_info.nodes =3D 0;
>   + md_cluster_ops->leave(mddev)
>   + md_bitmap_destroy
>      md_bitmap_free //won't trigger md_cluster_stop() because above set 0.
>
> Signed-off-by: Zhao Heming <heming.zhao@suse.com>
> ---
>  drivers/md/md.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index f567f536b529..e20f1d5a5261 100644
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
> @@ -8366,6 +8369,7 @@ int md_setup_cluster(struct mddev *mddev, int nodes)
>  	}
>  	spin_unlock(&pers_lock);
>=20=20
> +	mddev->safemode_delay =3D 0;
>  	return md_cluster_ops->join(mddev, nodes);

I still don't think you should change safemode_delay here until after
=2D>join succeeds.

NeilBrown

>  }
>=20=20
> @@ -8375,6 +8379,7 @@ void md_cluster_stop(struct mddev *mddev)
>  		return;
>  	md_cluster_ops->leave(mddev);
>  	module_put(md_cluster_mod);
> +	mddev->safemode_delay =3D DEFAULT_SAFEMODE_DELAY;
>  }
>=20=20
>  static int is_mddev_idle(struct mddev *mddev, int init)
> --=20
> 2.25.0

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAl8U1hoACgkQOeye3VZi
gbmLSA//ajkOqP+IywGb/KY9xOARSVTEsXf7zSSo/dhUnL7SkyQvX0iFfv+8P7V8
WrUrdukLETRO9l5rXeUeB9TAvbVNmz70uKYi+0kmlOpLsRTYCavQN2W8PV2FTxj4
W6KWPKLhlPEwSIiyCrTZebmW0F2KyRJ569iKKKJ6FFsuq6VCQnE6fd4k1oZv4+iC
ChSMqfT1kIhHbNRNnV+aEfAuqZEOXqF0jfAXv4xlogXFIm+UstdQgPF1g/Rpb1T2
GCV3BML4eeZpUZZiFlXe/DSJ9/2TdDKPOR7e1a2rAPz6Q5q7RENQRkkSzrwhCKQM
UzBLL+miplo31rOG8sebvPtuzPlhvXWLxHd42vBYvhDFRCRlnOyUNE9ZJD234eAm
145AkY0Tq6O3csxUm1krrx9fJNMXWJ8NN1HUrxrOSvCm5MdGyERFdceZT1zAqHLm
8Nx8T1AEHoECr2FibIn4PzThDLA38ukI8NCyFm4uFejQX+La6PvDOFO0CG02w9xr
fA7m7x+NBf52rgPp6QQTKvknOhKGExJkE7NACyyRxV04ePCUhg7HpwXjGW80LSVZ
zsPITeffi0k9gwXANHEhRFVB/qHvAimEYhH4Y30fZ2pYc8L25V9lWw0zpU5dzRDs
rnEP2sQISh2ZKCd7Ai8Z1KgqKkYYPrvOcw1A86DeGRloUdPAEb4=
=NyMm
-----END PGP SIGNATURE-----
--=-=-=--
