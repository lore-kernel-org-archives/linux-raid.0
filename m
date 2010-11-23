From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 18/21] imsm: Use geo structure
Date: Tue, 23 Nov 2010 13:42:03 +0100
Message-ID: <20101123124203.17770.96784.stgit@gklab-170-024.igk.intel.com>
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

For passing parameters use geo structures.
Add function (update_geometry()) to update geometry structure.

Signed-off-by: Krysztof Wojcik <krzysztof.wojcik@intel.com>
Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 mdadm/mdadm/super-intel.c |  271 +++++++++++++++++++++++++++++++++------------
 1 files changed, 199 insertions(+), 72 deletions(-)

diff --git a/mdadm/mdadm/super-intel.c b/mdadm/mdadm/super-intel.c
index 7481126..113c3bb 100644
--- a/mdadm/mdadm/super-intel.c
+++ b/mdadm/mdadm/super-intel.c
@@ -329,6 +329,16 @@ struct imsm_update_activate_spare {
 	struct imsm_update_activate_spare *next;
 };
 
+struct geo_params {
+	int dev_id;
+	char *dev_name;
+	long long size;
+	int level;
+	int layout;
+	int chunksize;
+	int raid_disks;
+};
+
 
 struct imsm_update_reshape {
 	enum imsm_update_type type;
@@ -6797,8 +6807,7 @@ static int update_level_imsm(struct supertype *st, struct mdinfo *info,
 }
 
 int imsm_reshape_is_allowed_on_container(struct supertype *st,
-					 long long size, int level, int layout,
-					 int chunksize, int raid_disks)
+					 struct geo_params *geo)
 {
 	int ret_val = 0;
 	struct mdinfo *info = NULL;
@@ -6809,8 +6818,9 @@ int imsm_reshape_is_allowed_on_container(struct supertype *st,
 
 	dprintf("imsm: imsm_reshape_is_allowed_on_container(ENTER): st->devnum = (%i)\n", st->devnum);
 
-	if ((size != -1) || (level != UnSet) ||
-	    (layout != UnSet) || (chunksize != 0)) {
+	if (geo == NULL ||
+	    (geo->size != -1) || (geo->level != UnSet) ||
+	    (geo->layout != UnSet) || (geo->chunksize != 0)) {
 		dprintf("imsm: Container operation is allowed for raid disks number change only.\n");
 		return ret_val;
 	}
@@ -6823,7 +6833,7 @@ int imsm_reshape_is_allowed_on_container(struct supertype *st,
 		return ret_val;
 	}
 
-	if (raid_disks == UnSet) {
+	if (geo->raid_disks == UnSet) {
 		dprintf("imsm: for container operation raid disks change is required\n");
 		goto exit_imsm_reshape_is_allowed_on_container;
 	}
@@ -6868,7 +6878,7 @@ int imsm_reshape_is_allowed_on_container(struct supertype *st,
 		}
 		st->ss->getinfo_super(st, info);
 
-		if (raid_disks < info->array.raid_disks) {
+		if (geo->raid_disks < info->array.raid_disks) {
 			/* we work on container for Online Capacity Expansion
 			 * only so raid_disks has to grow
 			 */
@@ -6892,7 +6902,8 @@ int imsm_reshape_is_allowed_on_container(struct supertype *st,
 			break;
 		}
 		used_disks = imsm_num_data_members(dev, 0);
-		dprintf("read raid_disks =%i\n", used_disks);
+		dprintf("read raid_disks = %i\n", used_disks);
+		dprintf("read requested disks = %i\n", geo->raid_disks);
 		array_blocks = map->blocks_per_member * used_disks;
 		/* round array size down to closest MB
 		 */
@@ -6900,7 +6911,7 @@ int imsm_reshape_is_allowed_on_container(struct supertype *st,
 		if (sysfs_set_num(info, NULL, "array_size", array_blocks/2) < 0)
 			dprintf("cannot set array size to %llu\n", array_blocks/2);
 
-		if (raid_disks > info->array.raid_disks)
+		if (geo->raid_disks > info->array.raid_disks)
 			devices_that_can_grow++;
 
 		if ((info->array.level != 0) &&
@@ -6913,9 +6924,9 @@ int imsm_reshape_is_allowed_on_container(struct supertype *st,
 			/* check for platform support for this raid level configuration
 			 */
 			struct intel_super *super = st->sb;
-			if (!is_raid_level_supported(super->orom,  info->array.level, raid_disks)) {
+			if (!is_raid_level_supported(super->orom,  info->array.level, geo->raid_disks)) {
 				dprintf("platform does not support raid%d with %d disk%s\n",
-					 info->array.level, raid_disks, raid_disks > 1 ? "s" : "");
+					 info->array.level, geo->raid_disks, geo->raid_disks > 1 ? "s" : "");
 				break;
 			}
 		}
@@ -7051,6 +7062,106 @@ abort:
 	return ret_val;
 }
 
+/*****************************************************************************
+ * Function: update_geometry
+ * Description: Prepares imsm volume map update in case of volume reshape
+ * Returns: 0 on success, -1 if fail
+ * ***************************************************************************/
+int update_geometry(struct supertype *st,
+		    struct geo_params *geo)
+{
+	int fd = -1, ret_val = -1;
+	struct mdinfo *sra = NULL;
+	char buf[PATH_MAX];
+	char supported = 1;
+
+	snprintf(buf, PATH_MAX, "/dev/md%i", geo->dev_id);
+	fd = open(buf , O_RDONLY | O_DIRECT);
+	if (fd < 0) {
+		dprintf("imsm: cannot open device\n");
+		return -1;
+	}
+
+	sra = sysfs_read(fd, 0, GET_DISKS | GET_LAYOUT | GET_CHUNK | GET_SIZE | GET_LEVEL | GET_DEVS);
+	if (!sra) {
+		dprintf("imsm: Cannot get mdinfo!\n");
+		goto update_geometry_exit;
+	}
+
+	if (sra->devs == NULL) {
+		dprintf("imsm: Cannot load device information.\n");
+		goto update_geometry_exit;
+	}
+	/* is size change possible??? */
+	if (((unsigned long long)geo->size != sra->devs->component_size) && (geo->size != UnSet) && (geo->size > 0)) {
+		geo->size = sra->devs->component_size;
+		dprintf("imsm: Change the array size not supported in imsm!\n");
+		goto update_geometry_exit;
+	}
+
+	if ((geo->level != sra->array.level) && (geo->level >= 0) && (geo->level != UnSet)) {
+		switch (sra->array.level) {
+		case 0:
+			if (geo->level != 5)
+				supported = 0;
+			break;
+		case 5:
+			if (geo->level != 0)
+				supported = 0;
+			break;
+		case 1:
+			if ((geo->level != 5) || (geo->level != 0))
+				supported = 0;
+			break;
+		case 10:
+			if (geo->level != 5)
+				supported = 0;
+			break;
+		default:
+			supported = 0;
+			break;
+		}
+		if (!supported) {
+			dprintf("imsm: Error. Level Migration from %d to %d not supported!\n", sra->array.level, geo->level);
+			goto update_geometry_exit;
+		}
+	} else {
+		geo->level = sra->array.level;
+	}
+
+	if ((geo->layout != sra->array.layout) && ((geo->layout != UnSet) && (geo->layout != -1))) {
+		if ((sra->array.layout == 0) && (sra->array.level == 5) && (geo->layout == 5)) {
+			/* reshape 5 -> 4 */
+			geo->raid_disks++;
+		} else if ((sra->array.layout == 5) && (sra->array.level == 5) && (geo->layout == 0)) {
+			/* reshape 4 -> 5 */
+			geo->layout = 0;
+			geo->level = 5;
+		} else {
+			dprintf("imsm: Error. Layout Migration from %d to %d not supported!\n", sra->array.layout, geo->layout);
+			ret_val = -1;
+			goto update_geometry_exit;
+		}
+	}
+
+	if ((geo->chunksize == 0) || (geo->chunksize == UnSet))
+	    geo->chunksize = sra->array.chunk_size;
+
+	if (!validate_geometry_imsm(st, geo->level, geo->layout, geo->raid_disks,
+					geo->chunksize,  geo->size,
+					0, 0, 1))
+		goto update_geometry_exit;
+
+	ret_val = 0;
+
+update_geometry_exit:
+	sysfs_free(sra);
+	if (fd > -1)
+		close(fd);
+
+	return ret_val;
+}
+
 /******************************************************************************
  * function: imsm_create_metadata_update_for_reshape
  * Function creates update for whole IMSM container.
@@ -7058,7 +7169,7 @@ abort:
  * when reshape will be triggered and md sets slot numbers.
  * Slot numbers in metadata will be updated with stage_2 update
  ******************************************************************************/
-struct imsm_update_reshape *imsm_create_metadata_update_for_reshape(struct supertype *st, int raid_disks, int imsm_volume)
+struct imsm_update_reshape *imsm_create_metadata_update_for_reshape(struct supertype *st, struct geo_params *geo)
 {
 	struct imsm_update_reshape *ret_val = NULL;
 	struct intel_super *super = st->sb;
@@ -7074,12 +7185,12 @@ struct imsm_update_reshape *imsm_create_metadata_update_for_reshape(struct super
 	int device_size;
 	void *upd_devs;
 
-	dprintf("imsm imsm_update_metadata_for_reshape(enter) raid_disks = %i\n", raid_disks);
+	dprintf("imsm imsm_update_metadata_for_reshape(enter) raid_disks = %i\n", geo->raid_disks);
 
-	if ((raid_disks < super->anchor->num_disks) ||
-	    (raid_disks == UnSet))
-		raid_disks = super->anchor->num_disks;
-	delta_disks = raid_disks - super->anchor->num_disks;
+	if ((geo->raid_disks < super->anchor->num_disks) ||
+	    (geo->raid_disks == UnSet))
+		geo->raid_disks = super->anchor->num_disks;
+	delta_disks = geo->raid_disks - super->anchor->num_disks;
 
 	/* size of all update data without anchor */
 	update_memory_size = sizeof(struct imsm_update_reshape);
@@ -7088,7 +7199,7 @@ struct imsm_update_reshape *imsm_create_metadata_update_for_reshape(struct super
 	 */
 	device_size = sizeof(struct imsm_dev);
 	device_size += sizeof(struct imsm_map);
-	device_size += 2*(raid_disks - 1) * sizeof(__u32);
+	device_size += 2 * (geo->raid_disks - 1) * sizeof(__u32);
 
 	update_memory_size += device_size * super->anchor->num_raid_devs;
 	if (delta_disks > 1) {
@@ -7121,7 +7232,7 @@ struct imsm_update_reshape *imsm_create_metadata_update_for_reshape(struct super
 			break;
 
 		find_array_minor((char *)old_dev->volume, 1, st->devnum, &devnum);
-		if (devnum == imsm_volume) {
+		if (devnum == geo->dev_id) {
 			__u8 to_state;
 			struct imsm_map *new_map2;
 			int idx;
@@ -7130,7 +7241,7 @@ struct imsm_update_reshape *imsm_create_metadata_update_for_reshape(struct super
 			imsm_copy_dev(upd_devs, old_dev);
 			new_map = get_imsm_map(upd_devs, 0);
 			old_disk_number = new_map->num_members;
-			new_map->num_members = raid_disks;
+			new_map->num_members = geo->raid_disks;
 			u->reshape_delta_disks = new_map->num_members - old_disk_number;
 			/* start migration on new device
 			 * it puts second map there also
@@ -7150,7 +7261,7 @@ struct imsm_update_reshape *imsm_create_metadata_update_for_reshape(struct super
 					for (idx = new_map2->num_members; idx < new_map->num_members; idx++)
 						set_imsm_ord_tbl_ent(new_map, idx, idx);
 				}
-				u->devnum = imsm_volume;
+				u->devnum = geo->dev_id;
 				break;
 			}
 		}
@@ -7322,10 +7433,20 @@ int imsm_reshape_super(struct supertype *st, long long size, int level,
 	struct mdinfo *sra = NULL;
 	int fd = -1;
 	char buf[PATH_MAX];
+	struct geo_params geo;
+
+	memset(&geo, sizeof (struct geo_params), 0);
+
+	geo.dev_name = dev;
+	geo.size = size;
+	geo.level = level;
+	geo.layout = layout;
+	geo.chunksize = chunksize;
+	geo.raid_disks = raid_disks;
 
 	dprintf("imsm: reshape_super called().\n");
-	dprintf("\tfor level      : %i\n", level);
-	dprintf("\tfor raid_disks : %i\n", raid_disks);
+	dprintf("\tfor level      : %i\n", geo.level);
+	dprintf("\tfor raid_disks : %i\n", geo.raid_disks);
 
 	if (experimental() == 0)
 		return ret_val;
@@ -7341,38 +7462,44 @@ int imsm_reshape_super(struct supertype *st, long long size, int level,
 	 * on container level we can do almost  everything */
 	if (st->subarray[0] == 0) {
 		/* check for delta_disks > 0 and supported raid levels 0 and 5 only in container */
-		if (imsm_reshape_is_allowed_on_container(st, size, level, layout, chunksize, raid_disks)) {
+		if (imsm_reshape_is_allowed_on_container(st, &geo)) {
 			struct imsm_update_reshape *u;
 			char *array;
 
-			array = get_volume_for_olce(st, raid_disks);
+			array = get_volume_for_olce(st, geo.raid_disks);
 			if (array) {
-				int devnum = -1;
-				find_array_minor(array, 1, st->devnum, &devnum);
-				if (devnum > 0) {
+				find_array_minor(array, 1, st->devnum, &geo.dev_id);
+				if (geo.dev_id > 0) {
 					dprintf("imsm: Preparing metadata update for: %s\n", array);
 
 					st->update_tail = &st->updates;
-					u = imsm_create_metadata_update_for_reshape(st, raid_disks, devnum);
+					u = imsm_create_metadata_update_for_reshape(st, &geo);
 
 					if (u) {
 						ret_val = 0;
 						append_metadata_update(st, u, u->update_memory_size);
-					}
-				}
+					} else
+						dprintf("imsm: Cannot prepare update\n");
+				} else
+					dprintf("imsm: Cannot find array in container\n");
 				free(array);
 			}
-		}
+		} else
+			dprintf("imsm: Operation is not allowed on container\n");
 		if (ret_val)
 			unfreeze_container(st);
 		*st->subarray = 0;
 		goto imsm_reshape_super_exit;
-	}
+	} else
+		dprintf("imsm: not a container operation\n");
+
+	geo.dev_id = -1;
+	find_array_minor(geo.dev_name, 1, st->devnum, &geo.dev_id);
 
 	/* we have volume so takeover can be performed for single volume only
 	 */
-	if ((size == -1) && (layout == UnSet) && (raid_disks == 0) && (level != UnSet)) {
-
+	if ((geo.size == -1) && (geo.layout == UnSet) && (geo.raid_disks == 0) && (geo.level != UnSet) &&
+	    (geo.dev_id > -1)) {
 		/* ok - this is takeover */
 		int container_fd;
 		int dn;
@@ -7400,9 +7527,9 @@ int imsm_reshape_super(struct supertype *st, long long size, int level,
 		 * to/from different than raid10 level
 		 * if source level is raid0 mdmon is sterted only
 		 */
-		if (((level == 10) || (sra->array.level == 10) || (sra->array.level == 0)) &&
-		     (level != sra->array.level) &&
-		     (level > 0)) {
+		if (((geo.level == 10) || (sra->array.level == 10) || (sra->array.level == 0)) &&
+		     (geo.level != sra->array.level) &&
+		     (geo.level > 0)) {
 			st->update_tail = &st->updates;
 			err = update_level_imsm(st, sra, sra->name, 0, 0, NULL);
 			if (err != 0) {
@@ -8039,17 +8166,17 @@ int imsm_manage_container_reshape(struct supertype *st)
 	char buf[PATH_MAX];
 	struct intel_super *super = st->sb;
 	struct imsm_super *mpb = super->anchor;
-	char *devname;
 	int fd;
 	struct mdinfo *info = NULL;
 	struct mdinfo info2;
 	int validate_fd;
-	int current_array;
-	int delta_disks, raid_disks;
+	int delta_disks;
+	struct geo_params geo;
 #ifdef DEBUG
 	int i;
 #endif
 
+	memset(&geo, sizeof (struct geo_params), 0);
 	/* verify reshape conditions
 	 * for single vlolume reshape exit only and reuse Grow_reshape() code
 	 */
@@ -8059,24 +8186,23 @@ int imsm_manage_container_reshape(struct supertype *st)
 		return ret_val;
 	}
 
-	devname = devnum2devname(st->devnum);
-	if (devname == NULL) {
-		dprintf("imsm: Error: imsm_manage_container_reshape(): cannot get device name.\n");
+	geo.dev_name = devnum2devname(st->devnum);
+	if (geo.dev_name == NULL) {
+		dprintf("imsm: Error: imsm_manage_reshape(): cannot get device name.\n");
 		return ret_val;
 	}
 
-	snprintf(buf, PATH_MAX, "/dev/%s", devname);
+	snprintf(buf, PATH_MAX, "/dev/%s", geo.dev_name);
 	fd = open(buf , O_RDONLY | O_DIRECT);
 	if (fd < 0) {
 		dprintf("imsm: cannot open device\n");
-		free(devname);
-		return ret_val;
+		goto imsm_manage_container_reshape_exit;
 	}
 
 	/* send pings to roll managemon and monitor
 	 */
-	ping_manager(devname);
-	ping_monitor(devname);
+	ping_manager(geo.dev_name);
+	ping_monitor(geo.dev_name);
 
 #ifdef DEBUG
 	/* device list for reshape
@@ -8090,22 +8216,22 @@ int imsm_manage_container_reshape(struct supertype *st)
 
 	info2.devs = NULL;
 	st->ss->getinfo_super(st, &info2);
-	current_array = -1;
-	find_array_minor(info2.name, 1, st->devnum, &current_array);
-	if (current_array < 0) {
+	geo.dev_id = -1;
+	find_array_minor(info2.name, 1, st->devnum, &geo.dev_id);
+	if (geo.dev_id < 0) {
 		dprintf("imsm. Error.Cannot get first array.\n");
 		goto imsm_manage_container_reshape_exit;
 	}
-	if (imsm_check_reshape_conditions(fd, st, current_array)) {
+	if (imsm_check_reshape_conditions(fd, st, geo.dev_id)) {
 		dprintf("imsm. Error. Wrong reshape conditions.\n");
 		goto imsm_manage_container_reshape_exit;
 	}
-	raid_disks = info2.array.raid_disks;
+	geo.raid_disks = info2.array.raid_disks;
 	dprintf("Container is ready for reshape ...\n");
 	switch (fork()) {
 	case 0:
 		fprintf(stderr, Name ": Child forked to run and monitor reshape\n");
-		while (current_array > -1) {
+		while (geo.dev_id > -1) {
 			int fd2 = -1;
 			int i;
 			int temp_array = -1;
@@ -8123,11 +8249,11 @@ int imsm_manage_container_reshape(struct supertype *st)
 				st->ss->getinfo_super(st, &info2);
 				dprintf("Checking slots for device %s\n", info2.sys_name);
 				find_array_minor(info2.name, 1, st->devnum, &temp_array);
-				if (temp_array == current_array)
+				if (temp_array == geo.dev_id)
 					break;
 			}
 			snprintf(buf, PATH_MAX, "/dev/%s", info2.sys_name);
-			dprintf("Prepare to reshape for device %s (md%i)\n", info2.sys_name, current_array);
+			dprintf("Prepare to reshape for device %s (md%i)\n", info2.sys_name, geo.dev_id);
 			fd2 = open(buf, O_RDWR | O_DIRECT);
 			if (fd2 < 0) {
 				dprintf("Reshape is broken (cannot open array)\n");
@@ -8160,7 +8286,7 @@ int imsm_manage_container_reshape(struct supertype *st)
 				     /* or this array was already reshaped */
 				     (strncmp(buf, "none", 4) == 0)) {
 					dprintf("Skip this array, sync_completed is %s\n", buf);
-					current_array = -1;
+					geo.dev_id = -1;
 					sysfs_free(info);
 					info = NULL;
 					close(fd2);
@@ -8176,10 +8302,10 @@ int imsm_manage_container_reshape(struct supertype *st)
 			snprintf(buf, PATH_MAX, "/dev/md/%s", info2.name);
 			info->delta_disks = info2.delta_disks;
 
-			delta_disks = info->array.raid_disks - raid_disks;
-			raid_disks = info->array.raid_disks;
+			delta_disks = info->array.raid_disks - geo.raid_disks;
+			geo.raid_disks = info->array.raid_disks;
 			if (info->array.level == 4) {
-				raid_disks--;
+				geo.raid_disks--;
 				delta_disks--;
 			}
 
@@ -8195,37 +8321,37 @@ int imsm_manage_container_reshape(struct supertype *st)
 				ret_val = 1;
 				goto imsm_manage_container_reshape_exit;
 			}
-			current_array = -1;
+			geo.dev_id = -1;
 			sprintf(st->subarray, "%i", 0);
-			array = get_volume_for_olce(st, raid_disks);
+			array = get_volume_for_olce(st, geo.raid_disks);
 			if (array) {
 				struct imsm_update_reshape *u;
 				dprintf("imsm: next volume to reshape is: %s\n", array);
 				info2.devs = NULL;
 				st->ss->getinfo_super(st, &info2);
-				find_array_minor(info2.name, 1, st->devnum, &current_array);
-				if (current_array > -1) {
+				find_array_minor(info2.name, 1, st->devnum, &geo.dev_id);
+				if (geo.dev_id > -1) {
 					/* send next array update
 					 */
-					dprintf("imsm: Preparing metadata update for: %s (md%i)\n", array, current_array);
+					dprintf("imsm: Preparing metadata update for: %s (md%i)\n", array, geo.dev_id);
 					st->update_tail = &st->updates;
-					u = imsm_create_metadata_update_for_reshape(st, raid_disks, current_array);
+					u = imsm_create_metadata_update_for_reshape(st, &geo);
 					if (u) {
 						u->reshape_delta_disks = delta_disks;
 						append_metadata_update(st, u, u->update_memory_size);
 						flush_metadata_updates(st);
 						/* send pings to roll managemon and monitor
 						 */
-						ping_manager(devname);
-						ping_monitor(devname);
+						ping_manager(geo.dev_name);
+						ping_monitor(geo.dev_name);
 
-						if (imsm_check_reshape_conditions(fd, st, current_array)) {
+						if (imsm_check_reshape_conditions(fd, st, geo.dev_id)) {
 							dprintf("imsm. Error. Wrong reshape conditions.\n");
 							ret_val = 1;
-							current_array = -1;
+							geo.dev_id = -1;
 						}
 					} else
-						current_array = -1;
+						geo.dev_id = -1;
 				}
 				free(array);
 			}
@@ -8244,10 +8370,11 @@ int imsm_manage_container_reshape(struct supertype *st)
 	}
 
 imsm_manage_container_reshape_exit:
-	free(devname);
 	sysfs_free(info);
 	if (fd > -1)
 		close(fd);
+	if (geo.dev_name)
+		free(geo.dev_name);
 
 	return ret_val;
 }

