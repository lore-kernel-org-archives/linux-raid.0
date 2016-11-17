From: Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH v6 05/11] md/r5cache: write-out mode and reclaim support
Date: Thu, 17 Nov 2016 00:57:09 +0000
Message-ID: <DC5363D5-FBA6-4957-BDCA-F58F9CA7FE09@fb.com>
References: <20161110204623.3484694-1-songliubraving@fb.com>
 <20161110204623.3484694-6-songliubraving@fb.com>
 <87zikz7xva.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87zikz7xva.fsf@notabene.neil.brown.name>
Content-Language: en-US
Content-ID: <DE3310820891CA469C72F842CFFC4116@namprd15.prod.outlook.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, Shaohua Li <shli@fb.com>, Kernel Team <Kernel-team@fb.com>, "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "hch@infradead.org" <hch@infradead.org>, "liuzhengyuang521@gmail.com" <liuzhengyuang521@gmail.com>, "liuzhengyuan@kylinos.cn" <liuzhengyuan@kylinos.cn>
List-Id: linux-raid.ids


> On Nov 16, 2016, at 4:28 PM, NeilBrown <neilb@suse.com> wrote:
>=20
> On Fri, Nov 11 2016, Song Liu wrote:
>>=20
>> +
>> +	free_space =3D r5l_ring_distance(log, log->log_start,
>> +				       log->last_checkpoint);
>> +	reclaim_space =3D r5c_log_required_to_flush_cache(conf);
>> +	if (free_space < 2 * reclaim_space)
>> +		set_bit(R5C_LOG_CRITICAL, &conf->cache_state);
>> +	else
>> +		clear_bit(R5C_LOG_CRITICAL, &conf->cache_state);
>> +	if (free_space < 3 * reclaim_space)
>> +		set_bit(R5C_LOG_TIGHT, &conf->cache_state);
>> +	else
>> +		clear_bit(R5C_LOG_TIGHT, &conf->cache_state);
>> +}
>=20
> This code, that you rewrote as I requested (Thanks) behaves slightly
> differently to the previous version.
> Maybe that is intentional, but I thought I would mention it anyway.
> The previous would set TIGHT when free_space dropped below
> 3*reclaim_space, and would only clear it when free_space when above
> 4*reclaim_space.  This provided some hysteresis.
> Now it is cleared as soon as free_space reaches 3*reclaim_space.
>=20
> Maybe this is what you want, but as the hysteresis seemed like it might
> be sensible, it is worth asking.

Thanks for pointing this out. This part will need a little more fine-tuning=
.=20

>>=20
>> +	if (log->r5c_journal_mode =3D=3D R5C_JOURNAL_MODE_WRITE_THROUGH)
>> +		return log->next_checkpoint;
>> +
>> +	spin_lock(&log->stripe_in_cache_lock);
>> +	if (list_empty(&conf->log->stripe_in_cache_list)) {
>> +		/* all stripes flushed */
>> +		spin_unlock(&log->stripe_in_cache_lock);
>> +		return log->next_checkpoint;
>> +	}
>> +	sh =3D list_first_entry(&conf->log->stripe_in_cache_list,
>> +			      struct stripe_head, r5c);
>> +	end =3D sh->log_start;
>> +	spin_unlock(&log->stripe_in_cache_lock);
>> +	return end;
>=20
> Given that we only assign "log_start" to the variable "end", it is
> strange that it is called "end".
> "new_cp" would make sense, or "log_start", but why "end" ??

It is somehow like "end of what we can reclaim". I will rename it.=20

>=20
>>=20
>> +/*
>> + * r5c_flush_stripe moves stripe from cached list to handle_list. When =
called,
>> + * the stripe must be on r5c_cached_full_stripes or r5c_cached_partial_=
stripes.
>> + *
>> + * must hold conf->device_lock
>> + */
>> +static void r5c_flush_stripe(struct r5conf *conf, struct stripe_head *s=
h)
>> +{
>> +	BUG_ON(list_empty(&sh->lru));
>> +	BUG_ON(test_bit(STRIPE_R5C_WRITE_OUT, &sh->state));
>> +	BUG_ON(test_bit(STRIPE_HANDLE, &sh->state));
>> +	assert_spin_locked(&conf->device_lock);
>> +
>> +	list_del_init(&sh->lru);
>> +	atomic_inc(&sh->count);
>> +
>> +	set_bit(STRIPE_HANDLE, &sh->state);
>> +	atomic_inc(&conf->active_stripes);
>> +	r5c_make_stripe_write_out(sh);
>> +
>> +	if (!test_and_set_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
>> +		atomic_inc(&conf->preread_active_stripes);
>> +	raid5_release_stripe(sh);
>=20
> This looks wrong.  raid5_release_stripe() can try to take
> conf->device_lock but this function is called with ->device_lock
> held. This would cause a deadlock.
>=20
> It presumably doesn't deadlock because you just incremented sh->count,
> so raid5_release_stripe() will probably just decrement sh->count and
> that count will remain > 0.
> So why are you incrementing ->count for a few instructions and then
> releasing the stripe?  Either that isn't necessary, or it could
> deadlock.
r5c_flush_stripe() will only work on stripes in r5c_cached_full_stripes or
r5c_cached_partial_stripes. So these stripes would always have count=3D0
(before atomic_inc).=20

> I guess that if we are certain that STRIPE_ON_RELEASE_LIST is clear,
> then it won't deadlock as it will do a lock-less add to
> conf->release_stripes.
> But if that is the case, it needs to be documented, and probaby there
> needs to be a WARN_ON(test_bit(STRIPE_ON_RELEASE_LIST.....));

Since the stripe is on r5c_cached_full_stripes or r5c_cached_partial_stripe=
s,=20
it should not have STRIPE_ON_RELEASE_LIST. Let me add documents=20
and check.=20

Thanks,
Song

