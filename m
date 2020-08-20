Return-Path: <SRS0=xKAG=B6=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E575C433DF
	for <linux-raid@archiver.kernel.org>; Thu, 20 Aug 2020 13:22:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 70BDB22B40
	for <linux-raid@archiver.kernel.org>; Thu, 20 Aug 2020 13:22:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729514AbgHTNWb (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 20 Aug 2020 09:22:31 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:10236 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728489AbgHTNWE (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 20 Aug 2020 09:22:04 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 6D44095DDC11C23BFA24;
        Thu, 20 Aug 2020 21:21:51 +0800 (CST)
Received: from huawei.com (10.175.101.6) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.487.0; Thu, 20 Aug 2020
 21:21:44 +0800
From:   Yufen Yu <yuyufen@huawei.com>
To:     <song@kernel.org>
CC:     <linux-raid@vger.kernel.org>, <houtao1@huawei.com>
Subject: [PATCH v2 07/10] md/raid6: let async recovery function support different page offset
Date:   Thu, 20 Aug 2020 09:22:11 -0400
Message-ID: <20200820132214.3749139-8-yuyufen@huawei.com>
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

For now, asynchronous raid6 recovery calculate functions are require
common offset for pages. But, we expect them to support different page
offset after introducing stripe shared page. Do that by simplily adding
page offset where each page address are referred. Then, replace the
old interface with the new ones in raid6 and raid6test.

Signed-off-by: Yufen Yu <yuyufen@huawei.com>
---
 crypto/async_tx/async_raid6_recov.c | 163 ++++++++++++++++++++--------
 crypto/async_tx/raid6test.c         |   4 +-
 drivers/md/raid5.c                  |   4 +-
 include/linux/async_tx.h            |   6 +-
 4 files changed, 128 insertions(+), 49 deletions(-)

diff --git a/crypto/async_tx/async_raid6_recov.c b/crypto/async_tx/async_raid6_recov.c
index f249142ceac4..354b8cd5537f 100644
--- a/crypto/async_tx/async_raid6_recov.c
+++ b/crypto/async_tx/async_raid6_recov.c
@@ -15,8 +15,9 @@
 #include <linux/dmaengine.h>
 
 static struct dma_async_tx_descriptor *
-async_sum_product(struct page *dest, struct page **srcs, unsigned char *coef,
-		  size_t len, struct async_submit_ctl *submit)
+async_sum_product(struct page *dest, unsigned int d_off,
+		struct page **srcs, unsigned int *src_offs, unsigned char *coef,
+		size_t len, struct async_submit_ctl *submit)
 {
 	struct dma_chan *chan = async_tx_find_channel(submit, DMA_PQ,
 						      &dest, 1, srcs, 2, len);
@@ -37,11 +38,14 @@ async_sum_product(struct page *dest, struct page **srcs, unsigned char *coef,
 
 		if (submit->flags & ASYNC_TX_FENCE)
 			dma_flags |= DMA_PREP_FENCE;
-		unmap->addr[0] = dma_map_page(dev, srcs[0], 0, len, DMA_TO_DEVICE);
-		unmap->addr[1] = dma_map_page(dev, srcs[1], 0, len, DMA_TO_DEVICE);
+		unmap->addr[0] = dma_map_page(dev, srcs[0], src_offs[0],
+						len, DMA_TO_DEVICE);
+		unmap->addr[1] = dma_map_page(dev, srcs[1], src_offs[1],
+						len, DMA_TO_DEVICE);
 		unmap->to_cnt = 2;
 
-		unmap->addr[2] = dma_map_page(dev, dest, 0, len, DMA_BIDIRECTIONAL);
+		unmap->addr[2] = dma_map_page(dev, dest, d_off,
+						len, DMA_BIDIRECTIONAL);
 		unmap->bidi_cnt = 1;
 		/* engine only looks at Q, but expects it to follow P */
 		pq[1] = unmap->addr[2];
@@ -66,9 +70,9 @@ async_sum_product(struct page *dest, struct page **srcs, unsigned char *coef,
 	async_tx_quiesce(&submit->depend_tx);
 	amul = raid6_gfmul[coef[0]];
 	bmul = raid6_gfmul[coef[1]];
-	a = page_address(srcs[0]);
-	b = page_address(srcs[1]);
-	c = page_address(dest);
+	a = page_address(srcs[0]) + src_offs[0];
+	b = page_address(srcs[1]) + src_offs[1];
+	c = page_address(dest) + d_off;
 
 	while (len--) {
 		ax    = amul[*a++];
@@ -80,8 +84,9 @@ async_sum_product(struct page *dest, struct page **srcs, unsigned char *coef,
 }
 
 static struct dma_async_tx_descriptor *
-async_mult(struct page *dest, struct page *src, u8 coef, size_t len,
-	   struct async_submit_ctl *submit)
+async_mult(struct page *dest, unsigned int d_off, struct page *src,
+		unsigned int s_off, u8 coef, size_t len,
+		struct async_submit_ctl *submit)
 {
 	struct dma_chan *chan = async_tx_find_channel(submit, DMA_PQ,
 						      &dest, 1, &src, 1, len);
@@ -101,9 +106,11 @@ async_mult(struct page *dest, struct page *src, u8 coef, size_t len,
 
 		if (submit->flags & ASYNC_TX_FENCE)
 			dma_flags |= DMA_PREP_FENCE;
-		unmap->addr[0] = dma_map_page(dev, src, 0, len, DMA_TO_DEVICE);
+		unmap->addr[0] = dma_map_page(dev, src, s_off,
+						len, DMA_TO_DEVICE);
 		unmap->to_cnt++;
-		unmap->addr[1] = dma_map_page(dev, dest, 0, len, DMA_BIDIRECTIONAL);
+		unmap->addr[1] = dma_map_page(dev, dest, d_off,
+						len, DMA_BIDIRECTIONAL);
 		dma_dest[1] = unmap->addr[1];
 		unmap->bidi_cnt++;
 		unmap->len = len;
@@ -133,8 +140,8 @@ async_mult(struct page *dest, struct page *src, u8 coef, size_t len,
 	 */
 	async_tx_quiesce(&submit->depend_tx);
 	qmul  = raid6_gfmul[coef];
-	d = page_address(dest);
-	s = page_address(src);
+	d = page_address(dest) + d_off;
+	s = page_address(src) + s_off;
 
 	while (len--)
 		*d++ = qmul[*s++];
@@ -144,11 +151,14 @@ async_mult(struct page *dest, struct page *src, u8 coef, size_t len,
 
 static struct dma_async_tx_descriptor *
 __2data_recov_4(int disks, size_t bytes, int faila, int failb,
-		struct page **blocks, struct async_submit_ctl *submit)
+		struct page **blocks, unsigned int *offs,
+		struct async_submit_ctl *submit)
 {
 	struct dma_async_tx_descriptor *tx = NULL;
 	struct page *p, *q, *a, *b;
+	unsigned int p_off, q_off, a_off, b_off;
 	struct page *srcs[2];
+	unsigned int src_offs[2];
 	unsigned char coef[2];
 	enum async_tx_flags flags = submit->flags;
 	dma_async_tx_callback cb_fn = submit->cb_fn;
@@ -156,26 +166,34 @@ __2data_recov_4(int disks, size_t bytes, int faila, int failb,
 	void *scribble = submit->scribble;
 
 	p = blocks[disks-2];
+	p_off = offs[disks-2];
 	q = blocks[disks-1];
+	q_off = offs[disks-1];
 
 	a = blocks[faila];
+	a_off = offs[faila];
 	b = blocks[failb];
+	b_off = offs[failb];
 
 	/* in the 4 disk case P + Pxy == P and Q + Qxy == Q */
 	/* Dx = A*(P+Pxy) + B*(Q+Qxy) */
 	srcs[0] = p;
+	src_offs[0] = p_off;
 	srcs[1] = q;
+	src_offs[1] = q_off;
 	coef[0] = raid6_gfexi[failb-faila];
 	coef[1] = raid6_gfinv[raid6_gfexp[faila]^raid6_gfexp[failb]];
 	init_async_submit(submit, ASYNC_TX_FENCE, tx, NULL, NULL, scribble);
-	tx = async_sum_product(b, srcs, coef, bytes, submit);
+	tx = async_sum_product(b, b_off, srcs, src_offs, coef, bytes, submit);
 
 	/* Dy = P+Pxy+Dx */
 	srcs[0] = p;
+	src_offs[0] = p_off;
 	srcs[1] = b;
+	src_offs[1] = b_off;
 	init_async_submit(submit, flags | ASYNC_TX_XOR_ZERO_DST, tx, cb_fn,
 			  cb_param, scribble);
-	tx = async_xor(a, srcs, 0, 2, bytes, submit);
+	tx = async_xor_offs(a, a_off, srcs, src_offs, 2, bytes, submit);
 
 	return tx;
 
@@ -183,11 +201,14 @@ __2data_recov_4(int disks, size_t bytes, int faila, int failb,
 
 static struct dma_async_tx_descriptor *
 __2data_recov_5(int disks, size_t bytes, int faila, int failb,
-		struct page **blocks, struct async_submit_ctl *submit)
+		struct page **blocks, unsigned int *offs,
+		struct async_submit_ctl *submit)
 {
 	struct dma_async_tx_descriptor *tx = NULL;
 	struct page *p, *q, *g, *dp, *dq;
+	unsigned int p_off, q_off, g_off, dp_off, dq_off;
 	struct page *srcs[2];
+	unsigned int src_offs[2];
 	unsigned char coef[2];
 	enum async_tx_flags flags = submit->flags;
 	dma_async_tx_callback cb_fn = submit->cb_fn;
@@ -208,60 +229,77 @@ __2data_recov_5(int disks, size_t bytes, int faila, int failb,
 	BUG_ON(good_srcs > 1);
 
 	p = blocks[disks-2];
+	p_off = offs[disks-2];
 	q = blocks[disks-1];
+	q_off = offs[disks-1];
 	g = blocks[good];
+	g_off = offs[good];
 
 	/* Compute syndrome with zero for the missing data pages
 	 * Use the dead data pages as temporary storage for delta p and
 	 * delta q
 	 */
 	dp = blocks[faila];
+	dp_off = offs[faila];
 	dq = blocks[failb];
+	dq_off = offs[failb];
 
 	init_async_submit(submit, ASYNC_TX_FENCE, tx, NULL, NULL, scribble);
-	tx = async_memcpy(dp, g, 0, 0, bytes, submit);
+	tx = async_memcpy(dp, g, dp_off, g_off, bytes, submit);
 	init_async_submit(submit, ASYNC_TX_FENCE, tx, NULL, NULL, scribble);
-	tx = async_mult(dq, g, raid6_gfexp[good], bytes, submit);
+	tx = async_mult(dq, dq_off, g, g_off,
+			raid6_gfexp[good], bytes, submit);
 
 	/* compute P + Pxy */
 	srcs[0] = dp;
+	src_offs[0] = dp_off;
 	srcs[1] = p;
+	src_offs[1] = p_off;
 	init_async_submit(submit, ASYNC_TX_FENCE|ASYNC_TX_XOR_DROP_DST, tx,
 			  NULL, NULL, scribble);
-	tx = async_xor(dp, srcs, 0, 2, bytes, submit);
+	tx = async_xor_offs(dp, dp_off, srcs, src_offs, 2, bytes, submit);
 
 	/* compute Q + Qxy */
 	srcs[0] = dq;
+	src_offs[0] = dq_off;
 	srcs[1] = q;
+	src_offs[1] = q_off;
 	init_async_submit(submit, ASYNC_TX_FENCE|ASYNC_TX_XOR_DROP_DST, tx,
 			  NULL, NULL, scribble);
-	tx = async_xor(dq, srcs, 0, 2, bytes, submit);
+	tx = async_xor_offs(dq, dq_off, srcs, src_offs, 2, bytes, submit);
 
 	/* Dx = A*(P+Pxy) + B*(Q+Qxy) */
 	srcs[0] = dp;
+	src_offs[0] = dp_off;
 	srcs[1] = dq;
+	src_offs[1] = dq_off;
 	coef[0] = raid6_gfexi[failb-faila];
 	coef[1] = raid6_gfinv[raid6_gfexp[faila]^raid6_gfexp[failb]];
 	init_async_submit(submit, ASYNC_TX_FENCE, tx, NULL, NULL, scribble);
-	tx = async_sum_product(dq, srcs, coef, bytes, submit);
+	tx = async_sum_product(dq, dq_off, srcs, src_offs, coef, bytes, submit);
 
 	/* Dy = P+Pxy+Dx */
 	srcs[0] = dp;
+	src_offs[0] = dp_off;
 	srcs[1] = dq;
+	src_offs[1] = dq_off;
 	init_async_submit(submit, flags | ASYNC_TX_XOR_DROP_DST, tx, cb_fn,
 			  cb_param, scribble);
-	tx = async_xor(dp, srcs, 0, 2, bytes, submit);
+	tx = async_xor_offs(dp, dp_off, srcs, src_offs, 2, bytes, submit);
 
 	return tx;
 }
 
 static struct dma_async_tx_descriptor *
 __2data_recov_n(int disks, size_t bytes, int faila, int failb,
-	      struct page **blocks, struct async_submit_ctl *submit)
+	      struct page **blocks, unsigned int *offs,
+		  struct async_submit_ctl *submit)
 {
 	struct dma_async_tx_descriptor *tx = NULL;
 	struct page *p, *q, *dp, *dq;
+	unsigned int p_off, q_off, dp_off, dq_off;
 	struct page *srcs[2];
+	unsigned int src_offs[2];
 	unsigned char coef[2];
 	enum async_tx_flags flags = submit->flags;
 	dma_async_tx_callback cb_fn = submit->cb_fn;
@@ -269,56 +307,74 @@ __2data_recov_n(int disks, size_t bytes, int faila, int failb,
 	void *scribble = submit->scribble;
 
 	p = blocks[disks-2];
+	p_off = offs[disks-2];
 	q = blocks[disks-1];
+	q_off = offs[disks-1];
 
 	/* Compute syndrome with zero for the missing data pages
 	 * Use the dead data pages as temporary storage for
 	 * delta p and delta q
 	 */
 	dp = blocks[faila];
+	dp_off = offs[faila];
 	blocks[faila] = NULL;
 	blocks[disks-2] = dp;
+	offs[disks-2] = dp_off;
 	dq = blocks[failb];
+	dq_off = offs[failb];
 	blocks[failb] = NULL;
 	blocks[disks-1] = dq;
+	offs[disks-1] = dq_off;
 
 	init_async_submit(submit, ASYNC_TX_FENCE, tx, NULL, NULL, scribble);
-	tx = async_gen_syndrome(blocks, 0, disks, bytes, submit);
+	tx = async_gen_syndrome(blocks, offs, disks, bytes, submit);
 
 	/* Restore pointer table */
 	blocks[faila]   = dp;
+	offs[faila] = dp_off;
 	blocks[failb]   = dq;
+	offs[failb] = dq_off;
 	blocks[disks-2] = p;
+	offs[disks-2] = p_off;
 	blocks[disks-1] = q;
+	offs[disks-1] = q_off;
 
 	/* compute P + Pxy */
 	srcs[0] = dp;
+	src_offs[0] = dp_off;
 	srcs[1] = p;
+	src_offs[1] = p_off;
 	init_async_submit(submit, ASYNC_TX_FENCE|ASYNC_TX_XOR_DROP_DST, tx,
 			  NULL, NULL, scribble);
-	tx = async_xor(dp, srcs, 0, 2, bytes, submit);
+	tx = async_xor_offs(dp, dp_off, srcs, src_offs, 2, bytes, submit);
 
 	/* compute Q + Qxy */
 	srcs[0] = dq;
+	src_offs[0] = dq_off;
 	srcs[1] = q;
+	src_offs[1] = q_off;
 	init_async_submit(submit, ASYNC_TX_FENCE|ASYNC_TX_XOR_DROP_DST, tx,
 			  NULL, NULL, scribble);
-	tx = async_xor(dq, srcs, 0, 2, bytes, submit);
+	tx = async_xor_offs(dq, dq_off, srcs, src_offs, 2, bytes, submit);
 
 	/* Dx = A*(P+Pxy) + B*(Q+Qxy) */
 	srcs[0] = dp;
+	src_offs[0] = dp_off;
 	srcs[1] = dq;
+	src_offs[1] = dq_off;
 	coef[0] = raid6_gfexi[failb-faila];
 	coef[1] = raid6_gfinv[raid6_gfexp[faila]^raid6_gfexp[failb]];
 	init_async_submit(submit, ASYNC_TX_FENCE, tx, NULL, NULL, scribble);
-	tx = async_sum_product(dq, srcs, coef, bytes, submit);
+	tx = async_sum_product(dq, dq_off, srcs, src_offs, coef, bytes, submit);
 
 	/* Dy = P+Pxy+Dx */
 	srcs[0] = dp;
+	src_offs[0] = dp_off;
 	srcs[1] = dq;
+	src_offs[1] = dq_off;
 	init_async_submit(submit, flags | ASYNC_TX_XOR_DROP_DST, tx, cb_fn,
 			  cb_param, scribble);
-	tx = async_xor(dp, srcs, 0, 2, bytes, submit);
+	tx = async_xor_offs(dp, dp_off, srcs, src_offs, 2, bytes, submit);
 
 	return tx;
 }
@@ -330,11 +386,13 @@ __2data_recov_n(int disks, size_t bytes, int faila, int failb,
  * @faila: first failed drive index
  * @failb: second failed drive index
  * @blocks: array of source pointers where the last two entries are p and q
+ * @offs: array of offset for pages in blocks
  * @submit: submission/completion modifiers
  */
 struct dma_async_tx_descriptor *
 async_raid6_2data_recov(int disks, size_t bytes, int faila, int failb,
-			struct page **blocks, struct async_submit_ctl *submit)
+			struct page **blocks, unsigned int *offs,
+			struct async_submit_ctl *submit)
 {
 	void *scribble = submit->scribble;
 	int non_zero_srcs, i;
@@ -358,7 +416,7 @@ async_raid6_2data_recov(int disks, size_t bytes, int faila, int failb,
 			if (blocks[i] == NULL)
 				ptrs[i] = (void *) raid6_empty_zero_page;
 			else
-				ptrs[i] = page_address(blocks[i]);
+				ptrs[i] = page_address(blocks[i]) + offs[i];
 
 		raid6_2data_recov(disks, bytes, faila, failb, ptrs);
 
@@ -383,16 +441,19 @@ async_raid6_2data_recov(int disks, size_t bytes, int faila, int failb,
 		 * explicitly handle the special case of a 4 disk array with
 		 * both data disks missing.
 		 */
-		return __2data_recov_4(disks, bytes, faila, failb, blocks, submit);
+		return __2data_recov_4(disks, bytes, faila, failb,
+				blocks, offs, submit);
 	case 3:
 		/* dma devices do not uniformly understand a single
 		 * source pq operation (in contrast to the synchronous
 		 * case), so explicitly handle the special case of a 5 disk
 		 * array with 2 of 3 data disks missing.
 		 */
-		return __2data_recov_5(disks, bytes, faila, failb, blocks, submit);
+		return __2data_recov_5(disks, bytes, faila, failb,
+				blocks, offs, submit);
 	default:
-		return __2data_recov_n(disks, bytes, faila, failb, blocks, submit);
+		return __2data_recov_n(disks, bytes, faila, failb,
+				blocks, offs, submit);
 	}
 }
 EXPORT_SYMBOL_GPL(async_raid6_2data_recov);
@@ -403,14 +464,17 @@ EXPORT_SYMBOL_GPL(async_raid6_2data_recov);
  * @bytes: block size
  * @faila: failed drive index
  * @blocks: array of source pointers where the last two entries are p and q
+ * @offs: array of offset for pages in blocks
  * @submit: submission/completion modifiers
  */
 struct dma_async_tx_descriptor *
 async_raid6_datap_recov(int disks, size_t bytes, int faila,
-			struct page **blocks, struct async_submit_ctl *submit)
+			struct page **blocks, unsigned int *offs,
+			struct async_submit_ctl *submit)
 {
 	struct dma_async_tx_descriptor *tx = NULL;
 	struct page *p, *q, *dq;
+	unsigned int p_off, q_off, dq_off;
 	u8 coef;
 	enum async_tx_flags flags = submit->flags;
 	dma_async_tx_callback cb_fn = submit->cb_fn;
@@ -418,6 +482,7 @@ async_raid6_datap_recov(int disks, size_t bytes, int faila,
 	void *scribble = submit->scribble;
 	int good_srcs, good, i;
 	struct page *srcs[2];
+	unsigned int src_offs[2];
 
 	pr_debug("%s: disks: %d len: %zu\n", __func__, disks, bytes);
 
@@ -434,7 +499,7 @@ async_raid6_datap_recov(int disks, size_t bytes, int faila,
 			if (blocks[i] == NULL)
 				ptrs[i] = (void*)raid6_empty_zero_page;
 			else
-				ptrs[i] = page_address(blocks[i]);
+				ptrs[i] = page_address(blocks[i]) + offs[i];
 
 		raid6_datap_recov(disks, bytes, faila, ptrs);
 
@@ -458,55 +523,67 @@ async_raid6_datap_recov(int disks, size_t bytes, int faila,
 	BUG_ON(good_srcs == 0);
 
 	p = blocks[disks-2];
+	p_off = offs[disks-2];
 	q = blocks[disks-1];
+	q_off = offs[disks-1];
 
 	/* Compute syndrome with zero for the missing data page
 	 * Use the dead data page as temporary storage for delta q
 	 */
 	dq = blocks[faila];
+	dq_off = offs[faila];
 	blocks[faila] = NULL;
 	blocks[disks-1] = dq;
+	offs[disks-1] = dq_off;
 
 	/* in the 4-disk case we only need to perform a single source
 	 * multiplication with the one good data block.
 	 */
 	if (good_srcs == 1) {
 		struct page *g = blocks[good];
+		unsigned int g_off = offs[good];
 
 		init_async_submit(submit, ASYNC_TX_FENCE, tx, NULL, NULL,
 				  scribble);
-		tx = async_memcpy(p, g, 0, 0, bytes, submit);
+		tx = async_memcpy(p, g, p_off, g_off, bytes, submit);
 
 		init_async_submit(submit, ASYNC_TX_FENCE, tx, NULL, NULL,
 				  scribble);
-		tx = async_mult(dq, g, raid6_gfexp[good], bytes, submit);
+		tx = async_mult(dq, dq_off, g, g_off,
+				raid6_gfexp[good], bytes, submit);
 	} else {
 		init_async_submit(submit, ASYNC_TX_FENCE, tx, NULL, NULL,
 				  scribble);
-		tx = async_gen_syndrome(blocks, 0, disks, bytes, submit);
+		tx = async_gen_syndrome(blocks, offs, disks, bytes, submit);
 	}
 
 	/* Restore pointer table */
 	blocks[faila]   = dq;
+	offs[faila] = dq_off;
 	blocks[disks-1] = q;
+	offs[disks-1] = q_off;
 
 	/* calculate g^{-faila} */
 	coef = raid6_gfinv[raid6_gfexp[faila]];
 
 	srcs[0] = dq;
+	src_offs[0] = dq_off;
 	srcs[1] = q;
+	src_offs[1] = q_off;
 	init_async_submit(submit, ASYNC_TX_FENCE|ASYNC_TX_XOR_DROP_DST, tx,
 			  NULL, NULL, scribble);
-	tx = async_xor(dq, srcs, 0, 2, bytes, submit);
+	tx = async_xor_offs(dq, dq_off, srcs, src_offs, 2, bytes, submit);
 
 	init_async_submit(submit, ASYNC_TX_FENCE, tx, NULL, NULL, scribble);
-	tx = async_mult(dq, dq, coef, bytes, submit);
+	tx = async_mult(dq, dq_off, dq, dq_off, coef, bytes, submit);
 
 	srcs[0] = p;
+	src_offs[0] = p_off;
 	srcs[1] = dq;
+	src_offs[1] = dq_off;
 	init_async_submit(submit, flags | ASYNC_TX_XOR_DROP_DST, tx, cb_fn,
 			  cb_param, scribble);
-	tx = async_xor(p, srcs, 0, 2, bytes, submit);
+	tx = async_xor_offs(p, p_off, srcs, src_offs, 2, bytes, submit);
 
 	return tx;
 }
diff --git a/crypto/async_tx/raid6test.c b/crypto/async_tx/raid6test.c
index ef4e6e68f759..66db82e5a3b1 100644
--- a/crypto/async_tx/raid6test.c
+++ b/crypto/async_tx/raid6test.c
@@ -101,12 +101,12 @@ static void raid6_dual_recov(int disks, size_t bytes, int faila, int failb,
 			/* data+P failure. */
 			init_async_submit(&submit, 0, NULL, NULL, NULL, addr_conv);
 			tx = async_raid6_datap_recov(disks, bytes,
-					faila, ptrs, &submit);
+					faila, ptrs, offs, &submit);
 		} else {
 			/* data+data failure. */
 			init_async_submit(&submit, 0, NULL, NULL, NULL, addr_conv);
 			tx = async_raid6_2data_recov(disks, bytes,
-					faila, failb, ptrs, &submit);
+					faila, failb, ptrs, offs, &submit);
 		}
 	}
 	init_completion(&cmp);
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index c0f9394891fe..8ed4610deeb2 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1685,13 +1685,13 @@ ops_run_compute6_2(struct stripe_head *sh, struct raid5_percpu *percpu)
 			return async_raid6_datap_recov(syndrome_disks+2,
 						RAID5_STRIPE_SIZE(sh->raid_conf),
 						faila,
-						blocks, &submit);
+						blocks, offs, &submit);
 		} else {
 			/* We're missing D+D. */
 			return async_raid6_2data_recov(syndrome_disks+2,
 						RAID5_STRIPE_SIZE(sh->raid_conf),
 						faila, failb,
-						blocks, &submit);
+						blocks, offs, &submit);
 		}
 	}
 }
diff --git a/include/linux/async_tx.h b/include/linux/async_tx.h
index efc5510f7d11..5cc73d7e5b52 100644
--- a/include/linux/async_tx.h
+++ b/include/linux/async_tx.h
@@ -196,11 +196,13 @@ async_syndrome_val(struct page **blocks, unsigned int *offsets, int src_cnt,
 
 struct dma_async_tx_descriptor *
 async_raid6_2data_recov(int src_num, size_t bytes, int faila, int failb,
-			struct page **ptrs, struct async_submit_ctl *submit);
+			struct page **ptrs, unsigned int *offs,
+			struct async_submit_ctl *submit);
 
 struct dma_async_tx_descriptor *
 async_raid6_datap_recov(int src_num, size_t bytes, int faila,
-			struct page **ptrs, struct async_submit_ctl *submit);
+			struct page **ptrs, unsigned int *offs,
+			struct async_submit_ctl *submit);
 
 void async_tx_quiesce(struct dma_async_tx_descriptor **tx);
 #endif /* _ASYNC_TX_H_ */
-- 
2.25.4

