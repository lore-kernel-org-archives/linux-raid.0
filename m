From: Shaohua Li <shli@kernel.org>
Subject: [patch 1/3]raid5: adjust order of some operations in handle_stripe
Date: Thu, 22 May 2014 19:24:31 +0800
Message-ID: <20140522112431.GA10509@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids


This is to revert ef5b7c69b7a1b8b8744a6168b6f. handle_stripe_clean_event()
handles finished stripes, which really should be the first thing to do. The
original changelog says checking reconstruct_state should be the first as
handle_stripe_clean_event can clear some dev->flags and impact checking
reconstruct_state code path. It's unclear to me why this happens, because I
thought written finish and reconstruct_state equals to *_result can't happen in
the same time.

I also moved checking reconstruct_state code path after handle_stripe_dirtying.
If that code sets reconstruct_state to reconstruct_state_idle, the order change
will make us miss one handle_stripe_dirtying. But the stripe will be eventually
handled again when written is finished.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 drivers/md/raid5.c |   74 ++++++++++++++++++++++++++---------------------------
 1 file changed, 37 insertions(+), 37 deletions(-)

Index: linux/drivers/md/raid5.c
===================================================================
--- linux.orig/drivers/md/raid5.c	2014-05-22 13:27:21.000000000 +0800
+++ linux/drivers/md/raid5.c	2014-05-22 14:41:05.603276379 +0800
@@ -3747,43 +3747,6 @@ static void handle_stripe(struct stripe_
 			handle_failed_sync(conf, sh, &s);
 	}
 
-	/* Now we check to see if any write operations have recently
-	 * completed
-	 */
-	prexor = 0;
-	if (sh->reconstruct_state == reconstruct_state_prexor_drain_result)
-		prexor = 1;
-	if (sh->reconstruct_state == reconstruct_state_drain_result ||
-	    sh->reconstruct_state == reconstruct_state_prexor_drain_result) {
-		sh->reconstruct_state = reconstruct_state_idle;
-
-		/* All the 'written' buffers and the parity block are ready to
-		 * be written back to disk
-		 */
-		BUG_ON(!test_bit(R5_UPTODATE, &sh->dev[sh->pd_idx].flags) &&
-		       !test_bit(R5_Discard, &sh->dev[sh->pd_idx].flags));
-		BUG_ON(sh->qd_idx >= 0 &&
-		       !test_bit(R5_UPTODATE, &sh->dev[sh->qd_idx].flags) &&
-		       !test_bit(R5_Discard, &sh->dev[sh->qd_idx].flags));
-		for (i = disks; i--; ) {
-			struct r5dev *dev = &sh->dev[i];
-			if (test_bit(R5_LOCKED, &dev->flags) &&
-				(i == sh->pd_idx || i == sh->qd_idx ||
-				 dev->written)) {
-				pr_debug("Writing block %d\n", i);
-				set_bit(R5_Wantwrite, &dev->flags);
-				if (prexor)
-					continue;
-				if (!test_bit(R5_Insync, &dev->flags) ||
-				    ((i == sh->pd_idx || i == sh->qd_idx)  &&
-				     s.failed == 0))
-					set_bit(STRIPE_INSYNC, &sh->state);
-			}
-		}
-		if (test_and_clear_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
-			s.dec_preread_active = 1;
-	}
-
 	/*
 	 * might be able to return some write requests if the parity blocks
 	 * are safe, or on a failed drive
@@ -3827,6 +3790,43 @@ static void handle_stripe(struct stripe_
 	if (s.to_write && !sh->reconstruct_state && !sh->check_state)
 		handle_stripe_dirtying(conf, sh, &s, disks);
 
+	/* Now we check to see if any write operations have recently
+	 * completed
+	 */
+	prexor = 0;
+	if (sh->reconstruct_state == reconstruct_state_prexor_drain_result)
+		prexor = 1;
+	if (sh->reconstruct_state == reconstruct_state_drain_result ||
+	    sh->reconstruct_state == reconstruct_state_prexor_drain_result) {
+		sh->reconstruct_state = reconstruct_state_idle;
+
+		/* All the 'written' buffers and the parity block are ready to
+		 * be written back to disk
+		 */
+		BUG_ON(!test_bit(R5_UPTODATE, &sh->dev[sh->pd_idx].flags) &&
+		       !test_bit(R5_Discard, &sh->dev[sh->pd_idx].flags));
+		BUG_ON(sh->qd_idx >= 0 &&
+		       !test_bit(R5_UPTODATE, &sh->dev[sh->qd_idx].flags) &&
+		       !test_bit(R5_Discard, &sh->dev[sh->qd_idx].flags));
+		for (i = disks; i--; ) {
+			struct r5dev *dev = &sh->dev[i];
+			if (test_bit(R5_LOCKED, &dev->flags) &&
+				(i == sh->pd_idx || i == sh->qd_idx ||
+				 dev->written)) {
+				pr_debug("Writing block %d\n", i);
+				set_bit(R5_Wantwrite, &dev->flags);
+				if (prexor)
+					continue;
+				if (!test_bit(R5_Insync, &dev->flags) ||
+				    ((i == sh->pd_idx || i == sh->qd_idx)  &&
+				     s.failed == 0))
+					set_bit(STRIPE_INSYNC, &sh->state);
+			}
+		}
+		if (test_and_clear_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
+			s.dec_preread_active = 1;
+	}
+
 	/* maybe we need to check and possibly fix the parity for this stripe
 	 * Any reads will already have been scheduled, so we just see if enough
 	 * data is available.  The parity check is held off while parity
