Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 413EAC4321E
	for <linux-raid@archiver.kernel.org>; Tue, 29 Nov 2022 13:33:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233785AbiK2Ndo (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 29 Nov 2022 08:33:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233465AbiK2NdY (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 29 Nov 2022 08:33:24 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 886F163BAC
        for <linux-raid@vger.kernel.org>; Tue, 29 Nov 2022 05:33:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=yw5p4hePq0bI+HXxbjQcz/Ji4Vx9hBLb5QQ/8fVGFIY=; b=H8aeQ2p7VmedPD1VjgeGuh+7Da
        8TdxnoYRlZW4jPrjIrBTGGyvwcsKNF7Nap//BcoF9r6Kz2/OVxVUBh0scof6VfrxfcbbjVrr+hfOQ
        a4oS70RpXxHJ4nZTESBpdsXUTcgpjwDzJWmjxrNQJepzy82iE+hN8R9R0ctc1Im1yWkDoCaxsekzz
        IAubZoB6pRofSe28/yMD1fXviqlAKdzvv/he+jahdj2InNS/ZzrgAgykyvkpiDcqp0G9dSYJTKBZ7
        r/FF/zuOZ+b79Eu/ZKN3KaYJQuuu6rKD4p6JFNlcpRp7WDOxJ2/JHrYUZJ15cjnQdf936QTwN/ke7
        2O9wXpgw==;
Received: from [2001:4bb8:192:26e7:691d:40a8:d7b5:b2f5] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1p00jU-008ppK-21; Tue, 29 Nov 2022 13:33:08 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH 3/3] md: fold unbind_rdev_from_array into md_kick_rdev_from_array
Date:   Tue, 29 Nov 2022 14:32:55 +0100
Message-Id: <20221129133255.8228-4-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221129133255.8228-1-hch@lst.de>
References: <20221129133255.8228-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

unbind_rdev_from_array is only called from md_kick_rdev_from_array, so
merge it into its only caller.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/md.c | 37 ++++++++++++++++---------------------
 1 file changed, 16 insertions(+), 21 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 94adb403946534..775f1dde190a2e 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2468,7 +2468,22 @@ static void rdev_delayed_delete(struct work_struct *ws)
 	kobject_put(&rdev->kobj);
 }
 
-static void unbind_rdev_from_array(struct md_rdev *rdev)
+void md_autodetect_dev(dev_t dev);
+
+static void export_rdev(struct md_rdev *rdev)
+{
+	pr_debug("md: export_rdev(%pg)\n", rdev->bdev);
+	md_rdev_clear(rdev);
+#ifndef MODULE
+	if (test_bit(AutoDetected, &rdev->flags))
+		md_autodetect_dev(rdev->bdev->bd_dev);
+#endif
+	blkdev_put(rdev->bdev, FMODE_READ | FMODE_WRITE | FMODE_EXCL);
+	rdev->bdev = NULL;
+	kobject_put(&rdev->kobj);
+}
+
+static void md_kick_rdev_from_array(struct md_rdev *rdev)
 {
 	bd_unlink_disk_holder(rdev->bdev, rdev->mddev->gendisk);
 	list_del_rcu(&rdev->same_set);
@@ -2491,26 +2506,6 @@ static void unbind_rdev_from_array(struct md_rdev *rdev)
 	INIT_WORK(&rdev->del_work, rdev_delayed_delete);
 	kobject_get(&rdev->kobj);
 	queue_work(md_rdev_misc_wq, &rdev->del_work);
-}
-
-void md_autodetect_dev(dev_t dev);
-
-static void export_rdev(struct md_rdev *rdev)
-{
-	pr_debug("md: export_rdev(%pg)\n", rdev->bdev);
-	md_rdev_clear(rdev);
-#ifndef MODULE
-	if (test_bit(AutoDetected, &rdev->flags))
-		md_autodetect_dev(rdev->bdev->bd_dev);
-#endif
-	blkdev_put(rdev->bdev, FMODE_READ | FMODE_WRITE | FMODE_EXCL);
-	rdev->bdev = NULL;
-	kobject_put(&rdev->kobj);
-}
-
-static void md_kick_rdev_from_array(struct md_rdev *rdev)
-{
-	unbind_rdev_from_array(rdev);
 	export_rdev(rdev);
 }
 
-- 
2.30.2

