Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,DATE_IN_PAST_06_12,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB9C3C433E6
	for <linux-raid@archiver.kernel.org>; Fri, 15 Jan 2021 13:29:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ABCAF22583
	for <linux-raid@archiver.kernel.org>; Fri, 15 Jan 2021 13:29:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731958AbhAON3Q (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 15 Jan 2021 08:29:16 -0500
Received: from mga18.intel.com ([134.134.136.126]:10827 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731831AbhAON3P (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Fri, 15 Jan 2021 08:29:15 -0500
IronPort-SDR: KnbCXRccV2Iw/ZepzKi+MEJKqRa2KsLy6l8SRHGkSfwrEJ0cnSXfHX/VqKcGSyGMFMdeCIAUFp
 LbacloPJiZuw==
X-IronPort-AV: E=McAfee;i="6000,8403,9864"; a="166216217"
X-IronPort-AV: E=Sophos;i="5.79,349,1602572400"; 
   d="scan'208";a="166216217"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2021 05:25:38 -0800
IronPort-SDR: J9Qq5dz8H74MvqFePsAbSWItisdg9OcMB8qY4xbPe2udCfHberwfQK74i2T3OOg96W+S1naUMz
 WFfj9NYy6Yjw==
X-IronPort-AV: E=Sophos;i="5.79,349,1602572400"; 
   d="scan'208";a="425312450"
Received: from unknown (HELO localhost.igk.intel.com) ([10.237.126.111])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2021 05:25:37 -0800
From:   Jakub Radtke <jakub.radtke@linux.intel.com>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH 8/8] Grow: Block reshape when external metadata and write-intent bitmap
Date:   Fri, 15 Jan 2021 00:47:01 -0500
Message-Id: <20210115054701.92064-9-jakub.radtke@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210115054701.92064-1-jakub.radtke@linux.intel.com>
References: <20210115054701.92064-1-jakub.radtke@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Jakub Radtke <jakub.radtke@intel.com>

Current kernel sysfs interface for the bitmap is limited. It allows
the applying of the bitmap on non-active volumes only.
The reshape operation for a volume with a bitmap should be blocked.

Signed-off-by: Jakub Radtke <jakub.radtke@intel.com>
Change-Id: I2b4f57d6934815cd63a9cf506328b89fa4aa3930
---
 Grow.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/Grow.c b/Grow.c
index 6b8321c5..a48789ce 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1838,15 +1838,14 @@ int Grow_reshape(char *devname, int fd,
 		pr_err("Cannot increase raid-disks on this array beyond %d\n", st->max_devs);
 		return 1;
 	}
-	if (s->level == 0 &&
-	    (array.state & (1<<MD_SB_BITMAP_PRESENT)) &&
-	    !(array.state & (1<<MD_SB_CLUSTERED))) {
-                array.state &= ~(1<<MD_SB_BITMAP_PRESENT);
-                if (md_set_array_info(fd, &array)!= 0) {
-                        pr_err("failed to remove internal bitmap.\n");
-                        return 1;
-                }
-        }
+	if (s->level == 0 && (array.state & (1 << MD_SB_BITMAP_PRESENT)) &&
+		!(array.state & (1 << MD_SB_CLUSTERED)) && !st->ss->external) {
+		array.state &= ~(1 << MD_SB_BITMAP_PRESENT);
+		if (md_set_array_info(fd, &array) != 0) {
+			pr_err("failed to remove internal bitmap.\n");
+			return 1;
+		}
+	}
 
 	/* in the external case we need to check that the requested reshape is
 	 * supported, and perform an initial check that the container holds the
@@ -1910,6 +1909,13 @@ int Grow_reshape(char *devname, int fd,
 					free(subarray);
 					return 1;
 				}
+				if (content->consistency_policy ==
+				    CONSISTENCY_POLICY_BITMAP) {
+					pr_err("Operation not supported when write-intent bitmap is enabled\n");
+					sysfs_free(cc);
+					free(subarray);
+					return 1;
+				}
 			}
 			sysfs_free(cc);
 		}
-- 
2.26.2

