Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6ADBCC433EF
	for <linux-raid@archiver.kernel.org>; Wed, 13 Jul 2022 11:31:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235550AbiGMLbj (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 13 Jul 2022 07:31:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231596AbiGMLbg (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 13 Jul 2022 07:31:36 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12ABA102700;
        Wed, 13 Jul 2022 04:31:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=qCBykpr/hg8qLaH6YfnGQvtq3JJJqR4usp3uIuIPVBM=; b=RlwLN+njbXxP7deZRbZitvwi5R
        +Q4qsRL+A83rv6Gyg7gyomyTxGpG+BOqo9XyovU1hjx9/Kzf4oF6ogl3JVtyXsZ1QlJJ7CnjDp9w1
        3qM6oQjhKYmF3z9LafgZ+9VBmmELso71mJizu5IVWKhD5Hwaset+wDQrq9oHQYTI4ujM3eRTSQ0qr
        vUzncHYwH4clgZe3LWqQNL1IiTyGFVxGRUAaZwAnVSThkvnjNnougDJMED7gL70x4KO8cyNS799I0
        Arx3UD0drcvunSgefsRzW5/iv3KrB7K7witbZdPAlMteZfFwFWMZHPOOqbUAhSlEAvkvZ9bOhkZjV
        yjsplmvg==;
Received: from ip4d15c27d.dynamic.kabel-deutschland.de ([77.21.194.125] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oBaaa-003A0k-R5; Wed, 13 Jul 2022 11:31:33 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Song Liu <song@kernel.org>
Cc:     Logan Gunthorpe <logang@deltatee.com>, linux-raid@vger.kernel.org,
        linux-block@vger.kernel.org
Subject: [PATCH 2/9] md: implement ->free_disk
Date:   Wed, 13 Jul 2022 13:31:18 +0200
Message-Id: <20220713113125.2232975-3-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220713113125.2232975-1-hch@lst.de>
References: <20220713113125.2232975-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Ensure that all private data is only freed once all accesses are done.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/md.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 7affddade8b6b..2beaadd202c4e 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5603,11 +5603,6 @@ static void md_free(struct kobject *ko)
 		del_gendisk(mddev->gendisk);
 		blk_cleanup_disk(mddev->gendisk);
 	}
-	percpu_ref_exit(&mddev->writes_pending);
-
-	bioset_exit(&mddev->bio_set);
-	bioset_exit(&mddev->sync_set);
-	kfree(mddev);
 }
 
 static const struct sysfs_ops md_sysfs_ops = {
@@ -7877,6 +7872,17 @@ static unsigned int md_check_events(struct gendisk *disk, unsigned int clearing)
 	return ret;
 }
 
+static void md_free_disk(struct gendisk *disk)
+{
+	struct mddev *mddev = disk->private_data;
+
+	percpu_ref_exit(&mddev->writes_pending);
+	bioset_exit(&mddev->bio_set);
+	bioset_exit(&mddev->sync_set);
+
+	kfree(mddev);
+}
+
 const struct block_device_operations md_fops =
 {
 	.owner		= THIS_MODULE,
@@ -7890,6 +7896,7 @@ const struct block_device_operations md_fops =
 	.getgeo		= md_getgeo,
 	.check_events	= md_check_events,
 	.set_read_only	= md_set_read_only,
+	.free_disk	= md_free_disk,
 };
 
 static int md_thread(void *arg)
-- 
2.30.2

