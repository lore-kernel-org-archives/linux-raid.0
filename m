Return-Path: <SRS0=xKAG=B6=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89833C433E1
	for <linux-raid@archiver.kernel.org>; Thu, 20 Aug 2020 13:22:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67908208DB
	for <linux-raid@archiver.kernel.org>; Thu, 20 Aug 2020 13:22:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728371AbgHTNWX (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 20 Aug 2020 09:22:23 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:10242 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728795AbgHTNWE (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 20 Aug 2020 09:22:04 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 94EC4452C9327068E3C1;
        Thu, 20 Aug 2020 21:21:51 +0800 (CST)
Received: from huawei.com (10.175.101.6) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.487.0; Thu, 20 Aug 2020
 21:21:42 +0800
From:   Yufen Yu <yuyufen@huawei.com>
To:     <song@kernel.org>
CC:     <linux-raid@vger.kernel.org>, <houtao1@huawei.com>
Subject: [PATCH v2 02/10] md/raid5: add a new member of offset into r5dev
Date:   Thu, 20 Aug 2020 09:22:06 -0400
Message-ID: <20200820132214.3749139-3-yuyufen@huawei.com>
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

Add a new member of offset into struct r5dev. It indicates the
offset of related dev[i].page. For now, since each device have a
privated page, the value is always 0. Thus, we set offset as 0
when allcate page in grow_buffers() and resize_stripes().

To support following different page offset, we try to use the page
offset rather than '0' directly for async_memcpy() and ops_run_io().

We try to support different page offset for xor compution functions
in the following. To avoid repeatly allocate a new array each time,
we add a memory region into scribble buffer to record offset.

No functional change.

Signed-off-by: Yufen Yu <yuyufen@huawei.com>
---
 drivers/md/raid5.c | 50 ++++++++++++++++++++++++++++++++++++----------
 drivers/md/raid5.h |  1 +
 2 files changed, 40 insertions(+), 11 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index a095c7a4cd7c..445a73e1dd2a 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -477,6 +477,7 @@ static int grow_buffers(struct stripe_head *sh, gfp_t gfp)
 		}
 		sh->dev[i].page = page;
 		sh->dev[i].orig_page = page;
+		sh->dev[i].offset = 0;
 	}
 
 	return 0;
@@ -1130,7 +1131,7 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 				sh->dev[i].vec.bv_page = sh->dev[i].page;
 			bi->bi_vcnt = 1;
 			bi->bi_io_vec[0].bv_len = RAID5_STRIPE_SIZE(conf);
-			bi->bi_io_vec[0].bv_offset = 0;
+			bi->bi_io_vec[0].bv_offset = sh->dev[i].offset;
 			bi->bi_iter.bi_size = RAID5_STRIPE_SIZE(conf);
 			bi->bi_write_hint = sh->dev[i].write_hint;
 			if (!rrdev)
@@ -1184,7 +1185,7 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 			sh->dev[i].rvec.bv_page = sh->dev[i].page;
 			rbi->bi_vcnt = 1;
 			rbi->bi_io_vec[0].bv_len = RAID5_STRIPE_SIZE(conf);
-			rbi->bi_io_vec[0].bv_offset = 0;
+			rbi->bi_io_vec[0].bv_offset = sh->dev[i].offset;
 			rbi->bi_iter.bi_size = RAID5_STRIPE_SIZE(conf);
 			rbi->bi_write_hint = sh->dev[i].write_hint;
 			sh->dev[i].write_hint = RWH_WRITE_LIFE_NOT_SET;
@@ -1404,14 +1405,25 @@ static addr_conv_t *to_addr_conv(struct stripe_head *sh,
 	return (void *) (to_addr_page(percpu, i) + sh->disks + 2);
 }
 
+/*
+ * Return a pointer to record offset address.
+ */
+static unsigned int *
+to_addr_offs(struct stripe_head *sh, struct raid5_percpu *percpu)
+{
+	return (unsigned int *) (to_addr_conv(sh, percpu, 0) + sh->disks + 2);
+}
+
 static struct dma_async_tx_descriptor *
 ops_run_compute5(struct stripe_head *sh, struct raid5_percpu *percpu)
 {
 	int disks = sh->disks;
 	struct page **xor_srcs = to_addr_page(percpu, 0);
+	unsigned int *off_srcs = to_addr_offs(sh, percpu);
 	int target = sh->ops.target;
 	struct r5dev *tgt = &sh->dev[target];
 	struct page *xor_dest = tgt->page;
+	unsigned int off_dest = tgt->offset;
 	int count = 0;
 	struct dma_async_tx_descriptor *tx;
 	struct async_submit_ctl submit;
@@ -1423,16 +1435,19 @@ ops_run_compute5(struct stripe_head *sh, struct raid5_percpu *percpu)
 		__func__, (unsigned long long)sh->sector, target);
 	BUG_ON(!test_bit(R5_Wantcompute, &tgt->flags));
 
-	for (i = disks; i--; )
-		if (i != target)
+	for (i = disks; i--; ) {
+		if (i != target) {
+			off_srcs[count] = sh->dev[i].offset;
 			xor_srcs[count++] = sh->dev[i].page;
+		}
+	}
 
 	atomic_inc(&sh->count);
 
 	init_async_submit(&submit, ASYNC_TX_FENCE|ASYNC_TX_XOR_ZERO_DST, NULL,
 			  ops_complete_compute, sh, to_addr_conv(sh, percpu, 0));
 	if (unlikely(count == 1))
-		tx = async_memcpy(xor_dest, xor_srcs[0], 0, 0,
+		tx = async_memcpy(xor_dest, xor_srcs[0], off_dest, off_srcs[0],
 				RAID5_STRIPE_SIZE(sh->raid_conf), &submit);
 	else
 		tx = async_xor(xor_dest, xor_srcs, 0, count,
@@ -1854,9 +1869,11 @@ ops_run_reconstruct5(struct stripe_head *sh, struct raid5_percpu *percpu,
 {
 	int disks = sh->disks;
 	struct page **xor_srcs;
+	unsigned int *off_srcs;
 	struct async_submit_ctl submit;
 	int count, pd_idx = sh->pd_idx, i;
 	struct page *xor_dest;
+	unsigned int off_dest;
 	int prexor = 0;
 	unsigned long flags;
 	int j = 0;
@@ -1881,24 +1898,31 @@ ops_run_reconstruct5(struct stripe_head *sh, struct raid5_percpu *percpu,
 again:
 	count = 0;
 	xor_srcs = to_addr_page(percpu, j);
+	off_srcs = to_addr_offs(sh, percpu);
 	/* check if prexor is active which means only process blocks
 	 * that are part of a read-modify-write (written)
 	 */
 	if (head_sh->reconstruct_state == reconstruct_state_prexor_drain_run) {
 		prexor = 1;
+		off_dest = off_srcs[count] = sh->dev[pd_idx].offset;
 		xor_dest = xor_srcs[count++] = sh->dev[pd_idx].page;
 		for (i = disks; i--; ) {
 			struct r5dev *dev = &sh->dev[i];
 			if (head_sh->dev[i].written ||
-			    test_bit(R5_InJournal, &head_sh->dev[i].flags))
+			    test_bit(R5_InJournal, &head_sh->dev[i].flags)) {
+				off_srcs[count] = dev->offset;
 				xor_srcs[count++] = dev->page;
+			}
 		}
 	} else {
 		xor_dest = sh->dev[pd_idx].page;
+		off_dest = sh->dev[pd_idx].offset;
 		for (i = disks; i--; ) {
 			struct r5dev *dev = &sh->dev[i];
-			if (i != pd_idx)
+			if (i != pd_idx) {
+				off_srcs[count] = dev->offset;
 				xor_srcs[count++] = dev->page;
+			}
 		}
 	}
 
@@ -1924,7 +1948,7 @@ ops_run_reconstruct5(struct stripe_head *sh, struct raid5_percpu *percpu,
 	}
 
 	if (unlikely(count == 1))
-		tx = async_memcpy(xor_dest, xor_srcs[0], 0, 0,
+		tx = async_memcpy(xor_dest, xor_srcs[0], off_dest, off_srcs[0],
 				RAID5_STRIPE_SIZE(sh->raid_conf), &submit);
 	else
 		tx = async_xor(xor_dest, xor_srcs, 0, count,
@@ -2253,8 +2277,9 @@ static int scribble_alloc(struct raid5_percpu *percpu,
 			  int num, int cnt)
 {
 	size_t obj_size =
-		sizeof(struct page *) * (num+2) +
-		sizeof(addr_conv_t) * (num+2);
+		sizeof(struct page *) * (num + 2) +
+		sizeof(addr_conv_t) * (num + 2) +
+		sizeof(unsigned int) * (num + 2);
 	void *scribble;
 
 	/*
@@ -2389,6 +2414,7 @@ static int resize_stripes(struct r5conf *conf, int newsize)
 		for(i=0; i<conf->pool_size; i++) {
 			nsh->dev[i].page = osh->dev[i].page;
 			nsh->dev[i].orig_page = osh->dev[i].page;
+			nsh->dev[i].offset = osh->dev[i].offset;
 		}
 		nsh->hash_lock_index = hash;
 		free_stripe(conf->slab_cache, osh);
@@ -2444,6 +2470,7 @@ static int resize_stripes(struct r5conf *conf, int newsize)
 				struct page *p = alloc_page(GFP_NOIO);
 				nsh->dev[i].page = p;
 				nsh->dev[i].orig_page = p;
+				nsh->dev[i].offset = 0;
 				if (!p)
 					err = -ENOMEM;
 			}
@@ -4369,7 +4396,8 @@ static void handle_stripe_expansion(struct r5conf *conf, struct stripe_head *sh)
 			/* place all the copies on one channel */
 			init_async_submit(&submit, 0, tx, NULL, NULL, NULL);
 			tx = async_memcpy(sh2->dev[dd_idx].page,
-					  sh->dev[i].page, 0, 0, RAID5_STRIPE_SIZE(conf),
+					  sh->dev[i].page, sh2->dev[dd_idx].offset,
+					  sh->dev[i].offset, RAID5_STRIPE_SIZE(conf),
 					  &submit);
 
 			set_bit(R5_Expanded, &sh2->dev[dd_idx].flags);
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 16fc29472f5c..6afdd3a78580 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -253,6 +253,7 @@ struct stripe_head {
 		struct bio	req, rreq;
 		struct bio_vec	vec, rvec;
 		struct page	*page, *orig_page;
+		unsigned int    offset;     /* offset of the page */
 		struct bio	*toread, *read, *towrite, *written;
 		sector_t	sector;			/* sector of this page */
 		unsigned long	flags;
-- 
2.25.4

