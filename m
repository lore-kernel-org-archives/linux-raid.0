From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 1/4] ioatdma: fix sed pool selection
Date: Wed, 13 Nov 2013 12:12:19 -0800
Message-ID: <20131113201219.12667.30357.stgit@viggo.jf.intel.com>
References: <20131113200146.12667.19447.stgit@viggo.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20131113200146.12667.19447.stgit@viggo.jf.intel.com>
Sender: stable-owner@vger.kernel.org
To: dmaengine@vger.kernel.org
Cc: vinod.koul@intel.com, linux-raid@vger.kernel.org, Dave Jiang <dave.jiang@intel.com>, stable@vger.kernel.org
List-Id: linux-raid.ids

The array to lookup the sed pool based on the number of sources
(pq16_idx_to_sedi) is 16 entries and expects a max source index.
However, we pass the total source count which runs off the end of the
array when src_cnt == 16.  The minimal fix is to just pass src_cnt-1,
but given we know the source count is > 8 we can just calculate the sed
pool by (src_cnt - 2) >> 3.

Cc: Dave Jiang <dave.jiang@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dma/ioat/dma_v3.c |   16 +---------------
 1 files changed, 1 insertions(+), 15 deletions(-)

diff --git a/drivers/dma/ioat/dma_v3.c b/drivers/dma/ioat/dma_v3.c
index 44786ad2a4cf..f26a35d43ba1 100644
--- a/drivers/dma/ioat/dma_v3.c
+++ b/drivers/dma/ioat/dma_v3.c
@@ -87,13 +87,6 @@ static const u8 pq_idx_to_field[] = { 1, 4, 5, 0, 1, 2, 4, 5 };
 static const u8 pq16_idx_to_field[] = { 1, 4, 1, 2, 3, 4, 5, 6, 7,
 					0, 1, 2, 3, 4, 5, 6 };
 
-/*
- * technically sources 1 and 2 do not require SED, but the op will have
- * at least 9 descriptors so that's irrelevant.
- */
-static const u8 pq16_idx_to_sed[] = { 0, 0, 0, 0, 0, 0, 0, 0, 0,
-				      1, 1, 1, 1, 1, 1, 1 };
-
 static void ioat3_eh(struct ioat2_dma_chan *ioat);
 
 static void xor_set_src(struct ioat_raw_descriptor *descs[2],
@@ -128,12 +121,6 @@ static void pq_set_src(struct ioat_raw_descriptor *descs[2],
 	pq->coef[idx] = coef;
 }
 
-static int sed_get_pq16_pool_idx(int src_cnt)
-{
-
-	return pq16_idx_to_sed[src_cnt];
-}
-
 static bool is_jf_ioat(struct pci_dev *pdev)
 {
 	switch (pdev->device) {
@@ -994,8 +981,7 @@ __ioat3_prep_pq16_lock(struct dma_chan *c, enum sum_check_flags *result,
 
 		descs[0] = (struct ioat_raw_descriptor *) pq;
 
-		desc->sed = ioat3_alloc_sed(device,
-					    sed_get_pq16_pool_idx(src_cnt));
+		desc->sed = ioat3_alloc_sed(device, (src_cnt-2) >> 3);
 		if (!desc->sed) {
 			dev_err(to_dev(chan),
 				"%s: no free sed entries\n", __func__);
