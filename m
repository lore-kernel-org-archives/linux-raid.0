Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67D7FC433EF
	for <linux-raid@archiver.kernel.org>; Tue, 19 Apr 2022 14:37:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353494AbiDSOkP (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 19 Apr 2022 10:40:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353499AbiDSOkN (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 19 Apr 2022 10:40:13 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C6D021819
        for <linux-raid@vger.kernel.org>; Tue, 19 Apr 2022 07:37:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650379050; x=1681915050;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aEOoUn+5J9D/5gjOSGs82VoR/GnC3wA7Trrx87vxv6o=;
  b=OeaxcYxPb4bvaernfP14mgLxsexX8DqkGf9jdjX4cqXtYekQIvRxHLfw
   XNOdu1sd/3irpueW/3+AOOGU3cHJoWMRK2g3PAwXmpT+obPe3uYpqU13n
   1VoWvbtjsrCMSMIhzK2/ApJI0rPlztg0NqyvLucpyxtTjHZubFJMPm96y
   7FpsO+yLUdT5JiBEXdLajO6DC5qN6Q4xMxkeEdkSHfY38W+89nMBIu8WQ
   1VAQSz21DJPHP8UW9o5f7nsCCMVSJESNJjozbUVRJd4tveOokwGidiPBt
   vk9p4/UP5RxalkfLcAmZNN13qeAoJn0yPOdr7/AwAiCuUVKW2qjKMpb2C
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10322"; a="263952005"
X-IronPort-AV: E=Sophos;i="5.90,272,1643702400"; 
   d="scan'208";a="263952005"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2022 07:37:30 -0700
X-IronPort-AV: E=Sophos;i="5.90,272,1643702400"; 
   d="scan'208";a="576128946"
Received: from mtkaczyk-devel.igk.intel.com ([10.102.102.23])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2022 07:37:29 -0700
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     jes@trained-monkey.org, colyli@suse.de
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH 1/3] imsm: introduce get_disk_slot_in_dev()
Date:   Tue, 19 Apr 2022 16:37:12 +0200
Message-Id: <20220419143714.16942-2-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220419143714.16942-1-mariusz.tkaczyk@linux.intel.com>
References: <20220419143714.16942-1-mariusz.tkaczyk@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

The routine was added to remove unnecessary get_imsm_dev() and
get_imsm_map() calls, used only to determine disk slot.

Additionally, enum for IMSM return statues was added for further usage.

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 super-intel.c | 46 +++++++++++++++++++++++++++++++++++-----------
 1 file changed, 35 insertions(+), 11 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index d5fad102..c16251c8 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -366,6 +366,17 @@ struct migr_record {
 };
 ASSERT_SIZE(migr_record, 128)
 
+/**
+ * enum imsm_status - internal IMSM return values representation.
+ * @STATUS_OK: function succeeded.
+ * @STATUS_ERROR: General error ocurred (not specified).
+ */
+enum {
+	IMSM_STATUS_OK = 0,
+	IMSM_STATUS_ERROR = -1,
+
+} imsm_status;
+
 struct md_list {
 	/* usage marker:
 	 *  1: load metadata
@@ -1151,7 +1162,7 @@ static void set_imsm_ord_tbl_ent(struct imsm_map *map, int slot, __u32 ord)
 	map->disk_ord_tbl[slot] = __cpu_to_le32(ord);
 }
 
-static int get_imsm_disk_slot(struct imsm_map *map, unsigned idx)
+static int get_imsm_disk_slot(struct imsm_map *map, const unsigned int idx)
 {
 	int slot;
 	__u32 ord;
@@ -1162,7 +1173,7 @@ static int get_imsm_disk_slot(struct imsm_map *map, unsigned idx)
 			return slot;
 	}
 
-	return -1;
+	return IMSM_STATUS_ERROR;
 }
 
 static int get_imsm_raid_level(struct imsm_map *map)
@@ -1177,6 +1188,23 @@ static int get_imsm_raid_level(struct imsm_map *map)
 	return map->raid_level;
 }
 
+/**
+ * get_disk_slot_in_dev() - retrieve disk slot from &imsm_dev.
+ * @super: &intel_super pointer, not NULL.
+ * @dev_idx: imsm device index.
+ * @idx: disk index.
+ *
+ * Return: Slot on success, IMSM_STATUS_ERROR otherwise.
+ */
+static int get_disk_slot_in_dev(struct intel_super *super, const __u8 dev_idx,
+				const unsigned int idx)
+{
+	struct imsm_dev *dev = get_imsm_dev(super, dev_idx);
+	struct imsm_map *map = get_imsm_map(dev, MAP_0);
+
+	return get_imsm_disk_slot(map, idx);
+}
+
 static int cmp_extent(const void *av, const void *bv)
 {
 	const struct extent *a = av;
@@ -1193,13 +1221,9 @@ static int count_memberships(struct dl *dl, struct intel_super *super)
 	int memberships = 0;
 	int i;
 
-	for (i = 0; i < super->anchor->num_raid_devs; i++) {
-		struct imsm_dev *dev = get_imsm_dev(super, i);
-		struct imsm_map *map = get_imsm_map(dev, MAP_0);
-
-		if (get_imsm_disk_slot(map, dl->index) >= 0)
+	for (i = 0; i < super->anchor->num_raid_devs; i++)
+		if (get_disk_slot_in_dev(super, i, dl->index) >= 0)
 			memberships++;
-	}
 
 	return memberships;
 }
@@ -1909,6 +1933,7 @@ void examine_migr_rec_imsm(struct intel_super *super)
 
 		/* first map under migration */
 		map = get_imsm_map(dev, MAP_0);
+
 		if (map)
 			slot = get_imsm_disk_slot(map, super->disks->index);
 		if (map == NULL || slot > 1 || slot < 0) {
@@ -9629,10 +9654,9 @@ static int apply_update_activate_spare(struct imsm_update_activate_spare *u,
 		/* count arrays using the victim in the metadata */
 		found = 0;
 		for (a = active_array; a ; a = a->next) {
-			dev = get_imsm_dev(super, a->info.container_member);
-			map = get_imsm_map(dev, MAP_0);
+			int dev_idx = a->info.container_member;
 
-			if (get_imsm_disk_slot(map, victim) >= 0)
+			if (get_disk_slot_in_dev(super, dev_idx, victim) >= 0)
 				found++;
 		}
 
-- 
2.26.2

