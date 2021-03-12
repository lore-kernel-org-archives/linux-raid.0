Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44E61C433DB
	for <linux-raid@archiver.kernel.org>; Fri, 12 Mar 2021 09:31:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EDC8F64F00
	for <linux-raid@archiver.kernel.org>; Fri, 12 Mar 2021 09:31:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232904AbhCLJaq (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 12 Mar 2021 04:30:46 -0500
Received: from mga12.intel.com ([192.55.52.136]:40403 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232756AbhCLJaZ (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Fri, 12 Mar 2021 04:30:25 -0500
IronPort-SDR: wNTuoQoFcZ91m2l+e4KQ87JGWns+nDFCe4H2fN1J4vVR7LxtbQ8mdvMNC7VVGgt0vquVdw3EQh
 ZAqLj3HwxyNA==
X-IronPort-AV: E=McAfee;i="6000,8403,9920"; a="168082127"
X-IronPort-AV: E=Sophos;i="5.81,243,1610438400"; 
   d="scan'208";a="168082127"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2021 01:30:24 -0800
IronPort-SDR: wZqdV/ocxpsA3/leRCXA5eqNkti3VS9A1OupSNu1+HoatbY5or6rHl9U+JhyNQrDETPC7K5Gut
 aBmWHm47XYyw==
X-IronPort-AV: E=Sophos;i="5.81,243,1610438400"; 
   d="scan'208";a="448572011"
Received: from mtkaczyk-devel.igk.intel.com ([10.102.102.23])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2021 01:30:23 -0800
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH v2] imsm: nvme multipath support
Date:   Fri, 12 Mar 2021 10:30:16 +0100
Message-Id: <20210312093016.7886-1-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Blazej Kucman <blazej.kucman@intel.com>

Add support for nvme devices which are represented
via nvme-subsystem.
Print warning when multi-path disk is added to RAID.

Signed-off-by: Oleksandr Shchirskyi <oleksandr.shchirskyi@intel.com>
Signed-off-by: Blazej Kucman <blazej.kucman@intel.com>
Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 platform-intel.c | 79 +++++++++++++++++++++++++++++++++++++++++++++++-
 platform-intel.h |  2 ++
 super-intel.c    | 38 ++++++++++++++---------
 3 files changed, 104 insertions(+), 15 deletions(-)

diff --git a/platform-intel.c b/platform-intel.c
index f1f6d4cd..0e1ec3d5 100644
--- a/platform-intel.c
+++ b/platform-intel.c
@@ -30,6 +30,8 @@
 #include <sys/stat.h>
 #include <limits.h>
 
+#define NVME_SUBSYS_PATH "/sys/devices/virtual/nvme-subsystem/"
+
 static int devpath_to_ll(const char *dev_path, const char *entry,
 			 unsigned long long *val);
 
@@ -668,12 +670,63 @@ const struct imsm_orom *find_imsm_capability(struct sys_dev *hba)
 	return NULL;
 }
 
+/* Check whether the nvme device is represented by nvme subsytem,
+ * if yes virtual path should be changed to hardware device path,
+ * to allow IMSM capabilities detection.
+ * Returns:
+ *	hardware path to device - if the device is represented via
+ *		nvme virtual subsytem
+ *	NULL - if the device is not represented via nvme virtual subsytem
+ */
+char *get_nvme_multipath_dev_hw_path(const char *dev_path)
+{
+	DIR *dir;
+	struct dirent *ent;
+	char *rp = NULL;
+
+	if (strncmp(dev_path, NVME_SUBSYS_PATH, strlen(NVME_SUBSYS_PATH)) != 0)
+		return NULL;
+
+	dir = opendir(dev_path);
+	if (!dir)
+		return NULL;
+
+	for (ent = readdir(dir); ent; ent = readdir(dir)) {
+		char buf[strlen(dev_path) + strlen(ent->d_name) + 1];
+
+		/* Check if dir is a controller, ignore namespaces*/
+		if (!(strncmp(ent->d_name, "nvme", 4) == 0) ||
+		    (strrchr(ent->d_name, 'n') != &ent->d_name[0]))
+			continue;
+
+		sprintf(buf, "%s/%s", dev_path, ent->d_name);
+		rp = realpath(buf, NULL);
+		break;
+	}
+
+	closedir(dir);
+	return rp;
+}
+
 char *devt_to_devpath(dev_t dev)
 {
 	char device[46];
+	char *rp;
+	char *buf;
 
 	sprintf(device, "/sys/dev/block/%d:%d/device", major(dev), minor(dev));
-	return realpath(device, NULL);
+
+	rp = realpath(device, NULL);
+	if (!rp)
+		return NULL;
+
+	buf = get_nvme_multipath_dev_hw_path(rp);
+	if (buf) {
+		free(rp);
+		return buf;
+	}
+
+	return rp;
 }
 
 char *diskfd_to_devpath(int fd)
@@ -797,3 +850,27 @@ int imsm_is_nvme_supported(int disk_fd, int verbose)
 	}
 	return 1;
 }
+
+/* Verify if multipath is supported by NVMe controller
+ * Returns:
+ *	0 - not supported
+ *	1 - supported
+ */
+int is_multipath_nvme(int disk_fd)
+{
+	char path_buf[PATH_MAX];
+	char ns_path[PATH_MAX];
+	char *kname = fd2kname(disk_fd);
+
+	if (!kname)
+		return 0;
+	sprintf(path_buf, "/sys/block/%s", kname);
+
+	if (!realpath(path_buf, ns_path))
+		return 0;
+
+	if (strncmp(ns_path, NVME_SUBSYS_PATH, strlen(NVME_SUBSYS_PATH)) == 0)
+		return 1;
+
+	return 0;
+}
diff --git a/platform-intel.h b/platform-intel.h
index 7371478e..8396a0f1 100644
--- a/platform-intel.h
+++ b/platform-intel.h
@@ -236,6 +236,7 @@ static inline char *guid_str(char *buf, struct efi_guid guid)
 	return buf;
 }
 
+char *get_nvme_multipath_dev_hw_path(const char *dev_path);
 char *diskfd_to_devpath(int fd);
 __u16 devpath_to_vendor(const char *dev_path);
 struct sys_dev *find_driver_devices(const char *bus, const char *driver);
@@ -252,4 +253,5 @@ const struct imsm_orom *get_orom_by_device_id(__u16 device_id);
 struct sys_dev *device_by_id(__u16 device_id);
 struct sys_dev *device_by_id_and_path(__u16 device_id, const char *path);
 int imsm_is_nvme_supported(int disk_fd, int verbose);
+int is_multipath_nvme(int disk_fd);
 char *vmd_domain_to_controller(struct sys_dev *hba, char *buf);
diff --git a/super-intel.c b/super-intel.c
index 715febf7..46513416 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -2347,9 +2347,9 @@ static int ahci_enumerate_ports(const char *hba_path, int port_count, int host_b
 static int print_nvme_info(struct sys_dev *hba)
 {
 	char buf[1024];
+	char *device_path;
 	struct dirent *ent;
 	DIR *dir;
-	char *rp;
 	int fd;
 
 	dir = opendir("/sys/block/");
@@ -2358,19 +2358,23 @@ static int print_nvme_info(struct sys_dev *hba)
 
 	for (ent = readdir(dir); ent; ent = readdir(dir)) {
 		if (strstr(ent->d_name, "nvme")) {
-			sprintf(buf, "/sys/block/%s", ent->d_name);
-			rp = realpath(buf, NULL);
-			if (!rp)
+			fd = open_dev(ent->d_name);
+			if (fd < 0)
 				continue;
-			if (path_attached_to_hba(rp, hba->path)) {
-				fd = open_dev(ent->d_name);
-				if (!imsm_is_nvme_supported(fd, 0)) {
-					if (fd >= 0)
-						close(fd);
-					free(rp);
-					continue;
-				}
 
+			if (!imsm_is_nvme_supported(fd, 0)) {
+				if (fd >= 0)
+					close(fd);
+				continue;
+			}
+
+			device_path = diskfd_to_devpath(fd);
+			if (!device_path) {
+				close(fd);
+				continue;
+			}
+
+			if (path_attached_to_hba(device_path, hba->path)) {
 				fd2devname(fd, buf);
 				if (hba->type == SYS_DEV_VMD)
 					printf(" NVMe under VMD : %s", buf);
@@ -2381,9 +2385,9 @@ static int print_nvme_info(struct sys_dev *hba)
 					printf(" (%s)\n", buf);
 				else
 					printf("()\n");
-				close(fd);
 			}
-			free(rp);
+			free(device_path);
+			close(fd);
 		}
 	}
 
@@ -5858,6 +5862,7 @@ static int add_to_super_imsm(struct supertype *st, mdu_disk_info_t *dk,
 		int i;
 		char *devpath = diskfd_to_devpath(fd);
 		char controller_path[PATH_MAX];
+		char *controller_name;
 
 		if (!devpath) {
 			pr_err("failed to get devpath, aborting\n");
@@ -5868,6 +5873,11 @@ static int add_to_super_imsm(struct supertype *st, mdu_disk_info_t *dk,
 		}
 
 		snprintf(controller_path, PATH_MAX-1, "%s/device", devpath);
+
+		controller_name = basename(devpath);
+		if (is_multipath_nvme(fd))
+			pr_err("%s controller supports Multi-Path I/O, Intel (R) VROC does not support multipathing\n", controller_name);
+
 		free(devpath);
 
 		if (!imsm_is_nvme_supported(dd->fd, 1)) {
-- 
2.26.2

