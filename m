From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v2 03/11] async_tx: structify submission arguments,
	add scribble
Date: Mon, 18 May 2009 17:59:41 -0700
Message-ID: <20090519005941.4104.24363.stgit@dwillia2-linux.ch.intel.com>
References: <20090519005647.4104.81119.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090519005647.4104.81119.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: maan@systemlinux.org, linux-kernel@vger.kernel.org, yur@emcraft.com, hpa@zytor.com
List-Id: linux-raid.ids

Prepare the api for the arrival of a new parameter, 'scribble'.  This
will allow callers to identify scratchpad memory for dma address or page
address conversions.  As this adds yet another parameter, take this
opportunity to convert the common submission parameters (flags,
dependency, callback, and callback argument) into an object that is
passed by reference.

[ Impact: moves api pass-by-value parameters to a pass-by-reference struct ]

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 crypto/async_tx/async_memcpy.c |   21 ++++-----
 crypto/async_tx/async_memset.c |   23 ++++------
 crypto/async_tx/async_tx.c     |   34 +++++++--------
 crypto/async_tx/async_xor.c    |   93 +++++++++++++++++-----------------------
 drivers/md/raid5.c             |   59 +++++++++++++++----------
 include/linux/async_tx.h       |   84 +++++++++++++++++++++++-------------
 6 files changed, 161 insertions(+), 153 deletions(-)

diff --git a/crypto/async_tx/async_memcpy.c b/crypto/async_tx/async_memcpy.c
index 7117ec6..c9342ae 100644
--- a/crypto/async_tx/async_memcpy.c
+++ b/crypto/async_tx/async_memcpy.c
@@ -35,26 +35,23 @@
  * @src: src page
  * @offset: offset in pages to start transaction
  * @len: length in bytes
- * @flags: ASYNC_TX_ACK
- * @depend_tx: memcpy depends on the result of this transaction
- * @cb_fn: function to call when the memcpy completes
- * @cb_param: parameter to pass to the callback routine
+ * @submit: submission / completion modifiers
  */
 struct dma_async_tx_descriptor *
 async_memcpy(struct page *dest, struct page *src, unsigned int dest_offset,
-	unsigned int src_offset, size_t len, enum async_tx_flags flags,
-	struct dma_async_tx_descriptor *depend_tx,
-	dma_async_tx_callback cb_fn, void *cb_param)
+	     unsigned int src_offset, size_t len,
+	     struct async_submit_ctl *submit)
 {
-	struct dma_chan *chan = async_tx_find_channel(depend_tx, DMA_MEMCPY,
+	struct dma_chan *chan = async_tx_find_channel(submit, DMA_MEMCPY,
 						      &dest, 1, &src, 1, len);
 	struct dma_device *device = chan ? chan->device : NULL;
 	struct dma_async_tx_descriptor *tx = NULL;
 
 	if (device) {
 		dma_addr_t dma_dest, dma_src;
-		unsigned long dma_prep_flags = cb_fn ? DMA_PREP_INTERRUPT : 0;
+		unsigned long dma_prep_flags;
 
+		dma_prep_flags = submit->cb_fn ? DMA_PREP_INTERRUPT : 0;
 		dma_dest = dma_map_page(device->dev, dest, dest_offset, len,
 					DMA_FROM_DEVICE);
 
@@ -67,13 +64,13 @@ async_memcpy(struct page *dest, struct page *src, unsigned int dest_offset,
 
 	if (tx) {
 		pr_debug("%s: (async) len: %zu\n", __func__, len);
-		async_tx_submit(chan, tx, flags, depend_tx, cb_fn, cb_param);
+		async_tx_submit(chan, tx, submit);
 	} else {
 		void *dest_buf, *src_buf;
 		pr_debug("%s: (sync) len: %zu\n", __func__, len);
 
 		/* wait for any prerequisite operations */
-		async_tx_quiesce(&depend_tx);
+		async_tx_quiesce(&submit->depend_tx);
 
 		dest_buf = kmap_atomic(dest, KM_USER0) + dest_offset;
 		src_buf = kmap_atomic(src, KM_USER1) + src_offset;
@@ -83,7 +80,7 @@ async_memcpy(struct page *dest, struct page *src, unsigned int dest_offset,
 		kunmap_atomic(dest_buf, KM_USER0);
 		kunmap_atomic(src_buf, KM_USER1);
 
-		async_tx_sync_epilog(cb_fn, cb_param);
+		async_tx_sync_epilog(submit);
 	}
 
 	return tx;
diff --git a/crypto/async_tx/async_memset.c b/crypto/async_tx/async_memset.c
index b2f1338..e347dbe 100644
--- a/crypto/async_tx/async_memset.c
+++ b/crypto/async_tx/async_memset.c
@@ -35,26 +35,21 @@
  * @val: fill value
  * @offset: offset in pages to start transaction
  * @len: length in bytes
- * @flags: ASYNC_TX_ACK
- * @depend_tx: memset depends on the result of this transaction
- * @cb_fn: function to call when the memcpy completes
- * @cb_param: parameter to pass to the callback routine
  */
 struct dma_async_tx_descriptor *
-async_memset(struct page *dest, int val, unsigned int offset,
-	size_t len, enum async_tx_flags flags,
-	struct dma_async_tx_descriptor *depend_tx,
-	dma_async_tx_callback cb_fn, void *cb_param)
+async_memset(struct page *dest, int val, unsigned int offset, size_t len,
+	     struct async_submit_ctl *submit)
 {
-	struct dma_chan *chan = async_tx_find_channel(depend_tx, DMA_MEMSET,
+	struct dma_chan *chan = async_tx_find_channel(submit, DMA_MEMSET,
 						      &dest, 1, NULL, 0, len);
 	struct dma_device *device = chan ? chan->device : NULL;
 	struct dma_async_tx_descriptor *tx = NULL;
 
 	if (device) {
 		dma_addr_t dma_dest;
-		unsigned long dma_prep_flags = cb_fn ? DMA_PREP_INTERRUPT : 0;
+		unsigned long dma_prep_flags;
 
+		dma_prep_flags = submit->cb_fn ? DMA_PREP_INTERRUPT : 0;
 		dma_dest = dma_map_page(device->dev, dest, offset, len,
 					DMA_FROM_DEVICE);
 
@@ -64,19 +59,19 @@ async_memset(struct page *dest, int val, unsigned int offset,
 
 	if (tx) {
 		pr_debug("%s: (async) len: %zu\n", __func__, len);
-		async_tx_submit(chan, tx, flags, depend_tx, cb_fn, cb_param);
+		async_tx_submit(chan, tx, submit);
 	} else { /* run the memset synchronously */
 		void *dest_buf;
 		pr_debug("%s: (sync) len: %zu\n", __func__, len);
 
-		dest_buf = (void *) (((char *) page_address(dest)) + offset);
+		dest_buf = page_address(dest) + offset;
 
 		/* wait for any prerequisite operations */
-		async_tx_quiesce(&depend_tx);
+		async_tx_quiesce(&submit->depend_tx);
 
 		memset(dest_buf, val, len);
 
-		async_tx_sync_epilog(cb_fn, cb_param);
+		async_tx_sync_epilog(submit);
 	}
 
 	return tx;
diff --git a/crypto/async_tx/async_tx.c b/crypto/async_tx/async_tx.c
index 3766bc3..85e1b44 100644
--- a/crypto/async_tx/async_tx.c
+++ b/crypto/async_tx/async_tx.c
@@ -45,13 +45,15 @@ static void __exit async_tx_exit(void)
 /**
  * __async_tx_find_channel - find a channel to carry out the operation or let
  *	the transaction execute synchronously
- * @depend_tx: transaction dependency
+ * @submit: transaction dependency and submission modifiers
  * @tx_type: transaction type
  */
 struct dma_chan *
-__async_tx_find_channel(struct dma_async_tx_descriptor *depend_tx,
-	enum dma_transaction_type tx_type)
+__async_tx_find_channel(struct async_submit_ctl *submit,
+			enum dma_transaction_type tx_type)
 {
+	struct dma_async_tx_descriptor *depend_tx = submit->depend_tx;
+
 	/* see if we can keep the chain on one channel */
 	if (depend_tx &&
 	    dma_has_cap(tx_type, depend_tx->chan->device->cap_mask))
@@ -160,11 +162,12 @@ enum submit_disposition {
 
 void
 async_tx_submit(struct dma_chan *chan, struct dma_async_tx_descriptor *tx,
-	enum async_tx_flags flags, struct dma_async_tx_descriptor *depend_tx,
-	dma_async_tx_callback cb_fn, void *cb_param)
+		struct async_submit_ctl *submit)
 {
-	tx->callback = cb_fn;
-	tx->callback_param = cb_param;
+	struct dma_async_tx_descriptor *depend_tx = submit->depend_tx;
+
+	tx->callback = submit->cb_fn;
+	tx->callback_param = submit->cb_param;
 
 	if (depend_tx) {
 		enum submit_disposition s;
@@ -220,7 +223,7 @@ async_tx_submit(struct dma_chan *chan, struct dma_async_tx_descriptor *tx,
 		tx->tx_submit(tx);
 	}
 
-	if (flags & ASYNC_TX_ACK)
+	if (submit->flags & ASYNC_TX_ACK)
 		async_tx_ack(tx);
 
 	if (depend_tx)
@@ -231,19 +234,14 @@ EXPORT_SYMBOL_GPL(async_tx_submit);
 /**
  * async_trigger_callback - schedules the callback function to be run after
  * any dependent operations have been completed.
- * @flags: ASYNC_TX_ACK
- * @depend_tx: 'callback' requires the completion of this transaction
- * @cb_fn: function to call after depend_tx completes
- * @cb_param: parameter to pass to the callback routine
  */
 struct dma_async_tx_descriptor *
-async_trigger_callback(enum async_tx_flags flags,
-	struct dma_async_tx_descriptor *depend_tx,
-	dma_async_tx_callback cb_fn, void *cb_param)
+async_trigger_callback(struct async_submit_ctl *submit)
 {
 	struct dma_chan *chan;
 	struct dma_device *device;
 	struct dma_async_tx_descriptor *tx;
+	struct dma_async_tx_descriptor *depend_tx = submit->depend_tx;
 
 	if (depend_tx) {
 		chan = depend_tx->chan;
@@ -262,14 +260,14 @@ async_trigger_callback(enum async_tx_flags flags,
 	if (tx) {
 		pr_debug("%s: (async)\n", __func__);
 
-		async_tx_submit(chan, tx, flags, depend_tx, cb_fn, cb_param);
+		async_tx_submit(chan, tx, submit);
 	} else {
 		pr_debug("%s: (sync)\n", __func__);
 
 		/* wait for any prerequisite operations */
-		async_tx_quiesce(&depend_tx);
+		async_tx_quiesce(&submit->depend_tx);
 
-		async_tx_sync_epilog(cb_fn, cb_param);
+		async_tx_sync_epilog(submit);
 	}
 
 	return tx;
diff --git a/crypto/async_tx/async_xor.c b/crypto/async_tx/async_xor.c
index 3cc5dc7..6290d05 100644
--- a/crypto/async_tx/async_xor.c
+++ b/crypto/async_tx/async_xor.c
@@ -34,18 +34,16 @@
 static __async_inline struct dma_async_tx_descriptor *
 do_async_xor(struct dma_chan *chan, struct page *dest, struct page **src_list,
 	     unsigned int offset, int src_cnt, size_t len,
-	     enum async_tx_flags flags,
-	     struct dma_async_tx_descriptor *depend_tx,
-	     dma_async_tx_callback cb_fn, void *cb_param)
+	     struct async_submit_ctl *submit)
 {
 	struct dma_device *dma = chan->device;
 	dma_addr_t *dma_src = (dma_addr_t *) src_list;
 	struct dma_async_tx_descriptor *tx = NULL;
 	int src_off = 0;
 	int i;
-	dma_async_tx_callback _cb_fn;
-	void *_cb_param;
-	enum async_tx_flags async_flags;
+	dma_async_tx_callback cb_fn_orig = submit->cb_fn;
+	void *cb_param_orig = submit->cb_param;
+	enum async_tx_flags flags_orig = submit->flags;
 	enum dma_ctrl_flags dma_flags;
 	int xor_src_cnt;
 	dma_addr_t dma_dest;
@@ -63,7 +61,7 @@ do_async_xor(struct dma_chan *chan, struct page *dest, struct page **src_list,
 	}
 
 	while (src_cnt) {
-		async_flags = flags;
+		submit->flags = flags_orig;
 		dma_flags = 0;
 		xor_src_cnt = min(src_cnt, dma->max_xor);
 		/* if we are submitting additional xors, leave the chain open,
@@ -71,15 +69,15 @@ do_async_xor(struct dma_chan *chan, struct page *dest, struct page **src_list,
 		 * buffer mapped
 		 */
 		if (src_cnt > xor_src_cnt) {
-			async_flags &= ~ASYNC_TX_ACK;
+			submit->flags &= ~ASYNC_TX_ACK;
 			dma_flags = DMA_COMPL_SKIP_DEST_UNMAP;
-			_cb_fn = NULL;
-			_cb_param = NULL;
+			submit->cb_fn = NULL;
+			submit->cb_param = NULL;
 		} else {
-			_cb_fn = cb_fn;
-			_cb_param = cb_param;
+			submit->cb_fn = cb_fn_orig;
+			submit->cb_param = cb_param_orig;
 		}
-		if (_cb_fn)
+		if (submit->cb_fn)
 			dma_flags |= DMA_PREP_INTERRUPT;
 
 		/* Since we have clobbered the src_list we are committed
@@ -90,7 +88,7 @@ do_async_xor(struct dma_chan *chan, struct page *dest, struct page **src_list,
 					      xor_src_cnt, len, dma_flags);
 
 		if (unlikely(!tx))
-			async_tx_quiesce(&depend_tx);
+			async_tx_quiesce(&submit->depend_tx);
 
 		/* spin wait for the preceeding transactions to complete */
 		while (unlikely(!tx)) {
@@ -101,10 +99,8 @@ do_async_xor(struct dma_chan *chan, struct page *dest, struct page **src_list,
 						      dma_flags);
 		}
 
-		async_tx_submit(chan, tx, async_flags, depend_tx, _cb_fn,
-				_cb_param);
-
-		depend_tx = tx;
+		async_tx_submit(chan, tx, submit);
+		submit->depend_tx = tx;
 
 		if (src_cnt > xor_src_cnt) {
 			/* drop completed sources */
@@ -123,8 +119,7 @@ do_async_xor(struct dma_chan *chan, struct page *dest, struct page **src_list,
 
 static void
 do_sync_xor(struct page *dest, struct page **src_list, unsigned int offset,
-	    int src_cnt, size_t len, enum async_tx_flags flags,
-	    dma_async_tx_callback cb_fn, void *cb_param)
+	    int src_cnt, size_t len, struct async_submit_ctl *submit)
 {
 	int i;
 	int xor_src_cnt;
@@ -139,7 +134,7 @@ do_sync_xor(struct page *dest, struct page **src_list, unsigned int offset,
 	/* set destination address */
 	dest_buf = page_address(dest) + offset;
 
-	if (flags & ASYNC_TX_XOR_ZERO_DST)
+	if (submit->flags & ASYNC_TX_XOR_ZERO_DST)
 		memset(dest_buf, 0, len);
 
 	while (src_cnt > 0) {
@@ -152,7 +147,7 @@ do_sync_xor(struct page *dest, struct page **src_list, unsigned int offset,
 		src_off += xor_src_cnt;
 	}
 
-	async_tx_sync_epilog(cb_fn, cb_param);
+	async_tx_sync_epilog(submit);
 }
 
 /**
@@ -167,18 +162,13 @@ do_sync_xor(struct page *dest, struct page **src_list, unsigned int offset,
  * @offset: offset in pages to start transaction
  * @src_cnt: number of source pages
  * @len: length in bytes
- * @flags: ASYNC_TX_XOR_ZERO_DST, ASYNC_TX_XOR_DROP_DEST, ASYNC_TX_ACK
- * @depend_tx: xor depends on the result of this transaction.
- * @cb_fn: function to call when the xor completes
- * @cb_param: parameter to pass to the callback routine
+ * @submit: submission / completion modifiers
  */
 struct dma_async_tx_descriptor *
 async_xor(struct page *dest, struct page **src_list, unsigned int offset,
-	int src_cnt, size_t len, enum async_tx_flags flags,
-	struct dma_async_tx_descriptor *depend_tx,
-	dma_async_tx_callback cb_fn, void *cb_param)
+	  int src_cnt, size_t len, struct async_submit_ctl *submit)
 {
-	struct dma_chan *chan = async_tx_find_channel(depend_tx, DMA_XOR,
+	struct dma_chan *chan = async_tx_find_channel(submit, DMA_XOR,
 						      &dest, 1, src_list,
 						      src_cnt, len);
 	BUG_ON(src_cnt <= 1);
@@ -188,7 +178,7 @@ async_xor(struct page *dest, struct page **src_list, unsigned int offset,
 		pr_debug("%s (async): len: %zu\n", __func__, len);
 
 		return do_async_xor(chan, dest, src_list, offset, src_cnt, len,
-				    flags, depend_tx, cb_fn, cb_param);
+				    submit);
 	} else {
 		/* run the xor synchronously */
 		pr_debug("%s (sync): len: %zu\n", __func__, len);
@@ -196,16 +186,15 @@ async_xor(struct page *dest, struct page **src_list, unsigned int offset,
 		/* in the sync case the dest is an implied source
 		 * (assumes the dest is the first source)
 		 */
-		if (flags & ASYNC_TX_XOR_DROP_DST) {
+		if (submit->flags & ASYNC_TX_XOR_DROP_DST) {
 			src_cnt--;
 			src_list++;
 		}
 
 		/* wait for any prerequisite operations */
-		async_tx_quiesce(&depend_tx);
+		async_tx_quiesce(&submit->depend_tx);
 
-		do_sync_xor(dest, src_list, offset, src_cnt, len,
-			    flags, cb_fn, cb_param);
+		do_sync_xor(dest, src_list, offset, src_cnt, len, submit);
 
 		return NULL;
 	}
@@ -228,19 +217,14 @@ static int page_is_zero(struct page *p, unsigned int offset, size_t len)
  * @src_cnt: number of source pages
  * @len: length in bytes
  * @result: 0 if sum == 0 else non-zero
- * @flags: ASYNC_TX_ACK
- * @depend_tx: xor depends on the result of this transaction.
- * @cb_fn: function to call when the xor completes
- * @cb_param: parameter to pass to the callback routine
+ * @submit: submission / completion modifiers
  */
 struct dma_async_tx_descriptor *
-async_xor_val(struct page *dest, struct page **src_list,
-	unsigned int offset, int src_cnt, size_t len,
-	u32 *result, enum async_tx_flags flags,
-	struct dma_async_tx_descriptor *depend_tx,
-	dma_async_tx_callback cb_fn, void *cb_param)
+async_xor_val(struct page *dest, struct page **src_list, unsigned int offset,
+	      int src_cnt, size_t len, u32 *result,
+	      struct async_submit_ctl *submit)
 {
-	struct dma_chan *chan = async_tx_find_channel(depend_tx, DMA_XOR_VAL,
+	struct dma_chan *chan = async_tx_find_channel(submit, DMA_XOR_VAL,
 						      &dest, 1, src_list,
 						      src_cnt, len);
 	struct dma_device *device = chan ? chan->device : NULL;
@@ -250,11 +234,12 @@ async_xor_val(struct page *dest, struct page **src_list,
 
 	if (device && src_cnt <= device->max_xor) {
 		dma_addr_t *dma_src = (dma_addr_t *) src_list;
-		unsigned long dma_prep_flags = cb_fn ? DMA_PREP_INTERRUPT : 0;
+		unsigned long dma_prep_flags;
 		int i;
 
 		pr_debug("%s: (async) len: %zu\n", __func__, len);
 
+		dma_prep_flags = submit->cb_fn ? DMA_PREP_INTERRUPT : 0;
 		for (i = 0; i < src_cnt; i++)
 			dma_src[i] = dma_map_page(device->dev, src_list[i],
 						  offset, len, DMA_TO_DEVICE);
@@ -263,7 +248,7 @@ async_xor_val(struct page *dest, struct page **src_list,
 						     len, result,
 						     dma_prep_flags);
 		if (unlikely(!tx)) {
-			async_tx_quiesce(&depend_tx);
+			async_tx_quiesce(&submit->depend_tx);
 
 			while (!tx) {
 				dma_async_issue_pending(chan);
@@ -273,23 +258,23 @@ async_xor_val(struct page *dest, struct page **src_list,
 			}
 		}
 
-		async_tx_submit(chan, tx, flags, depend_tx, cb_fn, cb_param);
+		async_tx_submit(chan, tx, submit);
 	} else {
-		unsigned long xor_flags = flags;
+		enum async_tx_flags flags_orig = submit->flags;
 
 		pr_debug("%s: (sync) len: %zu\n", __func__, len);
 
-		xor_flags |= ASYNC_TX_XOR_DROP_DST;
-		xor_flags &= ~ASYNC_TX_ACK;
+		submit->flags |= ASYNC_TX_XOR_DROP_DST;
+		submit->flags &= ~ASYNC_TX_ACK;
 
-		tx = async_xor(dest, src_list, offset, src_cnt, len, xor_flags,
-			depend_tx, NULL, NULL);
+		tx = async_xor(dest, src_list, offset, src_cnt, len, submit);
 
 		async_tx_quiesce(&tx);
 
 		*result = page_is_zero(dest, offset, len) ? 0 : 1;
 
-		async_tx_sync_epilog(cb_fn, cb_param);
+		async_tx_sync_epilog(submit);
+		submit->flags = flags_orig;
 	}
 
 	return tx;
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 0ef5362..e1920f2 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -499,11 +499,14 @@ async_copy_data(int frombio, struct bio *bio, struct page *page,
 	struct page *bio_page;
 	int i;
 	int page_offset;
+	struct async_submit_ctl submit;
 
 	if (bio->bi_sector >= sector)
 		page_offset = (signed)(bio->bi_sector - sector) * 512;
 	else
 		page_offset = (signed)(sector - bio->bi_sector) * -512;
+
+	init_async_submit(&submit, 0, tx, NULL, NULL, NULL);
 	bio_for_each_segment(bvl, bio, i) {
 		int len = bio_iovec_idx(bio, i)->bv_len;
 		int clen;
@@ -525,13 +528,14 @@ async_copy_data(int frombio, struct bio *bio, struct page *page,
 			bio_page = bio_iovec_idx(bio, i)->bv_page;
 			if (frombio)
 				tx = async_memcpy(page, bio_page, page_offset,
-						  b_offset, clen, 0,
-						  tx, NULL, NULL);
+						  b_offset, clen, &submit);
 			else
 				tx = async_memcpy(bio_page, page, b_offset,
-						  page_offset, clen, 0,
-						  tx, NULL, NULL);
+						  page_offset, clen, &submit);
 		}
+		/* chain the operations */
+		submit.depend_tx = tx;
+
 		if (clen < len) /* hit end of page */
 			break;
 		page_offset +=  len;
@@ -590,6 +594,7 @@ static void ops_run_biofill(struct stripe_head *sh)
 {
 	struct dma_async_tx_descriptor *tx = NULL;
 	raid5_conf_t *conf = sh->raid_conf;
+	struct async_submit_ctl submit;
 	int i;
 
 	pr_debug("%s: stripe %llu\n", __func__,
@@ -613,7 +618,8 @@ static void ops_run_biofill(struct stripe_head *sh)
 	}
 
 	atomic_inc(&sh->count);
-	async_trigger_callback(ASYNC_TX_ACK, tx, ops_complete_biofill, sh);
+	init_async_submit(&submit, ASYNC_TX_ACK, tx, ops_complete_biofill, sh, NULL);
+	async_trigger_callback(&submit);
 }
 
 static void ops_complete_compute5(void *stripe_head_ref)
@@ -645,6 +651,7 @@ static struct dma_async_tx_descriptor *ops_run_compute5(struct stripe_head *sh)
 	struct page *xor_dest = tgt->page;
 	int count = 0;
 	struct dma_async_tx_descriptor *tx;
+	struct async_submit_ctl submit;
 	int i;
 
 	pr_debug("%s: stripe %llu block: %d\n",
@@ -657,13 +664,12 @@ static struct dma_async_tx_descriptor *ops_run_compute5(struct stripe_head *sh)
 
 	atomic_inc(&sh->count);
 
+	init_async_submit(&submit, ASYNC_TX_XOR_ZERO_DST, NULL,
+			  ops_complete_compute5, sh, NULL);
 	if (unlikely(count == 1))
-		tx = async_memcpy(xor_dest, xor_srcs[0], 0, 0, STRIPE_SIZE,
-			0, NULL, ops_complete_compute5, sh);
+		tx = async_memcpy(xor_dest, xor_srcs[0], 0, 0, STRIPE_SIZE, &submit);
 	else
-		tx = async_xor(xor_dest, xor_srcs, 0, count, STRIPE_SIZE,
-			ASYNC_TX_XOR_ZERO_DST, NULL,
-			ops_complete_compute5, sh);
+		tx = async_xor(xor_dest, xor_srcs, 0, count, STRIPE_SIZE, &submit);
 
 	return tx;
 }
@@ -683,6 +689,7 @@ ops_run_prexor(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
 	int disks = sh->disks;
 	struct page *xor_srcs[disks];
 	int count = 0, pd_idx = sh->pd_idx, i;
+	struct async_submit_ctl submit;
 
 	/* existing parity data subtracted */
 	struct page *xor_dest = xor_srcs[count++] = sh->dev[pd_idx].page;
@@ -697,9 +704,9 @@ ops_run_prexor(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
 			xor_srcs[count++] = dev->page;
 	}
 
-	tx = async_xor(xor_dest, xor_srcs, 0, count, STRIPE_SIZE,
-		       ASYNC_TX_XOR_DROP_DST, tx,
-		       ops_complete_prexor, sh);
+	init_async_submit(&submit, ASYNC_TX_XOR_DROP_DST, tx,
+			  ops_complete_prexor, sh, NULL);
+	tx = async_xor(xor_dest, xor_srcs, 0, count, STRIPE_SIZE, &submit);
 
 	return tx;
 }
@@ -772,7 +779,7 @@ ops_run_postxor(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
 	/* kernel stack size limits the total number of disks */
 	int disks = sh->disks;
 	struct page *xor_srcs[disks];
-
+	struct async_submit_ctl submit;
 	int count = 0, pd_idx = sh->pd_idx, i;
 	struct page *xor_dest;
 	int prexor = 0;
@@ -811,13 +818,11 @@ ops_run_postxor(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
 
 	atomic_inc(&sh->count);
 
-	if (unlikely(count == 1)) {
-		flags &= ~(ASYNC_TX_XOR_DROP_DST | ASYNC_TX_XOR_ZERO_DST);
-		tx = async_memcpy(xor_dest, xor_srcs[0], 0, 0, STRIPE_SIZE,
-			flags, tx, ops_complete_postxor, sh);
-	} else
-		tx = async_xor(xor_dest, xor_srcs, 0, count, STRIPE_SIZE,
-			flags, tx, ops_complete_postxor, sh);
+	init_async_submit(&submit, flags, tx, ops_complete_postxor, sh, NULL);
+	if (unlikely(count == 1))
+		tx = async_memcpy(xor_dest, xor_srcs[0], 0, 0, STRIPE_SIZE, &submit);
+	else
+		tx = async_xor(xor_dest, xor_srcs, 0, count, STRIPE_SIZE, &submit);
 }
 
 static void ops_complete_check(void *stripe_head_ref)
@@ -838,6 +843,7 @@ static void ops_run_check(struct stripe_head *sh)
 	int disks = sh->disks;
 	struct page *xor_srcs[disks];
 	struct dma_async_tx_descriptor *tx;
+	struct async_submit_ctl submit;
 
 	int count = 0, pd_idx = sh->pd_idx, i;
 	struct page *xor_dest = xor_srcs[count++] = sh->dev[pd_idx].page;
@@ -851,12 +857,13 @@ static void ops_run_check(struct stripe_head *sh)
 			xor_srcs[count++] = dev->page;
 	}
 
+	init_async_submit(&submit, 0, NULL, NULL, NULL, NULL);
 	tx = async_xor_val(xor_dest, xor_srcs, 0, count, STRIPE_SIZE,
-		&sh->ops.zero_sum_result, 0, NULL, NULL, NULL);
+			   &sh->ops.zero_sum_result, &submit);
 
 	atomic_inc(&sh->count);
-	tx = async_trigger_callback(ASYNC_TX_ACK, tx,
-		ops_complete_check, sh);
+	init_async_submit(&submit, ASYNC_TX_ACK, tx, ops_complete_check, sh, NULL);
+	tx = async_trigger_callback(&submit);
 }
 
 static void raid5_run_ops(struct stripe_head *sh, unsigned long ops_request)
@@ -2664,6 +2671,7 @@ static void handle_stripe_expansion(raid5_conf_t *conf, struct stripe_head *sh,
 		if (i != sh->pd_idx && i != sh->qd_idx) {
 			int dd_idx, j;
 			struct stripe_head *sh2;
+			struct async_submit_ctl submit;
 
 			sector_t bn = compute_blocknr(sh, i, 1);
 			sector_t s = raid5_compute_sector(conf, bn, 0,
@@ -2683,9 +2691,10 @@ static void handle_stripe_expansion(raid5_conf_t *conf, struct stripe_head *sh,
 			}
 
 			/* place all the copies on one channel */
+			init_async_submit(&submit, 0, tx, NULL, NULL, NULL);
 			tx = async_memcpy(sh2->dev[dd_idx].page,
 					  sh->dev[i].page, 0, 0, STRIPE_SIZE,
-					  0, tx, NULL, NULL);
+					  &submit);
 
 			set_bit(R5_Expanded, &sh2->dev[dd_idx].flags);
 			set_bit(R5_UPTODATE, &sh2->dev[dd_idx].flags);
diff --git a/include/linux/async_tx.h b/include/linux/async_tx.h
index 9f14cd5..00cfb63 100644
--- a/include/linux/async_tx.h
+++ b/include/linux/async_tx.h
@@ -65,6 +65,22 @@ enum async_tx_flags {
 	ASYNC_TX_ACK		 = (1 << 2),
 };
 
+/**
+ * struct async_submit_ctl - async_tx submission/completion modifiers
+ * @flags: submission modifiers
+ * @depend_tx: parent dependency of the current operation being submitted
+ * @cb_fn: callback routine to run at operation completion
+ * @cb_param: parameter for the callback routine
+ * @scribble: caller provided space for dma/page address conversions
+ */
+struct async_submit_ctl {
+	enum async_tx_flags flags;
+	struct dma_async_tx_descriptor *depend_tx;
+	dma_async_tx_callback cb_fn;
+	void *cb_param;
+	void *scribble;
+};
+
 #ifdef CONFIG_DMA_ENGINE
 #define async_tx_issue_pending_all dma_issue_pending_all
 #ifdef CONFIG_ARCH_HAS_ASYNC_TX_FIND_CHANNEL
@@ -73,8 +89,8 @@ enum async_tx_flags {
 #define async_tx_find_channel(dep, type, dst, dst_count, src, src_count, len) \
 	 __async_tx_find_channel(dep, type)
 struct dma_chan *
-__async_tx_find_channel(struct dma_async_tx_descriptor *depend_tx,
-	enum dma_transaction_type tx_type);
+__async_tx_find_channel(struct async_submit_ctl *submit,
+			enum dma_transaction_type tx_type);
 #endif /* CONFIG_ARCH_HAS_ASYNC_TX_FIND_CHANNEL */
 #else
 static inline void async_tx_issue_pending_all(void)
@@ -83,9 +99,10 @@ static inline void async_tx_issue_pending_all(void)
 }
 
 static inline struct dma_chan *
-async_tx_find_channel(struct dma_async_tx_descriptor *depend_tx,
-	enum dma_transaction_type tx_type, struct page **dst, int dst_count,
-	struct page **src, int src_count, size_t len)
+async_tx_find_channel(struct async_submit_ctl *submit,
+		      enum dma_transaction_type tx_type, struct page **dst,
+		      int dst_count, struct page **src, int src_count,
+		      size_t len)
 {
 	return NULL;
 }
@@ -97,46 +114,53 @@ async_tx_find_channel(struct dma_async_tx_descriptor *depend_tx,
  * @cb_fn_param: parameter to pass to the callback routine
  */
 static inline void
-async_tx_sync_epilog(dma_async_tx_callback cb_fn, void *cb_fn_param)
+async_tx_sync_epilog(struct async_submit_ctl *submit)
+{
+	if (submit->cb_fn)
+		submit->cb_fn(submit->cb_param);
+}
+
+typedef union {
+	unsigned long addr;
+	struct page *page;
+	dma_addr_t dma;
+} addr_conv_t;
+
+static inline void
+init_async_submit(struct async_submit_ctl *args, enum async_tx_flags flags,
+		  struct dma_async_tx_descriptor *tx,
+		  dma_async_tx_callback cb_fn, void *cb_param,
+		  addr_conv_t *scribble)
 {
-	if (cb_fn)
-		cb_fn(cb_fn_param);
+	args->flags = flags;
+	args->depend_tx = tx;
+	args->cb_fn = cb_fn;
+	args->cb_param = cb_param;
+	args->scribble = scribble;
 }
 
-void
-async_tx_submit(struct dma_chan *chan, struct dma_async_tx_descriptor *tx,
-	enum async_tx_flags flags, struct dma_async_tx_descriptor *depend_tx,
-	dma_async_tx_callback cb_fn, void *cb_fn_param);
+void async_tx_submit(struct dma_chan *chan, struct dma_async_tx_descriptor *tx,
+		     struct async_submit_ctl *submit);
 
 struct dma_async_tx_descriptor *
 async_xor(struct page *dest, struct page **src_list, unsigned int offset,
-	int src_cnt, size_t len, enum async_tx_flags flags,
-	struct dma_async_tx_descriptor *depend_tx,
-	dma_async_tx_callback cb_fn, void *cb_fn_param);
+	  int src_cnt, size_t len, struct async_submit_ctl *submit);
 
 struct dma_async_tx_descriptor *
-async_xor_val(struct page *dest, struct page **src_list,
-	unsigned int offset, int src_cnt, size_t len,
-	u32 *result, enum async_tx_flags flags,
-	struct dma_async_tx_descriptor *depend_tx,
-	dma_async_tx_callback cb_fn, void *cb_fn_param);
+async_xor_val(struct page *dest, struct page **src_list, unsigned int offset,
+	      int src_cnt, size_t len, u32 *result,
+	      struct async_submit_ctl *submit);
 
 struct dma_async_tx_descriptor *
 async_memcpy(struct page *dest, struct page *src, unsigned int dest_offset,
-	unsigned int src_offset, size_t len, enum async_tx_flags flags,
-	struct dma_async_tx_descriptor *depend_tx,
-	dma_async_tx_callback cb_fn, void *cb_fn_param);
+	     unsigned int src_offset, size_t len,
+	     struct async_submit_ctl *submit);
 
 struct dma_async_tx_descriptor *
 async_memset(struct page *dest, int val, unsigned int offset,
-	size_t len, enum async_tx_flags flags,
-	struct dma_async_tx_descriptor *depend_tx,
-	dma_async_tx_callback cb_fn, void *cb_fn_param);
+	     size_t len, struct async_submit_ctl *submit);
 
-struct dma_async_tx_descriptor *
-async_trigger_callback(enum async_tx_flags flags,
-	struct dma_async_tx_descriptor *depend_tx,
-	dma_async_tx_callback cb_fn, void *cb_fn_param);
+struct dma_async_tx_descriptor *async_trigger_callback(struct async_submit_ctl *submit);
 
 void async_tx_quiesce(struct dma_async_tx_descriptor **tx);
 #endif /* _ASYNC_TX_H_ */

