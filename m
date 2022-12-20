Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C85ADC4332F
	for <linux-raid@archiver.kernel.org>; Tue, 20 Dec 2022 11:08:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232328AbiLTLH7 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 20 Dec 2022 06:07:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229812AbiLTLH5 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 20 Dec 2022 06:07:57 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A27A1DF88
        for <linux-raid@vger.kernel.org>; Tue, 20 Dec 2022 03:07:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671534476; x=1703070476;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=iK3GnGNiJseRO/5sTOsu6+XQVcnwbT5AEbOZjtlgLp8=;
  b=H3DrKxsLzzw7e8q0vnH2eNxWbtlWh1N/7k8Ad+OUWvZcR+ROm4t+eVjI
   RwJzqF1PZOk1+UCXtn1CfECFQPF8IwrYU9LkvqKkk5L81KakHuSAvydrT
   4o0nfLaQ8Y8WlmZQyUWaCpayeiNQcBLCU142h0YrTaxIS6VW4I0ooo9fa
   iJ5IXVHUGBdy+yUb9FrEb2pxJ1B9rcWtJkiNDyggNwCzQdNR2X40b8YkG
   ArVRcE32tGuVilxRztnw9+3pfoyM3mxH3oej7UcdPeQP0V4dGglKrNRpP
   ND+nm7xPBhbIx4eEC9ypVvYuCABkUFCmLOMQjkIN1MQ4zA9ytbojB3Bh0
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10566"; a="307268929"
X-IronPort-AV: E=Sophos;i="5.96,259,1665471600"; 
   d="scan'208";a="307268929"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2022 03:07:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10566"; a="681603796"
X-IronPort-AV: E=Sophos;i="5.96,259,1665471600"; 
   d="scan'208";a="681603796"
Received: from linux-myjy.igk.intel.com ([10.102.108.92])
  by orsmga008.jf.intel.com with ESMTP; 20 Dec 2022 03:07:55 -0800
From:   Blazej Kucman <blazej.kucman@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org, colyli@suse.de
Subject: [PATCH] Grow: fix possible memory leak.
Date:   Tue, 20 Dec 2022 12:07:51 +0100
Message-Id: <20221220110751.27354-1-blazej.kucman@intel.com>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Signed-off-by: Blazej Kucman <blazej.kucman@intel.com>
---
 Grow.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/Grow.c b/Grow.c
index e362403a..b73ec2ae 100644
--- a/Grow.c
+++ b/Grow.c
@@ -432,6 +432,7 @@ int Grow_addbitmap(char *devname, int fd, struct context *c, struct shape *s)
 			if (((disk.state & (1 << MD_DISK_WRITEMOSTLY)) == 0) &&
 			   (strcmp(s->bitmap_file, "clustered") == 0)) {
 				pr_err("%s disks marked write-mostly are not supported with clustered bitmap\n",devname);
+				free(mdi);
 				return 1;
 			}
 			fd2 = dev_open(dv, O_RDWR);
@@ -453,8 +454,10 @@ int Grow_addbitmap(char *devname, int fd, struct context *c, struct shape *s)
 				pr_err("failed to load super-block.\n");
 			}
 			close(fd2);
-			if (rv)
+			if (rv) {
+				free(mdi);
 				return 1;
+			}
 		}
 		if (offset_setable) {
 			st->ss->getinfo_super(st, mdi, NULL);
-- 
2.35.3

