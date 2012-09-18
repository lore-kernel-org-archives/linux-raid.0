From: NeilBrown <neilb@suse.de>
Subject: Re: [patch 6/7 v2] MD: raid5 trim support
Date: Tue, 18 Sep 2012 14:52:11 +1000
Message-ID: <20120918145211.0cbfbfa1@notabene.brown>
References: <20120810025113.050392766@kernel.org>
	<20120810025255.292192477@kernel.org>
	<20120813115051.64d5d44e@notabene.brown>
	<20120813020454.GA447@kernel.org>
	<20120813135831.284d721d@notabene.brown>
	<20120813054347.GA20261@kernel.org>
	<20120911141008.10dd0a50@notabene.brown>
	<20120912040953.GA10047@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/XTCG5wJNVqtHkkmSUn.XMqH"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120912040953.GA10047@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: Shaohua Li <shli@fusionio.com>, linux-raid@vger.kernel.org, axboe@kernel.dk
List-Id: linux-raid.ids

--Sig_/XTCG5wJNVqtHkkmSUn.XMqH
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 12 Sep 2012 12:09:53 +0800 Shaohua Li <shli@kernel.org> wrote:

> On Tue, Sep 11, 2012 at 02:10:08PM +1000, NeilBrown wrote:
> > > +	bi =3D orig_bi;
> > > +	if (bi->bi_rw & REQ_DISCARD) {
> > > +		dd_idx++;
> > > +		while (dd_idx =3D=3D sh->pd_idx || dd_idx =3D=3D sh->qd_idx)
> > > +			dd_idx++;
> > > +		if (dd_idx < sh->disks)
> > > +			goto again;
> > > +	}
> >=20
> > I'm afraid there there is something else here that I can't make my self=
 happy
> > with.
> >=20
> > You added a new "goto again" loop inside add_stripe_bio, and to compens=
ate
> > the increase logical_sector in make_request so that it doesn't call
> > add_stripe_bio so many times.
> > This means that to control flow between make_request and add_stripe_bio=
 is
> > very different depending on whether it is a discard or not.  That make =
the
> > code harder to understand and easier to break later.
> >=20
> > I think it would to create a completely separate "make_trim_request()" =
which
> > handles the trim/discard case, and leave the current code as it is.
> >=20
> > If/when you do send a patch to do that, please also resend the other ra=
id5
> > patch which comes after this one.  I tend not to keep patches once I've
> > devices not to apply them immediately.  It also reduces the chance of
> > confusion if you just send whatever you want me to apply.
>=20
> I'm afraid there will be a lot of duplicate code doing this way. How about
> below patch? I made it clearer for discard. If you like it, I'll send oth=
er
> patches.

I don't think there will be that much duplicate code.  And even if there is
some, it is worth it to get a clearer control flow.

I tried writing something and realised that your code is (I think) racy.
You really need the whole stripe to be either all-discard, or no-discards.
So you need to hold the stripe_lock while adding the discard bios to every
device.  Your code doesn't do that.

Here is what I came up with.  It only addresses the 'make_request' part of
the patch and isn't even compile tested but it should show the general shape
of the solution, and show how little code is duplicated.

NeilBrown

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 7031b86..ca80290 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4071,6 +4071,73 @@ static void release_stripe_plug(struct mddev *mddev,
 		release_stripe(sh);
 }
=20
+static void make_discard_request(struct mddev *mddev, struct bio *bi)
+{
+	sector_t logical_sector, last_sector;
+	int stripe_sectors;
+	struct r5conf *conf =3D mddev->private;
+
+	if (mddev->reshape_position !=3D MaxSector)
+		/* Skip discard while reshape is happening */
+		return;
+
+	logical_sector =3D bi->bi_sector & ~((sector_t)STRIPE_SECTORS-1);
+	last_sector =3D bi->bi_sector + (bi->bi_size>>9);
+
+	bi->bi_next =3D NULL;
+	bi->bi_phys_segments =3D 1;	/* over-loaded to count active stripes */
+
+	stripe_sectors =3D conf->chunk_sectors *
+		(conf->raid_disks - conf->max_degraded);
+	logical_sector =3D DIV_ROUND_UP_SECTOR_T(logical_sector,
+					       stripe_sectors);
+	sector_div(last_sector, stripe_sectors);
+
+	for (;logical_sector < last_sector;
+	     logical_sector +=3D STRIPE_SECTORS) {
+		sh =3D get_active_stripe(conf, logical_sector, previous,
+				       0, 0);
+	again:
+		prepare_to_wait(&conf->wait_for_overlap, &w,
+				TASK_UNINTERRUPTIBLE);
+		spin_lock_irq(&sh->stripe_lock);
+		for (d =3D 0; d < conf->raid_disks; d++) {
+			if (sh->dev[d].towrite ||
+			    sh->dev[d].toread) {
+				set_bit(R5_Overwrite, &sh->dev[d].flags);
+				spin_unlock_irq(&sh->stripe_lock);
+				schedule();
+				goto again;
+			}
+		}
+		finish_wait(&conf->wait_for_overlap, &w);
+		for (d =3D 0; d < conf->raid_disks; d++)
+			if (d !=3D conf->pd_idx &&
+			    d !=3D conf->qd_idx) {
+				sh->dev[d].towrite =3D bi;
+				set_bit(R5_OVERWRITE, &sh->dev[d].flags);
+			}
+		spin_unlock_irq(&sh->stripe_lock);
+		if (conf->mddev->bitmap) {
+			for (d =3D 0; d < conf->raid_disks - conf->max_degraded;
+			     d++)
+				bitmap_startwrite(mddev->bitmap,
+						  sh->sector,
+						  STRIPE_SECTORS,
+						  0);
+			sh->bm_seq =3D conf->seq_flush + 1;
+			set_bit(STRIPE_BIT_DELAY, &sh->state);
+		}
+
+		set_bit(STRIPE_HANDLE, &sh->state);
+		clear_bit(STRIPE_DELAYED, &sh->state);
+		if (!test_and_set_bit(STRIPE_PREREAD_ACTIVE,
+				      &sh->state))
+			atomic_inc(&conf->preread_active_stripes);
+		release_stripe_plug(mddev, sh);
+	}
+}
+
 static void make_request(struct mddev *mddev, struct bio * bi)
 {
 	struct r5conf *conf =3D mddev->private;
@@ -4093,6 +4160,11 @@ static void make_request(struct mddev *mddev, struct=
 bio * bi)
 	     chunk_aligned_read(mddev,bi))
 		return;
=20
+	if (unlikely(bi->bi_rw & REQ_DISCARD)) {
+		make_discard_request(mddev, bi);
+		return;
+	}
+
 	logical_sector =3D bi->bi_sector & ~((sector_t)STRIPE_SECTORS-1);
 	last_sector =3D bi->bi_sector + (bi->bi_size>>9);
 	bi->bi_next =3D NULL;

--Sig_/XTCG5wJNVqtHkkmSUn.XMqH
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUFf9+znsnt1WYoG5AQI26Q/+NjJn+dPBGiBlh0MX052ldxNSb+bT80th
UKu2wVY1ZFCSBQi0/NqrFuhA9BcBR2HyVAWcCobDQrBM5phG6sRtZrhVuGKt8b2m
vqZXF/dKIDc7y+lpih17SSwrb593lrcLr/NGAxgTIxR7XrZzCyJgY0mgnHYDi9+N
s7SiP7W3hCy2np2wq/1a2Ht7p7GDLgQANlPK35l6pDb29A0Y4P8Vf0t8Ymt0SKg9
D5QOPaNWhFlsO1IiVQIMBxU+d56sboEF0x+Z4SutO8ddKhIyallLUKvyGlSvkxwy
j16L0rf4Z94DwxnR1vOWyfpCb37OfSCRrnoIFBrrpFRyOsdMF1mqu50TOn7PqbfA
e82vryNzPL36GkNk+iEIYMFdb8Yoi0LclGZr3L8oGD7ISz8QKQjkrN7kOGCfvMLQ
wQ5tC90IddXAMJzyqXRPkBVhXCkcVRS0JsXlI8myqPqIC+YBoNURpzjmx6qRmQVd
dj8y04o4gC1Hj27OCCZ/Qa89SZWMBxDXrchGLz8DV+eWLQoz36Zm618tJMHODqRF
p26d3e2STp7ad8b3KKixaxSQAHo8fxE5TQXgmJvCeeFwHOULcLTIVH3uQVcTwJmX
Jx5hopY9vDRIi0/jKQ/lmhTajc8pLfHIkpDVhSo1MaHf9W1HdnS1heZt4uPWMcXl
gHUE8wrHmt4=
=N2ao
-----END PGP SIGNATURE-----

--Sig_/XTCG5wJNVqtHkkmSUn.XMqH--
