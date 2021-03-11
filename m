Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1D08C433DB
	for <linux-raid@archiver.kernel.org>; Thu, 11 Mar 2021 12:53:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D16964E92
	for <linux-raid@archiver.kernel.org>; Thu, 11 Mar 2021 12:53:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232949AbhCKMw6 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 11 Mar 2021 07:52:58 -0500
Received: from mga18.intel.com ([134.134.136.126]:60823 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233155AbhCKMw4 (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 11 Mar 2021 07:52:56 -0500
IronPort-SDR: kZPey2ewMYE7KjBQrLbsoUvXreiaFDCg1jc0w2CcVhi/6JmDPLlbSoa3vWKNIjeErNGHfDcU0p
 LT2CGI/0LQgQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9919"; a="176254873"
X-IronPort-AV: E=Sophos;i="5.81,240,1610438400"; 
   d="scan'208";a="176254873"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2021 04:52:55 -0800
IronPort-SDR: +h9hkWPJQrkwbJIPdpGMzaJUC1cLgEAw2vE7WzFhZWsgl1M/E7C2YZox9HK394T9rBNN67vrUR
 QsMtyZWLkAkA==
X-IronPort-AV: E=Sophos;i="5.81,240,1610438400"; 
   d="scan'208";a="448275033"
Received: from mtkaczyk-devel.igk.intel.com ([10.102.102.23])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2021 04:52:54 -0800
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH] imsm: extend curr_migr_unit to u64
Date:   Thu, 11 Mar 2021 13:52:45 +0100
Message-Id: <20210311125245.9615-1-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Make it u64 to align it with curr_migr_init field from migration_area.

Name helpers as vol_curr_migr_unit for differentiation between those
fields. Add ommited fillers in struct migr_record.

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 super-intel.c | 92 ++++++++++++++++++++++++++++-----------------------
 1 file changed, 51 insertions(+), 41 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 715febf7..5c2c28b9 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -164,7 +164,7 @@ struct imsm_map {
 ASSERT_SIZE(imsm_map, 52)
 
 struct imsm_vol {
-	__u32 curr_migr_unit;
+	__u32 curr_migr_unit_lo;
 	__u32 checkpoint_id;	/* id to access curr_migr_unit */
 	__u8  migr_state;	/* Normal or Migrating */
 #define MIGR_INIT 0
@@ -181,7 +181,8 @@ struct imsm_vol {
 	__u8  fs_state;		/* fast-sync state for CnG (0xff == disabled) */
 	__u16 verify_errors;	/* number of mismatches */
 	__u16 bad_blocks;	/* number of bad blocks during verify */
-	__u32 filler[4];
+	__u32 curr_migr_unit_hi;
+	__u32 filler[3];
 	struct imsm_map map[1];
 	/* here comes another one if migr_state */
 };
@@ -343,8 +344,9 @@ struct migr_record {
 				       * destination - high order 32 bits */
 	__u32 num_migr_units_hi;      /* Total num migration units-of-op
 				       * high order 32 bits */
+	__u32 filler[16];
 };
-ASSERT_SIZE(migr_record, 64)
+ASSERT_SIZE(migr_record, 128)
 
 struct md_list {
 	/* usage marker:
@@ -551,7 +553,7 @@ struct imsm_update_size_change {
 
 struct imsm_update_general_migration_checkpoint {
 	enum imsm_update_type type;
-	__u32 curr_migr_unit;
+	__u64 curr_migr_unit;
 };
 
 struct disk_info {
@@ -1229,6 +1231,14 @@ static unsigned long long num_data_stripes(struct imsm_map *map)
 	return join_u32(map->num_data_stripes_lo, map->num_data_stripes_hi);
 }
 
+static unsigned long long vol_curr_migr_unit(struct imsm_dev *dev)
+{
+	if (dev == NULL)
+		return 0;
+
+	return join_u32(dev->vol.curr_migr_unit_lo, dev->vol.curr_migr_unit_hi);
+}
+
 static unsigned long long imsm_dev_size(struct imsm_dev *dev)
 {
 	if (dev == NULL)
@@ -1288,6 +1298,14 @@ static void set_num_data_stripes(struct imsm_map *map, unsigned long long n)
 	split_ull(n, &map->num_data_stripes_lo, &map->num_data_stripes_hi);
 }
 
+static void set_vol_curr_migr_unit(struct imsm_dev *dev, unsigned long long n)
+{
+	if (dev == NULL)
+		return;
+
+	split_ull(n, &dev->vol.curr_migr_unit_lo, &dev->vol.curr_migr_unit_hi);
+}
+
 static void set_imsm_dev_size(struct imsm_dev *dev, unsigned long long n)
 {
 	split_ull(n, &dev->size_low, &dev->size_high);
@@ -1660,8 +1678,7 @@ static void print_imsm_dev(struct intel_super *super,
 		struct imsm_map *map = get_imsm_map(dev, MAP_1);
 
 		printf(" <-- %s", map_state_str[map->map_state]);
-		printf("\n     Checkpoint : %u ",
-			   __le32_to_cpu(dev->vol.curr_migr_unit));
+		printf("\n     Checkpoint : %llu ", vol_curr_migr_unit(dev));
 		if (is_gen_migration(dev) && (slot > 1 || slot < 0))
 			printf("(N/A)");
 		else
@@ -1752,7 +1769,8 @@ void convert_to_4k(struct intel_super *super)
 		struct imsm_map *map = get_imsm_map(dev, MAP_0);
 		/* dev */
 		set_imsm_dev_size(dev, imsm_dev_size(dev)/IMSM_4K_DIV);
-		dev->vol.curr_migr_unit /= IMSM_4K_DIV;
+		set_vol_curr_migr_unit(dev,
+				       vol_curr_migr_unit(dev) / IMSM_4K_DIV);
 
 		/* map0 */
 		set_blocks_per_member(map, blocks_per_member(map)/IMSM_4K_DIV);
@@ -1880,7 +1898,8 @@ void convert_from_4k(struct intel_super *super)
 		struct imsm_map *map = get_imsm_map(dev, MAP_0);
 		/* dev */
 		set_imsm_dev_size(dev, imsm_dev_size(dev)*IMSM_4K_DIV);
-		dev->vol.curr_migr_unit *= IMSM_4K_DIV;
+		set_vol_curr_migr_unit(dev,
+				       vol_curr_migr_unit(dev) * IMSM_4K_DIV);
 
 		/* map0 */
 		set_blocks_per_member(map, blocks_per_member(map)*IMSM_4K_DIV);
@@ -3154,7 +3173,7 @@ static int imsm_create_metadata_checkpoint_update(
 	}
 	(*u)->type = update_general_migration_checkpoint;
 	(*u)->curr_migr_unit = current_migr_unit(super->migr_rec);
-	dprintf("prepared for %u\n", (*u)->curr_migr_unit);
+	dprintf("prepared for %llu\n", (*u)->curr_migr_unit);
 
 	return update_memory_size;
 }
@@ -3446,7 +3465,7 @@ static void getinfo_super_imsm_volume(struct supertype *st, struct mdinfo *info,
 		case MIGR_INIT: {
 			__u64 blocks_per_unit = blocks_per_migr_unit(super,
 								     dev);
-			__u64 units = __le32_to_cpu(dev->vol.curr_migr_unit);
+			__u64 units = vol_curr_migr_unit(dev);
 
 			info->resync_start = blocks_per_unit * units;
 			break;
@@ -4145,7 +4164,7 @@ static void migrate(struct imsm_dev *dev, struct intel_super *super,
 
 	dev->vol.migr_state = 1;
 	set_migr_type(dev, migr_type);
-	dev->vol.curr_migr_unit = 0;
+	set_vol_curr_migr_unit(dev, 0);
 	dest = get_imsm_map(dev, MAP_1);
 
 	/* duplicate and then set the target end state in map[0] */
@@ -4205,7 +4224,7 @@ static void end_migration(struct imsm_dev *dev, struct intel_super *super,
 
 	dev->vol.migr_state = 0;
 	set_migr_type(dev, 0);
-	dev->vol.curr_migr_unit = 0;
+	set_vol_curr_migr_unit(dev, 0);
 	map->map_state = map_state;
 }
 
@@ -5491,7 +5510,7 @@ static int init_super_imsm_volume(struct supertype *st, mdu_array_info_t *info,
 	vol->migr_state = 0;
 	set_migr_type(dev, MIGR_INIT);
 	vol->dirty = !info->state;
-	vol->curr_migr_unit = 0;
+	set_vol_curr_migr_unit(dev, 0);
 	map = get_imsm_map(dev, MAP_0);
 	set_pba_of_lba0(map, super->create_offset);
 	map->blocks_per_strip = __cpu_to_le16(info_to_blocks_per_strip(info));
@@ -6420,7 +6439,7 @@ static int validate_ppl_imsm(struct supertype *st, struct mdinfo *info,
 		   (map->map_state == IMSM_T_STATE_NORMAL &&
 		   !(dev->vol.dirty & RAIDVOL_DIRTY)) ||
 		   (is_rebuilding(dev) &&
-		    dev->vol.curr_migr_unit == 0 &&
+		    vol_curr_migr_unit(dev) == 0 &&
 		    get_imsm_disk_idx(dev, disk->disk.raid_disk, MAP_1) != idx))
 			ret = st->ss->write_init_ppl(st, info, d->fd);
 		else
@@ -7808,7 +7827,7 @@ static void update_recovery_start(struct intel_super *super,
 		return;
 	}
 
-	units = __le32_to_cpu(dev->vol.curr_migr_unit);
+	units = vol_curr_migr_unit(dev);
 	rebuild->recovery_start = units * blocks_per_migr_unit(super, dev);
 }
 
@@ -8355,7 +8374,7 @@ static void imsm_progress_container_reshape(struct intel_super *super)
 		prev_num_members = map->num_members;
 		map->num_members = prev_disks;
 		dev->vol.migr_state = 1;
-		dev->vol.curr_migr_unit = 0;
+		set_vol_curr_migr_unit(dev, 0);
 		set_migr_type(dev, MIGR_GEN_MIGR);
 		for (i = prev_num_members;
 		     i < map->num_members; i++)
@@ -8392,10 +8411,10 @@ static int imsm_set_array_state(struct active_array *a, int consistent)
 		 * We might need to
 		 * - abort the reshape (if last_checkpoint is 0 and action!= reshape)
 		 * - finish the reshape (if last_checkpoint is big and action != reshape)
-		 * - update curr_migr_unit
+		 * - update vol_curr_migr_unit
 		 */
 		if (a->curr_action == reshape) {
-			/* still reshaping, maybe update curr_migr_unit */
+			/* still reshaping, maybe update vol_curr_migr_unit */
 			goto mark_checkpoint;
 		} else {
 			if (a->last_checkpoint == 0 && a->prev_action == reshape) {
@@ -8409,7 +8428,7 @@ static int imsm_set_array_state(struct active_array *a, int consistent)
 						get_imsm_map(dev, MAP_1);
 					dev->vol.migr_state = 0;
 					set_migr_type(dev, 0);
-					dev->vol.curr_migr_unit = 0;
+					set_vol_curr_migr_unit(dev, 0);
 					memcpy(map, map2,
 					       sizeof_imsm_map(map2));
 					super->updates_pending++;
@@ -8485,25 +8504,16 @@ mark_checkpoint:
 	if (is_gen_migration(dev))
 		goto skip_mark_checkpoint;
 
-	/* check if we can update curr_migr_unit from resync_start, recovery_start */
+	/* check if we can update vol_curr_migr_unit from resync_start,
+	 * recovery_start
+	 */
 	blocks_per_unit = blocks_per_migr_unit(super, dev);
 	if (blocks_per_unit) {
-		__u32 units32;
-		__u64 units;
-
-		units = a->last_checkpoint / blocks_per_unit;
-		units32 = units;
-
-		/* check that we did not overflow 32-bits, and that
-		 * curr_migr_unit needs updating
-		 */
-		if (units32 == units &&
-		    units32 != 0 &&
-		    __le32_to_cpu(dev->vol.curr_migr_unit) != units32) {
-			dprintf("imsm: mark checkpoint (%u)\n", units32);
-			dev->vol.curr_migr_unit = __cpu_to_le32(units32);
-			super->updates_pending++;
-		}
+		set_vol_curr_migr_unit(dev,
+				       a->last_checkpoint / blocks_per_unit);
+		dprintf("imsm: mark checkpoint (%llu)\n",
+			vol_curr_migr_unit(dev));
+		super->updates_pending++;
 	}
 
 skip_mark_checkpoint:
@@ -9588,7 +9598,7 @@ static int apply_reshape_container_disks_update(struct imsm_update_reshape *u,
 				id->index);
 			devices_to_reshape--;
 			newdev->vol.migr_state = 1;
-			newdev->vol.curr_migr_unit = 0;
+			set_vol_curr_migr_unit(newdev, 0);
 			set_migr_type(newdev, MIGR_GEN_MIGR);
 			newmap->num_members = u->new_raid_disks;
 			for (i = 0; i < delta_disks; i++) {
@@ -9790,8 +9800,8 @@ static void imsm_process_update(struct supertype *st,
 		/* find device under general migration */
 		for (id = super->devlist ; id; id = id->next) {
 			if (is_gen_migration(id->dev)) {
-				id->dev->vol.curr_migr_unit =
-					__cpu_to_le32(u->curr_migr_unit);
+				set_vol_curr_migr_unit(id->dev,
+						   u->curr_migr_unit);
 				super->updates_pending++;
 			}
 		}
@@ -10959,8 +10969,8 @@ int recover_backup_imsm(struct supertype *st, struct mdinfo *info)
 	char *buf = NULL;
 	int retval = 1;
 	unsigned int sector_size = super->sector_size;
-	unsigned long curr_migr_unit = current_migr_unit(migr_rec);
-	unsigned long num_migr_units = get_num_migr_units(migr_rec);
+	unsigned long long curr_migr_unit = current_migr_unit(migr_rec);
+	unsigned long long num_migr_units = get_num_migr_units(migr_rec);
 	char buffer[20];
 	int skipped_disks = 0;
 
-- 
2.26.2

