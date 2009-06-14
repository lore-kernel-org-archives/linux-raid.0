From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] md linear: Protecting mddev with rcu locks to avoid races in
Date: Mon, 15 Jun 2009 08:56:18 +1000
Message-ID: <18997.32786.206008.486995@notabene.brown>
References: <37d33d830906060824u1bf71f1ej22efc3e8bbcaf2b9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=unknown
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from SandeepKsinha on Saturday June 6
Sender: linux-raid-owner@vger.kernel.org
To: SandeepKsinha <sandeepksinha@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


Hi,
 Thanks for this patch, and sorry for the delay in reviewing it.

I have a few issues:

On Saturday June 6, sandeepksinha@gmail.com wrote:
> Signed-off-by: Sandeep K Sinha <sandeepksinha@gmail.com>
>=20
>     Protecting mddev with barriers to avoid races.

1/ You need a lot more of an explanatory comment than this.
 At least give some hint as to what the races are.
 Give than the rcu primitives are used, it now makes sense to use
 e.g. call_rcu to free the old 'conf'.  That might reasonably be in a
 separate patch, but the comment on this patch should at least at that
 possibility.
>=20
> diff --git a/drivers/md/linear.c b/drivers/md/linear.c
> index 9ad6ec4..a56095c 100644
> --- a/drivers/md/linear.c
> +++ b/drivers/md/linear.c
> @@ -28,9 +28,11 @@
>  static inline dev_info_t *which_dev(mddev_t *mddev, sector_t sector)
>  {
>  	int lo, mid, hi;
> -	linear_conf_t *conf =3D mddev_to_conf(mddev);
> +	linear_conf_t *conf;=09
>  =09
> +	rcu_read_lock();
>  	lo =3D 0;
> +	conf =3D rcu_dereference(mddev->private);
>  	hi =3D mddev->raid_disks - 1;
>=20

2/ mddev->raid_disks should really be dereferenced before 'conf'.
  Doing it the way you have done it, the 'raid_disks' value could be
  larger than the value supported by the 'conf' so things could
  go wrong.


>  	/*
> @@ -45,7 +47,7 @@ static inline dev_info_t *which_dev(mddev_t *mddev,
> sector_t sector)
>  		else
>  			lo =3D mid + 1;
>  	}
> -
> +	rcu_read_unlock();
>  	return conf->disks + lo;
>  }

3/ We are accessing conf->disks well after the rcu_lock has been releas=
ed.
   That is not exactly a problem with the code as it stands.  But if
   we do go ahead and free the old 'conf' with call_rcu, then this
   becomes racy.
   We should hold the rcu_read_lock for the entire time that we are
   accessing the contents of 'conf'.

   That means we don't take rcu_read_lock in which_dev, but rather
   take it in the two functions that call which_dev.

>=20
> @@ -86,36 +88,49 @@ static int linear_mergeable_bvec(struct request_q=
ueue *q,
>  static void linear_unplug(struct request_queue *q)
>  {
>  	mddev_t *mddev =3D q->queuedata;
> -	linear_conf_t *conf =3D mddev_to_conf(mddev);
> +	linear_conf_t *conf;
>  	int i;
>=20
> +	rcu_read_lock();
> +	conf =3D rcu_dereference(mddev->private);
> +=09
>  	for (i=3D0; i < mddev->raid_disks; i++) {
>  		struct request_queue *r_queue =3D bdev_get_queue(conf->disks[i].rd=
ev->bdev);
>  		blk_unplug(r_queue);
>  	}
> +	rcu_read_unlock();
>  }
>=20
>  static int linear_congested(void *data, int bits)
>  {
>  	mddev_t *mddev =3D data;
> -	linear_conf_t *conf =3D mddev_to_conf(mddev);
> +	linear_conf_t *conf;
>  	int i, ret =3D 0;
>=20
> +	rcu_read_lock();
> +	conf =3D rcu_dereference(mddev->private);
> +=09
>  	for (i =3D 0; i < mddev->raid_disks && !ret ; i++) {
>  		struct request_queue *q =3D bdev_get_queue(conf->disks[i].rdev->bd=
ev);
>  		ret |=3D bdi_congested(&q->backing_dev_info, bits);
>  	}
> +
> +	rcu_read_unlock();
>  	return ret;
>  }
>=20
>  static sector_t linear_size(mddev_t *mddev, sector_t sectors, int ra=
id_disks)
>  {
> -	linear_conf_t *conf =3D mddev_to_conf(mddev);
> -
> +	linear_conf_t *conf;
> +	sector_t array_sectors;
> +	rcu_read_lock();
> +	conf =3D rcu_dereference(mddev->private);
>  	WARN_ONCE(sectors || raid_disks,
>  		  "%s does not support generic reshape\n", __func__);
> -
> -	return conf->array_sectors;
> +	array_sectors =3D conf->array_sectors;
> +	rcu_read_unlock();
> +=09
> +	return array_sectors;
>  }
>=20
>  static linear_conf_t *linear_conf(mddev_t *mddev, int raid_disks)
> @@ -215,15 +230,14 @@ static int linear_add(mddev_t *mddev, mdk_rdev_=
t *rdev)
>  		return -EINVAL;
>=20
>  	rdev->raid_disk =3D rdev->saved_raid_disk;
> -
> -	newconf =3D linear_conf(mddev,mddev->raid_disks+1);
> +	newconf =3D linear_conf(mddev,mddev->raid_disks + 1);
>=20
>  	if (!newconf)
>  		return -ENOMEM;
>=20
>  	newconf->prev =3D mddev_to_conf(mddev);
> -	mddev->private =3D newconf;
>  	mddev->raid_disks++;
> +	rcu_assign_pointer(mddev->private,newconf);
>  	md_set_array_sectors(mddev, linear_size(mddev, 0, 0));
>  	set_capacity(mddev->gendisk, mddev->array_sectors);
>  	return 0;
> @@ -231,14 +245,17 @@ static int linear_add(mddev_t *mddev, mdk_rdev_=
t *rdev)
>=20
>  static int linear_stop (mddev_t *mddev)
>  {
> -	linear_conf_t *conf =3D mddev_to_conf(mddev);
> -
> +	linear_conf_t *conf;
> +
> +	rcu_read_lock();
> +	conf =3D rcu_dereference(mddev->private);
>  	blk_sync_queue(mddev->queue); /* the unplug fn references 'conf'*/
>  	do {
>  		linear_conf_t *t =3D conf->prev;
>  		kfree(conf);
>  		conf =3D t;
>  	} while (conf);
> +	rcu_read_unlock();
>=20

4/ We don't need the rcu protection here as we hold ->reconfig_mutex
   both in linear_add and linear_stop, so they cannot race.
   Adding a comment to this effect might be a good idea though.

Thanks,

NeilBrown


>  	return 0;
>  }
> --=20
> Regards,
> Sandeep.
>=20
>=20
>=20
>=20
>=20
>  =09
> =93To learn is to change. Education is a process that changes the lea=
rner.=94
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
