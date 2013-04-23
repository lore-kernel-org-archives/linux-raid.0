From: NeilBrown <neilb@suse.de>
Subject: Re: Fixes for DDF test case (race conditions in mdmon)
Date: Tue, 23 Apr 2013 17:15:48 +1000
Message-ID: <20130423171548.3d438b79@notabene.brown>
References: <1382695659-6231-1-git-send-email-mwilck@arcor.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/mAXRbhxr2Mnw=gsH.Y=9NIa"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1382695659-6231-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: mwilck@arcor.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/mAXRbhxr2Mnw=gsH.Y=9NIa
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 25 Oct 2013 12:07:31 +0200 mwilck@arcor.de wrote:

> This is a series of patches to fix the DDF tests case(tests/10ddf-create).
>=20
> Patch 3 fixes a problem that was implicitly introduced by commit=20
> c1ea5a98 - "mdadm -Db" would now print UUIDs for subarrays, but the
> wrong ones.
>=20
> Patch 5-7 are the interesting part. The DDF test case kept failing for
> me right there where a comment already says "# This failed once.=20
> The raid5 was resyncing". I tracked this down to race conditions
> between mdmon and the kernel when arrays are stopped - the kernel
> cleans up in sysfs and reading the attributes from there is unreliable.
> Files may have already vanished, read() may fail or even succeed
> with incorrect results.
>=20
> The other patches are hopefully self-explaining.
>=20
> Regards
> Martin
>=20
> Martin Wilck (8):
>   DDF: __write_ddf_structure: Fix wrong reference to ddf->primary
>   DDF: __write_init_super_ddf: just use seq number of active header
>   DDF: brief_detail_super_ddf: print correct UUID for subarrays
>   DDF: add code to debug state changes
>   monitor: don't call pselect() on deleted sysfs files
>   monitor: read_and_act: handle race conditions for resync_start
>   monitor: treat unreadable array_state as clean
>   tests/10ddf-create: omit log output check
>=20
>  monitor.c          |   38 ++++++++++++----
>  super-ddf.c        |  124 ++++++++++++++++++++++++++++++++++++++--------=
-----
>  tests/10ddf-create |    6 +--
>  3 files changed, 121 insertions(+), 47 deletions(-)

Thanks for these, and sorry for the delay in getting to them
(though the Date: field was
   Date: Fri, 25 Oct 2013 12:07:31 +0200
 so I've actually processed them 6 months before they will have been sent!!=
!)

All make sense and have been applied and push out.

NeilBrown

--Sig_/mAXRbhxr2Mnw=gsH.Y=9NIa
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUXY1JDnsnt1WYoG5AQJbDRAAutnGlggvJHGCYqrCOLYFa9Ita1P6MZXB
3KS2z4Au6K6PYp6ITVRtaS+fhSx7E2/PxqNE5aDyQ8IadibvztjVlzxCJob8eZWv
FVcKyjBbO5qDrQJZp9mbsS8avRFFlcEwKDFsHHkkggRqjLFmr9JAWyAwk5Fxji1R
qJAu9dIO27ah1o2/rjCkWTFfx0KGqdLe5fPEY22FF9Q3gTOLrre6G7M8FuZ8ro1D
tabjvpOXPEw3yuN5FrgW4puNyTPkxfygTX97uLcPLUjZ3H9mpARPfxyr2sEuyjGS
geNLruokMSAbcUXUGYYtdjwnYHQSgvPMEBokeAja4Idr0ZjPceAVbr06rONRo0Vu
kMnehDiWbfGVZ3AoiyanLfHgHbQOml8WDPuKsGvXzVzm5siUjPZJK+vosYUDcZ3k
KuFD/0+d5xNs+fDbNpmdXu8QizbnFqsIHEsflRaB9lmV1OlqrYcseamHrvZGl4pi
pvcYbp59i033byusRIYAm6kNORpmKRy/hhm8v5U5rCqxw+cE0JWzgQT3cKYN0bMl
qGJ5TfOKfn1S+hN/MDQqhZRs83sKUp6l95eQHZfi5hfTSUeChKyXb2uR4k5mZcRt
0nfwD62kT5dJtTPnR+BJFVqaKP6bTX7/PBS2te73yJaRftcmxWSrvQ0lVJEuCI39
DQP0Db0/a4A=
=TzAA
-----END PGP SIGNATURE-----

--Sig_/mAXRbhxr2Mnw=gsH.Y=9NIa--
