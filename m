From: Dan Williams <dan.j.williams@intel.com>
Subject: [GIT PULL] async_tx/dma driver fixes for 2.6.32
Date: Mon, 23 Nov 2009 15:05:10 -0700
Message-ID: <1259013910.15754.16.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1757398AbZKWWFJ@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-raid <linux-raid@vger.kernel.org>, Maciej Sosnowski <maciej.sosnowski@intel.com>
List-Id: linux-raid.ids

Hi Linus, please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/djbw/async_tx.git fixes

...to receive:

Dan Williams (9):
      ioat: silence "dca disabled" messages
      ioat3: dca and raid operations are incompatible
      ioat2,3: disable asynchronous error notifications
      ioat3: specify valid address for disabled-Q or disabled-P
      ioat2,3: report all uncorrectable errors
      dmaengine: include xor/pq validate in device_has_all_tx_types()
      async_tx: build-time toggling of async_{syndrome,xor}_val dma support
      ioat3: fix pq completion versus channel deallocation race
      shdma: fix initialization error handling

 crypto/async_tx/Kconfig      |    5 ++++
 crypto/async_tx/async_pq.c   |   14 ++++++++++--
 crypto/async_tx/async_xor.c  |   15 +++++++++++--
 drivers/dma/Kconfig          |    2 +
 drivers/dma/dmaengine.c      |   10 +++++++++
 drivers/dma/ioat/dca.c       |    6 ++--
 drivers/dma/ioat/dma.h       |    4 +--
 drivers/dma/ioat/dma_v2.c    |    2 +
 drivers/dma/ioat/dma_v3.c    |   44 +++++++++++++++++++++++++++++++++++------
 drivers/dma/ioat/hw.h        |    2 +
 drivers/dma/ioat/registers.h |    4 +--
 drivers/dma/shdma.c          |   12 ++++------
 12 files changed, 91 insertions(+), 29 deletions(-)

This primarily works around ioatdma driver issues with pq/xor-validate
operations.  The complete fix is staged for 2.6.33.  For now, commit:
"async_tx: build-time toggling of async_{syndrome,xor}_val dma support"
simply disables this operation type for 2.6.32.

The rest are 1-line or few-line fixes.

Thanks,
Dan


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
index bd0b248..8f99354 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -632,11 +632,21 @@ static bool device_has_all_tx_types(struct dma_device *device)
 	#if defined(CONFIG_ASYNC_XOR) || defined(CONFIG_ASYNC_XOR_MODULE)
 	if (!dma_has_cap(DMA_XOR, device->cap_mask))
 		return false;
+
+	#ifndef CONFIG_ASYNC_TX_DISABLE_XOR_VAL_DMA
+	if (!dma_has_cap(DMA_XOR_VAL, device->cap_mask))
+		return false;
+	#endif
 	#endif
 
 	#if defined(CONFIG_ASYNC_PQ) || defined(CONFIG_ASYNC_PQ_MODULE)
 	if (!dma_has_cap(DMA_PQ, device->cap_mask))
 		return false;
+
+	#ifndef CONFIG_ASYNC_TX_DISABLE_PQ_VAL_DMA
+	if (!dma_has_cap(DMA_PQ_VAL, device->cap_mask))
+		return false;
+	#endif
 	#endif
 
 	return true;
diff --git a/drivers/dma/ioat/dca.c b/drivers/dma/ioat/dca.c
index 69d0261..abd9038 100644
--- a/drivers/dma/ioat/dca.c
+++ b/drivers/dma/ioat/dca.c
@@ -98,17 +98,17 @@ static int dca_enabled_in_bios(struct pci_dev *pdev)
 	cpuid_level_9 = cpuid_eax(9);
 	res = test_bit(0, &cpuid_level_9);
 	if (!res)
-		dev_err(&pdev->dev, "DCA is disabled in BIOS\n");
+		dev_dbg(&pdev->dev, "DCA is disabled in BIOS\n");
 
 	return res;
 }
 
-static int system_has_dca_enabled(struct pci_dev *pdev)
+int system_has_dca_enabled(struct pci_dev *pdev)
 {
 	if (boot_cpu_has(X86_FEATURE_DCA))
 		return dca_enabled_in_bios(pdev);
 
-	dev_err(&pdev->dev, "boot cpu doesn't have X86_FEATURE_DCA\n");
+	dev_dbg(&pdev->dev, "boot cpu doesn't have X86_FEATURE_DCA\n");
 	return 0;
 }
 
diff --git a/drivers/dma/ioat/dma.h b/drivers/dma/ioat/dma.h
index c14fdfe..45edde9 100644
--- a/drivers/dma/ioat/dma.h
+++ b/drivers/dma/ioat/dma.h
@@ -297,9 +297,7 @@ static inline bool is_ioat_suspended(unsigned long status)
 /* channel was fatally programmed */
 static inline bool is_ioat_bug(unsigned long err)
 {
-	return !!(err & (IOAT_CHANERR_SRC_ADDR_ERR|IOAT_CHANERR_DEST_ADDR_ERR|
-			 IOAT_CHANERR_NEXT_ADDR_ERR|IOAT_CHANERR_CONTROL_ERR|
-			 IOAT_CHANERR_LENGTH_ERR));
+	return !!err;
 }
 
 static inline void ioat_unmap(struct pci_dev *pdev, dma_addr_t addr, size_t len,
diff --git a/drivers/dma/ioat/dma_v2.c b/drivers/dma/ioat/dma_v2.c
index 96ffab7..8f1f7f0 100644
--- a/drivers/dma/ioat/dma_v2.c
+++ b/drivers/dma/ioat/dma_v2.c
@@ -279,6 +279,8 @@ void ioat2_timer_event(unsigned long data)
 			u32 chanerr;
 
 			chanerr = readl(chan->reg_base + IOAT_CHANERR_OFFSET);
+			dev_err(to_dev(chan), "%s: Channel halted (%x)\n",
+				__func__, chanerr);
 			BUG_ON(is_ioat_bug(chanerr));
 		}
 
diff --git a/drivers/dma/ioat/dma_v3.c b/drivers/dma/ioat/dma_v3.c
index 35d1e33..42f6f10 100644
--- a/drivers/dma/ioat/dma_v3.c
+++ b/drivers/dma/ioat/dma_v3.c
@@ -378,6 +378,8 @@ static void ioat3_timer_event(unsigned long data)
 			u32 chanerr;
 
 			chanerr = readl(chan->reg_base + IOAT_CHANERR_OFFSET);
+			dev_err(to_dev(chan), "%s: Channel halted (%x)\n",
+				__func__, chanerr);
 			BUG_ON(is_ioat_bug(chanerr));
 		}
 
@@ -569,7 +571,7 @@ __ioat3_prep_xor_lock(struct dma_chan *c, enum sum_check_flags *result,
 	dump_desc_dbg(ioat, compl_desc);
 
 	/* we leave the channel locked to ensure in order submission */
-	return &desc->txd;
+	return &compl_desc->txd;
 }
 
 static struct dma_async_tx_descriptor *
@@ -728,7 +730,7 @@ __ioat3_prep_pq_lock(struct dma_chan *c, enum sum_check_flags *result,
 	dump_desc_dbg(ioat, compl_desc);
 
 	/* we leave the channel locked to ensure in order submission */
-	return &desc->txd;
+	return &compl_desc->txd;
 }
 
 static struct dma_async_tx_descriptor *
@@ -736,10 +738,16 @@ ioat3_prep_pq(struct dma_chan *chan, dma_addr_t *dst, dma_addr_t *src,
 	      unsigned int src_cnt, const unsigned char *scf, size_t len,
 	      unsigned long flags)
 {
+	/* specify valid address for disabled result */
+	if (flags & DMA_PREP_PQ_DISABLE_P)
+		dst[0] = dst[1];
+	if (flags & DMA_PREP_PQ_DISABLE_Q)
+		dst[1] = dst[0];
+
 	/* handle the single source multiply case from the raid6
 	 * recovery path
 	 */
-	if (unlikely((flags & DMA_PREP_PQ_DISABLE_P) && src_cnt == 1)) {
+	if ((flags & DMA_PREP_PQ_DISABLE_P) && src_cnt == 1) {
 		dma_addr_t single_source[2];
 		unsigned char single_source_coef[2];
 
@@ -761,6 +769,12 @@ ioat3_prep_pq_val(struct dma_chan *chan, dma_addr_t *pq, dma_addr_t *src,
 		  unsigned int src_cnt, const unsigned char *scf, size_t len,
 		  enum sum_check_flags *pqres, unsigned long flags)
 {
+	/* specify valid address for disabled result */
+	if (flags & DMA_PREP_PQ_DISABLE_P)
+		pq[0] = pq[1];
+	if (flags & DMA_PREP_PQ_DISABLE_Q)
+		pq[1] = pq[0];
+
 	/* the cleanup routine only sets bits on validate failure, it
 	 * does not clear bits on validate success... so clear it here
 	 */
@@ -778,9 +792,9 @@ ioat3_prep_pqxor(struct dma_chan *chan, dma_addr_t dst, dma_addr_t *src,
 	dma_addr_t pq[2];
 
 	memset(scf, 0, src_cnt);
-	flags |= DMA_PREP_PQ_DISABLE_Q;
 	pq[0] = dst;
-	pq[1] = ~0;
+	flags |= DMA_PREP_PQ_DISABLE_Q;
+	pq[1] = dst; /* specify valid address for disabled result */
 
 	return __ioat3_prep_pq_lock(chan, NULL, pq, src, src_cnt, scf, len,
 				    flags);
@@ -800,9 +814,9 @@ ioat3_prep_pqxor_val(struct dma_chan *chan, dma_addr_t *src,
 	*result = 0;
 
 	memset(scf, 0, src_cnt);
-	flags |= DMA_PREP_PQ_DISABLE_Q;
 	pq[0] = src[0];
-	pq[1] = ~0;
+	flags |= DMA_PREP_PQ_DISABLE_Q;
+	pq[1] = pq[0]; /* specify valid address for disabled result */
 
 	return __ioat3_prep_pq_lock(chan, result, pq, &src[1], src_cnt - 1, scf,
 				    len, flags);
@@ -1117,6 +1131,7 @@ static int __devinit ioat3_dma_self_test(struct ioatdma_device *device)
 int __devinit ioat3_dma_probe(struct ioatdma_device *device, int dca)
 {
 	struct pci_dev *pdev = device->pdev;
+	int dca_en = system_has_dca_enabled(pdev);
 	struct dma_device *dma;
 	struct dma_chan *c;
 	struct ioat_chan_common *chan;
@@ -1137,6 +1152,11 @@ int __devinit ioat3_dma_probe(struct ioatdma_device *device, int dca)
 	dma->device_prep_dma_interrupt = ioat3_prep_interrupt_lock;
 
 	cap = readl(device->reg_base + IOAT_DMA_CAP_OFFSET);
+
+	/* dca is incompatible with raid operations */
+	if (dca_en && (cap & (IOAT_CAP_XOR|IOAT_CAP_PQ)))
+		cap &= ~(IOAT_CAP_XOR|IOAT_CAP_PQ);
+
 	if (cap & IOAT_CAP_XOR) {
 		is_raid_device = true;
 		dma->max_xor = 8;
@@ -1186,6 +1206,16 @@ int __devinit ioat3_dma_probe(struct ioatdma_device *device, int dca)
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
diff --git a/drivers/dma/ioat/hw.h b/drivers/dma/ioat/hw.h
index 99afb12..60e6754 100644
--- a/drivers/dma/ioat/hw.h
+++ b/drivers/dma/ioat/hw.h
@@ -39,6 +39,8 @@
 #define IOAT_VER_3_0            0x30    /* Version 3.0 */
 #define IOAT_VER_3_2            0x32    /* Version 3.2 */
 
+int system_has_dca_enabled(struct pci_dev *pdev);
+
 struct ioat_dma_descriptor {
 	uint32_t	size;
 	union {
diff --git a/drivers/dma/ioat/registers.h b/drivers/dma/ioat/registers.h
index 63038e1..f015ec1 100644
--- a/drivers/dma/ioat/registers.h
+++ b/drivers/dma/ioat/registers.h
@@ -92,9 +92,7 @@
 #define IOAT_CHANCTRL_ERR_COMPLETION_EN		0x0004
 #define IOAT_CHANCTRL_INT_REARM			0x0001
 #define IOAT_CHANCTRL_RUN			(IOAT_CHANCTRL_INT_REARM |\
-						 IOAT_CHANCTRL_ERR_COMPLETION_EN |\
-						 IOAT_CHANCTRL_ANY_ERR_ABORT_EN |\
-						 IOAT_CHANCTRL_ERR_INT_EN)
+						 IOAT_CHANCTRL_ANY_ERR_ABORT_EN)
 
 #define IOAT_DMA_COMP_OFFSET			0x02	/* 16-bit DMA channel compatibility */
 #define IOAT_DMA_COMP_V1			0x0001	/* Compatibility with DMA version 1 */
diff --git a/drivers/dma/shdma.c b/drivers/dma/shdma.c
index b3b065c..034ecf0 100644
--- a/drivers/dma/shdma.c
+++ b/drivers/dma/shdma.c
@@ -640,17 +640,16 @@ static int __init sh_dmae_probe(struct platform_device *pdev)
 #endif
 	struct sh_dmae_device *shdev;
 
+	/* get platform data */
+	if (!pdev->dev.platform_data)
+		return -ENODEV;
+
 	shdev = kzalloc(sizeof(struct sh_dmae_device), GFP_KERNEL);
 	if (!shdev) {
 		dev_err(&pdev->dev, "No enough memory\n");
-		err = -ENOMEM;
-		goto shdev_err;
+		return -ENOMEM;
 	}
 
-	/* get platform data */
-	if (!pdev->dev.platform_data)
-		goto shdev_err;
-
 	/* platform data */
 	memcpy(&shdev->pdata, pdev->dev.platform_data,
 			sizeof(struct sh_dmae_pdata));
@@ -722,7 +721,6 @@ eirq_err:
 rst_err:
 	kfree(shdev);
 
-shdev_err:
 	return err;
 }
 
