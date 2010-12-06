From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 21/27] Migration raid0->raid5
Date: Mon, 06 Dec 2010 14:23:31 +0100
Message-ID: <20101206132331.21125.46565.stgit@gklab-170-024.igk.intel.com>
References: <20101206131821.21125.65217.stgit@gklab-170-024.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101206131821.21125.65217.stgit@gklab-170-024.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

Add implementation for migration from raid0 to raid5 in one step.
For imsm raid level parameters flow from mdadm (vi metadata update) to managemon was added.

Block takeover for this migration case (update_reshape is used only)
For migration on container (OLCE) reinitialize variables that are changed
by single array reshape case.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |   50 ++++++++++++++++++++++++++++++++++++++++++--------
 1 files changed, 42 insertions(+), 8 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 2c5331f..dee23e2 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -5001,7 +5001,7 @@ static void imsm_sync_metadata(struct supertype *container)
 {
 	struct intel_super *super = container->sb;
 
-	if (!super->updates_pending)
+	if (!super || !super->updates_pending)
 		return;
 
 	write_super_imsm(container, 0);
@@ -6502,6 +6502,13 @@ struct imsm_update_reshape *imsm_create_metadata_update_for_reshape(struct super
 
 	dprintf("imsm imsm_update_metadata_for_reshape(enter) raid_disks = %i\n", geo->raid_disks);
 
+	if (super == NULL || super->anchor == NULL) {
+		dprintf("Error: imsm_create_metadata_update_for_reshape(): null pointers on input\n");
+		dprintf("\t\t super = %p\n", super);
+		if (super)
+			dprintf("\t\t super->anchor = %p\n", super->anchor);
+		return ret_val;
+	}
 	if ((geo->raid_disks < super->anchor->num_disks) ||
 	    (geo->raid_disks == UnSet))
 		geo->raid_disks = super->anchor->num_disks;
@@ -6580,8 +6587,11 @@ struct imsm_update_reshape *imsm_create_metadata_update_for_reshape(struct super
 						set_imsm_ord_tbl_ent(new_map, idx, idx);
 				}
 				u->devnum = geo->dev_id;
-				/* case for reshape without grow */
-				if (u->reshape_delta_disks == 0) {
+				/* case for reshape without grow
+				 * or grow is level change effect
+				 */
+				if ((u->reshape_delta_disks == 0) ||
+				    ((new_map->raid_level != geo->level) && (geo->level != UnSet))) {
 					dprintf("imsm: reshape prepate metadata for volume= %d, index= %d\n", geo->dev_id, i);
 					if (update_geometry(st, geo) == -1) {
 						dprintf("imsm: ERROR: Cannot prepare update for volume map!\n");
@@ -6765,6 +6775,7 @@ int imsm_reshape_super(struct supertype *st, long long size, int level,
 	int ret_val = 1;
 	struct mdinfo *sra = NULL;
 	int fd = -1;
+	int fdc = -1;
 	char buf[PATH_MAX];
 	int delta_disks = -1;
 	struct geo_params geo;
@@ -6820,10 +6831,16 @@ int imsm_reshape_super(struct supertype *st, long long size, int level,
 	} else
 		dprintf("imsm: not a container operation\n");
 
-	snprintf(buf, PATH_MAX, "/dev/md%i", st->devnum);
-	fd = open(buf , O_RDONLY | O_DIRECT);
+	snprintf(buf, PATH_MAX, "/dev/md%i", st->container_dev);
+	fdc = open(buf , O_RDONLY | O_DIRECT);
+	if (fdc < 0) {
+		dprintf("imsm: cannot open container: %s\n", buf);
+		goto imsm_reshape_super_exit;
+	}
+
+	fd = open(geo.dev_name , O_RDONLY | O_DIRECT);
 	if (fd < 0) {
-		dprintf("imsm: cannot open device: %s\n", buf);
+		dprintf("imsm: cannot open device: %s\n", geo.dev_name);
 		goto imsm_reshape_super_exit;
 	}
 
@@ -6841,8 +6858,10 @@ int imsm_reshape_super(struct supertype *st, long long size, int level,
 	 */
 	if (geo.raid_disks > 0 && geo.raid_disks != UnSet)
 		delta_disks = geo.raid_disks - sra->array.raid_disks;
-	else
+	else {
 		delta_disks = 0;
+		geo.raid_disks = sra->array.raid_disks;
+	}
 	dprintf("imsm: imsm_reshape_super() called on array when delta disks = %i\n", delta_disks);
 	if (delta_disks == 0) {
 		struct imsm_update_reshape *u;
@@ -6850,7 +6869,16 @@ int imsm_reshape_super(struct supertype *st, long long size, int level,
 		dprintf("imsm: imsm_reshape_super(): raid_disks not changed for volume reshape. Reshape allowed.\n");
 
 		if (find_array_minor(geo.dev_name, 1, st->devnum, &geo.dev_id) > -1) {
-			u = imsm_create_metadata_update_for_reshape(st, &geo);
+			struct supertype *st2 = NULL;
+			struct supertype *st_tmp = st;
+			if (st->sb == NULL) {
+				st2 = super_by_fd(fdc, NULL);
+				st->ss->load_super(st2, fdc, NULL);
+				if (st2)
+					st_tmp = st2;
+			}
+
+			u = imsm_create_metadata_update_for_reshape(st_tmp, &geo);
 			if (u) {
 				if (geo.raid_disks > raid_disks)
 					u->reshape_raid_disks = geo.raid_disks;
@@ -6859,6 +6887,8 @@ int imsm_reshape_super(struct supertype *st, long long size, int level,
 				ret_val = 0;
 				append_metadata_update(st, u, u->update_memory_size);
 			}
+			if (st2)
+				st->ss->free_super(st2);
 		}
 		goto imsm_reshape_super_exit;
 	} else {
@@ -6878,6 +6908,8 @@ imsm_reshape_super_exit:
 	sysfs_free(sra);
 	if (fd >= 0)
 		close(fd);
+	if (fdc >= 0)
+		close(fdc);
 
 	dprintf("imsm: reshape_super Exit code = %i\n", ret_val);
 
@@ -7704,6 +7736,8 @@ int imsm_manage_container_reshape(struct supertype *st, char *backup)
 					 */
 					dprintf("imsm: Preparing metadata update for: %s (md%i)\n", array, geo.dev_id);
 					st->update_tail = &st->updates;
+					geo.size = UnSet;
+					geo.level = UnSet;
 					u = imsm_create_metadata_update_for_reshape(st, &geo);
 					if (u) {
 						u->reshape_delta_disks = delta_disks;

