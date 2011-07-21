From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 19/34] md/raid5: move some more common code into
 handle_stripe
Date: Thu, 21 Jul 2011 12:32:26 +1000
Message-ID: <20110721023226.6728.58479.stgit@notabene.brown>
References: <20110721022537.6728.90204.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110721022537.6728.90204.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The RAID6 version of this code is usable for RAID5 providing:
  - we test "conf->max_degraded" rather than "2" as appropriate
  - we make sure s->failed_num[1] is meaningful (and not '-1')
    when s->failed > 1

The 'return 1' must become 'goto finish' in the new location.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid5.c |  178 +++++++++++++++++++---------------------------------
 1 files changed, 66 insertions(+), 112 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index ba6f892..f23848f 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2969,63 +2969,14 @@ static int handle_stripe5(struct stripe_head *sh, struct stripe_head_state *s)
 		if (test_bit(R5_ReadError, &dev->flags))
 			clear_bit(R5_Insync, &dev->flags);
 		if (!test_bit(R5_Insync, &dev->flags)) {
+			if (s->failed < 2)
+				s->failed_num[s->failed] = i;
 			s->failed++;
-			s->failed_num[0] = i;
 		}
 	}
 	spin_unlock_irq(&conf->device_lock);
 	rcu_read_unlock();
 
-	if (unlikely(s->blocked_rdev)) {
-		if (s->syncing || s->expanding || s->expanded ||
-		    s->to_write || s->written) {
-			set_bit(STRIPE_HANDLE, &sh->state);
-			return 1;
-		}
-		/* There is nothing for the blocked_rdev to block */
-		rdev_dec_pending(s->blocked_rdev, conf->mddev);
-		s->blocked_rdev = NULL;
-	}
-
-	if (s->to_fill && !test_bit(STRIPE_BIOFILL_RUN, &sh->state)) {
-		set_bit(STRIPE_OP_BIOFILL, &s->ops_request);
-		set_bit(STRIPE_BIOFILL_RUN, &sh->state);
-	}
-
-	pr_debug("locked=%d uptodate=%d to_read=%d"
-		" to_write=%d failed=%d failed_num=%d\n",
-		s->locked, s->uptodate, s->to_read, s->to_write,
-		s->failed, s->failed_num[0]);
-	/* check if the array has lost two devices and, if so, some requests might
-	 * need to be failed
-	 */
-	if (s->failed > 1 && s->to_read+s->to_write+s->written)
-		handle_failed_stripe(conf, sh, s, disks, &s->return_bi);
-	if (s->failed > 1 && s->syncing) {
-		md_done_sync(conf->mddev, STRIPE_SECTORS,0);
-		clear_bit(STRIPE_SYNCING, &sh->state);
-		s->syncing = 0;
-	}
-
-	/* might be able to return some write requests if the parity block
-	 * is safe, or on a failed drive
-	 */
-	dev = &sh->dev[sh->pd_idx];
-	if (s->written &&
-	    ((test_bit(R5_Insync, &dev->flags) &&
-	      !test_bit(R5_LOCKED, &dev->flags) &&
-	      test_bit(R5_UPTODATE, &dev->flags)) ||
-	     (s->failed == 1 && s->failed_num[0] == sh->pd_idx)))
-		handle_stripe_clean_event(conf, sh, disks, &s->return_bi);
-
-	/* Now we might consider reading some blocks, either to check/generate
-	 * parity, or to satisfy requests
-	 * or to load a block that is being partially written.
-	 */
-	if (s->to_read || s->non_overwrite ||
-	    (s->syncing && (s->uptodate + s->compute < disks)) || s->expanding)
-		handle_stripe_fill(sh, s, disks);
-
 	return 0;
 }
 
@@ -3033,8 +2984,8 @@ static int handle_stripe6(struct stripe_head *sh, struct stripe_head_state *s)
 {
 	raid5_conf_t *conf = sh->raid_conf;
 	int disks = sh->disks;
-	int i, pd_idx = sh->pd_idx, qd_idx = sh->qd_idx;
-	struct r5dev *dev, *pdev, *qdev;
+	struct r5dev *dev;
+	int i;
 
 	/* Now to look around and see what can be done */
 
@@ -3108,65 +3059,6 @@ static int handle_stripe6(struct stripe_head *sh, struct stripe_head_state *s)
 	spin_unlock_irq(&conf->device_lock);
 	rcu_read_unlock();
 
-	if (unlikely(s->blocked_rdev)) {
-		if (s->syncing || s->expanding || s->expanded ||
-		    s->to_write || s->written) {
-			set_bit(STRIPE_HANDLE, &sh->state);
-			return 1;
-		}
-		/* There is nothing for the blocked_rdev to block */
-		rdev_dec_pending(s->blocked_rdev, conf->mddev);
-		s->blocked_rdev = NULL;
-	}
-
-	if (s->to_fill && !test_bit(STRIPE_BIOFILL_RUN, &sh->state)) {
-		set_bit(STRIPE_OP_BIOFILL, &s->ops_request);
-		set_bit(STRIPE_BIOFILL_RUN, &sh->state);
-	}
-
-	pr_debug("locked=%d uptodate=%d to_read=%d"
-	       " to_write=%d failed=%d failed_num=%d,%d\n",
-	       s->locked, s->uptodate, s->to_read, s->to_write, s->failed,
-	       s->failed_num[0], s->failed_num[1]);
-	/* check if the array has lost >2 devices and, if so, some requests
-	 * might need to be failed
-	 */
-	if (s->failed > 2 && s->to_read+s->to_write+s->written)
-		handle_failed_stripe(conf, sh, s, disks, &s->return_bi);
-	if (s->failed > 2 && s->syncing) {
-		md_done_sync(conf->mddev, STRIPE_SECTORS,0);
-		clear_bit(STRIPE_SYNCING, &sh->state);
-		s->syncing = 0;
-	}
-
-	/*
-	 * might be able to return some write requests if the parity blocks
-	 * are safe, or on a failed drive
-	 */
-	pdev = &sh->dev[pd_idx];
-	s->p_failed = (s->failed >= 1 && s->failed_num[0] == pd_idx)
-		|| (s->failed >= 2 && s->failed_num[1] == pd_idx);
-	qdev = &sh->dev[qd_idx];
-	s->q_failed = (s->failed >= 1 && s->failed_num[0] == qd_idx)
-		|| (s->failed >= 2 && s->failed_num[1] == qd_idx);
-
-	if (s->written &&
-	    (s->p_failed || ((test_bit(R5_Insync, &pdev->flags)
-			     && !test_bit(R5_LOCKED, &pdev->flags)
-			     && test_bit(R5_UPTODATE, &pdev->flags)))) &&
-	    (s->q_failed || ((test_bit(R5_Insync, &qdev->flags)
-			     && !test_bit(R5_LOCKED, &qdev->flags)
-			     && test_bit(R5_UPTODATE, &qdev->flags)))))
-		handle_stripe_clean_event(conf, sh, disks, &s->return_bi);
-
-	/* Now we might consider reading some blocks, either to check/generate
-	 * parity, or to satisfy requests
-	 * or to load a block that is being partially written.
-	 */
-	if (s->to_read || s->non_overwrite || (s->to_write && s->failed) ||
-	    (s->syncing && (s->uptodate + s->compute < disks)) || s->expanding)
-		handle_stripe_fill(sh, s, disks);
-
 	return 0;
 }
 
@@ -3178,6 +3070,7 @@ static void handle_stripe(struct stripe_head *sh)
 	int i;
 	int prexor;
 	int disks = sh->disks;
+	struct r5dev *pdev, *qdev;
 
 	clear_bit(STRIPE_HANDLE, &sh->state);
 	if (test_and_set_bit(STRIPE_ACTIVE, &sh->state)) {
@@ -3214,6 +3107,67 @@ static void handle_stripe(struct stripe_head *sh)
 	if (done)
 		goto finish;
 
+	if (unlikely(s.blocked_rdev)) {
+		if (s.syncing || s.expanding || s.expanded ||
+		    s.to_write || s.written) {
+			set_bit(STRIPE_HANDLE, &sh->state);
+			goto finish;
+		}
+		/* There is nothing for the blocked_rdev to block */
+		rdev_dec_pending(s.blocked_rdev, conf->mddev);
+		s.blocked_rdev = NULL;
+	}
+
+	if (s.to_fill && !test_bit(STRIPE_BIOFILL_RUN, &sh->state)) {
+		set_bit(STRIPE_OP_BIOFILL, &s.ops_request);
+		set_bit(STRIPE_BIOFILL_RUN, &sh->state);
+	}
+
+	pr_debug("locked=%d uptodate=%d to_read=%d"
+	       " to_write=%d failed=%d failed_num=%d,%d\n",
+	       s.locked, s.uptodate, s.to_read, s.to_write, s.failed,
+	       s.failed_num[0], s.failed_num[1]);
+	/* check if the array has lost >2 devices and, if so, some requests
+	 * might need to be failed
+	 */
+	if (s.failed > conf->max_degraded && s.to_read+s.to_write+s.written)
+		handle_failed_stripe(conf, sh, &s, disks, &s.return_bi);
+	if (s.failed > conf->max_degraded && s.syncing) {
+		md_done_sync(conf->mddev, STRIPE_SECTORS, 0);
+		clear_bit(STRIPE_SYNCING, &sh->state);
+		s.syncing = 0;
+	}
+
+	/*
+	 * might be able to return some write requests if the parity blocks
+	 * are safe, or on a failed drive
+	 */
+	pdev = &sh->dev[sh->pd_idx];
+	s.p_failed = (s.failed >= 1 && s.failed_num[0] == sh->pd_idx)
+		|| (s.failed >= 2 && s.failed_num[1] == sh->pd_idx);
+	qdev = &sh->dev[sh->qd_idx];
+	s.q_failed = (s.failed >= 1 && s.failed_num[0] == sh->qd_idx)
+		|| (s.failed >= 2 && s.failed_num[1] == sh->qd_idx)
+		|| conf->level < 6;
+
+	if (s.written &&
+	    (s.p_failed || ((test_bit(R5_Insync, &pdev->flags)
+			     && !test_bit(R5_LOCKED, &pdev->flags)
+			     && test_bit(R5_UPTODATE, &pdev->flags)))) &&
+	    (s.q_failed || ((test_bit(R5_Insync, &qdev->flags)
+			     && !test_bit(R5_LOCKED, &qdev->flags)
+			     && test_bit(R5_UPTODATE, &qdev->flags)))))
+		handle_stripe_clean_event(conf, sh, disks, &s.return_bi);
+
+	/* Now we might consider reading some blocks, either to check/generate
+	 * parity, or to satisfy requests
+	 * or to load a block that is being partially written.
+	 */
+	if (s.to_read || s.non_overwrite
+	    || (conf->level == 6 && s.to_write && s.failed)
+	    || (s.syncing && (s.uptodate + s.compute < disks)) || s.expanding)
+		handle_stripe_fill(sh, &s, disks);
+
 	/* Now we check to see if any write operations have recently
 	 * completed
 	 */


