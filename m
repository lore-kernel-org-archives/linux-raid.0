From: "Dorau, Lukasz" <lukasz.dorau@intel.com>
Subject: RE: [PATCH] imsm: fix: correct checking newly missing disks
Date: Thu, 1 Dec 2011 14:23:16 +0000
Message-ID: <D9FFE20C522965449E182ACE73889AEB052370@IRSMSX101.ger.corp.intel.com>
References: <20111114145252.21148.62905.stgit@gklab-128-085.igk.intel.com>
 <CAA9_cmccLh=zYnqkpdhjkYZQQK26oUN4xqiMyycYHoLSr19zKg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAA9_cmccLh=zYnqkpdhjkYZQQK26oUN4xqiMyycYHoLSr19zKg@mail.gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "neilb@suse.de" <neilb@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Kwolek, Adam" <adam.kwolek@intel.com>
List-Id: linux-raid.ids



Pozdrawiam,
=A3ukasz


> -----Original Message-----
> From: dan.j.williams@gmail.com [mailto:dan.j.williams@gmail.com] On B=
ehalf
> Of Dan Williams
> Sent: Wednesday, November 30, 2011 3:27 AM
> To: Dorau, Lukasz
> Cc: neilb@suse.de; linux-raid@vger.kernel.org; Labun, Marcin; Ciechan=
owski, Ed
> Subject: Re: [PATCH] imsm: fix: correct checking newly missing disks
>=20
> On Mon, Nov 14, 2011 at 6:52 AM, Lukasz Dorau <lukasz.dorau@intel.com=
>
> wrote:
> > The problem occurs when RAID10 array under rebuild
> > (after one disk fails) is assembled incrementally.
> > Mdadm tries to start array just after adding the third disk
> > and the volume is assembled incorrectly (in degraded state).
> >
> > The cause is that container_enough depends on
> > newly missing disks which are checked incorrectly now.
> > They should be checked using always the first map.
> >
> > Signed-off-by: Lukasz Dorau <lukasz.dorau@intel.com>
> > ---
> > =A0super-intel.c | =A0 =A04 ++--
> > =A01 files changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/super-intel.c b/super-intel.c
> > index 4ebee78..511a32a 100644
> > --- a/super-intel.c
> > +++ b/super-intel.c
> > @@ -2529,13 +2529,13 @@ static void getinfo_super_imsm(struct super=
type
> *st, struct mdinfo *info, char *
> >
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0failed =3D imsm_count_failed(super, =
dev);
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0state =3D imsm_check_degraded(super,=
 dev, failed);
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 map =3D get_imsm_map(dev, dev->vol.mi=
gr_state);
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 map =3D get_imsm_map(dev, 0);
> >
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* any newly missing disks?
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * (catches single-degraded vs doubl=
e-degraded)
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 */
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0for (j =3D 0; j < map->num_members; =
j++) {
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __u32 ord =3D get_ims=
m_ord_tbl_ent(dev, i, -1);
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __u32 ord =3D get_ims=
m_ord_tbl_ent(dev, i, 0);
>=20
> This looks wrong.  I noticed this when looking over Przemyslaw's patc=
h [1].
>=20
> map[0] always contains the destination state of the migration so the
> most reliable source for looking for out of sync disks is map[1].
>=20

I am convinced that the patch is good.=20
We are looking for information what was the state of array during migra=
tion (before it was stopped), so we have to use map[0].
map[1] contains information about the state of array before migration, =
which we do not need.

Regards,
Lukasz

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
