From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 14/34] md/raid5: move more code into common handle_stripe
Date: Thu, 21 Jul 2011 12:32:26 +1000
Message-ID: <20110721023226.6728.59699.stgit@notabene.brown>
References: <20110721022537.6728.90204.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110721022537.6728.90204.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The difference between the RAID5 and RAID6 code here is easily
resolved using conf->max_degraded.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid5.c |   90 ++++++++++++++++++----------------------------------
 1 files changed, 32 insertions(+), 58 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 7b562fc..e41b622 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3177,34 +3177,6 @@ static int handle_stripe5(struct stripe_head *sh, struct stripe_head_state *s)
 	     !test_bit(STRIPE_COMPUTE_RUN, &sh->state) &&
 	     !test_bit(STRIPE_INSYNC, &sh->state)))
 		handle_parity_checks5(conf, sh, s, disks);
-
-	if (s->syncing && s->locked == 0
-	    && test_bit(STRIPE_INSYNC, &sh->state)) {
-		md_done_sync(conf->mddev, STRIPE_SECTORS,1);
-		clear_bit(STRIPE_SYNCING, &sh->state);
-	}
-
-	/* If the failed drive is just a ReadError, then we might need to progress
-	 * the repair/check process
-	 */
-	if (s->failed == 1 && !conf->mddev->ro &&
-	    test_bit(R5_ReadError, &sh->dev[s->failed_num[0]].flags)
-	    && !test_bit(R5_LOCKED, &sh->dev[s->failed_num[0]].flags)
-	    && test_bit(R5_UPTODATE, &sh->dev[s->failed_num[0]].flags)
-		) {
-		dev = &sh->dev[s->failed_num[0]];
-		if (!test_bit(R5_ReWrite, &dev->flags)) {
-			set_bit(R5_Wantwrite, &dev->flags);
-			set_bit(R5_ReWrite, &dev->flags);
-			set_bit(R5_LOCKED, &dev->flags);
-			s->locked++;
-		} else {
-			/* let's read it back */
-			set_bit(R5_Wantread, &dev->flags);
-			set_bit(R5_LOCKED, &dev->flags);
-			s->locked++;
-		}
-	}
 	return 0;
 }
 
@@ -3394,36 +3366,6 @@ static int handle_stripe6(struct stripe_head *sh, struct stripe_head_state *s)
 	     !test_bit(STRIPE_COMPUTE_RUN, &sh->state) &&
 	     !test_bit(STRIPE_INSYNC, &sh->state)))
 		handle_parity_checks6(conf, sh, s, disks);
-
-	if (s->syncing && s->locked == 0
-	    && test_bit(STRIPE_INSYNC, &sh->state)) {
-		md_done_sync(conf->mddev, STRIPE_SECTORS,1);
-		clear_bit(STRIPE_SYNCING, &sh->state);
-	}
-
-	/* If the failed drives are just a ReadError, then we might need
-	 * to progress the repair/check process
-	 */
-	if (s->failed <= 2 && !conf->mddev->ro)
-		for (i = 0; i < s->failed; i++) {
-			dev = &sh->dev[s->failed_num[i]];
-			if (test_bit(R5_ReadError, &dev->flags)
-			    && !test_bit(R5_LOCKED, &dev->flags)
-			    && test_bit(R5_UPTODATE, &dev->flags)
-				) {
-				if (!test_bit(R5_ReWrite, &dev->flags)) {
-					set_bit(R5_Wantwrite, &dev->flags);
-					set_bit(R5_ReWrite, &dev->flags);
-					set_bit(R5_LOCKED, &dev->flags);
-					s->locked++;
-				} else {
-					/* let's read it back */
-					set_bit(R5_Wantread, &dev->flags);
-					set_bit(R5_LOCKED, &dev->flags);
-					s->locked++;
-				}
-			}
-		}
 	return 0;
 }
 
@@ -3466,6 +3408,38 @@ static void handle_stripe(struct stripe_head *sh)
 
 	if (done)
 		goto finish;
+
+
+	if (s.syncing && s.locked == 0 && test_bit(STRIPE_INSYNC, &sh->state)) {
+		md_done_sync(conf->mddev, STRIPE_SECTORS, 1);
+		clear_bit(STRIPE_SYNCING, &sh->state);
+	}
+
+	/* If the failed drives are just a ReadError, then we might need
+	 * to progress the repair/check process
+	 */
+	if (s.failed <= conf->max_degraded && !conf->mddev->ro)
+		for (i = 0; i < s.failed; i++) {
+			struct r5dev *dev = &sh->dev[s.failed_num[i]];
+			if (test_bit(R5_ReadError, &dev->flags)
+			    && !test_bit(R5_LOCKED, &dev->flags)
+			    && test_bit(R5_UPTODATE, &dev->flags)
+				) {
+				if (!test_bit(R5_ReWrite, &dev->flags)) {
+					set_bit(R5_Wantwrite, &dev->flags);
+					set_bit(R5_ReWrite, &dev->flags);
+					set_bit(R5_LOCKED, &dev->flags);
+					s.locked++;
+				} else {
+					/* let's read it back */
+					set_bit(R5_Wantread, &dev->flags);
+					set_bit(R5_LOCKED, &dev->flags);
+					s.locked++;
+				}
+			}
+		}
+
+
 	/* Finish reconstruct operations initiated by the expansion process */
 	if (sh->reconstruct_state == reconstruct_state_result) {
 		struct stripe_head *sh2


