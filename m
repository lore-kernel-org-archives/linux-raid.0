From: NeilBrown <neilb@suse.de>
Subject: Re: [patch 3/3] raid5: relieve lock contention in
 get_active_stripe()
Date: Tue, 10 Sep 2013 14:06:29 +1000
Message-ID: <20130910140629.702683da@notabene.brown>
References: <20130828143252.1d48b04b@notabene.brown>
	<20130828063953.GD17163@kernel.org>
	<20130903160858.2175a41b@notabene.brown>
	<20130903070228.GA25041@kernel.org>
	<20130904164132.177701e0@notabene.brown>
	<20130905054035.GA30216@kernel.org>
	<20130905162910.179ea808@notabene.brown>
	<20130905091822.GA8401@kernel.org>
	<20130909043318.GA27517@kernel.org>
	<20130910111318.1d19e8d3@notabene.brown>
	<20130910023555.GA17907@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/r8QVTGJEjaIgH0oi3hvAkwt"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130910023555.GA17907@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-raid.ids

--Sig_/r8QVTGJEjaIgH0oi3hvAkwt
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 10 Sep 2013 10:35:55 +0800 Shaohua Li <shli@kernel.org> wrote:

> On Tue, Sep 10, 2013 at 11:13:18AM +1000, NeilBrown wrote:
> > On Mon, 9 Sep 2013 12:33:18 +0800 Shaohua Li <shli@kernel.org> wrote:
> > >  		} else {
> > > +			spin_lock(&conf->device_lock);
> > > +
> > >  			if (atomic_read(&sh->count)) {
> > >  				BUG_ON(!list_empty(&sh->lru)
> > >  				    && !test_bit(STRIPE_EXPANDING, &sh->state)
> > > @@ -611,13 +725,14 @@ get_active_stripe(struct r5conf *conf, s
> > >  					sh->group =3D NULL;
> > >  				}
> > >  			}
> > > +			spin_unlock(&conf->device_lock);
> >=20
> > The device_lock is only really needed in the 'else' branch of the if
> > statement.  So can we have it only there.  i.e. don't take the lock if
> > sh->count is non-zero.
>=20
> This is correct, I assume this isn't worthy optimizing before. Will fix s=
oon.

It isn't really about optimising performance.  It is about making the code
easier to understand.  If we keep the region covered by the lock as small as
reasonably possible, it makes it more obvious to the reader which values are
being protected.

=20
> > > -	spin_lock_irqsave(&conf->device_lock, flags);
> > > +	lock_all_device_hash_locks_irqsave(conf, &flags);
> > >  	clear_bit(In_sync, &rdev->flags);
> > >  	mddev->degraded =3D calc_degraded(conf);
> > > -	spin_unlock_irqrestore(&conf->device_lock, flags);
> > > +	unlock_all_device_hash_locks_irqrestore(conf, &flags);
> > >  	set_bit(MD_RECOVERY_INTR, &mddev->recovery);
> >=20
> > Why do you think you need to take all the hash locks here and elsewhere=
 when
> > ->degraded is set?
> > The lock is only need to ensure that the 'In_sync' flags are consistent=
 with
> > the 'degraded' count.
> > ->degraded isn't used in get_active_stripe so I cannot see how it is re=
levant
> > to the hash locks.
> >=20
> > We need to lock everything in raid5_quiesce().  I don't think we need to
> > anywhere else.
>=20
> init_stripe() accesses some filelds, don't need to protect?

What fields?  Not ->degraded.

I think the fields that it accesses are effectively protected by the new
seqlock.
If you don't think so, please be explicit.


Thanks,
NeilBrown

--Sig_/r8QVTGJEjaIgH0oi3hvAkwt
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUi6axTnsnt1WYoG5AQKyIg//ZMPPrQo7U63Ojm/6J7tctewWJIvQ1iyU
5SW2pgDwsZJ/KTFfI/XBkoCIOABCL3jgtqgA9cL3oyJww1SGu7bnm8uY3ztSKe5B
xC7gv6S64KGmpz3GQDpn0K/ywu221ghLM2YWyNs9moKucRcbknflKdKdLSm1V0GI
jNVI01k/qhZTBTgC61t2TM3xW4m5ODynuUN0t1BHyGa6lBd+/CpcwzRPtoYIMRJw
Mf54jGSMMjG4PQ9EYJKbQoMLrutclNDyCQdiwN4wZW9AwL/KKgI1Kif0Sl+VATeQ
2Ih+9DeomDB+EwThTXSvT2jXMXAZ2KCo7EH+RIJhUEQKlbtrE7Aa4az+Oce4imO9
1dWv9UnrYoXWRORbcVfRSIalqZQPczCuN+PFvwdOpvza4fv/vcNlktqF6/uxONGI
MJIEi5dIILYuJ6AslVKbIjJIWvMLETKbT4kBlVTTA7wY9ohDTh5p2c4Sqbgb1Hra
HQMSfkEtO2CiV4uyw3qtJP3aG3WyJncNfWzmguvik2zMN+lQsVgHWV1j66GXZoxm
HAAFW/5OFCaFtSQ75ciO0ZY39u1DG0Y261iVOaOk5HtkcHbbtP02VKSAiNyBACBW
34T5SgXrDPh0Ypj6/F+u3H6qOf3LUAEfRwZVYM6ZWtE7WZvyZH7LAEMfYkfkgjFX
GUj+LwLGO4I=
=DNnw
-----END PGP SIGNATURE-----

--Sig_/r8QVTGJEjaIgH0oi3hvAkwt--
