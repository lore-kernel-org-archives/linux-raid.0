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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 817DDC433B4
	for <linux-raid@archiver.kernel.org>; Fri, 21 May 2021 00:56:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5ACE3600CD
	for <linux-raid@archiver.kernel.org>; Fri, 21 May 2021 00:56:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235643AbhEUA6F (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 20 May 2021 20:58:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235619AbhEUA6E (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 20 May 2021 20:58:04 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A24F2C061574
        for <linux-raid@vger.kernel.org>; Thu, 20 May 2021 17:56:42 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id t30so13015082pgl.8
        for <linux-raid@vger.kernel.org>; Thu, 20 May 2021 17:56:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yzPdPf8A+XYlIU6iP9u4H+UnqgjN/8DXh9TegflkiVo=;
        b=Qpv0rKWU8Q5eTegafSOE85WIWVK0COjXzjQFOrZUnCrQa7Jxi4GKQpfMK19xG2ahpo
         YpLBA7kf69xcpOHinufnGIOnSEcdre5XvAwm5syFZz8oDhtgaujMkffYfbBeFn2M4zR2
         lYIGYAbtGscgzGIZs5FnUiXJV+NtyQrzhChRNL5t4xqxMweZT2yQKNOxea7TVGg9HXZH
         8uGYmSegvvY6oeHllhf0MSJHRfqYHmC/kANElbPpJBBj4uwmUm3zynRIprKj3ywXyJYv
         i1xrx9VG+uw1FV+aF+S+r6zcjFalp4GKarApGm4hqJ6eF+EImgqEAdUQe514szyRE/6x
         4LlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yzPdPf8A+XYlIU6iP9u4H+UnqgjN/8DXh9TegflkiVo=;
        b=sJuxufDXdQXxZUTKiQ0XPuWmanYRbFeKwLC4+wnHwBHRZXYoXoLU75wYeqgDi/0UPb
         Tjo9AdBx2UbOmo1bTkqqicF8bR4ZLJvcK1ca6qLyKupHFJLt/rbpFrfTdiMJq55Bbgkg
         oEhpe64JDmfQmwlpWmVUwP2whg90FhsxPWaoccF6hBr++as27yWZIxJXKN+i6DkkvUdy
         GVmQnIkPa3yVHaK0GN8Gs2g6Ip+gN8f/IBrQMHzU1vWKfZIXgw7piJ6jRTSZDmGmSyle
         MjxNgip5SwNDuhA3zzaaVcdkjjgqd6/bq887N4uyqDCxZmKx6+DtfPtCyPrwxzodPzQy
         XCrA==
X-Gm-Message-State: AOAM532ACF/snkM2tAo2+zxWj9ozRLOVbaLSYykB5gFw6Rl8lZBN+sCx
        OrrfaLW+9odyb1mGs9w8uas=
X-Google-Smtp-Source: ABdhPJyexqeVXpWMP3H5UjgKp2xWks+nq3xyRkvM3dkXzlWxe5lNCGDUwcvKzlT7kYDC9na20GxCdA==
X-Received: by 2002:a62:8184:0:b029:2df:ef25:358 with SMTP id t126-20020a6281840000b02902dfef250358mr7235244pfd.5.1621558602223;
        Thu, 20 May 2021 17:56:42 -0700 (PDT)
Received: from localhost.localdomain ([89.187.161.155])
        by smtp.gmail.com with ESMTPSA id 5sm7405945pjo.17.2021.05.20.17.56.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 May 2021 17:56:41 -0700 (PDT)
From:   Guoqing Jiang <jgq516@gmail.com>
X-Google-Original-From: Guoqing Jiang <jiangguoqing@kylinos.cn>
To:     song@kernel.org
Cc:     linux-raid@vger.kernel.org, artur.paszkiewicz@intel.com
Subject: [PATCH V2 5/7] md/raid1: enable io accounting
Date:   Fri, 21 May 2021 08:55:19 +0800
Message-Id: <20210521005521.713106-6-jiangguoqing@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210521005521.713106-1-jiangguoqing@kylinos.cn>
References: <20210521005521.713106-1-jiangguoqing@kylinos.cn>
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

