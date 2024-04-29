Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56B2A3C482
	for <linux-raid@vger.kernel.org>; Mon, 29 Apr 2024 13:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714396071; cv=none; b=ifbia9Hh2NM8G92bS+TocSoXmS7MZzBVUGoncKkcpXCefiSjrCep38gj9P55GGs9cFKvKyGXCPzPlnSsujlnbYy4UVtb3bMzKzUs2MFtjZwslJbNFHStsR0XYOekKOgvI0IKnA1FSohg40oWsGJdR8JgRYXjCSQKJpZuh0Abfpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714396071; c=relaxed/simple;
	bh=s68wM1w2f5trdENLfcBrEuCSWzUPYbPhs64e2QatsEc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=l5MZQ6g8Wp9HF/abrqp7U8nX9RymoGxZ0vdAvcXlMA1ObnMb3R/Qg+vVwe2CAJeALlsEQijECcpEZ0vtk8SpYfYKtifqTKgrsoflM4Mk8+sf6IFpWQdsV/ZGda6GHoIUjAcLpnLG7kNOMhIegFB0NoDt4FXNw+aPfwd5R3Ff0b0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=n/X9nTGU; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="n/X9nTGU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714396070; x=1745932070;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=s68wM1w2f5trdENLfcBrEuCSWzUPYbPhs64e2QatsEc=;
  b=n/X9nTGUzMIEd0hN0YNczAffKljYw6cXb31j5Fn9NmUlW+xiAqhPpe/l
   M/pJgGqtozzTqXUGnTNt1OZm/8R0yBdjrTOEUWeFE2f53BhA1wHwIiPJ3
   MSK7K3dqDZB4ZL8p+LcUiSzp/0RaiDBnE3jqUx8treV6R3jt/HXRZ77FQ
   fmg9mcs1RH1hLM/UwJ4U5DainTyqPVNshR5UeBZ48moPvH7OXJBiX1vEK
   9cChMfqpgbpaMRf/+oGsrMQ7kA2H0g0jS/psqGFmu+p1BP5PiD23FfqMc
   BsSxLh2cP+SgSPiMgE7Er3ixIjVUVwT0uUJLb3vwrhYuecVkzTYfM/TRo
   A==;
X-CSE-ConnectionGUID: kk6JCVQ1QGCCgflKfH/QCw==
X-CSE-MsgGUID: D+QGqLMBR/uUaoUCBPuG5w==
X-IronPort-AV: E=McAfee;i="6600,9927,11057"; a="32554411"
X-IronPort-AV: E=Sophos;i="6.07,239,1708416000"; 
   d="scan'208";a="32554411"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2024 06:07:50 -0700
X-CSE-ConnectionGUID: iTqM0Z9nSGyp+m3OCKo/Jw==
X-CSE-MsgGUID: XFfY604MTDaDQuFFtN/o4Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,239,1708416000"; 
   d="scan'208";a="26609884"
Received: from patodeveloperka.igk.intel.com ([10.102.109.29])
  by orviesa007.jf.intel.com with ESMTP; 29 Apr 2024 06:07:50 -0700
From: Mateusz Kusiak <mateusz.kusiak@intel.com>
To: linux-raid@vger.kernel.org
Cc: mariusz.tkaczyk@linux.intel.com,
	jes@trained-monkey.org
Subject: [PATCH 3/8] imsm: add support for literal RAID 10
Date: Mon, 29 Apr 2024 15:07:15 +0200
Message-Id: <20240429130720.260452-4-mateusz.kusiak@intel.com>
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

As for now, IMSM supports only 4 drive RAID 1+0. This patch is first in
series to add support for literal RAID 10 (with more than 4 drives) to
imsm.

Allow setting RAID 10 as raid level for imsm arrays.

Add update_imsm_raid_level() to handle raid level updates. Set RAID10 as
default level for imsm R0 to R10 migrations. Replace magic numbers with
defined values for RAID level checks/assigns.

Signed-off-by: Mateusz Kusiak <mateusz.kusiak@intel.com>
Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 super-intel.c | 67 ++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 48 insertions(+), 19 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 1a8a7b125025..a7efc8df0b47 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -166,7 +166,8 @@ struct imsm_map {
 	__u8  raid_level;
 #define IMSM_T_RAID0 0
 #define IMSM_T_RAID1 1
-#define IMSM_T_RAID5 5		/* since metadata version 1.2.02 ? */
+#define IMSM_T_RAID5 5
+#define IMSM_T_RAID10 10
 	__u8  num_members;	/* number of member disks */
 	__u8  num_domains;	/* number of parity domains */
 	__u8  failed_disk_num;  /* valid only when state is degraded */
@@ -1259,14 +1260,42 @@ static int get_imsm_disk_slot(struct imsm_map *map, const unsigned int idx)
 
 	return IMSM_STATUS_ERROR;
 }
+/**
+ * update_imsm_raid_level() - update raid level appropriately in &imsm_map.
+ * @map:	&imsm_map pointer.
+ * @new_level:	MD style level.
+ *
+ * For backward compatibility reasons we need to differentiate RAID10.
+ * In the past IMSM RAID10 was presented as RAID1.
+ * Keep compatibility unless it is not explicitly updated by UEFI driver.
+ *
+ * Routine needs num_members to be set and (optionally) raid_level.
+ */
+static void update_imsm_raid_level(struct imsm_map *map, int new_level)
+{
+	if (new_level != IMSM_T_RAID10) {
+		map->raid_level = new_level;
+		return;
+	}
+
+	if (map->num_members == 4) {
+		if (map->raid_level == IMSM_T_RAID10 || map->raid_level == IMSM_T_RAID1)
+			return;
+
+		map->raid_level = IMSM_T_RAID1;
+		return;
+	}
+
+	map->raid_level = IMSM_T_RAID10;
+}
 
 static int get_imsm_raid_level(struct imsm_map *map)
 {
-	if (map->raid_level == 1) {
+	if (map->raid_level == IMSM_T_RAID1) {
 		if (map->num_members == 2)
-			return 1;
+			return IMSM_T_RAID1;
 		else
-			return 10;
+			return IMSM_T_RAID10;
 	}
 
 	return map->raid_level;
@@ -5678,7 +5707,7 @@ static int init_super_imsm_volume(struct supertype *st, mdu_array_info_t *info,
 	set_pba_of_lba0(map, super->create_offset);
 	map->blocks_per_strip = __cpu_to_le16(info_to_blocks_per_strip(info));
 	map->failed_disk_num = ~0;
-	if (info->level > 0)
+	if (info->level > IMSM_T_RAID0)
 		map->map_state = (info->state ? IMSM_T_STATE_NORMAL
 				  : IMSM_T_STATE_UNINITIALIZED);
 	else
@@ -5686,16 +5715,15 @@ static int init_super_imsm_volume(struct supertype *st, mdu_array_info_t *info,
 						      IMSM_T_STATE_NORMAL;
 	map->ddf = 1;
 
-	if (info->level == 1 && info->raid_disks > 2) {
+	if (info->level == IMSM_T_RAID1 && info->raid_disks > 2) {
 		free(dev);
 		free(dv);
-		pr_err("imsm does not support more than 2 disksin a raid1 volume\n");
+		pr_err("imsm does not support more than 2 disks in a raid1 volume\n");
 		return 0;
 	}
+	map->num_members = info->raid_disks;
 
-	map->raid_level = info->level;
-	if (info->level == 10)
-		map->raid_level = 1;
+	update_imsm_raid_level(map, info->level);
 	set_num_domains(map);
 
 	size_per_member += NUM_BLOCKS_DIRTY_STRIPE_REGION;
@@ -5703,7 +5731,6 @@ static int init_super_imsm_volume(struct supertype *st, mdu_array_info_t *info,
 							     size_per_member /
 							     BLOCKS_PER_KB));
 
-	map->num_members = info->raid_disks;
 	update_num_data_stripes(map, array_blocks);
 	for (i = 0; i < map->num_members; i++) {
 		/* initialized in add_to_super */
@@ -8275,7 +8302,7 @@ static struct mdinfo *container_content_imsm(struct supertype *st, char *subarra
 			info_d->data_offset = pba_of_lba0(map);
 			info_d->component_size = calc_component_size(map, dev);
 
-			if (map->raid_level == 5) {
+			if (map->raid_level == IMSM_T_RAID5) {
 				info_d->ppl_sector = this->ppl_sector;
 				info_d->ppl_size = this->ppl_size;
 				if (this->consistency_policy == CONSISTENCY_POLICY_PPL &&
@@ -9533,7 +9560,7 @@ static int apply_reshape_migration_update(struct imsm_update_reshape_migration *
 			}
 
 			to_state = map->map_state;
-			if ((u->new_level == 5) && (map->raid_level == 0)) {
+			if ((u->new_level == IMSM_T_RAID5) && (map->raid_level == IMSM_T_RAID0)) {
 				map->num_members++;
 				/* this should not happen */
 				if (u->new_disks[0] < 0) {
@@ -9544,11 +9571,13 @@ static int apply_reshape_migration_update(struct imsm_update_reshape_migration *
 					to_state = IMSM_T_STATE_NORMAL;
 			}
 			migrate(new_dev, super, to_state, MIGR_GEN_MIGR);
+
 			if (u->new_level > -1)
-				map->raid_level = u->new_level;
+				update_imsm_raid_level(map, u->new_level);
+
 			migr_map = get_imsm_map(new_dev, MAP_1);
-			if ((u->new_level == 5) &&
-			    (migr_map->raid_level == 0)) {
+			if ((u->new_level == IMSM_T_RAID5) &&
+			    (migr_map->raid_level == IMSM_T_RAID0)) {
 				int ord = map->num_members - 1;
 				migr_map->num_members--;
 				if (u->new_disks[0] < 0)
@@ -9584,7 +9613,7 @@ static int apply_reshape_migration_update(struct imsm_update_reshape_migration *
 
 			/* add disk
 			 */
-			if (u->new_level != 5 || migr_map->raid_level != 0 ||
+			if (u->new_level != IMSM_T_RAID5 || migr_map->raid_level != IMSM_T_RAID0 ||
 			    migr_map->raid_level == map->raid_level)
 				goto skip_disk_add;
 
@@ -9963,7 +9992,7 @@ static int apply_takeover_update(struct imsm_update_takeover *u,
 		/* update map */
 		map->num_members /= map->num_domains;
 		map->map_state = IMSM_T_STATE_NORMAL;
-		map->raid_level = 0;
+		update_imsm_raid_level(map, IMSM_T_RAID0);
 		set_num_domains(map);
 		update_num_data_stripes(map, imsm_dev_size(dev));
 		map->failed_disk_num = -1;
@@ -10007,7 +10036,7 @@ static int apply_takeover_update(struct imsm_update_takeover *u,
 		map = get_imsm_map(dev_new, MAP_0);
 
 		map->map_state = IMSM_T_STATE_DEGRADED;
-		map->raid_level = 1;
+		update_imsm_raid_level(map, IMSM_T_RAID10);
 		set_num_domains(map);
 		map->num_members = map->num_members * map->num_domains;
 		update_num_data_stripes(map, imsm_dev_size(dev));
-- 
2.39.2

