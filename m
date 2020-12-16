Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED033C4361B
	for <linux-raid@archiver.kernel.org>; Wed, 16 Dec 2020 01:27:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A27CF22DCC
	for <linux-raid@archiver.kernel.org>; Wed, 16 Dec 2020 01:27:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725765AbgLPB1h (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 15 Dec 2020 20:27:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725320AbgLPB1c (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 15 Dec 2020 20:27:32 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45FE9C0613D6
        for <linux-raid@vger.kernel.org>; Tue, 15 Dec 2020 17:26:52 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id x16so30421982ejj.7
        for <linux-raid@vger.kernel.org>; Tue, 15 Dec 2020 17:26:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=0YeQol4UUnc2r7M4Orydwby2O2PPAZtNd+0yMn15aPo=;
        b=fuFyS+HwIc8oAZ4P+X1VH1d/KZ+OzSRgIiRdGi4PpptIRxPQ/yzpP4Av2x8ISh6f/S
         LiXg7oaYiFXqcGDH+2TYyZ6BNJnqKCLH/jMp/0C32HCgIYETMjg5SQNCsHRA1ouYrCoY
         jMLxA4+M2A2vQE4NgTnBCjF5ds+F1HXM1pGz+QqCg24Vw8ZotTJSP07+PK2VdVWM7xkq
         HZNmWlWdNyOkY7utGAjPD06z/Pi5gJB48f/D9PDh6ZESN+H4LL6zv92D4uN90HyhCm/k
         i+ZNjrwK46xFd9HsgmeZYqedE/MkHmjUgbWKuN4FlFzMAQkCBfpMgZKc6KYBxA4LNw0y
         H0RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=0YeQol4UUnc2r7M4Orydwby2O2PPAZtNd+0yMn15aPo=;
        b=V1ujBkFZYM6AFl8exUpJ9bdj5tn8v4oubr759uvX886quehUTihg20h6zUCr2GwWv3
         Kx8pxcfjg42dZCvwdhJOZwU1f8QatKbMUq09KJI8DT7dcbWR1MeLNWJ3rb1P2ogkB6RJ
         03ZlvKVbgnDz98c0w0xIS37lkVHf0OWDGQ1IIZEbJoPv/L9VY7dApMKuvlJCWJvdhiIj
         1qiJf1GKC3ZRFf/qMrkNSgWYfdq8iNmjnqRFK3coD3EeE0vzrqaUMLbCOEibA+0xT5WN
         Xcel7FWP7dEvSj7p1l8maN9tsXBU78RMsEb6JsSdK+bS34mEfuIX9EA2eh9VJMgKnBKr
         3Y7A==
X-Gm-Message-State: AOAM531IfQrhkxBAKB9Xz4tYSS00+dLfhRmBhA5wom7jOkRbGxxaS8vj
        avW7xYV9GKxXeB1HMCeYlegCp65sedG94Dfmwdc=
X-Google-Smtp-Source: ABdhPJzgGDUdWAbxjoRCeYpd/Quvy77q/RJ92BB3ppRb+RnxmOeE6BjgT+RnT+oWDgqVCPCzURwRGA==
X-Received: by 2002:a17:906:6d0b:: with SMTP id m11mr28364300ejr.230.1608082010790;
        Tue, 15 Dec 2020 17:26:50 -0800 (PST)
Received: from gqjiang-home.profitbricks.net ([240e:304:2c80:539:f508:1adf:4d34:f89c])
        by smtp.gmail.com with ESMTPSA id m24sm195379ejo.52.2020.12.15.17.26.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 15 Dec 2020 17:26:50 -0800 (PST)
From:   Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
To:     linux-raid@vger.kernel.org
Cc:     song@kernel.org, Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Subject: [PATCH] md/raid5: cast chunk_sectors to sector_t value
Date:   Wed, 16 Dec 2020 02:26:22 +0100
Message-Id: <1608081982-10839-1-git-send-email-guoqing.jiang@cloud.ionos.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Currently, raid5 calculates dev_sectors from chunk_sectors without
proper cast, which is problematic.

Signed-off-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
---
I think the recently report about raid5 issue could be related with
the setting of dev_sectors.

Could someone test it with a large raid5 array? Thanks.

 drivers/md/raid5.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 3934347..ca0b29a 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7662,7 +7662,7 @@ static int raid5_run(struct mddev *mddev)
 	}
 
 	/* device size must be a multiple of chunk size */
-	mddev->dev_sectors &= ~(mddev->chunk_sectors - 1);
+	mddev->dev_sectors &= ~((sector_t)mddev->chunk_sectors - 1);
 	mddev->resync_max_sectors = mddev->dev_sectors;
 
 	if (mddev->degraded > dirty_parity_disks &&
-- 
2.7.4

