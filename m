From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH] imsm: FIX: remove update_reshape_set_slots update message
Date: Tue, 14 Dec 2010 15:41:56 +0100
Message-ID: <20101214144156.13137.20606.stgit@gklab-170-024.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

As it is suggested by Neil, that md has to accept slots chosen by mdadm
(instead decide itself about them), this patch sets slot to md instead base
on slot chosen by md.
Metadata update update_reshape_set_slots and code for slot number synchronization
are removed by this patch, as no longer required.

To use this method md has to be updated.
When md calls raid5_start_reshape(), spares are counted in the following way:
        list_for_each_entry(rdev, &mddev->disks, same_set)
                if (rdev->raid_disk < 0 &&
                    !test_bit(Faulty, &rdev->flags))
                        spares++;

so none of spare with slot set from user space will be counted.
To resolve this problem the following code in md /raid5.c/ should be used instead:
	list_for_each_entry(rdev, &mddev->disks, same_set)
           if (((rdev->raid_disk < 0) ||
                ((mddev->raid_disks - 1 - mddev->degraded)  < rdev->raid_disk)) &&
                 !test_bit(Faulty, &rdev->flags))
                     spares++;

Any disk with slot greater than array disks number is treated as spare.
'-1' is used, because slot numbers are '0'-based, degradation is used also
for calculation.

If kernel change seams to be ok, this patch can be applied.
If disks with slot set to '-1' has to be treated as spare by raid5 only,
changes introduced by this patch has to be discarded.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |  225 ++++++---------------------------------------------------
 1 files changed, 25 insertions(+), 200 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index c8d6382..e32228e 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -322,7 +322,6 @@ enum imsm_update_type {
 	update_rename_array,
 	update_add_disk,
 	update_reshape,
-	update_reshape_set_slots,
 	update_reshape_cancel,
 	update_level,
 };
@@ -5721,7 +5720,6 @@ static int disks_overlap(struct intel_super *super, int idx, struct imsm_update_
 }
 
 static void imsm_delete(struct intel_super *super, struct dl **dlp, unsigned index);
-static int imsm_reshape_array_set_slots(struct active_array *a);
 
 static void imsm_process_update(struct supertype *st,
 			        struct metadata_update *update)
@@ -5878,33 +5876,6 @@ update_reshape_exit:
 			free(u->devs_mem.dev);
 		break;
 	}
-	case update_reshape_set_slots: {
-		struct imsm_update_reshape *u = (void *)update->buf;
-		struct active_array *a;
-
-		dprintf("imsm: process_update() for update_reshape_set_slot "\
-			"for device %i\n",
-			u->devnum);
-		for (a = st->arrays; a; a = a->next)
-			if (a->devnum == u->devnum)
-				break;
-
-		if (a == NULL) {
-			dprintf(" - cannot locate requested array\n");
-			break;
-		}
-
-		/* do not accept this update type sent by mdadm
-		 */
-		if (u->update_prepared == -1) {
-			dprintf("imsm: message is not accepted\n");
-			break;
-		}
-
-		if (imsm_reshape_array_set_slots(a) > -1)
-			super->updates_pending++;
-		break;
-	}
 	case update_reshape_cancel: {
 		struct imsm_update_reshape *u = (void *)update->buf;
 		struct active_array *a;
@@ -6487,14 +6458,6 @@ static void imsm_prepare_update(struct supertype *st,
 		dprintf("New anchor length is %llu\n", (unsigned long long)len);
 		break;
 	}
-	case update_reshape_set_slots: {
-		struct imsm_update_reshape *u = (void *)update->buf;
-
-		/* do not accept this update type sent by mdadm
-		 */
-		u->update_prepared = -1;
-		break;
-	}
 	case update_reshape_cancel: {
 		struct imsm_update_reshape *u = (void *)update->buf;
 
@@ -8075,109 +8038,6 @@ void imsm_grow_array_remove_devices_on_cancel(struct active_array *a)
 	}
 }
 
-/* imsm_reshape_array_manage_new_slots()
- * returns: number of corrected slots for correct == 1
- *          counted number of different slots for correct == 0
-*/
-static int imsm_reshape_array_manage_new_slots(struct intel_super *super,
-					int inst,
-					int devnum,
-					int correct)
-{
-
-	struct imsm_dev *dev = get_imsm_dev(super, inst);
-	struct imsm_map *map_1 = get_imsm_map(dev, 0);
-	struct imsm_map *map_2 = get_imsm_map(dev, 1);
-	struct dl *dl;
-	unsigned long long sysfs_slot;
-	char buf[PATH_MAX];
-	int fd;
-	struct mdinfo *sra = NULL;
-	int ret_val = 0;
-
-	if ((map_1 == NULL) || (map_2 == NULL)) {
-		dprintf("imsm_reshape_array_set_slots() no maps "\
-			"(map_1 =%p, map_2 = %p)\n",
-			map_1,
-			map_2);
-		dprintf("\t\tdev->vol.migr_state = %i\n", dev->vol.migr_state);
-		dprintf("\t\tdev->volume = %s\n", dev->volume);
-		return -1;
-	}
-
-	/* verify/correct slot configuration of added disks
-	 */
-	dprintf("\n\nStart map verification for %i added devices "\
-		"on device no %i\n",
-		map_1->num_members - map_2->num_members, devnum);
-
-	fd = open_dev(devnum);
-	if (fd < 0) {
-		dprintf("imsm: ERROR: Cannot open device %s.\n", buf);
-		return -1;
-	}
-
-	sra = sysfs_read(fd, 0, GET_LEVEL|GET_VERSION|GET_DEVS|GET_STATE);
-	if (!sra) {
-		dprintf("imsm: ERROR: Device not found.\n");
-		close(fd);
-		return -1;
-	}
-
-	for (dl = super->disks; dl; dl = dl->next) {
-		int fd2;
-		int rv;
-
-		/* skip not configured disks */
-		if (dl->index < 0)
-			continue;
-
-		dprintf("\tLooking at device %s (index = %i).\n",
-			dl->devname,
-			dl->index);
-		if (dl->devname && (strlen(dl->devname) > 5))
-			sprintf(buf, "/sys/block/%s/md/dev-%s/slot",
-				sra->sys_name, dl->devname+5);
-		fd2 = open(buf, O_RDONLY);
-		if (fd2 < 0)
-			continue;
-		rv = sysfs_fd_get_ll(fd2, &sysfs_slot);
-		close(fd2);
-		if (rv < 0)
-			continue;
-		dprintf("\t\tLooking at slot %llu in sysfs.\n", sysfs_slot);
-		if ((int)sysfs_slot != dl->index) {
-			dprintf("Slots doesn't match sysfs->%i and imsm->%i\n",
-				(int)sysfs_slot,
-				dl->index);
-			ret_val++;
-			if (correct)
-				dl->index = sysfs_slot;
-		}
-	}
-	close(fd);
-	sysfs_free(sra);
-	dprintf("IMSM Map verification finished (found wrong slots : %i).\n",
-		ret_val);
-
-	return ret_val;
-}
-
-static int imsm_reshape_array_set_slots(struct active_array *a)
-{
-	struct intel_super *super = a->container->sb;
-	int inst = a->info.container_member;
-
-	return imsm_reshape_array_manage_new_slots(super, inst, a->devnum, 1);
-}
-
-int imsm_reshape_array_count_slots_mismatches(struct intel_super *super,
-					      int inst,
-					      int devnum)
-{
-	return imsm_reshape_array_manage_new_slots(super, inst, devnum, 0);
-}
-
 struct mdinfo *imsm_grow_array(struct active_array *a)
 {
 	int disk_count = 0;
@@ -8244,7 +8104,7 @@ struct mdinfo *imsm_grow_array(struct active_array *a)
 		 */
 		di->devs = (struct mdinfo *) dl;
 
-		di->disk.raid_disk = -1;
+		di->disk.raid_disk = dl->index;
 		di->disk.major = dl->major;
 		di->disk.minor = dl->minor;
 		di->disk.state = (1<<MD_DISK_SYNC) |
@@ -8316,60 +8176,42 @@ struct mdinfo *imsm_reshape_array(struct active_array *a,
 		dprintf("grow is detected.\n");
 		disk_list = imsm_grow_array(a);
 	}
-
-	if (disk_list) {
-		dprintf("imsm: send update update_reshape_set_slots\n");
-
-		u = (struct imsm_update_reshape *)calloc(1,
-					sizeof(struct imsm_update_reshape));
-		if (u) {
-			u->type = update_reshape_set_slots;
-			a->reshape_state = reshape_in_progress;
-		}
-	} else
-		dprintf("error: cannot start reshape\n");
+	if (disk_list)
+		a->reshape_state = request_type;
 
 imsm_reshape_array_exit:
-	if (u == NULL) {
+	if (!disk_list) {
 		dprintf("imsm: send update update_reshape_cancel\n");
 		a->reshape_state = reshape_not_active;
 		sysfs_set_str(&a->info, NULL, "sync_action", "idle");
 		imsm_grow_array_remove_devices_on_cancel(a);
 		u = (struct imsm_update_reshape *)calloc(1,
 					sizeof(struct imsm_update_reshape));
-		if (u)
+		if (u) {
 			u->type = update_reshape_cancel;
-	}
-
-	if (u) {
-		/* post any prepared update
-		 */
-		u->devnum = a->devnum;
-		u->update_memory_size = sizeof(struct imsm_update_reshape);
-		u->reshape_delta_disks = a->reshape_delta_disks;
-		u->update_prepared = 1;
-
-		mu = malloc(sizeof(struct metadata_update));
-		if (mu) {
-			mu->buf = (void *)u;
-			mu->space = NULL;
-			mu->len = u->update_memory_size;
-			mu->next = *updates;
-			*updates = mu;
-		} else {
-			a->reshape_state = reshape_not_active;
-			free(u);
-			u = NULL;
+			/* post any prepared update
+			 */
+			u->devnum = a->devnum;
+			u->update_memory_size =
+				sizeof(struct imsm_update_reshape);
+			u->reshape_delta_disks = a->reshape_delta_disks;
+			u->update_prepared = 1;
+
+			mu = malloc(sizeof(struct metadata_update));
+			if (mu) {
+				mu->buf = (void *)u;
+				mu->space = NULL;
+				mu->len = u->update_memory_size;
+				mu->next = *updates;
+				*updates = mu;
+			} else {
+				a->reshape_state = reshape_not_active;
+				free(u);
+				u = NULL;
+			}
 		}
 	}
 
-	if ((disk_list) && (u == NULL)) {
-		while (disk_list) {
-			struct mdinfo *di = disk_list;
-			disk_list = disk_list->next;
-			free(di);
-		}
-	}
 	return disk_list;
 }
 
@@ -8557,7 +8399,6 @@ int imsm_check_reshape_conditions(int fd,
 	int ret_val = 0;
 	struct intel_super *super = st->sb;
 	struct imsm_super *mpb = super->anchor;
-	int wrong_slots_counter;
 
 	/* wait until all arrays will be in reshape state
 	 * or error occures (iddle state detected)
@@ -8670,22 +8511,8 @@ int imsm_check_reshape_conditions(int fd,
 					break;
 				}
 			}
-			/* this device looks ok, so
-			 * check if slots are set corectly
-			 */
-			super = st->sb;
-			wrong_slots_counter =
-				imsm_reshape_array_count_slots_mismatches(super,
-							i,
-							atoi(info->sys_name+2));
 			sysfs_free(info);
 			info = NULL;
-			if (wrong_slots_counter != 0) {
-				dprintf("Slots for correction %i.\n",
-					wrong_slots_counter);
-				ret_val = 1;
-				goto exit_imsm_check_reshape_conditions;
-			}
 		}
 		sysfs_free(info);
 		info = NULL;
@@ -8696,8 +8523,6 @@ int imsm_check_reshape_conditions(int fd,
 			ret_val = 1;
 		}
 	}
-
-exit_imsm_check_reshape_conditions:
 	sysfs_free(info);
 	info = NULL;
 

