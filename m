From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 09/13] iop-adma: P+Q self test
Date: Wed, 18 Mar 2009 12:21:02 -0700
Message-ID: <20090318192102.20375.36540.stgit@dwillia2-linux.ch.intel.com>
References: <20090318191248.20375.40560.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090318191248.20375.40560.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: neilb@suse.de, maciej.sosnowski@intel.com
List-Id: linux-raid.ids

Even though the intent is to extend dmatest with P+Q tests there is
still value in having an always-on sanity check to prevent an
unintentionally broken driver from registering.

This depends on raid6_pq.ko for verification, the side effect being that
PQ capable channels will fail to register when raid6 is disabled.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dma/iop-adma.c |  182 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 181 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/iop-adma.c b/drivers/dma/iop-adma.c
index 0cdb333..2b014b6 100644
--- a/drivers/dma/iop-adma.c
+++ b/drivers/dma/iop-adma.c
@@ -31,6 +31,7 @@
 #include <linux/platform_device.h>
 #include <linux/memory.h>
 #include <linux/ioport.h>
+#include <linux/raid/raid6.h>
 
 #include <mach/adma.h>
 
@@ -1200,6 +1201,177 @@ out:
 	return err;
 }
 
+static int __devinit
+iop_adma_pq_zero_sum_self_test(struct iop_adma_device *device)
+{
+	#ifdef CONFIG_MD_RAID6_PQ
+	/* combined sources, software pq results, and extra hw pq results */
+	struct page *pq[IOP_ADMA_NUM_SRC_TEST+2+2];
+	/* ptr to the extra hw pq buffers defined above */
+	struct page **pq_hw = &pq[IOP_ADMA_NUM_SRC_TEST+2];
+	/* address conversion buffers (dma_map / page_address) */
+	void *pq_sw[IOP_ADMA_NUM_SRC_TEST+2];
+	dma_addr_t pq_src[IOP_ADMA_NUM_SRC_TEST];
+	dma_addr_t pq_dest[2];
+
+	int i;
+	struct dma_async_tx_descriptor *tx;
+	struct dma_chan *dma_chan;
+	dma_cookie_t cookie;
+	u32 zero_sum_result;
+	int err = 0;
+	struct device *dev;
+
+	dev_dbg(device->common.dev, "%s\n", __func__);
+
+	for (i = 0; i < ARRAY_SIZE(pq); i++) {
+		pq[i] = alloc_page(GFP_KERNEL);
+		if (!pq[i]) {
+			while (i--)
+				__free_page(pq[i]);
+			return -ENOMEM;
+		}
+	}
+
+	/* Fill in src buffers */
+	for (i = 0; i < IOP_ADMA_NUM_SRC_TEST; i++) {
+		pq_sw[i] = page_address(pq[i]);
+		memset(pq_sw[i], 0x11111111 * (1<<i), PAGE_SIZE);
+	}
+	pq_sw[i] = page_address(pq[i]);
+	pq_sw[i+1] = page_address(pq[i+1]);
+
+	dma_chan = container_of(device->common.channels.next,
+				struct dma_chan,
+				device_node);
+	if (iop_adma_alloc_chan_resources(dma_chan) < 1) {
+		err = -ENODEV;
+		goto out;
+	}
+
+	dev = dma_chan->device->dev;
+
+	/* initialize the dests */
+	memset(page_address(pq_hw[0]), 0 , PAGE_SIZE);
+	memset(page_address(pq_hw[1]), 0 , PAGE_SIZE);
+
+	/* test pq */
+	pq_dest[0] = dma_map_page(dev, pq_hw[0], 0, PAGE_SIZE, DMA_FROM_DEVICE);
+	pq_dest[1] = dma_map_page(dev, pq_hw[1], 0, PAGE_SIZE, DMA_FROM_DEVICE);
+	for (i = 0; i < IOP_ADMA_NUM_SRC_TEST; i++)
+		pq_src[i] = dma_map_page(dev, pq[i], 0, PAGE_SIZE,
+					 DMA_TO_DEVICE);
+
+	tx = iop_adma_prep_dma_pq(dma_chan, pq_dest, pq_src,
+				  IOP_ADMA_NUM_SRC_TEST, (u8 *)raid6_gfexp,
+				  PAGE_SIZE,
+				  DMA_PREP_INTERRUPT |
+				  DMA_CTRL_ACK);
+
+	cookie = iop_adma_tx_submit(tx);
+	iop_adma_issue_pending(dma_chan);
+	msleep(8);
+
+	if (iop_adma_is_complete(dma_chan, cookie, NULL, NULL) !=
+		DMA_SUCCESS) {
+		dev_err(dev, "Self-test pq timed out, disabling\n");
+		err = -ENODEV;
+		goto free_resources;
+	}
+
+	raid6_call.gen_syndrome(IOP_ADMA_NUM_SRC_TEST+2, PAGE_SIZE, pq_sw);
+
+	if (memcmp(pq_sw[IOP_ADMA_NUM_SRC_TEST],
+		   page_address(pq_hw[0]), PAGE_SIZE) != 0) {
+		dev_err(dev, "Self-test p failed compare, disabling\n");
+		err = -ENODEV;
+		goto free_resources;
+	}
+	if (memcmp(pq_sw[IOP_ADMA_NUM_SRC_TEST+1],
+		   page_address(pq_hw[1]), PAGE_SIZE) != 0) {
+		dev_err(dev, "Self-test q failed compare, disabling\n");
+		err = -ENODEV;
+		goto free_resources;
+	}
+
+	/* test correct zero sum using the software generated pq values */
+	for (i = 0; i < IOP_ADMA_NUM_SRC_TEST + 2; i++)
+		pq_src[i] = dma_map_page(dev, pq[i], 0, PAGE_SIZE,
+					 DMA_TO_DEVICE);
+
+	zero_sum_result = ~0;
+	tx = iop_adma_prep_dma_pq_zero_sum(dma_chan, pq_src,
+					   IOP_ADMA_NUM_SRC_TEST + 2,
+					   (u8 *) raid6_gfexp, PAGE_SIZE,
+					   &zero_sum_result,
+					   DMA_PREP_INTERRUPT |
+					   DMA_CTRL_ACK);
+
+	cookie = iop_adma_tx_submit(tx);
+	iop_adma_issue_pending(dma_chan);
+	msleep(8);
+
+	if (iop_adma_is_complete(dma_chan, cookie, NULL, NULL) !=
+		DMA_SUCCESS) {
+		dev_err(dev, "Self-test pq-zero-sum timed out, disabling\n");
+		err = -ENODEV;
+		goto free_resources;
+	}
+
+	if (zero_sum_result != 0) {
+		dev_err(dev, "Self-test pq-zero-sum failed to validate: %x\n",
+			zero_sum_result);
+		err = -ENODEV;
+		goto free_resources;
+	}
+
+	/* test incorrect zero sum */
+	i = IOP_ADMA_NUM_SRC_TEST;
+	memset(pq_sw[i] + 100, 0, 100);
+	memset(pq_sw[i+1] + 200, 0, 200);
+	for (i = 0; i < IOP_ADMA_NUM_SRC_TEST + 2; i++)
+		pq_src[i] = dma_map_page(dev, pq[i], 0, PAGE_SIZE,
+					 DMA_TO_DEVICE);
+
+	zero_sum_result = 0;
+	tx = iop_adma_prep_dma_pq_zero_sum(dma_chan, pq_src,
+					   IOP_ADMA_NUM_SRC_TEST + 2,
+					   (u8 *) raid6_gfexp, PAGE_SIZE,
+					   &zero_sum_result,
+					   DMA_PREP_INTERRUPT |
+					   DMA_CTRL_ACK);
+
+	cookie = iop_adma_tx_submit(tx);
+	iop_adma_issue_pending(dma_chan);
+	msleep(8);
+
+	if (iop_adma_is_complete(dma_chan, cookie, NULL, NULL) !=
+		DMA_SUCCESS) {
+		dev_err(dev, "Self-test !pq-zero-sum timed out, disabling\n");
+		err = -ENODEV;
+		goto free_resources;
+	}
+
+	if (zero_sum_result != (SUM_CHECK_P_RESULT | SUM_CHECK_Q_RESULT)) {
+		dev_err(dev, "Self-test !pq-zero-sum failed to validate: %x\n",
+			zero_sum_result);
+		err = -ENODEV;
+		goto free_resources;
+	}
+
+free_resources:
+	iop_adma_free_chan_resources(dma_chan);
+out:
+	i = ARRAY_SIZE(pq);
+	while (i--)
+		__free_page(pq[i]);
+	return err;
+	#else
+	return -ENODEV; /* no raid6 support */
+	#endif
+}
+
+
 static int __devexit iop_adma_remove(struct platform_device *dev)
 {
 	struct iop_adma_device *device = platform_get_drvdata(dev);
@@ -1350,13 +1522,21 @@ static int __devinit iop_adma_probe(struct platform_device *pdev)
 	}
 
 	if (dma_has_cap(DMA_XOR, dma_dev->cap_mask) ||
-		dma_has_cap(DMA_MEMSET, dma_dev->cap_mask)) {
+	    dma_has_cap(DMA_MEMSET, dma_dev->cap_mask)) {
 		ret = iop_adma_xor_zero_sum_self_test(adev);
 		dev_dbg(&pdev->dev, "xor self test returned %d\n", ret);
 		if (ret)
 			goto err_free_iop_chan;
 	}
 
+	if (dma_has_cap(DMA_PQ, dma_dev->cap_mask) &&
+	    dma_has_cap(DMA_PQ_ZERO_SUM, dma_dev->cap_mask)) {
+		ret = iop_adma_pq_zero_sum_self_test(adev);
+		dev_dbg(&pdev->dev, "pq self test returned %d\n", ret);
+		if (ret)
+			goto err_free_iop_chan;
+	}
+
 	dev_printk(KERN_INFO, &pdev->dev, "Intel(R) IOP: "
 	  "( %s%s%s%s%s%s%s%s%s%s)\n",
 	  dma_has_cap(DMA_PQ, dma_dev->cap_mask) ? "pq " : "",

