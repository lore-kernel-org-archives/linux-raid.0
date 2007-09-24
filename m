From: Dan Williams <dan.j.williams@intel.com>
Subject: [GIT PULL] async-tx/md-accel fixes and documentation for 2.6.23
Date: Mon, 24 Sep 2007 14:05:27 -0700
Message-ID: <1190667927.21384.25.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756657AbXIXVFl@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: NeilBrown <neilb@suse.de>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Linus, please pull from:

        git://lost.foo-projects.org/~dwillia2/git/iop async-tx-fixes-for-linus

to receive:

Dan Williams (3):
      async_tx: usage documentation and developer notes (v2)
      async_tx: fix dma_wait_for_async_tx
      raid5: fix 2 bugs in ops_complete_biofill

The raid5 change has been reviewed with Neil, and the documentation
received some fixups from Randy Dunlap and Shannon Nelson.

Documentation/crypto/async-tx-api.txt |  219 +++++++++++++++++++++++++++++++++
crypto/async_tx/async_tx.c            |   12 ++-
drivers/md/raid5.c                    |   17 +--
3 files changed, 236 insertions(+), 12 deletions(-)

---

diff --git a/Documentation/crypto/async-tx-api.txt b/Documentation/crypto/async-tx-api.txt
new file mode 100644
index 0000000..c1e9545
--- /dev/null
+++ b/Documentation/crypto/async-tx-api.txt
@@ -0,0 +1,219 @@
+		 Asynchronous Transfers/Transforms API
+
+1 INTRODUCTION
+
+2 GENEALOGY
+
+3 USAGE
+3.1 General format of the API
+3.2 Supported operations
+3.3 Descriptor management
+3.4 When does the operation execute?
+3.5 When does the operation complete?
+3.6 Constraints
+3.7 Example
+
+4 DRIVER DEVELOPER NOTES
+4.1 Conformance points
+4.2 "My application needs finer control of hardware channels"
+
+5 SOURCE
+
+---
+
+1 INTRODUCTION
+
+The async_tx API provides methods for describing a chain of asynchronous
+bulk memory transfers/transforms with support for inter-transactional
+dependencies.  It is implemented as a dmaengine client that smooths over
+the details of different hardware offload engine implementations.  Code
+that is written to the API can optimize for asynchronous operation and
+the API will fit the chain of operations to the available offload
+resources.
+
+2 GENEALOGY
+
+The API was initially designed to offload the memory copy and
+xor-parity-calculations of the md-raid5 driver using the offload engines
+present in the Intel(R) Xscale series of I/O processors.  It also built
+on the 'dmaengine' layer developed for offloading memory copies in the
+network stack using Intel(R) I/OAT engines.  The following design
+features surfaced as a result:
+1/ implicit synchronous path: users of the API do not need to know if
+   the platform they are running on has offload capabilities.  The
+   operation will be offloaded when an engine is available and carried out
+   in software otherwise.
+2/ cross channel dependency chains: the API allows a chain of dependent
+   operations to be submitted, like xor->copy->xor in the raid5 case.  The
+   API automatically handles cases where the transition from one operation
+   to another implies a hardware channel switch.
+3/ dmaengine extensions to support multiple clients and operation types
+   beyond 'memcpy'
+
+3 USAGE
+
+3.1 General format of the API:
+struct dma_async_tx_descriptor *
+async_<operation>(<op specific parameters>,
+		  enum async_tx_flags flags,
+        	  struct dma_async_tx_descriptor *dependency,
+        	  dma_async_tx_callback callback_routine,
+		  void *callback_parameter);
+
+3.2 Supported operations:
+memcpy       - memory copy between a source and a destination buffer
+memset       - fill a destination buffer with a byte value
+xor          - xor a series of source buffers and write the result to a
+	       destination buffer
+xor_zero_sum - xor a series of source buffers and set a flag if the
+	       result is zero.  The implementation attempts to prevent
+	       writes to memory
+
+3.3 Descriptor management:
+The return value is non-NULL and points to a 'descriptor' when the operation
+has been queued to execute asynchronously.  Descriptors are recycled
+resources, under control of the offload engine driver, to be reused as
+operations complete.  When an application needs to submit a chain of
+operations it must guarantee that the descriptor is not automatically recycled
+before the dependency is submitted.  This requires that all descriptors be
+acknowledged by the application before the offload engine driver is allowed to
+recycle (or free) the descriptor.  A descriptor can be acked by one of the
+following methods:
+1/ setting the ASYNC_TX_ACK flag if no child operations are to be submitted
+2/ setting the ASYNC_TX_DEP_ACK flag to acknowledge the parent
+   descriptor of a new operation.
+3/ calling async_tx_ack() on the descriptor.
+
+3.4 When does the operation execute?
+Operations do not immediately issue after return from the
+async_<operation> call.  Offload engine drivers batch operations to
+improve performance by reducing the number of mmio cycles needed to
+manage the channel.  Once a driver-specific threshold is met the driver
+automatically issues pending operations.  An application can force this
+event by calling async_tx_issue_pending_all().  This operates on all
+channels since the application has no knowledge of channel to operation
+mapping.
+
+3.5 When does the operation complete?
+There are two methods for an application to learn about the completion
+of an operation.
+1/ Call dma_wait_for_async_tx().  This call causes the CPU to spin while
+   it polls for the completion of the operation.  It handles dependency
+   chains and issuing pending operations.
+2/ Specify a completion callback.  The callback routine runs in tasklet
+   context if the offload engine driver supports interrupts, or it is
+   called in application context if the operation is carried out
+   synchronously in software.  The callback can be set in the call to
+   async_<operation>, or when the application needs to submit a chain of
+   unknown length it can use the async_trigger_callback() routine to set a
+   completion interrupt/callback at the end of the chain.
+
+3.6 Constraints:
+1/ Calls to async_<operation> are not permitted in IRQ context.  Other
+   contexts are permitted provided constraint #2 is not violated.
+2/ Completion callback routines cannot submit new operations.  This
+   results in recursion in the synchronous case and spin_locks being
+   acquired twice in the asynchronous case.
+
+3.7 Example:
+Perform a xor->copy->xor operation where each operation depends on the
+result from the previous operation:
+
+void complete_xor_copy_xor(void *param)
+{
+	printk("complete\n");
+}
+
+int run_xor_copy_xor(struct page **xor_srcs,
+		     int xor_src_cnt,
+		     struct page *xor_dest,
+		     size_t xor_len,
+		     struct page *copy_src,
+		     struct page *copy_dest,
+		     size_t copy_len)
+{
+	struct dma_async_tx_descriptor *tx;
+
+	tx = async_xor(xor_dest, xor_srcs, 0, xor_src_cnt, xor_len,
+		       ASYNC_TX_XOR_DROP_DST, NULL, NULL, NULL);
+	tx = async_memcpy(copy_dest, copy_src, 0, 0, copy_len,
+			  ASYNC_TX_DEP_ACK, tx, NULL, NULL);
+	tx = async_xor(xor_dest, xor_srcs, 0, xor_src_cnt, xor_len,
+		       ASYNC_TX_XOR_DROP_DST | ASYNC_TX_DEP_ACK | ASYNC_TX_ACK,
+		       tx, complete_xor_copy_xor, NULL);
+
+	async_tx_issue_pending_all();
+}
+
+See include/linux/async_tx.h for more information on the flags.  See the
+ops_run_* and ops_complete_* routines in drivers/md/raid5.c for more
+implementation examples.
+
+4 DRIVER DEVELOPMENT NOTES
+4.1 Conformance points:
+There are a few conformance points required in dmaengine drivers to
+accommodate assumptions made by applications using the async_tx API:
+1/ Completion callbacks are expected to happen in tasklet context
+2/ dma_async_tx_descriptor fields are never manipulated in IRQ context
+3/ Use async_tx_run_dependencies() in the descriptor clean up path to
+   handle submission of dependent operations
+
+4.2 "My application needs finer control of hardware channels"
+This requirement seems to arise from cases where a DMA engine driver is
+trying to support device-to-memory DMA.  The dmaengine and async_tx
+implementations were designed for offloading memory-to-memory
+operations; however, there are some capabilities of the dmaengine layer
+that can be used for platform-specific channel management.
+Platform-specific constraints can be handled by registering the
+application as a 'dma_client' and implementing a 'dma_event_callback' to
+apply a filter to the available channels in the system.  Before showing
+how to implement a custom dma_event callback some background of
+dmaengine's client support is required.
+
+The following routines in dmaengine support multiple clients requesting
+use of a channel:
+- dma_async_client_register(struct dma_client *client)
+- dma_async_client_chan_request(struct dma_client *client)
+
+dma_async_client_register takes a pointer to an initialized dma_client
+structure.  It expects that the 'event_callback' and 'cap_mask' fields
+are already initialized.
+
+dma_async_client_chan_request triggers dmaengine to notify the client of
+all channels that satisfy the capability mask.  It is up to the client's
+event_callback routine to track how many channels the client needs and
+how many it is currently using.  The dma_event_callback routine returns a
+dma_state_client code to let dmaengine know the status of the
+allocation.
+
+Below is the example of how to extend this functionality for
+platform-specific filtering of the available channels beyond the
+standard capability mask:
+
+static enum dma_state_client
+my_dma_client_callback(struct dma_client *client,
+			struct dma_chan *chan, enum dma_state state)
+{
+	struct dma_device *dma_dev;
+	struct my_platform_specific_dma *plat_dma_dev;
+	
+	dma_dev = chan->device;
+	plat_dma_dev = container_of(dma_dev,
+				    struct my_platform_specific_dma,
+				    dma_dev);
+
+	if (!plat_dma_dev->platform_specific_capability)
+		return DMA_DUP;
+
+	. . .
+}
+
+5 SOURCE
+include/linux/dmaengine.h: core header file for DMA drivers and clients
+drivers/dma/dmaengine.c: offload engine channel management routines
+drivers/dma/: location for offload engine drivers
+include/linux/async_tx.h: core header file for the async_tx api
+crypto/async_tx/async_tx.c: async_tx interface to dmaengine and common code
+crypto/async_tx/async_memcpy.c: copy offload
+crypto/async_tx/async_memset.c: memory fill offload
+crypto/async_tx/async_xor.c: xor and xor zero sum offload
diff --git a/crypto/async_tx/async_tx.c b/crypto/async_tx/async_tx.c
index 0350071..bc18cbb 100644
--- a/crypto/async_tx/async_tx.c
+++ b/crypto/async_tx/async_tx.c
@@ -80,6 +80,7 @@ dma_wait_for_async_tx(struct dma_async_tx_descriptor *tx)
 {
 	enum dma_status status;
 	struct dma_async_tx_descriptor *iter;
+	struct dma_async_tx_descriptor *parent;
 
 	if (!tx)
 		return DMA_SUCCESS;
@@ -87,8 +88,15 @@ dma_wait_for_async_tx(struct dma_async_tx_descriptor *tx)
 	/* poll through the dependency chain, return when tx is complete */
 	do {
 		iter = tx;
-		while (iter->cookie == -EBUSY)
-			iter = iter->parent;
+
+		/* find the root of the unsubmitted dependency chain */
+		while (iter->cookie == -EBUSY) {
+			parent = iter->parent;
+			if (parent && parent->cookie == -EBUSY)
+				iter = iter->parent;
+			else
+				break;
+		}
 
 		status = dma_sync_wait(iter->chan, iter->cookie);
 	} while (status == DMA_IN_PROGRESS || (iter != tx));
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 4d63773..f96dea9 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -514,7 +514,7 @@ static void ops_complete_biofill(void *stripe_head_ref)
 	struct stripe_head *sh = stripe_head_ref;
 	struct bio *return_bi = NULL;
 	raid5_conf_t *conf = sh->raid_conf;
-	int i, more_to_read = 0;
+	int i;
 
 	pr_debug("%s: stripe %llu\n", __FUNCTION__,
 		(unsigned long long)sh->sector);
@@ -522,16 +522,14 @@ static void ops_complete_biofill(void *stripe_head_ref)
 	/* clear completed biofills */
 	for (i = sh->disks; i--; ) {
 		struct r5dev *dev = &sh->dev[i];
-		/* check if this stripe has new incoming reads */
-		if (dev->toread)
-			more_to_read++;
 
 		/* acknowledge completion of a biofill operation */
-		/* and check if we need to reply to a read request
-		*/
-		if (test_bit(R5_Wantfill, &dev->flags) && !dev->toread) {
+		/* and check if we need to reply to a read request,
+		 * new R5_Wantfill requests are held off until
+		 * !test_bit(STRIPE_OP_BIOFILL, &sh->ops.pending)
+		 */
+		if (test_and_clear_bit(R5_Wantfill, &dev->flags)) {
 			struct bio *rbi, *rbi2;
-			clear_bit(R5_Wantfill, &dev->flags);
 
 			/* The access to dev->read is outside of the
 			 * spin_lock_irq(&conf->device_lock), but is protected
@@ -558,8 +556,7 @@ static void ops_complete_biofill(void *stripe_head_ref)
 
 	return_io(return_bi);
 
-	if (more_to_read)
-		set_bit(STRIPE_HANDLE, &sh->state);
+	set_bit(STRIPE_HANDLE, &sh->state);
 	release_stripe(sh);
 }
 
