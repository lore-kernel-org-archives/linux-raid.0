From: Przemyslaw Czarnowski
	<przemyslaw.hawrylewicz.czarnowski@intel.com>
Subject: [PATCH] imsm: always use set_migr_type to set type of migration
Date: Wed, 05 Oct 2011 11:59:50 +0200
Message-ID: <20111005095949.28631.81041.stgit@gklab-128-081.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, marcin.labun@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

For 'resync' besides the update of migration type (imsm_vol.migr_type
structure) additionally status (imsm_dev.status) flag is set to
DEV_VERIFY_AND_FIX. In order to clean up after migration, status flag
must be cleared. For this reason, migration type shouldn't be set
directly but via set_migr_type(). Otherwise status does not reflect
the state of array.

Signed-off-by: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>
---
 super-intel.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 3185e91..216ec21 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -3112,7 +3112,7 @@ static void end_migration(struct imsm_dev *dev, __u8 map_state)
 			}
 
 	dev->vol.migr_state = 0;
-	dev->vol.migr_type = 0;
+	set_migr_type(dev, 0);
 	dev->vol.curr_migr_unit = 0;
 	map->map_state = map_state;
 }
@@ -6124,7 +6124,7 @@ static void imsm_progress_container_reshape(struct intel_super *super)
 		map->num_members = prev_disks;
 		dev->vol.migr_state = 1;
 		dev->vol.curr_migr_unit = 0;
-		dev->vol.migr_type = MIGR_GEN_MIGR;
+		set_migr_type(dev, MIGR_GEN_MIGR);
 		for (i = prev_num_members;
 		     i < map->num_members; i++)
 			set_imsm_ord_tbl_ent(map, i, i);
@@ -6174,7 +6174,7 @@ static int imsm_set_array_state(struct active_array *a, int consistent)
 				if (0) {
 				struct imsm_map *map2 = get_imsm_map(dev, 1);
 				dev->vol.migr_state = 0;
-				dev->vol.migr_type = 0;
+				set_migr_type(dev, 0);
 				dev->vol.curr_migr_unit = 0;
 				memcpy(map, map2, sizeof_imsm_map(map2));
 				super->updates_pending++;
@@ -7053,7 +7053,7 @@ static int apply_reshape_container_disks_update(struct imsm_update_reshape *u,
 			devices_to_reshape--;
 			newdev->vol.migr_state = 1;
 			newdev->vol.curr_migr_unit = 0;
-			newdev->vol.migr_type = MIGR_GEN_MIGR;
+			set_migr_type(newdev, MIGR_GEN_MIGR);
 			newmap->num_members = u->new_raid_disks;
 			for (i = 0; i < delta_disks; i++) {
 				set_imsm_ord_tbl_ent(newmap,

