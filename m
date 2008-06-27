From: NeilBrown <neilb@suse.de>
Subject: [PATCH 026 of 29] md: md: replace STRIPE_OP_{BIODRAIN,PREXOR,POSTXOR} with 'reconstruct_states'
Date: Fri, 27 Jun 2008 16:52:11 +1000
Message-ID: <1080627065211.10742@suse.de>
References: <20080627164503.9671.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-raid.ids


From: Dan Williams <dan.j.williams@intel.com>

Track the state of reconstruct operations (recalculating the parity block
usually due to incoming writes, or as part of array expansion)  Reduces the
scope of the STRIPE_OP_{BIODRAIN,PREXOR,POSTXOR} flags to only tracking whether
a reconstruct operation has been requested via the ops_request field of struct
stripe_head_state.

This is the final step in the removal of ops.{pending,ack,complete,count}, i.e.
the STRIPE_OP_{BIODRAIN,PREXOR,POSTXOR} flags only request an operation and do
not track the state of the operation.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid5.c         |  204 +++++++++++++------------------------------
 ./include/linux/raid/raid5.h |    9 -
 2 files changed, 63 insertions(+), 150 deletions(-)

diff .prev/drivers/md/raid5.c ./drivers/md/raid5.c
--- .prev/drivers/md/raid5.c	2008-06-27 16:42:34.000000000 +1000
+++ ./drivers/md/raid5.c	2008-06-27 16:42:36.000000000 +1000
@@ -122,6 +122,13 @@ static void return_io(struct bio *return
 
 static void print_raid5_conf (raid5_conf_t *conf);
 
+static int stripe_operations_active(struct stripe_head *sh)
+{
+	return sh->check_state || sh->reconstruct_state ||
+	       test_bit(STRIPE_BIOFILL_RUN, &sh->state) ||
+	       test_bit(STRIPE_COMPUTE_RUN, &sh->state);
+}
+
 static void __release_stripe(raid5_conf_t *conf, struct stripe_head *sh)
 {
 	if (atomic_dec_and_test(&sh->count)) {
@@ -141,7 +148,7 @@ static void __release_stripe(raid5_conf_
 			}
 			md_wakeup_thread(conf->mddev->thread);
 		} else {
-			BUG_ON(sh->ops.pending);
+			BUG_ON(stripe_operations_active(sh));
 			if (test_and_clear_bit(STRIPE_PREREAD_ACTIVE, &sh->state)) {
 				atomic_dec(&conf->preread_active_stripes);
 				if (atomic_read(&conf->preread_active_stripes) < IO_THRESHOLD)
@@ -243,7 +250,7 @@ static void init_stripe(struct stripe_he
 
 	BUG_ON(atomic_read(&sh->count) != 0);
 	BUG_ON(test_bit(STRIPE_HANDLE, &sh->state));
-	BUG_ON(sh->ops.pending || sh->ops.ack || sh->ops.complete);
+	BUG_ON(stripe_operations_active(sh));
 
 	CHECK_DEVLOCK();
 	pr_debug("init_stripe called, stripe %llu\n",
@@ -344,47 +351,6 @@ static struct stripe_head *get_active_st
 	return sh;
 }
 
-/* test_and_ack_op() ensures that we only dequeue an operation once */
-#define test_and_ack_op(op, pend) \
-do {							\
-	if (test_bit(op, &sh->ops.pending) &&		\
-		!test_bit(op, &sh->ops.complete)) {	\
-		if (test_and_set_bit(op, &sh->ops.ack)) \
-			clear_bit(op, &pend);		\
-		else					\
-			ack++;				\
-	} else						\
-		clear_bit(op, &pend);			\
-} while (0)
-
-/* find new work to run, do not resubmit work that is already
- * in flight
- */
-static unsigned long get_stripe_work(struct stripe_head *sh)
-{
-	unsigned long pending;
-	int ack = 0;
-
-	pending = sh->ops.pending;
-
-	test_and_ack_op(STRIPE_OP_BIOFILL, pending);
-	test_and_ack_op(STRIPE_OP_COMPUTE_BLK, pending);
-	test_and_ack_op(STRIPE_OP_PREXOR, pending);
-	test_and_ack_op(STRIPE_OP_BIODRAIN, pending);
-	test_and_ack_op(STRIPE_OP_POSTXOR, pending);
-	test_and_ack_op(STRIPE_OP_CHECK, pending);
-
-	sh->ops.count -= ack;
-	if (unlikely(sh->ops.count < 0)) {
-		printk(KERN_ERR "pending: %#lx ops.pending: %#lx ops.ack: %#lx "
-			"ops.complete: %#lx\n", pending, sh->ops.pending,
-			sh->ops.ack, sh->ops.complete);
-		BUG();
-	}
-
-	return pending;
-}
-
 static void
 raid5_end_read_request(struct bio *bi, int error);
 static void
@@ -609,7 +575,7 @@ static void ops_complete_compute5(void *
 }
 
 static struct dma_async_tx_descriptor *
-ops_run_compute5(struct stripe_head *sh, unsigned long pending)
+ops_run_compute5(struct stripe_head *sh, unsigned long ops_request)
 {
 	/* kernel stack size limits the total number of disks */
 	int disks = sh->disks;
@@ -640,7 +606,7 @@ ops_run_compute5(struct stripe_head *sh,
 			ops_complete_compute5, sh);
 
 	/* ack now if postxor is not set to be run */
-	if (tx && !test_bit(STRIPE_OP_POSTXOR, &pending))
+	if (tx && !test_bit(STRIPE_OP_POSTXOR, &ops_request))
 		async_tx_ack(tx);
 
 	return tx;
@@ -652,8 +618,6 @@ static void ops_complete_prexor(void *st
 
 	pr_debug("%s: stripe %llu\n", __func__,
 		(unsigned long long)sh->sector);
-
-	set_bit(STRIPE_OP_PREXOR, &sh->ops.complete);
 }
 
 static struct dma_async_tx_descriptor *
@@ -686,7 +650,7 @@ ops_run_prexor(struct stripe_head *sh, s
 
 static struct dma_async_tx_descriptor *
 ops_run_biodrain(struct stripe_head *sh, struct dma_async_tx_descriptor *tx,
-		 unsigned long pending)
+		 unsigned long ops_request)
 {
 	int disks = sh->disks;
 	int pd_idx = sh->pd_idx, i;
@@ -694,7 +658,7 @@ ops_run_biodrain(struct stripe_head *sh,
 	/* check if prexor is active which means only process blocks
 	 * that are part of a read-modify-write (Wantprexor)
 	 */
-	int prexor = test_bit(STRIPE_OP_PREXOR, &pending);
+	int prexor = test_bit(STRIPE_OP_PREXOR, &ops_request);
 
 	pr_debug("%s: stripe %llu\n", __func__,
 		(unsigned long long)sh->sector);
@@ -744,7 +708,7 @@ static void ops_complete_postxor(void *s
 	pr_debug("%s: stripe %llu\n", __func__,
 		(unsigned long long)sh->sector);
 
-	set_bit(STRIPE_OP_POSTXOR, &sh->ops.complete);
+	sh->reconstruct_state = reconstruct_state_result;
 	set_bit(STRIPE_HANDLE, &sh->state);
 	release_stripe(sh);
 }
@@ -763,16 +727,14 @@ static void ops_complete_write(void *str
 			set_bit(R5_UPTODATE, &dev->flags);
 	}
 
-	set_bit(STRIPE_OP_BIODRAIN, &sh->ops.complete);
-	set_bit(STRIPE_OP_POSTXOR, &sh->ops.complete);
-
+	sh->reconstruct_state = reconstruct_state_drain_result;
 	set_bit(STRIPE_HANDLE, &sh->state);
 	release_stripe(sh);
 }
 
 static void
 ops_run_postxor(struct stripe_head *sh, struct dma_async_tx_descriptor *tx,
-		unsigned long pending)
+		unsigned long ops_request)
 {
 	/* kernel stack size limits the total number of disks */
 	int disks = sh->disks;
@@ -780,7 +742,7 @@ ops_run_postxor(struct stripe_head *sh, 
 
 	int count = 0, pd_idx = sh->pd_idx, i;
 	struct page *xor_dest;
-	int prexor = test_bit(STRIPE_OP_PREXOR, &pending);
+	int prexor = test_bit(STRIPE_OP_PREXOR, &ops_request);
 	unsigned long flags;
 	dma_async_tx_callback callback;
 
@@ -807,7 +769,7 @@ ops_run_postxor(struct stripe_head *sh, 
 	}
 
 	/* check whether this postxor is part of a write */
-	callback = test_bit(STRIPE_OP_BIODRAIN, &pending) ?
+	callback = test_bit(STRIPE_OP_BIODRAIN, &ops_request) ?
 		ops_complete_write : ops_complete_postxor;
 
 	/* 1/ if we prexor'd then the dest is reused as a source
@@ -868,8 +830,7 @@ static void ops_run_check(struct stripe_
 		ops_complete_check, sh);
 }
 
-static void raid5_run_ops(struct stripe_head *sh, unsigned long pending,
-			  unsigned long ops_request)
+static void raid5_run_ops(struct stripe_head *sh, unsigned long ops_request)
 {
 	int overlap_clear = 0, i, disks = sh->disks;
 	struct dma_async_tx_descriptor *tx = NULL;
@@ -880,18 +841,18 @@ static void raid5_run_ops(struct stripe_
 	}
 
 	if (test_bit(STRIPE_OP_COMPUTE_BLK, &ops_request))
-		tx = ops_run_compute5(sh, pending);
+		tx = ops_run_compute5(sh, ops_request);
 
-	if (test_bit(STRIPE_OP_PREXOR, &pending))
+	if (test_bit(STRIPE_OP_PREXOR, &ops_request))
 		tx = ops_run_prexor(sh, tx);
 
-	if (test_bit(STRIPE_OP_BIODRAIN, &pending)) {
-		tx = ops_run_biodrain(sh, tx, pending);
+	if (test_bit(STRIPE_OP_BIODRAIN, &ops_request)) {
+		tx = ops_run_biodrain(sh, tx, ops_request);
 		overlap_clear++;
 	}
 
-	if (test_bit(STRIPE_OP_POSTXOR, &pending))
-		ops_run_postxor(sh, tx, pending);
+	if (test_bit(STRIPE_OP_POSTXOR, &ops_request))
+		ops_run_postxor(sh, tx, ops_request);
 
 	if (test_bit(STRIPE_OP_CHECK, &ops_request))
 		ops_run_check(sh);
@@ -1684,11 +1645,11 @@ static void compute_block_2(struct strip
 	}
 }
 
-static int
-handle_write_operations5(struct stripe_head *sh, int rcw, int expand)
+static void
+handle_write_operations5(struct stripe_head *sh, struct stripe_head_state *s,
+			 int rcw, int expand)
 {
 	int i, pd_idx = sh->pd_idx, disks = sh->disks;
-	int locked = 0;
 
 	if (rcw) {
 		/* if we are not expanding this is a proper write request, and
@@ -1696,12 +1657,12 @@ handle_write_operations5(struct stripe_h
 		 * stripe cache
 		 */
 		if (!expand) {
-			set_bit(STRIPE_OP_BIODRAIN, &sh->ops.pending);
-			sh->ops.count++;
-		}
+			sh->reconstruct_state = reconstruct_state_drain_run;
+			set_bit(STRIPE_OP_BIODRAIN, &s->ops_request);
+		} else
+			sh->reconstruct_state = reconstruct_state_run;
 
-		set_bit(STRIPE_OP_POSTXOR, &sh->ops.pending);
-		sh->ops.count++;
+		set_bit(STRIPE_OP_POSTXOR, &s->ops_request);
 
 		for (i = disks; i--; ) {
 			struct r5dev *dev = &sh->dev[i];
@@ -1710,21 +1671,20 @@ handle_write_operations5(struct stripe_h
 				set_bit(R5_LOCKED, &dev->flags);
 				if (!expand)
 					clear_bit(R5_UPTODATE, &dev->flags);
-				locked++;
+				s->locked++;
 			}
 		}
-		if (locked + 1 == disks)
+		if (s->locked + 1 == disks)
 			if (!test_and_set_bit(STRIPE_FULL_WRITE, &sh->state))
 				atomic_inc(&sh->raid_conf->pending_full_writes);
 	} else {
 		BUG_ON(!(test_bit(R5_UPTODATE, &sh->dev[pd_idx].flags) ||
 			test_bit(R5_Wantcompute, &sh->dev[pd_idx].flags)));
 
-		set_bit(STRIPE_OP_PREXOR, &sh->ops.pending);
-		set_bit(STRIPE_OP_BIODRAIN, &sh->ops.pending);
-		set_bit(STRIPE_OP_POSTXOR, &sh->ops.pending);
-
-		sh->ops.count += 3;
+		sh->reconstruct_state = reconstruct_state_drain_run;
+		set_bit(STRIPE_OP_PREXOR, &s->ops_request);
+		set_bit(STRIPE_OP_BIODRAIN, &s->ops_request);
+		set_bit(STRIPE_OP_POSTXOR, &s->ops_request);
 
 		for (i = disks; i--; ) {
 			struct r5dev *dev = &sh->dev[i];
@@ -1742,7 +1702,7 @@ handle_write_operations5(struct stripe_h
 				set_bit(R5_Wantprexor, &dev->flags);
 				set_bit(R5_LOCKED, &dev->flags);
 				clear_bit(R5_UPTODATE, &dev->flags);
-				locked++;
+				s->locked++;
 			}
 		}
 	}
@@ -1752,13 +1712,11 @@ handle_write_operations5(struct stripe_h
 	 */
 	set_bit(R5_LOCKED, &sh->dev[pd_idx].flags);
 	clear_bit(R5_UPTODATE, &sh->dev[pd_idx].flags);
-	locked++;
+	s->locked++;
 
-	pr_debug("%s: stripe %llu locked: %d pending: %lx\n",
+	pr_debug("%s: stripe %llu locked: %d ops_request: %lx\n",
 		__func__, (unsigned long long)sh->sector,
-		locked, sh->ops.pending);
-
-	return locked;
+		s->locked, s->ops_request);
 }
 
 /*
@@ -2005,8 +1963,7 @@ static void handle_issuing_new_read_requ
 	 * midst of changing due to a write
 	 */
 	if (!test_bit(STRIPE_COMPUTE_RUN, &sh->state) && !sh->check_state &&
-	    !test_bit(STRIPE_OP_PREXOR, &sh->ops.pending) &&
-	    !test_bit(STRIPE_OP_POSTXOR, &sh->ops.pending)) {
+	    !sh->reconstruct_state) {
 		for (i = disks; i--; )
 			if (__handle_issuing_new_read_requests5(
 				sh, s, i, disks) == 0)
@@ -2211,7 +2168,7 @@ static void handle_issuing_new_write_req
 	if ((s->req_compute || !test_bit(STRIPE_COMPUTE_RUN, &sh->state)) &&
 	    (s->locked == 0 && (rcw == 0 || rmw == 0) &&
 	    !test_bit(STRIPE_BIT_DELAY, &sh->state)))
-		s->locked += handle_write_operations5(sh, rcw == 0, 0);
+		handle_write_operations5(sh, s, rcw == 0, 0);
 }
 
 static void handle_issuing_new_write_requests6(raid5_conf_t *conf,
@@ -2581,15 +2538,14 @@ static void handle_stripe5(struct stripe
 	struct bio *return_bi = NULL;
 	struct stripe_head_state s;
 	struct r5dev *dev;
-	unsigned long pending = 0;
 	mdk_rdev_t *blocked_rdev = NULL;
 	int prexor;
 
 	memset(&s, 0, sizeof(s));
-	pr_debug("handling stripe %llu, state=%#lx cnt=%d, pd_idx=%d "
-		"ops=%lx:%lx:%lx\n", (unsigned long long)sh->sector, sh->state,
-		atomic_read(&sh->count), sh->pd_idx,
-		sh->ops.pending, sh->ops.ack, sh->ops.complete);
+	pr_debug("handling stripe %llu, state=%#lx cnt=%d, pd_idx=%d check:%d "
+		 "reconstruct:%d\n", (unsigned long long)sh->sector, sh->state,
+		 atomic_read(&sh->count), sh->pd_idx, sh->check_state,
+		 sh->reconstruct_state);
 
 	spin_lock(&sh->lock);
 	clear_bit(STRIPE_HANDLE, &sh->state);
@@ -2703,34 +2659,12 @@ static void handle_stripe5(struct stripe
 	/* Now we check to see if any write operations have recently
 	 * completed
 	 */
-
-	/* leave prexor set until postxor is done, allows us to distinguish
-	 * a rmw from a rcw during biodrain
-	 */
 	prexor = 0;
-	if (test_bit(STRIPE_OP_PREXOR, &sh->ops.complete) &&
-		test_bit(STRIPE_OP_POSTXOR, &sh->ops.complete)) {
-
-		prexor = 1;
-		clear_bit(STRIPE_OP_PREXOR, &sh->ops.complete);
-		clear_bit(STRIPE_OP_PREXOR, &sh->ops.ack);
-		clear_bit(STRIPE_OP_PREXOR, &sh->ops.pending);
-
+	if (sh->reconstruct_state == reconstruct_state_drain_result) {
+		sh->reconstruct_state = reconstruct_state_idle;
 		for (i = disks; i--; )
-			clear_bit(R5_Wantprexor, &sh->dev[i].flags);
-	}
-
-	/* if only POSTXOR is set then this is an 'expand' postxor */
-	if (test_bit(STRIPE_OP_BIODRAIN, &sh->ops.complete) &&
-		test_bit(STRIPE_OP_POSTXOR, &sh->ops.complete)) {
-
-		clear_bit(STRIPE_OP_BIODRAIN, &sh->ops.complete);
-		clear_bit(STRIPE_OP_BIODRAIN, &sh->ops.ack);
-		clear_bit(STRIPE_OP_BIODRAIN, &sh->ops.pending);
-
-		clear_bit(STRIPE_OP_POSTXOR, &sh->ops.complete);
-		clear_bit(STRIPE_OP_POSTXOR, &sh->ops.ack);
-		clear_bit(STRIPE_OP_POSTXOR, &sh->ops.pending);
+			prexor += test_and_clear_bit(R5_Wantprexor,
+						     &sh->dev[i].flags);
 
 		/* All the 'written' buffers and the parity block are ready to
 		 * be written back to disk
@@ -2763,8 +2697,7 @@ static void handle_stripe5(struct stripe
 	 * 2/ A 'check' operation is in flight, as it may clobber the parity
 	 *    block.
 	 */
-	if (s.to_write && !test_bit(STRIPE_OP_POSTXOR, &sh->ops.pending) &&
-	    !sh->check_state)
+	if (s.to_write && !sh->reconstruct_state && !sh->check_state)
 		handle_issuing_new_write_requests5(conf, sh, &s, disks);
 
 	/* maybe we need to check and possibly fix the parity for this stripe
@@ -2805,18 +2738,10 @@ static void handle_stripe5(struct stripe
 		}
 	}
 
-	/* Finish postxor operations initiated by the expansion
-	 * process
-	 */
-	if (test_bit(STRIPE_OP_POSTXOR, &sh->ops.complete) &&
-		!test_bit(STRIPE_OP_BIODRAIN, &sh->ops.pending)) {
-
+	/* Finish reconstruct operations initiated by the expansion process */
+	if (sh->reconstruct_state == reconstruct_state_result) {
+		sh->reconstruct_state = reconstruct_state_idle;
 		clear_bit(STRIPE_EXPANDING, &sh->state);
-
-		clear_bit(STRIPE_OP_POSTXOR, &sh->ops.pending);
-		clear_bit(STRIPE_OP_POSTXOR, &sh->ops.ack);
-		clear_bit(STRIPE_OP_POSTXOR, &sh->ops.complete);
-
 		for (i = conf->raid_disks; i--; )
 			set_bit(R5_Wantwrite, &sh->dev[i].flags);
 			set_bit(R5_LOCKED, &dev->flags);
@@ -2824,15 +2749,13 @@ static void handle_stripe5(struct stripe
 	}
 
 	if (s.expanded && test_bit(STRIPE_EXPANDING, &sh->state) &&
-		!test_bit(STRIPE_OP_POSTXOR, &sh->ops.pending)) {
+	    !sh->reconstruct_state) {
 		/* Need to write out all blocks after computing parity */
 		sh->disks = conf->raid_disks;
 		sh->pd_idx = stripe_to_pdidx(sh->sector, conf,
 			conf->raid_disks);
-		s.locked += handle_write_operations5(sh, 1, 1);
-	} else if (s.expanded &&
-		   s.locked == 0 &&
-		!test_bit(STRIPE_OP_POSTXOR, &sh->ops.pending)) {
+		handle_write_operations5(sh, &s, 1, 1);
+	} else if (s.expanded && !sh->reconstruct_state && s.locked == 0) {
 		clear_bit(STRIPE_EXPAND_READY, &sh->state);
 		atomic_dec(&conf->reshape_stripes);
 		wake_up(&conf->wait_for_overlap);
@@ -2843,9 +2766,6 @@ static void handle_stripe5(struct stripe
 	    !test_bit(STRIPE_COMPUTE_RUN, &sh->state))
 		handle_stripe_expansion(conf, sh, NULL);
 
-	if (sh->ops.count)
-		pending = get_stripe_work(sh);
-
  unlock:
 	spin_unlock(&sh->lock);
 
@@ -2853,8 +2773,8 @@ static void handle_stripe5(struct stripe
 	if (unlikely(blocked_rdev))
 		md_wait_for_blocked_rdev(blocked_rdev, conf->mddev);
 
-	if (pending || s.ops_request)
-		raid5_run_ops(sh, pending, s.ops_request);
+	if (s.ops_request)
+		raid5_run_ops(sh, s.ops_request);
 
 	ops_run_io(sh, &s);
 

diff .prev/include/linux/raid/raid5.h ./include/linux/raid/raid5.h
--- .prev/include/linux/raid/raid5.h	2008-06-27 16:42:34.000000000 +1000
+++ ./include/linux/raid/raid5.h	2008-06-27 16:42:36.000000000 +1000
@@ -205,19 +205,12 @@ struct stripe_head {
 	int			bm_seq;	/* sequence number for bitmap flushes */
 	int			disks;			/* disks in stripe */
 	enum check_states	check_state;
+	enum reconstruct_states reconstruct_state;
 	/* stripe_operations
-	 * @pending - pending ops flags (set for request->issue->complete)
-	 * @ack - submitted ops flags (set for issue->complete)
-	 * @complete - completed ops flags (set for complete)
 	 * @target - STRIPE_OP_COMPUTE_BLK target
-	 * @count - raid5_runs_ops is set to run when this is non-zero
 	 */
 	struct stripe_operations {
-		unsigned long	   pending;
-		unsigned long	   ack;
-		unsigned long	   complete;
 		int		   target;
-		int		   count;
 		u32		   zero_sum_result;
 	} ops;
 	struct r5dev {
