From: "Trela, Maciej" <Maciej.Trela@intel.com>
Subject: [PATCH 03/10] mdadm: support non-grow reshape for external meta
Date: Wed, 21 Jul 2010 12:18:26 +0100
Message-ID: <BE2BFE91933D1B4089447C64486040804E2A49BC@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>, "Kwolek, Adam" <adam.kwolek@intel.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

From: Maciej Trela <maciej.trela@intel.com>

Add support for non-grow reshape operation - i.e. when changing the layout only.
The operation for changing the layout is needed for Raid0->Raid5 migrations:
after Raid0 is taken over to Raid4 it has to be reshaped to the new layout to become Raid5.

Operation sequence for non-grow reshape is the same as for OLCE (online capacity expansion) reshape type:
	- update_super() with "update_grow_array" parameter
	- prepare_update() with "update_grow_array"
	- process_update() with "update_grow_array"

Note that for Raid5 layout we need to provide additional missing device to metadata - see process_update().

Signed-off-by: Maciej Trela <maciej.trela@intel.com>
---
 Grow.c        |   42 ++++++++++++++++++++++++++++++++++
 managemon.c   |   12 +++++-----
 super-intel.c |   71 +++++++++++++++++++++++++++++++++++++++++++++++----------
 3 files changed, 106 insertions(+), 19 deletions(-)  mode change 100644 => 100755 super-intel.c

diff --git a/Grow.c b/Grow.c
index ea6f266..4146a05 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1624,6 +1624,9 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 			/* prepare meta update and add devices to mdmon
 			 */
 			info.delta_disks = delta_disks;
+			info.new_chunk = nchunk;
+			info.new_layout = nlayout;
+			info.new_level = (level == UnSet) ? array.level : level;
 			st->update_tail = &st->updates;
 			if (st->ss->update_super(st, &info, "update_grow_array",
 						 info.name, 0, 0, NULL) > 0)
@@ -1667,6 +1670,13 @@ native_array_setup:
 				break;
 			}
 		} else {
+			struct mdinfo info;
+			int delta_disks = 0;
+			int container_fd = -1;
+			int dn;
+			struct mdinfo *ret_info = NULL;
+			int required_disks = 0;
+
 			/* set them all just in case some old 'new_*' value
 			 * persists from some earlier problem
 			 */
@@ -1690,6 +1700,38 @@ native_array_setup:
 					fprintf(stderr, "       Bitmap must be removed before shape can be changed\n");
 				break;
 			}
+
+			/* check if we have external or native metadata
+			 */
+			if (st == NULL || st->ss->external == 0)
+				goto ext_array_configured;
+
+			/* update array for external meta via user space
+			 */
+			dn = devname2devnum(sra->text_version + 1);
+			container_fd = open_dev_excl(dn);
+			if (container_fd < 0)
+				goto ext_array_configured;
+			st->ss->load_super(st, container_fd, NULL);
+			close(container_fd);
+			st->ss->getinfo_super(st, &info);
+
+			delta_disks = 0;
+			strcpy(info.sys_name, sra->sys_name);
+			ret_info = st->ss->container_content(st);
+			if (ret_info == NULL)
+				goto ext_array_configured;
+			required_disks = ndisks;
+
+			/* prepare meta update and add devices to mdmon
+			 */
+			info.delta_disks = delta_disks;
+			info.new_chunk = nchunk;
+			info.new_layout = nlayout;
+			info.new_level = (level == UnSet) ? array.level : level;
+			st->update_tail = &st->updates;
+			st->ss->update_super(st, &info, "update_grow_array",
+					     info.name, 0, 0, NULL);
 		}
 
 ext_array_configured:
diff --git a/managemon.c b/managemon.c
index 8a4e089..a60aa97 100644
--- a/managemon.c
+++ b/managemon.c
@@ -380,9 +380,6 @@ static void manage_member(struct mdstat_ent *mdstat,
 	 * trying to find and assign a spare.
 	 * We do that whenever the monitor tells us too.
 	 */
-	// FIXME
-	a->info.array.chunk_size = mdstat->chunk_size;
-	// MORE
 
 	level = mdstat_to_level(mdstat);
 	if (a->info.array.level != level && level >= 0) { @@ -396,8 +393,9 @@ static void manage_member(struct mdstat_ent *mdstat,
 		/* not takeover fo maybe OLCE
 		 * accept OLCE during reshape only
 		 */
-		if ((a->info.array.raid_disks < mdstat->raid_disks) &&
-		    (a->info.array.raid_disks > 0)) {
+		if ((a->info.array.raid_disks < mdstat->raid_disks && a->info.array.raid_disks > 0) ||
+		    (a->info.array.chunk_size != mdstat->chunk_size && a->info.array.chunk_size > 0) ||
+		    (a->info.array.layout != mdstat->layout && a->info.array.layout > 
+0)) {
 			/* Yes - online capacity expanssion
 			 */
 			if (a->container->ss->grow_array) {
@@ -417,6 +415,8 @@ static void manage_member(struct mdstat_ent *mdstat,
 		}
 	}
 	a->info.array.raid_disks = mdstat->raid_disks;
+	a->info.array.chunk_size = mdstat->chunk_size;
+	a->info.array.layout = mdstat->layout;
 
 	if (a->check_degraded) {
 		struct metadata_update *updates = NULL; @@ -515,7 +515,7 @@ static void manage_new(struct mdstat_ent *mdstat,
 		return;
 
 	mdi = sysfs_read(-1, mdstat->devnum,
-			 GET_LEVEL|GET_CHUNK|GET_DISKS|GET_COMPONENT|
+			 GET_LEVEL|GET_LAYOUT|GET_CHUNK|GET_DISKS|GET_COMPONENT|
 			 GET_DEGRADED|GET_DEVS|GET_OFFSET|GET_SIZE|GET_STATE);
 
 	new = malloc(sizeof(*new));
diff --git a/super-intel.c b/super-intel.c old mode 100644 new mode 100755 index faa5d2e..286f722
--- a/super-intel.c
+++ b/super-intel.c
@@ -1753,7 +1753,7 @@ static int update_super_imsm(struct supertype *st, struct mdinfo *info,
 	}
 
 	if ((strcmp(update, "update_grow_array") == 0) &&
-	    (info->delta_disks > 0)) {
+	    (info->delta_disks >= 0)) {
 		struct imsm_update_grow_array *u = NULL;
 		struct mdinfo *sra = NULL;
 		struct mdinfo *vol = NULL;
@@ -1808,6 +1808,12 @@ static int update_super_imsm(struct supertype *st, struct mdinfo *info,
 		disks = (disks > map->num_members) ?
 			disks : map->num_members;
 
+		/* Support non-grow reshape case:
+		 *  if reshaping raid5(4) additional missing disk will be used */
+		if (map->raid_level == 0 && info->new_level == 5
+		    && info->new_layout == 0)
+			disks++;
+
 		/* allocate device that can receive new disks number
 		 * and reserve place for second map during migration
 		 */
@@ -1815,7 +1821,6 @@ static int update_super_imsm(struct supertype *st, struct mdinfo *info,
 			   ((disks - 1) * sizeof(__u32)) +
 			   sizeof(struct imsm_map) + ((disks-1) * sizeof(__u32));
 		u = calloc(1, len);
-
 		if (u == NULL) {
 			dprintf("imsm: Error: Cannot allocate memory for update (mdadm: update_grow_array)\n");
 			return 1;
@@ -1885,6 +1890,12 @@ static int update_super_imsm(struct supertype *st, struct mdinfo *info,
 				spare = NULL;
 		}
 
+		/* Support non-grow reshape case:
+		 *  if reshaping raid5(4) additional missing disk will be used */
+		if (map_new->raid_level == 0 && info->new_level == 5
+		    && info->new_layout == 0)
+			map_new->num_members++;
+
 		/* migration has to be in progress,
 		 * to get second map, copy it from current device map
 		 */
@@ -1898,13 +1909,6 @@ static int update_super_imsm(struct supertype *st, struct mdinfo *info,
 
 		map = get_imsm_map(dev_new, 0);
 		disks = map->num_members - map_migr_new->num_members;
-		if (disks != u->reshape_delta_disks) {
-			/* wrong number of disks added to md
-			 */
-			dprintf("imsm: ERROR: Not enough drives added to md (added = %i, required = %i).\n",
-				disks, u->reshape_delta_disks);
-			goto exit_update_grow_array;
-		}
 
 		/* update ready,
 		 * append it
@@ -5210,10 +5214,16 @@ int imsm_grow_array(struct active_array *a,  int new_raid_disks)
 		inst, a->info.array.raid_disks, a->info.array.level);
 
 	/* grow support only */
-	if ((a->info.array.raid_disks >= new_raid_disks) &&
+	if ((a->info.array.raid_disks > new_raid_disks) &&
 	    (new_raid_disks > 0))
 		return ret_val;
 
+	/* support non-grow reshape */
+	if (a->info.array.raid_disks == new_raid_disks) {
+		ret_val = 1;
+		goto do_not_grow;
+	}
+
 	/* Look for all disks beyond current configuration
 	 * To handle degradation after takeover
 	 * look also on last disk in configuration.
@@ -5309,6 +5319,7 @@ int imsm_grow_array(struct active_array *a,  int new_raid_disks)
 
 	/* prepare device to receive new disk(s)
 	 */
+ do_not_grow:
 	reallocate_imsm_dev(super, inst, new_raid_disks);
 
 	return ret_val;
@@ -5438,8 +5449,9 @@ static void imsm_process_update(struct supertype *st,
 		int slot;
 		int update_grow_array_status = -1;
 
+
 		slot = u->slot;
-		if (u->reshape_delta_disks <= 0) {
+		if (u->reshape_delta_disks < 0) {
 			fprintf(stderr, "error:(imsm) "\
 				"Wrong update is passed\n");
 			goto update_grow_array_exit;
@@ -5515,6 +5527,38 @@ static void imsm_process_update(struct supertype *st,
 		migr_map_src = get_imsm_map(dev_new, 1);
 		memcpy(migr_map, migr_map_src, sizeof_imsm_map(migr_map_src));
 
+		/* Support non-grow reshape case:
+		 *  if reshaping raid5(4) additional missing disk will be used */
+		if (map->raid_level != a->info.array.level) {
+			if (map->raid_level == 0 &&
+			    a->info.array.level == 5 &&
+			    a->info.array.layout == 0) {
+
+				int i;
+				map->raid_level = a->info.array.level;
+				mpb->num_disks++;
+
+				/* clear missing disks list */
+				while (super->missing) {
+					dl = super->missing;
+					super->missing = dl->next;
+					__free_imsm_disk(dl);
+				}
+				find_missing(super);
+				dl = super->missing;
+				assert(dl != NULL);
+				if (!dl)
+					break;
+				memset(&dl->disk, 0, sizeof(dl->disk));
+				strcpy((char *)dl->disk.serial, "MISSING");
+				dl->disk.total_blocks = map->blocks_per_member;
+				/* Set slot for missing disk */
+				i = map->num_members - 1;
+				set_imsm_ord_tbl_ent(map, i, dl->index | IMSM_ORD_REBUILD);
+				dl->raiddisk = i;
+			}
+		}
+
 		/* manage size, if active array is known
 		 * to in line with md access active array
 		 * (Initialize pointer to the proper active array) @@ -5844,7 +5888,7 @@ static void imsm_prepare_update(struct supertype *st,
 
 		dprintf("prepare_update(): update_grow_array\n");
 
-		if (u->reshape_delta_disks <= 0)
+		if (u->reshape_delta_disks < 0)
 			break;
 
 		/* add place for device in device list @@ -6008,7 +6052,8 @@ int imsm_reshape_is_allowed_on_container(struct is_allowed_params *params)
 		}
 		st->ss->getinfo_super(st, &info);
 
-		if (params->raid_disks <= info.array.raid_disks) {
+		if (params->raid_disks <= info.array.raid_disks &&
+		    params->raid_disks) {
 			/* we work on container for
 			 * Online Capacity Expansion
 			 * only

