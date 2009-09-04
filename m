From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 11/18] ioat3: xor self test
Date: Thu, 03 Sep 2009 23:45:31 -0700
Message-ID: <20090904064530.7141.64954.stgit@dwillia2-linux.ch.intel.com>
References: <20090904064308.7141.30576.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932932AbZIDGqL@vger.kernel.org>
In-Reply-To: <20090904064308.7141.30576.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-raid@vger.kernel.org, maciej.sosnowski@intel.com
List-Id: linux-raid.ids

This adds a hardware specific self test to be called from ioat_probe.
In the ioat3 case we will have tests for all the different raid
operations, while ioat1 and ioat2 will continue to just test memcpy.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dma/ioat/dma.c    |    5 -
 drivers/dma/ioat/dma.h    |    4 -
 drivers/dma/ioat/dma_v2.c |    1 
 drivers/dma/ioat/dma_v3.c |  275 +++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 282 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/ioat/dma.c b/drivers/dma/ioat/dma.c
index 2eb1fac..c524d36 100644
--- a/drivers/dma/ioat/dma.c
+++ b/drivers/dma/ioat/dma.c
@@ -800,7 +800,7 @@ static void __devinit ioat_dma_test_callback(void *dma_async_param)
  * ioat_dma_self_test - Perform a IOAT transaction to verify the HW works.
  * @device: device to be tested
  */
-static int __devinit ioat_dma_self_test(struct ioatdma_device *device)
+int __devinit ioat_dma_self_test(struct ioatdma_device *device)
 {
 	int i;
 	u8 *src;
@@ -1040,7 +1040,7 @@ int __devinit ioat_probe(struct ioatdma_device *device)
 	if (err)
 		goto err_setup_interrupts;
 
-	err = ioat_dma_self_test(device);
+	err = device->self_test(device);
 	if (err)
 		goto err_self_test;
 
@@ -1198,6 +1198,7 @@ int __devinit ioat1_dma_probe(struct ioatdma_device *device, int dca)
 
 	device->intr_quirk = ioat1_intr_quirk;
 	device->enumerate_channels = ioat1_enumerate_channels;
+	device->self_test = ioat_dma_self_test;
 	dma = &device->common;
 	dma->device_prep_dma_memcpy = ioat1_dma_prep_memcpy;
 	dma->device_issue_pending = ioat1_dma_memcpy_issue_pending;
diff --git a/drivers/dma/ioat/dma.h b/drivers/dma/ioat/dma.h
index 6c798f3..6a675a2 100644
--- a/drivers/dma/ioat/dma.h
+++ b/drivers/dma/ioat/dma.h
@@ -62,10 +62,10 @@
  * @enumerate_channels: hw version specific channel enumeration
  * @cleanup_tasklet: select between the v2 and v3 cleanup routines
  * @timer_fn: select between the v2 and v3 timer watchdog routines
+ * @self_test: hardware version specific self test for each supported op type
  *
  * Note: the v3 cleanup routine supports raid operations
  */
-
 struct ioatdma_device {
 	struct pci_dev *pdev;
 	void __iomem *reg_base;
@@ -80,6 +80,7 @@ struct ioatdma_device {
 	int (*enumerate_channels)(struct ioatdma_device *device);
 	void (*cleanup_tasklet)(unsigned long data);
 	void (*timer_fn)(unsigned long data);
+	int (*self_test)(struct ioatdma_device *device);
 };
 
 struct ioat_chan_common {
@@ -314,6 +315,7 @@ static inline void ioat_unmap(struct pci_dev *pdev, dma_addr_t addr, size_t len,
 int __devinit ioat_probe(struct ioatdma_device *device);
 int __devinit ioat_register(struct ioatdma_device *device);
 int __devinit ioat1_dma_probe(struct ioatdma_device *dev, int dca);
+int __devinit ioat_dma_self_test(struct ioatdma_device *device);
 void __devexit ioat_dma_remove(struct ioatdma_device *device);
 struct dca_provider * __devinit ioat_dca_init(struct pci_dev *pdev,
 					      void __iomem *iobase);
diff --git a/drivers/dma/ioat/dma_v2.c b/drivers/dma/ioat/dma_v2.c
index 56fa6d6..e0600f4 100644
--- a/drivers/dma/ioat/dma_v2.c
+++ b/drivers/dma/ioat/dma_v2.c
@@ -837,6 +837,7 @@ int __devinit ioat2_dma_probe(struct ioatdma_device *device, int dca)
 	device->enumerate_channels = ioat2_enumerate_channels;
 	device->cleanup_tasklet = ioat2_cleanup_tasklet;
 	device->timer_fn = ioat2_timer_event;
+	device->self_test = ioat_dma_self_test;
 	dma = &device->common;
 	dma->device_prep_dma_memcpy = ioat2_dma_prep_memcpy_lock;
 	dma->device_issue_pending = ioat2_issue_pending;
diff --git a/drivers/dma/ioat/dma_v3.c b/drivers/dma/ioat/dma_v3.c
index 957c205..927c08b 100644
--- a/drivers/dma/ioat/dma_v3.c
+++ b/drivers/dma/ioat/dma_v3.c
@@ -513,6 +513,280 @@ ioat3_prep_xor_val(struct dma_chan *chan, dma_addr_t *src,
 				     src_cnt - 1, len, flags);
 }
 
+static void __devinit ioat3_dma_test_callback(void *dma_async_param)
+{
+	struct completion *cmp = dma_async_param;
+
+	complete(cmp);
+}
+
+#define IOAT_NUM_SRC_TEST 6 /* must be <= 8 */
+static int __devinit ioat_xor_val_self_test(struct ioatdma_device *device)
+{
+	int i, src_idx;
+	struct page *dest;
+	struct page *xor_srcs[IOAT_NUM_SRC_TEST];
+	struct page *xor_val_srcs[IOAT_NUM_SRC_TEST + 1];
+	dma_addr_t dma_srcs[IOAT_NUM_SRC_TEST + 1];
+	dma_addr_t dma_addr, dest_dma;
+	struct dma_async_tx_descriptor *tx;
+	struct dma_chan *dma_chan;
+	dma_cookie_t cookie;
+	u8 cmp_byte = 0;
+	u32 cmp_word;
+	u32 xor_val_result;
+	int err = 0;
+	struct completion cmp;
+	unsigned long tmo;
+	struct device *dev = &device->pdev->dev;
+	struct dma_device *dma = &device->common;
+
+	dev_dbg(dev, "%s\n", __func__);
+
+	if (!dma_has_cap(DMA_XOR, dma->cap_mask))
+		return 0;
+
+	for (src_idx = 0; src_idx < IOAT_NUM_SRC_TEST; src_idx++) {
+		xor_srcs[src_idx] = alloc_page(GFP_KERNEL);
+		if (!xor_srcs[src_idx]) {
+			while (src_idx--)
+				__free_page(xor_srcs[src_idx]);
+			return -ENOMEM;
+		}
+	}
+
+	dest = alloc_page(GFP_KERNEL);
+	if (!dest) {
+		while (src_idx--)
+			__free_page(xor_srcs[src_idx]);
+		return -ENOMEM;
+	}
+
+	/* Fill in src buffers */
+	for (src_idx = 0; src_idx < IOAT_NUM_SRC_TEST; src_idx++) {
+		u8 *ptr = page_address(xor_srcs[src_idx]);
+		for (i = 0; i < PAGE_SIZE; i++)
+			ptr[i] = (1 << src_idx);
+	}
+
+	for (src_idx = 0; src_idx < IOAT_NUM_SRC_TEST; src_idx++)
+		cmp_byte ^= (u8) (1 << src_idx);
+
+	cmp_word = (cmp_byte << 24) | (cmp_byte << 16) |
+			(cmp_byte << 8) | cmp_byte;
+
+	memset(page_address(dest), 0, PAGE_SIZE);
+
+	dma_chan = container_of(dma->channels.next, struct dma_chan,
+				device_node);
+	if (dma->device_alloc_chan_resources(dma_chan) < 1) {
+		err = -ENODEV;
+		goto out;
+	}
+
+	/* test xor */
+	dest_dma = dma_map_page(dev, dest, 0, PAGE_SIZE, DMA_FROM_DEVICE);
+	for (i = 0; i < IOAT_NUM_SRC_TEST; i++)
+		dma_srcs[i] = dma_map_page(dev, xor_srcs[i], 0, PAGE_SIZE,
+					   DMA_TO_DEVICE);
+	tx = dma->device_prep_dma_xor(dma_chan, dest_dma, dma_srcs,
+				      IOAT_NUM_SRC_TEST, PAGE_SIZE,
+				      DMA_PREP_INTERRUPT);
+
+	if (!tx) {
+		dev_err(dev, "Self-test xor prep failed\n");
+		err = -ENODEV;
+		goto free_resources;
+	}
+
+	async_tx_ack(tx);
+	init_completion(&cmp);
+	tx->callback = ioat3_dma_test_callback;
+	tx->callback_param = &cmp;
+	cookie = tx->tx_submit(tx);
+	if (cookie < 0) {
+		dev_err(dev, "Self-test xor setup failed\n");
+		err = -ENODEV;
+		goto free_resources;
+	}
+	dma->device_issue_pending(dma_chan);
+
+	tmo = wait_for_completion_timeout(&cmp, msecs_to_jiffies(3000));
+
+	if (dma->device_is_tx_complete(dma_chan, cookie, NULL, NULL) != DMA_SUCCESS) {
+		dev_err(dev, "Self-test xor timed out\n");
+		err = -ENODEV;
+		goto free_resources;
+	}
+
+	dma_sync_single_for_cpu(dev, dest_dma, PAGE_SIZE, DMA_FROM_DEVICE);
+	for (i = 0; i < (PAGE_SIZE / sizeof(u32)); i++) {
+		u32 *ptr = page_address(dest);
+		if (ptr[i] != cmp_word) {
+			dev_err(dev, "Self-test xor failed compare\n");
+			err = -ENODEV;
+			goto free_resources;
+		}
+	}
+	dma_sync_single_for_device(dev, dest_dma, PAGE_SIZE, DMA_TO_DEVICE);
+
+	/* skip validate if the capability is not present */
+	if (!dma_has_cap(DMA_XOR_VAL, dma_chan->device->cap_mask))
+		goto free_resources;
+
+	/* validate the sources with the destintation page */
+	for (i = 0; i < IOAT_NUM_SRC_TEST; i++)
+		xor_val_srcs[i] = xor_srcs[i];
+	xor_val_srcs[i] = dest;
+
+	xor_val_result = 1;
+
+	for (i = 0; i < IOAT_NUM_SRC_TEST + 1; i++)
+		dma_srcs[i] = dma_map_page(dev, xor_val_srcs[i], 0, PAGE_SIZE,
+					   DMA_TO_DEVICE);
+	tx = dma->device_prep_dma_xor_val(dma_chan, dma_srcs,
+					  IOAT_NUM_SRC_TEST + 1, PAGE_SIZE,
+					  &xor_val_result, DMA_PREP_INTERRUPT);
+	if (!tx) {
+		dev_err(dev, "Self-test zero prep failed\n");
+		err = -ENODEV;
+		goto free_resources;
+	}
+
+	async_tx_ack(tx);
+	init_completion(&cmp);
+	tx->callback = ioat3_dma_test_callback;
+	tx->callback_param = &cmp;
+	cookie = tx->tx_submit(tx);
+	if (cookie < 0) {
+		dev_err(dev, "Self-test zero setup failed\n");
+		err = -ENODEV;
+		goto free_resources;
+	}
+	dma->device_issue_pending(dma_chan);
+
+	tmo = wait_for_completion_timeout(&cmp, msecs_to_jiffies(3000));
+
+	if (dma->device_is_tx_complete(dma_chan, cookie, NULL, NULL) != DMA_SUCCESS) {
+		dev_err(dev, "Self-test validate timed out\n");
+		err = -ENODEV;
+		goto free_resources;
+	}
+
+	if (xor_val_result != 0) {
+		dev_err(dev, "Self-test validate failed compare\n");
+		err = -ENODEV;
+		goto free_resources;
+	}
+
+	/* skip memset if the capability is not present */
+	if (!dma_has_cap(DMA_MEMSET, dma_chan->device->cap_mask))
+		goto free_resources;
+
+	/* test memset */
+	dma_addr = dma_map_page(dev, dest, 0,
+			PAGE_SIZE, DMA_FROM_DEVICE);
+	tx = dma->device_prep_dma_memset(dma_chan, dma_addr, 0, PAGE_SIZE,
+					 DMA_PREP_INTERRUPT);
+	if (!tx) {
+		dev_err(dev, "Self-test memset prep failed\n");
+		err = -ENODEV;
+		goto free_resources;
+	}
+
+	async_tx_ack(tx);
+	init_completion(&cmp);
+	tx->callback = ioat3_dma_test_callback;
+	tx->callback_param = &cmp;
+	cookie = tx->tx_submit(tx);
+	if (cookie < 0) {
+		dev_err(dev, "Self-test memset setup failed\n");
+		err = -ENODEV;
+		goto free_resources;
+	}
+	dma->device_issue_pending(dma_chan);
+
+	tmo = wait_for_completion_timeout(&cmp, msecs_to_jiffies(3000));
+
+	if (dma->device_is_tx_complete(dma_chan, cookie, NULL, NULL) != DMA_SUCCESS) {
+		dev_err(dev, "Self-test memset timed out\n");
+		err = -ENODEV;
+		goto free_resources;
+	}
+
+	for (i = 0; i < PAGE_SIZE/sizeof(u32); i++) {
+		u32 *ptr = page_address(dest);
+		if (ptr[i]) {
+			dev_err(dev, "Self-test memset failed compare\n");
+			err = -ENODEV;
+			goto free_resources;
+		}
+	}
+
+	/* test for non-zero parity sum */
+	xor_val_result = 0;
+	for (i = 0; i < IOAT_NUM_SRC_TEST + 1; i++)
+		dma_srcs[i] = dma_map_page(dev, xor_val_srcs[i], 0, PAGE_SIZE,
+					   DMA_TO_DEVICE);
+	tx = dma->device_prep_dma_xor_val(dma_chan, dma_srcs,
+					  IOAT_NUM_SRC_TEST + 1, PAGE_SIZE,
+					  &xor_val_result, DMA_PREP_INTERRUPT);
+	if (!tx) {
+		dev_err(dev, "Self-test 2nd zero prep failed\n");
+		err = -ENODEV;
+		goto free_resources;
+	}
+
+	async_tx_ack(tx);
+	init_completion(&cmp);
+	tx->callback = ioat3_dma_test_callback;
+	tx->callback_param = &cmp;
+	cookie = tx->tx_submit(tx);
+	if (cookie < 0) {
+		dev_err(dev, "Self-test  2nd zero setup failed\n");
+		err = -ENODEV;
+		goto free_resources;
+	}
+	dma->device_issue_pending(dma_chan);
+
+	tmo = wait_for_completion_timeout(&cmp, msecs_to_jiffies(3000));
+
+	if (dma->device_is_tx_complete(dma_chan, cookie, NULL, NULL) != DMA_SUCCESS) {
+		dev_err(dev, "Self-test 2nd validate timed out\n");
+		err = -ENODEV;
+		goto free_resources;
+	}
+
+	if (xor_val_result != SUM_CHECK_P_RESULT) {
+		dev_err(dev, "Self-test validate failed compare\n");
+		err = -ENODEV;
+		goto free_resources;
+	}
+
+free_resources:
+	dma->device_free_chan_resources(dma_chan);
+out:
+	src_idx = IOAT_NUM_SRC_TEST;
+	while (src_idx--)
+		__free_page(xor_srcs[src_idx]);
+	__free_page(dest);
+	return err;
+}
+
+static int __devinit ioat3_dma_self_test(struct ioatdma_device *device)
+{
+	int rc = ioat_dma_self_test(device);
+
+	if (rc)
+		return rc;
+
+	rc = ioat_xor_val_self_test(device);
+	if (rc)
+		return rc;
+
+	return 0;
+}
+
 int __devinit ioat3_dma_probe(struct ioatdma_device *device, int dca)
 {
 	struct pci_dev *pdev = device->pdev;
@@ -526,6 +800,7 @@ int __devinit ioat3_dma_probe(struct ioatdma_device *device, int dca)
 	device->enumerate_channels = ioat2_enumerate_channels;
 	device->cleanup_tasklet = ioat3_cleanup_tasklet;
 	device->timer_fn = ioat3_timer_event;
+	device->self_test = ioat3_dma_self_test;
 	dma = &device->common;
 	dma->device_prep_dma_memcpy = ioat2_dma_prep_memcpy_lock;
 	dma->device_issue_pending = ioat2_issue_pending;
