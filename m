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
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0002C433B4
	for <linux-raid@archiver.kernel.org>; Fri, 21 May 2021 00:56:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF678600CD
	for <linux-raid@archiver.kernel.org>; Fri, 21 May 2021 00:56:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235632AbhEUA6C (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 20 May 2021 20:58:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235619AbhEUA6B (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 20 May 2021 20:58:01 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E0BAC061574
        for <linux-raid@vger.kernel.org>; Thu, 20 May 2021 17:56:39 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id n8so4849100plf.7
        for <linux-raid@vger.kernel.org>; Thu, 20 May 2021 17:56:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FAACiYDE4vgtEht2NO8bSfTLuv4QC75m1wMXhVXHsfE=;
        b=av4gXK+b0Qn7wS5IAGzXNf45gDIJJcf4XTwbC/Q9saR7KZD9q1/TqqspkHEmrV+BmW
         Osgbrg7An/eeGSUiw8wPBptUqONZEeJ4qeX49YCmzGG4HQ3PS0pM6pnj/6Y7o8csFaig
         ecBLD3n6fdLhO2Jx3QhMsvWDVsSll7gyq7FncAzp8Pdqbjb6G4yYk7NZP8tPgotDG4zz
         zgfNXShPxe+6X4is7JH9X50prJVXeHiF0rZDu7/mKUT6RdTzFG27MCQlm6H5i/v0p+hy
         sT7XegGj8nXQp4chSfeC6StdoWznB0eHsNS7Itx54DPd41NQXY22tXPBBhagPhOlP0Zr
         +GuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FAACiYDE4vgtEht2NO8bSfTLuv4QC75m1wMXhVXHsfE=;
        b=A0UopdafdLb6ZsWPnEzg1yeJd+kGHIYUJCQAxsDe1JHVYYe4usPZsC2Yk4StYh0hlu
         psNlJhEXBpV1R2rr0NNlCSfylE/dUorGKxe7xzdeRTtuM57F5kSAQ0X5kVmRbes4HLvS
         GK/ZLdaBppAsNp+EyRBfXUfopgp6vZsqo6LfMlitfYvZ6zWlT7tRgIi1AzFuFdn5y9VU
         5nK/WWRpKU5pjvZl8wiNg3S7noejS0XPBvb/ycZFCS7BRHYyowNh0cHtzzhfUqDKThxf
         4YaIz8kofO4xdR6bNy20+kpch1B+2jZkdWffG+KXVBTyf6n9laPdZdu4tTdJFA/NEDTh
         IXxA==
X-Gm-Message-State: AOAM5335E0cN+1LUVODBBf7iy4H11ARBsh07qB4s5WT4dCcBqMpCmlzB
        vTzLzBjZPZGNqdVlytO6ah8=
X-Google-Smtp-Source: ABdhPJyrNSIpr93Uiz/eGhNNalKNa4/Yba354EvoaFwkLPYdNOr4c0nrdWbcTlv6nRN3OtMoiFWhtQ==
X-Received: by 2002:a17:90b:4a12:: with SMTP id kk18mr7699077pjb.99.1621558599128;
        Thu, 20 May 2021 17:56:39 -0700 (PDT)
Received: from localhost.localdomain ([89.187.161.155])
        by smtp.gmail.com with ESMTPSA id 5sm7405945pjo.17.2021.05.20.17.56.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 May 2021 17:56:38 -0700 (PDT)
From:   Guoqing Jiang <jgq516@gmail.com>
X-Google-Original-From: Guoqing Jiang <jiangguoqing@kylinos.cn>
To:     song@kernel.org
Cc:     linux-raid@vger.kernel.org, artur.paszkiewicz@intel.com
Subject: [PATCH V2 4/7] md/raid1: rename print_msg with r1bio_existed
Date:   Fri, 21 May 2021 08:55:18 +0800
Message-Id: <20210521005521.713106-5-jiangguoqing@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210521005521.713106-1-jiangguoqing@kylinos.cn>
References: <20210521005521.713106-1-jiangguoqing@kylinos.cn>
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

