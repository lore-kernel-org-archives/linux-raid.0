From: Dan Williams <dan.j.williams@intel.com>
Subject: [md PATCH 2/4] async_pq: kill a stray dma_map() call and other
	cleanups
Date: Tue, 20 Oct 2009 00:11:28 -0700
Message-ID: <20091020071128.6489.17320.stgit@dwillia2-linux.ch.intel.com>
References: <20091020070627.6489.4006.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091020070627.6489.4006.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

- update the kernel doc for async_syndrome to indicate what NULL in the
  source list means
- whitespace fixups

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 crypto/async_tx/async_pq.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/crypto/async_tx/async_pq.c b/crypto/async_tx/async_pq.c
index 43b1436..6047656 100644
--- a/crypto/async_tx/async_pq.c
+++ b/crypto/async_tx/async_pq.c
@@ -181,10 +181,14 @@ do_sync_gen_syndrome(struct page **blocks, unsigned int offset, int disks,
  * blocks[disks-1] to NULL.  When P or Q is omitted 'len' must be <=
  * PAGE_SIZE as a temporary buffer of this size is used in the
  * synchronous path.  'disks' always accounts for both destination
- * buffers.
+ * buffers.  If any source buffers (blocks[i] where i < disks - 2) are
+ * set to NULL those buffers will be replaced with the raid6_zero_page
+ * in the synchronous path and omitted in the hardware-asynchronous
+ * path.
  *
  * 'blocks' note: if submit->scribble is NULL then the contents of
- * 'blocks' may be overridden
+ * 'blocks' may be overwritten to perform address conversions
+ * (dma_map_page() or page_address()).
  */
 struct dma_async_tx_descriptor *
 async_gen_syndrome(struct page **blocks, unsigned int offset, int disks,
@@ -283,13 +287,13 @@ async_syndrome_val(struct page **blocks, unsigned int offset, int disks,
 		if (!P(blocks, disks))
 			dma_flags |= DMA_PREP_PQ_DISABLE_P;
 		else
-			pq[0] = dma_map_page(dev, P(blocks,disks),
+			pq[0] = dma_map_page(dev, P(blocks, disks),
 					     offset, len,
 					     DMA_TO_DEVICE);
 		if (!Q(blocks, disks))
 			dma_flags |= DMA_PREP_PQ_DISABLE_Q;
 		else
-			pq[1] = dma_map_page(dev, Q(blocks,disks),
+			pq[1] = dma_map_page(dev, Q(blocks, disks),
 					     offset, len,
 					     DMA_TO_DEVICE);
 
@@ -303,9 +307,6 @@ async_syndrome_val(struct page **blocks, unsigned int offset, int disks,
 				coefs[src_cnt] = raid6_gfexp[i];
 				src_cnt++;
 			}
-		pq[1] = dma_map_page(dev, Q(blocks,disks),
-				     offset, len,
-				     DMA_TO_DEVICE);
 
 		for (;;) {
 			tx = device->device_prep_dma_pq_val(chan, pq, dma_src,

