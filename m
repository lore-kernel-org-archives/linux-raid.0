From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 08/34] imsm: FIX: Do not update anchor directly
Date: Tue, 04 Jan 2011 15:36:41 +0100
Message-ID: <20110104143641.6697.14030.stgit@gklab-128-013.igk.intel.com>
References: <20110104143240.6697.52355.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110104143240.6697.52355.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

During preparing metadata update local /mdadm/ anchor shouldn't be updated directly.
information should be get from metadata after update.
It makes us sure that metadata is on disk(s) already.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |   31 ++++++++-----------------------
 1 files changed, 8 insertions(+), 23 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 7c73b67..0a915c0 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -6329,13 +6329,13 @@ static int imsm_create_metadata_update_for_reshape(
 	int old_raid_disks,
 	struct imsm_update_reshape **updatep)
 {
-	struct intel_super *super = st->sb;
-	struct imsm_super *mpb = super->anchor;
 	int update_memory_size = 0;
 	struct imsm_update_reshape *u = NULL;
 	struct mdinfo *spares = NULL;
 	int i;
 	int delta_disks = 0;
+	struct mdinfo *dev;
+	int added_disks = 0;
 
 	dprintf("imsm_update_metadata_for_reshape(enter) raid_disks = %i\n",
 		geo->raid_disks);
@@ -6374,27 +6374,12 @@ static int imsm_create_metadata_update_for_reshape(
 	dprintf("imsm: %i spares are available.\n\n",
 		spares->array.spare_disks);
 
-	for (i = 0; i < delta_disks; i++) {
-		struct mdinfo *dev = spares->devs;
-		struct dl *dl;
-
+	dev = spares->devs;
+	for (i = 0; (i < delta_disks) && dev; i++) {
 		u->new_disks[i] = makedev(dev->disk.major,
 					  dev->disk.minor);
-		dl = get_disk_super(super, dev->disk.major, dev->disk.minor);
-		dl->index = mpb->num_disks++;
-	}
-	/* Now update the metadata so that container_content will find
-	 * the new devices
-	 */
-	for (i = 0; i < mpb->num_raid_devs; i++) {
-		int d;
-		struct imsm_dev *dev = get_imsm_dev(super, i);
-		struct imsm_map *map = get_imsm_map(dev, 0);
-		map->num_members = geo->raid_disks;
-		for (d = 0; d < delta_disks; d++) {
-			set_imsm_ord_tbl_ent(map, old_raid_disks + d,
-					     mpb->num_disks - delta_disks + d);
-		}
+		dev = dev->next;
+		added_disks++;
 	}
 
 abort:
@@ -6403,13 +6388,13 @@ abort:
 	sysfs_free(spares);
 
 	dprintf("imsm: reshape update preparation :");
-	if (i == delta_disks) {
+	if (added_disks == delta_disks) {
 		dprintf(" OK\n");
 		*updatep = u;
 		return update_memory_size;
 	}
 	free(u);
-	dprintf(" Error\n");
+	dprintf(" Error: added_disks = %i\n", added_disks);
 
 	return 0;
 }

