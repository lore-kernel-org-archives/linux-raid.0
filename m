From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH v5] md/r5cache: handle alloc_page failure
Date: Fri, 25 Nov 2016 14:38:54 +1100
Message-ID: <87h96w9qk1.fsf@notabene.neil.brown.name>
References: <20161124065039.2151784-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161124065039.2151784-1-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@fb.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, liuzhengyuang521@gmail.com, liuzhengyuan@kylinos.cn, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 24 2016, Song Liu wrote:

> RMW of r5c write back cache uses an extra page to store old data for
> prexor. handle_stripe_dirtying() allocates this page by calling
> alloc_page(). However, alloc_page() may fail.
>
> To handle alloc_page() failures, this patch adds an extra page to
> disk_info. When alloc_page fails, handle_stripe() trys to use these
> pages. When these pages are used by other stripe (R5C_EXTRA_PAGE_IN_USE),
> the stripe is added to delayed_list.
>
> Signed-off-by: Song Liu <songliubraving@fb.com>

Reviewed-by: NeilBrown <neilb@suse.com>

Thanks,
NeilBrown


> ---
>  drivers/md/raid5-cache.c | 27 ++++++++++++++++-
>  drivers/md/raid5.c       | 78 ++++++++++++++++++++++++++++++++++++++++--=
------
>  drivers/md/raid5.h       |  6 ++++
>  3 files changed, 98 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
> index 8cb79fc..818874d 100644
> --- a/drivers/md/raid5-cache.c
> +++ b/drivers/md/raid5-cache.c
> @@ -2334,15 +2334,40 @@ int r5c_try_caching_write(struct r5conf *conf,
>   */
>  void r5c_release_extra_page(struct stripe_head *sh)
>  {
> +	struct r5conf *conf =3D sh->raid_conf;
>  	int i;
> +	bool using_disk_info_extra_page;
> +
> +	using_disk_info_extra_page =3D
> +		sh->dev[0].orig_page =3D=3D conf->disks[0].extra_page;
>=20=20
>  	for (i =3D sh->disks; i--; )
>  		if (sh->dev[i].page !=3D sh->dev[i].orig_page) {
>  			struct page *p =3D sh->dev[i].orig_page;
>=20=20
>  			sh->dev[i].orig_page =3D sh->dev[i].page;
> -			put_page(p);
> +			if (!using_disk_info_extra_page)
> +				put_page(p);
>  		}
> +
> +	if (using_disk_info_extra_page) {
> +		clear_bit(R5C_EXTRA_PAGE_IN_USE, &conf->cache_state);
> +		md_wakeup_thread(conf->mddev->thread);
> +	}
> +}
> +
> +void r5c_use_extra_page(struct stripe_head *sh)
> +{
> +	struct r5conf *conf =3D sh->raid_conf;
> +	int i;
> +	struct r5dev *dev;
> +
> +	for (i =3D sh->disks; i--; ) {
> +		dev =3D &sh->dev[i];
> +		if (dev->orig_page !=3D dev->page)
> +			put_page(dev->orig_page);
> +		dev->orig_page =3D conf->disks[i].extra_page;
> +	}
>  }
>=20=20
>  /*
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index dbab8c7..db909b9 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -876,6 +876,8 @@ static void ops_run_io(struct stripe_head *sh, struct=
 stripe_head_state *s)
>=20=20
>  	if (!test_bit(STRIPE_R5C_CACHING, &sh->state)) {
>  		/* writing out phase */
> +		if (s->waiting_extra_page)
> +			return;
>  		if (r5l_write_stripe(conf->log, sh) =3D=3D 0)
>  			return;
>  	} else {  /* caching phase */
> @@ -2007,6 +2009,7 @@ static struct stripe_head *alloc_stripe(struct kmem=
_cache *sc, gfp_t gfp,
>  		INIT_LIST_HEAD(&sh->batch_list);
>  		INIT_LIST_HEAD(&sh->lru);
>  		INIT_LIST_HEAD(&sh->r5c);
> +		INIT_LIST_HEAD(&sh->log_list);
>  		atomic_set(&sh->count, 1);
>  		sh->log_start =3D MaxSector;
>  		for (i =3D 0; i < disks; i++) {
> @@ -2253,10 +2256,24 @@ static int resize_stripes(struct r5conf *conf, in=
t newsize)
>  	 */
>  	ndisks =3D kzalloc(newsize * sizeof(struct disk_info), GFP_NOIO);
>  	if (ndisks) {
> -		for (i=3D0; i<conf->raid_disks; i++)
> +		for (i =3D 0; i < conf->pool_size; i++)
>  			ndisks[i] =3D conf->disks[i];
> -		kfree(conf->disks);
> -		conf->disks =3D ndisks;
> +
> +		for (i =3D conf->pool_size; i < newsize; i++) {
> +			ndisks[i].extra_page =3D alloc_page(GFP_NOIO);
> +			if (!ndisks[i].extra_page)
> +				err =3D -ENOMEM;
> +		}
> +
> +		if (err) {
> +			for (i =3D conf->pool_size; i < newsize; i++)
> +				if (ndisks[i].extra_page)
> +					put_page(ndisks[i].extra_page);
> +			kfree(ndisks);
> +		} else {
> +			kfree(conf->disks);
> +			conf->disks =3D ndisks;
> +		}
>  	} else
>  		err =3D -ENOMEM;
>=20=20
> @@ -3580,10 +3597,10 @@ static void handle_stripe_clean_event(struct r5co=
nf *conf,
>  		break_stripe_batch_list(head_sh, STRIPE_EXPAND_SYNC_FLAGS);
>  }
>=20=20
> -static void handle_stripe_dirtying(struct r5conf *conf,
> -				   struct stripe_head *sh,
> -				   struct stripe_head_state *s,
> -				   int disks)
> +static int handle_stripe_dirtying(struct r5conf *conf,
> +				  struct stripe_head *sh,
> +				  struct stripe_head_state *s,
> +				  int disks)
>  {
>  	int rmw =3D 0, rcw =3D 0, i;
>  	sector_t recovery_cp =3D conf->mddev->recovery_cp;
> @@ -3649,12 +3666,32 @@ static void handle_stripe_dirtying(struct r5conf =
*conf,
>  			    dev->page =3D=3D dev->orig_page &&
>  			    !test_bit(R5_LOCKED, &sh->dev[sh->pd_idx].flags)) {
>  				/* alloc page for prexor */
> -				dev->orig_page =3D alloc_page(GFP_NOIO);
> +				struct page *p =3D alloc_page(GFP_NOIO);
> +
> +				if (p) {
> +					dev->orig_page =3D p;
> +					continue;
> +				}
>=20=20
> -				/* will handle failure in a later patch*/
> -				BUG_ON(!dev->orig_page);
> +				/*
> +				 * alloc_page() failed, try use
> +				 * disk_info->extra_page
> +				 */
> +				if (!test_and_set_bit(R5C_EXTRA_PAGE_IN_USE,
> +						      &conf->cache_state)) {
> +					r5c_use_extra_page(sh);
> +					break;
> +				}
> +
> +				/* extra_page in use, add to delayed_list */
> +				set_bit(STRIPE_DELAYED, &sh->state);
> +				s->waiting_extra_page =3D 1;
> +				return -EAGAIN;
>  			}
> +		}
>=20=20
> +		for (i =3D disks; i--; ) {
> +			struct r5dev *dev =3D &sh->dev[i];
>  			if ((dev->towrite ||
>  			     i =3D=3D sh->pd_idx || i =3D=3D sh->qd_idx ||
>  			     test_bit(R5_InJournal, &dev->flags)) &&
> @@ -3730,6 +3767,7 @@ static void handle_stripe_dirtying(struct r5conf *c=
onf,
>  	    (s->locked =3D=3D 0 && (rcw =3D=3D 0 || rmw =3D=3D 0) &&
>  	     !test_bit(STRIPE_BIT_DELAY, &sh->state)))
>  		schedule_reconstruction(sh, s, rcw =3D=3D 0, 0);
> +	return 0;
>  }
>=20=20
>  static void handle_parity_checks5(struct r5conf *conf, struct stripe_hea=
d *sh,
> @@ -4545,8 +4583,12 @@ static void handle_stripe(struct stripe_head *sh)
>  			if (ret =3D=3D -EAGAIN ||
>  			    /* stripe under reclaim: !caching && injournal */
>  			    (!test_bit(STRIPE_R5C_CACHING, &sh->state) &&
> -			     s.injournal > 0))
> -				handle_stripe_dirtying(conf, sh, &s, disks);
> +			     s.injournal > 0)) {
> +				ret =3D handle_stripe_dirtying(conf, sh, &s,
> +							     disks);
> +				if (ret =3D=3D -EAGAIN)
> +					goto finish;
> +			}
>  		}
>  	}
>=20=20
> @@ -6458,6 +6500,8 @@ static void raid5_free_percpu(struct r5conf *conf)
>=20=20
>  static void free_conf(struct r5conf *conf)
>  {
> +	int i;
> +
>  	if (conf->log)
>  		r5l_exit_log(conf->log);
>  	if (conf->shrinker.nr_deferred)
> @@ -6466,6 +6510,9 @@ static void free_conf(struct r5conf *conf)
>  	free_thread_groups(conf);
>  	shrink_stripes(conf);
>  	raid5_free_percpu(conf);
> +	for (i =3D 0; i < conf->pool_size; i++)
> +		if (conf->disks[i].extra_page)
> +			put_page(conf->disks[i].extra_page);
>  	kfree(conf->disks);
>  	kfree(conf->stripe_hashtbl);
>  	kfree(conf);
> @@ -6612,9 +6659,16 @@ static struct r5conf *setup_conf(struct mddev *mdd=
ev)
>=20=20
>  	conf->disks =3D kzalloc(max_disks * sizeof(struct disk_info),
>  			      GFP_KERNEL);
> +
>  	if (!conf->disks)
>  		goto abort;
>=20=20
> +	for (i =3D 0; i < max_disks; i++) {
> +		conf->disks[i].extra_page =3D alloc_page(GFP_KERNEL);
> +		if (!conf->disks[i].extra_page)
> +			goto abort;
> +	}
> +
>  	conf->mddev =3D mddev;
>=20=20
>  	if ((conf->stripe_hashtbl =3D kzalloc(PAGE_SIZE, GFP_KERNEL)) =3D=3D NU=
LL)
> diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
> index d13fe45..ed8e136 100644
> --- a/drivers/md/raid5.h
> +++ b/drivers/md/raid5.h
> @@ -276,6 +276,7 @@ struct stripe_head_state {
>  	struct md_rdev *blocked_rdev;
>  	int handle_bad_blocks;
>  	int log_failed;
> +	int waiting_extra_page;
>  };
>=20=20
>  /* Flags for struct r5dev.flags */
> @@ -439,6 +440,7 @@ enum {
>=20=20
>  struct disk_info {
>  	struct md_rdev	*rdev, *replacement;
> +	struct page	*extra_page; /* extra page to use in prexor */
>  };
>=20=20
>  /*
> @@ -559,6 +561,9 @@ enum r5_cache_state {
>  				 * only process stripes that are already
>  				 * occupying the log
>  				 */
> +	R5C_EXTRA_PAGE_IN_USE,	/* a stripe is using disk_info.extra_page
> +				 * for prexor
> +				 */
>  };
>=20=20
>  struct r5conf {
> @@ -765,6 +770,7 @@ extern void
>  r5c_finish_stripe_write_out(struct r5conf *conf, struct stripe_head *sh,
>  			    struct stripe_head_state *s);
>  extern void r5c_release_extra_page(struct stripe_head *sh);
> +extern void r5c_use_extra_page(struct stripe_head *sh);
>  extern void r5l_wake_reclaim(struct r5l_log *log, sector_t space);
>  extern void r5c_handle_cached_data_endio(struct r5conf *conf,
>  	struct stripe_head *sh, int disks, struct bio_list *return_bi);
> --=20
> 2.9.3

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlg3sk4ACgkQOeye3VZi
gbkZrhAAnoULxjRr7fmeSLpYA5R6rhqxeIxHs6pV6fyn/jooJEbBvzGiev9h8bno
21Vg4CCkcAh3cTUEHS+z3DtSdW6YZia6pK//hxV5A0wuF5JA7wdSuMx9Uar+wfGG
cRGeD/k+g/y2cCQX42Hb9FRJLH9h7937pYOwQsyVFba/Qu+lo0LgtxKRWwGNPsqa
NoTHWgO759y3LU3/o2A/0t/CkfL3/9q9jMJzVoYW7RN/wHHZkx9/vmrn3i+7GlZE
uhzJ8aTexjtg4Uyl0QGxwIS+f8OkQq9wLRiUnYLKKhXDJOIg+twIZfU4ZychDY8D
Hdgyr9V6aRC+7YwWUh9Ysqlp29gPWR9fia6IfKXT9vz2iaUvLc75SDXBe0bljB8H
NF6DL7cqpQc96gggS3/pEq4Gzh0sd+meOZ6jrpgE0M1Bv5BXkZAqMbS8SaCPW+zi
hIQzZBKNnRssLX80I/HtulTkWmENei7Ov224Q5136+XHYaqEn7Tt1qxbqLl3D4zs
pWIdNxMD1Deoa/VPoWRA3AcPa+jsz06s5xM3AVrktR+UOuh67a4ELszWI951j2RZ
w12/rDpZwlC136ZVpYRDK3yEfWXZ7kx9xocEVdhuirfMwcRqyP1B9IM2510a/LFf
6TZBT3ApOH0NAacWaxJ5oJiLBymL3IdH70thB/ujGlkMSN9/D0U=
=Rx8C
-----END PGP SIGNATURE-----
--=-=-=--
