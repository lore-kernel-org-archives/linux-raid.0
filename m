Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12C38C433EF
	for <linux-raid@archiver.kernel.org>; Fri, 22 Jul 2022 06:42:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234054AbiGVGmY (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 22 Jul 2022 02:42:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234308AbiGVGmU (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 22 Jul 2022 02:42:20 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8B82868B9
        for <linux-raid@vger.kernel.org>; Thu, 21 Jul 2022 23:42:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658472139; x=1690008139;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YlepH2cXqH2l3b8yV47Fx6TAf5k51fKfGZ3QpS59gKU=;
  b=j8FYDvr3FBs5vPHfhTivTNaVkJsLCAFq0yN/ILH4AJA4BsLUKBL6HyeY
   1LI+hGnng50P8OtgDE/MzGLxl7HmNv54yezQzqD3NPSVAHm7TUhc6Z8G2
   jf+0NvW3S0yl11sobBQFJP5YUqcS14cH2wZQ7C+dO+rXPrmnwCURAXQ3A
   /qmGcwXO51GwnBnEqLer6YfnIorWluv+s7x58sT6C7eSdU9nBOzHK/gb4
   /nToRIG+Sv172joaHWLXGNOnPUyEKk/OzTZYXqpz8FGGeqiSsI5g7RpMR
   jt1J+6VboJWKIvWz+UlLfqMhLxYO13TtfFyEAXTLr+1DCg9sQThVViF2S
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10415"; a="287254966"
X-IronPort-AV: E=Sophos;i="5.93,184,1654585200"; 
   d="scan'208";a="287254966"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2022 23:42:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,184,1654585200"; 
   d="scan'208";a="657096216"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.108.83])
  by fmsmga008.fm.intel.com with ESMTP; 21 Jul 2022 23:42:19 -0700
From:   Lukasz Florczak <lukasz.florczak@linux.intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org
Subject: [PATCH 2/2 RESEND] mdadm: Remove dead code in imsm_fix_size_mismatch
Date:   Fri, 22 Jul 2022 08:43:48 +0200
Message-Id: <20220722064348.32136-3-lukasz.florczak@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220722064348.32136-1-lukasz.florczak@linux.intel.com>
References: <20220722064348.32136-1-lukasz.florczak@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

imsm_create_metadata_update_for_size_change() that returns u_size value
could return 0 in the past. As its behavior changed, and returned value
is always the size of imsm_update_size_change structure, check for
u_size is no longer needed.

Signed-off-by: Lukasz Florczak <lukasz.florczak@linux.intel.com>
---
 super-intel.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 102689bc..cb5292e1 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -11772,10 +11772,6 @@ static int imsm_fix_size_mismatch(struct supertype *st, int subarray_index)
 		geo.size = d_size;
 		u_size = imsm_create_metadata_update_for_size_change(st, &geo,
 								     &update);
-		if (u_size < 1) {
-			dprintf("imsm: Cannot prepare size change update\n");
-			goto exit;
-		}
 		imsm_update_metadata_locally(st, update, u_size);
 		if (st->update_tail) {
 			append_metadata_update(st, update, u_size);
-- 
2.27.0

