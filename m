From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH RFC 1/4] md: introduce struct stripe_head_state
Date: Tue, 10 Apr 2007 23:00:26 -0700
Message-ID: <20070411060026.15745.84714.stgit@dwillia2-linux.ch.intel.com>
References: <20070411055729.15745.51513.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070411055729.15745.51513.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

struct stripe_head_state collects all the dynamic stripe-state information
that is calculated/tracked during calls to handle_stripe.  This enables a
mechanism for handle_stripe functionality to be broken off into
subroutines.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 drivers/md/raid5.c         |  280 ++++++++++++++++++++++----------------------
 include/linux/raid/raid5.h |   11 ++
 2 files changed, 153 insertions(+), 138 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 74ce354..684552a 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1872,12 +1872,14 @@ static void handle_stripe5(struct stripe_head *sh)
 	struct bio *return_bi= NULL;
 	struct bio *bi;
 	int i;
-	int syncing, expanding, expanded;
-	int locked=0, uptodate=0, to_read=0, to_write=0, failed=0, written=0;
-	int to_fill=0, compute=0, req_compute=0, non_overwrite=0;
-	int failed_num=0;
+	struct stripe_head_state s = {
+		.locked=0, .uptodate=0, .to_read=0, .to_write=0, .failed=0,
+		.written=0, .to_fill=0, .compute=0, .req_compute=0,
+		.non_overwrite=0,
+	};
 	struct r5dev *dev;
 	unsigned long pending=0;
+	s.failed_num=0;
 
 	PRINTK("handling stripe %llu, state=%#lx cnt=%d, pd_idx=%d ops=%lx:%lx:%lx\n",
 	       (unsigned long long)sh->sector, sh->state, atomic_read(&sh->count),
@@ -1887,9 +1889,9 @@ static void handle_stripe5(struct stripe_head *sh)
 	clear_bit(STRIPE_HANDLE, &sh->state);
 	clear_bit(STRIPE_DELAYED, &sh->state);
 
-	syncing = test_bit(STRIPE_SYNCING, &sh->state);
-	expanding = test_bit(STRIPE_EXPAND_SOURCE, &sh->state);
-	expanded = test_bit(STRIPE_EXPAND_READY, &sh->state);
+	s.syncing = test_bit(STRIPE_SYNCING, &sh->state);
+	s.expanding = test_bit(STRIPE_EXPAND_SOURCE, &sh->state);
+	s.expanded = test_bit(STRIPE_EXPAND_READY, &sh->state);
 	/* Now to look around and see what can be done */
 
 	rcu_read_lock();
@@ -1911,22 +1913,22 @@ static void handle_stripe5(struct stripe_head *sh)
 			set_bit(R5_Wantfill, &dev->flags);
 
 		/* now count some things */
-		if (test_bit(R5_LOCKED, &dev->flags)) locked++;
-		if (test_bit(R5_UPTODATE, &dev->flags)) uptodate++;
+		if (test_bit(R5_LOCKED, &dev->flags)) s.locked++;
+		if (test_bit(R5_UPTODATE, &dev->flags)) s.uptodate++;
 
 		if (test_bit(R5_Wantfill, &dev->flags))
-			to_fill++;
+			s.to_fill++;
 		else if (dev->toread)
-			to_read++;
+			s.to_read++;
 
-		if (test_bit(R5_Wantcompute, &dev->flags)) BUG_ON(++compute > 1);
+		if (test_bit(R5_Wantcompute, &dev->flags)) BUG_ON(++s.compute > 1);
 
 		if (dev->towrite) {
-			to_write++;
+			s.to_write++;
 			if (!test_bit(R5_OVERWRITE, &dev->flags))
-				non_overwrite++;
+				s.non_overwrite++;
 		}
-		if (dev->written) written++;
+		if (dev->written) s.written++;
 		rdev = rcu_dereference(conf->disks[i].rdev);
 		if (!rdev || !test_bit(In_sync, &rdev->flags)) {
 			/* The ReadError flag will just be confusing now */
@@ -1935,23 +1937,24 @@ static void handle_stripe5(struct stripe_head *sh)
 		}
 		if (!rdev || !test_bit(In_sync, &rdev->flags)
 		    || test_bit(R5_ReadError, &dev->flags)) {
-			failed++;
-			failed_num = i;
+			s.failed++;
+			s.failed_num = i;
 		} else
 			set_bit(R5_Insync, &dev->flags);
 	}
 	rcu_read_unlock();
 
-	if (to_fill && !test_and_set_bit(STRIPE_OP_BIOFILL, &sh->ops.pending))
+	if (s.to_fill && !test_and_set_bit(STRIPE_OP_BIOFILL, &sh->ops.pending))
 		sh->ops.count++;
 
 	PRINTK("locked=%d uptodate=%d to_read=%d"
 		" to_write=%d to_fill=%d failed=%d failed_num=%d\n",
-		locked, uptodate, to_read, to_write, to_fill, failed, failed_num);
+		s.locked, s.uptodate, s.to_read, s.to_write, s.to_fill,
+		s.failed, s.failed_num);
 	/* check if the array has lost two devices and, if so, some requests might
 	 * need to be failed
 	 */
-	if (failed > 1 && to_read+to_write+written) {
+	if (s.failed > 1 && s.to_read+s.to_write+s.written) {
 		for (i=disks; i--; ) {
 			int bitmap_end = 0;
 
@@ -1969,7 +1972,7 @@ static void handle_stripe5(struct stripe_head *sh)
 			/* fail all writes first */
 			bi = sh->dev[i].towrite;
 			sh->dev[i].towrite = NULL;
-			if (bi) { to_write--; bitmap_end = 1; }
+			if (bi) { s.to_write--; bitmap_end = 1; }
 
 			if (test_and_clear_bit(R5_Overlap, &sh->dev[i].flags))
 				wake_up(&conf->wait_for_overlap);
@@ -2009,7 +2012,7 @@ static void handle_stripe5(struct stripe_head *sh)
 				sh->dev[i].toread = NULL;
 				if (test_and_clear_bit(R5_Overlap, &sh->dev[i].flags))
 					wake_up(&conf->wait_for_overlap);
-				if (bi) to_read--;
+				if (bi) s.to_read--;
 				while (bi && bi->bi_sector < sh->dev[i].sector + STRIPE_SECTORS){
 					struct bio *nextbi = r5_next_bio(bi, sh->dev[i].sector);
 					clear_bit(BIO_UPTODATE, &bi->bi_flags);
@@ -2026,20 +2029,20 @@ static void handle_stripe5(struct stripe_head *sh)
 						STRIPE_SECTORS, 0, 0);
 		}
 	}
-	if (failed > 1 && syncing) {
+	if (s.failed > 1 && s.syncing) {
 		md_done_sync(conf->mddev, STRIPE_SECTORS,0);
 		clear_bit(STRIPE_SYNCING, &sh->state);
-		syncing = 0;
+		s.syncing = 0;
 	}
 
 	/* might be able to return some write requests if the parity block
 	 * is safe, or on a failed drive
 	 */
 	dev = &sh->dev[sh->pd_idx];
-	if ( written &&
+	if ( s.written &&
 	     ( (test_bit(R5_Insync, &dev->flags) && !test_bit(R5_LOCKED, &dev->flags) &&
 		test_bit(R5_UPTODATE, &dev->flags))
-	       || (failed == 1 && failed_num == sh->pd_idx))
+	       || (s.failed == 1 && s.failed_num == sh->pd_idx))
 	    ) {
 	    /* any written block on an uptodate or failed drive can be returned.
 	     * Note that if we 'wrote' to a failed drive, it will be UPTODATE, but 
@@ -2081,8 +2084,8 @@ static void handle_stripe5(struct stripe_head *sh)
 	 * parity, or to satisfy requests
 	 * or to load a block that is being partially written.
 	 */
-	if (to_read || non_overwrite || (syncing && (uptodate + compute < disks)) || expanding ||
-		test_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.pending)) {
+	if (s.to_read || s.non_overwrite || (s.syncing && (s.uptodate + s.compute < disks)) ||
+		s.expanding || test_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.pending)) {
 
 		/* Clear completed compute operations.  Parity recovery
 		 * (STRIPE_OP_MOD_REPAIR_PD) implies a write-back which is handled
@@ -2114,11 +2117,11 @@ static void handle_stripe5(struct stripe_head *sh)
 				if (!test_bit(R5_LOCKED, &dev->flags) && !test_bit(R5_UPTODATE, &dev->flags) &&
 				     (dev->toread ||
 				     (dev->towrite && !test_bit(R5_OVERWRITE, &dev->flags)) ||
-				     syncing ||
-				     expanding ||
-				     (failed && (sh->dev[failed_num].toread ||
-						 (sh->dev[failed_num].towrite &&
-						 	!test_bit(R5_OVERWRITE, &sh->dev[failed_num].flags))))
+				     s.syncing ||
+				     s.expanding ||
+				     (s.failed && (sh->dev[s.failed_num].toread ||
+						 (sh->dev[s.failed_num].towrite &&
+						 	!test_bit(R5_OVERWRITE, &sh->dev[s.failed_num].flags))))
 					    )
 					) {
 					/* 1/ We would like to get this block, possibly
@@ -2132,20 +2135,20 @@ static void handle_stripe5(struct stripe_head *sh)
 					 * 3/ We hold off parity block re-reads until check
 					 * operations have quiesced.
 					 */
-					if ((uptodate == disks-1) && !test_bit(STRIPE_OP_CHECK, &sh->ops.pending)) {
+					if ((s.uptodate == disks-1) && !test_bit(STRIPE_OP_CHECK, &sh->ops.pending)) {
 						set_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.pending);
 						set_bit(R5_Wantcompute, &dev->flags);
 						sh->ops.target = i;
-						req_compute = 1;
+						s.req_compute = 1;
 						sh->ops.count++;
 						/* Careful: from this point on 'uptodate' is in the eye of
 						 * raid5_run_ops which services 'compute' operations before
 						 * writes. R5_Wantcompute flags a block that will be R5_UPTODATE
 						 * by the time it is needed for a subsequent operation.
 						 */
-						uptodate++;
+						s.uptodate++;
 						break; /* uptodate + compute == disks */
-					} else if ((uptodate < disks-1) && test_bit(R5_Insync, &dev->flags)) {
+					} else if ((s.uptodate < disks-1) && test_bit(R5_Insync, &dev->flags)) {
 						/* Note: we hold off compute operations while checks are in flight,
 						 * but we still prefer 'compute' over 'read' hence we only read if
 						 * (uptodate < disks-1)
@@ -2154,9 +2157,9 @@ static void handle_stripe5(struct stripe_head *sh)
 						set_bit(R5_Wantread, &dev->flags);
 						if (!test_and_set_bit(STRIPE_OP_IO, &sh->ops.pending))
 							sh->ops.count++;
-						locked++;
+						s.locked++;
 						PRINTK("Reading block %d (sync=%d)\n",
-							i, syncing);
+							i, s.syncing);
 					}
 				}
 			}
@@ -2207,7 +2210,7 @@ static void handle_stripe5(struct stripe_head *sh)
 				if (!test_and_set_bit(STRIPE_OP_IO, &sh->ops.pending))
 					sh->ops.count++;
 				if (!test_bit(R5_Insync, &dev->flags)
-				    || (i==sh->pd_idx && failed == 0))
+				    || (i==sh->pd_idx && s.failed == 0))
 					set_bit(STRIPE_INSYNC, &sh->state);
 			}
 		}
@@ -2223,7 +2226,7 @@ static void handle_stripe5(struct stripe_head *sh)
 	 *    a check is in flight
 	 * 3/ Write operations do not stack
 	 */
-	if (to_write && !test_bit(STRIPE_OP_POSTXOR, &sh->ops.pending) &&
+	if (s.to_write && !test_bit(STRIPE_OP_POSTXOR, &sh->ops.pending) &&
 		!test_bit(STRIPE_OP_CHECK, &sh->ops.pending)) {
 		int rmw=0, rcw=0;
 		for (i=disks ; i--;) {
@@ -2266,7 +2269,7 @@ static void handle_stripe5(struct stripe_head *sh)
 						set_bit(R5_Wantread, &dev->flags);
 						if (!test_and_set_bit(STRIPE_OP_IO, &sh->ops.pending))
 							sh->ops.count++;
-						locked++;
+						s.locked++;
 					} else {
 						set_bit(STRIPE_DELAYED, &sh->state);
 						set_bit(STRIPE_HANDLE, &sh->state);
@@ -2288,7 +2291,7 @@ static void handle_stripe5(struct stripe_head *sh)
 						set_bit(R5_Wantread, &dev->flags);
 						if (!test_and_set_bit(STRIPE_OP_IO, &sh->ops.pending))
 							sh->ops.count++;
-						locked++;
+						s.locked++;
 					} else {
 						set_bit(STRIPE_DELAYED, &sh->state);
 						set_bit(STRIPE_HANDLE, &sh->state);
@@ -2303,10 +2306,10 @@ static void handle_stripe5(struct stripe_head *sh)
 		 * is not the case then new writes need to be held off until the compute
 		 * completes.
 		 */
-		if ((req_compute || !test_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.pending)) &&
-			(locked == 0 && (rcw == 0 ||rmw == 0) &&
+		if ((s.req_compute || !test_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.pending)) &&
+			(s.locked == 0 && (rcw == 0 ||rmw == 0) &&
 			!test_bit(STRIPE_BIT_DELAY, &sh->state)))
-			locked += handle_write_operations5(sh, rcw == 0, 0);
+			s.locked += handle_write_operations5(sh, rcw == 0, 0);
 	}
 
 	/* 1/ Maybe we need to check and possibly fix the parity for this stripe.
@@ -2315,7 +2318,7 @@ static void handle_stripe5(struct stripe_head *sh)
 	 * 2/ Hold off parity checks while parity dependent operations are in flight
 	 *    (conflicting writes are protected by the 'locked' variable)
 	 */
-	if ((syncing && locked == 0 && !test_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.pending) &&
+	if ((s.syncing && s.locked == 0 && !test_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.pending) &&
 		!test_bit(STRIPE_INSYNC, &sh->state)) ||
 	    	test_bit(STRIPE_OP_CHECK, &sh->ops.pending) ||
 	    	test_bit(STRIPE_OP_MOD_REPAIR_PD, &sh->ops.pending)) {
@@ -2327,12 +2330,12 @@ static void handle_stripe5(struct stripe_head *sh)
 		 * 3/ skip to the writeback section if we previously
 		 *    initiated a recovery operation
 		 */
-		if (failed == 0 && !test_bit(STRIPE_OP_MOD_REPAIR_PD, &sh->ops.pending)) {
+		if (s.failed == 0 && !test_bit(STRIPE_OP_MOD_REPAIR_PD, &sh->ops.pending)) {
 			if (!test_and_set_bit(STRIPE_OP_CHECK, &sh->ops.pending)) {
-				BUG_ON(uptodate != disks);
+				BUG_ON(s.uptodate != disks);
 				clear_bit(R5_UPTODATE, &sh->dev[sh->pd_idx].flags);
 				sh->ops.count++;
-				uptodate--;
+				s.uptodate--;
 			} else if (test_and_clear_bit(STRIPE_OP_CHECK, &sh->ops.complete)) {
 				clear_bit(STRIPE_OP_CHECK, &sh->ops.ack);
 				clear_bit(STRIPE_OP_CHECK, &sh->ops.pending);
@@ -2354,7 +2357,7 @@ static void handle_stripe5(struct stripe_head *sh)
 							&sh->dev[sh->pd_idx].flags);
 						sh->ops.target = sh->pd_idx;
 						sh->ops.count++;
-						uptodate++;
+						s.uptodate++;
 					}
 				}
 			}
@@ -2378,22 +2381,22 @@ static void handle_stripe5(struct stripe_head *sh)
 			!test_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.pending)) {
 
 			/* either failed parity check, or recovery is happening */
-			if (failed==0)
-				failed_num = sh->pd_idx;
-			dev = &sh->dev[failed_num];
+			if (s.failed==0)
+				s.failed_num = sh->pd_idx;
+			dev = &sh->dev[s.failed_num];
 			BUG_ON(!test_bit(R5_UPTODATE, &dev->flags));
-			BUG_ON(uptodate != disks);
+			BUG_ON(s.uptodate != disks);
 
 			set_bit(R5_LOCKED, &dev->flags);
 			set_bit(R5_Wantwrite, &dev->flags);
 			if (!test_and_set_bit(STRIPE_OP_IO, &sh->ops.pending))
 				sh->ops.count++;
 			clear_bit(STRIPE_DEGRADED, &sh->state);
-			locked++;
+			s.locked++;
 			set_bit(STRIPE_INSYNC, &sh->state);
 		}
 	}
-	if (syncing && locked == 0 && test_bit(STRIPE_INSYNC, &sh->state)) {
+	if (s.syncing && s.locked == 0 && test_bit(STRIPE_INSYNC, &sh->state)) {
 		md_done_sync(conf->mddev, STRIPE_SECTORS,1);
 		clear_bit(STRIPE_SYNCING, &sh->state);
 	}
@@ -2401,26 +2404,26 @@ static void handle_stripe5(struct stripe_head *sh)
 	/* If the failed drive is just a ReadError, then we might need to progress
 	 * the repair/check process
 	 */
-	if (failed == 1 && ! conf->mddev->ro &&
-	    test_bit(R5_ReadError, &sh->dev[failed_num].flags)
-	    && !test_bit(R5_LOCKED, &sh->dev[failed_num].flags)
-	    && test_bit(R5_UPTODATE, &sh->dev[failed_num].flags)
+	if (s.failed == 1 && ! conf->mddev->ro &&
+	    test_bit(R5_ReadError, &sh->dev[s.failed_num].flags)
+	    && !test_bit(R5_LOCKED, &sh->dev[s.failed_num].flags)
+	    && test_bit(R5_UPTODATE, &sh->dev[s.failed_num].flags)
 		) {
-		dev = &sh->dev[failed_num];
+		dev = &sh->dev[s.failed_num];
 		if (!test_bit(R5_ReWrite, &dev->flags)) {
 			set_bit(R5_Wantwrite, &dev->flags);
 			if (!test_and_set_bit(STRIPE_OP_IO, &sh->ops.pending))
 				sh->ops.count++;
 			set_bit(R5_ReWrite, &dev->flags);
 			set_bit(R5_LOCKED, &dev->flags);
-			locked++;
+			s.locked++;
 		} else {
 			/* let's read it back */
 			set_bit(R5_Wantread, &dev->flags);
 			if (!test_and_set_bit(STRIPE_OP_IO, &sh->ops.pending))
 				sh->ops.count++;
 			set_bit(R5_LOCKED, &dev->flags);
-			locked++;
+			s.locked++;
 		}
 	}
 
@@ -2443,20 +2446,20 @@ static void handle_stripe5(struct stripe_head *sh)
 		}
 	}
 
-	if (expanded && test_bit(STRIPE_EXPANDING, &sh->state) &&
+	if (s.expanded && test_bit(STRIPE_EXPANDING, &sh->state) &&
 		!test_bit(STRIPE_OP_POSTXOR, &sh->ops.pending)) {
 		/* Need to write out all blocks after computing parity */
 		sh->disks = conf->raid_disks;
 		sh->pd_idx = stripe_to_pdidx(sh->sector, conf, conf->raid_disks);
-		locked += handle_write_operations5(sh, 0, 1);
-	} else if (expanded && !test_bit(STRIPE_OP_POSTXOR, &sh->ops.pending)) {
+		s.locked += handle_write_operations5(sh, 0, 1);
+	} else if (s.expanded && !test_bit(STRIPE_OP_POSTXOR, &sh->ops.pending)) {
 		clear_bit(STRIPE_EXPAND_READY, &sh->state);
 		atomic_dec(&conf->reshape_stripes);
 		wake_up(&conf->wait_for_overlap);
 		md_done_sync(conf->mddev, STRIPE_SECTORS, 1);
 	}
 
-	if (expanding && locked == 0) {
+	if (s.expanding && s.locked == 0) {
 		/* We have read all the blocks in this stripe and now we need to
 		 * copy some of them into a target stripe for expand.
 		 */
@@ -2537,14 +2540,15 @@ static void handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
 	struct bio *return_bi= NULL;
 	struct bio *bi;
 	int i;
-	int syncing, expanding, expanded;
-	int locked=0, uptodate=0, to_read=0, to_write=0, failed=0, written=0;
-	int non_overwrite = 0;
-	int failed_num[2] = {0, 0};
+	struct stripe_head_state s = {
+		.locked=0, .uptodate=0, .to_read=0, .to_write=0, .failed=0,
+		.written=0, .non_overwrite = 0,
+	};
 	struct r5dev *dev, *pdev, *qdev;
 	int pd_idx = sh->pd_idx;
 	int qd_idx = raid6_next_disk(pd_idx, disks);
 	int p_failed, q_failed;
+	s.r6_failed_num[0] = s.r6_failed_num[1] = 0;
 
 	PRINTK("handling stripe %llu, state=%#lx cnt=%d, pd_idx=%d, qd_idx=%d\n",
 	       (unsigned long long)sh->sector, sh->state, atomic_read(&sh->count),
@@ -2554,9 +2558,9 @@ static void handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
 	clear_bit(STRIPE_HANDLE, &sh->state);
 	clear_bit(STRIPE_DELAYED, &sh->state);
 
-	syncing = test_bit(STRIPE_SYNCING, &sh->state);
-	expanding = test_bit(STRIPE_EXPAND_SOURCE, &sh->state);
-	expanded = test_bit(STRIPE_EXPAND_READY, &sh->state);
+	s.syncing = test_bit(STRIPE_SYNCING, &sh->state);
+	s.expanding = test_bit(STRIPE_EXPAND_SOURCE, &sh->state);
+	s.expanded = test_bit(STRIPE_EXPAND_READY, &sh->state);
 	/* Now to look around and see what can be done */
 
 	rcu_read_lock();
@@ -2591,17 +2595,17 @@ static void handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
 		}
 
 		/* now count some things */
-		if (test_bit(R5_LOCKED, &dev->flags)) locked++;
-		if (test_bit(R5_UPTODATE, &dev->flags)) uptodate++;
+		if (test_bit(R5_LOCKED, &dev->flags)) s.locked++;
+		if (test_bit(R5_UPTODATE, &dev->flags)) s.uptodate++;
 
 
-		if (dev->toread) to_read++;
+		if (dev->toread) s.to_read++;
 		if (dev->towrite) {
-			to_write++;
+			s.to_write++;
 			if (!test_bit(R5_OVERWRITE, &dev->flags))
-				non_overwrite++;
+				s.non_overwrite++;
 		}
-		if (dev->written) written++;
+		if (dev->written) s.written++;
 		rdev = rcu_dereference(conf->disks[i].rdev);
 		if (!rdev || !test_bit(In_sync, &rdev->flags)) {
 			/* The ReadError flag will just be confusing now */
@@ -2610,21 +2614,21 @@ static void handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
 		}
 		if (!rdev || !test_bit(In_sync, &rdev->flags)
 		    || test_bit(R5_ReadError, &dev->flags)) {
-			if ( failed < 2 )
-				failed_num[failed] = i;
-			failed++;
+			if ( s.failed < 2 )
+				s.r6_failed_num[s.failed] = i;
+			s.failed++;
 		} else
 			set_bit(R5_Insync, &dev->flags);
 	}
 	rcu_read_unlock();
 	PRINTK("locked=%d uptodate=%d to_read=%d"
 	       " to_write=%d failed=%d failed_num=%d,%d\n",
-	       locked, uptodate, to_read, to_write, failed,
-	       failed_num[0], failed_num[1]);
+	       s.locked, s.uptodate, s.to_read, s.to_write, s.failed,
+	       s.r6_failed_num[0], s.r6_failed_num[1]);
 	/* check if the array has lost >2 devices and, if so, some requests might
 	 * need to be failed
 	 */
-	if (failed > 2 && to_read+to_write+written) {
+	if (s.failed > 2 && s.to_read+s.to_write+s.written) {
 		for (i=disks; i--; ) {
 			int bitmap_end = 0;
 
@@ -2642,7 +2646,7 @@ static void handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
 			/* fail all writes first */
 			bi = sh->dev[i].towrite;
 			sh->dev[i].towrite = NULL;
-			if (bi) { to_write--; bitmap_end = 1; }
+			if (bi) { s.to_write--; bitmap_end = 1; }
 
 			if (test_and_clear_bit(R5_Overlap, &sh->dev[i].flags))
 				wake_up(&conf->wait_for_overlap);
@@ -2679,7 +2683,7 @@ static void handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
 				sh->dev[i].toread = NULL;
 				if (test_and_clear_bit(R5_Overlap, &sh->dev[i].flags))
 					wake_up(&conf->wait_for_overlap);
-				if (bi) to_read--;
+				if (bi) s.to_read--;
 				while (bi && bi->bi_sector < sh->dev[i].sector + STRIPE_SECTORS){
 					struct bio *nextbi = r5_next_bio(bi, sh->dev[i].sector);
 					clear_bit(BIO_UPTODATE, &bi->bi_flags);
@@ -2696,10 +2700,10 @@ static void handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
 						STRIPE_SECTORS, 0, 0);
 		}
 	}
-	if (failed > 2 && syncing) {
+	if (s.failed > 2 && s.syncing) {
 		md_done_sync(conf->mddev, STRIPE_SECTORS,0);
 		clear_bit(STRIPE_SYNCING, &sh->state);
-		syncing = 0;
+		s.syncing = 0;
 	}
 
 	/*
@@ -2707,13 +2711,13 @@ static void handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
 	 * are safe, or on a failed drive
 	 */
 	pdev = &sh->dev[pd_idx];
-	p_failed = (failed >= 1 && failed_num[0] == pd_idx)
-		|| (failed >= 2 && failed_num[1] == pd_idx);
+	p_failed = (s.failed >= 1 && s.r6_failed_num[0] == pd_idx)
+		|| (s.failed >= 2 && s.r6_failed_num[1] == pd_idx);
 	qdev = &sh->dev[qd_idx];
-	q_failed = (failed >= 1 && failed_num[0] == qd_idx)
-		|| (failed >= 2 && failed_num[1] == qd_idx);
+	q_failed = (s.failed >= 1 && s.r6_failed_num[0] == qd_idx)
+		|| (s.failed >= 2 && s.r6_failed_num[1] == qd_idx);
 
-	if ( written &&
+	if ( s.written &&
 	     ( p_failed || ((test_bit(R5_Insync, &pdev->flags)
 			     && !test_bit(R5_LOCKED, &pdev->flags)
 			     && test_bit(R5_UPTODATE, &pdev->flags))) ) &&
@@ -2762,28 +2766,28 @@ static void handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
 	 * parity, or to satisfy requests
 	 * or to load a block that is being partially written.
 	 */
-	if (to_read || non_overwrite || (to_write && failed) ||
-	    (syncing && (uptodate < disks)) || expanding) {
+	if (s.to_read || s.non_overwrite || (s.to_write && s.failed) ||
+	    (s.syncing && (s.uptodate < disks)) || s.expanding) {
 		for (i=disks; i--;) {
 			dev = &sh->dev[i];
 			if (!test_bit(R5_LOCKED, &dev->flags) && !test_bit(R5_UPTODATE, &dev->flags) &&
 			    (dev->toread ||
 			     (dev->towrite && !test_bit(R5_OVERWRITE, &dev->flags)) ||
-			     syncing ||
-			     expanding ||
-			     (failed >= 1 && (sh->dev[failed_num[0]].toread || to_write)) ||
-			     (failed >= 2 && (sh->dev[failed_num[1]].toread || to_write))
+			     s.syncing ||
+			     s.expanding ||
+			     (s.failed >= 1 && (sh->dev[s.r6_failed_num[0]].toread || s.to_write)) ||
+			     (s.failed >= 2 && (sh->dev[s.r6_failed_num[1]].toread || s.to_write))
 				    )
 				) {
 				/* we would like to get this block, possibly
 				 * by computing it, but we might not be able to
 				 */
-				if (uptodate == disks-1) {
+				if (s.uptodate == disks-1) {
 					PRINTK("Computing stripe %llu block %d\n",
 					       (unsigned long long)sh->sector, i);
 					compute_block_1(sh, i, 0);
-					uptodate++;
-				} else if ( uptodate == disks-2 && failed >= 2 ) {
+					s.uptodate++;
+				} else if ( s.uptodate == disks-2 && s.failed >= 2 ) {
 					/* Computing 2-failure is *very* expensive; only do it if failed >= 2 */
 					int other;
 					for (other=disks; other--;) {
@@ -2796,13 +2800,13 @@ static void handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
 					PRINTK("Computing stripe %llu blocks %d,%d\n",
 					       (unsigned long long)sh->sector, i, other);
 					compute_block_2(sh, i, other);
-					uptodate += 2;
+					s.uptodate += 2;
 				} else if (test_bit(R5_Insync, &dev->flags)) {
 					set_bit(R5_LOCKED, &dev->flags);
 					set_bit(R5_Wantread, &dev->flags);
-					locked++;
+					s.locked++;
 					PRINTK("Reading block %d (sync=%d)\n",
-						i, syncing);
+						i, s.syncing);
 				}
 			}
 		}
@@ -2810,7 +2814,7 @@ static void handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
 	}
 
 	/* now to consider writing and what else, if anything should be read */
-	if (to_write) {
+	if (s.to_write) {
 		int rcw=0, must_compute=0;
 		for (i=disks ; i--;) {
 			dev = &sh->dev[i];
@@ -2836,7 +2840,7 @@ static void handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
 			for (i=disks; i--;) {
 				dev = &sh->dev[i];
 				if (!test_bit(R5_OVERWRITE, &dev->flags)
-				    && !(failed == 0 && (i == pd_idx || i == qd_idx))
+				    && !(s.failed == 0 && (i == pd_idx || i == qd_idx))
 				    && !test_bit(R5_LOCKED, &dev->flags) && !test_bit(R5_UPTODATE, &dev->flags) &&
 				    test_bit(R5_Insync, &dev->flags)) {
 					if (test_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
@@ -2845,7 +2849,7 @@ static void handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
 						       (unsigned long long)sh->sector, i);
 						set_bit(R5_LOCKED, &dev->flags);
 						set_bit(R5_Wantread, &dev->flags);
-						locked++;
+						s.locked++;
 					} else {
 						PRINTK("Request delayed stripe %llu block %d for Reconstruct\n",
 						       (unsigned long long)sh->sector, i);
@@ -2855,14 +2859,14 @@ static void handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
 				}
 			}
 		/* now if nothing is locked, and if we have enough data, we can start a write request */
-		if (locked == 0 && rcw == 0 &&
+		if (s.locked == 0 && rcw == 0 &&
 		    !test_bit(STRIPE_BIT_DELAY, &sh->state)) {
 			if ( must_compute > 0 ) {
 				/* We have failed blocks and need to compute them */
-				switch ( failed ) {
+				switch ( s.failed ) {
 				case 0:	BUG();
-				case 1: compute_block_1(sh, failed_num[0], 0); break;
-				case 2: compute_block_2(sh, failed_num[0], failed_num[1]); break;
+				case 1: compute_block_1(sh, s.r6_failed_num[0], 0); break;
+				case 2: compute_block_2(sh, s.r6_failed_num[0], s.r6_failed_num[1]); break;
 				default: BUG();	/* This request should have been failed? */
 				}
 			}
@@ -2874,7 +2878,7 @@ static void handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
 				if (test_bit(R5_LOCKED, &sh->dev[i].flags)) {
 					PRINTK("Writing stripe %llu block %d\n",
 					       (unsigned long long)sh->sector, i);
-					locked++;
+					s.locked++;
 					set_bit(R5_Wantwrite, &sh->dev[i].flags);
 				}
 			/* after a RECONSTRUCT_WRITE, the stripe MUST be in-sync */
@@ -2892,14 +2896,14 @@ static void handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
 	 * Any reads will already have been scheduled, so we just see if enough data
 	 * is available
 	 */
-	if (syncing && locked == 0 && !test_bit(STRIPE_INSYNC, &sh->state)) {
+	if (s.syncing && s.locked == 0 && !test_bit(STRIPE_INSYNC, &sh->state)) {
 		int update_p = 0, update_q = 0;
 		struct r5dev *dev;
 
 		set_bit(STRIPE_HANDLE, &sh->state);
 
-		BUG_ON(failed>2);
-		BUG_ON(uptodate < disks);
+		BUG_ON(s.failed>2);
+		BUG_ON(s.uptodate < disks);
 		/* Want to check and possibly repair P and Q.
 		 * However there could be one 'failed' device, in which
 		 * case we can only check one of them, possibly using the
@@ -2911,7 +2915,7 @@ static void handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
 		 * by stripe_handle with a tmp_page - just wait until then.
 		 */
 		if (tmp_page) {
-			if (failed == q_failed) {
+			if (s.failed == q_failed) {
 				/* The only possible failed device holds 'Q', so it makes
 				 * sense to check P (If anything else were failed, we would
 				 * have used P to recreate it).
@@ -2922,7 +2926,7 @@ static void handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
 					update_p = 1;
 				}
 			}
-			if (!q_failed && failed < 2) {
+			if (!q_failed && s.failed < 2) {
 				/* q is not failed, and we didn't use it to generate
 				 * anything, so it makes sense to check it
 				 */
@@ -2948,28 +2952,28 @@ static void handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
 			 * or P or Q if they need it
 			 */
 
-			if (failed == 2) {
-				dev = &sh->dev[failed_num[1]];
-				locked++;
+			if (s.failed == 2) {
+				dev = &sh->dev[s.r6_failed_num[1]];
+				s.locked++;
 				set_bit(R5_LOCKED, &dev->flags);
 				set_bit(R5_Wantwrite, &dev->flags);
 			}
-			if (failed >= 1) {
-				dev = &sh->dev[failed_num[0]];
-				locked++;
+			if (s.failed >= 1) {
+				dev = &sh->dev[s.r6_failed_num[0]];
+				s.locked++;
 				set_bit(R5_LOCKED, &dev->flags);
 				set_bit(R5_Wantwrite, &dev->flags);
 			}
 
 			if (update_p) {
 				dev = &sh->dev[pd_idx];
-				locked ++;
+				s.locked ++;
 				set_bit(R5_LOCKED, &dev->flags);
 				set_bit(R5_Wantwrite, &dev->flags);
 			}
 			if (update_q) {
 				dev = &sh->dev[qd_idx];
-				locked++;
+				s.locked++;
 				set_bit(R5_LOCKED, &dev->flags);
 				set_bit(R5_Wantwrite, &dev->flags);
 			}
@@ -2979,7 +2983,7 @@ static void handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
 		}
 	}
 
-	if (syncing && locked == 0 && test_bit(STRIPE_INSYNC, &sh->state)) {
+	if (s.syncing && s.locked == 0 && test_bit(STRIPE_INSYNC, &sh->state)) {
 		md_done_sync(conf->mddev, STRIPE_SECTORS,1);
 		clear_bit(STRIPE_SYNCING, &sh->state);
 	}
@@ -2987,9 +2991,9 @@ static void handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
 	/* If the failed drives are just a ReadError, then we might need
 	 * to progress the repair/check process
 	 */
-	if (failed <= 2 && ! conf->mddev->ro)
-		for (i=0; i<failed;i++) {
-			dev = &sh->dev[failed_num[i]];
+	if (s.failed <= 2 && ! conf->mddev->ro)
+		for (i=0; i<s.failed;i++) {
+			dev = &sh->dev[s.r6_failed_num[i]];
 			if (test_bit(R5_ReadError, &dev->flags)
 			    && !test_bit(R5_LOCKED, &dev->flags)
 			    && test_bit(R5_UPTODATE, &dev->flags)
@@ -3006,7 +3010,7 @@ static void handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
 			}
 		}
 
-	if (expanded && test_bit(STRIPE_EXPANDING, &sh->state)) {
+	if (s.expanded && test_bit(STRIPE_EXPANDING, &sh->state)) {
 		/* Need to write out all blocks after computing P&Q */
 		sh->disks = conf->raid_disks;
 		sh->pd_idx = stripe_to_pdidx(sh->sector, conf,
@@ -3014,18 +3018,18 @@ static void handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
 		compute_parity6(sh, RECONSTRUCT_WRITE);
 		for (i = conf->raid_disks ; i-- ;  ) {
 			set_bit(R5_LOCKED, &sh->dev[i].flags);
-			locked++;
+			s.locked++;
 			set_bit(R5_Wantwrite, &sh->dev[i].flags);
 		}
 		clear_bit(STRIPE_EXPANDING, &sh->state);
-	} else if (expanded) {
+	} else if (s.expanded) {
 		clear_bit(STRIPE_EXPAND_READY, &sh->state);
 		atomic_dec(&conf->reshape_stripes);
 		wake_up(&conf->wait_for_overlap);
 		md_done_sync(conf->mddev, STRIPE_SECTORS, 1);
 	}
 
-	if (expanding && locked == 0) {
+	if (s.expanding && s.locked == 0) {
 		/* We have read all the blocks in this stripe and now we need to
 		 * copy some of them into a target stripe for expand.
 		 */
@@ -3118,7 +3122,7 @@ static void handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
 		rcu_read_unlock();
 
 		if (rdev) {
-			if (syncing || expanding || expanded)
+			if (s.syncing || s.expanding || s.expanded)
 				md_sync_acct(rdev->bdev, STRIPE_SECTORS);
 
 			bi->bi_bdev = rdev->bdev;
diff --git a/include/linux/raid/raid5.h b/include/linux/raid/raid5.h
index 3541d2c..54e2aa2 100644
--- a/include/linux/raid/raid5.h
+++ b/include/linux/raid/raid5.h
@@ -182,6 +182,17 @@ struct stripe_head {
 		unsigned long	flags;
 	} dev[1]; /* allocated with extra space depending of RAID geometry */
 };
+
+struct stripe_head_state {
+	int syncing, expanding, expanded;
+	int locked, uptodate, to_read, to_write, failed, written;
+	int to_fill, compute, req_compute, non_overwrite, dirty;
+	union {
+		int failed_num;
+		int r6_failed_num[2];
+	};
+};
+
 /* Flags */
 #define	R5_UPTODATE	0	/* page contains current data */
 #define	R5_LOCKED	1	/* IO has been submitted on "req" */
