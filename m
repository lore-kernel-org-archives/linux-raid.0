From: Dominik Brodowski <linux@dominikbrodowski.net>
Subject: Re: [MD] Crash with 4.12+ kernel and high disk load -- bisected to
 4ad23a976413: MD: use per-cpu counter for writes_pending
Date: Tue, 8 Aug 2017 09:36:14 +0200
Message-ID: <20170808073614.GA21316@light.dominikbrodowski.net>
References: <ee7921d2-d3ff-2381-1f05-2c07b8001d08@unsolicited.net>
 <c2df7906-67b2-b33f-0e82-49e6ef53f5f1@unsolicited.net>
 <20170807112025.GA3094@light.dominikbrodowski.net>
 <87k22esfuf.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="BOKacYhQ+x31HxR3"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87k22esfuf.fsf@notabene.neil.brown.name>
Sender: linux-kernel-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Shaohua Li <shli@fb.com>, David R <david@unsolicited.net>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, tj@kernel.org
List-Id: linux-raid.ids


--BOKacYhQ+x31HxR3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 08, 2017 at 05:01:28PM +1000, NeilBrown wrote:
> On Mon, Aug 07 2017, Dominik Brodowski wrote:
>=20
> > Neil, Shaohua,
> >
> > following up on David R's bug message: I have observed something similar
> > on v4.12.[345] and v4.13-rc4, but not on v4.11. This is a RAID1 (on bare
> > metal partitions, /dev/sdaX and /dev/sdbY linked together). In case it
> > matters: Further upwards are cryptsetup, a DM volume group, then logical
> > volumes, and then filesystems (ext4, but also happened with xfs).
> >
> > In a tedious bisect (the bug wasn't as quickly reproducible as I would =
like,
> > but happened when I repeatedly created large lvs and filled them with s=
ome
> > content, while compiling kernels in parallel), I was able to track this
> > down to:
> >
> >
> > commit 4ad23a976413aa57fe5ba7a25953dc35ccca5b71
> > Author: NeilBrown <neilb@suse.com>
> > Date:   Wed Mar 15 14:05:14 2017 +1100
> >
> >     MD: use per-cpu counter for writes_pending
> >    =20
> >     The 'writes_pending' counter is used to determine when the
> >     array is stable so that it can be marked in the superblock
> >     as "Clean".  Consequently it needs to be updated frequently
> >     but only checked for zero occasionally.  Recent changes to
> >     raid5 cause the count to be updated even more often - once
> >     per 4K rather than once per bio.  This provided
> >     justification for making the updates more efficient.
> >
> >     ...
>=20
> Thanks for the report... and for bisecting and for re-sending...
>=20
> I believe I have found the problem, and have sent a patch separately.
>=20
> If mddev->safemode =3D=3D 1 and mddev->in_sync !=3D 0, md_check_recovery()
> causes the thread that calls it to spin.
> Prior to the patch you found, that couldn't happen.  Now it can,
> so it needs to be handled more carefully.
>=20
> While I was examining the code, I found another bug - so that is a win!
>=20
> Thanks,
> NeilBrown


Nice catch. Thanks! Will give it (both patches at once) a try on the test
system immediately.

Thanks,
	Dominik

--BOKacYhQ+x31HxR3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEmgXaWKgmjrvkPhLCmpdgiUyNow0FAlmJaeYACgkQmpdgiUyN
ow3XSxAAsHGa78KRK3R8waKCrNqldZp63tAeSA1+x3jWGrapd6lZYk6cmVYI61At
zSIjLN4n/QIqxcdopVc1U7B8tBRvr2sulgyQrLJqEMfCsNcvPjrSbTmX2Ed6fkbk
UL5WXsSncl9u5TBGIVcgizTGIphRs42PuY40acMrrsZMegUCGa9NWOdGN/PTmars
FcfXmS2/mykCB+6pudigfGamWrcIAM4FwlOsDcexWYKQU8wGUC4+fG75UkuhamTl
QkONOWR9aa5vi1knWAKSjcP33Kz863aVsWZ3tP55yG5TpWEvnFtVMJGMe01RzuyZ
wQYMZeyHAPOSUvTRwvF+uofjq7wco4U53o0FARKYyMkCnsLBd2jmDOiTA7PsRIn2
REwt8tztLo+xvrPO/8Z+ocjLUn0VjA8muKEXADeM/OS9kAPfO0SO6tQxeOqWaD8E
qSYG+lKyIZFkqIx9AHoGBWymdtinjpPwciTx9QWIhF1k6H0aG0DIvxKZwwLo7EB3
k8I/QtKaodDgfGZBkjYP+8Dd6tX++obDGLNjs+5oBlo3PIHEUOHsWlYsOFFpk5g9
t/3UT8GzBuTX43jMicl5twaeEwyqz1ntlg/q5iHechZn8FhMLI+4tDqioANR0ylW
QbyaTlBjc7w9oJrOk2tBS8t/d0T3bYm2B2Pem40+3ZUgdGLmRdo=
=IlGe
-----END PGP SIGNATURE-----

--BOKacYhQ+x31HxR3--
