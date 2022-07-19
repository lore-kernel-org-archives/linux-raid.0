Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4154ACCA485
	for <linux-raid@archiver.kernel.org>; Tue, 19 Jul 2022 09:20:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237207AbiGSJUH (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 19 Jul 2022 05:20:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235846AbiGSJTO (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 19 Jul 2022 05:19:14 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C056F30F57;
        Tue, 19 Jul 2022 02:19:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=GCvrXaFdqCJEYYsQAkx3LBTks4m8EIcdzDEboMJjXWs=; b=47K96DA8aAUM8G15WSkZHw36uW
        BrFo8lD5gLRwz9Qz54aud42AnG/RZkRn4vxhRVitjZJzyfaxPMIUfV5DCZa+hwNIOVOFLmHhK4Xex
        Gnmff+qmsCvNpXKFiQBVXw5HvsbhJ+srWOvug4YqYktFnkdNJ//6nqP1el89p/IgVwL9cMqvw0UxR
        69MYPJOuBq5WDE3VmGGVc8wX4tiu/nPMbS1QGdKAtrlhcK2F7IUmH9iIwwfgRKW9JyB/T5n7/ttIg
        rDUZ+ysiynAv+3BaxjNZwyTfcWulEVuwEzCN0jk4HkZEvs7gGqi6G8jqGm0sTLtvdKQC5ciZa0FHw
        I5ohDDEw==;
Received: from 089144198117.atnat0007.highway.a1.net ([89.144.198.117] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oDjNm-007D46-BH; Tue, 19 Jul 2022 09:19:10 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Song Liu <song@kernel.org>
Cc:     Logan Gunthorpe <logang@deltatee.com>, linux-raid@vger.kernel.org,
        linux-block@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 10/10] md: simplify md_open
Date:   Tue, 19 Jul 2022 11:18:24 +0200
Message-Id: <20220719091824.1064989-11-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220719091824.1064989-1-hch@lst.de>
References: <20220719091824.1064989-1-hch@lst.de>
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
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/md/md.c | 42 +++++++++++++++---------------------------
 1 file changed, 15 insertions(+), 27 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 6180d0a6b926d..efb9027f8322b 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7783,45 +7783,33 @@ static int md_set_read_only(struct block_device *bdev, bool ro)
 
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

