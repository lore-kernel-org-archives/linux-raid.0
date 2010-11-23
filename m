From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 08/21] imsm: FIX: Continue expansion after -As command
Date: Tue, 23 Nov 2010 13:40:41 +0100
Message-ID: <20101123124041.17770.78436.stgit@gklab-170-024.igk.intel.com>
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

When Online Capacity Expansion is run for 2 volumes on container
and during first reshape reboot occurs, -As mdadm command fill finish
reshape on first volume only. Having 2 arrays in container built
on different disks will violate IMSM compatibility with windows.
To resolve this we have to have ability to finish Expansion for second array also.
This should be done by execution the same container mdadm command.
mdadm should finish work and prepare container that will be compatible with Windows IMSM software.

During running the same command on container, mdadm should:
1. Correct size in md for first volume (finished already)
2. Continue reshape for second volume.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 mdadm/mdadm/Makefile      |    6 ++-
 mdadm/mdadm/mdadm.h       |    4 +-
 mdadm/mdadm/super-intel.c |   90 +++++++++++++++++++++++++++++++++++++--------
 mdadm/mdadm/util.c        |   78 +++++++++++++++++++++++++++++++++------
 4 files changed, 144 insertions(+), 34 deletions(-)

diff --git a/mdadm/mdadm/Makefile b/mdadm/mdadm/Makefile
index 2162039..7e2a058 100644
--- a/mdadm/mdadm/Makefile
+++ b/mdadm/mdadm/Makefile
@@ -112,17 +112,17 @@ SRCS =  mdadm.c config.c mdstat.c  ReadMe.c util.c Manage.c Assemble.c Build.c \
 MON_OBJS = mdmon.o monitor.o managemon.o util.o mdstat.o sysfs.o config.o \
 	Kill.o sg_io.o dlink.o ReadMe.o super0.o super1.o super-intel.o \
 	super-ddf.o sha1.o crc32.o msg.o bitmap.o \
-	platform-intel.o probe_roms.o Grow.o restripe.o
+	platform-intel.o probe_roms.o Grow.o restripe.o mapfile.o
 
 MON_SRCS = mdmon.c monitor.c managemon.c util.c mdstat.c sysfs.c config.c \
 	Kill.c sg_io.c dlink.c ReadMe.c super0.c super1.c super-intel.c \
 	super-ddf.c sha1.c crc32.c msg.c bitmap.c \
-	platform-intel.c probe_roms.c Grow.c restripe.c
+	platform-intel.c probe_roms.c Grow.c restripe.c mapfile.c
 
 STATICSRC = pwgr.c
 STATICOBJS = pwgr.o
 
-ASSEMBLE_SRCS := mdassemble.c Assemble.c Manage.c config.c dlink.c util.c \
+ASSEMBLE_SRCS := mdassemble.c Assemble.c Manage.c config.c dlink.c util.c mapfile.c\
 	super0.c super1.c super-ddf.c super-intel.c sha1.c crc32.c sg_io.c mdstat.c \
 	platform-intel.c probe_roms.c sysfs.c
 ASSEMBLE_AUTO_SRCS := mdopen.c
diff --git a/mdadm/mdadm/mdadm.h b/mdadm/mdadm/mdadm.h
index 844c354..ddff47a 100644
--- a/mdadm/mdadm/mdadm.h
+++ b/mdadm/mdadm/mdadm.h
@@ -968,8 +968,8 @@ extern int devname_matches(char *name, char *match);
 extern struct mddev_ident_s *conf_match(struct mdinfo *info, struct supertype *st);
 extern int read_attr(char *buf, int len, int fd);
 extern int read_dev_state(int fd);
-extern int find_array_minor(char *text_version, int external, int *minor);
-extern int find_array_minor2(char *text_version, int external, int *minor);
+extern int find_array_minor(char *text_version, int external, int container, int *minor);
+extern int find_array_minor2(char *text_version, int external, int container, int *minor);
 extern inline int experimental(void);
 
 extern void free_line(char *line);
diff --git a/mdadm/mdadm/super-intel.c b/mdadm/mdadm/super-intel.c
index 96892ec..945cc94 100644
--- a/mdadm/mdadm/super-intel.c
+++ b/mdadm/mdadm/super-intel.c
@@ -1748,7 +1748,7 @@ static void getinfo_super_imsm_volume(struct supertype *st, struct mdinfo *info)
 
 	/* fill sys_name field
 	 */
-	if (find_array_minor2(info->text_version, 1, &minor) == 0)
+	if (find_array_minor2(info->text_version, 1, st->devnum, &minor) == 0)
 		sprintf(info->sys_name, "md%i", minor);
 
 	/* fill delta_disks field
@@ -1911,7 +1911,7 @@ static void getinfo_super_imsm(struct supertype *st, struct mdinfo *info)
 	}
 	/* fill sys_name field
 	 */
-	if (find_array_minor2(info->text_version, 1, &minor) == 0)
+	if (find_array_minor2(info->text_version, 1, st->devnum, &minor) == 0)
 		sprintf(info->sys_name, "md%i", minor);
 }
 
@@ -6266,6 +6266,7 @@ static void imsm_prepare_update(struct supertype *st,
 			dprintf("imsm: No passed device.\n");
 			break;
 		}
+		dprintf("imsm: reshape delta disks is = %i\n", u->reshape_delta_disks);
 		if (u->reshape_delta_disks < 0)
 			break;
 		u->update_prepared = 1;
@@ -6804,6 +6805,7 @@ int imsm_reshape_is_allowed_on_container(struct supertype *st,
 	char buf[PATH_MAX];
 	int fd = -1;
 	int device_num = -1;
+	int devices_that_can_grow = 0;
 
 	dprintf("imsm: imsm_reshape_is_allowed_on_container(ENTER): st->devnum = (%i)\n", st->devnum);
 
@@ -6830,6 +6832,12 @@ int imsm_reshape_is_allowed_on_container(struct supertype *st,
 	while (device_num > -1) {
 		int result;
 		int minor;
+		unsigned long long array_blocks;
+		struct imsm_map *map = NULL;
+		struct imsm_dev *dev = NULL;
+		struct intel_super *super = NULL;
+		int used_disks;
+
 
 		dprintf("imsm: checking device_num: %i\n", device_num);
 		sprintf(st->subarray, "%i", device_num);
@@ -6841,8 +6849,12 @@ int imsm_reshape_is_allowed_on_container(struct supertype *st,
 				 */
 				dprintf("imsm: error: superblock is NULL during container operation\n");
 			} else {
-				dprintf("imsm: no more devices to check\n");
-				ret_val = 1;
+				dprintf("imsm: no more devices to check, number of forund devices: %i\n",
+					devices_that_can_grow);
+				/* check if any device in container can be groved
+				 */
+				if (devices_that_can_grow)
+					ret_val = 1;
 				/* restore superblock, for last device not loaded */
 				sprintf(st->subarray, "%i", 0);
 				st->ss->load_super(st, fd, NULL);
@@ -6856,13 +6868,40 @@ int imsm_reshape_is_allowed_on_container(struct supertype *st,
 		}
 		st->ss->getinfo_super(st, info);
 
-		if (raid_disks <= info->array.raid_disks) {
+		if (raid_disks < info->array.raid_disks) {
 			/* we work on container for Online Capacity Expansion
 			 * only so raid_disks has to grow
 			 */
 			dprintf("imsm: for container operation raid disks increase is required\n");
 			break;
 		}
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
+		used_disks = imsm_num_data_members(dev, 0);
+		dprintf("read raid_disks =%i\n", used_disks);
+		array_blocks = map->blocks_per_member * used_disks;
+		/* round array size down to closest MB
+		 */
+		array_blocks = (array_blocks >> SECT_PER_MB_SHIFT) << SECT_PER_MB_SHIFT;
+		if (sysfs_set_num(info, NULL, "array_size", array_blocks/2) < 0)
+			dprintf("cannot set array size to %llu\n", array_blocks/2);
+
+		if (raid_disks > info->array.raid_disks)
+			devices_that_can_grow++;
 
 		if ((info->array.level != 0) &&
 		    (info->array.level != 5)) {
@@ -6884,14 +6923,25 @@ int imsm_reshape_is_allowed_on_container(struct supertype *st,
 		/* all raid5 and raid0 volumes in container
 		 * has to be ready for Online Capacity Expansion
 		 */
-		result = find_array_minor2(info->text_version, st->ss->external, &minor);
+		result = find_array_minor2(info->text_version, st->ss->external, st->devnum, &minor);
 		if (result < 0) {
 			dprintf("imsm: cannot find array\n");
 			break;
 		}
 		sprintf(info->sys_name, "md%i", minor);
 		if (sysfs_get_str(info, NULL, "array_state", buf, 20) <= 0) {
-			dprintf("imsm: for container operation wrong array state\n");
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
 			break;
 		}
 		if (info->array.level > 0) {
@@ -6953,7 +7003,7 @@ struct mdinfo *get_spares_imsm(int devnum)
 		goto abort;
 	}
 	sprintf(buf, "/md%i/0", devnum);
-	find_result = find_array_minor2(buf, 1, &devnum);
+	find_result = find_array_minor2(buf, 1, devnum, &devnum);
 	if (find_result < 0) {
 		dprintf("imsm: ERROR: Cannot find array.\n");
 		goto abort;
@@ -7024,7 +7074,7 @@ struct imsm_update_reshape *imsm_create_metadata_update_for_reshape(struct super
 	int device_size;
 	void *upd_devs;
 
-	dprintf("imsm imsm_update_metadata_for_reshape(enter)\n");
+	dprintf("imsm imsm_update_metadata_for_reshape(enter) raid_disks = %i\n", raid_disks);
 
 	if ((raid_disks < super->anchor->num_disks) ||
 	    (raid_disks == UnSet))
@@ -7070,7 +7120,7 @@ struct imsm_update_reshape *imsm_create_metadata_update_for_reshape(struct super
 		if (old_dev == NULL)
 			break;
 
-		find_array_minor((char *)old_dev->volume, 1, &devnum);
+		find_array_minor((char *)old_dev->volume, 1, st->devnum, &devnum);
 		if (devnum == imsm_volume) {
 			__u8 to_state;
 			struct imsm_map *new_map2;
@@ -7081,6 +7131,7 @@ struct imsm_update_reshape *imsm_create_metadata_update_for_reshape(struct super
 			new_map = get_imsm_map(upd_devs, 0);
 			old_disk_number = new_map->num_members;
 			new_map->num_members = raid_disks;
+			u->reshape_delta_disks = new_map->num_members - old_disk_number;
 			/* start migration on new device
 			 * it puts second map there also
 			 */
@@ -7105,7 +7156,7 @@ struct imsm_update_reshape *imsm_create_metadata_update_for_reshape(struct super
 		}
 	}
 
-	if (u->reshape_delta_disks == 0) {
+	if (delta_disks <= 0) {
 		dprintf("imsm: reshape without grow (disk add).\n");
 		/* finalize update */
 		goto calculate_size_only;
@@ -7297,7 +7348,7 @@ int imsm_reshape_super(struct supertype *st, long long size, int level,
 			array = get_volume_for_olce(st, raid_disks);
 			if (array) {
 				int devnum = -1;
-				find_array_minor(array, 1, &devnum);
+				find_array_minor(array, 1, st->devnum, &devnum);
 				if (devnum > 0) {
 					dprintf("imsm: Preparing metadata update for: %s\n", array);
 
@@ -7908,7 +7959,7 @@ int imsm_check_reshape_conditions(int fd, struct supertype *st, int current_arra
 			}
 			st->ss->getinfo_super(st, info);
 
-			find_array_minor(info->name, 1, &temp_array);
+			find_array_minor(info->name, 1, st->devnum, &temp_array);
 			if (temp_array != current_array) {
 				if (temp_array < 0) {
 					ret_val = -1;
@@ -7919,6 +7970,11 @@ int imsm_check_reshape_conditions(int fd, struct supertype *st, int current_arra
 				continue;
 			}
 
+			if (sysfs_get_str(info, NULL, "raid_disks", buf, sizeof(buf)) < 0) {
+				dprintf("cannot get raid_disks\n");
+				ret_val = 1;
+				break;
+			}
 			/* sync_max should be always set to 0
 			 */
 			if (sysfs_get_str(info, NULL, "sync_max", buf, sizeof(buf)) < 0) {
@@ -7967,7 +8023,7 @@ int imsm_check_reshape_conditions(int fd, struct supertype *st, int current_arra
 			sysfs_free(info);
 			info = NULL;
 			if (wrong_slots_counter != 0) {
-				dprintf("Slost for correction %i.\n", wrong_slots_counter);
+				dprintf("Slots for correction %i.\n", wrong_slots_counter);
 				ret_val = 1;
 				goto exit_imsm_check_reshape_conditions;
 			}
@@ -8046,7 +8102,7 @@ int imsm_manage_container_reshape(struct supertype *st)
 	info2.devs = NULL;
 	st->ss->getinfo_super(st, &info2);
 	current_array = -1;
-	find_array_minor(info2.name, 1, &current_array);
+	find_array_minor(info2.name, 1, st->devnum, &current_array);
 	if (current_array < 0) {
 		dprintf("imsm. Error.Cannot get first array.\n");
 		goto imsm_manage_container_reshape_exit;
@@ -8077,7 +8133,7 @@ int imsm_manage_container_reshape(struct supertype *st)
 				info2.devs = NULL;
 				st->ss->getinfo_super(st, &info2);
 				dprintf("Checking slots for device %s\n", info2.sys_name);
-				find_array_minor(info2.name, 1, &temp_array);
+				find_array_minor(info2.name, 1, st->devnum, &temp_array);
 				if (temp_array == current_array)
 					break;
 			}
@@ -8158,7 +8214,7 @@ int imsm_manage_container_reshape(struct supertype *st)
 				dprintf("imsm: next volume to reshape is: %s\n", array);
 				info2.devs = NULL;
 				st->ss->getinfo_super(st, &info2);
-				find_array_minor(info2.name, 1, &current_array);
+				find_array_minor(info2.name, 1, st->devnum, &current_array);
 				if (current_array > -1) {
 					/* send next array update
 					 */
diff --git a/mdadm/mdadm/util.c b/mdadm/mdadm/util.c
index d176ec0..60b9e0a 100644
--- a/mdadm/mdadm/util.c
+++ b/mdadm/mdadm/util.c
@@ -1947,8 +1947,9 @@ int path2devnum(char *pth)
 	return dev_num;
 }
 
-
-int find_array_minor(char *text_version, int external, int *minor)
+extern void map_read(struct map_ent **map);
+extern void map_free(struct map_ent *map);
+int find_array_minor(char *text_version, int external, int container, int *minor)
 {
 	int i;
 	char path[PATH_MAX];
@@ -1957,6 +1958,65 @@ int find_array_minor(char *text_version, int external, int *minor)
 	if (minor == NULL)
 		return -2;
 
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
 	for (i = 127; i >= 0; i--) {
 		char buf[PATH_MAX];
 
@@ -1968,7 +2028,7 @@ int find_array_minor(char *text_version, int external, int *minor)
 			if (external) {
 				char *version = strchr(buf, ':');
 				if (version && strcmp(version + 1,
-							text_version))
+						      text_version))
 					continue;
 			} else {
 				if (strcmp(buf, text_version))
@@ -1979,25 +2039,19 @@ int find_array_minor(char *text_version, int external, int *minor)
 		}
 	}
 
-	snprintf(path, PATH_MAX, "/dev/md/%s", text_version);
-	i = path2devnum(path);
-	if (i > -1) {
-		*minor = i;
-		return 0;
-	}
 
 	return -1;
 }
 
 /* find_array_minor2 looks for frozen devices also
  */
-int find_array_minor2(char *text_version, int external, int *minor)
+int find_array_minor2(char *text_version, int external, int container, int *minor)
 {
 	int result;
 	char buf[PATH_MAX];
 
 	strcpy(buf, text_version);
-	result = find_array_minor(text_version, external, minor);
+	result = find_array_minor(text_version, external, container, minor);
 	if (result < 0) {
 		/* try to find frozen array also
 		 */
@@ -2006,7 +2060,7 @@ int find_array_minor2(char *text_version, int external, int *minor)
 		strcpy(buf, text_version);
 
 		*buf = '-';
-		result = find_array_minor(buf, external, minor);
+		result = find_array_minor(buf, external, container, minor);
 	}
 	return result;
 }

