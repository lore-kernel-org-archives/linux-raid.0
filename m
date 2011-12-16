From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: RE: [PATCH 3/3] imsm: FIX: UT '08imsm-overlap' fails
Date: Fri, 16 Dec 2011 08:32:07 +0000
Message-ID: <79556383A0E1384DB3A3903742AAC04A061319@IRSMSX101.ger.corp.intel.com>
References: <20111214150448.21483.16231.stgit@gklab-128-013.igk.intel.com>
	<20111214150720.21483.27249.stgit@gklab-128-013.igk.intel.com>
	<CABE8wwt44LbrKEGJjoUyjOt5zDP2=uO60hVPYfWpxMHi+EuQwg@mail.gmail.com>
	<20111215150314.7e5694c7@notabene.brown>
	<CABE8wwvfzxM1e2S7XOotMHWT40JF6sbRH3mW688dpuWmwoCtZQ@mail.gmail.com>
	<79556383A0E1384DB3A3903742AAC04A060EEA@IRSMSX101.ger.corp.intel.com>
 <CABE8wwu1RNQsHPHZ7xWNsQ6-qym4LHQjsnf+LT8qrZpdHkQ-Hg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CABE8wwu1RNQsHPHZ7xWNsQ6-qym4LHQjsnf+LT8qrZpdHkQ-Hg@mail.gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: NeilBrown <neilb@suse.de>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



> -----Original Message-----
> From: Williams, Dan J [mailto:dan.j.williams@intel.com]
> Sent: Friday, December 16, 2011 5:19 AM
> To: Kwolek, Adam
> Cc: NeilBrown; Labun, Marcin; Ciechanowski, Ed; linux-raid@vger.kerne=
l.org
> Subject: Re: [PATCH 3/3] imsm: FIX: UT '08imsm-overlap' fails
>=20
> 2011/12/15 Kwolek, Adam <adam.kwolek@intel.com>:
> >
> >
> > From: Williams, Dan J [mailto:dan.j.williams@intel.com]
> > Sent: Thursday, December 15, 2011 6:16 AM
> > To: NeilBrown
> > Cc: Labun, Marcin; Ciechanowski, Ed; linux-raid@vger.kernel.org;
> > Kwolek, Adam
> > Subject: Re: [PATCH 3/3] imsm: FIX: UT '08imsm-overlap' fails
> >
> >
> > On Dec 14, 2011 8:03 PM, "NeilBrown" <neilb@suse.de> wrote:
> >>
> >> On Wed, 14 Dec 2011 10:21:07 -0800 "Williams, Dan J"
> >> <dan.j.williams@intel.com> wrote:
> >>
> >> > On Wed, Dec 14, 2011 at 7:07 AM, Adam Kwolek
> <adam.kwolek@intel.com> wrote:
> >> > > Problem was introduced by patch (2011-09-19):
> >> > > =A0 Create: Allow to create two volumes of different sizes wit=
hin
> >> > > one container
> >> > >
> >> > > To resolve problem check requested disks number not against al=
l
> >> > > disks recorded in metadata, but against disks number set in ar=
ray map
> structure.
> >> > >
> >> > > Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> >> > > ---
> >> > >
> >> > > =A0super-intel.c | =A0 24 ++++++++++++++++++++----
> >> > > =A01 files changed, 20 insertions(+), 4 deletions(-)
> >> > >
> >> > > diff --git a/super-intel.c b/super-intel.c index 5e1d278..3c10=
d29
> >> > > 100644
> >> > > --- a/super-intel.c
> >> > > +++ b/super-intel.c
> >> > > @@ -5318,10 +5318,26 @@ static int
> >> > > validate_geometry_imsm_volume(struct supertype *st, int level,
> >> > >
> >> > > =A0 =A0 =A0 =A0mpb =3D super->anchor;
> >> > >
> >> > > - =A0 =A0 =A0 if (mpb->num_raid_devs > 0 && mpb->num_disks !=3D
> >> > > raiddisks) {
> >> > > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 fprintf(stderr, Name ": the opti=
on-rom requires all "
> >> > > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "member disks to=
 be a member of all
> >> > > volumes.\n");
> >> > > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
> >> > > + =A0 =A0 =A0 /* check if currently verified volume spans the =
same
> >> > > + disks number
> >> > > + =A0 =A0 =A0 =A0* as all other arrays that belongs to metadat=
a.
> >> > > + =A0 =A0 =A0 =A0* Do not allow to create volume with differen=
t disks
> >> > > + number
> >> > > + =A0 =A0 =A0 =A0* than curently is used.
> >> > > + =A0 =A0 =A0 =A0*/
> >> > > + =A0 =A0 =A0 for (i =3D 0; i < mpb->num_raid_devs; i++) {
> >> > > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* There is any already existing=
 array in
> >> > > + metadata
> >> > > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> >> > > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct imsm_dev *dev =3D get_ims=
m_dev(super, i);
> >> > > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct imsm_map *map =3D NULL;
> >> > > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (dev)
> >> > > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 map =3D get_imsm=
_map(dev, MAP_0);
> >> > > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (map) {
> >> > > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (raiddisks !=3D=
 map->num_members) {
> >> > > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
fprintf(stderr, Name ": the option-rom requires"
> >> > > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 " all member disks to be a member of "
> >> > > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 "all volumes.\n");
> >> > > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
return 0;
> >> > > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> >> > > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> >> >
> >> > I'd prefer to move this check back to the other 'orom' checks in
> >> > validate_geometry_imsm_volume(), and make it dependent on the
> >> > presence of the orom.
> >> >
> >> > diff --git a/super-intel.c b/super-intel.c index 07d47b5..9885b9=
8
> >> > 100644
> >> > --- a/super-intel.c
> >> > +++ b/super-intel.c
> >> > @@ -5122,12 +5122,6 @@ static int
> >> > validate_geometry_imsm_volume(struct
> >> > supertype *st, int level,
> >> > =A0 =A0 =A0 if (!super)
> >> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
> >> >
> >> > - =A0 =A0 if (mpb->num_raid_devs > 0 && mpb->num_disks !=3D raid=
disks) {
> >> > - =A0 =A0 =A0 =A0 =A0 =A0 fprintf(stderr, Name ": the option-rom=
 requires all "
> >> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "member disks to be a =
member of all
> >> > volumes.\n");
> >> > - =A0 =A0 =A0 =A0 =A0 =A0 return 0;
> >> > - =A0 =A0 }
> >> > -
> >> > =A0 =A0 =A0 if (!validate_geometry_imsm_orom(super, level, layou=
t,
> >> > raiddisks, chunk, verbose)) {
> >> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 fprintf(stderr, Name ": RAID gemetry=
 validation failed. "
> >> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "Cannot proceed with=
 the action(s).\n"); @@
> >> > -5206,6 +5200,11 @@ static int validate_geometry_imsm_volume(str=
uct
> >> > supertype *st, int level,
> >> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 fprintf(stderr, Name ": The option-r=
om requires all member"
> >> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 " disks to be a memb=
er of all volumes\n");
> >> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
> >> > + =A0 =A0 } else if (super->orom && mpb->num_raid_devs > 0 &&
> >> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mpb->num_disks !=3D raiddisks) =
{
> >> > + =A0 =A0 =A0 =A0 =A0 =A0 fprintf(stderr, Name ": The option-rom=
 requires all member"
> >> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 " disks to be a member=
 of all volumes\n");
> >> > + =A0 =A0 =A0 =A0 =A0 =A0 return 0;
> >> > =A0 =A0 =A0 }
> >> >
> >> > =A0 =A0 =A0 /* retrieve the largest free space block */
> >>
> >>
> >> Hi Dan,
> >> =A0I think you are presenting this as an alternate - is that corre=
ct?
> > Yes.
> >> It seems a lit simpler - does it do enough?
> > I believe so, I'd like Adam to confirm.
> >
> > I'm not sure if checking mpb->num_disks !=3D raiddisks is enough /o=
r it is
> rather too much/.
> > In disk list could be different number of members than in map (e.g.=
 rebuild
> when disks list is longer).
>=20
> Yes but num_disks should always be authoritative for the container.
>=20
> > It was UT08* failure cause and I thing using maps length is better.
> >
> > I'm not sure, if making it dependent on the presence of the orom ma=
kes us
> happy from compatibility point of view.
>=20
> That's exactly the point this restriction only matters when the orom =
is
> present.  Which is why 08imsm-overlap specifies IMSM_NO_PLATFORM=3D1.
>  Bypassing this restriction allows more stressful testing of the auto=
-layout
> code.
>=20
> > We shouldn't make metadata OROM incompatible. Every array can be
> mounted on OROM platform later, what scenario for such case?
>=20
> Specifying IMSM_NO_PLATFORM means all orom / platform compatibility
> checks are turned off.

I've checked, you are right. OROM check will resolve problem.
Do you post your patch or I should do it? We are short of time regardin=
g Neil's plans about v3.2.3

BR
Adam
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
