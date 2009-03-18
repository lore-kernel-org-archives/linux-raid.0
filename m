From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 11/13] dmatest: add xor test
Date: Wed, 18 Mar 2009 12:21:12 -0700
Message-ID: <20090318192112.20375.76447.stgit@dwillia2-linux.ch.intel.com>
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

Extend dmatest to launch a thread per supported operation type and add
an xor test.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dma/dmatest.c |  274 ++++++++++++++++++++++++++++++++++---------------
 1 files changed, 189 insertions(+), 85 deletions(-)

diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
index e190d8b..224acf4 100644
--- a/drivers/dma/dmatest.c
+++ b/drivers/dma/dmatest.c
@@ -38,6 +38,11 @@ module_param(max_channels, uint, S_IRUGO);
 MODULE_PARM_DESC(max_channels,
 		"Maximum number of channels to use (default: all)");
 
+static unsigned int xor_sources = 3;
+module_param(xor_sources, uint, S_IRUGO);
+MODULE_PARM_DESC(xor_sources,
+		"Number of xor source buffers (default: 3)");
+
 /*
  * Initialization patterns. All bytes in the source buffer has bit 7
  * set, all bytes in the destination buffer has bit 7 cleared.
@@ -59,8 +64,9 @@ struct dmatest_thread {
 	struct list_head	node;
 	struct task_struct	*task;
 	struct dma_chan		*chan;
-	u8			*srcbuf;
-	u8			*dstbuf;
+	u8			**srcs;
+	u8			**dsts;
+	enum dma_transaction_type type;
 };
 
 struct dmatest_chan {
@@ -98,30 +104,37 @@ static unsigned long dmatest_random(void)
 	return buf;
 }
 
-static void dmatest_init_srcbuf(u8 *buf, unsigned int start, unsigned int len)
+static void dmatest_init_srcs(u8 **bufs, unsigned int start, unsigned int len)
 {
 	unsigned int i;
-
-	for (i = 0; i < start; i++)
-		buf[i] = PATTERN_SRC | (~i & PATTERN_COUNT_MASK);
-	for ( ; i < start + len; i++)
-		buf[i] = PATTERN_SRC | PATTERN_COPY
-			| (~i & PATTERN_COUNT_MASK);;
-	for ( ; i < test_buf_size; i++)
-		buf[i] = PATTERN_SRC | (~i & PATTERN_COUNT_MASK);
+	u8 *buf;
+
+	for (; (buf = *bufs); bufs++) {
+		for (i = 0; i < start; i++)
+			buf[i] = PATTERN_SRC | (~i & PATTERN_COUNT_MASK);
+		for ( ; i < start + len; i++)
+			buf[i] = PATTERN_SRC | PATTERN_COPY
+				| (~i & PATTERN_COUNT_MASK);;
+		for ( ; i < test_buf_size; i++)
+			buf[i] = PATTERN_SRC | (~i & PATTERN_COUNT_MASK);
+		buf++;
+	}
 }
 
-static void dmatest_init_dstbuf(u8 *buf, unsigned int start, unsigned int len)
+static void dmatest_init_dsts(u8 **bufs, unsigned int start, unsigned int len)
 {
 	unsigned int i;
-
-	for (i = 0; i < start; i++)
-		buf[i] = PATTERN_DST | (~i & PATTERN_COUNT_MASK);
-	for ( ; i < start + len; i++)
-		buf[i] = PATTERN_DST | PATTERN_OVERWRITE
-			| (~i & PATTERN_COUNT_MASK);
-	for ( ; i < test_buf_size; i++)
-		buf[i] = PATTERN_DST | (~i & PATTERN_COUNT_MASK);
+	u8 *buf;
+
+	for (; (buf = *bufs); bufs++) {
+		for (i = 0; i < start; i++)
+			buf[i] = PATTERN_DST | (~i & PATTERN_COUNT_MASK);
+		for ( ; i < start + len; i++)
+			buf[i] = PATTERN_DST | PATTERN_OVERWRITE
+				| (~i & PATTERN_COUNT_MASK);
+		for ( ; i < test_buf_size; i++)
+			buf[i] = PATTERN_DST | (~i & PATTERN_COUNT_MASK);
+	}
 }
 
 static void dmatest_mismatch(u8 actual, u8 pattern, unsigned int index,
@@ -150,23 +163,30 @@ static void dmatest_mismatch(u8 actual, u8 pattern, unsigned int index,
 				thread_name, index, expected, actual);
 }
 
-static unsigned int dmatest_verify(u8 *buf, unsigned int start,
+static unsigned int dmatest_verify(u8 **bufs, unsigned int start,
 		unsigned int end, unsigned int counter, u8 pattern,
 		bool is_srcbuf)
 {
 	unsigned int i;
 	unsigned int error_count = 0;
 	u8 actual;
-
-	for (i = start; i < end; i++) {
-		actual = buf[i];
-		if (actual != (pattern | (~counter & PATTERN_COUNT_MASK))) {
-			if (error_count < 32)
-				dmatest_mismatch(actual, pattern, i, counter,
-						is_srcbuf);
-			error_count++;
+	u8 expected;
+	u8 *buf;
+	unsigned int counter_orig = counter;
+
+	for (; (buf = *bufs); bufs++) {
+		counter = counter_orig;
+		for (i = start; i < end; i++) {
+			actual = buf[i];
+			expected = pattern | (~counter & PATTERN_COUNT_MASK);
+			if (actual != expected) {
+				if (error_count < 32)
+					dmatest_mismatch(actual, pattern, i,
+							 counter, is_srcbuf);
+				error_count++;
+			}
+			counter++;
 		}
-		counter++;
 	}
 
 	if (error_count > 32)
@@ -178,10 +198,10 @@ static unsigned int dmatest_verify(u8 *buf, unsigned int start,
 
 /*
  * This function repeatedly tests DMA transfers of various lengths and
- * offsets until it is told to exit by kthread_stop(). There may be
- * multiple threads running this function in parallel for a single
- * channel, and there may be multiple channels being tested in
- * parallel.
+ * offsets for a given operation type until it is told to exit by
+ * kthread_stop(). There may be multiple threads running this function
+ * in parallel for a single channel, and there may be multiple channels
+ * being tested in parallel.
  *
  * Before each test, the source and destination buffer is initialized
  * with a known pattern. This pattern is different depending on
@@ -201,25 +221,53 @@ static int dmatest_func(void *data)
 	unsigned int		total_tests = 0;
 	dma_cookie_t		cookie;
 	enum dma_status		status;
+	enum dma_ctrl_flags 	flags;
 	int			ret;
+	int			src_cnt;
+	int			dst_cnt;
+	int			i;
 
 	thread_name = current->comm;
 
 	ret = -ENOMEM;
-	thread->srcbuf = kmalloc(test_buf_size, GFP_KERNEL);
-	if (!thread->srcbuf)
-		goto err_srcbuf;
-	thread->dstbuf = kmalloc(test_buf_size, GFP_KERNEL);
-	if (!thread->dstbuf)
-		goto err_dstbuf;
 
 	smp_rmb();
 	chan = thread->chan;
+	if (thread->type == DMA_MEMCPY)
+		src_cnt = dst_cnt = 1;
+	else if (thread->type == DMA_XOR) {
+		src_cnt = xor_sources | 1; /* force odd to ensure dst = src */
+		dst_cnt = 1;
+	} else
+		goto err_srcs;
+
+	thread->srcs = kcalloc(src_cnt+1, sizeof(u8 *), GFP_KERNEL);
+	if (!thread->srcs)
+		goto err_srcs;
+	for (i = 0; i < src_cnt; i++) {
+		thread->srcs[i] = kmalloc(test_buf_size, GFP_KERNEL);
+		if (!thread->srcs[i])
+			goto err_srcbuf;
+	}
+	thread->srcs[i] = NULL;
+
+	thread->dsts = kcalloc(dst_cnt+1, sizeof(u8 *), GFP_KERNEL);
+	if (!thread->dsts)
+		goto err_dsts;
+	for (i = 0; i < dst_cnt; i++) {
+		thread->dsts[i] = kmalloc(test_buf_size, GFP_KERNEL);
+		if (!thread->dsts[i])
+			goto err_dstbuf;
+	}
+	thread->dsts[i] = NULL;
+
+	flags = DMA_CTRL_ACK | DMA_COMPL_SKIP_DEST_UNMAP;
 
 	while (!kthread_should_stop()) {
 		struct dma_device *dev = chan->device;
-		struct dma_async_tx_descriptor *tx;
-		dma_addr_t dma_src, dma_dest;
+		struct dma_async_tx_descriptor *tx = NULL;
+		dma_addr_t dma_srcs[src_cnt];
+		dma_addr_t dma_dsts[dst_cnt];
 
 		total_tests++;
 
@@ -227,22 +275,41 @@ static int dmatest_func(void *data)
 		src_off = dmatest_random() % (test_buf_size - len + 1);
 		dst_off = dmatest_random() % (test_buf_size - len + 1);
 
-		dmatest_init_srcbuf(thread->srcbuf, src_off, len);
-		dmatest_init_dstbuf(thread->dstbuf, dst_off, len);
+		dmatest_init_srcs(thread->srcs, src_off, len);
+		dmatest_init_dsts(thread->dsts, dst_off, len);
+
+		for (i = 0; i < src_cnt; i++) {
+			u8 *buf = thread->srcs[i] + src_off;
 
-		dma_src = dma_map_single(dev->dev, thread->srcbuf + src_off,
-				len, DMA_TO_DEVICE);
+			dma_srcs[i] = dma_map_single(dev->dev, buf, len,
+						     DMA_TO_DEVICE);
+		}
 		/* map with DMA_BIDIRECTIONAL to force writeback/invalidate */
-		dma_dest = dma_map_single(dev->dev, thread->dstbuf,
-				test_buf_size, DMA_BIDIRECTIONAL);
+		for (i = 0; i < dst_cnt; i++) {
+			dma_dsts[i] = dma_map_single(dev->dev, thread->dsts[i],
+						     test_buf_size,
+						     DMA_BIDIRECTIONAL);
+		}
+
+		if (thread->type == DMA_MEMCPY)
+			tx = dev->device_prep_dma_memcpy(chan,
+							 dma_dsts[0] + dst_off,
+							 dma_srcs[0], len,
+							 flags);
+		else if (thread->type == DMA_XOR)
+			tx = dev->device_prep_dma_xor(chan,
+						      dma_dsts[0] + dst_off,
+						      dma_srcs, xor_sources,
+						      len, flags);
 
-		tx = dev->device_prep_dma_memcpy(chan, dma_dest + dst_off,
-				dma_src, len,
-				DMA_CTRL_ACK | DMA_COMPL_SKIP_DEST_UNMAP);
 		if (!tx) {
-			dma_unmap_single(dev->dev, dma_src, len, DMA_TO_DEVICE);
-			dma_unmap_single(dev->dev, dma_dest,
-					test_buf_size, DMA_BIDIRECTIONAL);
+			for (i = 0; i < src_cnt; i++)
+				dma_unmap_single(dev->dev, dma_srcs[i], len,
+						 DMA_TO_DEVICE);
+			for (i = 0; i < dst_cnt; i++)
+				dma_unmap_single(dev->dev, dma_dsts[i],
+						 test_buf_size,
+						 DMA_BIDIRECTIONAL);
 			pr_warning("%s: #%u: prep error with src_off=0x%x "
 					"dst_off=0x%x len=0x%x\n",
 					thread_name, total_tests - 1,
@@ -263,11 +330,11 @@ static int dmatest_func(void *data)
 			failed_tests++;
 			continue;
 		}
-		dma_async_memcpy_issue_pending(chan);
+		dma_async_issue_pending(chan);
 
 		do {
 			msleep(1);
-			status = dma_async_memcpy_complete(
+			status = dma_async_is_tx_complete(
 					chan, cookie, NULL, NULL);
 		} while (status == DMA_IN_PROGRESS);
 
@@ -278,29 +345,30 @@ static int dmatest_func(void *data)
 			continue;
 		}
 		/* Unmap by myself (see DMA_COMPL_SKIP_DEST_UNMAP above) */
-		dma_unmap_single(dev->dev, dma_dest,
-				test_buf_size, DMA_BIDIRECTIONAL);
+		for (i = 0; i < dst_cnt; i++)
+			dma_unmap_single(dev->dev, dma_dsts[i], test_buf_size,
+					 DMA_BIDIRECTIONAL);
 
 		error_count = 0;
 
 		pr_debug("%s: verifying source buffer...\n", thread_name);
-		error_count += dmatest_verify(thread->srcbuf, 0, src_off,
+		error_count += dmatest_verify(thread->srcs, 0, src_off,
 				0, PATTERN_SRC, true);
-		error_count += dmatest_verify(thread->srcbuf, src_off,
+		error_count += dmatest_verify(thread->srcs, src_off,
 				src_off + len, src_off,
 				PATTERN_SRC | PATTERN_COPY, true);
-		error_count += dmatest_verify(thread->srcbuf, src_off + len,
+		error_count += dmatest_verify(thread->srcs, src_off + len,
 				test_buf_size, src_off + len,
 				PATTERN_SRC, true);
 
 		pr_debug("%s: verifying dest buffer...\n",
 				thread->task->comm);
-		error_count += dmatest_verify(thread->dstbuf, 0, dst_off,
+		error_count += dmatest_verify(thread->dsts, 0, dst_off,
 				0, PATTERN_DST, false);
-		error_count += dmatest_verify(thread->dstbuf, dst_off,
+		error_count += dmatest_verify(thread->dsts, dst_off,
 				dst_off + len, src_off,
 				PATTERN_SRC | PATTERN_COPY, false);
-		error_count += dmatest_verify(thread->dstbuf, dst_off + len,
+		error_count += dmatest_verify(thread->dsts, dst_off + len,
 				test_buf_size, dst_off + len,
 				PATTERN_DST, false);
 
@@ -319,10 +387,16 @@ static int dmatest_func(void *data)
 	}
 
 	ret = 0;
-	kfree(thread->dstbuf);
+	for (i = 0; thread->dsts[i]; i++)
+		kfree(thread->dsts[i]);
 err_dstbuf:
-	kfree(thread->srcbuf);
+	kfree(thread->dsts);
+err_dsts:
+	for (i = 0; thread->srcs[i]; i++)
+		kfree(thread->srcs[i]);
 err_srcbuf:
+	kfree(thread->srcs);
+err_srcs:
 	pr_notice("%s: terminating after %u tests, %u failures (status %d)\n",
 			thread_name, total_tests, failed_tests, ret);
 	return ret;
@@ -344,35 +418,36 @@ static void dmatest_cleanup_channel(struct dmatest_chan *dtc)
 	kfree(dtc);
 }
 
-static int dmatest_add_channel(struct dma_chan *chan)
+static int dmatest_add_threads(struct dmatest_chan *dtc, enum dma_transaction_type type)
 {
-	struct dmatest_chan	*dtc;
-	struct dmatest_thread	*thread;
-	unsigned int		i;
-
-	dtc = kmalloc(sizeof(struct dmatest_chan), GFP_KERNEL);
-	if (!dtc) {
-		pr_warning("dmatest: No memory for %s\n", dma_chan_name(chan));
-		return -ENOMEM;
-	}
+	struct dmatest_thread *thread;
+	struct dma_chan *chan = dtc->chan;
+	char *op;
+	unsigned int i;
 
-	dtc->chan = chan;
-	INIT_LIST_HEAD(&dtc->threads);
+	if (type == DMA_MEMCPY)
+		op = "copy";
+	else if (type == DMA_XOR)
+		op = "xor";
+	else
+		return -EINVAL;
 
 	for (i = 0; i < threads_per_chan; i++) {
 		thread = kzalloc(sizeof(struct dmatest_thread), GFP_KERNEL);
 		if (!thread) {
-			pr_warning("dmatest: No memory for %s-test%u\n",
-				   dma_chan_name(chan), i);
+			pr_warning("dmatest: No memory for %s-%s%u\n",
+				   dma_chan_name(chan), op, i);
+
 			break;
 		}
 		thread->chan = dtc->chan;
+		thread->type = type;
 		smp_wmb();
-		thread->task = kthread_run(dmatest_func, thread, "%s-test%u",
-				dma_chan_name(chan), i);
+		thread->task = kthread_run(dmatest_func, thread, "%s-%s%u",
+				dma_chan_name(chan), op, i);
 		if (IS_ERR(thread->task)) {
-			pr_warning("dmatest: Failed to run thread %s-test%u\n",
-					dma_chan_name(chan), i);
+			pr_warning("dmatest: Failed to run thread %s-%s%u\n",
+					dma_chan_name(chan), op, i);
 			kfree(thread);
 			break;
 		}
@@ -382,7 +457,36 @@ static int dmatest_add_channel(struct dma_chan *chan)
 		list_add_tail(&thread->node, &dtc->threads);
 	}
 
-	pr_info("dmatest: Started %u threads using %s\n", i, dma_chan_name(chan));
+	return i;
+}
+
+static int dmatest_add_channel(struct dma_chan *chan)
+{
+	struct dmatest_chan	*dtc;
+	struct dma_device	*dma_dev = chan->device;
+	unsigned int		thread_count = 0;
+	unsigned int		cnt;
+
+	dtc = kmalloc(sizeof(struct dmatest_chan), GFP_KERNEL);
+	if (!dtc) {
+		pr_warning("dmatest: No memory for %s\n", dma_chan_name(chan));
+		return -ENOMEM;
+	}
+
+	dtc->chan = chan;
+	INIT_LIST_HEAD(&dtc->threads);
+
+	if (dma_has_cap(DMA_MEMCPY, dma_dev->cap_mask)) {
+		cnt = dmatest_add_threads(dtc, DMA_MEMCPY);
+		thread_count += cnt > 0 ?: 0;
+	}
+	if (dma_has_cap(DMA_XOR, dma_dev->cap_mask)) {
+		cnt = dmatest_add_threads(dtc, DMA_XOR);
+		thread_count += cnt > 0 ?: 0;
+	}
+
+	pr_info("dmatest: Started %u threads using %s\n",
+		thread_count, dma_chan_name(chan));
 
 	list_add_tail(&dtc->node, &dmatest_channels);
 	nr_channels++;

