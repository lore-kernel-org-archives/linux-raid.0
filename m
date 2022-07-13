Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DDA1CCA482
	for <linux-raid@archiver.kernel.org>; Wed, 13 Jul 2022 11:32:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236221AbiGMLcD (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 13 Jul 2022 07:32:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235763AbiGMLbw (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 13 Jul 2022 07:31:52 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1ED4102720;
        Wed, 13 Jul 2022 04:31:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=jQF5bV9jdiOfWy5z7Pp3x2W7dG14gudAMuB9AiDToLQ=; b=sK+BC1G9w2sO0hQcfRLPE3X8t4
        Xvd96xq5MaqMh1H52YNZivK5RJ4/z+crC2svIOvmsSrvqszK9dLaQHEEC/Qjoj8qeEUyUNfAdUxZm
        0yu4Eck7i6K4rr/bsS264mcEKe+TioyorI5pEmgqTeIe1sLOCKrgj5+gyli0GshUZ85LyaXuyTs7w
        keuOvf2/cm9ceS/94my+yxyv0aZI55dqLcANVSR9wItTwX1H+4ey3Yiinr4OdEPKPpMn1IFEqV+8n
        u7j1ncXeblgULpQQLAuXDyrktgRqq2qM4Be8Gxiv3edyvo3hCv/ceHWUsDDprDvxKjWQQxhEPn8+3
        6pjElC7w==;
Received: from ip4d15c27d.dynamic.kabel-deutschland.de ([77.21.194.125] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oBaaq-003ABN-HV; Wed, 13 Jul 2022 11:31:48 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Song Liu <song@kernel.org>
Cc:     Logan Gunthorpe <logang@deltatee.com>, linux-raid@vger.kernel.org,
        linux-block@vger.kernel.org
Subject: [PATCH 9/9] md: simplify md_open
Date:   Wed, 13 Jul 2022 13:31:25 +0200
Message-Id: <20220713113125.2232975-10-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220713113125.2232975-1-hch@lst.de>
References: <20220713113125.2232975-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Now that devices are on the all_mddevs list until the gendisk is freed,
there can't be any duplicates.  Remove the global list lookup and just
grab a reference.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/md.c | 42 +++++++++++++++---------------------------
 1 file changed, 15 insertions(+), 27 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index f3ff61e540ee0..41e752c97a196 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7786,45 +7786,33 @@ static int md_set_read_only(struct block_device *bdev, bool ro)
 
 static int md_open(struct block_device *bdev, fmode_t mode)
 {
-	/*
-	 * Succeed if we can lock the mddev, which confirms that
-	 * it isn't being stopped right now.
-	 */
-	struct mddev *mddev = mddev_find(bdev->bd_dev);
+	struct mddev *mddev;
 	int err;
 
+	spin_lock(&all_mddevs_lock);
+	mddev = mddev_get(bdev->bd_disk->private_data);
+	spin_unlock(&all_mddevs_lock);
 	if (!mddev)
 		return -ENODEV;
 
-	if (mddev->gendisk != bdev->bd_disk) {
-		/* we are racing with mddev_put which is discarding this
-		 * bd_disk.
-		 */
-		mddev_put(mddev);
-		/* Wait until bdev->bd_disk is definitely gone */
-		if (work_pending(&mddev->del_work))
-			flush_workqueue(md_misc_wq);
-		return -EBUSY;
-	}
-	BUG_ON(mddev != bdev->bd_disk->private_data);
-
-	if ((err = mutex_lock_interruptible(&mddev->open_mutex)))
+	err = mutex_lock_interruptible(&mddev->open_mutex);
+	if (err)
 		goto out;
 
-	if (test_bit(MD_CLOSING, &mddev->flags)) {
-		mutex_unlock(&mddev->open_mutex);
-		err = -ENODEV;
-		goto out;
-	}
+	err = -ENODEV;
+	if (test_bit(MD_CLOSING, &mddev->flags))
+		goto out_unlock;
 
-	err = 0;
 	atomic_inc(&mddev->openers);
 	mutex_unlock(&mddev->open_mutex);
 
 	bdev_check_media_change(bdev);
- out:
-	if (err)
-		mddev_put(mddev);
+	return 0;
+
+out_unlock:
+	mutex_unlock(&mddev->open_mutex);
+out:
+	mddev_put(mddev);
 	return err;
 }
 
-- 
2.30.2

