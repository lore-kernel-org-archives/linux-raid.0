From: Yuri Tikhonov <yur@emcraft.com>
Subject: [md-raid6-accel PATCH 06/12] md: req/comp logic for async compute operations
Date: Tue, 4 Dec 2007 14:33:16 +0300
Message-ID: <200712041433.17139.yur@emcraft.com>
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

 Scheduling and processing the asynchronous computations. 

 handle_stripe will compute a block when a backing disk has failed. Since both
RAID-5/6 use the same ops_complete_compute() we should set the second
computation target in RAID-5 to (-1) [no target].

 Signed-off-by: Yuri Tikhonov <yur@emcraft.com>
 Signed-off-by: Mikhail Cherkashin <mike@emcraft.com>
--
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 3e8f896..f0f8d7f 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2770,6 +2770,7 @@ static int __handle_issuing_new_read_requests5(struct stripe_head *sh,
 			set_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.pending);
 			set_bit(R5_Wantcompute, &dev->flags);
 			sh->ops.target = disk_idx;
+			sh->ops.target2 = -1; /* no second target */
 			s->req_compute = 1;
 			sh->ops.count++;
 			/* Careful: from this point on 'uptodate' is in the eye
@@ -2830,63 +2831,138 @@ static void handle_issuing_new_read_requests5(struct stripe_head *sh,
 	set_bit(STRIPE_HANDLE, &sh->state);
 }
 
-static void handle_issuing_new_read_requests6(struct stripe_head *sh,
+/* __handle_issuing_new_read_requests6 - returns 0 if there are no more disks
+ * to process
+ */
+static int __handle_issuing_new_read_requests6(struct stripe_head *sh,
 			struct stripe_head_state *s, struct r6_state *r6s,
-			int disks)
+			int disk_idx, int disks)
 {
-	int i;
 	struct stripe_queue *sq = sh->sq;
+	struct r5dev *dev = &sh->dev[disk_idx];
+	struct r5_queue_dev *dev_q = &sq->dev[disk_idx];
+	struct r5dev *failed_dev[2] = { &sh->dev[r6s->failed_num[0]],
+					&sh->dev[r6s->failed_num[1]]};
+	struct r5_queue_dev *failed_dev_q[2] = { &sq->dev[r6s->failed_num[0]],
+						 &sq->dev[r6s->failed_num[1]]};
 
-	for (i = disks; i--; ) {
-		struct r5dev *dev = &sh->dev[i];
-		struct r5_queue_dev *dev_q = &sq->dev[i];
+	/* don't schedule compute operations or reads on
+	 * the parity blocks while a check is in flight
+	 */
+	if ((disk_idx == sq->pd_idx || disk_idx == r6s->qd_idx) &&
+	    test_bit(STRIPE_OP_CHECK, &sh->ops.pending))
+		return ~0;
 
-		if (!test_bit(R5_LOCKED, &dev->flags) &&
-		    !test_bit(R5_UPTODATE, &dev->flags) &&
-		    (dev_q->toread || (dev_q->towrite &&
-		     !test_bit(R5_OVERWRITE, &dev->flags)) ||
-		     s->syncing || s->expanding ||
-		     (s->failed >= 1 &&
-		      (sq->dev[r6s->failed_num[0]].toread ||
-		       s->to_write)) ||
-		     (s->failed >= 2 &&
-		      (sq->dev[r6s->failed_num[1]].toread ||
-		       s->to_write)))) {
-			/* we would like to get this block, possibly
-			 * by computing it, but we might not be able to
+	/* is the data in this block needed, and can we get it? */
+	if (!test_bit(R5_LOCKED, &dev->flags) &&
+	    !test_bit(R5_UPTODATE, &dev->flags) && (dev_q->toread ||
+	    (dev_q->towrite && !test_bit(R5_OVERWRITE, &dev->flags)) ||
+	     s->syncing || s->expanding ||
+	     (s->failed >= 1 && (failed_dev_q[0]->toread ||
+	      (failed_dev_q[0]->towrite &&
+	      !test_bit(R5_OVERWRITE,&failed_dev[0]->flags)))) ||
+	     (s->failed >= 2 && (failed_dev_q[1]->toread ||
+	      (failed_dev_q[1]->towrite &&
+	      !test_bit(R5_OVERWRITE,&failed_dev[1]->flags))))
+             )) {
+		/* 1/ We would like to get this block, possibly
+		 * by computing it, but we might not be able to.
+		 *
+		 * 2/ Since parity check operations potentially
+		 * make the parity block !uptodate it will need
+		 * to be refreshed before any compute operations
+		 * on data disks are scheduled.
+		 *
+		 * 3/ We hold off parity blocks re-reads until check
+		 * operations have quiesced.
+		 */
+		if ((s->uptodate == disks-1) &&
+		    !test_bit(STRIPE_OP_CHECK, &sh->ops.pending)) {
+			pr_debug("Computing stripe %llu block %d\n",
+				 (unsigned long long)sh->sector, disk_idx);
+			set_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.pending);
+			set_bit(R5_Wantcompute, &dev->flags);
+			sh->ops.target = disk_idx;
+			sh->ops.target2 = -1; /* no second target */
+			s->req_compute = 1;
+			sh->ops.count++;
+			/* Careful: from this point on 'uptodate' is in the eye of
+			 * raid_run_ops which services 'compute' operations before
+			 * writes. R5_Wantcompute flags a block that will be R5_UPTODATE
+			 * by the time it is needed for a  subsequent operation.
 			 */
-			if (s->uptodate == disks-1) {
-				pr_debug("Computing stripe %llu block %d\n",
-				       (unsigned long long)sh->sector, i);
-				compute_block_1(sh, i, 0);
-				s->uptodate++;
-			} else if ( s->uptodate == disks-2 && s->failed >= 2 ) {
-				/* Computing 2-failure is *very* expensive; only
-				 * do it if failed >= 2
-				 */
-				int other;
-				for (other = disks; other--; ) {
-					if (other == i)
-						continue;
-					if (!test_bit(R5_UPTODATE,
-					      &sh->dev[other].flags))
-						break;
-				}
-				BUG_ON(other < 0);
-				pr_debug("Computing stripe %llu blocks %d,%d\n",
-				       (unsigned long long)sh->sector,
-				       i, other);
-				compute_block_2(sh, i, other);
-				s->uptodate += 2;
-			} else if (test_bit(R5_Insync, &dev->flags)) {
-				set_bit(R5_LOCKED, &dev->flags);
-				set_bit(R5_Wantread, &dev->flags);
-				s->locked++;
-				pr_debug("Reading block %d (sync=%d)\n",
-					i, s->syncing);
+			s->uptodate++;
+			return 0; /* s->uptodate + s->compute == disks */
+		} else if ( s->uptodate == disks-2 && s->failed >= 2 ) {
+			/* Computing 2-failure is *very* expensive; only
+			 * do it if failed >= 2
+			 */
+			int other;
+			for (other = disks; other--; ) {
+				if (other == disk_idx)
+					continue;
+				if (!test_bit(R5_UPTODATE, &sh->dev[other].flags))
+					break;
 			}
+			BUG_ON(other < 0);
+			pr_debug("Computing stripe %llu blocks %d,%d\n",
+				 (unsigned long long)sh->sector,
+				 disk_idx, other);
+			set_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.pending);
+			set_bit(R5_Wantcompute, &dev->flags);
+			set_bit(R5_Wantcompute, &sh->dev[other].flags);
+			sh->ops.target = disk_idx;
+			sh->ops.target2 = other;
+			s->req_compute = 1;
+			sh->ops.count++;
+			s->uptodate += 2;
+		} else if ((s->uptodate < disks-2) &&
+			    test_bit(R5_Insync, &dev->flags)) {
+			/* Note: we hold off compute operations while checks
+			 * are in flight, but we still prefer 'compute' over 'read'
+			 * hence we only read if (uptodate < disks-1) FIXME
+			 */
+			set_bit(R5_LOCKED, &dev->flags);
+			set_bit(R5_Wantread, &dev->flags);
+			if (!test_and_set_bit(STRIPE_OP_IO, &sh->ops.pending))
+				sh->ops.count++;
+			s->locked++;
+			pr_debug("Reading block %d (sync=%d)\n", disk_idx,
+				s->syncing);
 		}
 	}
+
+	return ~0;
+}
+
+static void handle_issuing_new_read_requests6(struct stripe_head *sh,
+			struct stripe_head_state *s, struct r6_state *r6s,
+			int disks)
+{
+	int i;
+
+	/* Clear completed compute operations.  Parity recovery
+	 * (STRIPE_OP_MOD_REPAIR_PD) implies a write-back which is handled
+	 * later on in this routine
+	 */
+	if (test_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.complete) &&
+		!test_bit(STRIPE_OP_MOD_REPAIR_PD, &sh->ops.pending)) {
+		clear_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.complete);
+		clear_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.ack);
+		clear_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.pending);
+	}
+
+	/* look for blocks to read/compute, skip this if a compute
+	 * is already in flight, or if the stripe contents are in the
+	 * midst of changing due to a write
+	 */
+	if (!test_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.pending) &&
+	    !test_bit(STRIPE_OP_POSTXOR, &sh->ops.pending)) {
+		for (i = disks; i--;)
+			if (!__handle_issuing_new_read_requests6(sh, s, r6s,
+			    i, disks))
+				break;
+	}
 	set_bit(STRIPE_HANDLE, &sh->state);
 }
 
@@ -3079,11 +3155,11 @@ static void handle_issuing_new_write_requests6(raid5_conf_t *conf,
 	for (i = disks; i--; ) {
 		struct r5dev *dev = &sh->dev[i];
 		/* Would I have to read this buffer for reconstruct_write */
-		if (!test_bit(R5_OVERWRITE, &dev->flags)
-		    && i != pd_idx && i != qd_idx
-		    && (!test_bit(R5_LOCKED, &dev->flags)
-			    ) &&
-		    !test_bit(R5_UPTODATE, &dev->flags)) {
+		if (!test_bit(R5_OVERWRITE, &dev->flags) &&
+		    i != pd_idx && i != qd_idx &&
+		    !test_bit(R5_LOCKED, &dev->flags) &&
+		    !test_bit(R5_UPTODATE, &dev->flags) &&
+		    !test_bit(R5_Wantcompute, &dev->flags)) {
 			if (test_bit(R5_Insync, &dev->flags)) rcw++;
 			else {
 				pr_debug("raid6: must_compute: "
@@ -3100,18 +3176,19 @@ static void handle_issuing_new_write_requests6(raid5_conf_t *conf,
 		/* want reconstruct write, but need to get some data */
 		for (i = disks; i--; ) {
 			struct r5dev *dev = &sh->dev[i];
-			if (!test_bit(R5_OVERWRITE, &dev->flags)
-			    && !(s->failed == 0 && (i == pd_idx || i == qd_idx))
-			    && !test_bit(R5_LOCKED, &dev->flags) &&
+			if (!(!test_bit(R5_OVERWRITE, &dev->flags) &&
+			    !(s->failed == 0 && (i == pd_idx || i == qd_idx)) &&
+			    !test_bit(R5_LOCKED, &dev->flags) &&
 			    !test_bit(R5_UPTODATE, &dev->flags) &&
-			    test_bit(R5_Insync, &dev->flags)) {
-				pr_debug("Read_old stripe %llu "
-					"block %d for Reconstruct\n",
-				     (unsigned long long)sh->sector, i);
-				set_bit(R5_LOCKED, &dev->flags);
-				set_bit(R5_Wantread, &dev->flags);
-				s->locked++;
-			}
+			    !test_bit(R5_Wantcompute, &dev->flags) &&
+			    test_bit(R5_Insync, &dev->flags)))
+				continue;
+			pr_debug("Read_old stripe %llu "
+				 "block %d for Reconstruct\n",
+				 (unsigned long long)sh->sector, i);
+			set_bit(R5_LOCKED, &dev->flags);
+			set_bit(R5_Wantread, &dev->flags);
+			s->locked++;
 		}
 	/* now if nothing is locked, and if we have enough data, we can start a
 	 * write request
@@ -3131,13 +3208,26 @@ static void handle_issuing_new_write_requests6(raid5_conf_t *conf,
 			case 0:
 				BUG();
 			case 1:
-				compute_block_1(sh, r6s->failed_num[0], 0);
+				set_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.pending);
+				set_bit(R5_Wantcompute,
+					&sh->dev[r6s->failed_num[0]].flags);
+				sh->ops.target = r6s->failed_num[0];
+				sh->ops.target2 = -1; /* no second target */
+				s->req_compute = 1;
+				sh->ops.count++;
 				break;
 			case 2:
-				compute_block_2(sh, r6s->failed_num[0],
-						r6s->failed_num[1]);
+				set_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.pending);
+				set_bit(R5_Wantcompute,
+					&sh->dev[r6s->failed_num[0]].flags);
+				set_bit(R5_Wantcompute,
+					&sh->dev[r6s->failed_num[1]].flags);
+				sh->ops.target = r6s->failed_num[0];
+				sh->ops.target2 = r6s->failed_num[1];
+				s->req_compute = 1;
+				sh->ops.count++;
 				break;
-			default: /* This request should have been failed? */
+			default:
 				BUG();
 			}
 		}
@@ -3737,6 +3827,8 @@ static void handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
 		if (test_bit(R5_LOCKED, &dev->flags)) s.locked++;
 		if (test_bit(R5_UPTODATE, &dev->flags)) s.uptodate++;
 
+		if (test_bit(R5_Wantcompute, &dev->flags))
+			BUG_ON(++s.compute > 2);
 
 		if (dev_q->toread)
 			s.to_read++;
@@ -3803,7 +3895,8 @@ static void handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
 	 * or to load a block that is being partially written.
 	 */
 	if (s.to_read || s.non_overwrite || (s.to_write && s.failed) ||
-	    (s.syncing && (s.uptodate < disks)) || s.expanding)
+	    (s.syncing && (s.uptodate + s.compute < disks)) || s.expanding ||
+	    test_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.pending))
 		handle_issuing_new_read_requests6(sh, &s, &r6s, disks);
 
 	/* Now we check to see if any write operations have recently

-- 
Yuri Tikhonov, Senior Software Engineer
Emcraft Systems, www.emcraft.com
