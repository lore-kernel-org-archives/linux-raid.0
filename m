From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 07/13] async_tx: add support for asynchronous RAID6 recovery
	operations
Date: Wed, 18 Mar 2009 12:20:52 -0700
Message-ID: <20090318192052.20375.68157.stgit@dwillia2-linux.ch.intel.com>
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

This patch extends async_tx API with two routines for RAID6 recovery.

 async_r6_dd_recov() recovers after double data disk failure

 async_r6_dp_recov() recovers after D+P failure

These routines make use of async_pq() which is fast in the asynchronous
case, but much slower than raid6_2data_recov() and raid6_datap_recov()
in the synchronous case.  The ASYNC_TX_ASYNC_ONLY flag is used to test
early for the presence of a raid6 offload engine before committing to
the asynchronous path.

Signed-off-by: Yuri Tikhonov <yur@emcraft.com>
Signed-off-by: Ilya Yanok <yanok@emcraft.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 crypto/async_tx/Kconfig         |    5 +
 crypto/async_tx/Makefile        |    1 
 crypto/async_tx/async_r6recov.c |  272 +++++++++++++++++++++++++++++++++++++++
 include/linux/async_tx.h        |   12 ++
 4 files changed, 290 insertions(+), 0 deletions(-)
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
index 0000000..90cdec6
--- /dev/null
+++ b/crypto/async_tx/async_r6recov.c
@@ -0,0 +1,272 @@
+/*
+ *	Copyright(c) 2007 Yuri Tikhonov <yur@emcraft.com>
+ *	Copyright(c) 2009 Intel Corporation
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
+#include <linux/raid/pq.h>
+#include <linux/async_tx.h>
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
+		  struct page **ptrs, enum async_tx_flags flags,
+		  struct dma_async_tx_descriptor *depend_tx,
+		  dma_async_tx_callback cb, void *cb_param)
+{
+	struct dma_async_tx_descriptor *tx = NULL;
+	struct page *lptrs[disks];
+	unsigned char lcoef[disks-4];
+	int i = 0, k = 0;
+	uint8_t bc[2];
+	dma_async_tx_callback lcb = NULL;
+	void *lcb_param = NULL;
+
+	/* Assume that failb > faila */
+	if (faila > failb)
+		swap(faila, failb);
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
+	tx = async_pq(lptrs, 0, k, lcoef, bytes,
+		      ASYNC_TX_ASYNC_ONLY|(flags & ASYNC_TX_DEP_ACK),
+		      depend_tx, NULL, NULL);
+	if (!tx) {
+		/* jump to optimized synchronous path */
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
+	lptrs[0] = ptrs[disks-1];
+	lptrs[1] = ptrs[failb];
+	tx = async_xor(lptrs[0], lptrs, 0, 2, bytes,
+		       ASYNC_TX_XOR_DROP_DST|ASYNC_TX_DEP_ACK, tx, NULL, NULL);
+
+	/* (3) Calculate P+Pxy */
+	lptrs[0] = ptrs[disks-2];
+	lptrs[1] = ptrs[faila];
+	tx = async_xor(lptrs[0], lptrs, 0, 2, bytes,
+		       ASYNC_TX_XOR_DROP_DST|ASYNC_TX_DEP_ACK, tx, NULL, NULL);
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
+	tx = async_pq(lptrs, 0, 2, bc, bytes, ASYNC_TX_DEP_ACK, tx, NULL, NULL);
+
+	/* (5) Compute failed Dy using recovered [failb] and P+Pnm in [p] */
+	lptrs[0] = ptrs[disks-2];
+	lptrs[1] = ptrs[failb];
+	lptrs[2] = ptrs[faila];
+	tx = async_xor(lptrs[2], lptrs, 0, 2, bytes,
+		       ASYNC_TX_XOR_ZERO_DST|ASYNC_TX_DEP_ACK, tx,
+		       lcb, lcb_param);
+
+	if (disks == 4) {
+		if (flags & ASYNC_TX_ACK)
+			async_tx_ack(tx);
+		return tx;
+	}
+
+	/* (6) Restore the parities back */
+	memcpy(lptrs, ptrs, (disks - 2) * sizeof(struct page *));
+	lptrs[disks - 2] = ptrs[disks-2];
+	lptrs[disks - 1] = ptrs[disks-1];
+	return async_gen_syndrome(lptrs, 0, disks - 2, bytes,
+				  ASYNC_TX_DEP_ACK|(flags & ASYNC_TX_ACK),
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
+		if (flags & ASYNC_TX_DEP_ACK)
+			async_tx_ack(depend_tx);
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
+		  enum async_tx_flags flags,
+		  struct dma_async_tx_descriptor *depend_tx,
+		  dma_async_tx_callback cb, void *cb_param)
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
+	tx = async_pq(lptrs, 0, k, lcoef, bytes,
+		      ASYNC_TX_ASYNC_ONLY|(flags & ASYNC_TX_DEP_ACK),
+		      depend_tx, NULL, NULL);
+	if (!tx) {
+		/* jump to optimized synchronous path */
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
+	return async_pq(lptrs, 0, 1, (u8 *)&raid6_gfexp[faila ? 255-faila : 0],
+			bytes, ASYNC_TX_DEP_ACK|(flags & ASYNC_TX_ACK),
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
+		if (flags & ASYNC_TX_DEP_ACK)
+			async_tx_ack(depend_tx);
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
+MODULE_AUTHOR("Yuri Tikhonov <yur@emcraft.com>, Dan Williams <dan.j.williams@intel.com>");
+MODULE_DESCRIPTION("asynchronous RAID-6 recovery api");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/async_tx.h b/include/linux/async_tx.h
index 1f10141..3febff9 100644
--- a/include/linux/async_tx.h
+++ b/include/linux/async_tx.h
@@ -169,5 +169,17 @@ async_syndrome_zero_sum(struct page **blocks, unsigned int offset, int src_cnt,
 			struct dma_async_tx_descriptor *depend_tx,
 			dma_async_tx_callback cb_fn, void *cb_param);
 
+struct dma_async_tx_descriptor *
+async_r6_dd_recov(int src_num, size_t bytes, int faila, int failb,
+		  struct page **ptrs, enum async_tx_flags flags,
+		  struct dma_async_tx_descriptor *depend_tx,
+		  dma_async_tx_callback callback, void *callback_param);
+
+struct dma_async_tx_descriptor *
+async_r6_dp_recov(int src_num, size_t bytes, int faila, struct page **ptrs,
+		  enum async_tx_flags flags,
+		  struct dma_async_tx_descriptor *depend_tx,
+		  dma_async_tx_callback callback, void *callback_param);
+
 void async_tx_quiesce(struct dma_async_tx_descriptor **tx);
 #endif /* _ASYNC_TX_H_ */

