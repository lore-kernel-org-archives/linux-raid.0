Return-Path: <SRS0=7RKO=EL=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 327E9C4741F
	for <linux-raid@archiver.kernel.org>; Thu,  5 Nov 2020 18:08:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B7ED420709
	for <linux-raid@archiver.kernel.org>; Thu,  5 Nov 2020 18:08:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MCVx0bZp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727851AbgKESIJ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 5 Nov 2020 13:08:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725862AbgKESII (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 5 Nov 2020 13:08:08 -0500
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43EE1C0613CF
        for <linux-raid@vger.kernel.org>; Thu,  5 Nov 2020 10:08:07 -0800 (PST)
Received: by mail-pj1-x1044.google.com with SMTP id w7so472371pjy.1
        for <linux-raid@vger.kernel.org>; Thu, 05 Nov 2020 10:08:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=u1qY+4ADGmO3FXtfgKtBLuD/hMettBhnyT5e01W+V2w=;
        b=MCVx0bZp6NPEgbSZ5pJHDjf+8eOQHNgHazdy1CMDW1bQHxJSiAI+BKn0+6Wnfiya4V
         zybRIYod/CIXhT9jua2KEEUUXzZVXJi7TY2Forjnhk+EwipT88LHAPSfTBWlv1Rx3RzS
         wrliMe6p46Xa03uGOeMIhCWJxFgGzq2pvVWI5XcykCopxrMuenmgAp5GVZlksXpvZ590
         H5BIEpsnWr9CcIDUlPHqoM8KQ+Q+R1bkpHrJcspe6rsbb10pB2G585MGQ+CTZ96ry4HC
         g9/XgyZzKCgJ81nGTPMONLpbitG4wUfO5ufMrBHr53x7Lwq5IBkG8NGzHihARszCUETP
         LH3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=u1qY+4ADGmO3FXtfgKtBLuD/hMettBhnyT5e01W+V2w=;
        b=Bok6CQJJivB3Lxheljh+e+vRRhdGwmAO3j8uHZSR282eZZWv22J3BeQ7ScCYJ+jObZ
         4ApwURtUoh2XJdUNQLryhCJUNQHoCK5Ma1X8K0w4PbxYTwR+1qRr5nvNXxG2c1P63aaQ
         OZ4yisLGJ/oe+rOo0bjGPXvzEDADpwb3d9txxwN9IHGUGAYvTBDbkDFL2f3h2S+yY1J3
         601R9MHt8shwFme+ftqnWmGSPyRWYvTZjot5AGWliO18PrvlQSM6h42PtLYp9DcDsya2
         iBZdfP8Mm5/Kt2zrB4J76UJBEp6DdZ5inD2hLM6odakHTSmJheqSpjx/tZq1X9KbK4fX
         Ft7w==
X-Gm-Message-State: AOAM532cEq+3lFdazjPZi6qZDXQNX5shA7UpKf8A12WEhLPneO5EPvuF
        MKrvcQXvSHLkWui3GL8XKoQ=
X-Google-Smtp-Source: ABdhPJynOLEx1B+IRkn/znqzkWej8avTkuEpXfRuW0x6zDMYUZukGwxDJWTBbL86E85OWnppxxh9tg==
X-Received: by 2002:a17:902:ed01:b029:d6:bb79:d46a with SMTP id b1-20020a170902ed01b02900d6bb79d46amr3537670pld.76.1604599686779;
        Thu, 05 Nov 2020 10:08:06 -0800 (PST)
Received: from kvigor-fedora-R90RRLH2.thefacebook.com ([2620:10d:c090:400::5:b0c2])
        by smtp.gmail.com with ESMTPSA id a8sm2885789pgt.1.2020.11.05.10.08.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2020 10:08:05 -0800 (PST)
From:   Kevin Vigor <kvigor@gmail.com>
To:     song@kernel.org, linux-raid@vger.kernel.org
Cc:     Kevin Vigor <kvigor@gmail.com>
Subject: [PATCH] md/raid10: initialize r10_bio->read_slot before use.
Date:   Thu,  5 Nov 2020 10:07:46 -0800
Message-Id: <20201105180746.1149364-1-kvigor@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

In __make_request() a new r10bio is allocated and passed to
raid10_read_request(). The read_slot member of the bio is not
initialized, and the raid10_read_request() uses it to index an
array. This leads to occasional panics.

Fix by initializing the field to invalid value and checking for
valid value in raid10_read_request().

Signed-off-by: Kevin Vigor <kvigor@gmail.com>
---
 drivers/md/raid10.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 8a1354a08a1a..64b1306b0c4a 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1143,7 +1143,7 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
 	struct md_rdev *err_rdev = NULL;
 	gfp_t gfp = GFP_NOIO;
 
-	if (r10_bio->devs[slot].rdev) {
+	if (slot >= 0 && r10_bio->devs[slot].rdev) {
 		/*
 		 * This is an error retry, but we cannot
 		 * safely dereference the rdev in the r10_bio,
@@ -1508,6 +1508,7 @@ static void __make_request(struct mddev *mddev, struct bio *bio, int sectors)
 	r10_bio->mddev = mddev;
 	r10_bio->sector = bio->bi_iter.bi_sector;
 	r10_bio->state = 0;
+	r10_bio->read_slot = -1;
 	memset(r10_bio->devs, 0, sizeof(r10_bio->devs[0]) * conf->copies);
 
 	if (bio_data_dir(bio) == READ)
-- 
2.26.2

