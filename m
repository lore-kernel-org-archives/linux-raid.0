From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 19/53] imsm: Add support for general migration
Date: Fri, 26 Nov 2010 09:06:15 +0100
Message-ID: <20101126080615.5221.22468.stgit@gklab-170-024.igk.intel.com>
References: <20101126075407.5221.62582.stgit@gklab-170-024.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101126075407.5221.62582.stgit@gklab-170-024.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

Internal IMSM procedures need to support the General Migration.
It is used during operations like:
- Online Capacity Expansion,
- migration initialization,
- finishing migration,
- apply changes to raid disks etc.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 mdmon.h       |    2 +-
 super-intel.c |   62 +++++++++++++++++++++++++++++++++++++++++++++++++++------
 2 files changed, 56 insertions(+), 8 deletions(-)

diff --git a/mdmon.h b/mdmon.h
index 5c51566..8190358 100644
--- a/mdmon.h
+++ b/mdmon.h
@@ -76,7 +76,7 @@ void do_monitor(struct supertype *container);
 void do_manager(struct supertype *container);
 extern int sigterm;
 
-int read_dev_state(int fd);
+extern int read_dev_state(int fd);
 int is_container_member(struct mdstat_ent *mdstat, char *container);
 
 struct mdstat_ent *mdstat_read(int hold, int start);
diff --git a/super-intel.c b/super-intel.c
index f092ccc..90faff6 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -2139,7 +2139,8 @@ static void migrate(struct imsm_dev *dev, __u8 to_state, int migr_type)
 
 	/* duplicate and then set the target end state in map[0] */
 	memcpy(dest, src, sizeof_imsm_map(src));
-	if (migr_type == MIGR_REBUILD) {
+	if ((migr_type == MIGR_REBUILD) ||
+	    (migr_type ==  MIGR_GEN_MIGR)) {
 		__u32 ord;
 		int i;
 
@@ -2156,18 +2157,26 @@ static void end_migration(struct imsm_dev *dev, __u8 map_state)
 {
 	struct imsm_map *map = get_imsm_map(dev, 0);
 	struct imsm_map *prev = get_imsm_map(dev, dev->vol.migr_state);
-	int i;
+	int i, j;
 
 	/* merge any IMSM_ORD_REBUILD bits that were not successfully
 	 * completed in the last migration.
 	 *
-	 * FIXME add support for online capacity expansion and
-	 * raid-level-migration
+	 * FIXME add support for raid-level-migration
 	 */
 	for (i = 0; i < prev->num_members; i++)
-		map->disk_ord_tbl[i] |= prev->disk_ord_tbl[i];
+		for (j = 0; j < map->num_members; j++)
+			/* during online capacity expansion
+			 * disks position can be changed if takeover is used
+			 */
+			if (ord_to_idx(map->disk_ord_tbl[j]) ==
+			    ord_to_idx(prev->disk_ord_tbl[i])) {
+				map->disk_ord_tbl[j] |= prev->disk_ord_tbl[i];
+				break;
+			}
 
 	dev->vol.migr_state = 0;
+	dev->vol.migr_type = 0;
 	dev->vol.curr_migr_unit = 0;
 	map->map_state = map_state;
 }
@@ -4307,6 +4316,17 @@ static int update_subarray_imsm(struct supertype *st, char *update, mddev_ident_
 }
 #endif /* MDASSEMBLE */
 
+static int is_gen_migration(struct imsm_dev *dev)
+{
+	if (!dev->vol.migr_state)
+		return 0;
+
+	if (migr_type(dev) == MIGR_GEN_MIGR)
+		return 1;
+
+	return 0;
+}
+
 static int is_rebuilding(struct imsm_dev *dev)
 {
 	struct imsm_map *migr_map;
@@ -4388,8 +4408,7 @@ static struct mdinfo *container_content_imsm(struct supertype *st)
 		 * unsupported migration
 		 */
 		if (dev->vol.migr_state &&
-		    (migr_type(dev) == MIGR_GEN_MIGR ||
-		     migr_type(dev) == MIGR_STATE_CHANGE)) {
+		    (migr_type(dev) == MIGR_STATE_CHANGE)) {
 			fprintf(stderr, Name ": cannot assemble volume '%.16s':"
 				" unsupported migration in progress\n",
 				dev->volume);
@@ -4672,6 +4691,8 @@ static void handle_missing(struct intel_super *super, struct imsm_dev *dev)
 	super->updates_pending++;
 }
 
+static void imsm_set_disk(struct active_array *a, int n, int state);
+
 /* Handle dirty -> clean transititions and resync.  Degraded and rebuild
  * states are handled in imsm_set_disk() with one exception, when a
  * resync is stopped due to a new failure this routine will set the
@@ -4747,6 +4768,16 @@ static int imsm_set_array_state(struct active_array *a, int consistent)
 			dev->vol.dirty = 1;
 		super->updates_pending++;
 	}
+
+	/* finalize online capacity expansion/reshape */
+	if ((a->curr_action != reshape) &&
+	    (a->prev_action == reshape)) {
+		struct mdinfo *mdi;
+
+		for (mdi = a->info.devs; mdi; mdi = mdi->next)
+			imsm_set_disk(a, mdi->disk.raid_disk, mdi->curr_state);
+	}
+
 	return consistent;
 }
 
@@ -4810,6 +4841,23 @@ static void imsm_set_disk(struct active_array *a, int n, int state)
 		end_migration(dev, map_state);
 		super->updates_pending++;
 		a->last_checkpoint = 0;
+	} else if (is_gen_migration(dev)) {
+		dprintf("imsm: Detected General Migration in state: ");
+		if (map_state == IMSM_T_STATE_NORMAL) {
+			end_migration(dev, map_state);
+			map = get_imsm_map(dev, 0);
+			map->failed_disk_num = ~0;
+			dprintf("normal\n");
+		} else {
+			if (map_state == IMSM_T_STATE_DEGRADED) {
+				printf("degraded\n");
+				end_migration(dev, map_state);
+			} else {
+				dprintf("failed\n");
+			}
+			map->map_state = map_state;
+		}
+		super->updates_pending++;
 	}
 }
 

