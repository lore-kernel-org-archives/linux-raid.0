From: NeilBrown <neil@brown.name>
Subject: Re: [PATCH v2] md-cluster: fix safemode_delay value when converting to clustered bitmap
Date: Fri, 17 Jul 2020 09:36:15 +1000
Message-ID: <87wo33vxqo.fsf@notabene.neil.brown.name>
References: <1594911043-16956-1-git-send-email-heming.zhao@suse.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1594911043-16956-1-git-send-email-heming.zhao@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Zhao Heming <heming.zhao@suse.com>, neilb@suse.com, song@kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 16 2020, Zhao Heming wrote:

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
> Neil said md_setup_cluster/md_cluster_stop are good places to fix.
> After investigation, md_setup_cluster() is a good place for setting,
> but md_cluster_stop are not pair for restoring.
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
> v2:
> - change setting path from location_store to md_setup_cluster
> - add restoring path
>
> ---
>  drivers/md/md.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index f567f53..f082f5c 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -101,6 +101,8 @@ static int remove_and_add_spares(struct mddev *mddev,
>   * count by 2 for every hour elapsed between read errors.
>   */
>  #define MD_DEFAULT_MAX_CORRECTED_READ_ERRORS 20
> +/* Default safemode delay: 200 msec */
> +#define DEFAULT_SAFEMODE_DELAY ((200 * HZ)/1000 +1)=20
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

=2D>join can fail.
I'd rather you checked the error there, and only clear safemode_delay if
the return value is zero.

NeilBrown


>  }
>=20=20
> --=20
> 1.8.3.1

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAl8Q5G8ACgkQOeye3VZi
gbmLgRAAmIGiZZ4jNjyexvEdVR3zz4oIguDjNUTJoh9OwqgY7BLN4hL0brooWJ/D
LkKI79E0m2CSrUOPLRUX0Nsf5ZRLspzXcOEGA7n/mZlctiqv8r5+jQx6a4Ll1+bR
U8hIjurc/3rwco/k1eDtgkWNVNyZZoadJEQnP88RPPZDBFP1J2TKSx553Kz2q4IW
iCR7ir/Y0mtREFkVrxZnc5XsVn5Nw/8s87iiN5nbNpWmhZbfLCkLkvG/Pa1hAniU
+qI4WxyyTT0lHP0vC/bsBuflheRYuqZ3kNZQazGfLAUN8sHqpV0M+peiOOKMzivX
swYe+23cPi/Z83ftzL0icgCUkKFXTE0jnV+lOLQjX5uzc/r33jInyVHVvNU/gSKu
22yJ9Md8POYGKlgJzCb9P+pOWSoAFgDm8xfV0bDKHvtp57ZPccNlJs2FQeHXOsL9
dHROycew6sf+IERc1BIDvnOxyjutr4oCEADY8XdXm4m9R1H80NIYhBL4yRwCCjnD
KxDf2M2qTh/dLBjJuTZq+Jyz0ghRLAj8GVwrwJUxIAowI5b+ZeFkMyR7pZArdZNn
RmH03nqOxJY/kn471Fy/iYRkRm+ieiQT9fbRUhoTcHaySIyUCYDJBpPnVScwXeFD
3QCfbql8OuoE1pY6rNL7NSJfbI7cvmfuaBGk8rPkRWR3a2rLKGg=
=Y9yk
-----END PGP SIGNATURE-----
--=-=-=--
