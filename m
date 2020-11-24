Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B04FC6379D
	for <linux-raid@archiver.kernel.org>; Tue, 24 Nov 2020 13:15:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E6C1C2073C
	for <linux-raid@archiver.kernel.org>; Tue, 24 Nov 2020 13:15:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387976AbgKXNPp (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 24 Nov 2020 08:15:45 -0500
Received: from mga07.intel.com ([134.134.136.100]:21496 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387805AbgKXNPo (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 24 Nov 2020 08:15:44 -0500
IronPort-SDR: lCVJEHHmJagW0CX6Jnkrs2xbNWVa+tdQPsecUqPkJBi/0B0XemuYBR6TeGdHIXcc8ndFNeO4ou
 jb/wJxpn+X3A==
X-IronPort-AV: E=McAfee;i="6000,8403,9814"; a="236078328"
X-IronPort-AV: E=Sophos;i="5.78,366,1599548400"; 
   d="scan'208";a="236078328"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2020 05:15:43 -0800
IronPort-SDR: bNI//jWUKTHVbTI2M7ZoBqrVxAgr35zeoFu18gu2Y6BQ63r71Bc9kKWC7mzpluVMjFoyOhGn6M
 0P0iShDDvXRA==
X-IronPort-AV: E=Sophos;i="5.78,366,1599548400"; 
   d="scan'208";a="478492761"
Received: from mtkaczyk-devel.igk.intel.com ([10.102.102.23])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2020 05:15:42 -0800
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH] imsm: update num_data_stripes according to dev_size
Date:   Tue, 24 Nov 2020 14:15:15 +0100
Message-Id: <20201124131515.1133-1-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

If array was created in UEFI there is possibility that
member size is not rounded to 1MB. After any size reconfiguration
it will be rounded down to 1MB per each member but the old
component size will remain in metadata.
During reshape old array size is calculated from component size because
dev_size is not a part of map and is bumped to new value quickly.
It may result in size mismatch if array is assembled during reshape.

If difference in calculated size and dev_size is observed try to fix it.
num_data_stripes value can be safety updated to smaller value if array
doesn't occuppy whole reserved component space.

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 super-intel.c | 84 +++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 78 insertions(+), 6 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 3a73d2b..9562064 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -3453,7 +3453,6 @@ static void getinfo_super_imsm_volume(struct supertype *st, struct mdinfo *info,
 			__u64 blocks_per_unit = blocks_per_migr_unit(super,
 								     dev);
 			__u64 units = current_migr_unit(migr_rec);
-			unsigned long long array_blocks;
 			int used_disks;
 
 			if (__le32_to_cpu(migr_rec->ascending_migr) &&
@@ -3472,12 +3471,8 @@ static void getinfo_super_imsm_volume(struct supertype *st, struct mdinfo *info,
 
 			used_disks = imsm_num_data_members(prev_map);
 			if (used_disks > 0) {
-				array_blocks = per_dev_array_size(map) *
+				info->custom_array_size = per_dev_array_size(map) *
 					used_disks;
-				info->custom_array_size =
-					round_size_to_mb(array_blocks,
-							 used_disks);
-
 			}
 		}
 		case MIGR_VERIFY:
@@ -11682,6 +11677,68 @@ int imsm_takeover(struct supertype *st, struct geo_params *geo)
 	return 0;
 }
 
+/* Flush size update if size calculated by num_data_stripes is higher than
+ * imsm_dev_size to eliminate differences during reshape.
+ * Mdmon will recalculate them correctly.
+ * If subarray index is not set then check whole container.
+ * Returns:
+ *	0 - no error occurred
+ *	1 - error detected
+ */
+static int imsm_fix_size_mismatch(struct supertype *st, int subarray_index)
+{
+	struct intel_super *super = st->sb;
+	int tmp = super->current_vol;
+	int ret_val = 1;
+	int i;
+
+	for (i = 0; i < super->anchor->num_raid_devs; i++) {
+		if (subarray_index >= 0 && i != subarray_index)
+			continue;
+		super->current_vol = i;
+		struct imsm_dev *dev = get_imsm_dev(super, super->current_vol);
+		struct imsm_map *map = get_imsm_map(dev, MAP_0);
+		unsigned int disc_count = imsm_num_data_members(map);
+		struct geo_params geo;
+		struct imsm_update_size_change *update;
+		unsigned long long calc_size = per_dev_array_size(map) * disc_count;
+		unsigned long long d_size = imsm_dev_size(dev);
+		int u_size;
+
+		if (calc_size == d_size || dev->vol.migr_type == MIGR_GEN_MIGR)
+			continue;
+
+		/* There is a difference, verify that imsm_dev_size is
+		 * rounded correctly and push update.
+		 */
+		if (d_size != round_size_to_mb(d_size, disc_count)) {
+			dprintf("imsm: Size of volume %d is not rounded correctly\n",
+				 i);
+			goto exit;
+		}
+		memset(&geo, 0, sizeof(struct geo_params));
+		geo.size = d_size;
+		u_size = imsm_create_metadata_update_for_size_change(st, &geo,
+								     &update);
+		if (u_size < 1) {
+			dprintf("imsm: Cannot prepare size change update\n");
+			goto exit;
+		}
+		imsm_update_metadata_locally(st, update, u_size);
+		if (st->update_tail) {
+			append_metadata_update(st, update, u_size);
+			flush_metadata_updates(st);
+			st->update_tail = &st->updates;
+		} else {
+			imsm_sync_metadata(st);
+		}
+	}
+	ret_val = 0;
+exit:
+	super->current_vol = tmp;
+	return ret_val;
+}
+
 static int imsm_reshape_super(struct supertype *st, unsigned long long size,
 			      int level,
 			      int layout, int chunksize, int raid_disks,
@@ -11718,6 +11775,11 @@ static int imsm_reshape_super(struct supertype *st, unsigned long long size,
 			struct imsm_update_reshape *u = NULL;
 			int len;
 
+			if (imsm_fix_size_mismatch(st, -1)) {
+				dprintf("imsm: Cannot fix size mismatch\n");
+				goto exit_imsm_reshape_super;
+			}
+
 			len = imsm_create_metadata_update_for_reshape(
 				st, &geo, old_raid_disks, &u);
 
@@ -12020,6 +12082,7 @@ static int imsm_manage_reshape(
 	unsigned long long start_buf_shift; /* [bytes] */
 	int degraded = 0;
 	int source_layout = 0;
+	int subarray_index = -1;
 
 	if (!sra)
 		return ret_val;
@@ -12033,6 +12096,7 @@ static int imsm_manage_reshape(
 		    dv->dev->vol.migr_state == 1) {
 			dev = dv->dev;
 			migr_vol_qan++;
+			subarray_index = dv->index;
 		}
 	}
 	/* Only one volume can migrate at the same time */
@@ -12217,6 +12281,14 @@ static int imsm_manage_reshape(
 
 	/* return '1' if done */
 	ret_val = 1;
+
+	/* After the reshape eliminate size mismatch in metadata.
+	 * Don't update md/component_size here, volume hasn't
+	 * to take whole space. It is allowed by kernel.
+	 * md/component_size will be set propoperly after next assembly.
+	 */
+	imsm_fix_size_mismatch(st, subarray_index);
+
 abort:
 	free(buf);
 	/* See Grow.c: abort_reshape() for further explanation */
-- 
2.25.0

