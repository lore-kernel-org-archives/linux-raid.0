From: Artur Wojcik <artur.wojcik@intel.com>
Subject: Re: [patch 1/1][mdadm] Fix needed to enable RAID volumes on SAS
 devices (version 2).
Date: Mon, 30 Nov 2009 16:12:22 +0100
Message-ID: <1259593942.3178.123.camel@awojcik-linux>
References: <58C655507FA1494D95397652C4416F35CCF61201@irsmsx503.ger.corp.intel.com>
	 <20091113193545.GW21495@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091113193545.GW21495@skl-net.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>, Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>
List-Id: linux-raid.ids

diff --git a/Detail.c b/Detail.c
index e2cf028..377f75d 100644
--- a/Detail.c
+++ b/Detail.c
@@ -26,6 +26,7 @@
 #include	"md_p.h"
 #include	"md_u.h"
 #include	<dirent.h>
+#include	"util.h"
 
 int Detail(char *dev, int brief, int export, int test, char *homehost)
 {
@@ -408,13 +409,13 @@ This is pretty boring
 			printf("  Member Arrays :");
 
 			while (dir && (de = readdir(dir)) != NULL) {
-				char path[200];
+				char path[PATH_MAX];
 				char vbuf[1024];
 				int nlen = strlen(sra->sys_name);
 				int dn;
 				if (de->d_name[0] == '.')
 					continue;
-				sprintf(path, "/sys/block/%s/md/metadata_version",
+				str_fmt(path, "/sys/block/%s/md/metadata_version",
 					de->d_name);
 				if (load_sys(path, vbuf) < 0)
 					continue;
diff --git a/platform-intel.c b/platform-intel.c
index d568ca6..c61b2f1 100644
--- a/platform-intel.c
+++ b/platform-intel.c
@@ -28,6 +28,7 @@
 #include <sys/mman.h>
 #include <sys/types.h>
 #include <sys/stat.h>
+#include "util.h"
 
 void free_sys_dev(struct sys_dev **list)
 {
@@ -44,15 +45,15 @@ void free_sys_dev(struct sys_dev **list)
 struct sys_dev *find_driver_devices(const char *bus, const char
*driver)
 {
 	/* search sysfs for devices driven by 'driver' */
-	char path[256];
-	char link[256];
+	char path[PATH_MAX];
+	char link[PATH_MAX];
 	char *c;
 	DIR *driver_dir;
 	struct dirent *de;
 	struct sys_dev *head = NULL;
 	struct sys_dev *list = NULL;
 
-	sprintf(path, "/sys/bus/%s/drivers/%s", bus, driver);
+	str_fmt(path, "/sys/bus/%s/drivers/%s", bus, driver);
 	driver_dir = opendir(path);
 	if (!driver_dir)
 		return NULL;
@@ -60,7 +61,7 @@ struct sys_dev *find_driver_devices(const char *bus,
const char *driver)
 		/* is 'de' a device? check that the 'subsystem' link exists and
 		 * that its target matches 'bus'
 		 */
-		sprintf(path, "/sys/bus/%s/drivers/%s/%s/subsystem",
+		str_fmt(path, "/sys/bus/%s/drivers/%s/%s/subsystem",
 			bus, driver, de->d_name);
 		if (readlink(path, link, sizeof(link)) < 0)
 			continue;
@@ -85,7 +86,7 @@ struct sys_dev *find_driver_devices(const char *bus,
const char *driver)
 		}
 
 		/* generate canonical path name for the device */
-		sprintf(path, "/sys/bus/%s/drivers/%s/%s",
+		str_fmt(path, "/sys/bus/%s/drivers/%s/%s",
 			bus, driver, de->d_name);
 		list->path = canonicalize_file_name(path);
 		list->next = NULL;
@@ -96,13 +97,13 @@ struct sys_dev *find_driver_devices(const char *bus,
const char *driver)
 
 __u16 devpath_to_vendor(const char *dev_path)
 {
-	char path[strlen(dev_path) + strlen("/vendor") + 1];
+	char path[PATH_MAX];
 	char vendor[7];
 	int fd;
 	__u16 id = 0xffff;
 	int n;
 
-	sprintf(path, "%s/vendor", dev_path);
+	str_fmt(path, "%s/vendor", dev_path);
 
 	fd = open(path, O_RDONLY);
 	if (fd < 0)
@@ -202,9 +203,9 @@ const struct imsm_orom *find_imsm_orom(void)
 
 char *devt_to_devpath(dev_t dev)
 {
-	char device[40];
+	char device[PATH_MAX];
 
-	sprintf(device, "/sys/dev/block/%d:%d/device", major(dev),
minor(dev));
+	str_fmt(device, "/sys/dev/block/%d:%d/device", major(dev),
minor(dev));
 	return canonicalize_file_name(device);
 }
 
diff --git a/super-intel.c b/super-intel.c
index 9a99d60..7991295 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -26,6 +26,7 @@
 #include <scsi/sg.h>
 #include <ctype.h>
 #include <dirent.h>
+#include "util.h"
 
 /* MPB == Metadata Parameter Block */
 #define MPB_SIGNATURE "Intel Raid ISM Cfg Sig. "
@@ -882,7 +883,7 @@ static int imsm_enumerate_ports(const char
*hba_path, int port_count, int host_b
 		char vendor[64];
 		char buf[1024];
 		int major, minor;
-		char *device;
+		char device[PATH_MAX];
 		char *c;
 		int port;
 		int type;
@@ -899,19 +900,12 @@ static int imsm_enumerate_ports(const char
*hba_path, int port_count, int host_b
 		}
 
 		/* retrieve the scsi device type */
-		if (asprintf(&device, "/sys/dev/block/%d:%d/device/xxxxxxx", major,
minor) < 0) {
-			if (verbose)
-				fprintf(stderr, Name ": failed to allocate 'device'\n");
-			err = 2;
-			break;
-		}
-		sprintf(device, "/sys/dev/block/%d:%d/device/type", major, minor);
+		str_fmt(device, "/sys/dev/block/%d:%d/device/type", major, minor);
 		if (load_sys(device, buf) != 0) {
 			if (verbose)
 				fprintf(stderr, Name ": failed to read device type for %s\n",
 					path);
 			err = 2;
-			free(device);
 			break;
 		}
 		type = strtoul(buf, NULL, 10);
@@ -920,7 +914,7 @@ static int imsm_enumerate_ports(const char
*hba_path, int port_count, int host_b
 		if (!(type == 0 || type == 7 || type == 14)) {
 			vendor[0] = '\0';
 			model[0] = '\0';
-			sprintf(device, "/sys/dev/block/%d:%d/device/vendor", major, minor);
+			str_fmt(device, "/sys/dev/block/%d:%d/device/vendor", major, minor);
 			if (load_sys(device, buf) == 0) {
 				strncpy(vendor, buf, sizeof(vendor));
 				vendor[sizeof(vendor) - 1] = '\0';
@@ -929,7 +923,7 @@ static int imsm_enumerate_ports(const char
*hba_path, int port_count, int host_b
 					*c-- = '\0';
 
 			}
-			sprintf(device, "/sys/dev/block/%d:%d/device/model", major, minor);
+			str_fmt(device, "/sys/dev/block/%d:%d/device/model", major, minor);
 			if (load_sys(device, buf) == 0) {
 				strncpy(model, buf, sizeof(model));
 				model[sizeof(model) - 1] = '\0';
@@ -953,10 +947,9 @@ static int imsm_enumerate_ports(const char
*hba_path, int port_count, int host_b
 				case 12: sprintf(buf, "raid"); break;
 				default: sprintf(buf, "unknown");
 				}
-		} else
+		} else {
 			buf[0] = '\0';
-		free(device);
-
+		}
 		/* chop device path to 'host%d' and calculate the port number */
 		c = strchr(&path[hba_len], '/');
 		*c = '\0';
@@ -1576,15 +1569,15 @@ static int compare_super_imsm(struct supertype
*st, struct supertype *tst)
 static void fd2devname(int fd, char *name)
 {
 	struct stat st;
-	char path[256];
-	char dname[100];
+	char path[PATH_MAX];
+	char dname[PATH_MAX];
 	char *nm;
 	int rv;
 
 	name[0] = '\0';
 	if (fstat(fd, &st) != 0)
 		return;
-	sprintf(path, "/sys/dev/block/%d:%d",
+	str_fmt(path, "/sys/dev/block/%d:%d",
 		major(st.st_rdev), minor(st.st_rdev));
 
 	rv = readlink(path, dname, sizeof(dname));
diff --git a/sysfs.c b/sysfs.c
index 35dfbd4..a51cfb6 100644
--- a/sysfs.c
+++ b/sysfs.c
@@ -26,6 +26,7 @@
 #include	"mdadm.h"
 #include	<dirent.h>
 #include	<ctype.h>
+#include	"util.h"
 
 int load_sys(char *path, char *buf)
 {
@@ -59,14 +60,14 @@ void sysfs_free(struct mdinfo *sra)
 
 int sysfs_open(int devnum, char *devname, char *attr)
 {
-	char fname[50];
+	char fname[PATH_MAX];
 	int fd;
 	char *mdname = devnum2devname(devnum);
 
 	if (!mdname)
 		return -1;
 
-	sprintf(fname, "/sys/block/%s/md/", mdname);
+	str_fmt(fname, "/sys/block/%s/md/", mdname);
 	if (devname) {
 		strcat(fname, devname);
 		strcat(fname, "/");
@@ -100,12 +101,7 @@ void sysfs_init(struct mdinfo *mdi, int fd, int
devnum)
 
 struct mdinfo *sysfs_read(int fd, int devnum, unsigned long options)
 {
-	/* Longest possible name in sysfs, mounted at /sys, is
-	 *  /sys/block/md_dXXX/md/dev-XXXXX/block/dev
-	 *  /sys/block/md_dXXX/md/metadata_version
-	 * which is about 41 characters.  50 should do for now
-	 */
-	char fname[50];
+	char fname[PATH_MAX];
 	char buf[1024];
 	char *base;
 	char *dbase;
@@ -124,7 +120,7 @@ struct mdinfo *sysfs_read(int fd, int devnum,
unsigned long options)
 		return NULL;
 	}
 
-	sprintf(fname, "/sys/block/%s/md/", sra->sys_name);
+	str_fmt(fname, "/sys/block/%s/md/", sra->sys_name);
 	base = fname + strlen(fname);
 
 	sra->devs = NULL;
@@ -376,14 +372,14 @@ unsigned long long get_component_size(int fd)
 	 * This returns in units of sectors.
 	 */
 	struct stat stb;
-	char fname[50];
+	char fname[PATH_MAX];
 	int n;
 	if (fstat(fd, &stb)) return 0;
 	if (major(stb.st_rdev) != get_mdp_major())
-		sprintf(fname, "/sys/block/md%d/md/component_size",
+		str_fmt(fname, "/sys/block/md%d/md/component_size",
 			(int)minor(stb.st_rdev));
 	else
-		sprintf(fname, "/sys/block/md_d%d/md/component_size",
+		str_fmt(fname, "/sys/block/md_d%d/md/component_size",
 			(int)minor(stb.st_rdev)>>MdpMinorShift);
 	fd = open(fname, O_RDONLY);
 	if (fd < 0)
@@ -399,11 +395,11 @@ unsigned long long get_component_size(int fd)
 int sysfs_set_str(struct mdinfo *sra, struct mdinfo *dev,
 		  char *name, char *val)
 {
-	char fname[50];
+	char fname[PATH_MAX];
 	int n;
 	int fd;
 
-	sprintf(fname, "/sys/block/%s/md/%s/%s",
+	str_fmt(fname, "/sys/block/%s/md/%s/%s",
 		sra->sys_name, dev?dev->sys_name:"", name);
 	fd = open(fname, O_WRONLY);
 	if (fd < 0)
@@ -428,11 +424,11 @@ int sysfs_set_num(struct mdinfo *sra, struct
mdinfo *dev,
 
 int sysfs_uevent(struct mdinfo *sra, char *event)
 {
-	char fname[50];
+	char fname[PATH_MAX];
 	int n;
 	int fd;
 
-	sprintf(fname, "/sys/block/%s/uevent",
+	str_fmt(fname, "/sys/block/%s/uevent",
 		sra->sys_name);
 	fd = open(fname, O_WRONLY);
 	if (fd < 0)
@@ -445,10 +441,10 @@ int sysfs_uevent(struct mdinfo *sra, char *event)
 int sysfs_get_fd(struct mdinfo *sra, struct mdinfo *dev,
 		       char *name)
 {
-	char fname[50];
+	char fname[PATH_MAX];
 	int fd;
 
-	sprintf(fname, "/sys/block/%s/md/%s/%s",
+	str_fmt(fname, "/sys/block/%s/md/%s/%s",
 		sra->sys_name, dev?dev->sys_name:"", name);
 	fd = open(fname, O_RDWR);
 	if (fd < 0)
@@ -574,18 +570,18 @@ int sysfs_set_array(struct mdinfo *info, int vers)
 
 int sysfs_add_disk(struct mdinfo *sra, struct mdinfo *sd, int in_sync)
 {
-	char dv[100];
-	char nm[100];
+	char dv[PATH_MAX];
+	char nm[PATH_MAX];
 	char *dname;
 	int rv;
 
-	sprintf(dv, "%d:%d", sd->disk.major, sd->disk.minor);
+	str_fmt(dv, "%d:%d", sd->disk.major, sd->disk.minor);
 	rv = sysfs_set_str(sra, NULL, "new_dev", dv);
 	if (rv)
 		return rv;
 
 	memset(nm, 0, sizeof(nm));
-	sprintf(dv, "/sys/dev/block/%d:%d", sd->disk.major, sd->disk.minor);
+	str_fmt(dv, "/sys/dev/block/%d:%d", sd->disk.major, sd->disk.minor);
 	rv = readlink(dv, nm, sizeof(nm));
 	if (rv <= 0)
 		return -1;
@@ -615,8 +611,8 @@ int sysfs_disk_to_sg(int fd)
 	 * scsi_generic interface
 	 */
 	struct stat st;
-	char path[256];
-	char sg_path[256];
+	char path[PATH_MAX];
+	char sg_path[PATH_MAX];
 	char sg_major_minor[8];
 	char *c;
 	DIR *dir;
@@ -626,7 +622,7 @@ int sysfs_disk_to_sg(int fd)
 	if (fstat(fd, &st))
 		return -1;
 
-	snprintf(path, sizeof(path), "/sys/dev/block/%d:%d/device",
+	str_fmt(path, "/sys/dev/block/%d:%d/device",
 		 major(st.st_rdev), minor(st.st_rdev));
 
 	dir = opendir(path);
@@ -645,7 +641,7 @@ int sysfs_disk_to_sg(int fd)
 	if (!de)
 		return -1;
 
-	snprintf(sg_path, sizeof(sg_path), "%s/%s/dev", path, de->d_name);
+	str_fmt(sg_path, "%s/%s/dev", path, de->d_name);
 	fd = open(sg_path, O_RDONLY);
 	if (fd < 0)
 		return fd;
@@ -662,7 +658,7 @@ int sysfs_disk_to_sg(int fd)
 	c++;
 	major = strtol(sg_major_minor, NULL, 10);
 	minor = strtol(c, NULL, 10);
-	snprintf(path, sizeof(path), "/dev/.tmp.md.%d:%d:%d",
+	str_fmt(path, "/dev/.tmp.md.%d:%d:%d",
 		 (int) getpid(), major, minor);
 	if (mknod(path, S_IFCHR|0600, makedev(major, minor))==0) {
 			fd = open(path, O_RDONLY);
@@ -678,7 +674,7 @@ int sysfs_disk_to_scsi_id(int fd, __u32 *id)
 {
 	/* from an open block device, try to retrieve it scsi_id */
 	struct stat st;
-	char path[256];
+	char path[PATH_MAX];
 	char *c1, *c2;
 	DIR *dir;
 	struct dirent *de;
@@ -686,7 +682,7 @@ int sysfs_disk_to_scsi_id(int fd, __u32 *id)
 	if (fstat(fd, &st))
 		return 1;
 
-	snprintf(path, sizeof(path), "/sys/dev/block/%d:%d/device",
+	str_fmt(path, "/sys/dev/block/%d:%d/device",
 		 major(st.st_rdev), minor(st.st_rdev));
 
 	dir = opendir(path);
@@ -734,10 +730,10 @@ int sysfs_unique_holder(int devnum, long rdev)
 	 */
 	DIR *dir;
 	struct dirent *de;
-	char dirname[100];
+	char dirname[PATH_MAX];
 	char l;
 	int found = 0;
-	sprintf(dirname, "/sys/dev/block/%d:%d/holders",
+	str_fmt(dirname, "/sys/dev/block/%d:%d/holders",
 		major(rdev), minor(rdev));
 	dir = opendir(dirname);
 	errno = ENOENT;
@@ -892,3 +888,4 @@ int WaitClean(char *dev, int sock, int verbose)
 	return rv;
 }
 #endif /* MDASSEMBLE */
+
diff --git a/util.c b/util.c
index 048c39f..cdae3b4 100644
--- a/util.c
+++ b/util.c
@@ -3,7 +3,6 @@
  *
  * Copyright (C) 2001-2009 Neil Brown <neilb@suse.de>
  *
- *
  *    This program is free software; you can redistribute it and/or
modify
  *    it under the terms of the GNU General Public License as published
by
  *    the Free Software Foundation; either version 2 of the License, or
@@ -31,6 +30,7 @@
 #include	<ctype.h>
 #include	<dirent.h>
 #include	<signal.h>
+#include	"util.h"
 
 /*
  * following taken from linux/blkpg.h because they aren't
@@ -1110,7 +1110,7 @@ int open_container(int fd)
 	/* 'fd' is a block device.  Find out if it is in use
 	 * by a container, and return an open fd on that container.
 	 */
-	char path[256];
+	char path[PATH_MAX];
 	char *e;
 	DIR *dir;
 	struct dirent *de;
@@ -1121,7 +1121,7 @@ int open_container(int fd)
 
 	if (fstat(fd, &st) != 0)
 		return -1;
-	sprintf(path, "/sys/dev/block/%d:%d/holders",
+	str_fmt(path, "/sys/dev/block/%d:%d/holders",
 		(int)major(st.st_rdev), (int)minor(st.st_rdev));
 	e = path + strlen(path);
 
@@ -1230,8 +1230,8 @@ int devname2devnum(char *name)
 
 int stat2devnum(struct stat *st)
 {
-	char path[30];
-	char link[200];
+	char path[PATH_MAX];
+	char link[PATH_MAX];
 	char *cp;
 	int n;
 
@@ -1245,7 +1245,7 @@ int stat2devnum(struct stat *st)
 		 * /sys/dev/block/%d:%d link which must look like
 		 * ../../block/mdXXX/mdXXXpYY
 		 */
-		sprintf(path, "/sys/dev/block/%d:%d", major(st->st_rdev),
+		str_fmt(path, "/sys/dev/block/%d:%d", major(st->st_rdev),
 			minor(st->st_rdev));
 		n = readlink(path, link, sizeof(link)-1);
 		if (n <= 0)
@@ -1271,11 +1271,11 @@ int fd2devnum(int fd)
 
 int mdmon_running(int devnum)
 {
-	char path[100];
+	char path[PATH_MAX];
 	char pid[10];
 	int fd;
 	int n;
-	sprintf(path, "/var/run/mdadm/%s.pid", devnum2devname(devnum));
+	str_fmt(path, "/var/run/mdadm/%s.pid", devnum2devname(devnum));
 	fd = open(path, O_RDONLY, 0);
 
 	if (fd < 0)
@@ -1291,11 +1291,11 @@ int mdmon_running(int devnum)
 
 int signal_mdmon(int devnum)
 {
-	char path[100];
+	char path[PATH_MAX];
 	char pid[10];
 	int fd;
 	int n;
-	sprintf(path, "/var/run/mdadm/%s.pid", devnum2devname(devnum));
+	str_fmt(path, "/var/run/mdadm/%s.pid", devnum2devname(devnum));
 	fd = open(path, O_RDONLY, 0);
 
 	if (fd < 0)
@@ -1315,7 +1315,7 @@ int start_mdmon(int devnum)
 	int len;
 	pid_t pid;	
 	int status;
-	char pathbuf[1024];
+	char pathbuf[PATH_MAX];
 	char *paths[4] = {
 		pathbuf,
 		"/sbin/mdmon",
@@ -1329,6 +1329,9 @@ int start_mdmon(int devnum)
 	len = readlink("/proc/self/exe", pathbuf, sizeof(pathbuf));
 	if (len > 0) {
 		char *sl;
+		if (len >= sizeof(pathbuf)) {
+			len = sizeof(pathbuf) - 1;
+		}
 		pathbuf[len] = 0;
 		sl = strrchr(pathbuf, '/');
 		if (sl)
@@ -1425,6 +1428,36 @@ void append_metadata_update(struct supertype *st,
void *buf, int len)
 }
 #endif /* MDASSEMBLE */
 
+/* Copyright (C) 2009 Intel Corporation. All rights reserved.
+ *
+ * This function formats a string according to format pattern. The
buffer is
+ * always null terminated even if source string does not fit in
destination 
+ * buffer. The function returns -1 in case of an error and this means 
+ * either one of the input parameters is NULL or there's not enough
space in 
+ * destination buffer to fit even a single character. Otherwise the
function 
+ * returns the number of character put in the destination buffer.
+ */
+int __str_fmt(char *buf, size_t buf_size, const char *fmt, ...)
+{
+	va_list vl;
+
+	if (((int)(--buf_size)) <= 0) {
+		errno = ENOBUFS;
+		return -1;
+	}
+	if ((buf == NULL) || (fmt == NULL)) {
+		errno = EINVAL;
+		return -1;
+	}
+	va_start(vl, fmt);
+	int result = vsnprintf(buf, buf_size, fmt, vl);
+	va_end(vl);
+	if ((result < 0) || (result >= buf_size)) {
+		buf[result = buf_size] = '\0';
+	}
+	return result;
+}
+
 #ifdef __TINYC__
 /* tinyc doesn't optimize this check in ioctl.h out ... */
 unsigned int __invalid_size_argument_for_IOC = 0;
diff --git a/util.h b/util.h
new file mode 100644
index 0000000..4be9bc8
--- /dev/null
+++ b/util.h
@@ -0,0 +1,67 @@
+/*
+ * Linux RAID Management Application
+ * Copyright (c) 2009 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
it
+ * under the terms of the GNU General Public License version 2 as
published
+ * by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warrany of
MERCHANTABILITY
+ * or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public
License
+ * for more details.
+ *
+ * You should have received a copy of the GNU General Public License
along
+ * with this program; if not, write to the Free Software Foundation,
Inc.,
+ * 51 Franklin Street, Fifhth Floor, Boston, MA 02110-1301, USA.
+ */
+
+#ifndef _UTIL_H_INCLUDED
+#define _UTIL_H_INCLUDED
+
+/* Define PATH_MAX in case we don't use GLIBC or the standard library
does 
+   not have PATH_MAX defined. Assume maximum path length is 4K
characters. */
+#ifndef PATH_MAX
+#define PATH_MAX      4096
+#endif /* PATH_MAX */
+
+/**
+ * @brief Wrapper macro for __str_fmt function.
+ *
+ * This macro makes use of __str_fmt() function easier. Use this macro
with 
+ * caution and only for arrays. Do not use this macro with pointers
because 
+ * the result might be unexpected.
+ *
+ * @param[in]     __buf          Destination buffer.
+ * @param[in]     __fmt          Format string.
+ *
+ * @return The return value of this marco is the same as for
__str_fmt() 
+ *         function. See description of __str_fmt() for more details.
+ */
+#define str_fmt(__buf, __fmt, ...) \
+	__str_fmt((char *)(__buf), sizeof(__buf), (const char *)(__fmt), ##
__VA_ARGS__)
+
+/**
+ * @brief Formats a string according to pattern.
+ *
+ * This is printf() like function which formats a text buffer according
to
+ * format pattern. The function stores the result of formating in a
destination
+ * buffer. The destrination buffer is always null terminated even if
result 
+ * does not fit in it. See description of printf() function for details
on how
+ * to format the output.
+ *
+ * @param[in]     buf            Pointer to destination buffer where
the 
+ *                               result of formating will be stored.
+ * @param[in]     buf_size       The capacity of destination buffer
including
+ *                               null ('\0') character.
+ * @param[in]     fmt            Pointer to buffer containging the
pattern.
+ *
+ * @return If successful the function returns number of characters put
in 
+ *         destination buffer, otherwise the function returns -1. Check
errno
+ *         variable to get details about the cause of an error.
+ */
+extern int __str_fmt(char *buf, size_t buf_size, const char *fmt, ...)
+	__attribute__((format(printf, 3, 4)));
+
+#endif /* _UTIL_H_INCLUDED */
+
-- 
1.6.3.3



