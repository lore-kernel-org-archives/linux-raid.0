From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 05/34] imsm: FIX: display correct information for '-E' option
Date: Tue, 04 Jan 2011 15:36:18 +0100
Message-ID: <20110104143618.6697.26412.stgit@gklab-128-013.igk.intel.com>
References: <20110104143240.6697.52355.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110104143240.6697.52355.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

Correct information displayed by '-E' option.
1. FIX: Slot information during raid0 migration is displayed incorrectly
        (missing disk position is taken from wrong map)
2. Improvement: information about (level, members, chunk size) migration is displayed.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |   30 +++++++++++++++++++++++++-----
 1 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 8fe24b3..35a3769 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -736,19 +736,35 @@ static void print_imsm_dev(struct imsm_dev *dev, char *uuid, int disk_idx)
 	__u64 sz;
 	int slot, i;
 	struct imsm_map *map = get_imsm_map(dev, 0);
+	struct imsm_map *map2 = get_imsm_map(dev, 1);
 	__u32 ord;
 
 	printf("\n");
 	printf("[%.16s]:\n", dev->volume);
 	printf("           UUID : %s\n", uuid);
-	printf("     RAID Level : %d\n", get_imsm_raid_level(map));
-	printf("        Members : %d\n", map->num_members);
+	printf("     RAID Level : %d", get_imsm_raid_level(map));
+	if (map2)
+		printf(" <-- %d", get_imsm_raid_level(map2));
+	printf("\n");
+	printf("        Members : %d", map->num_members);
+	if (map2)
+		printf(" <-- %d", map2->num_members);
+	printf("\n");
 	printf("          Slots : [");
 	for (i = 0; i < map->num_members; i++) {
-		ord = get_imsm_ord_tbl_ent(dev, i, -1);
+		ord = get_imsm_ord_tbl_ent(dev, i, 0);
 		printf("%s", ord & IMSM_ORD_REBUILD ? "_" : "U");
 	}
-	printf("]\n");
+	printf("]");
+	if (map2) {
+		printf(" <-- [");
+		for (i = 0; i < map2->num_members; i++) {
+			ord = get_imsm_ord_tbl_ent(dev, i, 1);
+			printf("%s", ord & IMSM_ORD_REBUILD ? "_" : "U");
+		}
+		printf("]");
+	}
+	printf("\n");
 	slot = get_imsm_disk_slot(map, disk_idx);
 	if (slot >= 0) {
 		ord = get_imsm_ord_tbl_ent(dev, slot, -1);
@@ -768,8 +784,12 @@ static void print_imsm_dev(struct imsm_dev *dev, char *uuid, int disk_idx)
 		__le32_to_cpu(map->pba_of_lba0));
 	printf("    Num Stripes : %u\n",
 		__le32_to_cpu(map->num_data_stripes));
-	printf("     Chunk Size : %u KiB\n",
+	printf("     Chunk Size : %u KiB",
 		__le16_to_cpu(map->blocks_per_strip) / 2);
+	if (map2)
+		printf(" <-- %u KiB",
+			__le16_to_cpu(map2->blocks_per_strip) / 2);
+	printf("\n");
 	printf("       Reserved : %d\n", __le32_to_cpu(dev->reserved_blocks));
 	printf("  Migrate State : ");
 	if (dev->vol.migr_state) {

