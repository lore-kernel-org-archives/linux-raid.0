Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,DATE_IN_PAST_06_12,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD5FAC433E6
	for <linux-raid@archiver.kernel.org>; Fri, 15 Jan 2021 13:26:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD8982339D
	for <linux-raid@archiver.kernel.org>; Fri, 15 Jan 2021 13:26:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732319AbhAON0e (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 15 Jan 2021 08:26:34 -0500
Received: from mga18.intel.com ([134.134.136.126]:10830 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732290AbhAON0d (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Fri, 15 Jan 2021 08:26:33 -0500
IronPort-SDR: tcoshrhGIdFmhjiB5lKfNeqHo4vv5IMJtuiX10aPOzT+DFkEfu/ApELhMi3MnxzqQ45mVErFts
 T4wzJ9y62J4Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9864"; a="166216147"
X-IronPort-AV: E=Sophos;i="5.79,349,1602572400"; 
   d="scan'208";a="166216147"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2021 05:25:26 -0800
IronPort-SDR: LUvSbFlhlpkx8R9T9bovHcNM5Tr2EZUEMG9DvJrXHAPkX87nQQtvF31zjfYTV2bsmOc8+bZGjx
 lIsZqFx2/L4Q==
X-IronPort-AV: E=Sophos;i="5.79,349,1602572400"; 
   d="scan'208";a="425312408"
Received: from unknown (HELO localhost.igk.intel.com) ([10.237.126.111])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2021 05:25:25 -0800
From:   Jakub Radtke <jakub.radtke@linux.intel.com>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH 2/8] Enable bitmap support for external metadata
Date:   Fri, 15 Jan 2021 00:46:55 -0500
Message-Id: <20210115054701.92064-3-jakub.radtke@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210115054701.92064-1-jakub.radtke@linux.intel.com>
References: <20210115054701.92064-1-jakub.radtke@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Jakub Radtke <jakub.radtke@intel.com>

The patch enables the implementation of a write-intent bitmap for external
metadata.
Configuration of the internal bitmaps for non-native metadata requires the
extension in superswitch to perform an additional sysfs setup before the
array is activated.

Change-Id: I77be689b9f4f815dd00bb14ef52267686b273fb5
Signed-off-by: Jakub Radtke <jakub.radtke@intel.com>
---
 Assemble.c |  6 ++++++
 Create.c   | 10 ++++++++++
 mdadm.h    |  3 +++
 3 files changed, 19 insertions(+)

diff --git a/Assemble.c b/Assemble.c
index ed0ddfb1..479ff5ec 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -2094,6 +2094,12 @@ int assemble_container_content(struct supertype *st, int mdfd,
 		}
 	}
 
+	/* Before activating the array, perform extra steps required to configure the internal
+	 * write-intent bitmap.
+	 */
+	if (content->consistency_policy == CONSISTENCY_POLICY_BITMAP &&
+	    st->ss->set_bitmap)
+		st->ss->set_bitmap(st, content);
 
 	if (start_reshape) {
 		int spare = content->array.raid_disks + expansion;
diff --git a/Create.c b/Create.c
index 51f8826b..751f18c1 100644
--- a/Create.c
+++ b/Create.c
@@ -989,6 +989,16 @@ int Create(struct supertype *st, char *mddev,
 				st->ss->free_super(st);
 				goto abort_locked;
 			}
+			/* Before activating the array, perform extra steps required
+			 * to configure the internal write-intent bitmap.
+			 */
+			if (info_new.consistency_policy ==
+				    CONSISTENCY_POLICY_BITMAP &&
+			    st->ss->set_bitmap &&
+			    st->ss->set_bitmap(st, &info)) {
+				st->ss->free_super(st);
+				goto abort_locked;
+			}
 
 			/* update parent container uuid */
 			if (me) {
diff --git a/mdadm.h b/mdadm.h
index 1ee6c92e..0cf94239 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -1006,6 +1006,9 @@ extern struct superswitch {
 	int (*add_internal_bitmap)(struct supertype *st, int *chunkp,
 				   int delay, int write_behind,
 				   unsigned long long size, int may_change, int major);
+	/* Perform additional setup required to activate a bitmap.
+	 */
+	int (*set_bitmap)(struct supertype *st, struct mdinfo *info);
 	/* Seek 'fd' to start of write-intent-bitmap.  Must be an
 	 * md-native format bitmap
 	 */
-- 
2.26.2

