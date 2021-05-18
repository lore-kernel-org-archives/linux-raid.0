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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77296C433B4
	for <linux-raid@archiver.kernel.org>; Tue, 18 May 2021 05:33:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 58A4960FDB
	for <linux-raid@archiver.kernel.org>; Tue, 18 May 2021 05:33:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241003AbhERFe2 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 18 May 2021 01:34:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240761AbhERFe1 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 18 May 2021 01:34:27 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7146FC061573
        for <linux-raid@vger.kernel.org>; Mon, 17 May 2021 22:33:10 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id s19so4324055pfe.8
        for <linux-raid@vger.kernel.org>; Mon, 17 May 2021 22:33:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XvuQpsBmOLIR5HP+hLpkBx2kkXwKYX22AWOSu+7X+iU=;
        b=abw/xicG3yqn2ndEjIgRpEzmFyYc2gM+Wiws7HZu0B3yIy7XscZwXmOaisgGgIzwos
         7kuB9eIEFixwtX++KqPVfwRetDD8PPNUt4rXixdUvsZT2JT+wRdkOj9sKcHd9S+/QPEc
         AIQgEUSjc7zTA6wtkP0c47MjO5A9NnhY1eYpadcvEkZ6HcFUX59Xp7g04G6mjR+kR7oI
         4J/25V5j30j+Ll/obiXBDj9Hmk08KrYd6pMUj4AV35+m3tT/b/fUsNrrQmO0mlu9GLiD
         n5yn8FwSWnvS1fpna5aMbFuTHR22Sg+fwh9pIPDrMkxbXh3ue6YQdi6Ap1fziBdDnn6S
         TNww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XvuQpsBmOLIR5HP+hLpkBx2kkXwKYX22AWOSu+7X+iU=;
        b=Gqck2j4FUtNSjNYaDqxljyqz/gpXsQ0+YYpdu9jncRkzbvSd1aQ6deMeHCR0GAAD3e
         N/TJXJG5O21f3jfLICu8Ud/qbSQlHI8rtOo81Egjv/38mb5DiBk80VjfkqMNZMGVyn9p
         oFVUvu9+yZPir9bDLHVknpzejzToCdL9nkyP5GOPcp8oZ5UALZMkZd9axhG2DPB/wGZj
         s9XLGlnu8TpreKrongYf44DPImG9UAszahkI68zZ4qfTsvGG+QUYGyWAccl9ezkOoaTn
         akUhwBilkuaPNMfrftUh1mXPnaIQFEBW+nCuWxRCd9UBYx6DswqvuUwyi9kHOBupeqmN
         U2eg==
X-Gm-Message-State: AOAM532KKQmhU/wjYnYQlOrI024vPB4h5l4ivZkAg4WoKsv39USAVyjG
        AkRkJumYLHHh+eB8DWwBtwo=
X-Google-Smtp-Source: ABdhPJxt4l6nM0T/p7z61i2DlvA21b77d/bxbbz18wK6Xkfl5ga2v6sl1dqKsMHuy9IfviBSXDD7Ag==
X-Received: by 2002:a63:bf0d:: with SMTP id v13mr3294213pgf.303.1621315990091;
        Mon, 17 May 2021 22:33:10 -0700 (PDT)
Received: from localhost.localdomain ([89.187.161.155])
        by smtp.gmail.com with ESMTPSA id z20sm11756726pjq.47.2021.05.17.22.33.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 22:33:09 -0700 (PDT)
From:   Guoqing Jiang <jgq516@gmail.com>
X-Google-Original-From: Guoqing Jiang <jiangguoqing@kylinos.cn>
To:     song@kernel.org
Cc:     linux-raid@vger.kernel.org, artur.paszkiewicz@intel.com,
        Guoqing Jiang <jiangguoqing@kylinos.cn>
Subject: [PATCH 3/5] md-multipath: enable io accounting
Date:   Tue, 18 May 2021 13:32:23 +0800
Message-Id: <20210518053225.641506-4-jiangguoqing@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210518053225.641506-1-jiangguoqing@kylinos.cn>
References: <20210518053225.641506-1-jiangguoqing@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

We can do the accounting between make_request and io is finished, also
introduce start_time accordingly.

Signed-off-by: Guoqing Jiang <jiangguoqing@kylinos.cn>
---
 drivers/md/md-multipath.c | 5 +++++
 drivers/md/md-multipath.h | 1 +
 2 files changed, 6 insertions(+)

diff --git a/drivers/md/md-multipath.c b/drivers/md/md-multipath.c
index 776bbe542db5..17cf35f4acdb 100644
--- a/drivers/md/md-multipath.c
+++ b/drivers/md/md-multipath.c
@@ -71,6 +71,8 @@ static void multipath_end_bh_io(struct multipath_bh *mp_bh, blk_status_t status)
 	struct mpconf *conf = mp_bh->mddev->private;
 
 	bio->bi_status = status;
+	if (blk_queue_io_stat(bio->bi_bdev->bd_disk->queue))
+		bio_end_io_acct_remapped(bio, mp_bh->start_time, bio->bi_bdev);
 	bio_endio(bio);
 	mempool_free(mp_bh, &conf->pool);
 }
@@ -124,6 +126,9 @@ static bool multipath_make_request(struct mddev *mddev, struct bio * bio)
 	bio_init(&mp_bh->bio, NULL, 0);
 	__bio_clone_fast(&mp_bh->bio, bio);
 
+	if (blk_queue_io_stat(bio->bi_bdev->bd_disk->queue))
+		mp_bh->start_time = bio_start_io_acct(bio);
+
 	mp_bh->bio.bi_iter.bi_sector += multipath->rdev->data_offset;
 	bio_set_dev(&mp_bh->bio, multipath->rdev->bdev);
 	mp_bh->bio.bi_opf |= REQ_FAILFAST_TRANSPORT;
diff --git a/drivers/md/md-multipath.h b/drivers/md/md-multipath.h
index b3099e5fc4d7..71376d95eac0 100644
--- a/drivers/md/md-multipath.h
+++ b/drivers/md/md-multipath.h
@@ -28,5 +28,6 @@ struct multipath_bh {
 	struct bio		bio;
 	int			path;
 	struct list_head	retry_list;
+	unsigned long		start_time;
 };
 #endif
-- 
2.25.1

