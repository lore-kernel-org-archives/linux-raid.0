From: Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH v2 1/6] r5cache: write part of r5cache
Date: Thu, 29 Sep 2016 23:06:38 +0000
Message-ID: <4405D5C4-0BF7-44F2-B088-39A3EF121B3F@fb.com>
References: <20160926233050.3351081-1-songliubraving@fb.com>
 <20160926233050.3351081-2-songliubraving@fb.com>
 <20160927225120.GA98100@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160927225120.GA98100@kernel.org>
Content-Language: en-US
Content-ID: <D6143752BC3B89479AA319085B80BFD1@namprd15.prod.outlook.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: Song Liu <songliubraving@fb.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "neilb@suse.com" <neilb@suse.com>, Shaohua Li <shli@fb.com>, Kernel Team <Kernel-team@fb.com>, "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "hch@infradead.org" <hch@infradead.org>, "liuzhengyuang521@gmail.com" <liuzhengyuang521@gmail.com>, "liuzhengyuan@kylinos.cn" <liuzhengyuan@kylinos.cn>
List-Id: linux-raid.ids

Thanks Shaohua!

I am working on adding more information in comments and commit notes.=20


>>=20
>> +/*
>> + * Freeze the stripe, thus send the stripe into reclaim path.
>> + *
>> + * This function should only be called from raid5d that handling this s=
tripe,
>> + * or when holds conf->device_lock
>> + */
>=20
> Do you mean if this called in raid5d, the lock isn't required? Please not=
e we
> could have several threads (like raid5d) handle stripes. Is there any pro=
blem
> here?

This requirement is not necessary anymore. I will update the comment here.=
=20

>=20
>> +void r5c_freeze_stripe_for_reclaim(struct stripe_head *sh)
>> +{
>> +	struct r5conf *conf =3D sh->raid_conf;
>> +
>> +	if (!conf->log)
>> +		return;
>> +static void r5c_handle_parity_cached(struct stripe_head *sh)
>> +{
>> +	int i;
>> +
>> +	for (i =3D sh->disks; i--; )
>> +		if (test_bit(R5_InCache, &sh->dev[i].flags))
>> +			set_bit(R5_Wantwrite, &sh->dev[i].flags);
>> +	set_bit(STRIPE_R5C_WRITTEN, &sh->state);
>> +}
>> +
>> +static void r5c_finish_cache_stripe(struct stripe_head *sh)
>> +{
>=20
> I'm hoping this one has a
> 	if (not in writeback mode)
> 		return
> so it's clearly this is only for writeback mode.
>=20
>> +	if (test_bit(STRIPE_R5C_FROZEN, &sh->state))
>> +		r5c_handle_parity_cached(sh);
>> +	else
>> +		r5c_handle_data_cached(sh);
>> +}
>> +
>>=20
>> 	return 0;
>> }
>>=20
>> -static void r5l_wake_reclaim(struct r5l_log *log, sector_t space);
>> /*
>>  * running in raid5d, where reclaim could wait for raid5d too (when it f=
lushes
>>  * data from log to raid disks), so we shouldn't wait for reclaim here
>> @@ -456,11 +541,17 @@ int r5l_write_stripe(struct r5l_log *log, struct s=
tripe_head *sh)
>> 		return -EAGAIN;
>> 	}
>>=20
>> +	WARN_ON(!test_bit(STRIPE_R5C_FROZEN, &sh->state));
>=20
> is this set even for write through?

In current implementation, the code still sets STRIPE_R5C_FROZEN in write t=
hrough mode=20
(in r5c_handle_stripe_dirtying). The reclaim path handles has same behavior=
 in write through=20
mode as original journal.

>>=20
>> +
>> +	if (!log || test_bit(STRIPE_R5C_FROZEN, &sh->state))
>> +		return -EAGAIN;
>> +
>> +	if (conf->log->r5c_state =3D=3D R5C_STATE_WRITE_THROUGH ||
>> +	    conf->quiesce !=3D 0 || conf->mddev->degraded !=3D 0) {
>> +		/* write through mode */
>> +		r5c_freeze_stripe_for_reclaim(sh);
>> +		return -EAGAIN;
>=20
> will this change behavior of R5C_STATE_WRITE_THROUGH?
> r5c_freeze_stripe_for_reclaim does change something not related to writet=
hrough
> mode.

The PREREAD_ACTIVE part of freeze is not necessary for write through. I wil=
l fix it.=20
Other that, the reclaim path works the same as write through mode (as origi=
nal journal
code). I will double check and make it clear.=20


> The quiesce check sounds not necessary. The patch flush all caches in qui=
esce,
> so no IO is running in quiesce state.

Great catch. Other checks already covers all cases in quiesce.=20

>>=20
>> @@ -901,6 +918,13 @@ static void ops_run_io(struct stripe_head *sh, stru=
ct stripe_head_state *s)
>>=20
>> 	might_sleep();
>>=20
>> +	if (s->to_cache) {
>> +		if (r5c_cache_data(conf->log, sh, s) =3D=3D 0)
>> +			return;
>=20
> At this stage we fallback to no cache. But I don't see R5_Wantcache is cl=
eared,
> is it a problem?

We did similar check for journal part. I think it will be easier if we add =
a check in=20
r5l_init_log(), and never create journal/cache when the array is too big?=20

>=20
>> @@ -1543,9 +1570,18 @@ ops_run_compute6_2(struct stripe_head *sh, struct=
 raid5_percpu *percpu)
>> static void ops_complete_prexor(void *stripe_head_ref)
>> {
>> 	struct stripe_head *sh =3D stripe_head_ref;
>> +	int i;
>>=20
>> 	pr_debug("%s: stripe %llu\n", __func__,
>> 		(unsigned long long)sh->sector);
>> +
>> +	for (i =3D sh->disks; i--; )
>> +		if (sh->dev[i].page !=3D sh->dev[i].orig_page) {
>> +			struct page *p =3D sh->dev[i].page;
>> +
>> +			sh->dev[i].page =3D sh->dev[i].orig_page;
>> +			put_page(p);
> What if array hasn't log but skipcopy is enabled?

In case of skip copy, page and orig_page are the same during ops_complete_p=
rexor:=20
    page =3D=3D orig_page =3D=3D old data.=20
    bio_page is the new data.=20

After prexor is done, we run biodrain, where page is set to bio_page to ski=
p copy.=20

>>=20
>> @@ -4416,7 +4538,7 @@ static void handle_stripe(struct stripe_head *sh)
>> 			struct r5dev *dev =3D &sh->dev[i];
>> 			if (test_bit(R5_LOCKED, &dev->flags) &&
>> 				(i =3D=3D sh->pd_idx || i =3D=3D sh->qd_idx ||
>> -				 dev->written)) {
>> +				 dev->written || test_bit(R5_InCache, &dev->flags))) {
>> 				pr_debug("Writing block %d\n", i);
>> 				set_bit(R5_Wantwrite, &dev->flags);
>> 				if (prexor)
>> @@ -4456,6 +4578,12 @@ static void handle_stripe(struct stripe_head *sh)
>> 				 test_bit(R5_Discard, &qdev->flags))))))
>> 		handle_stripe_clean_event(conf, sh, disks, &s.return_bi);
>>=20
>> +	if (s.just_cached)
>> +		r5c_handle_cached_data_endio(conf, sh, disks, &s.return_bi);
>> +
>> +	if (test_bit(STRIPE_R5C_FROZEN, &sh->state))
>> +		r5l_stripe_write_finished(sh);
> what's this for?

r5l_stripe_write_finished() removes sh->log_io.=20

It is actually not necessary to check for R5C_FROZEN. I will fix that.=20

>=20
>> +
>> 	/* Now we might consider reading some blocks, either to check/generate
>> 	 * parity, or to satisfy requests
>> 	 * or to load a block that is being partially written.
>> @@ -4467,13 +4595,17 @@ static void handle_stripe(struct stripe_head *sh=
)
>> 	    || s.expanding)
>> 		handle_stripe_fill(sh, &s, disks);
>>=20
>> -	/* Now to consider new write requests and what else, if anything
>> -	 * should be read.  We do not handle new writes when:
>> +	r5c_handle_stripe_written(conf, sh);
>=20
> please explain why this is required?

Added the following in comments:

        /*
         * If the stripe finishes full journal write cycle (write to journa=
l
         * and raid disk, this is the clean up procedure so it is ready for
         * next operation.
         */

>>=20
>> 	/* maybe we need to check and possibly fix the parity for this stripe
>> @@ -5192,7 +5324,7 @@ static void raid5_make_request(struct mddev *mddev=
, struct bio * bi)
>> 	 * later we might have to read it again in order to reconstruct
>> 	 * data on failed drives.
>> 	 */
>> -	if (rw =3D=3D READ && mddev->degraded =3D=3D 0 &&
>> +	if (rw =3D=3D READ && mddev->degraded =3D=3D 0 && conf->log =3D=3D NUL=
L &&
>> 	    mddev->reshape_position =3D=3D MaxSector) {
>> 		bi =3D chunk_aligned_read(mddev, bi);
>> 		if (!bi)
> This should be only for R5C_STATE_WRITE_BACK.

Will fix this.=20


>>=20
>> @@ -7662,8 +7800,11 @@ static void raid5_quiesce(struct mddev *mddev, in=
t state)
>> 		/* '2' tells resync/reshape to pause so that all
>> 		 * active stripes can drain
>> 		 */
>> +		r5c_flush_cache(conf, 0);
>> 		conf->quiesce =3D 2;
>> 		wait_event_cmd(conf->wait_for_quiescent,
>> +				    atomic_read(&conf->r5c_cached_partial_stripes) =3D=3D 0 &&
>> +				    atomic_read(&conf->r5c_cached_full_stripes) =3D=3D 0 &&
> I don't see a wakeup for this after the check condition is met.

The following in release_inactive_stripe_list will wake this up.=20
                if (atomic_read(&conf->active_stripes) =3D=3D 0)
                        wake_up(&conf->wait_for_quiescent);

This is OK because cached stripes (full stripe or partial) has to become ac=
tive
first before being inactive.=20

Thanks,
Song

