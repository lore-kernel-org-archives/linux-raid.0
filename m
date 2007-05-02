From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 09/16] md: move raid5 parity checks to raid5_run_ops
Date: Tue, 01 May 2007 23:19:11 -0700
Message-ID: <20070502061911.7066.33604.stgit@dwillia2-linux.ch.intel.com>
References: <20070502060949.7066.357.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070502060949.7066.357.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, akpm@linux-foundation.org, christopher.leech@intel.com
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

handle_stripe sets STRIPE_OP_CHECK to request a check operation in
raid5_run_ops.  If raid5_run_ops is able to perform the check with a
dma engine the parity will be preserved in memory removing the need to
re-read it from disk, as is necessary in the synchronous case.

'Repair' operations re-use the same logic as compute block, with the caveat
that the results of the compute block are immediately written back to the
parity disk.  To differentiate these operations the STRIPE_OP_MOD_REPAIR_PD
flag is added.

Changelog:
* remove test_and_set/test_and_clear BUG_ONs, Neil Brown

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 drivers/md/raid5.c |   80 ++++++++++++++++++++++++++++++++++++++++------------
 1 files changed, 61 insertions(+), 19 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 844bd9b..f8a4522 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2430,32 +2430,74 @@ static void handle_stripe5(struct stripe_head *sh)
 			locked += handle_write_operations5(sh, rcw == 0, 0);
 	}
 
-	/* maybe we need to check and possibly fix the parity for this stripe
-	 * Any reads will already have been scheduled, so we just see if enough data
-	 * is available
+	/* 1/ Maybe we need to check and possibly fix the parity for this stripe.
+	 *    Any reads will already have been scheduled, so we just see if enough data
+	 *    is available.
+	 * 2/ Hold off parity checks while parity dependent operations are in flight
+	 *    (conflicting writes are protected by the 'locked' variable)
 	 */
-	if (syncing && locked == 0 &&
-	    !test_bit(STRIPE_INSYNC, &sh->state)) {
+	if ((syncing && locked == 0 && !test_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.pending) &&
+		!test_bit(STRIPE_INSYNC, &sh->state)) ||
+	    	test_bit(STRIPE_OP_CHECK, &sh->ops.pending) ||
+	    	test_bit(STRIPE_OP_MOD_REPAIR_PD, &sh->ops.pending)) {
+
 		set_bit(STRIPE_HANDLE, &sh->state);
-		if (failed == 0) {
-			BUG_ON(uptodate != disks);
-			compute_parity5(sh, CHECK_PARITY);
-			uptodate--;
-			if (page_is_zero(sh->dev[sh->pd_idx].page)) {
-				/* parity is correct (on disc, not in buffer any more) */
-				set_bit(STRIPE_INSYNC, &sh->state);
-			} else {
-				conf->mddev->resync_mismatches += STRIPE_SECTORS;
-				if (test_bit(MD_RECOVERY_CHECK, &conf->mddev->recovery))
-					/* don't try to repair!! */
+		/* Take one of the following actions:
+		 * 1/ start a check parity operation if (uptodate == disks)
+		 * 2/ finish a check parity operation and act on the result
+		 * 3/ skip to the writeback section if we previously
+		 *    initiated a recovery operation
+		 */
+		if (failed == 0 && !test_bit(STRIPE_OP_MOD_REPAIR_PD, &sh->ops.pending)) {
+			if (!test_and_set_bit(STRIPE_OP_CHECK, &sh->ops.pending)) {
+				BUG_ON(uptodate != disks);
+				clear_bit(R5_UPTODATE, &sh->dev[sh->pd_idx].flags);
+				sh->ops.count++;
+				uptodate--;
+			} else if (test_and_clear_bit(STRIPE_OP_CHECK, &sh->ops.complete)) {
+				clear_bit(STRIPE_OP_CHECK, &sh->ops.ack);
+				clear_bit(STRIPE_OP_CHECK, &sh->ops.pending);
+
+				if (sh->ops.zero_sum_result == 0)
+					/* parity is correct (on disc, not in buffer any more) */
 					set_bit(STRIPE_INSYNC, &sh->state);
 				else {
-					compute_block(sh, sh->pd_idx);
-					uptodate++;
+					conf->mddev->resync_mismatches += STRIPE_SECTORS;
+					if (test_bit(MD_RECOVERY_CHECK, &conf->mddev->recovery))
+						/* don't try to repair!! */
+						set_bit(STRIPE_INSYNC, &sh->state);
+					else {
+						set_bit(STRIPE_OP_COMPUTE_BLK,
+							&sh->ops.pending);
+						set_bit(STRIPE_OP_MOD_REPAIR_PD,
+							&sh->ops.pending);
+						set_bit(R5_Wantcompute,
+							&sh->dev[sh->pd_idx].flags);
+						sh->ops.target = sh->pd_idx;
+						sh->ops.count++;
+						uptodate++;
+					}
 				}
 			}
 		}
-		if (!test_bit(STRIPE_INSYNC, &sh->state)) {
+
+		/* check if we can clear a parity disk reconstruct */
+		if (test_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.complete) &&
+			test_bit(STRIPE_OP_MOD_REPAIR_PD, &sh->ops.pending)) {
+
+			clear_bit(STRIPE_OP_MOD_REPAIR_PD, &sh->ops.pending);
+			clear_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.complete);
+			clear_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.ack);
+			clear_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.pending);
+		}
+
+		/* Wait for check parity and compute block operations to complete
+		 * before write-back
+		 */
+		if (!test_bit(STRIPE_INSYNC, &sh->state) &&
+			!test_bit(STRIPE_OP_CHECK, &sh->ops.pending) &&
+			!test_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.pending)) {
+
 			/* either failed parity check, or recovery is happening */
 			if (failed==0)
 				failed_num = sh->pd_idx;
