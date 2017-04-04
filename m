From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: [PATCH 4/4] raid5-ppl: partial parity calculation optimization
Date: Tue,  4 Apr 2017 13:13:58 +0200
Message-ID: <20170404111358.14829-5-artur.paszkiewicz@intel.com>
References: <20170404111358.14829-1-artur.paszkiewicz@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170404111358.14829-1-artur.paszkiewicz@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: shli@kernel.org
Cc: linux-raid@vger.kernel.org, Artur Paszkiewicz <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

In case of read-modify-write, partial partity is the same as the result
of ops_run_prexor5(), so we can just copy sh->dev[pd_idx].page into
sh->ppl_page instead of calculating it again.

Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
---
 drivers/md/raid5-ppl.c | 20 ++++++++++----------
 drivers/md/raid5.c     |  6 +++---
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/md/raid5-ppl.c b/drivers/md/raid5-ppl.c
index e938669810c4..6fef999f2150 100644
--- a/drivers/md/raid5-ppl.c
+++ b/drivers/md/raid5-ppl.c
@@ -152,7 +152,7 @@ ops_run_partial_parity(struct stripe_head *sh, struct raid5_percpu *percpu,
 		       struct dma_async_tx_descriptor *tx)
 {
 	int disks = sh->disks;
-	struct page **xor_srcs = flex_array_get(percpu->scribble, 0);
+	struct page **srcs = flex_array_get(percpu->scribble, 0);
 	int count = 0, pd_idx = sh->pd_idx, i;
 	struct async_submit_ctl submit;
 
@@ -165,18 +165,18 @@ ops_run_partial_parity(struct stripe_head *sh, struct raid5_percpu *percpu,
 	 * differently.
 	 */
 	if (sh->reconstruct_state == reconstruct_state_prexor_drain_run) {
-		/* rmw: xor old data and parity from updated disks */
-		for (i = disks; i--;) {
-			struct r5dev *dev = &sh->dev[i];
-			if (test_bit(R5_Wantdrain, &dev->flags) || i == pd_idx)
-				xor_srcs[count++] = dev->page;
-		}
+		/*
+		 * rmw: xor old data and parity from updated disks
+		 * This is calculated earlier by ops_run_prexor5() so just copy
+		 * the parity dev page.
+		 */
+		srcs[count++] = sh->dev[pd_idx].page;
 	} else if (sh->reconstruct_state == reconstruct_state_drain_run) {
 		/* rcw: xor data from all not updated disks */
 		for (i = disks; i--;) {
 			struct r5dev *dev = &sh->dev[i];
 			if (test_bit(R5_UPTODATE, &dev->flags))
-				xor_srcs[count++] = dev->page;
+				srcs[count++] = dev->page;
 		}
 	} else {
 		return tx;
@@ -187,10 +187,10 @@ ops_run_partial_parity(struct stripe_head *sh, struct raid5_percpu *percpu,
 			  + sizeof(struct page *) * (sh->disks + 2));
 
 	if (count == 1)
-		tx = async_memcpy(sh->ppl_page, xor_srcs[0], 0, 0, PAGE_SIZE,
+		tx = async_memcpy(sh->ppl_page, srcs[0], 0, 0, PAGE_SIZE,
 				  &submit);
 	else
-		tx = async_xor(sh->ppl_page, xor_srcs, 0, count, PAGE_SIZE,
+		tx = async_xor(sh->ppl_page, srcs, 0, count, PAGE_SIZE,
 			       &submit);
 
 	return tx;
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 9cab2fe078c2..f99a12f50f9a 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2079,9 +2079,6 @@ static void raid_run_ops(struct stripe_head *sh, unsigned long ops_request)
 			async_tx_ack(tx);
 	}
 
-	if (test_bit(STRIPE_OP_PARTIAL_PARITY, &ops_request))
-		tx = ops_run_partial_parity(sh, percpu, tx);
-
 	if (test_bit(STRIPE_OP_PREXOR, &ops_request)) {
 		if (level < 6)
 			tx = ops_run_prexor5(sh, percpu, tx);
@@ -2089,6 +2086,9 @@ static void raid_run_ops(struct stripe_head *sh, unsigned long ops_request)
 			tx = ops_run_prexor6(sh, percpu, tx);
 	}
 
+	if (test_bit(STRIPE_OP_PARTIAL_PARITY, &ops_request))
+		tx = ops_run_partial_parity(sh, percpu, tx);
+
 	if (test_bit(STRIPE_OP_BIODRAIN, &ops_request)) {
 		tx = ops_run_biodrain(sh, tx);
 		overlap_clear++;
-- 
2.11.0

