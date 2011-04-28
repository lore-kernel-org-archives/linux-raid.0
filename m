From: Przemyslaw Czarnowski
	<przemyslaw.hawrylewicz.czarnowski@intel.com>
Subject: [PATCH 4/5] imsm: process update for raid level migrations
Date: Fri, 29 Apr 2011 00:01:45 +0200
Message-ID: <20110428220145.19632.6578.stgit@gklab-128-081.igk.intel.com>
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

Received update and prepared memory is processed to update imsm metadata.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
Signed-off-by: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>
---
 super-intel.c |  123 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 122 insertions(+), 1 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 877d9e6..d4a45d7 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -6088,6 +6088,124 @@ static int add_remove_disk_update(struct intel_super *super)
 	return check_degraded;
 }
 
+
+static int apply_reshape_migration_update(struct imsm_update_reshape_migration *u,
+						struct intel_super *super,
+						void ***space_list)
+{
+	struct intel_dev *id;
+	void **tofree = NULL;
+	int ret_val = 0;
+
+	dprintf("apply_reshape_migration_update()\n");
+	if ((u->subdev < 0) ||
+	    (u->subdev > 1)) {
+		dprintf("imsm: Error: Wrong subdev: %i\n", u->subdev);
+		return ret_val;
+	}
+	if ((space_list == NULL) || (*space_list == NULL)) {
+		dprintf("imsm: Error: Memory is not allocated\n");
+		return ret_val;
+	}
+
+	for (id = super->devlist ; id; id = id->next) {
+		if (id->index == (unsigned)u->subdev) {
+			struct imsm_dev *dev = get_imsm_dev(super, u->subdev);
+			struct imsm_map *map;
+			struct imsm_dev *new_dev =
+				(struct imsm_dev *)*space_list;
+			struct imsm_map *migr_map = get_imsm_map(dev, 1);
+			int to_state;
+			struct dl *new_disk;
+
+			if (new_dev == NULL)
+				return ret_val;
+			*space_list = **space_list;
+			memcpy(new_dev, dev, sizeof_imsm_dev(dev, 0));
+			map = get_imsm_map(new_dev, 0);
+			if (migr_map) {
+				dprintf("imsm: Error: migration in progress");
+				return ret_val;
+			}
+
+			to_state = map->map_state;
+			if ((u->new_level == 5) && (map->raid_level == 0)) {
+				map->num_members++;
+				/* this should not happen */
+				if (u->new_disks[0] < 0) {
+					map->failed_disk_num =
+						map->num_members - 1;
+					to_state = IMSM_T_STATE_DEGRADED;
+				} else
+					to_state = IMSM_T_STATE_NORMAL;
+			}
+			migrate(new_dev, to_state, MIGR_GEN_MIGR);
+			if (u->new_level > -1)
+				map->raid_level = u->new_level;
+			migr_map = get_imsm_map(new_dev, 1);
+			if ((u->new_level == 5) &&
+			    (migr_map->raid_level == 0)) {
+				int ord = map->num_members - 1;
+				migr_map->num_members--;
+				if (u->new_disks[0] < 0)
+					ord |= IMSM_ORD_REBUILD;
+				set_imsm_ord_tbl_ent(map,
+						     map->num_members - 1,
+						     ord);
+			}
+			id->dev = new_dev;
+			tofree = (void **)dev;
+
+			/* add disk
+			 */
+			if ((u->new_level != 5) ||
+			    (migr_map->raid_level != 0) ||
+			    (migr_map->raid_level == map->raid_level))
+				goto skip_disk_add;
+
+			if (u->new_disks[0] >= 0) {
+				/* use passes spare
+				 */
+				new_disk = get_disk_super(super,
+							major(u->new_disks[0]),
+							minor(u->new_disks[0]));
+				dprintf("imsm: new disk for reshape is: %i:%i "
+					"(%p, index = %i)\n",
+					major(u->new_disks[0]),
+					minor(u->new_disks[0]),
+					new_disk, new_disk->index);
+				if (new_disk == NULL)
+					goto error_disk_add;
+
+				new_disk->index = map->num_members - 1;
+				/* slot to fill in autolayout
+				 */
+				new_disk->raiddisk = new_disk->index;
+				new_disk->disk.status |= CONFIGURED_DISK;
+				new_disk->disk.status &= ~SPARE_DISK;
+			} else
+				goto error_disk_add;
+
+skip_disk_add:
+			*tofree = *space_list;
+			/* calculate new size
+			 */
+			imsm_set_array_size(new_dev);
+
+			ret_val = 1;
+		}
+	}
+
+	if (tofree)
+		*space_list = tofree;
+	return ret_val;
+
+error_disk_add:
+	dprintf("Error: imsm: Cannot find disk.\n");
+	return ret_val;
+}
+
+
 static int apply_reshape_container_disks_update(struct imsm_update_reshape *u,
 						struct intel_super *super,
 						void ***space_list)
@@ -6353,6 +6471,10 @@ static void imsm_process_update(struct supertype *st,
 		break;
 	}
 	case update_reshape_migration: {
+		struct imsm_update_reshape_migration *u = (void *)update->buf;
+		if (apply_reshape_migration_update(
+			    u, super, &update->space_list))
+			super->updates_pending++;
 		break;
 	}
 	case update_activate_spare: {
@@ -6381,7 +6503,6 @@ static void imsm_process_update(struct supertype *st,
 		}
 
 		super->updates_pending++;
-
 		/* count failures (excluding rebuilds and the victim)
 		 * to determine map[0] state
 		 */

