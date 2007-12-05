From: Yuri Tikhonov <yur@emcraft.com>
Subject: Re: async_tx: get best channel
Date: Wed, 5 Dec 2007 19:37:45 +0300
Message-ID: <200712051937.46266.yur@emcraft.com>
References: <200710191623.34381.yur@emcraft.com> <1193163398.14140.24.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1193163398.14140.24.camel@dwillia2-linux.ch.intel.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Dan Williams <dan.j.williams@gmail.com>, Neil Brown <neilb@suse.de>, Wolfgang Denk <wd@denx.de>, Detlev Zundel <dzu@denx.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


 Hello,

On Tuesday 23 October 2007 22:16, Dan Williams wrote:
> The problem with moving this test to async_tx_find_channel() is that it
> imposes extra overhead in the fast path.  It would be best if we could
> keep all these decisions in the slow path, or at least hide it from
> architectures that do not need to implement it.  The thing that makes
> this tricky is the fact that the speed is based on the source address...

 The following patch is an attempt to support the getting best channel
feature in ASYNC_TX. The architectures which do not need to implement
this keep the chan->device->device_estimate method set to NULL, and thus
avoid async_tx_find_best_channel() invocation.

 As far as the the architectures which may benefit from this feature are
concerned, it is given at the discretion of the architecture's ADMA driver
developer to assign the relative priority of each channel for a given
operation: the async_tx_find_best_channel() function looks through the list
of channels which support the 'cap' type of operation, and selects the one
which returns the biggest value from device_estimate() method. The parameters
passed to device_estimate() are as follows:
- type of operation;
- list of source operands (addresses);
- number of operands;
- size of data processed by the operation.

 Signed-off-by: Yuri Tikhonov <yur@emcraft.com>
 Signed-off-by: Mikhail Cherkashin <mike@emcraft.com>
--

diff --git a/crypto/async_tx/async_memcpy.c b/crypto/async_tx/async_memcpy.c
index a973f4e..2146857 100644
--- a/crypto/async_tx/async_memcpy.c
+++ b/crypto/async_tx/async_memcpy.c
@@ -47,7 +47,8 @@ async_memcpy(struct page *dest, struct page *src, unsigned int dest_offset,
 	struct dma_async_tx_descriptor *depend_tx,
 	dma_async_tx_callback cb_fn, void *cb_param)
 {
-	struct dma_chan *chan = async_tx_find_channel(depend_tx, DMA_MEMCPY);
+	struct dma_chan *chan = async_tx_find_channel(depend_tx, DMA_MEMCPY,
+		&src, 1, len);
 	struct dma_device *device = chan ? chan->device : NULL;
 	int int_en = cb_fn ? 1 : 0;
 	struct dma_async_tx_descriptor *tx = device ?
diff --git a/crypto/async_tx/async_memset.c b/crypto/async_tx/async_memset.c
index 66ef635..b427913 100644
--- a/crypto/async_tx/async_memset.c
+++ b/crypto/async_tx/async_memset.c
@@ -46,7 +46,8 @@ async_memset(struct page *dest, int val, unsigned int offset,
 	struct dma_async_tx_descriptor *depend_tx,
 	dma_async_tx_callback cb_fn, void *cb_param)
 {
-	struct dma_chan *chan = async_tx_find_channel(depend_tx, DMA_MEMSET);
+	struct dma_chan *chan = async_tx_find_channel(depend_tx, DMA_MEMSET,
+		NULL, 0, len);
 	struct dma_device *device = chan ? chan->device : NULL;
 	int int_en = cb_fn ? 1 : 0;
 	struct dma_async_tx_descriptor *tx = device ?
diff --git a/crypto/async_tx/async_tx.c b/crypto/async_tx/async_tx.c
index 6d77ae6..e889f76 100644
--- a/crypto/async_tx/async_tx.c
+++ b/crypto/async_tx/async_tx.c
@@ -363,26 +363,75 @@ static void __exit async_tx_exit(void)
 }
 
 /**
+ * async_tx_find_best_channel - find a channel with the maximum rank for the
+ * 	transaction type given (the rank of the operation is the value
+ *	returned by the device_estimate method).
+ * @cap: transaction type
+ * @src_lst: array of pointers to sources for the transaction
+ * @src_cnt: number of arguments (size of the srcs array)
+ * @src_sz: length of the each argument pointed by srcs
+ */
+static struct dma_chan *
+async_tx_find_best_channel (enum dma_transaction_type cap,
+	struct page **src_lst, int src_cnt, size_t src_sz)
+{
+	struct dma_chan *best_chan = NULL;
+	struct dma_chan_ref *ref;
+	int best_rank = -1;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(ref, &async_tx_master_list, node)
+		if (dma_has_cap(cap, ref->chan->device->cap_mask)) {
+			int rank;
+
+			BUG_ON (!ref->chan->device->device_estimate);
+			rank = ref->chan->device->device_estimate (ref->chan,
+				cap, src_lst, src_cnt, src_sz);
+			if (rank > best_rank) {
+				best_rank = rank;
+				best_chan = ref->chan;
+			}
+		}
+	rcu_read_unlock();
+
+	BUG_ON(best_rank == -1);
+	return best_chan;
+}
+
+/**
  * async_tx_find_channel - find a channel to carry out the operation or let
  *	the transaction execute synchronously
  * @depend_tx: transaction dependency
  * @tx_type: transaction type
+ * @src_lst: array of pointers to sources for the transaction
+ * @src_cnt: number of arguments (size of the srcs array)
+ * @src_sz: length of the each argument pointed by srcs
  */
 struct dma_chan *
 async_tx_find_channel(struct dma_async_tx_descriptor *depend_tx,
-	enum dma_transaction_type tx_type)
+	enum dma_transaction_type tx_type, struct page **src_lst,
+	int src_cnt, size_t src_sz)
 {
+	struct dma_chan_ref *ref = NULL;
+	int cpu;
+
+	cpu = get_cpu();
+	if (likely(channel_table_initialized))
+		ref = per_cpu_ptr(channel_table[tx_type], cpu)->ref;
+	put_cpu();
+
+	/* see if adma devices can estimate efficiency of ops processing */
+	if (!depend_tx && ref && ref->chan->device->device_estimate)
+		return async_tx_find_best_channel (tx_type,
+			src_lst, src_cnt, src_sz);
+
 	/* see if we can keep the chain on one channel */
 	if (depend_tx &&
 		dma_has_cap(tx_type, depend_tx->chan->device->cap_mask))
 		return depend_tx->chan;
-	else if (likely(channel_table_initialized)) {
-		struct dma_chan_ref *ref;
-		int cpu = get_cpu();
-		ref = per_cpu_ptr(channel_table[tx_type], cpu)->ref;
-		put_cpu();
-		return ref ? ref->chan : NULL;
-	} else
+	else if (likely(ref))
+		return ref->chan;
+	else
 		return NULL;
 }
 EXPORT_SYMBOL_GPL(async_tx_find_channel);
diff --git a/crypto/async_tx/async_xor.c b/crypto/async_tx/async_xor.c
index 2575f67..2cdcd21 100644
--- a/crypto/async_tx/async_xor.c
+++ b/crypto/async_tx/async_xor.c
@@ -113,7 +113,8 @@ async_xor(struct page *dest, struct page **src_list, unsigned int offset,
 	struct dma_async_tx_descriptor *depend_tx,
 	dma_async_tx_callback cb_fn, void *cb_param)
 {
-	struct dma_chan *chan = async_tx_find_channel(depend_tx, DMA_XOR);
+	struct dma_chan *chan = async_tx_find_channel(depend_tx, DMA_XOR,
+		src_list, src_cnt, len);
 	struct dma_device *device = chan ? chan->device : NULL;
 	struct dma_async_tx_descriptor *tx = NULL;
 	dma_async_tx_callback _cb_fn;
@@ -254,7 +255,8 @@ async_xor_zero_sum(struct page *dest, struct page **src_list,
 	struct dma_async_tx_descriptor *depend_tx,
 	dma_async_tx_callback cb_fn, void *cb_param)
 {
-	struct dma_chan *chan = async_tx_find_channel(depend_tx, DMA_ZERO_SUM);
+	struct dma_chan *chan = async_tx_find_channel(depend_tx, DMA_ZERO_SUM,
+		src_list, src_cnt, len);
 	struct dma_device *device = chan ? chan->device : NULL;
 	int int_en = cb_fn ? 1 : 0;
 	struct dma_async_tx_descriptor *tx = device ?
diff --git a/include/linux/async_tx.h b/include/linux/async_tx.h
index 4be0e25..7ada55b 100644
--- a/include/linux/async_tx.h
+++ b/include/linux/async_tx.h
@@ -76,7 +76,8 @@ enum dma_status dma_wait_for_async_tx(struct dma_async_tx_descriptor *tx);
 void async_tx_run_dependencies(struct dma_async_tx_descriptor *tx);
 struct dma_chan *
 async_tx_find_channel(struct dma_async_tx_descriptor *depend_tx,
-	enum dma_transaction_type tx_type);
+	enum dma_transaction_type tx_type,struct page **src_lst,
+	int src_cnt, size_t src_sz);
 #else
 static inline void async_tx_issue_pending_all(void)
 {
@@ -97,7 +98,8 @@ async_tx_run_dependencies(struct dma_async_tx_descriptor *tx)
 
 static inline struct dma_chan *
 async_tx_find_channel(struct dma_async_tx_descriptor *depend_tx,
-	enum dma_transaction_type tx_type)
+	enum dma_transaction_type tx_type, struct page **src_lst,
+	int src_cnt, size_t src_sz)
 {
 	return NULL;
 }
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 50d1ae3..3d0f8cf 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -264,6 +264,8 @@ struct dma_async_tx_descriptor {
  * @device_prep_dma_interrupt: prepares an end of chain interrupt operation
  * @device_dependency_added: async_tx notifies the channel about new deps
  * @device_issue_pending: push pending transactions to hardware
+ * @device_estimate: estimate the efficiency of processing the transaction
+ *	by this device
  */
 struct dma_device {
 
@@ -308,6 +310,9 @@ struct dma_device {
 			dma_cookie_t cookie, dma_cookie_t *last,
 			dma_cookie_t *used);
 	void (*device_issue_pending)(struct dma_chan *chan);
+	int (*device_estimate) (struct dma_chan *chan,
+			enum dma_transaction_type cap, struct page **src_lst,
+			int src_cnt, size_t src_sz);
 };
 
 /* --- public DMA engine API --- */

-- 
Yuri Tikhonov, Senior Software Engineer
Emcraft Systems, www.emcraft.com
