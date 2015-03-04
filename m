From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] Fix stray --cluster-confrim crash
Date: Wed, 4 Mar 2015 13:46:56 +1100
Message-ID: <20150304134656.29c77f3d@notabene.brown>
References: <20150302165549.GA27519@shrek.lan>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/NeCcbXDynhGswtEOW/1jEoP"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150302165549.GA27519@shrek.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/NeCcbXDynhGswtEOW/1jEoP
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 2 Mar 2015 10:55:49 -0600 Goldwyn Rodrigues <rgoldwyn@suse.de> wrot=
e:

> Hi Neil,
>=20
> This fix is againt the md/for-next.
>=20
> A --cluster-confirm without an --add (by another node) can
> crash the kernel.
>=20
> Fix it by guarding it using a state.
>=20
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> ---=20
> diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
> index 03e521a..96679b2 100644
> --- a/drivers/md/md-cluster.c
> +++ b/drivers/md/md-cluster.c
> @@ -42,6 +42,10 @@ struct resync_info {
>  	__le64 hi;
>  };
> =20
> +/* md_cluster_info flags */
> +#define		MD_CLUSTER_WAITING_FOR_NEWDISK		1
> +
> +
>  struct md_cluster_info {
>  	/* dlm lock space and resources for clustered raid. */
>  	dlm_lockspace_t *lockspace;
> @@ -61,6 +65,7 @@ struct md_cluster_info {
>  	struct dlm_lock_resource *no_new_dev_lockres;
>  	struct md_thread *recv_thread;
>  	struct completion newdisk_completion;
> +	unsigned long state;
>  };
> =20
>  enum msg_type {
> @@ -380,9 +385,11 @@ static void process_add_new_disk(struct mddev *mddev=
, struct cluster_msg *cmsg)
>  	snprintf(raid_slot, 16, "RAID_DISK=3D%d", cmsg->raid_slot);
>  	pr_info("%s:%d Sending kobject change with %s and %s\n", __func__, __LI=
NE__, disk_uuid, raid_slot);
>  	init_completion(&cinfo->newdisk_completion);
> +	set_bit(MD_CLUSTER_WAITING_FOR_NEWDISK, &cinfo->state);
>  	kobject_uevent_env(&disk_to_dev(mddev->gendisk)->kobj, KOBJ_CHANGE, env=
p);
>  	wait_for_completion_timeout(&cinfo->newdisk_completion,
>  			NEW_DEV_TIMEOUT);
> +	clear_bit(MD_CLUSTER_WAITING_FOR_NEWDISK, &cinfo->state);
>  }
> =20
> =20
> @@ -832,13 +839,19 @@ static int add_new_disk_finish(struct mddev *mddev)
>  	return ret;
>  }
> =20
> -static void new_disk_ack(struct mddev *mddev, bool ack)
> +static int new_disk_ack(struct mddev *mddev, bool ack)
>  {
>  	struct md_cluster_info *cinfo =3D mddev->cluster_info;
> =20
> +	if (!test_bit(MD_CLUSTER_WAITING_FOR_NEWDISK, &cinfo->state)) {
> +		pr_warn("md-cluster(%s): Spurious cluster confirmation\n", mdname(mdde=
v));
> +		return -EINVAL;
> +	}
> +
>  	if (ack)
>  		dlm_unlock_sync(cinfo->no_new_dev_lockres);
>  	complete(&cinfo->newdisk_completion);
> +	return 0;
>  }
> =20
>  static struct md_cluster_operations cluster_ops =3D {
> diff --git a/drivers/md/md-cluster.h b/drivers/md/md-cluster.h
> index 60d7e58..7417133 100644
> --- a/drivers/md/md-cluster.h
> +++ b/drivers/md/md-cluster.h
> @@ -21,7 +21,7 @@ struct md_cluster_operations {
>  	int (*area_resyncing)(struct mddev *mddev, sector_t lo, sector_t hi);
>  	int (*add_new_disk_start)(struct mddev *mddev, struct md_rdev *rdev);
>  	int (*add_new_disk_finish)(struct mddev *mddev);
> -	void (*new_disk_ack)(struct mddev *mddev, bool ack);
> +	int (*new_disk_ack)(struct mddev *mddev, bool ack);
>  };
> =20
>  #endif /* _MD_CLUSTER_H */
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 23784988..461024d 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -5757,7 +5755,7 @@ static int add_new_disk(struct mddev *mddev, mdu_di=
sk_info_t *info)
> =20
>  	if (mddev_is_clustered(mddev) &&
>  		!(info->state & ((1 << MD_DISK_CLUSTER_ADD) | (1 << MD_DISK_CANDIDATE)=
))) {
> -		pr_err("%s: Cannot add to clustered mddev. Try --cluster-add\n",
> +		pr_err("%s: Cannot add to clustered mddev.\n",
>  			       mdname(mddev));
>  		return -EINVAL;
>  	}
> @@ -5855,7 +5853,11 @@ static int add_new_disk(struct mddev *mddev, mdu_d=
isk_info_t *info)
>  			if (info->state & (1 << MD_DISK_CANDIDATE)) {
>  				/* Through --cluster-confirm */
>  				set_bit(Candidate, &rdev->flags);
> -				md_cluster_ops->new_disk_ack(mddev, true);
> +				err =3D md_cluster_ops->new_disk_ack(mddev, true);
> +				if (err) {
> +					export_rdev(rdev);
> +					return err;
> +				}
>  			} else if (info->state & (1 << MD_DISK_CLUSTER_ADD)) {
>  				/* --add initiated by this node */
>  				err =3D md_cluster_ops->add_new_disk_start(mddev, rdev);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Makes sense.
Applied, thanks.

NeilBrown

--Sig_/NeCcbXDynhGswtEOW/1jEoP
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVPZyIDnsnt1WYoG5AQIgxg/7BASzw6j/xZj6KCoPebCpxyWyaE6BIqrK
DB5DcXf4Oj1gAK2fpQCioqNTBsEKiMqBOMh9tBx5pVKsZtIDfz9K4ZCLa0oViqvj
xeaxme1YQlWTKSMlAXHiIbri+Jvq19X3lQEUSdLLn4MeXbDJRZzDHqufK7kOXHVF
X+uOVUzJ6+q7os0j73kaYnzTZso/6V3U75bSCMkTWOMsBzPuciz+3zn9D+apC1M5
GvhqGlKoSCL7tT7NCrzysPXQx2Fy5c/iM+LUUQTbTJdKL1X0raAMY/UjC8Z8w/9x
SYZG52sDNXo2SG2iTZsS+i2GfjJR1P2pqwExJ/7LXue3hIhfZYj9OEovwbUtEI0S
sJ0slML1X1c2voK8bU/Fx/orwjGhtfizQzYjYRuqShsCiKHiGTaHzqgRHpII2X8b
vQJKrkPQWAf+Bt3+cXFOJRPood4itIpZg3mfDTDawpq9SRs3688KwyCxlGCrY2uq
zvNfWDxLdySnvJWh/CE6VrCt8NsYXR6mdk5MD4+PrGjff5Wzo16gVbtRyxmg8Cqh
6ERuO/vAR9NgRu4uOoSoHbe1cnSSrV5UCOMhjnMX4gvvafCjEb13a4USlRSC2Eua
DsFx7mSsWgnpNKF/HHsqfKfoHwTQn004dm8kyRCT/iO8x7h9nTta6gdk2AP65PMt
NXKyWJTUzKE=
=AzTn
-----END PGP SIGNATURE-----

--Sig_/NeCcbXDynhGswtEOW/1jEoP--
