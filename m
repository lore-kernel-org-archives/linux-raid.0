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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20F35C388F9
	for <linux-raid@archiver.kernel.org>; Wed, 11 Nov 2020 05:17:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C451220709
	for <linux-raid@archiver.kernel.org>; Wed, 11 Nov 2020 05:17:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W8gZ4EV5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726140AbgKKFRd (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 11 Nov 2020 00:17:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726091AbgKKFRZ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 11 Nov 2020 00:17:25 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 694EAC0613D6;
        Tue, 10 Nov 2020 21:17:25 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id f23so1062783ejk.2;
        Tue, 10 Nov 2020 21:17:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bRguf6TvAdqJw4tafj5Tqzo7iTwP1/S9FOUF+U+w1Y0=;
        b=W8gZ4EV5080LyPpXExMgGV7i2OiYTwnqZm6SqF1gd7y4cm2Pd3mOp7foFtAx200AhQ
         UFRRMaH86R/f97gS2qnLSiCt6U1q26PM5EFUYif44pK8bZE9j/S1dMcy+8p2j+gMrEbc
         o5s3wSh86X3kSO94zYHBZUHr1+VfBBN3RIKP96i9O4ts+LmUaafbofRLiNgT1memmm7C
         32OE9uDoaIYuT9y4ZDg+NAWn8JymtxYPhsFpJZdvq5E/CGrrJMYJ5oYi6rfn+4039PZX
         I6xkkQ2wT8nwx9yk53RnjCJdFxrYAZOdU+9q93VFTE3+mJDfBzGGbqHkjH8AgoUhF/CP
         1mEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bRguf6TvAdqJw4tafj5Tqzo7iTwP1/S9FOUF+U+w1Y0=;
        b=Vn7E6CP2VtqOj7f4iQdLLx0Nt2MzWSiO3cuezxKYKw7HF0bX6ClVhFrg5ESv5U4oTJ
         rb/t5W/W2ekD8M5WfNHRPz5lLvr3ITjjdbtopj5yCeks3VrrDNGiTQq6FVm+NfO1GqBn
         YOUYKtReG71kJJbMYUnlbpnuQRbyjzVpDi/61e+p26jMVyS+sAaepizWJIluDCv+oinI
         26gP7qYCH29ble1g1JdC/sID9o7PhZBZgumeI9uwlnjwS5at68NZmiAbcWYil23mfuxp
         Zzh9XenC2qzTcPRf/xPZ/W0ti8h6LzgE/1vTN5XOEfGyEcn3SPk4Edtq+f0MeRRXUMEZ
         SUxQ==
X-Gm-Message-State: AOAM532yy2LkM/viCeO2BSk70Am0wUVGYZGXjZD2DNI64ET63Icz5+Nw
        F518YjJb41VExdLYrFuzmuY=
X-Google-Smtp-Source: ABdhPJzNKnei4ngb45MVs7avwQIMLPexThuFRNCxC+zXWkZXKtwdk/14D/tjNmEtUDzmjfJg/SIGcw==
X-Received: by 2002:a17:906:1c0f:: with SMTP id k15mr22773704ejg.343.1605071844219;
        Tue, 10 Nov 2020 21:17:24 -0800 (PST)
Received: from lb01399.pb.local (p200300ca573cea52c98ae5b6a31510db.dip0.t-ipconnect.de. [2003:ca:573c:ea52:c98a:e5b6:a315:10db])
        by smtp.gmail.com with ESMTPSA id g20sm363628ejz.88.2020.11.10.21.17.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2020 21:17:23 -0800 (PST)
From:   Pankaj Gupta <pankaj.gupta.linux@gmail.com>
To:     song@kernel.org
Cc:     linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        pankaj.gupta.linux@gmail.com,
        Pankaj Gupta <pankaj.gupta@cloud.ionos.com>
Subject: [PATCH 3/3] md: use current request time as base for ktime comparisons
Date:   Wed, 11 Nov 2020 06:16:58 +0100
Message-Id: <20201111051658.18904-4-pankaj.gupta.linux@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201111051658.18904-1-pankaj.gupta.linux@gmail.com>
References: <20201111051658.18904-1-pankaj.gupta.linux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Pankaj Gupta <pankaj.gupta@cloud.ionos.com>

Request coalescing logic uses 'prev_flush_start' as base to
compare the current request start time. 'prev_flush_start' is
updated in other context.

This patch changes this by using ktime comparison base to
'req_start' for better readability of code.

Signed-off-by: Pankaj Gupta <pankaj.gupta@cloud.ionos.com>
---
 drivers/md/md.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index a330e61876e0..217b1e3312cb 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -667,10 +667,10 @@ bool md_flush_request(struct mddev *mddev, struct bio *bio)
 	 */
 	wait_event_lock_irq(mddev->sb_wait,
 			    !mddev->flush_bio ||
-			    ktime_after(mddev->prev_flush_start, req_start),
+			    ktime_before(req_start, mddev->prev_flush_start),
 			    mddev->lock);
 	/* new request after previous flush is completed */
-	if (!ktime_after(mddev->prev_flush_start, req_start)) {
+	if (ktime_after(req_start, mddev->prev_flush_start)) {
 		WARN_ON(mddev->flush_bio);
 		mddev->flush_bio = bio;
 		bio = NULL;
-- 
2.20.1

