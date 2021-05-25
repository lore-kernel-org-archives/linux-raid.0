Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F108DC47086
	for <linux-raid@archiver.kernel.org>; Tue, 25 May 2021 09:47:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CCE606100B
	for <linux-raid@archiver.kernel.org>; Tue, 25 May 2021 09:47:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232732AbhEYJsl (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 25 May 2021 05:48:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232733AbhEYJsk (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 25 May 2021 05:48:40 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1461FC06138E
        for <linux-raid@vger.kernel.org>; Tue, 25 May 2021 02:47:08 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id x18so18876731pfi.9
        for <linux-raid@vger.kernel.org>; Tue, 25 May 2021 02:47:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FAACiYDE4vgtEht2NO8bSfTLuv4QC75m1wMXhVXHsfE=;
        b=AMsGhFTC10+33GxqGktxuFN3fW4Ue4vpurxVRC8reaU/52vH7lFFf5XvSgSZteUNEt
         WMxgmeM/S9QgB/PifAAaebBPkN57cs1D1I57SL54YYBrPhYZF21MlveMt+jwkViIu4CF
         qXrt1aG6dGPOyP7XKxG3UzhucHUqiTACk/vhhAS7Lc2HMBqK0j6aSdL+I0Zjtd13tYmq
         yLGPQHMOUX0RgPEycrX3eNDk3h+q7L44tN4FqkNZ6z4lfJ/HPgysP2nfjGBdAE/H7L8U
         2DvmzGlQYV0yQstR2LXr2/Lz3hPh1MCH7epthXzOh9khhwFE6l4OQ6H/0e8FC/9vl7rv
         Co1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FAACiYDE4vgtEht2NO8bSfTLuv4QC75m1wMXhVXHsfE=;
        b=bAvMsVsXMo66vk6SgIN4t4pbYwBjy59eI4qroNV8UdNUDW1xTJcCmgkVJz/lwTQ8Jw
         vRwd8CLWcQ8iMKqsKGJ2ecZdzOGp4R5oWN/hKWbfIyLJX+BeDD/4kIqF5IFxsDrC28ox
         QQoaBDAKOhGWfHOq33jNXT033T/euDxznL/Zls+A1EfLYjwsYKp/aGM8AfkT+bgxSoTK
         yJ5pK+lvP8k8FNxOxndrvEElLczuGJMf+biLJwmzIa7HGxKX49Kmfakf/V8o9KHxtJmW
         xmEx43L2hO0lVXgqQ5nMSDEUrR/jQpyzfXKgGrTVu5UmfEDHfqANYaQsD3op2K6UFWwF
         nlKQ==
X-Gm-Message-State: AOAM533jAYoq4tymKvcPRW/Vc0ahEuTzKcFl+55joJTQViU8kmjUp3Bl
        1Ux0ThVhgWXpbhanvHPV5t4=
X-Google-Smtp-Source: ABdhPJz/UGuVNrVzxlrXjXh7eyvOExt+MhZ0HqNJueN8CjDUZMa0rdYjworqGc2jDmj+8RMkDzlCtw==
X-Received: by 2002:aa7:9f8f:0:b029:2dc:76bc:edce with SMTP id z15-20020aa79f8f0000b02902dc76bcedcemr29254986pfr.29.1621936027694;
        Tue, 25 May 2021 02:47:07 -0700 (PDT)
Received: from localhost.localdomain ([89.187.161.155])
        by smtp.gmail.com with ESMTPSA id r10sm13114437pfl.159.2021.05.25.02.47.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 May 2021 02:47:07 -0700 (PDT)
From:   Guoqing Jiang <jgq516@gmail.com>
X-Google-Original-From: Guoqing Jiang <jiangguoqing@kylinos.cn>
To:     song@kernel.org
Cc:     linux-raid@vger.kernel.org, artur.paszkiewicz@intel.com,
        hch@infradead.org
Subject: [PATCH V3 5/8] md/raid1: rename print_msg with r1bio_existed
Date:   Tue, 25 May 2021 17:46:20 +0800
Message-Id: <20210525094623.763195-6-jiangguoqing@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210525094623.763195-1-jiangguoqing@kylinos.cn>
References: <20210525094623.763195-1-jiangguoqing@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

The caller of raid1_read_request could pass NULL or a valid pointer for
"struct r1bio *r1_bio", so it actually means whether r1_bio is existed
or not.

Signed-off-by: Guoqing Jiang <jiangguoqing@kylinos.cn>
---
 drivers/md/raid1.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index ced076ba560e..696da6b8b7ed 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1210,7 +1210,7 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
 	const unsigned long do_sync = (bio->bi_opf & REQ_SYNC);
 	int max_sectors;
 	int rdisk;
-	bool print_msg = !!r1_bio;
+	bool r1bio_existed = !!r1_bio;
 	char b[BDEVNAME_SIZE];
 
 	/*
@@ -1220,7 +1220,7 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
 	 */
 	gfp_t gfp = r1_bio ? (GFP_NOIO | __GFP_HIGH) : GFP_NOIO;
 
-	if (print_msg) {
+	if (r1bio_existed) {
 		/* Need to get the block device name carefully */
 		struct md_rdev *rdev;
 		rcu_read_lock();
@@ -1252,7 +1252,7 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
 
 	if (rdisk < 0) {
 		/* couldn't find anywhere to read from */
-		if (print_msg) {
+		if (r1bio_existed) {
 			pr_crit_ratelimited("md/raid1:%s: %s: unrecoverable I/O read error for block %llu\n",
 					    mdname(mddev),
 					    b,
@@ -1263,7 +1263,7 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
 	}
 	mirror = conf->mirrors + rdisk;
 
-	if (print_msg)
+	if (r1bio_existed)
 		pr_info_ratelimited("md/raid1:%s: redirecting sector %llu to other mirror: %s\n",
 				    mdname(mddev),
 				    (unsigned long long)r1_bio->sector,
-- 
2.25.1

