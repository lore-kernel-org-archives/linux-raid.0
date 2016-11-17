From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH v6 05/11] md/r5cache: write-out mode and reclaim support
Date: Thu, 17 Nov 2016 11:28:57 +1100
Message-ID: <87zikz7xva.fsf@notabene.neil.brown.name>
References: <20161110204623.3484694-1-songliubraving@fb.com> <20161110204623.3484694-6-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161110204623.3484694-6-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@fb.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, liuzhengyuang521@gmail.com, liuzhengyuan@kylinos.cn, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 11 2016, Song Liu wrote:

> +/*
> + * evaluate log space usage and update R5C_LOG_TIGHT and R5C_LOG_CRITICAL
> + *
> + * R5C_LOG_TIGHT is set when free space on the log device is less than 3=
x of
> + * reclaim_required_space. R5C_LOG_CRITICAL is set when free space on th=
e log
> + * device is less than 2x of reclaim_required_space.
> + */
> +static inline void r5c_update_log_state(struct r5l_log *log)
> +{
> +	struct r5conf *conf =3D log->rdev->mddev->private;
> +	sector_t free_space;
> +	sector_t reclaim_space;
> +
> +	if (!r5c_is_writeback(log))
> +		return;
> +
> +	free_space =3D r5l_ring_distance(log, log->log_start,
> +				       log->last_checkpoint);
> +	reclaim_space =3D r5c_log_required_to_flush_cache(conf);
> +	if (free_space < 2 * reclaim_space)
> +		set_bit(R5C_LOG_CRITICAL, &conf->cache_state);
> +	else
> +		clear_bit(R5C_LOG_CRITICAL, &conf->cache_state);
> +	if (free_space < 3 * reclaim_space)
> +		set_bit(R5C_LOG_TIGHT, &conf->cache_state);
> +	else
> +		clear_bit(R5C_LOG_TIGHT, &conf->cache_state);
> +}

This code, that you rewrote as I requested (Thanks) behaves slightly
differently to the previous version.
Maybe that is intentional, but I thought I would mention it anyway.
The previous would set TIGHT when free_space dropped below
3*reclaim_space, and would only clear it when free_space when above
4*reclaim_space.  This provided some hysteresis.
Now it is cleared as soon as free_space reaches 3*reclaim_space.

Maybe this is what you want, but as the hysteresis seemed like it might
be sensible, it is worth asking.

>=20=20
> +/*
> + * calculate new last_checkpoint
> + * for write through mode, returns log->next_checkpoint
> + * for write back, returns log_start of first sh in stripe_in_cache_list
> + */
> +static sector_t r5c_calculate_new_cp(struct r5conf *conf)
> +{
> +	struct stripe_head *sh;
> +	struct r5l_log *log =3D conf->log;
> +	sector_t end =3D MaxSector;

The value assigned here is never used.

> +
> +	if (log->r5c_journal_mode =3D=3D R5C_JOURNAL_MODE_WRITE_THROUGH)
> +		return log->next_checkpoint;
> +
> +	spin_lock(&log->stripe_in_cache_lock);
> +	if (list_empty(&conf->log->stripe_in_cache_list)) {
> +		/* all stripes flushed */
> +		spin_unlock(&log->stripe_in_cache_lock);
> +		return log->next_checkpoint;
> +	}
> +	sh =3D list_first_entry(&conf->log->stripe_in_cache_list,
> +			      struct stripe_head, r5c);
> +	end =3D sh->log_start;
> +	spin_unlock(&log->stripe_in_cache_lock);
> +	return end;

Given that we only assign "log_start" to the variable "end", it is
strange that it is called "end".
"new_cp" would make sense, or "log_start", but why "end" ??


> +}
> +
>  static sector_t r5l_reclaimable_space(struct r5l_log *log)
>  {
> +	struct r5conf *conf =3D log->rdev->mddev->private;
> +
>  	return r5l_ring_distance(log, log->last_checkpoint,
> -				 log->next_checkpoint);
> +				 r5c_calculate_new_cp(conf));
>  }
>=20=20
>  static void r5l_run_no_mem_stripe(struct r5l_log *log)
> @@ -776,6 +966,7 @@ static bool r5l_complete_finished_ios(struct r5l_log =
*log)
>  static void __r5l_stripe_write_finished(struct r5l_io_unit *io)
>  {
>  	struct r5l_log *log =3D io->log;
> +	struct r5conf *conf =3D log->rdev->mddev->private;
>  	unsigned long flags;
>=20=20
>  	spin_lock_irqsave(&log->io_list_lock, flags);
> @@ -786,7 +977,8 @@ static void __r5l_stripe_write_finished(struct r5l_io=
_unit *io)
>  		return;
>  	}
>=20=20
> -	if (r5l_reclaimable_space(log) > log->max_free_space)
> +	if (r5l_reclaimable_space(log) > log->max_free_space ||
> +	    test_bit(R5C_LOG_TIGHT, &conf->cache_state))
>  		r5l_wake_reclaim(log, 0);
>=20=20
>  	spin_unlock_irqrestore(&log->io_list_lock, flags);
> @@ -907,14 +1099,140 @@ static void r5l_write_super_and_discard_space(str=
uct r5l_log *log,
>  	}
>  }
>=20=20
> +/*
> + * r5c_flush_stripe moves stripe from cached list to handle_list. When c=
alled,
> + * the stripe must be on r5c_cached_full_stripes or r5c_cached_partial_s=
tripes.
> + *
> + * must hold conf->device_lock
> + */
> +static void r5c_flush_stripe(struct r5conf *conf, struct stripe_head *sh)
> +{
> +	BUG_ON(list_empty(&sh->lru));
> +	BUG_ON(test_bit(STRIPE_R5C_WRITE_OUT, &sh->state));
> +	BUG_ON(test_bit(STRIPE_HANDLE, &sh->state));
> +	assert_spin_locked(&conf->device_lock);
> +
> +	list_del_init(&sh->lru);
> +	atomic_inc(&sh->count);
> +
> +	set_bit(STRIPE_HANDLE, &sh->state);
> +	atomic_inc(&conf->active_stripes);
> +	r5c_make_stripe_write_out(sh);
> +
> +	if (!test_and_set_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
> +		atomic_inc(&conf->preread_active_stripes);
> +	raid5_release_stripe(sh);

This looks wrong.  raid5_release_stripe() can try to take
conf->device_lock but this function is called with ->device_lock
held. This would cause a deadlock.

It presumably doesn't deadlock because you just incremented sh->count,
so raid5_release_stripe() will probably just decrement sh->count and
that count will remain > 0.
So why are you incrementing ->count for a few instructions and then
releasing the stripe?  Either that isn't necessary, or it could
deadlock.

I guess that if we are certain that STRIPE_ON_RELEASE_LIST is clear,
then it won't deadlock as it will do a lock-less add to
conf->release_stripes.
But if that is the case, it needs to be documented, and probaby there
needs to be a WARN_ON(test_bit(STRIPE_ON_RELEASE_LIST.....));


Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJYLPnJAAoJEDnsnt1WYoG5yi0QAJR6S0+xO59eOVA65l79hb/4
j6noJUaA6aFkfg9IckcUte0i8IYh468Nc9rppAP4c06umHtuilRfde3N6JR3IRZP
vR9O99LmMr9pHuyBN1kegvux9aBGj/gHJovvfbDCnF7BaXqgg9g3Z/MXMd11XTbl
mbM28+BI6zhUynsrC9HfK/koH/MnYlfWurl+n4MmN2d3L2QWmrHzufIVuRR6DiT7
bxCtMjwk2guKTWnKI5/yaNUxDdhTg7oL8+PgjnOTPElPPCNCny442Cpj8bjnNFoL
4HF0BUXcSgP7wQibpNvbAOZpfCtUU1JKC6/bgqo/L/kkBkPmA2N0PyKHno612FqM
UuGzP3jdV112a6nr3bI7wcCDt86tL775UahcmvCxD02EHx61n93htzT6yQbBpK8t
fGTy7RJrFECgG5Ilw3isy/Ll7oiU05GGOHvazQCvwosOtOFEmISXbMEGL4BNmQSt
WzRry+7/QvTxd+LPfpt/26CXLgLT8GP0NnS4wYHDUPXDp8grE0RNsZy85YHemg/r
VQi3PSwVG5F6oDVj3hy6DANJe5NYeV0U+pCWZ61v8fbhPHBz2Ccl5gsd53PIL0nv
+XGTJnAsmk6b8z/FAsxX1Hf57aCdmA10zZAitNA1ZSpaB9zrZ/QnWal0S/iQfmXb
DKbH1OfZrX1rDaix5Hcn
=R0Gp
-----END PGP SIGNATURE-----
--=-=-=--
