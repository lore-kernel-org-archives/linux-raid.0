Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30072C7EE2E
	for <linux-raid@archiver.kernel.org>; Mon, 29 May 2023 13:54:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbjE2Nyu (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 29 May 2023 09:54:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230161AbjE2NyQ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 29 May 2023 09:54:16 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A094110D8
        for <linux-raid@vger.kernel.org>; Mon, 29 May 2023 06:53:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685368405; x=1716904405;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kQiywsXRoNwZ0zOaubA1zXONHziZjQgYHbb1qaIbK4Q=;
  b=bo+VfCdCXitor634raBpOaiB9ldQhoW4jnacDWayo9gAX9CsJT+n/BZZ
   I34PoLn34COSA6JWsZom1GijpV6NnmbJ1S0OxEW23DKpIKfuWwKDNbqIJ
   YTSn82LaQ89PR0cOQYPVyavwJ5dn44RbAS8N/Dx9AD1vHiRYRcoqLGeQN
   MlWL8Eo6p5Yh+XVnsyQaw6MpDmQEmV5GVvwYMt8IqLrYPXx5jD+ONKWMP
   raRRAVIwPsf445bWHbvrXTqVZtX7zib4WbPcdmCJ/7sgP4mV6pVcrXVdt
   51FMTiPYqT1vnG+iUFQDBYkIzsknZlj1EGRl9N6Nd/dYn6XjXeQTjdTwF
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10725"; a="418193860"
X-IronPort-AV: E=Sophos;i="6.00,201,1681196400"; 
   d="scan'208";a="418193860"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2023 06:53:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10725"; a="706069270"
X-IronPort-AV: E=Sophos;i="6.00,201,1681196400"; 
   d="scan'208";a="706069270"
Received: from mtkaczyk-devel.igk.intel.com ([10.102.105.40])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2023 06:53:00 -0700
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org, colyli@suse.de
Subject: [PATCH 3/6] imsm: introduce round_member_size_to_mb()
Date:   Mon, 29 May 2023 15:52:35 +0200
Message-Id: <20230529135238.18602-4-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20230529135238.18602-1-mariusz.tkaczyk@linux.intel.com>
References: <20230529135238.18602-1-mariusz.tkaczyk@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Extract rounding logic to separate function.

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 super-intel.c | 31 +++++++++++++++++++++----------
 1 file changed, 21 insertions(+), 10 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 3cbab545..2351ce20 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -1599,17 +1599,29 @@ static int is_journal(struct imsm_disk *disk)
 	return (disk->status & JOURNAL_DISK) == JOURNAL_DISK;
 }
 
-/* round array size down to closest MB and ensure it splits evenly
- * between members
+/**
+ * round_member_size_to_mb()- Round given size to closest MiB.
+ * @size: size to round in sectors.
  */
-static unsigned long long round_size_to_mb(unsigned long long size, unsigned int
-					   disk_count)
+static inline unsigned long long round_member_size_to_mb(unsigned long long size)
 {
-	size /= disk_count;
-	size = (size >> SECT_PER_MB_SHIFT) << SECT_PER_MB_SHIFT;
-	size *= disk_count;
+	return (size >> SECT_PER_MB_SHIFT) << SECT_PER_MB_SHIFT;
+}
 
-	return size;
+/**
+ * round_size_to_mb()- Round given size.
+ * @array_size: size to round in sectors.
+ * @disk_count: count of data members.
+ *
+ * Get size per each data member and round it to closest MiB to ensure that data
+ * splits evenly between members.
+ *
+ * Return: Array size, rounded down.
+ */
+static inline unsigned long long round_size_to_mb(unsigned long long array_size,
+						  unsigned int disk_count)
+{
+	return round_member_size_to_mb(array_size / disk_count) * disk_count;
 }
 
 static int able_to_resync(int raid_level, int missing_disks)
@@ -11749,8 +11761,7 @@ enum imsm_reshape_type imsm_analyze_change(struct supertype *st,
 		} else {
 			/* round size due to metadata compatibility
 			*/
-			geo->size = (geo->size >> SECT_PER_MB_SHIFT)
-				    << SECT_PER_MB_SHIFT;
+			geo->size = round_member_size_to_mb(geo->size);
 			dprintf("Prepare update for size change to %llu\n",
 				geo->size );
 			if (current_size >= geo->size) {
-- 
2.26.2

