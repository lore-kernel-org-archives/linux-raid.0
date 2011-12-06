From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] imsm: fix: correct checking newly missing disks
Date: Tue, 6 Dec 2011 12:10:25 +1100
Message-ID: <20111206121025.1e20e55a@notabene.brown>
References: <20111114145252.21148.62905.stgit@gklab-128-085.igk.intel.com>
	<CAA9_cmccLh=zYnqkpdhjkYZQQK26oUN4xqiMyycYHoLSr19zKg@mail.gmail.com>
	<D9FFE20C522965449E182ACE73889AEB052370@IRSMSX101.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/l_JT32wSm42=1OdnTayZKY="; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <D9FFE20C522965449E182ACE73889AEB052370@IRSMSX101.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Dorau, Lukasz" <lukasz.dorau@intel.com>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Kwolek, Adam" <adam.kwolek@intel.com>
List-Id: linux-raid.ids

--Sig_/l_JT32wSm42=1OdnTayZKY=
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Thu, 1 Dec 2011 14:23:16 +0000 "Dorau, Lukasz" <lukasz.dorau@intel.com>
wrote:
> > > diff --git a/super-intel.c b/super-intel.c
> > > index 4ebee78..511a32a 100644
> > > --- a/super-intel.c
> > > +++ b/super-intel.c
> > > @@ -2529,13 +2529,13 @@ static void getinfo_super_imsm(struct superty=
pe
> > *st, struct mdinfo *info, char *
> > >
> > > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0failed =3D imsm_count_failed(super, de=
v);
> > > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0state =3D imsm_check_degraded(super, d=
ev, failed);
> > > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 map =3D get_imsm_map(dev, dev->vol.migr=
_state);
> > > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 map =3D get_imsm_map(dev, 0);
> > >
> > > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* any newly missing disks?
> > > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * (catches single-degraded vs double-=
degraded)
> > > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 */
> > > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0for (j =3D 0; j < map->num_members; j+=
+) {
> > > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __u32 ord =3D get_imsm_=
ord_tbl_ent(dev, i, -1);
> > > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __u32 ord =3D get_imsm_=
ord_tbl_ent(dev, i, 0);
> >=20
> > This looks wrong.  I noticed this when looking over Przemyslaw's patch =
[1].
> >=20
> > map[0] always contains the destination state of the migration so the
> > most reliable source for looking for out of sync disks is map[1].
> >=20
>=20
> I am convinced that the patch is good.=20
> We are looking for information what was the state of array during migrati=
on (before it was stopped), so we have to use map[0].
> map[1] contains information about the state of array before migration, wh=
ich we do not need.
>=20
> Regards,
> Lukasz

Hi,
 do we have agreement on this?  Dan - do you stand by your original concern
 or have you seen the light :-)

The patch is in, but I'd like to be sure it is right and to be honest I
haven't followed the dance of the maps too closely...

Thanks,
NeilBrown

--Sig_/l_JT32wSm42=1OdnTayZKY=
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTt1rgTnsnt1WYoG5AQLTkw/9EQYIrwIC6FRwkD5uySbnAv4iqmMe5i6E
xPLYqdBL1aDasSfFSSgwPHRzYR/1cLZjKDvzRhTpPHJ70tdIpyJmOr9ZmGT0zE+w
ykPc7qxaFUi2KVqQY5qboV94Ic/E0KWRDcA5o1WefDfGVLl4h2Hh4wHlh4PMKMVO
3t2y4mPDar+UcInnSFxABkJsRZB0m9CkGC7MOeaWgS/UJ5LS+wP6ExIYH58/lbbQ
+mjxUwkyLQlxQirPAhBO4tV2pko4d7w1vBDMDHHCJ/gV7wzQXHwYs0Iac/oXR2UN
jk+ifJu+Yp2+XE1S15mBiPh9oMavuT3n9fXReBsx1ATTuB86QmvtFYiLN2kDGjPD
UmBTQ3A6owNbnf9q5jGwTD33OR2G+NkDrwhQtxy8Se20KldWNx6ZoKd9ySVl2ynU
waztDpIhl3SOAJue/nxMYLH5syraxzCAmeNfhB/jRD+eIMDBUABqM53hz0Y3bsYL
Y22D9/jbBcvvoXcfHNBLb+ggDR83yjqow7I3kW7E02qY0TGTF17RQZ5MjWrZy/uf
Rqpz91gEy9wiITKuXy+SzHohtT224/8sZUfiIbcG/Olb8QbZj2dmiPBZ356ufzbn
hYHX0BHzOG3Ci4F6Ox2kBqjB+hmHimsvikmKJKQg+Mcl6bmoN40ST2VMHKyc8wUv
DynJpZX3+Xo=
=uYtZ
-----END PGP SIGNATURE-----

--Sig_/l_JT32wSm42=1OdnTayZKY=--
