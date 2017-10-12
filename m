From: Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH] md/bitmap: avoid read out of the disk
Date: Thu, 12 Oct 2017 17:53:09 +0000
Message-ID: <ED3BAA5A-9A7B-4FA1-BC4E-299F1A69D9E7@fb.com>
References: <a9a406f5f751d39620d5e4907992ccb1bdbfb5a7.1507670143.git.shli@fb.com>
 <87bmldnjtq.fsf@notabene.neil.brown.name>
 <20171012173019.c2bbfyz3hgudjbhz@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20171012173019.c2bbfyz3hgudjbhz@kernel.org>
Content-Language: en-US
Content-ID: <283F9D0301C63E4E834CF9CB5EF14A8D@namprd15.prod.outlook.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: NeilBrown <neilb@suse.com>, linux-raid <linux-raid@vger.kernel.org>, "kumba@gentoo.org" <kumba@gentoo.org>, Shaohua Li <shli@fb.com>
List-Id: linux-raid.ids


> On Oct 12, 2017, at 10:30 AM, Shaohua Li <shli@kernel.org> wrote:
>=20
> On Thu, Oct 12, 2017 at 02:09:21PM +1100, Neil Brown wrote:
>> On Tue, Oct 10 2017, Shaohua Li wrote:
>>=20
>>> From: Shaohua Li <shli@fb.com>
>>>=20
>>> If PAGE_SIZE is bigger than 4k, we could read out of the disk boundary.=
 Limit
>>> the read size to the end of disk. Write path already has similar limita=
tion.
>>>=20
>>> Fix: 8031c3ddc70a(md/bitmap: copy correct data for bitmap super)
>>> Reported-by: Joshua Kinard <kumba@gentoo.org>
>>> Tested-by: Joshua Kinard <kumba@gentoo.org>
>>> Cc: Song Liu <songliubraving@fb.com>
>>> Signed-off-by: Shaohua Li <shli@fb.com>
>>=20
>> Given that this bug was introduced by
>> Commit: 8031c3ddc70a ("md/bitmap: copy correct data for bitmap super")
>>=20
>> and that patch is markted:
>>=20
>>    Cc: stable@vger.kernel.org (4.10+)
>>=20
>> I think this patch should be tagged "CC: stable" too.
>=20
> I thought the Fix tag is enough, but I'll add the stable=20
>> However ... that earlier patch looks strange to me.
>> Why is it that "raid5 cache could write bitmap superblock before bitmap =
superblock is
>> initialized."  Can we just get raid5 cache *not* to write the bitmap
>> superblock too early?
>> I think that would better than breaking code that previously worked.
>=20
> That's the log reply code, which must update superblock and hence bitmap
> superblock, because reply happens very earlier. I agree the reply might s=
till
> have problem with bitmap. We'd better defer reply after the raid is fully
> initialized. Song, any idea?
>=20

With write back cache, there are two different types of stripes in recovery=
:
data-parity, and data-only. For data-parity stripes, we can simply replay d=
ata
from the journal. But for data-only stripes, we need to do rcw or rmw to up=
date
parities. Currently, the writes are handled with raid5 state machine. There=
fore,
we wake up mddev->thread in r5l_recovery_log(). It is necessary to finish t=
hese=20
stripes before we fully initialize the array, because these stripes need to=
 be=20
handled with write back state machine; while we we always start the array w=
ith=20
write through journal_mode.=20

Maybe we can fix this by change the order of initialization in md_run(),=20
specifically, moving bitmap_create() before pers->run().=20

Thanks,
Song





