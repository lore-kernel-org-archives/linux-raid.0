From: Yuri Tikhonov <yur@emcraft.com>
Subject: [PATCH 03/11][v3] async_tx: add support for asynchronous RAID6 recovery operations
Date: Tue, 13 Jan 2009 03:43:13 +0300
Message-ID: <200901130343.14016.yur@emcraft.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: linuxppc-dev@ozlabs.org, dan.j.williams@intel.com, dzu@denx.de, wd@denx.de, yanok@emcraft.com
List-Id: linux-raid.ids

This patch extends async_tx API with two operations for recovery
operations on RAID6 array with two failed disks using new async_pq()
operation. Patch introduces the following functions:

 async_r6_dd_recov() recovers after double data disk failure

 async_r6_dp_recov() recovers after D+P failure

Signed-off-by: Yuri Tikhonov <yur@emcraft.com>
Signed-off-by: Ilya Yanok <yanok@emcraft.com>
---
 crypto/async_tx/Kconfig         |    5 +
 crypto/async_tx/Makefile        |    1 +
 crypto/async_tx/async_r6recov.c |  286 +++++++++++++++++++++++++++++++++++++++
 include/linux/async_tx.h        |   11 ++
 4 files changed, 303 insertions(+), 0 deletions(-)
 create mode 100644 crypto/async_tx/async_r6recov.c

diff --git a/crypto/async_tx/Kconfig b/crypto/async_tx/Kconfig
index cb6d731..0b56224 100644
--- a/crypto/async_tx/Kconfig
+++ b/crypto/async_tx/Kconfig
@@ -18,3 +18,8 @@ config ASYNC_PQ
 	tristate
 	select ASYNC_CORE
 
+config ASYNC_R6RECOV
+	tristate
+	select ASYNC_CORE
+	select ASYNC_PQ
+
diff --git a/crypto/async_tx/Makefile b/crypto/async_tx/Makefile
index 1b99265..0ed8f13 100644
--- a/crypto/async_tx/Makefile
+++ b/crypto/async_tx/Makefile
@@ -3,3 +3,4 @@ obj-$(CONFIG_ASYNC_MEMCPY) += async_memcpy.o
 obj-$(CONFIG_ASYNC_MEMSET) += async_memset.o
 obj-$(CONFIG_ASYNC_XOR) += async_xor.o
 obj-$(CONFIG_ASYNC_PQ) += async_pq.o
+obj-$(CONFIG_ASYNC_R6RECOV) += async_r6recov.o
diff --git a/crypto/async_tx/async_r6recov.c b/crypto/async_tx/async_r6recov.c
new file mode 100644
index 0000000..8642c14
--- /dev/null
+++ b/crypto/async_tx/async_r6recov.c
@@ -0,0 +1,286 @@
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
+ * this program; if not, write to the Free Software Foundation, Inc., 51
+ * Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
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
+async_r6_dd_recov(int disks, size_t bytes, int faila, int failb,
+	struct page **ptrs, enum async_tx_flags flags,
+	struct dma_async_tx_descriptor *depend_tx,
+	dma_async_tx_callback cb, void *cb_param)
+{
+	struct dma_async_tx_descriptor *tx = NULL;
+	struct page *lptrs[disks];
+	unsigned char lcoef[disks-4];
+	int i = 0, k = 0, fc = -1;
+	uint8_t bc[2];
+	dma_async_tx_callback lcb = NULL;
+	void *lcb_param = NULL;
+
+	/* Assume that failb > faila */
+	if (faila > failb) {
+		fc = faila;
+		faila = failb;
+		failb = fc;
+	}
+
+	/* Try to compute missed data asynchronously. */
+	if (disks == 4) {
+		/*
+		 * Pxy and Qxy are zero in this case so we already have
+		 * P+Pxy and Q+Qxy in P and Q strips respectively.
+		 */
+		tx = depend_tx;
+		lcb = cb;
+		lcb_param = cb_param;
+		goto do_mult;
+	}
+
+	/*
+	 * (1) Calculate Qxy and Pxy:
+	 * Qxy = A(0)*D(0) + ... + A(n-1)*D(n-1) + A(n+1)*D(n+1) + ... +
+	 *	 A(m-1)*D(m-1) + A(m+1)*D(m+1) + ... + A(disks-1)*D(disks-1),
+	 * where n = faila, m = failb.
+	 */
+	for (i = 0, k = 0; i < disks - 2; i++) {
+		if (i != faila && i != failb) {
+			lptrs[k] = ptrs[i];
+			lcoef[k] = raid6_gfexp[i];
+			k++;
+		}
+	}
+
+	lptrs[k] = ptrs[faila];
+	lptrs[k+1] = ptrs[failb];
+	tx = async_pq(lptrs, lcoef, 0, k, bytes,
+		      ASYNC_TX_PQ_ZERO_P | ASYNC_TX_PQ_ZERO_Q |
+		      ASYNC_TX_ASYNC_ONLY, depend_tx, NULL, NULL);
+	if (!tx) {
+		/* Here may go to the synchronous variant */
+		if (flags & ASYNC_TX_ASYNC_ONLY)
+			return NULL;
+		goto ddr_sync;
+	}
+
+	/*
+	 * The following operations will 'damage' P/Q strips;
+	 * so now we condemned to move in an asynchronous way.
+	 */
+
+	/* (2) Calculate Q+Qxy */
+	lptrs[0] = ptrs[failb];
+	lptrs[1] = ptrs[disks-1];
+	lptrs[2] = NULL;
+	tx = async_pq(lptrs, NULL, 0, 1, bytes, ASYNC_TX_DEP_ACK,
+		      tx, NULL, NULL);
+
+	/* (3) Calculate P+Pxy */
+	lptrs[0] = ptrs[faila];
+	lptrs[1] = ptrs[disks-2];
+	lptrs[2] = NULL;
+	tx = async_pq(lptrs, NULL, 0, 1, bytes, ASYNC_TX_DEP_ACK,
+		      tx, NULL, NULL);
+
+do_mult:
+	/*
+	 * (4) Compute (P+Pxy) * Bxy. Compute (Q+Qxy) * Cxy. XOR them and get
+	 *  faila.
+	 * B = (2^(y-x))*((2^(y-x) + {01})^(-1))
+	 * C = (2^(-x))*((2^(y-x) + {01})^(-1))
+	 * B * [p] + C * [q] -> [failb]
+	 */
+	bc[0] = raid6_gfexi[failb-faila];
+	bc[1] = raid6_gfinv[raid6_gfexp[faila]^raid6_gfexp[failb]];
+
+	lptrs[0] = ptrs[disks - 2];
+	lptrs[1] = ptrs[disks - 1];
+	lptrs[2] = NULL;
+	lptrs[3] = ptrs[failb];
+	tx = async_pq(lptrs, bc, 0, 2, bytes,
+		      ASYNC_TX_PQ_ZERO_Q | ASYNC_TX_DEP_ACK,
+		      tx, NULL, NULL);
+
+	/* (5) Compute failed Dy using recovered [failb] and P+Pnm in [p] */
+	lptrs[0] = ptrs[disks-2];
+	lptrs[1] = ptrs[failb];
+	lptrs[2] = ptrs[faila];
+	lptrs[3] = NULL;
+	tx = async_pq(lptrs, NULL, 0, 2, bytes,
+		      ASYNC_TX_PQ_ZERO_P | ASYNC_TX_DEP_ACK,
+		      tx, lcb, lcb_param);
+
+	if (disks == 4)
+		return tx;
+
+	/* (6) Restore the parities back */
+	flags |= ASYNC_TX_DEP_ACK;
+
+	memcpy(lptrs, ptrs, (disks - 2) * sizeof(struct page *));
+	lptrs[disks - 2] = ptrs[disks-2];
+	lptrs[disks - 1] = ptrs[disks-1];
+	return async_gen_syndrome(lptrs, 0, disks - 2, bytes, flags,
+				  tx, cb, cb_param);
+
+ddr_sync:
+	{
+		void **sptrs = (void **)lptrs;
+		/*
+		 * Failed to compute asynchronously, do it in
+		 * synchronous manner
+		 */
+
+		/* wait for any prerequisite operations */
+		async_tx_quiesce(&depend_tx);
+
+		i = disks;
+		while (i--)
+			sptrs[i] = page_address(ptrs[i]);
+		raid6_2data_recov(disks, bytes, faila, failb, sptrs);
+
+		async_tx_sync_epilog(cb, cb_param);
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
+async_r6_dp_recov(int disks, size_t bytes, int faila, struct page **ptrs,
+	enum async_tx_flags flags, struct dma_async_tx_descriptor *depend_tx,
+	dma_async_tx_callback cb, void *cb_param)
+{
+	struct dma_async_tx_descriptor *tx = NULL;
+	struct page *lptrs[disks];
+	unsigned char lcoef[disks-2];
+	int i = 0, k = 0;
+
+	/* Try compute missed data asynchronously. */
+
+	/*
+	 * (1) Calculate Qn + Q:
+	 * Qn = A(0)*D(0) + .. + A(n-1)*D(n-1) + A(n+1)*D(n+1) + ..,
+	 *  where n = faila;
+	 * then subtract Qn from Q and place result to Pn.
+	 */
+	for (i = 0; i < disks - 2; i++) {
+		if (i != faila) {
+			lptrs[k] = ptrs[i];
+			lcoef[k++] = raid6_gfexp[i];
+		}
+	}
+	lptrs[k] = ptrs[disks-1]; /* Q-parity */
+	lcoef[k++] = 1;
+
+	lptrs[k] = NULL;
+	lptrs[k+1] = ptrs[disks-2];
+
+	tx = async_pq(lptrs, lcoef, 0, k, bytes,
+		      ASYNC_TX_PQ_ZERO_Q | ASYNC_TX_ASYNC_ONLY,
+		      depend_tx, NULL, NULL);
+	if (!tx) {
+		if (flags & ASYNC_TX_ASYNC_ONLY)
+			return NULL;
+		goto dpr_sync;
+	}
+
+	/*
+	 * (2) Compute missed Dn:
+	 * Dn = (Q + Qn) * [A(n)^(-1)]
+	 */
+	lptrs[0] = ptrs[disks-2];
+	lptrs[1] = NULL;
+	lptrs[2] = ptrs[faila];
+	return async_pq(lptrs, (u8 *)&raid6_gfexp[faila ? 255-faila : 0], 0, 1,
+			bytes, ASYNC_TX_DEP_ACK | ASYNC_TX_PQ_ZERO_Q,
+			tx, cb, cb_param);
+
+dpr_sync:
+	{
+		void **sptrs = (void **) lptrs;
+		/*
+		 * Failed to compute asynchronously, do it in
+		 * synchronous manner
+		 */
+
+		/* wait for any prerequisite operations */
+		async_tx_quiesce(&depend_tx);
+
+		i = disks;
+		while (i--)
+			sptrs[i] = page_address(ptrs[i]);
+		raid6_datap_recov(disks, bytes, faila, (void *)sptrs);
+
+		async_tx_sync_epilog(cb, cb_param);
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
index 2f92d87..7575f12 100644
--- a/include/linux/async_tx.h
+++ b/include/linux/async_tx.h
@@ -173,5 +173,16 @@ async_syndrome_zero_sum(struct page **src_list, unsigned int offset,
 	enum async_tx_flags flags, struct dma_async_tx_descriptor *depend_tx,
 	dma_async_tx_callback callback, void *callback_param);
 
+struct dma_async_tx_descriptor *
+async_r6_dd_recov(int src_num, size_t bytes, int faila, int failb,
+	struct page **ptrs, enum async_tx_flags flags,
+	struct dma_async_tx_descriptor *depend_tx,
+	dma_async_tx_callback callback, void *callback_param);
+
+struct dma_async_tx_descriptor *
+async_r6_dp_recov(int src_num, size_t bytes, int faila, struct page **ptrs,
+	enum async_tx_flags flags, struct dma_async_tx_descriptor *depend_tx,
+	dma_async_tx_callback callback, void *callback_param);
+
 void async_tx_quiesce(struct dma_async_tx_descriptor **tx);
 #endif /* _ASYNC_TX_H_ */
-- 
1.6.0.6

