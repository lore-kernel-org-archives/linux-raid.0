From: NeilBrown <neilb@suse.de>
Subject: [PATCH 027 of 29] md: md: replace R5_WantPrexor with R5_WantDrain, add 'prexor' reconstruct_states
Date: Fri, 27 Jun 2008 16:52:18 +1000
Message-ID: <1080627065218.10761@suse.de>
References: <20080627164503.9671.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-raid.ids


From: Dan Williams <dan.j.williams@intel.com>

Currently ops_run_biodrain and other locations have extra logic to determine
which blocks are processed in the prexor and non-prexor cases.  This can be
eliminated if handle_write_operations5 flags the blocks to be processed in all
cases via R5_Wantdrain.  The presence of the prexor operation is tracked in
sh->reconstruct_state.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid5.c         |   89 ++++++++++++++-----------------------------
 ./include/linux/raid/raid5.h |    6 +-
 2 files changed, 32 insertions(+), 63 deletions(-)

diff .prev/drivers/md/raid5.c ./drivers/md/raid5.c
--- .prev/drivers/md/raid5.c	2008-06-27 16:42:36.000000000 +1000
+++ ./drivers/md/raid5.c	2008-06-27 16:42:56.000000000 +1000
@@ -637,7 +637,7 @@ ops_run_prexor(struct stripe_head *sh, s
 	for (i = disks; i--; ) {
 		struct r5dev *dev = &sh->dev[i];
 		/* Only process blocks that are known to be uptodate */
-		if (dev->towrite && test_bit(R5_Wantprexor, &dev->flags))
+		if (test_bit(R5_Wantdrain, &dev->flags))
 			xor_srcs[count++] = dev->page;
 	}
 
@@ -649,16 +649,10 @@ ops_run_prexor(struct stripe_head *sh, s
 }
 
 static struct dma_async_tx_descriptor *
-ops_run_biodrain(struct stripe_head *sh, struct dma_async_tx_descriptor *tx,
-		 unsigned long ops_request)
+ops_run_biodrain(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
 {
 	int disks = sh->disks;
-	int pd_idx = sh->pd_idx, i;
-
-	/* check if prexor is active which means only process blocks
-	 * that are part of a read-modify-write (Wantprexor)
-	 */
-	int prexor = test_bit(STRIPE_OP_PREXOR, &ops_request);
+	int i;
 
 	pr_debug("%s: stripe %llu\n", __func__,
 		(unsigned long long)sh->sector);
@@ -666,20 +660,8 @@ ops_run_biodrain(struct stripe_head *sh,
 	for (i = disks; i--; ) {
 		struct r5dev *dev = &sh->dev[i];
 		struct bio *chosen;
-		int towrite;
 
-		towrite = 0;
-		if (prexor) { /* rmw */
-			if (dev->towrite &&
-			    test_bit(R5_Wantprexor, &dev->flags))
-				towrite = 1;
-		} else { /* rcw */
-			if (i != pd_idx && dev->towrite &&
-				test_bit(R5_LOCKED, &dev->flags))
-				towrite = 1;
-		}
-
-		if (towrite) {
+		if (test_and_clear_bit(R5_Wantdrain, &dev->flags)) {
 			struct bio *wbi;
 
 			spin_lock(&sh->lock);
@@ -704,18 +686,6 @@ ops_run_biodrain(struct stripe_head *sh,
 static void ops_complete_postxor(void *stripe_head_ref)
 {
 	struct stripe_head *sh = stripe_head_ref;
-
-	pr_debug("%s: stripe %llu\n", __func__,
-		(unsigned long long)sh->sector);
-
-	sh->reconstruct_state = reconstruct_state_result;
-	set_bit(STRIPE_HANDLE, &sh->state);
-	release_stripe(sh);
-}
-
-static void ops_complete_write(void *stripe_head_ref)
-{
-	struct stripe_head *sh = stripe_head_ref;
 	int disks = sh->disks, i, pd_idx = sh->pd_idx;
 
 	pr_debug("%s: stripe %llu\n", __func__,
@@ -727,14 +697,21 @@ static void ops_complete_write(void *str
 			set_bit(R5_UPTODATE, &dev->flags);
 	}
 
-	sh->reconstruct_state = reconstruct_state_drain_result;
+	if (sh->reconstruct_state == reconstruct_state_drain_run)
+		sh->reconstruct_state = reconstruct_state_drain_result;
+	else if (sh->reconstruct_state == reconstruct_state_prexor_drain_run)
+		sh->reconstruct_state = reconstruct_state_prexor_drain_result;
+	else {
+		BUG_ON(sh->reconstruct_state != reconstruct_state_run);
+		sh->reconstruct_state = reconstruct_state_result;
+	}
+
 	set_bit(STRIPE_HANDLE, &sh->state);
 	release_stripe(sh);
 }
 
 static void
-ops_run_postxor(struct stripe_head *sh, struct dma_async_tx_descriptor *tx,
-		unsigned long ops_request)
+ops_run_postxor(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
 {
 	/* kernel stack size limits the total number of disks */
 	int disks = sh->disks;
@@ -742,9 +719,8 @@ ops_run_postxor(struct stripe_head *sh, 
 
 	int count = 0, pd_idx = sh->pd_idx, i;
 	struct page *xor_dest;
-	int prexor = test_bit(STRIPE_OP_PREXOR, &ops_request);
+	int prexor = 0;
 	unsigned long flags;
-	dma_async_tx_callback callback;
 
 	pr_debug("%s: stripe %llu\n", __func__,
 		(unsigned long long)sh->sector);
@@ -752,7 +728,8 @@ ops_run_postxor(struct stripe_head *sh, 
 	/* check if prexor is active which means only process blocks
 	 * that are part of a read-modify-write (written)
 	 */
-	if (prexor) {
+	if (sh->reconstruct_state == reconstruct_state_prexor_drain_run) {
+		prexor = 1;
 		xor_dest = xor_srcs[count++] = sh->dev[pd_idx].page;
 		for (i = disks; i--; ) {
 			struct r5dev *dev = &sh->dev[i];
@@ -768,10 +745,6 @@ ops_run_postxor(struct stripe_head *sh, 
 		}
 	}
 
-	/* check whether this postxor is part of a write */
-	callback = test_bit(STRIPE_OP_BIODRAIN, &ops_request) ?
-		ops_complete_write : ops_complete_postxor;
-
 	/* 1/ if we prexor'd then the dest is reused as a source
 	 * 2/ if we did not prexor then we are redoing the parity
 	 * set ASYNC_TX_XOR_DROP_DST and ASYNC_TX_XOR_ZERO_DST
@@ -785,10 +758,10 @@ ops_run_postxor(struct stripe_head *sh, 
 	if (unlikely(count == 1)) {
 		flags &= ~(ASYNC_TX_XOR_DROP_DST | ASYNC_TX_XOR_ZERO_DST);
 		tx = async_memcpy(xor_dest, xor_srcs[0], 0, 0, STRIPE_SIZE,
-			flags, tx, callback, sh);
+			flags, tx, ops_complete_postxor, sh);
 	} else
 		tx = async_xor(xor_dest, xor_srcs, 0, count, STRIPE_SIZE,
-			flags, tx, callback, sh);
+			flags, tx, ops_complete_postxor, sh);
 }
 
 static void ops_complete_check(void *stripe_head_ref)
@@ -847,12 +820,12 @@ static void raid5_run_ops(struct stripe_
 		tx = ops_run_prexor(sh, tx);
 
 	if (test_bit(STRIPE_OP_BIODRAIN, &ops_request)) {
-		tx = ops_run_biodrain(sh, tx, ops_request);
+		tx = ops_run_biodrain(sh, tx);
 		overlap_clear++;
 	}
 
 	if (test_bit(STRIPE_OP_POSTXOR, &ops_request))
-		ops_run_postxor(sh, tx, ops_request);
+		ops_run_postxor(sh, tx);
 
 	if (test_bit(STRIPE_OP_CHECK, &ops_request))
 		ops_run_check(sh);
@@ -1669,6 +1642,7 @@ handle_write_operations5(struct stripe_h
 
 			if (dev->towrite) {
 				set_bit(R5_LOCKED, &dev->flags);
+				set_bit(R5_Wantdrain, &dev->flags);
 				if (!expand)
 					clear_bit(R5_UPTODATE, &dev->flags);
 				s->locked++;
@@ -1681,7 +1655,7 @@ handle_write_operations5(struct stripe_h
 		BUG_ON(!(test_bit(R5_UPTODATE, &sh->dev[pd_idx].flags) ||
 			test_bit(R5_Wantcompute, &sh->dev[pd_idx].flags)));
 
-		sh->reconstruct_state = reconstruct_state_drain_run;
+		sh->reconstruct_state = reconstruct_state_prexor_drain_run;
 		set_bit(STRIPE_OP_PREXOR, &s->ops_request);
 		set_bit(STRIPE_OP_BIODRAIN, &s->ops_request);
 		set_bit(STRIPE_OP_POSTXOR, &s->ops_request);
@@ -1691,15 +1665,10 @@ handle_write_operations5(struct stripe_h
 			if (i == pd_idx)
 				continue;
 
-			/* For a read-modify write there may be blocks that are
-			 * locked for reading while others are ready to be
-			 * written so we distinguish these blocks by the
-			 * R5_Wantprexor bit
-			 */
 			if (dev->towrite &&
 			    (test_bit(R5_UPTODATE, &dev->flags) ||
-			    test_bit(R5_Wantcompute, &dev->flags))) {
-				set_bit(R5_Wantprexor, &dev->flags);
+			     test_bit(R5_Wantcompute, &dev->flags))) {
+				set_bit(R5_Wantdrain, &dev->flags);
 				set_bit(R5_LOCKED, &dev->flags);
 				clear_bit(R5_UPTODATE, &dev->flags);
 				s->locked++;
@@ -2660,11 +2629,11 @@ static void handle_stripe5(struct stripe
 	 * completed
 	 */
 	prexor = 0;
-	if (sh->reconstruct_state == reconstruct_state_drain_result) {
+	if (sh->reconstruct_state == reconstruct_state_prexor_drain_result)
+		prexor = 1;
+	if (sh->reconstruct_state == reconstruct_state_drain_result ||
+	    sh->reconstruct_state == reconstruct_state_prexor_drain_result) {
 		sh->reconstruct_state = reconstruct_state_idle;
-		for (i = disks; i--; )
-			prexor += test_and_clear_bit(R5_Wantprexor,
-						     &sh->dev[i].flags);
 
 		/* All the 'written' buffers and the parity block are ready to
 		 * be written back to disk

diff .prev/include/linux/raid/raid5.h ./include/linux/raid/raid5.h
--- .prev/include/linux/raid/raid5.h	2008-06-27 16:42:36.000000000 +1000
+++ ./include/linux/raid/raid5.h	2008-06-27 16:42:56.000000000 +1000
@@ -187,8 +187,10 @@ enum check_states {
  */
 enum reconstruct_states {
 	reconstruct_state_idle = 0,
+	reconstruct_state_prexor_drain_run,	/* prexor-write */
 	reconstruct_state_drain_run,		/* write */
 	reconstruct_state_run,			/* expand */
+	reconstruct_state_prexor_drain_result,
 	reconstruct_state_drain_result,
 	reconstruct_state_result,
 };
@@ -258,9 +260,7 @@ struct r6_state {
 #define	R5_Wantfill	12 /* dev->toread contains a bio that needs
 				    * filling
 				    */
-#define	R5_Wantprexor	13 /* distinguish blocks ready for rmw from
-				    * other "towrites"
-				    */
+#define R5_Wantdrain	13 /* dev->towrite needs to be drained */
 /*
  * Write method
  */
