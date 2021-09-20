Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A513C433F5
	for <linux-raid@archiver.kernel.org>; Mon, 20 Sep 2021 11:22:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3AC1360F6B
	for <linux-raid@archiver.kernel.org>; Mon, 20 Sep 2021 11:22:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234985AbhITLX0 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 20 Sep 2021 07:23:26 -0400
Received: from mga12.intel.com ([192.55.52.136]:54142 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230160AbhITLXZ (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 20 Sep 2021 07:23:25 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10112"; a="202608662"
X-IronPort-AV: E=Sophos;i="5.85,308,1624345200"; 
   d="scan'208";a="202608662"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Sep 2021 04:21:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,308,1624345200"; 
   d="scan'208";a="548672444"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.102.57])
  by FMSMGA003.fm.intel.com with ESMTP; 20 Sep 2021 04:21:56 -0700
From:   Mateusz Grzonka <mateusz.grzonka@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org
Subject: [PATCH] imsm: Remove possibility for get_imsm_dev to return NULL
Date:   Mon, 20 Sep 2021 13:10:32 +0200
Message-Id: <20210920111032.19195-1-mateusz.grzonka@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Returning NULL from get_imsm_dev or __get_imsm_dev will cause segfault.
Guarantee that it never happens.

Signed-off-by: Mateusz Grzonka <mateusz.grzonka@intel.com>
---
 super-intel.c | 122 +++++++++++++++++++-------------------------------
 1 file changed, 46 insertions(+), 76 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 83ddc000..2c3df58a 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -858,30 +858,29 @@ static struct imsm_dev *__get_imsm_dev(struct imsm_super *mpb, __u8 index)
 	void *_mpb = mpb;
 
 	if (index >= mpb->num_raid_devs)
-		return NULL;
+		goto error;
 
 	/* devices start after all disks */
 	offset = ((void *) &mpb->disk[mpb->num_disks]) - _mpb;
 
-	for (i = 0; i <= index; i++)
+	for (i = 0; i <= index; i++, offset += sizeof_imsm_dev(_mpb + offset, 0))
 		if (i == index)
 			return _mpb + offset;
-		else
-			offset += sizeof_imsm_dev(_mpb + offset, 0);
-
-	return NULL;
+error:
+	pr_err("matching failed, index: %u\n", index);
+	abort();
 }
 
 static struct imsm_dev *get_imsm_dev(struct intel_super *super, __u8 index)
 {
 	struct intel_dev *dv;
 
-	if (index >= super->anchor->num_raid_devs)
-		return NULL;
+	assert(index < super->anchor->num_raid_devs);
 	for (dv = super->devlist; dv; dv = dv->next)
 		if (dv->index == index)
 			return dv->dev;
-	return NULL;
+	pr_err("matching failed, index: %u\n", index);
+	abort();
 }
 
 static inline unsigned long long __le48_to_cpu(const struct bbm_log_block_addr
@@ -4358,8 +4357,7 @@ int check_mpb_migr_compatibility(struct intel_super *super)
 	for (i = 0; i < super->anchor->num_raid_devs; i++) {
 		struct imsm_dev *dev_iter = __get_imsm_dev(super->anchor, i);
 
-		if (dev_iter &&
-		    dev_iter->vol.migr_state == 1 &&
+		if (dev_iter->vol.migr_state == 1 &&
 		    dev_iter->vol.migr_type == MIGR_GEN_MIGR) {
 			/* This device is migrating */
 			map0 = get_imsm_map(dev_iter, MAP_0);
@@ -4508,8 +4506,6 @@ static void clear_hi(struct intel_super *super)
 	}
 	for (i = 0; i < mpb->num_raid_devs; ++i) {
 		struct imsm_dev *dev = get_imsm_dev(super, i);
-		if (!dev)
-			return;
 		for (n = 0; n < 2; ++n) {
 			struct imsm_map *map = get_imsm_map(dev, n);
 			if (!map)
@@ -5831,7 +5827,7 @@ static int add_to_super_imsm_volume(struct supertype *st, mdu_disk_info_t *dk,
 		struct imsm_dev *_dev = __get_imsm_dev(mpb, 0);
 
 		_disk = __get_imsm_disk(mpb, dl->index);
-		if (!_dev || !_disk) {
+		if (!_disk) {
 			pr_err("BUG mpb setup error\n");
 			return 1;
 		}
@@ -6168,10 +6164,10 @@ static int write_super_imsm(struct supertype *st, int doclose)
 	for (i = 0; i < mpb->num_raid_devs; i++) {
 		struct imsm_dev *dev = __get_imsm_dev(mpb, i);
 		struct imsm_dev *dev2 = get_imsm_dev(super, i);
-		if (dev && dev2) {
-			imsm_copy_dev(dev, dev2);
-			mpb_size += sizeof_imsm_dev(dev, 0);
-		}
+
+		imsm_copy_dev(dev, dev2);
+		mpb_size += sizeof_imsm_dev(dev, 0);
+
 		if (is_gen_migration(dev2))
 			clear_migration_record = 0;
 	}
@@ -9040,29 +9036,26 @@ static int imsm_rebuild_allowed(struct supertype *cont, int dev_idx, int failed)
 	__u8 state;
 
 	dev2 = get_imsm_dev(cont->sb, dev_idx);
-	if (dev2) {
-		state = imsm_check_degraded(cont->sb, dev2, failed, MAP_0);
-		if (state == IMSM_T_STATE_FAILED) {
-			map = get_imsm_map(dev2, MAP_0);
-			if (!map)
-				return 1;
-			for (slot = 0; slot < map->num_members; slot++) {
-				/*
-				 * Check if failed disks are deleted from intel
-				 * disk list or are marked to be deleted
-				 */
-				idx = get_imsm_disk_idx(dev2, slot, MAP_X);
-				idisk = get_imsm_dl_disk(cont->sb, idx);
-				/*
-				 * Do not rebuild the array if failed disks
-				 * from failed sub-array are not removed from
-				 * container.
-				 */
-				if (idisk &&
-				    is_failed(&idisk->disk) &&
-				    (idisk->action != DISK_REMOVE))
-					return 0;
-			}
+
+	state = imsm_check_degraded(cont->sb, dev2, failed, MAP_0);
+	if (state == IMSM_T_STATE_FAILED) {
+		map = get_imsm_map(dev2, MAP_0);
+		for (slot = 0; slot < map->num_members; slot++) {
+			/*
+			 * Check if failed disks are deleted from intel
+			 * disk list or are marked to be deleted
+			 */
+			idx = get_imsm_disk_idx(dev2, slot, MAP_X);
+			idisk = get_imsm_dl_disk(cont->sb, idx);
+			/*
+			 * Do not rebuild the array if failed disks
+			 * from failed sub-array are not removed from
+			 * container.
+			 */
+			if (idisk &&
+			    is_failed(&idisk->disk) &&
+			    (idisk->action != DISK_REMOVE))
+				return 0;
 		}
 	}
 	return 1;
@@ -10094,7 +10087,6 @@ static void imsm_process_update(struct supertype *st,
 		int victim = u->dev_idx;
 		struct active_array *a;
 		struct intel_dev **dp;
-		struct imsm_dev *dev;
 
 		/* sanity check that we are not affecting the uuid of
 		 * active arrays, or deleting an active array
@@ -10110,8 +10102,7 @@ static void imsm_process_update(struct supertype *st,
 		 * is active in the container, so checking
 		 * mpb->num_raid_devs is just extra paranoia
 		 */
-		dev = get_imsm_dev(super, victim);
-		if (a || !dev || mpb->num_raid_devs == 1) {
+		if (a || mpb->num_raid_devs == 1 || victim >= super->anchor->num_raid_devs) {
 			dprintf("failed to delete subarray-%d\n", victim);
 			break;
 		}
@@ -10145,7 +10136,7 @@ static void imsm_process_update(struct supertype *st,
 			if (a->info.container_member == target)
 				break;
 		dev = get_imsm_dev(super, u->dev_idx);
-		if (a || !dev || !check_name(super, name, 1)) {
+		if (a || !check_name(super, name, 1)) {
 			dprintf("failed to rename subarray-%d\n", target);
 			break;
 		}
@@ -10174,10 +10165,6 @@ static void imsm_process_update(struct supertype *st,
 		struct imsm_update_rwh_policy *u = (void *)update->buf;
 		int target = u->dev_idx;
 		struct imsm_dev *dev = get_imsm_dev(super, target);
-		if (!dev) {
-			dprintf("could not find subarray-%d\n", target);
-			break;
-		}
 
 		if (dev->rwh_policy != u->new_policy) {
 			dev->rwh_policy = u->new_policy;
@@ -11411,8 +11398,10 @@ static int imsm_create_metadata_update_for_migration(
 {
 	struct intel_super *super = st->sb;
 	int update_memory_size;
+	int current_chunk_size;
 	struct imsm_update_reshape_migration *u;
-	struct imsm_dev *dev;
+	struct imsm_dev *dev = get_imsm_dev(super, super->current_vol);
+	struct imsm_map *map = get_imsm_map(dev, MAP_0);
 	int previous_level = -1;
 
 	dprintf("(enter) New Level = %i\n", geo->level);
@@ -11429,23 +11418,15 @@ static int imsm_create_metadata_update_for_migration(
 	u->new_disks[0] = -1;
 	u->new_chunksize = -1;
 
-	dev = get_imsm_dev(super, u->subdev);
-	if (dev) {
-		struct imsm_map *map;
+	current_chunk_size = __le16_to_cpu(map->blocks_per_strip) / 2;
 
-		map = get_imsm_map(dev, MAP_0);
-		if (map) {
-			int current_chunk_size =
-				__le16_to_cpu(map->blocks_per_strip) / 2;
-
-			if (geo->chunksize != current_chunk_size) {
-				u->new_chunksize = geo->chunksize / 1024;
-				dprintf("imsm: chunk size change from %i to %i\n",
-					current_chunk_size, u->new_chunksize);
-			}
-			previous_level = map->raid_level;
-		}
+	if (geo->chunksize != current_chunk_size) {
+		u->new_chunksize = geo->chunksize / 1024;
+		dprintf("imsm: chunk size change from %i to %i\n",
+			current_chunk_size, u->new_chunksize);
 	}
+	previous_level = map->raid_level;
+
 	if (geo->level == 5 && previous_level == 0) {
 		struct mdinfo *spares = NULL;
 
@@ -12534,9 +12515,6 @@ static int validate_internal_bitmap_imsm(struct supertype *st)
 	unsigned long long offset;
 	struct dl *d;
 
-	if (!dev)
-		return -1;
-
 	if (dev->rwh_policy != RWH_BITMAP)
 		return 0;
 
@@ -12582,16 +12560,8 @@ static int add_internal_bitmap_imsm(struct supertype *st, int *chunkp,
 		return -1;
 
 	dev = get_imsm_dev(super, vol_idx);
-
-	if (!dev) {
-		dprintf("cannot find the device for volume index %d\n",
-			vol_idx);
-		return -1;
-	}
 	dev->rwh_policy = RWH_BITMAP;
-
 	*chunkp = calculate_bitmap_chunksize(st, dev);
-
 	return 0;
 }
 
-- 
2.26.2

