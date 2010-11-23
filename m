From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 06/21] imsm: FIX: Guard size setting
Date: Tue, 23 Nov 2010 13:40:25 +0100
Message-ID: <20101123124025.17770.4101.stgit@gklab-170-024.igk.intel.com>
References: <20101123123900.17770.75516.stgit@gklab-170-024.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101123123900.17770.75516.stgit@gklab-170-024.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

Function imsm_num_data_members() can return 0 when error condition
occurs. This would cause set 0 array size in metadata to 0 also.
This patch puts guard for array size modification in such case.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 mdadm/mdadm/super-intel.c |   18 ++++++++++--------
 1 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/mdadm/mdadm/super-intel.c b/mdadm/mdadm/super-intel.c
index 1005595..3ff26c5 100644
--- a/mdadm/mdadm/super-intel.c
+++ b/mdadm/mdadm/super-intel.c
@@ -7149,14 +7149,16 @@ calculate_size_only:
 	 */
 	if (new_map != NULL) {
 		used_disks = imsm_num_data_members(upd_devs, 0);
-		array_blocks = new_map->blocks_per_member * used_disks;
-		/* round array size down to closest MB
-		 */
-		array_blocks = (array_blocks >> SECT_PER_MB_SHIFT) << SECT_PER_MB_SHIFT;
-		((struct imsm_dev *)(upd_devs))->size_low = __cpu_to_le32((__u32)array_blocks);
-		((struct imsm_dev *)(upd_devs))->size_high = __cpu_to_le32((__u32)(array_blocks >> 32));
-		/* finalize update */
-		ret_val = u;
+		if (used_disks) {
+			array_blocks = new_map->blocks_per_member * used_disks;
+			/* round array size down to closest MB
+			 */
+			array_blocks = (array_blocks >> SECT_PER_MB_SHIFT) << SECT_PER_MB_SHIFT;
+			((struct imsm_dev *)(upd_devs))->size_low = __cpu_to_le32((__u32)array_blocks);
+			((struct imsm_dev *)(upd_devs))->size_high = __cpu_to_le32((__u32)(array_blocks >> 32));
+			/* finalize update */
+			ret_val = u;
+		}
 	}
 
 exit_imsm_create_metadata_update_for_reshape:

