From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 05/18] ioat2+: add fence support
Date: Thu, 03 Sep 2009 23:45:00 -0700
Message-ID: <20090904064500.7141.60154.stgit@dwillia2-linux.ch.intel.com>
References: <20090904064308.7141.30576.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932697AbZIDGpn@vger.kernel.org>
In-Reply-To: <20090904064308.7141.30576.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-raid@vger.kernel.org, maciej.sosnowski@intel.com
List-Id: linux-raid.ids

In preparation for adding more operation types to the ioat3 path the
driver needs to honor the DMA_PREP_FENCE flag.  For example the async_tx api
will hand xor->memcpy->xor chains to the driver with the 'fence' flag set on
the first xor and the memcpy operation.  This flag in turn sets the 'fence'
flag in the descriptor control field telling the hardware that future
descriptors in the chain depend on the result of the current descriptor, so
wait for all writes to complete before starting the next operation.

Note that ioat1 does not prefetch the descriptor chain, so does not
require/support fenced operations.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dma/ioat/dma_v2.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/ioat/dma_v2.c b/drivers/dma/ioat/dma_v2.c
index c4d8a6a..b3a1f81 100644
--- a/drivers/dma/ioat/dma_v2.c
+++ b/drivers/dma/ioat/dma_v2.c
@@ -711,6 +711,7 @@ ioat2_dma_prep_memcpy_lock(struct dma_chan *c, dma_addr_t dma_dest,
 	desc->txd.flags = flags;
 	desc->len = total_len;
 	hw->ctl_f.int_en = !!(flags & DMA_PREP_INTERRUPT);
+	hw->ctl_f.fence = !!(flags & DMA_PREP_FENCE);
 	hw->ctl_f.compl_write = 1;
 	dump_desc_dbg(ioat, desc);
 	/* we leave the channel locked to ensure in order submission */
