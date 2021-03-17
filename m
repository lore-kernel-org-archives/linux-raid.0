Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 958E7C433DB
	for <linux-raid@archiver.kernel.org>; Wed, 17 Mar 2021 14:06:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3EDE864F67
	for <linux-raid@archiver.kernel.org>; Wed, 17 Mar 2021 14:06:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231615AbhCQOFg (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 17 Mar 2021 10:05:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231644AbhCQOFN (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 17 Mar 2021 10:05:13 -0400
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2141C06175F
        for <linux-raid@vger.kernel.org>; Wed, 17 Mar 2021 07:05:12 -0700 (PDT)
Received: by mail-qv1-xf36.google.com with SMTP id o19so1447364qvu.0
        for <linux-raid@vger.kernel.org>; Wed, 17 Mar 2021 07:05:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=PWoltp9WmwyO3d7XhliVywf9i2GXKDnsLpbRrO2NbGI=;
        b=WsRpNG8sX0PGjK+pfA+SQ3Bb3jhflsFaBhjj63LbczCkJ+7RcnSs60BJC1XVRTzffh
         ROYiVgrbr2NmfFs/FGJdGvIW460RaXjSJ7qb5vOugINIc9EiS1DXbtJFe0WYDSAPHGlA
         HQ4SiZdhN07sZRsTsJtQi+VtW6bA1Cr6v/QjY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=PWoltp9WmwyO3d7XhliVywf9i2GXKDnsLpbRrO2NbGI=;
        b=OHXGhllJ3spu+7RFMt70i5F3uaxSQ/b0QBFKbucQgXXxZQrjRw1qYt0XehbRjxpNk7
         Tl7zgEc5wqj6p+f/MNl1EGt8Z2GS5rznsJS/THsNWiV3u6b1pPloedekMrfix4Re1WOV
         AxMBolUdgczj95IITRlKSnuA/b11AsZ0yzyGMnORKTrwrVdRI5md9goaMoOr5+nxrmgD
         xRerdbSgHw6jXNqr48/SCjrOlmgIzagMjUw/LKV/zGJiAK2lU72taAk28Bn00BGSjwMZ
         NHCRre7RpaB1h4ycZfeq0d9NJD+z787hQIKCuNX32ilT7C0ukRxxup7gvfd1/ZxDKMTn
         E3GA==
X-Gm-Message-State: AOAM531H81sUXdzre4IRkmRiqqFtAWi6bWgEsszCqNX0hiCpeB/IXUAP
        XbZODPQTcBaVyt6aW4+Ix+Kkfp1etizO8onbLZc=
X-Google-Smtp-Source: ABdhPJyuvoed78WS6+HdEBNB7QZ/3oGdsTqI0V2wAYQM4QWLyFqID+v4ui/DHHggT9LydDHCzeR7Ng==
X-Received: by 2002:a0c:a909:: with SMTP id y9mr5600566qva.20.1615989911862;
        Wed, 17 Mar 2021 07:05:11 -0700 (PDT)
Received: from tuna.fritz.box ([2a02:8070:87b9:f700:d43d:6bf:d9e5:58a3])
        by smtp.gmail.com with ESMTPSA id e3sm17864791qkn.39.2021.03.17.07.05.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 07:05:11 -0700 (PDT)
From:   Jan Glauber <jglauber@digitalocean.com>
To:     linux-raid@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Song Liu <song@kernel.org>,
        Jan Glauber <jglauber@digitalocean.com>
Subject: [PATCH] md: Fix missing unused status line of /proc/mdstat
Date:   Wed, 17 Mar 2021 15:04:39 +0100
Message-Id: <20210317140439.9499-1-jglauber@digitalocean.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Reading /proc/mdstat with a read buffer size that would not
fit the unused status line in the first read will skip this
line from the output.

So 'dd if=/proc/mdstat bs=64 2>/dev/null' will not print something
like: unused devices: <none>

Don't return NULL immediately in start() for v=2 but call
show() once to print the status line also for multiple reads.

Fixes: 1f4aace60b0e ("fs/seq_file.c: simplify seq_file iteration code and interface")
Signed-off-by: Jan Glauber <jglauber@digitalocean.com>
---
 drivers/md/md.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 21da0c48f6c2..cb19d50fa672 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8153,7 +8153,11 @@ static void *md_seq_start(struct seq_file *seq, loff_t *pos)
 	loff_t l = *pos;
 	struct mddev *mddev;
 
-	if (l >= 0x10000)
+	if (l == 0x10000) {
+		++*pos;
+		return (void *)2;
+	}
+	if (l > 0x10000)
 		return NULL;
 	if (!l--)
 		/* header */
-- 
2.17.1

