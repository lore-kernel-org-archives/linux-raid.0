Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC60D2C190
	for <linux-raid@vger.kernel.org>; Mon,  5 Feb 2024 14:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707144651; cv=none; b=BI7i+lyGhXfuVZ3CN6d8KxozysMA3OXvQNVXhdlT0fstcIWcDgwmt2N6zdKHSttW1Y9cRRJSkuKUrvf2INBwuzMVatWSbNDW8YyyROSyqOfTjLV558Jy+Fxbe/nZBOT8WZRE/7G3IpkiNEgBvRobGPEnLsPKecTgasE4NRXwXFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707144651; c=relaxed/simple;
	bh=sn77qEybrd8m/trpjxwcrrANedGrvttvaVqfVPyazWQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Vq9qotjIv7Kz2OvIGI4RIPTxhAGJg2tLyXwfZ0r6b+75PI1zyMZJ+j6MbkTmMaokvgiGLdowxXgBfT+HIlNEpEVblECb7whO8q94McZkxLI23Xd0vvCwnI7eGIHEa9ljVagJeYNYlQkcZ4K6/PfGRXZ8svxQBywWtln6Kmxb++A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KPHTvLMc; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KPHTvLMc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707144649; x=1738680649;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=sn77qEybrd8m/trpjxwcrrANedGrvttvaVqfVPyazWQ=;
  b=KPHTvLMc43ebbrRCNaWG36xvYTJoGQQ6MF8C+kc/kdqc/pW6ZfWSpTgP
   XsiQI6FOHUE34nZfaO0PsS1mLyTkQDzLf/4HJe/mRrdetGUVstYEE95Wk
   WYRjc+Jv/xbhgBp5XCM2dMJuvF+4D+R9FpU/3jkSuZXR+4aN5UpROJEeb
   bwgFs8KZJ3hYSqkcivtl25jZPZQ3zJyFvv0O6A/lXc0CnRqClwxApP2EZ
   1k9nenfpM1Eqp+LTXO/DRbepuD0qubdzgnpmwSbMZa4yX1FbLKv736/Xq
   /5e/E3wUXbWMuB/XQNWG+Z3Bz4tL41K3gzChnRAiSjqOEGPzE66PXTQ85
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10974"; a="447699"
X-IronPort-AV: E=Sophos;i="6.05,245,1701158400"; 
   d="scan'208";a="447699"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2024 06:50:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,245,1701158400"; 
   d="scan'208";a="5339728"
Received: from unknown (HELO mtkaczyk-devel.igk.intel.com) ([10.102.108.91])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2024 06:50:48 -0800
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: jes@trained-monkey.org
Cc: linux-raid@vger.kernel.org,
	Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Subject: [PATCH v2] Revert "mdadm: remove container_enough logic"
Date: Mon,  5 Feb 2024 15:50:29 +0100
Message-Id: <20240205145029.12022-1-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.35.3
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Mentioned patch changes way of IMSM member arrays assembling, they are
updated by every new drive incremental processes. Previously, member
arrays were created and filled once, by last drive incremental process.

We determined regressions with various impact. Unfortunately, initial
testing didn't show them.

Regressions are connected to drive appearance order and may not be
reproducible on every configuration, there are at least two know
issues for now:

- sysfs attributes are filled using old metadata if there is
  outdated drive and it is enumerated first.

- rebuild may be aborted and started from beginning after reboot,
  if drive under rebuild is enumerated as the last one.

This reverts commit 4dde420fc3e24077ab926f79674eaae1b71de10b. It fixes
checkpatch issues and reworks logic to remove empty "if" branch in
Incremental.

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 Incremental.c |  9 +++++++++
 mdadm.h       |  7 +++++++
 super-ddf.c   |  1 +
 super-intel.c | 32 +++++++++++++++++++++++++++++++-
 4 files changed, 48 insertions(+), 1 deletion(-)

diff --git a/Incremental.c b/Incremental.c
index 6cbc164a27b9..30c07c037028 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -1467,6 +1467,15 @@ static int Incremental_container(struct supertype *st, char *devname,
 
 	st->ss->getinfo_super(st, &info, NULL);
 
+	if (info.container_enough < 0 || (info.container_enough == 0 && c->runstop < 1)) {
+		if (c->export)
+			printf("MD_STARTED=no\n");
+		else if (c->verbose)
+			pr_err("Not enough devices to start the container.\n");
+
+		return 0;
+	}
+
 	match = conf_match(st, &info, devname, c->verbose, &rv);
 	if (match == NULL && rv == 2)
 		return rv;
diff --git a/mdadm.h b/mdadm.h
index 709b6104c401..1f28b3e754be 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -377,6 +377,13 @@ struct mdinfo {
 	int container_member; /* for assembling external-metatdata arrays
 			       * This is to be used internally by metadata
 			       * handler only */
+	/**
+	 * flag external handlers can set to indicate that subarrays have:
+	 * - not enough disks to start (-1),
+	 * - enough disks to start (0),
+	 * - all expected disks (1).
+	 */
+	int container_enough;
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
index 6a664a2e58d3..dbea235dd4bd 100644
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
@@ -3836,11 +3840,37 @@ static void getinfo_super_imsm(struct supertype *st, struct mdinfo *info, char *
 
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
 
+	info->container_enough = max_enough;
+
 	if (super->disks) {
 		__u32 reserved = imsm_reserved_sectors(super, super->disks);
 
-- 
2.35.3

