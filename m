From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v3 02/14] async_tx: kill ASYNC_TX_DEP_ACK flag
Date: Sat, 29 Aug 2009 19:30:11 -0700
Message-ID: <20090830023011.5934.34392.stgit@dwillia2-linux.ch.intel.com>
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

In support of inter-channel chaining async_tx utilizes an ack flag to
gate whether a dependent operation can be chained to another.  While the
flag is not set the chain can be considered open for appending.  Setting
the ack flag closes the chain and flags the descriptor for garbage
collection.  The ASYNC_TX_DEP_ACK flag essentially means "close the
chain after adding this dependency".  Since each operation can only have
one child the api now implicitly sets the ack flag at dependency
submission time.  This removes an unnecessary management burden from
clients of the api.

[ Impact: clean up and enforce one dependency per operation ]

Reviewed-by: Andre Noll <maan@systemlinux.org>
Acked-by: Maciej Sosnowski <maciej.sosnowski@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 Documentation/crypto/async-tx-api.txt |    9 ++++-----
 crypto/async_tx/async_memcpy.c        |    2 +-
 crypto/async_tx/async_memset.c        |    2 +-
 crypto/async_tx/async_tx.c            |    4 ++--
 crypto/async_tx/async_xor.c           |    6 ++----
 drivers/md/raid5.c                    |   25 +++++++++++--------------
 include/linux/async_tx.h              |    4 +---
 7 files changed, 22 insertions(+), 30 deletions(-)

diff --git a/Documentation/crypto/async-tx-api.txt b/Documentation/crypto/async-tx-api.txt
index 4af1218..76feda8 100644
--- a/Documentation/crypto/async-tx-api.txt
+++ b/Documentation/crypto/async-tx-api.txt
@@ -80,8 +80,8 @@ acknowledged by the application before the offload engine driver is allowed to
 recycle (or free) the descriptor.  A descriptor can be acked by one of the
 following methods:
 1/ setting the ASYNC_TX_ACK flag if no child operations are to be submitted
-2/ setting the ASYNC_TX_DEP_ACK flag to acknowledge the parent
-   descriptor of a new operation.
+2/ submitting an unacknowledged descriptor as a dependency to another
+   async_tx call will implicitly set the acknowledged state.
 3/ calling async_tx_ack() on the descriptor.
 
 3.4 When does the operation execute?
@@ -136,10 +136,9 @@ int run_xor_copy_xor(struct page **xor_srcs,
 
 	tx = async_xor(xor_dest, xor_srcs, 0, xor_src_cnt, xor_len,
 		       ASYNC_TX_XOR_DROP_DST, NULL, NULL, NULL);
-	tx = async_memcpy(copy_dest, copy_src, 0, 0, copy_len,
-			  ASYNC_TX_DEP_ACK, tx, NULL, NULL);
+	tx = async_memcpy(copy_dest, copy_src, 0, 0, copy_len, tx, NULL, NULL);
 	tx = async_xor(xor_dest, xor_srcs, 0, xor_src_cnt, xor_len,
-		       ASYNC_TX_XOR_DROP_DST | ASYNC_TX_DEP_ACK | ASYNC_TX_ACK,
+		       ASYNC_TX_XOR_DROP_DST | ASYNC_TX_ACK,
 		       tx, complete_xor_copy_xor, NULL);
 
 	async_tx_issue_pending_all();
diff --git a/crypto/async_tx/async_memcpy.c b/crypto/async_tx/async_memcpy.c
index ddccfb0..7117ec6 100644
--- a/crypto/async_tx/async_memcpy.c
+++ b/crypto/async_tx/async_memcpy.c
@@ -35,7 +35,7 @@
  * @src: src page
  * @offset: offset in pages to start transaction
  * @len: length in bytes
- * @flags: ASYNC_TX_ACK, ASYNC_TX_DEP_ACK,
+ * @flags: ASYNC_TX_ACK
  * @depend_tx: memcpy depends on the result of this transaction
  * @cb_fn: function to call when the memcpy completes
  * @cb_param: parameter to pass to the callback routine
diff --git a/crypto/async_tx/async_memset.c b/crypto/async_tx/async_memset.c
index 5b5eb99..b2f1338 100644
--- a/crypto/async_tx/async_memset.c
+++ b/crypto/async_tx/async_memset.c
@@ -35,7 +35,7 @@
  * @val: fill value
  * @offset: offset in pages to start transaction
  * @len: length in bytes
- * @flags: ASYNC_TX_ACK, ASYNC_TX_DEP_ACK
+ * @flags: ASYNC_TX_ACK
  * @depend_tx: memset depends on the result of this transaction
  * @cb_fn: function to call when the memcpy completes
  * @cb_param: parameter to pass to the callback routine
diff --git a/crypto/async_tx/async_tx.c b/crypto/async_tx/async_tx.c
index 06eb6cc..3766bc3 100644
--- a/crypto/async_tx/async_tx.c
+++ b/crypto/async_tx/async_tx.c
@@ -223,7 +223,7 @@ async_tx_submit(struct dma_chan *chan, struct dma_async_tx_descriptor *tx,
 	if (flags & ASYNC_TX_ACK)
 		async_tx_ack(tx);
 
-	if (depend_tx && (flags & ASYNC_TX_DEP_ACK))
+	if (depend_tx)
 		async_tx_ack(depend_tx);
 }
 EXPORT_SYMBOL_GPL(async_tx_submit);
@@ -231,7 +231,7 @@ EXPORT_SYMBOL_GPL(async_tx_submit);
 /**
  * async_trigger_callback - schedules the callback function to be run after
  * any dependent operations have been completed.
- * @flags: ASYNC_TX_ACK, ASYNC_TX_DEP_ACK
+ * @flags: ASYNC_TX_ACK
  * @depend_tx: 'callback' requires the completion of this transaction
  * @cb_fn: function to call after depend_tx completes
  * @cb_param: parameter to pass to the callback routine
diff --git a/crypto/async_tx/async_xor.c b/crypto/async_tx/async_xor.c
index e0580b0..3cc5dc7 100644
--- a/crypto/async_tx/async_xor.c
+++ b/crypto/async_tx/async_xor.c
@@ -105,7 +105,6 @@ do_async_xor(struct dma_chan *chan, struct page *dest, struct page **src_list,
 				_cb_param);
 
 		depend_tx = tx;
-		flags |= ASYNC_TX_DEP_ACK;
 
 		if (src_cnt > xor_src_cnt) {
 			/* drop completed sources */
@@ -168,8 +167,7 @@ do_sync_xor(struct page *dest, struct page **src_list, unsigned int offset,
  * @offset: offset in pages to start transaction
  * @src_cnt: number of source pages
  * @len: length in bytes
- * @flags: ASYNC_TX_XOR_ZERO_DST, ASYNC_TX_XOR_DROP_DEST,
- *	ASYNC_TX_ACK, ASYNC_TX_DEP_ACK
+ * @flags: ASYNC_TX_XOR_ZERO_DST, ASYNC_TX_XOR_DROP_DEST, ASYNC_TX_ACK
  * @depend_tx: xor depends on the result of this transaction.
  * @cb_fn: function to call when the xor completes
  * @cb_param: parameter to pass to the callback routine
@@ -230,7 +228,7 @@ static int page_is_zero(struct page *p, unsigned int offset, size_t len)
  * @src_cnt: number of source pages
  * @len: length in bytes
  * @result: 0 if sum == 0 else non-zero
- * @flags: ASYNC_TX_ACK, ASYNC_TX_DEP_ACK
+ * @flags: ASYNC_TX_ACK
  * @depend_tx: xor depends on the result of this transaction.
  * @cb_fn: function to call when the xor completes
  * @cb_param: parameter to pass to the callback routine
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index f8d2d35..0ef5362 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -525,14 +525,12 @@ async_copy_data(int frombio, struct bio *bio, struct page *page,
 			bio_page = bio_iovec_idx(bio, i)->bv_page;
 			if (frombio)
 				tx = async_memcpy(page, bio_page, page_offset,
-					b_offset, clen,
-					ASYNC_TX_DEP_ACK,
-					tx, NULL, NULL);
+						  b_offset, clen, 0,
+						  tx, NULL, NULL);
 			else
 				tx = async_memcpy(bio_page, page, b_offset,
-					page_offset, clen,
-					ASYNC_TX_DEP_ACK,
-					tx, NULL, NULL);
+						  page_offset, clen, 0,
+						  tx, NULL, NULL);
 		}
 		if (clen < len) /* hit end of page */
 			break;
@@ -615,8 +613,7 @@ static void ops_run_biofill(struct stripe_head *sh)
 	}
 
 	atomic_inc(&sh->count);
-	async_trigger_callback(ASYNC_TX_DEP_ACK | ASYNC_TX_ACK, tx,
-		ops_complete_biofill, sh);
+	async_trigger_callback(ASYNC_TX_ACK, tx, ops_complete_biofill, sh);
 }
 
 static void ops_complete_compute5(void *stripe_head_ref)
@@ -701,8 +698,8 @@ ops_run_prexor(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
 	}
 
 	tx = async_xor(xor_dest, xor_srcs, 0, count, STRIPE_SIZE,
-		ASYNC_TX_DEP_ACK | ASYNC_TX_XOR_DROP_DST, tx,
-		ops_complete_prexor, sh);
+		       ASYNC_TX_XOR_DROP_DST, tx,
+		       ops_complete_prexor, sh);
 
 	return tx;
 }
@@ -809,7 +806,7 @@ ops_run_postxor(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
 	 * set ASYNC_TX_XOR_DROP_DST and ASYNC_TX_XOR_ZERO_DST
 	 * for the synchronous xor case
 	 */
-	flags = ASYNC_TX_DEP_ACK | ASYNC_TX_ACK |
+	flags = ASYNC_TX_ACK |
 		(prexor ? ASYNC_TX_XOR_DROP_DST : ASYNC_TX_XOR_ZERO_DST);
 
 	atomic_inc(&sh->count);
@@ -858,7 +855,7 @@ static void ops_run_check(struct stripe_head *sh)
 		&sh->ops.zero_sum_result, 0, NULL, NULL, NULL);
 
 	atomic_inc(&sh->count);
-	tx = async_trigger_callback(ASYNC_TX_DEP_ACK | ASYNC_TX_ACK, tx,
+	tx = async_trigger_callback(ASYNC_TX_ACK, tx,
 		ops_complete_check, sh);
 }
 
@@ -2687,8 +2684,8 @@ static void handle_stripe_expansion(raid5_conf_t *conf, struct stripe_head *sh,
 
 			/* place all the copies on one channel */
 			tx = async_memcpy(sh2->dev[dd_idx].page,
-				sh->dev[i].page, 0, 0, STRIPE_SIZE,
-				ASYNC_TX_DEP_ACK, tx, NULL, NULL);
+					  sh->dev[i].page, 0, 0, STRIPE_SIZE,
+					  0, tx, NULL, NULL);
 
 			set_bit(R5_Expanded, &sh2->dev[dd_idx].flags);
 			set_bit(R5_UPTODATE, &sh2->dev[dd_idx].flags);
diff --git a/include/linux/async_tx.h b/include/linux/async_tx.h
index 513150d..9f14cd5 100644
--- a/include/linux/async_tx.h
+++ b/include/linux/async_tx.h
@@ -58,13 +58,11 @@ struct dma_chan_ref {
  * array.
  * @ASYNC_TX_ACK: immediately ack the descriptor, precludes setting up a
  * dependency chain
- * @ASYNC_TX_DEP_ACK: ack the dependency descriptor.  Useful for chaining.
  */
 enum async_tx_flags {
 	ASYNC_TX_XOR_ZERO_DST	 = (1 << 0),
 	ASYNC_TX_XOR_DROP_DST	 = (1 << 1),
-	ASYNC_TX_ACK		 = (1 << 3),
-	ASYNC_TX_DEP_ACK	 = (1 << 4),
+	ASYNC_TX_ACK		 = (1 << 2),
 };
 
 #ifdef CONFIG_DMA_ENGINE

