From: Dan Williams <dan.j.williams@intel.com>
Subject: [RFC PATCH] md: towards a replacement for the raid5 STRIPE_OP_* flags
Date: Mon, 05 May 2008 16:07:40 -0700
Message-ID: <20080505224915.29821.46041.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The STRIPE_OP_* flags record the state of stripe operations which are
performed outside the stripe lock.  Their use in indicating which
operations need to be run is straightforward; however, interpolating what
the next state of the stripe should be based on a given combination of
these flags is not straightforward, and has led to bugs.  An easier to read
implementation with minimal degrees of freedom is needed.

Towards this goal, this patch introduces explicit states to replace what was
previously interpolated from the STRIPE_OP_* flags.  For now this only touches
the handle_parity_checks5 path.  See the comments for the 4 state domains
'check_states', 'compute_states', 'reconstruct_states', and 'read_states'.

Currently the diffstat shows a small decrease in lines of code for raid5.c.
This trend will continue as the flag / state sites are corrected.

This conversion also found a remaining issue with the current code.  There is
a small window for a drive to fail between when we schedule a repair and when
the parity calculation for that repair completes.  When this happens we will
writeback to 'failed_num' when we really want to write back to 'pd_idx'.

---
Basic rebuild/repair tests pass.

Is this more readable/debuggable?  Here is handle_parity_checks5() after the
patch:

static void handle_parity_checks5(raid5_conf_t *conf, struct stripe_head *sh,
				struct stripe_head_state *s, int disks)
{
	struct r5dev *dev = NULL;

	set_bit(STRIPE_HANDLE, &sh->state);

	switch (sh->check_state) {
	case check_state_idle:
		/* start a new check operation if there are no failures */
		if (s->failed == 0) {
			BUG_ON(s->uptodate != disks);
			sh->check_state = check_state_run;
			set_bit(STRIPE_OP_CHECK, &s->ops_run);
			clear_bit(R5_UPTODATE, &sh->dev[sh->pd_idx].flags);
			s->uptodate--;
			break;
		}
		dev = &sh->dev[s->failed_num];
		/* fall through */
	case check_state_compute_done:
		sh->check_state = check_state_idle;
		if (!dev)
			dev = &sh->dev[sh->pd_idx];

		/* check that a write has not made the stripe insync */
		if (test_bit(STRIPE_INSYNC, &sh->state))
			break;

		/* either failed parity check, or recovery is happening */
		BUG_ON(!test_bit(R5_UPTODATE, &dev->flags));
		BUG_ON(s->uptodate != disks);

		set_bit(R5_LOCKED, &dev->flags);
		s->locked++;
		set_bit(R5_Wantwrite, &dev->flags);
		if (!test_and_set_bit(STRIPE_OP_IO, &sh->ops.pending))
			sh->ops.count++;

		clear_bit(STRIPE_DEGRADED, &sh->state);
		set_bit(STRIPE_INSYNC, &sh->state);
		break;
	case check_state_run:
		break; /* we will be called again upon completion */
	case check_state_check_done:
		sh->check_state = check_state_idle;

		/* if a failure occurred during the check operation, leave
		 * STRIPE_INSYNC not set and let the stripe be handled again
		 */
		if (s->failed)
			break;
		
		/* handle a successful check operation, if parity is correct
		 * we are done.  Otherwise update the mismatch count and repair
		 * parity if !MD_RECOVERY_CHECK
		 */
		if (sh->ops.zero_sum_result == 0)
			/* parity is correct (on disc,
			 * not in buffer any more)
			 */
			set_bit(STRIPE_INSYNC, &sh->state);
		else {
			conf->mddev->resync_mismatches += STRIPE_SECTORS;
			if (test_bit(MD_RECOVERY_CHECK, &conf->mddev->recovery))
				/* don't try to repair!! */
				set_bit(STRIPE_INSYNC, &sh->state);
			else {
				sh->check_state = check_state_compute_run;
				set_bit(STRIPE_OP_COMPUTE_BLK, &s->ops_run);
				set_bit(R5_Wantcompute,
					&sh->dev[sh->pd_idx].flags);
				sh->ops.target = sh->pd_idx;
				s->uptodate++;
			}
		}
		break;
	case check_state_compute_run:
		break;
	default:
		printk(KERN_ERR "%s: unknown check_state: %d sector: %llu\n",
		       __func__, sh->check_state,
		       (unsigned long long) sh->sector);
		BUG();
	}
}

 drivers/md/raid5.c         |  166 +++++++++++++++++++++-----------------------
 include/linux/raid/raid5.h |   50 +++++++++++++
 2 files changed, 129 insertions(+), 87 deletions(-)


diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 59964a7..77e2fd0 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -608,7 +608,12 @@ static void ops_complete_compute5(void *stripe_head_ref)
 	set_bit(R5_UPTODATE, &tgt->flags);
 	BUG_ON(!test_bit(R5_Wantcompute, &tgt->flags));
 	clear_bit(R5_Wantcompute, &tgt->flags);
-	set_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.complete);
+	/* we can only be computing or repairing, not both */
+	BUG_ON(sh->check_state & sh->compute_state);
+	if (sh->check_state)
+		sh->check_state = check_state_compute_done;
+	else
+		set_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.complete);
 	set_bit(STRIPE_HANDLE, &sh->state);
 	release_stripe(sh);
 }
@@ -846,7 +851,7 @@ static void ops_complete_check(void *stripe_head_ref)
 		sh->ops.zero_sum_result == 0)
 		set_bit(R5_UPTODATE, &sh->dev[pd_idx].flags);
 
-	set_bit(STRIPE_OP_CHECK, &sh->ops.complete);
+	sh->check_state = check_state_check_done;
 	set_bit(STRIPE_HANDLE, &sh->state);
 	release_stripe(sh);
 }
@@ -883,7 +888,8 @@ static void ops_run_check(struct stripe_head *sh)
 		ops_complete_check, sh);
 }
 
-static void raid5_run_ops(struct stripe_head *sh, unsigned long pending)
+static void raid5_run_ops(struct stripe_head *sh, unsigned long pending,
+			  struct stripe_head_state *s)
 {
 	int overlap_clear = 0, i, disks = sh->disks;
 	struct dma_async_tx_descriptor *tx = NULL;
@@ -893,7 +899,8 @@ static void raid5_run_ops(struct stripe_head *sh, unsigned long pending)
 		overlap_clear++;
 	}
 
-	if (test_bit(STRIPE_OP_COMPUTE_BLK, &pending))
+	if (test_bit(STRIPE_OP_COMPUTE_BLK, &pending) ||
+	    test_bit(STRIPE_OP_COMPUTE_BLK, &s->ops_run))
 		tx = ops_run_compute5(sh, pending);
 
 	if (test_bit(STRIPE_OP_PREXOR, &pending))
@@ -907,7 +914,7 @@ static void raid5_run_ops(struct stripe_head *sh, unsigned long pending)
 	if (test_bit(STRIPE_OP_POSTXOR, &pending))
 		ops_run_postxor(sh, tx, pending);
 
-	if (test_bit(STRIPE_OP_CHECK, &pending))
+	if (test_bit(STRIPE_OP_CHECK, &s->ops_run))
 		ops_run_check(sh);
 
 	if (test_bit(STRIPE_OP_IO, &pending))
@@ -1969,8 +1976,7 @@ static int __handle_issuing_new_read_requests5(struct stripe_head *sh,
 	/* don't schedule compute operations or reads on the parity block while
 	 * a check is in flight
 	 */
-	if ((disk_idx == sh->pd_idx) &&
-	     test_bit(STRIPE_OP_CHECK, &sh->ops.pending))
+	if (disk_idx == sh->pd_idx && sh->check_state != check_state_idle)
 		return ~0;
 
 	/* is the data in this block needed, and can we get it? */
@@ -1992,7 +1998,7 @@ static int __handle_issuing_new_read_requests5(struct stripe_head *sh,
 		 * have quiesced.
 		 */
 		if ((s->uptodate == disks - 1) &&
-		    !test_bit(STRIPE_OP_CHECK, &sh->ops.pending)) {
+		    sh->check_state == check_state_idle) {
 			set_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.pending);
 			set_bit(R5_Wantcompute, &dev->flags);
 			sh->ops.target = disk_idx;
@@ -2030,12 +2036,8 @@ static void handle_issuing_new_read_requests5(struct stripe_head *sh,
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
@@ -2363,92 +2365,87 @@ static void handle_issuing_new_write_requests6(raid5_conf_t *conf,
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
+			set_bit(STRIPE_OP_CHECK, &s->ops_run);
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
-
+		dev = &sh->dev[s->failed_num];
+		/* fall through */
+	case check_state_compute_done:
+		sh->check_state = check_state_idle;
+		if (!dev)
+			dev = &sh->dev[sh->pd_idx];
+
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
 		if (!test_and_set_bit(STRIPE_OP_IO, &sh->ops.pending))
 			sh->ops.count++;
 
 		clear_bit(STRIPE_DEGRADED, &sh->state);
-		s->locked++;
 		set_bit(STRIPE_INSYNC, &sh->state);
+		break;
+	case check_state_run:
+		break; /* we will be called again upon completion */
+	case check_state_check_done:
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
+				set_bit(STRIPE_OP_COMPUTE_BLK, &s->ops_run);
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
 
@@ -2820,7 +2817,7 @@ static void handle_stripe5(struct stripe_head *sh)
 	 *    block.
 	 */
 	if (s.to_write && !test_bit(STRIPE_OP_POSTXOR, &sh->ops.pending) &&
-			  !test_bit(STRIPE_OP_CHECK, &sh->ops.pending))
+	    sh->check_state == check_state_idle)
 		handle_issuing_new_write_requests5(conf, sh, &s, disks);
 
 	/* maybe we need to check and possibly fix the parity for this stripe
@@ -2831,8 +2828,7 @@ static void handle_stripe5(struct stripe_head *sh)
 	if ((s.syncing && s.locked == 0 &&
 	     !test_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.pending) &&
 	     !test_bit(STRIPE_INSYNC, &sh->state)) ||
-	      test_bit(STRIPE_OP_CHECK, &sh->ops.pending) ||
-	      test_bit(STRIPE_OP_MOD_REPAIR_PD, &sh->ops.pending))
+	     sh->check_state != check_state_idle)
 		handle_parity_checks5(conf, sh, &s, disks);
 
 	if (s.syncing && s.locked == 0 && test_bit(STRIPE_INSYNC, &sh->state)) {
@@ -2914,8 +2910,8 @@ static void handle_stripe5(struct stripe_head *sh)
 	if (unlikely(blocked_rdev))
 		md_wait_for_blocked_rdev(blocked_rdev, conf->mddev);
 
-	if (pending)
-		raid5_run_ops(sh, pending);
+	if (pending || s.ops_run)
+		raid5_run_ops(sh, pending, &s);
 
 	return_io(return_bi);
 
diff --git a/include/linux/raid/raid5.h b/include/linux/raid/raid5.h
index f0827d3..676ae03 100644
--- a/include/linux/raid/raid5.h
+++ b/include/linux/raid/raid5.h
@@ -158,6 +158,51 @@
  *    the compute block completes.
  */
 
+/*
+ * Operations state - intermediate states that are visible outside of sh->lock
+ */
+/**
+ * enum check_states - handles syncing / repairing a stripe
+ * @check_state_idle - check operations are quiesced
+ * @check_state_run - check operation is running
+ * @check_state_check_done - set outside the lock when check result is valid
+ * @check_state_compute_run - check failed and we are repairing
+ * @check_state_compute_done - corrected parity ready for writeback
+ */
+enum check_states {
+	check_state_idle,
+	check_state_run, /* parity check */
+	check_state_check_done,
+	check_state_compute_run, /* parity repair */
+	check_state_compute_done,
+};
+
+/**
+ * enum compute_states - compute a block to satisfy a read or write request
+ * This is a companion to reconstruct_states and read_states.  Code explicitly
+ * checks that a check state is not active before setting this to run
+ */
+enum compute_states {
+	compute_state_idle,
+	compute_state_run, /* compute missing */
+};
+
+/**
+ * enum reconstruct_states - handles writing or expanding a stripe
+ */
+enum reconstruct_states {
+	reconstruct_state_idle,
+	reconstruct_state_run_with_drain, /* write */
+	reconstruct_state_run,		  /* expand */
+	reconstruct_state_done_with_drain,
+	reconstruct_state_done,
+};
+
+enum read_states {
+	read_state_idle,
+	read_state_run,
+};
+
 struct stripe_head {
 	struct hlist_node	hash;
 	struct list_head	lru;			/* inactive_list or handle_list */
@@ -169,6 +214,8 @@ struct stripe_head {
 	spinlock_t		lock;
 	int			bm_seq;	/* sequence number for bitmap flushes */
 	int			disks;			/* disks in stripe */
+	enum check_states	check_state;
+	enum compute_states	compute_state;
 	/* stripe_operations
 	 * @pending - pending ops flags (set for request->issue->complete)
 	 * @ack - submitted ops flags (set for issue->complete)
@@ -202,6 +249,7 @@ struct stripe_head_state {
 	int locked, uptodate, to_read, to_write, failed, written;
 	int to_fill, compute, req_compute, non_overwrite;
 	int failed_num;
+	unsigned long ops_run;
 };
 
 /* r6_state - extra state data only relevant to r6 */
@@ -266,10 +314,8 @@ struct r6_state {
 #define STRIPE_OP_IO		6
 
 /* modifiers to the base operations
- * STRIPE_OP_MOD_REPAIR_PD - compute the parity block and write it back
  * STRIPE_OP_MOD_DMA_CHECK - parity is not corrupted by the check
  */
-#define STRIPE_OP_MOD_REPAIR_PD 7
 #define STRIPE_OP_MOD_DMA_CHECK 8
 
 /*

