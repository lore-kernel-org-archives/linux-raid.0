From: Yufen Yu <yuyufen@huawei.com>
Subject: [PATCH 04/12] md/raid5: add new xor function to support different page offset
Date: Wed, 12 Aug 2020 08:49:23 -0400
Message-ID: <20200812124931.2584743-5-yuyufen@huawei.com>
References: <20200812124931.2584743-1-yuyufen@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200812124931.2584743-1-yuyufen@huawei.com>
Sender: linux-raid-owner@vger.kernel.org
To: song@kernel.org
Cc: linux-raid@vger.kernel.org, neilb@suse.com, guoqing.jiang@cloud.ionos.com, houtao1@huawei.com, yuyufen@huawei.com
List-Id: linux-raid.ids

raid5 will call async_xor() and async_xor_val() to compute xor.
However, both of them require common src/dst page offset. But,
we want them to support different src/dst page offset for following
shared page.

Here, adding two new function async_xor_offs() and async_xor_val_offs()
respectively for async_xor() and async_xor_val().

Signed-off-by: Yufen Yu <yuyufen@huawei.com>
---
 crypto/async_tx/async_xor.c | 120 +++++++++++++++++++++++++++++++-----
 include/linux/async_tx.h    |  11 ++++
 2 files changed, 114 insertions(+), 17 deletions(-)

diff --git a/crypto/async_tx/async_xor.c b/crypto/async_tx/async_xor.c
index 4e5eebe52e6a..a057ecb1288d 100644
--- a/crypto/async_tx/async_xor.c
+++ b/crypto/async_tx/async_xor.c
@@ -97,7 +97,8 @@ do_async_xor(struct dma_chan *chan, struct dmaengine_unmap_data *unmap,
 }
 
 static void
-do_sync_xor(struct page *dest, struct page **src_list, unsigned int offset,
+do_sync_xor_offs(struct page *dest, unsigned int offset,
+		struct page **src_list, unsigned int *src_offs,
 	    int src_cnt, size_t len, struct async_submit_ctl *submit)
 {
 	int i;
@@ -114,7 +115,8 @@ do_sync_xor(struct page *dest, struct page **src_list, unsigned int offset,
 	/* convert to buffer pointers */
 	for (i = 0; i < src_cnt; i++)
 		if (src_list[i])
-			srcs[xor_src_cnt++] = page_address(src_list[i]) + offset;
+			srcs[xor_src_cnt++] = page_address(src_list[i]) +
+				(src_offs ? src_offs[i] : offset);
 	src_cnt = xor_src_cnt;
 	/* set destination address */
 	dest_buf = page_address(dest) + offset;
@@ -135,11 +137,31 @@ do_sync_xor(struct page *dest, struct page **src_list, unsigned int offset,
 	async_tx_sync_epilog(submit);
 }
 
+static inline bool
+dma_xor_aligned_offsets(struct dma_device *device, unsigned int offset,
+		unsigned int *src_offs, int src_cnt, int len)
+{
+	int i;
+
+	if (!is_dma_xor_aligned(device, offset, 0, len))
+		return false;
+
+	if (!src_offs)
+		return true;
+
+	for (i = 0; i < src_cnt; i++) {
+		if (!is_dma_xor_aligned(device, src_offs[i], 0, len))
+			return false;
+	}
+	return true;
+}
+
 /**
- * async_xor - attempt to xor a set of blocks with a dma engine.
+ * async_xor_offs - attempt to xor a set of blocks with a dma engine.
  * @dest: destination page
+ * @offset: dst offset to start transaction
  * @src_list: array of source pages
- * @offset: common src/dst offset to start transaction
+ * @src_offs: array of source pages offset, NULL means common src/dst offset
  * @src_cnt: number of source pages
  * @len: length in bytes
  * @submit: submission / completion modifiers
@@ -157,8 +179,9 @@ do_sync_xor(struct page *dest, struct page **src_list, unsigned int offset,
  * is not specified.
  */
 struct dma_async_tx_descriptor *
-async_xor(struct page *dest, struct page **src_list, unsigned int offset,
-	  int src_cnt, size_t len, struct async_submit_ctl *submit)
+async_xor_offs(struct page *dest, unsigned int offset,
+		struct page **src_list, unsigned int *src_offs,
+		int src_cnt, size_t len, struct async_submit_ctl *submit)
 {
 	struct dma_chan *chan = async_tx_find_channel(submit, DMA_XOR,
 						      &dest, 1, src_list,
@@ -171,7 +194,8 @@ async_xor(struct page *dest, struct page **src_list, unsigned int offset,
 	if (device)
 		unmap = dmaengine_get_unmap_data(device->dev, src_cnt+1, GFP_NOWAIT);
 
-	if (unmap && is_dma_xor_aligned(device, offset, 0, len)) {
+	if (unmap && dma_xor_aligned_offsets(device, offset,
+				src_offs, src_cnt, len)) {
 		struct dma_async_tx_descriptor *tx;
 		int i, j;
 
@@ -184,7 +208,8 @@ async_xor(struct page *dest, struct page **src_list, unsigned int offset,
 				continue;
 			unmap->to_cnt++;
 			unmap->addr[j++] = dma_map_page(device->dev, src_list[i],
-							offset, len, DMA_TO_DEVICE);
+					src_offs ? src_offs[i] : offset,
+					len, DMA_TO_DEVICE);
 		}
 
 		/* map it bidirectional as it may be re-used as a source */
@@ -213,11 +238,42 @@ async_xor(struct page *dest, struct page **src_list, unsigned int offset,
 		/* wait for any prerequisite operations */
 		async_tx_quiesce(&submit->depend_tx);
 
-		do_sync_xor(dest, src_list, offset, src_cnt, len, submit);
+		do_sync_xor_offs(dest, offset, src_list, src_offs,
+				src_cnt, len, submit);
 
 		return NULL;
 	}
 }
+EXPORT_SYMBOL_GPL(async_xor_offs);
+
+/**
+ * async_xor - attempt to xor a set of blocks with a dma engine.
+ * @dest: destination page
+ * @src_list: array of source pages
+ * @offset: common src/dst offset to start transaction
+ * @src_cnt: number of source pages
+ * @len: length in bytes
+ * @submit: submission / completion modifiers
+ *
+ * honored flags: ASYNC_TX_ACK, ASYNC_TX_XOR_ZERO_DST, ASYNC_TX_XOR_DROP_DST
+ *
+ * xor_blocks always uses the dest as a source so the
+ * ASYNC_TX_XOR_ZERO_DST flag must be set to not include dest data in
+ * the calculation.  The assumption with dma eninges is that they only
+ * use the destination buffer as a source when it is explicity specified
+ * in the source list.
+ *
+ * src_list note: if the dest is also a source it must be at index zero.
+ * The contents of this array will be overwritten if a scribble region
+ * is not specified.
+ */
+struct dma_async_tx_descriptor *
+async_xor(struct page *dest, struct page **src_list, unsigned int offset,
+	  int src_cnt, size_t len, struct async_submit_ctl *submit)
+{
+	return async_xor_offs(dest, offset, src_list, NULL,
+			src_cnt, len, submit);
+}
 EXPORT_SYMBOL_GPL(async_xor);
 
 static int page_is_zero(struct page *p, unsigned int offset, size_t len)
@@ -237,10 +293,11 @@ xor_val_chan(struct async_submit_ctl *submit, struct page *dest,
 }
 
 /**
- * async_xor_val - attempt a xor parity check with a dma engine.
+ * async_xor_val_offs - attempt a xor parity check with a dma engine.
  * @dest: destination page used if the xor is performed synchronously
+ * @offset: des offset in pages to start transaction
  * @src_list: array of source pages
- * @offset: offset in pages to start transaction
+ * @src_offs: array of source pages offset, NULL means common src/det offset
  * @src_cnt: number of source pages
  * @len: length in bytes
  * @result: 0 if sum == 0 else non-zero
@@ -253,9 +310,10 @@ xor_val_chan(struct async_submit_ctl *submit, struct page *dest,
  * is not specified.
  */
 struct dma_async_tx_descriptor *
-async_xor_val(struct page *dest, struct page **src_list, unsigned int offset,
-	      int src_cnt, size_t len, enum sum_check_flags *result,
-	      struct async_submit_ctl *submit)
+async_xor_val_offs(struct page *dest, unsigned int offset,
+		struct page **src_list, unsigned int *src_offs,
+		int src_cnt, size_t len, enum sum_check_flags *result,
+		struct async_submit_ctl *submit)
 {
 	struct dma_chan *chan = xor_val_chan(submit, dest, src_list, src_cnt, len);
 	struct dma_device *device = chan ? chan->device : NULL;
@@ -268,7 +326,7 @@ async_xor_val(struct page *dest, struct page **src_list, unsigned int offset,
 		unmap = dmaengine_get_unmap_data(device->dev, src_cnt, GFP_NOWAIT);
 
 	if (unmap && src_cnt <= device->max_xor &&
-	    is_dma_xor_aligned(device, offset, 0, len)) {
+	    dma_xor_aligned_offsets(device, offset, src_offs, src_cnt, len)) {
 		unsigned long dma_prep_flags = 0;
 		int i;
 
@@ -281,7 +339,8 @@ async_xor_val(struct page *dest, struct page **src_list, unsigned int offset,
 
 		for (i = 0; i < src_cnt; i++) {
 			unmap->addr[i] = dma_map_page(device->dev, src_list[i],
-						      offset, len, DMA_TO_DEVICE);
+					src_offs ? src_offs[i] : offset,
+					len, DMA_TO_DEVICE);
 			unmap->to_cnt++;
 		}
 		unmap->len = len;
@@ -312,7 +371,8 @@ async_xor_val(struct page *dest, struct page **src_list, unsigned int offset,
 		submit->flags |= ASYNC_TX_XOR_DROP_DST;
 		submit->flags &= ~ASYNC_TX_ACK;
 
-		tx = async_xor(dest, src_list, offset, src_cnt, len, submit);
+		tx = async_xor_offs(dest, offset, src_list, src_offs,
+				src_cnt, len, submit);
 
 		async_tx_quiesce(&tx);
 
@@ -325,6 +385,32 @@ async_xor_val(struct page *dest, struct page **src_list, unsigned int offset,
 
 	return tx;
 }
+EXPORT_SYMBOL_GPL(async_xor_val_offs);
+
+/**
+ * async_xor_val - attempt a xor parity check with a dma engine.
+ * @dest: destination page used if the xor is performed synchronously
+ * @src_list: array of source pages
+ * @offset: offset in pages to start transaction
+ * @src_cnt: number of source pages
+ * @len: length in bytes
+ * @result: 0 if sum == 0 else non-zero
+ * @submit: submission / completion modifiers
+ *
+ * honored flags: ASYNC_TX_ACK
+ *
+ * src_list note: if the dest is also a source it must be at index zero.
+ * The contents of this array will be overwritten if a scribble region
+ * is not specified.
+ */
+struct dma_async_tx_descriptor *
+async_xor_val(struct page *dest, struct page **src_list, unsigned int offset,
+	      int src_cnt, size_t len, enum sum_check_flags *result,
+	      struct async_submit_ctl *submit)
+{
+	return async_xor_val_offs(dest, offset, src_list, NULL, src_cnt,
+			len, result, submit);
+}
 EXPORT_SYMBOL_GPL(async_xor_val);
 
 MODULE_AUTHOR("Intel Corporation");
diff --git a/include/linux/async_tx.h b/include/linux/async_tx.h
index 75e582b8d2d9..81110722f779 100644
--- a/include/linux/async_tx.h
+++ b/include/linux/async_tx.h
@@ -162,11 +162,22 @@ struct dma_async_tx_descriptor *
 async_xor(struct page *dest, struct page **src_list, unsigned int offset,
 	  int src_cnt, size_t len, struct async_submit_ctl *submit);
 
+struct dma_async_tx_descriptor *
+async_xor_offs(struct page *dest, unsigned int offset,
+		struct page **src_list, unsigned int *src_offset,
+		int src_cnt, size_t len, struct async_submit_ctl *submit);
+
 struct dma_async_tx_descriptor *
 async_xor_val(struct page *dest, struct page **src_list, unsigned int offset,
 	      int src_cnt, size_t len, enum sum_check_flags *result,
 	      struct async_submit_ctl *submit);
 
+struct dma_async_tx_descriptor *
+async_xor_val_offs(struct page *dest, unsigned int offset,
+		struct page **src_list, unsigned int *src_offset,
+		int src_cnt, size_t len, enum sum_check_flags *result,
+		struct async_submit_ctl *submit);
+
 struct dma_async_tx_descriptor *
 async_memcpy(struct page *dest, struct page *src, unsigned int dest_offset,
 	     unsigned int src_offset, size_t len,
-- 
2.25.4
