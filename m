Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6DCCC433EF
	for <linux-raid@archiver.kernel.org>; Wed, 10 Nov 2021 18:15:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADD3E6103C
	for <linux-raid@archiver.kernel.org>; Wed, 10 Nov 2021 18:15:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231932AbhKJSR6 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 10 Nov 2021 13:17:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231903AbhKJSR4 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 10 Nov 2021 13:17:56 -0500
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 826EDC061764
        for <linux-raid@vger.kernel.org>; Wed, 10 Nov 2021 10:15:08 -0800 (PST)
Received: by mail-il1-x12a.google.com with SMTP id l8so3445860ilv.3
        for <linux-raid@vger.kernel.org>; Wed, 10 Nov 2021 10:15:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=rlhgB97iV/qX70s6H0sid5aK6Z1F1GTaN8hvtTONShU=;
        b=IDTSvvbwNVNh6/J19Vm7aMUSp26t+df0eptEyA83K2ctYFowxR9l6TM7V88PfBlx1g
         pIxc9rvAJm9boUMeADZgUFw6MkfQ97XbOnVCz5eUELpKGzrZsI8KQhD1ljllS8jGYqfq
         S+221+s7e1YAINp1ngk7S1u3nrezPrG6tS5Wc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=rlhgB97iV/qX70s6H0sid5aK6Z1F1GTaN8hvtTONShU=;
        b=SrC0uUjMztqCHUIutAkHHLWrGGvYY27ueKtj1YapM6nCbzFsf8xM8gXrsKlcP5TyYS
         c/3iw/wWPwUxXdztv7eQxCqt0yjMHe2441MGVUTjZNd/O9BJl/vNoCHEPAIolxkpv8iq
         mThIIA0m3/Km1QdxKmNJsb9K1cF9KOPDCNG95crVxe926/sPuKMO6mnE5Fkl4Y+cycGM
         tJkGHVY+FEYWdDYTfQ0OwEcZVMGfzlO0U3gIog76uSV480iYOd3x2Bjx8c7oiCzpULCq
         wW5tsp3tgG17Zts1zvtOFaGcxhoELohovHUJps3oAkndpFwHnB66GY33YHCKpwyMkkRP
         VLBg==
X-Gm-Message-State: AOAM530MVXv2qv5O2HJZ7HDhDm+PE0Qvt1eTIF4kIg0hiXaHznoMaWA3
        r7od5kpLDwwttrjNNLu1VAc4iQ==
X-Google-Smtp-Source: ABdhPJzy8ZRC7qTMFXiHKFYzJiAPpYyibrDMmynT4gIzlXqrFbFmzjSqpF82ZmtnYGbIbeEv6V81LQ==
X-Received: by 2002:a05:6e02:20e4:: with SMTP id q4mr623739ilv.71.1636568108003;
        Wed, 10 Nov 2021 10:15:08 -0800 (PST)
Received: from vverma-s2-cbrunner ([162.243.188.99])
        by smtp.gmail.com with ESMTPSA id b9sm306969ilo.73.2021.11.10.10.15.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Nov 2021 10:15:07 -0800 (PST)
From:   Vishal Verma <vverma@digitalocean.com>
To:     song@kernel.org, linux-raid@vger.kernel.org, rgoldwyn@suse.de
Cc:     axboe@kernel.dk, Vishal Verma <vverma@digitalocean.com>
Subject: [RFC PATCH v4 4/4] md: raid456 add nowait support
Date:   Wed, 10 Nov 2021 18:14:41 +0000
Message-Id: <20211110181441.9263-4-vverma@digitalocean.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211110181441.9263-1-vverma@digitalocean.com>
References: <CAPhsuW6mSmxPOmU9=Gq-z_gV4V09+SFqrpKx33LzR=6Rg1fGZw@mail.gmail.com>
 <20211110181441.9263-1-vverma@digitalocean.com>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Returns EAGAIN in case the raid456 driver would block
waiting for situations like:

  - Reshape operation,
  - Discard operation.

Signed-off-by: Vishal Verma <vverma@digitalocean.com>
---
 drivers/md/raid5.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 9c1a5877cf9f..fa64ee315241 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5710,6 +5710,11 @@ static void make_discard_request(struct mddev *mddev, struct bio *bi)
 		int d;
 	again:
 		sh = raid5_get_active_stripe(conf, logical_sector, 0, 0, 0);
+		/* Bail out if REQ_NOWAIT is set */
+		if (bi->bi_opf & REQ_NOWAIT) {
+			bio_wouldblock_error(bi);
+			return;
+		}
 		prepare_to_wait(&conf->wait_for_overlap, &w,
 				TASK_UNINTERRUPTIBLE);
 		set_bit(R5_Overlap, &sh->dev[sh->pd_idx].flags);
@@ -5820,6 +5825,15 @@ static bool raid5_make_request(struct mddev *mddev, struct bio * bi)
 	bi->bi_next = NULL;
 
 	md_account_bio(mddev, &bi);
+	/* Bail out if REQ_NOWAIT is set */
+	if (bi->bi_opf & REQ_NOWAIT &&
+	    conf->reshape_progress != MaxSector &&
+	    mddev->reshape_backwards
+	    ? logical_sector < conf->reshape_safe
+	    : logical_sector >= conf->reshape_safe) {
+		bio_wouldblock_error(bi);
+		return true;
+	}
 	prepare_to_wait(&conf->wait_for_overlap, &w, TASK_UNINTERRUPTIBLE);
 	for (; logical_sector < last_sector; logical_sector += RAID5_STRIPE_SECTORS(conf)) {
 		int previous;
-- 
2.17.1

