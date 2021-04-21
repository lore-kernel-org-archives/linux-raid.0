Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1F0CC433ED
	for <linux-raid@archiver.kernel.org>; Wed, 21 Apr 2021 14:50:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 976C3600EF
	for <linux-raid@archiver.kernel.org>; Wed, 21 Apr 2021 14:50:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240146AbhDUOu4 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 21 Apr 2021 10:50:56 -0400
Received: from mga05.intel.com ([192.55.52.43]:18468 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238737AbhDUOu4 (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 21 Apr 2021 10:50:56 -0400
IronPort-SDR: MXBZp+p9nulr4xB/nh2Oa4z+lejEi1oKMjbwSJ4/oWu+x2WBWK6jDcIpTVWhaIyVThSCYIkjuV
 yzkDBQmewa5g==
X-IronPort-AV: E=McAfee;i="6200,9189,9961"; a="281039486"
X-IronPort-AV: E=Sophos;i="5.82,240,1613462400"; 
   d="scan'208";a="281039486"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2021 07:50:23 -0700
IronPort-SDR: YsbPDShsVf3UOjGmy9d2jXTV9FpPBMsvRkmkpOhhiZy+44MVrwjYqac1ahMtVnwxGt+0f+xacc
 QMqfkrjd582g==
X-IronPort-AV: E=Sophos;i="5.82,240,1613462400"; 
   d="scan'208";a="421011711"
Received: from mtkaczyk-devel.igk.intel.com ([10.102.102.23])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2021 07:50:22 -0700
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH] imsm: change wrong size verification
Date:   Wed, 21 Apr 2021 16:50:08 +0200
Message-Id: <20210421145008.8877-1-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Expectation that size is always rounded is incorrect.
Just confirm that size is smaller to be certain that update is safe.

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 super-intel.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 6617dd6d..a7052530 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -11817,12 +11817,12 @@ static int imsm_fix_size_mismatch(struct supertype *st, int subarray_index)
 		if (calc_size == d_size || dev->vol.migr_type == MIGR_GEN_MIGR)
 			continue;
 
-		/* There is a difference, verify that imsm_dev_size is
-		 * rounded correctly and push update.
+		/* There is a difference, confirm that imsm_dev_size is
+		 * smaller and push update.
 		 */
-		if (d_size != round_size_to_mb(d_size, disc_count)) {
-			dprintf("imsm: Size of volume %d is not rounded correctly\n",
-				 i);
+		if (d_size > calc_size) {
+			pr_err("imsm: dev size of subarray %d is incorrect\n",
+				i);
 			goto exit;
 		}
 		memset(&geo, 0, sizeof(struct geo_params));
-- 
2.26.2

