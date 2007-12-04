From: Yuri Tikhonov <yur@emcraft.com>
Subject: [md-raid6-accel PATCH 03/12] md: run stripe operations outside the lock
Date: Tue, 4 Dec 2007 14:29:12 +0300
Message-ID: <200712041429.13285.yur@emcraft.com>
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

 The raid_run_ops routine uses the asynchronous offload api and
the stripe_operations member of a stripe_head to carry out xor+pqxor+copy
operations asynchronously, outside the lock.

 The operations performed by RAID-6 are the same as in the RAID-5 case
except for no support of STRIPE_OP_PREXOR operations. All the others
are supported:
STRIPE_OP_BIOFILL
 - copy data into request buffers to satisfy a read request
STRIPE_OP_COMPUTE_BLK
 - generate missing blocks (1 or 2) in the cache from the other blocks
STRIPE_OP_BIODRAIN
 - copy data out of request buffers to satisfy a write request
STRIPE_OP_POSTXOR
 - recalculate parity for new data that has entered the cache
STRIPE_OP_CHECK
 - verify that the parity is correct
STRIPE_OP_IO
 - submit i/o to the member disks (note this was already performed outside
   the stripe lock, but it made sense to add it as an operation type

 The flow is the same as in the RAID-5 case.

 Signed-off-by: Yuri Tikhonov <yur@emcraft.com>
 Signed-off-by: Mikhail Cherkashin <mike@emcraft.com>
--
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 9a4959a..af77291 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -894,18 +894,26 @@ static void ops_run_biofill(struct stripe_head *sh)
 		ops_complete_biofill, sh);
 }
 
-static void ops_complete_compute5(void *stripe_head_ref)
+static void ops_complete_compute(void *stripe_head_ref)
 {
 	struct stripe_head *sh = stripe_head_ref;
-	int target = sh->ops.target;
-	struct r5dev *tgt = &sh->dev[target];
+	int target, i;
+	struct r5dev *tgt;
 
 	pr_debug("%s: stripe %llu\n", __FUNCTION__,
 		(unsigned long long)sh->sector);
 
-	set_bit(R5_UPTODATE, &tgt->flags);
-	BUG_ON(!test_bit(R5_Wantcompute, &tgt->flags));
-	clear_bit(R5_Wantcompute, &tgt->flags);
+	/* mark the computed target(s) as uptodate */
+	for (i = 0; i < 2; i++) {
+		target = (!i) ? sh->ops.target : sh->ops.target2;
+		if (target < 0)
+			continue;
+		tgt = &sh->dev[target];
+		set_bit(R5_UPTODATE, &tgt->flags);
+		BUG_ON(!test_bit(R5_Wantcompute, &tgt->flags));
+		clear_bit(R5_Wantcompute, &tgt->flags);
+	}
+
 	set_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.complete);
 	set_bit(STRIPE_HANDLE, &sh->state);
 	release_stripe(sh);
@@ -936,11 +944,11 @@ ops_run_compute5(struct stripe_head *sh, unsigned long pending)
 
 	if (unlikely(count == 1))
 		tx = async_memcpy(xor_dest, xor_srcs[0], 0, 0, STRIPE_SIZE,
-			0, NULL, ops_complete_compute5, sh);
+			0, NULL, ops_complete_compute, sh);
 	else
 		tx = async_xor(xor_dest, xor_srcs, 0, count, STRIPE_SIZE,
 			ASYNC_TX_XOR_ZERO_DST, NULL,
-			ops_complete_compute5, sh);
+			ops_complete_compute, sh);
 
 	/* ack now if postxor is not set to be run */
 	if (tx && !test_bit(STRIPE_OP_POSTXOR, &pending))
@@ -949,6 +957,159 @@ ops_run_compute5(struct stripe_head *sh, unsigned long pending)
 	return tx;
 }
 
+static struct dma_async_tx_descriptor *
+ops_run_compute6_1(struct stripe_head *sh, unsigned long pending)
+{
+	/* kernel stack size limits the total number of disks */
+	int disks = sh->sq->disks;
+	int target = sh->ops.target < 0 ? sh->ops.target2 : sh->ops.target;
+	struct r5dev *tgt = &sh->dev[target];
+	struct page *dest = sh->dev[target].page;
+	struct page *srcs[disks];
+	int count = 0;
+	int pd_idx = sh->sq->pd_idx;
+	int qd_idx = raid6_next_disk(pd_idx, disks);
+	struct dma_async_tx_descriptor *tx;
+	int i;
+
+	pr_debug("%s: stripe %llu block: %d\n",
+		__FUNCTION__, (unsigned long long)sh->sector, target);
+	BUG_ON(!test_bit(R5_Wantcompute, &tgt->flags));
+
+	atomic_inc(&sh->count);
+
+	if (target == qd_idx) {
+		/* We are actually computing the Q drive*/
+		for (i = disks; i-- ; ) {
+			if (i != target && i != pd_idx && i != qd_idx)
+				srcs[count++] = sh->dev[i].page;
+		}
+		/* Synchronous calculations need two destination pages,
+		 * so use P-page too
+		 */
+		tx = async_pqxor(sh->dev[pd_idx].page, dest,
+			srcs, (char *)raid6_gfexp,
+			0, count, STRIPE_SIZE,
+			ASYNC_TX_XOR_ZERO_DST, NULL,
+			ops_complete_compute, sh);
+	} else {
+		/* Compute any data- or p-drive using XOR */
+		for (i = disks; i-- ; ) {
+			if (i != target && i != qd_idx)
+				srcs[count++] = sh->dev[i].page;
+		}
+
+		tx = async_xor(dest, srcs, 0, count, STRIPE_SIZE,
+			ASYNC_TX_XOR_ZERO_DST, NULL,
+			ops_complete_compute, sh);
+	}
+
+	/* ack now if postxor is not set to be run */
+	if (tx && !test_bit(STRIPE_OP_POSTXOR, &pending))
+		async_tx_ack(tx);
+
+	return tx;
+}
+
+static struct dma_async_tx_descriptor *
+ops_run_compute6_2(struct stripe_head *sh, unsigned long pending)
+{
+	/* kernel stack size limits the total number of disks */
+	int disks = sh->sq->disks;
+	int target = sh->ops.target;
+	int target2 = sh->ops.target2;
+	struct r5dev *tgt = &sh->dev[target];
+	struct r5dev *tgt2 = &sh->dev[target2];
+	struct page *srcs[disks];
+	int count = 0;
+	int pd_idx = sh->sq->pd_idx;
+	int qd_idx = raid6_next_disk(pd_idx, disks);
+	int d0_idx = raid6_next_disk(qd_idx, disks);
+	struct dma_async_tx_descriptor *tx;
+	int i, faila, failb;
+
+	/* faila and failb are disk numbers relative to d0_idx;
+	 * pd_idx become disks-2 and qd_idx become disks-1.
+	 */
+	faila = (target < d0_idx) ? target + (disks - d0_idx) :
+			target - d0_idx;
+	failb = (target2 < d0_idx) ? target2 + (disks - d0_idx) :
+			target2 - d0_idx;
+
+	BUG_ON(faila == failb);
+	if ( failb < faila ) {
+		int tmp = faila;
+		faila = failb;
+		failb = tmp;
+	}
+
+	pr_debug("%s: stripe %llu block1: %d block2: %d\n",
+		__FUNCTION__, (unsigned long long)sh->sector, target, target2);
+	BUG_ON(!test_bit(R5_Wantcompute, &tgt->flags));
+	BUG_ON(!test_bit(R5_Wantcompute, &tgt2->flags));
+
+	atomic_inc(&sh->count);
+
+	if ( failb == disks-1 ) {
+		/* Q disk is one of the missing disks */
+		i = d0_idx;
+		do {
+			if (i != target && i != target2) {
+				srcs[count++] = sh->dev[i].page;
+				if (!test_bit(R5_UPTODATE, &sh->dev[i].flags))
+					pr_debug("%s with missing block %d/%d\n",
+						__FUNCTION__, count, i);
+			}
+			i = raid6_next_disk(i, disks);
+		} while ( i != d0_idx );
+
+		if ( faila == disks - 2 ) {
+			/* Missing P+Q, just recompute */
+			tx = async_pqxor(sh->dev[pd_idx].page,
+			    sh->dev[qd_idx].page, srcs, (char *)raid6_gfexp,
+			    0, count, STRIPE_SIZE, ASYNC_TX_XOR_ZERO_DST, NULL,
+			    ops_complete_compute, sh);
+		} else {
+			/* Missing D+Q; recompute D from P */
+			tx = async_xor(sh->dev[qd_idx == target ? target2 :
+			    target].page, srcs, 0, count, STRIPE_SIZE,
+			    ASYNC_TX_XOR_ZERO_DST, NULL,
+			    ops_complete_compute, sh);
+			/* recompute Q then? */
+		}
+
+		/* ack now if postxor is not set to be run */
+		if (tx && !test_bit(STRIPE_OP_POSTXOR, &pending))
+			async_tx_ack(tx);
+		return tx;
+	}
+
+	/* We're missing D+P or D+D */
+	i = d0_idx;
+	do {
+		srcs[count++] = sh->dev[i].page;
+		i = raid6_next_disk(i, disks);
+		if (i != target && i != target2 &&
+		    !test_bit(R5_UPTODATE, &sh->dev[i].flags))
+			pr_debug("%s with missing block %d/%d\n", __FUNCTION__, count, i);
+	} while ( i != d0_idx );
+
+	if ( failb == disks - 2 ) {
+		/* We're missing D+P. */
+		tx = async_r6_dp_recov(disks, STRIPE_SIZE, faila, srcs,
+				0, NULL, ops_complete_compute, sh);
+	} else {
+		/* We're missing D+D. */
+		tx = async_r6_dd_recov(disks, STRIPE_SIZE, faila, failb, srcs,
+				0, NULL, ops_complete_compute, sh);
+	}
+
+	if (tx && !test_bit(STRIPE_OP_POSTXOR, &pending))
+		async_tx_ack(tx);
+
+	return tx;
+}
+
 static void ops_complete_prexor(void *stripe_head_ref)
 {
 	struct stripe_head *sh = stripe_head_ref;
@@ -1018,6 +1179,12 @@ ops_run_biodrain(struct stripe_head *sh, struct dma_async_tx_descriptor *tx,
 			    test_bit(R5_Wantprexor, &dev->flags))
 				towrite = 1;
 		} else { /* rcw */
+			if (sq->raid_conf->level == 6) {
+				if (i != raid6_next_disk(pd_idx, disks) &&
+				    i != pd_idx && dev_q->towrite &&
+				    test_bit(R5_LOCKED, &dev->flags))
+					towrite = 1;
+			} else
 			if (i != pd_idx && dev_q->towrite &&
 				test_bit(R5_LOCKED, &dev->flags))
 				towrite = 1;
@@ -1062,7 +1229,10 @@ static void ops_complete_write(void *stripe_head_ref)
 {
 	struct stripe_head *sh = stripe_head_ref;
 	struct stripe_queue *sq = sh->sq;
-	int disks = sq->disks, i, pd_idx = sq->pd_idx;
+	int disks = sq->disks, i;
+	int pd_idx = sq->pd_idx;
+	int qd_idx = (sq->raid_conf->level != 6) ? -1 :
+		raid6_next_disk(pd_idx, disks);
 
 	pr_debug("%s: stripe %llu\n", __FUNCTION__,
 		(unsigned long long)sh->sector);
@@ -1071,7 +1241,7 @@ static void ops_complete_write(void *stripe_head_ref)
 		struct r5dev *dev = &sh->dev[i];
 		struct r5_queue_dev *dev_q = &sq->dev[i];
 
-		if (dev_q->written || i == pd_idx)
+		if (dev_q->written || i == pd_idx || i == qd_idx)
 			set_bit(R5_UPTODATE, &dev->flags);
 	}
 
@@ -1093,8 +1263,11 @@ ops_run_postxor(struct stripe_head *sh, struct dma_async_tx_descriptor *tx,
 
 	int count = 0;
 	int pd_idx = sq->pd_idx;
+	int qd_idx = (sq->raid_conf->level != 6) ? -1 :
+		raid6_next_disk(pd_idx, disks);
 	int i;
 	struct page *xor_dest;
+	struct page *q_dest = NULL;
 	int prexor = test_bit(STRIPE_OP_PREXOR, &pending);
 	unsigned long flags;
 	dma_async_tx_callback callback;
@@ -1107,6 +1280,7 @@ ops_run_postxor(struct stripe_head *sh, struct dma_async_tx_descriptor *tx,
 	 */
 	if (prexor) {
 		xor_dest = xor_srcs[count++] = sh->dev[pd_idx].page;
+		BUG_ON(!(qd_idx < 0));
 		for (i = disks; i--; ) {
 			struct r5dev *dev = &sh->dev[i];
 			struct r5_queue_dev *dev_q = &sq->dev[i];
@@ -1116,9 +1290,10 @@ ops_run_postxor(struct stripe_head *sh, struct dma_async_tx_descriptor *tx,
 		}
 	} else {
 		xor_dest = sh->dev[pd_idx].page;
+		q_dest = (qd_idx < 0) ? NULL : sh->dev[qd_idx].page;
 		for (i = disks; i--; ) {
 			struct r5dev *dev = &sh->dev[i];
-			if (i != pd_idx)
+			if (i != pd_idx && i != qd_idx)
 				xor_srcs[count++] = dev->page;
 		}
 	}
@@ -1138,32 +1313,44 @@ ops_run_postxor(struct stripe_head *sh, struct dma_async_tx_descriptor *tx,
 	atomic_inc(&sh->count);
 
 	if (unlikely(count == 1)) {
+		BUG_ON(!(qd_idx < 0));
 		flags &= ~(ASYNC_TX_XOR_DROP_DST | ASYNC_TX_XOR_ZERO_DST);
 		tx = async_memcpy(xor_dest, xor_srcs[0], 0, 0, STRIPE_SIZE,
 			flags, tx, callback, sh);
-	} else
-		tx = async_xor(xor_dest, xor_srcs, 0, count, STRIPE_SIZE,
-			flags, tx, callback, sh);
+	} else {
+		if (qd_idx < 0)
+			tx = async_xor(xor_dest, xor_srcs, 0, count,
+				STRIPE_SIZE, flags, tx, callback, sh);
+		else
+			tx = async_pqxor(xor_dest, q_dest, xor_srcs,
+				(char *)raid6_gfexp, 0, count, STRIPE_SIZE,
+				flags, tx, callback, sh);
+	}
 }
 
 static void ops_complete_check(void *stripe_head_ref)
 {
 	struct stripe_head *sh = stripe_head_ref;
 	int pd_idx = sh->sq->pd_idx;
+	int qd_idx = (sh->sq->raid_conf->level != 6) ? -1 :
+		raid6_next_disk(pd_idx, sh->sq->disks);
 
 	pr_debug("%s: stripe %llu\n", __FUNCTION__,
 		(unsigned long long)sh->sector);
 
-	if (test_and_clear_bit(STRIPE_OP_MOD_DMA_CHECK, &sh->ops.pending) &&
-		sh->ops.zero_sum_result == 0)
-		set_bit(R5_UPTODATE, &sh->dev[pd_idx].flags);
+	if (test_and_clear_bit(STRIPE_OP_MOD_DMA_CHECK, &sh->ops.pending)) {
+		if (sh->ops.zero_sum_result == 0)
+			set_bit(R5_UPTODATE, &sh->dev[pd_idx].flags);
+		if (!(qd_idx < 0) && sh->ops.zero_qsum_result == 0)
+			set_bit(R5_UPTODATE, &sh->dev[qd_idx].flags);
+	}
 
 	set_bit(STRIPE_OP_CHECK, &sh->ops.complete);
 	set_bit(STRIPE_HANDLE, &sh->state);
 	release_stripe(sh);
 }
 
-static void ops_run_check(struct stripe_head *sh)
+static void ops_run_check5(struct stripe_head *sh)
 {
 	/* kernel stack size limits the total number of disks */
 	struct stripe_queue *sq = sh->sq;
@@ -1198,12 +1385,72 @@ static void ops_run_check(struct stripe_head *sh)
 		ops_complete_check, sh);
 }
 
-static void raid5_run_ops(struct stripe_head *sh, unsigned long pending)
+static void ops_run_check6(struct stripe_head *sh)
+{
+	/* kernel stack size limits the total number of disks */
+	struct stripe_queue *sq = sh->sq;
+	int disks = sq->disks;
+	struct page *srcs[disks - 2];
+	struct dma_async_tx_descriptor *tx;
+
+	int count = 0;
+	int pd_idx = sq->pd_idx;
+	int qd_idx = raid6_next_disk(pd_idx, disks);
+	int i;
+
+	struct page *pxor_dest = sh->dev[pd_idx].page;
+	struct page *qxor_dest = sh->dev[qd_idx].page;
+
+	pr_debug("%s: stripe %llu\n", __FUNCTION__,
+		(unsigned long long)sh->sector);
+
+	for (i = 0; i < disks; i++) {
+		if (i != pd_idx && i != qd_idx)
+			srcs[count++] = sh->dev[i].page;
+	}
+
+	if (test_bit(STRIPE_OP_CHECK_PP, &sh->ops.pending) &&
+	    test_bit(STRIPE_OP_CHECK_QP, &sh->ops.pending)) {
+		/* check both P and Q */
+		pr_debug("%s: check both P&Q\n", __FUNCTION__);
+		tx = async_pqxor_zero_sum(pxor_dest, qxor_dest,
+			srcs, (char *)raid6_gfexp,
+			0, count, STRIPE_SIZE,
+			&sh->ops.zero_sum_result, &sh->ops.zero_qsum_result,
+			0, NULL, NULL, NULL);
+	} else if (test_bit(STRIPE_OP_CHECK_QP, &sh->ops.pending)) {
+		/* check Q only */
+		pr_debug("%s: check Q\n", __FUNCTION__);
+		tx = async_pqxor_zero_sum(NULL, qxor_dest,
+			srcs, (char *)raid6_gfexp,
+			0, count, STRIPE_SIZE,
+			&sh->ops.zero_sum_result, &sh->ops.zero_qsum_result,
+			0, NULL, NULL, NULL);
+	} else {
+		/* check P only */
+		tx = async_xor_zero_sum(pxor_dest,
+			srcs, 0, count, STRIPE_SIZE,
+			&sh->ops.zero_sum_result,
+			0, NULL, NULL, NULL);
+	}
+
+	if (tx)
+		set_bit(STRIPE_OP_MOD_DMA_CHECK, &sh->ops.pending);
+	else
+		clear_bit(STRIPE_OP_MOD_DMA_CHECK, &sh->ops.pending);
+
+	atomic_inc(&sh->count);
+	tx = async_trigger_callback(ASYNC_TX_DEP_ACK | ASYNC_TX_ACK, tx,
+		ops_complete_check, sh);
+}
+
+static void raid_run_ops(struct stripe_head *sh, unsigned long pending)
 {
 	struct stripe_queue *sq = sh->sq;
 	int overlap_clear = 0;
 	int disks = sq->disks;
 	int i;
+	int level = sq->raid_conf->level;
 	struct dma_async_tx_descriptor *tx = NULL;
 
 	if (test_bit(STRIPE_OP_BIOFILL, &pending)) {
@@ -1211,8 +1458,16 @@ static void raid5_run_ops(struct stripe_head *sh, unsigned long pending)
 		overlap_clear++;
 	}
 
-	if (test_bit(STRIPE_OP_COMPUTE_BLK, &pending))
-		tx = ops_run_compute5(sh, pending);
+	if (test_bit(STRIPE_OP_COMPUTE_BLK, &pending)) {
+		if (level != 6)
+			tx = ops_run_compute5(sh, pending);
+		else {
+			if (sh->ops.target2 < 0 || sh->ops.target < 0)
+				tx = ops_run_compute6_1(sh, pending);
+			else
+				tx = ops_run_compute6_2(sh, pending);
+		}
+	}
 
 	if (test_bit(STRIPE_OP_PREXOR, &pending))
 		tx = ops_run_prexor(sh, tx);
@@ -1225,8 +1480,12 @@ static void raid5_run_ops(struct stripe_head *sh, unsigned long pending)
 	if (test_bit(STRIPE_OP_POSTXOR, &pending))
 		ops_run_postxor(sh, tx, pending);
 
-	if (test_bit(STRIPE_OP_CHECK, &pending))
-		ops_run_check(sh);
+	if (test_bit(STRIPE_OP_CHECK, &pending)) {
+		if (level != 6)
+			ops_run_check5(sh);
+		else
+			ops_run_check6(sh);
+	}
 
 	if (test_bit(STRIPE_OP_IO, &pending))
 		ops_run_io(sh);
@@ -2505,7 +2764,7 @@ static int __handle_issuing_new_read_requests5(struct stripe_head *sh,
 			s->req_compute = 1;
 			sh->ops.count++;
 			/* Careful: from this point on 'uptodate' is in the eye
-			 * of raid5_run_ops which services 'compute' operations
+			 * of raid_run_ops which services 'compute' operations
 			 * before writes. R5_Wantcompute flags a block that will
 			 * be R5_UPTODATE by the time it is needed for a
 			 * subsequent operation.
@@ -2749,7 +3008,7 @@ static void handle_issuing_new_write_requests5(raid5_conf_t *conf,
 	 */
 	/* since handle_stripe can be called at any time we need to handle the
 	 * case where a compute block operation has been submitted and then a
-	 * subsequent call wants to start a write request.  raid5_run_ops only
+	 * subsequent call wants to start a write request.  raid_run_ops only
 	 * handles the case where compute block and postxor are requested
 	 * simultaneously.  If this is not the case then new writes need to be
 	 * held off until the compute completes.
@@ -3383,7 +3642,7 @@ static void handle_stripe5(struct stripe_head *sh)
 	spin_unlock(&sq->lock);
 
 	if (pending)
-		raid5_run_ops(sh, pending);
+		raid_run_ops(sh, pending);
 
 	return_io(return_bi);
 
diff --git a/include/linux/raid/raid5.h b/include/linux/raid/raid5.h
index effd34f..8bffac5 100644
--- a/include/linux/raid/raid5.h
+++ b/include/linux/raid/raid5.h
@@ -178,8 +178,10 @@ struct stripe_head {
 		unsigned long	   ack;
 		unsigned long	   complete;
 		int		   target;
+		int		   target2; /* the second target for RAID-6 */
 		int		   count;
-		u32		   zero_sum_result;
+		u32		   zero_sum_result;	/* P-parity check */
+		u32		   zero_qsum_result;	/* Q-parity check */
 	} ops;
 	struct stripe_queue *sq; /* list of pending bios for this stripe */
 	struct r5dev {
@@ -295,6 +297,9 @@ struct stripe_queue {
 #define STRIPE_OP_MOD_REPAIR_PD 7
 #define STRIPE_OP_MOD_DMA_CHECK 8
 
+#define STRIPE_OP_CHECK_PP	9
+#define STRIPE_OP_CHECK_QP	10
+
 /*
  * Stripe-queue state
  */

-- 
Yuri Tikhonov, Senior Software Engineer
Emcraft Systems, www.emcraft.com
