From: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Subject: [PATCH 1/4] Add raid10 -> raid0 takeover support
Date: Mon, 17 Jan 2011 16:42:43 +0100
Message-ID: <20110117154243.25096.6278.stgit@gklab-128-111.igk.intel.com>
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

The patch introduces takeover form level 10 to level 0 for imsm
metadata. This patch contains procedures connected with preparing
and applying metadata update during 10 -> 0 takeover.
When performing takeover 10->0 mdmon should update the external
metadata (due to disk slot and level changes).
To achieve that mdadm calls reshape_super() and prepare
the "update_takeover" metadata update type.
Prepared update is processed by mdmon in process_update().

Signed-off-by: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
---
 Grow.c        |    1 +
 super-intel.c |   98 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 98 insertions(+), 1 deletions(-)

diff --git a/Grow.c b/Grow.c
index ad13d6e..c4125ea 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1463,6 +1463,7 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 			rv = 1;
 			goto release;
 		}
+		ping_monitor(container);
 	}
 
 	info.array = array;
diff --git a/super-intel.c b/super-intel.c
index 334e0f4..86b365d 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -299,6 +299,7 @@ enum imsm_update_type {
 	update_rename_array,
 	update_add_remove_disk,
 	update_reshape_container_disks,
+	update_takeover
 };
 
 struct imsm_update_activate_spare {
@@ -319,6 +320,15 @@ struct geo_params {
 	int raid_disks;
 };
 
+enum takeover_direction {
+	R10_TO_R0,
+	R0_TO_R10
+};
+struct imsm_update_takeover {
+	enum imsm_update_type type;
+	int subarray;
+	enum takeover_direction direction;
+};
 
 struct imsm_update_reshape {
 	enum imsm_update_type type;
@@ -5802,6 +5812,56 @@ update_reshape_exit:
 	return ret_val;
 }
 
+static int apply_takeover_update(struct imsm_update_takeover *u,
+				struct intel_super *super)
+{
+	struct imsm_dev *dev = NULL;
+	struct imsm_map *map;
+	struct dl *dm, *du;
+	struct intel_dev *dv;
+
+	for (dv = super->devlist; dv; dv = dv->next)
+		if (dv->index == (unsigned int)u->subarray) {
+			dev = dv->dev;
+			break;
+	}
+
+	if (dev == NULL)
+		return 0;
+
+	map = get_imsm_map(dev, 0);
+
+	if (u->direction == R10_TO_R0) {
+		/* iterate through devices to mark removed disks as spare */
+		for (dm = super->disks; dm; dm = dm->next) {
+			if (dm->disk.status & FAILED_DISK) {
+				int idx = dm->index;
+				/* update indexes on the disk list */
+				for (du = super->disks; du; du = du->next)
+					if (du->index > idx)
+						du->index--;
+				/* mark as spare disk */
+				dm->disk.status = SPARE_DISK;
+				dm->index = -1;
+			}
+		}
+
+		/* update map */
+		map->num_members = map->num_members / 2;
+		map->map_state = IMSM_T_STATE_NORMAL;
+		map->num_domains = 1;
+		map->raid_level = 0;
+		map->failed_disk_num = -1;
+	}
+
+	/* update disk order table */
+	for (du = super->disks; du; du = du->next)
+		if (du->index >= 0)
+			set_imsm_ord_tbl_ent(map, du->index, du->index);
+
+	return 1;
+}
+
 static void imsm_process_update(struct supertype *st,
 			        struct metadata_update *update)
 {
@@ -5844,6 +5904,13 @@ static void imsm_process_update(struct supertype *st,
 	mpb = super->anchor;
 
 	switch (type) {
+	case update_takeover: {
+		struct imsm_update_takeover *u = (void *)update->buf;
+		if (apply_takeover_update(u, super))
+			super->updates_pending++;
+		break;
+	}
+
 	case update_reshape_container_disks: {
 		struct imsm_update_reshape *u = (void *)update->buf;
 		if (apply_reshape_container_disks_update(
@@ -6691,6 +6758,35 @@ analyse_change_exit:
 	return change;
 }
 
+int imsm_takeover(struct supertype *st, struct geo_params *geo)
+{
+	struct intel_super *super = st->sb;
+	struct imsm_update_takeover *u;
+
+	u = malloc(sizeof(struct imsm_update_takeover));
+	if (u == NULL)
+		return 1;
+
+	u->type = update_takeover;
+	u->subarray = super->current_vol;
+
+	/* 10->0 transition */
+	if (geo->level == 0)
+		u->direction = R10_TO_R0;
+
+	/* update metadata locally */
+	imsm_update_metadata_locally(st, u,
+					sizeof(struct imsm_update_takeover));
+	/* and possibly remotely */
+	if (st->update_tail)
+		append_metadata_update(st, u,
+					sizeof(struct imsm_update_takeover));
+	else
+		free(u);
+
+	return 0;
+}
+
 static int imsm_reshape_super(struct supertype *st, long long size, int level,
 			      int layout, int chunksize, int raid_disks,
 			      char *backup, char *dev, int verbose)
@@ -6772,7 +6868,7 @@ static int imsm_reshape_super(struct supertype *st, long long size, int level,
 		change = imsm_analyze_change(st, &geo);
 		switch (change) {
 			case CH_TAKEOVER:
-				ret_val = 0;
+				ret_val = imsm_takeover(st, &geo);
 				break;
 			case CH_CHUNK_MIGR:
 				ret_val = 0;

