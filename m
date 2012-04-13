From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 03/14] imsm: Add new metadata update for volume size expansion
Date: Fri, 13 Apr 2012 16:51:57 +0200
Message-ID: <1334328728-12544-4-git-send-email-adam.kwolek@intel.com>
References: <1334328728-12544-1-git-send-email-adam.kwolek@intel.com>
 <1334328728-12544-2-git-send-email-adam.kwolek@intel.com>
 <1334328728-12544-3-git-send-email-adam.kwolek@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1334328728-12544-3-git-send-email-adam.kwolek@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, grzegorz.grabowski@intel.com, maciej.patelczyk@intel.com, anna.czarnowska@intel.com, Adam Kwolek <adam.kwolek@intel.com>
List-Id: linux-raid.ids

Add new meatdata update type imsm_update_size_change, and update metadata
for volume size expansion operation.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---
 super-intel.c |  132 +++++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 124 insertions(+), 8 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index b657249..9220318 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -419,6 +419,7 @@ enum imsm_update_type {
 	update_reshape_migration,
 	update_takeover,
 	update_general_migration_checkpoint,
+	update_size_change,
 };
 
 struct imsm_update_activate_spare {
@@ -471,6 +472,12 @@ struct imsm_update_reshape_migration {
 	int new_disks[1]; /* new_raid_disks - old_raid_disks makedev number */
 };
 
+struct imsm_update_size_change {
+	enum imsm_update_type type;
+	int subdev;
+	long long new_size;
+};
+
 struct imsm_update_general_migration_checkpoint {
 	enum imsm_update_type type;
 	__u32 curr_migr_unit;
@@ -6976,7 +6983,8 @@ static void handle_missing(struct intel_super *super, struct imsm_dev *dev)
 	super->updates_pending++;
 }
 
-static unsigned long long imsm_set_array_size(struct imsm_dev *dev)
+static unsigned long long imsm_set_array_size(struct imsm_dev *dev,
+					      long long new_size)
 {
 	int used_disks = imsm_num_data_members(dev, MAP_0);
 	unsigned long long array_blocks;
@@ -6995,8 +7003,17 @@ static unsigned long long imsm_set_array_size(struct imsm_dev *dev)
 
 	/* set array size in metadata
 	 */
-	map = get_imsm_map(dev, MAP_0);
-	array_blocks = blocks_per_member(map) * used_disks;
+	if (new_size <= 0) {
+		/* OLCE size change is caused by added disks
+		 */
+		map = get_imsm_map(dev, MAP_0);
+		array_blocks = blocks_per_member(map) * used_disks;
+	} else {
+		/* Online Volume Size Change
+		 * Using  available free space
+		 */
+		array_blocks = new_size;
+	}
 
 	/* round array size down to closest MB
 	 */
@@ -7053,7 +7070,7 @@ static void imsm_progress_container_reshape(struct intel_super *super)
 		memcpy(map2, map, copy_map_size);
 		map2->num_members = prev_num_members;
 
-		imsm_set_array_size(dev);
+		imsm_set_array_size(dev, -1);
 		super->clean_migration_record_by_mdmon = 1;
 		super->updates_pending++;
 	}
@@ -7943,7 +7960,7 @@ skip_disk_add:
 			*tofree = *space_list;
 			/* calculate new size
 			 */
-			imsm_set_array_size(new_dev);
+			imsm_set_array_size(new_dev, -1);
 
 			ret_val = 1;
 		}
@@ -7958,6 +7975,44 @@ error_disk_add:
 	return ret_val;
 }
 
+static int apply_size_change_update(struct imsm_update_size_change *u,
+		struct intel_super *super)
+{
+	struct intel_dev *id;
+	int ret_val = 0;
+
+	dprintf("apply_size_change_update()\n");
+	if ((u->subdev < 0) ||
+	    (u->subdev > 1)) {
+		dprintf("imsm: Error: Wrong subdev: %i\n", u->subdev);
+		return ret_val;
+	}
+
+	for (id = super->devlist ; id; id = id->next) {
+		if (id->index == (unsigned)u->subdev) {
+			struct imsm_dev *dev = get_imsm_dev(super, u->subdev);
+			struct imsm_map *map = get_imsm_map(dev, MAP_0);
+			int used_disks = imsm_num_data_members(dev, MAP_0);
+			unsigned long long blocks_per_member;
+
+			/* calculate new size
+			 */
+			blocks_per_member = u->new_size / used_disks;
+			dprintf("imsm: apply_size_change_update(size: %llu, "
+				"blocks per member: %llu)\n",
+				u->new_size, blocks_per_member);
+			set_blocks_per_member(map, blocks_per_member);
+			imsm_set_array_size(dev, u->new_size);
+
+			ret_val = 1;
+			break;
+		}
+	}
+
+	return ret_val;
+}
+
+
 static int apply_update_activate_spare(struct imsm_update_activate_spare *u,
 				       struct intel_super *super,
 				       struct active_array *active_array)
@@ -8157,7 +8212,7 @@ static int apply_reshape_container_disks_update(struct imsm_update_reshape *u,
 			newmap = get_imsm_map(newdev, MAP_1);
 			memcpy(newmap, oldmap, sizeof_imsm_map(oldmap));
 
-			imsm_set_array_size(newdev);
+			imsm_set_array_size(newdev, -1);
 		}
 
 		sp = (void **)id->dev;
@@ -8365,6 +8420,12 @@ static void imsm_process_update(struct supertype *st,
 			super->updates_pending++;
 		break;
 	}
+	case update_size_change: {
+		struct imsm_update_size_change *u = (void *)update->buf;
+		if (apply_size_change_update(u, super))
+			super->updates_pending++;
+		break;
+	}
 	case update_activate_spare: {
 		struct imsm_update_activate_spare *u = (void *) update->buf; 
 		if (apply_update_activate_spare(u, super, st->arrays))
@@ -8759,6 +8820,9 @@ static void imsm_prepare_update(struct supertype *st,
 		dprintf("New anchor length is %llu\n", (unsigned long long)len);
 		break;
 	}
+	case update_size_change: {
+		break;
+	}
 	case update_create_array: {
 		struct imsm_update_create_array *u = (void *) update->buf;
 		struct intel_dev *dv;
@@ -9616,6 +9680,43 @@ abort:
 	return 0;
 }
 
+
+/******************************************************************************
+ * function: imsm_create_metadata_update_for_size_change()
+ *           Creates update for IMSM array for array size change.
+ *
+ ******************************************************************************/
+static int imsm_create_metadata_update_for_size_change(
+				struct supertype *st,
+				struct geo_params *geo,
+				struct imsm_update_size_change **updatep)
+{
+	struct intel_super *super = st->sb;
+	int update_memory_size = 0;
+	struct imsm_update_size_change *u = NULL;
+
+	dprintf("imsm_create_metadata_update_for_size_change(enter)"
+		" New size = %llu\n", geo->size);
+
+	/* size of all update data without anchor */
+	update_memory_size = sizeof(struct imsm_update_size_change);
+
+	u = calloc(1, update_memory_size);
+	if (u == NULL) {
+		dprintf("error: cannot get memory for "
+			"imsm_create_metadata_update_for_size_change\n");
+		return 0;
+	}
+	u->type = update_size_change;
+	u->subdev = super->current_vol;
+	u->new_size = geo->size;
+
+	dprintf("imsm: reshape update preparation : OK\n");
+	*updatep = u;
+
+	return update_memory_size;
+}
+
 /******************************************************************************
  * function: imsm_create_metadata_update_for_migration()
  *           Creates update for IMSM array.
@@ -10025,8 +10126,23 @@ static int imsm_reshape_super(struct supertype *st, long long size, int level,
 		}
 		break;
 		case CH_ARRAY_SIZE: {
-			/* ToDo: Prepare metadata update here
-			 */
+			struct imsm_update_size_change *u = NULL;
+			int len =
+				imsm_create_metadata_update_for_size_change(
+					st, &geo, &u);
+			if (len < 1) {
+				dprintf("imsm: "
+					"Cannot prepare update\n");
+				break;
+			}
+			ret_val = 0;
+			/* update metadata locally */
+			imsm_update_metadata_locally(st, u, len);
+			/* and possibly remotely */
+			if (st->update_tail)
+				append_metadata_update(st, u, len);
+			else
+				free(u);
 		}
 		break;
 		default:
-- 
1.6.4.2

