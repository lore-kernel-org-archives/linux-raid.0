Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78B9DC433B4
	for <linux-raid@archiver.kernel.org>; Tue, 18 May 2021 05:33:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A9DF60FDB
	for <linux-raid@archiver.kernel.org>; Tue, 18 May 2021 05:33:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241023AbhERFec (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 18 May 2021 01:34:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240761AbhERFeb (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 18 May 2021 01:34:31 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DE0EC061573
        for <linux-raid@vger.kernel.org>; Mon, 17 May 2021 22:33:13 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id k19so6582919pfu.5
        for <linux-raid@vger.kernel.org>; Mon, 17 May 2021 22:33:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=j1+u0rqgflM3UJt8xZcj9lUXm8KM2BwK8jgs0AUAyFI=;
        b=rzUfCJXC/7/oFT9R/oj1lElHD1+JbiPmy56GcBhyBlV1t7M7Nrkeoa8KH7ebPNfRrc
         LL2DzNjtj6mHNDfqnIMkBQXpaU3RDMMKWC3eebLaDYCsyDCCCSlS/br7jgbOsG2x2IcP
         OlsSXNzyV8ik9hilf17qRT0bzWO3ufe02hq7Aj1/38oPB4jOBdrAw4Rwe23k5g+eSiT0
         F8zKPjs1fC5bVGExwvezS+1/E8pKJICBh60cxPbt81r1I9MswMAF9NxoXPkW02siCktx
         /Ggagobk79GZBIAKrRJDSaDBgilgarqS5nJ9zk8w4G1LWR6xQycRhac+T9Ua5hG7mWSb
         yegg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=j1+u0rqgflM3UJt8xZcj9lUXm8KM2BwK8jgs0AUAyFI=;
        b=DQCIpTdykXSIIEt3ip3waX1Qw1COD7n75vfrTZ0ZiMSpRdIebKwDVvxXcV1TBu7UmT
         wAc+2uMdrBxkL+vdFcJk4+6vy8b7lMrZ0gDPDpEKgYGRRgNt8IgzlVJYZj58ujt5n/Dz
         r7SlDAzNkRvIwJi76VjsGD0ZMJYllckhnKYJcP44TKaN5LlPYVDdz57jeLo+R0cdUF4L
         FDdjbEZl+MeVawYlEbq+ElImzUyTqj+abmeTEsDXqIDG+ph41KtAsZ80EYjqkVzxMD/c
         nbgHJ8EPz8HTIHkVCVAzDubSSIMXI2OZPPWfJTeLaOGJoEEz2fdwcSmPy2a688+2eo1M
         v58w==
X-Gm-Message-State: AOAM533LGK9x5ymziBnNSJzhgFALAyu5p+COYBo3JlIleM/iDVoHL9DB
        dok2h/RSqZdyrwfJH74qxkA=
X-Google-Smtp-Source: ABdhPJyW1A/PeFxuQarqQoKrzusDtwmYkWYGJ9ZRNrJmPElLtHDj/eoNi7IykX3LD/wv/a604W2P4A==
X-Received: by 2002:a63:5160:: with SMTP id r32mr3336817pgl.83.1621315992967;
        Mon, 17 May 2021 22:33:12 -0700 (PDT)
Received: from localhost.localdomain ([89.187.161.155])
        by smtp.gmail.com with ESMTPSA id z20sm11756726pjq.47.2021.05.17.22.33.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 22:33:12 -0700 (PDT)
From:   Guoqing Jiang <jgq516@gmail.com>
X-Google-Original-From: Guoqing Jiang <jiangguoqing@kylinos.cn>
To:     song@kernel.org
Cc:     linux-raid@vger.kernel.org, artur.paszkiewicz@intel.com,
        Guoqing Jiang <jiangguoqing@kylinos.cn>
Subject: [PATCH 4/5] md/raid1: enable io accounting
Date:   Tue, 18 May 2021 13:32:24 +0800
Message-Id: <20210518053225.641506-5-jiangguoqing@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210518053225.641506-1-jiangguoqing@kylinos.cn>
References: <20210518053225.641506-1-jiangguoqing@kylinos.cn>
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
 drivers/md/raid1.c | 11 +++++++++++
 drivers/md/raid1.h |  1 +
 2 files changed, 12 insertions(+)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index ced076ba560e..b08a47523dbb 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -300,6 +300,8 @@ static void call_bio_endio(struct r1bio *r1_bio)
 	if (!test_bit(R1BIO_Uptodate, &r1_bio->state))
 		bio->bi_status = BLK_STS_IOERR;
 
+	if (blk_queue_io_stat(bio->bi_bdev->bd_disk->queue))
+		bio_end_io_acct_remapped(bio, r1_bio->start_time, bio->bi_bdev);
 	bio_endio(bio);
 }
 
@@ -1292,6 +1294,13 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
 
 	r1_bio->read_disk = rdisk;
 
+	/*
+	 * Reuse print_msg, if it is false then a fresh r1_bio is just
+	 * allocated before.
+	 */
+	if (!print_msg && blk_queue_io_stat(bio->bi_bdev->bd_disk->queue))
+		r1_bio->start_time = bio_start_io_acct(bio);
+
 	read_bio = bio_clone_fast(bio, gfp, &mddev->bio_set);
 
 	r1_bio->bios[rdisk] = read_bio;
@@ -1461,6 +1470,8 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
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

