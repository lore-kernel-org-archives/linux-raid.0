From: NeilBrown <neilb@suse.de>
Subject: [PATCH 025 of 29] md: md: replace STRIPE_OP_COMPUTE_BLK with STRIPE_COMPUTE_RUN
Date: Fri, 27 Jun 2008 16:52:04 +1000
Message-ID: <1080627065204.10724@suse.de>
References: <20080627164503.9671.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-raid.ids


From: Dan Williams <dan.j.williams@intel.com>

Track the state of compute operations (recalculating a block from all the other
blocks in a stripe) with a state flag.  Reduces the scope of the
STRIPE_OP_COMPUTE_BLK flag to only tracking whether a compute operation has
been requested via the ops_request field of struct stripe_head_state.

Note, the compute operation that is performed in the course of doing a 'repair'
operation (check the parity block, recalculate it and write it back if the
check result is not zero) is tracked separately with the 'check_state'
variable.  Compute operations are held off while a 'check' is in progress, and
moving this check out to handle_issuing_new_read_requests5 the helper routine
__handle_issuing_new_read_requests5 can be simplified.

This is another step towards the removal of ops.{pending,ack,complete,count},
i.e. STRIPE_OP_COMPUTE_BLK only requests an operation and does not track the
state of the operation.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid5.c |   65 ++++++++++++++-------------------------------------
 1 file changed, 18 insertions(+), 47 deletions(-)

diff .prev/drivers/md/raid5.c ./drivers/md/raid5.c
--- .prev/drivers/md/raid5.c	2008-06-27 16:22:05.000000000 +1000
+++ ./drivers/md/raid5.c	2008-06-27 16:22:06.000000000 +1000
@@ -604,8 +604,6 @@ static void ops_complete_compute5(void *
 	clear_bit(STRIPE_COMPUTE_RUN, &sh->state);
 	if (sh->check_state == check_state_compute_run)
 		sh->check_state = check_state_compute_result;
-	else
-		set_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.complete);
 	set_bit(STRIPE_HANDLE, &sh->state);
 	release_stripe(sh);
 }
@@ -881,8 +879,7 @@ static void raid5_run_ops(struct stripe_
 		overlap_clear++;
 	}
 
-	if (test_bit(STRIPE_OP_COMPUTE_BLK, &pending) ||
-	    test_bit(STRIPE_OP_COMPUTE_BLK, &ops_request))
+	if (test_bit(STRIPE_OP_COMPUTE_BLK, &ops_request))
 		tx = ops_run_compute5(sh, pending);
 
 	if (test_bit(STRIPE_OP_PREXOR, &pending))
@@ -1960,12 +1957,6 @@ static int __handle_issuing_new_read_req
 	struct r5dev *dev = &sh->dev[disk_idx];
 	struct r5dev *failed_dev = &sh->dev[s->failed_num];
 
-	/* don't schedule compute operations or reads on the parity block while
-	 * a check is in flight
-	 */
-	if (disk_idx == sh->pd_idx && sh->check_state)
-		return ~0;
-
 	/* is the data in this block needed, and can we get it? */
 	if (!test_bit(R5_LOCKED, &dev->flags) &&
 	    !test_bit(R5_UPTODATE, &dev->flags) && (dev->toread ||
@@ -1974,23 +1965,16 @@ static int __handle_issuing_new_read_req
 	     (failed_dev->toread || (failed_dev->towrite &&
 	     !test_bit(R5_OVERWRITE, &failed_dev->flags)
 	     ))))) {
-		/* 1/ We would like to get this block, possibly by computing it,
-		 * but we might not be able to.
-		 *
-		 * 2/ Since parity check operations potentially make the parity
-		 * block !uptodate it will need to be refreshed before any
-		 * compute operations on data disks are scheduled.
-		 *
-		 * 3/ We hold off parity block re-reads until check operations
-		 * have quiesced.
+		/* We would like to get this block, possibly by computing it,
+		 * otherwise read it if the backing disk is insync
 		 */
-		if ((s->uptodate == disks - 1) && !sh->check_state &&
+		if ((s->uptodate == disks - 1) &&
 		    (s->failed && disk_idx == s->failed_num)) {
-			set_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.pending);
+			set_bit(STRIPE_COMPUTE_RUN, &sh->state);
+			set_bit(STRIPE_OP_COMPUTE_BLK, &s->ops_request);
 			set_bit(R5_Wantcompute, &dev->flags);
 			sh->ops.target = disk_idx;
 			s->req_compute = 1;
-			sh->ops.count++;
 			/* Careful: from this point on 'uptodate' is in the eye
 			 * of raid5_run_ops which services 'compute' operations
 			 * before writes. R5_Wantcompute flags a block that will
@@ -1999,12 +1983,7 @@ static int __handle_issuing_new_read_req
 			 */
 			s->uptodate++;
 			return 0; /* uptodate + compute == disks */
-		} else if ((s->uptodate < disks - 1) &&
-			test_bit(R5_Insync, &dev->flags)) {
-			/* Note: we hold off compute operations while checks are
-			 * in flight, but we still prefer 'compute' over 'read'
-			 * hence we only read if (uptodate < * disks-1)
-			 */
+		} else if (test_bit(R5_Insync, &dev->flags)) {
 			set_bit(R5_LOCKED, &dev->flags);
 			set_bit(R5_Wantread, &dev->flags);
 			s->locked++;
@@ -2021,20 +2000,13 @@ static void handle_issuing_new_read_requ
 {
 	int i;
 
-	/* Clear completed compute operations */
-	if (test_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.complete)) {
-		clear_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.complete);
-		clear_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.ack);
-		clear_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.pending);
-	}
-
 	/* look for blocks to read/compute, skip this if a compute
 	 * is already in flight, or if the stripe contents are in the
 	 * midst of changing due to a write
 	 */
-	if (!test_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.pending) &&
-		!test_bit(STRIPE_OP_PREXOR, &sh->ops.pending) &&
-		!test_bit(STRIPE_OP_POSTXOR, &sh->ops.pending)) {
+	if (!test_bit(STRIPE_COMPUTE_RUN, &sh->state) && !sh->check_state &&
+	    !test_bit(STRIPE_OP_PREXOR, &sh->ops.pending) &&
+	    !test_bit(STRIPE_OP_POSTXOR, &sh->ops.pending)) {
 		for (i = disks; i--; )
 			if (__handle_issuing_new_read_requests5(
 				sh, s, i, disks) == 0)
@@ -2236,10 +2208,9 @@ static void handle_issuing_new_write_req
 	 * simultaneously.  If this is not the case then new writes need to be
 	 * held off until the compute completes.
 	 */
-	if ((s->req_compute ||
-	    !test_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.pending)) &&
-		(s->locked == 0 && (rcw == 0 || rmw == 0) &&
-		!test_bit(STRIPE_BIT_DELAY, &sh->state)))
+	if ((s->req_compute || !test_bit(STRIPE_COMPUTE_RUN, &sh->state)) &&
+	    (s->locked == 0 && (rcw == 0 || rmw == 0) &&
+	    !test_bit(STRIPE_BIT_DELAY, &sh->state)))
 		s->locked += handle_write_operations5(sh, rcw == 0, 0);
 }
 
@@ -2410,6 +2381,7 @@ static void handle_parity_checks5(raid5_
 				set_bit(STRIPE_INSYNC, &sh->state);
 			else {
 				sh->check_state = check_state_compute_run;
+				set_bit(STRIPE_COMPUTE_RUN, &sh->state);
 				set_bit(STRIPE_OP_COMPUTE_BLK, &s->ops_request);
 				set_bit(R5_Wantcompute,
 					&sh->dev[sh->pd_idx].flags);
@@ -2725,8 +2697,7 @@ static void handle_stripe5(struct stripe
 	 * or to load a block that is being partially written.
 	 */
 	if (s.to_read || s.non_overwrite ||
-	    (s.syncing && (s.uptodate + s.compute < disks)) || s.expanding ||
-	    test_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.pending))
+	    (s.syncing && (s.uptodate + s.compute < disks)) || s.expanding)
 		handle_issuing_new_read_requests5(sh, &s, disks);
 
 	/* Now we check to see if any write operations have recently
@@ -2803,7 +2774,7 @@ static void handle_stripe5(struct stripe
 	 */
 	if (sh->check_state ||
 	    (s.syncing && s.locked == 0 &&
-	     !test_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.pending) &&
+	     !test_bit(STRIPE_COMPUTE_RUN, &sh->state) &&
 	     !test_bit(STRIPE_INSYNC, &sh->state)))
 		handle_parity_checks5(conf, sh, &s, disks);
 
@@ -2869,7 +2840,7 @@ static void handle_stripe5(struct stripe
 	}
 
 	if (s.expanding && s.locked == 0 &&
-	    !test_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.pending))
+	    !test_bit(STRIPE_COMPUTE_RUN, &sh->state))
 		handle_stripe_expansion(conf, sh, NULL);
 
 	if (sh->ops.count)
@@ -3089,7 +3060,7 @@ static void handle_stripe6(struct stripe
 	}
 
 	if (s.expanding && s.locked == 0 &&
-	    !test_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.pending))
+	    !test_bit(STRIPE_COMPUTE_RUN, &sh->state))
 		handle_stripe_expansion(conf, sh, &r6s);
 
  unlock:
