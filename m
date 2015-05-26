From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 2/8] md/raid5: Ensure a batch member is not handled
 prematurely.
Date: Wed, 27 May 2015 08:35:32 +1000
Message-ID: <20150527083532.32486e08@notabene.brown>
References: <20150522052802.2117.40527.stgit@notabene.brown>
	<20150522053058.2117.29026.stgit@notabene.brown>
	<20150522234402.GA86128@kernel.org>
	<20150523102640.20be3fca@notabene.brown>
	<20150526181647.GA38853@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/i0ovB2kwYnQR7ywTY9cWog+"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150526181647.GA38853@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/i0ovB2kwYnQR7ywTY9cWog+
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 26 May 2015 11:16:47 -0700 Shaohua Li <shli@kernel.org> wrote:

> On Sat, May 23, 2015 at 10:26:40AM +1000, NeilBrown wrote:
> > On Fri, 22 May 2015 16:44:02 -0700 Shaohua Li <shli@kernel.org> wrote:
> >=20
> > > On Fri, May 22, 2015 at 03:30:58PM +1000, NeilBrown wrote:
> > > > If a stripe is a member of a batch, but not the head, it must
> > > > not be handled separately from the rest of the batch.
> > > >=20
> > > > 'clear_batch_ready()' handles this requirement to some
> > > > extent but not completely.  If a member is passed to handle_stripe()
> > > > a second time it returns '0' indicating the stripe can be handled,
> > > > which is wrong.
> > > > So add an extra test.
> > > >=20
> > > > Signed-off-by: NeilBrown <neilb@suse.de>
> > > > ---
> > > >  drivers/md/raid5.c |    6 +++++-
> > > >  1 file changed, 5 insertions(+), 1 deletion(-)
> > > >=20
> > > > diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> > > > index c3ccefbd4fe7..9a803b735848 100644
> > > > --- a/drivers/md/raid5.c
> > > > +++ b/drivers/md/raid5.c
> > > > @@ -4192,9 +4192,13 @@ static void analyse_stripe(struct stripe_hea=
d *sh, struct stripe_head_state *s)
> > > > =20
> > > >  static int clear_batch_ready(struct stripe_head *sh)
> > > >  {
> > > > +	/* Return '1' if this is a member of batch, or
> > > > +	 * '0' if it is a lone stripe or a head which can now be
> > > > +	 * handled.
> > > > +	 */
> > > >  	struct stripe_head *tmp;
> > > >  	if (!test_and_clear_bit(STRIPE_BATCH_READY, &sh->state))
> > > > -		return 0;
> > > > +		return (sh->batch_head && sh->batch_head !=3D sh);
> > > >  	spin_lock(&sh->stripe_lock);
> > > >  	if (!sh->batch_head) {
> > > >  		spin_unlock(&sh->stripe_lock);
> > >=20
> > > which case can this happen in?
> >=20
> > It definitely happens as I had reliable problems until I added this fix.
> > 'retry_aligned_read()' can call handle_stripe() on any stripe at any ti=
me,
> > but I doubt that would apply.  I might try putting a warn-on there and =
see if
> > it provides any hints.
> >=20
> > >=20
> > > Patches look good. But I'm not in Fusionio any more, so can't check t=
he
> > > performance in big raid array with fast flash cards. I'm doing some t=
ests here.
> > > I hit a warning in break_stripe_batch_list, STRIPE_BIT_DELAY is set i=
n the
> > > stripe state. I'm checking the reason, but if you have thoughts I can=
 try
> > > immediately, please let me know.
> >=20
> > I got STRIPE_BIT_DELAY a few times.  That was the main reason for
> >=20
> >   md/raid5: ensure whole batch is delayed for all required bitmap updat=
es.
> >=20
> > and they went away after I got that patch right.
> >=20
> > Maybe there is a race in there..
> >=20
> > If you can reproduce it, maybe WARN whenever STRIPE_BIT_DELAY gets set =
on a
> > stripe with ->batch_head.
>=20
> Ok, there is a race in add_stripe_bio(). We unlocked the stripe_lock to s=
et the
> BIT_DELAY. After the unlock, the stripe might be added to a batch,
> stripe_add_to_batch_list didn't clear the bit. Holding the lock in
> add_stripe_bio and checking ->batch_head again when we set the bit should=
 fix
> the issue.

We can't hold a spin_lock over bitmap_startwrite(), and we really need to
make sure the write doesn't start until bitmap_startwrite has completed.
So we need to keep the stripe_head out of any batch during that time.
So I've added an extra state bit.

Could you please review and possibly test the patch below?

>=20
> And STRIPE_ON_UNPLUG_LIST and STRIPE_ON_RELEASE_LIST are set is legit in
> break_stripe_batch_list(), they should be removed from the WARN_ON_ONCE().

Yes, you are right.  Thanks.

>=20
> Thanks,
> Shaohua

Thanks,
NeilBrown


diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 041341c66ae5..89d6faafffda 100644
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
@@ -3007,14 +3008,18 @@ static int add_stripe_bio(struct stripe_head *sh, s=
truct bio *bi, int dd_idx,
 	pr_debug("added bi b#%llu to stripe s#%llu, disk %d.\n",
 		(unsigned long long)(*bip)->bi_iter.bi_sector,
 		(unsigned long long)sh->sector, dd_idx);
-	spin_unlock_irq(&sh->stripe_lock);
=20
 	if (conf->mddev->bitmap && firstwrite) {
+		set_bit(STRIPE_BITMAP_PENDING, &sh->state);
+		spin_unlock_irq(&sh->stripe_lock);
 		bitmap_startwrite(conf->mddev->bitmap, sh->sector,
 				  STRIPE_SECTORS, 0);
+		spin_lock_irq(&sh->stripe_lock);
+		clear_bit(STRIPE_BITMAP_PENDING, &sh->state);
 		sh->bm_seq =3D conf->seq_flush+1;
 		set_bit(STRIPE_BIT_DELAY, &sh->state);
 	}
+	spin_lock_irq(&sh->stripe_lock);
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

--Sig_/i0ovB2kwYnQR7ywTY9cWog+
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVWT1NTnsnt1WYoG5AQJErw//aVsIiQ/cnZsPB5hpHlu1fTW0hwid4at/
jaTqZrWRssw4Snvr6qah6glMs8VRdVVf+1Pq8zityfilrAdn3InuidwMEhRItIqv
f36qJl1/0qzU5J5PvmlIygl+Ps7bEHhmRN/gvk63Ue7SKXTMLR+2bPfNcdJHBMjl
c8a4fNKsW6vZtm9lP0SXEBOsYdW/c5X7FZA3zmRvu/0eM7WrfDsq2sM3XT2p9vst
U/0Jcddd7SwUudP3dmfnY1sg4/iE7TE4qAA4G9OLLkCM0fa8YPZmuprwuK7BS7vV
JDP3hMKtbw0uH4+kf1QoKeNz9LhRw9WrJUpBgtxKtWhGSFE+cYgjgOjt+JaU6wE/
BQzqbsD5B72gkfWPrTC+vS259X9JVUbFJNZt1MXjHsHt3BtwTqQnYwNU89jhe5GM
g1nEVyLbIHGy0Jzt5FgrBm4wZ5DN1VPbjKGqw5HGh5eu1aVPyz4nhcRL36FmC7Er
D2aN9AnLpAlW6QTIhAVWDnupCKx3RxwqmmPeEfQb/PAbqfzMfTVAL7H2CT2oWAlf
VVyobM+urNqcHq7BnCT1QvEtEkdctzKpo2agYDlqc9ddAfoIqElzaa9WlktsAyaJ
R2I1qMrMHAeCjXtY6BS2Lh1iVn9a5eGveo/k8WwGwRloM0Da2ixqjAFXCMwKymJ0
RXUyBF2cw2Q=
=wBzP
-----END PGP SIGNATURE-----

--Sig_/i0ovB2kwYnQR7ywTY9cWog+--
