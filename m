From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: [PATCH 12/31] imsm: Cancel metadata changes on reshape start failure
Date: Tue, 9 Nov 2010 17:01:11 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D174A1CA9C@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

It can occurs that managemon cannot run reshape in md.
To perform metadata changes cancellation, update_reshape_cancel message is used. It is prepared by reshape_array() vector.
When monitor receives this message, it rollbacks metadata changes made previously during processing update_reshape update.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 mdadm/mdadm/super-intel.c |   90 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 90 insertions(+), 0 deletions(-)

diff --git a/mdadm/mdadm/super-intel.c b/mdadm/mdadm/super-intel.c index f0b5bbe..fa5ab8c 100644
--- a/mdadm/mdadm/super-intel.c
+++ b/mdadm/mdadm/super-intel.c
@@ -298,6 +298,7 @@ enum imsm_update_type {
 	update_level,
 	update_reshape,
 	update_reshape_set_slots,
+	update_reshape_cancel,
 };
 
 struct imsm_update_activate_spare {
@@ -5405,6 +5406,61 @@ update_reshape_exit:
 			super->updates_pending++;
 		break;
 	}
+	case update_reshape_cancel: {
+		struct imsm_update_reshape *u = (void *)update->buf;
+		struct active_array *a;
+		int inst;
+		struct imsm_dev *dev;
+		struct imsm_map *map_1;
+		struct imsm_map *map_2;
+		int reshape_delta_disks ;
+		struct dl *curr_disk;
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
+		reshape_delta_disks = map_1->num_members - map_2->num_members;
+		dprintf("\t\tRemove %i device(s) from configuration.\n", 
+reshape_delta_disks);
+
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
+
+			/* roll back maps and migration
+			 */
+			memcpy(map_1, map_2, sizeof_imsm_map(map_2));
+			/* reconfigure map_2 and perform migration end
+			 */
+			map_2 = get_imsm_map(dev, 1);
+			memcpy(map_2, map_1, sizeof_imsm_map(map_1));
+			end_migration(dev, map_1->map_state);
+
+			super->updates_pending++;
+		}
+		break;
+	}
 	case update_level: {
 		struct imsm_update_level *u = (void *)update->buf;
 		struct imsm_dev *dev_new, *dev = NULL; @@ -5827,6 +5883,9 @@ static void imsm_prepare_update(struct supertype *st,
 	case update_reshape_set_slots: {
 		break;
 	}
+	case update_reshape_cancel: {
+		break;
+	}
 	case update_level: {
 		struct imsm_update_level *u = (void *) update->buf;
 		struct active_array *a;
@@ -6653,6 +6712,31 @@ imsm_reshape_super_exit:
 	return ret_val;
 }
 
+void imsm_grow_array_remove_devices_on_cancel(struct active_array *a) {
+	struct mdinfo *di = a->info.devs;
+	struct mdinfo *di_prev = NULL;
+
+	while (di) {
+		if (di->disk.raid_disk == SYSFS_ADD_DISK_DO_NOT_SET_SLOT) {
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
 int imsm_get_new_device_name(struct dl *dl)  {
 	int rv;
@@ -6922,6 +7006,12 @@ imsm_reshape_array_exit:
 	if (u == NULL) {
 		dprintf("imsm: send update update_reshape_cancel\n");
 		sysfs_set_str(&a->info, NULL, "sync_action", "idle");
+		imsm_grow_array_remove_devices_on_cancel(a);
+		u = (struct imsm_update_reshape *)calloc(1, sizeof(struct imsm_update_reshape));
+		if (u) {
+			u->type = update_reshape_cancel;
+			a->reshape_delta_disks = RESHAPE_NOT_ACTIVE;
+		}
 	}
 
 	if (u) {

