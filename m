Return-Path: <SRS0=xKAG=B6=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07DC1C433E1
	for <linux-raid@archiver.kernel.org>; Thu, 20 Aug 2020 13:22:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D21AA208DB
	for <linux-raid@archiver.kernel.org>; Thu, 20 Aug 2020 13:22:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729443AbgHTNWS (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 20 Aug 2020 09:22:18 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:10239 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728700AbgHTNWG (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 20 Aug 2020 09:22:06 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 87EC39B69A099393F2F0;
        Thu, 20 Aug 2020 21:21:51 +0800 (CST)
Received: from huawei.com (10.175.101.6) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.487.0; Thu, 20 Aug 2020
 21:21:43 +0800
From:   Yufen Yu <yuyufen@huawei.com>
To:     <song@kernel.org>
CC:     <linux-raid@vger.kernel.org>, <houtao1@huawei.com>
Subject: [PATCH v2 03/10] md/raid5: make async_copy_data() to support different page offset
Date:   Thu, 20 Aug 2020 09:22:07 -0400
Message-ID: <20200820132214.3749139-4-yuyufen@huawei.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200820132214.3749139-1-yuyufen@huawei.com>
References: <20200820132214.3749139-1-yuyufen@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.101.6]
X-CFilter-Loop: Reflected
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

ops_run_biofill() and ops_run_biodrain() will call async_copy_data()
to copy sh->dev[i].page from or to bio page. For now, it implies the
offset of dev[i].page is 0. But we want to support different page offset
in the following.

Thus, pass page offset to these functions and replace 'page_offset'
with 'page_offset + poff'.

No functional change.

Signed-off-by: Yufen Yu <yuyufen@huawei.com>
---
 drivers/md/raid5.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 445a73e1dd2a..e6bbba1e05f4 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1227,7 +1227,7 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 
 static struct dma_async_tx_descriptor *
 async_copy_data(int frombio, struct bio *bio, struct page **page,
-	sector_t sector, struct dma_async_tx_descriptor *tx,
+	unsigned int poff, sector_t sector, struct dma_async_tx_descriptor *tx,
 	struct stripe_head *sh, int no_skipcopy)
 {
 	struct bio_vec bvl;
@@ -1273,11 +1273,11 @@ async_copy_data(int frombio, struct bio *bio, struct page **page,
 				    !no_skipcopy)
 					*page = bio_page;
 				else
-					tx = async_memcpy(*page, bio_page, page_offset,
+					tx = async_memcpy(*page, bio_page, page_offset + poff,
 						  b_offset, clen, &submit);
 			} else
 				tx = async_memcpy(bio_page, *page, b_offset,
-						  page_offset, clen, &submit);
+						  page_offset + poff, clen, &submit);
 		}
 		/* chain the operations */
 		submit.depend_tx = tx;
@@ -1350,6 +1350,7 @@ static void ops_run_biofill(struct stripe_head *sh)
 			while (rbi && rbi->bi_iter.bi_sector <
 				dev->sector + RAID5_STRIPE_SECTORS(conf)) {
 				tx = async_copy_data(0, rbi, &dev->page,
+						     dev->offset,
 						     dev->sector, tx, sh, 0);
 				rbi = r5_next_bio(conf, rbi, dev->sector);
 			}
@@ -1790,6 +1791,7 @@ ops_run_biodrain(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
 					set_bit(R5_Discard, &dev->flags);
 				else {
 					tx = async_copy_data(1, wbi, &dev->page,
+							     dev->offset,
 							     dev->sector, tx, sh,
 							     r5c_is_writeback(conf->log));
 					if (dev->page != dev->orig_page &&
-- 
2.25.4

