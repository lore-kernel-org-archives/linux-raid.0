Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DATE_IN_PAST_96_XX,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69925C43332
	for <linux-raid@archiver.kernel.org>; Fri,  5 Mar 2021 12:02:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A09A6501B
	for <linux-raid@archiver.kernel.org>; Fri,  5 Mar 2021 12:02:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbhCEMC3 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 5 Mar 2021 07:02:29 -0500
Received: from mga04.intel.com ([192.55.52.120]:35709 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229687AbhCEMCE (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Fri, 5 Mar 2021 07:02:04 -0500
IronPort-SDR: rP2qbTGVEvSip/5vONVvTxvIj73JgQktf1Pb9LqV1dFmvyA8TGaA9Kw34gzOEgjhcjUrTO1Exp
 Yqm3bgoLzCFg==
X-IronPort-AV: E=McAfee;i="6000,8403,9913"; a="185230275"
X-IronPort-AV: E=Sophos;i="5.81,224,1610438400"; 
   d="scan'208";a="185230275"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2021 04:02:04 -0800
IronPort-SDR: Q2SqNBv7ZwQKk63TQzpgrtc6SC6hPstFxNzs831rPWSEdijeRvd0KrJHa5KarLHkv9Q6rHjTS1
 fdj90g69gAQA==
X-IronPort-AV: E=Sophos;i="5.81,224,1610438400"; 
   d="scan'208";a="401656631"
Received: from unknown (HELO localhost.igk.intel.com) ([10.237.126.111])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2021 04:02:03 -0800
From:   Jakub Radtke <jakub.radtke@linux.intel.com>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH 6/8] imsm: Update-subarray for write-intent bitmap
Date:   Thu, 24 Sep 2020 20:03:02 -0400
Message-Id: <20200925000304.169728-7-jakub.radtke@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200925000304.169728-1-jakub.radtke@linux.intel.com>
References: <20200925000304.169728-1-jakub.radtke@linux.intel.com>
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

