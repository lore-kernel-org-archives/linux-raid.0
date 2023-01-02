Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53B6BC4167B
	for <linux-raid@archiver.kernel.org>; Mon,  2 Jan 2023 08:37:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbjABIhb (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 2 Jan 2023 03:37:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231893AbjABIhO (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 2 Jan 2023 03:37:14 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E8B3DB3
        for <linux-raid@vger.kernel.org>; Mon,  2 Jan 2023 00:37:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672648633; x=1704184633;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=N1ip840Sg9LhVOS40jZxldLMPxBPsKJndF/u246Gt1w=;
  b=cG4odLgdzI/mRdUy9nQMV47fXDeJ7G8NYtVkJyGPnJluA0sxPv9BXzC0
   Jki+uA3329SMztE2yzWJrbIeqHyaAoEdGwT4SdLr0XtxB3wQfuib4J4ME
   JAkFMiTEVIMoXg8/9kQbcWs4XDyiKaoL13N4uNff3B8QcreZ0LniAWY8d
   C7KgTw0XW2Jx1ClizKBxBf8cffOOGhZXfEb4qiMuStO3NU4Io/jSEyjLs
   zgm9FSY9VdxlIgZN3jycPUT2ekEJY4ruWTp3QjVF94bApQehXWGKPcaBn
   ZbW1RgnVVFY8QkaqvKuceGmZx3A0NDXpIWUPeikCH218QnbksAXKx8B03
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10577"; a="322685313"
X-IronPort-AV: E=Sophos;i="5.96,293,1665471600"; 
   d="scan'208";a="322685313"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jan 2023 00:37:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10577"; a="647864616"
X-IronPort-AV: E=Sophos;i="5.96,293,1665471600"; 
   d="scan'208";a="647864616"
Received: from unknown (HELO DESKTOP-QODMV9C.igk.intel.com.com) ([10.102.109.29])
  by orsmga007.jf.intel.com with ESMTP; 02 Jan 2023 00:37:11 -0800
From:   Mateusz Kusiak <mateusz.kusiak@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org, colyli@suse.de
Subject: [PATCH v2 02/10] Fix --update-subarray on active volume
Date:   Mon,  2 Jan 2023 09:35:16 +0100
Message-Id: <20230102083524.28893-3-mateusz.kusiak@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20230102083524.28893-1-mateusz.kusiak@intel.com>
References: <20230102083524.28893-1-mateusz.kusiak@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Options: bitmap, ppl and name should not be updated when array is active.
Those features are mutually exclusive and share the same data area in IMSM (danger of overwriting by kernel).
Remove check for active subarrays from super-intel.
Since ddf is not supported, apply it globally for all options.

Signed-off-by: Mateusz Kusiak <mateusz.kusiak@intel.com>
---
 Manage.c      | 7 +++++++
 super-intel.c | 5 -----
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/Manage.c b/Manage.c
index b1d0e630..5a9ea316 100644
--- a/Manage.c
+++ b/Manage.c
@@ -1745,6 +1745,13 @@ int Update_subarray(char *dev, char *subarray, char *update, struct mddev_ident
 		goto free_super;
 	}
 
+	if (is_subarray_active(subarray, st->devnm)) {
+		if (verbose >= 0)
+			pr_err("Subarray %s in %s is active, cannot update %s\n",
+			       subarray, dev, update);
+		goto free_super;
+	}
+
 	if (mdmon_running(st->devnm))
 		st->update_tail = &st->updates;
 
diff --git a/super-intel.c b/super-intel.c
index b0565610..5f93f3d3 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -7914,11 +7914,6 @@ static int update_subarray_imsm(struct supertype *st, char *subarray,
 		char *ep;
 		int vol;
 
-		if (is_subarray_active(subarray, st->devnm)) {
-			pr_err("Unable to update name of active subarray\n");
-			return 2;
-		}
-
 		if (!check_name(super, name, 0))
 			return 2;
 
-- 
2.26.2

