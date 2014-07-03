From: NeilBrown <neilb@suse.de>
Subject: Re: PATCH: RAID10-layout-descriptions
Date: Thu, 3 Jul 2014 16:58:39 +1000
Message-ID: <20140703165839.3fc182ea@notabene.brown>
References: <1402852943.4708.8.camel@heisenberg.scientia.net>
	<20140616064317.22366dea@notabene.brown>
	<1402936468.4787.24.camel@heisenberg.scientia.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/YBCEVnPR4q96x0LIfjCojny"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1402936468.4787.24.camel@heisenberg.scientia.net>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/YBCEVnPR4q96x0LIfjCojny
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 16 Jun 2014 18:34:28 +0200 Christoph Anton Mitterer
<calestyo@scientia.net> wrote:

> On Mon, 2014-06-16 at 06:43 +1000, NeilBrown wrote:=20
> > tbl I can live with.  Unicode I cannot.
> > In some contexts Unicode may be ok (non-English words) but not for
> > line-drawing characters and not for special punctuation.
> Well but you know, that tbl(1) won't work for your PDF/HTML rendering
> either? At least it didn't when I checked it.

True, it won't work for some renderers.  That is unfortunate but I am willi=
ng
to make some sacrifices I guess.

 man -l -Thtml md.4 > md.html

creates some HTML and some png files which look readable in a browser,
including the tables.


>=20
> Anyway... I guess there's no benefit in discussing over Unicode/tbl
> here... :)
>=20
>=20
> I've attached a new set of patches... the second replaces all the
> unicode stuff with similar ASCII chars.
> I'd suggest to merge both and not just the result of them, so we have
> the fancy Unicode stuff in git as well, should we ever decide to upgrade
> to post 1991 ;-)

Thanks for being accommodating of my irrational preferences.

>=20
>=20
> Hope that helps and you can merge them largely as is,... please tell me
> whether or not (or whether other tweaks are needed)... so that I can
> clean up that branch.

I've merged all your patches together and made a few little modification of
my own - nothing major.
I changed the Makefile to use "man -l filename" as that seems to be the
"right" thing to do, rather than "nroff -man".  So tbl is handled correctly.

I've added a separate patch with the biggest change I made which was to
replace "Device" with "Dev" in the 5-device arrays so that that table fits =
in
the width of a (standard, old fashioned, 72 column) page.

>=20
> Still have another branch with information you gave me back then, about
> how reads and writes are done... I'll come up with that in another mail.

Should I just pull your description-of-reads-and-writes branch (and impose =
my
style requirements on it)?

Thanks for your efforts and persistence!!

NeilBrown

--Sig_/YBCEVnPR4q96x0LIfjCojny
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU7T/Hznsnt1WYoG5AQJSeA//atB0Jc07ReMgqN1UVxs6pKKnykFIETgB
d2oJbCvtrFqynNnr517Z+S24GqWbpXzp9witHIKWxMTERwkQQHUZQgNb+g20lqV6
msGowuNMbOFTjnPvR8PnEf91F+WHLXfd3QTH4Ihc76f1s+s17rVGM2q4wOQmeTZs
zmNa573jG1GKY9Lwsz0p01EdSe19N9s1pEoo/KmAnYjCoFpdO0I33ykdtW9RBzdS
WVvdGohezIOmp4rBM4T5VuD37mwzP1CAq5QYOixJD6VN+KjuVgwqEcGBywn4V7DV
jK/yG+S8OgHpoq6RXJgm/DLGefjaE6Cc79/csSj32ByrW8b57A6gEMJ/7m3WYa1O
BDtMDy9dqMs41q055EBbqlvJ0fNO0rcaAv1EuXh+J5B3Mk/iPCbNsfHRoyHMVbxI
Mme1bkVE/a8nqMv8Zru4mDrGyIS8BZ2AmXtwZ9yS6ywnNucYqbI1bQpi8gjBNpWY
W3FBBm95qub3m2dDLs5730LuQZCUOfzEk/rYy9kPBEMEWlCmY80rYM+Jppz05Ib+
iNQqffgffnE80/bX64Lx6bD2WC5ouUTC1Nvq6oFaaz+xykyxESUrEef3vatoHoGg
tL/68YxbFSSKzUWr/w60CC9PRBE/RsqeIe4NnK++OTmOgSoQUoFnwUKlTAUEAuvp
X8oNEcptNQg=
=D/Q+
-----END PGP SIGNATURE-----

--Sig_/YBCEVnPR4q96x0LIfjCojny--
