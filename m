Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E230EC433EF
	for <linux-raid@archiver.kernel.org>; Fri, 25 Mar 2022 11:49:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352380AbiCYLvA (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 25 Mar 2022 07:51:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345320AbiCYLu7 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 25 Mar 2022 07:50:59 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5F32D3AFC
        for <linux-raid@vger.kernel.org>; Fri, 25 Mar 2022 04:49:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648208965; x=1679744965;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=AtsMHFVU45BKwWtIT6m9HwmIU+3sHP2d8PdNDeN+EHw=;
  b=jz+IOVAQPLpN9LzAmXZeJoY+3X1SedRpgWlDEwdEpRxMAuCP7Utulss3
   T+htPesZEstQaAfbOw0C+yr6KYd33iYDLFuEVHQP5NXjwKpfdP34z7Jxc
   K45t4BHG+U43qmaC5jvs7DkoNtdKvf8P17MDdp+RxJVtKRCisG5AnAHie
   Rba6WmtILbo3ebdbQl/l1YQRv1nrUCY3fj2x/63z6p4cXJSzt1vPScOrM
   MIdITmb3AHe1nYI97N1eyJrCen0dkYVI8X7uXvuWhbrk9B+l3rdROKAIY
   +r5PbFSa+29n5b7pkzMvG7R6msgrLuZOuDrFTJqO/Kt/QnFoE7j6vgCnk
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10296"; a="321811283"
X-IronPort-AV: E=Sophos;i="5.90,209,1643702400"; 
   d="scan'208";a="321811283"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2022 04:49:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,209,1643702400"; 
   d="scan'208";a="602028328"
Received: from unknown (HELO gklab-109-9.igk.intel.com) ([10.102.109.9])
  by fmsmga008.fm.intel.com with ESMTP; 25 Mar 2022 04:49:24 -0700
From:   Lukasz Florczak <lukasz.florczak@linux.intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org, colyli@suse.de
Subject: [PATCH] mdadm: Fix double free
Date:   Fri, 25 Mar 2022 12:48:59 +0100
Message-Id: <20220325114859.525589-1-lukasz.florczak@linux.intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

If there was a size mismatch after creation it would get fixed on grow
in imsm_fix_size_mismatch(), but due to double free "double free or corruption (fasttop)"
error occurs and grow cannot proceed.

Signed-off-by: Lukasz Florczak <lukasz.florczak@linux.intel.com>
---
 super-intel.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index d5fad102..bf6ba9ff 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -11783,9 +11783,8 @@ static int imsm_fix_size_mismatch(struct supertype *st, int subarray_index)
 			st->update_tail = &st->updates;
 		} else {
 			imsm_sync_metadata(st);
+			free(update);
 		}
-
-		free(update);
 	}
 	ret_val = 0;
 exit:
-- 
2.27.0

