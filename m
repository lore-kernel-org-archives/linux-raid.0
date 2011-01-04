From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 10/34] imsm: FIX: update first array in container only
Date: Tue, 04 Jan 2011 15:36:57 +0100
Message-ID: <20110104143657.6697.34927.stgit@gklab-128-013.igk.intel.com>
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

During first metadata update imsm for compatibility reason should update
only one array.
Buffers in prepare_update() are prepared for second update as well.
---

 super-intel.c |   33 +++++++++++++++++++++------------
 1 files changed, 21 insertions(+), 12 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 0a915c0..6d76205 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -5594,6 +5594,7 @@ static void imsm_process_update(struct supertype *st,
 		int i;
 		int delta_disks = u->new_raid_disks - u->old_raid_disks;
 		void **tofree = NULL;
+		int devices_to_reshape = 1;
 
 		dprintf("imsm: imsm_process_update() for update_reshape\n");
 
@@ -5621,7 +5622,7 @@ static void imsm_process_update(struct supertype *st,
 
 		dprintf("imsm: process_update(): update_reshape: volume set"\
 			" mpb->num_raid_devs = %i\n", mpb->num_raid_devs);
-		/* manage changes in volumes
+		/* manage changes in volume
 		 */
 		for (id = super->devlist ; id; id = id->next) {
 			void **sp = update->space_list;
@@ -5638,18 +5639,26 @@ static void imsm_process_update(struct supertype *st,
 			newmap = get_imsm_map(newdev, 0);
 			/* Copy the current map */
 			memcpy(newmap, oldmap, sizeof_imsm_map(oldmap));
-			newdev->vol.migr_state = 1;
-			newdev->vol.curr_migr_unit = 0;
-			newdev->vol.migr_type = MIGR_GEN_MIGR;
-			newmap->num_members = u->new_raid_disks;
-			for (i = 0; i < delta_disks; i++) {
-				set_imsm_ord_tbl_ent(newmap,
-						     u->old_raid_disks + i,
-						     u->old_raid_disks + i);
+			/* update one device only
+			 */
+			if (devices_to_reshape) {
+				dprintf("process_update(): modifying "\
+					"subdev: %i\n", id->index);
+				devices_to_reshape--;
+				newdev->vol.migr_state = 1;
+				newdev->vol.curr_migr_unit = 0;
+				newdev->vol.migr_type = MIGR_GEN_MIGR;
+				newmap->num_members = u->new_raid_disks;
+				for (i = 0; i < delta_disks; i++) {
+					set_imsm_ord_tbl_ent(newmap,
+							u->old_raid_disks + i,
+							u->old_raid_disks + i);
+				}
+				/* New map is correct, now need to save old map
+				 */
+				newmap = get_imsm_map(newdev, 1);
+				memcpy(newmap, oldmap, sizeof_imsm_map(oldmap));
 			}
-			/* New map is correct, now need to save old map */
-			newmap = get_imsm_map(newdev, 1);
-			memcpy(newmap, oldmap, sizeof_imsm_map(oldmap));
 
 			sp = (void **)id->dev;
 			id->dev = newdev;

