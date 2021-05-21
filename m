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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E5BCC43460
	for <linux-raid@archiver.kernel.org>; Fri, 21 May 2021 00:56:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 394ED60231
	for <linux-raid@archiver.kernel.org>; Fri, 21 May 2021 00:56:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235613AbhEUA5x (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 20 May 2021 20:57:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235593AbhEUA5x (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 20 May 2021 20:57:53 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9195DC061574
        for <linux-raid@vger.kernel.org>; Thu, 20 May 2021 17:56:31 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id j6-20020a17090adc86b02900cbfe6f2c96so6245592pjv.1
        for <linux-raid@vger.kernel.org>; Thu, 20 May 2021 17:56:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wWx9geOP/CGt+3lBwelnd/E0JX29E4W7KKWUDuyZoQ4=;
        b=TrGnJrsFs0PYDg+eN0HuaPPkFFXmmXnulug/yTxuCc5X9PAYIksAEgroRWwt3stvaf
         IrhVs+SGpUJwwB6zslBRBc3cjpb03sqJl3VUCn68KjEwBXBtAdbiLcssxyGbjdar1w7z
         /rw1di4sjW40j6QGj232MdEYxpx1pgGWjP32BSN+uVX6Fqv4ppqNLbG5U20+pZoULGsI
         R5l9RC51BOKpZrt7z7WioLb/c5Yz1ewUiT3R1AlCceuXkERNIPwdDhzavw70O3AmcBUV
         EiDU7BV9+kJPMZX5BK6An/0nBy3Vtlg7dLQCiau4XJXZ+MBXJeCNfeqlrZqJrjs0NADX
         pV/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wWx9geOP/CGt+3lBwelnd/E0JX29E4W7KKWUDuyZoQ4=;
        b=qU3HU51NBbBichPULiyerJqt+S+IjHw2gHP64XBo8hIf3YkgqyQ5Kwk6B65B5AafvR
         9ZKnEl+vsqmzJRG6ETCNSTqB/uzA6DFnUCetD3+7JSG7aXv0bbqU4wRxTC/8Xd77xOJt
         wyc6scCWH0skkFcRaikxhX9+a+y3jL2yln28/SbxSEb1RIkhAosHc5KKTwVN1z8LLp6O
         IAzmKZvkhynoTls+U0/ssEzKg4YBPrPglOIKBWPaTrGLCpSKrS0hKghnCiVoXb8xQXpt
         ODc9SUf3gdeX5NT8i2uubf0FfGLZNlscXwWF15Q1ljK2ZPQYBD73uRaK4l+5H4bt86Ic
         Qp+Q==
X-Gm-Message-State: AOAM533pxLyjclBJtPeGUXW5UUmYvmmSzHA/4tf8i61y9R8e0wQ2VgaZ
        wMF498IpGwr5YhiU42ZahQI=
X-Google-Smtp-Source: ABdhPJwI5VpdxI0Vn1Rayq7zX5LsUeNrn/Qv+UwQiz1AZwbPrvBEuJq037dIvJAf7dFVHy3BoD9pTw==
X-Received: by 2002:a17:902:dac6:b029:f3:16f3:d90d with SMTP id q6-20020a170902dac6b02900f316f3d90dmr9203148plx.42.1621558591174;
        Thu, 20 May 2021 17:56:31 -0700 (PDT)
Received: from localhost.localdomain ([89.187.161.155])
        by smtp.gmail.com with ESMTPSA id 5sm7405945pjo.17.2021.05.20.17.56.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 May 2021 17:56:30 -0700 (PDT)
From:   Guoqing Jiang <jgq516@gmail.com>
X-Google-Original-From: Guoqing Jiang <jiangguoqing@kylinos.cn>
To:     song@kernel.org
Cc:     linux-raid@vger.kernel.org, artur.paszkiewicz@intel.com
Subject: [PATCH V2 2/7] md: add accounting_bio for raid0 and raid5
Date:   Fri, 21 May 2021 08:55:16 +0800
Message-Id: <20210521005521.713106-3-jiangguoqing@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210521005521.713106-1-jiangguoqing@kylinos.cn>
References: <20210521005521.713106-1-jiangguoqing@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Let's introduce accounting_bio which checks if md needs clone the bio
for accounting.

And add relevant function to raid0 and raid5 given both don't have
their own clone infrastrure, also checks if it is split bio.

Signed-off-by: Guoqing Jiang <jiangguoqing@kylinos.cn>
---
 drivers/md/md.h    |  2 ++
 drivers/md/raid0.c | 14 ++++++++++++++
 drivers/md/raid5.c | 17 +++++++++++++++++
 3 files changed, 33 insertions(+)

diff --git a/drivers/md/md.h b/drivers/md/md.h
index 4da240ffe2c5..5125ccf9df06 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -605,6 +605,8 @@ struct md_personality
 	void *(*takeover) (struct mddev *mddev);
 	/* Changes the consistency policy of an active array. */
 	int (*change_consistency_policy)(struct mddev *mddev, const char *buf);
+	/* check if need to clone bio for accounting in md layer */
+	bool (*accounting_bio)(struct mddev *mddev, struct bio *bio);
 };
 
 struct md_sysfs_entry {
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index e5d7411cba9b..d309b639b5d9 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -748,6 +748,19 @@ static void raid0_quiesce(struct mddev *mddev, int quiesce)
 {
 }
 
+/*
+ * Don't account the bio if it was split from mddev->bio_set.
+ */
+static bool raid0_accounting_bio(struct mddev *mddev, struct bio *bio)
+{
+	bool ret = true;
+
+	if (bio->bi_pool == &mddev->bio_set)
+		ret = false;
+
+	return ret;
+}
+
 static struct md_personality raid0_personality=
 {
 	.name		= "raid0",
@@ -760,6 +773,7 @@ static struct md_personality raid0_personality=
 	.size		= raid0_size,
 	.takeover	= raid0_takeover,
 	.quiesce	= raid0_quiesce,
+	.accounting_bio = raid0_accounting_bio,
 };
 
 static int __init raid0_init (void)
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 841e1c1aa5e6..bcc1ceb69c73 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -8596,6 +8596,20 @@ static void *raid6_takeover(struct mddev *mddev)
 	return setup_conf(mddev);
 }
 
+/*
+ * Don't account the bio if it was split from r5conf->bio_split.
+ */
+static bool raid5_accounting_bio(struct mddev *mddev, struct bio *bio)
+{
+	bool ret = true;
+	struct r5conf *conf = mddev->private;
+
+	if (bio->bi_pool == &conf->bio_split)
+		ret = false;
+
+	return ret;
+}
+
 static int raid5_change_consistency_policy(struct mddev *mddev, const char *buf)
 {
 	struct r5conf *conf;
@@ -8688,6 +8702,7 @@ static struct md_personality raid6_personality =
 	.quiesce	= raid5_quiesce,
 	.takeover	= raid6_takeover,
 	.change_consistency_policy = raid5_change_consistency_policy,
+	.accounting_bio	= raid5_accounting_bio,
 };
 static struct md_personality raid5_personality =
 {
@@ -8712,6 +8727,7 @@ static struct md_personality raid5_personality =
 	.quiesce	= raid5_quiesce,
 	.takeover	= raid5_takeover,
 	.change_consistency_policy = raid5_change_consistency_policy,
+	.accounting_bio	= raid5_accounting_bio,
 };
 
 static struct md_personality raid4_personality =
@@ -8737,6 +8753,7 @@ static struct md_personality raid4_personality =
 	.quiesce	= raid5_quiesce,
 	.takeover	= raid4_takeover,
 	.change_consistency_policy = raid5_change_consistency_policy,
+	.accounting_bio	= raid5_accounting_bio,
 };
 
 static int __init raid5_init(void)
-- 
2.25.1

