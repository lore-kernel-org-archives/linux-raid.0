From: Yufen Yu <yuyufen@huawei.com>
Subject: [PATCH v4 13/15] md/raid6: let syndrome computor support different page offset
Date: Fri, 12 Jun 2020 19:42:18 +0800
Message-ID: <20200612114220.13126-14-yuyufen@huawei.com>
References: <20200612114220.13126-1-yuyufen@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200612114220.13126-1-yuyufen@huawei.com>
Sender: linux-raid-owner@vger.kernel.org
To: song@kernel.org
Cc: linux-raid@vger.kernel.org, neilb@suse.com, guoqing.jiang@cloud.ionos.com, houtao1@huawei.com, yuyufen@huawei.com
List-Id: linux-raid.ids

For now, syndrome compute functions require common offset in the pages
array. However, we expect these function can support different page
offset when try to use share page.

Signed-off-by: Yufen Yu <yuyufen@huawei.com>
---
 crypto/async_tx/async_pq.c          |  72 ++++++++----
 crypto/async_tx/async_raid6_recov.c | 163 ++++++++++++++++++++--------
 include/linux/async_tx.h            |  12 +-
 3 files changed, 175 insertions(+), 72 deletions(-)

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
diff --git a/crypto/async_tx/async_raid6_recov.c b/crypto/async_tx/async_raid6_recov.c
index f249142ceac4..0eb323a618b0 100644
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
+	tx = async_xor_offsets(a, a_off, srcs, src_offs, 2, bytes, submit);
 
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
+	tx = async_xor_offsets(dp, dp_off, srcs, src_offs, 2, bytes, submit);
 
 	/* compute Q + Qxy */
 	srcs[0] = dq;
+	src_offs[0] = dq_off;
 	srcs[1] = q;
+	src_offs[1] = q_off;
 	init_async_submit(submit, ASYNC_TX_FENCE|ASYNC_TX_XOR_DROP_DST, tx,
 			  NULL, NULL, scribble);
-	tx = async_xor(dq, srcs, 0, 2, bytes, submit);
+	tx = async_xor_offsets(dq, dq_off, srcs, src_offs, 2, bytes, submit);
 
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
+	tx = async_xor_offsets(dp, dp_off, srcs, src_offs, 2, bytes, submit);
 
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
+	tx = async_xor_offsets(dp, dp_off, srcs, src_offs, 2, bytes, submit);
 
 	/* compute Q + Qxy */
 	srcs[0] = dq;
+	src_offs[0] = dq_off;
 	srcs[1] = q;
+	src_offs[1] = q_off;
 	init_async_submit(submit, ASYNC_TX_FENCE|ASYNC_TX_XOR_DROP_DST, tx,
 			  NULL, NULL, scribble);
-	tx = async_xor(dq, srcs, 0, 2, bytes, submit);
+	tx = async_xor_offsets(dq, dq_off, srcs, src_offs, 2, bytes, submit);
 
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
+	tx = async_xor_offsets(dp, dp_off, srcs, src_offs, 2, bytes, submit);
 
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
+	tx = async_xor_offsets(dq, dq_off, srcs, src_offs, 2, bytes, submit);
 
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
+	tx = async_xor_offsets(p, p_off, srcs, src_offs, 2, bytes, submit);
 
 	return tx;
 }
diff --git a/include/linux/async_tx.h b/include/linux/async_tx.h
index 8d79e2de06bd..84d5cc5ff060 100644
--- a/include/linux/async_tx.h
+++ b/include/linux/async_tx.h
@@ -186,21 +186,23 @@ async_memcpy(struct page *dest, struct page *src, unsigned int dest_offset,
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
2.21.3
