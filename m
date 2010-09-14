From: Mike Hartman <mike@hartmanipulation.com>
Subject: Re: New RAID causing system lockups
Date: Mon, 13 Sep 2010 22:50:10 -0400
Message-ID: <AANLkTimeeecqZX1Bn23=_41sBYO+P8h_b5Z6Gf_ACuA1@mail.gmail.com>
References: <AANLkTimTvPupaPuFbfpcCGC=0Ys9fQWihAgaADsrowqq@mail.gmail.com>
	<20100912064308.46d96742@notabene>
	<AANLkTikWY1QE_2HBADkVV1u1OSCktVT=ShQrCdNWBF8n@mail.gmail.com>
	<AANLkTimzmoyq_KHA1Q3JgEJSj2iuwYwiHRNR=_ZuLQCZ@mail.gmail.com>
	<AANLkTiknrUVCToYg8NM0dUX9kXVE_kTAwtuAqo09X-qj@mail.gmail.com>
	<20100914095111.6e3045c7@notabene>
	<AANLkTin=jy=xJTtN5mQ6U=rYw3p+_4-nmkhO7zqR0KLP@mail.gmail.com>
	<AANLkTimyEr9LnS2BOR+rXhwfU0rCE-MmYcjttaTyqAWT@mail.gmail.com>
	<20100914113516.63c883c4@notabene>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100914113516.63c883c4@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>
>> > Hi Mike,
>> > =A0thanks for the updates.
>> >
>> > I'm not entirely clear what is happening (in fact, due to a cold t=
hat I am
>> > still fighting off, nothing is entirely clear at the moment), but =
it looks
>> > very likely that the problem is due to an interplay between barrie=
r handling,
>> > and the multi-level structure of your array (a raid0 being a membe=
r of a
>> > raid5).
>> >
>> > When a barrier request is processed, both arrays will schedule 'wo=
rk' to be
>> > done by the 'event' thread and I'm guess that you can get into a s=
ituation
>> > where one work time is wait for the other, but the other is behind=
 the one on
>> > the single queue (I wonder if that make sense...)
>> >
>> > Anyway, this patch might make a difference, =A0It reduced the numb=
er of work
>> > items schedule in a way that could conceivably fix the problem.
>> >
>> > If you can test this, please report the results. =A0I cannot easil=
y reproduce
>> > the problem so there is limited testing that I can do.
>> >
>> > Thanks,
>> > NeilBrown
>> >
>> >
>> > diff --git a/drivers/md/md.c b/drivers/md/md.c
>> > index f20d13e..7f2785c 100644
>> > --- a/drivers/md/md.c
>> > +++ b/drivers/md/md.c
>> > @@ -294,6 +294,23 @@ EXPORT_SYMBOL(mddev_congested);
>> >
>> > =A0#define POST_REQUEST_BARRIER ((void*)1)
>> >
>> > +static void md_barrier_done(mddev_t *mddev)
>> > +{
>> > + =A0 =A0 =A0 struct bio *bio =3D mddev->barrier;
>> > +
>> > + =A0 =A0 =A0 if (test_bit(BIO_EOPNOTSUPP, &bio->bi_flags))
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 bio_endio(bio, -EOPNOTSUPP);
>> > + =A0 =A0 =A0 else if (bio->bi_size =3D=3D 0)
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 bio_endio(bio, 0);
>> > + =A0 =A0 =A0 else {
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* other options need to be handled =
from process context */
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 schedule_work(&mddev->barrier_work);
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return;
>> > + =A0 =A0 =A0 }
>> > + =A0 =A0 =A0 mddev->barrier =3D NULL;
>> > + =A0 =A0 =A0 wake_up(&mddev->sb_wait);
>> > +}
>> > +
>> > =A0static void md_end_barrier(struct bio *bio, int err)
>> > =A0{
>> > =A0 =A0 =A0 =A0mdk_rdev_t *rdev =3D bio->bi_private;
>> > @@ -310,7 +327,7 @@ static void md_end_barrier(struct bio *bio, in=
t err)
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0wake_up(&mddev->sb_=
wait);
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0} else
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* The pre-request =
barrier has finished */
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 schedule_work(&mddev=
->barrier_work);
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 md_barrier_done(mdde=
v);
>> > =A0 =A0 =A0 =A0}
>> > =A0 =A0 =A0 =A0bio_put(bio);
>> > =A0}
>> > @@ -350,18 +367,12 @@ static void md_submit_barrier(struct work_st=
ruct *ws)
>> >
>> > =A0 =A0 =A0 =A0atomic_set(&mddev->flush_pending, 1);
>> >
>> > - =A0 =A0 =A0 if (test_bit(BIO_EOPNOTSUPP, &bio->bi_flags))
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 bio_endio(bio, -EOPNOTSUPP);
>> > - =A0 =A0 =A0 else if (bio->bi_size =3D=3D 0)
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* an empty barrier - all done */
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 bio_endio(bio, 0);
>> > - =A0 =A0 =A0 else {
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 bio->bi_rw &=3D ~REQ_HARDBARRIER;
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (mddev->pers->make_request(mddev,=
 bio))
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 generic_make_request=
(bio);
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 mddev->barrier =3D POST_REQUEST_BARR=
IER;
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 submit_barriers(mddev);
>> > - =A0 =A0 =A0 }
>> > + =A0 =A0 =A0 bio->bi_rw &=3D ~REQ_HARDBARRIER;
>> > + =A0 =A0 =A0 if (mddev->pers->make_request(mddev, bio))
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 generic_make_request(bio);
>> > + =A0 =A0 =A0 mddev->barrier =3D POST_REQUEST_BARRIER;
>> > + =A0 =A0 =A0 submit_barriers(mddev);
>> > +
>> > =A0 =A0 =A0 =A0if (atomic_dec_and_test(&mddev->flush_pending)) {
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mddev->barrier =3D NULL;
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0wake_up(&mddev->sb_wait);
>> > @@ -383,7 +394,7 @@ void md_barrier_request(mddev_t *mddev, struct=
 bio *bio)
>> > =A0 =A0 =A0 =A0submit_barriers(mddev);
>> >
>> > =A0 =A0 =A0 =A0if (atomic_dec_and_test(&mddev->flush_pending))
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 schedule_work(&mddev->barrier_work);
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 md_barrier_done(mddev);
>> > =A0}
>> > =A0EXPORT_SYMBOL(md_barrier_request);
>> >
>> >
>> >
>>
>> Neil, thanks for the patch. I experienced the lockup for the 5th tim=
e
>> an hour ago (about 3 hours after the last hard reboot) so I thought =
it
>> would be a good time to try your patch. Unfortunately I'm getting an
>> error:
>>
>> patching file drivers/md/md.c
>> Hunk #1 succeeded at 291 with fuzz 1 (offset -3 lines).
>> Hunk #2 FAILED at 324.
>> Hunk #3 FAILED at 364.
>> Hunk #4 FAILED at 391.
>> 3 out of 4 hunks FAILED -- saving rejects to file drivers/md/md.c.re=
j
>
> That is odd.
> I took the md.c that you posted on the web site, use "patch" to apply=
 my
> patch to it, and only Hunk #3 failed.
>
> I used 'wiggle' to apply the patch and it applied perfectly, properly
> replacing (1<<BIO_RW_BARRIER) with REQ_HARDBARRIER (or the other way =
around).
>
> Try this version. =A0You will need to be in drivers/md/, or use
>
> =A0patch drivers/md/md.c < this-patch
>
>
> NeilBrown
>
> --- md.c.orig =A0 2010-09-14 11:29:15.000000000 +1000
> +++ md.c =A0 =A0 =A0 =A02010-09-14 11:29:50.000000000 +1000
> @@ -291,6 +291,23 @@
>
> =A0#define POST_REQUEST_BARRIER ((void*)1)
>
> +static void md_barrier_done(mddev_t *mddev)
> +{
> + =A0 =A0 =A0 struct bio *bio =3D mddev->barrier;
> +
> + =A0 =A0 =A0 if (test_bit(BIO_EOPNOTSUPP, &bio->bi_flags))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 bio_endio(bio, -EOPNOTSUPP);
> + =A0 =A0 =A0 else if (bio->bi_size =3D=3D 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 bio_endio(bio, 0);
> + =A0 =A0 =A0 else {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* other options need to be handled fro=
m process context */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 schedule_work(&mddev->barrier_work);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 mddev->barrier =3D NULL;
> + =A0 =A0 =A0 wake_up(&mddev->sb_wait);
> +}
> +
> =A0static void md_end_barrier(struct bio *bio, int err)
> =A0{
> =A0 =A0 =A0 =A0mdk_rdev_t *rdev =3D bio->bi_private;
> @@ -307,7 +324,7 @@
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0wake_up(&mddev->sb_wai=
t);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0} else
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* The pre-request bar=
rier has finished */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 schedule_work(&mddev->b=
arrier_work);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 md_barrier_done(mddev);
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0bio_put(bio);
> =A0}
> @@ -347,18 +364,12 @@
>
> =A0 =A0 =A0 =A0atomic_set(&mddev->flush_pending, 1);
>
> - =A0 =A0 =A0 if (test_bit(BIO_EOPNOTSUPP, &bio->bi_flags))
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 bio_endio(bio, -EOPNOTSUPP);
> - =A0 =A0 =A0 else if (bio->bi_size =3D=3D 0)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* an empty barrier - all done */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 bio_endio(bio, 0);
> - =A0 =A0 =A0 else {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 bio->bi_rw &=3D ~(1<<BIO_RW_BARRIER);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (mddev->pers->make_request(mddev, bi=
o))
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 generic_make_request(bi=
o);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 mddev->barrier =3D POST_REQUEST_BARRIER=
;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 submit_barriers(mddev);
> - =A0 =A0 =A0 }
> + =A0 =A0 =A0 bio->bi_rw &=3D ~(1<<BIO_RW_BARRIER);
> + =A0 =A0 =A0 if (mddev->pers->make_request(mddev, bio))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 generic_make_request(bio);
> + =A0 =A0 =A0 mddev->barrier =3D POST_REQUEST_BARRIER;
> + =A0 =A0 =A0 submit_barriers(mddev);
> +
> =A0 =A0 =A0 =A0if (atomic_dec_and_test(&mddev->flush_pending)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mddev->barrier =3D NULL;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0wake_up(&mddev->sb_wait);
> @@ -380,7 +391,7 @@
> =A0 =A0 =A0 =A0submit_barriers(mddev);
>
> =A0 =A0 =A0 =A0if (atomic_dec_and_test(&mddev->flush_pending))
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 schedule_work(&mddev->barrier_work);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 md_barrier_done(mddev);
> =A0}
> =A0EXPORT_SYMBOL(md_barrier_request);
>
>

Sorry about that Neil, it was my fault. I copied your patch out of the
email and I think it picked up some unintended characters. I tried
copying it from the mailing list archive website instead and it
patched in fine. The kernel compiled with no trouble and I'm booted
into it now. No unexpected side-effects yet. I'll continue with my
copying and we'll see if it locks up again. Thanks for all your help!

Mike
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
