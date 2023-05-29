Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFA50C77B7A
	for <linux-raid@archiver.kernel.org>; Mon, 29 May 2023 13:55:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbjE2NzN (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 29 May 2023 09:55:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230199AbjE2Nyn (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 29 May 2023 09:54:43 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 590A6C7
        for <linux-raid@vger.kernel.org>; Mon, 29 May 2023 06:53:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685368430; x=1716904430;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xe9jcM/fPQk3i94c/NyAOmvisI2GUPt0m3tuzVY62vw=;
  b=YSAtAmZTvTYh2FPH3Xh90rZffIKlEEMG9ARw0mwAJgn8XsaeX9FbEc8Y
   myHpQShzMNAAV3/7Bph6Vv6K+Q5HY7N1IpNE/KLmQkpBGVjz84ewInF1t
   ZavIm9IcsicQebdLK/hz3x3o6Q5Q1L9t8PPKyfWINzE0PvTSZHy30MMRE
   398WCdaaeDuDU3gP69hWMZDQfo2mWHl9HFrHqJqALwni+36xKmxEKd8za
   +KKDWUG7vxkzpdXNiwwMz8kjHTiS4IXo2jfxafDYDLhBL+oV8VCzS2xUw
   bkwnt4NldhZ+mx2xXlkfoifLMe+yb7bDwi2bLXCo4VFBzsu/SLclHNP1V
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10725"; a="418193882"
X-IronPort-AV: E=Sophos;i="6.00,201,1681196400"; 
   d="scan'208";a="418193882"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2023 06:53:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10725"; a="706069278"
X-IronPort-AV: E=Sophos;i="6.00,201,1681196400"; 
   d="scan'208";a="706069278"
Received: from mtkaczyk-devel.igk.intel.com ([10.102.105.40])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2023 06:53:06 -0700
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org, colyli@suse.de
Subject: [PATCH 6/6] imsm: fix free space calculations
Date:   Mon, 29 May 2023 15:52:38 +0200
Message-Id: <20230529135238.18602-7-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20230529135238.18602-1-mariusz.tkaczyk@linux.intel.com>
References: <20230529135238.18602-1-mariusz.tkaczyk@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Between two volumes or between last volume and metadata at least
IMSM_RESERVED_SECTORS gap must exist. Currently the gap can be doubled
because metadata reservation contains IMSM_RESERVED_SECTORS too.

Divide reserve variable into pre_reservation and post_reservation to be
more flexible and decide separately if each reservation is needed.

Pre_reservation is needed only when a volume is created and it is not a
real first volume in a container (we can check that by extent_idx).
This type of reservation is not needed for expand.

Post_reservation is not needed only if real last volume is created or
expanded because reservation is done with the metadata.

The volume index in metadata cannot be trusted, because the real volume
order can be reversed. It is safer to use extent table, it is sorted by
start position.

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 super-intel.c | 50 ++++++++++++++++++++++++++++++--------------------
 1 file changed, 30 insertions(+), 20 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 1559c837..c012b220 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -6861,8 +6861,11 @@ static unsigned long long merge_extents(struct intel_super *super, const bool ex
 	int sum_extents = 0;
 	unsigned long long pos = 0;
 	unsigned long long start = 0;
-	unsigned long long maxsize = 0;
-	unsigned long reserve;
+	unsigned long long free_size = 0;
+
+	unsigned long pre_reservation = 0;
+	unsigned long post_reservation = IMSM_RESERVED_SECTORS;
+	unsigned long reservation_size;
 
 	for (dl = super->disks; dl; dl = dl->next)
 		if (dl->e)
@@ -6897,8 +6900,8 @@ static unsigned long long merge_extents(struct intel_super *super, const bool ex
 	do {
 		unsigned long long esize = e[i].start - pos;
 
-		if (expanding ? pos_vol_idx == super->current_vol : esize >= maxsize) {
-			maxsize = esize;
+		if (expanding ? pos_vol_idx == super->current_vol : esize >= free_size) {
+			free_size = esize;
 			start = pos;
 			extent_idx = i;
 		}
@@ -6908,28 +6911,35 @@ static unsigned long long merge_extents(struct intel_super *super, const bool ex
 
 		i++;
 	} while (e[i-1].size);
-	free(e);
 
-	if (maxsize == 0)
+	if (free_size == 0) {
+		dprintf("imsm: Cannot find free size.\n");
+		free(e);
 		return 0;
+	}
 
-	/* FIXME assumes volume at offset 0 is the first volume in a
-	 * container
-	 */
-	if (extent_idx > 0)
-		reserve = IMSM_RESERVED_SECTORS; /* gap between raid regions */
-	else
-		reserve = 0;
+	if (!expanding && extent_idx != 0)
+		/*
+		 * Not a real first volume in a container is created, pre_reservation is needed.
+		 */
+		pre_reservation = IMSM_RESERVED_SECTORS;
 
-	if (maxsize < reserve)
-		return 0;
+	if (e[extent_idx].size == 0)
+		/*
+		 * extent_idx points to the metadata, post_reservation is allready done.
+		 */
+		post_reservation = 0;
+	free(e);
 
-	super->create_offset = ~((unsigned long long) 0);
-	if (start + reserve > super->create_offset)
-		return 0; /* start overflows create_offset */
-	super->create_offset = start + reserve;
+	reservation_size = pre_reservation + post_reservation;
+
+	if (free_size < reservation_size) {
+		dprintf("imsm: Reservation size is greater than free space.\n");
+		return 0;
+	}
 
-	return maxsize - reserve;
+	super->create_offset = start + pre_reservation;
+	return free_size - reservation_size;
 }
 
 static int is_raid_level_supported(const struct imsm_orom *orom, int level, int raiddisks)
-- 
2.26.2

