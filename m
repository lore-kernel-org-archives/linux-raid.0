From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH] md: close a livelock window in handle_parity_checks5
Date: Wed, 09 Apr 2008 17:48:15 -0700
Message-ID: <20080410004815.8276.91378.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: akpm@linux-foundation.org, neilb@suse.de
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

If a failure is detected after a parity check operation has been
initiated, but before it completes handle_parity_checks5 will never
quiesce operations on the stripe.

Explicitly handle this case by "canceling" the parity check, i.e. clear
the STRIPE_OP_CHECK flags and queue the stripe on the handle list again
to refresh any non-uptodate blocks.

Kernel versions >= 2.6.23 are susceptible.

Cc: stable@kernel.org
Cc: NeilBrown <neilb@suse.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 drivers/md/raid5.c |   51 +++++++++++++++++++++++++++++----------------------
 1 files changed, 29 insertions(+), 22 deletions(-)


diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index e43e27a..476142f 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2363,25 +2363,15 @@ static void handle_issuing_new_write_requests6(raid5_conf_t *conf,
 static void handle_parity_checks5(raid5_conf_t *conf, struct stripe_head *sh,
 				struct stripe_head_state *s, int disks)
 {
+	int canceled_check = 0;
+
 	set_bit(STRIPE_HANDLE, &sh->state);
-	/* Take one of the following actions:
-	 * 1/ start a check parity operation if (uptodate == disks)
-	 * 2/ finish a check parity operation and act on the result
-	 * 3/ skip to the writeback section if we previously
-	 *    initiated a recovery operation
-	 */
-	if (s->failed == 0 &&
-	    !test_bit(STRIPE_OP_MOD_REPAIR_PD, &sh->ops.pending)) {
-		if (!test_and_set_bit(STRIPE_OP_CHECK, &sh->ops.pending)) {
-			BUG_ON(s->uptodate != disks);
-			clear_bit(R5_UPTODATE, &sh->dev[sh->pd_idx].flags);
-			sh->ops.count++;
-			s->uptodate--;
-		} else if (
-		       test_and_clear_bit(STRIPE_OP_CHECK, &sh->ops.complete)) {
-			clear_bit(STRIPE_OP_CHECK, &sh->ops.ack);
-			clear_bit(STRIPE_OP_CHECK, &sh->ops.pending);
 
+	/* complete a check operation */
+	if (test_and_clear_bit(STRIPE_OP_CHECK, &sh->ops.complete)) {
+	    clear_bit(STRIPE_OP_CHECK, &sh->ops.ack);
+	    clear_bit(STRIPE_OP_CHECK, &sh->ops.pending);
+		if (s->failed == 0) {
 			if (sh->ops.zero_sum_result == 0)
 				/* parity is correct (on disc,
 				 * not in buffer any more)
@@ -2406,7 +2396,8 @@ static void handle_parity_checks5(raid5_conf_t *conf, struct stripe_head *sh,
 					s->uptodate++;
 				}
 			}
-		}
+		} else
+			canceled_check = 1; /* STRIPE_INSYNC is not set */
 	}
 
 	/* check if we can clear a parity disk reconstruct */
@@ -2419,12 +2410,28 @@ static void handle_parity_checks5(raid5_conf_t *conf, struct stripe_head *sh,
 		clear_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.pending);
 	}
 
+	/* start a new check operation if there are no failures, the stripe is
+	 * not insync, and a repair is not in flight
+	 */
+	if (s->failed == 0 &&
+	    !test_bit(STRIPE_INSYNC, &sh->state) &&
+	    !test_bit(STRIPE_OP_MOD_REPAIR_PD, &sh->ops.pending)) {
+		if (!test_and_set_bit(STRIPE_OP_CHECK, &sh->ops.pending)) {
+			BUG_ON(s->uptodate != disks);
+			clear_bit(R5_UPTODATE, &sh->dev[sh->pd_idx].flags);
+			sh->ops.count++;
+			s->uptodate--;
+		}
+	}
+
 	/* Wait for check parity and compute block operations to complete
-	 * before write-back
+	 * before write-back.  If a failure occurred while the check operation
+	 * was in flight we need to cycle this stripe through handle_stripe
+	 * since the parity block may not be uptodate
 	 */
-	if (!test_bit(STRIPE_INSYNC, &sh->state) &&
-		!test_bit(STRIPE_OP_CHECK, &sh->ops.pending) &&
-		!test_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.pending)) {
+	if (!canceled_check && !test_bit(STRIPE_INSYNC, &sh->state) &&
+	    !test_bit(STRIPE_OP_CHECK, &sh->ops.pending) &&
+	    !test_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.pending)) {
 		struct r5dev *dev;
 		/* either failed parity check, or recovery is happening */
 		if (s->failed == 0)

