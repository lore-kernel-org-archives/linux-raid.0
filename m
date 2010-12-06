From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 12/27] Control reshape in mdadm
Date: Mon, 06 Dec 2010 14:22:19 +0100
Message-ID: <20101206132219.21125.65430.stgit@gklab-170-024.igk.intel.com>
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

When managemon starts reshape while sync_max is set to 0, mdadm waits already for it in manage_reshape().
When array reaches reshape state, manage_reshape() handler checks if all metadata updates are in place.
If not mdadm has to wait until updates hits array.
It starts reshape using child_grow() common code. Then waits until reshape is not finished.
When it happens it sets size to value specified in metadata and performs backward takeover to raid0 if necessary.

If manage_reshape() finds idle array state (instead reshape state) it is treated as error condition and process is terminated.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c        |   16 +-
 mdadm.h       |    6 +
 mdmon.c       |   52 +++++
 super-intel.c |  561 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 625 insertions(+), 10 deletions(-)

diff --git a/Grow.c b/Grow.c
index ecaeb39..b5442a5 100644
--- a/Grow.c
+++ b/Grow.c
@@ -453,10 +453,6 @@ static __u32 bsb_csum(char *buf, int len)
 	return __cpu_to_le32(csum);
 }
 
-static int child_grow(int afd, struct mdinfo *sra, unsigned long blocks,
-		      int *fds, unsigned long long *offsets,
-		      int disks, int chunk, int level, int layout, int data,
-		      int dests, int *destfd, unsigned long long *destoffsets);
 static int child_shrink(int afd, struct mdinfo *sra, unsigned long blocks,
 			int *fds, unsigned long long *offsets,
 			int disks, int chunk, int level, int layout, int data,
@@ -487,7 +483,7 @@ static int freeze_container(struct supertype *st)
 	return 1;
 }
 
-static void unfreeze_container(struct supertype *st)
+void unfreeze_container(struct supertype *st)
 {
 	int container_dev = (st->container_dev != NoMdDev
 			     ? st->container_dev : st->devnum);
@@ -543,7 +539,7 @@ static void unfreeze(struct supertype *st, int frozen)
 	}
 }
 
-static void wait_reshape(struct mdinfo *sra)
+void wait_reshape(struct mdinfo *sra)
 {
 	int fd = sysfs_get_fd(sra, NULL, "sync_action");
 	char action[20];
@@ -2203,10 +2199,10 @@ static void validate(int afd, int bfd, unsigned long long offset)
 	}
 }
 
-static int child_grow(int afd, struct mdinfo *sra, unsigned long stripes,
-		      int *fds, unsigned long long *offsets,
-		      int disks, int chunk, int level, int layout, int data,
-		      int dests, int *destfd, unsigned long long *destoffsets)
+int child_grow(int afd, struct mdinfo *sra, unsigned long stripes,
+	       int *fds, unsigned long long *offsets,
+	       int disks, int chunk, int level, int layout, int data,
+	       int dests, int *destfd, unsigned long long *destoffsets)
 {
 	char *buf;
 	int degraded = 0;
diff --git a/mdadm.h b/mdadm.h
index 20f65cc..4563d14 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -474,6 +474,7 @@ extern int sysfs_add_disk(struct mdinfo *sra, struct mdinfo *sd, int resume);
 extern int sysfs_disk_to_scsi_id(int fd, __u32 *id);
 extern int sysfs_unique_holder(int devnum, long rdev);
 extern int sysfs_freeze_array(struct mdinfo *sra);
+extern void wait_reshape(struct mdinfo *sra);
 extern int load_sys(char *path, char *buf);
 extern int reshape_prepare_fdlist(char *devname,
 				  struct mdinfo *sra,
@@ -495,6 +496,11 @@ extern int reshape_open_backup_file(char *backup,
 extern unsigned long compute_backup_blocks(int nchunk, int ochunk,
 					   unsigned int ndata, unsigned int odata);
 extern struct mdinfo *sysfs_get_unused_spares(int container_fd, int fd);
+extern int child_grow(int afd, struct mdinfo *sra, unsigned long stripes,
+		      int *fds, unsigned long long *offsets,
+		      int disks, int chunk, int level, int layout, int data,
+		      int dests, int *destfd, unsigned long long *destoffsets);
+extern void unfreeze_container(struct supertype *st);
 
 extern int save_stripes(int *source, unsigned long long *offsets,
 			int raid_disks, int chunk_size, int level, int layout,
diff --git a/mdmon.c b/mdmon.c
index 413ee29..271833f 100644
--- a/mdmon.c
+++ b/mdmon.c
@@ -530,3 +530,55 @@ void map_free(struct map_ent *map)
 {
 }
 
+void unfreeze_container(struct supertype *st)
+{
+}
+
+void wait_reshape(struct mdinfo *sra)
+{
+}
+
+unsigned long compute_backup_blocks(int nchunk, int ochunk,
+				    unsigned int ndata, unsigned int odata)
+{
+	return 0;
+}
+
+
+int reshape_prepare_fdlist(char *devname,
+			   struct mdinfo *sra,
+			   int raid_disks,
+			   int nrdisks,
+			   unsigned long blocks,
+			   char *backup_file,
+			   int *fdlist,
+			   unsigned long long *offsets)
+{
+	return 0;
+}
+
+int reshape_open_backup_file(char *backup_file,
+			     int fd,
+			     char *devname,
+			     long blocks,
+			     int *fdlist,
+			     unsigned long long *offsets)
+{
+	return -1;
+}
+
+int child_grow(int afd, struct mdinfo *sra,
+	       unsigned long stripes, int *fds, unsigned long long *offsets,
+	       int disks, int chunk, int level, int layout, int data,
+	       int dests, int *destfd, unsigned long long *destoffsets)
+{
+	return 1;
+}
+
+void reshape_free_fdlist(int *fdlist,
+			 unsigned long long *offsets,
+			 int size)
+{
+	;
+}
+
diff --git a/super-intel.c b/super-intel.c
index 5c3bd7b..5f96af2 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -26,6 +26,7 @@
 #include <scsi/sg.h>
 #include <ctype.h>
 #include <dirent.h>
+#include <sys/mman.h>
 
 /* MPB == Metadata Parameter Block */
 #define MPB_SIGNATURE "Intel Raid ISM Cfg Sig. "
@@ -6680,10 +6681,13 @@ int imsm_reshape_super(struct supertype *st, long long size, int level,
 			}
 		} else
 			dprintf("imsm: Operation is not allowed on container\n");
+		if (ret_val)
+			unfreeze_container(st);
 	} else
 		dprintf("imsm: not a container operation\n");
 
 	dprintf("imsm: reshape_super Exit code = %i\n", ret_val);
+
 	return ret_val;
 }
 
@@ -6749,6 +6753,13 @@ int imsm_reshape_array_set_slots(struct active_array *a)
 
 	return imsm_reshape_array_manage_new_slots(super, inst, a->devnum, 1);
 }
+
+int imsm_reshape_array_count_slots_mismatches(struct intel_super *super, int inst, int devnum)
+{
+
+	return imsm_reshape_array_manage_new_slots(super, inst, devnum, 0);
+}
+
 /* imsm_reshape_array_manage_new_slots()
  * returns: number of corrected slots for correct == 1
  *          counted number of different slots for correct == 0
@@ -7023,6 +7034,555 @@ imsm_reshape_array_exit:
 	return disk_list;
 }
 
+int imsm_grow_manage_size(struct supertype *st, struct mdinfo *sra, int current_vol)
+{
+	int ret_val = 0;
+	struct mdinfo *info = NULL;
+	unsigned long long size;
+	int container_fd;
+	unsigned long long current_size = 0;
+
+	/* finalize current volume reshape
+	 * for external meta size has to be managed by mdadm
+	 * read size set in meta and put it to md when
+	 * reshape is finished.
+	 */
+
+	if (sra == NULL) {
+		dprintf("Error: imsm_grow_manage_size(): sra == NULL\n");
+		goto exit_grow_manage_size_ext_meta;
+	}
+	wait_reshape(sra);
+
+	/* reshape has finished, update md size
+	 * get per-device size and multiply by data disks
+	 */
+	container_fd = open_dev(st->container_dev);
+	if (container_fd < 0) {
+		dprintf("Error: imsm_grow_manage_size(): container_fd == 0\n");
+		goto exit_grow_manage_size_ext_meta;
+	}
+	st->ss->load_super(st, container_fd, NULL);
+	info = sysfs_read(container_fd, 0, GET_LEVEL|GET_VERSION|GET_DEVS|GET_STATE);
+	close(container_fd);
+	if (info == NULL) {
+		dprintf("imsm: Cannot get device info.\n");
+		goto exit_grow_manage_size_ext_meta;
+	}
+	if (current_vol > -1) {
+		struct intel_super *super;
+
+		super = st->sb;
+		super->current_vol = current_vol;
+	}
+	st->ss->getinfo_super(st, info, NULL);
+	size = info->custom_array_size/2;
+	sysfs_get_ll(sra, NULL, "array_size", &current_size);
+	dprintf("imsm_grow_manage_size(): current size is %llu, set size to %llu\n", current_size, size);
+	sysfs_set_num(sra, NULL, "array_size", size);
+
+	ret_val = 1;
+
+exit_grow_manage_size_ext_meta:
+	sysfs_free(info);
+	return ret_val;
+}
+
+int imsm_child_grow(struct supertype *st, char *devname, int fd_in, struct mdinfo *sra, int current_vol, char *backup)
+{
+	int ret_val = 0;
+	int nrdisks;
+	int *fdlist;
+	unsigned long long *offsets;
+	unsigned int ndata, odata;
+	int ndisks, odisks;
+	unsigned long blocks, stripes;
+	int d;
+	struct mdinfo *sd;
+	int validate_fd;
+
+	nrdisks = ndisks = odisks = sra->array.raid_disks;
+	odisks -= sra->delta_disks;
+	odata = odisks-1;
+	ndata = ndisks-1;
+	fdlist = malloc((1+nrdisks) * sizeof(int));
+	offsets = malloc((1+nrdisks) * sizeof(offsets[0]));
+	if (!fdlist || !offsets) {
+		fprintf(stderr, Name ": malloc failed: grow aborted\n");
+		ret_val = 1;
+		if (fdlist)
+			free(fdlist);
+		if (offsets)
+			free(offsets);
+		return ret_val;
+	}
+	blocks = compute_backup_blocks(sra->array.chunk_size,
+				       sra->array.chunk_size,
+				       ndata, odata);
+
+	/* set MD_DISK_SYNC flag to open all devices that has to be backuped
+	 */
+	for (sd = sra->devs; sd; sd = sd->next) {
+		if ((sd->disk.raid_disk > -1) &&
+		    ((unsigned int)sd->disk.raid_disk < odata)) {
+			sd->disk.state |= (1<<MD_DISK_SYNC);
+			sd->disk.state &= ~(1<<MD_DISK_FAULTY);
+		} else {
+			sd->disk.state |= (1<<MD_DISK_FAULTY);
+			sd->disk.state &= ~(1<<MD_DISK_SYNC);
+		}
+	}
+#ifdef DEBUG
+	dprintf("FD list disk inspection:\n");
+	for (sd = sra->devs; sd; sd = sd->next) {
+		char *dn = map_dev(sd->disk.major,
+				   sd->disk.minor, 1);
+		dprintf("Disk %s", dn);
+		dprintf("\tstate = %i\n", sd->disk.state);
+	}
+#endif
+	d = reshape_prepare_fdlist(devname, sra, odisks,
+				    nrdisks, blocks, NULL,
+				    fdlist, offsets);
+	if (d < 0) {
+		fprintf(stderr, Name ": cannot prepare device list\n");
+		free(fdlist);
+		free(offsets);
+		ret_val = 1;
+		return ret_val;
+	}
+
+	if (reshape_open_backup_file(backup, fd_in, "imsm",
+				     (signed)blocks,
+				     fdlist, offsets) == 0) {
+		free(fdlist);
+		free(offsets);
+		ret_val = 1;
+		return ret_val;
+	}
+	d++;
+
+	mlockall(MCL_FUTURE);
+	if (ret_val == 0) {
+		if (check_env("MDADM_GROW_VERIFY"))
+			validate_fd = fd_in;
+		else
+			validate_fd = -1;
+
+		sra->array.raid_disks = odisks;
+		sra->new_level = sra->array.level;
+		sra->new_layout = sra->array.layout;
+		sra->new_chunk = sra->array.chunk_size;
+
+		stripes = blocks / (sra->array.chunk_size/512) / odata;
+		child_grow(validate_fd, sra, stripes,
+			fdlist, offsets,
+			odisks, sra->array.chunk_size,
+			sra->array.level, sra->array.layout, odata,
+			d - odisks, fdlist + odisks, offsets + odisks);
+		imsm_grow_manage_size(st, sra, current_vol);
+	}
+	reshape_free_fdlist(fdlist, offsets, d);
+
+	if (backup)
+		unlink(backup);
+
+	return ret_val;
+}
+
+void return_to_raid0(struct mdinfo *sra)
+{
+	if (sra->array.level == 4) {
+		dprintf("Execute backward takeover to raid0\n");
+		sysfs_set_str(sra, NULL, "level", "raid0");
+	}
+}
+
+int imsm_check_reshape_conditions(int fd, struct supertype *st, int current_array)
+{
+	char buf[PATH_MAX];
+	struct mdinfo *info = NULL;
+	int arrays_in_reshape_state = 0;
+	int wait_counter = 0;
+	int i;
+	int ret_val = 0;
+	struct intel_super *super = st->sb;
+	struct imsm_super *mpb = super->anchor;
+	int wrong_slots_counter;
+
+	/* wait until all arrays will be in reshape state
+	 * or error occures (iddle state detected)
+	 */
+	while ((arrays_in_reshape_state == 0) &&
+	       (ret_val == 0)) {
+		arrays_in_reshape_state = 0;
+		int temp_array;
+
+		if (wait_counter)
+			sleep(1);
+
+		for (i = 0; i < mpb->num_raid_devs; i++) {
+			int sync_max;
+			int len;
+
+			/* check array state in md
+			 */
+			st->ss->load_super(st, fd, NULL);
+			if (st->sb == NULL) {
+				dprintf("cannot get sb\n");
+				ret_val = 1;
+				break;
+			}
+			info = sysfs_read(fd, 0, GET_LEVEL|GET_VERSION|GET_DEVS|GET_STATE);
+			if (info == NULL) {
+				dprintf("imsm: Cannot get device info.\n");
+				break;
+			}
+			super = st->sb;
+			super->current_vol = i;
+			st->ss->getinfo_super(st, info, NULL);
+
+			find_array_minor(info->name, 1, st->devnum, &temp_array);
+			if (temp_array != current_array) {
+				if (temp_array < 0) {
+					ret_val = -1;
+					break;
+				}
+				sysfs_free(info);
+				info = NULL;
+				continue;
+			}
+			sprintf(info->sys_name, "md%i", current_array);
+			if (sysfs_get_str(info, NULL, "raid_disks", buf, sizeof(buf)) < 0) {
+				dprintf("cannot get raid_disks\n");
+				ret_val = 1;
+				break;
+			}
+			/* sync_max should be always set to 0
+			 */
+			if (sysfs_get_str(info, NULL, "sync_max", buf, sizeof(buf)) < 0) {
+				dprintf("cannot get sync_max\n");
+				ret_val = 1;
+				break;
+			}
+			len = strlen(buf)-1;
+			if (len < 0)
+				len = 0;
+			*(buf+len) = 0;
+			sync_max = atoi(buf);
+			if (sync_max != 0) {
+				dprintf("sync_max has wrong value (%s)\n", buf);
+				sysfs_free(info);
+				info = NULL;
+				continue;
+			}
+			if (sysfs_get_str(info, NULL, "sync_action", buf, sizeof(buf)) < 0) {
+				dprintf("cannot get sync_action\n");
+				ret_val = 1;
+				break;
+			}
+			len = strlen(buf)-1;
+			if (len < 0)
+				len = 0;
+			*(buf+len) = 0;
+			if (strncmp(buf, "idle", 7) == 0) {
+				dprintf("imsm: Error found array in idle state during reshape initialization\n");
+				ret_val = 1;
+				break;
+			}
+			if (strncmp(buf, "reshape", 7) == 0) {
+				arrays_in_reshape_state++;
+			} else {
+				if (strncmp(buf, "frozen", 6) != 0) {
+					*(buf+strlen(buf)) = 0;
+					dprintf("imsm: Error unexpected array state (%s) during reshape initialization\n",
+						buf);
+					ret_val = 1;
+					break;
+				}
+			}
+			/* this device looks ok, so
+			 * check if slots are set corectly
+			 */
+			super = st->sb;
+			wrong_slots_counter = imsm_reshape_array_count_slots_mismatches(super, i, atoi(info->sys_name+2));
+			sysfs_free(info);
+			info = NULL;
+			if (wrong_slots_counter != 0) {
+				dprintf("Slots for correction %i.\n", wrong_slots_counter);
+				ret_val = 1;
+				goto exit_imsm_check_reshape_conditions;
+			}
+		}
+		sysfs_free(info);
+		info = NULL;
+		wait_counter++;
+		if (wait_counter > 60) {
+			dprintf("exit on timeout, container is not prepared to reshape\n");
+			ret_val = 1;
+		}
+	}
+
+exit_imsm_check_reshape_conditions:
+	sysfs_free(info);
+	info = NULL;
+
+	return ret_val;
+}
+
+int imsm_manage_container_reshape(struct supertype *st, char *backup)
+{
+	int ret_val = 1;
+	char buf[PATH_MAX];
+	struct intel_super *super = st->sb;
+	struct imsm_super *mpb = super->anchor;
+	int fd;
+	struct mdinfo *info = NULL;
+	struct mdinfo info2;
+	int delta_disks;
+	struct geo_params geo;
+#ifdef DEBUG
+	int i;
+#endif
+
+	memset(&geo, sizeof (struct geo_params), 0);
+	/* verify reshape conditions
+	 * for single vlolume reshape exit only and reuse Grow_reshape() code
+	 */
+	if (st->container_dev != st->devnum) {
+		dprintf("imsm: imsm_manage_container_reshape() detects volume reshape (devnum = %i), exit.\n", st->devnum);
+		return ret_val;
+	}
+
+	if (backup == NULL) {
+		fprintf(stderr, Name ": Cannot grow - need backup-file\n");
+		return ret_val;
+	}
+
+	geo.dev_name = devnum2devname(st->devnum);
+	if (geo.dev_name == NULL) {
+		dprintf("imsm: Error: imsm_manage_reshape(): cannot get device name.\n");
+		return ret_val;
+	}
+
+	snprintf(buf, PATH_MAX, "/dev/%s", geo.dev_name);
+	fd = open(buf , O_RDONLY | O_DIRECT);
+	if (fd < 0) {
+		dprintf("imsm: cannot open device\n");
+		goto imsm_manage_container_reshape_exit;
+	}
+
+	/* send pings to roll managemon and monitor
+	 */
+	ping_manager(geo.dev_name);
+	ping_monitor(geo.dev_name);
+
+#ifdef DEBUG
+	/* device list for reshape
+	 */
+	dprintf("Arrays to run reshape (no: %i)\n", mpb->num_raid_devs);
+	for (i = 0; i < mpb->num_raid_devs; i++) {
+		struct imsm_dev *dev = get_imsm_dev(super, i);
+		dprintf("\tDevice: %s\n", dev->volume);
+	}
+#endif
+
+	info2.devs = NULL;
+	super = st->sb;
+	super->current_vol = 0;
+	st->ss->getinfo_super(st, &info2, NULL);
+	geo.dev_id = -1;
+	find_array_minor(info2.name, 1, st->devnum, &geo.dev_id);
+	if (geo.dev_id < 0) {
+		dprintf("imsm. Error.Cannot get first array.\n");
+		goto imsm_manage_container_reshape_exit;
+	}
+	if (imsm_check_reshape_conditions(fd, st, geo.dev_id)) {
+		dprintf("imsm. Error. Wrong reshape conditions.\n");
+		goto imsm_manage_container_reshape_exit;
+	}
+	geo.raid_disks = info2.array.raid_disks;
+	dprintf("Container is ready for reshape ...\n");
+	switch (fork()) {
+	case 0:
+		fprintf(stderr, Name ": Child forked to run and monitor reshape\n");
+		while (geo.dev_id > -1) {
+			int fd2 = -1;
+			int i;
+			int temp_array = -1;
+			char *array;
+
+			for (i = 0; i < mpb->num_raid_devs; i++) {
+				struct intel_super *super;
+
+				st->ss->load_super(st, fd, NULL);
+				if (st->sb == NULL) {
+					dprintf("cannot get sb\n");
+					ret_val = 1;
+					goto imsm_manage_container_reshape_exit;
+				}
+				info2.devs = NULL;
+				super = st->sb;
+				super->current_vol = i;
+				st->ss->getinfo_super(st, &info2, NULL);
+				find_array_minor(info2.name, 1, st->devnum, &temp_array);
+				if (temp_array == geo.dev_id) {
+					dprintf("Checking slots for device md%i\n", geo.dev_id);
+					break;
+				}
+			}
+			snprintf(buf, PATH_MAX, "/dev/md%i", geo.dev_id);
+			dprintf("Prepare to reshape for device md%i\n", geo.dev_id);
+			fd2 = open(buf, O_RDWR | O_DIRECT);
+			if (fd2 < 0) {
+				dprintf("Reshape is broken (cannot open array)\n");
+				ret_val = 1;
+				goto imsm_manage_container_reshape_exit;
+			}
+			info = sysfs_read(fd2, 0, GET_VERSION | GET_LEVEL | GET_DEVS | GET_STATE |\
+						 GET_COMPONENT | GET_OFFSET | GET_CACHE |\
+						 GET_CHUNK | GET_DISKS | GET_DEGRADED |
+						 GET_SIZE | GET_LAYOUT);
+			if (info == NULL) {
+				dprintf("Reshape is broken (cannot read sysfs)\n");
+				close(fd2);
+				ret_val = 1;
+				goto imsm_manage_container_reshape_exit;
+			}
+			delta_disks = info->delta_disks;
+			super = st->sb;
+
+			if (sysfs_get_str(info, NULL, "sync_completed", buf, sizeof(buf)) >= 0) {
+				/* check if in previous pass we reshape any array
+				 * if not we have to omit sync_complete condition
+				 * and try to reshape arrays
+				 */
+				if ((*buf == '0') ||
+				     /* or this array was already reshaped */
+				     (strncmp(buf, "none", 4) == 0)) {
+					dprintf("Skip this array, sync_completed is %s\n", buf);
+					geo.dev_id = -1;
+					sysfs_free(info);
+					info = NULL;
+					close(fd2);
+					continue;
+				}
+			} else {
+				dprintf("Reshape is broken (cannot read sync_complete)\n");
+				dprintf("Array level is: %i\n", info->array.level);
+				ret_val = 1;
+				close(fd2);
+				goto imsm_manage_container_reshape_exit;
+			}
+			snprintf(buf, PATH_MAX, "/dev/md/%s", info2.name);
+			info->delta_disks = info2.delta_disks;
+
+			delta_disks = info->array.raid_disks - geo.raid_disks;
+			geo.raid_disks = info->array.raid_disks;
+			if (info->array.level == 4) {
+				geo.raid_disks--;
+				delta_disks--;
+			}
+
+			super = st->sb;
+			super->current_vol = i;
+			ret_val = imsm_child_grow(st, buf,
+						  fd2,
+						  info,
+						  i,
+						  backup);
+			return_to_raid0(info);
+			sysfs_free(info);
+			info = NULL;
+			close(fd2);
+			i++;
+			if (ret_val) {
+				dprintf("Reshape is broken (cannot reshape)\n");
+				ret_val = 1;
+				goto imsm_manage_container_reshape_exit;
+			}
+			geo.dev_id = -1;
+			array = get_volume_for_olce(st, geo.raid_disks);
+			if (array) {
+				struct imsm_update_reshape *u;
+				dprintf("imsm: next volume to reshape is: %s\n", array);
+				find_array_minor(array, 1, st->devnum, &geo.dev_id);
+				if (geo.dev_id > -1) {
+					/* send next array update
+					 */
+					dprintf("imsm: Preparing metadata update for: %s (md%i)\n", array, geo.dev_id);
+					st->update_tail = &st->updates;
+					u = imsm_create_metadata_update_for_reshape(st, &geo);
+					if (u) {
+						u->reshape_delta_disks = delta_disks;
+						append_metadata_update(st, u, u->update_memory_size);
+						flush_metadata_updates(st);
+						/* send pings to roll managemon and monitor
+						 */
+						ping_manager(geo.dev_name);
+						ping_monitor(geo.dev_name);
+
+						if (imsm_check_reshape_conditions(fd, st, geo.dev_id)) {
+							dprintf("imsm. Error. Wrong reshape conditions.\n");
+							ret_val = 1;
+							geo.dev_id = -1;
+						}
+					} else
+						geo.dev_id = -1;
+				}
+				free(array);
+			}
+		}
+		unfreeze_container(st);
+		close(fd);
+		break;
+	case -1:
+		fprintf(stderr, Name ": Cannot run child to monitor reshape: %s\n",
+			strerror(errno));
+		ret_val = 1;
+		break;
+	default:
+		/* The child will take care of unfreezing the array */
+		break;
+	}
+
+imsm_manage_container_reshape_exit:
+	sysfs_free(info);
+	if (fd > -1)
+		close(fd);
+	if (geo.dev_name)
+		free(geo.dev_name);
+
+	return ret_val;
+}
+
+int imsm_manage_reshape(struct supertype *st, char *backup)
+{
+	int ret_val = 0;
+
+	dprintf("imsm: manage_reshape() called\n");
+
+	if (experimental() == 0)
+		return ret_val;
+
+	/* verify reshape conditions
+	 * for single vlolume reshape exit only and reuse Grow_reshape() code
+	 */
+	if (st->container_dev != st->devnum) {
+		dprintf("imsm: manage_reshape() current volume devnum: %i\n", st->devnum);
+
+		return ret_val;
+	}
+	ret_val = imsm_manage_container_reshape(st, backup);
+	/* unfreeze on error and success
+	 * for any result this is end of work
+	 */
+	unfreeze_container(st);
+
+	return ret_val;
+}
+
+
 struct superswitch super_imsm = {
 #ifndef	MDASSEMBLE
 	.examine_super	= examine_super_imsm,
@@ -7059,6 +7619,7 @@ struct superswitch super_imsm = {
 	.default_geometry = default_geometry_imsm,
 	.get_disk_controller_domain = imsm_get_disk_controller_domain,
 	.reshape_super  = imsm_reshape_super,
+	.manage_reshape = imsm_manage_reshape,
 	.reshape_array	= imsm_reshape_array,
 
 	.external	= 1,

