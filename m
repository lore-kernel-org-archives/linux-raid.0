From: NeilBrown <neilb@suse.de>
Subject: [PATCH 024 of 29] md: md: replace STRIPE_OP_BIOFILL with STRIPE_BIOFILL_RUN
Date: Fri, 27 Jun 2008 16:51:57 +1000
Message-ID: <1080627065157.10707@suse.de>
References: <20080627164503.9671.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-raid.ids


From: Dan Williams <dan.j.williams@intel.com>

Track the state of read operations (copying data from the stripe cache to bio
buffers outside the lock) with a state flag.  Reduce the scope of the
STRIPE_OP_BIOFILL flag to only tracking whether a biofill operation has been
requested via the ops_request field of struct stripe_head_state.

This is another step towards the removal of ops.{pending,ack,complete,count},
i.e. STRIPE_OP_BIOFILL only requests an operation and does not track the state
of the operation.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid5.c |   33 ++++++++++++---------------------
 1 file changed, 12 insertions(+), 21 deletions(-)

diff .prev/drivers/md/raid5.c ./drivers/md/raid5.c
--- .prev/drivers/md/raid5.c	2008-06-27 16:22:05.000000000 +1000
+++ ./drivers/md/raid5.c	2008-06-27 16:22:05.000000000 +1000
@@ -523,38 +523,34 @@ static void ops_complete_biofill(void *s
 		(unsigned long long)sh->sector);
 
 	/* clear completed biofills */
+	spin_lock_irq(&conf->device_lock);
 	for (i = sh->disks; i--; ) {
 		struct r5dev *dev = &sh->dev[i];
 
 		/* acknowledge completion of a biofill operation */
 		/* and check if we need to reply to a read request,
 		 * new R5_Wantfill requests are held off until
-		 * !test_bit(STRIPE_OP_BIOFILL, &sh->ops.pending)
+		 * !STRIPE_BIOFILL_RUN
 		 */
 		if (test_and_clear_bit(R5_Wantfill, &dev->flags)) {
 			struct bio *rbi, *rbi2;
 
-			/* The access to dev->read is outside of the
-			 * spin_lock_irq(&conf->device_lock), but is protected
-			 * by the STRIPE_OP_BIOFILL pending bit
-			 */
 			BUG_ON(!dev->read);
 			rbi = dev->read;
 			dev->read = NULL;
 			while (rbi && rbi->bi_sector <
 				dev->sector + STRIPE_SECTORS) {
 				rbi2 = r5_next_bio(rbi, dev->sector);
-				spin_lock_irq(&conf->device_lock);
 				if (--rbi->bi_phys_segments == 0) {
 					rbi->bi_next = return_bi;
 					return_bi = rbi;
 				}
-				spin_unlock_irq(&conf->device_lock);
 				rbi = rbi2;
 			}
 		}
 	}
-	set_bit(STRIPE_OP_BIOFILL, &sh->ops.complete);
+	spin_unlock_irq(&conf->device_lock);
+	clear_bit(STRIPE_BIOFILL_RUN, &sh->state);
 
 	return_io(return_bi);
 
@@ -880,7 +876,7 @@ static void raid5_run_ops(struct stripe_
 	int overlap_clear = 0, i, disks = sh->disks;
 	struct dma_async_tx_descriptor *tx = NULL;
 
-	if (test_bit(STRIPE_OP_BIOFILL, &pending)) {
+	if (test_bit(STRIPE_OP_BIOFILL, &ops_request)) {
 		ops_run_biofill(sh);
 		overlap_clear++;
 	}
@@ -2630,15 +2626,8 @@ static void handle_stripe5(struct stripe
 	s.syncing = test_bit(STRIPE_SYNCING, &sh->state);
 	s.expanding = test_bit(STRIPE_EXPAND_SOURCE, &sh->state);
 	s.expanded = test_bit(STRIPE_EXPAND_READY, &sh->state);
-	/* Now to look around and see what can be done */
-
-	/* clean-up completed biofill operations */
-	if (test_bit(STRIPE_OP_BIOFILL, &sh->ops.complete)) {
-		clear_bit(STRIPE_OP_BIOFILL, &sh->ops.pending);
-		clear_bit(STRIPE_OP_BIOFILL, &sh->ops.ack);
-		clear_bit(STRIPE_OP_BIOFILL, &sh->ops.complete);
-	}
 
+	/* Now to look around and see what can be done */
 	rcu_read_lock();
 	for (i=disks; i--; ) {
 		mdk_rdev_t *rdev;
@@ -2652,10 +2641,10 @@ static void handle_stripe5(struct stripe
 		/* maybe we can request a biofill operation
 		 *
 		 * new wantfill requests are only permitted while
-		 * STRIPE_OP_BIOFILL is clear
+		 * ops_complete_biofill is guaranteed to be inactive
 		 */
 		if (test_bit(R5_UPTODATE, &dev->flags) && dev->toread &&
-			!test_bit(STRIPE_OP_BIOFILL, &sh->ops.pending))
+		    !test_bit(STRIPE_BIOFILL_RUN, &sh->state))
 			set_bit(R5_Wantfill, &dev->flags);
 
 		/* now count some things */
@@ -2699,8 +2688,10 @@ static void handle_stripe5(struct stripe
 		goto unlock;
 	}
 
-	if (s.to_fill && !test_and_set_bit(STRIPE_OP_BIOFILL, &sh->ops.pending))
-		sh->ops.count++;
+	if (s.to_fill && !test_bit(STRIPE_BIOFILL_RUN, &sh->state)) {
+		set_bit(STRIPE_OP_BIOFILL, &s.ops_request);
+		set_bit(STRIPE_BIOFILL_RUN, &sh->state);
+	}
 
 	pr_debug("locked=%d uptodate=%d to_read=%d"
 		" to_write=%d failed=%d failed_num=%d\n",
