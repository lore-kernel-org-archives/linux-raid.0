From: "Labun, Marcin" <Marcin.Labun@intel.com>
Subject: PATCH 2/2] IMSM: do not rebuild the array if a non-redundant
 sub-array with failed disks is present
Date: Mon, 13 Dec 2010 16:31:33 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D176AAED53@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

Hi Neil,
Reworked:
-support more than 2 sub-array number in a array.
Marcin


From e75aec5f5823d1beb86ec2c8347f0e5b3883b495 Mon Sep 17 00:00:00 2001
From: Marcin Labun <marcin.labun@intel.com>
Date: Mon, 13 Dec 2010 16:31:39 +0100
Subject: [PATCH 2/2] IMSM: do not rebuild the array if a non-redundant sub-array with failed disks is present

Before looking for a spare to rebuild a degraded array check if there
are any failed disks in container. Block rebuild if the another sub-array
is failed until failed disks are removed from container.
Now Intel metadata handler rebuilds all sub-arrays even if one of them
is non-redundant. In case of failed sub-array, failed disks are just replaced
with new ones in the metadata mapping. The data for failed disk is not restored
even the disk is present in the system. This fix requests to remove the failed
disk from container to start the process of rebuilding the array with failed
member. If the disk is physically pulled out of the system, the disk is removed
from container automatically by exiting udev rules.

Signed-off-by: Marcin Labun <marcin.labun@intel.com>
---
 super-intel.c |   81 ++++++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 77 insertions(+), 4 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index fe642ed..d0e1fc2 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -365,15 +365,28 @@ static struct imsm_disk *__get_imsm_disk(struct imsm_super *mpb, __u8 index)
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
 
@@ -5114,6 +5127,45 @@ static struct dl *imsm_add_spare(struct intel_super *super, int slot,
 	return dl;
 }
 
+
+static int imsm_rebuild_allowed(struct supertype *cont, int dev_idx, int failed)
+{
+	struct imsm_dev *dev2;
+	struct imsm_map *map;
+	struct dl *idisk;
+	int slot;
+	int idx;
+	__u8 state;
+
+	dev2 = get_imsm_dev(cont->sb, dev_idx);
+	if (dev2) {
+		state = imsm_check_degraded(cont->sb, dev2, failed);
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
+				idisk = get_imsm_dl_disk(cont->sb, idx);
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
@@ -5141,6 +5193,7 @@ static struct mdinfo *imsm_activate_spare(struct active_array *a,
 	struct imsm_update_activate_spare *u;
 	int num_spares = 0;
 	int i;
+	int allowed;
 
 	for (d = a->info.devs ; d ; d = d->next) {
 		if ((d->curr_state & DS_FAULTY) &&
@@ -5156,6 +5209,26 @@ static struct mdinfo *imsm_activate_spare(struct active_array *a,
 	if (imsm_check_degraded(super, dev, failed) != IMSM_T_STATE_DEGRADED)
 		return NULL;
 
+	/*
+	 * If there are any failed disks check state of the other volume.
+	 * Block rebuild if the another one is failed until failed disks
+	 * are removed from container.
+	 */
+	if (failed) {
+		dprintf("found failed disks in %s, check if there another"
+			"failed sub-array.\n",
+			dev->volume);
+		/* check if states of the other volumes allow for rebuild */
+		for (i = 0; i <  super->anchor->num_raid_devs; i++) {
+			if (i != inst) {
+				allowed = imsm_rebuild_allowed(a->container,
+							       i, failed);
+				if (!allowed)
+					return NULL;
+			}
+		}
+	}
+
 	/* For each slot, if it is not working, find a spare */
 	for (i = 0; i < a->info.array.raid_disks; i++) {
 		for (d = a->info.devs ; d ; d = d->next)
-- 
1.6.4.2

