From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 17/34] md/raid5: unite handle_stripe_dirtying5 and
 handle_stripe_dirtying6
Date: Thu, 21 Jul 2011 12:32:26 +1000
Message-ID: <20110721023226.6728.28082.stgit@notabene.brown>
References: <20110721022537.6728.90204.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110721022537.6728.90204.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

RAID6 is only allowed to choose 'reconstruct-write' while RAID5 is
also allow 'read-modify-write'
Apart from this difference, handle_stripe_dirtying[56] are nearly
identical.  So resolve these differences and create just one function.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid5.c |   77 ++++++++++++++--------------------------------------
 1 files changed, 21 insertions(+), 56 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index ea796a9..b1eba98 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2468,11 +2468,19 @@ static void handle_stripe_clean_event(raid5_conf_t *conf,
 			md_wakeup_thread(conf->mddev->thread);
 }
 
-static void handle_stripe_dirtying5(raid5_conf_t *conf,
-		struct stripe_head *sh,	struct stripe_head_state *s, int disks)
+static void handle_stripe_dirtying(raid5_conf_t *conf,
+				   struct stripe_head *sh,
+				   struct stripe_head_state *s,
+				   int disks)
 {
 	int rmw = 0, rcw = 0, i;
-	for (i = disks; i--; ) {
+	if (conf->max_degraded == 2) {
+		/* RAID6 requires 'rcw' in current implementation
+		 * Calculate the real rcw later - for now fake it
+		 * look like rcw is cheaper
+		 */
+		rcw = 1; rmw = 2;
+	} else for (i = disks; i--; ) {
 		/* would I have to read this buffer for read_modify_write */
 		struct r5dev *dev = &sh->dev[i];
 		if ((dev->towrite || i == sh->pd_idx) &&
@@ -2519,16 +2527,19 @@ static void handle_stripe_dirtying5(raid5_conf_t *conf,
 				}
 			}
 		}
-	if (rcw <= rmw && rcw > 0)
+	if (rcw <= rmw && rcw > 0) {
 		/* want reconstruct write, but need to get some data */
+		rcw = 0;
 		for (i = disks; i--; ) {
 			struct r5dev *dev = &sh->dev[i];
 			if (!test_bit(R5_OVERWRITE, &dev->flags) &&
-			    i != sh->pd_idx &&
+			    i != sh->pd_idx && i != sh->qd_idx &&
 			    !test_bit(R5_LOCKED, &dev->flags) &&
 			    !(test_bit(R5_UPTODATE, &dev->flags) ||
-			    test_bit(R5_Wantcompute, &dev->flags)) &&
-			    test_bit(R5_Insync, &dev->flags)) {
+			      test_bit(R5_Wantcompute, &dev->flags))) {
+				rcw++;
+				if (!test_bit(R5_Insync, &dev->flags))
+					continue; /* it's a failed drive */
 				if (
 				  test_bit(STRIPE_PREREAD_ACTIVE, &sh->state)) {
 					pr_debug("Read_old block "
@@ -2542,6 +2553,7 @@ static void handle_stripe_dirtying5(raid5_conf_t *conf,
 				}
 			}
 		}
+	}
 	/* now if nothing is locked, and if we have enough data,
 	 * we can start a write request
 	 */
@@ -2558,53 +2570,6 @@ static void handle_stripe_dirtying5(raid5_conf_t *conf,
 		schedule_reconstruction(sh, s, rcw == 0, 0);
 }
 
-static void handle_stripe_dirtying6(raid5_conf_t *conf,
-		struct stripe_head *sh,	struct stripe_head_state *s,
-		int disks)
-{
-	int rcw = 0, pd_idx = sh->pd_idx, i;
-	int qd_idx = sh->qd_idx;
-
-	set_bit(STRIPE_HANDLE, &sh->state);
-	for (i = disks; i--; ) {
-		struct r5dev *dev = &sh->dev[i];
-		/* check if we haven't enough data */
-		if (!test_bit(R5_OVERWRITE, &dev->flags) &&
-		    i != pd_idx && i != qd_idx &&
-		    !test_bit(R5_LOCKED, &dev->flags) &&
-		    !(test_bit(R5_UPTODATE, &dev->flags) ||
-		      test_bit(R5_Wantcompute, &dev->flags))) {
-			rcw++;
-			if (!test_bit(R5_Insync, &dev->flags))
-				continue; /* it's a failed drive */
-
-			if (
-			  test_bit(STRIPE_PREREAD_ACTIVE, &sh->state)) {
-				pr_debug("Read_old stripe %llu "
-					"block %d for Reconstruct\n",
-				     (unsigned long long)sh->sector, i);
-				set_bit(R5_LOCKED, &dev->flags);
-				set_bit(R5_Wantread, &dev->flags);
-				s->locked++;
-			} else {
-				pr_debug("Request delayed stripe %llu "
-					"block %d for Reconstruct\n",
-				     (unsigned long long)sh->sector, i);
-				set_bit(STRIPE_DELAYED, &sh->state);
-				set_bit(STRIPE_HANDLE, &sh->state);
-			}
-		}
-	}
-	/* now if nothing is locked, and if we have enough data, we can start a
-	 * write request
-	 */
-	if ((s->req_compute || !test_bit(STRIPE_COMPUTE_RUN, &sh->state)) &&
-	    s->locked == 0 && rcw == 0 &&
-	    !test_bit(STRIPE_BIT_DELAY, &sh->state)) {
-		schedule_reconstruction(sh, s, 1, 0);
-	}
-}
-
 static void handle_parity_checks5(raid5_conf_t *conf, struct stripe_head *sh,
 				struct stripe_head_state *s, int disks)
 {
@@ -3100,7 +3065,7 @@ static int handle_stripe5(struct stripe_head *sh, struct stripe_head_state *s)
 	 *    block.
 	 */
 	if (s->to_write && !sh->reconstruct_state && !sh->check_state)
-		handle_stripe_dirtying5(conf, sh, s, disks);
+		handle_stripe_dirtying(conf, sh, s, disks);
 
 	/* maybe we need to check and possibly fix the parity for this stripe
 	 * Any reads will already have been scheduled, so we just see if enough
@@ -3289,7 +3254,7 @@ static int handle_stripe6(struct stripe_head *sh, struct stripe_head_state *s)
 	 *    block.
 	 */
 	if (s->to_write && !sh->reconstruct_state && !sh->check_state)
-		handle_stripe_dirtying6(conf, sh, s, disks);
+		handle_stripe_dirtying(conf, sh, s, disks);
 
 	/* maybe we need to check and possibly fix the parity for this stripe
 	 * Any reads will already have been scheduled, so we just see if enough


