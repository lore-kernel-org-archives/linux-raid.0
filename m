Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DATE_IN_PAST_96_XX,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CE64C4332D
	for <linux-raid@archiver.kernel.org>; Fri,  5 Mar 2021 12:02:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D968D6501B
	for <linux-raid@archiver.kernel.org>; Fri,  5 Mar 2021 12:02:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbhCEMCa (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 5 Mar 2021 07:02:30 -0500
Received: from mga04.intel.com ([192.55.52.120]:35709 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229719AbhCEMCJ (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Fri, 5 Mar 2021 07:02:09 -0500
IronPort-SDR: HtaV3MfbyhKjBH034vkEL2mvkNoXzYhU/DBnJMIJEBQQA+SieLutVITNL3yg96H4XjTXdJYsHm
 6BuVdqcblCAQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9913"; a="185230321"
X-IronPort-AV: E=Sophos;i="5.81,224,1610438400"; 
   d="scan'208";a="185230321"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2021 04:02:08 -0800
IronPort-SDR: NvtmijTguQ9YUufmUXyqMFD6D69W6cAPRsJrlAG01xw2dThb6vMdFfITRXrwX7r5CeFXQfFHEL
 thnA9TarHDQQ==
X-IronPort-AV: E=Sophos;i="5.81,224,1610438400"; 
   d="scan'208";a="401656641"
Received: from unknown (HELO localhost.igk.intel.com) ([10.237.126.111])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2021 04:02:08 -0800
From:   Jakub Radtke <jakub.radtke@linux.intel.com>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH 8/8] Grow: Block reshape when external metadata and write-intent bitmap
Date:   Thu, 24 Sep 2020 20:03:04 -0400
Message-Id: <20200925000304.169728-9-jakub.radtke@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200925000304.169728-1-jakub.radtke@linux.intel.com>
References: <20200925000304.169728-1-jakub.radtke@linux.intel.com>
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

