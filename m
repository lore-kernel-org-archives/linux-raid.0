Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25C18CCA479
	for <linux-raid@archiver.kernel.org>; Mon, 20 Jun 2022 16:11:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241509AbiFTQLh (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 20 Jun 2022 12:11:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbiFTQLf (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 20 Jun 2022 12:11:35 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E5D1205F0
        for <linux-raid@vger.kernel.org>; Mon, 20 Jun 2022 09:11:34 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 4DD8E21B6D;
        Mon, 20 Jun 2022 16:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1655741493; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7eAXv1MEjwHmC+Wgr1SKIJFJ0RUNCpXLg3uEwDUBl+s=;
        b=epwuvhqAa/36DU/TKSnVeyuoDyJQpr3BxKfFJBOHiES49zdZSKbSzOIU5HsLWXmBOsKkAp
        2BVjfG76wEV1Cajm2BovKKI/LiQjSwZ2jXwjFPUqgLVnVAUxAGs9rIWX/s4LsLLb4Jvb4J
        XDR1pQZHrLjkOxsfsR6uicaM5+6EGmk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1655741493;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7eAXv1MEjwHmC+Wgr1SKIJFJ0RUNCpXLg3uEwDUBl+s=;
        b=ImKVq7wP/WXH6l9LigL5l54QVFujbdZX0Ek3YDaQh1hFTJnFtgQWgcIFvVFupQJ8IeI9de
        2wI4FMgpPhdzhaBg==
Received: from localhost.localdomain (unknown [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id 39D5B2C141;
        Mon, 20 Jun 2022 16:11:30 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Coly Li <colyli@suse.de>
Subject: [PATCH 4/6] imsm: introduce get_disk_slot_in_dev()
Date:   Tue, 21 Jun 2022 00:10:41 +0800
Message-Id: <20220620161043.3661-5-colyli@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220620161043.3661-1-colyli@suse.de>
References: <20220620161043.3661-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>

The routine was added to remove unnecessary get_imsm_dev() and
get_imsm_map() calls, used only to determine disk slot.

Additionally, enum for IMSM return statues was added for further usage.

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Acked-by: Coly Li <colyli@suse.de>
---
 super-intel.c | 47 ++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 36 insertions(+), 11 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 3788feb9..cd1f1e3d 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -366,6 +366,18 @@ struct migr_record {
 };
 ASSERT_SIZE(migr_record, 128)
 
+/**
+ * enum imsm_status - internal IMSM return values representation.
+ * @STATUS_OK: function succeeded.
+ * @STATUS_ERROR: General error ocurred (not specified).
+ *
+ * Typedefed to imsm_status_t.
+ */
+typedef enum imsm_status {
+	IMSM_STATUS_ERROR = -1,
+	IMSM_STATUS_OK = 0,
+} imsm_status_t;
+
 struct md_list {
 	/* usage marker:
 	 *  1: load metadata
@@ -1183,7 +1195,7 @@ static void set_imsm_ord_tbl_ent(struct imsm_map *map, int slot, __u32 ord)
 	map->disk_ord_tbl[slot] = __cpu_to_le32(ord);
 }
 
-static int get_imsm_disk_slot(struct imsm_map *map, unsigned idx)
+static int get_imsm_disk_slot(struct imsm_map *map, const unsigned int idx)
 {
 	int slot;
 	__u32 ord;
@@ -1194,7 +1206,7 @@ static int get_imsm_disk_slot(struct imsm_map *map, unsigned idx)
 			return slot;
 	}
 
-	return -1;
+	return IMSM_STATUS_ERROR;
 }
 
 static int get_imsm_raid_level(struct imsm_map *map)
@@ -1209,6 +1221,23 @@ static int get_imsm_raid_level(struct imsm_map *map)
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
@@ -1225,13 +1254,9 @@ static int count_memberships(struct dl *dl, struct intel_super *super)
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
@@ -1941,6 +1966,7 @@ void examine_migr_rec_imsm(struct intel_super *super)
 
 		/* first map under migration */
 		map = get_imsm_map(dev, MAP_0);
+
 		if (map)
 			slot = get_imsm_disk_slot(map, super->disks->index);
 		if (map == NULL || slot > 1 || slot < 0) {
@@ -9655,10 +9681,9 @@ static int apply_update_activate_spare(struct imsm_update_activate_spare *u,
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
2.35.3

