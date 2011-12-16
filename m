From: "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH 3/3] imsm: FIX: UT '08imsm-overlap' fails
Date: Thu, 15 Dec 2011 20:18:45 -0800
Message-ID: <CABE8wwu1RNQsHPHZ7xWNsQ6-qym4LHQjsnf+LT8qrZpdHkQ-Hg@mail.gmail.com>
References: <20111214150448.21483.16231.stgit@gklab-128-013.igk.intel.com>
	<20111214150720.21483.27249.stgit@gklab-128-013.igk.intel.com>
	<CABE8wwt44LbrKEGJjoUyjOt5zDP2=uO60hVPYfWpxMHi+EuQwg@mail.gmail.com>
	<20111215150314.7e5694c7@notabene.brown>
	<CABE8wwvfzxM1e2S7XOotMHWT40JF6sbRH3mW688dpuWmwoCtZQ@mail.gmail.com>
	<79556383A0E1384DB3A3903742AAC04A060EEA@IRSMSX101.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <79556383A0E1384DB3A3903742AAC04A060EEA@IRSMSX101.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Kwolek, Adam" <adam.kwolek@intel.com>
Cc: NeilBrown <neilb@suse.de>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

2011/12/15 Kwolek, Adam <adam.kwolek@intel.com>:
>
>
> From: Williams, Dan J [mailto:dan.j.williams@intel.com]
> Sent: Thursday, December 15, 2011 6:16 AM
> To: NeilBrown
> Cc: Labun, Marcin; Ciechanowski, Ed; linux-raid@vger.kernel.org; Kwol=
ek, Adam
> Subject: Re: [PATCH 3/3] imsm: FIX: UT '08imsm-overlap' fails
>
>
> On Dec 14, 2011 8:03 PM, "NeilBrown" <neilb@suse.de> wrote:
>>
>> On Wed, 14 Dec 2011 10:21:07 -0800 "Williams, Dan J"
>> <dan.j.williams@intel.com> wrote:
>>
>> > On Wed, Dec 14, 2011 at 7:07 AM, Adam Kwolek <adam.kwolek@intel.co=
m> wrote:
>> > > Problem was introduced by patch (2011-09-19):
>> > > =A0 Create: Allow to create two volumes of different sizes withi=
n one container
>> > >
>> > > To resolve problem check requested disks number not against all =
disks
>> > > recorded in metadata, but against disks number set in array map =
structure.
>> > >
>> > > Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
>> > > ---
>> > >
>> > > =A0super-intel.c | =A0 24 ++++++++++++++++++++----
>> > > =A01 files changed, 20 insertions(+), 4 deletions(-)
>> > >
>> > > diff --git a/super-intel.c b/super-intel.c
>> > > index 5e1d278..3c10d29 100644
>> > > --- a/super-intel.c
>> > > +++ b/super-intel.c
>> > > @@ -5318,10 +5318,26 @@ static int validate_geometry_imsm_volume=
(struct supertype *st, int level,
>> > >
>> > > =A0 =A0 =A0 =A0mpb =3D super->anchor;
>> > >
>> > > - =A0 =A0 =A0 if (mpb->num_raid_devs > 0 && mpb->num_disks !=3D =
raiddisks) {
>> > > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 fprintf(stderr, Name ": the option=
-rom requires all "
>> > > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "member disks to b=
e a member of all volumes.\n");
>> > > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> > > + =A0 =A0 =A0 /* check if currently verified volume spans the sa=
me disks number
>> > > + =A0 =A0 =A0 =A0* as all other arrays that belongs to metadata.
>> > > + =A0 =A0 =A0 =A0* Do not allow to create volume with different =
disks number
>> > > + =A0 =A0 =A0 =A0* than curently is used.
>> > > + =A0 =A0 =A0 =A0*/
>> > > + =A0 =A0 =A0 for (i =3D 0; i < mpb->num_raid_devs; i++) {
>> > > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* There is any already existing a=
rray in metadata
>> > > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>> > > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct imsm_dev *dev =3D get_imsm_=
dev(super, i);
>> > > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct imsm_map *map =3D NULL;
>> > > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (dev)
>> > > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 map =3D get_imsm_m=
ap(dev, MAP_0);
>> > > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (map) {
>> > > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (raiddisks !=3D=
 map->num_members) {
>> > > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 fp=
rintf(stderr, Name ": the option-rom requires"
>> > > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 " all member disks to be a member of "
>> > > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 "all volumes.\n");
>> > > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 re=
turn 0;
>> > > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> > > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> >
>> > I'd prefer to move this check back to the other 'orom' checks in
>> > validate_geometry_imsm_volume(), and make it dependent on the pres=
ence
>> > of the orom.
>> >
>> > diff --git a/super-intel.c b/super-intel.c
>> > index 07d47b5..9885b98 100644
>> > --- a/super-intel.c
>> > +++ b/super-intel.c
>> > @@ -5122,12 +5122,6 @@ static int validate_geometry_imsm_volume(st=
ruct
>> > supertype *st, int level,
>> > =A0 =A0 =A0 if (!super)
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> >
>> > - =A0 =A0 if (mpb->num_raid_devs > 0 && mpb->num_disks !=3D raiddi=
sks) {
>> > - =A0 =A0 =A0 =A0 =A0 =A0 fprintf(stderr, Name ": the option-rom r=
equires all "
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "member disks to be a me=
mber of all volumes.\n");
>> > - =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> > - =A0 =A0 }
>> > -
>> > =A0 =A0 =A0 if (!validate_geometry_imsm_orom(super, level, layout,=
 raiddisks,
>> > chunk, verbose)) {
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 fprintf(stderr, Name ": RAID gemetry v=
alidation failed. "
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "Cannot proceed with t=
he action(s).\n");
>> > @@ -5206,6 +5200,11 @@ static int validate_geometry_imsm_volume(st=
ruct
>> > supertype *st, int level,
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 fprintf(stderr, Name ": The option-rom=
 requires all member"
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 " disks to be a member=
 of all volumes\n");
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> > + =A0 =A0 } else if (super->orom && mpb->num_raid_devs > 0 &&
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mpb->num_disks !=3D raiddisks) {
>> > + =A0 =A0 =A0 =A0 =A0 =A0 fprintf(stderr, Name ": The option-rom r=
equires all member"
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 " disks to be a member o=
f all volumes\n");
>> > + =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> > =A0 =A0 =A0 }
>> >
>> > =A0 =A0 =A0 /* retrieve the largest free space block */
>>
>>
>> Hi Dan,
>> =A0I think you are presenting this as an alternate - is that correct=
?
> Yes.
>> It seems a lit simpler - does it do enough?
> I believe so, I'd like Adam to confirm.
>
> I'm not sure if checking mpb->num_disks !=3D raiddisks is enough /or =
it is rather too much/.
> In disk list could be different number of members than in map (e.g. r=
ebuild when disks list is longer).

Yes but num_disks should always be authoritative for the container.

> It was UT08* failure cause and I thing using maps length is better.
>
> I'm not sure, if making it dependent on the presence of the orom make=
s us happy from compatibility point of view.

That's exactly the point this restriction only matters when the orom
is present.  Which is why 08imsm-overlap specifies IMSM_NO_PLATFORM=3D1=
=2E
 Bypassing this restriction allows more stressful testing of the
auto-layout code.

> We shouldn't make metadata OROM incompatible. Every array can be moun=
ted on OROM platform later, what scenario for such case?

Specifying IMSM_NO_PLATFORM means all orom / platform compatibility
checks are turned off.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
