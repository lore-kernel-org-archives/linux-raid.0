Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58882535B0
	for <linux-raid@vger.kernel.org>; Mon, 18 Mar 2024 16:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710779180; cv=none; b=q0OEjr1QWM9fmopcH/6bztaKIRVcJEVnGBb/vMRLyaDD5PQpTDd6q+XjWAkMOPsM5nc16xzV+TlhXf3UVx5Dw6vc8eD6MU4zLSkKCGa5psS6B/LEVhMICDO/VVJvQqpdf07KQFgsZ/RxjasTmDXHv6Sg0pSAmpORbkRM+7f/GsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710779180; c=relaxed/simple;
	bh=9KzqBfjmo9FqxYF0Rj1tSKG4gyhDhMyYuTfjZPJsuUI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fXVxhAGxZx5kob7PifJ/zPpMfFqZINjf4iXKkrNFHUjBKSwgTchYn+WNqVnqbQx4TYVnUWyYHaH+67xrIrp3fkJmXyIBtdaltmNllmDNVKZ0OtYY9Ie0aqjAVQu+JS4mzDF5fM66pZ0n93ay/rnCtugrJTykzMuZzZEOoM9o2js=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Q1arVBSV; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Q1arVBSV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710779179; x=1742315179;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9KzqBfjmo9FqxYF0Rj1tSKG4gyhDhMyYuTfjZPJsuUI=;
  b=Q1arVBSVW/AClerDJXi9+9bPAW7CKvqFXM/QdwaK6/CNygYKTD4HUKsN
   2oUXbfrXM+caaoQv6zXx8IhpE5kALr2ANVN3CCc0maA+/JRImewUKWKwm
   VE0BPkJxhZmg9JPf5bSNvJw1FT0fpW33Okqc1m/evaFiQQPc//rdruBwi
   dentjZJXC/qZhZvLg5iWqOjeQvXxwp1fXY+pv8Er/6ZPgN3uk3WPc6yC7
   W5XX2IZWlM+rwY4OF8x3Ow63Jc9Mf/ZxWDC/kTvzuMTwngLUt/oUJWYXi
   7vQ9TCF9gDgeh9nAURyYwKaCsM/PLMVFDl6+RltLUy2y0BCnQc3bQU5tk
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11017"; a="5453383"
X-IronPort-AV: E=Sophos;i="6.07,134,1708416000"; 
   d="scan'208";a="5453383"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2024 09:26:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,134,1708416000"; 
   d="scan'208";a="13554014"
Received: from linux-myjy.igk.intel.com ([10.102.108.92])
  by orviesa009.jf.intel.com with ESMTP; 18 Mar 2024 09:26:10 -0700
From: Blazej Kucman <blazej.kucman@intel.com>
To: mariusz.tkaczyk@linux.intel.com,
	jes@trained-monkey.org
Cc: linux-raid@vger.kernel.org
Subject: [PATCH 5/5] imsm: drive encryption policy implementation
Date: Mon, 18 Mar 2024 17:25:35 +0100
Message-Id: <20240318162535.13674-6-blazej.kucman@intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20240318162535.13674-1-blazej.kucman@intel.com>
References: <20240318162535.13674-1-blazej.kucman@intel.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

IMSM cares about drive encryption state.
It is not allowed to mix disks with different encryption state
within one md device. This policy will verify that attempt to use disks
with different encryption states will fail.
Verification is performed for devices NVMe/SATA Opal and SATA.

There is one exception, Opal SATA drives encryption is not checked when
ENCRYPTION_NO_VERIFY key with "sata_opal" value is set in conf,
for this reason such drives are treated as with encryption disabled.

Signed-off-by: Blazej Kucman <blazej.kucman@intel.com>
---
 super-intel.c | 73 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 73 insertions(+)

diff --git a/super-intel.c b/super-intel.c
index c5eff352..54d2103a 100644
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
+		status = get_nvme_opal_encryption_informations(disk_fd, &information, verbose);
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
+		if (information.status == ENS_LOCKED) {
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

