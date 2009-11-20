From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 6/8] dmaengine: include xor/pq validate in
	device_has_all_tx_types()
Date: Fri, 20 Nov 2009 00:06:44 -0700
Message-ID: <20091120070644.13478.82384.stgit@dwillia2-linux.ch.intel.com>
References: <20091120070506.13478.77838.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091120070506.13478.77838.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-raid@vger.kernel.org, maciej.sosnowski@intel.com
List-Id: linux-raid.ids

A channel must include these capabilities to satisfy
ASYNC_TX_DISABLE_CHANNEL_SWITCH.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dma/dmaengine.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index bd0b248..b6442f0 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -632,11 +632,15 @@ static bool device_has_all_tx_types(struct dma_device *device)
 	#if defined(CONFIG_ASYNC_XOR) || defined(CONFIG_ASYNC_XOR_MODULE)
 	if (!dma_has_cap(DMA_XOR, device->cap_mask))
 		return false;
+	if (!dma_has_cap(DMA_XOR_VAL, device->cap_mask))
+		return false;
 	#endif
 
 	#if defined(CONFIG_ASYNC_PQ) || defined(CONFIG_ASYNC_PQ_MODULE)
 	if (!dma_has_cap(DMA_PQ, device->cap_mask))
 		return false;
+	if (!dma_has_cap(DMA_PQ_VAL, device->cap_mask))
+		return false;
 	#endif
 
 	return true;

