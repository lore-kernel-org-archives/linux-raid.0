Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15427C4332F
	for <linux-raid@archiver.kernel.org>; Wed,  9 Nov 2022 10:10:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230120AbiKIKKp (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 9 Nov 2022 05:10:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230072AbiKIKKo (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 9 Nov 2022 05:10:44 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB7BDC6E
        for <linux-raid@vger.kernel.org>; Wed,  9 Nov 2022 02:10:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=LcPSzGvZbSMhLhl1cbh/c4IIHLSWU0Eua92yeCxxXjg=; b=AsXaIWfruSMUFCgVruomwbmTw6
        ktgyNJ4Bn6TMa3mzmLvyFBD1QeX+Q7qPEo/agMfra26Y7YyYSXZDgltslvQG3zt3vMpxi5vmLTWAT
        9TBK1To//jXZ/O3EpTvAPoVHh1ZidqHJiFAInyzTLPwHpeM6vSUMPqvO3a/M6/JyQduPdq9Be+W6t
        j3wodGqMB3+p2oDrGD1YKZvI8zOdq6RMNNRxdgUH1JUUD6Fam57PQTnB+asvJ2KWPn8gUUhM6MSA0
        uLJGEl86XYpcxA1FnctqF3RA01BkeosWy2Nuk8uT9rjGcXfWUv309ghVkoj3aYv/60A8rhwSPPuQ+
        PWIgzTYw==;
Received: from [46.183.103.17] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1osi2b-00CagC-0Z; Wed, 09 Nov 2022 10:10:43 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     song@kernel.org
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH] md/raid5: use bdev_write_cache instead of open coding it
Date:   Wed,  9 Nov 2022 11:10:37 +0100
Message-Id: <20221109101037.2414944-1-hch@lst.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Use the bdev_write_cache instead of two equivalent open coded checks.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/raid5-cache.c | 5 +----
 drivers/md/raid5-ppl.c   | 5 +----
 2 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 832d8566e1656..4458b551ec4d0 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -3061,7 +3061,6 @@ void r5c_update_on_rdev_error(struct mddev *mddev, struct md_rdev *rdev)
 
 int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
 {
-	struct request_queue *q = bdev_get_queue(rdev->bdev);
 	struct r5l_log *log;
 	int ret;
 
@@ -3090,9 +3089,7 @@ int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
 	if (!log)
 		return -ENOMEM;
 	log->rdev = rdev;
-
-	log->need_cache_flush = test_bit(QUEUE_FLAG_WC, &q->queue_flags) != 0;
-
+	log->need_cache_flush = bdev_write_cache(rdev->bdev);
 	log->uuid_checksum = crc32c_le(~0, rdev->mddev->uuid,
 				       sizeof(rdev->mddev->uuid));
 
diff --git a/drivers/md/raid5-ppl.c b/drivers/md/raid5-ppl.c
index 31b9157bc9ae9..e495939bb3e03 100644
--- a/drivers/md/raid5-ppl.c
+++ b/drivers/md/raid5-ppl.c
@@ -1301,8 +1301,6 @@ static int ppl_validate_rdev(struct md_rdev *rdev)
 
 static void ppl_init_child_log(struct ppl_log *log, struct md_rdev *rdev)
 {
-	struct request_queue *q;
-
 	if ((rdev->ppl.size << 9) >= (PPL_SPACE_SIZE +
 				      PPL_HEADER_SIZE) * 2) {
 		log->use_multippl = true;
@@ -1316,8 +1314,7 @@ static void ppl_init_child_log(struct ppl_log *log, struct md_rdev *rdev)
 	}
 	log->next_io_sector = rdev->ppl.sector;
 
-	q = bdev_get_queue(rdev->bdev);
-	if (test_bit(QUEUE_FLAG_WC, &q->queue_flags))
+	if (bdev_write_cache(rdev->bdev))
 		log->wb_cache_on = true;
 }
 
-- 
2.30.2

