From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] imsm: fix: Allowed to create 2 volumes with total size
 less	then maximum.
Date: Mon, 14 Nov 2011 16:43:11 +1100
Message-ID: <20111114164311.2df2f269@notabene.brown>
References: <20111110105154.19327.77169.stgit@gklab-128-192.igk.intel.com>
	<F9123E44003394499FDD2B17C60621D40500CC@IRSMSX101.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/nTzEogdXk8EqVYlkPCO_69R"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <F9123E44003394499FDD2B17C60621D40500CC@IRSMSX101.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Labun, Marcin" <Marcin.Labun@intel.com>
Cc: "Orlowski, Lukasz" <lukasz.orlowski@intel.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>
List-Id: linux-raid.ids

--Sig_/nTzEogdXk8EqVYlkPCO_69R
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Thu, 10 Nov 2011 13:30:32 +0000 "Labun, Marcin" <Marcin.Labun@intel.com>
wrote:

> Probably it would be more convenient to set the only possible size and cr=
eate a volume with a warning.
> Marcin

I disagree.  This code only applies if the user has explicitly requested a
particular size.  If that request cannot be fulfilled, it shouldn't be
attempted at all.

I have applied the original patch.

Thanks,
NeilBrown


>=20
>=20
> > -----Original Message-----
> > From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> > owner@vger.kernel.org] On Behalf Of Lukasz Orlowski
> > Sent: Thursday, November 10, 2011 11:52 AM
> > To: neilb@suse.de
> > Cc: linux-raid@vger.kernel.org; Williams, Dan J
> > Subject: [PATCH] imsm: fix: Allowed to create 2 volumes with total size
> > less then maximum.
> >=20
> > mdadm allows to create second volume on the same disk set, whose size
> > is
> > less then the free space left in the container (with IMSM_NO_PLATFORM
> > undefined or set to 0). This is an OROM compatibility issue.
> > It is fixed by verifying whether IMSM_NO_PLATFORM is set and for
> > the second volume creation scenario, requested size is verified against
> > remaining available space.
> >=20
> > Signed-off-by: Lukasz Orlowski <lukasz.orlowski@intel.com>
> > ---
> >  super-intel.c |    9 +++++++++
> >  1 files changed, 9 insertions(+), 0 deletions(-)
> >=20
> > diff --git a/super-intel.c b/super-intel.c
> > index 215679d..4ebee78 100644
> > --- a/super-intel.c
> > +++ b/super-intel.c
> > @@ -5276,6 +5276,15 @@ static int validate_geometry_imsm_volume(struct
> > supertype *st, int level,
> >  			i +=3D dl->extent_cnt;
> >=20
> >  	maxsize =3D merge_extents(super, i);
> > +
> > +	if (!check_env("IMSM_NO_PLATFORM") &&
> > +		mpb->num_raid_devs > 0 && size && size !=3D maxsize) {
> > +		fprintf(stderr, Name ": attempting to create a second "
> > +			"volume with size less then remaining space. "
> > +			"Aborting...\n");
> > +		return 0;
> > +	}
> > +
> >  	if (maxsize < size || maxsize =3D=3D 0) {
> >  		if (verbose)
> >  			fprintf(stderr, Name ": not enough space after merge
> > (%llu < %llu)\n",
> >=20
> > ---------------------------------------------------------------------
> > Intel Technology Poland sp. z o.o.
> > z siedziba w Gdansku
> > ul. Slowackiego 173
> > 80-298 Gdansk
> >=20
> > Sad Rejonowy Gdansk Polnoc w Gdansku,
> > VII Wydzial Gospodarczy Krajowego Rejestru Sadowego,
> > numer KRS 101882
> >=20
> > NIP 957-07-52-316
> > Kapital zakladowy 200.000 zl
> >=20
> > This e-mail and any attachments may contain confidential material for
> > the sole use of the intended recipient(s). Any review or distribution
> > by others is strictly prohibited. If you are not the intended
> > recipient, please contact the sender and delete all copies.
> > N=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BDr=EF=BF=BD=EF=BF=BDy=EF=
=BF=BD=EF=BF=BD=EF=BF=BDb=EF=BF=BDX=EF=BF=BD=EF=BF=BD=C7=A7v=EF=BF=BD^=EF=
=BF=BD)=DE=BA{.n=EF=BF=BD+=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD{=EF=BF=BD=EF=
=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD{ay=EF=BF=BD=1D=CA=87=DA=99=EF=BF=BD,j=0D=
=EF=BF=BD=EF=BF=BDf=EF=BF=BD=EF=BF=BD=EF=BF=BDh=EF=BF=BD=EF=BF=BD=EF=BF=BDz=
=EF=BF=BD=1E=EF=BF=BDw=EF=BF=BD=EF=BF=BD=EF=BF=BD
> >=20
> > =EF=BF=BD=EF=BF=BD=EF=BF=BDj:+v=EF=BF=BD=EF=BF=BD=EF=BF=BDw=EF=BF=BDj=
=EF=BF=BDm=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=0D=EF=BF=BD=EF=BF=BD=EF=BF=
=BD=EF=BF=BDzZ+=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=DD=A2j"=EF=BF=
=BD=EF=BF=BD!=EF=BF=BDi


--Sig_/nTzEogdXk8EqVYlkPCO_69R
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTsCqejnsnt1WYoG5AQIMkRAAtdVz6br6lkJzQqybuCMF0mWIw9HugWZ7
yZ0eEqFg6/+c5Q0CIAYcC9jAkISYsq9N+5sgQ4ot6623JkO5wHnLgOHbIZ+BUw52
11F7tQvIusRb4JZJYgTSlcn9vU1grog67wxaxpQNSKup6gApO8c2952/P/Rm6fB7
XoAXCpaMi5611gZ8Mybe+N7Rj9PggBH0jdmC2UTVbtAHfDnEpdHTH1XUPbSA2Vtx
QuP90sJjiKY8P1hfLnUXtYvTssNdp9xfzbJMatEEuJbV4MLwA1WStexiIc3t5RJM
w8l4MJp6MbT8DAhsguJrDxomBniufcFhLtsxuok5sqSPSGDr30B7PKPuM+IWbpJY
8bS/S+Y7R0rEz7GnEbnqV8JUOqCJ0QXxCeHbfzpgxH+zinXA7xKmXnZwu3f9JGWH
5XB9aoWNGuAH4tEdOUwiB044qirV80Qj29ANqlMQA4Tcol0LXwEnmuieHZeuGy29
QLLvDswNlfGOgQtnExyE24z8oCiy6fOM9cLUg5wsXynT6RZyRSBDb9yC3x1NdiWM
9ia+eVnNgUCUXl9p9Ogup+OpKYBT9OPYErDLEUN10LyVDxZlkZK9JpDSsAldXdyN
6ZW47/zg3WoB0WWqYkMgIlyAQi0nqucYOB36XxIZGYZbmGiB7AZvvzkPomDULcX+
hI5F79ZQjR8=
=6Y5F
-----END PGP SIGNATURE-----

--Sig_/nTzEogdXk8EqVYlkPCO_69R--
