From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v2 2/9] md/raid6: asynchronous raid6 operations
Date: Mon, 31 Aug 2009 09:41:14 -0700
Message-ID: <20090831164114.1696.62367.stgit@dwillia2-linux.ch.intel.com>
References: <20090831163914.1696.55782.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090831163914.1696.55782.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, Andre Noll <maan@systemlinux.org>, Ilya Yanok <yanok@emcraft.com>, Yuri Tikhonov <yur@emcraft.com>
List-Id: linux-raid.ids

[ Based on an original patch by Yuri Tikhonov ]

The raid_run_ops routine uses the asynchronous offload api and
the stripe_operations member of a stripe_head to carry out xor+pq+copy
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
STRIPE_OP_RECONSTRUCT
 - recalculate parity for new data that has entered the cache
STRIPE_OP_CHECK
 - verify that the parity is correct

The flow is the same as in the RAID-5 case, and reuses some routines, namely:
1/ ops_complete_postxor (renamed to ops_complete_reconstruct)
2/ ops_complete_compute (updated to set up to 2 targets uptodate)
3/ ops_run_check (renamed to ops_run_check_p for xor parity checks)

[neilb@suse.de: fixes to get it to pass mdadm regression suite]
Reviewed-by: Andre Noll <maan@systemlinux.org>
Signed-off-by: Yuri Tikhonov <yur@emcraft.com>
Signed-off-by: Ilya Yanok <yanok@emcraft.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/md/Kconfig |    2 
 drivers/md/raid5.c |  322 +++++++++++++++++++++++++++++++++++++++++++++++-----
 drivers/md/raid5.h |    8 +
 3 files changed, 299 insertions(+), 33 deletions(-)

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 41b3ae2..abb8636 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -124,6 +124,8 @@ config MD_RAID456
 	select MD_RAID6_PQ
 	select ASYNC_MEMCPY
 	select ASYNC_XOR
+	select ASYNC_PQ
+	select ASYNC_RAID6_RECOV
 	---help---
 	  A RAID-5 set of N drives with a capacity of C MB per drive provides
 	  the capacity of C * (N - 1) MB, and protects against a failure
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index e3a2990..e68616e 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -636,15 +636,16 @@ static void mark_target_uptodate(struct stripe_head *sh, int target)
 	clear_bit(R5_Wantcompute, &tgt->flags);
 }
 
-static void ops_complete_compute5(void *stripe_head_ref)
+static void ops_complete_compute(void *stripe_head_ref)
 {
 	struct stripe_head *sh = stripe_head_ref;
 
 	pr_debug("%s: stripe %llu\n", __func__,
 		(unsigned long long)sh->sector);
 
-	/* mark the computed target as uptodate */
+	/* mark the computed target(s) as uptodate */
 	mark_target_uptodate(sh, sh->ops.target);
+	mark_target_uptodate(sh, sh->ops.target2);
 
 	clear_bit(STRIPE_COMPUTE_RUN, &sh->state);
 	if (sh->check_state == check_state_compute_run)
@@ -684,7 +685,7 @@ ops_run_compute5(struct stripe_head *sh, struct raid5_percpu *percpu)
 	atomic_inc(&sh->count);
 
 	init_async_submit(&submit, ASYNC_TX_XOR_ZERO_DST, NULL,
-			  ops_complete_compute5, sh, to_addr_conv(sh, percpu));
+			  ops_complete_compute, sh, to_addr_conv(sh, percpu));
 	if (unlikely(count == 1))
 		tx = async_memcpy(xor_dest, xor_srcs[0], 0, 0, STRIPE_SIZE, &submit);
 	else
@@ -693,6 +694,197 @@ ops_run_compute5(struct stripe_head *sh, struct raid5_percpu *percpu)
 	return tx;
 }
 
+/* set_syndrome_sources - populate source buffers for gen_syndrome
+ * @srcs - (struct page *) array of size sh->disks
+ * @sh - stripe_head to parse
+ *
+ * Populates srcs in proper layout order for the stripe and returns the
+ * 'count' of sources to be used in a call to async_gen_syndrome.  The P
+ * destination buffer is recorded in srcs[count] and the Q destination
+ * is recorded in srcs[count+1]].
+ */
+static int set_syndrome_sources(struct page **srcs, struct stripe_head *sh)
+{
+	int disks = sh->disks;
+	int syndrome_disks = sh->ddf_layout ? disks : (disks - 2);
+	int d0_idx = raid6_d0(sh);
+	int count;
+	int i;
+
+	for (i = 0; i < disks; i++)
+		srcs[i] = (void *)raid6_empty_zero_page;
+
+	count = 0;
+	i = d0_idx;
+	do {
+		int slot = raid6_idx_to_slot(i, sh, &count, syndrome_disks);
+
+		srcs[slot] = sh->dev[i].page;
+		i = raid6_next_disk(i, disks);
+	} while (i != d0_idx);
+	BUG_ON(count != syndrome_disks);
+
+	return count;
+}
+
+static struct dma_async_tx_descriptor *
+ops_run_compute6_1(struct stripe_head *sh, struct raid5_percpu *percpu)
+{
+	int disks = sh->disks;
+	struct page **blocks = percpu->scribble;
+	int target;
+	int qd_idx = sh->qd_idx;
+	struct dma_async_tx_descriptor *tx;
+	struct async_submit_ctl submit;
+	struct r5dev *tgt;
+	struct page *dest;
+	int i;
+	int count;
+
+	if (sh->ops.target < 0)
+		target = sh->ops.target2;
+	else if (sh->ops.target2 < 0)
+		target = sh->ops.target;
+	else
+		/* we should only have one valid target */
+		BUG();
+	BUG_ON(target < 0);
+	pr_debug("%s: stripe %llu block: %d\n",
+		__func__, (unsigned long long)sh->sector, target);
+
+	tgt = &sh->dev[target];
+	BUG_ON(!test_bit(R5_Wantcompute, &tgt->flags));
+	dest = tgt->page;
+
+	atomic_inc(&sh->count);
+
+	if (target == qd_idx) {
+		count = set_syndrome_sources(blocks, sh);
+		blocks[count] = NULL; /* regenerating p is not necessary */
+		BUG_ON(blocks[count+1] != dest); /* q should already be set */
+		init_async_submit(&submit, 0, NULL, ops_complete_compute, sh,
+				  to_addr_conv(sh, percpu));
+		tx = async_gen_syndrome(blocks, 0, count+2, STRIPE_SIZE, &submit);
+	} else {
+		/* Compute any data- or p-drive using XOR */
+		count = 0;
+		for (i = disks; i-- ; ) {
+			if (i == target || i == qd_idx)
+				continue;
+			blocks[count++] = sh->dev[i].page;
+		}
+
+		init_async_submit(&submit, ASYNC_TX_XOR_ZERO_DST, NULL,
+				  ops_complete_compute, sh,
+				  to_addr_conv(sh, percpu));
+		tx = async_xor(dest, blocks, 0, count, STRIPE_SIZE, &submit);
+	}
+
+	return tx;
+}
+
+static struct dma_async_tx_descriptor *
+ops_run_compute6_2(struct stripe_head *sh, struct raid5_percpu *percpu)
+{
+	int i, count, disks = sh->disks;
+	int syndrome_disks = sh->ddf_layout ? disks : disks-2;
+	int d0_idx = raid6_d0(sh);
+	int faila = -1, failb = -1;
+	int target = sh->ops.target;
+	int target2 = sh->ops.target2;
+	struct r5dev *tgt = &sh->dev[target];
+	struct r5dev *tgt2 = &sh->dev[target2];
+	struct dma_async_tx_descriptor *tx;
+	struct page **blocks = percpu->scribble;
+	struct async_submit_ctl submit;
+
+	pr_debug("%s: stripe %llu block1: %d block2: %d\n",
+		 __func__, (unsigned long long)sh->sector, target, target2);
+	BUG_ON(target < 0 || target2 < 0);
+	BUG_ON(!test_bit(R5_Wantcompute, &tgt->flags));
+	BUG_ON(!test_bit(R5_Wantcompute, &tgt2->flags));
+
+	/* we need to open-code set_syndrome_sources to handle to the
+	 * slot number conversion for 'faila' and 'failb'
+	 */
+	for (i = 0; i < disks ; i++)
+		blocks[i] = (void *)raid6_empty_zero_page;
+	count = 0;
+	i = d0_idx;
+	do {
+		int slot = raid6_idx_to_slot(i, sh, &count, syndrome_disks);
+
+		blocks[slot] = sh->dev[i].page;
+
+		if (i == target)
+			faila = slot;
+		if (i == target2)
+			failb = slot;
+		i = raid6_next_disk(i, disks);
+	} while (i != d0_idx);
+	BUG_ON(count != syndrome_disks);
+
+	BUG_ON(faila == failb);
+	if (failb < faila)
+		swap(faila, failb);
+	pr_debug("%s: stripe: %llu faila: %d failb: %d\n",
+		 __func__, (unsigned long long)sh->sector, faila, failb);
+
+	atomic_inc(&sh->count);
+
+	if (failb == syndrome_disks+1) {
+		/* Q disk is one of the missing disks */
+		if (faila == syndrome_disks) {
+			/* Missing P+Q, just recompute */
+			init_async_submit(&submit, 0, NULL, ops_complete_compute,
+					  sh, to_addr_conv(sh, percpu));
+			return async_gen_syndrome(blocks, 0, count+2,
+						  STRIPE_SIZE, &submit);
+		} else {
+			struct page *dest;
+			int data_target;
+			int qd_idx = sh->qd_idx;
+
+			/* Missing D+Q: recompute D from P, then recompute Q */
+			if (target == qd_idx)
+				data_target = target2;
+			else
+				data_target = target;
+
+			count = 0;
+			for (i = disks; i-- ; ) {
+				if (i == data_target || i == qd_idx)
+					continue;
+				blocks[count++] = sh->dev[i].page;
+			}
+			dest = sh->dev[data_target].page;
+			init_async_submit(&submit, ASYNC_TX_XOR_ZERO_DST, NULL,
+					  NULL, NULL, to_addr_conv(sh, percpu));
+			tx = async_xor(dest, blocks, 0, count, STRIPE_SIZE,
+				       &submit);
+
+			count = set_syndrome_sources(blocks, sh);
+			init_async_submit(&submit, 0, tx, ops_complete_compute,
+					  sh, to_addr_conv(sh, percpu));
+			return async_gen_syndrome(blocks, 0, count+2,
+						  STRIPE_SIZE, &submit);
+		}
+	}
+
+	init_async_submit(&submit, 0, NULL, ops_complete_compute, sh,
+			  to_addr_conv(sh, percpu));
+	if (failb == syndrome_disks) {
+		/* We're missing D+P. */
+		return async_raid6_datap_recov(syndrome_disks+2, STRIPE_SIZE,
+					       faila, blocks, &submit);
+	} else {
+		/* We're missing D+D. */
+		return async_raid6_2data_recov(syndrome_disks+2, STRIPE_SIZE,
+					       faila, failb, blocks, &submit);
+	}
+}
+
+
 static void ops_complete_prexor(void *stripe_head_ref)
 {
 	struct stripe_head *sh = stripe_head_ref;
@@ -765,17 +957,21 @@ ops_run_biodrain(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
 	return tx;
 }
 
-static void ops_complete_postxor(void *stripe_head_ref)
+static void ops_complete_reconstruct(void *stripe_head_ref)
 {
 	struct stripe_head *sh = stripe_head_ref;
-	int disks = sh->disks, i, pd_idx = sh->pd_idx;
+	int disks = sh->disks;
+	int pd_idx = sh->pd_idx;
+	int qd_idx = sh->qd_idx;
+	int i;
 
 	pr_debug("%s: stripe %llu\n", __func__,
 		(unsigned long long)sh->sector);
 
 	for (i = disks; i--; ) {
 		struct r5dev *dev = &sh->dev[i];
-		if (dev->written || i == pd_idx)
+
+		if (dev->written || i == pd_idx || i == qd_idx)
 			set_bit(R5_UPTODATE, &dev->flags);
 	}
 
@@ -793,8 +989,8 @@ static void ops_complete_postxor(void *stripe_head_ref)
 }
 
 static void
-ops_run_postxor(struct stripe_head *sh, struct raid5_percpu *percpu,
-		struct dma_async_tx_descriptor *tx)
+ops_run_reconstruct5(struct stripe_head *sh, struct raid5_percpu *percpu,
+		     struct dma_async_tx_descriptor *tx)
 {
 	int disks = sh->disks;
 	struct page **xor_srcs = percpu->scribble;
@@ -837,7 +1033,7 @@ ops_run_postxor(struct stripe_head *sh, struct raid5_percpu *percpu,
 
 	atomic_inc(&sh->count);
 
-	init_async_submit(&submit, flags, tx, ops_complete_postxor, sh,
+	init_async_submit(&submit, flags, tx, ops_complete_reconstruct, sh,
 			  to_addr_conv(sh, percpu));
 	if (unlikely(count == 1))
 		tx = async_memcpy(xor_dest, xor_srcs[0], 0, 0, STRIPE_SIZE, &submit);
@@ -845,6 +1041,25 @@ ops_run_postxor(struct stripe_head *sh, struct raid5_percpu *percpu,
 		tx = async_xor(xor_dest, xor_srcs, 0, count, STRIPE_SIZE, &submit);
 }
 
+static void
+ops_run_reconstruct6(struct stripe_head *sh, struct raid5_percpu *percpu,
+		     struct dma_async_tx_descriptor *tx)
+{
+	struct async_submit_ctl submit;
+	struct page **blocks = percpu->scribble;
+	int count;
+
+	pr_debug("%s: stripe %llu\n", __func__, (unsigned long long)sh->sector);
+
+	count = set_syndrome_sources(blocks, sh);
+
+	atomic_inc(&sh->count);
+
+	init_async_submit(&submit, ASYNC_TX_ACK, tx, ops_complete_reconstruct,
+			  sh, to_addr_conv(sh, percpu));
+	async_gen_syndrome(blocks, 0, count+2, STRIPE_SIZE,  &submit);
+}
+
 static void ops_complete_check(void *stripe_head_ref)
 {
 	struct stripe_head *sh = stripe_head_ref;
@@ -857,23 +1072,28 @@ static void ops_complete_check(void *stripe_head_ref)
 	release_stripe(sh);
 }
 
-static void ops_run_check(struct stripe_head *sh, struct raid5_percpu *percpu)
+static void ops_run_check_p(struct stripe_head *sh, struct raid5_percpu *percpu)
 {
 	int disks = sh->disks;
+	int pd_idx = sh->pd_idx;
+	int qd_idx = sh->qd_idx;
+	struct page *xor_dest;
 	struct page **xor_srcs = percpu->scribble;
 	struct dma_async_tx_descriptor *tx;
 	struct async_submit_ctl submit;
-
-	int count = 0, pd_idx = sh->pd_idx, i;
-	struct page *xor_dest = xor_srcs[count++] = sh->dev[pd_idx].page;
+	int count;
+	int i;
 
 	pr_debug("%s: stripe %llu\n", __func__,
 		(unsigned long long)sh->sector);
 
+	count = 0;
+	xor_dest = sh->dev[pd_idx].page;
+	xor_srcs[count++] = xor_dest;
 	for (i = disks; i--; ) {
-		struct r5dev *dev = &sh->dev[i];
-		if (i != pd_idx)
-			xor_srcs[count++] = dev->page;
+		if (i == pd_idx || i == qd_idx)
+			continue;
+		xor_srcs[count++] = sh->dev[i].page;
 	}
 
 	init_async_submit(&submit, 0, NULL, NULL, NULL,
@@ -886,11 +1106,32 @@ static void ops_run_check(struct stripe_head *sh, struct raid5_percpu *percpu)
 	tx = async_trigger_callback(&submit);
 }
 
-static void raid5_run_ops(struct stripe_head *sh, unsigned long ops_request)
+static void ops_run_check_pq(struct stripe_head *sh, struct raid5_percpu *percpu, int checkp)
+{
+	struct page **srcs = percpu->scribble;
+	struct async_submit_ctl submit;
+	int count;
+
+	pr_debug("%s: stripe %llu checkp: %d\n", __func__,
+		(unsigned long long)sh->sector, checkp);
+
+	count = set_syndrome_sources(srcs, sh);
+	if (!checkp)
+		srcs[count] = NULL;
+
+	atomic_inc(&sh->count);
+	init_async_submit(&submit, ASYNC_TX_ACK, NULL, ops_complete_check,
+			  sh, to_addr_conv(sh, percpu));
+	async_syndrome_val(srcs, 0, count+2, STRIPE_SIZE,
+			   &sh->ops.zero_sum_result, percpu->spare_page, &submit);
+}
+
+static void raid_run_ops(struct stripe_head *sh, unsigned long ops_request)
 {
 	int overlap_clear = 0, i, disks = sh->disks;
 	struct dma_async_tx_descriptor *tx = NULL;
 	raid5_conf_t *conf = sh->raid_conf;
+	int level = conf->level;
 	struct raid5_percpu *percpu;
 	unsigned long cpu;
 
@@ -902,9 +1143,16 @@ static void raid5_run_ops(struct stripe_head *sh, unsigned long ops_request)
 	}
 
 	if (test_bit(STRIPE_OP_COMPUTE_BLK, &ops_request)) {
-		tx = ops_run_compute5(sh, percpu);
-		/* terminate the chain if postxor is not set to be run */
-		if (tx && !test_bit(STRIPE_OP_POSTXOR, &ops_request))
+		if (level < 6)
+			tx = ops_run_compute5(sh, percpu);
+		else {
+			if (sh->ops.target2 < 0 || sh->ops.target < 0)
+				tx = ops_run_compute6_1(sh, percpu);
+			else
+				tx = ops_run_compute6_2(sh, percpu);
+		}
+		/* terminate the chain if reconstruct is not set to be run */
+		if (tx && !test_bit(STRIPE_OP_RECONSTRUCT, &ops_request))
 			async_tx_ack(tx);
 	}
 
@@ -916,11 +1164,23 @@ static void raid5_run_ops(struct stripe_head *sh, unsigned long ops_request)
 		overlap_clear++;
 	}
 
-	if (test_bit(STRIPE_OP_POSTXOR, &ops_request))
-		ops_run_postxor(sh, percpu, tx);
+	if (test_bit(STRIPE_OP_RECONSTRUCT, &ops_request)) {
+		if (level < 6)
+			ops_run_reconstruct5(sh, percpu, tx);
+		else
+			ops_run_reconstruct6(sh, percpu, tx);
+	}
 
-	if (test_bit(STRIPE_OP_CHECK, &ops_request))
-		ops_run_check(sh, percpu);
+	if (test_bit(STRIPE_OP_CHECK, &ops_request)) {
+		if (sh->check_state == check_state_run)
+			ops_run_check_p(sh, percpu);
+		else if (sh->check_state == check_state_run_q)
+			ops_run_check_pq(sh, percpu, 0);
+		else if (sh->check_state == check_state_run_pq)
+			ops_run_check_pq(sh, percpu, 1);
+		else
+			BUG();
+	}
 
 	if (overlap_clear)
 		for (i = disks; i--; ) {
@@ -1931,7 +2191,7 @@ schedule_reconstruction5(struct stripe_head *sh, struct stripe_head_state *s,
 		} else
 			sh->reconstruct_state = reconstruct_state_run;
 
-		set_bit(STRIPE_OP_POSTXOR, &s->ops_request);
+		set_bit(STRIPE_OP_RECONSTRUCT, &s->ops_request);
 
 		for (i = disks; i--; ) {
 			struct r5dev *dev = &sh->dev[i];
@@ -1954,7 +2214,7 @@ schedule_reconstruction5(struct stripe_head *sh, struct stripe_head_state *s,
 		sh->reconstruct_state = reconstruct_state_prexor_drain_run;
 		set_bit(STRIPE_OP_PREXOR, &s->ops_request);
 		set_bit(STRIPE_OP_BIODRAIN, &s->ops_request);
-		set_bit(STRIPE_OP_POSTXOR, &s->ops_request);
+		set_bit(STRIPE_OP_RECONSTRUCT, &s->ops_request);
 
 		for (i = disks; i--; ) {
 			struct r5dev *dev = &sh->dev[i];
@@ -2206,9 +2466,10 @@ static int fetch_block5(struct stripe_head *sh, struct stripe_head_state *s,
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
@@ -2435,8 +2696,8 @@ static void handle_stripe_dirtying5(raid5_conf_t *conf,
 	 */
 	/* since handle_stripe can be called at any time we need to handle the
 	 * case where a compute block operation has been submitted and then a
-	 * subsequent call wants to start a write request.  raid5_run_ops only
-	 * handles the case where compute block and postxor are requested
+	 * subsequent call wants to start a write request.  raid_run_ops only
+	 * handles the case where compute block and reconstruct are requested
 	 * simultaneously.  If this is not the case then new writes need to be
 	 * held off until the compute completes.
 	 */
@@ -2618,6 +2879,7 @@ static void handle_parity_checks5(raid5_conf_t *conf, struct stripe_head *sh,
 				set_bit(R5_Wantcompute,
 					&sh->dev[sh->pd_idx].flags);
 				sh->ops.target = sh->pd_idx;
+				sh->ops.target2 = -1;
 				s->uptodate++;
 			}
 		}
@@ -3067,7 +3329,7 @@ static bool handle_stripe5(struct stripe_head *sh)
 		md_wait_for_blocked_rdev(blocked_rdev, conf->mddev);
 
 	if (s.ops_request)
-		raid5_run_ops(sh, s.ops_request);
+		raid_run_ops(sh, s.ops_request);
 
 	ops_run_io(sh, &s);
 
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 75f2c6c..116d0b4 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -176,7 +176,9 @@
  */
 enum check_states {
 	check_state_idle = 0,
-	check_state_run, /* parity check */
+	check_state_run, /* xor parity check */
+	check_state_run_q, /* q-parity check */
+	check_state_run_pq, /* pq dual parity check */
 	check_state_check_result,
 	check_state_compute_run, /* parity repair */
 	check_state_compute_result,
@@ -216,7 +218,7 @@ struct stripe_head {
 	 * @target - STRIPE_OP_COMPUTE_BLK target
 	 */
 	struct stripe_operations {
-		int		     target;
+		int 		     target, target2;
 		enum sum_check_flags zero_sum_result;
 	} ops;
 	struct r5dev {
@@ -299,7 +301,7 @@ struct r6_state {
 #define STRIPE_OP_COMPUTE_BLK	1
 #define STRIPE_OP_PREXOR	2
 #define STRIPE_OP_BIODRAIN	3
-#define STRIPE_OP_POSTXOR	4
+#define STRIPE_OP_RECONSTRUCT	4
 #define STRIPE_OP_CHECK	5
 
 /*

