From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 10/19] dmaengine: expose per channel dma mapping characteristics to clients
Date: Mon, 11 Sep 2006 16:18:28 -0700
Message-ID: <20060911231828.4737.72361.stgit@dwillia2-linux.ch.intel.com>
References: <1158015632.4241.31.camel@dwillia2-linux.ch.intel.com>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S965108AbWIKXSn@vger.kernel.org>
In-Reply-To: <1158015632.4241.31.camel@dwillia2-linux.ch.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, christopher.leech@intel.com
List-Id: linux-raid.ids

From: Dan Williams <dan.j.williams@intel.com>

Allow a client to ensure that the dma channel it has selected can
dma to the specified buffer or page address.  Also allow the client to
pre-map address ranges to be passed to the operations API.

Changelog:
* make the dmaengine api EXPORT_SYMBOL_GPL
* zero sum support should be standalone, not integrated into xor

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 drivers/dma/dmaengine.c   |    4 ++++
 drivers/dma/ioatdma.c     |   35 +++++++++++++++++++++++++++++++++++
 include/linux/dmaengine.h |   34 ++++++++++++++++++++++++++++++++++
 3 files changed, 73 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index 9b02afa..e78ce89 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -630,3 +630,7 @@ EXPORT_SYMBOL_GPL(dma_async_device_unreg
 EXPORT_SYMBOL_GPL(dma_chan_cleanup);
 EXPORT_SYMBOL_GPL(dma_async_do_xor_err);
 EXPORT_SYMBOL_GPL(dma_async_chan_init);
+EXPORT_SYMBOL_GPL(dma_async_map_page);
+EXPORT_SYMBOL_GPL(dma_async_map_single);
+EXPORT_SYMBOL_GPL(dma_async_unmap_page);
+EXPORT_SYMBOL_GPL(dma_async_unmap_single);
diff --git a/drivers/dma/ioatdma.c b/drivers/dma/ioatdma.c
index dd5b9f0..0159d14 100644
--- a/drivers/dma/ioatdma.c
+++ b/drivers/dma/ioatdma.c
@@ -637,6 +637,37 @@ extern dma_cookie_t dma_async_do_xor_err
 	union dmaengine_addr src, unsigned int src_cnt,
 	unsigned int src_off, size_t len, unsigned long flags);
 
+static dma_addr_t ioat_map_page(struct dma_chan *chan, struct page *page,
+					unsigned long offset, size_t size,
+					int direction)
+{
+	struct ioat_dma_chan *ioat_chan = to_ioat_chan(chan);
+	return pci_map_page(ioat_chan->device->pdev, page, offset, size,
+			direction);
+}
+
+static dma_addr_t ioat_map_single(struct dma_chan *chan, void *cpu_addr,
+					size_t size, int direction)
+{
+	struct ioat_dma_chan *ioat_chan = to_ioat_chan(chan);
+	return pci_map_single(ioat_chan->device->pdev, cpu_addr, size,
+			direction);
+}
+
+static void ioat_unmap_page(struct dma_chan *chan, dma_addr_t handle,
+				size_t size, int direction)
+{
+	struct ioat_dma_chan *ioat_chan = to_ioat_chan(chan);
+	pci_unmap_page(ioat_chan->device->pdev, handle, size, direction);
+}
+
+static void ioat_unmap_single(struct dma_chan *chan, dma_addr_t handle,
+				size_t size, int direction)
+{
+	struct ioat_dma_chan *ioat_chan = to_ioat_chan(chan);
+	pci_unmap_single(ioat_chan->device->pdev, handle, size,	direction);
+}
+
 static int __devinit ioat_probe(struct pci_dev *pdev,
                                 const struct pci_device_id *ent)
 {
@@ -717,6 +748,10 @@ #endif
 	device->common.capabilities = DMA_MEMCPY;
 	device->common.device_do_dma_memcpy = do_ioat_dma_memcpy;
 	device->common.device_do_dma_xor = dma_async_do_xor_err;
+	device->common.map_page = ioat_map_page;
+	device->common.map_single = ioat_map_single;
+	device->common.unmap_page = ioat_unmap_page;
+	device->common.unmap_single = ioat_unmap_single;
 	printk(KERN_INFO "Intel(R) I/OAT DMA Engine found, %d channels\n",
 		device->common.chancnt);
 
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index df055cc..cb4cfcf 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -287,6 +287,15 @@ struct dma_device {
 	enum dma_status (*device_operation_complete)(struct dma_chan *chan,
 			dma_cookie_t cookie, dma_cookie_t *last,
 			dma_cookie_t *used);
+	dma_addr_t (*map_page)(struct dma_chan *chan, struct page *page,
+				unsigned long offset, size_t size,
+				int direction);
+	dma_addr_t (*map_single)(struct dma_chan *chan, void *cpu_addr,
+				size_t size, int direction);
+	void (*unmap_page)(struct dma_chan *chan, dma_addr_t handle,
+				size_t size, int direction);
+	void (*unmap_single)(struct dma_chan *chan, dma_addr_t handle,
+				size_t size, int direction);
 	void (*device_issue_pending)(struct dma_chan *chan);
 };
 
@@ -592,6 +601,31 @@ static inline enum dma_status dma_async_
 	return DMA_IN_PROGRESS;
 }
 
+static inline dma_addr_t dma_async_map_page(struct dma_chan *chan,
+			struct page *page, unsigned long offset, size_t size,
+			int direction)
+{
+	return chan->device->map_page(chan, page, offset, size, direction);
+}
+
+static inline dma_addr_t dma_async_map_single(struct dma_chan *chan,
+			void *cpu_addr,	size_t size, int direction)
+{
+	return chan->device->map_single(chan, cpu_addr, size, direction);
+}
+
+static inline void dma_async_unmap_page(struct dma_chan *chan,
+			dma_addr_t handle, size_t size, int direction)
+{
+	chan->device->unmap_page(chan, handle, size, direction);
+}
+
+static inline void dma_async_unmap_single(struct dma_chan *chan,
+			dma_addr_t handle, size_t size, int direction)
+{
+	chan->device->unmap_single(chan, handle, size, direction);
+}
+
 /* --- DMA device --- */
 
 int dma_async_device_register(struct dma_device *device);
