From: "Wojcik, Krzysztof" <krzysztof.wojcik@intel.com>
Subject: RE: [PATCH] FIX: imsm: OROM does not recognize degraded arrays
Date: Fri, 25 Feb 2011 11:08:00 +0000
Message-ID: <BE2BFE91933D1B4089447C64486040806915B310@irsmsx503.ger.corp.intel.com>
References: <20110224065357.5594.92371.stgit@gklab-128-111.igk.intel.com>
 <AANLkTinS06EtPvr59C2ZY=gD8JFrp0AfAbmXAwWdjG5m@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTinS06EtPvr59C2ZY=gD8JFrp0AfAbmXAwWdjG5m@mail.gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "neilb@suse.de" <neilb@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Kwolek, Adam" <adam.kwolek@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids



> -----Original Message-----
> From: dan.j.williams@gmail.com [mailto:dan.j.williams@gmail.com] On
> Behalf Of Dan Williams
> Sent: Thursday, February 24, 2011 6:43 PM
> To: Wojcik, Krzysztof
> Cc: neilb@suse.de; linux-raid@vger.kernel.org; Neubauer, Wojciech;
> Kwolek, Adam; Ciechanowski, Ed
> Subject: Re: [PATCH] FIX: imsm: OROM does not recognize degraded arra=
ys
>=20
> Thanks Krzysztof, comments below:
>=20
> On Wed, Feb 23, 2011 at 10:53 PM, Krzysztof Wojcik
> <krzysztof.wojcik@intel.com> wrote:
> > Defect description:
> > When we create an redundant array in mdadm and then degrade it
> > by disk removing, Option ROM and Windows OS does not detect any
> array.
> > Reason:
> > Metadata created and updated after degrading array is not compatibl=
e
> > with IMSM standard.
> >
> > This patch synchronizes the metadata according IMSM requirements.
> > Following inconsistencies have been fixed:
> > - reset all fields in imsm_dev during creation to avoid random valu=
es
> > - init dev status during creation to proper state
> > - not reset CONFIGURED_DISK flag when disk is missing
> > - add ":0" suffix to the serial number for missing/failed disks
> > - update medatada signature after takeover operation
> > - mark map state as degraded after raid0->raid10 takeover
> >
> > Signed-off-by: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
> > ---
> > =A0super-intel.c | =A0 27 +++++++++++++++++----------
> > =A01 files changed, 17 insertions(+), 10 deletions(-)
> >
> > diff --git a/super-intel.c b/super-intel.c
> > index c101dca..a40b7e5 100644
> > --- a/super-intel.c
> > +++ b/super-intel.c
> > @@ -3437,6 +3437,8 @@ static int init_super_imsm_volume(struct
> supertype *st, mdu_array_info_t *info,
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0fprintf(stderr, Name": could not all=
ocate raid
> device\n");
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 0;
> > =A0 =A0 =A0 =A0}
> > + =A0 =A0 =A0 memset(dev, 0, (sizeof(*dev) + sizeof(__u32) * (info-
> >raid_disks - 1)));
> > +
>=20
> Consider changing the allocation to calloc, or store the size in a
> temporary variable so we don't duplicate the size calculation.

OK. Changed

>=20
> > =A0 =A0 =A0 =A0strncpy((char *) dev->volume, name, MAX_RAID_SERIAL_=
LEN);
> > =A0 =A0 =A0 =A0if (info->level =3D=3D 1)
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0array_blocks =3D info_to_blocks_per_=
member(info);
> > @@ -3449,8 +3451,7 @@ static int init_super_imsm_volume(struct
> supertype *st, mdu_array_info_t *info,
> >
> > =A0 =A0 =A0 =A0dev->size_low =3D __cpu_to_le32((__u32) array_blocks=
);
> > =A0 =A0 =A0 =A0dev->size_high =3D __cpu_to_le32((__u32) (array_bloc=
ks >> 32));
> > - =A0 =A0 =A0 dev->status =3D __cpu_to_le32(0);
> > - =A0 =A0 =A0 dev->reserved_blocks =3D __cpu_to_le32(0);
> > + =A0 =A0 =A0 dev->status =3D (DEV_READ_COALESCING | DEV_WRITE_COAL=
ESCING);
>=20
> The orom will fail to assemble arrays without these status bits set?

These bits are not the direct cause that OROM not assemble the array bu=
t it is not compatible with metadata created under Windows and OROM and=
 may cause problems in other scenarios.

>=20
> > =A0 =A0 =A0 =A0vol =3D &dev->vol;
> > =A0 =A0 =A0 =A0vol->migr_state =3D 0;
> > =A0 =A0 =A0 =A0set_migr_type(dev, MIGR_INIT);
> > @@ -5046,6 +5047,7 @@ static int mark_failure(struct imsm_dev *dev,
> struct imsm_disk *disk, int idx)
> > =A0 =A0 =A0 =A0__u32 ord;
> > =A0 =A0 =A0 =A0int slot;
> > =A0 =A0 =A0 =A0struct imsm_map *map;
> > + =A0 =A0 =A0 char buf[PATH_MAX];
>=20
> This is a very large stack allocation which is potentially problemati=
c
> for mdmon.

OK. Changed.

>=20
> >
> > =A0 =A0 =A0 =A0/* new failures are always set in map[0] */
> > =A0 =A0 =A0 =A0map =3D get_imsm_map(dev, 0);
> > @@ -5057,9 +5059,12 @@ static int mark_failure(struct imsm_dev *dev=
,
> struct imsm_disk *disk, int idx)
> > =A0 =A0 =A0 =A0ord =3D __le32_to_cpu(map->disk_ord_tbl[slot]);
> > =A0 =A0 =A0 =A0if (is_failed(disk) && (ord & IMSM_ORD_REBUILD))
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 0;
> > + =A0 =A0 =A0 sprintf(buf, "%s:0", disk->serial);
> > + =A0 =A0 =A0 int len =3D strlen(buf);
> > + =A0 =A0 =A0 unsigned int shift =3D len - MAX_RAID_SERIAL_LEN + 1;
> > + =A0 =A0 =A0 strncpy((char *)disk->serial, &buf[shift],
> MAX_RAID_SERIAL_LEN);
>=20
> Other option-roms truncated the serial number just to make sure it di=
d
> not match (see mark_missing()), are you sure the ":0" matters?  And i=
f
> we are already tolerant of chopping characters why not just
> append/overwrite the end of the serial number.

I adapted the method to the one used by OROM- append ":0" at the end of=
 serial number and cut at the beginning if size > MAX_RAID_SERIAL_LEN.

>=20
> > =A0 =A0 =A0 =A0disk->status |=3D FAILED_DISK;
> > - =A0 =A0 =A0 disk->status &=3D ~CONFIGURED_DISK;
>=20
> The  Windows driver was observed making this modification, but maybe
> only in the "missing" case.  Have you verified that this works in the
> failed but still present case (versus the device gone case).

This was verified under OROM and Windows.
If disk has been configured and become member of an array CONFIGURED_DI=
SK bit is set and it is not reset even though disk is missing or failed=
=2E

>=20
> > =A0 =A0 =A0 =A0set_imsm_ord_tbl_ent(map, slot, idx | IMSM_ORD_REBUI=
LD);
> > =A0 =A0 =A0 =A0if (map->failed_disk_num =3D=3D 0xff)
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0map->failed_disk_num =3D slot;
> > @@ -6063,16 +6068,16 @@ static int apply_takeover_update(struct
> imsm_update_takeover *u,
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*space_list =3D *spa=
ce;
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0du =3D (void *)space=
;
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0memcpy(du, super->di=
sks, sizeof(*du));
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 du->disk.status =3D F=
AILED_DISK;
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 du->disk.scsi_id =3D =
0;
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 du->disk.status =3D C=
ONFIGURED_DISK |
> FAILED_DISK;
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 du->disk.scsi_id =3D =
~0;
>=20
> Looks like the code has grown some open coded duplications of what
> mark_failure() is doing.  Let's unify this.  Keep subtle compatibilit=
y
> logic confined to one location.

OK. Changed

>=20
> --
> Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
