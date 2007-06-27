From: Dan Williams <dan.j.williams@intel.com>
Subject: [md-accel PATCH 13/19] md: handle_stripe5 - add request/completion
	logic for async expand ops
Date: Tue, 26 Jun 2007 18:51:40 -0700
Message-ID: <20070627015140.18962.28368.stgit@dwillia2-linux.ch.intel.com>
References: <20070627014823.18962.96398.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070627014823.18962.96398.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Cc: neilb@suse.de, akpm@linux-foundation.org, davem@davemloft.net, christopher.leech@intel.com, shannon.nelson@intel.com, herbert@gondor.apana.org.au, jeff@garzik.org
List-Id: linux-raid.ids

When a stripe is being expanded bulk copying takes place to move the data
from the old stripe to the new.  Since raid5_run_ops only operates on one
stripe at a time these bulk copies are handled in-line under the stripe
lock.  In the dma offload case we poll for the completion of the operation.

After the data has been copied into the new stripe the parity needs to be
recalculated across the new disks.  We reuse the existing postxor
functionality to carry out this calculation.  By setting STRIPE_OP_POSTXOR
without setting STRIPE_OP_BIODRAIN the completion path in handle stripe
can differentiate expand operations from normal write operations.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Acked-By: NeilBrown <neilb@suse.de>
---

 drivers/md/raid5.c |   50 ++++++++++++++++++++++++++++++++++++++------------
 1 files changed, 38 insertions(+), 12 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 3d0dca9..e0ae26d 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2646,6 +2646,7 @@ static void handle_stripe_expansion(raid5_conf_t *conf, struct stripe_head *sh,
 	/* We have read all the blocks in this stripe and now we need to
 	 * copy some of them into a target stripe for expand.
 	 */
+	struct dma_async_tx_descriptor *tx = NULL;
 	clear_bit(STRIPE_EXPAND_SOURCE, &sh->state);
 	for (i = 0; i < sh->disks; i++)
 		if (i != sh->pd_idx && (r6s && i != r6s->qd_idx)) {
@@ -2671,9 +2672,12 @@ static void handle_stripe_expansion(raid5_conf_t *conf, struct stripe_head *sh,
 				release_stripe(sh2);
 				continue;
 			}
-			memcpy(page_address(sh2->dev[dd_idx].page),
-			       page_address(sh->dev[i].page),
-			       STRIPE_SIZE);
+
+			/* place all the copies on one channel */
+			tx = async_memcpy(sh2->dev[dd_idx].page,
+				sh->dev[i].page, 0, 0, STRIPE_SIZE,
+				ASYNC_TX_DEP_ACK, tx, NULL, NULL);
+
 			set_bit(R5_Expanded, &sh2->dev[dd_idx].flags);
 			set_bit(R5_UPTODATE, &sh2->dev[dd_idx].flags);
 			for (j = 0; j < conf->raid_disks; j++)
@@ -2686,6 +2690,12 @@ static void handle_stripe_expansion(raid5_conf_t *conf, struct stripe_head *sh,
 				set_bit(STRIPE_HANDLE, &sh2->state);
 			}
 			release_stripe(sh2);
+
+			/* done submitting copies, wait for them to complete */
+			if (i + 1 >= sh->disks) {
+				async_tx_ack(tx);
+				dma_wait_for_async_tx(tx);
+			}
 		}
 }
 
@@ -2924,18 +2934,34 @@ static void handle_stripe5(struct stripe_head *sh)
 		}
 	}
 
-	if (s.expanded && test_bit(STRIPE_EXPANDING, &sh->state)) {
-		/* Need to write out all blocks after computing parity */
-		sh->disks = conf->raid_disks;
-		sh->pd_idx = stripe_to_pdidx(sh->sector, conf, conf->raid_disks);
-		compute_parity5(sh, RECONSTRUCT_WRITE);
+	/* Finish postxor operations initiated by the expansion
+	 * process
+	 */
+	if (test_bit(STRIPE_OP_POSTXOR, &sh->ops.complete) &&
+		!test_bit(STRIPE_OP_BIODRAIN, &sh->ops.pending)) {
+
+		clear_bit(STRIPE_EXPANDING, &sh->state);
+
+		clear_bit(STRIPE_OP_POSTXOR, &sh->ops.pending);
+		clear_bit(STRIPE_OP_POSTXOR, &sh->ops.ack);
+		clear_bit(STRIPE_OP_POSTXOR, &sh->ops.complete);
+
 		for (i = conf->raid_disks; i--; ) {
-			set_bit(R5_LOCKED, &sh->dev[i].flags);
-			s.locked++;
 			set_bit(R5_Wantwrite, &sh->dev[i].flags);
+			if (!test_and_set_bit(STRIPE_OP_IO, &sh->ops.pending))
+				sh->ops.count++;
 		}
-		clear_bit(STRIPE_EXPANDING, &sh->state);
-	} else if (s.expanded) {
+	}
+
+	if (s.expanded && test_bit(STRIPE_EXPANDING, &sh->state) &&
+		!test_bit(STRIPE_OP_POSTXOR, &sh->ops.pending)) {
+		/* Need to write out all blocks after computing parity */
+		sh->disks = conf->raid_disks;
+		sh->pd_idx = stripe_to_pdidx(sh->sector, conf,
+			conf->raid_disks);
+		s.locked += handle_write_operations5(sh, 0, 1);
+	} else if (s.expanded &&
+		!test_bit(STRIPE_OP_POSTXOR, &sh->ops.pending)) {
 		clear_bit(STRIPE_EXPAND_READY, &sh->state);
 		atomic_dec(&conf->reshape_stripes);
 		wake_up(&conf->wait_for_overlap);
