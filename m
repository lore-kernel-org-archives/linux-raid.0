From: Dan Williams <dan.j.williams@intel.com>
Subject: [git pull] async_tx and a fsldma fix for 2.6.25-rc
Date: Tue, 18 Mar 2008 17:45:00 -0700
Message-ID: <1205887500.7141.46.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: NeilBrown <neilb@suse.de>, Zhang Wei <wei.zhang@freescale.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Linus, please pull from:

	master.kernel.org:/pub/scm/linux/kernel/git/djbw/async_tx.git fixes

to receive:

Dan Williams (1):
      async_tx: avoid the async xor_zero_sum path when src_cnt > device->max_xor

Zhang Wei (1):
      fsldma: Fix the DMA halt when using DMA_INTERRUPT async_tx transfer.

 crypto/async_tx/async_xor.c |    2 +-
 drivers/dma/fsldma.c        |   30 ++++++++++++++++++++++++++++++
 drivers/dma/fsldma.h        |    1 +
 3 files changed, 32 insertions(+), 1 deletions(-)


Full log:
commit 8d8002f642886ae256a3c5d70fe8aff4faf3631a
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Tue Mar 18 21:23:59 2008 -0700

    async_tx: avoid the async xor_zero_sum path when src_cnt > device->max_xor
    
    If the channel cannot perform the operation in one call to
    ->device_prep_dma_zero_sum, then fallback to the xor+page_is_zero path.
    This only affects users with arrays larger than 16 devices on iop13xx or
    32 devices on iop3xx.
    
    Cc: <stable@kernel.org>
    Cc: Neil Brown <neilb@suse.de>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

diff --git a/crypto/async_tx/async_xor.c b/crypto/async_tx/async_xor.c
index 7a9db35..1c445c7 100644
--- a/crypto/async_tx/async_xor.c
+++ b/crypto/async_tx/async_xor.c
@@ -271,7 +271,7 @@ async_xor_zero_sum(struct page *dest, struct page **src_list,
 
 	BUG_ON(src_cnt <= 1);
 
-	if (device) {
+	if (device && src_cnt <= device->max_xor) {
 		dma_addr_t *dma_src = (dma_addr_t *) src_list;
 		unsigned long dma_prep_flags = cb_fn ? DMA_PREP_INTERRUPT : 0;
 		int i;

commit f79abb627f033c85a6088231f20c85bc4a9bd757
Author: Zhang Wei <wei.zhang@freescale.com>
Date:   Tue Mar 18 18:45:00 2008 -0700

    fsldma: Fix the DMA halt when using DMA_INTERRUPT async_tx transfer.
    
    The DMA_INTERRUPT async_tx is a NULL transfer, thus the BCR(count register)
    is 0. When the transfer started with a byte count of zero, the DMA
    controller will triger a PE(programming error) event and halt, not a normal
    interrupt. I add special codes for PE event and DMA_INTERRUPT
    async_tx testing.
    
    Signed-off-by: Zhang Wei <wei.zhang@freescale.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index ad2f938..7269230 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -123,6 +123,11 @@ static dma_addr_t get_ndar(struct fsl_dma_chan *fsl_chan)
 	return DMA_IN(fsl_chan, &fsl_chan->reg_base->ndar, 64);
 }
 
+static u32 get_bcr(struct fsl_dma_chan *fsl_chan)
+{
+	return DMA_IN(fsl_chan, &fsl_chan->reg_base->bcr, 32);
+}
+
 static int dma_is_idle(struct fsl_dma_chan *fsl_chan)
 {
 	u32 sr = get_sr(fsl_chan);
@@ -426,6 +431,9 @@ fsl_dma_prep_interrupt(struct dma_chan *chan)
 	new->async_tx.cookie = -EBUSY;
 	new->async_tx.ack = 0;
 
+	/* Insert the link descriptor to the LD ring */
+	list_add_tail(&new->node, &new->async_tx.tx_list);
+
 	/* Set End-of-link to the last link descriptor of new list*/
 	set_ld_eol(fsl_chan, new);
 
@@ -701,6 +709,23 @@ static irqreturn_t fsl_dma_chan_do_interrupt(int irq, void *data)
 	if (stat & FSL_DMA_SR_TE)
 		dev_err(fsl_chan->dev, "Transfer Error!\n");
 
+	/* Programming Error
+	 * The DMA_INTERRUPT async_tx is a NULL transfer, which will
+	 * triger a PE interrupt.
+	 */
+	if (stat & FSL_DMA_SR_PE) {
+		dev_dbg(fsl_chan->dev, "event: Programming Error INT\n");
+		if (get_bcr(fsl_chan) == 0) {
+			/* BCR register is 0, this is a DMA_INTERRUPT async_tx.
+			 * Now, update the completed cookie, and continue the
+			 * next uncompleted transfer.
+			 */
+			fsl_dma_update_completed_cookie(fsl_chan);
+			fsl_chan_xfer_ld_queue(fsl_chan);
+		}
+		stat &= ~FSL_DMA_SR_PE;
+	}
+
 	/* If the link descriptor segment transfer finishes,
 	 * we will recycle the used descriptor.
 	 */
@@ -841,6 +866,11 @@ static int fsl_dma_self_test(struct fsl_dma_chan *fsl_chan)
 	tx3 = fsl_dma_prep_memcpy(chan, dma_dest, dma_src, test_size / 4, 0);
 	async_tx_ack(tx3);
 
+	/* Interrupt tx test */
+	tx1 = fsl_dma_prep_interrupt(chan);
+	async_tx_ack(tx1);
+	cookie = fsl_dma_tx_submit(tx1);
+
 	/* Test exchanging the prepared tx sort */
 	cookie = fsl_dma_tx_submit(tx3);
 	cookie = fsl_dma_tx_submit(tx2);
diff --git a/drivers/dma/fsldma.h b/drivers/dma/fsldma.h
index ba78c42..fddd6ae 100644
--- a/drivers/dma/fsldma.h
+++ b/drivers/dma/fsldma.h
@@ -40,6 +40,7 @@
 #define FSL_DMA_MR_EOTIE	0x00000080
 
 #define FSL_DMA_SR_CH		0x00000020
+#define FSL_DMA_SR_PE		0x00000010
 #define FSL_DMA_SR_CB		0x00000004
 #define FSL_DMA_SR_TE		0x00000080
 #define FSL_DMA_SR_EOSI		0x00000002


