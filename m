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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0249FC433ED
	for <linux-raid@archiver.kernel.org>; Tue, 18 May 2021 05:33:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D0BCF611AD
	for <linux-raid@archiver.kernel.org>; Tue, 18 May 2021 05:33:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241071AbhERFef (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 18 May 2021 01:34:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240761AbhERFee (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 18 May 2021 01:34:34 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A1ECC061573
        for <linux-raid@vger.kernel.org>; Mon, 17 May 2021 22:33:16 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id w1so3921118pfu.0
        for <linux-raid@vger.kernel.org>; Mon, 17 May 2021 22:33:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PQde+5nWUtdM9M6ShhtsbBVC9bKZh1kONtR0TFqgHX8=;
        b=kO1NLQOVePtfonfU7BFDGViJnOAZKirjiRoxK76IPVNgD08nhn5a1JBHl1rVv7dUoz
         VxQQbotd/y0jzoZScJ7unb5fI1o81zG0CW+f6wqUh1zMfwEg/lcjwLPWCNBOTlCjc0ih
         NPFp36QSCYht7n9Vt3x1NKxvHCjV9KERGx8IMJcyjNryubfMET3DfI2kZIJ+gPrvxX5n
         L8CE/eVS4uW4eDnv44U4GwI88JJLG7FnOsybJxMiCVn5BjjDZKp9vhp2XFpXGbKyDrjQ
         Tvz35aBNyXmxqIlawb7XP77+gker4PtAZ8Yq7ux/O94XXvRb+XDN7lcl0eesoS5WUrnU
         8BGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PQde+5nWUtdM9M6ShhtsbBVC9bKZh1kONtR0TFqgHX8=;
        b=qPO/vyhTKN1DGd7pm2sdMIZY7lNSOtk5pxdol2VPEVTvr1pvoYjQWwUcpwM69x8z3q
         LVR5zXjBYkMonBXC19C2qvBx+OQ95LNf37LO5pxNh2LjYjwk4CI8p4DGx4+L0VFxPihs
         xpN/SWMRf+mqiWRhoHRt/a+K9pbuw0QauM1wCQXlH2mpFgKx39nStUu+UQHXhNAFlcWA
         LwFAlofWkd+W54iznHkOi21nXw9F+aSJzJXlUkyAYvG0C8PcTP8zAJR6vrlb+W2mNNh2
         lGrMUI7VusN7YWJrOY0o+zozqHb4SZiqj3e2cfTDh1Ms80FZYCmv8IymQNjwYtJm7cN9
         3o6Q==
X-Gm-Message-State: AOAM532+rurBAk5itaxu3NIsxLU2PiMeHecBebnGiVhPsw2LS1UFzb2m
        eQ4biE9CdpLSC77CN5aVt60=
X-Google-Smtp-Source: ABdhPJx5vpr2xVSEERtM5LiF351q1ddOPQatQns9TpvJsOeJV+eskXZIdfBrkToY6sVdDyMqEXlkVQ==
X-Received: by 2002:a63:795:: with SMTP id 143mr2862985pgh.43.1621315995837;
        Mon, 17 May 2021 22:33:15 -0700 (PDT)
Received: from localhost.localdomain ([89.187.161.155])
        by smtp.gmail.com with ESMTPSA id z20sm11756726pjq.47.2021.05.17.22.33.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 22:33:15 -0700 (PDT)
From:   Guoqing Jiang <jgq516@gmail.com>
X-Google-Original-From: Guoqing Jiang <jiangguoqing@kylinos.cn>
To:     song@kernel.org
Cc:     linux-raid@vger.kernel.org, artur.paszkiewicz@intel.com,
        Guoqing Jiang <jiangguoqing@kylinos.cn>
Subject: [PATCH 5/5] md/raid10: enable io accounting
Date:   Tue, 18 May 2021 13:32:25 +0800
Message-Id: <20210518053225.641506-6-jiangguoqing@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210518053225.641506-1-jiangguoqing@kylinos.cn>
References: <20210518053225.641506-1-jiangguoqing@kylinos.cn>
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
 drivers/md/raid10.c | 7 +++++++
 drivers/md/raid10.h | 1 +
 2 files changed, 8 insertions(+)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 13f5e6b2a73d..38795c237830 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -297,6 +297,9 @@ static void raid_end_bio_io(struct r10bio *r10_bio)
 	if (!test_bit(R10BIO_Uptodate, &r10_bio->state))
 		bio->bi_status = BLK_STS_IOERR;
 
+	if (blk_queue_io_stat(bio->bi_bdev->bd_disk->queue))
+		bio_end_io_acct_remapped(bio, r10_bio->start_time,
+					 bio->bi_bdev);
 	bio_endio(bio);
 	/*
 	 * Wake up any possible resync thread that waits for the device
@@ -1184,6 +1187,8 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
 	}
 	slot = r10_bio->read_slot;
 
+	if (blk_queue_io_stat(bio->bi_bdev->bd_disk->queue))
+		r10_bio->start_time = bio_start_io_acct(bio);
 	read_bio = bio_clone_fast(bio, gfp, &mddev->bio_set);
 
 	r10_bio->devs[slot].bio = read_bio;
@@ -1483,6 +1488,8 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
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

