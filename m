Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B319FC43334
	for <linux-raid@archiver.kernel.org>; Mon, 20 Jun 2022 16:11:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241963AbiFTQLk (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 20 Jun 2022 12:11:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241545AbiFTQLi (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 20 Jun 2022 12:11:38 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69C07205F2
        for <linux-raid@vger.kernel.org>; Mon, 20 Jun 2022 09:11:37 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 2692421ABD;
        Mon, 20 Jun 2022 16:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1655741496; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9BVacr8VBzzdT+M+/KfuBAOKLTXlWJ6riVVadGEyWaU=;
        b=T0acn4YgnO8MKTW/OgRLxsnOgX4c32NFcJQwsvosGEloef9hB0+fQyAPmYg6FkFUVg4DcO
        h4LVTjY5L27F9N3KTddt1tk+TWfYWOje5plWHTLuoKxC1IgPovZFrc/DPVoks34wK6YTHa
        okN23YPZcqaxDQoyZHZSflItUjE2Kk8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1655741496;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9BVacr8VBzzdT+M+/KfuBAOKLTXlWJ6riVVadGEyWaU=;
        b=TTj03iyl/pnMu5VcUZWOtbTHLHG0/4RuiQgKX9WhYxYZrhmx/Drw7cjnbi1omYBTMc5+/S
        r08yQOeF56uPlFBQ==
Received: from localhost.localdomain (unknown [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id 0AEB12C141;
        Mon, 20 Jun 2022 16:11:33 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Coly Li <colyli@suse.de>
Subject: [PATCH 5/6] imsm: use same slot across container
Date:   Tue, 21 Jun 2022 00:10:42 +0800
Message-Id: <20220620161043.3661-6-colyli@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220620161043.3661-1-colyli@suse.de>
References: <20220620161043.3661-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>

Autolayout relies on drives order on super->disks list, but
it is not quaranted by readdir() in sysfs_read(). As a result
drive could be put in different slot in second volume.

Make it consistent by reffering to first volume, if exists.

Use enum imsm_status to unify error handling.

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Acked-by: Coly Li <colyli@suse.de>
---
 super-intel.c | 169 ++++++++++++++++++++++++++++++++------------------
 1 file changed, 108 insertions(+), 61 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index cd1f1e3d..deef7c87 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -7522,11 +7522,27 @@ static int validate_geometry_imsm_volume(struct supertype *st, int level,
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
@@ -7570,12 +7586,10 @@ static int imsm_get_free_size(struct supertype *st, int raiddisks,
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
@@ -7588,37 +7602,69 @@ static int imsm_get_free_size(struct supertype *st, int raiddisks,
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
@@ -7654,35 +7700,35 @@ static int validate_geometry_imsm(struct supertype *st, int level, int layout,
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
@@ -11538,7 +11584,7 @@ enum imsm_reshape_type imsm_analyze_change(struct supertype *st,
 	unsigned long long current_size;
 	unsigned long long free_size;
 	unsigned long long max_size;
-	int rv;
+	imsm_status_t rv;
 
 	getinfo_super_imsm_volume(st, &info, NULL);
 	if (geo->level != info.array.level && geo->level >= 0 &&
@@ -11657,9 +11703,10 @@ enum imsm_reshape_type imsm_analyze_change(struct supertype *st,
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
2.35.3

