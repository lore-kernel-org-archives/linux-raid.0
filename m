From: =?ISO-8859-1?Q?Patrik_Horn=EDk?= <patrik@dsl.sk>
Subject: Re: Sequential writing to degraded RAID6 causing a lot of reading
Date: Tue, 20 May 2014 12:07:11 +0200
Message-ID: <CAAOsTSkzZM7Pf8k=JU=6uWKUqsq7M44FLC=fM_GVB8KD+z7qqA@mail.gmail.com>
References: <CAAOsTSmnbtejYvjoMpdOzrGFM0+PW45uuf-uBNkR4HUkgyaWDg@mail.gmail.com>
	<20120524144822.747b446b@notabene.brown>
	<CAAOsTSm47hy6YF-5fodB+2G6n1E=+Ces_PWsSo7F6GKEF_R1iA@mail.gmail.com>
	<20120528113145.1b8ac4ab@notabene.brown>
	<CAAOsTSmvGOwhmFW4PRfkmVnSApNKrsZfa6RAbjEhwQh-+ko1vQ@mail.gmail.com>
	<20140515171853.4cdfddd0@notabene.brown>
	<CAAOsTSnk+_HfrHK2WVjDVXiNjB2PTzp+8L6a5McJ80TzE=KOyg@mail.gmail.com>
	<20140520154209.0313429c@notabene.brown>
Reply-To: patrik@dsl.sk
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140520154209.0313429c@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2014-05-20 7:42 GMT+02:00 NeilBrown <neilb@suse.de>:
> On Thu, 15 May 2014 09:50:49 +0200 Patrik Horn=EDk <patrik@dsl.sk> wr=
ote:
>
>> OK, it seems that because of that my copy operations will not be
>> finished yet by next week... :)
>>
>> BTW this time layout is left-symetric but the problem I guess is in
>> whole strip' write detection with degraded RAID6.
>>
>> Patrik
>>
>> 2014-05-15 9:18 GMT+02:00 NeilBrown <neilb@suse.de>:
>> > On Thu, 15 May 2014 09:04:27 +0200 Patrik Horn=EDk <patrik@dsl.sk>=
 wrote:
>> >
>> >> Hello Neil,
>> >>
>> >> did you make some progress on this issue by any chance?
>> >
>> > No I haven't - sorry.
>> > After 2 year, I guess I really should.
>> >
>> > I'll make another note for first thing next week.
>
> Can you try the following patch and let me know if it helps?

I dont want to test it on production system... But I have some
degraded array which does not have production data on it so I will
think about how to test it.

> I definitely reduced the number of reads significantly, but my measur=
ements
> (of a very simple test case) didn't show much speed-up.
>

I did not look at the patch itself but according to your description
is should eliminate the problem, should it not? What was your read /
write ratio after the patch?

Thanks.

Patrik

> This is against current mainline.  If you want it against another ver=
sion and
> it doesn't apply easily, just ask.
>
> Thanks,
> NeilBrown
>
> From 98c411f93391be0dbda98d43835dd9e042faa78f Mon Sep 17 00:00:00 200=
1
> From: NeilBrown <neilb@suse.de>
> Date: Mon, 19 May 2014 11:16:49 +1000
> Subject: [PATCH] md/raid56: Don't perform reads to support writes unt=
il stripe
>  is ready.
> MIME-Version: 1.0
> Content-Type: text/plain; charset=3DUTF-8
> Content-Transfer-Encoding: 8bit
>
> If it is found that we need to pre-read some blocks before a write
> can succeed, we normally set STRIPE_DELAYED and don't actually perfor=
m
> the read until STRIPE_PREREAD_ACTIVE subsequently gets set.
>
> However for a degraded RAID6 we currently perform the reads as soon
> as we see that a write is pending.  This significantly hurts
> throughput.
>
> So:
>  - when handle_stripe_dirtying find a block that it wants on a device
>    that is failed, set STRIPE_DELAY, instead of doing nothing, and
>  - when fetch_block detects that a read might be required to satisfy =
a
>    write, only perform the read if STRIPE_PREREAD_ACTIVE is set,
>    and if we would actually need to read something to complete the wr=
ite.
>
> This also helps RAID5, though less often as RAID5 supports a
> read-modify-write cycle.  For RAID5 the read is performed too early
> only if the write is not a full 4K aligned write (i.e. no an
> R5_OVERWRITE).
>
> Also clean up a couple of horrible bits of formatting.
>
> Reported-by: Patrik Horn=EDk <patrik@dsl.sk>
> Signed-off-by: NeilBrown <neilb@suse.de>
>
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 633e20a96b34..d67202bd9118 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -292,9 +292,12 @@ static void do_release_stripe(struct r5conf *con=
f, struct stripe_head *sh,
>         BUG_ON(atomic_read(&conf->active_stripes)=3D=3D0);
>         if (test_bit(STRIPE_HANDLE, &sh->state)) {
>                 if (test_bit(STRIPE_DELAYED, &sh->state) &&
> -                   !test_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
> +                   !test_bit(STRIPE_PREREAD_ACTIVE, &sh->state)) {
>                         list_add_tail(&sh->lru, &conf->delayed_list);
> -               else if (test_bit(STRIPE_BIT_DELAY, &sh->state) &&
> +                       if (atomic_read(&conf->preread_active_stripes=
)
> +                           < IO_THRESHOLD)
> +                               md_wakeup_thread(conf->mddev->thread)=
;
> +               } else if (test_bit(STRIPE_BIT_DELAY, &sh->state) &&
>                            sh->bm_seq - conf->seq_write > 0)
>                         list_add_tail(&sh->lru, &conf->bitmap_list);
>                 else {
> @@ -2908,8 +2911,11 @@ static int fetch_block(struct stripe_head *sh,=
 struct stripe_head_state *s,
>              (s->failed >=3D 1 && fdev[0]->toread) ||
>              (s->failed >=3D 2 && fdev[1]->toread) ||
>              (sh->raid_conf->level <=3D 5 && s->failed && fdev[0]->to=
write &&
> +             (!test_bit(R5_Insync, &dev->flags) || test_bit(STRIPE_P=
REREAD_ACTIVE, &sh->state)) &&
>               !test_bit(R5_OVERWRITE, &fdev[0]->flags)) ||
> -            (sh->raid_conf->level =3D=3D 6 && s->failed && s->to_wri=
te))) {
> +            (sh->raid_conf->level =3D=3D 6 && s->failed && s->to_wri=
te &&
> +             s->towrite < sh->raid_conf->raid_disks - 2 &&
> +             (!test_bit(R5_Insync, &dev->flags) || test_bit(STRIPE_P=
REREAD_ACTIVE, &sh->state))))) {
>                 /* we would like to get this block, possibly by compu=
ting it,
>                  * otherwise read it if the backing disk is insync
>                  */
> @@ -3115,7 +3121,8 @@ static void handle_stripe_dirtying(struct r5con=
f *conf,
>                     !test_bit(R5_LOCKED, &dev->flags) &&
>                     !(test_bit(R5_UPTODATE, &dev->flags) ||
>                     test_bit(R5_Wantcompute, &dev->flags))) {
> -                       if (test_bit(R5_Insync, &dev->flags)) rcw++;
> +                       if (test_bit(R5_Insync, &dev->flags))
> +                               rcw++;
>                         else
>                                 rcw +=3D 2*disks;
>                 }
> @@ -3136,10 +3143,10 @@ static void handle_stripe_dirtying(struct r5c=
onf *conf,
>                             !(test_bit(R5_UPTODATE, &dev->flags) ||
>                             test_bit(R5_Wantcompute, &dev->flags)) &&
>                             test_bit(R5_Insync, &dev->flags)) {
> -                               if (
> -                                 test_bit(STRIPE_PREREAD_ACTIVE, &sh=
->state)) {
> -                                       pr_debug("Read_old block "
> -                                                "%d for r-m-w\n", i)=
;
> +                               if (test_bit(STRIPE_PREREAD_ACTIVE,
> +                                            &sh->state)) {
> +                                       pr_debug("Read_old block %d f=
or r-m-w\n",
> +                                                i);
>                                         set_bit(R5_LOCKED, &dev->flag=
s);
>                                         set_bit(R5_Wantread, &dev->fl=
ags);
>                                         s->locked++;
> @@ -3162,10 +3169,9 @@ static void handle_stripe_dirtying(struct r5co=
nf *conf,
>                             !(test_bit(R5_UPTODATE, &dev->flags) ||
>                               test_bit(R5_Wantcompute, &dev->flags)))=
 {
>                                 rcw++;
> -                               if (!test_bit(R5_Insync, &dev->flags)=
)
> -                                       continue; /* it's a failed dr=
ive */
> -                               if (
> -                                 test_bit(STRIPE_PREREAD_ACTIVE, &sh=
->state)) {
> +                               if (test_bit(R5_Insync, &dev->flags) =
&&
> +                                   test_bit(STRIPE_PREREAD_ACTIVE,
> +                                            &sh->state)) {
>                                         pr_debug("Read_old block "
>                                                 "%d for Reconstruct\n=
", i);
>                                         set_bit(R5_LOCKED, &dev->flag=
s);
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
