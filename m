From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 04/18] dmaengine, async_tx: support alignment checks
Date: Thu, 03 Sep 2009 23:44:55 -0700
Message-ID: <20090904064455.7141.41620.stgit@dwillia2-linux.ch.intel.com>
References: <20090904064308.7141.30576.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932858AbZIDGqB@vger.kernel.org>
In-Reply-To: <20090904064308.7141.30576.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-raid@vger.kernel.org, maciej.sosnowski@intel.com
List-Id: linux-raid.ids

Some engines have transfer size and address alignment restrictions.  Add
a per-operation alignment property to struct dma_device that the async
routines and dmatest can use to check alignment capabilities.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 crypto/async_tx/async_memcpy.c |    2 +-
 crypto/async_tx/async_memset.c |    2 +-
 crypto/async_tx/async_pq.c     |    6 ++++-
 crypto/async_tx/async_xor.c    |    5 +++--
 drivers/dma/dmatest.c          |   14 +++++++++++++
 include/linux/dmaengine.h      |   44 ++++++++++++++++++++++++++++++++++++++++
 6 files changed, 67 insertions(+), 6 deletions(-)

diff --git a/crypto/async_tx/async_memcpy.c b/crypto/async_tx/async_memcpy.c
index b38cbb3..0ec1fb6 100644
--- a/crypto/async_tx/async_memcpy.c
+++ b/crypto/async_tx/async_memcpy.c
@@ -50,7 +50,7 @@ async_memcpy(struct page *dest, struct page *src, unsigned int dest_offset,
 	struct dma_device *device = chan ? chan->device : NULL;
 	struct dma_async_tx_descriptor *tx = NULL;
 
-	if (device) {
+	if (device && is_dma_copy_aligned(device, src_offset, dest_offset, len)) {
 		dma_addr_t dma_dest, dma_src;
 		unsigned long dma_prep_flags = 0;
 
diff --git a/crypto/async_tx/async_memset.c b/crypto/async_tx/async_memset.c
index a374784..58e4a87 100644
--- a/crypto/async_tx/async_memset.c
+++ b/crypto/async_tx/async_memset.c
@@ -47,7 +47,7 @@ async_memset(struct page *dest, int val, unsigned int offset, size_t len,
 	struct dma_device *device = chan ? chan->device : NULL;
 	struct dma_async_tx_descriptor *tx = NULL;
 
-	if (device) {
+	if (device && is_dma_fill_aligned(device, offset, 0, len)) {
 		dma_addr_t dma_dest;
 		unsigned long dma_prep_flags = 0;
 
diff --git a/crypto/async_tx/async_pq.c b/crypto/async_tx/async_pq.c
index a25e290..b88db6d 100644
--- a/crypto/async_tx/async_pq.c
+++ b/crypto/async_tx/async_pq.c
@@ -211,7 +211,8 @@ async_gen_syndrome(struct page **blocks, unsigned int offset, int disks,
 
 	if (dma_src && device &&
 	    (src_cnt <= dma_maxpq(device, 0) ||
-	     dma_maxpq(device, DMA_PREP_CONTINUE) > 0)) {
+	     dma_maxpq(device, DMA_PREP_CONTINUE) > 0) &&
+	    is_dma_pq_aligned(device, offset, 0, len)) {
 		/* run the p+q asynchronously */
 		pr_debug("%s: (async) disks: %d len: %zu\n",
 			 __func__, disks, len);
@@ -274,7 +275,8 @@ async_syndrome_val(struct page **blocks, unsigned int offset, int disks,
 	else if (sizeof(dma_addr_t) <= sizeof(struct page *))
 		dma_src = (dma_addr_t *) blocks;
 
-	if (dma_src && device && disks <= dma_maxpq(device, 0)) {
+	if (dma_src && device && disks <= dma_maxpq(device, 0) &&
+	    is_dma_pq_aligned(device, offset, 0, len)) {
 		struct device *dev = device->dev;
 		dma_addr_t *pq = &dma_src[disks-2];
 		int i;
diff --git a/crypto/async_tx/async_xor.c b/crypto/async_tx/async_xor.c
index db27987..b459a90 100644
--- a/crypto/async_tx/async_xor.c
+++ b/crypto/async_tx/async_xor.c
@@ -193,7 +193,7 @@ async_xor(struct page *dest, struct page **src_list, unsigned int offset,
 	else if (sizeof(dma_addr_t) <= sizeof(struct page *))
 		dma_src = (dma_addr_t *) src_list;
 
-	if (dma_src && chan) {
+	if (dma_src && chan && is_dma_xor_aligned(chan->device, offset, 0, len)) {
 		/* run the xor asynchronously */
 		pr_debug("%s (async): len: %zu\n", __func__, len);
 
@@ -265,7 +265,8 @@ async_xor_val(struct page *dest, struct page **src_list, unsigned int offset,
 	else if (sizeof(dma_addr_t) <= sizeof(struct page *))
 		dma_src = (dma_addr_t *) src_list;
 
-	if (dma_src && device && src_cnt <= device->max_xor) {
+	if (dma_src && device && src_cnt <= device->max_xor &&
+	    is_dma_xor_aligned(device, offset, 0, len)) {
 		unsigned long dma_prep_flags = 0;
 		int i;
 
diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
index 58e49e4..a3722a7 100644
--- a/drivers/dma/dmatest.c
+++ b/drivers/dma/dmatest.c
@@ -288,6 +288,7 @@ static int dmatest_func(void *data)
 		dma_addr_t dma_dsts[dst_cnt];
 		struct completion cmp;
 		unsigned long tmo = msecs_to_jiffies(3000);
+		u8 align = 0;
 
 		total_tests++;
 
@@ -295,6 +296,18 @@ static int dmatest_func(void *data)
 		src_off = dmatest_random() % (test_buf_size - len + 1);
 		dst_off = dmatest_random() % (test_buf_size - len + 1);
 
+		/* honor alignment restrictions */
+		if (thread->type == DMA_MEMCPY)
+			align = dev->copy_align;
+		else if (thread->type == DMA_XOR)
+			align = dev->xor_align;
+		else if (thread->type == DMA_PQ)
+			align = dev->pq_align;
+
+		len = (len >> align) << align;
+		src_off = (src_off >> align) << align;
+		dst_off = (dst_off >> align) << align;
+
 		dmatest_init_srcs(thread->srcs, src_off, len);
 		dmatest_init_dsts(thread->dsts, dst_off, len);
 
@@ -311,6 +324,7 @@ static int dmatest_func(void *data)
 						     DMA_BIDIRECTIONAL);
 		}
 
+
 		if (thread->type == DMA_MEMCPY)
 			tx = dev->device_prep_dma_memcpy(chan,
 							 dma_dsts[0] + dst_off,
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 94656f9..2b9f2ac 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -242,6 +242,10 @@ struct dma_async_tx_descriptor {
  * @cap_mask: one or more dma_capability flags
  * @max_xor: maximum number of xor sources, 0 if no capability
  * @max_pq: maximum number of PQ sources and PQ-continue capability
+ * @copy_align: alignment shift for memcpy operations
+ * @xor_align: alignment shift for xor operations
+ * @pq_align: alignment shift for pq operations
+ * @fill_align: alignment shift for memset operations
  * @dev_id: unique device ID
  * @dev: struct device reference for dma mapping api
  * @device_alloc_chan_resources: allocate resources and return the
@@ -268,6 +272,10 @@ struct dma_device {
 	dma_cap_mask_t  cap_mask;
 	unsigned short max_xor;
 	unsigned short max_pq;
+	u8 copy_align;
+	u8 xor_align;
+	u8 pq_align;
+	u8 fill_align;
 	#define DMA_HAS_PQ_CONTINUE (1 << 15)
 
 	int dev_id;
@@ -311,6 +319,42 @@ struct dma_device {
 	void (*device_issue_pending)(struct dma_chan *chan);
 };
 
+static inline bool dmaengine_check_align(u8 align, size_t off1, size_t off2, size_t len)
+{
+	size_t mask;
+
+	if (!align)
+		return true;
+	mask = (1 << align) - 1;
+	if (mask & (off1 | off2 | len))
+		return false;
+	return true;
+}
+
+static inline bool is_dma_copy_aligned(struct dma_device *dev, size_t off1,
+				       size_t off2, size_t len)
+{
+	return dmaengine_check_align(dev->copy_align, off1, off2, len);
+}
+
+static inline bool is_dma_xor_aligned(struct dma_device *dev, size_t off1,
+				      size_t off2, size_t len)
+{
+	return dmaengine_check_align(dev->xor_align, off1, off2, len);
+}
+
+static inline bool is_dma_pq_aligned(struct dma_device *dev, size_t off1,
+				     size_t off2, size_t len)
+{
+	return dmaengine_check_align(dev->pq_align, off1, off2, len);
+}
+
+static inline bool is_dma_fill_aligned(struct dma_device *dev, size_t off1,
+				       size_t off2, size_t len)
+{
+	return dmaengine_check_align(dev->fill_align, off1, off2, len);
+}
+
 static inline void
 dma_set_maxpq(struct dma_device *dma, int maxpq, int has_pq_continue)
 {
