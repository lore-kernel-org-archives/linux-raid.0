From: Neil Brown <neilb@suse.de>
Subject: Re: New RAID causing system lockups
Date: Tue, 14 Sep 2010 09:51:11 +1000
Message-ID: <20100914095111.6e3045c7@notabene>
References: <AANLkTimTvPupaPuFbfpcCGC=0Ys9fQWihAgaADsrowqq@mail.gmail.com>
	<20100912064308.46d96742@notabene>
	<AANLkTikWY1QE_2HBADkVV1u1OSCktVT=ShQrCdNWBF8n@mail.gmail.com>
	<AANLkTimzmoyq_KHA1Q3JgEJSj2iuwYwiHRNR=_ZuLQCZ@mail.gmail.com>
	<AANLkTiknrUVCToYg8NM0dUX9kXVE_kTAwtuAqo09X-qj@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTiknrUVCToYg8NM0dUX9kXVE_kTAwtuAqo09X-qj@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Hartman <mike@hartmanipulation.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 13 Sep 2010 11:57:03 -0400
Mike Hartman <mike@hartmanipulation.com> wrote:

> >>> I don't know yet what is causing the lock-up. =C2=A0A quick look =
at your logs
> >>> suggest that it could be related to the barrier handling. =C2=A0M=
aybe trying to
> >>> handle a barrier during a reshape is prone to races of some sort =
- I wouldn't
> >>> be very surprised by that.
> >>
> >> Just note that during the second lockup no reshape or resync was g=
oing
> >> on. The array state was stable, I was just writing to it.
> >>
> >>>
> >>> I'll have a look at the code and see what I can find.
> >>
> >> Thanks a lot. If it was only a risk when I was growing/reshaping t=
he
> >> array, and covered by the backup file, it would just be an
> >> inconvenience. But since it can seemingly happen at any time it's =
a
> >> problem.
> >>
> >
> > The lockup just happened again. I wasn't doing any
> > growing/reshaping/anything like that. Just copying some data into t=
he
> > partition that lives on md0. dmesg_3.txt has been uploaded alongsid=
e
> > the other files at http://www.hartmanipulation.com/raid/. The trace
> > looks pretty similar to me.
> >
>=20
> The lockup just happened for the fourth time, less than an hour after
> I rebooted to clear the previous lockup from last night. All I did wa=
s
> boot the system, start the RAID, and start copying some files onto it=
=2E
> The problem seems to be getting worse - up until now I got at least a
> full day of fairly heavy usage out of the system before it happened.
> dmesg_4.txt has been uploaded alongside the other files. Let me know
> if there's any other system information that would be useful.
>=20
> Mike

Hi Mike,
 thanks for the updates.

I'm not entirely clear what is happening (in fact, due to a cold that I=
 am
still fighting off, nothing is entirely clear at the moment), but it lo=
oks
very likely that the problem is due to an interplay between barrier han=
dling,
and the multi-level structure of your array (a raid0 being a member of =
a
raid5).

When a barrier request is processed, both arrays will schedule 'work' t=
o be
done by the 'event' thread and I'm guess that you can get into a situat=
ion
where one work time is wait for the other, but the other is behind the =
one on
the single queue (I wonder if that make sense...)

Anyway, this patch might make a difference,  It reduced the number of w=
ork
items schedule in a way that could conceivably fix the problem.

If you can test this, please report the results.  I cannot easily repro=
duce
the problem so there is limited testing that I can do.

Thanks,
NeilBrown


diff --git a/drivers/md/md.c b/drivers/md/md.c
index f20d13e..7f2785c 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -294,6 +294,23 @@ EXPORT_SYMBOL(mddev_congested);
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
@@ -310,7 +327,7 @@ static void md_end_barrier(struct bio *bio, int err=
)
 			wake_up(&mddev->sb_wait);
 		} else
 			/* The pre-request barrier has finished */
-			schedule_work(&mddev->barrier_work);
+			md_barrier_done(mddev);
 	}
 	bio_put(bio);
 }
@@ -350,18 +367,12 @@ static void md_submit_barrier(struct work_struct =
*ws)
=20
 	atomic_set(&mddev->flush_pending, 1);
=20
-	if (test_bit(BIO_EOPNOTSUPP, &bio->bi_flags))
-		bio_endio(bio, -EOPNOTSUPP);
-	else if (bio->bi_size =3D=3D 0)
-		/* an empty barrier - all done */
-		bio_endio(bio, 0);
-	else {
-		bio->bi_rw &=3D ~REQ_HARDBARRIER;
-		if (mddev->pers->make_request(mddev, bio))
-			generic_make_request(bio);
-		mddev->barrier =3D POST_REQUEST_BARRIER;
-		submit_barriers(mddev);
-	}
+	bio->bi_rw &=3D ~REQ_HARDBARRIER;
+	if (mddev->pers->make_request(mddev, bio))
+		generic_make_request(bio);
+	mddev->barrier =3D POST_REQUEST_BARRIER;
+	submit_barriers(mddev);
+
 	if (atomic_dec_and_test(&mddev->flush_pending)) {
 		mddev->barrier =3D NULL;
 		wake_up(&mddev->sb_wait);
@@ -383,7 +394,7 @@ void md_barrier_request(mddev_t *mddev, struct bio =
*bio)
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
