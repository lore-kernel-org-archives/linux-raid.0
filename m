From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v3 12/14] async_tx: add support for asynchronous RAID6
	recovery operations
Date: Sat, 29 Aug 2009 19:31:02 -0700
Message-ID: <20090830023102.5934.35228.stgit@dwillia2-linux.ch.intel.com>
References: <20090830022908.5934.72142.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090830022908.5934.72142.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: Andre Noll <maan@systemlinux.org>, David Woodhouse <David.Woodhouse@intel.com>, Ilya Yanok <yanok@emcraft.com>, Maciej Sosnowski <maciej.sosnowski@intel.com>, linux-kernel@vger.kernel.org, Yuri Tikhonov <yur@emcraft.com>, linux-raid@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
List-Id: linux-raid.ids

 async_raid6_2data_recov() recovers two data disk failures

 async_raid6_datap_recov() recovers a data disk and the P disk

These routines are a port of the synchronous versions found in
drivers/md/raid6recov.c.  The primary difference is breaking out the xor
operations into separate calls to async_xor.  Two helper routines are
introduced to perform scalar multiplication where needed.
async_sum_product() multiplies two sources by scalar coefficients and
then sums (xor) the result.  async_mult() simply multiplies a single
source by a scalar.

This implemention also includes, in contrast to the original
synchronous-only code, special case handling for the 4-disk and 5-disk
array cases.  In these situations the default N-disk algorithm will
present 0-source or 1-source operations to dma devices.  To cover for
dma devices where the minimum source count is 2 we implement 4-disk and
5-disk handling in the recovery code.

[ Impact: asynchronous raid6 recovery routines for 2data and datap cases ]

Cc: Yuri Tikhonov <yur@emcraft.com>
Cc: Ilya Yanok <yanok@emcraft.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: David Woodhouse <David.Woodhouse@intel.com>
Reviewed-by: Andre Noll <maan@systemlinux.org>
Acked-by: Maciej Sosnowski <maciej.sosnowski@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 Documentation/crypto/async-tx-api.txt |    4 
 crypto/async_tx/Kconfig               |    5 
 crypto/async_tx/Makefile              |    1 
 crypto/async_tx/async_raid6_recov.c   |  448 +++++++++++++++++++++++++++++++++
 include/linux/async_tx.h              |    8 +
 5 files changed, 466 insertions(+), 0 deletions(-)
 create mode 100644 crypto/async_tx/async_raid6_recov.c

diff --git a/Documentation/crypto/async-tx-api.txt b/Documentation/crypto/async-tx-api.txt
index 0e48e05..ba046b8 100644
--- a/Documentation/crypto/async-tx-api.txt
+++ b/Documentation/crypto/async-tx-api.txt
@@ -67,6 +67,10 @@ xor_val - xor a series of source buffers and set a flag if the
 pq	- generate the p+q (raid6 syndrome) from a series of source buffers
 pq_val  - validate that a p and or q buffer are in sync with a given series of
 	  sources
+datap	- (raid6_datap_recov) recover a raid6 data block and the p block
+	  from the given sources
+2data	- (raid6_2data_recov) recover 2 raid6 data blocks from the given
+	  sources
 
 3.3 Descriptor management:
 The return value is non-NULL and points to a 'descriptor' when the operation
diff --git a/crypto/async_tx/Kconfig b/crypto/async_tx/Kconfig
index cb6d731..e5aeb2b 100644
--- a/crypto/async_tx/Kconfig
+++ b/crypto/async_tx/Kconfig
@@ -18,3 +18,8 @@ config ASYNC_PQ
 	tristate
 	select ASYNC_CORE
 
+config ASYNC_RAID6_RECOV
+	tristate
+	select ASYNC_CORE
+	select ASYNC_PQ
+
diff --git a/crypto/async_tx/Makefile b/crypto/async_tx/Makefile
index 1b99265..9a1a768 100644
--- a/crypto/async_tx/Makefile
+++ b/crypto/async_tx/Makefile
@@ -3,3 +3,4 @@ obj-$(CONFIG_ASYNC_MEMCPY) += async_memcpy.o
 obj-$(CONFIG_ASYNC_MEMSET) += async_memset.o
 obj-$(CONFIG_ASYNC_XOR) += async_xor.o
 obj-$(CONFIG_ASYNC_PQ) += async_pq.o
+obj-$(CONFIG_ASYNC_RAID6_RECOV) += async_raid6_recov.o
diff --git a/crypto/async_tx/async_raid6_recov.c b/crypto/async_tx/async_raid6_recov.c
new file mode 100644
index 0000000..0c14d48
--- /dev/null
+++ b/crypto/async_tx/async_raid6_recov.c
@@ -0,0 +1,448 @@
+/*
+ * Asynchronous RAID-6 recovery calculations ASYNC_TX API.
+ * Copyright(c) 2009 Intel Corporation
+ *
+ * based on raid6recov.c:
+ *   Copyright 2002 H. Peter Anvin
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
+ * this program; if not, write to the Free Software Foundation, Inc., 51
+ * Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ */
+#include <linux/kernel.h>
+#include <linux/interrupt.h>
+#include <linux/dma-mapping.h>
+#include <linux/raid/pq.h>
+#include <linux/async_tx.h>
+
+static struct dma_async_tx_descriptor *
+async_sum_product(struct page *dest, struct page **srcs, unsigned char *coef,
+		  size_t len, struct async_submit_ctl *submit)
+{
+	struct dma_chan *chan = async_tx_find_channel(submit, DMA_PQ,
+						      &dest, 1, srcs, 2, len);
+	struct dma_device *dma = chan ? chan->device : NULL;
+	const u8 *amul, *bmul;
+	u8 ax, bx;
+	u8 *a, *b, *c;
+
+	if (dma) {
+		dma_addr_t dma_dest[2];
+		dma_addr_t dma_src[2];
+		struct device *dev = dma->dev;
+		struct dma_async_tx_descriptor *tx;
+		enum dma_ctrl_flags dma_flags = DMA_PREP_PQ_DISABLE_P;
+
+		dma_dest[1] = dma_map_page(dev, dest, 0, len, DMA_BIDIRECTIONAL);
+		dma_src[0] = dma_map_page(dev, srcs[0], 0, len, DMA_TO_DEVICE);
+		dma_src[1] = dma_map_page(dev, srcs[1], 0, len, DMA_TO_DEVICE);
+		tx = dma->device_prep_dma_pq(chan, dma_dest, dma_src, 2, coef,
+					     len, dma_flags);
+		if (tx) {
+			async_tx_submit(chan, tx, submit);
+			return tx;
+		}
+	}
+
+	/* run the operation synchronously */
+	async_tx_quiesce(&submit->depend_tx);
+	amul = raid6_gfmul[coef[0]];
+	bmul = raid6_gfmul[coef[1]];
+	a = page_address(srcs[0]);
+	b = page_address(srcs[1]);
+	c = page_address(dest);
+
+	while (len--) {
+		ax    = amul[*a++];
+		bx    = bmul[*b++];
+		*c++ = ax ^ bx;
+	}
+
+	return NULL;
+}
+
+static struct dma_async_tx_descriptor *
+async_mult(struct page *dest, struct page *src, u8 coef, size_t len,
+	   struct async_submit_ctl *submit)
+{
+	struct dma_chan *chan = async_tx_find_channel(submit, DMA_PQ,
+						      &dest, 1, &src, 1, len);
+	struct dma_device *dma = chan ? chan->device : NULL;
+	const u8 *qmul; /* Q multiplier table */
+	u8 *d, *s;
+
+	if (dma) {
+		dma_addr_t dma_dest[2];
+		dma_addr_t dma_src[1];
+		struct device *dev = dma->dev;
+		struct dma_async_tx_descriptor *tx;
+		enum dma_ctrl_flags dma_flags = DMA_PREP_PQ_DISABLE_P;
+
+		dma_dest[1] = dma_map_page(dev, dest, 0, len, DMA_BIDIRECTIONAL);
+		dma_src[0] = dma_map_page(dev, src, 0, len, DMA_TO_DEVICE);
+		tx = dma->device_prep_dma_pq(chan, dma_dest, dma_src, 1, &coef,
+					     len, dma_flags);
+		if (tx) {
+			async_tx_submit(chan, tx, submit);
+			return tx;
+		}
+	}
+
+	/* no channel available, or failed to allocate a descriptor, so
+	 * perform the operation synchronously
+	 */
+	async_tx_quiesce(&submit->depend_tx);
+	qmul  = raid6_gfmul[coef];
+	d = page_address(dest);
+	s = page_address(src);
+
+	while (len--)
+		*d++ = qmul[*s++];
+
+	return NULL;
+}
+
+static struct dma_async_tx_descriptor *
+__2data_recov_4(size_t bytes, int faila, int failb, struct page **blocks,
+	      struct async_submit_ctl *submit)
+{
+	struct dma_async_tx_descriptor *tx = NULL;
+	struct page *p, *q, *a, *b;
+	struct page *srcs[2];
+	unsigned char coef[2];
+	enum async_tx_flags flags = submit->flags;
+	dma_async_tx_callback cb_fn = submit->cb_fn;
+	void *cb_param = submit->cb_param;
+	void *scribble = submit->scribble;
+
+	p = blocks[4-2];
+	q = blocks[4-1];
+
+	a = blocks[faila];
+	b = blocks[failb];
+
+	/* in the 4 disk case P + Pxy == P and Q + Qxy == Q */
+	/* Dx = A*(P+Pxy) + B*(Q+Qxy) */
+	srcs[0] = p;
+	srcs[1] = q;
+	coef[0] = raid6_gfexi[failb-faila];
+	coef[1] = raid6_gfinv[raid6_gfexp[faila]^raid6_gfexp[failb]];
+	init_async_submit(submit, 0, tx, NULL, NULL, scribble);
+	tx = async_sum_product(b, srcs, coef, bytes, submit);
+
+	/* Dy = P+Pxy+Dx */
+	srcs[0] = p;
+	srcs[1] = b;
+	init_async_submit(submit, flags | ASYNC_TX_XOR_ZERO_DST, tx, cb_fn,
+			  cb_param, scribble);
+	tx = async_xor(a, srcs, 0, 2, bytes, submit);
+
+	return tx;
+
+}
+
+static struct dma_async_tx_descriptor *
+__2data_recov_5(size_t bytes, int faila, int failb, struct page **blocks,
+	      struct async_submit_ctl *submit)
+{
+	struct dma_async_tx_descriptor *tx = NULL;
+	struct page *p, *q, *g, *dp, *dq;
+	struct page *srcs[2];
+	unsigned char coef[2];
+	enum async_tx_flags flags = submit->flags;
+	dma_async_tx_callback cb_fn = submit->cb_fn;
+	void *cb_param = submit->cb_param;
+	void *scribble = submit->scribble;
+	int uninitialized_var(good);
+	int i;
+
+	for (i = 0; i < 3; i++) {
+		if (i == faila || i == failb)
+			continue;
+		else {
+			good = i;
+			break;
+		}
+	}
+	BUG_ON(i >= 3);
+
+	p = blocks[5-2];
+	q = blocks[5-1];
+	g = blocks[good];
+
+	/* Compute syndrome with zero for the missing data pages
+	 * Use the dead data pages as temporary storage for delta p and
+	 * delta q
+	 */
+	dp = blocks[faila];
+	dq = blocks[failb];
+
+	init_async_submit(submit, 0, tx, NULL, NULL, scribble);
+	tx = async_memcpy(dp, g, 0, 0, bytes, submit);
+	init_async_submit(submit, 0, tx, NULL, NULL, scribble);
+	tx = async_mult(dq, g, raid6_gfexp[good], bytes, submit);
+
+	/* compute P + Pxy */
+	srcs[0] = dp;
+	srcs[1] = p;
+	init_async_submit(submit, ASYNC_TX_XOR_DROP_DST, tx, NULL, NULL,
+			  scribble);
+	tx = async_xor(dp, srcs, 0, 2, bytes, submit);
+
+	/* compute Q + Qxy */
+	srcs[0] = dq;
+	srcs[1] = q;
+	init_async_submit(submit, ASYNC_TX_XOR_DROP_DST, tx, NULL, NULL,
+			  scribble);
+	tx = async_xor(dq, srcs, 0, 2, bytes, submit);
+
+	/* Dx = A*(P+Pxy) + B*(Q+Qxy) */
+	srcs[0] = dp;
+	srcs[1] = dq;
+	coef[0] = raid6_gfexi[failb-faila];
+	coef[1] = raid6_gfinv[raid6_gfexp[faila]^raid6_gfexp[failb]];
+	init_async_submit(submit, 0, tx, NULL, NULL, scribble);
+	tx = async_sum_product(dq, srcs, coef, bytes, submit);
+
+	/* Dy = P+Pxy+Dx */
+	srcs[0] = dp;
+	srcs[1] = dq;
+	init_async_submit(submit, flags | ASYNC_TX_XOR_DROP_DST, tx, cb_fn,
+			  cb_param, scribble);
+	tx = async_xor(dp, srcs, 0, 2, bytes, submit);
+
+	return tx;
+}
+
+static struct dma_async_tx_descriptor *
+__2data_recov_n(int disks, size_t bytes, int faila, int failb,
+	      struct page **blocks, struct async_submit_ctl *submit)
+{
+	struct dma_async_tx_descriptor *tx = NULL;
+	struct page *p, *q, *dp, *dq;
+	struct page *srcs[2];
+	unsigned char coef[2];
+	enum async_tx_flags flags = submit->flags;
+	dma_async_tx_callback cb_fn = submit->cb_fn;
+	void *cb_param = submit->cb_param;
+	void *scribble = submit->scribble;
+
+	p = blocks[disks-2];
+	q = blocks[disks-1];
+
+	/* Compute syndrome with zero for the missing data pages
+	 * Use the dead data pages as temporary storage for
+	 * delta p and delta q
+	 */
+	dp = blocks[faila];
+	blocks[faila] = (void *)raid6_empty_zero_page;
+	blocks[disks-2] = dp;
+	dq = blocks[failb];
+	blocks[failb] = (void *)raid6_empty_zero_page;
+	blocks[disks-1] = dq;
+
+	init_async_submit(submit, 0, tx, NULL, NULL, scribble);
+	tx = async_gen_syndrome(blocks, 0, disks, bytes, submit);
+
+	/* Restore pointer table */
+	blocks[faila]   = dp;
+	blocks[failb]   = dq;
+	blocks[disks-2] = p;
+	blocks[disks-1] = q;
+
+	/* compute P + Pxy */
+	srcs[0] = dp;
+	srcs[1] = p;
+	init_async_submit(submit, ASYNC_TX_XOR_DROP_DST, tx, NULL, NULL,
+			  scribble);
+	tx = async_xor(dp, srcs, 0, 2, bytes, submit);
+
+	/* compute Q + Qxy */
+	srcs[0] = dq;
+	srcs[1] = q;
+	init_async_submit(submit, ASYNC_TX_XOR_DROP_DST, tx, NULL, NULL,
+			  scribble);
+	tx = async_xor(dq, srcs, 0, 2, bytes, submit);
+
+	/* Dx = A*(P+Pxy) + B*(Q+Qxy) */
+	srcs[0] = dp;
+	srcs[1] = dq;
+	coef[0] = raid6_gfexi[failb-faila];
+	coef[1] = raid6_gfinv[raid6_gfexp[faila]^raid6_gfexp[failb]];
+	init_async_submit(submit, 0, tx, NULL, NULL, scribble);
+	tx = async_sum_product(dq, srcs, coef, bytes, submit);
+
+	/* Dy = P+Pxy+Dx */
+	srcs[0] = dp;
+	srcs[1] = dq;
+	init_async_submit(submit, flags | ASYNC_TX_XOR_DROP_DST, tx, cb_fn,
+			  cb_param, scribble);
+	tx = async_xor(dp, srcs, 0, 2, bytes, submit);
+
+	return tx;
+}
+
+/**
+ * async_raid6_2data_recov - asynchronously calculate two missing data blocks
+ * @disks: number of disks in the RAID-6 array
+ * @bytes: block size
+ * @faila: first failed drive index
+ * @failb: second failed drive index
+ * @blocks: array of source pointers where the last two entries are p and q
+ * @submit: submission/completion modifiers
+ */
+struct dma_async_tx_descriptor *
+async_raid6_2data_recov(int disks, size_t bytes, int faila, int failb,
+			struct page **blocks, struct async_submit_ctl *submit)
+{
+	BUG_ON(faila == failb);
+	if (failb < faila)
+		swap(faila, failb);
+
+	pr_debug("%s: disks: %d len: %zu\n", __func__, disks, bytes);
+
+	/* we need to preserve the contents of 'blocks' for the async
+	 * case, so punt to synchronous if a scribble buffer is not available
+	 */
+	if (!submit->scribble) {
+		void **ptrs = (void **) blocks;
+		int i;
+
+		async_tx_quiesce(&submit->depend_tx);
+		for (i = 0; i < disks; i++)
+			ptrs[i] = page_address(blocks[i]);
+
+		raid6_2data_recov(disks, bytes, faila, failb, ptrs);
+
+		async_tx_sync_epilog(submit);
+
+		return NULL;
+	}
+
+	switch (disks) {
+	case 4:
+		/* dma devices do not uniformly understand a zero source pq
+		 * operation (in contrast to the synchronous case), so
+		 * explicitly handle the 4 disk special case
+		 */
+		return __2data_recov_4(bytes, faila, failb, blocks, submit);
+	case 5:
+		/* dma devices do not uniformly understand a single
+		 * source pq operation (in contrast to the synchronous
+		 * case), so explicitly handle the 5 disk special case
+		 */
+		return __2data_recov_5(bytes, faila, failb, blocks, submit);
+	default:
+		return __2data_recov_n(disks, bytes, faila, failb, blocks, submit);
+	}
+}
+EXPORT_SYMBOL_GPL(async_raid6_2data_recov);
+
+/**
+ * async_raid6_datap_recov - asynchronously calculate a data and the 'p' block
+ * @disks: number of disks in the RAID-6 array
+ * @bytes: block size
+ * @faila: failed drive index
+ * @blocks: array of source pointers where the last two entries are p and q
+ * @submit: submission/completion modifiers
+ */
+struct dma_async_tx_descriptor *
+async_raid6_datap_recov(int disks, size_t bytes, int faila,
+			struct page **blocks, struct async_submit_ctl *submit)
+{
+	struct dma_async_tx_descriptor *tx = NULL;
+	struct page *p, *q, *dq;
+	u8 coef;
+	enum async_tx_flags flags = submit->flags;
+	dma_async_tx_callback cb_fn = submit->cb_fn;
+	void *cb_param = submit->cb_param;
+	void *scribble = submit->scribble;
+	struct page *srcs[2];
+
+	pr_debug("%s: disks: %d len: %zu\n", __func__, disks, bytes);
+
+	/* we need to preserve the contents of 'blocks' for the async
+	 * case, so punt to synchronous if a scribble buffer is not available
+	 */
+	if (!scribble) {
+		void **ptrs = (void **) blocks;
+		int i;
+
+		async_tx_quiesce(&submit->depend_tx);
+		for (i = 0; i < disks; i++)
+			ptrs[i] = page_address(blocks[i]);
+
+		raid6_datap_recov(disks, bytes, faila, ptrs);
+
+		async_tx_sync_epilog(submit);
+
+		return NULL;
+	}
+
+	p = blocks[disks-2];
+	q = blocks[disks-1];
+
+	/* Compute syndrome with zero for the missing data page
+	 * Use the dead data page as temporary storage for delta q
+	 */
+	dq = blocks[faila];
+	blocks[faila] = (void *)raid6_empty_zero_page;
+	blocks[disks-1] = dq;
+
+	/* in the 4 disk case we only need to perform a single source
+	 * multiplication
+	 */
+	if (disks == 4) {
+		int good = faila == 0 ? 1 : 0;
+		struct page *g = blocks[good];
+
+		init_async_submit(submit, 0, tx, NULL, NULL, scribble);
+		tx = async_memcpy(p, g, 0, 0, bytes, submit);
+
+		init_async_submit(submit, 0, tx, NULL, NULL, scribble);
+		tx = async_mult(dq, g, raid6_gfexp[good], bytes, submit);
+	} else {
+		init_async_submit(submit, 0, tx, NULL, NULL, scribble);
+		tx = async_gen_syndrome(blocks, 0, disks, bytes, submit);
+	}
+
+	/* Restore pointer table */
+	blocks[faila]   = dq;
+	blocks[disks-1] = q;
+
+	/* calculate g^{-faila} */
+	coef = raid6_gfinv[raid6_gfexp[faila]];
+
+	srcs[0] = dq;
+	srcs[1] = q;
+	init_async_submit(submit, ASYNC_TX_XOR_DROP_DST, tx, NULL, NULL,
+			  scribble);
+	tx = async_xor(dq, srcs, 0, 2, bytes, submit);
+
+	init_async_submit(submit, 0, tx, NULL, NULL, scribble);
+	tx = async_mult(dq, dq, coef, bytes, submit);
+
+	srcs[0] = p;
+	srcs[1] = dq;
+	init_async_submit(submit, flags | ASYNC_TX_XOR_DROP_DST, tx, cb_fn,
+			  cb_param, scribble);
+	tx = async_xor(p, srcs, 0, 2, bytes, submit);
+
+	return tx;
+}
+EXPORT_SYMBOL_GPL(async_raid6_datap_recov);
+
+MODULE_AUTHOR("Dan Williams <dan.j.williams@intel.com>");
+MODULE_DESCRIPTION("asynchronous RAID-6 recovery api");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/async_tx.h b/include/linux/async_tx.h
index e6ce5f0..866e61c 100644
--- a/include/linux/async_tx.h
+++ b/include/linux/async_tx.h
@@ -194,5 +194,13 @@ async_syndrome_val(struct page **blocks, unsigned int offset, int src_cnt,
 		   size_t len, enum sum_check_flags *pqres, struct page *spare,
 		   struct async_submit_ctl *submit);
 
+struct dma_async_tx_descriptor *
+async_raid6_2data_recov(int src_num, size_t bytes, int faila, int failb,
+			struct page **ptrs, struct async_submit_ctl *submit);
+
+struct dma_async_tx_descriptor *
+async_raid6_datap_recov(int src_num, size_t bytes, int faila,
+			struct page **ptrs, struct async_submit_ctl *submit);
+
 void async_tx_quiesce(struct dma_async_tx_descriptor **tx);
 #endif /* _ASYNC_TX_H_ */

