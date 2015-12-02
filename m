From: Song Liu <songliubraving@fb.com>
Subject: [PATCH 08/17] enclosure detection/enumeration
Date: Tue, 1 Dec 2015 16:25:24 -0800
Message-ID: <1449015933-255689-9-git-send-email-songliubraving@fb.com>
References: <1449015933-255689-1-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1449015933-255689-1-git-send-email-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.com, dan.j.williams@intel.com, shli@fb.com, Dan Williams <djbw@fb.com>, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

From: Dan Williams <djbw@fb.com>

enumerate enclosures via --detail-platform --enclosure

Add the plumbing for the new command line parameter to
--detail-platform, and implement simple enumeration of an enclosure via
the attributes exported by ses and the /dev/disk/by-slot infrastructure.

Ex:
Enclosure0:
             Id : 0x5f80f41f1d6a60ff
         Vendor : facebook
          Model : Knox2U
          Slots : 15

         Slot00 : "OK" /dev/sdk YHJ9RP2D
         Slot01 : "OK" /dev/sdj YHJ6ZWJD
         Slot02 : "OK" /dev/sdi YHJ6BTLD
         Slot03 : "OK" /dev/sdg YHJ9WG2D
         Slot04 : "OK" /dev/sdf YHJ6WYGD
         Slot05 : "OK" /dev/sdl YHJ9S47D
         Slot06 : "OK" /dev/sdh YHJ9PZED
         Slot07 : "OK" /dev/sde YHJ7LW8D
         Slot08 : "OK" /dev/sdd YHJ7SSDD
         Slot09 : "OK" /dev/sdc YHJ7SRYD
         Slot10 : "OK" /dev/sdaa CVCV153103Z5120BGN
         Slot11 : "OK" /dev/sdx CVCV213103AK120BGN
         Slot12 : "OK" /dev/sdy CVCV203506EU120BGN
         Slot13 : "OK" /dev/sdz CVCV203602X2120BGN
         Slot14 : "OK" /dev/sdb YHJ9S3PD

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
---
 Detail.c      |  12 +--
 Makefile      |   4 +-
 ReadMe.c      |   2 +
 enclosure.c   | 314 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 mdadm.c       |  42 ++++++--
 mdadm.h       |   5 +
 super-intel.c |   2 -
 sysfs.c       |  11 +-
 util.c        |   1 +
 9 files changed, 374 insertions(+), 19 deletions(-)
 create mode 100644 enclosure.c

diff --git a/Detail.c b/Detail.c
index f71afb9..8fb61cc 100644
--- a/Detail.c
+++ b/Detail.c
@@ -717,7 +717,7 @@ out:
 	return rv;
 }
 
-int Detail_Platform(const struct platform_ops *platform, int scan, int verbose, int export, char *controller_path)
+int Detail_Platform(const struct platform_ops *platform, int scan, int verbose, int export, char *hwdevice)
 {
 	/* display platform capabilities
 	 * 'scan' in this context means iterate over all platform types
@@ -730,9 +730,9 @@ int Detail_Platform(const struct platform_ops *platform, int scan, int verbose,
 			platform->name);
 
 	if (platform && export)
-		err = platform->export_detail(verbose, controller_path);
+		err = platform->export_detail(verbose, hwdevice);
 	else if (platform)
-		err = platform->detail(verbose, 0, controller_path);
+		err = platform->detail(verbose, 0, hwdevice);
 	else if (!scan) {
 		if (verbose > 0)
 			pr_err("no platform components found\n");
@@ -741,7 +741,7 @@ int Detail_Platform(const struct platform_ops *platform, int scan, int verbose,
 	if (!scan)
 		return err;
 
-	for (p = platform_list; p; p++) {
+	for (p = platform_list; *p; p++) {
 		/* enumerated above */
 		if (*p == platform)
 			continue;
@@ -751,9 +751,9 @@ int Detail_Platform(const struct platform_ops *platform, int scan, int verbose,
 				(*p)->name);
 
 		if (export)
-			err |= (*p)->export_detail(verbose, controller_path);
+			err |= (*p)->export_detail(verbose, hwdevice);
 		else
-			err |= (*p)->detail(verbose, 0, controller_path);
+			err |= (*p)->detail(verbose, 0, hwdevice);
 
 	}
 
diff --git a/Makefile b/Makefile
index 2963884..3f9c7d2 100644
--- a/Makefile
+++ b/Makefile
@@ -134,7 +134,7 @@ OBJS =  mdadm.o config.o policy.o mdstat.o  ReadMe.o util.o maps.o lib.o \
 	mdopen.o super0.o super1.o super-ddf.o super-intel.o bitmap.o \
 	super-mbr.o super-gpt.o \
 	restripe.o sysfs.o sha1.o mapfile.o crc32.o sg_io.o msg.o xmalloc.o \
-	platform-intel.o probe_roms.o crc32c.o
+	platform-intel.o probe_roms.o crc32c.o enclosure.o
 
 CHECK_OBJS = restripe.o sysfs.o maps.o lib.o xmalloc.o dlink.o
 
@@ -147,7 +147,7 @@ MON_OBJS = mdmon.o monitor.o managemon.o util.o maps.o mdstat.o sysfs.o \
 	Kill.o sg_io.o dlink.o ReadMe.o super-intel.o \
 	super-mbr.o super-gpt.o \
 	super-ddf.o sha1.o crc32.o msg.o bitmap.o xmalloc.o \
-	platform-intel.o probe_roms.o
+	platform-intel.o probe_roms.o enclosure.o
 
 MON_SRCS = $(patsubst %.o,%.c,$(MON_OBJS))
 
diff --git a/ReadMe.c b/ReadMe.c
index fb5a671..8989e5c 100644
--- a/ReadMe.c
+++ b/ReadMe.c
@@ -97,6 +97,7 @@ struct option long_options[] = {
     {"examine-bitmap", 0, 0, 'X'},
     {"auto-detect", 0, 0, AutoDetect},
     {"detail-platform", 0, 0, DetailPlatform},
+    {"enclosure", 2, 0, Enclosure},
     {"kill-subarray", 1, 0, KillSubarray},
     {"update-subarray", 1, 0, UpdateSubarray},
     {"udev-rules", 2, 0, UdevRules},
@@ -502,6 +503,7 @@ char Help_misc[] =
 "                       device relates to the md driver\n"
 "  --detail      -D   : Display details of an array\n"
 "  --detail-platform  : Display hardware/firmware details\n"
+"  --enclosure        : Display disks by physical/bay location\n"
 "  --examine     -E   : Examine superblock on an array component\n"
 "  --examine-bitmap -X: Display contents of a bitmap file\n"
 "  --examine-badblocks: Display list of known bad blocks on device\n"
diff --git a/enclosure.c b/enclosure.c
new file mode 100644
index 0000000..76ed30d
--- /dev/null
+++ b/enclosure.c
@@ -0,0 +1,314 @@
+/*
+ * mdadm - Enclosure management support
+ *
+ * Copyright (C) 2013 Facebook
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ */
+#include "mdadm.h"
+
+#include <ctype.h>
+#include <sys/types.h>
+#include <dirent.h>
+
+
+#define ENCLOSURE_STRING 40
+struct slot {
+	struct slot *next;
+	char *devname;
+	int slot_num;
+};
+
+const char ENC_BASE[] = "/sys/class/enclosure";
+
+struct enclosure {
+	char vendor[ENCLOSURE_STRING];
+	char model[ENCLOSURE_STRING];
+	char id[ENCLOSURE_STRING];
+	struct slot *slot;
+	char *devname;
+	int num_slots;
+	struct enclosure *next;
+};
+
+static void free_slot(struct slot *slot)
+{
+	while (slot) {
+		struct slot *next = slot->next;
+
+		free(slot->devname);
+		free(slot);
+		slot = next;
+	}
+}
+
+static void free_enclosure(struct enclosure *enclosure)
+{
+	while (enclosure) {
+		struct enclosure *next = enclosure->next;
+
+		free_slot(enclosure->slot);
+		free(enclosure->devname);
+		free(enclosure);
+		enclosure = next;
+	}
+}
+
+static char *devpath_to_diskname_deprecated(const char *devpath)
+{
+	struct dirent *de = NULL;
+	char *r_devpath;
+	DIR *b_dir;
+	char *diskname = NULL;
+
+	r_devpath = realpath(devpath, NULL);
+	if (!r_devpath)
+		return NULL;
+
+	b_dir = opendir("/sys/block");
+	if (!b_dir)
+		goto out;
+
+	for (de = readdir(b_dir); de; de = readdir(b_dir)) {
+		char diskpath[100];
+		char *r_diskpath;
+		int done;
+
+		if (de->d_name[0] == '.')
+			continue;
+		sprintf(diskpath, "/sys/block/%s/device", de->d_name);
+		r_diskpath = realpath(diskpath, NULL);
+		if (!r_diskpath)
+			continue;
+
+		done = strcmp(r_devpath, r_diskpath) == 0;
+		free(r_diskpath);
+		if (done) {
+			diskname = xstrdup(de->d_name);
+			break;
+		}
+	}
+	closedir(b_dir);
+ out:
+	free(r_devpath);
+	return de ? diskname : NULL;
+}
+
+static char *device_to_diskname(const char *devpath)
+{
+	struct dirent *de = NULL;
+	struct stat st;
+	char *b_path;
+	DIR *b_dir;
+
+	if (stat(devpath, &st))
+		return NULL; /* no device */
+
+	xasprintf(&b_path, "%s/block", devpath);
+	b_dir = opendir(b_path);
+
+	/* on sysfs-deprecated hosts we need to do this the long way... */
+	if (!b_dir)
+		goto out;
+
+	for (de = readdir(b_dir); de; de = readdir(b_dir)) {
+		if (de->d_name[0] == '.')
+			continue;
+		if (de->d_type != DT_DIR)
+			continue;
+		/* 1:1 mapping of scsi device to block device */
+		break;
+	}
+	closedir(b_dir);
+ out:
+	free(b_path);
+
+	return de ? xstrdup(de->d_name) : devpath_to_diskname_deprecated(devpath);
+}
+
+static struct slot *parse_slots(struct enclosure *enclosure, DIR *slot_dir)
+{
+	struct slot *slot_list = NULL, **pos = &slot_list;
+	char path[PATH_MAX];
+	struct dirent *de;
+
+	if (!slot_dir)
+		return NULL;
+
+	for (de = readdir(slot_dir); de; de = readdir(slot_dir)) {
+		char slot_id[ENCLOSURE_STRING];
+		struct slot *slot;
+		char *e;
+
+		if (de->d_name[0] == '.')
+			continue;
+		if (de->d_type != DT_DIR)
+			continue;
+
+		snprintf(path, sizeof(path), "%s/%s/%s/slot",
+			 ENC_BASE, enclosure->devname, de->d_name);
+		if (load_sys_n(path, slot_id, sizeof(slot_id)) != 0)
+			continue;
+
+		slot = xcalloc(1, sizeof(*slot));
+		*pos = slot;
+		pos = &slot->next;
+		slot->slot_num = strtoul(slot_id, &e, 10);
+
+		snprintf(path, sizeof(path), "%s/%s/%s/device",
+			 ENC_BASE, enclosure->devname, de->d_name);
+		slot->devname = device_to_diskname(path);
+	}
+
+	if (de) {
+		free_slot(slot_list);
+		slot_list = NULL;
+	}
+
+	return slot_list;
+}
+
+static struct enclosure *parse_enclosures(void)
+{
+	struct enclosure *enc_list = NULL, **pos = &enc_list;
+	struct dirent *de;
+	DIR *enc_dir;
+
+	enc_dir = opendir(ENC_BASE);
+	if (!enc_dir)
+		return NULL;
+
+	for (de = readdir(enc_dir); de; de = readdir(enc_dir)) {
+		char num_slots[ENCLOSURE_STRING];
+		struct enclosure *enclosure;
+		char path[PATH_MAX];
+		DIR *slots;
+		char *e;
+
+		if (de->d_name[0] == '.')
+			continue;
+
+		enclosure = xcalloc(1, sizeof(*enclosure));
+		enclosure->devname = xstrdup(de->d_name);
+		*pos = enclosure;
+		pos = &enclosure->next;
+
+		snprintf(path, sizeof(path), "%s/%s/id", ENC_BASE, de->d_name);
+		if (load_sys_n(path, enclosure->id, sizeof(enclosure->id)) != 0)
+			break;
+
+		snprintf(path, sizeof(path), "%s/%s/components", ENC_BASE, de->d_name);
+		if (load_sys_n(path, num_slots, sizeof(num_slots)) != 0)
+			break;
+		enclosure->num_slots = strtoul(num_slots, &e, 10);
+
+		snprintf(path, sizeof(path), "%s/%s/device/model", ENC_BASE, de->d_name);
+		load_sys_n(path, enclosure->model, sizeof(enclosure->model));
+
+		snprintf(path, sizeof(path), "%s/%s/device/vendor", ENC_BASE, de->d_name);
+		load_sys_n(path, enclosure->vendor, sizeof(enclosure->vendor));
+
+		snprintf(path, sizeof(path), "%s/%s", ENC_BASE, de->d_name);
+		slots = opendir(path);
+		if (!slots)
+			break;
+
+		enclosure->slot = parse_slots(enclosure, slots);
+		closedir(slots);
+
+		if (!enclosure->slot)
+			break;
+
+	}
+
+	if (de) {
+		free_enclosure(enc_list);
+		enc_list = NULL;
+	}
+
+	closedir(enc_dir);
+
+	return enc_list;
+}
+
+static int detail_platform_enclosure(int verbose, int enumerate, char *enclosure_name)
+{
+	struct enclosure *enclosure = parse_enclosures();
+	struct enclosure *e;
+	int i;
+
+	if (!enclosure)
+		return 0;
+
+	for (e = enclosure, i = 0; e; e = e->next, i++) {
+		struct slot *s;
+
+		if (i)
+			printf("\n");
+		printf("Enclosure%d:\n", i);
+		printf("             Id : %s\n", e->id);
+		if (e->vendor[0])
+			printf("         Vendor : %s\n", e->vendor);
+		if (e->model[0])
+			printf("          Model : %s\n", e->model);
+		printf("          Slots : %d\n", e->num_slots);
+		if (e->slot)
+			printf("\n");
+
+		for (s = e->slot; s; s = s->next) {
+			int fd;
+			char buf[255];
+
+			printf("         Slot%02d :", s->slot_num);
+			snprintf(buf, sizeof(buf), "/dev/%s", s->devname ? : "");
+			printf("%s%s", buf[0] ? " " : "", buf);
+			if ((fd = dev_open(buf, O_RDONLY)) >= 0) {
+				memset(buf, 0, sizeof(buf));
+				if (scsi_get_serial(fd, buf, sizeof(buf)) == 0
+				    && buf[3]) {
+					char *serial;
+					char *end;
+
+					serial = &buf[4];
+
+					while (isspace(*serial))
+						serial++;
+					end = serial;
+					while (!isspace(*end) && *end != '\0')
+						end++;
+					if (end - &buf[4] > buf[3])
+						end = &buf[4] + buf[3] - 1;
+					*end = '\0';
+					printf(" %s", serial);
+				}
+				close(fd);
+			}
+			printf("\n");
+		}
+	}
+
+	free_enclosure(enclosure);
+	return 0;
+}
+
+static int export_detail_enclosure(int verbose, char *enclosure_name)
+{
+	return 0;
+}
+
+const struct platform_ops enclosure_platform = {
+	.detail = detail_platform_enclosure,
+	.export_detail = export_detail_enclosure,
+	.name = "enclosure",
+};
diff --git a/mdadm.c b/mdadm.c
index 98ef898..0e46177 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -154,6 +154,14 @@ int main(int argc, char *argv[])
 		case 'Y': c.export++;
 			continue;
 
+		case Enclosure:
+			  if (c.enclosure) {
+				  pr_err("--enclosure already specified\n");
+				  exit(2);
+			  }
+			  c.enclosure = optarg ? optarg : "scan";
+			  continue;
+
 		case HomeHost:
 			if (strcasecmp(optarg, "<ignore>") == 0)
 				c.require_homehost = 0;
@@ -1492,16 +1500,38 @@ int main(int argc, char *argv[])
 			}
 			rv = Examine(devlist, &c, ss);
 		} else if (devmode == DetailPlatform) {
+			char *controller = devlist ? devlist->devname : NULL;
 			const struct platform_ops *platform;
+			int scan, rv = 0;
 
-			if (ss)
-				platform = ss->ss->platform;
+			if (ss || c.enclosure)
+				scan = c.scan;
 			else
-				platform = NULL;
+				scan = 1;
 
-			rv = Detail_Platform(platform, platform ? c.scan : 1,
-					     c.verbose, c.export,
-					     devlist ? devlist->devname : NULL);
+			if (scan) {
+				rv = Detail_Platform(NULL, scan, c.verbose,
+						      c.export, controller);
+			} else {
+				/* metadata format specific details that
+				 * may be tied to a given controller
+				 */
+				if (ss) {
+					platform = ss->ss->platform;
+					rv = Detail_Platform(platform, scan,
+							     c.verbose, c.export,
+							     controller);
+				}
+				/* detail given enclosure or scan all
+				 * enclosures
+				 */
+				if (c.enclosure) {
+					platform = &enclosure_platform;
+					rv |= Detail_Platform(platform, scan,
+							      c.verbose, c.export,
+							      c.enclosure);
+				}
+			}
 		} else if (devlist == NULL) {
 			if (devmode == 'S' && c.scan)
 				rv = stop_scan(c.verbose);
diff --git a/mdadm.h b/mdadm.h
index f3b24b3..881c0fd 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -333,6 +333,7 @@ enum special_options {
 	AutoDetect,
 	Waitclean,
 	DetailPlatform,
+	Enclosure,
 	KillSubarray,
 	UpdateSubarray,
 	IncrementalPath,
@@ -459,6 +460,7 @@ struct context {
 	char	*action;
 	int	nodes;
 	char	*homecluster;
+	char	*enclosure;
 };
 
 struct shape {
@@ -599,10 +601,12 @@ extern int sysfs_set_safemode(struct mdinfo *sra, unsigned long ms);
 extern int sysfs_set_array(struct mdinfo *info, int vers);
 extern int sysfs_add_disk(struct mdinfo *sra, struct mdinfo *sd, int resume);
 extern int sysfs_disk_to_scsi_id(int fd, __u32 *id);
+extern int scsi_get_serial(int fd, void *buf, size_t buf_len);
 extern int sysfs_unique_holder(char *devnm, long rdev);
 extern int sysfs_freeze_array(struct mdinfo *sra);
 extern int sysfs_wait(int fd, int *msec);
 extern int load_sys(char *path, char *buf);
+extern int load_sys_n(char *path, char *buf, int len);
 extern int reshape_prepare_fdlist(char *devname,
 				  struct mdinfo *sra,
 				  int raid_disks,
@@ -1019,6 +1023,7 @@ extern struct superswitch super_imsm, super_ddf;
 extern struct superswitch mbr, gpt;
 
 extern const struct platform_ops imsm_platform;
+extern const struct platform_ops enclosure_platform;
 
 struct metadata_update {
 	int	len;
diff --git a/super-intel.c b/super-intel.c
index 53a9238..4ce46ef 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -3234,8 +3234,6 @@ static void fd2devname(int fd, char *name)
 	}
 }
 
-extern int scsi_get_serial(int fd, void *buf, size_t buf_len);
-
 static int imsm_read_serial(int fd, char *devname,
 			    __u8 serial[MAX_RAID_SERIAL_LEN])
 {
diff --git a/sysfs.c b/sysfs.c
index f1fd610..d20cf34 100644
--- a/sysfs.c
+++ b/sysfs.c
@@ -27,15 +27,15 @@
 #include	<dirent.h>
 #include	<ctype.h>
 
-int load_sys(char *path, char *buf)
+int load_sys_n(char *path, char *buf, int len)
 {
 	int fd = open(path, O_RDONLY);
 	int n;
 	if (fd < 0)
 		return -1;
-	n = read(fd, buf, 1024);
+	n = read(fd, buf, len);
 	close(fd);
-	if (n <0 || n >= 1024)
+	if (n <0 || n >= len)
 		return -1;
 	buf[n] = 0;
 	if (n && buf[n-1] == '\n')
@@ -43,6 +43,11 @@ int load_sys(char *path, char *buf)
 	return 0;
 }
 
+int load_sys(char *path, char *buf)
+{
+	return load_sys_n(path, buf, 1024);
+}
+
 void sysfs_free(struct mdinfo *sra)
 {
 	while (sra) {
diff --git a/util.c b/util.c
index e81c45d..bdc84e3 100644
--- a/util.c
+++ b/util.c
@@ -1150,6 +1150,7 @@ struct superswitch *superlist[] =
 const struct platform_ops *platform_list[] =
 {
 	&imsm_platform,
+	&enclosure_platform,
 	NULL,
 };
 
-- 
2.4.6

