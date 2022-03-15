Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37148C433EF
	for <linux-raid@archiver.kernel.org>; Tue, 15 Mar 2022 08:31:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345947AbiCOIcJ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 15 Mar 2022 04:32:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345924AbiCOIcI (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 15 Mar 2022 04:32:08 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C62014C40F
        for <linux-raid@vger.kernel.org>; Tue, 15 Mar 2022 01:30:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647333056; x=1678869056;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=FZR5yjr0dQuPT0DAop7Ctn+YpdxmzbjqraHJOwbjkek=;
  b=RMbsoyH3dnJyq5kdKi95ZAg5KCYP5QujmGjjcMwrfGQ7geRETy0tFWIx
   7Lm/iu4to0Y6aBKDVqt3t0KGpNc023r2e0aOxC2gUoh3jezf12Wx882ZQ
   fAbBHH5jUZt/3Pxs6sJEseFM2tPWKFRPfDpxokJbt/1eHBqPOkI2P7xUV
   d+rLd3zFrI/SC17ry1SGj9fj/WIQmIRl7ypEKgRYh+G3z0EJwFJA9s9KN
   Sv4HigY45bhNg1lamkkq/tRVn+oJkzstcptY8D32Jbx+MGvAaU3A20m5x
   WZKmd03mxXbJZMaci0PLpHfdUGi8LVaCM/I+tFEtbMnOOpnVP2KBAzenM
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10286"; a="281014073"
X-IronPort-AV: E=Sophos;i="5.90,182,1643702400"; 
   d="scan'208";a="281014073"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2022 01:30:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,182,1643702400"; 
   d="scan'208";a="540339344"
Received: from unknown (HELO gklab-109-9.igk.intel.com) ([10.102.109.9])
  by orsmga007.jf.intel.com with ESMTP; 15 Mar 2022 01:30:50 -0700
From:   Lukasz Florczak <lukasz.florczak@linux.intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org, colyli@suse.de
Subject: [PATCH] Unify error message.
Date:   Tue, 15 Mar 2022 09:30:30 +0100
Message-Id: <20220315083030.58992-1-lukasz.florczak@linux.intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Provide the same error message for the same error that can occur in Grow.c and super-intel.c.

Signed-off-by: Lukasz Florczak <lukasz.florczak@linux.intel.com>
---
 Grow.c        | 4 ++--
 super-intel.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/Grow.c b/Grow.c
index 9c6fc95e..9a947204 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1001,8 +1001,8 @@ int remove_disks_for_takeover(struct supertype *st,
 				rv = 1;
 			sysfs_free(arrays);
 			if (rv) {
-				pr_err("Error. Cannot perform operation on /dev/%s\n", st->devnm);
-				pr_err("For this operation it MUST be single array in container\n");
+				pr_err("Error. Cannot perform operation on %s- for this operation "
+				       "it MUST be single array in container\n", st->devnm);
 				return rv;
 			}
 		}
diff --git a/super-intel.c b/super-intel.c
index d5fad102..5ffa7636 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -11683,8 +11683,8 @@ enum imsm_reshape_type imsm_analyze_change(struct supertype *st,
 		struct imsm_super *mpb = super->anchor;
 
 		if (mpb->num_raid_devs > 1) {
-			pr_err("Error. Cannot perform operation on %s- for this operation it MUST be single array in container\n",
-			       geo->dev_name);
+			pr_err("Error. Cannot perform operation on %s- for this operation "
+			       "it MUST be single array in container\n", geo->dev_name);
 			change = -1;
 		}
 	}
-- 
2.27.0

