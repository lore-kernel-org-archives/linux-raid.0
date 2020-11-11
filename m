Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2ACA2C56201
	for <linux-raid@archiver.kernel.org>; Wed, 11 Nov 2020 05:17:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DDBBF20709
	for <linux-raid@archiver.kernel.org>; Wed, 11 Nov 2020 05:17:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T5ujxFfJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726090AbgKKFRZ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 11 Nov 2020 00:17:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726020AbgKKFRY (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 11 Nov 2020 00:17:24 -0500
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66F86C0613D1;
        Tue, 10 Nov 2020 21:17:23 -0800 (PST)
Received: by mail-ed1-x544.google.com with SMTP id l5so916459edq.11;
        Tue, 10 Nov 2020 21:17:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=X52yVvDtfXKl6tt5+mqohJFrBRR2d0gZevWx4aOlRzY=;
        b=T5ujxFfJBZwKDrND9Q6tTzrFNaczL9W2hqHjTmcfevHqnQPqdmWqmSvi2Ojfc7/3Iz
         y0uhCj1pMOaXcPByMSdlScqdJI4uKVCZrIhyOFEQXD8Qs7AcYy0f5f4VCUXHYtUqEf/v
         t5x0Jsg5T83cj5woLYxKP9SNTucNvuSw8Ccm76TyR7/k/6k0MYXiE1762jtetffBC6Mv
         iI2YoUuWDgEjZBAXR9j3R6iOIYiiT1i8MfZHPlY1pFK4LTw4CHEnuZd0JHMW1qakbSrK
         ekH+LI4QKzQHyifwpKVZ6F5lqi8X03hjp3xTLttfTNMpLNB6WfK7fGSv5pZUAevsGpjY
         gWnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=X52yVvDtfXKl6tt5+mqohJFrBRR2d0gZevWx4aOlRzY=;
        b=Jpp9FPz6u1PTr+XGw5q2KYBhe2jfprVhTwY9AghxRN2YA0tdBKwwGkKOSN2Ml3JTA8
         8/KA9QAkDRkQk0s6GRFlHD8h7hOiwkKnWkynKnzL6rxBR6Z+k8HmkafgjbagmHW5iUbQ
         AQ7DG9uiJvedjcYjhdw2Sp9+WMhZXAsUZ7sDkL5VN7Doa/yyB8UCDSJD5V4w6dmCDTXt
         qO5uU5Bkm6ezEzFTG5r3KECE/N/uuWQnnh8FAEcwPXxC4FZngU0u/abwI4jjndYd60//
         +XmaCJXnn5D108HRr/eWexwkNfSfbesObqHecNdpClKpfS2yPVB2OuCz2rQ8LWlr4yLD
         7uVQ==
X-Gm-Message-State: AOAM532iyURU0fjfvN9pVqGRUzHHZPpX0cFrwXz9oL5pcfSHXV2JvANe
        s35lqErKlCIIr6bm/T1JhfU=
X-Google-Smtp-Source: ABdhPJx99VQ6W3N+W4dZKCfDuGnmq89ELyoNBCyeREkQA5Vg1FMklEOsrTDz7ech2jMluO8Ugm4erw==
X-Received: by 2002:a05:6402:1701:: with SMTP id y1mr20328265edu.209.1605071842150;
        Tue, 10 Nov 2020 21:17:22 -0800 (PST)
Received: from lb01399.pb.local (p200300ca573cea52c98ae5b6a31510db.dip0.t-ipconnect.de. [2003:ca:573c:ea52:c98a:e5b6:a315:10db])
        by smtp.gmail.com with ESMTPSA id g20sm363628ejz.88.2020.11.10.21.17.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2020 21:17:21 -0800 (PST)
From:   Pankaj Gupta <pankaj.gupta.linux@gmail.com>
To:     song@kernel.org
Cc:     linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        pankaj.gupta.linux@gmail.com,
        Pankaj Gupta <pankaj.gupta@cloud.ionos.com>
Subject: [PATCH 1/3] md: improve variable names in md_flush_request()
Date:   Wed, 11 Nov 2020 06:16:56 +0100
Message-Id: <20201111051658.18904-2-pankaj.gupta.linux@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201111051658.18904-1-pankaj.gupta.linux@gmail.com>
References: <20201111051658.18904-1-pankaj.gupta.linux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Pankaj Gupta <pankaj.gupta@cloud.ionos.com>

 This patch improves readability by using better variable names
 in flush request coalescing logic.

Signed-off-by: Pankaj Gupta <pankaj.gupta@cloud.ionos.com>
---
 drivers/md/md.c | 8 ++++----
 drivers/md/md.h | 6 +++---
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 98bac4f304ae..167c80f98533 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -639,7 +639,7 @@ static void md_submit_flush_data(struct work_struct *ws)
 	 * could wait for this and below md_handle_request could wait for those
 	 * bios because of suspend check
 	 */
-	mddev->last_flush = mddev->start_flush;
+	mddev->prev_flush_start = mddev->start_flush;
 	mddev->flush_bio = NULL;
 	wake_up(&mddev->sb_wait);
 
@@ -660,13 +660,13 @@ static void md_submit_flush_data(struct work_struct *ws)
  */
 bool md_flush_request(struct mddev *mddev, struct bio *bio)
 {
-	ktime_t start = ktime_get_boottime();
+	ktime_t req_start = ktime_get_boottime();
 	spin_lock_irq(&mddev->lock);
 	wait_event_lock_irq(mddev->sb_wait,
 			    !mddev->flush_bio ||
-			    ktime_after(mddev->last_flush, start),
+			    ktime_after(mddev->prev_flush_start, req_start),
 			    mddev->lock);
-	if (!ktime_after(mddev->last_flush, start)) {
+	if (!ktime_after(mddev->prev_flush_start, req_start)) {
 		WARN_ON(mddev->flush_bio);
 		mddev->flush_bio = bio;
 		bio = NULL;
diff --git a/drivers/md/md.h b/drivers/md/md.h
index ccfb69868c2e..2292c847f9dd 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -495,9 +495,9 @@ struct mddev {
 	 */
 	struct bio *flush_bio;
 	atomic_t flush_pending;
-	ktime_t start_flush, last_flush; /* last_flush is when the last completed
-					  * flush was started.
-					  */
+	ktime_t start_flush, prev_flush_start; /* prev_flush_start is when the previous completed
+						* flush was started.
+						*/
 	struct work_struct flush_work;
 	struct work_struct event_work;	/* used by dm to report failure event */
 	mempool_t *serial_info_pool;
-- 
2.20.1

