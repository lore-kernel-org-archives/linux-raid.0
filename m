From: Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH] md/bitmap: avoid read out of the disk
Date: Mon, 16 Oct 2017 16:21:39 +0000
Message-ID: <608CE47A-1C46-4087-B7D3-6FA5936C1DAF@fb.com>
References: <a9a406f5f751d39620d5e4907992ccb1bdbfb5a7.1507670143.git.shli@fb.com>
 <87bmldnjtq.fsf@notabene.neil.brown.name>
 <20171012173019.c2bbfyz3hgudjbhz@kernel.org>
 <ED3BAA5A-9A7B-4FA1-BC4E-299F1A69D9E7@fb.com>
 <87wp3zlj9q.fsf@notabene.neil.brown.name>
 <20171013195122.mi7gr4xxm77odx7t@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20171013195122.mi7gr4xxm77odx7t@kernel.org>
Content-Language: en-US
Content-ID: <D9E91C66CC3E1B4C92C902D8812F0174@namprd15.prod.outlook.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: NeilBrown <neilb@suse.com>, linux-raid <linux-raid@vger.kernel.org>, "kumba@gentoo.org" <kumba@gentoo.org>, Shaohua Li <shli@fb.com>
List-Id: linux-raid.ids


> On Oct 13, 2017, at 12:51 PM, Shaohua Li <shli@kernel.org> wrote:
>=20
> On Fri, Oct 13, 2017 at 04:16:33PM +1100, Neil Brown wrote:
>> On Thu, Oct 12 2017, Song Liu wrote:
>>=20
>>>> On Oct 12, 2017, at 10:30 AM, Shaohua Li <shli@kernel.org> wrote:
>>>>=20
>>>> On Thu, Oct 12, 2017 at 02:09:21PM +1100, Neil Brown wrote:
>>>>> On Tue, Oct 10 2017, Shaohua Li wrote:
>>>>>=20
>>>>>> From: Shaohua Li <shli@fb.com>
>>>>>>=20
>>>>>> If PAGE_SIZE is bigger than 4k, we could read out of the disk bounda=
ry. Limit
>>>>>> the read size to the end of disk. Write path already has similar lim=
itation.
>>>>>>=20
>>>>>> Fix: 8031c3ddc70a(md/bitmap: copy correct data for bitmap super)
>>>>>> Reported-by: Joshua Kinard <kumba@gentoo.org>
>>>>>> Tested-by: Joshua Kinard <kumba@gentoo.org>
>>>>>> Cc: Song Liu <songliubraving@fb.com>
>>>>>> Signed-off-by: Shaohua Li <shli@fb.com>
>>>>>=20
>>>>> Given that this bug was introduced by
>>>>> Commit: 8031c3ddc70a ("md/bitmap: copy correct data for bitmap super"=
)
>>>>>=20
>>>>> and that patch is markted:
>>>>>=20
>>>>>   Cc: stable@vger.kernel.org (4.10+)
>>>>>=20
>>>>> I think this patch should be tagged "CC: stable" too.
>>>>=20
>>>> I thought the Fix tag is enough, but I'll add the stable=20
>>>>> However ... that earlier patch looks strange to me.
>>>>> Why is it that "raid5 cache could write bitmap superblock before bitm=
ap superblock is
>>>>> initialized."  Can we just get raid5 cache *not* to write the bitmap
>>>>> superblock too early?
>>>>> I think that would better than breaking code that previously worked.
>>>>=20
>>>> That's the log reply code, which must update superblock and hence bitm=
ap
>>>> superblock, because reply happens very earlier. I agree the reply migh=
t still
>>>> have problem with bitmap. We'd better defer reply after the raid is fu=
lly
>>>> initialized. Song, any idea?
>>>>=20
>>>=20
>>> With write back cache, there are two different types of stripes in reco=
very:
>>> data-parity, and data-only. For data-parity stripes, we can simply repl=
ay data
>>> from the journal. But for data-only stripes, we need to do rcw or rmw t=
o update
>>> parities. Currently, the writes are handled with raid5 state machine. T=
herefore,
>>> we wake up mddev->thread in r5l_recovery_log(). It is necessary to fini=
sh these=20
>>> stripes before we fully initialize the array, because these stripes nee=
d to be=20
>>> handled with write back state machine; while we we always start the arr=
ay with=20
>>> write through journal_mode.=20
>>>=20
>>> Maybe we can fix this by change the order of initialization in md_run()=
,=20
>>> specifically, moving bitmap_create() before pers->run().=20
>>=20
>> I've looked at some of the details here now.
>>=20
>> I think I would like raid5-cache to not perform any recovery until we
>> reach
>>=20
>>=20
>> 	md_wakeup_thread(mddev->thread);
>> 	md_wakeup_thread(mddev->sync_thread); /* possibly kick off a reshape */
>>=20
>>=20
>> in do_md_run().  Before that point it is possible to fail and abort -
>> e.g. if bitmap_load() fails.
>>=20
>> Possibly we could insert another personality call here "->start()" ??
>> That could then do whatever is needed before
>>=20
>> 	set_capacity(mddev->gendisk, mddev->array_sectors);
>> 	revalidate_disk(mddev->gendisk);
>>=20
>> makes the array accessible.
>>=20
>> Might that be reasonable?
>=20
> Looks good. I think we should call the ->start before
> md_wakeup_thread(mddev->thread); because we don't want to start recovery =
before
> log is recovered.

I also like this idea. In the coming month, I won't have much bandwidth to=
=20
implement this. Please let me know if you want to make the change. Otherwis=
e,=20
I will do it later (in December, I guess).=20

Thanks,
Song






