From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] enable bypass raid5 journal for full stripe writes
Date: Wed, 30 Sep 2015 18:03:30 +1000
Message-ID: <877fn8l4fh.fsf@notabene.neil.brown.name>
References: <1441346487-4011056-1-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1441346487-4011056-1-git-send-email-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@fb.com, hch@infradead.org, dan.j.williams@intel.com, hch@lst.de, Kernel-team@fb.com, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Song Liu <songliubraving@fb.com> writes:

> Summary:
> To save life time of journal device, we can config the device to
> bypass journal writes for full stripe write. This is configured by:
>
> echo "yes" > /sys/block/mdX/md/r5l_bypass_full_stripe
>
> and
>
> echo "no" > /sys/block/mdX/md/r5l_bypass_full_stripe
>
> For file system integrity, full stripe with REQ_FUA will still
> write to journal first.
>
> This patch applies on top of Shaohua's most recent patches:
>
> http://marc.info/?l=3Dlinux-raid&m=3D144122700510667

This just re-introduces the write hole.
You have no guarantee that all of the writes will complete before a
crash, but some might.
So after a crash on a degraded array, you still get unreliable data.

NeilBrown

>
> Signed-off-by: Song Liu <songliubraving@fb.com>
> Reviewed-by: Shaohua Li <shli@fb.com>
> ---
>  drivers/md/raid5-cache.c | 20 +++++++++++++++++
>  drivers/md/raid5.c       | 56 ++++++++++++++++++++++++++++++++++++++++++=
++++++
>  drivers/md/raid5.h       |  2 ++
>  3 files changed, 78 insertions(+)
>
> diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
> index 410b85b..0c3ddc5 100644
> --- a/drivers/md/raid5-cache.c
> +++ b/drivers/md/raid5-cache.c
> @@ -82,6 +82,8 @@ struct r5l_log {
>=20=20
>  	struct list_head no_space_stripes; /* pending stripes, log has no space=
 */
>  	spinlock_t no_space_stripes_lock;
> +
> +	int bypass_full_stripe;
>  };
>=20=20
>  /*
> @@ -438,6 +440,7 @@ int r5l_write_stripe(struct r5l_log *log, struct stri=
pe_head *sh)
>  	int meta_size;
>  	int reserve;
>  	int i;
> +	int fua =3D 0;
>=20=20
>  	if (!log)
>  		return -EAGAIN;
> @@ -453,6 +456,8 @@ int r5l_write_stripe(struct r5l_log *log, struct stri=
pe_head *sh)
>  		void *addr;
>  		if (!test_bit(R5_Wantwrite, &sh->dev[i].flags))
>  			continue;
> +		if (test_bit(R5_WantFUA, &sh->dev[i].flags))
> +			fua =3D 1;
>  		write_disks++;
>  		/* checksum is already calculated in last run */
>  		if (test_bit(STRIPE_LOG_TRAPPED, &sh->state))
> @@ -462,6 +467,10 @@ int r5l_write_stripe(struct r5l_log *log, struct str=
ipe_head *sh)
>  				addr, PAGE_SIZE);
>  		kunmap_atomic(addr);
>  	}
> +
> +	if (log->bypass_full_stripe && (write_disks =3D=3D sh->disks) && (!fua))
> +		return -EAGAIN;   /* bypass journal device */
> +
>  	parity_pages =3D 1 + !!(sh->qd_idx >=3D 0);
>  	data_pages =3D write_disks - parity_pages;
>=20=20
> @@ -520,6 +529,16 @@ int r5l_handle_flush_request(struct r5l_log *log, st=
ruct bio *bio)
>  	return -EAGAIN;
>  }
>=20=20
> +int r5l_get_bypass_full_stripe(struct r5l_log *log)
> +{
> +	return log->bypass_full_stripe;
> +}
> +
> +void r5l_set_bypass_full_stripe(struct r5l_log *log, int val)
> +{
> +	log->bypass_full_stripe =3D val;
> +}
> +
>  /* This will run after log space is reclaimed */
>  static void r5l_run_no_space_stripes(struct r5l_log *log)
>  {
> @@ -1105,6 +1124,7 @@ int r5l_init_log(struct r5conf *conf, struct md_rde=
v *rdev)
>  	if (!log->io_kc)
>  		goto io_kc;
>=20=20
> +	log->bypass_full_stripe =3D 0;
>  	log->reclaim_thread =3D md_register_thread(r5l_reclaim_thread,
>  		log->rdev->mddev, "reclaim");
>  	if (!log->reclaim_thread)
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 394cdf8..5781987 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -6223,6 +6223,61 @@ raid5_group_thread_cnt =3D __ATTR(group_thread_cnt=
, S_IRUGO | S_IWUSR,
>  				raid5_show_group_thread_cnt,
>  				raid5_store_group_thread_cnt);
>=20=20
> +static ssize_t
> +r5l_show_bypass_full_stripe(struct mddev *mddev, char *page)
> +{
> +	struct r5conf *conf;
> +	int ret =3D 0;
> +
> +	spin_lock(&mddev->lock);
> +	conf =3D mddev->private;
> +	if (conf) {
> +		if (conf->log)
> +			ret =3D sprintf(page, "%s\n",
> +				      r5l_get_bypass_full_stripe(conf->log) ? "yes" : "no");
> +		else
> +			ret =3D sprintf(page, "n/a\n");
> +	}
> +	spin_unlock(&mddev->lock);
> +	return ret;
> +}
> +
> +static ssize_t
> +r5l_store_bypass_full_stripe(struct mddev *mddev, const char *page, size=
_t len)
> +{
> +	struct r5conf *conf;
> +	int err =3D 0;
> +	int val;
> +
> +	if (strncmp(page, "yes", 3) =3D=3D 0 &&
> +	    (page[3] =3D=3D '\n' || page[3] =3D=3D '\0'))
> +		val =3D 1;
> +	else if (strncmp(page, "no", 2) =3D=3D 0 &&
> +	    (page[2] =3D=3D '\n' || page[2] =3D=3D '\0'))
> +		val =3D 0;
> +	else
> +		return -EINVAL;
> +
> +	mddev_suspend(mddev);
> +	spin_lock(&mddev->lock);
> +	conf =3D mddev->private;
> +	if (conf) {
> +		if (conf->log) {
> +			r5l_set_bypass_full_stripe(conf->log, val);
> +		} else
> +			err =3D -EINVAL;
> +	} else
> +		err =3D -ENODEV;
> +	spin_unlock(&mddev->lock);
> +	mddev_resume(mddev);
> +	return err ?: len;
> +}
> +
> +static struct md_sysfs_entry
> +r5l_bypass_full_stripe =3D __ATTR(r5l_bypass_full_stripe, S_IRUGO | S_IW=
USR,
> +				r5l_show_bypass_full_stripe,
> +				r5l_store_bypass_full_stripe);
> +
>  static struct attribute *raid5_attrs[] =3D  {
>  	&raid5_stripecache_size.attr,
>  	&raid5_stripecache_active.attr,
> @@ -6230,6 +6285,7 @@ static struct attribute *raid5_attrs[] =3D  {
>  	&raid5_group_thread_cnt.attr,
>  	&raid5_skip_copy.attr,
>  	&raid5_rmw_level.attr,
> +	&r5l_bypass_full_stripe.attr,
>  	NULL,
>  };
>  static struct attribute_group raid5_attrs_group =3D {
> diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
> index e6b9a40..c1f6935 100644
> --- a/drivers/md/raid5.h
> +++ b/drivers/md/raid5.h
> @@ -630,4 +630,6 @@ extern void r5l_write_stripe_run(struct r5l_log *log);
>  extern void r5l_flush_stripe_to_raid(struct r5l_log *log);
>  extern void r5l_stripe_write_finished(struct stripe_head *sh);
>  extern int r5l_handle_flush_request(struct r5l_log *log, struct bio *bio=
);
> +extern int r5l_get_bypass_full_stripe(struct r5l_log *log);
> +extern void r5l_set_bypass_full_stripe(struct r5l_log *log, int val);
>  #endif
> --=20
> 1.8.1

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWC5dSAAoJEDnsnt1WYoG5sYwQAKuQkzedjwOvHOCE2SyOWFMb
kvP/l7BVfxr8xGRRusxJODGaemBTdkJHoV19ejy7VccxBvB3+1dKXxBevau9YUjR
JUklSU1KPSeUxaww9/z0acD9PSTbkNcBEMMkI62I5urhUswdi953zlSaYrnAnYL6
1rIV/UjjPIH2n1UUd9dic65XSRHr1PGOIw6bnTV6UtIasskoMtX8AlH06j+Oy+G3
xYRaJB2aminvLgHWng6HR81ObSheWMKNOyPe87ADUqxNVxklvKjfZ11q96lT195n
uBhtBLPhHSa/J0WjRYb7WJwx7YbIh0QYZwNbRRZzihgcrdYPZmX4ddHarjGWv2MZ
sQIvOaeG9Q2rjA445JVvjbbi7DmKl6/JGKd4PY5E/4Z/dyZx4pSmDbCjyMQvFptL
m8c48RCZa8hnbJYyt8ah2I5oRWqg1tKt87MH8rXDz5vhhzeQi0iX/7q/mOHVDF6z
N77LL4vHl/foVDx16wYFAsIfuqkzk97e/WeqvYJnBXSyDTJ2VDkKGKE/eI1eQtva
DDDUEjI0WluOpL0mYXWpHGJYdQTle20grDj3g5hLfUzVrJv7C5sMqa6/3eWd8cls
GwwWqkdTahxKrrsNwRNIch7Yfl/As/0sSubgpcZJYxepoSVyjIYKcs2VYZnNzDib
k/J59lU3SY3fi+bdgouF
=KqBV
-----END PGP SIGNATURE-----
--=-=-=--
