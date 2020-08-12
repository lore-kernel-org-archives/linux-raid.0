From: Yufen Yu <yuyufen@huawei.com>
Subject: [PATCH 08/12] md/raid6: convert to new syndrome and recovery interface
Date: Wed, 12 Aug 2020 08:49:27 -0400
Message-ID: <20200812124931.2584743-9-yuyufen@huawei.com>
References: <20200812124931.2584743-1-yuyufen@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200812124931.2584743-1-yuyufen@huawei.com>
Sender: linux-raid-owner@vger.kernel.org
To: song@kernel.org
Cc: linux-raid@vger.kernel.org, neilb@suse.com, guoqing.jiang@cloud.ionos.com, houtao1@huawei.com, yuyufen@huawei.com
List-Id: linux-raid.ids

We try to adpate raid6 with the new compution interface.

Signed-off-by: Yufen Yu <yuyufen@huawei.com>
---
 drivers/md/raid5.c | 53 ++++++++++++++++++++++++++++++++--------------
 1 file changed, 37 insertions(+), 16 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 0d3475427965..dfe29d5fc9ad 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1459,6 +1459,7 @@ ops_run_compute5(struct stripe_head *sh, struct raid5_percpu *percpu)
 
 /* set_syndrome_sources - populate source buffers for gen_syndrome
  * @srcs - (struct page *) array of size sh->disks
+ * @offs - (unsigned int) array of offset for each page
  * @sh - stripe_head to parse
  *
  * Populates srcs in proper layout order for the stripe and returns the
@@ -1467,6 +1468,7 @@ ops_run_compute5(struct stripe_head *sh, struct raid5_percpu *percpu)
  * is recorded in srcs[count+1]].
  */
 static int set_syndrome_sources(struct page **srcs,
+				unsigned int *offs,
 				struct stripe_head *sh,
 				int srctype)
 {
@@ -1497,6 +1499,12 @@ static int set_syndrome_sources(struct page **srcs,
 				srcs[slot] = sh->dev[i].orig_page;
 			else
 				srcs[slot] = sh->dev[i].page;
+			/*
+			 * For R5_InJournal, PAGE_SIZE must be 4KB and will
+			 * not shared page. In that case, dev[i].offset
+			 * is 0.
+			 */
+			offs[slot] = sh->dev[i].offset;
 		}
 		i = raid6_next_disk(i, disks);
 	} while (i != d0_idx);
@@ -1509,12 +1517,14 @@ ops_run_compute6_1(struct stripe_head *sh, struct raid5_percpu *percpu)
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
 
@@ -1533,17 +1543,18 @@ ops_run_compute6_1(struct stripe_head *sh, struct raid5_percpu *percpu)
 	tgt = &sh->dev[target];
 	BUG_ON(!test_bit(R5_Wantcompute, &tgt->flags));
 	dest = tgt->page;
+	dest_off = tgt->offset;
 
 	atomic_inc(&sh->count);
 
 	if (target == qd_idx) {
-		count = set_syndrome_sources(blocks, sh, SYNDROME_SRC_ALL);
+		count = set_syndrome_sources(blocks, offs, sh, SYNDROME_SRC_ALL);
 		blocks[count] = NULL; /* regenerating p is not necessary */
 		BUG_ON(blocks[count+1] != dest); /* q should already be set */
 		init_async_submit(&submit, ASYNC_TX_FENCE, NULL,
 				  ops_complete_compute, sh,
 				  to_addr_conv(sh, percpu, 0));
-		tx = async_gen_syndrome(blocks, 0, count+2,
+		tx = async_gen_syndrome(blocks, offs, count+2,
 				RAID5_STRIPE_SIZE(sh->raid_conf), &submit);
 	} else {
 		/* Compute any data- or p-drive using XOR */
@@ -1551,13 +1562,14 @@ ops_run_compute6_1(struct stripe_head *sh, struct raid5_percpu *percpu)
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
+		tx = async_xor_offs(dest, dest_off, blocks, offs, count,
 				RAID5_STRIPE_SIZE(sh->raid_conf), &submit);
 	}
 
@@ -1577,6 +1589,7 @@ ops_run_compute6_2(struct stripe_head *sh, struct raid5_percpu *percpu)
 	struct r5dev *tgt2 = &sh->dev[target2];
 	struct dma_async_tx_descriptor *tx;
 	struct page **blocks = to_addr_page(percpu, 0);
+	unsigned int *offs = to_addr_offs(sh, percpu);
 	struct async_submit_ctl submit;
 
 	BUG_ON(sh->batch_head);
@@ -1596,6 +1609,7 @@ ops_run_compute6_2(struct stripe_head *sh, struct raid5_percpu *percpu)
 	do {
 		int slot = raid6_idx_to_slot(i, sh, &count, syndrome_disks);
 
+		offs[slot] = sh->dev[i].offset;
 		blocks[slot] = sh->dev[i].page;
 
 		if (i == target)
@@ -1620,11 +1634,12 @@ ops_run_compute6_2(struct stripe_head *sh, struct raid5_percpu *percpu)
 			init_async_submit(&submit, ASYNC_TX_FENCE, NULL,
 					  ops_complete_compute, sh,
 					  to_addr_conv(sh, percpu, 0));
-			return async_gen_syndrome(blocks, 0, syndrome_disks+2,
+			return async_gen_syndrome(blocks, offs, syndrome_disks+2,
 						  RAID5_STRIPE_SIZE(sh->raid_conf),
 						  &submit);
 		} else {
 			struct page *dest;
+			unsigned int dest_off;
 			int data_target;
 			int qd_idx = sh->qd_idx;
 
@@ -1638,22 +1653,24 @@ ops_run_compute6_2(struct stripe_head *sh, struct raid5_percpu *percpu)
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
+			tx = async_xor_offs(dest, dest_off, blocks, offs, count,
 				       RAID5_STRIPE_SIZE(sh->raid_conf),
 				       &submit);
 
-			count = set_syndrome_sources(blocks, sh, SYNDROME_SRC_ALL);
+			count = set_syndrome_sources(blocks, offs, sh, SYNDROME_SRC_ALL);
 			init_async_submit(&submit, ASYNC_TX_FENCE, tx,
 					  ops_complete_compute, sh,
 					  to_addr_conv(sh, percpu, 0));
-			return async_gen_syndrome(blocks, 0, count+2,
+			return async_gen_syndrome(blocks, offs, count+2,
 						  RAID5_STRIPE_SIZE(sh->raid_conf),
 						  &submit);
 		}
@@ -1666,13 +1683,13 @@ ops_run_compute6_2(struct stripe_head *sh, struct raid5_percpu *percpu)
 			return async_raid6_datap_recov(syndrome_disks+2,
 						RAID5_STRIPE_SIZE(sh->raid_conf),
 						faila,
-						blocks, &submit);
+						blocks, offs, &submit);
 		} else {
 			/* We're missing D+D. */
 			return async_raid6_2data_recov(syndrome_disks+2,
 						RAID5_STRIPE_SIZE(sh->raid_conf),
 						faila, failb,
-						blocks, &submit);
+						blocks, offs, &submit);
 		}
 	}
 }
@@ -1739,17 +1756,18 @@ ops_run_prexor6(struct stripe_head *sh, struct raid5_percpu *percpu,
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
-	tx = async_gen_syndrome(blocks, 0, count+2,
+	tx = async_gen_syndrome(blocks, offs, count+2,
 			RAID5_STRIPE_SIZE(sh->raid_conf), &submit);
 
 	return tx;
@@ -1978,6 +1996,7 @@ ops_run_reconstruct6(struct stripe_head *sh, struct raid5_percpu *percpu,
 {
 	struct async_submit_ctl submit;
 	struct page **blocks;
+	unsigned int *offs;
 	int count, i, j = 0;
 	struct stripe_head *head_sh = sh;
 	int last_stripe;
@@ -2002,6 +2021,7 @@ ops_run_reconstruct6(struct stripe_head *sh, struct raid5_percpu *percpu,
 
 again:
 	blocks = to_addr_page(percpu, j);
+	offs = to_addr_offs(sh, percpu);
 
 	if (sh->reconstruct_state == reconstruct_state_prexor_drain_run) {
 		synflags = SYNDROME_SRC_WRITTEN;
@@ -2011,7 +2031,7 @@ ops_run_reconstruct6(struct stripe_head *sh, struct raid5_percpu *percpu,
 		txflags = ASYNC_TX_ACK;
 	}
 
-	count = set_syndrome_sources(blocks, sh, synflags);
+	count = set_syndrome_sources(blocks, offs, sh, synflags);
 	last_stripe = !head_sh->batch_head ||
 		list_first_entry(&sh->batch_list,
 				 struct stripe_head, batch_list) == head_sh;
@@ -2023,7 +2043,7 @@ ops_run_reconstruct6(struct stripe_head *sh, struct raid5_percpu *percpu,
 	} else
 		init_async_submit(&submit, 0, tx, NULL, NULL,
 				  to_addr_conv(sh, percpu, j));
-	tx = async_gen_syndrome(blocks, 0, count+2,
+	tx = async_gen_syndrome(blocks, offs, count+2,
 			RAID5_STRIPE_SIZE(sh->raid_conf),  &submit);
 	if (!last_stripe) {
 		j++;
@@ -2089,6 +2109,7 @@ static void ops_run_check_p(struct stripe_head *sh, struct raid5_percpu *percpu)
 static void ops_run_check_pq(struct stripe_head *sh, struct raid5_percpu *percpu, int checkp)
 {
 	struct page **srcs = to_addr_page(percpu, 0);
+	unsigned int *offs = to_addr_offs(sh, percpu);
 	struct async_submit_ctl submit;
 	int count;
 
@@ -2096,16 +2117,16 @@ static void ops_run_check_pq(struct stripe_head *sh, struct raid5_percpu *percpu
 		(unsigned long long)sh->sector, checkp);
 
 	BUG_ON(sh->batch_head);
-	count = set_syndrome_sources(srcs, sh, SYNDROME_SRC_ALL);
+	count = set_syndrome_sources(srcs, offs, sh, SYNDROME_SRC_ALL);
 	if (!checkp)
 		srcs[count] = NULL;
 
 	atomic_inc(&sh->count);
 	init_async_submit(&submit, ASYNC_TX_ACK, NULL, ops_complete_check,
 			  sh, to_addr_conv(sh, percpu, 0));
-	async_syndrome_val(srcs, 0, count+2,
+	async_syndrome_val(srcs, offs, count+2,
 			   RAID5_STRIPE_SIZE(sh->raid_conf),
-			   &sh->ops.zero_sum_result, percpu->spare_page, &submit);
+			   &sh->ops.zero_sum_result, percpu->spare_page, 0, &submit);
 }
 
 static void raid_run_ops(struct stripe_head *sh, unsigned long ops_request)
-- 
2.25.4
