Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9221C433DB
	for <linux-raid@archiver.kernel.org>; Mon,  1 Feb 2021 13:21:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A71C660C41
	for <linux-raid@archiver.kernel.org>; Mon,  1 Feb 2021 13:21:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231773AbhBANUO (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 1 Feb 2021 08:20:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231901AbhBANSe (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 1 Feb 2021 08:18:34 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63236C0613D6;
        Mon,  1 Feb 2021 05:17:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=BXWhnojK4O/rl0e/ig2t0kjs5+mT27ZYX+NxLhH+25U=; b=h6uRruoiWnFQSWbPT4+fbcJcyz
        Fj9SVCOrSMZlZmiqA0xZZwkl6FuSAjlFy+G8HZt7D4nZl2gnk1Hvw4oHobCP9tBVifm33uMFLEnYB
        J/MFy1q6W8r7AHMS/JXf3XDZV+DVRE5m1mh3rDUectb8FcZyNIC1WepR6IXsgE7kxFyZqdteul75U
        Ow3vUAJvAZ8cHIyDF33A3DF9gMHzeyGM3ZIUWuZKN8xbKAL+JGYFeILC9JYBkqFSrEW1t43ebipwj
        YBuaYq30Z9C/31NeiX3f/V2UMHY5PKWBIKbzAdkuVzyyB0UI11FQlQ5MRZasXBfvdZYMkM+vFtEFO
        lYBCDT+w==;
Received: from [2001:4bb8:198:6bf4:18db:1a43:4422:423f] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1l6Z53-00Do2t-Jo; Mon, 01 Feb 2021 13:17:27 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     axboe@kernel.dk, song@kernel.org
Cc:     guoqing.jiang@cloud.ionos.com, linux-block@vger.kernel.org,
        linux-raid@vger.kernel.org
Subject: [PATCH 1/2] md: check for NULL ->meta_bdev before calling bdev_read_only
Date:   Mon,  1 Feb 2021 14:17:20 +0100
Message-Id: <20210201131721.750412-2-hch@lst.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210201131721.750412-1-hch@lst.de>
References: <20210201131721.750412-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

->meta_bdev is optional and not set for most arrays.  Add a
rdev_read_only helper that calls bdev_read_only for both devices
in a safe way.

Fixes: 6f0d9689b670 ("block: remove the NULL bdev check in bdev_read_only")
Reported-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/md.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 399c81bddc1ae1..7c0f6107865383 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2399,6 +2399,12 @@ int md_integrity_add_rdev(struct md_rdev *rdev, struct mddev *mddev)
 }
 EXPORT_SYMBOL(md_integrity_add_rdev);
 
+static bool rdev_read_only(struct md_rdev *rdev)
+{
+	return bdev_read_only(rdev->bdev) ||
+		(rdev->meta_bdev && bdev_read_only(rdev->meta_bdev));
+}
+
 static int bind_rdev_to_array(struct md_rdev *rdev, struct mddev *mddev)
 {
 	char b[BDEVNAME_SIZE];
@@ -2408,8 +2414,7 @@ static int bind_rdev_to_array(struct md_rdev *rdev, struct mddev *mddev)
 	if (find_rdev(mddev, rdev->bdev->bd_dev))
 		return -EEXIST;
 
-	if ((bdev_read_only(rdev->bdev) || bdev_read_only(rdev->meta_bdev)) &&
-	    mddev->pers)
+	if (rdev_read_only(rdev) && mddev->pers)
 		return -EROFS;
 
 	/* make sure rdev->sectors exceeds mddev->dev_sectors */
@@ -5843,9 +5848,7 @@ int md_run(struct mddev *mddev)
 			continue;
 		sync_blockdev(rdev->bdev);
 		invalidate_bdev(rdev->bdev);
-		if (mddev->ro != 1 &&
-		    (bdev_read_only(rdev->bdev) ||
-		     bdev_read_only(rdev->meta_bdev))) {
+		if (mddev->ro != 1 && rdev_read_only(rdev)) {
 			mddev->ro = 1;
 			if (mddev->gendisk)
 				set_disk_ro(mddev->gendisk, 1);
-- 
2.29.2

