From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 02/18] dmaengine, async_tx: add a "no channel switch" allocator
Date: Thu, 03 Sep 2009 23:44:45 -0700
Message-ID: <20090904064445.7141.18693.stgit@dwillia2-linux.ch.intel.com>
References: <20090904064308.7141.30576.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090904064308.7141.30576.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-raid@vger.kernel.org, maciej.sosnowski@intel.com
List-Id: linux-raid.ids

Channel switching is problematic for some dmaengine drivers as the
architecture precludes separating the ->prep from ->submit.  In these
cases the driver can select ASYNC_TX_DISABLE_CHANNEL_SWITCH to modify
the async_tx allocator to only return channels that support all of the
required asynchronous operations.

For example MD_RAID456=y selects support for asynchronous xor, xor
validate, pq, pq validate, and memcpy.  When
ASYNC_TX_DISABLE_CHANNEL_SWITCH=y any channel with all these
capabilities is marked DMA_ASYNC_TX allowing async_tx_find_channel() to
quickly locate compatible channels with the guarantee that dependency
chains will remain on one channel.  When
ASYNC_TX_DISABLE_CHANNEL_SWITCH=n async_tx_find_channel() may select
channels that lead to operation chains that need to cross channel
boundaries using the async_tx channel switch capability.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 crypto/async_tx/async_tx.c |    4 ++++
 drivers/dma/Kconfig        |    4 ++++
 drivers/dma/dmaengine.c    |   40 ++++++++++++++++++++++++++++++++++++++++
 include/linux/dmaengine.h  |   10 +++++++++-
 4 files changed, 57 insertions(+), 1 deletions(-)

diff --git a/crypto/async_tx/async_tx.c b/crypto/async_tx/async_tx.c
index 60615fe..f9cdf04 100644
--- a/crypto/async_tx/async_tx.c
+++ b/crypto/async_tx/async_tx.c
@@ -81,6 +81,10 @@ async_tx_channel_switch(struct dma_async_tx_descriptor *depend_tx,
 	struct dma_device *device = chan->device;
 	struct dma_async_tx_descriptor *intr_tx = (void *) ~0;
 
+	#ifdef CONFIG_ASYNC_TX_DISABLE_CHANNEL_SWITCH
+	BUG();
+	#endif
+
 	/* first check to see if we can still append to depend_tx */
 	spin_lock_bh(&depend_tx->lock);
 	if (depend_tx->parent && depend_tx->chan == tx->chan) {
diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index 912a51b..ddcd979 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -17,11 +17,15 @@ if DMADEVICES
 
 comment "DMA Devices"
 
+config ASYNC_TX_DISABLE_CHANNEL_SWITCH
+	bool
+
 config INTEL_IOATDMA
 	tristate "Intel I/OAT DMA support"
 	depends on PCI && X86
 	select DMA_ENGINE
 	select DCA
+	select ASYNC_TX_DISABLE_CHANNEL_SWITCH
 	help
 	  Enable support for the Intel(R) I/OAT DMA engine present
 	  in recent Intel Xeon chipsets.
diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index 7739f0d..bd0b248 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -608,6 +608,40 @@ void dmaengine_put(void)
 }
 EXPORT_SYMBOL(dmaengine_put);
 
+static bool device_has_all_tx_types(struct dma_device *device)
+{
+	/* A device that satisfies this test has channels that will never cause
+	 * an async_tx channel switch event as all possible operation types can
+	 * be handled.
+	 */
+	#ifdef CONFIG_ASYNC_TX_DMA
+	if (!dma_has_cap(DMA_INTERRUPT, device->cap_mask))
+		return false;
+	#endif
+
+	#if defined(CONFIG_ASYNC_MEMCPY) || defined(CONFIG_ASYNC_MEMCPY_MODULE)
+	if (!dma_has_cap(DMA_MEMCPY, device->cap_mask))
+		return false;
+	#endif
+
+	#if defined(CONFIG_ASYNC_MEMSET) || defined(CONFIG_ASYNC_MEMSET_MODULE)
+	if (!dma_has_cap(DMA_MEMSET, device->cap_mask))
+		return false;
+	#endif
+
+	#if defined(CONFIG_ASYNC_XOR) || defined(CONFIG_ASYNC_XOR_MODULE)
+	if (!dma_has_cap(DMA_XOR, device->cap_mask))
+		return false;
+	#endif
+
+	#if defined(CONFIG_ASYNC_PQ) || defined(CONFIG_ASYNC_PQ_MODULE)
+	if (!dma_has_cap(DMA_PQ, device->cap_mask))
+		return false;
+	#endif
+
+	return true;
+}
+
 static int get_dma_id(struct dma_device *device)
 {
 	int rc;
@@ -665,6 +699,12 @@ int dma_async_device_register(struct dma_device *device)
 	BUG_ON(!device->device_issue_pending);
 	BUG_ON(!device->dev);
 
+	/* note: this only matters in the
+	 * CONFIG_ASYNC_TX_DISABLE_CHANNEL_SWITCH=y case
+	 */
+	if (device_has_all_tx_types(device))
+		dma_cap_set(DMA_ASYNC_TX, device->cap_mask);
+
 	idr_ref = kmalloc(sizeof(*idr_ref), GFP_KERNEL);
 	if (!idr_ref)
 		return -ENOMEM;
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 176f827..3e35df3 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -48,6 +48,9 @@ enum dma_status {
 
 /**
  * enum dma_transaction_type - DMA transaction types/indexes
+ *
+ * Note: The DMA_ASYNC_TX capability is not to be set by drivers.  It is
+ * automatically set as dma devices are registered.
  */
 enum dma_transaction_type {
 	DMA_MEMCPY,
@@ -61,6 +64,7 @@ enum dma_transaction_type {
 	DMA_MEMCPY_CRC32C,
 	DMA_INTERRUPT,
 	DMA_PRIVATE,
+	DMA_ASYNC_TX,
 	DMA_SLAVE,
 };
 
@@ -393,7 +397,11 @@ static inline void net_dmaengine_put(void)
 #ifdef CONFIG_ASYNC_TX_DMA
 #define async_dmaengine_get()	dmaengine_get()
 #define async_dmaengine_put()	dmaengine_put()
+#ifdef CONFIG_ASYNC_TX_DISABLE_CHANNEL_SWITCH
+#define async_dma_find_channel(type) dma_find_channel(DMA_ASYNC_TX)
+#else
 #define async_dma_find_channel(type) dma_find_channel(type)
+#endif /* CONFIG_ASYNC_TX_DISABLE_CHANNEL_SWITCH */
 #else
 static inline void async_dmaengine_get(void)
 {
@@ -406,7 +414,7 @@ async_dma_find_channel(enum dma_transaction_type type)
 {
 	return NULL;
 }
-#endif
+#endif /* CONFIG_ASYNC_TX_DMA */
 
 dma_cookie_t dma_async_memcpy_buf_to_buf(struct dma_chan *chan,
 	void *dest, void *src, size_t len);

