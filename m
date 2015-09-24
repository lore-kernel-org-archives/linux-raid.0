From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 2/2] raid5: update analysis state for failed stripe
Date: Thu, 24 Sep 2015 15:26:57 +1000
Message-ID: <87d1x8wfoe.fsf@notabene.neil.brown.name>
References: <bda150068cfdb69bf8b632c32dc2a7db17c919f4.1442596586.git.shli@fb.com> <0fc9dd19baf6f214a112b040401a4cf3d6313942.1442596586.git.shli@fb.com> <87bncty7sp.fsf@notabene.neil.brown.name> <20150923063425.GA2813864@devbig084.prn1.facebook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150923063425.GA2813864@devbig084.prn1.facebook.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>
Cc: linux-raid@vger.kernel.org, Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Shaohua Li <shli@fb.com> writes:

> On Wed, Sep 23, 2015 at 04:21:58PM +1000, Neil Brown wrote:
>> Shaohua Li <shli@fb.com> writes:
>>=20
>> > handle_failed_stripe() makes the stripe fail, eg, all IO will return
>> > with a failure, but it doesn't update stripe_head_state. Later
>> > handle_stripe() has special handling for raid6 for handle_stripe_fill(=
).
>> > That check before handle_stripe_fill() doesn't skip the failed stripe
>> > and we get a kernel crash in need_this_block.  This patch clear the
>> > analysis state to make sure no functions wrongly called after
>> > handle_failed_stripe()
>> >
>> > Signed-off-by: Shaohua Li <shli@fb.com>
>> > ---
>> >  drivers/md/raid5.c | 4 ++++
>> >  1 file changed, 4 insertions(+)
>> >
>> > diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
>> > index 394cdf8..8e4fb89a 100644
>> > --- a/drivers/md/raid5.c
>> > +++ b/drivers/md/raid5.c
>> > @@ -3155,6 +3155,8 @@ handle_failed_stripe(struct r5conf *conf, struct=
 stripe_head *sh,
>> >  			spin_unlock_irq(&sh->stripe_lock);
>> >  			if (test_and_clear_bit(R5_Overlap, &sh->dev[i].flags))
>> >  				wake_up(&conf->wait_for_overlap);
>> > +			if (bi)
>> > +				s->to_read--;
>> >  			while (bi && bi->bi_iter.bi_sector <
>> >  			       sh->dev[i].sector + STRIPE_SECTORS) {
>> >  				struct bio *nextbi =3D
>> > @@ -3173,6 +3175,8 @@ handle_failed_stripe(struct r5conf *conf, struct=
 stripe_head *sh,
>> >  		 */
>> >  		clear_bit(R5_LOCKED, &sh->dev[i].flags);
>> >  	}
>> > +	s->to_write =3D 0;
>> > +	s->written =3D 0;
>> >=20=20
>> >  	if (test_and_clear_bit(STRIPE_FULL_WRITE, &sh->state))
>> >  		if (atomic_dec_and_test(&conf->pending_full_writes))
>> > --=20
>> > 1.8.1
>>=20
>> Again, this probably is a sensible fix, but I would like to be certain.
>> Where exactly in need_this_block does the kernel crash?  I cannot see
>> anything that could cause an invalid address....
>
>
>>>for (i =3D 0; i < s->failed; i++) {
>>>                if (fdev[i]->towrite &&
> the fdev[i]->towrite. because s->failed >=3D2 (it's 3 in my case), while
> the array size is 2.
>
> Thanks,
> Shaohua

Ahh, of course.
In that case I think I'd like to limit the for loop as well.
So I've applied your patch and this one as well.

Thanks,
NeilBrown

From=2076e308d70b204ff0af0028458caabfeacac4541a Mon Sep 17 00:00:00 2001
From: NeilBrown <neilb@suse.com>
Date: Thu, 24 Sep 2015 15:25:36 +1000
Subject: [PATCH] md/raid5: don't index beyond end of array in
 need_this_block().

When need_this_block probably shouldn't be called when there
are more than 2 failed devices, we really don't want it to try
indexing beyond the end of the failed_num[] of fdev[] arrays.

So limit the loops to at most 2 iterations.

Reported-by: Shaohua Li <shli@fb.com>
Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 903d8a2b7b07..0f49ce411c9a 100644
=2D-- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3304,7 +3304,7 @@ static int need_this_block(struct stripe_head *sh, st=
ruct stripe_head_state *s,
 		 */
 		return 0;
=20
=2D	for (i =3D 0; i < s->failed; i++) {
+	for (i =3D 0; i < s->failed && i < 2; i++) {
 		if (fdev[i]->towrite &&
 		    !test_bit(R5_UPTODATE, &fdev[i]->flags) &&
 		    !test_bit(R5_OVERWRITE, &fdev[i]->flags))
@@ -3328,7 +3328,7 @@ static int need_this_block(struct stripe_head *sh, st=
ruct stripe_head_state *s,
 	    sh->sector < sh->raid_conf->mddev->recovery_cp)
 		/* reconstruct-write isn't being forced */
 		return 0;
=2D	for (i =3D 0; i < s->failed; i++) {
+	for (i =3D 0; i < s->failed && i < 2; i++) {
 		if (s->failed_num[i] !=3D sh->pd_idx &&
 		    s->failed_num[i] !=3D sh->qd_idx &&
 		    !test_bit(R5_UPTODATE, &fdev[i]->flags) &&

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWA4mhAAoJEDnsnt1WYoG5/eoP/Al7E4Qv/OfkQaUkla7VZDxf
7JOSXkvTXOEsYQT+fhHaoGDc4UvU0WSCWcPvaNSt/OZa4haWjujjq5Qmd5C704r0
Fpk6c0DDB/2DwDFeskSCA+g6T9wXMBJYzdSOWiWp8yUHz1EtmeFHT3TkHMmkmplc
BDTZErgPTOT4WyhMW6+1NxzrLEFuxcbrVzEDrm6ciSBogTJUGSoK+/6SpQXUPByz
6L+BMq4pQ5vFTnpJIr89fUEW9OzuWajL45d0R8KEtAXv8doQgxcg8ktS73HQS9d/
jQpwlWt42j6FebJcKATcFQCXikVTaS4xFnmzdwEyvSC74btlFcTYv2mN0QTED7GA
2EUT4SwB9MAaajjdAYF4VpeOj/JKjsc3UJ1/ASe2gVZBOwgmw0EIGr8wSaY7pPmn
oztKr+I1OUwQmmzOBBq01lTb4uE72kNydtxoi6Tct9qpLkR79MLCDMaq8QP3THQZ
81e3XRkJR0+6zeSjLjR0gTppI/mNiQxIdarTi3JcqqajIAbrKio44PQfdlcS/wk3
ZvoBW33z5qe0mgfW/YTR1Vbel9ZsFto7NqGHPJO/PXI6fsArRFHdGjjsgQAjQbxh
14QGV/R6d20qDrUKgYGw0lcuZcwtiPLHQ2J8dBnCFQUmUPWUI1AVyuG9ws/jK7EZ
FObKMvN8RjJs7V7dqxZE
=ZAF0
-----END PGP SIGNATURE-----
--=-=-=--
