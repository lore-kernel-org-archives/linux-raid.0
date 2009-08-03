From: Andre Noll <maan@systemlinux.org>
Subject: Re: [PATCH/Resend] md: Push down data integrity code to personalities.
Date: Mon, 3 Aug 2009 18:40:30 +0200
Message-ID: <20090803164030.GI5174@skl-net.de>
References: <20090701083802.GC9910@skl-net.de> <19026.50240.504728.428875@notabene.brown> <20090713085442.GJ9910@skl-net.de> <19058.31706.803177.77914@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gJNQRAHI5jiYqw2y"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <19058.31706.803177.77914@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--gJNQRAHI5jiYqw2y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 15:06, Neil Brown wrote:
> > Here is a revised patch that puts calls to the new functions into
> > the ->hot_*_disk methods as you propose.
>=20
> Thanks.  Much better.
> Calling md_integrity_check from the ->error routines isn't a good idea
> though.  They can be called in interrupt context, and
> md_integrity_check can call kmalloc(..., GFP_KERNEL) which might try
> to sleep.  That would be bad.
> We don't need the call in ->error, having it in ->hot_remove_disk is
> adequate, as that is called soon after any failure (it doesn't wait
> for the sysadmin to "mdadm --remove ...".).
>=20
> So I have made that change and updated the comment accordingly.

Thanks. Sorry if this is a FAQ, but how can one tell whether a given
function may be called in interrupt context? Is there a better way
than recursively checking all its callers?

> > Side note: The patch causes the new gcc warning
> >=20
> > 	drivers/md/md.c: In function 'md_integrity_add_rdev':
> > 	drivers/md/md.c:1546: warning: unused variable 'gd'
> >=20
> > if data integrity is not compiled in. Any ideas on how to avoid it
> > without introducing an #ifdef-mess are welcome.
>=20
> I just replaced ever occurrence of "gd" with "mddev->gendisk".  It
> isn't too ugly.
> Alternately, blkdev.h could have
>=20
> static inline struct blk_integrity *blk_get_integrity(struct gendisk *dis=
k)
> {
> 	return NULL;
> }
>=20
> in place of
>=20
> #define blk_get_integrity(a)			(0)
>=20
> and then there would be no complaints about unused variables, and
> slightly improved type checking.

IMO this second alternative is be a bit cleaner and it might help
other users of blk_get_integrity() as well. Martin, are you OK with
this change to blkdev.h?

Regards
Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--gJNQRAHI5jiYqw2y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFKdxL+Wto1QDEAkw8RAgLaAJ4oVhDjHNvzHXBtrpzpPzg6a9P0pQCggcmx
HzHt9FRnAXJBFxzLKxOX4DE=
=XiQi
-----END PGP SIGNATURE-----

--gJNQRAHI5jiYqw2y--
