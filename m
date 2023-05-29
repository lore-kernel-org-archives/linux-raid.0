Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4717DC7EE2E
	for <linux-raid@archiver.kernel.org>; Mon, 29 May 2023 13:55:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230142AbjE2NzP (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 29 May 2023 09:55:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230098AbjE2Nyn (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 29 May 2023 09:54:43 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB9D2A8
        for <linux-raid@vger.kernel.org>; Mon, 29 May 2023 06:53:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685368429; x=1716904429;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jNXjofIBQcAf4T/wd1ar/scMxnm+iG97QEJHngNz4oc=;
  b=hNDUEnb+CegDIDX2KZK6rvjyJd2xt5PUmaAZj9MbSGgl4FBavahtiXXi
   JHlw32Hw9IGZO8baZaR2jt38/zhgSwuXOKBu7K1+j73v3je6eyeani9jD
   u+iHm8cNgV3Ycm9rppHC+LHJ8DCps9O+kVlSzmdtV+MaVj6SaB/n2yL8A
   Jcq5WLwAgeZo5U7yCPJ+COgRWnpZiof/Nh3qiavAxmd16VoLCX9J0i6fE
   pxbfc6Mc3g1LugZiCELbrJh7YltIQz+Y+NQnys4huhISZlsC/2O5wWWxc
   dtkyNwCRz3xmGCWcjDXvHn2dwIYUzpmNUPNkshaQJBT7cOKflGl4RFViN
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10725"; a="418193874"
X-IronPort-AV: E=Sophos;i="6.00,201,1681196400"; 
   d="scan'208";a="418193874"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2023 06:53:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10725"; a="706069275"
X-IronPort-AV: E=Sophos;i="6.00,201,1681196400"; 
   d="scan'208";a="706069275"
Received: from mtkaczyk-devel.igk.intel.com ([10.102.105.40])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2023 06:53:04 -0700
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org, colyli@suse.de
Subject: [PATCH 5/6] imsm: return free space after volume for expand
Date:   Mon, 29 May 2023 15:52:37 +0200
Message-Id: <20230529135238.18602-6-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20230529135238.18602-1-mariusz.tkaczyk@linux.intel.com>
References: <20230529135238.18602-1-mariusz.tkaczyk@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

merge_extends() routine searches for the biggest free space. For expand,
it works only in standard cases where the last volume is expanded and
the free space is determined after the last volume.
Add volume index to extent struct and use that do determine size after
super->current_vol during expand.

Limitation to last volume is no longer needed. It unblocks scenarios
where kill-subarray is used to remove first volume and later it is
recreated (now it is the second volume, even if it is placed before
existing one).

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 super-intel.c | 71 +++++++++++++++++++++++++++------------------------
 1 file changed, 37 insertions(+), 34 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 83bf2bfc..1559c837 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -498,8 +498,15 @@ struct intel_disk {
 	struct intel_disk *next;
 };
 
+/**
+ * struct extent - reserved space details.
+ * @start: start offset.
+ * @size: size of reservation, set to 0 for metadata reservation.
+ * @vol: index of the volume, meaningful if &size is set.
+ */
 struct extent {
 	unsigned long long start, size;
+	int vol;
 };
 
 /* definitions of reshape process types */
@@ -1494,9 +1501,10 @@ static struct extent *get_extents(struct intel_super *super, struct dl *dl,
 				  int get_minimal_reservation)
 {
 	/* find a list of used extents on the given physical device */
-	struct extent *rv, *e;
-	int i;
 	int memberships = count_memberships(dl, super);
+	struct extent *rv = xcalloc(memberships + 1, sizeof(struct extent));
+	struct extent *e = rv;
+	int i;
 	__u32 reservation;
 
 	/* trim the reserved area for spares, so they can join any array
@@ -1508,9 +1516,6 @@ static struct extent *get_extents(struct intel_super *super, struct dl *dl,
 	else
 		reservation = MPB_SECTOR_CNT + IMSM_RESERVED_SECTORS;
 
-	rv = xcalloc(sizeof(struct extent), (memberships + 1));
-	e = rv;
-
 	for (i = 0; i < super->anchor->num_raid_devs; i++) {
 		struct imsm_dev *dev = get_imsm_dev(super, i);
 		struct imsm_map *map = get_imsm_map(dev, MAP_0);
@@ -1518,6 +1523,7 @@ static struct extent *get_extents(struct intel_super *super, struct dl *dl,
 		if (get_imsm_disk_slot(map, dl->index) >= 0) {
 			e->start = pba_of_lba0(map);
 			e->size = per_dev_array_size(map);
+			e->vol = i;
 			e++;
 		}
 	}
@@ -6836,24 +6842,26 @@ static unsigned long long find_size(struct extent *e, int *idx, int num_extents)
 	return end - base_start;
 }
 
-/** merge_extents() - analyze extents and get max common free size.
+/** merge_extents() - analyze extents and get free size.
  * @super: Intel metadata, not NULL.
+ * @expanding: if set, we are expanding &super->current_vol.
  *
- * Build a composite disk with all known extents and generate a new maxsize
- * given the "all disks in an array must share a common start offset"
- * constraint.
+ * Build a composite disk with all known extents and generate a size given the
+ * "all disks in an array must share a common start offset" constraint.
+ * If a volume is expanded, then return free space after the volume.
  *
- * Return: Max free space or 0 on failure.
+ * Return: Free space or 0 on failure.
  */
-static unsigned long long merge_extents(struct intel_super *super)
+static unsigned long long merge_extents(struct intel_super *super, const bool expanding)
 {
 	struct extent *e;
 	struct dl *dl;
-	int i, j;
-	int start_extent, sum_extents = 0;
-	unsigned long long pos;
+	int i, j, pos_vol_idx = -1;
+	int extent_idx = 0;
+	int sum_extents = 0;
+	unsigned long long pos = 0;
 	unsigned long long start = 0;
-	unsigned long long maxsize;
+	unsigned long long maxsize = 0;
 	unsigned long reserve;
 
 	for (dl = super->disks; dl; dl = dl->next)
@@ -6878,26 +6886,26 @@ static unsigned long long merge_extents(struct intel_super *super)
 	j = 0;
 	while (i < sum_extents) {
 		e[j].start = e[i].start;
+		e[j].vol = e[i].vol;
 		e[j].size = find_size(e, &i, sum_extents);
 		j++;
 		if (e[j-1].size == 0)
 			break;
 	}
 
-	pos = 0;
-	maxsize = 0;
-	start_extent = 0;
 	i = 0;
 	do {
-		unsigned long long esize;
+		unsigned long long esize = e[i].start - pos;
 
-		esize = e[i].start - pos;
-		if (esize >= maxsize) {
+		if (expanding ? pos_vol_idx == super->current_vol : esize >= maxsize) {
 			maxsize = esize;
 			start = pos;
-			start_extent = i;
+			extent_idx = i;
 		}
+
 		pos = e[i].start + e[i].size;
+		pos_vol_idx = e[i].vol;
+
 		i++;
 	} while (e[i-1].size);
 	free(e);
@@ -6908,7 +6916,7 @@ static unsigned long long merge_extents(struct intel_super *super)
 	/* FIXME assumes volume at offset 0 is the first volume in a
 	 * container
 	 */
-	if (start_extent > 0)
+	if (extent_idx > 0)
 		reserve = IMSM_RESERVED_SECTORS; /* gap between raid regions */
 	else
 		reserve = 0;
@@ -7519,7 +7527,7 @@ static int validate_geometry_imsm_volume(struct supertype *st, int level,
 		return 0;
 	}
 
-	maxsize = merge_extents(super);
+	maxsize = merge_extents(super, false);
 
 	if (mpb->num_raid_devs > 0 && size && size != maxsize)
 		pr_err("attempting to create a second volume with size less then remaining space.\n");
@@ -7568,7 +7576,8 @@ static imsm_status_t imsm_get_free_size(struct intel_super *super,
 					const int raiddisks,
 					unsigned long long size,
 					const int chunk,
-					unsigned long long *freesize)
+					unsigned long long *freesize,
+					bool expanding)
 {
 	struct imsm_super *mpb = super->anchor;
 	struct dl *dl;
@@ -7605,7 +7614,7 @@ static imsm_status_t imsm_get_free_size(struct intel_super *super,
 		cnt++;
 	}
 
-	maxsize = merge_extents(super);
+	maxsize = merge_extents(super, expanding);
 	if (maxsize < minsize)  {
 		pr_err("imsm: Free space is %llu but must be equal or larger than %llu.\n",
 		       maxsize, minsize);
@@ -7663,7 +7672,7 @@ static imsm_status_t autolayout_imsm(struct intel_super *super,
 	int vol_cnt = super->anchor->num_raid_devs;
 	imsm_status_t rv;
 
-	rv = imsm_get_free_size(super, raiddisks, size, chunk, freesize);
+	rv = imsm_get_free_size(super, raiddisks, size, chunk, freesize, false);
 	if (rv != IMSM_STATUS_OK)
 		return IMSM_STATUS_ERROR;
 
@@ -11624,19 +11633,13 @@ static imsm_status_t imsm_analyze_expand(struct supertype *st,
 		goto success;
 	}
 
-	if (super->current_vol + 1 != super->anchor->num_raid_devs) {
-		pr_err("imsm: The last volume in container can be expanded only (%i/%s).\n",
-		       super->current_vol, st->devnm);
-		return IMSM_STATUS_ERROR;
-	}
-
 	if (data_disks == 0) {
 		pr_err("imsm: Cannot retrieve data disks.\n");
 		return IMSM_STATUS_ERROR;
 	}
 	current_size = array->custom_array_size / data_disks;
 
-	rv = imsm_get_free_size(super, dev->vol.map->num_members, 0, chunk_kib, &free_size);
+	rv = imsm_get_free_size(super, dev->vol.map->num_members, 0, chunk_kib, &free_size, true);
 	if (rv != IMSM_STATUS_OK) {
 		pr_err("imsm: Cannot find free space for expand.\n");
 		return IMSM_STATUS_ERROR;
-- 
2.26.2

