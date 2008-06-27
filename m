From: NeilBrown <neilb@suse.de>
Subject: [PATCH 023 of 29] md: md: replace STRIPE_OP_CHECK with 'check_states'
Date: Fri, 27 Jun 2008 16:51:50 +1000
Message-ID: <1080627065150.10689@suse.de>
References: <20080627164503.9671.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-raid.ids


From: Dan Williams <dan.j.williams@intel.com>

The STRIPE_OP_* flags record the state of stripe operations which are
performed outside the stripe lock.  Their use in indicating which
operations need to be run is straightforward; however, interpolating what
the next state of the stripe should be based on a given combination of
these flags is not straightforward, and has led to bugs.  An easier to read
implementation with minimal degrees of freedom is needed.

Towards this goal, this patch introduces explicit states to replace what was
previously interpolated from the STRIPE_OP_* flags.  For now this only converts
the handle_parity_checks5 path, removing a user of the
ops.{pending,ack,complete,count} fields of struct stripe_operations.

This conversion also found a remaining issue with the current code.  There is
a small window for a drive to fail between when we schedule a repair and when
the parity calculation for that repair completes.  When this happens we will
writeback to 'failed_num' when we really want to write back to 'pd_idx'.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid5.c         |  170 ++++++++++++++++++++-----------------------
 ./include/linux/raid/raid5.h |   46 ++++++++++-
 2 files changed, 122 insertions(+), 94 deletions(-)

diff .prev/drivers/md/raid5.c ./drivers/md/raid5.c
--- .prev/drivers/md/raid5.c	2008-06-27 16:22:05.000000000 +1000
+++ ./drivers/md/raid5.c	2008-06-27 16:22:05.000000000 +1000
@@ -605,7 +605,11 @@ static void ops_complete_compute5(void *
 	set_bit(R5_UPTODATE, &tgt->flags);
 	BUG_ON(!test_bit(R5_Wantcompute, &tgt->flags));
 	clear_bit(R5_Wantcompute, &tgt->flags);
-	set_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.complete);
+	clear_bit(STRIPE_COMPUTE_RUN, &sh->state);
+	if (sh->check_state == check_state_compute_run)
+		sh->check_state = check_state_compute_result;
+	else
+		set_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.complete);
 	set_bit(STRIPE_HANDLE, &sh->state);
 	release_stripe(sh);
 }
@@ -838,7 +842,7 @@ static void ops_complete_check(void *str
 	pr_debug("%s: stripe %llu\n", __func__,
 		(unsigned long long)sh->sector);
 
-	set_bit(STRIPE_OP_CHECK, &sh->ops.complete);
+	sh->check_state = check_state_check_result;
 	set_bit(STRIPE_HANDLE, &sh->state);
 	release_stripe(sh);
 }
@@ -870,7 +874,8 @@ static void ops_run_check(struct stripe_
 		ops_complete_check, sh);
 }
 
-static void raid5_run_ops(struct stripe_head *sh, unsigned long pending)
+static void raid5_run_ops(struct stripe_head *sh, unsigned long pending,
+			  unsigned long ops_request)
 {
 	int overlap_clear = 0, i, disks = sh->disks;
 	struct dma_async_tx_descriptor *tx = NULL;
@@ -880,7 +885,8 @@ static void raid5_run_ops(struct stripe_
 		overlap_clear++;
 	}
 
-	if (test_bit(STRIPE_OP_COMPUTE_BLK, &pending))
+	if (test_bit(STRIPE_OP_COMPUTE_BLK, &pending) ||
+	    test_bit(STRIPE_OP_COMPUTE_BLK, &ops_request))
 		tx = ops_run_compute5(sh, pending);
 
 	if (test_bit(STRIPE_OP_PREXOR, &pending))
@@ -894,7 +900,7 @@ static void raid5_run_ops(struct stripe_
 	if (test_bit(STRIPE_OP_POSTXOR, &pending))
 		ops_run_postxor(sh, tx, pending);
 
-	if (test_bit(STRIPE_OP_CHECK, &pending))
+	if (test_bit(STRIPE_OP_CHECK, &ops_request))
 		ops_run_check(sh);
 
 	if (overlap_clear)
@@ -1961,8 +1967,7 @@ static int __handle_issuing_new_read_req
 	/* don't schedule compute operations or reads on the parity block while
 	 * a check is in flight
 	 */
-	if ((disk_idx == sh->pd_idx) &&
-	     test_bit(STRIPE_OP_CHECK, &sh->ops.pending))
+	if (disk_idx == sh->pd_idx && sh->check_state)
 		return ~0;
 
 	/* is the data in this block needed, and can we get it? */
@@ -1983,9 +1988,8 @@ static int __handle_issuing_new_read_req
 		 * 3/ We hold off parity block re-reads until check operations
 		 * have quiesced.
 		 */
-		if ((s->uptodate == disks - 1) &&
-		    (s->failed && disk_idx == s->failed_num) &&
-		    !test_bit(STRIPE_OP_CHECK, &sh->ops.pending)) {
+		if ((s->uptodate == disks - 1) && !sh->check_state &&
+		    (s->failed && disk_idx == s->failed_num)) {
 			set_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.pending);
 			set_bit(R5_Wantcompute, &dev->flags);
 			sh->ops.target = disk_idx;
@@ -2021,12 +2025,8 @@ static void handle_issuing_new_read_requ
 {
 	int i;
 
-	/* Clear completed compute operations.  Parity recovery
-	 * (STRIPE_OP_MOD_REPAIR_PD) implies a write-back which is handled
-	 * later on in this routine
-	 */
-	if (test_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.complete) &&
-		!test_bit(STRIPE_OP_MOD_REPAIR_PD, &sh->ops.pending)) {
+	/* Clear completed compute operations */
+	if (test_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.complete)) {
 		clear_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.complete);
 		clear_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.ack);
 		clear_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.pending);
@@ -2350,90 +2350,85 @@ static void handle_issuing_new_write_req
 static void handle_parity_checks5(raid5_conf_t *conf, struct stripe_head *sh,
 				struct stripe_head_state *s, int disks)
 {
-	int canceled_check = 0;
+	struct r5dev *dev = NULL;
 
 	set_bit(STRIPE_HANDLE, &sh->state);
 
-	/* complete a check operation */
-	if (test_and_clear_bit(STRIPE_OP_CHECK, &sh->ops.complete)) {
-		clear_bit(STRIPE_OP_CHECK, &sh->ops.ack);
-		clear_bit(STRIPE_OP_CHECK, &sh->ops.pending);
+	switch (sh->check_state) {
+	case check_state_idle:
+		/* start a new check operation if there are no failures */
 		if (s->failed == 0) {
-			if (sh->ops.zero_sum_result == 0)
-				/* parity is correct (on disc,
-				 * not in buffer any more)
-				 */
-				set_bit(STRIPE_INSYNC, &sh->state);
-			else {
-				conf->mddev->resync_mismatches +=
-					STRIPE_SECTORS;
-				if (test_bit(
-				     MD_RECOVERY_CHECK, &conf->mddev->recovery))
-					/* don't try to repair!! */
-					set_bit(STRIPE_INSYNC, &sh->state);
-				else {
-					set_bit(STRIPE_OP_COMPUTE_BLK,
-						&sh->ops.pending);
-					set_bit(STRIPE_OP_MOD_REPAIR_PD,
-						&sh->ops.pending);
-					set_bit(R5_Wantcompute,
-						&sh->dev[sh->pd_idx].flags);
-					sh->ops.target = sh->pd_idx;
-					sh->ops.count++;
-					s->uptodate++;
-				}
-			}
-		} else
-			canceled_check = 1; /* STRIPE_INSYNC is not set */
-	}
-
-	/* start a new check operation if there are no failures, the stripe is
-	 * not insync, and a repair is not in flight
-	 */
-	if (s->failed == 0 &&
-	    !test_bit(STRIPE_INSYNC, &sh->state) &&
-	    !test_bit(STRIPE_OP_MOD_REPAIR_PD, &sh->ops.pending)) {
-		if (!test_and_set_bit(STRIPE_OP_CHECK, &sh->ops.pending)) {
 			BUG_ON(s->uptodate != disks);
+			sh->check_state = check_state_run;
+			set_bit(STRIPE_OP_CHECK, &s->ops_request);
 			clear_bit(R5_UPTODATE, &sh->dev[sh->pd_idx].flags);
-			sh->ops.count++;
 			s->uptodate--;
+			break;
 		}
-	}
-
-	/* check if we can clear a parity disk reconstruct */
-	if (test_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.complete) &&
-	    test_bit(STRIPE_OP_MOD_REPAIR_PD, &sh->ops.pending)) {
-
-		clear_bit(STRIPE_OP_MOD_REPAIR_PD, &sh->ops.pending);
-		clear_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.complete);
-		clear_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.ack);
-		clear_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.pending);
-	}
+		dev = &sh->dev[s->failed_num];
+		/* fall through */
+	case check_state_compute_result:
+		sh->check_state = check_state_idle;
+		if (!dev)
+			dev = &sh->dev[sh->pd_idx];
 
+		/* check that a write has not made the stripe insync */
+		if (test_bit(STRIPE_INSYNC, &sh->state))
+			break;
 
-	/* Wait for check parity and compute block operations to complete
-	 * before write-back.  If a failure occurred while the check operation
-	 * was in flight we need to cycle this stripe through handle_stripe
-	 * since the parity block may not be uptodate
-	 */
-	if (!canceled_check && !test_bit(STRIPE_INSYNC, &sh->state) &&
-	    !test_bit(STRIPE_OP_CHECK, &sh->ops.pending) &&
-	    !test_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.pending)) {
-		struct r5dev *dev;
 		/* either failed parity check, or recovery is happening */
-		if (s->failed == 0)
-			s->failed_num = sh->pd_idx;
-		dev = &sh->dev[s->failed_num];
 		BUG_ON(!test_bit(R5_UPTODATE, &dev->flags));
 		BUG_ON(s->uptodate != disks);
 
 		set_bit(R5_LOCKED, &dev->flags);
+		s->locked++;
 		set_bit(R5_Wantwrite, &dev->flags);
 
 		clear_bit(STRIPE_DEGRADED, &sh->state);
-		s->locked++;
 		set_bit(STRIPE_INSYNC, &sh->state);
+		break;
+	case check_state_run:
+		break; /* we will be called again upon completion */
+	case check_state_check_result:
+		sh->check_state = check_state_idle;
+
+		/* if a failure occurred during the check operation, leave
+		 * STRIPE_INSYNC not set and let the stripe be handled again
+		 */
+		if (s->failed)
+			break;
+
+		/* handle a successful check operation, if parity is correct
+		 * we are done.  Otherwise update the mismatch count and repair
+		 * parity if !MD_RECOVERY_CHECK
+		 */
+		if (sh->ops.zero_sum_result == 0)
+			/* parity is correct (on disc,
+			 * not in buffer any more)
+			 */
+			set_bit(STRIPE_INSYNC, &sh->state);
+		else {
+			conf->mddev->resync_mismatches += STRIPE_SECTORS;
+			if (test_bit(MD_RECOVERY_CHECK, &conf->mddev->recovery))
+				/* don't try to repair!! */
+				set_bit(STRIPE_INSYNC, &sh->state);
+			else {
+				sh->check_state = check_state_compute_run;
+				set_bit(STRIPE_OP_COMPUTE_BLK, &s->ops_request);
+				set_bit(R5_Wantcompute,
+					&sh->dev[sh->pd_idx].flags);
+				sh->ops.target = sh->pd_idx;
+				s->uptodate++;
+			}
+		}
+		break;
+	case check_state_compute_run:
+		break;
+	default:
+		printk(KERN_ERR "%s: unknown check_state: %d sector: %llu\n",
+		       __func__, sh->check_state,
+		       (unsigned long long) sh->sector);
+		BUG();
 	}
 }
 
@@ -2807,7 +2802,7 @@ static void handle_stripe5(struct stripe
 	 *    block.
 	 */
 	if (s.to_write && !test_bit(STRIPE_OP_POSTXOR, &sh->ops.pending) &&
-			  !test_bit(STRIPE_OP_CHECK, &sh->ops.pending))
+	    !sh->check_state)
 		handle_issuing_new_write_requests5(conf, sh, &s, disks);
 
 	/* maybe we need to check and possibly fix the parity for this stripe
@@ -2815,11 +2810,10 @@ static void handle_stripe5(struct stripe
 	 * data is available.  The parity check is held off while parity
 	 * dependent operations are in flight.
 	 */
-	if ((s.syncing && s.locked == 0 &&
+	if (sh->check_state ||
+	    (s.syncing && s.locked == 0 &&
 	     !test_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.pending) &&
-	     !test_bit(STRIPE_INSYNC, &sh->state)) ||
-	      test_bit(STRIPE_OP_CHECK, &sh->ops.pending) ||
-	      test_bit(STRIPE_OP_MOD_REPAIR_PD, &sh->ops.pending))
+	     !test_bit(STRIPE_INSYNC, &sh->state)))
 		handle_parity_checks5(conf, sh, &s, disks);
 
 	if (s.syncing && s.locked == 0 && test_bit(STRIPE_INSYNC, &sh->state)) {
@@ -2897,8 +2891,8 @@ static void handle_stripe5(struct stripe
 	if (unlikely(blocked_rdev))
 		md_wait_for_blocked_rdev(blocked_rdev, conf->mddev);
 
-	if (pending)
-		raid5_run_ops(sh, pending);
+	if (pending || s.ops_request)
+		raid5_run_ops(sh, pending, s.ops_request);
 
 	ops_run_io(sh, &s);
 

diff .prev/include/linux/raid/raid5.h ./include/linux/raid/raid5.h
--- .prev/include/linux/raid/raid5.h	2008-06-27 16:22:04.000000000 +1000
+++ ./include/linux/raid/raid5.h	2008-06-27 16:22:05.000000000 +1000
@@ -158,6 +158,41 @@
  *    the compute block completes.
  */
 
+/*
+ * Operations state - intermediate states that are visible outside of sh->lock
+ * In general _idle indicates nothing is running, _run indicates a data
+ * processing operation is active, and _result means the data processing result
+ * is stable and can be acted upon.  For simple operations like biofill and
+ * compute that only have an _idle and _run state they are indicated with
+ * sh->state flags (STRIPE_BIOFILL_RUN and STRIPE_COMPUTE_RUN)
+ */
+/**
+ * enum check_states - handles syncing / repairing a stripe
+ * @check_state_idle - check operations are quiesced
+ * @check_state_run - check operation is running
+ * @check_state_result - set outside lock when check result is valid
+ * @check_state_compute_run - check failed and we are repairing
+ * @check_state_compute_result - set outside lock when compute result is valid
+ */
+enum check_states {
+	check_state_idle = 0,
+	check_state_run, /* parity check */
+	check_state_check_result,
+	check_state_compute_run, /* parity repair */
+	check_state_compute_result,
+};
+
+/**
+ * enum reconstruct_states - handles writing or expanding a stripe
+ */
+enum reconstruct_states {
+	reconstruct_state_idle = 0,
+	reconstruct_state_drain_run,		/* write */
+	reconstruct_state_run,			/* expand */
+	reconstruct_state_drain_result,
+	reconstruct_state_result,
+};
+
 struct stripe_head {
 	struct hlist_node	hash;
 	struct list_head	lru;			/* inactive_list or handle_list */
@@ -169,6 +204,7 @@ struct stripe_head {
 	spinlock_t		lock;
 	int			bm_seq;	/* sequence number for bitmap flushes */
 	int			disks;			/* disks in stripe */
+	enum check_states	check_state;
 	/* stripe_operations
 	 * @pending - pending ops flags (set for request->issue->complete)
 	 * @ack - submitted ops flags (set for issue->complete)
@@ -202,6 +238,7 @@ struct stripe_head_state {
 	int locked, uptodate, to_read, to_write, failed, written;
 	int to_fill, compute, req_compute, non_overwrite;
 	int failed_num;
+	unsigned long ops_request;
 };
 
 /* r6_state - extra state data only relevant to r6 */
@@ -254,8 +291,10 @@ struct r6_state {
 #define	STRIPE_EXPAND_READY	11
 #define	STRIPE_IO_STARTED	12 /* do not count towards 'bypass_count' */
 #define	STRIPE_FULL_WRITE	13 /* all blocks are set to be overwritten */
+#define	STRIPE_BIOFILL_RUN	14
+#define	STRIPE_COMPUTE_RUN	15
 /*
- * Operations flags (in issue order)
+ * Operation request flags
  */
 #define STRIPE_OP_BIOFILL	0
 #define STRIPE_OP_COMPUTE_BLK	1
@@ -264,11 +303,6 @@ struct r6_state {
 #define STRIPE_OP_POSTXOR	4
 #define STRIPE_OP_CHECK	5
 
-/* modifiers to the base operations
- * STRIPE_OP_MOD_REPAIR_PD - compute the parity block and write it back
- */
-#define STRIPE_OP_MOD_REPAIR_PD 7
-
 /*
  * Plugging:
  *
