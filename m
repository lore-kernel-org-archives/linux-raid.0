From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 01/18] dmaengine: add fence support
Date: Thu, 03 Sep 2009 23:44:40 -0700
Message-ID: <20090904064440.7141.72561.stgit@dwillia2-linux.ch.intel.com>
References: <20090904064308.7141.30576.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756640AbZIDGon@vger.kernel.org>
In-Reply-To: <20090904064308.7141.30576.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-raid@vger.kernel.org, maciej.sosnowski@intel.com
List-Id: linux-raid.ids

Some engines optimize operation by reading ahead in the descriptor chain
such that descriptor2 may start execution before descriptor1 completes.
If descriptor2 depends on the result from descriptor1 then a fence is
required (on descriptor2) to disable this optimization.  The async_tx
api could implicitly identify dependencies via the 'depend_tx'
parameter, but that would constrain cases where the dependency chain
only specifies a completion order rather than a data dependency.  So,
provide an ASYNC_TX_FENCE to explicitly identify data dependencies.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 crypto/async_tx/async_memcpy.c      |    7 ++++-
 crypto/async_tx/async_memset.c      |    7 ++++-
 crypto/async_tx/async_pq.c          |    5 ++++
 crypto/async_tx/async_raid6_recov.c |   47 ++++++++++++++++++++---------------
 crypto/async_tx/async_xor.c         |   11 ++++++--
 drivers/md/raid5.c                  |   37 +++++++++++++++++-----------
 include/linux/async_tx.h            |    3 ++
 include/linux/dmaengine.h           |    3 ++
 8 files changed, 79 insertions(+), 41 deletions(-)

diff --git a/crypto/async_tx/async_memcpy.c b/crypto/async_tx/async_memcpy.c
index 98e15bd..b38cbb3 100644
--- a/crypto/async_tx/async_memcpy.c
+++ b/crypto/async_tx/async_memcpy.c
@@ -52,9 +52,12 @@ async_memcpy(struct page *dest, struct page *src, unsigned int dest_offset,
 
 	if (device) {
 		dma_addr_t dma_dest, dma_src;
-		unsigned long dma_prep_flags;
+		unsigned long dma_prep_flags = 0;
 
-		dma_prep_flags = submit->cb_fn ? DMA_PREP_INTERRUPT : 0;
+		if (submit->cb_fn)
+			dma_prep_flags |= DMA_PREP_INTERRUPT;
+		if (submit->flags & ASYNC_TX_FENCE)
+			dma_prep_flags |= DMA_PREP_FENCE;
 		dma_dest = dma_map_page(device->dev, dest, dest_offset, len,
 					DMA_FROM_DEVICE);
 
diff --git a/crypto/async_tx/async_memset.c b/crypto/async_tx/async_memset.c
index b896a6e..a374784 100644
--- a/crypto/async_tx/async_memset.c
+++ b/crypto/async_tx/async_memset.c
@@ -49,9 +49,12 @@ async_memset(struct page *dest, int val, unsigned int offset, size_t len,
 
 	if (device) {
 		dma_addr_t dma_dest;
-		unsigned long dma_prep_flags;
+		unsigned long dma_prep_flags = 0;
 
-		dma_prep_flags = submit->cb_fn ? DMA_PREP_INTERRUPT : 0;
+		if (submit->cb_fn)
+			dma_prep_flags |= DMA_PREP_INTERRUPT;
+		if (submit->flags & ASYNC_TX_FENCE)
+			dma_prep_flags |= DMA_PREP_FENCE;
 		dma_dest = dma_map_page(device->dev, dest, offset, len,
 					DMA_FROM_DEVICE);
 
diff --git a/crypto/async_tx/async_pq.c b/crypto/async_tx/async_pq.c
index 108b21e..a25e290 100644
--- a/crypto/async_tx/async_pq.c
+++ b/crypto/async_tx/async_pq.c
@@ -101,6 +101,7 @@ do_async_gen_syndrome(struct dma_chan *chan, struct page **blocks,
 		 */
 		if (src_cnt > pq_src_cnt) {
 			submit->flags &= ~ASYNC_TX_ACK;
+			submit->flags |= ASYNC_TX_FENCE;
 			dma_flags |= DMA_COMPL_SKIP_DEST_UNMAP;
 			submit->cb_fn = NULL;
 			submit->cb_param = NULL;
@@ -111,6 +112,8 @@ do_async_gen_syndrome(struct dma_chan *chan, struct page **blocks,
 			if (cb_fn_orig)
 				dma_flags |= DMA_PREP_INTERRUPT;
 		}
+		if (submit->flags & ASYNC_TX_FENCE)
+			dma_flags |= DMA_PREP_FENCE;
 
 		/* Since we have clobbered the src_list we are committed
 		 * to doing this asynchronously.  Drivers force forward
@@ -282,6 +285,8 @@ async_syndrome_val(struct page **blocks, unsigned int offset, int disks,
 			dma_flags |= DMA_PREP_PQ_DISABLE_P;
 		if (!Q(blocks, disks))
 			dma_flags |= DMA_PREP_PQ_DISABLE_Q;
+		if (submit->flags & ASYNC_TX_FENCE)
+			dma_flags |= DMA_PREP_FENCE;
 		for (i = 0; i < disks; i++)
 			if (likely(blocks[i])) {
 				BUG_ON(is_raid6_zero_block(blocks[i]));
diff --git a/crypto/async_tx/async_raid6_recov.c b/crypto/async_tx/async_raid6_recov.c
index 0c14d48..822a42d 100644
--- a/crypto/async_tx/async_raid6_recov.c
+++ b/crypto/async_tx/async_raid6_recov.c
@@ -44,6 +44,8 @@ async_sum_product(struct page *dest, struct page **srcs, unsigned char *coef,
 		struct dma_async_tx_descriptor *tx;
 		enum dma_ctrl_flags dma_flags = DMA_PREP_PQ_DISABLE_P;
 
+		if (submit->flags & ASYNC_TX_FENCE)
+			dma_flags |= DMA_PREP_FENCE;
 		dma_dest[1] = dma_map_page(dev, dest, 0, len, DMA_BIDIRECTIONAL);
 		dma_src[0] = dma_map_page(dev, srcs[0], 0, len, DMA_TO_DEVICE);
 		dma_src[1] = dma_map_page(dev, srcs[1], 0, len, DMA_TO_DEVICE);
@@ -89,6 +91,8 @@ async_mult(struct page *dest, struct page *src, u8 coef, size_t len,
 		struct dma_async_tx_descriptor *tx;
 		enum dma_ctrl_flags dma_flags = DMA_PREP_PQ_DISABLE_P;
 
+		if (submit->flags & ASYNC_TX_FENCE)
+			dma_flags |= DMA_PREP_FENCE;
 		dma_dest[1] = dma_map_page(dev, dest, 0, len, DMA_BIDIRECTIONAL);
 		dma_src[0] = dma_map_page(dev, src, 0, len, DMA_TO_DEVICE);
 		tx = dma->device_prep_dma_pq(chan, dma_dest, dma_src, 1, &coef,
@@ -138,7 +142,7 @@ __2data_recov_4(size_t bytes, int faila, int failb, struct page **blocks,
 	srcs[1] = q;
 	coef[0] = raid6_gfexi[failb-faila];
 	coef[1] = raid6_gfinv[raid6_gfexp[faila]^raid6_gfexp[failb]];
-	init_async_submit(submit, 0, tx, NULL, NULL, scribble);
+	init_async_submit(submit, ASYNC_TX_FENCE, tx, NULL, NULL, scribble);
 	tx = async_sum_product(b, srcs, coef, bytes, submit);
 
 	/* Dy = P+Pxy+Dx */
@@ -188,23 +192,23 @@ __2data_recov_5(size_t bytes, int faila, int failb, struct page **blocks,
 	dp = blocks[faila];
 	dq = blocks[failb];
 
-	init_async_submit(submit, 0, tx, NULL, NULL, scribble);
+	init_async_submit(submit, ASYNC_TX_FENCE, tx, NULL, NULL, scribble);
 	tx = async_memcpy(dp, g, 0, 0, bytes, submit);
-	init_async_submit(submit, 0, tx, NULL, NULL, scribble);
+	init_async_submit(submit, ASYNC_TX_FENCE, tx, NULL, NULL, scribble);
 	tx = async_mult(dq, g, raid6_gfexp[good], bytes, submit);
 
 	/* compute P + Pxy */
 	srcs[0] = dp;
 	srcs[1] = p;
-	init_async_submit(submit, ASYNC_TX_XOR_DROP_DST, tx, NULL, NULL,
-			  scribble);
+	init_async_submit(submit, ASYNC_TX_FENCE|ASYNC_TX_XOR_DROP_DST, tx,
+			  NULL, NULL, scribble);
 	tx = async_xor(dp, srcs, 0, 2, bytes, submit);
 
 	/* compute Q + Qxy */
 	srcs[0] = dq;
 	srcs[1] = q;
-	init_async_submit(submit, ASYNC_TX_XOR_DROP_DST, tx, NULL, NULL,
-			  scribble);
+	init_async_submit(submit, ASYNC_TX_FENCE|ASYNC_TX_XOR_DROP_DST, tx,
+			  NULL, NULL, scribble);
 	tx = async_xor(dq, srcs, 0, 2, bytes, submit);
 
 	/* Dx = A*(P+Pxy) + B*(Q+Qxy) */
@@ -212,7 +216,7 @@ __2data_recov_5(size_t bytes, int faila, int failb, struct page **blocks,
 	srcs[1] = dq;
 	coef[0] = raid6_gfexi[failb-faila];
 	coef[1] = raid6_gfinv[raid6_gfexp[faila]^raid6_gfexp[failb]];
-	init_async_submit(submit, 0, tx, NULL, NULL, scribble);
+	init_async_submit(submit, ASYNC_TX_FENCE, tx, NULL, NULL, scribble);
 	tx = async_sum_product(dq, srcs, coef, bytes, submit);
 
 	/* Dy = P+Pxy+Dx */
@@ -252,7 +256,7 @@ __2data_recov_n(int disks, size_t bytes, int faila, int failb,
 	blocks[failb] = (void *)raid6_empty_zero_page;
 	blocks[disks-1] = dq;
 
-	init_async_submit(submit, 0, tx, NULL, NULL, scribble);
+	init_async_submit(submit, ASYNC_TX_FENCE, tx, NULL, NULL, scribble);
 	tx = async_gen_syndrome(blocks, 0, disks, bytes, submit);
 
 	/* Restore pointer table */
@@ -264,15 +268,15 @@ __2data_recov_n(int disks, size_t bytes, int faila, int failb,
 	/* compute P + Pxy */
 	srcs[0] = dp;
 	srcs[1] = p;
-	init_async_submit(submit, ASYNC_TX_XOR_DROP_DST, tx, NULL, NULL,
-			  scribble);
+	init_async_submit(submit, ASYNC_TX_FENCE|ASYNC_TX_XOR_DROP_DST, tx,
+			  NULL, NULL, scribble);
 	tx = async_xor(dp, srcs, 0, 2, bytes, submit);
 
 	/* compute Q + Qxy */
 	srcs[0] = dq;
 	srcs[1] = q;
-	init_async_submit(submit, ASYNC_TX_XOR_DROP_DST, tx, NULL, NULL,
-			  scribble);
+	init_async_submit(submit, ASYNC_TX_FENCE|ASYNC_TX_XOR_DROP_DST, tx,
+			  NULL, NULL, scribble);
 	tx = async_xor(dq, srcs, 0, 2, bytes, submit);
 
 	/* Dx = A*(P+Pxy) + B*(Q+Qxy) */
@@ -280,7 +284,7 @@ __2data_recov_n(int disks, size_t bytes, int faila, int failb,
 	srcs[1] = dq;
 	coef[0] = raid6_gfexi[failb-faila];
 	coef[1] = raid6_gfinv[raid6_gfexp[faila]^raid6_gfexp[failb]];
-	init_async_submit(submit, 0, tx, NULL, NULL, scribble);
+	init_async_submit(submit, ASYNC_TX_FENCE, tx, NULL, NULL, scribble);
 	tx = async_sum_product(dq, srcs, coef, bytes, submit);
 
 	/* Dy = P+Pxy+Dx */
@@ -407,13 +411,16 @@ async_raid6_datap_recov(int disks, size_t bytes, int faila,
 		int good = faila == 0 ? 1 : 0;
 		struct page *g = blocks[good];
 
-		init_async_submit(submit, 0, tx, NULL, NULL, scribble);
+		init_async_submit(submit, ASYNC_TX_FENCE, tx, NULL, NULL,
+				  scribble);
 		tx = async_memcpy(p, g, 0, 0, bytes, submit);
 
-		init_async_submit(submit, 0, tx, NULL, NULL, scribble);
+		init_async_submit(submit, ASYNC_TX_FENCE, tx, NULL, NULL,
+				  scribble);
 		tx = async_mult(dq, g, raid6_gfexp[good], bytes, submit);
 	} else {
-		init_async_submit(submit, 0, tx, NULL, NULL, scribble);
+		init_async_submit(submit, ASYNC_TX_FENCE, tx, NULL, NULL,
+				  scribble);
 		tx = async_gen_syndrome(blocks, 0, disks, bytes, submit);
 	}
 
@@ -426,11 +433,11 @@ async_raid6_datap_recov(int disks, size_t bytes, int faila,
 
 	srcs[0] = dq;
 	srcs[1] = q;
-	init_async_submit(submit, ASYNC_TX_XOR_DROP_DST, tx, NULL, NULL,
-			  scribble);
+	init_async_submit(submit, ASYNC_TX_FENCE|ASYNC_TX_XOR_DROP_DST, tx,
+			  NULL, NULL, scribble);
 	tx = async_xor(dq, srcs, 0, 2, bytes, submit);
 
-	init_async_submit(submit, 0, tx, NULL, NULL, scribble);
+	init_async_submit(submit, ASYNC_TX_FENCE, tx, NULL, NULL, scribble);
 	tx = async_mult(dq, dq, coef, bytes, submit);
 
 	srcs[0] = p;
diff --git a/crypto/async_tx/async_xor.c b/crypto/async_tx/async_xor.c
index 56b5f98..db27987 100644
--- a/crypto/async_tx/async_xor.c
+++ b/crypto/async_tx/async_xor.c
@@ -69,6 +69,7 @@ do_async_xor(struct dma_chan *chan, struct page *dest, struct page **src_list,
 		 */
 		if (src_cnt > xor_src_cnt) {
 			submit->flags &= ~ASYNC_TX_ACK;
+			submit->flags |= ASYNC_TX_FENCE;
 			dma_flags = DMA_COMPL_SKIP_DEST_UNMAP;
 			submit->cb_fn = NULL;
 			submit->cb_param = NULL;
@@ -78,7 +79,8 @@ do_async_xor(struct dma_chan *chan, struct page *dest, struct page **src_list,
 		}
 		if (submit->cb_fn)
 			dma_flags |= DMA_PREP_INTERRUPT;
-
+		if (submit->flags & ASYNC_TX_FENCE)
+			dma_flags |= DMA_PREP_FENCE;
 		/* Since we have clobbered the src_list we are committed
 		 * to doing this asynchronously.  Drivers force forward progress
 		 * in case they can not provide a descriptor
@@ -264,12 +266,15 @@ async_xor_val(struct page *dest, struct page **src_list, unsigned int offset,
 		dma_src = (dma_addr_t *) src_list;
 
 	if (dma_src && device && src_cnt <= device->max_xor) {
-		unsigned long dma_prep_flags;
+		unsigned long dma_prep_flags = 0;
 		int i;
 
 		pr_debug("%s: (async) len: %zu\n", __func__, len);
 
-		dma_prep_flags = submit->cb_fn ? DMA_PREP_INTERRUPT : 0;
+		if (submit->cb_fn)
+			dma_prep_flags |= DMA_PREP_INTERRUPT;
+		if (submit->flags & ASYNC_TX_FENCE)
+			dma_prep_flags |= DMA_PREP_FENCE;
 		for (i = 0; i < src_cnt; i++)
 			dma_src[i] = dma_map_page(device->dev, src_list[i],
 						  offset, len, DMA_TO_DEVICE);
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 0a5cf21..54ef8d7 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -502,13 +502,17 @@ async_copy_data(int frombio, struct bio *bio, struct page *page,
 	int i;
 	int page_offset;
 	struct async_submit_ctl submit;
+	enum async_tx_flags flags = 0;
 
 	if (bio->bi_sector >= sector)
 		page_offset = (signed)(bio->bi_sector - sector) * 512;
 	else
 		page_offset = (signed)(sector - bio->bi_sector) * -512;
 
-	init_async_submit(&submit, 0, tx, NULL, NULL, NULL);
+	if (frombio)
+		flags |= ASYNC_TX_FENCE;
+	init_async_submit(&submit, flags, tx, NULL, NULL, NULL);
+
 	bio_for_each_segment(bvl, bio, i) {
 		int len = bio_iovec_idx(bio, i)->bv_len;
 		int clen;
@@ -685,7 +689,7 @@ ops_run_compute5(struct stripe_head *sh, struct raid5_percpu *percpu)
 
 	atomic_inc(&sh->count);
 
-	init_async_submit(&submit, ASYNC_TX_XOR_ZERO_DST, NULL,
+	init_async_submit(&submit, ASYNC_TX_FENCE|ASYNC_TX_XOR_ZERO_DST, NULL,
 			  ops_complete_compute, sh, to_addr_conv(sh, percpu));
 	if (unlikely(count == 1))
 		tx = async_memcpy(xor_dest, xor_srcs[0], 0, 0, STRIPE_SIZE, &submit);
@@ -763,7 +767,8 @@ ops_run_compute6_1(struct stripe_head *sh, struct raid5_percpu *percpu)
 		count = set_syndrome_sources(blocks, sh);
 		blocks[count] = NULL; /* regenerating p is not necessary */
 		BUG_ON(blocks[count+1] != dest); /* q should already be set */
-		init_async_submit(&submit, 0, NULL, ops_complete_compute, sh,
+		init_async_submit(&submit, ASYNC_TX_FENCE, NULL,
+				  ops_complete_compute, sh,
 				  to_addr_conv(sh, percpu));
 		tx = async_gen_syndrome(blocks, 0, count+2, STRIPE_SIZE, &submit);
 	} else {
@@ -775,8 +780,8 @@ ops_run_compute6_1(struct stripe_head *sh, struct raid5_percpu *percpu)
 			blocks[count++] = sh->dev[i].page;
 		}
 
-		init_async_submit(&submit, ASYNC_TX_XOR_ZERO_DST, NULL,
-				  ops_complete_compute, sh,
+		init_async_submit(&submit, ASYNC_TX_FENCE|ASYNC_TX_XOR_ZERO_DST,
+				  NULL, ops_complete_compute, sh,
 				  to_addr_conv(sh, percpu));
 		tx = async_xor(dest, blocks, 0, count, STRIPE_SIZE, &submit);
 	}
@@ -837,8 +842,9 @@ ops_run_compute6_2(struct stripe_head *sh, struct raid5_percpu *percpu)
 		/* Q disk is one of the missing disks */
 		if (faila == syndrome_disks) {
 			/* Missing P+Q, just recompute */
-			init_async_submit(&submit, 0, NULL, ops_complete_compute,
-					  sh, to_addr_conv(sh, percpu));
+			init_async_submit(&submit, ASYNC_TX_FENCE, NULL,
+					  ops_complete_compute, sh,
+					  to_addr_conv(sh, percpu));
 			return async_gen_syndrome(blocks, 0, count+2,
 						  STRIPE_SIZE, &submit);
 		} else {
@@ -859,21 +865,24 @@ ops_run_compute6_2(struct stripe_head *sh, struct raid5_percpu *percpu)
 				blocks[count++] = sh->dev[i].page;
 			}
 			dest = sh->dev[data_target].page;
-			init_async_submit(&submit, ASYNC_TX_XOR_ZERO_DST, NULL,
-					  NULL, NULL, to_addr_conv(sh, percpu));
+			init_async_submit(&submit,
+					  ASYNC_TX_FENCE|ASYNC_TX_XOR_ZERO_DST,
+					  NULL, NULL, NULL,
+					  to_addr_conv(sh, percpu));
 			tx = async_xor(dest, blocks, 0, count, STRIPE_SIZE,
 				       &submit);
 
 			count = set_syndrome_sources(blocks, sh);
-			init_async_submit(&submit, 0, tx, ops_complete_compute,
-					  sh, to_addr_conv(sh, percpu));
+			init_async_submit(&submit, ASYNC_TX_FENCE, tx,
+					  ops_complete_compute, sh,
+					  to_addr_conv(sh, percpu));
 			return async_gen_syndrome(blocks, 0, count+2,
 						  STRIPE_SIZE, &submit);
 		}
 	}
 
-	init_async_submit(&submit, 0, NULL, ops_complete_compute, sh,
-			  to_addr_conv(sh, percpu));
+	init_async_submit(&submit, ASYNC_TX_FENCE, NULL, ops_complete_compute,
+			  sh, to_addr_conv(sh, percpu));
 	if (failb == syndrome_disks) {
 		/* We're missing D+P. */
 		return async_raid6_datap_recov(syndrome_disks+2, STRIPE_SIZE,
@@ -916,7 +925,7 @@ ops_run_prexor(struct stripe_head *sh, struct raid5_percpu *percpu,
 			xor_srcs[count++] = dev->page;
 	}
 
-	init_async_submit(&submit, ASYNC_TX_XOR_DROP_DST, tx,
+	init_async_submit(&submit, ASYNC_TX_FENCE|ASYNC_TX_XOR_DROP_DST, tx,
 			  ops_complete_prexor, sh, to_addr_conv(sh, percpu));
 	tx = async_xor(xor_dest, xor_srcs, 0, count, STRIPE_SIZE, &submit);
 
diff --git a/include/linux/async_tx.h b/include/linux/async_tx.h
index 866e61c..a1c486a 100644
--- a/include/linux/async_tx.h
+++ b/include/linux/async_tx.h
@@ -58,11 +58,14 @@ struct dma_chan_ref {
  * array.
  * @ASYNC_TX_ACK: immediately ack the descriptor, precludes setting up a
  * dependency chain
+ * @ASYNC_TX_FENCE: specify that the next operation in the dependency
+ * chain uses this operation's result as an input
  */
 enum async_tx_flags {
 	ASYNC_TX_XOR_ZERO_DST	 = (1 << 0),
 	ASYNC_TX_XOR_DROP_DST	 = (1 << 1),
 	ASYNC_TX_ACK		 = (1 << 2),
+	ASYNC_TX_FENCE		 = (1 << 3),
 };
 
 /**
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 2fe9bf1..176f827 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -87,6 +87,8 @@ enum dma_transaction_type {
  * @DMA_PREP_CONTINUE - indicate to a driver that it is reusing buffers as
  *  sources that were the result of a previous operation, in the case of a PQ
  *  operation it continues the calculation with new sources
+ * @DMA_PREP_FENCE - tell the driver that subsequent operations depend
+ *  on the result of this operation
  */
 enum dma_ctrl_flags {
 	DMA_PREP_INTERRUPT = (1 << 0),
@@ -98,6 +100,7 @@ enum dma_ctrl_flags {
 	DMA_PREP_PQ_DISABLE_P = (1 << 6),
 	DMA_PREP_PQ_DISABLE_Q = (1 << 7),
 	DMA_PREP_CONTINUE = (1 << 8),
+	DMA_PREP_FENCE = (1 << 9),
 };
 
 /**
