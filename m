Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F797C25B08
	for <linux-raid@archiver.kernel.org>; Wed, 17 Aug 2022 12:06:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239319AbiHQMGl (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 17 Aug 2022 08:06:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239321AbiHQMGL (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 17 Aug 2022 08:06:11 -0400
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED5E487681
        for <linux-raid@vger.kernel.org>; Wed, 17 Aug 2022 05:05:56 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1660737939;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D0ucZPHsIgT41OufhpLRcJBvDHiuCzrVgI5QhcPtb1c=;
        b=tg2z5i/uLenm20eoExHDzOy5lKRwuocv16WoC9Ku2b7FF23AYRUIakvEp0X6fduwb9pibS
        6jYauvN1bFbEUkkDeIIvcSgxlxQWUEsYawNjv6OrXFI4BZ+R/3GRAmIeUy98l61491tcdj
        vh1iPBgfmygZGXF7K770QCLVcq8a6FY=
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
To:     neilb@suse.de, mpatocka@redhat.com
Cc:     song@kernel.org, linux-raid@vger.kernel.org,
        Guoqing Jiang <guoqing.jiang@linux.dev>
Subject: [PATCH 1/2] Revert "md-raid: destroy the bitmap after destroying the thread"
Date:   Wed, 17 Aug 2022 20:05:13 +0800
Message-Id: <20220817120514.5536-2-guoqing.jiang@linux.dev>
In-Reply-To: <20220817120514.5536-1-guoqing.jiang@linux.dev>
References: <20220817120514.5536-1-guoqing.jiang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

This reverts commit e151db8ecfb019b7da31d076130a794574c89f6f. Because it
obviously breaks clustered raid as noticed by Neil though it fixed KASAN
issue for dm-raid, let's revert it and fix KASAN issue in next commit.

[1]. https://lore.kernel.org/linux-raid/a6657e08-b6a7-358b-2d2a-0ac37d49d23a@linux.dev/T/#m95ac225cab7409f66c295772483d091084a6d470

Signed-off-by: Guoqing Jiang <guoqing.jiang@linux.dev>
---
 drivers/md/md.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index afaf36b2f6ab..76acd2c72f84 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6238,11 +6238,11 @@ static void mddev_detach(struct mddev *mddev)
 static void __md_stop(struct mddev *mddev)
 {
 	struct md_personality *pers = mddev->pers;
+	md_bitmap_destroy(mddev);
 	mddev_detach(mddev);
 	/* Ensure ->event_work is done */
 	if (mddev->event_work.func)
 		flush_workqueue(md_misc_wq);
-	md_bitmap_destroy(mddev);
 	spin_lock(&mddev->lock);
 	mddev->pers = NULL;
 	spin_unlock(&mddev->lock);
-- 
2.31.1

