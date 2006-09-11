From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 14/19] dmaengine: add dma_sync_wait
Date: Mon, 11 Sep 2006 16:18:49 -0700
Message-ID: <20060911231849.4737.90803.stgit@dwillia2-linux.ch.intel.com>
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

dma_sync_wait is a common routine to live wait for a dma operation to
complete.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 include/linux/dmaengine.h |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 9fd6cbd..0a70c9e 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -750,6 +750,18 @@ static inline void dma_async_unmap_singl
 	chan->device->unmap_single(chan, handle, size, direction);
 }
 
+static inline enum dma_status dma_sync_wait(struct dma_chan *chan,
+						dma_cookie_t cookie)
+{
+	enum dma_status status;
+	dma_async_issue_pending(chan);
+	do {
+		status = dma_async_operation_complete(chan, cookie, NULL, NULL);
+	} while (status == DMA_IN_PROGRESS);
+
+	return status;
+}
+
 /* --- DMA device --- */
 
 int dma_async_device_register(struct dma_device *device);
