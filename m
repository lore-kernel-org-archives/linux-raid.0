From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: [PATCH v2 06/12] raid5-ppl: calculate partial parity
Date: Mon,  5 Dec 2016 16:31:07 +0100
Message-ID: <20161205153113.7268-7-artur.paszkiewicz@intel.com>
References: <20161205153113.7268-1-artur.paszkiewicz@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161205153113.7268-1-artur.paszkiewicz@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: shli@kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Partial parity is calculated as follows:

- reconstruct-write case:
  xor data from all not updated disks in a stripe

- read-modify-write case:
  xor old data and parity from all updated disks in a stripe

Implement it using the async_tx API and integrate into raid_run_ops().
It must be called when we still have access to old data, so do it when
STRIPE_OP_BIODRAIN is set, but before ops_run_prexor5(). The result is
stored into sh->ppl_page.

Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
---
 drivers/md/raid5.c | 75 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 75 insertions(+)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 77a503d3..2169de5 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1941,6 +1941,49 @@ static void ops_run_check_pq(struct stripe_head *sh, struct raid5_percpu *percpu
 			   &sh->ops.zero_sum_result, percpu->spare_page, &submit);
 }
 
+static struct dma_async_tx_descriptor *
+ops_run_partial_parity(struct stripe_head *sh, struct raid5_percpu *percpu,
+		       struct dma_async_tx_descriptor *tx)
+{
+	int disks = sh->disks;
+	struct page **xor_srcs = flex_array_get(percpu->scribble, 0);
+	int count = 0, pd_idx = sh->pd_idx, i;
+	struct async_submit_ctl submit;
+
+	if (test_bit(STRIPE_FULL_WRITE, &sh->state))
+		return tx;
+
+	if (sh->reconstruct_state == reconstruct_state_prexor_drain_run) {
+		for (i = disks; i--;) {
+			struct r5dev *dev = &sh->dev[i];
+			if (test_bit(R5_Wantdrain, &dev->flags)
+					|| i == pd_idx)
+				xor_srcs[count++] = dev->page;
+		}
+	} else if (sh->reconstruct_state == reconstruct_state_drain_run) {
+		for (i = disks; i--;) {
+			struct r5dev *dev = &sh->dev[i];
+			if (test_bit(R5_UPTODATE, &dev->flags))
+				xor_srcs[count++] = dev->page;
+		}
+	} else {
+		return tx;
+	}
+
+	init_async_submit(&submit, ASYNC_TX_XOR_ZERO_DST, tx,
+			NULL, sh, flex_array_get(percpu->scribble, 0)
+				+ sizeof(struct page *) * (sh->disks + 2));
+
+	if (count == 1)
+		tx = async_memcpy(sh->ppl_page, xor_srcs[0], 0, 0, PAGE_SIZE,
+				&submit);
+	else
+		tx = async_xor(sh->ppl_page, xor_srcs, 0, count, PAGE_SIZE,
+				&submit);
+
+	return tx;
+}
+
 static void raid_run_ops(struct stripe_head *sh, unsigned long ops_request)
 {
 	int overlap_clear = 0, i, disks = sh->disks;
@@ -1971,6 +2014,11 @@ static void raid_run_ops(struct stripe_head *sh, unsigned long ops_request)
 			async_tx_ack(tx);
 	}
 
+	if (test_bit(STRIPE_OP_BIODRAIN, &ops_request) &&
+			test_bit(MD_HAS_PPL, &conf->mddev->flags) &&
+			conf->disks[sh->pd_idx].rdev)
+		tx = ops_run_partial_parity(sh, percpu, tx);
+
 	if (test_bit(STRIPE_OP_PREXOR, &ops_request)) {
 		if (level < 6)
 			tx = ops_run_prexor5(sh, percpu, tx);
@@ -3042,6 +3090,33 @@ static int add_stripe_bio(struct stripe_head *sh, struct bio *bi, int dd_idx,
 	if (*bip && (*bip)->bi_iter.bi_sector < bio_end_sector(bi))
 		goto overlap;
 
+	/*
+	 * PPL does not allow writes to different disks in the same stripe when
+	 * they are not next to each other. Not really an overlap, but
+	 * wait_for_overlap can be used to handle this.
+	 */
+	if (forwrite && test_bit(MD_HAS_PPL, &conf->mddev->flags)) {
+		int i;
+		int di = 0;
+		int first = -1, last = -1;
+		int count = 0;
+		for (i = 0; i < sh->disks; i++) {
+			if (i == sh->pd_idx)
+				continue;
+
+			if (sh->dev[i].towrite || i == dd_idx) {
+				count++;
+				if (first < 0)
+					first = di;
+				last = di;
+			}
+			di++;
+		}
+
+		if (last > first && (last - first > count - 1))
+			goto overlap;
+	}
+
 	if (!forwrite || previous)
 		clear_bit(STRIPE_BATCH_READY, &sh->state);
 
-- 
2.10.1

