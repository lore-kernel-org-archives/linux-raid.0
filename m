From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 8/8] imsm: move common code for array size calculation to
	function
Date: Tue, 01 Feb 2011 14:50:00 +0100
Message-ID: <20110201135000.13398.35393.stgit@gklab-128-013.igk.intel.com>
References: <20110201134226.13398.4071.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110201134226.13398.4071.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

Array size calculation is made in the same way in few places in code.
Make function imsm_set_device_size() for this common code.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |   74 +++++++++++++++++++++++++--------------------------------
 1 files changed, 33 insertions(+), 41 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index e523313..c70d44b 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -5052,6 +5052,37 @@ static void handle_missing(struct intel_super *super, struct imsm_dev *dev)
 	super->updates_pending++;
 }
 
+static unsigned long long imsm_set_array_size(struct imsm_dev *dev)
+{
+	int used_disks = imsm_num_data_members(dev, 0);
+	unsigned long long array_blocks;
+	struct imsm_map *map;
+
+	if (used_disks == 0) {
+		/* when problems occures
+		 * return current array_blocks value
+		 */
+		array_blocks = __le32_to_cpu(dev->size_high);
+		array_blocks = array_blocks << 32;
+		array_blocks += __le32_to_cpu(dev->size_low);
+
+		return array_blocks;
+	}
+
+	/* set array size in metadata
+	 */
+	map = get_imsm_map(dev, 0);
+	array_blocks = map->blocks_per_member * used_disks;
+
+	/* round array size down to closest MB
+	 */
+	array_blocks = (array_blocks >> SECT_PER_MB_SHIFT) << SECT_PER_MB_SHIFT;
+	dev->size_low = __cpu_to_le32((__u32)array_blocks);
+	dev->size_high = __cpu_to_le32((__u32)(array_blocks >> 32));
+
+	return array_blocks;
+}
+
 static void imsm_set_disk(struct active_array *a, int n, int state);
 
 static void imsm_progress_container_reshape(struct intel_super *super)
@@ -5071,7 +5102,6 @@ static void imsm_progress_container_reshape(struct intel_super *super)
 		struct imsm_map *map = get_imsm_map(dev, 0);
 		struct imsm_map *map2;
 		int prev_num_members;
-		int used_disks;
 
 		if (dev->vol.migr_state)
 			return;
@@ -5099,26 +5129,7 @@ static void imsm_progress_container_reshape(struct intel_super *super)
 		memcpy(map2, map, copy_map_size);
 		map2->num_members = prev_num_members;
 
-		/* calculate new size
-		 */
-		used_disks = imsm_num_data_members(dev, 0);
-		if (used_disks) {
-			unsigned long long array_blocks;
-
-			array_blocks =
-				map->blocks_per_member
-				* used_disks;
-			/* round array size down to closest MB
-			 */
-			array_blocks = (array_blocks
-					>> SECT_PER_MB_SHIFT)
-				<< SECT_PER_MB_SHIFT;
-			dev->size_low =
-				__cpu_to_le32((__u32)array_blocks);
-			dev->size_high =
-				__cpu_to_le32(
-					(__u32)(array_blocks >> 32));
-		}
+		imsm_set_array_size(dev);
 		super->updates_pending++;
 	}
 }
@@ -5910,8 +5921,6 @@ static int apply_reshape_container_disks_update(struct imsm_update_reshape *u,
 		/* update one device only
 		 */
 		if (devices_to_reshape) {
-			int used_disks;
-
 			dprintf("imsm: modifying subdev: %i\n",
 				id->index);
 			devices_to_reshape--;
@@ -5929,24 +5938,7 @@ static int apply_reshape_container_disks_update(struct imsm_update_reshape *u,
 			newmap = get_imsm_map(newdev, 1);
 			memcpy(newmap, oldmap, sizeof_imsm_map(oldmap));
 
-			/* calculate new size
-			 */
-			used_disks = imsm_num_data_members(newdev, 0);
-			if (used_disks) {
-				unsigned long long array_blocks;
-
-				array_blocks =
-					newmap->blocks_per_member * used_disks;
-				/* round array size down to closest MB
-				 */
-				array_blocks = (array_blocks
-						>> SECT_PER_MB_SHIFT)
-					<< SECT_PER_MB_SHIFT;
-				newdev->size_low =
-					__cpu_to_le32((__u32)array_blocks);
-				newdev->size_high =
-					__cpu_to_le32((__u32)(array_blocks >> 32));
-			}
+			imsm_set_array_size(newdev);
 		}
 
 		sp = (void **)id->dev;

