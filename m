From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 2.6.21-rc4 07/15] md: move raid5 compute block operations to
	raid5_run_ops
Date: Thu, 22 Mar 2007 23:52:12 -0700
Message-ID: <20070323065212.15570.38346.stgit@dwillia2-linux.ch.intel.com>
References: <20070323064856.15570.45052.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070323064856.15570.45052.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, christopher.leech@intel.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org, yur@emcraft.com, wd@denx.de, arjan@linux.intel.com, rmk+kernel@arm.linux.org.uk
List-Id: linux-raid.ids

handle_stripe sets STRIPE_OP_COMPUTE_BLK to request servicing from
raid5_run_ops.  It also sets a flag for the block being computed to let
other parts of handle_stripe submit dependent operations.  raid5_run_ops
guarantees that the compute operation completes before any dependent
operation starts.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 drivers/md/raid5.c |  125 +++++++++++++++++++++++++++++++++++++++-------------
 1 files changed, 93 insertions(+), 32 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 4d1adb5..9856742 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1980,7 +1980,7 @@ static void handle_stripe5(struct stripe_head *sh)
 	int i;
 	int syncing, expanding, expanded;
 	int locked=0, uptodate=0, to_read=0, to_write=0, failed=0, written=0;
-	int non_overwrite = 0;
+	int compute=0, req_compute=0, non_overwrite=0;
 	int failed_num=0;
 	struct r5dev *dev;
 	unsigned long pending=0;
@@ -2032,8 +2032,8 @@ static void handle_stripe5(struct stripe_head *sh)
 		/* now count some things */
 		if (test_bit(R5_LOCKED, &dev->flags)) locked++;
 		if (test_bit(R5_UPTODATE, &dev->flags)) uptodate++;
+		if (test_bit(R5_Wantcompute, &dev->flags)) BUG_ON(++compute > 1);
 
-		
 		if (dev->toread) to_read++;
 		if (dev->towrite) {
 			to_write++;
@@ -2188,31 +2188,82 @@ static void handle_stripe5(struct stripe_head *sh)
 	 * parity, or to satisfy requests
 	 * or to load a block that is being partially written.
 	 */
-	if (to_read || non_overwrite || (syncing && (uptodate < disks)) || expanding) {
-		for (i=disks; i--;) {
-			dev = &sh->dev[i];
-			if (!test_bit(R5_LOCKED, &dev->flags) && !test_bit(R5_UPTODATE, &dev->flags) &&
-			    (dev->toread ||
-			     (dev->towrite && !test_bit(R5_OVERWRITE, &dev->flags)) ||
-			     syncing ||
-			     expanding ||
-			     (failed && (sh->dev[failed_num].toread ||
-					 (sh->dev[failed_num].towrite && !test_bit(R5_OVERWRITE, &sh->dev[failed_num].flags))))
-				    )
-				) {
-				/* we would like to get this block, possibly
-				 * by computing it, but we might not be able to
+	if (to_read || non_overwrite || (syncing && (uptodate + compute < disks)) || expanding ||
+		test_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.pending)) {
+
+		/* Clear completed compute operations.  Parity recovery
+		 * (STRIPE_OP_MOD_REPAIR_PD) implies a write-back which is handled
+		 * later on in this routine
+		 */
+		if (test_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.complete) &&
+			!test_bit(STRIPE_OP_MOD_REPAIR_PD, &sh->ops.pending)) {
+			clear_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.complete);
+			clear_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.ack);
+			clear_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.pending);
+		}
+
+		/* look for blocks to read/compute, skip this if a compute
+		 * is already in flight, or if the stripe contents are in the
+		 * midst of changing due to a write
+		 */
+		if (!test_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.pending) &&
+			!test_bit(STRIPE_OP_PREXOR, &sh->ops.pending) &&
+			!test_bit(STRIPE_OP_POSTXOR, &sh->ops.pending)) {
+			for (i=disks; i--;) {
+				dev = &sh->dev[i];
+
+				/* don't schedule compute operations or reads on
+				 * the parity block while a check is in flight
 				 */
-				if (uptodate == disks-1) {
-					PRINTK("Computing block %d\n", i);
-					compute_block(sh, i);
-					uptodate++;
-				} else if (test_bit(R5_Insync, &dev->flags)) {
-					set_bit(R5_LOCKED, &dev->flags);
-					set_bit(R5_Wantread, &dev->flags);
-					locked++;
-					PRINTK("Reading block %d (sync=%d)\n", 
-						i, syncing);
+				if ((i == sh->pd_idx) && test_bit(STRIPE_OP_CHECK, &sh->ops.pending))
+					continue;
+
+				if (!test_bit(R5_LOCKED, &dev->flags) && !test_bit(R5_UPTODATE, &dev->flags) &&
+				     (dev->toread ||
+				     (dev->towrite && !test_bit(R5_OVERWRITE, &dev->flags)) ||
+				     syncing ||
+				     expanding ||
+				     (failed && (sh->dev[failed_num].toread ||
+						 (sh->dev[failed_num].towrite &&
+						 	!test_bit(R5_OVERWRITE, &sh->dev[failed_num].flags))))
+					    )
+					) {
+					/* 1/ We would like to get this block, possibly
+					 * by computing it, but we might not be able to.
+					 *
+					 * 2/ Since parity check operations potentially
+					 * make the parity block !uptodate it will need
+					 * to be refreshed before any compute operations
+					 * on data disks are scheduled.
+					 *
+					 * 3/ We hold off parity block re-reads until check
+					 * operations have quiesced.
+					 */
+					if ((uptodate == disks-1) && !test_bit(STRIPE_OP_CHECK, &sh->ops.pending)) {
+						set_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.pending);
+						set_bit(R5_Wantcompute, &dev->flags);
+						sh->ops.target = i;
+						BUG_ON(req_compute++);
+						sh->ops.count++;
+						/* Careful: from this point on 'uptodate' is in the eye of
+						 * raid5_run_ops which services 'compute' operations before
+						 * writes. R5_Wantcompute flags a block that will be R5_UPTODATE
+						 * by the time it is needed for a subsequent operation.
+						 */
+						uptodate++;
+					} else if ((uptodate < disks-1) && test_bit(R5_Insync, &dev->flags)) {
+						/* Note: we hold off compute operations while checks are in flight,
+						 * but we still prefer 'compute' over 'read' hence we only read if
+						 * (uptodate < disks-1)
+						 */
+						set_bit(R5_LOCKED, &dev->flags);
+						set_bit(R5_Wantread, &dev->flags);
+						if (!test_and_set_bit(STRIPE_OP_IO, &sh->ops.pending))
+							sh->ops.count++;
+						locked++;
+						PRINTK("Reading block %d (sync=%d)\n",
+							i, syncing);
+					}
 				}
 			}
 		}
@@ -2287,7 +2338,7 @@ static void handle_stripe5(struct stripe_head *sh)
 			if ((dev->towrite || i == sh->pd_idx) &&
 			    (!test_bit(R5_LOCKED, &dev->flags) 
 				    ) &&
-			    !test_bit(R5_UPTODATE, &dev->flags)) {
+			    !(test_bit(R5_UPTODATE, &dev->flags) || test_bit(R5_Wantcompute, &dev->flags))) {
 				if (test_bit(R5_Insync, &dev->flags)
 /*				    && !(!mddev->insync && i == sh->pd_idx) */
 					)
@@ -2298,7 +2349,7 @@ static void handle_stripe5(struct stripe_head *sh)
 			if (!test_bit(R5_OVERWRITE, &dev->flags) && i != sh->pd_idx &&
 			    (!test_bit(R5_LOCKED, &dev->flags) 
 				    ) &&
-			    !test_bit(R5_UPTODATE, &dev->flags)) {
+			    !(test_bit(R5_UPTODATE, &dev->flags) || test_bit(R5_Wantcompute, &dev->flags))) {
 				if (test_bit(R5_Insync, &dev->flags)) rcw++;
 				else rcw += 2*disks;
 			}
@@ -2311,7 +2362,8 @@ static void handle_stripe5(struct stripe_head *sh)
 			for (i=disks; i--;) {
 				dev = &sh->dev[i];
 				if ((dev->towrite || i == sh->pd_idx) &&
-				    !test_bit(R5_LOCKED, &dev->flags) && !test_bit(R5_UPTODATE, &dev->flags) &&
+				    !test_bit(R5_LOCKED, &dev->flags) &&
+				    !(test_bit(R5_UPTODATE, &dev->flags) || test_bit(R5_Wantcompute, &dev->flags)) &&
 				    test_bit(R5_Insync, &dev->flags)) {
 					if (test_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
 					{
@@ -2330,7 +2382,8 @@ static void handle_stripe5(struct stripe_head *sh)
 			for (i=disks; i--;) {
 				dev = &sh->dev[i];
 				if (!test_bit(R5_OVERWRITE, &dev->flags) && i != sh->pd_idx &&
-				    !test_bit(R5_LOCKED, &dev->flags) && !test_bit(R5_UPTODATE, &dev->flags) &&
+				    !test_bit(R5_LOCKED, &dev->flags) &&
+				    !(test_bit(R5_UPTODATE, &dev->flags) || test_bit(R5_Wantcompute, &dev->flags)) &&
 				    test_bit(R5_Insync, &dev->flags)) {
 					if (test_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
 					{
@@ -2345,8 +2398,16 @@ static void handle_stripe5(struct stripe_head *sh)
 				}
 			}
 		/* now if nothing is locked, and if we have enough data, we can start a write request */
-		if (locked == 0 && (rcw == 0 ||rmw == 0) &&
-		    !test_bit(STRIPE_BIT_DELAY, &sh->state))
+		/* since handle_stripe can be called at any time we need to handle the case
+		 * where a compute block operation has been submitted and then a subsequent
+		 * call wants to start a write request.  raid5_run_ops only handles the case where
+		 * compute block and postxor are requested simultaneously.  If this
+		 * is not the case then new writes need to be held off until the compute
+		 * completes.
+		 */
+		if ((req_compute || !test_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.pending)) &&
+			(locked == 0 && (rcw == 0 ||rmw == 0) &&
+			!test_bit(STRIPE_BIT_DELAY, &sh->state)))
 			locked += handle_write_operations5(sh, rcw, 0);
 	}
 
