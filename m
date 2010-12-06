From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 03/27] imsm: Prepare reshape_update in mdadm
Date: Mon, 06 Dec 2010 14:21:08 +0100
Message-ID: <20101206132108.21125.54920.stgit@gklab-170-024.igk.intel.com>
References: <20101206131821.21125.65217.stgit@gklab-170-024.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101206131821.21125.65217.stgit@gklab-170-024.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

During Online Capacity Expansion metadata has to be updated to show
array changes and allow for future assembly of array.
To do this mdadm prepares and sends reshape_update metadata update to mdmon.
Update is sent for one array in container. It contains updated device
and spares that have to be turned in to array members.
For spares we have 2 cases:
1. For first array in container:
   reshape_delta_disks: shows how many disks will be added to array
   Spares are sent in update so variable spares_in_update in metadata update tells that mdmon has to turn spares in to array
   (IMSM's array meaning) members.
2. For 2nd array in container:
   reshape_delta_disks: shows how many disks will be added to array -exactly as in first case
   Spares were turned in to array members (they are not a spares) so we have for this volume
   reuse those disks only.

This update will change active array state to reshape_is_starting state.
This works in the following way:
1. reshape_super() prepares metadata update and send it to mdmon
2. managemon in prepare_update() allocates required memory for bigger device object
3. monitor in process_update() updates (replaces) device object with information
   passed from mdadm (memory was allocated by managemon)
4. process_update() function performs:
   - sets reshape_delta_disks variable to reshape_delta_disks value from update
   - sets array in to reshape_is_starting state.
5. This signals managemon to add devices to md and start reshape for this array
   and put array in to reshape_in_progress.
   Managemon can request reshape_cancel_request state in error case.

Signed-off-by: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 mdadm.h       |    3 
 mdmon.c       |   13 +
 super-intel.c |  669 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 sysfs.c       |  169 ++++++++++++++
 util.c        |  147 +++++++++++++
 5 files changed, 1001 insertions(+), 0 deletions(-)

diff --git a/mdadm.h b/mdadm.h
index 175d228..423f62c 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -494,6 +494,7 @@ extern int reshape_open_backup_file(char *backup,
 				    unsigned long long *offsets);
 extern unsigned long compute_backup_blocks(int nchunk, int ochunk,
 					   unsigned int ndata, unsigned int odata);
+extern struct mdinfo *sysfs_get_unused_spares(int container_fd, int fd);
 
 extern int save_stripes(int *source, unsigned long long *offsets,
 			int raid_disks, int chunk_size, int level, int layout,
@@ -1060,6 +1061,8 @@ extern int conf_name_is_free(char *name);
 extern int devname_matches(char *name, char *match);
 extern struct mddev_ident *conf_match(struct mdinfo *info, struct supertype *st);
 extern int experimental(void);
+extern int find_array_minor(char *text_version, int external, int container, int *minor);
+extern int find_array_minor2(char *text_version, int external, int container, int *minor);
 
 extern void free_line(char *line);
 extern int match_oneof(char *devices, char *devname);
diff --git a/mdmon.c b/mdmon.c
index f56e57f..413ee29 100644
--- a/mdmon.c
+++ b/mdmon.c
@@ -517,3 +517,16 @@ static int mdmon(char *devname, int devnum, int must_fork, int takeover)
 
 	exit(0);
 }
+
+/* Below there are some dummy functions needed for compilation but not used by mdmon
+ */
+
+void map_read(struct map_ent **melp)
+{
+	*melp = NULL;
+}
+
+void map_free(struct map_ent *map)
+{
+}
+
diff --git a/super-intel.c b/super-intel.c
index 2943898..ae2f567 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -285,6 +285,7 @@ enum imsm_update_type {
 	update_kill_array,
 	update_rename_array,
 	update_add_disk,
+	update_reshape,
 };
 
 struct imsm_update_activate_spare {
@@ -295,6 +296,43 @@ struct imsm_update_activate_spare {
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
+
+struct imsm_update_reshape {
+	enum imsm_update_type type;
+	int update_memory_size;
+	int reshape_delta_disks;
+	int disks_count;
+	int spares_in_update;
+	int devnum;
+	/* pointers to memory that will be allocated
+	 * by manager during prepare_update()
+	 */
+	struct intel_dev devs_mem;
+	/* status of update preparation
+	 */
+	int update_prepared;
+	/* anchor data prepared by mdadm */
+	int upd_devs_offset;
+	int device_size;
+	struct dl upd_disks[1];
+	/* here goes added spares
+	 */
+	/* and here goes imsm_devs pointed by upd_devs
+	 * devs are put here as row data every device_size bytes
+	 *
+	 */
+};
+
 struct disk_info {
 	__u8 serial[MAX_RAID_SERIAL_LEN];
 };
@@ -5236,6 +5274,7 @@ static int disks_overlap(struct intel_super *super, int idx, struct imsm_update_
 }
 
 static void imsm_delete(struct intel_super *super, struct dl **dlp, unsigned index);
+int imsm_get_new_device_name(struct dl *dl);
 
 static void imsm_process_update(struct supertype *st,
 			        struct metadata_update *update)
@@ -5271,6 +5310,9 @@ static void imsm_process_update(struct supertype *st,
 	mpb = super->anchor;
 
 	switch (type) {
+	case update_reshape: {
+		break;
+	}
 	case update_activate_spare: {
 		struct imsm_update_activate_spare *u = (void *) update->buf; 
 		struct imsm_dev *dev = get_imsm_dev(super, u->array);
@@ -5590,6 +5632,9 @@ static void imsm_prepare_update(struct supertype *st,
 	size_t len = 0;
 
 	switch (type) {
+	case update_reshape: {
+		break;
+	}
 	case update_create_array: {
 		struct imsm_update_create_array *u = (void *) update->buf;
 		struct intel_dev *dv;
@@ -5743,6 +5788,629 @@ static const char *imsm_get_disk_controller_domain(const char *path)
 		return NULL;
 }
 
+int imsm_reshape_is_allowed_on_container(struct supertype *st,
+					 struct geo_params *geo)
+{
+	int ret_val = 0;
+	struct mdinfo *info = NULL;
+	char buf[PATH_MAX];
+	int fd = -1;
+	int device_num = -1;
+	int devices_that_can_grow = 0;
+
+	dprintf("imsm: imsm_reshape_is_allowed_on_container(ENTER): st->devnum = (%i)\n", st->devnum);
+
+	if (geo == NULL ||
+	    (geo->size != -1) || (geo->level != UnSet) ||
+	    (geo->layout != UnSet) || (geo->chunksize != 0)) {
+		dprintf("imsm: Container operation is allowed for raid disks number change only.\n");
+		return ret_val;
+	}
+
+	snprintf(buf, PATH_MAX, "/dev/md%i", st->devnum);
+	dprintf("imsm: open device (%s)\n", buf);
+	fd = open(buf , O_RDONLY | O_DIRECT);
+	if (fd < 0) {
+		dprintf("imsm: cannot open device\n");
+		return ret_val;
+	}
+
+	if (geo->raid_disks == UnSet) {
+		dprintf("imsm: for container operation raid disks change is required\n");
+		goto exit_imsm_reshape_is_allowed_on_container;
+	}
+
+	device_num = 0; /* start from first device (skip container info) */
+	while (device_num > -1) {
+		int result;
+		int minor;
+		unsigned long long array_blocks;
+		struct imsm_map *map = NULL;
+		struct imsm_dev *dev = NULL;
+		struct intel_super *super = NULL;
+		int used_disks;
+
+
+		dprintf("imsm: checking device_num: %i\n", device_num);
+		super = st->sb;
+		super->current_vol = device_num;
+		st->ss->load_super(st, fd, NULL);
+		if (st->sb == NULL) {
+			if (device_num == 0) {
+				/* for the first checked device this is error
+				   there should be at least one device to check
+				 */
+				dprintf("imsm: error: superblock is NULL during container operation\n");
+			} else {
+				dprintf("imsm: no more devices to check, number of forund devices: %i\n",
+					devices_that_can_grow);
+				/* check if any device in container can be groved
+				 */
+				if (devices_that_can_grow)
+					ret_val = 1;
+			}
+			break;
+		}
+		info = sysfs_read(fd, 0, GET_LEVEL|GET_VERSION|GET_DEVS|GET_STATE);
+		if (info == NULL) {
+			dprintf("imsm: Cannot get device info.\n");
+			break;
+		}
+		super = st->sb;
+		super->current_vol = device_num;
+		st->ss->getinfo_super(st, info, NULL);
+		if ((info->name == NULL) ||
+		    (strlen(info->name) == 0)) {
+			/* no more to load
+			 */
+			dprintf("imsm: no more devices to check, number of forund devices: %i\n",
+				devices_that_can_grow);
+			/* check if any device in container can be groved
+				 */
+			if (devices_that_can_grow)
+				ret_val = 1;
+			break;
+		}
+
+		if (geo->raid_disks < info->array.raid_disks) {
+			/* we work on container for Online Capacity Expansion
+			 * only so raid_disks has to grow
+			 */
+			dprintf("imsm: for container operation raid disks increase is required\n");
+			break;
+		}
+		/* check if size is set corectly
+		 * wrong conditions could happend when previous reshape wes interrupted
+		 */
+		super = st->sb;
+		dev = get_imsm_dev(super, device_num);
+		if (dev == NULL) {
+			dprintf("cannot get imsm device\n");
+			ret_val = 0;
+			break;
+		}
+		map = get_imsm_map(dev, 0);
+		if (dev == NULL) {
+			dprintf("cannot get imsm device map\n");
+			ret_val = 0;
+			break;
+		}
+		used_disks = imsm_num_data_members(dev);
+		dprintf("read raid_disks = %i\n", used_disks);
+		dprintf("read requested disks = %i\n", geo->raid_disks);
+		array_blocks = map->blocks_per_member * used_disks;
+		/* round array size down to closest MB
+		 */
+		array_blocks = (array_blocks >> SECT_PER_MB_SHIFT) << SECT_PER_MB_SHIFT;
+		if (sysfs_set_num(info, NULL, "array_size", array_blocks/2) < 0)
+			dprintf("cannot set array size to %llu\n", array_blocks/2);
+
+		if (geo->raid_disks > info->array.raid_disks)
+			devices_that_can_grow++;
+
+		if ((info->array.level != 0) &&
+		    (info->array.level != 5)) {
+			/* we cannot use this container other raid level
+			 */
+			dprintf("imsm: for container operation wrong raid level (%i) detected\n", info->array.level);
+			break;
+		} else {
+			/* check for platform support for this raid level configuration
+			 */
+			struct intel_super *super = st->sb;
+			if (!is_raid_level_supported(super->orom,  info->array.level, geo->raid_disks)) {
+				dprintf("platform does not support raid%d with %d disk%s\n",
+					 info->array.level, geo->raid_disks, geo->raid_disks > 1 ? "s" : "");
+				break;
+			}
+		}
+
+		/* all raid5 and raid0 volumes in container
+		 * has to be ready for Online Capacity Expansion
+		 */
+		result = find_array_minor2(info->text_version, st->ss->external, st->devnum, &minor);
+		if (result < 0) {
+			dprintf("imsm: cannot find array\n");
+			break;
+		}
+		sprintf(info->sys_name, "md%i", minor);
+		if (sysfs_get_str(info, NULL, "array_state", buf, 20) <= 0) {
+			dprintf("imsm: cannot read array state\n");
+			break;
+		}
+		if ((strncmp(buf, "clean", 5) != 0) &&
+		    (strncmp(buf, "clear", 5) != 0) &&
+		    (strncmp(buf, "active", 6) != 0)) {
+			int index = strlen(buf) - 1;
+
+			if (index < 0)
+				index = 0;
+			*(buf + index) = 0;
+			fprintf(stderr, "imsm: Error: Array %s is not in proper state (current state: %s). Cannot continue.\n", info->sys_name, buf);
+			break;
+		}
+		if (info->array.level > 0) {
+			if (sysfs_get_str(info, NULL, "sync_action", buf, 20) <= 0) {
+				dprintf("imsm: for container operation no sync action\n");
+				break;
+			}
+			/* check if any reshape is not in progress
+			 */
+			if (strncmp(buf, "reshape", 7) == 0) {
+				dprintf("imsm: for container operation reshape is currently in progress\n");
+				break;
+			}
+		}
+		sysfs_free(info);
+		info = NULL;
+		device_num++;
+	}
+	sysfs_free(info);
+	info = NULL;
+
+exit_imsm_reshape_is_allowed_on_container:
+	if (fd >= 0)
+		close(fd);
+
+	dprintf("imsm: imsm_reshape_is_allowed_on_container(Exit) device_num = %i, ret_val = %i\n", device_num, ret_val);
+	if (ret_val)
+		dprintf("\tContainer operation allowed\n");
+	else
+		dprintf("\tError: %i\n", ret_val);
+
+	return ret_val;
+}
+
+struct mdinfo *get_spares_imsm(int devnum)
+{
+	int fd = -1;
+	char buf[PATH_MAX];
+	struct mdinfo *info = NULL;
+	struct mdinfo *ret_val = NULL;
+	int cont_id = -1;
+	struct supertype *st = NULL;
+	int find_result;
+	struct intel_super *super = NULL;
+
+	dprintf("imsm: get_spares_imsm for device: %i.\n", devnum);
+
+	sprintf(buf, "/dev/md%i", devnum);
+	dprintf("try to read container %s\n", buf);
+
+	cont_id = open(buf, O_RDONLY);
+	if (cont_id < 0) {
+		dprintf("imsm: ERROR: Cannot open container.\n");
+		goto abort;
+	}
+
+	/* get first volume */
+	st = super_by_fd(cont_id, NULL);
+	if (st == NULL) {
+		dprintf("imsm: ERROR: Cannot load container information.\n");
+		goto abort;
+	}
+	sprintf(buf, "/md%i/0", devnum);
+	find_result = find_array_minor2(buf, 1, devnum, &devnum);
+	if (find_result < 0) {
+		dprintf("imsm: ERROR: Cannot find array.\n");
+		goto abort;
+	}
+	sprintf(buf, "/dev/md%i", devnum);
+	fd = open(buf, O_RDONLY);
+	if (fd < 0) {
+		dprintf("imsm: ERROR: Cannot open device.\n");
+		goto abort;
+	}
+	st->ss->load_super(st, cont_id, NULL);
+	if (st->sb == NULL) {
+		dprintf("imsm: ERROR: Cannot load array information.\n");
+		goto abort;
+	}
+	info = sysfs_read(fd, 0, GET_LEVEL | GET_VERSION | GET_DEVS | GET_STATE);
+	if (info == NULL) {
+		dprintf("imsm: Cannot get device info.\n");
+		goto abort;
+	}
+	super = st->sb;
+	super->current_vol = 0;
+	st->ss->getinfo_super(st, info, NULL);
+	sprintf(buf, "/dev/md/%s", info->name);
+	ret_val = sysfs_get_unused_spares(cont_id, fd);
+	if (ret_val == NULL) {
+		dprintf("imsm: ERROR: Cannot get spare devices.\n");
+		goto abort;
+	}
+	if (ret_val->array.spare_disks == 0) {
+		dprintf("imsm: ERROR: No available spares.\n");
+		free(ret_val);
+		ret_val = NULL;
+		goto abort;
+	}
+
+abort:
+	if (st)
+		st->ss->free_super(st);
+	sysfs_free(info);
+	if (fd > -1)
+		close(fd);
+	if (cont_id > -1)
+		close(cont_id);
+
+	return ret_val;
+}
+
+/******************************************************************************
+ * function: imsm_create_metadata_update_for_reshape
+ * Function creates update for whole IMSM container.
+ * Slot number for new devices are guesed only. Managemon will correct them
+ * when reshape will be triggered and md sets slot numbers.
+ * Slot numbers in metadata will be updated with stage_2 update
+ ******************************************************************************/
+struct imsm_update_reshape *imsm_create_metadata_update_for_reshape(struct supertype *st, struct geo_params *geo)
+{
+	struct imsm_update_reshape *ret_val = NULL;
+	struct intel_super *super = st->sb;
+	int update_memory_size = 0;
+	struct imsm_update_reshape *u = NULL;
+	struct imsm_map *new_map = NULL;
+	struct mdinfo *spares = NULL;
+	int i;
+	unsigned long long array_blocks;
+	int used_disks;
+	int delta_disks = 0;
+	struct dl *new_disks;
+	int device_size;
+	void *upd_devs;
+
+	dprintf("imsm imsm_update_metadata_for_reshape(enter) raid_disks = %i\n", geo->raid_disks);
+
+	if ((geo->raid_disks < super->anchor->num_disks) ||
+	    (geo->raid_disks == UnSet))
+		geo->raid_disks = super->anchor->num_disks;
+	delta_disks = geo->raid_disks - super->anchor->num_disks;
+
+	/* size of all update data without anchor */
+	update_memory_size = sizeof(struct imsm_update_reshape);
+	/* add space for all devices,
+	 * then add maps space
+	 */
+	device_size = sizeof(struct imsm_dev);
+	device_size += sizeof(struct imsm_map);
+	device_size += 2 * (geo->raid_disks - 1) * sizeof(__u32);
+
+	update_memory_size += device_size * super->anchor->num_raid_devs;
+	if (delta_disks > 1) {
+		/* now add space for spare disks information
+		 */
+		update_memory_size += sizeof(struct dl) * (delta_disks - 1);
+	}
+
+	u = calloc(1, update_memory_size);
+	if (u == NULL) {
+		dprintf("error: cannot get memory for imsm_update_reshape update\n");
+		return ret_val;
+	}
+	u->reshape_delta_disks = delta_disks;
+	u->update_prepared = -1;
+	u->update_memory_size = update_memory_size;
+	u->type = update_reshape;
+	u->spares_in_update = 0;
+	u->upd_devs_offset =  sizeof(struct imsm_update_reshape) + sizeof(struct dl) * (delta_disks - 1);
+	upd_devs = (struct imsm_dev *)((void *)u + u->upd_devs_offset);
+	u->device_size = device_size;
+
+	for (i = 0; i < super->anchor->num_raid_devs; i++) {
+		struct imsm_dev *old_dev = __get_imsm_dev(super->anchor, i);
+		int old_disk_number;
+		int devnum = -1;
+
+		u->devnum = -1;
+		if (old_dev == NULL)
+			break;
+
+		find_array_minor((char *)old_dev->volume, 1, st->devnum, &devnum);
+		if (devnum == geo->dev_id) {
+			__u8 to_state;
+			struct imsm_map *new_map2;
+			int idx;
+
+			new_map = NULL;
+			imsm_copy_dev(upd_devs, old_dev);
+			new_map = get_imsm_map(upd_devs, 0);
+			old_disk_number = new_map->num_members;
+			new_map->num_members = geo->raid_disks;
+			u->reshape_delta_disks = new_map->num_members - old_disk_number;
+			/* start migration on new device
+			 * it puts second map there also
+			 */
+
+			to_state = imsm_check_degraded(super, old_dev, 0);
+			migrate(upd_devs, to_state, MIGR_GEN_MIGR);
+			/* second map length is equal to first map
+			* correct second map length to old value
+			*/
+			new_map2 = get_imsm_map(upd_devs, 1);
+			if (new_map2) {
+				if (new_map2->num_members != old_disk_number) {
+					new_map2->num_members = old_disk_number;
+					/* guess new disk indexes
+					*/
+					for (idx = new_map2->num_members; idx < new_map->num_members; idx++)
+						set_imsm_ord_tbl_ent(new_map, idx, idx);
+				}
+				u->devnum = geo->dev_id;
+				break;
+			}
+		}
+	}
+
+	if (delta_disks <= 0) {
+		dprintf("imsm: reshape without grow (disk add).\n");
+		/* finalize update */
+		goto calculate_size_only;
+	}
+
+	/* now get spare disks list
+	 */
+	spares = get_spares_imsm(st->container_dev);
+
+	if (spares == NULL) {
+		dprintf("imsm: ERROR: Cannot get spare devices.\n");
+		goto exit_imsm_create_metadata_update_for_reshape;
+	}
+	if ((spares->array.spare_disks == 0) ||
+	(u->reshape_delta_disks > spares->array.spare_disks)) {
+		dprintf("imsm: ERROR: No available spares.\n");
+		goto exit_imsm_create_metadata_update_for_reshape;
+	}
+	/* we have got spares
+	 * update disk list in imsm_disk list table in anchor
+	 */
+	dprintf("imsm: %i spares are available.\n\n", spares->array.spare_disks);
+	new_disks = u->upd_disks;
+	for (i = 0; i < u->reshape_delta_disks; i++) {
+		struct mdinfo *dev = spares->devs;
+		__u32 id;
+		int fd;
+		char buf[PATH_MAX];
+		int rv;
+		unsigned long long size;
+
+		sprintf(buf, "%d:%d", dev->disk.major, dev->disk.minor);
+		dprintf("open spare disk %s (%s)\n", buf, dev->sys_name);
+		fd = dev_open(buf, O_RDWR);
+		if (fd < 0) {
+			dprintf("\topen failed\n");
+			goto exit_imsm_create_metadata_update_for_reshape;
+		}
+		if (sysfs_disk_to_scsi_id(fd, &id) == 0)
+			new_disks[i].disk.scsi_id = __cpu_to_le32(id);
+		else
+			new_disks[i].disk.scsi_id = __cpu_to_le32(0);
+		new_disks[i].disk.status = CONFIGURED_DISK;
+		rv = imsm_read_serial(fd, NULL, new_disks[i].disk.serial);
+		if (rv != 0) {
+			dprintf("\tcannot read disk serial\n");
+			close(fd);
+			goto exit_imsm_create_metadata_update_for_reshape;
+		}
+		dprintf("\tdisk serial: %s\n", new_disks[i].disk.serial);
+		get_dev_size(fd, NULL, &size);
+		size /= 512;
+		new_disks[i].disk.total_blocks = __cpu_to_le32(size);
+		new_disks[i].disk.owner_cfg_num = super->anchor->disk->owner_cfg_num;
+
+		new_disks[i].major = dev->disk.major;
+		new_disks[i].minor = dev->disk.minor;
+		/* no relink in update
+		 * use table access
+		 */
+		new_disks[i].next = NULL;
+
+		close(fd);
+		spares->devs = dev->next;
+		u->spares_in_update++;
+
+		free(dev);
+		dprintf("\n");
+	}
+calculate_size_only:
+	/* calculate new size
+	 */
+	if (new_map != NULL) {
+
+		used_disks = imsm_num_data_members(upd_devs);
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
+	}
+
+exit_imsm_create_metadata_update_for_reshape:
+	/* free spares
+	 */
+	if (spares) {
+		while (spares->devs) {
+			struct mdinfo *dev = spares->devs;
+			spares->devs = dev->next;
+			free(dev);
+		}
+		free(spares);
+	}
+
+	if (ret_val == NULL)
+		free(u);
+
+	return ret_val;
+}
+
+char *get_volume_for_olce(struct supertype *st, int raid_disks)
+{
+	char *ret_val = NULL;
+	struct mdinfo *sra = NULL;
+	struct mdinfo info;
+	char *ret_buf;
+	struct intel_super *super = st->sb;
+	int i;
+	int fd = -1;
+	char buf[PATH_MAX];
+
+	snprintf(buf, PATH_MAX, "/dev/md%i", st->devnum);
+	dprintf("imsm: open device (%s)\n", buf);
+	fd = open(buf , O_RDONLY | O_DIRECT);
+	if (fd < 0) {
+		dprintf("imsm: cannot open device\n");
+		return ret_val;
+	}
+
+	ret_buf = malloc(PATH_MAX);
+	if (ret_buf == NULL)
+		goto exit_get_volume_for_olce;
+
+	super = st->sb;
+	for (i = 0; i < super->anchor->num_raid_devs; i++) {
+		struct intel_super *super = NULL;
+
+		st->ss->load_super(st, fd, NULL);
+		if (st->sb == NULL)
+			goto exit_get_volume_for_olce;
+		info.devs = NULL;
+		super = st->sb;
+		super->current_vol = i;
+		st->ss->getinfo_super(st, &info, NULL);
+
+		if (raid_disks > info.array.raid_disks) {
+			snprintf(ret_buf, PATH_MAX,
+				 "%s",  info.name);
+			dprintf("Found device for OLCE requested raid_disks = %i, array raid_disks = %i\n",
+				raid_disks, info.array.raid_disks);
+			ret_val = ret_buf;
+			break;
+		}
+	}
+
+exit_get_volume_for_olce:
+	if ((ret_val == NULL) && ret_buf)
+		free(ret_buf);
+	sysfs_free(sra);
+	if (fd > -1)
+		close(fd);
+
+	return ret_val;
+}
+
+int imsm_reshape_super(struct supertype *st, long long size, int level,
+		       int layout, int chunksize, int raid_disks,
+		       char *backup, char *dev, int verbouse)
+{
+	int ret_val = 1;
+	struct geo_params geo;
+
+	dprintf("imsm: reshape_super called.\n");
+
+	memset(&geo, sizeof (struct geo_params), 0);
+
+	geo.dev_name = dev;
+	geo.size = size;
+	geo.level = level;
+	geo.layout = layout;
+	geo.chunksize = chunksize;
+	geo.raid_disks = raid_disks;
+
+	dprintf("\tfor level      : %i\n", geo.level);
+	dprintf("\tfor raid_disks : %i\n", geo.raid_disks);
+
+	if (experimental() == 0)
+		return ret_val;
+
+	/* verify reshape conditions
+	 * on container level we can do almost  everything */
+	if (st->container_dev == st->devnum) {
+		/* check for delta_disks > 0 and supported raid levels 0 and 5 only in container */
+		if (imsm_reshape_is_allowed_on_container(st, &geo)) {
+			struct imsm_update_reshape *u;
+			char *array;
+
+			array = get_volume_for_olce(st, geo.raid_disks);
+			if (array) {
+				find_array_minor(array, 1, st->devnum, &geo.dev_id);
+				if (geo.dev_id > 0) {
+					dprintf("imsm: Preparing metadata update for: %s\n", array);
+
+					st->update_tail = &st->updates;
+					u = imsm_create_metadata_update_for_reshape(st, &geo);
+
+					if (u) {
+						ret_val = 0;
+						append_metadata_update(st, u, u->update_memory_size);
+					} else
+						dprintf("imsm: Cannot prepare update\n");
+				} else
+					dprintf("imsm: Cannot find array in container\n");
+				free(array);
+			}
+		} else
+			dprintf("imsm: Operation is not allowed on container\n");
+	} else
+		dprintf("imsm: not a container operation\n");
+
+	dprintf("imsm: reshape_super Exit code = %i\n", ret_val);
+	return ret_val;
+}
+
+int imsm_get_new_device_name(struct dl *dl)
+{
+	int rv;
+	char dv[PATH_MAX];
+	char nm[PATH_MAX];
+	char *dname;
+
+	if (dl->devname != NULL)
+		return 0;
+
+	sprintf(dv, "/sys/dev/block/%d:%d", dl->major, dl->minor);
+	memset(nm, 0, sizeof(nm));
+	rv = readlink(dv, nm, sizeof(nm));
+	if (rv > 0) {
+		nm[rv] = '\0';
+		dname = strrchr(nm, '/');
+		if (dname) {
+			char buf[PATH_MAX];
+
+			dname++;
+			sprintf(buf, "/dev/%s", dname);
+			dl->devname = strdup(buf);
+		}
+	}
+
+	return rv;
+}
 
 struct superswitch super_imsm = {
 #ifndef	MDASSEMBLE
@@ -5779,6 +6447,7 @@ struct superswitch super_imsm = {
 	.container_content = container_content_imsm,
 	.default_geometry = default_geometry_imsm,
 	.get_disk_controller_domain = imsm_get_disk_controller_domain,
+	.reshape_super  = imsm_reshape_super,
 
 	.external	= 1,
 	.name = "imsm",
diff --git a/sysfs.c b/sysfs.c
index 7a0403d..366d2db 100644
--- a/sysfs.c
+++ b/sysfs.c
@@ -801,6 +801,175 @@ int sysfs_unique_holder(int devnum, long rdev)
 		return found;
 }
 
+int sysfs_is_spare_device_belongs_to(int fd, char *devname)
+{
+	int ret_val = -1;
+	char fname[PATH_MAX];
+	char *base;
+	char *dbase;
+	struct mdinfo *sra;
+	DIR *dir = NULL;
+	struct dirent *de;
+
+	sra = malloc(sizeof(*sra));
+	if (sra == NULL)
+		goto abort;
+	memset(sra, 0, sizeof(*sra));
+	sysfs_init(sra, fd, -1);
+	if (sra->sys_name[0] == 0)
+		goto abort;
+
+	memset(fname, PATH_MAX, 0);
+	sprintf(fname, "/sys/block/%s/md/", sra->sys_name);
+	base = fname + strlen(fname);
+
+	/* Get all the devices as well */
+	*base = 0;
+	dir = opendir(fname);
+	if (!dir)
+		goto abort;
+	while ((de = readdir(dir)) != NULL) {
+		if (de->d_ino == 0 ||
+		    strncmp(de->d_name, "dev-", 4) != 0)
+			continue;
+		strcpy(base, de->d_name);
+		dbase = base + strlen(base);
+		*dbase = '\0';
+		dbase = strstr(fname, "/md/");
+		if (dbase && strcmp(devname, dbase) == 0) {
+			ret_val = 1;
+			goto abort;
+		}
+	}
+abort:
+	if (dir)
+		closedir(dir);
+	sysfs_free(sra);
+
+	return ret_val;
+}
+
+struct mdinfo *sysfs_get_unused_spares(int container_fd, int fd)
+{
+	char fname[PATH_MAX];
+	char buf[PATH_MAX];
+	char *base;
+	char *dbase;
+	struct mdinfo *ret_val;
+	struct mdinfo *dev;
+	DIR *dir = NULL;
+	struct dirent *de;
+	int is_in;
+	char *to_check;
+
+	ret_val = malloc(sizeof(*ret_val));
+	if (ret_val == NULL)
+		goto abort;
+	memset(ret_val, 0, sizeof(*ret_val));
+	sysfs_init(ret_val, container_fd, -1);
+	if (ret_val->sys_name[0] == 0)
+		goto abort;
+
+	sprintf(fname, "/sys/block/%s/md/", ret_val->sys_name);
+	base = fname + strlen(fname);
+
+	strcpy(base, "raid_disks");
+	if (load_sys(fname, buf))
+		goto abort;
+	ret_val->array.raid_disks = strtoul(buf, NULL, 0);
+
+	/* Get all the devices as well */
+	*base = 0;
+	dir = opendir(fname);
+	if (!dir)
+		goto abort;
+	ret_val->array.spare_disks = 0;
+	while ((de = readdir(dir)) != NULL) {
+		char *ep;
+		if (de->d_ino == 0 ||
+		    strncmp(de->d_name, "dev-", 4) != 0)
+			continue;
+		strcpy(base, de->d_name);
+		dbase = base + strlen(base);
+		*dbase = '\0';
+
+		to_check = strstr(fname, "/md/");
+		is_in = sysfs_is_spare_device_belongs_to(fd, to_check);
+		if (is_in == -1) {
+			char *p;
+			struct stat stb;
+			char stb_name[PATH_MAX];
+
+			dev = malloc(sizeof(*dev));
+			if (!dev)
+				goto abort;
+			strncpy(dev->text_version, fname, 50);
+
+			*dbase++ = '/';
+
+			dev->disk.raid_disk = strtoul(buf, &ep, 10);
+			dev->disk.raid_disk = -1;
+
+			strcpy(dbase, "block/dev");
+			if (load_sys(fname, buf)) {
+				free(dev);
+				continue;
+			}
+			/* check first if we are working on block device
+			 * if not, we cannot check it
+			 */
+			p = strchr(dev->text_version, '-');
+			if (p)
+				p++;
+			sprintf(stb_name, "/dev/%s", p);
+			if (stat(stb_name, &stb) < 0) {
+				dprintf(Name ": stat failed for %s: %s.\n",
+					stb_name, strerror(errno));
+				free(dev);
+				continue;
+			}
+			if (!S_ISBLK(stb.st_mode)) {
+				dprintf(Name ": %s is not a block device. Skip checking.\n",
+					stb_name);
+				goto skip;
+			}
+			dprintf(Name": %s seams to a be block device\n", stb_name);
+			sscanf(buf, "%d:%d", &dev->disk.major, &dev->disk.minor);
+			strcpy(dbase, "block/device/state");
+			if (load_sys(fname, buf) != 0) {
+				free(dev);
+				continue;
+			}
+			if (strncmp(buf, "offline", 7) == 0) {
+				free(dev);
+				continue;
+			}
+			if (strncmp(buf, "failed", 6) == 0) {
+				free(dev);
+				continue;
+			}
+
+skip:
+			/* add this disk to spares list */
+			dev->next = ret_val->devs;
+			ret_val->devs = dev;
+			ret_val->array.spare_disks++;
+			*(dbase-1) = '\0';
+			dprintf("sysfs: found spare: %s [%d:%d]\n",
+				fname, dev->disk.major, dev->disk.minor);
+		}
+	}
+	closedir(dir);
+	return ret_val;
+
+abort:
+	if (dir)
+		closedir(dir);
+	sysfs_free(ret_val);
+
+	return NULL;
+}
+
 int sysfs_freeze_array(struct mdinfo *sra)
 {
 	/* Try to freeze resync/rebuild on this array/container.
diff --git a/util.c b/util.c
index 4b41e2b..7eac1e3 100644
--- a/util.c
+++ b/util.c
@@ -1906,3 +1906,150 @@ int experimental(void)
 	}
 }
 
+int path2devnum(char *pth)
+{
+	char *ep;
+	int fd = -1;
+	char *dev_pth = NULL;
+	char *dev_str;
+	int dev_num = -1;
+
+	fd = open(pth, O_RDONLY);
+	if (fd < 0)
+		return dev_num;
+	close(fd);
+	dev_pth = canonicalize_file_name(pth);
+	if (dev_pth == NULL)
+		return dev_num;
+	dev_str = strrchr(dev_pth, '/');
+	if (dev_str) {
+		while (!isdigit(dev_str[0]))
+			dev_str++;
+		dev_num = strtoul(dev_str, &ep, 10);
+		if (*ep != '\0')
+			dev_num = -1;
+	}
+
+	if (dev_pth)
+		free(dev_pth);
+
+	return dev_num;
+}
+
+extern void map_read(struct map_ent **map);
+extern void map_free(struct map_ent *map);
+int find_array_minor(char *text_version, int external, int container, int *minor)
+{
+	int i;
+	char path[PATH_MAX];
+	struct stat s;
+
+	if (minor == NULL)
+		return -2;
+
+	snprintf(path, PATH_MAX, "/dev/md/%s", text_version);
+	i = path2devnum(path);
+	if (i > -1) {
+		*minor = i;
+		return 0;
+	}
+
+	i = path2devnum(text_version);
+	if (i > -1) {
+		*minor = i;
+		return 0;
+	}
+
+	if (container > 0) {
+		struct map_ent *map = NULL;
+		struct map_ent *m;
+		char cont[PATH_MAX];
+
+		snprintf(cont, PATH_MAX, "/md%i/", container);
+		map_read(&map);
+		for (m = map; m; m = m->next) {
+			int index;
+			unsigned int len = 0;
+			char buf[PATH_MAX];
+
+			/* array have belongs to proper container
+			*/
+			if (strncmp(cont, m->metadata, 6) != 0)
+				continue;
+			/* begin of array name in map have to be the same
+			 * as array name in metadata
+			 */
+			if (strncmp(m->path, path, strlen(path)) != 0)
+				continue;
+			/* array name has to be followed by '_' char
+			 */
+			len = strlen(path);
+			if (*(m->path + len) != '_')
+				continue;
+			/* then we have to have  valid index
+			 */
+			len++;
+			if (strlen(m->path + len) <= 0)
+			    continue;
+			/* index has to be las position in array name
+			 */
+			index = atoi(m->path + strlen(path) + 1);
+			snprintf(buf, PATH_MAX, "%i", index);
+			len += strlen(buf);
+			if (len != strlen(m->path))
+				continue;
+			dprintf("Found %s device based on mdadm maps\n", m->path);
+			*minor = m->devnum;
+			map_free(map);
+			return 0;
+		}
+		map_free(map);
+	}
+
+	for (i = 127; i >= 0; i--) {
+		char buf[PATH_MAX];
+
+		snprintf(path, PATH_MAX, "/sys/block/md%d/md/", i);
+		if (stat(path, &s) != -1) {
+			strcat(path, "metadata_version");
+			if (load_sys(path, buf))
+				continue;
+			if (external) {
+				char *version = strchr(buf, ':');
+				if (version && strcmp(version + 1,
+						      text_version))
+					continue;
+			} else {
+				if (strcmp(buf, text_version))
+					continue;
+			}
+			*minor = i;
+			return 0;
+		}
+	}
+
+	return -1;
+}
+
+/* find_array_minor2 looks for frozen devices also
+ */
+int find_array_minor2(char *text_version, int external, int container, int *minor)
+{
+	int result;
+	char buf[PATH_MAX];
+
+	strcpy(buf, text_version);
+	result = find_array_minor(text_version, external, container, minor);
+	if (result < 0) {
+		/* try to find frozen array also
+		 */
+		char buf[PATH_MAX];
+
+		strcpy(buf, text_version);
+
+		*buf = '-';
+		result = find_array_minor(buf, external, container, minor);
+	}
+	return result;
+}
+

