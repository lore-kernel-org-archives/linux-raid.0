From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 8/8] ioat3: fix pq completion versus channel deallocation race
Date: Fri, 20 Nov 2009 00:06:54 -0700
Message-ID: <20091120070654.13478.57156.stgit@dwillia2-linux.ch.intel.com>
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

The completion of a pq operation is notified with a null descriptor
appended to the end of the chain.  This descriptor needs to be visible
to dma clients otherwise the client is precluded from ensuring all
operations are quiesced before freeing channel resources, i.e. due to
descriptor polling it may get the completion notification ahead of the
interrupt delivered by the null descriptor.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dma/ioat/dma_v3.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/ioat/dma_v3.c b/drivers/dma/ioat/dma_v3.c
index 189788f..e30e0ac 100644
--- a/drivers/dma/ioat/dma_v3.c
+++ b/drivers/dma/ioat/dma_v3.c
@@ -730,7 +730,7 @@ __ioat3_prep_pq_lock(struct dma_chan *c, enum sum_check_flags *result,
 	dump_desc_dbg(ioat, compl_desc);
 
 	/* we leave the channel locked to ensure in order submission */
-	return &desc->txd;
+	return &compl_desc->txd;
 }
 
 static struct dma_async_tx_descriptor *

