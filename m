Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C966C433EF
	for <linux-raid@archiver.kernel.org>; Thu, 16 Jun 2022 19:20:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378289AbiFPTUV (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 16 Jun 2022 15:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377556AbiFPTT5 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 16 Jun 2022 15:19:57 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D7145620D;
        Thu, 16 Jun 2022 12:19:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Cc:To:From:content-disposition;
        bh=ww0/TV5RRR8rJ7SvdiX8OXRQBEbLDtnpG/LBC1FtO8Q=; b=gyv2umXvu2Mri+AJM6Jopd/iEE
        qkDzmsHXyWgK1GP/QhpiRdBlVilFeXXg088N+jfDRwfV3bQ2rhcNyKGIv2OezJ4tlCYGWviGgAePi
        66oIZDI5hO9BD5a79e8gV9Krk/q292fNpAt+miMLQKkLwSV1YAgQ0QeUoTN9hSF7f6QYrFRNBPgw4
        Fut84X/z8EF1Ca38bXY5RGIEE/b0H14iJ4TU6tfv62vJBzfU8lt08Ni3nf7gNYlCtCIkU9rLf2d/z
        S8g9Fy/hd+8ojp7QrLh3fXcygmXGQqInoYn8p1KsipUnsYV4j/0ctcoCyqGvRxC/5FTIuHk7csU58
        Q83BtyAQ==;
Received: from cgy1-donard.priv.deltatee.com ([172.16.1.31])
        by ale.deltatee.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1o1v20-0092il-O1; Thu, 16 Jun 2022 13:19:53 -0600
Received: from gunthorp by cgy1-donard.priv.deltatee.com with local (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1o1v1v-0006FP-Je; Thu, 16 Jun 2022 13:19:47 -0600
From:   Logan Gunthorpe <logang@deltatee.com>
To:     linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        Song Liu <song@kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Christoph Hellwig <hch@lst.de>
Date:   Thu, 16 Jun 2022 13:19:37 -0600
Message-Id: <20220616191945.23935-8-logang@deltatee.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220616191945.23935-1-logang@deltatee.com>
References: <20220616191945.23935-1-logang@deltatee.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 172.16.1.31
X-SA-Exim-Rcpt-To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, song@kernel.org, hch@infradead.org, guoqing.jiang@linux.dev, sbates@raithlin.com, Martin.Oliveira@eideticom.com, David.Sloan@eideticom.com, logang@deltatee.com, hch@lst.de
X-SA-Exim-Mail-From: gunthorp@deltatee.com
Subject: [PATCH v3 07/15] md/raid5: Drop the do_prepare flag in raid5_make_request()
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

prepare_to_wait() can be reasonably called after schedule instead of
setting a flag and preparing in the next loop iteration.

This means that prepare_to_wait() will be called before
read_seqcount_begin(), but there shouldn't be any reason that the order
matters here. On the first iteration of the loop prepare_to_wait() is
already called first.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Guoqing Jiang <guoqing.jiang@linux.dev>
---
 drivers/md/raid5.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 26ef292842de..c58e70db204a 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5918,7 +5918,6 @@ static bool raid5_make_request(struct mddev *mddev, struct bio * bi)
 	const int rw = bio_data_dir(bi);
 	enum stripe_result res;
 	DEFINE_WAIT(w);
-	bool do_prepare;
 
 	if (unlikely(bi->bi_opf & REQ_PREFLUSH)) {
 		int ret = log_handle_flush_request(conf, bi);
@@ -5976,12 +5975,8 @@ static bool raid5_make_request(struct mddev *mddev, struct bio * bi)
 	for (; logical_sector < last_sector; logical_sector += RAID5_STRIPE_SECTORS(conf)) {
 		int seq;
 
-		do_prepare = false;
 	retry:
 		seq = read_seqcount_begin(&conf->gen_lock);
-		if (do_prepare)
-			prepare_to_wait(&conf->wait_for_overlap, &w,
-				TASK_UNINTERRUPTIBLE);
 
 		res = make_stripe_request(mddev, conf, &ctx, logical_sector,
 					  bi, seq);
@@ -5993,7 +5988,8 @@ static bool raid5_make_request(struct mddev *mddev, struct bio * bi)
 
 		if (res == STRIPE_SCHEDULE_AND_RETRY) {
 			schedule();
-			do_prepare = true;
+			prepare_to_wait(&conf->wait_for_overlap, &w,
+					TASK_UNINTERRUPTIBLE);
 			goto retry;
 		}
 	}
-- 
2.30.2

