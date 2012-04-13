From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 06/14] imsm: FIX: Support metadata changes rollback
Date: Fri, 13 Apr 2012 16:52:00 +0200
Message-ID: <1334328728-12544-7-git-send-email-adam.kwolek@intel.com>
References: <1334328728-12544-1-git-send-email-adam.kwolek@intel.com>
 <1334328728-12544-2-git-send-email-adam.kwolek@intel.com>
 <1334328728-12544-3-git-send-email-adam.kwolek@intel.com>
 <1334328728-12544-4-git-send-email-adam.kwolek@intel.com>
 <1334328728-12544-5-git-send-email-adam.kwolek@intel.com>
 <1334328728-12544-6-git-send-email-adam.kwolek@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1334328728-12544-6-git-send-email-adam.kwolek@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, grzegorz.grabowski@intel.com, maciej.patelczyk@intel.com, anna.czarnowska@intel.com, Adam Kwolek <adam.kwolek@intel.com>
List-Id: linux-raid.ids

Add metadata rollback specific code for imsm.
Let reshape_super() ability to differentiate metadata apply and rollback
actions.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---
 super-intel.c |   56 ++++++++++++++++++++++++++++++++++++++------------------
 1 files changed, 38 insertions(+), 18 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 62aeeb3..2a050fc 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -9472,7 +9472,8 @@ static int imsm_find_array_minor_by_subdev(int subdev, int container, int *minor
 
 static int imsm_reshape_is_allowed_on_container(struct supertype *st,
 						struct geo_params *geo,
-						int *old_raid_disks)
+						int *old_raid_disks,
+						int direction)
 {
 	/* currently we only support increasing the number of devices
 	 * for a container.  This increases the number of device for each
@@ -9496,6 +9497,12 @@ static int imsm_reshape_is_allowed_on_container(struct supertype *st,
 		return ret_val;
 	}
 
+	if (direction == ROLLBACK_METADATA_CHANGES) {
+		dprintf("imsm: Metadata changes rollback is not supported for "
+			"container operation.\n");
+		return ret_val;
+	}
+
 	info = container_content_imsm(st, NULL);
 	for (member = info; member; member = member->next) {
 		int result;
@@ -9816,11 +9823,13 @@ static void imsm_update_metadata_locally(struct supertype *st,
 * Function:	imsm_analyze_change
 * Description:	Function analyze change for single volume
 * 		and validate if transition is supported
-* Parameters:	Geometry parameters, supertype structure
+* Parameters:	Geometry parameters, supertype structure,
+*		metadata change direction (apply/rollback)
 * Returns:	Operation type code on success, -1 if fail
 ****************************************************************************/
 enum imsm_reshape_type imsm_analyze_change(struct supertype *st,
-					   struct geo_params *geo)
+					   struct geo_params *geo,
+					   int direction)
 {
 	struct mdinfo info;
 	int change = -1;
@@ -9939,18 +9948,24 @@ enum imsm_reshape_type imsm_analyze_change(struct supertype *st,
 			goto analyse_change_exit;
 		}
 		geo->size *= 2;
-		/* round size due to metadata compatibility
-		 */
-		geo->size = (geo->size >> SECT_PER_MB_SHIFT)
-			    << SECT_PER_MB_SHIFT;
-		dprintf("Prepare update for size change to %llu\n", geo->size );
-		if (current_size >= geo->size) {
-			fprintf(stderr,
-				Name " Error. Size expanssion is supported only"
-				" (current size is %llu, requested size "
-				"/rounded/ is %llu).\n",
-				current_size, geo->size);
-			goto analyse_change_exit;
+		if ((direction == ROLLBACK_METADATA_CHANGES)) {
+			/* accept size for rollback only
+			*/
+		} else {
+			/* round size due to metadata compatibility
+			*/
+			geo->size = (geo->size >> SECT_PER_MB_SHIFT)
+				    << SECT_PER_MB_SHIFT;
+			dprintf("Prepare update for size change to %llu\n",
+				geo->size );
+			if (current_size >= geo->size) {
+				fprintf(stderr,
+					Name " Error. Size expanssion is "
+					"supported only (current size is %llu, "
+					"requested size /rounded/ is %llu).\n",
+					current_size, geo->size);
+				goto analyse_change_exit;
+			}
 		}
 		geo->size *= data_disks;
 		geo->raid_disks = dev->vol.map->num_members;
@@ -9980,7 +9995,12 @@ enum imsm_reshape_type imsm_analyze_change(struct supertype *st,
 	}
 
 analyse_change_exit:
-
+	if ((direction == ROLLBACK_METADATA_CHANGES) &&
+	     ((change == CH_MIGRATION) || (change == CH_TAKEOVER))) {
+		dprintf("imsm: Metadata changes rollback is not supported for "
+			"migration and takeover operations.\n");
+		change = -1;
+	}
 	return change;
 }
 
@@ -10051,7 +10071,7 @@ static int imsm_reshape_super(struct supertype *st, long long size, int level,
 		int old_raid_disks = 0;
 
 		if (imsm_reshape_is_allowed_on_container(
-			    st, &geo, &old_raid_disks)) {
+			    st, &geo, &old_raid_disks, direction)) {
 			struct imsm_update_reshape *u = NULL;
 			int len;
 
@@ -10100,7 +10120,7 @@ static int imsm_reshape_super(struct supertype *st, long long size, int level,
 			goto exit_imsm_reshape_super;
 		}
 		super->current_vol = dev->index;
-		change = imsm_analyze_change(st, &geo);
+		change = imsm_analyze_change(st, &geo, direction);
 		switch (change) {
 		case CH_TAKEOVER:
 			ret_val = imsm_takeover(st, &geo);
-- 
1.6.4.2

