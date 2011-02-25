From: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Subject: [PATCH] FIX: imsm: OROM does not recognize degraded arrays (V2)
Date: Fri, 25 Feb 2011 02:17:18 +0100
Message-ID: <20110225011718.9377.67311.stgit@gklab-128-111.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, adam.kwolek@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

Defect description:
When we create an redundant array in mdadm and then degrade it
by disk removing, Option ROM and Windows OS does not detect any array.
Reason:
Metadata created and updated after degrading array is not compatible
with IMSM standard.

This patch synchronizes the metadata according IMSM requirements.
Following inconsistencies have been fixed:
- reset all fields in imsm_dev during creation to avoid random values
- init dev status during creation to proper state
- not reset CONFIGURED_DISK flag when disk is missing
- add ":0" suffix to the serial number for missing/failed disks
- update medatada signature after takeover operation
- mark map state as degraded after raid0->raid10 takeover

Note:
Patch reworked after Dan Willams review.

Signed-off-by: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
---
 super-intel.c |   30 ++++++++++++++++++------------
 1 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index c101dca..1a7be71 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -3431,12 +3431,13 @@ static int init_super_imsm_volume(struct supertype *st, mdu_array_info_t *info,
 		fprintf(stderr, Name ": failed to allocate device list entry\n");
 		return 0;
 	}
-	dev = malloc(sizeof(*dev) + sizeof(__u32) * (info->raid_disks - 1));
+	dev = calloc(1, sizeof(*dev) + sizeof(__u32) * (info->raid_disks - 1));
 	if (!dev) {
 		free(dv);
 		fprintf(stderr, Name": could not allocate raid device\n");
 		return 0;
 	}
+
 	strncpy((char *) dev->volume, name, MAX_RAID_SERIAL_LEN);
 	if (info->level == 1)
 		array_blocks = info_to_blocks_per_member(info);
@@ -3449,8 +3450,7 @@ static int init_super_imsm_volume(struct supertype *st, mdu_array_info_t *info,
 
 	dev->size_low = __cpu_to_le32((__u32) array_blocks);
 	dev->size_high = __cpu_to_le32((__u32) (array_blocks >> 32));
-	dev->status = __cpu_to_le32(0);
-	dev->reserved_blocks = __cpu_to_le32(0);
+	dev->status = (DEV_READ_COALESCING | DEV_WRITE_COALESCING);
 	vol = &dev->vol;
 	vol->migr_state = 0;
 	set_migr_type(dev, MIGR_INIT);
@@ -5046,6 +5046,8 @@ static int mark_failure(struct imsm_dev *dev, struct imsm_disk *disk, int idx)
 	__u32 ord;
 	int slot;
 	struct imsm_map *map;
+	char buf[MAX_RAID_SERIAL_LEN+3];
+	unsigned int len, shift = 0;
 
 	/* new failures are always set in map[0] */
 	map = get_imsm_map(dev, 0);
@@ -5058,8 +5060,12 @@ static int mark_failure(struct imsm_dev *dev, struct imsm_disk *disk, int idx)
 	if (is_failed(disk) && (ord & IMSM_ORD_REBUILD))
 		return 0;
 
+	sprintf(buf, "%s:0", disk->serial);
+	if ((len = strlen(buf)) >= MAX_RAID_SERIAL_LEN)
+		shift = len - MAX_RAID_SERIAL_LEN + 1;
+	strncpy((char *)disk->serial, &buf[shift], MAX_RAID_SERIAL_LEN);
+
 	disk->status |= FAILED_DISK;
-	disk->status &= ~CONFIGURED_DISK;
 	set_imsm_ord_tbl_ent(map, slot, idx | IMSM_ORD_REBUILD);
 	if (map->failed_disk_num == 0xff)
 		map->failed_disk_num = slot;
@@ -6063,8 +6069,6 @@ static int apply_takeover_update(struct imsm_update_takeover *u,
 			*space_list = *space;
 			du = (void *)space;
 			memcpy(du, super->disks, sizeof(*du));
-			du->disk.status = FAILED_DISK;
-			du->disk.scsi_id = 0;
 			du->fd = -1;
 			du->minor = 0;
 			du->major = 0;
@@ -6085,9 +6089,8 @@ static int apply_takeover_update(struct imsm_update_takeover *u,
 		memcpy(dev_new, dev, sizeof(*dev));
 		/* update new map */
 		map = get_imsm_map(dev_new, 0);
-		map->failed_disk_num = map->num_members;
 		map->num_members = map->num_members * 2;
-		map->map_state = IMSM_T_STATE_NORMAL;
+		map->map_state = IMSM_T_STATE_DEGRADED;
 		map->num_domains = 2;
 		map->raid_level = 1;
 		/* replace dev<->dev_new */
@@ -6098,9 +6101,10 @@ static int apply_takeover_update(struct imsm_update_takeover *u,
 		if (du->index >= 0)
 			set_imsm_ord_tbl_ent(map, du->index, du->index);
 	for (du = super->missing; du; du = du->next)
-		if (du->index >= 0)
-			set_imsm_ord_tbl_ent(map, du->index,
-						du->index | IMSM_ORD_REBUILD);
+		if (du->index >= 0) {
+			set_imsm_ord_tbl_ent(map, du->index, du->index);
+			mark_missing(dev_new, &du->disk, du->index);
+		}
 
 	return 1;
 }
@@ -6149,8 +6153,10 @@ static void imsm_process_update(struct supertype *st,
 	switch (type) {
 	case update_takeover: {
 		struct imsm_update_takeover *u = (void *)update->buf;
-		if (apply_takeover_update(u, super, &update->space_list))
+		if (apply_takeover_update(u, super, &update->space_list)) {
+			imsm_update_version_info(super);
 			super->updates_pending++;
+		}
 		break;
 	}
 

