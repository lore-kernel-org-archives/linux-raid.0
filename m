Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EFE4C7EE2F
	for <linux-raid@archiver.kernel.org>; Wed, 31 May 2023 15:22:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234409AbjEaPWH (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 31 May 2023 11:22:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234459AbjEaPVg (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 31 May 2023 11:21:36 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36198123
        for <linux-raid@vger.kernel.org>; Wed, 31 May 2023 08:21:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685546493; x=1717082493;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kQiywsXRoNwZ0zOaubA1zXONHziZjQgYHbb1qaIbK4Q=;
  b=Zdp4ma9I3Un6dTK4TkAELRpYHmoqdFgan0e/blczO6jK6we1CMWTNhUR
   O6vmOllbdHK6/8gXwOSiLrQFxVAE5JuS7I2B7cvuyzol2PVQeizPfOWe0
   zQ7YuTeyGuwZAkNS9MvmezqBzJW4XycuDOfHV8ku628ODirWgVxd/5wTT
   auouSOcVD57pS6iweltCFgYErsvfJSy+VlnGmP0Pim61SnniBT3XcoOyk
   ikwFGazcT0My2boIhOBoGWXzzyrdJw5vfMNC5wnvrnkfAwXmVQxZaRyqw
   9LL/qtO31qQJ+gbjBNEF6XY1ntNmCRr5TM8z3qtFuLr7SJ+fw+Y9REGE7
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10727"; a="339864916"
X-IronPort-AV: E=Sophos;i="6.00,207,1681196400"; 
   d="scan'208";a="339864916"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2023 08:21:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10727"; a="796747340"
X-IronPort-AV: E=Sophos;i="6.00,207,1681196400"; 
   d="scan'208";a="796747340"
Received: from mtkaczyk-devel.igk.intel.com ([10.102.105.40])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2023 08:21:31 -0700
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org, colyli@suse.de
Subject: [PATCH 3/6] imsm: introduce round_member_size_to_mb()
Date:   Wed, 31 May 2023 17:21:05 +0200
Message-Id: <20230531152108.18103-4-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20230531152108.18103-1-mariusz.tkaczyk@linux.intel.com>
References: <20230531152108.18103-1-mariusz.tkaczyk@linux.intel.com>
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

