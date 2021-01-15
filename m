Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,DATE_IN_PAST_06_12,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0343DC433E9
	for <linux-raid@archiver.kernel.org>; Fri, 15 Jan 2021 13:28:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BFF1A2339D
	for <linux-raid@archiver.kernel.org>; Fri, 15 Jan 2021 13:28:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732744AbhAON1y (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 15 Jan 2021 08:27:54 -0500
Received: from mga18.intel.com ([134.134.136.126]:10822 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732063AbhAON1y (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Fri, 15 Jan 2021 08:27:54 -0500
IronPort-SDR: gktB1NOlM9rH3G6Fdm2DmYPzMVwF+MUzNg4vtDJuDpnsIv7bMSSSYU9zUDxrVjgktqtCr5ldas
 hVMsAbCKhnVw==
X-IronPort-AV: E=McAfee;i="6000,8403,9864"; a="166216174"
X-IronPort-AV: E=Sophos;i="5.79,349,1602572400"; 
   d="scan'208";a="166216174"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2021 05:25:30 -0800
IronPort-SDR: DpOe27GM9I9xXxpR2HdcDc+hbQWnSHbVfN4zjyDuJZ7iPOLyBz9juEVRSuab0jvnNfD63yQjH+
 BlxLKMMaSEdw==
X-IronPort-AV: E=Sophos;i="5.79,349,1602572400"; 
   d="scan'208";a="425312415"
Received: from unknown (HELO localhost.igk.intel.com) ([10.237.126.111])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2021 05:25:29 -0800
From:   Jakub Radtke <jakub.radtke@linux.intel.com>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH 4/8] imsm: Adding a spare to an existing array with bitmap
Date:   Fri, 15 Jan 2021 00:46:57 -0500
Message-Id: <20210115054701.92064-5-jakub.radtke@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210115054701.92064-1-jakub.radtke@linux.intel.com>
References: <20210115054701.92064-1-jakub.radtke@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Jakub Radtke <jakub.radtke@intel.com>

When adding a spare to an existing array with bitmap, an additional
initialization (adding bitmap header and preparing the bitmap area)
is required.

Signed-off-by: Jakub Radtke <jakub.radtke@intel.com>
Change-Id: Icaced458f4a1dd7777fce60660b749301c8496e8
---
 super-intel.c | 37 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 36 insertions(+), 1 deletion(-)

diff --git a/super-intel.c b/super-intel.c
index edb1c60e..eb5d39b9 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -9537,6 +9537,39 @@ static int apply_size_change_update(struct imsm_update_size_change *u,
 	return ret_val;
 }
 
+static int prepare_spare_to_activate(struct supertype *st,
+				     struct imsm_update_activate_spare *u)
+{
+	struct intel_super *super = st->sb;
+	int prev_current_vol = super->current_vol;
+	struct active_array *a;
+	int ret = 1;
+
+	for (a = st->arrays; a; a = a->next)
+		/*
+		 * Additional initialization (adding bitmap header, filling
+		 * the bitmap area with '1's to force initial rebuild for a whole
+		 * data-area) is required when adding the spare to the volume
+		 * with write-intent bitmap.
+		 */
+		if (a->info.container_member == u->array &&
+		    a->info.consistency_policy == CONSISTENCY_POLICY_BITMAP) {
+			struct dl *dl;
+
+			for (dl = super->disks; dl; dl = dl->next)
+				if (dl == u->dl)
+					break;
+			if (!dl)
+				break;
+
+			super->current_vol = u->array;
+			if (st->ss->write_bitmap(st, dl->fd, NoUpdate))
+				ret = 0;
+			super->current_vol = prev_current_vol;
+		}
+	return ret;
+}
+
 static int apply_update_activate_spare(struct imsm_update_activate_spare *u,
 				       struct intel_super *super,
 				       struct active_array *active_array)
@@ -9961,7 +9994,9 @@ static void imsm_process_update(struct supertype *st,
 	}
 	case update_activate_spare: {
 		struct imsm_update_activate_spare *u = (void *) update->buf;
-		if (apply_update_activate_spare(u, super, st->arrays))
+
+		if (prepare_spare_to_activate(st, u) &&
+		    apply_update_activate_spare(u, super, st->arrays))
 			super->updates_pending++;
 		break;
 	}
-- 
2.26.2

