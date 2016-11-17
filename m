From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH 1/2] raid5-cache: update superblock at shutdown/reboot
Date: Thu, 17 Nov 2016 16:18:15 +1100
Message-ID: <87wpg2heg8.fsf@notabene.neil.brown.name>
References: <5d6f023fb1d1398317d07f02634f90b055e26f4b.1479345454.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5d6f023fb1d1398317d07f02634f90b055e26f4b.1479345454.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>, linux-raid@vger.kernel.org
Cc: songliubraving@fb.com, Zhengyuan Liu <liuzhengyuan@kylinos.cn>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 17 2016, Shaohua Li wrote:

> Currently raid5-cache update superblock in .quiesce. But since at
> shutdown/reboot, .quiesce is called with reconfig mutex locked,
> superblock isn't guaranteed to be called in reclaim thread (see
> 8e018c21da3). This will make assemble do unnecessary journal recovery.
> It doesn't corrupt data but is annoying.  This adds an extra hook to
> guarantee journal is flushed to raid disks.  And since this hook is
> called before superblock update, this will guarantee we have a uptodate
> superblock in shutdown/reboot

Hi.
I don't quite follow some of the reasoning here.
In particular, the ->stop_writes() that you have implemented
does almost exactly the same thing as r5l_quiesce(1).
So why not simply call ->quiesce(mddev, 1) in __md_stop_writes()??
You probably need to also call ->quiesce(mddev, 0) to keep things
balanced.

Also you have introduced a static mutex (which isn't my favourite sort
of thing) without giving any explanation why in the changelog comment.
So I cannot easily see if that addition is at all justified.

Thanks,
NeilBrown

>
> Signed-off-by: Shaohua Li <shli@fb.com>
> Cc: Zhengyuan Liu <liuzhengyuan@kylinos.cn>
> Cc: NeilBrown <neilb@suse.com>
> ---
>  drivers/md/md.c          |  3 +++
>  drivers/md/md.h          |  2 ++
>  drivers/md/raid5-cache.c | 19 ++++++++++++++++++-
>  drivers/md/raid5.c       |  3 +++
>  drivers/md/raid5.h       |  1 +
>  5 files changed, 27 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 1f1c7f0..155dd42 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -5471,6 +5471,9 @@ static void __md_stop_writes(struct mddev *mddev)
>=20=20
>  	del_timer_sync(&mddev->safemode_timer);
>=20=20
> +	if (mddev->pers && mddev->pers->stop_writes)
> +		mddev->pers->stop_writes(mddev);
> +
>  	bitmap_flush(mddev);
>=20=20
>  	if (mddev->ro =3D=3D 0 &&
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index af6b33c..8da6fe9 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -512,6 +512,8 @@ struct md_personality
>  	/* congested implements bdi.congested_fn().
>  	 * Will not be called while array is 'suspended' */
>  	int (*congested)(struct mddev *mddev, int bits);
> +	/* stop touching raid disks */
> +	void (*stop_writes)(struct mddev *mddev);
>  };
>=20=20
>  struct md_sysfs_entry {
> diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
> index 2e270e6..641dec8 100644
> --- a/drivers/md/raid5-cache.c
> +++ b/drivers/md/raid5-cache.c
> @@ -738,11 +738,13 @@ static void r5l_write_super_and_discard_space(struc=
t r5l_log *log,
>=20=20
>  static void r5l_do_reclaim(struct r5l_log *log)
>  {
> +	static DEFINE_MUTEX(lock);
>  	sector_t reclaim_target =3D xchg(&log->reclaim_target, 0);
>  	sector_t reclaimable;
>  	sector_t next_checkpoint;
>  	u64 next_cp_seq;
>=20=20
> +	mutex_lock(&lock);
>  	spin_lock_irq(&log->io_list_lock);
>  	/*
>  	 * move proper io_unit to reclaim list. We should not change the order.
> @@ -769,8 +771,10 @@ static void r5l_do_reclaim(struct r5l_log *log)
>  	spin_unlock_irq(&log->io_list_lock);
>=20=20
>  	BUG_ON(reclaimable < 0);
> -	if (reclaimable =3D=3D 0)
> +	if (reclaimable =3D=3D 0) {
> +		mutex_unlock(&lock);
>  		return;
> +	}
>=20=20
>  	/*
>  	 * write_super will flush cache of each raid disk. We must write super
> @@ -784,6 +788,8 @@ static void r5l_do_reclaim(struct r5l_log *log)
>  	log->last_cp_seq =3D next_cp_seq;
>  	mutex_unlock(&log->io_mutex);
>=20=20
> +	mutex_unlock(&lock);
> +
>  	r5l_run_no_space_stripes(log);
>  }
>=20=20
> @@ -836,6 +842,17 @@ void r5l_quiesce(struct r5l_log *log, int state)
>  	}
>  }
>=20=20
> +void r5l_stop_writes(struct mddev *mddev)
> +{
> +	struct r5conf *conf =3D mddev->private;
> +	struct r5l_log *log =3D conf->log;
> +
> +	if (!log)
> +		return;
> +	r5l_wake_reclaim(log, -1L);
> +	r5l_do_reclaim(log);
> +}
> +
>  bool r5l_log_disk_error(struct r5conf *conf)
>  {
>  	struct r5l_log *log;
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index df88656..3d27338 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -7866,6 +7866,7 @@ static struct md_personality raid6_personality =3D
>  	.quiesce	=3D raid5_quiesce,
>  	.takeover	=3D raid6_takeover,
>  	.congested	=3D raid5_congested,
> +	.stop_writes	=3D r5l_stop_writes,
>  };
>  static struct md_personality raid5_personality =3D
>  {
> @@ -7889,6 +7890,7 @@ static struct md_personality raid5_personality =3D
>  	.quiesce	=3D raid5_quiesce,
>  	.takeover	=3D raid5_takeover,
>  	.congested	=3D raid5_congested,
> +	.stop_writes	=3D r5l_stop_writes,
>  };
>=20=20
>  static struct md_personality raid4_personality =3D
> @@ -7913,6 +7915,7 @@ static struct md_personality raid4_personality =3D
>  	.quiesce	=3D raid5_quiesce,
>  	.takeover	=3D raid4_takeover,
>  	.congested	=3D raid5_congested,
> +	.stop_writes	=3D r5l_stop_writes,
>  };
>=20=20
>  static int __init raid5_init(void)
> diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
> index 57ec49f..0643cc0 100644
> --- a/drivers/md/raid5.h
> +++ b/drivers/md/raid5.h
> @@ -633,4 +633,5 @@ extern void r5l_stripe_write_finished(struct stripe_h=
ead *sh);
>  extern int r5l_handle_flush_request(struct r5l_log *log, struct bio *bio=
);
>  extern void r5l_quiesce(struct r5l_log *log, int state);
>  extern bool r5l_log_disk_error(struct r5conf *conf);
> +extern void r5l_stop_writes(struct mddev *mddev);
>  #endif
> --=20
> 2.9.3

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJYLT2YAAoJEDnsnt1WYoG57l4QAL2v87MZG5iKmyBd5WKt2/ki
bpomIYYSJfmb32NJkuHCor7VlChfWKATkmTU5//BG++0GidSg00CpUWhp5Akecpv
kyluACsxARty+MWSOv9HoPDD45qRjqxbwWHscjVrhjy9qiEqqJubkAHtYOJkS67J
o5RkwL3n3WyB4XgeRhiFi0NoE3bV4CP0+tvapssiNt+zDHRtBtSzHHH0mZg0EDkf
E9ykXiPD0aSzOZDyX/5+h76mMSdjWpd0iXgzaqmmPebl6HmG4N0ODBYEKzUUUKV3
BMS5qWOM+vytTqRLGT4NwM16njC/+mh4pPIaeAIfOO76EHj0FtImvO9A9KvSIjLn
/DpdKreBrnEbOrnemupDsLvsZHn05Jtb3uIKzJZrv8RiAGrujGV3J4evdz+6e2t3
Yfh/FgvDTxX6gZLvChe0+a/YGQn3d0yqBOJJ81tOuMBSYPiblEVpS11+3JfIJB6/
+eksSHWzS3d4icoySEJYKXLcV0zM2Dz+n04ipO+7oHOLlp644Pzo01gG0A//cTBe
s7t+lkzatH9Swl9hPUnyl9yoqlYMe+/YI1t0EBZPWRgAksT1hVXP9kLn35J33q1P
DkQ5G5Mfdkyo1IuP2+CX2SG77kKgTezUyzTp9y+7e4vLyJOJgBL148tjwArO0+mz
gvuKSkLVCjWRZYrz+lO4
=87Q3
-----END PGP SIGNATURE-----
--=-=-=--
