From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] FIX: imsm: OROM does not recognize degraded arrays
Date: Thu, 24 Feb 2011 09:42:53 -0800
Message-ID: <AANLkTinS06EtPvr59C2ZY=gD8JFrp0AfAbmXAwWdjG5m@mail.gmail.com>
References: <20110224065357.5594.92371.stgit@gklab-128-111.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110224065357.5594.92371.stgit@gklab-128-111.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Cc: neilb@suse.de, linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, adam.kwolek@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

Thanks Krzysztof, comments below:

On Wed, Feb 23, 2011 at 10:53 PM, Krzysztof Wojcik
<krzysztof.wojcik@intel.com> wrote:
> Defect description:
> When we create an redundant array in mdadm and then degrade it
> by disk removing, Option ROM and Windows OS does not detect any array=
=2E
> Reason:
> Metadata created and updated after degrading array is not compatible
> with IMSM standard.
>
> This patch synchronizes the metadata according IMSM requirements.
> Following inconsistencies have been fixed:
> - reset all fields in imsm_dev during creation to avoid random values
> - init dev status during creation to proper state
> - not reset CONFIGURED_DISK flag when disk is missing
> - add ":0" suffix to the serial number for missing/failed disks
> - update medatada signature after takeover operation
> - mark map state as degraded after raid0->raid10 takeover
>
> Signed-off-by: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
> ---
> =A0super-intel.c | =A0 27 +++++++++++++++++----------
> =A01 files changed, 17 insertions(+), 10 deletions(-)
>
> diff --git a/super-intel.c b/super-intel.c
> index c101dca..a40b7e5 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -3437,6 +3437,8 @@ static int init_super_imsm_volume(struct supert=
ype *st, mdu_array_info_t *info,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0fprintf(stderr, Name": could not alloc=
ate raid device\n");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 0;
> =A0 =A0 =A0 =A0}
> + =A0 =A0 =A0 memset(dev, 0, (sizeof(*dev) + sizeof(__u32) * (info->r=
aid_disks - 1)));
> +

Consider changing the allocation to calloc, or store the size in a
temporary variable so we don't duplicate the size calculation.

> =A0 =A0 =A0 =A0strncpy((char *) dev->volume, name, MAX_RAID_SERIAL_LE=
N);
> =A0 =A0 =A0 =A0if (info->level =3D=3D 1)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0array_blocks =3D info_to_blocks_per_me=
mber(info);
> @@ -3449,8 +3451,7 @@ static int init_super_imsm_volume(struct supert=
ype *st, mdu_array_info_t *info,
>
> =A0 =A0 =A0 =A0dev->size_low =3D __cpu_to_le32((__u32) array_blocks);
> =A0 =A0 =A0 =A0dev->size_high =3D __cpu_to_le32((__u32) (array_blocks=
 >> 32));
> - =A0 =A0 =A0 dev->status =3D __cpu_to_le32(0);
> - =A0 =A0 =A0 dev->reserved_blocks =3D __cpu_to_le32(0);
> + =A0 =A0 =A0 dev->status =3D (DEV_READ_COALESCING | DEV_WRITE_COALES=
CING);

The orom will fail to assemble arrays without these status bits set?

> =A0 =A0 =A0 =A0vol =3D &dev->vol;
> =A0 =A0 =A0 =A0vol->migr_state =3D 0;
> =A0 =A0 =A0 =A0set_migr_type(dev, MIGR_INIT);
> @@ -5046,6 +5047,7 @@ static int mark_failure(struct imsm_dev *dev, s=
truct imsm_disk *disk, int idx)
> =A0 =A0 =A0 =A0__u32 ord;
> =A0 =A0 =A0 =A0int slot;
> =A0 =A0 =A0 =A0struct imsm_map *map;
> + =A0 =A0 =A0 char buf[PATH_MAX];

This is a very large stack allocation which is potentially problematic
for mdmon.

>
> =A0 =A0 =A0 =A0/* new failures are always set in map[0] */
> =A0 =A0 =A0 =A0map =3D get_imsm_map(dev, 0);
> @@ -5057,9 +5059,12 @@ static int mark_failure(struct imsm_dev *dev, =
struct imsm_disk *disk, int idx)
> =A0 =A0 =A0 =A0ord =3D __le32_to_cpu(map->disk_ord_tbl[slot]);
> =A0 =A0 =A0 =A0if (is_failed(disk) && (ord & IMSM_ORD_REBUILD))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 0;
> + =A0 =A0 =A0 sprintf(buf, "%s:0", disk->serial);
> + =A0 =A0 =A0 int len =3D strlen(buf);
> + =A0 =A0 =A0 unsigned int shift =3D len - MAX_RAID_SERIAL_LEN + 1;
> + =A0 =A0 =A0 strncpy((char *)disk->serial, &buf[shift], MAX_RAID_SER=
IAL_LEN);

Other option-roms truncated the serial number just to make sure it did
not match (see mark_missing()), are you sure the ":0" matters?  And if
we are already tolerant of chopping characters why not just
append/overwrite the end of the serial number.

> =A0 =A0 =A0 =A0disk->status |=3D FAILED_DISK;
> - =A0 =A0 =A0 disk->status &=3D ~CONFIGURED_DISK;

The  Windows driver was observed making this modification, but maybe
only in the "missing" case.  Have you verified that this works in the
failed but still present case (versus the device gone case).

> =A0 =A0 =A0 =A0set_imsm_ord_tbl_ent(map, slot, idx | IMSM_ORD_REBUILD=
);
> =A0 =A0 =A0 =A0if (map->failed_disk_num =3D=3D 0xff)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0map->failed_disk_num =3D slot;
> @@ -6063,16 +6068,16 @@ static int apply_takeover_update(struct imsm_=
update_takeover *u,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*space_list =3D *space=
;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0du =3D (void *)space;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0memcpy(du, super->disk=
s, sizeof(*du));
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 du->disk.status =3D FAI=
LED_DISK;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 du->disk.scsi_id =3D 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 du->disk.status =3D CON=
=46IGURED_DISK | FAILED_DISK;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 du->disk.scsi_id =3D ~0=
;

Looks like the code has grown some open coded duplications of what
mark_failure() is doing.  Let's unify this.  Keep subtle compatibility
logic confined to one location.

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
