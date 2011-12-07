From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 8/9] imsm: FIX: Check correct slots on disk failure
Date: Wed, 07 Dec 2011 13:58:38 +0100
Message-ID: <20111207125838.25279.47090.stgit@gklab-128-013.igk.intel.com>
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

When changes are made to 2nd map, slot in second map should be tested
instead first one /as change will be applied to second map).

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 9689fdd..7f9c64f 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -4522,14 +4522,16 @@ static int add_to_super_imsm_volume(struct supertype *st, mdu_disk_info_t *dk,
 			set_imsm_ord_tbl_ent(map, slot, df->index | IMSM_ORD_REBUILD);
 			if (is_gen_migration(dev)) {
 				struct imsm_map *map2 = get_imsm_map(dev, 1);
-				if (slot < map2->num_members) {
+				int slot2 = get_imsm_disk_slot(map2, df->index);
+				if ((slot2 < map2->num_members) &&
+				    (slot2 >= 0)) {
 					__u32 ord2 = get_imsm_ord_tbl_ent(dev,
-									  slot,
+									  slot2,
 									  1);
 					if ((unsigned)df->index ==
 							       ord_to_idx(ord2))
 						set_imsm_ord_tbl_ent(map2,
-							slot,
+							slot2,
 							df->index |
 							IMSM_ORD_REBUILD);
 				}
@@ -6164,8 +6166,11 @@ static int mark_failure(struct imsm_dev *dev, struct imsm_disk *disk, int idx)
 	 */
 	if (dev->vol.migr_state) {
 		struct imsm_map *map2 = get_imsm_map(dev, 1);
-		if (slot < map2->num_members)
-			set_imsm_ord_tbl_ent(map2, slot,
+		int slot2 = get_imsm_disk_slot(map2, idx);
+
+		if ((slot2 < map2->num_members) &&
+		    (slot2 >= 0))
+			set_imsm_ord_tbl_ent(map2, slot2,
 					     idx | IMSM_ORD_REBUILD);
 	}
 	if (map->failed_disk_num == 0xff)

