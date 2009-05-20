From: Andre Noll <maan@systemlinux.org>
Subject: Re: Subject [ md PATCH 4/6] : md to support page size chunks in the case of raid 0
Date: Wed, 20 May 2009 15:46:26 +0200
Message-ID: <20090520134626.GK11504@skl-net.de>
References: <1242687989.21201.16.camel@raz> <18962.444.630305.895248@notabene.brown> <20090520075117.GQ6403@skl-net.de> <18963.55483.993420.606497@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GmiNL4+5WUWrod5m"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <18963.55483.993420.606497@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>
List-Id: linux-raid.ids


--GmiNL4+5WUWrod5m
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 20:17, Neil Brown wrote:

> > How about rolling our own md_sector_div() which at least checks for
> > such bugs via the
> >=20
> >         (void)(((typeof((temp)) *)0) =3D=3D ((sector_t *)0))
> >=20
> > trick?
>=20
> Interesting idea..
> You would still need to eyeball that code to make sure md_sector_div
> was used instead of sector_div, though I guess that is more obvious..

We could change all sector_div()s to md_sector_div() in one patch
and refuse to take patches that introduce new uses of sector_div().

> Maybe sector_div should have that test in it globally...

Actually such tests are already in the sector_div version in
asm-generic/div64.c, but that gets only used if CONFIG_LBD is set. If
it is unset, no checks are performed at all. So yes, I believe
it makes sense to add these checks there as well. As Jens (CC'ed)
is the person who touched this code most recently (back in 2007),
he can probably tell best if such a change would be appreciated.

> Though I've actually hit more problems with the second arg not being
> "unsigned long" like it should be.

At I understand it, the second arg should be u32, but it's also OK
to call sector_div() with a 64-bit second arg as long as the _value_
of this arg fits into a u32. As this condition can only be checked at
runtime and with a performance penalty, it might be worth to fix up
all md users of sector_div() which use something different than u32
as the second arg. An md_sector_div() with additional checks could
help to find all such places. And the usual "this must be sector_t"
review comment would then become "please use md_sector_div()" :-)

> What I was suggesting for you is the previous paragraph.  Removing all
> knowledge about specific raid levels from md.c.
> So where ever md.c tests the value for mddev->level, ask the question:
> how can this information be extracted from the module rather than
> having this hard-coded test.
>=20
> Probably the easiest would be moving
>=20
>=20
> 	if (mddev->recovery_cp !=3D MaxSector &&
> 	    mddev->level >=3D 1)
> 		printk(KERN_ERR "md: %s: raid array is not clean"
> 		       " -- starting background reconstruction\n",
> 		       mdname(mddev));
>=20
> into various ->run methods.
> Probably the hardest would be all the messing with LEVEL_MULTIPATH.
> Somewhere in between would be the tests for which levels support
> bitmaps.
>=20
> In general, we just want to delay the test until we are in personality
> code and do it there.
>=20
> Does that make sense?

Yes, it does, and I will have a look at it. One immediate problem I
can see is that the straight-forward pushdown approach will add quite
some code duplication. For example the above check for MaxSector and
the prink would have to be duplicated to each ->run function except
raid0, linear and multipath.

Adding a common check_reconstruction() function to md.c which is called
=66rom the personalities that care would avoid the duplication but looks
a bit like over-engineering in this particular case. However, it might
be the right approach for more complicated "semi-personality-dependent"
code.

I suppose it has to be decided on a per-case basis which approach fits
best.

Thanks
Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--GmiNL4+5WUWrod5m
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFKFAmyWto1QDEAkw8RArjBAKCji19hDrlTvho/i/9u39OvkFL8awCfZUas
w2cHxIEmMsGQfHv/k1T9BkA=
=Pmqx
-----END PGP SIGNATURE-----

--GmiNL4+5WUWrod5m--
