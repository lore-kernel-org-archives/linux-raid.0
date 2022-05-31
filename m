Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 127F9C433FE
	for <linux-raid@archiver.kernel.org>; Tue, 31 May 2022 10:27:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245686AbiEaK1x (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 31 May 2022 06:27:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245136AbiEaK1v (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 31 May 2022 06:27:51 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB5FD996B6
        for <linux-raid@vger.kernel.org>; Tue, 31 May 2022 03:27:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653992870; x=1685528870;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NWhccGlsMLMHcFbGQoNgjRM0tBvWLCp+xZwq+vCumgE=;
  b=g6jqjgxCJrZ/tsGWsO4a5VvKSBro4+RsWVhqxh1AxZ6VhW7n9bsh8jmq
   OpsZxTbFCb5EhVwfgEYY7Q+nF3TEfhyNVEcUFI+0agxLNrXNKhu2AsXcb
   vAuHKrG9lJhlgxgVsjc/A/HNcMlMD8Uk1nxvFGo1TecjONXORjEU2+N24
   KSj+BoS8A8cO4hlJFG/v5lV/OL60vZwjrm98FIXJ137D5BSmbcBhhTVNm
   5Ov+beMK/TIZxP/y0RLz/vK4vFn3IechsLK3tI/lejGDmt8M0kz0PAOnF
   OXlI319ehbLKlNoDghTA7ZcMuOovuQLXe55Hwb3U2a5t2wV3sglwvE86F
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10363"; a="300562497"
X-IronPort-AV: E=Sophos;i="5.91,264,1647327600"; 
   d="scan'208";a="300562497"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2022 03:27:50 -0700
X-IronPort-AV: E=Sophos;i="5.91,264,1647327600"; 
   d="scan'208";a="576342803"
Received: from mtkaczyk-devel.igk.intel.com ([10.102.102.23])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2022 03:27:49 -0700
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     jes@trained-monkey.org, colyli@suse.de
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH 2/3 v2] imsm: use same slot across container
Date:   Tue, 31 May 2022 12:27:26 +0200
Message-Id: <20220531102727.9315-3-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220531102727.9315-1-mariusz.tkaczyk@linux.intel.com>
References: <20220531102727.9315-1-mariusz.tkaczyk@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Autolayout relies on drives order on super->disks list, but
it is not quaranted by readdir() in sysfs_read(). As a result
drive could be put in different slot in second volume.

Make it consistent by reffering to first volume, if exists.

Use enum imsm_status to unify error handling.

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 super-intel.c | 169 ++++++++++++++++++++++++++++++++------------------
 1 file changed, 108 insertions(+), 61 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index f0196948..3c02d2f6 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -7493,11 +7493,27 @@ static int validate_geometry_imsm_volume(struct supertype *st, int level,
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
@@ -7541,12 +7557,10 @@ static int imsm_get_free_size(struct supertype *st, int raiddisks,
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
@@ -7559,37 +7573,69 @@ static int imsm_get_free_size(struct supertype *st, int raiddisks,
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
@@ -7625,35 +7671,35 @@ static int validate_geometry_imsm(struct supertype *st, int level, int layout,
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
@@ -11524,7 +11570,7 @@ enum imsm_reshape_type imsm_analyze_change(struct supertype *st,
 	unsigned long long current_size;
 	unsigned long long free_size;
 	unsigned long long max_size;
-	int rv;
+	imsm_status_t rv;
 
 	getinfo_super_imsm_volume(st, &info, NULL);
 	if (geo->level != info.array.level && geo->level >= 0 &&
@@ -11643,9 +11689,10 @@ enum imsm_reshape_type imsm_analyze_change(struct supertype *st,
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

