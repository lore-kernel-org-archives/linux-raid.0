From: Yuri Tikhonov <yur@emcraft.com>
Subject: [md-raid6-accel PATCH 08/12] md: req/comp logic for async read operations
Date: Tue, 4 Dec 2007 14:35:27 +0300
Message-ID: <200712041435.27723.yur@emcraft.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: Neil Brown <neilb@suse.de>, Wolfgang Denk <wd@denx.de>, Detlev Zundel <dzu@denx.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


 When a read bio is attached to the stripe and the corresponding block is
marked as R5_UPTODATE, then a biofill operation is scheduled to copy
the data from the stripe cache to the bio buffer.

 Signed-off-by: Yuri Tikhonov <yur@emcraft.com>
 Signed-off-by: Mikhail Cherkashin <mike@emcraft.com>
--
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 9856a91..88f7e06 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3854,6 +3854,14 @@ static void handle_stripe6(struct stripe_head *sh)
 	s.syncing = test_bit(STRIPE_SYNCING, &sh->state);
 	s.expanding = test_bit(STRIPE_EXPAND_SOURCE, &sh->state);
 	s.expanded = test_bit(STRIPE_EXPAND_READY, &sh->state);
+
+	/* clean-up completed biofill operations */
+	if (test_bit(STRIPE_OP_BIOFILL, &sh->ops.complete)) {
+		clear_bit(STRIPE_OP_BIOFILL, &sh->ops.pending);
+		clear_bit(STRIPE_OP_BIOFILL, &sh->ops.ack);
+		clear_bit(STRIPE_OP_BIOFILL, &sh->ops.complete);
+	}
+
 	/* Now to look around and see what can be done */
 
 	rcu_read_lock();
@@ -3866,33 +3874,16 @@ static void handle_stripe6(struct stripe_head *sh)
 		if (test_and_clear_bit(i, sq->overwrite))
 			set_bit(R5_OVERWRITE, &dev->flags);
 
-		pr_debug("check %d: state 0x%lx read %p write %p written %p\n",
-			i, dev->flags, dev_q->toread, dev_q->towrite,
-			dev_q->written);
-		/* maybe we can reply to a read */
-		if (test_bit(R5_UPTODATE, &dev->flags) && dev_q->toread) {
-			struct bio *rbi, *rbi2;
-			pr_debug("Return read for disc %d\n", i);
-			spin_lock_irq(&conf->device_lock);
-			rbi = dev_q->toread;
-			dev_q->toread = NULL;
-			clear_bit(i, sq->to_read);
-			if (test_and_clear_bit(i, sq->overlap))
-				wake_up(&conf->wait_for_overlap);
-			spin_unlock_irq(&conf->device_lock);
-			while (rbi && rbi->bi_sector <
-			       dev_q->sector + STRIPE_SECTORS) {
-				copy_data(0, rbi, dev->page, dev_q->sector);
-				rbi2 = r5_next_bio(rbi, dev_q->sector);
-				spin_lock_irq(&conf->device_lock);
-				if (--rbi->bi_phys_segments == 0) {
-					rbi->bi_next = return_bi;
-					return_bi = rbi;
-				}
-				spin_unlock_irq(&conf->device_lock);
-				rbi = rbi2;
-			}
-		}
+		pr_debug("check %d: state 0x%lx toread %p write %p "
+			"written %p\n",	i, dev->flags, dev_q->toread,
+			dev_q->towrite, dev_q->written);
+		/* maybe we can reply to a read
+		 * new wantfill requests are only permitted while
+		 * STRIPE_OP_BIOFILL is clear
+		 */
+		if (test_bit(R5_UPTODATE, &dev->flags) && dev_q->toread &&
+		    !test_bit(STRIPE_OP_BIOFILL, &sh->ops.pending))
+			set_bit(R5_Wantfill, &dev->flags);
 
 		/* now count some things */
 		if (test_bit(R5_LOCKED, &dev->flags)) s.locked++;
@@ -3925,6 +3916,10 @@ static void handle_stripe6(struct stripe_head *sh)
 			set_bit(R5_Insync, &dev->flags);
 	}
 	rcu_read_unlock();
+
+	if (s.to_fill && !test_and_set_bit(STRIPE_OP_BIOFILL, &sh->ops.pending))
+		sh->ops.count++;
+
 	pr_debug("locked=%d uptodate=%d to_read=%d"
 	       " to_write=%d failed=%d failed_num=%d,%d\n",
 	       s.locked, s.uptodate, s.to_read, s.to_write, s.failed,

-- 
Yuri Tikhonov, Senior Software Engineer
Emcraft Systems, www.emcraft.com
