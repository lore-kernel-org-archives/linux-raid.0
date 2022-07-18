Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63B25C433EF
	for <linux-raid@archiver.kernel.org>; Mon, 18 Jul 2022 06:34:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233542AbiGRGeV (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 18 Jul 2022 02:34:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231515AbiGRGeT (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 18 Jul 2022 02:34:19 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E949715822;
        Sun, 17 Jul 2022 23:34:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=DGMfe2gN5IEqr2gKRw9DghJ5rWWMIbfL6K5JkuwPjDo=; b=THIU5ybOsDLDU2cbLLpD1vaP+E
        2r4L0hJCGi57cI2wvY1yOcIaghbm5KcfHDzYjhNKe0rWO8ZQGX1k7GEQ0n5Xej3hYhIoEy7IEcjib
        jfYst9r8O2u39i0EmSXKHR7XwUAQhy/2TL8RPbFLFN6oyZolEtp5hDEw7W1Pyx9K51qaK4uDEtqve
        14KYOhHChgvd2iq+efc15W5JGzPZ8NQ/5YfAREHZHxEvowPi1tbzSNH17qDrJy3hMLJUpR/7X3/AV
        3AdLFKeUZTQ0ALWIAgAPoTvx9vHB3M4Iwd7zqYgwp9CfEPRYZ+pKmOutEolJZq3J2fAdOHxFZDAE2
        H0MKjHSw==;
Received: from 089144198117.atnat0007.highway.a1.net ([89.144.198.117] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oDKKe-00BEXr-2F; Mon, 18 Jul 2022 06:34:16 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Song Liu <song@kernel.org>
Cc:     Logan Gunthorpe <logang@deltatee.com>, linux-raid@vger.kernel.org,
        linux-block@vger.kernel.org
Subject: [PATCH 01/10] md: fix mddev->kobj lifetime
Date:   Mon, 18 Jul 2022 08:34:01 +0200
Message-Id: <20220718063410.338626-2-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220718063410.338626-1-hch@lst.de>
References: <20220718063410.338626-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Once a kobject is initialized, the containing object should not be
directly freed.  So delay initialization until it is added.  Also
remove the kobject_del call as the last put will remove the kobject as
well.  The explicitly delete isn't needed here, and dropping it will
simplify further fixes.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/md.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index b64de313838f2..a49ddc9454ff6 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -678,7 +678,6 @@ static void md_safemode_timeout(struct timer_list *t);
 
 void mddev_init(struct mddev *mddev)
 {
-	kobject_init(&mddev->kobj, &md_ktype);
 	mutex_init(&mddev->open_mutex);
 	mutex_init(&mddev->reconfig_mutex);
 	mutex_init(&mddev->bitmap_info.mutex);
@@ -5617,7 +5616,6 @@ static void mddev_delayed_delete(struct work_struct *ws)
 {
 	struct mddev *mddev = container_of(ws, struct mddev, del_work);
 
-	kobject_del(&mddev->kobj);
 	kobject_put(&mddev->kobj);
 }
 
@@ -5719,6 +5717,7 @@ int md_alloc(dev_t dev, char *name)
 	if (error)
 		goto out_cleanup_disk;
 
+	kobject_init(&mddev->kobj, &md_ktype);
 	error = kobject_add(&mddev->kobj, &disk_to_dev(disk)->kobj, "%s", "md");
 	if (error)
 		goto out_del_gendisk;
-- 
2.30.2

