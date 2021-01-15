Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,DATE_IN_PAST_06_12,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03F40C433DB
	for <linux-raid@archiver.kernel.org>; Fri, 15 Jan 2021 13:29:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C324822583
	for <linux-raid@archiver.kernel.org>; Fri, 15 Jan 2021 13:29:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729700AbhAON3Q (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 15 Jan 2021 08:29:16 -0500
Received: from mga18.intel.com ([134.134.136.126]:10822 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731576AbhAON3O (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Fri, 15 Jan 2021 08:29:14 -0500
IronPort-SDR: GPYUGOh8xf0114uxzZ0Kuwh9VGzXXAa6mQurmlBNtpGdbDXZSdy/ClxLCelGLn9StSsrce/UnO
 L9Y9krd/GmDA==
X-IronPort-AV: E=McAfee;i="6000,8403,9864"; a="166216195"
X-IronPort-AV: E=Sophos;i="5.79,349,1602572400"; 
   d="scan'208";a="166216195"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2021 05:25:34 -0800
IronPort-SDR: NesPcqyp97HrgASufzedxgKKxcOdzhPrBxRd1F6L6uycXnMQ9IFd16voBR8JkWcPrqGDMJzZjx
 zu2GbwjGLdtg==
X-IronPort-AV: E=Sophos;i="5.79,349,1602572400"; 
   d="scan'208";a="425312432"
Received: from unknown (HELO localhost.igk.intel.com) ([10.237.126.111])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2021 05:25:33 -0800
From:   Jakub Radtke <jakub.radtke@linux.intel.com>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH 6/8] imsm: Update-subarray for write-intent bitmap
Date:   Fri, 15 Jan 2021 00:46:59 -0500
Message-Id: <20210115054701.92064-7-jakub.radtke@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210115054701.92064-1-jakub.radtke@linux.intel.com>
References: <20210115054701.92064-1-jakub.radtke@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Jakub Radtke <jakub.radtke@intel.com>

The patch updates the current bitmap functionality to handle adding
the bitmap on existing volumes.

Change-Id: I75c4a2a450858204457f45b4daeecfd807c83834
Signed-off-by: Jakub Radtke <jakub.radtke@intel.com>
---
 super-intel.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index eb5d39b9..0f3bbdf2 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -7783,6 +7783,19 @@ static int kill_subarray_imsm(struct supertype *st, char *subarray_id)
 	return 0;
 }
 
+static int get_rwh_policy_from_update(char *update)
+{
+	if (strcmp(update, "ppl") == 0)
+		return RWH_MULTIPLE_DISTRIBUTED;
+	else if (strcmp(update, "no-ppl") == 0)
+		return RWH_MULTIPLE_OFF;
+	else if (strcmp(update, "bitmap") == 0)
+		return RWH_BITMAP;
+	else if (strcmp(update, "no-bitmap") == 0)
+		return RWH_OFF;
+	return -1;
+}
+
 static int update_subarray_imsm(struct supertype *st, char *subarray,
 				char *update, struct mddev_ident *ident)
 {
@@ -7829,8 +7842,7 @@ static int update_subarray_imsm(struct supertype *st, char *subarray,
 			}
 			super->updates_pending++;
 		}
-	} else if (strcmp(update, "ppl") == 0 ||
-		   strcmp(update, "no-ppl") == 0) {
+	} else if (get_rwh_policy_from_update(update) != -1) {
 		int new_policy;
 		char *ep;
 		int vol = strtoul(subarray, &ep, 10);
@@ -7838,10 +7850,7 @@ static int update_subarray_imsm(struct supertype *st, char *subarray,
 		if (*ep != '\0' || vol >= super->anchor->num_raid_devs)
 			return 2;
 
-		if (strcmp(update, "ppl") == 0)
-			new_policy = RWH_MULTIPLE_DISTRIBUTED;
-		else
-			new_policy = RWH_MULTIPLE_OFF;
+		new_policy = get_rwh_policy_from_update(update);
 
 		if (st->update_tail) {
 			struct imsm_update_rwh_policy *u = xmalloc(sizeof(*u));
@@ -7857,6 +7866,8 @@ static int update_subarray_imsm(struct supertype *st, char *subarray,
 			dev->rwh_policy = new_policy;
 			super->updates_pending++;
 		}
+		if (new_policy == RWH_BITMAP)
+			return write_init_bitmap_imsm_vol(st, vol);
 	} else
 		return 2;
 
-- 
2.26.2

