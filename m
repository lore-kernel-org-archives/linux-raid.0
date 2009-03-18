From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 12/13] dmatest: add dma interrupts and callbacks
Date: Wed, 18 Mar 2009 12:21:17 -0700
Message-ID: <20090318192117.20375.84496.stgit@dwillia2-linux.ch.intel.com>
References: <20090318191248.20375.40560.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090318191248.20375.40560.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: neilb@suse.de, maciej.sosnowski@intel.com
List-Id: linux-raid.ids

Use the callback infrastructure to report driver/hardware hangs or
missed interrupts.  Since this makes the test threads much more
aggressive (from: explicit 1ms sleep to: wait_for_completion) we set the
nice value to 10 so as to not swamp legitimate tasks.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dma/dmatest.c |   37 +++++++++++++++++++++++++++----------
 1 files changed, 27 insertions(+), 10 deletions(-)

diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
index 224acf4..a27c0fb 100644
--- a/drivers/dma/dmatest.c
+++ b/drivers/dma/dmatest.c
@@ -196,6 +196,11 @@ static unsigned int dmatest_verify(u8 **bufs, unsigned int start,
 	return error_count;
 }
 
+static void dmatest_callback(void *completion)
+{
+	complete(completion);
+}
+
 /*
  * This function repeatedly tests DMA transfers of various lengths and
  * offsets for a given operation type until it is told to exit by
@@ -261,13 +266,17 @@ static int dmatest_func(void *data)
 	}
 	thread->dsts[i] = NULL;
 
-	flags = DMA_CTRL_ACK | DMA_COMPL_SKIP_DEST_UNMAP;
+	set_user_nice(current, 10);
+
+	flags = DMA_CTRL_ACK | DMA_COMPL_SKIP_DEST_UNMAP | DMA_PREP_INTERRUPT;
 
 	while (!kthread_should_stop()) {
 		struct dma_device *dev = chan->device;
 		struct dma_async_tx_descriptor *tx = NULL;
 		dma_addr_t dma_srcs[src_cnt];
 		dma_addr_t dma_dsts[dst_cnt];
+		struct completion cmp;
+		unsigned long tmo = msecs_to_jiffies(3000);
 
 		total_tests++;
 
@@ -318,7 +327,10 @@ static int dmatest_func(void *data)
 			failed_tests++;
 			continue;
 		}
-		tx->callback = NULL;
+
+		init_completion(&cmp);
+		tx->callback = dmatest_callback;
+		tx->callback_param = &cmp;
 		cookie = tx->tx_submit(tx);
 
 		if (dma_submit_error(cookie)) {
@@ -332,18 +344,23 @@ static int dmatest_func(void *data)
 		}
 		dma_async_issue_pending(chan);
 
-		do {
-			msleep(1);
-			status = dma_async_is_tx_complete(
-					chan, cookie, NULL, NULL);
-		} while (status == DMA_IN_PROGRESS);
+		tmo = wait_for_completion_timeout(&cmp, tmo);
+		status = dma_async_is_tx_complete(chan, cookie, NULL, NULL);
 
-		if (status == DMA_ERROR) {
-			pr_warning("%s: #%u: error during copy\n",
-					thread_name, total_tests - 1);
+		if (tmo == 0) {
+			pr_warning("%s: #%u: test timed out\n",
+				   thread_name, total_tests - 1);
+			failed_tests++;
+			continue;
+		} else if (status != DMA_SUCCESS) {
+			pr_warning("%s: #%u: got completion callback,"
+				   " but status is \'%s\'\n",
+				   thread_name, total_tests - 1,
+				   status == DMA_ERROR ? "error" : "in progress");
 			failed_tests++;
 			continue;
 		}
+
 		/* Unmap by myself (see DMA_COMPL_SKIP_DEST_UNMAP above) */
 		for (i = 0; i < dst_cnt; i++)
 			dma_unmap_single(dev->dev, dma_dsts[i], test_buf_size,

