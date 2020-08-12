From: Yufen Yu <yuyufen@huawei.com>
Subject: [PATCH 05/12] md/raid5: convert to new xor compution interface
Date: Wed, 12 Aug 2020 08:49:24 -0400
Message-ID: <20200812124931.2584743-6-yuyufen@huawei.com>
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

We try to replace async_xor() and async_xor_val() with the new
introduced interface async_xor_offs() and async_xor_val_offs()
for raid4/5.

Signed-off-by: Yufen Yu <yuyufen@huawei.com>
---
 drivers/md/raid5.c | 26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 4757d1b8f90d..0d3475427965 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1451,7 +1451,7 @@ ops_run_compute5(struct stripe_head *sh, struct raid5_percpu *percpu)
 		tx = async_memcpy(xor_dest, xor_srcs[0], off_dest, off_srcs[0],
 				RAID5_STRIPE_SIZE(sh->raid_conf), &submit);
 	else
-		tx = async_xor(xor_dest, xor_srcs, 0, count,
+		tx = async_xor_offs(xor_dest, off_dest, xor_srcs, off_srcs, count,
 				RAID5_STRIPE_SIZE(sh->raid_conf), &submit);
 
 	return tx;
@@ -1698,10 +1698,12 @@ ops_run_prexor5(struct stripe_head *sh, struct raid5_percpu *percpu,
 {
 	int disks = sh->disks;
 	struct page **xor_srcs = to_addr_page(percpu, 0);
+	unsigned int *off_srcs = to_addr_offs(sh, percpu);
 	int count = 0, pd_idx = sh->pd_idx, i;
 	struct async_submit_ctl submit;
 
 	/* existing parity data subtracted */
+	unsigned int off_dest = off_srcs[count] = sh->dev[pd_idx].offset;
 	struct page *xor_dest = xor_srcs[count++] = sh->dev[pd_idx].page;
 
 	BUG_ON(sh->batch_head);
@@ -1711,15 +1713,22 @@ ops_run_prexor5(struct stripe_head *sh, struct raid5_percpu *percpu,
 	for (i = disks; i--; ) {
 		struct r5dev *dev = &sh->dev[i];
 		/* Only process blocks that are known to be uptodate */
-		if (test_bit(R5_InJournal, &dev->flags))
+		if (test_bit(R5_InJournal, &dev->flags)) {
+			/*
+			 * For this case, PAGE_SIZE must be equal to 4KB and
+			 * page offset is zero.
+			 */
+			off_srcs[count] = dev->offset;
 			xor_srcs[count++] = dev->orig_page;
-		else if (test_bit(R5_Wantdrain, &dev->flags))
+		} else if (test_bit(R5_Wantdrain, &dev->flags)) {
+			off_srcs[count] = dev->offset;
 			xor_srcs[count++] = dev->page;
+		}
 	}
 
 	init_async_submit(&submit, ASYNC_TX_FENCE|ASYNC_TX_XOR_DROP_DST, tx,
 			  ops_complete_prexor, sh, to_addr_conv(sh, percpu, 0));
-	tx = async_xor(xor_dest, xor_srcs, 0, count,
+	tx = async_xor_offs(xor_dest, off_dest, xor_srcs, off_srcs, count,
 			RAID5_STRIPE_SIZE(sh->raid_conf), &submit);
 
 	return tx;
@@ -1953,7 +1962,7 @@ ops_run_reconstruct5(struct stripe_head *sh, struct raid5_percpu *percpu,
 		tx = async_memcpy(xor_dest, xor_srcs[0], off_dest, off_srcs[0],
 				RAID5_STRIPE_SIZE(sh->raid_conf), &submit);
 	else
-		tx = async_xor(xor_dest, xor_srcs, 0, count,
+		tx = async_xor_offs(xor_dest, off_dest, xor_srcs, off_srcs, count,
 				RAID5_STRIPE_SIZE(sh->raid_conf), &submit);
 	if (!last_stripe) {
 		j++;
@@ -2042,7 +2051,9 @@ static void ops_run_check_p(struct stripe_head *sh, struct raid5_percpu *percpu)
 	int pd_idx = sh->pd_idx;
 	int qd_idx = sh->qd_idx;
 	struct page *xor_dest;
+	unsigned int off_dest;
 	struct page **xor_srcs = to_addr_page(percpu, 0);
+	unsigned int *off_srcs = to_addr_offs(sh, percpu);
 	struct dma_async_tx_descriptor *tx;
 	struct async_submit_ctl submit;
 	int count;
@@ -2054,16 +2065,19 @@ static void ops_run_check_p(struct stripe_head *sh, struct raid5_percpu *percpu)
 	BUG_ON(sh->batch_head);
 	count = 0;
 	xor_dest = sh->dev[pd_idx].page;
+	off_dest = sh->dev[pd_idx].offset;
+	off_srcs[count] = off_dest;
 	xor_srcs[count++] = xor_dest;
 	for (i = disks; i--; ) {
 		if (i == pd_idx || i == qd_idx)
 			continue;
+		off_srcs[count] = sh->dev[i].offset;
 		xor_srcs[count++] = sh->dev[i].page;
 	}
 
 	init_async_submit(&submit, 0, NULL, NULL, NULL,
 			  to_addr_conv(sh, percpu, 0));
-	tx = async_xor_val(xor_dest, xor_srcs, 0, count,
+	tx = async_xor_val_offs(xor_dest, off_dest, xor_srcs, off_srcs, count,
 			   RAID5_STRIPE_SIZE(sh->raid_conf),
 			   &sh->ops.zero_sum_result, &submit);
 
-- 
2.25.4
