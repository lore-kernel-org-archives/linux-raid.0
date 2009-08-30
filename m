From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v3 10/14] async_tx: remove walk of tx->parent chain in
	dma_wait_for_async_tx
Date: Sat, 29 Aug 2009 19:30:52 -0700
Message-ID: <20090830023052.5934.3855.stgit@dwillia2-linux.ch.intel.com>
References: <20090830022908.5934.72142.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090830022908.5934.72142.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

We currently walk the parent chain when waiting for a given tx to
complete however this walk may race with the driver cleanup routine.
The routines in async_raid6_recov.c may fall back to the synchronous
path at any point so we need to be prepared to call async_tx_quiesce()
(which calls  dma_wait_for_async_tx).  To remove the ->parent walk we
guarantee that every time a dependency is attached ->issue_pending() is
invoked, then we can simply poll the initial descriptor until
completion.

This also allows for a lighter weight 'issue pending' implementation as
there is no longer a requirement to iterate through all the channels'
->issue_pending() routines as long as operations have been submitted in
an ordered chain.  async_tx_issue_pending() is added for this case.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 crypto/async_tx/async_tx.c |   13 +++++++------
 drivers/dma/dmaengine.c    |   45 ++++++++++----------------------------------
 include/linux/async_tx.h   |   23 ++++++++++++++++++++++
 3 files changed, 40 insertions(+), 41 deletions(-)

diff --git a/crypto/async_tx/async_tx.c b/crypto/async_tx/async_tx.c
index 6e37ad3..60615fe 100644
--- a/crypto/async_tx/async_tx.c
+++ b/crypto/async_tx/async_tx.c
@@ -77,8 +77,8 @@ static void
 async_tx_channel_switch(struct dma_async_tx_descriptor *depend_tx,
 			struct dma_async_tx_descriptor *tx)
 {
-	struct dma_chan *chan;
-	struct dma_device *device;
+	struct dma_chan *chan = depend_tx->chan;
+	struct dma_device *device = chan->device;
 	struct dma_async_tx_descriptor *intr_tx = (void *) ~0;
 
 	/* first check to see if we can still append to depend_tx */
@@ -90,11 +90,11 @@ async_tx_channel_switch(struct dma_async_tx_descriptor *depend_tx,
 	}
 	spin_unlock_bh(&depend_tx->lock);
 
-	if (!intr_tx)
+	/* attached dependency, flush the parent channel */
+	if (!intr_tx) {
+		device->device_issue_pending(chan);
 		return;
-
-	chan = depend_tx->chan;
-	device = chan->device;
+	}
 
 	/* see if we can schedule an interrupt
 	 * otherwise poll for completion
@@ -128,6 +128,7 @@ async_tx_channel_switch(struct dma_async_tx_descriptor *depend_tx,
 			intr_tx->tx_submit(intr_tx);
 			async_tx_ack(intr_tx);
 		}
+		device->device_issue_pending(chan);
 	} else {
 		if (dma_wait_for_async_tx(depend_tx) == DMA_ERROR)
 			panic("%s: DMA_ERROR waiting for depend_tx\n",
diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index 6781e8f..e002e0e 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -934,49 +934,24 @@ EXPORT_SYMBOL(dma_async_tx_descriptor_init);
 
 /* dma_wait_for_async_tx - spin wait for a transaction to complete
  * @tx: in-flight transaction to wait on
- *
- * This routine assumes that tx was obtained from a call to async_memcpy,
- * async_xor, async_memset, etc which ensures that tx is "in-flight" (prepped
- * and submitted).  Walking the parent chain is only meant to cover for DMA
- * drivers that do not implement the DMA_INTERRUPT capability and may race with
- * the driver's descriptor cleanup routine.
  */
 enum dma_status
 dma_wait_for_async_tx(struct dma_async_tx_descriptor *tx)
 {
-	enum dma_status status;
-	struct dma_async_tx_descriptor *iter;
-	struct dma_async_tx_descriptor *parent;
+	unsigned long dma_sync_wait_timeout = jiffies + msecs_to_jiffies(5000);
 
 	if (!tx)
 		return DMA_SUCCESS;
 
-	WARN_ONCE(tx->parent, "%s: speculatively walking dependency chain for"
-		  " %s\n", __func__, dma_chan_name(tx->chan));
-
-	/* poll through the dependency chain, return when tx is complete */
-	do {
-		iter = tx;
-
-		/* find the root of the unsubmitted dependency chain */
-		do {
-			parent = iter->parent;
-			if (!parent)
-				break;
-			else
-				iter = parent;
-		} while (parent);
-
-		/* there is a small window for ->parent == NULL and
-		 * ->cookie == -EBUSY
-		 */
-		while (iter->cookie == -EBUSY)
-			cpu_relax();
-
-		status = dma_sync_wait(iter->chan, iter->cookie);
-	} while (status == DMA_IN_PROGRESS || (iter != tx));
-
-	return status;
+	while (tx->cookie == -EBUSY) {
+		if (time_after_eq(jiffies, dma_sync_wait_timeout)) {
+			pr_err("%s timeout waiting for descriptor submission\n",
+				__func__);
+			return DMA_ERROR;
+		}
+		cpu_relax();
+	}
+	return dma_sync_wait(tx->chan, tx->cookie);
 }
 EXPORT_SYMBOL_GPL(dma_wait_for_async_tx);
 
diff --git a/include/linux/async_tx.h b/include/linux/async_tx.h
index 3d21a25..12a2efc 100644
--- a/include/linux/async_tx.h
+++ b/include/linux/async_tx.h
@@ -83,6 +83,24 @@ struct async_submit_ctl {
 
 #ifdef CONFIG_DMA_ENGINE
 #define async_tx_issue_pending_all dma_issue_pending_all
+
+/**
+ * async_tx_issue_pending - send pending descriptor to the hardware channel
+ * @tx: descriptor handle to retrieve hardware context
+ *
+ * Note: any dependent operations will have already been issued by
+ * async_tx_channel_switch, or (in the case of no channel switch) will
+ * be already pending on this channel.
+ */
+static inline void async_tx_issue_pending(struct dma_async_tx_descriptor *tx)
+{
+	if (likely(tx)) {
+		struct dma_chan *chan = tx->chan;
+		struct dma_device *dma = chan->device;
+
+		dma->device_issue_pending(chan);
+	}
+}
 #ifdef CONFIG_ARCH_HAS_ASYNC_TX_FIND_CHANNEL
 #include <asm/async_tx.h>
 #else
@@ -98,6 +116,11 @@ static inline void async_tx_issue_pending_all(void)
 	do { } while (0);
 }
 
+static inline void async_tx_issue_pending(struct dma_async_tx_descriptor *tx)
+{
+	do { } while (0);
+}
+
 static inline struct dma_chan *
 async_tx_find_channel(struct async_submit_ctl *submit,
 		      enum dma_transaction_type tx_type, struct page **dst,

