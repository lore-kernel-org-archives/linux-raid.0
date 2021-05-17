Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92222C43460
	for <linux-raid@archiver.kernel.org>; Mon, 17 May 2021 14:48:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6EB0860C41
	for <linux-raid@archiver.kernel.org>; Mon, 17 May 2021 14:48:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240392AbhEQOtK (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 17 May 2021 10:49:10 -0400
Received: from mga05.intel.com ([192.55.52.43]:43127 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240263AbhEQOrC (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 17 May 2021 10:47:02 -0400
IronPort-SDR: 0fwj+ZIYGFMYYgcClG/9theR23m2AslsSDBXB7hziWJtbIuUV9SppqM7E1hUVSq8tx2hmE5zsT
 Mm15Jby36uaw==
X-IronPort-AV: E=McAfee;i="6200,9189,9987"; a="286009432"
X-IronPort-AV: E=Sophos;i="5.82,307,1613462400"; 
   d="scan'208";a="286009432"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2021 07:39:18 -0700
IronPort-SDR: Iu53sBjiUPl4UrHfImTFoQo3E38bcAPzELEH9306Z7shfdJL0q4tLuC4mVp7Rop9D7CIPzbJ/s
 Vb95IDvPhfeA==
X-IronPort-AV: E=Sophos;i="5.82,307,1613462400"; 
   d="scan'208";a="472432894"
Received: from mtkaczyk-devel.igk.intel.com ([10.102.102.23])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2021 07:39:17 -0700
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH 1/4] imsm: add generic method to resolve "device" links
Date:   Mon, 17 May 2021 16:39:00 +0200
Message-Id: <20210517143903.10077-2-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210517143903.10077-1-mariusz.tkaczyk@linux.intel.com>
References: <20210517143903.10077-1-mariusz.tkaczyk@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Each virtual device is linked with parent by "device". This patch adds
possibility to get previous device in sysfs tree.

Depending on device type, there is a different amount of virutal
layers. The best we can do is allow to directly specify how many
"device" links need to be resolved. This approach also allows to get
previous virtual device, which may contain some attributes.

Simplify fd2devname, this function doesn't require new functionality and
shall use generic fd2kname.

For nvme drives represented via nvme-subystem when path to block
device if requested, then return it without translation.

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 platform-intel.c | 75 ++++++++++++++++++++++++++++++++----------------
 platform-intel.h |  4 +--
 super-intel.c    | 63 ++++++++++++++++------------------------
 3 files changed, 77 insertions(+), 65 deletions(-)

diff --git a/platform-intel.c b/platform-intel.c
index 2da152f..2ed63ed 100644
--- a/platform-intel.c
+++ b/platform-intel.c
@@ -712,28 +712,61 @@ char *get_nvme_multipath_dev_hw_path(const char *dev_path)
 	return rp;
 }
 
-char *devt_to_devpath(dev_t dev)
+/* Description: Return part or whole realpath for the dev
+ * Parameters:
+ *	dev - the device to be quered
+ *	dev_level - level of "/device" entries. It allows to caller to access
+ *		    virtual or physical devices which are on "path" to quered
+ *		    one.
+ *	buf - optional, must be PATH_MAX size. If set, then will be used.
+ */
+char *devt_to_devpath(dev_t dev, int dev_level, char *buf)
 {
-	char device[46];
-	char *rp;
-	char *buf;
+	char device[PATH_MAX];
+	char *hw_path;
+	int i;
+	unsigned long device_free_len = sizeof(device) - 1;
+	char dev_str[] = "/device";
+	unsigned long dev_str_len = strlen(dev_str);
+
+	snprintf(device, sizeof(device), "/sys/dev/block/%d:%d", major(dev),
+		 minor(dev));
+
+	/* If caller wants block device, return path to it even if it is exposed
+	 * via virtual layer.
+	 */
+	if (dev_level == 0)
+		return realpath(device, buf);
 
-	sprintf(device, "/sys/dev/block/%d:%d/device", major(dev), minor(dev));
+	device_free_len -= strlen(device);
+	for (i = 0; i < dev_level; i++) {
+		if (device_free_len < dev_str_len)
+			return NULL;
 
-	rp = realpath(device, NULL);
-	if (!rp)
-		return NULL;
+		strncat(device, dev_str, device_free_len);
 
-	buf = get_nvme_multipath_dev_hw_path(rp);
-	if (buf) {
-		free(rp);
-		return buf;
+		/* Resolve nvme-subsystem abstraction if needed
+		 */
+		device_free_len -= dev_str_len;
+		if (i == 0) {
+			char rp[PATH_MAX];
+
+			if (!realpath(device, rp))
+				return NULL;
+			hw_path = get_nvme_multipath_dev_hw_path(rp);
+			if (hw_path) {
+				strcpy(device, hw_path);
+				device_free_len = sizeof(device) -
+						  strlen(device) - 1;
+				free(hw_path);
+			}
+		}
 	}
 
-	return rp;
+	return realpath(device, buf);
 }
 
-char *diskfd_to_devpath(int fd)
+char *diskfd_to_devpath(int fd, int dev_level, char *buf)
 {
 	/* return the device path for a disk, return NULL on error or fd
 	 * refers to a partition
@@ -745,7 +778,7 @@ char *diskfd_to_devpath(int fd)
 	if (!S_ISBLK(st.st_mode))
 		return NULL;
 
-	return devt_to_devpath(st.st_rdev);
+	return devt_to_devpath(st.st_rdev, dev_level, buf);
 }
 
 int path_attached_to_hba(const char *disk_path, const char *hba_path)
@@ -770,7 +803,7 @@ int path_attached_to_hba(const char *disk_path, const char *hba_path)
 
 int devt_attached_to_hba(dev_t dev, const char *hba_path)
 {
-	char *disk_path = devt_to_devpath(dev);
+	char *disk_path = devt_to_devpath(dev, 1, NULL);
 	int rc = path_attached_to_hba(disk_path, hba_path);
 
 	if (disk_path)
@@ -781,7 +814,7 @@ int devt_attached_to_hba(dev_t dev, const char *hba_path)
 
 int disk_attached_to_hba(int fd, const char *hba_path)
 {
-	char *disk_path = diskfd_to_devpath(fd);
+	char *disk_path = diskfd_to_devpath(fd, 1, NULL);
 	int rc = path_attached_to_hba(disk_path, hba_path);
 
 	if (disk_path)
@@ -862,15 +895,9 @@ int imsm_is_nvme_supported(int disk_fd, int verbose)
  */
 int is_multipath_nvme(int disk_fd)
 {
-	char path_buf[PATH_MAX];
 	char ns_path[PATH_MAX];
-	char *kname = fd2kname(disk_fd);
-
-	if (!kname)
-		return 0;
-	sprintf(path_buf, "/sys/block/%s", kname);
 
-	if (!realpath(path_buf, ns_path))
+	if (!diskfd_to_devpath(disk_fd, 0, ns_path))
 		return 0;
 
 	if (strncmp(ns_path, NVME_SUBSYS_PATH, strlen(NVME_SUBSYS_PATH)) == 0)
diff --git a/platform-intel.h b/platform-intel.h
index 8396a0f..f93add5 100644
--- a/platform-intel.h
+++ b/platform-intel.h
@@ -237,7 +237,7 @@ static inline char *guid_str(char *buf, struct efi_guid guid)
 }
 
 char *get_nvme_multipath_dev_hw_path(const char *dev_path);
-char *diskfd_to_devpath(int fd);
+char *diskfd_to_devpath(int fd, int dev_level, char *buf);
 __u16 devpath_to_vendor(const char *dev_path);
 struct sys_dev *find_driver_devices(const char *bus, const char *driver);
 struct sys_dev *find_intel_devices(void);
@@ -245,7 +245,7 @@ const struct imsm_orom *find_imsm_capability(struct sys_dev *hba);
 const struct imsm_orom *find_imsm_orom(void);
 int disk_attached_to_hba(int fd, const char *hba_path);
 int devt_attached_to_hba(dev_t dev, const char *hba_path);
-char *devt_to_devpath(dev_t dev);
+char *devt_to_devpath(dev_t dev, int dev_level, char *buf);
 int path_attached_to_hba(const char *disk_path, const char *hba_path);
 const char *get_sys_dev_type(enum sys_dev_type);
 const struct orom_entry *get_orom_entry_by_device_id(__u16 dev_id);
diff --git a/super-intel.c b/super-intel.c
index 5469912..cff8550 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -694,7 +694,7 @@ static struct sys_dev* find_disk_attached_hba(int fd, const char *devname)
 	if (fd < 0)
 		disk_path  = (char *) devname;
 	else
-		disk_path = diskfd_to_devpath(fd);
+		disk_path = diskfd_to_devpath(fd, 1, NULL);
 
 	if (!disk_path)
 		return 0;
@@ -2253,7 +2253,7 @@ static int ahci_enumerate_ports(const char *hba_path, int port_count, int host_b
 
 		if (sscanf(ent->d_name, "%d:%d", &major, &minor) != 2)
 			continue;
-		path = devt_to_devpath(makedev(major, minor));
+		path = devt_to_devpath(makedev(major, minor), 1, NULL);
 		if (!path)
 			continue;
 		if (!path_attached_to_hba(path, hba_path)) {
@@ -2407,7 +2407,7 @@ static int print_nvme_info(struct sys_dev *hba)
 				continue;
 			}
 
-			device_path = diskfd_to_devpath(fd);
+			device_path = diskfd_to_devpath(fd, 1, NULL);
 			if (!device_path) {
 				close(fd);
 				continue;
@@ -4015,28 +4015,13 @@ static int compare_super_imsm(struct supertype *st, struct supertype *tst,
 
 static void fd2devname(int fd, char *name)
 {
-	struct stat st;
-	char path[256];
-	char dname[PATH_MAX];
 	char *nm;
-	int rv;
-
-	name[0] = '\0';
-	if (fstat(fd, &st) != 0)
-		return;
-	sprintf(path, "/sys/dev/block/%d:%d",
-		major(st.st_rdev), minor(st.st_rdev));
 
-	rv = readlink(path, dname, sizeof(dname)-1);
-	if (rv <= 0)
+	nm = fd2kname(fd);
+	if (!nm)
 		return;
 
-	dname[rv] = '\0';
-	nm = strrchr(dname, '/');
-	if (nm) {
-		nm++;
-		snprintf(name, MAX_RAID_SERIAL_LEN, "/dev/%s", nm);
-	}
+	snprintf(name, MAX_RAID_SERIAL_LEN, "/dev/%s", nm);
 }
 
 static int nvme_get_serial(int fd, void *buf, size_t buf_len)
@@ -5941,29 +5926,23 @@ static int add_to_super_imsm(struct supertype *st, mdu_disk_info_t *dk,
 		free(dd);
 		abort();
 	}
+
 	if (super->hba && ((super->hba->type == SYS_DEV_NVME) ||
 	   (super->hba->type == SYS_DEV_VMD))) {
 		int i;
-		char *devpath = diskfd_to_devpath(fd);
-		char controller_path[PATH_MAX];
-		char *controller_name;
+		char cntrl_path[PATH_MAX];
+		char *cntrl_name;
+		char pci_dev_path[PATH_MAX];
 
-		if (!devpath) {
-			pr_err("failed to get devpath, aborting\n");
+		if (!diskfd_to_devpath(fd, 2, pci_dev_path) ||
+		    !diskfd_to_devpath(fd, 1, cntrl_path)) {
+			pr_err("failed to get dev_path, aborting\n");
 			if (dd->devname)
 				free(dd->devname);
 			free(dd);
 			return 1;
 		}
 
-		snprintf(controller_path, PATH_MAX-1, "%s/device", devpath);
-
-		controller_name = basename(devpath);
-		if (is_multipath_nvme(fd))
-			pr_err("%s controller supports Multi-Path I/O, Intel (R) VROC does not support multipathing\n", controller_name);
-
-		free(devpath);
-
 		if (!imsm_is_nvme_supported(dd->fd, 1)) {
 			if (dd->devname)
 				free(dd->devname);
@@ -5971,7 +5950,12 @@ static int add_to_super_imsm(struct supertype *st, mdu_disk_info_t *dk,
 			return 1;
 		}
 
-		if (devpath_to_vendor(controller_path) == 0x8086) {
+		cntrl_name = basename(cntrl_path);
+		if (is_multipath_nvme(fd))
+			pr_err("%s controller supports Multi-Path I/O, Intel (R) VROC does not support multipathing\n",
+			       cntrl_name);
+
+		if (devpath_to_vendor(pci_dev_path) == 0x8086) {
 			/*
 			 * If Intel's NVMe drive has serial ended with
 			 * "-A","-B","-1" or "-2" it means that this is "x8"
@@ -6985,7 +6969,7 @@ get_devices(const char *hba_path)
 		char *path = NULL;
 		if (sscanf(ent->d_name, "%d:%d", &major, &minor) != 2)
 			continue;
-		path = devt_to_devpath(makedev(major, minor));
+		path = devt_to_devpath(makedev(major, minor), 1, NULL);
 		if (!path)
 			continue;
 		if (!path_attached_to_hba(path, hba_path)) {
@@ -10648,7 +10632,7 @@ int validate_container_imsm(struct mdinfo *info)
 	struct sys_dev *hba = NULL;
 	struct sys_dev *intel_devices = find_intel_devices();
 	char *dev_path = devt_to_devpath(makedev(info->disk.major,
-									info->disk.minor));
+						 info->disk.minor), 1, NULL);
 
 	for (idev = intel_devices; idev; idev = idev->next) {
 		if (dev_path && strstr(dev_path, idev->path)) {
@@ -10669,7 +10653,8 @@ int validate_container_imsm(struct mdinfo *info)
 	struct mdinfo *dev;
 
 	for (dev = info->next; dev; dev = dev->next) {
-		dev_path = devt_to_devpath(makedev(dev->disk.major, dev->disk.minor));
+		dev_path = devt_to_devpath(makedev(dev->disk.major,
+						   dev->disk.minor), 1, NULL);
 
 		struct sys_dev *hba2 = NULL;
 		for (idev = intel_devices; idev; idev = idev->next) {
@@ -11181,7 +11166,7 @@ static const char *imsm_get_disk_controller_domain(const char *path)
 		struct sys_dev* hba;
 		char *path;
 
-		path = devt_to_devpath(st.st_rdev);
+		path = devt_to_devpath(st.st_rdev, 1, NULL);
 		if (path == NULL)
 			return "unknown";
 		hba = find_disk_attached_hba(-1, path);
-- 
2.26.2

