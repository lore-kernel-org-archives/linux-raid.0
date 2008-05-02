From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH] md: fix raid5 'repair' operations
Date: Fri, 02 May 2008 14:27:15 -0700
Message-ID: <20080502212715.22922.79901.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: akpm@linux-foundation.org
Cc: neilb@suse.de, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux@horizon.com
List-Id: linux-raid.ids

commit bd2ab67030e9116f1e4aae1289220255412b37fd "md: close a livelock
window in handle_parity_checks5" introduced a bug in handling 'repair'
operations.  After a repair operation completes we clear the state bits
tracking this operation.  However, they are cleared too early and this
results in the code deciding to re-run the parity check operation.  Since
we have done the repair in memory the second check does not find a mismatch
and thus does not do a writeback.

Test results:
$ echo repair > /sys/block/md0/md/sync_action
$ cat /sys/block/md0/md/mismatch_cnt
51072
$ echo repair > /sys/block/md0/md/sync_action
$ cat /sys/block/md0/md/mismatch_cnt
0

(also fix incorrect indentation)

Cc: <stable@kernel.org>
Tested-by: George Spelvin <linux@horizon.com>
Acked-by: NeilBrown <neilb@suse.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 drivers/md/raid5.c |   25 +++++++++++++------------
 1 files changed, 13 insertions(+), 12 deletions(-)


diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 087eee0..ee0ea91 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2369,8 +2369,8 @@ static void handle_parity_checks5(raid5_conf_t *conf, struct stripe_head *sh,
 
 	/* complete a check operation */
 	if (test_and_clear_bit(STRIPE_OP_CHECK, &sh->ops.complete)) {
-	    clear_bit(STRIPE_OP_CHECK, &sh->ops.ack);
-	    clear_bit(STRIPE_OP_CHECK, &sh->ops.pending);
+		clear_bit(STRIPE_OP_CHECK, &sh->ops.ack);
+		clear_bit(STRIPE_OP_CHECK, &sh->ops.pending);
 		if (s->failed == 0) {
 			if (sh->ops.zero_sum_result == 0)
 				/* parity is correct (on disc,
@@ -2400,16 +2400,6 @@ static void handle_parity_checks5(raid5_conf_t *conf, struct stripe_head *sh,
 			canceled_check = 1; /* STRIPE_INSYNC is not set */
 	}
 
-	/* check if we can clear a parity disk reconstruct */
-	if (test_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.complete) &&
-		test_bit(STRIPE_OP_MOD_REPAIR_PD, &sh->ops.pending)) {
-
-		clear_bit(STRIPE_OP_MOD_REPAIR_PD, &sh->ops.pending);
-		clear_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.complete);
-		clear_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.ack);
-		clear_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.pending);
-	}
-
 	/* start a new check operation if there are no failures, the stripe is
 	 * not insync, and a repair is not in flight
 	 */
@@ -2424,6 +2414,17 @@ static void handle_parity_checks5(raid5_conf_t *conf, struct stripe_head *sh,
 		}
 	}
 
+	/* check if we can clear a parity disk reconstruct */
+	if (test_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.complete) &&
+	    test_bit(STRIPE_OP_MOD_REPAIR_PD, &sh->ops.pending)) {
+
+		clear_bit(STRIPE_OP_MOD_REPAIR_PD, &sh->ops.pending);
+		clear_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.complete);
+		clear_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.ack);
+		clear_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.pending);
+	}
+
+
 	/* Wait for check parity and compute block operations to complete
 	 * before write-back.  If a failure occurred while the check operation
 	 * was in flight we need to cycle this stripe through handle_stripe

