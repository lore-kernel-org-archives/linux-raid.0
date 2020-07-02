From: Yufen Yu <yuyufen@huawei.com>
Subject: [PATCH v5 13/16] md/raid6: let syndrome computor support different page offset
Date: Thu, 2 Jul 2020 08:06:25 -0400
Message-ID: <20200702120628.777303-14-yuyufen@huawei.com>
References: <20200702120628.777303-1-yuyufen@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200702120628.777303-1-yuyufen@huawei.com>
Sender: linux-raid-owner@vger.kernel.org
To: song@kernel.org
Cc: linux-raid@vger.kernel.org, neilb@suse.com, guoqing.jiang@cloud.ionos.com, houtao1@huawei.com, yuyufen@huawei.com
List-Id: linux-raid.ids

For now, syndrome compute functions require common offset in the pages
array. However, we expect these function can support different page
offset when try to use share page. Simplily covert them by adding page
offset where each page address are referred.

Since the only caller of async_gen_syndrome() and async_syndrome_val()
are in md/raid6, we don't want to reserve them but modify the interface
directly.

Signed-off-by: Yufen Yu <yuyufen@huawei.com>
---
 crypto/async_tx/async_pq.c | 72 +++++++++++++++++++++++++-------------
 include/linux/async_tx.h   |  6 ++--
 2 files changed, 51 insertions(+), 27 deletions(-)

diff --git a/crypto/async_tx/async_pq.c b/crypto/async_tx/async_pq.c
index 341ece61cf9b..f3256e9ceafe 100644
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
+			tx = async_xor_offsets(spare, s_off,
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
diff --git a/include/linux/async_tx.h b/include/linux/async_tx.h
index 8d79e2de06bd..bbda58d48dbd 100644
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
