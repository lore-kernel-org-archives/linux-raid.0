From: NeilBrown <neilb@suse.de>
Subject: Re: Array died during grow; now resync stopped
Date: Thu, 5 Feb 2015 15:40:34 +1100
Message-ID: <20150205154034.2d2b629f@notabene.brown>
References: <loom.20150202T100454-579@post.gmane.org>
	<20150203064056.5dbba8c5@notabene.brown>
	<trinity-d6d8d6b9-e19b-4ff6-a39f-3748b5fb2e13-1422959753855@3capp-gmx-bs42>
	<20150204174556.426eb865@notabene.brown>
	<trinity-85824e10-6eeb-490e-91e9-29cac6bb884e-1423051086472@3capp-gmx-bs24>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/eAV5e2YDd1Utw/1v/oIOsGS"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <trinity-85824e10-6eeb-490e-91e9-29cac6bb884e-1423051086472@3capp-gmx-bs24>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?SsO2cmc=?= Habenicht <j.habenicht@gmx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/eAV5e2YDd1Utw/1v/oIOsGS
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 4 Feb 2015 12:58:06 +0100 "J=C3=B6rg Habenicht" <j.habenicht@gmx.de=
> wrote:

> It works! :-)) The array syncs!

Excellent!

>=20
>=20
> > > >What does
> > > >cat /proc/1671/stack
> > > >cat /proc/1672/stack
> > > >show?
> > >=20
> > > $ cat /proc/1671/stack
> > > cat: /proc/1671/stack: No such file or directory
> >=20
> > I guess you don't have that feature compiled into your kernel.
>=20
> Guess so. I'm going to look to the missing CONFIG_ line.

CONFIG_STACKTRACE ... in case you haven't found it already.

> >=20
> > And this is stuck in the same place.... what what is consuming all the
> > stripes I wonder....
>=20
> Do you like me to collect more information?

No thanks, the required information was further down.  They were all consum=
ed
by the reshape (which needs at least twice the largest chunk size).


> > If you double it, the problem should go away.
> >=20
> > mdadm should  do that for you .... I wonder why it didn't.
> >=20
>=20
> Do you like to have more test results?

I had a look at the code and it was fairly obvious.  mdadm adjusts the stri=
pe
cache based on the 'old' chunk size.  It never includes the 'new' chunk size
in those calculations.  I've made a note to fix that.

Thanks,
NeilBrown


--Sig_/eAV5e2YDd1Utw/1v/oIOsGS
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVNL0Qjnsnt1WYoG5AQLQFRAApwVJaucU90HnzdkL9dSiR7kelwo0qwXD
fWE1PhDEge434YRObs7hO/YU5UFfVKrCGT0ANRF8urURMiBMLu9Brb2QyLhS+T6y
KhTwFfahsmMU5gFCszL3fXdFR0NIfiNniCuM1bsUwE/hS4TxAr40o1Asq1ELa3M0
PRvv96rk0wSj+TdStudI3/Y5LpIX1lvS0V61CaCaYwFKh6uuSdJ7yr1kDyg7I9ey
V1sb+C8QR9YnUVcMKA6MYAyisWrIKkhx9ujVJEy1/cs5Xu+iZev4aNS/pK5jhtyb
DMaYwtjjWflVdA2eGiyDKNOeCv+WcJK0PTgC9bIImsAKf9GYRSkZOEotGGss3CVA
cISilpF+C8+2cdp+zdtgajn06khOZjjS+NH9EFpOXNlh89SBoCWTpA/yUg3iAZ9P
LBfI3fsoSqr/udVPj2C8OmFDpNGeI3mJn59NFcpPzs1XaaS/jNy2e+JVeuseqD/6
4vMMpDVCUedAEiVp4wsYM5MOA6yK+O/88BNS1uIQF2SxULwcPunFAseBD+peRUzM
PwNY6nY7xn2oaP34NNBVocs+FP77gvPm9CxSggcXOo92cg+QJUJNyfnLViG7EYzZ
9YFXDJrMBd67EH0AgVAhnR9EIirxyI9gy+f67Co5g7tz+VFmIANkEVseAwWKE7OJ
Hb9K4APHlKQ=
=i0Nt
-----END PGP SIGNATURE-----

--Sig_/eAV5e2YDd1Utw/1v/oIOsGS--
