From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v2 01/11] async_tx: rename zero_sum to val
Date: Mon, 18 May 2009 17:59:31 -0700
Message-ID: <20090519005931.4104.81475.stgit@dwillia2-linux.ch.intel.com>
References: <20090519005647.4104.81119.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090519005647.4104.81119.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: maan@systemlinux.org, linux-kernel@vger.kernel.org, yur@emcraft.com, hpa@zytor.com
List-Id: linux-raid.ids

'zero_sum' does not properly describe the operation of generating parity
and checking that it validates against an existing buffer.  Change the
name of the operation to 'val' (for 'validate').  This is in
anticipation of the p+q case where it is a requirement to identify the
target parity buffers separately from the source buffers, because the
target parity buffers will not have corresponding pq coefficients.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/arm/mach-iop13xx/setup.c |    8 ++++----
 arch/arm/plat-iop/adma.c      |    2 +-
 crypto/async_tx/async_xor.c   |   16 ++++++++--------
 drivers/dma/dmaengine.c       |    4 ++--
 drivers/dma/iop-adma.c        |   38 +++++++++++++++++++-------------------
 drivers/md/raid5.c            |    2 +-
 include/linux/async_tx.h      |    2 +-
 include/linux/dmaengine.h     |    8 ++++----
 8 files changed, 40 insertions(+), 40 deletions(-)

diff --git a/arch/arm/mach-iop13xx/setup.c b/arch/arm/mach-iop13xx/setup.c
index cfd4d2e..9800228 100644
--- a/arch/arm/mach-iop13xx/setup.c
+++ b/arch/arm/mach-iop13xx/setup.c
@@ -478,7 +478,7 @@ void __init iop13xx_platform_init(void)
 			dma_cap_set(DMA_MEMCPY, plat_data->cap_mask);
 			dma_cap_set(DMA_XOR, plat_data->cap_mask);
 			dma_cap_set(DMA_DUAL_XOR, plat_data->cap_mask);
-			dma_cap_set(DMA_ZERO_SUM, plat_data->cap_mask);
+			dma_cap_set(DMA_XOR_VAL, plat_data->cap_mask);
 			dma_cap_set(DMA_MEMSET, plat_data->cap_mask);
 			dma_cap_set(DMA_MEMCPY_CRC32C, plat_data->cap_mask);
 			dma_cap_set(DMA_INTERRUPT, plat_data->cap_mask);
@@ -490,7 +490,7 @@ void __init iop13xx_platform_init(void)
 			dma_cap_set(DMA_MEMCPY, plat_data->cap_mask);
 			dma_cap_set(DMA_XOR, plat_data->cap_mask);
 			dma_cap_set(DMA_DUAL_XOR, plat_data->cap_mask);
-			dma_cap_set(DMA_ZERO_SUM, plat_data->cap_mask);
+			dma_cap_set(DMA_XOR_VAL, plat_data->cap_mask);
 			dma_cap_set(DMA_MEMSET, plat_data->cap_mask);
 			dma_cap_set(DMA_MEMCPY_CRC32C, plat_data->cap_mask);
 			dma_cap_set(DMA_INTERRUPT, plat_data->cap_mask);
@@ -502,13 +502,13 @@ void __init iop13xx_platform_init(void)
 			dma_cap_set(DMA_MEMCPY, plat_data->cap_mask);
 			dma_cap_set(DMA_XOR, plat_data->cap_mask);
 			dma_cap_set(DMA_DUAL_XOR, plat_data->cap_mask);
-			dma_cap_set(DMA_ZERO_SUM, plat_data->cap_mask);
+			dma_cap_set(DMA_XOR_VAL, plat_data->cap_mask);
 			dma_cap_set(DMA_MEMSET, plat_data->cap_mask);
 			dma_cap_set(DMA_MEMCPY_CRC32C, plat_data->cap_mask);
 			dma_cap_set(DMA_INTERRUPT, plat_data->cap_mask);
 			dma_cap_set(DMA_PQ_XOR, plat_data->cap_mask);
 			dma_cap_set(DMA_PQ_UPDATE, plat_data->cap_mask);
-			dma_cap_set(DMA_PQ_ZERO_SUM, plat_data->cap_mask);
+			dma_cap_set(DMA_PQ_VAL, plat_data->cap_mask);
 			break;
 		}
 	}
diff --git a/arch/arm/plat-iop/adma.c b/arch/arm/plat-iop/adma.c
index f724208..c040044 100644
--- a/arch/arm/plat-iop/adma.c
+++ b/arch/arm/plat-iop/adma.c
@@ -198,7 +198,7 @@ static int __init iop3xx_adma_cap_init(void)
 	dma_cap_set(DMA_INTERRUPT, iop3xx_aau_data.cap_mask);
 	#else
 	dma_cap_set(DMA_XOR, iop3xx_aau_data.cap_mask);
-	dma_cap_set(DMA_ZERO_SUM, iop3xx_aau_data.cap_mask);
+	dma_cap_set(DMA_XOR_VAL, iop3xx_aau_data.cap_mask);
 	dma_cap_set(DMA_MEMSET, iop3xx_aau_data.cap_mask);
 	dma_cap_set(DMA_INTERRUPT, iop3xx_aau_data.cap_mask);
 	#endif
diff --git a/crypto/async_tx/async_xor.c b/crypto/async_tx/async_xor.c
index 95fe2c8..e0580b0 100644
--- a/crypto/async_tx/async_xor.c
+++ b/crypto/async_tx/async_xor.c
@@ -222,7 +222,7 @@ static int page_is_zero(struct page *p, unsigned int offset, size_t len)
 }
 
 /**
- * async_xor_zero_sum - attempt a xor parity check with a dma engine.
+ * async_xor_val - attempt a xor parity check with a dma engine.
  * @dest: destination page used if the xor is performed synchronously
  * @src_list: array of source pages.  The dest page must be listed as a source
  * 	at index zero.  The contents of this array may be overwritten.
@@ -236,13 +236,13 @@ static int page_is_zero(struct page *p, unsigned int offset, size_t len)
  * @cb_param: parameter to pass to the callback routine
  */
 struct dma_async_tx_descriptor *
-async_xor_zero_sum(struct page *dest, struct page **src_list,
+async_xor_val(struct page *dest, struct page **src_list,
 	unsigned int offset, int src_cnt, size_t len,
 	u32 *result, enum async_tx_flags flags,
 	struct dma_async_tx_descriptor *depend_tx,
 	dma_async_tx_callback cb_fn, void *cb_param)
 {
-	struct dma_chan *chan = async_tx_find_channel(depend_tx, DMA_ZERO_SUM,
+	struct dma_chan *chan = async_tx_find_channel(depend_tx, DMA_XOR_VAL,
 						      &dest, 1, src_list,
 						      src_cnt, len);
 	struct dma_device *device = chan ? chan->device : NULL;
@@ -261,15 +261,15 @@ async_xor_zero_sum(struct page *dest, struct page **src_list,
 			dma_src[i] = dma_map_page(device->dev, src_list[i],
 						  offset, len, DMA_TO_DEVICE);
 
-		tx = device->device_prep_dma_zero_sum(chan, dma_src, src_cnt,
-						      len, result,
-						      dma_prep_flags);
+		tx = device->device_prep_dma_xor_val(chan, dma_src, src_cnt,
+						     len, result,
+						     dma_prep_flags);
 		if (unlikely(!tx)) {
 			async_tx_quiesce(&depend_tx);
 
 			while (!tx) {
 				dma_async_issue_pending(chan);
-				tx = device->device_prep_dma_zero_sum(chan,
+				tx = device->device_prep_dma_xor_val(chan,
 					dma_src, src_cnt, len, result,
 					dma_prep_flags);
 			}
@@ -296,7 +296,7 @@ async_xor_zero_sum(struct page *dest, struct page **src_list,
 
 	return tx;
 }
-EXPORT_SYMBOL_GPL(async_xor_zero_sum);
+EXPORT_SYMBOL_GPL(async_xor_val);
 
 static int __init async_xor_init(void)
 {
diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index 92438e9..6781e8f 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -644,8 +644,8 @@ int dma_async_device_register(struct dma_device *device)
 		!device->device_prep_dma_memcpy);
 	BUG_ON(dma_has_cap(DMA_XOR, device->cap_mask) &&
 		!device->device_prep_dma_xor);
-	BUG_ON(dma_has_cap(DMA_ZERO_SUM, device->cap_mask) &&
-		!device->device_prep_dma_zero_sum);
+	BUG_ON(dma_has_cap(DMA_XOR_VAL, device->cap_mask) &&
+		!device->device_prep_dma_xor_val);
 	BUG_ON(dma_has_cap(DMA_MEMSET, device->cap_mask) &&
 		!device->device_prep_dma_memset);
 	BUG_ON(dma_has_cap(DMA_INTERRUPT, device->cap_mask) &&
diff --git a/drivers/dma/iop-adma.c b/drivers/dma/iop-adma.c
index 2f05226..6ff79a6 100644
--- a/drivers/dma/iop-adma.c
+++ b/drivers/dma/iop-adma.c
@@ -660,9 +660,9 @@ iop_adma_prep_dma_xor(struct dma_chan *chan, dma_addr_t dma_dest,
 }
 
 static struct dma_async_tx_descriptor *
-iop_adma_prep_dma_zero_sum(struct dma_chan *chan, dma_addr_t *dma_src,
-			   unsigned int src_cnt, size_t len, u32 *result,
-			   unsigned long flags)
+iop_adma_prep_dma_xor_val(struct dma_chan *chan, dma_addr_t *dma_src,
+			  unsigned int src_cnt, size_t len, u32 *result,
+			  unsigned long flags)
 {
 	struct iop_adma_chan *iop_chan = to_iop_adma_chan(chan);
 	struct iop_adma_desc_slot *sw_desc, *grp_start;
@@ -906,7 +906,7 @@ out:
 
 #define IOP_ADMA_NUM_SRC_TEST 4 /* must be <= 15 */
 static int __devinit
-iop_adma_xor_zero_sum_self_test(struct iop_adma_device *device)
+iop_adma_xor_val_self_test(struct iop_adma_device *device)
 {
 	int i, src_idx;
 	struct page *dest;
@@ -1002,7 +1002,7 @@ iop_adma_xor_zero_sum_self_test(struct iop_adma_device *device)
 		PAGE_SIZE, DMA_TO_DEVICE);
 
 	/* skip zero sum if the capability is not present */
-	if (!dma_has_cap(DMA_ZERO_SUM, dma_chan->device->cap_mask))
+	if (!dma_has_cap(DMA_XOR_VAL, dma_chan->device->cap_mask))
 		goto free_resources;
 
 	/* zero sum the sources with the destintation page */
@@ -1016,10 +1016,10 @@ iop_adma_xor_zero_sum_self_test(struct iop_adma_device *device)
 		dma_srcs[i] = dma_map_page(dma_chan->device->dev,
 					   zero_sum_srcs[i], 0, PAGE_SIZE,
 					   DMA_TO_DEVICE);
-	tx = iop_adma_prep_dma_zero_sum(dma_chan, dma_srcs,
-					IOP_ADMA_NUM_SRC_TEST + 1, PAGE_SIZE,
-					&zero_sum_result,
-					DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
+	tx = iop_adma_prep_dma_xor_val(dma_chan, dma_srcs,
+				       IOP_ADMA_NUM_SRC_TEST + 1, PAGE_SIZE,
+				       &zero_sum_result,
+				       DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
 
 	cookie = iop_adma_tx_submit(tx);
 	iop_adma_issue_pending(dma_chan);
@@ -1072,10 +1072,10 @@ iop_adma_xor_zero_sum_self_test(struct iop_adma_device *device)
 		dma_srcs[i] = dma_map_page(dma_chan->device->dev,
 					   zero_sum_srcs[i], 0, PAGE_SIZE,
 					   DMA_TO_DEVICE);
-	tx = iop_adma_prep_dma_zero_sum(dma_chan, dma_srcs,
-					IOP_ADMA_NUM_SRC_TEST + 1, PAGE_SIZE,
-					&zero_sum_result,
-					DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
+	tx = iop_adma_prep_dma_xor_val(dma_chan, dma_srcs,
+				       IOP_ADMA_NUM_SRC_TEST + 1, PAGE_SIZE,
+				       &zero_sum_result,
+				       DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
 
 	cookie = iop_adma_tx_submit(tx);
 	iop_adma_issue_pending(dma_chan);
@@ -1192,9 +1192,9 @@ static int __devinit iop_adma_probe(struct platform_device *pdev)
 		dma_dev->max_xor = iop_adma_get_max_xor();
 		dma_dev->device_prep_dma_xor = iop_adma_prep_dma_xor;
 	}
-	if (dma_has_cap(DMA_ZERO_SUM, dma_dev->cap_mask))
-		dma_dev->device_prep_dma_zero_sum =
-			iop_adma_prep_dma_zero_sum;
+	if (dma_has_cap(DMA_XOR_VAL, dma_dev->cap_mask))
+		dma_dev->device_prep_dma_xor_val =
+			iop_adma_prep_dma_xor_val;
 	if (dma_has_cap(DMA_INTERRUPT, dma_dev->cap_mask))
 		dma_dev->device_prep_dma_interrupt =
 			iop_adma_prep_dma_interrupt;
@@ -1249,7 +1249,7 @@ static int __devinit iop_adma_probe(struct platform_device *pdev)
 
 	if (dma_has_cap(DMA_XOR, dma_dev->cap_mask) ||
 		dma_has_cap(DMA_MEMSET, dma_dev->cap_mask)) {
-		ret = iop_adma_xor_zero_sum_self_test(adev);
+		ret = iop_adma_xor_val_self_test(adev);
 		dev_dbg(&pdev->dev, "xor self test returned %d\n", ret);
 		if (ret)
 			goto err_free_iop_chan;
@@ -1259,10 +1259,10 @@ static int __devinit iop_adma_probe(struct platform_device *pdev)
 	  "( %s%s%s%s%s%s%s%s%s%s)\n",
 	  dma_has_cap(DMA_PQ_XOR, dma_dev->cap_mask) ? "pq_xor " : "",
 	  dma_has_cap(DMA_PQ_UPDATE, dma_dev->cap_mask) ? "pq_update " : "",
-	  dma_has_cap(DMA_PQ_ZERO_SUM, dma_dev->cap_mask) ? "pq_zero_sum " : "",
+	  dma_has_cap(DMA_PQ_VAL, dma_dev->cap_mask) ? "pq_val " : "",
 	  dma_has_cap(DMA_XOR, dma_dev->cap_mask) ? "xor " : "",
 	  dma_has_cap(DMA_DUAL_XOR, dma_dev->cap_mask) ? "dual_xor " : "",
-	  dma_has_cap(DMA_ZERO_SUM, dma_dev->cap_mask) ? "xor_zero_sum " : "",
+	  dma_has_cap(DMA_XOR_VAL, dma_dev->cap_mask) ? "xor_val " : "",
 	  dma_has_cap(DMA_MEMSET, dma_dev->cap_mask)  ? "fill " : "",
 	  dma_has_cap(DMA_MEMCPY_CRC32C, dma_dev->cap_mask) ? "cpy+crc " : "",
 	  dma_has_cap(DMA_MEMCPY, dma_dev->cap_mask) ? "cpy " : "",
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 3bbc6d6..f8d2d35 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -854,7 +854,7 @@ static void ops_run_check(struct stripe_head *sh)
 			xor_srcs[count++] = dev->page;
 	}
 
-	tx = async_xor_zero_sum(xor_dest, xor_srcs, 0, count, STRIPE_SIZE,
+	tx = async_xor_val(xor_dest, xor_srcs, 0, count, STRIPE_SIZE,
 		&sh->ops.zero_sum_result, 0, NULL, NULL, NULL);
 
 	atomic_inc(&sh->count);
diff --git a/include/linux/async_tx.h b/include/linux/async_tx.h
index 5fc2ef8..513150d 100644
--- a/include/linux/async_tx.h
+++ b/include/linux/async_tx.h
@@ -117,7 +117,7 @@ async_xor(struct page *dest, struct page **src_list, unsigned int offset,
 	dma_async_tx_callback cb_fn, void *cb_fn_param);
 
 struct dma_async_tx_descriptor *
-async_xor_zero_sum(struct page *dest, struct page **src_list,
+async_xor_val(struct page *dest, struct page **src_list,
 	unsigned int offset, int src_cnt, size_t len,
 	u32 *result, enum async_tx_flags flags,
 	struct dma_async_tx_descriptor *depend_tx,
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 2e2aa3d..6768727 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -55,8 +55,8 @@ enum dma_transaction_type {
 	DMA_PQ_XOR,
 	DMA_DUAL_XOR,
 	DMA_PQ_UPDATE,
-	DMA_ZERO_SUM,
-	DMA_PQ_ZERO_SUM,
+	DMA_XOR_VAL,
+	DMA_PQ_VAL,
 	DMA_MEMSET,
 	DMA_MEMCPY_CRC32C,
 	DMA_INTERRUPT,
@@ -214,7 +214,7 @@ struct dma_async_tx_descriptor {
  * @device_free_chan_resources: release DMA channel's resources
  * @device_prep_dma_memcpy: prepares a memcpy operation
  * @device_prep_dma_xor: prepares a xor operation
- * @device_prep_dma_zero_sum: prepares a zero_sum operation
+ * @device_prep_dma_xor_val: prepares a xor validation operation
  * @device_prep_dma_memset: prepares a memset operation
  * @device_prep_dma_interrupt: prepares an end of chain interrupt operation
  * @device_prep_slave_sg: prepares a slave dma operation
@@ -243,7 +243,7 @@ struct dma_device {
 	struct dma_async_tx_descriptor *(*device_prep_dma_xor)(
 		struct dma_chan *chan, dma_addr_t dest, dma_addr_t *src,
 		unsigned int src_cnt, size_t len, unsigned long flags);
-	struct dma_async_tx_descriptor *(*device_prep_dma_zero_sum)(
+	struct dma_async_tx_descriptor *(*device_prep_dma_xor_val)(
 		struct dma_chan *chan, dma_addr_t *src,	unsigned int src_cnt,
 		size_t len, u32 *result, unsigned long flags);
 	struct dma_async_tx_descriptor *(*device_prep_dma_memset)(

