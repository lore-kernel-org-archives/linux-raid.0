Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 337403C482
	for <linux-raid@vger.kernel.org>; Mon, 29 Apr 2024 13:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714396076; cv=none; b=f7DExAtQvw+Y93SGTAKPxANfeFlOCInDugqHDGqzWP+RfiO9Jo6A6n2hcDfqiJWfhUtd7Kc2dg/i8OgQ6BDnQD/2AoMh5J6qtItO5DmVzeqilT/5NHRlPNwV6aC5AHP95kYbrsRMITBa/3nD7VZ09rH//IB3aR9cRriG7OctqWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714396076; c=relaxed/simple;
	bh=iXx8x5Rk71fmpQTydG8wcNUg7UpA6FdF3O9CIGkszTU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SmXyk7Agl3YUp5Mt0BlhcX8VH2B96JF27veaVOiweunBS61dX03Q/M4pDcxOcK8C/ee+mqF26703I9fXVIzzXJbJ9W/Xsa8XNEUs+NacLpIfIvd9fucgw6SLbGnzXHm4UweDeVfXxAfMM5B2qWFtSVEvGdSPZEQi8VSLtdejo0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZKP9TR2w; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZKP9TR2w"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714396074; x=1745932074;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=iXx8x5Rk71fmpQTydG8wcNUg7UpA6FdF3O9CIGkszTU=;
  b=ZKP9TR2wQYG12kzmkBkYrHeBf8sebp8rnHakU2YCwnkcKol7rYA4pzqc
   9Li0ZBStuXRmHhfbCzoQdIEtG/zi7skehmFPAoczMTXQKxeOE24IOonVD
   d4szDgYXp7AgNOZLMJvN8vB5AyKVTzzNeILBVviVZXqW7H6zUQ1c4CaLJ
   sdjmKENU2FO4Y0+a7ZHokV6l1a31G0IuSpJ/oU9G0wRtdWAlydBYxkIRg
   uM+x6elLNuccICZb6R71UAxcTsm9QuX+/xiNbNGCoyVeSCCf0u3SJAXYy
   gRif5EGC6Hzqekm9D8pDf5vubOJyJ0a8kSEkR0FKOodmxFcJfJw3XhQoP
   Q==;
X-CSE-ConnectionGUID: JYwNWQ5qTzC6/D89KyEuzQ==
X-CSE-MsgGUID: /zB20Ep+TlCmKCRqQyv++w==
X-IronPort-AV: E=McAfee;i="6600,9927,11057"; a="32554416"
X-IronPort-AV: E=Sophos;i="6.07,239,1708416000"; 
   d="scan'208";a="32554416"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2024 06:07:54 -0700
X-CSE-ConnectionGUID: xxa0kk0uRQ6gFy3VZvEK0g==
X-CSE-MsgGUID: oOwLENhBQ/KH9W26ngsmZQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,239,1708416000"; 
   d="scan'208";a="26609896"
Received: from patodeveloperka.igk.intel.com ([10.102.109.29])
  by orviesa007.jf.intel.com with ESMTP; 29 Apr 2024 06:07:53 -0700
From: Mateusz Kusiak <mateusz.kusiak@intel.com>
To: linux-raid@vger.kernel.org
Cc: mariusz.tkaczyk@linux.intel.com,
	jes@trained-monkey.org
Subject: [PATCH 4/8] imsm: refactor RAID level handling
Date: Mon, 29 Apr 2024 15:07:16 +0200
Message-Id: <20240429130720.260452-5-mateusz.kusiak@intel.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240429130720.260452-1-mateusz.kusiak@intel.com>
References: <20240429130720.260452-1-mateusz.kusiak@intel.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add imsm_level_ops struct for better handling and unifying raid level
support. Add helper methods and move "orom_has_raid[...]" methods from
header to source file.

RAID 1e is not supported under Linux, remove RAID 1e associated code.

Refactor imsm_analyze_change() and is_raid_level_supported().
Remove hardcoded check for 4 drives and make devNumChange a multiplier
for RAID 10.

Refactor printing supported raid levels.

Signed-off-by: Mateusz Kusiak <mateusz.kusiak@intel.com>
Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 platform-intel.c |  57 ++++++++++++++++++++++++
 platform-intel.h |  32 ++++++--------
 super-intel.c    | 111 ++++++++++++++++++++++++++++-------------------
 3 files changed, 138 insertions(+), 62 deletions(-)

diff --git a/platform-intel.c b/platform-intel.c
index ac282bc5b09b..40e8fb82da30 100644
--- a/platform-intel.c
+++ b/platform-intel.c
@@ -32,6 +32,63 @@
 
 #define NVME_SUBSYS_PATH "/sys/devices/virtual/nvme-subsystem/"
 
+static bool imsm_orom_has_raid0(const struct imsm_orom *orom)
+{
+	return imsm_rlc_has_bit(orom, IMSM_OROM_RLC_RAID0);
+}
+
+static bool imsm_orom_has_raid1(const struct imsm_orom *orom)
+{
+	return imsm_rlc_has_bit(orom, IMSM_OROM_RLC_RAID1);
+}
+
+static bool imsm_orom_has_raid10(const struct imsm_orom *orom)
+{
+	return imsm_rlc_has_bit(orom, IMSM_OROM_RLC_RAID10);
+}
+
+static bool imsm_orom_has_raid5(const struct imsm_orom *orom)
+{
+	return imsm_rlc_has_bit(orom, IMSM_OROM_RLC_RAID5);
+}
+
+/* IMSM platforms do not define how many disks are allowed for each level,
+ * but there are some global limitations we need to follow.
+ */
+static bool imsm_orom_support_raid_disks_count_raid0(const int raid_disks)
+{
+	return true;
+}
+
+static bool imsm_orom_support_raid_disks_count_raid1(const int raid_disks)
+{
+	if (raid_disks == 2)
+		return true;
+	return false;
+}
+
+static bool imsm_orom_support_raid_disks_count_raid5(const int raid_disks)
+{
+	if (raid_disks > 2)
+		return true;
+	return false;
+}
+
+static bool imsm_orom_support_raid_disks_count_raid10(const int raid_disks)
+{
+	if (raid_disks == 4)
+		return true;
+	return false;
+}
+
+struct imsm_level_ops imsm_level_ops[] = {
+		{0, imsm_orom_has_raid0, imsm_orom_support_raid_disks_count_raid0, "raid0"},
+		{1, imsm_orom_has_raid1, imsm_orom_support_raid_disks_count_raid1, "raid1"},
+		{5, imsm_orom_has_raid5, imsm_orom_support_raid_disks_count_raid5, "raid5"},
+		{10, imsm_orom_has_raid10, imsm_orom_support_raid_disks_count_raid10, "raid10"},
+		{-1, NULL, NULL, NULL}
+};
+
 static int devpath_to_ll(const char *dev_path, const char *entry,
 			 unsigned long long *val);
 
diff --git a/platform-intel.h b/platform-intel.h
index 3c2bc595f7b5..dcc5aaa74f21 100644
--- a/platform-intel.h
+++ b/platform-intel.h
@@ -109,25 +109,21 @@ struct imsm_orom {
 	#define IMSM_OROM_CAPABILITIES_TPV (1 << 10)
 } __attribute__((packed));
 
-static inline int imsm_orom_has_raid0(const struct imsm_orom *orom)
-{
-	return !!(orom->rlc & IMSM_OROM_RLC_RAID0);
-}
-static inline int imsm_orom_has_raid1(const struct imsm_orom *orom)
-{
-	return !!(orom->rlc & IMSM_OROM_RLC_RAID1);
-}
-static inline int imsm_orom_has_raid1e(const struct imsm_orom *orom)
-{
-	return !!(orom->rlc & IMSM_OROM_RLC_RAID1E);
-}
-static inline int imsm_orom_has_raid10(const struct imsm_orom *orom)
-{
-	return !!(orom->rlc & IMSM_OROM_RLC_RAID10);
-}
-static inline int imsm_orom_has_raid5(const struct imsm_orom *orom)
+/* IMSM metadata requirements for each level */
+struct imsm_level_ops {
+	int level;
+	bool (*is_level_supported)(const struct imsm_orom *);
+	bool (*is_raiddisks_count_supported)(const int);
+	char *name;
+};
+
+extern struct imsm_level_ops imsm_level_ops[];
+
+static inline bool imsm_rlc_has_bit(const struct imsm_orom *orom, const unsigned short bit)
 {
-	return !!(orom->rlc & IMSM_OROM_RLC_RAID5);
+	if (orom->rlc & bit)
+		return true;
+	return false;
 }
 
 /**
diff --git a/super-intel.c b/super-intel.c
index a7efc8df0b47..da17265d7f12 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -2681,6 +2681,15 @@ static int ahci_get_port_count(const char *hba_path, int *port_count)
 	return host_base;
 }
 
+static void print_imsm_level_capability(const struct imsm_orom *orom)
+{
+	int idx;
+
+	for (idx = 0; imsm_level_ops[idx].name; idx++)
+		if (imsm_level_ops[idx].is_level_supported(orom))
+			printf("%s ", imsm_level_ops[idx].name);
+}
+
 static void print_imsm_capability(const struct imsm_orom *orom)
 {
 	printf("       Platform : Intel(R) ");
@@ -2699,12 +2708,11 @@ static void print_imsm_capability(const struct imsm_orom *orom)
 			printf("        Version : %d.%d.%d.%d\n", orom->major_ver,
 			       orom->minor_ver, orom->hotfix_ver, orom->build);
 	}
-	printf("    RAID Levels :%s%s%s%s%s\n",
-	       imsm_orom_has_raid0(orom) ? " raid0" : "",
-	       imsm_orom_has_raid1(orom) ? " raid1" : "",
-	       imsm_orom_has_raid1e(orom) ? " raid1e" : "",
-	       imsm_orom_has_raid10(orom) ? " raid10" : "",
-	       imsm_orom_has_raid5(orom) ? " raid5" : "");
+
+	printf("    RAID Levels : ");
+	print_imsm_level_capability(orom);
+	printf("\n");
+
 	printf("    Chunk Sizes :%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s\n",
 	       imsm_orom_has_chunk(orom, 2) ? " 2k" : "",
 	       imsm_orom_has_chunk(orom, 4) ? " 4k" : "",
@@ -2739,12 +2747,11 @@ static void print_imsm_capability_export(const struct imsm_orom *orom)
 	if (orom->major_ver || orom->minor_ver || orom->hotfix_ver || orom->build)
 		printf("IMSM_VERSION=%d.%d.%d.%d\n", orom->major_ver, orom->minor_ver,
 				orom->hotfix_ver, orom->build);
-	printf("IMSM_SUPPORTED_RAID_LEVELS=%s%s%s%s%s\n",
-			imsm_orom_has_raid0(orom) ? "raid0 " : "",
-			imsm_orom_has_raid1(orom) ? "raid1 " : "",
-			imsm_orom_has_raid1e(orom) ? "raid1e " : "",
-			imsm_orom_has_raid5(orom) ? "raid10 " : "",
-			imsm_orom_has_raid10(orom) ? "raid5 " : "");
+
+	printf("IMSM_SUPPORTED_RAID_LEVELS=");
+	print_imsm_level_capability(orom);
+	printf("\n");
+
 	printf("IMSM_SUPPORTED_CHUNK_SIZES=%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s\n",
 			imsm_orom_has_chunk(orom, 2) ? "2k " : "",
 			imsm_orom_has_chunk(orom, 4) ? "4k " : "",
@@ -6992,26 +6999,41 @@ static unsigned long long merge_extents(struct intel_super *super, const bool ex
 	return free_size - reservation_size;
 }
 
-static int is_raid_level_supported(const struct imsm_orom *orom, int level, int raiddisks)
+/**
+ * is_raid_level_supported() - check if this count of drives and level is supported by platform.
+ * @orom: hardware properties, could be NULL.
+ * @level: requested raid level.
+ * @raiddisks: requested disk count.
+ *
+ * IMSM UEFI/OROM does not provide information about supported count of raid disks
+ * for particular level. That is why it is hardcoded.
+ * It is recommended to not allow of usage other levels than supported,
+ * IMSM code is not tested against different level implementations.
+ *
+ * Return: true if supported, false otherwise.
+ */
+static bool is_raid_level_supported(const struct imsm_orom *orom, int level, int raiddisks)
 {
-	if (level < 0 || level == 6 || level == 4)
-		return 0;
+	int idx;
 
-	/* if we have an orom prevent invalid raid levels */
-	if (orom)
-		switch (level) {
-		case 0: return imsm_orom_has_raid0(orom);
-		case 1:
-			if (raiddisks > 2)
-				return imsm_orom_has_raid1e(orom);
-			return imsm_orom_has_raid1(orom) && raiddisks == 2;
-		case 10: return imsm_orom_has_raid10(orom) && raiddisks == 4;
-		case 5: return imsm_orom_has_raid5(orom) && raiddisks > 2;
-		}
-	else
-		return 1; /* not on an Intel RAID platform so anything goes */
+	for (idx = 0; imsm_level_ops[idx].name; idx++) {
+		if (imsm_level_ops[idx].level == level)
+			break;
+	}
 
-	return 0;
+	if (!imsm_level_ops[idx].name)
+		return false;
+
+	if (!imsm_level_ops[idx].is_raiddisks_count_supported(raiddisks))
+		return false;
+
+	if (!orom)
+		return true;
+
+	if (imsm_level_ops[idx].is_level_supported(orom))
+		return true;
+
+	return false;
 }
 
 static int
@@ -11962,18 +11984,17 @@ enum imsm_reshape_type imsm_analyze_change(struct supertype *st,
 	int change = -1;
 	int check_devs = 0;
 	int chunk;
-	/* number of added/removed disks in operation result */
-	int devNumChange = 0;
 	/* imsm compatible layout value for array geometry verification */
 	int imsm_layout = -1;
+	int raid_disks = geo->raid_disks;
 	imsm_status_t rv;
 
 	getinfo_super_imsm_volume(st, &info, NULL);
-	if (geo->level != info.array.level && geo->level >= 0 &&
+	if (geo->level != info.array.level && geo->level >= IMSM_T_RAID0 &&
 	    geo->level != UnSet) {
 		switch (info.array.level) {
-		case 0:
-			if (geo->level == 5) {
+		case IMSM_T_RAID0:
+			if (geo->level == IMSM_T_RAID5) {
 				change = CH_MIGRATION;
 				if (geo->layout != ALGORITHM_LEFT_ASYMMETRIC) {
 					pr_err("Error. Requested Layout not supported (left-asymmetric layout is supported only)!\n");
@@ -11982,20 +12003,20 @@ enum imsm_reshape_type imsm_analyze_change(struct supertype *st,
 				}
 				imsm_layout =  geo->layout;
 				check_devs = 1;
-				devNumChange = 1; /* parity disk added */
-			} else if (geo->level == 10) {
+				raid_disks += 1; /* parity disk added */
+			} else if (geo->level == IMSM_T_RAID10) {
 				change = CH_TAKEOVER;
 				check_devs = 1;
-				devNumChange = 2; /* two mirrors added */
+				raid_disks *= 2; /* mirrors added */
 				imsm_layout = 0x102; /* imsm supported layout */
 			}
 			break;
-		case 1:
-		case 10:
+		case IMSM_T_RAID1:
+		case IMSM_T_RAID10:
 			if (geo->level == 0) {
 				change = CH_TAKEOVER;
 				check_devs = 1;
-				devNumChange = -(geo->raid_disks/2);
+				raid_disks /= 2;
 				imsm_layout = 0; /* imsm raid0 layout */
 			}
 			break;
@@ -12011,10 +12032,10 @@ enum imsm_reshape_type imsm_analyze_change(struct supertype *st,
 	if (geo->layout != info.array.layout &&
 	    (geo->layout != UnSet && geo->layout != -1)) {
 		change = CH_MIGRATION;
-		if (info.array.layout == 0 && info.array.level == 5 &&
+		if (info.array.layout == 0 && info.array.level == IMSM_T_RAID5 &&
 		    geo->layout == 5) {
 			/* reshape 5 -> 4 */
-		} else if (info.array.layout == 5 && info.array.level == 5 &&
+		} else if (info.array.layout == 5 && info.array.level == IMSM_T_RAID5 &&
 			   geo->layout == 0) {
 			/* reshape 4 -> 5 */
 			geo->layout = 0;
@@ -12033,7 +12054,7 @@ enum imsm_reshape_type imsm_analyze_change(struct supertype *st,
 
 	if (geo->chunksize > 0 && geo->chunksize != UnSet &&
 	    geo->chunksize != info.array.chunk_size) {
-		if (info.array.level == 10) {
+		if (info.array.level == IMSM_T_RAID10) {
 			pr_err("Error. Chunk size change for RAID 10 is not supported.\n");
 			change = -1;
 			goto analyse_change_exit;
@@ -12058,14 +12079,16 @@ enum imsm_reshape_type imsm_analyze_change(struct supertype *st,
 		rv = imsm_analyze_expand(st, geo, &info, direction);
 		if (rv != IMSM_STATUS_OK)
 			goto analyse_change_exit;
+		raid_disks = geo->raid_disks;
 		change = CH_ARRAY_SIZE;
 	}
 
 	chunk = geo->chunksize / 1024;
+
 	if (!validate_geometry_imsm(st,
 				    geo->level,
 				    imsm_layout,
-				    geo->raid_disks + devNumChange,
+				    raid_disks,
 				    &chunk,
 				    geo->size, INVALID_SECTORS,
 				    0, 0, info.consistency_policy, 1))
-- 
2.39.2

