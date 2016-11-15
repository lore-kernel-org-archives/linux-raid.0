From: Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH v6 04/11] md/r5cache: caching mode of r5cache
Date: Tue, 15 Nov 2016 19:08:29 +0000
Message-ID: <0A3E2AC9-966D-4EC3-A16D-CE8AC7B85DB7@fb.com>
References: <20161110204623.3484694-1-songliubraving@fb.com>
 <20161110204623.3484694-5-songliubraving@fb.com>
 <20161115170330.kdjxussdau54ekus@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161115170330.kdjxussdau54ekus@kernel.org>
Content-Language: en-US
Content-ID: <8D818A94F9BB1343BB48A9922BB172E5@namprd15.prod.outlook.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, NeilBrown <neilb@suse.com>, Shaohua Li <shli@fb.com>, Kernel Team <Kernel-team@fb.com>, "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "hch@infradead.org" <hch@infradead.org>, "liuzhengyuang521@gmail.com" <liuzhengyuang521@gmail.com>, "liuzhengyuan@kylinos.cn" <liuzhengyuan@kylinos.cn>
List-Id: linux-raid.ids


> On Nov 15, 2016, at 9:03 AM, Shaohua Li <shli@kernel.org> wrote:
>=20
> On Thu, Nov 10, 2016 at 12:46:16PM -0800, Song Liu wrote:
>> As described in previous patch, write back cache operates in two
>> modes: caching and writing-out. The caching mode works as:
>> 1. write data to journal
>>   (r5c_handle_stripe_dirtying, r5c_cache_data)
>> 2. call bio_endio
>>   (r5c_handle_data_cached, r5c_return_dev_pending_writes).
>>=20
>> Then the writing-out path is as:
>> 1. Mark the stripe as write-out (r5c_make_stripe_write_out)
>> 2. Calcualte parity (reconstruct or RMW)
>> 3. Write parity (and maybe some other data) to journal device
>> 4. Write data and parity to RAID disks
>>=20
>> This patch implements caching mode. The cache is integrated with
>> stripe cache of raid456. It leverages code of r5l_log to write
>> data to journal device.
>>=20
>> Writing-out mode of the cache is implemented in the next patch.
>>=20
>> With r5cache, write operation does not wait for parity calculation
>> and write out, so the write latency is lower (1 write to journal
>> device vs. read and then write to raid disks). Also, r5cache will
>> reduce RAID overhead (multipile IO due to read-modify-write of
>> parity) and provide more opportunities of full stripe writes.
>>=20
>> This patch adds 2 flags to stripe_head.state:
>> - STRIPE_R5C_PARTIAL_STRIPE,
>> - STRIPE_R5C_FULL_STRIPE,
>>=20
>> Instead of inactive_list, stripes with cached data are tracked in
>> r5conf->r5c_full_stripe_list and r5conf->r5c_partial_stripe_list.
>> STRIPE_R5C_FULL_STRIPE and STRIPE_R5C_PARTIAL_STRIPE are flags for
>> stripes in these lists. Note: stripes in r5c_full/partial_stripe_list
>> are not considered as "active".
>>=20
>> For RMW, the code allocates an extra page for each data block
>> being updated.  This is stored in r5dev->page and the old data
>> is read into it.  Then the prexor calculation subtracts ->page
>> from the parity block, and the reconstruct calculation adds the
>> ->orig_page data back into the parity block.
>>=20
>> r5cache naturally excludes SkipCopy. When the array has write back
>> cache, async_copy_data() will not skip copy.
>>=20
>> There are some known limitations of the cache implementation:
>>=20
>> 1. Write cache only covers full page writes (R5_OVERWRITE). Writes
>>   of smaller granularity are write through.
>> 2. Only one log io (sh->log_io) for each stripe at anytime. Later
>>   writes for the same stripe have to wait. This can be improved by
>>   moving log_io to r5dev.
>> 3. With writeback cache, read path must enter state machine, which
>>   is a significant bottleneck for some workloads.
>> 4. There is no per stripe checkpoint (with r5l_payload_flush) in
>>   the log, so recovery code has to replay more than necessary data
>>   (sometimes all the log from last_checkpoint). This reduces
>>   availability of the array.
>>=20
>> This patch includes a fix proposed by ZhengYuan Liu
>> <liuzhengyuan@kylinos.cn>
>>=20
>> Signed-off-by: Song Liu <songliubraving@fb.com>
>> ---
>>=20
>> +				if (injournal =3D=3D 0)
>> +					list_add_tail(&sh->lru, temp_inactive_list);
>> +				else if (uptodate =3D=3D conf->raid_disks - conf->max_degraded) {
>> +					/* full stripe */
>> +					if (!test_and_set_bit(STRIPE_R5C_FULL_STRIPE, &sh->state))
>> +						atomic_inc(&conf->r5c_cached_full_stripes);
>> +					if (test_and_clear_bit(STRIPE_R5C_PARTIAL_STRIPE, &sh->state))
>> +						atomic_dec(&conf->r5c_cached_partial_stripes);
>> +					list_add_tail(&sh->lru, &conf->r5c_full_stripe_list);
>=20
> Using the R5_UPTODATE bit to determine full stripe is skeptical. Read ent=
ers
> into the state machine with writeback. After data is is read into stripe =
cache,
> the R5_UPTODATE bit is set. So here we could put stripe which is never wr=
itten
> into r5c_cached_full_stripes. why not just use injournal to do the determ=
ination?

Here, we first test if (injournal =3D=3D 0). If so, this stripe is released=
 to temp_inactive_list. So I think
it is not problem?
>>=20
>> 	might_sleep();
>>=20
>> -	if (r5l_write_stripe(conf->log, sh) =3D=3D 0)
>> -		return;
>> +	if (test_bit(STRIPE_R5C_WRITE_OUT, &sh->state)) {
>> +		/* writing out mode */
>> +		if (r5l_write_stripe(conf->log, sh) =3D=3D 0)
>> +			return;
>> +	} else {
>> +		/* caching mode */
>> +		if (test_bit(STRIPE_LOG_TRAPPED, &sh->state)) {
>=20
> The STRIPE_LOG_TRAPPED bit isn't designed for this, maybe it just works, =
I have
> to double check. but this one is a little confusing.

This is somehow reuse the flag in caching mode/phase. In handle_stripe(), a=
 large part of the=20
logic is skipped with STRIPE_LOG_TRAPPED. This behavior is the same in cach=
ing mode/phase
and write_out mode/phase.=20

>> static struct dma_async_tx_descriptor *
>> @@ -1496,7 +1558,8 @@ ops_run_prexor5(struct stripe_head *sh, struct rai=
d5_percpu *percpu,
>> 	for (i =3D disks; i--; ) {
>> 		struct r5dev *dev =3D &sh->dev[i];
>> 		/* Only process blocks that are known to be uptodate */
>> -		if (test_bit(R5_Wantdrain, &dev->flags))
>> +		if (test_bit(R5_Wantdrain, &dev->flags) ||
>> +		    test_bit(R5_InJournal, &dev->flags))
>> 			xor_srcs[count++] =3D dev->page;
>> 	}
>>=20
>> @@ -1530,6 +1593,7 @@ ops_run_prexor6(struct stripe_head *sh, struct rai=
d5_percpu *percpu,
>> static struct dma_async_tx_descriptor *
>> ops_run_biodrain(struct stripe_head *sh, struct dma_async_tx_descriptor =
*tx)
>> {
>> +	struct r5conf *conf =3D sh->raid_conf;
>> 	int disks =3D sh->disks;
>> 	int i;
>> 	struct stripe_head *head_sh =3D sh;
>> @@ -1547,6 +1611,7 @@ ops_run_biodrain(struct stripe_head *sh, struct dm=
a_async_tx_descriptor *tx)
>>=20
>> again:
>> 			dev =3D &sh->dev[i];
>> +			clear_bit(R5_InJournal, &dev->flags);
>=20
> why clear the bit here? isn't this bit cleared when the stripe is initial=
ized?

This is necessary when we rewrite a page that is already in journal. This m=
eans there is new data coming to=20
this stripe and dev, so we should not consider the page is secured in journ=
al.=20

>=20
> Thanks,
> Shaohua

