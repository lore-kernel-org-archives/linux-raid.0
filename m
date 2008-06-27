From: NeilBrown <neilb@suse.de>
Subject: [PATCH 029 of 29] md: md: rationalize raid5 function names
Date: Fri, 27 Jun 2008 16:52:32 +1000
Message-ID: <1080627065232.10796@suse.de>
References: <20080627164503.9671.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-raid.ids


From: Dan Williams <dan.j.williams@intel.com>

Commit a4456856 refactored some of the deep code paths in raid5.c into separate
functions.  The names chosen at the time do not consistently indicate what is
going to happen to the stripe.  So, update the names, and since a stripe is a
cache element use cache semantics like fill, dirty, and clean.

(also, fix up the indentation in fetch_block5)

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid5.c |   76 ++++++++++++++++++++++++++-------------------------
 1 file changed, 40 insertions(+), 36 deletions(-)

diff .prev/drivers/md/raid5.c ./drivers/md/raid5.c
--- .prev/drivers/md/raid5.c	2008-06-27 16:42:56.000000000 +1000
+++ ./drivers/md/raid5.c	2008-06-27 16:42:57.000000000 +1000
@@ -1618,7 +1618,7 @@ static void compute_block_2(struct strip
 }
 
 static void
-handle_write_operations5(struct stripe_head *sh, struct stripe_head_state *s,
+schedule_reconstruction5(struct stripe_head *sh, struct stripe_head_state *s,
 			 int rcw, int expand)
 {
 	int i, pd_idx = sh->pd_idx, disks = sh->disks;
@@ -1783,7 +1783,7 @@ static int stripe_to_pdidx(sector_t stri
 }
 
 static void
-handle_requests_to_failed_array(raid5_conf_t *conf, struct stripe_head *sh,
+handle_failed_stripe(raid5_conf_t *conf, struct stripe_head *sh,
 				struct stripe_head_state *s, int disks,
 				struct bio **return_bi)
 {
@@ -1874,23 +1874,28 @@ handle_requests_to_failed_array(raid5_co
 			md_wakeup_thread(conf->mddev->thread);
 }
 
-/* __handle_issuing_new_read_requests5 - returns 0 if there are no more disks
- * to process
+/* fetch_block5 - checks the given member device to see if its data needs
+ * to be read or computed to satisfy a request.
+ *
+ * Returns 1 when no more member devices need to be checked, otherwise returns
+ * 0 to tell the loop in handle_stripe_fill5 to continue
  */
-static int __handle_issuing_new_read_requests5(struct stripe_head *sh,
-			struct stripe_head_state *s, int disk_idx, int disks)
+static int fetch_block5(struct stripe_head *sh, struct stripe_head_state *s,
+			int disk_idx, int disks)
 {
 	struct r5dev *dev = &sh->dev[disk_idx];
 	struct r5dev *failed_dev = &sh->dev[s->failed_num];
 
 	/* is the data in this block needed, and can we get it? */
 	if (!test_bit(R5_LOCKED, &dev->flags) &&
-	    !test_bit(R5_UPTODATE, &dev->flags) && (dev->toread ||
-	    (dev->towrite && !test_bit(R5_OVERWRITE, &dev->flags)) ||
-	     s->syncing || s->expanding || (s->failed &&
-	     (failed_dev->toread || (failed_dev->towrite &&
-	     !test_bit(R5_OVERWRITE, &failed_dev->flags)
-	     ))))) {
+	    !test_bit(R5_UPTODATE, &dev->flags) &&
+	    (dev->toread ||
+	     (dev->towrite && !test_bit(R5_OVERWRITE, &dev->flags)) ||
+	     s->syncing || s->expanding ||
+	     (s->failed &&
+	      (failed_dev->toread ||
+	       (failed_dev->towrite &&
+		!test_bit(R5_OVERWRITE, &failed_dev->flags)))))) {
 		/* We would like to get this block, possibly by computing it,
 		 * otherwise read it if the backing disk is insync
 		 */
@@ -1908,7 +1913,7 @@ static int __handle_issuing_new_read_req
 			 * subsequent operation.
 			 */
 			s->uptodate++;
-			return 0; /* uptodate + compute == disks */
+			return 1; /* uptodate + compute == disks */
 		} else if (test_bit(R5_Insync, &dev->flags)) {
 			set_bit(R5_LOCKED, &dev->flags);
 			set_bit(R5_Wantread, &dev->flags);
@@ -1918,10 +1923,13 @@ static int __handle_issuing_new_read_req
 		}
 	}
 
-	return ~0;
+	return 0;
 }
 
-static void handle_issuing_new_read_requests5(struct stripe_head *sh,
+/**
+ * handle_stripe_fill5 - read or compute data to satisfy pending requests.
+ */
+static void handle_stripe_fill5(struct stripe_head *sh,
 			struct stripe_head_state *s, int disks)
 {
 	int i;
@@ -1931,16 +1939,14 @@ static void handle_issuing_new_read_requ
 	 * midst of changing due to a write
 	 */
 	if (!test_bit(STRIPE_COMPUTE_RUN, &sh->state) && !sh->check_state &&
-	    !sh->reconstruct_state) {
+	    !sh->reconstruct_state)
 		for (i = disks; i--; )
-			if (__handle_issuing_new_read_requests5(
-				sh, s, i, disks) == 0)
+			if (fetch_block5(sh, s, i, disks))
 				break;
-	}
 	set_bit(STRIPE_HANDLE, &sh->state);
 }
 
-static void handle_issuing_new_read_requests6(struct stripe_head *sh,
+static void handle_stripe_fill6(struct stripe_head *sh,
 			struct stripe_head_state *s, struct r6_state *r6s,
 			int disks)
 {
@@ -1999,12 +2005,12 @@ static void handle_issuing_new_read_requ
 }
 
 
-/* handle_completed_write_requests
+/* handle_stripe_clean_event
  * any written block on an uptodate or failed drive can be returned.
  * Note that if we 'wrote' to a failed drive, it will be UPTODATE, but
  * never LOCKED, so we don't need to test 'failed' directly.
  */
-static void handle_completed_write_requests(raid5_conf_t *conf,
+static void handle_stripe_clean_event(raid5_conf_t *conf,
 	struct stripe_head *sh, int disks, struct bio **return_bi)
 {
 	int i;
@@ -2049,7 +2055,7 @@ static void handle_completed_write_reque
 			md_wakeup_thread(conf->mddev->thread);
 }
 
-static void handle_issuing_new_write_requests5(raid5_conf_t *conf,
+static void handle_stripe_dirtying5(raid5_conf_t *conf,
 		struct stripe_head *sh,	struct stripe_head_state *s, int disks)
 {
 	int rmw = 0, rcw = 0, i;
@@ -2136,10 +2142,10 @@ static void handle_issuing_new_write_req
 	if ((s->req_compute || !test_bit(STRIPE_COMPUTE_RUN, &sh->state)) &&
 	    (s->locked == 0 && (rcw == 0 || rmw == 0) &&
 	    !test_bit(STRIPE_BIT_DELAY, &sh->state)))
-		handle_write_operations5(sh, s, rcw == 0, 0);
+		schedule_reconstruction5(sh, s, rcw == 0, 0);
 }
 
-static void handle_issuing_new_write_requests6(raid5_conf_t *conf,
+static void handle_stripe_dirtying6(raid5_conf_t *conf,
 		struct stripe_head *sh,	struct stripe_head_state *s,
 		struct r6_state *r6s, int disks)
 {
@@ -2597,8 +2603,7 @@ static void handle_stripe5(struct stripe
 	 * need to be failed
 	 */
 	if (s.failed > 1 && s.to_read+s.to_write+s.written)
-		handle_requests_to_failed_array(conf, sh, &s, disks,
-						&return_bi);
+		handle_failed_stripe(conf, sh, &s, disks, &return_bi);
 	if (s.failed > 1 && s.syncing) {
 		md_done_sync(conf->mddev, STRIPE_SECTORS,0);
 		clear_bit(STRIPE_SYNCING, &sh->state);
@@ -2614,7 +2619,7 @@ static void handle_stripe5(struct stripe
 	       !test_bit(R5_LOCKED, &dev->flags) &&
 	       test_bit(R5_UPTODATE, &dev->flags)) ||
 	       (s.failed == 1 && s.failed_num == sh->pd_idx)))
-		handle_completed_write_requests(conf, sh, disks, &return_bi);
+		handle_stripe_clean_event(conf, sh, disks, &return_bi);
 
 	/* Now we might consider reading some blocks, either to check/generate
 	 * parity, or to satisfy requests
@@ -2622,7 +2627,7 @@ static void handle_stripe5(struct stripe
 	 */
 	if (s.to_read || s.non_overwrite ||
 	    (s.syncing && (s.uptodate + s.compute < disks)) || s.expanding)
-		handle_issuing_new_read_requests5(sh, &s, disks);
+		handle_stripe_fill5(sh, &s, disks);
 
 	/* Now we check to see if any write operations have recently
 	 * completed
@@ -2666,7 +2671,7 @@ static void handle_stripe5(struct stripe
 	 *    block.
 	 */
 	if (s.to_write && !sh->reconstruct_state && !sh->check_state)
-		handle_issuing_new_write_requests5(conf, sh, &s, disks);
+		handle_stripe_dirtying5(conf, sh, &s, disks);
 
 	/* maybe we need to check and possibly fix the parity for this stripe
 	 * Any reads will already have been scheduled, so we just see if enough
@@ -2722,7 +2727,7 @@ static void handle_stripe5(struct stripe
 		sh->disks = conf->raid_disks;
 		sh->pd_idx = stripe_to_pdidx(sh->sector, conf,
 			conf->raid_disks);
-		handle_write_operations5(sh, &s, 1, 1);
+		schedule_reconstruction5(sh, &s, 1, 1);
 	} else if (s.expanded && !sh->reconstruct_state && s.locked == 0) {
 		clear_bit(STRIPE_EXPAND_READY, &sh->state);
 		atomic_dec(&conf->reshape_stripes);
@@ -2854,8 +2859,7 @@ static void handle_stripe6(struct stripe
 	 * might need to be failed
 	 */
 	if (s.failed > 2 && s.to_read+s.to_write+s.written)
-		handle_requests_to_failed_array(conf, sh, &s, disks,
-						&return_bi);
+		handle_failed_stripe(conf, sh, &s, disks, &return_bi);
 	if (s.failed > 2 && s.syncing) {
 		md_done_sync(conf->mddev, STRIPE_SECTORS,0);
 		clear_bit(STRIPE_SYNCING, &sh->state);
@@ -2880,7 +2884,7 @@ static void handle_stripe6(struct stripe
 	     ( r6s.q_failed || ((test_bit(R5_Insync, &qdev->flags)
 			     && !test_bit(R5_LOCKED, &qdev->flags)
 			     && test_bit(R5_UPTODATE, &qdev->flags)))))
-		handle_completed_write_requests(conf, sh, disks, &return_bi);
+		handle_stripe_clean_event(conf, sh, disks, &return_bi);
 
 	/* Now we might consider reading some blocks, either to check/generate
 	 * parity, or to satisfy requests
@@ -2888,11 +2892,11 @@ static void handle_stripe6(struct stripe
 	 */
 	if (s.to_read || s.non_overwrite || (s.to_write && s.failed) ||
 	    (s.syncing && (s.uptodate < disks)) || s.expanding)
-		handle_issuing_new_read_requests6(sh, &s, &r6s, disks);
+		handle_stripe_fill6(sh, &s, &r6s, disks);
 
 	/* now to consider writing and what else, if anything should be read */
 	if (s.to_write)
-		handle_issuing_new_write_requests6(conf, sh, &s, &r6s, disks);
+		handle_stripe_dirtying6(conf, sh, &s, &r6s, disks);
 
 	/* maybe we need to check and possibly fix the parity for this stripe
 	 * Any reads will already have been scheduled, so we just see if enough
