From: "Dorau, Lukasz" <lukasz.dorau@intel.com>
Subject: RE: [PATCH] imsm: fix: correct calculation of UUID
Date: Thu, 5 Jan 2012 13:30:41 +0000
Message-ID: <D9FFE20C522965449E182ACE73889AEB061321@IRSMSX101.ger.corp.intel.com>
References: <20120104094035.14727.94117.stgit@gklab-128-085.igk.intel.com>
	<CABE8wwtjQG5Zo6rd-7T+oQp3qBG-_hjbXoLy4zO2aRXNi8zPnw@mail.gmail.com>
	<D9FFE20C522965449E182ACE73889AEB060E93@IRSMSX101.ger.corp.intel.com>
 <CABE8wwvEX09DWhYtE9s3uL6RYr2nT32HP_hBvJ_JjWNvRPMuig@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CABE8wwvEX09DWhYtE9s3uL6RYr2nT32HP_hBvJ_JjWNvRPMuig@mail.gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "neilb@suse.de" <neilb@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

> -----Original Message-----
> From: Dan Williams [mailto:dan.j.williams@intel.com]
> Sent: Wednesday, January 04, 2012 5:41 PM
> To: Dorau, Lukasz
> Cc: neilb@suse.de; linux-raid@vger.kernel.org; Labun, Marcin; Ciechan=
owski, Ed
> Subject: Re: [PATCH] imsm: fix: correct calculation of UUID
>=20
> 2012/1/4 Dorau, Lukasz <lukasz.dorau@intel.com>:
> > On Wed, Jan 4, 2012 at 11:05 AM, Dan Williams <dan.j.williams@intel=
=2Ecom>
> wrote:
> >>
> >> On Wed, Jan 4, 2012 at 1:40 AM, Lukasz Dorau <lukasz.dorau@intel.c=
om>
> >> wrote:
> >> > The UUID is calculated from two numbers and two strings stored i=
n arrays.
> >> > Whole arrays of chars are taken to calculation (not only the use=
d part).
> >> > This is wrong, because the unused part of arrays can be changed
> accidentally.
> >> > For example it can sometimes happen when degraded raid is being =
rebuilt in
> >> OROM.
> >> > Such accidental change of UUID causes that system installed on r=
aid
> >> > does not boot due to not recognized booting device (raid with ch=
anged
> UUID).
> >> >
> >> > Signed-off-by: Lukasz Dorau <lukasz.dorau@intel.com>
> >> > ---
> >> > =A0super-intel.c | =A0 =A07 +++++--
> >> > =A01 files changed, 5 insertions(+), 2 deletions(-)
> >> >
> >> > diff --git a/super-intel.c b/super-intel.c
> >> > index 0e9269f..7f34542 100644
> >> > --- a/super-intel.c
> >> > +++ b/super-intel.c
> >> > @@ -1820,6 +1820,7 @@ static void uuid_from_super_imsm(struct
> supertype
> >> *st, int uuid[4])
> >> > =A0 =A0 =A0 =A0struct sha1_ctx ctx;
> >> > =A0 =A0 =A0 =A0struct imsm_dev *dev =3D NULL;
> >> > =A0 =A0 =A0 =A0__u32 family_num;
> >> > + =A0 =A0 =A0 size_t len;
> >> >
> >> > =A0 =A0 =A0 =A0/* some mdadm versions failed to set ->orig_famil=
y_num, in which
> >> > =A0 =A0 =A0 =A0 * case fall back to ->family_num. =A0orig_family=
_num will be
> >> > @@ -1829,14 +1830,16 @@ static void uuid_from_super_imsm(struct
> >> supertype *st, int uuid[4])
> >> > =A0 =A0 =A0 =A0if (family_num =3D=3D 0)
> >> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0family_num =3D super->anchor->fam=
ily_num;
> >> > =A0 =A0 =A0 =A0sha1_init_ctx(&ctx);
> >> > - =A0 =A0 =A0 sha1_process_bytes(super->anchor->sig, MPB_SIG_LEN=
, &ctx);
> >> > + =A0 =A0 =A0 len =3D strnlen((const char *)super->anchor->sig, =
MPB_SIG_LEN);
> >> > + =A0 =A0 =A0 sha1_process_bytes(super->anchor->sig, len, &ctx);
> >> > =A0 =A0 =A0 =A0sha1_process_bytes(&family_num, sizeof(__u32), &c=
tx);
> >> > =A0 =A0 =A0 =A0if (super->current_vol >=3D 0)
> >> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0dev =3D get_imsm_dev(super, super=
->current_vol);
> >> > =A0 =A0 =A0 =A0if (dev) {
> >> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0__u32 vol =3D super->current_vol;
> >> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sha1_process_bytes(&vol, sizeof(v=
ol), &ctx);
> >> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 sha1_process_bytes(dev->volume, MA=
X_RAID_SERIAL_LEN, &ctx);
> >> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 len =3D strnlen((const char *)dev-=
>volume, MAX_RAID_SERIAL_LEN);
> >> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 sha1_process_bytes(dev->volume, le=
n, &ctx);
> >>
> >> Can't do this. =A0It will break the UUIDs of existing arrays in th=
e field.
> >>
> > So we can't fill the unused part of these arrays with '\000' charac=
ter
> > before calculating the UUID either, can we?
> >
> >> When can the unused portion of anchor->sig and dev->volume be "cha=
nged
> >> accidentally", as you mention, during a rebuild?
> >>
> > Please consider the following scenario:
> > 1. Create RAID 10 volume of name "r10d4n0s64" in OROM.
> > 2. Delete the volume "r10d4n0s64" in OROM.
> > 3. Create RAID 10 volume of name "raid10" in OROM.
> > 4. Boot the system.
> > 5. Run mdadm, contents of dev->volume array is "raid10\000s64\000\0=
00..."
> (8th, 9th, 10th bytes are "s64")
> > 6. Fail one of the "raid10" volume's disks. The "raid10" volume is =
degraded
> now.
> > 7. Restart the computer and enter OROM.
> > 8. Add a new empty disk to the volume in OROM. The status of the vo=
lume is
> changed to "Rebuild".
> > 9. Boot the system.
> > 10. Run mdadm, contents of dev->volume array is
> "raid10\000\000\000\000\000..." (8th, 9th, 10th bytes are "\000\000\0=
00").
>=20
> On all disks or just the newly added spare?
>=20
On all disks.

> > Now the UUID is different than it was in point 5th (above). If the =
operating
> system were installed on that volume, it would not boot due to not re=
cognized
> booting device (raid with changed UUID).
>=20
> ...and you can only reproduce this when adding the disk via orom?
>

Yes, only when adding the disk via OROM.

Regards,
Lukasz

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
