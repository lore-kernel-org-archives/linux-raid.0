From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 05/13] async_tx: add sum check flags
Date: Wed, 18 Mar 2009 12:20:41 -0700
Message-ID: <20090318192041.20375.11506.stgit@dwillia2-linux.ch.intel.com>
References: <20090318191248.20375.40560.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090318191248.20375.40560.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: neilb@suse.de, maciej.sosnowski@intel.com
List-Id: linux-raid.ids

Replace the flat zero_sum_result with a collection of flags to contain
the P (xor) zero-sum result, and the soon to be utilized Q (raid6 reed
solomon syndrome) zero-sum result.  Use the SUM_CHECK_ namespace instead
of DMA_ since these flags will be used on non-dma-zero-sum enabled
platforms.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/arm/include/asm/hardware/iop3xx-adma.h |    5 +++--
 arch/arm/mach-iop13xx/include/mach/adma.h   |   12 +++++++-----
 crypto/async_tx/async_xor.c                 |    4 ++--
 drivers/md/raid5.c                          |    2 +-
 drivers/md/raid5.h                          |    5 +++--
 include/linux/async_tx.h                    |    2 +-
 include/linux/dmaengine.h                   |   21 ++++++++++++++++++++-
 7 files changed, 37 insertions(+), 14 deletions(-)

diff --git a/arch/arm/include/asm/hardware/iop3xx-adma.h b/arch/arm/include/asm/hardware/iop3xx-adma.h
index 83e6ba3..26eefea 100644
--- a/arch/arm/include/asm/hardware/iop3xx-adma.h
+++ b/arch/arm/include/asm/hardware/iop3xx-adma.h
@@ -756,13 +756,14 @@ static inline void iop_desc_set_block_fill_val(struct iop_adma_desc_slot *desc,
 	hw_desc->src[0] = val;
 }
 
-static inline int iop_desc_get_zero_result(struct iop_adma_desc_slot *desc)
+static inline enum sum_check_flags
+iop_desc_get_zero_result(struct iop_adma_desc_slot *desc)
 {
 	struct iop3xx_desc_aau *hw_desc = desc->hw_desc;
 	struct iop3xx_aau_desc_ctrl desc_ctrl = hw_desc->desc_ctrl_field;
 
 	iop_paranoia(!(desc_ctrl.tx_complete && desc_ctrl.zero_result_en));
-	return desc_ctrl.zero_result_err;
+	return desc_ctrl.zero_result_err << SUM_CHECK_P;
 }
 
 static inline void iop_chan_append(struct iop_adma_chan *chan)
diff --git a/arch/arm/mach-iop13xx/include/mach/adma.h b/arch/arm/mach-iop13xx/include/mach/adma.h
index 5722e86..1cd31df 100644
--- a/arch/arm/mach-iop13xx/include/mach/adma.h
+++ b/arch/arm/mach-iop13xx/include/mach/adma.h
@@ -428,18 +428,20 @@ static inline void iop_desc_set_block_fill_val(struct iop_adma_desc_slot *desc,
 	hw_desc->block_fill_data = val;
 }
 
-static inline int iop_desc_get_zero_result(struct iop_adma_desc_slot *desc)
+static inline enum sum_check_flags
+iop_desc_get_zero_result(struct iop_adma_desc_slot *desc)
 {
 	struct iop13xx_adma_desc_hw *hw_desc = desc->hw_desc;
 	struct iop13xx_adma_desc_ctrl desc_ctrl = hw_desc->desc_ctrl_field;
 	struct iop13xx_adma_byte_count byte_count = hw_desc->byte_count_field;
+	enum sum_check_flags flags;
 
 	BUG_ON(!(byte_count.tx_complete && desc_ctrl.zero_result));
 
-	if (desc_ctrl.pq_xfer_en)
-		return byte_count.zero_result_err_q;
-	else
-		return byte_count.zero_result_err;
+	flags = byte_count.zero_result_err_q << SUM_CHECK_Q;
+	flags |= byte_count.zero_result_err << SUM_CHECK_P;
+
+	return flags;
 }
 
 static inline void iop_chan_append(struct iop_adma_chan *chan)
diff --git a/crypto/async_tx/async_xor.c b/crypto/async_tx/async_xor.c
index 0a56fae..d1a084e 100644
--- a/crypto/async_tx/async_xor.c
+++ b/crypto/async_tx/async_xor.c
@@ -238,7 +238,7 @@ static int page_is_zero(struct page *p, unsigned int offset, size_t len)
 struct dma_async_tx_descriptor *
 async_xor_zero_sum(struct page *dest, struct page **src_list,
 	unsigned int offset, int src_cnt, size_t len,
-	u32 *result, enum async_tx_flags flags,
+	enum sum_check_flags *result, enum async_tx_flags flags,
 	struct dma_async_tx_descriptor *depend_tx,
 	dma_async_tx_callback cb_fn, void *cb_param)
 {
@@ -289,7 +289,7 @@ async_xor_zero_sum(struct page *dest, struct page **src_list,
 
 		async_tx_quiesce(&tx);
 
-		*result = page_is_zero(dest, offset, len) ? 0 : 1;
+		*result = !page_is_zero(dest, offset, len) << SUM_CHECK_P;
 
 		async_tx_sync_epilog(cb_fn, cb_param);
 	}
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 21626cc..a102337 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2521,7 +2521,7 @@ static void handle_parity_checks5(raid5_conf_t *conf, struct stripe_head *sh,
 		 * we are done.  Otherwise update the mismatch count and repair
 		 * parity if !MD_RECOVERY_CHECK
 		 */
-		if (sh->ops.zero_sum_result == 0)
+		if ((sh->ops.zero_sum_result & SUM_CHECK_P_RESULT) == 0)
 			/* parity is correct (on disc,
 			 * not in buffer any more)
 			 */
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 2934ee0..cfb5006 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -2,6 +2,7 @@
 #define _RAID5_H
 
 #include <linux/raid/xor.h>
+#include <linux/dmaengine.h>
 
 /*
  *
@@ -213,8 +214,8 @@ struct stripe_head {
 	 * @target - STRIPE_OP_COMPUTE_BLK target
 	 */
 	struct stripe_operations {
-		int		   target;
-		u32		   zero_sum_result;
+		int		     target;
+		enum sum_check_flags zero_sum_result;
 	} ops;
 	struct r5dev {
 		struct bio	req;
diff --git a/include/linux/async_tx.h b/include/linux/async_tx.h
index 5fc2ef8..6370f32 100644
--- a/include/linux/async_tx.h
+++ b/include/linux/async_tx.h
@@ -119,7 +119,7 @@ async_xor(struct page *dest, struct page **src_list, unsigned int offset,
 struct dma_async_tx_descriptor *
 async_xor_zero_sum(struct page *dest, struct page **src_list,
 	unsigned int offset, int src_cnt, size_t len,
-	u32 *result, enum async_tx_flags flags,
+	enum sum_check_flags *result, enum async_tx_flags flags,
 	struct dma_async_tx_descriptor *depend_tx,
 	dma_async_tx_callback cb_fn, void *cb_fn_param);
 
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 1956c8d..cd17392 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -90,6 +90,25 @@ enum dma_ctrl_flags {
 };
 
 /**
+ * enum sum_check_bits - bit position of pq_check_flags
+ */
+enum sum_check_bits {
+	SUM_CHECK_P = 0,
+	SUM_CHECK_Q = 1,
+};
+
+/**
+ * enum pq_check_flags - result of async_{xor,pq}_zero_sum operations
+ * @SUM_CHECK_P_RESULT - 1 if xor zero sum error, 0 otherwise
+ * @SUM_CHECK_Q_RESULT - 1 if reed-solomon zero sum error, 0 otherwise
+ */
+enum sum_check_flags {
+	SUM_CHECK_P_RESULT = (1 << SUM_CHECK_P),
+	SUM_CHECK_Q_RESULT = (1 << SUM_CHECK_Q),
+};
+
+
+/**
  * dma_cap_mask_t - capabilities bitmap modeled after cpumask_t.
  * See linux/cpumask.h
  */
@@ -246,7 +265,7 @@ struct dma_device {
 		unsigned int src_cnt, size_t len, unsigned long flags);
 	struct dma_async_tx_descriptor *(*device_prep_dma_zero_sum)(
 		struct dma_chan *chan, dma_addr_t *src,	unsigned int src_cnt,
-		size_t len, u32 *result, unsigned long flags);
+		size_t len, enum sum_check_flags *result, unsigned long flags);
 	struct dma_async_tx_descriptor *(*device_prep_dma_memset)(
 		struct dma_chan *chan, dma_addr_t dest, int value, size_t len,
 		unsigned long flags);

