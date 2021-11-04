Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87B24C433F5
	for <linux-raid@archiver.kernel.org>; Thu,  4 Nov 2021 13:16:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 63EDE611C9
	for <linux-raid@archiver.kernel.org>; Thu,  4 Nov 2021 13:16:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231663AbhKDNTK (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 4 Nov 2021 09:19:10 -0400
Received: from mga09.intel.com ([134.134.136.24]:46163 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231160AbhKDNTI (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 4 Nov 2021 09:19:08 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10157"; a="231548052"
X-IronPort-AV: E=Sophos;i="5.87,208,1631602800"; 
   d="scan'208";a="231548052"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2021 06:16:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,208,1631602800"; 
   d="scan'208";a="667895924"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.95.202])
  by orsmga005.jf.intel.com with ESMTP; 04 Nov 2021 06:16:29 -0700
From:   Pawel Piatkowski <pawel.piatkowski@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org
Subject: [PATCH] imsm: free allocated memory in imsm_fix_size_mismatch
Date:   Thu,  4 Nov 2021 14:16:22 +0100
Message-Id: <20211104131622.3563-1-pawel.piatkowski@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Free allocated memory stored in variable named update

Signed-off-by: Pawel Piatkowski <pawel.piatkowski@intel.com>
---
 super-intel.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/super-intel.c b/super-intel.c
index 08c64409..4f8d9747 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -11798,6 +11798,8 @@ static int imsm_fix_size_mismatch(struct supertype *st, int subarray_index)
 		} else {
 			imsm_sync_metadata(st);
 		}
+
+		free(update);
 	}
 	ret_val = 0;
 exit:
-- 
2.26.2

