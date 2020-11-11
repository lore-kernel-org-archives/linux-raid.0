Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C81EC388F9
	for <linux-raid@archiver.kernel.org>; Wed, 11 Nov 2020 05:17:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CCD1E20709
	for <linux-raid@archiver.kernel.org>; Wed, 11 Nov 2020 05:17:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="buzQAx13"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726102AbgKKFR0 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 11 Nov 2020 00:17:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726055AbgKKFRY (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 11 Nov 2020 00:17:24 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C474C0613D4;
        Tue, 10 Nov 2020 21:17:24 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id f20so1040748ejz.4;
        Tue, 10 Nov 2020 21:17:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=W4oa2arKXpCRAolq9D2lGXxHhmUs0bsO+JdBDi0oVas=;
        b=buzQAx13RV4ZvT8vzuWft03dlaFWsa3Rd6LiKF6cHOoQPS6NWgOngBONvdZ4d0eLUV
         hC/xKc9rpZG0TEu/NuB1zbkYQSvjM6bzXbM2l6yjocs2GJd6zn4H1fRLKlwUoJtPk5QC
         dG+1Wu/3wmVfqg1WwtUdq3bSnloCZWlH81U1dcZdWCGvitQkND6TjQVe8i6nplTHNobO
         4E4IxyyvckskewIatN0QJhPjOa5DTJOoaJRylSXtiKYUbk6cGb/2HSKbmXlXnI8KJ+EO
         Y8Mk3PAMLdk4KpbXISgtsYlsJlntbVelXJQ2r7alnLeZNIzFotwkvOuD77nnf1yuS4hK
         teFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=W4oa2arKXpCRAolq9D2lGXxHhmUs0bsO+JdBDi0oVas=;
        b=fgR3N862VDyWUTfXI/DQ8fEd8x4iNSLP50SjGetjFcVvLANKHBEU9xiULRveUT67n9
         Ec5ZFyo5DYCzRT9LWu8sBNUKqrH0DIe9vPh1MqcJlzCx/GnWbZZ/+jZbB24uAWDBGUDT
         zxp/nskQlEbSndo0zQS59P4iJlhmprfzChWQeDsNJ9KyCPK0fsNCLy2ioNkB+aklrsdD
         zSJZ96Zawm0mNdRITufc8SOLRd4krKPiauFnqRX9JKw9IOflNkjb0u+I0kt4fTs84Fdi
         rnc58TLvxSHQz20NoC94HlpbuoUYDt+xlZ0zKrTf9QR8vVrfJEDGHOv1uCa/1TC8jyU4
         99AA==
X-Gm-Message-State: AOAM532wiNPpAyCRBmbkp0Yxe0sLed9PJZfZCRHwvpiUYW4cVcPjIWMo
        wyagJj2OwzzEzY3Xp7A0mOMFodPFzhE=
X-Google-Smtp-Source: ABdhPJxXNQihstkl7oxxs8OthEimIkqJbVWvYENvEA1AiBAtUJ+7d/QbEngohM8pmnQbv0gIP40ocQ==
X-Received: by 2002:a17:906:6d83:: with SMTP id h3mr22986842ejt.481.1605071843221;
        Tue, 10 Nov 2020 21:17:23 -0800 (PST)
Received: from lb01399.pb.local (p200300ca573cea52c98ae5b6a31510db.dip0.t-ipconnect.de. [2003:ca:573c:ea52:c98a:e5b6:a315:10db])
        by smtp.gmail.com with ESMTPSA id g20sm363628ejz.88.2020.11.10.21.17.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2020 21:17:22 -0800 (PST)
From:   Pankaj Gupta <pankaj.gupta.linux@gmail.com>
To:     song@kernel.org
Cc:     linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        pankaj.gupta.linux@gmail.com,
        Pankaj Gupta <pankaj.gupta@cloud.ionos.com>
Subject: [PATCH 2/3] md: add comments in md_flush_request()
Date:   Wed, 11 Nov 2020 06:16:57 +0100
Message-Id: <20201111051658.18904-3-pankaj.gupta.linux@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201111051658.18904-1-pankaj.gupta.linux@gmail.com>
References: <20201111051658.18904-1-pankaj.gupta.linux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Pankaj Gupta <pankaj.gupta@cloud.ionos.com>

 Request coalescing logic is dependent on flush time
 update in other context. This patch adds comments
 to understand the code flow better.

Signed-off-by: Pankaj Gupta <pankaj.gupta@cloud.ionos.com>
---
 drivers/md/md.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 167c80f98533..a330e61876e0 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -662,10 +662,14 @@ bool md_flush_request(struct mddev *mddev, struct bio *bio)
 {
 	ktime_t req_start = ktime_get_boottime();
 	spin_lock_irq(&mddev->lock);
+	/* flush requests wait until ongoing flush completes,
+	 * hence coalescing all the pending requests.
+	 */
 	wait_event_lock_irq(mddev->sb_wait,
 			    !mddev->flush_bio ||
 			    ktime_after(mddev->prev_flush_start, req_start),
 			    mddev->lock);
+	/* new request after previous flush is completed */
 	if (!ktime_after(mddev->prev_flush_start, req_start)) {
 		WARN_ON(mddev->flush_bio);
 		mddev->flush_bio = bio;
-- 
2.20.1

