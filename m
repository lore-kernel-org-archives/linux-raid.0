Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB1F7C433FE
	for <linux-raid@archiver.kernel.org>; Tue, 19 Apr 2022 14:37:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353501AbiDSOkT (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 19 Apr 2022 10:40:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353493AbiDSOkP (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 19 Apr 2022 10:40:15 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AB1720F70
        for <linux-raid@vger.kernel.org>; Tue, 19 Apr 2022 07:37:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650379053; x=1681915053;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hCgDcXKVjEktUbQPpuOiEo1r4lQIJEdl9xIYO8N90LU=;
  b=LuHGVpRfD1zDLIC6q2/m22IzceoHu0C+J4LgL830YTvbDOsFrODEcYwg
   uZs37wDEpIEwE9afKaK4JdkkFqCjI9w5fhSE1PkEyupNLkcLFRoCOLrcW
   rXXm8gGp6pJTStunYQa0GzwGiZ8Fn55bzXcmmtRhCsso0UK2B7otAhHm0
   yXaXsQQaj6c1/fFNulbX8LtB1grI5z3Ak78xIhRV8bdMOuONAsoa00fve
   /oZFG8BvOsFbF7jtOQbSYCRsNW1VYTt+yVJ1ra5zVKyOcWBBpdZIcqJbv
   nMZRL7jpV3WC3fW9rrbvdze6pWsjF+yqcLh8Px30eNT7E+KI6XE6NdWXT
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10322"; a="263952018"
X-IronPort-AV: E=Sophos;i="5.90,272,1643702400"; 
   d="scan'208";a="263952018"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2022 07:37:32 -0700
X-IronPort-AV: E=Sophos;i="5.90,272,1643702400"; 
   d="scan'208";a="576128967"
Received: from mtkaczyk-devel.igk.intel.com ([10.102.102.23])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2022 07:37:31 -0700
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     jes@trained-monkey.org, colyli@suse.de
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH 2/3] imsm: use same slot across container
Date:   Tue, 19 Apr 2022 16:37:13 +0200
Message-Id: <20220419143714.16942-3-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220419143714.16942-1-mariusz.tkaczyk@linux.intel.com>
References: <20220419143714.16942-1-mariusz.tkaczyk@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Autolayout relies on drives order on super->disks list, but
it is not quaranted by readdir() in sysfs_read(). As a result
drive could be put in different slot in second volume.

Make it consistent by referring to first volume, if exists.

Enum imsm_status is typedefed and propagated in modified routines, to
unify error handling.

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 super-intel.c | 175 ++++++++++++++++++++++++++++++++------------------
 1 file changed, 112 insertions(+), 63 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index c16251c8..f3cd7515 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -370,12 +370,14 @@ ASSERT_SIZE(migr_record, 128)
  * enum imsm_status - internal IMSM return values representation.
  * @STATUS_OK: function succeeded.
  * @STATUS_ERROR: General error ocurred (not specified).
+ *
+ * Typedefed to imsm_status_t.
  */
-enum {
+typedef enum imsm_status {
 	IMSM_STATUS_OK = 0,
 	IMSM_STATUS_ERROR = -1,
 
-} imsm_status;
+} imsm_status_t;
 
 struct md_list {
 	/* usage marker:
@@ -7492,11 +7494,27 @@ static int validate_geometry_imsm_volume(struct supertype *st, int level,
 	return 1;
 }
 
-static int imsm_get_free_size(struct supertype *st, int raiddisks,
-			 unsigned long long size, int chunk,
-			 unsigned long long *freesize)
+/**
+ * imsm_get_free_size() - get the biggest, common free space from members.
+ * @super: &intel_super pointer, not NULL.
+ * @raiddisks: number of raid disks.
+ * @size: requested size, could be 0 (means max size).
+ * @chunk: requested chunk.
+ * @freesize: pointer for returned size value.
+ *
+ * Return: &IMSM_STATUS_OK or &IMSM_STATUS_ERROR.
+ *
+ * @freesize is set to meaningful value, this can be @size, or calculated
+ * max free size.
+ * super->create_offset value is modified and set appropriately in
+ * merge_extends() for further creation.
+ */
+static imsm_status_t imsm_get_free_size(struct intel_super *super,
+					const int raiddisks,
+					unsigned long long size,
+					const int chunk,
+					unsigned long long *freesize)
 {
-	struct intel_super *super = st->sb;
 	struct imsm_super *mpb = super->anchor;
 	struct dl *dl;
 	int i;
@@ -7540,12 +7558,10 @@ static int imsm_get_free_size(struct supertype *st, int raiddisks,
 		/* chunk is in K */
 		minsize = chunk * 2;
 
-	if (cnt < raiddisks ||
-	    (super->orom && used && used != raiddisks) ||
-	    maxsize < minsize ||
-	    maxsize == 0) {
+	if (cnt < raiddisks || (super->orom && used && used != raiddisks) ||
+	    maxsize < minsize || maxsize == 0) {
 		pr_err("not enough devices with space to create array.\n");
-		return 0; /* No enough free spaces large enough */
+		return IMSM_STATUS_ERROR;
 	}
 
 	if (size == 0) {
@@ -7558,37 +7574,69 @@ static int imsm_get_free_size(struct supertype *st, int raiddisks,
 	}
 	if (mpb->num_raid_devs > 0 && size && size != maxsize)
 		pr_err("attempting to create a second volume with size less then remaining space.\n");
-	cnt = 0;
-	for (dl = super->disks; dl; dl = dl->next)
-		if (dl->e)
-			dl->raiddisk = cnt++;
-
 	*freesize = size;
 
 	dprintf("imsm: imsm_get_free_size() returns : %llu\n", size);
 
-	return 1;
+	return IMSM_STATUS_OK;
 }
 
-static int reserve_space(struct supertype *st, int raiddisks,
-			 unsigned long long size, int chunk,
-			 unsigned long long *freesize)
+/**
+ * autolayout_imsm() - automatically layout a new volume.
+ * @super: &intel_super pointer, not NULL.
+ * @raiddisks: number of raid disks.
+ * @size: requested size, could be 0 (means max size).
+ * @chunk: requested chunk.
+ * @freesize: pointer for returned size value.
+ *
+ * We are being asked to automatically layout a new volume based on the current
+ * contents of the container. If the parameters can be satisfied autolayout_imsm
+ * will record the disks, start offset, and will return size of the volume to
+ * be created. See imsm_get_free_size() for details.
+ * add_to_super() and getinfo_super() detect when autolayout is in progress.
+ * If first volume exists, slots are set consistently to it.
+ *
+ * Return: &IMSM_STATUS_OK on success, &IMSM_STATUS_ERROR otherwise.
+ *
+ * Disks are marked for creation via dl->raiddisk.
+ */
+static imsm_status_t autolayout_imsm(struct intel_super *super,
+				     const int raiddisks,
+				     unsigned long long size, const int chunk,
+				     unsigned long long *freesize)
 {
-	struct intel_super *super = st->sb;
-	struct dl *dl;
-	int cnt;
-	int rv = 0;
+	int curr_slot = 0;
+	struct dl *disk;
+	int vol_cnt = super->anchor->num_raid_devs;
+	imsm_status_t rv;
 
-	rv = imsm_get_free_size(st, raiddisks, size, chunk, freesize);
-	if (rv) {
-		cnt = 0;
-		for (dl = super->disks; dl; dl = dl->next)
-			if (dl->e)
-				dl->raiddisk = cnt++;
-		rv = 1;
+	rv = imsm_get_free_size(super, raiddisks, size, chunk, freesize);
+	if (rv != IMSM_STATUS_OK)
+		return IMSM_STATUS_ERROR;
+
+	for (disk = super->disks; disk; disk = disk->next) {
+		if (!disk->e)
+			continue;
+
+		if (curr_slot == raiddisks)
+			break;
+
+		if (vol_cnt == 0) {
+			disk->raiddisk = curr_slot;
+		} else {
+			int _slot = get_disk_slot_in_dev(super, 0, disk->index);
+
+			if (_slot == -1) {
+				pr_err("Disk %s is not used in first volume, aborting\n",
+				       disk->devname);
+				return IMSM_STATUS_ERROR;
+			}
+			disk->raiddisk = _slot;
+		}
+		curr_slot++;
 	}
 
-	return rv;
+	return IMSM_STATUS_OK;
 }
 
 static int validate_geometry_imsm(struct supertype *st, int level, int layout,
@@ -7624,35 +7672,35 @@ static int validate_geometry_imsm(struct supertype *st, int level, int layout,
 	}
 
 	if (!dev) {
-		if (st->sb) {
-			struct intel_super *super = st->sb;
-			if (!validate_geometry_imsm_orom(st->sb, level, layout,
-							 raiddisks, chunk, size,
-							 verbose))
+		struct intel_super *super = st->sb;
+
+		/*
+		 * Autolayout mode, st->sb and freesize must be set.
+		 */
+		if (!super || !freesize) {
+			pr_vrb("freesize and superblock must be set for autolayout, aborting\n");
+			return 1;
+		}
+
+		if (!validate_geometry_imsm_orom(st->sb, level, layout,
+						 raiddisks, chunk, size,
+						 verbose))
+			return 0;
+
+		if (super->orom) {
+			imsm_status_t rv;
+			int count = count_volumes(super->hba, super->orom->dpa,
+					      verbose);
+			if (super->orom->vphba <= count) {
+				pr_vrb("platform does not support more than %d raid volumes.\n",
+				       super->orom->vphba);
 				return 0;
-			/* we are being asked to automatically layout a
-			 * new volume based on the current contents of
-			 * the container.  If the the parameters can be
-			 * satisfied reserve_space will record the disks,
-			 * start offset, and size of the volume to be
-			 * created.  add_to_super and getinfo_super
-			 * detect when autolayout is in progress.
-			 */
-			/* assuming that freesize is always given when array is
-			   created */
-			if (super->orom && freesize) {
-				int count;
-				count = count_volumes(super->hba,
-						      super->orom->dpa, verbose);
-				if (super->orom->vphba <= count) {
-					pr_vrb("platform does not support more than %d raid volumes.\n",
-					       super->orom->vphba);
-					return 0;
-				}
 			}
-			if (freesize)
-				return reserve_space(st, raiddisks, size,
-						     *chunk, freesize);
+
+			rv = autolayout_imsm(super, raiddisks, size, *chunk,
+					     freesize);
+			if (rv != IMSM_STATUS_OK)
+				return 0;
 		}
 		return 1;
 	}
@@ -11523,7 +11571,7 @@ enum imsm_reshape_type imsm_analyze_change(struct supertype *st,
 	unsigned long long current_size;
 	unsigned long long free_size;
 	unsigned long long max_size;
-	int rv;
+	imsm_status_t rv;
 
 	getinfo_super_imsm_volume(st, &info, NULL);
 	if (geo->level != info.array.level && geo->level >= 0 &&
@@ -11642,9 +11690,10 @@ enum imsm_reshape_type imsm_analyze_change(struct supertype *st,
 		}
 		/* check the maximum available size
 		 */
-		rv =  imsm_get_free_size(st, dev->vol.map->num_members,
-					 0, chunk, &free_size);
-		if (rv == 0)
+		rv = imsm_get_free_size(super, dev->vol.map->num_members,
+					0, chunk, &free_size);
+
+		if (rv != IMSM_STATUS_OK)
 			/* Cannot find maximum available space
 			 */
 			max_size = 0;
-- 
2.26.2

