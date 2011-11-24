From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] imsm: incorrect incremental behavior because of wrong
 index used
Date: Thu, 24 Nov 2011 16:23:39 +1100
Message-ID: <20111124162339.56936d08@notabene.brown>
References: <20111123165943.25613.20161.stgit@gklab-154-231>
	<CABE8wwtdDLoggFJev-BSB94VGz+3Y_7fU1o5GJxR53-UU+asGg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/UxzSmr85Z/zg6NcrR+_RgZd"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CABE8wwtdDLoggFJev-BSB94VGz+3Y_7fU1o5GJxR53-UU+asGg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>, linux-raid@vger.kernel.org, marcin.labun@intel.com, ed.ciechanowski@intel.com, Doug Ledford <dledford@redhat.com>
List-Id: linux-raid.ids

--Sig_/UxzSmr85Z/zg6NcrR+_RgZd
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Wed, 23 Nov 2011 10:56:21 -0800 "Williams, Dan J"
<dan.j.williams@intel.com> wrote:

> On Wed, Nov 23, 2011 at 8:59 AM, Przemyslaw Czarnowski
> <przemyslaw.hawrylewicz.czarnowski@intel.com> wrote:
> > Incremental in some cases prematurely assembles degraded arrays due to
> > wrong index used in code which counts missing disks
> >
> > Signed-off-by: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski=
@intel.com>
>=20
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
>=20
> > ---
> > =A0super-intel.c | =A0 =A02 +-
> > =A01 files changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/super-intel.c b/super-intel.c
> > index 360c4cc..a0672bf 100644
> > --- a/super-intel.c
> > +++ b/super-intel.c
> > @@ -2539,7 +2539,7 @@ static void getinfo_super_imsm(struct supertype *=
st, struct mdinfo *info, char *
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * (catches single-degraded vs double-de=
graded)
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 */
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0for (j =3D 0; j < map->num_members; j++)=
 {
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __u32 ord =3D get_imsm_or=
d_tbl_ent(dev, i, 0);
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __u32 ord =3D get_imsm_or=
d_tbl_ent(dev, j, 0);
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0__u32 idx =3D ord_to_idx=
(ord);
> >
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!(ord & IMSM_ORD_REB=
UILD) &&
> >
> >


Applied, thanks.

NeilBrown


--Sig_/UxzSmr85Z/zg6NcrR+_RgZd
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTs3U2znsnt1WYoG5AQI5gQ//fW78r3HSGMH1dHSeh56lhNvEkAIaCdkl
AoAm1NCSR72aHBf9IaeKzV+fXYELMLj5hzC2isMVCwfcR/rzD5olCjltBrySG/9f
f7HOpU+aG7p9BfWGfovWlgSAVlXBvVOdVpxawMPt3z8YIC3kWLQW3z6bugtrGDoT
ulDkuG1sXqQGfHz0qxoe7onTLfxhxllvm/518y0DECbMYrCnTikOW2yE0VCJC3KA
AFnrJHLHxmSkrTtfycn2XPc0Amwo6HP5u3PXlcU3E1abgKgqO8Uqdd83S2mkZrrM
raY3CK7Y1bpy8vlNFcHcH0osxeWkmg+BS+TfjJNft+F12sZiKadaVWWuUzTTUYh+
7pTXRQk65GO5JhjOGynwjL3X2g6Rjj8WftLAsJMHSCl6vx8Vwz2zdMnEPjkcb89F
IuHzDxuZNQ1YYb/ff5a65XIe2srvnOUdZK3SnT7xMi6oo9MZ83hM9yqdptkrh5U3
7QZblWCFgxzel0WP5UY8/jGfJGjRQaOPznjVKJeAWBV0Jtz/d1Xo/5yPDZRlXtyU
vZunEVZrn4AdPenz2b9gVyp9Nolxj+7zC2iNZdy3t1j7hPyq/6552J3iVjTVcgWb
Mdjs6yXLVddXVT+nsRr9dSZBNocReWIkBnNaO+ClxOpmWyzbtB3epKSGCUGO4WsF
Eg86lBh2zb4=
=IhRH
-----END PGP SIGNATURE-----

--Sig_/UxzSmr85Z/zg6NcrR+_RgZd--
