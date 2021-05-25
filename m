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
	by smtp.lore.kernel.org (Postfix) with ESMTP id D65B5C47084
	for <linux-raid@archiver.kernel.org>; Tue, 25 May 2021 09:47:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B020761284
	for <linux-raid@archiver.kernel.org>; Tue, 25 May 2021 09:47:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232702AbhEYJsd (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 25 May 2021 05:48:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232508AbhEYJsc (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 25 May 2021 05:48:32 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A19FEC061756
        for <linux-raid@vger.kernel.org>; Tue, 25 May 2021 02:46:58 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id t193so22300822pgb.4
        for <linux-raid@vger.kernel.org>; Tue, 25 May 2021 02:46:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zVx1dxeLUcTko+lLjqbpHzUN3VfpbG3ciX+AJaqUnMo=;
        b=UKA3uX6gXXOho6QoVnEekphZF5fcwUQL1w74lroxg4wMFgPfT/H0xHWqovbpQXIKRh
         ZEUy/7/GGcbVCvvYNwVsPzbtnYxVV1ATXHlVBh19j0tZ30K88iCJGK/Cm0fo76ryZ8Im
         ZfpB711Ij70kMo24Fx9ItDxKsa60eEyiKKHn1F2lIKYzIonra68YA9ZS3J21VfrVi2AN
         h/sTFRWq5iiEN/mA+5QDh92K5BbM27/VycXdWDrxLozTfuzCXTO/b2Gh1sE1W4tO4Xoz
         7wzXCTWsLDa2BXTb3J/zB8FyQ1ZIT1XsYpEmg2zYp8JHb26nD4XNzW4EdF25+XWba+qt
         zQXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zVx1dxeLUcTko+lLjqbpHzUN3VfpbG3ciX+AJaqUnMo=;
        b=g21S4dWwdchJ6Kd7kJlsEUiLR350RruPziLVRU/G5mhLDjaKO7xXgTI0yK5bOyesnM
         duo5kNlikVofawZcy3iwuZgrV3So9XIqq9X9vPuB/a/f4Bf+5ZyuVIuu0Ije5hrCYjc3
         HhgK7yyA19afvkJ2kaFXmXGAAc6rudP0i96H3/2/h+8wA+QwrCOBiP8wkpxHL6Qhglbq
         /pw1Sy0g2ejUuCG/wTkR79gqWCu52jt1HcDV4UxsnHIjPBSTusBJ+4eW4lmzL231x1YJ
         +qYO1B6+4gNOqwrb8OCFsrSScFobZdI0BsAchDxsJK3iAgLQzDotXhr6sNweFCTmfbYa
         78BA==
X-Gm-Message-State: AOAM531ibqr+EMANjdQtAmwUwJpkRZr8zNw1mRFuBndStR+Cp23JNWOo
        hDGcRVLqMqpaxK0QyxO3hmE=
X-Google-Smtp-Source: ABdhPJxTjqSJjJuWSofltXhMm699qdykf/xlQQVtiJIlD90jLTOcMc59U2K5MrQNDSEPQJaqpDFPCw==
X-Received: by 2002:aa7:874a:0:b029:2e7:8407:f8f3 with SMTP id g10-20020aa7874a0000b02902e78407f8f3mr15086057pfo.53.1621936018277;
        Tue, 25 May 2021 02:46:58 -0700 (PDT)
Received: from localhost.localdomain ([89.187.161.155])
        by smtp.gmail.com with ESMTPSA id r10sm13114437pfl.159.2021.05.25.02.46.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 May 2021 02:46:57 -0700 (PDT)
From:   Guoqing Jiang <jgq516@gmail.com>
X-Google-Original-From: Guoqing Jiang <jiangguoqing@kylinos.cn>
To:     song@kernel.org
Cc:     linux-raid@vger.kernel.org, artur.paszkiewicz@intel.com,
        hch@infradead.org
Subject: [PATCH V3 1/8] md: revert io stats accounting
Date:   Tue, 25 May 2021 17:46:16 +0800
Message-Id: <20210525094623.763195-2-jiangguoqing@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210525094623.763195-1-jiangguoqing@kylinos.cn>
References: <20210525094623.763195-1-jiangguoqing@kylinos.cn>
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

