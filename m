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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A12EC2B9F8
	for <linux-raid@archiver.kernel.org>; Tue, 25 May 2021 09:48:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 158A3613FA
	for <linux-raid@archiver.kernel.org>; Tue, 25 May 2021 09:48:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232655AbhEYJto (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 25 May 2021 05:49:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232755AbhEYJso (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 25 May 2021 05:48:44 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34840C061574
        for <linux-raid@vger.kernel.org>; Tue, 25 May 2021 02:47:13 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id a7so7386209plh.3
        for <linux-raid@vger.kernel.org>; Tue, 25 May 2021 02:47:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nG6NWDUi09tEfdGLE7+zW+x9YCauidoCKtemREdhP84=;
        b=c3PHO/pkkElyTfoLSsHIYC4FBK2lsZGxANczHngoCxdxrzTldRAFlO66ohvdSBkaxi
         Ub0lo+lPggyfAg/T3vOYsY5CzrKYUU7fiJQSEUOQinRo45XSKpLkEsdwma0XA96vLcat
         nHpaVgyr/WpZoKYH6Jj6fX5X7wu6wTep86cpuU3TXAxoUshzoCeGg6YXE2WHoAGtzD+s
         nC5JaZYofp7pngiupRjaSPyTWgef+JlzLPCjhJB010JGPtvek+Y2a7W373aV0JUXsehr
         KaSaoRJepoyKlcfqSvj8iMOxIPuCeKpXd3+GX7NwfbAuxrblcj3eTF4hxOjlN1X15A+s
         aRKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nG6NWDUi09tEfdGLE7+zW+x9YCauidoCKtemREdhP84=;
        b=LPg1Wqb5keXXUaDg1C4JguTLHvUM8XTbCHfwwcUQgBSe/6RztRRUNiy2cC70s7c1mw
         foRJkoG997NVXO6fZ/JU3Uqm8hE1TuTqyk4bAHbUB5nHdtFCqBOw4KVd7b90jnu87wip
         V/dn6SuW/W7K28L5axYJ9wfA7YUXGLQUqdXsqtl34hBp89Ho5fpiU++AgqLei1h3EkNX
         lgN7JZwiMtn2+smMsGfzubFTZ9FMU20WeHuooEhQdH1h8pY9hkvuy5ZV1bvF2ejEiOm9
         xMpwMwAKt1al+W3dryAQ/1AB/Bin7PQBEpUq9+hqvlP1IfqgJHC3zq4nqCWxv21oXQU2
         D+hA==
X-Gm-Message-State: AOAM533dEXSckvOoU5QGp+CiLeAjvD4d3ck9dhaKNyjhMH8qLAOINhrn
        LvhpDU1v0oGFdSqr/YAJGHw=
X-Google-Smtp-Source: ABdhPJzZeRGDE4Bs3jpa0F+RAi2+kFEzbYyylr2cBW+h02EJG1rZz+iuMNMyi+s6TI1LIRpKjD4CGw==
X-Received: by 2002:a17:90b:116:: with SMTP id p22mr28834967pjz.186.1621936032817;
        Tue, 25 May 2021 02:47:12 -0700 (PDT)
Received: from localhost.localdomain ([89.187.161.155])
        by smtp.gmail.com with ESMTPSA id r10sm13114437pfl.159.2021.05.25.02.47.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 May 2021 02:47:12 -0700 (PDT)
From:   Guoqing Jiang <jgq516@gmail.com>
X-Google-Original-From: Guoqing Jiang <jiangguoqing@kylinos.cn>
To:     song@kernel.org
Cc:     linux-raid@vger.kernel.org, artur.paszkiewicz@intel.com,
        hch@infradead.org
Subject: [PATCH V3 7/8] md/raid10: enable io accounting
Date:   Tue, 25 May 2021 17:46:22 +0800
Message-Id: <20210525094623.763195-8-jiangguoqing@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210525094623.763195-1-jiangguoqing@kylinos.cn>
References: <20210525094623.763195-1-jiangguoqing@kylinos.cn>
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

