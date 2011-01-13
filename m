From: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Subject: [PATCH 1/6] Define imsm_analyze_change function
Date: Thu, 13 Jan 2011 16:32:27 +0100
Message-ID: <20110113153227.20266.42368.stgit@gklab-128-111.igk.intel.com>
References: <20110113152722.20266.24174.stgit@gklab-128-111.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110113152722.20266.24174.stgit@gklab-128-111.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, adam.kwolek@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

Function intended to use for single volume migration.
Function analyze transition and validate if it is supported.

Signed-off-by: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
---
 super-intel.c |  135 ++++++++++++++++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 124 insertions(+), 11 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 4cbb070..c12ba74 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -6576,16 +6576,110 @@ static void imsm_update_metadata_locally(struct supertype *st,
 	}
 }
 
-/*******************************************************************************
+/***************************************************************************
 * Function:	imsm_analyze_change
-* Description:	Function analyze and validate change for single volume migration
+* Description:	Function analyze change for single volume
+* 		and validate if transition is supported
 * Parameters:	Geometry parameters, supertype structure
 * Returns:	Operation type code on success, -1 if fail
-********************************************************************************/
-enum imsm_reshape_type imsm_analyze_change(
-	struct supertype *st, struct geo_params *geo)
+****************************************************************************/
+enum imsm_reshape_type imsm_analyze_change(struct supertype *st,
+						struct geo_params *geo)
 {
-	return -1;
+	struct mdinfo info;
+	int change = -1;
+	int check_devs = 0;
+
+	getinfo_super_imsm_volume(st, &info, NULL);
+
+	if ((geo->level != info.array.level) &&
+		(geo->level >= 0) &&
+		(geo->level != UnSet)) {
+		switch (info.array.level) {
+		case 0:
+			if (geo->level == 5) {
+				change = CH_LEVEL_MIGRATION;
+				check_devs = 1;
+			}
+			if (geo->level == 10) {
+				change = CH_TAKEOVER;
+				check_devs = 1;
+			}
+			break;
+		case 5:
+			if (geo->level != 0)
+				change = CH_LEVEL_MIGRATION;
+			break;
+		case 10:
+			if (geo->level == 0) {
+				change = CH_TAKEOVER;
+				check_devs = 1;
+			}
+			break;
+		}
+		if (change == -1) {
+			fprintf(stderr, Name " Error. Level Migration from %d to %d "\
+				"not supported!\n", info.array.level, geo->level);
+			goto analyse_change_exit;
+		}
+	} else {
+		geo->level = info.array.level;
+	}
+
+	if ((geo->layout != info.array.layout)
+		&& ((geo->layout != UnSet) && (geo->layout != -1))) {
+		change = CH_LEVEL_MIGRATION;
+		if ((info.array.layout == 0) && (info.array.level == 5)
+			&& (geo->layout == 5)) {
+			/* reshape 5 -> 4 */
+		} else if ((info.array.layout == 5)
+				&& (info.array.level == 5)
+				&& (geo->layout == 0)) {
+			/* reshape 4 -> 5 */
+			geo->layout = 0;
+			geo->level = 5;
+		} else {
+			fprintf(stderr, Name " Error. Layout Migration from %d to %d "\
+				"not supported!\n", info.array.layout, geo->layout);
+			change = -1;
+			goto analyse_change_exit;
+		}
+	} else {
+		geo->layout = info.array.layout;
+	}
+
+	if ((geo->chunksize > 0) && (geo->chunksize != UnSet)
+		&& (geo->chunksize != info.array.chunk_size)) {
+		change = CH_CHUNK_MIGR;
+	} else {
+		geo->chunksize = info.array.chunk_size;
+	}
+
+	if (!validate_geometry_imsm(st,
+					geo->level,
+					geo->layout,
+					geo->raid_disks,
+					(geo->chunksize / 1024),
+					geo->size,
+					0, 0, 1))
+		change = -1;
+
+	if (check_devs) {
+		struct intel_super *super = st->sb;
+		struct imsm_super *mpb = super->anchor;
+
+		if (mpb->num_raid_devs > 1) {
+			fprintf(stderr, Name " Error. Cannot perform operation on %s"\
+				"- for this operation it MUST be single "\
+			       "array in container\n",
+				geo->dev_name);
+			change = -1;
+		}
+	}
+
+analyse_change_exit:
+
+	return change;
 }
 
 static int imsm_reshape_super(struct supertype *st, long long size, int level,
@@ -6649,18 +6743,37 @@ static int imsm_reshape_super(struct supertype *st, long long size, int level,
 		* - chunk size migration
 		* - migration: raid5 -> raid0; raid0 -> raid5
 		*/
-		int change;
+		struct intel_super *super = st->sb;
+		struct intel_dev *dev = super->devlist;
+		int change, devnum;
 		dprintf("imsm: info: Volume operation\n");
+		/* find requested device */
+		while (dev) {
+			imsm_find_array_minor_by_subdev(dev->index, st->container_dev, &devnum);
+			if (devnum == geo.dev_id)
+				break;
+			dev = dev->next;
+		}
+		if (dev == NULL) {
+			fprintf(stderr, Name " Cannot find %s (%i) subarray\n",
+					geo.dev_name, geo.dev_id);
+				goto exit_imsm_reshape_super;
+		}
+		super->current_vol = dev->index;
 		change = imsm_analyze_change(st, &geo);
 		switch (change) {
 			case CH_TAKEOVER:
-			break;
+				ret_val = 0;
+				break;
 			case CH_CHUNK_MIGR:
-			break;
+				ret_val = 0;
+				break;
 			case CH_LEVEL_MIGRATION:
-			break;
+				ret_val = 0;
+				break;
+			default:
+				ret_val = 1;
 		}
-		ret_val = 0;
 	}
 
 exit_imsm_reshape_super:

