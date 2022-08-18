Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D5C4C25B0E
	for <linux-raid@archiver.kernel.org>; Thu, 18 Aug 2022 14:20:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244837AbiHROUx (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 18 Aug 2022 10:20:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343508AbiHROUv (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 18 Aug 2022 10:20:51 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32887AFAF7
        for <linux-raid@vger.kernel.org>; Thu, 18 Aug 2022 07:20:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660832451; x=1692368451;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=J8q/EG3e+YZD+2ViwIvgzZnFSxL2L20MLea6+q65R8w=;
  b=DrN67HWT3QdL9DdnL5JB6P01qZfRM2WePaesYBcP1Z5iuHCQT1/CdUej
   6Edmuyj//rUVZE4vCSLD8hJzUsU08s07lf9AzH1i5HYr7Fe8U30iWUCaq
   SLglX+Zb10/+bQfHahjilKkz0AOVBrQ2qgkWFysrZ5jAPeH0gQt6u7wsX
   lZ0wqqmK8UPCt5fQN4xENLZrGvzNdAmk7w6VxDljQBTtgEisLHt1ht1zj
   92y/APB2zQ14KPkTbl7JEHxKpL/dHnjS6JCqRDYmyokUn+F5boPk6HOgI
   6ab3OZqQuCNN2hJc9oOFF1rEW4V9v9Hn5mZoCjZWLbQ5mDNFS0ww3/AXv
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10443"; a="356757969"
X-IronPort-AV: E=Sophos;i="5.93,246,1654585200"; 
   d="scan'208";a="356757969"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 07:20:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,246,1654585200"; 
   d="scan'208";a="636840649"
Received: from unknown (HELO unbrick.amr.corp.intel.com) ([10.102.92.203])
  by orsmga008.jf.intel.com with ESMTP; 18 Aug 2022 07:20:27 -0700
From:   Kinga Tanska <kinga.tanska@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org, colyli@suse.de
Subject: [PATCH v3 1/2] Assemble: check if device is container before scheduling force-clean update
Date:   Thu, 18 Aug 2022 09:20:40 +0200
Message-Id: <20220818072041.13586-2-kinga.tanska@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220818072041.13586-1-kinga.tanska@intel.com>
References: <20220818072041.13586-1-kinga.tanska@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Up to now using assemble with force flag making each array as clean.
Force-clean should not be done for the container. This commit add
check if device is different than container before cleaning.

Signed-off-by: Kinga Tanska <kinga.tanska@intel.com>
---
 Assemble.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index 704b8293..f31372db 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -1813,10 +1813,9 @@ try_again:
 		}
 #endif
 	}
-	if (c->force && !clean &&
+	if (c->force && !clean && content->array.level != LEVEL_CONTAINER &&
 	    !enough(content->array.level, content->array.raid_disks,
-		    content->array.layout, clean,
-		    avail)) {
+		    content->array.layout, clean, avail)) {
 		change += st->ss->update_super(st, content, "force-array",
 					       devices[chosen_drive].devname, c->verbose,
 					       0, NULL);
-- 
2.26.2

