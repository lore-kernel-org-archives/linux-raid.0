Return-Path: <SRS0=xKAG=B6=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 260F5C433E3
	for <linux-raid@archiver.kernel.org>; Thu, 20 Aug 2020 13:22:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F00B1208DB
	for <linux-raid@archiver.kernel.org>; Thu, 20 Aug 2020 13:22:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728639AbgHTNWV (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 20 Aug 2020 09:22:21 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:10241 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728785AbgHTNWE (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 20 Aug 2020 09:22:04 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 8BA2F4B1CC912B4AA6D3;
        Thu, 20 Aug 2020 21:21:51 +0800 (CST)
Received: from huawei.com (10.175.101.6) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.487.0; Thu, 20 Aug 2020
 21:21:43 +0800
From:   Yufen Yu <yuyufen@huawei.com>
To:     <song@kernel.org>
CC:     <linux-raid@vger.kernel.org>, <houtao1@huawei.com>
Subject: [PATCH v2 05/10] md/raid5: convert to new xor compution interface
Date:   Thu, 20 Aug 2020 09:22:09 -0400
Message-ID: <20200820132214.3749139-6-yuyufen@huawei.com>
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

We try to replace async_xor() and async_xor_val() with the new
introduced interface async_xor_offs() and async_xor_val_offs()
for raid456.

Signed-off-by: Yufen Yu <yuyufen@huawei.com>
---
 drivers/md/raid5.c | 43 ++++++++++++++++++++++++++++++++++---------
 1 file changed, 34 insertions(+), 9 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index e6bbba1e05f4..a37ff68db6af 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1451,7 +1451,7 @@ ops_run_compute5(struct stripe_head *sh, struct raid5_percpu *percpu)
 		tx = async_memcpy(xor_dest, xor_srcs[0], off_dest, off_srcs[0],
 				RAID5_STRIPE_SIZE(sh->raid_conf), &submit);
 	else
-		tx = async_xor(xor_dest, xor_srcs, 0, count,
+		tx = async_xor_offs(xor_dest, off_dest, xor_srcs, off_srcs, count,
 				RAID5_STRIPE_SIZE(sh->raid_conf), &submit);
 
 	return tx;
@@ -1509,12 +1509,14 @@ ops_run_compute6_1(struct stripe_head *sh, struct raid5_percpu *percpu)
 {
 	int disks = sh->disks;
 	struct page **blocks = to_addr_page(percpu, 0);
+	unsigned int *offs = to_addr_offs(sh, percpu);
 	int target;
 	int qd_idx = sh->qd_idx;
 	struct dma_async_tx_descriptor *tx;
 	struct async_submit_ctl submit;
 	struct r5dev *tgt;
 	struct page *dest;
+	unsigned int dest_off;
 	int i;
 	int count;
 
@@ -1533,6 +1535,7 @@ ops_run_compute6_1(struct stripe_head *sh, struct raid5_percpu *percpu)
 	tgt = &sh->dev[target];
 	BUG_ON(!test_bit(R5_Wantcompute, &tgt->flags));
 	dest = tgt->page;
+	dest_off = tgt->offset;
 
 	atomic_inc(&sh->count);
 
@@ -1551,13 +1554,14 @@ ops_run_compute6_1(struct stripe_head *sh, struct raid5_percpu *percpu)
 		for (i = disks; i-- ; ) {
 			if (i == target || i == qd_idx)
 				continue;
+			offs[count] = sh->dev[i].offset;
 			blocks[count++] = sh->dev[i].page;
 		}
 
 		init_async_submit(&submit, ASYNC_TX_FENCE|ASYNC_TX_XOR_ZERO_DST,
 				  NULL, ops_complete_compute, sh,
 				  to_addr_conv(sh, percpu, 0));
-		tx = async_xor(dest, blocks, 0, count,
+		tx = async_xor_offs(dest, dest_off, blocks, offs, count,
 				RAID5_STRIPE_SIZE(sh->raid_conf), &submit);
 	}
 
@@ -1577,6 +1581,7 @@ ops_run_compute6_2(struct stripe_head *sh, struct raid5_percpu *percpu)
 	struct r5dev *tgt2 = &sh->dev[target2];
 	struct dma_async_tx_descriptor *tx;
 	struct page **blocks = to_addr_page(percpu, 0);
+	unsigned int *offs = to_addr_offs(sh, percpu);
 	struct async_submit_ctl submit;
 
 	BUG_ON(sh->batch_head);
@@ -1589,13 +1594,16 @@ ops_run_compute6_2(struct stripe_head *sh, struct raid5_percpu *percpu)
 	/* we need to open-code set_syndrome_sources to handle the
 	 * slot number conversion for 'faila' and 'failb'
 	 */
-	for (i = 0; i < disks ; i++)
+	for (i = 0; i < disks ; i++) {
+		offs[i] = 0;
 		blocks[i] = NULL;
+	}
 	count = 0;
 	i = d0_idx;
 	do {
 		int slot = raid6_idx_to_slot(i, sh, &count, syndrome_disks);
 
+		offs[slot] = sh->dev[i].offset;
 		blocks[slot] = sh->dev[i].page;
 
 		if (i == target)
@@ -1625,6 +1633,7 @@ ops_run_compute6_2(struct stripe_head *sh, struct raid5_percpu *percpu)
 						  &submit);
 		} else {
 			struct page *dest;
+			unsigned int dest_off;
 			int data_target;
 			int qd_idx = sh->qd_idx;
 
@@ -1638,14 +1647,16 @@ ops_run_compute6_2(struct stripe_head *sh, struct raid5_percpu *percpu)
 			for (i = disks; i-- ; ) {
 				if (i == data_target || i == qd_idx)
 					continue;
+				offs[count] = sh->dev[i].offset;
 				blocks[count++] = sh->dev[i].page;
 			}
 			dest = sh->dev[data_target].page;
+			dest_off = sh->dev[data_target].offset;
 			init_async_submit(&submit,
 					  ASYNC_TX_FENCE|ASYNC_TX_XOR_ZERO_DST,
 					  NULL, NULL, NULL,
 					  to_addr_conv(sh, percpu, 0));
-			tx = async_xor(dest, blocks, 0, count,
+			tx = async_xor_offs(dest, dest_off, blocks, offs, count,
 				       RAID5_STRIPE_SIZE(sh->raid_conf),
 				       &submit);
 
@@ -1698,10 +1709,12 @@ ops_run_prexor5(struct stripe_head *sh, struct raid5_percpu *percpu,
 {
 	int disks = sh->disks;
 	struct page **xor_srcs = to_addr_page(percpu, 0);
+	unsigned int *off_srcs = to_addr_offs(sh, percpu);
 	int count = 0, pd_idx = sh->pd_idx, i;
 	struct async_submit_ctl submit;
 
 	/* existing parity data subtracted */
+	unsigned int off_dest = off_srcs[count] = sh->dev[pd_idx].offset;
 	struct page *xor_dest = xor_srcs[count++] = sh->dev[pd_idx].page;
 
 	BUG_ON(sh->batch_head);
@@ -1711,15 +1724,22 @@ ops_run_prexor5(struct stripe_head *sh, struct raid5_percpu *percpu,
 	for (i = disks; i--; ) {
 		struct r5dev *dev = &sh->dev[i];
 		/* Only process blocks that are known to be uptodate */
-		if (test_bit(R5_InJournal, &dev->flags))
+		if (test_bit(R5_InJournal, &dev->flags)) {
+			/*
+			 * For this case, PAGE_SIZE must be equal to 4KB and
+			 * page offset is zero.
+			 */
+			off_srcs[count] = dev->offset;
 			xor_srcs[count++] = dev->orig_page;
-		else if (test_bit(R5_Wantdrain, &dev->flags))
+		} else if (test_bit(R5_Wantdrain, &dev->flags)) {
+			off_srcs[count] = dev->offset;
 			xor_srcs[count++] = dev->page;
+		}
 	}
 
 	init_async_submit(&submit, ASYNC_TX_FENCE|ASYNC_TX_XOR_DROP_DST, tx,
 			  ops_complete_prexor, sh, to_addr_conv(sh, percpu, 0));
-	tx = async_xor(xor_dest, xor_srcs, 0, count,
+	tx = async_xor_offs(xor_dest, off_dest, xor_srcs, off_srcs, count,
 			RAID5_STRIPE_SIZE(sh->raid_conf), &submit);
 
 	return tx;
@@ -1953,7 +1973,7 @@ ops_run_reconstruct5(struct stripe_head *sh, struct raid5_percpu *percpu,
 		tx = async_memcpy(xor_dest, xor_srcs[0], off_dest, off_srcs[0],
 				RAID5_STRIPE_SIZE(sh->raid_conf), &submit);
 	else
-		tx = async_xor(xor_dest, xor_srcs, 0, count,
+		tx = async_xor_offs(xor_dest, off_dest, xor_srcs, off_srcs, count,
 				RAID5_STRIPE_SIZE(sh->raid_conf), &submit);
 	if (!last_stripe) {
 		j++;
@@ -2042,7 +2062,9 @@ static void ops_run_check_p(struct stripe_head *sh, struct raid5_percpu *percpu)
 	int pd_idx = sh->pd_idx;
 	int qd_idx = sh->qd_idx;
 	struct page *xor_dest;
+	unsigned int off_dest;
 	struct page **xor_srcs = to_addr_page(percpu, 0);
+	unsigned int *off_srcs = to_addr_offs(sh, percpu);
 	struct dma_async_tx_descriptor *tx;
 	struct async_submit_ctl submit;
 	int count;
@@ -2054,16 +2076,19 @@ static void ops_run_check_p(struct stripe_head *sh, struct raid5_percpu *percpu)
 	BUG_ON(sh->batch_head);
 	count = 0;
 	xor_dest = sh->dev[pd_idx].page;
+	off_dest = sh->dev[pd_idx].offset;
+	off_srcs[count] = off_dest;
 	xor_srcs[count++] = xor_dest;
 	for (i = disks; i--; ) {
 		if (i == pd_idx || i == qd_idx)
 			continue;
+		off_srcs[count] = sh->dev[i].offset;
 		xor_srcs[count++] = sh->dev[i].page;
 	}
 
 	init_async_submit(&submit, 0, NULL, NULL, NULL,
 			  to_addr_conv(sh, percpu, 0));
-	tx = async_xor_val(xor_dest, xor_srcs, 0, count,
+	tx = async_xor_val_offs(xor_dest, off_dest, xor_srcs, off_srcs, count,
 			   RAID5_STRIPE_SIZE(sh->raid_conf),
 			   &sh->ops.zero_sum_result, &submit);
 
-- 
2.25.4

