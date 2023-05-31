Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F707C77B7A
	for <linux-raid@archiver.kernel.org>; Wed, 31 May 2023 15:22:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233885AbjEaPWE (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 31 May 2023 11:22:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234409AbjEaPVa (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 31 May 2023 11:21:30 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F12AC0
        for <linux-raid@vger.kernel.org>; Wed, 31 May 2023 08:21:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685546489; x=1717082489;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HPLDIt7rj+8h3lPYitOf0woH5Y1kYMuHcsFm4TjxG8A=;
  b=Bzq7tAn0x4D6gGKXUDzrRZ3f/5ACYbccZ4eDQJRcU3LLcvfPwPYkwUuG
   EG4pgUh3L67BXh31AnevhtZMYZ93cmkzKDzBHjxIL0RIsaMqCSirpV4D0
   5WHdaCklCJGlrA2jg/FSB0Oo9X+hH8H8kweFr3jp4D9HIjtEjZC6MOBsh
   LqQDonk6vd9s5AkGD1BAZPmRSOIiEygH72lQYFHqvkga3myGn8DPtcCLk
   Ii/yLZPOcNidHNKv41gRfvFgHxvPm0Elieur/KMkJ9sI9EhKUpsZ0ROCt
   Zpr49DpDukacPHP473piNkuls+FE4XEqSKJpG2EmZdBOJLAhOanmDFzYl
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10727"; a="339864902"
X-IronPort-AV: E=Sophos;i="6.00,207,1681196400"; 
   d="scan'208";a="339864902"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2023 08:21:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10727"; a="796747338"
X-IronPort-AV: E=Sophos;i="6.00,207,1681196400"; 
   d="scan'208";a="796747338"
Received: from mtkaczyk-devel.igk.intel.com ([10.102.105.40])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2023 08:21:28 -0700
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org, colyli@suse.de
Subject: [PATCH 1/6] imsm: move sum_extents calculations to merge_extents()
Date:   Wed, 31 May 2023 17:21:03 +0200
Message-Id: <20230531152108.18103-2-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20230531152108.18103-1-mariusz.tkaczyk@linux.intel.com>
References: <20230531152108.18103-1-mariusz.tkaczyk@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

This logic is only used by merge_extents() code, there is no need to pass
it as parameter. Move it up. Add proper description.

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 super-intel.c | 37 +++++++++++++++++++------------------
 1 file changed, 19 insertions(+), 18 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 8ffe485c..81d6ecd9 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -6824,21 +6824,31 @@ static unsigned long long find_size(struct extent *e, int *idx, int num_extents)
 	return end - base_start;
 }
 
-static unsigned long long merge_extents(struct intel_super *super, int sum_extents)
+/** merge_extents() - analyze extents and get max common free size.
+ * @super: Intel metadata, not NULL.
+ *
+ * Build a composite disk with all known extents and generate a new maxsize
+ * given the "all disks in an array must share a common start offset"
+ * constraint.
+ *
+ * Return: Max free space or 0 on failure.
+ */
+static unsigned long long merge_extents(struct intel_super *super)
 {
-	/* build a composite disk with all known extents and generate a new
-	 * 'maxsize' given the "all disks in an array must share a common start
-	 * offset" constraint
-	 */
-	struct extent *e = xcalloc(sum_extents, sizeof(*e));
+	struct extent *e;
 	struct dl *dl;
 	int i, j;
-	int start_extent;
+	int start_extent, sum_extents = 0;
 	unsigned long long pos;
 	unsigned long long start = 0;
 	unsigned long long maxsize;
 	unsigned long reserve;
 
+	for (dl = super->disks; dl; dl = dl->next)
+		if (dl->e)
+			sum_extents += dl->extent_cnt;
+	e = xcalloc(sum_extents, sizeof(struct extent));
+
 	/* coalesce and sort all extents. also, check to see if we need to
 	 * reserve space between member arrays
 	 */
@@ -7497,13 +7507,7 @@ static int validate_geometry_imsm_volume(struct supertype *st, int level,
 		return 0;
 	}
 
-	/* count total number of extents for merge */
-	i = 0;
-	for (dl = super->disks; dl; dl = dl->next)
-		if (dl->e)
-			i += dl->extent_cnt;
-
-	maxsize = merge_extents(super, i);
+	maxsize = merge_extents(super);
 
 	if (mpb->num_raid_devs > 0 && size && size != maxsize)
 		pr_err("attempting to create a second volume with size less then remaining space.\n");
@@ -7557,7 +7561,6 @@ static imsm_status_t imsm_get_free_size(struct intel_super *super,
 	struct imsm_super *mpb = super->anchor;
 	struct dl *dl;
 	int i;
-	int extent_cnt;
 	struct extent *e;
 	unsigned long long maxsize;
 	unsigned long long minsize;
@@ -7566,7 +7569,6 @@ static imsm_status_t imsm_get_free_size(struct intel_super *super,
 
 	/* find the largest common start free region of the possible disks */
 	used = 0;
-	extent_cnt = 0;
 	cnt = 0;
 	for (dl = super->disks; dl; dl = dl->next) {
 		dl->raiddisk = -1;
@@ -7587,11 +7589,10 @@ static imsm_status_t imsm_get_free_size(struct intel_super *super,
 			;
 		dl->e = e;
 		dl->extent_cnt = i;
-		extent_cnt += i;
 		cnt++;
 	}
 
-	maxsize = merge_extents(super, extent_cnt);
+	maxsize = merge_extents(super);
 	minsize = size;
 	if (size == 0)
 		/* chunk is in K */
-- 
2.26.2

