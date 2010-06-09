From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: [PATCH 15/23] imsm: Set new array size in update_grow_array
Date: Wed, 9 Jun 2010 15:37:33 +0100
Message-ID: <905EDD02F158D948B186911EB64DB3D11EECE8E3@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

(Online Capacity Expansion for IMSM)
Online capacity expansion has a goal that at the process end, increasing disks number increases array size.
To expand array size, new array size has to be calculated based on new disks number. This value is stored in metadata.

When reshape finishes mdadm will read this value from metadata and will update md (md will not update it automatically as array size is managed externally for external metadata).

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |   36 ++++++++++++++++++++++++++++++++++++
 1 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/super-intel.c b/super-intel.c index 6af79a8..b92a787 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -5490,6 +5490,42 @@ static void imsm_process_update(struct supertype *st,
 		migr_map_src = get_imsm_map(dev_new, 1);
 		memcpy(migr_map, migr_map_src, sizeof_imsm_map(migr_map_src));
 
+		/* manage size, if active array is known
+		 * to in line with md access active array
+		 * (Initialize pointer to the proper active array)
+		 */
+		if ((map->raid_level == 5) ||
+		    (map->raid_level == 0)) {
+			unsigned long long array_blocks;
+			unsigned long long array_blocks_current;
+			int used_disks;
+
+			switch (map->raid_level) {
+			case 5:
+				used_disks = map->num_members - 1;
+			break;
+			case 0:
+				used_disks = map->num_members;
+			break;
+			}
+
+			array_blocks = map->blocks_per_member * used_disks;
+			/* round array size down to closest MB
+			 */
+			array_blocks = (array_blocks >> SECT_PER_MB_SHIFT)
+					<< SECT_PER_MB_SHIFT;
+			array_blocks_current
+				= (((unsigned long long)dev->size_high) << 32)
+					+ dev->size_low;
+
+			/* grow only
+			 */
+			if (array_blocks_current < array_blocks) {
+				dev->size_low = __cpu_to_le32((__u32)array_blocks);
+				dev->size_high
+					= __cpu_to_le32((__u32)(array_blocks >> 32));
+			}
+		}
 		super->updates_pending++;
 
 		/* operatio succed - no exit with error

