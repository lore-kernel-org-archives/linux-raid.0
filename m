From: Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH v5 4/8] md/r5cache: write part of r5cache
Date: Fri, 14 Oct 2016 07:33:03 +0000
Message-ID: <00D21118-73D2-42D1-8062-D468D0C134B4@fb.com>
References: <20161013054944.1038806-1-songliubraving@fb.com>
 <20161013054944.1038806-5-songliubraving@fb.com>
 <87lgxrzaja.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87lgxrzaja.fsf@notabene.neil.brown.name>
Content-Language: en-US
Content-ID: <B1795B69EB47D84EADF017401813262B@namprd15.prod.outlook.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, Shaohua Li <shli@fb.com>, Kernel Team <Kernel-team@fb.com>, "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "hch@infradead.org" <hch@infradead.org>, "liuzhengyuang521@gmail.com" <liuzhengyuang521@gmail.com>, "liuzhengyuan@kylinos.cn" <liuzhengyuan@kylinos.cn>
List-Id: linux-raid.ids


> On Oct 13, 2016, at 11:53 PM, NeilBrown <neilb@suse.com> wrote:
>=20
> On Thu, Oct 13 2016, Song Liu wrote:
>>=20
>> For RMW, the code allocates an extra page for each data block
>> being updated.  This is stored in r5dev->page and the old data
>> is read into it.  Then the prexor calculation subtracts ->page
>> from the parity block, and the reconstruct calculation adds the
>> ->orig_page data back into the parity block.
>=20
> What happens if the alloc_page() fails?

That will be tough, but solvable.. We can
    read old data to page
    do prexor=20
    read new data from journal device to page
    do xor=20
    do the rest of the work.=20

Or we can force the code to rcw, which does not need extra page.=20
But rcw, does not always work in degraded mode. So, this is a good=20
reason not to do write-back in degraded mode...

>>=20
>> This patch includes a fix proposed by ZhengYuan Liu
>> <liuzhengyuan@kylinos.cn>
>>=20
>> Signed-off-by: Song Liu <songliubraving@fb.com>
>=20
> You introduce a new flag:
>> +	R5_InCache,	/* Data in cache */
>=20
> but don't document it at all (apart from those three words).
> I must confess that I found it confuses when you talk about the
> "journal" as the "cache".  I understand way, but in my mind, the "cache"
> is the in-memory cache of stripe_heads.
> We now have something that we sometimes call a "journal", sometimes call
> a "log" and sometimes call a "cache".  That is a recipe for confusion.
>=20
> A sentence or two explaining how this flag will be used would help in
> reading the rest of the code.

I will try to unify the names here, and add more comments.=20

>=20
>> +
>> +void r5c_handle_cached_data_endio(struct r5conf *conf,
>> +	  struct stripe_head *sh, int disks, struct bio_list *return_bi)
>> +{
>> +	int i;
>> +
>> +	for (i =3D sh->disks; i--; ) {
>> +		if (test_bit(R5_InCache, &sh->dev[i].flags) &&
>> +		    sh->dev[i].written) {
>=20
> Is it possible for R5_InCache to be set, but 'written' to be NULL ???

Yes, it is possible. A stripe may go through "write data to journal, return=
 IO" multiple
times before parity calculation. When it comes here the second time, dev wr=
itten in the=20
first time will have R5_InCache set, but its written will be NULL.=20

>=20
>>=20
>> static void r5c_finish_cache_stripe(struct stripe_head *sh)
>> @@ -242,8 +323,10 @@ static void r5c_finish_cache_stripe(struct stripe_h=
ead *sh)
>> 	if (log->r5c_state =3D=3D R5C_STATE_WRITE_THROUGH) {
>> 		BUG_ON(!test_bit(STRIPE_R5C_FROZEN, &sh->state));
>> 		set_bit(STRIPE_R5C_WRITTEN, &sh->state);
>> -	} else
>> -		BUG(); /* write back logic in next patch */
>> +	} else if (test_bit(STRIPE_R5C_FROZEN, &sh->state))
>> +		r5c_handle_parity_cached(sh);
>> +	else
>> +		r5c_handle_data_cached(sh);
>> }
>>=20
>> static void r5l_io_run_stripes(struct r5l_io_unit *io)
>> @@ -483,7 +566,8 @@ static int r5l_log_stripe(struct r5l_log *log, struc=
t stripe_head *sh,
>> 	io =3D log->current_io;
>>=20
>> 	for (i =3D 0; i < sh->disks; i++) {
>> -		if (!test_bit(R5_Wantwrite, &sh->dev[i].flags))
>> +		if (!test_bit(R5_Wantwrite, &sh->dev[i].flags) &&
>> +		    !test_bit(R5_Wantcache, &sh->dev[i].flags))
>> 			continue;
>=20
> If changed R5_Wantcache to R5_Wantjournal, and always set it on blocks
> that were destined for the journal, then this would just be
>=20
> 		if (!test_bit(R5_Wantjournal, &sh->dev[i].flags))
>=20
> which would make lots of sense...  Just a thought.

We set R5_Wantwrite in multiple places. If we simplify the code here, we wi=
ll need to make
those places aware of journal. I guess that is not ideal either?=20

=20
>=20
>> }
>>=20
>> -static void r5l_wake_reclaim(struct r5l_log *log, sector_t space)
>> +void r5l_wake_reclaim(struct r5l_log *log, sector_t space)
>=20
> Why are you removing the 'static' here?  You don't call it from any
> other file.

In next patch, it is called in raid.c.=20

>=20
>>=20
>>=20
>> static int r5l_load_log(struct r5l_log *log)
>> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
>> index 2e3e61a..0539f34 100644
>> --- a/drivers/md/raid5.c
>> +++ b/drivers/md/raid5.c
>> @@ -245,8 +245,25 @@ static void do_release_stripe(struct r5conf *conf, =
struct stripe_head *sh,
>> 			    < IO_THRESHOLD)
>> 				md_wakeup_thread(conf->mddev->thread);
>> 		atomic_dec(&conf->active_stripes);
>> -		if (!test_bit(STRIPE_EXPANDING, &sh->state))
>> -			list_add_tail(&sh->lru, temp_inactive_list);
>> +		if (!test_bit(STRIPE_EXPANDING, &sh->state)) {
>> +			if (atomic_read(&sh->dev_in_cache) =3D=3D 0) {
>> +				list_add_tail(&sh->lru, temp_inactive_list);
>> +			} else if (atomic_read(&sh->dev_in_cache) =3D=3D
>> +				   conf->raid_disks - conf->max_degraded) {
>=20
> Is this really the test that you want?
> Presumably "full stripes" are those that can be written out without
> reading anything, while "partial stripes" will need something read in
> first.
> It is possible that the stripe head contains data for some devices which
> is not in the cache, possibly because a READ request filled it in.
> So we should really be counting the number of devices with R5_UPTODATE.
> ??

Yes, counting R5_UPTODATE will be better. Let me check whether there are
corner cases we need to cover.=20

Thanks,
Song

