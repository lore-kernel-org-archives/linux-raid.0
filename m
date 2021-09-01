Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D103CC432BE
	for <linux-raid@archiver.kernel.org>; Wed,  1 Sep 2021 11:41:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0D0C6101B
	for <linux-raid@archiver.kernel.org>; Wed,  1 Sep 2021 11:41:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243853AbhIALmJ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 1 Sep 2021 07:42:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241488AbhIALmJ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 1 Sep 2021 07:42:09 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE2B2C061575
        for <linux-raid@vger.kernel.org>; Wed,  1 Sep 2021 04:41:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=Dj0nVVgzfvTvDGHLliigtDMVe9wOTM6XbBYuENAZmWU=; b=r2XyfBwVFgdh+zhR1KB/Bfpc9T
        hTagHeLe04UvyU6UNSLHc9vd6KHmJjqAdamN4g32ZDKE8XmSXt1X7DNfVMDSNtfYEmecKGCSR/b90
        MMI+E4B6PQt2hd9Hbq7/0W3vgJsX4as9wueimpHNgdvnjw5DO5zGrAkJeJY/yExjp4YprKmTF5fF4
        e4y3Ir+NO4JIkcXvcvRZbNjbAyHik0sICzZS5VrQIHIt9QwwbaqlvSEdnEyYQzgJfzbZIoMBcEUOe
        CGfR1WXWn1oMwAkdWgenoqk+kVQxXWJQGuvSG7fEU3u5GVa9NGZzbS7Hvm0faGiQrxFsvxBhXSrfg
        kRgBJm/A==;
Received: from [2001:4bb8:180:a30:2deb:705a:5588:bf7d] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mLObB-002FY5-Ay; Wed, 01 Sep 2021 11:40:25 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Song Liu <song@kernel.org>
Cc:     Luis Chamberlain <mcgrof@kernel.org>, linux-raid@vger.kernel.org
Subject: [PATCH 2/5] md: add error handling support for add_disk()
Date:   Wed,  1 Sep 2021 13:38:30 +0200
Message-Id: <20210901113833.1334886-3-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210901113833.1334886-1-hch@lst.de>
References: <20210901113833.1334886-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Luis Chamberlain <mcgrof@kernel.org>

We never checked for errors on add_disk() as this function
returned void. Now that this is fixed, use the shiny new
error handling.

We just do the unwinding of what was not done before, and are
sure to unlock prior to bailing.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/md.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 6c0c3d0d905aa..6bd5ad3c30b41 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5700,7 +5700,11 @@ static int md_alloc(dev_t dev, char *name)
 	disk->flags |= GENHD_FL_EXT_DEVT;
 	disk->events |= DISK_EVENT_MEDIA_CHANGE;
 	mddev->gendisk = disk;
-	add_disk(disk);
+	error = add_disk(disk);
+	if (error) {
+		blk_cleanup_disk(disk);
+		goto abort;
+	}
 
 	error = kobject_add(&mddev->kobj, &disk_to_dev(disk)->kobj, "%s", "md");
 	if (error) {
-- 
2.30.2

