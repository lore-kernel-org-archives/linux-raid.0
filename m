From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: RE: [PATCH 3/3] imsm: FIX: UT '08imsm-overlap' fails
Date: Thu, 15 Dec 2011 08:01:21 +0000
Message-ID: <79556383A0E1384DB3A3903742AAC04A060EEA@IRSMSX101.ger.corp.intel.com>
References: <20111214150448.21483.16231.stgit@gklab-128-013.igk.intel.com>
	<20111214150720.21483.27249.stgit@gklab-128-013.igk.intel.com>
	<CABE8wwt44LbrKEGJjoUyjOt5zDP2=uO60hVPYfWpxMHi+EuQwg@mail.gmail.com>
	<20111215150314.7e5694c7@notabene.brown>
 <CABE8wwvfzxM1e2S7XOotMHWT40JF6sbRH3mW688dpuWmwoCtZQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CABE8wwvfzxM1e2S7XOotMHWT40JF6sbRH3mW688dpuWmwoCtZQ@mail.gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "Williams, Dan J" <dan.j.williams@intel.com>, NeilBrown <neilb@suse.de>
Cc: "Labun, Marcin" <Marcin.Labun@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



=46rom: Williams, Dan J [mailto:dan.j.williams@intel.com]=20
Sent: Thursday, December 15, 2011 6:16 AM
To: NeilBrown
Cc: Labun, Marcin; Ciechanowski, Ed; linux-raid@vger.kernel.org; Kwolek=
, Adam
Subject: Re: [PATCH 3/3] imsm: FIX: UT '08imsm-overlap' fails


On Dec 14, 2011 8:03 PM, "NeilBrown" <neilb@suse.de> wrote:
>
> On Wed, 14 Dec 2011 10:21:07 -0800 "Williams, Dan J"
> <dan.j.williams@intel.com> wrote:
>
> > On Wed, Dec 14, 2011 at 7:07 AM, Adam Kwolek <adam.kwolek@intel.com=
> wrote:
> > > Problem was introduced by patch (2011-09-19):
> > > =A0 Create: Allow to create two volumes of different sizes within=
 one container
> > >
> > > To resolve problem check requested disks number not against all d=
isks
> > > recorded in metadata, but against disks number set in array map s=
tructure.
> > >
> > > Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> > > ---
> > >
> > > =A0super-intel.c | =A0 24 ++++++++++++++++++++----
> > > =A01 files changed, 20 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/super-intel.c b/super-intel.c
> > > index 5e1d278..3c10d29 100644
> > > --- a/super-intel.c
> > > +++ b/super-intel.c
> > > @@ -5318,10 +5318,26 @@ static int validate_geometry_imsm_volume(=
struct supertype *st, int level,
> > >
> > > =A0 =A0 =A0 =A0mpb =3D super->anchor;
> > >
> > > - =A0 =A0 =A0 if (mpb->num_raid_devs > 0 && mpb->num_disks !=3D r=
aiddisks) {
> > > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 fprintf(stderr, Name ": the option-=
rom requires all "
> > > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "member disks to be=
 a member of all volumes.\n");
> > > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
> > > + =A0 =A0 =A0 /* check if currently verified volume spans the sam=
e disks number
> > > + =A0 =A0 =A0 =A0* as all other arrays that belongs to metadata.
> > > + =A0 =A0 =A0 =A0* Do not allow to create volume with different d=
isks number
> > > + =A0 =A0 =A0 =A0* than curently is used.
> > > + =A0 =A0 =A0 =A0*/
> > > + =A0 =A0 =A0 for (i =3D 0; i < mpb->num_raid_devs; i++) {
> > > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* There is any already existing ar=
ray in metadata
> > > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> > > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct imsm_dev *dev =3D get_imsm_d=
ev(super, i);
> > > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct imsm_map *map =3D NULL;
> > > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (dev)
> > > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 map =3D get_imsm_ma=
p(dev, MAP_0);
> > > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (map) {
> > > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (raiddisks !=3D =
map->num_members) {
> > > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 fpr=
intf(stderr, Name ": the option-rom requires"
> > > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 " all member disks to be a member of "
> > > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 "all volumes.\n");
> > > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret=
urn 0;
> > > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> > > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> >
> > I'd prefer to move this check back to the other 'orom' checks in
> > validate_geometry_imsm_volume(), and make it dependent on the prese=
nce
> > of the orom.
> >
> > diff --git a/super-intel.c b/super-intel.c
> > index 07d47b5..9885b98 100644
> > --- a/super-intel.c
> > +++ b/super-intel.c
> > @@ -5122,12 +5122,6 @@ static int validate_geometry_imsm_volume(str=
uct
> > supertype *st, int level,
> > =A0 =A0 =A0 if (!super)
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
> >
> > - =A0 =A0 if (mpb->num_raid_devs > 0 && mpb->num_disks !=3D raiddis=
ks) {
> > - =A0 =A0 =A0 =A0 =A0 =A0 fprintf(stderr, Name ": the option-rom re=
quires all "
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "member disks to be a mem=
ber of all volumes.\n");
> > - =A0 =A0 =A0 =A0 =A0 =A0 return 0;
> > - =A0 =A0 }
> > -
> > =A0 =A0 =A0 if (!validate_geometry_imsm_orom(super, level, layout, =
raiddisks,
> > chunk, verbose)) {
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 fprintf(stderr, Name ": RAID gemetry va=
lidation failed. "
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "Cannot proceed with th=
e action(s).\n");
> > @@ -5206,6 +5200,11 @@ static int validate_geometry_imsm_volume(str=
uct
> > supertype *st, int level,
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 fprintf(stderr, Name ": The option-rom =
requires all member"
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 " disks to be a member =
of all volumes\n");
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
> > + =A0 =A0 } else if (super->orom && mpb->num_raid_devs > 0 &&
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mpb->num_disks !=3D raiddisks) {
> > + =A0 =A0 =A0 =A0 =A0 =A0 fprintf(stderr, Name ": The option-rom re=
quires all member"
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 " disks to be a member of=
 all volumes\n");
> > + =A0 =A0 =A0 =A0 =A0 =A0 return 0;
> > =A0 =A0 =A0 }
> >
> > =A0 =A0 =A0 /* retrieve the largest free space block */
>
>
> Hi Dan,
> =A0I think you are presenting this as an alternate - is that correct?
Yes.
> It seems a lit simpler - does it do enough?
I believe so, I'd like Adam to confirm.

I'm not sure if checking mpb->num_disks !=3D raiddisks is enough /or it=
 is rather too much/.
In disk list could be different number of members than in map (e.g. reb=
uild when disks list is longer).
It was UT08* failure cause and I thing using maps length is better.

I'm not sure, if making it dependent on the presence of the orom makes =
us happy from compatibility point of view.
We shouldn't make metadata OROM incompatible. Every array can be mounte=
d on OROM platform later, what scenario for such case?

BR
Adam

(forgive brevity replying from phone)
--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
