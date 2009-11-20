From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 7/8] async_tx: build-time toggling of async_{syndrome,
	xor}_val dma support
Date: Fri, 20 Nov 2009 00:06:49 -0700
Message-ID: <20091120070649.13478.64153.stgit@dwillia2-linux.ch.intel.com>
References: <20091120070506.13478.77838.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932117AbZKTHH2@vger.kernel.org>
In-Reply-To: <20091120070506.13478.77838.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-raid@vger.kernel.org, maciej.sosnowski@intel.com
List-Id: linux-raid.ids

ioat3.2 does not support asynchronous error notifications which makes
the driver experience latencies when non-zero pq validate results are
expected.  Provide a mechanism for turning off async_xor_val and
async_syndrome_val via Kconfig.  This approach is generally useful for
any driver that specifies ASYNC_TX_DISABLE_CHANNEL_SWITCH and would like
to force the async_tx api to fall back to the synchronous path for
certain operations.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 crypto/async_tx/Kconfig     |    5 +++++
 crypto/async_tx/async_pq.c  |   14 +++++++++++---
 crypto/async_tx/async_xor.c |   15 ++++++++++++---
 drivers/dma/Kconfig         |    2 ++
 drivers/dma/dmaengine.c     |    6 ++++++
 drivers/dma/ioat/dma_v3.c   |   10 ++++++++++
 6 files changed, 46 insertions(+), 6 deletions(-)

diff --git a/crypto/async_tx/Kconfig b/crypto/async_tx/Kconfig
index e5aeb2b..e28e276 100644
--- a/crypto/async_tx/Kconfig
+++ b/crypto/async_tx/Kconfig
@@ -23,3 +23,8 @@ config ASYNC_RAID6_RECOV
 	select ASYNC_CORE
 	select ASYNC_PQ
 
+config ASYNC_TX_DISABLE_PQ_VAL_DMA
+	bool
+
+config ASYNC_TX_DISABLE_XOR_VAL_DMA
+	bool
diff --git a/crypto/async_tx/async_pq.c b/crypto/async_tx/async_pq.c
index 6b5cc4f..ec87f53 100644
--- a/crypto/async_tx/async_pq.c
+++ b/crypto/async_tx/async_pq.c
@@ -240,6 +240,16 @@ async_gen_syndrome(struct page **blocks, unsigned int offset, int disks,
 }
 EXPORT_SYMBOL_GPL(async_gen_syndrome);
 
+static inline struct dma_chan *
+pq_val_chan(struct async_submit_ctl *submit, struct page **blocks, int disks, size_t len)
+{
+	#ifdef CONFIG_ASYNC_TX_DISABLE_PQ_VAL_DMA
+	return NULL;
+	#endif
+	return async_tx_find_channel(submit, DMA_PQ_VAL, NULL, 0,  blocks,
+				     disks, len);
+}
+
 /**
  * async_syndrome_val - asynchronously validate a raid6 syndrome
  * @blocks: source blocks from idx 0..disks-3, P @ disks-2 and Q @ disks-1
@@ -260,9 +270,7 @@ async_syndrome_val(struct page **blocks, unsigned int offset, int disks,
 		   size_t len, enum sum_check_flags *pqres, struct page *spare,
 		   struct async_submit_ctl *submit)
 {
-	struct dma_chan *chan = async_tx_find_channel(submit, DMA_PQ_VAL,
-						      NULL, 0,  blocks, disks,
-						      len);
+	struct dma_chan *chan = pq_val_chan(submit, blocks, disks, len);
 	struct dma_device *device = chan ? chan->device : NULL;
 	struct dma_async_tx_descriptor *tx;
 	unsigned char coefs[disks-2];
diff --git a/crypto/async_tx/async_xor.c b/crypto/async_tx/async_xor.c
index 79182dc..079ae8c 100644
--- a/crypto/async_tx/async_xor.c
+++ b/crypto/async_tx/async_xor.c
@@ -234,6 +234,17 @@ static int page_is_zero(struct page *p, unsigned int offset, size_t len)
 		memcmp(a, a + 4, len - 4) == 0);
 }
 
+static inline struct dma_chan *
+xor_val_chan(struct async_submit_ctl *submit, struct page *dest,
+		 struct page **src_list, int src_cnt, size_t len)
+{
+	#ifdef CONFIG_ASYNC_TX_DISABLE_XOR_VAL_DMA
+	return NULL;
+	#endif
+	return async_tx_find_channel(submit, DMA_XOR_VAL, &dest, 1, src_list,
+				     src_cnt, len);
+}
+
 /**
  * async_xor_val - attempt a xor parity check with a dma engine.
  * @dest: destination page used if the xor is performed synchronously
@@ -255,9 +266,7 @@ async_xor_val(struct page *dest, struct page **src_list, unsigned int offset,
 	      int src_cnt, size_t len, enum sum_check_flags *result,
 	      struct async_submit_ctl *submit)
 {
-	struct dma_chan *chan = async_tx_find_channel(submit, DMA_XOR_VAL,
-						      &dest, 1, src_list,
-						      src_cnt, len);
+	struct dma_chan *chan = xor_val_chan(submit, dest, src_list, src_cnt, len);
 	struct dma_device *device = chan ? chan->device : NULL;
 	struct dma_async_tx_descriptor *tx = NULL;
 	dma_addr_t *dma_src = NULL;
diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index 5903a88..b401dad 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -26,6 +26,8 @@ config INTEL_IOATDMA
 	select DMA_ENGINE
 	select DCA
 	select ASYNC_TX_DISABLE_CHANNEL_SWITCH
+	select ASYNC_TX_DISABLE_PQ_VAL_DMA
+	select ASYNC_TX_DISABLE_XOR_VAL_DMA
 	help
 	  Enable support for the Intel(R) I/OAT DMA engine present
 	  in recent Intel Xeon chipsets.
diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index b6442f0..8f99354 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -632,16 +632,22 @@ static bool device_has_all_tx_types(struct dma_device *device)
 	#if defined(CONFIG_ASYNC_XOR) || defined(CONFIG_ASYNC_XOR_MODULE)
 	if (!dma_has_cap(DMA_XOR, device->cap_mask))
 		return false;
+
+	#ifndef CONFIG_ASYNC_TX_DISABLE_XOR_VAL_DMA
 	if (!dma_has_cap(DMA_XOR_VAL, device->cap_mask))
 		return false;
 	#endif
+	#endif
 
 	#if defined(CONFIG_ASYNC_PQ) || defined(CONFIG_ASYNC_PQ_MODULE)
 	if (!dma_has_cap(DMA_PQ, device->cap_mask))
 		return false;
+
+	#ifndef CONFIG_ASYNC_TX_DISABLE_PQ_VAL_DMA
 	if (!dma_has_cap(DMA_PQ_VAL, device->cap_mask))
 		return false;
 	#endif
+	#endif
 
 	return true;
 }
diff --git a/drivers/dma/ioat/dma_v3.c b/drivers/dma/ioat/dma_v3.c
index 252cf2d..189788f 100644
--- a/drivers/dma/ioat/dma_v3.c
+++ b/drivers/dma/ioat/dma_v3.c
@@ -1206,6 +1206,16 @@ int __devinit ioat3_dma_probe(struct ioatdma_device *device, int dca)
 		device->timer_fn = ioat2_timer_event;
 	}
 
+	#ifdef CONFIG_ASYNC_TX_DISABLE_PQ_VAL_DMA
+	dma_cap_clear(DMA_PQ_VAL, dma->cap_mask);
+	dma->device_prep_dma_pq_val = NULL;
+	#endif
+
+	#ifdef CONFIG_ASYNC_TX_DISABLE_XOR_VAL_DMA
+	dma_cap_clear(DMA_XOR_VAL, dma->cap_mask);
+	dma->device_prep_dma_xor_val = NULL;
+	#endif
+
 	/* -= IOAT ver.3 workarounds =- */
 	/* Write CHANERRMSK_INT with 3E07h to mask out the errors
 	 * that can cause stability issues for IOAT ver.3
