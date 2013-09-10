From: NeilBrown <neilb@suse.de>
Subject: Re: [patch 3/3] raid5: relieve lock contention in
 get_active_stripe()
Date: Tue, 10 Sep 2013 17:28:36 +1000
Message-ID: <20130910172836.43e23cbf@notabene.brown>
References: <20130904164132.177701e0@notabene.brown>
	<20130905054035.GA30216@kernel.org>
	<20130905162910.179ea808@notabene.brown>
	<20130905091822.GA8401@kernel.org>
	<20130909043318.GA27517@kernel.org>
	<20130910111318.1d19e8d3@notabene.brown>
	<20130910023555.GA17907@kernel.org>
	<20130910140629.702683da@notabene.brown>
	<20130910042438.GA16797@kernel.org>
	<20130910152032.48631492@notabene.brown>
	<20130910065912.GA12038@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/rbLlz33xCOTpiXEgsrZax5g"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130910065912.GA12038@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-raid.ids

--Sig_/rbLlz33xCOTpiXEgsrZax5g
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 10 Sep 2013 14:59:12 +0800 Shaohua Li <shli@kernel.org> wrote:

> On Tue, Sep 10, 2013 at 03:20:32PM +1000, NeilBrown wrote:
> > On Tue, 10 Sep 2013 12:24:38 +0800 Shaohua Li <shli@kernel.org> wrote:
> >=20
> > > On Tue, Sep 10, 2013 at 02:06:29PM +1000, NeilBrown wrote:
> > > > On Tue, 10 Sep 2013 10:35:55 +0800 Shaohua Li <shli@kernel.org> wro=
te:
> > > >=20
> > > > > On Tue, Sep 10, 2013 at 11:13:18AM +1000, NeilBrown wrote:
> > > > > > On Mon, 9 Sep 2013 12:33:18 +0800 Shaohua Li <shli@kernel.org> =
wrote:
> > > > > > >  		} else {
> > > > > > > +			spin_lock(&conf->device_lock);
> > > > > > > +
> > > > > > >  			if (atomic_read(&sh->count)) {
> > > > > > >  				BUG_ON(!list_empty(&sh->lru)
> > > > > > >  				    && !test_bit(STRIPE_EXPANDING, &sh->state)
> > > > > > > @@ -611,13 +725,14 @@ get_active_stripe(struct r5conf *conf, s
> > > > > > >  					sh->group =3D NULL;
> > > > > > >  				}
> > > > > > >  			}
> > > > > > > +			spin_unlock(&conf->device_lock);
> > > > > >=20
> > > > > > The device_lock is only really needed in the 'else' branch of t=
he if
> > > > > > statement.  So can we have it only there.  i.e. don't take the =
lock if
> > > > > > sh->count is non-zero.
> > > > >=20
> > > > > This is correct, I assume this isn't worthy optimizing before. Wi=
ll fix soon.
> > > >=20
> > > > It isn't really about optimising performance.  It is about making t=
he code
> > > > easier to understand.  If we keep the region covered by the lock as=
 small as
> > > > reasonably possible, it makes it more obvious to the reader which v=
alues are
> > > > being protected.
> > > >=20
> > > > =20
> > > > > > > -	spin_lock_irqsave(&conf->device_lock, flags);
> > > > > > > +	lock_all_device_hash_locks_irqsave(conf, &flags);
> > > > > > >  	clear_bit(In_sync, &rdev->flags);
> > > > > > >  	mddev->degraded =3D calc_degraded(conf);
> > > > > > > -	spin_unlock_irqrestore(&conf->device_lock, flags);
> > > > > > > +	unlock_all_device_hash_locks_irqrestore(conf, &flags);
> > > > > > >  	set_bit(MD_RECOVERY_INTR, &mddev->recovery);
> > > > > >=20
> > > > > > Why do you think you need to take all the hash locks here and e=
lsewhere when
> > > > > > ->degraded is set?
> > > > > > The lock is only need to ensure that the 'In_sync' flags are co=
nsistent with
> > > > > > the 'degraded' count.
> > > > > > ->degraded isn't used in get_active_stripe so I cannot see how =
it is relevant
> > > > > > to the hash locks.
> > > > > >=20
> > > > > > We need to lock everything in raid5_quiesce().  I don't think w=
e need to
> > > > > > anywhere else.
> > > > >=20
> > > > > init_stripe() accesses some filelds, don't need to protect?
> > > >=20
> > > > What fields?  Not ->degraded.
> > > >=20
> > > > I think the fields that it accesses are effectively protected by th=
e new
> > > > seqlock.
> > > > If you don't think so, please be explicit.
> > >=20
> > > Like raid_disks, previous_raid_disks, chunk_sectors, prev_chunk_secto=
rs,
> > > algorithm and so on. They are used in raid5_compute_sector(), stripe_=
set_idx()
> > > and init_stripe(). The former two are called by init_stripe().
> >=20
> > Yes.  Those are only changed in raid5_start_reshape() and are protected=
 by
> > conf->gen_lock.
>=20
> Ok, I thought I misread degraded as max_degraded, so added unnecessary co=
de.
> The last question, in raid5_start_reshape(), I thought we should use seql=
ock to
> protect the '!mddev->sync_thread' case, no?

We don't need anything there to protect the change to conf->raid_disks as
make_request can only possibly access previous_raid_disks at that point.

However conf->reshape_progress is an issue.
I write request just before this point would use a 'previous' stripe, while
immediately after it would use a 'next' stripe.  i.e. sh->generation could
have a different value.

So I think would should use the seqlock to protect that branch, and should
decrement conf->generation.
We should be putting algorithm and chunk back as well.

I'll great a patch to just fix that.
Thanks.

>=20
> > If they change while init_stripe is running, the read_seqcount_retry() =
call in
> > make_request() will notice the inconsistency, release the stripe, and t=
ry
> > again.
> >=20
> > I guess we probably need an extra check on gen_lock inside init_stripe(=
).
> > i.e. a
> >   do {
> >      seq =3D read_seqcount_begin(&conf->gen_lock);
> >=20
> > just after the "remove_hash(sh)", and a
> >=20
> >   } while (read_seqcount_retry(&conf->gen_lock, seq));
> >=20
> > just before the "insert_hash(sh)".  That will ensure the stripe inserte=
d into
> > the hash is consistent.  The read_seqcount_retry() in make_request is s=
till
> > needed to ensure that the correct stripe_head is used.
>=20
> Good point. If it's in hash list, the seqcount check could be skiped.

I'm not sure exactly what you mean but I cannot see a case where you would
want to skip the seqcount check there...

NeilBrown

--Sig_/rbLlz33xCOTpiXEgsrZax5g
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUi7KJDnsnt1WYoG5AQI22RAAqS73ysXnXIsw7nL5S6m7sTS4DrX9EOZ4
a/J9UY8SRsKRXKHhlaD2gJmbLzMN+xsiEIa43BxVZaz+t1uQ0uUeuvvRqy0Vov2a
i1NQvmG0YHysWFD4oeYE2KYNuWPJLV0vQQwIWN7agFYfmTJGMNfL1ilXto1rGked
kjtPn4WLCQX3BV8U/HLhTW1kbjCU38uiLojpjYCeBWwvXtsSsTussoJLk0kU6YmL
xnnJitBwbhZ6kbE/gGaXYgLOwaLAo2nH/oTz4mS3QXHjzCn8VEoEPlZFKDQW90eq
d+J/qTZ5DkCndYcTPlnZwuzMRXKLBagzt8O66Qy8W2EMkiaxz8nyRov4Ccs4jV0C
J0mUrOR3U8SHZopbzECkFrDHkYsb7HJiIsm/vtKPdBm24Y7Izf8d2/5e0lHnd/Hi
pKZgs+MJGC0lcLyBi4Fkcdnm7siETWlRcXonX+gpgFJIuA50s+5SLumP9ogQimab
y03qR4/JnD3GlQ6jB6k6YP4HiY04/eh5eK5uFbkFGrcQkGj9QQcUqVyhGr1aQ7g7
yw9Gen8No4EU1pJS7Irw2nz6EneKV8KMkIUPc2LoqoHyJa9ChS83kCjdXRrXbLnU
kMqnjs0NdP4qkfqDF7GU7XcAVueu5lHDiPTWazo1Io5OAKQR952V+xSVDXu1MVEA
aHIeJfw8kZE=
=dz28
-----END PGP SIGNATURE-----

--Sig_/rbLlz33xCOTpiXEgsrZax5g--
