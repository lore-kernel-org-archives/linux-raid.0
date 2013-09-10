From: NeilBrown <neilb@suse.de>
Subject: Re: [patch 3/3] raid5: relieve lock contention in
 get_active_stripe()
Date: Tue, 10 Sep 2013 15:20:32 +1000
Message-ID: <20130910152032.48631492@notabene.brown>
References: <20130903160858.2175a41b@notabene.brown>
	<20130903070228.GA25041@kernel.org>
	<20130904164132.177701e0@notabene.brown>
	<20130905054035.GA30216@kernel.org>
	<20130905162910.179ea808@notabene.brown>
	<20130905091822.GA8401@kernel.org>
	<20130909043318.GA27517@kernel.org>
	<20130910111318.1d19e8d3@notabene.brown>
	<20130910023555.GA17907@kernel.org>
	<20130910140629.702683da@notabene.brown>
	<20130910042438.GA16797@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/B40PMAjFe5DJrJn=wB2KW=9"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130910042438.GA16797@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-raid.ids

--Sig_/B40PMAjFe5DJrJn=wB2KW=9
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 10 Sep 2013 12:24:38 +0800 Shaohua Li <shli@kernel.org> wrote:

> On Tue, Sep 10, 2013 at 02:06:29PM +1000, NeilBrown wrote:
> > On Tue, 10 Sep 2013 10:35:55 +0800 Shaohua Li <shli@kernel.org> wrote:
> >=20
> > > On Tue, Sep 10, 2013 at 11:13:18AM +1000, NeilBrown wrote:
> > > > On Mon, 9 Sep 2013 12:33:18 +0800 Shaohua Li <shli@kernel.org> wrot=
e:
> > > > >  		} else {
> > > > > +			spin_lock(&conf->device_lock);
> > > > > +
> > > > >  			if (atomic_read(&sh->count)) {
> > > > >  				BUG_ON(!list_empty(&sh->lru)
> > > > >  				    && !test_bit(STRIPE_EXPANDING, &sh->state)
> > > > > @@ -611,13 +725,14 @@ get_active_stripe(struct r5conf *conf, s
> > > > >  					sh->group =3D NULL;
> > > > >  				}
> > > > >  			}
> > > > > +			spin_unlock(&conf->device_lock);
> > > >=20
> > > > The device_lock is only really needed in the 'else' branch of the if
> > > > statement.  So can we have it only there.  i.e. don't take the lock=
 if
> > > > sh->count is non-zero.
> > >=20
> > > This is correct, I assume this isn't worthy optimizing before. Will f=
ix soon.
> >=20
> > It isn't really about optimising performance.  It is about making the c=
ode
> > easier to understand.  If we keep the region covered by the lock as sma=
ll as
> > reasonably possible, it makes it more obvious to the reader which value=
s are
> > being protected.
> >=20
> > =20
> > > > > -	spin_lock_irqsave(&conf->device_lock, flags);
> > > > > +	lock_all_device_hash_locks_irqsave(conf, &flags);
> > > > >  	clear_bit(In_sync, &rdev->flags);
> > > > >  	mddev->degraded =3D calc_degraded(conf);
> > > > > -	spin_unlock_irqrestore(&conf->device_lock, flags);
> > > > > +	unlock_all_device_hash_locks_irqrestore(conf, &flags);
> > > > >  	set_bit(MD_RECOVERY_INTR, &mddev->recovery);
> > > >=20
> > > > Why do you think you need to take all the hash locks here and elsew=
here when
> > > > ->degraded is set?
> > > > The lock is only need to ensure that the 'In_sync' flags are consis=
tent with
> > > > the 'degraded' count.
> > > > ->degraded isn't used in get_active_stripe so I cannot see how it i=
s relevant
> > > > to the hash locks.
> > > >=20
> > > > We need to lock everything in raid5_quiesce().  I don't think we ne=
ed to
> > > > anywhere else.
> > >=20
> > > init_stripe() accesses some filelds, don't need to protect?
> >=20
> > What fields?  Not ->degraded.
> >=20
> > I think the fields that it accesses are effectively protected by the new
> > seqlock.
> > If you don't think so, please be explicit.
>=20
> Like raid_disks, previous_raid_disks, chunk_sectors, prev_chunk_sectors,
> algorithm and so on. They are used in raid5_compute_sector(), stripe_set_=
idx()
> and init_stripe(). The former two are called by init_stripe().

Yes.  Those are only changed in raid5_start_reshape() and are protected by
conf->gen_lock.

If they change while init_stripe is running, the read_seqcount_retry() call=
 in
make_request() will notice the inconsistency, release the stripe, and try
again.

I guess we probably need an extra check on gen_lock inside init_stripe().
i.e. a
  do {
     seq =3D read_seqcount_begin(&conf->gen_lock);

just after the "remove_hash(sh)", and a

  } while (read_seqcount_retry(&conf->gen_lock, seq));

just before the "insert_hash(sh)".  That will ensure the stripe inserted in=
to
the hash is consistent.  The read_seqcount_retry() in make_request is still
needed to ensure that the correct stripe_head is used.

Thanks,
NeilBrown

--Sig_/B40PMAjFe5DJrJn=wB2KW=9
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUi6sIDnsnt1WYoG5AQICwQ/8Dgumo3gxDEza4L69Im9/5wo0/B3XwrEx
NDvBg8XRGkBFO1wdz/bnPo2WKB/w1vPB8M2m0aG4hNONxiA2NYE5wCbimlTvufLe
Vt1ZYK3+/N1YMlJcVf2oEBzxRop3FputYFwCC+gX1BFzv43zJSRWbO+V/I48069u
pRaMT/hx0Ga6M1zZIbxXwbIt/tvAJ/fdlaoL8Pd0Kw4zmpOcmDAH9evduZzFWoky
RoQFJXTzk6fEi/MkJJIxu5OXYZl7By9IZzjMqoE6fQ4pn3eJ2+DjXzImIBmsywOC
hsia8Qn1+7pocrnin0eq1AHtlgah7TbzWNL400XFa1eEj7nYJCxnvrJt6UjHtwvv
IDHMlTd/BEUpK6H+ayC/QVzgJJJXI34yx8HeOUW1e133LU4fF6iMl5psKcxxBKJ+
nFzO2i9RIMMxBEZPs36SM3SYs6fivZxPw6cMq5Az9tIxb9psxb+7YZGs3DgiweQy
WrASBLqnYgHOF4jP2zZNgMF96rZTnWLILL9/fJO8HSej6trpnPP2z/vpwUqe2DN4
q7uTbnqXkK32wGI4+4CZxLOOHtaeDvPTlRYrfz7GtvZZS2xO+6LjNK5qDIcYmTbP
yqtf5nNH1TV2r0r/k2VV+jJI/t2KkmF9X9xVxJG/XnxaS++hm/tabhSPLobgmiFw
pDfpD5LA2Sk=
=rZvq
-----END PGP SIGNATURE-----

--Sig_/B40PMAjFe5DJrJn=wB2KW=9--
