From: Yuri Tikhonov <yur@emcraft.com>
Subject: [md-raid6-accel PATCH 01/12] async_tx: PQXOR implementation
Date: Tue, 4 Dec 2007 14:27:00 +0300
Message-ID: <200712041427.00982.yur@emcraft.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: Neil Brown <neilb@suse.de>, Wolfgang Denk <wd@denx.de>, Detlev Zundel <dzu@denx.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

 This patch implements support for the asynchronous computation of RAID-6
syndromes.

 It provides an API to compute RAID-6 syndromes asynchronously in a format
conforming to async_tx interfaces. The async_pxor and async_pqxor_zero_sum
functions are very similar to async_xor functions but make use of
additional tx_set_src_mult method for setting cooefficients of the RAID-6
Q syndrome.

 The Galois polynomial which is used in the s/w case is 0x11d (the
corresponding coefficients are hard-coded in raid6_call.gen_syndrome).
Because even with the h/w acceleration enabled some pqxor operations may be
processed in CPU (e.g. in case of no DMA descriptors available) it's highly
recommended to configure the DMA engine which your system uses to exploit
exactly the same Galois polynomial.

 Signed-off-by: Yuri Tikhonov <yur@emcraft.com>
 Signed-off-by: Mikhail Cherkashin <mike@emcraft.com>
--
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
index 0000000..f71335c
--- /dev/null
+++ b/crypto/async_tx/async_pqxor.c
@@ -0,0 +1,331 @@
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
+ * zero sum to save the values to check.
+ */
+static spinlock_t spare_lock;
+struct page *spare_pages[2];
+
+/**
+ * do_async_pqxor - asynchronously calculate P and/or Q
+ */
+static void
+do_async_pqxor(struct dma_async_tx_descriptor *tx, struct dma_device *device,
+	struct dma_chan *chan,
+	struct page *pdest, struct page *qdest,
+	struct page **src_list, unsigned char *scoef_list,
+	unsigned int offset, unsigned int src_cnt, size_t len,
+	enum async_tx_flags flags, struct dma_async_tx_descriptor *depend_tx,
+	dma_async_tx_callback callback, void *callback_param)
+{
+	struct page *dest;
+	dma_addr_t dma_addr;
+	enum dma_data_direction dir;
+	int i;
+
+	/*  One parity (P or Q) calculation is initiated always;
+	 * first always try Q
+	 */
+	dir = (flags & ASYNC_TX_ASSUME_COHERENT) ?
+		DMA_NONE : DMA_FROM_DEVICE;
+	dest = qdest ? qdest : pdest;
+	dma_addr = dma_map_page(device->dev, dest, offset, len, dir);
+	tx->tx_set_dest(dma_addr, tx, 0);
+
+	/* Switch to the next destination */
+	if (qdest && pdest) {
+		/* Both destinations are set, thus here we deal with P */
+		dma_addr = dma_map_page(device->dev, pdest, offset, len, dir);
+		tx->tx_set_dest(dma_addr, tx, 1);
+	}
+
+	dir = (flags & ASYNC_TX_ASSUME_COHERENT) ?
+		DMA_NONE : DMA_TO_DEVICE;
+	for (i = 0; i < src_cnt; i++) {
+		dma_addr = dma_map_page(device->dev, src_list[i],
+			offset, len, dir);
+		tx->tx_set_src(dma_addr, tx, i);
+		if (!qdest)
+			/* P-only calculation */
+			tx->tx_set_src_mult(1, tx, i);
+		else
+			/* PQ or Q-only calculation */
+			tx->tx_set_src_mult(scoef_list[i], tx, i);
+	}
+
+	async_tx_submit(chan, tx, flags, depend_tx, callback,
+		callback_param);
+}
+
+/**
+ * do_sync_pqxor - synchronously calculate P and Q
+ */
+static void
+do_sync_pqxor(struct page *pdest, struct page *qdest,
+	struct page **src_list, unsigned int offset,
+	unsigned int src_cnt, size_t len, enum async_tx_flags flags,
+	struct dma_async_tx_descriptor *depend_tx,
+	dma_async_tx_callback callback, void *callback_param)
+{
+	int i;
+
+	/* reuse the 'src_list' array to convert to buffer pointers */
+	for (i = 0; i < src_cnt; i++)
+		src_list[i] = (struct page *)
+			(page_address(src_list[i]) + offset);
+
+	/* set destination addresses */
+	src_list[i++] = (struct page *)(page_address(pdest) + offset);
+	src_list[i++] = (struct page *)(page_address(qdest) + offset);
+
+	if (flags & ASYNC_TX_XOR_ZERO_DST) {
+		memset(src_list[i-2], 0, len);
+		memset(src_list[i-1], 0, len);
+	}
+
+	raid6_call.gen_syndrome(i, len, (void **)src_list);
+	async_tx_sync_epilog(flags, depend_tx, callback, callback_param);
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
+	struct dma_chan *chan = async_tx_find_channel(depend_tx, DMA_PQ_XOR);
+	struct dma_device *device = chan ? chan->device : NULL;
+	struct dma_async_tx_descriptor *tx = NULL;
+	int int_en;
+
+	if (!device && (flags & ASYNC_TX_ASYNC_ONLY))
+		return NULL;
+
+	if (device) { /* run the xor asynchronously */
+		int_en = callback ? 1 : 0;
+
+		tx = device->device_prep_dma_pqxor(chan,
+			src_list, src_cnt,
+			(pdest && qdest) ? 2 : 1,
+			len,
+			flags & ASYNC_TX_XOR_ZERO_DST ? 1 : 0,
+			int_en);
+
+		if (tx) {
+			do_async_pqxor(tx, device, chan,
+				pdest, qdest,
+				src_list, scoef_list,
+				offset, src_cnt, len,
+				flags, depend_tx, callback,
+				callback_param);
+		}  else /* fall through */ {
+			if (flags & ASYNC_TX_ASYNC_ONLY)
+				return NULL;
+			goto qxor_sync;
+		}
+	} else { /* run the pqxor synchronously */
+qxor_sync:
+		/* may do synchronous PQ only when both destinations exsists */
+		if (!pdest || !qdest)
+			return NULL;
+
+		/* wait for any prerequisite operations */
+		if (depend_tx) {
+			/* if ack is already set then we cannot be sure
+			 * we are referring to the correct operation
+			 */
+			BUG_ON(depend_tx->ack);
+			if (dma_wait_for_async_tx(depend_tx) == DMA_ERROR)
+				panic("%s: DMA_ERROR waiting for depend_tx\n",
+					__FUNCTION__);
+		}
+
+		do_sync_pqxor(pdest, qdest, src_list,
+			offset,	src_cnt, len, flags, depend_tx,
+			callback, callback_param);
+	}
+
+	return tx;
+}
+EXPORT_SYMBOL_GPL(async_pqxor);
+
+/**
+ * async_xor_zero_sum - attempt a PQ parities check with a dma engine.
+ * @pdest: P-parity destination to check
+ * @qdest: Q-parity destination to check
+ * @src_list: array of source pages.
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
+	struct page **src_list, unsigned char *scoef_list,
+	unsigned int offset, int src_cnt, size_t len,
+	u32 *presult, u32 *qresult, enum async_tx_flags flags,
+	struct dma_async_tx_descriptor *depend_tx,
+	dma_async_tx_callback callback, void *callback_param)
+{
+	struct dma_chan *chan = async_tx_find_channel(depend_tx,
+						      DMA_PQ_ZERO_SUM);
+	struct dma_device *device = chan ? chan->device : NULL;
+	struct page *dest;
+	int int_en = callback ? 1 : 0;
+	struct dma_async_tx_descriptor *tx = device ?
+		device->device_prep_dma_pqzero_sum(chan,
+			src_cnt, (pdest && qdest) ? 2 : 1, len,
+			presult, qresult, int_en) : NULL;
+	int i;
+
+	BUG_ON(src_cnt <= 1);
+
+	if (tx) {
+		dma_addr_t dma_addr;
+		enum dma_data_direction dir;
+
+		dir = (flags & ASYNC_TX_ASSUME_COHERENT) ?
+			DMA_NONE : DMA_TO_DEVICE;
+
+		/* Set location of first parity to check;
+		 * first try Q
+		 */
+		dest = qdest ? qdest : pdest;
+		dma_addr = dma_map_page(device->dev, dest, offset, len, dir);
+		tx->tx_set_dest(dma_addr, tx, 0);
+
+		if (qdest && pdest) {
+			/* Both parities has to be checked */
+			dma_addr = dma_map_page(device->dev, pdest, offset,
+						len, dir);
+			tx->tx_set_dest(dma_addr, tx, 1);
+		}
+
+		dir = (flags & ASYNC_TX_ASSUME_COHERENT) ?
+			DMA_NONE : DMA_TO_DEVICE;
+
+		/* Set location of srcs and coefs */
+		for (i = 0; i < src_cnt; i++) {
+			dma_addr = dma_map_page(device->dev, src_list[i],
+				offset, len, dir);
+			tx->tx_set_src(dma_addr, tx, i);
+			tx->tx_set_src_mult(scoef_list[i], tx, i);
+		}
+
+		async_tx_submit(chan, tx, flags, depend_tx, callback,
+			callback_param);
+	} else {
+		unsigned long lflags = flags;
+
+		/* TBD: support for lengths size of more than PAGE_SIZE */
+
+		lflags &= ~ASYNC_TX_ACK;
+		spin_lock(&spare_lock);
+		do_sync_pqxor(spare_pages[0], spare_pages[1],
+			src_list, offset,
+			src_cnt, len, lflags,
+			depend_tx, NULL, NULL);
+
+		if (presult && pdest)
+			*presult = memcmp(page_address(pdest),
+					   page_address(spare_pages[0]),
+					   len) == 0 ? 0 : 1;
+		if (qresult && qdest)
+			*qresult = memcmp(page_address(qdest),
+					   page_address(spare_pages[1]),
+					   len) == 0 ? 0 : 1;
+		spin_unlock(&spare_lock);
+	}
+
+	return tx;
+}
+EXPORT_SYMBOL_GPL(async_pqxor_zero_sum);
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
+	spare_pages[1] = alloc_page(GFP_KERNEL);
+
+	return 0;
+abort:
+	safe_put_page(spare_pages[0]);
+	printk(KERN_ERR "%s: cannot allocate spare!\n", __FUNCTION__);
+	return -ENOMEM;
+}
+
+static void __exit async_pqxor_exit(void)
+{
+	safe_put_page(spare_pages[0]);
+	safe_put_page(spare_pages[1]);
+}
+
+module_init(async_pqxor_init);
+module_exit(async_pqxor_exit);
+
+MODULE_AUTHOR("Yuri Tikhonov <yur@emcraft.com>");
+MODULE_DESCRIPTION("asynchronous qxor/qxor-zero-sum api");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/async_tx.h b/include/linux/async_tx.h
index bdca3f1..80bf0a3 100644
--- a/include/linux/async_tx.h
+++ b/include/linux/async_tx.h
@@ -51,6 +51,8 @@ struct dma_chan_ref {
  * @ASYNC_TX_ACK: immediately ack the descriptor, precludes setting up a
  * dependency chain
  * @ASYNC_TX_DEP_ACK: ack the dependency descriptor.  Useful for chaining.
+ * @ASYNC_TX_ASYNC_ONLY: if set then try to perform operation requested in
+ * asynchronous way only.
  */
 enum async_tx_flags {
 	ASYNC_TX_XOR_ZERO_DST	 = (1 << 0),
@@ -58,6 +60,7 @@ enum async_tx_flags {
 	ASYNC_TX_ASSUME_COHERENT = (1 << 2),
 	ASYNC_TX_ACK		 = (1 << 3),
 	ASYNC_TX_DEP_ACK	 = (1 << 4),
+	ASYNC_TX_ASYNC_ONLY	 = (1 << 7),
 };
 
 #ifdef CONFIG_DMA_ENGINE
@@ -147,4 +150,20 @@ struct dma_async_tx_descriptor *
 async_trigger_callback(enum async_tx_flags flags,
 	struct dma_async_tx_descriptor *depend_tx,
 	dma_async_tx_callback cb_fn, void *cb_fn_param);
+
+struct dma_async_tx_descriptor *
+async_pqxor(struct page *pdest, struct page *qdest,
+	struct page **src_list, unsigned char *scoef_list,
+	unsigned int offset, int src_cnt, size_t len, enum async_tx_flags flags,
+	struct dma_async_tx_descriptor *depend_tx,
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
 #endif /* _ASYNC_TX_H_ */
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index a3b6035..50d1ae3 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -210,6 +210,7 @@ typedef void (*dma_async_tx_callback)(void *dma_async_param);
  * @tx_submit: set the prepared descriptor(s) to be executed by the engine
  * @tx_set_dest: set a destination address in a hardware descriptor
  * @tx_set_src: set a source address in a hardware descriptor
+ * @tx_set_src_mult: set a GF-multiplier in a hardware descriptor
  * @callback: routine to call after this operation is complete
  * @callback_param: general parameter to pass to the callback routine
  * ---async_tx api specific fields---
@@ -230,6 +231,8 @@ struct dma_async_tx_descriptor {
 		struct dma_async_tx_descriptor *tx, int index);
 	void (*tx_set_src)(dma_addr_t addr,
 		struct dma_async_tx_descriptor *tx, int index);
+	void (*tx_set_src_mult)(unsigned char mult,
+		struct dma_async_tx_descriptor *tx, int index);
 	dma_async_tx_callback callback;
 	void *callback_param;
 	struct list_head depend_list;
@@ -254,7 +257,9 @@ struct dma_async_tx_descriptor {
  * @device_free_chan_resources: release DMA channel's resources
  * @device_prep_dma_memcpy: prepares a memcpy operation
  * @device_prep_dma_xor: prepares a xor operation
+ * @device_prep_dma_pqxor: prepares a pq-xor operation
  * @device_prep_dma_zero_sum: prepares a zero_sum operation
+ * @device_prep_dma_pqzero_sum: prepares a pqzero_sum operation
  * @device_prep_dma_memset: prepares a memset operation
  * @device_prep_dma_interrupt: prepares an end of chain interrupt operation
  * @device_dependency_added: async_tx notifies the channel about new deps
@@ -282,9 +287,17 @@ struct dma_device {
 	struct dma_async_tx_descriptor *(*device_prep_dma_xor)(
 		struct dma_chan *chan, unsigned int src_cnt, size_t len,
 		int int_en);
+	struct dma_async_tx_descriptor *(*device_prep_dma_pqxor)(
+		struct dma_chan *chan, struct page **sas,
+		unsigned int src_cnt, unsigned int dst_cnt,
+		size_t len, int zero_dst, int int_en);
 	struct dma_async_tx_descriptor *(*device_prep_dma_zero_sum)(
 		struct dma_chan *chan, unsigned int src_cnt, size_t len,
 		u32 *result, int int_en);
+	struct dma_async_tx_descriptor *(*device_prep_dma_pqzero_sum)(
+		struct dma_chan *chan,
+		unsigned int src_cnt, unsigned int dst_cnt, size_t len,
+		u32 *presult, u32 *qresult, int int_en);
 	struct dma_async_tx_descriptor *(*device_prep_dma_memset)(
 		struct dma_chan *chan, int value, size_t len, int int_en);
 	struct dma_async_tx_descriptor *(*device_prep_dma_interrupt)(

-- 
Yuri Tikhonov, Senior Software Engineer
Emcraft Systems, www.emcraft.com
