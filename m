From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 4/8] ioat3: specify valid address for disabled-Q or disabled-P
Date: Fri, 20 Nov 2009 00:06:34 -0700
Message-ID: <20091120070634.13478.42516.stgit@dwillia2-linux.ch.intel.com>
References: <20091120070506.13478.77838.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1757302AbZKTHHM@vger.kernel.org>
In-Reply-To: <20091120070506.13478.77838.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-raid@vger.kernel.org, maciej.sosnowski@intel.com
List-Id: linux-raid.ids

Although disabled, hardware still checks address validity, so duplicate
the known address.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dma/ioat/dma_v3.c |   22 +++++++++++++++++-----
 1 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/dma/ioat/dma_v3.c b/drivers/dma/ioat/dma_v3.c
index 4f305f6..fad2e9f 100644
--- a/drivers/dma/ioat/dma_v3.c
+++ b/drivers/dma/ioat/dma_v3.c
@@ -736,10 +736,16 @@ ioat3_prep_pq(struct dma_chan *chan, dma_addr_t *dst, dma_addr_t *src,
 	      unsigned int src_cnt, const unsigned char *scf, size_t len,
 	      unsigned long flags)
 {
+	/* specify valid address for disabled result */
+	if (flags & DMA_PREP_PQ_DISABLE_P)
+		dst[0] = dst[1];
+	if (flags & DMA_PREP_PQ_DISABLE_Q)
+		dst[1] = dst[0];
+
 	/* handle the single source multiply case from the raid6
 	 * recovery path
 	 */
-	if (unlikely((flags & DMA_PREP_PQ_DISABLE_P) && src_cnt == 1)) {
+	if ((flags & DMA_PREP_PQ_DISABLE_P) && src_cnt == 1) {
 		dma_addr_t single_source[2];
 		unsigned char single_source_coef[2];
 
@@ -761,6 +767,12 @@ ioat3_prep_pq_val(struct dma_chan *chan, dma_addr_t *pq, dma_addr_t *src,
 		  unsigned int src_cnt, const unsigned char *scf, size_t len,
 		  enum sum_check_flags *pqres, unsigned long flags)
 {
+	/* specify valid address for disabled result */
+	if (flags & DMA_PREP_PQ_DISABLE_P)
+		pq[0] = pq[1];
+	if (flags & DMA_PREP_PQ_DISABLE_Q)
+		pq[1] = pq[0];
+
 	/* the cleanup routine only sets bits on validate failure, it
 	 * does not clear bits on validate success... so clear it here
 	 */
@@ -778,9 +790,9 @@ ioat3_prep_pqxor(struct dma_chan *chan, dma_addr_t dst, dma_addr_t *src,
 	dma_addr_t pq[2];
 
 	memset(scf, 0, src_cnt);
-	flags |= DMA_PREP_PQ_DISABLE_Q;
 	pq[0] = dst;
-	pq[1] = ~0;
+	flags |= DMA_PREP_PQ_DISABLE_Q;
+	pq[1] = dst; /* specify valid address for disabled result */
 
 	return __ioat3_prep_pq_lock(chan, NULL, pq, src, src_cnt, scf, len,
 				    flags);
@@ -800,9 +812,9 @@ ioat3_prep_pqxor_val(struct dma_chan *chan, dma_addr_t *src,
 	*result = 0;
 
 	memset(scf, 0, src_cnt);
-	flags |= DMA_PREP_PQ_DISABLE_Q;
 	pq[0] = src[0];
-	pq[1] = ~0;
+	flags |= DMA_PREP_PQ_DISABLE_Q;
+	pq[1] = pq[0]; /* specify valid address for disabled result */
 
 	return __ioat3_prep_pq_lock(chan, result, pq, &src[1], src_cnt - 1, scf,
 				    len, flags);
