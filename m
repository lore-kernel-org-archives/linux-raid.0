From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 37/53] mdadm: second_map enhancement for imsm_get_map()
Date: Fri, 26 Nov 2010 09:08:39 +0100
Message-ID: <20101126080839.5221.71397.stgit@gklab-170-024.igk.intel.com>
References: <20101126075407.5221.62582.stgit@gklab-170-024.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101126075407.5221.62582.stgit@gklab-170-024.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

Allow map related operations for the given map: first of second.
For reshape specific functionality it is required to have an access

Until now, the active map was chosen according to the current volume status.

Signed-off-by: Maciej Trela <maciej.trela@intel.com>
Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |   69 ++++++++++++++++++++++++++++++++-------------------------
 1 files changed, 39 insertions(+), 30 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index e57a127..eea5fec 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -519,23 +519,33 @@ static struct imsm_dev *get_imsm_dev(struct intel_super *super, __u8 index)
 	return NULL;
 }
 
-static __u32 get_imsm_ord_tbl_ent(struct imsm_dev *dev, int slot)
+/*
+ * for second_map:
+ *  == 0 get first map
+ *  == 1 get second map
+ *  == -1 than get map according to the current migr_state
+ */
+static __u32 get_imsm_ord_tbl_ent(struct imsm_dev *dev, int slot, int second_map)
 {
 	struct imsm_map *map;
 
-	if (dev->vol.migr_state)
-		map = get_imsm_map(dev, 1);
-	else
-		map = get_imsm_map(dev, 0);
+	if (second_map == -1) {
+		if (dev->vol.migr_state)
+			map = get_imsm_map(dev, 1);
+		else
+			map = get_imsm_map(dev, 0);
+	} else {
+		map = get_imsm_map(dev, second_map);
+	}
 
 	/* top byte identifies disk under rebuild */
 	return __le32_to_cpu(map->disk_ord_tbl[slot]);
 }
 
 #define ord_to_idx(ord) (((ord) << 8) >> 8)
-static __u32 get_imsm_disk_idx(struct imsm_dev *dev, int slot)
+static __u32 get_imsm_disk_idx(struct imsm_dev *dev, int slot, int second_map)
 {
-	__u32 ord = get_imsm_ord_tbl_ent(dev, slot);
+	__u32 ord = get_imsm_ord_tbl_ent(dev, slot, second_map);
 
 	return ord_to_idx(ord);
 }
@@ -712,13 +722,13 @@ static void print_imsm_dev(struct imsm_dev *dev, char *uuid, int disk_idx)
 	printf("        Members : %d\n", map->num_members);
 	printf("          Slots : [");
 	for (i = 0; i < map->num_members; i++) {
-		ord = get_imsm_ord_tbl_ent(dev, i);
+		ord = get_imsm_ord_tbl_ent(dev, i, -1);
 		printf("%s", ord & IMSM_ORD_REBUILD ? "_" : "U");
 	}
 	printf("]\n");
 	slot = get_imsm_disk_slot(map, disk_idx);
 	if (slot >= 0) {
-		ord = get_imsm_ord_tbl_ent(dev, slot);
+		ord = get_imsm_ord_tbl_ent(dev, slot, -1);
 		printf("      This Slot : %d%s\n", slot,
 		       ord & IMSM_ORD_REBUILD ? " (out-of-sync)" : "");
 	} else
@@ -1356,12 +1366,12 @@ static __u32 num_stripes_per_unit_rebuild(struct imsm_dev *dev)
 		return num_stripes_per_unit_resync(dev);
 }
 
-static __u8 imsm_num_data_members(struct imsm_dev *dev)
+static __u8 imsm_num_data_members(struct imsm_dev *dev, int second_map)
 {
 	/* named 'imsm_' because raid0, raid1 and raid10
 	 * counter-intuitively have the same number of data disks
 	 */
-	struct imsm_map *map = get_imsm_map(dev, 0);
+	struct imsm_map *map = get_imsm_map(dev, second_map);
 
 	switch (get_imsm_raid_level(map)) {
 	case 0:
@@ -1444,7 +1454,7 @@ static __u64 blocks_per_migr_unit(struct imsm_dev *dev)
 		 */
 		stripes_per_unit = num_stripes_per_unit_resync(dev);
 		migr_chunk = migr_strip_blocks_resync(dev);
-		disks = imsm_num_data_members(dev);
+		disks = imsm_num_data_members(dev, 0);
 		blocks_per_unit = stripes_per_unit * migr_chunk * disks;
 		stripe = __le32_to_cpu(map->blocks_per_strip) * disks;
 		segment = blocks_per_unit / stripe;
@@ -1675,7 +1685,7 @@ static void getinfo_super_imsm(struct supertype *st, struct mdinfo *info)
 			 * (catches single-degraded vs double-degraded)
 			 */
 			for (j = 0; j < map->num_members; j++) {
-				__u32 ord = get_imsm_ord_tbl_ent(dev, i);
+				__u32 ord = get_imsm_ord_tbl_ent(dev, i, -1);
 				__u32 idx = ord_to_idx(ord);
 
 				if (!(ord & IMSM_ORD_REBUILD) &&
@@ -3383,7 +3393,7 @@ static int add_to_super_imsm_volume(struct supertype *st, mdu_disk_info_t *dk,
 	/* Check the device has not already been added */
 	slot = get_imsm_disk_slot(map, dl->index);
 	if (slot >= 0 &&
-	    (get_imsm_ord_tbl_ent(dev, slot) & IMSM_ORD_REBUILD) == 0) {
+	    (get_imsm_ord_tbl_ent(dev, slot, -1) & IMSM_ORD_REBUILD) == 0) {
 		fprintf(stderr, Name ": %s has been included in this array twice\n",
 			devname);
 		return 1;
@@ -3629,7 +3639,7 @@ static int create_array(struct supertype *st, int dev_idx)
 	imsm_copy_dev(&u->dev, dev);
 	inf = get_disk_info(u);
 	for (i = 0; i < map->num_members; i++) {
-		int idx = get_imsm_disk_idx(dev, i);
+		int idx = get_imsm_disk_idx(dev, i, -1);
 
 		disk = get_imsm_disk(super, idx);
 		serialcpy(inf[i].serial, disk->serial);
@@ -4503,8 +4513,8 @@ static struct mdinfo *container_content_imsm(struct supertype *st)
 			__u32 ord;
 
 			skip = 0;
-			idx = get_imsm_disk_idx(dev, slot);
-			ord = get_imsm_ord_tbl_ent(dev, slot); 
+			idx = get_imsm_disk_idx(dev, slot, 0);
+			ord = get_imsm_ord_tbl_ent(dev, slot, 0);
 			for (d = super->disks; d ; d = d->next)
 				if (d->index == idx)
 					break;
@@ -4599,7 +4609,7 @@ static __u8 imsm_check_degraded(struct intel_super *super, struct imsm_dev *dev,
 		int insync = insync;
 
 		for (i = 0; i < map->num_members; i++) {
-			__u32 ord = get_imsm_ord_tbl_ent(dev, i);
+			__u32 ord = get_imsm_ord_tbl_ent(dev, i, -1);
 			int idx = ord_to_idx(ord);
 			struct imsm_disk *disk;
 
@@ -4883,7 +4893,7 @@ static void imsm_set_disk(struct active_array *a, int n, int state)
 
 	dprintf("imsm: set_disk %d:%x\n", n, state);
 
-	ord = get_imsm_ord_tbl_ent(dev, n);
+	ord = get_imsm_ord_tbl_ent(dev, n, -1);
 	disk = get_imsm_disk(super, ord_to_idx(ord));
 
 	/* check for new failures */
@@ -4990,7 +5000,7 @@ static void imsm_sync_metadata(struct supertype *container)
 static struct dl *imsm_readd(struct intel_super *super, int idx, struct active_array *a)
 {
 	struct imsm_dev *dev = get_imsm_dev(super, a->info.container_member);
-	int i = get_imsm_disk_idx(dev, idx);
+	int i = get_imsm_disk_idx(dev, idx, -1);
 	struct dl *dl;
 
 	for (dl = super->disks; dl; dl = dl->next)
@@ -5011,7 +5021,7 @@ static struct dl *imsm_add_spare(struct intel_super *super, int slot,
 				 struct mdinfo *additional_test_list)
 {
 	struct imsm_dev *dev = get_imsm_dev(super, a->info.container_member);
-	int idx = get_imsm_disk_idx(dev, slot);
+	int idx = get_imsm_disk_idx(dev, slot, -1);
 	struct imsm_super *mpb = super->anchor;
 	struct imsm_map *map;
 	unsigned long long pos;
@@ -5276,7 +5286,7 @@ static int disks_overlap(struct intel_super *super, int idx, struct imsm_update_
 	int j;
 
 	for (i = 0; i < map->num_members; i++) {
-		disk = get_imsm_disk(super, get_imsm_disk_idx(dev, i));
+		disk = get_imsm_disk(super, get_imsm_disk_idx(dev, i, -1));
 		for (j = 0; j < new_map->num_members; j++)
 			if (serialcmp(disk->serial, inf[j].serial) == 0)
 				return 1;
@@ -5527,7 +5537,7 @@ update_reshape_exit:
 		end_migration(dev, map_1->map_state);
 		/* array size rollback
 		 */
-		used_disks = imsm_num_data_members(dev);
+		used_disks = imsm_num_data_members(dev, 0);
 		if (used_disks) {
 			array_blocks = map_1->blocks_per_member * used_disks;
 			/* round array size down to closest MB
@@ -5602,7 +5612,7 @@ update_reshape_exit:
 		struct dl *dl;
 		unsigned int found;
 		int failed;
-		int victim = get_imsm_disk_idx(dev, u->slot);
+		int victim = get_imsm_disk_idx(dev, u->slot, -1);
 		int i;
 
 		for (dl = super->disks; dl; dl = dl->next)
@@ -5625,7 +5635,7 @@ update_reshape_exit:
 		for (i = 0; i < map->num_members; i++) {
 			if (i == u->slot)
 				continue;
-			disk = get_imsm_disk(super, get_imsm_disk_idx(dev, i));
+			disk = get_imsm_disk(super, get_imsm_disk_idx(dev, i, -1));
 			if (!disk || is_failed(disk))
 				failed++;
 		}
@@ -6091,7 +6101,7 @@ static void imsm_delete(struct intel_super *super, struct dl **dlp, unsigned ind
 			/* update ord entries being careful not to propagate
 			 * ord-flags to the first map
 			 */
-			ord = get_imsm_ord_tbl_ent(dev, j);
+			ord = get_imsm_ord_tbl_ent(dev, j, -1);
 
 			if (ord_to_idx(ord) <= index)
 				continue;
@@ -6182,7 +6192,7 @@ static int update_level_imsm(struct supertype *st, struct mdinfo *info,
 			    (dl->minor != newdi->disk.minor))
 				continue;
 			slot = get_imsm_disk_slot(map, dl->index);
-			idx = get_imsm_ord_tbl_ent(dev_new, slot);
+			idx = get_imsm_ord_tbl_ent(dev_new, slot, 0);
 			tmp_ord_tbl[newdi->disk.raid_disk] = idx;
 			break;
 		}
@@ -6295,7 +6305,7 @@ int imsm_reshape_is_allowed_on_container(struct supertype *st,
 			ret_val = 0;
 			break;
 		}
-		used_disks = imsm_num_data_members(dev);
+		used_disks = imsm_num_data_members(dev, 0);
 		dprintf("read raid_disks = %i\n", used_disks);
 		dprintf("read requested disks = %i\n", geo->raid_disks);
 		array_blocks = map->blocks_per_member * used_disks;
@@ -6635,8 +6645,7 @@ calculate_size_only:
 	/* calculate new size
 	 */
 	if (new_map != NULL) {
-
-		used_disks = imsm_num_data_members(upd_devs);
+		used_disks = imsm_num_data_members(upd_devs, 0);
 		if (used_disks) {
 			array_blocks = new_map->blocks_per_member * used_disks;
 			/* round array size down to closest MB

