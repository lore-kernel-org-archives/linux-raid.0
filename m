From: Lukasz Dorau <lukasz.dorau@intel.com>
Subject: [PATCH] imsm: fix: add support for OLCE and migration to
	imsm_count_failed
Date: Fri, 04 Nov 2011 14:52:14 +0100
Message-ID: <20111104135214.13558.65725.stgit@gklab-128-085.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, marcin.labun@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

The problem occurs when array under OLCE (from 3 to 6 disks)
is assembled incrementally. Mdadm tries to start array
just after adding the third disk (this is equal to the number of disks
before the start of reshape). It does not succeed,
the volume does not assembly correctly.

The function counting failed disks (imsm_count_failed())
was fixed for migration case. Now all disk members in both maps
are checked when failed disks are counted correctly.

Signed-off-by: Lukasz Dorau <lukasz.dorau@intel.com>
---
 super-intel.c |   18 ++++++++++++------
 1 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index f776be9..215679d 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -5943,6 +5943,7 @@ static int imsm_count_failed(struct intel_super *super, struct imsm_dev *dev)
 	struct imsm_disk *disk;
 	struct imsm_map *map = get_imsm_map(dev, 0);
 	struct imsm_map *prev = get_imsm_map(dev, dev->vol.migr_state);
+	struct imsm_map *map_for_loop;
 	__u32 ord;
 	int idx;
 
@@ -5951,13 +5952,18 @@ static int imsm_count_failed(struct intel_super *super, struct imsm_dev *dev)
 	 * map[0].  So we look through all the disks we started with and
 	 * see if any failures are still present, or if any new ones
 	 * have arrived
-	 *
-	 * FIXME add support for online capacity expansion and
-	 * raid-level-migration
 	 */
-	for (i = 0; i < prev->num_members; i++) {
-		ord = __le32_to_cpu(prev->disk_ord_tbl[i]);
-		ord |= __le32_to_cpu(map->disk_ord_tbl[i]);
+	map_for_loop = prev;
+	if (is_gen_migration(dev))
+		if (prev && (map->num_members > prev->num_members))
+			map_for_loop = map;
+
+	for (i = 0; i < map_for_loop->num_members; i++) {
+		ord = 0;
+		if (i < prev->num_members)
+			ord |= __le32_to_cpu(prev->disk_ord_tbl[i]);
+		if (i < map->num_members)
+			ord |= __le32_to_cpu(map->disk_ord_tbl[i]);
 		idx = ord_to_idx(ord);
 
 		disk = get_imsm_disk(super, idx);

