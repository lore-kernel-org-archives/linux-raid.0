From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 2/9] imsm: FIX: Correct ords merging in end_migration()
Date: Wed, 07 Dec 2011 13:57:51 +0100
Message-ID: <20111207125751.25279.30422.stgit@gklab-128-013.igk.intel.com>
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

Ord's merging should occur when rebuild finishes and final state is other
than expected only /additional failures occur during rebuild/.
Exclude array initialization.
Merging ords on migration finish should never happen.
Any failure during migration should be immediately placed in first
/current/ map, so no merge is necessary.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |   45 +++++++++++++++++++++++++++++----------------
 1 files changed, 29 insertions(+), 16 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 9b3d6be..8f075e0 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -3128,7 +3128,8 @@ static void migrate(struct imsm_dev *dev, struct intel_super *super,
 	src->map_state = to_state;
 }
 
-static void end_migration(struct imsm_dev *dev, __u8 map_state)
+static void end_migration(struct imsm_dev *dev, struct intel_super *super,
+			  __u8 map_state)
 {
 	struct imsm_map *map = get_imsm_map(dev, 0);
 	struct imsm_map *prev = get_imsm_map(dev, dev->vol.migr_state);
@@ -3139,16 +3140,28 @@ static void end_migration(struct imsm_dev *dev, __u8 map_state)
 	 *
 	 * FIXME add support for raid-level-migration
 	 */
-	for (i = 0; i < prev->num_members; i++)
-		for (j = 0; j < map->num_members; j++)
-			/* during online capacity expansion
-			 * disks position can be changed if takeover is used
-			 */
-			if (ord_to_idx(map->disk_ord_tbl[j]) ==
-			    ord_to_idx(prev->disk_ord_tbl[i])) {
-				map->disk_ord_tbl[j] |= prev->disk_ord_tbl[i];
-				break;
-			}
+	if ((map_state != map->map_state) && (is_gen_migration(dev) == 0) &&
+		(prev->map_state != IMSM_T_STATE_UNINITIALIZED)) {
+		/* when final map state is other than expected
+		 * merge maps (not for migration)
+		 */
+		int failed;
+
+		for (i = 0; i < prev->num_members; i++)
+			for (j = 0; j < map->num_members; j++)
+				/* during online capacity expansion
+				 * disks position can be changed
+				 * if takeover is used
+				 */
+				if (ord_to_idx(map->disk_ord_tbl[j]) ==
+				    ord_to_idx(prev->disk_ord_tbl[i])) {
+					map->disk_ord_tbl[j] |=
+						prev->disk_ord_tbl[i];
+					break;
+				}
+		failed = imsm_count_failed(super, dev, MAP_0);
+		map_state = imsm_check_degraded(super, dev, failed, MAP_0);
+	}
 
 	dev->vol.migr_state = 0;
 	set_migr_type(dev, 0);
@@ -6335,7 +6348,7 @@ static int imsm_set_array_state(struct active_array *a, int consistent)
 		 */
 		if (is_resyncing(dev)) {
 			dprintf("imsm: mark resync done\n");
-			end_migration(dev, map_state);
+			end_migration(dev, super, map_state);
 			super->updates_pending++;
 			a->last_checkpoint = 0;
 		}
@@ -6434,7 +6447,7 @@ static void imsm_set_disk(struct active_array *a, int n, int state)
 
 	/* check if recovery complete, newly degraded, or failed */
 	if (map_state == IMSM_T_STATE_NORMAL && is_rebuilding(dev)) {
-		end_migration(dev, map_state);
+		end_migration(dev, super, map_state);
 		map = get_imsm_map(dev, 0);
 		map->failed_disk_num = ~0;
 		super->updates_pending++;
@@ -6449,7 +6462,7 @@ static void imsm_set_disk(struct active_array *a, int n, int state)
 	} else if (map_state == IMSM_T_STATE_FAILED &&
 		   map->map_state != map_state) {
 		dprintf("imsm: mark failed\n");
-		end_migration(dev, map_state);
+		end_migration(dev, super, map_state);
 		super->updates_pending++;
 		a->last_checkpoint = 0;
 	} else if (is_gen_migration(dev)) {
@@ -6459,14 +6472,14 @@ static void imsm_set_disk(struct active_array *a, int n, int state)
 		case IMSM_T_STATE_NORMAL:
 			dprintf("normal\n");
 			if (a->last_checkpoint >= a->info.component_size)
-				end_migration(dev, map_state);
+				end_migration(dev, super, map_state);
 			map = get_imsm_map(dev, 0);
 			map->failed_disk_num = ~0;
 			break;
 		case IMSM_T_STATE_DEGRADED:
 			dprintf("degraded\n");
 			if (a->last_checkpoint >= a->info.component_size)
-				end_migration(dev, map_state);
+				end_migration(dev, super, map_state);
 			else
 				manage_second_map(super, dev);
 			break;

