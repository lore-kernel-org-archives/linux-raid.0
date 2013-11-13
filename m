From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 2/4] ioatdma: fix selection of 16 vs 8 source path
Date: Wed, 13 Nov 2013 12:12:26 -0800
Message-ID: <20131113201226.12667.13289.stgit@viggo.jf.intel.com>
References: <20131113200146.12667.19447.stgit@viggo.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20131113200146.12667.19447.stgit@viggo.jf.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: dmaengine@vger.kernel.org
Cc: vinod.koul@intel.com, linux-raid@vger.kernel.org, Dave Jiang <dave.jiang@intel.com>, stable@vger.kernel.org
List-Id: linux-raid.ids

When performing continuations there are implied sources that need to be
added to the source count. Quoting dma_set_maxpq:

/* dma_maxpq - reduce maxpq in the face of continued operations
 * @dma - dma device with PQ capability
 * @flags - to check if DMA_PREP_CONTINUE and DMA_PREP_PQ_DISABLE_P are set
 *
 * When an engine does not support native continuation we need 3 extra
 * source slots to reuse P and Q with the following coefficients:
 * 1/ {00} * P : remove P from Q', but use it as a source for P'
 * 2/ {01} * Q : use Q to continue Q' calculation
 * 3/ {00} * Q : subtract Q from P' to cancel (2)
 *
 * In the case where P is disabled we only need 1 extra source:
 * 1/ {01} * Q : use Q to continue Q' calculation
 */

...fix the selection of the 16 source path to take these implied sources
into account.

Note this also kills the BUG_ON(src_cnt < 9) check in
__ioat3_prep_pq16_lock().  Besides not accounting for implied sources
the check is redundant given we already made the path selection.

Cc: <stable@vger.kernel.org>
Cc: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dma/ioat/dma_v3.c |   30 +++++++++++++++---------------
 1 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/dma/ioat/dma_v3.c b/drivers/dma/ioat/dma_v3.c
index f26a35d43ba1..0284908997f8 100644
--- a/drivers/dma/ioat/dma_v3.c
+++ b/drivers/dma/ioat/dma_v3.c
@@ -951,9 +951,6 @@ __ioat3_prep_pq16_lock(struct dma_chan *c, enum sum_check_flags *result,
 	u8 op;
 	int i, s, idx, num_descs;
 
-	/* this function only handles src_cnt 9 - 16 */
-	BUG_ON(src_cnt < 9);
-
 	/* this function is only called with 9-16 sources */
 	op = result ? IOAT_OP_PQ_VAL_16S : IOAT_OP_PQ_16S;
 
@@ -1039,13 +1036,21 @@ __ioat3_prep_pq16_lock(struct dma_chan *c, enum sum_check_flags *result,
 	return &desc->txd;
 }
 
+static int src_cnt_flags(unsigned int src_cnt, unsigned long flags)
+{
+	if (dmaf_p_disabled_continue(flags))
+		return src_cnt + 1;
+	else if (dmaf_continue(flags))
+		return src_cnt + 3;
+	else
+		return src_cnt;
+}
+
 static struct dma_async_tx_descriptor *
 ioat3_prep_pq(struct dma_chan *chan, dma_addr_t *dst, dma_addr_t *src,
 	      unsigned int src_cnt, const unsigned char *scf, size_t len,
 	      unsigned long flags)
 {
-	struct dma_device *dma = chan->device;
-
 	/* specify valid address for disabled result */
 	if (flags & DMA_PREP_PQ_DISABLE_P)
 		dst[0] = dst[1];
@@ -1065,7 +1070,7 @@ ioat3_prep_pq(struct dma_chan *chan, dma_addr_t *dst, dma_addr_t *src,
 		single_source_coef[0] = scf[0];
 		single_source_coef[1] = 0;
 
-		return (src_cnt > 8) && (dma->max_pq > 8) ?
+		return src_cnt_flags(src_cnt, flags) > 8 ?
 			__ioat3_prep_pq16_lock(chan, NULL, dst, single_source,
 					       2, single_source_coef, len,
 					       flags) :
@@ -1073,7 +1078,7 @@ ioat3_prep_pq(struct dma_chan *chan, dma_addr_t *dst, dma_addr_t *src,
 					     single_source_coef, len, flags);
 
 	} else {
-		return (src_cnt > 8) && (dma->max_pq > 8) ?
+		return src_cnt_flags(src_cnt, flags) > 8 ?
 			__ioat3_prep_pq16_lock(chan, NULL, dst, src, src_cnt,
 					       scf, len, flags) :
 			__ioat3_prep_pq_lock(chan, NULL, dst, src, src_cnt,
@@ -1086,8 +1091,6 @@ ioat3_prep_pq_val(struct dma_chan *chan, dma_addr_t *pq, dma_addr_t *src,
 		  unsigned int src_cnt, const unsigned char *scf, size_t len,
 		  enum sum_check_flags *pqres, unsigned long flags)
 {
-	struct dma_device *dma = chan->device;
-
 	/* specify valid address for disabled result */
 	if (flags & DMA_PREP_PQ_DISABLE_P)
 		pq[0] = pq[1];
@@ -1099,7 +1102,7 @@ ioat3_prep_pq_val(struct dma_chan *chan, dma_addr_t *pq, dma_addr_t *src,
 	 */
 	*pqres = 0;
 
-	return (src_cnt > 8) && (dma->max_pq > 8) ?
+	return src_cnt_flags(src_cnt, flags) > 8 ?
 		__ioat3_prep_pq16_lock(chan, pqres, pq, src, src_cnt, scf, len,
 				       flags) :
 		__ioat3_prep_pq_lock(chan, pqres, pq, src, src_cnt, scf, len,
@@ -1110,7 +1113,6 @@ static struct dma_async_tx_descriptor *
 ioat3_prep_pqxor(struct dma_chan *chan, dma_addr_t dst, dma_addr_t *src,
 		 unsigned int src_cnt, size_t len, unsigned long flags)
 {
-	struct dma_device *dma = chan->device;
 	unsigned char scf[src_cnt];
 	dma_addr_t pq[2];
 
@@ -1119,7 +1121,7 @@ ioat3_prep_pqxor(struct dma_chan *chan, dma_addr_t dst, dma_addr_t *src,
 	flags |= DMA_PREP_PQ_DISABLE_Q;
 	pq[1] = dst; /* specify valid address for disabled result */
 
-	return (src_cnt > 8) && (dma->max_pq > 8) ?
+	return src_cnt_flags(src_cnt, flags) > 8 ?
 		__ioat3_prep_pq16_lock(chan, NULL, pq, src, src_cnt, scf, len,
 				       flags) :
 		__ioat3_prep_pq_lock(chan, NULL, pq, src, src_cnt, scf, len,
@@ -1131,7 +1133,6 @@ ioat3_prep_pqxor_val(struct dma_chan *chan, dma_addr_t *src,
 		     unsigned int src_cnt, size_t len,
 		     enum sum_check_flags *result, unsigned long flags)
 {
-	struct dma_device *dma = chan->device;
 	unsigned char scf[src_cnt];
 	dma_addr_t pq[2];
 
@@ -1145,8 +1146,7 @@ ioat3_prep_pqxor_val(struct dma_chan *chan, dma_addr_t *src,
 	flags |= DMA_PREP_PQ_DISABLE_Q;
 	pq[1] = pq[0]; /* specify valid address for disabled result */
 
-
-	return (src_cnt > 8) && (dma->max_pq > 8) ?
+	return src_cnt_flags(src_cnt, flags) > 8 ?
 		__ioat3_prep_pq16_lock(chan, result, pq, &src[1], src_cnt - 1,
 				       scf, len, flags) :
 		__ioat3_prep_pq_lock(chan, result, pq, &src[1], src_cnt - 1,

