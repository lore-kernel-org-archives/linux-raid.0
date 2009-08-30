From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v3 13/14] dmatest: add pq support
Date: Sat, 29 Aug 2009 19:31:07 -0700
Message-ID: <20090830023107.5934.16509.stgit@dwillia2-linux.ch.intel.com>
References: <20090830022908.5934.72142.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090830022908.5934.72142.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, Andre Noll <maan@systemlinux.org>, Maciej Sosnowski <maciej.sosnowski@intel.com>, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

Test raid6 p+q operations with a simple "always multiply by 1" q
calculation to fit into dmatest's current destination verification
scheme.

Reviewed-by: Andre Noll <maan@systemlinux.org>
Acked-by: Maciej Sosnowski <maciej.sosnowski@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dma/dmatest.c |   26 ++++++++++++++++++++++++++
 1 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
index a27c0fb..a5ee541 100644
--- a/drivers/dma/dmatest.c
+++ b/drivers/dma/dmatest.c
@@ -43,6 +43,11 @@ module_param(xor_sources, uint, S_IRUGO);
 MODULE_PARM_DESC(xor_sources,
 		"Number of xor source buffers (default: 3)");
 
+static unsigned int pq_sources = 3;
+module_param(pq_sources, uint, S_IRUGO);
+MODULE_PARM_DESC(pq_sources,
+		"Number of p+q source buffers (default: 3)");
+
 /*
  * Initialization patterns. All bytes in the source buffer has bit 7
  * set, all bytes in the destination buffer has bit 7 cleared.
@@ -227,6 +232,7 @@ static int dmatest_func(void *data)
 	dma_cookie_t		cookie;
 	enum dma_status		status;
 	enum dma_ctrl_flags 	flags;
+	u8			pq_coefs[pq_sources];
 	int			ret;
 	int			src_cnt;
 	int			dst_cnt;
@@ -243,6 +249,11 @@ static int dmatest_func(void *data)
 	else if (thread->type == DMA_XOR) {
 		src_cnt = xor_sources | 1; /* force odd to ensure dst = src */
 		dst_cnt = 1;
+	} else if (thread->type == DMA_PQ) {
+		src_cnt = pq_sources | 1; /* force odd to ensure dst = src */
+		dst_cnt = 2;
+		for (i = 0; i < pq_sources; i++)
+			pq_coefs[i] = 1;
 	} else
 		goto err_srcs;
 
@@ -310,6 +321,15 @@ static int dmatest_func(void *data)
 						      dma_dsts[0] + dst_off,
 						      dma_srcs, xor_sources,
 						      len, flags);
+		else if (thread->type == DMA_PQ) {
+			dma_addr_t dma_pq[dst_cnt];
+
+			for (i = 0; i < dst_cnt; i++)
+				dma_pq[i] = dma_dsts[i] + dst_off;
+			tx = dev->device_prep_dma_pq(chan, dma_pq, dma_srcs,
+						     pq_sources, pq_coefs,
+						     len, flags);
+		}
 
 		if (!tx) {
 			for (i = 0; i < src_cnt; i++)
@@ -446,6 +466,8 @@ static int dmatest_add_threads(struct dmatest_chan *dtc, enum dma_transaction_ty
 		op = "copy";
 	else if (type == DMA_XOR)
 		op = "xor";
+	else if (type == DMA_PQ)
+		op = "pq";
 	else
 		return -EINVAL;
 
@@ -501,6 +523,10 @@ static int dmatest_add_channel(struct dma_chan *chan)
 		cnt = dmatest_add_threads(dtc, DMA_XOR);
 		thread_count += cnt > 0 ?: 0;
 	}
+	if (dma_has_cap(DMA_PQ, dma_dev->cap_mask)) {
+		cnt = dmatest_add_threads(dtc, DMA_PQ);
+		thread_count += cnt > 0 ?: 0;
+	}
 
 	pr_info("dmatest: Started %u threads using %s\n",
 		thread_count, dma_chan_name(chan));

