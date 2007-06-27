From: Dan Williams <dan.j.williams@intel.com>
Subject: [md-accel PATCH 09/19] md: handle_stripe5 - add request/completion
	logic for async write ops
Date: Tue, 26 Jun 2007 18:51:20 -0700
Message-ID: <20070627015120.18962.89311.stgit@dwillia2-linux.ch.intel.com>
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

After handle_stripe5 decides whether it wants to perform a
read-modify-write, or a reconstruct write it calls
handle_write_operations5.  A read-modify-write operation will perform an
xor subtraction of the blocks marked with the R5_Wantprexor flag, copy the
new data into the stripe (biodrain) and perform a postxor operation across
all up-to-date blocks to generate the new parity.  A reconstruct write is run
when all blocks are already up-to-date in the cache so all that is needed
is a biodrain and postxor.

On the completion path STRIPE_OP_PREXOR will be set if the operation was a
read-modify-write.  The STRIPE_OP_BIODRAIN flag is used in the completion
path to differentiate write-initiated postxor operations versus
expansion-initiated postxor operations.  Completion of a write triggers i/o
to the drives.

Changelog:
* make the 'rcw' parameter to handle_write_operations5 a simple flag, Neil Brown
* remove test_and_set/test_and_clear BUG_ONs, Neil Brown

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Acked-By: NeilBrown <neilb@suse.de>
---

 drivers/md/raid5.c |  161 +++++++++++++++++++++++++++++++++++++++++++++-------
 1 files changed, 138 insertions(+), 23 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 7c688f6..b2e88fe 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1815,7 +1815,79 @@ static void compute_block_2(struct stripe_head *sh, int dd_idx1, int dd_idx2)
 	}
 }
 
+static int
+handle_write_operations5(struct stripe_head *sh, int rcw, int expand)
+{
+	int i, pd_idx = sh->pd_idx, disks = sh->disks;
+	int locked = 0;
+
+	if (rcw) {
+		/* if we are not expanding this is a proper write request, and
+		 * there will be bios with new data to be drained into the
+		 * stripe cache
+		 */
+		if (!expand) {
+			set_bit(STRIPE_OP_BIODRAIN, &sh->ops.pending);
+			sh->ops.count++;
+		}
+
+		set_bit(STRIPE_OP_POSTXOR, &sh->ops.pending);
+		sh->ops.count++;
+
+		for (i = disks; i--; ) {
+			struct r5dev *dev = &sh->dev[i];
+
+			if (dev->towrite) {
+				set_bit(R5_LOCKED, &dev->flags);
+				if (!expand)
+					clear_bit(R5_UPTODATE, &dev->flags);
+				locked++;
+			}
+		}
+	} else {
+		BUG_ON(!(test_bit(R5_UPTODATE, &sh->dev[pd_idx].flags) ||
+			test_bit(R5_Wantcompute, &sh->dev[pd_idx].flags)));
+
+		set_bit(STRIPE_OP_PREXOR, &sh->ops.pending);
+		set_bit(STRIPE_OP_BIODRAIN, &sh->ops.pending);
+		set_bit(STRIPE_OP_POSTXOR, &sh->ops.pending);
+
+		sh->ops.count += 3;
+
+		for (i = disks; i--; ) {
+			struct r5dev *dev = &sh->dev[i];
+			if (i == pd_idx)
+				continue;
+
+			/* For a read-modify write there may be blocks that are
+			 * locked for reading while others are ready to be
+			 * written so we distinguish these blocks by the
+			 * R5_Wantprexor bit
+			 */
+			if (dev->towrite &&
+			    (test_bit(R5_UPTODATE, &dev->flags) ||
+			    test_bit(R5_Wantcompute, &dev->flags))) {
+				set_bit(R5_Wantprexor, &dev->flags);
+				set_bit(R5_LOCKED, &dev->flags);
+				clear_bit(R5_UPTODATE, &dev->flags);
+				locked++;
+			}
+		}
+	}
+
+	/* keep the parity disk locked while asynchronous operations
+	 * are in flight
+	 */
+	set_bit(R5_LOCKED, &sh->dev[pd_idx].flags);
+	clear_bit(R5_UPTODATE, &sh->dev[pd_idx].flags);
+	locked++;
 
+	pr_debug("%s: stripe %llu locked: %d pending: %lx\n",
+		__FUNCTION__, (unsigned long long)sh->sector,
+		locked, sh->ops.pending);
+
+	return locked;
+}
 
 /*
  * Each stripe/dev can have one or more bion attached.
@@ -2210,27 +2282,8 @@ static void handle_issuing_new_write_requests5(raid5_conf_t *conf,
 	 * we can start a write request
 	 */
 	if (s->locked == 0 && (rcw == 0 || rmw == 0) &&
-	    !test_bit(STRIPE_BIT_DELAY, &sh->state)) {
-		pr_debug("Computing parity...\n");
-		compute_parity5(sh, rcw == 0 ?
-			RECONSTRUCT_WRITE : READ_MODIFY_WRITE);
-		/* now every locked buffer is ready to be written */
-		for (i = disks; i--; )
-			if (test_bit(R5_LOCKED, &sh->dev[i].flags)) {
-				pr_debug("Writing block %d\n", i);
-				s->locked++;
-				set_bit(R5_Wantwrite, &sh->dev[i].flags);
-				if (!test_bit(R5_Insync, &sh->dev[i].flags)
-				    || (i == sh->pd_idx && s->failed == 0))
-					set_bit(STRIPE_INSYNC, &sh->state);
-			}
-		if (test_and_clear_bit(STRIPE_PREREAD_ACTIVE, &sh->state)) {
-			atomic_dec(&conf->preread_active_stripes);
-			if (atomic_read(&conf->preread_active_stripes) <
-			    IO_THRESHOLD)
-				md_wakeup_thread(conf->mddev->thread);
-		}
-	}
+	    !test_bit(STRIPE_BIT_DELAY, &sh->state))
+		s->locked += handle_write_operations5(sh, rcw == 0, 0);
 }
 
 static void handle_issuing_new_write_requests6(raid5_conf_t *conf,
@@ -2649,8 +2702,70 @@ static void handle_stripe5(struct stripe_head *sh)
 		(s.syncing && (s.uptodate < disks)) || s.expanding)
 		handle_issuing_new_read_requests5(sh, &s, disks);
 
-	/* now to consider writing and what else, if anything should be read */
-	if (s.to_write)
+	/* Now we check to see if any write operations have recently
+	 * completed
+	 */
+
+	/* leave prexor set until postxor is done, allows us to distinguish
+	 * a rmw from a rcw during biodrain
+	 */
+	if (test_bit(STRIPE_OP_PREXOR, &sh->ops.complete) &&
+		test_bit(STRIPE_OP_POSTXOR, &sh->ops.complete)) {
+
+		clear_bit(STRIPE_OP_PREXOR, &sh->ops.complete);
+		clear_bit(STRIPE_OP_PREXOR, &sh->ops.ack);
+		clear_bit(STRIPE_OP_PREXOR, &sh->ops.pending);
+
+		for (i = disks; i--; )
+			clear_bit(R5_Wantprexor, &sh->dev[i].flags);
+	}
+
+	/* if only POSTXOR is set then this is an 'expand' postxor */
+	if (test_bit(STRIPE_OP_BIODRAIN, &sh->ops.complete) &&
+		test_bit(STRIPE_OP_POSTXOR, &sh->ops.complete)) {
+
+		clear_bit(STRIPE_OP_BIODRAIN, &sh->ops.complete);
+		clear_bit(STRIPE_OP_BIODRAIN, &sh->ops.ack);
+		clear_bit(STRIPE_OP_BIODRAIN, &sh->ops.pending);
+
+		clear_bit(STRIPE_OP_POSTXOR, &sh->ops.complete);
+		clear_bit(STRIPE_OP_POSTXOR, &sh->ops.ack);
+		clear_bit(STRIPE_OP_POSTXOR, &sh->ops.pending);
+
+		/* All the 'written' buffers and the parity block are ready to
+		 * be written back to disk
+		 */
+		BUG_ON(!test_bit(R5_UPTODATE, &sh->dev[sh->pd_idx].flags));
+		for (i = disks; i--; ) {
+			dev = &sh->dev[i];
+			if (test_bit(R5_LOCKED, &dev->flags) &&
+				(i == sh->pd_idx || dev->written)) {
+				pr_debug("Writing block %d\n", i);
+				set_bit(R5_Wantwrite, &dev->flags);
+				if (!test_and_set_bit(
+				    STRIPE_OP_IO, &sh->ops.pending))
+					sh->ops.count++;
+				if (!test_bit(R5_Insync, &dev->flags) ||
+				    (i == sh->pd_idx && s.failed == 0))
+					set_bit(STRIPE_INSYNC, &sh->state);
+			}
+		}
+		if (test_and_clear_bit(STRIPE_PREREAD_ACTIVE, &sh->state)) {
+			atomic_dec(&conf->preread_active_stripes);
+			if (atomic_read(&conf->preread_active_stripes) <
+				IO_THRESHOLD)
+				md_wakeup_thread(conf->mddev->thread);
+		}
+	}
+
+	/* Now to consider new write requests and what else, if anything
+	 * should be read.  We do not handle new writes when:
+	 * 1/ A 'write' operation (copy+xor) is already in flight.
+	 * 2/ A 'check' operation is in flight, as it may clobber the parity
+	 *    block.
+	 */
+	if (s.to_write && !test_bit(STRIPE_OP_POSTXOR, &sh->ops.pending) &&
+			  !test_bit(STRIPE_OP_CHECK, &sh->ops.pending))
 		handle_issuing_new_write_requests5(conf, sh, &s, disks);
 
 	/* maybe we need to check and possibly fix the parity for this stripe
