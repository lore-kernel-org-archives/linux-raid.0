From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 02/14] imsm: FIX: Add volume size expand support to imsm_analyze_change()
Date: Fri, 13 Apr 2012 16:51:56 +0200
Message-ID: <1334328728-12544-3-git-send-email-adam.kwolek@intel.com>
References: <1334328728-12544-1-git-send-email-adam.kwolek@intel.com>
 <1334328728-12544-2-git-send-email-adam.kwolek@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1334328728-12544-2-git-send-email-adam.kwolek@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, grzegorz.grabowski@intel.com, maciej.patelczyk@intel.com, anna.czarnowska@intel.com, Adam Kwolek <adam.kwolek@intel.com>
List-Id: linux-raid.ids

Patch adds ability to function imsm_analyze_change() for:
1. Detect size change request for volume operation.
2. Check and correct size for change.
3. Set new change kind to CH_ARRAY_SIZE

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---
 super-intel.c |   51 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 51 insertions(+), 0 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 3aabcc0..b657249 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -405,6 +405,7 @@ struct extent {
 enum imsm_reshape_type {
 	CH_TAKEOVER,
 	CH_MIGRATION,
+	CH_ARRAY_SIZE,
 };
 
 /* definition of messages passed to imsm_process_update */
@@ -9728,6 +9729,10 @@ enum imsm_reshape_type imsm_analyze_change(struct supertype *st,
 	int devNumChange = 0;
 	/* imsm compatible layout value for array geometry verification */
 	int imsm_layout = -1;
+	int data_disks;
+	struct imsm_dev *dev;
+	struct intel_super *super;
+	long long current_size;
 
 	getinfo_super_imsm_volume(st, &info, NULL);
 	if ((geo->level != info.array.level) &&
@@ -9809,6 +9814,47 @@ enum imsm_reshape_type imsm_analyze_change(struct supertype *st,
 		geo->chunksize = info.array.chunk_size;
 
 	chunk = geo->chunksize / 1024;
+
+	super = st->sb;
+	dev = get_imsm_dev(super, super->current_vol);
+	data_disks = imsm_num_data_members(dev , MAP_0);
+	/* compute current size in K per disk member
+	 */
+	current_size = info.custom_array_size / 2 / data_disks;
+
+	if ((current_size != geo->size) && (geo->size > 0)) {
+		if (change != -1) {
+			fprintf(stderr,
+				Name " Error. Size change should be the only "
+				"one at a time.\n");
+			change = -1;
+			goto analyse_change_exit;
+		}
+		if ((super->current_vol + 1) != super->anchor->num_raid_devs) {
+			fprintf(stderr,
+				Name " Error. The last volume in container "
+				"can be expanded only (%i/%i).\n",
+				super->current_vol, st->devnum);
+			goto analyse_change_exit;
+		}
+		geo->size *= 2;
+		/* round size due to metadata compatibility
+		 */
+		geo->size = (geo->size >> SECT_PER_MB_SHIFT)
+			    << SECT_PER_MB_SHIFT;
+		dprintf("Prepare update for size change to %llu\n", geo->size );
+		if (current_size >= geo->size) {
+			fprintf(stderr,
+				Name " Error. Size expanssion is supported only"
+				" (current size is %llu, requested size "
+				"/rounded/ is %llu).\n",
+				current_size, geo->size);
+			goto analyse_change_exit;
+		}
+		geo->size *= data_disks;
+		geo->raid_disks = dev->vol.map->num_members;
+		change = CH_ARRAY_SIZE;
+	}
 	if (!validate_geometry_imsm(st,
 				    geo->level,
 				    imsm_layout,
@@ -9978,6 +10024,11 @@ static int imsm_reshape_super(struct supertype *st, long long size, int level,
 				free(u);
 		}
 		break;
+		case CH_ARRAY_SIZE: {
+			/* ToDo: Prepare metadata update here
+			 */
+		}
+		break;
 		default:
 			ret_val = 1;
 		}
-- 
1.6.4.2

