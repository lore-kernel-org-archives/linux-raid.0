From: Yufen Yu <yuyufen@huawei.com>
Subject: [PATCH v5 15/16] md/raid6: compute syndrome with correct page offset
Date: Thu, 2 Jul 2020 08:06:27 -0400
Message-ID: <20200702120628.777303-16-yuyufen@huawei.com>
References: <20200702120628.777303-1-yuyufen@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200702120628.777303-1-yuyufen@huawei.com>
Sender: linux-raid-owner@vger.kernel.org
To: song@kernel.org
Cc: linux-raid@vger.kernel.org, neilb@suse.com, guoqing.jiang@cloud.ionos.com, houtao1@huawei.com, yuyufen@huawei.com
List-Id: linux-raid.ids

When raid6 compute syndrome, the pages address will be passed to computer
function. After trying to support shared page between multiple sh->dev,
we also need to let computor know the correct location of each page.

Signed-off-by: Yufen Yu <yuyufen@huawei.com>
---
 drivers/md/raid5.c | 69 +++++++++++++++++++++++++++++++---------------
 1 file changed, 47 insertions(+), 22 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index a3376a4e4e5c..533097da2ea6 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1531,6 +1531,7 @@ ops_run_compute5(struct stripe_head *sh, struct raid5_percpu *percpu)
 
 /* set_syndrome_sources - populate source buffers for gen_syndrome
  * @srcs - (struct page *) array of size sh->disks
+ * @offs - (unsigned int) array of offset for each page
  * @sh - stripe_head to parse
  *
  * Populates srcs in proper layout order for the stripe and returns the
@@ -1539,6 +1540,7 @@ ops_run_compute5(struct stripe_head *sh, struct raid5_percpu *percpu)
  * is recorded in srcs[count+1]].
  */
 static int set_syndrome_sources(struct page **srcs,
+				unsigned int *offs,
 				struct stripe_head *sh,
 				int srctype)
 {
@@ -1569,6 +1571,12 @@ static int set_syndrome_sources(struct page **srcs,
 				srcs[slot] = sh->dev[i].orig_page;
 			else
 				srcs[slot] = sh->dev[i].page;
+			/*
+			 * For R5_InJournal, PAGE_SIZE must be 4KB and will
+			 * not use r5pages. In that case, dev[i].offset
+			 * is 0. So we can also use the value directly.
+			 */
+			offs[slot] = sh->dev[i].offset;
 		}
 		i = raid6_next_disk(i, disks);
 	} while (i != d0_idx);
@@ -1581,12 +1589,14 @@ ops_run_compute6_1(struct stripe_head *sh, struct raid5_percpu *percpu)
 {
 	int disks = sh->disks;
 	struct page **blocks = to_addr_page(percpu, 0);
+	unsigned int *offs = to_addr_offs(sh, percpu);
 	int target;
 	int qd_idx = sh->qd_idx;
 	struct dma_async_tx_descriptor *tx;
 	struct async_submit_ctl submit;
 	struct r5dev *tgt;
 	struct page *dest;
+	unsigned int dest_off;
 	int i;
 	int count;
 	struct r5conf *conf = sh->raid_conf;
@@ -1606,32 +1616,35 @@ ops_run_compute6_1(struct stripe_head *sh, struct raid5_percpu *percpu)
 	tgt = &sh->dev[target];
 	BUG_ON(!test_bit(R5_Wantcompute, &tgt->flags));
 	dest = tgt->page;
+	dest_off = tgt->offset;
 
 	atomic_inc(&sh->count);
 
 	if (target == qd_idx) {
-		count = set_syndrome_sources(blocks, sh, SYNDROME_SRC_ALL);
+		count = set_syndrome_sources(blocks, offs,
+					sh, SYNDROME_SRC_ALL);
 		blocks[count] = NULL; /* regenerating p is not necessary */
 		BUG_ON(blocks[count+1] != dest); /* q should already be set */
 		init_async_submit(&submit, ASYNC_TX_FENCE, NULL,
 				  ops_complete_compute, sh,
 				  to_addr_conv(sh, percpu, 0));
-		tx = async_gen_syndrome(blocks, 0, count+2,
-				conf->stripe_size, &submit);
+		tx = async_gen_syndrome(blocks, offs,
+					count+2, conf->stripe_size, &submit);
 	} else {
 		/* Compute any data- or p-drive using XOR */
 		count = 0;
 		for (i = disks; i-- ; ) {
 			if (i == target || i == qd_idx)
 				continue;
+			offs[count] = sh->dev[i].offset;
 			blocks[count++] = sh->dev[i].page;
 		}
 
 		init_async_submit(&submit, ASYNC_TX_FENCE|ASYNC_TX_XOR_ZERO_DST,
 				  NULL, ops_complete_compute, sh,
 				  to_addr_conv(sh, percpu, 0));
-		tx = async_xor(dest, blocks, 0, count,
-				conf->stripe_size, &submit);
+		tx = async_xor_offsets(dest, dest_off, blocks, offs,
+				count, conf->stripe_size, &submit);
 	}
 
 	return tx;
@@ -1650,6 +1663,7 @@ ops_run_compute6_2(struct stripe_head *sh, struct raid5_percpu *percpu)
 	struct r5dev *tgt2 = &sh->dev[target2];
 	struct dma_async_tx_descriptor *tx;
 	struct page **blocks = to_addr_page(percpu, 0);
+	unsigned int *offs = to_addr_offs(sh, percpu);
 	struct async_submit_ctl submit;
 	struct r5conf *conf = sh->raid_conf;
 
@@ -1670,6 +1684,7 @@ ops_run_compute6_2(struct stripe_head *sh, struct raid5_percpu *percpu)
 	do {
 		int slot = raid6_idx_to_slot(i, sh, &count, syndrome_disks);
 
+		offs[slot] = sh->dev[i].offset;
 		blocks[slot] = sh->dev[i].page;
 
 		if (i == target)
@@ -1694,10 +1709,12 @@ ops_run_compute6_2(struct stripe_head *sh, struct raid5_percpu *percpu)
 			init_async_submit(&submit, ASYNC_TX_FENCE, NULL,
 					  ops_complete_compute, sh,
 					  to_addr_conv(sh, percpu, 0));
-			return async_gen_syndrome(blocks, 0, syndrome_disks+2,
-						  conf->stripe_size, &submit);
+			return async_gen_syndrome(blocks, offs,
+					syndrome_disks+2,
+					conf->stripe_size, &submit);
 		} else {
 			struct page *dest;
+			unsigned int dest_off;
 			int data_target;
 			int qd_idx = sh->qd_idx;
 
@@ -1711,21 +1728,24 @@ ops_run_compute6_2(struct stripe_head *sh, struct raid5_percpu *percpu)
 			for (i = disks; i-- ; ) {
 				if (i == data_target || i == qd_idx)
 					continue;
+				offs[count] = sh->dev[i].offset;
 				blocks[count++] = sh->dev[i].page;
 			}
 			dest = sh->dev[data_target].page;
+			dest_off = sh->dev[data_target].offset;
 			init_async_submit(&submit,
 					  ASYNC_TX_FENCE|ASYNC_TX_XOR_ZERO_DST,
 					  NULL, NULL, NULL,
 					  to_addr_conv(sh, percpu, 0));
-			tx = async_xor(dest, blocks, 0, count,
-					conf->stripe_size, &submit);
+			tx = async_xor_offsets(dest, dest_off, blocks, offs,
+					count, conf->stripe_size, &submit);
 
-			count = set_syndrome_sources(blocks, sh, SYNDROME_SRC_ALL);
+			count = set_syndrome_sources(blocks, offs,
+					sh, SYNDROME_SRC_ALL);
 			init_async_submit(&submit, ASYNC_TX_FENCE, tx,
 					  ops_complete_compute, sh,
 					  to_addr_conv(sh, percpu, 0));
-			return async_gen_syndrome(blocks, 0, count+2,
+			return async_gen_syndrome(blocks, offs, count+2,
 						  conf->stripe_size, &submit);
 		}
 	} else {
@@ -1736,13 +1756,13 @@ ops_run_compute6_2(struct stripe_head *sh, struct raid5_percpu *percpu)
 			/* We're missing D+P. */
 			return async_raid6_datap_recov(syndrome_disks+2,
 						       conf->stripe_size, faila,
-						       blocks, &submit);
+						       blocks, offs, &submit);
 		} else {
 			/* We're missing D+D. */
 			return async_raid6_2data_recov(syndrome_disks+2,
 						       conf->stripe_size,
 						       faila, failb,
-						       blocks, &submit);
+						       blocks, offs, &submit);
 		}
 	}
 }
@@ -1810,6 +1830,7 @@ ops_run_prexor6(struct stripe_head *sh, struct raid5_percpu *percpu,
 		struct dma_async_tx_descriptor *tx)
 {
 	struct page **blocks = to_addr_page(percpu, 0);
+	unsigned int *offs = to_addr_offs(sh, percpu);
 	int count;
 	struct async_submit_ctl submit;
 	struct r5conf *conf = sh->raid_conf;
@@ -1817,12 +1838,12 @@ ops_run_prexor6(struct stripe_head *sh, struct raid5_percpu *percpu,
 	pr_debug("%s: stripe %llu\n", __func__,
 		(unsigned long long)sh->sector);
 
-	count = set_syndrome_sources(blocks, sh, SYNDROME_SRC_WANT_DRAIN);
+	count = set_syndrome_sources(blocks, offs, sh, SYNDROME_SRC_WANT_DRAIN);
 
 	init_async_submit(&submit, ASYNC_TX_FENCE|ASYNC_TX_PQ_XOR_DST, tx,
 			  ops_complete_prexor, sh, to_addr_conv(sh, percpu, 0));
-	tx = async_gen_syndrome(blocks, 0, count+2,
-				conf->stripe_size, &submit);
+	tx = async_gen_syndrome(blocks, offs, count+2,
+				conf->stripe_size,  &submit);
 
 	return tx;
 }
@@ -2054,6 +2075,7 @@ ops_run_reconstruct6(struct stripe_head *sh, struct raid5_percpu *percpu,
 {
 	struct async_submit_ctl submit;
 	struct page **blocks;
+	unsigned int *offs;
 	int count, i, j = 0;
 	struct stripe_head *head_sh = sh;
 	int last_stripe;
@@ -2079,6 +2101,7 @@ ops_run_reconstruct6(struct stripe_head *sh, struct raid5_percpu *percpu,
 
 again:
 	blocks = to_addr_page(percpu, j);
+	offs = to_addr_offs(sh, percpu);
 
 	if (sh->reconstruct_state == reconstruct_state_prexor_drain_run) {
 		synflags = SYNDROME_SRC_WRITTEN;
@@ -2088,7 +2111,7 @@ ops_run_reconstruct6(struct stripe_head *sh, struct raid5_percpu *percpu,
 		txflags = ASYNC_TX_ACK;
 	}
 
-	count = set_syndrome_sources(blocks, sh, synflags);
+	count = set_syndrome_sources(blocks, offs, sh, synflags);
 	last_stripe = !head_sh->batch_head ||
 		list_first_entry(&sh->batch_list,
 				 struct stripe_head, batch_list) == head_sh;
@@ -2100,8 +2123,8 @@ ops_run_reconstruct6(struct stripe_head *sh, struct raid5_percpu *percpu,
 	} else
 		init_async_submit(&submit, 0, tx, NULL, NULL,
 				  to_addr_conv(sh, percpu, j));
-	tx = async_gen_syndrome(blocks, 0, count+2,
-				conf->stripe_size, &submit);
+	tx = async_gen_syndrome(blocks, offs, count+2,
+				conf->stripe_size,  &submit);
 	if (!last_stripe) {
 		j++;
 		sh = list_first_entry(&sh->batch_list, struct stripe_head,
@@ -2168,6 +2191,7 @@ static void ops_run_check_p(struct stripe_head *sh, struct raid5_percpu *percpu)
 static void ops_run_check_pq(struct stripe_head *sh, struct raid5_percpu *percpu, int checkp)
 {
 	struct page **srcs = to_addr_page(percpu, 0);
+	unsigned int *offs = to_addr_offs(sh, percpu);
 	struct async_submit_ctl submit;
 	int count;
 	struct r5conf *conf = sh->raid_conf;
@@ -2176,15 +2200,16 @@ static void ops_run_check_pq(struct stripe_head *sh, struct raid5_percpu *percpu
 		(unsigned long long)sh->sector, checkp);
 
 	BUG_ON(sh->batch_head);
-	count = set_syndrome_sources(srcs, sh, SYNDROME_SRC_ALL);
+	count = set_syndrome_sources(srcs, offs, sh, SYNDROME_SRC_ALL);
 	if (!checkp)
 		srcs[count] = NULL;
 
 	atomic_inc(&sh->count);
 	init_async_submit(&submit, ASYNC_TX_ACK, NULL, ops_complete_check,
 			  sh, to_addr_conv(sh, percpu, 0));
-	async_syndrome_val(srcs, 0, count+2, conf->stripe_size,
-			   &sh->ops.zero_sum_result, percpu->spare_page, &submit);
+	async_syndrome_val(srcs, offs, count+2, conf->stripe_size,
+			   &sh->ops.zero_sum_result,
+			   percpu->spare_page, 0, &submit);
 }
 
 static void raid_run_ops(struct stripe_head *sh, unsigned long ops_request)
-- 
2.25.4
