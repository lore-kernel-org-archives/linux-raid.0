From: mwilck@arcor.de
Subject: [PATCH 08/27] DDF: ddf_set_disk: move status logic to separate function
Date: Wed,  3 Jul 2013 22:27:48 +0200
Message-ID: <1372883287-8859-9-git-send-email-mwilck@arcor.de>
References: <1372883287-8859-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1372883287-8859-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

Moved code to determine RAID status to a separate function
get_bvd_status(). I need this to account for secondary RAID level.

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 super-ddf.c |   94 +++++++++++++++++++++++++++++++++-------------------------
 1 files changed, 53 insertions(+), 41 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index c448bff..322ad5e 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -1515,7 +1515,7 @@ bad:
 }
 #endif
 
-static int find_phys(struct ddf_super *ddf, __u32 phys_refnum)
+static int find_phys(const struct ddf_super *ddf, __u32 phys_refnum)
 {
 	/* Find the entry in phys_disk which has the given refnum
 	 * and return it's index
@@ -3812,9 +3812,55 @@ static int ddf_set_array_state(struct active_array *a, int consistent)
 	return consistent;
 }
 
-#define container_of(ptr, type, member) ({                      \
-	const typeof( ((type *)0)->member ) *__mptr = (ptr); \
-	(type *)( (char *)__mptr - offsetof(type,member) );})
+static int get_bvd_state(const struct ddf_super *ddf,
+			 const struct vd_config *vc)
+{
+	unsigned int i, n_bvd, working = 0;
+	unsigned int n_prim = __be16_to_cpu(vc->prim_elmnt_count);
+	int pd, st, state;
+	for (i = 0; i < n_prim; i++) {
+		if (!find_index_in_bvd(ddf, vc, i, &n_bvd))
+			continue;
+		pd = find_phys(ddf, vc->phys_refnum[n_bvd]);
+		if (pd < 0)
+			continue;
+		st = __be16_to_cpu(ddf->phys->entries[pd].state);
+		if ((st & (DDF_Online|DDF_Failed|DDF_Rebuilding))
+		    == DDF_Online)
+			working++;
+	}
+
+	state = DDF_state_degraded;
+	if (working == n_prim)
+		state = DDF_state_optimal;
+	else
+		switch (vc->prl) {
+		case DDF_RAID0:
+		case DDF_CONCAT:
+		case DDF_JBOD:
+			state = DDF_state_failed;
+			break;
+		case DDF_RAID1:
+			if (working == 0)
+				state = DDF_state_failed;
+			else if (working >= 2)
+				state = DDF_state_part_optimal;
+			break;
+		case DDF_RAID4:
+		case DDF_RAID5:
+			if (working < n_prim - 1)
+				state = DDF_state_failed;
+			break;
+		case DDF_RAID6:
+			if (working < n_prim - 2)
+				state = DDF_state_failed;
+			else if (working == n_prim - 1)
+				state = DDF_state_part_optimal;
+			break;
+		}
+	return state;
+}
+
 /*
  * The state of each disk is stored in the global phys_disk structure
  * in phys_disk.entries[n].state.
@@ -3837,7 +3883,6 @@ static void ddf_set_disk(struct active_array *a, int n, int state)
 	struct vd_config *vc = find_vdcr(ddf, inst, (unsigned int)n,
 					 &n_bvd, &vcl);
 	int pd;
-	int i, st, working;
 	struct mdinfo *mdi;
 	struct dl *dl;
 
@@ -3901,43 +3946,10 @@ static void ddf_set_disk(struct active_array *a, int n, int state)
 	 * It needs to be one of "optimal", "degraded", "failed".
 	 * I don't understand 'deleted' or 'missing'.
 	 */
-	working = 0;
-	for (i=0; i < a->info.array.raid_disks; i++) {
-		pd = find_phys(ddf, vc->phys_refnum[i]);
-		if (pd < 0)
-			continue;
-		st = __be16_to_cpu(ddf->phys->entries[pd].state);
-		if ((st & (DDF_Online|DDF_Failed|DDF_Rebuilding))
-		    == DDF_Online)
-			working++;
+	state = get_bvd_state(ddf, vc);
+	if (vc->sec_elmnt_count > 1) {
+		/* treat secondary level */
 	}
-	state = DDF_state_degraded;
-	if (working == a->info.array.raid_disks)
-		state = DDF_state_optimal;
-	else switch(vc->prl) {
-		case DDF_RAID0:
-		case DDF_CONCAT:
-		case DDF_JBOD:
-			state = DDF_state_failed;
-			break;
-		case DDF_RAID1:
-			if (working == 0)
-				state = DDF_state_failed;
-			else if (working == 2 && state == DDF_state_degraded)
-				state = DDF_state_part_optimal;
-			break;
-		case DDF_RAID4:
-		case DDF_RAID5:
-			if (working < a->info.array.raid_disks-1)
-				state = DDF_state_failed;
-			break;
-		case DDF_RAID6:
-			if (working < a->info.array.raid_disks-2)
-				state = DDF_state_failed;
-			else if (working == a->info.array.raid_disks-1)
-				state = DDF_state_part_optimal;
-			break;
-		}
 
 	if (ddf->virt->entries[inst].state !=
 	    ((ddf->virt->entries[inst].state & ~DDF_state_mask)
-- 
1.7.1
