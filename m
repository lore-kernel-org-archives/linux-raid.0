From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 20/21] Migration raid0->raid5
Date: Tue, 23 Nov 2010 13:42:20 +0100
Message-ID: <20101123124220.17770.7527.stgit@gklab-170-024.igk.intel.com>
References: <20101123123900.17770.75516.stgit@gklab-170-024.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101123123900.17770.75516.stgit@gklab-170-024.igk.intel.com>
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

 mdadm/mdadm/super-intel.c |   53 +++++++++++++++++++++++++++++++++++++++++----
 1 files changed, 48 insertions(+), 5 deletions(-)

diff --git a/mdadm/mdadm/super-intel.c b/mdadm/mdadm/super-intel.c
index f874f2f..0b553bc 100644
--- a/mdadm/mdadm/super-intel.c
+++ b/mdadm/mdadm/super-intel.c
@@ -5335,7 +5335,7 @@ static void imsm_sync_metadata(struct supertype *container)
 {
 	struct intel_super *super = container->sb;
 
-	if (!super->updates_pending)
+	if (!super || !super->updates_pending)
 		return;
 
 	write_super_imsm(container, 0);
@@ -7193,6 +7193,13 @@ struct imsm_update_reshape *imsm_create_metadata_update_for_reshape(struct super
 
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
@@ -7271,8 +7278,11 @@ struct imsm_update_reshape *imsm_create_metadata_update_for_reshape(struct super
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
@@ -7534,6 +7544,13 @@ int imsm_reshape_super(struct supertype *st, long long size, int level,
 		int dn;
 		int err;
 
+		/* takeover raid0->raid5 doesn't need meta update
+		 * this can be handled by migrations if necessary
+		 */
+		if ((geo.level == 5) && (sra->array.level == 5)) {
+			ret_val = 0;
+			goto imsm_reshape_super_exit;
+		}
 		dn = devname2devnum(sra->text_version + 1);
 		container_fd = open_dev_excl(dn);
 		if (container_fd < 0) {
@@ -7570,8 +7587,10 @@ int imsm_reshape_super(struct supertype *st, long long size, int level,
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
@@ -7579,7 +7598,26 @@ int imsm_reshape_super(struct supertype *st, long long size, int level,
 		dprintf("imsm: imsm_reshape_super(): raid_disks not changed for volume reshape. Reshape allowed.\n");
 
 		if (find_array_minor(geo.dev_name, 1, st->devnum, &geo.dev_id) > -1) {
-			u = imsm_create_metadata_update_for_reshape(st, &geo);
+			struct supertype *st2 = NULL;
+			struct supertype *st_tmp = st;
+			if (st->sb == NULL) {
+				close(fd);
+				/* open container
+				 */
+				snprintf(buf, PATH_MAX, "/dev/md%i", st->container_dev);
+				dprintf("imsm: open device %s\n", buf);
+				fd = open(buf , O_RDWR | O_DIRECT);
+				if (fd < 0) {
+					dprintf("imsm: cannot open device %s\n", buf);
+					goto imsm_reshape_super_exit;
+				}
+				st2 = super_by_fd(fd);
+				st->ss->load_super(st2, fd, NULL);
+				if (st2)
+					st_tmp = st2;
+			}
+
+			u = imsm_create_metadata_update_for_reshape(st_tmp, &geo);
 			if (u) {
 				if (geo.raid_disks > raid_disks)
 					u->reshape_raid_disks = geo.raid_disks;
@@ -7587,7 +7625,10 @@ int imsm_reshape_super(struct supertype *st, long long size, int level,
 				u->reshape_layout = geo.layout;
 				ret_val = 0;
 				append_metadata_update(st, u, u->update_memory_size);
+
 			}
+			if (st2)
+				st->ss->free_super(st2);
 		}
 		goto imsm_reshape_super_exit;
 	} else {
@@ -8396,6 +8437,8 @@ int imsm_manage_container_reshape(struct supertype *st)
 					 */
 					dprintf("imsm: Preparing metadata update for: %s (md%i)\n", array, geo.dev_id);
 					st->update_tail = &st->updates;
+					geo.size = UnSet;
+					geo.level = UnSet;
 					u = imsm_create_metadata_update_for_reshape(st, &geo);
 					if (u) {
 						u->reshape_delta_disks = delta_disks;

