Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CF1AC433B4
	for <linux-raid@archiver.kernel.org>; Fri, 21 May 2021 00:56:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE06D613AD
	for <linux-raid@archiver.kernel.org>; Fri, 21 May 2021 00:56:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235599AbhEUA5v (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 20 May 2021 20:57:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235593AbhEUA5u (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 20 May 2021 20:57:50 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C68A4C061574
        for <linux-raid@vger.kernel.org>; Thu, 20 May 2021 17:56:28 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id s19so11423961pfe.8
        for <linux-raid@vger.kernel.org>; Thu, 20 May 2021 17:56:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zVx1dxeLUcTko+lLjqbpHzUN3VfpbG3ciX+AJaqUnMo=;
        b=JbYBUu4348/U0G16fz8htsLANJG+6nYMnm6smJvwCVTFBZYw+JIVBTTs5MLfem0JYN
         MO5vOAt5DdUHxdME9DqVIKs29DhmujQ88hMq6pSE4HN+7R/T69V+soFuuGDpBe7rUqM5
         CsPAjWm1KoNDxWQ6K5YFkLiYRkzuzk1R6Et1nv4ERaZz5URsJu0WHcosSLKlf7GlgAYA
         RzT4pPDJEYSXkm/nVN9O1dAlME4tOo36W+Q3xX4MsAjtUUStvV/IaW0emNMp4Yjw+/6H
         U4yfV8BAM8q2c73h8tT4M36ZKTJELJA8jIDvAIug4PZCddYIMuIEzRWBlrWkUt3qomFz
         yIvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zVx1dxeLUcTko+lLjqbpHzUN3VfpbG3ciX+AJaqUnMo=;
        b=ZZJ+ro3OmQIPq0mWBo49AZxbgidCgK2YC4m0f7T4GoX3VzNfpBsorh1cQo81o78mRG
         6pbTDh7bSeiXQ3ExAqo2Bcz/nqdVu2+wj7J0LFqipJkqUi7xeDIcxdshtbdxK4dF+AnU
         8DWArwebPzdi+QFU3DG37709OzEq8zKLpXMc/iixa4JXmgDnFYWwMh/iHzJCTIXRDjp7
         ltF+ocSbXFoKj+o0Kdo30jE5qs2RPoFMFaIKCxs3vPWeXxRrxC6Nm6Ow9gqjzS1Q8J3Y
         6jW5q44YzN6oxRrpjUXcwYRVEJLkKi44/xY8F7B/VuON/A/kSUiA47FmJ15+9Ux3o4Uw
         uHZw==
X-Gm-Message-State: AOAM5323xrf4EXdRGSmagax5+MhxsbMPCzUs4Jtpu1/wXYvX51BL5XiD
        5Q1KUo+KLRB6fCwG4tuqoIw=
X-Google-Smtp-Source: ABdhPJzm1PKnuwG/bW0E5LrLSZjiuSlHbtw+1Cgj0nn05eOIfTiU/rSgydb5rfibAlEWQz1yraP95Q==
X-Received: by 2002:a63:e105:: with SMTP id z5mr7067574pgh.321.1621558588431;
        Thu, 20 May 2021 17:56:28 -0700 (PDT)
Received: from localhost.localdomain ([89.187.161.155])
        by smtp.gmail.com with ESMTPSA id 5sm7405945pjo.17.2021.05.20.17.56.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 May 2021 17:56:27 -0700 (PDT)
From:   Guoqing Jiang <jgq516@gmail.com>
X-Google-Original-From: Guoqing Jiang <jiangguoqing@kylinos.cn>
To:     song@kernel.org
Cc:     linux-raid@vger.kernel.org, artur.paszkiewicz@intel.com
Subject: [PATCH V2 1/7] md: revert io stats accounting
Date:   Fri, 21 May 2021 08:55:15 +0800
Message-Id: <20210521005521.713106-2-jiangguoqing@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210521005521.713106-1-jiangguoqing@kylinos.cn>
References: <20210521005521.713106-1-jiangguoqing@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

The commit 41d2d848e5c0 ("md: improve io stats accounting") could cause
double fault problem per the report [1], and also it is not correct to
change ->bi_end_io if md don't own it, so let's revert it.

And io stats accounting will be replemented in later commits.

[1]. https://lore.kernel.org/linux-raid/3bf04253-3fad-434a-63a7-20214e38cf26@gmail.com/T/#t

Fixes: 41d2d848e5c0 ("md: improve io stats accounting")
Signed-off-by: Guoqing Jiang <jiangguoqing@kylinos.cn>
---
 drivers/md/md.c | 45 ---------------------------------------------
 drivers/md/md.h |  1 -
 2 files changed, 46 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 49f897fbb89b..7ba00e4c862d 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -441,30 +441,6 @@ void md_handle_request(struct mddev *mddev, struct bio *bio)
 }
 EXPORT_SYMBOL(md_handle_request);
 
-struct md_io {
-	struct mddev *mddev;
-	bio_end_io_t *orig_bi_end_io;
-	void *orig_bi_private;
-	struct block_device *orig_bi_bdev;
-	unsigned long start_time;
-};
-
-static void md_end_io(struct bio *bio)
-{
-	struct md_io *md_io = bio->bi_private;
-	struct mddev *mddev = md_io->mddev;
-
-	bio_end_io_acct_remapped(bio, md_io->start_time, md_io->orig_bi_bdev);
-
-	bio->bi_end_io = md_io->orig_bi_end_io;
-	bio->bi_private = md_io->orig_bi_private;
-
-	mempool_free(md_io, &mddev->md_io_pool);
-
-	if (bio->bi_end_io)
-		bio->bi_end_io(bio);
-}
-
 static blk_qc_t md_submit_bio(struct bio *bio)
 {
 	const int rw = bio_data_dir(bio);
@@ -489,21 +465,6 @@ static blk_qc_t md_submit_bio(struct bio *bio)
 		return BLK_QC_T_NONE;
 	}
 
-	if (bio->bi_end_io != md_end_io) {
-		struct md_io *md_io;
-
-		md_io = mempool_alloc(&mddev->md_io_pool, GFP_NOIO);
-		md_io->mddev = mddev;
-		md_io->orig_bi_end_io = bio->bi_end_io;
-		md_io->orig_bi_private = bio->bi_private;
-		md_io->orig_bi_bdev = bio->bi_bdev;
-
-		bio->bi_end_io = md_end_io;
-		bio->bi_private = md_io;
-
-		md_io->start_time = bio_start_io_acct(bio);
-	}
-
 	/* bio could be mergeable after passing to underlayer */
 	bio->bi_opf &= ~REQ_NOMERGE;
 
@@ -5608,7 +5569,6 @@ static void md_free(struct kobject *ko)
 
 	bioset_exit(&mddev->bio_set);
 	bioset_exit(&mddev->sync_set);
-	mempool_exit(&mddev->md_io_pool);
 	kfree(mddev);
 }
 
@@ -5705,11 +5665,6 @@ static int md_alloc(dev_t dev, char *name)
 		 */
 		mddev->hold_active = UNTIL_STOP;
 
-	error = mempool_init_kmalloc_pool(&mddev->md_io_pool, BIO_POOL_SIZE,
-					  sizeof(struct md_io));
-	if (error)
-		goto abort;
-
 	error = -ENOMEM;
 	mddev->queue = blk_alloc_queue(NUMA_NO_NODE);
 	if (!mddev->queue)
diff --git a/drivers/md/md.h b/drivers/md/md.h
index fb7eab58cfd5..4da240ffe2c5 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -487,7 +487,6 @@ struct mddev {
 	struct bio_set			sync_set; /* for sync operations like
 						   * metadata and bitmap writes
 						   */
-	mempool_t			md_io_pool;
 
 	/* Generic flush handling.
 	 * The last to finish preflush schedules a worker to submit
-- 
2.25.1

