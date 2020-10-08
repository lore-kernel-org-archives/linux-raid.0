Return-Path: <SRS0=hplT=DP=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6517C4363A
	for <linux-raid@archiver.kernel.org>; Thu,  8 Oct 2020 03:20:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D9F9206E9
	for <linux-raid@archiver.kernel.org>; Thu,  8 Oct 2020 03:20:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="CcbCRHK/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727933AbgJHDUO (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 7 Oct 2020 23:20:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727449AbgJHDUO (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 7 Oct 2020 23:20:14 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00838C061755
        for <linux-raid@vger.kernel.org>; Wed,  7 Oct 2020 20:20:13 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id x22so2789177pfo.12
        for <linux-raid@vger.kernel.org>; Wed, 07 Oct 2020 20:20:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=ZOBy7+0FCdGItwUTR5yne86Gk1jJKMKTRgh/+ELxKCA=;
        b=CcbCRHK/WEAVNwjcAgkpyHZ5OC8rPjdDo5BCTP3JGCfsyruJHcHFtYCNhQLWM3rfZL
         RV5RV5tW4TOywbPt0HmXMzObvDmwlrQ6D2+HM5yb5+ZFIuYzrQKO0mWLXlZD7QvZm5It
         GfaUbo/4vGkOsl3gkFoQZxgzeN7RZDDdjbh07D1PXGouc+Ejd1Llz0HzmV5qiTtQ/VJx
         TXD6h68EFEc82RdBw6IKb2BwbREKDkLKh+R4Hd4i8tnQVhl4g4xQynHP4tULQJnEkGwq
         Fy1LzRn0eD5h4m7/cAinNslx91hOW3z2wysmoUk8IgUksjmh0xl4q+NPk2X2wnGjDjD4
         0dMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ZOBy7+0FCdGItwUTR5yne86Gk1jJKMKTRgh/+ELxKCA=;
        b=a0vIhYRguXb3CZ/L5EKqX6H5MOJPcHQFZZ1TUpnUYVbRPiSfPjET786uqZrf2GTWR2
         /5cOP8sUvxV+0lPNMPXg4FgL8Vl0AZMQ+A14OXfWVAcLls+zUKFFupx99YYHyBDHPVDB
         KYdGhC1XiDRi9A1W+v1aQ4iX6vnb3+jWalIKbUCUO/wDb3spj0HKlpiPN6OnFyIvo8iD
         AnxNYDlawzEeztXFKlr4mLW9gY+G9wjjfphGyulm/ok+HFeI/tTmXapy/8SMNIEKdTfc
         1Xas8LwiCzv1x4XT5t4/ILwltUjcSIxrsajPczZ+lQtmJKP/T0VIb/G/d3cvzi81ZE+k
         8rTA==
X-Gm-Message-State: AOAM532WjulkzVm/zx40xIAA42NO6nfR9l+Qjorcut9VlDhs65o4BFtk
        5+LIhiA6Pbam+h4bwJdmsxk5Ww==
X-Google-Smtp-Source: ABdhPJw3ktHppaBU2bv6GDW7hdA7Gt8zqPRJLg06INrHJkXA8+XoJu18V6q8oWNPxTFH1qffKEJefw==
X-Received: by 2002:a62:1c53:0:b029:155:e9e:d1da with SMTP id c80-20020a621c530000b02901550e9ed1damr5597931pfc.14.1602127212612;
        Wed, 07 Oct 2020 20:20:12 -0700 (PDT)
Received: from gqjiang-home.profitbricks.net ([196.245.9.44])
        by smtp.gmail.com with ESMTPSA id n24sm4451744pjq.14.2020.10.07.20.20.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Oct 2020 20:20:11 -0700 (PDT)
From:   Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
To:     song@kernel.org
Cc:     linux-raid@vger.kernel.org,
        Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Subject: [PATCH] md: fix the checking of wrong work queue
Date:   Thu,  8 Oct 2020 05:19:09 +0200
Message-Id: <1602127149-30561-1-git-send-email-guoqing.jiang@cloud.ionos.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

It should check md_rdev_misc_wq instead of md_misc_wq.

Fixes: cc1ffe6 ("md: add new workqueue for delete rdev")
Signed-off-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
---
 drivers/md/md.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 6072782..cd3c249 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9545,7 +9545,7 @@ static int __init md_init(void)
 		goto err_misc_wq;
 
 	md_rdev_misc_wq = alloc_workqueue("md_rdev_misc", 0, 0);
-	if (!md_misc_wq)
+	if (!md_rdev_misc_wq)
 		goto err_rdev_misc_wq;
 
 	if ((ret = register_blkdev(MD_MAJOR, "md")) < 0)
-- 
2.7.4

