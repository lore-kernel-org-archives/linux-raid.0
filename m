From: Dan Williams <dan.j.williams@intel.com>
Subject: [md-accel PATCH 10/19] md: handle_stripe5 - add request/completion
	logic for async compute ops
Date: Tue, 26 Jun 2007 18:51:25 -0700
Message-ID: <20070627015125.18962.77873.stgit@dwillia2-linux.ch.intel.com>
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

handle_stripe will compute a block when a backing disk has failed, or when
it determines it can save a disk read by computing the block from all the
other up-to-date blocks.

Previously a block would be computed under the lock and subsequent logic in
handle_stripe could use the newly up-to-date block.  With the raid5_run_ops
implementation the compute operation is carried out a later time outside
the lock.  To preserve the old functionality we take advantage of the
dependency chain feature of async_tx to flag the block as R5_Wantcompute
and then let other parts of handle_stripe operate on the block as if it
were up-to-date.  raid5_run_ops guarantees that the block will be ready
before it is used in another operation.

However, this only works in cases where the compute and the dependent
operation are scheduled at the same time.  If a previous call to
handle_stripe sets the R5_Wantcompute flag there is no facility to pass the
async_tx dependency chain across successive calls to raid5_run_ops.  The
req_compute variable protects against this case.

Changelog:
* remove the req_compute BUG_ON

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Acked-By: NeilBrown <neilb@suse.de>
---

 drivers/md/raid5.c         |  149 ++++++++++++++++++++++++++++++++++----------
 include/linux/raid/raid5.h |    2 -
 2 files changed, 115 insertions(+), 36 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index b2e88fe..38b8167 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2070,36 +2070,101 @@ handle_requests_to_failed_array(raid5_conf_t *conf, struct stripe_head *sh,
 
 }
 
+/* __handle_issuing_new_read_requests5 - returns 0 if there are no more disks
+ * to process
+ */
+static int __handle_issuing_new_read_requests5(struct stripe_head *sh,
+			struct stripe_head_state *s, int disk_idx, int disks)
+{
+	struct r5dev *dev = &sh->dev[disk_idx];
+	struct r5dev *failed_dev = &sh->dev[s->failed_num];
+
+	/* don't schedule compute operations or reads on the parity block while
+	 * a check is in flight
+	 */
+	if ((disk_idx == sh->pd_idx) &&
+	     test_bit(STRIPE_OP_CHECK, &sh->ops.pending))
+		return ~0;
+
+	/* is the data in this block needed, and can we get it? */
+	if (!test_bit(R5_LOCKED, &dev->flags) &&
+	    !test_bit(R5_UPTODATE, &dev->flags) && (dev->toread ||
+	    (dev->towrite && !test_bit(R5_OVERWRITE, &dev->flags)) ||
+	     s->syncing || s->expanding || (s->failed &&
+	     (failed_dev->toread || (failed_dev->towrite &&
+	     !test_bit(R5_OVERWRITE, &failed_dev->flags)
+	     ))))) {
+		/* 1/ We would like to get this block, possibly by computing it,
+		 * but we might not be able to.
+		 *
+		 * 2/ Since parity check operations potentially make the parity
+		 * block !uptodate it will need to be refreshed before any
+		 * compute operations on data disks are scheduled.
+		 *
+		 * 3/ We hold off parity block re-reads until check operations
+		 * have quiesced.
+		 */
+		if ((s->uptodate == disks - 1) &&
+		    !test_bit(STRIPE_OP_CHECK, &sh->ops.pending)) {
+			set_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.pending);
+			set_bit(R5_Wantcompute, &dev->flags);
+			sh->ops.target = disk_idx;
+			s->req_compute = 1;
+			sh->ops.count++;
+			/* Careful: from this point on 'uptodate' is in the eye
+			 * of raid5_run_ops which services 'compute' operations
+			 * before writes. R5_Wantcompute flags a block that will
+			 * be R5_UPTODATE by the time it is needed for a
+			 * subsequent operation.
+			 */
+			s->uptodate++;
+			return 0; /* uptodate + compute == disks */
+		} else if ((s->uptodate < disks - 1) &&
+			test_bit(R5_Insync, &dev->flags)) {
+			/* Note: we hold off compute operations while checks are
+			 * in flight, but we still prefer 'compute' over 'read'
+			 * hence we only read if (uptodate < * disks-1)
+			 */
+			set_bit(R5_LOCKED, &dev->flags);
+			set_bit(R5_Wantread, &dev->flags);
+			if (!test_and_set_bit(STRIPE_OP_IO, &sh->ops.pending))
+				sh->ops.count++;
+			s->locked++;
+			pr_debug("Reading block %d (sync=%d)\n", disk_idx,
+				s->syncing);
+		}
+	}
+
+	return ~0;
+}
+
 static void handle_issuing_new_read_requests5(struct stripe_head *sh,
 			struct stripe_head_state *s, int disks)
 {
 	int i;
-	for (i = disks; i--; ) {
-		struct r5dev *dev = &sh->dev[i];
-		if (!test_bit(R5_LOCKED, &dev->flags) &&
-		    !test_bit(R5_UPTODATE, &dev->flags) &&
-		    (dev->toread ||
-		     (dev->towrite && !test_bit(R5_OVERWRITE, &dev->flags)) ||
-		     s->syncing || s->expanding ||
-		     (s->failed && (sh->dev[s->failed_num].toread ||
-			(sh->dev[s->failed_num].towrite &&
-			!test_bit(R5_OVERWRITE, &sh->dev[s->failed_num].flags))
-		      )))) {
-			/* we would like to get this block, possibly
-			 * by computing it, but we might not be able to
-			 */
-			if (s->uptodate == disks-1) {
-				pr_debug("Computing block %d\n", i);
-				compute_block(sh, i);
-				s->uptodate++;
-			} else if (test_bit(R5_Insync, &dev->flags)) {
-				set_bit(R5_LOCKED, &dev->flags);
-				set_bit(R5_Wantread, &dev->flags);
-				s->locked++;
-				pr_debug("Reading block %d (sync=%d)\n",
-					i, s->syncing);
-			}
-		}
+
+	/* Clear completed compute operations.  Parity recovery
+	 * (STRIPE_OP_MOD_REPAIR_PD) implies a write-back which is handled
+	 * later on in this routine
+	 */
+	if (test_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.complete) &&
+		!test_bit(STRIPE_OP_MOD_REPAIR_PD, &sh->ops.pending)) {
+		clear_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.complete);
+		clear_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.ack);
+		clear_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.pending);
+	}
+
+	/* look for blocks to read/compute, skip this if a compute
+	 * is already in flight, or if the stripe contents are in the
+	 * midst of changing due to a write
+	 */
+	if (!test_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.pending) &&
+		!test_bit(STRIPE_OP_PREXOR, &sh->ops.pending) &&
+		!test_bit(STRIPE_OP_POSTXOR, &sh->ops.pending)) {
+		for (i = disks; i--; )
+			if (__handle_issuing_new_read_requests5(
+				sh, s, i, disks) == 0)
+				break;
 	}
 	set_bit(STRIPE_HANDLE, &sh->state);
 }
@@ -2216,7 +2281,8 @@ static void handle_issuing_new_write_requests5(raid5_conf_t *conf,
 		struct r5dev *dev = &sh->dev[i];
 		if ((dev->towrite || i == sh->pd_idx) &&
 		    !test_bit(R5_LOCKED, &dev->flags) &&
-		    !test_bit(R5_UPTODATE, &dev->flags)) {
+		    !(test_bit(R5_UPTODATE, &dev->flags) ||
+		      test_bit(R5_Wantcompute, &dev->flags))) {
 			if (test_bit(R5_Insync, &dev->flags))
 				rmw++;
 			else
@@ -2225,9 +2291,9 @@ static void handle_issuing_new_write_requests5(raid5_conf_t *conf,
 		/* Would I have to read this buffer for reconstruct_write */
 		if (!test_bit(R5_OVERWRITE, &dev->flags) && i != sh->pd_idx &&
 		    !test_bit(R5_LOCKED, &dev->flags) &&
-		    !test_bit(R5_UPTODATE, &dev->flags)) {
-			if (test_bit(R5_Insync, &dev->flags))
-				rcw++;
+		    !(test_bit(R5_UPTODATE, &dev->flags) ||
+		    test_bit(R5_Wantcompute, &dev->flags))) {
+			if (test_bit(R5_Insync, &dev->flags)) rcw++;
 			else
 				rcw += 2*disks;
 		}
@@ -2241,7 +2307,8 @@ static void handle_issuing_new_write_requests5(raid5_conf_t *conf,
 			struct r5dev *dev = &sh->dev[i];
 			if ((dev->towrite || i == sh->pd_idx) &&
 			    !test_bit(R5_LOCKED, &dev->flags) &&
-			    !test_bit(R5_UPTODATE, &dev->flags) &&
+			    !(test_bit(R5_UPTODATE, &dev->flags) ||
+			    test_bit(R5_Wantcompute, &dev->flags)) &&
 			    test_bit(R5_Insync, &dev->flags)) {
 				if (
 				  test_bit(STRIPE_PREREAD_ACTIVE, &sh->state)) {
@@ -2263,7 +2330,8 @@ static void handle_issuing_new_write_requests5(raid5_conf_t *conf,
 			if (!test_bit(R5_OVERWRITE, &dev->flags) &&
 			    i != sh->pd_idx &&
 			    !test_bit(R5_LOCKED, &dev->flags) &&
-			    !test_bit(R5_UPTODATE, &dev->flags) &&
+			    !(test_bit(R5_UPTODATE, &dev->flags) ||
+			    test_bit(R5_Wantcompute, &dev->flags)) &&
 			    test_bit(R5_Insync, &dev->flags)) {
 				if (
 				  test_bit(STRIPE_PREREAD_ACTIVE, &sh->state)) {
@@ -2281,8 +2349,17 @@ static void handle_issuing_new_write_requests5(raid5_conf_t *conf,
 	/* now if nothing is locked, and if we have enough data,
 	 * we can start a write request
 	 */
-	if (s->locked == 0 && (rcw == 0 || rmw == 0) &&
-	    !test_bit(STRIPE_BIT_DELAY, &sh->state))
+	/* since handle_stripe can be called at any time we need to handle the
+	 * case where a compute block operation has been submitted and then a
+	 * subsequent call wants to start a write request.  raid5_run_ops only
+	 * handles the case where compute block and postxor are requested
+	 * simultaneously.  If this is not the case then new writes need to be
+	 * held off until the compute completes.
+	 */
+	if ((s->req_compute ||
+	    !test_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.pending)) &&
+		(s->locked == 0 && (rcw == 0 || rmw == 0) &&
+		!test_bit(STRIPE_BIT_DELAY, &sh->state)))
 		s->locked += handle_write_operations5(sh, rcw == 0, 0);
 }
 
@@ -2643,6 +2720,7 @@ static void handle_stripe5(struct stripe_head *sh)
 		/* now count some things */
 		if (test_bit(R5_LOCKED, &dev->flags)) s.locked++;
 		if (test_bit(R5_UPTODATE, &dev->flags)) s.uptodate++;
+		if (test_bit(R5_Wantcompute, &dev->flags)) s.compute++;
 
 		if (dev->toread)
 			s.to_read++;
@@ -2699,7 +2777,8 @@ static void handle_stripe5(struct stripe_head *sh)
 	 * or to load a block that is being partially written.
 	 */
 	if (s.to_read || s.non_overwrite ||
-		(s.syncing && (s.uptodate < disks)) || s.expanding)
+	    (s.syncing && (s.uptodate + s.compute < disks)) || s.expanding ||
+	    test_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.pending))
 		handle_issuing_new_read_requests5(sh, &s, disks);
 
 	/* Now we check to see if any write operations have recently
diff --git a/include/linux/raid/raid5.h b/include/linux/raid/raid5.h
index f623a44..2d45eba 100644
--- a/include/linux/raid/raid5.h
+++ b/include/linux/raid/raid5.h
@@ -200,7 +200,7 @@ struct stripe_head {
 struct stripe_head_state {
 	int syncing, expanding, expanded;
 	int locked, uptodate, to_read, to_write, failed, written;
-	int non_overwrite, dirty;
+	int compute, req_compute, non_overwrite, dirty;
 	int failed_num;
 };
 
