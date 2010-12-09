From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 20/29] Migration raid0->raid5
Date: Thu, 09 Dec 2010 16:21:27 +0100
Message-ID: <20101209152127.26876.27378.stgit@gklab-170-024.igk.intel.com>
References: <20101209150352.26876.33974.stgit@gklab-170-024.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101209150352.26876.33974.stgit@gklab-170-024.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

Add implementation for migration from raid0 to raid5 in one step.
For imsm raid level parameters flow from mdadm (vi metadata update) to managemon was added.

Block takeover for this migration case (update_reshape is used only)
For migration on container (OLCE) reinitialize variables that are changed
by single array reshape case.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |   35 ++++++++++++++++++++++++++++++-----
 1 files changed, 30 insertions(+), 5 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 0d4bb07..564869e 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -5002,7 +5002,7 @@ static void imsm_sync_metadata(struct supertype *container)
 {
 	struct intel_super *super = container->sb;
 
-	if (!super->updates_pending)
+	if (!super || !super->updates_pending)
 		return;
 
 	write_super_imsm(container, 0);
@@ -6605,6 +6605,14 @@ struct imsm_update_reshape *imsm_create_metadata_update_for_reshape(
 	dprintf("imsm_update_metadata_for_reshape(enter) raid_disks = %i\n",
 		geo->raid_disks);
 
+	if (super == NULL || super->anchor == NULL) {
+		dprintf("Error: imsm_create_metadata_update_for_reshape(): "\
+			"null pointers on input\n");
+		dprintf("\t\t super = %p\n", super);
+		if (super)
+			dprintf("\t\t super->anchor = %p\n", super->anchor);
+		return ret_val;
+	}
 	if ((geo->raid_disks < super->anchor->num_disks) ||
 	    (geo->raid_disks == UnSet))
 		geo->raid_disks = super->anchor->num_disks;
@@ -6693,8 +6701,12 @@ struct imsm_update_reshape *imsm_create_metadata_update_for_reshape(
 								     idx);
 				}
 				u->devnum = geo->dev_id;
-				/* case for reshape without grow */
-				if (u->reshape_delta_disks == 0) {
+				/* case for reshape without grow
+				 * or grow is level change effect
+				 */
+				if ((u->reshape_delta_disks == 0) ||
+				    ((new_map->raid_level != geo->level) &&
+				     (geo->level != UnSet))) {
 					dprintf("imsm: reshape prepare "\
 						"metadata for volume= %d, "\
 						"index= %d\n",
@@ -6881,6 +6893,7 @@ int imsm_reshape_super(struct supertype *st, long long size, int level,
 	int ret_val = 1;
 	struct mdinfo *sra = NULL;
 	int fd = -1;
+	int fdc = -1;
 	char buf[PATH_MAX];
 	int delta_disks = -1;
 	struct geo_params geo;
@@ -6945,9 +6958,15 @@ int imsm_reshape_super(struct supertype *st, long long size, int level,
 	} else
 		dprintf("imsm: not a container operation\n");
 
+	fdc = open_dev(st->container_dev);
+	if (fdc < 0) {
+		dprintf("imsm: cannot open container: %s\n", buf);
+		goto imsm_reshape_super_exit;
+	}
+
 	fd = open_dev(st->devnum);
 	if (fd < 0) {
-		dprintf("imsm: cannot open device: %s\n", buf);
+		dprintf("imsm: cannot open device: %s\n", geo.dev_name);
 		goto imsm_reshape_super_exit;
 	}
 
@@ -6964,8 +6983,10 @@ int imsm_reshape_super(struct supertype *st, long long size, int level,
 	 */
 	if (geo.raid_disks > 0 && geo.raid_disks != UnSet)
 		delta_disks = geo.raid_disks - sra->array.raid_disks;
-	else
+	else {
 		delta_disks = 0;
+		geo.raid_disks = sra->array.raid_disks;
+	}
 	dprintf("imsm: imsm_reshape_super() for array, delta disks = %i\n",
 		delta_disks);
 	if (delta_disks == 0) {
@@ -7002,6 +7023,8 @@ imsm_reshape_super_exit:
 	sysfs_free(sra);
 	if (fd >= 0)
 		close(fd);
+	if (fdc >= 0)
+		close(fdc);
 
 	dprintf("imsm: reshape_super Exit code = %i\n", ret_val);
 
@@ -7867,6 +7890,8 @@ int imsm_manage_container_reshape(struct supertype *st, char *backup)
 						"update for subarray: %i "\
 						"(md%i)\n", array, geo.dev_id);
 					st->update_tail = &st->updates;
+					geo.size = UnSet;
+					geo.level = UnSet;
 					u = imsm_create_metadata_update_for_reshape(st, &geo);
 					if (u) {
 						u->reshape_delta_disks =

