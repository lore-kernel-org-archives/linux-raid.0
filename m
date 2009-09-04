From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 13/18] ioat3: support xor via pq descriptors
Date: Thu, 03 Sep 2009 23:45:41 -0700
Message-ID: <20090904064541.7141.80397.stgit@dwillia2-linux.ch.intel.com>
References: <20090904064308.7141.30576.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932961AbZIDGqo@vger.kernel.org>
In-Reply-To: <20090904064308.7141.30576.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-raid@vger.kernel.org, maciej.sosnowski@intel.com
List-Id: linux-raid.ids

If a platform advertises pq capabilities, but not xor, then use
ioat3_prep_pqxor and ioat3_prep_pqxor_val to simulate xor support.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dma/ioat/dma_v3.c |   49 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 49 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/ioat/dma_v3.c b/drivers/dma/ioat/dma_v3.c
index ca2af0f..bb57491 100644
--- a/drivers/dma/ioat/dma_v3.c
+++ b/drivers/dma/ioat/dma_v3.c
@@ -766,6 +766,44 @@ ioat3_prep_pq_val(struct dma_chan *chan, dma_addr_t *pq, dma_addr_t *src,
 				    flags);
 }
 
+static struct dma_async_tx_descriptor *
+ioat3_prep_pqxor(struct dma_chan *chan, dma_addr_t dst, dma_addr_t *src,
+		 unsigned int src_cnt, size_t len, unsigned long flags)
+{
+	unsigned char scf[src_cnt];
+	dma_addr_t pq[2];
+
+	memset(scf, 0, src_cnt);
+	flags |= DMA_PREP_PQ_DISABLE_Q;
+	pq[0] = dst;
+	pq[1] = ~0;
+
+	return __ioat3_prep_pq_lock(chan, NULL, pq, src, src_cnt, scf, len,
+				    flags);
+}
+
+struct dma_async_tx_descriptor *
+ioat3_prep_pqxor_val(struct dma_chan *chan, dma_addr_t *src,
+		     unsigned int src_cnt, size_t len,
+		     enum sum_check_flags *result, unsigned long flags)
+{
+	unsigned char scf[src_cnt];
+	dma_addr_t pq[2];
+
+	/* the cleanup routine only sets bits on validate failure, it
+	 * does not clear bits on validate success... so clear it here
+	 */
+	*result = 0;
+
+	memset(scf, 0, src_cnt);
+	flags |= DMA_PREP_PQ_DISABLE_Q;
+	pq[0] = src[0];
+	pq[1] = ~0;
+
+	return __ioat3_prep_pq_lock(chan, result, pq, &src[1], src_cnt - 1, scf,
+				    len, flags);
+}
+
 static void __devinit ioat3_dma_test_callback(void *dma_async_param)
 {
 	struct completion *cmp = dma_async_param;
@@ -1084,6 +1122,17 @@ int __devinit ioat3_dma_probe(struct ioatdma_device *device, int dca)
 
 		dma_cap_set(DMA_PQ_VAL, dma->cap_mask);
 		dma->device_prep_dma_pq_val = ioat3_prep_pq_val;
+
+		if (!(cap & IOAT_CAP_XOR)) {
+			dma->max_xor = 8;
+			dma->xor_align = 2;
+
+			dma_cap_set(DMA_XOR, dma->cap_mask);
+			dma->device_prep_dma_xor = ioat3_prep_pqxor;
+
+			dma_cap_set(DMA_XOR_VAL, dma->cap_mask);
+			dma->device_prep_dma_xor_val = ioat3_prep_pqxor_val;
+		}
 	}
 
 	/* -= IOAT ver.3 workarounds =- */
