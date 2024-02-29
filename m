Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FA657D060
	for <linux-raid@vger.kernel.org>; Thu, 29 Feb 2024 11:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709207571; cv=none; b=fKwS5gpoe64Z++Fk4yF2/89eBnDLF4L9rOONaWMXfw5ggdzkhZJLg4/qg4L6X5V3bZtSFzK+xcXd1bWgeeL0RkHKHFOFN69yqel07OkRyQvTA9LMsIeCJTdkY6x1TigzWWraIGhk5jDH0SrbDnzQJbug2V8PR1/NfkXjdAGTvoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709207571; c=relaxed/simple;
	bh=+qMCtxFmy2MPOHqnQmZjLQAvARVCHMxYwUGAw1srI9Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UCedCcdXzpUkKsLM9p+iWVf/kQpAXAgKmBGWhNc/qmTLD354uCgf9NtUyi8c2GAXrCEX9KQ6wgZ3HvqFSQtyRkn+x+ZtsKUyEhxDXfF65bENaGA63E6Q2n+kFyx/xjY9poVrQsc6BMzRBGmzpVsW6VvVUP0i9NldQc0QP7zmqGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=c0dfJNAj; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="c0dfJNAj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709207570; x=1740743570;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+qMCtxFmy2MPOHqnQmZjLQAvARVCHMxYwUGAw1srI9Y=;
  b=c0dfJNAjx2/Hb4b4lpaB8fA/1zL77sZ2mWlT0/nms85mB98f8IZ/bL7O
   X4CGfvBOXEnzX8XqkCEsMEaRZ4+4CSM/99vnXdEL47gDJJy9RQsCojRqs
   X2QvFRcvalP9uR4LWCOD7DqdSGNe/RET2AGMFAGVV58u6Mhf9JxU+swgd
   eXtW8VzBlEu9r8RtaimoYCB0lWdXJxlQO5O5tY2bfIkjBAWlkB8zT/tsM
   4vGnSyS6CVUBn+vajL5ygs46IWSOno1RLHZ/YnwPvkhfXDXLs/oZSthxh
   V0c1ow68T2pjU/QmFEsHz7guUpLBos07fu2fp/bNxAvgNUsJaPbZePfFk
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10998"; a="7499483"
X-IronPort-AV: E=Sophos;i="6.06,194,1705392000"; 
   d="scan'208";a="7499483"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Feb 2024 03:52:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,194,1705392000"; 
   d="scan'208";a="7754838"
Received: from unknown (HELO mtkaczyk-devel.igk.intel.com) ([10.102.108.91])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Feb 2024 03:52:49 -0800
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: jes@trained-monkey.org
Cc: linux-raid@vger.kernel.org,
	Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Subject: [PATCH 11/13] imsm: test_and_add_device_policies() implementation
Date: Thu, 29 Feb 2024 12:52:15 +0100
Message-Id: <20240229115217.26543-12-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20240229115217.26543-1-mariusz.tkaczyk@linux.intel.com>
References: <20240229115217.26543-1-mariusz.tkaczyk@linux.intel.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch removes get_disk_controller_domain_imsm() in favour of
test_and_add_device_policies_imsm(). It is used by
create, add and mdmonitor.

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 platform-intel.h |   1 -
 super-intel.c    | 123 ++++++++++++++++++++++++++++++++++-------------
 2 files changed, 90 insertions(+), 34 deletions(-)

diff --git a/platform-intel.h b/platform-intel.h
index ce29d3da58e4..3c2bc595f7b5 100644
--- a/platform-intel.h
+++ b/platform-intel.h
@@ -262,7 +262,6 @@ int disk_attached_to_hba(int fd, const char *hba_path);
 int devt_attached_to_hba(dev_t dev, const char *hba_path);
 char *devt_to_devpath(dev_t dev, int dev_level, char *buf);
 int path_attached_to_hba(const char *disk_path, const char *hba_path);
-const char *get_sys_dev_type(enum sys_dev_type);
 const struct orom_entry *get_orom_entry_by_device_id(__u16 dev_id);
 const struct imsm_orom *get_orom_by_device_id(__u16 device_id);
 struct sys_dev *device_by_id(__u16 device_id);
diff --git a/super-intel.c b/super-intel.c
index 90928dce722e..fcbfb85d009f 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -11220,39 +11220,90 @@ abort:
 	return retval;
 }
 
-static char disk_by_path[] = "/dev/disk/by-path/";
-
-static const char *imsm_get_disk_controller_domain(const char *path)
-{
-	char disk_path[PATH_MAX];
-	char *drv=NULL;
-	struct stat st;
-
-	strncpy(disk_path, disk_by_path, PATH_MAX);
-	strncat(disk_path, path, PATH_MAX - strlen(disk_path) - 1);
-	if (stat(disk_path, &st) == 0) {
-		struct sys_dev* hba;
-		char *path;
-
-		path = devt_to_devpath(st.st_rdev, 1, NULL);
-		if (path == NULL)
-			return "unknown";
-		hba = find_disk_attached_hba(-1, path);
-		if (hba && hba->type == SYS_DEV_SAS)
-			drv = "isci";
-		else if (hba && (hba->type == SYS_DEV_SATA || hba->type == SYS_DEV_SATA_VMD))
-			drv = "ahci";
-		else if (hba && hba->type == SYS_DEV_VMD)
-			drv = "vmd";
-		else if (hba && hba->type == SYS_DEV_NVME)
-			drv = "nvme";
-		else
-			drv = "unknown";
-		dprintf("path: %s hba: %s attached: %s\n",
-			path, (hba) ? hba->path : "NULL", drv);
-		free(path);
+/**
+ * test_and_add_drive_controller_policy_imsm() - add disk controller to policies list.
+ * @type: Policy type to search on list.
+ * @pols: List of currently recorded policies.
+ * @disk_fd: File descriptor of the device to check.
+ * @hba: The hba disk is attached, could be NULL if verification is disabled.
+ * @verbose: verbose flag.
+ *
+ * IMSM cares about drive physical placement. If @hba is not set, it adds unknown policy.
+ * If there is no controller policy on pols we are free to add first one. If there is a policy then,
+ * new must be the same - no controller mixing allowed.
+ */
+static mdadm_status_t
+test_and_add_drive_controller_policy_imsm(const char * const type, dev_policy_t **pols, int disk_fd,
+					  struct sys_dev *hba, const int verbose)
+{
+	const char *controller_policy = get_sys_dev_type(SYS_DEV_UNKNOWN);
+	struct dev_policy *pol = pol_find(*pols, (char *)type);
+	char devname[MAX_RAID_SERIAL_LEN];
+
+	if (hba)
+		controller_policy = get_sys_dev_type(hba->type);
+
+	if (!pol) {
+		pol_add(pols, (char *)type, (char *)controller_policy, "imsm");
+		return MDADM_STATUS_SUCCESS;
 	}
-	return drv;
+
+	if (strcmp(pol->value, controller_policy) == 0)
+		return MDADM_STATUS_SUCCESS;
+
+	fd2devname(disk_fd, devname);
+	pr_vrb("Intel(R) raid controller \"%s\" found for %s, but \"%s\" was detected earlier\n",
+	       controller_policy, devname, pol->value);
+	pr_vrb("Disks under different controllers cannot be used, aborting\n");
+
+	return MDADM_STATUS_ERROR;
+}
+
+struct imsm_drive_policy {
+	char *type;
+	mdadm_status_t (*test_and_add_drive_policy)(const char * const type,
+						    struct dev_policy **pols, int disk_fd,
+						    struct sys_dev *hba, const int verbose);
+};
+
+struct imsm_drive_policy imsm_policies[] = {
+	{"controller", test_and_add_drive_controller_policy_imsm},
+};
+
+mdadm_status_t test_and_add_drive_policies_imsm(struct dev_policy **pols, int disk_fd,
+						const int verbose)
+{
+	struct imsm_drive_policy *imsm_pol;
+	struct sys_dev *hba = NULL;
+	char path[PATH_MAX];
+	mdadm_status_t ret;
+	unsigned int i;
+
+	/* If imsm platform verification is disabled, do not search for hba. */
+	if (check_no_platform() != 1) {
+		if (!diskfd_to_devpath(disk_fd, 1, path)) {
+			pr_vrb("IMSM: Failed to retrieve device path by file descriptor.\n");
+			return MDADM_STATUS_ERROR;
+		}
+
+		hba = find_disk_attached_hba(disk_fd, path);
+		if (!hba) {
+			pr_vrb("IMSM: Failed to find hba for %s\n", path);
+			return MDADM_STATUS_ERROR;
+		}
+	}
+
+	for (i = 0; i < ARRAY_SIZE(imsm_policies); i++) {
+		imsm_pol = &imsm_policies[i];
+
+		ret = imsm_pol->test_and_add_drive_policy(imsm_pol->type, pols, disk_fd, hba,
+							  verbose);
+		if (ret != MDADM_STATUS_SUCCESS)
+			/* Inherit error code */
+			return ret;
+	}
+
+	return MDADM_STATUS_SUCCESS;
 }
 
 /**
@@ -11280,6 +11331,7 @@ mdadm_status_t get_spare_criteria_imsm(struct supertype *st, char *mddev_path,
 
 	if (mddev_path) {
 		int fd = open(mddev_path, O_RDONLY);
+		mdadm_status_t rv;
 
 		if (!is_fd_valid(fd))
 			return MDADM_STATUS_ERROR;
@@ -11291,7 +11343,12 @@ mdadm_status_t get_spare_criteria_imsm(struct supertype *st, char *mddev_path,
 			}
 			free_superblock = true;
 		}
+
+		rv = mddev_test_and_add_drive_policies(st, &c->pols, fd, 0);
 		close(fd);
+
+		if (rv != MDADM_STATUS_SUCCESS)
+			goto out;
 	}
 
 	super = st->sb;
@@ -13026,7 +13083,7 @@ struct superswitch super_imsm = {
 	.update_subarray = update_subarray_imsm,
 	.load_container	= load_container_imsm,
 	.default_geometry = default_geometry_imsm,
-	.get_disk_controller_domain = imsm_get_disk_controller_domain,
+	.test_and_add_drive_policies = test_and_add_drive_policies_imsm,
 	.reshape_super  = imsm_reshape_super,
 	.manage_reshape = imsm_manage_reshape,
 	.recover_backup = recover_backup_imsm,
-- 
2.35.3

