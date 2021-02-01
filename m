Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20FA4C433E0
	for <linux-raid@archiver.kernel.org>; Mon,  1 Feb 2021 13:21:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DDAFE64E2A
	for <linux-raid@archiver.kernel.org>; Mon,  1 Feb 2021 13:21:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231575AbhBANVW (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 1 Feb 2021 08:21:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231922AbhBANSL (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 1 Feb 2021 08:18:11 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8E5BC0613ED;
        Mon,  1 Feb 2021 05:17:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=p+BicYwTAcraxDXyWx/iGATSbv1DFzd9yO27m/Udqe4=; b=OQhFfKVF9k/N+UMn0OtjhU8wUA
        +ixZv3ehxdM/ofg9/UwHyO7kO9/2d9mNvwFVML3Z1azild2trAY9Pwk+Psm0eDJ1xHmGQ5vOmq1C2
        sYnYtqokYu3YUO+ZYjx5doNbU+4D/GY6xXrp/w/3kmqSy6zn38IuexaHVJVLr2mJqEIXP8jcDMqHC
        /kAFy8d0muyu/574J41MFGmKC90aRc6NIaU2BIN98md0D9nwd2jVZav3apze2SiD+6aWsidCEjVph
        QG5joBGilHXEXew5LJ3All5LUNr6vyjVa5JJgtkdso56J17A/mu8YDeh4sjyGf5xhatrSw6Vr2JHH
        tR4YvybQ==;
Received: from [2001:4bb8:198:6bf4:18db:1a43:4422:423f] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1l6Z5D-00Do3B-7n; Mon, 01 Feb 2021 13:17:35 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     axboe@kernel.dk, song@kernel.org
Cc:     guoqing.jiang@cloud.ionos.com, linux-block@vger.kernel.org,
        linux-raid@vger.kernel.org
Subject: [PATCH 2/2] md: use rdev_read_only in restart_array
Date:   Mon,  1 Feb 2021 14:17:21 +0100
Message-Id: <20210201131721.750412-3-hch@lst.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210201131721.750412-1-hch@lst.de>
References: <20210201131721.750412-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Make the read-only check in restart_array identical to the other two
read-only checks.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/md.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 7c0f6107865383..21da0c48f6c21e 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6143,7 +6143,7 @@ static int restart_array(struct mddev *mddev)
 		if (test_bit(Journal, &rdev->flags) &&
 		    !test_bit(Faulty, &rdev->flags))
 			has_journal = true;
-		if (bdev_read_only(rdev->bdev))
+		if (rdev_read_only(rdev))
 			has_readonly = true;
 	}
 	rcu_read_unlock();
-- 
2.29.2

