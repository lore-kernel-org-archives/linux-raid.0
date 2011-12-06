From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] imsm: fix: correct checking newly missing disks
Date: Tue, 6 Dec 2011 13:22:07 +1100
Message-ID: <20111206132207.34f86bb0@notabene.brown>
References: <20111114145252.21148.62905.stgit@gklab-128-085.igk.intel.com>
	<CAA9_cmccLh=zYnqkpdhjkYZQQK26oUN4xqiMyycYHoLSr19zKg@mail.gmail.com>
	<D9FFE20C522965449E182ACE73889AEB052370@IRSMSX101.ger.corp.intel.com>
	<20111206121025.1e20e55a@notabene.brown>
	<CABE8wwuMGo4BD2117p4BYt1OvYYOiXmnm5YF0Z04srG9Dmw2zA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/vxmWzjK6aa98OUX=j_U02r."; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CABE8wwuMGo4BD2117p4BYt1OvYYOiXmnm5YF0Z04srG9Dmw2zA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "Dorau, Lukasz" <lukasz.dorau@intel.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Kwolek, Adam" <adam.kwolek@intel.com>
List-Id: linux-raid.ids

--Sig_/vxmWzjK6aa98OUX=j_U02r.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Mon, 5 Dec 2011 18:19:09 -0800 "Williams, Dan J"
<dan.j.williams@intel.com> wrote:

> On Mon, Dec 5, 2011 at 5:10 PM, NeilBrown <neilb@suse.de> wrote:
> > On Thu, 1 Dec 2011 14:23:16 +0000 "Dorau, Lukasz" <lukasz.dorau@intel.c=
om>
> > wrote:
> >> > > diff --git a/super-intel.c b/super-intel.c
> >> > > index 4ebee78..511a32a 100644
> >> > > --- a/super-intel.c
> >> > > +++ b/super-intel.c
> >> > > @@ -2529,13 +2529,13 @@ static void getinfo_super_imsm(struct supe=
rtype
> >> > *st, struct mdinfo *info, char *
> >> > >
> >> > > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0failed =3D imsm_count_failed(super,=
 dev);
> >> > > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0state =3D imsm_check_degraded(super=
, dev, failed);
> >> > > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 map =3D get_imsm_map(dev, dev->vol.m=
igr_state);
> >> > > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 map =3D get_imsm_map(dev, 0);
> >> > >
> >> > > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* any newly missing disks?
> >> > > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * (catches single-degraded vs doub=
le-degraded)
> >> > > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 */
> >> > > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0for (j =3D 0; j < map->num_members;=
 j++) {
> >> > > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __u32 ord =3D get_im=
sm_ord_tbl_ent(dev, i, -1);
> >> > > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __u32 ord =3D get_im=
sm_ord_tbl_ent(dev, i, 0);
> >> >
> >> > This looks wrong. =A0I noticed this when looking over Przemyslaw's p=
atch [1].
> >> >
> >> > map[0] always contains the destination state of the migration so the
> >> > most reliable source for looking for out of sync disks is map[1].
> >> >
> >>
> >> I am convinced that the patch is good.
> >> We are looking for information what was the state of array during migr=
ation (before it was stopped), so we have to use map[0].
> >> map[1] contains information about the state of array before migration,=
 which we do not need.
> >>
> >> Regards,
> >> Lukasz
> >
> > Hi,
> > =A0do we have agreement on this? =A0Dan - do you stand by your original=
 concern
> > =A0or have you seen the light :-)
> >
> > The patch is in, but I'd like to be sure it is right and to be honest I
> > haven't followed the dance of the maps too closely...
>=20
> Lukasz is right.  We want to find out if starting the array with the
> current list of disks in the container would regress the state of the
> array recorded in the metadata.  map[0] should always record the best
> possible state of all the slots in the array if any of those have gone
> missing we don't want incremental assembly to proceed.
>=20
> Sorry for the noise, my point was 'correct' in isolation but it missed
> that the context is looking for the most optimistic view of the disk.

Great - thanks for clearing that up.

NeilBrown

--Sig_/vxmWzjK6aa98OUX=j_U02r.
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTt18WDnsnt1WYoG5AQKKDA//Z/1qL40DcBbk34TneZ8cnmQDpMNfsALi
XlnxMgcMGJF5YXxRA6OrmWbqsTpc8qtXHlb1wUkZyteI0RbcgZOXN8s8o5gm8f1G
W0at2gHxevim4puugQEzlqFd8fCM4H2aVAT6/J8CTFDANVmbkplWY0ic6hlxLBEp
GFc4p1s0rREywr+17ehH9xoAJnimnhZmqIuWLDcryY4DdasAz/kWzOWatZzN7lf7
/9mbAfq7R3RDfBaPxYPAa0TvTmJtmunwKCezLxCZNGF8UqzTjiA+2/0ovHWrySz5
TVP7fE1L1WAeG70s6Sd0gqhbrLmnwn86mM9jSxdnnUMOQF7mJLbOuPVkAM7grO10
f659TwA/lQ/3xGje44/Eht8nKzHafISEmmIIk7yz/WShLhEOFYADk8YAcyFtOytu
OAyPP+LnqI4OFEGlapc0GUnsks29+/KQwAr6ORsh+P96qLbdi2MHTvgsv8K3oqkR
ZRD4FUtXCMo1mpLCuIQB5NqjTPSf470rI1Wa8n6xBXmG/hPVo4UlMzgIEV8So941
11Y4IV8uy0oaGMB2ftTBS8yMNzr9GAslUrshyNNdqvTgO5XnzGlrdEjnK+DQcTTf
vjzXY7yoK0/WzeNToVv9Wu1SX4CIKOOlH81jKhnpvaUwhBn6qM5/3MrO+jQhq2V6
VfMsOH0q9SU=
=yMM3
-----END PGP SIGNATURE-----

--Sig_/vxmWzjK6aa98OUX=j_U02r.--
