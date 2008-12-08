From: Yuri Tikhonov <yur@emcraft.com>
Subject: [PATCH 07/11] md: rewrite handle_stripe_dirtying6 in asynchronous way
Date: Tue, 9 Dec 2008 00:57:33 +0300
Message-ID: <200812090057.33890.yur@emcraft.com>
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

Rewrite handle_stripe_dirtying6 function to work asynchronously.

Signed-off-by: Yuri Tikhonov <yur@emcraft.com>
Signed-off-by: Ilya Yanok <yanok@emcraft.com>
---
 drivers/md/raid5.c |  113 ++++++++++++++--------------------------------------
 1 files changed, 30 insertions(+), 83 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index e08ed4f..f0b47bd 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2485,99 +2485,46 @@ static void handle_stripe_dirtying6(raid5_conf_t *conf,
 		struct stripe_head *sh,	struct stripe_head_state *s,
 		struct r6_state *r6s, int disks)
 {
-	int rcw = 0, must_compute = 0, pd_idx = sh->pd_idx, i;
+	int rcw = 0, pd_idx = sh->pd_idx, i;
 	int qd_idx = r6s->qd_idx;
+
+	set_bit(STRIPE_HANDLE, &sh->state);
 	for (i = disks; i--; ) {
 		struct r5dev *dev = &sh->dev[i];
-		/* Would I have to read this buffer for reconstruct_write */
-		if (!test_bit(R5_OVERWRITE, &dev->flags)
-		    && i != pd_idx && i != qd_idx
-		    && (!test_bit(R5_LOCKED, &dev->flags)
-			    ) &&
-		    !test_bit(R5_UPTODATE, &dev->flags)) {
-			if (test_bit(R5_Insync, &dev->flags)) rcw++;
-			else {
-				pr_debug("raid6: must_compute: "
-					"disk %d flags=%#lx\n", i, dev->flags);
-				must_compute++;
+		/* check if we haven't enough data */
+		if (!test_bit(R5_OVERWRITE, &dev->flags) &&
+		    i != pd_idx && i != qd_idx &&
+		    !test_bit(R5_LOCKED, &dev->flags) &&
+		    !(test_bit(R5_UPTODATE, &dev->flags) ||
+		      test_bit(R5_Wantcompute, &dev->flags))) {
+			rcw++;
+			if (!test_bit(R5_Insync, &dev->flags))
+				continue; /* it's a failed drive */
+
+			if (
+			  test_bit(STRIPE_PREREAD_ACTIVE, &sh->state)) {
+				pr_debug("Read_old stripe %llu "
+					"block %d for Reconstruct\n",
+				     (unsigned long long)sh->sector, i);
+				set_bit(R5_LOCKED, &dev->flags);
+				set_bit(R5_Wantread, &dev->flags);
+				s->locked++;
+			} else {
+				pr_debug("Request delayed stripe %llu "
+					"block %d for Reconstruct\n",
+				     (unsigned long long)sh->sector, i);
+				set_bit(STRIPE_DELAYED, &sh->state);
+				set_bit(STRIPE_HANDLE, &sh->state);
 			}
 		}
 	}
-	pr_debug("for sector %llu, rcw=%d, must_compute=%d\n",
-	       (unsigned long long)sh->sector, rcw, must_compute);
-	set_bit(STRIPE_HANDLE, &sh->state);
-
-	if (rcw > 0)
-		/* want reconstruct write, but need to get some data */
-		for (i = disks; i--; ) {
-			struct r5dev *dev = &sh->dev[i];
-			if (!test_bit(R5_OVERWRITE, &dev->flags)
-			    && !(s->failed == 0 && (i == pd_idx || i == qd_idx))
-			    && !test_bit(R5_LOCKED, &dev->flags) &&
-			    !test_bit(R5_UPTODATE, &dev->flags) &&
-			    test_bit(R5_Insync, &dev->flags)) {
-				if (
-				  test_bit(STRIPE_PREREAD_ACTIVE, &sh->state)) {
-					pr_debug("Read_old stripe %llu "
-						"block %d for Reconstruct\n",
-					     (unsigned long long)sh->sector, i);
-					set_bit(R5_LOCKED, &dev->flags);
-					set_bit(R5_Wantread, &dev->flags);
-					s->locked++;
-				} else {
-					pr_debug("Request delayed stripe %llu "
-						"block %d for Reconstruct\n",
-					     (unsigned long long)sh->sector, i);
-					set_bit(STRIPE_DELAYED, &sh->state);
-					set_bit(STRIPE_HANDLE, &sh->state);
-				}
-			}
-		}
 	/* now if nothing is locked, and if we have enough data, we can start a
 	 * write request
 	 */
-	if (s->locked == 0 && rcw == 0 &&
+	if ((s->req_compute || !test_bit(STRIPE_COMPUTE_RUN, &sh->state)) &&
+	    s->locked == 0 && rcw == 0 &&
 	    !test_bit(STRIPE_BIT_DELAY, &sh->state)) {
-		if (must_compute > 0) {
-			/* We have failed blocks and need to compute them */
-			switch (s->failed) {
-			case 0:
-				BUG();
-			case 1:
-				compute_block_1(sh, r6s->failed_num[0], 0);
-				break;
-			case 2:
-				compute_block_2(sh, r6s->failed_num[0],
-						r6s->failed_num[1]);
-				break;
-			default: /* This request should have been failed? */
-				BUG();
-			}
-		}
-
-		pr_debug("Computing parity for stripe %llu\n",
-			(unsigned long long)sh->sector);
-		compute_parity6(sh, RECONSTRUCT_WRITE);
-		/* now every locked buffer is ready to be written */
-		for (i = disks; i--; )
-			if (test_bit(R5_LOCKED, &sh->dev[i].flags)) {
-				pr_debug("Writing stripe %llu block %d\n",
-				       (unsigned long long)sh->sector, i);
-				s->locked++;
-				set_bit(R5_Wantwrite, &sh->dev[i].flags);
-			}
-		if (s->locked == disks)
-			if (!test_and_set_bit(STRIPE_FULL_WRITE, &sh->state))
-				atomic_inc(&conf->pending_full_writes);
-		/* after a RECONSTRUCT_WRITE, the stripe MUST be in-sync */
-		set_bit(STRIPE_INSYNC, &sh->state);
-
-		if (test_and_clear_bit(STRIPE_PREREAD_ACTIVE, &sh->state)) {
-			atomic_dec(&conf->preread_active_stripes);
-			if (atomic_read(&conf->preread_active_stripes) <
-			    IO_THRESHOLD)
-				md_wakeup_thread(conf->mddev->thread);
-		}
+		schedule_reconstruction(sh, s, 1, 0);
 	}
 }
 
-- 
1.5.6.1

