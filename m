From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 2/8] md/raid5: Ensure a batch member is not handled
 prematurely.
Date: Wed, 27 May 2015 10:36:56 +1000
Message-ID: <20150527103656.6591e6f3@notabene.brown>
References: <20150522052802.2117.40527.stgit@notabene.brown>
	<20150522053058.2117.29026.stgit@notabene.brown>
	<20150522234402.GA86128@kernel.org>
	<20150523102640.20be3fca@notabene.brown>
	<20150526181647.GA38853@kernel.org>
	<20150527083532.32486e08@notabene.brown>
	<20150527093451.0c83be44@notabene.brown>
	<20150527001005.GA106894@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/4r1CmuCvQc9G96hHh+9Ji0z"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150527001005.GA106894@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/4r1CmuCvQc9G96hHh+9Ji0z
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 26 May 2015 17:10:05 -0700 Shaohua Li <shli@kernel.org> wrote:

> On Wed, May 27, 2015 at 09:34:51AM +1000, NeilBrown wrote:
> > On Wed, 27 May 2015 08:35:32 +1000 NeilBrown <neilb@suse.de> wrote:
> >=20
> > > Could you please review and possibly test the patch below?
> > >=20
> >=20
> > well... that patch had a fairly obvious double-lock bug.
> > Try this one.
> > (oh, just saw your email that you spotted the lock bug :-)
> >=20
> >=20
> > NeilBrown
> >=20
> > From: NeilBrown <neilb@suse.de>
> > Date: Wed, 27 May 2015 08:43:45 +1000
> > Subject: [PATCH] md/raid5: close race between STRIPE_BIT_DELAY and batc=
hing.
> >=20
> > The first time a write is added to a stripe, we need to set the
> > bitmap bits (if a bitmap is active).
> > While doing that the stripe is not locked and other writes could
> > be added and then the stripe could be added to a batch.
> > Once it has entered the batch it is too large to set STRIPE_BIT_DELAY
> > as the batch head has taken over when the stripe will be written.
> >=20
> > We cannot hold the spinlock while adding the bitmap bit,
> > so introduce a new stripe_head flag 'STRIPE_BITMAP_PENDING' which
> > indicates that adding to the bitmap is pending.  This prevents
> > the stripe from being added to a batch.
> >=20
> > Only the first thread to add a write to a stripe can set this bit,
> > so it is safe for it to clear it again when it is done.
> >=20
> > Reported-by: Shaohua Li <shli@kernel.org>
> > Signed-off-by: NeilBrown <neilb@suse.de>
> >=20
> > diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> > index 73b5376dad3b..dae587ecdf71 100644
> > --- a/drivers/md/raid5.c
> > +++ b/drivers/md/raid5.c
> > @@ -760,6 +760,7 @@ static void unlock_two_stripes(struct stripe_head *=
sh1, struct stripe_head *sh2)
> >  static bool stripe_can_batch(struct stripe_head *sh)
> >  {
> >  	return test_bit(STRIPE_BATCH_READY, &sh->state) &&
> > +		!test_bit(STRIPE_BITMAP_PENDING, &sh->state) &&
> >  		is_full_stripe_write(sh);
> >  }
> > =20
> > @@ -3007,14 +3008,27 @@ static int add_stripe_bio(struct stripe_head *s=
h, struct bio *bi, int dd_idx,
> >  	pr_debug("added bi b#%llu to stripe s#%llu, disk %d.\n",
> >  		(unsigned long long)(*bip)->bi_iter.bi_sector,
> >  		(unsigned long long)sh->sector, dd_idx);
> > -	spin_unlock_irq(&sh->stripe_lock);
> > =20
> >  	if (conf->mddev->bitmap && firstwrite) {
> > +		/* Cannot hold spinlock over bitmap_startwrite,
> > +		 * but must ensure this isn't added to a batch until
> > +		 * we have added to the bitmap and set bm_seq.
> > +		 * So set STRIPE_BITMAP_PENDING to prevent
> > +		 * batching.
> > +		 * Only the first thread to add a write to a stripe
> > +		 * can set this bit, so we "own" it.
> > +		 */
> > +		WARN_ON(test_bit(STRIPE_BITMAP_PENDING, &sh->state));
> I keep hitting this. the firstwrite is set for every device.
>=20

I wonder why I'm not.... maybe because I'm using /dev/loop devices and they
behave a bit differently.

Of course 'firstwrite' is not per-stripe, it is per-device-in-a-stripe.
So it will be set for every device.
Which is rather pointless really, we only need to set the bitmap once for t=
he
whole stripe.  Maybe it was easier the other way.

Could you try this?

Thanks!
NeilBrown

From: NeilBrown <neilb@suse.de>
Date: Wed, 27 May 2015 08:43:45 +1000
Subject: [PATCH] md/raid5: close race between STRIPE_BIT_DELAY and batching.

When we add a write to a stripe we need to make sure the bitmap
bit is set.  While doing that the stripe is not locked so it could
be added to a batch after which further changes to STRIPE_BIT_DELAY
and ->bm_seq are ineffective.

So we need to hold off adding to a stripe until bitmap_startwrite has
completed at least once, and we need to avoid further changes to
STRIPE_BIT_DELAY once the stripe has been added to a batch.

If a bitmap_startwrite() completes after the stripe was added to a
batch, it will not have set the bit, only incremented a counter, so no
extra delay of the stripe is needed.

Reported-by: Shaohua Li <shli@kernel.org>
Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 73b5376dad3b..5d5ce97c2210 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -760,6 +760,7 @@ static void unlock_two_stripes(struct stripe_head *sh1,=
 struct stripe_head *sh2)
 static bool stripe_can_batch(struct stripe_head *sh)
 {
 	return test_bit(STRIPE_BATCH_READY, &sh->state) &&
+		!test_bit(STRIPE_BITMAP_PENDING, &sh->state) &&
 		is_full_stripe_write(sh);
 }
=20
@@ -3007,14 +3008,32 @@ static int add_stripe_bio(struct stripe_head *sh, s=
truct bio *bi, int dd_idx,
 	pr_debug("added bi b#%llu to stripe s#%llu, disk %d.\n",
 		(unsigned long long)(*bip)->bi_iter.bi_sector,
 		(unsigned long long)sh->sector, dd_idx);
-	spin_unlock_irq(&sh->stripe_lock);
=20
 	if (conf->mddev->bitmap && firstwrite) {
+		/* Cannot hold spinlock over bitmap_startwrite,
+		 * but must ensure this isn't added to a batch until
+		 * we have added to the bitmap and set bm_seq.
+		 * So set STRIPE_BITMAP_PENDING to prevent
+		 * batching.
+		 * If multiple add_stripe_bio() calls race here they
+		 * much all set STRIPE_BITMAP_PENDING.  So only the first one
+		 * to complete "bitmap_startwrite" gets to set
+		 * STRIPE_BIT_DELAY.  This is important as once a stripe
+		 * is added to a batch, STRIPE_BIT_DELAY cannot be changed
+		 * any more.
+		 */
+		set_bit(STRIPE_BITMAP_PENDING, &sh->state);
+		spin_unlock_irq(&sh->stripe_lock);
 		bitmap_startwrite(conf->mddev->bitmap, sh->sector,
 				  STRIPE_SECTORS, 0);
-		sh->bm_seq =3D conf->seq_flush+1;
-		set_bit(STRIPE_BIT_DELAY, &sh->state);
+		spin_lock_irq(&sh->stripe_lock);
+		clear_bit(STRIPE_BITMAP_PENDING, &sh->state);
+		if (!sh->batch_head) {
+			sh->bm_seq =3D conf->seq_flush+1;
+			set_bit(STRIPE_BIT_DELAY, &sh->state);
+		}
 	}
+	spin_unlock_irq(&sh->stripe_lock);
=20
 	if (stripe_can_batch(sh))
 		stripe_add_to_batch_list(conf, sh);
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index d7b2bc8b756f..02c3bf8fbfe7 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -337,6 +337,9 @@ enum {
 	STRIPE_ON_RELEASE_LIST,
 	STRIPE_BATCH_READY,
 	STRIPE_BATCH_ERR,
+	STRIPE_BITMAP_PENDING,	/* Being added to bitmap, don't add
+				 * to batch yet.
+				 */
 };
=20
 #define STRIPE_EXPAND_SYNC_FLAGS \


--Sig_/4r1CmuCvQc9G96hHh+9Ji0z
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVWURqDnsnt1WYoG5AQLXTw//Rzj4rXmXiQl206Mv//OvXihziMjuUwv4
9KBm7oGX0ugnOJ5wnrmC87+X5ntKmElPibqfIqNcChNnqPUN7ikrw0pxgXwN6TZX
YTnPO3CG6IuSYQ9XcWa/57+8pp07MCofJMWHPqvJcQL3jWAgVF3YBXm3Jzca0YkZ
6Wf5KaCtFUo0AhrUIwbvYgD276hlfPNvaEALKfGg7TLUJSgH9I04Y7V0Kof3v7GE
Qbiuoxxa/oZpdWvG7U6ml+ylLMV+72wX+7Tcvzt9XpzYHoeJccbidDjujbEsq65S
cyvBLBuXnS1Apzr1Y93/3B+Y4Nn0UymDobm5ylN/AgZR9nTpqptMuvVTJUZizYcP
z9ysOXjswPwfFhf0M1Nvl79cTywX63TNfWxRMBJrTIO40LPfe/CuLL0zu3gfs/1c
IZiH305CXlVZgc3nCwvp6j7GyKAnUkZ6sWse6vQvXosjhBT1XPT8fdOvoa4kQAx0
l4T/EBMhBblhOnyxdzlYFV4FH9Tifq58Q7HPc1bB30Oqtzg3Dz2ddyi4dgzaJnp2
Lrvc2kXMcwn0RGX/hz1ZgZ3elzrpJdVK9tr7j+vM0Jqt6xJIq2QVgmRdC/mjGECE
cVporghN2Z1JmKyubHXkfoHj2xT/ILYruIJQaRj5zVr95jg7+/H6eU/4PmMZ/d+d
6V4u2Uqljao=
=7QBV
-----END PGP SIGNATURE-----

--Sig_/4r1CmuCvQc9G96hHh+9Ji0z--
