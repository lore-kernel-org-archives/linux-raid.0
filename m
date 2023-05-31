Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5D42C7EE31
	for <linux-raid@archiver.kernel.org>; Wed, 31 May 2023 15:22:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234018AbjEaPWF (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 31 May 2023 11:22:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234474AbjEaPVh (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 31 May 2023 11:21:37 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33A6212B
        for <linux-raid@vger.kernel.org>; Wed, 31 May 2023 08:21:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685546495; x=1717082495;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3/S9y36/IQz90GK9LH2QMkB8aGYlcEnY/oABEiV+WVY=;
  b=DWNcCjxMkC5aMiEX7IQmEel6lpGrjsnRWftrVWZIUp+Kybkf9MyDN2SE
   NjW4mhfJYSRScM2VI2mHLBLZ7W/ypS0gpJkEXO3rv2gs3cU+Cf35Hsr1A
   RbZStXCWHOlNpB4M3Ceeu0enpU7Nr2CxEf7p707vlA8spl5FetHO/MLpt
   mMZO78s3L23JPjR/1astbeeqwMnvkj8nFBtuWKMiP9BvrJTj9hvMwGzxV
   kxWZ63qnfn9Kpj6MJDrfyPL2Om/vksqQMEMfKoJTywJ6fwZVG5Cznnehz
   gGFdTkUNJNXF6HxYecvLXA09itpjl65g8BHk7WXkIVzgOls1mSVj7jy/O
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10727"; a="339864926"
X-IronPort-AV: E=Sophos;i="6.00,207,1681196400"; 
   d="scan'208";a="339864926"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2023 08:21:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10727"; a="796747342"
X-IronPort-AV: E=Sophos;i="6.00,207,1681196400"; 
   d="scan'208";a="796747342"
Received: from mtkaczyk-devel.igk.intel.com ([10.102.105.40])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2023 08:21:33 -0700
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org, colyli@suse.de
Subject: [PATCH 4/6] imsm: move expand verification code into new function
Date:   Wed, 31 May 2023 17:21:06 +0200
Message-Id: <20230531152108.18103-5-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20230531152108.18103-1-mariusz.tkaczyk@linux.intel.com>
References: <20230531152108.18103-1-mariusz.tkaczyk@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

The code here is too complex. Move it to separate function and
simplify it. Add more error messages.

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 super-intel.c | 187 +++++++++++++++++++++++++++-----------------------
 1 file changed, 101 insertions(+), 86 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 2351ce20..83bf2bfc 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -11582,6 +11582,102 @@ static void imsm_update_metadata_locally(struct supertype *st,
 	}
 }
 
+/**
+ * imsm_analyze_expand() - check expand properties and calculate new size.
+ * @st: imsm supertype.
+ * @geo: new geometry params.
+ * @array: array info.
+ * @direction: reshape direction.
+ *
+ * Obtain free space after the &array and verify if expand to requested size is
+ * possible. If geo->size is set to %MAX_SIZE, assume that max free size is
+ * requested.
+ *
+ * Return:
+ * On success %IMSM_STATUS_OK is returned, geo->size and geo->raid_disks are
+ * updated.
+ * On error, %IMSM_STATUS_ERROR is returned.
+ */
+static imsm_status_t imsm_analyze_expand(struct supertype *st,
+					 struct geo_params *geo,
+					 struct mdinfo *array,
+					 int direction)
+{
+	struct intel_super *super = st->sb;
+	struct imsm_dev *dev = get_imsm_dev(super, super->current_vol);
+	struct imsm_map *map = get_imsm_map(dev, MAP_0);
+	int data_disks = imsm_num_data_members(map);
+
+	unsigned long long current_size;
+	unsigned long long free_size;
+	unsigned long long new_size;
+	unsigned long long max_size;
+
+	const int chunk_kib = geo->chunksize / 1024;
+	imsm_status_t rv;
+
+	if (direction == ROLLBACK_METADATA_CHANGES) {
+		/**
+		 * Accept size for rollback only.
+		 */
+		new_size = geo->size * 2;
+		goto success;
+	}
+
+	if (super->current_vol + 1 != super->anchor->num_raid_devs) {
+		pr_err("imsm: The last volume in container can be expanded only (%i/%s).\n",
+		       super->current_vol, st->devnm);
+		return IMSM_STATUS_ERROR;
+	}
+
+	if (data_disks == 0) {
+		pr_err("imsm: Cannot retrieve data disks.\n");
+		return IMSM_STATUS_ERROR;
+	}
+	current_size = array->custom_array_size / data_disks;
+
+	rv = imsm_get_free_size(super, dev->vol.map->num_members, 0, chunk_kib, &free_size);
+	if (rv != IMSM_STATUS_OK) {
+		pr_err("imsm: Cannot find free space for expand.\n");
+		return IMSM_STATUS_ERROR;
+	}
+	max_size = round_member_size_to_mb(free_size + current_size);
+
+	if (geo->size == MAX_SIZE)
+		new_size = max_size;
+	else
+		new_size = round_member_size_to_mb(geo->size * 2);
+
+	if (new_size == 0) {
+		pr_err("imsm: Rounded requested size is 0.\n");
+		return IMSM_STATUS_ERROR;
+	}
+
+	if (new_size > max_size) {
+		pr_err("imsm: Rounded requested size (%llu) is larger than free space available (%llu).\n",
+		       new_size, max_size);
+		return IMSM_STATUS_ERROR;
+	}
+
+	if (new_size == current_size) {
+		pr_err("imsm: Rounded requested size (%llu) is same as current size (%llu).\n",
+		       new_size, current_size);
+		return IMSM_STATUS_ERROR;
+	}
+
+	if (new_size < current_size) {
+		pr_err("imsm: Size reduction is not supported, rounded requested size (%llu) is smaller than current (%llu).\n",
+		       new_size, current_size);
+		return IMSM_STATUS_ERROR;
+	}
+
+success:
+	dprintf("imsm: New size per member is %llu.\n", new_size);
+	geo->size = data_disks * new_size;
+	geo->raid_disks = dev->vol.map->num_members;
+	return IMSM_STATUS_OK;
+}
+
 /***************************************************************************
 * Function:	imsm_analyze_change
 * Description:	Function analyze change for single volume
@@ -11602,13 +11698,6 @@ enum imsm_reshape_type imsm_analyze_change(struct supertype *st,
 	int devNumChange = 0;
 	/* imsm compatible layout value for array geometry verification */
 	int imsm_layout = -1;
-	int data_disks;
-	struct imsm_dev *dev;
-	struct imsm_map *map;
-	struct intel_super *super;
-	unsigned long long current_size;
-	unsigned long long free_size;
-	unsigned long long max_size;
 	imsm_status_t rv;
 
 	getinfo_super_imsm_volume(st, &info, NULL);
@@ -11691,94 +11780,20 @@ enum imsm_reshape_type imsm_analyze_change(struct supertype *st,
 		geo->chunksize = info.array.chunk_size;
 	}
 
-	chunk = geo->chunksize / 1024;
-
-	super = st->sb;
-	dev = get_imsm_dev(super, super->current_vol);
-	map = get_imsm_map(dev, MAP_0);
-	data_disks = imsm_num_data_members(map);
-	/* compute current size per disk member
-	 */
-	current_size = info.custom_array_size / data_disks;
-
-	if (geo->size > 0 && geo->size != MAX_SIZE) {
-		/* align component size
-		 */
-		geo->size = imsm_component_size_alignment_check(
-				    get_imsm_raid_level(dev->vol.map),
-				    chunk * 1024, super->sector_size,
-				    geo->size * 2);
-		if (geo->size == 0) {
-			pr_err("Error. Size expansion is supported only (current size is %llu, requested size /rounded/ is 0).\n",
-				   current_size);
-			goto analyse_change_exit;
-		}
-	}
-
-	if (current_size != geo->size && geo->size > 0) {
+	if (geo->size > 0) {
 		if (change != -1) {
 			pr_err("Error. Size change should be the only one at a time.\n");
 			change = -1;
 			goto analyse_change_exit;
 		}
-		if ((super->current_vol + 1) != super->anchor->num_raid_devs) {
-			pr_err("Error. The last volume in container can be expanded only (%i/%s).\n",
-			       super->current_vol, st->devnm);
-			goto analyse_change_exit;
-		}
-		/* check the maximum available size
-		 */
-		rv = imsm_get_free_size(super, dev->vol.map->num_members,
-					0, chunk, &free_size);
 
+		rv = imsm_analyze_expand(st, geo, &info, direction);
 		if (rv != IMSM_STATUS_OK)
-			/* Cannot find maximum available space
-			 */
-			max_size = 0;
-		else {
-			max_size = free_size + current_size;
-			/* align component size
-			 */
-			max_size = imsm_component_size_alignment_check(
-					get_imsm_raid_level(dev->vol.map),
-					chunk * 1024, super->sector_size,
-					max_size);
-		}
-		if (geo->size == MAX_SIZE) {
-			/* requested size change to the maximum available size
-			 */
-			if (max_size == 0) {
-				pr_err("Error. Cannot find maximum available space.\n");
-				change = -1;
-				goto analyse_change_exit;
-			} else
-				geo->size = max_size;
-		}
-
-		if (direction == ROLLBACK_METADATA_CHANGES) {
-			/* accept size for rollback only
-			*/
-		} else {
-			/* round size due to metadata compatibility
-			*/
-			geo->size = round_member_size_to_mb(geo->size);
-			dprintf("Prepare update for size change to %llu\n",
-				geo->size );
-			if (current_size >= geo->size) {
-				pr_err("Error. Size expansion is supported only (current size is %llu, requested size /rounded/ is %llu).\n",
-				       current_size, geo->size);
-				goto analyse_change_exit;
-			}
-			if (max_size && geo->size > max_size) {
-				pr_err("Error. Requested size is larger than maximum available size (maximum available size is %llu, requested size /rounded/ is %llu).\n",
-				       max_size, geo->size);
-				goto analyse_change_exit;
-			}
-		}
-		geo->size *= data_disks;
-		geo->raid_disks = dev->vol.map->num_members;
+			goto analyse_change_exit;
 		change = CH_ARRAY_SIZE;
 	}
+
+	chunk = geo->chunksize / 1024;
 	if (!validate_geometry_imsm(st,
 				    geo->level,
 				    imsm_layout,
-- 
2.26.2

