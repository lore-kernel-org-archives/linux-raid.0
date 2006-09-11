From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 12/19] dmaengine: dma_async_memcpy_err for DMA engines that do not support memcpy
Date: Mon, 11 Sep 2006 16:18:39 -0700
Message-ID: <20060911231838.4737.6812.stgit@dwillia2-linux.ch.intel.com>
References: <1158015632.4241.31.camel@dwillia2-linux.ch.intel.com>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1158015632.4241.31.camel@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, christopher.leech@intel.com
List-Id: linux-raid.ids

From: Dan Williams <dan.j.williams@intel.com>

Default virtual function that returns an error if the user attempts a
memcpy operation.  An XOR engine is an example of a DMA engine that does
not support memcpy.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 drivers/dma/dmaengine.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index fe62237..33ad690 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -593,6 +593,18 @@ void dma_async_device_unregister(struct 
 }
 
 /**
+ * dma_async_do_memcpy_err - default function for dma devices that
+ *	do not support memcpy
+ */
+dma_cookie_t dma_async_do_memcpy_err(struct dma_chan *chan,
+		union dmaengine_addr dest, unsigned int dest_off,
+		union dmaengine_addr src, unsigned int src_off,
+                size_t len, unsigned long flags)
+{
+	return -ENXIO;
+}
+
+/**
  * dma_async_do_xor_err - default function for dma devices that
  *	do not support xor
  */
@@ -642,6 +654,7 @@ EXPORT_SYMBOL_GPL(dma_async_issue_pendin
 EXPORT_SYMBOL_GPL(dma_async_device_register);
 EXPORT_SYMBOL_GPL(dma_async_device_unregister);
 EXPORT_SYMBOL_GPL(dma_chan_cleanup);
+EXPORT_SYMBOL_GPL(dma_async_do_memcpy_err);
 EXPORT_SYMBOL_GPL(dma_async_do_xor_err);
 EXPORT_SYMBOL_GPL(dma_async_do_memset_err);
 EXPORT_SYMBOL_GPL(dma_async_chan_init);
