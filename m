From: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Subject: [PATCH 4/4] raid0->raid10 takeover- process metadata update
Date: Mon, 17 Jan 2011 16:43:08 +0100
Message-ID: <20110117154308.25096.54013.stgit@gklab-128-111.igk.intel.com>
References: <20110117153908.25096.42697.stgit@gklab-128-111.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110117153908.25096.42697.stgit@gklab-128-111.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, adam.kwolek@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

Implementation of raid0->raid10 takeover metadata update
at process_update level.
- We are using memory prievously alocated in prepare_update to
create two dummy disks will be inserted in the metadata and
new imsm_dev structure with expanded disk order table.
- Update indexes in disk list
- Update metadata map
- Update disk order table

Signed-off-by: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
---
 super-intel.c |   59 +++++++++++++++++++++++++++++++++++++++++++++++++++++----
 1 files changed, 55 insertions(+), 4 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 3b2a273..e284a4a 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -5813,12 +5813,15 @@ update_reshape_exit:
 }
 
 static int apply_takeover_update(struct imsm_update_takeover *u,
-				struct intel_super *super)
+				struct intel_super *super,
+				void ***space_list)
 {
 	struct imsm_dev *dev = NULL;
+	struct intel_dev *dv;
+	struct imsm_dev *dev_new;
 	struct imsm_map *map;
 	struct dl *dm, *du;
-	struct intel_dev *dv;
+	int i;
 
 	for (dv = super->devlist; dv; dv = dv->next)
 		if (dv->index == (unsigned int)u->subarray) {
@@ -5845,7 +5848,6 @@ static int apply_takeover_update(struct imsm_update_takeover *u,
 				dm->index = -1;
 			}
 		}
-
 		/* update map */
 		map->num_members = map->num_members / 2;
 		map->map_state = IMSM_T_STATE_NORMAL;
@@ -5854,10 +5856,59 @@ static int apply_takeover_update(struct imsm_update_takeover *u,
 		map->failed_disk_num = -1;
 	}
 
+	if (u->direction == R0_TO_R10) {
+		void **space;
+		/* update slots in current disk list */
+		for (dm = super->disks; dm; dm = dm->next) {
+			if (dm->index >= 0)
+				dm->index *= 2;
+		}
+		/* create new *missing* disks */
+		for (i = 0; i < map->num_members; i++) {
+			space = *space_list;
+			if (!space)
+				continue;
+			*space_list = *space;
+			du = (void *)space;
+			memcpy(du, super->disks, sizeof(*du));
+			du->disk.status = FAILED_DISK;
+			du->disk.scsi_id = 0;
+			du->fd = -1;
+			du->minor = 0;
+			du->major = 0;
+			du->index = (i * 2) + 1;
+			sprintf((char *)du->disk.serial,
+				" MISSING_%d", du->index);
+			sprintf((char *)du->serial,
+				"MISSING_%d", du->index);
+			du->next = super->missing;
+			super->missing = du;
+		}
+		/* create new dev and map */
+		space = *space_list;
+		if (!space)
+			return 0;
+		*space_list = *space;
+		dev_new = (void *)space;
+		memcpy(dev_new, dev, sizeof(*dev));
+		/* update new map */
+		map = get_imsm_map(dev_new, 0);
+		map->failed_disk_num = map->num_members;
+		map->num_members = map->num_members * 2;
+		map->map_state = IMSM_T_STATE_NORMAL;
+		map->num_domains = 2;
+		map->raid_level = 1;
+		/* replace dev<->dev_new */
+		dv->dev = dev_new;
+	}
 	/* update disk order table */
 	for (du = super->disks; du; du = du->next)
 		if (du->index >= 0)
 			set_imsm_ord_tbl_ent(map, du->index, du->index);
+	for (du = super->missing; du; du = du->next)
+		if (du->index >= 0)
+			set_imsm_ord_tbl_ent(map, du->index,
+						du->index | IMSM_ORD_REBUILD);
 
 	return 1;
 }
@@ -5906,7 +5957,7 @@ static void imsm_process_update(struct supertype *st,
 	switch (type) {
 	case update_takeover: {
 		struct imsm_update_takeover *u = (void *)update->buf;
-		if (apply_takeover_update(u, super))
+		if (apply_takeover_update(u, super, &update->space_list))
 			super->updates_pending++;
 		break;
 	}

