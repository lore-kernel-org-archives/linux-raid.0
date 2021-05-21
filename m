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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 815B8C433ED
	for <linux-raid@archiver.kernel.org>; Fri, 21 May 2021 00:56:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 60259600CD
	for <linux-raid@archiver.kernel.org>; Fri, 21 May 2021 00:56:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235644AbhEUA6I (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 20 May 2021 20:58:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235619AbhEUA6I (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 20 May 2021 20:58:08 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70F6FC061574
        for <linux-raid@vger.kernel.org>; Thu, 20 May 2021 17:56:46 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id j12so13025394pgh.7
        for <linux-raid@vger.kernel.org>; Thu, 20 May 2021 17:56:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nG6NWDUi09tEfdGLE7+zW+x9YCauidoCKtemREdhP84=;
        b=JqztQc3QjiD/j95r3qv2PHg+t30h6PtV3TuACCjVrV2kJ1zYVoQwzjeFYrmapG41TT
         py091jlbiYaEOJFqnFmdhA0k3aQA5w6NQ/o94mJtfp76C+tO//pQ/YOuGT14oKUwwude
         iqDrfyQNgUswLbzRFI9XLxN+2tl1AOfd8jQGPCztn1akKQ7C77RnkzBdSS7dswCixjf8
         BCvs3yA/QWIEmi04vz5wtbsoP1NjbTUBXrtK9T+pUeVWJeS0cblp33f3Px57Cxkv/wSg
         wy0XA5ilYTy5VOyGup7Pi0a8JzFh0avrIlLKBu8ZtrlYHYM8VxYivVg2ASqzlTw1aTwj
         4nKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nG6NWDUi09tEfdGLE7+zW+x9YCauidoCKtemREdhP84=;
        b=pgdsMD7psuxXjntf2yGTIqDTRVzXYLU//9WQjLgbmUx651P56s5ZVni4b11LY0YkGt
         uiBefNVyp0xPbW67ojhMJXBJSgClq+Rd3VXnl44dilH+wAobmkTXd9FwI4DlYFaJ6LcJ
         oDWmdKpMocbO0s/rizUCu9bjyOa1lQv7yRKGYG+t36BbBH8y1+JASaf7GZZbc7n3v/3e
         ZrRiUXSIJzoSCk/1PdbdqFj7K2lQYgG247plXilW0zBISnFBqUTz747d6ASqleHnIx77
         NQ5qBwmf6Ahfcx6iUzTauaHVEqyaKTMWn5onCzZ6wPkW6cXnamy25UYHl4L96JLc26pq
         L1ow==
X-Gm-Message-State: AOAM531akWvu3lu3WlOpTxx2s9QlJhb2PbNmFqaDIJcpruUyRM7rcaU/
        rNvh7WpYoSednatOvbKCvEw=
X-Google-Smtp-Source: ABdhPJyXEgM31SbRrLgEomOrir5vQD2oF00oWA5ngnXV2c7EKDWPka/87EssH/jYf3u04RodMroGrA==
X-Received: by 2002:a62:7d82:0:b029:2de:2c39:c6a4 with SMTP id y124-20020a627d820000b02902de2c39c6a4mr7308948pfc.75.1621558606078;
        Thu, 20 May 2021 17:56:46 -0700 (PDT)
Received: from localhost.localdomain ([89.187.161.155])
        by smtp.gmail.com with ESMTPSA id 5sm7405945pjo.17.2021.05.20.17.56.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 May 2021 17:56:45 -0700 (PDT)
From:   Guoqing Jiang <jgq516@gmail.com>
X-Google-Original-From: Guoqing Jiang <jiangguoqing@kylinos.cn>
To:     song@kernel.org
Cc:     linux-raid@vger.kernel.org, artur.paszkiewicz@intel.com
Subject: [PATCH V2 6/7] md/raid10: enable io accounting
Date:   Fri, 21 May 2021 08:55:20 +0800
Message-Id: <20210521005521.713106-7-jiangguoqing@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210521005521.713106-1-jiangguoqing@kylinos.cn>
References: <20210521005521.713106-1-jiangguoqing@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

For raid10, we record the start time between split bio and clone bio,
and finish the accounting in the final endio.

Also introduce start_time in r10bio accordingly.

Signed-off-by: Guoqing Jiang <jiangguoqing@kylinos.cn>
---
 drivers/md/raid10.c | 6 ++++++
 drivers/md/raid10.h | 1 +
 2 files changed, 7 insertions(+)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 13f5e6b2a73d..16977e8e075d 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -297,6 +297,8 @@ static void raid_end_bio_io(struct r10bio *r10_bio)
 	if (!test_bit(R10BIO_Uptodate, &r10_bio->state))
 		bio->bi_status = BLK_STS_IOERR;
 
+	if (blk_queue_io_stat(bio->bi_bdev->bd_disk->queue))
+		bio_end_io_acct(bio, r10_bio->start_time);
 	bio_endio(bio);
 	/*
 	 * Wake up any possible resync thread that waits for the device
@@ -1184,6 +1186,8 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
 	}
 	slot = r10_bio->read_slot;
 
+	if (blk_queue_io_stat(bio->bi_bdev->bd_disk->queue))
+		r10_bio->start_time = bio_start_io_acct(bio);
 	read_bio = bio_clone_fast(bio, gfp, &mddev->bio_set);
 
 	r10_bio->devs[slot].bio = read_bio;
@@ -1483,6 +1487,8 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 		r10_bio->master_bio = bio;
 	}
 
+	if (blk_queue_io_stat(bio->bi_bdev->bd_disk->queue))
+		r10_bio->start_time = bio_start_io_acct(bio);
 	atomic_set(&r10_bio->remaining, 1);
 	md_bitmap_startwrite(mddev->bitmap, r10_bio->sector, r10_bio->sectors, 0);
 
diff --git a/drivers/md/raid10.h b/drivers/md/raid10.h
index 1461fd55311b..c34bb196790e 100644
--- a/drivers/md/raid10.h
+++ b/drivers/md/raid10.h
@@ -124,6 +124,7 @@ struct r10bio {
 	sector_t		sector;	/* virtual sector number */
 	int			sectors;
 	unsigned long		state;
+	unsigned long		start_time;
 	struct mddev		*mddev;
 	/*
 	 * original bio going to /dev/mdx
-- 
2.25.1

