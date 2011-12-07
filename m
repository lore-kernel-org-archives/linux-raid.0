From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 9/9] imsm: FIX: Use defines for device map access
Date: Wed, 07 Dec 2011 13:58:46 +0100
Message-ID: <20111207125846.25279.80957.stgit@gklab-128-013.igk.intel.com>
References: <20111207125549.25279.43741.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111207125549.25279.43741.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

Maps should not be accessed using "magic numbers" /0, 1,-1/.
Add proper definitions and change all map access to use them.
Change present definitions /MAP_0/MAP_1/ to values already used
in code /0, 1, -1//

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |  268 +++++++++++++++++++++++++++++----------------------------
 1 files changed, 136 insertions(+), 132 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 7f9c64f..cea314c 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -108,8 +108,9 @@ struct imsm_disk {
 
 /* map selector for map managment
  */
-#define MAP_0		2
-#define MAP_1		4
+#define MAP_0		0
+#define MAP_1		1
+#define MAP_X		-1
 
 /* RAID map configuration infos. */
 struct imsm_map {
@@ -667,9 +668,9 @@ struct imsm_map *get_imsm_map(struct imsm_dev *dev, int second_map)
 {
 	/* A device can have 2 maps if it is in the middle of a migration.
 	 * If second_map is:
-	 *    MAP_0 or 0   - we return the first map
-	 *    MAP_1 or 1   - we return the second map if it exists, else NULL
-	 *   -1   - we return the second map if it exists, else the first
+	 *    MAP_0 - we return the first map
+	 *    MAP_1 - we return the second map if it exists, else NULL
+	 *    MAP_X - we return the second map if it exists, else the first
 	 */
 	struct imsm_map *map = &dev->vol.map[0];
 	struct imsm_map *map2 = NULL;
@@ -679,13 +680,11 @@ struct imsm_map *get_imsm_map(struct imsm_dev *dev, int second_map)
 
 	switch (second_map) {
 	case MAP_0:
-	case 0:
 		break;
 	case MAP_1:
-	case 1:
 		map = map2;
 		break;
-	case -1:
+	case MAP_X:
 		if (map2)
 			map = map2;
 		break;
@@ -702,13 +701,13 @@ struct imsm_map *get_imsm_map(struct imsm_dev *dev, int second_map)
 static size_t sizeof_imsm_dev(struct imsm_dev *dev, int migr_state)
 {
 	size_t size = sizeof(*dev) - sizeof(struct imsm_map) +
-		      sizeof_imsm_map(get_imsm_map(dev, 0));
+		      sizeof_imsm_map(get_imsm_map(dev, MAP_0));
 
 	/* migrating means an additional map */
 	if (dev->vol.migr_state)
-		size += sizeof_imsm_map(get_imsm_map(dev, 1));
+		size += sizeof_imsm_map(get_imsm_map(dev, MAP_1));
 	else if (migr_state)
-		size += sizeof_imsm_map(get_imsm_map(dev, 0));
+		size += sizeof_imsm_map(get_imsm_map(dev, MAP_0));
 
 	return size;
 }
@@ -762,9 +761,9 @@ static struct imsm_dev *get_imsm_dev(struct intel_super *super, __u8 index)
 
 /*
  * for second_map:
- *  == 0 get first map
- *  == 1 get second map
- *  == -1 than get map according to the current migr_state
+ *  == MAP_0 get first map
+ *  == MAP_1 get second map
+ *  == MAP_X than get map according to the current migr_state
  */
 static __u32 get_imsm_ord_tbl_ent(struct imsm_dev *dev,
 				  int slot,
@@ -835,7 +834,7 @@ static int count_memberships(struct dl *dl, struct intel_super *super)
 
 	for (i = 0; i < super->anchor->num_raid_devs; i++) {
 		struct imsm_dev *dev = get_imsm_dev(super, i);
-		struct imsm_map *map = get_imsm_map(dev, 0);
+		struct imsm_map *map = get_imsm_map(dev, MAP_0);
 
 		if (get_imsm_disk_slot(map, dl->index) >= 0)
 			memberships++;
@@ -870,7 +869,7 @@ static struct extent *get_extents(struct intel_super *super, struct dl *dl)
 
 	for (i = 0; i < super->anchor->num_raid_devs; i++) {
 		struct imsm_dev *dev = get_imsm_dev(super, i);
-		struct imsm_map *map = get_imsm_map(dev, 0);
+		struct imsm_map *map = get_imsm_map(dev, MAP_0);
 
 		if (get_imsm_disk_slot(map, dl->index) >= 0) {
 			e->start = __le32_to_cpu(map->pba_of_lba0);
@@ -1043,8 +1042,8 @@ static void print_imsm_dev(struct intel_super *super,
 {
 	__u64 sz;
 	int slot, i;
-	struct imsm_map *map = get_imsm_map(dev, 0);
-	struct imsm_map *map2 = get_imsm_map(dev, 1);
+	struct imsm_map *map = get_imsm_map(dev, MAP_0);
+	struct imsm_map *map2 = get_imsm_map(dev, MAP_1);
 	__u32 ord;
 
 	printf("\n");
@@ -1060,14 +1059,14 @@ static void print_imsm_dev(struct intel_super *super,
 	printf("\n");
 	printf("          Slots : [");
 	for (i = 0; i < map->num_members; i++) {
-		ord = get_imsm_ord_tbl_ent(dev, i, 0);
+		ord = get_imsm_ord_tbl_ent(dev, i, MAP_0);
 		printf("%s", ord & IMSM_ORD_REBUILD ? "_" : "U");
 	}
 	printf("]");
 	if (map2) {
 		printf(" <-- [");
 		for (i = 0; i < map2->num_members; i++) {
-			ord = get_imsm_ord_tbl_ent(dev, i, 1);
+			ord = get_imsm_ord_tbl_ent(dev, i, MAP_1);
 			printf("%s", ord & IMSM_ORD_REBUILD ? "_" : "U");
 		}
 		printf("]");
@@ -1081,7 +1080,7 @@ static void print_imsm_dev(struct intel_super *super,
 	printf("\n");
 	slot = get_imsm_disk_slot(map, disk_idx);
 	if (slot >= 0) {
-		ord = get_imsm_ord_tbl_ent(dev, slot, -1);
+		ord = get_imsm_ord_tbl_ent(dev, slot, MAP_X);
 		printf("      This Slot : %d%s\n", slot,
 		       ord & IMSM_ORD_REBUILD ? " (out-of-sync)" : "");
 	} else
@@ -1125,7 +1124,7 @@ static void print_imsm_dev(struct intel_super *super,
 		printf("idle\n");
 	printf("      Map State : %s", map_state_str[map->map_state]);
 	if (dev->vol.migr_state) {
-		struct imsm_map *map = get_imsm_map(dev, 1);
+		struct imsm_map *map = get_imsm_map(dev, MAP_1);
 
 		printf(" <-- %s", map_state_str[map->map_state]);
 		printf("\n     Checkpoint : %u ",
@@ -1860,7 +1859,7 @@ get_imsm_numerical_version(struct imsm_super *mpb, int *m, int *p)
 static __u32 migr_strip_blocks_resync(struct imsm_dev *dev)
 {
 	/* migr_strip_size when repairing or initializing parity */
-	struct imsm_map *map = get_imsm_map(dev, 0);
+	struct imsm_map *map = get_imsm_map(dev, MAP_0);
 	__u32 chunk = __le32_to_cpu(map->blocks_per_strip);
 
 	switch (get_imsm_raid_level(map)) {
@@ -1878,7 +1877,7 @@ static __u32 migr_strip_blocks_rebuild(struct imsm_dev *dev)
 	 * this is different than migr_strip_size_resync(), but it's good
 	 * to be compatible
 	 */
-	struct imsm_map *map = get_imsm_map(dev, 1);
+	struct imsm_map *map = get_imsm_map(dev, MAP_1);
 	__u32 chunk = __le32_to_cpu(map->blocks_per_strip);
 
 	switch (get_imsm_raid_level(map)) {
@@ -1897,8 +1896,8 @@ static __u32 migr_strip_blocks_rebuild(struct imsm_dev *dev)
 
 static __u32 num_stripes_per_unit_resync(struct imsm_dev *dev)
 {
-	struct imsm_map *lo = get_imsm_map(dev, 0);
-	struct imsm_map *hi = get_imsm_map(dev, 1);
+	struct imsm_map *lo = get_imsm_map(dev, MAP_0);
+	struct imsm_map *hi = get_imsm_map(dev, MAP_1);
 	__u32 lo_chunk = __le32_to_cpu(lo->blocks_per_strip);
 	__u32 hi_chunk = __le32_to_cpu(hi->blocks_per_strip);
 
@@ -1907,11 +1906,11 @@ static __u32 num_stripes_per_unit_resync(struct imsm_dev *dev)
 
 static __u32 num_stripes_per_unit_rebuild(struct imsm_dev *dev)
 {
-	struct imsm_map *lo = get_imsm_map(dev, 0);
+	struct imsm_map *lo = get_imsm_map(dev, MAP_0);
 	int level = get_imsm_raid_level(lo);
 
 	if (level == 1 || level == 10) {
-		struct imsm_map *hi = get_imsm_map(dev, 1);
+		struct imsm_map *hi = get_imsm_map(dev, MAP_1);
 
 		return hi->num_domains;
 	} else
@@ -1940,7 +1939,7 @@ static __u8 imsm_num_data_members(struct imsm_dev *dev, int second_map)
 
 static __u32 parity_segment_depth(struct imsm_dev *dev)
 {
-	struct imsm_map *map = get_imsm_map(dev, 0);
+	struct imsm_map *map = get_imsm_map(dev, MAP_0);
 	__u32 chunk =  __le32_to_cpu(map->blocks_per_strip);
 
 	switch(get_imsm_raid_level(map)) {
@@ -1956,7 +1955,7 @@ static __u32 parity_segment_depth(struct imsm_dev *dev)
 
 static __u32 map_migr_block(struct imsm_dev *dev, __u32 block)
 {
-	struct imsm_map *map = get_imsm_map(dev, 1);
+	struct imsm_map *map = get_imsm_map(dev, MAP_1);
 	__u32 chunk = __le32_to_cpu(map->blocks_per_strip);
 	__u32 strip = block / chunk;
 
@@ -1995,7 +1994,7 @@ static __u64 blocks_per_migr_unit(struct intel_super *super,
 	case MIGR_VERIFY:
 	case MIGR_REPAIR:
 	case MIGR_INIT: {
-		struct imsm_map *map = get_imsm_map(dev, 0);
+		struct imsm_map *map = get_imsm_map(dev, MAP_0);
 		__u32 stripes_per_unit;
 		__u32 blocks_per_unit;
 		__u32 parity_depth;
@@ -2011,7 +2010,7 @@ static __u64 blocks_per_migr_unit(struct intel_super *super,
 		 */
 		stripes_per_unit = num_stripes_per_unit_resync(dev);
 		migr_chunk = migr_strip_blocks_resync(dev);
-		disks = imsm_num_data_members(dev, 0);
+		disks = imsm_num_data_members(dev, MAP_0);
 		blocks_per_unit = stripes_per_unit * migr_chunk * disks;
 		stripe = __le16_to_cpu(map->blocks_per_strip) * disks;
 		segment = blocks_per_unit / stripe;
@@ -2284,8 +2283,8 @@ static void getinfo_super_imsm_volume(struct supertype *st, struct mdinfo *info,
 	struct intel_super *super = st->sb;
 	struct migr_record *migr_rec = super->migr_rec;
 	struct imsm_dev *dev = get_imsm_dev(super, super->current_vol);
-	struct imsm_map *map = get_imsm_map(dev, 0);
-	struct imsm_map *prev_map = get_imsm_map(dev, 1);
+	struct imsm_map *map = get_imsm_map(dev, MAP_0);
+	struct imsm_map *prev_map = get_imsm_map(dev, MAP_1);
 	struct imsm_map *map_to_analyse = map;
 	struct dl *dl;
 	char *devname;
@@ -2430,7 +2429,7 @@ static void getinfo_super_imsm_volume(struct supertype *st, struct mdinfo *info,
 				(unsigned long long)blocks_per_unit,
 				info->reshape_progress);
 
-			used_disks = imsm_num_data_members(dev, 1);
+			used_disks = imsm_num_data_members(dev, MAP_1);
 			if (used_disks > 0) {
 				array_blocks = map->blocks_per_member *
 					used_disks;
@@ -2475,7 +2474,7 @@ static void getinfo_super_imsm_volume(struct supertype *st, struct mdinfo *info,
 			dmap[i] = 0;
 			if (i < info->array.raid_disks) {
 				struct imsm_disk *dsk;
-				j = get_imsm_disk_idx(dev, i, -1);
+				j = get_imsm_disk_idx(dev, i, MAP_X);
 				dsk = get_imsm_disk(super, j);
 				if (dsk && (dsk->status & CONFIGURED_DISK))
 					dmap[i] = 1;
@@ -2498,8 +2497,7 @@ static void manage_second_map(struct intel_super *super, struct imsm_dev *dev)
 		struct imsm_map *map2 = get_imsm_map(dev, MAP_1);
 
 		failed = imsm_count_failed(super, dev, MAP_1);
-		map_state = imsm_check_degraded(super, dev, failed,
-						MAP_1);
+		map_state = imsm_check_degraded(super, dev, failed, MAP_1);
 		if (map2->map_state != map_state) {
 			map2->map_state = map_state;
 			super->updates_pending++;
@@ -2568,13 +2566,13 @@ static void getinfo_super_imsm(struct supertype *st, struct mdinfo *info, char *
 
 		failed = imsm_count_failed(super, dev, MAP_0);
 		state = imsm_check_degraded(super, dev, failed, MAP_0);
-		map = get_imsm_map(dev, 0);
+		map = get_imsm_map(dev, MAP_0);
 
 		/* any newly missing disks?
 		 * (catches single-degraded vs double-degraded)
 		 */
 		for (j = 0; j < map->num_members; j++) {
-			__u32 ord = get_imsm_ord_tbl_ent(dev, j, 0);
+			__u32 ord = get_imsm_ord_tbl_ent(dev, j, MAP_0);
 			__u32 idx = ord_to_idx(ord);
 
 			if (!(ord & IMSM_ORD_REBUILD) &&
@@ -3101,12 +3099,12 @@ static void migrate(struct imsm_dev *dev, struct intel_super *super,
 		    __u8 to_state, int migr_type)
 {
 	struct imsm_map *dest;
-	struct imsm_map *src = get_imsm_map(dev, 0);
+	struct imsm_map *src = get_imsm_map(dev, MAP_0);
 
 	dev->vol.migr_state = 1;
 	set_migr_type(dev, migr_type);
 	dev->vol.curr_migr_unit = 0;
-	dest = get_imsm_map(dev, 1);
+	dest = get_imsm_map(dev, MAP_1);
 
 	/* duplicate and then set the target end state in map[0] */
 	memcpy(dest, src, sizeof_imsm_map(src));
@@ -3131,8 +3129,9 @@ static void migrate(struct imsm_dev *dev, struct intel_super *super,
 static void end_migration(struct imsm_dev *dev, struct intel_super *super,
 			  __u8 map_state)
 {
-	struct imsm_map *map = get_imsm_map(dev, 0);
-	struct imsm_map *prev = get_imsm_map(dev, dev->vol.migr_state);
+	struct imsm_map *map = get_imsm_map(dev, MAP_0);
+	struct imsm_map *prev = get_imsm_map(dev, dev->vol.migr_state == 0 ?
+						    MAP_0 : MAP_1);
 	int i, j;
 
 	/* merge any IMSM_ORD_REBUILD bits that were not successfully
@@ -3264,8 +3263,8 @@ int check_mpb_migr_compatibility(struct intel_super *super)
 		    dev_iter->vol.migr_state == 1 &&
 		    dev_iter->vol.migr_type == MIGR_GEN_MIGR) {
 			/* This device is migrating */
-			map0 = get_imsm_map(dev_iter, 0);
-			map1 = get_imsm_map(dev_iter, 1);
+			map0 = get_imsm_map(dev_iter, MAP_0);
+			map1 = get_imsm_map(dev_iter, MAP_1);
 			if (map0->pba_of_lba0 != map1->pba_of_lba0)
 				/* migration optimization area was used */
 				return -1;
@@ -4152,7 +4151,7 @@ static void imsm_update_version_info(struct intel_super *super)
 
 	for (i = 0; i < mpb->num_raid_devs; i++) {
 		dev = get_imsm_dev(super, i);
-		map = get_imsm_map(dev, 0);
+		map = get_imsm_map(dev, MAP_0);
 		if (__le32_to_cpu(dev->size_high) > 0)
 			mpb->attributes |= MPB_ATTRIB_2TB;
 
@@ -4332,7 +4331,7 @@ static int init_super_imsm_volume(struct supertype *st, mdu_array_info_t *info,
 	set_migr_type(dev, MIGR_INIT);
 	vol->dirty = !info->state;
 	vol->curr_migr_unit = 0;
-	map = get_imsm_map(dev, 0);
+	map = get_imsm_map(dev, MAP_0);
 	map->pba_of_lba0 = __cpu_to_le32(super->create_offset);
 	map->blocks_per_member = __cpu_to_le32(info_to_blocks_per_member(info));
 	map->blocks_per_strip = __cpu_to_le16(info_to_blocks_per_strip(info));
@@ -4456,7 +4455,7 @@ static int add_to_super_imsm_volume(struct supertype *st, mdu_disk_info_t *dk,
 	int slot;
 
 	dev = get_imsm_dev(super, super->current_vol);
-	map = get_imsm_map(dev, 0);
+	map = get_imsm_map(dev, MAP_0);
 
 	if (! (dk->state & (1<<MD_DISK_SYNC))) {
 		fprintf(stderr, Name ": %s: Cannot add spare devices to IMSM volume\n",
@@ -4491,7 +4490,7 @@ static int add_to_super_imsm_volume(struct supertype *st, mdu_disk_info_t *dk,
 	/* Check the device has not already been added */
 	slot = get_imsm_disk_slot(map, dl->index);
 	if (slot >= 0 &&
-	    (get_imsm_ord_tbl_ent(dev, slot, -1) & IMSM_ORD_REBUILD) == 0) {
+	    (get_imsm_ord_tbl_ent(dev, slot, MAP_X) & IMSM_ORD_REBUILD) == 0) {
 		fprintf(stderr, Name ": %s has been included in this array twice\n",
 			devname);
 		return 1;
@@ -4515,19 +4514,20 @@ static int add_to_super_imsm_volume(struct supertype *st, mdu_disk_info_t *dk,
 	/* refresh unset/failed slots to point to valid 'missing' entries */
 	for (df = super->missing; df; df = df->next)
 		for (slot = 0; slot < mpb->num_disks; slot++) {
-			__u32 ord = get_imsm_ord_tbl_ent(dev, slot, -1);
+			__u32 ord = get_imsm_ord_tbl_ent(dev, slot, MAP_X);
 
 			if ((ord & IMSM_ORD_REBUILD) == 0)
 				continue;
 			set_imsm_ord_tbl_ent(map, slot, df->index | IMSM_ORD_REBUILD);
 			if (is_gen_migration(dev)) {
-				struct imsm_map *map2 = get_imsm_map(dev, 1);
+				struct imsm_map *map2 = get_imsm_map(dev,
+								     MAP_1);
 				int slot2 = get_imsm_disk_slot(map2, df->index);
 				if ((slot2 < map2->num_members) &&
 				    (slot2 >= 0)) {
 					__u32 ord2 = get_imsm_ord_tbl_ent(dev,
-									  slot2,
-									  1);
+									 slot2,
+									 MAP_1);
 					if ((unsigned)df->index ==
 							       ord_to_idx(ord2))
 						set_imsm_ord_tbl_ent(map2,
@@ -4846,7 +4846,7 @@ static int create_array(struct supertype *st, int dev_idx)
 	struct imsm_update_create_array *u;
 	struct intel_super *super = st->sb;
 	struct imsm_dev *dev = get_imsm_dev(super, dev_idx);
-	struct imsm_map *map = get_imsm_map(dev, 0);
+	struct imsm_map *map = get_imsm_map(dev, MAP_0);
 	struct disk_info *inf;
 	struct imsm_disk *disk;
 	int i;
@@ -4865,7 +4865,7 @@ static int create_array(struct supertype *st, int dev_idx)
 	imsm_copy_dev(&u->dev, dev);
 	inf = get_disk_info(u);
 	for (i = 0; i < map->num_members; i++) {
-		int idx = get_imsm_disk_idx(dev, i, -1);
+		int idx = get_imsm_disk_idx(dev, i, MAP_X);
 
 		disk = get_imsm_disk(super, idx);
 		serialcpy(inf[i].serial, disk->serial);
@@ -5712,7 +5712,7 @@ static int is_rebuilding(struct imsm_dev *dev)
 	if (migr_type(dev) != MIGR_REBUILD)
 		return 0;
 
-	migr_map = get_imsm_map(dev, 1);
+	migr_map = get_imsm_map(dev, MAP_1);
 
 	if (migr_map->map_state == IMSM_T_STATE_DEGRADED)
 		return 1;
@@ -5730,7 +5730,7 @@ static int is_initializing(struct imsm_dev *dev)
 	if (migr_type(dev) != MIGR_INIT)
 		return 0;
 
-	migr_map = get_imsm_map(dev, 1);
+	migr_map = get_imsm_map(dev, MAP_1);
 
 	if (migr_map->map_state == IMSM_T_STATE_UNINITIALIZED)
 		return 1;
@@ -5828,8 +5828,8 @@ static struct mdinfo *container_content_imsm(struct supertype *st, char *subarra
 			continue;
 
 		dev = get_imsm_dev(super, i);
-		map = get_imsm_map(dev, 0);
-		map2 = get_imsm_map(dev, 1);
+		map = get_imsm_map(dev, MAP_0);
+		map2 = get_imsm_map(dev, MAP_1);
 
 		/* do not publish arrays that are in the middle of an
 		 * unsupported migration
@@ -5888,8 +5888,8 @@ static struct mdinfo *container_content_imsm(struct supertype *st, char *subarra
 			__u32 ord;
 
 			skip = 0;
-			idx = get_imsm_disk_idx(dev, slot, 0);
-			ord = get_imsm_ord_tbl_ent(dev, slot, -1);
+			idx = get_imsm_disk_idx(dev, slot, MAP_0);
+			ord = get_imsm_ord_tbl_ent(dev, slot, MAP_X);
 			for (d = super->disks; d ; d = d->next)
 				if (d->index == idx)
 					break;
@@ -6004,7 +6004,7 @@ static __u8 imsm_check_degraded(struct intel_super *super, struct imsm_dev *dev,
 		int insync = insync;
 
 		for (i = 0; i < map->num_members; i++) {
-			__u32 ord = get_imsm_ord_tbl_ent(dev, i, -1);
+			__u32 ord = get_imsm_ord_tbl_ent(dev, i, MAP_X);
 			int idx = ord_to_idx(ord);
 			struct imsm_disk *disk;
 
@@ -6065,8 +6065,11 @@ static int imsm_count_failed(struct intel_super *super, struct imsm_dev *dev,
 
 	for (i = 0; i < map_for_loop->num_members; i++) {
 		idx_1 = -255;
+		/* when MAP_X is passed both maps failures are counted
+		 */
 		if (prev &&
-		    (look_in_map & MAP_1) && (i < prev->num_members)) {
+		    ((look_in_map == MAP_1) || (look_in_map == MAP_X)) &&
+		    (i < prev->num_members)) {
 			ord = __le32_to_cpu(prev->disk_ord_tbl[i]);
 			idx_1 = ord_to_idx(ord);
 
@@ -6074,7 +6077,8 @@ static int imsm_count_failed(struct intel_super *super, struct imsm_dev *dev,
 			if (!disk || is_failed(disk) || ord & IMSM_ORD_REBUILD)
 				failed++;
 		}
-		if ((look_in_map & MAP_0) && (i < map->num_members)) {
+		if (((look_in_map == MAP_0) || (look_in_map == MAP_X)) &&
+		    (i < map->num_members)) {
 			ord = __le32_to_cpu(map->disk_ord_tbl[i]);
 			idx = ord_to_idx(ord);
 
@@ -6122,7 +6126,7 @@ static int is_resyncing(struct imsm_dev *dev)
 	if (migr_type(dev) == MIGR_GEN_MIGR)
 		return 0;
 
-	migr_map = get_imsm_map(dev, 1);
+	migr_map = get_imsm_map(dev, MAP_1);
 
 	if ((migr_map->map_state == IMSM_T_STATE_NORMAL) &&
 	    (dev->vol.migr_type != MIGR_GEN_MIGR))
@@ -6141,7 +6145,7 @@ static int mark_failure(struct imsm_dev *dev, struct imsm_disk *disk, int idx)
 	unsigned int len, shift = 0;
 
 	/* new failures are always set in map[0] */
-	map = get_imsm_map(dev, 0);
+	map = get_imsm_map(dev, MAP_0);
 
 	slot = get_imsm_disk_slot(map, idx);
 	if (slot < 0)
@@ -6165,7 +6169,7 @@ static int mark_failure(struct imsm_dev *dev, struct imsm_disk *disk, int idx)
 	 * This is valid for migration, initialization and rebuild
 	 */
 	if (dev->vol.migr_state) {
-		struct imsm_map *map2 = get_imsm_map(dev, 1);
+		struct imsm_map *map2 = get_imsm_map(dev, MAP_1);
 		int slot2 = get_imsm_disk_slot(map2, idx);
 
 		if ((slot2 < map2->num_members) &&
@@ -6215,7 +6219,7 @@ static void handle_missing(struct intel_super *super, struct imsm_dev *dev)
 
 static unsigned long long imsm_set_array_size(struct imsm_dev *dev)
 {
-	int used_disks = imsm_num_data_members(dev, 0);
+	int used_disks = imsm_num_data_members(dev, MAP_0);
 	unsigned long long array_blocks;
 	struct imsm_map *map;
 
@@ -6232,7 +6236,7 @@ static unsigned long long imsm_set_array_size(struct imsm_dev *dev)
 
 	/* set array size in metadata
 	 */
-	map = get_imsm_map(dev, 0);
+	map = get_imsm_map(dev, MAP_0);
 	array_blocks = map->blocks_per_member * used_disks;
 
 	/* round array size down to closest MB
@@ -6260,7 +6264,7 @@ static void imsm_progress_container_reshape(struct intel_super *super)
 
 	for (i = 0; i < mpb->num_raid_devs; i++) {
 		struct imsm_dev *dev = get_imsm_dev(super, i);
-		struct imsm_map *map = get_imsm_map(dev, 0);
+		struct imsm_map *map = get_imsm_map(dev, MAP_0);
 		struct imsm_map *map2;
 		int prev_num_members;
 
@@ -6285,7 +6289,7 @@ static void imsm_progress_container_reshape(struct intel_super *super)
 		for (i = prev_num_members;
 		     i < map->num_members; i++)
 			set_imsm_ord_tbl_ent(map, i, i);
-		map2 = get_imsm_map(dev, 1);
+		map2 = get_imsm_map(dev, MAP_1);
 		/* Copy the current map */
 		memcpy(map2, map, copy_map_size);
 		map2->num_members = prev_num_members;
@@ -6305,7 +6309,7 @@ static int imsm_set_array_state(struct active_array *a, int consistent)
 	int inst = a->info.container_member;
 	struct intel_super *super = a->container->sb;
 	struct imsm_dev *dev = get_imsm_dev(super, inst);
-	struct imsm_map *map = get_imsm_map(dev, 0);
+	struct imsm_map *map = get_imsm_map(dev, MAP_0);
 	int failed = imsm_count_failed(super, dev, MAP_0);
 	__u8 map_state = imsm_check_degraded(super, dev, failed, MAP_0);
 	__u32 blocks_per_unit;
@@ -6329,12 +6333,14 @@ static int imsm_set_array_state(struct active_array *a, int consistent)
 				 * user action is required to recover process
 				 */
 				if (0) {
-				struct imsm_map *map2 = get_imsm_map(dev, 1);
-				dev->vol.migr_state = 0;
-				set_migr_type(dev, 0);
-				dev->vol.curr_migr_unit = 0;
-				memcpy(map, map2, sizeof_imsm_map(map2));
-				super->updates_pending++;
+					struct imsm_map *map2 =
+						get_imsm_map(dev, MAP_1);
+					dev->vol.migr_state = 0;
+					set_migr_type(dev, 0);
+					dev->vol.curr_migr_unit = 0;
+					memcpy(map, map2,
+					       sizeof_imsm_map(map2));
+					super->updates_pending++;
 				}
 			}
 			if (a->last_checkpoint >= a->info.component_size) {
@@ -6342,7 +6348,7 @@ static int imsm_set_array_state(struct active_array *a, int consistent)
 				int used_disks;
 				struct mdinfo *mdi;
 
-				used_disks = imsm_num_data_members(dev, 0);
+				used_disks = imsm_num_data_members(dev, MAP_0);
 				if (used_disks > 0) {
 					array_blocks =
 						map->blocks_per_member *
@@ -6449,7 +6455,7 @@ static void imsm_set_disk(struct active_array *a, int n, int state)
 	int inst = a->info.container_member;
 	struct intel_super *super = a->container->sb;
 	struct imsm_dev *dev = get_imsm_dev(super, inst);
-	struct imsm_map *map = get_imsm_map(dev, 0);
+	struct imsm_map *map = get_imsm_map(dev, MAP_0);
 	struct imsm_disk *disk;
 	int failed;
 	__u32 ord;
@@ -6464,7 +6470,7 @@ static void imsm_set_disk(struct active_array *a, int n, int state)
 
 	dprintf("imsm: set_disk %d:%x\n", n, state);
 
-	ord = get_imsm_ord_tbl_ent(dev, n, 0);
+	ord = get_imsm_ord_tbl_ent(dev, n, MAP_0);
 	disk = get_imsm_disk(super, ord_to_idx(ord));
 
 	/* check for new failures */
@@ -6475,7 +6481,7 @@ static void imsm_set_disk(struct active_array *a, int n, int state)
 
 	/* check if in_sync */
 	if (state & DS_INSYNC && ord & IMSM_ORD_REBUILD && is_rebuilding(dev)) {
-		struct imsm_map *migr_map = get_imsm_map(dev, 1);
+		struct imsm_map *migr_map = get_imsm_map(dev, MAP_1);
 
 		set_imsm_ord_tbl_ent(migr_map, n, ord_to_idx(ord));
 		super->updates_pending++;
@@ -6492,7 +6498,7 @@ static void imsm_set_disk(struct active_array *a, int n, int state)
 		if (is_rebuilding(dev)) {
 			dprintf("while rebuilding");
 			end_migration(dev, super, map_state);
-			map = get_imsm_map(dev, 0);
+			map = get_imsm_map(dev, MAP_0);
 			map->failed_disk_num = ~0;
 			super->updates_pending++;
 			a->last_checkpoint = 0;
@@ -6504,7 +6510,7 @@ static void imsm_set_disk(struct active_array *a, int n, int state)
 				end_migration(dev, super, map_state);
 			else
 				map->map_state = map_state;
-			map = get_imsm_map(dev, 0);
+			map = get_imsm_map(dev, MAP_0);
 			map->failed_disk_num = ~0;
 			super->updates_pending++;
 			break;
@@ -6618,7 +6624,7 @@ static void imsm_sync_metadata(struct supertype *container)
 static struct dl *imsm_readd(struct intel_super *super, int idx, struct active_array *a)
 {
 	struct imsm_dev *dev = get_imsm_dev(super, a->info.container_member);
-	int i = get_imsm_disk_idx(dev, idx, -1);
+	int i = get_imsm_disk_idx(dev, idx, MAP_X);
 	struct dl *dl;
 
 	for (dl = super->disks; dl; dl = dl->next)
@@ -6639,7 +6645,7 @@ static struct dl *imsm_add_spare(struct intel_super *super, int slot,
 				 struct mdinfo *additional_test_list)
 {
 	struct imsm_dev *dev = get_imsm_dev(super, a->info.container_member);
-	int idx = get_imsm_disk_idx(dev, slot, -1);
+	int idx = get_imsm_disk_idx(dev, slot, MAP_X);
 	struct imsm_super *mpb = super->anchor;
 	struct imsm_map *map;
 	unsigned long long pos;
@@ -6701,7 +6707,7 @@ static struct dl *imsm_add_spare(struct intel_super *super, int slot,
 		}
 		for (i = 0; i < mpb->num_raid_devs; i++) {
 			dev = get_imsm_dev(super, i);
-			map = get_imsm_map(dev, 0);
+			map = get_imsm_map(dev, MAP_0);
 
 			/* check if this disk is already a member of
 			 * this array
@@ -6757,10 +6763,9 @@ static int imsm_rebuild_allowed(struct supertype *cont, int dev_idx, int failed)
 
 	dev2 = get_imsm_dev(cont->sb, dev_idx);
 	if (dev2) {
-		state = imsm_check_degraded(cont->sb, dev2, failed,
-					    MAP_0);
+		state = imsm_check_degraded(cont->sb, dev2, failed, MAP_0);
 		if (state == IMSM_T_STATE_FAILED) {
-			map = get_imsm_map(dev2, 0);
+			map = get_imsm_map(dev2, MAP_0);
 			if (!map)
 				return 1;
 			for (slot = 0; slot < map->num_members; slot++) {
@@ -6768,7 +6773,7 @@ static int imsm_rebuild_allowed(struct supertype *cont, int dev_idx, int failed)
 				 * Check if failed disks are deleted from intel
 				 * disk list or are marked to be deleted
 				 */
-				idx = get_imsm_disk_idx(dev2, slot, -1);
+				idx = get_imsm_disk_idx(dev2, slot, MAP_X);
 				idisk = get_imsm_dl_disk(cont->sb, idx);
 				/*
 				 * Do not rebuild the array if failed disks
@@ -6802,7 +6807,7 @@ static struct mdinfo *imsm_activate_spare(struct active_array *a,
 	struct intel_super *super = a->container->sb;
 	int inst = a->info.container_member;
 	struct imsm_dev *dev = get_imsm_dev(super, inst);
-	struct imsm_map *map = get_imsm_map(dev, 0);
+	struct imsm_map *map = get_imsm_map(dev, MAP_0);
 	int failed = a->info.array.raid_disks;
 	struct mdinfo *rv = NULL;
 	struct mdinfo *d;
@@ -6975,15 +6980,15 @@ static struct mdinfo *imsm_activate_spare(struct active_array *a,
 static int disks_overlap(struct intel_super *super, int idx, struct imsm_update_create_array *u)
 {
 	struct imsm_dev *dev = get_imsm_dev(super, idx);
-	struct imsm_map *map = get_imsm_map(dev, 0);
-	struct imsm_map *new_map = get_imsm_map(&u->dev, 0);
+	struct imsm_map *map = get_imsm_map(dev, MAP_0);
+	struct imsm_map *new_map = get_imsm_map(&u->dev, MAP_0);
 	struct disk_info *inf = get_disk_info(u);
 	struct imsm_disk *disk;
 	int i;
 	int j;
 
 	for (i = 0; i < map->num_members; i++) {
-		disk = get_imsm_disk(super, get_imsm_disk_idx(dev, i, -1));
+		disk = get_imsm_disk(super, get_imsm_disk_idx(dev, i, MAP_X));
 		for (j = 0; j < new_map->num_members; j++)
 			if (serialcmp(disk->serial, inf[j].serial) == 0)
 				return 1;
@@ -7096,7 +7101,7 @@ static int apply_reshape_migration_update(struct imsm_update_reshape_migration *
 			struct imsm_map *map;
 			struct imsm_dev *new_dev =
 				(struct imsm_dev *)*space_list;
-			struct imsm_map *migr_map = get_imsm_map(dev, 1);
+			struct imsm_map *migr_map = get_imsm_map(dev, MAP_1);
 			int to_state;
 			struct dl *new_disk;
 
@@ -7104,7 +7109,7 @@ static int apply_reshape_migration_update(struct imsm_update_reshape_migration *
 				return ret_val;
 			*space_list = **space_list;
 			memcpy(new_dev, dev, sizeof_imsm_dev(dev, 0));
-			map = get_imsm_map(new_dev, 0);
+			map = get_imsm_map(new_dev, MAP_0);
 			if (migr_map) {
 				dprintf("imsm: Error: migration in progress");
 				return ret_val;
@@ -7124,7 +7129,7 @@ static int apply_reshape_migration_update(struct imsm_update_reshape_migration *
 			migrate(new_dev, super, to_state, MIGR_GEN_MIGR);
 			if (u->new_level > -1)
 				map->raid_level = u->new_level;
-			migr_map = get_imsm_map(new_dev, 1);
+			migr_map = get_imsm_map(new_dev, MAP_1);
 			if ((u->new_level == 5) &&
 			    (migr_map->raid_level == 0)) {
 				int ord = map->num_members - 1;
@@ -7199,7 +7204,7 @@ static int apply_update_activate_spare(struct imsm_update_activate_spare *u,
 {
 	struct imsm_super *mpb = super->anchor;
 	struct imsm_dev *dev = get_imsm_dev(super, u->array);
-	struct imsm_map *map = get_imsm_map(dev, 0);
+	struct imsm_map *map = get_imsm_map(dev, MAP_0);
 	struct imsm_map *migr_map;
 	struct active_array *a;
 	struct imsm_disk *disk;
@@ -7212,7 +7217,7 @@ static int apply_update_activate_spare(struct imsm_update_activate_spare *u,
 	int second_map_created = 0;
 
 	for (; u; u = u->next) {
-		victim = get_imsm_disk_idx(dev, u->slot, -1);
+		victim = get_imsm_disk_idx(dev, u->slot, MAP_X);
 
 		if (victim < 0)
 			return 0;
@@ -7236,7 +7241,7 @@ static int apply_update_activate_spare(struct imsm_update_activate_spare *u,
 			if (i == u->slot)
 				continue;
 			disk = get_imsm_disk(super,
-					     get_imsm_disk_idx(dev, i, -1));
+					     get_imsm_disk_idx(dev, i, MAP_X));
 			if (!disk || is_failed(disk))
 				failed++;
 		}
@@ -7251,15 +7256,14 @@ static int apply_update_activate_spare(struct imsm_update_activate_spare *u,
 		disk->status &= ~SPARE_DISK;
 
 		/* mark rebuild */
-		to_state = imsm_check_degraded(super, dev, failed,
-					       MAP_0);
+		to_state = imsm_check_degraded(super, dev, failed, MAP_0);
 		if (!second_map_created) {
 			second_map_created = 1;
 			map->map_state = IMSM_T_STATE_DEGRADED;
 			migrate(dev, super, to_state, MIGR_REBUILD);
 		} else
 			map->map_state = to_state;
-		migr_map = get_imsm_map(dev, 1);
+		migr_map = get_imsm_map(dev, MAP_1);
 		set_imsm_ord_tbl_ent(map, u->slot, dl->index);
 		set_imsm_ord_tbl_ent(migr_map, u->slot,
 				     dl->index | IMSM_ORD_REBUILD);
@@ -7277,7 +7281,7 @@ static int apply_update_activate_spare(struct imsm_update_activate_spare *u,
 		found = 0;
 		for (a = active_array; a ; a = a->next) {
 			dev = get_imsm_dev(super, a->info.container_member);
-			map = get_imsm_map(dev, 0);
+			map = get_imsm_map(dev, MAP_0);
 
 			if (get_imsm_disk_slot(map, victim) >= 0)
 				found++;
@@ -7369,8 +7373,8 @@ static int apply_reshape_container_disks_update(struct imsm_update_reshape *u,
 		newdev = (void*)sp;
 		/* Copy the dev, but not (all of) the map */
 		memcpy(newdev, id->dev, sizeof(*newdev));
-		oldmap = get_imsm_map(id->dev, 0);
-		newmap = get_imsm_map(newdev, 0);
+		oldmap = get_imsm_map(id->dev, MAP_0);
+		newmap = get_imsm_map(newdev, MAP_0);
 		/* Copy the current map */
 		memcpy(newmap, oldmap, sizeof_imsm_map(oldmap));
 		/* update one device only
@@ -7390,7 +7394,7 @@ static int apply_reshape_container_disks_update(struct imsm_update_reshape *u,
 			}
 			/* New map is correct, now need to save old map
 			 */
-			newmap = get_imsm_map(newdev, 1);
+			newmap = get_imsm_map(newdev, MAP_1);
 			memcpy(newmap, oldmap, sizeof_imsm_map(oldmap));
 
 			imsm_set_array_size(newdev);
@@ -7433,7 +7437,7 @@ static int apply_takeover_update(struct imsm_update_takeover *u,
 	if (dev == NULL)
 		return 0;
 
-	map = get_imsm_map(dev, 0);
+	map = get_imsm_map(dev, MAP_0);
 
 	if (u->direction == R10_TO_R0) {
 		/* Number of failed disks must be half of initial disk number */
@@ -7497,7 +7501,7 @@ static int apply_takeover_update(struct imsm_update_takeover *u,
 		dev_new = (void *)space;
 		memcpy(dev_new, dev, sizeof(*dev));
 		/* update new map */
-		map = get_imsm_map(dev_new, 0);
+		map = get_imsm_map(dev_new, MAP_0);
 		map->num_members = map->num_members * 2;
 		map->map_state = IMSM_T_STATE_DEGRADED;
 		map->num_domains = 2;
@@ -7641,7 +7645,7 @@ static void imsm_process_update(struct supertype *st,
 			goto create_error;
 		}
 
-		new_map = get_imsm_map(&u->dev, 0);
+		new_map = get_imsm_map(&u->dev, MAP_0);
 		new_start = __le32_to_cpu(new_map->pba_of_lba0);
 		new_end = new_start + __le32_to_cpu(new_map->blocks_per_member);
 		inf = get_disk_info(u);
@@ -7652,7 +7656,7 @@ static void imsm_process_update(struct supertype *st,
 		 */
 		for (i = 0; i < mpb->num_raid_devs; i++) {
 			dev = get_imsm_dev(super, i);
-			map = get_imsm_map(dev, 0);
+			map = get_imsm_map(dev, MAP_0);
 			start = __le32_to_cpu(map->pba_of_lba0);
 			end = start + __le32_to_cpu(map->blocks_per_member);
 			if ((new_start >= start && new_start <= end) ||
@@ -7833,7 +7837,7 @@ static void imsm_prepare_update(struct supertype *st,
 		if (u->direction == R0_TO_R10) {
 			void **tail = (void **)&update->space_list;
 			struct imsm_dev *dev = get_imsm_dev(super, u->subarray);
-			struct imsm_map *map = get_imsm_map(dev, 0);
+			struct imsm_map *map = get_imsm_map(dev, MAP_0);
 			int num_members = map->num_members;
 			void *space;
 			int size, i;
@@ -7965,7 +7969,7 @@ static void imsm_prepare_update(struct supertype *st,
 				struct imsm_map *map;
 
 				dev = get_imsm_dev(super, u->subdev);
-				map = get_imsm_map(dev, 0);
+				map = get_imsm_map(dev, MAP_0);
 				current_level = map->raid_level;
 				break;
 			}
@@ -7999,7 +8003,7 @@ static void imsm_prepare_update(struct supertype *st,
 		struct imsm_update_create_array *u = (void *) update->buf;
 		struct intel_dev *dv;
 		struct imsm_dev *dev = &u->dev;
-		struct imsm_map *map = get_imsm_map(dev, 0);
+		struct imsm_map *map = get_imsm_map(dev, MAP_0);
 		struct dl *dl;
 		struct disk_info *inf;
 		int i;
@@ -8084,20 +8088,20 @@ static void imsm_delete(struct intel_super *super, struct dl **dlp, unsigned ind
 
 	for (i = 0; i < mpb->num_raid_devs; i++) {
 		dev = get_imsm_dev(super, i);
-		map = get_imsm_map(dev, 0);
+		map = get_imsm_map(dev, MAP_0);
 		num_members = map->num_members;
 		for (j = 0; j < num_members; j++) {
 			/* update ord entries being careful not to propagate
 			 * ord-flags to the first map
 			 */
-			ord = get_imsm_ord_tbl_ent(dev, j, -1);
+			ord = get_imsm_ord_tbl_ent(dev, j, MAP_X);
 
 			if (ord_to_idx(ord) <= index)
 				continue;
 
-			map = get_imsm_map(dev, 0);
+			map = get_imsm_map(dev, MAP_0);
 			set_imsm_ord_tbl_ent(map, j, ord_to_idx(ord - 1));
-			map = get_imsm_map(dev, 1);
+			map = get_imsm_map(dev, MAP_1);
 			if (map)
 				set_imsm_ord_tbl_ent(map, j, ord - 1);
 		}
@@ -8143,7 +8147,7 @@ static int imsm_get_allowed_degradation(int level, int raid_disks,
 		/* check map if all disks pairs not failed
 		 * in both maps
 		 */
-		map = get_imsm_map(dev, 0);
+		map = get_imsm_map(dev, MAP_0);
 		for (i = 0; i < ret_val; i++) {
 			int degradation = 0;
 			if (get_imsm_disk(super, i) == NULL)
@@ -8153,7 +8157,7 @@ static int imsm_get_allowed_degradation(int level, int raid_disks,
 			if (degradation == 2)
 				return 0;
 		}
-		map = get_imsm_map(dev, 1);
+		map = get_imsm_map(dev, MAP_1);
 		/* if there is no second map
 		 * result can be returned
 		 */
@@ -8262,8 +8266,8 @@ void init_migr_record_imsm(struct supertype *st, struct imsm_dev *dev,
 	struct mdinfo *sd;
 	char nm[30];
 	int fd;
-	struct imsm_map *map_dest = get_imsm_map(dev, 0);
-	struct imsm_map *map_src = get_imsm_map(dev, 1);
+	struct imsm_map *map_dest = get_imsm_map(dev, MAP_0);
+	struct imsm_map *map_src = get_imsm_map(dev, MAP_1);
 	unsigned long long num_migr_units;
 	unsigned long long array_blocks;
 
@@ -8276,7 +8280,7 @@ void init_migr_record_imsm(struct supertype *st, struct imsm_dev *dev,
 	migr_rec->dest_depth_per_unit = GEN_MIGR_AREA_SIZE /
 		max(map_dest->blocks_per_strip, map_src->blocks_per_strip);
 	migr_rec->dest_depth_per_unit *= map_dest->blocks_per_strip;
-	new_data_disks = imsm_num_data_members(dev, 0);
+	new_data_disks = imsm_num_data_members(dev, MAP_0);
 	migr_rec->blocks_per_unit =
 		__cpu_to_le32(migr_rec->dest_depth_per_unit * new_data_disks);
 	migr_rec->dest_depth_per_unit =
@@ -8340,12 +8344,12 @@ int save_backup_imsm(struct supertype *st,
 	unsigned long long *target_offsets = NULL;
 	int *targets = NULL;
 	int i;
-	struct imsm_map *map_dest = get_imsm_map(dev, 0);
+	struct imsm_map *map_dest = get_imsm_map(dev, MAP_0);
 	int new_disks = map_dest->num_members;
 	int dest_layout = 0;
 	int dest_chunk;
 	unsigned long long start;
-	int data_disks = imsm_num_data_members(dev, 0);
+	int data_disks = imsm_num_data_members(dev, MAP_0);
 
 	targets = malloc(new_disks * sizeof(int));
 	if (!targets)
@@ -8505,7 +8509,7 @@ int recover_backup_imsm(struct supertype *st, struct mdinfo *info)
 	if (id == NULL)
 		return 1;
 
-	map_dest = get_imsm_map(id->dev, 0);
+	map_dest = get_imsm_map(id->dev, MAP_0);
 	new_disks = map_dest->num_members;
 
 	read_offset = (unsigned long long)
@@ -8890,7 +8894,7 @@ static int imsm_create_metadata_update_for_migration(
 	if (dev) {
 		struct imsm_map *map;
 
-		map = get_imsm_map(dev, 0);
+		map = get_imsm_map(dev, MAP_0);
 		if (map) {
 			int current_chunk_size =
 				__le16_to_cpu(map->blocks_per_strip) / 2;
@@ -9402,12 +9406,12 @@ static int imsm_manage_reshape(
 		goto abort;
 	}
 
-	map_src = get_imsm_map(dev, 1);
+	map_src = get_imsm_map(dev, MAP_1);
 	if (map_src == NULL)
 		goto abort;
 
-	ndata = imsm_num_data_members(dev, 0);
-	odata = imsm_num_data_members(dev, 1);
+	ndata = imsm_num_data_members(dev, MAP_0);
+	odata = imsm_num_data_members(dev, MAP_1);
 
 	chunk = __le16_to_cpu(map_src->blocks_per_strip) * 512;
 	old_data_stripe_length = odata * chunk;

