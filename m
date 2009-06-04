From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 6/8] md/raid6: asynchronous handle_parity_check6
Date: Wed, 03 Jun 2009 18:29:29 -0700
Message-ID: <20090604012928.11507.32956.stgit@dwillia2-linux.ch.intel.com>
References: <20090604012709.11507.15528.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090604012709.11507.15528.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, Ilya Yanok <yanok@emcraft.com>, Yuri Tikhonov <yur@emcraft.com>
List-Id: linux-raid.ids

[ Based on an original patch by Yuri Tikhonov ]

Implement the state machine for handling the RAID-6 parities check and
repair functionality.  Note that the raid6 case does not need to check
for new failures, like raid5, as it will always writeback the correct
disks.  The raid5 case can be updated to check zero_sum_result to avoid
getting confused by new failures rather than retrying the entire check
operation.

Signed-off-by: Yuri Tikhonov <yur@emcraft.com>
Signed-off-by: Ilya Yanok <yanok@emcraft.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/md/raid5.c |  138 +++++++++++++++++++++++++++++++++++++++-------------
 1 files changed, 103 insertions(+), 35 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index fbc3006..1252ab5 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2895,63 +2895,71 @@ static void handle_parity_checks6(raid5_conf_t *conf, struct stripe_head *sh,
 				struct r6_state *r6s, struct page *tmp_page,
 				int disks)
 {
-	int update_p = 0, update_q = 0;
-	struct r5dev *dev;
 	int pd_idx = sh->pd_idx;
 	int qd_idx = sh->qd_idx;
+	struct r5dev *dev;
 
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
-			/* The only possible failed device holds 'Q', so it
+			/* The only possible failed device holds Q, so it
 			 * makes sense to check P (If anything else were failed,
 			 * we would have used P to recreate it).
 			 */
-			compute_block_1(sh, pd_idx, 1);
-			if (!page_is_zero(sh->dev[pd_idx].page)) {
-				compute_block_1(sh, pd_idx, 0);
-				update_p = 1;
-			}
+			sh->check_state = check_state_run;
 		}
 		if (!r6s->q_failed && s->failed < 2) {
-			/* q is not failed, and we didn't use it to generate
+			/* Q is not failed, and we didn't use it to generate
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
+			if (sh->check_state == check_state_run)
+				sh->check_state = check_state_run_pq;
+			else
+				sh->check_state = check_state_run_q;
 		}
-		if (update_p || update_q) {
-			conf->mddev->resync_mismatches += STRIPE_SECTORS;
-			if (test_bit(MD_RECOVERY_CHECK, &conf->mddev->recovery))
-				/* don't try to repair!! */
-				update_p = update_q = 0;
+
+		/* discard potentially stale zero_sum_result */
+		sh->ops.zero_sum_result = 0;
+
+		if (sh->check_state == check_state_run) {
+			/* async_xor_zero_sum destroys the contents of P */
+			clear_bit(R5_UPTODATE, &sh->dev[pd_idx].flags);
+			s->uptodate--;
 		}
+		if (sh->check_state >= check_state_run &&
+		    sh->check_state <= check_state_run_pq) {
+			/* async_syndrome_zero_sum preserves P and Q, so
+			 * no need to mark them !uptodate here
+			 */
+			set_bit(STRIPE_OP_CHECK, &s->ops_request);
+			break;
+		}
+
+		/* we have 2-disk failure */
+		BUG_ON(s->failed != 2);
+		/* fall through */
+	case check_state_compute_result:
+		sh->check_state = check_state_idle;
+
+		/* check that a write has not made the stripe insync */
+		if (test_bit(STRIPE_INSYNC, &sh->state))
+			break;
 
 		/* now write out any block on a failed drive,
-		 * or P or Q if they need it
+		 * or P or Q if they were recomputed
 		 */
-
+		BUG_ON(s->uptodate < disks - 1); /* We don't need Q to recover */
 		if (s->failed == 2) {
 			dev = &sh->dev[r6s->failed_num[1]];
 			s->locked++;
@@ -2964,14 +2972,13 @@ static void handle_parity_checks6(raid5_conf_t *conf, struct stripe_head *sh,
 			set_bit(R5_LOCKED, &dev->flags);
 			set_bit(R5_Wantwrite, &dev->flags);
 		}
-
-		if (update_p) {
+		if (sh->ops.zero_sum_result & SUM_CHECK_P_RESULT) {
 			dev = &sh->dev[pd_idx];
 			s->locked++;
 			set_bit(R5_LOCKED, &dev->flags);
 			set_bit(R5_Wantwrite, &dev->flags);
 		}
-		if (update_q) {
+		if (sh->ops.zero_sum_result & SUM_CHECK_Q_RESULT) {
 			dev = &sh->dev[qd_idx];
 			s->locked++;
 			set_bit(R5_LOCKED, &dev->flags);
@@ -2980,6 +2987,67 @@ static void handle_parity_checks6(raid5_conf_t *conf, struct stripe_head *sh,
 		clear_bit(STRIPE_DEGRADED, &sh->state);
 
 		set_bit(STRIPE_INSYNC, &sh->state);
+		break;
+	case check_state_run:
+	case check_state_run_q:
+	case check_state_run_pq:
+		break; /* we will be called again upon completion */
+	case check_state_check_result:
+		sh->check_state = check_state_idle;
+
+		/* handle a successful check operation, if parity is correct
+		 * we are done.  Otherwise update the mismatch count and repair
+		 * parity if !MD_RECOVERY_CHECK
+		 */
+		if (sh->ops.zero_sum_result == 0) {
+			/* both parities are correct */
+			if (!s->failed)
+				set_bit(STRIPE_INSYNC, &sh->state);
+			else {
+				/* in contrast to the raid5 case we can validate
+				 * parity, but still have a failure to write
+				 * back
+				 */
+				sh->check_state = check_state_compute_result;
+				/* Returning at this point means that we may go
+				 * off and bring p and/or q uptodate again so
+				 * we make sure to check zero_sum_result again
+				 * to verify if p or q need writeback
+				 */
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
+				if (sh->ops.zero_sum_result & SUM_CHECK_P_RESULT) {
+					set_bit(R5_Wantcompute,
+						&sh->dev[pd_idx].flags);
+					sh->ops.target = pd_idx;
+					s->uptodate++;
+				} else
+					sh->ops.target = -1;
+				if (sh->ops.zero_sum_result & SUM_CHECK_Q_RESULT) {
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
 

