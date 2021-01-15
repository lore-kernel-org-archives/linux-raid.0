Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFEE1C433E0
	for <linux-raid@archiver.kernel.org>; Fri, 15 Jan 2021 15:32:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 73A6123136
	for <linux-raid@archiver.kernel.org>; Fri, 15 Jan 2021 15:32:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728020AbhAOPcK (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 15 Jan 2021 10:32:10 -0500
Received: from mga17.intel.com ([192.55.52.151]:51592 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725946AbhAOPcJ (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Fri, 15 Jan 2021 10:32:09 -0500
IronPort-SDR: AZQeCUvXn92sJlC3fUhg2Li+Audzn1dnjEVI53WyHJfaKF9hfxiyRUwXqDu64Bb4jtVsjSJZIq
 tPEC6HFQ30gg==
X-IronPort-AV: E=McAfee;i="6000,8403,9864"; a="158337834"
X-IronPort-AV: E=Sophos;i="5.79,349,1602572400"; 
   d="scan'208";a="158337834"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2021 07:31:28 -0800
IronPort-SDR: PPt0W1XR8rTsAaL8QR1koIT+Auznd9KX3a9ua76/GkshkqxY+quNHd6AtmScOHt59zUvMlA9K7
 o/K9v8LFh4Sw==
X-IronPort-AV: E=Sophos;i="5.79,349,1602572400"; 
   d="scan'208";a="354338184"
Received: from unknown (HELO gklab-109-123.igk.intel.com) ([10.102.109.123])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2021 07:31:27 -0800
From:   Oleksandr Shchirskyi <oleksandr.shchirskyi@intel.com>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH] imsm: nvme multipath support
Date:   Fri, 15 Jan 2021 16:28:24 +0100
Message-Id: <20210115152824.51793-1-oleksandr.shchirskyi@intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Blazej Kucman <blazej.kucman@intel.com>

Add support for nvme devices which are represented
via nvme-subsystem.
Print warning when multi-path disk is added to RAID

Signed-off-by: Oleksandr Shchirskyi <oleksandr.shchirskyi@intel.com>
Signed-off-by: Blazej Kucman <blazej.kucman@intel.com>
---
 platform-intel.c | 83 +++++++++++++++++++++++++++++++++++++++++++++++-
 platform-intel.h |  2 ++
 super-intel.c    | 38 ++++++++++++++--------
 3 files changed, 108 insertions(+), 15 deletions(-)

diff --git a/platform-intel.c b/platform-intel.c
index f1f6d4cd..2ee5a8da 100644
--- a/platform-intel.c
+++ b/platform-intel.c
@@ -668,12 +668,71 @@ const struct imsm_orom *find_imsm_capability(struct sys_dev *hba)
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
+	char buf[PATH_MAX];
+	DIR *dir;
+	struct dirent *ent;
+	char *nvme_subsystem_path = "/devices/virtual/nvme-subsystem";
+	char *ptr;
+	char *rp = NULL;
+
+	if (!strstr(dev_path, nvme_subsystem_path))
+		return NULL;
+
+	memcpy(buf, dev_path, sizeof(buf) - 1);
+	buf[PATH_MAX-1] = '\0';
+
+	dir = opendir(buf);
+	if (!dir)
+		return NULL;
+
+	for (ent = readdir(dir); ent; ent = readdir(dir)) {
+		if (!(strncmp(ent->d_name, "nvme", 4) == 0))
+			continue;
+
+		// Needed is realpath to controller not to namespace.
+		ptr = ent->d_name + 4;
+		if (!strstr(ptr, "n")) {
+			char buf1[PATH_MAX + NAME_MAX + 1];
+
+			sprintf(buf1, "%s/%s", buf, ent->d_name);
+			rp = realpath(buf1, NULL);
+			break;
+		}
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
@@ -797,3 +856,25 @@ int imsm_is_nvme_supported(int disk_fd, int verbose)
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
+	char *ns_name;
+	char path_buf[PATH_MAX];
+	char ns_path[PATH_MAX];
+	char *nvme_subsystem_path = "/devices/virtual/nvme-subsystem";
+
+	ns_name = fd2kname(disk_fd);
+	sprintf(path_buf, "/sys/block/%s", ns_name);
+	if (!realpath(path_buf, ns_path))
+		return 0;
+	if (!strstr(ns_path, nvme_subsystem_path))
+		return 0;
+
+	return 1;
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
2.27.0

---------------------------------------------------------------------
Intel Technology Poland sp. z o.o.
ul. Sowackiego 173 | 80-298 Gdask | Sd Rejonowy Gdask Pnoc | VII Wydzia Gospodarczy Krajowego Rejestru Sdowego - KRS 101882 | NIP 957-07-52-316 | Kapita zakadowy 200.000 PLN.
Ta wiadomo wraz z zacznikami jest przeznaczona dla okrelonego adresata i moe zawiera informacje poufne. W razie przypadkowego otrzymania tej wiadomoci, prosimy o powiadomienie nadawcy oraz trwae jej usunicie; jakiekolwiek przegldanie lub rozpowszechnianie jest zabronione.
This e-mail and any attachments may contain confidential material for the sole use of the intended recipient(s). If you are not the intended recipient, please contact the sender and delete all copies; any review or distribution by others is strictly prohibited.
 

