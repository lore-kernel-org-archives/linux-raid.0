Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1251F7CF20
	for <linux-raid@vger.kernel.org>; Thu, 29 Feb 2024 11:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709207563; cv=none; b=RmXPuzmt4jeDJYVs/fKYFvjdH1rNEvNPyP7S9o+qEhCYCPiqo2iq6Nc+WHy87SF5PCmqOlNO76sr+CGExYMj6URZ6xtwd3Pf4K5uCOp25oKADsZxUn54s/zk4GuFKuBgyBGo5WyOHYjZ3myy+JgH94w0Gyy4c94ltbQDkHLyPhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709207563; c=relaxed/simple;
	bh=ivLtIdJSrmm8aw7tvBQukJo7WhnVZ13l1vWpACaLQ9w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NqNQh0qm1eIZyXtDi+qNZIEv4xr0wHvrQU5z0gkYRVs+WbnNTUuIJa01VOmzmGN0c+cd5Sv9Xv6ziCf+ClTlMu9bynEmam+Id/vxzcLEYFNN8vmqnC8U15sy2/WsCdShLd4abE74CWXkyM5LigbuY5jrDKitMCjyW1PDdzL7Z24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=msXDbMCj; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="msXDbMCj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709207562; x=1740743562;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ivLtIdJSrmm8aw7tvBQukJo7WhnVZ13l1vWpACaLQ9w=;
  b=msXDbMCjsg4rJANWUVRMCK/7HBPDk5R8QdU2AOkfc+s2Vz/xL5S6IVWD
   cpxqOkCVYOpYTd6j7Vk30gV1/4Zp12FomED7yA2eWICVFnxu+1RvXXv06
   nh9eudosdfqhaAt+Xq6eII3frvDilhe8RJaLlH2NI+O474iglPCt9s5O+
   ickpMXpAkh6SQyfoMqkFzls6Fm4+Cqpe78/BndczIA9bRQaWbkvUQfaj/
   kr1XdOaDl6JWBpo3wOPFnS2lp8ETu4SUGf/dS5/dobjB5BCjJsKbJuMcJ
   IbtfQ/C3zZwGfuHjVua1MCqdxQJE0WzAzl7SjhgkydVwbKvnZT8oDkfQW
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10998"; a="7499462"
X-IronPort-AV: E=Sophos;i="6.06,194,1705392000"; 
   d="scan'208";a="7499462"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Feb 2024 03:52:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,194,1705392000"; 
   d="scan'208";a="7754819"
Received: from unknown (HELO mtkaczyk-devel.igk.intel.com) ([10.102.108.91])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Feb 2024 03:52:41 -0800
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: jes@trained-monkey.org
Cc: linux-raid@vger.kernel.org,
	Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Subject: [PATCH 07/13] mdadm: test_and_add device policies implementation
Date: Thu, 29 Feb 2024 12:52:11 +0100
Message-Id: <20240229115217.26543-8-mariusz.tkaczyk@linux.intel.com>
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

Add support for three scenarios:
- obtaining array wide policies via fd,
- obtaining array wide policies via struct mdinfo,
- getting policies for particular drive from the request.

Add proper functions and make them extern. These functions are used
in next patches.

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 mdadm.h  |  7 +++++
 policy.c | 93 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 100 insertions(+)

diff --git a/mdadm.h b/mdadm.h
index 889f4a0f1ecf..af2bc714bacb 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -1452,6 +1452,13 @@ extern void dev_policy_free(struct dev_policy *p);
 extern void pol_add(struct dev_policy **pol, char *name, char *val, char *metadata);
 extern struct dev_policy *pol_find(struct dev_policy *pol, char *name);
 
+extern mdadm_status_t drive_test_and_add_policies(struct supertype *st, dev_policy_t **pols,
+						  int fd, const int verbose);
+extern mdadm_status_t sysfs_test_and_add_drive_policies(struct supertype *st, dev_policy_t **pols,
+							struct mdinfo *mdi, const int verbose);
+extern mdadm_status_t mddev_test_and_add_drive_policies(struct supertype *st, dev_policy_t **pols,
+							int array_fd, const int verbose);
+
 enum policy_action {
 	act_default,
 	act_include,
diff --git a/policy.c b/policy.c
index eee9ef63adda..4b85f62d9675 100644
--- a/policy.c
+++ b/policy.c
@@ -397,6 +397,99 @@ struct dev_policy *path_policy(char **paths, char *type)
 	return pol;
 }
 
+/**
+ * drive_test_and_add_policies() - get policies for drive and add them to pols.
+ * @st: supertype.
+ * @pols: pointer to pointer of first list entry, cannot be NULL, may point to NULL.
+ * @fd: device descriptor.
+ * @verbose: verbose flag.
+ *
+ * If supertype doesn't support this functionality return success. Use metadata handler to get
+ * policies.
+ */
+mdadm_status_t drive_test_and_add_policies(struct supertype *st, dev_policy_t **pols, int fd,
+					   const int verbose)
+{
+	if (!st->ss->test_and_add_drive_policies)
+		return MDADM_STATUS_SUCCESS;
+
+	if (st->ss->test_and_add_drive_policies(pols, fd, verbose) == MDADM_STATUS_SUCCESS) {
+		/* After successful call list cannot be empty */
+		assert(*pols);
+		return MDADM_STATUS_SUCCESS;
+	}
+
+	return MDADM_STATUS_ERROR;
+}
+
+/**
+ * sysfs_test_and_add_policies() - get policies for mddev and add them to pols.
+ * @st: supertype.
+ * @pols: pointer to pointer of first list entry, cannot be NULL, may point to NULL.
+ * @mdi: mdinfo describes the MD array, must have GET_DISKS option.
+ * @verbose: verbose flag.
+ *
+ * If supertype doesn't support this functionality return success. To get policies, all disks
+ * connected to mddev are analyzed.
+ */
+mdadm_status_t sysfs_test_and_add_drive_policies(struct supertype *st, dev_policy_t **pols,
+						 struct mdinfo *mdi, const int verbose)
+{
+	struct mdinfo *sd;
+
+	if (!st->ss->test_and_add_drive_policies)
+		return MDADM_STATUS_SUCCESS;
+
+	for (sd = mdi->devs; sd; sd = sd->next) {
+		char *devpath = map_dev(sd->disk.major, sd->disk.minor, 0);
+		int fd = dev_open(devpath, O_RDONLY);
+		int rv;
+
+		if (!is_fd_valid(fd)) {
+			pr_err("Cannot open fd for %s\n", devpath);
+			return MDADM_STATUS_ERROR;
+		}
+
+		rv = drive_test_and_add_policies(st, pols, fd, verbose);
+		close(fd);
+
+		if (rv)
+			return MDADM_STATUS_ERROR;
+	}
+
+	return MDADM_STATUS_SUCCESS;
+}
+
+/**
+ * mddev_test_and_add_policies() - get policies for mddev and add them to pols.
+ * @st: supertype.
+ * @pols: pointer to pointer of first list entry, cannot be NULL, may point to NULL.
+ * @array_fd: MD device descriptor.
+ * @verbose: verbose flag.
+ *
+ * If supertype doesn't support this functionality return success. Use fd to extract disks.
+ */
+mdadm_status_t mddev_test_and_add_drive_policies(struct supertype *st, dev_policy_t **pols,
+						 int array_fd, const int verbose)
+{
+	struct mdinfo *sra;
+	int ret;
+
+	if (!st->ss->test_and_add_drive_policies)
+		return MDADM_STATUS_SUCCESS;
+
+	sra = sysfs_read(array_fd, NULL, GET_DEVS);
+	if (!sra) {
+		pr_err("Cannot load sysfs for %s\n", fd2devnm(array_fd));
+		return MDADM_STATUS_ERROR;
+	}
+
+	ret = sysfs_test_and_add_drive_policies(st, pols, sra, verbose);
+
+	sysfs_free(sra);
+	return ret;
+}
+
 void pol_add(struct dev_policy **pol,
 		    char *name, char *val,
 		    char *metadata)
-- 
2.35.3

