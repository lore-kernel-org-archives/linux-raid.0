From: NeilBrown <neilb@suse.de>
Subject: [PATCH 020 of 29] md: md: kill STRIPE_OP_IO flag
Date: Fri, 27 Jun 2008 16:51:30 +1000
Message-ID: <1080627065130.10634@suse.de>
References: <20080627164503.9671.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-raid.ids


From: Dan Williams <dan.j.williams@intel.com>

The R5_Want{Read,Write} flags already gate i/o.  So, this flag is
superfluous and we can unconditionally call ops_run_io().

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid5.c         |   32 +++++---------------------------
 ./include/linux/raid/raid5.h |    1 -
 2 files changed, 5 insertions(+), 28 deletions(-)

diff .prev/drivers/md/raid5.c ./drivers/md/raid5.c
--- .prev/drivers/md/raid5.c	2008-06-27 16:22:03.000000000 +1000
+++ ./drivers/md/raid5.c	2008-06-27 16:22:04.000000000 +1000
@@ -373,8 +373,6 @@ static unsigned long get_stripe_work(str
 	test_and_ack_op(STRIPE_OP_BIODRAIN, pending);
 	test_and_ack_op(STRIPE_OP_POSTXOR, pending);
 	test_and_ack_op(STRIPE_OP_CHECK, pending);
-	if (test_and_clear_bit(STRIPE_OP_IO, &sh->ops.pending))
-		ack++;
 
 	sh->ops.count -= ack;
 	if (unlikely(sh->ops.count < 0)) {
@@ -399,7 +397,6 @@ static void ops_run_io(struct stripe_hea
 
 	might_sleep();
 
-	set_bit(STRIPE_IO_STARTED, &sh->state);
 	for (i = disks; i--; ) {
 		int rw;
 		struct bio *bi;
@@ -433,6 +430,8 @@ static void ops_run_io(struct stripe_hea
 				test_bit(STRIPE_EXPAND_READY, &sh->state))
 				md_sync_acct(rdev->bdev, STRIPE_SECTORS);
 
+			set_bit(STRIPE_IO_STARTED, &sh->state);
+
 			bi->bi_bdev = rdev->bdev;
 			pr_debug("%s: for %llu schedule op %ld on disc %d\n",
 				__func__, (unsigned long long)sh->sector,
@@ -900,9 +899,6 @@ static void raid5_run_ops(struct stripe_
 	if (test_bit(STRIPE_OP_CHECK, &pending))
 		ops_run_check(sh);
 
-	if (test_bit(STRIPE_OP_IO, &pending))
-		ops_run_io(sh);
-
 	if (overlap_clear)
 		for (i = disks; i--; ) {
 			struct r5dev *dev = &sh->dev[i];
@@ -2013,8 +2009,6 @@ static int __handle_issuing_new_read_req
 			 */
 			set_bit(R5_LOCKED, &dev->flags);
 			set_bit(R5_Wantread, &dev->flags);
-			if (!test_and_set_bit(STRIPE_OP_IO, &sh->ops.pending))
-				sh->ops.count++;
 			s->locked++;
 			pr_debug("Reading block %d (sync=%d)\n", disk_idx,
 				s->syncing);
@@ -2208,9 +2202,6 @@ static void handle_issuing_new_write_req
 						"%d for r-m-w\n", i);
 					set_bit(R5_LOCKED, &dev->flags);
 					set_bit(R5_Wantread, &dev->flags);
-					if (!test_and_set_bit(
-						STRIPE_OP_IO, &sh->ops.pending))
-						sh->ops.count++;
 					s->locked++;
 				} else {
 					set_bit(STRIPE_DELAYED, &sh->state);
@@ -2234,9 +2225,6 @@ static void handle_issuing_new_write_req
 						"%d for Reconstruct\n", i);
 					set_bit(R5_LOCKED, &dev->flags);
 					set_bit(R5_Wantread, &dev->flags);
-					if (!test_and_set_bit(
-						STRIPE_OP_IO, &sh->ops.pending))
-						sh->ops.count++;
 					s->locked++;
 				} else {
 					set_bit(STRIPE_DELAYED, &sh->state);
@@ -2444,8 +2432,6 @@ static void handle_parity_checks5(raid5_
 
 		set_bit(R5_LOCKED, &dev->flags);
 		set_bit(R5_Wantwrite, &dev->flags);
-		if (!test_and_set_bit(STRIPE_OP_IO, &sh->ops.pending))
-			sh->ops.count++;
 
 		clear_bit(STRIPE_DEGRADED, &sh->state);
 		s->locked++;
@@ -2801,9 +2787,6 @@ static void handle_stripe5(struct stripe
 				(i == sh->pd_idx || dev->written)) {
 				pr_debug("Writing block %d\n", i);
 				set_bit(R5_Wantwrite, &dev->flags);
-				if (!test_and_set_bit(
-				    STRIPE_OP_IO, &sh->ops.pending))
-					sh->ops.count++;
 				if (prexor)
 					continue;
 				if (!test_bit(R5_Insync, &dev->flags) ||
@@ -2857,16 +2840,12 @@ static void handle_stripe5(struct stripe
 		dev = &sh->dev[s.failed_num];
 		if (!test_bit(R5_ReWrite, &dev->flags)) {
 			set_bit(R5_Wantwrite, &dev->flags);
-			if (!test_and_set_bit(STRIPE_OP_IO, &sh->ops.pending))
-				sh->ops.count++;
 			set_bit(R5_ReWrite, &dev->flags);
 			set_bit(R5_LOCKED, &dev->flags);
 			s.locked++;
 		} else {
 			/* let's read it back */
 			set_bit(R5_Wantread, &dev->flags);
-			if (!test_and_set_bit(STRIPE_OP_IO, &sh->ops.pending))
-				sh->ops.count++;
 			set_bit(R5_LOCKED, &dev->flags);
 			s.locked++;
 		}
@@ -2884,13 +2863,10 @@ static void handle_stripe5(struct stripe
 		clear_bit(STRIPE_OP_POSTXOR, &sh->ops.ack);
 		clear_bit(STRIPE_OP_POSTXOR, &sh->ops.complete);
 
-		for (i = conf->raid_disks; i--; ) {
+		for (i = conf->raid_disks; i--; )
 			set_bit(R5_Wantwrite, &sh->dev[i].flags);
 			set_bit(R5_LOCKED, &dev->flags);
 			s.locked++;
-			if (!test_and_set_bit(STRIPE_OP_IO, &sh->ops.pending))
-				sh->ops.count++;
-		}
 	}
 
 	if (s.expanded && test_bit(STRIPE_EXPANDING, &sh->state) &&
@@ -2926,6 +2902,8 @@ static void handle_stripe5(struct stripe
 	if (pending)
 		raid5_run_ops(sh, pending);
 
+	ops_run_io(sh);
+
 	return_io(return_bi);
 
 }

diff .prev/include/linux/raid/raid5.h ./include/linux/raid/raid5.h
--- .prev/include/linux/raid/raid5.h	2008-06-27 16:22:03.000000000 +1000
+++ ./include/linux/raid/raid5.h	2008-06-27 16:22:04.000000000 +1000
@@ -263,7 +263,6 @@ struct r6_state {
 #define STRIPE_OP_BIODRAIN	3
 #define STRIPE_OP_POSTXOR	4
 #define STRIPE_OP_CHECK	5
-#define STRIPE_OP_IO		6
 
 /* modifiers to the base operations
  * STRIPE_OP_MOD_REPAIR_PD - compute the parity block and write it back
