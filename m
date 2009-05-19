From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v2 08/11] async_tx: add support for asynchronous GF
	multiplication
Date: Mon, 18 May 2009 18:00:07 -0700
Message-ID: <20090519010006.4104.70181.stgit@dwillia2-linux.ch.intel.com>
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

[ Based on an original patch by Yuri Tikhonov ]

This adds support for doing asynchronous GF multiplication by adding
two additional functions to the async_tx API:

 async_gen_syndrome() does simultaneous XOR and Galois field
    multiplication of sources.

 async_syndrome_val() validates the given source buffers against known P
    and Q values.

When a request is made to run async_pq against more than the hardware
maximum number of supported sources we need to reuse the previous
generated P and Q values as sources into the next operation.  Care must
be taken to remove Q from P' and P from Q'.  For example to perform a 5
source pq op with hardware that only supports 4 sources at a time the
following approach is taken:

p, q = PQ(src0, src1, src2, src3, COEF({01}, {02}, {04}, {08}))
p', q' = PQ(p, q, q, src4, COEF({00}, {01}, {00}, {10}))

p' = p + q + q + src4 = p + src4
q' = {00}*p + {01}*q + {00}*q + {10}*src4 = q + {10}*src4

Note: 4 is the minimum acceptable maxpq otherwise we punt to
synchronous-software path.

The DMA_PREP_CONTINUE flag indicates to the driver to reuse p and q as
sources (in the above manner) and fill the remaining slots up to maxpq
with the new sources/coefficients.

Note: Some devices have native support for P+Q continuation and can skip
this extra work.  Devices with this capability can advertise it with
dma_set_maxpq.  It is up to each driver how the DMA_PREP_CONTINUE flag
is honored.

Signed-off-by: Yuri Tikhonov <yur@emcraft.com>
Signed-off-by: Ilya Yanok <yanok@emcraft.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/arm/mach-iop13xx/setup.c |    2 
 crypto/async_tx/Kconfig       |    4 
 crypto/async_tx/Makefile      |    1 
 crypto/async_tx/async_pq.c    |  399 +++++++++++++++++++++++++++++++++++++++++
 crypto/async_tx/async_xor.c   |    2 
 drivers/dma/dmaengine.c       |    4 
 drivers/dma/iop-adma.c        |    2 
 include/linux/async_tx.h      |    9 +
 include/linux/dmaengine.h     |   58 +++++-
 9 files changed, 472 insertions(+), 9 deletions(-)
 create mode 100644 crypto/async_tx/async_pq.c

diff --git a/arch/arm/mach-iop13xx/setup.c b/arch/arm/mach-iop13xx/setup.c
index 9800228..2e7ca0d 100644
--- a/arch/arm/mach-iop13xx/setup.c
+++ b/arch/arm/mach-iop13xx/setup.c
@@ -506,7 +506,7 @@ void __init iop13xx_platform_init(void)
 			dma_cap_set(DMA_MEMSET, plat_data->cap_mask);
 			dma_cap_set(DMA_MEMCPY_CRC32C, plat_data->cap_mask);
 			dma_cap_set(DMA_INTERRUPT, plat_data->cap_mask);
-			dma_cap_set(DMA_PQ_XOR, plat_data->cap_mask);
+			dma_cap_set(DMA_PQ, plat_data->cap_mask);
 			dma_cap_set(DMA_PQ_UPDATE, plat_data->cap_mask);
 			dma_cap_set(DMA_PQ_VAL, plat_data->cap_mask);
 			break;
diff --git a/crypto/async_tx/Kconfig b/crypto/async_tx/Kconfig
index d8fb391..cb6d731 100644
--- a/crypto/async_tx/Kconfig
+++ b/crypto/async_tx/Kconfig
@@ -14,3 +14,7 @@ config ASYNC_MEMSET
 	tristate
 	select ASYNC_CORE
 
+config ASYNC_PQ
+	tristate
+	select ASYNC_CORE
+
diff --git a/crypto/async_tx/Makefile b/crypto/async_tx/Makefile
index 27baa7d..1b99265 100644
--- a/crypto/async_tx/Makefile
+++ b/crypto/async_tx/Makefile
@@ -2,3 +2,4 @@ obj-$(CONFIG_ASYNC_CORE) += async_tx.o
 obj-$(CONFIG_ASYNC_MEMCPY) += async_memcpy.o
 obj-$(CONFIG_ASYNC_MEMSET) += async_memset.o
 obj-$(CONFIG_ASYNC_XOR) += async_xor.o
+obj-$(CONFIG_ASYNC_PQ) += async_pq.o
diff --git a/crypto/async_tx/async_pq.c b/crypto/async_tx/async_pq.c
new file mode 100644
index 0000000..195e6cf
--- /dev/null
+++ b/crypto/async_tx/async_pq.c
@@ -0,0 +1,399 @@
+/*
+ * Copyright(c) 2007 Yuri Tikhonov <yur@emcraft.com>
+ * Copyright(c) 2009 Intel Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc., 59
+ * Temple Place - Suite 330, Boston, MA  02111-1307, USA.
+ *
+ * The full GNU General Public License is included in this distribution in the
+ * file called COPYING.
+ */
+#include <linux/kernel.h>
+#include <linux/interrupt.h>
+#include <linux/dma-mapping.h>
+#include <linux/raid/pq.h>
+#include <linux/async_tx.h>
+
+/**
+ * spare_pages - synchronous zero sum result buffers
+ *
+ * Protected by spare_lock
+ */
+static struct page *spare_pages[2];
+static spinlock_t spare_lock;
+
+/**
+ * scribble - space to hold throwaway P buffer for synchronous gen_syndrome
+ */
+static struct page *scribble;
+
+static bool is_raid6_zero_block(struct page *p)
+{
+	return p == (void *) raid6_empty_zero_page;
+}
+
+/* the struct page *blocks[] parameter passed to async_gen_syndrome()
+ * and async_syndrome_val() contains the 'P' destination address at
+ * blocks[disks-2] and the 'Q' destination address at blocks[disks-1]
+ *
+ * note: these are macros as they are used a lvalues
+ */
+#define P(b, d) (b[d-2])
+#define Q(b, d) (b[d-1])
+
+/**
+ * do_async_gen_syndrome - asynchronously calculate P and/or Q
+ */
+static __async_inline struct dma_async_tx_descriptor *
+do_async_gen_syndrome(struct dma_chan *chan, struct page **blocks,
+		      const unsigned char *scfs, unsigned int offset, int disks,
+		      size_t len, dma_addr_t *dma_src,
+		      struct async_submit_ctl *submit)
+{
+	struct dma_async_tx_descriptor *tx = NULL;
+	struct dma_device *dma = chan->device;
+	enum dma_ctrl_flags dma_flags = 0;
+	enum async_tx_flags flags_orig = submit->flags;
+	dma_async_tx_callback cb_fn_orig = submit->cb_fn;
+	dma_async_tx_callback cb_param_orig = submit->cb_param;
+	int src_cnt = disks - 2;
+	unsigned char coefs[src_cnt];
+	unsigned short pq_src_cnt;
+	dma_addr_t dma_dest[2];
+	int src_off = 0;
+	int idx;
+	int i;
+
+	/* DMAs use destinations as sources, so use BIDIRECTIONAL mapping */
+	if (P(blocks, disks))
+		dma_dest[0] = dma_map_page(dma->dev, P(blocks, disks), offset,
+					   len, DMA_BIDIRECTIONAL);
+	else
+		dma_flags |= DMA_PREP_PQ_DISABLE_P;
+	if (Q(blocks, disks))
+		dma_dest[1] = dma_map_page(dma->dev, Q(blocks, disks), offset,
+					   len, DMA_BIDIRECTIONAL);
+	else
+		dma_flags |= DMA_PREP_PQ_DISABLE_Q;
+
+	/* convert source addresses being careful to collapse 'empty'
+	 * sources and update the coefficients accordingly
+	 */
+	for (i = 0, idx = 0; i < src_cnt; i++) {
+		if (is_raid6_zero_block(blocks[i]))
+			continue;
+		dma_src[idx] = dma_map_page(dma->dev, blocks[i], offset, len,
+					    DMA_TO_DEVICE);
+		coefs[idx] = scfs[i];
+		idx++;
+	}
+	src_cnt = idx;
+
+	while (src_cnt > 0) {
+		submit->flags = flags_orig;
+		pq_src_cnt = min(src_cnt, dma_maxpq(dma, dma_flags));
+		/* if we are submitting additional pqs, leave the chain open,
+		 * clear the callback parameters, and leave the destination
+		 * buffers mapped
+		 */
+		if (src_cnt > pq_src_cnt) {
+			submit->flags &= ~ASYNC_TX_ACK;
+			dma_flags |= DMA_COMPL_SKIP_DEST_UNMAP;
+			submit->cb_fn = NULL;
+			submit->cb_param = NULL;
+		} else {
+			dma_flags &= ~DMA_COMPL_SKIP_DEST_UNMAP;
+			submit->cb_fn = cb_fn_orig;
+			submit->cb_param = cb_param_orig;
+		}
+		if (submit->cb_fn)
+			dma_flags |= DMA_PREP_INTERRUPT;
+
+		/* Since we have clobbered the src_list we are committed
+		 * to doing this asynchronously.  Drivers force forward
+		 * progress in case they can not provide a descriptor
+		 */
+		for (;;) {
+			tx = dma->device_prep_dma_pq(chan, dma_dest,
+						     &dma_src[src_off],
+						     pq_src_cnt,
+						     &coefs[src_off], len,
+						     dma_flags);
+			if (likely(tx))
+				break;
+			async_tx_quiesce(&submit->depend_tx);
+			dma_async_issue_pending(chan);
+		}
+
+		async_tx_submit(chan, tx, submit);
+		submit->depend_tx = tx;
+
+		/* drop completed sources */
+		src_cnt -= pq_src_cnt;
+		src_off += pq_src_cnt;
+
+		dma_flags |= DMA_PREP_CONTINUE;
+	}
+
+	return tx;
+}
+
+/**
+ * do_sync_gen_syndrome - synchronously calculate a raid6 syndrome
+ */
+static void
+do_sync_gen_syndrome(struct page **blocks, unsigned int offset, int disks,
+		     size_t len, struct async_submit_ctl *submit)
+{
+	void **srcs;
+	int i;
+
+	if (submit->scribble)
+		srcs = (void **) submit->scribble;
+	else
+		srcs = (void **) blocks;
+
+	for (i = 0; i < disks; i++) {
+		if (is_raid6_zero_block(blocks[i])) {
+			BUG_ON(i > disks - 3); /* P or Q can't be zero */
+			srcs[i] = (void *) blocks[i];
+		} else
+			srcs[i] = page_address(blocks[i]) + offset;
+	}
+	raid6_call.gen_syndrome(disks, len, srcs);
+	async_tx_sync_epilog(submit);
+}
+
+/**
+ * async_gen_syndrome - asynchronously calculate a raid6 syndrome
+ * @blocks: source blocks from idx 0..disks-3, P @ disks-2 and Q @ disks-1
+ * @offset: common offset into each block (src and dest) to start transaction
+ * @disks: number of blocks (including missing P or Q, see below)
+ * @len: length of operation in bytes
+ * @submit: submission/completion modifiers
+ *
+ * General note: This routine assumes a field of GF(2^8) with a
+ * primitive polynomial of 0x11d and a generator of {02}.
+ *
+ * 'disks' note: callers can optionally omit either P or Q (but not
+ * both) from the calculation by setting blocks[disks-2] or
+ * blocks[disks-1] to NULL.  When P or Q is omitted 'len' must be <=
+ * PAGE_SIZE as a temporary buffer of this size is used in the
+ * synchronous path.  'disks' always accounts for both destination
+ * buffers.
+ *
+ * 'blocks' note: if submit->scribble is NULL then the contents of
+ * 'blocks' may be overridden
+ */
+struct dma_async_tx_descriptor *
+async_gen_syndrome(struct page **blocks, unsigned int offset, int disks,
+		   size_t len, struct async_submit_ctl *submit)
+{
+	int src_cnt = disks - 2;
+	struct dma_chan *chan = async_tx_find_channel(submit, DMA_PQ,
+						      &P(blocks, disks), 2,
+						      blocks, src_cnt, len);
+	struct dma_device *device = chan ? chan->device : NULL;
+	dma_addr_t *dma_src = NULL;
+
+	BUG_ON(disks > 255 || !(P(blocks, disks) || Q(blocks, disks)));
+
+	if (submit->scribble)
+		dma_src = submit->scribble;
+	else if (sizeof(dma_addr_t) <= sizeof(struct page *))
+		dma_src = (dma_addr_t *) blocks;
+
+	if (dma_src && device &&
+	    (src_cnt <= dma_maxpq(device, 0) ||
+	     dma_maxpq(device, DMA_PREP_CONTINUE) > 0)) {
+		/* run the p+q asynchronously */
+		pr_debug("%s: (async) len: %zu\n", __func__, len);
+		return do_async_gen_syndrome(chan, blocks, raid6_gfexp, offset,
+					     disks, len, dma_src, submit);
+	}
+
+	/* run the pq synchronously */
+	pr_debug("%s: (sync) len: %zu\n", __func__, len);
+
+	/* wait for any prerequisite operations */
+	async_tx_quiesce(&submit->depend_tx);
+
+	if (!P(blocks, disks)) {
+		P(blocks, disks) = scribble;
+		BUG_ON(len + offset > PAGE_SIZE);
+	}
+	if (!Q(blocks, disks)) {
+		Q(blocks, disks) = scribble;
+		BUG_ON(len + offset > PAGE_SIZE);
+	}
+	do_sync_gen_syndrome(blocks, offset, disks, len, submit);
+
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(async_gen_syndrome);
+
+/**
+ * async_syndrome_val - asynchronously validate a raid6 syndrome
+ * @blocks: source blocks from idx 0..disks-3, P @ disks-2 and Q @ disks-1
+ * @offset: common offset into each block (src and dest) to start transaction
+ * @disks: number of blocks (including missing P or Q, see below)
+ * @len: length of operation in bytes
+ * @pqres: on val failure SUM_CHECK_P_RESULT and/or SUM_CHECK_Q_RESULT are set
+ * @submit: submission / completion modifiers
+ *
+ * The same notes from async_gen_syndrome apply to the 'blocks',
+ * and 'disks' parameters of this routine.
+ */
+struct dma_async_tx_descriptor *
+async_syndrome_val(struct page **blocks, unsigned int offset, int disks,
+		   size_t len, enum sum_check_flags *pqres,
+		   struct async_submit_ctl *submit)
+{
+	struct dma_chan *chan = async_tx_find_channel(submit, DMA_PQ_VAL,
+						      NULL, 0,  blocks, disks,
+						      len);
+	struct dma_device *device = chan ? chan->device : NULL;
+	struct dma_async_tx_descriptor *tx = NULL;
+	enum dma_ctrl_flags dma_flags = submit->cb_fn ? DMA_PREP_INTERRUPT : 0;
+	dma_addr_t *dma_src = NULL;
+
+	BUG_ON(disks < 4);
+
+	if (submit->scribble)
+		dma_src = submit->scribble;
+	else if (sizeof(dma_addr_t) <= sizeof(struct page *))
+		dma_src = (dma_addr_t *) blocks;
+
+	if (dma_src && device && disks <= dma_maxpq(device, 0)) {
+		struct device *dev = device->dev;
+		dma_addr_t *pq = &dma_src[disks-2];
+		int i;
+
+		pr_debug("%s: (async) len: %zu\n", __func__, len);
+		if (!P(blocks, disks))
+			dma_flags |= DMA_PREP_PQ_DISABLE_P;
+		if (!Q(blocks, disks))
+			dma_flags |= DMA_PREP_PQ_DISABLE_Q;
+		for (i = 0; i < disks; i++)
+			if (likely(blocks[i])) {
+				BUG_ON(is_raid6_zero_block(blocks[i]));
+				dma_src[i] = dma_map_page(dev, blocks[i],
+							  offset, len,
+							  DMA_TO_DEVICE);
+			}
+
+		for (;;) {
+			tx = device->device_prep_dma_pq_val(chan, pq, dma_src,
+							    disks - 2,
+							    raid6_gfexp,
+							    len, pqres,
+							    dma_flags);
+			if (likely(tx))
+				break;
+			async_tx_quiesce(&submit->depend_tx);
+			dma_async_issue_pending(chan);
+		}
+		async_tx_submit(chan, tx, submit);
+	} else {
+		struct page *p_src = P(blocks, disks);
+		struct page *q_src = Q(blocks, disks);
+		enum async_tx_flags flags_orig = submit->flags;
+		dma_async_tx_callback cb_fn_orig = submit->cb_fn;
+		void *cb_param_orig = submit->cb_param;
+		void *p, *q, *s;
+
+		pr_debug("%s: (sync) len: %zu\n", __func__, len);
+		BUG_ON(len + offset > PAGE_SIZE);
+		submit->flags &= ~ASYNC_TX_ACK;
+		submit->cb_fn = NULL;
+		submit->cb_param = NULL;
+
+		/* recompute the parity into temporary buffers */
+		spin_lock(&spare_lock);
+		P(blocks, disks) = spare_pages[0];
+		Q(blocks, disks) = spare_pages[1];
+		tx = async_gen_syndrome(blocks, offset,
+					disks, len, submit);
+		async_tx_quiesce(&tx);
+
+		/* validate that the existing parity matches the
+		 * temporary result
+		 */
+		*pqres = 0;
+		if (p_src) {
+			p = page_address(p_src) + offset;
+			s = page_address(spare_pages[0]) + offset;
+			*pqres |= !!memcmp(p, s, len) << SUM_CHECK_P;
+		}
+
+		if (q_src) {
+			q = page_address(q_src) + offset;
+			s = page_address(spare_pages[1]) + offset;
+			*pqres |= !!memcmp(q, s, len) << SUM_CHECK_Q;
+		}
+		spin_unlock(&spare_lock);
+
+		/* restore P and Q, but note that if submit->scribble
+		 * was NULL the above call to async_gen_syndrome() will
+		 * have destroyed the contents of 'blocks'
+		 */
+		P(blocks, disks) = p_src;
+		Q(blocks, disks) = q_src;
+
+		submit->cb_fn = cb_fn_orig;
+		submit->cb_param = cb_param_orig;
+		submit->flags = flags_orig;
+		async_tx_sync_epilog(submit);
+	}
+
+	return tx;
+}
+EXPORT_SYMBOL_GPL(async_syndrome_val);
+
+static void safe_put_page(struct page *p)
+{
+	if (p)
+		put_page(p);
+}
+
+static int __init async_pq_init(void)
+{
+	spin_lock_init(&spare_lock);
+
+	spare_pages[0] = alloc_page(GFP_KERNEL);
+	spare_pages[1] = alloc_page(GFP_KERNEL);
+	scribble = alloc_page(GFP_KERNEL);
+
+	if (spare_pages[0] && spare_pages[1] && scribble)
+		return 0;
+
+	safe_put_page(scribble);
+	safe_put_page(spare_pages[1]);
+	safe_put_page(spare_pages[0]);
+	pr_err("%s: failed to allocate required spare pages\n", __func__);
+	return -ENOMEM;
+}
+
+static void __exit async_pq_exit(void)
+{
+	safe_put_page(scribble);
+	safe_put_page(spare_pages[1]);
+	safe_put_page(spare_pages[0]);
+}
+
+module_init(async_pq_init);
+module_exit(async_pq_exit);
+
+MODULE_DESCRIPTION("asynchronous raid6 syndrome generation/validation");
+MODULE_LICENSE("GPL");
diff --git a/crypto/async_tx/async_xor.c b/crypto/async_tx/async_xor.c
index 3bfbbc0..63ee568 100644
--- a/crypto/async_tx/async_xor.c
+++ b/crypto/async_tx/async_xor.c
@@ -62,7 +62,7 @@ do_async_xor(struct dma_chan *chan, struct page *dest, struct page **src_list,
 	while (src_cnt) {
 		submit->flags = flags_orig;
 		dma_flags = 0;
-		xor_src_cnt = min(src_cnt, dma->max_xor);
+		xor_src_cnt = min(src_cnt, (int)dma->max_xor);
 		/* if we are submitting additional xors, leave the chain open,
 		 * clear the callback parameters, and leave the destination
 		 * buffer mapped
diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index 6781e8f..17cd775 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -646,6 +646,10 @@ int dma_async_device_register(struct dma_device *device)
 		!device->device_prep_dma_xor);
 	BUG_ON(dma_has_cap(DMA_XOR_VAL, device->cap_mask) &&
 		!device->device_prep_dma_xor_val);
+	BUG_ON(dma_has_cap(DMA_PQ, device->cap_mask) &&
+		!device->device_prep_dma_pq);
+	BUG_ON(dma_has_cap(DMA_PQ_VAL, device->cap_mask) &&
+		!device->device_prep_dma_pq_val);
 	BUG_ON(dma_has_cap(DMA_MEMSET, device->cap_mask) &&
 		!device->device_prep_dma_memset);
 	BUG_ON(dma_has_cap(DMA_INTERRUPT, device->cap_mask) &&
diff --git a/drivers/dma/iop-adma.c b/drivers/dma/iop-adma.c
index 6ff79a6..4496bc6 100644
--- a/drivers/dma/iop-adma.c
+++ b/drivers/dma/iop-adma.c
@@ -1257,7 +1257,7 @@ static int __devinit iop_adma_probe(struct platform_device *pdev)
 
 	dev_printk(KERN_INFO, &pdev->dev, "Intel(R) IOP: "
 	  "( %s%s%s%s%s%s%s%s%s%s)\n",
-	  dma_has_cap(DMA_PQ_XOR, dma_dev->cap_mask) ? "pq_xor " : "",
+	  dma_has_cap(DMA_PQ, dma_dev->cap_mask) ? "pq " : "",
 	  dma_has_cap(DMA_PQ_UPDATE, dma_dev->cap_mask) ? "pq_update " : "",
 	  dma_has_cap(DMA_PQ_VAL, dma_dev->cap_mask) ? "pq_val " : "",
 	  dma_has_cap(DMA_XOR, dma_dev->cap_mask) ? "xor " : "",
diff --git a/include/linux/async_tx.h b/include/linux/async_tx.h
index 3d21a25..6d80022 100644
--- a/include/linux/async_tx.h
+++ b/include/linux/async_tx.h
@@ -162,5 +162,14 @@ async_memset(struct page *dest, int val, unsigned int offset,
 
 struct dma_async_tx_descriptor *async_trigger_callback(struct async_submit_ctl *submit);
 
+struct dma_async_tx_descriptor *
+async_gen_syndrome(struct page **blocks, unsigned int offset, int src_cnt,
+		   size_t len, struct async_submit_ctl *submit);
+
+struct dma_async_tx_descriptor *
+async_syndrome_val(struct page **blocks, unsigned int offset, int src_cnt,
+		   size_t len, enum sum_check_flags *pqres,
+		   struct async_submit_ctl *submit);
+
 void async_tx_quiesce(struct dma_async_tx_descriptor **tx);
 #endif /* _ASYNC_TX_H_ */
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 02447af..0a05846 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -52,7 +52,7 @@ enum dma_status {
 enum dma_transaction_type {
 	DMA_MEMCPY,
 	DMA_XOR,
-	DMA_PQ_XOR,
+	DMA_PQ,
 	DMA_DUAL_XOR,
 	DMA_PQ_UPDATE,
 	DMA_XOR_VAL,
@@ -70,20 +70,28 @@ enum dma_transaction_type {
 
 /**
  * enum dma_ctrl_flags - DMA flags to augment operation preparation,
- * 	control completion, and communicate status.
+ *  control completion, and communicate status.
  * @DMA_PREP_INTERRUPT - trigger an interrupt (callback) upon completion of
- * 	this transaction
+ *  this transaction
  * @DMA_CTRL_ACK - the descriptor cannot be reused until the client
- * 	acknowledges receipt, i.e. has has a chance to establish any
- * 	dependency chains
+ *  acknowledges receipt, i.e. has has a chance to establish any dependency
+ *  chains
  * @DMA_COMPL_SKIP_SRC_UNMAP - set to disable dma-unmapping the source buffer(s)
  * @DMA_COMPL_SKIP_DEST_UNMAP - set to disable dma-unmapping the destination(s)
+ * @DMA_PREP_PQ_DISABLE_P - prevent generation of P while generating Q
+ * @DMA_PREP_PQ_DISABLE_Q - prevent generation of Q while generating P
+ * @DMA_PREP_CONTINUE - indicate to a driver that it is reusing buffers as
+ *  sources that were the result of a previous operation, in the case of a PQ
+ *  operation it continues the calculation with new sources
  */
 enum dma_ctrl_flags {
 	DMA_PREP_INTERRUPT = (1 << 0),
 	DMA_CTRL_ACK = (1 << 1),
 	DMA_COMPL_SKIP_SRC_UNMAP = (1 << 2),
 	DMA_COMPL_SKIP_DEST_UNMAP = (1 << 3),
+	DMA_PREP_PQ_DISABLE_P = (1 << 4),
+	DMA_PREP_PQ_DISABLE_Q = (1 << 5),
+	DMA_PREP_CONTINUE = (1 << 6),
 };
 
 /**
@@ -226,6 +234,7 @@ struct dma_async_tx_descriptor {
  * @global_node: list_head for global dma_device_list
  * @cap_mask: one or more dma_capability flags
  * @max_xor: maximum number of xor sources, 0 if no capability
+ * @max_pq: maximum number of PQ sources and PQ-continue capability
  * @dev_id: unique device ID
  * @dev: struct device reference for dma mapping api
  * @device_alloc_chan_resources: allocate resources and return the
@@ -234,6 +243,8 @@ struct dma_async_tx_descriptor {
  * @device_prep_dma_memcpy: prepares a memcpy operation
  * @device_prep_dma_xor: prepares a xor operation
  * @device_prep_dma_xor_val: prepares a xor validation operation
+ * @device_prep_dma_pq: prepares a pq operation
+ * @device_prep_dma_pq_val: prepares a pqzero_sum operation
  * @device_prep_dma_memset: prepares a memset operation
  * @device_prep_dma_interrupt: prepares an end of chain interrupt operation
  * @device_prep_slave_sg: prepares a slave dma operation
@@ -248,7 +259,9 @@ struct dma_device {
 	struct list_head channels;
 	struct list_head global_node;
 	dma_cap_mask_t  cap_mask;
-	int max_xor;
+	unsigned short max_xor;
+	unsigned short max_pq;
+	#define DMA_HAS_PQ_CONTINUE (1 << 15)
 
 	int dev_id;
 	struct device *dev;
@@ -265,6 +278,14 @@ struct dma_device {
 	struct dma_async_tx_descriptor *(*device_prep_dma_xor_val)(
 		struct dma_chan *chan, dma_addr_t *src,	unsigned int src_cnt,
 		size_t len, enum sum_check_flags *result, unsigned long flags);
+	struct dma_async_tx_descriptor *(*device_prep_dma_pq)(
+		struct dma_chan *chan, dma_addr_t *dst, dma_addr_t *src,
+		unsigned int src_cnt, const unsigned char *scf,
+		size_t len, unsigned long flags);
+	struct dma_async_tx_descriptor *(*device_prep_dma_pq_val)(
+		struct dma_chan *chan, dma_addr_t *pq, dma_addr_t *src,
+		unsigned int src_cnt, const unsigned char *scf, size_t len,
+		enum sum_check_flags *pqres, unsigned long flags);
 	struct dma_async_tx_descriptor *(*device_prep_dma_memset)(
 		struct dma_chan *chan, dma_addr_t dest, int value, size_t len,
 		unsigned long flags);
@@ -283,6 +304,31 @@ struct dma_device {
 	void (*device_issue_pending)(struct dma_chan *chan);
 };
 
+static inline void dma_set_maxpq(struct dma_device *dma, int maxpq, int has_pq_continue)
+{
+	dma->max_pq = maxpq;
+	if (has_pq_continue)
+		dma->max_pq |= DMA_HAS_PQ_CONTINUE;
+}
+
+/* dma_maxpq - reduce maxpq in the face of continued operations
+ * @dma - dma device with PQ capability
+ * @flags - to determine if DMA_PREP_CONTINUE is set
+ *
+ * When an engine does not support native continuation we need 3 extra
+ * source slots to reuse P and Q with the following coefficients:
+ * 1/ {00} * P : remove P from Q', but use it as a source for P'
+ * 2/ {01} * Q : use Q to continue Q' calculation
+ * 3/ {00} * Q : subtract Q from P' to cancel (2)
+ */
+static inline int dma_maxpq(struct dma_device *dma, enum dma_ctrl_flags flags)
+{
+	if ((flags & DMA_PREP_CONTINUE) &&
+	    (dma->max_pq & DMA_HAS_PQ_CONTINUE) == 0)
+		return dma->max_pq - 3;
+	return dma->max_pq & ~DMA_HAS_PQ_CONTINUE;
+}
+
 /* --- public DMA engine API --- */
 
 #ifdef CONFIG_DMA_ENGINE

