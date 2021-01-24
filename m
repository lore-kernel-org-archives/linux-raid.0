Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 086EDC4332B
	for <linux-raid@archiver.kernel.org>; Sun, 24 Jan 2021 10:06:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BCB5A22AAA
	for <linux-raid@archiver.kernel.org>; Sun, 24 Jan 2021 10:06:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbhAXKGV (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 24 Jan 2021 05:06:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726739AbhAXKGR (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 24 Jan 2021 05:06:17 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68779C06174A;
        Sun, 24 Jan 2021 02:05:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=K6diAuI1dykKiPdXMiX1y5sNzP8n09/HziOZ9JOHixw=; b=HAB7DU15HlXBk7fo4pm48eAnnz
        y3wRNIuPlc+uEmBp3NuG0/4Q/71LYmoelCczGo35ecJTUghzhrxKV7xqTNkdxYhXmJkIx3OsJeLGq
        HCBVcZl3uCkltVbHMCmNLAc0kOD98ymy61AGyCAG7JEvKJBOhfy+I2wTZNiW3TX27FAZa/DA1atYn
        zfJKLIm0nnkVeMi/GHo0vD7xjQlBViMwlNR2ZeQr9FLAR7sPWXd9Cxgt3+u4UYbWygazIXbZ1uoxL
        ZgqpuTt+UDnH6qNK95eTlqfkeSt7KOPj7nqmvJbDDsn9bQmLYdAec9ZWMTOagQBAIPI46RmjzFFKi
        ERsd1Vmg==;
Received: from [2001:4bb8:188:1954:a3b3:627f:702b:2136] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1l3cGh-002q98-LP; Sun, 24 Jan 2021 10:05:26 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Tejun Heo <tj@kernel.org>, Coly Li <colyli@suse.de>,
        Song Liu <song@kernel.org>, dm-devel@redhat.com,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-block@vger.kernel.org
Subject: [PATCH 02/10] dcssblk: remove the end of device check in dcssblk_submit_bio
Date:   Sun, 24 Jan 2021 11:02:33 +0100
Message-Id: <20210124100241.1167849-3-hch@lst.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210124100241.1167849-1-hch@lst.de>
References: <20210124100241.1167849-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

The block layer already checks for this conditions in bio_check_eod
before calling the driver.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Tejun Heo <tj@kernel.org>
---
 drivers/s390/block/dcssblk.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/s390/block/dcssblk.c b/drivers/s390/block/dcssblk.c
index 299e77ec2c4163..5c5cff3f237452 100644
--- a/drivers/s390/block/dcssblk.c
+++ b/drivers/s390/block/dcssblk.c
@@ -886,10 +886,6 @@ dcssblk_submit_bio(struct bio *bio)
 	    (bio->bi_iter.bi_size & 4095) != 0)
 		/* Request is not page-aligned. */
 		goto fail;
-	if (bio_end_sector(bio) > get_capacity(bio->bi_disk)) {
-		/* Request beyond end of DCSS segment. */
-		goto fail;
-	}
 	/* verify data transfer direction */
 	if (dev_info->is_shared) {
 		switch (dev_info->segment_type) {
-- 
2.29.2

