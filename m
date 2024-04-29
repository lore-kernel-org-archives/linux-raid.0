Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E6D16A8DC
	for <linux-raid@vger.kernel.org>; Mon, 29 Apr 2024 13:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714396091; cv=none; b=sxCjaT1H1ARuH+QCveT+erLwlaztEtD+Hk/Vuvwcyt36STtIQJCy5BA12zNWfhI1lSGENJuGxYvM40mQVc+35kOhZPt3zxMLX38ZToqX3jVmS1zMsn/TmfMxS2u/eLwtetd2vYT+DSvxh3CZcZjb1rm17X+9m5B0zh/4OKdGX8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714396091; c=relaxed/simple;
	bh=K/MK/k1IcykeSkCEUG5ZdNi/JbXzv5USq22qwOTE0g0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ibhIrliMHBcDEvMTXYL14GPzqFFCzTrcRUtN+F0OA0iFmjKQ0Sy2Xf33CkCsbNA1YRXTdLkKmOknAWJG+iDt7YppJ4RQLY5kQY4VWTXkrOT0463UkLYKS6RHKJ5GU2a38fJkJ7XvSTMi5cG8ScHbKLR+ENNvcX8KkJweUyUpGCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kOGgGelt; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kOGgGelt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714396090; x=1745932090;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=K/MK/k1IcykeSkCEUG5ZdNi/JbXzv5USq22qwOTE0g0=;
  b=kOGgGeltXZaTDnbTaqo6D4vyvL5dZBkgkjR29u3Mh7tLC91rJzN/YsTq
   brx6l5bup4M542C0HnDddECZfzs6gNC9fIs7WnlQe8B9zG1i3nU1KYlqr
   CfmdaE/fAwkCjX+OaFnY/8T7vrBcZiF/Yi9K3jV/jchSmIfeU360mxgU1
   tafHWzJhwrG7QKdxO3duze3ySdd/PGdp9DIZjLte6OSG9b0J8jPzwKRDh
   AXKHucwx/DcUs3W06z9fx/yuaB2pSnRqWP341PWJdE6JE6mmJS3TlDzcq
   8ZlA93gMGVyKLDGTjzAQPB2ZqI5g1JewyGHdLemFULNccWz92xvsdVZqR
   Q==;
X-CSE-ConnectionGUID: Z8ZcNsWEQHO0PvF3hpHZ/w==
X-CSE-MsgGUID: 33t9XXMgSMG8hO3aNVlDDA==
X-IronPort-AV: E=McAfee;i="6600,9927,11057"; a="32554514"
X-IronPort-AV: E=Sophos;i="6.07,239,1708416000"; 
   d="scan'208";a="32554514"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2024 06:08:06 -0700
X-CSE-ConnectionGUID: nzwB8tDwQ9mtiDQ2F4pSFw==
X-CSE-MsgGUID: mZKf6gvWRwuul3sIqTp0Uw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,239,1708416000"; 
   d="scan'208";a="26609939"
Received: from patodeveloperka.igk.intel.com ([10.102.109.29])
  by orviesa007.jf.intel.com with ESMTP; 29 Apr 2024 06:08:05 -0700
From: Mateusz Kusiak <mateusz.kusiak@intel.com>
To: linux-raid@vger.kernel.org
Cc: mariusz.tkaczyk@linux.intel.com,
	jes@trained-monkey.org
Subject: [PATCH 7/8] imsm: simplify imsm_check_attributes()
Date: Mon, 29 Apr 2024 15:07:19 +0200
Message-Id: <20240429130720.260452-8-mateusz.kusiak@intel.com>
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

imsm_check_attributes() is too complex for that it really does.

Remove repeating code and simplify the function.
Fix function calls.

Signed-off-by: Mateusz Kusiak <mateusz.kusiak@intel.com>
Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 super-intel.c | 106 ++++++++------------------------------------------
 1 file changed, 16 insertions(+), 90 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 2d30931672cd..d60915e812d4 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -2135,91 +2135,18 @@ void convert_from_4k(struct intel_super *super)
 	mpb->check_sum = __gen_imsm_checksum(mpb);
 }
 
-/*******************************************************************************
- * function: imsm_check_attributes
- * Description: Function checks if features represented by attributes flags
- *		are supported by mdadm.
- * Parameters:
- *		attributes - Attributes read from metadata
- * Returns:
- *		0 - passed attributes contains unsupported features flags
- *		1 - all features are supported
- ******************************************************************************/
-static int imsm_check_attributes(__u32 attributes)
+/**
+ * imsm_check_attributes() - Check if features represented by attributes flags are supported.
+ *
+ * @attributes: attributes read from metadata.
+ * Returns: true if all features are supported, false otherwise.
+ */
+static bool imsm_check_attributes(__u32 attributes)
 {
-	int ret_val = 1;
-	__u32 not_supported = MPB_ATTRIB_SUPPORTED^0xffffffff;
-
-	not_supported &= ~MPB_ATTRIB_IGNORED;
-
-	not_supported &= attributes;
-	if (not_supported) {
-		pr_err("(IMSM): Unsupported attributes : %x\n",
-			(unsigned)__le32_to_cpu(not_supported));
-		if (not_supported & MPB_ATTRIB_CHECKSUM_VERIFY) {
-			dprintf("\t\tMPB_ATTRIB_CHECKSUM_VERIFY \n");
-			not_supported ^= MPB_ATTRIB_CHECKSUM_VERIFY;
-		}
-		if (not_supported & MPB_ATTRIB_2TB) {
-			dprintf("\t\tMPB_ATTRIB_2TB\n");
-			not_supported ^= MPB_ATTRIB_2TB;
-		}
-		if (not_supported & MPB_ATTRIB_RAID0) {
-			dprintf("\t\tMPB_ATTRIB_RAID0\n");
-			not_supported ^= MPB_ATTRIB_RAID0;
-		}
-		if (not_supported & MPB_ATTRIB_RAID1) {
-			dprintf("\t\tMPB_ATTRIB_RAID1\n");
-			not_supported ^= MPB_ATTRIB_RAID1;
-		}
-		if (not_supported & MPB_ATTRIB_RAID10) {
-			dprintf("\t\tMPB_ATTRIB_RAID10\n");
-			not_supported ^= MPB_ATTRIB_RAID10;
-		}
-		if (not_supported & MPB_ATTRIB_RAID1E) {
-			dprintf("\t\tMPB_ATTRIB_RAID1E\n");
-			not_supported ^= MPB_ATTRIB_RAID1E;
-		}
-		if (not_supported & MPB_ATTRIB_RAID5) {
-		dprintf("\t\tMPB_ATTRIB_RAID5\n");
-			not_supported ^= MPB_ATTRIB_RAID5;
-		}
-		if (not_supported & MPB_ATTRIB_RAIDCNG) {
-			dprintf("\t\tMPB_ATTRIB_RAIDCNG\n");
-			not_supported ^= MPB_ATTRIB_RAIDCNG;
-		}
-		if (not_supported & MPB_ATTRIB_BBM) {
-			dprintf("\t\tMPB_ATTRIB_BBM\n");
-		not_supported ^= MPB_ATTRIB_BBM;
-		}
-		if (not_supported & MPB_ATTRIB_CHECKSUM_VERIFY) {
-			dprintf("\t\tMPB_ATTRIB_CHECKSUM_VERIFY (== MPB_ATTRIB_LEGACY)\n");
-			not_supported ^= MPB_ATTRIB_CHECKSUM_VERIFY;
-		}
-		if (not_supported & MPB_ATTRIB_EXP_STRIPE_SIZE) {
-			dprintf("\t\tMPB_ATTRIB_EXP_STRIP_SIZE\n");
-			not_supported ^= MPB_ATTRIB_EXP_STRIPE_SIZE;
-		}
-		if (not_supported & MPB_ATTRIB_2TB_DISK) {
-			dprintf("\t\tMPB_ATTRIB_2TB_DISK\n");
-			not_supported ^= MPB_ATTRIB_2TB_DISK;
-		}
-		if (not_supported & MPB_ATTRIB_NEVER_USE2) {
-			dprintf("\t\tMPB_ATTRIB_NEVER_USE2\n");
-			not_supported ^= MPB_ATTRIB_NEVER_USE2;
-		}
-		if (not_supported & MPB_ATTRIB_NEVER_USE) {
-			dprintf("\t\tMPB_ATTRIB_NEVER_USE\n");
-			not_supported ^= MPB_ATTRIB_NEVER_USE;
-		}
-
-		if (not_supported)
-			dprintf("(IMSM): Unknown attributes : %x\n", not_supported);
-
-		ret_val = 0;
-	}
+	if ((attributes & (MPB_ATTRIB_SUPPORTED | MPB_ATTRIB_IGNORED)) == attributes)
+		return true;
 
-	return ret_val;
+	return false;
 }
 
 static void getinfo_super_imsm(struct supertype *st, struct mdinfo *info, char *map);
@@ -2247,11 +2174,10 @@ static void examine_super_imsm(struct supertype *st, char *homehost)
 	creation_time = __le64_to_cpu(mpb->creation_time);
 	printf("  Creation Time : %.24s\n",
 		creation_time ? ctime(&creation_time) : "Unknown");
-	printf("     Attributes : ");
-	if (imsm_check_attributes(mpb->attributes))
-		printf("All supported\n");
-	else
-		printf("not supported\n");
+
+	printf("     Attributes : %08x (%s)\n", mpb->attributes,
+	       imsm_check_attributes(mpb->attributes) ? "supported" : "not supported");
+
 	getinfo_super_imsm(st, &info, NULL);
 	fname_from_uuid(&info, nbuf);
 	printf("           UUID : %s\n", nbuf + 5);
@@ -8182,9 +8108,9 @@ static struct mdinfo *container_content_imsm(struct supertype *st, char *subarra
 	int current_vol = super->current_vol;
 
 	/* do not assemble arrays when not all attributes are supported */
-	if (imsm_check_attributes(mpb->attributes) == 0) {
+	if (imsm_check_attributes(mpb->attributes) == false) {
 		sb_errors = 1;
-		pr_err("Unsupported attributes in IMSM metadata.Arrays activation is blocked.\n");
+		pr_err("Unsupported attributes in IMSM metadata. Arrays activation is blocked.\n");
 	}
 
 	/* count spare devices, not used in maps
-- 
2.39.2

