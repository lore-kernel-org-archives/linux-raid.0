Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E58AC3F6B0
	for <linux-raid@archiver.kernel.org>; Thu, 18 Aug 2022 14:57:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343871AbiHRO5k (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 18 Aug 2022 10:57:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343892AbiHRO5c (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 18 Aug 2022 10:57:32 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F99CB4438
        for <linux-raid@vger.kernel.org>; Thu, 18 Aug 2022 07:57:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660834649; x=1692370649;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XjmXysXw8LYhPwUSLbjE+T5vn8cj2cYlxDy8Uxh9VOA=;
  b=bYOKcsQAnuBDvyzvOd1pHqug/0TR95blu/Wrlk+SMLkMZxg2ccBI5a1O
   QOHDViUWBKlGHHiV6B4DMU9pNWKUmq7AUDQk4zEmL9iA1jvwJgpov7dcm
   26wtqmYY4+R556WBaaDTffI1Bz2bojBt6bKNR5QxEb3sJw5LyI7PSAUeV
   52X056nDqaWPmZTSluFe7JV6/LD8m+03Mnp79ErbQxqLPqDF0qve0vZiq
   UBMxnSLt9JaTRExIYFzBW9tX14d0b3doKFcNuaXT+4eVpAEts6hBxjoS2
   WtW18D3KUu+mSD16Jngla3k4I8RKqxQRarLWJ11uHECJLg11tGbdv8K+5
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10443"; a="356766111"
X-IronPort-AV: E=Sophos;i="5.93,246,1654585200"; 
   d="scan'208";a="356766111"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 07:57:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,246,1654585200"; 
   d="scan'208";a="676084420"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.92.52])
  by fmsmga004.fm.intel.com with ESMTP; 18 Aug 2022 07:57:27 -0700
From:   Mateusz Kusiak <mateusz.kusiak@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org, colyli@suse.de
Subject: [PATCH 02/10] Fix --update-subarray on active volume
Date:   Thu, 18 Aug 2022 16:56:13 +0200
Message-Id: <20220818145621.21982-3-mateusz.kusiak@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220818145621.21982-1-mateusz.kusiak@intel.com>
References: <20220818145621.21982-1-mateusz.kusiak@intel.com>
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
index e5e6abe4..b9f0b184 100644
--- a/Manage.c
+++ b/Manage.c
@@ -1694,6 +1694,13 @@ int Update_subarray(char *dev, char *subarray, char *update, struct mddev_ident
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
index 4ddfcf94..672f946e 100644
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

