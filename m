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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C80C4C47096
	for <linux-raid@archiver.kernel.org>; Thu,  3 Jun 2021 09:22:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD32F61369
	for <linux-raid@archiver.kernel.org>; Thu,  3 Jun 2021 09:22:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbhFCJXo (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 3 Jun 2021 05:23:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbhFCJXo (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 3 Jun 2021 05:23:44 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9522C061756
        for <linux-raid@vger.kernel.org>; Thu,  3 Jun 2021 02:21:46 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id d16so4411263pfn.12
        for <linux-raid@vger.kernel.org>; Thu, 03 Jun 2021 02:21:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rnz8krzV9WehgRZRRVBE2mJFRYMGs3gYLPEIFJnkZwo=;
        b=cTwok83cHvlqiyO1O2eLHJA8dNZAb2Oz6YQiAXPi12qmUEmaue38yYFeObk9+h3G71
         479/k8dmDPwwaQU2ffBebjTAeQAZewbXziDeNE6qcx+TKKS0Wx1bVZ1HDUVqvmQGqnzw
         AhpaCBF51Rn4eh7RkCDXu5xR+B8fyAiGl1H6SpO8U5+PVk4m9yx+M0SqFw7YT9YJV3EZ
         cOHAmWhNamHTMMt+MFtYBEVs7m8OgIelTyzVNIozAJyBJ/6CqiTXq4+FdiPg+DcwFakK
         NsbCVi/z5FhLRqFuC+r7mHlRIRNA4IqgvRgM78adKUsSr28vHLVRAlbGiR393U+mirUU
         x80w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rnz8krzV9WehgRZRRVBE2mJFRYMGs3gYLPEIFJnkZwo=;
        b=AXVk1B/ivSnLHVGksqfaYiOabBab8xTgPeb5q7HPjKR32Ep4xWf3ueyNuoIhEzuzlH
         whUdJ3oPjVXLhLkEoMXOial+zvTyBmUzjfl1cPPsv0DjTBbnFAY1cNw2C0W5tdbobKP5
         VAgMQ8Pdly07MPU+9tBRBXwdA4h3qkRRACqaOW4xmJ3hy/+iL6XxSr+jCFxkI0tQek3Y
         KuYexrMbdY/Ndalzpxmmd1B/py6GEQryNGVRROdCvMXVoxEMysCh+B1SceIQW9OmWXEp
         otzJwolssmyfraA/mtO2k0xb8rwOkxVMjhyN1AFdvEfZfEig8RfjqK1BSbBqo5D5CyX4
         Bv3Q==
X-Gm-Message-State: AOAM530U4APASLzCZPIPDSYsA7xnNFS36reN+IO5MxBgYNybzyXYRLbA
        6kfv31vwTgMtN3g/EfohTxmLHxb4Wus=
X-Google-Smtp-Source: ABdhPJzVKGrgDTE0cvT48q8LKD0HSDLMj3rfcTl57zIdwwGeOFTNs02vEx8FF7U9B563duuvP484tQ==
X-Received: by 2002:a05:6a00:1992:b029:2df:b93b:49a with SMTP id d18-20020a056a001992b02902dfb93b049amr31405172pfl.11.1622712106312;
        Thu, 03 Jun 2021 02:21:46 -0700 (PDT)
Received: from localhost.localdomain ([89.187.161.155])
        by smtp.gmail.com with ESMTPSA id c24sm1937249pfn.63.2021.06.03.02.21.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jun 2021 02:21:46 -0700 (PDT)
From:   Guoqing Jiang <jgq516@gmail.com>
X-Google-Original-From: Guoqing Jiang <jiangguoqing@kylinos.cn>
To:     song@kernel.org
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH 1/2] md: check level before create and exit io_acct_set
Date:   Thu,  3 Jun 2021 17:21:06 +0800
Message-Id: <20210603092107.1415706-2-jiangguoqing@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210603092107.1415706-1-jiangguoqing@kylinos.cn>
References: <20210603092107.1415706-1-jiangguoqing@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

The bio_set (io_acct_set) is used by personalities to clone bio and
trace the timestamp of bio. Some personalities such as raid1/10 don't
need the bio_set, so add check to not create it unconditionally.

Also update the comment for md_account_bio to make it more clear.

Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Guoqing Jiang <jiangguoqing@kylinos.cn>
---
 drivers/md/md.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 32abcfb8bcad..56b606184c87 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2341,7 +2341,8 @@ int md_integrity_register(struct mddev *mddev)
 
 	pr_debug("md: data integrity enabled on %s\n", mdname(mddev));
 	if (bioset_integrity_create(&mddev->bio_set, BIO_POOL_SIZE) ||
-	    bioset_integrity_create(&mddev->io_acct_set, BIO_POOL_SIZE)) {
+	    (mddev->level != 1 && mddev->level != 10 &&
+	     bioset_integrity_create(&mddev->io_acct_set, BIO_POOL_SIZE))) {
 		pr_err("md: failed to create integrity pool for %s\n",
 		       mdname(mddev));
 		return -EINVAL;
@@ -5570,7 +5571,8 @@ static void md_free(struct kobject *ko)
 
 	bioset_exit(&mddev->bio_set);
 	bioset_exit(&mddev->sync_set);
-	bioset_exit(&mddev->io_acct_set);
+	if (mddev->level != 1 && mddev->level != 10)
+		bioset_exit(&mddev->io_acct_set);
 	kfree(mddev);
 }
 
@@ -5866,7 +5868,8 @@ int md_run(struct mddev *mddev)
 		if (err)
 			goto exit_bio_set;
 	}
-	if (!bioset_initialized(&mddev->io_acct_set)) {
+	if (mddev->level != 1 && mddev->level != 10 &&
+	    !bioset_initialized(&mddev->io_acct_set)) {
 		err = bioset_init(&mddev->io_acct_set, BIO_POOL_SIZE,
 				  offsetof(struct md_io_acct, bio_clone), 0);
 		if (err)
@@ -6048,7 +6051,8 @@ int md_run(struct mddev *mddev)
 	module_put(pers->owner);
 	md_bitmap_destroy(mddev);
 abort:
-	bioset_exit(&mddev->io_acct_set);
+	if (mddev->level != 1 && mddev->level != 10)
+		bioset_exit(&mddev->io_acct_set);
 exit_sync_set:
 	bioset_exit(&mddev->sync_set);
 exit_bio_set:
@@ -6276,7 +6280,8 @@ void md_stop(struct mddev *mddev)
 	__md_stop(mddev);
 	bioset_exit(&mddev->bio_set);
 	bioset_exit(&mddev->sync_set);
-	bioset_exit(&mddev->io_acct_set);
+	if (mddev->level != 1 && mddev->level != 10)
+		bioset_exit(&mddev->io_acct_set);
 }
 
 EXPORT_SYMBOL_GPL(md_stop);
@@ -8593,7 +8598,10 @@ static void md_end_io_acct(struct bio *bio)
 	bio_endio(orig_bio);
 }
 
-/* used by personalities (raid0 and raid5) to account io stats */
+/*
+ * Used by personalities that don't already clone the bio and thus can't
+ * easily add the timestamp to their extended bio structure.
+ */
 void md_account_bio(struct mddev *mddev, struct bio **bio)
 {
 	struct md_io_acct *md_io_acct;
-- 
2.25.1

