From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 11/11] raid6/async_tx: handle holes in block list in
	async_syndrome_val
Date: Fri, 16 Oct 2009 16:49:19 +1100
Message-ID: <20091016054919.24208.31586.stgit@notabene.brown>
References: <20091016054316.24208.33818.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091016054316.24208.33818.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Dan Williams <dan.j.williams@intel.com>
List-Id: linux-raid.ids

async_syndrome_val check the P and Q blocks used for RAID6
calculations.
With DDF raid6, some of the data blocks might be NULL, so
this needs to be handled in the same way that async_gen_syndrome
handles it.

As async_syndrome_val calls async_xor, also enhance async_xor
to detect and skip NULL blocks in the list.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 crypto/async_tx/async_pq.c  |   31 ++++++++++++++++++++++++-------
 crypto/async_tx/async_xor.c |   18 +++++++++++-------
 2 files changed, 35 insertions(+), 14 deletions(-)

diff --git a/crypto/async_tx/async_pq.c b/crypto/async_tx/async_pq.c
index 9ab1ce4..43b1436 100644
--- a/crypto/async_tx/async_pq.c
+++ b/crypto/async_tx/async_pq.c
@@ -260,8 +260,10 @@ async_syndrome_val(struct page **blocks, unsigned int offset, int disks,
 						      len);
 	struct dma_device *device = chan ? chan->device : NULL;
 	struct dma_async_tx_descriptor *tx;
+	unsigned char coefs[disks-2];
 	enum dma_ctrl_flags dma_flags = submit->cb_fn ? DMA_PREP_INTERRUPT : 0;
 	dma_addr_t *dma_src = NULL;
+	int src_cnt = 0;
 
 	BUG_ON(disks < 4);
 
@@ -280,20 +282,35 @@ async_syndrome_val(struct page **blocks, unsigned int offset, int disks,
 			 __func__, disks, len);
 		if (!P(blocks, disks))
 			dma_flags |= DMA_PREP_PQ_DISABLE_P;
+		else
+			pq[0] = dma_map_page(dev, P(blocks,disks),
+					     offset, len,
+					     DMA_TO_DEVICE);
 		if (!Q(blocks, disks))
 			dma_flags |= DMA_PREP_PQ_DISABLE_Q;
+		else
+			pq[1] = dma_map_page(dev, Q(blocks,disks),
+					     offset, len,
+					     DMA_TO_DEVICE);
+
 		if (submit->flags & ASYNC_TX_FENCE)
 			dma_flags |= DMA_PREP_FENCE;
-		for (i = 0; i < disks; i++)
-			if (likely(blocks[i]))
-				dma_src[i] = dma_map_page(dev, blocks[i],
-							  offset, len,
-							  DMA_TO_DEVICE);
+		for (i = 0; i < disks-2; i++)
+			if (likely(blocks[i])) {
+				dma_src[src_cnt] = dma_map_page(dev, blocks[i],
+								offset, len,
+								DMA_TO_DEVICE);
+				coefs[src_cnt] = raid6_gfexp[i];
+				src_cnt++;
+			}
+		pq[1] = dma_map_page(dev, Q(blocks,disks),
+				     offset, len,
+				     DMA_TO_DEVICE);
 
 		for (;;) {
 			tx = device->device_prep_dma_pq_val(chan, pq, dma_src,
-							    disks - 2,
-							    raid6_gfexp,
+							    src_cnt,
+							    coefs,
 							    len, pqres,
 							    dma_flags);
 			if (likely(tx))
diff --git a/crypto/async_tx/async_xor.c b/crypto/async_tx/async_xor.c
index b459a90..79182dc 100644
--- a/crypto/async_tx/async_xor.c
+++ b/crypto/async_tx/async_xor.c
@@ -44,20 +44,23 @@ do_async_xor(struct dma_chan *chan, struct page *dest, struct page **src_list,
 	void *cb_param_orig = submit->cb_param;
 	enum async_tx_flags flags_orig = submit->flags;
 	enum dma_ctrl_flags dma_flags;
-	int xor_src_cnt;
+	int xor_src_cnt = 0;
 	dma_addr_t dma_dest;
 
 	/* map the dest bidrectional in case it is re-used as a source */
 	dma_dest = dma_map_page(dma->dev, dest, offset, len, DMA_BIDIRECTIONAL);
 	for (i = 0; i < src_cnt; i++) {
 		/* only map the dest once */
+		if (!src_list[i])
+			continue;
 		if (unlikely(src_list[i] == dest)) {
-			dma_src[i] = dma_dest;
+			dma_src[xor_src_cnt++] = dma_dest;
 			continue;
 		}
-		dma_src[i] = dma_map_page(dma->dev, src_list[i], offset,
-					  len, DMA_TO_DEVICE);
+		dma_src[xor_src_cnt++] = dma_map_page(dma->dev, src_list[i], offset,
+						      len, DMA_TO_DEVICE);
 	}
+	src_cnt = xor_src_cnt;
 
 	while (src_cnt) {
 		submit->flags = flags_orig;
@@ -123,7 +126,7 @@ do_sync_xor(struct page *dest, struct page **src_list, unsigned int offset,
 	    int src_cnt, size_t len, struct async_submit_ctl *submit)
 {
 	int i;
-	int xor_src_cnt;
+	int xor_src_cnt = 0;
 	int src_off = 0;
 	void *dest_buf;
 	void **srcs;
@@ -135,8 +138,9 @@ do_sync_xor(struct page *dest, struct page **src_list, unsigned int offset,
 
 	/* convert to buffer pointers */
 	for (i = 0; i < src_cnt; i++)
-		srcs[i] = page_address(src_list[i]) + offset;
-
+		if (src_list[i])
+			srcs[xor_src_cnt++] = page_address(src_list[i]) + offset;
+	src_cnt = xor_src_cnt;
 	/* set destination address */
 	dest_buf = page_address(dest) + offset;
 


