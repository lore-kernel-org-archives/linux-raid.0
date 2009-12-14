From: Vishnu Suresh <Vishnu@freescale.com>
Subject: [PATCH v1] fsldma: Delete DMA_INTERRUPT capability
Date: Mon, 14 Dec 2009 19:00:23 +0530
Message-ID: <1260797423-7352-1-git-send-email-Vishnu@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@lists.ozlabs.org>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
	<mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
	<mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Sender: linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@lists.ozlabs.org
Errors-To: linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@lists.ozlabs.org
To: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, dan.j.williams@intel.com
Cc: Vishnu Suresh <Vishnu@freescale.com>, B04825@freescale.com, R58472@freescale.com
List-Id: linux-raid.ids

The DMA_INTERRUPT is a NULL transfer, triggering a
Programming Error. Though this Error is handled in
the driver with the fix given in "fsldma: Fix the DMA
halt when using DMA_INTERRUPT async_tx transfer."
<f79abb627f033c85a6088231f20c85bc4a9bd757>,
the RAID5 operation, which initiated the transaction
via Async_tx, hangs.

Hence, this patch removes the DMA_INTERRUPT capability
and the associated code from the driver.

Signed-off-by: Vishnu Suresh <Vishnu@freescale.com>
---
Changes with respect to v0
o. The functionality is removed instead of disabling as
   per comments
o. Rebased to linux-next as of 20091214

 drivers/dma/fsldma.c |   31 -------------------------------
 1 files changed, 0 insertions(+), 31 deletions(-)

diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index 296f9e7..272097a 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -449,35 +449,6 @@ static void fsl_dma_free_chan_resources(struct dma_chan *chan)
 	fsl_chan->desc_pool = NULL;
 }
 
-static struct dma_async_tx_descriptor *
-fsl_dma_prep_interrupt(struct dma_chan *chan, unsigned long flags)
-{
-	struct fsl_dma_chan *fsl_chan;
-	struct fsl_desc_sw *new;
-
-	if (!chan)
-		return NULL;
-
-	fsl_chan = to_fsl_chan(chan);
-
-	new = fsl_dma_alloc_descriptor(fsl_chan);
-	if (!new) {
-		dev_err(fsl_chan->dev, "No free memory for link descriptor\n");
-		return NULL;
-	}
-
-	new->async_tx.cookie = -EBUSY;
-	new->async_tx.flags = flags;
-
-	/* Insert the link descriptor to the LD ring */
-	list_add_tail(&new->node, &new->tx_list);
-
-	/* Set End-of-link to the last link descriptor of new list*/
-	set_ld_eol(fsl_chan, new);
-
-	return &new->async_tx;
-}
-
 static struct dma_async_tx_descriptor *fsl_dma_prep_memcpy(
 	struct dma_chan *chan, dma_addr_t dma_dest, dma_addr_t dma_src,
 	size_t len, unsigned long flags)
@@ -1200,11 +1171,9 @@ static int __devinit of_fsl_dma_probe(struct of_device *dev,
 						- fdev->reg.start + 1);
 
 	dma_cap_set(DMA_MEMCPY, fdev->common.cap_mask);
-	dma_cap_set(DMA_INTERRUPT, fdev->common.cap_mask);
 	dma_cap_set(DMA_SLAVE, fdev->common.cap_mask);
 	fdev->common.device_alloc_chan_resources = fsl_dma_alloc_chan_resources;
 	fdev->common.device_free_chan_resources = fsl_dma_free_chan_resources;
-	fdev->common.device_prep_dma_interrupt = fsl_dma_prep_interrupt;
 	fdev->common.device_prep_dma_memcpy = fsl_dma_prep_memcpy;
 	fdev->common.device_is_tx_complete = fsl_dma_is_complete;
 	fdev->common.device_issue_pending = fsl_dma_memcpy_issue_pending;
-- 
1.6.4.2
