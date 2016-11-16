From: Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH v6 04/11] md/r5cache: caching mode of r5cache
Date: Wed, 16 Nov 2016 19:55:25 +0000
Message-ID: <504BBD2B-D9C8-4D54-992D-6CF460015C32@fb.com>
References: <20161110204623.3484694-1-songliubraving@fb.com>
 <20161110204623.3484694-5-songliubraving@fb.com>
 <20161115170330.kdjxussdau54ekus@kernel.org>
 <0A3E2AC9-966D-4EC3-A16D-CE8AC7B85DB7@fb.com>
 <20161115214919.GA28086@shli-mbp.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161115214919.GA28086@shli-mbp.local>
Content-Language: en-US
Content-ID: <4F5B572E25472742A9B236094B048064@namprd15.prod.outlook.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>
Cc: Shaohua Li <shli@kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, NeilBrown <neilb@suse.com>, Kernel Team <Kernel-team@fb.com>, "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "hch@infradead.org" <hch@infradead.org>, "liuzhengyuang521@gmail.com" <liuzhengyuang521@gmail.com>, "liuzhengyuan@kylinos.cn" <liuzhengyuan@kylinos.cn>
List-Id: linux-raid.ids


> On Nov 15, 2016, at 1:49 PM, Shaohua Li <shli@fb.com> wrote:
>=20
> On Tue, Nov 15, 2016 at 07:08:29PM +0000, Song Liu wrote:
>=20
>>>>=20
>>>> 	might_sleep();
>>>>=20
>>>> -	if (r5l_write_stripe(conf->log, sh) =3D=3D 0)
>>>> -		return;
>>>> +	if (test_bit(STRIPE_R5C_WRITE_OUT, &sh->state)) {
>>>> +		/* writing out mode */
>>>> +		if (r5l_write_stripe(conf->log, sh) =3D=3D 0)
>>>> +			return;
>>>> +	} else {
>>>> +		/* caching mode */
>>>> +		if (test_bit(STRIPE_LOG_TRAPPED, &sh->state)) {
>>>=20
>>> The STRIPE_LOG_TRAPPED bit isn't designed for this, maybe it just works=
, I have
>>> to double check. but this one is a little confusing.
>>=20
>> This is somehow reuse the flag in caching mode/phase. In handle_stripe()=
, a large part of the=20
>> logic is skipped with STRIPE_LOG_TRAPPED. This behavior is the same in c=
aching mode/phase
>> and write_out mode/phase.=20
>=20
> I'd think this is another abuse of the bit. Both writeout mode and the ca=
ching
> mode could set the bit. Here you are using the bit to determine if enteri=
ng
> caching mode. This isn't clear at all to me. I'd add another bit to indic=
ate
> the caching mode if necessary.

I guess the comment made it confusing... STRIPE_LOG_TRAPPED is not=20
used to determine where it is in caching phase. The /* caching phase */ is=
=20
for the "else" statement:

        if (test_bit(STRIPE_R5C_WRITE_OUT, &sh->state)) {
                /* writing out phase */
                if (r5l_write_stripe(conf->log, sh) =3D=3D 0)
                        return;
        } else {  /* caching phase   i.e.  STRIPE_R5C_WRITE_OUT =3D=3D 0 */
                if (test_bit(STRIPE_LOG_TRAPPED, &sh->state)) {
                        r5c_cache_data(conf->log, sh, s);
                        return;
                }
        }

In caching phase, STRIPE_LOG_TRAPPED is used as a gate of=20
r5c_cache_data(). It is set in r5c_handle_dirtying() and cleared in=20
endio of journal writes. It is kind similar to the name "log trapped"
meaning it is time to write data to the log.=20

>=20
>>>> @@ -1547,6 +1611,7 @@ ops_run_biodrain(struct stripe_head *sh, struct =
dma_async_tx_descriptor *tx)
>>>>=20
>>>> again:
>>>> 			dev =3D &sh->dev[i];
>>>> +			clear_bit(R5_InJournal, &dev->flags);
>>>=20
>>> why clear the bit here? isn't this bit cleared when the stripe is initi=
alized?
>>=20
>> This is necessary when we rewrite a page that is already in journal. Thi=
s means there is new data coming to=20
>> this stripe and dev, so we should not consider the page is secured in jo=
urnal.=20
>=20
> This sounds suggest we should clear the bit after writeout is done.

That may also work. Let me confirm.=20

Thanks,=20
Song=
