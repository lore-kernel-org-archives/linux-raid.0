From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 10/13] dmaengine: allow dma support for async_tx to be toggled
Date: Wed, 18 Mar 2009 12:21:07 -0700
Message-ID: <20090318192107.20375.18145.stgit@dwillia2-linux.ch.intel.com>
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

Provide a config option for blocking the allocation of dma channels to
the async_tx api.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 crypto/async_tx/async_tx.c |    6 +++---
 drivers/dma/Kconfig        |   11 +++++++++++
 include/linux/dmaengine.h  |   18 ++++++++++++++++++
 3 files changed, 32 insertions(+), 3 deletions(-)

diff --git a/crypto/async_tx/async_tx.c b/crypto/async_tx/async_tx.c
index c3b07cf..2b1513e 100644
--- a/crypto/async_tx/async_tx.c
+++ b/crypto/async_tx/async_tx.c
@@ -30,7 +30,7 @@
 #ifdef CONFIG_DMA_ENGINE
 static int __init async_tx_init(void)
 {
-	dmaengine_get();
+	async_dmaengine_get();
 
 	printk(KERN_INFO "async_tx: api initialized (async)\n");
 
@@ -39,7 +39,7 @@ static int __init async_tx_init(void)
 
 static void __exit async_tx_exit(void)
 {
-	dmaengine_put();
+	async_dmaengine_put();
 }
 
 module_init(async_tx_init);
@@ -59,7 +59,7 @@ __async_tx_find_channel(struct dma_async_tx_descriptor *depend_tx,
 	if (depend_tx &&
 	    dma_has_cap(tx_type, depend_tx->chan->device->cap_mask))
 		return depend_tx->chan;
-	return dma_find_channel(tx_type);
+	return async_dma_find_channel(tx_type);
 }
 EXPORT_SYMBOL_GPL(__async_tx_find_channel);
 #endif
diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index 48ea59e..3b3c01b 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -98,6 +98,17 @@ config NET_DMA
 	  Say Y here if you enabled INTEL_IOATDMA or FSL_DMA, otherwise
 	  say N.
 
+config ASYNC_TX_DMA
+	bool "Async_tx: Offload support for the async_tx api"
+	depends on DMA_ENGINE
+	help
+	  This allows the async_tx api to take advantage of offload engines for
+	  memcpy, memset, xor, and raid6 p+q operations.  If your platform has
+	  a dma engine that can perform raid operations and you have enabled
+	  MD_RAID456 say Y.
+
+	  If unsure, say N.
+
 config DMATEST
 	tristate "DMA Test client"
 	depends on DMA_ENGINE
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index a7fa966..7eedf45 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -356,6 +356,24 @@ static inline void net_dmaengine_put(void)
 }
 #endif
 
+#ifdef CONFIG_ASYNC_TX_DMA
+#define async_dmaengine_get()	dmaengine_get()
+#define async_dmaengine_put()	dmaengine_put()
+#define async_dma_find_channel(type) dma_find_channel(type)
+#else
+static inline void async_dmaengine_get(void)
+{
+}
+static inline void async_dmaengine_put(void)
+{
+}
+static inline struct dma_chan *
+async_dma_find_channel(enum dma_transaction_type type)
+{
+	return NULL;
+}
+#endif
+
 dma_cookie_t dma_async_memcpy_buf_to_buf(struct dma_chan *chan,
 	void *dest, void *src, size_t len);
 dma_cookie_t dma_async_memcpy_buf_to_pg(struct dma_chan *chan,

