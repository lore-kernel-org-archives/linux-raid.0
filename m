From: Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH v6 03/11] md/r5cache: State machine for raid5-cache write
 back mode
Date: Tue, 15 Nov 2016 01:36:45 +0000
Message-ID: <E9BA3F38-D363-42CA-9360-B5CFF0F30671@fb.com>
References: <20161110204623.3484694-1-songliubraving@fb.com>
 <20161110204623.3484694-4-songliubraving@fb.com>
 <20161115012221.5holqbeqi542k7pa@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161115012221.5holqbeqi542k7pa@kernel.org>
Content-Language: en-US
Content-ID: <F9EE7F7DBABC3C43BDA9D4FA81DADE8F@namprd15.prod.outlook.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, NeilBrown <neilb@suse.com>, Shaohua Li <shli@fb.com>, Kernel Team <Kernel-team@fb.com>, "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "hch@infradead.org" <hch@infradead.org>, "liuzhengyuang521@gmail.com" <liuzhengyuang521@gmail.com>, "liuzhengyuan@kylinos.cn" <liuzhengyuan@kylinos.cn>
List-Id: linux-raid.ids


> On Nov 14, 2016, at 5:22 PM, Shaohua Li <shli@kernel.org> wrote:
>=20
>> The following detailed explanation is copied from the raid5-cache.c:
>>=20
>> /*
>> * raid5 cache state machine
>> *
>> * With rhe RAID cache, each stripe works in two modes:
>> *      - caching mode
>> *      - writing-out mode
>=20
> 'mode' is quite confusing here. it always remainders me r5c_journal_mode.=
 can
> you use state?

I am not very sure whether state is the best name here. Maybe we can use "p=
hase"?

>> + * Note: when the array is in write-through, each stripe still goes thr=
ough
>> + * caching mode and writing-out mode. In such cases, this function is c=
alled
>> + * in r5c_handle_stripe_dirtying().
>> + */
>> +static void r5c_make_stripe_write_out(struct stripe_head *sh)
>> +{
>> +	struct r5conf *conf =3D sh->raid_conf;
>> +	struct r5l_log *log =3D conf->log;
>> +
>> +	if (!log)
>> +		return;
>> +	WARN_ON(test_bit(STRIPE_R5C_WRITE_OUT, &sh->state));
>> +	set_bit(STRIPE_R5C_WRITE_OUT, &sh->state);
>> +}
>> +
>> +/*
>> + * Setting proper flags after writing (or flushing) data and/or parity =
to the
>> + * log device. This is called from r5l_log_endio() or r5l_log_flush_end=
io().
>> + */
>> +static void r5c_finish_cache_stripe(struct stripe_head *sh)
>> +{
>> +	struct r5l_log *log =3D sh->raid_conf->log;
>> +
>> +	if (log->r5c_journal_mode =3D=3D R5C_JOURNAL_MODE_WRITE_THROUGH) {
>> +		BUG_ON(!test_bit(STRIPE_R5C_WRITE_OUT, &sh->state));
>> +		/*
>> +		 * Set R5_InJournal for parity dev[pd_idx]. This means parity
>> +		 * is in the journal. For RAID 6, it is NOT necessary to set
>> +		 * the flag for dev[qd_idx], as the two parities are written
>> +		 * out together.
>> +		 */
>> +		set_bit(R5_InJournal, &sh->dev[sh->pd_idx].flags);
>=20
> if this flag is only for pd_idx disk and you are using it to determine th=
e
> stripe data is in journal, why not make it a stripe flag?
R5_InJournal is used in multiple place in the next patch. Using it here wil=
l=20
save us a stripe flag.=20

Thanks,
Song


