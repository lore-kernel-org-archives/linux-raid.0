From: Konstantin Khlebnikov <koct9i@gmail.com>
Subject: Re: [PATCH] md/raid5: limit request size according to implementation limits
Date: Mon, 28 Nov 2016 09:06:45 +0300
Message-ID: <CALYGNiN9ChdiEAwGGMC8=QumDSE+ypcSH9OLLTL8SVYDuG5vWw@mail.gmail.com>
References: <148026435214.19980.7956943898609877817.stgit@buzz> <e4f231db-6e4b-3d7f-e7a0-362dc4441823@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <e4f231db-6e4b-3d7f-e7a0-362dc4441823@suse.de>
Sender: stable-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Shaohua Li <shli@kernel.org>, Neil Brown <neilb@suse.com>, linux-raid@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Stable <stable@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Nov 28, 2016 at 7:40 AM, Coly Li <colyli@suse.de> wrote:
> On 2016/11/28 =E4=B8=8A=E5=8D=8812:32, Konstantin Khlebnikov wrote:
>> Current implementation employ 16bit counter of active stripes in lower
>> bits of bio->bi_phys_segments. If request is big enough to overflow
>> this counter bio will be completed and freed too early.
>>
>> Fortunately this not happens in default configuration because several
>> other limits prevent that: stripe_cache_size * nr_disks effectively
>> limits count of active stripes. And small max_sectors_kb at lower
>> disks prevent that during normal read/write operations.
>>
>> Overflow easily happens in discard if it's enabled by module parameter
>> "devices_handle_discard_safely" and stripe_cache_size is set big enough.
>>
>> This patch limits requests size with 256Mb - 8Kb to prevent overflows.
>>
>> Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
>> Cc: Shaohua Li <shli@kernel.org>
>> Cc: Neil Brown <neilb@suse.com>
>> Cc: stable@vger.kernel.org
>> ---
>>  drivers/md/raid5.c |    9 +++++++++
>>  1 file changed, 9 insertions(+)
>>
>> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
>> index 92ac251e91e6..cce6057b9aca 100644
>> --- a/drivers/md/raid5.c
>> +++ b/drivers/md/raid5.c
>> @@ -6984,6 +6984,15 @@ static int raid5_run(struct mddev *mddev)
>>                       stripe =3D (stripe | (stripe-1)) + 1;
>>               mddev->queue->limits.discard_alignment =3D stripe;
>>               mddev->queue->limits.discard_granularity =3D stripe;
>> +
>> +             /*
>> +              * We use 16-bit counter of active stripes in bi_phys_segm=
ents
>> +              * (minus one for over-loaded initialization)
>> +              */
>> +             blk_queue_max_hw_sectors(mddev->queue, 0xfffe * STRIPE_SEC=
TORS);
>> +             blk_queue_max_discard_sectors(mddev->queue,
>> +                                           0xfffe * STRIPE_SECTORS);
>> +
>
> Could you please to explain why use 0xfffe * STRIPE_SECTORS here ?

This code send individual bio to lower device for each STRIPE_SECTORS (8)
and count them in 16-bit counter 0xffff max (you could find this
constant above in this file)
but counter initialized with 1 to prevent hitting zero during generation
thus maximum is 0xfffe stripes which is 256Mb - 8Kb in bytes

>
> Thanks.
>
> Coly
>
