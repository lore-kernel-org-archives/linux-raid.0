From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 12/14] imsm: FIX: Component size alignment check
Date: Fri, 13 Apr 2012 16:52:06 +0200
Message-ID: <1334328728-12544-13-git-send-email-adam.kwolek@intel.com>
References: <1334328728-12544-1-git-send-email-adam.kwolek@intel.com>
 <1334328728-12544-2-git-send-email-adam.kwolek@intel.com>
 <1334328728-12544-3-git-send-email-adam.kwolek@intel.com>
 <1334328728-12544-4-git-send-email-adam.kwolek@intel.com>
 <1334328728-12544-5-git-send-email-adam.kwolek@intel.com>
 <1334328728-12544-6-git-send-email-adam.kwolek@intel.com>
 <1334328728-12544-7-git-send-email-adam.kwolek@intel.com>
 <1334328728-12544-8-git-send-email-adam.kwolek@intel.com>
 <1334328728-12544-9-git-send-email-adam.kwolek@intel.com>
 <1334328728-12544-10-git-send-email-adam.kwolek@intel.com>
 <1334328728-12544-11-git-send-email-adam.kwolek@intel.com>
 <1334328728-12544-12-git-send-email-adam.kwolek@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1334328728-12544-12-git-send-email-adam.kwolek@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, grzegorz.grabowski@intel.com, maciej.patelczyk@intel.com, anna.czarnowska@intel.com, Adam Kwolek <adam.kwolek@intel.com>
List-Id: linux-raid.ids

Put currently existing code for alignment correction in to function
imsm_component_size_aligment_check() and use it for align component size
to chunk size during volume size expansion operation.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---
 super-intel.c |   68 ++++++++++++++++++++++++++++++++++++++++----------------
 1 files changed, 48 insertions(+), 20 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index d9c293c..6d0e0c4 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -2454,6 +2454,32 @@ int imsm_reshape_blocks_arrays_changes(struct intel_super *super)
 	}
 	return rv;
 }
+static unsigned long long imsm_component_size_aligment_check(int level,
+					      int chunk_size,
+					      unsigned long long component_size)
+{
+	unsigned int component_size_alligment;
+
+	/* check component size aligment
+	*/
+	component_size_alligment = component_size % (chunk_size/512);
+
+	dprintf("imsm_component_size_aligment_check(Level: %i, "
+		"chunk_size = %i, component_size = %llu), "
+		"component_size_alligment = %u\n",
+		level, chunk_size, component_size,
+		component_size_alligment);
+
+	if (component_size_alligment && (level != 1) && (level != UnSet)) {
+		dprintf("imsm: reported component size alligned from %llu ",
+			component_size);
+		component_size -= component_size_alligment;
+		dprintf("to %llu (%i).\n",
+			component_size, component_size_alligment);
+	}
+
+	return component_size;
+}
 
 static void getinfo_super_imsm_volume(struct supertype *st, struct mdinfo *info, char *dmap)
 {
@@ -2465,7 +2491,6 @@ static void getinfo_super_imsm_volume(struct supertype *st, struct mdinfo *info,
 	struct imsm_map *map_to_analyse = map;
 	struct dl *dl;
 	char *devname;
-	unsigned int component_size_alligment;
 	int map_disks = info->array.raid_disks;
 
 	memset(info, 0, sizeof(*info));
@@ -2548,19 +2573,10 @@ static void getinfo_super_imsm_volume(struct supertype *st, struct mdinfo *info,
 	info->data_offset	  = pba_of_lba0(map_to_analyse);
 	info->component_size	  = blocks_per_member(map_to_analyse);
 
-	/* check component size aligment
-	 */
-	component_size_alligment =
-		info->component_size % (info->array.chunk_size/512);
-
-	if (component_size_alligment &&
-	    (info->array.level != 1) && (info->array.level != UnSet)) {
-		dprintf("imsm: reported component size alligned from %llu ",
-			info->component_size);
-		info->component_size -= component_size_alligment;
-		dprintf("to %llu (%i).\n",
-			info->component_size, component_size_alligment);
-	}
+	info->component_size = imsm_component_size_aligment_check(
+							info->array.level,
+							info->array.chunk_size,
+							info->component_size);
 
 	memset(info->uuid, 0, sizeof(info->uuid));
 	info->recovery_start = MaxSector;
@@ -9951,9 +9967,18 @@ enum imsm_reshape_type imsm_analyze_change(struct supertype *st,
 	super = st->sb;
 	dev = get_imsm_dev(super, super->current_vol);
 	data_disks = imsm_num_data_members(dev , MAP_0);
-	/* compute current size in K per disk member
+	/* compute current size per disk member
 	 */
-	current_size = info.custom_array_size / 2 / data_disks;
+	current_size = info.custom_array_size / data_disks;
+
+	if (geo->size > 0) {
+		/* align component size
+		 */
+		geo->size = imsm_component_size_aligment_check(
+				    get_imsm_raid_level(dev->vol.map),
+				    chunk * 1024,
+				    geo->size * 2);
+	}
 
 	if ((current_size != geo->size) && (geo->size >= 0)) {
 		if (change != -1) {
@@ -9986,10 +10011,13 @@ enum imsm_reshape_type imsm_analyze_change(struct supertype *st,
 			}
 			geo->size = freesize + current_size;
 
-			/* round to chunk size */
-			geo->size &= ~(chunk-1);
-		} else
-			geo->size *= 2;
+			/* align component size
+			 */
+			geo->size = imsm_component_size_aligment_check(
+					      get_imsm_raid_level(dev->vol.map),
+					      chunk * 1024,
+					      geo->size);
+		}
 
 		if ((direction == ROLLBACK_METADATA_CHANGES)) {
 			/* accept size for rollback only
-- 
1.6.4.2

