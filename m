From: Przemyslaw Czarnowski
	<przemyslaw.hawrylewicz.czarnowski@intel.com>
Subject: [PATCH 1/5] imsm: prepare update for level migrations reshape
Date: Fri, 29 Apr 2011 00:00:05 +0200
Message-ID: <20110428220005.19632.12064.stgit@gklab-128-081.igk.intel.com>
References: <20110428215751.19632.5381.stgit@gklab-128-081.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110428215751.19632.5381.stgit@gklab-128-081.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, adam.kwolek@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

Introducing raid0->raid5 level migration metadata update structure
is prepared for future use.

Adding spare device is required to hold additional raid5 parity.
Mdadm just checks for spares, but it is not included in update.
If there are no spares available, abort. Otherwise we will create
degraded array what should be not allowed.
Mdmon will decide what spare device is used for parity.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
Signed-off-by: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>
---
 super-intel.c |  112 ++++++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 107 insertions(+), 5 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 83135a6..9bf4714 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -305,6 +305,7 @@ enum imsm_update_type {
 	update_rename_array,
 	update_add_remove_disk,
 	update_reshape_container_disks,
+	update_reshape_migration,
 	update_takeover
 };
 
@@ -340,6 +341,20 @@ struct imsm_update_reshape {
 	enum imsm_update_type type;
 	int old_raid_disks;
 	int new_raid_disks;
+
+	int new_disks[1]; /* new_raid_disks - old_raid_disks makedev number */
+};
+
+struct imsm_update_reshape_migration {
+	enum imsm_update_type type;
+	int old_raid_disks;
+	int new_raid_disks;
+	/* fields for array migration changes
+	 */
+	int subdev;
+	int new_level;
+	int new_layout;
+
 	int new_disks[1]; /* new_raid_disks - old_raid_disks makedev number */
 };
 
@@ -6337,6 +6352,9 @@ static void imsm_process_update(struct supertype *st,
 			super->updates_pending++;
 		break;
 	}
+	case update_reshape_migration: {
+		break;
+	}
 	case update_activate_spare: {
 		struct imsm_update_activate_spare *u = (void *) update->buf; 
 		struct imsm_dev *dev = get_imsm_dev(super, u->array);
@@ -6730,6 +6748,9 @@ static void imsm_prepare_update(struct supertype *st,
 		dprintf("New anchor length is %llu\n", (unsigned long long)len);
 		break;
 	}
+	case update_reshape_migration: {
+		break;
+	}
 	case update_create_array: {
 		struct imsm_update_create_array *u = (void *) update->buf;
 		struct intel_dev *dv;
@@ -7025,12 +7046,12 @@ static int imsm_create_metadata_update_for_reshape(
 	struct supertype *st,
 	struct geo_params *geo,
 	int old_raid_disks,
-	struct imsm_update_reshape **updatep)
+	struct imsm_update_reshape_migration **updatep)
 {
 	struct intel_super *super = st->sb;
 	struct imsm_super *mpb = super->anchor;
 	int update_memory_size = 0;
-	struct imsm_update_reshape *u = NULL;
+	struct imsm_update_reshape_migration *u = NULL;
 	struct mdinfo *spares = NULL;
 	int i;
 	int delta_disks = 0;
@@ -7105,6 +7126,70 @@ abort:
 	return 0;
 }
 
+/******************************************************************************
+ * function: imsm_create_metadata_update_for_migration()
+ *           Creates update for IMSM array.
+ *
+ ******************************************************************************/
+static int imsm_create_metadata_update_for_migration(
+					struct supertype *st,
+					struct geo_params *geo,
+					struct imsm_update_reshape_migration **updatep)
+{
+	struct intel_super *super = st->sb;
+	int update_memory_size = 0;
+	struct imsm_update_reshape_migration *u = NULL;
+	struct imsm_dev *dev;
+	int previous_level = -1;
+
+	dprintf("imsm_create_metadata_update_for_migration(enter)"
+		" New Level = %i\n", geo->level);
+
+	/* size of all update data without anchor */
+	update_memory_size = sizeof(struct imsm_update_reshape_migration);
+
+	u = calloc(1, update_memory_size);
+	if (u == NULL) {
+		dprintf("error: cannot get memory for "
+			"imsm_create_metadata_update_for_migration\n");
+		return 0;
+	}
+	u->type = update_reshape_migration;
+	u->subdev = super->current_vol;
+	u->new_level = geo->level;
+	u->new_layout = geo->layout;
+	u->new_raid_disks = u->old_raid_disks = geo->raid_disks;
+	u->new_disks[0] = -1;
+
+	dev = get_imsm_dev(super, u->subdev);
+	if (dev) {
+		struct imsm_map *map;
+
+		map = get_imsm_map(dev, 0);
+		if (map)
+			previous_level = map->raid_level;
+	}
+	if ((geo->level == 5) && (previous_level == 0)) {
+		struct mdinfo *spares = NULL;
+
+		u->new_raid_disks++;
+		spares = get_spares_for_grow(st);
+		if ((spares == NULL) || (spares->array.spare_disks < 1)) {
+			free(u);
+			sysfs_free(spares);
+			update_memory_size = 0;
+			dprintf("error: cannot get spare device "
+				"for requested migration");
+			return 0;
+		}
+		sysfs_free(spares);
+	}
+	dprintf("imsm: reshape update preparation : OK\n");
+	*updatep = u;
+
+	return update_memory_size;
+}
+
 static void imsm_update_metadata_locally(struct supertype *st,
 					 void *buf, int len)
 {
@@ -7341,7 +7426,7 @@ static int imsm_reshape_super(struct supertype *st, long long size, int level,
 
 		if (imsm_reshape_is_allowed_on_container(
 			    st, &geo, &old_raid_disks)) {
-			struct imsm_update_reshape *u = NULL;
+			struct imsm_update_reshape_migration *u = NULL;
 			int len;
 
 			len = imsm_create_metadata_update_for_reshape(
@@ -7393,9 +7478,26 @@ static int imsm_reshape_super(struct supertype *st, long long size, int level,
 		case CH_TAKEOVER:
 			ret_val = imsm_takeover(st, &geo);
 			break;
-		case CH_MIGRATION:
+		case CH_MIGRATION: {
+			struct imsm_update_reshape_migration *u = NULL;
+			int len =
+				imsm_create_metadata_update_for_migration(
+					st, &geo, &u);
+			if (len < 1) {
+				dprintf("imsm: "
+					"Cannot prepare update\n");
+				break;
+			}
 			ret_val = 0;
-			break;
+			/* update metadata locally */
+			imsm_update_metadata_locally(st, u, len);
+			/* and possibly remotely */
+			if (st->update_tail)
+				append_metadata_update(st, u, len);
+			else
+				free(u);
+		}
+		break;
 		default:
 			ret_val = 1;
 		}

