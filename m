From: "Hawrylewicz Czarnowski, Przemyslaw"
	<przemyslaw.hawrylewicz.czarnowski@intel.com>
Subject: [PATCH 07/13] imsm: extension of delete subarray to handle active
 container
Date: Thu, 22 Apr 2010 23:12:12 +0100
Message-ID: <66C59AD0932712458090B447266D638CD405E3BB@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "'linux-raid@vger.kernel.org'" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

For active container with remaining raid0 volume (mdmon is not running)
patch adds possibility to delete subarray and update metadata on all
component devices belonging to this volume.

Signed-off-by: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>
---
 Makefile      |    4 +-
 mdadm.h       |   21 +++++
 super-intel.c |   40 +++++++++
 util.c        |  262 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 325 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 1035ea8..1eb3e4b 100644
--- a/Makefile
+++ b/Makefile
@@ -96,12 +96,12 @@ SRCS =  mdadm.c config.c mdstat.c  ReadMe.c util.c Manage.c Assemble.c Build.c \
 
 MON_OBJS = mdmon.o monitor.o managemon.o util.o mdstat.o sysfs.o config.o \
 	Kill.o sg_io.o dlink.o ReadMe.o super0.o super1.o super-intel.o \
-	super-ddf.o sha1.o crc32.o msg.o bitmap.o \
+	super-ddf.o sha1.o crc32.o msg.o bitmap.o mdopen.o mapfile.o \
 	platform-intel.o probe_roms.o
 
 MON_SRCS = mdmon.c monitor.c managemon.c util.c mdstat.c sysfs.c config.c \
 	Kill.c sg_io.c dlink.c ReadMe.c super0.c super1.c super-intel.c \
-	super-ddf.c sha1.c crc32.c msg.c bitmap.c \
+	super-ddf.c sha1.c crc32.c msg.c bitmap.c mdopen.c mapfile.c \
 	platform-intel.c probe_roms.c
 
 STATICSRC = pwgr.c
diff --git a/mdadm.h b/mdadm.h
index cfbe407..2a5ca3b 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -722,6 +722,20 @@ extern void get_one_disk(int mdfd, mdu_array_info_t *ainf,
 			 mdu_disk_info_t *disk);
 void wait_for(char *dev, int fd);
 
+/*
+ * Array dynamic list holds the most important data to remember
+ * during the validation of the devices passed to some metadata
+ * manipulation functions (eg. delete subarray).
+ */
+struct array_dev_list {
+	int major;
+	int minor;
+	int found; /* mark here if disk is found in command line */
+	int fd; /* file descriptor of opened device*/
+	struct supertype *st; /* supertype record obtained from this device */
+	struct array_dev_list *next; /* next item */
+};
+
 #if __GNUC__ < 3
 struct stat64;
 #endif
@@ -928,6 +942,13 @@ extern int devname2devnum(char *name);
 extern int stat2devnum(struct stat *st);
 extern int fd2devnum(int fd);
 
+extern int find_array_minor(char *text_version, struct map_ent *map, int *minor);
+extern struct array_dev_list *get_devs_from_container(char *name, struct supertype **st);
+extern struct array_dev_list *array_dev_list_add(struct array_dev_list **dl, int maj, int min, struct supertype *st);
+extern void free_array_dev_list(struct array_dev_list *dl);
+extern struct array_dev_list *check_find_devices(mddev_dev_t devlist, int force, int quiet, struct mddev_ident_s *ident, char *meta_type, int *index, int *mon_managed);
+extern struct array_dev_list *check_devices(mddev_dev_t devlist, int force, int quiet, char *meta_type);
+
 static inline int dev2major(int d)
 {
 	if (d >= 0)
diff --git a/super-intel.c b/super-intel.c
index ff6fb52..10cf814 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -3470,8 +3470,12 @@ int delete_subarray_imsm(struct supertype *st, int fd)
 		return 1;
 	}
 
+	if (mdmon_running(st->container_dev))
+		return 1;
+
 	/* First case: 2 volumes */
 	if (mpb->num_raid_devs > 1) {
+		struct map_ent *map;
 		struct intel_dev *dp;
 		struct intel_dev *d = super->devlist->next;
 
@@ -3503,6 +3507,42 @@ int delete_subarray_imsm(struct supertype *st, int fd)
 		if (!st->loaded_container)
 			super->disks->fd = fd;
 		rv = write_super_imsm(super, 0);
+
+		/* if necessary re-index all container members */
+		if (st->loaded_container && container_index < mpb->num_raid_devs) {
+			struct map_ent *m;
+			map_read(&map);
+			map_lock(&map);
+			for (m = map; m; m = m->next) {
+				char *ind = strrchr(m->metadata, '/');
+				if (ind++) { /* array */
+					int index = atoi(ind);
+					if (index > container_index) { /* change needed */
+						char path[PATH_MAX];
+						char buf[1024];
+						struct mdinfo info_new;
+						*ind = '0' + --index;
+						/* sysfs */
+						snprintf(path, sizeof(path), "/sys/block/md%d/md/metadata_version", m->devnum);
+						snprintf(buf, sizeof(buf), "external:%s", m->metadata);
+						if (sysfs_set_str_simple(path, buf)) {
+							rv = 1;
+							break;
+						}
+						/* map */
+						strcpy(path, m->path);
+						super->current_vol = index;
+						getinfo_super_imsm_volume(st, &info_new);
+						map_do_update(&map, m->devnum,
+							      info_new.text_version,
+							      info_new.uuid, path);
+					}
+				}
+			}
+			map_write(map);
+			map_unlock(&map);
+			map_free(map);
+		}
 	} else { /* second case: 1 volume */
 		struct dl *d;
 		for (d = super->disks; d; d = d->next)
diff --git a/util.c b/util.c
index 423b66f..7ae0ba7 100644
--- a/util.c
+++ b/util.c
@@ -1649,3 +1649,265 @@ void append_metadata_update(struct supertype *st, void *buf, int len)
 unsigned int __invalid_size_argument_for_IOC = 0;
 #endif
 
+/* Function finds device minor of the device located in map file */
+int find_array_minor(char *text_version, struct map_ent *map, int *minor)
+{
+	if (!text_version || !minor)
+		return -1;
+
+	while (map)
+	{
+		if (!strcmp(map->metadata, text_version)) {
+			*minor = map->devnum;
+			return 0;
+		}
+		map = map->next;
+	}
+	return -1;
+}
+
+void free_array_dev_list(struct array_dev_list *dl)
+{
+	struct array_dev_list *t;
+	while(dl) {
+		t = dl;
+		dl = dl->next;
+		if (t->st)
+			t->st->ss->free_super(t->st);
+		free(t->st);
+		if (t->fd != -1)
+			close(t->fd);
+		free(t);
+	}
+}
+
+struct array_dev_list *array_dev_list_add(struct array_dev_list **dl, int maj, int min, struct supertype *st)
+{
+	struct array_dev_list *temp;
+
+	if (!dl)
+		return NULL;
+
+	temp = malloc(sizeof(*temp));
+	if (!temp) {
+		free_array_dev_list(*dl);
+		return NULL;
+	}
+	temp->next = *dl;
+	temp->major = maj;
+	temp->minor = min;
+	temp->found = 0;
+	temp->fd = -1;
+	temp->st = st;
+
+	*dl = temp;
+	return *dl;
+}
+
+struct array_dev_list *get_devs_from_container(char *name, struct supertype **st)
+{
+	int fd;
+	struct array_dev_list *dl = NULL;
+	struct mdinfo *mdi, *devs;
+
+	if (!st || !name)
+		return NULL;
+
+	if ((fd = open_mddev(name, 0)) == -1)
+		return NULL;
+
+	(*st) = guess_super(fd);
+
+	if (!*st) {
+		close(fd);
+		*st = NULL;
+		return NULL;
+	}
+
+	if ((*st)->ss->load_super(*st, fd, name)) {
+		*st = NULL;
+		close(fd);
+		return NULL;
+	}
+
+	mdi = sysfs_read(fd, 0, GET_DEVS);
+	if (!mdi) {
+		close(fd);
+		return NULL;
+	}
+
+	for (devs = mdi->devs; devs; devs = devs->next) {
+		if (devs->disk.state & (1 << MD_DISK_FAULTY))
+			continue;
+		if (!array_dev_list_add(&dl, devs->disk.major, devs->disk.minor, NULL)) {
+			close(fd);
+			(*st)->ss->free_super(*st);
+			*st = NULL;
+			sysfs_free(mdi);
+			return NULL;
+		}
+	}
+	close(fd);
+	sysfs_free(mdi);
+	return dl;
+}
+
+struct array_dev_list *check_devices(mddev_dev_t devlist, int force, int quiet, char *meta_type)
+{
+	int	fd;
+	struct supertype *st, *cst = NULL, *ref = NULL;
+	char	container_devname[255];
+	mddev_dev_t dv;
+	int	active_container = 0;
+	struct array_dev_list *dl = NULL, *d;
+
+	if (!devlist)
+		return NULL;
+
+	container_devname[0] = '\0';
+
+	for (dv = devlist; dv; dv = dv->next) {
+		fd = open(dv->devname, O_RDWR|(force ? O_NONBLOCK : 0));
+		if (fd < 0) {
+			if (!quiet)
+				fprintf(stderr, Name ": Couldn't open %s for read/write\n",
+					dv->devname);
+			free_array_dev_list(dl);
+			close(fd);
+			return NULL;
+		}
+		st = guess_super(fd);
+
+		if (!st) {
+			if (!quiet)
+				fprintf(stderr, Name ": Unrecognised md component device - %s\n",
+					dv->devname);
+			free_array_dev_list(dl);
+			close(fd);
+			return NULL;
+		}
+
+		if (!st->ss->match_metadata_desc(meta_type)) {
+			if (!quiet)
+				fprintf(stderr, Name ": Only %s metadata allowed\n", meta_type);
+			free_array_dev_list(dl);
+			close(fd);
+			return NULL;
+		}
+
+		if (st->ss->load_super(st, fd, dv->devname)) {
+			if (!quiet)
+				fprintf(stderr, Name ": Could not load superblock on %s\n", dv->devname);
+			free_array_dev_list(dl);
+			close(fd);
+			return NULL;
+		}
+		/* this device is a container */
+		if (st->loaded_container) { /* check if other devices passed */
+			if (ref || dv->next) {
+				fprintf(stderr, Name ": Container device should be the only one provided\n");
+				free_array_dev_list(dl);
+				close(fd);
+				return NULL;
+			}
+			active_container = 1;
+			strncpy(container_devname, dv->devname, sizeof(container_devname));
+			cst = st;
+			break;
+		} else {
+			/* so find active container comprises this device */
+			struct mdstat_ent *ent;
+			char *name = strrchr(dv->devname, '/');
+			if (name++) {
+				ent = mdstat_by_component(name);
+				if (ent) {
+					active_container = 1;
+					if (container_devname[0]) {
+						char *tmp = strrchr(container_devname, '/');
+						if (!tmp++) {
+							fprintf(stderr, Name ": Container device path is invalid\n");
+							free_array_dev_list(dl);
+							close(fd);
+							return NULL;
+						}
+						if (strcmp(tmp, ent->dev)) {
+							fprintf(stderr, Name ": Given devices does not belong to the same container\n");
+							free_array_dev_list(dl);
+							close(fd);
+							return NULL;
+						}
+					}
+					else
+						snprintf(container_devname, sizeof(container_devname), "/dev/%s", ent->dev);
+					if (!dl)
+						dl = get_devs_from_container(container_devname, &cst);
+
+					/* and get valid container disk members */
+					for (d = dl; d; d = d->next) {
+						struct stat stat;
+						if (fstat(fd, &stat) == -1) {
+							close(fd);
+							free_array_dev_list(dl);
+							return NULL;
+						}
+						if (d->major == MAJOR(stat.st_rdev) && d->minor == MINOR(stat.st_rdev)) {
+							d->found = 1;
+							d->st = st;
+							d->fd = fd;
+							break;
+						}
+					}
+				} else {
+					struct mdinfo i;
+					st->ss->getinfo_super(st, &i);
+					array_dev_list_add(&dl, i.disk.major, i.disk.minor, st);
+					dl->fd = fd;
+					continue;
+				}
+			}
+			close(fd);
+		}
+
+		if (!ref) {
+			ref = st;
+			close(fd);
+			continue;
+		}
+		if (st->ss->compare_super(st, ref)) {
+			free_array_dev_list(dl);
+			close(fd);
+			fprintf(stderr, Name ": Given devices does not belong to the same array\n");
+			return NULL;
+		}
+	}
+
+	if (active_container) {
+		for (d = dl; d; d = d->next) {
+			if (!d->found)
+				break;
+		}
+		if (d) {
+			free_array_dev_list(dl);
+			fprintf(stderr, Name ": Array containing given devices is active. "
+				"Please provide full set of drives\n");
+			return NULL;
+		}
+	}
+
+	/* For case of active container, use container's supertype data
+	 */
+	if (cst)
+	{
+		free_array_dev_list(dl);
+		dl = NULL;
+		array_dev_list_add(&dl, -1, -1, cst);
+		if ((dl->fd = open_mddev(container_devname, 0)) == -1) {
+			free_array_dev_list(dl);
+			fprintf(stderr, Name ": Could not reopen container device\n");
+			return NULL;
+		}
+	}
+
+	return dl;
+}
+
-- 
1.6.4.2


--
Best Regards,
Przemyslaw Hawrylewicz-Czarnowski
Software Development Engineer


