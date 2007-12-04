From: Yuri Tikhonov <yur@emcraft.com>
Subject: [md-raid6-accel PATCH 02/12] async_tx: RAID-6 recovery implementation
Date: Tue, 4 Dec 2007 14:28:11 +0300
Message-ID: <200712041428.12094.yur@emcraft.com>
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

 This patch adds support for asynchronous RAID-6 recovery operations.

 An asynchronous implementation using async_tx API is provided to compute
two missing data blocks (async_r6_dd_recov) and to compute one missing data
block and one missing parity_block (async_r6_dp_recov).

 In general, the RAID-6 recovery API is the wrappers which organize the
calculations algorithms using async_pqxor().

 Please refer to the "The mathematics of RAID-6" wtite-paper written by
H.Peter Anvin available at www.kernel.org/pub/linux/kernel/people/hpa/raid6.pdf
for the theoretical basement of the algorithms implemented here.

 Signed-off-by: Yuri Tikhonov <yur@emcraft.com>
 Signed-off-by: Mikhail Cherkashin <mike@emcraft.com>
--
diff --git a/crypto/async_tx/Kconfig b/crypto/async_tx/Kconfig
index b1705d1..b2423e9 100644
--- a/crypto/async_tx/Kconfig
+++ b/crypto/async_tx/Kconfig
@@ -18,3 +18,7 @@ config ASYNC_PQXOR
 	tristate
 	select ASYNC_CORE
 
+config ASYNC_R6RECOV
+	tristate
+	select ASYNC_CORE
+
diff --git a/crypto/async_tx/Makefile b/crypto/async_tx/Makefile
index 32d6ce2..76fcd43 100644
--- a/crypto/async_tx/Makefile
+++ b/crypto/async_tx/Makefile
@@ -3,3 +3,4 @@ obj-$(CONFIG_ASYNC_MEMCPY) += async_memcpy.o
 obj-$(CONFIG_ASYNC_MEMSET) += async_memset.o
 obj-$(CONFIG_ASYNC_XOR) += async_xor.o
 obj-$(CONFIG_ASYNC_PQXOR) += async_pqxor.o
+obj-$(CONFIG_ASYNC_R6RECOV) += async_r6recov.o
diff --git a/crypto/async_tx/async_r6recov.c b/crypto/async_tx/async_r6recov.c
new file mode 100644
index 0000000..365c05b
--- /dev/null
+++ b/crypto/async_tx/async_r6recov.c
@@ -0,0 +1,314 @@
+/*
+ *	Copyright(c) 2007 Yuri Tikhonov <yur@emcraft.com>
+ *
+ *	Developed for DENX Software Engineering GmbH
+ *
+ *	Asynchronous RAID-6 recovery calculations ASYNC_TX API.
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
+#define ASYNC_R6_MAX_SRCS	256
+
+/**
+ * async_r6_dd_recov - attempt to calculate two data misses using dma engines.
+ * @disks: number of disks in the RAID-6 array
+ * @bytes: size of strip
+ * @faila: first failed drive index
+ * @failb: second failed drive index
+ * @ptrs: array of pointers to strips (last two must be p and q, respectively)
+ * @flags: ASYNC_TX_ACK, ASYNC_TX_DEP_ACK
+ * @depend_tx: depends on the result of this transaction.
+ * @cb: function to call when the operation completes
+ * @cb_param: parameter to pass to the callback routine
+ */
+struct dma_async_tx_descriptor *
+async_r6_dd_recov (int disks, size_t bytes, int faila, int failb,
+	struct page **ptrs, enum async_tx_flags flags,
+	struct dma_async_tx_descriptor *depend_tx,
+	dma_async_tx_callback cb, void *cb_param)
+{
+	struct dma_async_tx_descriptor *tx = NULL;
+	struct page *lptrs[ASYNC_R6_MAX_SRCS];
+	unsigned char lcoef[ASYNC_R6_MAX_SRCS];
+	int i = 0, k = 0, fc = -1;
+	u8 bc[2];
+
+	BUG_ON(disks > ASYNC_R6_MAX_SRCS);
+
+	/* Assume that failb > faila */
+	if (faila > failb) {
+		fc = faila;
+		faila = failb;
+		failb = fc;
+	}
+
+	/*
+	 * Try to compute missed data asynchronously.
+	 * Some operations never fail (XOR) so do not
+	 * check what they return
+	 */
+
+	/* (1) Calculate Qxy and Pxy:
+	 *  Qxy = A(1)*D(1) + .. + A(n,m-1)*D(n,m-1) + A(n,m+1)*D(n,m+1) + ..,
+	 *   where n = faila, m = failb.
+	 */
+	for (i = 0, k = 0; i < disks - 2; i++) {
+		if (i != faila && i != failb) {
+			lptrs[k] = ptrs[i];
+			lcoef[k] = raid6_gfexp[i];
+			k++;
+		}
+	}
+	if (!(tx=async_pqxor(ptrs[faila], ptrs[failb],
+			lptrs, lcoef, 0, k, bytes,
+			ASYNC_TX_XOR_ZERO_DST,
+			depend_tx, NULL, NULL))) {
+		/* Here may go to the synchronous variant */
+		if (flags & ASYNC_TX_ASYNC_ONLY)
+			return NULL;
+		goto ddr_sync;
+	}
+
+	/* The following operations will 'damage' P/Q strips;
+	 * so now we condemned to move in a asynchronous way.
+	 */
+
+	/* (2) Calculate Q+Qxy
+	 */
+	tx=async_pqxor(ptrs[disks-1], NULL,
+		&ptrs[failb], NULL, 0, 1, bytes,
+		ASYNC_TX_DEP_ACK,
+		tx, NULL, NULL);
+
+	/* (3) Calculate P+Pxy
+	 */
+	tx=async_pqxor(ptrs[disks-2], NULL,
+		&ptrs[faila], NULL, 0, 1, bytes,
+		ASYNC_TX_DEP_ACK,
+		tx, NULL, NULL);
+
+	/* (4) Compute (P+Pxy) * Bxy. Compute (Q+Qxy) * Cxy. XOR them and get
+	 *  faila.
+	 * B = (2^(y-x))*((2^(y-x) + {01})^(-1))
+	 * C = (2^(-x))*((2^(y-x) + {01})^(-1))
+	 * B * [p] + C * [q] -> [failb]
+	 */
+	bc[0] = raid6_gfexi[failb-faila];
+	bc[1] = raid6_gfinv[raid6_gfexp[faila]^raid6_gfexp[failb]];
+	if (!(tx=async_pqxor(NULL, ptrs[failb],
+			&ptrs[disks - 2], bc, 0, 2, bytes,
+			ASYNC_TX_DEP_ACK | ASYNC_TX_XOR_ZERO_DST,
+			tx, NULL, NULL))) {
+		/* It's bad if we failed here; try to repeat this
+		 * using another failed disk as a spare; this wouldn't
+		 * failed since now we'll be able to compute synchronously
+		 * (there is no support for synchronous Q-only)
+		 */
+		async_pqxor(ptrs[faila], ptrs[failb],
+			&ptrs[disks - 2], bc, 0, 2, bytes,
+			ASYNC_TX_DEP_ACK | ASYNC_TX_XOR_ZERO_DST,
+			NULL, NULL, NULL);
+	}
+
+	/* (5) Compute failed Dy using recovered [failb] and P+Pnm in [p]
+	 */
+	lptrs[0] = ptrs[disks-2];
+	lptrs[1] = ptrs[failb];
+	tx=async_pqxor(ptrs[faila], NULL,
+		lptrs, NULL, 0, 2, bytes,
+		ASYNC_TX_DEP_ACK | ASYNC_TX_XOR_ZERO_DST,
+		tx, NULL, NULL);
+
+	/* (6) Restore the parities back (use Pnm and Qnm)
+	 */
+	flags &= ~ASYNC_TX_XOR_ZERO_DST;
+	flags |= ASYNC_TX_DEP_ACK;
+
+	lptrs[0] = ptrs[faila];
+	lcoef[0] = raid6_gfexp[faila];
+	lptrs[1] = ptrs[failb];
+	lcoef[1] = raid6_gfexp[failb];
+	if (!(tx=async_pqxor(ptrs[disks-2], ptrs[disks-1],
+			lptrs, lcoef,
+			0, 2, bytes, flags,
+			tx, cb, cb_param))) {
+		/* just return, since data has been recovered anyway */
+		return NULL;
+	}
+
+	/* if come here then all required asynchronous operations
+	 * have been scheduled successfully
+	 */
+	return tx;
+
+ddr_sync:
+	{
+		void *sptrs[ASYNC_R6_MAX_SRCS + 2];
+
+		/*
+		 * Failed to compute asynchronously, do it in
+		 * synchronous manner
+		 */
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
+		i = disks;
+		while(i--)
+			sptrs[i] = page_address(ptrs[i]);
+		raid6_2data_recov(disks, bytes, faila, failb, sptrs);
+
+		async_tx_sync_epilog(flags, depend_tx, cb, cb_param);
+	}
+
+	return tx;
+}
+EXPORT_SYMBOL_GPL(async_r6_dd_recov);
+
+/**
+ * async_r6_dp_recov - attempt to calculate one data miss using dma engines.
+ * @disks: number of disks in the RAID-6 array
+ * @bytes: size of strip
+ * @faila: failed drive index
+ * @ptrs: array of pointers to strips (last two must be p and q, respectively)
+ * @flags: ASYNC_TX_ACK, ASYNC_TX_DEP_ACK
+ * @depend_tx: depends on the result of this transaction.
+ * @cb: function to call when the operation completes
+ * @cb_param: parameter to pass to the callback routine
+ */
+struct dma_async_tx_descriptor *
+async_r6_dp_recov (int disks, size_t bytes, int faila, struct page **ptrs,
+	enum async_tx_flags flags, struct dma_async_tx_descriptor *depend_tx,
+	dma_async_tx_callback cb, void *cb_param)
+{
+	struct dma_async_tx_descriptor *tx = NULL;
+	struct page *lptrs[ASYNC_R6_MAX_SRCS];
+	unsigned char lcoef[ASYNC_R6_MAX_SRCS];
+	int i = 0, k = 0;
+
+	BUG_ON(disks > ASYNC_R6_MAX_SRCS);
+
+	/*
+	 * Try compute missed data asynchronously
+	 */
+	/* (1) Calculate Qn + Q:
+	 *  Qn = A(1)*D(1) + .. + A(n-1)*D(n-1) + A(n+1)*D(n+1) + ..,
+	 *   where n = faila;
+	 *  then subtract Qn from Q and place result to Pn.
+	 */
+	for (i=0; i < disks - 2; i++) {
+		if (i != faila) {
+			lptrs[k] = ptrs[i];
+			lcoef[k++] = raid6_gfexp[i];
+		}
+	}
+	lptrs[k] = ptrs[disks-1]; /* Q-parity */
+	lcoef[k++] = 1;
+
+	if (!(tx=async_pqxor(NULL, ptrs[disks-2],
+			lptrs, lcoef, 0, k,
+			bytes, ASYNC_TX_XOR_ZERO_DST,
+			depend_tx, NULL, NULL))) {
+		if (flags & ASYNC_TX_ASYNC_ONLY)
+			return NULL;
+		goto dpr_sync;
+	}
+
+	/* (2) Compute missed Dn:
+	 *  Dn = (Q + Qn) * [A(n)^(-1)]
+	 */
+	if (!(tx=async_pqxor(NULL, ptrs[faila],
+			&ptrs[disks-2], (u8 *)&raid6_gfexp[255-faila],
+			0, 1, bytes,
+			ASYNC_TX_DEP_ACK | ASYNC_TX_XOR_ZERO_DST,
+			tx, cb, cb_param))) {
+		if (flags & ASYNC_TX_ASYNC_ONLY)
+			return NULL;
+		goto dpr_sync;
+	}
+
+	/* if come here then all required asynchronous operations
+	 * have been scheduled successfully
+	 */
+	return tx;
+
+dpr_sync:
+	{
+		void *sptrs[ASYNC_R6_MAX_SRCS + 2];
+
+		/*
+		 * Failed to compute asynchronously, do it in
+		 * synchronous manner
+		 */
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
+		i = disks;
+		while(i--)
+			sptrs[i] = page_address(ptrs[i]);
+		raid6_datap_recov(disks, bytes, faila, (void *)sptrs);
+
+		async_tx_sync_epilog(flags, depend_tx, cb, cb_param);
+	}
+
+	return tx;
+}
+EXPORT_SYMBOL_GPL(async_r6_dp_recov);
+
+static int __init async_r6recov_init(void)
+{
+	return 0;
+}
+
+static void __exit async_r6recov_exit(void)
+{
+	do { } while (0);
+}
+
+module_init(async_r6recov_init);
+module_exit(async_r6recov_exit);
+
+MODULE_AUTHOR("Yuri Tikhonov <yur@emcraft.com>");
+MODULE_DESCRIPTION("asynchronous RAID-6 recovery api");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/async_tx.h b/include/linux/async_tx.h
index 80bf0a3..d587872 100644
--- a/include/linux/async_tx.h
+++ b/include/linux/async_tx.h
@@ -166,4 +166,15 @@ async_pqxor_zero_sum(struct page *pdest, struct page *qdest,
 	struct dma_async_tx_descriptor *depend_tx,
 	dma_async_tx_callback callback, void *callback_param);
 
+struct dma_async_tx_descriptor *
+async_r6_dd_recov (int src_num, size_t bytes, int faila, int failb,
+	struct page **ptrs, enum async_tx_flags flags,
+	struct dma_async_tx_descriptor *depend_tx,
+	dma_async_tx_callback callback, void *callback_param);
+
+struct dma_async_tx_descriptor *
+async_r6_dp_recov (int src_num, size_t bytes, int faila, struct page **ptrs,
+	enum async_tx_flags flags, struct dma_async_tx_descriptor *depend_tx,
+	dma_async_tx_callback callback, void *callback_param);
+
 #endif /* _ASYNC_TX_H_ */

-- 
Yuri Tikhonov, Senior Software Engineer
Emcraft Systems, www.emcraft.com
