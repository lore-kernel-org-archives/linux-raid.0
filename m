From: Yuri Tikhonov <yur@emcraft.com>
Subject: [md-raid6-accel PATCH 05/12] md: req/comp logic for async write operations
Date: Tue, 4 Dec 2007 14:32:05 +0300
Message-ID: <200712041432.05574.yur@emcraft.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: Neil Brown <neilb@suse.de>, Wolfgang Denk <wd@denx.de>, Detlev Zundel <dzu@denx.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

 The RAID-6 driver shares handle_write_operations() with RAID-5. For this
purpose, some modifications to handle_write_operations5() had been made. The
function itself was renamed as well. The handle_write_operations() is being
triggered either from handle_stripe6() or handle_stripe5().

 This patch introduces one more RAID-5/6 shared function, it is
handle_completed_postxor_requests(), to be called when either handle_stripe5()
or handle_stripe6() discover the completeness of a post-xor operation for the
stripe.

 Signed-off-by: Yuri Tikhonov <yur@emcraft.com>
 Signed-off-by: Mikhail Cherkashin <mike@emcraft.com>
--
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 2c6fee0..3e8f896 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2447,11 +2447,12 @@ static void compute_block_2(struct stripe_head *sh, int dd_idx1, int dd_idx2)
 }
 
 static int
-handle_write_operations5(struct stripe_head *sh, int rcw, int expand)
+handle_write_operations(struct stripe_head *sh, int rcw, int expand)
 {
 	int locked = 0;
 	struct stripe_queue *sq = sh->sq;
 	int i, pd_idx = sq->pd_idx, disks = sq->disks;
+	int level = sq->raid_conf->level;
 
 	if (rcw) {
 		/* if we are not expanding this is a proper write request, and
@@ -2478,6 +2479,7 @@ handle_write_operations5(struct stripe_head *sh, int rcw, int expand)
 			}
 		}
 	} else {
+		BUG_ON(level == 6);
 		BUG_ON(!(test_bit(R5_UPTODATE, &sh->dev[pd_idx].flags) ||
 			test_bit(R5_Wantcompute, &sh->dev[pd_idx].flags)));
 
@@ -2510,13 +2512,20 @@ handle_write_operations5(struct stripe_head *sh, int rcw, int expand)
 		}
 	}
 
-	/* keep the parity disk locked while asynchronous operations
+	/* keep the parity disks locked while asynchronous operations
 	 * are in flight
 	 */
 	set_bit(R5_LOCKED, &sh->dev[pd_idx].flags);
 	clear_bit(R5_UPTODATE, &sh->dev[pd_idx].flags);
 	locked++;
 
+	if (level == 6) {
+		int qd_idx = raid6_next_disk(pd_idx, disks);
+		set_bit(R5_LOCKED, &sh->dev[qd_idx].flags);
+		clear_bit(R5_UPTODATE, &sh->dev[qd_idx].flags);
+		locked++;
+	}
+
 	pr_debug("%s: stripe %llu locked: %d pending: %lx\n",
 		__FUNCTION__, (unsigned long long)sh->sector,
 		locked, sh->ops.pending);
@@ -2881,6 +2890,47 @@ static void handle_issuing_new_read_requests6(struct stripe_head *sh,
 	set_bit(STRIPE_HANDLE, &sh->state);
 }
 
+static void handle_completed_postxor_requests(struct stripe_head *sh,
+	struct stripe_head_state *s, int disks)
+{
+	struct stripe_queue *sq = sh->sq;
+	int i, pd_idx = sq->pd_idx;
+	int qd_idx = (sq->raid_conf->level != 6) ? -1 :
+		raid6_next_disk(pd_idx, disks);
+	struct r5dev *dev;
+
+	clear_bit(STRIPE_OP_BIODRAIN, &sh->ops.complete);
+	clear_bit(STRIPE_OP_BIODRAIN, &sh->ops.ack);
+	clear_bit(STRIPE_OP_BIODRAIN, &sh->ops.pending);
+
+	clear_bit(STRIPE_OP_POSTXOR, &sh->ops.complete);
+	clear_bit(STRIPE_OP_POSTXOR, &sh->ops.ack);
+	clear_bit(STRIPE_OP_POSTXOR, &sh->ops.pending);
+
+	/* All the 'written' buffers and the parity block are ready to be
+	 * written back to disk
+	 */
+	BUG_ON(!test_bit(R5_UPTODATE, &sh->dev[pd_idx].flags));
+	if (!(qd_idx < 0))
+		BUG_ON(!test_bit(R5_UPTODATE, &sh->dev[qd_idx].flags));
+
+	for (i = disks; i--;) {
+		struct r5_queue_dev *dev_q = &sq->dev[i];
+
+		dev = &sh->dev[i];
+		if (test_bit(R5_LOCKED, &dev->flags) &&
+		    (i == pd_idx || i == qd_idx || dev_q->written)) {
+			pr_debug("Writing block %d\n", i);
+			set_bit(R5_Wantwrite, &dev->flags);
+			if (!test_and_set_bit(STRIPE_OP_IO, &sh->ops.pending))
+				sh->ops.count++;
+			if (!test_bit(R5_Insync, &dev->flags) ||
+			    ((i == pd_idx || i == qd_idx) &&
+			    s->failed == 0))
+				set_bit(STRIPE_INSYNC, &sh->state);
+		}
+	}
+}
 
 /* handle_completed_write_requests
  * any written block on an uptodate or failed drive can be returned.
@@ -3016,7 +3066,7 @@ static void handle_issuing_new_write_requests5(raid5_conf_t *conf,
 	if ((s->req_compute ||
 	    !test_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.pending)) &&
 		(s->locked == 0 && (rcw == 0 || rmw == 0)))
-		s->locked += handle_write_operations5(sh, rcw == 0, 0);
+		s->locked += handle_write_operations(sh, rcw == 0, 0);
 }
 
 static void handle_issuing_new_write_requests6(raid5_conf_t *conf,
@@ -3066,6 +3116,14 @@ static void handle_issuing_new_write_requests6(raid5_conf_t *conf,
 	/* now if nothing is locked, and if we have enough data, we can start a
 	 * write request
 	 */
+	/* since handle_stripe can be called at any time we need to handle the case
+	 * where a compute block operation has been submitted and then a subsequent
+	 * call wants to start a write request.  raid_run_ops only handles the case where
+	 * compute block and postxor are requested simultaneously.  If this
+	 * is not the case then new writes need to be held off until the compute
+	 * completes.
+	 */
+
 	if (s->locked == 0 && rcw == 0) {
 		if (must_compute > 0) {
 			/* We have failed blocks and need to compute them */
@@ -3084,19 +3142,9 @@ static void handle_issuing_new_write_requests6(raid5_conf_t *conf,
 			}
 		}
 
-		pr_debug("Computing parity for stripe %llu\n",
-			(unsigned long long)sh->sector);
-		compute_parity6(sh, RECONSTRUCT_WRITE);
-		/* now every locked buffer is ready to be written */
-		for (i = disks; i--; )
-			if (test_bit(R5_LOCKED, &sh->dev[i].flags)) {
-				pr_debug("Writing stripe %llu block %d\n",
-				       (unsigned long long)sh->sector, i);
-				s->locked++;
-				set_bit(R5_Wantwrite, &sh->dev[i].flags);
-			}
-		/* after a RECONSTRUCT_WRITE, the stripe MUST be in-sync */
-		set_bit(STRIPE_INSYNC, &sh->state);
+		if (s->req_compute ||
+		    !test_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.pending))
+			s->locked += handle_write_operations(sh, rcw == 0, 0);
 	}
 }
 
@@ -3514,37 +3562,8 @@ static void handle_stripe5(struct stripe_head *sh)
 
 	/* if only POSTXOR is set then this is an 'expand' postxor */
 	if (test_bit(STRIPE_OP_BIODRAIN, &sh->ops.complete) &&
-		test_bit(STRIPE_OP_POSTXOR, &sh->ops.complete)) {
-
-		clear_bit(STRIPE_OP_BIODRAIN, &sh->ops.complete);
-		clear_bit(STRIPE_OP_BIODRAIN, &sh->ops.ack);
-		clear_bit(STRIPE_OP_BIODRAIN, &sh->ops.pending);
-
-		clear_bit(STRIPE_OP_POSTXOR, &sh->ops.complete);
-		clear_bit(STRIPE_OP_POSTXOR, &sh->ops.ack);
-		clear_bit(STRIPE_OP_POSTXOR, &sh->ops.pending);
-
-		/* All the 'written' buffers and the parity block are ready to
-		 * be written back to disk
-		 */
-		BUG_ON(!test_bit(R5_UPTODATE, &sh->dev[sq->pd_idx].flags));
-		for (i = disks; i--; ) {
-			struct r5_queue_dev *dev_q = &sq->dev[i];
-
-			dev = &sh->dev[i];
-			if (test_bit(R5_LOCKED, &dev->flags) &&
-				(i == sq->pd_idx || dev_q->written)) {
-				pr_debug("Writing block %d\n", i);
-				set_bit(R5_Wantwrite, &dev->flags);
-				if (!test_and_set_bit(
-				    STRIPE_OP_IO, &sh->ops.pending))
-					sh->ops.count++;
-				if (!test_bit(R5_Insync, &dev->flags) ||
-				    (i == sq->pd_idx && s.failed == 0))
-					set_bit(STRIPE_INSYNC, &sh->state);
-			}
-		}
-	}
+	    test_bit(STRIPE_OP_POSTXOR, &sh->ops.complete))
+		handle_completed_postxor_requests(sh, &s, disks);
 
 	/* Now to consider new write requests and what else, if anything
 	 * should be read.  We do not handle new writes when:
@@ -3624,7 +3643,7 @@ static void handle_stripe5(struct stripe_head *sh)
 		sq->disks = conf->raid_disks;
 		sq->pd_idx = stripe_to_pdidx(sh->sector, conf,
 			conf->raid_disks);
-		s.locked += handle_write_operations5(sh, 1, 1);
+		s.locked += handle_write_operations(sh, 1, 1);
 	} else if (s.expanded &&
 		!test_bit(STRIPE_OP_POSTXOR, &sh->ops.pending)) {
 		clear_bit(STRIPE_EXPAND_READY, &sh->state);
@@ -3787,8 +3806,23 @@ static void handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
 	    (s.syncing && (s.uptodate < disks)) || s.expanding)
 		handle_issuing_new_read_requests6(sh, &s, &r6s, disks);
 
-	/* now to consider writing and what else, if anything should be read */
-	if (s.to_write)
+	/* Now we check to see if any write operations have recently
+	 * completed
+	 */
+
+	/* if only POSTXOR is set then this is an 'expand' postxor */
+	if (test_bit(STRIPE_OP_BIODRAIN, &sh->ops.complete) &&
+	    test_bit(STRIPE_OP_POSTXOR, &sh->ops.complete))
+		handle_completed_postxor_requests(sh, &s, disks);
+
+	/* 1/ Now to consider new write requests and what else,
+	 * if anything shuold be read
+	 * 2/ Check operations clobber the parity block so do not start
+	 * new writes while a check is in flight
+	 * 3/ Write operations do not stack
+	 */
+	if (s.to_write && !test_bit(STRIPE_OP_POSTXOR, &sh->ops.pending) &&
+	    !test_bit(STRIPE_OP_CHECK, &sh->ops.pending))
 		handle_issuing_new_write_requests6(conf, sh, &s, &r6s, disks);
 
 	/* maybe we need to check and possibly fix the parity for this stripe

-- 
Yuri Tikhonov, Senior Software Engineer
Emcraft Systems, www.emcraft.com
