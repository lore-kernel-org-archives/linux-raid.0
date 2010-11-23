From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 07/21] imsm: FIX: Reshape Cancel message on 2nd array doesn't
	work correctly
Date: Tue, 23 Nov 2010 13:40:33 +0100
Message-ID: <20101123124033.17770.60028.stgit@gklab-170-024.igk.intel.com>
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

During Online Capacity Expansion on container with 2 arrays, when 2nd
volume reshape fails, cancel message is generated.

Cancel message should not remove disks from disks list when they are used
in other volume already. Size stored in metadata has to be roll-backed
to initial value when disks are removed array configuration.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 mdadm/mdadm/super-intel.c |   53 ++++++++++++++++++++++++++++++++++++---------
 1 files changed, 42 insertions(+), 11 deletions(-)

diff --git a/mdadm/mdadm/super-intel.c b/mdadm/mdadm/super-intel.c
index 3ff26c5..96892ec 100644
--- a/mdadm/mdadm/super-intel.c
+++ b/mdadm/mdadm/super-intel.c
@@ -5795,11 +5795,15 @@ update_reshape_exit:
 		struct imsm_update_reshape *u = (void *)update->buf;
 		struct active_array *a;
 		int inst;
+		int i;
 		struct imsm_dev *dev;
+		struct imsm_dev *devi;
 		struct imsm_map *map_1;
 		struct imsm_map *map_2;
 		int reshape_delta_disks ;
 		struct dl *curr_disk;
+		int used_disks;
+		unsigned long long array_blocks;
 
 
 		dprintf("imsm: process_update() for update_reshape_cancel for device %i\n", u->devnum);
@@ -5821,9 +5825,28 @@ update_reshape_exit:
 		dev = get_imsm_dev(super, inst);
 		map_1 = get_imsm_map(dev, 0);
 		map_2 = get_imsm_map(dev, 1);
+		if (map_2 == NULL)
+			break;
 		reshape_delta_disks = map_1->num_members - map_2->num_members;
 		dprintf("\t\tRemove %i device(s) from configuration.\n", reshape_delta_disks);
 
+		/* when cancel was applied during reshape of second volume, we need disks for first
+		 * array reshaped previously, find the smallest delta_disks to remove
+		 */
+		i = 0;
+		devi = get_imsm_dev(super, i);
+		while (devi) {
+			struct imsm_map *mapi = get_imsm_map(devi, 0);
+			int delta_disks = map_1->num_members - mapi->num_members;
+			if ((i != inst) &&
+			    (delta_disks < reshape_delta_disks) &&
+			    (delta_disks >= 0))
+				reshape_delta_disks = delta_disks;
+			i++;
+			devi = get_imsm_dev(super, i);
+		}
+		/* remove disks
+		 */
 		if (reshape_delta_disks > 0) {
 			/* reverse device(s) back to spares
 			*/
@@ -5839,18 +5862,26 @@ update_reshape_exit:
 				}
 				curr_disk = curr_disk->next;
 			}
-
-			/* roll back maps and migration
-			 */
-			memcpy(map_1, map_2, sizeof_imsm_map(map_2));
-			/* reconfigure map_2 and perform migration end
-			 */
-			map_2 = get_imsm_map(dev, 1);
-			memcpy(map_2, map_1, sizeof_imsm_map(map_1));
-			end_migration(dev, map_1->map_state);
-
-			super->updates_pending++;
 		}
+		/* roll back maps and migration
+		 */
+		memcpy(map_1, map_2, sizeof_imsm_map(map_2));
+		/* reconfigure map_2 and perform migration end
+		 */
+		map_2 = get_imsm_map(dev, 1);
+		memcpy(map_2, map_1, sizeof_imsm_map(map_1));
+		end_migration(dev, map_1->map_state);
+		/* array size rollback
+		 */
+		used_disks = imsm_num_data_members(dev, 0);
+		array_blocks = map_1->blocks_per_member * used_disks;
+		/* round array size down to closest MB
+		 */
+		array_blocks = (array_blocks >> SECT_PER_MB_SHIFT) << SECT_PER_MB_SHIFT;
+		dev->size_low = __cpu_to_le32((__u32)array_blocks);
+		dev->size_high = __cpu_to_le32((__u32)(array_blocks >> 32));
+
+		super->updates_pending++;
 		break;
 	}
 	case update_level: {

