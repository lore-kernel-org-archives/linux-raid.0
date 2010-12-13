From: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Subject: [PATCH] Finding spare devices for grow - rework
Date: Mon, 13 Dec 2010 13:29:03 +0100
Message-ID: <20101213122903.7090.92287.stgit@gklab-170-111.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, adam.kwolek@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

This patch introduces new method of finding spare devices
for grow (OnLine Capacity Expansion) operation.
The patch reuses code and procedures delivered
by the Array Auto Rebuild functionality hence it reduce
code redundancy.
The patch also introduces spare drive size verification
(missing in early implementation)

Signed-off-by: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
---
 super-intel.c |  142 +++++++++++++++++++++++------------------------
 sysfs.c       |  174 ---------------------------------------------------------
 2 files changed, 70 insertions(+), 246 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 626ecb6..c8d6382 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -7352,77 +7352,72 @@ exit_imsm_reshape_is_allowed_on_container:
 	return ret_val;
 }
 
-struct mdinfo *get_spares_imsm(int devnum)
+/* Function: get_spares_for_grow
+ * Description: Allocates memory and creates list of spare devices
+ * 		avaliable in containter. Checks if spare drive size is acceptable.
+ * Parameters: Pointer to the supertype structure
+ * Returns: Pointer to the list of spare devices (mdinfo structure) on sucess,
+ * 		NULL if fail
+ */
+struct mdinfo *get_spares_for_grow(struct supertype *st)
 {
+	int err;
+	char buf[PATH_MAX];
 	int fd = -1;
-	struct mdinfo *info = NULL;
-	struct mdinfo *ret_val = NULL;
-	int cont_fd = -1;
-	struct supertype *st = NULL;
-	int find_result;
-	struct intel_super *super = NULL;
-
-	dprintf("imsm: get_spares_imsm for device: %i.\n", devnum);
+	dev_t dev = 0;
+	struct mdinfo *disks, *d, *ds;
+	struct mdinfo *spares = NULL;
+	unsigned long long min_size = min_acceptable_spare_size_imsm(st);
 
-	cont_fd = open_dev(devnum);
-	if (cont_fd < 0) {
-		dprintf("imsm: ERROR: Cannot open container.\n");
-		goto abort;
-	}
+	sprintf(buf, "/dev/md%i", st->container_dev);
+	fd = open(buf, O_RDONLY);
 
-	/* get first volume */
-	st = super_by_fd(cont_fd, NULL);
-	if (st == NULL) {
-		dprintf("imsm: ERROR: Cannot load container information.\n");
-		goto abort;
-	}
-	find_result = imsm_find_array_minor_by_subdev(0, devnum, &devnum);
-	if (find_result < 0) {
-		dprintf("imsm: ERROR: Cannot find array.\n");
-		goto abort;
-	}
-	fd = open_dev(devnum);
-	if (fd < 0) {
-		dprintf("imsm: ERROR: Cannot open device.\n");
-		goto abort;
-	}
-	st->ss->load_super(st, cont_fd, NULL);
-	if (st->sb == NULL) {
-		dprintf("imsm: ERROR: Cannot load array information.\n");
-		goto abort;
-	}
-	info = sysfs_read(fd,
-			  0,
-			  GET_LEVEL | GET_VERSION | GET_DEVS | GET_STATE);
-	if (info == NULL) {
-		dprintf("imsm: Cannot get device info.\n");
-		goto abort;
-	}
-	super = st->sb;
-	super->current_vol = 0;
-	st->ss->getinfo_super(st, info, NULL);
-	ret_val = sysfs_get_unused_spares(cont_fd, fd);
-	if (ret_val == NULL) {
-		dprintf("imsm: ERROR: Cannot get spare devices.\n");
-		goto abort;
-	}
-	if (ret_val->array.spare_disks == 0) {
-		dprintf("imsm: ERROR: No available spares.\n");
-		free(ret_val);
-		ret_val = NULL;
-		goto abort;
-	}
+	err = load_container_imsm(st, fd, NULL);
+	close(fd);
+	if (err)
+		return NULL;
 
-abort:
-	if (st)
-		st->ss->free_super(st);
-	sysfs_free(info);
-	if (fd > -1)
-		close(fd);
-	if (cont_fd > -1)
-		close(cont_fd);
+	/* get list of alldisks in container */
+	disks = getinfo_super_disks_imsm(st);
 
-	return ret_val;
+	if (!disks)
+		return NULL;
+	/* find spare devices on the list */
+	for (d = disks->devs ; d ; d = d->next) {
+		int found = 0;
+		if (d->disk.state == 0) {
+			/* check if size is acceptable */
+			unsigned long long dev_size;
+			dev = makedev(d->disk.major,d->disk.minor);
+			if (min_size &&
+			    dev_size_from_id(dev,  &dev_size) &&
+			    dev_size >= min_size) {
+				dev = 0;
+				found = 1;
+			}
+		}
+		if (found) {
+			/* append spare to the list */
+			ds = malloc(sizeof(struct mdinfo));
+			if (ds == NULL)
+				goto exit_get_spares_for_grow;
+			memcpy(ds, d, sizeof(struct mdinfo));
+			ds->next = spares;
+			spares = ds;
+			disks->array.spare_disks++;
+		}
+	}
+exit_get_spares_for_grow:
+	/* free memory */
+	d = disks->devs;
+	while (d) {
+		struct mdinfo *tmp;
+		tmp = d->next;
+		free(d);
+		d = tmp;
+	}
+	disks->devs = spares;
+	return disks;
 }
 
 /*****************************************************************************
@@ -7707,7 +7702,7 @@ struct imsm_update_reshape *imsm_create_metadata_update_for_reshape(
 
 	/* now get spare disks list
 	 */
-	spares = get_spares_imsm(st->container_dev);
+	spares = get_spares_for_grow(st);
 
 	if (spares == NULL) {
 		dprintf("imsm: ERROR: Cannot get spare devices.\n");
@@ -8133,6 +8128,7 @@ static int imsm_reshape_array_manage_new_slots(struct intel_super *super,
 		int fd2;
 		int rv;
 
+		/* skip not configured disks */
 		if (dl->index < 0)
 			continue;
 
@@ -8189,10 +8185,11 @@ struct mdinfo *imsm_grow_array(struct active_array *a)
 	int inst = a->info.container_member;
 	struct imsm_dev *dev = get_imsm_dev(super, inst);
 	struct imsm_map *map = get_imsm_map(dev, 0);
+	struct imsm_map *map_2 = get_imsm_map(dev, 1);
 	struct mdinfo *di;
 	struct dl *dl;
 	int i;
-	int prev_raid_disks = a->info.array.raid_disks;
+	int prev_raid_disks = map_2->num_members;
 	int new_raid_disks = prev_raid_disks + a->reshape_delta_disks;
 	struct mdinfo *vol = NULL;
 	int fd;
@@ -8221,12 +8218,13 @@ struct mdinfo *imsm_grow_array(struct active_array *a)
 	for (i = prev_raid_disks; i < new_raid_disks; i++) {
 		/* OK, this device can be added.  Try to add.
 		 */
-		dl = imsm_add_spare(super, i, a, 0, rv);
-		if (!dl)
-			continue;
+		dl = super->disks;
+		while (dl) {
+			if (dl->index == i)
+				break;
+			dl = dl->next;
+		}
 
-		if (dl->index < 0)
-			dl->index = i;
 		/* found a usable disk with enough space */
 		di = malloc(sizeof(*di));
 		if (!di)
diff --git a/sysfs.c b/sysfs.c
index ca29aab..7a0403d 100644
--- a/sysfs.c
+++ b/sysfs.c
@@ -801,180 +801,6 @@ int sysfs_unique_holder(int devnum, long rdev)
 		return found;
 }
 
-int sysfs_is_spare_device_belongs_to(int fd, char *devname)
-{
-	int ret_val = -1;
-	char fname[PATH_MAX];
-	char *base;
-	char *dbase;
-	struct mdinfo *sra;
-	DIR *dir = NULL;
-	struct dirent *de;
-
-	sra = malloc(sizeof(*sra));
-	if (sra == NULL)
-		goto abort;
-	memset(sra, 0, sizeof(*sra));
-	sysfs_init(sra, fd, -1);
-	if (sra->sys_name[0] == 0)
-		goto abort;
-
-	memset(fname, PATH_MAX, 0);
-	sprintf(fname, "/sys/block/%s/md/", sra->sys_name);
-	base = fname + strlen(fname);
-
-	/* Get all the devices as well */
-	*base = 0;
-	dir = opendir(fname);
-	if (!dir)
-		goto abort;
-	while ((de = readdir(dir)) != NULL) {
-		if (de->d_ino == 0 ||
-		    strncmp(de->d_name, "dev-", 4) != 0)
-			continue;
-		strcpy(base, de->d_name);
-		dbase = base + strlen(base);
-		*dbase = '\0';
-		dbase = strstr(fname, "/md/");
-		if (dbase && strcmp(devname, dbase) == 0) {
-			ret_val = 1;
-			goto abort;
-		}
-	}
-abort:
-	if (dir)
-		closedir(dir);
-	sysfs_free(sra);
-
-	return ret_val;
-}
-
-struct mdinfo *sysfs_get_unused_spares(int container_fd, int fd)
-{
-	char fname[PATH_MAX];
-	char buf[PATH_MAX];
-	char *base;
-	char *dbase;
-	struct mdinfo *ret_val;
-	struct mdinfo *dev;
-	DIR *dir = NULL;
-	struct dirent *de;
-	int is_in;
-	char *to_check;
-
-	ret_val = malloc(sizeof(*ret_val));
-	if (ret_val == NULL)
-		goto abort;
-	memset(ret_val, 0, sizeof(*ret_val));
-	sysfs_init(ret_val, container_fd, -1);
-	if (ret_val->sys_name[0] == 0)
-		goto abort;
-
-	sprintf(fname, "/sys/block/%s/md/", ret_val->sys_name);
-	base = fname + strlen(fname);
-
-	strcpy(base, "raid_disks");
-	if (load_sys(fname, buf))
-		goto abort;
-	ret_val->array.raid_disks = strtoul(buf, NULL, 0);
-
-	/* Get all the devices as well */
-	*base = 0;
-	dir = opendir(fname);
-	if (!dir)
-		goto abort;
-	ret_val->array.spare_disks = 0;
-	while ((de = readdir(dir)) != NULL) {
-		char *ep;
-		if (de->d_ino == 0 ||
-		    strncmp(de->d_name, "dev-", 4) != 0)
-			continue;
-		strcpy(base, de->d_name);
-		dbase = base + strlen(base);
-		*dbase = '\0';
-
-		to_check = strstr(fname, "/md/");
-		is_in = sysfs_is_spare_device_belongs_to(fd, to_check);
-		if (is_in == -1) {
-			char *p;
-			struct stat stb;
-			char stb_name[PATH_MAX];
-
-			dev = malloc(sizeof(*dev));
-			if (!dev)
-				goto abort;
-			strncpy(dev->text_version, fname, 50);
-
-			*dbase++ = '/';
-
-			dev->disk.raid_disk = strtoul(buf, &ep, 10);
-			dev->disk.raid_disk = -1;
-
-			strcpy(dbase, "block/dev");
-			if (load_sys(fname, buf)) {
-				free(dev);
-				continue;
-			}
-			/* check first if we are working on block device
-			 * if not, we cannot check it
-			 */
-			p = strchr(dev->text_version, '-');
-			if (p)
-				p++;
-			sprintf(stb_name, "/dev/%s", p);
-			if (stat(stb_name, &stb) < 0) {
-				dprintf(Name ": stat failed for %s: %s.\n",
-					stb_name, strerror(errno));
-				free(dev);
-				continue;
-			}
-			if (!S_ISBLK(stb.st_mode)) {
-				dprintf(Name\
-					": %s is not a block device."\
-					" Skip checking.\n",
-					stb_name);
-				goto skip;
-			}
-			dprintf(Name": %s seams to a be block device\n",
-				stb_name);
-			sscanf(buf, "%d:%d",
-			       &dev->disk.major,
-			       &dev->disk.minor);
-			strcpy(dbase, "block/device/state");
-			if (load_sys(fname, buf) != 0) {
-				free(dev);
-				continue;
-			}
-			if (strncmp(buf, "offline", 7) == 0) {
-				free(dev);
-				continue;
-			}
-			if (strncmp(buf, "failed", 6) == 0) {
-				free(dev);
-				continue;
-			}
-
-skip:
-			/* add this disk to spares list */
-			dev->next = ret_val->devs;
-			ret_val->devs = dev;
-			ret_val->array.spare_disks++;
-			*(dbase-1) = '\0';
-			dprintf("sysfs: found spare: %s [%d:%d]\n",
-				fname, dev->disk.major, dev->disk.minor);
-		}
-	}
-	closedir(dir);
-	return ret_val;
-
-abort:
-	if (dir)
-		closedir(dir);
-	sysfs_free(ret_val);
-
-	return NULL;
-}
-
 int sysfs_freeze_array(struct mdinfo *sra)
 {
 	/* Try to freeze resync/rebuild on this array/container.

