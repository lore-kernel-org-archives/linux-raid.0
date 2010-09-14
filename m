From: Neil Brown <neilb@suse.de>
Subject: Re: New RAID causing system lockups
Date: Tue, 14 Sep 2010 11:35:16 +1000
Message-ID: <20100914113516.63c883c4@notabene>
References: <AANLkTimTvPupaPuFbfpcCGC=0Ys9fQWihAgaADsrowqq@mail.gmail.com>
	<20100912064308.46d96742@notabene>
	<AANLkTikWY1QE_2HBADkVV1u1OSCktVT=ShQrCdNWBF8n@mail.gmail.com>
	<AANLkTimzmoyq_KHA1Q3JgEJSj2iuwYwiHRNR=_ZuLQCZ@mail.gmail.com>
	<AANLkTiknrUVCToYg8NM0dUX9kXVE_kTAwtuAqo09X-qj@mail.gmail.com>
	<20100914095111.6e3045c7@notabene>
	<AANLkTin=jy=xJTtN5mQ6U=rYw3p+_4-nmkhO7zqR0KLP@mail.gmail.com>
	<AANLkTimyEr9LnS2BOR+rXhwfU0rCE-MmYcjttaTyqAWT@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTimyEr9LnS2BOR+rXhwfU0rCE-MmYcjttaTyqAWT@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Hartman <mike@hartmanipulation.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 13 Sep 2010 21:11:30 -0400
Mike Hartman <mike@hartmanipulation.com> wrote:

> Forgot to include the mailing list on this.
>=20
> > Hi Mike,
> > =C2=A0thanks for the updates.
> >
> > I'm not entirely clear what is happening (in fact, due to a cold th=
at I am
> > still fighting off, nothing is entirely clear at the moment), but i=
t looks
> > very likely that the problem is due to an interplay between barrier=
 handling,
> > and the multi-level structure of your array (a raid0 being a member=
 of a
> > raid5).
> >
> > When a barrier request is processed, both arrays will schedule 'wor=
k' to be
> > done by the 'event' thread and I'm guess that you can get into a si=
tuation
> > where one work time is wait for the other, but the other is behind =
the one on
> > the single queue (I wonder if that make sense...)
> >
> > Anyway, this patch might make a difference, =C2=A0It reduced the nu=
mber of work
> > items schedule in a way that could conceivably fix the problem.
> >
> > If you can test this, please report the results. =C2=A0I cannot eas=
ily reproduce
> > the problem so there is limited testing that I can do.
> >
> > Thanks,
> > NeilBrown
> >
> >
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > index f20d13e..7f2785c 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -294,6 +294,23 @@ EXPORT_SYMBOL(mddev_congested);
> >
> > =C2=A0#define POST_REQUEST_BARRIER ((void*)1)
> >
> > +static void md_barrier_done(mddev_t *mddev)
> > +{
> > + =C2=A0 =C2=A0 =C2=A0 struct bio *bio =3D mddev->barrier;
> > +
> > + =C2=A0 =C2=A0 =C2=A0 if (test_bit(BIO_EOPNOTSUPP, &bio->bi_flags)=
)
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 bio_endio(bio, -=
EOPNOTSUPP);
> > + =C2=A0 =C2=A0 =C2=A0 else if (bio->bi_size =3D=3D 0)
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 bio_endio(bio, 0=
);
> > + =C2=A0 =C2=A0 =C2=A0 else {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* other options=
 need to be handled from process context */
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 schedule_work(&m=
ddev->barrier_work);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return;
> > + =C2=A0 =C2=A0 =C2=A0 }
> > + =C2=A0 =C2=A0 =C2=A0 mddev->barrier =3D NULL;
> > + =C2=A0 =C2=A0 =C2=A0 wake_up(&mddev->sb_wait);
> > +}
> > +
> > =C2=A0static void md_end_barrier(struct bio *bio, int err)
> > =C2=A0{
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0mdk_rdev_t *rdev =3D bio->bi_private;
> > @@ -310,7 +327,7 @@ static void md_end_barrier(struct bio *bio, int=
 err)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0wake_up(&mddev->sb_wait);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0} else
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0/* The pre-request barrier has finished */
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 schedule_work(&mddev->barrier_work);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 md_barrier_done(mddev);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0bio_put(bio);
> > =C2=A0}
> > @@ -350,18 +367,12 @@ static void md_submit_barrier(struct work_str=
uct *ws)
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0atomic_set(&mddev->flush_pending, 1);
> >
> > - =C2=A0 =C2=A0 =C2=A0 if (test_bit(BIO_EOPNOTSUPP, &bio->bi_flags)=
)
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 bio_endio(bio, -=
EOPNOTSUPP);
> > - =C2=A0 =C2=A0 =C2=A0 else if (bio->bi_size =3D=3D 0)
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* an empty barr=
ier - all done */
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 bio_endio(bio, 0=
);
> > - =C2=A0 =C2=A0 =C2=A0 else {
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 bio->bi_rw &=3D =
~REQ_HARDBARRIER;
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (mddev->pers-=
>make_request(mddev, bio))
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 generic_make_request(bio);
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mddev->barrier =3D=
 POST_REQUEST_BARRIER;
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 submit_barriers(=
mddev);
> > - =C2=A0 =C2=A0 =C2=A0 }
> > + =C2=A0 =C2=A0 =C2=A0 bio->bi_rw &=3D ~REQ_HARDBARRIER;
> > + =C2=A0 =C2=A0 =C2=A0 if (mddev->pers->make_request(mddev, bio))
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 generic_make_req=
uest(bio);
> > + =C2=A0 =C2=A0 =C2=A0 mddev->barrier =3D POST_REQUEST_BARRIER;
> > + =C2=A0 =C2=A0 =C2=A0 submit_barriers(mddev);
> > +
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0if (atomic_dec_and_test(&mddev->flush_pe=
nding)) {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0mddev->barri=
er =3D NULL;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0wake_up(&mdd=
ev->sb_wait);
> > @@ -383,7 +394,7 @@ void md_barrier_request(mddev_t *mddev, struct =
bio *bio)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0submit_barriers(mddev);
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0if (atomic_dec_and_test(&mddev->flush_pe=
nding))
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 schedule_work(&m=
ddev->barrier_work);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 md_barrier_done(=
mddev);
> > =C2=A0}
> > =C2=A0EXPORT_SYMBOL(md_barrier_request);
> >
> >
> >
>=20
> Neil, thanks for the patch. I experienced the lockup for the 5th time
> an hour ago (about 3 hours after the last hard reboot) so I thought i=
t
> would be a good time to try your patch. Unfortunately I'm getting an
> error:
>=20
> patching file drivers/md/md.c
> Hunk #1 succeeded at 291 with fuzz 1 (offset -3 lines).
> Hunk #2 FAILED at 324.
> Hunk #3 FAILED at 364.
> Hunk #4 FAILED at 391.
> 3 out of 4 hunks FAILED -- saving rejects to file drivers/md/md.c.rej

That is odd.
I took the md.c that you posted on the web site, use "patch" to apply m=
y
patch to it, and only Hunk #3 failed.

I used 'wiggle' to apply the patch and it applied perfectly, properly
replacing (1<<BIO_RW_BARRIER) with REQ_HARDBARRIER (or the other way ar=
ound).

Try this version.  You will need to be in drivers/md/, or use

 patch drivers/md/md.c < this-patch


NeilBrown

--- md.c.orig	2010-09-14 11:29:15.000000000 +1000
+++ md.c	2010-09-14 11:29:50.000000000 +1000
@@ -291,6 +291,23 @@
=20
 #define POST_REQUEST_BARRIER ((void*)1)
=20
+static void md_barrier_done(mddev_t *mddev)
+{
+	struct bio *bio =3D mddev->barrier;
+
+	if (test_bit(BIO_EOPNOTSUPP, &bio->bi_flags))
+		bio_endio(bio, -EOPNOTSUPP);
+	else if (bio->bi_size =3D=3D 0)
+		bio_endio(bio, 0);
+	else {
+		/* other options need to be handled from process context */
+		schedule_work(&mddev->barrier_work);
+		return;
+	}
+	mddev->barrier =3D NULL;
+	wake_up(&mddev->sb_wait);
+}
+
 static void md_end_barrier(struct bio *bio, int err)
 {
 	mdk_rdev_t *rdev =3D bio->bi_private;
@@ -307,7 +324,7 @@
 			wake_up(&mddev->sb_wait);
 		} else
 			/* The pre-request barrier has finished */
-			schedule_work(&mddev->barrier_work);
+			md_barrier_done(mddev);
 	}
 	bio_put(bio);
 }
@@ -347,18 +364,12 @@
=20
 	atomic_set(&mddev->flush_pending, 1);
=20
-	if (test_bit(BIO_EOPNOTSUPP, &bio->bi_flags))
-		bio_endio(bio, -EOPNOTSUPP);
-	else if (bio->bi_size =3D=3D 0)
-		/* an empty barrier - all done */
-		bio_endio(bio, 0);
-	else {
-		bio->bi_rw &=3D ~(1<<BIO_RW_BARRIER);
-		if (mddev->pers->make_request(mddev, bio))
-			generic_make_request(bio);
-		mddev->barrier =3D POST_REQUEST_BARRIER;
-		submit_barriers(mddev);
-	}
+	bio->bi_rw &=3D ~(1<<BIO_RW_BARRIER);
+	if (mddev->pers->make_request(mddev, bio))
+		generic_make_request(bio);
+	mddev->barrier =3D POST_REQUEST_BARRIER;
+	submit_barriers(mddev);
+
 	if (atomic_dec_and_test(&mddev->flush_pending)) {
 		mddev->barrier =3D NULL;
 		wake_up(&mddev->sb_wait);
@@ -380,7 +391,7 @@
 	submit_barriers(mddev);
=20
 	if (atomic_dec_and_test(&mddev->flush_pending))
-		schedule_work(&mddev->barrier_work);
+		md_barrier_done(mddev);
 }
 EXPORT_SYMBOL(md_barrier_request);
=20
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
