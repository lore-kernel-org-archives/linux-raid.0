Return-Path: <SRS0=Kwls=DG=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0FDFC4346E
	for <linux-raid@archiver.kernel.org>; Tue, 29 Sep 2020 06:47:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B57992083B
	for <linux-raid@archiver.kernel.org>; Tue, 29 Sep 2020 06:47:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727408AbgI2GrM (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 29 Sep 2020 02:47:12 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:40584 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725826AbgI2GrL (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 29 Sep 2020 02:47:11 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id B89A582A3DECEB3DD9BB;
        Tue, 29 Sep 2020 14:47:10 +0800 (CST)
Received: from huawei.com (10.175.127.227) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.487.0; Tue, 29 Sep 2020
 14:47:00 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <song@kernel.org>, <axboe@kernel.dk>, <linux-raid@vger.kernel.org>
CC:     Jason Yan <yanaijie@huawei.com>
Subject: [PATCH] md/raid0: remove unused function is_io_in_chunk_boundary()
Date:   Tue, 29 Sep 2020 14:47:59 +0800
Message-ID: <20200929064759.3605064-1-yanaijie@huawei.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

This function is no longger needed after commit 20d0189b1012 ("block:
Introduce new bio_split()").

Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/md/raid0.c | 17 -----------------
 1 file changed, 17 deletions(-)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index aa2d72791768..35843df15b5e 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -426,23 +426,6 @@ static void raid0_free(struct mddev *mddev, void *priv)
 	kfree(conf);
 }
 
-/*
- * Is io distribute over 1 or more chunks ?
-*/
-static inline int is_io_in_chunk_boundary(struct mddev *mddev,
-			unsigned int chunk_sects, struct bio *bio)
-{
-	if (likely(is_power_of_2(chunk_sects))) {
-		return chunk_sects >=
-			((bio->bi_iter.bi_sector & (chunk_sects-1))
-					+ bio_sectors(bio));
-	} else{
-		sector_t sector = bio->bi_iter.bi_sector;
-		return chunk_sects >= (sector_div(sector, chunk_sects)
-						+ bio_sectors(bio));
-	}
-}
-
 static void raid0_handle_discard(struct mddev *mddev, struct bio *bio)
 {
 	struct r0conf *conf = mddev->private;
-- 
2.25.4

