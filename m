From: Yuri Tikhonov <yur@emcraft.com>
Subject: [md-raid6-accel PATCH 07/12] md: req/comp logic for async check operations
Date: Tue, 4 Dec 2007 14:34:11 +0300
Message-ID: <200712041434.11443.yur@emcraft.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: Neil Brown <neilb@suse.de>, Wolfgang Denk <wd@denx.de>, Detlev Zundel <dzu@denx.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

 The STRIPE_OP_CHECK_* flags are used to trigger parities verification.

 STRIPE_OP_CHECK_PP - check P-parity;
 STRIPE_OP_CHECK_QP - check Q-parity.

 The result of the check operation is stored to zero_sum_result (for P-parity)
and to zero_qsum_result (for Q-parity) fields of <sh>. Zero value corresponds
to the correct parity, non-zerp - to non-correct.

 This patch also removes spare page for RAID-6 Q-parity check since it gone
into async_pqxor() [this need for the synchronous CPU cases only; if the check
operation is being performed by DMA - there is no need in spares].

 Signed-off-by: Yuri Tikhonov <yur@emcraft.com>
 Signed-off-by: Mikhail Cherkashin <mike@emcraft.com>
--
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index f0f8d7f..9856a91 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3327,62 +3327,129 @@ static void handle_parity_checks5(raid5_conf_t *conf, struct stripe_head *sh,
 
 static void handle_parity_checks6(raid5_conf_t *conf, struct stripe_head *sh,
 				struct stripe_head_state *s,
-				struct r6_state *r6s, struct page *tmp_page,
+				struct r6_state *r6s,
 				int disks)
 {
-	int update_p = 0, update_q = 0;
 	struct stripe_queue *sq = sh->sq;
-	struct r5dev *dev;
 	int pd_idx = sq->pd_idx;
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
-
-	/* If !tmp_page, we cannot do the calculations,
-	 * but as we have set STRIPE_HANDLE, we will soon be called
-	 * by stripe_handle with a tmp_page - just wait until then.
-	 */
-	if (tmp_page) {
-		if (s->failed == r6s->q_failed) {
-			/* The only possible failed device holds 'Q', so it
-			 * makes sense to check P (If anything else were failed,
-			 * we would have used P to recreate it).
-			 */
-			compute_block_1(sh, pd_idx, 1);
-			if (!page_is_zero(sh->dev[pd_idx].page)) {
-				compute_block_1(sh, pd_idx, 0);
-				update_p = 1;
+	if (s->failed <= 1 && !test_bit(STRIPE_OP_MOD_REPAIR_PD,
+	    &sh->ops.pending)) {
+		/* If one or no disks failed */
+		if (!test_and_set_bit(STRIPE_OP_CHECK, &sh->ops.pending)) {
+			/* Run check operation */
+			pr_debug("run check with uptodate = %d of %d\n",
+				s->uptodate, disks);
+			BUG_ON(s->uptodate != disks);
+			if ( s->failed == r6s->q_failed ) {
+				/* no or only q-disk failed - check p */
+				clear_bit(R5_UPTODATE, &sh->dev[pd_idx].flags);
+				set_bit(STRIPE_OP_CHECK_PP, &sh->ops.pending);
+				s->uptodate--;
 			}
-		}
-		if (!r6s->q_failed && s->failed < 2) {
-			/* q is not failed, and we didn't use it to generate
-			 * anything, so it makes sense to check it
-			 */
-			memcpy(page_address(tmp_page),
-			       page_address(sh->dev[qd_idx].page),
-			       STRIPE_SIZE);
-			compute_parity6(sh, UPDATE_PARITY);
-			if (memcmp(page_address(tmp_page),
-				   page_address(sh->dev[qd_idx].page),
-				   STRIPE_SIZE) != 0) {
-				clear_bit(STRIPE_INSYNC, &sh->state);
-				update_q = 1;
+			if ( !r6s->q_failed ) {
+				/* Q-disk is OK - then check Q-parity also */
+				clear_bit(R5_UPTODATE, &sh->dev[qd_idx].flags);
+				set_bit(STRIPE_OP_CHECK_QP, &sh->ops.pending);
+				s->uptodate--;
+			}
+			sh->ops.count++;
+		} else if (test_and_clear_bit(STRIPE_OP_CHECK,
+		    &sh->ops.complete)) {
+			/* Check operation has been completed */
+			clear_bit(STRIPE_OP_CHECK, &sh->ops.ack);
+			clear_bit(STRIPE_OP_CHECK, &sh->ops.pending);
+				/* See what we've got */
+			if (test_and_clear_bit(STRIPE_OP_CHECK_PP,
+			    &sh->ops.pending) && sh->ops.zero_sum_result != 0) {
+				/* P-parity is wrong */
+				set_bit(STRIPE_OP_UPDATE_PP, &sh->ops.pending);
+			}
+			if (test_and_clear_bit(STRIPE_OP_CHECK_QP, &sh->
+			    ops.pending) && sh->ops.zero_qsum_result != 0) {
+				/* Q-parity is wrong */
+				set_bit(STRIPE_OP_UPDATE_QP, &sh->ops.pending);
+			}
+			if (!test_bit(STRIPE_OP_UPDATE_PP, &sh->ops.pending) &&
+			    !test_bit(STRIPE_OP_UPDATE_QP, &sh->ops.pending)) {
+				/* Both parities are correct */
+				set_bit(STRIPE_INSYNC, &sh->state);
+			} else {
+				/* One or both parities are wrong */
+				conf->mddev->resync_mismatches +=
+				    STRIPE_SECTORS;
+				if (test_bit(MD_RECOVERY_CHECK,
+				    &conf->mddev->recovery)) {
+					/* Don't try to repair */
+					clear_bit(STRIPE_OP_UPDATE_PP,
+					    &sh->ops.pending);
+					clear_bit(STRIPE_OP_UPDATE_QP,
+					    &sh->ops.pending);
+					set_bit(STRIPE_INSYNC, &sh->state);
+				} else {
+					/*
+					 * One or both parities have to be
+					 * updated
+					 */
+					pr_debug("Computing ... ");
+					BUG_ON(test_and_set_bit(
+						STRIPE_OP_COMPUTE_BLK,
+						&sh->ops.pending));
+					set_bit(STRIPE_OP_MOD_REPAIR_PD,
+						&sh->ops.pending);
+					sh->ops.count++;
+					if (test_bit(STRIPE_OP_UPDATE_PP,
+					    &sh->ops.pending)) {
+						pr_debug("P ");
+						BUG_ON(test_and_set_bit(
+						    R5_Wantcompute,
+						    &sh->dev[pd_idx].flags));
+						sh->ops.target = pd_idx;
+						s->uptodate++;
+					} else
+						sh->ops.target = -1;
+					if (test_bit(STRIPE_OP_UPDATE_QP,
+					    &sh->ops.pending)) {
+						pr_debug("Q ");
+						BUG_ON(test_and_set_bit(
+						    R5_Wantcompute,
+						    &sh->dev[qd_idx].flags));
+						sh->ops.target2 = qd_idx;
+						s->uptodate++;
+					} else
+						sh->ops.target2 = -1;
+					pr_debug("disk(s)\n");
+				}
 			}
 		}
-		if (update_p || update_q) {
-			conf->mddev->resync_mismatches += STRIPE_SECTORS;
-			if (test_bit(MD_RECOVERY_CHECK, &conf->mddev->recovery))
-				/* don't try to repair!! */
-				update_p = update_q = 0;
-		}
+	}
+
+	/* check if we can clear a parity disk reconstruct */
+	if (test_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.complete) &&
+	    test_bit(STRIPE_OP_MOD_REPAIR_PD, &sh->ops.pending)) {
+		clear_bit(STRIPE_OP_MOD_REPAIR_PD, &sh->ops.pending);
+		clear_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.complete);
+		clear_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.ack);
+		clear_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.pending);
+	}
+
+	/* Wait for check parity and compute block operations to complete
+	 * before write-back
+	 */
+	if (!test_bit(STRIPE_INSYNC, &sh->state) &&
+		!test_bit(STRIPE_OP_CHECK, &sh->ops.pending) &&
+		!test_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.pending)) {
+		struct r5dev *dev;
 
 		/* now write out any block on a failed drive,
 		 * or P or Q if they need it
@@ -3393,25 +3460,29 @@ static void handle_parity_checks6(raid5_conf_t *conf, struct stripe_head *sh,
 			s->locked++;
 			set_bit(R5_LOCKED, &dev->flags);
 			set_bit(R5_Wantwrite, &dev->flags);
+			BUG_ON(!test_bit(R5_UPTODATE, &dev->flags));
 		}
 		if (s->failed >= 1) {
 			dev = &sh->dev[r6s->failed_num[0]];
 			s->locked++;
 			set_bit(R5_LOCKED, &dev->flags);
 			set_bit(R5_Wantwrite, &dev->flags);
+			BUG_ON(!test_bit(R5_UPTODATE, &dev->flags));
 		}
 
-		if (update_p) {
+		if (test_and_clear_bit(STRIPE_OP_UPDATE_PP, &sh->ops.pending)) {
 			dev = &sh->dev[pd_idx];
 			s->locked++;
 			set_bit(R5_LOCKED, &dev->flags);
 			set_bit(R5_Wantwrite, &dev->flags);
+			BUG_ON(!test_bit(R5_UPTODATE, &dev->flags));
 		}
-		if (update_q) {
+		if (test_and_clear_bit(STRIPE_OP_UPDATE_QP, &sh->ops.pending)) {
 			dev = &sh->dev[qd_idx];
 			s->locked++;
 			set_bit(R5_LOCKED, &dev->flags);
 			set_bit(R5_Wantwrite, &dev->flags);
+			BUG_ON(!test_bit(R5_UPTODATE, &dev->flags));
 		}
 		clear_bit(STRIPE_DEGRADED, &sh->state);
 
@@ -3757,7 +3828,7 @@ static void handle_stripe5(struct stripe_head *sh)
 
 }
 
-static void handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
+static void handle_stripe6(struct stripe_head *sh)
 {
 	struct stripe_queue *sq = sh->sq;
 	raid6_conf_t *conf = sq->raid_conf;
@@ -3918,12 +3989,18 @@ static void handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
 	    !test_bit(STRIPE_OP_CHECK, &sh->ops.pending))
 		handle_issuing_new_write_requests6(conf, sh, &s, &r6s, disks);
 
-	/* maybe we need to check and possibly fix the parity for this stripe
-	 * Any reads will already have been scheduled, so we just see if enough
-	 * data is available
+	/* 1/ Maybe we need to check and possibly fix the parity for this stripe
+	 * Any reads will already have been scheduled, so we just see
+	 * if enough data is available
+	 * 2/ Hold off parity checks while parity dependent operations are
+	 * in flight (conflicting writes are protected by the 'locked' variable)
 	 */
-	if (s.syncing && s.locked == 0 && !test_bit(STRIPE_INSYNC, &sh->state))
-		handle_parity_checks6(conf, sh, &s, &r6s, tmp_page, disks);
+	if ((s.syncing && s.locked == 0 &&
+	    !test_bit(STRIPE_OP_COMPUTE_BLK,&sh->ops.pending) &&
+	    !test_bit(STRIPE_INSYNC, &sh->state)) ||
+	    test_bit(STRIPE_OP_CHECK, &sh->ops.pending) ||
+	    test_bit(STRIPE_OP_MOD_REPAIR_PD, &sh->ops.pending))
+		handle_parity_checks6(conf, sh, &s, &r6s, disks);
 
 	if (s.syncing && s.locked == 0 && test_bit(STRIPE_INSYNC, &sh->state)) {
 		md_done_sync(conf->mddev, STRIPE_SECTORS,1);
@@ -4044,10 +4121,10 @@ static void handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
 	}
 }
 
-static void handle_stripe(struct stripe_head *sh, struct page *tmp_page)
+static void handle_stripe(struct stripe_head *sh)
 {
 	if (sh->sq->raid_conf->level == 6)
-		handle_stripe6(sh, tmp_page);
+		handle_stripe6(sh);
 	else
 		handle_stripe5(sh);
 }
@@ -4068,7 +4145,7 @@ static void handle_queue(struct stripe_queue *sq, int disks, int data_disks)
 	    (to_write && test_bit(STRIPE_QUEUE_PREREAD_ACTIVE, &sq->state))) {
 		struct stripe_head *sh = get_active_stripe(sq, disks, 1);
 		if (sh) {
-			handle_stripe(sh, NULL);
+			handle_stripe(sh);
 			release_stripe(sh);
 		}
 	}
@@ -4747,7 +4824,7 @@ static inline sector_t sync_request(mddev_t *mddev, sector_t sector_nr, int *ski
 	clear_bit(STRIPE_INSYNC, &sh->state);
 	spin_unlock(&sq->lock);
 
-	handle_stripe(sh, NULL);
+	handle_stripe(sh);
 	release_stripe(sh);
 	release_queue(sq);
 
@@ -4942,7 +5019,7 @@ static void raid5d (mddev_t *mddev)
 		spin_unlock_irq(&conf->device_lock);
 		
 		handled++;
-		handle_stripe(sh, conf->spare_page);
+		handle_stripe(sh);
 		release_stripe(sh);
 
 		spin_lock_irq(&conf->device_lock);
@@ -5140,12 +5217,6 @@ static int run(mddev_t *mddev)
 	if ((conf->stripe_hashtbl = kzalloc(PAGE_SIZE, GFP_KERNEL)) == NULL)
 		goto abort;
 
-	if (mddev->level == 6) {
-		conf->spare_page = alloc_page(GFP_KERNEL);
-		if (!conf->spare_page)
-			goto abort;
-	}
-
 	sprintf(conf->workqueue_name, "%s_cache_arb",
 		mddev->gendisk->disk_name);
 	conf->workqueue = create_singlethread_workqueue(conf->workqueue_name);
@@ -5326,7 +5397,6 @@ abort:
 		print_raid5_conf(conf);
 		if (conf->workqueue)
 			destroy_workqueue(conf->workqueue);
-		safe_put_page(conf->spare_page);
 		kfree(conf->disks);
 		kfree(conf->stripe_hashtbl);
 		kfree(conf);
diff --git a/include/linux/raid/raid5.h b/include/linux/raid/raid5.h
index 8bffac5..c84bfbd 100644
--- a/include/linux/raid/raid5.h
+++ b/include/linux/raid/raid5.h
@@ -299,6 +299,8 @@ struct stripe_queue {
 
 #define STRIPE_OP_CHECK_PP	9
 #define STRIPE_OP_CHECK_QP	10
+#define STRIPE_OP_UPDATE_PP	11
+#define STRIPE_OP_UPDATE_QP	12
 
 /*
  * Stripe-queue state
@@ -390,8 +392,6 @@ struct raid5_private_data {
 					    * Cleared when a sync completes.
 					    */
 
-	struct page 		*spare_page; /* Used when checking P/Q in raid6 */
-
 	/*
 	 * Free queue pool
 	 */

-- 
Yuri Tikhonov, Senior Software Engineer
Emcraft Systems, www.emcraft.com
