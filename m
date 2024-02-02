Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BE89148303
	for <linux-raid@vger.kernel.org>; Fri,  2 Feb 2024 16:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706891960; cv=none; b=nwRXOQxIF4Q5ScR1sNVFg3Q5hV2WbFEPkJxKbv6oMLQ8ydiPNkrOdo1/F9te14fbn4Qk1wDubbgPQ+zNnwOkb5iMoKahZJ1ObZprfp7IkUopEl0/q+sLRCAlDl9Y+EH8S60dp9aIF4mzcaqXOnJAcmwZzcqZmxASmw5cR3tRDZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706891960; c=relaxed/simple;
	bh=xWsJ8IricUmi6yQa/nWBPHNebhVBgmii5uuAT/dDf8c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ub6qHcnXRbIdaW5FqvCG2aIVu45Et5vEJzCKJMBA8zGjaDSfRXgnoBva7KbD0JTvTB+9DsUgVN8mw6B1DISzON+QYPYXh+LIIToWR3i8mHFWKcDnl+2b3hhtinOslrExG1xET6jFCRtuggFXLFi32ZRoEvmYsI4NugDEoIUQdGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Tqp1ROVc; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Tqp1ROVc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706891956; x=1738427956;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xWsJ8IricUmi6yQa/nWBPHNebhVBgmii5uuAT/dDf8c=;
  b=Tqp1ROVcRvaMAH/zcHWJ7aX7ciF98bGzMOzO3kaKbRpCdR7C7kBzV8Zd
   9ttkXoU6tWzSmabFRc+rsaH7km9ZVKe8oIwMfyabQZQJRtj6EyMvoUfn6
   RhWWNFlgTTuOi+VPScDNsWA0DI3x4Om4pMCMa3zVbr4wY7mxgB9sKE0fe
   7GRqu80K97AMI4obUgRDNd8JGPRBM8JZbAuSIVlfsLn4w5/ncC/vr0khi
   Hh2VZJWQ9S2Q3NSsPCzdKamV0tEtcqiW5hPKDxdexQOUKQf1pxZb6/mBe
   bi1bkrgQ5Vpwcj8movYKU1iABmUwjpmhEVKYjulqOp5n9AnCHsSvOpBZU
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10971"; a="376818"
X-IronPort-AV: E=Sophos;i="6.05,238,1701158400"; 
   d="scan'208";a="376818"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2024 08:39:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,238,1701158400"; 
   d="scan'208";a="4723288"
Received: from unknown (HELO mtkaczyk-devel.igk.intel.com) ([10.102.108.91])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2024 08:39:14 -0800
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: jes@trained-monkey.org
Cc: linux-raid@vger.kernel.org,
	Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Subject: [PATCH 2/2] Revert "mdadm: remove container_enough logic"
Date: Fri,  2 Feb 2024 17:38:35 +0100
Message-Id: <20240202163835.9652-3-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20240202163835.9652-1-mariusz.tkaczyk@linux.intel.com>
References: <20240202163835.9652-1-mariusz.tkaczyk@linux.intel.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This reverts commit 4dde420fc3e24077ab926f79674eaae1b71de10b.

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 Incremental.c | 11 +++++++++++
 mdadm.h       |  3 +++
 super-ddf.c   |  1 +
 super-intel.c | 32 +++++++++++++++++++++++++++++++-
 4 files changed, 46 insertions(+), 1 deletion(-)

diff --git a/Incremental.c b/Incremental.c
index 6cbc164a27b9..5477a5369c6f 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -1467,6 +1467,17 @@ static int Incremental_container(struct supertype *st, char *devname,
 
 	st->ss->getinfo_super(st, &info, NULL);
 
+	if ((c->runstop > 0 && info.container_enough >= 0) ||
+	    info.container_enough > 0)
+		/* pass */;
+	else {
+		if (c->export) {
+			printf("MD_STARTED=no\n");
+		} else if (c->verbose)
+			pr_err("not enough devices to start the container\n");
+		return 0;
+	}
+
 	match = conf_match(st, &info, devname, c->verbose, &rv);
 	if (match == NULL && rv == 2)
 		return rv;
diff --git a/mdadm.h b/mdadm.h
index 709b6104c401..0b647085fea1 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -377,6 +377,9 @@ struct mdinfo {
 	int container_member; /* for assembling external-metatdata arrays
 			       * This is to be used internally by metadata
 			       * handler only */
+	int container_enough; /* flag external handlers can set to
+			       * indicate that subarrays have not enough (-1),
+			       * enough to start (0), or all expected disks (1) */
 	char		sys_name[32];
 	struct mdinfo *devs;
 	struct mdinfo *next;
diff --git a/super-ddf.c b/super-ddf.c
index a87e3169d325..7571e3b740c6 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -1975,6 +1975,7 @@ static void getinfo_super_ddf(struct supertype *st, struct mdinfo *info, char *m
 	info->array.ctime	  = DECADE + __be32_to_cpu(*cptr);
 
 	info->array.chunk_size	  = 0;
+	info->container_enough	  = 1;
 
 	info->disk.major	  = 0;
 	info->disk.minor	  = 0;
diff --git a/super-intel.c b/super-intel.c
index 6a664a2e58d3..697820b0d85e 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -3778,6 +3778,7 @@ static void getinfo_super_imsm(struct supertype *st, struct mdinfo *info, char *
 	struct intel_super *super = st->sb;
 	struct imsm_disk *disk;
 	int map_disks = info->array.raid_disks;
+	int max_enough = -1;
 	int i;
 	struct imsm_super *mpb;
 
@@ -3819,9 +3820,12 @@ static void getinfo_super_imsm(struct supertype *st, struct mdinfo *info, char *
 
 	for (i = 0; i < mpb->num_raid_devs; i++) {
 		struct imsm_dev *dev = get_imsm_dev(super, i);
-		int j = 0;
+		int failed, enough, j, missing = 0;
 		struct imsm_map *map;
+		__u8 state;
 
+		failed = imsm_count_failed(super, dev, MAP_0);
+		state = imsm_check_degraded(super, dev, failed, MAP_0);
 		map = get_imsm_map(dev, MAP_0);
 
 		/* any newly missing disks?
@@ -3836,10 +3840,36 @@ static void getinfo_super_imsm(struct supertype *st, struct mdinfo *info, char *
 
 			if (!(ord & IMSM_ORD_REBUILD) &&
 			    get_imsm_missing(super, idx)) {
+				missing = 1;
 				break;
 			}
 		}
+
+		if (state == IMSM_T_STATE_FAILED)
+			enough = -1;
+		else if (state == IMSM_T_STATE_DEGRADED &&
+			 (state != map->map_state || missing))
+			enough = 0;
+		else /* we're normal, or already degraded */
+			enough = 1;
+		if (is_gen_migration(dev) && missing) {
+			/* during general migration we need all disks
+			 * that process is running on.
+			 * No new missing disk is allowed.
+			 */
+			max_enough = -1;
+			enough = -1;
+			/* no more checks necessary
+			 */
+			break;
+		}
+		/* in the missing/failed disk case check to see
+		 * if at least one array is runnable
+		 */
+		max_enough = max(max_enough, enough);
 	}
+	dprintf("enough: %d\n", max_enough);
+	info->container_enough = max_enough;
 
 	if (super->disks) {
 		__u32 reserved = imsm_reserved_sectors(super, super->disks);
-- 
2.35.3

