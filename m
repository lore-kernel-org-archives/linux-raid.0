From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 22/34] imsm: update array size information in metadata
Date: Tue, 04 Jan 2011 15:38:31 +0100
Message-ID: <20110104143831.6697.67491.stgit@gklab-128-013.igk.intel.com>
References: <20110104143240.6697.52355.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110104143240.6697.52355.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

When disks are added size has to increase in metadata.
This size should be used by common code to set size in md when reshape will be finished.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |   23 +++++++++++++++++++++++
 1 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index dc4f308..72b6cf5 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -5672,6 +5672,7 @@ static void imsm_process_update(struct supertype *st,
 			/* update one device only
 			 */
 			if (devices_to_reshape) {
+				int used_disks;
 				dprintf("process_update(): modifying "\
 					"subdev: %i\n", id->index);
 				devices_to_reshape--;
@@ -5688,6 +5689,28 @@ static void imsm_process_update(struct supertype *st,
 				 */
 				newmap = get_imsm_map(newdev, 1);
 				memcpy(newmap, oldmap, sizeof_imsm_map(oldmap));
+
+				/* calculate new size
+				 */
+				used_disks = imsm_num_data_members(newdev, 0);
+				if (used_disks) {
+					unsigned long long array_blocks;
+
+					array_blocks =
+						newmap->blocks_per_member
+						* used_disks;
+					/* round array size down to closest MB
+					 */
+					array_blocks = (array_blocks
+							>> SECT_PER_MB_SHIFT)
+							<< SECT_PER_MB_SHIFT;
+					newdev->size_low =
+						__cpu_to_le32(
+							(__u32)array_blocks);
+					newdev->size_high =
+						__cpu_to_le32(
+						(__u32)(array_blocks >> 32));
+				}
 			}
 
 			sp = (void **)id->dev;

