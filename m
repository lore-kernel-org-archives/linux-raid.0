From: Yufen Yu <yuyufen@huawei.com>
Subject: [PATCH v3 08/11] md/raid5: compute xor with correct page offset
Date: Wed, 27 May 2020 21:19:30 +0800
Message-ID: <20200527131933.34400-9-yuyufen@huawei.com>
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

When compute xor, the pages address will be passed to computer function.
After trying to use pages in r5pages, we also need to pass page offset
to let it know correct location of each page.

For now raid5-cache and raid5-ppl are supported only when PAGE_SIZE is
equal to 4096. In that case, shared pages will not be supported and
dev->offset is '0'. So, we can use that value directly.

Signed-off-by: Yufen Yu <yuyufen@huawei.com>
---
 drivers/md/raid5.c | 64 ++++++++++++++++++++++++++++++++++++----------
 1 file changed, 51 insertions(+), 13 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index b97ebc7b5747..1a59c1db96ff 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1481,6 +1481,7 @@ ops_run_compute5(struct stripe_head *sh, struct raid5_percpu *percpu)
 {
 	int disks = sh->disks;
 	struct page **xor_srcs = to_addr_page(percpu, 0);
+	unsigned int *offs = to_addr_offs(sh, percpu);
 	int target = sh->ops.target;
 	struct r5dev *tgt = &sh->dev[target];
 	struct page *xor_dest = tgt->page;
@@ -1488,6 +1489,7 @@ ops_run_compute5(struct stripe_head *sh, struct raid5_percpu *percpu)
 	struct dma_async_tx_descriptor *tx;
 	struct async_submit_ctl submit;
 	int i;
+	unsigned int des_offset = tgt->offset;
 
 	BUG_ON(sh->batch_head);
 
@@ -1495,18 +1497,23 @@ ops_run_compute5(struct stripe_head *sh, struct raid5_percpu *percpu)
 		__func__, (unsigned long long)sh->sector, target);
 	BUG_ON(!test_bit(R5_Wantcompute, &tgt->flags));
 
-	for (i = disks; i--; )
-		if (i != target)
+	for (i = disks; i--; ) {
+		if (i != target) {
+			offs[count] = sh->dev[i].offset;
 			xor_srcs[count++] = sh->dev[i].page;
+		}
+	}
 
 	atomic_inc(&sh->count);
 
 	init_async_submit(&submit, ASYNC_TX_FENCE|ASYNC_TX_XOR_ZERO_DST, NULL,
 			  ops_complete_compute, sh, to_addr_conv(sh, percpu, 0));
 	if (unlikely(count == 1))
-		tx = async_memcpy(xor_dest, xor_srcs[0], 0, 0, STRIPE_SIZE, &submit);
+		tx = async_memcpy(xor_dest, xor_srcs[0], des_offset, offs[0],
+				STRIPE_SIZE, &submit);
 	else
-		tx = async_xor(xor_dest, xor_srcs, 0, count, STRIPE_SIZE, &submit);
+		tx = async_xor_offsets(xor_dest, des_offset, xor_srcs, offs,
+				count, STRIPE_SIZE, &submit);
 
 	return tx;
 }
@@ -1745,10 +1752,12 @@ ops_run_prexor5(struct stripe_head *sh, struct raid5_percpu *percpu,
 {
 	int disks = sh->disks;
 	struct page **xor_srcs = to_addr_page(percpu, 0);
+	unsigned int *offs = to_addr_offs(sh, percpu);
 	int count = 0, pd_idx = sh->pd_idx, i;
 	struct async_submit_ctl submit;
 
 	/* existing parity data subtracted */
+	unsigned int des_offset = offs[count] = sh->dev[pd_idx].offset;
 	struct page *xor_dest = xor_srcs[count++] = sh->dev[pd_idx].page;
 
 	BUG_ON(sh->batch_head);
@@ -1758,15 +1767,23 @@ ops_run_prexor5(struct stripe_head *sh, struct raid5_percpu *percpu,
 	for (i = disks; i--; ) {
 		struct r5dev *dev = &sh->dev[i];
 		/* Only process blocks that are known to be uptodate */
-		if (test_bit(R5_InJournal, &dev->flags))
+		if (test_bit(R5_InJournal, &dev->flags)) {
+			/*
+			 * For this case, PAGE_SIZE must be 4KB and will not
+			 * use r5pages. So dev->offset is zero.
+			 */
+			offs[count] = dev->offset;
 			xor_srcs[count++] = dev->orig_page;
-		else if (test_bit(R5_Wantdrain, &dev->flags))
+		} else if (test_bit(R5_Wantdrain, &dev->flags)) {
+			offs[count] = dev->offset;
 			xor_srcs[count++] = dev->page;
+		}
 	}
 
 	init_async_submit(&submit, ASYNC_TX_FENCE|ASYNC_TX_XOR_DROP_DST, tx,
 			  ops_complete_prexor, sh, to_addr_conv(sh, percpu, 0));
-	tx = async_xor(xor_dest, xor_srcs, 0, count, STRIPE_SIZE, &submit);
+	tx = async_xor_offsets(xor_dest, des_offset, xor_srcs, offs,
+			count, STRIPE_SIZE, &submit);
 
 	return tx;
 }
@@ -1916,6 +1933,7 @@ ops_run_reconstruct5(struct stripe_head *sh, struct raid5_percpu *percpu,
 {
 	int disks = sh->disks;
 	struct page **xor_srcs;
+	unsigned int *offs;
 	struct async_submit_ctl submit;
 	int count, pd_idx = sh->pd_idx, i;
 	struct page *xor_dest;
@@ -1924,6 +1942,7 @@ ops_run_reconstruct5(struct stripe_head *sh, struct raid5_percpu *percpu,
 	int j = 0;
 	struct stripe_head *head_sh = sh;
 	int last_stripe;
+	unsigned int des_offset;
 
 	pr_debug("%s: stripe %llu\n", __func__,
 		(unsigned long long)sh->sector);
@@ -1940,27 +1959,37 @@ ops_run_reconstruct5(struct stripe_head *sh, struct raid5_percpu *percpu,
 		ops_complete_reconstruct(sh);
 		return;
 	}
+
 again:
 	count = 0;
 	xor_srcs = to_addr_page(percpu, j);
+	offs = to_addr_offs(sh, percpu);
 	/* check if prexor is active which means only process blocks
 	 * that are part of a read-modify-write (written)
 	 */
 	if (head_sh->reconstruct_state == reconstruct_state_prexor_drain_run) {
 		prexor = 1;
+		des_offset = offs[count] = sh->dev[pd_idx].offset;
 		xor_dest = xor_srcs[count++] = sh->dev[pd_idx].page;
+
 		for (i = disks; i--; ) {
 			struct r5dev *dev = &sh->dev[i];
 			if (head_sh->dev[i].written ||
-			    test_bit(R5_InJournal, &head_sh->dev[i].flags))
+			    test_bit(R5_InJournal, &head_sh->dev[i].flags)) {
+				offs[count] = dev->offset;
 				xor_srcs[count++] = dev->page;
+			}
 		}
 	} else {
 		xor_dest = sh->dev[pd_idx].page;
+		des_offset = sh->dev[pd_idx].offset;
+
 		for (i = disks; i--; ) {
 			struct r5dev *dev = &sh->dev[i];
-			if (i != pd_idx)
+			if (i != pd_idx) {
+				offs[count] = dev->offset;
 				xor_srcs[count++] = dev->page;
+			}
 		}
 	}
 
@@ -1986,9 +2015,12 @@ ops_run_reconstruct5(struct stripe_head *sh, struct raid5_percpu *percpu,
 	}
 
 	if (unlikely(count == 1))
-		tx = async_memcpy(xor_dest, xor_srcs[0], 0, 0, STRIPE_SIZE, &submit);
+		tx = async_memcpy(xor_dest, xor_srcs[0], des_offset,
+				offs[0], STRIPE_SIZE, &submit);
 	else
-		tx = async_xor(xor_dest, xor_srcs, 0, count, STRIPE_SIZE, &submit);
+		tx = async_xor_offsets(xor_dest, des_offset, xor_srcs,
+				offs, count, STRIPE_SIZE, &submit);
+
 	if (!last_stripe) {
 		j++;
 		sh = list_first_entry(&sh->batch_list, struct stripe_head,
@@ -2076,10 +2108,12 @@ static void ops_run_check_p(struct stripe_head *sh, struct raid5_percpu *percpu)
 	int qd_idx = sh->qd_idx;
 	struct page *xor_dest;
 	struct page **xor_srcs = to_addr_page(percpu, 0);
+	unsigned int *offs = to_addr_offs(sh, percpu);
 	struct dma_async_tx_descriptor *tx;
 	struct async_submit_ctl submit;
 	int count;
 	int i;
+	unsigned int dest_offset;
 
 	pr_debug("%s: stripe %llu\n", __func__,
 		(unsigned long long)sh->sector);
@@ -2087,17 +2121,21 @@ static void ops_run_check_p(struct stripe_head *sh, struct raid5_percpu *percpu)
 	BUG_ON(sh->batch_head);
 	count = 0;
 	xor_dest = sh->dev[pd_idx].page;
+	dest_offset = sh->dev[pd_idx].offset;
+	offs[count] = dest_offset;
 	xor_srcs[count++] = xor_dest;
+
 	for (i = disks; i--; ) {
 		if (i == pd_idx || i == qd_idx)
 			continue;
+		offs[count] = sh->dev[i].offset;
 		xor_srcs[count++] = sh->dev[i].page;
 	}
 
 	init_async_submit(&submit, 0, NULL, NULL, NULL,
 			  to_addr_conv(sh, percpu, 0));
-	tx = async_xor_val(xor_dest, xor_srcs, 0, count, STRIPE_SIZE,
-			   &sh->ops.zero_sum_result, &submit);
+	tx = async_xor_val_offsets(xor_dest, dest_offset, xor_srcs, offs,
+			count, STRIPE_SIZE, &sh->ops.zero_sum_result, &submit);
 
 	atomic_inc(&sh->count);
 	init_async_submit(&submit, ASYNC_TX_ACK, tx, ops_complete_check, sh, NULL);
-- 
2.21.3
