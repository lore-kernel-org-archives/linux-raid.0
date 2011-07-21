From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 16/34] md/raid5: unite fetch_block5 and fetch_block6
Date: Thu, 21 Jul 2011 12:32:26 +1000
Message-ID: <20110721023226.6728.42897.stgit@notabene.brown>
References: <20110721022537.6728.90204.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110721022537.6728.90204.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Provided that ->failed_num[1] is not a valid device number (which is
easily achieved) fetch_block6 provides all the functionality of
fetch_block5.

So remove the latter and rename the former to simply "fetch_block".

Then handle_stripe_fill5 and handle_stripe_fill6 become the same and
can similarly be united.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid5.c |  107 +++++++++++-----------------------------------------
 1 files changed, 23 insertions(+), 84 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 100ac1f..ea796a9 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2308,91 +2308,20 @@ handle_failed_stripe(raid5_conf_t *conf, struct stripe_head *sh,
 			md_wakeup_thread(conf->mddev->thread);
 }
 
-/* fetch_block5 - checks the given member device to see if its data needs
+/* fetch_block - checks the given member device to see if its data needs
  * to be read or computed to satisfy a request.
  *
  * Returns 1 when no more member devices need to be checked, otherwise returns
- * 0 to tell the loop in handle_stripe_fill5 to continue
+ * 0 to tell the loop in handle_stripe_fill to continue
  */
-static int fetch_block5(struct stripe_head *sh, struct stripe_head_state *s,
-			int disk_idx, int disks)
-{
-	struct r5dev *dev = &sh->dev[disk_idx];
-	struct r5dev *failed_dev = &sh->dev[s->failed_num[0]];
-
-	/* is the data in this block needed, and can we get it? */
-	if (!test_bit(R5_LOCKED, &dev->flags) &&
-	    !test_bit(R5_UPTODATE, &dev->flags) &&
-	    (dev->toread ||
-	     (dev->towrite && !test_bit(R5_OVERWRITE, &dev->flags)) ||
-	     s->syncing || s->expanding ||
-	     (s->failed && failed_dev->toread) ||
-	     (s->failed && failed_dev->towrite &&
-		!test_bit(R5_OVERWRITE, &failed_dev->flags)))))) {
-		/* We would like to get this block, possibly by computing it,
-		 * otherwise read it if the backing disk is insync
-		 */
-		if ((s->uptodate == disks - 1) &&
-		    (s->failed && disk_idx == s->failed_num[0])) {
-			set_bit(STRIPE_COMPUTE_RUN, &sh->state);
-			set_bit(STRIPE_OP_COMPUTE_BLK, &s->ops_request);
-			set_bit(R5_Wantcompute, &dev->flags);
-			sh->ops.target = disk_idx;
-			sh->ops.target2 = -1;
-			s->req_compute = 1;
-			/* Careful: from this point on 'uptodate' is in the eye
-			 * of raid_run_ops which services 'compute' operations
-			 * before writes. R5_Wantcompute flags a block that will
-			 * be R5_UPTODATE by the time it is needed for a
-			 * subsequent operation.
-			 */
-			s->uptodate++;
-			return 1; /* uptodate + compute == disks */
-		} else if (test_bit(R5_Insync, &dev->flags)) {
-			set_bit(R5_LOCKED, &dev->flags);
-			set_bit(R5_Wantread, &dev->flags);
-			s->locked++;
-			pr_debug("Reading block %d (sync=%d)\n", disk_idx,
-				s->syncing);
-		}
-	}
-
-	return 0;
-}
-
-/**
- * handle_stripe_fill5 - read or compute data to satisfy pending requests.
- */
-static void handle_stripe_fill5(struct stripe_head *sh,
-			struct stripe_head_state *s, int disks)
-{
-	int i;
-
-	/* look for blocks to read/compute, skip this if a compute
-	 * is already in flight, or if the stripe contents are in the
-	 * midst of changing due to a write
-	 */
-	if (!test_bit(STRIPE_COMPUTE_RUN, &sh->state) && !sh->check_state &&
-	    !sh->reconstruct_state)
-		for (i = disks; i--; )
-			if (fetch_block5(sh, s, i, disks))
-				break;
-	set_bit(STRIPE_HANDLE, &sh->state);
-}
-
-/* fetch_block6 - checks the given member device to see if its data needs
- * to be read or computed to satisfy a request.
- *
- * Returns 1 when no more member devices need to be checked, otherwise returns
- * 0 to tell the loop in handle_stripe_fill6 to continue
- */
-static int fetch_block6(struct stripe_head *sh, struct stripe_head_state *s,
-			int disk_idx, int disks)
+static int fetch_block(struct stripe_head *sh, struct stripe_head_state *s,
+		       int disk_idx, int disks)
 {
 	struct r5dev *dev = &sh->dev[disk_idx];
 	struct r5dev *fdev[2] = { &sh->dev[s->failed_num[0]],
 				  &sh->dev[s->failed_num[1]] };
 
+	/* is the data in this block needed, and can we get it? */
 	if (!test_bit(R5_LOCKED, &dev->flags) &&
 	    !test_bit(R5_UPTODATE, &dev->flags) &&
 	    (dev->toread ||
@@ -2400,7 +2329,9 @@ static int fetch_block6(struct stripe_head *sh, struct stripe_head_state *s,
 	     s->syncing || s->expanding ||
 	     (s->failed >= 1 && fdev[0]->toread) ||
 	     (s->failed >= 2 && fdev[1]->toread) ||
-	     (s->failed && s->to_write)) {
+	     (sh->raid_conf->level <= 5 && s->failed && fdev[0]->towrite &&
+	      !test_bit(R5_OVERWRITE, &fdev[0]->flags)) ||
+	     (sh->raid_conf->level == 6 && s->failed && s->to_write))) {
 		/* we would like to get this block, possibly by computing it,
 		 * otherwise read it if the backing disk is insync
 		 */
@@ -2420,6 +2351,12 @@ static int fetch_block6(struct stripe_head *sh, struct stripe_head_state *s,
 			sh->ops.target = disk_idx;
 			sh->ops.target2 = -1; /* no 2nd target */
 			s->req_compute = 1;
+			/* Careful: from this point on 'uptodate' is in the eye
+			 * of raid_run_ops which services 'compute' operations
+			 * before writes. R5_Wantcompute flags a block that will
+			 * be R5_UPTODATE by the time it is needed for a
+			 * subsequent operation.
+			 */
 			s->uptodate++;
 			return 1;
 		} else if (s->uptodate == disks-2 && s->failed >= 2) {
@@ -2460,11 +2397,11 @@ static int fetch_block6(struct stripe_head *sh, struct stripe_head_state *s,
 }
 
 /**
- * handle_stripe_fill6 - read or compute data to satisfy pending requests.
+ * handle_stripe_fill - read or compute data to satisfy pending requests.
  */
-static void handle_stripe_fill6(struct stripe_head *sh,
-			struct stripe_head_state *s,
-			int disks)
+static void handle_stripe_fill(struct stripe_head *sh,
+			       struct stripe_head_state *s,
+			       int disks)
 {
 	int i;
 
@@ -2475,7 +2412,7 @@ static void handle_stripe_fill6(struct stripe_head *sh,
 	if (!test_bit(STRIPE_COMPUTE_RUN, &sh->state) && !sh->check_state &&
 	    !sh->reconstruct_state)
 		for (i = disks; i--; )
-			if (fetch_block6(sh, s, i, disks))
+			if (fetch_block(sh, s, i, disks))
 				break;
 	set_bit(STRIPE_HANDLE, &sh->state);
 }
@@ -3123,7 +3060,7 @@ static int handle_stripe5(struct stripe_head *sh, struct stripe_head_state *s)
 	 */
 	if (s->to_read || s->non_overwrite ||
 	    (s->syncing && (s->uptodate + s->compute < disks)) || s->expanding)
-		handle_stripe_fill5(sh, s, disks);
+		handle_stripe_fill(sh, s, disks);
 
 	/* Now we check to see if any write operations have recently
 	 * completed
@@ -3314,7 +3251,7 @@ static int handle_stripe6(struct stripe_head *sh, struct stripe_head_state *s)
 	 */
 	if (s->to_read || s->non_overwrite || (s->to_write && s->failed) ||
 	    (s->syncing && (s->uptodate + s->compute < disks)) || s->expanding)
-		handle_stripe_fill6(sh, s, disks);
+		handle_stripe_fill(sh, s, disks);
 
 	/* Now we check to see if any write operations have recently
 	 * completed
@@ -3398,6 +3335,8 @@ static void handle_stripe(struct stripe_head *sh)
 	s.syncing = test_bit(STRIPE_SYNCING, &sh->state);
 	s.expanding = test_bit(STRIPE_EXPAND_SOURCE, &sh->state);
 	s.expanded = test_bit(STRIPE_EXPAND_READY, &sh->state);
+	s.failed_num[0] = -1;
+	s.failed_num[1] = -1;
 
 	if (conf->level == 6)
 		done = handle_stripe6(sh, &s);


