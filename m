Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18942C12002
	for <linux-raid@archiver.kernel.org>; Wed, 21 Jul 2021 12:01:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F1F7D611C1
	for <linux-raid@archiver.kernel.org>; Wed, 21 Jul 2021 12:01:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235808AbhGULUy (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 21 Jul 2021 07:20:54 -0400
Received: from mga05.intel.com ([192.55.52.43]:56810 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239304AbhGULCW (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 21 Jul 2021 07:02:22 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10051"; a="296979768"
X-IronPort-AV: E=Sophos;i="5.84,258,1620716400"; 
   d="scan'208";a="296979768"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2021 04:42:58 -0700
X-IronPort-AV: E=Sophos;i="5.84,258,1620716400"; 
   d="scan'208";a="511766620"
Received: from mtkaczyk-devel.igk.intel.com ([10.102.102.23])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2021 04:42:57 -0700
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH] imsm: fix num_data_stripes after raid0 takeover
Date:   Wed, 21 Jul 2021 13:42:20 +0200
Message-Id: <20210721114220.19399-1-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

After raid1 to raid0 migration num_data_stripes value is
incorrect because was additionally divided by 2.

Create dedicated setters for num_data_stripes and num_domains
and propagate it across the code to unify alghoritms and
eliminate similar mistakes.

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 super-intel.c | 139 ++++++++++++++++++++++++++++----------------------
 1 file changed, 77 insertions(+), 62 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 876e077c..d63e7954 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -1228,6 +1228,33 @@ static unsigned long long total_blocks(struct imsm_disk *disk)
 	return join_u32(disk->total_blocks_lo, disk->total_blocks_hi);
 }
 
+/**
+ * imsm_num_data_members() - get data drives count for an array.
+ * @map: Map to analyze.
+ *
+ * num_data_members value represents minimal count of drives for level.
+ * The name of the property could be misleading for RAID5 with asymmetric layout
+ * because some data required to be calculated from parity.
+ * The property is extracted from level and num_members value.
+ *
+ * Return: num_data_members value on success, zero otherwise.
+ */
+static __u8 imsm_num_data_members(struct imsm_map *map)
+{
+	switch (get_imsm_raid_level(map)) {
+	case 0:
+		return map->num_members;
+	case 1:
+	case 10:
+		return map->num_members / 2;
+	case 5:
+		return map->num_members - 1;
+	default:
+		dprintf("unsupported raid level\n");
+		return 0;
+	}
+}
+
 static unsigned long long pba_of_lba0(struct imsm_map *map)
 {
 	if (map == NULL)
@@ -1301,6 +1328,24 @@ static void set_total_blocks(struct imsm_disk *disk, unsigned long long n)
 	split_ull(n, &disk->total_blocks_lo, &disk->total_blocks_hi);
 }
 
+/**
+ * set_num_domains() - Set number of domains for an array.
+ * @map: Map to be updated.
+ *
+ * num_domains property represents copies count of each data drive, thus make
+ * it meaningful only for RAID1 and RAID10. IMSM supports two domains for
+ * raid1 and raid10.
+ */
+static void set_num_domains(struct imsm_map *map)
+{
+	int level = get_imsm_raid_level(map);
+
+	if (level == 1 || level == 10)
+		map->num_domains = 2;
+	else
+		map->num_domains = 1;
+}
+
 static void set_pba_of_lba0(struct imsm_map *map, unsigned long long n)
 {
 	split_ull(n, &map->pba_of_lba0_lo, &map->pba_of_lba0_hi);
@@ -1316,6 +1361,24 @@ static void set_num_data_stripes(struct imsm_map *map, unsigned long long n)
 	split_ull(n, &map->num_data_stripes_lo, &map->num_data_stripes_hi);
 }
 
+/**
+ * update_num_data_stripes() - Calculate and update num_data_stripes value.
+ * @map: map to be updated.
+ * @dev_size: size of volume.
+ *
+ * num_data_stripes value is addictionally divided by num_domains, therefore for
+ * levels where num_domains is not 1, nds is a part of real value.
+ */
+static void update_num_data_stripes(struct imsm_map *map,
+				     unsigned long long dev_size)
+{
+	unsigned long long nds = dev_size / imsm_num_data_members(map);
+
+	nds /= map->num_domains;
+	nds /= map->blocks_per_strip;
+	set_num_data_stripes(map, nds);
+}
+
 static void set_vol_curr_migr_unit(struct imsm_dev *dev, unsigned long long n)
 {
 	if (dev == NULL)
@@ -2880,26 +2943,6 @@ static __u32 num_stripes_per_unit_rebuild(struct imsm_dev *dev)
 		return num_stripes_per_unit_resync(dev);
 }
 
-static __u8 imsm_num_data_members(struct imsm_map *map)
-{
-	/* named 'imsm_' because raid0, raid1 and raid10
-	 * counter-intuitively have the same number of data disks
-	 */
-	switch (get_imsm_raid_level(map)) {
-	case 0:
-		return map->num_members;
-		break;
-	case 1:
-	case 10:
-		return map->num_members/2;
-	case 5:
-		return map->num_members - 1;
-	default:
-		dprintf("unsupported raid level\n");
-		return 0;
-	}
-}
-
 static unsigned long long calc_component_size(struct imsm_map *map,
 					      struct imsm_dev *dev)
 {
@@ -5482,7 +5525,6 @@ static int init_super_imsm_volume(struct supertype *st, mdu_array_info_t *info,
 	int namelen;
 	unsigned long long array_blocks;
 	size_t size_old, size_new;
-	unsigned long long num_data_stripes;
 	unsigned int data_disks;
 	unsigned long long size_per_member;
 
@@ -5600,18 +5642,9 @@ static int init_super_imsm_volume(struct supertype *st, mdu_array_info_t *info,
 	}
 
 	map->raid_level = info->level;
-	if (info->level == 10) {
+	if (info->level == 10)
 		map->raid_level = 1;
-		map->num_domains = info->raid_disks / 2;
-	} else if (info->level == 1)
-		map->num_domains = info->raid_disks;
-	else
-		map->num_domains = 1;
-
-	/* info->size is only int so use the 'size' parameter instead */
-	num_data_stripes = size_per_member / info_to_blocks_per_strip(info);
-	num_data_stripes /= map->num_domains;
-	set_num_data_stripes(map, num_data_stripes);
+	set_num_domains(map);
 
 	size_per_member += NUM_BLOCKS_DIRTY_STRIPE_REGION;
 	set_blocks_per_member(map, info_to_blocks_per_member(info,
@@ -5619,6 +5652,7 @@ static int init_super_imsm_volume(struct supertype *st, mdu_array_info_t *info,
 							     BLOCKS_PER_KB));
 
 	map->num_members = info->raid_disks;
+	update_num_data_stripes(map, array_blocks);
 	for (i = 0; i < map->num_members; i++) {
 		/* initialized in add_to_super */
 		set_imsm_ord_tbl_ent(map, i, IMSM_ORD_REBUILD);
@@ -9445,7 +9479,6 @@ static int apply_reshape_migration_update(struct imsm_update_reshape_migration *
 			/* update chunk size
 			 */
 			if (u->new_chunksize > 0) {
-				unsigned long long num_data_stripes;
 				struct imsm_map *dest_map =
 					get_imsm_map(dev, MAP_0);
 				int used_disks =
@@ -9456,11 +9489,7 @@ static int apply_reshape_migration_update(struct imsm_update_reshape_migration *
 
 				map->blocks_per_strip =
 					__cpu_to_le16(u->new_chunksize * 2);
-				num_data_stripes =
-					imsm_dev_size(dev) / used_disks;
-				num_data_stripes /= map->blocks_per_strip;
-				num_data_stripes /= map->num_domains;
-				set_num_data_stripes(map, num_data_stripes);
+				update_num_data_stripes(map, imsm_dev_size(dev));
 			}
 
 			/* ensure blocks_per_member has valid value
@@ -9534,7 +9563,6 @@ static int apply_size_change_update(struct imsm_update_size_change *u,
 			struct imsm_map *map = get_imsm_map(dev, MAP_0);
 			int used_disks = imsm_num_data_members(map);
 			unsigned long long blocks_per_member;
-			unsigned long long num_data_stripes;
 			unsigned long long new_size_per_disk;
 
 			if (used_disks == 0)
@@ -9545,16 +9573,10 @@ static int apply_size_change_update(struct imsm_update_size_change *u,
 			new_size_per_disk = u->new_size / used_disks;
 			blocks_per_member = new_size_per_disk +
 					    NUM_BLOCKS_DIRTY_STRIPE_REGION;
-			num_data_stripes = new_size_per_disk /
-					   map->blocks_per_strip;
-			num_data_stripes /= map->num_domains;
-			dprintf("(size: %llu, blocks per member: %llu, num_data_stipes: %llu)\n",
-				u->new_size, new_size_per_disk,
-				num_data_stripes);
-			set_blocks_per_member(map, blocks_per_member);
-			set_num_data_stripes(map, num_data_stripes);
-			imsm_set_array_size(dev, u->new_size);
 
+			imsm_set_array_size(dev, u->new_size);
+			set_blocks_per_member(map, blocks_per_member);
+			update_num_data_stripes(map, u->new_size);
 			ret_val = 1;
 			break;
 		}
@@ -9836,8 +9858,6 @@ static int apply_takeover_update(struct imsm_update_takeover *u,
 	map = get_imsm_map(dev, MAP_0);
 
 	if (u->direction == R10_TO_R0) {
-		unsigned long long num_data_stripes;
-
 		/* Number of failed disks must be half of initial disk number */
 		if (imsm_count_failed(super, dev, MAP_0) !=
 				(map->num_members / 2))
@@ -9858,19 +9878,16 @@ static int apply_takeover_update(struct imsm_update_takeover *u,
 			}
 		}
 		/* update map */
-		map->num_members = map->num_members / 2;
+		map->num_members /= map->num_domains;
 		map->map_state = IMSM_T_STATE_NORMAL;
-		map->num_domains = 1;
 		map->raid_level = 0;
+		set_num_domains(map);
+		update_num_data_stripes(map, imsm_dev_size(dev));
 		map->failed_disk_num = -1;
-		num_data_stripes = imsm_dev_size(dev) / 2;
-		num_data_stripes /= map->blocks_per_strip;
-		set_num_data_stripes(map, num_data_stripes);
 	}
 
 	if (u->direction == R0_TO_R10) {
 		void **space;
-		unsigned long long num_data_stripes;
 
 		/* update slots in current disk list */
 		for (dm = super->disks; dm; dm = dm->next) {
@@ -9905,14 +9922,12 @@ static int apply_takeover_update(struct imsm_update_takeover *u,
 		memcpy(dev_new, dev, sizeof(*dev));
 		/* update new map */
 		map = get_imsm_map(dev_new, MAP_0);
-		map->num_members = map->num_members * 2;
+
 		map->map_state = IMSM_T_STATE_DEGRADED;
-		map->num_domains = 2;
 		map->raid_level = 1;
-		num_data_stripes = imsm_dev_size(dev) / 2;
-		num_data_stripes /= map->blocks_per_strip;
-		num_data_stripes /= map->num_domains;
-		set_num_data_stripes(map, num_data_stripes);
+		set_num_domains(map);
+		map->num_members = map->num_members * map->num_domains;
+		update_num_data_stripes(map, imsm_dev_size(dev));
 
 		/* replace dev<->dev_new */
 		dv->dev = dev_new;
-- 
2.26.2

