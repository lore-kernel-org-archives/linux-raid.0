From: Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH v5 5/8] md/r5cache: reclaim support
Date: Fri, 21 Oct 2016 21:04:21 +0000
Message-ID: <8B0D1660-3389-4A62-8616-D9F7604684FB@fb.com>
References: <20161013054944.1038806-1-songliubraving@fb.com>
 <20161013054944.1038806-6-songliubraving@fb.com>
 <87oa2hxfg6.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87oa2hxfg6.fsf@notabene.neil.brown.name>
Content-Language: en-US
Content-ID: <56EF69486624F348897543BE9206B717@namprd15.prod.outlook.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, Shaohua Li <shli@fb.com>, Kernel Team <Kernel-team@fb.com>, "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "hch@infradead.org" <hch@infradead.org>, "liuzhengyuang521@gmail.com" <liuzhengyuang521@gmail.com>, "liuzhengyuan@kylinos.cn" <liuzhengyuan@kylinos.cn>
List-Id: linux-raid.ids


> On Oct 18, 2016, at 7:03 PM, NeilBrown <neilb@suse.com> wrote:
>=20
>> AL, 5 seconds) reclaim
>>   if there is no reclaim in the past 5 seconds.
>=20
> 5 seconds is an arbitrary number.  I don't think it needs to be made
> configurable, but it might help to justify it.
> I would probably make it closer to 30 seconds.  There really isn't any
> rush.  If there is much load, it will never wait this long.  If there is
> not much load ... then it probably doesn't matter.

Yeah, 30 second should work here.=20
>=20
>=20
>> 2. when there are R5C_FULL_STRIPE_FLUSH_BATCH (32) cached full stripes
>>   (r5c_check_cached_full_stripe)
>=20
> This is another arbitrary number, but I think it needs more
> justification.  Why 32?  That's 128K per device, which isn't very much.
> It might make sense to set the batch size based on the stripe size
> (e.g. at least on stripe?) or on the cache size.

How about we use something like min(stripe_cache_size / 8, 256)? Journal sp=
ace
will trigger reclaim in other conditions (#4 below).=20

>=20
>> 3. when there is pressure on stripe cache (r5c_check_stripe_cache_usage)
>> 4. when there is pressure on journal space (r5l_write_stripe, r5c_cache_=
data)
>>=20
>> r5c_do_reclaim() contains new logic of reclaim.
>>=20
>> For stripe cache:
>>=20
>> When stripe cache pressure is high (more than 3/4 stripes are cached,
>=20
> You say "3/4" here bit I think the code says "1/2"
>> +	if (total_cached > conf->min_nr_stripes * 1 / 2 ||
> But there is also
>> +	if (total_cached > conf->min_nr_stripes * 3 / 4 ||
>> +	    atomic_read(&conf->empty_inactive_list_nr) > 0)
>=20
> so maybe you do mean 3/4..  Maybe some comments closer to the different
> fractions would help.

There are level of cache pressure:
high pressure: total_cached > 3/4 || empty_inactivelist_nr > 0
moderate pressure: total_cached > 1/2.=20

The condition:
+	if (total_cached > conf->min_nr_stripes * 1 / 2 ||
+	    atomic_read(&conf->empty_inactive_list_nr) > 0)

covers "either high or moderate pressure".=20


>> @@ -141,6 +150,12 @@ struct r5l_log {
>>=20
>> 	/* for r5c_cache */
>> 	enum r5c_state r5c_state;
>> +
>> +	/* all stripes in r5cache, in the order of seq at sh->log_start */
>> +	struct list_head stripe_in_cache_list;
>> +
>> +	spinlock_t stripe_in_cache_lock;
>=20
> You use the _irqsave / _irqrestore versions of spinlock for this lock,
> but I cannot see where it is takes from interrupt-context.
> What did I miss?

Let me fix them.=20

>=20
>> +/* evaluate log space usage and update R5C_LOG_TIGHT and R5C_LOG_CRITIC=
AL */
>> +static inline void r5c_update_log_state(struct r5l_log *log)
>> +{
>> +	struct r5conf *conf =3D log->rdev->mddev->private;
>> +	sector_t free_space =3D r5l_ring_distance(log, log->log_start,
>> +						log->last_checkpoint);
>> +	sector_t reclaim_space =3D r5c_log_required_to_flush_cache(conf);
>> +
>> +	if (!r5c_is_writeback(log))
>> +		return;
>> +	else if (free_space < 2 * reclaim_space) {
>> +		set_bit(R5C_LOG_CRITICAL, &conf->cache_state);
>> +		set_bit(R5C_LOG_TIGHT, &conf->cache_state);
>> +	} else if (free_space < 3 * reclaim_space) {
>> +		clear_bit(R5C_LOG_CRITICAL, &conf->cache_state);
>> +		set_bit(R5C_LOG_TIGHT, &conf->cache_state);
>> +	} else if (free_space > 4 * reclaim_space) {
>> +		clear_bit(R5C_LOG_TIGHT, &conf->cache_state);
>> +		clear_bit(R5C_LOG_CRITICAL, &conf->cache_state);
>> +	} else
>> +		clear_bit(R5C_LOG_CRITICAL, &conf->cache_state);
>=20
> Hmmm...
> We set LOG_CRITICAL if free_space < 2*reclaim_space, else we clear it.
> We set LOG_TIGHT if free_space < 3*reclaim_space and clear it if > 4*recl=
aim_space
>=20
> Would the code be clearer if you just made that explicit.
>=20
> At the very least, change
>> +	} else if (free_space > 4 * reclaim_space) {
>> +		clear_bit(R5C_LOG_TIGHT, &conf->cache_state);
>> +		clear_bit(R5C_LOG_CRITICAL, &conf->cache_state);
>> +	} else
>> +		clear_bit(R5C_LOG_CRITICAL, &conf->cache_state);
>=20
> to
>=20
>> +	} else if (free_space < 4 * reclaim_space) {
>> +		clear_bit(R5C_LOG_CRITICAL, &conf->cache_state);
>> +	} else {
>> +		clear_bit(R5C_LOG_TIGHT, &conf->cache_state);
>> +		clear_bit(R5C_LOG_CRITICAL, &conf->cache_state);
>> +     }
>=20
> so the order of the branches is consistent and all the tests a '<'.

I will revise the code and the comments.=20

>=20
>>=20
>> 	BUG_ON(reclaimable < 0);
>> @@ -941,7 +1131,7 @@ static void r5l_do_reclaim(struct r5l_log *log)
>>=20
>> 	mutex_lock(&log->io_mutex);
>> 	log->last_checkpoint =3D next_checkpoint;
>> -	log->last_cp_seq =3D next_cp_seq;
>=20
> Why don't we update last_cp_seq here any more?

There are two reasons:=20
1. We are not using last_cp_seq after recovery is done. So it is not necess=
ary
    to update it. Shaohua had some idea to use it for reclaim (keep orderin=
g of=20
    stripes). But my initial implementation uses sh->log_start and=20
    r5l_ring_distance() instead.=20
2. With write back cache, last_cp_seq will be the seq of first stripe in=20
    stripe_in_cache_list. To track last_cp_seq, we will need an extra first=
_seq_in_cache
    in stripe_head. I feel it is a waste of memory.=20
  =20
>=20
>> +
>> +/*
>> + * if num < 0, flush all stripes
>> + * if num =3D=3D 0, flush all full stripes
>> + * if num > 0, flush all full stripes. If less than num full stripes ar=
e
>> + *             flushed, flush some partial stripes until totally num st=
ripes are
>> + *             flushed or there is no more cached stripes.
>> + */
>=20
> I'm not very keen on the idea of having "num < 0".
>=20
> I'd rather the meaning was:
>  flush all full stripes, and a total of at least num stripes.
>=20
> To flush all stripes, pass MAX_INT for num (or similar).

This is a great idea. I will fix it.=20

Thanks,
Song

