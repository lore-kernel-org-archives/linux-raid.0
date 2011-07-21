From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 18/34] md/raid5: move more common code into handle_stripe
Date: Thu, 21 Jul 2011 12:32:26 +1000
Message-ID: <20110721023226.6728.76228.stgit@notabene.brown>
References: <20110721022537.6728.90204.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110721022537.6728.90204.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Apart from 'prexor' which can only be set for RAID5, and
'qd_idx' which can only be meaningful for RAID6, these two
chunks of code are nearly the same.

So combine them into one adding a test to call either
handle_parity_checks5 or handle_parity_checks6 as appropriate.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid5.c |  161 ++++++++++++++++++++--------------------------------
 1 files changed, 61 insertions(+), 100 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index b1eba98..ba6f892 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1756,7 +1756,7 @@ static sector_t raid5_compute_sector(raid5_conf_t *conf, sector_t r_sector,
 	/*
 	 * Select the parity disk based on the user selected algorithm.
 	 */
-	pd_idx = qd_idx = ~0;
+	pd_idx = qd_idx = -1;
 	switch(conf->level) {
 	case 4:
 		pd_idx = data_disks;
@@ -2904,7 +2904,6 @@ static int handle_stripe5(struct stripe_head *sh, struct stripe_head_state *s)
 	raid5_conf_t *conf = sh->raid_conf;
 	int disks = sh->disks, i;
 	struct r5dev *dev;
-	int prexor;
 
 	/* Now to look around and see what can be done */
 	rcu_read_lock();
@@ -3027,56 +3026,6 @@ static int handle_stripe5(struct stripe_head *sh, struct stripe_head_state *s)
 	    (s->syncing && (s->uptodate + s->compute < disks)) || s->expanding)
 		handle_stripe_fill(sh, s, disks);
 
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
-		BUG_ON(!test_bit(R5_UPTODATE, &sh->dev[sh->pd_idx].flags));
-		for (i = disks; i--; ) {
-			dev = &sh->dev[i];
-			if (test_bit(R5_LOCKED, &dev->flags) &&
-				(i == sh->pd_idx || dev->written)) {
-				pr_debug("Writing block %d\n", i);
-				set_bit(R5_Wantwrite, &dev->flags);
-				if (prexor)
-					continue;
-				if (!test_bit(R5_Insync, &dev->flags) ||
-				    (i == sh->pd_idx && s->failed == 0))
-					set_bit(STRIPE_INSYNC, &sh->state);
-			}
-		}
-		if (test_and_clear_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
-			s->dec_preread_active = 1;
-	}
-
-	/* Now to consider new write requests and what else, if anything
-	 * should be read.  We do not handle new writes when:
-	 * 1/ A 'write' operation (copy+xor) is already in flight.
-	 * 2/ A 'check' operation is in flight, as it may clobber the parity
-	 *    block.
-	 */
-	if (s->to_write && !sh->reconstruct_state && !sh->check_state)
-		handle_stripe_dirtying(conf, sh, s, disks);
-
-	/* maybe we need to check and possibly fix the parity for this stripe
-	 * Any reads will already have been scheduled, so we just see if enough
-	 * data is available.  The parity check is held off while parity
-	 * dependent operations are in flight.
-	 */
-	if (sh->check_state ||
-	    (s->syncing && s->locked == 0 &&
-	     !test_bit(STRIPE_COMPUTE_RUN, &sh->state) &&
-	     !test_bit(STRIPE_INSYNC, &sh->state)))
-		handle_parity_checks5(conf, sh, s, disks);
 	return 0;
 }
 
@@ -3218,54 +3167,6 @@ static int handle_stripe6(struct stripe_head *sh, struct stripe_head_state *s)
 	    (s->syncing && (s->uptodate + s->compute < disks)) || s->expanding)
 		handle_stripe_fill(sh, s, disks);
 
-	/* Now we check to see if any write operations have recently
-	 * completed
-	 */
-	if (sh->reconstruct_state == reconstruct_state_drain_result) {
-
-		sh->reconstruct_state = reconstruct_state_idle;
-		/* All the 'written' buffers and the parity blocks are ready to
-		 * be written back to disk
-		 */
-		BUG_ON(!test_bit(R5_UPTODATE, &sh->dev[sh->pd_idx].flags));
-		BUG_ON(!test_bit(R5_UPTODATE, &sh->dev[qd_idx].flags));
-		for (i = disks; i--; ) {
-			dev = &sh->dev[i];
-			if (test_bit(R5_LOCKED, &dev->flags) &&
-			    (i == sh->pd_idx || i == qd_idx ||
-			     dev->written)) {
-				pr_debug("Writing block %d\n", i);
-				BUG_ON(!test_bit(R5_UPTODATE, &dev->flags));
-				set_bit(R5_Wantwrite, &dev->flags);
-				if (!test_bit(R5_Insync, &dev->flags) ||
-				    ((i == sh->pd_idx || i == qd_idx) &&
-				      s->failed == 0))
-					set_bit(STRIPE_INSYNC, &sh->state);
-			}
-		}
-		if (test_and_clear_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
-			s->dec_preread_active = 1;
-	}
-
-	/* Now to consider new write requests and what else, if anything
-	 * should be read.  We do not handle new writes when:
-	 * 1/ A 'write' operation (copy+gen_syndrome) is already in flight.
-	 * 2/ A 'check' operation is in flight, as it may clobber the parity
-	 *    block.
-	 */
-	if (s->to_write && !sh->reconstruct_state && !sh->check_state)
-		handle_stripe_dirtying(conf, sh, s, disks);
-
-	/* maybe we need to check and possibly fix the parity for this stripe
-	 * Any reads will already have been scheduled, so we just see if enough
-	 * data is available.  The parity check is held off while parity
-	 * dependent operations are in flight.
-	 */
-	if (sh->check_state ||
-	    (s->syncing && s->locked == 0 &&
-	     !test_bit(STRIPE_COMPUTE_RUN, &sh->state) &&
-	     !test_bit(STRIPE_INSYNC, &sh->state)))
-		handle_parity_checks6(conf, sh, s, disks);
 	return 0;
 }
 
@@ -3275,6 +3176,8 @@ static void handle_stripe(struct stripe_head *sh)
 	int done;
 	raid5_conf_t *conf = sh->raid_conf;
 	int i;
+	int prexor;
+	int disks = sh->disks;
 
 	clear_bit(STRIPE_HANDLE, &sh->state);
 	if (test_and_set_bit(STRIPE_ACTIVE, &sh->state)) {
@@ -3311,6 +3214,64 @@ static void handle_stripe(struct stripe_head *sh)
 	if (done)
 		goto finish;
 
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
+		BUG_ON(!test_bit(R5_UPTODATE, &sh->dev[sh->pd_idx].flags));
+		BUG_ON(sh->qd_idx >= 0 &&
+		       !test_bit(R5_UPTODATE, &sh->dev[sh->qd_idx].flags));
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
+	/* Now to consider new write requests and what else, if anything
+	 * should be read.  We do not handle new writes when:
+	 * 1/ A 'write' operation (copy+xor) is already in flight.
+	 * 2/ A 'check' operation is in flight, as it may clobber the parity
+	 *    block.
+	 */
+	if (s.to_write && !sh->reconstruct_state && !sh->check_state)
+		handle_stripe_dirtying(conf, sh, &s, disks);
+
+	/* maybe we need to check and possibly fix the parity for this stripe
+	 * Any reads will already have been scheduled, so we just see if enough
+	 * data is available.  The parity check is held off while parity
+	 * dependent operations are in flight.
+	 */
+	if (sh->check_state ||
+	    (s.syncing && s.locked == 0 &&
+	     !test_bit(STRIPE_COMPUTE_RUN, &sh->state) &&
+	     !test_bit(STRIPE_INSYNC, &sh->state))) {
+		if (conf->level == 6)
+			handle_parity_checks6(conf, sh, &s, disks);
+		else
+			handle_parity_checks5(conf, sh, &s, disks);
+	}
 
 	if (s.syncing && s.locked == 0 && test_bit(STRIPE_INSYNC, &sh->state)) {
 		md_done_sync(conf->mddev, STRIPE_SECTORS, 1);


