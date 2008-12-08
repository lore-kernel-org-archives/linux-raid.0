From: Yuri Tikhonov <yur@emcraft.com>
Subject: [PATCH 09/11] md: change handle_stripe6 to work asynchronously
Date: Tue, 9 Dec 2008 00:57:54 +0300
Message-ID: <200812090057.54977.yur@emcraft.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: linuxppc-dev@ozlabs.org, dan.j.williams@intel.com, dzu@denx.de, wd@denx.de, yanok@emcraft.com
List-Id: linux-raid.ids

handle_stripe6 function is changed to do things asynchronously.

Signed-off-by: Yuri Tikhonov <yur@emcraft.com>
Signed-off-by: Ilya Yanok <yanok@emcraft.com>
---
 drivers/md/raid5.c |  130 ++++++++++++++++++++++++++++++++++++----------------
 1 files changed, 90 insertions(+), 40 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 91e5438..47b7de3 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3117,9 +3117,10 @@ static bool handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
 
 	r6s.qd_idx = raid6_next_disk(pd_idx, disks);
 	pr_debug("handling stripe %llu, state=%#lx cnt=%d, "
-		"pd_idx=%d, qd_idx=%d\n",
+		"pd_idx=%d, qd_idx=%d\n, check:%d, reconstruct:%d\n",
 	       (unsigned long long)sh->sector, sh->state,
-	       atomic_read(&sh->count), pd_idx, r6s.qd_idx);
+	       atomic_read(&sh->count), pd_idx, r6s.qd_idx,
+	       sh->check_state, sh->reconstruct_state);
 	memset(&s, 0, sizeof(s));
 
 	spin_lock(&sh->lock);
@@ -3139,35 +3140,24 @@ static bool handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
 
 		pr_debug("check %d: state 0x%lx read %p write %p written %p\n",
 			i, dev->flags, dev->toread, dev->towrite, dev->written);
-		/* maybe we can reply to a read */
-		if (test_bit(R5_UPTODATE, &dev->flags) && dev->toread) {
-			struct bio *rbi, *rbi2;
-			pr_debug("Return read for disc %d\n", i);
-			spin_lock_irq(&conf->device_lock);
-			rbi = dev->toread;
-			dev->toread = NULL;
-			if (test_and_clear_bit(R5_Overlap, &dev->flags))
-				wake_up(&conf->wait_for_overlap);
-			spin_unlock_irq(&conf->device_lock);
-			while (rbi && rbi->bi_sector < dev->sector + STRIPE_SECTORS) {
-				copy_data(0, rbi, dev->page, dev->sector);
-				rbi2 = r5_next_bio(rbi, dev->sector);
-				spin_lock_irq(&conf->device_lock);
-				if (!raid5_dec_bi_phys_segments(rbi)) {
-					rbi->bi_next = return_bi;
-					return_bi = rbi;
-				}
-				spin_unlock_irq(&conf->device_lock);
-				rbi = rbi2;
-			}
-		}
+		/* maybe we can reply to a read
+		 *
+		 * new wantfill requests are only permitted while
+		 * ops_complete_biofill is guaranteed to be inactive
+		 */
+		if (test_bit(R5_UPTODATE, &dev->flags) && dev->toread &&
+		    !test_bit(STRIPE_BIOFILL_RUN, &sh->state))
+			set_bit(R5_Wantfill, &dev->flags);
 
 		/* now count some things */
 		if (test_bit(R5_LOCKED, &dev->flags)) s.locked++;
 		if (test_bit(R5_UPTODATE, &dev->flags)) s.uptodate++;
+		if (test_bit(R5_Wantcompute, &dev->flags))
+			BUG_ON(++s.compute > 2);
 
-
-		if (dev->toread)
+		if (test_bit(R5_Wantfill, &dev->flags)) {
+			s.to_fill++;
+		} else if (dev->toread)
 			s.to_read++;
 		if (dev->towrite) {
 			s.to_write++;
@@ -3208,6 +3198,11 @@ static bool handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
 		blocked_rdev = NULL;
 	}
 
+	if (s.to_fill && !test_bit(STRIPE_BIOFILL_RUN, &sh->state)) {
+		set_bit(STRIPE_OP_BIOFILL, &s.ops_request);
+		set_bit(STRIPE_BIOFILL_RUN, &sh->state);
+	}
+
 	pr_debug("locked=%d uptodate=%d to_read=%d"
 	       " to_write=%d failed=%d failed_num=%d,%d\n",
 	       s.locked, s.uptodate, s.to_read, s.to_write, s.failed,
@@ -3248,18 +3243,62 @@ static bool handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
 	 * or to load a block that is being partially written.
 	 */
 	if (s.to_read || s.non_overwrite || (s.to_write && s.failed) ||
-	    (s.syncing && (s.uptodate < disks)) || s.expanding)
+	    (s.syncing && (s.uptodate + s.compute < disks)) || s.expanding)
 		handle_stripe_fill6(sh, &s, &r6s, disks);
 
-	/* now to consider writing and what else, if anything should be read */
-	if (s.to_write)
+	/* Now we check to see if any write operations have recently
+	 * completed
+	 */
+	if (sh->reconstruct_state == reconstruct_state_drain_result) {
+		int qd_idx = raid6_next_disk(sh->pd_idx,
+					     conf->raid_disks);
+
+		sh->reconstruct_state = reconstruct_state_idle;
+		/* All the 'written' buffers and the parity blocks are ready to
+		 * be written back to disk
+		 */
+		BUG_ON(!test_bit(R5_UPTODATE, &sh->dev[sh->pd_idx].flags));
+		BUG_ON(!test_bit(R5_UPTODATE, &sh->dev[qd_idx].flags));
+		for (i = disks; i--; ) {
+			dev = &sh->dev[i];
+			if (test_bit(R5_LOCKED, &dev->flags) &&
+			    (i == sh->pd_idx || i == qd_idx ||
+			     dev->written)) {
+				pr_debug("Writing block %d\n", i);
+				BUG_ON(!test_bit(R5_UPTODATE, &dev->flags));
+				set_bit(R5_Wantwrite, &dev->flags);
+				if (!test_bit(R5_Insync, &dev->flags) ||
+				    ((i == sh->pd_idx || i == qd_idx) &&
+				      s.failed == 0))
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
+	if (s.to_write && !sh->reconstruct_state && !sh->check_state)
 		handle_stripe_dirtying6(conf, sh, &s, &r6s, disks);
 
 	/* maybe we need to check and possibly fix the parity for this stripe
 	 * Any reads will already have been scheduled, so we just see if enough
-	 * data is available
+	 * data is available.  The parity check is held off while parity
+	 * dependent operations are in flight.
 	 */
-	if (s.syncing && s.locked == 0 && !test_bit(STRIPE_INSYNC, &sh->state))
+	if (sh->check_state ||
+	    (s.syncing && s.locked == 0 &&
+	     !test_bit(STRIPE_COMPUTE_RUN, &sh->state) &&
+	     !test_bit(STRIPE_INSYNC, &sh->state)))
 		handle_parity_checks6(conf, sh, &s, &r6s, tmp_page, disks);
 
 	if (s.syncing && s.locked == 0 && test_bit(STRIPE_INSYNC, &sh->state)) {
@@ -3281,27 +3320,35 @@ static bool handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
 					set_bit(R5_Wantwrite, &dev->flags);
 					set_bit(R5_ReWrite, &dev->flags);
 					set_bit(R5_LOCKED, &dev->flags);
+					s.locked++;
 				} else {
 					/* let's read it back */
 					set_bit(R5_Wantread, &dev->flags);
 					set_bit(R5_LOCKED, &dev->flags);
+					s.locked++;
 				}
 			}
 		}
 
-	if (s.expanded && test_bit(STRIPE_EXPANDING, &sh->state)) {
+	/* Finish reconstruct operations initiated by the expansion process */
+	if (sh->reconstruct_state == reconstruct_state_result) {
+		sh->reconstruct_state = reconstruct_state_idle;
+		clear_bit(STRIPE_EXPANDING, &sh->state);
+		for (i = conf->raid_disks; i--; ) {
+			set_bit(R5_Wantwrite, &sh->dev[i].flags);
+			set_bit(R5_LOCKED, &sh->dev[i].flags);
+			s.locked++;
+		}
+	}
+
+	if (s.expanded && test_bit(STRIPE_EXPANDING, &sh->state) &&
+	    !sh->reconstruct_state) {
 		/* Need to write out all blocks after computing P&Q */
 		sh->disks = conf->raid_disks;
 		sh->pd_idx = stripe_to_pdidx(sh->sector, conf,
 					     conf->raid_disks);
-		compute_parity6(sh, RECONSTRUCT_WRITE);
-		for (i = conf->raid_disks ; i-- ;  ) {
-			set_bit(R5_LOCKED, &sh->dev[i].flags);
-			s.locked++;
-			set_bit(R5_Wantwrite, &sh->dev[i].flags);
-		}
-		clear_bit(STRIPE_EXPANDING, &sh->state);
-	} else if (s.expanded) {
+		schedule_reconstruction(sh, &s, 1, 1);
+	} else if (s.expanded && !sh->reconstruct_state && s.locked == 0) {
 		clear_bit(STRIPE_EXPAND_READY, &sh->state);
 		atomic_dec(&conf->reshape_stripes);
 		wake_up(&conf->wait_for_overlap);
@@ -3319,6 +3366,9 @@ static bool handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
 	if (unlikely(blocked_rdev))
 		md_wait_for_blocked_rdev(blocked_rdev, conf->mddev);
 
+	if (s.ops_request)
+		raid_run_ops(sh, s.ops_request);
+
 	ops_run_io(sh, &s);
 
 	return_io(return_bi);
-- 
1.5.6.1

