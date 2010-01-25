From: Anatolij Gustschin <agust@denx.de>
Subject: [PATCH] dmatest: correct raid6 pq test
Date: Mon, 25 Jan 2010 09:15:03 +0100
Message-ID: <1264407303-14264-1-git-send-email-agust@denx.de>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Anatolij Gustschin <agust@denx.de>
List-Id: linux-raid.ids

The number of pq sources specified by module parameter "pq_sources"
is always forced odd to fit into dmatest's destination verificaton
scheme. But number of pq sources and coefficients as passed to the
driver's prep_dma_pq() is not adjusted accordingly.

Fix it now to get correct testing results in the case passed
"pq_sources" parameter is even.

Signed-off-by: Anatolij Gustschin <agust@denx.de>
---
 drivers/dma/dmatest.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
index 8b90516..cc0f329 100644
--- a/drivers/dma/dmatest.c
+++ b/drivers/dma/dmatest.c
@@ -237,7 +237,7 @@ static int dmatest_func(void *data)
 	dma_cookie_t		cookie;
 	enum dma_status		status;
 	enum dma_ctrl_flags 	flags;
-	u8			pq_coefs[pq_sources];
+	u8			pq_coefs[pq_sources + 1];
 	int			ret;
 	int			src_cnt;
 	int			dst_cnt;
@@ -257,7 +257,7 @@ static int dmatest_func(void *data)
 	} else if (thread->type == DMA_PQ) {
 		src_cnt = pq_sources | 1; /* force odd to ensure dst = src */
 		dst_cnt = 2;
-		for (i = 0; i < pq_sources; i++)
+		for (i = 0; i < src_cnt; i++)
 			pq_coefs[i] = 1;
 	} else
 		goto err_srcs;
@@ -355,7 +355,7 @@ static int dmatest_func(void *data)
 			for (i = 0; i < dst_cnt; i++)
 				dma_pq[i] = dma_dsts[i] + dst_off;
 			tx = dev->device_prep_dma_pq(chan, dma_pq, dma_srcs,
-						     pq_sources, pq_coefs,
+						     src_cnt, pq_coefs,
 						     len, flags);
 		}
 
-- 
1.5.6.3

