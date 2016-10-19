From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH v5 5/8] md/r5cache: reclaim support
Date: Wed, 19 Oct 2016 13:03:53 +1100
Message-ID: <87oa2hxfg6.fsf@notabene.neil.brown.name>
References: <20161013054944.1038806-1-songliubraving@fb.com> <20161013054944.1038806-6-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161013054944.1038806-6-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@fb.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, liuzhengyuang521@gmail.com, liuzhengyuan@kylinos.cn, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 13 2016, Song Liu wrote:

> There are two limited resources, stripe cache and journal disk space.
> For better performance, we priotize reclaim of full stripe writes.
> To free up more journal space, we free earliest data on the journal.
>
> In current implementation, reclaim happens when:
> 1. Periodically (every R5C_RECLAIM_WAKEUP_INTERVAL, 5 seconds) reclaim
>    if there is no reclaim in the past 5 seconds.

5 seconds is an arbitrary number.  I don't think it needs to be made
configurable, but it might help to justify it.
I would probably make it closer to 30 seconds.  There really isn't any
rush.  If there is much load, it will never wait this long.  If there is
not much load ... then it probably doesn't matter.


> 2. when there are R5C_FULL_STRIPE_FLUSH_BATCH (32) cached full stripes
>    (r5c_check_cached_full_stripe)

This is another arbitrary number, but I think it needs more
justification.  Why 32?  That's 128K per device, which isn't very much.
It might make sense to set the batch size based on the stripe size
(e.g. at least on stripe?) or on the cache size.

> 3. when there is pressure on stripe cache (r5c_check_stripe_cache_usage)
> 4. when there is pressure on journal space (r5l_write_stripe, r5c_cache_d=
ata)
>
> r5c_do_reclaim() contains new logic of reclaim.
>
> For stripe cache:
>
> When stripe cache pressure is high (more than 3/4 stripes are cached,

You say "3/4" here bit I think the code says "1/2"
> +	if (total_cached > conf->min_nr_stripes * 1 / 2 ||
But there is also
> +	if (total_cached > conf->min_nr_stripes * 3 / 4 ||
> +	    atomic_read(&conf->empty_inactive_list_nr) > 0)

so maybe you do mean 3/4..  Maybe some comments closer to the different
fractions would help.

> @@ -141,6 +150,12 @@ struct r5l_log {
>=20=20
>  	/* for r5c_cache */
>  	enum r5c_state r5c_state;
> +
> +	/* all stripes in r5cache, in the order of seq at sh->log_start */
> +	struct list_head stripe_in_cache_list;
> +
> +	spinlock_t stripe_in_cache_lock;

You use the _irqsave / _irqrestore versions of spinlock for this lock,
but I cannot see where it is takes from interrupt-context.
What did I miss?

> +/* evaluate log space usage and update R5C_LOG_TIGHT and R5C_LOG_CRITICA=
L */
> +static inline void r5c_update_log_state(struct r5l_log *log)
> +{
> +	struct r5conf *conf =3D log->rdev->mddev->private;
> +	sector_t free_space =3D r5l_ring_distance(log, log->log_start,
> +						log->last_checkpoint);
> +	sector_t reclaim_space =3D r5c_log_required_to_flush_cache(conf);
> +
> +	if (!r5c_is_writeback(log))
> +		return;
> +	else if (free_space < 2 * reclaim_space) {
> +		set_bit(R5C_LOG_CRITICAL, &conf->cache_state);
> +		set_bit(R5C_LOG_TIGHT, &conf->cache_state);
> +	} else if (free_space < 3 * reclaim_space) {
> +		clear_bit(R5C_LOG_CRITICAL, &conf->cache_state);
> +		set_bit(R5C_LOG_TIGHT, &conf->cache_state);
> +	} else if (free_space > 4 * reclaim_space) {
> +		clear_bit(R5C_LOG_TIGHT, &conf->cache_state);
> +		clear_bit(R5C_LOG_CRITICAL, &conf->cache_state);
> +	} else
> +		clear_bit(R5C_LOG_CRITICAL, &conf->cache_state);

Hmmm...
We set LOG_CRITICAL if free_space < 2*reclaim_space, else we clear it.
We set LOG_TIGHT if free_space < 3*reclaim_space and clear it if > 4*reclai=
m_space

Would the code be clearer if you just made that explicit.

At the very least, change
> +	} else if (free_space > 4 * reclaim_space) {
> +		clear_bit(R5C_LOG_TIGHT, &conf->cache_state);
> +		clear_bit(R5C_LOG_CRITICAL, &conf->cache_state);
> +	} else
> +		clear_bit(R5C_LOG_CRITICAL, &conf->cache_state);

to

> +	} else if (free_space < 4 * reclaim_space) {
> +		clear_bit(R5C_LOG_CRITICAL, &conf->cache_state);
> +	} else {
> +		clear_bit(R5C_LOG_TIGHT, &conf->cache_state);
> +		clear_bit(R5C_LOG_CRITICAL, &conf->cache_state);
> +     }

so the order of the branches is consistent and all the tests a '<'.

>=20=20
> +/*
> + * do not release a stripe to cached lists in quiesce
> + */

You tell me what this function doesn't do, but not what it does.

This function is only called once, and I think that could would be
clearer if this was just included in-line in that one place.

> +void r5c_prepare_stripe_for_release_in_quiesce(struct stripe_head *sh)
> +{
> +	if (!test_bit(STRIPE_HANDLE, &sh->state) &&
> +	    atomic_read(&sh->dev_in_cache) !=3D 0) {
> +		if (!test_bit(STRIPE_R5C_FROZEN, &sh->state))
> +			r5c_freeze_stripe_for_reclaim(sh);
> +		set_bit(STRIPE_HANDLE, &sh->state);
> +	}
> +}
> +
>=20=20
> @@ -709,6 +867,7 @@ static void r5l_run_no_space_stripes(struct r5l_log *=
log)
>  	while (!list_empty(&log->no_space_stripes)) {
>  		sh =3D list_first_entry(&log->no_space_stripes,
>  				      struct stripe_head, log_list);
> +		set_bit(STRIPE_PREREAD_ACTIVE, &sh->state);
>  		list_del_init(&sh->log_list);
>  		set_bit(STRIPE_HANDLE, &sh->state);
>  		raid5_release_stripe(sh);

This chunk doesn't seem to belong here.  It looks like it might be a
bugfix that is quite independent of the rest of the code.  Is it?
If is, it probably belongs in a separate patch.


>  static void r5l_do_reclaim(struct r5l_log *log)
>  {
> +	struct r5conf *conf =3D log->rdev->mddev->private;
>  	sector_t reclaim_target =3D xchg(&log->reclaim_target, 0);
>  	sector_t reclaimable;
>  	sector_t next_checkpoint;
> -	u64 next_cp_seq;
>=20=20
>  	spin_lock_irq(&log->io_list_lock);
>  	/*
> @@ -924,8 +1115,7 @@ static void r5l_do_reclaim(struct r5l_log *log)
>  				    log->io_list_lock);
>  	}
>=20=20
> -	next_checkpoint =3D log->next_checkpoint;
> -	next_cp_seq =3D log->next_cp_seq;
> +	next_checkpoint =3D r5c_calculate_new_cp(conf);
>  	spin_unlock_irq(&log->io_list_lock);
>=20=20
>  	BUG_ON(reclaimable < 0);
> @@ -941,7 +1131,7 @@ static void r5l_do_reclaim(struct r5l_log *log)
>=20=20
>  	mutex_lock(&log->io_mutex);
>  	log->last_checkpoint =3D next_checkpoint;
> -	log->last_cp_seq =3D next_cp_seq;

Why don't we update last_cp_seq here any more?


> +
> +/*
> + * if num < 0, flush all stripes
> + * if num =3D=3D 0, flush all full stripes
> + * if num > 0, flush all full stripes. If less than num full stripes are
> + *             flushed, flush some partial stripes until totally num str=
ipes are
> + *             flushed or there is no more cached stripes.
> + */

I'm not very keen on the idea of having "num < 0".

I'd rather the meaning was:
  flush all full stripes, and a total of at least num stripes.

To flush all stripes, pass MAX_INT for num (or similar).

> +void r5c_flush_cache(struct r5conf *conf, int num)
> +{
> +	int count;
> +	struct stripe_head *sh, *next;
> +
> +	assert_spin_locked(&conf->device_lock);
> +	if (!conf->log)
> +		return;
> +
> +	count =3D 0;
> +	list_for_each_entry_safe(sh, next, &conf->r5c_full_stripe_list, lru) {
> +		r5c_flush_stripe(conf, sh);
> +		count++;
> +	}
> +
> +	if (num =3D=3D 0 || (num > 0 && count >=3D num))
> +		return;
> +	list_for_each_entry_safe(sh, next,
> +				 &conf->r5c_partial_stripe_list, lru) {
> +		r5c_flush_stripe(conf, sh);
> +		if (num > 0 && count++ >=3D num)
> +			break;
> +	}
> +}
> +


Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJYBtSJAAoJEDnsnt1WYoG5v7cP/iixbvHg2wNapuB2NLm+ZRn3
HMKaFz5zaaAbMdoucc2CbEj5nwI8+3u8ZXdiCkZYe0QYftXQsGpYYLZxHDhi1ktY
bjOyjx57m6t3/0w4YDxOba95+fnJ7kRaikjC8N9UCRG/sxPfBw40Hi7CK4IkX/4q
6lFJtIpLf8AEKbUWZgksgn8/W2o5cJF6GywGi6EBAk9vaR4uqm2DaCcvWYnud++T
oBHOzNL75ncON8jAtksND3w5bcBPyl5a0yQBlJb2IKo9NJrhjtO/O1KZLaCT5sFF
JsSuQOigybtX6C5Tn/9W1SGJyAyd0naBrSqGRRFBY/EthBOTJg5HtX9NjtCGtSoB
BkiWFbJOuPmdeORpvobVicHHTEA7Gvm4eFy2w96kzgpyniNpyfTPAT5oCQgF9ElJ
xgByEUt4oDO+T0tv4RS0TSoqUqgYZ0PwEOu/j9sryRRGpmBKkATyJ6jaQ1JJGJyw
+ILEDUdHJlDVnfoTybkq0Z4k1ZYXz7wTG1clKLSmIk7I5vyiEVQFUjkhJ93Wl6ap
TwJvYYveEvvfps9EUVg3T/E8ghIrqwQ8LEMqNh+Oi6OsH6t1zSEojhUuxQ623ypv
91FI5hXXjZMd24R387tj6BLO1qncBAEd9WbgfOqtJNcTfZFRSc5wptoTIi0+1Sfe
0Vm4bv5Lh6KhHOUQZq6Y
=1ZzL
-----END PGP SIGNATURE-----
--=-=-=--
