From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 26/53] imsm: Cancel metadata changes on reshape start failure
Date: Fri, 26 Nov 2010 09:07:16 +0100
Message-ID: <20101126080716.5221.67217.stgit@gklab-170-024.igk.intel.com>
References: <20101126075407.5221.62582.stgit@gklab-170-024.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101126075407.5221.62582.stgit@gklab-170-024.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

It can occurs that managemon cannot run reshape in md.
To perform metadata changes cancellation, update_reshape_cancel message is used. It is prepared by reshape_array() vector.
When monitor receives this message, it rollbacks metadata changes made previously during processing update_reshape update.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |  123 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 123 insertions(+), 0 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 799bb51..89fb118 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -288,6 +288,7 @@ enum imsm_update_type {
 	update_level,
 	update_reshape,
 	update_reshape_set_slots,
+	update_reshape_cancel,
 };
 
 struct imsm_update_activate_spare {
@@ -5403,6 +5404,94 @@ update_reshape_exit:
 			super->updates_pending++;
 		break;
 	}
+	case update_reshape_cancel: {
+		struct imsm_update_reshape *u = (void *)update->buf;
+		struct active_array *a;
+		int inst;
+		int i;
+		struct imsm_dev *dev;
+		struct imsm_dev *devi;
+		struct imsm_map *map_1;
+		struct imsm_map *map_2;
+		int reshape_delta_disks ;
+		struct dl *curr_disk;
+		int used_disks;
+		unsigned long long array_blocks;
+
+
+		dprintf("imsm: process_update() for update_reshape_cancel for device %i\n", u->devnum);
+		for (a = st->arrays; a; a = a->next)
+			if (a->devnum == u->devnum) {
+				break;
+			}
+		if (a == NULL)
+			break;
+
+		inst = a->info.container_member;
+		dev = get_imsm_dev(super, inst);
+		map_1 = get_imsm_map(dev, 0);
+		map_2 = get_imsm_map(dev, 1);
+		if (map_2 == NULL)
+			break;
+		reshape_delta_disks = map_1->num_members - map_2->num_members;
+		dprintf("\t\tRemove %i device(s) from configuration.\n", reshape_delta_disks);
+
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
+		if (reshape_delta_disks > 0) {
+			/* reverse device(s) back to spares
+			*/
+			curr_disk = super->disks;
+			while (curr_disk) {
+				dprintf("Looking at %i device to remove\n", curr_disk->index);
+				if (curr_disk->index >= map_2->num_members) {
+					dprintf("\t\t\tREMOVE\n");
+					curr_disk->index = -1;
+					curr_disk->raiddisk = -1;
+					curr_disk->disk.status &= ~CONFIGURED_DISK;
+					curr_disk->disk.status |= SPARE_DISK;
+				}
+				curr_disk = curr_disk->next;
+			}
+		}
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
+		used_disks = imsm_num_data_members(dev);
+		if (used_disks) {
+			array_blocks = map_1->blocks_per_member * used_disks;
+			/* round array size down to closest MB
+			*/
+			array_blocks = (array_blocks >> SECT_PER_MB_SHIFT) << SECT_PER_MB_SHIFT;
+			dev->size_low = __cpu_to_le32((__u32)array_blocks);
+			dev->size_high = __cpu_to_le32((__u32)(array_blocks >> 32));
+		}
+
+		super->updates_pending++;
+		break;
+	}
 	case update_level: {
 		struct imsm_update_level *u = (void *)update->buf;
 		struct imsm_dev *dev_new, *dev = NULL;
@@ -5826,6 +5915,9 @@ static void imsm_prepare_update(struct supertype *st,
 	case update_reshape_set_slots: {
 		break;
 	}
+	case update_reshape_cancel: {
+		break;
+	}
 	case update_level: {
 		struct imsm_update_level *u = (void *) update->buf;
 		struct active_array *a;
@@ -6690,6 +6782,31 @@ imsm_reshape_super_exit:
 	return ret_val;
 }
 
+void imsm_grow_array_remove_devices_on_cancel(struct active_array *a)
+{
+	struct mdinfo *di = a->info.devs;
+	struct mdinfo *di_prev = NULL;
+
+	while (di) {
+		if (di->disk.raid_disk < 0) {
+			struct mdinfo *rmdev = di;
+			sysfs_set_str(&a->info, rmdev, "state", "faulty");
+			sysfs_set_str(&a->info, rmdev, "slot", "none");
+			sysfs_set_str(&a->info, rmdev, "state", "remove");
+
+			if (di_prev)
+				di_prev->next = di->next;
+			else
+				a->info.devs = di->next;
+			di = di->next;
+			free(rmdev);
+		} else {
+			di_prev = di;
+			di = di->next;
+		}
+	}
+}
+
 int imsm_get_new_device_name(struct dl *dl)
 {
 	int rv;
@@ -6960,6 +7077,12 @@ imsm_reshape_array_exit:
 		dprintf("imsm: send update update_reshape_cancel\n");
 		a->reshape_state = reshape_not_active;
 		sysfs_set_str(&a->info, NULL, "sync_action", "idle");
+		imsm_grow_array_remove_devices_on_cancel(a);
+		u = (struct imsm_update_reshape *)calloc(1, sizeof(struct imsm_update_reshape));
+		if (u) {
+			u->type = update_reshape_cancel;
+			a->reshape_state = reshape_not_active;
+		}
 	}
 
 	if (u) {

