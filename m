Return-Path: <SRS0=xKAG=B6=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3079FC433DF
	for <linux-raid@archiver.kernel.org>; Thu, 20 Aug 2020 13:22:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 096F0208DB
	for <linux-raid@archiver.kernel.org>; Thu, 20 Aug 2020 13:22:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728799AbgHTNWY (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 20 Aug 2020 09:22:24 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:10240 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728779AbgHTNWE (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 20 Aug 2020 09:22:04 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 82C88A64ED8665E03B3B;
        Thu, 20 Aug 2020 21:21:51 +0800 (CST)
Received: from huawei.com (10.175.101.6) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.487.0; Thu, 20 Aug 2020
 21:21:44 +0800
From:   Yufen Yu <yuyufen@huawei.com>
To:     <song@kernel.org>
CC:     <linux-raid@vger.kernel.org>, <houtao1@huawei.com>
Subject: [PATCH v2 06/10] md/raid6: let syndrome computor support different page offset
Date:   Thu, 20 Aug 2020 09:22:10 -0400
Message-ID: <20200820132214.3749139-7-yuyufen@huawei.com>
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

For now, syndrome compute functions require common offset in the pages
array. However, we expect them to support different offset when try to
use shared page in the following. Simplily covert them by adding page
offset where each page address are referred.

Since the only caller of async_gen_syndrome() and async_syndrome_val()
are in raid6, we don't want to reserve the old interface but modify the
interface directly. After that, replacing old interfaces with new ones
for raid6 and raid6test.

Signed-off-by: Yufen Yu <yuyufen@huawei.com>
---
 crypto/async_tx/async_pq.c  | 72 ++++++++++++++++++++++++-------------
 crypto/async_tx/raid6test.c | 24 ++++++++-----
 drivers/md/raid5.c          | 36 ++++++++++++-------
 include/linux/async_tx.h    |  6 ++--
 4 files changed, 91 insertions(+), 47 deletions(-)

diff --git a/crypto/async_tx/async_pq.c b/crypto/async_tx/async_pq.c
index 341ece61cf9b..f9cdc5e91664 100644
--- a/crypto/async_tx/async_pq.c
+++ b/crypto/async_tx/async_pq.c
@@ -104,7 +104,7 @@ do_async_gen_syndrome(struct dma_chan *chan,
  * do_sync_gen_syndrome - synchronously calculate a raid6 syndrome
  */
 static void
-do_sync_gen_syndrome(struct page **blocks, unsigned int offset, int disks,
+do_sync_gen_syndrome(struct page **blocks, unsigned int *offsets, int disks,
 		     size_t len, struct async_submit_ctl *submit)
 {
 	void **srcs;
@@ -121,7 +121,8 @@ do_sync_gen_syndrome(struct page **blocks, unsigned int offset, int disks,
 			BUG_ON(i > disks - 3); /* P or Q can't be zero */
 			srcs[i] = (void*)raid6_empty_zero_page;
 		} else {
-			srcs[i] = page_address(blocks[i]) + offset;
+			srcs[i] = page_address(blocks[i]) + offsets[i];
+
 			if (i < disks - 2) {
 				stop = i;
 				if (start == -1)
@@ -138,10 +139,23 @@ do_sync_gen_syndrome(struct page **blocks, unsigned int offset, int disks,
 	async_tx_sync_epilog(submit);
 }
 
+static inline bool
+is_dma_pq_aligned_offs(struct dma_device *dev, unsigned int *offs,
+				     int src_cnt, size_t len)
+{
+	int i;
+
+	for (i = 0; i < src_cnt; i++) {
+		if (!is_dma_pq_aligned(dev, offs[i], 0, len))
+			return false;
+	}
+	return true;
+}
+
 /**
  * async_gen_syndrome - asynchronously calculate a raid6 syndrome
  * @blocks: source blocks from idx 0..disks-3, P @ disks-2 and Q @ disks-1
- * @offset: common offset into each block (src and dest) to start transaction
+ * @offsets: offset array into each block (src and dest) to start transaction
  * @disks: number of blocks (including missing P or Q, see below)
  * @len: length of operation in bytes
  * @submit: submission/completion modifiers
@@ -160,7 +174,7 @@ do_sync_gen_syndrome(struct page **blocks, unsigned int offset, int disks,
  * path.
  */
 struct dma_async_tx_descriptor *
-async_gen_syndrome(struct page **blocks, unsigned int offset, int disks,
+async_gen_syndrome(struct page **blocks, unsigned int *offsets, int disks,
 		   size_t len, struct async_submit_ctl *submit)
 {
 	int src_cnt = disks - 2;
@@ -179,7 +193,7 @@ async_gen_syndrome(struct page **blocks, unsigned int offset, int disks,
 	if (unmap && !(submit->flags & ASYNC_TX_PQ_XOR_DST) &&
 	    (src_cnt <= dma_maxpq(device, 0) ||
 	     dma_maxpq(device, DMA_PREP_CONTINUE) > 0) &&
-	    is_dma_pq_aligned(device, offset, 0, len)) {
+	    is_dma_pq_aligned_offs(device, offsets, disks, len)) {
 		struct dma_async_tx_descriptor *tx;
 		enum dma_ctrl_flags dma_flags = 0;
 		unsigned char coefs[MAX_DISKS];
@@ -196,8 +210,8 @@ async_gen_syndrome(struct page **blocks, unsigned int offset, int disks,
 		for (i = 0, j = 0; i < src_cnt; i++) {
 			if (blocks[i] == NULL)
 				continue;
-			unmap->addr[j] = dma_map_page(device->dev, blocks[i], offset,
-						      len, DMA_TO_DEVICE);
+			unmap->addr[j] = dma_map_page(device->dev, blocks[i],
+						offsets[i], len, DMA_TO_DEVICE);
 			coefs[j] = raid6_gfexp[i];
 			unmap->to_cnt++;
 			j++;
@@ -210,7 +224,8 @@ async_gen_syndrome(struct page **blocks, unsigned int offset, int disks,
 		unmap->bidi_cnt++;
 		if (P(blocks, disks))
 			unmap->addr[j++] = dma_map_page(device->dev, P(blocks, disks),
-							offset, len, DMA_BIDIRECTIONAL);
+							P(offsets, disks),
+							len, DMA_BIDIRECTIONAL);
 		else {
 			unmap->addr[j++] = 0;
 			dma_flags |= DMA_PREP_PQ_DISABLE_P;
@@ -219,7 +234,8 @@ async_gen_syndrome(struct page **blocks, unsigned int offset, int disks,
 		unmap->bidi_cnt++;
 		if (Q(blocks, disks))
 			unmap->addr[j++] = dma_map_page(device->dev, Q(blocks, disks),
-						       offset, len, DMA_BIDIRECTIONAL);
+							Q(offsets, disks),
+							len, DMA_BIDIRECTIONAL);
 		else {
 			unmap->addr[j++] = 0;
 			dma_flags |= DMA_PREP_PQ_DISABLE_Q;
@@ -240,13 +256,13 @@ async_gen_syndrome(struct page **blocks, unsigned int offset, int disks,
 
 	if (!P(blocks, disks)) {
 		P(blocks, disks) = pq_scribble_page;
-		BUG_ON(len + offset > PAGE_SIZE);
+		P(offsets, disks) = 0;
 	}
 	if (!Q(blocks, disks)) {
 		Q(blocks, disks) = pq_scribble_page;
-		BUG_ON(len + offset > PAGE_SIZE);
+		Q(offsets, disks) = 0;
 	}
-	do_sync_gen_syndrome(blocks, offset, disks, len, submit);
+	do_sync_gen_syndrome(blocks, offsets, disks, len, submit);
 
 	return NULL;
 }
@@ -270,6 +286,7 @@ pq_val_chan(struct async_submit_ctl *submit, struct page **blocks, int disks, si
  * @len: length of operation in bytes
  * @pqres: on val failure SUM_CHECK_P_RESULT and/or SUM_CHECK_Q_RESULT are set
  * @spare: temporary result buffer for the synchronous case
+ * @s_off: spare buffer page offset
  * @submit: submission / completion modifiers
  *
  * The same notes from async_gen_syndrome apply to the 'blocks',
@@ -278,9 +295,9 @@ pq_val_chan(struct async_submit_ctl *submit, struct page **blocks, int disks, si
  * specified.
  */
 struct dma_async_tx_descriptor *
-async_syndrome_val(struct page **blocks, unsigned int offset, int disks,
+async_syndrome_val(struct page **blocks, unsigned int *offsets, int disks,
 		   size_t len, enum sum_check_flags *pqres, struct page *spare,
-		   struct async_submit_ctl *submit)
+		   unsigned int s_off, struct async_submit_ctl *submit)
 {
 	struct dma_chan *chan = pq_val_chan(submit, blocks, disks, len);
 	struct dma_device *device = chan ? chan->device : NULL;
@@ -295,7 +312,7 @@ async_syndrome_val(struct page **blocks, unsigned int offset, int disks,
 		unmap = dmaengine_get_unmap_data(device->dev, disks, GFP_NOWAIT);
 
 	if (unmap && disks <= dma_maxpq(device, 0) &&
-	    is_dma_pq_aligned(device, offset, 0, len)) {
+	    is_dma_pq_aligned_offs(device, offsets, disks, len)) {
 		struct device *dev = device->dev;
 		dma_addr_t pq[2];
 		int i, j = 0, src_cnt = 0;
@@ -307,7 +324,7 @@ async_syndrome_val(struct page **blocks, unsigned int offset, int disks,
 		for (i = 0; i < disks-2; i++)
 			if (likely(blocks[i])) {
 				unmap->addr[j] = dma_map_page(dev, blocks[i],
-							      offset, len,
+							      offsets[i], len,
 							      DMA_TO_DEVICE);
 				coefs[j] = raid6_gfexp[i];
 				unmap->to_cnt++;
@@ -320,7 +337,7 @@ async_syndrome_val(struct page **blocks, unsigned int offset, int disks,
 			dma_flags |= DMA_PREP_PQ_DISABLE_P;
 		} else {
 			pq[0] = dma_map_page(dev, P(blocks, disks),
-					     offset, len,
+					     P(offsets, disks), len,
 					     DMA_TO_DEVICE);
 			unmap->addr[j++] = pq[0];
 			unmap->to_cnt++;
@@ -330,7 +347,7 @@ async_syndrome_val(struct page **blocks, unsigned int offset, int disks,
 			dma_flags |= DMA_PREP_PQ_DISABLE_Q;
 		} else {
 			pq[1] = dma_map_page(dev, Q(blocks, disks),
-					     offset, len,
+					     Q(offsets, disks), len,
 					     DMA_TO_DEVICE);
 			unmap->addr[j++] = pq[1];
 			unmap->to_cnt++;
@@ -355,7 +372,9 @@ async_syndrome_val(struct page **blocks, unsigned int offset, int disks,
 		async_tx_submit(chan, tx, submit);
 	} else {
 		struct page *p_src = P(blocks, disks);
+		unsigned int p_off = P(offsets, disks);
 		struct page *q_src = Q(blocks, disks);
+		unsigned int q_off = Q(offsets, disks);
 		enum async_tx_flags flags_orig = submit->flags;
 		dma_async_tx_callback cb_fn_orig = submit->cb_fn;
 		void *scribble = submit->scribble;
@@ -381,27 +400,32 @@ async_syndrome_val(struct page **blocks, unsigned int offset, int disks,
 		if (p_src) {
 			init_async_submit(submit, ASYNC_TX_XOR_ZERO_DST, NULL,
 					  NULL, NULL, scribble);
-			tx = async_xor(spare, blocks, offset, disks-2, len, submit);
+			tx = async_xor_offs(spare, s_off,
+					blocks, offsets, disks-2, len, submit);
 			async_tx_quiesce(&tx);
-			p = page_address(p_src) + offset;
-			s = page_address(spare) + offset;
+			p = page_address(p_src) + p_off;
+			s = page_address(spare) + s_off;
 			*pqres |= !!memcmp(p, s, len) << SUM_CHECK_P;
 		}
 
 		if (q_src) {
 			P(blocks, disks) = NULL;
 			Q(blocks, disks) = spare;
+			Q(offsets, disks) = s_off;
 			init_async_submit(submit, 0, NULL, NULL, NULL, scribble);
-			tx = async_gen_syndrome(blocks, offset, disks, len, submit);
+			tx = async_gen_syndrome(blocks, offsets, disks,
+					len, submit);
 			async_tx_quiesce(&tx);
-			q = page_address(q_src) + offset;
-			s = page_address(spare) + offset;
+			q = page_address(q_src) + q_off;
+			s = page_address(spare) + s_off;
 			*pqres |= !!memcmp(q, s, len) << SUM_CHECK_Q;
 		}
 
 		/* restore P, Q and submit */
 		P(blocks, disks) = p_src;
+		P(offsets, disks) = p_off;
 		Q(blocks, disks) = q_src;
+		Q(offsets, disks) = q_off;
 
 		submit->cb_fn = cb_fn_orig;
 		submit->cb_param = cb_param_orig;
diff --git a/crypto/async_tx/raid6test.c b/crypto/async_tx/raid6test.c
index 14e73dcd7475..ef4e6e68f759 100644
--- a/crypto/async_tx/raid6test.c
+++ b/crypto/async_tx/raid6test.c
@@ -18,6 +18,7 @@
 #define NDISKS 64 /* Including P and Q */
 
 static struct page *dataptrs[NDISKS];
+unsigned int dataoffs[NDISKS];
 static addr_conv_t addr_conv[NDISKS];
 static struct page *data[NDISKS+3];
 static struct page *spare;
@@ -38,6 +39,7 @@ static void makedata(int disks)
 	for (i = 0; i < disks; i++) {
 		prandom_bytes(page_address(data[i]), PAGE_SIZE);
 		dataptrs[i] = data[i];
+		dataoffs[i] = 0;
 	}
 }
 
@@ -52,7 +54,8 @@ static char disk_type(int d, int disks)
 }
 
 /* Recover two failed blocks. */
-static void raid6_dual_recov(int disks, size_t bytes, int faila, int failb, struct page **ptrs)
+static void raid6_dual_recov(int disks, size_t bytes, int faila, int failb,
+		struct page **ptrs, unsigned int *offs)
 {
 	struct async_submit_ctl submit;
 	struct completion cmp;
@@ -66,7 +69,8 @@ static void raid6_dual_recov(int disks, size_t bytes, int faila, int failb, stru
 		if (faila == disks-2) {
 			/* P+Q failure.  Just rebuild the syndrome. */
 			init_async_submit(&submit, 0, NULL, NULL, NULL, addr_conv);
-			tx = async_gen_syndrome(ptrs, 0, disks, bytes, &submit);
+			tx = async_gen_syndrome(ptrs, offs,
+					disks, bytes, &submit);
 		} else {
 			struct page *blocks[NDISKS];
 			struct page *dest;
@@ -89,22 +93,26 @@ static void raid6_dual_recov(int disks, size_t bytes, int faila, int failb, stru
 			tx = async_xor(dest, blocks, 0, count, bytes, &submit);
 
 			init_async_submit(&submit, 0, tx, NULL, NULL, addr_conv);
-			tx = async_gen_syndrome(ptrs, 0, disks, bytes, &submit);
+			tx = async_gen_syndrome(ptrs, offs,
+					disks, bytes, &submit);
 		}
 	} else {
 		if (failb == disks-2) {
 			/* data+P failure. */
 			init_async_submit(&submit, 0, NULL, NULL, NULL, addr_conv);
-			tx = async_raid6_datap_recov(disks, bytes, faila, ptrs, &submit);
+			tx = async_raid6_datap_recov(disks, bytes,
+					faila, ptrs, &submit);
 		} else {
 			/* data+data failure. */
 			init_async_submit(&submit, 0, NULL, NULL, NULL, addr_conv);
-			tx = async_raid6_2data_recov(disks, bytes, faila, failb, ptrs, &submit);
+			tx = async_raid6_2data_recov(disks, bytes,
+					faila, failb, ptrs, &submit);
 		}
 	}
 	init_completion(&cmp);
 	init_async_submit(&submit, ASYNC_TX_ACK, tx, callback, &cmp, addr_conv);
-	tx = async_syndrome_val(ptrs, 0, disks, bytes, &result, spare, &submit);
+	tx = async_syndrome_val(ptrs, offs,
+			disks, bytes, &result, spare, 0, &submit);
 	async_tx_issue_pending(tx);
 
 	if (wait_for_completion_timeout(&cmp, msecs_to_jiffies(3000)) == 0)
@@ -126,7 +134,7 @@ static int test_disks(int i, int j, int disks)
 	dataptrs[i] = recovi;
 	dataptrs[j] = recovj;
 
-	raid6_dual_recov(disks, PAGE_SIZE, i, j, dataptrs);
+	raid6_dual_recov(disks, PAGE_SIZE, i, j, dataptrs, dataoffs);
 
 	erra = memcmp(page_address(data[i]), page_address(recovi), PAGE_SIZE);
 	errb = memcmp(page_address(data[j]), page_address(recovj), PAGE_SIZE);
@@ -162,7 +170,7 @@ static int test(int disks, int *tests)
 	/* Generate assumed good syndrome */
 	init_completion(&cmp);
 	init_async_submit(&submit, ASYNC_TX_ACK, NULL, callback, &cmp, addr_conv);
-	tx = async_gen_syndrome(dataptrs, 0, disks, PAGE_SIZE, &submit);
+	tx = async_gen_syndrome(dataptrs, dataoffs, disks, PAGE_SIZE, &submit);
 	async_tx_issue_pending(tx);
 
 	if (wait_for_completion_timeout(&cmp, msecs_to_jiffies(3000)) == 0) {
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index a37ff68db6af..c0f9394891fe 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1459,6 +1459,7 @@ ops_run_compute5(struct stripe_head *sh, struct raid5_percpu *percpu)
 
 /* set_syndrome_sources - populate source buffers for gen_syndrome
  * @srcs - (struct page *) array of size sh->disks
+ * @offs - (unsigned int) array of offset for each page
  * @sh - stripe_head to parse
  *
  * Populates srcs in proper layout order for the stripe and returns the
@@ -1467,6 +1468,7 @@ ops_run_compute5(struct stripe_head *sh, struct raid5_percpu *percpu)
  * is recorded in srcs[count+1]].
  */
 static int set_syndrome_sources(struct page **srcs,
+				unsigned int *offs,
 				struct stripe_head *sh,
 				int srctype)
 {
@@ -1497,6 +1499,12 @@ static int set_syndrome_sources(struct page **srcs,
 				srcs[slot] = sh->dev[i].orig_page;
 			else
 				srcs[slot] = sh->dev[i].page;
+			/*
+			 * For R5_InJournal, PAGE_SIZE must be 4KB and will
+			 * not shared page. In that case, dev[i].offset
+			 * is 0.
+			 */
+			offs[slot] = sh->dev[i].offset;
 		}
 		i = raid6_next_disk(i, disks);
 	} while (i != d0_idx);
@@ -1540,13 +1548,13 @@ ops_run_compute6_1(struct stripe_head *sh, struct raid5_percpu *percpu)
 	atomic_inc(&sh->count);
 
 	if (target == qd_idx) {
-		count = set_syndrome_sources(blocks, sh, SYNDROME_SRC_ALL);
+		count = set_syndrome_sources(blocks, offs, sh, SYNDROME_SRC_ALL);
 		blocks[count] = NULL; /* regenerating p is not necessary */
 		BUG_ON(blocks[count+1] != dest); /* q should already be set */
 		init_async_submit(&submit, ASYNC_TX_FENCE, NULL,
 				  ops_complete_compute, sh,
 				  to_addr_conv(sh, percpu, 0));
-		tx = async_gen_syndrome(blocks, 0, count+2,
+		tx = async_gen_syndrome(blocks, offs, count+2,
 				RAID5_STRIPE_SIZE(sh->raid_conf), &submit);
 	} else {
 		/* Compute any data- or p-drive using XOR */
@@ -1628,7 +1636,7 @@ ops_run_compute6_2(struct stripe_head *sh, struct raid5_percpu *percpu)
 			init_async_submit(&submit, ASYNC_TX_FENCE, NULL,
 					  ops_complete_compute, sh,
 					  to_addr_conv(sh, percpu, 0));
-			return async_gen_syndrome(blocks, 0, syndrome_disks+2,
+			return async_gen_syndrome(blocks, offs, syndrome_disks+2,
 						  RAID5_STRIPE_SIZE(sh->raid_conf),
 						  &submit);
 		} else {
@@ -1660,11 +1668,11 @@ ops_run_compute6_2(struct stripe_head *sh, struct raid5_percpu *percpu)
 				       RAID5_STRIPE_SIZE(sh->raid_conf),
 				       &submit);
 
-			count = set_syndrome_sources(blocks, sh, SYNDROME_SRC_ALL);
+			count = set_syndrome_sources(blocks, offs, sh, SYNDROME_SRC_ALL);
 			init_async_submit(&submit, ASYNC_TX_FENCE, tx,
 					  ops_complete_compute, sh,
 					  to_addr_conv(sh, percpu, 0));
-			return async_gen_syndrome(blocks, 0, count+2,
+			return async_gen_syndrome(blocks, offs, count+2,
 						  RAID5_STRIPE_SIZE(sh->raid_conf),
 						  &submit);
 		}
@@ -1750,17 +1758,18 @@ ops_run_prexor6(struct stripe_head *sh, struct raid5_percpu *percpu,
 		struct dma_async_tx_descriptor *tx)
 {
 	struct page **blocks = to_addr_page(percpu, 0);
+	unsigned int *offs = to_addr_offs(sh, percpu);
 	int count;
 	struct async_submit_ctl submit;
 
 	pr_debug("%s: stripe %llu\n", __func__,
 		(unsigned long long)sh->sector);
 
-	count = set_syndrome_sources(blocks, sh, SYNDROME_SRC_WANT_DRAIN);
+	count = set_syndrome_sources(blocks, offs, sh, SYNDROME_SRC_WANT_DRAIN);
 
 	init_async_submit(&submit, ASYNC_TX_FENCE|ASYNC_TX_PQ_XOR_DST, tx,
 			  ops_complete_prexor, sh, to_addr_conv(sh, percpu, 0));
-	tx = async_gen_syndrome(blocks, 0, count+2,
+	tx = async_gen_syndrome(blocks, offs, count+2,
 			RAID5_STRIPE_SIZE(sh->raid_conf), &submit);
 
 	return tx;
@@ -1989,6 +1998,7 @@ ops_run_reconstruct6(struct stripe_head *sh, struct raid5_percpu *percpu,
 {
 	struct async_submit_ctl submit;
 	struct page **blocks;
+	unsigned int *offs;
 	int count, i, j = 0;
 	struct stripe_head *head_sh = sh;
 	int last_stripe;
@@ -2013,6 +2023,7 @@ ops_run_reconstruct6(struct stripe_head *sh, struct raid5_percpu *percpu,
 
 again:
 	blocks = to_addr_page(percpu, j);
+	offs = to_addr_offs(sh, percpu);
 
 	if (sh->reconstruct_state == reconstruct_state_prexor_drain_run) {
 		synflags = SYNDROME_SRC_WRITTEN;
@@ -2022,7 +2033,7 @@ ops_run_reconstruct6(struct stripe_head *sh, struct raid5_percpu *percpu,
 		txflags = ASYNC_TX_ACK;
 	}
 
-	count = set_syndrome_sources(blocks, sh, synflags);
+	count = set_syndrome_sources(blocks, offs, sh, synflags);
 	last_stripe = !head_sh->batch_head ||
 		list_first_entry(&sh->batch_list,
 				 struct stripe_head, batch_list) == head_sh;
@@ -2034,7 +2045,7 @@ ops_run_reconstruct6(struct stripe_head *sh, struct raid5_percpu *percpu,
 	} else
 		init_async_submit(&submit, 0, tx, NULL, NULL,
 				  to_addr_conv(sh, percpu, j));
-	tx = async_gen_syndrome(blocks, 0, count+2,
+	tx = async_gen_syndrome(blocks, offs, count+2,
 			RAID5_STRIPE_SIZE(sh->raid_conf),  &submit);
 	if (!last_stripe) {
 		j++;
@@ -2100,6 +2111,7 @@ static void ops_run_check_p(struct stripe_head *sh, struct raid5_percpu *percpu)
 static void ops_run_check_pq(struct stripe_head *sh, struct raid5_percpu *percpu, int checkp)
 {
 	struct page **srcs = to_addr_page(percpu, 0);
+	unsigned int *offs = to_addr_offs(sh, percpu);
 	struct async_submit_ctl submit;
 	int count;
 
@@ -2107,16 +2119,16 @@ static void ops_run_check_pq(struct stripe_head *sh, struct raid5_percpu *percpu
 		(unsigned long long)sh->sector, checkp);
 
 	BUG_ON(sh->batch_head);
-	count = set_syndrome_sources(srcs, sh, SYNDROME_SRC_ALL);
+	count = set_syndrome_sources(srcs, offs, sh, SYNDROME_SRC_ALL);
 	if (!checkp)
 		srcs[count] = NULL;
 
 	atomic_inc(&sh->count);
 	init_async_submit(&submit, ASYNC_TX_ACK, NULL, ops_complete_check,
 			  sh, to_addr_conv(sh, percpu, 0));
-	async_syndrome_val(srcs, 0, count+2,
+	async_syndrome_val(srcs, offs, count+2,
 			   RAID5_STRIPE_SIZE(sh->raid_conf),
-			   &sh->ops.zero_sum_result, percpu->spare_page, &submit);
+			   &sh->ops.zero_sum_result, percpu->spare_page, 0, &submit);
 }
 
 static void raid_run_ops(struct stripe_head *sh, unsigned long ops_request)
diff --git a/include/linux/async_tx.h b/include/linux/async_tx.h
index 8901f3c801ee..efc5510f7d11 100644
--- a/include/linux/async_tx.h
+++ b/include/linux/async_tx.h
@@ -186,13 +186,13 @@ async_memcpy(struct page *dest, struct page *src, unsigned int dest_offset,
 struct dma_async_tx_descriptor *async_trigger_callback(struct async_submit_ctl *submit);
 
 struct dma_async_tx_descriptor *
-async_gen_syndrome(struct page **blocks, unsigned int offset, int src_cnt,
+async_gen_syndrome(struct page **blocks, unsigned int *offsets, int src_cnt,
 		   size_t len, struct async_submit_ctl *submit);
 
 struct dma_async_tx_descriptor *
-async_syndrome_val(struct page **blocks, unsigned int offset, int src_cnt,
+async_syndrome_val(struct page **blocks, unsigned int *offsets, int src_cnt,
 		   size_t len, enum sum_check_flags *pqres, struct page *spare,
-		   struct async_submit_ctl *submit);
+		   unsigned int s_off, struct async_submit_ctl *submit);
 
 struct dma_async_tx_descriptor *
 async_raid6_2data_recov(int src_num, size_t bytes, int faila, int failb,
-- 
2.25.4

