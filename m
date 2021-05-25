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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5836DC2B9F8
	for <linux-raid@archiver.kernel.org>; Tue, 25 May 2021 09:48:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E2CF613FA
	for <linux-raid@archiver.kernel.org>; Tue, 25 May 2021 09:48:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232728AbhEYJso (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 25 May 2021 05:48:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232720AbhEYJsl (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 25 May 2021 05:48:41 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D2A9C061756
        for <linux-raid@vger.kernel.org>; Tue, 25 May 2021 02:47:10 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id 6so22283275pgk.5
        for <linux-raid@vger.kernel.org>; Tue, 25 May 2021 02:47:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yzPdPf8A+XYlIU6iP9u4H+UnqgjN/8DXh9TegflkiVo=;
        b=an8o1jcwYf2/wwqCDf68X7M/hLMPnr+3S2pgkb1Slp9UOBTlWcbeoQFUNgU7bWAEjN
         bCj7SGLy6oIstZhPo4d5HW72HYnJBhhaZzv1XCfpP6zoUX5unjGDWAq038FITaGoCxnV
         pJH5L1bIjdg1bxShp3UiARyR2UTo/lGsOJQwdfH1F3KjlkHP8rwEjPhBuiW9PoJpIyQG
         m2MyFyvZ1yl7fOwGXI2dq+/nBxdDU0nNj7CypqfdIF6ruguyCzNVDpxcpIqeslWEqqMw
         aummQmNJMvU3Q7uUMid7yqMG1LQKf2TWtNOdO9wGk4RQEsZD3LU63k1WL5c3aJ6geSkh
         CYTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yzPdPf8A+XYlIU6iP9u4H+UnqgjN/8DXh9TegflkiVo=;
        b=cE3k0Dpe6kl+lia7wAGczLtytmec9w9qXAziXyQf0iL9hbtxA3Pv9QvuKs/ztn5BUi
         QnT4S08w97tttEOGv1HRCwnzIsP6HfMIgu9Y71gWMGQ+/1R5vXTwR/PkxmWInudSCHsr
         tApIk9kH/wGOVvbkGF5dZRtV0DPcVWECbBTGgDH/bOlOG62mhwhgzu0OwdfwX5IWmKKe
         j8XztgBWDJOb/fY8XYM9d+t1dkvKa9LzlKstKJOwSD1PzGpvuf0igRul4xuNWV3eKyxQ
         5196kWpBtzOBOxmT8ftDLUyeV9IW+Lu97greQuLVQWhod2zsnHTaa/k0G6teCw/6bLDn
         CNjg==
X-Gm-Message-State: AOAM533bShBLnWog+OBJzFp4Myv/QE947NpXYElMwMDXw8Z1IriHWN3p
        i19+P+9oIrEmYhen8AFLh8M=
X-Google-Smtp-Source: ABdhPJw+WAGnWM8iWB6Dgr4lYiq50szEVjTaTwksJpd3/NiBIVI34FO3pPX2JphPUSGImTY/c68oDA==
X-Received: by 2002:a62:8fcf:0:b029:2e8:f2ba:38e7 with SMTP id n198-20020a628fcf0000b02902e8f2ba38e7mr7050160pfd.1.1621936030247;
        Tue, 25 May 2021 02:47:10 -0700 (PDT)
Received: from localhost.localdomain ([89.187.161.155])
        by smtp.gmail.com with ESMTPSA id r10sm13114437pfl.159.2021.05.25.02.47.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 May 2021 02:47:09 -0700 (PDT)
From:   Guoqing Jiang <jgq516@gmail.com>
X-Google-Original-From: Guoqing Jiang <jiangguoqing@kylinos.cn>
To:     song@kernel.org
Cc:     linux-raid@vger.kernel.org, artur.paszkiewicz@intel.com,
        hch@infradead.org
Subject: [PATCH V3 6/8] md/raid1: enable io accounting
Date:   Tue, 25 May 2021 17:46:21 +0800
Message-Id: <20210525094623.763195-7-jiangguoqing@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210525094623.763195-1-jiangguoqing@kylinos.cn>
References: <20210525094623.763195-1-jiangguoqing@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

For raid1, we record the start time between split bio and clone bio,
and finish the accounting in the final endio.

Also introduce start_time in r1bio accordingly.

Signed-off-by: Guoqing Jiang <jiangguoqing@kylinos.cn>
---
 drivers/md/raid1.c | 7 +++++++
 drivers/md/raid1.h | 1 +
 2 files changed, 8 insertions(+)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 696da6b8b7ed..51f2547c2007 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -300,6 +300,8 @@ static void call_bio_endio(struct r1bio *r1_bio)
 	if (!test_bit(R1BIO_Uptodate, &r1_bio->state))
 		bio->bi_status = BLK_STS_IOERR;
 
+	if (blk_queue_io_stat(bio->bi_bdev->bd_disk->queue))
+		bio_end_io_acct(bio, r1_bio->start_time);
 	bio_endio(bio);
 }
 
@@ -1292,6 +1294,9 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
 
 	r1_bio->read_disk = rdisk;
 
+	if (!r1bio_existed && blk_queue_io_stat(bio->bi_bdev->bd_disk->queue))
+		r1_bio->start_time = bio_start_io_acct(bio);
+
 	read_bio = bio_clone_fast(bio, gfp, &mddev->bio_set);
 
 	r1_bio->bios[rdisk] = read_bio;
@@ -1461,6 +1466,8 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 		r1_bio->sectors = max_sectors;
 	}
 
+	if (blk_queue_io_stat(bio->bi_bdev->bd_disk->queue))
+		r1_bio->start_time = bio_start_io_acct(bio);
 	atomic_set(&r1_bio->remaining, 1);
 	atomic_set(&r1_bio->behind_remaining, 0);
 
diff --git a/drivers/md/raid1.h b/drivers/md/raid1.h
index b7eb09e8c025..ccf10e59b116 100644
--- a/drivers/md/raid1.h
+++ b/drivers/md/raid1.h
@@ -158,6 +158,7 @@ struct r1bio {
 	sector_t		sector;
 	int			sectors;
 	unsigned long		state;
+	unsigned long		start_time;
 	struct mddev		*mddev;
 	/*
 	 * original bio going to /dev/mdx
-- 
2.25.1

