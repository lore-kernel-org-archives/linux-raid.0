From: Ilya Yanok <yanok@emcraft.com>
Subject: [PATCH 04/11] md: run stripe operations outside the lock
Date: Thu, 13 Nov 2008 18:15:57 +0300
Message-ID: <1226589364-5619-5-git-send-email-yanok@emcraft.com>
References: <1226589364-5619-1-git-send-email-yanok@emcraft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@ozlabs.org>
In-Reply-To: <1226589364-5619-1-git-send-email-yanok@emcraft.com>
List-Unsubscribe: <https://ozlabs.org/mailman/options/linuxppc-dev>,
	<mailto:linuxppc-dev-request@ozlabs.org?subject=unsubscribe>
List-Archive: <http://ozlabs.org/pipermail/linuxppc-dev>
List-Post: <mailto:linuxppc-dev@ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@ozlabs.org?subject=help>
List-Subscribe: <https://ozlabs.org/mailman/listinfo/linuxppc-dev>,
	<mailto:linuxppc-dev-request@ozlabs.org?subject=subscribe>
Sender: linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@ozlabs.org
Errors-To: linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@ozlabs.org
To: linux-raid@vger.kernel.org
Cc: linuxppc-dev@ozlabs.org, dzu@denx.de, wd@denx.de, Ilya Yanok <yanok@emcraft.com>
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

 The flow is the same as in the RAID-5 case.

Signed-off-by: Yuri Tikhonov <yur@emcraft.com>
Signed-off-by: Ilya Yanok <yanok@emcraft.com>
---
 drivers/md/Kconfig         |    2 +
 drivers/md/raid5.c         |  286 ++++++++++++++++++++++++++++++++++++++++----
 include/linux/raid/raid5.h |    6 +-
 3 files changed, 269 insertions(+), 25 deletions(-)

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 2281b50..7731472 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -123,6 +123,8 @@ config MD_RAID456
 	depends on BLK_DEV_MD
 	select ASYNC_MEMCPY
 	select ASYNC_XOR
+	select ASYNC_PQXOR
+	select ASYNC_R6RECOV
 	---help---
 	  A RAID-5 set of N drives with a capacity of C MB per drive provides
 	  the capacity of C * (N - 1) MB, and protects against a failure
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index a36a743..5b44d71 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -584,18 +584,26 @@ static void ops_run_biofill(struct stripe_head *sh)
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
 
 	pr_debug("%s: stripe %llu\n", __func__,
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
 	clear_bit(STRIPE_COMPUTE_RUN, &sh->state);
 	if (sh->check_state == check_state_compute_run)
 		sh->check_state = check_state_compute_result;
@@ -627,15 +635,158 @@ static struct dma_async_tx_descriptor *ops_run_compute5(struct stripe_head *sh)
 
 	if (unlikely(count == 1))
 		tx = async_memcpy(xor_dest, xor_srcs[0], 0, 0, STRIPE_SIZE,
-			0, NULL, ops_complete_compute5, sh);
+			0, NULL, ops_complete_compute, sh);
 	else
 		tx = async_xor(xor_dest, xor_srcs, 0, count, STRIPE_SIZE,
 			ASYNC_TX_XOR_ZERO_DST, NULL,
-			ops_complete_compute5, sh);
+			ops_complete_compute, sh);
+
+	return tx;
+}
+
+static struct dma_async_tx_descriptor *
+ops_run_compute6_1(struct stripe_head *sh)
+{
+	/* kernel stack size limits the total number of disks */
+	int disks = sh->disks;
+	struct page *srcs[disks];
+	int target = sh->ops.target < 0 ? sh->ops.target2 : sh->ops.target;
+	struct r5dev *tgt = &sh->dev[target];
+	struct page *dest = sh->dev[target].page;
+	int count = 0;
+	int pd_idx = sh->pd_idx, qd_idx = raid6_next_disk(pd_idx, disks);
+	int d0_idx = raid6_next_disk(qd_idx, disks);
+	struct dma_async_tx_descriptor *tx;
+	int i;
+
+	pr_debug("%s: stripe %llu block: %d\n",
+		__func__, (unsigned long long)sh->sector, target);
+	BUG_ON(!test_bit(R5_Wantcompute, &tgt->flags));
+
+	atomic_inc(&sh->count);
+
+	if (target == qd_idx) {
+		/* We are actually computing the Q drive*/
+		i = d0_idx;
+		do {
+			srcs[count++] = sh->dev[i].page;
+			i = raid6_next_disk(i, disks);
+		} while (i != pd_idx);
+		/* Synchronous calculations need two destination pages,
+		 * so use P-page too
+		 */
+		tx = async_gen_syndrome(sh->dev[pd_idx].page, dest,
+			srcs, 0, count, STRIPE_SIZE,
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
 
 	return tx;
 }
 
+static struct dma_async_tx_descriptor *
+ops_run_compute6_2(struct stripe_head *sh)
+{
+	/* kernel stack size limits the total number of disks */
+	int disks = sh->disks;
+	struct page *srcs[disks];
+	int target = sh->ops.target;
+	int target2 = sh->ops.target2;
+	struct r5dev *tgt = &sh->dev[target];
+	struct r5dev *tgt2 = &sh->dev[target2];
+	int count = 0;
+	int pd_idx = sh->pd_idx;
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
+	if (failb < faila) {
+		int tmp = faila;
+		faila = failb;
+		failb = tmp;
+	}
+
+	pr_debug("%s: stripe %llu block1: %d block2: %d\n",
+		__func__, (unsigned long long)sh->sector, target, target2);
+	BUG_ON(!test_bit(R5_Wantcompute, &tgt->flags));
+	BUG_ON(!test_bit(R5_Wantcompute, &tgt2->flags));
+
+	atomic_inc(&sh->count);
+
+	if (failb == disks-1) {
+		/* Q disk is one of the missing disks */
+		i = d0_idx;
+		do {
+			if (i != target && i != target2) {
+				srcs[count++] = sh->dev[i].page;
+				if (!test_bit(R5_UPTODATE, &sh->dev[i].flags))
+					pr_debug("%s with missing block "
+						 "%d/%d\n", __func__, count, i);
+			}
+			i = raid6_next_disk(i, disks);
+		} while (i != d0_idx);
+
+		if (faila == disks - 2) {
+			/* Missing P+Q, just recompute */
+			tx = async_gen_syndrome(sh->dev[pd_idx].page,
+			     sh->dev[qd_idx].page, srcs, 0, count, STRIPE_SIZE,
+			     ASYNC_TX_XOR_ZERO_DST, NULL,
+			     ops_complete_compute, sh);
+		} else {
+			/* Missing D+Q: recompute D from P,
+			 * recompute Q then. Should be handled in
+			 * the fetch_block6() function
+			 */
+			BUG();
+		}
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
+			pr_debug("%s with missing block %d/%d\n", __func__,
+				 count, i);
+	} while (i != d0_idx);
+
+	if (failb == disks - 2) {
+		/* We're missing D+P. */
+		tx = async_r6_dp_recov(disks, STRIPE_SIZE, faila, srcs,
+				0, NULL, ops_complete_compute, sh);
+	} else {
+		/* We're missing D+D. */
+		tx = async_r6_dd_recov(disks, STRIPE_SIZE, faila, failb, srcs,
+				0, NULL, ops_complete_compute, sh);
+	}
+
+	return tx;
+}
+
+
 static void ops_complete_prexor(void *stripe_head_ref)
 {
 	struct stripe_head *sh = stripe_head_ref;
@@ -695,6 +846,7 @@ ops_run_biodrain(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
 			wbi = dev->written = chosen;
 			spin_unlock(&sh->lock);
 
+			/* schedule the copy operations */
 			while (wbi && wbi->bi_sector <
 				dev->sector + STRIPE_SECTORS) {
 				tx = async_copy_data(1, wbi, dev->page,
@@ -711,13 +863,15 @@ static void ops_complete_postxor(void *stripe_head_ref)
 {
 	struct stripe_head *sh = stripe_head_ref;
 	int disks = sh->disks, i, pd_idx = sh->pd_idx;
+	int qd_idx = (sh->raid_conf->level != 6) ? -1 :
+		     raid6_next_disk(pd_idx, disks);
 
 	pr_debug("%s: stripe %llu\n", __func__,
 		(unsigned long long)sh->sector);
 
 	for (i = disks; i--; ) {
 		struct r5dev *dev = &sh->dev[i];
-		if (dev->written || i == pd_idx)
+		if (dev->written || i == pd_idx || i == qd_idx)
 			set_bit(R5_UPTODATE, &dev->flags);
 	}
 
@@ -742,7 +896,13 @@ ops_run_postxor(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
 	struct page *xor_srcs[disks];
 
 	int count = 0, pd_idx = sh->pd_idx, i;
+	int qd_idx = (sh->raid_conf->level != 6) ? -1 :
+		     raid6_next_disk(pd_idx, disks);
+	int d0_idx = (sh->raid_conf->level != 6) ?
+		raid6_next_disk(pd_idx, disks) :
+		raid6_next_disk(qd_idx, disks);
 	struct page *xor_dest;
+	struct page *q_dest = NULL;
 	int prexor = 0;
 	unsigned long flags;
 
@@ -753,6 +913,7 @@ ops_run_postxor(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
 	 * that are part of a read-modify-write (written)
 	 */
 	if (sh->reconstruct_state == reconstruct_state_prexor_drain_run) {
+		BUG_ON(!(qd_idx < 0));
 		prexor = 1;
 		xor_dest = xor_srcs[count++] = sh->dev[pd_idx].page;
 		for (i = disks; i--; ) {
@@ -762,11 +923,13 @@ ops_run_postxor(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
 		}
 	} else {
 		xor_dest = sh->dev[pd_idx].page;
-		for (i = disks; i--; ) {
+		q_dest = (qd_idx < 0) ? NULL : sh->dev[qd_idx].page;
+		i = d0_idx;
+		do {
 			struct r5dev *dev = &sh->dev[i];
-			if (i != pd_idx)
-				xor_srcs[count++] = dev->page;
-		}
+			xor_srcs[count++] = dev->page;
+			i = raid6_next_disk(i, disks);
+		} while (i != pd_idx);
 	}
 
 	/* 1/ if we prexor'd then the dest is reused as a source
@@ -780,12 +943,20 @@ ops_run_postxor(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
 	atomic_inc(&sh->count);
 
 	if (unlikely(count == 1)) {
+		BUG_ON(!(qd_idx < 0));
 		flags &= ~(ASYNC_TX_XOR_DROP_DST | ASYNC_TX_XOR_ZERO_DST);
 		tx = async_memcpy(xor_dest, xor_srcs[0], 0, 0, STRIPE_SIZE,
 			flags, tx, ops_complete_postxor, sh);
-	} else
-		tx = async_xor(xor_dest, xor_srcs, 0, count, STRIPE_SIZE,
-			flags, tx, ops_complete_postxor, sh);
+	} else {
+		if (qd_idx < 0)
+			tx = async_xor(xor_dest, xor_srcs, 0, count,
+				       STRIPE_SIZE, flags, tx,
+				       ops_complete_postxor, sh);
+		else
+			tx = async_gen_syndrome(xor_dest, q_dest, xor_srcs, 0,
+						count, STRIPE_SIZE, flags, tx,
+						ops_complete_postxor, sh);
+	}
 }
 
 static void ops_complete_check(void *stripe_head_ref)
@@ -800,7 +971,7 @@ static void ops_complete_check(void *stripe_head_ref)
 	release_stripe(sh);
 }
 
-static void ops_run_check(struct stripe_head *sh)
+static void ops_run_check5(struct stripe_head *sh)
 {
 	/* kernel stack size limits the total number of disks */
 	int disks = sh->disks;
@@ -827,9 +998,65 @@ static void ops_run_check(struct stripe_head *sh)
 		ops_complete_check, sh);
 }
 
-static void raid5_run_ops(struct stripe_head *sh, unsigned long ops_request)
+static void ops_run_check6(struct stripe_head *sh, unsigned long pending)
+{
+	/* kernel stack size limits the total number of disks */
+	int disks = sh->disks;
+	struct page *srcs[disks];
+	struct dma_async_tx_descriptor *tx;
+
+	int count = 0, i;
+	int pd_idx = sh->pd_idx, qd_idx = raid6_next_disk(pd_idx, disks);
+	int d0_idx = raid6_next_disk(qd_idx, disks);
+
+	struct page *qxor_dest = srcs[count++] = sh->dev[qd_idx].page;
+	struct page *pxor_dest = srcs[count++] = sh->dev[pd_idx].page;
+
+	pr_debug("%s: stripe %llu\n", __func__,
+		(unsigned long long)sh->sector);
+
+	srcs[count++] = sh->dev[qd_idx].page;
+	srcs[count++] = sh->dev[pd_idx].page;
+	i = d0_idx;
+	do {
+		srcs[count++] = sh->dev[i].page;
+		i = raid6_next_disk(i, disks);
+	} while (i != pd_idx);
+
+	if (test_bit(STRIPE_OP_CHECK_PP, &pending) &&
+	    test_bit(STRIPE_OP_CHECK_QP, &pending)) {
+		/* check both P and Q */
+		pr_debug("%s: check both P&Q\n", __func__);
+		tx = async_syndrome_zero_sum(pxor_dest, qxor_dest,
+			srcs, 0, count, STRIPE_SIZE,
+			&sh->ops.zero_sum_result, &sh->ops.zero_qsum_result,
+			0, NULL, NULL, NULL);
+	} else if (test_bit(STRIPE_OP_CHECK_QP, &pending)) {
+		/* check Q only */
+		srcs[1] = NULL;
+		pr_debug("%s: check Q\n", __func__);
+		tx = async_syndrome_zero_sum(NULL, qxor_dest,
+			srcs, 0, count, STRIPE_SIZE,
+			&sh->ops.zero_sum_result, &sh->ops.zero_qsum_result,
+			0, NULL, NULL, NULL);
+	} else {
+		/* check P only */
+		srcs[0] = NULL;
+		tx = async_xor_zero_sum(pxor_dest,
+			&srcs[1], 0, count-1, STRIPE_SIZE,
+			&sh->ops.zero_sum_result,
+			0, NULL, NULL, NULL);
+	}
+
+	atomic_inc(&sh->count);
+	tx = async_trigger_callback(ASYNC_TX_DEP_ACK | ASYNC_TX_ACK, tx,
+		ops_complete_check, sh);
+}
+
+static void raid_run_ops(struct stripe_head *sh, unsigned long ops_request)
 {
 	int overlap_clear = 0, i, disks = sh->disks;
+	int level = sh->raid_conf->level;
 	struct dma_async_tx_descriptor *tx = NULL;
 
 	if (test_bit(STRIPE_OP_BIOFILL, &ops_request)) {
@@ -838,7 +1065,14 @@ static void raid5_run_ops(struct stripe_head *sh, unsigned long ops_request)
 	}
 
 	if (test_bit(STRIPE_OP_COMPUTE_BLK, &ops_request)) {
-		tx = ops_run_compute5(sh);
+		if (level == 5)
+			tx = ops_run_compute5(sh);
+		else {
+			if (sh->ops.target2 < 0 || sh->ops.target < 0)
+				tx = ops_run_compute6_1(sh);
+			else
+				tx = ops_run_compute6_2(sh);
+		}
 		/* terminate the chain if postxor is not set to be run */
 		if (tx && !test_bit(STRIPE_OP_POSTXOR, &ops_request))
 			async_tx_ack(tx);
@@ -856,7 +1090,11 @@ static void raid5_run_ops(struct stripe_head *sh, unsigned long ops_request)
 		ops_run_postxor(sh, tx);
 
 	if (test_bit(STRIPE_OP_CHECK, &ops_request))
-		ops_run_check(sh);
+		ops_run_check5(sh);
+
+	if (test_bit(STRIPE_OP_CHECK_PP, &ops_request) ||
+	    test_bit(STRIPE_OP_CHECK_QP, &ops_request))
+		ops_run_check6(sh, ops_request);
 
 	if (overlap_clear)
 		for (i = disks; i--; ) {
@@ -1936,9 +2174,10 @@ static int fetch_block5(struct stripe_head *sh, struct stripe_head_state *s,
 			set_bit(STRIPE_OP_COMPUTE_BLK, &s->ops_request);
 			set_bit(R5_Wantcompute, &dev->flags);
 			sh->ops.target = disk_idx;
+			sh->ops.target2 = -1;
 			s->req_compute = 1;
 			/* Careful: from this point on 'uptodate' is in the eye
-			 * of raid5_run_ops which services 'compute' operations
+			 * of raid_run_ops which services 'compute' operations
 			 * before writes. R5_Wantcompute flags a block that will
 			 * be R5_UPTODATE by the time it is needed for a
 			 * subsequent operation.
@@ -2165,7 +2404,7 @@ static void handle_stripe_dirtying5(raid5_conf_t *conf,
 	 */
 	/* since handle_stripe can be called at any time we need to handle the
 	 * case where a compute block operation has been submitted and then a
-	 * subsequent call wants to start a write request.  raid5_run_ops only
+	 * subsequent call wants to start a write request.  raid_run_ops only
 	 * handles the case where compute block and postxor are requested
 	 * simultaneously.  If this is not the case then new writes need to be
 	 * held off until the compute completes.
@@ -2348,6 +2587,7 @@ static void handle_parity_checks5(raid5_conf_t *conf, struct stripe_head *sh,
 				set_bit(R5_Wantcompute,
 					&sh->dev[sh->pd_idx].flags);
 				sh->ops.target = sh->pd_idx;
+				sh->ops.target2 = -1;
 				s->uptodate++;
 			}
 		}
@@ -2785,7 +3025,7 @@ static bool handle_stripe5(struct stripe_head *sh)
 		md_wait_for_blocked_rdev(blocked_rdev, conf->mddev);
 
 	if (s.ops_request)
-		raid5_run_ops(sh, s.ops_request);
+		raid_run_ops(sh, s.ops_request);
 
 	ops_run_io(sh, &s);
 
diff --git a/include/linux/raid/raid5.h b/include/linux/raid/raid5.h
index 3b26727..78c78a2 100644
--- a/include/linux/raid/raid5.h
+++ b/include/linux/raid/raid5.h
@@ -212,8 +212,8 @@ struct stripe_head {
 	 * @target - STRIPE_OP_COMPUTE_BLK target
 	 */
 	struct stripe_operations {
-		int		   target;
-		u32		   zero_sum_result;
+		int		   target, target2;
+		u32		   zero_sum_result, zero_qsum_result;
 	} ops;
 	struct r5dev {
 		struct bio	req;
@@ -295,6 +295,8 @@ struct r6_state {
 #define STRIPE_OP_BIODRAIN	3
 #define STRIPE_OP_POSTXOR	4
 #define STRIPE_OP_CHECK	5
+#define STRIPE_OP_CHECK_PP	6
+#define STRIPE_OP_CHECK_QP	7
 
 /*
  * Plugging:
-- 
1.5.6.1
