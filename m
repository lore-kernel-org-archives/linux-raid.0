From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 7/9] imsm: support 'missing' devices at Create
Date: Thu, 25 Aug 2011 19:14:35 -0700
Message-ID: <20110826021434.28015.93967.stgit@localhost6.localdomain6>
References: <20110826020908.28015.52384.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110826020908.28015.52384.stgit@localhost6.localdomain6>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, marcin.labun@intel.com, Dave Jiang <dave.jiang@intel.com>, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

Specifying missing devices at create is very useful for array recovery.

For imsm create dummy disk entries at init_super_imsm time, and then use
them to fill in unoccupied slots in the final array (if the container is
unpopulated).

If the container is already populated (has a subarray)
'missing' disks must be in reference to already recorded missing devices
in the metadata.

Cc: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 super-intel.c |   71 ++++++++++++++++++++++++++++++++++++++++++++++++++-------
 1 files changed, 62 insertions(+), 9 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 193e0d0..fee620d 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -4133,12 +4133,40 @@ static int init_super_imsm_volume(struct supertype *st, mdu_array_info_t *info,
 		memset(mpb_new + size_old, 0, size_round - size_old);
 	}
 	super->current_vol = idx;
-	/* when creating the first raid device in this container set num_disks
-	 * to zero, i.e. delete this spare and add raid member devices in
-	 * add_to_super_imsm_volume()
+
+	/* handle 'failed_disks' by either:
+	 * a) create dummy disk entries in the table if this the first
+	 *    volume in the array.  We add them here as this is the only
+	 *    opportunity to add them. add_to_super_imsm_volume()
+	 *    handles the non-failed disks and continues incrementing
+	 *    mpb->num_disks.
+	 * b) validate that 'failed_disks' matches the current number
+	 *    of missing disks if the container is populated
 	 */
-	if (super->current_vol == 0)
+	if (super->current_vol == 0) {
 		mpb->num_disks = 0;
+		for (i = 0; i < info->failed_disks; i++) {
+			struct imsm_disk *disk;
+
+			mpb->num_disks++;
+			disk = __get_imsm_disk(mpb, i);
+			disk->status = CONFIGURED_DISK | FAILED_DISK;
+			disk->scsi_id = __cpu_to_le32(~(__u32)0);
+			snprintf((char *) disk->serial, MAX_RAID_SERIAL_LEN,
+				 "missing:%d", i);
+		}
+		find_missing(super);
+	} else {
+		int missing = 0;
+		struct dl *d;
+
+		for (d = super->missing; d; d = d->next)
+			missing++;
+		if (info->failed_disks > missing) {
+			fprintf(stderr, Name": unable to add 'missing' disk to container\n");
+			return 0;
+		}
+	}
 
 	if (!check_name(super, name, 0))
 		return 0;
@@ -4170,15 +4198,14 @@ static int init_super_imsm_volume(struct supertype *st, mdu_array_info_t *info,
 	vol = &dev->vol;
 	vol->migr_state = 0;
 	set_migr_type(dev, MIGR_INIT);
-	vol->dirty = 0;
+	vol->dirty = !info->state;
 	vol->curr_migr_unit = 0;
 	map = get_imsm_map(dev, 0);
 	map->pba_of_lba0 = __cpu_to_le32(super->create_offset);
 	map->blocks_per_member = __cpu_to_le32(info_to_blocks_per_member(info));
 	map->blocks_per_strip = __cpu_to_le16(info_to_blocks_per_strip(info));
 	map->failed_disk_num = ~0;
-	map->map_state = info->level ? IMSM_T_STATE_UNINITIALIZED :
-				       IMSM_T_STATE_NORMAL;
+	map->map_state = info->failed_disks ? IMSM_T_STATE_DEGRADED : IMSM_T_STATE_NORMAL;
 	map->ddf = 1;
 
 	if (info->level == 1 && info->raid_disks > 2) {
@@ -4286,9 +4313,10 @@ static int add_to_super_imsm_volume(struct supertype *st, mdu_disk_info_t *dk,
 {
 	struct intel_super *super = st->sb;
 	struct imsm_super *mpb = super->anchor;
-	struct dl *dl;
+	struct imsm_disk *_disk;
 	struct imsm_dev *dev;
 	struct imsm_map *map;
+	struct dl *dl, *df;
 	int slot;
 
 	dev = get_imsm_dev(super, super->current_vol);
@@ -4335,12 +4363,37 @@ static int add_to_super_imsm_volume(struct supertype *st, mdu_disk_info_t *dk,
 	set_imsm_ord_tbl_ent(map, dk->raid_disk, dl->index);
 	dl->disk.status = CONFIGURED_DISK;
 
+	/* update size of 'missing' disks to be at least as large as the
+	 * largest acitve member (we only have dummy missing disks when
+	 * creating the first volume)
+	 */
+	if (super->current_vol == 0) {
+		for (df = super->missing; df; df = df->next) {
+			if (dl->disk.total_blocks > df->disk.total_blocks)
+				df->disk.total_blocks = dl->disk.total_blocks;
+			_disk = __get_imsm_disk(mpb, df->index);
+			*_disk = df->disk;
+		}
+	}
+
+	/* refresh unset/failed slots to point to valid 'missing' entries */
+	for (df = super->missing; df; df = df->next)
+		for (slot = 0; slot < mpb->num_disks; slot++) {
+			__u32 ord = get_imsm_ord_tbl_ent(dev, slot, -1);
+
+			if ((ord & IMSM_ORD_REBUILD) == 0)
+				continue;
+			set_imsm_ord_tbl_ent(map, slot, df->index | IMSM_ORD_REBUILD);
+			dprintf("set slot:%d to missing disk:%d\n", slot, df->index);
+			break;
+		}
+
 	/* if we are creating the first raid device update the family number */
 	if (super->current_vol == 0) {
 		__u32 sum;
 		struct imsm_dev *_dev = __get_imsm_dev(mpb, 0);
-		struct imsm_disk *_disk = __get_imsm_disk(mpb, dl->index);
 
+		_disk = __get_imsm_disk(mpb, dl->index);
 		if (!_dev || !_disk) {
 			fprintf(stderr, Name ": BUG mpb setup error\n");
 			return 1;

