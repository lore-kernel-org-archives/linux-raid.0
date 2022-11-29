Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE1B9C46467
	for <linux-raid@archiver.kernel.org>; Tue, 29 Nov 2022 13:33:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232141AbiK2Ndb (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 29 Nov 2022 08:33:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233214AbiK2NdO (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 29 Nov 2022 08:33:14 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6177C24952
        for <linux-raid@vger.kernel.org>; Tue, 29 Nov 2022 05:33:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=LEx7JZu8wvCZpWalj42akkrVIKEUknHZF4O9MrgxpG4=; b=EJgtRoZGxr7Ji6i8ZYRERGd75H
        Fgrai7PCND3U2NrSJhqYTEKlIni/6ASMJsHFYQ/5mdpLxbmlDsvKH4vJ9EPtCpheIeVqMZjjPE6CG
        yKk4Lds8tcbjlwitMWSIPeDORB5IXQDVNcdsGaabVokDHFshWOiiiFU++ni0GUQQFajIgo86xdkbK
        AJqJJbFnrJ1fZi/eUsL8u7VRelXW0eEip32ODKznuWGwGtesLmkmQy2rjIMasY/hxedcenxRLNA+y
        uArAEiy0mo096ZTvi8DC72Fjhpy+AIoRD/mQa7K3iYfLAUa7A49G3DJ04bb1d0qiUK9hOJYFqdGIF
        b/Q73JGw==;
Received: from [2001:4bb8:192:26e7:691d:40a8:d7b5:b2f5] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1p00jN-008pma-Nu; Tue, 29 Nov 2022 13:33:02 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH 1/3] md: remove lock_bdev / unlock_bdev
Date:   Tue, 29 Nov 2022 14:32:53 +0100
Message-Id: <20221129133255.8228-2-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221129133255.8228-1-hch@lst.de>
References: <20221129133255.8228-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

These wrappers for blkdev_get / blkdev_put just horribly confuse the
code with their odd naming.  Remove them and improve the error unwinding
in md_import_device with the now folded code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/md.c | 63 +++++++++++++++++--------------------------------
 1 file changed, 22 insertions(+), 41 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index f95b8644048597..27ce98b018aff9 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2493,34 +2493,6 @@ static void unbind_rdev_from_array(struct md_rdev *rdev)
 	queue_work(md_rdev_misc_wq, &rdev->del_work);
 }
 
-/*
- * prevent the device from being mounted, repartitioned or
- * otherwise reused by a RAID array (or any other kernel
- * subsystem), by bd_claiming the device.
- */
-static int lock_rdev(struct md_rdev *rdev, dev_t dev, int shared)
-{
-	int err = 0;
-	struct block_device *bdev;
-
-	bdev = blkdev_get_by_dev(dev, FMODE_READ|FMODE_WRITE|FMODE_EXCL,
-				 shared ? (struct md_rdev *)lock_rdev : rdev);
-	if (IS_ERR(bdev)) {
-		pr_warn("md: could not open device unknown-block(%u,%u).\n",
-			MAJOR(dev), MINOR(dev));
-		return PTR_ERR(bdev);
-	}
-	rdev->bdev = bdev;
-	return err;
-}
-
-static void unlock_rdev(struct md_rdev *rdev)
-{
-	struct block_device *bdev = rdev->bdev;
-	rdev->bdev = NULL;
-	blkdev_put(bdev, FMODE_READ|FMODE_WRITE|FMODE_EXCL);
-}
-
 void md_autodetect_dev(dev_t dev);
 
 static void export_rdev(struct md_rdev *rdev)
@@ -2531,7 +2503,8 @@ static void export_rdev(struct md_rdev *rdev)
 	if (test_bit(AutoDetected, &rdev->flags))
 		md_autodetect_dev(rdev->bdev->bd_dev);
 #endif
-	unlock_rdev(rdev);
+	blkdev_put(rdev->bdev, FMODE_READ | FMODE_WRITE | FMODE_EXCL);
+	rdev->bdev = NULL;
 	kobject_put(&rdev->kobj);
 }
 
@@ -3675,9 +3648,10 @@ EXPORT_SYMBOL_GPL(md_rdev_init);
  */
 static struct md_rdev *md_import_device(dev_t newdev, int super_format, int super_minor)
 {
-	int err;
+	static struct md_rdev *claim_rdev; /* just for claiming the bdev */
 	struct md_rdev *rdev;
 	sector_t size;
+	int err;
 
 	rdev = kzalloc(sizeof(*rdev), GFP_KERNEL);
 	if (!rdev)
@@ -3685,14 +3659,20 @@ static struct md_rdev *md_import_device(dev_t newdev, int super_format, int supe
 
 	err = md_rdev_init(rdev);
 	if (err)
-		goto abort_free;
+		goto out_free_rdev;
 	err = alloc_disk_sb(rdev);
 	if (err)
-		goto abort_free;
+		goto out_clear_rdev;
 
-	err = lock_rdev(rdev, newdev, super_format == -2);
-	if (err)
-		goto abort_free;
+	rdev->bdev = blkdev_get_by_dev(newdev,
+			FMODE_READ | FMODE_WRITE | FMODE_EXCL,
+			super_format == -2 ? claim_rdev : rdev);
+	if (IS_ERR(rdev->bdev)) {
+		pr_warn("md: could not open device unknown-block(%u,%u).\n",
+			MAJOR(newdev), MINOR(newdev));
+		err = PTR_ERR(rdev->bdev);
+		goto out_clear_rdev;
+	}
 
 	kobject_init(&rdev->kobj, &rdev_ktype);
 
@@ -3701,7 +3681,7 @@ static struct md_rdev *md_import_device(dev_t newdev, int super_format, int supe
 		pr_warn("md: %pg has zero or unknown size, marking faulty!\n",
 			rdev->bdev);
 		err = -EINVAL;
-		goto abort_free;
+		goto out_blkdev_put;
 	}
 
 	if (super_format >= 0) {
@@ -3711,21 +3691,22 @@ static struct md_rdev *md_import_device(dev_t newdev, int super_format, int supe
 			pr_warn("md: %pg does not have a valid v%d.%d superblock, not importing!\n",
 				rdev->bdev,
 				super_format, super_minor);
-			goto abort_free;
+			goto out_blkdev_put;
 		}
 		if (err < 0) {
 			pr_warn("md: could not read %pg's sb, not importing!\n",
 				rdev->bdev);
-			goto abort_free;
+			goto out_blkdev_put;
 		}
 	}
 
 	return rdev;
 
-abort_free:
-	if (rdev->bdev)
-		unlock_rdev(rdev);
+out_blkdev_put:
+	blkdev_put(rdev->bdev, FMODE_READ | FMODE_WRITE | FMODE_EXCL);
+out_clear_rdev:
 	md_rdev_clear(rdev);
+out_free_rdev:
 	kfree(rdev);
 	return ERR_PTR(err);
 }
-- 
2.30.2

