From: Lukasz Dorau <lukasz.dorau@intel.com>
Subject: [PATCH] imsm: fix: check if size of expansion is not larger than
	maximum
Date: Thu, 17 May 2012 16:14:00 +0200
Message-ID: <20120517141400.20390.87947.stgit@gklab-128-085.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

We do not check if requested size of expansion is larger than maximum
available size now. If it is larger the output message is a bit misleading,
for example:
   mdadm: Cannot set size on array members.
   mdadm: Cannot set device size for /dev/md/vol: Device or resource busy
Now we check if requested size of expansion is larger than maximum
available size and the appropriate output message was added.

Signed-off-by: Lukasz Dorau <lukasz.dorau@intel.com>
---
 super-intel.c |   47 ++++++++++++++++++++++++++++++++---------------
 1 files changed, 32 insertions(+), 15 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 733bb38..6c87e20 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -9902,6 +9902,9 @@ enum imsm_reshape_type imsm_analyze_change(struct supertype *st,
 	struct imsm_dev *dev;
 	struct intel_super *super;
 	long long current_size;
+	unsigned long long free_size;
+	long long max_size;
+	int rv;
 
 	getinfo_super_imsm_volume(st, &info, NULL);
 	if ((geo->level != info.array.level) &&
@@ -10015,28 +10018,33 @@ enum imsm_reshape_type imsm_analyze_change(struct supertype *st,
 				super->current_vol, st->devnum);
 			goto analyse_change_exit;
 		}
+		/* check the maximum available size
+		 */
+		rv =  imsm_get_free_size(st, dev->vol.map->num_members,
+					 0, chunk, &free_size);
+		if (rv == 0)
+			/* Cannot find maximum available space
+			 */
+			max_size = 0;
+		else {
+			max_size = free_size + current_size;
+			/* align component size
+			 */
+			max_size = imsm_component_size_aligment_check(
+					get_imsm_raid_level(dev->vol.map),
+					chunk * 1024,
+					max_size);
+		}
 		if (geo->size == 0) {
 			/* requested size change to the maximum available size
 			 */
-			unsigned long long freesize;
-			int rv;
-
-			rv =  imsm_get_free_size(st, dev->vol.map->num_members,
-						 0, chunk, &freesize);
-			if (rv == 0) {
+			if (max_size == 0) {
 				fprintf(stderr, Name " Error. Cannot find "
 					"maximum available space.\n");
 				change = -1;
 				goto analyse_change_exit;
-			}
-			geo->size = freesize + current_size;
-
-			/* align component size
-			 */
-			geo->size = imsm_component_size_aligment_check(
-					      get_imsm_raid_level(dev->vol.map),
-					      chunk * 1024,
-					      geo->size);
+			} else
+				geo->size = max_size;
 		}
 
 		if ((direction == ROLLBACK_METADATA_CHANGES)) {
@@ -10057,6 +10065,15 @@ enum imsm_reshape_type imsm_analyze_change(struct supertype *st,
 					current_size, geo->size);
 				goto analyse_change_exit;
 			}
+			if (max_size && geo->size > max_size) {
+				fprintf(stderr,
+					Name " Error. Requested size is larger "
+					"than maximum available size (maximum "
+					"available size is %llu, "
+					"requested size /rounded/ is %llu).\n",
+					max_size, geo->size);
+				goto analyse_change_exit;
+			}
 		}
 		geo->size *= data_disks;
 		geo->raid_disks = dev->vol.map->num_members;

