From: Yuri Tikhonov <yur@emcraft.com>
Subject: [md-raid6-accel PATCH 09/12] md: req/comp logic for async expand operations
Date: Tue, 4 Dec 2007 14:36:20 +0300
Message-ID: <200712041436.20346.yur@emcraft.com>
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

 Support for expanding RAID-6 stripes asynchronously.

 By setting STRIPE_OP_POSTXOR without setting STRIPE_OP_BIODRAIN the
completion path in handle stripe can differentiate expand operations
from normal write operations.

 Signed-off-by: Yuri Tikhonov <yur@emcraft.com>
 Signed-off-by: Mikhail Cherkashin <mike@emcraft.com>
--
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 88f7e06..9b4db93 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4024,19 +4024,32 @@ static void handle_stripe6(struct stripe_head *sh)
 			}
 		}
 
-	if (s.expanded && test_bit(STRIPE_QUEUE_EXPANDING, &sq->state)) {
+	/* Finish postxor operations initiated by the expansion
+	 * process
+	 */
+	if (test_bit(STRIPE_OP_POSTXOR, &sh->ops.complete) &&
+	    !test_bit(STRIPE_OP_BIODRAIN, &sh->ops.pending)) {
+		clear_bit(STRIPE_QUEUE_EXPANDING, &sq->state);
+		clear_bit(STRIPE_OP_POSTXOR, &sh->ops.pending);
+		clear_bit(STRIPE_OP_POSTXOR, &sh->ops.ack);
+		clear_bit(STRIPE_OP_POSTXOR, &sh->ops.complete);
+
+		for (i = conf->raid_disks; i--;  ) {
+			set_bit(R5_Wantwrite, &sh->dev[i].flags);
+			if (!test_and_set_bit(STRIPE_OP_IO, &sh->ops.pending))
+				sh->ops.count++;
+		}
+	}
+
+	if (s.expanded && test_bit(STRIPE_QUEUE_EXPANDING, &sq->state) &&
+	    !test_bit(STRIPE_OP_POSTXOR, &sh->ops.pending)) {
 		/* Need to write out all blocks after computing P&Q */
 		sq->disks = conf->raid_disks;
 		sq->pd_idx = stripe_to_pdidx(sh->sector, conf,
 					     conf->raid_disks);
-		compute_parity6(sh, RECONSTRUCT_WRITE);
-		for (i = conf->raid_disks ; i-- ;  ) {
-			set_bit(R5_LOCKED, &sh->dev[i].flags);
-			s.locked++;
-			set_bit(R5_Wantwrite, &sh->dev[i].flags);
-		}
-		clear_bit(STRIPE_QUEUE_EXPANDING, &sq->state);
-	} else if (s.expanded) {
+		s.locked += handle_write_operations(sh, 0, 1);
+	} else if (s.expanded &&
+		   !test_bit(STRIPE_OP_POSTXOR, &sh->ops.pending)) {
 		clear_bit(STRIPE_EXPAND_READY, &sh->state);
 		atomic_dec(&conf->reshape_stripes);
 		wake_up(&conf->wait_for_overlap);

-- 
Yuri Tikhonov, Senior Software Engineer
Emcraft Systems, www.emcraft.com
