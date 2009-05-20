From: Andre Noll <maan@systemlinux.org>
Subject: Re: Subject [ md PATCH 4/6] : md to support page size chunks in the case of raid 0
Date: Wed, 20 May 2009 09:51:17 +0200
Message-ID: <20090520075117.GQ6403@skl-net.de>
References: <1242687989.21201.16.camel@raz> <18962.444.630305.895248@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aNvCJ41Feu8IgPyB"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <18962.444.630305.895248@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--aNvCJ41Feu8IgPyB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 19, 2009 at 10:47:56AM +1000, Neil Brown wrote:

> And 'temp' should be 'sector_t'.  'sector_div' requires a 'sector_t'
> for the first argument.

=2E..

> Again, temp must be sector_t.

How about rolling our own md_sector_div() which at least checks for
such bugs via the

        (void)(((typeof((temp)) *)0) =3D=3D ((sector_t *)0))

trick?

> > @@ -3996,14 +4001,23 @@ static int do_md_run(mddev_t * mddev)
> >  				chunk_size, MAX_CHUNK_SIZE);
> >  			return -EINVAL;
> >  		}
> > +
> >  		/*
> >  		 * chunk-size has to be a power of 2
> >  		 */
> > -		if ( (1 << ffz(~chunk_size)) !=3D chunk_size) {
> > +		if ((1 << ffz(~chunk_size)) !=3D chunk_size &&
> > +			 mddev->level !=3D 0) {
> >  			printk(KERN_ERR "chunk_size of %d not valid\n", chunk_size);
> >  			return -EINVAL;
> >  		}
>=20
> I wold really like to remove any knowledge about specific raid levels
> from the common (md.c) code and keep it all in the personality modules
> (is that a job for you Andre ??).
> So I definitely don't want to add a test for ->level here.
>=20
> So I would like to see the tests for chunk_size removed do_md_run and
> included in each personalities ->run function.  This would be a series
> of patches that adds the checks in ->run where needed, then removes it
> from md.c.  Would you like to do that?

Sure, I can give it a try. Though I'm not sure I fully understand
what would be the difference between the checks in the individual
->run functions. Currently, in do_md_run() we check that

        * chunk_size <=3D MAX_CHUNK_SIZE
        * chunk_size is a power of two
        * the rdev is at least one chunk large

None of these checks depend on the raid level, so the above change
that allows chunk sizes which are not a power of two for raid0 would
be the only difference. Are you anticipating that the requirements
of the various raid levels with respect to chunk size will further
diverge in the future?

Thanks
Andre

--aNvCJ41Feu8IgPyB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFKE7Z1Wto1QDEAkw8RAk9gAKCGFEqO21vC2xSJDZ/PKG2Na0Lf1gCgkHJH
+kTUZGFpu/sECT38HHSJsC4=
=MLS3
-----END PGP SIGNATURE-----

--aNvCJ41Feu8IgPyB--
