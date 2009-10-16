From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 08/11] md: fix problems with RAID6 calculations for DDF.
Date: Fri, 16 Oct 2009 16:49:19 +1100
Message-ID: <20091016054919.24208.42030.stgit@notabene.brown>
References: <20091016054316.24208.33818.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091016054316.24208.33818.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid5.c |   20 +++++++++++++-------
 drivers/md/raid5.h |    2 +-
 2 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 25c3c29..d4ce51b 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -158,11 +158,14 @@ static int raid6_idx_to_slot(int idx, struct stripe_head *sh,
 {
 	int slot;
 
+	if (sh->ddf_layout)
+		slot = (*count)++;
 	if (idx == sh->pd_idx)
 		return syndrome_disks;
 	if (idx == sh->qd_idx)
 		return syndrome_disks + 1;
-	slot = (*count)++;
+	if (!sh->ddf_layout)
+		slot = (*count)++;
 	return slot;
 }
 
@@ -727,9 +730,8 @@ static int set_syndrome_sources(struct page **srcs, struct stripe_head *sh)
 		srcs[slot] = sh->dev[i].page;
 		i = raid6_next_disk(i, disks);
 	} while (i != d0_idx);
-	BUG_ON(count != syndrome_disks);
 
-	return count;
+	return syndrome_disks;
 }
 
 static struct dma_async_tx_descriptor *
@@ -828,7 +830,6 @@ ops_run_compute6_2(struct stripe_head *sh, struct raid5_percpu *percpu)
 			failb = slot;
 		i = raid6_next_disk(i, disks);
 	} while (i != d0_idx);
-	BUG_ON(count != syndrome_disks);
 
 	BUG_ON(faila == failb);
 	if (failb < faila)
@@ -845,7 +846,7 @@ ops_run_compute6_2(struct stripe_head *sh, struct raid5_percpu *percpu)
 			init_async_submit(&submit, ASYNC_TX_FENCE, NULL,
 					  ops_complete_compute, sh,
 					  to_addr_conv(sh, percpu));
-			return async_gen_syndrome(blocks, 0, count+2,
+			return async_gen_syndrome(blocks, 0, syndrome_disks+2,
 						  STRIPE_SIZE, &submit);
 		} else {
 			struct page *dest;
@@ -1935,10 +1936,15 @@ static sector_t compute_blocknr(struct stripe_head *sh, int i, int previous)
 		case ALGORITHM_PARITY_N:
 			break;
 		case ALGORITHM_ROTATING_N_CONTINUE:
+			/* Like left_symmetric, but P is before Q */
 			if (sh->pd_idx == 0)
 				i--;	/* P D D D Q */
-			else if (i > sh->pd_idx)
-				i -= 2; /* D D Q P D */
+			else {
+				/* D D Q P D */
+				if (i < sh->pd_idx)
+					i += raid_disks;
+				i -= (sh->pd_idx + 1);
+			}
 			break;
 		case ALGORITHM_LEFT_ASYMMETRIC_6:
 		case ALGORITHM_RIGHT_ASYMMETRIC_6:
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index dcefdc9..dd70835 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -488,7 +488,7 @@ static inline int algorithm_valid_raid6(int layout)
 {
 	return (layout >= 0 && layout <= 5)
 		||
-		(layout == 8 || layout == 10)
+		(layout >= 8 && layout <= 10)
 		||
 		(layout >= 16 && layout <= 20);
 }


