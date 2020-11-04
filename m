Return-Path: <SRS0=4QbR=EK=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11B22C2D0A3
	for <linux-raid@archiver.kernel.org>; Wed,  4 Nov 2020 09:01:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B57B52220B
	for <linux-raid@archiver.kernel.org>; Wed,  4 Nov 2020 09:01:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727246AbgKDJBk (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 4 Nov 2020 04:01:40 -0500
Received: from mga04.intel.com ([192.55.52.120]:54363 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725891AbgKDJBk (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 4 Nov 2020 04:01:40 -0500
IronPort-SDR: HWVLCUDDphtx4gp9aNxbbloFKZ35sWk4DWCB8puExWhipVKof9CNYXVdL7l53UOTLC17kBYKPN
 HPhIsSO1RG1Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9794"; a="166597676"
X-IronPort-AV: E=Sophos;i="5.77,450,1596524400"; 
   d="scan'208";a="166597676"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2020 01:01:40 -0800
IronPort-SDR: W+QUBvupLb1tQ30unVvi+r9vnpRer2pD56/H3VcxMYPpFw4r1nox48fvhlQd+i1EvjQdMKx2m6
 EwBXPgiBnwLQ==
X-IronPort-AV: E=Sophos;i="5.77,450,1596524400"; 
   d="scan'208";a="325534455"
Received: from mtkaczyk-devel.igk.intel.com ([10.102.102.23])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2020 01:01:38 -0800
From:   Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH] imsm: limit support to first NVMe namespace
Date:   Wed,  4 Nov 2020 10:01:28 +0100
Message-Id: <20201104090128.17096-1-mariusz.tkaczyk@intel.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Due to metadata limitations NVMe multinamespace support has to be removed.

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
---
 platform-intel.c | 31 +++++++++++++++++++++++++++++++
 platform-intel.h |  1 +
 super-intel.c    | 11 ++++++++++-
 3 files changed, 42 insertions(+), 1 deletion(-)

diff --git a/platform-intel.c b/platform-intel.c
index 04bffc57..f1f6d4cd 100644
--- a/platform-intel.c
+++ b/platform-intel.c
@@ -766,3 +766,34 @@ char *vmd_domain_to_controller(struct sys_dev *hba, char *buf)
 	closedir(dir);
 	return NULL;
 }
+/* Verify that NVMe drive is supported by IMSM
+ * Returns:
+ *	0 - not supported
+ *	1 - supported
+ */
+int imsm_is_nvme_supported(int disk_fd, int verbose)
+{
+	char nsid_path[PATH_MAX];
+	char buf[PATH_MAX];
+	struct stat stb;
+
+	if (disk_fd < 0)
+		return 0;
+
+	if (fstat(disk_fd, &stb))
+		return 0;
+
+	snprintf(nsid_path, PATH_MAX-1, "/sys/dev/block/%d:%d/nsid",
+		 major(stb.st_rdev), minor(stb.st_rdev));
+
+	if (load_sys(nsid_path, buf, sizeof(buf))) {
+		pr_err("Cannot read %s, rejecting drive\n", nsid_path);
+		return 0;
+	}
+	if (strtoll(buf, NULL, 10) != 1) {
+		if (verbose)
+			pr_err("Only first namespace is supported by IMSM, aborting\n");
+		return 0;
+	}
+	return 1;
+}
diff --git a/platform-intel.h b/platform-intel.h
index 7cb370ef..7371478e 100644
--- a/platform-intel.h
+++ b/platform-intel.h
@@ -251,4 +251,5 @@ const struct orom_entry *get_orom_entry_by_device_id(__u16 dev_id);
 const struct imsm_orom *get_orom_by_device_id(__u16 device_id);
 struct sys_dev *device_by_id(__u16 device_id);
 struct sys_dev *device_by_id_and_path(__u16 device_id, const char *path);
+int imsm_is_nvme_supported(int disk_fd, int verbose);
 char *vmd_domain_to_controller(struct sys_dev *hba, char *buf);
diff --git a/super-intel.c b/super-intel.c
index 3a73d2b3..ffda5332 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -2364,7 +2364,9 @@ static int print_nvme_info(struct sys_dev *hba)
 				continue;
 			if (path_attached_to_hba(rp, hba->path)) {
 				fd = open_dev(ent->d_name);
-				if (fd < 0) {
+				if (!imsm_is_nvme_supported(fd, 0)) {
+					if (fd >= 0)
+						close(fd);
 					free(rp);
 					continue;
 				}
@@ -5873,6 +5875,13 @@ static int add_to_super_imsm(struct supertype *st, mdu_disk_info_t *dk,
 		snprintf(controller_path, PATH_MAX-1, "%s/device", devpath);
 		free(devpath);
 
+		if (!imsm_is_nvme_supported(dd->fd, 1)) {
+			if (dd->devname)
+				free(dd->devname);
+			free(dd);
+			return 1;
+		}
+
 		if (devpath_to_vendor(controller_path) == 0x8086) {
 			/*
 			 * If Intel's NVMe drive has serial ended with
-- 
2.25.0

