From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 02/11] imsm: FIX: Mark both maps on degradation while migrating
Date: Thu, 24 Nov 2011 13:17:26 +0100
Message-ID: <20111124121726.5254.52476.stgit@gklab-128-013.igk.intel.com>
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

During migration degradation is set in first map only. This means that
according to second map disk is present. This is not true and not compatible
with OROM behavior.

Set disks in both maps to degraded state during migration.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 5f2c4a2..5828922 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -4485,6 +4485,20 @@ static int add_to_super_imsm_volume(struct supertype *st, mdu_disk_info_t *dk,
 			if ((ord & IMSM_ORD_REBUILD) == 0)
 				continue;
 			set_imsm_ord_tbl_ent(map, slot, df->index | IMSM_ORD_REBUILD);
+			if (is_gen_migration(dev)) {
+				struct imsm_map *map2 = get_imsm_map(dev, 1);
+				if (slot < map2->num_members) {
+					__u32 ord2 = get_imsm_ord_tbl_ent(dev,
+									  slot,
+									  1);
+					if ((unsigned)df->index ==
+							       ord_to_idx(ord2))
+						set_imsm_ord_tbl_ent(map2,
+							slot,
+							df->index |
+							IMSM_ORD_REBUILD);
+				}
+			}
 			dprintf("set slot:%d to missing disk:%d\n", slot, df->index);
 			break;
 		}
@@ -6075,6 +6089,12 @@ static int mark_failure(struct imsm_dev *dev, struct imsm_disk *disk, int idx)
 
 	disk->status |= FAILED_DISK;
 	set_imsm_ord_tbl_ent(map, slot, idx | IMSM_ORD_REBUILD);
+	if (is_gen_migration(dev)) {
+		struct imsm_map *map2 = get_imsm_map(dev, 1);
+		if (slot < map2->num_members)
+			set_imsm_ord_tbl_ent(map2, slot,
+					     idx | IMSM_ORD_REBUILD);
+	}
 	if (map->failed_disk_num == 0xff)
 		map->failed_disk_num = slot;
 	return 1;

