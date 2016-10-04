From: Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH v2 3/6] r5cache: reclaim support
Date: Tue, 4 Oct 2016 21:59:29 +0000
Message-ID: <A98F6D6D-B853-488B-863F-3DB761520B70@fb.com>
References: <20160926233050.3351081-1-songliubraving@fb.com>
 <20160926233050.3351081-4-songliubraving@fb.com>
 <20160928003438.GC98100@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160928003438.GC98100@kernel.org>
Content-Language: en-US
Content-ID: <19DB117841C19848AC14F6CE0E2BC01F@namprd15.prod.outlook.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "neilb@suse.com" <neilb@suse.com>, Shaohua Li <shli@fb.com>, Kernel Team <Kernel-team@fb.com>, "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "hch@infradead.org" <hch@infradead.org>, "liuzhengyuang521@gmail.com" <liuzhengyuang521@gmail.com>, "liuzhengyuan@kylinos.cn" <liuzhengyuan@kylinos.cn>
List-Id: linux-raid.ids


> On Sep 27, 2016, at 5:34 PM, Shaohua Li <shli@kernel.org> wrote:
>=20
>>=20
>> +	if (!conf->log)
>> +		return;
>> +	spin_lock(&conf->device_lock);
>> +	if (r5c_total_cached_stripes(conf) > conf->max_nr_stripes * 3 / 4 ||
>> +	    atomic_read(&conf->empty_inactive_list_nr) > 0)
>> +		r5c_flush_cache(conf, R5C_RECLAIM_STRIPE_GROUP);
>=20
> I still worry about the max_nr_stripes usage. It can be changed at runtim=
e. If
> there are no enough stripes, should we just allocate more stripes or recl=
aim
> stripe cache? If memory system tries to shrink stripes (eg, decrease
> max_nr_stripes), will it cause deadlock for r5cache?
>=20

Write cache will not have dead lock due to stripe cache usage, because cach=
ed
stripe will hold a stripe until it is flushed to the raid disks.=20


>> +	else if (r5c_total_cached_stripes(conf) >
>> +		 conf->max_nr_stripes * 1 / 2)
>> +		r5c_flush_cache(conf, 1);
>=20
> This one is a defensive reclaim. It should always reclaim stripes with fu=
ll
> data. If there are no enough such stripes, do nothing. Flushing 1 stripe =
would
> always be wrong unless we are in critical stripe space shortage, as recla=
im
> involves disk cache flush and is slow, we should do aggretation as much a=
s
> possible.

I will remove the defensive reclaim.=20

>=20
>>  *
>> @@ -198,10 +260,9 @@ void r5c_freeze_stripe_for_reclaim(struct stripe_he=
ad *sh)
>> {
>> 	struct r5conf *conf =3D sh->raid_conf;
>>=20
>> -	if (!conf->log)
>> +	if (!conf->log || test_bit(STRIPE_R5C_FROZEN, &sh->state))
>> 		return;
>>=20
>> -	WARN_ON(test_bit(STRIPE_R5C_FROZEN, &sh->state));
>> 	set_bit(STRIPE_R5C_FROZEN, &sh->state);
>=20
> This is confusing. The WARN_ON suggests the STRIPE_R5C_FROZEN isn't set f=
or sh,
> but the change suggests it's possible the bit is set. Which one is correc=
t?
>=20

Will fix this.=20

>>=20
>> @@ -518,6 +583,14 @@ static int r5l_log_stripe(struct r5l_log *log, stru=
ct stripe_head *sh,
>> 	atomic_inc(&io->pending_stripe);
>> 	sh->log_io =3D io;
>>=20
>> +	if (sh->log_start =3D=3D MaxSector) {
>> +		BUG_ON(!list_empty(&sh->r5c));
>> +		sh->log_start =3D io->log_start;
>> +		spin_lock_irqsave(&log->stripe_in_cache_lock, flags);
>> +		list_add_tail(&sh->r5c,
>> +			      &log->stripe_in_cache);
>> +		spin_unlock_irqrestore(&log->stripe_in_cache_lock, flags);
>> +	}
> what if it's in writethrogh mode?

This does not impact write through mode. But let me add clear check just in=
 case.=20
>=20
>> +		last_checkpoint =3D (list_first_entry(&log->stripe_in_cache,
>> +						    struct stripe_head, r5c))->log_start;
>> +		spin_unlock(&log->stripe_in_cache_lock);
>> +		if (sh->log_start !=3D last_checkpoint) {
>> +			spin_lock(&log->no_space_stripes_lock);
>> +			list_add_tail(&sh->log_list, &log->no_space_stripes);
>> +			spin_unlock(&log->no_space_stripes_lock);
>> +			mutex_unlock(&log->io_mutex);
>> +			return -ENOSPC;
>=20
> So if a stripe is in cache, we try to reclaim it. We should have some mec=
hanism
> to guarantee there are enough space for reclaim (eg for parity). Otherwis=
e
> there could be a deadlock because the space allocation in reclaim path is=
 to
> free space. Could you please explain how this is done?
>=20

I redefined this part in newer version, which should be clear.=20

>> +		} else 	if (!r5l_has_free_space(log, reserve)) {
>> +			WARN(1, "%s: run out of journal space\n", __func__);
>> +			BUG();
> that's scaring, why it happens?
>=20

I rewrite some of the code in newer version. But in case something similar =
happens, it
is a bug with reclaim.=20

>>=20
>> +		if (test_bit(R5C_LOG_CRITICAL, &conf->cache_state) &&
>> +		    sh->log_start !=3D last_checkpoint)
>> +			continue;
> what's this check for?

With this check, the code only flushes stripes at last_checkpoint on journa=
l. This is no=20
longer needed in newer version. I will remove it.=20

>=20
>> 		list_del_init(&sh->log_list);
>> +
>> static sector_t r5l_reclaimable_space(struct r5l_log *log)
>> {
>> +	struct r5conf *conf =3D log->rdev->mddev->private;
>> +
>> 	return r5l_ring_distance(log, log->last_checkpoint,
>> -				 log->next_checkpoint);
>> +				 r5c_calculate_last_cp(conf));
> will this work for writethrouth?

r5c_calculate_last_cp() returns next_checkpoint for write through mode.=20
>=20
>> }
>>=20
>>=20
>> 	if (reclaimable =3D=3D 0)
>> 		return;
>> -
>> 	/*
>> 	 * write_super will flush cache of each raid disk. We must write super
>> 	 * here, because the log area might be reused soon and we don't want to
>> @@ -877,10 +995,7 @@ static void r5l_do_reclaim(struct r5l_log *log)
>>=20
>> 	mutex_lock(&log->io_mutex);
>> 	log->last_checkpoint =3D next_checkpoint;
>> -	log->last_cp_seq =3D next_cp_seq;
> why not update last_cp_seq?

=10Currently, we don't need last_cp_seq anywhere in the code. To keep track=
 of=20
last_cp_seq, we need add this field to stripe_head. From what I can this, t=
his=20
seems not necessary.=20

>> 	mutex_unlock(&log->io_mutex);
>> -
>> -	r5l_run_no_space_stripes(log);
>=20
> I don't understand why move r5l_run_no_space_stripes to r5c_flush_cache. =
It's
> natural we run this after some spaces are reclaimed.

I will move it back.=20

>> }
>>=20
>> static void r5l_reclaim_thread(struct md_thread *thread)
>> @@ -891,7 +1006,9 @@ static void r5l_reclaim_thread(struct md_thread *th=
read)
>>=20
>> 	if (!log)
>> 		return;
>> +	r5c_do_reclaim(conf);
>> 	r5l_do_reclaim(log);
>> +	md_wakeup_thread(mddev->thread);
>=20
> this wakeup is a bit strange. After we reclaim some spaces, we will rerun
> pending stripes, which will wakeup mddev->thread. Do miss some wakeup in =
other
> reclaim places?

This one is not really necessary. I will remove it.=20


>> }
>>=20
>> void r5l_wake_reclaim(struct r5l_log *log, sector_t space)
>>=20
>> }
>>=20
>> -static void r5c_flush_stripe(struct r5conf *conf, struct stripe_head *s=
h)
>> +/*
>> + * r5c_flush_cache will move stripe from cached list to handle_list or
>> + * r5c_priority_list
>=20
> What's the r5c_priority_list for? If you want to make sure reclaim makes
> progress, I think it's the wrong way. If there are no spaces, handling ot=
her
> normal stripes will mean moving them to no_space list and do nothing else=
. Then
> the reclaim stripes will get the turn to run. There is no extra list requ=
ired.

I will try to remove it.=20

>=20
>>=20
>> +	BUG_ON(test_bit(STRIPE_R5C_PRIORITY, &sh->state) &&
>> +	       !test_bit(STRIPE_HANDLE, &sh->state));
>> +
>> +	if (test_bit(STRIPE_R5C_PRIORITY, &sh->state))
>> +		return 0;
>> +	if (test_bit(STRIPE_HANDLE, &sh->state) && !priority)
>> +		return 0;
>> +
>> 	r5c_freeze_stripe_for_reclaim(sh);
>> -	atomic_inc(&conf->active_stripes);
>> +	if (!test_and_set_bit(STRIPE_HANDLE, &sh->state)) {
>> +		atomic_inc(&conf->active_stripes);
>> +	}
>=20
> shouldn't the stripe is always accounted to active before it's reclaimed?=
 Do we
> decrease the count before the stripe is reclaimed? sounds like a bug.
>=20

We decrease active count when the stripe is on r5c_cached_full_stripe or=20
r5c_cached_partial stripe. These two lists are variation of inactive_list.=
=20

>>=20
>> +
>> +			mutex_unlock(&log->io_mutex);
>> +			return -ENOSPC;
>> 		}
>> +		pr_debug("%s: write sh %lu to free log space\n", __func__, sh->sector=
);
>> +	}
>> +	if (!r5l_has_free_space(log, reserve)) {
>> +		pr_err("%s: cannot reserve space %d\n", __func__, reserve);
>> +		BUG();
>=20
> same here. we should put the stripe into no_space list. If we can't alloc=
ate
> space eventually, it indicates reclaim has bug.

BUG() here already indicates bug in reclaim. I will test this thoroughly wi=
th new version.=20

>>=20
>> +				if (before_jiffies > 20)
>> +					pr_debug("%s: wait for sh takes %lu jiffies\n", __func__, before_j=
iffies);
> please remove the debug code.
>=20
> Thanks,
> Shaohua

