From: Ilya Yanok <yanok@emcraft.com>
Subject: [PATCH 02/11] async_tx: add support for asynchronous GF multiplication
Date: Thu, 13 Nov 2008 18:15:55 +0300
Message-ID: <1226589364-5619-3-git-send-email-yanok@emcraft.com>
References: <1226589364-5619-1-git-send-email-yanok@emcraft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@ozlabs.org>
In-Reply-To: <1226589364-5619-1-git-send-email-yanok@emcraft.com>
List-Unsubscribe: <https://ozlabs.org/mailman/options/linuxppc-dev>,
	<mailto:linuxppc-dev-request@ozlabs.org?subject=unsubscribe>
List-Archive: <http://ozlabs.org/pipermail/linuxppc-dev>
List-Post: <mailto:linuxppc-dev@ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@ozlabs.org?subject=help>
List-Subscribe: <https://ozlabs.org/mailman/listinfo/linuxppc-dev>,
	<mailto:linuxppc-dev-request@ozlabs.org?subject=subscribe>
Sender: linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@ozlabs.org
Errors-To: linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@ozlabs.org
To: linux-raid@vger.kernel.org
Cc: linuxppc-dev@ozlabs.org, dzu@denx.de, wd@denx.de, Ilya Yanok <yanok@emcraft.com>
List-Id: linux-raid.ids

This adds support for doing asynchronous GF multiplication by adding
four additional functions to async_tx API:
 async_pqxor() does simultaneous XOR of sources and XOR of sources
GF-multiplied by given coefficients.
 async_pqxor_zero_sum() checks if results of calculations match given
ones.
 async_gen_syndrome() does sumultaneous XOR and R/S syndrome of sources.
 async_syndrome_zerosum() checks if results of XOR/syndrome calculation
matches given ones.

Latter two functions just use pqxor with approprite coefficients in
asynchronous case but have significant optimizations if synchronous
case.

To support this API dmaengine driver should set DMA_PQ_XOR and
DMA_PQ_ZERO_SUM capabilities and provide device_prep_dma_pqxor and
device_prep_dma_pqzero_sum methods in dma_device structure.

Signed-off-by: Yuri Tikhonov <yur@emcraft.com>
Signed-off-by: Ilya Yanok <yanok@emcraft.com>
---
 crypto/async_tx/Kconfig       |    4 +
 crypto/async_tx/Makefile      |    1 +
 crypto/async_tx/async_pqxor.c |  532 +++++++++++++++++++++++++++++++++++++++++
 include/linux/async_tx.h      |   31 +++
 include/linux/dmaengine.h     |   11 +
 5 files changed, 579 insertions(+), 0 deletions(-)
 create mode 100644 crypto/async_tx/async_pqxor.c

diff --git a/crypto/async_tx/Kconfig b/crypto/async_tx/Kconfig
index d8fb391..b1705d1 100644
--- a/crypto/async_tx/Kconfig
+++ b/crypto/async_tx/Kconfig
@@ -14,3 +14,7 @@ config ASYNC_MEMSET
 	tristate
 	select ASYNC_CORE
 
+config ASYNC_PQXOR
+	tristate
+	select ASYNC_CORE
+
diff --git a/crypto/async_tx/Makefile b/crypto/async_tx/Makefile
index 27baa7d..32d6ce2 100644
--- a/crypto/async_tx/Makefile
+++ b/crypto/async_tx/Makefile
@@ -2,3 +2,4 @@ obj-$(CONFIG_ASYNC_CORE) += async_tx.o
 obj-$(CONFIG_ASYNC_MEMCPY) += async_memcpy.o
 obj-$(CONFIG_ASYNC_MEMSET) += async_memset.o
 obj-$(CONFIG_ASYNC_XOR) += async_xor.o
+obj-$(CONFIG_ASYNC_PQXOR) += async_pqxor.o
diff --git a/crypto/async_tx/async_pqxor.c b/crypto/async_tx/async_pqxor.c
new file mode 100644
index 0000000..547d72a
--- /dev/null
+++ b/crypto/async_tx/async_pqxor.c
@@ -0,0 +1,532 @@
+/*
+ *	Copyright(c) 2007 Yuri Tikhonov <yur@emcraft.com>
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
+#include <linux/raid/xor.h>
+#include <linux/async_tx.h>
+
+#include "../drivers/md/raid6.h"
+
+/**
+ *  The following static variables are used in cases of synchronous
+ * zero sum to save the values to check. Two pages used for zero sum and
+ * the third one is for dumb P destination when calling gen_syndrome()
+ */
+static spinlock_t spare_lock;
+struct page *spare_pages[3];
+
+/**
+ * do_async_pqxor - asynchronously calculate P and/or Q
+ */
+static struct dma_async_tx_descriptor *
+do_async_pqxor(struct dma_chan *chan, struct page *pdest, struct page *qdest,
+	struct page **src_list, unsigned char *scoef_list,
+	unsigned int offset, unsigned int src_cnt, size_t len,
+	enum async_tx_flags flags, struct dma_async_tx_descriptor *depend_tx,
+	dma_async_tx_callback cb_fn, void *cb_param)
+{
+	struct dma_device *dma = chan->device;
+	struct page *dest;
+	dma_addr_t dma_dest[2];
+	dma_addr_t dma_src[src_cnt];
+	unsigned char *scf = qdest ? scoef_list : NULL;
+	struct dma_async_tx_descriptor *tx;
+	int i, dst_cnt = 0;
+	unsigned long dma_prep_flags = cb_fn ? DMA_PREP_INTERRUPT : 0;
+
+	if (flags & ASYNC_TX_XOR_ZERO_DST)
+		dma_prep_flags |= DMA_PREP_ZERO_DST;
+
+	/*  One parity (P or Q) calculation is initiated always;
+	 * first always try Q
+	 */
+	dest = qdest ? qdest : pdest;
+	dma_dest[dst_cnt++] = dma_map_page(dma->dev, dest, offset, len,
+					    DMA_FROM_DEVICE);
+
+	/* Switch to the next destination */
+	if (qdest && pdest) {
+		/* Both destinations are set, thus here we deal with P */
+		dma_dest[dst_cnt++] = dma_map_page(dma->dev, pdest, offset,
+						len, DMA_FROM_DEVICE);
+	}
+
+	for (i = 0; i < src_cnt; i++)
+		dma_src[i] = dma_map_page(dma->dev, src_list[i],
+			offset, len, DMA_TO_DEVICE);
+
+	/* Since we have clobbered the src_list we are committed
+	 * to doing this asynchronously.  Drivers force forward progress
+	 * in case they can not provide a descriptor
+	 */
+	tx = dma->device_prep_dma_pqxor(chan, dma_dest, dst_cnt, dma_src,
+					   src_cnt, scf, len, dma_prep_flags);
+	if (unlikely(!tx)) {
+		async_tx_quiesce(&depend_tx);
+
+		while (unlikely(!tx)) {
+			dma_async_issue_pending(chan);
+			tx = dma->device_prep_dma_pqxor(chan,
+							   dma_dest, dst_cnt,
+							   dma_src, src_cnt,
+							   scf, len,
+							   dma_prep_flags);
+		}
+	}
+
+	async_tx_submit(chan, tx, flags, depend_tx, cb_fn, cb_param);
+
+	return tx;
+}
+
+/**
+ * do_sync_pqxor - synchronously calculate P and Q
+ */
+static void
+do_sync_pqxor(struct page *pdest, struct page *qdest,
+	struct page **src_list, unsigned char *scoef_list, unsigned int offset,
+	unsigned int src_cnt, size_t len, enum async_tx_flags flags,
+	struct dma_async_tx_descriptor *depend_tx,
+	dma_async_tx_callback cb_fn, void *cb_param)
+{
+	int i, pos;
+	uint8_t *p, *q, *src;
+
+	/* set destination addresses */
+	p = pdest ? (uint8_t *)(page_address(pdest) + offset) : NULL;
+	q = (uint8_t *)(page_address(qdest) + offset);
+
+	if (flags & ASYNC_TX_XOR_ZERO_DST) {
+		if (p)
+			memset(p, 0, len);
+		memset(q, 0, len);
+	}
+
+	for (i = 0; i < src_cnt; i++) {
+		src = (uint8_t *)(page_address(src_list[i]) + offset);
+		for (pos = 0; pos < len; pos++) {
+			if (p)
+				p[pos] ^= src[pos];
+			q[pos] ^= raid6_gfmul[scoef_list[i]][src[pos]];
+		}
+	}
+	async_tx_sync_epilog(cb_fn, cb_param);
+}
+
+/**
+ * async_pqxor - attempt to calculate RS-syndrome and XOR in parallel using
+ *	a dma engine.
+ * @pdest: destination page for P-parity (XOR)
+ * @qdest: destination page for Q-parity (GF-XOR)
+ * @src_list: array of source pages
+ * @src_coef_list: array of source coefficients used in GF-multiplication
+ * @offset: offset in pages to start transaction
+ * @src_cnt: number of source pages
+ * @len: length in bytes
+ * @flags: ASYNC_TX_XOR_ZERO_DST, ASYNC_TX_ASSUME_COHERENT,
+ *	ASYNC_TX_ACK, ASYNC_TX_DEP_ACK, ASYNC_TX_ASYNC_ONLY
+ * @depend_tx: depends on the result of this transaction.
+ * @callback: function to call when the operation completes
+ * @callback_param: parameter to pass to the callback routine
+ */
+struct dma_async_tx_descriptor *
+async_pqxor(struct page *pdest, struct page *qdest,
+	struct page **src_list, unsigned char *scoef_list,
+	unsigned int offset, int src_cnt, size_t len, enum async_tx_flags flags,
+	struct dma_async_tx_descriptor *depend_tx,
+	dma_async_tx_callback callback, void *callback_param)
+{
+	struct page *dest[2];
+	struct dma_chan *chan;
+	struct dma_device *device;
+	struct dma_async_tx_descriptor *tx = NULL;
+
+	BUG_ON(!pdest && !qdest);
+
+	dest[0] = pdest;
+	dest[1] = qdest;
+
+	chan = async_tx_find_channel(depend_tx, DMA_PQ_XOR,
+				     dest, 2, src_list, src_cnt, len);
+	device = chan ? chan->device : NULL;
+
+	if (!device && (flags & ASYNC_TX_ASYNC_ONLY))
+		return NULL;
+
+	if (device) { /* run the xor asynchronously */
+		tx = do_async_pqxor(chan, pdest, qdest, src_list,
+			       scoef_list, offset, src_cnt, len, flags,
+			       depend_tx, callback,callback_param);
+	} else { /* run the pqxor synchronously */
+		if (!qdest) {
+			struct page *tsrc[src_cnt + 1];
+			struct page **lsrc = src_list;
+			if (!(flags & ASYNC_TX_XOR_ZERO_DST)) {
+				tsrc[0] = pdest;
+				memcpy(tsrc + 1, src_list, src_cnt *
+						sizeof(struct page *));
+				lsrc = tsrc;
+				src_cnt++;
+				flags |= ASYNC_TX_XOR_DROP_DST;
+			}
+			return async_xor(pdest, lsrc, offset, src_cnt, len,
+					flags, depend_tx,
+					callback, callback_param);
+		}
+
+		/* wait for any prerequisite operations */
+		async_tx_quiesce(&depend_tx);
+
+		do_sync_pqxor(pdest, qdest, src_list, scoef_list,
+			offset,	src_cnt, len, flags, depend_tx,
+			callback, callback_param);
+	}
+
+	return tx;
+}
+EXPORT_SYMBOL_GPL(async_pqxor);
+
+/**
+ * do_sync_gen_syndrome - synchronously calculate P and Q
+ */
+static void
+do_sync_gen_syndrome(struct page *pdest, struct page *qdest,
+	struct page **src_list, unsigned int offset,
+	unsigned int src_cnt, size_t len, enum async_tx_flags flags,
+	struct dma_async_tx_descriptor *depend_tx,
+	dma_async_tx_callback callback, void *callback_param)
+{
+	int i;
+	void *tsrc[src_cnt + 2];
+
+	for (i = 0; i < src_cnt; i++)
+		tsrc[i] = page_address(src_list[i]) + offset;
+
+	/* set destination addresses */
+	tsrc[i++] = page_address(pdest) + offset;
+	tsrc[i++] = page_address(qdest) + offset;
+
+	if (flags & ASYNC_TX_XOR_ZERO_DST) {
+		memset(tsrc[i-2], 0, len);
+		memset(tsrc[i-1], 0, len);
+	}
+
+	raid6_call.gen_syndrome(i, len, tsrc);
+	async_tx_sync_epilog(callback, callback_param);
+}
+
+/**
+ * async_gen_syndrome - attempt to calculate RS-syndrome and XOR in parallel
+ * using a dma engine.
+ * @pdest: destination page for P-parity (XOR)
+ * @qdest: destination page for Q-parity (GF-XOR)
+ * @src_list: array of source pages
+ * @offset: offset in pages to start transaction
+ * @src_cnt: number of source pages
+ * @len: length in bytes
+ * @flags: ASYNC_TX_XOR_ZERO_DST, ASYNC_TX_ASSUME_COHERENT,
+ *	ASYNC_TX_ACK, ASYNC_TX_DEP_ACK, ASYNC_TX_ASYNC_ONLY
+ * @depend_tx: depends on the result of this transaction.
+ * @callback: function to call when the operation completes
+ * @callback_param: parameter to pass to the callback routine
+ */
+struct dma_async_tx_descriptor *
+async_gen_syndrome(struct page *pdest, struct page *qdest,
+	struct page **src_list,	unsigned int offset, int src_cnt, size_t len,
+	enum async_tx_flags flags, struct dma_async_tx_descriptor *depend_tx,
+	dma_async_tx_callback callback, void *callback_param)
+{
+	struct page *dest[2];
+	struct dma_chan *chan;
+	struct dma_device *device;
+	struct dma_async_tx_descriptor *tx = NULL;
+
+	dest[0] = pdest;
+	dest[1] = qdest;
+
+	chan = async_tx_find_channel(depend_tx, DMA_PQ_XOR,
+				     dest, 2, src_list, src_cnt, len);
+	device = chan ? chan->device : NULL;
+
+	if (!device && (flags & ASYNC_TX_ASYNC_ONLY))
+		return NULL;
+
+	if (device) { /* run the xor asynchronously */
+		tx = do_async_pqxor(chan, pdest, qdest, src_list,
+			       (uint8_t *)raid6_gfexp, offset, src_cnt,
+			       len, flags, depend_tx, callback, callback_param);
+	} else { /* run the pqxor synchronously */
+		if (!qdest) {
+			struct page *tsrc[src_cnt + 1];
+			struct page **lsrc = src_list;
+			if (!(flags & ASYNC_TX_XOR_ZERO_DST)) {
+				tsrc[0] = pdest;
+				memcpy(tsrc + 1, src_list, src_cnt *
+						sizeof(struct page *));
+				lsrc = tsrc;
+				src_cnt++;
+				flags |= ASYNC_TX_XOR_DROP_DST;
+			}
+			return async_xor(pdest, lsrc, offset, src_cnt, len,
+					flags, depend_tx,
+					callback, callback_param);
+		}
+
+		/* may do synchronous PQ only when both destinations exsists */
+		if (!pdest)
+			pdest = spare_pages[2];
+
+		/* wait for any prerequisite operations */
+		async_tx_quiesce(&depend_tx);
+
+		do_sync_gen_syndrome(pdest, qdest, src_list,
+			offset,	src_cnt, len, flags, depend_tx,
+			callback, callback_param);
+	}
+
+	return tx;
+}
+EXPORT_SYMBOL_GPL(async_gen_syndrome);
+
+/**
+ * async_pqxor_zero_sum - attempt a PQ parities check with a dma engine.
+ * @pdest: P-parity destination to check
+ * @qdest: Q-parity destination to check
+ * @src_list: array of source pages; the 1st pointer is qdest, the 2nd - pdest.
+ * @scoef_list: coefficients to use in GF-multiplications
+ * @offset: offset in pages to start transaction
+ * @src_cnt: number of source pages
+ * @len: length in bytes
+ * @presult: 0 if P parity is OK else non-zero
+ * @qresult: 0 if Q parity is OK else non-zero
+ * @flags: ASYNC_TX_ASSUME_COHERENT, ASYNC_TX_ACK, ASYNC_TX_DEP_ACK
+ * @depend_tx: depends on the result of this transaction.
+ * @callback: function to call when the xor completes
+ * @callback_param: parameter to pass to the callback routine
+ */
+struct dma_async_tx_descriptor *
+async_pqxor_zero_sum(struct page *pdest, struct page *qdest,
+	struct page **src_list, unsigned char *scf,
+	unsigned int offset, int src_cnt, size_t len,
+	u32 *presult, u32 *qresult, enum async_tx_flags flags,
+	struct dma_async_tx_descriptor *depend_tx,
+	dma_async_tx_callback cb_fn, void *cb_param)
+{
+	struct dma_chan *chan = async_tx_find_channel(depend_tx,
+						      DMA_PQ_ZERO_SUM,
+						      src_list, 2, &src_list[2],
+						      src_cnt, len);
+	struct dma_device *device = chan ? chan->device : NULL;
+	struct dma_async_tx_descriptor *tx = NULL;
+
+	BUG_ON(src_cnt <= 1);
+	BUG_ON(!qdest || qdest != src_list[0] || pdest != src_list[1]);
+
+	if (device) {
+		dma_addr_t dma_src[src_cnt];
+		unsigned long dma_prep_flags = cb_fn ? DMA_PREP_INTERRUPT : 0;
+		int i;
+
+		for (i = 0; i < src_cnt; i++)
+			dma_src[i] = src_list[i] ? dma_map_page(device->dev,
+					src_list[i], offset, len,
+					DMA_TO_DEVICE) : 0;
+
+		tx = device->device_prep_dma_pqzero_sum(chan, dma_src, src_cnt,
+						      scf, len,
+						      presult, qresult,
+						      dma_prep_flags);
+
+		if (unlikely(!tx)) {
+			async_tx_quiesce(&depend_tx);
+
+			while (unlikely(!tx)) {
+				dma_async_issue_pending(chan);
+				tx = device->device_prep_dma_pqzero_sum(chan,
+						dma_src, src_cnt, scf, len,
+						presult, qresult,
+						dma_prep_flags);
+			}
+		}
+
+		async_tx_submit(chan, tx, flags, depend_tx, cb_fn, cb_param);
+	} else {
+		unsigned long lflags = flags;
+
+		/* TBD: support for lengths size of more than PAGE_SIZE */
+
+		lflags &= ~ASYNC_TX_ACK;
+		lflags |= ASYNC_TX_XOR_ZERO_DST;
+
+		spin_lock(&spare_lock);
+		tx = async_pqxor(spare_pages[0], spare_pages[1],
+				 &src_list[2], scf, offset,
+				 src_cnt - 2, len, lflags,
+				 depend_tx, NULL, NULL);
+
+		async_tx_quiesce(&tx);
+
+		if (presult && pdest)
+			*presult = memcmp(page_address(pdest) + offset,
+					   page_address(spare_pages[0]) +
+					   offset, len) == 0 ? 0 : 1;
+		if (qresult && qdest)
+			*qresult = memcmp(page_address(qdest) + offset,
+					   page_address(spare_pages[1]) +
+					   offset, len) == 0 ? 0 : 1;
+		spin_unlock(&spare_lock);
+	}
+
+	return tx;
+}
+EXPORT_SYMBOL_GPL(async_pqxor_zero_sum);
+
+/**
+ * async_syndrome_zero_sum - attempt a PQ parities check with a dma engine.
+ * @pdest: P-parity destination to check
+ * @qdest: Q-parity destination to check
+ * @src_list: array of source pages; the 1st pointer is qdest, the 2nd - pdest.
+ * @offset: offset in pages to start transaction
+ * @src_cnt: number of source pages
+ * @len: length in bytes
+ * @presult: 0 if P parity is OK else non-zero
+ * @qresult: 0 if Q parity is OK else non-zero
+ * @flags: ASYNC_TX_ASSUME_COHERENT, ASYNC_TX_ACK, ASYNC_TX_DEP_ACK
+ * @depend_tx: depends on the result of this transaction.
+ * @callback: function to call when the xor completes
+ * @callback_param: parameter to pass to the callback routine
+ */
+struct dma_async_tx_descriptor *
+async_syndrome_zero_sum(struct page *pdest, struct page *qdest,
+	struct page **src_list, unsigned int offset, int src_cnt, size_t len,
+	u32 *presult, u32 *qresult, enum async_tx_flags flags,
+	struct dma_async_tx_descriptor *depend_tx,
+	dma_async_tx_callback cb_fn, void *cb_param)
+{
+	struct dma_chan *chan = async_tx_find_channel(depend_tx,
+						      DMA_PQ_ZERO_SUM,
+						      src_list, 2, &src_list[2],
+						      src_cnt, len);
+	struct dma_device *device = chan ? chan->device : NULL;
+	struct dma_async_tx_descriptor *tx = NULL;
+
+	BUG_ON(src_cnt <= 1);
+	BUG_ON(!qdest || qdest != src_list[0] || pdest != src_list[1]);
+
+	if (device) {
+		dma_addr_t dma_src[src_cnt];
+		unsigned long dma_prep_flags = cb_fn ? DMA_PREP_INTERRUPT : 0;
+		int i;
+
+		for (i = 0; i < src_cnt; i++)
+			dma_src[i] = src_list[i] ? dma_map_page(device->dev,
+					src_list[i], offset, len,
+					DMA_TO_DEVICE) : 0;
+
+		tx = device->device_prep_dma_pqzero_sum(chan, dma_src, src_cnt,
+						      (uint8_t *)raid6_gfexp,
+						      len, presult, qresult,
+						      dma_prep_flags);
+
+		if (unlikely(!tx)) {
+			async_tx_quiesce(&depend_tx);
+			while (unlikely(!tx)) {
+				dma_async_issue_pending(chan);
+				tx = device->device_prep_dma_pqzero_sum(chan,
+						dma_src, src_cnt,
+						(uint8_t *)raid6_gfexp, len,
+						presult, qresult,
+						dma_prep_flags);
+			}
+		}
+
+		async_tx_submit(chan, tx, flags, depend_tx, cb_fn, cb_param);
+	} else {
+		unsigned long lflags = flags;
+
+		/* TBD: support for lengths size of more than PAGE_SIZE */
+
+		lflags &= ~ASYNC_TX_ACK;
+		lflags |= ASYNC_TX_XOR_ZERO_DST;
+
+		spin_lock(&spare_lock);
+		tx = async_gen_syndrome(spare_pages[0], spare_pages[1],
+					&src_list[2], offset,
+					src_cnt - 2, len, lflags,
+					depend_tx, NULL, NULL);
+		async_tx_quiesce(&tx);
+
+		if (presult && pdest)
+			*presult = memcmp(page_address(pdest) + offset,
+					   page_address(spare_pages[0]) +
+					   offset, len) == 0 ? 0 : 1;
+		if (qresult && qdest)
+			*qresult = memcmp(page_address(qdest) + offset,
+					   page_address(spare_pages[1]) +
+					   offset, len) == 0 ? 0 : 1;
+		spin_unlock(&spare_lock);
+	}
+
+	return tx;
+}
+EXPORT_SYMBOL_GPL(async_syndrome_zero_sum);
+
+static int __init async_pqxor_init(void)
+{
+	spin_lock_init(&spare_lock);
+
+	spare_pages[0] = alloc_page(GFP_KERNEL);
+	if (!spare_pages[0])
+		goto abort;
+	spare_pages[1] = alloc_page(GFP_KERNEL);
+	if (!spare_pages[1])
+		goto abort;
+	spare_pages[2] = alloc_page(GFP_KERNEL);
+
+	return 0;
+abort:
+	safe_put_page(spare_pages[0]);
+	safe_put_page(spare_pages[1]);
+	printk(KERN_ERR "%s: cannot allocate spare!\n", __func__);
+	return -ENOMEM;
+}
+
+static void __exit async_pqxor_exit(void)
+{
+	safe_put_page(spare_pages[0]);
+	safe_put_page(spare_pages[1]);
+	safe_put_page(spare_pages[2]);
+}
+
+module_init(async_pqxor_init);
+module_exit(async_pqxor_exit);
+
+MODULE_AUTHOR("Yuri Tikhonov <yur@emcraft.com>");
+MODULE_DESCRIPTION("asynchronous qxor/qxor-zero-sum api");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/async_tx.h b/include/linux/async_tx.h
index 0f50d4c..9038b06 100644
--- a/include/linux/async_tx.h
+++ b/include/linux/async_tx.h
@@ -50,12 +50,15 @@ struct dma_chan_ref {
  * @ASYNC_TX_ACK: immediately ack the descriptor, precludes setting up a
  * dependency chain
  * @ASYNC_TX_DEP_ACK: ack the dependency descriptor.  Useful for chaining.
+ * @ASYNC_TX_ASYNC_ONLY: if set then try to perform operation requested in
+ * asynchronous way only.
  */
 enum async_tx_flags {
 	ASYNC_TX_XOR_ZERO_DST	 = (1 << 0),
 	ASYNC_TX_XOR_DROP_DST	 = (1 << 1),
 	ASYNC_TX_ACK		 = (1 << 3),
 	ASYNC_TX_DEP_ACK	 = (1 << 4),
+	ASYNC_TX_ASYNC_ONLY	 = (1 << 5),
 };
 
 #ifdef CONFIG_DMA_ENGINE
@@ -146,5 +149,33 @@ async_trigger_callback(enum async_tx_flags flags,
 	struct dma_async_tx_descriptor *depend_tx,
 	dma_async_tx_callback cb_fn, void *cb_fn_param);
 
+struct dma_async_tx_descriptor *
+async_pqxor(struct page *pdest, struct page *qdest,
+	struct page **src_list, unsigned char *scoef_list,
+	unsigned int offset, int src_cnt, size_t len, enum async_tx_flags flags,
+	struct dma_async_tx_descriptor *depend_tx,
+	dma_async_tx_callback callback, void *callback_param);
+
+struct dma_async_tx_descriptor *
+async_gen_syndrome(struct page *pdest, struct page *qdest,
+	struct page **src_list, unsigned int offset, int src_cnt, size_t len,
+	enum async_tx_flags flags, struct dma_async_tx_descriptor *depend_tx,
+	dma_async_tx_callback callback, void *callback_param);
+
+struct dma_async_tx_descriptor *
+async_pqxor_zero_sum(struct page *pdest, struct page *qdest,
+	struct page **src_list, unsigned char *scoef_list,
+	unsigned int offset, int src_cnt, size_t len,
+	u32 *presult, u32 *qresult, enum async_tx_flags flags,
+	struct dma_async_tx_descriptor *depend_tx,
+	dma_async_tx_callback callback, void *callback_param);
+
+struct dma_async_tx_descriptor *
+async_syndrome_zero_sum(struct page *pdest, struct page *qdest,
+	struct page **src_list, unsigned int offset, int src_cnt, size_t len,
+	u32 *presult, u32 *qresult, enum async_tx_flags flags,
+	struct dma_async_tx_descriptor *depend_tx,
+	dma_async_tx_callback callback, void *callback_param);
+
 void async_tx_quiesce(struct dma_async_tx_descriptor **tx);
 #endif /* _ASYNC_TX_H_ */
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index adb0b08..51b7238 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -123,6 +123,7 @@ enum dma_ctrl_flags {
 	DMA_CTRL_ACK = (1 << 1),
 	DMA_COMPL_SKIP_SRC_UNMAP = (1 << 2),
 	DMA_COMPL_SKIP_DEST_UNMAP = (1 << 3),
+	DMA_PREP_ZERO_DST = (1 << 4),
 };
 
 /**
@@ -308,7 +309,9 @@ struct dma_async_tx_descriptor {
  * @device_free_chan_resources: release DMA channel's resources
  * @device_prep_dma_memcpy: prepares a memcpy operation
  * @device_prep_dma_xor: prepares a xor operation
+ * @device_prep_dma_pqxor: prepares a pq-xor operation
  * @device_prep_dma_zero_sum: prepares a zero_sum operation
+ * @device_prep_dma_pqzero_sum: prepares a pqzero_sum operation
  * @device_prep_dma_memset: prepares a memset operation
  * @device_prep_dma_interrupt: prepares an end of chain interrupt operation
  * @device_prep_slave_sg: prepares a slave dma operation
@@ -339,9 +342,17 @@ struct dma_device {
 	struct dma_async_tx_descriptor *(*device_prep_dma_xor)(
 		struct dma_chan *chan, dma_addr_t dest, dma_addr_t *src,
 		unsigned int src_cnt, size_t len, unsigned long flags);
+	struct dma_async_tx_descriptor *(*device_prep_dma_pqxor)(
+		struct dma_chan *chan, dma_addr_t *dst, unsigned int dst_cnt,
+		dma_addr_t *src, unsigned int src_cnt, unsigned char *scf,
+		size_t len, unsigned long flags);
 	struct dma_async_tx_descriptor *(*device_prep_dma_zero_sum)(
 		struct dma_chan *chan, dma_addr_t *src,	unsigned int src_cnt,
 		size_t len, u32 *result, unsigned long flags);
+	struct dma_async_tx_descriptor *(*device_prep_dma_pqzero_sum)(
+		struct dma_chan *chan, dma_addr_t *src, unsigned int src_cnt,
+		unsigned char *scf,
+		size_t len, u32 *presult, u32 *qresult, unsigned long flags);
 	struct dma_async_tx_descriptor *(*device_prep_dma_memset)(
 		struct dma_chan *chan, dma_addr_t dest, int value, size_t len,
 		unsigned long flags);
-- 
1.5.6.1
