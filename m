From: Jinpu Wang <jinpu.wang@profitbricks.com>
Subject: Re: [BUG] MD/RAID1 hung forever on freeze_array
Date: Thu, 15 Dec 2016 10:24:49 +0100
Message-ID: <CAMGffEn6Ao2eY7+5N0CDk0QpsLOvgZ8sUKq2xk6sW4QkOQVqfw@mail.gmail.com>
References: <CAMGffE=1kp7gMhG+dFxTvhD6VkRuSfbuXbf9vYSWwGG+=vvhDA@mail.gmail.com>
 <87a8c20xpg.fsf@notabene.neil.brown.name> <CAMGffEkQ5puQEE0FVfLMV1of1OYOhLMhHdUTAy-YLYPkzBzjDg@mail.gmail.com>
 <87oa0gzuej.fsf@notabene.neil.brown.name> <CAMGffEm4BDhKJSiDt=2WmxrpRutg862at7JP221gMi6_SpPomQ@mail.gmail.com>
 <877f73zd5d.fsf@notabene.neil.brown.name> <CAMGffEnCesgUp4gBsPN2L9qg3WSxNXsCcYEPWH-BaeEEktaqcw@mail.gmail.com>
 <CAMGffE=KoVdoYRzkHdRMuCopjmUdcrP9-woFFr-4-VszGsSHRQ@mail.gmail.com>
 <CAMGffEnvn4YQ5ADFXrOm2vOeEwApo38V84wB7VF3D1eZihF-Zw@mail.gmail.com> <87fulpyj33.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87fulpyj33.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org, Shaohua Li <shli@fb.com>, Nate Dailey <nate.dailey@stratus.com>
List-Id: linux-raid.ids

On Thu, Dec 15, 2016 at 4:20 AM, NeilBrown <neilb@suse.com> wrote:
>
>> Hi Neil,
>>
>> I found a old mail thread below
>> http://www.spinics.net/lists/raid/msg52792.html
>>
>> Likely Alex is trying to fix same bug, right?
>> in one reply you suggested to modify the call in make_request
>>
>> @@ -1207,7 +1207,8 @@ read_again:
>>                                 sectors_handled;
>>                         goto read_again;
>>                 } else
>> -                       generic_make_request(read_bio);
>> +                       reschedule_retry(r1_bio);
>>                 return;
>>         }
>>
>>
>> I append above change, it looks fix the bug, I've run same tests over
>> one hour,  no hung task anymore.
>>
>> Do you think this is right fix? Do we still need the change you
>> suggested with punt_bios_to_rescuer?
>
> I don't really like that fix.  I suspect it would probably hurt
> performance.
>
> I'd prefer to fix generic_make_request() to process queued requests in a
> more sensible order.
> Can you please try the following (with all other patches removed)?
> Thanks,
> NeilBrown

Thanks Neil, I will try when back to office, I'm sick at home.
>
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 14d7c0740dc0..3436b6fc3ef8 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -2036,10 +2036,31 @@ blk_qc_t generic_make_request(struct bio *bio)
>                 struct request_queue *q =3D bdev_get_queue(bio->bi_bdev);
>
>                 if (likely(blk_queue_enter(q, false) =3D=3D 0)) {
> +                       struct bio_list hold;
> +                       struct bio_list lower, same;
> +
> +                       /* Create a fresh bio_list for all subordinate re=
quests */
> +                       bio_list_merge(&hold, &bio_list_on_stack);
> +                       bio_list_init(&bio_list_on_stack);
>                         ret =3D q->make_request_fn(q, bio);
>
>                         blk_queue_exit(q);
>
> +                       /* sort new bios into those for a lower level
> +                        * and those for the same level
> +                        */
> +                       bio_list_init(&lower);
> +                       bio_list_init(&same);
> +                       while ((bio =3D bio_list_pop(&bio_list_on_stack))=
 !=3D NULL)
> +                               if (q =3D=3D bdev_get_queue(bio->bi_bdev)=
)
> +                                       bio_list_add(&same, bio);
> +                               else
> +                                       bio_list_add(&lower, bio);
> +                       /* now assemble so we handle the lowest level fir=
st */
> +                       bio_list_merge(&bio_list_on_stack, &lower);
> +                       bio_list_merge(&bio_list_on_stack, &same);
> +                       bio_list_merge(&bio_list_on_stack, &hold);
> +
>                         bio =3D bio_list_pop(current->bio_list);
>                 } else {
>                         struct bio *bio_next =3D bio_list_pop(current->bi=
o_list);



--=20
Jinpu Wang
Linux Kernel Developer

ProfitBricks GmbH
Greifswalder Str. 207
D - 10405 Berlin

Tel:       +49 30 577 008  042
Fax:      +49 30 577 008 299
Email:    jinpu.wang@profitbricks.com
URL:      https://www.profitbricks.de

Sitz der Gesellschaft: Berlin
Registergericht: Amtsgericht Charlottenburg, HRB 125506 B
Gesch=C3=A4ftsf=C3=BChrer: Achim Weiss
