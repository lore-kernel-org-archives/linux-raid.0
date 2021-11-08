Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D097C433EF
	for <linux-raid@archiver.kernel.org>; Mon,  8 Nov 2021 11:53:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 39C9A6124D
	for <linux-raid@archiver.kernel.org>; Mon,  8 Nov 2021 11:53:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239343AbhKHL4B (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 8 Nov 2021 06:56:01 -0500
Received: from mga12.intel.com ([192.55.52.136]:21164 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231401AbhKHL4B (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 8 Nov 2021 06:56:01 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10161"; a="212254586"
X-IronPort-AV: E=Sophos;i="5.87,218,1631602800"; 
   d="scan'208";a="212254586"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2021 03:53:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,218,1631602800"; 
   d="scan'208";a="451445181"
Received: from unknown (HELO dev-ppiatko.ger.corp.intel.com) ([10.102.95.202])
  by orsmga006.jf.intel.com with ESMTP; 08 Nov 2021 03:53:15 -0800
From:   Pawel Piatkowski <pawel.piatkowski@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org
Subject: [PATCH] imsm: assert if there is migration but prev_map doesn't exist
Date:   Mon,  8 Nov 2021 12:53:12 +0100
Message-Id: <20211108115312.5673-1-pawel.piatkowski@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Verify that prev_map in not null during volume migration.
Practically this case is not possible, device prev_map is being
added if it is in the middle of migration.
Add verification to silence static code analyze errors.

Change error handling for function is_gen_migration() (as well as
values compared with return value from this function) to use boolean
types provided by stdbool.h.

Signed-off-by: Pawel Piatkowski <pawel.piatkowski@intel.com>
---
 super-intel.c | 29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 28472a1a..bf13f888 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -1658,7 +1658,7 @@ int get_spare_criteria_imsm(struct supertype *st, struct spare_criteria *c)
 	return 0;
 }
 
-static int is_gen_migration(struct imsm_dev *dev);
+static bool is_gen_migration(struct imsm_dev *dev);
 
 #define IMSM_4K_DIV 8
 
@@ -1902,7 +1902,7 @@ void examine_migr_rec_imsm(struct intel_super *super)
 		struct imsm_map *map;
 		int slot = -1;
 
-		if (is_gen_migration(dev) == 0)
+		if (is_gen_migration(dev) == false)
 				continue;
 
 		printf("\nMigration Record Information:");
@@ -3461,6 +3461,12 @@ static void getinfo_super_imsm_volume(struct supertype *st, struct mdinfo *info,
 	info->recovery_blocked = imsm_reshape_blocks_arrays_changes(st->sb);
 
 	if (is_gen_migration(dev)) {
+		/*
+		 * device prev_map should be added if it is in the middle
+		 * of migration
+		 */
+		assert(prev_map);
+
 		info->reshape_active = 1;
 		info->new_level = get_imsm_raid_level(map);
 		info->new_layout = imsm_level_to_layout(info->new_level);
@@ -4255,7 +4261,7 @@ static void end_migration(struct imsm_dev *dev, struct intel_super *super,
 	 *
 	 * FIXME add support for raid-level-migration
 	 */
-	if (map_state != map->map_state && (is_gen_migration(dev) == 0) &&
+	if (map_state != map->map_state && (is_gen_migration(dev) == false) &&
 	    prev->map_state != IMSM_T_STATE_UNINITIALIZED) {
 		/* when final map state is other than expected
 		 * merge maps (not for migration)
@@ -7862,18 +7868,13 @@ static int update_subarray_imsm(struct supertype *st, char *subarray,
 	return 0;
 }
 
-static int is_gen_migration(struct imsm_dev *dev)
+static bool is_gen_migration(struct imsm_dev *dev)
 {
-	if (dev == NULL)
-		return 0;
-
-	if (!dev->vol.migr_state)
-		return 0;
-
-	if (migr_type(dev) == MIGR_GEN_MIGR)
-		return 1;
+	if (dev && dev->vol.migr_state &&
+	    migr_type(dev) == MIGR_GEN_MIGR)
+		return true;
 
-	return 0;
+	return false;
 }
 
 static int is_rebuilding(struct imsm_dev *dev)
@@ -8377,7 +8378,7 @@ static void handle_missing(struct intel_super *super, struct imsm_dev *dev)
 	dprintf("imsm: mark missing\n");
 	/* end process for initialization and rebuild only
 	 */
-	if (is_gen_migration(dev) == 0) {
+	if (is_gen_migration(dev) == false) {
 		int failed = imsm_count_failed(super, dev, MAP_0);
 
 		if (failed) {
-- 
2.26.2

