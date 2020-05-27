From: Yufen Yu <yuyufen@huawei.com>
Subject: [PATCH v3 10/11] md/raid6: compute syndrome with correct page offset
Date: Wed, 27 May 2020 21:19:32 +0800
Message-ID: <20200527131933.34400-11-yuyufen@huawei.com>
References: <20200527131933.34400-1-yuyufen@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200527131933.34400-1-yuyufen@huawei.com>
Sender: linux-raid-owner@vger.kernel.org
To: song@kernel.org
Cc: linux-raid@vger.kernel.org, neilb@suse.com, guoqing.jiang@cloud.ionos.com, colyli@suse.de, xni@redhat.com, houtao1@huawei.com, yuyufen@huawei.com
List-Id: linux-raid.ids

When raid6 compute syndrome, the pages address will be passed to computer
function. After trying to support shared page between multiple sh->dev,
we also need to let computor know the correct location of each page.

Signed-off-by: Yufen Yu <yuyufen@huawei.com>
---
 drivers/md/raid5.c | 63 +++++++++++++++++++++++++++++++++-------------
 1 file changed, 45 insertions(+), 18 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 1a59c1db96ff..5a886951b8b4 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1520,6 +1520,7 @@ ops_run_compute5(struct stripe_head *sh, struct raid5_percpu *percpu)
 
 /* set_syndrome_sources - populate source buffers for gen_syndrome
  * @srcs - (struct page *) array of size sh->disks
+ * @offs - (unsigned int) array of offset for each page
  * @sh - stripe_head to parse
  *
  * Populates srcs in proper layout order for the stripe and returns the
@@ -1528,6 +1529,7 @@ ops_run_compute5(struct stripe_head *sh, struct raid5_percpu *percpu)
  * is recorded in srcs[count+1]].
  */
 static int set_syndrome_sources(struct page **srcs,
+				unsigned int *offs,
 				struct stripe_head *sh,
 				int srctype)
 {
@@ -1558,6 +1560,12 @@ static int set_syndrome_sources(struct page **srcs,
 				srcs[slot] = sh->dev[i].orig_page;
 			else
 				srcs[slot] = sh->dev[i].page;
+			/*
+			 * For orig_page, PAGE_SIZE must be 4KB and will
+			 * not use r5pages. In that case, dev[i].offset
+			 * is 0. So we can also use the value directly.
+			 */
+			offs[slot] = sh->dev[i].offset;
 		}
 		i = raid6_next_disk(i, disks);
 	} while (i != d0_idx);
@@ -1570,12 +1578,14 @@ ops_run_compute6_1(struct stripe_head *sh, struct raid5_percpu *percpu)
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
 
@@ -1594,30 +1604,35 @@ ops_run_compute6_1(struct stripe_head *sh, struct raid5_percpu *percpu)
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
-		tx = async_gen_syndrome(blocks, 0, count+2, STRIPE_SIZE, &submit);
+		tx = async_gen_syndrome(blocks, offs,
+					count+2, STRIPE_SIZE, &submit);
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
-		tx = async_xor(dest, blocks, 0, count, STRIPE_SIZE, &submit);
+		tx = async_xor_offsets(dest, dest_off, blocks, offs,
+				count, STRIPE_SIZE, &submit);
 	}
 
 	return tx;
@@ -1636,6 +1651,8 @@ ops_run_compute6_2(struct stripe_head *sh, struct raid5_percpu *percpu)
 	struct r5dev *tgt2 = &sh->dev[target2];
 	struct dma_async_tx_descriptor *tx;
 	struct page **blocks = to_addr_page(percpu, 0);
+	unsigned int *offs = to_addr_offs(sh, percpu);
+
 	struct async_submit_ctl submit;
 
 	BUG_ON(sh->batch_head);
@@ -1655,6 +1672,7 @@ ops_run_compute6_2(struct stripe_head *sh, struct raid5_percpu *percpu)
 	do {
 		int slot = raid6_idx_to_slot(i, sh, &count, syndrome_disks);
 
+		offs[slot] = sh->dev[i].offset;
 		blocks[slot] = sh->dev[i].page;
 
 		if (i == target)
@@ -1679,10 +1697,11 @@ ops_run_compute6_2(struct stripe_head *sh, struct raid5_percpu *percpu)
 			init_async_submit(&submit, ASYNC_TX_FENCE, NULL,
 					  ops_complete_compute, sh,
 					  to_addr_conv(sh, percpu, 0));
-			return async_gen_syndrome(blocks, 0, syndrome_disks+2,
-						  STRIPE_SIZE, &submit);
+			return async_gen_syndrome(blocks, offs,
+					syndrome_disks+2, STRIPE_SIZE, &submit);
 		} else {
 			struct page *dest;
+			unsigned int dest_off;
 			int data_target;
 			int qd_idx = sh->qd_idx;
 
@@ -1696,21 +1715,24 @@ ops_run_compute6_2(struct stripe_head *sh, struct raid5_percpu *percpu)
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
-			tx = async_xor(dest, blocks, 0, count, STRIPE_SIZE,
-				       &submit);
+			tx = async_xor_offsets(dest, dest_off, blocks, offs,
+					count, STRIPE_SIZE, &submit);
 
-			count = set_syndrome_sources(blocks, sh, SYNDROME_SRC_ALL);
+			count = set_syndrome_sources(blocks, offs,
+					sh, SYNDROME_SRC_ALL);
 			init_async_submit(&submit, ASYNC_TX_FENCE, tx,
 					  ops_complete_compute, sh,
 					  to_addr_conv(sh, percpu, 0));
-			return async_gen_syndrome(blocks, 0, count+2,
+			return async_gen_syndrome(blocks, offs, count+2,
 						  STRIPE_SIZE, &submit);
 		}
 	} else {
@@ -1721,12 +1743,12 @@ ops_run_compute6_2(struct stripe_head *sh, struct raid5_percpu *percpu)
 			/* We're missing D+P. */
 			return async_raid6_datap_recov(syndrome_disks+2,
 						       STRIPE_SIZE, faila,
-						       blocks, &submit);
+						       blocks, offs, &submit);
 		} else {
 			/* We're missing D+D. */
 			return async_raid6_2data_recov(syndrome_disks+2,
 						       STRIPE_SIZE, faila, failb,
-						       blocks, &submit);
+						       blocks, offs, &submit);
 		}
 	}
 }
@@ -1793,17 +1815,18 @@ ops_run_prexor6(struct stripe_head *sh, struct raid5_percpu *percpu,
 		struct dma_async_tx_descriptor *tx)
 {
 	struct page **blocks = to_addr_page(percpu, 0);
+	unsigned int *offs = to_addr_offs(sh, percpu);
 	int count;
 	struct async_submit_ctl submit;
 
 	pr_debug("%s: stripe %llu\n", __func__,
 		(unsigned long long)sh->sector);
 
-	count = set_syndrome_sources(blocks, sh, SYNDROME_SRC_WANT_DRAIN);
+	count = set_syndrome_sources(blocks, offs, sh, SYNDROME_SRC_WANT_DRAIN);
 
 	init_async_submit(&submit, ASYNC_TX_FENCE|ASYNC_TX_PQ_XOR_DST, tx,
 			  ops_complete_prexor, sh, to_addr_conv(sh, percpu, 0));
-	tx = async_gen_syndrome(blocks, 0, count+2, STRIPE_SIZE,  &submit);
+	tx = async_gen_syndrome(blocks, offs, count+2, STRIPE_SIZE,  &submit);
 
 	return tx;
 }
@@ -2035,6 +2058,7 @@ ops_run_reconstruct6(struct stripe_head *sh, struct raid5_percpu *percpu,
 {
 	struct async_submit_ctl submit;
 	struct page **blocks;
+	unsigned int *offs;
 	int count, i, j = 0;
 	struct stripe_head *head_sh = sh;
 	int last_stripe;
@@ -2059,6 +2083,7 @@ ops_run_reconstruct6(struct stripe_head *sh, struct raid5_percpu *percpu,
 
 again:
 	blocks = to_addr_page(percpu, j);
+	offs = to_addr_offs(sh, percpu);
 
 	if (sh->reconstruct_state == reconstruct_state_prexor_drain_run) {
 		synflags = SYNDROME_SRC_WRITTEN;
@@ -2068,7 +2093,7 @@ ops_run_reconstruct6(struct stripe_head *sh, struct raid5_percpu *percpu,
 		txflags = ASYNC_TX_ACK;
 	}
 
-	count = set_syndrome_sources(blocks, sh, synflags);
+	count = set_syndrome_sources(blocks, offs, sh, synflags);
 	last_stripe = !head_sh->batch_head ||
 		list_first_entry(&sh->batch_list,
 				 struct stripe_head, batch_list) == head_sh;
@@ -2080,7 +2105,7 @@ ops_run_reconstruct6(struct stripe_head *sh, struct raid5_percpu *percpu,
 	} else
 		init_async_submit(&submit, 0, tx, NULL, NULL,
 				  to_addr_conv(sh, percpu, j));
-	tx = async_gen_syndrome(blocks, 0, count+2, STRIPE_SIZE,  &submit);
+	tx = async_gen_syndrome(blocks, offs, count+2, STRIPE_SIZE,  &submit);
 	if (!last_stripe) {
 		j++;
 		sh = list_first_entry(&sh->batch_list, struct stripe_head,
@@ -2145,6 +2170,7 @@ static void ops_run_check_p(struct stripe_head *sh, struct raid5_percpu *percpu)
 static void ops_run_check_pq(struct stripe_head *sh, struct raid5_percpu *percpu, int checkp)
 {
 	struct page **srcs = to_addr_page(percpu, 0);
+	unsigned int *offs = to_addr_offs(sh, percpu);
 	struct async_submit_ctl submit;
 	int count;
 
@@ -2152,15 +2178,16 @@ static void ops_run_check_pq(struct stripe_head *sh, struct raid5_percpu *percpu
 		(unsigned long long)sh->sector, checkp);
 
 	BUG_ON(sh->batch_head);
-	count = set_syndrome_sources(srcs, sh, SYNDROME_SRC_ALL);
+	count = set_syndrome_sources(srcs, offs, sh, SYNDROME_SRC_ALL);
 	if (!checkp)
 		srcs[count] = NULL;
 
 	atomic_inc(&sh->count);
 	init_async_submit(&submit, ASYNC_TX_ACK, NULL, ops_complete_check,
 			  sh, to_addr_conv(sh, percpu, 0));
-	async_syndrome_val(srcs, 0, count+2, STRIPE_SIZE,
-			   &sh->ops.zero_sum_result, percpu->spare_page, &submit);
+	async_syndrome_val(srcs, offs, count+2, STRIPE_SIZE,
+			   &sh->ops.zero_sum_result,
+			   percpu->spare_page, 0, &submit);
 }
 
 static void raid_run_ops(struct stripe_head *sh, unsigned long ops_request)
-- 
2.21.3
