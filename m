From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 26/34] imsm: Move reshape update processing to function
Date: Tue, 04 Jan 2011 15:39:03 +0100
Message-ID: <20110104143903.6697.67817.stgit@gklab-128-013.igk.intel.com>
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

For code reuse in raid0 reshape case when monitor is not loaded.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |  229 +++++++++++++++++++++++++++++++--------------------------
 1 files changed, 126 insertions(+), 103 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 276e72d..565afd4 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -5660,6 +5660,121 @@ static int add_remove_disk_update(struct intel_super *super)
 	return check_degraded;
 }
 
+static int apply_reshape_container_disks_update(struct imsm_update_reshape *u,
+						 struct intel_super *super,
+						 void ***space_list,
+						 int devices_to_reshape)
+{
+	struct dl *new_disk;
+	struct intel_dev *id;
+	int i;
+	int delta_disks = u->new_raid_disks - u->old_raid_disks;
+	void **tofree = NULL;
+	struct imsm_super *mpb;
+	int ret_val = 0;
+
+	dprintf("imsm: apply_reshape_container_disks_update() for reshape\n");
+	mpb = super->anchor;
+	/* enable spares to use in array
+	 */
+	for (i = 0; i < delta_disks; i++) {
+		new_disk = get_disk_super(super,
+					  major(u->new_disks[i]),
+					  minor(u->new_disks[i]));
+		dprintf("imsm: apply_reshape_container_disks_update():"\
+			"new disk for reshape is: %i:%i (%p, index = %i)\n",
+			major(u->new_disks[i]), minor(u->new_disks[i]),
+			new_disk, new_disk->index);
+		if ((new_disk == NULL) ||
+		    ((new_disk->index >= 0) &&
+		     (new_disk->index < u->old_raid_disks)))
+			goto update_reshape_exit;
+		new_disk->index = mpb->num_disks++;
+		/* slot to fill in autolayout
+		 */
+		new_disk->raiddisk = new_disk->index;
+		new_disk->disk.status |=
+			CONFIGURED_DISK;
+		new_disk->disk.status &= ~SPARE_DISK;
+	}
+
+	dprintf("imsm: apply_reshape_container_disks_update():"
+		"update_reshape: volume set mpb->num_raid_devs = %i\n",
+		mpb->num_raid_devs);
+	/* manage changes in volume
+	 */
+	for (id = super->devlist ; id; id = id->next) {
+		void **sp = *space_list;
+		struct imsm_dev *newdev;
+		struct imsm_map *newmap, *oldmap;
+
+		if (!sp)
+			continue;
+		*space_list = *sp;
+		newdev = (void *)sp;
+		/* Copy the dev, but not (all of) the map
+		 */
+		memcpy(newdev, id->dev, sizeof(*newdev));
+		oldmap = get_imsm_map(id->dev, 0);
+		newmap = get_imsm_map(newdev, 0);
+		/* Copy the current map
+		 */
+		memcpy(newmap, oldmap, sizeof_imsm_map(oldmap));
+		/* update one device only
+		 */
+		if (devices_to_reshape) {
+			int used_disks;
+
+			dprintf("apply_reshape_container_disks_update():"\
+				"modifying subdev: %i\n", id->index);
+			devices_to_reshape--;
+			newdev->vol.migr_state = 1;
+			newdev->vol.curr_migr_unit = 0;
+			newdev->vol.migr_type = MIGR_GEN_MIGR;
+			newmap->num_members = u->new_raid_disks;
+			for (i = 0; i < delta_disks; i++) {
+				set_imsm_ord_tbl_ent(newmap,
+						     u->old_raid_disks + i,
+						     u->old_raid_disks + i);
+			}
+			/* New map is correct, now need to save old map
+			 */
+			newmap = get_imsm_map(newdev, 1);
+			memcpy(newmap, oldmap, sizeof_imsm_map(oldmap));
+
+			/* calculate new size
+			 */
+			used_disks = imsm_num_data_members(newdev, 0);
+			if (used_disks) {
+				unsigned long long array_blocks;
+
+				array_blocks =
+					newmap->blocks_per_member * used_disks;
+				/* round array size down to closest MB
+				 */
+				array_blocks = (array_blocks
+					>> SECT_PER_MB_SHIFT)
+					<< SECT_PER_MB_SHIFT;
+				newdev->size_low =
+					__cpu_to_le32((__u32)array_blocks);
+				newdev->size_high =
+					__cpu_to_le32((__u32)
+							(array_blocks >> 32));
+			}
+		}
+
+		sp = (void **)id->dev;
+		id->dev = newdev;
+		*sp = tofree;
+		tofree = sp;
+	}
+	ret_val = 1;
+
+update_reshape_exit:
+
+	return ret_val;
+}
+
 static void imsm_process_update(struct supertype *st,
 			        struct metadata_update *update)
 {
@@ -5704,109 +5819,12 @@ static void imsm_process_update(struct supertype *st,
 	switch (type) {
 	case update_reshape_container_disks: {
 		struct imsm_update_reshape *u = (void *)update->buf;
-		struct dl *new_disk;
-		struct intel_dev *id;
-		int i;
-		int delta_disks = u->new_raid_disks - u->old_raid_disks;
-		void **tofree = NULL;
-		int devices_to_reshape = 1;
-
-		dprintf("imsm: imsm_process_update() for update_reshape\n");
-
-		/* enable spares to use in array */
-		for (i = 0; i < delta_disks; i++) {
-			new_disk = get_disk_super(super,
-						  major(u->new_disks[i]),
-						  minor(u->new_disks[i]));
-			dprintf("imsm: imsm_process_update(): new disk "\
-				"for reshape is: %i:%i (%p, index = %i)\n",
-				major(u->new_disks[i]), minor(u->new_disks[i]),
-				new_disk, new_disk->index);
-			if ((new_disk == NULL) ||
-			    ((new_disk->index >= 0) &&
-			     (new_disk->index < u->old_raid_disks)))
-				goto update_reshape_exit;
-
-			new_disk->index = mpb->num_disks++;
-			/* slot to fill in autolayout */
-			new_disk->raiddisk = new_disk->index;
-			new_disk->disk.status |=
-				CONFIGURED_DISK;
-			new_disk->disk.status &= ~SPARE_DISK;
-		}
-
-		dprintf("imsm: process_update(): update_reshape: volume set"\
-			" mpb->num_raid_devs = %i\n", mpb->num_raid_devs);
-		/* manage changes in volume
-		 */
-		for (id = super->devlist ; id; id = id->next) {
-			void **sp = update->space_list;
-			struct imsm_dev *newdev;
-			struct imsm_map *newmap, *oldmap;
-
-			if (!sp)
-				continue;
-			update->space_list = *sp;
-			newdev = (void*)sp;
-			/* Copy the dev, but not (all of) the map */
-			memcpy(newdev, id->dev, sizeof(*newdev));
-			oldmap = get_imsm_map(id->dev, 0);
-			newmap = get_imsm_map(newdev, 0);
-			/* Copy the current map */
-			memcpy(newmap, oldmap, sizeof_imsm_map(oldmap));
-			/* update one device only
-			 */
-			if (devices_to_reshape) {
-				int used_disks;
-				dprintf("process_update(): modifying "\
-					"subdev: %i\n", id->index);
-				devices_to_reshape--;
-				newdev->vol.migr_state = 1;
-				newdev->vol.curr_migr_unit = 0;
-				newdev->vol.migr_type = MIGR_GEN_MIGR;
-				newmap->num_members = u->new_raid_disks;
-				for (i = 0; i < delta_disks; i++) {
-					set_imsm_ord_tbl_ent(newmap,
-							u->old_raid_disks + i,
-							u->old_raid_disks + i);
-				}
-				/* New map is correct, now need to save old map
-				 */
-				newmap = get_imsm_map(newdev, 1);
-				memcpy(newmap, oldmap, sizeof_imsm_map(oldmap));
+		int ret_val;
 
-				/* calculate new size
-				 */
-				used_disks = imsm_num_data_members(newdev, 0);
-				if (used_disks) {
-					unsigned long long array_blocks;
-
-					array_blocks =
-						newmap->blocks_per_member
-						* used_disks;
-					/* round array size down to closest MB
-					 */
-					array_blocks = (array_blocks
-							>> SECT_PER_MB_SHIFT)
-							<< SECT_PER_MB_SHIFT;
-					newdev->size_low =
-						__cpu_to_le32(
-							(__u32)array_blocks);
-					newdev->size_high =
-						__cpu_to_le32(
-						(__u32)(array_blocks >> 32));
-				}
-			}
-
-			sp = (void **)id->dev;
-			id->dev = newdev;
-			*sp = tofree;
-			tofree = sp;
-		}
-
-		update->space_list = tofree;
-		super->updates_pending++;
-update_reshape_exit:
+		ret_val = apply_reshape_container_disks_update(u, super,
+							&update->space_list, 1);
+		if (ret_val)
+			super->updates_pending++;
 		break;
 	}
 	case update_activate_spare: {
@@ -6592,7 +6610,12 @@ static int imsm_reshape_super(struct supertype *st, long long size, int level,
 
 			if (len) {
 				ret_val = 0;
-				append_metadata_update(st, u, len);
+				if (mdmon_running(st->container_dev))
+					append_metadata_update(st, u, len);
+				else {
+					/* no mdmon - apply update
+					 */
+				}
 			} else
 				dprintf("imsm: Cannot prepare "\
 					"update\n");

