Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0C81C433F5
	for <linux-raid@archiver.kernel.org>; Fri,  8 Apr 2022 11:59:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234575AbiDHMB1 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 8 Apr 2022 08:01:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232279AbiDHMB0 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 8 Apr 2022 08:01:26 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C981888D3
        for <linux-raid@vger.kernel.org>; Fri,  8 Apr 2022 04:59:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649419162; x=1680955162;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=NzGvSXsvi7wU6BNuCndvdjiS09pVW6hjgrytE1gAQ4w=;
  b=Sn1+u2phd7AMnNyIl+DNCAnObeUaBtQyRfDzsqGE3kb84alZvK1AjJ2L
   G+qz25qNqHKqEv1hKnum5tVBicOlg9v+R3lVv4tUZZtQMltrS7i9ITRSr
   0Wgy9RlDECnTOp4eXQoNRkpYFJOvhDwgN6Z0k09uICw9vhSab2YXdS8ui
   fmCtLBWxgibfjo7VUdS9iEg64rmu9hgXsk1xS9e8tq+UvUa3D879j2AsV
   QoEN2W8Q38TcC2N6bT4IyvhxNTotYvgMuasMqHEzRySVK48QKRy4+VtmH
   Tq3aw+kUQdI3vWXdVIFpBZPXgnpzVJHZ1xAcCXqlQyIpHz93+yjzsRaMd
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10310"; a="261752578"
X-IronPort-AV: E=Sophos;i="5.90,245,1643702400"; 
   d="scan'208";a="261752578"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2022 04:59:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,245,1643702400"; 
   d="scan'208";a="794939320"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.102.57])
  by fmsmga006.fm.intel.com with ESMTP; 08 Apr 2022 04:59:20 -0700
From:   Mateusz Grzonka <mateusz.grzonka@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org
Subject: [PATCH resend] imsm: Remove possibility for get_imsm_dev to return NULL
Date:   Fri,  8 Apr 2022 13:45:03 +0200
Message-Id: <20220408114503.32377-1-mateusz.grzonka@intel.com>
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
 super-intel.c | 153 +++++++++++++++++++++++++-------------------------
 1 file changed, 78 insertions(+), 75 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 28472a1a..b7441716 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -851,6 +851,21 @@ static struct disk_info *get_disk_info(struct imsm_update_create_array *update)
 	return inf;
 }
 
+/**
+ * __get_imsm_dev() - Get device with index from imsm_super.
+ * @mpb: &imsm_super pointer, not NULL.
+ * @index: Device index.
+ *
+ * Function works as non-NULL, aborting in such a case,
+ * when NULL would be returned.
+ *
+ * Device index should be in range 0 up to num_raid_devs.
+ * Function assumes the index was already verified.
+ * Index must be valid, otherwise abort() is called.
+ *
+ * Return: Pointer to corresponding imsm_dev.
+ *
+ */
 static struct imsm_dev *__get_imsm_dev(struct imsm_super *mpb, __u8 index)
 {
 	int offset;
@@ -858,30 +873,47 @@ static struct imsm_dev *__get_imsm_dev(struct imsm_super *mpb, __u8 index)
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
+	pr_err("cannot find imsm_dev with index %u in imsm_super\n", index);
+	abort();
 }
 
+/**
+ * get_imsm_dev() - Get device with index from intel_super.
+ * @super: &intel_super pointer, not NULL.
+ * @index: Device index.
+ *
+ * Function works as non-NULL, aborting in such a case,
+ * when NULL would be returned.
+ *
+ * Device index should be in range 0 up to num_raid_devs.
+ * Function assumes the index was already verified.
+ * Index must be valid, otherwise abort() is called.
+ *
+ * Return: Pointer to corresponding imsm_dev.
+ *
+ */
 static struct imsm_dev *get_imsm_dev(struct intel_super *super, __u8 index)
 {
 	struct intel_dev *dv;
 
 	if (index >= super->anchor->num_raid_devs)
-		return NULL;
+		goto error;
+
 	for (dv = super->devlist; dv; dv = dv->next)
 		if (dv->index == index)
 			return dv->dev;
-	return NULL;
+error:
+	pr_err("cannot find imsm_dev with index %u in intel_super\n", index);
+	abort();
 }
 
 static inline unsigned long long __le48_to_cpu(const struct bbm_log_block_addr
@@ -4358,8 +4390,7 @@ int check_mpb_migr_compatibility(struct intel_super *super)
 	for (i = 0; i < super->anchor->num_raid_devs; i++) {
 		struct imsm_dev *dev_iter = __get_imsm_dev(super->anchor, i);
 
-		if (dev_iter &&
-		    dev_iter->vol.migr_state == 1 &&
+		if (dev_iter->vol.migr_state == 1 &&
 		    dev_iter->vol.migr_type == MIGR_GEN_MIGR) {
 			/* This device is migrating */
 			map0 = get_imsm_map(dev_iter, MAP_0);
@@ -4508,8 +4539,6 @@ static void clear_hi(struct intel_super *super)
 	}
 	for (i = 0; i < mpb->num_raid_devs; ++i) {
 		struct imsm_dev *dev = get_imsm_dev(super, i);
-		if (!dev)
-			return;
 		for (n = 0; n < 2; ++n) {
 			struct imsm_map *map = get_imsm_map(dev, n);
 			if (!map)
@@ -5830,7 +5859,7 @@ static int add_to_super_imsm_volume(struct supertype *st, mdu_disk_info_t *dk,
 		struct imsm_dev *_dev = __get_imsm_dev(mpb, 0);
 
 		_disk = __get_imsm_disk(mpb, dl->index);
-		if (!_dev || !_disk) {
+		if (!_disk) {
 			pr_err("BUG mpb setup error\n");
 			return 1;
 		}
@@ -6165,10 +6194,10 @@ static int write_super_imsm(struct supertype *st, int doclose)
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
@@ -9032,29 +9061,26 @@ static int imsm_rebuild_allowed(struct supertype *cont, int dev_idx, int failed)
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
@@ -10088,7 +10114,6 @@ static void imsm_process_update(struct supertype *st,
 		int victim = u->dev_idx;
 		struct active_array *a;
 		struct intel_dev **dp;
-		struct imsm_dev *dev;
 
 		/* sanity check that we are not affecting the uuid of
 		 * active arrays, or deleting an active array
@@ -10104,8 +10129,7 @@ static void imsm_process_update(struct supertype *st,
 		 * is active in the container, so checking
 		 * mpb->num_raid_devs is just extra paranoia
 		 */
-		dev = get_imsm_dev(super, victim);
-		if (a || !dev || mpb->num_raid_devs == 1) {
+		if (a || mpb->num_raid_devs == 1 || victim >= super->anchor->num_raid_devs) {
 			dprintf("failed to delete subarray-%d\n", victim);
 			break;
 		}
@@ -10139,7 +10163,7 @@ static void imsm_process_update(struct supertype *st,
 			if (a->info.container_member == target)
 				break;
 		dev = get_imsm_dev(super, u->dev_idx);
-		if (a || !dev || !check_name(super, name, 1)) {
+		if (a || !check_name(super, name, 1)) {
 			dprintf("failed to rename subarray-%d\n", target);
 			break;
 		}
@@ -10168,10 +10192,6 @@ static void imsm_process_update(struct supertype *st,
 		struct imsm_update_rwh_policy *u = (void *)update->buf;
 		int target = u->dev_idx;
 		struct imsm_dev *dev = get_imsm_dev(super, target);
-		if (!dev) {
-			dprintf("could not find subarray-%d\n", target);
-			break;
-		}
 
 		if (dev->rwh_policy != u->new_policy) {
 			dev->rwh_policy = u->new_policy;
@@ -11396,8 +11416,10 @@ static int imsm_create_metadata_update_for_migration(
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
@@ -11414,23 +11436,15 @@ static int imsm_create_metadata_update_for_migration(
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
 
@@ -12517,9 +12531,6 @@ static int validate_internal_bitmap_imsm(struct supertype *st)
 	unsigned long long offset;
 	struct dl *d;
 
-	if (!dev)
-		return -1;
-
 	if (dev->rwh_policy != RWH_BITMAP)
 		return 0;
 
@@ -12565,16 +12576,8 @@ static int add_internal_bitmap_imsm(struct supertype *st, int *chunkp,
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

