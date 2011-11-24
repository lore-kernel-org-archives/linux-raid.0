From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 07/11] imsm: FIX: Manage second map state on array degradation
Date: Thu, 24 Nov 2011 13:18:05 +0100
Message-ID: <20111124121805.5254.3350.stgit@gklab-128-013.igk.intel.com>
References: <20111124121516.5254.48774.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111124121516.5254.48774.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

When degradation during migration occurs second map state is not set
to degraded value (map are updated correctly).

Correct second map state according to it's degradation level.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |   76 ++++++++++++++++++++++++++++++++++++++++++++-------------
 1 files changed, 58 insertions(+), 18 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index ccd9883..147de36 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -106,6 +106,11 @@ struct imsm_disk {
 	__u32 filler[IMSM_DISK_FILLERS]; /* 0xF4 - 0x107 MPB_DISK_FILLERS for future expansion */
 };
 
+/* map selector for map managment
+ */
+#define MAP_0		2
+#define MAP_1		4
+
 /* RAID map configuration infos. */
 struct imsm_map {
 	__u32 pba_of_lba0;	/* start address of partition */
@@ -662,7 +667,9 @@ struct imsm_map *get_imsm_map(struct imsm_dev *dev, int second_map)
 {
 	/* A device can have 2 maps if it is in the middle of a migration.
 	 * If second_map is:
+	 *    MAP_0 and
 	 *    0   - we return the first map
+	 *    MAP_1 and
 	 *    1   - we return the second map if it exists, else NULL
 	 *   -1   - we return the second map if it exists, else the first
 	 *   -2   - we return longer map /excluding uninitialized state/
@@ -674,8 +681,10 @@ struct imsm_map *get_imsm_map(struct imsm_dev *dev, int second_map)
 		map2 = (void *)map + sizeof_imsm_map(map);
 
 	switch (second_map) {
+	case MAP_0:
 	case 0:
 		break;
+	case MAP_1:
 	case 1:
 		map = map2;
 		break;
@@ -2485,8 +2494,28 @@ static void getinfo_super_imsm_volume(struct supertype *st, struct mdinfo *info,
 	}
 }
 
-static __u8 imsm_check_degraded(struct intel_super *super, struct imsm_dev *dev, int failed);
-static int imsm_count_failed(struct intel_super *super, struct imsm_dev *dev);
+static __u8 imsm_check_degraded(struct intel_super *super, struct imsm_dev *dev,
+				int failed, int look_in_map);
+
+static int imsm_count_failed(struct intel_super *super, struct imsm_dev *dev,
+			     int look_in_map);
+
+static void manage_second_map(struct intel_super *super, struct imsm_dev *dev)
+{
+	if (is_gen_migration(dev)) {
+		int failed;
+		__u8 map_state;
+		struct imsm_map *map2 = get_imsm_map(dev, MAP_1);
+
+		failed = imsm_count_failed(super, dev, MAP_1);
+		map_state = imsm_check_degraded(super, dev, failed,
+						MAP_1);
+		if (map2->map_state != map_state) {
+			map2->map_state = map_state;
+			super->updates_pending++;
+		}
+	}
+}
 
 static struct imsm_disk *get_imsm_missing(struct intel_super *super, __u8 index)
 {
@@ -2547,8 +2576,8 @@ static void getinfo_super_imsm(struct supertype *st, struct mdinfo *info, char *
 		struct imsm_map *map;
 		__u8 state;
 
-		failed = imsm_count_failed(super, dev);
-		state = imsm_check_degraded(super, dev, failed);
+		failed = imsm_count_failed(super, dev, MAP_0);
+		state = imsm_check_degraded(super, dev, failed, MAP_0);
 		map = get_imsm_map(dev, 0);
 
 		/* any newly missing disks?
@@ -5914,9 +5943,12 @@ static struct mdinfo *container_content_imsm(struct supertype *st, char *subarra
 }
 
 
-static __u8 imsm_check_degraded(struct intel_super *super, struct imsm_dev *dev, int failed)
+static __u8 imsm_check_degraded(struct intel_super *super, struct imsm_dev *dev,
+				int failed, int look_in_map)
 {
-	struct imsm_map *map = get_imsm_map(dev, 0);
+	struct imsm_map *map;
+
+	map = get_imsm_map(dev, look_in_map);
 
 	if (!failed)
 		return map->map_state == IMSM_T_STATE_UNINITIALIZED ? 
@@ -5980,7 +6012,8 @@ static __u8 imsm_check_degraded(struct intel_super *super, struct imsm_dev *dev,
 	return map->map_state;
 }
 
-static int imsm_count_failed(struct intel_super *super, struct imsm_dev *dev)
+static int imsm_count_failed(struct intel_super *super, struct imsm_dev *dev,
+			     int look_in_map)
 {
 	int i;
 	int failed = 0;
@@ -5999,14 +6032,15 @@ static int imsm_count_failed(struct intel_super *super, struct imsm_dev *dev)
 	 */
 	map_for_loop = prev;
 	if (is_gen_migration(dev))
-		if (prev && (map->num_members > prev->num_members))
+		if (prev &&
+		    (map->num_members > prev->num_members))
 			map_for_loop = map;
 
 	for (i = 0; i < map_for_loop->num_members; i++) {
 		ord = 0;
-		if (i < prev->num_members)
+		if ((look_in_map & MAP_1) && (i < prev->num_members))
 			ord |= __le32_to_cpu(prev->disk_ord_tbl[i]);
-		if (i < map->num_members)
+		if ((look_in_map & MAP_0) && (i < map->num_members))
 			ord |= __le32_to_cpu(map->disk_ord_tbl[i]);
 		idx = ord_to_idx(ord);
 
@@ -6216,8 +6250,8 @@ static int imsm_set_array_state(struct active_array *a, int consistent)
 	struct intel_super *super = a->container->sb;
 	struct imsm_dev *dev = get_imsm_dev(super, inst);
 	struct imsm_map *map = get_imsm_map(dev, 0);
-	int failed = imsm_count_failed(super, dev);
-	__u8 map_state = imsm_check_degraded(super, dev, failed);
+	int failed = imsm_count_failed(super, dev, MAP_0);
+	__u8 map_state = imsm_check_degraded(super, dev, failed, MAP_0);
 	__u32 blocks_per_unit;
 
 	if (dev->vol.migr_state &&
@@ -6391,8 +6425,8 @@ static void imsm_set_disk(struct active_array *a, int n, int state)
 		super->updates_pending++;
 	}
 
-	failed = imsm_count_failed(super, dev);
-	map_state = imsm_check_degraded(super, dev, failed);
+	failed = imsm_count_failed(super, dev, MAP_0);
+	map_state = imsm_check_degraded(super, dev, failed, MAP_0);
 
 	/* check if recovery complete, newly degraded, or failed */
 	if (map_state == IMSM_T_STATE_NORMAL && is_rebuilding(dev)) {
@@ -6429,6 +6463,8 @@ static void imsm_set_disk(struct active_array *a, int n, int state)
 			dprintf("degraded\n");
 			if (a->last_checkpoint >= a->info.component_size)
 				end_migration(dev, map_state);
+			else
+				manage_second_map(super, dev);
 		break;
 		default:
 			dprintf("failed\n");
@@ -6625,7 +6661,8 @@ static int imsm_rebuild_allowed(struct supertype *cont, int dev_idx, int failed)
 
 	dev2 = get_imsm_dev(cont->sb, dev_idx);
 	if (dev2) {
-		state = imsm_check_degraded(cont->sb, dev2, failed);
+		state = imsm_check_degraded(cont->sb, dev2, failed,
+					    MAP_0);
 		if (state == IMSM_T_STATE_FAILED) {
 			map = get_imsm_map(dev2, 0);
 			if (!map)
@@ -6702,7 +6739,8 @@ static struct mdinfo *imsm_activate_spare(struct active_array *a,
 		 */
 		return NULL;
 
-	if (imsm_check_degraded(super, dev, failed) != IMSM_T_STATE_DEGRADED)
+	if (imsm_check_degraded(super, dev, failed, MAP_0) !=
+			IMSM_T_STATE_DEGRADED)
 		return NULL;
 
 	/*
@@ -7109,7 +7147,8 @@ static int apply_update_activate_spare(struct imsm_update_activate_spare *u,
 		disk->status &= ~SPARE_DISK;
 
 		/* mark rebuild */
-		to_state = imsm_check_degraded(super, dev, failed);
+		to_state = imsm_check_degraded(super, dev, failed,
+					       MAP_0);
 		if (!second_map_created) {
 			second_map_created = 1;
 			map->map_state = IMSM_T_STATE_DEGRADED;
@@ -7294,7 +7333,8 @@ static int apply_takeover_update(struct imsm_update_takeover *u,
 
 	if (u->direction == R10_TO_R0) {
 		/* Number of failed disks must be half of initial disk number */
-		if (imsm_count_failed(super, dev) != (map->num_members / 2))
+		if (imsm_count_failed(super, dev, MAP_0) !=
+				(map->num_members / 2))
 			return 0;
 
 		/* iterate through devices to mark removed disks as spare */

