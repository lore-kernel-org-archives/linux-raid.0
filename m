From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 08/11] imsm: FIX: Function rework - imsm_count_failed()
Date: Thu, 24 Nov 2011 13:18:13 +0100
Message-ID: <20111124121813.5254.87970.stgit@gklab-128-013.igk.intel.com>
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

imsm_count_failed() assumes that on the same positions in both maps
the same disk indexes are kept. This is not always true /e.g. rebuild/
It can occur that disk taken for rebuild fails at once.
Degradation on the same positions in both maps refers to different disks.
Sum of both ords can point on not failed disk. This can cause wrong
failed disk counting.

Check both maps independently. This allows for getting real degradation
information.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |   43 +++++++++++++++++++++++++++----------------
 1 files changed, 27 insertions(+), 16 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 147de36..3e7cfb4 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -6018,11 +6018,12 @@ static int imsm_count_failed(struct intel_super *super, struct imsm_dev *dev,
 	int i;
 	int failed = 0;
 	struct imsm_disk *disk;
-	struct imsm_map *map = get_imsm_map(dev, 0);
-	struct imsm_map *prev = get_imsm_map(dev, dev->vol.migr_state);
+	struct imsm_map *map = get_imsm_map(dev, MAP_0);
+	struct imsm_map *prev = get_imsm_map(dev, MAP_1);
 	struct imsm_map *map_for_loop;
 	__u32 ord;
 	int idx;
+	int idx_1;
 
 	/* at the beginning of migration we set IMSM_ORD_REBUILD on
 	 * disks that are being rebuilt.  New failures are recorded to
@@ -6030,23 +6031,33 @@ static int imsm_count_failed(struct intel_super *super, struct imsm_dev *dev,
 	 * see if any failures are still present, or if any new ones
 	 * have arrived
 	 */
-	map_for_loop = prev;
-	if (is_gen_migration(dev))
-		if (prev &&
-		    (map->num_members > prev->num_members))
-			map_for_loop = map;
+	map_for_loop = map;
+	if (prev &&
+	    (map->num_members < prev->num_members))
+		map_for_loop = prev;
 
 	for (i = 0; i < map_for_loop->num_members; i++) {
-		ord = 0;
-		if ((look_in_map & MAP_1) && (i < prev->num_members))
-			ord |= __le32_to_cpu(prev->disk_ord_tbl[i]);
-		if ((look_in_map & MAP_0) && (i < map->num_members))
-			ord |= __le32_to_cpu(map->disk_ord_tbl[i]);
-		idx = ord_to_idx(ord);
+		idx_1 = -255;
+		if (prev &&
+		    (look_in_map & MAP_1) && (i < prev->num_members)) {
+			ord = __le32_to_cpu(prev->disk_ord_tbl[i]);
+			idx_1 = ord_to_idx(ord);
 
-		disk = get_imsm_disk(super, idx);
-		if (!disk || is_failed(disk) || ord & IMSM_ORD_REBUILD)
-			failed++;
+			disk = get_imsm_disk(super, idx_1);
+			if (!disk || is_failed(disk) || ord & IMSM_ORD_REBUILD)
+				failed++;
+		}
+		if ((look_in_map & MAP_0) && (i < map->num_members)) {
+			ord = __le32_to_cpu(map->disk_ord_tbl[i]);
+			idx = ord_to_idx(ord);
+
+			if (idx != idx_1) {
+				disk = get_imsm_disk(super, idx);
+				if (!disk || is_failed(disk) ||
+				    ord & IMSM_ORD_REBUILD)
+					failed++;
+			}
+		}
 	}
 
 	return failed;

