From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 09/11] imsm: FIX: Check maximum allowed degradation level in
	open_backup_targets()
Date: Thu, 24 Nov 2011 13:18:21 +0100
Message-ID: <20111124121821.5254.95759.stgit@gklab-128-013.igk.intel.com>
References: <20111124121516.5254.48774.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111124121516.5254.48774.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

Any degradation during opening any backup device can causes error
and array assembly failure.

Allow for degradation during opening backup devices.
This allows for degraded array assembly.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |   97 +++++++++++++++++++++++++++++++++++++++++++++++++++++----
 1 files changed, 90 insertions(+), 7 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 3e7cfb4..e2b3c05 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -8020,6 +8020,75 @@ static void imsm_delete(struct intel_super *super, struct dl **dlp, unsigned ind
 	}
 }
 #endif /* MDASSEMBLE */
+
+static void close_targets(int *targets, int new_disks)
+{
+	int i;
+
+	if (!targets)
+		return;
+
+	for (i = 0; i < new_disks; i++) {
+		if (targets[i] >= 0) {
+			close(targets[i]);
+			targets[i] = -1;
+		}
+	}
+}
+
+static int imsm_get_allowed_degradation(int level, int raid_disks,
+					struct intel_super *super,
+					struct imsm_dev *dev)
+{
+	switch (level) {
+	case 10:{
+		int ret_val = 0;
+		struct imsm_map *map;
+		int i;
+
+		ret_val = raid_disks/2;
+		/* check map if all disks pairs not failed
+		 * in both maps
+		 */
+		map = get_imsm_map(dev, 0);
+		for (i = 0; i < ret_val; i++) {
+			int degradation = 0;
+			if (get_imsm_disk(super, i) == NULL)
+				degradation++;
+			if (get_imsm_disk(super, i + 1) == NULL)
+				degradation++;
+			if (degradation == 2)
+				return 0;
+		}
+		map = get_imsm_map(dev, 1);
+		/* if there is no second map
+		 * result can be returned
+		 */
+		if (map == NULL)
+			return ret_val;
+		/* check degradation in second map
+		 */
+		for (i = 0; i < ret_val; i++) {
+			int degradation = 0;
+		if (get_imsm_disk(super, i) == NULL)
+				degradation++;
+			if (get_imsm_disk(super, i + 1) == NULL)
+				degradation++;
+			if (degradation == 2)
+				return 0;
+		}
+		return ret_val;
+	}
+	case 5:
+		return 1;
+	case 6:
+		return 2;
+	default:
+		return 0;
+	}
+}
+
+
 /*******************************************************************************
  * Function:	open_backup_targets
  * Description:	Function opens file descriptors for all devices given in
@@ -8028,14 +8097,18 @@ static void imsm_delete(struct intel_super *super, struct dl **dlp, unsigned ind
  *	info		: general array info
  *	raid_disks	: number of disks
  *	raid_fds	: table of device's file descriptors
+ *	super		: intel super for raid10 degradation check
+ *	dev		: intel device for raid10 degradation check
  * Returns:
  *	 0 : success
  *	-1 : fail
  ******************************************************************************/
-int open_backup_targets(struct mdinfo *info, int raid_disks, int *raid_fds)
+int open_backup_targets(struct mdinfo *info, int raid_disks, int *raid_fds,
+			struct intel_super *super, struct imsm_dev *dev)
 {
 	struct mdinfo *sd;
 	int i;
+	int opened = 0;
 
 	for (i = 0; i < raid_disks; i++)
 		raid_fds[i] = -1;
@@ -8057,8 +8130,19 @@ int open_backup_targets(struct mdinfo *info, int raid_disks, int *raid_fds)
 		raid_fds[sd->disk.raid_disk] = dev_open(dn, O_RDWR);
 		if (raid_fds[sd->disk.raid_disk] < 0) {
 			fprintf(stderr, "cannot open component\n");
-			return -1;
+			continue;
 		}
+		opened++;
+	}
+	/* check if maximum array degradation level is not exceeded
+	*/
+	if ((raid_disks - opened) >
+			imsm_get_allowed_degradation(info->new_level,
+						     raid_disks,
+						     super, dev)) {
+		fprintf(stderr, "Not enough disks can be opened.\n");
+		close_targets(raid_fds, raid_disks);
+		return -2;
 	}
 	return 0;
 }
@@ -8191,7 +8275,8 @@ int save_backup_imsm(struct supertype *st,
 		target_offsets[i] -= start/data_disks;
 	}
 
-	if (open_backup_targets(info, new_disks, targets))
+	if (open_backup_targets(info, new_disks, targets,
+				super, dev))
 		goto abort;
 
 	dest_layout = imsm_level_to_layout(map_dest->raid_level);
@@ -8217,9 +8302,7 @@ int save_backup_imsm(struct supertype *st,
 
 abort:
 	if (targets) {
-		for (i = 0; i < new_disks; i++)
-			if (targets[i] >= 0)
-				close(targets[i]);
+		close_targets(targets, new_disks);
 		free(targets);
 	}
 	free(target_offsets);
@@ -8348,7 +8431,7 @@ int recover_backup_imsm(struct supertype *st, struct mdinfo *info)
 	if (!targets)
 		goto abort;
 
-	if (open_backup_targets(info, new_disks, targets)) {
+	if (open_backup_targets(info, new_disks, targets, super, id->dev)) {
 		fprintf(stderr,
 			Name ": Cannot open devices belongs to array.\n");
 		goto abort;

