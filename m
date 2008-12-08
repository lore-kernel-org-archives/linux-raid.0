From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] ASYNC_TX: async_xor mapping fix
Date: Mon, 08 Dec 2008 14:08:16 -0700
Message-ID: <1228770496.26373.3.camel@dwillia2-linux.ch.intel.com>
References: <200812082214.26811.yur@emcraft.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200812082214.26811.yur@emcraft.com>
Sender: linux-raid-owner@vger.kernel.org
To: Yuri Tikhonov <yur@emcraft.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>, "dzu@denx.de" <dzu@denx.de>, "wd@denx.de" <wd@denx.de>, Ilya Yanok <yanok@emcraft.com>
List-Id: linux-raid.ids

On Mon, 2008-12-08 at 12:14 -0700, Yuri Tikhonov wrote:
> The destination address may be present in the source list, so we should
> map the addresses from the source list first.
>  Otherwise, if page corresponding to destination is not marked as write-
> through (with regards to CPU cache), then mapping it with DMA_FROM_DEVICE
> may lead to data loss, and finally to an incorrect result of calculations.
> 

Thanks Yuri.  I think we should avoid mapping the destination twice
altogether, and for simplicity just always map it bidirectionally.
Something like this (untested):

diff --git a/crypto/async_tx/async_xor.c b/crypto/async_tx/async_xor.c
index c029d3e..a6faa90 100644
--- a/crypto/async_tx/async_xor.c
+++ b/crypto/async_tx/async_xor.c
@@ -53,10 +53,17 @@ do_async_xor(struct dma_chan *chan, struct page *dest, struct page **src_list,
 	int xor_src_cnt;
 	dma_addr_t dma_dest;
 
-	dma_dest = dma_map_page(dma->dev, dest, offset, len, DMA_FROM_DEVICE);
-	for (i = 0; i < src_cnt; i++)
+	/* map the dest bidrectional in case it is re-used as a source */
+	dma_dest = dma_map_page(dma->dev, dest, offset, len, DMA_BIDIRECTIONAL);
+	for (i = 0; i < src_cnt; i++) {
+		/* only map the dest once */
+		if (src_list[i] == dest) {
+			dma_src[i] = dma_dest;
+			continue;
+		}
 		dma_src[i] = dma_map_page(dma->dev, src_list[i], offset,
 					  len, DMA_TO_DEVICE);
+	}
 
 	while (src_cnt) {
 		async_flags = flags;
diff --git a/drivers/dma/iop-adma.c b/drivers/dma/iop-adma.c
index c7a9306..7bf4a2e 100644
--- a/drivers/dma/iop-adma.c
+++ b/drivers/dma/iop-adma.c
@@ -86,13 +86,20 @@ iop_adma_run_tx_complete_actions(struct iop_adma_desc_slot *desc,
 			u32 src_cnt;
 			dma_addr_t addr;
 
+			src_cnt = unmap->unmap_src_cnt;
 			if (!(flags & DMA_COMPL_SKIP_DEST_UNMAP)) {
+				enum dma_data_direction dir;
+
 				addr = iop_desc_get_dest_addr(unmap, iop_chan);
-				dma_unmap_page(dev, addr, len, DMA_FROM_DEVICE);
+				if (src_cnt > 1)
+					dir = DMA_BIDIRECTIONAL;
+				else
+					dir = DMA_FROM_DEVICE;
+
+				dma_unmap_page(dev, addr, len, dir);
 			}
 
 			if (!(flags & DMA_COMPL_SKIP_SRC_UNMAP)) {
-				src_cnt = unmap->unmap_src_cnt;
 				while (src_cnt--) {
 					addr = iop_desc_get_src_addr(unmap,
 								     iop_chan,
diff --git a/drivers/dma/mv_xor.c b/drivers/dma/mv_xor.c
index 0328da0..888fbe9 100644
--- a/drivers/dma/mv_xor.c
+++ b/drivers/dma/mv_xor.c
@@ -312,13 +312,19 @@ mv_xor_run_tx_complete_actions(struct mv_xor_desc_slot *desc,
 			u32 src_cnt;
 			dma_addr_t addr;
 
+			src_cnt = unmap->unmap_src_cnt;
 			if (!(flags & DMA_COMPL_SKIP_DEST_UNMAP)) {
+				enum dma_data_direction dir;
+
 				addr = mv_desc_get_dest_addr(unmap);
-				dma_unmap_page(dev, addr, len, DMA_FROM_DEVICE);
+				if (src_cnt > 1)
+					dir = DMA_BIDIRECTIONAL;
+				else
+					dir = DMA_FROM_DEVICE;
+				dma_unmap_page(dev, addr, len, dir);
 			}
 
 			if (!(flags & DMA_COMPL_SKIP_SRC_UNMAP)) {
-				src_cnt = unmap->unmap_src_cnt;
 				while (src_cnt--) {
 					addr = mv_desc_get_src_addr(unmap,
 								    src_cnt);


