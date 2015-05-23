From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 2/8] md/raid5: Ensure a batch member is not handled
 prematurely.
Date: Sat, 23 May 2015 10:26:40 +1000
Message-ID: <20150523102640.20be3fca@notabene.brown>
References: <20150522052802.2117.40527.stgit@notabene.brown>
	<20150522053058.2117.29026.stgit@notabene.brown>
	<20150522234402.GA86128@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/wJR_j14E1X.PVvsLkDpeLPA"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150522234402.GA86128@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/wJR_j14E1X.PVvsLkDpeLPA
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 22 May 2015 16:44:02 -0700 Shaohua Li <shli@kernel.org> wrote:

> On Fri, May 22, 2015 at 03:30:58PM +1000, NeilBrown wrote:
> > If a stripe is a member of a batch, but not the head, it must
> > not be handled separately from the rest of the batch.
> >=20
> > 'clear_batch_ready()' handles this requirement to some
> > extent but not completely.  If a member is passed to handle_stripe()
> > a second time it returns '0' indicating the stripe can be handled,
> > which is wrong.
> > So add an extra test.
> >=20
> > Signed-off-by: NeilBrown <neilb@suse.de>
> > ---
> >  drivers/md/raid5.c |    6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> > index c3ccefbd4fe7..9a803b735848 100644
> > --- a/drivers/md/raid5.c
> > +++ b/drivers/md/raid5.c
> > @@ -4192,9 +4192,13 @@ static void analyse_stripe(struct stripe_head *s=
h, struct stripe_head_state *s)
> > =20
> >  static int clear_batch_ready(struct stripe_head *sh)
> >  {
> > +	/* Return '1' if this is a member of batch, or
> > +	 * '0' if it is a lone stripe or a head which can now be
> > +	 * handled.
> > +	 */
> >  	struct stripe_head *tmp;
> >  	if (!test_and_clear_bit(STRIPE_BATCH_READY, &sh->state))
> > -		return 0;
> > +		return (sh->batch_head && sh->batch_head !=3D sh);
> >  	spin_lock(&sh->stripe_lock);
> >  	if (!sh->batch_head) {
> >  		spin_unlock(&sh->stripe_lock);
>=20
> which case can this happen in?

It definitely happens as I had reliable problems until I added this fix.
'retry_aligned_read()' can call handle_stripe() on any stripe at any time,
but I doubt that would apply.  I might try putting a warn-on there and see =
if
it provides any hints.

>=20
> Patches look good. But I'm not in Fusionio any more, so can't check the
> performance in big raid array with fast flash cards. I'm doing some tests=
 here.
> I hit a warning in break_stripe_batch_list, STRIPE_BIT_DELAY is set in the
> stripe state. I'm checking the reason, but if you have thoughts I can try
> immediately, please let me know.

I got STRIPE_BIT_DELAY a few times.  That was the main reason for

  md/raid5: ensure whole batch is delayed for all required bitmap updates.

and they went away after I got that patch right.

Maybe there is a race in there..

If you can reproduce it, maybe WARN whenever STRIPE_BIT_DELAY gets set on a
stripe with ->batch_head.

>=20
> Thanks,
> Shaohua

Thanks,
NeilBrown

--Sig_/wJR_j14E1X.PVvsLkDpeLPA
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVV/JQTnsnt1WYoG5AQIBZg//W5yOUxIeMQ7uW5YtNceLlqbqDGp6mz5t
H9E2Y4+WVu+gMmJ4jTZoUvk5RG7M3pTsf6lhr/SQKoDGrnJNtu1b4ZDdYryzVvU6
jXIrCkVGcHHQCyqBIYs4+TdHSzpUT7XoHpIUICjuJNk0yFP1NsoUwzXoEefqxANI
d9ZuAs8cOHbGQ/KsbtSxVn4RN6fygBURBb1AclYo5WgEc3eTaEqj4nv5EoxFPqqS
HxCamNKCluvINSqrB134Jw54WQabi0769STHtZrfInO3a2YHNGXPD2YNbAgetF2c
CGSHzGVTgcBvqW0dk3sFDTbvn4ySM1dEkyj2xGJXZxco3I2lrttSZmCo8AKKNtoh
ZZqV5YULJASsc351Ij9eqPnDF3ytr9vHBZrF32KsXCq6ycM2BxUcLTcSBKliWwn8
3RYjk7CU7kn82Rh0q5FeWTbqCZ175O8htkxvrQ+ure74iDn61wBmw8JGRUvuITZE
iXUBGWeAut72L3LQ/Ff+eCRRJDxx6CuNBEXQIQ+8Y5OHD33qRuPDgIrfKB2j5RRH
hqUlM6GvglSZ2wMoC14P26W6ktY+rMKtlyI6HRa/vGhQ/423QJor/lpNcWWh2asR
xhJJbuLWPoyodaJDjxAEDN+atrQ2YHQ3dwrSUJWclRj/UTpVsYNlCZxNjI8NBiXp
je6F7jkCMxc=
=g1XD
-----END PGP SIGNATURE-----

--Sig_/wJR_j14E1X.PVvsLkDpeLPA--
