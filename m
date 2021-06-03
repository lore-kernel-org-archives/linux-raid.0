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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1761FC47096
	for <linux-raid@archiver.kernel.org>; Thu,  3 Jun 2021 09:22:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EDE7061369
	for <linux-raid@archiver.kernel.org>; Thu,  3 Jun 2021 09:22:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229707AbhFCJYd (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 3 Jun 2021 05:24:33 -0400
Received: from mail-pf1-f182.google.com ([209.85.210.182]:33573 "EHLO
        mail-pf1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbhFCJYc (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 3 Jun 2021 05:24:32 -0400
Received: by mail-pf1-f182.google.com with SMTP id f22so4494929pfn.0
        for <linux-raid@vger.kernel.org>; Thu, 03 Jun 2021 02:22:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=E36TTso8mI9GOaZhkb+uxwzJyKdse/vPW8djM59E5OY=;
        b=eJVhcFnFlJC3wbjDDDMRteN+GP1G+7hhg/p40Kq77yOnfFCLG6YF8u8iIQ7IXwC9ox
         5a2i1szBrNbhp3Qkgzs2oFem10rjJA1cgFsotQZFt5Kki6OdsPhd+EoHxNIcJ/fIqDFy
         k9YB7WQTioUYq3MpjXhuMcLQrBhAzhulOWsV9sGjm6/CiOmPNSg7LJA6sxuYC6/yBfYX
         2hBK7OldL9SfC7xSOwk+JkKbawNyaRBRnf0S3HkV2fkMC1ma63qeejuVnk364jtYJNcQ
         b2d3sYLb3v27bMTAbTvzitUHz3FKNCjYvZu027krvLoZfv9ASKOwRa67Rp2Pd43qhAuI
         weOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=E36TTso8mI9GOaZhkb+uxwzJyKdse/vPW8djM59E5OY=;
        b=gq1OIf6Jb5fOiq7rWbq+o95Dchh/zTL+02HVaDYN5YBnLW4xKVbtDPBCFIkBQHbiJV
         AMg2Blh2UnQiUVR8zbHN7ulxLhOsquXMrtCDEdOYWOkuBT2ovYaK8YuNi4BtG2Xbbyl2
         bQgj7KjL/akcGdAsIwchLQOb8feAGI6XgAJqgKDsDiQFY2RkgnWSPC9b1faIS7lEfxC4
         TOKTs+7oXwYK+Ug6dsmH2KbqidIN5n971KHNXLzkXk/RDm+ulJuAS+frtdiTL1L5m+a8
         yfuXxm9gt2ARk6dAvc68/2FdhNBd5lhfzvkR7bFpt/qSaLMiugJDENlnPSjGbPHcAsRk
         M+Dw==
X-Gm-Message-State: AOAM531+IblG6ZftQC4ZC5/OZjaRkc05OOdrlzA7yhrU7KdTsKlQHi6z
        ExXItM+XuawOtx4wt1A4lBI=
X-Google-Smtp-Source: ABdhPJxS7vn14uy9v9zB47E0m6BlaGpo10g+MywoTg/Kv0+i7YtDjHVdJgoz+GTmSLJpkNJlaVCEdQ==
X-Received: by 2002:aa7:8b4f:0:b029:2bd:ea13:c4b4 with SMTP id i15-20020aa78b4f0000b02902bdea13c4b4mr30884333pfd.48.1622712108337;
        Thu, 03 Jun 2021 02:21:48 -0700 (PDT)
Received: from localhost.localdomain ([89.187.161.155])
        by smtp.gmail.com with ESMTPSA id c24sm1937249pfn.63.2021.06.03.02.21.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jun 2021 02:21:48 -0700 (PDT)
From:   Guoqing Jiang <jgq516@gmail.com>
X-Google-Original-From: Guoqing Jiang <jiangguoqing@kylinos.cn>
To:     song@kernel.org
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH 2/2] md: add comments in md_integrity_register
Date:   Thu,  3 Jun 2021 17:21:07 +0800
Message-Id: <20210603092107.1415706-3-jiangguoqing@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210603092107.1415706-1-jiangguoqing@kylinos.cn>
References: <20210603092107.1415706-1-jiangguoqing@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Given it is not obvious for the error handling, let's try to add some
comments here to make it clear.

Signed-off-by: Guoqing Jiang <jiangguoqing@kylinos.cn>
---
 drivers/md/md.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 56b606184c87..2c69905dd5c0 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2343,6 +2343,12 @@ int md_integrity_register(struct mddev *mddev)
 	if (bioset_integrity_create(&mddev->bio_set, BIO_POOL_SIZE) ||
 	    (mddev->level != 1 && mddev->level != 10 &&
 	     bioset_integrity_create(&mddev->io_acct_set, BIO_POOL_SIZE))) {
+		/*
+		 * No need to handle the failure of bioset_integrity_create,
+		 * because the function is called by md_run() -> pers->run(),
+		 * md_run calls bioset_exit -> bioset_integrity_free in case
+		 * of failure case.
+		 */
 		pr_err("md: failed to create integrity pool for %s\n",
 		       mdname(mddev));
 		return -EINVAL;
-- 
2.25.1

