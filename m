Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E635C433EF
	for <linux-raid@archiver.kernel.org>; Mon, 13 Sep 2021 03:22:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A804600D4
	for <linux-raid@archiver.kernel.org>; Mon, 13 Sep 2021 03:22:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238419AbhIMDXS (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 12 Sep 2021 23:23:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238421AbhIMDXQ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 12 Sep 2021 23:23:16 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F262C061574
        for <linux-raid@vger.kernel.org>; Sun, 12 Sep 2021 20:22:01 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id u13-20020a17090abb0db0290177e1d9b3f7so5569034pjr.1
        for <linux-raid@vger.kernel.org>; Sun, 12 Sep 2021 20:22:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smartx-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NJfd+Dl6LyVyy7WHaPVunJ2WQBOC5w96NLDZ1F2YTMU=;
        b=KmkXDaGXiNAV5S+8g9ac3wLbeYoy+IMJcexHOAVPtxdk27ksFOOClYU2Ou/enfSoWD
         kRjjyJTxA2B+X+G9TXX7nN1EOjToVKLBOYR5HKG1MiU3/hlFJFpoBf9vP7Ga87HTvrZi
         mmMk3Ma4N+103XjMsbzRh8cqhmzKnEK+MQU01ALDB1kX3hCj3KjzbR8dokd9F3xO4woZ
         cME5u9ygNGE4fJjJYanq18iDf9D3dVcpHCojJAEEsq8sqkIwIZjOSU24SgQb/QXSUlHw
         gqtw7qpyqrrMx29BaCpq29ymgit7itjOG4wjLKe6960m9RB+pQBRQHKuo3XB5Mheyn7q
         FcZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NJfd+Dl6LyVyy7WHaPVunJ2WQBOC5w96NLDZ1F2YTMU=;
        b=sMmjusKmk281OaBsO9nDtwjdpImS+EZPNks1A+tdZbKUSSomMPYKd4PO5ZXwPTWMCy
         IOs4wcYazgNZyGDvynJgySmHsRCbZemF2r4hrdm4GX5Bt68BSJsziet08pgivB4u3Ugf
         1gSvzYLp5JWJYn1r64o+ntLb/hZI6PIT60GU3Xqe/46j0obRyV7xZQAJv21sMJ4TinqI
         ckHiA73RTE89IYxMLcEigUsUSF5jYLlff0T26W6QAQEVIp0UOCKIoZTrqtZ9DRcy9IyG
         +wsOWzKx/UzfM8UyMBuvvoPXAire0DICHfmi01fL1xJYvcpB2TfBe3HJRVqdypmnj3gN
         Gf3w==
X-Gm-Message-State: AOAM5327/ieKQbRY3rGBHL0lZqGAQFJPklMRrLZYn8Mbkn7Qowgjxzzq
        BSKrXfV3WbPG2PTLj6OrCRl9jA==
X-Google-Smtp-Source: ABdhPJz/LJrGEeFqHQou6i5SysEv2s1GOhEKWvZxYRCQiM1Pw2xt2H16CF7bw3hKs6fgqyMiHnKaxg==
X-Received: by 2002:a17:90a:1d4c:: with SMTP id u12mr10217220pju.95.1631503321038;
        Sun, 12 Sep 2021 20:22:01 -0700 (PDT)
Received: from 64-217.. ([103.97.201.33])
        by smtp.gmail.com with ESMTPSA id k127sm5042950pfd.1.2021.09.12.20.21.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Sep 2021 20:22:00 -0700 (PDT)
From:   Li Feng <fengli@smartx.com>
To:     Song Liu <song@kernel.org>, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Li Feng <fengli@smartx.com>
Subject: [PATCH] md: allow to set the fail_fast on RAID1/RAID10
Date:   Mon, 13 Sep 2021 11:20:03 +0800
Message-Id: <20210913032003.2836583-1-fengli@smartx.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

When the running RAID1/RAID10 need to be set with the fail_fast flag,
we have to remove each device from RAID and re-add it again with the
--fail_fast flag.

Export the fail_fast flag to the userspace to support the read and
write.

Signed-off-by: Li Feng <fengli@smartx.com>
---
 drivers/md/md.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index ae8fe54ea358..ce63972a4555 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3583,6 +3583,35 @@ ppl_size_store(struct md_rdev *rdev, const char *buf, size_t len)
 static struct rdev_sysfs_entry rdev_ppl_size =
 __ATTR(ppl_size, S_IRUGO|S_IWUSR, ppl_size_show, ppl_size_store);
 
+static ssize_t
+fail_fast_show(struct md_rdev *rdev, char *page)
+{
+	return sprintf(page, "%d\n", test_bit(FailFast, &rdev->flags));
+}
+
+static ssize_t
+fail_fast_store(struct md_rdev *rdev, const char *buf, size_t len)
+{
+	int ret;
+	bool bit;
+
+	ret = kstrtobool(buf, &bit);
+	if (ret)
+		return ret;
+
+	if (test_bit(FailFast, &rdev->flags) && !bit) {
+		clear_bit(FailFast, &rdev->flags);
+		md_update_sb(rdev->mddev, 1);
+	} else if (!test_bit(FailFast, &rdev->flags) && bit) {
+		set_bit(FailFast, &rdev->flags);
+		md_update_sb(rdev->mddev, 1);
+	}
+	return len;
+}
+
+static struct rdev_sysfs_entry rdev_fail_fast =
+__ATTR(fail_fast, 0644, fail_fast_show, fail_fast_store);
+
 static struct attribute *rdev_default_attrs[] = {
 	&rdev_state.attr,
 	&rdev_errors.attr,
@@ -3595,6 +3624,7 @@ static struct attribute *rdev_default_attrs[] = {
 	&rdev_unack_bad_blocks.attr,
 	&rdev_ppl_sector.attr,
 	&rdev_ppl_size.attr,
+	&rdev_fail_fast.attr,
 	NULL,
 };
 static ssize_t
-- 
2.31.1

