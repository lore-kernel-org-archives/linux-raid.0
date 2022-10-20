Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F25EC433FE
	for <linux-raid@archiver.kernel.org>; Thu, 20 Oct 2022 11:57:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbiJTL5Y (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 20 Oct 2022 07:57:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbiJTL5X (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 20 Oct 2022 07:57:23 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A309134DFB
        for <linux-raid@vger.kernel.org>; Thu, 20 Oct 2022 04:57:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666267042; x=1697803042;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=vnvVVfi/ZMEAz10yimtTxnzkmNcWiSP9CttnEmiaV84=;
  b=D7/rCt3qWtF1ReaXeAZa6NQqGHh1EyEZMksMFAVkcfI1rdqtObGSVunM
   owBgkcUR8tHA95IchdqYQnSGeLD0sS1cpUfDa1lpGxXHWXrAgLu1DwyY8
   jXBzjrLwqz2B78GIVDI02mn5L45DMs1lidofNOBhixOEh6WeznOJUvRmh
   4/bQl+0gR7C1NI7VvVIr2aAAx9sWngaKeHZal8P/xV1IxpflgbGfyFPdV
   2Ei6RIO8mbeWfKXar77d5VknZ8ku91yRbuHPwPtjnzVsovHbGXhOfbEDr
   MxMkLnHPjAXM7jvhl1RTiY7dr7C2a8aaTmOpOgS/4Fqsc/dLPrE1cM8Lc
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10505"; a="307784055"
X-IronPort-AV: E=Sophos;i="5.95,198,1661842800"; 
   d="scan'208";a="307784055"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2022 04:57:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10505"; a="663000782"
X-IronPort-AV: E=Sophos;i="5.95,198,1661842800"; 
   d="scan'208";a="663000782"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.92.203])
  by orsmga001.jf.intel.com with ESMTP; 20 Oct 2022 04:57:20 -0700
From:   Kinga Tanska <kinga.tanska@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org, colyli@suse.de
Subject: [PATCH] super-intel: make freesize not required for chunk size migration
Date:   Thu, 20 Oct 2022 06:59:03 +0200
Message-Id: <20221020045903.19950-1-kinga.tanska@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Freesize is not required when chunk size migration is performed. Fix
return value when superblock is not set.

Signed-off-by: Kinga Tanska <kinga.tanska@intel.com>
---
 super-intel.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 4d82af3d..37c59da5 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -7714,11 +7714,11 @@ static int validate_geometry_imsm(struct supertype *st, int level, int layout,
 		struct intel_super *super = st->sb;
 
 		/*
-		 * Autolayout mode, st->sb and freesize must be set.
+		 * Autolayout mode, st->sb must be set.
 		 */
-		if (!super || !freesize) {
-			pr_vrb("freesize and superblock must be set for autolayout, aborting\n");
-			return 1;
+		if (!super) {
+			pr_vrb("superblock must be set for autolayout, aborting\n");
+			return 0;
 		}
 
 		if (!validate_geometry_imsm_orom(st->sb, level, layout,
@@ -7726,7 +7726,7 @@ static int validate_geometry_imsm(struct supertype *st, int level, int layout,
 						 verbose))
 			return 0;
 
-		if (super->orom) {
+		if (super->orom && freesize) {
 			imsm_status_t rv;
 			int count = count_volumes(super->hba, super->orom->dpa,
 					      verbose);
-- 
2.26.2

