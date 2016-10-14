From: Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH v5 3/8] md/r5cache: State machine for raid5-cache write
 back mode
Date: Fri, 14 Oct 2016 07:03:32 +0000
Message-ID: <04790064-1DBC-4EDD-924A-AA665F685B4F@fb.com>
References: <20161013054944.1038806-1-songliubraving@fb.com>
 <20161013054944.1038806-4-songliubraving@fb.com>
 <87oa2nzcdz.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87oa2nzcdz.fsf@notabene.neil.brown.name>
Content-Language: en-US
Content-ID: <E76DDDC5BCC74E4F8046CFA48491682D@namprd15.prod.outlook.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, Shaohua Li <shli@fb.com>, Kernel Team <Kernel-team@fb.com>, "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "hch@infradead.org" <hch@infradead.org>, "liuzhengyuang521@gmail.com" <liuzhengyuang521@gmail.com>, "liuzhengyuan@kylinos.cn" <liuzhengyuan@kylinos.cn>
List-Id: linux-raid.ids


> On Oct 13, 2016, at 11:13 PM, NeilBrown <neilb@suse.com> wrote:
>=20
> On Thu, Oct 13 2016, Song Liu wrote:
>=20
>>=20
>> /*
>> * raid5 cache state machine
>> *
>> * The RAID cache works in two major states for each stripe: write state
>> * and reclaim state. These states are controlled by flags STRIPE_R5C_FRO=
ZEN
>> * and STRIPE_R5C_WRITTEN
>=20
> Hi,
> It would really help at this point to understand exactly what it is
> that is "FROZEN".  I guess the contents of the stripe_head are frozen?
> so that nothing changes between writing to the journal and writing to
> the RAID?  Making that explicit would help.

I guess I (wrongly) borrowed the frozen name from Shaohua's earlier
patch, where frozen means "no more writes until flush done".=20

In this implementation, STRIPE_R5C_FROZEN is to differentiate write state
and reclaim state (reclaim may not be a good name here though).=20

In write state, data writes are handled as:
    write to journal
    return IO
    write to journal
    return IO, etc

In reclaim state, the state machine works as
     calculate parity
     write parity (maybe also some data) to journal
     write data and parity to raid disks
     (maybe) return IO

The reclaim state is very similar to current write journal (or write throug=
h=20
cache) behavior; while the write state is only applicable to write back cac=
he.=20

This particular patch does NOT add detailed logic of the write back cache,=
=20
so the stripe enters reclaim state (set  STRIPE_R5C_FROZEN) immediately
on every write (in handle dirtying).=20


> Only... the stripe_head gets "frozen" before that.  It gets frozen
> before the parity is calculated, and not released until the data and
> parity is written to the RAID.  This new "FROZEN" state is a subset of
> that - yes?

Yes, the stripe got frozen before parity is calculated. And released after
data and parity is written to RAID.=20

The timeline is like:
    write data to journal, return IO
    write data to journal, return IO
    ....
    frozen
    calculate parity
    write parity to journal
    write data and parity to RAID
    release or un-frozen or melt.

>=20
> Given that STRIPE_R5C_FROZEN is set when the stripe is in "reclaim
> state", I wonder why you didn't call it "STRIPE_R5C_RECLAIM"
> .... though I'm not sure "reclaim" is a good word.  Reclaim is
> something that happens to the journal after the data has been written
> to the RAID.
Reclaim might be a good name here. It is the flag that the state machine is
working towards "write all data and parity to RAID".=20

>>=20
>> diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
>> index 7557791b..9e05850 100644
>> --- a/drivers/md/raid5-cache.c
>> +++ b/drivers/md/raid5-cache.c
>> @@ -40,6 +40,47 @@
>>  */
>> #define R5L_POOL_SIZE	4
>>=20
>> +enum r5c_state {
>> +	R5C_STATE_NO_CACHE =3D 0,
>> +	R5C_STATE_WRITE_THROUGH =3D 1,
>> +	R5C_STATE_WRITE_BACK =3D 2,
>> +	R5C_STATE_CACHE_BROKEN =3D 3,
>=20
> How is CACHE_BROKEN different from NO_CACHE??
> Maybe a latter patch will tell me, but I'd rather know now :-)

Yeah, a later patch (sysfs entry r5c_state) has more details. In current wr=
ite journal
implementation, we force the array read-only when the journal device is bro=
ken.=20
The array is read-only even after re-assemble, because it still has JOURNAL=
 bit in=20
its feature map. So that is CACHE_BROKEN,=20

> As this state is stored in the r5l_log, and as we don't allocate that
> when there is no cache, why have a NO_CACHE state?

We only store "write through" or "write back" in r5l_log. However, the r5c_=
state sysfs
entry has 2 functionalities:
     1. switching between "write through" and "write back";
     2. put array from CACHE_BROKEN to NO_CACHE (remove JOURNAL bit from=20
         feature map).=20

>>=20
>> +/*
>> + * Freeze the stripe, thus send the stripe into reclaim path.
>> + *
>> + * In current implementation, STRIPE_R5C_FROZEN is also set in write th=
rough
>> + * mode (in r5c_handle_stripe_dirtying). This does not change the behav=
ior of
>> + * for write through mode.
>> + */
>> +void r5c_freeze_stripe_for_reclaim(struct stripe_head *sh)
>=20
> "freeze_stripe_for_reclaim" seems an odd name.  How does "reclaim" fit?
> You are freezing the stripe so it can be written to the journal, and
> then eventually to the RAID are you not?
> Or are you freezing it so the space used in the journal cannot be reclaim=
ed?
>=20
> Maybe I misunderstand the "FROZEN" concept still.

It is more like "frozen" so we kickoff the reclaim process.=20

>=20
>> +{
>> +	struct r5conf *conf =3D sh->raid_conf;
>> +	struct r5l_log *log =3D conf->log;
>> +
>> +	if (!log)
>> +		return;
>> +	WARN_ON(test_bit(STRIPE_R5C_FROZEN, &sh->state));
>> +	set_bit(STRIPE_R5C_FROZEN, &sh->state);
>> +}
>> +
>> +static void r5c_finish_cache_stripe(struct stripe_head *sh)
>=20
> A comment just before this function saying when it is called would help.
> "Call when a stripe_head is safe in the journal, but has not yet been
> written to the RAID" ??

Yes, exactly "Call when a stripe_head is safe in the journal, but has not y=
et=20
been written to the RAID"=20

>> +{
>> +	struct r5l_log *log =3D sh->raid_conf->log;
>> +
>> +	if (log->r5c_state =3D=3D R5C_STATE_WRITE_THROUGH) {
>> +		BUG_ON(!test_bit(STRIPE_R5C_FROZEN, &sh->state));
>> +		set_bit(STRIPE_R5C_WRITTEN, &sh->state);
>> +	} else
>> +		BUG(); /* write back logic in next patch */
>> +}
>> +
>> static void r5l_io_run_stripes(struct r5l_io_unit *io)
>> {
>> 	struct stripe_head *sh, *next;
>>=20
>> 	list_for_each_entry_safe(sh, next, &io->stripe_list, log_list) {
>> 		list_del_init(&sh->log_list);
>> +
>> +		r5c_finish_cache_stripe(sh);
>> +
>> 		set_bit(STRIPE_HANDLE, &sh->state);
>> 		raid5_release_stripe(sh);
>> 	}
>> @@ -412,18 +493,19 @@ static int r5l_log_stripe(struct r5l_log *log, str=
uct stripe_head *sh,
>> 		r5l_append_payload_page(log, sh->dev[i].page);
>> 	}
>>=20
>> -	if (sh->qd_idx >=3D 0) {
>> +	if (parity_pages =3D=3D 2) {
>> 		r5l_append_payload_meta(log, R5LOG_PAYLOAD_PARITY,
>> 					sh->sector, sh->dev[sh->pd_idx].log_checksum,
>> 					sh->dev[sh->qd_idx].log_checksum, true);
>> 		r5l_append_payload_page(log, sh->dev[sh->pd_idx].page);
>> 		r5l_append_payload_page(log, sh->dev[sh->qd_idx].page);
>> -	} else {
>> +	} else if (parity_pages =3D=3D 1) {
>> 		r5l_append_payload_meta(log, R5LOG_PAYLOAD_PARITY,
>> 					sh->sector, sh->dev[sh->pd_idx].log_checksum,
>> 					0, false);
>> 		r5l_append_payload_page(log, sh->dev[sh->pd_idx].page);
>> -	}
>> +	} else
>> +		BUG_ON(parity_pages !=3D 0);
>=20
>=20
> Why this change?  I don't think it is wrong, but I don't see why it
> belongs here.  How does it help?

In the journal only implementation, parity_pages could only be 1 or 2. With
write back cache, parity pages could also be 0 (data only). So this is new=
=20
case to be handled here. The "BUG_ON" part is not really necessary.=20

>=20
>> +
>> +	if (!log || test_bit(STRIPE_R5C_FROZEN, &sh->state))
>> +		return -EAGAIN;
>> +
>> +	if (conf->log->r5c_state =3D=3D R5C_STATE_WRITE_THROUGH ||
>> +	    conf->mddev->degraded !=3D 0) {
>=20
> Why do you disable write-back when the array is degraded?

I think this is not really necessary. Our original thought was to simplify =
the case.
Since the array is already much slower in degraded mode, write-back cache
cannot make it awesome anyway.

I think we can enable write-back in degraded mode later on.=20

>>=20
>> +	/*
>> +	 * Now to consider new write requests, cache write back and what else,
>> +	 * if anything should be read.  We do not handle new writes when:
>> 	 * 1/ A 'write' operation (copy+xor) is already in flight.
>> 	 * 2/ A 'check' operation is in flight, as it may clobber the parity
>> 	 *    block.
>> +	 * 3/ A r5c cache log write is in flight.
>> 	 */
>> -	if (s.to_write && !sh->reconstruct_state && !sh->check_state)
>> +	if ((s.to_write || test_bit(STRIPE_R5C_FROZEN, &sh->state)) &&
>> +	    !sh->reconstruct_state && !sh->check_state && !sh->log_io)
>> 		handle_stripe_dirtying(conf, sh, &s, disks);
>=20
> OK, I'm definitely confused now.
> If the stripe is FROZEN, surely you don't want to call
> handle_stripe_dirtying().

handle_stripe_dirtying() is the beginning of original write path: shall we =
do=20
rcw or rmw? Once frozen, we need to calculate parity and write to RAID,=20
so we need handle_stripe_dirtying here.=20

Thanks,
Song

