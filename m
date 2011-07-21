From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 12/34] md/raid5: move stripe_head_state and more code into
 handle_stripe.
Date: Thu, 21 Jul 2011 12:32:26 +1000
Message-ID: <20110721023225.6728.26725.stgit@notabene.brown>
References: <20110721022537.6728.90204.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110721022537.6728.90204.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

By defining the 'stripe_head_state' in 'handle_stripe', we can move
some common code out of handle_stripe[56]() and into handle_stripe.

The means that all accesses for stripe_head_state in handle_stripe[56]
need to be 's->' instead of 's.', but the compiler should inline
those functions and just use a direct stack reference, and future
patches while hoist most of this code up into handle_stripe()
so we will revert to "s.".

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid5.c |  340 ++++++++++++++++++++++++----------------------------
 1 files changed, 158 insertions(+), 182 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 3327e82..ce1c291 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2999,24 +2999,13 @@ static void handle_stripe_expansion(raid5_conf_t *conf, struct stripe_head *sh,
  *
  */
 
-static void handle_stripe5(struct stripe_head *sh)
+static void handle_stripe5(struct stripe_head *sh, struct stripe_head_state *s)
 {
 	raid5_conf_t *conf = sh->raid_conf;
 	int disks = sh->disks, i;
-	struct stripe_head_state s;
 	struct r5dev *dev;
 	int prexor;
 
-	memset(&s, 0, sizeof(s));
-	pr_debug("handling stripe %llu, state=%#lx cnt=%d, pd_idx=%d check:%d "
-		 "reconstruct:%d\n", (unsigned long long)sh->sector, sh->state,
-		 atomic_read(&sh->count), sh->pd_idx, sh->check_state,
-		 sh->reconstruct_state);
-
-	s.syncing = test_bit(STRIPE_SYNCING, &sh->state);
-	s.expanding = test_bit(STRIPE_EXPAND_SOURCE, &sh->state);
-	s.expanded = test_bit(STRIPE_EXPAND_READY, &sh->state);
-
 	/* Now to look around and see what can be done */
 	rcu_read_lock();
 	spin_lock_irq(&conf->device_lock);
@@ -3039,25 +3028,28 @@ static void handle_stripe5(struct stripe_head *sh)
 			set_bit(R5_Wantfill, &dev->flags);
 
 		/* now count some things */
-		if (test_bit(R5_LOCKED, &dev->flags)) s.locked++;
-		if (test_bit(R5_UPTODATE, &dev->flags)) s.uptodate++;
-		if (test_bit(R5_Wantcompute, &dev->flags)) s.compute++;
+		if (test_bit(R5_LOCKED, &dev->flags))
+			s->locked++;
+		if (test_bit(R5_UPTODATE, &dev->flags))
+			s->uptodate++;
+		if (test_bit(R5_Wantcompute, &dev->flags))
+			s->compute++;
 
 		if (test_bit(R5_Wantfill, &dev->flags))
-			s.to_fill++;
+			s->to_fill++;
 		else if (dev->toread)
-			s.to_read++;
+			s->to_read++;
 		if (dev->towrite) {
-			s.to_write++;
+			s->to_write++;
 			if (!test_bit(R5_OVERWRITE, &dev->flags))
-				s.non_overwrite++;
+				s->non_overwrite++;
 		}
 		if (dev->written)
-			s.written++;
+			s->written++;
 		rdev = rcu_dereference(conf->disks[i].rdev);
-		if (s.blocked_rdev == NULL &&
+		if (s->blocked_rdev == NULL &&
 		    rdev && unlikely(test_bit(Blocked, &rdev->flags))) {
-			s.blocked_rdev = rdev;
+			s->blocked_rdev = rdev;
 			atomic_inc(&rdev->nr_pending);
 		}
 		clear_bit(R5_Insync, &dev->flags);
@@ -3078,62 +3070,62 @@ static void handle_stripe5(struct stripe_head *sh)
 		if (test_bit(R5_ReadError, &dev->flags))
 			clear_bit(R5_Insync, &dev->flags);
 		if (!test_bit(R5_Insync, &dev->flags)) {
-			s.failed++;
-			s.failed_num[0] = i;
+			s->failed++;
+			s->failed_num[0] = i;
 		}
 	}
 	spin_unlock_irq(&conf->device_lock);
 	rcu_read_unlock();
 
-	if (unlikely(s.blocked_rdev)) {
-		if (s.syncing || s.expanding || s.expanded ||
-		    s.to_write || s.written) {
+	if (unlikely(s->blocked_rdev)) {
+		if (s->syncing || s->expanding || s->expanded ||
+		    s->to_write || s->written) {
 			set_bit(STRIPE_HANDLE, &sh->state);
-			goto unlock;
+			return;
 		}
 		/* There is nothing for the blocked_rdev to block */
-		rdev_dec_pending(s.blocked_rdev, conf->mddev);
-		s.blocked_rdev = NULL;
+		rdev_dec_pending(s->blocked_rdev, conf->mddev);
+		s->blocked_rdev = NULL;
 	}
 
-	if (s.to_fill && !test_bit(STRIPE_BIOFILL_RUN, &sh->state)) {
-		set_bit(STRIPE_OP_BIOFILL, &s.ops_request);
+	if (s->to_fill && !test_bit(STRIPE_BIOFILL_RUN, &sh->state)) {
+		set_bit(STRIPE_OP_BIOFILL, &s->ops_request);
 		set_bit(STRIPE_BIOFILL_RUN, &sh->state);
 	}
 
 	pr_debug("locked=%d uptodate=%d to_read=%d"
 		" to_write=%d failed=%d failed_num=%d\n",
-		s.locked, s.uptodate, s.to_read, s.to_write,
-		s.failed, s.failed_num[0]);
+		s->locked, s->uptodate, s->to_read, s->to_write,
+		s->failed, s->failed_num[0]);
 	/* check if the array has lost two devices and, if so, some requests might
 	 * need to be failed
 	 */
-	if (s.failed > 1 && s.to_read+s.to_write+s.written)
-		handle_failed_stripe(conf, sh, &s, disks, &s.return_bi);
-	if (s.failed > 1 && s.syncing) {
+	if (s->failed > 1 && s->to_read+s->to_write+s->written)
+		handle_failed_stripe(conf, sh, s, disks, &s->return_bi);
+	if (s->failed > 1 && s->syncing) {
 		md_done_sync(conf->mddev, STRIPE_SECTORS,0);
 		clear_bit(STRIPE_SYNCING, &sh->state);
-		s.syncing = 0;
+		s->syncing = 0;
 	}
 
 	/* might be able to return some write requests if the parity block
 	 * is safe, or on a failed drive
 	 */
 	dev = &sh->dev[sh->pd_idx];
-	if ( s.written &&
-	     ((test_bit(R5_Insync, &dev->flags) &&
-	       !test_bit(R5_LOCKED, &dev->flags) &&
-	       test_bit(R5_UPTODATE, &dev->flags)) ||
-	       (s.failed == 1 && s.failed_num[0] == sh->pd_idx)))
-		handle_stripe_clean_event(conf, sh, disks, &s.return_bi);
+	if (s->written &&
+	    ((test_bit(R5_Insync, &dev->flags) &&
+	      !test_bit(R5_LOCKED, &dev->flags) &&
+	      test_bit(R5_UPTODATE, &dev->flags)) ||
+	     (s->failed == 1 && s->failed_num[0] == sh->pd_idx)))
+		handle_stripe_clean_event(conf, sh, disks, &s->return_bi);
 
 	/* Now we might consider reading some blocks, either to check/generate
 	 * parity, or to satisfy requests
 	 * or to load a block that is being partially written.
 	 */
-	if (s.to_read || s.non_overwrite ||
-	    (s.syncing && (s.uptodate + s.compute < disks)) || s.expanding)
-		handle_stripe_fill5(sh, &s, disks);
+	if (s->to_read || s->non_overwrite ||
+	    (s->syncing && (s->uptodate + s->compute < disks)) || s->expanding)
+		handle_stripe_fill5(sh, s, disks);
 
 	/* Now we check to see if any write operations have recently
 	 * completed
@@ -3158,12 +3150,12 @@ static void handle_stripe5(struct stripe_head *sh)
 				if (prexor)
 					continue;
 				if (!test_bit(R5_Insync, &dev->flags) ||
-				    (i == sh->pd_idx && s.failed == 0))
+				    (i == sh->pd_idx && s->failed == 0))
 					set_bit(STRIPE_INSYNC, &sh->state);
 			}
 		}
 		if (test_and_clear_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
-			s.dec_preread_active = 1;
+			s->dec_preread_active = 1;
 	}
 
 	/* Now to consider new write requests and what else, if anything
@@ -3172,8 +3164,8 @@ static void handle_stripe5(struct stripe_head *sh)
 	 * 2/ A 'check' operation is in flight, as it may clobber the parity
 	 *    block.
 	 */
-	if (s.to_write && !sh->reconstruct_state && !sh->check_state)
-		handle_stripe_dirtying5(conf, sh, &s, disks);
+	if (s->to_write && !sh->reconstruct_state && !sh->check_state)
+		handle_stripe_dirtying5(conf, sh, s, disks);
 
 	/* maybe we need to check and possibly fix the parity for this stripe
 	 * Any reads will already have been scheduled, so we just see if enough
@@ -3181,12 +3173,13 @@ static void handle_stripe5(struct stripe_head *sh)
 	 * dependent operations are in flight.
 	 */
 	if (sh->check_state ||
-	    (s.syncing && s.locked == 0 &&
+	    (s->syncing && s->locked == 0 &&
 	     !test_bit(STRIPE_COMPUTE_RUN, &sh->state) &&
 	     !test_bit(STRIPE_INSYNC, &sh->state)))
-		handle_parity_checks5(conf, sh, &s, disks);
+		handle_parity_checks5(conf, sh, s, disks);
 
-	if (s.syncing && s.locked == 0 && test_bit(STRIPE_INSYNC, &sh->state)) {
+	if (s->syncing && s->locked == 0
+	    && test_bit(STRIPE_INSYNC, &sh->state)) {
 		md_done_sync(conf->mddev, STRIPE_SECTORS,1);
 		clear_bit(STRIPE_SYNCING, &sh->state);
 	}
@@ -3194,22 +3187,22 @@ static void handle_stripe5(struct stripe_head *sh)
 	/* If the failed drive is just a ReadError, then we might need to progress
 	 * the repair/check process
 	 */
-	if (s.failed == 1 && !conf->mddev->ro &&
-	    test_bit(R5_ReadError, &sh->dev[s.failed_num[0]].flags)
-	    && !test_bit(R5_LOCKED, &sh->dev[s.failed_num[0]].flags)
-	    && test_bit(R5_UPTODATE, &sh->dev[s.failed_num[0]].flags)
+	if (s->failed == 1 && !conf->mddev->ro &&
+	    test_bit(R5_ReadError, &sh->dev[s->failed_num[0]].flags)
+	    && !test_bit(R5_LOCKED, &sh->dev[s->failed_num[0]].flags)
+	    && test_bit(R5_UPTODATE, &sh->dev[s->failed_num[0]].flags)
 		) {
-		dev = &sh->dev[s.failed_num[0]];
+		dev = &sh->dev[s->failed_num[0]];
 		if (!test_bit(R5_ReWrite, &dev->flags)) {
 			set_bit(R5_Wantwrite, &dev->flags);
 			set_bit(R5_ReWrite, &dev->flags);
 			set_bit(R5_LOCKED, &dev->flags);
-			s.locked++;
+			s->locked++;
 		} else {
 			/* let's read it back */
 			set_bit(R5_Wantread, &dev->flags);
 			set_bit(R5_LOCKED, &dev->flags);
-			s.locked++;
+			s->locked++;
 		}
 	}
 
@@ -3227,7 +3220,7 @@ static void handle_stripe5(struct stripe_head *sh)
 					      &sh2->state))
 				atomic_inc(&conf->preread_active_stripes);
 			release_stripe(sh2);
-			goto unlock;
+			return;
 		}
 		if (sh2)
 			release_stripe(sh2);
@@ -3237,69 +3230,35 @@ static void handle_stripe5(struct stripe_head *sh)
 		for (i = conf->raid_disks; i--; ) {
 			set_bit(R5_Wantwrite, &sh->dev[i].flags);
 			set_bit(R5_LOCKED, &sh->dev[i].flags);
-			s.locked++;
+			s->locked++;
 		}
 	}
 
-	if (s.expanded && test_bit(STRIPE_EXPANDING, &sh->state) &&
+	if (s->expanded && test_bit(STRIPE_EXPANDING, &sh->state) &&
 	    !sh->reconstruct_state) {
 		/* Need to write out all blocks after computing parity */
 		sh->disks = conf->raid_disks;
 		stripe_set_idx(sh->sector, conf, 0, sh);
-		schedule_reconstruction(sh, &s, 1, 1);
-	} else if (s.expanded && !sh->reconstruct_state && s.locked == 0) {
+		schedule_reconstruction(sh, s, 1, 1);
+	} else if (s->expanded && !sh->reconstruct_state && s->locked == 0) {
 		clear_bit(STRIPE_EXPAND_READY, &sh->state);
 		atomic_dec(&conf->reshape_stripes);
 		wake_up(&conf->wait_for_overlap);
 		md_done_sync(conf->mddev, STRIPE_SECTORS, 1);
 	}
 
-	if (s.expanding && s.locked == 0 &&
+	if (s->expanding && s->locked == 0 &&
 	    !test_bit(STRIPE_COMPUTE_RUN, &sh->state))
 		handle_stripe_expansion(conf, sh, NULL);
-
- unlock:
-
-	/* wait for this device to become unblocked */
-	if (unlikely(s.blocked_rdev))
-		md_wait_for_blocked_rdev(s.blocked_rdev, conf->mddev);
-
-	if (s.ops_request)
-		raid_run_ops(sh, s.ops_request);
-
-	ops_run_io(sh, &s);
-
-	if (s.dec_preread_active) {
-		/* We delay this until after ops_run_io so that if make_request
-		 * is waiting on a flush, it won't continue until the writes
-		 * have actually been submitted.
-		 */
-		atomic_dec(&conf->preread_active_stripes);
-		if (atomic_read(&conf->preread_active_stripes) <
-		    IO_THRESHOLD)
-			md_wakeup_thread(conf->mddev->thread);
-	}
-	return_io(s.return_bi);
 }
 
-static void handle_stripe6(struct stripe_head *sh)
+static void handle_stripe6(struct stripe_head *sh, struct stripe_head_state *s)
 {
 	raid5_conf_t *conf = sh->raid_conf;
 	int disks = sh->disks;
 	int i, pd_idx = sh->pd_idx, qd_idx = sh->qd_idx;
-	struct stripe_head_state s;
 	struct r5dev *dev, *pdev, *qdev;
 
-	pr_debug("handling stripe %llu, state=%#lx cnt=%d, "
-		"pd_idx=%d, qd_idx=%d\n, check:%d, reconstruct:%d\n",
-	       (unsigned long long)sh->sector, sh->state,
-	       atomic_read(&sh->count), pd_idx, qd_idx,
-	       sh->check_state, sh->reconstruct_state);
-	memset(&s, 0, sizeof(s));
-
-	s.syncing = test_bit(STRIPE_SYNCING, &sh->state);
-	s.expanding = test_bit(STRIPE_EXPAND_SOURCE, &sh->state);
-	s.expanded = test_bit(STRIPE_EXPAND_READY, &sh->state);
 	/* Now to look around and see what can be done */
 
 	rcu_read_lock();
@@ -3320,28 +3279,30 @@ static void handle_stripe6(struct stripe_head *sh)
 			set_bit(R5_Wantfill, &dev->flags);
 
 		/* now count some things */
-		if (test_bit(R5_LOCKED, &dev->flags)) s.locked++;
-		if (test_bit(R5_UPTODATE, &dev->flags)) s.uptodate++;
+		if (test_bit(R5_LOCKED, &dev->flags))
+			s->locked++;
+		if (test_bit(R5_UPTODATE, &dev->flags))
+			s->uptodate++;
 		if (test_bit(R5_Wantcompute, &dev->flags)) {
-			s.compute++;
-			BUG_ON(s.compute > 2);
+			s->compute++;
+			BUG_ON(s->compute > 2);
 		}
 
 		if (test_bit(R5_Wantfill, &dev->flags)) {
-			s.to_fill++;
+			s->to_fill++;
 		} else if (dev->toread)
-			s.to_read++;
+			s->to_read++;
 		if (dev->towrite) {
-			s.to_write++;
+			s->to_write++;
 			if (!test_bit(R5_OVERWRITE, &dev->flags))
-				s.non_overwrite++;
+				s->non_overwrite++;
 		}
 		if (dev->written)
-			s.written++;
+			s->written++;
 		rdev = rcu_dereference(conf->disks[i].rdev);
-		if (s.blocked_rdev == NULL &&
+		if (s->blocked_rdev == NULL &&
 		    rdev && unlikely(test_bit(Blocked, &rdev->flags))) {
-			s.blocked_rdev = rdev;
+			s->blocked_rdev = rdev;
 			atomic_inc(&rdev->nr_pending);
 		}
 		clear_bit(R5_Insync, &dev->flags);
@@ -3362,43 +3323,43 @@ static void handle_stripe6(struct stripe_head *sh)
 		if (test_bit(R5_ReadError, &dev->flags))
 			clear_bit(R5_Insync, &dev->flags);
 		if (!test_bit(R5_Insync, &dev->flags)) {
-			if (s.failed < 2)
-				s.failed_num[s.failed] = i;
-			s.failed++;
+			if (s->failed < 2)
+				s->failed_num[s->failed] = i;
+			s->failed++;
 		}
 	}
 	spin_unlock_irq(&conf->device_lock);
 	rcu_read_unlock();
 
-	if (unlikely(s.blocked_rdev)) {
-		if (s.syncing || s.expanding || s.expanded ||
-		    s.to_write || s.written) {
+	if (unlikely(s->blocked_rdev)) {
+		if (s->syncing || s->expanding || s->expanded ||
+		    s->to_write || s->written) {
 			set_bit(STRIPE_HANDLE, &sh->state);
-			goto unlock;
+			return;
 		}
 		/* There is nothing for the blocked_rdev to block */
-		rdev_dec_pending(s.blocked_rdev, conf->mddev);
-		s.blocked_rdev = NULL;
+		rdev_dec_pending(s->blocked_rdev, conf->mddev);
+		s->blocked_rdev = NULL;
 	}
 
-	if (s.to_fill && !test_bit(STRIPE_BIOFILL_RUN, &sh->state)) {
-		set_bit(STRIPE_OP_BIOFILL, &s.ops_request);
+	if (s->to_fill && !test_bit(STRIPE_BIOFILL_RUN, &sh->state)) {
+		set_bit(STRIPE_OP_BIOFILL, &s->ops_request);
 		set_bit(STRIPE_BIOFILL_RUN, &sh->state);
 	}
 
 	pr_debug("locked=%d uptodate=%d to_read=%d"
 	       " to_write=%d failed=%d failed_num=%d,%d\n",
-	       s.locked, s.uptodate, s.to_read, s.to_write, s.failed,
-	       s.failed_num[0], s.failed_num[1]);
+	       s->locked, s->uptodate, s->to_read, s->to_write, s->failed,
+	       s->failed_num[0], s->failed_num[1]);
 	/* check if the array has lost >2 devices and, if so, some requests
 	 * might need to be failed
 	 */
-	if (s.failed > 2 && s.to_read+s.to_write+s.written)
-		handle_failed_stripe(conf, sh, &s, disks, &s.return_bi);
-	if (s.failed > 2 && s.syncing) {
+	if (s->failed > 2 && s->to_read+s->to_write+s->written)
+		handle_failed_stripe(conf, sh, s, disks, &s->return_bi);
+	if (s->failed > 2 && s->syncing) {
 		md_done_sync(conf->mddev, STRIPE_SECTORS,0);
 		clear_bit(STRIPE_SYNCING, &sh->state);
-		s.syncing = 0;
+		s->syncing = 0;
 	}
 
 	/*
@@ -3406,28 +3367,28 @@ static void handle_stripe6(struct stripe_head *sh)
 	 * are safe, or on a failed drive
 	 */
 	pdev = &sh->dev[pd_idx];
-	s.p_failed = (s.failed >= 1 && s.failed_num[0] == pd_idx)
-		|| (s.failed >= 2 && s.failed_num[1] == pd_idx);
+	s->p_failed = (s->failed >= 1 && s->failed_num[0] == pd_idx)
+		|| (s->failed >= 2 && s->failed_num[1] == pd_idx);
 	qdev = &sh->dev[qd_idx];
-	s.q_failed = (s.failed >= 1 && s.failed_num[0] == qd_idx)
-		|| (s.failed >= 2 && s.failed_num[1] == qd_idx);
+	s->q_failed = (s->failed >= 1 && s->failed_num[0] == qd_idx)
+		|| (s->failed >= 2 && s->failed_num[1] == qd_idx);
 
-	if (s.written &&
-	    (s.p_failed || ((test_bit(R5_Insync, &pdev->flags)
+	if (s->written &&
+	    (s->p_failed || ((test_bit(R5_Insync, &pdev->flags)
 			     && !test_bit(R5_LOCKED, &pdev->flags)
 			     && test_bit(R5_UPTODATE, &pdev->flags)))) &&
-	    (s.q_failed || ((test_bit(R5_Insync, &qdev->flags)
+	    (s->q_failed || ((test_bit(R5_Insync, &qdev->flags)
 			     && !test_bit(R5_LOCKED, &qdev->flags)
 			     && test_bit(R5_UPTODATE, &qdev->flags)))))
-		handle_stripe_clean_event(conf, sh, disks, &s.return_bi);
+		handle_stripe_clean_event(conf, sh, disks, &s->return_bi);
 
 	/* Now we might consider reading some blocks, either to check/generate
 	 * parity, or to satisfy requests
 	 * or to load a block that is being partially written.
 	 */
-	if (s.to_read || s.non_overwrite || (s.to_write && s.failed) ||
-	    (s.syncing && (s.uptodate + s.compute < disks)) || s.expanding)
-		handle_stripe_fill6(sh, &s, disks);
+	if (s->to_read || s->non_overwrite || (s->to_write && s->failed) ||
+	    (s->syncing && (s->uptodate + s->compute < disks)) || s->expanding)
+		handle_stripe_fill6(sh, s, disks);
 
 	/* Now we check to see if any write operations have recently
 	 * completed
@@ -3450,12 +3411,12 @@ static void handle_stripe6(struct stripe_head *sh)
 				set_bit(R5_Wantwrite, &dev->flags);
 				if (!test_bit(R5_Insync, &dev->flags) ||
 				    ((i == sh->pd_idx || i == qd_idx) &&
-				      s.failed == 0))
+				      s->failed == 0))
 					set_bit(STRIPE_INSYNC, &sh->state);
 			}
 		}
 		if (test_and_clear_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
-			s.dec_preread_active = 1;
+			s->dec_preread_active = 1;
 	}
 
 	/* Now to consider new write requests and what else, if anything
@@ -3464,8 +3425,8 @@ static void handle_stripe6(struct stripe_head *sh)
 	 * 2/ A 'check' operation is in flight, as it may clobber the parity
 	 *    block.
 	 */
-	if (s.to_write && !sh->reconstruct_state && !sh->check_state)
-		handle_stripe_dirtying6(conf, sh, &s, disks);
+	if (s->to_write && !sh->reconstruct_state && !sh->check_state)
+		handle_stripe_dirtying6(conf, sh, s, disks);
 
 	/* maybe we need to check and possibly fix the parity for this stripe
 	 * Any reads will already have been scheduled, so we just see if enough
@@ -3473,12 +3434,13 @@ static void handle_stripe6(struct stripe_head *sh)
 	 * dependent operations are in flight.
 	 */
 	if (sh->check_state ||
-	    (s.syncing && s.locked == 0 &&
+	    (s->syncing && s->locked == 0 &&
 	     !test_bit(STRIPE_COMPUTE_RUN, &sh->state) &&
 	     !test_bit(STRIPE_INSYNC, &sh->state)))
-		handle_parity_checks6(conf, sh, &s, disks);
+		handle_parity_checks6(conf, sh, s, disks);
 
-	if (s.syncing && s.locked == 0 && test_bit(STRIPE_INSYNC, &sh->state)) {
+	if (s->syncing && s->locked == 0
+	    && test_bit(STRIPE_INSYNC, &sh->state)) {
 		md_done_sync(conf->mddev, STRIPE_SECTORS,1);
 		clear_bit(STRIPE_SYNCING, &sh->state);
 	}
@@ -3486,9 +3448,9 @@ static void handle_stripe6(struct stripe_head *sh)
 	/* If the failed drives are just a ReadError, then we might need
 	 * to progress the repair/check process
 	 */
-	if (s.failed <= 2 && !conf->mddev->ro)
-		for (i = 0; i < s.failed; i++) {
-			dev = &sh->dev[s.failed_num[i]];
+	if (s->failed <= 2 && !conf->mddev->ro)
+		for (i = 0; i < s->failed; i++) {
+			dev = &sh->dev[s->failed_num[i]];
 			if (test_bit(R5_ReadError, &dev->flags)
 			    && !test_bit(R5_LOCKED, &dev->flags)
 			    && test_bit(R5_UPTODATE, &dev->flags)
@@ -3497,12 +3459,12 @@ static void handle_stripe6(struct stripe_head *sh)
 					set_bit(R5_Wantwrite, &dev->flags);
 					set_bit(R5_ReWrite, &dev->flags);
 					set_bit(R5_LOCKED, &dev->flags);
-					s.locked++;
+					s->locked++;
 				} else {
 					/* let's read it back */
 					set_bit(R5_Wantread, &dev->flags);
 					set_bit(R5_LOCKED, &dev->flags);
-					s.locked++;
+					s->locked++;
 				}
 			}
 		}
@@ -3514,11 +3476,11 @@ static void handle_stripe6(struct stripe_head *sh)
 		for (i = conf->raid_disks; i--; ) {
 			set_bit(R5_Wantwrite, &sh->dev[i].flags);
 			set_bit(R5_LOCKED, &sh->dev[i].flags);
-			s.locked++;
+			s->locked++;
 		}
 	}
 
-	if (s.expanded && test_bit(STRIPE_EXPANDING, &sh->state) &&
+	if (s->expanded && test_bit(STRIPE_EXPANDING, &sh->state) &&
 	    !sh->reconstruct_state) {
 		struct stripe_head *sh2
 			= get_active_stripe(conf, sh->sector, 1, 1, 1);
@@ -3532,7 +3494,7 @@ static void handle_stripe6(struct stripe_head *sh)
 					      &sh2->state))
 				atomic_inc(&conf->preread_active_stripes);
 			release_stripe(sh2);
-			goto unlock;
+			return;
 		}
 		if (sh2)
 			release_stripe(sh2);
@@ -3540,19 +3502,54 @@ static void handle_stripe6(struct stripe_head *sh)
 		/* Need to write out all blocks after computing P&Q */
 		sh->disks = conf->raid_disks;
 		stripe_set_idx(sh->sector, conf, 0, sh);
-		schedule_reconstruction(sh, &s, 1, 1);
-	} else if (s.expanded && !sh->reconstruct_state && s.locked == 0) {
+		schedule_reconstruction(sh, s, 1, 1);
+	} else if (s->expanded && !sh->reconstruct_state && s->locked == 0) {
 		clear_bit(STRIPE_EXPAND_READY, &sh->state);
 		atomic_dec(&conf->reshape_stripes);
 		wake_up(&conf->wait_for_overlap);
 		md_done_sync(conf->mddev, STRIPE_SECTORS, 1);
 	}
 
-	if (s.expanding && s.locked == 0 &&
+	if (s->expanding && s->locked == 0 &&
 	    !test_bit(STRIPE_COMPUTE_RUN, &sh->state))
-		handle_stripe_expansion(conf, sh, &s);
+		handle_stripe_expansion(conf, sh, s);
+}
+
+static void handle_stripe(struct stripe_head *sh)
+{
+	struct stripe_head_state s;
+	raid5_conf_t *conf = sh->raid_conf;
+
+	clear_bit(STRIPE_HANDLE, &sh->state);
+	if (test_and_set_bit(STRIPE_ACTIVE, &sh->state)) {
+		/* already being handled, ensure it gets handled
+		 * again when current action finishes */
+		set_bit(STRIPE_HANDLE, &sh->state);
+		return;
+	}
+
+	if (test_and_clear_bit(STRIPE_SYNC_REQUESTED, &sh->state)) {
+		set_bit(STRIPE_SYNCING, &sh->state);
+		clear_bit(STRIPE_INSYNC, &sh->state);
+	}
+	clear_bit(STRIPE_DELAYED, &sh->state);
+
+	pr_debug("handling stripe %llu, state=%#lx cnt=%d, "
+		"pd_idx=%d, qd_idx=%d\n, check:%d, reconstruct:%d\n",
+	       (unsigned long long)sh->sector, sh->state,
+	       atomic_read(&sh->count), sh->pd_idx, sh->qd_idx,
+	       sh->check_state, sh->reconstruct_state);
+	memset(&s, 0, sizeof(s));
+
+	s.syncing = test_bit(STRIPE_SYNCING, &sh->state);
+	s.expanding = test_bit(STRIPE_EXPAND_SOURCE, &sh->state);
+	s.expanded = test_bit(STRIPE_EXPAND_READY, &sh->state);
+
+	if (conf->level == 6)
+		handle_stripe6(sh, &s);
+	else
+		handle_stripe5(sh, &s);
 
- unlock:
 
 	/* wait for this device to become unblocked */
 	if (unlikely(s.blocked_rdev))
@@ -3576,28 +3573,7 @@ static void handle_stripe6(struct stripe_head *sh)
 	}
 
 	return_io(s.return_bi);
-}
 
-static void handle_stripe(struct stripe_head *sh)
-{
-	clear_bit(STRIPE_HANDLE, &sh->state);
-	if (test_and_set_bit(STRIPE_ACTIVE, &sh->state)) {
-		/* already being handled, ensure it gets handled
-		 * again when current action finishes */
-		set_bit(STRIPE_HANDLE, &sh->state);
-		return;
-	}
-
-	if (test_and_clear_bit(STRIPE_SYNC_REQUESTED, &sh->state)) {
-		set_bit(STRIPE_SYNCING, &sh->state);
-		clear_bit(STRIPE_INSYNC, &sh->state);
-	}
-	clear_bit(STRIPE_DELAYED, &sh->state);
-
-	if (sh->raid_conf->level == 6)
-		handle_stripe6(sh);
-	else
-		handle_stripe5(sh);
 	clear_bit(STRIPE_ACTIVE, &sh->state);
 }
 


