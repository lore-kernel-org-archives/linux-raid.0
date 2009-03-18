From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 06/13] async_tx: add support for asynchronous GF multiplication
Date: Wed, 18 Mar 2009 12:20:47 -0700
Message-ID: <20090318192046.20375.89854.stgit@dwillia2-linux.ch.intel.com>
References: <20090318191248.20375.40560.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090318191248.20375.40560.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: neilb@suse.de, maciej.sosnowski@intel.com, Ilya Yanok <yanok@emcraft.com>, Yuri Tikhonov <yur@emcraft.com>
List-Id: linux-raid.ids

[ Based on an original patch by Yuri Tikhonov ]

This adds support for doing asynchronous GF multiplication by adding
four additional functions to the async_tx API:

 async_pq() does simultaneous XOR of sources and XOR of sources
  GF-multiplied by given coefficients.

 async_pq_zero_sum() checks if results of calculations match given
  ones.

 async_gen_syndrome() does simultaneous XOR and R/S syndrome of sources.

 async_syndrome_zerosum() checks if results of XOR/syndrome calculation
  matches given ones.

Latter two functions just use async_pq() with the appropriate coefficients
in asynchronous case but have significant optimizations in the synchronous
case.

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
with the new sources/coeffecients.

In the zero_sum case decrement max_pq by two to account for the implied
additional p and q sources.

Note: Some devices can natively support P+Q continuation and can skip
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
 crypto/async_tx/async_pq.c    |  590 +++++++++++++++++++++++++++++++++++++++++
 crypto/async_tx/async_xor.c   |    2 
 drivers/dma/iop-adma.c        |    2 
 include/linux/async_tx.h      |   33 ++
 include/linux/dmaengine.h     |   58 ++++
 8 files changed, 681 insertions(+), 11 deletions(-)
 create mode 100644 crypto/async_tx/async_pq.c

diff --git a/arch/arm/mach-iop13xx/setup.c b/arch/arm/mach-iop13xx/setup.c
index cfd4d2e..3846482 100644
--- a/arch/arm/mach-iop13xx/setup.c
+++ b/arch/arm/mach-iop13xx/setup.c
@@ -506,7 +506,7 @@ void __init iop13xx_platform_init(void)
 			dma_cap_set(DMA_MEMSET, plat_data->cap_mask);
 			dma_cap_set(DMA_MEMCPY_CRC32C, plat_data->cap_mask);
 			dma_cap_set(DMA_INTERRUPT, plat_data->cap_mask);
-			dma_cap_set(DMA_PQ_XOR, plat_data->cap_mask);
+			dma_cap_set(DMA_PQ, plat_data->cap_mask);
 			dma_cap_set(DMA_PQ_UPDATE, plat_data->cap_mask);
 			dma_cap_set(DMA_PQ_ZERO_SUM, plat_data->cap_mask);
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
index 0000000..da47a29
--- /dev/null
+++ b/crypto/async_tx/async_pq.c
@@ -0,0 +1,590 @@
+/*
+ *	Copyright(c) 2007 Yuri Tikhonov <yur@emcraft.com>
+ *	Copyright(c) 2009 Intel Corporation
+ *
+ *	Developed for DENX Software Engineering GmbH
+ *
+ *	Asynchronous GF-XOR calculations ASYNC_TX API.
+ *
+ *	based on async_xor.c code written by:
+ *		Dan Williams <dan.j.williams@intel.com>
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
+/* scribble - space to hold throwaway P buffer for synchronous gen_syndrome */
+static struct page *scribble;
+
+static bool is_raid6_zero_block(void *p)
+{
+	return p == (void *) raid6_empty_zero_page;
+}
+
+/**
+ * do_async_pq - asynchronously calculate P and/or Q
+ */
+static __async_inline struct dma_async_tx_descriptor *
+do_async_pq(struct dma_chan *chan, struct page **blocks, unsigned char *scfs,
+	    unsigned int offset, int src_cnt, size_t len,
+	    enum async_tx_flags flags,
+	    struct dma_async_tx_descriptor *depend_tx,
+	    dma_async_tx_callback cb_fn, void *cb_param)
+{
+	struct dma_device *dma = chan->device;
+	dma_addr_t dma_dest[2], dma_src[src_cnt];
+	struct dma_async_tx_descriptor *tx = NULL;
+	dma_async_tx_callback _cb_fn;
+	void *_cb_param;
+	unsigned char *scf = NULL;
+	int i, src_off = 0;
+	unsigned short pq_src_cnt;
+	enum async_tx_flags async_flags;
+	enum dma_ctrl_flags dma_flags = 0;
+	int idx;
+	u8 coefs[src_cnt];
+
+	/* DMAs use destinations as sources, so use BIDIRECTIONAL mapping */
+	if (blocks[src_cnt])
+		dma_dest[0] = dma_map_page(dma->dev, blocks[src_cnt],
+					   offset, len, DMA_BIDIRECTIONAL);
+	else
+		dma_flags |= DMA_PREP_PQ_DISABLE_P;
+	if (blocks[src_cnt+1])
+		dma_dest[1] = dma_map_page(dma->dev, blocks[src_cnt+1],
+					   offset, len, DMA_BIDIRECTIONAL);
+	else
+		dma_flags |= DMA_PREP_PQ_DISABLE_Q;
+
+	/* convert source addresses being careful to collapse 'zero'
+	 * sources and update the coefficients accordingly
+	 */
+	for (i = 0, idx = 0; i < src_cnt; i++) {
+		if (is_raid6_zero_block(blocks[i]))
+			continue;
+		dma_src[idx] = dma_map_page(dma->dev, blocks[i],
+					    offset, len, DMA_TO_DEVICE);
+		coefs[idx] = scfs[i];
+		idx++;
+	}
+	src_cnt = idx;
+
+	while (src_cnt > 0) {
+		async_flags = flags;
+		pq_src_cnt = min(src_cnt, dma_maxpq(dma, flags));
+		/* if we are submitting additional pqs, leave the chain open,
+		 * clear the callback parameters, and leave the destination
+		 * buffers mapped
+		 */
+		if (src_cnt > pq_src_cnt) {
+			async_flags &= ~ASYNC_TX_ACK;
+			dma_flags |= DMA_COMPL_SKIP_DEST_UNMAP;
+			_cb_fn = NULL;
+			_cb_param = NULL;
+		} else {
+			_cb_fn = cb_fn;
+			_cb_param = cb_param;
+		}
+		if (_cb_fn)
+			dma_flags |= DMA_PREP_INTERRUPT;
+		if (scfs)
+			scf = &scfs[src_off];
+
+		/* Since we have clobbered the src_list we are committed
+		 * to doing this asynchronously.  Drivers force forward
+		 * progress in case they can not provide a descriptor
+		 */
+		tx = dma->device_prep_dma_pq(chan, dma_dest,
+					     &dma_src[src_off], pq_src_cnt,
+					     scf, len, dma_flags);
+		if (unlikely(!tx))
+			async_tx_quiesce(&depend_tx);
+
+		/* spin wait for the preceeding transactions to complete */
+		while (unlikely(!tx)) {
+			dma_async_issue_pending(chan);
+			tx = dma->device_prep_dma_pq(chan, dma_dest,
+					&dma_src[src_off], pq_src_cnt,
+					scf, len, dma_flags);
+		}
+
+		async_tx_submit(chan, tx, async_flags, depend_tx,
+				_cb_fn, _cb_param);
+
+		depend_tx = tx;
+		flags |= ASYNC_TX_DEP_ACK;
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
+ * do_sync_pq - synchronously calculate P and Q
+ */
+static void
+do_sync_pq(struct page **blocks, unsigned char *scfs, unsigned int offset,
+	int src_cnt, size_t len, enum async_tx_flags flags,
+	struct dma_async_tx_descriptor *depend_tx,
+	dma_async_tx_callback cb_fn, void *cb_param)
+{
+	u8 *p = NULL;
+	u8 *q = NULL;
+	u8 *ptrs[src_cnt];
+	int d, z;
+	u8 wd, wq, wp;
+
+	/* address convert inputs */
+	if (blocks[src_cnt])
+		p = (u8 *)(page_address(blocks[src_cnt]) + offset);
+	if (blocks[src_cnt+1])
+		q = (u8 *)(page_address(blocks[src_cnt+1]) + offset);
+	for (z = 0; z < src_cnt; z++) {
+		if (is_raid6_zero_block(blocks[z]))
+			ptrs[z] = (void *) blocks[z];
+		else
+			ptrs[z] = (u8 *)(page_address(blocks[z]) + offset);
+	}
+
+	for (d = 0; d < len; d++) {
+		wq = wp = ptrs[0][d];
+		for (z = 1; z < src_cnt; z++) {
+			wd = ptrs[z][d];
+			wp ^= wd;
+			wq ^= raid6_gfmul[scfs[z]][wd];
+		}
+		if (p)
+			p[d] = wp;
+		if (q)
+			q[d] = wq;
+	}
+
+	async_tx_sync_epilog(cb_fn, cb_param);
+}
+
+/**
+ * async_pq - attempt to do XOR and Galois calculations in parallel using
+ *	a dma engine.
+ * @blocks: source block array from 0 to (src_cnt-1) with the p destination
+ *	at blocks[src_cnt] and q at blocks[src_cnt + 1]. Only one of two
+ *	destinations may be present (another then has to be set to NULL).
+ *	NOTE: client code must assume the contents of this array are destroyed
+ * @offset: offset in pages to start transaction
+ * @src_cnt: number of source pages
+ * @scfs: array of source coefficients used in GF-multiplication
+ * @len: length in bytes
+ * @flags: ASYNC_TX_ACK, ASYNC_TX_DEP_ACK, ASYNC_TX_ASYNC_ONLY
+ * @depend_tx: depends on the result of this transaction.
+ * @cb_fn: function to call when the operation completes
+ * @cb_param: parameter to pass to the callback routine
+ */
+struct dma_async_tx_descriptor *
+async_pq(struct page **blocks, unsigned int offset, int src_cnt,
+	 unsigned char *scfs, size_t len, enum async_tx_flags flags,
+	 struct dma_async_tx_descriptor *depend_tx,
+	 dma_async_tx_callback cb_fn, void *cb_param)
+{
+	struct dma_chan *chan = async_tx_find_channel(depend_tx, DMA_PQ,
+					&blocks[src_cnt], 2,
+					blocks, src_cnt, len);
+	struct dma_device *device = chan ? chan->device : NULL;
+	struct dma_async_tx_descriptor *tx = NULL;
+	bool do_async = false;
+
+	if (device && (src_cnt <= dma_maxpq(device, 0) ||
+		       dma_maxpq(device, DMA_PREP_CONTINUE) > 0))
+		do_async = true;
+
+	if (!device && (flags & ASYNC_TX_ASYNC_ONLY))
+		return NULL;
+
+	if (do_async) {
+		/* run pq asynchronously */
+		tx = do_async_pq(chan, blocks, scfs, offset, src_cnt, len,
+				 flags, depend_tx, cb_fn, cb_param);
+	} else {
+		/* run pq synchronously */
+		if (!blocks[src_cnt+1]) { /* only p requested, just xor */
+			flags |= ASYNC_TX_XOR_ZERO_DST;
+			return async_xor(blocks[src_cnt], blocks, offset,
+					 src_cnt, len, flags, depend_tx,
+					 cb_fn, cb_param);
+		}
+
+		/* wait for any prerequisite operations */
+		async_tx_quiesce(&depend_tx);
+
+		do_sync_pq(blocks, scfs, offset, src_cnt, len, flags,
+			depend_tx, cb_fn, cb_param);
+	}
+
+	return tx;
+}
+EXPORT_SYMBOL_GPL(async_pq);
+
+/**
+ * do_sync_gen_syndrome - synchronously calculate P (xor) and Q (Reed-Solomon
+ *	code)
+ */
+static void
+do_sync_gen_syndrome(struct page **blocks, unsigned int offset, int src_cnt,
+	size_t len, enum async_tx_flags flags,
+	struct dma_async_tx_descriptor *depend_tx,
+	dma_async_tx_callback cb_fn, void *cb_param)
+{
+	int i;
+	void *tsrc[src_cnt+2];
+
+	for (i = 0; i < src_cnt + 2; i++) {
+		if (is_raid6_zero_block(blocks[i]))
+			tsrc[i] = (void *) blocks[i];
+		else
+			tsrc[i] = page_address(blocks[i]) + offset;
+	}
+
+	raid6_call.gen_syndrome(i, len, tsrc);
+
+	async_tx_sync_epilog(cb_fn, cb_param);
+}
+
+/**
+ * async_gen_syndrome - attempt to generate P (xor) and Q (Reed-Solomon code)
+ *	with a dma engine for a given set of blocks.  This routine assumes a
+ *	field of GF(2^8) with a primitive polynomial of 0x11d and a generator
+ *	of {02}.
+ * @blocks: source block array ordered from 0..src_cnt-1 with the P destination
+ *	at blocks[src_cnt] and Q at blocks[src_cnt + 1]. Only one of two
+ *	destinations may be present (another then has to be set to NULL).  Some
+ *	raid6 schemes calculate the syndrome over all disks with P and Q set to
+ *	zero.  In this case we catch 'zero' blocks with is_raid6_zero_block()
+ *	so we can drop them in the async case, or skip the page_address()
+ *	conversion in the sync case.
+ *	NOTE: client code must assume the contents of this array are destroyed
+ * @offset: offset in pages to start transaction
+ * @src_cnt: number of source pages: 2 < src_cnt <= 255
+ * @len: length of blocks in bytes
+ * @flags: ASYNC_TX_ACK, ASYNC_TX_DEP_ACK, ASYNC_TX_ASYNC_ONLY
+ * @depend_tx: P+Q operation depends on the result of this transaction.
+ * @cb_fn: function to call when P+Q generation completes
+ * @cb_param: parameter to pass to the callback routine
+ */
+struct dma_async_tx_descriptor *
+async_gen_syndrome(struct page **blocks, unsigned int offset, int src_cnt,
+		   size_t len, enum async_tx_flags flags,
+		   struct dma_async_tx_descriptor *depend_tx,
+		   dma_async_tx_callback cb_fn, void *cb_param)
+{
+	struct dma_chan *chan = async_tx_find_channel(depend_tx, DMA_PQ,
+						     &blocks[src_cnt], 2,
+						     blocks, src_cnt, len);
+	struct dma_device *device = chan ? chan->device : NULL;
+	struct dma_async_tx_descriptor *tx = NULL;
+	bool do_async = false;
+
+	BUG_ON(src_cnt > 255 || (!blocks[src_cnt] && !blocks[src_cnt+1]));
+
+	if (device && (src_cnt <= dma_maxpq(device, 0) ||
+		       dma_maxpq(device, DMA_PREP_CONTINUE) > 0))
+		do_async = true;
+
+	if (!do_async && (flags & ASYNC_TX_ASYNC_ONLY))
+		return NULL;
+
+	if (do_async) {
+		/* run the p+q asynchronously */
+		tx = do_async_pq(chan, blocks, (uint8_t *)raid6_gfexp,
+				 offset, src_cnt, len, flags, depend_tx,
+				 cb_fn, cb_param);
+	} else {
+		/* run the pq synchronously */
+		/* wait for any prerequisite operations */
+		async_tx_quiesce(&depend_tx);
+
+		if (!blocks[src_cnt])
+			blocks[src_cnt] = scribble;
+		if (!blocks[src_cnt+1])
+			blocks[src_cnt+1] = scribble;
+		do_sync_gen_syndrome(blocks, offset, src_cnt, len, flags,
+				     depend_tx, cb_fn, cb_param);
+	}
+
+	return tx;
+}
+EXPORT_SYMBOL_GPL(async_gen_syndrome);
+
+static __async_inline enum dma_ctrl_flags
+__pq_zero_sum_map_pages(dma_addr_t *dma, int src_cnt, struct device *dev,
+			struct page **blocks, unsigned int offset, size_t len)
+{
+	enum dma_ctrl_flags flags = 0;
+	int i;
+
+	if (!blocks[src_cnt])
+		flags |= DMA_PREP_PQ_DISABLE_P;
+	if (!blocks[src_cnt+1])
+		flags |= DMA_PREP_PQ_DISABLE_Q;
+	for (i = 0; i < src_cnt + 2; i++)
+		if (likely(blocks[i])) {
+			dma[i] = dma_map_page(dev, blocks[i], offset, len,
+					      DMA_TO_DEVICE);
+			BUG_ON(is_raid6_zero_block(blocks[i]));
+		}
+	return flags;
+}
+
+/**
+ * async_pq_zero_sum - attempt a PQ parities check with a dma engine.
+ * @blocks: array of source pages. The 0..src_cnt-1 are the sources, the
+ *	src_cnt and src_cnt+1 are the P and Q destinations to check, resp.
+ *	Only one of two destinations may be present.
+ *	NOTE: client code must assume the contents of this array are destroyed
+ * @offset: offset in pages to start transaction
+ * @src_cnt: number of source pages
+ * @scfs: coefficients to use in GF-multiplications
+ * @len: length in bytes
+ * @pqres: SUM_CHECK_P_RESULT and/or SUM_CHECK_Q_RESULT are set on zero sum fail
+ * @flags: ASYNC_TX_ACK, ASYNC_TX_DEP_ACK
+ * @depend_tx: depends on the result of this transaction.
+ * @cb_fn: function to call when the xor completes
+ * @cb_param: parameter to pass to the callback routine
+ */
+struct dma_async_tx_descriptor *
+async_pq_zero_sum(struct page **blocks, unsigned int offset, int src_cnt,
+		  unsigned char *scfs, size_t len, enum sum_check_flags *pqres,
+		  enum async_tx_flags flags,
+		  struct dma_async_tx_descriptor *depend_tx,
+		  dma_async_tx_callback cb_fn, void *cb_param)
+{
+	struct dma_chan *chan = async_tx_find_channel(depend_tx,
+						      DMA_PQ_ZERO_SUM,
+						      &blocks[src_cnt], 2,
+						      blocks, src_cnt, len);
+	struct dma_device *device = chan ? chan->device : NULL;
+	struct dma_async_tx_descriptor *tx = NULL;
+	enum dma_ctrl_flags dma_flags = cb_fn ? DMA_PREP_INTERRUPT : 0;
+
+	BUG_ON(src_cnt < 2);
+
+	if (device && src_cnt <= dma_maxpq(device, 0) - 2) {
+		dma_addr_t dma_src[src_cnt + 2];
+
+		dma_flags |= __pq_zero_sum_map_pages(dma_src, src_cnt,
+						     device->dev, blocks,
+						     offset, len);
+		tx = device->device_prep_dma_pqzero_sum(chan, dma_src, src_cnt,
+							scfs, len, pqres,
+							dma_flags);
+
+		if (unlikely(!tx)) {
+			async_tx_quiesce(&depend_tx);
+
+			while (unlikely(!tx)) {
+				dma_async_issue_pending(chan);
+				tx = device->device_prep_dma_pqzero_sum(chan,
+						dma_src, src_cnt, scfs, len,
+						pqres, dma_flags);
+			}
+		}
+
+		async_tx_submit(chan, tx, flags, depend_tx, cb_fn, cb_param);
+	} else {
+		struct page *pdest = blocks[src_cnt];
+		struct page *qdest = blocks[src_cnt + 1];
+		void *p, *q, *s;
+
+		flags &= ~ASYNC_TX_ACK;
+
+		spin_lock(&spare_lock);
+		blocks[src_cnt] = spare_pages[0];
+		blocks[src_cnt + 1] = spare_pages[1];
+		tx = async_pq(blocks, offset, src_cnt, scfs, len, flags,
+			      depend_tx, NULL, NULL);
+		async_tx_quiesce(&tx);
+
+		*pqres = 0;
+		if (pdest) {
+			p = page_address(pdest) + offset;
+			s = page_address(spare_pages[0]) + offset;
+			*pqres |= !!memcmp(p, s, len) << SUM_CHECK_P;
+		}
+
+		if (qdest) {
+			q = page_address(qdest) + offset;
+			s = page_address(spare_pages[1]) + offset;
+			*pqres |= !!memcmp(q, s, len) << SUM_CHECK_Q;
+		}
+		spin_unlock(&spare_lock);
+
+		async_tx_sync_epilog(cb_fn, cb_param);
+	}
+
+	return tx;
+}
+EXPORT_SYMBOL_GPL(async_pq_zero_sum);
+
+/**
+ * async_syndrome_zero_sum - attempt a P (xor) and Q (Reed-Solomon code)
+ *	parities check with a dma engine. This routine assumes a field of
+ *	GF(2^8) with a primitive polynomial of 0x11d and a generator of {02}.
+ * @blocks: array of source pages. The 0..src_cnt-1 are the sources, the
+ *	src_cnt and src_cnt+1 are the P and Q destinations to check, resp.
+ *	Only one of two destinations may be present.
+ *	NOTE: client code must assume the contents of this array are destroyed
+ * @offset: offset in pages to start transaction
+ * @src_cnt: number of source pages
+ * @len: length in bytes
+ * @pqres: SUM_CHECK_P_RESULT and/or SUM_CHECK_Q_RESULT are set on zero sum fail
+ * @flags: ASYNC_TX_ACK, ASYNC_TX_DEP_ACK
+ * @depend_tx: depends on the result of this transaction.
+ * @cb_fn: function to call when the xor completes
+ * @cb_param: parameter to pass to the callback routine
+ */
+struct dma_async_tx_descriptor *
+async_syndrome_zero_sum(struct page **blocks, unsigned int offset, int src_cnt,
+			size_t len, enum sum_check_flags *pqres,
+			enum async_tx_flags flags,
+			struct dma_async_tx_descriptor *depend_tx,
+			dma_async_tx_callback cb_fn, void *cb_param)
+{
+	struct dma_chan *chan = async_tx_find_channel(depend_tx,
+						      DMA_PQ_ZERO_SUM,
+						      &blocks[src_cnt], 2,
+						      blocks, src_cnt, len);
+	struct dma_device *device = chan ? chan->device : NULL;
+	struct dma_async_tx_descriptor *tx = NULL;
+	enum dma_ctrl_flags dma_flags = cb_fn ? DMA_PREP_INTERRUPT : 0;
+
+	BUG_ON(src_cnt < 2);
+
+	if (device && src_cnt <= dma_maxpq(device, 0) - 2) {
+		dma_addr_t dma_src[src_cnt + 2];
+
+		dma_flags |= __pq_zero_sum_map_pages(dma_src, src_cnt,
+						     device->dev, blocks,
+						     offset, len);
+		tx = device->device_prep_dma_pqzero_sum(chan, dma_src, src_cnt,
+							(uint8_t *)raid6_gfexp,
+							len, pqres, dma_flags);
+
+		if (unlikely(!tx)) {
+			async_tx_quiesce(&depend_tx);
+			while (unlikely(!tx)) {
+				dma_async_issue_pending(chan);
+				tx = device->device_prep_dma_pqzero_sum(chan,
+						dma_src, src_cnt,
+						(uint8_t *)raid6_gfexp, len,
+						pqres, dma_flags);
+			}
+		}
+
+		async_tx_submit(chan, tx, flags, depend_tx, cb_fn, cb_param);
+	} else {
+		struct page *pdest = blocks[src_cnt];
+		struct page *qdest = blocks[src_cnt + 1];
+		enum async_tx_flags lflags = flags;
+		void *p, *q, *s;
+
+		lflags &= ~ASYNC_TX_ACK;
+
+		spin_lock(&spare_lock);
+		blocks[src_cnt] = spare_pages[0];
+		blocks[src_cnt + 1] = spare_pages[1];
+		tx = async_gen_syndrome(blocks, offset,
+					src_cnt, len, lflags,
+					depend_tx, NULL, NULL);
+		async_tx_quiesce(&tx);
+
+		*pqres = 0;
+		if (pdest) {
+			p = page_address(pdest) + offset;
+			s = page_address(spare_pages[0]) + offset;
+			*pqres |= !!memcmp(p, s, len) << SUM_CHECK_P;
+		}
+
+		if (qdest) {
+			q = page_address(qdest) + offset;
+			s = page_address(spare_pages[1]) + offset;
+			*pqres |= !!memcmp(q, s, len) << SUM_CHECK_Q;
+		}
+		spin_unlock(&spare_lock);
+
+		async_tx_sync_epilog(cb_fn, cb_param);
+	}
+
+	return tx;
+}
+EXPORT_SYMBOL_GPL(async_syndrome_zero_sum);
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
+	if (!spare_pages[0])
+		goto abort;
+	spare_pages[1] = alloc_page(GFP_KERNEL);
+	if (!spare_pages[1])
+		goto abort;
+	scribble = alloc_page(GFP_KERNEL);
+	if (!scribble)
+		goto abort;
+	return 0;
+abort:
+	safe_put_page(scribble);
+	safe_put_page(spare_pages[1]);
+	safe_put_page(spare_pages[0]);
+	printk(KERN_ERR "%s: cannot allocate spare!\n", __func__);
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
+MODULE_AUTHOR("Yuri Tikhonov <yur@emcraft.com>, Dan Williams <dan.j.williams@intel.com>");
+MODULE_DESCRIPTION("asynchronous pq/pq-zero-sum api");
+MODULE_LICENSE("GPL");
diff --git a/crypto/async_tx/async_xor.c b/crypto/async_tx/async_xor.c
index d1a084e..fcd6be5 100644
--- a/crypto/async_tx/async_xor.c
+++ b/crypto/async_tx/async_xor.c
@@ -65,7 +65,7 @@ do_async_xor(struct dma_chan *chan, struct page *dest, struct page **src_list,
 	while (src_cnt) {
 		async_flags = flags;
 		dma_flags = 0;
-		xor_src_cnt = min(src_cnt, dma->max_xor);
+		xor_src_cnt = min(src_cnt, (int)dma->max_xor);
 		/* if we are submitting additional xors, leave the chain open,
 		 * clear the callback parameters, and leave the destination
 		 * buffer mapped
diff --git a/drivers/dma/iop-adma.c b/drivers/dma/iop-adma.c
index 16adbe6..8bccf85 100644
--- a/drivers/dma/iop-adma.c
+++ b/drivers/dma/iop-adma.c
@@ -1258,7 +1258,7 @@ static int __devinit iop_adma_probe(struct platform_device *pdev)
 
 	dev_printk(KERN_INFO, &pdev->dev, "Intel(R) IOP: "
 	  "( %s%s%s%s%s%s%s%s%s%s)\n",
-	  dma_has_cap(DMA_PQ_XOR, dma_dev->cap_mask) ? "pq_xor " : "",
+	  dma_has_cap(DMA_PQ, dma_dev->cap_mask) ? "pq " : "",
 	  dma_has_cap(DMA_PQ_UPDATE, dma_dev->cap_mask) ? "pq_update " : "",
 	  dma_has_cap(DMA_PQ_ZERO_SUM, dma_dev->cap_mask) ? "pq_zero_sum " : "",
 	  dma_has_cap(DMA_XOR, dma_dev->cap_mask) ? "xor " : "",
diff --git a/include/linux/async_tx.h b/include/linux/async_tx.h
index 6370f32..1f10141 100644
--- a/include/linux/async_tx.h
+++ b/include/linux/async_tx.h
@@ -59,12 +59,15 @@ struct dma_chan_ref {
  * @ASYNC_TX_ACK: immediately ack the descriptor, precludes setting up a
  * dependency chain
  * @ASYNC_TX_DEP_ACK: ack the dependency descriptor.  Useful for chaining.
+ * @ASYNC_TX_ASYNC_ONLY: if set then try to perform operation requested only in
+ * the asynchronous mode. Useful for R6 recovery.
  */
 enum async_tx_flags {
 	ASYNC_TX_XOR_ZERO_DST	 = (1 << 0),
 	ASYNC_TX_XOR_DROP_DST	 = (1 << 1),
-	ASYNC_TX_ACK		 = (1 << 3),
-	ASYNC_TX_DEP_ACK	 = (1 << 4),
+	ASYNC_TX_ACK		 = (1 << 2),
+	ASYNC_TX_DEP_ACK	 = (1 << 3),
+	ASYNC_TX_ASYNC_ONLY	 = (1 << 4),
 };
 
 #ifdef CONFIG_DMA_ENGINE
@@ -140,5 +143,31 @@ async_trigger_callback(enum async_tx_flags flags,
 	struct dma_async_tx_descriptor *depend_tx,
 	dma_async_tx_callback cb_fn, void *cb_fn_param);
 
+struct dma_async_tx_descriptor *
+async_pq(struct page **blocks, unsigned int offset, int src_cnt,
+	 unsigned char *scfs, size_t len, enum async_tx_flags flags,
+	 struct dma_async_tx_descriptor *depend_tx,
+	 dma_async_tx_callback cb_fn, void *cb_param);
+
+struct dma_async_tx_descriptor *
+async_gen_syndrome(struct page **blocks, unsigned int offset, int src_cnt,
+		   size_t len, enum async_tx_flags flags,
+		   struct dma_async_tx_descriptor *depend_tx,
+		   dma_async_tx_callback cb_fn, void *cb_param);
+
+struct dma_async_tx_descriptor *
+async_pq_zero_sum(struct page **blocks, unsigned int offset, int src_cnt,
+		  unsigned char *scfs, size_t len, enum sum_check_flags *pqres,
+		  enum async_tx_flags flags,
+		  struct dma_async_tx_descriptor *depend_tx,
+		  dma_async_tx_callback cb_fn, void *cb_param);
+
+struct dma_async_tx_descriptor *
+async_syndrome_zero_sum(struct page **blocks, unsigned int offset, int src_cnt,
+			size_t len, enum sum_check_flags *pqres,
+			enum async_tx_flags flags,
+			struct dma_async_tx_descriptor *depend_tx,
+			dma_async_tx_callback cb_fn, void *cb_param);
+
 void async_tx_quiesce(struct dma_async_tx_descriptor **tx);
 #endif /* _ASYNC_TX_H_ */
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index cd17392..a7fa966 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -55,7 +55,7 @@ enum dma_status {
 enum dma_transaction_type {
 	DMA_MEMCPY,
 	DMA_XOR,
-	DMA_PQ_XOR,
+	DMA_PQ,
 	DMA_DUAL_XOR,
 	DMA_PQ_UPDATE,
 	DMA_ZERO_SUM,
@@ -73,20 +73,28 @@ enum dma_transaction_type {
 
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
@@ -228,6 +236,7 @@ struct dma_async_tx_descriptor {
  * @global_node: list_head for global dma_device_list
  * @cap_mask: one or more dma_capability flags
  * @max_xor: maximum number of xor sources, 0 if no capability
+ * @max_pq: maximum number of PQ sources and PQ-continue capability
  * @dev_id: unique device ID
  * @dev: struct device reference for dma mapping api
  * @device_alloc_chan_resources: allocate resources and return the
@@ -235,7 +244,9 @@ struct dma_async_tx_descriptor {
  * @device_free_chan_resources: release DMA channel's resources
  * @device_prep_dma_memcpy: prepares a memcpy operation
  * @device_prep_dma_xor: prepares a xor operation
+ * @device_prep_dma_pq: prepares a pq operation
  * @device_prep_dma_zero_sum: prepares a zero_sum operation
+ * @device_prep_dma_pqzero_sum: prepares a pqzero_sum operation
  * @device_prep_dma_memset: prepares a memset operation
  * @device_prep_dma_interrupt: prepares an end of chain interrupt operation
  * @device_prep_slave_sg: prepares a slave dma operation
@@ -249,7 +260,9 @@ struct dma_device {
 	struct list_head channels;
 	struct list_head global_node;
 	dma_cap_mask_t  cap_mask;
-	int max_xor;
+	unsigned short max_xor;
+	unsigned short max_pq;
+	#define DMA_HAS_PQ_CONTINUE (1 << 15)
 
 	int dev_id;
 	struct device *dev;
@@ -263,9 +276,17 @@ struct dma_device {
 	struct dma_async_tx_descriptor *(*device_prep_dma_xor)(
 		struct dma_chan *chan, dma_addr_t dest, dma_addr_t *src,
 		unsigned int src_cnt, size_t len, unsigned long flags);
+	struct dma_async_tx_descriptor *(*device_prep_dma_pq)(
+		struct dma_chan *chan, dma_addr_t *dst, dma_addr_t *src,
+		unsigned int src_cnt, unsigned char *scf,
+		size_t len, unsigned long flags);
 	struct dma_async_tx_descriptor *(*device_prep_dma_zero_sum)(
 		struct dma_chan *chan, dma_addr_t *src,	unsigned int src_cnt,
 		size_t len, enum sum_check_flags *result, unsigned long flags);
+	struct dma_async_tx_descriptor *(*device_prep_dma_pqzero_sum)(
+		struct dma_chan *chan, dma_addr_t *src, unsigned int src_cnt,
+		unsigned char *scf, size_t len, enum sum_check_flags *pqres,
+		unsigned long flags);
 	struct dma_async_tx_descriptor *(*device_prep_dma_memset)(
 		struct dma_chan *chan, dma_addr_t dest, int value, size_t len,
 		unsigned long flags);
@@ -284,6 +305,31 @@ struct dma_device {
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

