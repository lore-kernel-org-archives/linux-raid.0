Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7813C433DB
	for <linux-raid@archiver.kernel.org>; Wed, 10 Feb 2021 02:25:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A009864E53
	for <linux-raid@archiver.kernel.org>; Wed, 10 Feb 2021 02:25:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235286AbhBJCZG (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 9 Feb 2021 21:25:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235130AbhBJCWo (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 9 Feb 2021 21:22:44 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2640FC0613D6
        for <linux-raid@vger.kernel.org>; Tue,  9 Feb 2021 18:21:59 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id p20so1224567ejb.6
        for <linux-raid@vger.kernel.org>; Tue, 09 Feb 2021 18:21:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=P+Rl18f2CqIZf3xUfrJOw1gFkoUj3SzrLrpSBkHccFc=;
        b=FGz8DWPMpLpqDV8Xr6cAmBEujcXBl6NuuAXHNaIxt+h8nlpfFoilw4jEG3Vv+H6yHj
         SX0eDB3o76jRHbLbAGmb//kFvHKyxjahxlIT/zMX1ph5n+dUjQM/FBxiEXKdIbYZz1oe
         Y8Y+5n0acSpswc5Rcvn/lpZIEwghjfcW/Ubc6lbGEZ88UZKuLSjwNnSNEo4O8PZ1k0V6
         gKSr5Jmx8ogMheyhWQjhibDRvX3h5PeilUGQGOv2ZFAonjDwfo82EtgvHGMjtTxu0v6D
         D7cZ+xTQFlPAhO8Mw4eJLRRiqAVYC6DcP00BfqoQhLEKDH3WB+rbTZv1+aOF5Dzd992J
         idCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=P+Rl18f2CqIZf3xUfrJOw1gFkoUj3SzrLrpSBkHccFc=;
        b=BoK/Y8EPGtm2z9erKmosRhEX+OJw+lc4uN0bq13hLQ9SJ2op6L0MpQLKwTcxRLo8CK
         2tBA9K/iGnHLrHTL2eM/OWblDg81aqgJM0PnaHbz1+eDyaIFRJhqyh8O2Kr3+tKcYCJP
         bJoemc6A2Gu1c03XZGMyYsvsWVieNwjzAqmCttCo/ztRZgdFCfDGvqp1eEHFWYf7JtDD
         mtYO5opxZ8BiV12AwWONu0OUOBKofaM1oTcfQgqJusuJrjgNBcg/yG+CyZg+FscPUNV1
         ZFwi/0dk/x+jFcIV213G24dvf1eIWICTo9aJt6r21w5qDi4LupiTL9I7al6AFpXjD+Wh
         GYtw==
X-Gm-Message-State: AOAM530d0nfSxbNEaiKm7W6KH01H0RT/UVh/vOzPnYZPrr/g2ohsEzqc
        zmf3BErIlvim4YuDq4oRExxaZQ==
X-Google-Smtp-Source: ABdhPJzPg7tLXGzsP3p0NivEJMZdqWlU10owKCj+hY4F3YQGhlB1EoG/ZH4X3ldALBlWs/mL8wA+nQ==
X-Received: by 2002:a17:906:7cb:: with SMTP id m11mr718361ejc.332.1612923717856;
        Tue, 09 Feb 2021 18:21:57 -0800 (PST)
Received: from gqjiang-home.profitbricks.net ([240e:304:2c81:1769:6c6a:42e9:2a2c:6cd3])
        by smtp.gmail.com with ESMTPSA id l1sm263979eje.12.2021.02.09.18.21.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 09 Feb 2021 18:21:57 -0800 (PST)
From:   Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
To:     song@kernel.org
Cc:     linux-raid@vger.kernel.org,
        Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Subject: [PATCH] md: don't unregister sync_thread with reconfig_mutex held
Date:   Wed, 10 Feb 2021 03:21:16 +0100
Message-Id: <1612923676-18294-1-git-send-email-guoqing.jiang@cloud.ionos.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Unregister sync_thread doesn't need to hold reconfig_mutex since it
doesn't reconfigure array.

And it could cause deadlock problem for raid5 as follows:

1. process A tried to reap sync thread with reconfig_mutex held after echo
   idle to sync_action.
2. raid5 sync thread was blocked if there were too many active stripes.
3. SB_CHANGE_PENDING was set (because of write IO comes from upper layer)
   which causes the number of active stripes can't be decreased.
4. SB_CHANGE_PENDING can't be cleared since md_check_recovery was not able
   to hold reconfig_mutex.

More details in the link:
issu://lore.kernel.org/linux-raid/5ed54ffc-ce82-bf66-4eff-390cb23bc1ac@molgen.mpg.de/T/#t

Reported-and-tested-by: Donald Buczek <buczek@molgen.mpg.de>
Signed-off-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
---
 drivers/md/md.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index ca40942..eec8c27 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9365,13 +9365,18 @@ void md_check_recovery(struct mddev *mddev)
 EXPORT_SYMBOL(md_check_recovery);
 
 void md_reap_sync_thread(struct mddev *mddev)
+	__releases(&mddev->reconfig_mutex)
+	__acquires(&mddev->reconfig_mutex)
+
 {
 	struct md_rdev *rdev;
 	sector_t old_dev_sectors = mddev->dev_sectors;
 	bool is_reshaped = false;
 
 	/* resync has finished, collect result */
+	mddev_unlock(mddev);
 	md_unregister_thread(&mddev->sync_thread);
+	mddev_lock_nointr(mddev);
 	if (!test_bit(MD_RECOVERY_INTR, &mddev->recovery) &&
 	    !test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery) &&
 	    mddev->degraded != mddev->raid_disks) {
-- 
2.7.4

