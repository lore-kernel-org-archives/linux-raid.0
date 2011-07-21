From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 20/34] md/raid5: finalise new merged handle_stripe.
Date: Thu, 21 Jul 2011 12:32:27 +1000
Message-ID: <20110721023226.6728.78219.stgit@notabene.brown>
References: <20110721022537.6728.90204.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110721022537.6728.90204.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

handle_stripe5() and handle_stripe6() are now virtually identical.
So discard one and rename the other to 'analyse_stripe()'.

It always returns 0, so change it to 'void' and remove the 'done'
variable in handle_stripe().

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid5.c |  100 +++-------------------------------------------------
 1 files changed, 5 insertions(+), 95 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index f23848f..93ee26c 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2899,88 +2899,7 @@ static void handle_stripe_expansion(raid5_conf_t *conf, struct stripe_head *sh,
  *
  */
 
-static int handle_stripe5(struct stripe_head *sh, struct stripe_head_state *s)
-{
-	raid5_conf_t *conf = sh->raid_conf;
-	int disks = sh->disks, i;
-	struct r5dev *dev;
-
-	/* Now to look around and see what can be done */
-	rcu_read_lock();
-	spin_lock_irq(&conf->device_lock);
-	for (i=disks; i--; ) {
-		mdk_rdev_t *rdev;
-
-		dev = &sh->dev[i];
-
-		pr_debug("check %d: state 0x%lx toread %p read %p write %p "
-			"written %p\n",	i, dev->flags, dev->toread, dev->read,
-			dev->towrite, dev->written);
-
-		/* maybe we can request a biofill operation
-		 *
-		 * new wantfill requests are only permitted while
-		 * ops_complete_biofill is guaranteed to be inactive
-		 */
-		if (test_bit(R5_UPTODATE, &dev->flags) && dev->toread &&
-		    !test_bit(STRIPE_BIOFILL_RUN, &sh->state))
-			set_bit(R5_Wantfill, &dev->flags);
-
-		/* now count some things */
-		if (test_bit(R5_LOCKED, &dev->flags))
-			s->locked++;
-		if (test_bit(R5_UPTODATE, &dev->flags))
-			s->uptodate++;
-		if (test_bit(R5_Wantcompute, &dev->flags))
-			s->compute++;
-
-		if (test_bit(R5_Wantfill, &dev->flags))
-			s->to_fill++;
-		else if (dev->toread)
-			s->to_read++;
-		if (dev->towrite) {
-			s->to_write++;
-			if (!test_bit(R5_OVERWRITE, &dev->flags))
-				s->non_overwrite++;
-		}
-		if (dev->written)
-			s->written++;
-		rdev = rcu_dereference(conf->disks[i].rdev);
-		if (s->blocked_rdev == NULL &&
-		    rdev && unlikely(test_bit(Blocked, &rdev->flags))) {
-			s->blocked_rdev = rdev;
-			atomic_inc(&rdev->nr_pending);
-		}
-		clear_bit(R5_Insync, &dev->flags);
-		if (!rdev)
-			/* Not in-sync */;
-		else if (test_bit(In_sync, &rdev->flags))
-			set_bit(R5_Insync, &dev->flags);
-		else {
-			/* could be in-sync depending on recovery/reshape status */
-			if (sh->sector + STRIPE_SECTORS <= rdev->recovery_offset)
-				set_bit(R5_Insync, &dev->flags);
-		}
-		if (!test_bit(R5_Insync, &dev->flags)) {
-			/* The ReadError flag will just be confusing now */
-			clear_bit(R5_ReadError, &dev->flags);
-			clear_bit(R5_ReWrite, &dev->flags);
-		}
-		if (test_bit(R5_ReadError, &dev->flags))
-			clear_bit(R5_Insync, &dev->flags);
-		if (!test_bit(R5_Insync, &dev->flags)) {
-			if (s->failed < 2)
-				s->failed_num[s->failed] = i;
-			s->failed++;
-		}
-	}
-	spin_unlock_irq(&conf->device_lock);
-	rcu_read_unlock();
-
-	return 0;
-}
-
-static int handle_stripe6(struct stripe_head *sh, struct stripe_head_state *s)
+static void analyse_stripe(struct stripe_head *sh, struct stripe_head_state *s)
 {
 	raid5_conf_t *conf = sh->raid_conf;
 	int disks = sh->disks;
@@ -2988,11 +2907,11 @@ static int handle_stripe6(struct stripe_head *sh, struct stripe_head_state *s)
 	int i;
 
 	/* Now to look around and see what can be done */
-
 	rcu_read_lock();
 	spin_lock_irq(&conf->device_lock);
 	for (i=disks; i--; ) {
 		mdk_rdev_t *rdev;
+
 		dev = &sh->dev[i];
 
 		pr_debug("check %d: state 0x%lx read %p write %p written %p\n",
@@ -3016,9 +2935,9 @@ static int handle_stripe6(struct stripe_head *sh, struct stripe_head_state *s)
 			BUG_ON(s->compute > 2);
 		}
 
-		if (test_bit(R5_Wantfill, &dev->flags)) {
+		if (test_bit(R5_Wantfill, &dev->flags))
 			s->to_fill++;
-		} else if (dev->toread)
+		else if (dev->toread)
 			s->to_read++;
 		if (dev->towrite) {
 			s->to_write++;
@@ -3058,14 +2977,11 @@ static int handle_stripe6(struct stripe_head *sh, struct stripe_head_state *s)
 	}
 	spin_unlock_irq(&conf->device_lock);
 	rcu_read_unlock();
-
-	return 0;
 }
 
 static void handle_stripe(struct stripe_head *sh)
 {
 	struct stripe_head_state s;
-	int done;
 	raid5_conf_t *conf = sh->raid_conf;
 	int i;
 	int prexor;
@@ -3099,13 +3015,7 @@ static void handle_stripe(struct stripe_head *sh)
 	s.failed_num[0] = -1;
 	s.failed_num[1] = -1;
 
-	if (conf->level == 6)
-		done = handle_stripe6(sh, &s);
-	else
-		done = handle_stripe5(sh, &s);
-
-	if (done)
-		goto finish;
+	analyse_stripe(sh, &s);
 
 	if (unlikely(s.blocked_rdev)) {
 		if (s.syncing || s.expanding || s.expanded ||


