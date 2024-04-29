Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 938CD548EC
	for <linux-raid@vger.kernel.org>; Mon, 29 Apr 2024 13:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714396079; cv=none; b=ZZfwIPjM8M5mpXEdEQb58TwXURXhTsZ62FgoUKViseAEpSaRbfVlgrGyZ04bTPkVIrbEEopUkqUsPCHgvtrmBDTmB+J6GQ2Pk/OoAu5H0ZooJ2bAL6w1ah2Nx1pCdjehJsvLXuzoy936l48hAwDJJBX8zcKeS5Zfon490UMwIqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714396079; c=relaxed/simple;
	bh=ezMtIIFWPQassMHx1B0WQSdCkUI5+yecwAWg3eqU2r8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SNYr+tvPAI0+aEwCsxxwrUjUxMyKhQpbiRRf3qGrHPWHEumJhf4LmXxM12HuGz0whuE/hp0VPWAbU8HSG5CWogWzkiGlQcJIMdXZ+jPYxagerkGRjhOEqEST2x8xacs/qCApUKKj6uZFOq4OHGXljlg+PT5x4q22LMlI76z9QAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=G4ejahlF; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="G4ejahlF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714396078; x=1745932078;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ezMtIIFWPQassMHx1B0WQSdCkUI5+yecwAWg3eqU2r8=;
  b=G4ejahlFp0esGw5uDu2GMRy1hbJyIJsxiZc1Wppxohjf8ASvD/dfqtEh
   zeGQI20TnYukNOFUBUjzX7VCHSeRDjRaTV7tCgNfnI+71oeGxw9mfCD7m
   YosJdeJ//rujs2C5s8mvhW00yXtSwDvYz76a3q/OX3XuGQKyCKw2FG/t+
   5rj9bHGFVvuU+/f9rG3JSAOP+ltIrEDzWeWet4nxMwtgIdqXsii6pyeaK
   8XZjDd7/wCmfB297W8pHwYRNQoPKiTOU+ySsu7gY1Xge2VB+gAyYkMW1b
   V5Q3OJZQWuNJXGxCO6IcFzSN5LYJcXMxRswGUKAltbndeXvxms6O3WX9S
   w==;
X-CSE-ConnectionGUID: V2//hVXkTQmanWy6xvqbxw==
X-CSE-MsgGUID: ayBApaAISIuMysD9SDtvFA==
X-IronPort-AV: E=McAfee;i="6600,9927,11057"; a="32554428"
X-IronPort-AV: E=Sophos;i="6.07,239,1708416000"; 
   d="scan'208";a="32554428"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2024 06:07:58 -0700
X-CSE-ConnectionGUID: kc4COm7tTEWtWNg5NaQOgg==
X-CSE-MsgGUID: qRLkvjttT7iGDvPAGbHyEw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,239,1708416000"; 
   d="scan'208";a="26609907"
Received: from patodeveloperka.igk.intel.com ([10.102.109.29])
  by orviesa007.jf.intel.com with ESMTP; 29 Apr 2024 06:07:57 -0700
From: Mateusz Kusiak <mateusz.kusiak@intel.com>
To: linux-raid@vger.kernel.org
Cc: mariusz.tkaczyk@linux.intel.com,
	jes@trained-monkey.org
Subject: [PATCH 5/8] imsm: bump minimal version
Date: Mon, 29 Apr 2024 15:07:17 +0200
Message-Id: <20240429130720.260452-6-mateusz.kusiak@intel.com>
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

IMSM version 1.3 (called ATTRIBS) brought attributes used to define array
properties which require support in driver. The goal of this change was
to avoid changing version when adding new features.

For some reasons migration has never been completed and currently (after
10 years of implementing) IMSM can use older versions.

It is right time to finally switch it. There is no point in using old
versions, use 1.3.00 as minimal one.

Define JD_VERSION used by Windows driver.

Signed-off-by: Mateusz Kusiak <mateusz.kusiak@intel.com>
Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 super-intel.c | 87 ++++++++++++++++++++++-----------------------------
 1 file changed, 38 insertions(+), 49 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index da17265d7f12..4b168add4346 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -32,14 +32,19 @@
 /* MPB == Metadata Parameter Block */
 #define MPB_SIGNATURE "Intel Raid ISM Cfg Sig. "
 #define MPB_SIG_LEN (strlen(MPB_SIGNATURE))
-#define MPB_VERSION_RAID0 "1.0.00"
-#define MPB_VERSION_RAID1 "1.1.00"
-#define MPB_VERSION_MANY_VOLUMES_PER_ARRAY "1.2.00"
-#define MPB_VERSION_3OR4_DISK_ARRAY "1.2.01"
-#define MPB_VERSION_RAID5 "1.2.02"
-#define MPB_VERSION_5OR6_DISK_ARRAY "1.2.04"
-#define MPB_VERSION_CNG "1.2.06"
+
+/* Legacy IMSM versions:
+ * MPB_VERSION_RAID0 1.0.00
+ * MPB_VERSION_RAID1 1.1.00
+ * MPB_VERSION_MANY_VOLUMES_PER_ARRAY 1.2.00
+ * MPB_VERSION_3OR4_DISK_ARRAY 1.2.01
+ * MPB_VERSION_RAID5 1.2.02
+ * MPB_VERSION_5OR6_DISK_ARRAY 1.2.04
+ * MPB_VERSION_CNG 1.2.06
+ */
+
 #define MPB_VERSION_ATTRIBS "1.3.00"
+#define MPB_VERSION_ATTRIBS_JD "2.0.00"
 #define MAX_SIGNATURE_LENGTH  32
 #define MAX_RAID_SERIAL_LEN   16
 
@@ -5512,51 +5517,46 @@ static unsigned long long info_to_blocks_per_member(mdu_array_info_t *info,
 		return (size * 2) & ~(info_to_blocks_per_strip(info) - 1);
 }
 
+static void imsm_write_signature(struct imsm_super *mpb)
+{
+	/* It is safer to eventually truncate version rather than left it not NULL ended */
+	snprintf((char *) mpb->sig, MAX_SIGNATURE_LENGTH, MPB_SIGNATURE MPB_VERSION_ATTRIBS);
+}
+
 static void imsm_update_version_info(struct intel_super *super)
 {
 	/* update the version and attributes */
 	struct imsm_super *mpb = super->anchor;
-	char *version;
 	struct imsm_dev *dev;
 	struct imsm_map *map;
 	int i;
 
+	mpb->attributes |= MPB_ATTRIB_CHECKSUM_VERIFY;
+
 	for (i = 0; i < mpb->num_raid_devs; i++) {
 		dev = get_imsm_dev(super, i);
 		map = get_imsm_map(dev, MAP_0);
+
 		if (__le32_to_cpu(dev->size_high) > 0)
 			mpb->attributes |= MPB_ATTRIB_2TB;
 
-		/* FIXME detect when an array spans a port multiplier */
-		#if 0
-		mpb->attributes |= MPB_ATTRIB_PM;
-		#endif
-
-		if (mpb->num_raid_devs > 1 ||
-		    mpb->attributes != MPB_ATTRIB_CHECKSUM_VERIFY) {
-			version = MPB_VERSION_ATTRIBS;
-			switch (get_imsm_raid_level(map)) {
-			case 0: mpb->attributes |= MPB_ATTRIB_RAID0; break;
-			case 1: mpb->attributes |= MPB_ATTRIB_RAID1; break;
-			case 10: mpb->attributes |= MPB_ATTRIB_RAID10; break;
-			case 5: mpb->attributes |= MPB_ATTRIB_RAID5; break;
-			}
-		} else {
-			if (map->num_members >= 5)
-				version = MPB_VERSION_5OR6_DISK_ARRAY;
-			else if (dev->status == DEV_CLONE_N_GO)
-				version = MPB_VERSION_CNG;
-			else if (get_imsm_raid_level(map) == 5)
-				version = MPB_VERSION_RAID5;
-			else if (map->num_members >= 3)
-				version = MPB_VERSION_3OR4_DISK_ARRAY;
-			else if (get_imsm_raid_level(map) == 1)
-				version = MPB_VERSION_RAID1;
-			else
-				version = MPB_VERSION_RAID0;
+		switch (get_imsm_raid_level(map)) {
+		case IMSM_T_RAID0:
+			mpb->attributes |= MPB_ATTRIB_RAID0;
+			break;
+		case IMSM_T_RAID1:
+			mpb->attributes |= MPB_ATTRIB_RAID1;
+			break;
+		case IMSM_T_RAID5:
+			mpb->attributes |= MPB_ATTRIB_RAID5;
+			break;
+		case IMSM_T_RAID10:
+			mpb->attributes |= MPB_ATTRIB_RAID10;
+			break;
 		}
-		strcpy(((char *) mpb->sig) + strlen(MPB_SIGNATURE), version);
 	}
+
+	imsm_write_signature(mpb);
 }
 
 /**
@@ -5785,7 +5785,6 @@ static int init_super_imsm(struct supertype *st, mdu_array_info_t *info,
 	struct intel_super *super;
 	struct imsm_super *mpb;
 	size_t mpb_size;
-	char *version;
 
 	if (data_offset != INVALID_SECTORS) {
 		pr_err("data-offset not supported by imsm\n");
@@ -5828,13 +5827,7 @@ static int init_super_imsm(struct supertype *st, mdu_array_info_t *info,
 		return 0;
 	}
 
-	mpb->attributes = MPB_ATTRIB_CHECKSUM_VERIFY;
-
-	version = (char *) mpb->sig;
-	strcpy(version, MPB_SIGNATURE);
-	version += strlen(MPB_SIGNATURE);
-	strcpy(version, MPB_VERSION_RAID0);
-
+	imsm_update_version_info(super);
 	return 1;
 }
 
@@ -6208,7 +6201,6 @@ static union {
 
 static int write_super_imsm_spare(struct intel_super *super, struct dl *d)
 {
-	struct imsm_super *mpb = super->anchor;
 	struct imsm_super *spare = &spare_record.anchor;
 	__u32 sum;
 
@@ -6217,14 +6209,11 @@ static int write_super_imsm_spare(struct intel_super *super, struct dl *d)
 
 	spare->mpb_size = __cpu_to_le32(sizeof(struct imsm_super));
 	spare->generation_num = __cpu_to_le32(1UL);
-	spare->attributes = MPB_ATTRIB_CHECKSUM_VERIFY;
 	spare->num_disks = 1;
 	spare->num_raid_devs = 0;
-	spare->cache_size = mpb->cache_size;
 	spare->pwr_cycle_count = __cpu_to_le32(1);
 
-	snprintf((char *) spare->sig, MAX_SIGNATURE_LENGTH,
-		 MPB_SIGNATURE MPB_VERSION_RAID0);
+	imsm_write_signature(spare);
 
 	spare->disk[0] = d->disk;
 	if (__le32_to_cpu(d->disk.total_blocks_hi) > 0)
-- 
2.39.2

