Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60D993FB31
	for <linux-raid@vger.kernel.org>; Fri, 22 Mar 2024 11:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711108317; cv=none; b=U5DwfSNS5T6ec/VfDU5Z4i63jodV4l///E+tjk8cLL8fRGiNKgPwrSTWM3DrOEdISQC8Ch0jSpdPkXmgjRbtXVvzXhCYiR93jmu1C35G/mYseO7JXTm6a87oBflnZ+FFtxe1s3RWO3WqAqyj1VSZdIuuzGGENDdpQvCJvpI4r9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711108317; c=relaxed/simple;
	bh=Kp2ouRFUjgUmsxg/96Sv/xQdQut5unKAzW1l5qoHi+A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IHmz/a9XGdkeNaxDSb+jBZCYD+DwhSFSZKEbJwD6YyfFleyVZbtvNOZ5usQ/8NM/7apsNlWjF8P0CZUkQDkQz643vwQcZeq2Iwm+m0l+BrcFdnQknw5tfGoq0//YIlSThCnihcMzImCD90SxBbKkL71Tztmq+cxj+t8yCSkDpWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eA+InolI; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eA+InolI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711108316; x=1742644316;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Kp2ouRFUjgUmsxg/96Sv/xQdQut5unKAzW1l5qoHi+A=;
  b=eA+InolIzfCs0abe1vGjwNQkmnCdpJsCBTtQB6rgb0uVgbX30o53r2bT
   8+TCsTcMqaOTSepZIqlRjQX1BP+vedJQzrmEVh4VXSy3VOBQ6j0jZspia
   0slCzoDP+G1ufmwUOh+2Ia4UqiwST8o1M1kQ+gvKzxTQZzerBSmxdl9B5
   7s117HqvcDDz1DQJIHBCFcY6pWCMbEXtaIrG6kBUXLaU+nucdCMnrcPvL
   GjuMZS+phoYquXKAngz4BbuwbJ/Iw5JqgGtyara8eUVt3xsujlAiSxgTw
   5TPsRpIdZqBjNHZshhzbQVS1GJ0EO62IuSbAWGkCf6AHRiKDsbrpHGV9c
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11020"; a="6006810"
X-IronPort-AV: E=Sophos;i="6.07,145,1708416000"; 
   d="scan'208";a="6006810"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2024 04:51:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,145,1708416000"; 
   d="scan'208";a="46001024"
Received: from linux-myjy.igk.intel.com ([10.102.108.92])
  by fmviesa001.fm.intel.com with ESMTP; 22 Mar 2024 04:51:55 -0700
From: Blazej Kucman <blazej.kucman@intel.com>
To: mariusz.tkaczyk@linux.intel.com,
	jes@trained-monkey.org
Cc: linux-raid@vger.kernel.org
Subject: [PATCH v2 6/6] imsm: drive encryption policy implementation
Date: Fri, 22 Mar 2024 12:51:20 +0100
Message-Id: <20240322115120.12325-7-blazej.kucman@intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20240322115120.12325-1-blazej.kucman@intel.com>
References: <20240322115120.12325-1-blazej.kucman@intel.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

IMSM cares about drive encryption state. It is not allowed to mix disks
with different encryption state within one md device. This policy will
verify that attempt to use disks with different encryption states will
fail. Verification is performed for devices NVMe/SATA Opal and SATA.

There is one exception, Opal SATA drives encryption is not checked when
ENCRYPTION_NO_VERIFY key with "sata_opal" value is set in conf, for this
reason such drives are treated as without encryption support.

Signed-off-by: Blazej Kucman <blazej.kucman@intel.com>
---
 super-intel.c | 73 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 73 insertions(+)

diff --git a/super-intel.c b/super-intel.c
index 885d7a91..2923a0f8 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -11291,6 +11291,78 @@ test_and_add_drive_controller_policy_imsm(const char * const type, dev_policy_t
 	return MDADM_STATUS_ERROR;
 }
 
+/**
+ * test_and_add_drive_encryption_policy_imsm() - add disk encryption to policies list.
+ * @type: policy type to search in the list.
+ * @pols: list of currently recorded policies.
+ * @disk_fd: file descriptor of the device to check.
+ * @hba: The hba to which the drive is attached, could be NULL if verification is disabled.
+ * @verbose: verbose flag.
+ *
+ * IMSM cares about drive encryption state. It is not allowed to mix disks with different
+ * encryption state within one md device.
+ * If there is no encryption policy on pols we are free to add first one.
+ * If there is a policy then, new must be the same.
+ */
+static mdadm_status_t
+test_and_add_drive_encryption_policy_imsm(const char * const type, dev_policy_t **pols, int disk_fd,
+					  struct sys_dev *hba, const int verbose)
+{
+	struct dev_policy *expected_policy = pol_find(*pols, (char *)type);
+	struct encryption_information information = {0};
+	char *encryption_state = "Unknown";
+	int status = MDADM_STATUS_SUCCESS;
+	bool encryption_checked = true;
+	char devname[PATH_MAX];
+
+	if (!hba)
+		goto check_policy;
+
+	switch (hba->type) {
+	case SYS_DEV_NVME:
+	case SYS_DEV_VMD:
+		status = get_nvme_opal_encryption_information(disk_fd, &information, verbose);
+		break;
+	case SYS_DEV_SATA:
+	case SYS_DEV_SATA_VMD:
+		status = get_ata_encryption_information(disk_fd, &information, verbose);
+		break;
+	default:
+		encryption_checked = false;
+	}
+
+	if (status) {
+		fd2devname(disk_fd, devname);
+		pr_vrb("Failed to read encryption information of device %s\n", devname);
+		return MDADM_STATUS_ERROR;
+	}
+
+	if (encryption_checked) {
+		if (information.status == ENC_STATUS_LOCKED) {
+			fd2devname(disk_fd, devname);
+			pr_vrb("Device %s is in Locked state, cannot use. Aborting.\n", devname);
+			return MDADM_STATUS_ERROR;
+		}
+		encryption_state = (char *)get_encryption_status_string(information.status);
+	}
+
+check_policy:
+	if (expected_policy) {
+		if (strcmp(expected_policy->value, encryption_state) == 0)
+			return MDADM_STATUS_SUCCESS;
+
+		fd2devname(disk_fd, devname);
+		pr_vrb("Encryption status \"%s\" detected for disk %s, but \"%s\" status was detected eariler.\n",
+		       encryption_state, devname, expected_policy->value);
+		pr_vrb("Disks with different encryption status cannot be used.\n");
+		return MDADM_STATUS_ERROR;
+	}
+
+	pol_add(pols, (char *)type, encryption_state, "imsm");
+
+	return MDADM_STATUS_SUCCESS;
+}
+
 struct imsm_drive_policy {
 	char *type;
 	mdadm_status_t (*test_and_add_drive_policy)(const char * const type,
@@ -11300,6 +11372,7 @@ struct imsm_drive_policy {
 
 struct imsm_drive_policy imsm_policies[] = {
 	{"controller", test_and_add_drive_controller_policy_imsm},
+	{"encryption", test_and_add_drive_encryption_policy_imsm}
 };
 
 mdadm_status_t test_and_add_drive_policies_imsm(struct dev_policy **pols, int disk_fd,
-- 
2.35.3

