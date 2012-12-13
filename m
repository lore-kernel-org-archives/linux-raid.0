From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/2] lib/raid6: Add AVX2 optimized gen_syndrome
 functions
Date: Thu, 13 Dec 2012 19:53:17 +1100
Message-ID: <20121213195317.540c55b4@notabene.brown>
References: <1354309840-9360-1-git-send-email-james.t.kukunas@linux.intel.com>
	<20121213083509.GZ2095@yliu-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/bD4hVWAf=j.n7TN0tWOkq1M"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20121213083509.GZ2095@yliu-dev.sh.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Cc: Jim Kukunas <james.t.kukunas@linux.intel.com>, Linux Raid <linux-raid@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
List-Id: linux-raid.ids

--Sig_/bD4hVWAf=j.n7TN0tWOkq1M
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 13 Dec 2012 16:35:09 +0800 Yuanhan Liu <yuanhan.liu@linux.intel.com>
wrote:

> On Fri, Nov 30, 2012 at 01:10:39PM -0800, Jim Kukunas wrote:
> > From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
> >=20
> > Add AVX2 optimized gen_syndrom functions, which is simply based on
> > sse2.c written by hpa.
> >=20
> > Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
> > Reviewed-by: H. Peter Anvin <hpa@zytor.com>
> > Signed-off-by: Jim Kukunas <james.t.kukunas@linux.intel.com>
> > ---
> >  include/linux/raid/pq.h |   3 +
> >  lib/raid6/Makefile      |   2 +-
> >  lib/raid6/algos.c       |   9 ++
> >  lib/raid6/avx2.c        | 251 ++++++++++++++++++++++++++++++++++++++++=
++++++++
> >  lib/raid6/test/Makefile |  12 ++-
> >  5 files changed, 275 insertions(+), 2 deletions(-)
> >  create mode 100644 lib/raid6/avx2.c
>=20
> Hi Neil,
>=20
> Ping...

Ahh ..... yeah ... sorry...

Applied.

NeilBrown

--Sig_/bD4hVWAf=j.n7TN0tWOkq1M
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUMmXfTnsnt1WYoG5AQLK9Q//Zj4ga24eypKs2G1CC0VkzVDAQhLbfIPN
Jm4B25g3PzsQFPYW+Uj72oFgXw52MyIb0GcNuluisSt29l/uIau2JIpJn0y1kcFP
gAIPP8oMquMG0rSrd5m+ouM9a21EwJJYpdP+6Mo4a8wyMHENUc8j2iEppOCgSY5h
dqMVQ3yhIiuZRlMTOyAbRIAJ3HrJaw0xJRDdrEa4bJmCVNGBURtvIN0reC+HnooH
CGfVtinSWXTi7leKsRaUf0cSnnL8DDZgvn9wJFal0jxsZg+7p8JF6YVBeOo80twi
iMbcS86jWLdtbHUXmLnsWvqoRVwk9H15L7MCDP09r6jCL2g9D8DIE1zXzkdNxS36
lNLSg4qE+cyDq6p5qCM//wbTE86Pi/Mi8PqNfZ7AmJVVUISia+5moYx1PPZnGrXc
JnNuO6YQ4gM5eAau9L5KTpaVP0kIk3c5MhebLOiS1F3mOpElCOdEuWx8UEbq0Lca
lcZf7MOJ/T4V2Lbl08nIzHySYNwFc4LAIbPDoAqPuds++oyXAq+CTnKOYRDBzANN
I8kTL+l1JfdcQwolfNiWCsWZ0YBiZgWTr5Ump5PkqV/nj7D97BLfQ65mi2nWJk2X
JITIPoEGaqKkZfZkeiLtetHKGO/ZNoZIDDhTN73Abgua4To4T9kQJRihYd0jG3Ak
MckTIgqhyds=
=qdBn
-----END PGP SIGNATURE-----

--Sig_/bD4hVWAf=j.n7TN0tWOkq1M--
