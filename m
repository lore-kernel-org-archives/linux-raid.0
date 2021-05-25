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
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC1D9C4707F
	for <linux-raid@archiver.kernel.org>; Tue, 25 May 2021 09:47:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3C716100B
	for <linux-raid@archiver.kernel.org>; Tue, 25 May 2021 09:47:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232692AbhEYJsd (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 25 May 2021 05:48:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232686AbhEYJsc (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 25 May 2021 05:48:32 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32DD6C06138B
        for <linux-raid@vger.kernel.org>; Tue, 25 May 2021 02:47:03 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id j12so22296899pgh.7
        for <linux-raid@vger.kernel.org>; Tue, 25 May 2021 02:47:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bkFfsz2HrYpXsYgoOTSdz6GnQ7C9O4bH3pvDcdklVso=;
        b=gV9HedKq1WMbVl0lghkeO4pZ42LYdKKsXZRHBOMCwgcOtZT7NxeM3TdfyO5GaPScw2
         6mCrYjMeyHq/X5jdHipeLFlm7YCwP1rCpphw4By3UGvukpEZ1iXTmcBYRR1ZN+yhZ2Sr
         QxR4GWJlGBturHrmz4+UMcg8DexUFmuIX/omTWJtFQQ/QIqozDN4sJnVUcNw3GAAVVX/
         X5DJi+U6CHofS2uEjS8lVlKRmyNOw6R3EmIZxZF2rC29nc05EG88C6gJOo4Z3UUtV+wJ
         BzwG3+qMx4pE3NFtGwpz/1CnVkNp7Oj4i28Ya/7YNPW+yyDHBXjBxmInKUHBp7/Sq8mq
         AwWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bkFfsz2HrYpXsYgoOTSdz6GnQ7C9O4bH3pvDcdklVso=;
        b=rMFeVhRcnCkX4WJwy+qc5RXwTZDm1uOm1dYAcSclkzddHJqXY5efZ4D3eb/7uL36Hx
         cH1pbdDli0FuohY0yoqayhpzu2qn1ORQv+BTe4WH/cp2PQa3pix9RwXCFZS/IjF98rWi
         s2xgsMA/l6H90CbnoKQezouDjqd8iRvK1rJQpPWjm5A+B9XLS+Je2rWF8MApai5fSGfn
         zcI5uy8vAR/lLWcAA83vU6N33ASc4dapwADzFSMd7X5OZQusisq1OsR5SmY1NStYduYf
         H26ECvhYExTuBkz5kqhx+dHpGUan8IP4w71Cvn8bEOgG71MpUeDprBjQTjA15HD6vTkh
         hB+w==
X-Gm-Message-State: AOAM530ACNW+52QPyuAjToUL61RyiiV6DNilTXAoUG/wSLnODbAWD9Uz
        JfRCwdE9ag8rOpD01mdV5oAvv/Ua5+Q=
X-Google-Smtp-Source: ABdhPJw3kHPGRj8QQSH6TqkyUEtUDrCw25p2bovZn8OR8WqDv5Ps/AVRhLPvD8Lvr2nZt/hlINRu/A==
X-Received: by 2002:a63:490:: with SMTP id 138mr18205431pge.99.1621936022813;
        Tue, 25 May 2021 02:47:02 -0700 (PDT)
Received: from localhost.localdomain ([89.187.161.155])
        by smtp.gmail.com with ESMTPSA id r10sm13114437pfl.159.2021.05.25.02.47.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 May 2021 02:47:02 -0700 (PDT)
From:   Guoqing Jiang <jgq516@gmail.com>
X-Google-Original-From: Guoqing Jiang <jiangguoqing@kylinos.cn>
To:     song@kernel.org
Cc:     linux-raid@vger.kernel.org, artur.paszkiewicz@intel.com,
        hch@infradead.org
Subject: [PATCH V3 3/8] md/raid5: move checking badblock before clone bio in raid5_read_one_chunk
Date:   Tue, 25 May 2021 17:46:18 +0800
Message-Id: <20210525094623.763195-4-jiangguoqing@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210525094623.763195-1-jiangguoqing@kylinos.cn>
References: <20210525094623.763195-1-jiangguoqing@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

We don't need to clone bio if the relevant region has badblock.

Signed-off-by: Guoqing Jiang <jiangguoqing@kylinos.cn>
---
 drivers/md/raid5.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 58e9dbc0f683..5a05277f4be7 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5427,6 +5427,13 @@ static int raid5_read_one_chunk(struct mddev *mddev, struct bio *raid_bio)
 	atomic_inc(&rdev->nr_pending);
 	rcu_read_unlock();
 
+	if (is_badblock(rdev, sector, bio_sectors(raid_bio), &first_bad,
+			&bad_sectors)) {
+		bio_put(raid_bio);
+		rdev_dec_pending(rdev, mddev);
+		return 0;
+	}
+
 	align_bio = bio_clone_fast(raid_bio, GFP_NOIO, &mddev->bio_set);
 	bio_set_dev(align_bio, rdev->bdev);
 	align_bio->bi_end_io = raid5_align_endio;
@@ -5435,13 +5442,6 @@ static int raid5_read_one_chunk(struct mddev *mddev, struct bio *raid_bio)
 
 	raid_bio->bi_next = (void *)rdev;
 
-	if (is_badblock(rdev, sector, bio_sectors(align_bio), &first_bad,
-			&bad_sectors)) {
-		bio_put(align_bio);
-		rdev_dec_pending(rdev, mddev);
-		return 0;
-	}
-
 	/* No reshape active, so we can trust rdev->data_offset */
 	align_bio->bi_iter.bi_sector += rdev->data_offset;
 
-- 
2.25.1

