Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08C31C04A6A
	for <linux-raid@archiver.kernel.org>; Mon, 14 Aug 2023 13:55:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231643AbjHNNyl (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 14 Aug 2023 09:54:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231730AbjHNNy1 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 14 Aug 2023 09:54:27 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 331D510F4
        for <linux-raid@vger.kernel.org>; Mon, 14 Aug 2023 06:54:26 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id d2e1a72fcca58-686be28e1a8so3020591b3a.0
        for <linux-raid@vger.kernel.org>; Mon, 14 Aug 2023 06:54:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smartx-com.20221208.gappssmtp.com; s=20221208; t=1692021265; x=1692626065;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y3ZoyfLkeoyL9ct03/xsH7pdr7cmbeHEYZ/U9mmEUCw=;
        b=FU0SF1aDqpbGJF3lBnecyq2YDISs7pdShKtraYsvL9Tk2L1q26sjcf+eeqfoNob6BC
         R9PypBIYDr2NJ2bWBQHT4CTszViJS7KsH5GbDnyO17xtxWNTzkV3Ne1KjW+9D+enCkCR
         wKNganprEUZ1QVp/H0Prktg6/iGnqH2CijOxp7zUt+2pC8nUdS/eHz4YktF0d15TH2yk
         t9O8wMLpXJ/Ffoh8bZ7rvONHI9AnAjj0NUOecENQ4AhU9WqlDFGmB+81bjLL3nPtMD2y
         v+1NLQt88ogCBKqFun7DW/H9Ga/hRvgyi32EQFuIWW12byRpdT5SmdKDnHHxsT1vux8J
         gidw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692021265; x=1692626065;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y3ZoyfLkeoyL9ct03/xsH7pdr7cmbeHEYZ/U9mmEUCw=;
        b=hNDZVsiPdThTjyMdEJehKH/IQcVjH1LhzrxoDdkGaD/Fe0o2VQiokyYeDVVxkAVKXh
         n/nvj1QN7tvA6d/VMKySohwz0SKB6Wabn4G5W+6VsyHJwyGsYpWXbi5pc2RJSivWuB0G
         dB/ypxRCmXZYBQOKxvwN1WgyICOSg8TIhIYSVIwPBGBHSUcJbDeg+/O0SK1Focf0qadp
         eeUzDRuEEg5qnPJryUbWBoaX+TcT4hExKr3S8OPicE1d+rOeaUreymiNlp+yvZOBfWSZ
         PuIYHXPkmJnUB8ZLcy+0vZrkM87C/3tfW8Cc7oUN35JOj5LMsmInB83ojkYZrutdENr2
         mU+Q==
X-Gm-Message-State: AOJu0YziiH42nBfjaerGu1Vt+XbCxx+AegdYnlMGdYV4JaeHLNObEov9
        oCALGCU4f8tYWobKD+ta9fQthg==
X-Google-Smtp-Source: AGHT+IEqckEE/XCiRwmSDxLRyJNd4Hmrks4uXrqjSHA5K+QAOHGYoL8X/uOq97yXOppuiBS+5+5MaQ==
X-Received: by 2002:a05:6a20:4294:b0:140:6a7b:78bd with SMTP id o20-20020a056a20429400b001406a7b78bdmr10389461pzj.46.1692021265533;
        Mon, 14 Aug 2023 06:54:25 -0700 (PDT)
Received: from nixos.tailf4e9e.ts.net ([47.75.78.161])
        by smtp.googlemail.com with ESMTPSA id m26-20020a056a00165a00b006874a6850e9sm7962122pfc.215.2023.08.14.06.54.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Aug 2023 06:54:25 -0700 (PDT)
From:   Xueshi Hu <xueshi.hu@smartx.com>
To:     yukuai3@huawei.com, song@kernel.org, dan.j.williams@intel.com,
        neilb@suse.de, akpm@linux-foundation.org, neilb@suse.com
Cc:     linux-raid@vger.kernel.org, Xueshi Hu <xueshi.hu@smartx.com>
Subject: [PATCH v6 2/3] md/raid1: free the r1bio firstly before waiting for blocked rdev
Date:   Mon, 14 Aug 2023 21:53:55 +0800
Message-Id: <20230814135356.1113639-3-xueshi.hu@smartx.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230814135356.1113639-1-xueshi.hu@smartx.com>
References: <20230814135356.1113639-1-xueshi.hu@smartx.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Raid1 reshape will change mempool and r1conf::raid_disks which are
necessary when freeing r1bio. allow_barrier() make an concurrent
raid1_reshape() possible. So, free the in-flight r1bio firstly before
waiting blocked rdev.

Fixes: 6bfe0b499082 ("md: support blocking writes to an array on device failure")
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Xueshi Hu <xueshi.hu@smartx.com>
---
 drivers/md/raid1.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index dbbee0c14a5b..5f17f30a00a9 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1374,6 +1374,7 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 		return;
 	}
 
+ retry_write:
 	r1_bio = alloc_r1bio(mddev, bio);
 	r1_bio->sectors = max_write_sectors;
 
@@ -1389,7 +1390,6 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 	 */
 
 	disks = conf->raid_disks * 2;
- retry_write:
 	blocked_rdev = NULL;
 	rcu_read_lock();
 	max_sectors = r1_bio->sectors;
@@ -1469,7 +1469,7 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 		for (j = 0; j < i; j++)
 			if (r1_bio->bios[j])
 				rdev_dec_pending(conf->mirrors[j].rdev, mddev);
-		r1_bio->state = 0;
+		free_r1bio(r1_bio);
 		allow_barrier(conf, bio->bi_iter.bi_sector);
 
 		if (bio->bi_opf & REQ_NOWAIT) {
-- 
2.40.1

