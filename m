Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D1625467B
	for <linux-raid@vger.kernel.org>; Mon, 29 Apr 2024 13:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714396084; cv=none; b=ku3zSzu7SbD7xN5luJ51NyjwBTURy7KMxQ7Gf16DSOawjCqyPZmkduEewUriArhttCHVxDVccwihseDip4W2esthEn56ErOq1wFDVeGJgzBTnW20+qicDHrZ1By/HBRCXg2Gpuu9i+y5p4ISNht+Yw4r4W9daApul95mcQ9m0YU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714396084; c=relaxed/simple;
	bh=GrdLrPyhXb6e2B9fs8caa+HuiV21YYX1Qt3CPl8JawU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=likHMs6gTToPQRDdJT8ZjBWPiVtxudZ4Jv5zYLIoDX0k+3lkJSUP43yhgQ8SR29FsdyhPRe7s0+bVaDAzajhIF9nAhS8GfgV9NEBTVer8YmTVrbf+i/ilvcPeQz6GKzlOA/2Cr7RFOhAsQpFvj5+pj5cZ7vatzxk7jpaylxzXDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LdDDfmIo; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LdDDfmIo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714396083; x=1745932083;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GrdLrPyhXb6e2B9fs8caa+HuiV21YYX1Qt3CPl8JawU=;
  b=LdDDfmIoEw5Hc+VQV1xgO461RMwbU1lbo43aTbFIiKvzpzj+1uEw9k9W
   pL27ezfRVK+pUOAa21OD0sWxm0Js31gXuJkX0EDChVOKHOjz0jrxD+hps
   yP69MLTXqx/BqBO4vwjoulRR8PU3sZVZAEQx/P6LDSajkLZ6AHum+kVrZ
   KvowPmvhCYOj6LvYo1hQuyzN5K/0pBA0Czq+qgUMnfzNt3G5/QmUk7dnY
   SFC9WdMKOBZebx5vFaGqmO+/tf3Wit/90gsiTqGfayxfGlVs/FdlzmGjJ
   fwP85uQDvpuNc/WbuWSAU/QDNGCraDfB80x/tCCvblCnDxWbc1GCHW3xE
   w==;
X-CSE-ConnectionGUID: U9jywQBZTXe982ucsnYrIQ==
X-CSE-MsgGUID: 6Jx14mDsTwKiN89Y0VfbZA==
X-IronPort-AV: E=McAfee;i="6600,9927,11057"; a="32554465"
X-IronPort-AV: E=Sophos;i="6.07,239,1708416000"; 
   d="scan'208";a="32554465"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2024 06:08:02 -0700
X-CSE-ConnectionGUID: FKSrE9tKSnSMYsFjMt0hbQ==
X-CSE-MsgGUID: ukDRFwvjSquI7+XqWFH9Nw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,239,1708416000"; 
   d="scan'208";a="26609911"
Received: from patodeveloperka.igk.intel.com ([10.102.109.29])
  by orviesa007.jf.intel.com with ESMTP; 29 Apr 2024 06:08:01 -0700
From: Mateusz Kusiak <mateusz.kusiak@intel.com>
To: linux-raid@vger.kernel.org
Cc: mariusz.tkaczyk@linux.intel.com,
	jes@trained-monkey.org
Subject: [PATCH 6/8] imsm: define RAID_10 attribute
Date: Mon, 29 Apr 2024 15:07:18 +0200
Message-Id: <20240429130720.260452-7-mateusz.kusiak@intel.com>
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

Add MPB_ATTRIB_RAID10_EXT attribute to support RAID 10
with more than 4 drives.

Allow more than 4 drives in imsm_orom_support_raid_disks_raid10().

This is one of last patches for introducing R10D4+ to imsm.
Only small adjustments in reshape behaviours are needed.

Signed-off-by: Mateusz Kusiak <mateusz.kusiak@intel.com>
Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 platform-intel.c | 3 ++-
 super-intel.c    | 5 +++++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/platform-intel.c b/platform-intel.c
index 40e8fb82da30..15a9fa5ac160 100644
--- a/platform-intel.c
+++ b/platform-intel.c
@@ -76,7 +76,8 @@ static bool imsm_orom_support_raid_disks_count_raid5(const int raid_disks)
 
 static bool imsm_orom_support_raid_disks_count_raid10(const int raid_disks)
 {
-	if (raid_disks == 4)
+	/* raid_disks count must be higher than 4 and even */
+	if (raid_disks >= 4 && (raid_disks & 1) == 0)
 		return true;
 	return false;
 }
diff --git a/super-intel.c b/super-intel.c
index 4b168add4346..2d30931672cd 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -62,6 +62,8 @@
 #define MPB_ATTRIB_RAIDCNG		__cpu_to_le32(0x00000020)
 /* supports expanded stripe sizes of  256K, 512K and 1MB */
 #define MPB_ATTRIB_EXP_STRIPE_SIZE	__cpu_to_le32(0x00000040)
+/* supports RAID10 with more than 4 drives */
+#define MPB_ATTRIB_RAID10_EXT		__cpu_to_le32(0x00000080)
 
 /* The OROM Support RST Caching of Volumes */
 #define MPB_ATTRIB_NVM			__cpu_to_le32(0x02000000)
@@ -89,6 +91,7 @@
 					MPB_ATTRIB_RAID10          | \
 					MPB_ATTRIB_RAID5           | \
 					MPB_ATTRIB_EXP_STRIPE_SIZE | \
+					MPB_ATTRIB_RAID10_EXT      | \
 					MPB_ATTRIB_BBM)
 
 /* Define attributes that are unused but not harmful */
@@ -5552,6 +5555,8 @@ static void imsm_update_version_info(struct intel_super *super)
 			break;
 		case IMSM_T_RAID10:
 			mpb->attributes |= MPB_ATTRIB_RAID10;
+			if (map->num_members > 4)
+				mpb->attributes |= MPB_ATTRIB_RAID10_EXT;
 			break;
 		}
 	}
-- 
2.39.2

