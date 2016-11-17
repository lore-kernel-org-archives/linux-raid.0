From: Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH v6 04/11] md/r5cache: caching mode of r5cache
Date: Thu, 17 Nov 2016 17:25:13 +0000
Message-ID: <529A29AD-9526-4FCD-9218-B478B46C1FD4@fb.com>
References: <20161110204623.3484694-1-songliubraving@fb.com>
 <20161110204623.3484694-5-songliubraving@fb.com>
 <20161115170330.kdjxussdau54ekus@kernel.org>
 <0A3E2AC9-966D-4EC3-A16D-CE8AC7B85DB7@fb.com>
 <20161115214919.GA28086@shli-mbp.local>
 <504BBD2B-D9C8-4D54-992D-6CF460015C32@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <504BBD2B-D9C8-4D54-992D-6CF460015C32@fb.com>
Content-Language: en-US
Content-ID: <F6519EF190C9364A93171A584AAD5AF4@namprd15.prod.outlook.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>
Cc: Shaohua Li <shli@kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, NeilBrown <neilb@suse.com>, Kernel Team <Kernel-team@fb.com>, "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "hch@infradead.org" <hch@infradead.org>, "liuzhengyuang521@gmail.com" <liuzhengyuang521@gmail.com>, "liuzhengyuan@kylinos.cn" <liuzhengyuan@kylinos.cn>
List-Id: linux-raid.ids

>=20
>>=20
>>>>> @@ -1547,6 +1611,7 @@ ops_run_biodrain(struct stripe_head *sh, struct=
 dma_async_tx_descriptor *tx)
>>>>>=20
>>>>> again:
>>>>> 			dev =3D &sh->dev[i];
>>>>> +			clear_bit(R5_InJournal, &dev->flags);
>>>>=20
>>>> why clear the bit here? isn't this bit cleared when the stripe is init=
ialized?
>>>=20
>>> This is necessary when we rewrite a page that is already in journal. Th=
is means there is new data coming to=20
>>> this stripe and dev, so we should not consider the page is secured in j=
ournal.=20
>>=20
>> This sounds suggest we should clear the bit after writeout is done.
>=20
> That may also work. Let me confirm.=20
>=20

I think we still need clear R5_InJournal in ops_run_biodrain(). r5l_write_s=
tripe() and r5l_log_stripe() uses=20
R5_InJournal as a flag of "no need to write journal again". If we do not cl=
ear R5_InJournal in=20
ops_run_biodrain(), newer data will not be written to journal.=20

Thanks,
Song

