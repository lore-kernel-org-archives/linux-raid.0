From: Dan Williams <dan.j.williams@intel.com>
Subject: [mdadm GIT PULL] static analysis fixes
Date: Tue, 22 Dec 2009 17:09:38 -0700
Message-ID: <1261526978.31952.7.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>, Ed Ciechanowski <ed.ciechanowski@intel.com>, marcin.labun@intel.com, artur.wojcik@intel.com
List-Id: linux-raid.ids

Hi Neil, please pull from:

  git://github.com/djbw/mdadm.git klockwork

...to receive a collection of static analysis fixes.  These are
independent of other recent development and can be pulled separately.
Full diff below.

Thanks,
Dan

Artur Wojcik (16):
      Fix for buffer overflow defect in 'link'.
      Fix for possible NULL pointer dereference.
      Fix for memory and resource leak.
      Fix for NULL pointer dereference.
      Fix for NULL pointer dereference.
      Fix for buffer overflow defect.
      Fix for NULL pointer dereference defect.
      Fix for NULL pointer dereference defect.
      Fix for NULL pointer dereference defect.
      Fix for memory leak defect.
      Fix for memory leak defect.
      Fix for memory leak defect.
      Fix for buffer overflow error.
      Fix for buffer overflow defect.
      Fix for resource leak on error path.
      Fix required to enable RAID arrays on SAS disks.

Dan Williams (2):
      imsm: no need to report the component device name from container_content
      imsm: prune dead code in validate_geometry_imsm

 mdadm.h          |    7 ++++
 platform-intel.c |   10 ++++--
 probe_roms.c     |    8 +++--
 super-intel.c    |   83 +++++++++++++++++++++++++++++++----------------------
 sysfs.c          |   13 ++------
 5 files changed, 71 insertions(+), 50 deletions(-)

diff --git a/mdadm.h b/mdadm.h
index c7f864b..fb243e5 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -1001,3 +1001,10 @@ static inline int xasprintf(char **strp, const char *fmt, ...) {
 #define ALGORITHM_PARITY_0_6		20
 #define ALGORITHM_PARITY_N_6		ALGORITHM_PARITY_N
 
+/* Define PATH_MAX in case we don't use glibc or standard library does
+ * not have PATH_MAX defined. Assume max path length is 4K characters.
+ */
+#ifndef PATH_MAX
+#define PATH_MAX	4096
+#endif
+
diff --git a/platform-intel.c b/platform-intel.c
index d568ca6..30f7914 100644
--- a/platform-intel.c
+++ b/platform-intel.c
@@ -44,7 +44,7 @@ void free_sys_dev(struct sys_dev **list)
 struct sys_dev *find_driver_devices(const char *bus, const char *driver)
 {
 	/* search sysfs for devices driven by 'driver' */
-	char path[256];
+	char path[292];
 	char link[256];
 	char *c;
 	DIR *driver_dir;
@@ -57,13 +57,17 @@ struct sys_dev *find_driver_devices(const char *bus, const char *driver)
 	if (!driver_dir)
 		return NULL;
 	for (de = readdir(driver_dir); de; de = readdir(driver_dir)) {
+		int n;
+
 		/* is 'de' a device? check that the 'subsystem' link exists and
 		 * that its target matches 'bus'
 		 */
 		sprintf(path, "/sys/bus/%s/drivers/%s/%s/subsystem",
 			bus, driver, de->d_name);
-		if (readlink(path, link, sizeof(link)) < 0)
+		n = readlink(path, link, sizeof(link));
+		if (n < 0 || n >= sizeof(link))
 			continue;
+		link[n] = '\0';
 		c = strrchr(link, '/');
 		if (!c)
 			continue;
@@ -202,7 +206,7 @@ const struct imsm_orom *find_imsm_orom(void)
 
 char *devt_to_devpath(dev_t dev)
 {
-	char device[40];
+	char device[46];
 
 	sprintf(device, "/sys/dev/block/%d:%d/device", major(dev), minor(dev));
 	return canonicalize_file_name(device);
diff --git a/probe_roms.c b/probe_roms.c
index a9a8638..0f0ffbc 100644
--- a/probe_roms.c
+++ b/probe_roms.c
@@ -80,7 +80,7 @@ void probe_roms_exit(void)
 
 int probe_roms_init(unsigned long align)
 {
-	int fd;
+	int fd = -1;
 	int rc = 0;
 
 	/* valid values are 2048 and 512.  512 is for PCI-3.0 compliant
@@ -107,9 +107,11 @@ int probe_roms_init(unsigned long align)
 
 	if (rc == 0)
 		rom_fd = fd;
-	else
+	else {
+		if (fd >= 0) 
+			close(fd);
 		probe_roms_exit();
-
+	}
 	return rc;
 }
 
diff --git a/super-intel.c b/super-intel.c
index 2e119f8..14e1521 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -318,6 +318,8 @@ static struct supertype *match_metadata_desc_imsm(char *arg)
 		return NULL;
 
 	st = malloc(sizeof(*st));
+	if (!st)
+		return NULL;
 	memset(st, 0, sizeof(*st));
 	st->ss = &super_imsm;
 	st->max_devs = IMSM_MAX_DEVICES;
@@ -701,7 +703,7 @@ static void print_imsm_disk(struct imsm_super *mpb, int index, __u32 reserved)
 	char str[MAX_RAID_SERIAL_LEN + 1];
 	__u64 sz;
 
-	if (index < 0)
+	if (index < 0 || !disk)
 		return;
 
 	printf("\n");
@@ -959,6 +961,12 @@ static int imsm_enumerate_ports(const char *hba_path, int port_count, int host_b
 
 		/* chop device path to 'host%d' and calculate the port number */
 		c = strchr(&path[hba_len], '/');
+		if (!c) {
+			if (verbose)
+				fprintf(stderr, Name ": %s - invalid path name\n", path + hba_len);
+			err = 2;
+			break;
+		}
 		*c = '\0';
 		if (sscanf(&path[hba_len], "host%d", &port) == 1)
 			port -= host_base;
@@ -1236,6 +1244,7 @@ static void getinfo_super_imsm_volume(struct supertype *st, struct mdinfo *info)
 	struct imsm_dev *dev = get_imsm_dev(super, super->current_vol);
 	struct imsm_map *map = get_imsm_map(dev, 0);
 	struct dl *dl;
+	char *devname;
 
 	for (dl = super->disks; dl; dl = dl->next)
 		if (dl->raiddisk == info->disk.raid_disk)
@@ -1277,9 +1286,11 @@ static void getinfo_super_imsm_volume(struct supertype *st, struct mdinfo *info)
 
 	info->array.major_version = -1;
 	info->array.minor_version = -2;
-	sprintf(info->text_version, "/%s/%d",
-		devnum2devname(st->container_dev),
-		info->container_member);
+	devname = devnum2devname(st->container_dev);
+	*info->text_version = '\0';
+	if (devname)
+		sprintf(info->text_version, "/%s/%d", devname, info->container_member);
+	free(devname);
 	info->safe_mode_delay = 4000;  /* 4 secs like the Matrix driver */
 	uuid_from_super_imsm(st, info->uuid);
 }
@@ -1577,7 +1588,7 @@ static void fd2devname(int fd, char *name)
 {
 	struct stat st;
 	char path[256];
-	char dname[100];
+	char dname[PATH_MAX];
 	char *nm;
 	int rv;
 
@@ -2487,13 +2498,14 @@ static int load_super_imsm_all(struct supertype *st, int fd, void **sbp,
 
 	if (sra->array.major_version != -1 ||
 	    sra->array.minor_version != -2 ||
-	    strcmp(sra->text_version, "imsm") != 0)
-		return 1;
-
+	    strcmp(sra->text_version, "imsm") != 0) {
+		err = 1;
+		goto error;
+	}
 	/* load all mpbs */
 	for (sd = sra->devs, i = 0; sd; sd = sd->next, i++) {
 		struct intel_super *s = alloc_super(0);
-		char nm[20];
+		char nm[32];
 		int dfd;
 
 		err = 1;
@@ -2555,6 +2567,7 @@ static int load_super_imsm_all(struct supertype *st, int fd, void **sbp,
 		super_list = super_list->next;
 		free_imsm(s);
 	}
+	sysfs_free(sra);
 
 	if (err)
 		return err;
@@ -2797,6 +2810,8 @@ static int init_super_imsm_volume(struct supertype *st, mdu_array_info_t *info,
 	map->ddf = 1;
 
 	if (info->level == 1 && info->raid_disks > 2) {
+		free(dev);
+		free(dv);
 		fprintf(stderr, Name": imsm does not support more than 2 disks"
 				"in a raid1 volume\n");
 		return 0;
@@ -2938,6 +2953,10 @@ static int add_to_super_imsm_volume(struct supertype *st, mdu_disk_info_t *dk,
 		struct imsm_dev *_dev = __get_imsm_dev(mpb, 0);
 		struct imsm_disk *_disk = __get_imsm_disk(mpb, dl->index);
 
+		if (!_dev || !_disk) {
+			fprintf(stderr, Name ": BUG mpb setup error\n");
+			return 1;
+		}
 		*_dev = *dev;
 		*_disk = dl->disk;
 		sum = random32();
@@ -3426,7 +3445,7 @@ static int validate_geometry_imsm_volume(struct supertype *st, int level,
 {
 	struct stat stb;
 	struct intel_super *super = st->sb;
-	struct imsm_super *mpb = super->anchor;
+	struct imsm_super *mpb;
 	struct dl *dl;
 	unsigned long long pos = 0;
 	unsigned long long maxsize;
@@ -3436,6 +3455,7 @@ static int validate_geometry_imsm_volume(struct supertype *st, int level,
 	/* We must have the container info already read in. */
 	if (!super)
 		return 0;
+	mpb = super->anchor;
 
 	if (!is_raid_level_supported(super->orom, level, raiddisks)) {
 		pr_vrb(": platform does not support raid%d with %d disk%s\n",
@@ -3664,6 +3684,7 @@ static int validate_geometry_imsm(struct supertype *st, int level, int layout,
 {
 	int fd, cfd;
 	struct mdinfo *sra;
+	int is_member = 0;
 
 	/* if given unused devices create a container 
 	 * if given given devices in a container create a member volume
@@ -3697,21 +3718,6 @@ static int validate_geometry_imsm(struct supertype *st, int level, int layout,
 						     dev, freesize, verbose);
 	}
 
-	/* limit creation to the following levels */
-	if (!dev)
-		switch (level) {
-		case 0:
-		case 1:
-		case 10:
-		case 5:
-			return 0;
-		default:
-			if (verbose)
-				fprintf(stderr, Name
-					": IMSM only supports levels 0,1,5,10\n");
-			return 1;
-		}
-
 	/* This device needs to be a device in an 'imsm' container */
 	fd = open(dev, O_RDONLY|O_EXCL, 0);
 	if (fd >= 0) {
@@ -3730,17 +3736,19 @@ static int validate_geometry_imsm(struct supertype *st, int level, int layout,
 	}
 	/* Well, it is in use by someone, maybe an 'imsm' container. */
 	cfd = open_container(fd);
+	close(fd);
 	if (cfd < 0) {
-		close(fd);
 		if (verbose)
 			fprintf(stderr, Name ": Cannot use %s: It is busy\n",
 				dev);
 		return 0;
 	}
 	sra = sysfs_read(cfd, 0, GET_VERSION);
-	close(fd);
 	if (sra && sra->array.major_version == -1 &&
-	    strcmp(sra->text_version, "imsm") == 0) {
+	    strcmp(sra->text_version, "imsm") == 0)
+		is_member = 1;
+	sysfs_free(sra);
+	if (is_member) {
 		/* This is a member of a imsm container.  Load the container
 		 * and try to create a volume
 		 */
@@ -3755,11 +3763,13 @@ static int validate_geometry_imsm(struct supertype *st, int level, int layout,
 							     size, dev,
 							     freesize, verbose);
 		}
-		close(cfd);
-	} else /* may belong to another container */
-		return 0;
+	}
 
-	return 1;
+	if (verbose)
+		fprintf(stderr, Name ": failed container membership check\n");
+
+	close(cfd);
+	return 0;
 }
 #endif /* MDASSEMBLE */
 
@@ -3804,6 +3814,11 @@ static struct mdinfo *container_content_imsm(struct supertype *st)
 		}
 
 		this = malloc(sizeof(*this));
+		if (!this) {
+			fprintf(stderr, Name ": failed to allocate %lu bytes\n",
+				sizeof(*this));
+			break;
+		}
 		memset(this, 0, sizeof(*this));
 		this->next = rest;
 
@@ -3821,7 +3836,7 @@ static struct mdinfo *container_content_imsm(struct supertype *st)
 			ord = get_imsm_ord_tbl_ent(dev, slot); 
 			for (d = super->disks; d ; d = d->next)
 				if (d->index == idx)
-                                        break;
+					break;
 
 			if (d == NULL)
 				skip = 1;
@@ -3863,8 +3878,6 @@ static struct mdinfo *container_content_imsm(struct supertype *st)
 			info_d->events = __le32_to_cpu(mpb->generation_num);
 			info_d->data_offset = __le32_to_cpu(map->pba_of_lba0);
 			info_d->component_size = __le32_to_cpu(map->blocks_per_member);
-			if (d->devname)
-				strcpy(info_d->name, d->devname);
 		}
 		rest = this;
 	}
diff --git a/sysfs.c b/sysfs.c
index 35dfbd4..1d15ff6 100644
--- a/sysfs.c
+++ b/sysfs.c
@@ -100,13 +100,8 @@ void sysfs_init(struct mdinfo *mdi, int fd, int devnum)
 
 struct mdinfo *sysfs_read(int fd, int devnum, unsigned long options)
 {
-	/* Longest possible name in sysfs, mounted at /sys, is
-	 *  /sys/block/md_dXXX/md/dev-XXXXX/block/dev
-	 *  /sys/block/md_dXXX/md/metadata_version
-	 * which is about 41 characters.  50 should do for now
-	 */
-	char fname[50];
-	char buf[1024];
+	char fname[PATH_MAX];
+	char buf[PATH_MAX];
 	char *base;
 	char *dbase;
 	struct mdinfo *sra;
@@ -574,8 +569,8 @@ int sysfs_set_array(struct mdinfo *info, int vers)
 
 int sysfs_add_disk(struct mdinfo *sra, struct mdinfo *sd, int in_sync)
 {
-	char dv[100];
-	char nm[100];
+	char dv[PATH_MAX];
+	char nm[PATH_MAX];
 	char *dname;
 	int rv;
 


