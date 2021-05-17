Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 908E4C433B4
	for <linux-raid@archiver.kernel.org>; Mon, 17 May 2021 14:48:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 674C3601FC
	for <linux-raid@archiver.kernel.org>; Mon, 17 May 2021 14:48:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240131AbhEQOuE (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 17 May 2021 10:50:04 -0400
Received: from mga05.intel.com ([192.55.52.43]:42597 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241403AbhEQOro (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 17 May 2021 10:47:44 -0400
IronPort-SDR: 6Z/W0Gmdv89mctkbcaXr1NkvvCu4jiWQCmNdTMh9cI6xDC7DX4tYefxnJjJkZnRQ66BgnVvgbe
 6iGjCqWlpqOA==
X-IronPort-AV: E=McAfee;i="6200,9189,9987"; a="286009446"
X-IronPort-AV: E=Sophos;i="5.82,307,1613462400"; 
   d="scan'208";a="286009446"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2021 07:39:22 -0700
IronPort-SDR: EOM6ju9hXZhU+rlg8Lr0OUnPT4VJjzY2y8IbUg3wFeYzfwLCvbo4BYQo0xIVt2GQKSrRKjYLYY
 3VlxjV+Bgu9w==
X-IronPort-AV: E=Sophos;i="5.82,307,1613462400"; 
   d="scan'208";a="472432917"
Received: from mtkaczyk-devel.igk.intel.com ([10.102.102.23])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2021 07:39:21 -0700
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH 2/4] imsm: add devpath_to_char method
Date:   Mon, 17 May 2021 16:39:01 +0200
Message-Id: <20210517143903.10077-3-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210517143903.10077-1-mariusz.tkaczyk@linux.intel.com>
References: <20210517143903.10077-1-mariusz.tkaczyk@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Add method for reading sysfs attributes and propagate it across IMSM code.

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 platform-intel.c | 23 +++++++++++++++++++++++
 platform-intel.h |  2 ++
 super-intel.c    | 33 +++++++++++++++------------------
 3 files changed, 40 insertions(+), 18 deletions(-)

diff --git a/platform-intel.c b/platform-intel.c
index 2ed63ed..9401784 100644
--- a/platform-intel.c
+++ b/platform-intel.c
@@ -239,6 +239,29 @@ __u16 devpath_to_vendor(const char *dev_path)
 	return id;
 }
 
+/* Description: Read text value of dev_path/entry field
+ * Parameters:
+ *	dev_path - sysfs path to the device
+ *	entry - entry to be read
+ *	buf - buffer for read value
+ *	len - size of buf
+ *	verbose - error logging level
+ */
+int devpath_to_char(const char *dev_path, const char *entry, char *buf, int len,
+		    int verbose)
+{
+	char path[PATH_MAX];
+
+	snprintf(path, sizeof(path), "%s/%s", dev_path, entry);
+	if (load_sys(path, buf, len)) {
+		if (verbose)
+			pr_err("Cannot read %s, aborting\n", path);
+		return 1;
+	}
+
+	return 0;
+}
+
 struct sys_dev *find_intel_devices(void)
 {
 	struct sys_dev *ahci, *isci, *nvme;
diff --git a/platform-intel.h b/platform-intel.h
index f93add5..45d98cd 100644
--- a/platform-intel.h
+++ b/platform-intel.h
@@ -238,6 +238,8 @@ static inline char *guid_str(char *buf, struct efi_guid guid)
 
 char *get_nvme_multipath_dev_hw_path(const char *dev_path);
 char *diskfd_to_devpath(int fd, int dev_level, char *buf);
+int devpath_to_char(const char *dev_path, const char *entry, char *buf,
+		    int len, int verbose);
 __u16 devpath_to_vendor(const char *dev_path);
 struct sys_dev *find_driver_devices(const char *bus, const char *driver);
 struct sys_dev *find_intel_devices(void);
diff --git a/super-intel.c b/super-intel.c
index cff8550..c352f50 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -2246,7 +2246,7 @@ static int ahci_enumerate_ports(const char *hba_path, int port_count, int host_b
 		char vendor[64];
 		char buf[1024];
 		int major, minor;
-		char *device;
+		char device[PATH_MAX];
 		char *c;
 		int port;
 		int type;
@@ -2262,20 +2262,15 @@ static int ahci_enumerate_ports(const char *hba_path, int port_count, int host_b
 			continue;
 		}
 
-		/* retrieve the scsi device type */
-		if (asprintf(&device, "/sys/dev/block/%d:%d/device/xxxxxxx", major, minor) < 0) {
+		/* retrieve the scsi device */
+		if (!devt_to_devpath(makedev(major, minor), 1, device)) {
 			if (verbose > 0)
-				pr_err("failed to allocate 'device'\n");
+				pr_err("failed to get device\n");
 			err = 2;
 			break;
 		}
-		sprintf(device, "/sys/dev/block/%d:%d/device/type", major, minor);
-		if (load_sys(device, buf, sizeof(buf)) != 0) {
-			if (verbose > 0)
-				pr_err("failed to read device type for %s\n",
-					path);
+		if (devpath_to_char(device, "type", buf, sizeof(buf), 0)) {
 			err = 2;
-			free(device);
 			break;
 		}
 		type = strtoul(buf, NULL, 10);
@@ -2284,8 +2279,9 @@ static int ahci_enumerate_ports(const char *hba_path, int port_count, int host_b
 		if (!(type == 0 || type == 7 || type == 14)) {
 			vendor[0] = '\0';
 			model[0] = '\0';
-			sprintf(device, "/sys/dev/block/%d:%d/device/vendor", major, minor);
-			if (load_sys(device, buf, sizeof(buf)) == 0) {
+
+			if (devpath_to_char(device, "vendor", buf,
+					    sizeof(buf), 0) == 0) {
 				strncpy(vendor, buf, sizeof(vendor));
 				vendor[sizeof(vendor) - 1] = '\0';
 				c = (char *) &vendor[sizeof(vendor) - 1];
@@ -2293,8 +2289,9 @@ static int ahci_enumerate_ports(const char *hba_path, int port_count, int host_b
 					*c-- = '\0';
 
 			}
-			sprintf(device, "/sys/dev/block/%d:%d/device/model", major, minor);
-			if (load_sys(device, buf, sizeof(buf)) == 0) {
+
+			if (devpath_to_char(device, "model", buf,
+					    sizeof(buf), 0) == 0) {
 				strncpy(model, buf, sizeof(model));
 				model[sizeof(model) - 1] = '\0';
 				c = (char *) &model[sizeof(model) - 1];
@@ -2319,7 +2316,6 @@ static int ahci_enumerate_ports(const char *hba_path, int port_count, int host_b
 				}
 		} else
 			buf[0] = '\0';
-		free(device);
 
 		/* chop device path to 'host%d' and calculate the port number */
 		c = strchr(&path[hba_len], '/');
@@ -4026,7 +4022,7 @@ static void fd2devname(int fd, char *name)
 
 static int nvme_get_serial(int fd, void *buf, size_t buf_len)
 {
-	char path[60];
+	char path[PATH_MAX];
 	char *name = fd2kname(fd);
 
 	if (!name)
@@ -4035,9 +4031,10 @@ static int nvme_get_serial(int fd, void *buf, size_t buf_len)
 	if (strncmp(name, "nvme", 4) != 0)
 		return 1;
 
-	snprintf(path, sizeof(path) - 1, "/sys/block/%s/device/serial", name);
+	if (!diskfd_to_devpath(fd, 1, path))
+		return 1;
 
-	return load_sys(path, buf, buf_len);
+	return devpath_to_char(path, "serial", buf, buf_len, 0);
 }
 
 extern int scsi_get_serial(int fd, void *buf, size_t buf_len);
-- 
2.26.2

