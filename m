From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v3 04/14] async_xor: permit callers to pass in a 'dma/page
	scribble' region
Date: Sat, 29 Aug 2009 19:30:21 -0700
Message-ID: <20090830023021.5934.54848.stgit@dwillia2-linux.ch.intel.com>
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

async_xor() needs space to perform dma and page address conversions.  In
most cases the code can simply reuse the struct page * array because the
size of the native pointer matches the size of a dma/page address.  In
order to support archs where sizeof(dma_addr_t) is larger than
sizeof(struct page *), or to preserve the input parameters, we utilize a
memory region passed in by the caller.

Since the code is now prepared to handle the case where it cannot
perform address conversions on the stack, we no longer need the
!HIGHMEM64G dependency in drivers/dma/Kconfig.

[ Impact: don't clobber input buffers for address conversions ]

Reviewed-by: Andre Noll <maan@systemlinux.org>
Acked-by: Maciej Sosnowski <maciej.sosnowski@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 Documentation/crypto/async-tx-api.txt |   43 +++++++++++++++---------
 crypto/async_tx/async_xor.c           |   60 ++++++++++++++++-----------------
 drivers/dma/Kconfig                   |    2 +
 3 files changed, 58 insertions(+), 47 deletions(-)

diff --git a/Documentation/crypto/async-tx-api.txt b/Documentation/crypto/async-tx-api.txt
index dfe0475..6b15e48 100644
--- a/Documentation/crypto/async-tx-api.txt
+++ b/Documentation/crypto/async-tx-api.txt
@@ -115,29 +115,42 @@ of an operation.
 Perform a xor->copy->xor operation where each operation depends on the
 result from the previous operation:
 
-void complete_xor_copy_xor(void *param)
+void callback(void *param)
 {
-	printk("complete\n");
+	struct completion *cmp = param;
+
+	complete(cmp);
 }
 
-int run_xor_copy_xor(struct page **xor_srcs,
-		     int xor_src_cnt,
-		     struct page *xor_dest,
-		     size_t xor_len,
-		     struct page *copy_src,
-		     struct page *copy_dest,
-		     size_t copy_len)
+void run_xor_copy_xor(struct page **xor_srcs,
+		      int xor_src_cnt,
+		      struct page *xor_dest,
+		      size_t xor_len,
+		      struct page *copy_src,
+		      struct page *copy_dest,
+		      size_t copy_len)
 {
 	struct dma_async_tx_descriptor *tx;
+	addr_conv_t addr_conv[xor_src_cnt];
+	struct async_submit_ctl submit;
+	addr_conv_t addr_conv[NDISKS];
+	struct completion cmp;
+
+	init_async_submit(&submit, ASYNC_TX_XOR_DROP_DST, NULL, NULL, NULL,
+			  addr_conv);
+	tx = async_xor(xor_dest, xor_srcs, 0, xor_src_cnt, xor_len, &submit)
 
-	tx = async_xor(xor_dest, xor_srcs, 0, xor_src_cnt, xor_len,
-		       ASYNC_TX_XOR_DROP_DST, NULL, NULL, NULL);
-	tx = async_memcpy(copy_dest, copy_src, 0, 0, copy_len, tx, NULL, NULL);
-	tx = async_xor(xor_dest, xor_srcs, 0, xor_src_cnt, xor_len,
-		       ASYNC_TX_XOR_DROP_DST | ASYNC_TX_ACK,
-		       tx, complete_xor_copy_xor, NULL);
+	submit->depend_tx = tx;
+	tx = async_memcpy(copy_dest, copy_src, 0, 0, copy_len, &submit);
+
+	init_completion(&cmp);
+	init_async_submit(&submit, ASYNC_TX_XOR_DROP_DST | ASYNC_TX_ACK, tx,
+			  callback, &cmp, addr_conv);
+	tx = async_xor(xor_dest, xor_srcs, 0, xor_src_cnt, xor_len, &submit);
 
 	async_tx_issue_pending_all();
+
+	wait_for_completion(&cmp);
 }
 
 See include/linux/async_tx.h for more information on the flags.  See the
diff --git a/crypto/async_tx/async_xor.c b/crypto/async_tx/async_xor.c
index 691fa98..1e96c4d 100644
--- a/crypto/async_tx/async_xor.c
+++ b/crypto/async_tx/async_xor.c
@@ -33,11 +33,10 @@
 /* do_async_xor - dma map the pages and perform the xor with an engine */
 static __async_inline struct dma_async_tx_descriptor *
 do_async_xor(struct dma_chan *chan, struct page *dest, struct page **src_list,
-	     unsigned int offset, int src_cnt, size_t len,
+	     unsigned int offset, int src_cnt, size_t len, dma_addr_t *dma_src,
 	     struct async_submit_ctl *submit)
 {
 	struct dma_device *dma = chan->device;
-	dma_addr_t *dma_src = (dma_addr_t *) src_list;
 	struct dma_async_tx_descriptor *tx = NULL;
 	int src_off = 0;
 	int i;
@@ -125,9 +124,14 @@ do_sync_xor(struct page *dest, struct page **src_list, unsigned int offset,
 	int xor_src_cnt;
 	int src_off = 0;
 	void *dest_buf;
-	void **srcs = (void **) src_list;
+	void **srcs;
 
-	/* reuse the 'src_list' array to convert to buffer pointers */
+	if (submit->scribble)
+		srcs = submit->scribble;
+	else
+		srcs = (void **) src_list;
+
+	/* convert to buffer pointers */
 	for (i = 0; i < src_cnt; i++)
 		srcs[i] = page_address(src_list[i]) + offset;
 
@@ -178,17 +182,26 @@ async_xor(struct page *dest, struct page **src_list, unsigned int offset,
 	struct dma_chan *chan = async_tx_find_channel(submit, DMA_XOR,
 						      &dest, 1, src_list,
 						      src_cnt, len);
+	dma_addr_t *dma_src = NULL;
+
 	BUG_ON(src_cnt <= 1);
 
-	if (chan) {
+	if (submit->scribble)
+		dma_src = submit->scribble;
+	else if (sizeof(dma_addr_t) <= sizeof(struct page *))
+		dma_src = (dma_addr_t *) src_list;
+
+	if (dma_src && chan) {
 		/* run the xor asynchronously */
 		pr_debug("%s (async): len: %zu\n", __func__, len);
 
 		return do_async_xor(chan, dest, src_list, offset, src_cnt, len,
-				    submit);
+				    dma_src, submit);
 	} else {
 		/* run the xor synchronously */
 		pr_debug("%s (sync): len: %zu\n", __func__, len);
+		WARN_ONCE(chan, "%s: no space for dma address conversion\n",
+			  __func__);
 
 		/* in the sync case the dest is an implied source
 		 * (assumes the dest is the first source)
@@ -241,11 +254,16 @@ async_xor_val(struct page *dest, struct page **src_list, unsigned int offset,
 						      src_cnt, len);
 	struct dma_device *device = chan ? chan->device : NULL;
 	struct dma_async_tx_descriptor *tx = NULL;
+	dma_addr_t *dma_src = NULL;
 
 	BUG_ON(src_cnt <= 1);
 
-	if (device && src_cnt <= device->max_xor) {
-		dma_addr_t *dma_src = (dma_addr_t *) src_list;
+	if (submit->scribble)
+		dma_src = submit->scribble;
+	else if (sizeof(dma_addr_t) <= sizeof(struct page *))
+		dma_src = (dma_addr_t *) src_list;
+
+	if (dma_src && device && src_cnt <= device->max_xor) {
 		unsigned long dma_prep_flags;
 		int i;
 
@@ -275,6 +293,9 @@ async_xor_val(struct page *dest, struct page **src_list, unsigned int offset,
 		enum async_tx_flags flags_orig = submit->flags;
 
 		pr_debug("%s: (sync) len: %zu\n", __func__, len);
+		WARN_ONCE(device && src_cnt <= device->max_xor,
+			  "%s: no space for dma address conversion\n",
+			  __func__);
 
 		submit->flags |= ASYNC_TX_XOR_DROP_DST;
 		submit->flags &= ~ASYNC_TX_ACK;
@@ -293,29 +314,6 @@ async_xor_val(struct page *dest, struct page **src_list, unsigned int offset,
 }
 EXPORT_SYMBOL_GPL(async_xor_val);
 
-static int __init async_xor_init(void)
-{
-	#ifdef CONFIG_DMA_ENGINE
-	/* To conserve stack space the input src_list (array of page pointers)
-	 * is reused to hold the array of dma addresses passed to the driver.
-	 * This conversion is only possible when dma_addr_t is less than the
-	 * the size of a pointer.  HIGHMEM64G is known to violate this
-	 * assumption.
-	 */
-	BUILD_BUG_ON(sizeof(dma_addr_t) > sizeof(struct page *));
-	#endif
-
-	return 0;
-}
-
-static void __exit async_xor_exit(void)
-{
-	do { } while (0);
-}
-
-module_init(async_xor_init);
-module_exit(async_xor_exit);
-
 MODULE_AUTHOR("Intel Corporation");
 MODULE_DESCRIPTION("asynchronous xor/xor-zero-sum api");
 MODULE_LICENSE("GPL");
diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index 3b3c01b..912a51b 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -4,7 +4,7 @@
 
 menuconfig DMADEVICES
 	bool "DMA Engine support"
-	depends on !HIGHMEM64G && HAS_DMA
+	depends on HAS_DMA
 	help
 	  DMA engines can do asynchronous data transfers without
 	  involving the host CPU.  Currently, this framework can be

