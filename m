From: Yuri Tikhonov <yur@emcraft.com>
Subject: [PATCH 08/11][v2] md: asynchronous handle_parity_check6
Date: Tue, 13 Jan 2009 03:43:24 +0300
Message-ID: <200901130343.24586.yur@emcraft.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: linuxppc-dev@ozlabs.org, dan.j.williams@intel.com, dzu@denx.de, wd@denx.de, yanok@emcraft.com
List-Id: linux-raid.ids

This patch introduces the state machine for handling the RAID-6 parities
check and repair functionality.

Signed-off-by: Yuri Tikhonov <yur@emcraft.com>
Signed-off-by: Ilya Yanok <yanok@emcraft.com>
---
 drivers/md/raid5.c |  164 +++++++++++++++++++++++++++++++++++-----------------
 1 files changed, 111 insertions(+), 53 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 2e26e84..b8e37c8 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2620,91 +2620,149 @@ static void handle_parity_checks6(raid5_conf_t *conf, struct stripe_head *sh,
 				struct r6_state *r6s, struct page *tmp_page,
 				int disks)
 {
-	int update_p = 0, update_q = 0;
-	struct r5dev *dev;
+	int i;
+	struct r5dev *devs[2] = {NULL, NULL};
 	int pd_idx = sh->pd_idx;
 	int qd_idx = r6s->qd_idx;
 
 	set_bit(STRIPE_HANDLE, &sh->state);
 
 	BUG_ON(s->failed > 2);
-	BUG_ON(s->uptodate < disks);
+
 	/* Want to check and possibly repair P and Q.
 	 * However there could be one 'failed' device, in which
 	 * case we can only check one of them, possibly using the
 	 * other to generate missing data
 	 */
 
-	/* If !tmp_page, we cannot do the calculations,
-	 * but as we have set STRIPE_HANDLE, we will soon be called
-	 * by stripe_handle with a tmp_page - just wait until then.
-	 */
-	if (tmp_page) {
+	switch (sh->check_state) {
+	case check_state_idle:
+		/* start a new check operation if there are < 2 failures */
 		if (s->failed == r6s->q_failed) {
 			/* The only possible failed device holds 'Q', so it
 			 * makes sense to check P (If anything else were failed,
 			 * we would have used P to recreate it).
 			 */
-			compute_block_1(sh, pd_idx, 1);
-			if (!page_is_zero(sh->dev[pd_idx].page)) {
-				compute_block_1(sh, pd_idx, 0);
-				update_p = 1;
-			}
+			sh->check_state = check_state_run;
+			set_bit(STRIPE_OP_CHECK_PP, &s->ops_request);
+			clear_bit(R5_UPTODATE, &sh->dev[pd_idx].flags);
+			s->uptodate--;
 		}
 		if (!r6s->q_failed && s->failed < 2) {
 			/* q is not failed, and we didn't use it to generate
 			 * anything, so it makes sense to check it
 			 */
-			memcpy(page_address(tmp_page),
-			       page_address(sh->dev[qd_idx].page),
-			       STRIPE_SIZE);
-			compute_parity6(sh, UPDATE_PARITY);
-			if (memcmp(page_address(tmp_page),
-				   page_address(sh->dev[qd_idx].page),
-				   STRIPE_SIZE) != 0) {
-				clear_bit(STRIPE_INSYNC, &sh->state);
-				update_q = 1;
-			}
+			sh->check_state = check_state_run;
+			set_bit(STRIPE_OP_CHECK_QP, &s->ops_request);
+			clear_bit(R5_UPTODATE, &sh->dev[qd_idx].flags);
+			s->uptodate--;
 		}
-		if (update_p || update_q) {
-			conf->mddev->resync_mismatches += STRIPE_SECTORS;
-			if (test_bit(MD_RECOVERY_CHECK, &conf->mddev->recovery))
-				/* don't try to repair!! */
-				update_p = update_q = 0;
+		if (sh->check_state == check_state_run) {
+			break;
 		}
 
-		/* now write out any block on a failed drive,
-		 * or P or Q if they need it
-		 */
+		/* we have 2-disk failure */
+		BUG_ON(s->failed != 2);
+		devs[0] = &sh->dev[r6s->failed_num[0]];
+		devs[1] = &sh->dev[r6s->failed_num[1]];
+		/* fall through */
+	case check_state_compute_result:
+		sh->check_state = check_state_idle;
 
-		if (s->failed == 2) {
-			dev = &sh->dev[r6s->failed_num[1]];
-			s->locked++;
-			set_bit(R5_LOCKED, &dev->flags);
-			set_bit(R5_Wantwrite, &dev->flags);
+		BUG_ON((devs[0] && !devs[1]) ||
+		       (!devs[0] && devs[1]));
+
+		BUG_ON(s->uptodate < (disks - 1));
+
+		if (!devs[0]) {
+			if (s->failed >= 1)
+				devs[0] = &sh->dev[r6s->failed_num[0]];
+			else
+				devs[0] = &sh->dev[pd_idx];
 		}
-		if (s->failed >= 1) {
-			dev = &sh->dev[r6s->failed_num[0]];
-			s->locked++;
-			set_bit(R5_LOCKED, &dev->flags);
-			set_bit(R5_Wantwrite, &dev->flags);
+		if (!devs[1]) {
+			if (s->failed >= 2)
+				devs[1] = &sh->dev[r6s->failed_num[1]];
+			else
+				devs[1] = &sh->dev[qd_idx];
 		}
 
-		if (update_p) {
-			dev = &sh->dev[pd_idx];
-			s->locked++;
-			set_bit(R5_LOCKED, &dev->flags);
-			set_bit(R5_Wantwrite, &dev->flags);
-		}
-		if (update_q) {
-			dev = &sh->dev[qd_idx];
-			s->locked++;
-			set_bit(R5_LOCKED, &dev->flags);
-			set_bit(R5_Wantwrite, &dev->flags);
+		BUG_ON(!test_bit(R5_UPTODATE, &devs[0]->flags) &&
+		       !test_bit(R5_UPTODATE, &devs[1]->flags));
+
+		/* check that a write has not made the stripe insync */
+		if (test_bit(STRIPE_INSYNC, &sh->state))
+			break;
+
+		for (i=0; i < 2; i++) {
+			if (test_bit(R5_UPTODATE, &devs[i]->flags)) {
+				s->locked++;
+				set_bit(R5_LOCKED, &devs[i]->flags);
+				set_bit(R5_Wantwrite, &devs[i]->flags);
+			}
 		}
-		clear_bit(STRIPE_DEGRADED, &sh->state);
 
+		clear_bit(STRIPE_DEGRADED, &sh->state);
 		set_bit(STRIPE_INSYNC, &sh->state);
+		break;
+	case check_state_run:
+		break; /* we will be called again upon completion */
+	case check_state_check_result:
+		sh->check_state = check_state_idle;
+
+		/* if a failure occurred during the check operation, leave
+		 * STRIPE_INSYNC not set and let the stripe be handled again
+		 */
+		if (s->failed > 1) {
+			break;
+		}
+
+		/* handle a successful check operation, if parity is correct
+		 * we are done.  Otherwise update the mismatch count and repair
+		 * parity if !MD_RECOVERY_CHECK
+		 */
+		if (sh->ops.zero_sum_result == 0) {
+			/* both parities are correct */
+			if (!s->failed) {
+				set_bit(STRIPE_INSYNC, &sh->state);
+			} else {
+				sh->check_state = check_state_compute_result;
+			}
+		} else {
+			conf->mddev->resync_mismatches += STRIPE_SECTORS;
+			if (test_bit(MD_RECOVERY_CHECK, &conf->mddev->recovery))
+				/* don't try to repair!! */
+				set_bit(STRIPE_INSYNC, &sh->state);
+			else {
+				sh->check_state = check_state_compute_run;
+				set_bit(STRIPE_COMPUTE_RUN, &sh->state);
+				set_bit(STRIPE_OP_COMPUTE_BLK, &s->ops_request);
+				if (sh->ops.zero_sum_result &
+				    DMA_PCHECK_FAILED) {
+					set_bit(R5_Wantcompute,
+						&sh->dev[pd_idx].flags);
+					sh->ops.target = pd_idx;
+					s->uptodate++;
+				} else
+					sh->ops.target = -1;
+				if (sh->ops.zero_sum_result &
+				    DMA_QCHECK_FAILED) {
+					set_bit(R5_Wantcompute,
+						&sh->dev[qd_idx].flags);
+					sh->ops.target2 = qd_idx;
+					s->uptodate++;
+				} else
+					sh->ops.target2 = -1;
+			}
+		}
+		break;
+	case check_state_compute_run:
+		break;
+	default:
+		printk(KERN_ERR "%s: unknown check_state: %d sector: %llu\n",
+		       __func__, sh->check_state,
+		       (unsigned long long) sh->sector);
+		BUG();
 	}
 }
 
-- 
1.6.0.6

