From: Jinpu Wang <jinpu.wang@profitbricks.com>
Subject: Re: [BUG] MD/RAID1 hung forever on freeze_array
Date: Mon, 19 Dec 2016 15:56:06 +0100
Message-ID: <CAMGffEkgo5pd-wZ1M9_TXcxjFbUQA3b_gpTgbEoDErLXCucsjg@mail.gmail.com>
References: <CAMGffE=1kp7gMhG+dFxTvhD6VkRuSfbuXbf9vYSWwGG+=vvhDA@mail.gmail.com>
 <87a8c20xpg.fsf@notabene.neil.brown.name> <CAMGffEkQ5puQEE0FVfLMV1of1OYOhLMhHdUTAy-YLYPkzBzjDg@mail.gmail.com>
 <87oa0gzuej.fsf@notabene.neil.brown.name> <CAMGffEm4BDhKJSiDt=2WmxrpRutg862at7JP221gMi6_SpPomQ@mail.gmail.com>
 <877f73zd5d.fsf@notabene.neil.brown.name> <CAMGffEnCesgUp4gBsPN2L9qg3WSxNXsCcYEPWH-BaeEEktaqcw@mail.gmail.com>
 <CAMGffE=KoVdoYRzkHdRMuCopjmUdcrP9-woFFr-4-VszGsSHRQ@mail.gmail.com>
 <CAMGffEnvn4YQ5ADFXrOm2vOeEwApo38V84wB7VF3D1eZihF-Zw@mail.gmail.com>
 <87fulpyj33.fsf@notabene.neil.brown.name> <CAMGffEkufeaDytaHxtLR02iiQifZDhcwkLdzMj3X8_yaitSoFQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAMGffEkufeaDytaHxtLR02iiQifZDhcwkLdzMj3X8_yaitSoFQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org, Shaohua Li <shli@fb.com>, Nate Dailey <nate.dailey@stratus.com>
List-Id: linux-raid.ids

On Mon, Dec 19, 2016 at 12:16 PM, Jinpu Wang
<jinpu.wang@profitbricks.com> wrote:
> Hi Neil,
>
> After apply the patch below, it paniced during boot in
> generic_make_request-> bio_list_pop.
> Looks related to you do bio_list_init(&bio_list_on_stack); again.
>> diff --git a/block/blk-core.c b/block/blk-core.c
>> index 14d7c0740dc0..3436b6fc3ef8 100644
>> --- a/block/blk-core.c
>> +++ b/block/blk-core.c
>> @@ -2036,10 +2036,31 @@ blk_qc_t generic_make_request(struct bio *bio)
>>                 struct request_queue *q =3D bdev_get_queue(bio->bi_bdev)=
;
>>
>>                 if (likely(blk_queue_enter(q, false) =3D=3D 0)) {
>> +                       struct bio_list hold;
>> +                       struct bio_list lower, same;
>> +
>> +                       /* Create a fresh bio_list for all subordinate r=
equests */
>> +                       bio_list_merge(&hold, &bio_list_on_stack);
>> +                       bio_list_init(&bio_list_on_stack); ??? maybe ini=
t hold, and then merge bio_list_on_stack?
>>                         ret =3D q->make_request_fn(q, bio);
>>
>>                         blk_queue_exit(q);
>>
>> +                       /* sort new bios into those for a lower level
>> +                        * and those for the same level
>> +                        */
>> +                       bio_list_init(&lower);
>> +                       bio_list_init(&same);
>> +                       while ((bio =3D bio_list_pop(&bio_list_on_stack)=
) !=3D NULL)
>> +                               if (q =3D=3D bdev_get_queue(bio->bi_bdev=
))
>> +                                       bio_list_add(&same, bio);
>> +                               else
>> +                                       bio_list_add(&lower, bio);
>> +                       /* now assemble so we handle the lowest level fi=
rst */
>> +                       bio_list_merge(&bio_list_on_stack, &lower);
>> +                       bio_list_merge(&bio_list_on_stack, &same);
>> +                       bio_list_merge(&bio_list_on_stack, &hold);
>> +
>>                         bio =3D bio_list_pop(current->bio_list);
>>                 } else {
>>                         struct bio *bio_next =3D bio_list_pop(current->b=
io_list);
>
>
Seems we don't need bio_list hold at all, lower and seem merge back to
bio_list_on_stack?
I'm currently testing patch below, so far so good.

diff --git a/block/blk-core.c b/block/blk-core.c
index e8d15d8..9c56cf7 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2064,10 +2064,24 @@ blk_qc_t generic_make_request(struct bio *bio)
                struct request_queue *q =3D bdev_get_queue(bio->bi_bdev);

                if (likely(blk_queue_enter(q, __GFP_DIRECT_RECLAIM) =3D=3D =
0)) {
+                       struct bio_list lower, same;

                        ret =3D q->make_request_fn(q, bio);

                        blk_queue_exit(q);
+                       /* sort new bios into those for a lower level
+                        * and those for the same level
+                        */
+                       bio_list_init(&lower);
+                       bio_list_init(&same);
+                       while ((bio =3D bio_list_pop(&bio_list_on_stack)) !=
=3D NULL)
+                               if (q =3D=3D bdev_get_queue(bio->bi_bdev))
+                                       bio_list_add(&same, bio);
+                               else
+                                       bio_list_add(&lower, bio);
+                       /* now assemble so we handle the lowest level first=
 */
+                       bio_list_merge(&bio_list_on_stack, &lower);
+                       bio_list_merge(&bio_list_on_stack, &same);

                        bio =3D bio_list_pop(current->bio_list);
                } else {

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
