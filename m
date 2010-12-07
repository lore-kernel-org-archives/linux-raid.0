From: "Labun, Marcin" <Marcin.Labun@intel.com>
Subject: [PATCH 2/2] IMSM: do not rebuild the array if a non-redundant
 sub-array with failed disks is present
Date: Tue, 7 Dec 2010 16:10:48 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D17676E3C3@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Czarnowska, Anna" <anna.czarnowska@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>
List-Id: linux-raid.ids

From ee52735e3576dc998a837229ac5b9fb3ed1faeaf Mon Sep 17 00:00:00 2001
From: Marcin Labun <marcin.labun@intel.com>
Date: Wed, 30 Nov 2010 15:47:19 +0100
Subject: [PATCH 2/2] IMSM: do not rebuild the array if a non-redundant sub-array with failed disks is present

Now Intel metadata handler rebuilds all sub-arrays even if one of them
is non-redundant. In case of failed sub-array, failed disks are just replaced
with new ones in the metadata mapping. The data for failed disk is not restored
even the disk is present in the system. This fix requests to remove the failed
disk from container to let the process of rebuilding the array with failed
member. If the disk is physically pulled out of the system, the disk is removed
from container automatically by exiting udev rules.

Signed-off-by: Marcin Labun <marcin.labun@intel.com>
---
 super-intel.c |   76 ++++++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 72 insertions(+), 4 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 1cee6c1..0703af2 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -364,15 +364,28 @@ static struct imsm_disk *__get_imsm_disk(struct imsm_super *mpb, __u8 index)
 	return &mpb->disk[index];
 }
 
-/* retrieve a disk from the parsed metadata */
-static struct imsm_disk *get_imsm_disk(struct intel_super *super, __u8 index)
+/* retrieve the disk description based on a index of the disk
+ * in the sub-array 
+ */
+static struct dl *get_imsm_dl_disk(struct intel_super *super, __u8 index)
 {
 	struct dl *d;
 
 	for (d = super->disks; d; d = d->next)
 		if (d->index == index)
-			return &d->disk;
-	
+			return d;
+
+	return NULL;
+}
+/* retrieve a disk from the parsed metadata */
+static struct imsm_disk *get_imsm_disk(struct intel_super *super, __u8 index)
+{
+	struct dl *dl;
+
+	dl = get_imsm_dl_disk(super, index);
+	if (dl)
+		return &dl->disk;
+
 	return NULL;
 }
 
@@ -5042,6 +5055,45 @@ static struct dl *imsm_add_spare(struct intel_super *super, int slot,
 	return dl;
 }
 
+
+static int imsm_rebuild_allowed(struct active_array *a, int dev_idx, int failed)
+{
+	struct imsm_dev *dev2;
+	struct imsm_map *map;
+	struct dl *idisk;
+	int slot;
+	int idx;
+	__u8 state;
+
+	dev2 = get_imsm_dev(a->container->sb, dev_idx);
+	if (dev2) {
+		state = imsm_check_degraded(a->container->sb, dev2, failed);
+		if (state == IMSM_T_STATE_FAILED) {
+			map = get_imsm_map(dev2, 0);
+			if (!map)
+				return 1;
+			for (slot = 0; slot < map->num_members; slot++) {
+				/* 
+				 * Check if failed disks are deleted from intel
+				 * disk list or are marked to be deleted
+				 */
+				idx = get_imsm_disk_idx(dev2, slot);
+				idisk = get_imsm_dl_disk(a->container->sb, idx);
+				/* 
+				 * Do not rebuild the array if failed disks
+				 * from failed sub-array are not removed from
+				 * container.
+				 */
+				if (idisk &&
+				    is_failed(&idisk->disk) &&
+				    (idisk->action != DISK_REMOVE))
+					return 0;
+			}
+		}
+	}
+	return 1;
+}
+
 static struct mdinfo *imsm_activate_spare(struct active_array *a,
 					  struct metadata_update **updates)
 {
@@ -5069,6 +5121,7 @@ static struct mdinfo *imsm_activate_spare(struct active_array *a,
 	struct imsm_update_activate_spare *u;
 	int num_spares = 0;
 	int i;
+	int allowed;
 
 	for (d = a->info.devs ; d ; d = d->next) {
 		if ((d->curr_state & DS_FAULTY) &&
@@ -5084,6 +5137,21 @@ static struct mdinfo *imsm_activate_spare(struct active_array *a,
 	if (imsm_check_degraded(super, dev, failed) != IMSM_T_STATE_DEGRADED)
 		return NULL;
 
+	/* 
+	 * If there are any failed disks check state of the other volume. 
+	 * Block rebuild if the other one is failed until failed disks
+	 * are removed from container.
+	 */
+	if (failed) {
+		dprintf("found failed disks in %s, check if there is another"
+			"sub-array\n",
+			dev->volume);
+		/* check the state of the other volume allows for rebuild */
+		allowed = imsm_rebuild_allowed(a, (inst == 0) ? 1 : 0, failed);
+		if (!allowed) 
+			return NULL;
+	}
+	    
 	/* For each slot, if it is not working, find a spare */
 	for (i = 0; i < a->info.array.raid_disks; i++) {
 		for (d = a->info.devs ; d ; d = d->next)
-- 
1.6.4.2
